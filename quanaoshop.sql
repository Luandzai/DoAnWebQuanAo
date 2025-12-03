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

SET @@GLOBAL.GTID_PURGED=/*!80000 '+'*/ '2a0babbd-b023-11f0-8e80-005056c00001:1-1288';

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
) ENGINE=InnoDB AUTO_INCREMENT=49 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `chitietdonhang`
--

LOCK TABLES `chitietdonhang` WRITE;
/*!40000 ALTER TABLE `chitietdonhang` DISABLE KEYS */;
INSERT INTO `chitietdonhang` VALUES (3,1002,5001,1,99000.00),(4,1003,5002,1,99000.00),(5,1003,5003,1,399000.00),(6,1004,5001,1,99000.00),(7,1005,5003,1,399000.00),(8,1006,5001,1,99000.00),(9,1007,5003,1,399000.00),(10,1008,5002,3,99000.00),(11,1009,5026,1,270000.00),(12,1010,5003,1,399000.00),(13,1011,5026,1,270000.00),(14,1012,5026,1,270000.00),(15,1013,5026,1,270000.00),(16,1014,5001,1,99000.00),(17,1015,5003,1,399000.00),(18,1016,5001,1,99000.00),(19,1017,5004,1,180000.00),(20,1018,5001,1,99000.00),(21,1019,5003,1,399000.00),(22,1020,5006,1,270000.00),(23,1021,5006,1,270000.00),(24,1022,5012,1,378000.00),(25,1023,5049,1,380000.00),(26,1024,5013,1,198000.00),(27,1025,5005,1,360000.00),(28,1026,5013,1,198000.00),(29,1026,5014,1,324000.00),(30,1027,5003,1,399000.00),(31,1027,5004,1,180000.00),(32,1027,5026,1,270000.00),(33,1028,5010,1,225000.00),(34,1029,5007,1,450000.00),(35,1029,5016,1,432000.00),(36,1030,5004,1,180000.00),(37,1031,5010,1,225000.00),(38,1032,5004,1,180000.00),(39,1033,5003,1,399000.00),(40,1033,5005,1,360000.00),(41,1033,5033,10,45000.00),(42,1034,5002,1,99000.00),(43,1035,5001,1,99000.00),(44,1035,5003,1,399000.00),(45,1035,5061,1,100000.00),(46,1036,5001,1,99000.00),(47,1036,5003,1,399000.00),(48,1036,5061,1,100000.00);
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
INSERT INTO `chitietgiohang` VALUES (4,5003,1),(4,5004,1),(4,5007,1),(4,5066,1),(4,5067,1),(6,5001,3),(9,5003,1),(9,5023,1),(19,5002,2);
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
INSERT INTO `chitietreturns` VALUES (4,5003,1,399000.00),(10,5001,1,99000.00),(11,5003,1,399000.00),(12,5006,1,270000.00),(13,5012,1,378000.00),(14,5049,1,380000.00),(15,5026,1,270000.00),(16,5002,1,99000.00);
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
INSERT INTO `danhgia` VALUES (3,5001,6,5,'Áo đẹp','https://res.cloudinary.com/ddawh25f0/image/upload/v1762348064/reviews/images/gjemzpmym3pjvm2enrxv.jpg','reviews/images/gjemzpmym3pjvm2enrxv',NULL,NULL,'2025-11-04 00:49:36',NULL,NULL,NULL),(5,5003,5,5,'Quần đẹp',NULL,NULL,NULL,NULL,'2025-11-05 19:38:37',NULL,NULL,NULL),(6,5003,6,5,'Quần đẹp và chắc chắn',NULL,NULL,'https://res.cloudinary.com/ddawh25f0/video/upload/v1762358590/reviews/videos/f0kidsozgqpnrys5us4k.mp4','reviews/videos/f0kidsozgqpnrys5us4k','2025-11-05 23:03:12',NULL,NULL,NULL),(8,5016,4,5,'a','https://res.cloudinary.com/ddawh25f0/image/upload/v1762967711/reviews/images/is249pyatxp5kq16ajpa.png','reviews/images/is249pyatxp5kq16ajpa',NULL,NULL,'2025-11-13 00:15:10',NULL,NULL,NULL),(9,5007,4,5,'a','https://res.cloudinary.com/duvldvygz/image/upload/v1763816444/reviews/images/mmlbbbtomyjicl2gtsco.jpg','reviews/images/mmlbbbtomyjicl2gtsco','https://res.cloudinary.com/ddawh25f0/video/upload/v1763818818/reviews/videos/totv01ihrfniokzmbqwh.mp4','reviews/videos/totv01ihrfniokzmbqwh','2025-11-22 19:55:55','2025-11-22 20:40:16',NULL,NULL),(10,5003,4,5,'a',NULL,NULL,'https://res.cloudinary.com/ddawh25f0/video/upload/v1763818865/reviews/videos/j9tht5ah1qxebzueosxc.mp4','reviews/videos/j9tht5ah1qxebzueosxc','2025-11-22 20:41:04',NULL,NULL,NULL),(11,5002,17,5,'aaaaaaaaaaa','https://res.cloudinary.com/ddawh25f0/image/upload/v1764210817/reviews/images/r7stjux1ovyzrbyk9xsw.webp','reviews/images/r7stjux1ovyzrbyk9xsw',NULL,NULL,'2025-11-27 09:33:38',NULL,NULL,NULL);
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
) ENGINE=InnoDB AUTO_INCREMENT=139 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `diachigiaohang`
--

LOCK TABLES `diachigiaohang` WRITE;
/*!40000 ALTER TABLE `diachigiaohang` DISABLE KEYS */;
INSERT INTO `diachigiaohang` VALUES (102,6,'Trương Văn Nghị','0834576312','11 Đ.Nam Cao, phường Tân Phú, quận 9, Thành phố Hồ Chí Minh','default','default','default',0),(103,6,'Trương Văn Nghị','0834576312','11 Đ.Nam Cao','default','default','default',0),(104,6,'Trương Văn Nghị','0834576312','11 Đ.Xuân Diệp','default','default','default',0),(105,6,'Trương Văn Nghị','0834576312','11 Đ.Nam Cao, Phường Tân Phú, Quận 9, Hồ Chí Minh','Phường Tân Phú','Quận 9','Hồ Chí Minh',0),(106,5,'Trương Văn Hửu','0944089720','11 Đ.Nam Cao, Thị trấn Thứa, Huyện Lương Tài, Bắc Ninh','Thị trấn Thứa','Huyện Lương Tài','Bắc Ninh',0),(107,5,'Trương Văn Hửu','0944089720','11 Đ.Nam Cao, Xã Xà Phiên, Huyện Long Mỹ, Hậu Giang','Xã Xà Phiên','Huyện Long Mỹ','Hậu Giang',0),(108,5,'Trương Văn Hửu','0944089720','11 Đ.Nam Cao, Xã Viên An Đông, Huyện Ngọc Hiển, Cà Mau','Xã Viên An Đông','Huyện Ngọc Hiển','Cà Mau',0),(109,5,'Trương Văn Hửu','0944089720','11 Đ.Nam Cao, Phường Tân Phú, Thành Phố Thủ Đức, Hồ Chí Minh','Phường Tân Phú','Thành Phố Thủ Đức','Hồ Chí Minh',0),(110,7,'1348_Trương Văn Hửu','0944089720','11 Đ.Nam Cao, Thị trấn Thứa, Huyện Lương Tài, Bắc Ninh','Thị trấn Thứa','Huyện Lương Tài','Bắc Ninh',0),(111,10,'Ton Duy Truong','1234567890','123 linh đông, Phường Hiệp Phú, Thành Phố Thủ Đức, Hồ Chí Minh','Phường Hiệp Phú','Thành Phố Thủ Đức','Hồ Chí Minh',0),(112,4,'Tô Trần Luân','1234567890','234, Phường Phượng Sơn, Thị xã Chũ, Bắc Giang','Phường Phượng Sơn','Thị xã Chũ','Bắc Giang',0),(113,10,'Ton Duy Truong','1234567890','1234, Xã Nghĩa Hồ, Huyện Lục Ngạn, Bắc Giang','Xã Nghĩa Hồ','Huyện Lục Ngạn','Bắc Giang',0),(114,10,'Ton Duy Truong','1234567890','234, Xã Nam Dương, Thị xã Chũ, Bắc Giang','Xã Nam Dương','Thị xã Chũ','Bắc Giang',0),(115,10,'Ton Duy Truong','1234567890','1234, Xã Khánh Tiến, Huyện U Minh, Cà Mau','Xã Khánh Tiến','Huyện U Minh','Cà Mau',0),(116,10,'Ton Duy Truong','1234567890','123, Xã Hồng Thái, Huyện Văn Lãng, Lạng Sơn','Xã Hồng Thái','Huyện Văn Lãng','Lạng Sơn',0),(117,9,'minh kha','1234567890','123, Xã Khánh Tiến, Huyện U Minh, Cà Mau','Xã Khánh Tiến','Huyện U Minh','Cà Mau',0),(118,12,'Nguyen Le Trong Phuc','1234567890','1234, Xã Vĩnh Viễn A, Huyện Long Mỹ, Hậu Giang','Xã Vĩnh Viễn A','Huyện Long Mỹ','Hậu Giang',0),(119,12,'Nguyen Le Trong Phuc','1234567890','12334, Xã Sơn Thành Đông, Huyện Tây Hòa, Phú Yên','Xã Sơn Thành Đông','Huyện Tây Hòa','Phú Yên',0),(120,12,'Nguyen Le Trong Phuc','1234567890','123, Xã An Thịnh, Huyện Lương Tài, Bắc Ninh','Xã An Thịnh','Huyện Lương Tài','Bắc Ninh',0),(121,12,'Nguyen Le Trong Phuc','1234567890','123, Xã Long Trị, Thị xã Long Mỹ, Hậu Giang','Xã Long Trị','Thị xã Long Mỹ','Hậu Giang',0),(122,12,'Nguyen Le Trong Phuc','1234567890','123, Xã Phước Long, Huyện Phước Long, Bạc Liêu','Xã Phước Long','Huyện Phước Long','Bạc Liêu',0),(123,12,'Nguyen Le Trong Phuc','1234567890','123, Xã Phong Thạnh, Thị Xã Giá Rai, Bạc Liêu','Xã Phong Thạnh','Thị Xã Giá Rai','Bạc Liêu',0),(124,4,'Quản Trị Viên','1234567890','123, Xã Hòa Thành, Thị xã Đông Hòa, Phú Yên','Xã Hòa Thành','Thị xã Đông Hòa','Phú Yên',0),(125,4,'Quản Trị Viên','1234567890','1, Xã Gia Đông, Thị xã Thuận Thành, Bắc Ninh','Xã Gia Đông','Thị xã Thuận Thành','Bắc Ninh',0),(126,4,'Quản Trị Viên','1234567890','123, Xã Ya ly, Huyện Sa Thầy, Kon Tum','Xã Ya ly','Huyện Sa Thầy','Kon Tum',0),(127,4,'Quản Trị Viên','1234567890','123, Xã Sa Sơn, Huyện Sa Thầy, Kon Tum','Xã Sa Sơn','Huyện Sa Thầy','Kon Tum',0),(128,4,'Quản Trị Viên','1234567890','123, Xã Long Bình, Thị xã Long Mỹ, Hậu Giang','Xã Long Bình','Thị xã Long Mỹ','Hậu Giang',0),(129,4,'Quản Trị Viên','1234567890','123, Xã Song Giang, Huyện Gia Bình, Bắc Ninh','Xã Song Giang','Huyện Gia Bình','Bắc Ninh',0),(130,4,'Quản Trị Viên','1234567890','123, Xã Phước Thắng, Huyện Bác Ái, Ninh Thuận','Xã Phước Thắng','Huyện Bác Ái','Ninh Thuận',0),(131,4,'Quản Trị Viên','1234567890','123, Xã Bờ Y, Huyện Ngọc Hồi, Kon Tum','Xã Bờ Y','Huyện Ngọc Hồi','Kon Tum',0),(132,4,'Quản Trị Viên','1234567890','123, Xã Đắk Nông, Huyện Ngọc Hồi, Kon Tum','Xã Đắk Nông','Huyện Ngọc Hồi','Kon Tum',0),(133,4,'Quản Trị Viên','1234567890','123, Xã Đắk Nông, Huyện Ngọc Hồi, Kon Tum','Xã Đắk Nông','Huyện Ngọc Hồi','Kon Tum',0),(134,4,'Quản Trị Viên','1234567890','123, Xã Vĩnh Phú Tây, Huyện Phước Long, Bạc Liêu','Xã Vĩnh Phú Tây','Huyện Phước Long','Bạc Liêu',0),(135,4,'Quản Trị Viên','1234567890','1223, Xã Ngũ Phụng, Huyện đảo Phú Quý, Bình Thuận','Xã Ngũ Phụng','Huyện đảo Phú Quý','Bình Thuận',0),(136,17,'Hung','1234567890','123, Xã Khánh Thuận, Huyện U Minh, Cà Mau','Xã Khánh Thuận','Huyện U Minh','Cà Mau',0),(137,17,'Hung','1234567890','123 linh đông, Xã Vĩnh Viễn, Huyện Long Mỹ, Hậu Giang','Xã Vĩnh Viễn','Huyện Long Mỹ','Hậu Giang',0),(138,17,'Hung','1234567890','123 linh đông, Xã Vĩnh Viễn, Huyện Long Mỹ, Hậu Giang','Xã Vĩnh Viễn','Huyện Long Mỹ','Hậu Giang',0);
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
) ENGINE=InnoDB AUTO_INCREMENT=1037 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `donhang`
--

LOCK TABLES `donhang` WRITE;
/*!40000 ALTER TABLE `donhang` DISABLE KEYS */;
INSERT INTO `donhang` VALUES (1002,6,102,NULL,601,'2025-11-02 20:13:11',99000.00,0.00,99000.00,'DA_HUY','Giao hàng nhanh nhé',NULL,NULL),(1003,6,103,NULL,601,'2025-11-02 23:39:57',498000.00,0.00,498000.00,'DA_GIAO','Giao hàng cẩn thận',NULL,NULL),(1004,6,104,NULL,601,'2025-11-03 00:50:41',99000.00,0.00,99000.00,'DA_GIAO','Hello',NULL,NULL),(1005,6,105,'FREE30K',601,'2025-11-03 02:24:47',399000.00,30000.00,399000.00,'DA_GIAO','HeHe','2025-11-08 20:55:40',4),(1006,5,106,NULL,602,'2025-11-03 17:14:26',99000.00,50000.00,149000.00,'DA_GIAO','Giao hàng nhanh',NULL,NULL),(1007,5,107,'FREE30K',601,'2025-11-03 18:08:23',399000.00,30000.00,399000.00,'DA_GIAO','HiHIU',NULL,NULL),(1008,5,108,NULL,601,'2025-11-03 20:34:01',297000.00,30000.00,327000.00,'DA_GIAO','Chào',NULL,NULL),(1009,5,109,NULL,601,'2025-11-05 15:44:19',270000.00,30000.00,300000.00,'DA_GIAO','Giao hàng nhanh nhé',NULL,NULL),(1010,7,110,'FREE30K',601,'2025-11-06 00:53:41',399000.00,30000.00,399000.00,'DA_HUY','Giao hàng nhanh giúp tôi',NULL,NULL),(1011,10,111,NULL,601,'2025-11-08 02:39:04',270000.00,30000.00,300000.00,'DA_HUY','',NULL,NULL),(1012,4,112,NULL,601,'2025-11-08 08:02:36',270000.00,30000.00,300000.00,'DOI_TRA','','2025-11-09 19:43:08',4),(1013,10,113,NULL,601,'2025-11-08 09:43:31',270000.00,30000.00,300000.00,'DA_GIAO','',NULL,NULL),(1014,10,114,NULL,601,'2025-11-08 10:29:36',99000.00,30000.00,129000.00,'DA_HUY','',NULL,NULL),(1015,10,115,NULL,601,'2025-11-08 10:30:15',399000.00,30000.00,429000.00,'DA_GIAO','',NULL,NULL),(1016,10,116,NULL,601,'2025-11-08 17:25:20',99000.00,30000.00,129000.00,'DA_GIAO','',NULL,NULL),(1017,9,117,NULL,601,'2025-11-08 18:50:15',180000.00,30000.00,210000.00,'DA_HUY','',NULL,NULL),(1018,12,118,NULL,601,'2025-11-08 19:58:16',99000.00,30000.00,129000.00,'DOI_TRA','','2025-11-08 21:29:16',12),(1019,12,119,NULL,601,'2025-11-08 21:06:21',399000.00,30000.00,429000.00,'DA_GIAO','','2025-11-08 21:30:07',4),(1020,12,120,NULL,601,'2025-11-08 21:17:02',270000.00,30000.00,300000.00,'DOI_TRA','','2025-11-08 21:17:52',12),(1021,12,121,NULL,601,'2025-11-09 17:35:23',270000.00,30000.00,300000.00,'DOI_TRA','','2025-11-09 17:35:49',12),(1022,12,122,NULL,601,'2025-11-09 17:43:44',378000.00,30000.00,408000.00,'DOI_TRA','','2025-11-09 17:44:08',12),(1023,12,123,NULL,601,'2025-11-09 17:46:27',380000.00,30000.00,410000.00,'DOI_TRA','','2025-11-09 17:46:49',12),(1024,4,124,'50K',601,'2025-11-09 18:12:34',198000.00,30000.00,178000.00,'DA_HUY','',NULL,NULL),(1025,4,125,'hehe',601,'2025-11-09 19:32:04',360000.00,30000.00,370000.00,'DA_GIAO','',NULL,NULL),(1026,4,126,'lala',601,'2025-11-12 23:04:46',522000.00,30000.00,542000.00,'DA_GIAO','',NULL,NULL),(1027,4,128,NULL,601,'2025-11-12 23:34:19',849000.00,30000.00,879000.00,'DA_GIAO','',NULL,NULL),(1028,4,129,NULL,601,'2025-11-12 23:39:31',225000.00,30000.00,255000.00,'DA_GIAO','',NULL,NULL),(1029,4,130,NULL,601,'2025-11-12 23:41:16',882000.00,30000.00,912000.00,'DA_GIAO','',NULL,NULL),(1030,4,131,NULL,601,'2025-11-14 18:59:26',180000.00,30000.00,210000.00,'DANG_XU_LY','',NULL,NULL),(1031,4,133,NULL,601,'2025-11-14 19:06:42',225000.00,30000.00,255000.00,'DANG_XU_LY','',NULL,NULL),(1032,4,134,NULL,601,'2025-11-21 13:57:11',180000.00,30000.00,210000.00,'DA_HUY','',NULL,NULL),(1033,4,135,'FREE30K',601,'2025-11-22 12:58:55',1209000.00,30000.00,1209000.00,'DANG_XU_LY','',NULL,NULL),(1034,17,136,NULL,601,'2025-11-22 21:01:55',99000.00,30000.00,129000.00,'DOI_TRA','','2025-11-27 09:34:03',17),(1035,17,137,NULL,601,'2025-12-03 17:11:16',598000.00,30000.00,628000.00,'CHUA_THANH_TOAN','',NULL,NULL),(1036,17,138,NULL,601,'2025-12-03 17:11:38',598000.00,30000.00,628000.00,'CHUA_THANH_TOAN','',NULL,NULL);
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
INSERT INTO `giohang` VALUES (4,'2025-11-08 06:28:21','2025-11-08 06:28:21'),(5,'2025-11-03 17:13:32','2025-11-03 17:13:32'),(6,'2025-11-02 19:45:36','2025-11-02 19:45:36'),(7,'2025-11-06 00:50:41','2025-11-06 00:50:41'),(9,'2025-11-06 15:04:15','2025-11-06 15:04:15'),(10,'2025-11-08 02:38:10','2025-11-08 02:38:10'),(12,'2025-11-08 19:57:57','2025-11-08 19:57:57'),(17,'2025-11-22 21:00:29','2025-11-22 21:00:29'),(19,'2025-11-24 08:10:10','2025-11-24 08:10:10');
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
INSERT INTO `khuyenmai` VALUES ('50K','Giảm giá 11/11','SOTIEN',50000.00,0.00,NULL,212,'2025-11-08 07:00:00','2025-11-12 07:00:00',9,'ACTIVE'),('aaaa','aaaa','SOTIEN',1000.00,0.00,NULL,202,'2025-11-22 07:00:00','2025-11-30 07:00:00',10,'ACTIVE'),('aaaaaaaaaaaaaaa','aaaa','SOTIEN',10000.00,0.00,NULL,251,'2025-11-24 07:00:00','2025-11-28 07:00:00',0,'ACTIVE'),('FREE30K','Giảm 30K cho đơn hàng đầu','SOTIEN',30000.00,200000.00,411,202,'2025-11-01 15:40:00','2026-12-31 23:59:59',97,'ACTIVE'),('hehe','hohoh','SOTIEN',20000.00,0.00,NULL,202,'2025-11-09 07:00:00','2025-11-11 07:00:00',0,'ACTIVE'),('hehe1','hehe1','SOTIEN',10000.00,0.00,NULL,212,'2025-11-07 07:00:00','2025-11-15 07:00:00',1,'ACTIVE'),('lala','lele','SOTIEN',10000.00,0.00,NULL,213,'2025-11-12 07:00:00','2025-11-14 07:00:00',0,'ACTIVE');
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
) ENGINE=InnoDB AUTO_INCREMENT=154 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `lichsudonhang`
--

LOCK TABLES `lichsudonhang` WRITE;
/*!40000 ALTER TABLE `lichsudonhang` DISABLE KEYS */;
INSERT INTO `lichsudonhang` VALUES (2,1002,'DANG_XU_LY','DA_HUY','2025-11-03 00:29:00','Trạng thái được cập nhật tự động.'),(3,1003,'DANG_XU_LY','DA_HUY','2025-11-03 00:35:42','Trạng thái được cập nhật tự động.'),(4,1004,'DANG_XU_LY','DA_HUY','2025-11-03 00:51:02','Trạng thái được cập nhật tự động.'),(5,1005,'DANG_XU_LY','DA_HUY','2025-11-03 02:27:48','Trạng thái được cập nhật tự động.'),(6,1007,'DANG_XU_LY','DA_HUY','2025-11-03 18:14:15','Trạng thái được cập nhật tự động.'),(7,1006,'DANG_XU_LY','DA_GIAO','2025-11-03 20:36:54','Trạng thái được cập nhật tự động.'),(8,1007,'DA_HUY','DA_GIAO','2025-11-03 20:37:26','Trạng thái được cập nhật tự động.'),(9,1008,'DANG_XU_LY','DA_GIAO','2025-11-03 20:37:48','Trạng thái được cập nhật tự động.'),(10,1005,'DA_HUY','DANG_XU_LY','2025-11-03 23:10:37','Trạng thái được cập nhật tự động.'),(11,1005,'DANG_XU_LY','DANG_GIAO','2025-11-03 23:11:24','Trạng thái được cập nhật tự động.'),(12,1003,'DA_HUY','DA_GIAO','2025-11-04 00:46:01','Trạng thái được cập nhật tự động.'),(13,1004,'DA_HUY','DA_GIAO','2025-11-04 00:46:10','Trạng thái được cập nhật tự động.'),(14,1005,'DANG_GIAO','DA_GIAO','2025-11-04 02:33:04','Trạng thái được cập nhật tự động.'),(18,1011,'DANG_XU_LY','DA_HUY','2025-11-08 06:55:38','Trạng thái được cập nhật tự động.'),(19,1010,'DANG_XU_LY','DANG_GIAO','2025-11-08 07:08:10','Trạng thái được cập nhật tự động.'),(20,1009,'DANG_XU_LY','DA_GIAO','2025-11-08 07:08:19','Trạng thái được cập nhật tự động.'),(26,1010,'DANG_GIAO','DANG_XU_LY','2025-11-08 07:15:45','Trạng thái được cập nhật tự động.'),(27,1010,'DANG_XU_LY','DANG_GIAO','2025-11-08 07:15:48','Trạng thái được cập nhật tự động.'),(46,1012,'DANG_XU_LY','DANG_GIAO','2025-11-08 08:03:04','Trạng thái được cập nhật tự động.'),(47,1012,'DANG_XU_LY','DANG_GIAO','2025-11-08 08:03:04','Đơn hàng được chuyển từ trạng thái DANG_XU_LY sang DANG_GIAO'),(49,1012,'DANG_GIAO','DA_GIAO','2025-11-08 08:03:19','Trạng thái được cập nhật tự động.'),(50,1012,'DANG_GIAO','DA_GIAO','2025-11-08 08:03:19','Đơn hàng được chuyển từ trạng thái DANG_GIAO sang DA_GIAO'),(68,1010,'DANG_GIAO','DA_HUY','2025-11-08 09:07:49','Trạng thái được cập nhật tự động.'),(69,1010,'DANG_GIAO','DA_HUY','2025-11-08 09:07:49','Đơn hàng được chuyển từ trạng thái DANG_GIAO sang DA_HUY'),(70,1013,'DANG_XU_LY','DANG_GIAO','2025-11-08 09:44:02','Trạng thái được cập nhật tự động.'),(71,1013,'DANG_XU_LY','DANG_GIAO','2025-11-08 09:44:02','Đơn hàng được chuyển từ trạng thái DANG_XU_LY sang DANG_GIAO'),(72,1013,'DANG_GIAO','DA_GIAO','2025-11-08 09:44:05','Trạng thái được cập nhật tự động.'),(73,1013,'DANG_GIAO','DA_GIAO','2025-11-08 09:44:05','Đơn hàng được chuyển từ trạng thái DANG_GIAO sang DA_GIAO'),(74,1015,'DANG_XU_LY','DANG_GIAO','2025-11-08 10:30:58','Trạng thái được cập nhật tự động.'),(75,1015,'DANG_XU_LY','DANG_GIAO','2025-11-08 10:30:58','Đơn hàng được chuyển từ trạng thái DANG_XU_LY sang DANG_GIAO'),(76,1015,'DANG_GIAO','DA_GIAO','2025-11-08 10:31:02','Trạng thái được cập nhật tự động.'),(77,1015,'DANG_GIAO','DA_GIAO','2025-11-08 10:31:02','Đơn hàng được chuyển từ trạng thái DANG_GIAO sang DA_GIAO'),(78,1014,'DANG_XU_LY','DA_HUY','2025-11-08 10:31:18','Trạng thái được cập nhật tự động.'),(79,1014,'DANG_XU_LY','DA_HUY','2025-11-08 10:31:18','Đơn hàng được chuyển từ trạng thái DANG_XU_LY sang DA_HUY'),(80,1016,'DANG_XU_LY','DANG_GIAO','2025-11-08 17:25:58','Trạng thái được cập nhật tự động.'),(81,1016,'DANG_XU_LY','DANG_GIAO','2025-11-08 17:25:58','Đơn hàng được chuyển từ trạng thái DANG_XU_LY sang DANG_GIAO'),(82,1016,'DANG_GIAO','DA_GIAO','2025-11-08 17:26:01','Trạng thái được cập nhật tự động.'),(83,1016,'DANG_GIAO','DA_GIAO','2025-11-08 17:26:01','Đơn hàng được chuyển từ trạng thái DANG_GIAO sang DA_GIAO'),(84,1017,'DANG_XU_LY','DA_HUY','2025-11-08 18:51:19','Trạng thái được cập nhật tự động.'),(85,1017,'DANG_XU_LY','DA_HUY','2025-11-08 18:51:19','Đơn hàng được chuyển từ trạng thái DANG_XU_LY sang DA_HUY'),(86,1018,'DANG_XU_LY','DANG_GIAO','2025-11-08 19:58:39','Trạng thái được cập nhật tự động.'),(87,1018,'DANG_XU_LY','DANG_GIAO','2025-11-08 19:58:39','Đơn hàng được chuyển từ trạng thái DANG_XU_LY sang DANG_GIAO'),(88,1018,'DANG_GIAO','DA_GIAO','2025-11-08 19:58:41','Trạng thái được cập nhật tự động.'),(89,1018,'DANG_GIAO','DA_GIAO','2025-11-08 19:58:41','Đơn hàng được chuyển từ trạng thái DANG_GIAO sang DA_GIAO'),(90,1012,'DA_GIAO','DOI_TRA','2025-11-08 20:30:18','Trạng thái được cập nhật tự động.'),(92,1012,'DOI_TRA','DA_GIAO','2025-11-08 20:54:50','Trạng thái được cập nhật tự động.'),(93,1019,'DANG_XU_LY','DANG_GIAO','2025-11-08 21:06:32','Trạng thái được cập nhật tự động.'),(94,1019,'DANG_XU_LY','DANG_GIAO','2025-11-08 21:06:32','Đơn hàng được chuyển từ trạng thái DANG_XU_LY sang DANG_GIAO'),(95,1019,'DANG_GIAO','DA_GIAO','2025-11-08 21:06:35','Trạng thái được cập nhật tự động.'),(96,1019,'DANG_GIAO','DA_GIAO','2025-11-08 21:06:35','Đơn hàng được chuyển từ trạng thái DANG_GIAO sang DA_GIAO'),(97,1019,'DA_GIAO','DOI_TRA','2025-11-08 21:06:49','Trạng thái được cập nhật tự động.'),(98,1019,'DOI_TRA','DA_GIAO','2025-11-08 21:07:17','Trạng thái được cập nhật tự động.'),(99,1020,'DANG_XU_LY','DANG_GIAO','2025-11-08 21:17:17','Trạng thái được cập nhật tự động.'),(100,1020,'DANG_XU_LY','DANG_GIAO','2025-11-08 21:17:17','Đơn hàng được chuyển từ trạng thái DANG_XU_LY sang DANG_GIAO'),(101,1020,'DANG_GIAO','DA_GIAO','2025-11-08 21:17:20','Trạng thái được cập nhật tự động.'),(102,1020,'DANG_GIAO','DA_GIAO','2025-11-08 21:17:20','Đơn hàng được chuyển từ trạng thái DANG_GIAO sang DA_GIAO'),(103,1020,'DA_GIAO','DOI_TRA','2025-11-08 21:17:52','Trạng thái được cập nhật tự động.'),(104,1018,'DA_GIAO','DOI_TRA','2025-11-08 21:29:16','Trạng thái được cập nhật tự động.'),(105,1019,'DA_GIAO','DOI_TRA','2025-11-08 21:29:58','Trạng thái được cập nhật tự động.'),(106,1019,'DOI_TRA','DA_GIAO','2025-11-08 21:30:07','Trạng thái được cập nhật tự động.'),(107,1021,'DANG_XU_LY','DANG_GIAO','2025-11-09 17:35:36','Trạng thái được cập nhật tự động.'),(108,1021,'DANG_XU_LY','DANG_GIAO','2025-11-09 17:35:36','Đơn hàng được chuyển từ trạng thái DANG_XU_LY sang DANG_GIAO'),(109,1021,'DANG_GIAO','DA_GIAO','2025-11-09 17:35:38','Trạng thái được cập nhật tự động.'),(110,1021,'DANG_GIAO','DA_GIAO','2025-11-09 17:35:38','Đơn hàng được chuyển từ trạng thái DANG_GIAO sang DA_GIAO'),(111,1021,'DA_GIAO','DOI_TRA','2025-11-09 17:35:49','Trạng thái được cập nhật tự động.'),(112,1022,'DANG_XU_LY','DANG_GIAO','2025-11-09 17:43:54','Trạng thái được cập nhật tự động.'),(113,1022,'DANG_XU_LY','DANG_GIAO','2025-11-09 17:43:54','Đơn hàng được chuyển từ trạng thái DANG_XU_LY sang DANG_GIAO'),(114,1022,'DANG_GIAO','DA_GIAO','2025-11-09 17:43:57','Trạng thái được cập nhật tự động.'),(115,1022,'DANG_GIAO','DA_GIAO','2025-11-09 17:43:57','Đơn hàng được chuyển từ trạng thái DANG_GIAO sang DA_GIAO'),(116,1022,'DA_GIAO','DOI_TRA','2025-11-09 17:44:08','Trạng thái được cập nhật tự động.'),(117,1023,'DANG_XU_LY','DANG_GIAO','2025-11-09 17:46:36','Trạng thái được cập nhật tự động.'),(118,1023,'DANG_XU_LY','DANG_GIAO','2025-11-09 17:46:36','Đơn hàng được chuyển từ trạng thái DANG_XU_LY sang DANG_GIAO'),(119,1023,'DANG_GIAO','DA_GIAO','2025-11-09 17:46:38','Trạng thái được cập nhật tự động.'),(120,1023,'DANG_GIAO','DA_GIAO','2025-11-09 17:46:38','Đơn hàng được chuyển từ trạng thái DANG_GIAO sang DA_GIAO'),(121,1023,'DA_GIAO','DOI_TRA','2025-11-09 17:46:49','Trạng thái được cập nhật tự động.'),(122,1024,'DANG_XU_LY','DA_HUY','2025-11-09 18:13:02','Trạng thái được cập nhật tự động.'),(123,1024,'DANG_XU_LY','DA_HUY','2025-11-09 18:13:02','Đơn hàng được chuyển từ trạng thái DANG_XU_LY sang DA_HUY'),(124,1012,'DA_GIAO','DOI_TRA','2025-11-09 19:43:08','Trạng thái được cập nhật tự động.'),(125,1025,'DANG_XU_LY','DANG_GIAO','2025-11-09 19:45:06','Trạng thái được cập nhật tự động.'),(126,1025,'DANG_XU_LY','DANG_GIAO','2025-11-09 19:45:06','Đơn hàng được chuyển từ trạng thái DANG_XU_LY sang DANG_GIAO'),(127,1025,'DANG_GIAO','DA_GIAO','2025-11-09 19:45:09','Trạng thái được cập nhật tự động.'),(128,1025,'DANG_GIAO','DA_GIAO','2025-11-09 19:45:09','Đơn hàng được chuyển từ trạng thái DANG_GIAO sang DA_GIAO'),(129,1026,'DANG_XU_LY','DANG_GIAO','2025-11-12 23:33:46','Trạng thái được cập nhật tự động.'),(130,1026,'DANG_XU_LY','DANG_GIAO','2025-11-12 23:33:46','Đơn hàng được chuyển từ trạng thái DANG_XU_LY sang DANG_GIAO'),(131,1026,'DANG_GIAO','DA_GIAO','2025-11-12 23:33:49','Trạng thái được cập nhật tự động.'),(132,1026,'DANG_GIAO','DA_GIAO','2025-11-12 23:33:49','Đơn hàng được chuyển từ trạng thái DANG_GIAO sang DA_GIAO'),(133,1027,'DANG_XU_LY','DANG_GIAO','2025-11-12 23:34:34','Trạng thái được cập nhật tự động.'),(134,1027,'DANG_XU_LY','DANG_GIAO','2025-11-12 23:34:34','Đơn hàng được chuyển từ trạng thái DANG_XU_LY sang DANG_GIAO'),(135,1027,'DANG_GIAO','DA_GIAO','2025-11-12 23:34:37','Trạng thái được cập nhật tự động.'),(136,1027,'DANG_GIAO','DA_GIAO','2025-11-12 23:34:37','Đơn hàng được chuyển từ trạng thái DANG_GIAO sang DA_GIAO'),(137,1028,'DANG_XU_LY','DANG_GIAO','2025-11-12 23:39:52','Trạng thái được cập nhật tự động.'),(138,1028,'DANG_XU_LY','DANG_GIAO','2025-11-12 23:39:52','Đơn hàng được chuyển từ trạng thái DANG_XU_LY sang DANG_GIAO'),(139,1028,'DANG_GIAO','DA_GIAO','2025-11-12 23:39:58','Trạng thái được cập nhật tự động.'),(140,1028,'DANG_GIAO','DA_GIAO','2025-11-12 23:39:58','Đơn hàng được chuyển từ trạng thái DANG_GIAO sang DA_GIAO'),(141,1029,'DANG_XU_LY','DANG_GIAO','2025-11-12 23:41:24','Trạng thái được cập nhật tự động.'),(142,1029,'DANG_XU_LY','DANG_GIAO','2025-11-12 23:41:24','Đơn hàng được chuyển từ trạng thái DANG_XU_LY sang DANG_GIAO'),(143,1029,'DANG_GIAO','DA_GIAO','2025-11-12 23:41:27','Trạng thái được cập nhật tự động.'),(144,1029,'DANG_GIAO','DA_GIAO','2025-11-12 23:41:27','Đơn hàng được chuyển từ trạng thái DANG_GIAO sang DA_GIAO'),(145,1032,'CHUA_THANH_TOAN','DA_HUY','2025-11-21 13:58:13','Trạng thái được cập nhật tự động.'),(146,1032,'CHUA_THANH_TOAN','DA_HUY','2025-11-21 13:58:13','Đơn hàng được chuyển từ trạng thái CHUA_THANH_TOAN sang DA_HUY'),(147,1034,'CHUA_THANH_TOAN','DANG_XU_LY','2025-11-24 08:21:34','Trạng thái được cập nhật tự động.'),(148,1034,'CHUA_THANH_TOAN','DANG_XU_LY','2025-11-24 08:21:34','Đơn hàng được chuyển từ trạng thái CHUA_THANH_TOAN sang DANG_XU_LY'),(149,1034,'DANG_XU_LY','DANG_GIAO','2025-11-24 08:21:37','Trạng thái được cập nhật tự động.'),(150,1034,'DANG_XU_LY','DANG_GIAO','2025-11-24 08:21:37','Đơn hàng được chuyển từ trạng thái DANG_XU_LY sang DANG_GIAO'),(151,1034,'DANG_GIAO','DA_GIAO','2025-11-24 08:21:40','Trạng thái được cập nhật tự động.'),(152,1034,'DANG_GIAO','DA_GIAO','2025-11-24 08:21:40','Đơn hàng được chuyển từ trạng thái DANG_GIAO sang DA_GIAO'),(153,1034,'DA_GIAO','DOI_TRA','2025-11-27 09:34:03','Trạng thái được cập nhật tự động.');
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
INSERT INTO `nguoidung` VALUES (4,'admin@gmail.com',NULL,'$2b$10$zFfCAFMhVTzxiEAwZxysOuR9cTBAOS67ZHUoa8zcf573L6dwfsswy','LOCAL','Quản Trị Viên',NULL,NULL,NULL,'ADMIN','ACTIVE',NULL,NULL,'2025-11-01 15:47:44'),(5,'huutv@gmail.com',NULL,'$2b$10$/8rI0GDeJlx6SJFIvurAU.5PGzOwzXre/B8/QmJaLZ2V35pQwkdTm','LOCAL','Trương Văn Hửu','0944089720','2004-01-02','Nam','KHACHHANG','ACTIVE',NULL,NULL,'2025-11-01 15:49:36'),(6,'nghitv@gmail.com',NULL,'$2b$10$1Ng2Pk/uE.IHgJtMk49xy.KE2p3Ngr3k6ZvEW0MQyN9jj3GftotH2','LOCAL','Trương Văn Nghị','0834576312','2007-01-30','Nam','KHACHHANG','ACTIVE',NULL,NULL,'2025-11-01 17:57:17'),(7,'huutv91vp2@gmail.com','102402061977779301978',NULL,'GOOGLE','1348_Trương Văn Hửu','0944089720','2004-01-01','Nam','KHACHHANG','ACTIVE',NULL,NULL,'2025-11-03 23:03:14'),(8,'huutv5@gmail.com',NULL,'$2b$10$LXdaycCIauXyu2DFwMuJ7eDtfHzrZAxJG7DkEhyPBqGUSJA9d63nK','LOCAL','Trương Trọng Hửu',NULL,NULL,NULL,'KHACHHANG','ACTIVE','67777e764efc769d853e515827f7e75ee6e693e50c3682089c43c42cb6ba121f','2025-11-05 19:15:31','2025-11-05 18:45:21'),(9,'nguyenminhkha3589@gmail.com','110087312938332068220',NULL,'GOOGLE','minh kha',NULL,NULL,NULL,'ADMIN','ACTIVE',NULL,NULL,'2025-11-06 15:03:19'),(10,'truong123@gmail.com',NULL,'$2b$10$1b6TRR0zGRtLr8fkpqOMceMGZuPDxpE2dihLS4QPYpO9vXkhLBKsK','LOCAL','Ton Duy Truong',NULL,NULL,NULL,'KHACHHANG','ACTIVE',NULL,NULL,'2025-11-08 02:36:16'),(11,'luantotran123@gmail.com','108215322239299880418',NULL,'GOOGLE','1856_Tô Trần Luân',NULL,NULL,NULL,'KHACHHANG','ACTIVE',NULL,NULL,'2025-11-08 19:16:12'),(12,'Phuc@gmail.com',NULL,'$2b$10$j5mECevpXyC8kIHGdWvJYOa66lIzuv6b6uKo3xUsPKkD/kOTEMOuG','LOCAL','Nguyen Le Trong Phuc',NULL,NULL,NULL,'KHACHHANG','ACTIVE',NULL,NULL,'2025-11-08 19:57:42'),(13,'transolam2004@gmail.com',NULL,'$2b$10$uwplbMuYvsYRQm/5VrCDI.YG3MFOi.6FnVk1FC5Zt/Sh7gjLHAkce','LOCAL','Trần Sơ Lâm',NULL,NULL,NULL,'KHACHHANG','ACTIVE',NULL,NULL,'2025-11-13 19:12:50'),(14,'Hieu@gmailcom',NULL,'$2b$10$gu22kkiLUkd/jZSDHaTscOfy78YRZZIckHG5eh03NqfrcC4r4caoa','LOCAL','Hieu',NULL,NULL,NULL,'KHACHHANG','ACTIVE',NULL,NULL,'2025-11-22 17:08:21'),(15,'Duc@gmail.com',NULL,'$2b$10$/JZPGJfxcquwxtVTh59rt.1HGQ.wMjhFBG9dCYi0aHWIyF/ea.Bnm','LOCAL','Duc',NULL,NULL,NULL,'KHACHHANG','ACTIVE',NULL,NULL,'2025-11-22 17:10:50'),(16,'Tuan@gmail.com',NULL,'$2b$10$75gLgfortsXz9bXXRv1mxutp92K58QYpWwkE4WONGkQ2PWjOTbYii','LOCAL','Tuân',NULL,NULL,NULL,'KHACHHANG','ACTIVE',NULL,NULL,'2025-11-22 17:11:36'),(17,'Hung@gmail.com',NULL,'$2b$10$2DqPr7ivaZEfh9wOVjrqgeaZRMh2yOEmtVRQgvRh0f9cyiYl0.L1y','LOCAL','Hung',NULL,NULL,NULL,'KHACHHANG','ACTIVE',NULL,NULL,'2025-11-22 20:58:48'),(18,'testcustomer@gmail.com',NULL,'$2b$10$UMUlhCY5UDHcAM1MCak6WOjZpoYn5T/VgvcdWWriDBcLgbIpfJn4q','LOCAL','Test Customer',NULL,NULL,NULL,'KHACHHANG','ACTIVE',NULL,NULL,'2025-11-24 08:05:58'),(19,'khachhang.test2024@gmail.com',NULL,'$2b$10$JNpCs9xhgvosX36vni2Vde.bnwSsf/P2k6mbcjWtuolpBKppiPqx2','LOCAL','Khách Hàng Test',NULL,NULL,NULL,'KHACHHANG','ACTIVE',NULL,NULL,'2025-11-24 08:07:29'),(20,'haha@gmail.com',NULL,'$2b$10$fPzjMzUAvOl77u3C5eYwCuV3TNapyETdduaxjGwRTW6z5VRm/Eeo.','LOCAL','HAHA',NULL,NULL,NULL,'KHACHHANG','ACTIVE',NULL,NULL,'2025-11-24 08:20:19');
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
INSERT INTO `nguoidung_voucher` VALUES (4,'50K','2025-11-09 18:12:06','DA_SU_DUNG'),(4,'aaaa','2025-11-23 20:43:07','DA_NHAN'),(4,'FREE30K','2025-11-21 14:15:50','DA_SU_DUNG'),(4,'hehe','2025-11-09 19:29:32','DA_SU_DUNG'),(4,'hehe1','2025-11-12 23:02:12','DA_NHAN'),(4,'lala','2025-11-12 23:04:00','DA_SU_DUNG'),(5,'FREE30K','2025-11-03 17:13:09','DA_SU_DUNG'),(6,'FREE30K','2025-11-02 17:56:18','DA_NHAN'),(7,'FREE30K','2025-11-06 00:52:37','DA_SU_DUNG'),(9,'aaaa','2025-11-22 21:19:31','DA_NHAN'),(9,'FREE30K','2025-11-22 21:18:27','DA_NHAN');
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
INSERT INTO `phienbansanpham` VALUES (5001,201,'ATCB-S-TRANG',99000.00,51),(5002,201,'ATCB-M-TRANG',99000.00,13),(5003,202,'QJSF-S-XANH',399000.00,76),(5004,203,'ATCT-M-DEN',180000.00,40),(5005,204,'ASMNTD-M-DEN',360000.00,48),(5006,205,'APNVCS-M-DEN',270000.00,50),(5007,206,'AKND-M-DEN',450000.00,49),(5008,207,'AHNNB-M-DEN',405000.00,55),(5009,208,'QJNRG-M-DEN',495000.00,50),(5010,209,'QSNK-M-DEN',225000.00,48),(5012,211,'QTNOD-M-DEN',378000.00,50),(5013,212,'ATNFR-M-DEN',230000.00,30),(5014,213,'ASMNL-M-DEN',324000.00,9),(5015,214,'ACTP-M-DEN',162000.00,50),(5016,215,'AHNTM-M-DEN',432000.00,49),(5017,216,'AKNC-M-DEN',351000.00,50),(5018,217,'QJNOL-M-DEN',468000.00,50),(5019,218,'QSNJ-M-DEN',252000.00,50),(5020,219,'QORNVT-M-DEN',297000.00,50),(5021,220,'CVCA-M-DEN',243000.00,50),(5022,221,'VDMV-M-DEN',540000.00,50),(5023,222,'QLGN-M-DEN',279000.00,20),(5024,223,'QSCB2L-M-DEN',234000.00,50),(5025,224,'DBN1M-M-DEN',405000.00,50),(5026,225,'AKTTCN-M-DEN',270000.00,48),(5027,226,'AKDLB-M-DEN',1350000.00,50),(5028,227,'VDBT-NAU',450000.00,50),(5029,228,'GDNCS-40-DEN',1170000.00,50),(5030,229,'MLT-FREE-DEN',135000.00,50),(5031,230,'BLCN-DEN',630000.00,50),(5032,231,'KMGT-DEN',315000.00,50),(5033,232,'TCC-FREE-DEN',45000.00,10),(5034,233,'TLDN-90CM-DEN',360000.00,60),(5049,210,'SKU-1762558064268',380000.00,40),(5050,210,'SKU-1762558067561',380000.00,120),(5057,222,'SKU-1763049245073',310000.00,160),(5058,211,'SKU-1763812075315',400000.00,10),(5060,249,'SKU-1763818175945',100000.00,10),(5061,250,'SKU-1763818609470',100000.00,8),(5063,250,'SKU-1763822144115',100000.00,10),(5065,251,'SKU-1764109183716',100000.00,10),(5066,251,'SKU-1764109733988',100000.00,10),(5067,251,'SKU-1764109783910',100000.00,10),(5068,251,'SKU-1764109812743',100000.00,12),(5069,253,'SKU-1764207371851',80000.00,10),(5070,253,'SKU-1764207375553',100000.00,10),(5071,253,'SKU-1764207381223',100000.00,10);
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
) ENGINE=InnoDB AUTO_INCREMENT=110 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `phiendangnhap`
--

LOCK TABLES `phiendangnhap` WRITE;
/*!40000 ALTER TABLE `phiendangnhap` DISABLE KEYS */;
INSERT INTO `phiendangnhap` VALUES (1,5,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6NSwidmFpVHJvIjoiS0hBQ0hIQU5HIiwiaWF0IjoxNzYxOTk0NTg4LCJleHAiOjE3NjQ1ODY1ODh9.2-gWV-9TkKtyQ-cc7qVMM8miyBqR5E0N3XjzchDwR1o','2025-11-01 17:56:28','2025-12-01 17:56:28'),(2,6,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6NiwidmFpVHJvIjoiS0hBQ0hIQU5HIiwiaWF0IjoxNzYxOTk0NjY1LCJleHAiOjE3NjQ1ODY2NjV9.7Te_bCRiZQCzVqZYA5Pa1v6-Jpyyg6L2bp-oaiIo90c','2025-11-01 17:57:45','2025-12-01 17:57:45'),(3,5,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6NSwidmFpVHJvIjoiS0hBQ0hIQU5HIiwiaWF0IjoxNzYyMDA5MjAxLCJleHAiOjE3NjQ2MDEyMDF9.iV3-v6TXRFWdpkmvZmyTtpdolYjFgk1uzNbIxkzPRhM','2025-11-01 22:00:01','2025-12-01 22:00:01'),(4,5,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6NSwidmFpVHJvIjoiS0hBQ0hIQU5HIiwiaWF0IjoxNzYyMDE4NDgyLCJleHAiOjE3NjQ2MTA0ODJ9.NIle1AfpJ02Igcur-5yvVVYjms2TWR2nGgQNX-OPv6E','2025-11-02 00:34:42','2025-12-02 00:34:42'),(5,5,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6NSwidmFpVHJvIjoiS0hBQ0hIQU5HIiwiaWF0IjoxNzYyMDc3MjYwLCJleHAiOjE3NjQ2NjkyNjB9.ZDwq5y5u2ZAMUbtwONbiuZ2tmst08JpEVs9D1mXq5Cw','2025-11-02 16:54:20','2025-12-02 16:54:20'),(6,6,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6NiwidmFpVHJvIjoiS0hBQ0hIQU5HIiwiaWF0IjoxNzYyMDc3NjE5LCJleHAiOjE3NjQ2Njk2MTl9.IxflC9KO1auR9zifHtWP5-RMm9iDlXQdCultsEyZM1s','2025-11-02 17:00:19','2025-12-02 17:00:19'),(7,4,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6NCwidmFpVHJvIjoiQURNSU4iLCJpYXQiOjE3NjIwNzc2NjEsImV4cCI6MTc2NDY2OTY2MX0.-HFJJzPA1q0RRKTap2WnAFeWpXNeL0yPXjcUt7te6wU','2025-11-02 17:01:01','2025-12-02 17:01:01'),(8,5,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6NSwidmFpVHJvIjoiS0hBQ0hIQU5HIiwiaWF0IjoxNzYyMDc3NzExLCJleHAiOjE3NjQ2Njk3MTF9.xh6szAjViTOYeFpvPODCyJGPn94Scc8HZoySvjEGpwY','2025-11-02 17:01:51','2025-12-02 17:01:51'),(9,5,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6NSwidmFpVHJvIjoiS0hBQ0hIQU5HIiwiaWF0IjoxNzYyMDc4MjE0LCJleHAiOjE3NjQ2NzAyMTR9.Bzl9ALgFKK_I4kT4q0AcNcRMy0bdDVaqTa6T55umWnU','2025-11-02 17:10:14','2025-12-02 17:10:14'),(10,6,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6NiwidmFpVHJvIjoiS0hBQ0hIQU5HIiwiaWF0IjoxNzYyMDc4MjQwLCJleHAiOjE3NjQ2NzAyNDB9.uvS_OllKDZyjGxoeDQKaDbmF8FMc_UhMt8qyQRwNdsQ','2025-11-02 17:10:40','2025-12-02 17:10:40'),(11,6,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6NiwidmFpVHJvIjoiS0hBQ0hIQU5HIiwiaWF0IjoxNzYyMDc4MzEwLCJleHAiOjE3NjQ2NzAzMTB9.HFlGAnX5PkbGw545dHrsHiwhn6T9sYkkBNfijYibsEA','2025-11-02 17:11:50','2025-12-02 17:11:50'),(12,6,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6NiwidmFpVHJvIjoiS0hBQ0hIQU5HIiwiaWF0IjoxNzYyMDc5MDI0LCJleHAiOjE3NjQ2NzEwMjR9.UxM6RCZ0vbDuf3D01VFcS0Bw0ZesvBU2jQwjKnT27jk','2025-11-02 17:23:44','2025-12-02 17:23:44'),(13,6,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6NiwidmFpVHJvIjoiS0hBQ0hIQU5HIiwiaWF0IjoxNzYyMDg1NDQ3LCJleHAiOjE3NjQ2Nzc0NDd9.lx21ASxSeC_LqpK3JE0xZL6mFoF_xzl3I10Mm_y4rQI','2025-11-02 19:10:47','2025-12-02 19:10:47'),(14,5,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6NSwidmFpVHJvIjoiS0hBQ0hIQU5HIiwiaWF0IjoxNzYyMTY0NTk4LCJleHAiOjE3NjQ3NTY1OTh9.V62LFFPEhkN9oadpBY6JCWAqJKaZVLCx6uZ2KIAxtb4','2025-11-03 17:09:58','2025-12-03 17:09:58'),(15,6,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6NiwidmFpVHJvIjoiS0hBQ0hIQU5HIiwiaWF0IjoxNzYyMTY4MjgwLCJleHAiOjE3NjQ3NjAyODB9.4Z3bgIsI6fsZO84e8JsXe1gKmSkN5VhUWiNiZs-8mtk','2025-11-03 18:11:20','2025-12-03 18:11:20'),(16,5,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6NSwidmFpVHJvIjoiS0hBQ0hIQU5HIiwiaWF0IjoxNzYyMTY4NDAzLCJleHAiOjE3NjQ3NjA0MDN9.17t2dH5UEJ8Bmnra1ombfTW5mFdLMaX14wiNpj8l6Yk','2025-11-03 18:13:23','2025-12-03 18:13:23'),(17,6,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6NiwidmFpVHJvIjoiS0hBQ0hIQU5HIiwiaWF0IjoxNzYyMTY5NTk5LCJleHAiOjE3NjQ3NjE1OTl9.bvi-k0QAidilShW0H8grfCCwI6iTysR9FqDM8PZrYSY','2025-11-03 18:33:19','2025-12-03 18:33:19'),(18,5,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6NSwidmFpVHJvIjoiS0hBQ0hIQU5HIiwiaWF0IjoxNzYyMTY5NjMwLCJleHAiOjE3NjQ3NjE2MzB9.KYdpyRst92XTOvrFIF23DGncgtDX-QI7vupZ7ZPE1Go','2025-11-03 18:33:50','2025-12-03 18:33:50'),(19,5,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6NSwidmFpVHJvIjoiS0hBQ0hIQU5HIiwiaWF0IjoxNzYyMTczODgwLCJleHAiOjE3NjQ3NjU4ODB9.n-mIoJg-p4NOeOR1Wou98j-bNrGBPS4LWfWiM_JMi8Y','2025-11-03 19:44:40','2025-12-03 19:44:40'),(20,7,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6NywidmFpVHJvIjoiS0hBQ0hIQU5HIiwiaWF0IjoxNzYyMTg1Nzk0LCJleHAiOjE3NjQ3Nzc3OTR9.hYHdbPA4e7oSHyVwCuYAk-hQXzf-wtl7_HyW4z8S_ZE','2025-11-03 23:03:14','2025-12-03 23:03:14'),(21,5,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6NSwidmFpVHJvIjoiS0hBQ0hIQU5HIiwiaWF0IjoxNzYyMTg2MTg5LCJleHAiOjE3NjQ3NzgxODl9.u-Nz8SMseOpW2rHi1ypkKwijhLTbfz3-Np5ING5XrLY','2025-11-03 23:09:49','2025-12-03 23:09:49'),(22,6,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6NiwidmFpVHJvIjoiS0hBQ0hIQU5HIiwiaWF0IjoxNzYyMTg2MjQzLCJleHAiOjE3NjQ3NzgyNDN9.j298A8QFlnRjYLvyiK7EcPI1Qsv41SXRiSV7YOug3nM','2025-11-03 23:10:43','2025-12-03 23:10:43'),(23,5,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6NSwidmFpVHJvIjoiS0hBQ0hIQU5HIiwiaWF0IjoxNzYyMTg2MzM0LCJleHAiOjE3NjQ3NzgzMzR9.Ji9PfVX3w-kdIPcTwwgdJUfiFAkC9wvDV2cGZAFGiNs','2025-11-03 23:12:14','2025-12-03 23:12:14'),(24,6,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6NiwidmFpVHJvIjoiS0hBQ0hIQU5HIiwiaWF0IjoxNzYyMTkxODYyLCJleHAiOjE3NjQ3ODM4NjJ9.KNdJ_TFntUI1xPQLgR2Um9xxj9Okf1JeoLJidMTxPCc','2025-11-04 00:44:22','2025-12-04 00:44:22'),(25,5,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6NSwidmFpVHJvIjoiS0hBQ0hIQU5HIiwiaWF0IjoxNzYyMTk5MjcwLCJleHAiOjE3NjQ3OTEyNzB9.SSTgPs-SEYJLxeEHbiAPCu8BjmZON4Sd2uP7rvUsa6c','2025-11-04 02:47:50','2025-12-04 02:47:50'),(26,5,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6NSwidmFpVHJvIjoiS0hBQ0hIQU5HIiwiaWF0IjoxNzYyMzI5Mjk5LCJleHAiOjE3NjQ5MjEyOTl9.GUegbwFMMofCFgZS_7Ee3Xj4j5Nh1RrPNKfXDcri_d8','2025-11-05 14:54:59','2025-12-05 14:54:59'),(27,5,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6NSwidmFpVHJvIjoiS0hBQ0hIQU5HIiwiaWF0IjoxNzYyMzM4NTU1LCJleHAiOjE3NjQ5MzA1NTV9.RjbO92tZJs5CIinXnyTgfARLwe4xz_pqTWdJuJ-wbGs','2025-11-05 17:29:15','2025-12-05 17:29:15'),(28,8,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6OCwidmFpVHJvIjoiS0hBQ0hIQU5HIiwiaWF0IjoxNzYyMzQzMTM0LCJleHAiOjE3NjQ5MzUxMzR9.flMs3baIOvWs-Vf825ljIPs_QJnXlXfqQ8v5_29oOWI','2025-11-05 18:45:34','2025-12-05 18:45:34'),(29,8,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6OCwidmFpVHJvIjoiS0hBQ0hIQU5HIiwiaWF0IjoxNzYyMzQ0NDExLCJleHAiOjE3NjQ5MzY0MTF9.e_1AeRoHqkFyNeZJYFTB1ASNtBgnUbk3anB60m5qP0Q','2025-11-05 19:06:51','2025-12-05 19:06:51'),(30,5,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6NSwidmFpVHJvIjoiS0hBQ0hIQU5HIiwiaWF0IjoxNzYyMzQ0NjgxLCJleHAiOjE3NjQ5MzY2ODF9.8mHAaem8d-DdAqi5mnGL9bKFR_Dpi-SnTn8VSsBYp20','2025-11-05 19:11:21','2025-12-05 19:11:21'),(31,6,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6NiwidmFpVHJvIjoiS0hBQ0hIQU5HIiwiaWF0IjoxNzYyMzQ2Njc1LCJleHAiOjE3NjQ5Mzg2NzV9.Hjx3f5dkgHsVvh5tH88iosOFlk6cjm3e5VtxH-0PxYw','2025-11-05 19:44:35','2025-12-05 19:44:35'),(32,7,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6NywidmFpVHJvIjoiS0hBQ0hIQU5HIiwiaWF0IjoxNzYyMzY0OTY1LCJleHAiOjE3NjQ5NTY5NjV9.44nx15yxCYPUDn3y5c6wzY1fpMW6Ri8KgGEHQqm6fvw','2025-11-06 00:49:25','2025-12-06 00:49:25'),(33,9,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6OSwidmFpVHJvIjoiS0hBQ0hIQU5HIiwiaWF0IjoxNzYyNDE2MTk5LCJleHAiOjE3NjUwMDgxOTl9.FTPa-QUWqKNGUnE9BlZ6PsTPqM0ABAIYMW6MTlZ4CeE','2025-11-06 15:03:19','2025-12-06 15:03:20'),(34,10,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MTAsInZhaVRybyI6IktIQUNISEFORyIsImlhdCI6MTc2MjU0NDE5MSwiZXhwIjoxNzY1MTM2MTkxfQ.zoIBs6k9-kw85h1Oma8vi6WGRUNCC--dciPV_7PNuAc','2025-11-08 02:36:31','2025-12-08 02:36:31'),(35,4,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6NCwidmFpVHJvIjoiQURNSU4iLCJpYXQiOjE3NjI1NDcwMzksImV4cCI6MTc2NTEzOTAzOX0.U032WBBM_sFoOZF-ky1var7jfcMXmlO4l3DbBb2uHjg','2025-11-08 03:23:59','2025-12-08 03:24:00'),(36,10,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MTAsInZhaVRybyI6IktIQUNISEFORyIsImlhdCI6MTc2MjU2OTc4MywiZXhwIjoxNzY1MTYxNzgzfQ.bgPcEkxFUFWX9puAqFpcGcA1x5GzOlqA0J2MhTCauag','2025-11-08 09:43:03','2025-12-08 09:43:03'),(37,4,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6NCwidmFpVHJvIjoiQURNSU4iLCJpYXQiOjE3NjI1Njk4MzQsImV4cCI6MTc2NTE2MTgzNH0.cwLABHD8t81WTTeeomA_lIOn7M3u9Xbk2FHeuqVksSs','2025-11-08 09:43:54','2025-12-08 09:43:55'),(38,4,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6NCwidmFpVHJvIjoiQURNSU4iLCJpYXQiOjE3NjI1NzA5NDIsImV4cCI6MTc2NTE2Mjk0Mn0.Zm5vTPq1IFGV2M4kanWA3fBujygGitHZRYhk9htBtUQ','2025-11-08 10:02:22','2025-12-08 10:02:23'),(39,10,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MTAsInZhaVRybyI6IktIQUNISEFORyIsImlhdCI6MTc2MjU3MjU0MywiZXhwIjoxNzY1MTY0NTQzfQ.wKeqqaAKoIyUnGQZDgB3jcb4ACB_KteNAJe9dj0k160','2025-11-08 10:29:03','2025-12-08 10:29:03'),(40,4,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6NCwidmFpVHJvIjoiQURNSU4iLCJpYXQiOjE3NjI1NzI2MjQsImV4cCI6MTc2NTE2NDYyNH0.m2xhvppIh0aTyqGr2YrrcoHkwP82-DmyQqeey6Zn4ek','2025-11-08 10:30:24','2025-12-08 10:30:24'),(41,4,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6NCwidmFpVHJvIjoiQURNSU4iLCJpYXQiOjE3NjI1OTY2NzEsImV4cCI6MTc2NTE4ODY3MX0.DIs0Bumr4Y2g7tVH7SWs-hio2UBr4NpgkHHHOt-Z37M','2025-11-08 17:11:11','2025-12-08 17:11:11'),(42,10,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MTAsInZhaVRybyI6IktIQUNISEFORyIsImlhdCI6MTc2MjU5NzUwMiwiZXhwIjoxNzY1MTg5NTAyfQ.rTwAhARo4t0GkwwVOqg2LBm74LgNo7hmcd4GZlqE5v0','2025-11-08 17:25:02','2025-12-08 17:25:02'),(43,4,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6NCwidmFpVHJvIjoiQURNSU4iLCJpYXQiOjE3NjI1OTc1MzUsImV4cCI6MTc2NTE4OTUzNX0.ZIuLA_5APGUSBeGQaKVzDy5r05kAz7c6WzbA0fN2nns','2025-11-08 17:25:35','2025-12-08 17:25:36'),(44,9,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6OSwidmFpVHJvIjoiQURNSU4iLCJpYXQiOjE3NjI2MDIwOTIsImV4cCI6MTc2NTE5NDA5Mn0.20Md834M4qbYq2Ocsvqh-ZlLp_wHuYCfmlx4mI6qp70','2025-11-08 18:41:32','2025-12-08 18:41:33'),(45,4,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6NCwidmFpVHJvIjoiQURNSU4iLCJpYXQiOjE3NjI2MDIzODgsImV4cCI6MTc2NTE5NDM4OH0.Ty93rfWKpwFFFBudHSic_ZQjh-ZAjmG7i9eORIK86_0','2025-11-08 18:46:28','2025-12-08 18:46:28'),(46,9,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6OSwidmFpVHJvIjoiQURNSU4iLCJpYXQiOjE3NjI2MDI1OTMsImV4cCI6MTc2NTE5NDU5M30.gVITP1mTfKGk1uXj77Sq-JEyShS-4chzr-L9IvoSvRw','2025-11-08 18:49:53','2025-12-08 18:49:53'),(47,4,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6NCwidmFpVHJvIjoiQURNSU4iLCJpYXQiOjE3NjI2MDI2MjQsImV4cCI6MTc2NTE5NDYyNH0.dVy65bW5HqCAqRhcmxqxjq5ebz22m-Lql5CyG4dpj1s','2025-11-08 18:50:24','2025-12-08 18:50:25'),(48,4,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6NCwidmFpVHJvIjoiQURNSU4iLCJpYXQiOjE3NjI2MDMwMjksImV4cCI6MTc2NTE5NTAyOX0.5lD3P-YaW5TYscQ2hBpHMZkmSvjGEIcTLbf7oVzBi7Q','2025-11-08 18:57:09','2025-12-08 18:57:10'),(49,4,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6NCwidmFpVHJvIjoiQURNSU4iLCJpYXQiOjE3NjI2MDMxMjAsImV4cCI6MTc2NTE5NTEyMH0.XTWEbYd-gWNrxvVXQcx91g_bMPg_hkJ0zt4A3jWwVfo','2025-11-08 18:58:40','2025-12-08 18:58:40'),(50,4,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6NCwidmFpVHJvIjoiQURNSU4iLCJpYXQiOjE3NjI2MDMzMTksImV4cCI6MTc2NTE5NTMxOX0.9v9oecDB5Xl9VyEXtxAXnZsJ7mWdBfg9aX8xYC8TuI4','2025-11-08 19:01:59','2025-12-08 19:01:59'),(51,4,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6NCwidmFpVHJvIjoiQURNSU4iLCJpYXQiOjE3NjI2MDQwMzUsImV4cCI6MTc2NTE5NjAzNX0.oYaRNrg6qvyGHrvra_N2qmU0e82FNXt4qiLQiqGfPVg','2025-11-08 19:13:55','2025-12-08 19:13:55'),(52,11,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MTEsInZhaVRybyI6IktIQUNISEFORyIsImlhdCI6MTc2MjYwNDE3MiwiZXhwIjoxNzY1MTk2MTcyfQ.lvphIqdaCbKcmX9K3dNZrEUZ7V6sBSNkZd5pePGfuF0','2025-11-08 19:16:12','2025-12-08 19:16:13'),(53,11,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MTEsInZhaVRybyI6IktIQUNISEFORyIsImlhdCI6MTc2MjYwNDMzNiwiZXhwIjoxNzY1MTk2MzM2fQ.ZM9S-wgi0ECEocAuFw_dubcvKfKFHEZyLl7YNBIwTjI','2025-11-08 19:18:56','2025-12-08 19:18:56'),(54,9,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6OSwidmFpVHJvIjoiQURNSU4iLCJpYXQiOjE3NjI2MDQzNjUsImV4cCI6MTc2NTE5NjM2NX0.8HwHyx-S42op72f5h96jsI7sF21A341fp1S83fyGzX8','2025-11-08 19:19:25','2025-12-08 19:19:25'),(55,11,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MTEsInZhaVRybyI6IktIQUNISEFORyIsImlhdCI6MTc2MjYwNDQ0MywiZXhwIjoxNzY1MTk2NDQzfQ.lH96QwSyEs9CmTbIiiXS5-tYeVShSFnSaggvGjXJOwo','2025-11-08 19:20:43','2025-12-08 19:20:43'),(56,11,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MTEsInZhaVRybyI6IktIQUNISEFORyIsImlhdCI6MTc2MjYwNDY4MywiZXhwIjoxNzY1MTk2NjgzfQ.8msVIBFNiHWdcOmptLgPyYNyFzt_KKvyIzXD-8_dSe8','2025-11-08 19:24:43','2025-12-08 19:24:44'),(57,9,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6OSwidmFpVHJvIjoiQURNSU4iLCJpYXQiOjE3NjI2MDQ2OTQsImV4cCI6MTc2NTE5NjY5NH0.BM5E5jklgiOgIyqIYuhp8A1EsEVo1dNM1wIRmXP2v-Y','2025-11-08 19:24:54','2025-12-08 19:24:54'),(58,12,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MTIsInZhaVRybyI6IktIQUNISEFORyIsImlhdCI6MTc2MjYwNjY3MiwiZXhwIjoxNzY1MTk4NjcyfQ.bfUGTYdO5QqMrPWH0frwlohtv74jCB-KF7Z1af6LluE','2025-11-08 19:57:52','2025-12-08 19:57:53'),(59,4,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6NCwidmFpVHJvIjoiQURNSU4iLCJpYXQiOjE3NjI2MDY3MDUsImV4cCI6MTc2NTE5ODcwNX0.0w2hRjDS2IrtaehJaJG3UpuXxpK_0cM2d7fBjArnvCE','2025-11-08 19:58:25','2025-12-08 19:58:26'),(60,12,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MTIsInZhaVRybyI6IktIQUNISEFORyIsImlhdCI6MTc2MjYwNjc2MiwiZXhwIjoxNzY1MTk4NzYyfQ.Vg8EnEhYxYo5piCcfS43yN-iKaBAq1LgBVAoNdWJ7Eg','2025-11-08 19:59:22','2025-12-08 19:59:23'),(61,4,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6NCwidmFpVHJvIjoiQURNSU4iLCJpYXQiOjE3NjI2MDc0NTcsImV4cCI6MTc2NTE5OTQ1N30.e9ExOfKkQmzB7PeXfKB4cqSmfCzokkAtyT-RMoWYdsk','2025-11-08 20:10:57','2025-12-08 20:10:57'),(62,12,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MTIsInZhaVRybyI6IktIQUNISEFORyIsImlhdCI6MTc2MjYxMDc2NSwiZXhwIjoxNzY1MjAyNzY1fQ.zLXWuyFIftq_wmjuABUDzZTZBmbyCnvwmKvDS7Rt0GI','2025-11-08 21:06:05','2025-12-08 21:06:06'),(63,4,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6NCwidmFpVHJvIjoiQURNSU4iLCJpYXQiOjE3NjI2MTA4MjMsImV4cCI6MTc2NTIwMjgyM30.qmwUOvfnSfP5AlldWRH0X0sc6GtAUGa_nJVGyx3HlhY','2025-11-08 21:07:03','2025-12-08 21:07:04'),(64,12,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MTIsInZhaVRybyI6IktIQUNISEFORyIsImlhdCI6MTc2MjYxMTM5NCwiZXhwIjoxNzY1MjAzMzk0fQ.xwT8oyavZHcDzah6Pf-nelnPMOFO99yNHei60B-_jrg','2025-11-08 21:16:34','2025-12-08 21:16:35'),(65,4,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6NCwidmFpVHJvIjoiQURNSU4iLCJpYXQiOjE3NjI2MTE0MzAsImV4cCI6MTc2NTIwMzQzMH0.qUdJ5GJ-ONwHuOp5s6RPyE_AHZUPd0FEXc5vQNTL2iA','2025-11-08 21:17:10','2025-12-08 21:17:10'),(66,12,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MTIsInZhaVRybyI6IktIQUNISEFORyIsImlhdCI6MTc2MjYxMTQ2MSwiZXhwIjoxNzY1MjAzNDYxfQ.bN08jC1v5Ttq-ZzLReRCdBt7GN6I9vVCTmTmmEz0DHI','2025-11-08 21:17:41','2025-12-08 21:17:41'),(67,4,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6NCwidmFpVHJvIjoiQURNSU4iLCJpYXQiOjE3NjI2MTE0ODIsImV4cCI6MTc2NTIwMzQ4Mn0.mNPpyW6gaD31XwL-oCUbJe5Qwpi__ixKcPea4-tsHXc','2025-11-08 21:18:02','2025-12-08 21:18:03'),(68,12,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MTIsInZhaVRybyI6IktIQUNISEFORyIsImlhdCI6MTc2MjYxMjExMCwiZXhwIjoxNzY1MjA0MTEwfQ.WAlxI2OZhzHPSQoaarvc5GpImBwOYZnfp1r6UUmfxM8','2025-11-08 21:28:30','2025-12-08 21:28:30'),(69,4,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6NCwidmFpVHJvIjoiQURNSU4iLCJpYXQiOjE3NjI2MTIxMjQsImV4cCI6MTc2NTIwNDEyNH0.sir_qTFxA61yMIS6SpSIrfYWSoARYY9hGVphuuzZKZM','2025-11-08 21:28:44','2025-12-08 21:28:45'),(70,4,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6NCwidmFpVHJvIjoiQURNSU4iLCJpYXQiOjE3NjI4NTI5ODEsImV4cCI6MTc2NTQ0NDk4MX0.A0OYr6AYIznJduHnBUt6NkSv7CotylRTcGOsM2s5qaE','2025-11-11 16:23:01','2025-12-11 16:23:01'),(71,10,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MTAsInZhaVRybyI6IktIQUNISEFORyIsImlhdCI6MTc2Mjg1MzIwOSwiZXhwIjoxNzY1NDQ1MjA5fQ.aeM6LiJYNf405YKPA8xDGT-Lm_x5VjS6mfLPkh1bEtg','2025-11-11 16:26:49','2025-12-11 16:26:50'),(72,9,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6OSwidmFpVHJvIjoiQURNSU4iLCJpYXQiOjE3NjI4NTMyMjAsImV4cCI6MTc2NTQ0NTIyMH0.hZvmkobawh-clHY8-KI2tFW3g4a8EWYkjL2OpO58f1Q','2025-11-11 16:27:00','2025-12-11 16:27:00'),(73,10,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MTAsInZhaVRybyI6IktIQUNISEFORyIsImlhdCI6MTc2Mjg1MzQ3MywiZXhwIjoxNzY1NDQ1NDczfQ.nps5D_QUPn-8iKn85UPyREfGvpD2boeXDo9FuOyxtzM','2025-11-11 16:31:13','2025-12-11 16:31:13'),(74,4,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6NCwidmFpVHJvIjoiQURNSU4iLCJpYXQiOjE3NjI4NTM0OTEsImV4cCI6MTc2NTQ0NTQ5MX0.Nedp4KPycouUl_hoSQGDqDo-446jNazxHipoop__IjA','2025-11-11 16:31:31','2025-12-11 16:31:31'),(75,10,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MTAsInZhaVRybyI6IktIQUNISEFORyIsImlhdCI6MTc2Mjg1MzUwNSwiZXhwIjoxNzY1NDQ1NTA1fQ.WNvfNPdtpBYfUfG75EwqyL8eKYQ-5Jpm-eetzict6Xg','2025-11-11 16:31:45','2025-12-11 16:31:45'),(76,4,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6NCwidmFpVHJvIjoiQURNSU4iLCJpYXQiOjE3NjI4NTM1MjIsImV4cCI6MTc2NTQ0NTUyMn0.-2CifJexP6iS4j3sPI131yYLTuWaRjWpx3q3--YKIxM','2025-11-11 16:32:02','2025-12-11 16:32:03'),(77,10,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MTAsInZhaVRybyI6IktIQUNISEFORyIsImlhdCI6MTc2Mjg1MzYwMSwiZXhwIjoxNzY1NDQ1NjAxfQ.61DzLnDXkC46-b0o9FqvsStg_xBm1NHQR1Zb5oMvS0k','2025-11-11 16:33:21','2025-12-11 16:33:21'),(78,4,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6NCwidmFpVHJvIjoiQURNSU4iLCJpYXQiOjE3NjI4NzI1NzYsImV4cCI6MTc2NTQ2NDU3Nn0.WqXkpFveRP-pN3ke333r4UkAJ8eii-q3QPaI6D5lXRM','2025-11-11 21:49:36','2025-12-11 21:49:36'),(79,4,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6NCwidmFpVHJvIjoiQURNSU4iLCJpYXQiOjE3NjI4Nzk4MTAsImV4cCI6MTc2NTQ3MTgxMH0.1JuTBVO9vj2USY_Nvv73Lp45OuNXePpL4W1XyowGBQ0','2025-11-11 23:50:10','2025-12-11 23:50:10'),(80,4,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6NCwidmFpVHJvIjoiQURNSU4iLCJpYXQiOjE3NjI4ODE0NzksImV4cCI6MTc2NTQ3MzQ3OX0.jQXTlpv0kOcuwBtJTAB4eBSjE1W9sBqqPhHjFCbhWFs','2025-11-12 00:17:59','2025-12-12 00:18:00'),(81,4,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6NCwidmFpVHJvIjoiQURNSU4iLCJpYXQiOjE3NjI5NDY5NDYsImV4cCI6MTc2NTUzODk0Nn0.92qAGeJvVurLQOOwOviYANcxPBh5yyfVlPZSRtd0fek','2025-11-12 18:29:06','2025-12-12 18:29:07'),(82,4,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6NCwidmFpVHJvIjoiQURNSU4iLCJpYXQiOjE3NjI5NDgwNDEsImV4cCI6MTc2NTU0MDA0MX0.QZIpzgMXQ4j2HUdNbzqodg_ylePvD6uGMdj8sdXMrPA','2025-11-12 18:47:21','2025-12-12 18:47:22'),(83,10,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MTAsInZhaVRybyI6IktIQUNISEFORyIsImlhdCI6MTc2Mjk0OTM1NywiZXhwIjoxNzY1NTQxMzU3fQ.LG-CDgzGBzSWjYIP0vtfxCa4ICfY397r1tvY6Oie_zY','2025-11-12 19:09:17','2025-12-12 19:09:18'),(84,4,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6NCwidmFpVHJvIjoiQURNSU4iLCJpYXQiOjE3NjI5NDkzNjQsImV4cCI6MTc2NTU0MTM2NH0.fCF3rSxhNKphAXzxH_GZX1PqHz2CI6-ei8PEYF9RO0w','2025-11-12 19:09:24','2025-12-12 19:09:25'),(85,11,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MTEsInZhaVRybyI6IktIQUNISEFORyIsImlhdCI6MTc2MzAzNTU0MCwiZXhwIjoxNzY1NjI3NTQwfQ.lbYk86tF99NmOe2dcwf40dF6Q11i6L-KmkGs8_ahiCE','2025-11-13 19:05:40','2025-12-13 19:05:40'),(86,13,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MTMsInZhaVRybyI6IktIQUNISEFORyIsImlhdCI6MTc2MzAzNTk4NywiZXhwIjoxNzY1NjI3OTg3fQ.YdACYx9ATKyj3CkWCex2ot7JW1XYpDaJAR4zI-KjIcQ','2025-11-13 19:13:07','2025-12-13 19:13:07'),(87,4,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6NCwidmFpVHJvIjoiQURNSU4iLCJpYXQiOjE3NjMwNTA3NzEsImV4cCI6MTc2NTY0Mjc3MX0.S_qy5UH-HrokYdFc-oooRUZZc2VItYgjdPM9YCjWFDA','2025-11-13 23:19:31','2025-12-13 23:19:32'),(88,13,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MTMsInZhaVRybyI6IktIQUNISEFORyIsImlhdCI6MTc2Mzc0NDEzNSwiZXhwIjoxNzY2MzM2MTM1fQ.7BicdhkHa_TYUtfrure4Ui8lim-Wm69zZV9F-ocmTVY','2025-11-21 23:55:35','2025-12-21 23:55:35'),(89,13,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MTMsInZhaVRybyI6IktIQUNISEFORyIsImlhdCI6MTc2Mzc0NDI1OCwiZXhwIjoxNzY2MzM2MjU4fQ.o8oVKx5PrBYWy1o2iUD706nCB_GgRI51n_3f85tQ5NE','2025-11-21 23:57:38','2025-12-21 23:57:39'),(90,4,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6NCwidmFpVHJvIjoiQURNSU4iLCJpYXQiOjE3NjM3NDQyODgsImV4cCI6MTc2NjMzNjI4OH0.Eb7YYNqKBea5yCaHixf8R-w1IzXfzYL4QRmiKA9s90w','2025-11-21 23:58:08','2025-12-21 23:58:08'),(91,15,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MTUsInZhaVRybyI6IktIQUNISEFORyIsImlhdCI6MTc2MzgwNjI2NSwiZXhwIjoxNzY2Mzk4MjY1fQ.laZrUgaSNWoobqc6T_2f952UkGis8fXO6F0oLhn_1Y4','2025-11-22 17:11:05','2025-12-22 17:11:06'),(92,16,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MTYsInZhaVRybyI6IktIQUNISEFORyIsImlhdCI6MTc2MzgwNjMxMCwiZXhwIjoxNzY2Mzk4MzEwfQ.wAx0enr117F9CXipp0yJ1CFGqQANKX_DE_zuecuxjek','2025-11-22 17:11:50','2025-12-22 17:11:50'),(93,4,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6NCwidmFpVHJvIjoiQURNSU4iLCJpYXQiOjE3NjM4MDkyMDYsImV4cCI6MTc2NjQwMTIwNn0.ZXDCuEL3JM8x4u9RoFHaWox6CHyENy4bEOpXxtIwevA','2025-11-22 18:00:06','2025-12-22 18:00:06'),(94,17,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MTcsInZhaVRybyI6IktIQUNISEFORyIsImlhdCI6MTc2MzgxOTkzOSwiZXhwIjoxNzY2NDExOTM5fQ.1JN9haQl2qew_Nl8zE0SMPjeNnq7Jqbd9HKc9tdJKoo','2025-11-22 20:58:59','2025-12-22 20:58:59'),(95,4,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6NCwidmFpVHJvIjoiQURNSU4iLCJpYXQiOjE3NjM4MjAxNTEsImV4cCI6MTc2NjQxMjE1MX0.FkajYEHIwG_zP14jjmWHugH5i-PXfrmQH2OiYJYLTrk','2025-11-22 21:02:31','2025-12-22 21:02:32'),(96,17,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MTcsInZhaVRybyI6IktIQUNISEFORyIsImlhdCI6MTc2MzgyMDI1NCwiZXhwIjoxNzY2NDEyMjU0fQ.fDIRrSBa5UyZul0ToLJ5hujF9vL3cPepbSc3g6_mFmQ','2025-11-22 21:04:14','2025-12-22 21:04:15'),(97,9,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6OSwidmFpVHJvIjoiQURNSU4iLCJpYXQiOjE3NjM4MjA5NDksImV4cCI6MTc2NjQxMjk0OX0.fQmYkWBfY3DzA058FI0LDzSoa58JUJ_GsWUhpXZ_Tks','2025-11-22 21:15:49','2025-12-22 21:15:49'),(98,4,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6NCwidmFpVHJvIjoiQURNSU4iLCJpYXQiOjE3NjM5MDM5MDQsImV4cCI6MTc2NjQ5NTkwNH0.xOQlWLGyJElsyvLXESkotfZvoy9cbMcrVOt78nz4hRI','2025-11-23 20:18:24','2025-12-23 20:18:25'),(99,4,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6NCwidmFpVHJvIjoiQURNSU4iLCJpYXQiOjE3NjM5NDYyODEsImV4cCI6MTc2NjUzODI4MX0.RVf6pduOA94ZO0GT1ErW69fnIU-V_8sFsSjr7cNisic','2025-11-24 08:04:41','2025-12-24 08:04:41'),(100,19,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MTksInZhaVRybyI6IktIQUNISEFORyIsImlhdCI6MTc2Mzk0NjQ5NywiZXhwIjoxNzY2NTM4NDk3fQ.PRVEei7sJgSpI_58uHOOBVHZSeTkc6W1ryJxd1_B134','2025-11-24 08:08:17','2025-12-24 08:08:18'),(101,20,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MjAsInZhaVRybyI6IktIQUNISEFORyIsImlhdCI6MTc2Mzk0NzI0MywiZXhwIjoxNzY2NTM5MjQzfQ.6fPfRvzaNcdwFo-9409KWWCVwrwxr2GaRwSP7bt2o_8','2025-11-24 08:20:43','2025-12-24 08:20:44'),(102,4,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6NCwidmFpVHJvIjoiQURNSU4iLCJpYXQiOjE3NjM5NDcyNTgsImV4cCI6MTc2NjUzOTI1OH0.fRlH015UwVWKI-s1SSuZBVWZaX5zE2tr58uzt4KTp30','2025-11-24 08:20:58','2025-12-24 08:20:58'),(103,17,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MTcsInZhaVRybyI6IktIQUNISEFORyIsImlhdCI6MTc2Mzk1MjIxOCwiZXhwIjoxNzY2NTQ0MjE4fQ.dKoBzPSh3DG_GrEsjTp7JpCj9INVpUc07fwZfZ-uzX4','2025-11-24 09:43:38','2025-12-24 09:43:39'),(104,4,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6NCwidmFpVHJvIjoiQURNSU4iLCJpYXQiOjE3NjQwNjUxMjQsImV4cCI6MTc2NjY1NzEyNH0.eSDYkpepSAy-PjXqUTYjjsUKLib7VjXGoFiYbwweL80','2025-11-25 17:05:24','2025-12-25 17:05:24'),(105,12,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MTIsInZhaVRybyI6IktIQUNISEFORyIsImlhdCI6MTc2NDA5OTc5NCwiZXhwIjoxNzY2NjkxNzk0fQ.kfUlXBayhLjDQbqrxS4-oMvQlKGgpwqOd3DkrIXw1Bc','2025-11-26 02:43:14','2025-12-26 02:43:15'),(106,4,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6NCwidmFpVHJvIjoiQURNSU4iLCJpYXQiOjE3NjQwOTk4ODksImV4cCI6MTc2NjY5MTg4OX0.y-lFNKZJzmUgZhyFAcfIrT-mmSHcHgdhzgF3rHiv8g8','2025-11-26 02:44:49','2025-12-26 02:44:50'),(107,17,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MTcsInZhaVRybyI6IktIQUNISEFORyIsImlhdCI6MTc2NDIxMDc5MSwiZXhwIjoxNzY2ODAyNzkxfQ.UXgjEClyXCVVG9s7CcF4RUx0GCIrcCxgK0mSqGmx1Lw','2025-11-27 09:33:11','2025-12-27 09:33:12'),(108,4,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6NCwidmFpVHJvIjoiQURNSU4iLCJpYXQiOjE3NjQyMTA4NTIsImV4cCI6MTc2NjgwMjg1Mn0.j0yeojZQsV3s8-rPmrhJHCreXaX8Y9gZhNjjoQ1vlX0','2025-11-27 09:34:12','2025-12-27 09:34:12'),(109,17,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MTcsInZhaVRybyI6IktIQUNISEFORyIsImlhdCI6MTc2NDIxMDg5OCwiZXhwIjoxNzY2ODAyODk4fQ.s49Dvon7jKIy9tbgmRJdm3zAqhaU7VCfe87WRbquB2U','2025-11-27 09:34:58','2025-12-27 09:34:58');
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
) ENGINE=InnoDB AUTO_INCREMENT=17 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `returns`
--

LOCK TABLES `returns` WRITE;
/*!40000 ALTER TABLE `returns` DISABLE KEYS */;
INSERT INTO `returns` VALUES (4,1005,'Sản phẩm lỗi','REJECTED',NULL,'2025-11-04 02:34:25','2025-11-08 20:55:40',NULL),(10,1018,'a','COMPLETED',99000.00,'2025-11-08 21:29:16','2025-11-08 21:29:33',4),(11,1019,'a','REJECTED',NULL,'2025-11-08 21:29:58','2025-11-08 21:30:07',4),(12,1021,'a','COMPLETED',270000.00,'2025-11-09 17:35:49','2025-11-09 17:43:14',4),(13,1022,'a','COMPLETED',378000.00,'2025-11-09 17:44:08','2025-11-09 17:46:04',4),(14,1023,'a','COMPLETED',380000.00,'2025-11-09 17:46:49','2025-11-09 17:46:59',4),(15,1012,'a','COMPLETED',270000.00,'2025-11-09 19:43:08','2025-11-09 19:43:39',4),(16,1034,'a','COMPLETED',99000.00,'2025-11-27 09:34:03','2025-11-27 09:34:40',4);
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
INSERT INTO `sanpham` VALUES (201,406,'Áo Thun Cotton Cơ Bản','ao-thun-cotton-co-ban','Thông tin sản phẩm Áo Thun:\n- Hàng chuẩn sản xuất, với những mẫu áo ý nghĩa, hài hước và độc đáo.\n- Chất liệu: thun cotton 100%, co giãn 2 chiều, vải mềm, vải mịn, thoáng mát, không xù lông.\n- Đường may chuẩn chỉnh, tỉ mỉ, chắc chắn.\n- Họa tiết được in bằng bằng công nghệ Pet Kĩ thuật số, rất chi tiết và bền màu.\n- Thiết kế với những mẫu in độc đáo!\nCó đủ các size từ   S, M, L, XL Chuẩn Form Oversize, Định Lượng 260GSM\nHướng dẫn sử dụng sản phẩm:\n- Nhớ lộn trái áo khi giặt máy và không ngâm lâu trong nước giặt\n- Không sử dụng thuốc tẩy\n- Khi phơi lộn trái và không phơi trực tiếp dưới ánh nắng mặt trời để bảo quản hình trên áo luôn đẹp\n Điều kiện áp dụng đổi sản phẩm (trong vòng 07 ngày kể từ khi nhận sản phẩm) \n- Hàng hoá sai mẫu mã do người gửi\n- Hàng hoá bị lỗi hoặc hư hỏng do vận chuyển hoặc do nhà sản xuất \nCách Thức Về Đổi Trả Sản Phẩm\n- Chúng mình chỉ nhận đổi trả sản phẩm trong vòng 7 ngày \"kể từ khi bạn nhận được hàng\", và lỗi về thiết kế hoặc chất lượng áo, Chúng mình không hỗ trợ đổi trả khi khách hàng chọn sai kích thước \" size áo \". Nếu bạn cảm thấy khó trong vấn đề chọn size thì đừng ngừng ngại Inbox cho tụi mình nhé.\nDo màn hình và điều kiện ánh sáng khác nhau, màu sắc thực tế của sản phẩm có thể chênh lệch khoảng 2-5%','BLANK CANVAS','Cotton 100%',120000.00,'ACTIVE',0,0,'2025-11-01 15:40:00'),(202,411,'Quần Jean Slim Fit','quan-jean-slim-fit','Thông tin sản phẩm Quần Jean Slim Fit:\r\n- Hàng thiết kế và sản xuất bởi DenimPro, đảm bảo chất lượng và form dáng.\r\n- Chất liệu: Vải Jean Cotton cao cấp, co giãn nhẹ, thoáng mát, giữ form, và thân thiện với da.\r\n- Đường may tỉ mỉ, tinh tế, không chỉ thừa, đạt tiêu chuẩn xuất khẩu.\r\n- Phù hợp mặc đi làm, đi chơi, dạo phố hoặc các sự kiện quan trọng.\r\n- Thiết kế Quần Jean Slim Fit hiện đại, trẻ trung, dễ dàng phối đồ.\r\n\r\nCó đủ các size từ S, M, L, XL, XXL (Vui lòng tham khảo bảng size chi tiết).\r\n\r\nHướng dẫn sử dụng sản phẩm:\r\n- Ưu tiên giặt tay ở nhiệt độ thường để giữ độ bền của Vải Jean Cotton.\r\n- Hạn chế giặt máy. Nếu giặt máy, nên lộn trái sản phẩm và cho vào túi giặt.\r\n- Không sử dụng thuốc tẩy hoặc ngâm sản phẩm quá lâu.\r\n- Phơi ở nơi thoáng mát, tránh ánh nắng mặt trời trực tiếp.\r\n\r\nĐiều kiện áp dụng đổi sản phẩm (trong vòng 07 ngày kể từ khi nhận sản phẩm):\r\n- Hàng hoá còn mới, chưa qua sử dụng, còn nguyên tem mác.\r\n- Hàng hoá bị lỗi hoặc hư hỏng do vận chuyển hoặc do nhà sản xuất.\r\n\r\nLưu ý:\r\n- Do màn hình và điều kiện ánh sáng khác nhau, màu sắc thực tế của sản phẩm có thể chênh lệch khoảng 3-5%.','DenimPro','Vải Jean Cotton',450000.00,'ACTIVE',0,0,'2025-11-02 15:40:00'),(203,406,'Áo Thun Nam Cổ Tròn','ao-thun-nam-co-tron','Thông tin sản phẩm Áo Thun Nam Cổ Tròn:\r\n- Hàng thiết kế và sản xuất bởi UrbanFlex, đảm bảo chất lượng và form dáng.\r\n- Chất liệu: Cotton 4 chiều cao cấp, siêu co giãn, thấm hút mồ hôi, và thân thiện với da.\r\n- Đường may tỉ mỉ, tinh tế, không chỉ thừa, đạt tiêu chuẩn xuất khẩu.\r\n- Phù hợp mặc đi làm, đi chơi, dạo phố hoặc các sự kiện quan trọng.\r\n- Thiết kế Áo Thun Nam Cổ Tròn hiện đại, trẻ trung, dễ dàng phối đồ.\r\n\r\nCó đủ các size từ S, M, L, XL, XXL (Vui lòng tham khảo bảng size chi tiết).\r\n\r\nHướng dẫn sử dụng sản phẩm:\r\n- Ưu tiên giặt tay ở nhiệt độ thường để giữ độ bền của Cotton 4 chiều.\r\n- Hạn chế giặt máy. Nếu giặt máy, nên lộn trái sản phẩm và cho vào túi giặt.\r\n- Không sử dụng thuốc tẩy hoặc ngâm sản phẩm quá lâu.\r\n- Phơi ở nơi thoáng mát, tránh ánh nắng mặt trời trực tiếp.\r\n\r\nĐiều kiện áp dụng đổi sản phẩm (trong vòng 07 ngày kể từ khi nhận sản phẩm):\r\n- Hàng hoá còn mới, chưa qua sử dụng, còn nguyên tem mác.\r\n- Hàng hoá bị lỗi hoặc hư hỏng do vận chuyển hoặc do nhà sản xuất.\r\n\r\nLưu ý:\r\n- Do màn hình và điều kiện ánh sáng khác nhau, màu sắc thực tế của sản phẩm có thể chênh lệch khoảng 3-5%.','UrbanFlex','Cotton 4 chiều',200000.00,'ACTIVE',0,0,'2025-11-04 18:11:41'),(204,407,'Áo Sơ Mi Nam Tay Dài','ao-so-mi-nam-tay-dai','Thông tin sản phẩm Áo Sơ Mi Nam Tay Dài:\n- Hàng thiết kế và sản xuất bởi Elegante, đảm bảo chất lượng và form dáng.\n- Chất liệu: Vải Kate Lụa cao cấp, chống nhăn, thoáng mát, giữ form, và thân thiện với da.\n- Đường may tỉ mỉ, tinh tế, không chỉ thừa, đạt tiêu chuẩn xuất khẩu.\n- Phù hợp mặc đi làm, đi chơi, dạo phố hoặc các sự kiện quan trọng.\n- Thiết kế Áo Sơ Mi Nam Tay Dài hiện đại, trẻ trung, dễ dàng phối đồ.\n\nCó đủ các size từ S, M, L, XL, XXL (Vui lòng tham khảo bảng size chi tiết).\n\nHướng dẫn sử dụng sản phẩm:\n- Ưu tiên giặt tay ở nhiệt độ thường để giữ độ bền của Vải Kate Lụa.\n- Hạn chế giặt máy. Nếu giặt máy, nên lộn trái sản phẩm và cho vào túi giặt.\n- Không sử dụng thuốc tẩy hoặc ngâm sản phẩm quá lâu.\n- Phơi ở nơi thoáng mát, tránh ánh nắng mặt trời trực tiếp.\n\nĐiều kiện áp dụng đổi sản phẩm (trong vòng 07 ngày kể từ khi nhận sản phẩm):\n- Hàng hoá còn mới, chưa qua sử dụng, còn nguyên tem mác.\n- Hàng hoá bị lỗi hoặc hư hỏng do vận chuyển hoặc do nhà sản xuất.\n\nLưu ý:\n- Do màn hình và điều kiện ánh sáng khác nhau, màu sắc thực tế của sản phẩm có thể chênh lệch khoảng 3-5%.','Elegante','Vải Kate Lụa',400000.00,'ACTIVE',0,0,'2025-11-04 18:11:41'),(205,408,'Áo Polo Nam Vải Cá Sấu','ao-polo-nam-vai-ca-sau','Thông tin sản phẩm Áo Polo Nam Vải Cá Sấu:\n- Hàng thiết kế và sản xuất bởi ActiveWear, đảm bảo chất lượng và form dáng.\n- Chất liệu: Vải Cotton Pique (Cá Sấu) cao cấp, thoáng mát, giữ form, và thân thiện với da.\n- Đường may tỉ mỉ, tinh tế, không chỉ thừa, đạt tiêu chuẩn xuất khẩu.\n- Phù hợp mặc đi làm, đi chơi, dạo phố hoặc các sự kiện quan trọng.\n- Thiết kế Áo Polo Nam Vải Cá Sấu hiện đại, trẻ trung, dễ dàng phối đồ.\n\nCó đủ các size từ S, M, L, XL, XXL (Vui lòng tham khảo bảng size chi tiết).\n\nHướng dẫn sử dụng sản phẩm:\n- Ưu tiên giặt tay ở nhiệt độ thường để giữ độ bền của Vải Cotton Pique (Cá Sấu).\n- Hạn chế giặt máy. Nếu giặt máy, nên lộn trái sản phẩm và cho vào túi giặt.\n- Không sử dụng thuốc tẩy hoặc ngâm sản phẩm quá lâu.\n- Phơi ở nơi thoáng mát, tránh ánh nắng mặt trời trực tiếp.\n\nĐiều kiện áp dụng đổi sản phẩm (trong vòng 07 ngày kể từ khi nhận sản phẩm):\n- Hàng hoá còn mới, chưa qua sử dụng, còn nguyên tem mác.\n- Hàng hoá bị lỗi hoặc hư hỏng do vận chuyển hoặc do nhà sản xuất.\n\nLưu ý:\n- Do màn hình và điều kiện ánh sáng khác nhau, màu sắc thực tế của sản phẩm có thể chênh lệch khoảng 3-5%.','ActiveWear','Vải Cotton Pique (Cá Sấu)',300000.00,'ACTIVE',0,0,'2025-11-04 18:11:41'),(206,409,'Áo Khoác Nam Dù','ao-khoac-nam-du','Thông tin sản phẩm Áo Khoác Nam Dù:\n- Hàng thiết kế và sản xuất bởi WindBreaker, đảm bảo chất lượng và form dáng.\n- Chất liệu: Vải Dù 2 lớp cao cấp, chống gió, trượt nước nhẹ, và thân thiện với da.\n- Đường may tỉ mỉ, tinh tế, không chỉ thừa, đạt tiêu chuẩn xuất khẩu.\n- Phù hợp mặc đi làm, đi chơi, dạo phố hoặc các sự kiện quan trọng.\n- Thiết kế Áo Khoác Nam Dù hiện đại, trẻ trung, dễ dàng phối đồ.\n\nCó đủ các size từ S, M, L, XL, XXL (Vui lòng tham khảo bảng size chi tiết).\n\nHướng dẫn sử dụng sản phẩm:\n- Ưu tiên giặt tay ở nhiệt độ thường để giữ độ bền của Vải Dù 2 lớp.\n- Hạn chế giặt máy. Nếu giặt máy, nên lộn trái sản phẩm và cho vào túi giặt.\n- Không sử dụng thuốc tẩy hoặc ngâm sản phẩm quá lâu.\n- Phơi ở nơi thoáng mát, tránh ánh nắng mặt trời trực tiếp.\n\nĐiều kiện áp dụng đổi sản phẩm (trong vòng 07 ngày kể từ khi nhận sản phẩm):\n- Hàng hoá còn mới, chưa qua sử dụng, còn nguyên tem mác.\n- Hàng hoá bị lỗi hoặc hư hỏng do vận chuyển hoặc do nhà sản xuất.\n\nLưu ý:\n- Do màn hình và điều kiện ánh sáng khác nhau, màu sắc thực tế của sản phẩm có thể chênh lệch khoảng 3-5%.','WindBreaker','Vải Dù 2 lớp',500000.00,'ACTIVE',0,0,'2025-11-04 18:11:41'),(207,410,'Áo Hoodie Nam Nỉ Bông','ao-hoodie-nam-ni-bong','Thông tin sản phẩm Áo Hoodie Nam Nỉ Bông:\r\n- Hàng thiết kế và sản xuất bởi CozyWear, đảm bảo chất lượng và form dáng.\r\n- Chất liệu: Vải Nỉ Bông Dày cao cấp, ấm áp, giữ form, và thân thiện với da.\r\n- Đường may tỉ mỉ, tinh tế, không chỉ thừa, đạt tiêu chuẩn xuất khẩu.\r\n- Phù hợp mặc đi làm, đi chơi, dạo phố hoặc các sự kiện quan trọng.\r\n- Thiết kế Áo Hoodie Nam Nỉ Bông hiện đại, trẻ trung, dễ dàng phối đồ.\r\n\r\nCó đủ các size từ S, M, L, XL, XXL (Vui lòng tham khảo bảng size chi tiết).\r\n\r\nHướng dẫn sử dụng sản phẩm:\r\n- Ưu tiên giặt tay ở nhiệt độ thường để giữ độ bền của Vải Nỉ Bông Dày.\r\n- Hạn chế giặt máy. Nếu giặt máy, nên lộn trái sản phẩm và cho vào túi giặt.\r\n- Không sử dụng thuốc tẩy hoặc ngâm sản phẩm quá lâu.\r\n- Phơi ở nơi thoáng mát, tránh ánh nắng mặt trời trực tiếp.\r\n\r\nĐiều kiện áp dụng đổi sản phẩm (trong vòng 07 ngày kể từ khi nhận sản phẩm):\r\n- Hàng hoá còn mới, chưa qua sử dụng, còn nguyên tem mác.\r\n- Hàng hoá bị lỗi hoặc hư hỏng do vận chuyển hoặc do nhà sản xuất.\r\n\r\nLưu ý:\r\n- Do màn hình và điều kiện ánh sáng khác nhau, màu sắc thực tế của sản phẩm có thể chênh lệch khoảng 3-5%.','CozyWear','Vải Nỉ Bông Dày',450000.00,'ACTIVE',0,0,'2025-11-04 18:11:41'),(208,411,'Quần Jean Nam Rách Gối','quan-jean-nam-rach-goi','Thông tin sản phẩm Quần Jean Nam Rách Gối:\n- Hàng thiết kế và sản xuất bởi RippedStyle, đảm bảo chất lượng và form dáng.\n- Chất liệu: Vải Jean Bụi cao cấp, thoáng mát, giữ form, và thân thiện với da.\n- Đường may tỉ mỉ, tinh tế, không chỉ thừa, đạt tiêu chuẩn xuất khẩu.\n- Phù hợp mặc đi làm, đi chơi, dạo phố hoặc các sự kiện quan trọng.\n- Thiết kế Quần Jean Nam Rách Gối hiện đại, trẻ trung, dễ dàng phối đồ.\n\nCó đủ các size từ S, M, L, XL, XXL (Vui lòng tham khảo bảng size chi tiết).\n\nHướng dẫn sử dụng sản phẩm:\n- Ưu tiên giặt tay ở nhiệt độ thường để giữ độ bền của Vải Jean Bụi.\n- Hạn chế giặt máy. Nếu giặt máy, nên lộn trái sản phẩm và cho vào túi giặt.\n- Không sử dụng thuốc tẩy hoặc ngâm sản phẩm quá lâu.\n- Phơi ở nơi thoáng mát, tránh ánh nắng mặt trời trực tiếp.\n\nĐiều kiện áp dụng đổi sản phẩm (trong vòng 07 ngày kể từ khi nhận sản phẩm):\n- Hàng hoá còn mới, chưa qua sử dụng, còn nguyên tem mác.\n- Hàng hoá bị lỗi hoặc hư hỏng do vận chuyển hoặc do nhà sản xuất.\n\nLưu ý:\n- Do màn hình và điều kiện ánh sáng khác nhau, màu sắc thực tế của sản phẩm có thể chênh lệch khoảng 3-5%.','RippedStyle','Vải Jean Bụi',550000.00,'ACTIVE',0,0,'2025-11-04 18:11:41'),(209,412,'Quần Short Nam Kaki','quan-short-nam-kaki','Thông tin sản phẩm Quần Short Nam Kaki:\r\n- Hàng thiết kế và sản xuất bởi UrbanFlex, đảm bảo chất lượng và form dáng.\r\n- Chất liệu: Vải Kaki Cotton cao cấp, thoáng mát, giữ form, và thân thiện với da.\r\n- Đường may tỉ mỉ, tinh tế, không chỉ thừa, đạt tiêu chuẩn xuất khẩu.\r\n- Phù hợp mặc đi làm, đi chơi, dạo phố hoặc các sự kiện quan trọng.\r\n- Thiết kế Quần Short Nam Kaki hiện đại, trẻ trung, dễ dàng phối đồ.\r\n\r\nCó đủ các size từ S, M, L, XL, XXL (Vui lòng tham khảo bảng size chi tiết).\r\n\r\nHướng dẫn sử dụng sản phẩm:\r\n- Ưu tiên giặt tay ở nhiệt độ thường để giữ độ bền của Vải Kaki Cotton.\r\n- Hạn chế giặt máy. Nếu giặt máy, nên lộn trái sản phẩm và cho vào túi giặt.\r\n- Không sử dụng thuốc tẩy hoặc ngâm sản phẩm quá lâu.\r\n- Phơi ở nơi thoáng mát, tránh ánh nắng mặt trời trực tiếp.\r\n\r\nĐiều kiện áp dụng đổi sản phẩm (trong vòng 07 ngày kể từ khi nhận sản phẩm):\r\n- Hàng hoá còn mới, chưa qua sử dụng, còn nguyên tem mác.\r\n- Hàng hoá bị lỗi hoặc hư hỏng do vận chuyển hoặc do nhà sản xuất.\r\n\r\nLưu ý:\r\n- Do màn hình và điều kiện ánh sáng khác nhau, màu sắc thực tế của sản phẩm có thể chênh lệch khoảng 3-5%.','UrbanFlex','Vải Kaki Cotton',250000.00,'ACTIVE',0,0,'2025-11-04 18:11:41'),(210,413,'Quần Kaki Nam Dáng Slim','quan-kaki-nam-dang-slim','','','',380000.00,'ACTIVE',0,0,'2025-11-04 18:11:41'),(211,414,'Quần Tây Nam Ống Đứng','quan-tay-nam-ong-dung','Thông tin sản phẩm Quần Tây Nam Ống Đứng:\r\n- Hàng thiết kế và sản xuất bởi OfficeStyle, đảm bảo chất lượng và form dáng.\r\n- Chất liệu: Vải Tây Cao Cấp cao cấp, chống nhăn, thoáng mát, giữ form, và thân thiện với da.\r\n- Đường may tỉ mỉ, tinh tế, không chỉ thừa, đạt tiêu chuẩn xuất khẩu.\r\n- Phù hợp mặc đi làm, đi chơi, dạo phố hoặc các sự kiện quan trọng.\r\n- Thiết kế Quần Tây Nam Ống Đứng hiện đại, trẻ trung, dễ dàng phối đồ.\r\n\r\nCó đủ các size từ S, M, L, XL, XXL (Vui lòng tham khảo bảng size chi tiết).\r\n\r\nHướng dẫn sử dụng sản phẩm:\r\n- Ưu tiên giặt tay ở nhiệt độ thường để giữ độ bền của Vải Tây Cao Cấp.\r\n- Hạn chế giặt máy. Nếu giặt máy, nên lộn trái sản phẩm và cho vào túi giặt.\r\n- Không sử dụng thuốc tẩy hoặc ngâm sản phẩm quá lâu.\r\n- Phơi ở nơi thoáng mát, tránh ánh nắng mặt trời trực tiếp.\r\n\r\nĐiều kiện áp dụng đổi sản phẩm (trong vòng 07 ngày kể từ khi nhận sản phẩm):\r\n- Hàng hoá còn mới, chưa qua sử dụng, còn nguyên tem mác.\r\n- Hàng hoá bị lỗi hoặc hư hỏng do vận chuyển hoặc do nhà sản xuất.\r\n\r\nLưu ý:\r\n- Do màn hình và điều kiện ánh sáng khác nhau, màu sắc thực tế của sản phẩm có thể chênh lệch khoảng 3-5%.','OfficeStyle','Vải Tây Cao Cấp',420000.00,'ACTIVE',0,0,'2025-11-04 18:11:41'),(212,415,'Áo Thun Nữ Form Rộng','ao-thun-nu-form-rong','Thông tin sản phẩm Áo Thun Nữ Form Rộng:\r\n- Hàng thiết kế và sản xuất bởi DivaStyle, đảm bảo chất lượng và form dáng.\r\n- Chất liệu: Cotton 100% 2 chiều cao cấp, thoáng mát, giữ form, và thân thiện với da.\r\n- Đường may tỉ mỉ, tinh tế, không chỉ thừa, đạt tiêu chuẩn xuất khẩu.\r\n- Phù hợp mặc đi làm, đi chơi, dạo phố hoặc các sự kiện quan trọng.\r\n- Thiết kế Áo Thun Nữ Form Rộng hiện đại, trẻ trung, dễ dàng phối đồ.\r\n\r\nCó đủ các size từ S, M, L, XL, XXL (Vui lòng tham khảo bảng size chi tiết).\r\n\r\nHướng dẫn sử dụng sản phẩm:\r\n- Ưu tiên giặt tay ở nhiệt độ thường để giữ độ bền của Cotton 100% 2 chiều.\r\n- Hạn chế giặt máy. Nếu giặt máy, nên lộn trái sản phẩm và cho vào túi giặt.\r\n- Không sử dụng thuốc tẩy hoặc ngâm sản phẩm quá lâu.\r\n- Phơi ở nơi thoáng mát, tránh ánh nắng mặt trời trực tiếp.\r\n\r\nĐiều kiện áp dụng đổi sản phẩm (trong vòng 07 ngày kể từ khi nhận sản phẩm):\r\n- Hàng hoá còn mới, chưa qua sử dụng, còn nguyên tem mác.\r\n- Hàng hoá bị lỗi hoặc hư hỏng do vận chuyển hoặc do nhà sản xuất.\r\n\r\nLưu ý:\r\n- Do màn hình và điều kiện ánh sáng khác nhau, màu sắc thực tế của sản phẩm có thể chênh lệch khoảng 3-5%.','DivaStyle','Cotton 100% 2 chiều',220000.00,'ACTIVE',0,0,'2025-11-04 18:11:41'),(213,416,'Áo Sơ Mi Nữ Lụa','ao-so-mi-nu-lua','Thông tin sản phẩm Áo Sơ Mi Nữ Lụa:\r\n- Hàng thiết kế và sản xuất bởi SilkSation, đảm bảo chất lượng và form dáng.\r\n- Chất liệu: Vải Lụa Satin cao cấp, mềm mịn, thoáng mát, giữ form, và thân thiện với da.\r\n- Đường may tỉ mỉ, tinh tế, không chỉ thừa, đạt tiêu chuẩn xuất khẩu.\r\n- Phù hợp mặc đi làm, đi chơi, dạo phố hoặc các sự kiện quan trọng.\r\n- Thiết kế Áo Sơ Mi Nữ Lụa hiện đại, trẻ trung, dễ dàng phối đồ.\r\n\r\nCó đủ các size từ S, M, L, XL, XXL (Vui lòng tham khảo bảng size chi tiết).\r\n\r\nHướng dẫn sử dụng sản phẩm:\r\n- Ưu tiên giặt tay ở nhiệt độ thường để giữ độ bền của Vải Lụa Satin.\r\n- Hạn chế giặt máy. Nếu giặt máy, nên lộn trái sản phẩm và cho vào túi giặt.\r\n- Không sử dụng thuốc tẩy hoặc ngâm sản phẩm quá lâu.\r\n- Phơi ở nơi thoáng mát, tránh ánh nắng mặt trời trực tiếp.\r\n\r\nĐiều kiện áp dụng đổi sản phẩm (trong vòng 07 ngày kể từ khi nhận sản phẩm):\r\n- Hàng hoá còn mới, chưa qua sử dụng, còn nguyên tem mác.\r\n- Hàng hoá bị lỗi hoặc hư hỏng do vận chuyển hoặc do nhà sản xuất.\r\n\r\nLưu ý:\r\n- Do màn hình và điều kiện ánh sáng khác nhau, màu sắc thực tế của sản phẩm có thể chênh lệch khoảng 3-5%.','SilkySation','Vải Lụa Satin',360000.00,'ACTIVE',0,0,'2025-11-04 18:11:41'),(214,417,'Áo Croptop Tay Phồng','ao-croptop-tay-phong','Thông tin sản phẩm Áo Croptop Tay Phồng:\n- Hàng thiết kế và sản xuất bởi DivaStyle, đảm bảo chất lượng và form dáng.\n- Chất liệu: Vải Kate Forrm cao cấp, thoáng mát, giữ form, và thân thiện với da.\n- Đường may tỉ mỉ, tinh tế, không chỉ thừa, đạt tiêu chuẩn xuất khẩu.\n- Phù hợp mặc đi làm, đi chơi, dạo phố hoặc các sự kiện quan trọng.\n- Thiết kế Áo Croptop Tay Phồng hiện đại, trẻ trung, dễ dàng phối đồ.\n\nCó đủ các size từ S, M, L, XL, XXL (Vui lòng tham khảo bảng size chi tiết).\n\nHướng dẫn sử dụng sản phẩm:\n- Ưu tiên giặt tay ở nhiệt độ thường để giữ độ bền của Vải Kate Forrm.\n- Hạn chế giặt máy. Nếu giặt máy, nên lộn trái sản phẩm và cho vào túi giặt.\n- Không sử dụng thuốc tẩy hoặc ngâm sản phẩm quá lâu.\n- Phơi ở nơi thoáng mát, tránh ánh nắng mặt trời trực tiếp.\n\nĐiều kiện áp dụng đổi sản phẩm (trong vòng 07 ngày kể từ khi nhận sản phẩm):\n- Hàng hoá còn mới, chưa qua sử dụng, còn nguyên tem mác.\n- Hàng hoá bị lỗi hoặc hư hỏng do vận chuyển hoặc do nhà sản xuất.\n\nLưu ý:\n- Do màn hình và điều kiện ánh sáng khác nhau, màu sắc thực tế của sản phẩm có thể chênh lệch khoảng 3-5%.','DivaStyle','Vải Kate Forrm',180000.00,'ACTIVE',0,0,'2025-11-04 18:11:41'),(215,418,'Áo Hoodie Nữ Tai Mèo','ao-hoodie-nu-tai-meo','Thông tin sản phẩm Áo Hoodie Nữ Tai Mèo:\n- Hàng thiết kế và sản xuất bởi CozyWear, đảm bảo chất lượng và form dáng.\n- Chất liệu: Vải Nỉ Bông Mịn cao cấp, ấm áp, giữ form, và thân thiện với da.\n- Đường may tỉ mỉ, tinh tế, không chỉ thừa, đạt tiêu chuẩn xuất khẩu.\n- Phù hợp mặc đi làm, đi chơi, dạo phố hoặc các sự kiện quan trọng.\n- Thiết kế Áo Hoodie Nữ Tai Mèo hiện đại, trẻ trung, dễ dàng phối đồ.\n\nCó đủ các size từ S, M, L, XL, XXL (Vui lòng tham khảo bảng size chi tiết).\n\nHướng dẫn sử dụng sản phẩm:\n- Ưu tiên giặt tay ở nhiệt độ thường để giữ độ bền của Vải Nỉ Bông Mịn.\n- Hạn chế giặt máy. Nếu giặt máy, nên lộn trái sản phẩm và cho vào túi giặt.\n- Không sử dụng thuốc tẩy hoặc ngâm sản phẩm quá lâu.\n- Phơi ở nơi thoáng mát, tránh ánh nắng mặt trời trực tiếp.\n\nĐiều kiện áp dụng đổi sản phẩm (trong vòng 07 ngày kể từ khi nhận sản phẩm):\n- Hàng hoá còn mới, chưa qua sử dụng, còn nguyên tem mác.\n- Hàng hoá bị lỗi hoặc hư hỏng do vận chuyển hoặc do nhà sản xuất.\n\nLưu ý:\n- Do màn hình và điều kiện ánh sáng khác nhau, màu sắc thực tế của sản phẩm có thể chênh lệch khoảng 3-5%.','CozyWear','Vải Nỉ Bông Mịn',480000.00,'ACTIVE',0,0,'2025-11-04 18:11:41'),(216,419,'Áo Khoác Nữ Cardigan','ao-khoac-nu-cardigan','Thông tin sản phẩm Áo Khoác Nữ Cardigan:\n- Hàng thiết kế và sản xuất bởi CozyWear, đảm bảo chất lượng và form dáng.\n- Chất liệu: Vải Len Dệt Kim cao cấp, mềm mại, thoáng mát, giữ form, và thân thiện với da.\n- Đường may tỉ mỉ, tinh tế, không chỉ thừa, đạt tiêu chuẩn xuất khẩu.\n- Phù hợp mặc đi làm, đi chơi, dạo phố hoặc các sự kiện quan trọng.\n- Thiết kế Áo Khoác Nữ Cardigan hiện đại, trẻ trung, dễ dàng phối đồ.\n\nCó đủ các size từ S, M, L, XL, XXL (Vui lòng tham khảo bảng size chi tiết).\n\nHướng dẫn sử dụng sản phẩm:\n- Ưu tiên giặt tay ở nhiệt độ thường để giữ độ bền của Vải Len Dệt Kim.\n- Hạn chế giặt máy. Nếu giặt máy, nên lộn trái sản phẩm và cho vào túi giặt.\n- Không sử dụng thuốc tẩy hoặc ngâm sản phẩm quá lâu.\n- Phơi ở nơi thoáng mát, tránh ánh nắng mặt trời trực tiếp.\n\nĐiều kiện áp dụng đổi sản phẩm (trong vòng 07 ngày kể từ khi nhận sản phẩm):\n- Hàng hoá còn mới, chưa qua sử dụng, còn nguyên tem mác.\n- Hàng hoá bị lỗi hoặc hư hỏng do vận chuyển hoặc do nhà sản xuất.\n\nLưu ý:\n- Do màn hình và điều kiện ánh sáng khác nhau, màu sắc thực tế của sản phẩm có thể chênh lệch khoảng 3-5%.','CozyWear','Vải Len Dệt Kim',390000.00,'ACTIVE',0,0,'2025-11-04 18:11:41'),(217,420,'Quần Jean Nữ Ống Loe','quan-jean-nu-ong-loe','Thông tin sản phẩm Quần Jean Nữ Ống Loe:\n- Hàng thiết kế và sản xuất bởi DivaStyle, đảm bảo chất lượng và form dáng.\n- Chất liệu: Vải Jean Co Giãn cao cấp, tôn dáng, giữ form, và thân thiện với da.\n- Đường may tỉ mỉ, tinh tế, không chỉ thừa, đạt tiêu chuẩn xuất khẩu.\n- Phù hợp mặc đi làm, đi chơi, dạo phố hoặc các sự kiện quan trọng.\n- Thiết kế Quần Jean Nữ Ống Loe hiện đại, trẻ trung, dễ dàng phối đồ.\n\nCó đủ các size từ S, M, L, XL, XXL (Vui lòng tham khảo bảng size chi tiết).\n\nHướng dẫn sử dụng sản phẩm:\n- Ưu tiên giặt tay ở nhiệt độ thường để giữ độ bền của Vải Jean Co Giãn.\n- Hạn chế giặt máy. Nếu giặt máy, nên lộn trái sản phẩm và cho vào túi giặt.\n- Không sử dụng thuốc tẩy hoặc ngâm sản phẩm quá lâu.\n- Phơi ở nơi thoáng mát, tránh ánh nắng mặt trời trực tiếp.\n\nĐiều kiện áp dụng đổi sản phẩm (trong vòng 07 ngày kể từ khi nhận sản phẩm):\n- Hàng hoá còn mới, chưa qua sử dụng, còn nguyên tem mác.\n- Hàng hoá bị lỗi hoặc hư hỏng do vận chuyển hoặc do nhà sản xuất.\n\nLưu ý:\n- Do màn hình và điều kiện ánh sáng khác nhau, màu sắc thực tế của sản phẩm có thể chênh lệch khoảng 3-5%.','DivaStyle','Vải Jean Co Giãn',520000.00,'ACTIVE',0,0,'2025-11-04 18:11:41'),(218,421,'Quần Short Nữ Jean','quan-short-nu-jean','Thông tin sản phẩm Quần Short Nữ Jean:\n- Hàng thiết kế và sản xuất bởi DenimPro, đảm bảo chất lượng và form dáng.\n- Chất liệu: Vải Jean Cotton cao cấp, thoáng mát, giữ form, và thân thiện với da.\n- Đường may tỉ mỉ, tinh tế, không chỉ thừa, đạt tiêu chuẩn xuất khẩu.\n- Phù hợp mặc đi làm, đi chơi, dạo phố hoặc các sự kiện quan trọng.\n- Thiết kế Quần Short Nữ Jean hiện đại, trẻ trung, dễ dàng phối đồ.\n\nCó đủ các size từ S, M, L, XL, XXL (Vui lòng tham khảo bảng size chi tiết).\n\nHướng dẫn sử dụng sản phẩm:\n- Ưu tiên giặt tay ở nhiệt độ thường để giữ độ bền của Vải Jean Cotton.\n- Hạn chế giặt máy. Nếu giặt máy, nên lộn trái sản phẩm và cho vào túi giặt.\n- Không sử dụng thuốc tẩy hoặc ngâm sản phẩm quá lâu.\n- Phơi ở nơi thoáng mát, tránh ánh nắng mặt trời trực tiếp.\n\nĐiều kiện áp dụng đổi sản phẩm (trong vòng 07 ngày kể từ khi nhận sản phẩm):\n- Hàng hoá còn mới, chưa qua sử dụng, còn nguyên tem mác.\n- Hàng hoá bị lỗi hoặc hư hỏng do vận chuyển hoặc do nhà sản xuất.\n\nLưu ý:\n- Do màn hình và điều kiện ánh sáng khác nhau, màu sắc thực tế của sản phẩm có thể chênh lệch khoảng 3-5%.','DenimPro','Vải Jean Cotton',280000.00,'ACTIVE',0,0,'2025-11-04 18:11:41'),(219,422,'Quần Ống Rộng Nữ Vải Tuyết','quan-ong-rong-nu-vai-tuyet','Thông tin sản phẩm Quần Ống Rộng Nữ Vải Tuyết:\n- Hàng thiết kế và sản xuất bởi Elegante, đảm bảo chất lượng và form dáng.\n- Chất liệu: Vải Tuyết Mưa cao cấp, thoáng mát, giữ form, và thân thiện với da.\n- Đường may tỉ mỉ, tinh tế, không chỉ thừa, đạt tiêu chuẩn xuất khẩu.\n- Phù hợp mặc đi làm, đi chơi, dạo phố hoặc các sự kiện quan trọng.\n- Thiết kế Quần Ống Rộng Nữ Vải Tuyết hiện đại, trẻ trung, dễ dàng phối đồ.\n\nCó đủ các size từ S, M, L, XL, XXL (Vui lòng tham khảo bảng size chi tiết).\n\nHướng dẫn sử dụng sản phẩm:\n- Ưu tiên giặt tay ở nhiệt độ thường để giữ độ bền của Vải Tuyết Mưa.\n- Hạn chế giặt máy. Nếu giặt máy, nên lộn trái sản phẩm và cho vào túi giặt.\n- Không sử dụng thuốc tẩy hoặc ngâm sản phẩm quá lâu.\n- Phơi ở nơi thoáng mát, tránh ánh nắng mặt trời trực tiếp.\n\nĐiều kiện áp dụng đổi sản phẩm (trong vòng 07 ngày kể từ khi nhận sản phẩm):\n- Hàng hoá còn mới, chưa qua sử dụng, còn nguyên tem mác.\n- Hàng hoá bị lỗi hoặc hư hỏng do vận chuyển hoặc do nhà sản xuất.\n\nLưu ý:\n- Do màn hình và điều kiện ánh sáng khác nhau, màu sắc thực tế của sản phẩm có thể chênh lệch khoảng 3-5%.','Elegante','Vải Tuyết Mưa',330000.00,'ACTIVE',0,0,'2025-11-04 18:11:41'),(220,423,'Chân Váy Chữ A','chan-vay-chu-a','Thông tin sản phẩm Chân Váy Chữ A:\n- Hàng thiết kế và sản xuất bởi DivaStyle, đảm bảo chất lượng và form dáng.\n- Chất liệu: Vải Kaki Mềm cao cấp, thoáng mát, giữ form, và thân thiện với da.\n- Đường may tỉ mỉ, tinh tế, không chỉ thừa, đạt tiêu chuẩn xuất khẩu.\n- Phù hợp mặc đi làm, đi chơi, dạo phố hoặc các sự kiện quan trọng.\n- Thiết kế Chân Váy Chữ A hiện đại, trẻ trung, dễ dàng phối đồ.\n\nCó đủ các size từ S, M, L, XL, XXL (Vui lòng tham khảo bảng size chi tiết).\n\nHướng dẫn sử dụng sản phẩm:\n- Ưu tiên giặt tay ở nhiệt độ thường để giữ độ bền của Vải Kaki Mềm.\n- Hạn chế giặt máy. Nếu giặt máy, nên lộn trái sản phẩm và cho vào túi giặt.\n- Không sử dụng thuốc tẩy hoặc ngâm sản phẩm quá lâu.\n- Phơi ở nơi thoáng mát, tránh ánh nắng mặt trời trực tiếp.\n\nĐiều kiện áp dụng đổi sản phẩm (trong vòng 07 ngày kể từ khi nhận sản phẩm):\n- Hàng hoá còn mới, chưa qua sử dụng, còn nguyên tem mác.\n- Hàng hoá bị lỗi hoặc hư hỏng do vận chuyển hoặc do nhà sản xuất.\n\nLưu ý:\n- Do màn hình và điều kiện ánh sáng khác nhau, màu sắc thực tế của sản phẩm có thể chênh lệch khoảng 3-5%.','DivaStyle','Vải Kaki Mềm',270000.00,'ACTIVE',0,0,'2025-11-04 18:11:41'),(221,424,'Váy Đầm Maxi Voan','vay-dam-maxi-voan','Thông tin sản phẩm Váy Đầm Maxi Voan:\n- Hàng thiết kế và sản xuất bởi SilkSation, đảm bảo chất lượng và form dáng.\n- Chất liệu: Vải Voan Lụa 2 Lớp cao cấp, bay bổng, thoáng mát, giữ form, và thân thiện với da.\n- Đường may tỉ mỉ, tinh tế, không chỉ thừa, đạt tiêu chuẩn xuất khẩu.\n- Phù hợp mặc đi làm, đi chơi, dạo phố hoặc các sự kiện quan trọng.\n- Thiết kế Váy Đầm Maxi Voan hiện đại, trẻ trung, dễ dàng phối đồ.\n\nCó đủ các size từ S, M, L, XL, XXL (Vui lòng tham khảo bảng size chi tiết).\n\nHướng dẫn sử dụng sản phẩm:\n- Ưu tiên giặt tay ở nhiệt độ thường để giữ độ bền của Vải Voan Lụa 2 Lớp.\n- Hạn chế giặt máy. Nếu giặt máy, nên lộn trái sản phẩm và cho vào túi giặt.\n- Không sử dụng thuốc tẩy hoặc ngâm sản phẩm quá lâu.\n- Phơi ở nơi thoáng mát, tránh ánh nắng mặt trời trực tiếp.\n\nĐiều kiện áp dụng đổi sản phẩm (trong vòng 07 ngày kể từ khi nhận sản phẩm):\n- Hàng hoá còn mới, chưa qua sử dụng, còn nguyên tem mác.\n- Hàng hoá bị lỗi hoặc hư hỏng do vận chuyển hoặc do nhà sản xuất.\n\nLưu ý:\n- Do màn hình và điều kiện ánh sáng khác nhau, màu sắc thực tế của sản phẩm có thể chênh lệch khoảng 3-5%.','SilkySation','Vải Voan Lụa 2 Lớp',600000.00,'ACTIVE',0,0,'2025-11-04 18:11:41'),(222,425,'Quần Legging Gym Nữ','quan-legging-gym-nu','Thông tin sản phẩm Quần Legging Gym Nữ:\r\n- Hàng thiết kế và sản xuất bởi ActiveWear, đảm bảo chất lượng và form dáng.\r\n- Chất liệu: Vải Thun Lạnh 4 Chiều cao cấp, co giãn tối đa, thấm hút mồ hôi, và thân thiện với da.\r\n- Đường may tỉ mỉ, tinh tế, không chỉ thừa, đạt tiêu chuẩn xuất khẩu.\r\n- Phù hợp mặc đi làm, đi chơi, dạo phố hoặc các sự kiện quan trọng.\r\n- Thiết kế Quần Legging Gym Nữ hiện đại, trẻ trung, dễ dàng phối đồ.\r\n\r\nCó đủ các size từ S, M, L, XL, XXL (Vui lòng tham khảo bảng size chi tiết).\r\n\r\nHướng dẫn sử dụng sản phẩm:\r\n- Ưu tiên giặt tay ở nhiệt độ thường để giữ độ bền của Vải Thun Lạnh 4 Chiều.\r\n- Hạn chế giặt máy. Nếu giặt máy, nên lộn trái sản phẩm và cho vào túi giặt.\r\n- Không sử dụng thuốc tẩy hoặc ngâm sản phẩm quá lâu.\r\n- Phơi ở nơi thoáng mát, tránh ánh nắng mặt trời trực tiếp.\r\n\r\nĐiều kiện áp dụng đổi sản phẩm (trong vòng 07 ngày kể từ khi nhận sản phẩm):\r\n- Hàng hoá còn mới, chưa qua sử dụng, còn nguyên tem mác.\r\n- Hàng hoá bị lỗi hoặc hư hỏng do vận chuyển hoặc do nhà sản xuất.\r\n\r\nLưu ý:\r\n- Do màn hình và điều kiện ánh sáng khác nhau, màu sắc thực tế của sản phẩm có thể chênh lệch khoảng 3-5%.','ActiveWear','Vải Thun Lạnh 4 Chiều',310000.00,'ACTIVE',0,0,'2025-11-04 18:11:41'),(223,426,'Quần Short Chạy Bộ 2 Lớp','quan-short-chay-bo-2-lop','Thông tin sản phẩm Quần Short Chạy Bộ 2 Lớp:\n- Hàng thiết kế và sản xuất bởi ActiveWear, đảm bảo chất lượng và form dáng.\n- Chất liệu: Vải Dù Lót Lưới cao cấp, siêu nhẹ, thoáng mát, giữ form, và thân thiện với da.\n- Đường may tỉ mỉ, tinh tế, không chỉ thừa, đạt tiêu chuẩn xuất khẩu.\n- Phù hợp mặc đi làm, đi chơi, dạo phố hoặc các sự kiện quan trọng.\n- Thiết kế Quần Short Chạy Bộ 2 Lớp hiện đại, trẻ trung, dễ dàng phối đồ.\n\nCó đủ các size từ S, M, L, XL, XXL (Vui lòng tham khảo bảng size chi tiết).\n\nHướng dẫn sử dụng sản phẩm:\n- Ưu tiên giặt tay ở nhiệt độ thường để giữ độ bền của Vải Dù Lót Lưới.\n- Hạn chế giặt máy. Nếu giặt máy, nên lộn trái sản phẩm và cho vào túi giặt.\n- Không sử dụng thuốc tẩy hoặc ngâm sản phẩm quá lâu.\n- Phơi ở nơi thoáng mát, tránh ánh nắng mặt trời trực tiếp.\n\nĐiều kiện áp dụng đổi sản phẩm (trong vòng 07 ngày kể từ khi nhận sản phẩm):\n- Hàng hoá còn mới, chưa qua sử dụng, còn nguyên tem mác.\n- Hàng hoá bị lỗi hoặc hư hỏng do vận chuyển hoặc do nhà sản xuất.\n\nLưu ý:\n- Do màn hình và điều kiện ánh sáng khác nhau, màu sắc thực tế của sản phẩm có thể chênh lệch khoảng 3-5%.','ActiveWear','Vải Dù Lót Lưới',260000.00,'ACTIVE',0,0,'2025-11-04 18:11:41'),(224,427,'Đồ Bơi Nữ Một Mảnh','do-boi-nu-mot-manh','Thông tin sản phẩm Đồ Bơi Nữ Một Mảnh:\n- Hàng thiết kế và sản xuất bởi AquaFit, đảm bảo chất lượng và form dáng.\n- Chất liệu: Vải Lycra Bơi Lội cao cấp, co giãn, chống UV, và thân thiện với da.\n- Đường may tỉ mỉ, tinh tế, không chỉ thừa, đạt tiêu chuẩn xuất khẩu.\n- Phù hợp mặc đi làm, đi chơi, dạo phố hoặc các sự kiện quan trọng.\n- Thiết kế Đồ Bơi Nữ Một Mảnh hiện đại, trẻ trung, dễ dàng phối đồ.\n\nCó đủ các size từ S, M, L, XL, XXL (Vui lòng tham khảo bảng size chi tiết).\n\nHướng dẫn sử dụng sản phẩm:\n- Ưu tiên giặt tay ở nhiệt độ thường để giữ độ bền của Vải Lycra Bơi Lội.\n- Hạn chế giặt máy. Nếu giặt máy, nên lộn trái sản phẩm và cho vào túi giặt.\n- Không sử dụng thuốc tẩy hoặc ngâm sản phẩm quá lâu.\n- Phơi ở nơi thoáng mát, tránh ánh nắng mặt trời trực tiếp.\n\nĐiều kiện áp dụng đổi sản phẩm (trong vòng 07 ngày kể từ khi nhận sản phẩm):\n- Hàng hoá còn mới, chưa qua sử dụng, còn nguyên tem mác.\n- Hàng hoá bị lỗi hoặc hư hỏng do vận chuyển hoặc do nhà sản xuất.\n\nLưu ý:\n- Do màn hình và điều kiện ánh sáng khác nhau, màu sắc thực tế của sản phẩm có thể chênh lệch khoảng 3-5%.','AquaFit','Vải Lycra Bơi Lội',450000.00,'ACTIVE',0,0,'2025-11-04 18:11:41'),(225,428,'Áo Khoác Thể Thao Chống Nắng','ao-khoac-the-thao-chong-nang','Thông tin sản phẩm Áo Khoác Thể Thao Chống Nắng:\n- Hàng thiết kế và sản xuất bởi ActiveWear, đảm bảo chất lượng và form dáng.\n- Chất liệu: Vải Thun Lạnh (UPF 50+) cao cấp, thoáng mát, chống tia UV, và thân thiện với da.\n- Đường may tỉ mỉ, tinh tế, không chỉ thừa, đạt tiêu chuẩn xuất khẩu.\n- Phù hợp mặc đi làm, đi chơi, dạo phố hoặc các sự kiện quan trọng.\n- Thiết kế Áo Khoác Thể Thao Chống Nắng hiện đại, trẻ trung, dễ dàng phối đồ.\n\nCó đủ các size từ S, M, L, XL, XXL (Vui lòng tham khảo bảng size chi tiết).\n\nHướng dẫn sử dụng sản phẩm:\n- Ưu tiên giặt tay ở nhiệt độ thường để giữ độ bền của Vải Thun Lạnh (UPF 50+).\n- Hạn chế giặt máy. Nếu giặt máy, nên lộn trái sản phẩm và cho vào túi giặt.\n- Không sử dụng thuốc tẩy hoặc ngâm sản phẩm quá lâu.\n- Phơi ở nơi thoáng mát, tránh ánh nắng mặt trời trực tiếp.\n\nĐiều kiện áp dụng đổi sản phẩm (trong vòng 07 ngày kể từ khi nhận sản phẩm):\n- Hàng hoá còn mới, chưa qua sử dụng, còn nguyên tem mác.\n- Hàng hoá bị lỗi hoặc hư hỏng do vận chuyển hoặc do nhà sản xuất.\n\nLưu ý:\n- Do màn hình và điều kiện ánh sáng khác nhau, màu sắc thực tế của sản phẩm có thể chênh lệch khoảng 3-5%.','ActiveWear','Vải Thun Lạnh (UPF 50+)',300000.00,'ACTIVE',0,0,'2025-11-04 18:11:41'),(226,429,'Áo Khoác Da Lót Lông','ao-khoac-da-lot-long','Thông tin sản phẩm Áo Khoác Da Lót Lông:\n- Hàng thiết kế và sản xuất bởi LeatherLux, đảm bảo chất lượng và form dáng.\n- Chất liệu: Da PU Cao Cấp Lót Lông Cừu cao cấp, siêu ấm, giữ form, và thân thiện với da.\n- Đường may tỉ mỉ, tinh tế, không chỉ thừa, đạt tiêu chuẩn xuất khẩu.\n- Phù hợp mặc đi làm, đi chơi, dạo phố hoặc các sự kiện quan trọng.\n- Thiết kế Áo Khoác Da Lót Lông hiện đại, trẻ trung, dễ dàng phối đồ.\n\nCó đủ các size từ S, M, L, XL, XXL (Vui lòng tham khảo bảng size chi tiết).\n\nHướng dẫn sử dụng sản phẩm:\n- Ưu tiên giặt tay ở nhiệt độ thường để giữ độ bền của Da PU Cao Cấp Lót Lông Cừu.\n- Hạn chế giặt máy. Nếu giặt máy, nên lộn trái sản phẩm và cho vào túi giặt.\n- Không sử dụng thuốc tẩy hoặc ngâm sản phẩm quá lâu.\n- Phơi ở nơi thoáng mát, tránh ánh nắng mặt trời trực tiếp.\n\nĐiều kiện áp dụng đổi sản phẩm (trong vòng 07 ngày kể từ khi nhận sản phẩm):\n- Hàng hoá còn mới, chưa qua sử dụng, còn nguyên tem mác.\n- Hàng hoá bị lỗi hoặc hư hỏng do vận chuyển hoặc do nhà sản xuất.\n\nLưu ý:\n- Do màn hình và điều kiện ánh sáng khác nhau, màu sắc thực tế của sản phẩm có thể chênh lệch khoảng 3-5%.','LeatherLux','Da PU Cao Cấp Lót Lông Cừu',1500000.00,'ACTIVE',0,0,'2025-11-04 18:11:41'),(227,430,'Ví Da Bò Thật','vi-da-bo-that','Thông tin sản phẩm Ví Da Bò Thật:\n- Hàng thiết kế cao cấp bởi LeatherLux.\n- Chất liệu: Da Bò Thật 100% siêu bền, chống mài mòn và chịu lực tốt.\n- Đường may/khóa kéo/mối nối tỉ mỉ, tinh tế, không chi tiết thừa.\n- Thiết kế đa dụng, vừa thời trang vừa tiện lợi, phù hợp cho mọi hoàn cảnh.\n\nHướng dẫn bảo quản sản phẩm:\n- Để sản phẩm ở nơi khô ráo, thoáng mát.\n- Không để sản phẩm tiếp xúc trực tiếp với hóa chất, xà phòng.\n- Vệ sinh sản phẩm bằng khăn ẩm, lau nhẹ nhàng.\n- Tránh phơi trực tiếp dưới ánh nắng mặt trời gắt.\n\nĐiều kiện áp dụng đổi sản phẩm (trong vòng 07 ngày kể từ khi nhận sản phẩm):\n- Hàng hoá còn mới, chưa qua sử dụng, còn nguyên tem mác.\n- Hàng hoá bị lỗi hoặc hư hỏng do vận chuyển hoặc do nhà sản xuất.\n\nLưu ý:\n- Do màn hình và điều kiện ánh sáng khác nhau, màu sắc thực tế của sản phẩm có thể chênh lệch khoảng 3-5%.','LeatherLux','Da Bò Thật 100%',500000.00,'ACTIVE',0,0,'2025-11-04 18:11:41'),(228,431,'Giày Da Nam Công Sở','giay-da-nam-cong-so','Thông tin sản phẩm Giày Da Nam Công Sở:\n- Hàng thiết kế cao cấp bởi Elegante.\n- Chất liệu: Da Bò Nhập Khẩu siêu bền, chống mài mòn và chịu lực tốt.\n- Đường may/khóa kéo/mối nối tỉ mỉ, tinh tế, không chi tiết thừa.\n- Thiết kế đa dụng, vừa thời trang vừa tiện lợi, phù hợp cho mọi hoàn cảnh.\n\nHướng dẫn bảo quản sản phẩm:\n- Để sản phẩm ở nơi khô ráo, thoáng mát.\n- Không để sản phẩm tiếp xúc trực tiếp với hóa chất, xà phòng.\n- Vệ sinh sản phẩm bằng khăn ẩm, lau nhẹ nhàng.\n- Tránh phơi trực tiếp dưới ánh nắng mặt trời gắt.\n\nĐiều kiện áp dụng đổi sản phẩm (trong vòng 07 ngày kể từ khi nhận sản phẩm):\n- Hàng hoá còn mới, chưa qua sử dụng, còn nguyên tem mác.\n- Hàng hoá bị lỗi hoặc hư hỏng do vận chuyển hoặc do nhà sản xuất.\n\nLưu ý:\n- Do màn hình và điều kiện ánh sáng khác nhau, màu sắc thực tế của sản phẩm có thể chênh lệch khoảng 3-5%.','Elegante','Da Bò Nhập Khẩu',1300000.00,'ACTIVE',0,0,'2025-11-04 18:11:41'),(229,432,'Mũ Lưỡi Trai (Nón Kết)','mu-luoi-trai-non-ket','Thông tin sản phẩm Mũ Lưỡi Trai (Nón Kết):\n- Hàng thiết kế cao cấp bởi UrbanFlex.\n- Chất liệu: Vải Kaki Cotton siêu bền, chống mài mòn và chịu lực tốt.\n- Đường may/khóa kéo/mối nối tỉ mỉ, tinh tế, không chi tiết thừa.\n- Thiết kế đa dụng, vừa thời trang vừa tiện lợi, phù hợp cho mọi hoàn cảnh.\n\nHướng dẫn bảo quản sản phẩm:\n- Để sản phẩm ở nơi khô ráo, thoáng mát.\n- Không để sản phẩm tiếp xúc trực tiếp với hóa chất, xà phòng.\n- Vệ sinh sản phẩm bằng khăn ẩm, lau nhẹ nhàng.\n- Tránh phơi trực tiếp dưới ánh nắng mặt trời gắt.\n\nĐiều kiện áp dụng đổi sản phẩm (trong vòng 07 ngày kể từ khi nhận sản phẩm):\n- Hàng hoá còn mới, chưa qua sử dụng, còn nguyên tem mác.\n- Hàng hoá bị lỗi hoặc hư hỏng do vận chuyển hoặc do nhà sản xuất.\n\nLưu ý:\n- Do màn hình và điều kiện ánh sáng khác nhau, màu sắc thực tế của sản phẩm có thể chênh lệch khoảng 3-5%.','UrbanFlex','Vải Kaki Cotton',150000.00,'ACTIVE',0,0,'2025-11-04 18:11:41'),(230,433,'Balo Laptop Chống Nước','balo-laptop-chong-nuoc','Thông tin sản phẩm Balo Laptop Chống Nước:\n- Hàng thiết kế cao cấp bởi PackSafe.\n- Chất liệu: Vải Oxford Chống Thấm siêu bền, chống mài mòn và chịu lực tốt.\n- Đường may/khóa kéo/mối nối tỉ mỉ, tinh tế, không chi tiết thừa.\n- Thiết kế đa dụng, vừa thời trang vừa tiện lợi, phù hợp cho mọi hoàn cảnh.\n\nHướng dẫn bảo quản sản phẩm:\n- Để sản phẩm ở nơi khô ráo, thoáng mát.\n- Không để sản phẩm tiếp xúc trực tiếp với hóa chất, xà phòng.\n- Vệ sinh sản phẩm bằng khăn ẩm, lau nhẹ nhàng.\n- Tránh phơi trực tiếp dưới ánh nắng mặt trời gắt.\n\nĐiều kiện áp dụng đổi sản phẩm (trong vòng 07 ngày kể từ khi nhận sản phẩm):\n- Hàng hoá còn mới, chưa qua sử dụng, còn nguyên tem mác.\n- Hàng hoá bị lỗi hoặc hư hỏng do vận chuyển hoặc do nhà sản xuất.\n\nLưu ý:\n- Do màn hình và điều kiện ánh sáng khác nhau, màu sắc thực tế của sản phẩm có thể chênh lệch khoảng 3-5%.','PackSafe','Vải Oxford Chống Thấm',700000.00,'ACTIVE',0,0,'2025-11-04 18:11:41'),(231,434,'Kính Mát Gọng Tròn','kinh-mat-gong-tron','Thông tin sản phẩm Kính Mát Gọng Tròn:\n- Hàng thiết kế cao cấp bởi SunShade.\n- Chất liệu: Gọng Hợp Kim & Tròng Kính Polarized siêu bền, chống UV400, và chịu lực tốt.\n- Đường may/khóa kéo/mối nối tỉ mỉ, tinh tế, không chi tiết thừa.\n- Thiết kế đa dụng, vừa thời trang vừa tiện lợi, phù hợp cho mọi hoàn cảnh.\n\nHướng dẫn bảo quản sản phẩm:\n- Để sản phẩm ở nơi khô ráo, thoáng mát.\n- Không để sản phẩm tiếp xúc trực tiếp với hóa chất, xà phòng.\n- Vệ sinh sản phẩm bằng khăn ẩm, lau nhẹ nhàng.\n- Tránh phơi trực tiếp dưới ánh nắng mặt trời gắt.\n\nĐiều kiện áp dụng đổi sản phẩm (trong vòng 07 ngày kể từ khi nhận sản phẩm):\n- Hàng hoá còn mới, chưa qua sử dụng, còn nguyên tem mác.\n- Hàng hoá bị lỗi hoặc hư hỏng do vận chuyển hoặc do nhà sản xuất.\n\nLưu ý:\n- Do màn hình và điều kiện ánh sáng khác nhau, màu sắc thực tế của sản phẩm có thể chênh lệch khoảng 3-5%.','SunShade','Gọng Hợp Kim & Tròng Kính Polarized',350000.00,'ACTIVE',0,0,'2025-11-04 18:11:41'),(232,435,'Tất Cổ Cao (Vớ)','tat-co-cao-vo','Thông tin sản phẩm Tất Cổ Cao (Vớ):\r\n- Hàng thiết kế cao cấp bởi CozyWear.\r\n- Chất liệu: Cotton 100% siêu bền, thoáng khí, khử mùi và chịu lực tốt.\r\n- Đường may/khóa kéo/mối nối tỉ mỉ, tinh tế, không chi tiết thừa.\r\n- Thiết kế đa dụng, vừa thời trang vừa tiện lợi, phù hợp cho mọi hoàn cảnh.\r\n\r\nHướng dẫn bảo quản sản phẩm:\r\n- Để sản phẩm ở nơi khô ráo, thoáng mát.\r\n- Không để sản phẩm tiếp xúc trực tiếp với hóa chất, xà phòng.\r\n- Vệ sinh sản phẩm bằng khăn ẩm, lau nhẹ nhàng.\r\n- Tránh phơi trực tiếp dưới ánh nắng mặt trời gắt.\r\n\r\nĐiều kiện áp dụng đổi sản phẩm (trong vòng 07 ngày kể từ khi nhận sản phẩm):\r\n- Hàng hoá còn mới, chưa qua sử dụng, còn nguyên tem mác.\r\n- Hàng hoá bị lỗi hoặc hư hỏng do vận chuyển hoặc do nhà sản xuất.\r\n\r\nLưu ý:\r\n- Do màn hình và điều kiện ánh sáng khác nhau, màu sắc thực tế của sản phẩm có thể chênh lệch khoảng 3-5%.','CozyWear','Cotton 100%',50000.00,'ACTIVE',0,0,'2025-11-04 18:11:41'),(233,436,'Thắt Lưng Da Nam','that-lung-da-nam','Thông tin sản phẩm Thắt Lưng Da Nam:\r\n- Hàng thiết kế cao cấp bởi GentleWear.\r\n- Chất liệu: Da Bò Cao Cấp siêu bền, chống mài mòn và chịu lực tốt.\r\n- Đường may/khóa kéo/mối nối tỉ mỉ, tinh tế, không chi tiết thừa.\r\n- Thiết kế đa dụng, vừa thời trang vừa tiện lợi, phù hợp cho mọi hoàn cảnh.\r\n\r\nHướng dẫn bảo quản sản phẩm:\r\n- Để sản phẩm ở nơi khô ráo, thoáng mát.\r\n- Không để sản phẩm tiếp xúc trực tiếp với hóa chất, xà phòng.\r\n- Vệ sinh sản phẩm bằng khăn ẩm, lau nhẹ nhàng.\r\n- Tránh phơi trực tiếp dưới ánh nắng mặt trời gắt.\r\n\r\nĐiều kiện áp dụng đổi sản phẩm (trong vòng 07 ngày kể từ khi nhận sản phẩm):\r\n- Hàng hoá còn mới, chưa qua sử dụng, còn nguyên tem mác.\r\n- Hàng hoá bị lỗi hoặc hư hỏng do vận chuyển hoặc do nhà sản xuất.\r\n\r\nLưu ý:\r\n- Do màn hình và điều kiện ánh sáng khác nhau, màu sắc thực tế của sản phẩm có thể chênh lệch khoảng 3-5%.','GentleWear','Da Bò Cao Cấp',400000.00,'ACTIVE',0,0,'2025-11-04 18:11:41'),(249,409,'Áo Thun Nữ Form Rộng1','ao-thun-nu-form-rong1','aaaa','aaaa','aaaa',1000000.00,'ACTIVE',0,0,'2025-11-22 20:29:58'),(250,409,'Áo Thun Nữ Form Rộngs','ao-thun-nu-form-rongs','bbbb','bbbbb','bbbb',100000.00,'ACTIVE',0,0,'2025-11-22 20:36:52'),(251,439,'Quần Kaki Nam Dáng Slims','quan-kaki-nam-dang-slims','ffff','DivaStyle','fffff',100000.00,'ACTIVE',0,0,'2025-11-22 20:41:46'),(253,446,'áo nam mùa đông 1','ao-nam-mua-dong-1','aaaaaaaaaaaa','DivaStyle','Cotton 100% 2 chiều',100000.00,'ACTIVE',0,0,'2025-11-27 08:36:36');
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
) ENGINE=InnoDB AUTO_INCREMENT=37 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `thanhtoan`
--

LOCK TABLES `thanhtoan` WRITE;
/*!40000 ALTER TABLE `thanhtoan` DISABLE KEYS */;
INSERT INTO `thanhtoan` VALUES (2,1002,701,99000.00,'2025-11-02 20:13:11','',NULL),(3,1003,701,498000.00,'2025-11-02 23:39:57','',NULL),(4,1004,701,99000.00,'2025-11-03 00:50:41','',NULL),(5,1005,701,399000.00,'2025-11-03 02:24:47','',NULL),(6,1006,701,149000.00,'2025-11-03 17:14:26','PENDING',NULL),(7,1007,701,399000.00,'2025-11-03 18:08:23','',NULL),(8,1008,701,327000.00,'2025-11-03 20:34:01','PENDING',NULL),(9,1009,702,300000.00,'2025-11-05 15:44:19','PENDING',NULL),(10,1010,701,399000.00,'2025-11-06 00:53:41','FAILED',NULL),(12,1012,701,300000.00,'2025-11-08 08:02:36','PENDING',NULL),(13,1013,701,300000.00,'2025-11-08 09:43:31','PENDING',NULL),(14,1014,701,129000.00,'2025-11-08 10:29:36','FAILED',NULL),(15,1015,701,429000.00,'2025-11-08 10:30:15','PENDING',NULL),(16,1016,701,129000.00,'2025-11-08 17:25:20','PENDING',NULL),(17,1017,701,210000.00,'2025-11-08 18:50:15','FAILED',NULL),(18,1018,701,129000.00,'2025-11-08 19:58:16','PENDING',NULL),(19,1019,701,429000.00,'2025-11-08 21:06:21','PENDING',NULL),(20,1020,701,300000.00,'2025-11-08 21:17:02','PENDING',NULL),(21,1021,701,300000.00,'2025-11-09 17:35:23','PENDING',NULL),(22,1022,701,408000.00,'2025-11-09 17:43:44','PENDING',NULL),(23,1023,701,410000.00,'2025-11-09 17:46:27','PENDING',NULL),(24,1024,701,178000.00,'2025-11-09 18:12:34','FAILED',NULL),(25,1025,701,370000.00,'2025-11-09 19:32:04','PENDING',NULL),(26,1026,701,542000.00,'2025-11-12 23:04:46','PENDING',NULL),(27,1027,701,879000.00,'2025-11-12 23:34:19','PENDING',NULL),(28,1028,701,255000.00,'2025-11-12 23:39:31','PENDING',NULL),(29,1029,701,912000.00,'2025-11-12 23:41:16','PENDING',NULL),(30,1030,701,210000.00,'2025-11-14 18:59:26','PENDING',NULL),(31,1031,701,255000.00,'2025-11-14 19:06:42','PENDING',NULL),(32,1032,702,210000.00,'2025-11-21 13:57:11','FAILED',NULL),(33,1033,701,1209000.00,'2025-11-22 12:58:55','PENDING',NULL),(34,1034,702,129000.00,'2025-11-22 21:01:55','PENDING',NULL),(35,1035,703,628000.00,'2025-12-03 17:11:16','PENDING',NULL),(36,1036,703,628000.00,'2025-12-03 17:11:38','PENDING',NULL);
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
INSERT INTO `yeuthich` VALUES (4,5003,'2025-11-25 07:44:01'),(6,5001,'2025-11-01 15:40:00'),(7,5026,'2025-11-06 00:50:11'),(19,5033,'2025-11-24 08:11:49');
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

-- Dump completed on 2025-12-03 18:04:35
