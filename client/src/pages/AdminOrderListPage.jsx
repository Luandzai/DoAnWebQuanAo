import React, { useState, useEffect, useContext, useCallback } from "react";
import { Tabs, Tab } from "react-bootstrap";
import {
  Card,
  Button,
  Table,
  Spinner,
  Alert,
  Badge,
  Dropdown,
  Modal,
  ListGroup,
  Row,
  Col,
  Image,
  Form,
  InputGroup,
  Pagination,
} from "react-bootstrap";
import AdminLayout from "../components/AdminLayout";
import AuthContext from "../context/AuthContext";
import { toast } from "react-toastify";
import {
  EyeFill,
  Search,
  Filter,
  ArrowDownUp,
  Calendar2Check,
} from "react-bootstrap-icons";
import ConfirmStatusModal from "../components/ConfirmStatusModal";

// Constants
const STATUS_OPTIONS = {
  CHUA_THANH_TOAN: { name: "Chưa thanh toán", color: "secondary", icon: "💳" },
  DANG_XU_LY: { name: "Đang xử lý", color: "info", icon: "⏳" },
  DANG_GIAO: { name: "Đang giao hàng", color: "warning", icon: "🚚" },
  DA_GIAO: { name: "Đã hoàn thành", color: "success", icon: "✅" },
  DA_HUY: { name: "Đã hủy", color: "danger", icon: "❌" },
  DOI_TRA: { name: "Đổi/Trả hàng", color: "dark", icon: "🔄" },
};

const STATUS_TRANSITIONS = {
  CHUA_THANH_TOAN: ["DANG_XU_LY", "DA_HUY"],
  DANG_XU_LY: ["DANG_GIAO", "DA_HUY"],
  DANG_GIAO: ["DA_GIAO", "DA_HUY"],
  DA_GIAO: [], // Trạng thái cuối
  DA_HUY: [], // Trạng thái cuối
  DOI_TRA: [], // Không thể cập nhật từ đây (chỉ có thể xử lý trong Returns)
};

const SORT_OPTIONS = {
  DATE_DESC: { key: "DATE_DESC", name: "Mới nhất trước" },
  DATE_ASC: { key: "DATE_ASC", name: "Cũ nhất trước" },
  TOTAL_DESC: { key: "TOTAL_DESC", name: "Tổng tiền giảm dần" },
  TOTAL_ASC: { key: "TOTAL_ASC", name: "Tổng tiền tăng dần" },
};

const AdminOrderListPage = () => {
  // Data states
  const [orders, setOrders] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);
  const [pagination, setPagination] = useState({
    total: 0,
    page: 1,
    limit: 10,
    totalPages: 0,
  });

  // UI states
  const [searchTerm, setSearchTerm] = useState("");
  const [statusFilter, setStatusFilter] = useState("");
  const [sortBy, setSortBy] = useState(SORT_OPTIONS.DATE_DESC.key);
  const [pageSize, setPageSize] = useState(10);
  const [currentPage, setCurrentPage] = useState(1);

  // Modal states
  const [selectedOrder, setSelectedOrder] = useState(null);
  const [showDetailModal, setShowDetailModal] = useState(false);
  const [showConfirmModal, setShowConfirmModal] = useState(false);
  const [pendingStatusUpdate, setPendingStatusUpdate] = useState(null);

  // Loading states
  const [updatingId, setUpdatingId] = useState(null);
  const [detailLoading, setDetailLoading] = useState(false);

  const { api } = useContext(AuthContext);

  // Format helpers
  const formatCurrency = (amount) => {
    return new Intl.NumberFormat("vi-VN", {
      style: "currency",
      currency: "VND",
      minimumFractionDigits: 0,
    }).format(amount);
  };

  const formatDate = (dateString) => {
    return new Date(dateString).toLocaleString("vi-VN", {
      year: "numeric",
      month: "2-digit",
      day: "2-digit",
      hour: "2-digit",
      minute: "2-digit",
    });
  };

  // Data fetching
  const fetchOrders = useCallback(
    async (filters = {}) => {
      setLoading(true);
      try {
        const params = new URLSearchParams();

        if (filters.search) params.append("search", filters.search);
        if (filters.status) params.append("status", filters.status);
        if (filters.sortBy) params.append("sortBy", filters.sortBy);
        if (filters.page) params.append("page", filters.page);
        if (filters.limit) params.append("limit", filters.limit);

        const { data } = await api.get(`/admin/orders?${params.toString()}`);
        setOrders(data.orders || []);
        setPagination(
          data.pagination || {
            total: 0,
            page: 1,
            limit: 10,
            totalPages: 0,
          }
        );
      } catch (error) {
        console.error("Lỗi khi tải danh sách đơn hàng:", error);
        setError(
          error.response?.data?.message || "Không thể tải danh sách đơn hàng"
        );
        toast.error("Không thể tải danh sách đơn hàng");
      } finally {
        setLoading(false);
      }
    },
    [api]
  );

  // Load orders on mount and when filters change
  useEffect(() => {
    fetchOrders({
      search: searchTerm,
      status: statusFilter,
      sortBy: sortBy,
      page: currentPage,
      limit: pageSize,
    });
  }, [searchTerm, statusFilter, sortBy, currentPage, pageSize, fetchOrders]);

  // Search handler with debounce
  // NEW: Effect để xử lý Search/Filter/Sort/Limit (debounce)
  useEffect(() => {
    // Chỉ reset về trang 1 nếu một trong các filter/search thay đổi
    // và currentPage hiện tại không phải là 1.
    // Nếu filter/search thay đổi VÀ currentPage đang là 1, ta gọi fetchOrders

    // Đặt logic debounce vào 1 useEffect khác, chỉ phụ thuộc vào searchTerm, statusFilter, sortBy, pageSize
    const timeoutId = setTimeout(() => {
      // Khi một filter thay đổi:
      // 1. Reset về trang 1 (nếu chưa ở trang 1)
      if (currentPage !== 1) {
        setCurrentPage(1);
      } else {
        // 2. Nếu đã ở trang 1, thì gọi fetchOrders ngay lập tức
        fetchOrders({
          search: searchTerm,
          status: statusFilter,
          sortBy: sortBy,
          page: 1,
          limit: pageSize,
        });
      }
    }, 500);

    return () => clearTimeout(timeoutId);
  }, [searchTerm, statusFilter, sortBy, pageSize]);

  // Status update handlers
  const handleStatusUpdate = async (orderId, newStatus) => {
    setPendingStatusUpdate({ orderId, newStatus });
    setShowConfirmModal(true);
  };

  const confirmStatusUpdate = async () => {
    if (!pendingStatusUpdate) return;

    const { orderId, newStatus } = pendingStatusUpdate;
    setUpdatingId(orderId);

    try {
      const response = await api.put(`/admin/orders/${orderId}/status`, {
        trangThaiMoi: newStatus,
      });

      if (response.data.success) {
        toast.success(`Đã cập nhật trạng thái đơn hàng #${orderId}`);
        fetchOrders({
          search: searchTerm,
          status: statusFilter,
          sortBy: sortBy,
          page: currentPage,
          limit: pageSize,
        });
      }
    } catch (error) {
      console.error("Lỗi khi cập nhật trạng thái:", error);
      toast.error(
        error.response?.data?.message ||
          error.response?.data?.details?.message ||
          "Không thể cập nhật trạng thái đơn hàng"
      );
    } finally {
      setUpdatingId(null);
      setPendingStatusUpdate(null);
      setShowConfirmModal(false);
    }
  };

  // Order detail handlers
  const handleViewDetail = async (orderId) => {
    setDetailLoading(true);
    setShowDetailModal(true);

    try {
      // FIX LỖI: API trả về { success: true, data: { ... } }. Ta cần lấy data.data
      const { data: responseData } = await api.get(`/admin/orders/${orderId}`);
      setSelectedOrder(responseData.data); // LẤY CHỈ OBJECT ĐƠN HÀNG THỰC TẾ
    } catch (error) {
      console.error("Lỗi khi tải chi tiết đơn hàng:", error);
      toast.error("Không thể tải chi tiết đơn hàng");
      setShowDetailModal(false);
    } finally {
      setDetailLoading(false);
    }
  };

  return (
    <AdminLayout>
      <Card className="shadow-sm">
        <Card.Header className="bg-white">
          <Row className="align-items-center">
            <Col md={3}>
              <h5 className="mb-0">Quản lý Đơn hàng ({orders.length})</h5>
            </Col>

            <Col md={3}>
              <InputGroup size="sm">
                <InputGroup.Text>
                  <Search />
                </InputGroup.Text>
                <Form.Control
                  placeholder="Tìm đơn hàng..."
                  value={searchTerm}
                  onChange={(e) => setSearchTerm(e.target.value)}
                />
              </InputGroup>
            </Col>

            <Col md={2}>
              <Form.Select
                size="sm"
                value={statusFilter}
                onChange={(e) => setStatusFilter(e.target.value)}
              >
                <option value="">Tất cả trạng thái</option>
                {Object.entries(STATUS_OPTIONS).map(([key, value]) => (
                  <option key={key} value={key}>
                    {value.icon} {value.name}
                  </option>
                ))}
              </Form.Select>
            </Col>

            <Col md={2}>
              <Form.Select
                size="sm"
                value={sortBy}
                onChange={(e) => setSortBy(e.target.value)}
              >
                {Object.values(SORT_OPTIONS).map((option) => (
                  <option key={option.key} value={option.key}>
                    {option.name}
                  </option>
                ))}
              </Form.Select>
            </Col>

            <Col md={2}>
              <Form.Select
                size="sm"
                value={pageSize}
                onChange={(e) => setPageSize(Number(e.target.value))}
              >
                {[10, 20, 50, 100].map((size) => (
                  <option key={size} value={size}>
                    {size} dòng / trang
                  </option>
                ))}
              </Form.Select>
            </Col>
          </Row>
        </Card.Header>

        <Card.Body className="p-0">
          {loading ? (
            <div className="text-center py-5">
              <Spinner animation="border" className="mb-2" />
              <p className="mb-0">Đang tải danh sách đơn hàng...</p>
            </div>
          ) : error ? (
            <Alert variant="danger" className="m-3">
              <Alert.Heading>Không thể tải dữ liệu</Alert.Heading>
              <p className="mb-0">{error}</p>
            </Alert>
          ) : orders.length === 0 ? (
            <div className="text-center py-5">
              <p className="mb-0 text-muted">Không tìm thấy đơn hàng nào</p>
            </div>
          ) : (
            <div>
              <Table hover responsive className="align-middle mb-0">
                <thead className="bg-light">
                  <tr>
                    <th className="text-nowrap">Mã ĐH</th>
                    <th>Khách hàng</th>
                    <th>
                      <div className="d-flex align-items-center">
                        Ngày đặt
                        <Calendar2Check className="ms-1" />
                      </div>
                    </th>
                    <th>
                      <div className="d-flex align-items-center">
                        Tổng tiền
                        <ArrowDownUp className="ms-1" />
                      </div>
                    </th>
                    <th>Trạng thái</th>
                    <th style={{ width: "180px" }}>Thao tác</th>
                  </tr>
                </thead>
                <tbody>
                  {orders.map((order) => (
                    <tr key={order.DonHangID}>
                      <td>
                        <strong className="text-primary">
                          #{order.DonHangID}
                        </strong>
                      </td>
                      <td>
                        <div>{order.HoTen}</div>
                        <small className="text-muted">{order.Email}</small>
                      </td>
                      <td>{formatDate(order.NgayDatHang)}</td>
                      <td>
                        <strong>{formatCurrency(order.TongThanhToan)}</strong>
                      </td>
                      <td>
                        <Badge
                          bg={STATUS_OPTIONS[order.TrangThai]?.color}
                          className="d-inline-flex align-items-center"
                        >
                          <span className="me-1">
                            {STATUS_OPTIONS[order.TrangThai]?.icon}
                          </span>
                          {STATUS_OPTIONS[order.TrangThai]?.name}
                        </Badge>
                      </td>
                      <td>
                        <Dropdown size="sm" className="d-inline me-1">
                          <Dropdown.Toggle
                            variant="primary"
                            id={`dropdown-${order.DonHangID}`}
                            disabled={
                              updatingId === order.DonHangID ||
                              !STATUS_TRANSITIONS[order.TrangThai]?.length
                            }
                          >
                            {updatingId === order.DonHangID ? (
                              <>
                                <Spinner
                                  as="span"
                                  animation="border"
                                  size="sm"
                                  className="me-1"
                                />
                                Đang xử lý...
                              </>
                            ) : (
                              "Cập nhật"
                            )}
                          </Dropdown.Toggle>

                          <Dropdown.Menu>
                            {STATUS_TRANSITIONS[order.TrangThai]?.map(
                              (status) => (
                                <Dropdown.Item
                                  key={status}
                                  onClick={() =>
                                    handleStatusUpdate(order.DonHangID, status)
                                  }
                                >
                                  {STATUS_OPTIONS[status].icon}{" "}
                                  {STATUS_OPTIONS[status].name}
                                </Dropdown.Item>
                              )
                            )}
                          </Dropdown.Menu>
                        </Dropdown>

                        <Button
                          variant="info"
                          size="sm"
                          onClick={() => handleViewDetail(order.DonHangID)}
                        >
                          <EyeFill className="me-1" />
                          Chi tiết
                        </Button>
                      </td>
                    </tr>
                  ))}
                </tbody>
              </Table>
              <div className="d-flex justify-content-center p-3">
                {pagination.totalPages > 1 && (
                  <Pagination>
                    <Pagination.First
                      onClick={() => setCurrentPage(1)}
                      disabled={currentPage === 1}
                    />
                    <Pagination.Prev
                      onClick={() => setCurrentPage(currentPage - 1)}
                      disabled={currentPage === 1}
                    />

                    {[...Array(pagination.totalPages)].map((_, idx) => (
                      <Pagination.Item
                        key={idx + 1}
                        active={idx + 1 === currentPage}
                        onClick={() => setCurrentPage(idx + 1)}
                      >
                        {idx + 1}
                      </Pagination.Item>
                    ))}

                    <Pagination.Next
                      onClick={() => setCurrentPage(currentPage + 1)}
                      disabled={currentPage === pagination.totalPages}
                    />
                    <Pagination.Last
                      onClick={() => setCurrentPage(pagination.totalPages)}
                      disabled={currentPage === pagination.totalPages}
                    />
                  </Pagination>
                )}
              </div>
            </div>
          )}
        </Card.Body>
      </Card>

      {/* Modal Xác nhận */}
      <ConfirmStatusModal
        show={showConfirmModal}
        onHide={() => {
          setShowConfirmModal(false);
          setPendingStatusUpdate(null);
        }}
        onConfirm={confirmStatusUpdate}
        title="Xác nhận thay đổi trạng thái"
        message={
          pendingStatusUpdate
            ? `Bạn có chắc muốn chuyển đơn hàng #${
                pendingStatusUpdate.orderId
              } sang trạng thái "${
                STATUS_OPTIONS[pendingStatusUpdate.newStatus]?.name
              }"?`
            : ""
        }
        isProcessing={!!updatingId}
      />

      {/* Modal Chi tiết */}
      <Modal
        show={showDetailModal}
        onHide={() => setShowDetailModal(false)}
        size="lg"
        scrollable
      >
        <Modal.Header closeButton>
          <Modal.Title>
            Chi tiết đơn hàng #{selectedOrder?.DonHangID}
          </Modal.Title>
        </Modal.Header>

        <Modal.Body>
          {detailLoading ? (
            <div className="text-center py-5">
              <Spinner animation="border" className="mb-2" /> Đang tải thông tin
              chi tiết...
            </div>
          ) : selectedOrder ? (
            // Dữ liệu chi tiết nằm trực tiếp trong selectedOrder
            <Tabs
              defaultActiveKey="details"
              id="order-detail-tabs"
              className="mb-3"
            >
              {/* TAB 1: THÔNG TIN CHUNG & SẢN PHẨM */}
              <Tab eventKey="details" title="Chi tiết Đơn hàng">
                <Row>
                  {/* CỘT 1: THÔNG TIN CHUNG */}
                  <Col md={6} className="mb-4">
                    <Card className="h-100">
                      <Card.Header className="bg-light">
                        <h6 className="mb-0">Thông tin khách hàng & Địa chỉ</h6>
                      </Card.Header>
                      <Card.Body>
                        <p>
                          <strong>Khách hàng:</strong>{" "}
                          {selectedOrder.TenKhachHang} (
                          {selectedOrder.EmailKhachHang})
                        </p>
                        <p>
                          <strong>Người nhận:</strong>{" "}
                          {selectedOrder.TenNguoiNhan}
                        </p>
                        <p>
                          <strong>Địa chỉ:</strong>{" "}
                          {selectedOrder.DiaChiChiTiet}
                        </p>
                        <p>
                          <strong>Ghi chú:</strong>{" "}
                          {selectedOrder.GhiChu || "Không có"}
                        </p>
                        {/* <p>
                          <strong>Cập nhật cuối:</strong>{" "}
                          {selectedOrder.NgayCapNhat
                            ? formatDate(selectedOrder.NgayCapNhat)
                            : "Chưa cập nhật"}
                        </p> */}
                        {/* <p>
                          <strong>Admin:</strong>{" "}
                          {selectedOrder.NguoiCapNhatTen || "Không rõ"}
                        </p> */}
                      </Card.Body>
                    </Card>
                  </Col>

                  {/* CỘT 2: TỔNG KẾT VÀ THANH TOÁN */}
                  <Col md={6} className="mb-4">
                    <Card className="h-100">
                      <Card.Header className="bg-light">
                        <h6 className="mb-0">Tổng kết & Thanh toán</h6>
                      </Card.Header>
                      <Card.Body>
                        <p>
                          <strong>PT Vận chuyển:</strong>{" "}
                          {selectedOrder.TenPhuongThuc}
                        </p>
                        <p>
                          <strong>Voucher:</strong>{" "}
                          {selectedOrder.TenKhuyenMai || "Không sử dụng"}
                        </p>
                        <p>
                          <strong>Phí VC:</strong>{" "}
                          {formatCurrency(selectedOrder.PhiVanChuyen || 0)}
                        </p>
                        <p>
                          <strong>Tổng tiền hàng:</strong>{" "}
                          {formatCurrency(selectedOrder.TongTienHang || 0)}
                        </p>
                        {/* <p>
                          <strong>Giảm giá:</strong> -{" "}
                          {formatCurrency(
                            (selectedOrder.TongTienHang || 0) +
                              (selectedOrder.PhiVanChuyen || 0) -
                              (selectedOrder.TongThanhToan || 0)
                          )}
                        </p> */}
                      </Card.Body>
                      <Card.Footer className="text-end">
                        <h5>
                          Tổng thanh toán:{" "}
                          <strong className="text-danger">
                            {formatCurrency(selectedOrder.TongThanhToan || 0)}
                          </strong>
                        </h5>
                      </Card.Footer>
                    </Card>
                  </Col>
                </Row>

                {/* CHI TIẾT SẢN PHẨM */}
                <Card>
                  <Card.Header className="bg-light">
                    <h6 className="mb-0">Danh sách Sản phẩm</h6>
                  </Card.Header>
                  <Card.Body className="p-0">
                    <ListGroup variant="flush">
                      {selectedOrder.items?.map((item) => (
                        <ListGroup.Item
                          key={item.PhienBanID}
                          className="d-flex align-items-center"
                        >
                          {/* THIẾT KẾ HIỂN THỊ SẢN PHẨM */}
                          <Col xs={2} md={1}>
                            <Image
                              src={item.HinhAnh}
                              alt={item.TenSanPham}
                              className="img-fluid rounded"
                            />
                          </Col>
                          <Col>
                            <h6 className="mb-1">{item.TenSanPham}</h6>
                            <p className="mb-0 small text-muted">
                              {item.ThuocTinh}
                            </p>
                          </Col>
                          <Col xs="auto" className="text-end">
                            <p className="mb-0">
                              {item.SoLuong} x{" "}
                              {formatCurrency(item.GiaLucMua || 0)}
                            </p>
                            <strong className="text-danger">
                              ={" "}
                              {formatCurrency(
                                (item.SoLuong || 0) * (item.GiaLucMua || 0)
                              )}
                            </strong>
                          </Col>
                        </ListGroup.Item>
                      ))}
                    </ListGroup>
                  </Card.Body>
                </Card>
              </Tab>

              {/* TAB 2: LỊCH SỬ ĐƠN HÀNG */}
              <Tab
                eventKey="history"
                title={`Lịch sử (${selectedOrder.history?.length || 0})`}
              >
                <Table striped bordered size="sm" className="mt-3">
                  <thead>
                    <tr>
                      <th>Thời gian</th>
                      <th>Trạng thái Cũ</th>
                      <th>Trạng thái Mới</th>
                      <th>Ghi chú</th>
                    </tr>
                  </thead>
                  <tbody>
                    {selectedOrder.history?.map((h) => (
                      <tr key={h.LichSuID}>
                        <td>{new Date(h.ThoiGian).toLocaleString("vi-VN")}</td>
                        <td>
                          <Badge
                            bg={
                              STATUS_OPTIONS[h.TrangThaiCu]?.color ||
                              "secondary"
                            }
                          >
                            {h.TrangThaiCu}
                          </Badge>
                        </td>
                        <td>
                          <Badge
                            bg={
                              STATUS_OPTIONS[h.TrangThaiMoi]?.color ||
                              "secondary"
                            }
                          >
                            {h.TrangThaiMoi}
                          </Badge>
                        </td>
                        <td>{h.GhiChu}</td>
                      </tr>
                    ))}
                  </tbody>
                </Table>
                {selectedOrder.history?.length === 0 && (
                  <Alert variant="info">Chưa có lịch sử trạng thái.</Alert>
                )}
              </Tab>
            </Tabs>
          ) : (
            <Alert variant="danger">
              Không thể tải thông tin chi tiết đơn hàng
            </Alert>
          )}
        </Modal.Body>
      </Modal>
    </AdminLayout>
  );
};

export default AdminOrderListPage;
