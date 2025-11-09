// server/src/utils/sendEmail.js (File MỚI)
const nodemailer = require("nodemailer");
require("dotenv").config();

const sendEmail = async (options) => {
  // 1. Tạo transporter (dịch vụ sẽ gửi email)
  const transporter = nodemailer.createTransport({
    host: process.env.EMAIL_HOST,
    port: process.env.EMAIL_PORT,
    secure: false, // true for 465, false for other ports
    auth: {
      user: process.env.EMAIL_USER,
      pass: process.env.EMAIL_PASS,
    },
  });

  // 2. Định nghĩa các tùy chọn email
  const mailOptions = {
    from: `BLANK CANVAS <${process.env.EMAIL_USER}>`,
    to: options.email,
    subject: options.subject,
    html: options.html, // Gửi nội dung dạng HTML
  };

  // 3. Gửi email
  await transporter.sendMail(mailOptions);
};

module.exports = sendEmail;
