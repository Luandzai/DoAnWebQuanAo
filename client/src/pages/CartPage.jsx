// client/src/pages/CartPage.jsx (ĐÃ SỬA LỖI)

import React, { useContext } from "react";
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
  const { cartItems, updateCartQuantity, removeFromCart, loading } =
    useContext(CartContext);
  const navigate = useNavigate();

  // Tính tổng tiền
  const subtotal = cartItems.reduce(
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
            <ListGroup variant="flush">
              {cartItems.map((item) => (
                <ListGroup.Item
                  key={item.PhienBanID}
                  className="mb-3 p-3 shadow-sm"
                >
                  <Row className="align-items-center">
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
                      <p className="text-muted small mb-0">{item.ThuocTinh}</p>
                    </Col>
                    <Col md={2}>
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
          )}
        </Col>

        {/* CỘT PHẢI: TÓM TẮT ĐƠN HÀNG */}
        <Col md={4}>
          <Card className="shadow-sm">
            <Card.Body>
              <Card.Title className="fs-4">Tổng giá trị đơn hàng</Card.Title>
              <ListGroup variant="flush" className="my-3">
                <ListGroup.Item className="d-flex justify-content-between">
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
                disabled={cartItems.length === 0}
                onClick={() => navigate("/checkout")}
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
