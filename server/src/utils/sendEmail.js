// server/src/utils/sendEmail.js
const nodemailer = require("nodemailer");
require("dotenv").config(); // Bạn đã thêm dòng này, hãy giữ nó

// Sửa lại: Hàm này sẽ nhận trực tiếp đối tượng mailOptions từ controller
const sendEmail = async (mailOptions) => { 
  // 1. Tạo transporter (Giữ nguyên cấu hình của bạn)
  const transporter = nodemailer.createTransport({
    host: process.env.EMAIL_HOST,
    port: process.env.EMAIL_PORT,
    secure: false, // false cho port 587 (STARTTLS)
    auth: {
      user: process.env.EMAIL_USER,
      pass: process.env.EMAIL_PASS,
    },
    // Thêm tùy chọn này để tránh lỗi tự ký chứng chỉ (self-signed certificate)
    tls: {
      rejectUnauthorized: false
    }
  });

  // 2. Gửi email với try...catch để xử lý lỗi
  try {
    // Không cần tạo 'mailOptions' mới, mà gửi thẳng 'mailOptions' nhận được từ controller
    await transporter.sendMail(mailOptions); 
    console.log("Email đã được gửi thành công.");
    return true; // Trả về true khi thành công
  } catch (error) {
    console.error("Lỗi khi gửi email:", error);
    return false; // Trả về false khi thất bại
  }
};

module.exports = sendEmail;