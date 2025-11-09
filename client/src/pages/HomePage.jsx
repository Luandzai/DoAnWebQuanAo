// client/src/pages/HomePage.jsx (ĐÃ SẮP XẾP LẠI ĐÚNG THỨ TỰ)

import React, { useState, useEffect, useContext } from "react";
import { Container, Row, Col, Spinner, Alert } from "react-bootstrap";

// 1. Import AuthContext để lấy 'api'
import AuthContext from "../context/AuthContext";

// Import các component
import HeroCarousel from "../components/HeroCarousel";
import PromoBanners from "../components/PromoBanners";
import ProductCard from "../components/ProductCard";
import CategoryProductSlider from "../components/CategoryProductSlider"; // Component mới

const HomePage = () => {
  // 3. State mới: Giữ lại state cũ và thêm state cho danh mục
  const [bestSellingProducts, setBestSellingProducts] = useState([]);
  const [newestProducts, setNewestProducts] = useState([]);
  const [categories, setCategories] = useState([]); // State mới
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);
  const { api } = useContext(AuthContext);

  // 4. Dùng useEffect để gọi TẤT CẢ API (Bán chạy, Mới nhất, Danh mục)
  useEffect(() => {
    const fetchHomeData = async () => {
      try {
        setLoading(true);
        setError(null);

        // Gọi 3 API song song
        const bestSellingPromise = api.get("/products/bestselling");
        const newestPromise = api.get("/products/newest");
        const categoryPromise = api.get("/categories"); // API mới

        const [bestSellingRes, newestRes, categoryRes] = await Promise.all([
          bestSellingPromise,
          newestPromise,
          categoryPromise,
        ]);

        setBestSellingProducts(bestSellingRes.data);
        setNewestProducts(newestRes.data);

        // Lọc ra TẤT CẢ CÁC DANH MỤC CON (giống yêu cầu)
        const childCategories = categoryRes.data.filter(
          (cat) => cat.DanhMucChaID !== null
        );
        setCategories(childCategories);
      } catch (err) {
        setError("Không thể tải dữ liệu trang chủ.");
        console.error(err);
      } finally {
        setLoading(false);
      }
    };

    fetchHomeData();
  }, [api]); // Phụ thuộc vào 'api' từ context

  // 5. Component con để render lưới sản phẩm (dùng cho Bán chạy, Mới nhất)
  const ProductGrid = ({ title, items }) => (
    <>
      <h2 className="my-4 fw-bold text-center">{title}</h2>
      <Row>
        {items.length > 0 ? (
          items.map((product) => (
            // Hiển thị 4 sản phẩm 1 hàng (lg={3})
            <Col key={product.SanPhamID} sm={6} md={4} lg={3}>
              <ProductCard product={product} />
            </Col>
          ))
        ) : (
          <p className="text-center">Không có sản phẩm nào để hiển thị.</p>
        )}
      </Row>
    </>
  );

  return (
    <>
      {/* 1. HERO CAROUSEL (Không đổi) */}
      <HeroCarousel />

      {/* 2. KHỐI NỘI DUNG CHÍNH (Trong Container) */}
      <Container fluid className="py-5">
        {/* 6. Kiểm tra trạng thái loading/error */}
        {loading ? (
          <div className="text-center">
            <Spinner animation="border" />
          </div>
        ) : error ? (
          <Alert variant="danger">{error}</Alert>
        ) : (
          <>
            {/* === SẢN PHẨM BÁN CHẠY (Giữ lại) === */}
            <ProductGrid
              title="SẢN PHẨM BÁN CHẠY 🔥"
              items={bestSellingProducts}
            />

            {/* === SẢN PHẨM MỚI NHẤT (Giữ lại) === */}
            <ProductGrid title="SẢN PHẨM MỚI NHẤT ⚡" items={newestProducts} />

            {/* === DANH MỤC (VỊ TRÍ MỚI) === */}
            {/* Lặp qua TẤT CẢ danh mục con và render slider */}
            {categories.map((category) => (
              <CategoryProductSlider
                key={category.DanhMucID}
                category={category}
              />
            ))}

            {/* === PROMO BANNERS (Giữ lại) === */}
            <PromoBanners />
          </>
        )}
      </Container>
    </>
  );
};

export default HomePage;
