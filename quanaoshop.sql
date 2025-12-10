-- MySQL dump 10.13  Distrib 8.0.44, for Win64 (x86_64)
--
-- Host: 127.0.0.1    Database: quanaoshop
-- ------------------------------------------------------
-- Server version	9.5.0

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;
SET @MYSQLDUMP_TEMP_LOG_BIN = @@SESSION.SQL_LOG_BIN;
SET @@SESSION.SQL_LOG_BIN= 0;

--
-- GTID state at the beginning of the backup 
--

SET @@GLOBAL.GTID_PURGED=/*!80000 '+'*/ '2a0babbd-b023-11f0-8e80-005056c00001:1-1470';

--
-- Table structure for table `chitietdonhang`
--

DROP TABLE IF EXISTS `chitietdonhang`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `chitietdonhang` (
  `ChiTietID` int NOT NULL AUTO_INCREMENT,
  `DonHangID` int NOT NULL,
  `PhienBanID` int NOT NULL,
  `SoLuong` int NOT NULL,
  `GiaLucMua` decimal(10,2) NOT NULL,
  PRIMARY KEY (`ChiTietID`),
  KEY `DonHangID` (`DonHangID`),
  KEY `PhienBanID` (`PhienBanID`),
  CONSTRAINT `chitietdonhang_ibfk_1` FOREIGN KEY (`DonHangID`) REFERENCES `donhang` (`DonHangID`) ON DELETE CASCADE,
  CONSTRAINT `chitietdonhang_ibfk_2` FOREIGN KEY (`PhienBanID`) REFERENCES `phienbansanpham` (`PhienBanID`),
  CONSTRAINT `chitietdonhang_chk_1` CHECK ((`SoLuong` > 0)),
  CONSTRAINT `chitietdonhang_chk_2` CHECK ((`GiaLucMua` >= 0))
) ENGINE=InnoDB AUTO_INCREMENT=58 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `chitietdonhang`
--

LOCK TABLES `chitietdonhang` WRITE;
/*!40000 ALTER TABLE `chitietdonhang` DISABLE KEYS */;
/*!40000 ALTER TABLE `chitietdonhang` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `chitietgiohang`
--

DROP TABLE IF EXISTS `chitietgiohang`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `chitietgiohang` (
  `GioHangID` int NOT NULL,
  `PhienBanID` int NOT NULL,
  `SoLuong` int NOT NULL,
  PRIMARY KEY (`GioHangID`,`PhienBanID`),
  KEY `PhienBanID` (`PhienBanID`),
  CONSTRAINT `chitietgiohang_ibfk_1` FOREIGN KEY (`GioHangID`) REFERENCES `giohang` (`NguoiDungID`) ON DELETE CASCADE,
  CONSTRAINT `chitietgiohang_ibfk_2` FOREIGN KEY (`PhienBanID`) REFERENCES `phienbansanpham` (`PhienBanID`) ON DELETE CASCADE,
  CONSTRAINT `chitietgiohang_chk_1` CHECK ((`SoLuong` > 0))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `chitietgiohang`
--

LOCK TABLES `chitietgiohang` WRITE;
/*!40000 ALTER TABLE `chitietgiohang` DISABLE KEYS */;
/*!40000 ALTER TABLE `chitietgiohang` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `chitietphienban`
--

DROP TABLE IF EXISTS `chitietphienban`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `chitietphienban` (
  `PhienBanID` int NOT NULL,
  `GiaTriID` int NOT NULL,
  PRIMARY KEY (`PhienBanID`,`GiaTriID`),
  KEY `GiaTriID` (`GiaTriID`),
  CONSTRAINT `chitietphienban_ibfk_1` FOREIGN KEY (`PhienBanID`) REFERENCES `phienbansanpham` (`PhienBanID`) ON DELETE CASCADE,
  CONSTRAINT `chitietphienban_ibfk_2` FOREIGN KEY (`GiaTriID`) REFERENCES `giatrithuoctinh` (`GiaTriID`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `chitietphienban`
--

LOCK TABLES `chitietphienban` WRITE;
/*!40000 ALTER TABLE `chitietphienban` DISABLE KEYS */;
INSERT INTO `chitietphienban` VALUES (5001,3001),(5003,3001),(5060,3001),(5071,3001),(5002,3002),(5004,3002),(5005,3002),(5006,3002),(5007,3002),(5008,3002),(5009,3002),(5010,3002),(5012,3002),(5013,3002),(5014,3002),(5015,3002),(5016,3002),(5017,3002),(5018,3002),(5019,3002),(5020,3002),(5021,3002),(5022,3002),(5023,3002),(5024,3002),(5025,3002),(5026,3002),(5027,3002),(5050,3002),(5058,3002),(5063,3002),(5065,3002),(5066,3002),(5068,3002),(5004,3003),(5005,3003),(5006,3003),(5007,3003),(5008,3003),(5009,3003),(5010,3003),(5012,3003),(5013,3003),(5014,3003),(5015,3003),(5016,3003),(5017,3003),(5018,3003),(5019,3003),(5020,3003),(5021,3003),(5022,3003),(5023,3003),(5024,3003),(5025,3003),(5026,3003),(5027,3003),(5029,3003),(5030,3003),(5031,3003),(5032,3003),(5033,3003),(5034,3003),(5001,3004),(5002,3004),(5050,3004),(5060,3004),(5061,3004),(5065,3004),(5070,3004),(5003,3005),(5049,3006),(5057,3006),(5061,3006),(5069,3006),(5070,3006),(5057,3009),(5058,3009),(5063,3009),(5067,3010),(5068,3010),(5071,3010),(5029,3011),(5028,3013),(5049,3013),(5066,3013),(5069,3013),(5030,3014),(5033,3014),(5067,3014),(5034,3019);
/*!40000 ALTER TABLE `chitietphienban` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `chitietreturns`
--

DROP TABLE IF EXISTS `chitietreturns`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `chitietreturns` (
  `ReturnID` int NOT NULL,
  `PhienBanID` int NOT NULL,
  `SoLuongTra` int NOT NULL,
  `GiaHoanTra` decimal(10,2) NOT NULL,
  PRIMARY KEY (`ReturnID`,`PhienBanID`),
  KEY `PhienBanID` (`PhienBanID`),
  CONSTRAINT `chitietreturns_ibfk_1` FOREIGN KEY (`ReturnID`) REFERENCES `returns` (`ReturnID`) ON DELETE CASCADE,
  CONSTRAINT `chitietreturns_ibfk_2` FOREIGN KEY (`PhienBanID`) REFERENCES `phienbansanpham` (`PhienBanID`),
  CONSTRAINT `chitietreturns_chk_1` CHECK ((`SoLuongTra` > 0)),
  CONSTRAINT `chitietreturns_chk_2` CHECK ((`GiaHoanTra` >= 0))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `chitietreturns`
--

LOCK TABLES `chitietreturns` WRITE;
/*!40000 ALTER TABLE `chitietreturns` DISABLE KEYS */;
/*!40000 ALTER TABLE `chitietreturns` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `danhgia`
--

DROP TABLE IF EXISTS `danhgia`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `danhgia` (
  `DanhGiaID` int NOT NULL AUTO_INCREMENT,
  `PhienBanID` int NOT NULL,
  `NguoiDungID` int NOT NULL,
  `DiemSo` int NOT NULL,
  `BinhLuan` text COLLATE utf8mb4_general_ci,
  `HinhAnhURL` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `HinhAnhPublicID` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `VideoURL` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `VideoPublicID` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `NgayTao` datetime DEFAULT CURRENT_TIMESTAMP,
  `NgayCapNhat` datetime DEFAULT NULL,
  `PhanHoi` text COLLATE utf8mb4_general_ci,
  `NgayPhanHoi` datetime DEFAULT NULL,
  PRIMARY KEY (`DanhGiaID`),
  KEY `NguoiDungID` (`NguoiDungID`),
  KEY `idx_danhgia_phienban` (`PhienBanID`),
  CONSTRAINT `danhgia_ibfk_1` FOREIGN KEY (`PhienBanID`) REFERENCES `phienbansanpham` (`PhienBanID`),
  CONSTRAINT `danhgia_ibfk_2` FOREIGN KEY (`NguoiDungID`) REFERENCES `nguoidung` (`NguoiDungID`),
  CONSTRAINT `danhgia_chk_1` CHECK ((`DiemSo` between 1 and 5))
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `danhgia`
--

LOCK TABLES `danhgia` WRITE;
/*!40000 ALTER TABLE `danhgia` DISABLE KEYS */;
/*!40000 ALTER TABLE `danhgia` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `danhmuc`
--

DROP TABLE IF EXISTS `danhmuc`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `danhmuc` (
  `DanhMucID` int NOT NULL AUTO_INCREMENT,
  `TenDanhMuc` varchar(100) COLLATE utf8mb4_general_ci NOT NULL,
  `Slug` varchar(255) COLLATE utf8mb4_general_ci NOT NULL,
  `DanhMucChaID` int DEFAULT NULL,
  `MoTa` text COLLATE utf8mb4_general_ci,
  PRIMARY KEY (`DanhMucID`),
  UNIQUE KEY `TenDanhMuc` (`TenDanhMuc`),
  UNIQUE KEY `Slug` (`Slug`),
  KEY `DanhMucChaID` (`DanhMucChaID`),
  KEY `idx_danhmuc_slug` (`Slug`),
  CONSTRAINT `danhmuc_ibfk_1` FOREIGN KEY (`DanhMucChaID`) REFERENCES `danhmuc` (`DanhMucID`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=447 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `danhmuc`
--

LOCK TABLES `danhmuc` WRITE;
/*!40000 ALTER TABLE `danhmuc` DISABLE KEYS */;
INSERT INTO `danhmuc` VALUES (401,'Đồ Nam','do-nam',NULL,NULL),(402,'Đồ Nữ','do-nu',NULL,NULL),(403,'Đồ Thể Thao','do-the-thao',NULL,NULL),(404,'Đồ Da','do-da',NULL,NULL),(405,'Phụ Kiện','phu-kien',NULL,NULL),(406,'Áo Thun Nam','ao-thun-nam',401,NULL),(407,'Áo Sơ Mi Nam','ao-so-mi-nam',401,NULL),(408,'Áo Polo Nam','ao-polo-nam',401,NULL),(409,'Áo Khoác Nam','ao-khoac-nam',401,NULL),(410,'Áo Hoodie Nam','ao-hoodie-nam',401,NULL),(411,'Quần Jean Nam','quan-jean-nam',401,NULL),(412,'Quần Short Nam','quan-short-nam',401,NULL),(413,'Quần Kaki Nam','quan-kaki-nam',401,NULL),(414,'Quần Tây Nam','quan-tay-nam',401,NULL),(415,'Áo Thun Nữ','ao-thun-nu',402,NULL),(416,'Áo Sơ Mi Nữ','ao-so-mi-nu',402,NULL),(417,'Áo Croptop','ao-croptop',402,NULL),(418,'Áo Hoodie Nữ','ao-hoodie-nu',402,NULL),(419,'Áo Khoác Nữ','ao-khoac-nu',402,NULL),(420,'Quần Jean Nữ','quan-jean-nu',402,NULL),(421,'Quần Short Nữ','quan-short-nu',402,NULL),(422,'Quần Ống Rộng','quan-ong-rong',402,NULL),(423,'Chân Váy','chan-vay',402,NULL),(424,'Váy & Đầm','dam-nu',402,NULL),(425,'Quần Áo Tập Gym','quan-ao-tap-gym',403,NULL),(426,'Đồ Chạy Bộ','do-chay-bo',403,NULL),(427,'Đồ Bơi','do-boi',403,NULL),(428,'Áo Khoác Thể Thao','ao-khoac-the-thao',403,NULL),(429,'Áo Khoác Da','ao-khoac-da',404,NULL),(430,'Ví Da','vi-da',404,NULL),(431,'Giày Da','giay-da',404,NULL),(432,'Mũ & Nón','mu-non',405,NULL),(433,'Túi & Balo','tui-balo',405,NULL),(434,'Kính Mát','kinh-mat',405,NULL),(435,'Tất & Vớ','tat-vo',405,NULL),(436,'Thắt Lưng','that-lung',405,NULL),(439,'Áo mùa thu','ao-mua-thu',401,NULL),(446,'Áo nam mùa đông','ao-nam-mua-dong',401,NULL);
/*!40000 ALTER TABLE `danhmuc` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `diachigiaohang`
--

DROP TABLE IF EXISTS `diachigiaohang`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `diachigiaohang` (
  `DiaChiID` int NOT NULL AUTO_INCREMENT,
  `NguoiDungID` int NOT NULL,
  `TenNguoiNhan` varchar(100) COLLATE utf8mb4_general_ci NOT NULL,
  `DienThoaiNhan` varchar(15) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `DiaChiChiTiet` varchar(255) COLLATE utf8mb4_general_ci NOT NULL,
  `PhuongXa` varchar(100) COLLATE utf8mb4_general_ci NOT NULL,
  `QuanHuyen` varchar(100) COLLATE utf8mb4_general_ci NOT NULL,
  `TinhThanh` varchar(100) COLLATE utf8mb4_general_ci NOT NULL,
  `MacDinh` tinyint(1) DEFAULT '0',
  PRIMARY KEY (`DiaChiID`),
  KEY `NguoiDungID` (`NguoiDungID`),
  CONSTRAINT `diachigiaohang_ibfk_1` FOREIGN KEY (`NguoiDungID`) REFERENCES `nguoidung` (`NguoiDungID`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=150 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `diachigiaohang`
--

LOCK TABLES `diachigiaohang` WRITE;
/*!40000 ALTER TABLE `diachigiaohang` DISABLE KEYS */;
/*!40000 ALTER TABLE `diachigiaohang` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `donhang`
--

DROP TABLE IF EXISTS `donhang`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `donhang` (
  `DonHangID` int NOT NULL AUTO_INCREMENT,
  `NguoiDungID` int NOT NULL,
  `DiaChiGiaoHangID` int NOT NULL,
  `MaKhuyenMai` varchar(50) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `PhuongThucID` int DEFAULT NULL,
  `NgayDatHang` datetime DEFAULT CURRENT_TIMESTAMP,
  `TongTienHang` decimal(10,2) NOT NULL,
  `PhiVanChuyen` decimal(10,2) DEFAULT '0.00',
  `TongThanhToan` decimal(10,2) NOT NULL,
  `TrangThai` enum('CHUA_THANH_TOAN','DANG_XU_LY','DANG_GIAO','DA_GIAO','DA_HUY','DOI_TRA') COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'DANG_XU_LY',
  `GhiChu` text COLLATE utf8mb4_general_ci,
  `NgayCapNhat` datetime DEFAULT NULL,
  `NguoiCapNhat` int DEFAULT NULL,
  PRIMARY KEY (`DonHangID`),
  KEY `DiaChiGiaoHangID` (`DiaChiGiaoHangID`),
  KEY `MaKhuyenMai` (`MaKhuyenMai`),
  KEY `PhuongThucID` (`PhuongThucID`),
  KEY `idx_donhang_trangthai` (`TrangThai`),
  KEY `idx_donhang_nguoidung` (`NguoiDungID`),
  CONSTRAINT `donhang_ibfk_1` FOREIGN KEY (`NguoiDungID`) REFERENCES `nguoidung` (`NguoiDungID`),
  CONSTRAINT `donhang_ibfk_2` FOREIGN KEY (`DiaChiGiaoHangID`) REFERENCES `diachigiaohang` (`DiaChiID`),
  CONSTRAINT `donhang_ibfk_3` FOREIGN KEY (`MaKhuyenMai`) REFERENCES `khuyenmai` (`MaKhuyenMai`),
  CONSTRAINT `donhang_ibfk_4` FOREIGN KEY (`PhuongThucID`) REFERENCES `phuongthucvanchuyen` (`PhuongThucID`),
  CONSTRAINT `donhang_chk_1` CHECK ((`TongTienHang` >= 0)),
  CONSTRAINT `donhang_chk_2` CHECK ((`PhiVanChuyen` >= 0)),
  CONSTRAINT `donhang_chk_3` CHECK ((`TongThanhToan` >= 0))
) ENGINE=InnoDB AUTO_INCREMENT=1046 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `donhang`
--

LOCK TABLES `donhang` WRITE;
/*!40000 ALTER TABLE `donhang` DISABLE KEYS */;
/*!40000 ALTER TABLE `donhang` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `giatrithuoctinh`
--

DROP TABLE IF EXISTS `giatrithuoctinh`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `giatrithuoctinh` (
  `GiaTriID` int NOT NULL AUTO_INCREMENT,
  `ThuocTinhID` int NOT NULL,
  `GiaTri` varchar(50) COLLATE utf8mb4_general_ci NOT NULL,
  PRIMARY KEY (`GiaTriID`),
  UNIQUE KEY `ThuocTinhID` (`ThuocTinhID`,`GiaTri`),
  CONSTRAINT `giatrithuoctinh_ibfk_1` FOREIGN KEY (`ThuocTinhID`) REFERENCES `thuoctinh` (`ThuocTinhID`)
) ENGINE=InnoDB AUTO_INCREMENT=3023 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `giatrithuoctinh`
--

LOCK TABLES `giatrithuoctinh` WRITE;
/*!40000 ALTER TABLE `giatrithuoctinh` DISABLE KEYS */;
INSERT INTO `giatrithuoctinh` VALUES (3006,301,'L'),(3002,301,'M'),(3001,301,'S'),(3007,301,'XL'),(3008,301,'XXL'),(3013,302,'Nâu'),(3004,302,'Trắng'),(3009,302,'Vàng'),(3005,302,'Xanh'),(3003,302,'Đen'),(3010,302,'Đỏ'),(3015,303,'39'),(3011,303,'40'),(3012,303,'41'),(3016,303,'42'),(3017,303,'43'),(3020,304,'100cm'),(3021,304,'110cm'),(3022,304,'120cm'),(3018,304,'80cm'),(3019,304,'90cm'),(3014,305,'Freesize');
/*!40000 ALTER TABLE `giatrithuoctinh` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `giohang`
--

DROP TABLE IF EXISTS `giohang`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `giohang` (
  `NguoiDungID` int NOT NULL,
  `NgayTao` datetime DEFAULT CURRENT_TIMESTAMP,
  `NgayCapNhat` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`NguoiDungID`),
  CONSTRAINT `giohang_ibfk_1` FOREIGN KEY (`NguoiDungID`) REFERENCES `nguoidung` (`NguoiDungID`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `giohang`
--

LOCK TABLES `giohang` WRITE;
/*!40000 ALTER TABLE `giohang` DISABLE KEYS */;
/*!40000 ALTER TABLE `giohang` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `hinhanhsanpham`
--

DROP TABLE IF EXISTS `hinhanhsanpham`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `hinhanhsanpham` (
  `HinhAnhID` int NOT NULL AUTO_INCREMENT,
  `SanPhamID` int NOT NULL,
  `PhienBanID` int DEFAULT NULL,
  `URL` varchar(255) COLLATE utf8mb4_general_ci NOT NULL,
  `MoTa` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `LaAnhChinh` tinyint(1) DEFAULT '0',
  `ViTri` int DEFAULT '0',
  PRIMARY KEY (`HinhAnhID`),
  KEY `SanPhamID` (`SanPhamID`),
  KEY `fk_hinhanh_phienban` (`PhienBanID`),
  CONSTRAINT `fk_hinhanh_phienban` FOREIGN KEY (`PhienBanID`) REFERENCES `phienbansanpham` (`PhienBanID`) ON DELETE CASCADE,
  CONSTRAINT `hinhanhsanpham_ibfk_1` FOREIGN KEY (`SanPhamID`) REFERENCES `sanpham` (`SanPhamID`) ON DELETE CASCADE,
  CONSTRAINT `hinhanhsanpham_chk_1` CHECK ((`ViTri` >= 0))
) ENGINE=InnoDB AUTO_INCREMENT=195 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `hinhanhsanpham`
--

LOCK TABLES `hinhanhsanpham` WRITE;
/*!40000 ALTER TABLE `hinhanhsanpham` DISABLE KEYS */;
INSERT INTO `hinhanhsanpham` VALUES (1,201,NULL,'https://img.lazcdn.com/g/p/d60951be1736ed5fc99ba5da947642cf.png_720x720q80.png',NULL,1,0),(2,201,NULL,'https://product.hstatic.net/200000404243/product/a3mn140r2-vnma026-2010-n-1_6644379e77504eedbec568889885df35.jpg',NULL,0,0),(3,202,NULL,'https://bizweb.dktcdn.net/100/396/594/products/img-1742.jpg?v=1708922250740',NULL,1,0),(97,203,NULL,'https://product.hstatic.net/200000471735/product/mts205s5-2-n01__2__c717a7ec0141485093264be148632b79.jpg',NULL,1,0),(98,203,NULL,'https://colo.com.vn/wp-content/uploads/2023/10/ao-thun-nam-co-tron-den-1.jpeg',NULL,0,0),(99,204,NULL,'https://product.hstatic.net/200000588671/product/ao-so-mi-nam-tay-dai-cong-so-bamboo-mau-xanh-den-1_15a13335f0b74f48a7e2f4d50aed2e01.jpg',NULL,1,0),(100,204,NULL,'https://pos.nvncdn.com/492284-9176/ps/20241110_WeY0twVLPU.jpeg?v=1731229011',NULL,0,0),(101,205,NULL,'https://cf.shopee.vn/file/c93a40ed8dc173297fa4bcd78d767186',NULL,1,0),(102,205,NULL,'https://down-vn.img.susercontent.com/file/34acd5e930c8a21e1c3a70d3cf2a70c5',NULL,0,0),(103,206,NULL,'https://lados.vn/wp-content/uploads/2024/09/3-kem-ld2107.jpg',NULL,1,0),(104,206,NULL,'https://product.hstatic.net/1000369857/product/akd903_1_tui_1200x1200_0002_layer_21_c8306b98e3604f5890c8446b99cf2a9b.jpg',NULL,0,0),(105,207,NULL,'https://product.hstatic.net/200000370509/product/1481_66c8e86d83a73540f408618b2cde78c7_66fa80d9d6d7434c8cdacfef45c12072_64843aa2f0ac499fbe30e2951a529139_large.jpg',NULL,1,0),(106,207,NULL,'https://product.hstatic.net/200000370449/product/hdr_den_sau_ec2123b4a8b447cb92efe95165691a12_master.jpg',NULL,0,0),(107,208,NULL,'https://4menshop.com/images/thumbs/2020/09/quan-jean-rach-goi-qj004-mau-den-15557.png',NULL,1,0),(108,208,NULL,'https://4menshop.com/images/thumbs/2020/05/quan-jean-slimfit-qj1645-mau-den-15196.png',NULL,0,0),(109,209,NULL,'https://product.hstatic.net/1000096703/product/kenta183__1__8d9f2bf14a22446db4465d2d8725ba92_master.jpg',NULL,1,0),(110,209,NULL,'https://cdn.vuahanghieu.com/unsafe/0x900/left/top/smart/filters:quality(90)/https://admin.vuahanghieu.com/upload/product/2024/03/quan-short-nam-lacoste-kaki-slim-mau-xanh-navy-size-33-65ebbcff03d96-09032024083559.jpg',NULL,0,0),(111,210,NULL,'https://4menshop.com/images/thumbs/2019/11/quan-kaki-slimfit-xanh-qk181-14848.jpg',NULL,1,0),(112,210,NULL,'https://product.hstatic.net/200000370509/product/6916_a5d3f55ffc09c0874577cff4e5bb5ebc_78b074ca40724ce8a8acb5822b6e0da9_54ccd36cf22f4768a70eef7fb85dabe2_master.jpg',NULL,0,0),(113,211,NULL,'https://dongphucbonmua.com/wp-content/uploads/2019/08/dong-phuc-quan-au-cong-so-nam-mau-den.jpg',NULL,1,0),(114,211,NULL,'https://img.lazcdn.com/g/p/f6e3792965cd962a40e3ef7dfc07c605.jpg_720x720q80.jpg',NULL,0,0),(115,212,NULL,'https://product.hstatic.net/1000075554/product/9460c38f30ccd4928ddd_b4132579e54b40b8ab58b0f2666221e4_c711a95222af4888b2e684edddb2500d_master.jpg',NULL,1,0),(116,212,NULL,'https://bizweb.dktcdn.net/100/287/440/products/ao-thun-nu-form-rong-tay-lo-3-acb92174-46f9-4781-bc5b-a084b1772cea.jpg?v=1622792317307',NULL,0,0),(117,213,NULL,'https://down-vn.img.susercontent.com/file/f8fcb87f54dd698447a9f1375bd22ac4',NULL,1,0),(118,213,NULL,'https://cache.maydep.vn/wp-content/uploads/2022/01/ao-so-mi-dong-phuc-nu-vai-lua.jpg',NULL,0,0),(119,214,NULL,'https://cdn.kkfashion.vn/9820-home_default/ao-croptop-tay-phong-mau-den-asm06-10.jpg',NULL,1,0),(120,214,NULL,'https://dosi-in.com/images/detailed/409/dosiin-fiin-ao-croptop-tay-phong-co-vuong-mau-tron-kieu-han-quoc-xinh-xan-cho-nu-form-rong-made-409631.jpg',NULL,0,0),(121,215,NULL,'https://m.media-amazon.com/images/I/61sC0yq4TaL._AC_UL1500_.jpg',NULL,1,0),(122,215,NULL,'https://salt.tikicdn.com/cache/w300/ts/product/45/a7/8d/53aa40a18ba18bd40efcc43355bda7f8.jpg',NULL,0,0),(123,216,NULL,'https://airui.store/wp-content/uploads/2023/12/Ao-Cardigan-Len-Nu-Dinh-Hoa-No-Mau-Trang-Be-Ao-Khoac-Len-Hang-Dep.jpg',NULL,1,0),(124,216,NULL,'https://airui.store/wp-content/uploads/2023/12/Ao-Cardigan-Len-Nu-Tui-Gau-Trang-Be-Ao-Khoac-Len-Hang-Dep.jpg',NULL,0,0),(125,217,NULL,'https://bizweb.dktcdn.net/100/484/513/products/b47934d387842cda7595.jpg?v=1714290125787',NULL,1,0),(126,217,NULL,'https://cdn.kkfashion.vn/24708-large_default/quan-jeans-dai-lung-cao-ong-loe-mau-den-qj-10.jpg',NULL,0,0),(127,218,NULL,'https://pos.nvncdn.com/d0f3ca-7136/ps/20240911_yFTGsCX5D1.jpeg',NULL,1,0),(128,218,NULL,'https://down-vn.img.susercontent.com/file/vn-11134201-23030-v0kixvlg9uov2d',NULL,0,0),(129,219,NULL,'https://salt.tikicdn.com/ts/product/a6/f2/7f/19276df6361713a219f18c7507ec74ad.jpg',NULL,1,0),(130,219,NULL,'https://vn-live-01.slatic.net/p/8a333daa8fdd139ebbeba0484576d603.jpg',NULL,0,0),(131,220,NULL,'https://img.lazcdn.com/g/p/00e36b5cc7acff00e9db8d97c8d45780.jpg_720x720q80.jpg',NULL,1,0),(132,220,NULL,'https://bizweb.dktcdn.net/100/422/076/products/z6067499164890-e77feaa745b98efca173ce2ad4864039.jpg?v=1732523012753',NULL,0,0),(133,221,NULL,'https://product.hstatic.net/200000788335/product/dav.0181-mo1_054c9f9aa1304904b4379b329e9e5652_master.jpg',NULL,1,0),(134,221,NULL,'https://thoitrangnuhoang.com/data/Product/z3590473691163_ea0dc85af12d6224e3e53827bcbbd927_1658644449.jpg',NULL,0,0),(135,222,NULL,'https://htsport.vn/wp-content/uploads/2021/12/quan-tap-gym-yoga-nu-poly-khong-tui-QG02.jpg',NULL,1,0),(136,222,NULL,'https://fitme.vn/cdn/shop/files/quan-legging-nu-tap-gym-co-tui-an-theta-qdtt-den_3.jpg?v=1710225312&width=2048',NULL,0,0),(137,223,NULL,'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSMgPXAT34XuoWh2gXuDBXGUfqUCsfN_KgAdA&s',NULL,1,0),(138,223,NULL,'https://bizweb.dktcdn.net/100/509/297/products/2-xanh-duong.jpg?v=1725873125720',NULL,0,0),(139,224,NULL,'https://supersports.com.vn/cdn/shop/files/8-134710001-1_1200x1200.jpg?v=1691402716',NULL,1,0),(140,224,NULL,'https://product.hstatic.net/200000642151/product/wo-ss24s-swi004__3__6c539eba2e5841389356b2eb889aa210_master.jpg',NULL,0,0),(141,225,NULL,'https://yeepvn.sgp1.digitaloceanspaces.com/2023/04/5445760f3dafaaf84cbb0999dd32d269.jpg',NULL,1,0),(142,225,NULL,'https://product.hstatic.net/1000308345/product/img_2108_d9dc647ef3b24c649b5d1efdfbf39d5c_master.jpg',NULL,0,0),(143,226,NULL,'https://cdn0199.cdn4s.com/media/cd9731b5125acb04924b.jpg',NULL,1,0),(144,226,NULL,'https://ann.com.vn/wp-content/uploads/22118-clean-bia-ak077.png',NULL,0,0),(145,227,NULL,'https://vuadasaigon.com/images/detailed/5/vi_da_bo_may_thu_cong_vd80_3.jpg',NULL,1,0),(146,227,NULL,'https://www.gento.vn/wp-content/uploads/2022/09/vi-nam-da-bo-2-600x600.jpg',NULL,0,0),(147,228,NULL,'https://product.hstatic.net/1000355922/product/giay-da-nam-cong-so-ngoai-co-4382045__5__61ce577b6d28424bb853106ba1ff457a_master.jpg',NULL,1,0),(148,228,NULL,'https://cdn.shopify.com/s/files/1/1404/4249/files/23112018-giay-tay-nam-dong-hai-G0703d_grande.JPG?v=1542961434',NULL,0,0),(149,229,NULL,'https://zerdio.com.vn/wp-content/uploads/2020/07/non-ket-nam-den-2.jpg',NULL,1,0),(150,229,NULL,'https://zerdio.com.vn/wp-content/uploads/2020/12/mu-luoi-trai-den-tron-9-247x247.jpg',NULL,0,0),(151,230,NULL,'https://gubag.vn/wp-content/uploads/2022/10/balo-dung-laptop-17-inch-chong-nuoc-cao-cap-gb-bl57-2-1.webp',NULL,1,0),(152,230,NULL,'https://zongvietnam.com/wp-content/uploads/2023/10/balo-laptop-du-lich-phuot-chong-tham-nuoc-tangcool-705-14-156-inch.jpg',NULL,0,0),(153,231,NULL,'https://desmonshop.com/wp-content/uploads/2021/10/photo_2021-10-28_01-09-08-2.jpg',NULL,1,0),(154,231,NULL,'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcStPCAqYGbSXR11XHlnKMsgqN8EkUFNhD9gUw&s',NULL,0,0),(155,232,NULL,'https://bizweb.dktcdn.net/100/460/898/products/1-a49b2a2e-8e05-4d5d-ad35-1e9bee4ac959.png?v=1712463597310',NULL,1,0),(156,232,NULL,'https://pos.nvncdn.com/cba2a3-7534/ps/20240701_VKbpZRjPmC.jpeg?v=1719843719',NULL,0,0),(157,233,NULL,'https://www.gento.vn/wp-content/uploads/2021/10/day-lung-nam-da-that-D40197.jpg',NULL,1,0),(158,233,NULL,'https://lavatino.com/wp-content/uploads/2020/01/That-lung-da-bo-cong-so-TINO-04-D02-TRANG-3-1-1000x1000-1.jpg',NULL,0,0),(186,249,NULL,'https://res.cloudinary.com/ddawh25f0/image/upload/v1763818199/reviews/images/a1htzdddkfiqxfkhfjbv.png','Gemini_Generated_Image_syqdp7syqdp7syqd.png',1,0),(187,249,NULL,'https://res.cloudinary.com/ddawh25f0/image/upload/v1763818222/reviews/images/agqq4qlmieekc0g1oyhn.png','Gemini_Generated_Image_wj18mxwj18mxwj18.png',0,1),(188,249,NULL,'https://res.cloudinary.com/ddawh25f0/image/upload/v1763818224/reviews/images/xy3gyezgevceosjm5hpg.png','Gemini_Generated_Image_dri83mdri83mdri8.png',0,2),(189,250,NULL,'https://res.cloudinary.com/ddawh25f0/image/upload/v1763818614/reviews/images/ufpmcrx575zvo9rorr79.jpg','non-ket-nam-den-2.jpg',1,0),(190,251,NULL,'https://res.cloudinary.com/ddawh25f0/image/upload/v1763818907/reviews/images/wabhjqks5zimitlmgrop.jpg','5445760f3dafaaf84cbb0999dd32d269.jpg',1,0),(192,253,NULL,'https://res.cloudinary.com/ddawh25f0/image/upload/v1764207393/reviews/images/vspo6qfyzxmyvnwgjlwh.png','GiamGiaCuoiTuan.jpg',1,0),(193,253,NULL,'https://res.cloudinary.com/ddawh25f0/image/upload/v1764207395/reviews/images/esykunbjjt71zhwgmrq9.webp','PhuKien.jpg',0,1),(194,253,NULL,'https://res.cloudinary.com/ddawh25f0/image/upload/v1764207396/reviews/images/a4dethqu624wys50c8yn.webp','Courtside_Collection.jpg',0,2);
/*!40000 ALTER TABLE `hinhanhsanpham` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `khuyenmai`
--

DROP TABLE IF EXISTS `khuyenmai`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `khuyenmai` (
  `MaKhuyenMai` varchar(50) COLLATE utf8mb4_general_ci NOT NULL,
  `TenKhuyenMai` varchar(255) COLLATE utf8mb4_general_ci NOT NULL,
  `LoaiGiamGia` enum('PHANTRAM','SOTIEN') COLLATE utf8mb4_general_ci NOT NULL,
  `GiaTriGiam` decimal(10,2) NOT NULL,
  `ApDungToiThieu` decimal(10,2) DEFAULT '0.00',
  `DanhMucID` int DEFAULT NULL,
  `SanPhamID` int DEFAULT NULL,
  `NgayBatDau` datetime NOT NULL,
  `NgayKetThuc` datetime NOT NULL,
  `SoLuongToiDa` int DEFAULT '0',
  `TrangThai` enum('ACTIVE','INACTIVE') COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'ACTIVE',
  PRIMARY KEY (`MaKhuyenMai`),
  KEY `DanhMucID` (`DanhMucID`),
  KEY `SanPhamID` (`SanPhamID`),
  CONSTRAINT `khuyenmai_ibfk_1` FOREIGN KEY (`DanhMucID`) REFERENCES `danhmuc` (`DanhMucID`) ON DELETE SET NULL,
  CONSTRAINT `khuyenmai_ibfk_2` FOREIGN KEY (`SanPhamID`) REFERENCES `sanpham` (`SanPhamID`) ON DELETE SET NULL,
  CONSTRAINT `khuyenmai_chk_1` CHECK ((`GiaTriGiam` >= 0)),
  CONSTRAINT `khuyenmai_chk_2` CHECK ((`ApDungToiThieu` >= 0)),
  CONSTRAINT `khuyenmai_chk_3` CHECK ((`SoLuongToiDa` >= 0))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `khuyenmai`
--

LOCK TABLES `khuyenmai` WRITE;
/*!40000 ALTER TABLE `khuyenmai` DISABLE KEYS */;
/*!40000 ALTER TABLE `khuyenmai` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `lichsudonhang`
--

DROP TABLE IF EXISTS `lichsudonhang`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `lichsudonhang` (
  `LichSuID` int NOT NULL AUTO_INCREMENT,
  `DonHangID` int NOT NULL,
  `TrangThaiCu` enum('CHUA_THANH_TOAN','DANG_XU_LY','DANG_GIAO','DA_GIAO','DA_HUY','DOI_TRA') COLLATE utf8mb4_general_ci DEFAULT NULL,
  `TrangThaiMoi` enum('CHUA_THANH_TOAN','DANG_XU_LY','DANG_GIAO','DA_GIAO','DA_HUY','DOI_TRA') COLLATE utf8mb4_general_ci DEFAULT NULL,
  `ThoiGian` datetime DEFAULT CURRENT_TIMESTAMP,
  `GhiChu` text COLLATE utf8mb4_general_ci,
  PRIMARY KEY (`LichSuID`),
  KEY `DonHangID` (`DonHangID`),
  CONSTRAINT `lichsudonhang_ibfk_1` FOREIGN KEY (`DonHangID`) REFERENCES `donhang` (`DonHangID`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=175 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `lichsudonhang`
--

LOCK TABLES `lichsudonhang` WRITE;
/*!40000 ALTER TABLE `lichsudonhang` DISABLE KEYS */;
/*!40000 ALTER TABLE `lichsudonhang` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `nguoidung`
--

DROP TABLE IF EXISTS `nguoidung`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `nguoidung` (
  `NguoiDungID` int NOT NULL AUTO_INCREMENT,
  `Email` varchar(100) COLLATE utf8mb4_general_ci NOT NULL,
  `GoogleID` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `MatKhauHash` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `LoaiXacThuc` enum('LOCAL','GOOGLE') COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'LOCAL',
  `HoTen` varchar(100) COLLATE utf8mb4_general_ci NOT NULL,
  `DienThoai` varchar(15) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `NgaySinh` date DEFAULT NULL,
  `GioiTinh` enum('Nam','Nu','Khac') COLLATE utf8mb4_general_ci DEFAULT NULL,
  `VaiTro` enum('KHACHHANG','ADMIN') COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'KHACHHANG',
  `TrangThai` enum('ACTIVE','INACTIVE') COLLATE utf8mb4_general_ci DEFAULT 'ACTIVE',
  `MatKhauResetToken` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `MatKhauResetTokenExpires` datetime DEFAULT NULL,
  `NgayTao` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`NguoiDungID`),
  UNIQUE KEY `Email` (`Email`),
  UNIQUE KEY `GoogleID` (`GoogleID`),
  KEY `idx_email` (`Email`),
  KEY `idx_google_id` (`GoogleID`)
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `nguoidung`
--

LOCK TABLES `nguoidung` WRITE;
/*!40000 ALTER TABLE `nguoidung` DISABLE KEYS */;
INSERT INTO `nguoidung` VALUES (4,'admin@gmail.com',NULL,'$2b$10$zFfCAFMhVTzxiEAwZxysOuR9cTBAOS67ZHUoa8zcf573L6dwfsswy','LOCAL','Quản Trị Viên','1234567890','2004-01-29','Nam','ADMIN','ACTIVE',NULL,NULL,'2025-11-01 15:47:44');
/*!40000 ALTER TABLE `nguoidung` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `nguoidung_voucher`
--

DROP TABLE IF EXISTS `nguoidung_voucher`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `nguoidung_voucher` (
  `NguoiDungID` int NOT NULL,
  `MaKhuyenMai` varchar(50) COLLATE utf8mb4_general_ci NOT NULL,
  `NgayNhan` datetime DEFAULT CURRENT_TIMESTAMP,
  `TrangThai` enum('DA_NHAN','DA_SU_DUNG') COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'DA_NHAN',
  PRIMARY KEY (`NguoiDungID`,`MaKhuyenMai`),
  KEY `MaKhuyenMai` (`MaKhuyenMai`),
  CONSTRAINT `nguoidung_voucher_ibfk_1` FOREIGN KEY (`NguoiDungID`) REFERENCES `nguoidung` (`NguoiDungID`) ON DELETE CASCADE,
  CONSTRAINT `nguoidung_voucher_ibfk_2` FOREIGN KEY (`MaKhuyenMai`) REFERENCES `khuyenmai` (`MaKhuyenMai`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `nguoidung_voucher`
--

LOCK TABLES `nguoidung_voucher` WRITE;
/*!40000 ALTER TABLE `nguoidung_voucher` DISABLE KEYS */;
/*!40000 ALTER TABLE `nguoidung_voucher` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `paymentmethods`
--

DROP TABLE IF EXISTS `paymentmethods`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `paymentmethods` (
  `MethodID` int NOT NULL AUTO_INCREMENT,
  `TenPhuongThuc` varchar(100) COLLATE utf8mb4_general_ci NOT NULL,
  `MoTa` text COLLATE utf8mb4_general_ci,
  `Active` tinyint(1) DEFAULT '1',
  PRIMARY KEY (`MethodID`),
  UNIQUE KEY `TenPhuongThuc` (`TenPhuongThuc`)
) ENGINE=InnoDB AUTO_INCREMENT=705 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `paymentmethods`
--

LOCK TABLES `paymentmethods` WRITE;
/*!40000 ALTER TABLE `paymentmethods` DISABLE KEYS */;
INSERT INTO `paymentmethods` VALUES (701,'COD','Thanh toán khi nhận hàng',1),(702,'VNPAY','Thanh toán qua cổng VNPAY',1),(703,'MOMO','Thanh toán qua ví MoMo',1);
/*!40000 ALTER TABLE `paymentmethods` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `phienbansanpham`
--

DROP TABLE IF EXISTS `phienbansanpham`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `phienbansanpham` (
  `PhienBanID` int NOT NULL AUTO_INCREMENT,
  `SanPhamID` int NOT NULL,
  `SKU` varchar(50) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `GiaBan` decimal(10,2) NOT NULL,
  `SoLuongTonKho` int DEFAULT '0',
  PRIMARY KEY (`PhienBanID`),
  UNIQUE KEY `SKU` (`SKU`),
  KEY `idx_phienban_sanpham` (`SanPhamID`),
  CONSTRAINT `phienbansanpham_ibfk_1` FOREIGN KEY (`SanPhamID`) REFERENCES `sanpham` (`SanPhamID`) ON DELETE CASCADE,
  CONSTRAINT `phienbansanpham_chk_1` CHECK ((`GiaBan` >= 0)),
  CONSTRAINT `phienbansanpham_chk_2` CHECK ((`SoLuongTonKho` >= 0))
) ENGINE=InnoDB AUTO_INCREMENT=5072 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `phienbansanpham`
--

LOCK TABLES `phienbansanpham` WRITE;
/*!40000 ALTER TABLE `phienbansanpham` DISABLE KEYS */;
INSERT INTO `phienbansanpham` VALUES (5001,201,'ATCB-S-TRANG',99000.00,45),(5002,201,'ATCB-M-TRANG',99000.00,13),(5003,202,'QJSF-S-XANH',399000.00,76),(5004,203,'ATCT-M-DEN',180000.00,24),(5005,204,'ASMNTD-M-DEN',360000.00,48),(5006,205,'APNVCS-M-DEN',270000.00,50),(5007,206,'AKND-M-DEN',450000.00,49),(5008,207,'AHNNB-M-DEN',405000.00,55),(5009,208,'QJNRG-M-DEN',495000.00,50),(5010,209,'QSNK-M-DEN',225000.00,48),(5012,211,'QTNOD-M-DEN',378000.00,50),(5013,212,'ATNFR-M-DEN',230000.00,30),(5014,213,'ASMNL-M-DEN',324000.00,3),(5015,214,'ACTP-M-DEN',162000.00,50),(5016,215,'AHNTM-M-DEN',432000.00,49),(5017,216,'AKNC-M-DEN',351000.00,50),(5018,217,'QJNOL-M-DEN',468000.00,50),(5019,218,'QSNJ-M-DEN',252000.00,50),(5020,219,'QORNVT-M-DEN',297000.00,50),(5021,220,'CVCA-M-DEN',243000.00,50),(5022,221,'VDMV-M-DEN',540000.00,50),(5023,222,'QLGN-M-DEN',279000.00,20),(5024,223,'QSCB2L-M-DEN',234000.00,50),(5025,224,'DBN1M-M-DEN',405000.00,50),(5026,225,'AKTTCN-M-DEN',270000.00,48),(5027,226,'AKDLB-M-DEN',1350000.00,50),(5028,227,'VDBT-NAU',450000.00,50),(5029,228,'GDNCS-40-DEN',1170000.00,50),(5030,229,'MLT-FREE-DEN',135000.00,50),(5031,230,'BLCN-DEN',630000.00,50),(5032,231,'KMGT-DEN',315000.00,50),(5033,232,'TCC-FREE-DEN',45000.00,10),(5034,233,'TLDN-90CM-DEN',360000.00,60),(5049,210,'SKU-1762558064268',380000.00,40),(5050,210,'SKU-1762558067561',380000.00,120),(5057,222,'SKU-1763049245073',310000.00,160),(5058,211,'SKU-1763812075315',400000.00,10),(5060,249,'SKU-1763818175945',100000.00,10),(5061,250,'SKU-1763818609470',100000.00,8),(5063,250,'SKU-1763822144115',100000.00,10),(5065,251,'SKU-1764109183716',100000.00,10),(5066,251,'SKU-1764109733988',100000.00,10),(5067,251,'SKU-1764109783910',100000.00,10),(5068,251,'SKU-1764109812743',100000.00,12),(5069,253,'SKU-1764207371851',80000.00,10),(5070,253,'SKU-1764207375553',100000.00,10),(5071,253,'SKU-1764207381223',100000.00,10);
/*!40000 ALTER TABLE `phienbansanpham` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `phiendangnhap`
--

DROP TABLE IF EXISTS `phiendangnhap`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `phiendangnhap` (
  `PhienID` int NOT NULL AUTO_INCREMENT,
  `NguoiDungID` int NOT NULL,
  `Token` varchar(255) COLLATE utf8mb4_general_ci NOT NULL,
  `NgayTao` datetime DEFAULT CURRENT_TIMESTAMP,
  `HetHan` datetime DEFAULT NULL,
  PRIMARY KEY (`PhienID`),
  KEY `NguoiDungID` (`NguoiDungID`),
  CONSTRAINT `phiendangnhap_ibfk_1` FOREIGN KEY (`NguoiDungID`) REFERENCES `nguoidung` (`NguoiDungID`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=121 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `phiendangnhap`
--

LOCK TABLES `phiendangnhap` WRITE;
/*!40000 ALTER TABLE `phiendangnhap` DISABLE KEYS */;
INSERT INTO `phiendangnhap` VALUES (120,4,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6NCwidmFpVHJvIjoiQURNSU4iLCJpYXQiOjE3NjUzMzMwMDYsImV4cCI6MTc2NzkyNTAwNn0.rElVFTK8KFtt7sAhmJ0uAqWxXZXkfwsd9PJGllFWZmQ','2025-12-10 09:16:46','2026-01-09 09:16:47');
/*!40000 ALTER TABLE `phiendangnhap` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `phuongthucvanchuyen`
--

DROP TABLE IF EXISTS `phuongthucvanchuyen`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `phuongthucvanchuyen` (
  `PhuongThucID` int NOT NULL AUTO_INCREMENT,
  `TenPhuongThuc` varchar(100) COLLATE utf8mb4_general_ci NOT NULL,
  `PhiCoDinh` decimal(10,2) DEFAULT '0.00',
  `MoTa` text COLLATE utf8mb4_general_ci,
  PRIMARY KEY (`PhuongThucID`),
  UNIQUE KEY `TenPhuongThuc` (`TenPhuongThuc`),
  CONSTRAINT `phuongthucvanchuyen_chk_1` CHECK ((`PhiCoDinh` >= 0))
) ENGINE=InnoDB AUTO_INCREMENT=603 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `phuongthucvanchuyen`
--

LOCK TABLES `phuongthucvanchuyen` WRITE;
/*!40000 ALTER TABLE `phuongthucvanchuyen` DISABLE KEYS */;
INSERT INTO `phuongthucvanchuyen` VALUES (601,'Giao hàng Tiết kiệm',30000.00,NULL),(602,'Giao hàng Hỏa tốc',50000.00,NULL);
/*!40000 ALTER TABLE `phuongthucvanchuyen` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `returns`
--

DROP TABLE IF EXISTS `returns`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `returns` (
  `ReturnID` int NOT NULL AUTO_INCREMENT,
  `DonHangID` int NOT NULL,
  `Reason` text COLLATE utf8mb4_general_ci NOT NULL,
  `Status` enum('PENDING','APPROVED','REJECTED','COMPLETED') COLLATE utf8mb4_general_ci DEFAULT 'PENDING',
  `RefundAmount` decimal(10,2) DEFAULT NULL,
  `NgayYeuCau` datetime DEFAULT CURRENT_TIMESTAMP,
  `NgayCapNhat` datetime DEFAULT NULL,
  `NguoiCapNhat` int DEFAULT NULL,
  PRIMARY KEY (`ReturnID`),
  KEY `DonHangID` (`DonHangID`),
  CONSTRAINT `returns_ibfk_1` FOREIGN KEY (`DonHangID`) REFERENCES `donhang` (`DonHangID`) ON DELETE CASCADE,
  CONSTRAINT `returns_chk_1` CHECK ((`RefundAmount` >= 0))
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `returns`
--

LOCK TABLES `returns` WRITE;
/*!40000 ALTER TABLE `returns` DISABLE KEYS */;
/*!40000 ALTER TABLE `returns` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sanpham`
--

DROP TABLE IF EXISTS `sanpham`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sanpham` (
  `SanPhamID` int NOT NULL AUTO_INCREMENT,
  `DanhMucID` int DEFAULT NULL,
  `TenSanPham` varchar(255) COLLATE utf8mb4_general_ci NOT NULL,
  `Slug` varchar(255) COLLATE utf8mb4_general_ci NOT NULL,
  `MoTa` text COLLATE utf8mb4_general_ci,
  `ThuongHieu` varchar(100) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `ChatLieu` varchar(100) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `GiaGoc` decimal(10,2) DEFAULT NULL,
  `TrangThai` enum('ACTIVE','DRAFT','ARCHIVED','HET_HANG') COLLATE utf8mb4_general_ci DEFAULT 'DRAFT',
  `BanChay` tinyint(1) DEFAULT '0',
  `LuotXem` int DEFAULT '0',
  `NgayTao` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`SanPhamID`),
  UNIQUE KEY `Slug` (`Slug`),
  KEY `idx_sanpham_slug` (`Slug`),
  KEY `idx_sanpham_danhmuc` (`DanhMucID`),
  CONSTRAINT `sanpham_ibfk_1` FOREIGN KEY (`DanhMucID`) REFERENCES `danhmuc` (`DanhMucID`) ON DELETE SET NULL,
  CONSTRAINT `sanpham_chk_1` CHECK ((`GiaGoc` >= 0)),
  CONSTRAINT `sanpham_chk_2` CHECK ((`LuotXem` >= 0))
) ENGINE=InnoDB AUTO_INCREMENT=254 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sanpham`
--

LOCK TABLES `sanpham` WRITE;
/*!40000 ALTER TABLE `sanpham` DISABLE KEYS */;
INSERT INTO `sanpham` VALUES (201,406,'Áo Thun Cotton Cơ Bản','ao-thun-cotton-co-ban','Thông tin sản phẩm Áo Thun:\n- Hàng chuẩn sản xuất, với những mẫu áo ý nghĩa, hài hước và độc đáo.\n- Chất liệu: thun cotton 100%, co giãn 2 chiều, vải mềm, vải mịn, thoáng mát, không xù lông.\n- Đường may chuẩn chỉnh, tỉ mỉ, chắc chắn.\n- Họa tiết được in bằng bằng công nghệ Pet Kĩ thuật số, rất chi tiết và bền màu.\n- Thiết kế với những mẫu in độc đáo!\nCó đủ các size từ   S, M, L, XL Chuẩn Form Oversize, Định Lượng 260GSM\nHướng dẫn sử dụng sản phẩm:\n- Nhớ lộn trái áo khi giặt máy và không ngâm lâu trong nước giặt\n- Không sử dụng thuốc tẩy\n- Khi phơi lộn trái và không phơi trực tiếp dưới ánh nắng mặt trời để bảo quản hình trên áo luôn đẹp\n Điều kiện áp dụng đổi sản phẩm (trong vòng 07 ngày kể từ khi nhận sản phẩm) \n- Hàng hoá sai mẫu mã do người gửi\n- Hàng hoá bị lỗi hoặc hư hỏng do vận chuyển hoặc do nhà sản xuất \nCách Thức Về Đổi Trả Sản Phẩm\n- Chúng mình chỉ nhận đổi trả sản phẩm trong vòng 7 ngày \"kể từ khi bạn nhận được hàng\", và lỗi về thiết kế hoặc chất lượng áo, Chúng mình không hỗ trợ đổi trả khi khách hàng chọn sai kích thước \" size áo \". Nếu bạn cảm thấy khó trong vấn đề chọn size thì đừng ngừng ngại Inbox cho tụi mình nhé.\nDo màn hình và điều kiện ánh sáng khác nhau, màu sắc thực tế của sản phẩm có thể chênh lệch khoảng 2-5%','BLANK CANVAS','Cotton 100%',120000.00,'ACTIVE',0,0,'2025-11-01 15:40:00'),(202,411,'Quần Jean Slim Fit','quan-jean-slim-fit','Thông tin sản phẩm Quần Jean Slim Fit:\r\n- Hàng thiết kế và sản xuất bởi DenimPro, đảm bảo chất lượng và form dáng.\r\n- Chất liệu: Vải Jean Cotton cao cấp, co giãn nhẹ, thoáng mát, giữ form, và thân thiện với da.\r\n- Đường may tỉ mỉ, tinh tế, không chỉ thừa, đạt tiêu chuẩn xuất khẩu.\r\n- Phù hợp mặc đi làm, đi chơi, dạo phố hoặc các sự kiện quan trọng.\r\n- Thiết kế Quần Jean Slim Fit hiện đại, trẻ trung, dễ dàng phối đồ.\r\n\r\nCó đủ các size từ S, M, L, XL, XXL (Vui lòng tham khảo bảng size chi tiết).\r\n\r\nHướng dẫn sử dụng sản phẩm:\r\n- Ưu tiên giặt tay ở nhiệt độ thường để giữ độ bền của Vải Jean Cotton.\r\n- Hạn chế giặt máy. Nếu giặt máy, nên lộn trái sản phẩm và cho vào túi giặt.\r\n- Không sử dụng thuốc tẩy hoặc ngâm sản phẩm quá lâu.\r\n- Phơi ở nơi thoáng mát, tránh ánh nắng mặt trời trực tiếp.\r\n\r\nĐiều kiện áp dụng đổi sản phẩm (trong vòng 07 ngày kể từ khi nhận sản phẩm):\r\n- Hàng hoá còn mới, chưa qua sử dụng, còn nguyên tem mác.\r\n- Hàng hoá bị lỗi hoặc hư hỏng do vận chuyển hoặc do nhà sản xuất.\r\n\r\nLưu ý:\r\n- Do màn hình và điều kiện ánh sáng khác nhau, màu sắc thực tế của sản phẩm có thể chênh lệch khoảng 3-5%.','DenimPro','Vải Jean Cotton',450000.00,'ARCHIVED',0,0,'2025-11-02 15:40:00'),(203,406,'Áo Thun Nam Cổ Tròn','ao-thun-nam-co-tron','Thông tin sản phẩm Áo Thun Nam Cổ Tròn:\r\n- Hàng thiết kế và sản xuất bởi UrbanFlex, đảm bảo chất lượng và form dáng.\r\n- Chất liệu: Cotton 4 chiều cao cấp, siêu co giãn, thấm hút mồ hôi, và thân thiện với da.\r\n- Đường may tỉ mỉ, tinh tế, không chỉ thừa, đạt tiêu chuẩn xuất khẩu.\r\n- Phù hợp mặc đi làm, đi chơi, dạo phố hoặc các sự kiện quan trọng.\r\n- Thiết kế Áo Thun Nam Cổ Tròn hiện đại, trẻ trung, dễ dàng phối đồ.\r\n\r\nCó đủ các size từ S, M, L, XL, XXL (Vui lòng tham khảo bảng size chi tiết).\r\n\r\nHướng dẫn sử dụng sản phẩm:\r\n- Ưu tiên giặt tay ở nhiệt độ thường để giữ độ bền của Cotton 4 chiều.\r\n- Hạn chế giặt máy. Nếu giặt máy, nên lộn trái sản phẩm và cho vào túi giặt.\r\n- Không sử dụng thuốc tẩy hoặc ngâm sản phẩm quá lâu.\r\n- Phơi ở nơi thoáng mát, tránh ánh nắng mặt trời trực tiếp.\r\n\r\nĐiều kiện áp dụng đổi sản phẩm (trong vòng 07 ngày kể từ khi nhận sản phẩm):\r\n- Hàng hoá còn mới, chưa qua sử dụng, còn nguyên tem mác.\r\n- Hàng hoá bị lỗi hoặc hư hỏng do vận chuyển hoặc do nhà sản xuất.\r\n\r\nLưu ý:\r\n- Do màn hình và điều kiện ánh sáng khác nhau, màu sắc thực tế của sản phẩm có thể chênh lệch khoảng 3-5%.','UrbanFlex','Cotton 4 chiều',200000.00,'ACTIVE',0,0,'2025-11-04 18:11:41'),(204,407,'Áo Sơ Mi Nam Tay Dài','ao-so-mi-nam-tay-dai','Thông tin sản phẩm Áo Sơ Mi Nam Tay Dài:\n- Hàng thiết kế và sản xuất bởi Elegante, đảm bảo chất lượng và form dáng.\n- Chất liệu: Vải Kate Lụa cao cấp, chống nhăn, thoáng mát, giữ form, và thân thiện với da.\n- Đường may tỉ mỉ, tinh tế, không chỉ thừa, đạt tiêu chuẩn xuất khẩu.\n- Phù hợp mặc đi làm, đi chơi, dạo phố hoặc các sự kiện quan trọng.\n- Thiết kế Áo Sơ Mi Nam Tay Dài hiện đại, trẻ trung, dễ dàng phối đồ.\n\nCó đủ các size từ S, M, L, XL, XXL (Vui lòng tham khảo bảng size chi tiết).\n\nHướng dẫn sử dụng sản phẩm:\n- Ưu tiên giặt tay ở nhiệt độ thường để giữ độ bền của Vải Kate Lụa.\n- Hạn chế giặt máy. Nếu giặt máy, nên lộn trái sản phẩm và cho vào túi giặt.\n- Không sử dụng thuốc tẩy hoặc ngâm sản phẩm quá lâu.\n- Phơi ở nơi thoáng mát, tránh ánh nắng mặt trời trực tiếp.\n\nĐiều kiện áp dụng đổi sản phẩm (trong vòng 07 ngày kể từ khi nhận sản phẩm):\n- Hàng hoá còn mới, chưa qua sử dụng, còn nguyên tem mác.\n- Hàng hoá bị lỗi hoặc hư hỏng do vận chuyển hoặc do nhà sản xuất.\n\nLưu ý:\n- Do màn hình và điều kiện ánh sáng khác nhau, màu sắc thực tế của sản phẩm có thể chênh lệch khoảng 3-5%.','Elegante','Vải Kate Lụa',400000.00,'ACTIVE',0,0,'2025-11-04 18:11:41'),(205,408,'Áo Polo Nam Vải Cá Sấu','ao-polo-nam-vai-ca-sau','Thông tin sản phẩm Áo Polo Nam Vải Cá Sấu:\n- Hàng thiết kế và sản xuất bởi ActiveWear, đảm bảo chất lượng và form dáng.\n- Chất liệu: Vải Cotton Pique (Cá Sấu) cao cấp, thoáng mát, giữ form, và thân thiện với da.\n- Đường may tỉ mỉ, tinh tế, không chỉ thừa, đạt tiêu chuẩn xuất khẩu.\n- Phù hợp mặc đi làm, đi chơi, dạo phố hoặc các sự kiện quan trọng.\n- Thiết kế Áo Polo Nam Vải Cá Sấu hiện đại, trẻ trung, dễ dàng phối đồ.\n\nCó đủ các size từ S, M, L, XL, XXL (Vui lòng tham khảo bảng size chi tiết).\n\nHướng dẫn sử dụng sản phẩm:\n- Ưu tiên giặt tay ở nhiệt độ thường để giữ độ bền của Vải Cotton Pique (Cá Sấu).\n- Hạn chế giặt máy. Nếu giặt máy, nên lộn trái sản phẩm và cho vào túi giặt.\n- Không sử dụng thuốc tẩy hoặc ngâm sản phẩm quá lâu.\n- Phơi ở nơi thoáng mát, tránh ánh nắng mặt trời trực tiếp.\n\nĐiều kiện áp dụng đổi sản phẩm (trong vòng 07 ngày kể từ khi nhận sản phẩm):\n- Hàng hoá còn mới, chưa qua sử dụng, còn nguyên tem mác.\n- Hàng hoá bị lỗi hoặc hư hỏng do vận chuyển hoặc do nhà sản xuất.\n\nLưu ý:\n- Do màn hình và điều kiện ánh sáng khác nhau, màu sắc thực tế của sản phẩm có thể chênh lệch khoảng 3-5%.','ActiveWear','Vải Cotton Pique (Cá Sấu)',300000.00,'ACTIVE',0,0,'2025-11-04 18:11:41'),(206,409,'Áo Khoác Nam Dù','ao-khoac-nam-du','Thông tin sản phẩm Áo Khoác Nam Dù:\n- Hàng thiết kế và sản xuất bởi WindBreaker, đảm bảo chất lượng và form dáng.\n- Chất liệu: Vải Dù 2 lớp cao cấp, chống gió, trượt nước nhẹ, và thân thiện với da.\n- Đường may tỉ mỉ, tinh tế, không chỉ thừa, đạt tiêu chuẩn xuất khẩu.\n- Phù hợp mặc đi làm, đi chơi, dạo phố hoặc các sự kiện quan trọng.\n- Thiết kế Áo Khoác Nam Dù hiện đại, trẻ trung, dễ dàng phối đồ.\n\nCó đủ các size từ S, M, L, XL, XXL (Vui lòng tham khảo bảng size chi tiết).\n\nHướng dẫn sử dụng sản phẩm:\n- Ưu tiên giặt tay ở nhiệt độ thường để giữ độ bền của Vải Dù 2 lớp.\n- Hạn chế giặt máy. Nếu giặt máy, nên lộn trái sản phẩm và cho vào túi giặt.\n- Không sử dụng thuốc tẩy hoặc ngâm sản phẩm quá lâu.\n- Phơi ở nơi thoáng mát, tránh ánh nắng mặt trời trực tiếp.\n\nĐiều kiện áp dụng đổi sản phẩm (trong vòng 07 ngày kể từ khi nhận sản phẩm):\n- Hàng hoá còn mới, chưa qua sử dụng, còn nguyên tem mác.\n- Hàng hoá bị lỗi hoặc hư hỏng do vận chuyển hoặc do nhà sản xuất.\n\nLưu ý:\n- Do màn hình và điều kiện ánh sáng khác nhau, màu sắc thực tế của sản phẩm có thể chênh lệch khoảng 3-5%.','WindBreaker','Vải Dù 2 lớp',500000.00,'ACTIVE',0,0,'2025-11-04 18:11:41'),(207,410,'Áo Hoodie Nam Nỉ Bông','ao-hoodie-nam-ni-bong','Thông tin sản phẩm Áo Hoodie Nam Nỉ Bông:\r\n- Hàng thiết kế và sản xuất bởi CozyWear, đảm bảo chất lượng và form dáng.\r\n- Chất liệu: Vải Nỉ Bông Dày cao cấp, ấm áp, giữ form, và thân thiện với da.\r\n- Đường may tỉ mỉ, tinh tế, không chỉ thừa, đạt tiêu chuẩn xuất khẩu.\r\n- Phù hợp mặc đi làm, đi chơi, dạo phố hoặc các sự kiện quan trọng.\r\n- Thiết kế Áo Hoodie Nam Nỉ Bông hiện đại, trẻ trung, dễ dàng phối đồ.\r\n\r\nCó đủ các size từ S, M, L, XL, XXL (Vui lòng tham khảo bảng size chi tiết).\r\n\r\nHướng dẫn sử dụng sản phẩm:\r\n- Ưu tiên giặt tay ở nhiệt độ thường để giữ độ bền của Vải Nỉ Bông Dày.\r\n- Hạn chế giặt máy. Nếu giặt máy, nên lộn trái sản phẩm và cho vào túi giặt.\r\n- Không sử dụng thuốc tẩy hoặc ngâm sản phẩm quá lâu.\r\n- Phơi ở nơi thoáng mát, tránh ánh nắng mặt trời trực tiếp.\r\n\r\nĐiều kiện áp dụng đổi sản phẩm (trong vòng 07 ngày kể từ khi nhận sản phẩm):\r\n- Hàng hoá còn mới, chưa qua sử dụng, còn nguyên tem mác.\r\n- Hàng hoá bị lỗi hoặc hư hỏng do vận chuyển hoặc do nhà sản xuất.\r\n\r\nLưu ý:\r\n- Do màn hình và điều kiện ánh sáng khác nhau, màu sắc thực tế của sản phẩm có thể chênh lệch khoảng 3-5%.','CozyWear','Vải Nỉ Bông Dày',450000.00,'ACTIVE',0,0,'2025-11-04 18:11:41'),(208,411,'Quần Jean Nam Rách Gối','quan-jean-nam-rach-goi','Thông tin sản phẩm Quần Jean Nam Rách Gối:\n- Hàng thiết kế và sản xuất bởi RippedStyle, đảm bảo chất lượng và form dáng.\n- Chất liệu: Vải Jean Bụi cao cấp, thoáng mát, giữ form, và thân thiện với da.\n- Đường may tỉ mỉ, tinh tế, không chỉ thừa, đạt tiêu chuẩn xuất khẩu.\n- Phù hợp mặc đi làm, đi chơi, dạo phố hoặc các sự kiện quan trọng.\n- Thiết kế Quần Jean Nam Rách Gối hiện đại, trẻ trung, dễ dàng phối đồ.\n\nCó đủ các size từ S, M, L, XL, XXL (Vui lòng tham khảo bảng size chi tiết).\n\nHướng dẫn sử dụng sản phẩm:\n- Ưu tiên giặt tay ở nhiệt độ thường để giữ độ bền của Vải Jean Bụi.\n- Hạn chế giặt máy. Nếu giặt máy, nên lộn trái sản phẩm và cho vào túi giặt.\n- Không sử dụng thuốc tẩy hoặc ngâm sản phẩm quá lâu.\n- Phơi ở nơi thoáng mát, tránh ánh nắng mặt trời trực tiếp.\n\nĐiều kiện áp dụng đổi sản phẩm (trong vòng 07 ngày kể từ khi nhận sản phẩm):\n- Hàng hoá còn mới, chưa qua sử dụng, còn nguyên tem mác.\n- Hàng hoá bị lỗi hoặc hư hỏng do vận chuyển hoặc do nhà sản xuất.\n\nLưu ý:\n- Do màn hình và điều kiện ánh sáng khác nhau, màu sắc thực tế của sản phẩm có thể chênh lệch khoảng 3-5%.','RippedStyle','Vải Jean Bụi',550000.00,'ACTIVE',0,0,'2025-11-04 18:11:41'),(209,412,'Quần Short Nam Kaki','quan-short-nam-kaki','Thông tin sản phẩm Quần Short Nam Kaki:\r\n- Hàng thiết kế và sản xuất bởi UrbanFlex, đảm bảo chất lượng và form dáng.\r\n- Chất liệu: Vải Kaki Cotton cao cấp, thoáng mát, giữ form, và thân thiện với da.\r\n- Đường may tỉ mỉ, tinh tế, không chỉ thừa, đạt tiêu chuẩn xuất khẩu.\r\n- Phù hợp mặc đi làm, đi chơi, dạo phố hoặc các sự kiện quan trọng.\r\n- Thiết kế Quần Short Nam Kaki hiện đại, trẻ trung, dễ dàng phối đồ.\r\n\r\nCó đủ các size từ S, M, L, XL, XXL (Vui lòng tham khảo bảng size chi tiết).\r\n\r\nHướng dẫn sử dụng sản phẩm:\r\n- Ưu tiên giặt tay ở nhiệt độ thường để giữ độ bền của Vải Kaki Cotton.\r\n- Hạn chế giặt máy. Nếu giặt máy, nên lộn trái sản phẩm và cho vào túi giặt.\r\n- Không sử dụng thuốc tẩy hoặc ngâm sản phẩm quá lâu.\r\n- Phơi ở nơi thoáng mát, tránh ánh nắng mặt trời trực tiếp.\r\n\r\nĐiều kiện áp dụng đổi sản phẩm (trong vòng 07 ngày kể từ khi nhận sản phẩm):\r\n- Hàng hoá còn mới, chưa qua sử dụng, còn nguyên tem mác.\r\n- Hàng hoá bị lỗi hoặc hư hỏng do vận chuyển hoặc do nhà sản xuất.\r\n\r\nLưu ý:\r\n- Do màn hình và điều kiện ánh sáng khác nhau, màu sắc thực tế của sản phẩm có thể chênh lệch khoảng 3-5%.','UrbanFlex','Vải Kaki Cotton',250000.00,'ACTIVE',0,0,'2025-11-04 18:11:41'),(210,413,'Quần Kaki Nam Dáng Slim','quan-kaki-nam-dang-slim','','','',380000.00,'ACTIVE',0,0,'2025-11-04 18:11:41'),(211,414,'Quần Tây Nam Ống Đứng','quan-tay-nam-ong-dung','Thông tin sản phẩm Quần Tây Nam Ống Đứng:\r\n- Hàng thiết kế và sản xuất bởi OfficeStyle, đảm bảo chất lượng và form dáng.\r\n- Chất liệu: Vải Tây Cao Cấp cao cấp, chống nhăn, thoáng mát, giữ form, và thân thiện với da.\r\n- Đường may tỉ mỉ, tinh tế, không chỉ thừa, đạt tiêu chuẩn xuất khẩu.\r\n- Phù hợp mặc đi làm, đi chơi, dạo phố hoặc các sự kiện quan trọng.\r\n- Thiết kế Quần Tây Nam Ống Đứng hiện đại, trẻ trung, dễ dàng phối đồ.\r\n\r\nCó đủ các size từ S, M, L, XL, XXL (Vui lòng tham khảo bảng size chi tiết).\r\n\r\nHướng dẫn sử dụng sản phẩm:\r\n- Ưu tiên giặt tay ở nhiệt độ thường để giữ độ bền của Vải Tây Cao Cấp.\r\n- Hạn chế giặt máy. Nếu giặt máy, nên lộn trái sản phẩm và cho vào túi giặt.\r\n- Không sử dụng thuốc tẩy hoặc ngâm sản phẩm quá lâu.\r\n- Phơi ở nơi thoáng mát, tránh ánh nắng mặt trời trực tiếp.\r\n\r\nĐiều kiện áp dụng đổi sản phẩm (trong vòng 07 ngày kể từ khi nhận sản phẩm):\r\n- Hàng hoá còn mới, chưa qua sử dụng, còn nguyên tem mác.\r\n- Hàng hoá bị lỗi hoặc hư hỏng do vận chuyển hoặc do nhà sản xuất.\r\n\r\nLưu ý:\r\n- Do màn hình và điều kiện ánh sáng khác nhau, màu sắc thực tế của sản phẩm có thể chênh lệch khoảng 3-5%.','OfficeStyle','Vải Tây Cao Cấp',420000.00,'ACTIVE',0,0,'2025-11-04 18:11:41'),(212,415,'Áo Thun Nữ Form Rộng','ao-thun-nu-form-rong','Thông tin sản phẩm Áo Thun Nữ Form Rộng:\r\n- Hàng thiết kế và sản xuất bởi DivaStyle, đảm bảo chất lượng và form dáng.\r\n- Chất liệu: Cotton 100% 2 chiều cao cấp, thoáng mát, giữ form, và thân thiện với da.\r\n- Đường may tỉ mỉ, tinh tế, không chỉ thừa, đạt tiêu chuẩn xuất khẩu.\r\n- Phù hợp mặc đi làm, đi chơi, dạo phố hoặc các sự kiện quan trọng.\r\n- Thiết kế Áo Thun Nữ Form Rộng hiện đại, trẻ trung, dễ dàng phối đồ.\r\n\r\nCó đủ các size từ S, M, L, XL, XXL (Vui lòng tham khảo bảng size chi tiết).\r\n\r\nHướng dẫn sử dụng sản phẩm:\r\n- Ưu tiên giặt tay ở nhiệt độ thường để giữ độ bền của Cotton 100% 2 chiều.\r\n- Hạn chế giặt máy. Nếu giặt máy, nên lộn trái sản phẩm và cho vào túi giặt.\r\n- Không sử dụng thuốc tẩy hoặc ngâm sản phẩm quá lâu.\r\n- Phơi ở nơi thoáng mát, tránh ánh nắng mặt trời trực tiếp.\r\n\r\nĐiều kiện áp dụng đổi sản phẩm (trong vòng 07 ngày kể từ khi nhận sản phẩm):\r\n- Hàng hoá còn mới, chưa qua sử dụng, còn nguyên tem mác.\r\n- Hàng hoá bị lỗi hoặc hư hỏng do vận chuyển hoặc do nhà sản xuất.\r\n\r\nLưu ý:\r\n- Do màn hình và điều kiện ánh sáng khác nhau, màu sắc thực tế của sản phẩm có thể chênh lệch khoảng 3-5%.','DivaStyle','Cotton 100% 2 chiều',220000.00,'ACTIVE',0,0,'2025-11-04 18:11:41'),(213,416,'Áo Sơ Mi Nữ Lụa','ao-so-mi-nu-lua','Thông tin sản phẩm Áo Sơ Mi Nữ Lụa:\r\n- Hàng thiết kế và sản xuất bởi SilkSation, đảm bảo chất lượng và form dáng.\r\n- Chất liệu: Vải Lụa Satin cao cấp, mềm mịn, thoáng mát, giữ form, và thân thiện với da.\r\n- Đường may tỉ mỉ, tinh tế, không chỉ thừa, đạt tiêu chuẩn xuất khẩu.\r\n- Phù hợp mặc đi làm, đi chơi, dạo phố hoặc các sự kiện quan trọng.\r\n- Thiết kế Áo Sơ Mi Nữ Lụa hiện đại, trẻ trung, dễ dàng phối đồ.\r\n\r\nCó đủ các size từ S, M, L, XL, XXL (Vui lòng tham khảo bảng size chi tiết).\r\n\r\nHướng dẫn sử dụng sản phẩm:\r\n- Ưu tiên giặt tay ở nhiệt độ thường để giữ độ bền của Vải Lụa Satin.\r\n- Hạn chế giặt máy. Nếu giặt máy, nên lộn trái sản phẩm và cho vào túi giặt.\r\n- Không sử dụng thuốc tẩy hoặc ngâm sản phẩm quá lâu.\r\n- Phơi ở nơi thoáng mát, tránh ánh nắng mặt trời trực tiếp.\r\n\r\nĐiều kiện áp dụng đổi sản phẩm (trong vòng 07 ngày kể từ khi nhận sản phẩm):\r\n- Hàng hoá còn mới, chưa qua sử dụng, còn nguyên tem mác.\r\n- Hàng hoá bị lỗi hoặc hư hỏng do vận chuyển hoặc do nhà sản xuất.\r\n\r\nLưu ý:\r\n- Do màn hình và điều kiện ánh sáng khác nhau, màu sắc thực tế của sản phẩm có thể chênh lệch khoảng 3-5%.','SilkySation','Vải Lụa Satin',360000.00,'ACTIVE',0,0,'2025-11-04 18:11:41'),(214,417,'Áo Croptop Tay Phồng','ao-croptop-tay-phong','Thông tin sản phẩm Áo Croptop Tay Phồng:\n- Hàng thiết kế và sản xuất bởi DivaStyle, đảm bảo chất lượng và form dáng.\n- Chất liệu: Vải Kate Forrm cao cấp, thoáng mát, giữ form, và thân thiện với da.\n- Đường may tỉ mỉ, tinh tế, không chỉ thừa, đạt tiêu chuẩn xuất khẩu.\n- Phù hợp mặc đi làm, đi chơi, dạo phố hoặc các sự kiện quan trọng.\n- Thiết kế Áo Croptop Tay Phồng hiện đại, trẻ trung, dễ dàng phối đồ.\n\nCó đủ các size từ S, M, L, XL, XXL (Vui lòng tham khảo bảng size chi tiết).\n\nHướng dẫn sử dụng sản phẩm:\n- Ưu tiên giặt tay ở nhiệt độ thường để giữ độ bền của Vải Kate Forrm.\n- Hạn chế giặt máy. Nếu giặt máy, nên lộn trái sản phẩm và cho vào túi giặt.\n- Không sử dụng thuốc tẩy hoặc ngâm sản phẩm quá lâu.\n- Phơi ở nơi thoáng mát, tránh ánh nắng mặt trời trực tiếp.\n\nĐiều kiện áp dụng đổi sản phẩm (trong vòng 07 ngày kể từ khi nhận sản phẩm):\n- Hàng hoá còn mới, chưa qua sử dụng, còn nguyên tem mác.\n- Hàng hoá bị lỗi hoặc hư hỏng do vận chuyển hoặc do nhà sản xuất.\n\nLưu ý:\n- Do màn hình và điều kiện ánh sáng khác nhau, màu sắc thực tế của sản phẩm có thể chênh lệch khoảng 3-5%.','DivaStyle','Vải Kate Forrm',180000.00,'ACTIVE',0,0,'2025-11-04 18:11:41'),(215,418,'Áo Hoodie Nữ Tai Mèo','ao-hoodie-nu-tai-meo','Thông tin sản phẩm Áo Hoodie Nữ Tai Mèo:\n- Hàng thiết kế và sản xuất bởi CozyWear, đảm bảo chất lượng và form dáng.\n- Chất liệu: Vải Nỉ Bông Mịn cao cấp, ấm áp, giữ form, và thân thiện với da.\n- Đường may tỉ mỉ, tinh tế, không chỉ thừa, đạt tiêu chuẩn xuất khẩu.\n- Phù hợp mặc đi làm, đi chơi, dạo phố hoặc các sự kiện quan trọng.\n- Thiết kế Áo Hoodie Nữ Tai Mèo hiện đại, trẻ trung, dễ dàng phối đồ.\n\nCó đủ các size từ S, M, L, XL, XXL (Vui lòng tham khảo bảng size chi tiết).\n\nHướng dẫn sử dụng sản phẩm:\n- Ưu tiên giặt tay ở nhiệt độ thường để giữ độ bền của Vải Nỉ Bông Mịn.\n- Hạn chế giặt máy. Nếu giặt máy, nên lộn trái sản phẩm và cho vào túi giặt.\n- Không sử dụng thuốc tẩy hoặc ngâm sản phẩm quá lâu.\n- Phơi ở nơi thoáng mát, tránh ánh nắng mặt trời trực tiếp.\n\nĐiều kiện áp dụng đổi sản phẩm (trong vòng 07 ngày kể từ khi nhận sản phẩm):\n- Hàng hoá còn mới, chưa qua sử dụng, còn nguyên tem mác.\n- Hàng hoá bị lỗi hoặc hư hỏng do vận chuyển hoặc do nhà sản xuất.\n\nLưu ý:\n- Do màn hình và điều kiện ánh sáng khác nhau, màu sắc thực tế của sản phẩm có thể chênh lệch khoảng 3-5%.','CozyWear','Vải Nỉ Bông Mịn',480000.00,'ACTIVE',0,0,'2025-11-04 18:11:41'),(216,419,'Áo Khoác Nữ Cardigan','ao-khoac-nu-cardigan','Thông tin sản phẩm Áo Khoác Nữ Cardigan:\n- Hàng thiết kế và sản xuất bởi CozyWear, đảm bảo chất lượng và form dáng.\n- Chất liệu: Vải Len Dệt Kim cao cấp, mềm mại, thoáng mát, giữ form, và thân thiện với da.\n- Đường may tỉ mỉ, tinh tế, không chỉ thừa, đạt tiêu chuẩn xuất khẩu.\n- Phù hợp mặc đi làm, đi chơi, dạo phố hoặc các sự kiện quan trọng.\n- Thiết kế Áo Khoác Nữ Cardigan hiện đại, trẻ trung, dễ dàng phối đồ.\n\nCó đủ các size từ S, M, L, XL, XXL (Vui lòng tham khảo bảng size chi tiết).\n\nHướng dẫn sử dụng sản phẩm:\n- Ưu tiên giặt tay ở nhiệt độ thường để giữ độ bền của Vải Len Dệt Kim.\n- Hạn chế giặt máy. Nếu giặt máy, nên lộn trái sản phẩm và cho vào túi giặt.\n- Không sử dụng thuốc tẩy hoặc ngâm sản phẩm quá lâu.\n- Phơi ở nơi thoáng mát, tránh ánh nắng mặt trời trực tiếp.\n\nĐiều kiện áp dụng đổi sản phẩm (trong vòng 07 ngày kể từ khi nhận sản phẩm):\n- Hàng hoá còn mới, chưa qua sử dụng, còn nguyên tem mác.\n- Hàng hoá bị lỗi hoặc hư hỏng do vận chuyển hoặc do nhà sản xuất.\n\nLưu ý:\n- Do màn hình và điều kiện ánh sáng khác nhau, màu sắc thực tế của sản phẩm có thể chênh lệch khoảng 3-5%.','CozyWear','Vải Len Dệt Kim',390000.00,'ACTIVE',0,0,'2025-11-04 18:11:41'),(217,420,'Quần Jean Nữ Ống Loe','quan-jean-nu-ong-loe','Thông tin sản phẩm Quần Jean Nữ Ống Loe:\n- Hàng thiết kế và sản xuất bởi DivaStyle, đảm bảo chất lượng và form dáng.\n- Chất liệu: Vải Jean Co Giãn cao cấp, tôn dáng, giữ form, và thân thiện với da.\n- Đường may tỉ mỉ, tinh tế, không chỉ thừa, đạt tiêu chuẩn xuất khẩu.\n- Phù hợp mặc đi làm, đi chơi, dạo phố hoặc các sự kiện quan trọng.\n- Thiết kế Quần Jean Nữ Ống Loe hiện đại, trẻ trung, dễ dàng phối đồ.\n\nCó đủ các size từ S, M, L, XL, XXL (Vui lòng tham khảo bảng size chi tiết).\n\nHướng dẫn sử dụng sản phẩm:\n- Ưu tiên giặt tay ở nhiệt độ thường để giữ độ bền của Vải Jean Co Giãn.\n- Hạn chế giặt máy. Nếu giặt máy, nên lộn trái sản phẩm và cho vào túi giặt.\n- Không sử dụng thuốc tẩy hoặc ngâm sản phẩm quá lâu.\n- Phơi ở nơi thoáng mát, tránh ánh nắng mặt trời trực tiếp.\n\nĐiều kiện áp dụng đổi sản phẩm (trong vòng 07 ngày kể từ khi nhận sản phẩm):\n- Hàng hoá còn mới, chưa qua sử dụng, còn nguyên tem mác.\n- Hàng hoá bị lỗi hoặc hư hỏng do vận chuyển hoặc do nhà sản xuất.\n\nLưu ý:\n- Do màn hình và điều kiện ánh sáng khác nhau, màu sắc thực tế của sản phẩm có thể chênh lệch khoảng 3-5%.','DivaStyle','Vải Jean Co Giãn',520000.00,'ACTIVE',0,0,'2025-11-04 18:11:41'),(218,421,'Quần Short Nữ Jean','quan-short-nu-jean','Thông tin sản phẩm Quần Short Nữ Jean:\n- Hàng thiết kế và sản xuất bởi DenimPro, đảm bảo chất lượng và form dáng.\n- Chất liệu: Vải Jean Cotton cao cấp, thoáng mát, giữ form, và thân thiện với da.\n- Đường may tỉ mỉ, tinh tế, không chỉ thừa, đạt tiêu chuẩn xuất khẩu.\n- Phù hợp mặc đi làm, đi chơi, dạo phố hoặc các sự kiện quan trọng.\n- Thiết kế Quần Short Nữ Jean hiện đại, trẻ trung, dễ dàng phối đồ.\n\nCó đủ các size từ S, M, L, XL, XXL (Vui lòng tham khảo bảng size chi tiết).\n\nHướng dẫn sử dụng sản phẩm:\n- Ưu tiên giặt tay ở nhiệt độ thường để giữ độ bền của Vải Jean Cotton.\n- Hạn chế giặt máy. Nếu giặt máy, nên lộn trái sản phẩm và cho vào túi giặt.\n- Không sử dụng thuốc tẩy hoặc ngâm sản phẩm quá lâu.\n- Phơi ở nơi thoáng mát, tránh ánh nắng mặt trời trực tiếp.\n\nĐiều kiện áp dụng đổi sản phẩm (trong vòng 07 ngày kể từ khi nhận sản phẩm):\n- Hàng hoá còn mới, chưa qua sử dụng, còn nguyên tem mác.\n- Hàng hoá bị lỗi hoặc hư hỏng do vận chuyển hoặc do nhà sản xuất.\n\nLưu ý:\n- Do màn hình và điều kiện ánh sáng khác nhau, màu sắc thực tế của sản phẩm có thể chênh lệch khoảng 3-5%.','DenimPro','Vải Jean Cotton',280000.00,'ACTIVE',0,0,'2025-11-04 18:11:41'),(219,422,'Quần Ống Rộng Nữ Vải Tuyết','quan-ong-rong-nu-vai-tuyet','Thông tin sản phẩm Quần Ống Rộng Nữ Vải Tuyết:\n- Hàng thiết kế và sản xuất bởi Elegante, đảm bảo chất lượng và form dáng.\n- Chất liệu: Vải Tuyết Mưa cao cấp, thoáng mát, giữ form, và thân thiện với da.\n- Đường may tỉ mỉ, tinh tế, không chỉ thừa, đạt tiêu chuẩn xuất khẩu.\n- Phù hợp mặc đi làm, đi chơi, dạo phố hoặc các sự kiện quan trọng.\n- Thiết kế Quần Ống Rộng Nữ Vải Tuyết hiện đại, trẻ trung, dễ dàng phối đồ.\n\nCó đủ các size từ S, M, L, XL, XXL (Vui lòng tham khảo bảng size chi tiết).\n\nHướng dẫn sử dụng sản phẩm:\n- Ưu tiên giặt tay ở nhiệt độ thường để giữ độ bền của Vải Tuyết Mưa.\n- Hạn chế giặt máy. Nếu giặt máy, nên lộn trái sản phẩm và cho vào túi giặt.\n- Không sử dụng thuốc tẩy hoặc ngâm sản phẩm quá lâu.\n- Phơi ở nơi thoáng mát, tránh ánh nắng mặt trời trực tiếp.\n\nĐiều kiện áp dụng đổi sản phẩm (trong vòng 07 ngày kể từ khi nhận sản phẩm):\n- Hàng hoá còn mới, chưa qua sử dụng, còn nguyên tem mác.\n- Hàng hoá bị lỗi hoặc hư hỏng do vận chuyển hoặc do nhà sản xuất.\n\nLưu ý:\n- Do màn hình và điều kiện ánh sáng khác nhau, màu sắc thực tế của sản phẩm có thể chênh lệch khoảng 3-5%.','Elegante','Vải Tuyết Mưa',330000.00,'ACTIVE',0,0,'2025-11-04 18:11:41'),(220,423,'Chân Váy Chữ A','chan-vay-chu-a','Thông tin sản phẩm Chân Váy Chữ A:\n- Hàng thiết kế và sản xuất bởi DivaStyle, đảm bảo chất lượng và form dáng.\n- Chất liệu: Vải Kaki Mềm cao cấp, thoáng mát, giữ form, và thân thiện với da.\n- Đường may tỉ mỉ, tinh tế, không chỉ thừa, đạt tiêu chuẩn xuất khẩu.\n- Phù hợp mặc đi làm, đi chơi, dạo phố hoặc các sự kiện quan trọng.\n- Thiết kế Chân Váy Chữ A hiện đại, trẻ trung, dễ dàng phối đồ.\n\nCó đủ các size từ S, M, L, XL, XXL (Vui lòng tham khảo bảng size chi tiết).\n\nHướng dẫn sử dụng sản phẩm:\n- Ưu tiên giặt tay ở nhiệt độ thường để giữ độ bền của Vải Kaki Mềm.\n- Hạn chế giặt máy. Nếu giặt máy, nên lộn trái sản phẩm và cho vào túi giặt.\n- Không sử dụng thuốc tẩy hoặc ngâm sản phẩm quá lâu.\n- Phơi ở nơi thoáng mát, tránh ánh nắng mặt trời trực tiếp.\n\nĐiều kiện áp dụng đổi sản phẩm (trong vòng 07 ngày kể từ khi nhận sản phẩm):\n- Hàng hoá còn mới, chưa qua sử dụng, còn nguyên tem mác.\n- Hàng hoá bị lỗi hoặc hư hỏng do vận chuyển hoặc do nhà sản xuất.\n\nLưu ý:\n- Do màn hình và điều kiện ánh sáng khác nhau, màu sắc thực tế của sản phẩm có thể chênh lệch khoảng 3-5%.','DivaStyle','Vải Kaki Mềm',270000.00,'ACTIVE',0,0,'2025-11-04 18:11:41'),(221,424,'Váy Đầm Maxi Voan','vay-dam-maxi-voan','Thông tin sản phẩm Váy Đầm Maxi Voan:\n- Hàng thiết kế và sản xuất bởi SilkSation, đảm bảo chất lượng và form dáng.\n- Chất liệu: Vải Voan Lụa 2 Lớp cao cấp, bay bổng, thoáng mát, giữ form, và thân thiện với da.\n- Đường may tỉ mỉ, tinh tế, không chỉ thừa, đạt tiêu chuẩn xuất khẩu.\n- Phù hợp mặc đi làm, đi chơi, dạo phố hoặc các sự kiện quan trọng.\n- Thiết kế Váy Đầm Maxi Voan hiện đại, trẻ trung, dễ dàng phối đồ.\n\nCó đủ các size từ S, M, L, XL, XXL (Vui lòng tham khảo bảng size chi tiết).\n\nHướng dẫn sử dụng sản phẩm:\n- Ưu tiên giặt tay ở nhiệt độ thường để giữ độ bền của Vải Voan Lụa 2 Lớp.\n- Hạn chế giặt máy. Nếu giặt máy, nên lộn trái sản phẩm và cho vào túi giặt.\n- Không sử dụng thuốc tẩy hoặc ngâm sản phẩm quá lâu.\n- Phơi ở nơi thoáng mát, tránh ánh nắng mặt trời trực tiếp.\n\nĐiều kiện áp dụng đổi sản phẩm (trong vòng 07 ngày kể từ khi nhận sản phẩm):\n- Hàng hoá còn mới, chưa qua sử dụng, còn nguyên tem mác.\n- Hàng hoá bị lỗi hoặc hư hỏng do vận chuyển hoặc do nhà sản xuất.\n\nLưu ý:\n- Do màn hình và điều kiện ánh sáng khác nhau, màu sắc thực tế của sản phẩm có thể chênh lệch khoảng 3-5%.','SilkySation','Vải Voan Lụa 2 Lớp',600000.00,'ACTIVE',0,0,'2025-11-04 18:11:41'),(222,425,'Quần Legging Gym Nữ','quan-legging-gym-nu','Thông tin sản phẩm Quần Legging Gym Nữ:\r\n- Hàng thiết kế và sản xuất bởi ActiveWear, đảm bảo chất lượng và form dáng.\r\n- Chất liệu: Vải Thun Lạnh 4 Chiều cao cấp, co giãn tối đa, thấm hút mồ hôi, và thân thiện với da.\r\n- Đường may tỉ mỉ, tinh tế, không chỉ thừa, đạt tiêu chuẩn xuất khẩu.\r\n- Phù hợp mặc đi làm, đi chơi, dạo phố hoặc các sự kiện quan trọng.\r\n- Thiết kế Quần Legging Gym Nữ hiện đại, trẻ trung, dễ dàng phối đồ.\r\n\r\nCó đủ các size từ S, M, L, XL, XXL (Vui lòng tham khảo bảng size chi tiết).\r\n\r\nHướng dẫn sử dụng sản phẩm:\r\n- Ưu tiên giặt tay ở nhiệt độ thường để giữ độ bền của Vải Thun Lạnh 4 Chiều.\r\n- Hạn chế giặt máy. Nếu giặt máy, nên lộn trái sản phẩm và cho vào túi giặt.\r\n- Không sử dụng thuốc tẩy hoặc ngâm sản phẩm quá lâu.\r\n- Phơi ở nơi thoáng mát, tránh ánh nắng mặt trời trực tiếp.\r\n\r\nĐiều kiện áp dụng đổi sản phẩm (trong vòng 07 ngày kể từ khi nhận sản phẩm):\r\n- Hàng hoá còn mới, chưa qua sử dụng, còn nguyên tem mác.\r\n- Hàng hoá bị lỗi hoặc hư hỏng do vận chuyển hoặc do nhà sản xuất.\r\n\r\nLưu ý:\r\n- Do màn hình và điều kiện ánh sáng khác nhau, màu sắc thực tế của sản phẩm có thể chênh lệch khoảng 3-5%.','ActiveWear','Vải Thun Lạnh 4 Chiều',310000.00,'ACTIVE',0,0,'2025-11-04 18:11:41'),(223,426,'Quần Short Chạy Bộ 2 Lớp','quan-short-chay-bo-2-lop','Thông tin sản phẩm Quần Short Chạy Bộ 2 Lớp:\n- Hàng thiết kế và sản xuất bởi ActiveWear, đảm bảo chất lượng và form dáng.\n- Chất liệu: Vải Dù Lót Lưới cao cấp, siêu nhẹ, thoáng mát, giữ form, và thân thiện với da.\n- Đường may tỉ mỉ, tinh tế, không chỉ thừa, đạt tiêu chuẩn xuất khẩu.\n- Phù hợp mặc đi làm, đi chơi, dạo phố hoặc các sự kiện quan trọng.\n- Thiết kế Quần Short Chạy Bộ 2 Lớp hiện đại, trẻ trung, dễ dàng phối đồ.\n\nCó đủ các size từ S, M, L, XL, XXL (Vui lòng tham khảo bảng size chi tiết).\n\nHướng dẫn sử dụng sản phẩm:\n- Ưu tiên giặt tay ở nhiệt độ thường để giữ độ bền của Vải Dù Lót Lưới.\n- Hạn chế giặt máy. Nếu giặt máy, nên lộn trái sản phẩm và cho vào túi giặt.\n- Không sử dụng thuốc tẩy hoặc ngâm sản phẩm quá lâu.\n- Phơi ở nơi thoáng mát, tránh ánh nắng mặt trời trực tiếp.\n\nĐiều kiện áp dụng đổi sản phẩm (trong vòng 07 ngày kể từ khi nhận sản phẩm):\n- Hàng hoá còn mới, chưa qua sử dụng, còn nguyên tem mác.\n- Hàng hoá bị lỗi hoặc hư hỏng do vận chuyển hoặc do nhà sản xuất.\n\nLưu ý:\n- Do màn hình và điều kiện ánh sáng khác nhau, màu sắc thực tế của sản phẩm có thể chênh lệch khoảng 3-5%.','ActiveWear','Vải Dù Lót Lưới',260000.00,'ACTIVE',0,0,'2025-11-04 18:11:41'),(224,427,'Đồ Bơi Nữ Một Mảnh','do-boi-nu-mot-manh','Thông tin sản phẩm Đồ Bơi Nữ Một Mảnh:\n- Hàng thiết kế và sản xuất bởi AquaFit, đảm bảo chất lượng và form dáng.\n- Chất liệu: Vải Lycra Bơi Lội cao cấp, co giãn, chống UV, và thân thiện với da.\n- Đường may tỉ mỉ, tinh tế, không chỉ thừa, đạt tiêu chuẩn xuất khẩu.\n- Phù hợp mặc đi làm, đi chơi, dạo phố hoặc các sự kiện quan trọng.\n- Thiết kế Đồ Bơi Nữ Một Mảnh hiện đại, trẻ trung, dễ dàng phối đồ.\n\nCó đủ các size từ S, M, L, XL, XXL (Vui lòng tham khảo bảng size chi tiết).\n\nHướng dẫn sử dụng sản phẩm:\n- Ưu tiên giặt tay ở nhiệt độ thường để giữ độ bền của Vải Lycra Bơi Lội.\n- Hạn chế giặt máy. Nếu giặt máy, nên lộn trái sản phẩm và cho vào túi giặt.\n- Không sử dụng thuốc tẩy hoặc ngâm sản phẩm quá lâu.\n- Phơi ở nơi thoáng mát, tránh ánh nắng mặt trời trực tiếp.\n\nĐiều kiện áp dụng đổi sản phẩm (trong vòng 07 ngày kể từ khi nhận sản phẩm):\n- Hàng hoá còn mới, chưa qua sử dụng, còn nguyên tem mác.\n- Hàng hoá bị lỗi hoặc hư hỏng do vận chuyển hoặc do nhà sản xuất.\n\nLưu ý:\n- Do màn hình và điều kiện ánh sáng khác nhau, màu sắc thực tế của sản phẩm có thể chênh lệch khoảng 3-5%.','AquaFit','Vải Lycra Bơi Lội',450000.00,'ACTIVE',0,0,'2025-11-04 18:11:41'),(225,428,'Áo Khoác Thể Thao Chống Nắng','ao-khoac-the-thao-chong-nang','Thông tin sản phẩm Áo Khoác Thể Thao Chống Nắng:\n- Hàng thiết kế và sản xuất bởi ActiveWear, đảm bảo chất lượng và form dáng.\n- Chất liệu: Vải Thun Lạnh (UPF 50+) cao cấp, thoáng mát, chống tia UV, và thân thiện với da.\n- Đường may tỉ mỉ, tinh tế, không chỉ thừa, đạt tiêu chuẩn xuất khẩu.\n- Phù hợp mặc đi làm, đi chơi, dạo phố hoặc các sự kiện quan trọng.\n- Thiết kế Áo Khoác Thể Thao Chống Nắng hiện đại, trẻ trung, dễ dàng phối đồ.\n\nCó đủ các size từ S, M, L, XL, XXL (Vui lòng tham khảo bảng size chi tiết).\n\nHướng dẫn sử dụng sản phẩm:\n- Ưu tiên giặt tay ở nhiệt độ thường để giữ độ bền của Vải Thun Lạnh (UPF 50+).\n- Hạn chế giặt máy. Nếu giặt máy, nên lộn trái sản phẩm và cho vào túi giặt.\n- Không sử dụng thuốc tẩy hoặc ngâm sản phẩm quá lâu.\n- Phơi ở nơi thoáng mát, tránh ánh nắng mặt trời trực tiếp.\n\nĐiều kiện áp dụng đổi sản phẩm (trong vòng 07 ngày kể từ khi nhận sản phẩm):\n- Hàng hoá còn mới, chưa qua sử dụng, còn nguyên tem mác.\n- Hàng hoá bị lỗi hoặc hư hỏng do vận chuyển hoặc do nhà sản xuất.\n\nLưu ý:\n- Do màn hình và điều kiện ánh sáng khác nhau, màu sắc thực tế của sản phẩm có thể chênh lệch khoảng 3-5%.','ActiveWear','Vải Thun Lạnh (UPF 50+)',300000.00,'ACTIVE',0,0,'2025-11-04 18:11:41'),(226,429,'Áo Khoác Da Lót Lông','ao-khoac-da-lot-long','Thông tin sản phẩm Áo Khoác Da Lót Lông:\n- Hàng thiết kế và sản xuất bởi LeatherLux, đảm bảo chất lượng và form dáng.\n- Chất liệu: Da PU Cao Cấp Lót Lông Cừu cao cấp, siêu ấm, giữ form, và thân thiện với da.\n- Đường may tỉ mỉ, tinh tế, không chỉ thừa, đạt tiêu chuẩn xuất khẩu.\n- Phù hợp mặc đi làm, đi chơi, dạo phố hoặc các sự kiện quan trọng.\n- Thiết kế Áo Khoác Da Lót Lông hiện đại, trẻ trung, dễ dàng phối đồ.\n\nCó đủ các size từ S, M, L, XL, XXL (Vui lòng tham khảo bảng size chi tiết).\n\nHướng dẫn sử dụng sản phẩm:\n- Ưu tiên giặt tay ở nhiệt độ thường để giữ độ bền của Da PU Cao Cấp Lót Lông Cừu.\n- Hạn chế giặt máy. Nếu giặt máy, nên lộn trái sản phẩm và cho vào túi giặt.\n- Không sử dụng thuốc tẩy hoặc ngâm sản phẩm quá lâu.\n- Phơi ở nơi thoáng mát, tránh ánh nắng mặt trời trực tiếp.\n\nĐiều kiện áp dụng đổi sản phẩm (trong vòng 07 ngày kể từ khi nhận sản phẩm):\n- Hàng hoá còn mới, chưa qua sử dụng, còn nguyên tem mác.\n- Hàng hoá bị lỗi hoặc hư hỏng do vận chuyển hoặc do nhà sản xuất.\n\nLưu ý:\n- Do màn hình và điều kiện ánh sáng khác nhau, màu sắc thực tế của sản phẩm có thể chênh lệch khoảng 3-5%.','LeatherLux','Da PU Cao Cấp Lót Lông Cừu',1500000.00,'ACTIVE',0,0,'2025-11-04 18:11:41'),(227,430,'Ví Da Bò Thật','vi-da-bo-that','Thông tin sản phẩm Ví Da Bò Thật:\n- Hàng thiết kế cao cấp bởi LeatherLux.\n- Chất liệu: Da Bò Thật 100% siêu bền, chống mài mòn và chịu lực tốt.\n- Đường may/khóa kéo/mối nối tỉ mỉ, tinh tế, không chi tiết thừa.\n- Thiết kế đa dụng, vừa thời trang vừa tiện lợi, phù hợp cho mọi hoàn cảnh.\n\nHướng dẫn bảo quản sản phẩm:\n- Để sản phẩm ở nơi khô ráo, thoáng mát.\n- Không để sản phẩm tiếp xúc trực tiếp với hóa chất, xà phòng.\n- Vệ sinh sản phẩm bằng khăn ẩm, lau nhẹ nhàng.\n- Tránh phơi trực tiếp dưới ánh nắng mặt trời gắt.\n\nĐiều kiện áp dụng đổi sản phẩm (trong vòng 07 ngày kể từ khi nhận sản phẩm):\n- Hàng hoá còn mới, chưa qua sử dụng, còn nguyên tem mác.\n- Hàng hoá bị lỗi hoặc hư hỏng do vận chuyển hoặc do nhà sản xuất.\n\nLưu ý:\n- Do màn hình và điều kiện ánh sáng khác nhau, màu sắc thực tế của sản phẩm có thể chênh lệch khoảng 3-5%.','LeatherLux','Da Bò Thật 100%',500000.00,'ACTIVE',0,0,'2025-11-04 18:11:41'),(228,431,'Giày Da Nam Công Sở','giay-da-nam-cong-so','Thông tin sản phẩm Giày Da Nam Công Sở:\n- Hàng thiết kế cao cấp bởi Elegante.\n- Chất liệu: Da Bò Nhập Khẩu siêu bền, chống mài mòn và chịu lực tốt.\n- Đường may/khóa kéo/mối nối tỉ mỉ, tinh tế, không chi tiết thừa.\n- Thiết kế đa dụng, vừa thời trang vừa tiện lợi, phù hợp cho mọi hoàn cảnh.\n\nHướng dẫn bảo quản sản phẩm:\n- Để sản phẩm ở nơi khô ráo, thoáng mát.\n- Không để sản phẩm tiếp xúc trực tiếp với hóa chất, xà phòng.\n- Vệ sinh sản phẩm bằng khăn ẩm, lau nhẹ nhàng.\n- Tránh phơi trực tiếp dưới ánh nắng mặt trời gắt.\n\nĐiều kiện áp dụng đổi sản phẩm (trong vòng 07 ngày kể từ khi nhận sản phẩm):\n- Hàng hoá còn mới, chưa qua sử dụng, còn nguyên tem mác.\n- Hàng hoá bị lỗi hoặc hư hỏng do vận chuyển hoặc do nhà sản xuất.\n\nLưu ý:\n- Do màn hình và điều kiện ánh sáng khác nhau, màu sắc thực tế của sản phẩm có thể chênh lệch khoảng 3-5%.','Elegante','Da Bò Nhập Khẩu',1300000.00,'ACTIVE',0,0,'2025-11-04 18:11:41'),(229,432,'Mũ Lưỡi Trai (Nón Kết)','mu-luoi-trai-non-ket','Thông tin sản phẩm Mũ Lưỡi Trai (Nón Kết):\n- Hàng thiết kế cao cấp bởi UrbanFlex.\n- Chất liệu: Vải Kaki Cotton siêu bền, chống mài mòn và chịu lực tốt.\n- Đường may/khóa kéo/mối nối tỉ mỉ, tinh tế, không chi tiết thừa.\n- Thiết kế đa dụng, vừa thời trang vừa tiện lợi, phù hợp cho mọi hoàn cảnh.\n\nHướng dẫn bảo quản sản phẩm:\n- Để sản phẩm ở nơi khô ráo, thoáng mát.\n- Không để sản phẩm tiếp xúc trực tiếp với hóa chất, xà phòng.\n- Vệ sinh sản phẩm bằng khăn ẩm, lau nhẹ nhàng.\n- Tránh phơi trực tiếp dưới ánh nắng mặt trời gắt.\n\nĐiều kiện áp dụng đổi sản phẩm (trong vòng 07 ngày kể từ khi nhận sản phẩm):\n- Hàng hoá còn mới, chưa qua sử dụng, còn nguyên tem mác.\n- Hàng hoá bị lỗi hoặc hư hỏng do vận chuyển hoặc do nhà sản xuất.\n\nLưu ý:\n- Do màn hình và điều kiện ánh sáng khác nhau, màu sắc thực tế của sản phẩm có thể chênh lệch khoảng 3-5%.','UrbanFlex','Vải Kaki Cotton',150000.00,'ACTIVE',0,0,'2025-11-04 18:11:41'),(230,433,'Balo Laptop Chống Nước','balo-laptop-chong-nuoc','Thông tin sản phẩm Balo Laptop Chống Nước:\n- Hàng thiết kế cao cấp bởi PackSafe.\n- Chất liệu: Vải Oxford Chống Thấm siêu bền, chống mài mòn và chịu lực tốt.\n- Đường may/khóa kéo/mối nối tỉ mỉ, tinh tế, không chi tiết thừa.\n- Thiết kế đa dụng, vừa thời trang vừa tiện lợi, phù hợp cho mọi hoàn cảnh.\n\nHướng dẫn bảo quản sản phẩm:\n- Để sản phẩm ở nơi khô ráo, thoáng mát.\n- Không để sản phẩm tiếp xúc trực tiếp với hóa chất, xà phòng.\n- Vệ sinh sản phẩm bằng khăn ẩm, lau nhẹ nhàng.\n- Tránh phơi trực tiếp dưới ánh nắng mặt trời gắt.\n\nĐiều kiện áp dụng đổi sản phẩm (trong vòng 07 ngày kể từ khi nhận sản phẩm):\n- Hàng hoá còn mới, chưa qua sử dụng, còn nguyên tem mác.\n- Hàng hoá bị lỗi hoặc hư hỏng do vận chuyển hoặc do nhà sản xuất.\n\nLưu ý:\n- Do màn hình và điều kiện ánh sáng khác nhau, màu sắc thực tế của sản phẩm có thể chênh lệch khoảng 3-5%.','PackSafe','Vải Oxford Chống Thấm',700000.00,'ACTIVE',0,0,'2025-11-04 18:11:41'),(231,434,'Kính Mát Gọng Tròn','kinh-mat-gong-tron','Thông tin sản phẩm Kính Mát Gọng Tròn:\n- Hàng thiết kế cao cấp bởi SunShade.\n- Chất liệu: Gọng Hợp Kim & Tròng Kính Polarized siêu bền, chống UV400, và chịu lực tốt.\n- Đường may/khóa kéo/mối nối tỉ mỉ, tinh tế, không chi tiết thừa.\n- Thiết kế đa dụng, vừa thời trang vừa tiện lợi, phù hợp cho mọi hoàn cảnh.\n\nHướng dẫn bảo quản sản phẩm:\n- Để sản phẩm ở nơi khô ráo, thoáng mát.\n- Không để sản phẩm tiếp xúc trực tiếp với hóa chất, xà phòng.\n- Vệ sinh sản phẩm bằng khăn ẩm, lau nhẹ nhàng.\n- Tránh phơi trực tiếp dưới ánh nắng mặt trời gắt.\n\nĐiều kiện áp dụng đổi sản phẩm (trong vòng 07 ngày kể từ khi nhận sản phẩm):\n- Hàng hoá còn mới, chưa qua sử dụng, còn nguyên tem mác.\n- Hàng hoá bị lỗi hoặc hư hỏng do vận chuyển hoặc do nhà sản xuất.\n\nLưu ý:\n- Do màn hình và điều kiện ánh sáng khác nhau, màu sắc thực tế của sản phẩm có thể chênh lệch khoảng 3-5%.','SunShade','Gọng Hợp Kim & Tròng Kính Polarized',350000.00,'ACTIVE',0,0,'2025-11-04 18:11:41'),(232,435,'Tất Cổ Cao (Vớ)','tat-co-cao-vo','Thông tin sản phẩm Tất Cổ Cao (Vớ):\r\n- Hàng thiết kế cao cấp bởi CozyWear.\r\n- Chất liệu: Cotton 100% siêu bền, thoáng khí, khử mùi và chịu lực tốt.\r\n- Đường may/khóa kéo/mối nối tỉ mỉ, tinh tế, không chi tiết thừa.\r\n- Thiết kế đa dụng, vừa thời trang vừa tiện lợi, phù hợp cho mọi hoàn cảnh.\r\n\r\nHướng dẫn bảo quản sản phẩm:\r\n- Để sản phẩm ở nơi khô ráo, thoáng mát.\r\n- Không để sản phẩm tiếp xúc trực tiếp với hóa chất, xà phòng.\r\n- Vệ sinh sản phẩm bằng khăn ẩm, lau nhẹ nhàng.\r\n- Tránh phơi trực tiếp dưới ánh nắng mặt trời gắt.\r\n\r\nĐiều kiện áp dụng đổi sản phẩm (trong vòng 07 ngày kể từ khi nhận sản phẩm):\r\n- Hàng hoá còn mới, chưa qua sử dụng, còn nguyên tem mác.\r\n- Hàng hoá bị lỗi hoặc hư hỏng do vận chuyển hoặc do nhà sản xuất.\r\n\r\nLưu ý:\r\n- Do màn hình và điều kiện ánh sáng khác nhau, màu sắc thực tế của sản phẩm có thể chênh lệch khoảng 3-5%.','CozyWear','Cotton 100%',50000.00,'ACTIVE',0,0,'2025-11-04 18:11:41'),(233,436,'Thắt Lưng Da Nam','that-lung-da-nam','Thông tin sản phẩm Thắt Lưng Da Nam:\r\n- Hàng thiết kế cao cấp bởi GentleWear.\r\n- Chất liệu: Da Bò Cao Cấp siêu bền, chống mài mòn và chịu lực tốt.\r\n- Đường may/khóa kéo/mối nối tỉ mỉ, tinh tế, không chi tiết thừa.\r\n- Thiết kế đa dụng, vừa thời trang vừa tiện lợi, phù hợp cho mọi hoàn cảnh.\r\n\r\nHướng dẫn bảo quản sản phẩm:\r\n- Để sản phẩm ở nơi khô ráo, thoáng mát.\r\n- Không để sản phẩm tiếp xúc trực tiếp với hóa chất, xà phòng.\r\n- Vệ sinh sản phẩm bằng khăn ẩm, lau nhẹ nhàng.\r\n- Tránh phơi trực tiếp dưới ánh nắng mặt trời gắt.\r\n\r\nĐiều kiện áp dụng đổi sản phẩm (trong vòng 07 ngày kể từ khi nhận sản phẩm):\r\n- Hàng hoá còn mới, chưa qua sử dụng, còn nguyên tem mác.\r\n- Hàng hoá bị lỗi hoặc hư hỏng do vận chuyển hoặc do nhà sản xuất.\r\n\r\nLưu ý:\r\n- Do màn hình và điều kiện ánh sáng khác nhau, màu sắc thực tế của sản phẩm có thể chênh lệch khoảng 3-5%.','GentleWear','Da Bò Cao Cấp',400000.00,'ACTIVE',0,0,'2025-11-04 18:11:41'),(249,409,'Áo Thun Nữ Form Rộng1','ao-thun-nu-form-rong1','aaaa','aaaa','aaaa',1000000.00,'ACTIVE',0,0,'2025-11-22 20:29:58'),(250,415,'Áo Thun Nữ Form Rộngs','ao-thun-nu-form-rongs','bbbb','bbbbb','bbbb',100000.00,'ACTIVE',0,0,'2025-11-22 20:36:52'),(251,439,'Quần Kaki Nam Dáng Slims','quan-kaki-nam-dang-slims','ffff','DivaStyle','fffff',100000.00,'ACTIVE',0,0,'2025-11-22 20:41:46'),(253,446,'áo nam mùa đông 1','ao-nam-mua-dong-1','aaaaaaaaaaaa','DivaStyle','Cotton 100% 2 chiều',100000.00,'ACTIVE',0,0,'2025-11-27 08:36:36');
/*!40000 ALTER TABLE `sanpham` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sizechart`
--

DROP TABLE IF EXISTS `sizechart`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sizechart` (
  `SizeChartID` int NOT NULL AUTO_INCREMENT,
  `DanhMucID` int DEFAULT NULL,
  `MoTa` text COLLATE utf8mb4_general_ci,
  PRIMARY KEY (`SizeChartID`),
  KEY `DanhMucID` (`DanhMucID`),
  CONSTRAINT `sizechart_ibfk_1` FOREIGN KEY (`DanhMucID`) REFERENCES `danhmuc` (`DanhMucID`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sizechart`
--

LOCK TABLES `sizechart` WRITE;
/*!40000 ALTER TABLE `sizechart` DISABLE KEYS */;
INSERT INTO `sizechart` VALUES (1,435,'{\"type\":\"freesize\",\"content\":\"Sản phẩm này là Freesize, phù hợp với mọi kích cỡ.\"}'),(2,406,'{\"headers\":[\"Size\",\"Chiều cao (cm)\",\"Cân nặng (kg)\",\"Dài áo (cm)\",\"Rộng ngực (cm)\"],\"rows\":[[\"S\",\"1.60-1.65\",\"50-58\",\"66\",\"48\"],[\"M\",\"1.66-1.70\",\"59-68\",\"68\",\"50\"],[\"L\",\"1.71-1.75\",\"69-76\",\"70\",\"52\"],[\"XL\",\"1.76-1.80\",\"77-85\",\"72\",\"54\"],[\"XXL\",\">1.80\",\">85\",\"74\",\"56\"]]}'),(3,436,'{\"headers\":[\"Size\"],\"rows\":[[\"Freesize (phù hợp với mọi size)\"]]}'),(4,430,'{\"headers\":[\"Size\"],\"rows\":[[\"Freesize\"]]}'),(5,431,'{\"headers\":[\"Size\",\"Dài chn (cm)\"],\"rows\":[[\"S\",\"18-20\"]]}'),(6,433,'{\"headers\":[\"Size\",\"Chiều cao (cm)\",\"Cân nặng (kg)\"],\"rows\":[[\"S\",\"150 - 160\",\"45 - 55\"],[\"M\",\"160 - 170\",\"55 - 65\"],[\"L\",\"170 - 175\",\"65 - 75\"],[\"XL\",\"175 - 180\",\"75 - 85\"]]}'),(9,446,'{\"headers\":[\"Size\",\"Chiều cao (cm)\",\"Cân nặng (kg)\"],\"rows\":[[\"S\",\"150 - 160\",\"45 - 55\"],[\"M\",\"160 - 170\",\"55 - 65\"],[\"L\",\"170 - 175\",\"65 - 75\"],[\"XL\",\"175 - 180\",\"75 - 85\"]]}');
/*!40000 ALTER TABLE `sizechart` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `thanhtoan`
--

DROP TABLE IF EXISTS `thanhtoan`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `thanhtoan` (
  `ThanhToanID` int NOT NULL AUTO_INCREMENT,
  `DonHangID` int NOT NULL,
  `MethodID` int NOT NULL,
  `SoTienThanhToan` decimal(10,2) NOT NULL,
  `NgayThanhToan` datetime DEFAULT CURRENT_TIMESTAMP,
  `TrangThai` enum('PENDING','SUCCESS','FAILED') COLLATE utf8mb4_general_ci NOT NULL,
  `MaGiaoDich` varchar(100) COLLATE utf8mb4_general_ci DEFAULT NULL,
  PRIMARY KEY (`ThanhToanID`),
  UNIQUE KEY `DonHangID` (`DonHangID`),
  KEY `MethodID` (`MethodID`),
  CONSTRAINT `thanhtoan_ibfk_1` FOREIGN KEY (`DonHangID`) REFERENCES `donhang` (`DonHangID`) ON DELETE CASCADE,
  CONSTRAINT `thanhtoan_ibfk_2` FOREIGN KEY (`MethodID`) REFERENCES `paymentmethods` (`MethodID`),
  CONSTRAINT `thanhtoan_chk_1` CHECK ((`SoTienThanhToan` >= 0))
) ENGINE=InnoDB AUTO_INCREMENT=44 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `thanhtoan`
--

LOCK TABLES `thanhtoan` WRITE;
/*!40000 ALTER TABLE `thanhtoan` DISABLE KEYS */;
/*!40000 ALTER TABLE `thanhtoan` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `thuoctinh`
--

DROP TABLE IF EXISTS `thuoctinh`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `thuoctinh` (
  `ThuocTinhID` int NOT NULL AUTO_INCREMENT,
  `TenThuocTinh` varchar(50) COLLATE utf8mb4_general_ci NOT NULL,
  `Slug` varchar(200) COLLATE utf8mb4_general_ci NOT NULL,
  PRIMARY KEY (`ThuocTinhID`),
  UNIQUE KEY `TenThuocTinh` (`TenThuocTinh`)
) ENGINE=InnoDB AUTO_INCREMENT=306 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `thuoctinh`
--

LOCK TABLES `thuoctinh` WRITE;
/*!40000 ALTER TABLE `thuoctinh` DISABLE KEYS */;
INSERT INTO `thuoctinh` VALUES (301,'Kích Cỡ','kich-co'),(302,'Màu Sắc','mau-sac'),(303,'Kích Cỡ Giày','kich-co-giay'),(304,'Kích Cỡ Thắt Lưng','kich-co-that-lung'),(305,'Kích Cỡ Chung','kich-co-chung');
/*!40000 ALTER TABLE `thuoctinh` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `yeuthich`
--

DROP TABLE IF EXISTS `yeuthich`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `yeuthich` (
  `NguoiDungID` int NOT NULL,
  `PhienBanID` int NOT NULL,
  `NgayThem` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`NguoiDungID`,`PhienBanID`),
  KEY `PhienBanID` (`PhienBanID`),
  CONSTRAINT `yeuthich_ibfk_1` FOREIGN KEY (`NguoiDungID`) REFERENCES `nguoidung` (`NguoiDungID`) ON DELETE CASCADE,
  CONSTRAINT `yeuthich_ibfk_2` FOREIGN KEY (`PhienBanID`) REFERENCES `phienbansanpham` (`PhienBanID`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `yeuthich`
--

LOCK TABLES `yeuthich` WRITE;
/*!40000 ALTER TABLE `yeuthich` DISABLE KEYS */;
/*!40000 ALTER TABLE `yeuthich` ENABLE KEYS */;
UNLOCK TABLES;
SET @@SESSION.SQL_LOG_BIN = @MYSQLDUMP_TEMP_LOG_BIN;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-12-10  9:21:35
