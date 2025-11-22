// client/src/pages/AdminReviewListPage.jsx (Refactored)
import React, { useState } from "react";
import { Card } from "react-bootstrap";
import AdminLayout from "../components/AdminLayout";
import ConfirmModal from "../components/ConfirmModal";
import ReviewFilters from "../components/ReviewFilters";
import ReviewTable from "../components/ReviewTable";
import { useReviewsAdmin } from "../hooks/useReviewsAdmin";

const AdminReviewListPage = () => {
    const {
        reviews,
        loading,
        error,
        pagination,
        searchTerm,
        setSearchTerm,
        ratingFilter,
        setRatingFilter,
        currentPage,
        setCurrentPage,
        isProcessing,
        deleteReview
    } = useReviewsAdmin();

    // Modal Confirm
    const [showConfirmModal, setShowConfirmModal] = useState(false);
    const [selectedReviewId, setSelectedReviewId] = useState(null);

    const handleDelete = (reviewId) => {
        setSelectedReviewId(reviewId);
        setShowConfirmModal(true);
    };

    const confirmDeletion = async () => {
        if (!selectedReviewId) return;
        await deleteReview(selectedReviewId);
        setShowConfirmModal(false);
        setSelectedReviewId(null);
    };

    return (
        <AdminLayout>
            <h2 className="mb-4">Quản lý Đánh giá</h2>

            <Card className="shadow-sm">
                <Card.Header className="bg-white">
                    <ReviewFilters
                        searchTerm={searchTerm}
                        setSearchTerm={setSearchTerm}
                        ratingFilter={ratingFilter}
                        setRatingFilter={setRatingFilter}
                        totalReviews={pagination.total}
                    />
                </Card.Header>

                <Card.Body className="p-0">
                    <ReviewTable
                        reviews={reviews}
                        loading={loading}
                        error={error}
                        pagination={pagination}
                        setCurrentPage={setCurrentPage}
                        onDelete={handleDelete}
                        isProcessing={isProcessing}
                    />
                </Card.Body>
            </Card>

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
