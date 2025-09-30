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
-- Table structure for table `detail_kerjaan`
--

DROP TABLE IF EXISTS `detail_kerjaan`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `detail_kerjaan` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `uuid` char(36) NOT NULL DEFAULT uuid(),
  `jumlah_orang` int(11) NOT NULL,
  `jenis` enum('tenda','panggung','gapura') NOT NULL,
  `jumlah_unit` decimal(5,2) NOT NULL,
  `status` enum('ps','bkr') NOT NULL COMMENT 'ps: Pasang, bkr: Bongkar',
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `id_kerjaan` char(36) NOT NULL,
  `tanggal` date DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uuid` (`uuid`),
  KEY `fk_detail_kerjaan_uuid` (`id_kerjaan`),
  CONSTRAINT `fk_detail_kerjaan_uuid` FOREIGN KEY (`id_kerjaan`) REFERENCES `kerjaan` (`uuid`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=27 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `detail_kerjaan`
--

LOCK TABLES `detail_kerjaan` WRITE;
/*!40000 ALTER TABLE `detail_kerjaan` DISABLE KEYS */;
set autocommit=0;
INSERT INTO `detail_kerjaan` VALUES
(3,'b50399b5-993a-11f0-8a7a-5ea00c5897ec',5,'tenda',4.00,'ps','2025-09-24 11:36:27','2025-09-24 11:36:27','24eb04c7-9781-11f0-b5ce-239da9796382','2025-09-18'),
(4,'29ae8ee3-993b-11f0-8a7a-5ea00c5897ec',5,'tenda',4.00,'bkr','2025-09-24 11:39:42','2025-09-24 11:39:42','24eb04c7-9781-11f0-b5ce-239da9796382','2025-09-22'),
(5,'4d584800-9949-11f0-8a7a-5ea00c5897ec',3,'tenda',1.00,'ps','2025-09-24 13:20:55','2025-09-24 13:20:55','24eb0385-9781-11f0-b5ce-239da9796382','2025-09-18'),
(6,'ac5dd8bf-9949-11f0-8a7a-5ea00c5897ec',3,'tenda',1.00,'bkr','2025-09-24 13:23:35','2025-09-24 13:23:35','24eb0385-9781-11f0-b5ce-239da9796382','2025-09-21'),
(7,'fb3d6e66-9949-11f0-8a7a-5ea00c5897ec',4,'tenda',2.00,'ps','2025-09-24 13:25:47','2025-09-24 13:25:47','24eafebd-9781-11f0-b5ce-239da9796382','2025-09-18'),
(8,'16171b1d-994a-11f0-8a7a-5ea00c5897ec',5,'tenda',2.00,'bkr','2025-09-24 13:26:32','2025-09-24 13:26:32','24eafebd-9781-11f0-b5ce-239da9796382','2025-09-20'),
(9,'cd1e7e2b-994b-11f0-8a7a-5ea00c5897ec',4,'tenda',2.00,'ps','2025-09-24 13:41:10','2025-09-24 13:41:10','24ead4f0-9781-11f0-b5ce-239da9796382','2025-09-15'),
(10,'e966df06-994b-11f0-8a7a-5ea00c5897ec',5,'tenda',2.00,'bkr','2025-09-24 13:41:57','2025-09-24 13:41:57','24ead4f0-9781-11f0-b5ce-239da9796382','2025-09-18'),
(11,'111be7ef-994c-11f0-8a7a-5ea00c5897ec',5,'tenda',2.00,'bkr','2025-09-24 13:43:04','2025-09-24 13:43:04','fda5e44f-977e-11f0-b5ce-239da9796382','2025-09-19'),
(12,'3a19da26-994c-11f0-8a7a-5ea00c5897ec',4,'tenda',2.00,'ps','2025-09-24 13:44:13','2025-09-24 13:44:13','fda5e44f-977e-11f0-b5ce-239da9796382','2025-09-12'),
(13,'a171cb8e-9a3a-11f0-86c8-2f058cafc7d9',5,'tenda',4.00,'ps','2025-09-26 02:42:39','2025-09-26 02:42:39','68fe0012-9a39-11f0-86c8-2f058cafc7d9','2025-09-23'),
(14,'f35422f3-9a3a-11f0-86c8-2f058cafc7d9',5,'tenda',2.00,'ps','2025-09-26 02:44:57','2025-09-26 02:44:57','e095ac99-9a3a-11f0-86c8-2f058cafc7d9','2025-09-23'),
(15,'02d9e055-9a3b-11f0-86c8-2f058cafc7d9',5,'panggung',1.00,'ps','2025-09-26 02:45:23','2025-09-26 02:45:23','e095ac99-9a3a-11f0-86c8-2f058cafc7d9','2025-09-24'),
(16,'69cfffce-9b78-11f0-8bcf-3d449d4688d7',5,'tenda',5.00,'ps','2025-09-27 08:03:12','2025-09-27 08:03:12','5af0e30f-9b78-11f0-8bcf-3d449d4688d7','2025-09-25'),
(17,'7365e83c-9b78-11f0-8bcf-3d449d4688d7',5,'gapura',1.00,'ps','2025-09-27 08:03:28','2025-09-27 08:03:28','5af0e30f-9b78-11f0-8bcf-3d449d4688d7','2025-09-25'),
(18,'c64ea4cc-9b78-11f0-8bcf-3d449d4688d7',5,'tenda',4.00,'bkr','2025-09-27 08:05:47','2025-09-27 08:05:47','68fe0012-9a39-11f0-86c8-2f058cafc7d9','2025-09-27'),
(19,'4b2ef33e-9d2e-11f0-8219-8f13b2443d65',5,'tenda',3.00,'ps','2025-09-29 13:30:17','2025-09-29 13:30:17','e930463e-9d2d-11f0-8219-8f13b2443d65','2025-09-29'),
(20,'56585a34-9d2e-11f0-8219-8f13b2443d65',5,'panggung',1.00,'ps','2025-09-29 13:30:36','2025-09-29 13:30:36','e930463e-9d2d-11f0-8219-8f13b2443d65','2025-09-29'),
(21,'a652033f-9d2e-11f0-8219-8f13b2443d65',5,'tenda',3.00,'bkr','2025-09-29 13:32:50','2025-09-29 13:32:50','5af0e30f-9b78-11f0-8bcf-3d449d4688d7','2025-09-28'),
(22,'b2805854-9d2e-11f0-8219-8f13b2443d65',4,'tenda',2.00,'bkr','2025-09-29 13:33:10','2025-09-29 13:33:10','5af0e30f-9b78-11f0-8bcf-3d449d4688d7','2025-09-29'),
(23,'c4add2b3-9d2e-11f0-8219-8f13b2443d65',5,'gapura',1.00,'bkr','2025-09-29 13:33:41','2025-09-29 13:33:41','5af0e30f-9b78-11f0-8bcf-3d449d4688d7','2025-09-28'),
(24,'1d9d8cfd-9d2f-11f0-8219-8f13b2443d65',5,'gapura',2.00,'ps','2025-09-29 13:36:10','2025-09-29 13:36:10','10003348-9d2f-11f0-8219-8f13b2443d65','2025-09-28'),
(25,'f8e10d93-9dc9-11f0-91db-4e8fe5cb4b15',5,'tenda',1.00,'ps','2025-09-30 06:57:08','2025-09-30 06:57:08','e58c3898-9dc9-11f0-91db-4e8fe5cb4b15','2025-09-25'),
(26,'0fb61658-9dca-11f0-91db-4e8fe5cb4b15',4,'tenda',1.00,'bkr','2025-09-30 06:57:47','2025-09-30 06:57:47','e58c3898-9dc9-11f0-91db-4e8fe5cb4b15','2025-09-29');
/*!40000 ALTER TABLE `detail_kerjaan` ENABLE KEYS */;
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
) ENGINE=InnoDB AUTO_INCREMENT=40 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;
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
(26,6,8),
(27,7,8),
(28,7,7),
(29,7,2),
(30,7,5),
(31,7,3),
(32,8,2),
(33,8,7),
(34,8,8),
(35,9,2),
(36,9,3),
(37,9,4),
(38,9,7),
(39,9,8);
/*!40000 ALTER TABLE `jobs` ENABLE KEYS */;
UNLOCK TABLES;
commit;

--
-- Table structure for table `kerjaan`
--

DROP TABLE IF EXISTS `kerjaan`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `kerjaan` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `uuid` char(36) NOT NULL DEFAULT uuid(),
  `pengguna` varchar(255) NOT NULL,
  `lokasi` varchar(255) NOT NULL,
  `tanggal` date NOT NULL,
  `status_pembayaran` enum('yes','no') NOT NULL DEFAULT 'no',
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `uuid` (`uuid`)
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `kerjaan`
--

LOCK TABLES `kerjaan` WRITE;
/*!40000 ALTER TABLE `kerjaan` DISABLE KEYS */;
set autocommit=0;
INSERT INTO `kerjaan` VALUES
(1,'fda5e44f-977e-11f0-b5ce-239da9796382','Arman Ani','Lingkudu','2025-09-10','no','2025-09-22 06:40:12','2025-09-22 06:40:12'),
(2,'24ead4f0-9781-11f0-b5ce-239da9796382','rumah riati','Wandaka','2025-09-15','no','2025-09-22 06:55:37','2025-09-22 06:55:37'),
(3,'24eafebd-9781-11f0-b5ce-239da9796382','la sudir','Geresa','2025-09-18','no','2025-09-22 06:55:37','2025-09-22 06:55:37'),
(4,'24eb0385-9781-11f0-b5ce-239da9796382','SMP 3','Lipu','2025-09-18','no','2025-09-22 06:55:37','2025-09-22 06:55:37'),
(5,'24eb04c7-9781-11f0-b5ce-239da9796382','papa rin','Wandaka','2025-09-18','no','2025-09-22 06:55:37','2025-09-22 06:55:37'),
(9,'68fe0012-9a39-11f0-86c8-2f058cafc7d9','Statistik','Tasau\'Ea','2025-09-23','no','2025-09-26 02:33:55','2025-09-26 02:33:55'),
(10,'e095ac99-9a3a-11f0-86c8-2f058cafc7d9','Islamic Center ','Mina-minanga','2025-09-23','no','2025-09-26 02:44:25','2025-09-26 02:44:25'),
(17,'5af0e30f-9b78-11f0-8bcf-3d449d4688d7','SMA 1','Tasau\'Ea','2025-09-25','no','2025-09-27 08:02:47','2025-09-27 08:02:47'),
(18,'e930463e-9d2d-11f0-8219-8f13b2443d65','smp4 kulisusu','Bone','2025-09-29','no','2025-09-29 13:27:32','2025-09-29 13:27:32'),
(19,'10003348-9d2f-11f0-8219-8f13b2443d65','Aloo','Jauhari','2025-09-28','no','2025-09-29 13:35:47','2025-09-29 13:35:47'),
(20,'e58c3898-9dc9-11f0-91db-4e8fe5cb4b15','Nganga Buaya','Ereke','2025-09-25','no','2025-09-30 06:56:36','2025-09-30 06:56:36');
/*!40000 ALTER TABLE `kerjaan` ENABLE KEYS */;
UNLOCK TABLES;
commit;

--
-- Table structure for table `pekerja`
--

DROP TABLE IF EXISTS `pekerja`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `pekerja` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `uuid` char(36) NOT NULL,
  `kerjaan_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `uuid` (`uuid`),
  KEY `kerjaan_id` (`kerjaan_id`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `pekerja_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  CONSTRAINT `pekerja_kerjaan_fk` FOREIGN KEY (`kerjaan_id`) REFERENCES `detail_kerjaan` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=29 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `pekerja`
--

LOCK TABLES `pekerja` WRITE;
/*!40000 ALTER TABLE `pekerja` DISABLE KEYS */;
set autocommit=0;
INSERT INTO `pekerja` VALUES
(4,'2e1d30d7-b39c-43c4-9a03-36a824d27221',19,2,'2025-09-30 05:29:46','2025-09-30 05:29:46'),
(5,'2f4e46f3-b542-4b53-8644-3b920ddbe31b',19,3,'2025-09-30 05:30:51','2025-09-30 05:30:51'),
(6,'9c791f2e-da6d-42ee-a014-afd61dd40ec8',20,2,'2025-09-30 05:48:06','2025-09-30 05:48:06'),
(7,'8a72c05d-948c-4b4c-96e2-11002b5df466',24,2,'2025-09-30 06:27:42','2025-09-30 06:27:42'),
(8,'58b9fa41-7bc3-4d05-8741-3ef4f9cc6913',19,4,'2025-09-30 06:41:54','2025-09-30 06:41:54'),
(9,'e099662d-732e-4f8c-b0ad-9e43d730ae5e',19,7,'2025-09-30 06:48:49','2025-09-30 06:48:49'),
(10,'860202ad-e8c4-4030-b54a-017a3cdd529f',19,8,'2025-09-30 06:48:54','2025-09-30 06:48:54'),
(11,'867b3f0d-9265-419c-afba-1a5039b6e415',20,8,'2025-09-30 06:51:28','2025-09-30 06:51:28'),
(12,'c8c26b50-1973-4d20-8a8d-f404f4acc6b6',20,7,'2025-09-30 06:51:32','2025-09-30 06:51:32'),
(13,'f64a3d74-780c-44ae-a1c2-aa96a3366b19',20,4,'2025-09-30 06:51:38','2025-09-30 06:51:38'),
(14,'d64aba0a-8558-4c81-84c1-260a8fa4fdb5',20,3,'2025-09-30 06:51:47','2025-09-30 06:51:47'),
(15,'d95b6457-9017-48f3-aab3-ac7fc6c4f870',24,3,'2025-09-30 06:52:17','2025-09-30 06:52:17'),
(16,'ad66d22a-b5e9-420b-a888-573fb38dd09c',24,4,'2025-09-30 06:52:23','2025-09-30 06:52:23'),
(17,'f9685bd5-84de-48db-8eca-ea78fc72c609',24,7,'2025-09-30 06:52:27','2025-09-30 06:52:27'),
(18,'2f8ff318-93c4-4403-891b-139325283f60',24,8,'2025-09-30 06:52:31','2025-09-30 06:52:31'),
(19,'2d8176fa-086d-4d14-a200-76b875dfc558',16,2,'2025-09-30 06:53:44','2025-09-30 06:53:44'),
(20,'cfa7f217-ca0c-4bfe-824a-53f096f78f48',16,3,'2025-09-30 06:53:49','2025-09-30 06:53:49'),
(21,'6901e653-3a84-44b2-a255-7f495272c50c',16,4,'2025-09-30 06:53:53','2025-09-30 06:53:53'),
(22,'519c1a59-8a93-49a4-8961-5c1397c582d4',16,7,'2025-09-30 06:53:57','2025-09-30 06:53:57'),
(23,'916b44a1-4a75-4cf4-860a-a1f02ac6ff2e',16,8,'2025-09-30 06:54:06','2025-09-30 06:54:06'),
(24,'864a7160-f1a5-4666-9d10-ee5701b751ac',17,2,'2025-09-30 06:54:17','2025-09-30 06:54:17'),
(25,'eb8ff74f-81e1-4570-b0b6-99816b7c4925',17,3,'2025-09-30 06:54:22','2025-09-30 06:54:22'),
(26,'a024d401-369b-43d8-af34-e5f6429b3d43',17,4,'2025-09-30 06:54:26','2025-09-30 06:54:26'),
(27,'3dcc830a-2764-4167-a23e-6b76d36fa027',17,7,'2025-09-30 06:54:31','2025-09-30 06:54:31'),
(28,'de69c727-d021-41da-8e18-414c4c1e07b2',17,8,'2025-09-30 06:54:35','2025-09-30 06:54:35');
/*!40000 ALTER TABLE `pekerja` ENABLE KEYS */;
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
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;
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
(6,5,'rmh riati',2,'bkr','2025-09-18','no','2025-09-19 09:55:31','2025-09-19 09:55:31'),
(7,5,'geresa',2,'bkr','2025-09-20','no','2025-09-21 14:12:03','2025-09-21 14:12:03'),
(8,3,'smp 3',1,'bkr','2025-09-21','no','2025-09-21 14:12:39','2025-09-21 14:12:39'),
(9,5,'papa rin',4,'bkr','2025-09-22','no','2025-09-23 22:25:16','2025-09-23 22:25:16');
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

-- Dump completed on 2025-09-30 15:05:09
