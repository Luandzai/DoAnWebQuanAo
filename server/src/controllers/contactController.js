// server/src/controllers/contactController.js
const sendEmail = require('../utils/sendEmail');

const handleContactRequest = async (req, res) => {
  try {
    const { hoTen, soDienThoai, gmail, noiDung } = req.body;

    // Kiểm tra thông tin đầu vào (có thể thêm validation chi tiết hơn)
    if (!hoTen || !gmail || !noiDung) {
      return res.status(400).json({ message: 'Vui lòng nhập đủ thông tin bắt buộc.' });
    }

    // Nội dung email gửi cho shop
    const emailHtml = `
      <h3>Bạn có một liên hệ mới từ khách hàng</h3>
      <p><strong>Họ tên:</strong> ${hoTen}</p>
      <p><strong>Email:</strong> ${gmail}</p>
      <p><strong>Số điện thoại:</strong> ${soDienThoai || 'Không cung cấp'}</p>
      <hr>
      <p><strong>Nội dung:</strong></p>
      <p>${noiDung}</p>
    `;

    // Cấu hình mail
    const mailOptions = {
      from: `"${hoTen}" <${process.env.EMAIL_USER}>`, // Hiển thị tên người gửi
      to: process.env.SHOP_EMAIL, // Email của shop bạn
      subject: `[Liên Hệ] Thư mới từ ${hoTen}`, // Tiêu đề email
      html: emailHtml,
      replyTo: gmail, // **Quan trọng:** Giúp bạn nhấn "Reply" là trả lời thẳng cho người dùng
    };

    // Gửi mail
    const isSent = await sendEmail(mailOptions);

    if (isSent) {
      res.status(200).json({ message: 'Tin nhắn của bạn đã được gửi thành công!' });
    } else {
      res.status(500).json({ message: 'Có lỗi xảy ra khi gửi email.' });
    }
  } catch (error) {
    console.error('Lỗi tại contactController:', error);
    res.status(500).json({ message: 'Lỗi máy chủ nội bộ.' });
  }
};

module.exports = {
  handleContactRequest,
};