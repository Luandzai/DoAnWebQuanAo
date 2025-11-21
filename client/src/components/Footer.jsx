// client/src/components/Footer.jsx

import React from "react";
import {
  Container,
  Row,
  Col,
  Nav,
  Form, // Thêm Form
  InputGroup, // Thêm InputGroup
  FormControl, // Thêm FormControl
  Button, // Thêm Button
} from "react-bootstrap";
import { Link } from "react-router-dom";
import { GeoAlt, Telephone, Facebook, Envelope } from "react-bootstrap-icons"; // Import các icon
// 1. Import file CSS tùy chỉnh
import "./Footer.css";

const Footer = () => {
  return (
    // 'mt-auto' tự động đẩy footer xuống dưới nếu trang ngắn
    // Đổi màu nền (bg-dark) để phù hợp với màu nền của ảnh mẫu (màu xám đậm hơn)
    <footer className="footer-container text-light mt-auto py-5">
      <Container fluid>
        <Row>
          {/* CỘT 1: VỀ CHÚNG TÔI - Chiếm 5/12 cột (theo tỉ lệ ảnh) */}
          <Col md={8} className="mb-4">
            <h5 className="fw-bold mb-3">VỀ CHÚNG TÔI</h5>
            <p className="footer-text large-text">
              Vương-Group - Khoác lên mình niềm vui gia đình Việt Nam 2022. Công
              ty cổ phần Thương mại và Dịch vụ Vương -Group được thành lập với
              mục đích chính ban đầu là hoạt động trong lĩnh vực sản xuất hàng
              thời trang xuất khẩu với các sản phẩm chủ yếu là tơ lụa và sợi.
              Năm 2023 thương hiệu thời trang VPS ra đời, tự hào trở thành một
              cột mốc đáng nhớ của doanh nghiệp Việt trong ngành thời trang.
              Mang đến niềm vui cho hàng triệu gia đình Việt VPS hướng đến mục
              tiêu mang lại niềm vui mỗi ngày cho hàng triệu người tiêu dùng
              Việt. Chúng tôi tin rằng người dân Việt Nam cũng đang hướng đến
              một cuộc sống năng động, tích cực hơn.
            </p>
          </Col>

          {/* CỘT 2: ĐƯỜNG DẪN - Giữ nguyên cấu trúc link, thay đổi tiêu đề */}
          <Col md={2} className="mb-4">
            <h5 className="fw-bold mb-3">ĐƯỜNG DẪN</h5>
            <Nav className="flex-column footer-links">
              <Nav.Link as={Link} to="/">
                Trang chủ
              </Nav.Link>
              <Nav.Link as={Link} to="/news">
                Về chúng tôi
              </Nav.Link>
              <Nav.Link as={Link} to="/contact">
                Thông tin liên hệ
              </Nav.Link>
            </Nav>
          </Col>

          {/* CỘT 3: THÔNG TIN LIÊN HỆ - Chiếm 4/12 cột */}
          <Col md={2} className="mb-4">
            <h5 className="fw-bold mb-3">THÔNG TIN LIÊN HỆ</h5>
            <ul className="list-unstyled contact-list">
              <li>
                <GeoAlt size={16} className="me-2" />
                <span>Địa chỉ: 38 Linh Dông TP.HCM</span>
              </li>
              <li>
                <Telephone size={16} className="me-2" />
                <span>+84 812422901</span>
              </li>
              {/* CẬP NHẬT LINK FACEBOOK */}
              <li>
                <a
                  href="https://www.facebook.com/profile.php?id=61583922954340"
                  target="_blank"
                  rel="noopener noreferrer"
                  className="text-light-subtle d-flex align-items-start text-decoration-none"
                >
                  <Facebook size={16} className="me-2" />
                  <span>Facebook</span>
                </a>
              </li>
              <li>
                <Envelope size={16} className="me-2" />
                <span>blankcanvas.hotro@gmail.com</span>
              </li>
            </ul>
          </Col>
        </Row>
      </Container>
    </footer>
  );
};

export default Footer;
