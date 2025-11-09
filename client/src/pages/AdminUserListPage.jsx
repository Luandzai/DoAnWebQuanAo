// client/src/pages/AdminUserListPage.jsx (HOÀN CHỈNH - CẬP NHẬT TRẠNG THÁI & VAI TRÒ)

import React, { useState, useEffect, useContext, useCallback } from "react";
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
} from "react-bootstrap";
import AdminLayout from "../components/AdminLayout";
import AuthContext from "../context/AuthContext";
import { toast } from "react-toastify";
import { Search, ArrowDownUp, PersonFill } from "react-bootstrap-icons";
// Sử dụng tên file ConfirmModal đã được tạo ở bước 2
import ConfirmModal from "../components/ConfirmModal";

// Constants
const STATUS_OPTIONS = {
  ACTIVE: { name: "Hoạt động", color: "success" },
  INACTIVE: { name: "Đã khóa", color: "danger" },
};

const ROLE_OPTIONS = {
  KHACHHANG: { name: "Khách hàng", color: "info" },
  ADMIN: { name: "Quản trị viên", color: "primary" },
};

const AUTH_OPTIONS = {
  LOCAL: "Mật khẩu",
  GOOGLE: "Google",
};

const SORT_OPTIONS = {
  DATE_DESC: { key: "DATE_DESC", name: "Mới nhất trước" },
  DATE_ASC: { key: "DATE_ASC", name: "Cũ nhất trước" },
  NAME_ASC: { key: "NAME_ASC", name: "Tên (A-Z)" },
  NAME_DESC: { key: "NAME_DESC", name: "Tên (Z-A)" },
};

const AdminUserListPage = () => {
  // Data states
  const [users, setUsers] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);
  const { api, user: currentUser } = useContext(AuthContext); // Lấy thông tin user hiện tại

  // Filter & Pagination states
  const [searchTerm, setSearchTerm] = useState("");
  const [statusFilter, setStatusFilter] = useState("");
  const [roleFilter, setRoleFilter] = useState("");
  const [sortBy, setSortBy] = useState(SORT_OPTIONS.DATE_DESC.key);
  const [pageSize, setPageSize] = useState(10);
  const [currentPage, setCurrentPage] = useState(1);
  const [pagination, setPagination] = useState({
    total: 0,
    page: 1,
    limit: 10,
    totalPages: 0,
  });

  // === STATES CHO THAO TÁC ===
  const [updatingId, setUpdatingId] = useState(null);
  const [showConfirmModal, setShowConfirmModal] = useState(false);
  // pendingUpdate: { userId, currentStatus/currentRole, newStatus/newRole, type: 'status' | 'role' }
  const [pendingUpdate, setPendingUpdate] = useState(null);
  // ===================================

  // Format helpers
  const formatDate = (dateString) => {
    return new Date(dateString).toLocaleDateString("vi-VN");
  };

  // Data fetching
  const fetchUsers = useCallback(
    async (filters = {}) => {
      setLoading(true);
      try {
        const params = new URLSearchParams();

        if (filters.search) params.append("search", filters.search);
        if (filters.status) params.append("status", filters.status);
        if (filters.role) params.append("role", filters.role);
        if (filters.sortBy) params.append("sortBy", filters.sortBy);
        if (filters.page) params.append("page", filters.page);
        if (filters.limit) params.append("limit", filters.limit);

        const { data } = await api.get(`/admin/users?${params.toString()}`);

        setUsers(data.users || []);
        setPagination(
          data.pagination || { total: 0, page: 1, limit: 10, totalPages: 0 }
        );
        setError(null);
      } catch (err) {
        console.error("Lỗi khi tải danh sách người dùng:", err);
        setError(
          err.response?.data?.message || "Không thể tải danh sách người dùng."
        );
        toast.error("Không thể tải danh sách người dùng");
      } finally {
        setLoading(false);
      }
    },
    [api]
  );

  // --- LOGIC XỬ LÝ CẬP NHẬT TRẠNG THÁI (STATUS) ---

  const handleChangeStatus = (userId, currentStatus) => {
    const newStatus = currentStatus === "ACTIVE" ? "INACTIVE" : "ACTIVE";
    setPendingUpdate({ userId, currentStatus, newStatus, type: "status" });
    setShowConfirmModal(true);
  };

  const confirmStatusUpdate = async () => {
    if (!pendingUpdate || pendingUpdate.type !== "status") return;

    const { userId, newStatus } = pendingUpdate;
    setUpdatingId(userId);

    try {
      const endpoint = `/admin/users/${userId}/status`;
      const response = await api.put(endpoint, {
        trangThaiMoi: newStatus,
      });

      if (response.data.message) {
        toast.success(response.data.message);
        // Tải lại danh sách (để cập nhật Badge)
        fetchUsers({
          search: searchTerm,
          status: statusFilter,
          role: roleFilter,
          sortBy: sortBy,
          page: currentPage,
          limit: pageSize,
        });
      }
    } catch (error) {
      console.error("Lỗi khi cập nhật trạng thái người dùng:", error);
      toast.error(
        error.response?.data?.message || "Không thể cập nhật trạng thái."
      );
    } finally {
      setUpdatingId(null);
      setPendingUpdate(null);
      setShowConfirmModal(false);
    }
  };

  // --- LOGIC XỬ LÝ CẬP NHẬT VAI TRÒ (ROLE) ---

  const handleChangeRole = (userId, currentRole) => {
    const newRole = currentRole === "ADMIN" ? "KHACHHANG" : "ADMIN";
    setPendingUpdate({ userId, currentRole, newRole, type: "role" });
    setShowConfirmModal(true);
  };

  const confirmRoleUpdate = async () => {
    if (!pendingUpdate || pendingUpdate.type !== "role") return;

    const { userId, newRole } = pendingUpdate;
    setUpdatingId(userId);

    try {
      const endpoint = `/admin/users/${userId}/role`;
      const response = await api.put(endpoint, {
        vaiTroMoi: newRole,
      });

      if (response.data.message) {
        toast.success(response.data.message);
        // Tải lại danh sách
        fetchUsers({
          search: searchTerm,
          status: statusFilter,
          role: roleFilter,
          sortBy: sortBy,
          page: currentPage,
          limit: pageSize,
        });
      }
    } catch (error) {
      console.error("Lỗi khi cập nhật vai trò người dùng:", error);
      toast.error(
        error.response?.data?.message || "Không thể cập nhật vai trò."
      );
    } finally {
      setUpdatingId(null);
      setPendingUpdate(null);
      setShowConfirmModal(false);
    }
  };

  // --- LOGIC TẢI DỮ LIỆU & DEBOUNCE (Giữ nguyên) ---

  // 1. Load users khi filter (trừ searchTerm) hoặc currentPage thay đổi (Không debounce)
  useEffect(() => {
    fetchUsers({
      search: searchTerm,
      status: statusFilter,
      role: roleFilter,
      sortBy: sortBy,
      page: currentPage,
      limit: pageSize,
    });
  }, [statusFilter, roleFilter, sortBy, currentPage, pageSize, fetchUsers]);

  // 2. Xử lý debounce cho searchTerm (và reset trang nếu cần)
  useEffect(() => {
    const timeoutId = setTimeout(() => {
      if (currentPage !== 1) {
        setCurrentPage(1);
      } else {
        fetchUsers({
          search: searchTerm,
          status: statusFilter,
          role: roleFilter,
          sortBy: sortBy,
          page: 1,
          limit: pageSize,
        });
      }
    }, 500);

    return () => clearTimeout(timeoutId);
  }, [searchTerm, fetchUsers]);

  // --- LOGIC XỬ LÝ MODAL CHUNG (handleConfirm & getModalContent) ---

  const handleConfirm = () => {
    if (pendingUpdate?.type === "status") {
      confirmStatusUpdate();
    } else if (pendingUpdate?.type === "role") {
      confirmRoleUpdate();
    }
  };

  const getModalContent = () => {
    if (!pendingUpdate) return { title: "", message: "", confirmText: "" };

    if (pendingUpdate.type === "status") {
      const action =
        pendingUpdate.newStatus === "INACTIVE" ? "KHÓA" : "MỞ KHÓA";
      return {
        title: "Xác nhận thay đổi Trạng thái",
        message: `Bạn có chắc chắn muốn ${action} tài khoản #${pendingUpdate.userId} này?`,
        confirmText: action,
        variant: pendingUpdate.newStatus === "INACTIVE" ? "danger" : "success",
      };
    } else if (pendingUpdate.type === "role") {
      const action = pendingUpdate.newRole === "ADMIN" ? "NÂNG CẤP" : "HẠ CẤP";
      const roleName =
        ROLE_OPTIONS[pendingUpdate.newRole]?.name.toUpperCase() ||
        pendingUpdate.newRole;
      return {
        title: "Xác nhận thay đổi Vai trò",
        message: `Bạn có chắc chắn muốn ${action} tài khoản #${pendingUpdate.userId} thành vai trò [${roleName}]?`,
        confirmText: action,
        variant: "warning",
      };
    }
    return { title: "", message: "", confirmText: "" };
  };

  const modalContent = getModalContent();

  return (
    <AdminLayout>
      <Card className="shadow-sm">
        <Card.Header className="bg-white">
          <Row className="align-items-center">
            <Col md={3}>
              <h5 className="mb-0">Quản lý Người dùng ({pagination.total})</h5>
            </Col>

            {/* 1. Tìm kiếm */}
            <Col md={3}>
              <InputGroup size="sm">
                <InputGroup.Text>
                  <Search />
                </InputGroup.Text>
                <Form.Control
                  placeholder="Tìm theo tên, email, SĐT..."
                  value={searchTerm}
                  onChange={(e) => setSearchTerm(e.target.value)}
                />
              </InputGroup>
            </Col>

            {/* 2. Lọc Vai trò */}
            <Col md={2}>
              <Form.Select
                size="sm"
                value={roleFilter}
                onChange={(e) => setRoleFilter(e.target.value)}
              >
                <option value="">Tất cả Vai trò</option>
                {Object.entries(ROLE_OPTIONS).map(([key, value]) => (
                  <option key={key} value={key}>
                    {value.name}
                  </option>
                ))}
              </Form.Select>
            </Col>

            {/* 3. Lọc Trạng thái */}
            <Col md={2}>
              <Form.Select
                size="sm"
                value={statusFilter}
                onChange={(e) => setStatusFilter(e.target.value)}
              >
                <option value="">Tất cả Trạng thái</option>
                {Object.entries(STATUS_OPTIONS).map(([key, value]) => (
                  <option key={key} value={key}>
                    {value.name}
                  </option>
                ))}
              </Form.Select>
            </Col>

            {/* 4. Sắp xếp & Page Size */}
            <Col
              md={2}
              className="d-flex justify-content-end align-items-center"
            >
              <Form.Select
                size="sm"
                value={sortBy}
                onChange={(e) => setSortBy(e.target.value)}
                className="me-2"
              >
                {Object.values(SORT_OPTIONS).map((option) => (
                  <option key={option.key} value={option.key}>
                    {option.name}
                  </option>
                ))}
              </Form.Select>
            </Col>
          </Row>
          <Row className="mt-2">
            <Col md={12} className="d-flex justify-content-end">
              <Form.Select
                size="sm"
                value={pageSize}
                onChange={(e) => setPageSize(Number(e.target.value))}
                style={{ width: "150px" }}
              >
                {[10, 20, 50].map((size) => (
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
              <Spinner animation="border" size="sm" /> Đang tải danh sách người
              dùng...
            </div>
          ) : error ? (
            <Alert variant="danger" className="m-3">
              {error}
            </Alert>
          ) : users.length === 0 ? (
            <div className="text-center py-5">
              <p className="mb-0 text-muted">Không tìm thấy người dùng nào</p>
            </div>
          ) : (
            <>
              <Table hover responsive className="align-middle mb-0">
                <thead className="bg-light">
                  <tr>
                    <th>ID</th>
                    <th>Thông tin</th>
                    <th>Vai trò</th>
                    <th>Xác thực</th>
                    <th>Trạng thái</th>
                    <th>Ngày tạo</th>
                    <th style={{ width: "150px" }}>Thao tác</th>
                  </tr>
                </thead>
                <tbody>
                  {users.map((user) => {
                    const statusConfig = STATUS_OPTIONS[user.TrangThai] || {
                      name: user.TrangThai,
                      color: "secondary",
                    };
                    const roleConfig = ROLE_OPTIONS[user.VaiTro] || {
                      name: user.VaiTro,
                      color: "secondary",
                    };
                    const authMethod =
                      AUTH_OPTIONS[user.LoaiXacThuc] || user.LoaiXacThuc;

                    // Kiểm tra xem user có phải là chính Admin đang login hay không
                    // Sử dụng `currentUser` từ context thay vì req.user
                    const isSelf =
                      user.NguoiDungID === currentUser?.NguoiDungID;

                    return (
                      <tr key={user.NguoiDungID}>
                        <td>{user.NguoiDungID}</td>
                        <td>
                          <strong className="d-block">{user.HoTen}</strong>
                          <small className="text-muted">{user.Email}</small>
                          <small className="d-block text-info">
                            {user.DienThoai}
                          </small>
                        </td>
                        <td>
                          <Badge bg={roleConfig.color}>{roleConfig.name}</Badge>
                          {isSelf && (
                            <Badge bg="dark" className="ms-1">
                              Bạn
                            </Badge>
                          )}
                        </td>
                        <td>
                          <Badge
                            bg={
                              user.LoaiXacThuc === "GOOGLE"
                                ? "danger"
                                : "secondary"
                            }
                          >
                            {authMethod}
                          </Badge>
                        </td>
                        <td>
                          <Badge bg={statusConfig.color}>
                            {statusConfig.name}
                          </Badge>
                        </td>
                        <td>{formatDate(user.NgayTao)}</td>
                        <td>
                          <Button
                            variant="warning"
                            size="sm"
                            className="me-2"
                            onClick={() =>
                              handleChangeRole(user.NguoiDungID, user.VaiTro)
                            }
                            title="Thay đổi Vai trò"
                            // Không cho phép thay đổi vai trò của chính mình
                            disabled={updatingId === user.NguoiDungID || isSelf}
                          >
                            {updatingId === user.NguoiDungID &&
                            pendingUpdate?.type === "role" ? (
                              <Spinner animation="border" size="sm" />
                            ) : (
                              <PersonFill />
                            )}
                          </Button>
                          <Button
                            // Không cho phép Khóa/Mở khóa chính mình
                            disabled={updatingId === user.NguoiDungID || isSelf}
                            variant={
                              user.TrangThai === "ACTIVE" ? "danger" : "success"
                            }
                            size="sm"
                            onClick={() =>
                              handleChangeStatus(
                                user.NguoiDungID,
                                user.TrangThai
                              )
                            }
                            title={
                              user.TrangThai === "ACTIVE"
                                ? "Khóa tài khoản"
                                : "Mở khóa tài khoản"
                            }
                          >
                            {/* Hiển thị Spinner khi đang xử lý */}
                            {updatingId === user.NguoiDungID &&
                            pendingUpdate?.type === "status" ? (
                              <Spinner animation="border" size="sm" />
                            ) : user.TrangThai === "ACTIVE" ? (
                              "Khóa"
                            ) : (
                              "Mở khóa"
                            )}
                          </Button>
                        </td>
                      </tr>
                    );
                  })}
                </tbody>
              </Table>

              {/* === PHÂN TRANG === */}
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
              {/* === END PHÂN TRANG === */}
            </>
          )}
        </Card.Body>
      </Card>

      {/* === MODAL XÁC NHẬN CHUNG === */}
      <ConfirmModal
        show={showConfirmModal}
        onHide={() => setShowConfirmModal(false)}
        onConfirm={handleConfirm}
        title={modalContent.title}
        message={modalContent.message}
        confirmText={modalContent.confirmText}
        confirmVariant={modalContent.variant}
        isProcessing={!!updatingId}
      />
      {/* ============================= */}
    </AdminLayout>
  );
};

export default AdminUserListPage;
