import React, { useState, useEffect } from "react";
import {
  Card,
  Button,
  Table,
  Spinner,
  Alert,
  Modal,
  Form,
} from "react-bootstrap";
import AdminLayout from "../components/AdminLayout";
import { toast } from "react-toastify";
import { Plus, PencilSquare, Trash } from "react-bootstrap-icons";
import { useCategories } from '../hooks/useCategories';
import CategoryRow from '../components/CategoryRow';
import CategoryForm from '../components/CategoryForm';

// Component chính
const AdminCategoryPage = () => {
    const {
        categories,
        loading,
        error,
        fetchCategories,
        addCategory,
        updateCategory,
        deleteCategory,
        buildCategoryTree,
    } = useCategories();

    const [showModal, setShowModal] = useState(false);
    const [showDeleteModal, setShowDeleteModal] = useState(false);
    const [isEdit, setIsEdit] = useState(false);
    const [currentCategory, setCurrentCategory] = useState(null);
    const [categoryToDelete, setCategoryToDelete] = useState(null);
    const [modalData, setModalData] = useState({
        TenDanhMuc: "",
        Slug: "",
        DanhMucChaID: "",
    });
    const [modalError, setModalError] = useState("");
    const [modalLoading, setModalLoading] = useState(false);

    useEffect(() => {
        fetchCategories();
    }, [fetchCategories]);

    const handleShowAdd = () => {
        setIsEdit(false);
        setCurrentCategory(null);
        setModalData({ TenDanhMuc: "", Slug: "", DanhMucChaID: "" });
        setShowModal(true);
        setModalError("");
    };

    const handleShowEdit = (category) => {
        setIsEdit(true);
        setCurrentCategory(category);
        setModalData({
            TenDanhMuc: category.TenDanhMuc,
            Slug: category.Slug,
            DanhMucChaID: category.DanhMucChaID || "",
        });
        setShowModal(true);
        setModalError("");
    };

    const handleCloseModal = () => setShowModal(false);

    const handleSubmit = async (e) => {
        e.preventDefault();
        if (!modalData.TenDanhMuc.trim()) {
            setModalError("Tên danh mục không được để trống");
            return;
        }

        setModalLoading(true);
        setModalError("");

        try {
            if (isEdit) {
                await updateCategory(currentCategory.DanhMucID, modalData);
            } else {
                await addCategory(modalData);
            }
            handleCloseModal();
        } catch (err) {
            const errorMessage = err.response?.data?.message || (isEdit ? "Cập nhật thất bại" : "Tạo mới thất bại");
            setModalError(errorMessage);
            // Toast is already handled in the hook
        } finally {
            setModalLoading(false);
        }
    };

    const handleShowDeleteModal = (category) => {
        setCategoryToDelete(category);
        setShowDeleteModal(true);
    };



    const handleCloseDeleteModal = () => {
        setShowDeleteModal(false);
        setCategoryToDelete(null);
    };

    const handleConfirmDelete = async () => {
        try {
            await deleteCategory(categoryToDelete.DanhMucID);
            handleCloseDeleteModal();
        } catch (err) {
            // Toast is already handled in the hook
            handleCloseDeleteModal();
        }
    };

    const categoryTree = buildCategoryTree(categories);
    const parentCategories = categories.filter(
        (cat) =>
        !cat.DanhMucChaID &&
        (!isEdit || cat.DanhMucID !== currentCategory?.DanhMucID)
    );

    return (
        <AdminLayout>
            <Card className="shadow-sm">
                <Card.Header className="d-flex justify-content-between align-items-center">
                    <h5>Quản lý Danh mục</h5>
                    <Button variant="primary" size="sm" onClick={handleShowAdd}>
                        <Plus /> Thêm Danh mục
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
                            <th>ID</th>
                            <th>Tên Danh mục</th>
                            <th>Slug</th>
                            <th>Thao tác</th>
                            </tr>
                        </thead>
                        <tbody>
                            {categoryTree.map((cat) => (
                            <CategoryRow
                                key={cat.DanhMucID}
                                cat={cat}
                                level={0}
                                onEdit={handleShowEdit}
                                onDelete={handleShowDeleteModal}
                            />
                            ))}
                        </tbody>
                        </Table>
                    )}
                </Card.Body>
            </Card>

            {/* Modal Thêm/Sửa Danh mục */}
            <Modal show={showModal} onHide={handleCloseModal} centered>
                <Modal.Header closeButton>
                <Modal.Title>
                    {isEdit ? "Cập nhật Danh mục" : "Thêm Danh mục mới"}
                </Modal.Title>
                </Modal.Header>
                <Modal.Body>
                    <CategoryForm
                        modalData={modalData}
                        setModalData={setModalData}
                        handleSubmit={handleSubmit}
                        modalLoading={modalLoading}
                        isEdit={isEdit}
                        parentCategories={parentCategories}
                        modalError={modalError}
                    />
                </Modal.Body>
            </Modal>

            {/* Delete Confirmation Modal */}
            <Modal show={showDeleteModal} onHide={handleCloseDeleteModal} centered>
                <Modal.Header closeButton>
                <Modal.Title>Xác nhận xóa danh mục</Modal.Title>
                </Modal.Header>
                <Modal.Body>
                {categoryToDelete && (
                    <p>
                    Bạn có chắc chắn muốn xóa danh mục "
                    <strong>{categoryToDelete.TenDanhMuc}</strong>"?
                    {categoryToDelete.children?.length > 0 && (
                        <Alert variant="warning" className="mt-2">
                        Lưu ý: Danh mục này có {categoryToDelete.children.length} danh
                        mục con. Việc xóa có thể không thành công nếu có sản phẩm liên
                        quan.
                        </Alert>
                    )}
                    </p>
                )}
                </Modal.Body>
                <Modal.Footer>
                <Button variant="secondary" onClick={handleCloseDeleteModal}>
                    Hủy bỏ
                </Button>
                <Button variant="danger" onClick={handleConfirmDelete}>
                    Xác nhận xóa
                </Button>
                </Modal.Footer>
            </Modal>
        </AdminLayout>
    );
};

export default AdminCategoryPage;
