// client/src/components/AdminLayout.jsx (Sườn Layout)

import React from "react";
import { Container, Row, Col, Nav } from "react-bootstrap";
import { Link, NavLink } from "react-router-dom";
import {
  Speedometer,
  BoxSeam,
  List,
  People,
  ArrowReturnLeft,
  Gift,
  StarFill,
} from "react-bootstrap-icons"; // Icons

const AdminLayout = ({ children }) => {
  return (
    <Container fluid className="py-5 admin-container">
      <Row>
        {/* Sidebar Admin */}
        <Col md={3} lg={2}>
          <div className="admin-sidebar shadow-sm p-3 bg-light rounded">
            <h4 className="mb-4 fw-bold">Admin Panel</h4>
            <Nav className="flex-column">
              <Nav.Link as={NavLink} to="/admin/dashboard" className="mb-2">
                <Speedometer className="me-2" />
                Dashboard
              </Nav.Link>
              <Nav.Link as={NavLink} to="/admin/products" className="mb-2">
                <BoxSeam className="me-2" />
                Sản phẩm
              </Nav.Link>
              <Nav.Link as={NavLink} to="/admin/categories" className="mb-2">
                <List className="me-2" />
                Danh mục & Thuộc tính
              </Nav.Link>
              <Nav.Link as={NavLink} to="/admin/orders" className="mb-2">
                <BoxSeam className="me-2" />
                Đơn hàng
              </Nav.Link>
              <Nav.Link as={NavLink} to="/admin/users" className="mb-2">
                <People className="me-2" />
                Người dùng
              </Nav.Link>
              <Nav.Link as={NavLink} to="/admin/returns" className="mb-2">
                <ArrowReturnLeft className="me-2" />
                Yêu cầu đổi trả
              </Nav.Link>
              <Nav.Link as={NavLink} to="/admin/vouchers" className="mb-2">
                <Gift className="me-2" />
                Mã khuyến mãi
              </Nav.Link>
              <Nav.Link as={NavLink} to="/admin/reviews" className="mb-2">
                <StarFill className="me-2" />
                Đánh giá
              </Nav.Link>
            </Nav>
          </div>
        </Col>

        {/* Nội dung Admin */}
        <Col md={9} lg={10}>
          <div className="admin-content-wrapper">{children}</div>
        </Col>
      </Row>
    </Container>
  );
};

export default AdminLayout;
