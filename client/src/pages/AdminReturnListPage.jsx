import React, {
  useState,
  useEffect,
  useContext,
  useCallback,
  useMemo,
} from "react";
import {
  Card,
  Button,
  Table,
  Spinner,
  Alert,
  Badge,
  Form,
  InputGroup,
  Pagination,
  Row,
  Col,
  Modal,
  ListGroup,
} from "react-bootstrap";
import AdminLayout from "../components/AdminLayout";
import AuthContext from "../context/AuthContext";
import { toast } from "react-toastify";
import { Search, EyeFill } from "react-bootstrap-icons";
import ConfirmModal from "../components/ConfirmModal"; // Sử dụng Modal xác nhận chung

// Constants
const STATUS_OPTIONS = {
  PENDING: { name: "Chờ xử lý", color: "warning" },
  APPROVED: { name: "Đã phê duyệt", color: "primary" },
  REJECTED: { name: "Đã từ chối", color: "danger" },
  COMPLETED: { name: "Đã hoàn tất", color: "success" },
};

const AdminReturnListPage = () => {
  // Data states
  const [returnsList, setReturnsList] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);
  const { api } = useContext(AuthContext);

  // Filter & Pagination states
  const [searchTerm, setSearchTerm] = useState("");
  const [statusFilter, setStatusFilter] = useState("");
  const [pageSize] = useState(10);
  const [currentPage, setCurrentPage] = useState(1);
  const [pagination, setPagination] = useState({
    total: 0,
    page: 1,
    limit: 10,
    totalPages: 0,
  });

  // Modal Detail states
  const [selectedReturn, setSelectedReturn] = useState(null);
  const [showDetailModal, setShowDetailModal] = useState(false);
  const [detailLoading, setDetailLoading] = useState(false);

  // Modal Confirm states
  const [showConfirmModal, setShowConfirmModal] = useState(false);
  const [pendingUpdate, setPendingUpdate] = useState(null); // { returnId, newStatus, refundAmount }
  const [updatingId, setUpdatingId] = useState(null);
  const [refundAmount, setRefundAmount] = useState(0);

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
    });
  };

  // --- HÀM FETCH DỮ LIỆU ---
  const fetchReturns = useCallback(
    async (filters = {}) => {
      setLoading(true);
      try {
        const params = new URLSearchParams();

        if (filters.search) params.append("search", filters.search);
        if (filters.status) params.append("status", filters.status);
        if (filters.page) params.append("page", filters.page);
        if (filters.limit) params.append("limit", filters.limit);

        const { data } = await api.get(`/admin/returns?${params.toString()}`);

        setReturnsList(data.returns || []);
        setPagination(
          data.pagination || { total: 0, page: 1, limit: 10, totalPages: 0 }
        );
        setError(null);
      } catch (err) {
        console.error("Lỗi khi tải danh sách yêu cầu đổi/trả:", err);
        setError(
          err.response?.data?.message ||
            "Không thể tải danh sách yêu cầu đổi/trả."
        );
      } finally {
        setLoading(false);
      }
    },
    [api]
  );

  // --- LOGIC EFFECT (Load Data & Debounce Search) ---
  useEffect(() => {
    fetchReturns({
      search: searchTerm,
      status: statusFilter,
      page: currentPage,
      limit: pageSize,
    });
  }, [statusFilter, currentPage, pageSize, fetchReturns]);

  useEffect(() => {
    const timeoutId = setTimeout(() => {
      if (currentPage !== 1) {
        setCurrentPage(1);
      } else {
        fetchReturns({
          search: searchTerm,
          status: statusFilter,
          page: 1,
          limit: pageSize,
        });
      }
    }, 500);

    return () => clearTimeout(timeoutId);
  }, [searchTerm, fetchReturns]);

  // --- HANDLERS (Modal & Status Update) ---

  const handleViewDetail = async (returnId) => {
    setDetailLoading(true);
    setShowDetailModal(true);
    setSelectedReturn(null);

    try {
      const { data } = await api.get(`/admin/returns/${returnId}`);
      setSelectedReturn(data);

      // Khởi tạo refundAmount khi mở chi tiết
      if (data.RefundAmount) {
        setRefundAmount(parseFloat(data.RefundAmount));
      } else if (data.items) {
        // Tính toán Max Refund nếu chưa có RefundAmount
        const maxRefund = data.items.reduce(
          (sum, item) => sum + item.SoLuongTra * item.GiaHoanTra,
          0
        );
        setRefundAmount(maxRefund);
      }
    } catch {
      toast.error("Không thể tải chi tiết yêu cầu.");
    } finally {
      setDetailLoading(false);
    }
  };

  const handleStatusUpdate = (returnId, currentStatus, targetStatus) => {
    // Chỉ cho phép chuyển đổi từ PENDING hoặc APPROVED
    if (currentStatus !== "PENDING" && currentStatus !== "APPROVED") return;

    // Thiết lập số tiền hoàn trả mặc định trước khi mở modal
    let initialRefund = 0;

    if (targetStatus === "APPROVED" && selectedReturn?.items) {
      initialRefund = selectedReturn.items.reduce(
        (sum, item) => sum + item.SoLuongTra * item.GiaHoanTra,
        0
      );
    } else if (targetStatus === "COMPLETED" && selectedReturn?.RefundAmount) {
      initialRefund = parseFloat(selectedReturn.RefundAmount);
    }

    setRefundAmount(initialRefund);

    setPendingUpdate({ returnId, newStatus: targetStatus });
    setShowConfirmModal(true);
  };

  const handleConfirm = async () => {
    if (!pendingUpdate) return;

    const { returnId, newStatus } = pendingUpdate;
    setUpdatingId(returnId);

    try {
      const payload = {
        newStatus,
        // Chỉ gửi refundAmount nếu trạng thái là APPROVED (khắc phục lỗi 400)
        refundAmount:
          newStatus === "APPROVED" ? parseFloat(refundAmount) : undefined,
      };

      const endpoint = `/admin/returns/${returnId}/status`;
      const response = await api.put(endpoint, payload);

      if (response.data.message) {
        toast.success(response.data.message);

        fetchReturns({
          search: searchTerm,
          status: statusFilter,
          page: currentPage,
          limit: pageSize,
        });

        setShowDetailModal(false);
      }
    } catch (error) {
      console.error("Lỗi khi cập nhật trạng thái trả hàng:", error);
      toast.error(
        error.response?.data?.message || "Cập nhật trạng thái thất bại."
      );
    } finally {
      setUpdatingId(null);
      setPendingUpdate(null);
      setShowConfirmModal(false);
      setRefundAmount(0); // Reset
    }
  };

  // --- CẤU HÌNH MODAL XÁC NHẬN (ĐÃ SỬA LỖI CẤU TRÚC HTML) ---
  const modalContent = useMemo(() => {
    if (!pendingUpdate) return { title: "", message: "", confirmText: "" };

    const { newStatus, returnId } = pendingUpdate;
    const returnDetail =
      returnsList.find((r) => r.ReturnID === returnId) || selectedReturn;

    if (newStatus === "APPROVED") {
      const maxRefund = returnDetail?.items
        ? returnDetail.items.reduce(
            (sum, item) => sum + item.SoLuongTra * item.GiaHoanTra,
            0
          )
        : 0;

      return {
        title: "Xác nhận Phê duyệt Yêu cầu",
        // SỬ DỤNG <div> THAY VÌ <p> ĐỂ KHẮC PHỤC LỖI HYDRATION
        message: (
          <div>
            <div>
              Bạn có chắc muốn **PHÊ DUYỆT** yêu cầu trả hàng #{returnId} của
              khách hàng **{returnDetail?.TenKhachHang}**?
            </div>
            <div>Đơn hàng gốc: #{returnDetail?.DonHangID}.</div>
            <div className="mt-2">
              **Lưu ý:** Việc phê duyệt sẽ kích hoạt hoàn trả tồn kho và cập
              nhật số tiền hoàn trả.
            </div>
            {/* Input nhập số tiền hoàn trả */}
            <Form.Group className="mt-3">
              <Form.Label>
                Số tiền hoàn trả (Tối đa: {formatCurrency(maxRefund)})
              </Form.Label>
              <InputGroup>
                <Form.Control
                  type="number"
                  value={refundAmount}
                  onChange={(e) =>
                    setRefundAmount(parseFloat(e.target.value) || 0)
                  }
                  min="0"
                  max={maxRefund}
                  required
                />
                <InputGroup.Text>VND</InputGroup.Text>
              </InputGroup>
            </Form.Group>
          </div>
        ),
        confirmText: "Phê duyệt & Hoàn trả",
        variant: "primary",
      };
    } else if (newStatus === "REJECTED") {
      return {
        title: "Xác nhận Từ chối Yêu cầu",
        message: `Bạn có chắc muốn **TỪ CHỐI** yêu cầu trả hàng #${returnId}? Trạng thái đơn hàng gốc sẽ được cập nhật lại thành DA_GIAO.`,
        confirmText: "Từ chối",
        variant: "danger",
      };
    } else if (newStatus === "COMPLETED") {
      const finalRefund = returnDetail?.RefundAmount || 0;
      return {
        title: "Xác nhận Hoàn tất Thủ tục",
        message: `Xác nhận **ĐÃ HOÀN TẤT** thủ tục và đã hoàn trả **${formatCurrency(
          finalRefund
        )}** cho khách hàng.`,
        confirmText: "Hoàn tất",
        variant: "success",
      };
    }
    return { title: "", message: "", confirmText: "" };
  }, [
    pendingUpdate,
    refundAmount,
    formatCurrency,
    returnsList,
    selectedReturn,
  ]);

  return (
    <AdminLayout>
      <h2 className="mb-4">Quản lý Yêu cầu Đổi/Trả</h2>

      <Card className="shadow-sm">
        <Card.Header className="bg-white">
          <Row className="align-items-center">
            <Col md={3}>
              <h5 className="mb-0">Yêu cầu ({pagination.total})</h5>
            </Col>

            <Col md={3}>
              <InputGroup size="sm">
                <InputGroup.Text>
                  <Search />
                </InputGroup.Text>
                <Form.Control
                  placeholder="Tìm theo Mã ĐH, Email..."
                  value={searchTerm}
                  onChange={(e) => setSearchTerm(e.target.value)}
                />
              </InputGroup>
            </Col>

            <Col md={3}>
              <Form.Select
                size="sm"
                value={statusFilter}
                onChange={(e) => setStatusFilter(e.target.value)}
              >
                <option value="">Tất cả trạng thái</option>
                {Object.entries(STATUS_OPTIONS).map(([key, value]) => (
                  <option key={key} value={key}>
                    {value.name}
                  </option>
                ))}
              </Form.Select>
            </Col>

            <Col md={3} className="text-end">
              <span className="text-muted small">
                Hiển thị {returnsList.length} / {pagination.total}
              </span>
            </Col>
          </Row>
        </Card.Header>

        <Card.Body className="p-0">
          {loading ? (
            <div className="text-center py-5">
              <Spinner animation="border" /> Đang tải...
            </div>
          ) : error ? (
            <Alert variant="danger" className="m-3">
              {error}
            </Alert>
          ) : returnsList.length === 0 ? (
            <div className="text-center py-5">
              <p className="mb-0 text-muted">Không tìm thấy yêu cầu nào.</p>
            </div>
          ) : (
            <Table hover responsive className="align-middle mb-0">
              <thead className="bg-light">
                <tr>
                  <th>Mã YC</th>
                  <th>Mã ĐH</th>
                  <th>Khách hàng</th>
                  <th>Ngày YC</th>
                  <th>Hoàn trả</th>
                  <th>Trạng thái</th>
                  <th style={{ width: "150px" }}>Thao tác</th>
                </tr>
              </thead>
              <tbody>
                {returnsList.map((req) => (
                  <tr key={req.ReturnID}>
                    <td>
                      <strong className="text-primary">#{req.ReturnID}</strong>
                    </td>
                    <td>#{req.DonHangID}</td>
                    <td>
                      <div>{req.TenKhachHang}</div>
                      <small className="text-muted">{req.Email}</small>
                    </td>
                    <td>{formatDate(req.NgayYeuCau)}</td>
                    <td>
                      {req.RefundAmount ? (
                        <strong className="text-success">
                          {formatCurrency(req.RefundAmount)}
                        </strong>
                      ) : (
                        <span className="text-muted">Chưa xác định</span>
                      )}
                    </td>
                    <td>
                      <Badge bg={STATUS_OPTIONS[req.Status]?.color}>
                        {STATUS_OPTIONS[req.Status]?.name}
                      </Badge>
                    </td>
                    <td>
                      <Button
                        variant="info"
                        size="sm"
                        onClick={() => handleViewDetail(req.ReturnID)}
                        className="me-2"
                      >
                        <EyeFill /> Chi tiết
                      </Button>
                    </td>
                  </tr>
                ))}
              </tbody>
            </Table>
          )}
        </Card.Body>
        {/* Pagination */}
        {pagination.totalPages > 1 && (
          <div className="d-flex justify-content-center p-3 border-top">
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
          </div>
        )}
      </Card>

      {/* --- MODAL CHI TIẾT YÊU CẦU --- */}
      <Modal
        show={showDetailModal}
        onHide={() => setShowDetailModal(false)}
        size="lg"
        scrollable
      >
        <Modal.Header closeButton>
          <Modal.Title>
            Chi tiết Yêu cầu #{selectedReturn?.ReturnID}
          </Modal.Title>
        </Modal.Header>
        <Modal.Body>
          {detailLoading ? (
            <div className="text-center py-5">
              <Spinner animation="border" /> Đang tải chi tiết...
            </div>
          ) : selectedReturn ? (
            <>
              <Row className="mb-4">
                <Col md={6}>
                  <h6>Thông tin Yêu cầu</h6>
                  <p>
                    <strong>Trạng thái: </strong>
                    <Badge bg={STATUS_OPTIONS[selectedReturn.Status]?.color}>
                      {STATUS_OPTIONS[selectedReturn.Status]?.name}
                    </Badge>
                  </p>
                  <p>
                    <strong>Ngày yêu cầu:</strong>{" "}
                    {formatDate(selectedReturn.NgayYeuCau)}
                  </p>
                  <p>
                    <strong>Lý do:</strong> {selectedReturn.Reason}
                  </p>
                  <p>
                    <strong>Địa chỉ giao:</strong>{" "}
                    {selectedReturn.DiaChiChiTiet}
                  </p>
                </Col>
                <Col md={6} className="text-end">
                  <h6>Tóm tắt Thanh toán</h6>
                  <p>
                    <strong>Đơn hàng gốc:</strong> #{selectedReturn.DonHangID}
                  </p>
                  <p>
                    <strong>Tổng ĐH gốc:</strong>{" "}
                    {formatCurrency(selectedReturn.TongThanhToan)}
                  </p>
                  <p>
                    <strong>Số tiền Hoàn trả đã duyệt:</strong>
                    {selectedReturn.RefundAmount ? (
                      <strong className="text-success ms-2">
                        {formatCurrency(selectedReturn.RefundAmount)}
                      </strong>
                    ) : (
                      <span className="text-muted ms-2">Chưa xác định</span>
                    )}
                  </p>
                </Col>
              </Row>

              <h6>Chi tiết Sản phẩm</h6>
              <ListGroup variant="flush">
                {selectedReturn.items?.map((item, index) => (
                  <ListGroup.Item
                    key={index}
                    className="d-flex justify-content-between align-items-center"
                  >
                    <div>
                      <strong>{item.TenSanPham}</strong>
                      <div className="text-muted small">
                        {item.ThuocTinh} | Số lượng trả: {item.SoLuongTra}
                      </div>
                    </div>
                    <div className="text-end">
                      {formatCurrency(item.GiaHoanTra)}
                    </div>
                  </ListGroup.Item>
                ))}
              </ListGroup>
            </>
          ) : (
            <Alert variant="info">Không có dữ liệu chi tiết.</Alert>
          )}
        </Modal.Body>
        <Modal.Footer className="d-flex justify-content-between">
          <div>
            {/* Nút Phê duyệt/Từ chối chỉ hiện khi PENDING */}
            {selectedReturn?.Status === "PENDING" && (
              <>
                <Button
                  variant="primary"
                  className="me-2"
                  disabled={updatingId === selectedReturn.ReturnID}
                  onClick={() =>
                    handleStatusUpdate(
                      selectedReturn.ReturnID,
                      selectedReturn.Status,
                      "APPROVED"
                    )
                  }
                >
                  Phê duyệt & Hoàn tiền
                </Button>
                <Button
                  variant="danger"
                  disabled={updatingId === selectedReturn.ReturnID}
                  onClick={() =>
                    handleStatusUpdate(
                      selectedReturn.ReturnID,
                      selectedReturn.Status,
                      "REJECTED"
                    )
                  }
                >
                  Từ chối
                </Button>
              </>
            )}
            {/* Nút Hoàn tất chỉ hiện khi APPROVED */}
            {selectedReturn?.Status === "APPROVED" && (
              <Button
                variant="success"
                disabled={updatingId === selectedReturn.ReturnID}
                onClick={() =>
                  handleStatusUpdate(
                    selectedReturn.ReturnID,
                    selectedReturn.Status,
                    "COMPLETED"
                  )
                }
              >
                Đã hoàn tất thủ tục
              </Button>
            )}
          </div>
          <Button variant="secondary" onClick={() => setShowDetailModal(false)}>
            Đóng
          </Button>
        </Modal.Footer>
      </Modal>

      {/* --- MODAL XÁC NHẬN CHUNG (Dùng lại cho APPROVED/REJECTED/COMPLETED) --- */}
      <ConfirmModal
        show={showConfirmModal}
        onHide={() => {
          setShowConfirmModal(false);
          setPendingUpdate(null);
          setRefundAmount(0);
        }}
        onConfirm={handleConfirm}
        title={modalContent.title}
        message={modalContent.message}
        confirmText={modalContent.confirmText}
        confirmVariant={modalContent.variant}
        isProcessing={!!updatingId}
      />
    </AdminLayout>
  );
};

export default AdminReturnListPage;
