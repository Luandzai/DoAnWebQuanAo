// client/src/pages/AdminReviewListPage.jsx
import React, { useState, useEffect, useContext, useCallback } from "react";
import {
  Card,
  Button,
  Table,
  Spinner,
  Alert,
  Form,
  InputGroup,
  Pagination,
  Row,
  Col,
  Image,
} from "react-bootstrap";
import AdminLayout from "../components/AdminLayout";
import AuthContext from "../context/AuthContext";
import { toast } from "react-toastify";
import {
  Search,
  Trash,
  StarFill,
  Film,
  Image as ImageIcon,
} from "react-bootstrap-icons";
import ConfirmModal from "../components/ConfirmModal";
import StarRating from "../components/StarRating"; // Import component StarRating

const AdminReviewListPage = () => {
  const [reviews, setReviews] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);
  const { api } = useContext(AuthContext);

  // Filter & Pagination
  const [searchTerm, setSearchTerm] = useState("");
  const [ratingFilter, setRatingFilter] = useState("");
  const [currentPage, setCurrentPage] = useState(1);
  const [pagination, setPagination] = useState({ totalPages: 0 });

  // Modal Confirm
  const [showConfirmModal, setShowConfirmModal] = useState(false);
  const [isProcessing, setIsProcessing] = useState(false);
  const [selectedReviewId, setSelectedReviewId] = useState(null);

  const fetchReviews = useCallback(
    async (page = 1) => {
      setLoading(true);
      try {
        const params = new URLSearchParams();
        params.append("page", page);
        params.append("limit", 10);
        if (searchTerm) params.append("search", searchTerm);
        if (ratingFilter) params.append("rating", ratingFilter);

        const { data } = await api.get(`/admin/reviews?${params.toString()}`);

        setReviews(data.reviews || []);
        setPagination(data.pagination || { totalPages: 0 });
        setError(null);
      } catch (err) {
        setError(
          err.response?.data?.message || "Không thể tải danh sách đánh giá."
        );
      } finally {
        setLoading(false);
      }
    },
    [api, searchTerm, ratingFilter]
  );

  // Load ban đầu và khi filter/page thay đổi
  useEffect(() => {
    fetchReviews(currentPage);
  }, [fetchReviews, currentPage]);

  // Reset về trang 1 khi filter thay đổi
  useEffect(() => {
    if (currentPage !== 1) {
      setCurrentPage(1);
    }
  }, [searchTerm, ratingFilter]);

  // Handlers
  const handleDelete = (reviewId) => {
    setSelectedReviewId(reviewId);
    setShowConfirmModal(true);
  };

  const confirmDeletion = async () => {
    if (!selectedReviewId) return;
    setIsProcessing(true);

    try {
      await api.delete(`/admin/reviews/${selectedReviewId}`);
      toast.success("Đã xóa đánh giá thành công.");
      fetchReviews(currentPage); // Tải lại trang hiện tại
    } catch (err) {
      toast.error(err.response?.data?.message || "Xóa đánh giá thất bại.");
    } finally {
      setIsProcessing(false);
      setShowConfirmModal(false);
      setSelectedReviewId(null);
    }
  };

  return (
    <AdminLayout>
      <h2 className="mb-4">Quản lý Đánh giá</h2>

      <Card className="shadow-sm">
        <Card.Header className="bg-white">
          <Row className="align-items-center">
            <Col md={5}>
              <InputGroup size="sm">
                <InputGroup.Text>
                  <Search />
                </InputGroup.Text>
                <Form.Control
                  placeholder="Tìm theo Tên SP, Tên User, Email, Bình luận..."
                  value={searchTerm}
                  onChange={(e) => setSearchTerm(e.target.value)}
                />
              </InputGroup>
            </Col>
            <Col md={3}>
              <Form.Select
                size="sm"
                value={ratingFilter}
                onChange={(e) => setRatingFilter(e.target.value)}
              >
                <option value="">Tất cả Điểm số</option>
                <option value="5">5 Sao</option>
                <option value="4">4 Sao</option>
                <option value="3">3 Sao</option>
                <option value="2">2 Sao</option>
                <option value="1">1 Sao</option>
              </Form.Select>
            </Col>
            <Col md={4} className="text-end">
              <span className="text-muted small">
                Tổng số: {pagination.total || 0}
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
          ) : reviews.length === 0 ? (
            <div className="text-center py-5">
              <p className="mb-0 text-muted">Không tìm thấy đánh giá nào.</p>
            </div>
          ) : (
            <Table hover responsive className="align-middle mb-0">
              <thead className="bg-light">
                <tr>
                  <th>ID</th>
                  <th>Sản phẩm</th>
                  <th>Người dùng</th>
                  <th>Đánh giá</th>
                  <th>Bình luận</th>
                  <th>Media</th>
                  <th>Ngày tạo</th>
                  <th>Thao tác</th>
                </tr>
              </thead>
              <tbody>
                {reviews.map((r) => (
                  <tr key={r.DanhGiaID}>
                    <td>
                      <strong>#{r.DanhGiaID}</strong>
                    </td>
                    <td>{r.TenSanPham}</td>
                    <td>{r.TenNguoiDung}</td>
                    <td>
                      <StarRating value={r.DiemSo} />
                    </td>
                    <td>
                      <small>{r.BinhLuan.substring(0, 50)}...</small>
                    </td>
                    <td>
                      {r.HinhAnhURL && (
                        <ImageIcon
                          size={20}
                          className="me-2"
                          title="Có hình ảnh"
                        />
                      )}
                      {r.VideoURL && <Film size={20} title="Có video" />}
                    </td>
                    <td>{new Date(r.NgayTao).toLocaleDateString("vi-VN")}</td>
                    <td>
                      <Button
                        variant="danger"
                        size="sm"
                        onClick={() => handleDelete(r.DanhGiaID)}
                        disabled={isProcessing}
                      >
                        <Trash />
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

      {/* Modal Xác nhận Xóa */}
      <ConfirmModal
        show={showConfirmModal}
        onHide={() => setShowConfirmModal(false)}
        onConfirm={confirmDeletion}
        title="Xác nhận Xóa Đánh giá"
        message={`Bạn có chắc chắn muốn XÓA vĩnh viễn đánh giá #${selectedReviewId}? Media trên Cloudinary cũng sẽ bị xóa.`}
        confirmText="Xóa vĩnh viễn"
        confirmVariant="danger"
        isProcessing={isProcessing}
      />
    </AdminLayout>
  );
};

export default AdminReviewListPage;
