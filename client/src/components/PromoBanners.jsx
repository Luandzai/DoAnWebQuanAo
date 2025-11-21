// client/src/components/PromoBanners.jsx
import React from "react";
import { Row, Col } from "react-bootstrap";
import { Link } from "react-router-dom";
import "./PromoBanners.css"; // Chúng ta sẽ tạo file này

const PromoBanners = () => {
  return (
    <Row className="my-5">
      {/* Banner Lớn Bên Trái */}
      <Col md={6} className="mb-4">
        <Link
          to="/products"
          className="promo-banner-large"
          style={{
            backgroundImage:
              "url('https://images.unsplash.com/photo-1516762689617-e1cff2b45dbf?fit=crop&w=800&q=80')",
          }}
        >
          <div className="promo-content">
            <h4>Courtside Collection</h4>
            <p>Thời trang thể thao sành điệu</p>
            <span className="btn btn-light btn-sm">MUA NGAY</span>
          </div>
        </Link>
      </Col>

      {/* 2 Banner Nhỏ Bên Phải */}
      <Col md={6}>
        <Row>
          <Col md={12} className="mb-4">
            <Link
              to="/products"
              className="promo-banner-small"
              style={{
                backgroundImage:
                  "url('https://images.unsplash.com/photo-1560769629-975ec94e6a86?fit=crop&w=800&q=80')",
              }}
            >
              <div className="promo-content">
                <h5>Phụ Kiện Năng Động</h5>
                <span className="btn btn-light btn-sm">XEM THÊM</span>
              </div>
            </Link>
          </Col>
          <Col md={12} className="mb-4">
            <Link
              to="/products"
              className="promo-banner-small"
              style={{
                backgroundImage:
                  "url('https://images.unsplash.com/photo-1593030103050-5b091809d068?fit=crop&w=800&q=80')",
              }}
            >
              <div className="promo-content">
                <h5>Giảm Giá Cuối Tuần</h5>
                <span className="btn btn-light btn-sm">SĂN SALE</span>
              </div>
            </Link>
          </Col>
        </Row>
      </Col>
    </Row>
  );
};

export default PromoBanners;
