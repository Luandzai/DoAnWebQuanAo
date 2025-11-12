// client/src/pages/CheckoutPage.jsx (Nâng cấp Mã Giảm Giá thành Dropdown)

import React, { useState, useEffect, useContext } from "react";
import {
  Container,
  Row,
  Col,
  Form,
  Button,
  Card,
  ListGroup,
  Image,
  Alert,
  Spinner,
  InputGroup,
} from "react-bootstrap";
import { useNavigate } from "react-router-dom";
import AuthContext from "../context/AuthContext";
import CartContext from "../context/CartContext";
import OrderSuccessModal from "../components/OrderSuccessModal";
import { toast } from "react-toastify";

// Import CSS cho Phương thức thanh toán
import "./CheckoutPage.css";
import {
  Bank,
  CreditCard2FrontFill,
  CashCoin,
  Paypal,
} from "react-bootstrap-icons";

// Mảng layout cho PT Thanh toán
const paymentOptions = [
  {
    id: "701",
    name: "Thanh toán khi nhận hàng (COD)",
    description: "Nhận, kiểm tra rồi thanh toán",
    icon: <CashCoin />,
  },
  {
    id: "702",
    name: "VNPAY",
    description: "Thanh toán qua VNPAY (Thẻ/QR)",
    icon: <CreditCard2FrontFill />,
  },
  {
    id: "703",
    name: "Ví MoMo",
    description: "Thanh toán qua ví điện tử MoMo",
    icon: <Paypal />,
  },
  {
    id: "704",
    name: "Tài khoản ngân hàng",
    description: "Chuyển khoản trực tiếp",
    icon: <Bank />,
  },
];

const CheckoutPage = () => {
  const navigate = useNavigate();
  const { user, api } = useContext(AuthContext);
  const {
    cartItems,
    clearCart,
    loading: cartLoading,
  } = useContext(CartContext);

  // === State Địa chỉ ===
  const [shippingInfo, setShippingInfo] = useState({
    TenNguoiNhan: user?.hoTen || "",
    Email: user?.email || "",
    DienThoaiNhan: user?.dienThoai || "",
    SoNha: "", // Ô mới: Số nhà, tên đường
    PhuongXa: "",
    QuanHuyen: "",
    TinhThanh: "",
  });
  const [provinces, setProvinces] = useState([]);
  const [districts, setDistricts] = useState([]);
  const [wards, setWards] = useState([]);
  const [selectedProvinceId, setSelectedProvinceId] = useState("");
  const [selectedDistrictId, setSelectedDistrictId] = useState("");
  const [selectedWardCode, setSelectedWardCode] = useState("");

  // === State Vận chuyển ===
  const [shippingOptions, setShippingOptions] = useState([]);
  const [selectedShipping, setSelectedShipping] = useState(null);

  // === State Thanh toán ===
  const [paymentMethod, setPaymentMethod] = useState("701");
  const [notes, setNotes] = useState("");

  // === CẬP NHẬT STATE VOUCHER ===
  const [myVouchers, setMyVouchers] = useState([]); // State mới để lưu voucher của user
  const [myVouchersLoading, setMyVouchersLoading] = useState(true);
  const [selectedVoucherCode, setSelectedVoucherCode] = useState(""); // State mới cho dropdown

  const [discountAmount, setDiscountAmount] = useState(0);
  const [voucherError, setVoucherError] = useState("");
  // const [voucherLoading, setVoucherLoading] = useState(false); // Không cần nút "Áp dụng" nữa

  // === State Logic ===
  const [error, setError] = useState("");
  const [loading, setLoading] = useState(false);
  const [showSuccessModal, setShowSuccessModal] = useState(false);

  // === TẢI TẤT CẢ DỮ LIỆU CẦN THIẾT KHI VÀO TRANG ===
  useEffect(() => {
    // 1. Điền thông tin user
    if (user) {
      setShippingInfo((prev) => ({
        ...prev,
        TenNguoiNhan: user.hoTen || "",
        Email: user.email || "",
        DienThoaiNhan: user.dienThoai || "",
      }));
    }

    // 2. Tải PTVC
    const fetchShippingOptions = async () => {
      try {
        const { data } = await api.get("/shipping");
        setShippingOptions(data);
        if (data.length > 0) setSelectedShipping(data[0]);
      } catch (err) {
        console.error("Lỗi tải PTVC", err);
      }
    };

    // 3. Tải Tỉnh/Thành
    const fetchProvinces = async () => {
      try {
        const { data } = await api.get("/locations/provinces");
        setProvinces(data || []);
      } catch (err) {
        console.error("Lỗi tải Tỉnh/Thành", err);
      }
    };

    // 4. Tải Voucher của User
    const fetchMyApplicableVouchers = async () => {
      // Chỉ tải nếu đã đăng nhập và giỏ hàng có sản phẩm
      if (!user || cartItems.length === 0) {
        setMyVouchersLoading(false);
        return;
      }
      try {
        setMyVouchersLoading(true);
        // Gọi API mới, gửi kèm cartItems để backend lọc
        const { data } = await api.post("/user/my-applicable-vouchers", {
          cartItems: cartItems,
        });
        setMyVouchers(data || []);
      } catch (err) {
        console.error("Lỗi tải voucher có thể áp dụng:", err);
        setMyVouchers([]); // Đặt lại voucher nếu có lỗi
      } finally {
        setMyVouchersLoading(false);
      }
    };

    fetchShippingOptions();
    fetchProvinces();
    fetchMyApplicableVouchers();
  }, [user, api, cartItems]); // Thêm cartItems vào dependency array

  // (useEffect Tải Quận/Huyện - giữ nguyên)
  useEffect(() => {
    if (!selectedProvinceId) {
      setDistricts([]);
      setWards([]);
      return;
    }
    const fetchDistricts = async () => {
      try {
        const { data } = await api.get(
          `/locations/districts?province_id=${selectedProvinceId}`
        );
        setDistricts(data || []);
      } catch (err) {
        console.error("Lỗi tải Quận/Huyện", err);
      }
    };
    fetchDistricts();
    const provinceName =
      provinces.find((p) => p.ProvinceID == selectedProvinceId)?.ProvinceName ||
      "";
    setShippingInfo((prev) => ({
      ...prev,
      TinhThanh: provinceName,
      QuanHuyen: "",
      PhuongXa: "",
    }));
    setSelectedDistrictId("");
    setSelectedWardCode("");
  }, [selectedProvinceId, api, provinces]);

  // (useEffect Tải Phường/Xã - giữ nguyên)
  useEffect(() => {
    if (!selectedDistrictId) {
      setWards([]);
      return;
    }
    const fetchWards = async () => {
      try {
        const { data } = await api.get(
          `/locations/wards?district_id=${selectedDistrictId}`
        );
        setWards(data || []);
      } catch (err) {
        console.error("Lỗi tải Phường/Xã", err);
      }
    };
    fetchWards();
    const districtName =
      districts.find((d) => d.DistrictID == selectedDistrictId)?.DistrictName ||
      "";
    setShippingInfo((prev) => ({
      ...prev,
      QuanHuyen: districtName,
      PhuongXa: "",
    }));
    setSelectedWardCode("");
  }, [selectedDistrictId, api, districts]);

  // (Tính toán Tạm tính)
  const subtotal = cartItems.reduce(
    (acc, item) => acc + item.SoLuong * parseFloat(item.GiaBan),
    0
  );

  // === CẬP NHẬT LOGIC VOUCHER ===
  // useEffect này sẽ tự động tính toán lại giảm giá khi
  // 1. User chọn 1 voucher
  // 2. Tạm tính (subtotal) thay đổi
  useEffect(() => {
    if (!selectedVoucherCode) {
      // Nếu chọn "-- Chọn mã --"
      setDiscountAmount(0);
      setVoucherError("");
      return;
    }

    const voucher = myVouchers.find(
      (v) => v.MaKhuyenMai === selectedVoucherCode
    );
    if (!voucher) return; // Không tìm thấy voucher

    // Kiểm tra điều kiện
    if (voucher.ApDungToiThieu > subtotal) {
      setDiscountAmount(0);
      setVoucherError(
        `Đơn hàng phải từ ${parseFloat(voucher.ApDungToiThieu).toLocaleString(
          "vi-VN"
        )} ₫`
      );
      return;
    }

    // Hợp lệ -> Tính toán
    setVoucherError("");
    let giamGia = 0;
    if (voucher.LoaiGiamGia === "SOTIEN") {
      giamGia = parseFloat(voucher.GiaTriGiam);
    }
    if (voucher.LoaiGiamGia === "PHANTRAM") {
      giamGia = (subtotal * parseFloat(voucher.GiaTriGiam)) / 100;
    }
    setDiscountAmount(giamGia);
  }, [selectedVoucherCode, myVouchers, subtotal]);
  // ============================

  const shippingFee = selectedShipping
    ? parseFloat(selectedShipping.PhiCoDinh)
    : 0;
  // Tổng tiền = Tạm tính + Phí VC - Giảm giá
  const total = subtotal + shippingFee - discountAmount;

  const handleInputChange = (e) => {
    setShippingInfo({
      ...shippingInfo,
      [e.target.name]: e.target.value,
    });
  };

  const handleWardChange = (e) => {
    const wardCode = e.target.value;
    setSelectedWardCode(wardCode);
    const wardName = wards.find((w) => w.WardCode === wardCode)?.WardName || "";
    setShippingInfo((prev) => ({ ...prev, PhuongXa: wardName }));
  };

  // (Hàm applyVoucherHandler ĐÃ BỊ XÓA, không cần nữa)

  // Hàm ĐẶT HÀNG (CẬP NHẬT)
  const placeOrderHandler = async () => {
    setLoading(true);
    setError("");

    if (
      !shippingInfo.TenNguoiNhan ||
      !shippingInfo.DienThoaiNhan ||
      !shippingInfo.SoNha ||
      !shippingInfo.PhuongXa ||
      !shippingInfo.QuanHuyen ||
      !shippingInfo.TinhThanh
    ) {
      setError(
        "Vui lòng điền đầy đủ thông tin giao hàng (Tỉnh/Huyện/Xã và Số nhà)."
      );
      setLoading(false);
      return;
    }

    try {
      await api.post("/orders", {
        shippingInfo: shippingInfo,
        paymentMethodId: paymentMethod,
        notes: notes,
        cartItems: cartItems,
        PhuongThucID: selectedShipping.PhuongThucID,
        MaKhuyenMai: selectedVoucherCode || null, // Gửi mã đã chọn từ dropdown
      });

      clearCart();
      setShowSuccessModal(true);
    } catch (err) {
      setError(err.response?.data?.message || "Đặt hàng thất bại.");
    } finally {
      setLoading(false);
    }
  };

  if (cartLoading) {
    return (
      <div className="text-center py-5">
        <Spinner animation="border" />
      </div>
    );
  }

  return (
    <Container fluid className="py-5">
      <Row>
        {/* CỘT TRÁI: TÓM TẮT ĐƠN HÀNG (CẬP NHẬT) */}
        <Col md={5}>
          <Card className="shadow-sm mb-3">
            <Card.Header as="h5">Tóm tắt đơn hàng</Card.Header>
            <ListGroup
              variant="flush"
              style={{ maxHeight: "400px", overflowY: "auto" }}
            >
              {cartItems.map((item) => (
                <ListGroup.Item key={item.PhienBanID}>
                  <Row className="align-items-center">
                    <Col xs={3}>
                      <Image src={item.HinhAnh} fluid thumbnail />
                    </Col>
                    <Col xs={9}>
                      <p className="mb-0 fw-bold">{item.TenSanPham}</p>
                      <small className="text-muted">{item.ThuocTinh}</small>
                      <p className="mb-0">
                        {item.SoLuong} x{" "}
                        {parseFloat(item.GiaBan).toLocaleString("vi-VN")} ₫
                      </p>
                    </Col>
                  </Row>
                </ListGroup.Item>
              ))}
            </ListGroup>
          </Card>
          <Card className="shadow-sm">
            <Card.Body>
              {/* === THAY THẾ Ô NHẬP BẰNG DROPDOWN === */}
              <Form.Group className="mb-3">
                <Form.Label className="fw-bold">Mã giảm giá</Form.Label>
                <Form.Select
                  value={selectedVoucherCode}
                  onChange={(e) => setSelectedVoucherCode(e.target.value)}
                  disabled={myVouchersLoading || myVouchers.length === 0}
                >
                  <option value="">
                    {myVouchersLoading
                      ? "Đang tải voucher..."
                      : myVouchers.length === 0
                      ? "Bạn không có voucher nào"
                      : "-- Chọn mã khuyến mãi --"}
                  </option>
                  {myVouchers.map((v) => (
                    <option key={v.MaKhuyenMai} value={v.MaKhuyenMai}>
                      {v.TenKhuyenMai} (Mã: {v.MaKhuyenMai})
                    </option>
                  ))}
                </Form.Select>
                {voucherError && (
                  <small className="text-danger">{voucherError}</small>
                )}
              </Form.Group>

              <ListGroup variant="flush">
                <ListGroup.Item className="d-flex justify-content-between">
                  <span>Tạm tính:</span>
                  <strong>{subtotal.toLocaleString("vi-VN")} ₫</strong>
                </ListGroup.Item>
                <ListGroup.Item className="d-flex justify-content-between">
                  <span>Phí vận chuyển:</span>
                  <strong>{shippingFee.toLocaleString("vi-VN")} ₫</strong>
                </ListGroup.Item>
                {discountAmount > 0 && (
                  <ListGroup.Item className="d-flex justify-content-between text-success">
                    <span>Tiền khuyến mãi:</span>
                    <strong>
                      - {discountAmount.toLocaleString("vi-VN")} ₫
                    </strong>
                  </ListGroup.Item>
                )}
                <ListGroup.Item className="d-flex justify-content-between fs-5">
                  <strong>Tổng cộng:</strong>
                  <strong className="text-danger">
                    {total.toLocaleString("vi-VN")} ₫
                  </strong>
                </ListGroup.Item>
              </ListGroup>
            </Card.Body>
          </Card>
        </Col>

        {/* CỘT PHẢI: FORM THANH TOÁN (Giữ nguyên) */}
        <Col md={7}>
          {error && <Alert variant="danger">{error}</Alert>}

          {/* Card Thông tin giao hàng (với 3 dropdown) */}
          <Card className="shadow-sm mb-3">
            <Card.Header as="h5">1. Thông tin giao hàng</Card.Header>
            <Card.Body>
              <Form>
                <Form.Group className="mb-3">
                  <Form.Label>Họ và tên</Form.Label>
                  <Form.Control
                    type="text"
                    name="TenNguoiNhan"
                    value={shippingInfo.TenNguoiNhan}
                    onChange={handleInputChange}
                  />
                </Form.Group>
                <Row>
                  <Col md={6}>
                    <Form.Group className="mb-3">
                      <Form.Label>Email</Form.Label>
                      <Form.Control
                        type="email"
                        name="Email"
                        value={shippingInfo.Email}
                        onChange={handleInputChange}
                      />
                    </Form.Group>
                  </Col>
                  <Col md={6}>
                    <Form.Group className="mb-3">
                      <Form.Label>Số điện thoại</Form.Label>
                      <Form.Control
                        type="text"
                        name="DienThoaiNhan"
                        value={shippingInfo.DienThoaiNhan}
                        onChange={handleInputChange}
                      />
                    </Form.Group>
                  </Col>
                </Row>

                <Row>
                  <Col md={4}>
                    <Form.Group className="mb-3">
                      <Form.Label>Tỉnh/Thành phố</Form.Label>
                      <Form.Select
                        value={selectedProvinceId}
                        onChange={(e) => setSelectedProvinceId(e.target.value)}
                      >
                        <option value="">Chọn Tỉnh/Thành</option>
                        {provinces.map((p) => (
                          <option key={p.ProvinceID} value={p.ProvinceID}>
                            {p.ProvinceName}
                          </option>
                        ))}
                      </Form.Select>
                    </Form.Group>
                  </Col>
                  <Col md={4}>
                    <Form.Group className="mb-3">
                      <Form.Label>Quận/Huyện</Form.Label>
                      <Form.Select
                        value={selectedDistrictId}
                        onChange={(e) => setSelectedDistrictId(e.target.value)}
                        disabled={districts.length === 0}
                      >
                        <option value="">Chọn Quận/Huyện</option>
                        {districts.map((d) => (
                          <option key={d.DistrictID} value={d.DistrictID}>
                            {d.DistrictName}
                          </option>
                        ))}
                      </Form.Select>
                    </Form.Group>
                  </Col>
                  <Col md={4}>
                    <Form.Group className="mb-3">
                      <Form.Label>Phường/Xã</Form.Label>
                      <Form.Select
                        value={selectedWardCode}
                        onChange={handleWardChange}
                        disabled={wards.length === 0}
                      >
                        <option value="">Chọn Phường/Xã</option>
                        {wards.map((w) => (
                          <option key={w.WardCode} value={w.WardCode}>
                            {w.WardName}
                          </option>
                        ))}
                      </Form.Select>
                    </Form.Group>
                  </Col>
                </Row>

                <Form.Group className="mb-3">
                  <Form.Label>Số nhà, tên đường</Form.Label>
                  <Form.Control
                    type="text"
                    name="SoNha"
                    value={shippingInfo.SoNha}
                    onChange={handleInputChange}
                    placeholder="Ví dụ: 123 Nguyễn Văn Cừ"
                  />
                </Form.Group>

                <Form.Group className="mb-3">
                  <Form.Label>Ghi chú</Form.Label>
                  <Form.Control
                    as="textarea"
                    rows={2}
                    value={notes}
                    onChange={(e) => setNotes(e.target.value)}
                  />
                </Form.Group>
              </Form>
            </Card.Body>
          </Card>

          {/* Card PTVC (đã nâng cấp) */}
          <Card className="shadow-sm mb-3">
            <Card.Header as="h5">2. Phương thức vận chuyển</Card.Header>
            <Card.Body>
              {shippingOptions.length > 0 ? (
                shippingOptions.map((method) => (
                  <Form.Check
                    key={method.PhuongThucID}
                    type="radio"
                    id={`shipping-${method.PhuongThucID}`}
                    label={`${method.TenPhuongThuc} (${parseFloat(
                      method.PhiCoDinh
                    ).toLocaleString("vi-VN")} ₫)`}
                    value={method.PhuongThucID}
                    checked={
                      selectedShipping?.PhuongThucID === method.PhuongThucID
                    }
                    onChange={() => setSelectedShipping(method)}
                  />
                ))
              ) : (
                <p>Đang tải các phương thức vận chuyển...</p>
              )}
            </Card.Body>
          </Card>

          {/* Card Thanh toán (Giao diện thẻ) */}
          <Card className="shadow-sm mb-3">
            <Card.Header as="h5">3. Phương thức thanh toán</Card.Header>
            <Card.Body>
              {paymentOptions.map((option) => (
                <div
                  key={option.id}
                  className={`payment-method-card ${
                    paymentMethod === option.id ? "active" : ""
                  }`}
                  onClick={() => setPaymentMethod(option.id)}
                >
                  <div className="payment-radio"></div>
                  <div className="payment-method-info">
                    <strong>{option.name}</strong>
                    <small>{option.description}</small>
                  </div>
                  <div className="payment-method-logos">{option.icon}</div>
                </div>
              ))}
            </Card.Body>
          </Card>

          <div className="d-flex justify-content-between align-items-center">
            <Button variant="link" onClick={() => navigate("/cart")}>
              Quay lại giỏ hàng
            </Button>
            <Button
              variant="primary"
              size="lg"
              onClick={placeOrderHandler}
              disabled={loading || cartItems.length === 0}
            >
              {loading ? (
                <Spinner as="span" animation="border" size="sm" />
              ) : (
                "Hoàn tất Đặt hàng"
              )}
            </Button>
          </div>
        </Col>
      </Row>

      {/* Modal Success (giữ nguyên) */}
      <OrderSuccessModal
        show={showSuccessModal}
        onHide={() => setShowSuccessModal(false)}
      />
    </Container>
  );
};

export default CheckoutPage;
