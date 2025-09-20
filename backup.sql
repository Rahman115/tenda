Enter password: 
/*M!999999\- enable the sandbox mode */ 
-- MariaDB dump 10.19-12.0.2-MariaDB, for Android (aarch64)
--
-- Host: localhost    Database: tenda
-- ------------------------------------------------------
-- Server version	12.0.2-MariaDB

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*M!100616 SET @OLD_NOTE_VERBOSITY=@@NOTE_VERBOSITY, NOTE_VERBOSITY=0 */;

--
-- Table structure for table `barang`
--

DROP TABLE IF EXISTS `barang`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `barang` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `nama` varchar(100) NOT NULL,
  `harga` decimal(15,2) NOT NULL,
  `satuan` varchar(20) NOT NULL,
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `barang`
--

LOCK TABLES `barang` WRITE;
/*!40000 ALTER TABLE `barang` DISABLE KEYS */;
set autocommit=0;
/*!40000 ALTER TABLE `barang` ENABLE KEYS */;
UNLOCK TABLES;
commit;

--
-- Table structure for table `detail_pekerjaan`
--

DROP TABLE IF EXISTS `detail_pekerjaan`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `detail_pekerjaan` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `pekerjaan_id` int(11) NOT NULL,
  `barang_id` int(11) NOT NULL,
  `quantity` int(11) NOT NULL,
  `subtotal` decimal(15,2) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `pekerjaan_id` (`pekerjaan_id`),
  KEY `barang_id` (`barang_id`),
  CONSTRAINT `detail_pekerjaan_ibfk_1` FOREIGN KEY (`pekerjaan_id`) REFERENCES `pekerjaan` (`id`) ON DELETE CASCADE,
  CONSTRAINT `detail_pekerjaan_ibfk_2` FOREIGN KEY (`barang_id`) REFERENCES `barang` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `detail_pekerjaan`
--

LOCK TABLES `detail_pekerjaan` WRITE;
/*!40000 ALTER TABLE `detail_pekerjaan` DISABLE KEYS */;
set autocommit=0;
/*!40000 ALTER TABLE `detail_pekerjaan` ENABLE KEYS */;
UNLOCK TABLES;
commit;

--
-- Table structure for table `jobs`
--

DROP TABLE IF EXISTS `jobs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `jobs` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `pekerjaan_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `pekerjaan_id` (`pekerjaan_id`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `jobs_ibfk_1` FOREIGN KEY (`pekerjaan_id`) REFERENCES `pekerjaan` (`id`) ON DELETE CASCADE,
  CONSTRAINT `jobs_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=27 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `jobs`
--

LOCK TABLES `jobs` WRITE;
/*!40000 ALTER TABLE `jobs` DISABLE KEYS */;
set autocommit=0;
INSERT INTO `jobs` VALUES
(1,1,2),
(2,1,3),
(3,1,5),
(4,1,7),
(5,2,5),
(6,2,7),
(7,2,8),
(8,3,2),
(9,3,4),
(10,3,5),
(11,3,7),
(12,3,8),
(13,4,2),
(14,4,3),
(15,4,4),
(16,4,7),
(17,4,8),
(18,5,2),
(19,5,3),
(20,5,4),
(21,5,5),
(22,6,2),
(23,6,4),
(24,6,5),
(25,6,7),
(26,6,8);
/*!40000 ALTER TABLE `jobs` ENABLE KEYS */;
UNLOCK TABLES;
commit;

--
-- Table structure for table `pekerjaan`
--

DROP TABLE IF EXISTS `pekerjaan`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `pekerjaan` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `jumlah_orang` int(11) NOT NULL,
  `lokasi` varchar(255) NOT NULL,
  `jumlah_lokal` int(11) NOT NULL,
  `status` enum('ps','bkr') NOT NULL COMMENT 'ps: Pasang, bkr: Bongkar',
  `tanggal` date NOT NULL,
  `status_pembayaran` enum('yes','no') NOT NULL DEFAULT 'no',
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `pekerjaan`
--

LOCK TABLES `pekerjaan` WRITE;
/*!40000 ALTER TABLE `pekerjaan` DISABLE KEYS */;
set autocommit=0;
INSERT INTO `pekerjaan` VALUES
(1,4,'Geresa',2,'ps','2025-09-18','no','2025-09-19 06:02:28','2025-09-19 06:02:28'),
(2,3,'SMP 3',1,'ps','2025-09-18','no','2025-09-19 06:02:28','2025-09-19 06:02:28'),
(3,5,'Papa Rin',4,'ps','2025-09-18','no','2025-09-19 06:02:28','2025-09-19 06:02:28'),
(4,5,'Arman Ani',2,'bkr','2025-09-19','no','2025-09-19 06:02:28','2025-09-19 06:02:28'),
(5,4,'rmh riati',2,'ps','2025-09-15','no','2025-09-19 09:55:31','2025-09-19 09:55:31'),
(6,5,'rmh riati',2,'bkr','2025-09-18','no','2025-09-19 09:55:31','2025-09-19 09:55:31');
/*!40000 ALTER TABLE `pekerjaan` ENABLE KEYS */;
UNLOCK TABLES;
commit;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `users` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `username` varchar(50) NOT NULL,
  `password` varchar(255) NOT NULL,
  `nama_lengkap` varchar(100) NOT NULL,
  `role` enum('admin','user') DEFAULT 'user',
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `username` (`username`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
set autocommit=0;
INSERT INTO `users` VALUES
(1,'admin','8c6976e5b5410415bde908bd4dee15dfb167a9c873fc4bb8a81f6f2ab448a918','Administrator Sistem','admin','2025-09-19 05:24:53'),
(2,'laiba','ba7816bf8f01cfea414140de5dae2223b00361a396177a9cb410ff61f20015ad','Hasaruddin','user','2025-09-19 05:30:36'),
(3,'rasyid','ba7816bf8f01cfea414140de5dae2223b00361a396177a9cb410ff61f20015ad','Rasyid Makmur','user','2025-09-19 05:30:36'),
(4,'idar','ba7816bf8f01cfea414140de5dae2223b00361a396177a9cb410ff61f20015ad','Idarlan','user','2025-09-19 05:30:36'),
(5,'lani','ba7816bf8f01cfea414140de5dae2223b00361a396177a9cb410ff61f20015ad','Marlan','user','2025-09-19 05:30:36'),
(6,'yus','ba7816bf8f01cfea414140de5dae2223b00361a396177a9cb410ff61f20015ad','Yusril','user','2025-09-19 05:30:36'),
(7,'abudu','ba7816bf8f01cfea414140de5dae2223b00361a396177a9cb410ff61f20015ad','Abd. Rahman A. M','user','2025-09-19 05:32:18'),
(8,'om','ba7816bf8f01cfea414140de5dae2223b00361a396177a9cb410ff61f20015ad','Om','user','2025-09-19 09:42:03');
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;
commit;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*M!100616 SET NOTE_VERBOSITY=@OLD_NOTE_VERBOSITY */;

-- Dump completed on 2025-09-21  1:16:21
