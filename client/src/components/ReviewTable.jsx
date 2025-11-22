// client/src/components/ReviewTable.jsx
import React from 'react';
import { Table, Spinner, Alert, Pagination, Button } from 'react-bootstrap';
import { Trash, Film, Image as ImageIcon } from 'react-bootstrap-icons';
import StarRating from './StarRating';

const ReviewTable = ({
    reviews,
    loading,
    error,
    pagination,
    setCurrentPage,
    onDelete,
    isProcessing,
}) => {

    const renderPagination = () => {
        if (!pagination.totalPages || pagination.totalPages <= 1) return null;

        let items = [];
        for (let number = 1; number <= pagination.totalPages; number++) {
            items.push(
                <Pagination.Item
                    key={number}
                    active={number === pagination.page}
                    onClick={() => setCurrentPage(number)}
                >
                    {number}
                </Pagination.Item>,
            );
        }

        return (
            <div className="d-flex justify-content-center p-3 border-top">
                <Pagination>
                    <Pagination.First onClick={() => setCurrentPage(1)} disabled={pagination.page === 1} />
                    <Pagination.Prev onClick={() => setCurrentPage(pagination.page - 1)} disabled={pagination.page === 1} />
                    {items}
                    <Pagination.Next onClick={() => setCurrentPage(pagination.page + 1)} disabled={pagination.page === pagination.totalPages} />
                    <Pagination.Last onClick={() => setCurrentPage(pagination.totalPages)} disabled={pagination.page === pagination.totalPages} />
                </Pagination>
            </div>
        );
    };

    if (loading) {
        return <div className="text-center py-5"><Spinner animation="border" /> Đang tải...</div>;
    }

    if (error) {
        return <Alert variant="danger" className="m-3">{error}</Alert>;
    }

    if (reviews.length === 0) {
        return <div className="text-center py-5"><p className="mb-0 text-muted">Không tìm thấy đánh giá nào.</p></div>;
    }

    return (
        <>
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
                            <td><strong>#{r.DanhGiaID}</strong></td>
                            <td>{r.TenSanPham}</td>
                            <td>{r.TenNguoiDung}</td>
                            <td><StarRating value={r.DiemSo} /></td>
                            <td><small>{r.BinhLuan.substring(0, 50)}...</small></td>
                            <td>
                                {r.HinhAnhURL && <ImageIcon size={20} className="me-2" title="Có hình ảnh" />}
                                {r.VideoURL && <Film size={20} title="Có video" />}
                            </td>
                            <td>{new Date(r.NgayTao).toLocaleDateString("vi-VN")}</td>
                            <td>
                                <Button
                                    variant="danger"
                                    size="sm"
                                    onClick={() => onDelete(r.DanhGiaID)}
                                    disabled={isProcessing}
                                >
                                    <Trash />
                                </Button>
                            </td>
                        </tr>
                    ))}
                </tbody>
            </Table>
            {renderPagination()}
        </>
    );
};

export default ReviewTable;
