// client/src/pages/AdminVoucherListPage.jsx (ĐÃ SỬA LOGIC KÍCH HOẠT)

import React, { useState, useEffect, useContext, useCallback } from "react";
import {
  Card,
  Button,
  Table,
  Spinner,
  Alert,
  Badge,
  Row,
  Col,
} from "react-bootstrap";
import AdminLayout from "../components/AdminLayout";
import AuthContext from "../context/AuthContext";
import { toast } from "react-toastify";
import {
  Plus,
  PencilSquare,
  Trash,
  ArrowReturnLeft,
} from "react-bootstrap-icons";
import AdminVoucherModal from "../components/AdminVoucherModal.jsx";
import ConfirmModal from "../components/ConfirmModal";

// Constants
const LOAI_GIAM_GIA = {
  PHANTRAM: "%",
  SOTIEN: "₫",
};

const AdminVoucherListPage = () => {
  const [vouchers, setVouchers] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);

  // === SỬA LỖI LOGIC MODAL ===
  const [isProcessing, setIsProcessing] = useState(false);
  // State mới: { code: '50K', action: 'disable' | 'enable' }
  const [pendingAction, setPendingAction] = useState(null);
  const [showConfirmModal, setShowConfirmModal] = useState(false);
  // =========================

  const { api } = useContext(AuthContext);

  // Modal states (Thêm/Sửa)
  const [showModal, setShowModal] = useState(false);
  const [isEditMode, setIsEditMode] = useState(false);
  const [voucherToEdit, setVoucherToEdit] = useState(null);

  // Format helpers
  const formatCurrency = (amount) => {
    return new Intl.NumberFormat("vi-VN", {
      style: "currency",
      currency: "VND",
      minimumFractionDigits: 0,
    }).format(amount);
  };

  const formatDate = (dateString) => {
    return new Date(dateString).toLocaleDateString("vi-VN");
  };

  // Hàm fetchVouchers
  const fetchVouchers = useCallback(async () => {
    setLoading(true);
    try {
      const { data } = await api.get("/vouchers/admin");
      setVouchers(data);
    } catch (err) {
      setError(
        err.response?.data?.message || "Không thể tải danh sách voucher."
      );
    } finally {
      setLoading(false);
    }
  }, [api]);

  useEffect(() => {
    fetchVouchers();
  }, [fetchVouchers]);

  // Handlers (Thêm/Sửa - Giữ nguyên)
  const handleShowAddModal = () => {
    setIsEditMode(false);
    setVoucherToEdit(null);
    setShowModal(true);
  };

  const handleShowEditModal = (voucher) => {
    setIsEditMode(true);
    setVoucherToEdit(voucher);
    setShowModal(true);
  };

  const handleVoucherUpdated = () => {
    fetchVouchers(); // Tải lại danh sách
  };

  // --- HANDLER VÔ HIỆU HÓA ---
  const handleDisable = (maKhuyenMai) => {
    setPendingAction({ code: maKhuyenMai, action: "disable" });
    setShowConfirmModal(true);
  };

  // --- HANDLER KÍCH HOẠT ---
  const handleEnable = (maKhuyenMai) => {
    setPendingAction({ code: maKhuyenMai, action: "enable" });
    setShowConfirmModal(true);
  };

  // --- HÀM XÁC NHẬN CHUNG (GỌI API) ---
  const handleConfirm = async () => {
    if (!pendingAction) return;

    const { code, action } = pendingAction;
    setIsProcessing(true); // Bật loading

    try {
      if (action === "disable") {
        // API Vô hiệu hóa
        await api.put(`/vouchers/admin/${code}/disable`);
        toast.success("Đã vô hiệu hóa voucher.");
      } else if (action === "enable") {
        // API Kích hoạt lại
        await api.put(`/vouchers/admin/${code}/enable`);
        toast.success("Đã kích hoạt lại voucher.");
      }
      fetchVouchers(); // Tải lại danh sách
    } catch (err) {
      toast.error(err.response?.data?.message || "Thao tác thất bại.");
    } finally {
      setIsProcessing(false); // Tắt loading
      setPendingAction(null);
      setShowConfirmModal(false);
    }
  };

  // --- Cấu hình Modal Xác nhận (Dựa trên 'action') ---
  const getModalConfig = () => {
    if (!pendingAction) return {};

    if (pendingAction.action === "disable") {
      return {
        title: "Xác nhận Vô hiệu hóa Voucher",
        message: `Bạn có chắc chắn muốn VÔ HIỆU HÓA voucher "${pendingAction.code}"? Voucher này sẽ bị ẩn.`,
        confirmText: "Vô hiệu hóa",
        variant: "danger",
      };
    }

    if (pendingAction.action === "enable") {
      return {
        title: "Xác nhận Kích hoạt Voucher",
        message: `Bạn có chắc chắn muốn KÍCH HOẠT LẠI voucher "${pendingAction.code}"?`,
        confirmText: "Kích hoạt",
        variant: "success", // Đổi màu nút thành Xanh
      };
    }
    return {};
  };

  const modalConfig = getModalConfig();

  return (
    <AdminLayout>
      <Card className="shadow-sm">
        <Card.Header className="d-flex justify-content-between align-items-center">
          <h5>Quản lý Khuyến mãi/Voucher ({vouchers.length})</h5>
          <Button variant="primary" size="sm" onClick={handleShowAddModal}>
            <Plus /> Thêm Voucher
          </Button>
        </Card.Header>
        <Card.Body>
          {loading ? (
            <div className="text-center">
              <Spinner animation="border" size="sm" /> Đang tải...
            </div>
          ) : error ? (
            <Alert variant="danger">{error}</Alert>
          ) : (
            <Table striped hover responsive size="sm" className="align-middle">
              <thead>
                <tr>
                  <th>Mã KM</th>
                  <th>Tên Chương trình</th>
                  <th>Giá trị</th>
                  <th>Hạn dùng</th>
                  <th>Tồn</th>
                  <th>Trạng Thái</th>
                  <th>Thao tác</th>
                </tr>
              </thead>
              <tbody>
                {vouchers.map((v) => {
                  const isExpired = new Date(v.NgayKetThuc) < new Date();
                  const isOutOfStock = v.SoLuongToiDa === 0;
                  const isActive = v.TrangThai === "ACTIVE"; // Kiểm tra trạng thái

                  let stockBadge = "success";
                  if (isOutOfStock) stockBadge = "danger";
                  else if (v.SoLuongToiDa <= 5) stockBadge = "warning";

                  return (
                    <tr
                      key={v.MaKhuyenMai}
                      className={!isActive ? "table-secondary" : ""}
                    >
                      <td>
                        <strong
                          className={
                            isExpired || !isActive
                              ? "text-danger"
                              : "text-primary"
                          }
                        >
                          {v.MaKhuyenMai}
                        </strong>
                      </td>
                      <td>{v.TenKhuyenMai}</td>
                      <td>
                        {v.LoaiGiamGia === "PHANTRAM"
                          ? `${v.GiaTriGiam}%`
                          : formatCurrency(v.GiaTriGiam)}
                      </td>
                      <td>
                        <span
                          className={isExpired ? "text-danger fw-bold" : ""}
                        >
                          {formatDate(v.NgayKetThuc)}
                        </span>
                        {isExpired && (
                          <Badge bg="secondary" className="ms-1">
                            Hết hạn
                          </Badge>
                        )}
                      </td>
                      <td>
                        <Badge bg={stockBadge}>
                          {isOutOfStock ? "Hết lượt" : v.SoLuongToiDa}
                        </Badge>
                      </td>
                      <td>
                        <Badge bg={isActive ? "success" : "secondary"}>
                          {isActive ? "Hoạt động" : "Vô hiệu hóa"}
                        </Badge>
                      </td>
                      <td>
                        <Button
                          variant="warning"
                          size="sm"
                          className="me-2"
                          onClick={() => handleShowEditModal(v)}
                          disabled={isProcessing}
                        >
                          <PencilSquare />
                        </Button>

                        {/* === SỬA LỖI LOGIC NÚT BẤM === */}
                        <Button
                          variant={isActive ? "danger" : "success"}
                          size="sm"
                          onClick={() => {
                            if (isActive) {
                              handleDisable(v.MaKhuyenMai); // Gọi Vô hiệu hóa
                            } else {
                              handleEnable(v.MaKhuyenMai); // Gọi Kích hoạt lại
                            }
                          }}
                          disabled={isProcessing}
                          title={isActive ? "Vô hiệu hóa" : "Kích hoạt lại"}
                        >
                          {isActive ? <Trash /> : <ArrowReturnLeft />}
                        </Button>
                        {/* ============================= */}
                      </td>
                    </tr>
                  );
                })}
              </tbody>
            </Table>
          )}
        </Card.Body>
      </Card>

      {/* MODAL THÊM/SỬA VOUCHER */}
      <AdminVoucherModal
        show={showModal}
        onHide={() => setShowModal(false)}
        onVoucherUpdated={handleVoucherUpdated}
        isEdit={isEditMode}
        voucherToEdit={voucherToEdit}
      />

      {/* MODAL XÁC NHẬN (ĐÃ CẬP NHẬT) */}
      <ConfirmModal
        show={showConfirmModal}
        onHide={() => {
          if (!isProcessing) {
            setShowConfirmModal(false);
            setPendingAction(null);
          }
        }}
        onConfirm={handleConfirm}
        title={modalConfig.title}
        message={modalConfig.message}
        confirmText={modalConfig.confirmText}
        confirmVariant={modalConfig.variant}
        isProcessing={isProcessing}
      />
    </AdminLayout>
  );
};

export default AdminVoucherListPage;
