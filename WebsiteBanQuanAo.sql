-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Máy chủ: 127.0.0.1
-- Thời gian đã tạo: Th10 05, 2025 lúc 07:34 PM
-- Phiên bản máy phục vụ: 10.4.32-MariaDB
-- Phiên bản PHP: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Cơ sở dữ liệu: `quanaoshop`
--
CREATE DATABASE IF NOT EXISTS `quanaoshop` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE `quanaoshop`;

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `chitietdonhang`
--

CREATE TABLE `chitietdonhang` (
  `ChiTietID` int(11) NOT NULL,
  `DonHangID` int(11) NOT NULL,
  `PhienBanID` int(11) NOT NULL,
  `SoLuong` int(11) NOT NULL CHECK (`SoLuong` > 0),
  `GiaLucMua` decimal(10,2) NOT NULL CHECK (`GiaLucMua` >= 0)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Đang đổ dữ liệu cho bảng `chitietdonhang`
--

INSERT INTO `chitietdonhang` (`ChiTietID`, `DonHangID`, `PhienBanID`, `SoLuong`, `GiaLucMua`) VALUES
(3, 1002, 5001, 1, 99000.00),
(4, 1003, 5002, 1, 99000.00),
(5, 1003, 5003, 1, 399000.00),
(6, 1004, 5001, 1, 99000.00),
(7, 1005, 5003, 1, 399000.00),
(8, 1006, 5001, 1, 99000.00),
(9, 1007, 5003, 1, 399000.00),
(10, 1008, 5002, 3, 99000.00),
(11, 1009, 5026, 1, 270000.00),
(12, 1010, 5003, 1, 399000.00);

--
-- Bẫy `chitietdonhang`
--
DELIMITER $$
CREATE TRIGGER `trig_after_delete_chi_tiet_tong` AFTER DELETE ON `chitietdonhang` FOR EACH ROW BEGIN
    -- Cập nhật TongTienHang (nếu không còn sản phẩm nào thì tổng bằng 0)
    UPDATE DonHang
    SET TongTienHang = IFNULL((
        SELECT SUM(SoLuong * GiaLucMua)
        FROM ChiTietDonHang
        WHERE DonHangID = OLD.DonHangID
    ), 0)
    WHERE DonHangID = OLD.DonHangID;
    
    -- Gọi Stored Procedure để tính lại TongThanhToan
    -- CALL sp_CapNhatTongThanhToan(OLD.DonHangID);
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `trig_after_insert_chi_tiet_dh` AFTER INSERT ON `chitietdonhang` FOR EACH ROW BEGIN
    UPDATE PhienBanSanPham
    SET SoLuongTonKho = SoLuongTonKho - NEW.SoLuong
    WHERE PhienBanID = NEW.PhienBanID;
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `trig_after_insert_chi_tiet_tong` AFTER INSERT ON `chitietdonhang` FOR EACH ROW BEGIN
    -- Cập nhật TongTienHang (chỉ tổng giá trị hàng hóa)
    UPDATE DonHang
    SET TongTienHang = (
        SELECT SUM(SoLuong * GiaLucMua)
        FROM ChiTietDonHang
        WHERE DonHangID = NEW.DonHangID
    )
    WHERE DonHangID = NEW.DonHangID;
    
    -- Gọi một Stored Procedure để tính toán TongThanhToan (bao gồm phí VC và giảm giá)
    -- CALL sp_CapNhatTongThanhToan(NEW.DonHangID); 
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `chitietgiohang`
--

CREATE TABLE `chitietgiohang` (
  `GioHangID` int(11) NOT NULL,
  `PhienBanID` int(11) NOT NULL,
  `SoLuong` int(11) NOT NULL CHECK (`SoLuong` > 0)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Đang đổ dữ liệu cho bảng `chitietgiohang`
--

INSERT INTO `chitietgiohang` (`GioHangID`, `PhienBanID`, `SoLuong`) VALUES
(6, 5001, 3);

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `chitietphienban`
--

CREATE TABLE `chitietphienban` (
  `PhienBanID` int(11) NOT NULL,
  `GiaTriID` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Đang đổ dữ liệu cho bảng `chitietphienban`
--

INSERT INTO `chitietphienban` (`PhienBanID`, `GiaTriID`) VALUES
(5001, 3001),
(5001, 3004),
(5002, 3002),
(5002, 3004),
(5003, 3001),
(5003, 3005),
(5004, 3002),
(5004, 3003),
(5005, 3002),
(5005, 3003),
(5006, 3002),
(5006, 3003),
(5007, 3002),
(5007, 3003),
(5008, 3002),
(5008, 3003),
(5009, 3002),
(5009, 3003),
(5010, 3002),
(5010, 3003),
(5011, 3002),
(5011, 3003),
(5012, 3002),
(5012, 3003),
(5013, 3002),
(5013, 3003),
(5014, 3002),
(5014, 3003),
(5015, 3002),
(5015, 3003),
(5016, 3002),
(5016, 3003),
(5017, 3002),
(5017, 3003),
(5018, 3002),
(5018, 3003),
(5019, 3002),
(5019, 3003),
(5020, 3002),
(5020, 3003),
(5021, 3002),
(5021, 3003),
(5022, 3002),
(5022, 3003),
(5023, 3002),
(5023, 3003),
(5024, 3002),
(5024, 3003),
(5025, 3002),
(5025, 3003),
(5026, 3002),
(5026, 3003),
(5027, 3002),
(5027, 3003),
(5028, 3013),
(5029, 3003),
(5029, 3011),
(5030, 3003),
(5030, 3014),
(5031, 3003),
(5032, 3003),
(5033, 3003),
(5033, 3014),
(5034, 3003),
(5034, 3019);

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `chitietreturns`
--

CREATE TABLE `chitietreturns` (
  `ReturnID` int(11) NOT NULL,
  `PhienBanID` int(11) NOT NULL,
  `SoLuongTra` int(11) NOT NULL CHECK (`SoLuongTra` > 0),
  `GiaHoanTra` decimal(10,2) NOT NULL CHECK (`GiaHoanTra` >= 0)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Đang đổ dữ liệu cho bảng `chitietreturns`
--

INSERT INTO `chitietreturns` (`ReturnID`, `PhienBanID`, `SoLuongTra`, `GiaHoanTra`) VALUES
(1, 5001, 1, 99000.00),
(2, 5002, 1, 99000.00),
(2, 5003, 1, 399000.00),
(4, 5003, 1, 399000.00),
(5, 5002, 1, 99000.00);

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `danhgia`
--

CREATE TABLE `danhgia` (
  `DanhGiaID` int(11) NOT NULL,
  `PhienBanID` int(11) NOT NULL,
  `NguoiDungID` int(11) NOT NULL,
  `DiemSo` int(11) NOT NULL CHECK (`DiemSo` between 1 and 5),
  `BinhLuan` text DEFAULT NULL,
  `HinhAnhURL` varchar(255) DEFAULT NULL,
  `HinhAnhPublicID` varchar(255) DEFAULT NULL,
  `VideoURL` varchar(255) DEFAULT NULL,
  `VideoPublicID` varchar(255) DEFAULT NULL,
  `NgayTao` datetime DEFAULT current_timestamp(),
  `NgayCapNhat` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Đang đổ dữ liệu cho bảng `danhgia`
--

INSERT INTO `danhgia` (`DanhGiaID`, `PhienBanID`, `NguoiDungID`, `DiemSo`, `BinhLuan`, `HinhAnhURL`, `HinhAnhPublicID`, `VideoURL`, `VideoPublicID`, `NgayTao`, `NgayCapNhat`) VALUES
(2, 5001, 5, 5, 'Áo đẹp và mặc thoải mái lắm nha', NULL, NULL, NULL, NULL, '2025-11-03 21:10:44', NULL),
(3, 5001, 6, 5, 'Áo đẹp', 'https://res.cloudinary.com/ddawh25f0/image/upload/v1762348064/reviews/images/gjemzpmym3pjvm2enrxv.jpg', 'reviews/images/gjemzpmym3pjvm2enrxv', NULL, NULL, '2025-11-04 00:49:36', NULL),
(4, 5002, 6, 5, 'Áo xịn', NULL, NULL, 'https://res.cloudinary.com/ddawh25f0/video/upload/v1762357833/reviews/videos/yscbifpxum6pyclve9ll.mp4', 'reviews/videos/yscbifpxum6pyclve9ll', '2025-11-04 00:50:16', '2025-11-05 22:50:34'),
(5, 5003, 5, 5, 'Quần đẹp', NULL, NULL, NULL, NULL, '2025-11-05 19:38:37', NULL),
(6, 5003, 6, 5, 'Quần đẹp và chắc chắn', NULL, NULL, 'https://res.cloudinary.com/ddawh25f0/video/upload/v1762358590/reviews/videos/f0kidsozgqpnrys5us4k.mp4', 'reviews/videos/f0kidsozgqpnrys5us4k', '2025-11-05 23:03:12', NULL);

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `danhmuc`
--

CREATE TABLE `danhmuc` (
  `DanhMucID` int(11) NOT NULL,
  `TenDanhMuc` varchar(100) NOT NULL,
  `Slug` varchar(255) NOT NULL,
  `DanhMucChaID` int(11) DEFAULT NULL,
  `MoTa` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Đang đổ dữ liệu cho bảng `danhmuc`
--

INSERT INTO `danhmuc` (`DanhMucID`, `TenDanhMuc`, `Slug`, `DanhMucChaID`, `MoTa`) VALUES
(401, 'Đồ Nam', 'do-nam', NULL, NULL),
(402, 'Đồ Nữ', 'do-nu', NULL, NULL),
(403, 'Đồ Thể Thao', 'do-the-thao', NULL, NULL),
(404, 'Đồ Da', 'do-da', NULL, NULL),
(405, 'Phụ Kiện', 'phu-kien', NULL, NULL),
(406, 'Áo Thun Nam', 'ao-thun-nam', 401, NULL),
(407, 'Áo Sơ Mi Nam', 'ao-so-mi-nam', 401, NULL),
(408, 'Áo Polo Nam', 'ao-polo-nam', 401, NULL),
(409, 'Áo Khoác Nam', 'ao-khoac-nam', 401, NULL),
(410, 'Áo Hoodie Nam', 'ao-hoodie-nam', 401, NULL),
(411, 'Quần Jean Nam', 'quan-jean-nam', 401, NULL),
(412, 'Quần Short Nam', 'quan-short-nam', 401, NULL),
(413, 'Quần Kaki Nam', 'quan-kaki-nam', 401, NULL),
(414, 'Quần Tây Nam', 'quan-tay-nam', 401, NULL),
(415, 'Áo Thun Nữ', 'ao-thun-nu', 402, NULL),
(416, 'Áo Sơ Mi Nữ', 'ao-so-mi-nu', 402, NULL),
(417, 'Áo Croptop', 'ao-croptop', 402, NULL),
(418, 'Áo Hoodie Nữ', 'ao-hoodie-nu', 402, NULL),
(419, 'Áo Khoác Nữ', 'ao-khoac-nu', 402, NULL),
(420, 'Quần Jean Nữ', 'quan-jean-nu', 402, NULL),
(421, 'Quần Short Nữ', 'quan-short-nu', 402, NULL),
(422, 'Quần Ống Rộng', 'quan-ong-rong', 402, NULL),
(423, 'Chân Váy', 'chan-vay', 402, NULL),
(424, 'Váy & Đầm', 'dam-nu', 402, NULL),
(425, 'Quần Áo Tập Gym', 'quan-ao-tap-gym', 403, NULL),
(426, 'Đồ Chạy Bộ', 'do-chay-bo', 403, NULL),
(427, 'Đồ Bơi', 'do-boi', 403, NULL),
(428, 'Áo Khoác Thể Thao', 'ao-khoac-the-thao', 403, NULL),
(429, 'Áo Khoác Da', 'ao-khoac-da', 404, NULL),
(430, 'Ví Da', 'vi-da', 404, NULL),
(431, 'Giày Da', 'giay-da', 404, NULL),
(432, 'Mũ & Nón', 'mu-non', 405, NULL),
(433, 'Túi & Balo', 'tui-balo', 405, NULL),
(434, 'Kính Mát', 'kinh-mat', 405, NULL),
(435, 'Tất & Vớ', 'tat-vo', 405, NULL),
(436, 'Thắt Lưng', 'that-lung', 405, NULL);

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `diachigiaohang`
--

CREATE TABLE `diachigiaohang` (
  `DiaChiID` int(11) NOT NULL,
  `NguoiDungID` int(11) NOT NULL,
  `TenNguoiNhan` varchar(100) NOT NULL,
  `DienThoaiNhan` varchar(15) DEFAULT NULL,
  `DiaChiChiTiet` varchar(255) NOT NULL,
  `PhuongXa` varchar(100) NOT NULL,
  `QuanHuyen` varchar(100) NOT NULL,
  `TinhThanh` varchar(100) NOT NULL,
  `MacDinh` tinyint(1) DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Đang đổ dữ liệu cho bảng `diachigiaohang`
--

INSERT INTO `diachigiaohang` (`DiaChiID`, `NguoiDungID`, `TenNguoiNhan`, `DienThoaiNhan`, `DiaChiChiTiet`, `PhuongXa`, `QuanHuyen`, `TinhThanh`, `MacDinh`) VALUES
(102, 6, 'Trương Văn Nghị', '0834576312', '11 Đ.Nam Cao, phường Tân Phú, quận 9, Thành phố Hồ Chí Minh', 'default', 'default', 'default', 0),
(103, 6, 'Trương Văn Nghị', '0834576312', '11 Đ.Nam Cao', 'default', 'default', 'default', 0),
(104, 6, 'Trương Văn Nghị', '0834576312', '11 Đ.Xuân Diệp', 'default', 'default', 'default', 0),
(105, 6, 'Trương Văn Nghị', '0834576312', '11 Đ.Nam Cao, Phường Tân Phú, Quận 9, Hồ Chí Minh', 'Phường Tân Phú', 'Quận 9', 'Hồ Chí Minh', 0),
(106, 5, 'Trương Văn Hửu', '0944089720', '11 Đ.Nam Cao, Thị trấn Thứa, Huyện Lương Tài, Bắc Ninh', 'Thị trấn Thứa', 'Huyện Lương Tài', 'Bắc Ninh', 0),
(107, 5, 'Trương Văn Hửu', '0944089720', '11 Đ.Nam Cao, Xã Xà Phiên, Huyện Long Mỹ, Hậu Giang', 'Xã Xà Phiên', 'Huyện Long Mỹ', 'Hậu Giang', 0),
(108, 5, 'Trương Văn Hửu', '0944089720', '11 Đ.Nam Cao, Xã Viên An Đông, Huyện Ngọc Hiển, Cà Mau', 'Xã Viên An Đông', 'Huyện Ngọc Hiển', 'Cà Mau', 0),
(109, 5, 'Trương Văn Hửu', '0944089720', '11 Đ.Nam Cao, Phường Tân Phú, Thành Phố Thủ Đức, Hồ Chí Minh', 'Phường Tân Phú', 'Thành Phố Thủ Đức', 'Hồ Chí Minh', 0),
(110, 7, '1348_Trương Văn Hửu', '0944089720', '11 Đ.Nam Cao, Thị trấn Thứa, Huyện Lương Tài, Bắc Ninh', 'Thị trấn Thứa', 'Huyện Lương Tài', 'Bắc Ninh', 0);

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `donhang`
--
CREATE TABLE `donhang` (
  `DonHangID` int(11) NOT NULL,
  `NguoiDungID` int(11) NOT NULL,
  `DiaChiGiaoHangID` int(11) NOT NULL,
  `MaKhuyenMai` varchar(50) DEFAULT NULL,
  `PhuongThucID` int(11) DEFAULT NULL,
  `NgayDatHang` datetime DEFAULT current_timestamp(),
  `TongTienHang` decimal(10,2) NOT NULL CHECK (`TongTienHang` >= 0),
  `PhiVanChuyen` decimal(10,2) DEFAULT 0.00 CHECK (`PhiVanChuyen` >= 0),
  `TongThanhToan` decimal(10,2) NOT NULL CHECK (`TongThanhToan` >= 0),
  `TrangThai` enum('CHUA_THANH_TOAN','DANG_XU_LY','DANG_GIAO','DA_GIAO','DA_HUY') NOT NULL DEFAULT 'DANG_XU_LY',
  `GhiChu` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
ALTER TABLE DonHang
ADD COLUMN NgayCapNhat DATETIME,
ADD COLUMN NguoiCapNhat INT;

--
-- Đang đổ dữ liệu cho bảng `donhang`
--

INSERT INTO `donhang` (`DonHangID`, `NguoiDungID`, `DiaChiGiaoHangID`, `MaKhuyenMai`, `PhuongThucID`, `NgayDatHang`, `TongTienHang`, `PhiVanChuyen`, `TongThanhToan`, `TrangThai`, `GhiChu`) VALUES
(1002, 6, 102, NULL, 601, '2025-11-02 20:13:11', 99000.00, 0.00, 99000.00, 'DA_HUY', 'Giao hàng nhanh nhé'),
(1003, 6, 103, NULL, 601, '2025-11-02 23:39:57', 498000.00, 0.00, 498000.00, 'DA_GIAO', 'Giao hàng cẩn thận'),
(1004, 6, 104, NULL, 601, '2025-11-03 00:50:41', 99000.00, 0.00, 99000.00, 'DA_GIAO', 'Hello'),
(1005, 6, 105, 'FREE30K', 601, '2025-11-03 02:24:47', 399000.00, 30000.00, 399000.00, 'DA_GIAO', 'HeHe'),
(1006, 5, 106, NULL, 602, '2025-11-03 17:14:26', 99000.00, 50000.00, 149000.00, 'DA_GIAO', 'Giao hàng nhanh'),
(1007, 5, 107, 'FREE30K', 601, '2025-11-03 18:08:23', 399000.00, 30000.00, 399000.00, 'DA_GIAO', 'HiHIU'),
(1008, 5, 108, NULL, 601, '2025-11-03 20:34:01', 297000.00, 30000.00, 327000.00, 'DA_GIAO', 'Chào'),
(1009, 5, 109, NULL, 601, '2025-11-05 15:44:19', 270000.00, 30000.00, 300000.00, 'DANG_XU_LY', 'Giao hàng nhanh nhé'),
(1010, 7, 110, 'FREE30K', 601, '2025-11-06 00:53:41', 399000.00, 30000.00, 399000.00, 'DANG_XU_LY', 'Giao hàng nhanh giúp tôi');

--
-- Bẫy `donhang`
--
DELIMITER $$
CREATE TRIGGER `trig_after_update_trang_thai` AFTER UPDATE ON `donhang` FOR EACH ROW BEGIN
    -- Chỉ ghi log nếu cột TrangThai thực sự thay đổi giá trị
    IF OLD.TrangThai <> NEW.TrangThai THEN
        INSERT INTO LichSuDonHang (DonHangID, TrangThaiCu, TrangThaiMoi, GhiChu)
        VALUES (NEW.DonHangID, OLD.TrangThai, NEW.TrangThai, 'Trạng thái được cập nhật tự động.');
    END IF;
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `trig_before_update_don_hang_huy` BEFORE UPDATE ON `donhang` FOR EACH ROW BEGIN
    -- Kiểm tra nếu đơn hàng chuyển từ trạng thái đang xử lý/đang giao sang DA_HUY
    IF (OLD.TrangThai = 'DANG_XU_LY' OR OLD.TrangThai = 'DANG_GIAO') AND NEW.TrangThai = 'DA_HUY' THEN
        -- Tăng tồn kho cho TẤT CẢ sản phẩm trong đơn hàng
        UPDATE PhienBanSanPham AS p
        INNER JOIN ChiTietDonHang AS c ON p.PhienBanID = c.PhienBanID
        SET p.SoLuongTonKho = p.SoLuongTonKho + c.SoLuong
        WHERE c.DonHangID = NEW.DonHangID;
    END IF;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `giatrithuoctinh`
--

CREATE TABLE `giatrithuoctinh` (
  `GiaTriID` int(11) NOT NULL,
  `ThuocTinhID` int(11) NOT NULL,
  `GiaTri` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Đang đổ dữ liệu cho bảng `giatrithuoctinh`
--

INSERT INTO `giatrithuoctinh` (`GiaTriID`, `ThuocTinhID`, `GiaTri`) VALUES
(3006, 301, 'L'),
(3002, 301, 'M'),
(3001, 301, 'S'),
(3007, 301, 'XL'),
(3008, 301, 'XXL'),
(3013, 302, 'Nâu'),
(3004, 302, 'Trắng'),
(3009, 302, 'Vàng'),
(3005, 302, 'Xanh'),
(3003, 302, 'Đen'),
(3010, 302, 'Đỏ'),
(3015, 303, '39'),
(3011, 303, '40'),
(3012, 303, '41'),
(3016, 303, '42'),
(3017, 303, '43'),
(3020, 304, '100cm'),
(3021, 304, '110cm'),
(3022, 304, '120cm'),
(3018, 304, '80cm'),
(3019, 304, '90cm'),
(3014, 305, 'Freesize');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `giohang`
--

CREATE TABLE `giohang` (
  `NguoiDungID` int(11) NOT NULL,
  `NgayTao` datetime DEFAULT current_timestamp(),
  `NgayCapNhat` datetime DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Đang đổ dữ liệu cho bảng `giohang`
--

INSERT INTO `giohang` (`NguoiDungID`, `NgayTao`, `NgayCapNhat`) VALUES
(5, '2025-11-03 17:13:32', '2025-11-03 17:13:32'),
(6, '2025-11-02 19:45:36', '2025-11-02 19:45:36'),
(7, '2025-11-06 00:50:41', '2025-11-06 00:50:41');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `hinhanhsanpham`
--

CREATE TABLE `hinhanhsanpham` (
  `HinhAnhID` int(11) NOT NULL,
  `SanPhamID` int(11) NOT NULL,
  `PhienBanID` int(11) DEFAULT NULL,
  `URL` varchar(255) NOT NULL,
  `MoTa` varchar(255) DEFAULT NULL,
  `LaAnhChinh` tinyint(1) DEFAULT 0,
  `ViTri` int(11) DEFAULT 0 CHECK (`ViTri` >= 0)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Đang đổ dữ liệu cho bảng `hinhanhsanpham`
--

INSERT INTO `hinhanhsanpham` (`HinhAnhID`, `SanPhamID`, `PhienBanID`, `URL`, `MoTa`, `LaAnhChinh`, `ViTri`) VALUES
(1, 201, NULL, 'https://img.lazcdn.com/g/p/d60951be1736ed5fc99ba5da947642cf.png_720x720q80.png', NULL, 1, 0),
(2, 201, NULL, 'https://product.hstatic.net/200000404243/product/a3mn140r2-vnma026-2010-n-1_6644379e77504eedbec568889885df35.jpg', NULL, 0, 0),
(3, 202, NULL, 'https://bizweb.dktcdn.net/100/396/594/products/img-1742.jpg?v=1708922250740', NULL, 1, 0),
(97, 203, NULL, 'https://product.hstatic.net/200000471735/product/mts205s5-2-n01__2__c717a7ec0141485093264be148632b79.jpg', NULL, 1, 0),
(98, 203, NULL, 'https://colo.com.vn/wp-content/uploads/2023/10/ao-thun-nam-co-tron-den-1.jpeg', NULL, 0, 0),
(99, 204, NULL, 'https://product.hstatic.net/200000588671/product/ao-so-mi-nam-tay-dai-cong-so-bamboo-mau-xanh-den-1_15a13335f0b74f48a7e2f4d50aed2e01.jpg', NULL, 1, 0),
(100, 204, NULL, 'https://pos.nvncdn.com/492284-9176/ps/20241110_WeY0twVLPU.jpeg?v=1731229011', NULL, 0, 0),
(101, 205, NULL, 'https://cf.shopee.vn/file/c93a40ed8dc173297fa4bcd78d767186', NULL, 1, 0),
(102, 205, NULL, 'https://down-vn.img.susercontent.com/file/34acd5e930c8a21e1c3a70d3cf2a70c5', NULL, 0, 0),
(103, 206, NULL, 'https://lados.vn/wp-content/uploads/2024/09/3-kem-ld2107.jpg', NULL, 1, 0),
(104, 206, NULL, 'https://product.hstatic.net/1000369857/product/akd903_1_tui_1200x1200_0002_layer_21_c8306b98e3604f5890c8446b99cf2a9b.jpg', NULL, 0, 0),
(105, 207, NULL, 'https://product.hstatic.net/200000370509/product/1481_66c8e86d83a73540f408618b2cde78c7_66fa80d9d6d7434c8cdacfef45c12072_64843aa2f0ac499fbe30e2951a529139_large.jpg', NULL, 1, 0),
(106, 207, NULL, 'https://product.hstatic.net/200000370449/product/hdr_den_sau_ec2123b4a8b447cb92efe95165691a12_master.jpg', NULL, 0, 0),
(107, 208, NULL, 'https://4menshop.com/images/thumbs/2020/09/quan-jean-rach-goi-qj004-mau-den-15557.png', NULL, 1, 0),
(108, 208, NULL, 'https://4menshop.com/images/thumbs/2020/05/quan-jean-slimfit-qj1645-mau-den-15196.png', NULL, 0, 0),
(109, 209, NULL, 'https://product.hstatic.net/1000096703/product/kenta183__1__8d9f2bf14a22446db4465d2d8725ba92_master.jpg', NULL, 1, 0),
(110, 209, NULL, 'https://cdn.vuahanghieu.com/unsafe/0x900/left/top/smart/filters:quality(90)/https://admin.vuahanghieu.com/upload/product/2024/03/quan-short-nam-lacoste-kaki-slim-mau-xanh-navy-size-33-65ebbcff03d96-09032024083559.jpg', NULL, 0, 0),
(111, 210, NULL, 'https://4menshop.com/images/thumbs/2019/11/quan-kaki-slimfit-xanh-qk181-14848.jpg', NULL, 1, 0),
(112, 210, NULL, 'https://product.hstatic.net/200000370509/product/6916_a5d3f55ffc09c0874577cff4e5bb5ebc_78b074ca40724ce8a8acb5822b6e0da9_54ccd36cf22f4768a70eef7fb85dabe2_master.jpg', NULL, 0, 0),
(113, 211, NULL, 'https://dongphucbonmua.com/wp-content/uploads/2019/08/dong-phuc-quan-au-cong-so-nam-mau-den.jpg', NULL, 1, 0),
(114, 211, NULL, 'https://img.lazcdn.com/g/p/f6e3792965cd962a40e3ef7dfc07c605.jpg_720x720q80.jpg', NULL, 0, 0),
(115, 212, NULL, 'https://product.hstatic.net/1000075554/product/9460c38f30ccd4928ddd_b4132579e54b40b8ab58b0f2666221e4_c711a95222af4888b2e684edddb2500d_master.jpg', NULL, 1, 0),
(116, 212, NULL, 'https://bizweb.dktcdn.net/100/287/440/products/ao-thun-nu-form-rong-tay-lo-3-acb92174-46f9-4781-bc5b-a084b1772cea.jpg?v=1622792317307', NULL, 0, 0),
(117, 213, NULL, 'https://down-vn.img.susercontent.com/file/f8fcb87f54dd698447a9f1375bd22ac4', NULL, 1, 0),
(118, 213, NULL, 'https://cache.maydep.vn/wp-content/uploads/2022/01/ao-so-mi-dong-phuc-nu-vai-lua.jpg', NULL, 0, 0),
(119, 214, NULL, 'https://cdn.kkfashion.vn/9820-home_default/ao-croptop-tay-phong-mau-den-asm06-10.jpg', NULL, 1, 0),
(120, 214, NULL, 'https://dosi-in.com/images/detailed/409/dosiin-fiin-ao-croptop-tay-phong-co-vuong-mau-tron-kieu-han-quoc-xinh-xan-cho-nu-form-rong-made-409631.jpg', NULL, 0, 0),
(121, 215, NULL, 'https://m.media-amazon.com/images/I/61sC0yq4TaL._AC_UL1500_.jpg', NULL, 1, 0),
(122, 215, NULL, 'https://salt.tikicdn.com/cache/w300/ts/product/45/a7/8d/53aa40a18ba18bd40efcc43355bda7f8.jpg', NULL, 0, 0),
(123, 216, NULL, 'https://airui.store/wp-content/uploads/2023/12/Ao-Cardigan-Len-Nu-Dinh-Hoa-No-Mau-Trang-Be-Ao-Khoac-Len-Hang-Dep.jpg', NULL, 1, 0),
(124, 216, NULL, 'https://airui.store/wp-content/uploads/2023/12/Ao-Cardigan-Len-Nu-Tui-Gau-Trang-Be-Ao-Khoac-Len-Hang-Dep.jpg', NULL, 0, 0),
(125, 217, NULL, 'https://bizweb.dktcdn.net/100/484/513/products/b47934d387842cda7595.jpg?v=1714290125787', NULL, 1, 0),
(126, 217, NULL, 'https://cdn.kkfashion.vn/24708-large_default/quan-jeans-dai-lung-cao-ong-loe-mau-den-qj-10.jpg', NULL, 0, 0),
(127, 218, NULL, 'https://pos.nvncdn.com/d0f3ca-7136/ps/20240911_yFTGsCX5D1.jpeg', NULL, 1, 0),
(128, 218, NULL, 'https://down-vn.img.susercontent.com/file/vn-11134201-23030-v0kixvlg9uov2d', NULL, 0, 0),
(129, 219, NULL, 'https://salt.tikicdn.com/ts/product/a6/f2/7f/19276df6361713a219f18c7507ec74ad.jpg', NULL, 1, 0),
(130, 219, NULL, 'https://vn-live-01.slatic.net/p/8a333daa8fdd139ebbeba0484576d603.jpg', NULL, 0, 0),
(131, 220, NULL, 'https://img.lazcdn.com/g/p/00e36b5cc7acff00e9db8d97c8d45780.jpg_720x720q80.jpg', NULL, 1, 0),
(132, 220, NULL, 'https://bizweb.dktcdn.net/100/422/076/products/z6067499164890-e77feaa745b98efca173ce2ad4864039.jpg?v=1732523012753', NULL, 0, 0),
(133, 221, NULL, 'https://product.hstatic.net/200000788335/product/dav.0181-mo1_054c9f9aa1304904b4379b329e9e5652_master.jpg', NULL, 1, 0),
(134, 221, NULL, 'https://thoitrangnuhoang.com/data/Product/z3590473691163_ea0dc85af12d6224e3e53827bcbbd927_1658644449.jpg', NULL, 0, 0),
(135, 222, NULL, 'https://htsport.vn/wp-content/uploads/2021/12/quan-tap-gym-yoga-nu-poly-khong-tui-QG02.jpg', NULL, 1, 0),
(136, 222, NULL, 'https://fitme.vn/cdn/shop/files/quan-legging-nu-tap-gym-co-tui-an-theta-qdtt-den_3.jpg?v=1710225312&width=2048', NULL, 0, 0),
(137, 223, NULL, 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSMgPXAT34XuoWh2gXuDBXGUfqUCsfN_KgAdA&s', NULL, 1, 0),
(138, 223, NULL, 'https://bizweb.dktcdn.net/100/509/297/products/2-xanh-duong.jpg?v=1725873125720', NULL, 0, 0),
(139, 224, NULL, 'https://supersports.com.vn/cdn/shop/files/8-134710001-1_1200x1200.jpg?v=1691402716', NULL, 1, 0),
(140, 224, NULL, 'https://product.hstatic.net/200000642151/product/wo-ss24s-swi004__3__6c539eba2e5841389356b2eb889aa210_master.jpg', NULL, 0, 0),
(141, 225, NULL, 'https://yeepvn.sgp1.digitaloceanspaces.com/2023/04/5445760f3dafaaf84cbb0999dd32d269.jpg', NULL, 1, 0),
(142, 225, NULL, 'https://product.hstatic.net/1000308345/product/img_2108_d9dc647ef3b24c649b5d1efdfbf39d5c_master.jpg', NULL, 0, 0),
(143, 226, NULL, 'https://cdn0199.cdn4s.com/media/cd9731b5125acb04924b.jpg', NULL, 1, 0),
(144, 226, NULL, 'https://ann.com.vn/wp-content/uploads/22118-clean-bia-ak077.png', NULL, 0, 0),
(145, 227, NULL, 'https://vuadasaigon.com/images/detailed/5/vi_da_bo_may_thu_cong_vd80_3.jpg', NULL, 1, 0),
(146, 227, NULL, 'https://www.gento.vn/wp-content/uploads/2022/09/vi-nam-da-bo-2-600x600.jpg', NULL, 0, 0),
(147, 228, NULL, 'https://product.hstatic.net/1000355922/product/giay-da-nam-cong-so-ngoai-co-4382045__5__61ce577b6d28424bb853106ba1ff457a_master.jpg', NULL, 1, 0),
(148, 228, NULL, 'https://cdn.shopify.com/s/files/1/1404/4249/files/23112018-giay-tay-nam-dong-hai-G0703d_grande.JPG?v=1542961434', NULL, 0, 0),
(149, 229, NULL, 'https://zerdio.com.vn/wp-content/uploads/2020/07/non-ket-nam-den-2.jpg', NULL, 1, 0),
(150, 229, NULL, 'https://zerdio.com.vn/wp-content/uploads/2020/12/mu-luoi-trai-den-tron-9-247x247.jpg', NULL, 0, 0),
(151, 230, NULL, 'https://gubag.vn/wp-content/uploads/2022/10/balo-dung-laptop-17-inch-chong-nuoc-cao-cap-gb-bl57-2-1.webp', NULL, 1, 0),
(152, 230, NULL, 'https://zongvietnam.com/wp-content/uploads/2023/10/balo-laptop-du-lich-phuot-chong-tham-nuoc-tangcool-705-14-156-inch.jpg', NULL, 0, 0),
(153, 231, NULL, 'https://desmonshop.com/wp-content/uploads/2021/10/photo_2021-10-28_01-09-08-2.jpg', NULL, 1, 0),
(154, 231, NULL, 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcStPCAqYGbSXR11XHlnKMsgqN8EkUFNhD9gUw&s', NULL, 0, 0),
(155, 232, NULL, 'https://bizweb.dktcdn.net/100/460/898/products/1-a49b2a2e-8e05-4d5d-ad35-1e9bee4ac959.png?v=1712463597310', NULL, 1, 0),
(156, 232, NULL, 'https://pos.nvncdn.com/cba2a3-7534/ps/20240701_VKbpZRjPmC.jpeg?v=1719843719', NULL, 0, 0),
(157, 233, NULL, 'https://www.gento.vn/wp-content/uploads/2021/10/day-lung-nam-da-that-D40197.jpg', NULL, 1, 0),
(158, 233, NULL, 'https://lavatino.com/wp-content/uploads/2020/01/That-lung-da-bo-cong-so-TINO-04-D02-TRANG-3-1-1000x1000-1.jpg', NULL, 0, 0);

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `khuyenmai`
--

CREATE TABLE `khuyenmai` (
  `MaKhuyenMai` varchar(50) NOT NULL,
  `TenKhuyenMai` varchar(255) NOT NULL,
  `LoaiGiamGia` enum('PHANTRAM','SOTIEN') NOT NULL,
  `GiaTriGiam` decimal(10,2) NOT NULL CHECK (`GiaTriGiam` >= 0),
  `ApDungToiThieu` decimal(10,2) DEFAULT 0.00 CHECK (`ApDungToiThieu` >= 0),
  `DanhMucID` int(11) DEFAULT NULL,
  `SanPhamID` int(11) DEFAULT NULL,
  `NgayBatDau` datetime NOT NULL,
  `NgayKetThuc` datetime NOT NULL,
  `SoLuongToiDa` int(11) DEFAULT 0 CHECK (`SoLuongToiDa` >= 0)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
ALTER TABLE `KhuyenMai`
ADD COLUMN `TrangThai` ENUM('ACTIVE', 'INACTIVE') NOT NULL DEFAULT 'ACTIVE' 
AFTER `SoLuongToiDa`;
--
-- Đang đổ dữ liệu cho bảng `khuyenmai`
--

INSERT INTO `khuyenmai` (`MaKhuyenMai`, `TenKhuyenMai`, `LoaiGiamGia`, `GiaTriGiam`, `ApDungToiThieu`, `DanhMucID`, `SanPhamID`, `NgayBatDau`, `NgayKetThuc`, `SoLuongToiDa`) VALUES
('FREE30K', 'Giảm 30K cho đơn hàng đầu', 'SOTIEN', 30000.00, 200000.00, 411, 202, '2025-11-01 15:40:00', '2026-12-31 23:59:59', 98);

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `lichsudonhang`
--

CREATE TABLE `lichsudonhang` (
  `LichSuID` int(11) NOT NULL,
  `DonHangID` int(11) NOT NULL,
  `TrangThaiCu` enum('CHUA_THANH_TOAN','DANG_XU_LY','DANG_GIAO','DA_GIAO','DA_HUY') DEFAULT NULL,
  `TrangThaiMoi` enum('CHUA_THANH_TOAN','DANG_XU_LY','DANG_GIAO','DA_GIAO','DA_HUY') DEFAULT NULL,
  `ThoiGian` datetime DEFAULT current_timestamp(),
  `GhiChu` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
-- 1. Bổ sung trạng thái DOI_TRA vào cột TrangThai của bảng donhang
ALTER TABLE `donhang`
MODIFY COLUMN `TrangThai` ENUM('CHUA_THANH_TOAN', 'DANG_XU_LY', 'DANG_GIAO', 'DA_GIAO', 'DA_HUY', 'DOI_TRA') 
NOT NULL DEFAULT 'DANG_XU_LY';


-- 2. Bổ sung trạng thái DOI_TRA vào cột TrangThaiCu của bảng lichsudonhang
ALTER TABLE `lichsudonhang`
MODIFY COLUMN `TrangThaiCu` ENUM('CHUA_THANH_TOAN', 'DANG_XU_LY', 'DANG_GIAO', 'DA_GIAO', 'DA_HUY', 'DOI_TRA') 
DEFAULT NULL;


-- 3. Bổ sung trạng thái DOI_TRA vào cột TrangThaiMoi của bảng lichsudonhang
ALTER TABLE `lichsudonhang`
MODIFY COLUMN `TrangThaiMoi` ENUM('CHUA_THANH_TOAN', 'DANG_XU_LY', 'DANG_GIAO', 'DA_GIAO', 'DA_HUY', 'DOI_TRA') 
DEFAULT NULL;
--
-- Đang đổ dữ liệu cho bảng `lichsudonhang`
--

INSERT INTO `lichsudonhang` (`LichSuID`, `DonHangID`, `TrangThaiCu`, `TrangThaiMoi`, `ThoiGian`, `GhiChu`) VALUES
(2, 1002, 'DANG_XU_LY', 'DA_HUY', '2025-11-03 00:29:00', 'Trạng thái được cập nhật tự động.'),
(3, 1003, 'DANG_XU_LY', 'DA_HUY', '2025-11-03 00:35:42', 'Trạng thái được cập nhật tự động.'),
(4, 1004, 'DANG_XU_LY', 'DA_HUY', '2025-11-03 00:51:02', 'Trạng thái được cập nhật tự động.'),
(5, 1005, 'DANG_XU_LY', 'DA_HUY', '2025-11-03 02:27:48', 'Trạng thái được cập nhật tự động.'),
(6, 1007, 'DANG_XU_LY', 'DA_HUY', '2025-11-03 18:14:15', 'Trạng thái được cập nhật tự động.'),
(7, 1006, 'DANG_XU_LY', 'DA_GIAO', '2025-11-03 20:36:54', 'Trạng thái được cập nhật tự động.'),
(8, 1007, 'DA_HUY', 'DA_GIAO', '2025-11-03 20:37:26', 'Trạng thái được cập nhật tự động.'),
(9, 1008, 'DANG_XU_LY', 'DA_GIAO', '2025-11-03 20:37:48', 'Trạng thái được cập nhật tự động.'),
(10, 1005, 'DA_HUY', 'DANG_XU_LY', '2025-11-03 23:10:37', 'Trạng thái được cập nhật tự động.'),
(11, 1005, 'DANG_XU_LY', 'DANG_GIAO', '2025-11-03 23:11:24', 'Trạng thái được cập nhật tự động.'),
(12, 1003, 'DA_HUY', 'DA_GIAO', '2025-11-04 00:46:01', 'Trạng thái được cập nhật tự động.'),
(13, 1004, 'DA_HUY', 'DA_GIAO', '2025-11-04 00:46:10', 'Trạng thái được cập nhật tự động.'),
(14, 1005, 'DANG_GIAO', 'DA_GIAO', '2025-11-04 02:33:04', 'Trạng thái được cập nhật tự động.');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `nguoidung`
--

CREATE TABLE `nguoidung` (
  `NguoiDungID` int(11) NOT NULL,
  `Email` varchar(100) NOT NULL,
  `GoogleID` varchar(255) DEFAULT NULL,
  `MatKhauHash` varchar(255) DEFAULT NULL,
  `LoaiXacThuc` enum('LOCAL','GOOGLE') NOT NULL DEFAULT 'LOCAL',
  `HoTen` varchar(100) NOT NULL,
  `DienThoai` varchar(15) DEFAULT NULL,
  `NgaySinh` date DEFAULT NULL,
  `GioiTinh` enum('Nam','Nu','Khac') DEFAULT NULL,
  `VaiTro` enum('KHACHHANG','ADMIN') NOT NULL DEFAULT 'KHACHHANG',
  `TrangThai` enum('ACTIVE','INACTIVE') DEFAULT 'ACTIVE',
  `MatKhauResetToken` varchar(255) DEFAULT NULL,
  `MatKhauResetTokenExpires` datetime DEFAULT NULL,
  `NgayTao` datetime DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Đang đổ dữ liệu cho bảng `nguoidung`
--

INSERT INTO `nguoidung` (`NguoiDungID`, `Email`, `GoogleID`, `MatKhauHash`, `LoaiXacThuc`, `HoTen`, `DienThoai`, `NgaySinh`, `GioiTinh`, `VaiTro`, `TrangThai`, `MatKhauResetToken`, `MatKhauResetTokenExpires`, `NgayTao`) VALUES
(4, 'admin@gmail.com', NULL, '$2b$10$zFfCAFMhVTzxiEAwZxysOuR9cTBAOS67ZHUoa8zcf573L6dwfsswy', 'LOCAL', 'Quản Trị Viên', NULL, NULL, NULL, 'ADMIN', 'ACTIVE', NULL, NULL, '2025-11-01 15:47:44'),
(5, 'huutv@gmail.com', NULL, '$2b$10$/8rI0GDeJlx6SJFIvurAU.5PGzOwzXre/B8/QmJaLZ2V35pQwkdTm', 'LOCAL', 'Trương Văn Hửu', '0944089720', '2004-01-02', 'Nam', 'KHACHHANG', 'ACTIVE', NULL, NULL, '2025-11-01 15:49:36'),
(6, 'nghitv@gmail.com', NULL, '$2b$10$1Ng2Pk/uE.IHgJtMk49xy.KE2p3Ngr3k6ZvEW0MQyN9jj3GftotH2', 'LOCAL', 'Trương Văn Nghị', '0834576312', '2007-01-30', 'Nam', 'KHACHHANG', 'ACTIVE', NULL, NULL, '2025-11-01 17:57:17'),
(7, 'huutv91vp2@gmail.com', '102402061977779301978', NULL, 'GOOGLE', '1348_Trương Văn Hửu', '0944089720', '2004-01-01', 'Nam', 'KHACHHANG', 'ACTIVE', NULL, NULL, '2025-11-03 23:03:14'),
(8, 'huutv5@gmail.com', NULL, '$2b$10$LXdaycCIauXyu2DFwMuJ7eDtfHzrZAxJG7DkEhyPBqGUSJA9d63nK', 'LOCAL', 'Trương Trọng Hửu', NULL, NULL, NULL, 'KHACHHANG', 'ACTIVE', '67777e764efc769d853e515827f7e75ee6e693e50c3682089c43c42cb6ba121f', '2025-11-05 19:15:31', '2025-11-05 18:45:21');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `nguoidung_voucher`
--

CREATE TABLE `nguoidung_voucher` (
  `NguoiDungID` int(11) NOT NULL,
  `MaKhuyenMai` varchar(50) NOT NULL,
  `NgayNhan` datetime DEFAULT current_timestamp(),
  `TrangThai` enum('DA_NHAN','DA_SU_DUNG') NOT NULL DEFAULT 'DA_NHAN'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Đang đổ dữ liệu cho bảng `nguoidung_voucher`
--

INSERT INTO `nguoidung_voucher` (`NguoiDungID`, `MaKhuyenMai`, `NgayNhan`, `TrangThai`) VALUES
(5, 'FREE30K', '2025-11-03 17:13:09', 'DA_SU_DUNG'),
(6, 'FREE30K', '2025-11-02 17:56:18', 'DA_NHAN'),
(7, 'FREE30K', '2025-11-06 00:52:37', 'DA_SU_DUNG');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `paymentmethods`
--

CREATE TABLE `paymentmethods` (
  `MethodID` int(11) NOT NULL,
  `TenPhuongThuc` varchar(100) NOT NULL,
  `MoTa` text DEFAULT NULL,
  `Active` tinyint(1) DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Đang đổ dữ liệu cho bảng `paymentmethods`
--

INSERT INTO `paymentmethods` (`MethodID`, `TenPhuongThuc`, `MoTa`, `Active`) VALUES
(701, 'COD', 'Thanh toán khi nhận hàng', 1),
(702, 'VNPAY', 'Thanh toán qua cổng VNPAY', 1),
(703, 'MOMO', 'Thanh toán qua ví MoMo', 1),
(704, 'NGANHANG', 'Chuyển khoản trực tiếp', 1);

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `phienbansanpham`
--

CREATE TABLE `phienbansanpham` (
  `PhienBanID` int(11) NOT NULL,
  `SanPhamID` int(11) NOT NULL,
  `SKU` varchar(50) DEFAULT NULL,
  `GiaBan` decimal(10,2) NOT NULL CHECK (`GiaBan` >= 0),
  `SoLuongTonKho` int(11) DEFAULT 0 CHECK (`SoLuongTonKho` >= 0)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Đang đổ dữ liệu cho bảng `phienbansanpham`
--

INSERT INTO `phienbansanpham` (`PhienBanID`, `SanPhamID`, `SKU`, `GiaBan`, `SoLuongTonKho`) VALUES
(5001, 201, 'ATCB-S-TRANG', 99000.00, 52),
(5002, 201, 'ATCB-M-TRANG', 99000.00, 13),
(5003, 202, 'QJSF-S-XANH', 399000.00, 30),
(5004, 203, 'ATCT-M-DEN', 180000.00, 50),
(5005, 204, 'ASMNTD-M-DEN', 360000.00, 50),
(5006, 205, 'APNVCS-M-DEN', 270000.00, 50),
(5007, 206, 'AKND-M-DEN', 450000.00, 50),
(5008, 207, 'AHNNB-M-DEN', 405000.00, 50),
(5009, 208, 'QJNRG-M-DEN', 495000.00, 50),
(5010, 209, 'QSNK-M-DEN', 225000.00, 50),
(5011, 210, 'QKNDS-M-DEN', 342000.00, 50),
(5012, 211, 'QTNOD-M-DEN', 378000.00, 50),
(5013, 212, 'ATNFR-M-DEN', 198000.00, 50),
(5014, 213, 'ASMNL-M-DEN', 324000.00, 50),
(5015, 214, 'ACTP-M-DEN', 162000.00, 50),
(5016, 215, 'AHNTM-M-DEN', 432000.00, 50),
(5017, 216, 'AKNC-M-DEN', 351000.00, 50),
(5018, 217, 'QJNOL-M-DEN', 468000.00, 50),
(5019, 218, 'QSNJ-M-DEN', 252000.00, 50),
(5020, 219, 'QORNVT-M-DEN', 297000.00, 50),
(5021, 220, 'CVCA-M-DEN', 243000.00, 50),
(5022, 221, 'VDMV-M-DEN', 540000.00, 50),
(5023, 222, 'QLGN-M-DEN', 279000.00, 50),
(5024, 223, 'QSCB2L-M-DEN', 234000.00, 50),
(5025, 224, 'DBN1M-M-DEN', 405000.00, 50),
(5026, 225, 'AKTTCN-M-DEN', 270000.00, 49),
(5027, 226, 'AKDLB-M-DEN', 1350000.00, 50),
(5028, 227, 'VDBT-NAU', 450000.00, 50),
(5029, 228, 'GDNCS-40-DEN', 1170000.00, 50),
(5030, 229, 'MLT-FREE-DEN', 135000.00, 50),
(5031, 230, 'BLCN-DEN', 630000.00, 50),
(5032, 231, 'KMGT-DEN', 315000.00, 50),
(5033, 232, 'TCC-FREE-DEN', 45000.00, 50),
(5034, 233, 'TLDN-90CM-DEN', 360000.00, 50);

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `phiendangnhap`
--

CREATE TABLE `phiendangnhap` (
  `PhienID` int(11) NOT NULL,
  `NguoiDungID` int(11) NOT NULL,
  `Token` varchar(255) NOT NULL,
  `NgayTao` datetime DEFAULT current_timestamp(),
  `HetHan` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Đang đổ dữ liệu cho bảng `phiendangnhap`
--

INSERT INTO `phiendangnhap` (`PhienID`, `NguoiDungID`, `Token`, `NgayTao`, `HetHan`) VALUES
(1, 5, 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6NSwidmFpVHJvIjoiS0hBQ0hIQU5HIiwiaWF0IjoxNzYxOTk0NTg4LCJleHAiOjE3NjQ1ODY1ODh9.2-gWV-9TkKtyQ-cc7qVMM8miyBqR5E0N3XjzchDwR1o', '2025-11-01 17:56:28', '2025-12-01 17:56:28'),
(2, 6, 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6NiwidmFpVHJvIjoiS0hBQ0hIQU5HIiwiaWF0IjoxNzYxOTk0NjY1LCJleHAiOjE3NjQ1ODY2NjV9.7Te_bCRiZQCzVqZYA5Pa1v6-Jpyyg6L2bp-oaiIo90c', '2025-11-01 17:57:45', '2025-12-01 17:57:45'),
(3, 5, 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6NSwidmFpVHJvIjoiS0hBQ0hIQU5HIiwiaWF0IjoxNzYyMDA5MjAxLCJleHAiOjE3NjQ2MDEyMDF9.iV3-v6TXRFWdpkmvZmyTtpdolYjFgk1uzNbIxkzPRhM', '2025-11-01 22:00:01', '2025-12-01 22:00:01'),
(4, 5, 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6NSwidmFpVHJvIjoiS0hBQ0hIQU5HIiwiaWF0IjoxNzYyMDE4NDgyLCJleHAiOjE3NjQ2MTA0ODJ9.NIle1AfpJ02Igcur-5yvVVYjms2TWR2nGgQNX-OPv6E', '2025-11-02 00:34:42', '2025-12-02 00:34:42'),
(5, 5, 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6NSwidmFpVHJvIjoiS0hBQ0hIQU5HIiwiaWF0IjoxNzYyMDc3MjYwLCJleHAiOjE3NjQ2NjkyNjB9.ZDwq5y5u2ZAMUbtwONbiuZ2tmst08JpEVs9D1mXq5Cw', '2025-11-02 16:54:20', '2025-12-02 16:54:20'),
(6, 6, 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6NiwidmFpVHJvIjoiS0hBQ0hIQU5HIiwiaWF0IjoxNzYyMDc3NjE5LCJleHAiOjE3NjQ2Njk2MTl9.IxflC9KO1auR9zifHtWP5-RMm9iDlXQdCultsEyZM1s', '2025-11-02 17:00:19', '2025-12-02 17:00:19'),
(7, 4, 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6NCwidmFpVHJvIjoiQURNSU4iLCJpYXQiOjE3NjIwNzc2NjEsImV4cCI6MTc2NDY2OTY2MX0.-HFJJzPA1q0RRKTap2WnAFeWpXNeL0yPXjcUt7te6wU', '2025-11-02 17:01:01', '2025-12-02 17:01:01'),
(8, 5, 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6NSwidmFpVHJvIjoiS0hBQ0hIQU5HIiwiaWF0IjoxNzYyMDc3NzExLCJleHAiOjE3NjQ2Njk3MTF9.xh6szAjViTOYeFpvPODCyJGPn94Scc8HZoySvjEGpwY', '2025-11-02 17:01:51', '2025-12-02 17:01:51'),
(9, 5, 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6NSwidmFpVHJvIjoiS0hBQ0hIQU5HIiwiaWF0IjoxNzYyMDc4MjE0LCJleHAiOjE3NjQ2NzAyMTR9.Bzl9ALgFKK_I4kT4q0AcNcRMy0bdDVaqTa6T55umWnU', '2025-11-02 17:10:14', '2025-12-02 17:10:14'),
(10, 6, 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6NiwidmFpVHJvIjoiS0hBQ0hIQU5HIiwiaWF0IjoxNzYyMDc4MjQwLCJleHAiOjE3NjQ2NzAyNDB9.uvS_OllKDZyjGxoeDQKaDbmF8FMc_UhMt8qyQRwNdsQ', '2025-11-02 17:10:40', '2025-12-02 17:10:40'),
(11, 6, 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6NiwidmFpVHJvIjoiS0hBQ0hIQU5HIiwiaWF0IjoxNzYyMDc4MzEwLCJleHAiOjE3NjQ2NzAzMTB9.HFlGAnX5PkbGw545dHrsHiwhn6T9sYkkBNfijYibsEA', '2025-11-02 17:11:50', '2025-12-02 17:11:50'),
(12, 6, 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6NiwidmFpVHJvIjoiS0hBQ0hIQU5HIiwiaWF0IjoxNzYyMDc5MDI0LCJleHAiOjE3NjQ2NzEwMjR9.UxM6RCZ0vbDuf3D01VFcS0Bw0ZesvBU2jQwjKnT27jk', '2025-11-02 17:23:44', '2025-12-02 17:23:44'),
(13, 6, 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6NiwidmFpVHJvIjoiS0hBQ0hIQU5HIiwiaWF0IjoxNzYyMDg1NDQ3LCJleHAiOjE3NjQ2Nzc0NDd9.lx21ASxSeC_LqpK3JE0xZL6mFoF_xzl3I10Mm_y4rQI', '2025-11-02 19:10:47', '2025-12-02 19:10:47'),
(14, 5, 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6NSwidmFpVHJvIjoiS0hBQ0hIQU5HIiwiaWF0IjoxNzYyMTY0NTk4LCJleHAiOjE3NjQ3NTY1OTh9.V62LFFPEhkN9oadpBY6JCWAqJKaZVLCx6uZ2KIAxtb4', '2025-11-03 17:09:58', '2025-12-03 17:09:58'),
(15, 6, 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6NiwidmFpVHJvIjoiS0hBQ0hIQU5HIiwiaWF0IjoxNzYyMTY4MjgwLCJleHAiOjE3NjQ3NjAyODB9.4Z3bgIsI6fsZO84e8JsXe1gKmSkN5VhUWiNiZs-8mtk', '2025-11-03 18:11:20', '2025-12-03 18:11:20'),
(16, 5, 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6NSwidmFpVHJvIjoiS0hBQ0hIQU5HIiwiaWF0IjoxNzYyMTY4NDAzLCJleHAiOjE3NjQ3NjA0MDN9.17t2dH5UEJ8Bmnra1ombfTW5mFdLMaX14wiNpj8l6Yk', '2025-11-03 18:13:23', '2025-12-03 18:13:23'),
(17, 6, 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6NiwidmFpVHJvIjoiS0hBQ0hIQU5HIiwiaWF0IjoxNzYyMTY5NTk5LCJleHAiOjE3NjQ3NjE1OTl9.bvi-k0QAidilShW0H8grfCCwI6iTysR9FqDM8PZrYSY', '2025-11-03 18:33:19', '2025-12-03 18:33:19'),
(18, 5, 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6NSwidmFpVHJvIjoiS0hBQ0hIQU5HIiwiaWF0IjoxNzYyMTY5NjMwLCJleHAiOjE3NjQ3NjE2MzB9.KYdpyRst92XTOvrFIF23DGncgtDX-QI7vupZ7ZPE1Go', '2025-11-03 18:33:50', '2025-12-03 18:33:50'),
(19, 5, 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6NSwidmFpVHJvIjoiS0hBQ0hIQU5HIiwiaWF0IjoxNzYyMTczODgwLCJleHAiOjE3NjQ3NjU4ODB9.n-mIoJg-p4NOeOR1Wou98j-bNrGBPS4LWfWiM_JMi8Y', '2025-11-03 19:44:40', '2025-12-03 19:44:40'),
(20, 7, 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6NywidmFpVHJvIjoiS0hBQ0hIQU5HIiwiaWF0IjoxNzYyMTg1Nzk0LCJleHAiOjE3NjQ3Nzc3OTR9.hYHdbPA4e7oSHyVwCuYAk-hQXzf-wtl7_HyW4z8S_ZE', '2025-11-03 23:03:14', '2025-12-03 23:03:14'),
(21, 5, 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6NSwidmFpVHJvIjoiS0hBQ0hIQU5HIiwiaWF0IjoxNzYyMTg2MTg5LCJleHAiOjE3NjQ3NzgxODl9.u-Nz8SMseOpW2rHi1ypkKwijhLTbfz3-Np5ING5XrLY', '2025-11-03 23:09:49', '2025-12-03 23:09:49'),
(22, 6, 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6NiwidmFpVHJvIjoiS0hBQ0hIQU5HIiwiaWF0IjoxNzYyMTg2MjQzLCJleHAiOjE3NjQ3NzgyNDN9.j298A8QFlnRjYLvyiK7EcPI1Qsv41SXRiSV7YOug3nM', '2025-11-03 23:10:43', '2025-12-03 23:10:43'),
(23, 5, 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6NSwidmFpVHJvIjoiS0hBQ0hIQU5HIiwiaWF0IjoxNzYyMTg2MzM0LCJleHAiOjE3NjQ3NzgzMzR9.Ji9PfVX3w-kdIPcTwwgdJUfiFAkC9wvDV2cGZAFGiNs', '2025-11-03 23:12:14', '2025-12-03 23:12:14'),
(24, 6, 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6NiwidmFpVHJvIjoiS0hBQ0hIQU5HIiwiaWF0IjoxNzYyMTkxODYyLCJleHAiOjE3NjQ3ODM4NjJ9.KNdJ_TFntUI1xPQLgR2Um9xxj9Okf1JeoLJidMTxPCc', '2025-11-04 00:44:22', '2025-12-04 00:44:22'),
(25, 5, 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6NSwidmFpVHJvIjoiS0hBQ0hIQU5HIiwiaWF0IjoxNzYyMTk5MjcwLCJleHAiOjE3NjQ3OTEyNzB9.SSTgPs-SEYJLxeEHbiAPCu8BjmZON4Sd2uP7rvUsa6c', '2025-11-04 02:47:50', '2025-12-04 02:47:50'),
(26, 5, 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6NSwidmFpVHJvIjoiS0hBQ0hIQU5HIiwiaWF0IjoxNzYyMzI5Mjk5LCJleHAiOjE3NjQ5MjEyOTl9.GUegbwFMMofCFgZS_7Ee3Xj4j5Nh1RrPNKfXDcri_d8', '2025-11-05 14:54:59', '2025-12-05 14:54:59'),
(27, 5, 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6NSwidmFpVHJvIjoiS0hBQ0hIQU5HIiwiaWF0IjoxNzYyMzM4NTU1LCJleHAiOjE3NjQ5MzA1NTV9.RjbO92tZJs5CIinXnyTgfARLwe4xz_pqTWdJuJ-wbGs', '2025-11-05 17:29:15', '2025-12-05 17:29:15'),
(28, 8, 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6OCwidmFpVHJvIjoiS0hBQ0hIQU5HIiwiaWF0IjoxNzYyMzQzMTM0LCJleHAiOjE3NjQ5MzUxMzR9.flMs3baIOvWs-Vf825ljIPs_QJnXlXfqQ8v5_29oOWI', '2025-11-05 18:45:34', '2025-12-05 18:45:34'),
(29, 8, 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6OCwidmFpVHJvIjoiS0hBQ0hIQU5HIiwiaWF0IjoxNzYyMzQ0NDExLCJleHAiOjE3NjQ5MzY0MTF9.e_1AeRoHqkFyNeZJYFTB1ASNtBgnUbk3anB60m5qP0Q', '2025-11-05 19:06:51', '2025-12-05 19:06:51'),
(30, 5, 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6NSwidmFpVHJvIjoiS0hBQ0hIQU5HIiwiaWF0IjoxNzYyMzQ0NjgxLCJleHAiOjE3NjQ5MzY2ODF9.8mHAaem8d-DdAqi5mnGL9bKFR_Dpi-SnTn8VSsBYp20', '2025-11-05 19:11:21', '2025-12-05 19:11:21'),
(31, 6, 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6NiwidmFpVHJvIjoiS0hBQ0hIQU5HIiwiaWF0IjoxNzYyMzQ2Njc1LCJleHAiOjE3NjQ5Mzg2NzV9.Hjx3f5dkgHsVvh5tH88iosOFlk6cjm3e5VtxH-0PxYw', '2025-11-05 19:44:35', '2025-12-05 19:44:35'),
(32, 7, 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6NywidmFpVHJvIjoiS0hBQ0hIQU5HIiwiaWF0IjoxNzYyMzY0OTY1LCJleHAiOjE3NjQ5NTY5NjV9.44nx15yxCYPUDn3y5c6wzY1fpMW6Ri8KgGEHQqm6fvw', '2025-11-06 00:49:25', '2025-12-06 00:49:25');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `phuongthucvanchuyen`
--

CREATE TABLE `phuongthucvanchuyen` (
  `PhuongThucID` int(11) NOT NULL,
  `TenPhuongThuc` varchar(100) NOT NULL,
  `PhiCoDinh` decimal(10,2) DEFAULT 0.00 CHECK (`PhiCoDinh` >= 0),
  `MoTa` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Đang đổ dữ liệu cho bảng `phuongthucvanchuyen`
--

INSERT INTO `phuongthucvanchuyen` (`PhuongThucID`, `TenPhuongThuc`, `PhiCoDinh`, `MoTa`) VALUES
(601, 'Giao hàng Tiết kiệm', 30000.00, NULL),
(602, 'Giao hàng Hỏa tốc', 50000.00, NULL);

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `producttags`
--

CREATE TABLE `producttags` (
  `SanPhamID` int(11) NOT NULL,
  `TagID` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `returns`
--

CREATE TABLE `returns` (
  `ReturnID` int(11) NOT NULL,
  `DonHangID` int(11) NOT NULL,
  `Reason` text NOT NULL,
  `Status` enum('PENDING','APPROVED','REJECTED','COMPLETED') DEFAULT 'PENDING',
  `RefundAmount` decimal(10,2) DEFAULT NULL CHECK (`RefundAmount` >= 0),
  `NgayYeuCau` datetime DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
ALTER TABLE `returns`
ADD COLUMN `NgayCapNhat` DATETIME DEFAULT NULL;
ALTER TABLE `returns` ADD COLUMN `NguoiCapNhat` INT DEFAULT NULL;
-- 
-- Đang đổ dữ liệu cho bảng `returns`
--

INSERT INTO `returns` (`ReturnID`, `DonHangID`, `Reason`, `Status`, `RefundAmount`, `NgayYeuCau`) VALUES
(1, 1004, 'Sai kích thước', 'APPROVED', NULL, '2025-11-04 01:46:26'),
(2, 1003, 'Sản phẩm bị lỗi', 'APPROVED', NULL, '2025-11-04 01:54:38'),
(4, 1005, 'Sản phẩm lỗi', 'PENDING', NULL, '2025-11-04 02:34:25'),
(5, 1008, 'Đặt nhầm', 'APPROVED', NULL, '2025-11-04 02:49:43');

--
-- Bẫy `returns`
--
DELIMITER $$
CREATE TRIGGER `trig_after_update_returns_approve` AFTER UPDATE ON `returns` FOR EACH ROW BEGIN
    -- Chỉ chạy khi trạng thái đổi từ PENDING -> APPROVED (hoặc COMPLETED)
    IF (OLD.Status = 'PENDING' AND (NEW.Status = 'APPROVED' OR NEW.Status = 'COMPLETED')) THEN
        
        -- Cộng trả tồn kho cho TẤT CẢ sản phẩm trong phiếu trả hàng đó
        UPDATE PhienBanSanPham AS p
        INNER JOIN ChiTietReturns AS ctr ON p.PhienBanID = ctr.PhienBanID
        SET p.SoLuongTonKho = p.SoLuongTonKho + ctr.SoLuongTra
        WHERE ctr.ReturnID = NEW.ReturnID;
    END IF;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `sanpham`
--

CREATE TABLE `sanpham` (
  `SanPhamID` int(11) NOT NULL,
  `DanhMucID` int(11) DEFAULT NULL,
  `TenSanPham` varchar(255) NOT NULL,
  `Slug` varchar(255) NOT NULL,
  `MoTa` text DEFAULT NULL,
  `ThuongHieu` varchar(100) DEFAULT NULL,
  `ChatLieu` varchar(100) DEFAULT NULL,
  `GiaGoc` decimal(10,2) DEFAULT NULL CHECK (`GiaGoc` >= 0),
  `TrangThai` enum('ACTIVE','DRAFT','ARCHIVED','HET_HANG') DEFAULT 'DRAFT',
  `BanChay` tinyint(1) DEFAULT 0,
  `LuotXem` int(11) DEFAULT 0 CHECK (`LuotXem` >= 0),
  `NgayTao` datetime DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Đang đổ dữ liệu cho bảng `sanpham`
--

INSERT INTO `sanpham` (`SanPhamID`, `DanhMucID`, `TenSanPham`, `Slug`, `MoTa`, `ThuongHieu`, `ChatLieu`, `GiaGoc`, `TrangThai`, `BanChay`, `LuotXem`, `NgayTao`) VALUES
(201, 406, 'Áo Thun Cotton Cơ Bản', 'ao-thun-cotton-co-ban', 'Thông tin sản phẩm Áo Thun:\n- Hàng chuẩn sản xuất, với những mẫu áo ý nghĩa, hài hước và độc đáo.\n- Chất liệu: thun cotton 100%, co giãn 2 chiều, vải mềm, vải mịn, thoáng mát, không xù lông.\n- Đường may chuẩn chỉnh, tỉ mỉ, chắc chắn.\n- Họa tiết được in bằng bằng công nghệ Pet Kĩ thuật số, rất chi tiết và bền màu.\n- Thiết kế với những mẫu in độc đáo!\nCó đủ các size từ   S, M, L, XL Chuẩn Form Oversize, Định Lượng 260GSM\nHướng dẫn sử dụng sản phẩm:\n- Nhớ lộn trái áo khi giặt máy và không ngâm lâu trong nước giặt\n- Không sử dụng thuốc tẩy\n- Khi phơi lộn trái và không phơi trực tiếp dưới ánh nắng mặt trời để bảo quản hình trên áo luôn đẹp\n Điều kiện áp dụng đổi sản phẩm (trong vòng 07 ngày kể từ khi nhận sản phẩm) \n- Hàng hoá sai mẫu mã do người gửi\n- Hàng hoá bị lỗi hoặc hư hỏng do vận chuyển hoặc do nhà sản xuất \nCách Thức Về Đổi Trả Sản Phẩm\n- Chúng mình chỉ nhận đổi trả sản phẩm trong vòng 7 ngày \"kể từ khi bạn nhận được hàng\", và lỗi về thiết kế hoặc chất lượng áo, Chúng mình không hỗ trợ đổi trả khi khách hàng chọn sai kích thước \" size áo \". Nếu bạn cảm thấy khó trong vấn đề chọn size thì đừng ngừng ngại Inbox cho tụi mình nhé.\nDo màn hình và điều kiện ánh sáng khác nhau, màu sắc thực tế của sản phẩm có thể chênh lệch khoảng 2-5%', 'BLANK CANVAS', 'Cotton 100%', 120000.00, 'ACTIVE', 0, 0, '2025-11-01 15:40:00'),
(202, 411, 'Quần Jean Slim Fit', 'quan-jean-slim-fit', 'Thông tin sản phẩm Quần Jean Slim Fit:\n- Hàng thiết kế và sản xuất bởi DenimPro, đảm bảo chất lượng và form dáng.\n- Chất liệu: Vải Jean Cotton cao cấp, co giãn nhẹ, thoáng mát, giữ form, và thân thiện với da.\n- Đường may tỉ mỉ, tinh tế, không chỉ thừa, đạt tiêu chuẩn xuất khẩu.\n- Phù hợp mặc đi làm, đi chơi, dạo phố hoặc các sự kiện quan trọng.\n- Thiết kế Quần Jean Slim Fit hiện đại, trẻ trung, dễ dàng phối đồ.\n\nCó đủ các size từ S, M, L, XL, XXL (Vui lòng tham khảo bảng size chi tiết).\n\nHướng dẫn sử dụng sản phẩm:\n- Ưu tiên giặt tay ở nhiệt độ thường để giữ độ bền của Vải Jean Cotton.\n- Hạn chế giặt máy. Nếu giặt máy, nên lộn trái sản phẩm và cho vào túi giặt.\n- Không sử dụng thuốc tẩy hoặc ngâm sản phẩm quá lâu.\n- Phơi ở nơi thoáng mát, tránh ánh nắng mặt trời trực tiếp.\n\nĐiều kiện áp dụng đổi sản phẩm (trong vòng 07 ngày kể từ khi nhận sản phẩm):\n- Hàng hoá còn mới, chưa qua sử dụng, còn nguyên tem mác.\n- Hàng hoá bị lỗi hoặc hư hỏng do vận chuyển hoặc do nhà sản xuất.\n\nLưu ý:\n- Do màn hình và điều kiện ánh sáng khác nhau, màu sắc thực tế của sản phẩm có thể chênh lệch khoảng 3-5%.', 'DenimPro', 'Vải Jean Cotton', 450000.00, 'ACTIVE', 0, 0, '2025-11-02 15:40:00'),
(203, 406, 'Áo Thun Nam Cổ Tròn', 'ao-thun-nam-co-tron', 'Thông tin sản phẩm Áo Thun Nam Cổ Tròn:\n- Hàng thiết kế và sản xuất bởi UrbanFlex, đảm bảo chất lượng và form dáng.\n- Chất liệu: Cotton 4 chiều cao cấp, siêu co giãn, thấm hút mồ hôi, và thân thiện với da.\n- Đường may tỉ mỉ, tinh tế, không chỉ thừa, đạt tiêu chuẩn xuất khẩu.\n- Phù hợp mặc đi làm, đi chơi, dạo phố hoặc các sự kiện quan trọng.\n- Thiết kế Áo Thun Nam Cổ Tròn hiện đại, trẻ trung, dễ dàng phối đồ.\n\nCó đủ các size từ S, M, L, XL, XXL (Vui lòng tham khảo bảng size chi tiết).\n\nHướng dẫn sử dụng sản phẩm:\n- Ưu tiên giặt tay ở nhiệt độ thường để giữ độ bền của Cotton 4 chiều.\n- Hạn chế giặt máy. Nếu giặt máy, nên lộn trái sản phẩm và cho vào túi giặt.\n- Không sử dụng thuốc tẩy hoặc ngâm sản phẩm quá lâu.\n- Phơi ở nơi thoáng mát, tránh ánh nắng mặt trời trực tiếp.\n\nĐiều kiện áp dụng đổi sản phẩm (trong vòng 07 ngày kể từ khi nhận sản phẩm):\n- Hàng hoá còn mới, chưa qua sử dụng, còn nguyên tem mác.\n- Hàng hoá bị lỗi hoặc hư hỏng do vận chuyển hoặc do nhà sản xuất.\n\nLưu ý:\n- Do màn hình và điều kiện ánh sáng khác nhau, màu sắc thực tế của sản phẩm có thể chênh lệch khoảng 3-5%.', 'UrbanFlex', 'Cotton 4 chiều', 200000.00, 'ACTIVE', 0, 0, '2025-11-04 18:11:41'),
(204, 407, 'Áo Sơ Mi Nam Tay Dài', 'ao-so-mi-nam-tay-dai', 'Thông tin sản phẩm Áo Sơ Mi Nam Tay Dài:\n- Hàng thiết kế và sản xuất bởi Elegante, đảm bảo chất lượng và form dáng.\n- Chất liệu: Vải Kate Lụa cao cấp, chống nhăn, thoáng mát, giữ form, và thân thiện với da.\n- Đường may tỉ mỉ, tinh tế, không chỉ thừa, đạt tiêu chuẩn xuất khẩu.\n- Phù hợp mặc đi làm, đi chơi, dạo phố hoặc các sự kiện quan trọng.\n- Thiết kế Áo Sơ Mi Nam Tay Dài hiện đại, trẻ trung, dễ dàng phối đồ.\n\nCó đủ các size từ S, M, L, XL, XXL (Vui lòng tham khảo bảng size chi tiết).\n\nHướng dẫn sử dụng sản phẩm:\n- Ưu tiên giặt tay ở nhiệt độ thường để giữ độ bền của Vải Kate Lụa.\n- Hạn chế giặt máy. Nếu giặt máy, nên lộn trái sản phẩm và cho vào túi giặt.\n- Không sử dụng thuốc tẩy hoặc ngâm sản phẩm quá lâu.\n- Phơi ở nơi thoáng mát, tránh ánh nắng mặt trời trực tiếp.\n\nĐiều kiện áp dụng đổi sản phẩm (trong vòng 07 ngày kể từ khi nhận sản phẩm):\n- Hàng hoá còn mới, chưa qua sử dụng, còn nguyên tem mác.\n- Hàng hoá bị lỗi hoặc hư hỏng do vận chuyển hoặc do nhà sản xuất.\n\nLưu ý:\n- Do màn hình và điều kiện ánh sáng khác nhau, màu sắc thực tế của sản phẩm có thể chênh lệch khoảng 3-5%.', 'Elegante', 'Vải Kate Lụa', 400000.00, 'ACTIVE', 0, 0, '2025-11-04 18:11:41'),
(205, 408, 'Áo Polo Nam Vải Cá Sấu', 'ao-polo-nam-vai-ca-sau', 'Thông tin sản phẩm Áo Polo Nam Vải Cá Sấu:\n- Hàng thiết kế và sản xuất bởi ActiveWear, đảm bảo chất lượng và form dáng.\n- Chất liệu: Vải Cotton Pique (Cá Sấu) cao cấp, thoáng mát, giữ form, và thân thiện với da.\n- Đường may tỉ mỉ, tinh tế, không chỉ thừa, đạt tiêu chuẩn xuất khẩu.\n- Phù hợp mặc đi làm, đi chơi, dạo phố hoặc các sự kiện quan trọng.\n- Thiết kế Áo Polo Nam Vải Cá Sấu hiện đại, trẻ trung, dễ dàng phối đồ.\n\nCó đủ các size từ S, M, L, XL, XXL (Vui lòng tham khảo bảng size chi tiết).\n\nHướng dẫn sử dụng sản phẩm:\n- Ưu tiên giặt tay ở nhiệt độ thường để giữ độ bền của Vải Cotton Pique (Cá Sấu).\n- Hạn chế giặt máy. Nếu giặt máy, nên lộn trái sản phẩm và cho vào túi giặt.\n- Không sử dụng thuốc tẩy hoặc ngâm sản phẩm quá lâu.\n- Phơi ở nơi thoáng mát, tránh ánh nắng mặt trời trực tiếp.\n\nĐiều kiện áp dụng đổi sản phẩm (trong vòng 07 ngày kể từ khi nhận sản phẩm):\n- Hàng hoá còn mới, chưa qua sử dụng, còn nguyên tem mác.\n- Hàng hoá bị lỗi hoặc hư hỏng do vận chuyển hoặc do nhà sản xuất.\n\nLưu ý:\n- Do màn hình và điều kiện ánh sáng khác nhau, màu sắc thực tế của sản phẩm có thể chênh lệch khoảng 3-5%.', 'ActiveWear', 'Vải Cotton Pique (Cá Sấu)', 300000.00, 'ACTIVE', 0, 0, '2025-11-04 18:11:41'),
(206, 409, 'Áo Khoác Nam Dù', 'ao-khoac-nam-du', 'Thông tin sản phẩm Áo Khoác Nam Dù:\n- Hàng thiết kế và sản xuất bởi WindBreaker, đảm bảo chất lượng và form dáng.\n- Chất liệu: Vải Dù 2 lớp cao cấp, chống gió, trượt nước nhẹ, và thân thiện với da.\n- Đường may tỉ mỉ, tinh tế, không chỉ thừa, đạt tiêu chuẩn xuất khẩu.\n- Phù hợp mặc đi làm, đi chơi, dạo phố hoặc các sự kiện quan trọng.\n- Thiết kế Áo Khoác Nam Dù hiện đại, trẻ trung, dễ dàng phối đồ.\n\nCó đủ các size từ S, M, L, XL, XXL (Vui lòng tham khảo bảng size chi tiết).\n\nHướng dẫn sử dụng sản phẩm:\n- Ưu tiên giặt tay ở nhiệt độ thường để giữ độ bền của Vải Dù 2 lớp.\n- Hạn chế giặt máy. Nếu giặt máy, nên lộn trái sản phẩm và cho vào túi giặt.\n- Không sử dụng thuốc tẩy hoặc ngâm sản phẩm quá lâu.\n- Phơi ở nơi thoáng mát, tránh ánh nắng mặt trời trực tiếp.\n\nĐiều kiện áp dụng đổi sản phẩm (trong vòng 07 ngày kể từ khi nhận sản phẩm):\n- Hàng hoá còn mới, chưa qua sử dụng, còn nguyên tem mác.\n- Hàng hoá bị lỗi hoặc hư hỏng do vận chuyển hoặc do nhà sản xuất.\n\nLưu ý:\n- Do màn hình và điều kiện ánh sáng khác nhau, màu sắc thực tế của sản phẩm có thể chênh lệch khoảng 3-5%.', 'WindBreaker', 'Vải Dù 2 lớp', 500000.00, 'ACTIVE', 0, 0, '2025-11-04 18:11:41'),
(207, 410, 'Áo Hoodie Nam Nỉ Bông', 'ao-hoodie-nam-ni-bong', 'Thông tin sản phẩm Áo Hoodie Nam Nỉ Bông:\n- Hàng thiết kế và sản xuất bởi CozyWear, đảm bảo chất lượng và form dáng.\n- Chất liệu: Vải Nỉ Bông Dày cao cấp, ấm áp, giữ form, và thân thiện với da.\n- Đường may tỉ mỉ, tinh tế, không chỉ thừa, đạt tiêu chuẩn xuất khẩu.\n- Phù hợp mặc đi làm, đi chơi, dạo phố hoặc các sự kiện quan trọng.\n- Thiết kế Áo Hoodie Nam Nỉ Bông hiện đại, trẻ trung, dễ dàng phối đồ.\n\nCó đủ các size từ S, M, L, XL, XXL (Vui lòng tham khảo bảng size chi tiết).\n\nHướng dẫn sử dụng sản phẩm:\n- Ưu tiên giặt tay ở nhiệt độ thường để giữ độ bền của Vải Nỉ Bông Dày.\n- Hạn chế giặt máy. Nếu giặt máy, nên lộn trái sản phẩm và cho vào túi giặt.\n- Không sử dụng thuốc tẩy hoặc ngâm sản phẩm quá lâu.\n- Phơi ở nơi thoáng mát, tránh ánh nắng mặt trời trực tiếp.\n\nĐiều kiện áp dụng đổi sản phẩm (trong vòng 07 ngày kể từ khi nhận sản phẩm):\n- Hàng hoá còn mới, chưa qua sử dụng, còn nguyên tem mác.\n- Hàng hoá bị lỗi hoặc hư hỏng do vận chuyển hoặc do nhà sản xuất.\n\nLưu ý:\n- Do màn hình và điều kiện ánh sáng khác nhau, màu sắc thực tế của sản phẩm có thể chênh lệch khoảng 3-5%.', 'CozyWear', 'Vải Nỉ Bông Dày', 450000.00, 'ACTIVE', 0, 0, '2025-11-04 18:11:41'),
(208, 411, 'Quần Jean Nam Rách Gối', 'quan-jean-nam-rach-goi', 'Thông tin sản phẩm Quần Jean Nam Rách Gối:\n- Hàng thiết kế và sản xuất bởi RippedStyle, đảm bảo chất lượng và form dáng.\n- Chất liệu: Vải Jean Bụi cao cấp, thoáng mát, giữ form, và thân thiện với da.\n- Đường may tỉ mỉ, tinh tế, không chỉ thừa, đạt tiêu chuẩn xuất khẩu.\n- Phù hợp mặc đi làm, đi chơi, dạo phố hoặc các sự kiện quan trọng.\n- Thiết kế Quần Jean Nam Rách Gối hiện đại, trẻ trung, dễ dàng phối đồ.\n\nCó đủ các size từ S, M, L, XL, XXL (Vui lòng tham khảo bảng size chi tiết).\n\nHướng dẫn sử dụng sản phẩm:\n- Ưu tiên giặt tay ở nhiệt độ thường để giữ độ bền của Vải Jean Bụi.\n- Hạn chế giặt máy. Nếu giặt máy, nên lộn trái sản phẩm và cho vào túi giặt.\n- Không sử dụng thuốc tẩy hoặc ngâm sản phẩm quá lâu.\n- Phơi ở nơi thoáng mát, tránh ánh nắng mặt trời trực tiếp.\n\nĐiều kiện áp dụng đổi sản phẩm (trong vòng 07 ngày kể từ khi nhận sản phẩm):\n- Hàng hoá còn mới, chưa qua sử dụng, còn nguyên tem mác.\n- Hàng hoá bị lỗi hoặc hư hỏng do vận chuyển hoặc do nhà sản xuất.\n\nLưu ý:\n- Do màn hình và điều kiện ánh sáng khác nhau, màu sắc thực tế của sản phẩm có thể chênh lệch khoảng 3-5%.', 'RippedStyle', 'Vải Jean Bụi', 550000.00, 'ACTIVE', 0, 0, '2025-11-04 18:11:41'),
(209, 412, 'Quần Short Nam Kaki', 'quan-short-nam-kaki', 'Thông tin sản phẩm Quần Short Nam Kaki:\n- Hàng thiết kế và sản xuất bởi UrbanFlex, đảm bảo chất lượng và form dáng.\n- Chất liệu: Vải Kaki Cotton cao cấp, thoáng mát, giữ form, và thân thiện với da.\n- Đường may tỉ mỉ, tinh tế, không chỉ thừa, đạt tiêu chuẩn xuất khẩu.\n- Phù hợp mặc đi làm, đi chơi, dạo phố hoặc các sự kiện quan trọng.\n- Thiết kế Quần Short Nam Kaki hiện đại, trẻ trung, dễ dàng phối đồ.\n\nCó đủ các size từ S, M, L, XL, XXL (Vui lòng tham khảo bảng size chi tiết).\n\nHướng dẫn sử dụng sản phẩm:\n- Ưu tiên giặt tay ở nhiệt độ thường để giữ độ bền của Vải Kaki Cotton.\n- Hạn chế giặt máy. Nếu giặt máy, nên lộn trái sản phẩm và cho vào túi giặt.\n- Không sử dụng thuốc tẩy hoặc ngâm sản phẩm quá lâu.\n- Phơi ở nơi thoáng mát, tránh ánh nắng mặt trời trực tiếp.\n\nĐiều kiện áp dụng đổi sản phẩm (trong vòng 07 ngày kể từ khi nhận sản phẩm):\n- Hàng hoá còn mới, chưa qua sử dụng, còn nguyên tem mác.\n- Hàng hoá bị lỗi hoặc hư hỏng do vận chuyển hoặc do nhà sản xuất.\n\nLưu ý:\n- Do màn hình và điều kiện ánh sáng khác nhau, màu sắc thực tế của sản phẩm có thể chênh lệch khoảng 3-5%.', 'UrbanFlex', 'Vải Kaki Cotton', 250000.00, 'ACTIVE', 0, 0, '2025-11-04 18:11:41'),
(210, 413, 'Quần Kaki Nam Dáng Slim', 'quan-kaki-nam-dang-slim', 'Thông tin sản phẩm Quần Kaki Nam Dáng Slim:\n- Hàng thiết kế và sản xuất bởi Elegante, đảm bảo chất lượng và form dáng.\n- Chất liệu: Vải Kaki Co Giãn cao cấp, thoáng mát, giữ form, và thân thiện với da.\n- Đường may tỉ mỉ, tinh tế, không chỉ thừa, đạt tiêu chuẩn xuất khẩu.\n- Phù hợp mặc đi làm, đi chơi, dạo phố hoặc các sự kiện quan trọng.\n- Thiết kế Quần Kaki Nam Dáng Slim hiện đại, trẻ trung, dễ dàng phối đồ.\n\nCó đủ các size từ S, M, L, XL, XXL (Vui lòng tham khảo bảng size chi tiết).\n\nHướng dẫn sử dụng sản phẩm:\n- Ưu tiên giặt tay ở nhiệt độ thường để giữ độ bền của Vải Kaki Co Giãn.\n- Hạn chế giặt máy. Nếu giặt máy, nên lộn trái sản phẩm và cho vào túi giặt.\n- Không sử dụng thuốc tẩy hoặc ngâm sản phẩm quá lâu.\n- Phơi ở nơi thoáng mát, tránh ánh nắng mặt trời trực tiếp.\n\nĐiều kiện áp dụng đổi sản phẩm (trong vòng 07 ngày kể từ khi nhận sản phẩm):\n- Hàng hoá còn mới, chưa qua sử dụng, còn nguyên tem mác.\n- Hàng hoá bị lỗi hoặc hư hỏng do vận chuyển hoặc do nhà sản xuất.\n\nLưu ý:\n- Do màn hình và điều kiện ánh sáng khác nhau, màu sắc thực tế của sản phẩm có thể chênh lệch khoảng 3-5%.', 'Elegante', 'Vải Kaki Co Giãn', 380000.00, 'ACTIVE', 0, 0, '2025-11-04 18:11:41'),
(211, 414, 'Quần Tây Nam Ống Đứng', 'quan-tay-nam-ong-dung', 'Thông tin sản phẩm Quần Tây Nam Ống Đứng:\n- Hàng thiết kế và sản xuất bởi OfficeStyle, đảm bảo chất lượng và form dáng.\n- Chất liệu: Vải Tây Cao Cấp cao cấp, chống nhăn, thoáng mát, giữ form, và thân thiện với da.\n- Đường may tỉ mỉ, tinh tế, không chỉ thừa, đạt tiêu chuẩn xuất khẩu.\n- Phù hợp mặc đi làm, đi chơi, dạo phố hoặc các sự kiện quan trọng.\n- Thiết kế Quần Tây Nam Ống Đứng hiện đại, trẻ trung, dễ dàng phối đồ.\n\nCó đủ các size từ S, M, L, XL, XXL (Vui lòng tham khảo bảng size chi tiết).\n\nHướng dẫn sử dụng sản phẩm:\n- Ưu tiên giặt tay ở nhiệt độ thường để giữ độ bền của Vải Tây Cao Cấp.\n- Hạn chế giặt máy. Nếu giặt máy, nên lộn trái sản phẩm và cho vào túi giặt.\n- Không sử dụng thuốc tẩy hoặc ngâm sản phẩm quá lâu.\n- Phơi ở nơi thoáng mát, tránh ánh nắng mặt trời trực tiếp.\n\nĐiều kiện áp dụng đổi sản phẩm (trong vòng 07 ngày kể từ khi nhận sản phẩm):\n- Hàng hoá còn mới, chưa qua sử dụng, còn nguyên tem mác.\n- Hàng hoá bị lỗi hoặc hư hỏng do vận chuyển hoặc do nhà sản xuất.\n\nLưu ý:\n- Do màn hình và điều kiện ánh sáng khác nhau, màu sắc thực tế của sản phẩm có thể chênh lệch khoảng 3-5%.', 'OfficeStyle', 'Vải Tây Cao Cấp', 420000.00, 'ACTIVE', 0, 0, '2025-11-04 18:11:41'),
(212, 415, 'Áo Thun Nữ Form Rộng', 'ao-thun-nu-form-rong', 'Thông tin sản phẩm Áo Thun Nữ Form Rộng:\n- Hàng thiết kế và sản xuất bởi DivaStyle, đảm bảo chất lượng và form dáng.\n- Chất liệu: Cotton 100% 2 chiều cao cấp, thoáng mát, giữ form, và thân thiện với da.\n- Đường may tỉ mỉ, tinh tế, không chỉ thừa, đạt tiêu chuẩn xuất khẩu.\n- Phù hợp mặc đi làm, đi chơi, dạo phố hoặc các sự kiện quan trọng.\n- Thiết kế Áo Thun Nữ Form Rộng hiện đại, trẻ trung, dễ dàng phối đồ.\n\nCó đủ các size từ S, M, L, XL, XXL (Vui lòng tham khảo bảng size chi tiết).\n\nHướng dẫn sử dụng sản phẩm:\n- Ưu tiên giặt tay ở nhiệt độ thường để giữ độ bền của Cotton 100% 2 chiều.\n- Hạn chế giặt máy. Nếu giặt máy, nên lộn trái sản phẩm và cho vào túi giặt.\n- Không sử dụng thuốc tẩy hoặc ngâm sản phẩm quá lâu.\n- Phơi ở nơi thoáng mát, tránh ánh nắng mặt trời trực tiếp.\n\nĐiều kiện áp dụng đổi sản phẩm (trong vòng 07 ngày kể từ khi nhận sản phẩm):\n- Hàng hoá còn mới, chưa qua sử dụng, còn nguyên tem mác.\n- Hàng hoá bị lỗi hoặc hư hỏng do vận chuyển hoặc do nhà sản xuất.\n\nLưu ý:\n- Do màn hình và điều kiện ánh sáng khác nhau, màu sắc thực tế của sản phẩm có thể chênh lệch khoảng 3-5%.', 'DivaStyle', 'Cotton 100% 2 chiều', 220000.00, 'ACTIVE', 0, 0, '2025-11-04 18:11:41'),
(213, 416, 'Áo Sơ Mi Nữ Lụa', 'ao-so-mi-nu-lua', 'Thông tin sản phẩm Áo Sơ Mi Nữ Lụa:\n- Hàng thiết kế và sản xuất bởi SilkSation, đảm bảo chất lượng và form dáng.\n- Chất liệu: Vải Lụa Satin cao cấp, mềm mịn, thoáng mát, giữ form, và thân thiện với da.\n- Đường may tỉ mỉ, tinh tế, không chỉ thừa, đạt tiêu chuẩn xuất khẩu.\n- Phù hợp mặc đi làm, đi chơi, dạo phố hoặc các sự kiện quan trọng.\n- Thiết kế Áo Sơ Mi Nữ Lụa hiện đại, trẻ trung, dễ dàng phối đồ.\n\nCó đủ các size từ S, M, L, XL, XXL (Vui lòng tham khảo bảng size chi tiết).\n\nHướng dẫn sử dụng sản phẩm:\n- Ưu tiên giặt tay ở nhiệt độ thường để giữ độ bền của Vải Lụa Satin.\n- Hạn chế giặt máy. Nếu giặt máy, nên lộn trái sản phẩm và cho vào túi giặt.\n- Không sử dụng thuốc tẩy hoặc ngâm sản phẩm quá lâu.\n- Phơi ở nơi thoáng mát, tránh ánh nắng mặt trời trực tiếp.\n\nĐiều kiện áp dụng đổi sản phẩm (trong vòng 07 ngày kể từ khi nhận sản phẩm):\n- Hàng hoá còn mới, chưa qua sử dụng, còn nguyên tem mác.\n- Hàng hoá bị lỗi hoặc hư hỏng do vận chuyển hoặc do nhà sản xuất.\n\nLưu ý:\n- Do màn hình và điều kiện ánh sáng khác nhau, màu sắc thực tế của sản phẩm có thể chênh lệch khoảng 3-5%.', 'SilkySation', 'Vải Lụa Satin', 360000.00, 'ACTIVE', 0, 0, '2025-11-04 18:11:41'),
(214, 417, 'Áo Croptop Tay Phồng', 'ao-croptop-tay-phong', 'Thông tin sản phẩm Áo Croptop Tay Phồng:\n- Hàng thiết kế và sản xuất bởi DivaStyle, đảm bảo chất lượng và form dáng.\n- Chất liệu: Vải Kate Forrm cao cấp, thoáng mát, giữ form, và thân thiện với da.\n- Đường may tỉ mỉ, tinh tế, không chỉ thừa, đạt tiêu chuẩn xuất khẩu.\n- Phù hợp mặc đi làm, đi chơi, dạo phố hoặc các sự kiện quan trọng.\n- Thiết kế Áo Croptop Tay Phồng hiện đại, trẻ trung, dễ dàng phối đồ.\n\nCó đủ các size từ S, M, L, XL, XXL (Vui lòng tham khảo bảng size chi tiết).\n\nHướng dẫn sử dụng sản phẩm:\n- Ưu tiên giặt tay ở nhiệt độ thường để giữ độ bền của Vải Kate Forrm.\n- Hạn chế giặt máy. Nếu giặt máy, nên lộn trái sản phẩm và cho vào túi giặt.\n- Không sử dụng thuốc tẩy hoặc ngâm sản phẩm quá lâu.\n- Phơi ở nơi thoáng mát, tránh ánh nắng mặt trời trực tiếp.\n\nĐiều kiện áp dụng đổi sản phẩm (trong vòng 07 ngày kể từ khi nhận sản phẩm):\n- Hàng hoá còn mới, chưa qua sử dụng, còn nguyên tem mác.\n- Hàng hoá bị lỗi hoặc hư hỏng do vận chuyển hoặc do nhà sản xuất.\n\nLưu ý:\n- Do màn hình và điều kiện ánh sáng khác nhau, màu sắc thực tế của sản phẩm có thể chênh lệch khoảng 3-5%.', 'DivaStyle', 'Vải Kate Forrm', 180000.00, 'ACTIVE', 0, 0, '2025-11-04 18:11:41'),
(215, 418, 'Áo Hoodie Nữ Tai Mèo', 'ao-hoodie-nu-tai-meo', 'Thông tin sản phẩm Áo Hoodie Nữ Tai Mèo:\n- Hàng thiết kế và sản xuất bởi CozyWear, đảm bảo chất lượng và form dáng.\n- Chất liệu: Vải Nỉ Bông Mịn cao cấp, ấm áp, giữ form, và thân thiện với da.\n- Đường may tỉ mỉ, tinh tế, không chỉ thừa, đạt tiêu chuẩn xuất khẩu.\n- Phù hợp mặc đi làm, đi chơi, dạo phố hoặc các sự kiện quan trọng.\n- Thiết kế Áo Hoodie Nữ Tai Mèo hiện đại, trẻ trung, dễ dàng phối đồ.\n\nCó đủ các size từ S, M, L, XL, XXL (Vui lòng tham khảo bảng size chi tiết).\n\nHướng dẫn sử dụng sản phẩm:\n- Ưu tiên giặt tay ở nhiệt độ thường để giữ độ bền của Vải Nỉ Bông Mịn.\n- Hạn chế giặt máy. Nếu giặt máy, nên lộn trái sản phẩm và cho vào túi giặt.\n- Không sử dụng thuốc tẩy hoặc ngâm sản phẩm quá lâu.\n- Phơi ở nơi thoáng mát, tránh ánh nắng mặt trời trực tiếp.\n\nĐiều kiện áp dụng đổi sản phẩm (trong vòng 07 ngày kể từ khi nhận sản phẩm):\n- Hàng hoá còn mới, chưa qua sử dụng, còn nguyên tem mác.\n- Hàng hoá bị lỗi hoặc hư hỏng do vận chuyển hoặc do nhà sản xuất.\n\nLưu ý:\n- Do màn hình và điều kiện ánh sáng khác nhau, màu sắc thực tế của sản phẩm có thể chênh lệch khoảng 3-5%.', 'CozyWear', 'Vải Nỉ Bông Mịn', 480000.00, 'ACTIVE', 0, 0, '2025-11-04 18:11:41'),
(216, 419, 'Áo Khoác Nữ Cardigan', 'ao-khoac-nu-cardigan', 'Thông tin sản phẩm Áo Khoác Nữ Cardigan:\n- Hàng thiết kế và sản xuất bởi CozyWear, đảm bảo chất lượng và form dáng.\n- Chất liệu: Vải Len Dệt Kim cao cấp, mềm mại, thoáng mát, giữ form, và thân thiện với da.\n- Đường may tỉ mỉ, tinh tế, không chỉ thừa, đạt tiêu chuẩn xuất khẩu.\n- Phù hợp mặc đi làm, đi chơi, dạo phố hoặc các sự kiện quan trọng.\n- Thiết kế Áo Khoác Nữ Cardigan hiện đại, trẻ trung, dễ dàng phối đồ.\n\nCó đủ các size từ S, M, L, XL, XXL (Vui lòng tham khảo bảng size chi tiết).\n\nHướng dẫn sử dụng sản phẩm:\n- Ưu tiên giặt tay ở nhiệt độ thường để giữ độ bền của Vải Len Dệt Kim.\n- Hạn chế giặt máy. Nếu giặt máy, nên lộn trái sản phẩm và cho vào túi giặt.\n- Không sử dụng thuốc tẩy hoặc ngâm sản phẩm quá lâu.\n- Phơi ở nơi thoáng mát, tránh ánh nắng mặt trời trực tiếp.\n\nĐiều kiện áp dụng đổi sản phẩm (trong vòng 07 ngày kể từ khi nhận sản phẩm):\n- Hàng hoá còn mới, chưa qua sử dụng, còn nguyên tem mác.\n- Hàng hoá bị lỗi hoặc hư hỏng do vận chuyển hoặc do nhà sản xuất.\n\nLưu ý:\n- Do màn hình và điều kiện ánh sáng khác nhau, màu sắc thực tế của sản phẩm có thể chênh lệch khoảng 3-5%.', 'CozyWear', 'Vải Len Dệt Kim', 390000.00, 'ACTIVE', 0, 0, '2025-11-04 18:11:41'),
(217, 420, 'Quần Jean Nữ Ống Loe', 'quan-jean-nu-ong-loe', 'Thông tin sản phẩm Quần Jean Nữ Ống Loe:\n- Hàng thiết kế và sản xuất bởi DivaStyle, đảm bảo chất lượng và form dáng.\n- Chất liệu: Vải Jean Co Giãn cao cấp, tôn dáng, giữ form, và thân thiện với da.\n- Đường may tỉ mỉ, tinh tế, không chỉ thừa, đạt tiêu chuẩn xuất khẩu.\n- Phù hợp mặc đi làm, đi chơi, dạo phố hoặc các sự kiện quan trọng.\n- Thiết kế Quần Jean Nữ Ống Loe hiện đại, trẻ trung, dễ dàng phối đồ.\n\nCó đủ các size từ S, M, L, XL, XXL (Vui lòng tham khảo bảng size chi tiết).\n\nHướng dẫn sử dụng sản phẩm:\n- Ưu tiên giặt tay ở nhiệt độ thường để giữ độ bền của Vải Jean Co Giãn.\n- Hạn chế giặt máy. Nếu giặt máy, nên lộn trái sản phẩm và cho vào túi giặt.\n- Không sử dụng thuốc tẩy hoặc ngâm sản phẩm quá lâu.\n- Phơi ở nơi thoáng mát, tránh ánh nắng mặt trời trực tiếp.\n\nĐiều kiện áp dụng đổi sản phẩm (trong vòng 07 ngày kể từ khi nhận sản phẩm):\n- Hàng hoá còn mới, chưa qua sử dụng, còn nguyên tem mác.\n- Hàng hoá bị lỗi hoặc hư hỏng do vận chuyển hoặc do nhà sản xuất.\n\nLưu ý:\n- Do màn hình và điều kiện ánh sáng khác nhau, màu sắc thực tế của sản phẩm có thể chênh lệch khoảng 3-5%.', 'DivaStyle', 'Vải Jean Co Giãn', 520000.00, 'ACTIVE', 0, 0, '2025-11-04 18:11:41'),
(218, 421, 'Quần Short Nữ Jean', 'quan-short-nu-jean', 'Thông tin sản phẩm Quần Short Nữ Jean:\n- Hàng thiết kế và sản xuất bởi DenimPro, đảm bảo chất lượng và form dáng.\n- Chất liệu: Vải Jean Cotton cao cấp, thoáng mát, giữ form, và thân thiện với da.\n- Đường may tỉ mỉ, tinh tế, không chỉ thừa, đạt tiêu chuẩn xuất khẩu.\n- Phù hợp mặc đi làm, đi chơi, dạo phố hoặc các sự kiện quan trọng.\n- Thiết kế Quần Short Nữ Jean hiện đại, trẻ trung, dễ dàng phối đồ.\n\nCó đủ các size từ S, M, L, XL, XXL (Vui lòng tham khảo bảng size chi tiết).\n\nHướng dẫn sử dụng sản phẩm:\n- Ưu tiên giặt tay ở nhiệt độ thường để giữ độ bền của Vải Jean Cotton.\n- Hạn chế giặt máy. Nếu giặt máy, nên lộn trái sản phẩm và cho vào túi giặt.\n- Không sử dụng thuốc tẩy hoặc ngâm sản phẩm quá lâu.\n- Phơi ở nơi thoáng mát, tránh ánh nắng mặt trời trực tiếp.\n\nĐiều kiện áp dụng đổi sản phẩm (trong vòng 07 ngày kể từ khi nhận sản phẩm):\n- Hàng hoá còn mới, chưa qua sử dụng, còn nguyên tem mác.\n- Hàng hoá bị lỗi hoặc hư hỏng do vận chuyển hoặc do nhà sản xuất.\n\nLưu ý:\n- Do màn hình và điều kiện ánh sáng khác nhau, màu sắc thực tế của sản phẩm có thể chênh lệch khoảng 3-5%.', 'DenimPro', 'Vải Jean Cotton', 280000.00, 'ACTIVE', 0, 0, '2025-11-04 18:11:41'),
(219, 422, 'Quần Ống Rộng Nữ Vải Tuyết', 'quan-ong-rong-nu-vai-tuyet', 'Thông tin sản phẩm Quần Ống Rộng Nữ Vải Tuyết:\n- Hàng thiết kế và sản xuất bởi Elegante, đảm bảo chất lượng và form dáng.\n- Chất liệu: Vải Tuyết Mưa cao cấp, thoáng mát, giữ form, và thân thiện với da.\n- Đường may tỉ mỉ, tinh tế, không chỉ thừa, đạt tiêu chuẩn xuất khẩu.\n- Phù hợp mặc đi làm, đi chơi, dạo phố hoặc các sự kiện quan trọng.\n- Thiết kế Quần Ống Rộng Nữ Vải Tuyết hiện đại, trẻ trung, dễ dàng phối đồ.\n\nCó đủ các size từ S, M, L, XL, XXL (Vui lòng tham khảo bảng size chi tiết).\n\nHướng dẫn sử dụng sản phẩm:\n- Ưu tiên giặt tay ở nhiệt độ thường để giữ độ bền của Vải Tuyết Mưa.\n- Hạn chế giặt máy. Nếu giặt máy, nên lộn trái sản phẩm và cho vào túi giặt.\n- Không sử dụng thuốc tẩy hoặc ngâm sản phẩm quá lâu.\n- Phơi ở nơi thoáng mát, tránh ánh nắng mặt trời trực tiếp.\n\nĐiều kiện áp dụng đổi sản phẩm (trong vòng 07 ngày kể từ khi nhận sản phẩm):\n- Hàng hoá còn mới, chưa qua sử dụng, còn nguyên tem mác.\n- Hàng hoá bị lỗi hoặc hư hỏng do vận chuyển hoặc do nhà sản xuất.\n\nLưu ý:\n- Do màn hình và điều kiện ánh sáng khác nhau, màu sắc thực tế của sản phẩm có thể chênh lệch khoảng 3-5%.', 'Elegante', 'Vải Tuyết Mưa', 330000.00, 'ACTIVE', 0, 0, '2025-11-04 18:11:41'),
(220, 423, 'Chân Váy Chữ A', 'chan-vay-chu-a', 'Thông tin sản phẩm Chân Váy Chữ A:\n- Hàng thiết kế và sản xuất bởi DivaStyle, đảm bảo chất lượng và form dáng.\n- Chất liệu: Vải Kaki Mềm cao cấp, thoáng mát, giữ form, và thân thiện với da.\n- Đường may tỉ mỉ, tinh tế, không chỉ thừa, đạt tiêu chuẩn xuất khẩu.\n- Phù hợp mặc đi làm, đi chơi, dạo phố hoặc các sự kiện quan trọng.\n- Thiết kế Chân Váy Chữ A hiện đại, trẻ trung, dễ dàng phối đồ.\n\nCó đủ các size từ S, M, L, XL, XXL (Vui lòng tham khảo bảng size chi tiết).\n\nHướng dẫn sử dụng sản phẩm:\n- Ưu tiên giặt tay ở nhiệt độ thường để giữ độ bền của Vải Kaki Mềm.\n- Hạn chế giặt máy. Nếu giặt máy, nên lộn trái sản phẩm và cho vào túi giặt.\n- Không sử dụng thuốc tẩy hoặc ngâm sản phẩm quá lâu.\n- Phơi ở nơi thoáng mát, tránh ánh nắng mặt trời trực tiếp.\n\nĐiều kiện áp dụng đổi sản phẩm (trong vòng 07 ngày kể từ khi nhận sản phẩm):\n- Hàng hoá còn mới, chưa qua sử dụng, còn nguyên tem mác.\n- Hàng hoá bị lỗi hoặc hư hỏng do vận chuyển hoặc do nhà sản xuất.\n\nLưu ý:\n- Do màn hình và điều kiện ánh sáng khác nhau, màu sắc thực tế của sản phẩm có thể chênh lệch khoảng 3-5%.', 'DivaStyle', 'Vải Kaki Mềm', 270000.00, 'ACTIVE', 0, 0, '2025-11-04 18:11:41'),
(221, 424, 'Váy Đầm Maxi Voan', 'vay-dam-maxi-voan', 'Thông tin sản phẩm Váy Đầm Maxi Voan:\n- Hàng thiết kế và sản xuất bởi SilkSation, đảm bảo chất lượng và form dáng.\n- Chất liệu: Vải Voan Lụa 2 Lớp cao cấp, bay bổng, thoáng mát, giữ form, và thân thiện với da.\n- Đường may tỉ mỉ, tinh tế, không chỉ thừa, đạt tiêu chuẩn xuất khẩu.\n- Phù hợp mặc đi làm, đi chơi, dạo phố hoặc các sự kiện quan trọng.\n- Thiết kế Váy Đầm Maxi Voan hiện đại, trẻ trung, dễ dàng phối đồ.\n\nCó đủ các size từ S, M, L, XL, XXL (Vui lòng tham khảo bảng size chi tiết).\n\nHướng dẫn sử dụng sản phẩm:\n- Ưu tiên giặt tay ở nhiệt độ thường để giữ độ bền của Vải Voan Lụa 2 Lớp.\n- Hạn chế giặt máy. Nếu giặt máy, nên lộn trái sản phẩm và cho vào túi giặt.\n- Không sử dụng thuốc tẩy hoặc ngâm sản phẩm quá lâu.\n- Phơi ở nơi thoáng mát, tránh ánh nắng mặt trời trực tiếp.\n\nĐiều kiện áp dụng đổi sản phẩm (trong vòng 07 ngày kể từ khi nhận sản phẩm):\n- Hàng hoá còn mới, chưa qua sử dụng, còn nguyên tem mác.\n- Hàng hoá bị lỗi hoặc hư hỏng do vận chuyển hoặc do nhà sản xuất.\n\nLưu ý:\n- Do màn hình và điều kiện ánh sáng khác nhau, màu sắc thực tế của sản phẩm có thể chênh lệch khoảng 3-5%.', 'SilkySation', 'Vải Voan Lụa 2 Lớp', 600000.00, 'ACTIVE', 0, 0, '2025-11-04 18:11:41'),
(222, 425, 'Quần Legging Gym Nữ', 'quan-legging-gym-nu', 'Thông tin sản phẩm Quần Legging Gym Nữ:\n- Hàng thiết kế và sản xuất bởi ActiveWear, đảm bảo chất lượng và form dáng.\n- Chất liệu: Vải Thun Lạnh 4 Chiều cao cấp, co giãn tối đa, thấm hút mồ hôi, và thân thiện với da.\n- Đường may tỉ mỉ, tinh tế, không chỉ thừa, đạt tiêu chuẩn xuất khẩu.\n- Phù hợp mặc đi làm, đi chơi, dạo phố hoặc các sự kiện quan trọng.\n- Thiết kế Quần Legging Gym Nữ hiện đại, trẻ trung, dễ dàng phối đồ.\n\nCó đủ các size từ S, M, L, XL, XXL (Vui lòng tham khảo bảng size chi tiết).\n\nHướng dẫn sử dụng sản phẩm:\n- Ưu tiên giặt tay ở nhiệt độ thường để giữ độ bền của Vải Thun Lạnh 4 Chiều.\n- Hạn chế giặt máy. Nếu giặt máy, nên lộn trái sản phẩm và cho vào túi giặt.\n- Không sử dụng thuốc tẩy hoặc ngâm sản phẩm quá lâu.\n- Phơi ở nơi thoáng mát, tránh ánh nắng mặt trời trực tiếp.\n\nĐiều kiện áp dụng đổi sản phẩm (trong vòng 07 ngày kể từ khi nhận sản phẩm):\n- Hàng hoá còn mới, chưa qua sử dụng, còn nguyên tem mác.\n- Hàng hoá bị lỗi hoặc hư hỏng do vận chuyển hoặc do nhà sản xuất.\n\nLưu ý:\n- Do màn hình và điều kiện ánh sáng khác nhau, màu sắc thực tế của sản phẩm có thể chênh lệch khoảng 3-5%.', 'ActiveWear', 'Vải Thun Lạnh 4 Chiều', 310000.00, 'ACTIVE', 0, 0, '2025-11-04 18:11:41'),
(223, 426, 'Quần Short Chạy Bộ 2 Lớp', 'quan-short-chay-bo-2-lop', 'Thông tin sản phẩm Quần Short Chạy Bộ 2 Lớp:\n- Hàng thiết kế và sản xuất bởi ActiveWear, đảm bảo chất lượng và form dáng.\n- Chất liệu: Vải Dù Lót Lưới cao cấp, siêu nhẹ, thoáng mát, giữ form, và thân thiện với da.\n- Đường may tỉ mỉ, tinh tế, không chỉ thừa, đạt tiêu chuẩn xuất khẩu.\n- Phù hợp mặc đi làm, đi chơi, dạo phố hoặc các sự kiện quan trọng.\n- Thiết kế Quần Short Chạy Bộ 2 Lớp hiện đại, trẻ trung, dễ dàng phối đồ.\n\nCó đủ các size từ S, M, L, XL, XXL (Vui lòng tham khảo bảng size chi tiết).\n\nHướng dẫn sử dụng sản phẩm:\n- Ưu tiên giặt tay ở nhiệt độ thường để giữ độ bền của Vải Dù Lót Lưới.\n- Hạn chế giặt máy. Nếu giặt máy, nên lộn trái sản phẩm và cho vào túi giặt.\n- Không sử dụng thuốc tẩy hoặc ngâm sản phẩm quá lâu.\n- Phơi ở nơi thoáng mát, tránh ánh nắng mặt trời trực tiếp.\n\nĐiều kiện áp dụng đổi sản phẩm (trong vòng 07 ngày kể từ khi nhận sản phẩm):\n- Hàng hoá còn mới, chưa qua sử dụng, còn nguyên tem mác.\n- Hàng hoá bị lỗi hoặc hư hỏng do vận chuyển hoặc do nhà sản xuất.\n\nLưu ý:\n- Do màn hình và điều kiện ánh sáng khác nhau, màu sắc thực tế của sản phẩm có thể chênh lệch khoảng 3-5%.', 'ActiveWear', 'Vải Dù Lót Lưới', 260000.00, 'ACTIVE', 0, 0, '2025-11-04 18:11:41'),
(224, 427, 'Đồ Bơi Nữ Một Mảnh', 'do-boi-nu-mot-manh', 'Thông tin sản phẩm Đồ Bơi Nữ Một Mảnh:\n- Hàng thiết kế và sản xuất bởi AquaFit, đảm bảo chất lượng và form dáng.\n- Chất liệu: Vải Lycra Bơi Lội cao cấp, co giãn, chống UV, và thân thiện với da.\n- Đường may tỉ mỉ, tinh tế, không chỉ thừa, đạt tiêu chuẩn xuất khẩu.\n- Phù hợp mặc đi làm, đi chơi, dạo phố hoặc các sự kiện quan trọng.\n- Thiết kế Đồ Bơi Nữ Một Mảnh hiện đại, trẻ trung, dễ dàng phối đồ.\n\nCó đủ các size từ S, M, L, XL, XXL (Vui lòng tham khảo bảng size chi tiết).\n\nHướng dẫn sử dụng sản phẩm:\n- Ưu tiên giặt tay ở nhiệt độ thường để giữ độ bền của Vải Lycra Bơi Lội.\n- Hạn chế giặt máy. Nếu giặt máy, nên lộn trái sản phẩm và cho vào túi giặt.\n- Không sử dụng thuốc tẩy hoặc ngâm sản phẩm quá lâu.\n- Phơi ở nơi thoáng mát, tránh ánh nắng mặt trời trực tiếp.\n\nĐiều kiện áp dụng đổi sản phẩm (trong vòng 07 ngày kể từ khi nhận sản phẩm):\n- Hàng hoá còn mới, chưa qua sử dụng, còn nguyên tem mác.\n- Hàng hoá bị lỗi hoặc hư hỏng do vận chuyển hoặc do nhà sản xuất.\n\nLưu ý:\n- Do màn hình và điều kiện ánh sáng khác nhau, màu sắc thực tế của sản phẩm có thể chênh lệch khoảng 3-5%.', 'AquaFit', 'Vải Lycra Bơi Lội', 450000.00, 'ACTIVE', 0, 0, '2025-11-04 18:11:41'),
(225, 428, 'Áo Khoác Thể Thao Chống Nắng', 'ao-khoac-the-thao-chong-nang', 'Thông tin sản phẩm Áo Khoác Thể Thao Chống Nắng:\n- Hàng thiết kế và sản xuất bởi ActiveWear, đảm bảo chất lượng và form dáng.\n- Chất liệu: Vải Thun Lạnh (UPF 50+) cao cấp, thoáng mát, chống tia UV, và thân thiện với da.\n- Đường may tỉ mỉ, tinh tế, không chỉ thừa, đạt tiêu chuẩn xuất khẩu.\n- Phù hợp mặc đi làm, đi chơi, dạo phố hoặc các sự kiện quan trọng.\n- Thiết kế Áo Khoác Thể Thao Chống Nắng hiện đại, trẻ trung, dễ dàng phối đồ.\n\nCó đủ các size từ S, M, L, XL, XXL (Vui lòng tham khảo bảng size chi tiết).\n\nHướng dẫn sử dụng sản phẩm:\n- Ưu tiên giặt tay ở nhiệt độ thường để giữ độ bền của Vải Thun Lạnh (UPF 50+).\n- Hạn chế giặt máy. Nếu giặt máy, nên lộn trái sản phẩm và cho vào túi giặt.\n- Không sử dụng thuốc tẩy hoặc ngâm sản phẩm quá lâu.\n- Phơi ở nơi thoáng mát, tránh ánh nắng mặt trời trực tiếp.\n\nĐiều kiện áp dụng đổi sản phẩm (trong vòng 07 ngày kể từ khi nhận sản phẩm):\n- Hàng hoá còn mới, chưa qua sử dụng, còn nguyên tem mác.\n- Hàng hoá bị lỗi hoặc hư hỏng do vận chuyển hoặc do nhà sản xuất.\n\nLưu ý:\n- Do màn hình và điều kiện ánh sáng khác nhau, màu sắc thực tế của sản phẩm có thể chênh lệch khoảng 3-5%.', 'ActiveWear', 'Vải Thun Lạnh (UPF 50+)', 300000.00, 'ACTIVE', 0, 0, '2025-11-04 18:11:41'),
(226, 429, 'Áo Khoác Da Lót Lông', 'ao-khoac-da-lot-long', 'Thông tin sản phẩm Áo Khoác Da Lót Lông:\n- Hàng thiết kế và sản xuất bởi LeatherLux, đảm bảo chất lượng và form dáng.\n- Chất liệu: Da PU Cao Cấp Lót Lông Cừu cao cấp, siêu ấm, giữ form, và thân thiện với da.\n- Đường may tỉ mỉ, tinh tế, không chỉ thừa, đạt tiêu chuẩn xuất khẩu.\n- Phù hợp mặc đi làm, đi chơi, dạo phố hoặc các sự kiện quan trọng.\n- Thiết kế Áo Khoác Da Lót Lông hiện đại, trẻ trung, dễ dàng phối đồ.\n\nCó đủ các size từ S, M, L, XL, XXL (Vui lòng tham khảo bảng size chi tiết).\n\nHướng dẫn sử dụng sản phẩm:\n- Ưu tiên giặt tay ở nhiệt độ thường để giữ độ bền của Da PU Cao Cấp Lót Lông Cừu.\n- Hạn chế giặt máy. Nếu giặt máy, nên lộn trái sản phẩm và cho vào túi giặt.\n- Không sử dụng thuốc tẩy hoặc ngâm sản phẩm quá lâu.\n- Phơi ở nơi thoáng mát, tránh ánh nắng mặt trời trực tiếp.\n\nĐiều kiện áp dụng đổi sản phẩm (trong vòng 07 ngày kể từ khi nhận sản phẩm):\n- Hàng hoá còn mới, chưa qua sử dụng, còn nguyên tem mác.\n- Hàng hoá bị lỗi hoặc hư hỏng do vận chuyển hoặc do nhà sản xuất.\n\nLưu ý:\n- Do màn hình và điều kiện ánh sáng khác nhau, màu sắc thực tế của sản phẩm có thể chênh lệch khoảng 3-5%.', 'LeatherLux', 'Da PU Cao Cấp Lót Lông Cừu', 1500000.00, 'ACTIVE', 0, 0, '2025-11-04 18:11:41'),
(227, 430, 'Ví Da Bò Thật', 'vi-da-bo-that', 'Thông tin sản phẩm Ví Da Bò Thật:\n- Hàng thiết kế cao cấp bởi LeatherLux.\n- Chất liệu: Da Bò Thật 100% siêu bền, chống mài mòn và chịu lực tốt.\n- Đường may/khóa kéo/mối nối tỉ mỉ, tinh tế, không chi tiết thừa.\n- Thiết kế đa dụng, vừa thời trang vừa tiện lợi, phù hợp cho mọi hoàn cảnh.\n\nHướng dẫn bảo quản sản phẩm:\n- Để sản phẩm ở nơi khô ráo, thoáng mát.\n- Không để sản phẩm tiếp xúc trực tiếp với hóa chất, xà phòng.\n- Vệ sinh sản phẩm bằng khăn ẩm, lau nhẹ nhàng.\n- Tránh phơi trực tiếp dưới ánh nắng mặt trời gắt.\n\nĐiều kiện áp dụng đổi sản phẩm (trong vòng 07 ngày kể từ khi nhận sản phẩm):\n- Hàng hoá còn mới, chưa qua sử dụng, còn nguyên tem mác.\n- Hàng hoá bị lỗi hoặc hư hỏng do vận chuyển hoặc do nhà sản xuất.\n\nLưu ý:\n- Do màn hình và điều kiện ánh sáng khác nhau, màu sắc thực tế của sản phẩm có thể chênh lệch khoảng 3-5%.', 'LeatherLux', 'Da Bò Thật 100%', 500000.00, 'ACTIVE', 0, 0, '2025-11-04 18:11:41'),
(228, 431, 'Giày Da Nam Công Sở', 'giay-da-nam-cong-so', 'Thông tin sản phẩm Giày Da Nam Công Sở:\n- Hàng thiết kế cao cấp bởi Elegante.\n- Chất liệu: Da Bò Nhập Khẩu siêu bền, chống mài mòn và chịu lực tốt.\n- Đường may/khóa kéo/mối nối tỉ mỉ, tinh tế, không chi tiết thừa.\n- Thiết kế đa dụng, vừa thời trang vừa tiện lợi, phù hợp cho mọi hoàn cảnh.\n\nHướng dẫn bảo quản sản phẩm:\n- Để sản phẩm ở nơi khô ráo, thoáng mát.\n- Không để sản phẩm tiếp xúc trực tiếp với hóa chất, xà phòng.\n- Vệ sinh sản phẩm bằng khăn ẩm, lau nhẹ nhàng.\n- Tránh phơi trực tiếp dưới ánh nắng mặt trời gắt.\n\nĐiều kiện áp dụng đổi sản phẩm (trong vòng 07 ngày kể từ khi nhận sản phẩm):\n- Hàng hoá còn mới, chưa qua sử dụng, còn nguyên tem mác.\n- Hàng hoá bị lỗi hoặc hư hỏng do vận chuyển hoặc do nhà sản xuất.\n\nLưu ý:\n- Do màn hình và điều kiện ánh sáng khác nhau, màu sắc thực tế của sản phẩm có thể chênh lệch khoảng 3-5%.', 'Elegante', 'Da Bò Nhập Khẩu', 1300000.00, 'ACTIVE', 0, 0, '2025-11-04 18:11:41'),
(229, 432, 'Mũ Lưỡi Trai (Nón Kết)', 'mu-luoi-trai-non-ket', 'Thông tin sản phẩm Mũ Lưỡi Trai (Nón Kết):\n- Hàng thiết kế cao cấp bởi UrbanFlex.\n- Chất liệu: Vải Kaki Cotton siêu bền, chống mài mòn và chịu lực tốt.\n- Đường may/khóa kéo/mối nối tỉ mỉ, tinh tế, không chi tiết thừa.\n- Thiết kế đa dụng, vừa thời trang vừa tiện lợi, phù hợp cho mọi hoàn cảnh.\n\nHướng dẫn bảo quản sản phẩm:\n- Để sản phẩm ở nơi khô ráo, thoáng mát.\n- Không để sản phẩm tiếp xúc trực tiếp với hóa chất, xà phòng.\n- Vệ sinh sản phẩm bằng khăn ẩm, lau nhẹ nhàng.\n- Tránh phơi trực tiếp dưới ánh nắng mặt trời gắt.\n\nĐiều kiện áp dụng đổi sản phẩm (trong vòng 07 ngày kể từ khi nhận sản phẩm):\n- Hàng hoá còn mới, chưa qua sử dụng, còn nguyên tem mác.\n- Hàng hoá bị lỗi hoặc hư hỏng do vận chuyển hoặc do nhà sản xuất.\n\nLưu ý:\n- Do màn hình và điều kiện ánh sáng khác nhau, màu sắc thực tế của sản phẩm có thể chênh lệch khoảng 3-5%.', 'UrbanFlex', 'Vải Kaki Cotton', 150000.00, 'ACTIVE', 0, 0, '2025-11-04 18:11:41'),
(230, 433, 'Balo Laptop Chống Nước', 'balo-laptop-chong-nuoc', 'Thông tin sản phẩm Balo Laptop Chống Nước:\n- Hàng thiết kế cao cấp bởi PackSafe.\n- Chất liệu: Vải Oxford Chống Thấm siêu bền, chống mài mòn và chịu lực tốt.\n- Đường may/khóa kéo/mối nối tỉ mỉ, tinh tế, không chi tiết thừa.\n- Thiết kế đa dụng, vừa thời trang vừa tiện lợi, phù hợp cho mọi hoàn cảnh.\n\nHướng dẫn bảo quản sản phẩm:\n- Để sản phẩm ở nơi khô ráo, thoáng mát.\n- Không để sản phẩm tiếp xúc trực tiếp với hóa chất, xà phòng.\n- Vệ sinh sản phẩm bằng khăn ẩm, lau nhẹ nhàng.\n- Tránh phơi trực tiếp dưới ánh nắng mặt trời gắt.\n\nĐiều kiện áp dụng đổi sản phẩm (trong vòng 07 ngày kể từ khi nhận sản phẩm):\n- Hàng hoá còn mới, chưa qua sử dụng, còn nguyên tem mác.\n- Hàng hoá bị lỗi hoặc hư hỏng do vận chuyển hoặc do nhà sản xuất.\n\nLưu ý:\n- Do màn hình và điều kiện ánh sáng khác nhau, màu sắc thực tế của sản phẩm có thể chênh lệch khoảng 3-5%.', 'PackSafe', 'Vải Oxford Chống Thấm', 700000.00, 'ACTIVE', 0, 0, '2025-11-04 18:11:41'),
(231, 434, 'Kính Mát Gọng Tròn', 'kinh-mat-gong-tron', 'Thông tin sản phẩm Kính Mát Gọng Tròn:\n- Hàng thiết kế cao cấp bởi SunShade.\n- Chất liệu: Gọng Hợp Kim & Tròng Kính Polarized siêu bền, chống UV400, và chịu lực tốt.\n- Đường may/khóa kéo/mối nối tỉ mỉ, tinh tế, không chi tiết thừa.\n- Thiết kế đa dụng, vừa thời trang vừa tiện lợi, phù hợp cho mọi hoàn cảnh.\n\nHướng dẫn bảo quản sản phẩm:\n- Để sản phẩm ở nơi khô ráo, thoáng mát.\n- Không để sản phẩm tiếp xúc trực tiếp với hóa chất, xà phòng.\n- Vệ sinh sản phẩm bằng khăn ẩm, lau nhẹ nhàng.\n- Tránh phơi trực tiếp dưới ánh nắng mặt trời gắt.\n\nĐiều kiện áp dụng đổi sản phẩm (trong vòng 07 ngày kể từ khi nhận sản phẩm):\n- Hàng hoá còn mới, chưa qua sử dụng, còn nguyên tem mác.\n- Hàng hoá bị lỗi hoặc hư hỏng do vận chuyển hoặc do nhà sản xuất.\n\nLưu ý:\n- Do màn hình và điều kiện ánh sáng khác nhau, màu sắc thực tế của sản phẩm có thể chênh lệch khoảng 3-5%.', 'SunShade', 'Gọng Hợp Kim & Tròng Kính Polarized', 350000.00, 'ACTIVE', 0, 0, '2025-11-04 18:11:41'),
(232, 435, 'Tất Cổ Cao (Vớ)', 'tat-co-cao-vo', 'Thông tin sản phẩm Tất Cổ Cao (Vớ):\n- Hàng thiết kế cao cấp bởi CozyWear.\n- Chất liệu: Cotton 100% siêu bền, thoáng khí, khử mùi và chịu lực tốt.\n- Đường may/khóa kéo/mối nối tỉ mỉ, tinh tế, không chi tiết thừa.\n- Thiết kế đa dụng, vừa thời trang vừa tiện lợi, phù hợp cho mọi hoàn cảnh.\n\nHướng dẫn bảo quản sản phẩm:\n- Để sản phẩm ở nơi khô ráo, thoáng mát.\n- Không để sản phẩm tiếp xúc trực tiếp với hóa chất, xà phòng.\n- Vệ sinh sản phẩm bằng khăn ẩm, lau nhẹ nhàng.\n- Tránh phơi trực tiếp dưới ánh nắng mặt trời gắt.\n\nĐiều kiện áp dụng đổi sản phẩm (trong vòng 07 ngày kể từ khi nhận sản phẩm):\n- Hàng hoá còn mới, chưa qua sử dụng, còn nguyên tem mác.\n- Hàng hoá bị lỗi hoặc hư hỏng do vận chuyển hoặc do nhà sản xuất.\n\nLưu ý:\n- Do màn hình và điều kiện ánh sáng khác nhau, màu sắc thực tế của sản phẩm có thể chênh lệch khoảng 3-5%.', 'CozyWear', 'Cotton 100%', 50000.00, 'ACTIVE', 0, 0, '2025-11-04 18:11:41'),
(233, 436, 'Thắt Lưng Da Nam', 'that-lung-da-nam', 'Thông tin sản phẩm Thắt Lưng Da Nam:\n- Hàng thiết kế cao cấp bởi GentleWear.\n- Chất liệu: Da Bò Cao Cấp siêu bền, chống mài mòn và chịu lực tốt.\n- Đường may/khóa kéo/mối nối tỉ mỉ, tinh tế, không chi tiết thừa.\n- Thiết kế đa dụng, vừa thời trang vừa tiện lợi, phù hợp cho mọi hoàn cảnh.\n\nHướng dẫn bảo quản sản phẩm:\n- Để sản phẩm ở nơi khô ráo, thoáng mát.\n- Không để sản phẩm tiếp xúc trực tiếp với hóa chất, xà phòng.\n- Vệ sinh sản phẩm bằng khăn ẩm, lau nhẹ nhàng.\n- Tránh phơi trực tiếp dưới ánh nắng mặt trời gắt.\n\nĐiều kiện áp dụng đổi sản phẩm (trong vòng 07 ngày kể từ khi nhận sản phẩm):\n- Hàng hoá còn mới, chưa qua sử dụng, còn nguyên tem mác.\n- Hàng hoá bị lỗi hoặc hư hỏng do vận chuyển hoặc do nhà sản xuất.\n\nLưu ý:\n- Do màn hình và điều kiện ánh sáng khác nhau, màu sắc thực tế của sản phẩm có thể chênh lệch khoảng 3-5%.', 'GentleWear', 'Da Bò Cao Cấp', 400000.00, 'ACTIVE', 0, 0, '2025-11-04 18:11:41');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `sizechart`
--

CREATE TABLE `sizechart` (
  `SizeChartID` int(11) NOT NULL,
  `DanhMucID` int(11) DEFAULT NULL,
  `MoTa` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `tags`
--

CREATE TABLE `tags` (
  `TagID` int(11) NOT NULL,
  `TenTag` varchar(50) NOT NULL,
  `Slug` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `thanhtoan`
--

CREATE TABLE `thanhtoan` (
  `ThanhToanID` int(11) NOT NULL,
  `DonHangID` int(11) NOT NULL,
  `MethodID` int(11) NOT NULL,
  `SoTienThanhToan` decimal(10,2) NOT NULL CHECK (`SoTienThanhToan` >= 0),
  `NgayThanhToan` datetime DEFAULT current_timestamp(),
  `TrangThai` enum('PENDING','SUCCESS','FAILED') NOT NULL,
  `MaGiaoDich` varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Đang đổ dữ liệu cho bảng `thanhtoan`
--

INSERT INTO `thanhtoan` (`ThanhToanID`, `DonHangID`, `MethodID`, `SoTienThanhToan`, `NgayThanhToan`, `TrangThai`, `MaGiaoDich`) VALUES
(2, 1002, 701, 99000.00, '2025-11-02 20:13:11', '', NULL),
(3, 1003, 701, 498000.00, '2025-11-02 23:39:57', '', NULL),
(4, 1004, 701, 99000.00, '2025-11-03 00:50:41', '', NULL),
(5, 1005, 701, 399000.00, '2025-11-03 02:24:47', '', NULL),
(6, 1006, 701, 149000.00, '2025-11-03 17:14:26', 'PENDING', NULL),
(7, 1007, 701, 399000.00, '2025-11-03 18:08:23', '', NULL),
(8, 1008, 701, 327000.00, '2025-11-03 20:34:01', 'PENDING', NULL),
(9, 1009, 702, 300000.00, '2025-11-05 15:44:19', 'PENDING', NULL),
(10, 1010, 701, 399000.00, '2025-11-06 00:53:41', 'PENDING', NULL);

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `thuoctinh`
--

CREATE TABLE `thuoctinh` (
  `ThuocTinhID` int(11) NOT NULL,
  `TenThuocTinh` varchar(50) NOT NULL,
  `Slug` varchar(200) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Đang đổ dữ liệu cho bảng `thuoctinh`
--

INSERT INTO `thuoctinh` (`ThuocTinhID`, `TenThuocTinh`, `Slug`) VALUES
(301, 'Kích Cỡ', 'kich-co'),
(302, 'Màu Sắc', 'mau-sac'),
(303, 'Kích Cỡ Giày', 'kich-co-giay'),
(304, 'Kích Cỡ Thắt Lưng', 'kich-co-that-lung'),
(305, 'Kích Cỡ Chung', 'kich-co-chung');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `vanchuyen`
--

CREATE TABLE `vanchuyen` (
  `VanChuyenID` int(11) NOT NULL,
  `DonHangID` int(11) NOT NULL,
  `TenDonViVC` varchar(100) DEFAULT NULL,
  `MaTheoDoi` varchar(100) DEFAULT NULL,
  `NgayGiaoDuKien` date DEFAULT NULL,
  `TrangThaiVC` enum('CHUA_GUI','DA_LAY_HANG','DANG_GIAO','GIAO_THANH_CONG','HOAN_HANG') NOT NULL DEFAULT 'CHUA_GUI'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `yeuthich`
--

CREATE TABLE `yeuthich` (
  `NguoiDungID` int(11) NOT NULL,
  `PhienBanID` int(11) NOT NULL,
  `NgayThem` datetime DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Đang đổ dữ liệu cho bảng `yeuthich`
--

INSERT INTO `yeuthich` (`NguoiDungID`, `PhienBanID`, `NgayThem`) VALUES
(6, 5001, '2025-11-01 15:40:00'),
(7, 5026, '2025-11-06 00:50:11');

--
-- Chỉ mục cho các bảng đã đổ
--

--
-- Chỉ mục cho bảng `chitietdonhang`
--
ALTER TABLE `chitietdonhang`
  ADD PRIMARY KEY (`ChiTietID`),
  ADD KEY `DonHangID` (`DonHangID`),
  ADD KEY `PhienBanID` (`PhienBanID`);

--
-- Chỉ mục cho bảng `chitietgiohang`
--
ALTER TABLE `chitietgiohang`
  ADD PRIMARY KEY (`GioHangID`,`PhienBanID`),
  ADD KEY `PhienBanID` (`PhienBanID`);

--
-- Chỉ mục cho bảng `chitietphienban`
--
ALTER TABLE `chitietphienban`
  ADD PRIMARY KEY (`PhienBanID`,`GiaTriID`),
  ADD KEY `GiaTriID` (`GiaTriID`);

--
-- Chỉ mục cho bảng `chitietreturns`
--
ALTER TABLE `chitietreturns`
  ADD PRIMARY KEY (`ReturnID`,`PhienBanID`),
  ADD KEY `PhienBanID` (`PhienBanID`);

--
-- Chỉ mục cho bảng `danhgia`
--
ALTER TABLE `danhgia`
  ADD PRIMARY KEY (`DanhGiaID`),
  ADD KEY `NguoiDungID` (`NguoiDungID`),
  ADD KEY `idx_danhgia_phienban` (`PhienBanID`);

--
-- Chỉ mục cho bảng `danhmuc`
--
ALTER TABLE `danhmuc`
  ADD PRIMARY KEY (`DanhMucID`),
  ADD UNIQUE KEY `TenDanhMuc` (`TenDanhMuc`),
  ADD UNIQUE KEY `Slug` (`Slug`),
  ADD KEY `DanhMucChaID` (`DanhMucChaID`),
  ADD KEY `idx_danhmuc_slug` (`Slug`);

--
-- Chỉ mục cho bảng `diachigiaohang`
--
ALTER TABLE `diachigiaohang`
  ADD PRIMARY KEY (`DiaChiID`),
  ADD KEY `NguoiDungID` (`NguoiDungID`);

--
-- Chỉ mục cho bảng `donhang`
--
ALTER TABLE `donhang`
  ADD PRIMARY KEY (`DonHangID`),
  ADD KEY `DiaChiGiaoHangID` (`DiaChiGiaoHangID`),
  ADD KEY `MaKhuyenMai` (`MaKhuyenMai`),
  ADD KEY `PhuongThucID` (`PhuongThucID`),
  ADD KEY `idx_donhang_trangthai` (`TrangThai`),
  ADD KEY `idx_donhang_nguoidung` (`NguoiDungID`);

--
-- Chỉ mục cho bảng `giatrithuoctinh`
--
ALTER TABLE `giatrithuoctinh`
  ADD PRIMARY KEY (`GiaTriID`),
  ADD UNIQUE KEY `ThuocTinhID` (`ThuocTinhID`,`GiaTri`);

--
-- Chỉ mục cho bảng `giohang`
--
ALTER TABLE `giohang`
  ADD PRIMARY KEY (`NguoiDungID`);

--
-- Chỉ mục cho bảng `hinhanhsanpham`
--
ALTER TABLE `hinhanhsanpham`
  ADD PRIMARY KEY (`HinhAnhID`),
  ADD KEY `SanPhamID` (`SanPhamID`),
  ADD KEY `fk_hinhanh_phienban` (`PhienBanID`);

--
-- Chỉ mục cho bảng `khuyenmai`
--
ALTER TABLE `khuyenmai`
  ADD PRIMARY KEY (`MaKhuyenMai`),
  ADD KEY `DanhMucID` (`DanhMucID`),
  ADD KEY `SanPhamID` (`SanPhamID`);

--
-- Chỉ mục cho bảng `lichsudonhang`
--
ALTER TABLE `lichsudonhang`
  ADD PRIMARY KEY (`LichSuID`),
  ADD KEY `DonHangID` (`DonHangID`);

--
-- Chỉ mục cho bảng `nguoidung`
--
ALTER TABLE `nguoidung`
  ADD PRIMARY KEY (`NguoiDungID`),
  ADD UNIQUE KEY `Email` (`Email`),
  ADD UNIQUE KEY `GoogleID` (`GoogleID`),
  ADD KEY `idx_email` (`Email`),
  ADD KEY `idx_google_id` (`GoogleID`);

--
-- Chỉ mục cho bảng `nguoidung_voucher`
--
ALTER TABLE `nguoidung_voucher`
  ADD PRIMARY KEY (`NguoiDungID`,`MaKhuyenMai`),
  ADD KEY `MaKhuyenMai` (`MaKhuyenMai`);

--
-- Chỉ mục cho bảng `paymentmethods`
--
ALTER TABLE `paymentmethods`
  ADD PRIMARY KEY (`MethodID`),
  ADD UNIQUE KEY `TenPhuongThuc` (`TenPhuongThuc`);

--
-- Chỉ mục cho bảng `phienbansanpham`
--
ALTER TABLE `phienbansanpham`
  ADD PRIMARY KEY (`PhienBanID`),
  ADD UNIQUE KEY `SKU` (`SKU`),
  ADD KEY `idx_phienban_sanpham` (`SanPhamID`);

--
-- Chỉ mục cho bảng `phiendangnhap`
--
ALTER TABLE `phiendangnhap`
  ADD PRIMARY KEY (`PhienID`),
  ADD KEY `NguoiDungID` (`NguoiDungID`);

--
-- Chỉ mục cho bảng `phuongthucvanchuyen`
--
ALTER TABLE `phuongthucvanchuyen`
  ADD PRIMARY KEY (`PhuongThucID`),
  ADD UNIQUE KEY `TenPhuongThuc` (`TenPhuongThuc`);

--
-- Chỉ mục cho bảng `producttags`
--
ALTER TABLE `producttags`
  ADD PRIMARY KEY (`SanPhamID`,`TagID`),
  ADD KEY `TagID` (`TagID`);

--
-- Chỉ mục cho bảng `returns`
--
ALTER TABLE `returns`
  ADD PRIMARY KEY (`ReturnID`),
  ADD KEY `DonHangID` (`DonHangID`);

--
-- Chỉ mục cho bảng `sanpham`
--
ALTER TABLE `sanpham`
  ADD PRIMARY KEY (`SanPhamID`),
  ADD UNIQUE KEY `Slug` (`Slug`),
  ADD KEY `idx_sanpham_slug` (`Slug`),
  ADD KEY `idx_sanpham_danhmuc` (`DanhMucID`);

--
-- Chỉ mục cho bảng `sizechart`
--
ALTER TABLE `sizechart`
  ADD PRIMARY KEY (`SizeChartID`),
  ADD KEY `DanhMucID` (`DanhMucID`);

--
-- Chỉ mục cho bảng `tags`
--
ALTER TABLE `tags`
  ADD PRIMARY KEY (`TagID`),
  ADD UNIQUE KEY `TenTag` (`TenTag`),
  ADD UNIQUE KEY `Slug` (`Slug`);

--
-- Chỉ mục cho bảng `thanhtoan`
--
ALTER TABLE `thanhtoan`
  ADD PRIMARY KEY (`ThanhToanID`),
  ADD UNIQUE KEY `DonHangID` (`DonHangID`),
  ADD KEY `MethodID` (`MethodID`);

--
-- Chỉ mục cho bảng `thuoctinh`
--
ALTER TABLE `thuoctinh`
  ADD PRIMARY KEY (`ThuocTinhID`),
  ADD UNIQUE KEY `TenThuocTinh` (`TenThuocTinh`);

--
-- Chỉ mục cho bảng `vanchuyen`
--
ALTER TABLE `vanchuyen`
  ADD PRIMARY KEY (`VanChuyenID`),
  ADD UNIQUE KEY `DonHangID` (`DonHangID`);

--
-- Chỉ mục cho bảng `yeuthich`
--
ALTER TABLE `yeuthich`
  ADD PRIMARY KEY (`NguoiDungID`,`PhienBanID`),
  ADD KEY `PhienBanID` (`PhienBanID`);

--
-- AUTO_INCREMENT cho các bảng đã đổ
--

--
-- AUTO_INCREMENT cho bảng `chitietdonhang`
--
ALTER TABLE `chitietdonhang`
  MODIFY `ChiTietID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- AUTO_INCREMENT cho bảng `danhgia`
--
ALTER TABLE `danhgia`
  MODIFY `DanhGiaID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT cho bảng `danhmuc`
--
ALTER TABLE `danhmuc`
  MODIFY `DanhMucID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=439;

--
-- AUTO_INCREMENT cho bảng `diachigiaohang`
--
ALTER TABLE `diachigiaohang`
  MODIFY `DiaChiID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=111;

--
-- AUTO_INCREMENT cho bảng `donhang`
--
ALTER TABLE `donhang`
  MODIFY `DonHangID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=1011;

--
-- AUTO_INCREMENT cho bảng `giatrithuoctinh`
--
ALTER TABLE `giatrithuoctinh`
  MODIFY `GiaTriID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3023;

--
-- AUTO_INCREMENT cho bảng `hinhanhsanpham`
--
ALTER TABLE `hinhanhsanpham`
  MODIFY `HinhAnhID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=159;

--
-- AUTO_INCREMENT cho bảng `lichsudonhang`
--
ALTER TABLE `lichsudonhang`
  MODIFY `LichSuID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=15;

--
-- AUTO_INCREMENT cho bảng `nguoidung`
--
ALTER TABLE `nguoidung`
  MODIFY `NguoiDungID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT cho bảng `paymentmethods`
--
ALTER TABLE `paymentmethods`
  MODIFY `MethodID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=705;

--
-- AUTO_INCREMENT cho bảng `phienbansanpham`
--
ALTER TABLE `phienbansanpham`
  MODIFY `PhienBanID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5035;

--
-- AUTO_INCREMENT cho bảng `phiendangnhap`
--
ALTER TABLE `phiendangnhap`
  MODIFY `PhienID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=33;

--
-- AUTO_INCREMENT cho bảng `phuongthucvanchuyen`
--
ALTER TABLE `phuongthucvanchuyen`
  MODIFY `PhuongThucID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=603;

--
-- AUTO_INCREMENT cho bảng `returns`
--
ALTER TABLE `returns`
  MODIFY `ReturnID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT cho bảng `sanpham`
--
ALTER TABLE `sanpham`
  MODIFY `SanPhamID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=234;

--
-- AUTO_INCREMENT cho bảng `sizechart`
--
ALTER TABLE `sizechart`
  MODIFY `SizeChartID` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT cho bảng `tags`
--
ALTER TABLE `tags`
  MODIFY `TagID` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT cho bảng `thanhtoan`
--
ALTER TABLE `thanhtoan`
  MODIFY `ThanhToanID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT cho bảng `thuoctinh`
--
ALTER TABLE `thuoctinh`
  MODIFY `ThuocTinhID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=306;

--
-- AUTO_INCREMENT cho bảng `vanchuyen`
--
ALTER TABLE `vanchuyen`
  MODIFY `VanChuyenID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- Các ràng buộc cho các bảng đã đổ
--

--
-- Các ràng buộc cho bảng `chitietdonhang`
--
ALTER TABLE `chitietdonhang`
  ADD CONSTRAINT `chitietdonhang_ibfk_1` FOREIGN KEY (`DonHangID`) REFERENCES `donhang` (`DonHangID`) ON DELETE CASCADE,
  ADD CONSTRAINT `chitietdonhang_ibfk_2` FOREIGN KEY (`PhienBanID`) REFERENCES `phienbansanpham` (`PhienBanID`);

--
-- Các ràng buộc cho bảng `chitietgiohang`
--
ALTER TABLE `chitietgiohang`
  ADD CONSTRAINT `chitietgiohang_ibfk_1` FOREIGN KEY (`GioHangID`) REFERENCES `giohang` (`NguoiDungID`) ON DELETE CASCADE,
  ADD CONSTRAINT `chitietgiohang_ibfk_2` FOREIGN KEY (`PhienBanID`) REFERENCES `phienbansanpham` (`PhienBanID`) ON DELETE CASCADE;

--
-- Các ràng buộc cho bảng `chitietphienban`
--
ALTER TABLE `chitietphienban`
  ADD CONSTRAINT `chitietphienban_ibfk_1` FOREIGN KEY (`PhienBanID`) REFERENCES `phienbansanpham` (`PhienBanID`) ON DELETE CASCADE,
  ADD CONSTRAINT `chitietphienban_ibfk_2` FOREIGN KEY (`GiaTriID`) REFERENCES `giatrithuoctinh` (`GiaTriID`) ON DELETE CASCADE;

--
-- Các ràng buộc cho bảng `chitietreturns`
--
ALTER TABLE `chitietreturns`
  ADD CONSTRAINT `chitietreturns_ibfk_1` FOREIGN KEY (`ReturnID`) REFERENCES `returns` (`ReturnID`) ON DELETE CASCADE,
  ADD CONSTRAINT `chitietreturns_ibfk_2` FOREIGN KEY (`PhienBanID`) REFERENCES `phienbansanpham` (`PhienBanID`);

--
-- Các ràng buộc cho bảng `danhgia`
--
ALTER TABLE `danhgia`
  ADD CONSTRAINT `danhgia_ibfk_1` FOREIGN KEY (`PhienBanID`) REFERENCES `phienbansanpham` (`PhienBanID`),
  ADD CONSTRAINT `danhgia_ibfk_2` FOREIGN KEY (`NguoiDungID`) REFERENCES `nguoidung` (`NguoiDungID`);

--
-- Các ràng buộc cho bảng `danhmuc`
--
ALTER TABLE `danhmuc`
  ADD CONSTRAINT `danhmuc_ibfk_1` FOREIGN KEY (`DanhMucChaID`) REFERENCES `danhmuc` (`DanhMucID`) ON DELETE SET NULL;

--
-- Các ràng buộc cho bảng `diachigiaohang`
--
ALTER TABLE `diachigiaohang`
  ADD CONSTRAINT `diachigiaohang_ibfk_1` FOREIGN KEY (`NguoiDungID`) REFERENCES `nguoidung` (`NguoiDungID`) ON DELETE CASCADE;

--
-- Các ràng buộc cho bảng `donhang`
--
ALTER TABLE `donhang`
  ADD CONSTRAINT `donhang_ibfk_1` FOREIGN KEY (`NguoiDungID`) REFERENCES `nguoidung` (`NguoiDungID`),
  ADD CONSTRAINT `donhang_ibfk_2` FOREIGN KEY (`DiaChiGiaoHangID`) REFERENCES `diachigiaohang` (`DiaChiID`),
  ADD CONSTRAINT `donhang_ibfk_3` FOREIGN KEY (`MaKhuyenMai`) REFERENCES `khuyenmai` (`MaKhuyenMai`),
  ADD CONSTRAINT `donhang_ibfk_4` FOREIGN KEY (`PhuongThucID`) REFERENCES `phuongthucvanchuyen` (`PhuongThucID`);

--
-- Các ràng buộc cho bảng `giatrithuoctinh`
--
ALTER TABLE `giatrithuoctinh`
  ADD CONSTRAINT `giatrithuoctinh_ibfk_1` FOREIGN KEY (`ThuocTinhID`) REFERENCES `thuoctinh` (`ThuocTinhID`);

--
-- Các ràng buộc cho bảng `giohang`
--
ALTER TABLE `giohang`
  ADD CONSTRAINT `giohang_ibfk_1` FOREIGN KEY (`NguoiDungID`) REFERENCES `nguoidung` (`NguoiDungID`) ON DELETE CASCADE;

--
-- Các ràng buộc cho bảng `hinhanhsanpham`
--
ALTER TABLE `hinhanhsanpham`
  ADD CONSTRAINT `fk_hinhanh_phienban` FOREIGN KEY (`PhienBanID`) REFERENCES `phienbansanpham` (`PhienBanID`) ON DELETE CASCADE,
  ADD CONSTRAINT `hinhanhsanpham_ibfk_1` FOREIGN KEY (`SanPhamID`) REFERENCES `sanpham` (`SanPhamID`) ON DELETE CASCADE;

--
-- Các ràng buộc cho bảng `khuyenmai`
--
ALTER TABLE `khuyenmai`
  ADD CONSTRAINT `khuyenmai_ibfk_1` FOREIGN KEY (`DanhMucID`) REFERENCES `danhmuc` (`DanhMucID`) ON DELETE SET NULL,
  ADD CONSTRAINT `khuyenmai_ibfk_2` FOREIGN KEY (`SanPhamID`) REFERENCES `sanpham` (`SanPhamID`) ON DELETE SET NULL;

--
-- Các ràng buộc cho bảng `lichsudonhang`
--
ALTER TABLE `lichsudonhang`
  ADD CONSTRAINT `lichsudonhang_ibfk_1` FOREIGN KEY (`DonHangID`) REFERENCES `donhang` (`DonHangID`) ON DELETE CASCADE;

--
-- Các ràng buộc cho bảng `nguoidung_voucher`
--
ALTER TABLE `nguoidung_voucher`
  ADD CONSTRAINT `nguoidung_voucher_ibfk_1` FOREIGN KEY (`NguoiDungID`) REFERENCES `nguoidung` (`NguoiDungID`) ON DELETE CASCADE,
  ADD CONSTRAINT `nguoidung_voucher_ibfk_2` FOREIGN KEY (`MaKhuyenMai`) REFERENCES `khuyenmai` (`MaKhuyenMai`) ON DELETE CASCADE;

--
-- Các ràng buộc cho bảng `phienbansanpham`
--
ALTER TABLE `phienbansanpham`
  ADD CONSTRAINT `phienbansanpham_ibfk_1` FOREIGN KEY (`SanPhamID`) REFERENCES `sanpham` (`SanPhamID`) ON DELETE CASCADE;

--
-- Các ràng buộc cho bảng `phiendangnhap`
--
ALTER TABLE `phiendangnhap`
  ADD CONSTRAINT `phiendangnhap_ibfk_1` FOREIGN KEY (`NguoiDungID`) REFERENCES `nguoidung` (`NguoiDungID`) ON DELETE CASCADE;

--
-- Các ràng buộc cho bảng `producttags`
--
ALTER TABLE `producttags`
  ADD CONSTRAINT `producttags_ibfk_1` FOREIGN KEY (`SanPhamID`) REFERENCES `sanpham` (`SanPhamID`) ON DELETE CASCADE,
  ADD CONSTRAINT `producttags_ibfk_2` FOREIGN KEY (`TagID`) REFERENCES `tags` (`TagID`) ON DELETE CASCADE;

--
-- Các ràng buộc cho bảng `returns`
--
ALTER TABLE `returns`
  ADD CONSTRAINT `returns_ibfk_1` FOREIGN KEY (`DonHangID`) REFERENCES `donhang` (`DonHangID`) ON DELETE CASCADE;

--
-- Các ràng buộc cho bảng `sanpham`
--
ALTER TABLE `sanpham`
  ADD CONSTRAINT `sanpham_ibfk_1` FOREIGN KEY (`DanhMucID`) REFERENCES `danhmuc` (`DanhMucID`) ON DELETE SET NULL;

--
-- Các ràng buộc cho bảng `sizechart`
--
ALTER TABLE `sizechart`
  ADD CONSTRAINT `sizechart_ibfk_1` FOREIGN KEY (`DanhMucID`) REFERENCES `danhmuc` (`DanhMucID`) ON DELETE CASCADE;

--
-- Các ràng buộc cho bảng `thanhtoan`
--
ALTER TABLE `thanhtoan`
  ADD CONSTRAINT `thanhtoan_ibfk_1` FOREIGN KEY (`DonHangID`) REFERENCES `donhang` (`DonHangID`) ON DELETE CASCADE,
  ADD CONSTRAINT `thanhtoan_ibfk_2` FOREIGN KEY (`MethodID`) REFERENCES `paymentmethods` (`MethodID`);

--
-- Các ràng buộc cho bảng `vanchuyen`
--
ALTER TABLE `vanchuyen`
  ADD CONSTRAINT `vanchuyen_ibfk_1` FOREIGN KEY (`DonHangID`) REFERENCES `donhang` (`DonHangID`) ON DELETE CASCADE;

--
-- Các ràng buộc cho bảng `yeuthich`
--
ALTER TABLE `yeuthich`
  ADD CONSTRAINT `yeuthich_ibfk_1` FOREIGN KEY (`NguoiDungID`) REFERENCES `nguoidung` (`NguoiDungID`) ON DELETE CASCADE,
  ADD CONSTRAINT `yeuthich_ibfk_2` FOREIGN KEY (`PhienBanID`) REFERENCES `phienbansanpham` (`PhienBanID`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
