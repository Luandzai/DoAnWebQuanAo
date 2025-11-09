// client/src/components/UserOrders.jsx (ĐÃ NÂNG CẤP ĐÁNH GIÁ)

import React, { useState, useEffect, useContext } from "react";
import {
  Card,
  Spinner,
  Alert,
  ListGroup,
  Image,
  Button,
  Modal, // <--- Đã có
  Row,
  Col,
  Badge,
} from "react-bootstrap";
import AuthContext from "../context/AuthContext";
import { toast } from "react-toastify";
import { Link } from "react-router-dom";
import ProductReviewModal from "./ProductReviewModal"; // <-- 1. IMPORT MODAL MỚI

const UserOrders = () => {
  const [orders, setOrders] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);
  const { api, user } = useContext(AuthContext);

  const [showDetailModal, setShowDetailModal] = useState(false);
  const [selectedOrder, setSelectedOrder] = useState(null);
  const [detailLoading, setDetailLoading] = useState(false);

  const [showConfirmModal, setShowConfirmModal] = useState(false);
  const [orderToCancel, setOrderToCancel] = useState(null);
  const [cancellingOrder, setCancellingOrder] = useState(null);

  // === 2. THÊM STATE MỚI CHO REVIEW MODAL ===
  const [showReviewModal, setShowReviewModal] = useState(false);
  const [productToReview, setProductToReview] = useState(null);
  // ===========================================

  // Hàm tải dữ liệu (sẽ gọi API đã nâng cấp)
  const fetchOrders = async () => {
    setLoading(true);
    setError(null);
    try {
      const { data } = await api.get("/orders");
      // 'data.items' giờ đã chứa { ..., DaDanhGia: 1 }
      setOrders(data);
    } catch (err) {
      setError("Không thể tải danh sách đơn hàng.");
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
    fetchOrders();
  }, [api]);

  const handleShowDetails = async (orderId) => {
    setShowDetailModal(true);
    setDetailLoading(true);
    try {
      const { data } = await api.get(`/orders/${orderId}`);
      setSelectedOrder(data);
    } catch (err) {
      console.error(err);
    } finally {
      setDetailLoading(false);
    }
  };
  const handleCloseDetailModal = () => setShowDetailModal(false);

  const handleCancelOrder = (orderId) => {
    setOrderToCancel(orderId);
    setShowConfirmModal(true);
  };
  const handleCloseConfirmModal = () => {
    setShowConfirmModal(false);
    setOrderToCancel(null);
  };

  // Hàm Hủy đơn
  const confirmCancel = async () => {
    if (!orderToCancel) return;
    setCancellingOrder(orderToCancel);
    handleCloseConfirmModal();
    try {
      await api.put(`/orders/${orderToCancel}/cancel`);
      fetchOrders();
      toast.success("Đã hủy đơn hàng thành công!");
    } catch (err) {
      toast.error(err.response?.data?.message || "Hủy đơn thất bại.");
      setCancellingOrder(null);
    }
  };

  // === 3. HÀM MỚI: MỞ MODAL ĐÁNH GIÁ ===
  const handleShowReviewModal = (product) => {
    setProductToReview(product);
    setShowReviewModal(true);
  };

  // Hàm đóng modal
  const handleCloseReviewModal = () => {
    setShowReviewModal(false);
    setProductToReview(null);
  };

  // Hàm chạy sau khi gửi review (để tải lại cờ 'DaDanhGia')
  const handleReviewSubmitted = () => {
    fetchOrders(); // Tải lại toàn bộ danh sách đơn hàng
  };
  // ======================================

  if (loading) {
    return (
      <div className="text-center">
        <Spinner animation="border" />
      </div>
    );
  }

  if (error) {
    return <Alert variant="danger">{error}</Alert>;
  }

  return (
    <>
      <h3 className="mb-4">Danh sách đơn hàng</h3>
      {orders.length === 0 ? (
        <p>Bạn chưa có đơn hàng nào.</p>
      ) : (
        <ListGroup variant="flush">
          {orders.map((order) => {
            let badgeBg = "secondary";
            if (order.TrangThai === "DANG_XU_LY") badgeBg = "info";
            if (order.TrangThai === "DA_GIAO") badgeBg = "success";
            if (order.TrangThai === "DA_HUY") badgeBg = "danger";

            return (
              <ListGroup.Item key={order.DonHangID} className="p-0 mb-3">
                <Card className="shadow-sm">
                  <Card.Header className="d-flex justify-content-between">
                    <span>Mã ĐH: ORD_{order.DonHangID}</span>
                    <Badge bg={badgeBg}>{order.TrangThai}</Badge>
                  </Card.Header>
                  <Card.Body>
                    {/* === PHẦN MỚI THÊM: HIỂN THỊ SẢN PHẨM === */}
                    <ListGroup variant="flush" className="mb-3">
                      {order.items &&
                        order.items.map((item, index) => (
                          <ListGroup.Item
                            key={index}
                            className="d-flex align-items-center p-2"
                          >
                            <Image
                              src={item.HinhAnh}
                              style={{
                                width: "60px",
                                height: "60px",
                                objectFit: "cover",
                              }}
                              className="me-3"
                            />
                            <div className="flex-grow-1">
                              <small className="fw-bold d-block">
                                {item.TenSanPham}
                              </small>
                              <small className="text-muted d-block">
                                {item.ThuocTinh}
                              </small>
                              <small className="text-muted">
                                SL: {item.SoLuong}
                              </small>
                            </div>

                            {/* === 4. THÊM NÚT ĐÁNH GIÁ === */}
                            {order.TrangThai === "DA_GIAO" && (
                              <Button
                                variant={
                                  item.DaDanhGia
                                    ? "outline-success" // Đã đánh giá
                                    : "outline-primary" // Chưa đánh giá
                                }
                                size="sm"
                                onClick={() => handleShowReviewModal(item)}
                              >
                                {item.DaDanhGia
                                  ? "Xem/Sửa Đánh giá"
                                  : "Viết Đánh giá"}
                              </Button>
                            )}
                            {/* ========================== */}
                          </ListGroup.Item>
                        ))}
                    </ListGroup>
                    {/* ======================================= */}

                    <p>
                      Ngày đặt:{" "}
                      {new Date(order.NgayDatHang).toLocaleDateString("vi-VN")}
                    </p>
                    <h5 className="text-end">
                      Thành tiền:
                      <strong className="text-danger ms-2">
                        {parseFloat(order.TongThanhToan).toLocaleString(
                          "vi-VN"
                        )}{" "}
                        ₫
                      </strong>
                    </h5>
                  </Card.Body>
                  <Card.Footer className="text-end">
                    {/* Chỉ hiển thị nút khi đã giao */}
                    {order.TrangThai === "DA_GIAO" && (
                      <Button
                        as={Link}
                        to={`/profile/return-request/${order.DonHangID}`}
                        variant="outline-info"
                        size="sm"
                        className="me-2"
                        // 1. Vô hiệu hóa nếu 'DaYeuCauTraHang' là 1 (true)
                        disabled={order.DaYeuCauTraHang == 1}
                        title={
                          order.DaYeuCauTraHang == 1
                            ? "Đơn hàng này đã có yêu cầu đổi/trả"
                            : "Yêu cầu đổi/trả"
                        }
                      >
                        {/* 2. Đổi chữ nếu đã yêu cầu */}
                        {order.DaYeuCauTraHang == 1
                          ? "Đã yêu cầu"
                          : "Yêu cầu Đổi/Trả"}
                      </Button>
                    )}
                    <Button
                      variant="outline-danger"
                      size="sm"
                      className="me-2"
                      onClick={() => handleCancelOrder(order.DonHangID)}
                      disabled={
                        order.TrangThai !== "DANG_XU_LY" ||
                        cancellingOrder === order.DonHangID
                      }
                    >
                      {cancellingOrder === order.DonHangID ? (
                        <Spinner as="span" animation="border" size="sm" />
                      ) : (
                        "Hủy đơn"
                      )}
                    </Button>
                    <Button
                      variant="primary"
                      size="sm"
                      onClick={() => handleShowDetails(order.DonHangID)}
                    >
                      Chi tiết
                    </Button>
                  </Card.Footer>
                </Card>
              </ListGroup.Item>
            );
          })}
        </ListGroup>
      )}

      {/* MODAL CHI TIẾT */}
      {/* (Giữ nguyên không đổi) */}
      <Modal
        show={showDetailModal}
        onHide={handleCloseDetailModal}
        size="lg"
        centered
      >
        <Modal.Header closeButton>
          <Modal.Title>Chi tiết đơn hàng</Modal.Title>
        </Modal.Header>
        <Modal.Body>
          {detailLoading ? (
            <div className="text-center">
              <Spinner animation="border" />
            </div>
          ) : selectedOrder ? (
            <Row>
              <Col md={6}>
                <h5>Thông tin người nhận</h5>
                <p className="mb-1">
                  <strong>Tên:</strong> {selectedOrder.TenNguoiNhan}
                </p>
                <p className="mb-1">
                  <strong>Email:</strong> {user?.email}
                </p>
                <p className="mb-1">
                  <strong>SĐT:</strong> {selectedOrder.DienThoaiNhan}
                </p>
                <p className="mb-1">
                  <strong>Địa chỉ:</strong> {selectedOrder.DiaChiChiTiet}
                </p>
                <p className="mb-1">
                  <strong>Thanh toán:</strong>{" "}
                  {selectedOrder.TenPhuongThucThanhToan}
                </p>
              </Col>
              <Col md={6}>
                <h5>Các sản phẩm</h5>
                <ListGroup variant="flush">
                  {selectedOrder.items.map((item) => (
                    <ListGroup.Item
                      key={item.PhienBanID}
                      className="d-flex align-items-center"
                    >
                      <Image
                        src={item.HinhAnh}
                        style={{
                          width: "50px",
                          height: "50px",
                          objectFit: "cover",
                        }}
                        className="me-2"
                      />
                      <div>
                        <small className="fw-bold">{item.TenSanPham}</small>
                        <small className="text-muted d-block">
                          {item.ThuocTinh}
                        </small>
                        <small className="text-muted">
                          {item.SoLuong} x{" "}
                          {parseFloat(item.GiaLucMua).toLocaleString("vi-VN")} ₫
                        </small>
                      </div>
                    </ListGroup.Item>
                  ))}
                </ListGroup>
                <hr />
                <h5 className="text-end">
                  Tổng tiền:{" "}
                  {parseFloat(selectedOrder.TongThanhToan).toLocaleString(
                    "vi-VN"
                  )}{" "}
                  ₫
                </h5>
              </Col>
            </Row>
          ) : (
            <p>Không thể tải chi tiết.</p>
          )}
        </Modal.Body>
      </Modal>

      {/* MODAL XÁC NHẬN HỦY */}
      {/* (Giữ nguyên không đổi) */}
      <Modal show={showConfirmModal} onHide={handleCloseConfirmModal} centered>
        <Modal.Header closeButton>
          <Modal.Title>Xác nhận hủy đơn hàng</Modal.Title>
        </Modal.Header>
        <Modal.Body>
          Bạn có chắc chắn muốn hủy đơn hàng{" "}
          <strong>ORD_{orderToCancel}</strong> không? Hành động này không thể
          hoàn tác.
        </Modal.Body>
        <Modal.Footer>
          <Button variant="secondary" onClick={handleCloseConfirmModal}>
            Không
          </Button>
          <Button variant="danger" onClick={confirmCancel}>
            Xác nhận hủy
          </Button>
        </Modal.Footer>
      </Modal>

      {/* === 5. THÊM MODAL MỚI VÀO RENDER === */}
      {productToReview && (
        <ProductReviewModal
          show={showReviewModal}
          onHide={handleCloseReviewModal}
          product={productToReview}
          onReviewSubmitted={handleReviewSubmitted}
        />
      )}
    </>
  );
};

export default UserOrders;
