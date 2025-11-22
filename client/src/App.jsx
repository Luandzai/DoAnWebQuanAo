// client/src/App.jsx

import React from "react";
import { Routes, Route } from "react-router-dom";

// Import các Components dùng chung
import Header from "./components/Header";
import Footer from "./components/Footer";

// Import các Pages
import HomePage from "./pages/HomePage";
import ProductListPage from "./pages/ProductListPage";
import ProductDetailPage from "./pages/ProductDetailPage";
import CartPage from "./pages/CartPage";
import AuthPage from "./pages/AuthPage";
import ContactPage from "./pages/ContactPage"; // 1. Import ContactPage
import CheckoutPage from "./pages/CheckoutPage";
import NewsPage from "./pages/NewsPage"; // Thêm phần mở rộng .jsx để chắc chắn
import VirtualTryOnPage from './pages/VirtualTryOnPage'; // Import trang mới


// 1. THÊM CÁC IMPORT MỚI
import ProfilePage from "./pages/ProfilePage";
import ProfileUpdate from "./components/ProfileUpdate";
import UserOrders from "./components/UserOrders";
import UserWishlist from "./components/UserWishlist";
import UserVouchers from "./components/UserVouchers";
import ReturnListPage from "./pages/ReturnListPage";
import ReturnRequestPage from "./pages/ReturnRequestPage";
import ForgotPasswordPage from "./pages/ForgotPasswordPage";
import ResetPasswordPage from "./pages/ResetPasswordPage";
import AdminCategoryPage from "./pages/AdminCategoryPage";
import AdminRoute from "./components/AdminRoute";
import AdminDashboardPage from "./pages/AdminDashboardPage";
import AdminProductListPage from "./pages/AdminProductListPage";
import AdminOrderListPage from "./pages/AdminOrderListPage";
import AdminUserListPage from "./pages/AdminUserListPage"; // Đã import
import AdminReturnListPage from "./pages/AdminReturnListPage";
import AdminVoucherListPage from "./pages/AdminVoucherListPage"; // Đã import
import AdminReviewListPage from "./pages/AdminReviewListPage";
import PaymentResultPage from "./pages/PaymentResultPage"; // <-- DÒNG BỊ ĐỎ LÀ DÒNG NÀY

import ComingSoon from "./pages/ComingSoon"; // Di chuyển xuống dưới cho gọn
function App() {
  return (
    <div className="d-flex flex-column min-vh-100">
      <Header />

      <main className="flex-grow-1 main-content">
        <Routes>
          {/* Trang chính */}
          <Route path="/" element={<HomePage />} />
          <Route path="/products" element={<ProductListPage />} />
          <Route path="/product/:slug" element={<ProductDetailPage />} />
          <Route path="/cart" element={<CartPage />} />
          <Route path="/checkout" element={<CheckoutPage />} />
          <Route path="/auth" element={<AuthPage />} />
          {/* === ROUTE KHÔI PHỤC MẬT KHẨU === */}
          <Route path="/forgot-password" element={<ForgotPasswordPage />} />
          <Route
            path="/reset-password/:token"
            element={<ResetPasswordPage />}
          />
          {/* === ROUTE KẾT QUẢ THANH TOÁN === */}
          <Route path="/payment/result" element={<PaymentResultPage />} />
          {/* ======================= */}
          {/* 2. KHỐI ROUTE LỒNG NHAU CHO PROFILE */}
          <Route path="/profile" element={<ProfilePage />}>
            <Route index element={<ProfileUpdate />} /> {/* Mặc định */}
            <Route path="orders" element={<UserOrders />} />
            <Route path="wishlist" element={<UserWishlist />} />
            <Route path="vouchers" element={<UserVouchers />} />
            <Route path="returns" element={<ReturnListPage />} />
          </Route>
          {/* Các trang phụ */}
          <Route
            path="/profile/return-request/:orderId"
            element={<ReturnRequestPage />}
          />
          <Route path="/contact" element={<ContactPage />} />{" "}
          {/* 2. Cập nhật route */}
          <Route path="/about" element={<ComingSoon />} />
          <Route path="/services" element={<ComingSoon />} />
          <Route path="/faq" element={<ComingSoon />} />
          <Route path="/privacy" element={<ComingSoon />} />
          <Route path="/shipping" element={<ComingSoon />} />
          <Route path="/warranty" element={<ComingSoon />} />
          <Route path="/news" element={<NewsPage />} />
          <Route path="/virtual-try-on" element={<VirtualTryOnPage />} />
          {/* === KHU VỰC ADMIN (ĐÃ THÊM ROUTE USERS) === */}
          <Route path="/admin" element={<AdminRoute />}>
            <Route index element={<AdminDashboardPage />} />
            <Route path="dashboard" element={<AdminDashboardPage />} />
            <Route path="products" element={<AdminProductListPage />} />
            <Route path="categories" element={<AdminCategoryPage />} />
            <Route path="orders" element={<AdminOrderListPage />} />

            {/* <<< ĐÃ THÊM DÒNG ROUTE BỊ THIẾU Ở ĐÂY >>> */}
            <Route path="users" element={<AdminUserListPage />} />
            <Route path="returns" element={<AdminReturnListPage />} />
            <Route path="vouchers" element={<AdminVoucherListPage />} />
            <Route path="reviews" element={<AdminReviewListPage />} />
          </Route>
          {/* ========================================= */}
        </Routes>
      </main>

      <Footer />
    </div>
  );
}

export default App;
