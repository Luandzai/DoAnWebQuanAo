// client/src/components/Header.jsx (Phiên bản cuối cùng sửa lỗi NavLink Active)

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
} from "react-bootstrap";
import { Link, useNavigate, NavLink, useLocation } from "react-router-dom"; // Thêm useLocation
import { Telephone, Search, Person, Cart } from "react-bootstrap-icons";
import "./Header.css";
import AuthContext from "../context/AuthContext";
import CartContext from "../context/CartContext";

// Danh sách các danh mục để dễ dàng lặp và quản lý
const CATEGORIES = [
  { name: "TẤT CẢ SẢN PHẨM", category: "tat-ca", path: "/products" },
  { name: "ĐỒ NAM", category: "do-nam" },
  { name: "ĐỒ NỮ", category: "do-nu" },
  { name: "ĐỒ THỂ THAO", category: "do-the-thao" },
  { name: "ĐỒ DA", category: "do-da" },
  { name: "PHỤ KIỆN", category: "phu-kien" },
];

// Hàm kiểm tra category active: Sẽ dùng useLocation để kiểm tra URL hiện tại
const isCategoryActive = (category, location) => {
  if (location.pathname !== "/products") return false;

  const searchParams = new URLSearchParams(location.search);
  const currentCategory = searchParams.get("category");

  // Kiểm tra "TẤT CẢ SẢN PHẨM"
  if (category === "tat-ca") {
    // Active chỉ khi path là /products VÀ KHÔNG có query category
    return !currentCategory;
  }

  // Kiểm tra các category cụ thể
  return currentCategory === category;
};

const Header = () => {
  const { user, logout } = useContext(AuthContext);
  const { cartItems } = useContext(CartContext);

  const [keyword, setKeyword] = useState("");
  const navigate = useNavigate();
  const location = useLocation(); // Lấy đối tượng location hiện tại

  const searchHandler = (e) => {
    e.preventDefault();
    if (keyword.trim()) {
      navigate(`/products?search=${keyword}`);
      setKeyword("");
    } else {
      navigate("/products");
    }
  };

  const handleCategoryClick = (category) => {
    if (category === "tat-ca") {
      navigate("/products");
    } else {
      navigate(`/products?category=${category}`);
    }
  };

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
              {/* Sử dụng map để tạo NavLink cho danh mục */}
              {CATEGORIES.map((item) => (
                <Nav.Link
                  key={item.category}
                  // Chỉ sử dụng NavLink cho các link không có query param,
                  // Ở đây ta dùng Nav.Link thường và tự thêm class 'active'
                  as="div" // Dùng div thay vì NavLink để tránh lỗi active
                  onClick={() => handleCategoryClick(item.category)}
                  className={`nav-link ${
                    isCategoryActive(item.category, location) ? "active" : ""
                  }`}
                  style={{ cursor: "pointer" }} // Thêm cursor để người dùng biết là có thể click
                >
                  {item.name}
                </Nav.Link>
              ))}

              {/* Các link không có query param giữ nguyên */}
              <Nav.Link as={NavLink} to="/news">
                TIN TỨC
              </Nav.Link>
              <Nav.Link as={NavLink} to="/virtual-try-on">
                THỬ ĐỒ ẢO
              </Nav.Link>
              <Nav.Link as={NavLink} to="/contact">
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

              {/* CẬP NHẬT ICON GIỎ HÀNG */}
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
