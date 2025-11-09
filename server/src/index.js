require("dotenv").config(); // Nạp biến môi trường từ file .env
const express = require("express");
const cors = require("cors");
require("./config/db"); // Import để chạy kết nối DB

// Import routes
const authRoutes = require("./routes/authRoutes");
const productRoutes = require("./routes/productRoutes");
const cartRoutes = require("./routes/cartRoutes");
const userRoutes = require("./routes/userRoutes");
const orderRoutes = require("./routes/orderRoutes");
const reviewRoutes = require("./routes/reviewRoutes");
const voucherRoutes = require("./routes/voucherRoutes");
const wishlistRoutes = require("./routes/wishlistRoutes");
const shippingRoutes = require("./routes/shippingRoutes");
const locationRoutes = require("./routes/locationRoutes");
const returnsRoutes = require("./routes/returnsRoutes");
const categoryRoutes = require("./routes/categoryRoutes");
const attributeRoutes = require("./routes/attributeRoutes");
const adminRoutes = require("./routes/adminRoutes");
const adminOrderRoutes = require("./routes/adminOrderRoutes");

const app = express();
const PORT = process.env.PORT || 5000;
// Kích hoạt CORS (Cross-Origin Resource Sharing)
app.use(cors());
// Giúp server đọc được dữ liệu JSON từ request
app.use(express.json());

// Một route API test
app.get("/api", (req, res) => {
  res.json({ message: "Chào mừng bạn đến với API bán quần áo!" });
});

// Sử dụng auth routes
app.use("/api/auth", authRoutes);
app.use("/api/cart", cartRoutes);
app.use("/api/products", productRoutes);
app.use("/api/user", userRoutes);
app.use("/api/orders", orderRoutes);
app.use("/api/reviews", reviewRoutes);
app.use("/api/vouchers", voucherRoutes);
app.use("/api/wishlist", wishlistRoutes);
app.use("/api/shipping", shippingRoutes);
app.use("/api/locations", locationRoutes);
app.use("/api/returns", returnsRoutes);
app.use("/api/categories", categoryRoutes);
app.use("/api/attributes", attributeRoutes);
// Admin routes
app.use("/api/admin/orders", adminOrderRoutes); // Phải đặt trước /api/admin
app.use("/api/admin", adminRoutes);
app.use("/api/admin/returns", returnsRoutes);

app.listen(PORT, () => {
  console.log(`Server đang chạy tại http://localhost:${PORT}`);
});
