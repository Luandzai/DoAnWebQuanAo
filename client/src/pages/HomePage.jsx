// client/src/pages/HomePage.jsx (Refactored)
import React from "react";
import { Container, Row, Col, Spinner, Alert } from "react-bootstrap";
import { useHomePageData } from '../hooks/useHomePageData';

// Import UI components
import HeroCarousel from "../components/HeroCarousel";
import PromoBanners from "../components/PromoBanners";
import ProductCard from "../components/ProductCard";
import CategoryProductSlider from "../components/CategoryProductSlider";

// Helper component to render product grids
const ProductGrid = ({ title, items }) => (
    <>
        <h2 className="my-4 fw-bold text-center">{title}</h2>
        {items && items.length > 0 ? (
            <Row>
                {items.map((product) => (
                    <Col key={product.SanPhamID} xs={6} sm={6} md={4} lg={3}>
                        <ProductCard product={product} />
                    </Col>
                ))}
            </Row>
        ) : (
            <p className="text-center text-muted">Không có sản phẩm nào để hiển thị.</p>
        )}
    </>
);

const HomePage = () => {
    const {
        bestSellingProducts,
        newestProducts,
        categories,
        loading,
        error
    } = useHomePageData();

    return (
        <>
            <HeroCarousel />
            <Container fluid className="py-5">
                {loading ? (
                    <div className="text-center" style={{ minHeight: '50vh' }}>
                        <Spinner animation="border" />
                    </div>
                ) : error ? (
                    <Alert variant="danger">{error}</Alert>
                ) : (
                    <>
                        <ProductGrid title="SẢN PHẨM BÁN CHẠY 🔥" items={bestSellingProducts} />
                        <ProductGrid title="SẢN PHẨM MỚI NHẤT ⚡" items={newestProducts} />
                        
                        {categories.map((category) => (
                            <CategoryProductSlider key={category.DanhMucID} category={category} />
                        ))}

                        <PromoBanners />
                    </>
                )}
            </Container>
        </>
    );
};

export default HomePage;
