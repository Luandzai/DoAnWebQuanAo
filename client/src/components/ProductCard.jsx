// client/src/components/ProductCard.jsx (ĐÃ THIẾT KẾ LẠI)

import React, { useContext } from "react";
import { Card, Button, Badge } from "react-bootstrap";
import { Link, useNavigate } from "react-router-dom";
import { Heart, HeartFill, Cart } from "react-bootstrap-icons";

// Import 3 Context
import AuthContext from "../context/AuthContext";
import WishlistContext from "../context/WishlistContext";
import CartContext from "../context/CartContext"; // <-- THÊM CART CONTEXT

// Import CSS
import "./ProductCard.css";

const ProductCard = ({ product }) => {
  // Lấy state và hàm từ Context
  const { user } = useContext(AuthContext);
  const { addWishlist, removeWishlist, isFavorited } =
    useContext(WishlistContext);
  const { addToCart, cartItems } = useContext(CartContext); // <-- LẤY HÀM addToCart
  const navigate = useNavigate();

  const favorited = isFavorited(product.SanPhamID);

  const formatPrice = (price) => {
    return new Intl.NumberFormat("vi-VN", {
      style: "currency",
      currency: "VND",
    }).format(price);
  };

  // Logic giá
  const giaBanNum = parseFloat(product.GiaBan);
  const giaGocNum = parseFloat(product.GiaGoc);
  const displayPrice = giaBanNum > 0 ? giaBanNum : giaGocNum;
  const showOldPrice = giaBanNum > 0 && giaBanNum < giaGocNum;
  let discountPercent = 0;
  if (showOldPrice) {
    discountPercent = Math.round(((giaGocNum - giaBanNum) / giaGocNum) * 100);
  }

  // Hàm xử lý khi click Trái tim
  const handleWishlistClick = (e) => {
    e.preventDefault();
    if (!user) {
      navigate("/auth");
      return;
    }
    if (favorited) {
      removeWishlist(product.SanPhamID);
    } else {
      addWishlist(product.SanPhamID);
    }
  };

  // === HÀM MỚI: XỬ LÝ CLICK GIỎ HÀNG ===
  const handleAddToCart = (e) => {
    e.preventDefault();
    if (!user) {
      navigate("/auth");
      return;
    }
    // Lấy PhienBanID đầu tiên của sản phẩm
    // (Lưu ý: Logic này chỉ đúng nếu sản phẩm có ít nhất 1 phiên bản)
    // Để làm đúng, chúng ta cần PhienBanID, nhưng product card chỉ có SanPhamID
    // Tạm thời, chúng ta sẽ điều hướng đến trang chi tiết
    navigate(`/product/${product.Slug}`);

    // NẾU BẠN MUỐN THÊM NGAY LẬP TỨC (cần sửa API /product)
    // if(product.DefaultPhienBanID) {
    //   addToCart(product.DefaultPhienBanID, 1);
    // } else {
    //   navigate(`/product/${product.Slug}`);
    // }
  };

  return (
    // 1. SỬA LẠI CARD (ĐƠN GIẢN HƠN)
    <Card className="my-3 rounded shadow-sm product-card-v2">
      {/* Badges Container - Giảm Giá, Hàng Mới, Voucher */}
      <div className="product-badges-container">
        {showOldPrice && discountPercent > 0 && (
          <Badge bg="danger" className="discount-badge">
            - {discountPercent}%
          </Badge>
        )}
        {/* Chỉ hiển thị nếu IsNew = 1 (true) */}
        {product.IsNew == 1 && <span className="badge-new">Hàng Mới</span>}
        {/* Chỉ hiển thị nếu HasVoucher = 1 (true) */}
        {product.HasVoucher == 1 && (
          <span className="badge-voucher">Voucher</span>
        )}
      </div>

      {/* NÚT TRÁI TIM */}
      <Button
        variant="light"
        className="position-absolute shadow-sm product-card-wishlist-btn"
        onClick={handleWishlistClick}
      >
        {favorited ? <HeartFill color="red" /> : <Heart />}
      </Button>

      <Link to={`/product/${product.Slug}`}>
        <div className="product-card-image-wrapper">
          <Card.Img
            src={
              product.HinhAnhChinh ||
              "https://placehold.co/500x500?text=No+Image"
            }
            variant="top"
          />
        </div>
      </Link>

      {/* 2. SỬA LẠI CARD BODY */}
      <Card.Body>
        <Link to={`/product/${product.Slug}`} className="text-decoration-none">
          <Card.Title as="div" className="product-title">
            {product.TenSanPham}
          </Card.Title>
        </Link>

        {/* HÀNG GIÁ VÀ GIỎ HÀNG */}
        <div className="product-price-row">
          {/* Giá */}
          <Card.Text as="h5" className="my-0">
            <span className="text-danger me-2">
              {formatPrice(displayPrice)}
            </span>
            {showOldPrice && (
              <span className="text-muted product-price-old-v2">
                {formatPrice(giaGocNum)}
              </span>
            )}
          </Card.Text>

          {/* Icon Giỏ hàng */}
          <Button
            variant="link"
            className="product-cart-icon"
            onClick={handleAddToCart}
            title="Thêm vào giỏ hàng"
          >
            <Cart size={22} />
          </Button>
        </div>

        {/* NÚT "XEM CHI TIẾT" ĐÃ BỊ XÓA */}
      </Card.Body>
    </Card>
  );
};

export default ProductCard;
