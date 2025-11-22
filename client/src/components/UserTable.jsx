// client/src/components/UserTable.jsx
import React from 'react';
import { Table, Spinner, Alert, Pagination, Button, Badge } from 'react-bootstrap';
import { PersonFill } from 'react-bootstrap-icons';

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

const UserTable = ({
    users,
    loading,
    error,
    pagination,
    setCurrentPage,
    onRoleChange,
    onStatusChange,
    updatingId,
    currentUserId,
}) => {

    const formatDate = (dateString) => new Date(dateString).toLocaleDateString("vi-VN");

    const renderPagination = () => {
        if (!pagination.totalPages || pagination.totalPages <= 1) return null;
        let items = [];
        for (let number = 1; number <= pagination.totalPages; number++) {
            items.push(
                <Pagination.Item key={number} active={number === pagination.page} onClick={() => setCurrentPage(number)}>
                    {number}
                </Pagination.Item>,
            );
        }
        return (
            <div className="d-flex justify-content-center p-3">
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
    if (users.length === 0) {
        return <div className="text-center py-5"><p className="mb-0 text-muted">Không tìm thấy người dùng nào.</p></div>;
    }

    return (
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
                        const isSelf = user.NguoiDungID === currentUserId;
                        const statusConfig = STATUS_OPTIONS[user.TrangThai] || {};
                        const roleConfig = ROLE_OPTIONS[user.VaiTro] || {};
                        const authMethod = AUTH_OPTIONS[user.LoaiXacThuc] || user.LoaiXacThuc;

                        return (
                            <tr key={user.NguoiDungID}>
                                <td>{user.NguoiDungID}</td>
                                <td>
                                    <strong className="d-block">{user.HoTen}</strong>
                                    <small className="text-muted">{user.Email}</small>
                                    <small className="d-block text-info">{user.DienThoai}</small>
                                </td>
                                <td>
                                    <Badge bg={roleConfig.color}>{roleConfig.name}</Badge>
                                    {isSelf && <Badge bg="dark" className="ms-1">Bạn</Badge>}
                                </td>
                                <td><Badge bg={user.LoaiXacThuc === 'GOOGLE' ? 'danger' : 'secondary'}>{authMethod}</Badge></td>
                                <td><Badge bg={statusConfig.color}>{statusConfig.name}</Badge></td>
                                <td>{formatDate(user.NgayTao)}</td>
                                <td>
                                    <Button
                                        variant="warning"
                                        size="sm"
                                        className="me-2"
                                        onClick={() => onRoleChange(user.NguoiDungID, user.VaiTro)}
                                        title="Thay đổi Vai trò"
                                        disabled={updatingId === user.NguoiDungID || isSelf}
                                    >
                                        {updatingId === user.NguoiDungID ? <Spinner animation="border" size="sm" /> : <PersonFill />}
                                    </Button>
                                    <Button
                                        variant={user.TrangThai === 'ACTIVE' ? 'danger' : 'success'}
                                        size="sm"
                                        onClick={() => onStatusChange(user.NguoiDungID, user.TrangThai)}
                                        title={user.TrangThai === 'ACTIVE' ? 'Khóa tài khoản' : 'Mở khóa tài khoản'}
                                        disabled={updatingId === user.NguoiDungID || isSelf}
                                    >
                                        {updatingId === user.NguoiDungID ? <Spinner animation="border" size="sm" /> : (user.TrangThai === 'ACTIVE' ? 'Khóa' : 'Mở khóa')}
                                    </Button>
                                </td>
                            </tr>
                        );
                    })}
                </tbody>
            </Table>
            {renderPagination()}
        </>
    );
};

export default UserTable;
