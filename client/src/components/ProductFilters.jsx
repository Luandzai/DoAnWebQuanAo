// client/src/components/ProductFilters.jsx
import React from 'react';
import { Row, Col, Form, InputGroup, Button } from 'react-bootstrap';
import { Search, Plus } from 'react-bootstrap-icons';

const ProductFilters = ({
    searchTerm,
    setSearchTerm,
    sortBy,
    setSortBy,
    pageSize,
    setPageSize,
    sortOptions,
    totalProducts,
    onShowAddModal,
}) => {
    return (
        <Row className="align-items-center">
            <Col md={5}>
                <h5 className="mb-0">Quản lý Sản phẩm ({totalProducts})</h5>
            </Col>

            <Col md={3}>
                <InputGroup size="sm">
                    <InputGroup.Text><Search /></InputGroup.Text>
                    <Form.Control
                        placeholder="Tìm theo tên, SKU..."
                        value={searchTerm}
                        onChange={(e) => setSearchTerm(e.target.value)}
                    />
                </InputGroup>
            </Col>

            <Col md={2}>
                <Form.Select
                    size="sm"
                    value={sortBy}
                    onChange={(e) => setSortBy(e.target.value)}
                >
                    {Object.values(sortOptions).map((option) => (
                        <option key={option.key} value={option.key}>
                            {option.name}
                        </option>
                    ))}
                </Form.Select>
            </Col>

            <Col md={2} className="d-flex justify-content-end align-items-center">
                <Form.Select
                    size="sm"
                    value={pageSize}
                    onChange={(e) => setPageSize(Number(e.target.value))}
                    className="me-2"
                >
                    {[10, 20, 50].map((size) => (
                        <option key={size} value={size}>
                            {size} dòng / trang
                        </option>
                    ))}
                </Form.Select>
                <Button variant="primary" size="sm" onClick={onShowAddModal}>
                    <Plus />
                </Button>
            </Col>
        </Row>
    );
};

export default ProductFilters;
