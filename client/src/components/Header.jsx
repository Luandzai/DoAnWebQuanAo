// client/src/components/Header.jsx (Bản đầy đủ, đã thêm Badge)

import React, { useContext, useState } from "react";
import {
  Navbar,
  Nav,
  Container,
  Form,
  InputGroup,
  Button,
  NavDropdown,
  Badge,
} from "react-bootstrap"; // 1. Import Badge
import { Link, useNavigate } from "react-router-dom";
import { Telephone, Search, Person, Cart } from "react-bootstrap-icons";
import "./Header.css";
import AuthContext from "../context/AuthContext";
import CartContext from "../context/CartContext"; // 2. IMPORT CART CONTEXT

const Header = () => {
  const { user, logout } = useContext(AuthContext);
  const { cartItems } = useContext(CartContext); // 3. LẤY 'cartItems'

  const [keyword, setKeyword] = useState("");
  const navigate = useNavigate();

  const searchHandler = (e) => {
    e.preventDefault();
    if (keyword.trim()) {
      navigate(`/products?search=${keyword}`);
      setKeyword("");
    } else {
      navigate("/products");
    }
  };

  // 4. Tính số lượng (theo ID sản phẩm)
  const cartItemCount = cartItems.length;

  return (
    <header className="header-container shadow-sm">
      {/* Thanh Top-bar */}
      <div className="top-bar bg-dark text-white">
        <Container fluid className="d-flex justify-content-between">
          <span>
            <Telephone size={14} /> Hỗ trợ khách hàng: 1800.1000
          </span>
          <span></span>
        </Container>
      </div>

      {/* Thanh Navbar chính */}
      <Navbar bg="white" variant="light" expand="lg" className="main-navbar">
        <Container fluid>
          {/* Logo */}
          <Navbar.Brand as={Link} to="/" className="fw-bold fs-4">
            BLANK CANVAS
          </Navbar.Brand>

          {/* Nút Hamburger (Mobile) */}
          <Navbar.Toggle aria-controls="main-navbar-nav" />

          {/* Nội dung Navbar */}
          <Navbar.Collapse id="main-navbar-nav">
            {/* Các link điều hướng (Căn giữa) */}
            <Nav className="mx-auto nav-links">
              <Nav.Link as={Link} to="/products">
                TẤT CẢ SẢN PHẨM
              </Nav.Link>
              <Nav.Link as={Link} to="/products?category=do-nam">
                ĐỒ NAM
              </Nav.Link>
              <Nav.Link as={Link} to="/products?category=do-nu">
                ĐỒ NỮ
              </Nav.Link>
              <Nav.Link as={Link} to="/products?category=do-the-thao">
                ĐỒ THỂ THAO
              </Nav.Link>
              <Nav.Link as={Link} to="/products?category=do-da">
                ĐỒ DA
              </Nav.Link>
              <Nav.Link as={Link} to="/products?category=phu-kien">
                PHỤ KIỆN
              </Nav.Link>
              <Nav.Link as={Link} to="/news">
                TIN TỨC
              </Nav.Link>
              <Nav.Link as={Link} to="/contact">
                LIÊN HỆ
              </Nav.Link>
            </Nav>

            {/* Ô tìm kiếm và Icons (Căn phải) */}
            <Nav className="align-items-center nav-icons">
              {/* Form tìm kiếm */}
              <Form
                className="d-flex me-3 search-form"
                onSubmit={searchHandler}
              >
                <InputGroup size="sm">
                  <Form.Control
                    type="search"
                    placeholder="Tìm kiếm..."
                    aria-label="Tìm kiếm"
                    value={keyword}
                    onChange={(e) => setKeyword(e.target.value)}
                  />
                  <Button
                    type="submit"
                    variant="outline-secondary"
                    className="search-button"
                  >
                    <Search />
                  </Button>
                </InputGroup>
              </Form>

              {/* Icon Tài khoản */}
              {user ? (
                <NavDropdown
                  title={`Xin chào, ${user.hoTen}`}
                  id="user-nav-dropdown"
                >
                  <NavDropdown.Item as={Link} to="/profile">
                    Thông tin tài khoản
                  </NavDropdown.Item>
                  {user.vaiTro === "ADMIN" && (
                    <NavDropdown.Item as={Link} to="/admin/dashboard">
                      Trang Admin
                    </NavDropdown.Item>
                  )}
                  <NavDropdown.Divider />
                  <NavDropdown.Item onClick={logout}>
                    Đăng xuất
                  </NavDropdown.Item>
                </NavDropdown>
              ) : (
                <Nav.Link as={Link} to="/auth" className="nav-icon-link">
                  <Person size={22} />
                </Nav.Link>
              )}

              {/* 5. CẬP NHẬT ICON GIỎ HÀNG */}
              <Nav.Link
                as={Link}
                to="/cart"
                className="nav-icon-link position-relative"
              >
                <Cart size={22} />
                {/* Chỉ hiển thị Badge nếu đã đăng nhập VÀ có hàng */}
                {user && cartItemCount > 0 && (
                  <Badge
                    pill
                    bg="danger"
                    className="position-absolute"
                    style={{
                      top: "-5px",
                      right: "-10px",
                      fontSize: "0.7em",
                    }}
                  >
                    {cartItemCount}
                  </Badge>
                )}
              </Nav.Link>
            </Nav>
          </Navbar.Collapse>
        </Container>
      </Navbar>
    </header>
  );
};

export default Header;
