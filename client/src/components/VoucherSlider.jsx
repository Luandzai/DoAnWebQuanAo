// client/src/components/VoucherSlider.jsx (ĐÃ XÓA DỮ LIỆU GIẢ)

import React from "react";
import { Swiper, SwiperSlide } from "swiper/react";
import { Navigation } from "swiper/modules";

import "swiper/css";
import "swiper/css/navigation";

import { Badge } from "react-bootstrap";
import "./VoucherSlider.css";

// 1. Dữ liệu giả ĐÃ BỊ XÓA
// const mockVouchers = [ ... ];

// 2. Nhận 'vouchers' (dữ liệu thật) từ props
const VoucherSlider = ({
  vouchers,
  onVoucherClick,
  onApply,
  appliedVoucher,
  onClaimVoucher,
}) => {
  // 3. Nếu không có voucher thì không hiển thị gì cả
  if (!vouchers || vouchers.length === 0) {
    return null; // (Hoặc bạn có thể hiển thị 1 thông báo nhỏ)
  }

  const handleClaimClick = (e, maKhuyenMai) => {
    e.stopPropagation(); // Prevent triggering parent div's onClick
    if (onClaimVoucher) {
      onClaimVoucher(maKhuyenMai);
    }
  };

  return (
    <Swiper
      modules={[Navigation]}
      spaceBetween={10}
      slidesPerView={1}
      navigation
      className="voucher-swiper-container"
    >
      {/* 4. Lặp (map) qua 'vouchers' (dữ liệu thật) */}
      {vouchers.map((voucher) => (
        <SwiperSlide key={voucher.MaKhuyenMai}>
          <div
            className={`voucher-section ${
              // 5. Dùng MaKhuyenMai (từ CSDL) để so sánh
              appliedVoucher?.MaKhuyenMai === voucher.MaKhuyenMai
                ? "voucher-applied"
                : ""
            }`}
            onClick={onVoucherClick} // Click để mở Modal
          >
            <div className="d-flex justify-content-between align-items-center">
              <span className="fw-bold">Voucher và khuyến mãi</span>
              <Badge 
                pill 
                className="btn-apply-voucher"
                onClick={(e) => handleClaimClick(e, voucher.MaKhuyenMai)}
                style={{ cursor: 'pointer' }}
              >
                Nhận
              </Badge>
            </div>
            <div className="mt-2">
              {/* 6. Dùng MaKhuyenMai và TenKhuyenMai (từ CSDL) */}
              <span className="voucher-code">{voucher.MaKhuyenMai}</span>
              <span className="text-muted small ms-2">
                {voucher.TenKhuyenMai}
              </span>
              <br />
              <span className="voucher-expiry">
                Hết hạn sau:{" "}
                {new Date(voucher.NgayKetThuc).toLocaleDateString("vi-VN")}
              </span>
            </div>
          </div>
        </SwiperSlide>
      ))}
    </Swiper>
  );
};

export default VoucherSlider;
