// client/src/components/ProductGrid.jsx
import React from 'react';
import { Row, Col, Spinner, Alert, Pagination } from 'react-bootstrap';
import ProductCard from './ProductCard';

const ProductGrid = ({ products, loading, error, pagination, onPageChange }) => {

    const renderPagination = () => {
        if (!pagination || !pagination.totalPages || pagination.totalPages <= 1) return null;
        
        let items = [];
        const { currentPage, totalPages } = pagination;
        let startPage = Math.max(1, currentPage - 2);
        let endPage = Math.min(totalPages, currentPage + 2);

        if (currentPage > 3) {
            items.push(<Pagination.Ellipsis key="start-ellipsis" disabled />);
        }

        for (let number = startPage; number <= endPage; number++) {
            items.push(
                <Pagination.Item key={number} active={number === currentPage} onClick={() => onPageChange(number)}>
                    {number}
                </Pagination.Item>
            );
        }
        
        if (totalPages > endPage) {
            items.push(<Pagination.Ellipsis key="end-ellipsis" disabled />);
        }

        return (
            <Pagination className="justify-content-center mt-4">
                <Pagination.First onClick={() => onPageChange(1)} disabled={currentPage === 1} />
                <Pagination.Prev onClick={() => onPageChange(currentPage - 1)} disabled={currentPage === 1} />
                {items}
                <Pagination.Next onClick={() => onPageChange(currentPage + 1)} disabled={currentPage === totalPages} />
                <Pagination.Last onClick={() => onPageChange(totalPages)} disabled={currentPage === totalPages} />
            </Pagination>
        );
    };

    if (loading) {
        return (
            <div className="text-center py-5" style={{ minHeight: "300px" }}>
                <Spinner animation="border" />
            </div>
        );
    }

    if (error) {
        return <Alert variant="danger">{error}</Alert>;
    }

    if (!products || products.length === 0) {
        return <p className="text-center text-muted">Không có sản phẩm nào khớp với tiêu chí của bạn.</p>;
    }

    return (
        <>
            <Row>
                {products.map((product) => (
                    <Col key={product.SanPhamID} sm={6} lg={4} className="mb-4">
                        <ProductCard product={product} />
                    </Col>
                ))}
            </Row>
            {renderPagination()}
        </>
    );
};

export default ProductGrid;
