// client/src/components/ReturnRequestTable.jsx
import React from 'react';
import { Table, Spinner, Alert, Pagination, Button, Badge } from 'react-bootstrap';
import { EyeFill } from 'react-bootstrap-icons';

const STATUS_OPTIONS = {
    PENDING: { name: "Chờ xử lý", color: "warning" },
    APPROVED: { name: "Đã phê duyệt", color: "primary" },
    REJECTED: { name: "Đã từ chối", color: "danger" },
    COMPLETED: { name: "Đã hoàn tất", color: "success" },
};

const ReturnRequestTable = ({
    returnsList,
    loading,
    error,
    pagination,
    setCurrentPage,
    onViewDetail
}) => {

    const formatCurrency = (amount) => new Intl.NumberFormat("vi-VN", { style: "currency", currency: "VND" }).format(amount || 0);
    const formatDate = (dateString) => new Date(dateString).toLocaleDateString("vi-VN");

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

    if (returnsList.length === 0) {
        return <div className="text-center py-5"><p className="mb-0 text-muted">Không tìm thấy yêu cầu nào.</p></div>;
    }

    return (
        <>
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
                            <td><strong className="text-primary">#{req.ReturnID}</strong></td>
                            <td>#{req.DonHangID}</td>
                            <td>
                                <div>{req.TenKhachHang}</div>
                                <small className="text-muted">{req.Email}</small>
                            </td>
                            <td>{formatDate(req.NgayYeuCau)}</td>
                            <td>
                                {req.RefundAmount ? (
                                    <strong className="text-success">{formatCurrency(req.RefundAmount)}</strong>
                                ) : (
                                    <span className="text-muted">Chưa xác định</span>
                                )}
                            </td>
                            <td>
                                <Badge bg={STATUS_OPTIONS[req.Status]?.color}>{STATUS_OPTIONS[req.Status]?.name}</Badge>
                            </td>
                            <td>
                                <Button variant="info" size="sm" onClick={() => onViewDetail(req.ReturnID)} className="me-2">
                                    <EyeFill /> Chi tiết
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

export default ReturnRequestTable;
