// client/src/pages/AdminProductListPage.jsx (Refactored)
import React, { useState } from "react";
import { Card } from "react-bootstrap";
import AdminLayout from "../components/AdminLayout";
import AdminProductModal from "../components/AdminProductModal.jsx";
import ConfirmModal from "../components/ConfirmModal.jsx";
import ProductFilters from "../components/ProductFilters.jsx";
import ProductTable from "../components/ProductTable.jsx";
import { useProductsAdmin } from "../hooks/useProductsAdmin.js";

const AdminProductListPage = () => {
    const {
        products,
        loading,
        error,
        pagination,
        deletingId,
        searchTerm,
        setSearchTerm,
        sortBy,
        setSortBy,
        pageSize,
        setPageSize,
        currentPage,
        setCurrentPage,
        deleteProduct,
        refreshProducts,
        SORT_OPTIONS,
    } = useProductsAdmin();

    // State for modals
    const [showModal, setShowModal] = useState(false);
    const [isEditMode, setIsEditMode] = useState(false);
    const [productToEdit, setProductToEdit] = useState(null);
    const [showConfirmDelete, setShowConfirmDelete] = useState(false);
    const [productToDeleteId, setProductToDeleteId] = useState(null);

    const handleShowAddModal = () => {
        setIsEditMode(false);
        setProductToEdit(null);
        setShowModal(true);
    };

    const handleShowEditModal = (product) => {
        setIsEditMode(true);
        setProductToEdit(product);
        setShowModal(true);
    };
    
    const handleProductUpdated = () => {
        refreshProducts();
    };

    const handleDeleteClick = (productId) => {
        setProductToDeleteId(productId);
        setShowConfirmDelete(true);
    };

    const handleConfirmDelete = () => {
        deleteProduct(productToDeleteId);
        setShowConfirmDelete(false);
        setProductToDeleteId(null);
    };

    return (
        <AdminLayout>
            <Card className="shadow-sm">
                <Card.Header className="bg-white">
                    <ProductFilters
                        searchTerm={searchTerm}
                        setSearchTerm={setSearchTerm}
                        sortBy={sortBy}
                        setSortBy={setSortBy}
                        pageSize={pageSize}
                        setPageSize={setPageSize}
                        sortOptions={SORT_OPTIONS}
                        totalProducts={pagination.total}
                        onShowAddModal={handleShowAddModal}
                    />
                </Card.Header>

                <Card.Body className="p-0">
                    <ProductTable
                        products={products}
                        loading={loading}
                        error={error}
                        pagination={pagination}
                        setCurrentPage={setCurrentPage}
                        onEdit={handleShowEditModal}
                        onDelete={handleDeleteClick}
                        deletingId={deletingId}
                    />
                </Card.Body>
            </Card>

            <AdminProductModal
                show={showModal}
                onHide={() => setShowModal(false)}
                onProductUpdated={handleProductUpdated}
                isEdit={isEditMode}
                productToEdit={productToEdit}
            />

            <ConfirmModal
                show={showConfirmDelete}
                onHide={() => setShowConfirmDelete(false)}
                onConfirm={handleConfirmDelete}
                title="Xác nhận Xóa Sản phẩm"
                message="Bạn có chắc chắn muốn xóa (lưu trữ) sản phẩm này không? Sản phẩm sẽ bị ẩn khỏi trang người dùng."
                confirmText="Xóa"
                confirmVariant="danger"
                isProcessing={!!deletingId}
            />
        </AdminLayout>
    );
};

export default AdminProductListPage;
