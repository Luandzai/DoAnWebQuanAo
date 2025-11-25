// server/src/index.js
require("dotenv").config(); // Nạp biến môi trường từ file .env
const express = require("express");
const cors = require("cors");

const axios = require("axios"); 
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
const contactRoutes = require("./routes/contactRoutes");
const paymentRoutes = require("./routes/paymentRoutes");
const tryOnRoutes = require("./routes/tryOnRoutes"); // Import route mới

const app = express();
const PORT = process.env.PORT || 5000;
// Kích hoạt CORS (Cross-Origin Resource Sharing)
app.use(cors());
// Giúp server đọc được dữ liệu JSON từ request
app.use(express.json());

// --- API CHATBOT (Groq - Llama 3) ---
app.post('/api/chat', async (req, res) => {
    const { message } = req.body;

    if (!message) {
        return res.status(400).json({ reply: "Vui lòng nhập tin nhắn." });
    }

    const apiKey = process.env.GROQ_API_KEY;

    const apiUrl = "https://api.groq.com/openai/v1/chat/completions";

    const payload = {
        model: "llama-3.3-70b-versatile", // 🔥 Model rẻ & tốt. Có thể đổi thành llama3-70b
        messages: [
            {
                role: "system",
                content: `
Bạn là Stylist ảo của shop "Blank Canvas".
Hãy tư vấn thời trang cho khách:
- Ngắn gọn, trẻ trung, có emoji.
- Nếu câu hỏi không liên quan thời trang → từ chối lịch sự.
                `
            },
            {
                role: "user",
                content: message
            }
        ],
        temperature: 0.7
    };

    try {
        const response = await axios.post(apiUrl, payload, {
            headers: {
                "Content-Type": "application/json",
                "Authorization": `Bearer ${apiKey}`
            }
        });

        const reply =
            response.data?.choices?.[0]?.message?.content ||
            "Mình chưa nghĩ ra câu trả lời phù hợp 😅";

        res.json({ reply });

    } catch (error) {
        console.error("❌ Lỗi API Groq:", error.response?.data || error.message);
        res.status(500).json({ reply: "Stylist đang bận, thử lại sau nha 😅" });
    }
});


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
app.use("/api/contact", contactRoutes); // <-- THÊM DÒNG NÀY
app.use("/api/payment", paymentRoutes);
app.use("/api/try-on", tryOnRoutes); // Sử dụng route mới
// Admin routes
app.use("/api/admin/orders", adminOrderRoutes); // Phải đặt trước /api/admin
app.use("/api/admin", adminRoutes);
app.use("/api/admin/returns", returnsRoutes);

app.listen(PORT, () => {
  console.log(`Server đang chạy tại http://localhost:${PORT}`);
});