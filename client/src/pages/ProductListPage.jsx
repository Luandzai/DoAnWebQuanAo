// client/src/pages/ProductListPage.jsx (Refactored)
import React from 'react';
import { Container, Row, Col, DropdownButton, Dropdown, Badge } from 'react-bootstrap';
import { useProductSearch } from '../hooks/useProductSearch';
import Sidebar from '../components/Sidebar';
import ProductGrid from '../components/ProductGrid';

const SortDropdown = ({ sortBy, onSortChange }) => {
    const sortOptions = {
        'newest': 'Mới nhất',
        'price-asc': 'Giá: Thấp đến cao',
        'price-desc': 'Giá: Cao đến thấp',
    };

    return (
        <DropdownButton
            id="dropdown-sort"
            title={sortOptions[sortBy] || 'Sắp xếp'}
            size="sm"
            onSelect={onSortChange}
        >
            <Dropdown.Item eventKey="newest">Mới nhất</Dropdown.Item>
            <Dropdown.Item eventKey="price-asc">Giá: Thấp đến cao</Dropdown.Item>
            <Dropdown.Item eventKey="price-desc">Giá: Cao đến thấp</Dropdown.Item>
        </DropdownButton>
    );
};


const ProductListPage = () => {
    const {
        products,
        loadingProducts,
        error,
        categoryTree,
        attributes,
        loadingSidebar,
        filters,
        handleFilterChange,
        searchKeyword,
        removeSearch,
        sortBy,
        handleSortChange,
        pagination,
        handlePageChange,
    } = useProductSearch();

    return (
        <Container fluid className="py-5">
            <Row>
                <Col md={3}>
                    <Sidebar
                        onFilterChange={handleFilterChange}
                        activeFilters={filters}
                        categoryTree={categoryTree}
                        attributes={attributes}
                        isLoading={loadingSidebar}
                    />
                </Col>
                <Col md={9}>
                    <div className="d-flex justify-content-between align-items-center mb-3">
                        <div>
                            {searchKeyword && (
                                <>
                                    <span className="me-2">Kết quả cho:</span>
                                    <Badge pill bg="info" className="me-1" style={{ cursor: 'pointer' }} onClick={removeSearch}>
                                        {searchKeyword} <span className="fw-bold">X</span>
                                    </Badge>
                                </>
                            )}
                        </div>
                        <SortDropdown sortBy={sortBy} onSortChange={handleSortChange} />
                    </div>

                    <ProductGrid
                        products={products}
                        loading={loadingProducts}
                        error={error}
                        pagination={pagination}
                        onPageChange={handlePageChange}
                    />
                </Col>
            </Row>
        </Container>
    );
};

export default ProductListPage;
