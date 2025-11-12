// client/src/components/ContactForm.jsx
import React, { useState } from 'react';
import axios from 'axios';
import './ContactForm.css'; // Giả sử bạn dùng axios

// Bạn có thể tạo file CSS riêng, ví dụ: ContactForm.css
// import './ContactForm.css'; 

const ContactForm = () => {
  const [formData, setFormData] = useState({
    hoTen: '',
    soDienThoai: '',
    gmail: '',
    noiDung: '',
  });
  
  const [message, setMessage] = useState('');
  const [isError, setIsError] = useState(false);
  const [isLoading, setIsLoading] = useState(false);

  const handleChange = (e) => {
    const { name, value } = e.target;
    setFormData((prevData) => ({
      ...prevData,
      [name]: value,
    }));
  };

  const handleSubmit = async (e) => {
    e.preventDefault();
    setIsLoading(true);
    setMessage('');
    setIsError(false);

    try {
      // Gọi API đến server
      const response = await axios.post('/api/contact/send', formData);
      
      setMessage(response.data.message);
      setIsError(false);
      // Xóa form sau khi gửi thành công
      setFormData({
        hoTen: '',
        soDienThoai: '',
        gmail: '',
        noiDung: '',
      });
    } catch (error) {
      const errorMsg = error.response?.data?.message || 'Có lỗi xảy ra, vui lòng thử lại.';
      setMessage(errorMsg);
      setIsError(true);
    } finally {
      setIsLoading(false);
    }
  };

  return (
    <div className="contact-form-container">
      <h2>Liên hệ với chúng tôi</h2>
      <p>Chúng tôi luôn sẵn sàng lắng nghe bạn. Vui lòng điền vào form dưới đây.</p>
      
      <form onSubmit={handleSubmit}>
        <div className="form-group">
          <label htmlFor="hoTen">Họ và Tên (*)</label>
          <input
            type="text"
            id="hoTen"
            name="hoTen"
            value={formData.hoTen}
            onChange={handleChange}
            required
          />
        </div>
        
        <div className="form-group">
          <label htmlFor="gmail">Email (*)</label>
          <input
            type="email"
            id="gmail"
            name="gmail"
            value={formData.gmail}
            onChange={handleChange}
            required
          />
        </div>

        <div className="form-group">
          <label htmlFor="soDienThoai">Số điện thoại</label>
          <input
            type="tel"
            id="soDienThoai"
            name="soDienThoai"
            value={formData.soDienThoai}
            onChange={handleChange}
          />
        </div>

        <div className="form-group">
          <label htmlFor="noiDung">Nội dung (*)</label>
          <textarea
            id="noiDung"
            name="noiDung"
            rows="5"
            value={formData.noiDung}
            onChange={handleChange}
            required
          ></textarea>
        </div>

        <button type="submit" disabled={isLoading}>
          {isLoading ? 'Đang gửi...' : 'Gửi liên hệ'}
        </button>
      </form>

      {message && (
        <p className={`form-message ${isError ? 'error' : 'success'}`}>
          {message}
        </p>
      )}
    </div>
  );
};

export default ContactForm;