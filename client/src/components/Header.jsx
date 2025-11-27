// client/src/components/Header.jsx (Đã thêm ThemeToggle)

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
import { Link, useNavigate, NavLink, useLocation } from "react-router-dom";
import { Telephone, Search, Person, Cart, Heart } from "react-bootstrap-icons";
import "./Header.css";
import AuthContext from "../context/AuthContext";
import CartContext from "../context/CartContext";
import WishlistContext from "../context/WishlistContext";
// 1. Import ThemeToggle
import ThemeToggle from "./ThemeToggle";

const CATEGORIES = [
  { name: "TẤT CẢ SẢN PHẨM", category: "tat-ca", path: "/products" },
  { name: "ĐỒ NAM", category: "do-nam" },
  { name: "ĐỒ NỮ", category: "do-nu" },
  { name: "ĐỒ THỂ THAO", category: "do-the-thao" },
  { name: "ĐỒ DA", category: "do-da" },
  { name: "PHỤ KIỆN", category: "phu-kien" },
];

const isCategoryActive = (category, location) => {
  if (location.pathname !== "/products") return false;
  const searchParams = new URLSearchParams(location.search);
  const currentCategory = searchParams.get("danhMuc");
  if (category === "tat-ca") {
    return !currentCategory;
  }
  return currentCategory === category;
};

const Header = () => {
  const { user, logout } = useContext(AuthContext);
  const { cartItems } = useContext(CartContext);
  const { wishlist: wishlistItems } = useContext(WishlistContext);

  const [keyword, setKeyword] = useState("");
  const navigate = useNavigate();
  const location = useLocation();

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
      navigate(`/products?danhMuc=${category}`);
    }
  };

  const cartItemCount = cartItems?.length || 0;
  const wishlistItemCount = wishlistItems?.length || 0;

  return (
    <header className="header-container shadow-sm">
      <div className="top-bar bg-dark text-white">
        <Container fluid className="d-flex justify-content-between">
          <span>
            <Telephone size={14} /> Hỗ trợ khách hàng: 1800.1000
          </span>
          <span></span>
        </Container>
      </div>

      <Navbar bg="body" variant="underline" expand="xl" className="main-navbar">
        <Container fluid>
          <Navbar.Brand as={Link} to="/" className="fw-bold fs-4">
            BLANK CANVAS
          </Navbar.Brand>

          <Navbar.Toggle aria-controls="main-navbar-nav" />

          <Navbar.Collapse id="main-navbar-nav">
            <Nav className="mx-auto nav-links">
              {CATEGORIES.map((item) => (
                <Nav.Link
                  key={item.category}
                  as="div"
                  onClick={() => handleCategoryClick(item.category)}
                  className={`nav-link ${
                    isCategoryActive(item.category, location) ? "active" : ""
                  }`}
                  style={{ cursor: "pointer" }}
                >
                  {item.name}
                </Nav.Link>
              ))}

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

            <Nav className="align-items-center nav-icons gap-2">
              <Form
                className="d-flex me-2 search-form"
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

              {/* 2. THÊM NÚT THEME TOGGLE TẠI ĐÂY */}
              <ThemeToggle />

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

              <Nav.Link
                as={Link}
                to="/profile/wishlist"
                className="nav-icon-link position-relative"
              >
                <Heart size={22} />
                {user && wishlistItemCount > 0 && (
                  <Badge
                    pill
                    bg="danger"
                    className="position-absolute"
                    style={{ top: "-5px", right: "-10px", fontSize: "0.7em" }}
                  >
                    {wishlistItemCount}
                  </Badge>
                )}
              </Nav.Link>

              <Nav.Link
                as={Link}
                to="/cart"
                className="nav-icon-link position-relative"
              >
                <Cart size={22} />
                {user && cartItemCount > 0 && (
                  <Badge
                    pill
                    bg="danger"
                    className="position-absolute"
                    style={{ top: "-5px", right: "-10px", fontSize: "0.7em" }}
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
