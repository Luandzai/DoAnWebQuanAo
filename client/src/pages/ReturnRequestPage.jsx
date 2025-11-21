// client/src/pages/ReturnRequestPage.jsx (Đã sửa lỗi Race Condition)

import React, { useState, useEffect, useContext } from "react";
import { useParams, useNavigate } from "react-router-dom";
import {
  Container,
  Row,
  Col,
  Form,
  Button,
  Spinner,
  Alert,
  ListGroup,
  Image,
} from "react-bootstrap";
import AuthContext from "../context/AuthContext";
import { toast } from "react-toastify"; // Import toast

const ReturnRequestPage = () => {
  const { orderId } = useParams();
  const navigate = useNavigate();
  const { api } = useContext(AuthContext);

  const [order, setOrder] = useState(null);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);

  const [reason, setReason] = useState("");
  const [itemsToReturn, setItemsToReturn] = useState({});

  // 1. Tải thông tin đơn hàng
  useEffect(() => {
    const fetchOrderDetails = async () => {
      try {
        const { data } = await api.get(`/orders/${orderId}`);
        setOrder(data);
      } catch (err) {
        setError(`Không thể tải chi tiết đơn hàng: ${err.message}`);
      } finally {
        setLoading(false);
      }
    };
    fetchOrderDetails();
  }, [api, orderId]);

  // 2. Hàm xử lý khi thay đổi số lượng trả
  const handleQuantityChange = (phienBanID, maxSoLuong, value) => {
    const qty = parseInt(value) || 0;
    if (qty >= 0 && qty <= maxSoLuong) {
      setItemsToReturn({
        ...itemsToReturn,
        [phienBanID]: qty,
      });
    }
  };

  // 3. Hàm Gửi Yêu Cầu (Đã sửa logic)
  const submitHandler = async (e) => {
    e.preventDefault();
    setLoading(true);
    setError(null);

    const itemsArray = Object.keys(itemsToReturn)
      .filter((id) => itemsToReturn[id] > 0)
      .map((id) => {
        const itemDetail = order.items.find((i) => i.PhienBanID == id);
        return {
          PhienBanID: parseInt(id), // Đảm bảo là số
          SoLuongTra: itemsToReturn[id],
          GiaHoanTra: itemDetail.GiaLucMua,
        };
      });

    if (itemsArray.length === 0) {
      setError("Bạn chưa chọn sản phẩm nào để trả.");
      setLoading(false);
      return;
    }
    if (!reason.trim()) {
      setError("Vui lòng nhập lý do đổi/trả.");
      setLoading(false);
      return;
    }

    let isSuccess = false; // Dùng cờ (flag)
    try {
      // Gọi API POST /api/returns
      await api.post("/returns", {
        DonHangID: orderId,
        Reason: reason,
        items: itemsArray,
      });

      isSuccess = true; // Đánh dấu là thành công
    } catch (err) {
      setError(err.response?.data?.message || "Gửi yêu cầu thất bại.");
    } finally {
      setLoading(false);
    }

    // Chỉ chuyển trang và báo thành công NẾU cờ là true
    if (isSuccess) {
      toast.success("Gửi yêu cầu thành công!");
      navigate("/profile/returns"); // Chuyển về trang danh sách đổi trả
    }
  };

  if (loading && !order) {
    // Sửa lại logic loading
    return (
      <div className="text-center py-5">
        <Spinner animation="border" />
      </div>
    );
  }

  if (error && !order) {
    // Sửa lại logic error
    return (
      <Container className="py-5">
        <Alert variant="danger">{error}</Alert>
      </Container>
    );
  }

  if (!order) {
    return null;
  } // Tránh lỗi render

  return (
    <Container fluid className="py-5">
      <Row className="justify-content-center">
        <Col md={8}>
          <h2 className="mb-4">Yêu cầu Đổi/Trả hàng</h2>
          <h5>Đơn hàng: ORD_{order.DonHangID}</h5>
          <p>Chọn sản phẩm và số lượng bạn muốn trả:</p>

          <Form onSubmit={submitHandler}>
            <ListGroup variant="flush" className="mb-3">
              {order.items.map((item) => (
                <ListGroup.Item
                  key={item.PhienBanID}
                  className="d-flex align-items-center"
                >
                  <Image
                    src={item.HinhAnh}
                    style={{ width: "60px" }}
                    className="me-3"
                  />
                  <div className="flex-grow-1">
                    <strong>{item.TenSanPham}</strong>
                    <div className="text-muted small">{item.ThuocTinh}</div>
                  </div>
                  <Form.Control
                    type="number"
                    style={{ width: "80px" }}
                    min={0}
                    max={item.SoLuong}
                    value={itemsToReturn[item.PhienBanID] || 0}
                    onChange={(e) =>
                      handleQuantityChange(
                        item.PhienBanID,
                        item.SoLuong,
                        e.target.value
                      )
                    }
                  />
                  <span className="ms-2">/ {item.SoLuong}</span>
                </ListGroup.Item>
              ))}
            </ListGroup>

            <Form.Group className="mb-3">
              <Form.Label className="fw-bold">Lý do đổi/trả:</Form.Label>
              <Form.Control
                as="textarea"
                rows={3}
                value={reason}
                onChange={(e) => setReason(e.target.value)}
                required
                placeholder="Ví dụ: Sản phẩm bị lỗi, sai kích thước..."
              />
            </Form.Group>

            {error && <Alert variant="danger">{error}</Alert>}

            <Button type="submit" variant="primary" disabled={loading}>
              {loading ? "Đang gửi..." : "Gửi Yêu Cầu"}
            </Button>
          </Form>
        </Col>
      </Row>
    </Container>
  );
};
export default ReturnRequestPage;
