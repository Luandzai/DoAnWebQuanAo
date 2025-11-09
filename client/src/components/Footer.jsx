// client/src/components/Footer.jsx

import React from "react";
import { Container, Row, Col, Nav } from "react-bootstrap";
import { Link } from "react-router-dom";
// 1. Import file CSS tùy chỉnh
import "./Footer.css";

const Footer = () => {
  return (
    // 'mt-auto' tự động đẩy footer xuống dưới nếu trang ngắn
    <footer className="footer-container bg-dark text-light mt-auto py-5">
      <Container fluid>
        <Row>
          {/* CỘT 1: GIỚI THIỆU/LOGO */}
          <Col md={3} className="mb-4">
            <h5 className="fw-bold mb-3">BLANK CANVAS</h5>
            <p className="footer-text">
              © 2025 SUPERSTAR
              <br />
              Chuyên cung cấp các sản phẩm thời trang Local Brand và quốc tế.
            </p>
          </Col>

          {/* CỘT 2: VỀ CHÚNG TÔI */}
          <Col md={3} className="mb-4">
            <h5 className="fw-bold mb-3">VỀ CHÚNG TÔI</h5>
            <Nav className="flex-column footer-links">
              <Nav.Link as={Link} to="/about">
                Câu chuyện thương hiệu
              </Nav.Link>
              <Nav.Link as={Link} to="/services">
                Dịch vụ
              </Nav.Link>
              <Nav.Link as={Link} to="/contact">
                Liên hệ
              </Nav.Link>
            </Nav>
          </Col>

          {/* CỘT 3: THÔNG TIN */}
          <Col md={3} className="mb-4">
            <h5 className="fw-bold mb-3">THÔNG TIN</h5>
            <Nav className="flex-column footer-links">
              <Nav.Link as={Link} to="/faq">
                Câu hỏi thường gặp
              </Nav.Link>
              <Nav.Link as={Link} to="/privacy">
                Chính sách bảo mật
              </Nav.Link>
              <Nav.Link as={Link} to="/shipping">
                Chính sách vận chuyển
              </Nav.Link>
              <Nav.Link as={Link} to="/warranty">
                Chính sách đổi trả
              </Nav.Link>
            </Nav>
          </Col>

          {/* CỘT 4: LIÊN HỆ */}
          <Col md={3} className="mb-4">
            <h5 className="fw-bold mb-3">LIÊN HỆ</h5>
            <ul className="list-unstyled footer-text">
              <li>Hà Nội: 8, Ngõ 8, Quang Đa</li>
              <li>SĐT: 0987.654.321</li>
              <li>Xưởng: Nam Định, Giao Lạc</li>
              <li>SĐT: 0123.456.789</li>
              <li>Email: banquanao@gmail.com</li>
            </ul>
          </Col>
        </Row>
      </Container>
    </footer>
  );
};

export default Footer;
