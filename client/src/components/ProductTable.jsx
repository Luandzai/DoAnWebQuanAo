// client/src/components/ProductTable.jsx
import React from 'react';
import { Table, Spinner, Alert, Pagination, Button, Image } from 'react-bootstrap';
import { EyeFill, PencilSquare, Trash, ArrowDownUp } from 'react-bootstrap-icons';
import { Link } from 'react-router-dom';

const ProductTable = ({
    products,
    loading,
    error,
    pagination,
    setCurrentPage,
    onEdit,
    onDelete,
    deletingId,
}) => {

    const formatCurrency = (amount) => {
        return new Intl.NumberFormat("vi-VN", {
            style: "currency",
            currency: "VND",
        }).format(amount || 0);
    };

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

    if (products.length === 0) {
        return <div className="text-center py-5"><p className="mb-0 text-muted">Không tìm thấy sản phẩm nào</p></div>;
    }

    return (
        <>
            <Table hover responsive className="align-middle mb-0">
                <thead className="bg-light">
                    <tr>
                        <th>ID</th>
                        <th>Ảnh</th>
                        <th>Tên Sản phẩm</th>
                        <th><div className="d-flex align-items-center">Giá bán<ArrowDownUp className="ms-1" /></div></th>
                        <th><div className="d-flex align-items-center">Tồn kho<ArrowDownUp className="ms-1" /></div></th>
                        <th>Thao tác</th>
                    </tr>
                </thead>
                <tbody>
                    {products.map((p) => (
                        <tr key={p.SanPhamID}>
                            <td>{p.SanPhamID}</td>
                            <td>
                                <Image
                                    src={p.HinhAnhChinh || "https://placehold.co/50x50?text=No+Img"}
                                    style={{ width: "50px", height: "50px", objectFit: "cover" }}
                                    thumbnail
                                />
                            </td>
                            <td>{p.TenSanPham}</td>
                            <td>{formatCurrency(p.GiaBanThapNhat)}</td>
                            <td>{p.TongTonKho}</td>
                            <td>
                                <Button as={Link} to={`/product/${p.Slug}`} variant="info" size="sm" className="me-2" title="Xem trên website">
                                    <EyeFill />
                                </Button>
                                <Button variant="warning" size="sm" className="me-2" onClick={() => onEdit(p)}>
                                    <PencilSquare />
                                </Button>
                                <Button variant="danger" size="sm" onClick={() => onDelete(p.SanPhamID)} disabled={deletingId === p.SanPhamID}>
                                    {deletingId === p.SanPhamID ? <Spinner as="span" size="sm" animation="border" /> : <Trash />}
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

export default ProductTable;
