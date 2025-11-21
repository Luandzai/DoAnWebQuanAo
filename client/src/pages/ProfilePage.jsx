// client/src/pages/ProfilePage.jsx

import React, { useContext } from "react";
import { Container, Row, Col, Nav, Image } from "react-bootstrap";
// NavLink: Giống như <Link> nhưng nó biết khi nào "active"
// Outlet: Là nơi các component con (như Form) sẽ được render
import { NavLink, Outlet } from "react-router-dom";
import { PersonCircle } from "react-bootstrap-icons"; // Icon avatar

import AuthContext from "../context/AuthContext";
import "./ProfilePage.css"; // Import CSS

const ProfilePage = () => {
  const { user } = useContext(AuthContext); // Lấy user từ context

  // Nếu chưa kịp load user (ví dụ: F5)
  if (!user) {
    return (
      <Container className="py-5 text-center">
        <p>Đang tải thông tin...</p>
      </Container>
    );
  }

  return (
    <Container fluid className="py-5">
      <Row>
        {/* === CỘT 1: SIDEBAR (Menu) === */}
        <Col md={3}>
          <div className="profile-sidebar">
            {/* Avatar và Tên */}
            <div className="text-center mb-4">
              <PersonCircle size={80} className="profile-avatar" />
              <h5 className="mt-2 mb-0">{user.hoTen}</h5>
              <small className="text-muted">{user.email}</small>
            </div>

            {/* Menu (Dùng NavLink) */}
            <Nav className="flex-column profile-nav" variant="pills">
              {/* 'end' đảm bảo link "/" chỉ active khi khớp chính xác */}
              <Nav.Link as={NavLink} to="/profile" end>
                Cập nhật tài khoản
              </Nav.Link>
              <Nav.Link as={NavLink} to="/profile/orders">
                Đơn hàng
              </Nav.Link>
              <Nav.Link as={NavLink} to="/profile/wishlist">
                Sản phẩm yêu thích
              </Nav.Link>
              <Nav.Link as={NavLink} to="/profile/vouchers">
                Mã khuyến mãi
              </Nav.Link>
              <Nav.Link as={NavLink} to="/profile/returns">
                Đổi trả của tôi
              </Nav.Link>
            </Nav>
          </div>
        </Col>

        {/* === CỘT 2: NỘI DUNG (Content) === */}
        <Col md={9}>
          <div className="profile-content-card">
            {/* Đây là nơi các component con (Update, Orders...) sẽ hiển thị */}
            <Outlet />
          </div>
        </Col>
      </Row>
    </Container>
  );
};

export default ProfilePage;
