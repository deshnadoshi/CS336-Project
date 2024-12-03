CREATE DATABASE  IF NOT EXISTS `railwaybooking` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;
USE `railwaybooking`;
-- MySQL dump 10.13  Distrib 8.0.34, for Win64 (x86_64)
--
-- Host: localhost    Database: railwaybooking
-- ------------------------------------------------------
-- Server version	8.0.35

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

--
-- Table structure for table `customers`
--

DROP TABLE IF EXISTS `customers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `customers` (
  `username` varchar(10) NOT NULL,
  `password` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL,
  `first_name` varchar(20) DEFAULT NULL,
  `last_name` varchar(20) DEFAULT NULL,
  `email` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`username`),
  UNIQUE KEY `username_UNIQUE` (`username`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `customers`
--

LOCK TABLES `customers` WRITE;
/*!40000 ALTER TABLE `customers` DISABLE KEYS */;
INSERT INTO `customers` VALUES ('dd1035','trains123','Deshna','Doshi','dd1035@rutgers.edu'),('ps1173','trains456','Palak','Singh','ps1173@rutgers.edu');
/*!40000 ALTER TABLE `customers` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `employees`
--

DROP TABLE IF EXISTS `employees`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `employees` (
  `ssn` int NOT NULL,
  `first_name` varchar(45) DEFAULT NULL,
  `last_name` varchar(45) DEFAULT NULL,
  `username` varchar(45) NOT NULL,
  `password` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL,
  `is_admin` tinyint(1) DEFAULT '0',
  PRIMARY KEY (`ssn`),
  UNIQUE KEY `username_UNIQUE` (`username`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `employees`
--

LOCK TABLES `employees` WRITE;
/*!40000 ALTER TABLE `employees` DISABLE KEYS */;
INSERT INTO `employees` VALUES (111111111,'Administrator','Login','admin','admin',1),(180121345,'Maria','Jaral','maria','pword123',0),(190121345,'Jasmine','Hanjra','jasmine','pword456',0);
/*!40000 ALTER TABLE `employees` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `reservations`
--

DROP TABLE IF EXISTS `reservations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `reservations` (
  `res_number` int NOT NULL,
  `res_datetime` date DEFAULT NULL,
  `total_fare` float DEFAULT NULL,
  `is_roundtrip` tinyint(1) DEFAULT NULL,
  `discount_type` varchar(50) DEFAULT NULL,
  `res_origin_station_id` int DEFAULT NULL,
  `res_destination_station_id` int DEFAULT NULL,
  `line_name` varchar(50) DEFAULT NULL,
  `portfolio_username` varchar(10) DEFAULT NULL,
  `status` varchar(50) DEFAULT 'CONFIRMED',
  PRIMARY KEY (`res_number`),
  KEY `res_origin_station_id` (`res_origin_station_id`),
  KEY `res_destination_station_id` (`res_destination_station_id`),
  KEY `line_name` (`line_name`),
  KEY `portfolio_username` (`portfolio_username`),
  CONSTRAINT `reservations_ibfk_1` FOREIGN KEY (`res_origin_station_id`) REFERENCES `stations` (`station_id`),
  CONSTRAINT `reservations_ibfk_2` FOREIGN KEY (`res_destination_station_id`) REFERENCES `stations` (`station_id`),
  CONSTRAINT `reservations_ibfk_3` FOREIGN KEY (`line_name`) REFERENCES `trainschedules` (`line_name`),
  CONSTRAINT `reservations_ibfk_4` FOREIGN KEY (`portfolio_username`) REFERENCES `customers` (`username`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `reservations`
--

LOCK TABLES `reservations` WRITE;
/*!40000 ALTER TABLE `reservations` DISABLE KEYS */;
INSERT INTO `reservations` VALUES (325655,'2024-12-01',18,0,'',2,6,'green','ps1173','CONFIRMED'),(463725,'2024-12-01',20.8,1,'senior',1,4,'blue','dd1035','CANCELLED'),(689491,'2024-11-19',15.6,1,'senior',2,4,'blue','ps1173','CONFIRMED'),(802944,'2024-12-01',24,1,'child',1,4,'blue','dd1035','CONFIRMED'),(919981,'2024-11-19',18,1,'child',2,4,'blue','ps1173','CONFIRMED');
/*!40000 ALTER TABLE `reservations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `stations`
--

DROP TABLE IF EXISTS `stations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `stations` (
  `station_id` int NOT NULL,
  `name` varchar(20) DEFAULT NULL,
  `state` char(2) DEFAULT NULL,
  `city` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`station_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `stations`
--

LOCK TABLES `stations` WRITE;
/*!40000 ALTER TABLE `stations` DISABLE KEYS */;
INSERT INTO `stations` VALUES (1,'Livingston','NJ','New Brunswick'),(2,'Busch','NJ','New Brunswick'),(3,'College Ave','NJ','New Brunswick'),(4,'Cook','NJ','New Brunswick'),(5,'Douglass','NJ','New Brunswick'),(6,'Edison','NJ','Edison'),(7,'Matawan','NJ','Matawan'),(8,'Woodbridge','NJ','Woodbridge'),(9,'East Brunswick','NJ','East Brunswick'),(10,'Trenton','NJ','Trenton'),(11,'Princeton','NJ','Princeton'),(12,'Somerville','NJ','Somerville'),(13,'Old Bridge','NJ','Old Bridge'),(14,'Somerset','NJ','Somerset'),(15,'Hillsborough','NJ','Hillsborough'),(16,'Bridgewater','NJ','Bridgwater'),(17,'Bound Brook','NJ','Bound Brook'),(18,'South Brunswick','NJ','South Brunswick'),(19,'West Windsor','NJ','West Windsor'),(20,'Franklin','NJ','Franklin Township');
/*!40000 ALTER TABLE `stations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `stops_at`
--

DROP TABLE IF EXISTS `stops_at`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `stops_at` (
  `line_name` varchar(50) NOT NULL,
  `station_id` int NOT NULL,
  `stop_arrival_time` time DEFAULT NULL,
  `stop_departure_time` time DEFAULT NULL,
  `stop_number` int DEFAULT NULL,
  PRIMARY KEY (`line_name`,`station_id`),
  KEY `station_id` (`station_id`),
  CONSTRAINT `stops_at_ibfk_1` FOREIGN KEY (`line_name`) REFERENCES `trainschedules` (`line_name`),
  CONSTRAINT `stops_at_ibfk_2` FOREIGN KEY (`station_id`) REFERENCES `stations` (`station_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `stops_at`
--

LOCK TABLES `stops_at` WRITE;
/*!40000 ALTER TABLE `stops_at` DISABLE KEYS */;
INSERT INTO `stops_at` VALUES ('blue',1,'08:00:00','08:35:00',1),('blue',2,'09:05:00','09:10:00',2),('blue',3,'09:40:00','09:45:00',3),('blue',4,'10:15:00','10:20:00',4),('blue',5,'10:50:00','10:55:00',5),('cyan',5,'09:00:00','09:35:00',1),('cyan',6,'10:05:00','10:10:00',2),('cyan',9,'10:40:00','10:45:00',3),('cyan',11,'11:15:00','11:20:00',4),('cyan',12,'11:50:00','11:55:00',5),('cyan',14,'12:25:00','12:30:00',6),('green',2,'10:00:00','10:35:00',1),('green',6,'11:05:00','11:10:00',2),('green',9,'11:40:00','11:45:00',3),('indigo',3,'11:00:00','11:35:00',1),('indigo',16,'12:05:00','12:10:00',2),('orange',4,'12:00:00','12:35:00',1),('orange',5,'13:05:00','13:10:00',2),('orange',7,'13:40:00','13:45:00',3),('orange',9,'14:15:00','14:20:00',4),('orange',15,'14:50:00','14:55:00',5),('orange',20,'15:25:00','15:30:00',6),('purple',15,'13:00:00','13:35:00',1),('purple',16,'14:05:00','14:10:00',2),('purple',19,'14:40:00','14:45:00',3),('purple',20,'15:15:00','15:20:00',4),('red',4,'14:00:00','14:35:00',1),('red',13,'15:05:00','15:10:00',2),('red',15,'15:40:00','15:45:00',3),('violet',1,'06:00:00','06:35:00',1),('violet',2,'07:05:00','07:10:00',2),('violet',3,'07:40:00','07:45:00',3),('violet',4,'08:15:00','08:20:00',4),('violet',5,'08:50:00','08:55:00',5),('yellow',6,'15:00:00','15:35:00',1),('yellow',8,'16:05:00','16:10:00',2),('yellow',10,'16:40:00','16:45:00',3),('yellow',11,'17:15:00','17:20:00',4),('yellow',14,'17:50:00','17:55:00',5),('yellow',16,'18:25:00','18:30:00',6),('yellow',17,'19:00:00','19:05:00',7);
/*!40000 ALTER TABLE `stops_at` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `trains`
--

DROP TABLE IF EXISTS `trains`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `trains` (
  `train_id` int NOT NULL,
  `line_name` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`train_id`),
  KEY `line_name` (`line_name`),
  CONSTRAINT `trains_ibfk_1` FOREIGN KEY (`line_name`) REFERENCES `trainschedules` (`line_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `trains`
--

LOCK TABLES `trains` WRITE;
/*!40000 ALTER TABLE `trains` DISABLE KEYS */;
INSERT INTO `trains` VALUES (5,'blue'),(8,'cyan'),(4,'green'),(7,'indigo'),(2,'orange'),(6,'purple'),(1,'red'),(9,'violet'),(3,'yellow');
/*!40000 ALTER TABLE `trains` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `trainschedules`
--

DROP TABLE IF EXISTS `trainschedules`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `trainschedules` (
  `line_name` varchar(50) NOT NULL,
  `num_stops` int DEFAULT NULL,
  `fare` int DEFAULT NULL,
  `train_arrival_time` datetime NOT NULL,
  `train_departure_time` datetime NOT NULL,
  `travel_time` int DEFAULT NULL,
  `origin_stop_station_id` int DEFAULT NULL,
  `destination_stop_station_id` int DEFAULT NULL,
  PRIMARY KEY (`line_name`,`train_arrival_time`,`train_departure_time`),
  KEY `origin_stop_station_id` (`origin_stop_station_id`),
  KEY `destination_stop_station_id` (`destination_stop_station_id`),
  CONSTRAINT `trainschedules_ibfk_1` FOREIGN KEY (`origin_stop_station_id`) REFERENCES `stations` (`station_id`),
  CONSTRAINT `trainschedules_ibfk_2` FOREIGN KEY (`destination_stop_station_id`) REFERENCES `stations` (`station_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `trainschedules`
--

LOCK TABLES `trainschedules` WRITE;
/*!40000 ALTER TABLE `trainschedules` DISABLE KEYS */;
INSERT INTO `trainschedules` VALUES ('blue',5,20,'2024-11-19 10:50:00','2024-11-19 08:35:00',135,1,5),('cyan',6,30,'2024-11-19 12:25:00','2024-11-19 09:35:00',170,5,14),('green',3,27,'2024-11-17 11:40:00','2024-11-17 10:35:00',65,2,9),('indigo',2,40,'2024-11-16 12:05:00','2024-11-16 11:35:00',30,3,6),('indigo',2,40,'2024-11-23 12:05:00','2024-11-23 11:35:00',30,3,6),('orange',6,36,'2024-11-16 15:25:00','2024-11-16 12:35:00',170,4,20),('purple',4,48,'2024-11-17 15:15:00','2024-11-17 13:35:00',100,15,20),('red',3,18,'2024-11-18 15:40:00','2024-11-18 14:35:00',65,4,15),('violet',5,45,'2024-11-19 08:50:00','2024-11-19 06:35:00',135,1,5),('yellow',7,49,'2024-11-19 19:00:00','2024-11-19 15:35:00',205,6,17);
/*!40000 ALTER TABLE `trainschedules` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping routines for database 'railwaybooking'
--
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2024-12-03 18:46:04
