// client/src/pages/CartPage.jsx (ĐÃ SỬA LỖI)

import React, { useContext, useState, useEffect } from "react";
import {
  Container,
  Row,
  Col,
  ListGroup,
  Image,
  Button,
  Card,
  Form,
  InputGroup, // <-- LỖI LÀ DO THIẾU DÒNG NÀY
  Alert, // Thêm Alert
  Spinner, // Thêm Spinner
} from "react-bootstrap";
import { Link, useNavigate } from "react-router-dom";
import CartContext from "../context/CartContext";
import { X } from "react-bootstrap-icons";

const CartPage = () => {
  const {
    cartItems,
    updateCartQuantity,
    removeFromCart,
    loading,
    selectItemsForCheckout, // <-- Lấy hàm mới từ context
  } = useContext(CartContext);
  const navigate = useNavigate();

  // State mới để quản lý các item được chọn (lưu PhienBanID)
  const [selectedItems, setSelectedItems] = useState([]);

  // Cập nhật danh sách item được chọn khi giỏ hàng thay đổi
  useEffect(() => {
    // Mặc định chọn tất cả khi tải trang
    setSelectedItems(cartItems.map((item) => item.PhienBanID));
  }, [cartItems]);

  // Lọc ra các object item đầy đủ dựa trên ID đã chọn
  const itemsToCheckout = cartItems.filter((item) =>
    selectedItems.includes(item.PhienBanID)
  );

  // Tính tổng tiền chỉ cho các sản phẩm được chọn
  const subtotal = itemsToCheckout.reduce(
    (acc, item) => acc + item.SoLuong * parseFloat(item.GiaBan),
    0
  );

  // Hàm xử lý +/-
  const handleQuantityChange = (item, newQty) => {
    if (newQty > 0) {
      updateCartQuantity(item.PhienBanID, newQty);
    } else if (newQty === 0) {
      // Nếu giảm về 0, thì xóa
      removeFromCart(item.PhienBanID);
    }
  };

  // Hàm xử lý khi check/uncheck một item
  const handleSelectItem = (phienBanID) => {
    setSelectedItems(
      (prev) =>
        prev.includes(phienBanID)
          ? prev.filter((id) => id !== phienBanID) // Bỏ chọn
          : [...prev, phienBanID] // Chọn
    );
  };

  // Hàm xử lý khi check/uncheck "Chọn tất cả"
  const handleSelectAll = (e) => {
    if (e.target.checked) {
      setSelectedItems(cartItems.map((item) => item.PhienBanID));
    } else {
      setSelectedItems([]);
    }
  };

  // Hàm xử lý khi nhấn nút "Tiến hành đặt hàng"
  const handleCheckout = () => {
    selectItemsForCheckout(itemsToCheckout); // <-- Gửi các item đã chọn vào context
    navigate("/checkout");
  };

  if (loading) {
    return (
      <Container fluid className="py-5 text-center">
        <Spinner animation="border" />
      </Container>
    );
  }

  return (
    <Container fluid className="py-5">
      <h2 className="mb-4">Giỏ hàng của bạn</h2>
      <Row>
        {/* CỘT TRÁI: DANH SÁCH SẢN PHẨM */}
        <Col md={8}>
          {cartItems.length === 0 ? (
            <Alert variant="info">
              Giỏ hàng của bạn đang trống. <Link to="/">Quay lại mua sắm</Link>
            </Alert>
          ) : (
            <>
              {/* === THANH CHỌN TẤT CẢ === */}
              <div className="d-flex justify-content-between align-items-center p-3 mb-3 bg-light rounded">
                <Form.Check
                  type="checkbox"
                  id="select-all"
                  label={`Chọn tất cả (${cartItems.length} sản phẩm)`}
                  checked={selectedItems.length === cartItems.length}
                  onChange={handleSelectAll}
                />
              </div>
              {/* ========================== */}

              <ListGroup variant="flush">
                {cartItems.map((item) => (
                  <ListGroup.Item
                    key={item.PhienBanID}
                    className="mb-3 p-3 shadow-sm"
                  >
                    <Row className="align-items-center">
                      <Col xs="auto">
                        <Form.Check
                          type="checkbox"
                          checked={selectedItems.includes(item.PhienBanID)}
                          onChange={() => handleSelectItem(item.PhienBanID)}
                        />
                      </Col>
                      <Col md={2}>
                        <Image
                          src={item.HinhAnh}
                          alt={item.TenSanPham}
                          fluid
                          rounded
                        />
                      </Col>
                      <Col md={4}>
                        <h5>{item.TenSanPham}</h5>
                        <p className="text-muted small mb-0">
                          {item.ThuocTinh}
                        </p>
                      </Col>
                      <Col md={1}>
                        <strong>
                          {parseFloat(item.GiaBan).toLocaleString("vi-VN")} ₫
                        </strong>
                      </Col>
                      <Col md={2}>
                        {/* Bộ chọn số lượng */}
                        <InputGroup size="sm" style={{ maxWidth: "100px" }}>
                          <Button
                            variant="outline-secondary"
                            onClick={() =>
                              handleQuantityChange(item, item.SoLuong - 1)
                            }
                          >
                            -
                          </Button>
                          <Form.Control
                            type="text"
                            value={item.SoLuong}
                            readOnly
                            className="text-center"
                          />
                          <Button
                            variant="outline-secondary"
                            onClick={() =>
                              handleQuantityChange(item, item.SoLuong + 1)
                            }
                          >
                            +
                          </Button>
                        </InputGroup>
                      </Col>
                      <Col md={2} className="text-end">
                        <Button
                          variant="danger"
                          size="sm"
                          onClick={() => removeFromCart(item.PhienBanID)}
                        >
                          <X size={20} />
                        </Button>
                      </Col>
                    </Row>
                  </ListGroup.Item>
                ))}
              </ListGroup>
            </>
          )}
        </Col>

        {/* CỘT PHẢI: TÓM TẮT ĐƠN HÀNG */}
        <Col md={4}>
          <Card className="shadow-sm">
            <Card.Body>
              <Card.Title className="fs-4">Tổng giá trị đơn hàng</Card.Title>
              <ListGroup variant="flush" className="my-3">
                <ListGroup.Item className="d-flex justify-content-between align-items-center">
                  <span>Tạm tính:</span>
                  <strong>{subtotal.toLocaleString("vi-VN")} ₫</strong>
                </ListGroup.Item>
                <ListGroup.Item className="d-flex justify-content-between fs-5">
                  <strong>Tổng cộng:</strong>
                  <strong className="text-danger">
                    {subtotal.toLocaleString("vi-VN")} ₫
                  </strong>
                </ListGroup.Item>
              </ListGroup>
              <Button
                variant="primary"
                className="w-100"
                size="lg"
                disabled={itemsToCheckout.length === 0} // <-- Disable nếu không có item nào được chọn
                onClick={handleCheckout} // <-- Gọi hàm checkout mới
              >
                Tiến hành Đặt hàng
              </Button>
            </Card.Body>
          </Card>
        </Col>
      </Row>
    </Container>
  );
};

export default CartPage;
