// client/src/components/HeroCarousel.jsx
import React from "react";
import { Carousel } from "react-bootstrap";

const HeroCarousel = () => {
  return (
    <Carousel fade>
      <Carousel.Item>
        <img
          className="d-block w-100"
          // Bạn có thể dùng ảnh anime của bạn, chỉ cần giữ nguyên style
          src="https://images.unsplash.com/photo-1556905055-8f358a7a47b2?fit=crop&w=1920&q=80"
          alt="First slide"
          /* ĐÂY LÀ PHẦN SỬA LỖI QUAN TRỌNG:
            - maxHeight: '550px'  => Đặt chiều cao cố định (bạn có thể đổi số 550)
            - objectFit: 'cover' => Giúp ảnh lấp đầy khung mà không bị méo (sẽ tự crop)
          */
          style={{ maxHeight: "550px", objectFit: "cover" }}
        />
        <Carousel.Caption>
          <h3>Phụ Kiện Thời Trang</h3>
          <p>Hoàn thiện phong cách của bạn.</p>
        </Carousel.Caption>
      </Carousel.Item>

      <Carousel.Item>
        <img
          className="d-block w-100"
          src="https://images.unsplash.com/photo-1483985988355-763728e1935b?fit=crop&w=1920&q=80"
          alt="Second slide"
          // Thêm style y hệt vào đây
          style={{ maxHeight: "550px", objectFit: "cover" }}
        />
        <Carousel.Caption>
          <h3>Sale Mùa Hè</h3>
          <p>Giảm giá lên đến 50% cho tất cả sản phẩm.</p>
        </Carousel.Caption>
      </Carousel.Item>

      <Carousel.Item>
        <img
          className="d-block w-100"
          src="https://images.unsplash.com/photo-1441986300917-64674bd600d8?fit=crop&w=1920&q=80"
          alt="Third slide"
          // Thêm style y hệt vào đây
          style={{ maxHeight: "550px", objectFit: "cover" }}
        />
        <Carousel.Caption>
          <h3>Hàng Mới Về</h3>
          <p>Khám phá bộ sưu tập Thu-Đông mới nhất.</p>
        </Carousel.Caption>
      </Carousel.Item>
    </Carousel>
  );
};

export default HeroCarousel;
