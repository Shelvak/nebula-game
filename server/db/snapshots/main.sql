-- MySQL dump 10.13  Distrib 5.1.41, for debian-linux-gnu (i486)
--
-- Host: localhost    Database: spacegame
-- ------------------------------------------------------
-- Server version	5.1.41-3ubuntu12.6

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `alliances`
--

DROP TABLE IF EXISTS `alliances`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `alliances` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `galaxy_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `foreign_key` (`galaxy_id`),
  CONSTRAINT `alliances_ibfk_1` FOREIGN KEY (`galaxy_id`) REFERENCES `galaxies` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `alliances`
--

LOCK TABLES `alliances` WRITE;
/*!40000 ALTER TABLE `alliances` DISABLE KEYS */;
/*!40000 ALTER TABLE `alliances` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `buildings`
--

DROP TABLE IF EXISTS `buildings`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `buildings` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `planet_id` int(11) DEFAULT NULL,
  `x` tinyint(2) unsigned NOT NULL DEFAULT '0',
  `y` tinyint(2) unsigned NOT NULL DEFAULT '0',
  `armor_mod` int(11) NOT NULL,
  `constructor_mod` int(11) NOT NULL,
  `energy_mod` int(11) NOT NULL,
  `level` tinyint(2) unsigned NOT NULL DEFAULT '0',
  `type` varchar(255) NOT NULL,
  `upgrade_ends_at` datetime DEFAULT NULL,
  `x_end` tinyint(2) unsigned NOT NULL DEFAULT '0',
  `y_end` tinyint(2) unsigned NOT NULL DEFAULT '0',
  `last_update` datetime DEFAULT NULL,
  `state` tinyint(2) NOT NULL DEFAULT '0',
  `hp` int(10) unsigned NOT NULL,
  `pause_remainder` int(10) unsigned DEFAULT NULL,
  `hp_remainder` int(10) unsigned NOT NULL DEFAULT '0',
  `constructable_type` varchar(100) DEFAULT NULL,
  `constructable_id` int(11) DEFAULT NULL,
  `construction_mod` tinyint(2) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `tiles_taken` (`planet_id`,`x`,`y`,`x_end`,`y_end`),
  KEY `index_buildings_on_construction_ends` (`upgrade_ends_at`),
  KEY `buildings_by_type` (`planet_id`,`type`),
  CONSTRAINT `buildings_ibfk_1` FOREIGN KEY (`planet_id`) REFERENCES `planets` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=23 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `buildings`
--

LOCK TABLES `buildings` WRITE;
/*!40000 ALTER TABLE `buildings` DISABLE KEYS */;
INSERT INTO `buildings` VALUES (1,32,7,16,0,0,0,1,'Thunder',NULL,8,17,NULL,1,300,NULL,0,NULL,NULL,0),(2,32,21,16,0,0,0,1,'Thunder',NULL,22,17,NULL,1,300,NULL,0,NULL,NULL,0),(3,32,21,9,0,0,0,1,'Screamer',NULL,22,10,NULL,1,300,NULL,0,NULL,NULL,0),(4,32,18,28,0,0,0,1,'NpcSolarPlant',NULL,19,29,NULL,0,1000,NULL,0,NULL,NULL,0),(5,32,7,9,0,0,0,1,'Vulcan',NULL,8,10,NULL,1,300,NULL,0,NULL,NULL,0),(6,32,14,22,0,0,0,1,'Thunder',NULL,15,23,NULL,1,300,NULL,0,NULL,NULL,0),(7,32,26,16,0,0,0,1,'NpcZetiumExtractor',NULL,27,17,NULL,0,800,NULL,0,NULL,NULL,0),(8,32,3,27,0,0,0,1,'NpcMetalExtractor',NULL,4,28,NULL,0,400,NULL,0,NULL,NULL,0),(9,32,28,24,0,0,0,1,'NpcMetalExtractor',NULL,29,25,NULL,0,400,NULL,0,NULL,NULL,0),(10,32,18,25,0,0,0,1,'NpcSolarPlant',NULL,19,26,NULL,0,1000,NULL,0,NULL,NULL,0),(11,32,15,26,0,0,0,1,'NpcSolarPlant',NULL,16,27,NULL,0,1000,NULL,0,NULL,NULL,0),(12,32,7,28,0,0,0,1,'NpcCommunicationsHub',NULL,9,29,NULL,0,1200,NULL,0,NULL,NULL,0),(13,32,21,22,0,0,0,1,'Vulcan',NULL,22,23,NULL,1,300,NULL,0,NULL,NULL,0),(14,32,24,24,0,0,0,1,'NpcMetalExtractor',NULL,25,25,NULL,0,400,NULL,0,NULL,NULL,0),(15,32,0,28,0,0,0,1,'NpcMetalExtractor',NULL,1,29,NULL,0,400,NULL,0,NULL,NULL,0),(16,32,11,14,0,0,0,1,'Mothership',NULL,18,19,NULL,1,10500,NULL,0,NULL,NULL,0),(17,32,22,27,0,0,0,1,'NpcSolarPlant',NULL,23,28,NULL,0,1000,NULL,0,NULL,NULL,0),(18,32,14,9,0,0,0,1,'Thunder',NULL,15,10,NULL,1,300,NULL,0,NULL,NULL,0),(19,32,25,20,0,0,0,1,'NpcTemple',NULL,27,22,NULL,0,1500,NULL,0,NULL,NULL,0),(20,32,12,27,0,0,0,1,'NpcSolarPlant',NULL,13,28,NULL,0,1000,NULL,0,NULL,NULL,0),(21,32,7,22,0,0,0,1,'Screamer',NULL,8,23,NULL,1,300,NULL,0,NULL,NULL,0),(22,32,26,27,0,0,0,1,'NpcCommunicationsHub',NULL,28,28,NULL,0,1200,NULL,0,NULL,NULL,0);
/*!40000 ALTER TABLE `buildings` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `callbacks`
--

DROP TABLE IF EXISTS `callbacks`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `callbacks` (
  `class` varchar(50) NOT NULL,
  `object_id` int(10) unsigned NOT NULL,
  `ends_at` datetime NOT NULL,
  `event` tinyint(2) unsigned NOT NULL DEFAULT '0',
  `ruleset` varchar(30) NOT NULL,
  UNIQUE KEY `main` (`class`,`object_id`,`event`),
  KEY `tick` (`ends_at`),
  KEY `removal` (`class`,`object_id`),
  KEY `index_callbacks_on_class_and_object_id` (`class`,`object_id`),
  KEY `time` (`ends_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `callbacks`
--

LOCK TABLES `callbacks` WRITE;
/*!40000 ALTER TABLE `callbacks` DISABLE KEYS */;
INSERT INTO `callbacks` VALUES ('Notification',1,'2010-10-25 16:20:38',4,'dev'),('Notification',2,'2010-10-25 16:20:39',4,'dev');
/*!40000 ALTER TABLE `callbacks` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `combat_logs`
--

DROP TABLE IF EXISTS `combat_logs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `combat_logs` (
  `sha1_id` char(40) NOT NULL,
  `info` text NOT NULL,
  `expires_at` datetime NOT NULL,
  PRIMARY KEY (`sha1_id`),
  KEY `index_combat_logs_on_expires_at` (`expires_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `combat_logs`
--

LOCK TABLES `combat_logs` WRITE;
/*!40000 ALTER TABLE `combat_logs` DISABLE KEYS */;
/*!40000 ALTER TABLE `combat_logs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `construction_queue_entries`
--

DROP TABLE IF EXISTS `construction_queue_entries`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `construction_queue_entries` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `constructable_type` varchar(100) NOT NULL,
  `constructor_id` int(11) NOT NULL,
  `count` int(11) NOT NULL,
  `position` smallint(2) unsigned NOT NULL DEFAULT '0',
  `params` text,
  PRIMARY KEY (`id`),
  KEY `index_upgrade_queue_entries_on_constructor_id` (`constructor_id`),
  KEY `index_upgrade_queue_entries_on_position` (`position`),
  KEY `foreign_key` (`constructor_id`),
  CONSTRAINT `construction_queue_entries_ibfk_1` FOREIGN KEY (`constructor_id`) REFERENCES `buildings` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `construction_queue_entries`
--

LOCK TABLES `construction_queue_entries` WRITE;
/*!40000 ALTER TABLE `construction_queue_entries` DISABLE KEYS */;
/*!40000 ALTER TABLE `construction_queue_entries` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cooldowns`
--

DROP TABLE IF EXISTS `cooldowns`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cooldowns` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `location_id` int(10) unsigned NOT NULL,
  `location_type` tinyint(2) unsigned NOT NULL,
  `location_x` int(11) DEFAULT NULL,
  `location_y` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `location` (`location_id`,`location_type`,`location_x`,`location_y`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cooldowns`
--

LOCK TABLES `cooldowns` WRITE;
/*!40000 ALTER TABLE `cooldowns` DISABLE KEYS */;
/*!40000 ALTER TABLE `cooldowns` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `folliages`
--

DROP TABLE IF EXISTS `folliages`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `folliages` (
  `planet_id` int(11) NOT NULL,
  `x` tinyint(2) unsigned NOT NULL DEFAULT '0',
  `y` tinyint(2) unsigned NOT NULL DEFAULT '0',
  `variation` tinyint(2) unsigned NOT NULL DEFAULT '0',
  UNIQUE KEY `coords` (`planet_id`,`x`,`y`),
  CONSTRAINT `folliages_ibfk_1` FOREIGN KEY (`planet_id`) REFERENCES `planets` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `folliages`
--

LOCK TABLES `folliages` WRITE;
/*!40000 ALTER TABLE `folliages` DISABLE KEYS */;
INSERT INTO `folliages` VALUES (2,0,12,6),(2,0,18,10),(2,0,19,7),(2,0,20,11),(2,0,21,1),(2,0,22,8),(2,0,27,8),(2,0,28,6),(2,0,30,10),(2,1,5,1),(2,1,15,13),(2,1,20,9),(2,1,21,11),(2,1,22,7),(2,1,24,12),(2,1,26,1),(2,1,28,1),(2,1,29,12),(2,2,10,6),(2,2,11,4),(2,2,29,8),(2,3,5,1),(2,3,25,13),(2,3,29,4),(2,3,32,0),(2,3,33,13),(2,4,3,4),(2,4,4,13),(2,4,18,0),(2,4,31,13),(2,4,32,1),(2,5,1,7),(2,5,10,0),(2,5,11,13),(2,5,26,5),(2,5,29,2),(2,6,0,10),(2,6,5,9),(2,6,9,3),(2,6,11,9),(2,6,15,6),(2,6,27,6),(2,6,28,13),(2,6,29,7),(2,7,7,0),(2,7,16,3),(2,7,26,6),(2,7,31,0),(2,8,0,13),(2,8,1,0),(2,8,6,10),(2,8,9,12),(2,8,11,4),(2,8,13,9),(2,8,16,11),(2,8,18,0),(2,8,19,2),(2,8,20,3),(2,8,24,5),(2,8,25,12),(2,8,30,4),(2,9,0,6),(2,9,3,0),(2,9,6,8),(2,9,7,6),(2,9,22,0),(2,9,30,13),(2,9,33,8),(2,9,34,11),(2,10,0,5),(2,10,3,3),(2,10,13,13),(2,10,14,11),(2,10,22,10),(2,10,25,8),(2,10,32,1),(2,11,3,7),(2,11,9,5),(2,11,10,1),(2,11,13,2),(2,11,33,0),(2,11,34,3),(2,12,0,8),(2,12,1,7),(2,12,15,3),(2,12,16,1),(2,12,20,0),(2,12,21,13),(2,12,22,13),(2,12,23,1),(2,13,14,7),(2,13,15,9),(2,13,24,6),(2,13,33,13),(2,13,34,1),(2,13,35,4),(2,14,0,7),(2,14,18,5),(2,14,20,11),(2,14,31,7),(2,14,35,5),(2,15,35,13),(2,16,0,5),(2,16,1,3),(2,16,2,1),(2,17,3,8),(2,17,20,5),(2,17,34,3),(2,18,5,11),(2,18,33,10),(2,18,34,10),(2,19,0,4),(2,19,5,7),(2,20,1,13),(2,20,6,2),(2,21,0,7),(2,21,1,12),(2,21,6,11),(2,21,9,3),(2,21,35,3),(2,22,1,11),(2,22,7,4),(2,22,16,2),(2,22,21,3),(2,23,0,3),(2,23,1,5),(2,23,3,6),(2,23,4,5),(2,23,9,9),(2,23,23,12),(2,24,0,13),(2,24,1,9),(2,24,5,8),(2,24,6,0),(2,24,11,8),(2,24,14,5),(2,24,17,0),(2,24,20,6),(2,24,21,13),(2,24,30,5),(2,25,1,9),(2,25,2,8),(2,25,6,7),(2,25,16,10),(2,25,18,6),(2,25,21,6),(2,25,30,3),(2,26,7,12),(2,26,16,13),(2,26,22,0),(2,26,25,0),(2,26,26,0),(2,27,5,2),(2,27,26,13),(2,28,1,3),(2,28,24,9),(2,28,25,10),(2,28,30,7),(2,29,5,6),(2,29,16,2),(2,30,13,6),(2,31,15,0),(2,31,16,8),(2,32,15,8),(2,32,16,8),(2,32,23,9),(2,33,9,4),(2,33,17,4),(2,34,27,9),(2,35,0,11),(2,35,10,8),(2,35,13,1),(2,35,23,1),(2,36,4,4),(2,36,5,9),(2,36,6,9),(2,36,7,3),(2,36,8,3),(2,36,16,0),(2,37,4,2),(2,37,19,8),(2,37,28,13),(2,38,8,8),(2,38,9,3),(2,38,26,0),(2,38,30,10),(2,39,0,11),(2,39,1,12),(2,39,2,9),(2,39,4,3),(2,39,10,11),(2,40,4,2),(2,40,18,2),(2,40,26,11),(2,40,27,0),(2,41,19,7),(2,41,26,3),(2,41,28,3),(2,41,32,2),(2,42,3,10),(2,42,4,2),(2,42,8,2),(2,43,3,13),(2,43,4,8),(2,43,7,7),(2,43,8,0),(2,43,13,2),(2,43,15,2),(2,43,26,0),(2,43,32,5),(2,43,33,12),(4,0,0,0),(4,0,2,12),(4,0,7,0),(4,0,11,3),(4,0,18,13),(4,0,20,9),(4,0,22,7),(4,1,1,13),(4,1,2,4),(4,1,6,12),(4,1,10,0),(4,1,17,5),(4,1,21,4),(4,1,23,5),(4,2,0,4),(4,2,1,9),(4,2,2,0),(4,2,4,5),(4,2,20,13),(4,2,21,6),(4,2,25,12),(4,3,0,4),(4,3,1,13),(4,3,2,3),(4,3,4,0),(4,3,7,6),(4,3,17,13),(4,3,20,3),(4,4,4,0),(4,4,5,13),(4,4,20,11),(4,5,1,10),(4,5,7,13),(4,5,8,10),(4,5,19,6),(4,6,1,11),(4,6,2,6),(4,6,16,12),(4,7,0,5),(4,7,5,1),(4,7,7,11),(4,7,25,13),(4,8,0,0),(4,8,6,11),(4,8,7,10),(4,8,9,5),(4,8,16,9),(4,8,23,4),(4,8,24,0),(4,9,5,4),(4,9,23,0),(4,10,3,7),(4,10,5,5),(4,10,15,5),(4,10,20,11),(4,10,21,12),(4,10,23,13),(4,11,3,8),(4,11,4,13),(4,12,1,0),(4,12,4,10),(4,12,15,0),(4,13,16,13),(4,13,18,7),(4,14,11,8),(4,14,16,5),(4,14,17,10),(4,14,18,7),(4,15,13,5),(4,15,14,8),(4,15,15,13),(4,15,19,4),(4,15,20,8),(4,16,2,13),(4,16,8,1),(4,16,17,7),(4,16,19,7),(4,16,22,10),(4,16,25,2),(4,17,1,7),(4,17,9,1),(4,17,14,3),(4,17,19,13),(4,18,7,7),(4,18,18,10),(4,18,22,8),(4,18,23,3),(4,19,8,1),(4,19,10,7),(4,19,12,11),(4,19,13,7),(4,19,15,6),(4,19,17,6),(4,19,19,3),(4,19,23,9),(4,20,7,10),(4,20,9,9),(4,20,23,3),(4,21,16,5),(4,21,17,2),(4,21,18,3),(4,21,21,13),(4,21,23,0),(4,22,11,7),(4,22,12,8),(4,22,13,12),(4,22,19,8),(4,22,25,0),(4,23,9,6),(4,24,9,0),(4,24,10,1),(4,24,11,9),(4,24,12,2),(4,24,25,2),(4,25,7,2),(4,25,9,5),(4,25,10,3),(4,25,17,4),(4,26,7,8),(4,26,12,7),(4,26,17,7),(4,27,8,6),(4,27,9,7),(4,27,17,10),(4,27,18,3),(4,27,21,11),(4,27,23,12),(4,28,23,13),(4,28,24,0),(4,29,7,1),(4,29,17,9),(4,30,1,4),(4,30,2,1),(4,30,21,7),(4,31,3,5),(4,31,11,12),(4,31,21,9),(4,31,23,12),(4,31,24,1),(4,32,1,9),(4,32,2,1),(4,32,20,10),(4,32,21,6),(4,32,23,11),(4,33,3,11),(4,33,21,7),(4,33,24,4),(4,34,0,8),(4,34,2,3),(4,34,8,7),(4,34,9,13),(4,34,15,5),(4,35,13,0),(4,35,15,9),(4,36,0,10),(4,36,2,0),(4,36,17,9),(4,36,25,10),(4,37,2,9),(4,37,18,7),(4,38,25,1),(4,39,2,0),(4,39,15,13),(4,39,16,12),(4,40,25,12),(4,41,2,8),(4,42,25,12),(11,0,0,1),(11,0,7,6),(11,0,36,8),(11,0,41,6),(11,0,45,9),(11,0,47,8),(11,1,3,7),(11,1,7,2),(11,1,27,11),(11,1,34,5),(11,1,40,8),(11,2,18,0),(11,2,48,12),(11,3,22,10),(11,3,25,9),(11,3,28,12),(11,3,33,12),(11,3,41,9),(11,3,42,5),(11,3,44,1),(11,3,45,6),(11,4,17,9),(11,4,23,10),(11,4,27,11),(11,4,29,1),(11,4,38,13),(11,4,39,5),(11,4,40,4),(11,4,43,11),(11,5,5,7),(11,5,17,1),(11,5,18,1),(11,5,20,13),(11,5,25,11),(11,5,26,1),(11,5,39,7),(11,5,49,9),(11,6,13,12),(11,6,21,1),(11,6,30,11),(11,6,40,7),(11,6,44,5),(11,7,36,2),(11,7,43,7),(11,8,13,13),(11,8,14,5),(11,8,34,6),(11,8,43,12),(11,8,44,11),(11,9,9,9),(11,9,26,3),(11,9,37,5),(11,9,41,5),(11,10,25,6),(11,10,26,13),(11,10,36,10),(11,10,37,2),(11,10,40,12),(11,11,10,2),(11,11,12,6),(11,11,15,8),(11,11,45,13),(11,12,19,4),(11,12,26,11),(11,12,38,1),(11,12,41,0),(11,12,43,7),(11,13,23,5),(11,13,27,5),(11,13,43,7),(11,14,23,13),(11,14,27,4),(11,14,32,2),(11,14,40,3),(11,15,15,0),(11,15,18,0),(11,15,19,10),(11,15,21,9),(11,15,22,0),(11,15,26,9),(11,16,24,13),(11,16,39,6),(11,16,44,9),(11,17,18,12),(11,17,21,1),(11,17,30,4),(11,17,31,0),(11,17,44,0),(11,18,6,11),(11,18,18,4),(11,18,26,8),(11,18,27,13),(11,18,35,7),(11,18,36,10),(11,18,40,7),(11,18,45,2),(11,19,9,4),(11,19,15,7),(11,19,25,4),(11,19,36,10),(11,19,40,10),(11,20,8,7),(11,20,11,11),(11,20,17,10),(11,20,24,4),(11,20,30,10),(11,20,33,11),(11,20,41,4),(11,21,1,6),(11,21,9,1),(11,21,10,12),(11,21,14,3),(11,21,15,6),(11,21,18,11),(11,21,19,3),(11,21,31,13),(11,21,33,2),(11,21,34,4),(11,21,37,7),(11,22,1,12),(11,22,16,3),(11,22,25,3),(11,22,26,13),(11,22,27,0),(11,22,29,12),(11,22,31,1),(11,22,34,0),(11,22,37,4),(11,22,41,10),(11,23,12,12),(11,23,13,6),(11,23,24,0),(11,23,25,4),(11,23,26,12),(11,23,27,7),(11,23,35,6),(11,24,0,0),(11,24,14,8),(11,24,16,4),(11,24,30,13),(11,24,36,8),(11,24,37,9),(11,24,41,0),(11,24,45,10),(11,25,0,2),(11,25,16,6),(11,25,18,1),(11,25,25,12),(11,25,26,4),(11,25,37,3),(11,26,14,2),(11,26,16,11),(11,26,20,5),(11,26,28,6),(11,26,32,5),(11,26,45,3),(11,27,5,11),(11,27,24,9),(11,27,25,1),(11,27,26,12),(11,27,31,13),(11,27,32,7),(11,27,35,4),(11,28,2,2),(11,28,5,6),(11,28,15,7),(11,28,19,5),(11,28,20,3),(11,28,22,8),(11,28,23,6),(11,28,24,3),(11,28,32,2),(11,28,49,12),(11,29,1,9),(11,29,2,11),(11,29,5,5),(11,29,8,6),(11,29,10,6),(11,29,13,9),(11,29,28,10),(11,29,29,13),(11,29,32,5),(11,29,33,7),(11,29,39,5),(11,29,42,7),(11,29,46,2),(11,29,47,12),(20,0,0,1),(20,0,5,4),(20,0,17,3),(20,1,7,12),(20,1,10,4),(20,1,12,13),(20,1,13,8),(20,2,8,5),(20,2,9,12),(20,2,13,13),(20,2,14,5),(20,2,15,13),(20,3,11,1),(20,3,13,11),(20,4,2,11),(20,4,5,9),(20,4,10,8),(20,4,21,13),(20,5,0,13),(20,5,1,4),(20,5,7,13),(20,5,8,7),(20,6,2,4),(20,7,9,11),(20,8,6,9),(20,8,9,11),(20,8,11,11),(20,8,14,7),(20,9,4,8),(20,9,6,5),(20,9,12,1),(20,9,21,9),(20,10,4,13),(20,10,6,10),(20,10,7,0),(20,10,12,5),(20,10,18,11),(20,10,19,9),(20,11,5,0),(20,11,8,8),(20,11,12,2),(20,11,14,7),(20,11,19,7),(20,12,7,6),(20,12,13,2),(20,13,1,5),(20,13,3,2),(20,13,5,13),(20,13,7,9),(20,14,0,9),(20,14,3,5),(20,14,11,0),(20,14,13,9),(20,15,0,12),(20,15,3,4),(20,15,7,8),(20,15,14,11),(20,16,0,3),(20,16,1,0),(20,16,7,13),(20,16,8,6),(20,16,9,12),(20,16,10,12),(20,16,12,6),(20,17,11,11),(20,18,0,3),(20,18,1,1),(20,18,2,10),(20,18,11,2),(20,18,14,7),(20,19,24,4),(20,20,0,5),(20,20,18,5),(20,20,21,6),(20,21,1,2),(20,21,4,2),(20,21,15,9),(20,21,19,7),(20,22,1,10),(20,22,3,8),(20,22,16,2),(20,22,18,7),(20,22,19,9),(20,22,22,5),(20,22,25,1),(20,23,11,2),(20,23,14,10),(20,23,20,7),(20,23,22,4),(20,23,26,8),(20,23,27,12),(20,24,0,8),(20,24,10,1),(20,24,12,3),(20,24,21,2),(20,24,26,1),(20,25,1,6),(20,25,3,13),(20,25,5,13),(20,25,10,4),(20,25,17,5),(20,25,25,0),(20,25,26,12),(20,25,27,9),(20,26,1,3),(20,26,8,7),(20,26,11,7),(20,26,14,13),(20,26,15,9),(20,26,19,5),(20,27,13,5),(20,27,14,8),(20,27,20,1),(20,27,25,6),(20,28,1,13),(20,28,5,0),(20,28,9,3),(20,28,13,9),(20,28,18,9),(20,28,19,6),(20,28,24,6),(20,29,0,9),(20,29,1,2),(20,29,8,7),(20,29,15,10),(20,30,0,8),(20,30,1,7),(20,30,3,12),(20,30,12,10),(20,31,0,4),(20,31,2,2),(20,31,3,12),(20,31,13,1),(20,31,14,4),(20,31,16,5),(20,32,1,12),(20,34,8,7),(20,35,8,5),(20,36,27,4),(20,37,8,4),(20,37,19,7),(20,38,8,3),(20,38,15,11),(20,38,24,12),(20,39,7,5),(20,39,8,4),(20,39,11,11),(20,39,14,6),(20,39,16,11),(20,39,18,0),(21,0,0,7),(21,0,1,7),(21,0,2,10),(21,0,3,11),(21,0,25,7),(21,1,1,1),(21,1,5,10),(21,1,8,12),(21,1,15,3),(21,1,21,0),(21,2,5,8),(21,3,5,12),(21,3,16,10),(21,4,0,10),(21,4,1,8),(21,4,7,0),(21,4,10,6),(21,5,1,6),(21,5,4,10),(21,5,5,10),(21,5,16,2),(21,7,0,9),(21,7,11,13),(21,7,15,9),(21,8,3,6),(21,8,4,3),(21,8,18,11),(21,9,16,5),(21,9,17,10),(21,10,15,7),(21,10,18,10),(21,10,32,13),(21,10,34,9),(21,11,14,4),(21,11,18,11),(21,12,3,12),(21,12,34,0),(21,13,4,0),(21,13,5,11),(21,13,14,7),(21,13,34,5),(21,14,15,12),(21,14,34,11),(21,15,4,10),(21,15,11,5),(21,15,13,4),(21,16,4,13),(21,16,13,10),(21,16,14,2),(21,16,31,6),(21,17,5,6),(21,17,10,5),(21,17,14,8),(21,17,21,1),(21,18,10,2),(21,18,13,12),(21,19,9,4),(21,19,17,8),(21,19,30,8),(21,19,31,1),(21,20,2,5),(21,20,17,9),(21,20,18,3),(21,20,19,3),(21,20,22,12),(21,21,2,3),(21,21,3,0),(21,21,16,3),(21,21,22,11),(21,21,28,1),(21,21,31,8),(21,21,33,2),(21,22,1,9),(21,22,2,8),(21,22,16,7),(21,22,21,4),(21,22,28,1),(21,22,29,4),(21,22,31,9),(21,22,32,0),(21,23,3,3),(21,23,6,12),(21,23,7,5),(21,23,8,1),(21,23,12,5),(21,23,16,11),(21,23,26,7),(21,23,30,0),(25,0,2,10),(25,0,6,4),(25,0,14,4),(25,0,18,12),(25,0,19,5),(25,0,24,1),(25,0,31,3),(25,0,34,8),(25,0,35,8),(25,1,0,0),(25,1,5,12),(25,1,6,8),(25,1,15,5),(25,1,17,9),(25,1,19,7),(25,1,30,6),(25,2,5,9),(25,2,6,3),(25,2,16,12),(25,2,21,9),(25,2,23,12),(25,3,1,9),(25,3,2,12),(25,3,3,3),(25,3,4,13),(25,3,8,0),(25,3,11,7),(25,3,22,8),(25,4,2,7),(25,4,3,4),(25,4,4,5),(25,4,8,2),(25,4,14,13),(25,4,15,8),(25,5,0,8),(25,5,9,13),(25,5,20,5),(25,5,33,8),(25,6,1,4),(25,6,4,13),(25,6,29,3),(25,6,32,3),(25,7,4,11),(25,7,32,11),(25,8,3,0),(25,8,12,1),(25,8,13,12),(25,8,14,11),(25,8,15,0),(25,8,17,11),(25,8,28,4),(25,9,17,0),(25,9,23,3),(25,9,28,4),(25,10,1,3),(25,10,4,0),(25,10,13,9),(25,10,16,10),(25,10,18,13),(25,10,20,3),(25,10,22,12),(25,10,23,8),(25,10,24,4),(25,10,28,5),(25,11,16,7),(25,11,17,8),(25,11,20,6),(25,11,22,4),(25,11,23,4),(25,11,24,6),(25,11,28,12),(25,12,16,10),(25,12,17,2),(25,12,19,8),(25,12,25,9),(25,12,27,10),(25,12,28,7),(25,12,29,9),(25,12,31,1),(25,13,0,6),(25,13,3,8),(25,13,12,0),(25,13,19,10),(25,14,3,12),(25,14,17,5),(25,14,18,1),(25,14,19,12),(25,14,34,8),(25,14,36,7),(25,15,0,10),(25,15,3,13),(25,15,31,8),(25,16,0,4),(25,16,3,12),(25,16,17,4),(25,16,31,12),(25,17,21,8),(25,17,31,5),(25,17,36,13),(25,18,0,12),(25,18,21,10),(25,18,26,13),(25,18,31,1),(25,19,1,12),(25,19,2,4),(25,19,8,2),(25,19,17,4),(25,19,22,5),(25,19,25,3),(25,19,32,2),(25,19,36,8),(25,20,1,1),(25,20,4,1),(25,20,19,7),(25,20,32,7),(25,21,0,12),(25,21,2,7),(25,21,4,9),(25,21,10,2),(25,21,13,1),(25,21,19,3),(25,22,1,8),(25,22,2,4),(25,22,18,3),(25,22,26,7),(25,22,27,3),(25,22,28,0),(25,22,31,9),(25,23,18,3),(25,23,30,8),(25,23,32,2),(25,24,2,11),(25,24,10,12),(25,24,11,13),(25,24,16,3),(25,24,17,3),(25,24,26,5),(25,24,28,6),(25,25,13,11),(25,25,19,6),(25,25,28,0),(25,25,32,4),(25,25,33,13),(25,26,19,1),(25,26,25,10),(25,26,27,5),(25,26,29,9),(25,26,36,10),(25,27,1,13),(25,27,12,8),(25,27,16,11),(25,27,21,7),(25,27,30,5),(25,27,32,5),(25,27,33,9),(25,27,35,4),(25,27,36,11),(25,28,30,12),(25,29,24,9),(25,29,31,2),(25,29,36,10),(25,30,1,1),(25,30,10,7),(25,30,12,9),(25,30,24,3),(25,30,31,12),(25,31,9,0),(25,31,10,3),(25,31,13,5),(25,31,14,5),(25,31,27,1),(30,0,4,6),(30,0,7,3),(30,0,14,6),(30,0,18,0),(30,0,20,10),(30,0,25,10),(30,1,7,1),(30,1,13,12),(30,1,15,6),(30,1,17,7),(30,1,27,2),(30,2,10,11),(30,2,14,7),(30,3,6,3),(30,3,9,0),(30,3,13,11),(30,4,7,9),(30,4,14,0),(30,5,0,6),(30,5,4,1),(30,5,16,5),(30,5,18,6),(30,6,11,2),(30,6,12,8),(30,7,1,7),(30,7,2,12),(30,7,11,4),(30,7,22,3),(30,7,32,9),(30,7,35,8),(30,8,12,7),(30,8,13,1),(30,8,14,4),(30,8,15,6),(30,8,22,2),(30,8,32,8),(30,8,35,8),(30,9,7,4),(30,9,12,2),(30,9,13,4),(30,9,14,13),(30,9,17,13),(30,9,36,9),(30,10,2,10),(30,10,13,5),(30,10,17,5),(30,10,25,7),(30,10,32,3),(30,10,34,12),(30,11,0,12),(30,11,16,8),(30,11,19,2),(30,12,0,4),(30,12,14,7),(30,14,31,11),(30,14,32,0),(30,14,34,12),(30,15,2,6),(30,15,12,8),(30,15,15,0),(30,15,28,2),(30,15,30,12),(30,15,32,3),(30,15,33,7),(30,15,35,1),(30,15,36,4),(30,16,2,8),(30,16,28,10),(30,16,33,9),(30,16,35,8),(30,16,36,2),(30,17,0,10),(30,17,3,10),(30,17,29,9),(30,17,32,1),(30,18,1,6),(30,18,2,10),(30,18,15,8),(30,18,18,3),(30,18,27,5),(30,19,0,3),(30,19,1,6),(30,19,7,2),(30,19,12,9),(30,19,13,11),(30,19,14,1),(30,19,19,13),(30,19,33,4),(30,20,0,12),(30,20,10,13),(30,20,11,4),(30,21,1,2),(30,21,2,6),(30,21,5,8),(30,21,10,2),(30,21,14,13),(30,22,6,0),(30,22,9,6),(30,22,12,10),(30,22,14,12),(30,22,36,11),(30,23,0,13),(30,23,3,0),(30,23,14,5),(30,23,20,7),(30,23,25,1),(30,23,33,4),(30,24,3,2),(30,24,4,1),(30,24,13,11),(30,24,14,10),(30,24,15,10),(30,24,27,13),(30,24,30,4),(30,24,33,3),(30,24,35,11),(32,0,4,10),(32,0,5,11),(32,0,6,2),(32,0,8,4),(32,1,6,5),(32,1,14,5),(32,2,5,5),(32,2,18,7),(32,3,2,8),(32,3,4,3),(32,3,29,2),(32,4,19,12),(32,4,26,0),(32,4,29,10),(32,5,4,7),(32,5,15,4),(32,5,16,0),(32,5,19,13),(32,5,22,3),(32,5,26,7),(32,6,2,2),(32,6,3,5),(32,6,7,3),(32,6,16,6),(32,6,23,7),(32,6,24,12),(32,6,25,6),(32,6,26,7),(32,7,21,4),(32,8,27,5),(32,9,0,12),(32,9,7,11),(32,9,9,4),(32,9,10,0),(32,9,17,12),(32,9,23,1),(32,9,27,12),(32,10,11,9),(32,10,15,6),(32,10,16,2),(32,10,28,2),(32,11,10,5),(32,11,12,13),(32,12,12,7),(32,12,21,2),(32,12,25,0),(32,13,2,13),(32,13,5,0),(32,13,8,0),(32,13,9,4),(32,14,0,2),(32,14,20,12),(32,14,24,3),(32,15,3,12),(32,15,7,10),(32,15,8,0),(32,16,5,2),(32,16,6,2),(32,16,10,6),(32,17,4,4),(32,17,10,12),(32,18,7,4),(32,18,10,4),(32,18,12,2),(32,18,20,0),(32,18,21,3),(32,19,1,10),(32,19,8,8),(32,20,4,0),(32,20,8,11),(32,20,9,4),(32,20,16,13),(32,20,21,9),(32,20,23,6),(32,21,4,2),(32,21,5,8),(32,21,8,13),(32,21,20,10),(32,22,5,5),(32,22,6,11),(32,22,8,10),(32,22,12,0),(32,22,26,1),(32,23,6,9),(32,23,7,10),(32,23,9,12),(32,23,11,3),(32,23,12,4),(32,23,13,5),(32,23,14,12),(32,23,15,11),(32,23,16,9),(32,23,18,6),(32,23,23,11),(32,24,8,10),(32,24,10,11),(32,24,11,9),(32,24,14,4),(32,24,16,5),(32,24,17,6),(32,24,23,7),(32,25,3,9),(32,25,7,5),(32,25,12,6),(32,25,13,11),(32,25,28,13),(32,25,29,9),(32,26,3,2),(32,26,5,0),(32,26,25,2),(32,27,3,6),(32,27,10,3),(32,27,18,5),(32,27,26,0),(32,27,29,7),(32,28,16,10),(32,28,17,8),(32,28,18,1),(32,29,14,8),(36,0,0,7),(36,0,16,3),(36,0,33,13),(36,0,35,4),(36,1,10,12),(36,1,12,3),(36,1,14,2),(36,1,33,3),(36,1,38,8),(36,1,40,1),(36,2,2,6),(36,2,21,8),(36,2,22,8),(36,2,38,5),(36,2,43,5),(36,3,19,7),(36,3,20,11),(36,3,36,0),(36,4,10,11),(36,4,14,13),(36,4,21,8),(36,4,24,9),(36,4,34,5),(36,4,36,10),(36,4,38,7),(36,4,39,8),(36,5,2,0),(36,5,15,2),(36,5,17,8),(36,5,19,4),(36,5,20,0),(36,5,37,5),(36,6,20,4),(36,6,24,5),(36,6,36,7),(36,7,2,7),(36,7,4,2),(36,7,5,11),(36,7,7,1),(36,7,15,9),(36,7,17,0),(36,8,16,8),(36,8,28,11),(36,9,1,4),(36,9,6,5),(36,9,18,10),(36,9,31,10),(36,9,32,5),(36,9,34,10),(36,10,0,5),(36,10,1,2),(36,10,3,7),(36,10,4,13),(36,10,18,2),(36,10,22,8),(36,10,31,4),(36,11,6,3),(36,11,27,2),(36,12,10,2),(36,12,22,2),(36,12,28,7),(36,12,34,11),(36,13,2,5),(36,13,3,5),(36,13,4,2),(36,13,19,10),(36,13,35,4),(36,13,41,5),(36,13,43,11),(36,14,33,10),(36,14,34,7),(36,14,35,1),(36,14,40,11),(36,14,41,9),(36,14,42,12),(36,15,10,8),(36,15,25,0),(36,15,35,12),(36,15,40,1),(36,16,4,4),(36,16,7,5),(36,16,15,1),(36,16,24,2),(36,16,33,4),(36,16,41,12),(36,16,42,7),(36,16,43,2),(36,17,16,8),(36,17,18,8),(36,17,29,1),(36,18,4,2),(36,18,9,11),(36,18,14,11),(36,18,21,12),(36,18,23,9),(36,18,34,1),(36,18,40,2),(36,18,42,8),(36,18,43,3),(36,19,18,3),(36,19,25,13),(36,19,34,1),(36,19,40,8),(36,20,5,9),(36,20,10,3),(36,20,24,3),(36,20,31,12),(36,20,37,6),(36,21,12,10),(36,21,17,10),(36,21,19,12),(36,21,24,2),(36,21,25,10),(36,21,26,2),(36,21,28,5),(36,21,29,2),(36,21,37,8),(36,21,38,2),(36,21,40,5),(36,22,19,13),(36,22,22,12),(36,22,27,9),(36,22,29,6),(36,22,32,5),(36,22,42,9),(36,23,8,6),(36,23,14,11),(36,23,15,13),(36,23,16,6),(36,23,19,7),(36,23,29,2),(36,23,34,13),(36,23,38,6),(36,23,39,5),(36,24,7,4),(36,24,8,1),(36,24,11,0),(36,24,12,3),(36,24,16,10),(36,24,19,10),(36,24,29,5),(36,24,42,6),(36,25,7,8),(36,25,10,13),(36,25,16,12),(36,25,19,5),(36,25,20,7),(36,25,30,1),(36,25,38,0),(36,26,9,7),(36,26,12,4),(36,26,16,7),(36,26,28,2),(36,26,35,5),(36,26,42,0),(36,27,10,7),(36,27,12,8),(36,27,16,10),(36,27,28,8),(36,27,34,0),(36,28,1,10),(36,28,4,2),(36,28,8,11),(36,28,9,11),(36,28,17,7),(36,28,31,10),(36,28,35,11),(36,28,41,11),(36,28,42,5),(36,29,4,2),(36,29,8,9),(36,29,11,10),(36,29,35,11),(36,29,37,7),(36,29,43,12),(36,30,15,10),(36,30,26,10),(36,30,34,6),(36,31,6,3),(36,31,8,3),(36,31,19,0),(36,31,27,5),(36,31,43,3),(38,0,10,6),(38,0,16,1),(38,0,19,9),(38,0,38,3),(38,0,39,10),(38,1,11,7),(38,1,12,5),(38,1,16,12),(38,1,18,12),(38,1,37,9),(38,2,1,4),(38,2,10,6),(38,2,13,4),(38,2,15,7),(38,2,18,4),(38,2,19,13),(38,3,1,7),(38,3,2,0),(38,3,14,12),(38,3,15,13),(38,3,19,12),(38,3,22,5),(38,3,34,6),(38,4,10,7),(38,4,12,12),(38,4,14,11),(38,4,15,1),(38,4,17,6),(38,4,20,3),(38,5,13,8),(38,5,17,11),(38,5,39,1),(38,6,17,11),(38,6,20,11),(38,6,21,6),(38,6,31,5),(38,7,3,12),(38,7,7,0),(38,7,17,6),(38,7,19,0),(38,7,22,10),(38,8,6,6),(38,8,10,11),(38,8,11,5),(38,8,13,0),(38,8,16,12),(38,8,28,2),(38,8,39,8),(38,9,0,10),(38,9,2,8),(38,9,3,0),(38,9,7,8),(38,9,9,6),(38,9,12,13),(38,9,13,0),(38,9,28,7),(38,9,35,4),(38,10,0,4),(38,10,3,10),(38,10,4,12),(38,10,11,6),(38,10,22,3),(38,10,30,3),(38,11,5,8),(38,11,16,7),(38,11,30,10),(38,12,6,12),(38,12,7,13),(38,12,8,9),(38,12,14,9),(38,12,22,7),(38,12,27,3),(38,12,30,1),(38,12,32,3),(38,13,1,11),(38,13,7,2),(38,13,15,7),(38,13,21,4),(38,13,23,10),(38,13,32,9),(38,13,39,11),(38,14,1,11),(38,14,4,9),(38,14,16,0),(38,14,21,6),(38,14,30,5),(38,14,33,2),(38,15,7,0),(38,15,19,11),(38,15,20,1),(38,15,23,8),(38,15,27,7),(38,15,31,12),(38,15,34,13),(38,16,0,7),(38,16,7,5),(38,16,9,8),(38,16,10,9),(38,16,17,9),(38,16,37,13),(38,16,38,3),(38,17,14,12),(38,17,18,5),(38,17,23,0),(38,17,32,8),(38,17,33,2),(38,17,36,12),(38,18,14,6),(38,18,19,8),(38,18,20,8),(38,18,23,7),(38,18,33,9),(38,18,35,6),(38,19,9,4),(38,19,11,4),(38,19,13,0),(38,19,15,3),(38,19,18,12),(38,19,20,1),(38,19,22,8),(38,19,24,4),(38,19,32,0),(38,19,36,13),(38,19,39,10),(38,20,10,11),(38,20,11,2),(38,20,20,7),(38,20,25,6),(38,20,32,2),(38,21,9,0),(38,21,18,13),(38,21,29,5),(38,21,31,1),(38,21,32,5),(38,21,33,12),(38,21,36,0),(38,22,19,8),(38,22,33,5),(38,23,21,3),(38,23,32,9),(38,23,37,12),(38,24,21,9),(38,24,23,4),(38,24,25,9),(38,24,26,9),(38,24,37,10),(38,24,39,13),(38,25,18,0),(38,25,21,9),(38,25,33,7),(38,25,39,6),(38,26,5,2),(38,26,6,8),(38,26,15,6),(38,26,18,5),(38,26,20,0),(38,26,21,12),(38,26,35,10),(38,26,36,13),(38,26,38,6),(38,26,39,8),(38,27,13,4),(38,27,14,5),(38,27,28,4),(38,27,33,5),(38,27,39,2),(38,28,18,13),(38,28,20,12),(38,29,0,13),(38,29,9,0),(38,29,16,6),(38,29,17,6),(38,29,18,12),(38,29,22,5),(38,29,26,11),(38,29,27,6),(38,29,29,10),(38,29,33,1),(38,29,35,8),(38,29,36,13);
/*!40000 ALTER TABLE `folliages` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `fow_galaxy_entries`
--

DROP TABLE IF EXISTS `fow_galaxy_entries`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `fow_galaxy_entries` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `galaxy_id` int(11) NOT NULL,
  `player_id` int(11) DEFAULT NULL,
  `alliance_id` int(11) DEFAULT NULL,
  `x` int(11) NOT NULL,
  `y` int(11) NOT NULL,
  `x_end` int(11) NOT NULL,
  `y_end` int(11) NOT NULL,
  `counter` tinyint(2) unsigned NOT NULL DEFAULT '1',
  PRIMARY KEY (`id`),
  UNIQUE KEY `player_visiblity` (`player_id`,`x`,`y`,`x_end`,`y_end`),
  UNIQUE KEY `alliance_visiblity` (`alliance_id`,`x`,`y`,`x_end`,`y_end`),
  KEY `lookup_players_by_coords` (`galaxy_id`,`x`,`x_end`,`y`,`y_end`),
  KEY `for_cleanup` (`counter`),
  CONSTRAINT `fow_galaxy_entries_ibfk_1` FOREIGN KEY (`galaxy_id`) REFERENCES `galaxies` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `fow_galaxy_entries`
--

LOCK TABLES `fow_galaxy_entries` WRITE;
/*!40000 ALTER TABLE `fow_galaxy_entries` DISABLE KEYS */;
INSERT INTO `fow_galaxy_entries` VALUES (1,1,1,NULL,-3,-3,3,3,1);
/*!40000 ALTER TABLE `fow_galaxy_entries` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `fow_ss_entries`
--

DROP TABLE IF EXISTS `fow_ss_entries`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `fow_ss_entries` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `solar_system_id` int(11) NOT NULL,
  `player_id` int(11) DEFAULT NULL,
  `counter` int(11) NOT NULL DEFAULT '0',
  `player_planets` tinyint(1) DEFAULT NULL,
  `player_ships` tinyint(1) DEFAULT NULL,
  `enemy_planets` tinyint(1) NOT NULL DEFAULT '0',
  `enemy_ships` tinyint(1) NOT NULL DEFAULT '0',
  `alliance_id` int(11) DEFAULT NULL,
  `alliance_planet_player_ids` text,
  `alliance_ship_player_ids` text,
  `nap_planets` tinyint(1) DEFAULT NULL,
  `nap_ships` tinyint(1) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `create_for_player` (`solar_system_id`,`player_id`),
  UNIQUE KEY `create_for_alliance` (`solar_system_id`,`alliance_id`),
  KEY `select_by_player` (`player_id`),
  KEY `select_by_alliance` (`alliance_id`),
  KEY `for_cleanup` (`counter`),
  CONSTRAINT `fow_ss_entries_ibfk_1` FOREIGN KEY (`solar_system_id`) REFERENCES `solar_systems` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fow_ss_entries_ibfk_2` FOREIGN KEY (`player_id`) REFERENCES `players` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fow_ss_entries_ibfk_3` FOREIGN KEY (`alliance_id`) REFERENCES `alliances` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `fow_ss_entries`
--

LOCK TABLES `fow_ss_entries` WRITE;
/*!40000 ALTER TABLE `fow_ss_entries` DISABLE KEYS */;
INSERT INTO `fow_ss_entries` VALUES (1,4,1,2,1,0,0,0,NULL,NULL,NULL,NULL,NULL),(2,3,1,1,0,0,0,0,NULL,NULL,NULL,NULL,NULL),(3,2,1,1,0,0,0,0,NULL,NULL,NULL,NULL,NULL),(4,1,1,1,0,0,0,0,NULL,NULL,NULL,NULL,NULL);
/*!40000 ALTER TABLE `fow_ss_entries` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `galaxies`
--

DROP TABLE IF EXISTS `galaxies`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `galaxies` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `created_at` datetime NOT NULL,
  `ruleset` varchar(30) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `galaxies`
--

LOCK TABLES `galaxies` WRITE;
/*!40000 ALTER TABLE `galaxies` DISABLE KEYS */;
INSERT INTO `galaxies` VALUES (1,'2010-10-11 16:20:35','dev');
/*!40000 ALTER TABLE `galaxies` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `naps`
--

DROP TABLE IF EXISTS `naps`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `naps` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `initiator_id` int(11) NOT NULL,
  `acceptor_id` int(11) NOT NULL,
  `status` tinyint(2) unsigned NOT NULL DEFAULT '0',
  `created_at` datetime NOT NULL,
  `expires_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `enforce_one_nap_per_pair` (`initiator_id`,`acceptor_id`),
  KEY `lookup_naps_for_alliance_1st` (`initiator_id`,`status`),
  KEY `lookup_naps_for_alliance_2nd` (`acceptor_id`,`status`),
  CONSTRAINT `naps_ibfk_2` FOREIGN KEY (`acceptor_id`) REFERENCES `alliances` (`id`) ON DELETE CASCADE,
  CONSTRAINT `naps_ibfk_1` FOREIGN KEY (`initiator_id`) REFERENCES `alliances` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `naps`
--

LOCK TABLES `naps` WRITE;
/*!40000 ALTER TABLE `naps` DISABLE KEYS */;
/*!40000 ALTER TABLE `naps` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `notifications`
--

DROP TABLE IF EXISTS `notifications`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `notifications` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `player_id` int(11) NOT NULL,
  `created_at` datetime NOT NULL,
  `expires_at` datetime NOT NULL,
  `event` tinyint(2) unsigned NOT NULL,
  `params` text,
  `starred` tinyint(1) NOT NULL DEFAULT '0',
  `read` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `player` (`player_id`),
  KEY `order` (`read`,`created_at`),
  KEY `index_notifications_on_expires_at` (`expires_at`),
  KEY `foreign_key` (`player_id`),
  CONSTRAINT `notifications_ibfk_1` FOREIGN KEY (`player_id`) REFERENCES `players` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `notifications`
--

LOCK TABLES `notifications` WRITE;
/*!40000 ALTER TABLE `notifications` DISABLE KEYS */;
INSERT INTO `notifications` VALUES (1,1,'2010-10-11 16:20:38','2010-10-25 16:20:38',3,'--- \n:id: 1\n',0,0),(2,1,'2010-10-11 16:20:39','2010-10-25 16:20:39',3,'--- \n:id: 2\n',0,0);
/*!40000 ALTER TABLE `notifications` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `objective_progresses`
--

DROP TABLE IF EXISTS `objective_progresses`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `objective_progresses` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `objective_id` int(11) DEFAULT NULL,
  `player_id` int(11) DEFAULT NULL,
  `completed` tinyint(2) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `objective_fk` (`objective_id`),
  KEY `player_fk` (`player_id`),
  CONSTRAINT `objective_progresses_ibfk_2` FOREIGN KEY (`player_id`) REFERENCES `players` (`id`) ON DELETE CASCADE,
  CONSTRAINT `objective_progresses_ibfk_1` FOREIGN KEY (`objective_id`) REFERENCES `objectives` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `objective_progresses`
--

LOCK TABLES `objective_progresses` WRITE;
/*!40000 ALTER TABLE `objective_progresses` DISABLE KEYS */;
INSERT INTO `objective_progresses` VALUES (1,1,1,0),(2,2,1,0),(3,3,1,0);
/*!40000 ALTER TABLE `objective_progresses` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `objectives`
--

DROP TABLE IF EXISTS `objectives`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `objectives` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `quest_id` int(11) NOT NULL,
  `type` varchar(255) NOT NULL,
  `key` varchar(255) DEFAULT NULL,
  `count` tinyint(2) unsigned NOT NULL DEFAULT '1',
  `level` tinyint(2) unsigned DEFAULT NULL,
  `alliance` tinyint(1) NOT NULL DEFAULT '0',
  `npc` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `quest_objectives` (`quest_id`),
  KEY `on_progress` (`type`,`key`),
  CONSTRAINT `objectives_ibfk_1` FOREIGN KEY (`quest_id`) REFERENCES `quests` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `objectives`
--

LOCK TABLES `objectives` WRITE;
/*!40000 ALTER TABLE `objectives` DISABLE KEYS */;
INSERT INTO `objectives` VALUES (1,1,'HaveUpgradedTo','Building::MetalExtractor',1,1,0,0),(2,1,'HaveUpgradedTo','Building::SolarPlant',2,1,0,0),(3,2,'HaveUpgradedTo','Building::Barracks',1,1,0,0),(4,3,'UpgradeTo','Unit::Trooper',3,1,0,0),(5,4,'UpgradeTo','Unit::Shocker',2,1,0,0),(6,5,'Destroy','Unit::Gnat',10,1,0,0),(7,5,'Destroy','Unit::Glancer',5,1,0,0),(8,6,'HaveUpgradedTo','Building::GroundFactory',1,1,0,0),(9,7,'HaveUpgradedTo','Building::SpaceFactory',1,1,0,0),(10,8,'AnnexPlanet','Planet',1,NULL,0,1),(11,9,'AnnexPlanet','Planet',1,NULL,0,0),(12,10,'HaveUpgradedTo','Unit::Trooper',10,1,0,0),(13,10,'HaveUpgradedTo','Unit::Shocker',5,1,0,0),(14,10,'HaveUpgradedTo','Unit::Seeker',5,1,0,0);
/*!40000 ALTER TABLE `objectives` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `planets`
--

DROP TABLE IF EXISTS `planets`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `planets` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `solar_system_id` int(11) NOT NULL,
  `width` int(11) DEFAULT NULL,
  `height` int(11) DEFAULT NULL,
  `position` int(11) NOT NULL DEFAULT '0',
  `angle` int(11) NOT NULL DEFAULT '0',
  `variation` int(11) NOT NULL DEFAULT '0',
  `type` varchar(255) NOT NULL,
  `player_id` int(11) DEFAULT NULL,
  `name` varchar(255) NOT NULL DEFAULT '',
  `size` int(11) NOT NULL DEFAULT '0',
  `metal_rate` int(10) unsigned DEFAULT NULL,
  `energy_rate` int(10) unsigned DEFAULT NULL,
  `zetium_rate` int(10) unsigned DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uniqueness` (`solar_system_id`,`position`),
  KEY `index_planets_on_galaxy_id_and_solar_system_id` (`solar_system_id`),
  KEY `index_planets_on_player_id_and_galaxy_id` (`player_id`),
  KEY `group_by_for_fowssentry_status_updates` (`player_id`,`solar_system_id`),
  CONSTRAINT `planets_ibfk_2` FOREIGN KEY (`player_id`) REFERENCES `players` (`id`) ON DELETE SET NULL,
  CONSTRAINT `planets_ibfk_1` FOREIGN KEY (`solar_system_id`) REFERENCES `solar_systems` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=39 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `planets`
--

LOCK TABLES `planets` WRITE;
/*!40000 ALTER TABLE `planets` DISABLE KEYS */;
INSERT INTO `planets` VALUES (1,1,NULL,NULL,0,180,1,'Jumpgate',NULL,'G1-S1-P1',48,NULL,NULL,NULL),(2,1,44,36,1,315,1,'Regular',NULL,'G1-S1-P2',64,NULL,NULL,NULL),(3,1,NULL,NULL,2,150,4,'Resource',NULL,'G1-S1-P3',27,225,376,211),(4,1,43,26,3,224,6,'Regular',NULL,'G1-S1-P4',55,NULL,NULL,NULL),(5,1,NULL,NULL,4,306,1,'Jumpgate',NULL,'G1-S1-P5',40,NULL,NULL,NULL),(6,1,NULL,NULL,5,225,4,'Mining',NULL,'G1-S1-P6',46,351,258,288),(7,1,NULL,NULL,6,294,5,'Mining',NULL,'G1-S1-P7',42,159,281,315),(8,1,NULL,NULL,7,167,5,'Mining',NULL,'G1-S1-P8',37,366,237,166),(9,1,NULL,NULL,9,297,0,'Npc',NULL,'G1-S1-P9',27,NULL,NULL,NULL),(10,1,NULL,NULL,10,350,0,'Resource',NULL,'G1-S1-P10',60,322,256,235),(11,1,30,50,11,160,8,'Regular',NULL,'G1-S1-P11',64,NULL,NULL,NULL),(12,1,NULL,NULL,12,108,1,'Jumpgate',NULL,'G1-S1-P12',37,NULL,NULL,NULL),(13,1,NULL,NULL,14,126,2,'Resource',NULL,'G1-S1-P13',28,359,212,106),(14,1,NULL,NULL,15,250,6,'Mining',NULL,'G1-S1-P14',52,123,264,120),(15,1,NULL,NULL,16,220,0,'Jumpgate',NULL,'G1-S1-P15',55,NULL,NULL,NULL),(16,2,NULL,NULL,0,270,2,'Mining',NULL,'G1-S2-P16',35,164,156,252),(17,2,NULL,NULL,3,44,2,'Resource',NULL,'G1-S2-P17',56,348,246,230),(18,2,NULL,NULL,4,234,2,'Jumpgate',NULL,'G1-S2-P18',45,NULL,NULL,NULL),(19,2,NULL,NULL,5,285,0,'Mining',NULL,'G1-S2-P19',56,316,307,294),(20,2,40,28,6,102,0,'Regular',NULL,'G1-S2-P20',54,NULL,NULL,NULL),(21,2,24,35,7,66,0,'Regular',NULL,'G1-S2-P21',47,NULL,NULL,NULL),(22,2,NULL,NULL,8,60,2,'Jumpgate',NULL,'G1-S2-P22',58,NULL,NULL,NULL),(23,2,NULL,NULL,9,90,1,'Mining',NULL,'G1-S2-P23',39,145,113,235),(24,2,NULL,NULL,10,162,1,'Jumpgate',NULL,'G1-S2-P24',54,NULL,NULL,NULL),(25,3,32,37,0,180,6,'Regular',NULL,'G1-S3-P25',55,NULL,NULL,NULL),(26,3,NULL,NULL,1,315,0,'Jumpgate',NULL,'G1-S3-P26',33,NULL,NULL,NULL),(27,3,NULL,NULL,2,270,4,'Mining',NULL,'G1-S3-P27',32,370,132,209),(28,3,NULL,NULL,3,66,0,'Mining',NULL,'G1-S3-P28',38,200,293,225),(29,3,NULL,NULL,4,108,0,'Jumpgate',NULL,'G1-S3-P29',47,NULL,NULL,NULL),(30,3,25,37,5,195,2,'Regular',NULL,'G1-S3-P30',49,NULL,NULL,NULL),(31,3,NULL,NULL,6,180,3,'Mining',NULL,'G1-S3-P31',40,193,213,291),(32,4,30,30,0,180,0,'Homeworld',1,'G1-S4-P32',29,NULL,NULL,NULL),(33,4,NULL,NULL,1,0,2,'Mining',NULL,'G1-S4-P33',39,325,382,330),(34,4,NULL,NULL,2,120,1,'Jumpgate',NULL,'G1-S4-P34',30,NULL,NULL,NULL),(35,4,NULL,NULL,3,292,0,'Npc',NULL,'G1-S4-P35',43,NULL,NULL,NULL),(36,4,32,44,4,18,5,'Regular',NULL,'G1-S4-P36',60,NULL,NULL,NULL),(37,4,NULL,NULL,5,90,6,'Mining',NULL,'G1-S4-P37',42,148,248,366),(38,4,30,40,6,240,4,'Regular',NULL,'G1-S4-P38',56,NULL,NULL,NULL);
/*!40000 ALTER TABLE `planets` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `players`
--

DROP TABLE IF EXISTS `players`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `players` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `galaxy_id` int(11) DEFAULT NULL,
  `auth_token` char(64) NOT NULL,
  `name` varchar(64) NOT NULL,
  `scientists` int(10) unsigned NOT NULL DEFAULT '0',
  `scientists_total` int(10) unsigned NOT NULL DEFAULT '0',
  `alliance_id` int(11) DEFAULT NULL,
  `xp` int(10) unsigned NOT NULL DEFAULT '0',
  `points` int(10) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `authentication` (`galaxy_id`,`auth_token`),
  KEY `index_players_on_alliance_id` (`alliance_id`),
  CONSTRAINT `players_ibfk_1` FOREIGN KEY (`galaxy_id`) REFERENCES `galaxies` (`id`) ON DELETE CASCADE,
  CONSTRAINT `players_ibfk_2` FOREIGN KEY (`alliance_id`) REFERENCES `alliances` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `players`
--

LOCK TABLES `players` WRITE;
/*!40000 ALTER TABLE `players` DISABLE KEYS */;
INSERT INTO `players` VALUES (1,1,'0000000000000000000000000000000000000000000000000000000000000000','Test Player',0,0,NULL,0,0);
/*!40000 ALTER TABLE `players` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `quest_progresses`
--

DROP TABLE IF EXISTS `quest_progresses`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `quest_progresses` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `quest_id` int(11) NOT NULL,
  `player_id` int(11) NOT NULL,
  `status` tinyint(2) unsigned NOT NULL,
  `completed` tinyint(2) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `on_objective_complete` (`quest_id`,`player_id`),
  KEY `listing` (`player_id`,`status`),
  CONSTRAINT `quest_progresses_ibfk_2` FOREIGN KEY (`player_id`) REFERENCES `players` (`id`) ON DELETE CASCADE,
  CONSTRAINT `quest_progresses_ibfk_1` FOREIGN KEY (`quest_id`) REFERENCES `quests` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `quest_progresses`
--

LOCK TABLES `quest_progresses` WRITE;
/*!40000 ALTER TABLE `quest_progresses` DISABLE KEYS */;
INSERT INTO `quest_progresses` VALUES (1,1,1,0,0),(2,2,1,0,0);
/*!40000 ALTER TABLE `quest_progresses` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `quests`
--

DROP TABLE IF EXISTS `quests`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `quests` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `parent_id` int(11) DEFAULT NULL,
  `rewards` text NOT NULL,
  `help_url_id` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `child quests` (`parent_id`),
  CONSTRAINT `quests_ibfk_1` FOREIGN KEY (`parent_id`) REFERENCES `quests` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `quests`
--

LOCK TABLES `quests` WRITE;
/*!40000 ALTER TABLE `quests` DISABLE KEYS */;
INSERT INTO `quests` VALUES (1,NULL,'{\"metal\":100,\"energy\":100,\"zetium\":100}','resources'),(2,NULL,'{\"units\":[{\"level\":1,\"count\":5,\"type\":\"Trooper\"}]}','army'),(3,2,'{\"metal\":300,\"energy\":500,\"zetium\":400}','units'),(4,3,'{\"units\":[{\"level\":3,\"count\":3,\"type\":\"Shocker\"},{\"level\":3,\"count\":3,\"type\":\"Seeker\"}],\"zetium\":100}','units'),(5,4,'{\"units\":[{\"level\":3,\"count\":1,\"type\":\"Scorpion\"}]}','combat'),(6,5,'{\"units\":[{\"level\":1,\"count\":2,\"type\":\"Scorpion\"}]}','ground-factory'),(7,6,'{\"units\":[{\"level\":1,\"count\":2,\"type\":\"Crow\"}]}','space-factory'),(8,7,'{\"metal\":2000,\"energy\":2000,\"zetium\":1500}','annexation'),(9,8,'{\"xp\":1000,\"metal\":2000,\"energy\":2000,\"units\":[{\"level\":2,\"count\":1,\"type\":\"Cyrix\"}],\"zetium\":1500,\"points\":2000}','enemy-annexation'),(10,4,'{\"xp\":1000,\"zetium\":1000,\"points\":1000}',NULL);
/*!40000 ALTER TABLE `quests` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `resources_entries`
--

DROP TABLE IF EXISTS `resources_entries`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `resources_entries` (
  `planet_id` int(11) NOT NULL AUTO_INCREMENT,
  `metal` float NOT NULL DEFAULT '0',
  `metal_storage` float NOT NULL DEFAULT '0',
  `energy` float NOT NULL DEFAULT '0',
  `energy_storage` float NOT NULL DEFAULT '0',
  `zetium` float NOT NULL DEFAULT '0',
  `zetium_storage` float NOT NULL DEFAULT '0',
  `metal_rate` float NOT NULL DEFAULT '0',
  `energy_rate` float NOT NULL DEFAULT '0',
  `zetium_rate` float NOT NULL DEFAULT '0',
  `last_update` datetime DEFAULT NULL,
  `energy_diminish_registered` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`planet_id`),
  KEY `index_resources_entries_on_last_update` (`last_update`),
  CONSTRAINT `resources_entries_ibfk_1` FOREIGN KEY (`planet_id`) REFERENCES `planets` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=39 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `resources_entries`
--

LOCK TABLES `resources_entries` WRITE;
/*!40000 ALTER TABLE `resources_entries` DISABLE KEYS */;
INSERT INTO `resources_entries` VALUES (1,0,0,0,0,0,0,0,0,0,NULL,0),(2,0,0,0,0,0,0,0,0,0,NULL,0),(3,0,0,0,0,0,0,0,0,0,NULL,0),(4,0,0,0,0,0,0,0,0,0,NULL,0),(5,0,0,0,0,0,0,0,0,0,NULL,0),(6,0,0,0,0,0,0,0,0,0,NULL,0),(7,0,0,0,0,0,0,0,0,0,NULL,0),(8,0,0,0,0,0,0,0,0,0,NULL,0),(9,0,0,0,0,0,0,0,0,0,NULL,0),(10,0,0,0,0,0,0,0,0,0,NULL,0),(11,0,0,0,0,0,0,0,0,0,NULL,0),(12,0,0,0,0,0,0,0,0,0,NULL,0),(13,0,0,0,0,0,0,0,0,0,NULL,0),(14,0,0,0,0,0,0,0,0,0,NULL,0),(15,0,0,0,0,0,0,0,0,0,NULL,0),(16,0,0,0,0,0,0,0,0,0,NULL,0),(17,0,0,0,0,0,0,0,0,0,NULL,0),(18,0,0,0,0,0,0,0,0,0,NULL,0),(19,0,0,0,0,0,0,0,0,0,NULL,0),(20,0,0,0,0,0,0,0,0,0,NULL,0),(21,0,0,0,0,0,0,0,0,0,NULL,0),(22,0,0,0,0,0,0,0,0,0,NULL,0),(23,0,0,0,0,0,0,0,0,0,NULL,0),(24,0,0,0,0,0,0,0,0,0,NULL,0),(25,0,0,0,0,0,0,0,0,0,NULL,0),(26,0,0,0,0,0,0,0,0,0,NULL,0),(27,0,0,0,0,0,0,0,0,0,NULL,0),(28,0,0,0,0,0,0,0,0,0,NULL,0),(29,0,0,0,0,0,0,0,0,0,NULL,0),(30,0,0,0,0,0,0,0,0,0,NULL,0),(31,0,0,0,0,0,0,0,0,0,NULL,0),(32,864,3024,1728,6048,0,604.8,50,100,0,'2010-10-11 16:20:38',0),(33,0,0,0,0,0,0,0,0,0,NULL,0),(34,0,0,0,0,0,0,0,0,0,NULL,0),(35,0,0,0,0,0,0,0,0,0,NULL,0),(36,0,0,0,0,0,0,0,0,0,NULL,0),(37,0,0,0,0,0,0,0,0,0,NULL,0),(38,0,0,0,0,0,0,0,0,0,NULL,0);
/*!40000 ALTER TABLE `resources_entries` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `route_hops`
--

DROP TABLE IF EXISTS `route_hops`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `route_hops` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `route_id` int(11) NOT NULL,
  `location_type` tinyint(2) unsigned NOT NULL,
  `location_id` int(10) unsigned NOT NULL,
  `location_x` int(11) DEFAULT NULL,
  `location_y` int(11) DEFAULT NULL,
  `arrives_at` datetime NOT NULL,
  `index` smallint(6) NOT NULL,
  `next` tinyint(1) NOT NULL DEFAULT '0',
  `jumps_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `next_hop` (`route_id`,`index`),
  KEY `route` (`route_id`,`location_type`,`location_id`),
  KEY `next` (`route_id`,`next`),
  CONSTRAINT `route_hops_ibfk_1` FOREIGN KEY (`route_id`) REFERENCES `routes` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `route_hops`
--

LOCK TABLES `route_hops` WRITE;
/*!40000 ALTER TABLE `route_hops` DISABLE KEYS */;
/*!40000 ALTER TABLE `route_hops` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `routes`
--

DROP TABLE IF EXISTS `routes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `routes` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `target_type` tinyint(2) unsigned NOT NULL,
  `target_id` int(10) unsigned NOT NULL,
  `arrives_at` datetime NOT NULL,
  `cached_units` text NOT NULL,
  `player_id` int(11) NOT NULL,
  `target_x` int(11) NOT NULL,
  `target_y` int(11) NOT NULL,
  `target_name` varchar(255) DEFAULT NULL,
  `target_variation` tinyint(2) unsigned DEFAULT NULL,
  `target_solar_system_id` int(11) DEFAULT NULL,
  `current_id` int(11) unsigned NOT NULL,
  `current_type` tinyint(2) unsigned NOT NULL,
  `current_x` int(11) NOT NULL,
  `current_y` int(11) NOT NULL,
  `current_name` varchar(255) DEFAULT NULL,
  `current_variation` tinyint(2) unsigned DEFAULT NULL,
  `current_solar_system_id` int(11) DEFAULT NULL,
  `source_id` int(11) unsigned NOT NULL,
  `source_type` tinyint(2) unsigned NOT NULL,
  `source_x` int(11) NOT NULL,
  `source_y` int(11) NOT NULL,
  `source_name` varchar(255) DEFAULT NULL,
  `source_variation` tinyint(2) unsigned DEFAULT NULL,
  `source_solar_system_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `incoming_routes` (`target_type`,`target_id`),
  KEY `foreign_key` (`player_id`),
  CONSTRAINT `routes_ibfk_1` FOREIGN KEY (`player_id`) REFERENCES `players` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `routes`
--

LOCK TABLES `routes` WRITE;
/*!40000 ALTER TABLE `routes` DISABLE KEYS */;
/*!40000 ALTER TABLE `routes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `schema_migrations`
--

DROP TABLE IF EXISTS `schema_migrations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `schema_migrations` (
  `version` varchar(255) NOT NULL,
  UNIQUE KEY `unique_schema_migrations` (`version`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `schema_migrations`
--

LOCK TABLES `schema_migrations` WRITE;
/*!40000 ALTER TABLE `schema_migrations` DISABLE KEYS */;
INSERT INTO `schema_migrations` VALUES ('20090601175224'),('20090601184051'),('20090601184055'),('20090601184059'),('20090701164131'),('20090713165021'),('20090808144214'),('20090809160211'),('20090810173759'),('20090826140238'),('20090826141836'),('20090829202538'),('20090829210029'),('20090829224505'),('20090830143959'),('20090830145319'),('20090901153809'),('20090904190655'),('20090905175341'),('20090905192056'),('20090906135044'),('20090909222719'),('20090911180950'),('20090912165229'),('20090919155819'),('20091024222359'),('20091103164416'),('20091103180558'),('20091103181146'),('20091109191211'),('20091225193714'),('20100114152902'),('20100121142414'),('20100127115341'),('20100127120219'),('20100127120515'),('20100127121337'),('20100129150736'),('20100203202757'),('20100203204803'),('20100204172507'),('20100204173714'),('20100208163239'),('20100210114531'),('20100212134334'),('20100218181507'),('20100219114448'),('20100220144106'),('20100222144003'),('20100223153023'),('20100224153728'),('20100224163525'),('20100225124928'),('20100225153721'),('20100225155505'),('20100225155739'),('20100226122144'),('20100226122651'),('20100301153626'),('20100302131225'),('20100303131706'),('20100308163148'),('20100308164422'),('20100310172315'),('20100310181338'),('20100311123523'),('20100315112858'),('20100319141401'),('20100322184529'),('20100324134243'),('20100324141652'),('20100331125702'),('20100415130556'),('20100415130600'),('20100415130605'),('20100415134627'),('20100419141518'),('20100419142018'),('20100419164230'),('20100426141509'),('20100428130912'),('20100429171200'),('20100430174140'),('20100610151652'),('20100610180750'),('20100614142225'),('20100614160819'),('20100614162423'),('20100616132525'),('20100616135507'),('20100622124252'),('20100706105523'),('20100710121447'),('20100710191351'),('20100716155807'),('20100719131622'),('20100721155359'),('20100722124307'),('20100812164444'),('20100812164449'),('20100812164518'),('20100812164524'),('20100817165213'),('20100819175736'),('20100820185846'),('20100906095758'),('20100915145823'),('20100929111549'),('20101001155323'),('20101005180058'),('99999999999000'),('99999999999900');
/*!40000 ALTER TABLE `schema_migrations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `solar_systems`
--

DROP TABLE IF EXISTS `solar_systems`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `solar_systems` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `type` varchar(255) NOT NULL,
  `galaxy_id` int(11) NOT NULL,
  `x` mediumint(9) NOT NULL,
  `y` mediumint(9) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uniqueness` (`galaxy_id`,`x`,`y`),
  CONSTRAINT `solar_systems_ibfk_1` FOREIGN KEY (`galaxy_id`) REFERENCES `galaxies` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `solar_systems`
--

LOCK TABLES `solar_systems` WRITE;
/*!40000 ALTER TABLE `solar_systems` DISABLE KEYS */;
INSERT INTO `solar_systems` VALUES (1,'Resource',1,1,1),(2,'Expansion',1,-2,-2),(3,'Expansion',1,-3,3),(4,'Homeworld',1,0,0);
/*!40000 ALTER TABLE `solar_systems` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `technologies`
--

DROP TABLE IF EXISTS `technologies`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `technologies` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `last_update` datetime DEFAULT NULL,
  `upgrade_ends_at` datetime DEFAULT NULL,
  `pause_remainder` int(10) unsigned DEFAULT NULL,
  `scientists` int(10) unsigned DEFAULT '0',
  `level` tinyint(2) unsigned NOT NULL,
  `player_id` int(11) NOT NULL,
  `type` varchar(50) NOT NULL,
  `pause_scientists` int(10) unsigned DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `main` (`player_id`,`type`,`level`),
  UNIQUE KEY `type_by_player` (`player_id`,`type`,`level`),
  UNIQUE KEY `ensure_uniqueness` (`player_id`,`type`),
  KEY `upgrading` (`player_id`,`upgrade_ends_at`),
  CONSTRAINT `technologies_ibfk_1` FOREIGN KEY (`player_id`) REFERENCES `players` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `technologies`
--

LOCK TABLES `technologies` WRITE;
/*!40000 ALTER TABLE `technologies` DISABLE KEYS */;
/*!40000 ALTER TABLE `technologies` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tiles`
--

DROP TABLE IF EXISTS `tiles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tiles` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `kind` tinyint(2) unsigned NOT NULL DEFAULT '0',
  `planet_id` int(11) NOT NULL,
  `x` tinyint(2) unsigned NOT NULL DEFAULT '0',
  `y` tinyint(2) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uniqueness` (`planet_id`,`x`,`y`),
  CONSTRAINT `tiles_ibfk_1` FOREIGN KEY (`planet_id`) REFERENCES `planets` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=3921 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tiles`
--

LOCK TABLES `tiles` WRITE;
/*!40000 ALTER TABLE `tiles` DISABLE KEYS */;
INSERT INTO `tiles` VALUES (1,6,2,2,0),(2,6,2,3,0),(3,6,2,4,0),(4,6,2,5,0),(5,3,2,29,0),(6,3,2,30,0),(7,3,2,31,0),(8,3,2,32,0),(9,3,2,33,0),(10,3,2,34,0),(11,3,2,36,0),(12,3,2,37,0),(13,10,2,0,1),(14,6,2,4,1),(15,6,2,6,1),(16,3,2,27,1),(17,3,2,29,1),(18,3,2,30,1),(19,3,2,31,1),(20,3,2,32,1),(21,3,2,33,1),(22,3,2,34,1),(23,3,2,35,1),(24,3,2,36,1),(25,3,2,37,1),(26,6,2,4,2),(27,6,2,5,2),(28,6,2,6,2),(29,6,2,7,2),(30,3,2,13,2),(31,3,2,26,2),(32,3,2,27,2),(33,3,2,28,2),(34,3,2,29,2),(35,3,2,30,2),(36,3,2,31,2),(37,3,2,32,2),(38,3,2,33,2),(39,3,2,34,2),(40,3,2,35,2),(41,3,2,36,2),(42,3,2,37,2),(43,6,2,5,3),(44,3,2,13,3),(45,3,2,15,3),(46,3,2,28,3),(47,3,2,29,3),(48,3,2,30,3),(49,3,2,31,3),(50,3,2,32,3),(51,3,2,33,3),(52,3,2,34,3),(53,3,2,35,3),(54,3,2,37,3),(55,0,2,8,4),(56,3,2,13,4),(57,3,2,14,4),(58,3,2,15,4),(59,3,2,16,4),(60,3,2,17,4),(61,3,2,30,4),(62,3,2,31,4),(63,3,2,32,4),(64,3,2,33,4),(65,3,2,34,4),(66,4,2,2,5),(67,3,2,12,5),(68,3,2,13,5),(69,3,2,14,5),(70,3,2,15,5),(71,3,2,16,5),(72,3,2,17,5),(73,3,2,28,5),(74,3,2,30,5),(75,3,2,31,5),(76,3,2,32,5),(77,3,2,33,5),(78,3,2,34,5),(79,3,2,35,5),(80,0,2,37,5),(81,4,2,0,6),(82,4,2,1,6),(83,4,2,2,6),(84,4,2,3,6),(85,3,2,11,6),(86,3,2,12,6),(87,3,2,13,6),(88,3,2,14,6),(89,3,2,15,6),(90,3,2,28,6),(91,3,2,29,6),(92,3,2,30,6),(93,3,2,31,6),(94,3,2,32,6),(95,3,2,33,6),(96,3,2,34,6),(97,4,2,0,7),(98,4,2,1,7),(99,4,2,2,7),(100,4,2,3,7),(101,4,2,4,7),(102,3,2,10,7),(103,3,2,11,7),(104,3,2,13,7),(105,3,2,15,7),(106,3,2,16,7),(107,3,2,17,7),(108,1,2,29,7),(109,3,2,31,7),(110,3,2,32,7),(111,3,2,33,7),(112,3,2,34,7),(113,4,2,0,8),(114,4,2,1,8),(115,4,2,2,8),(116,4,2,3,8),(117,4,2,4,8),(118,4,2,5,8),(119,4,2,6,8),(120,4,2,7,8),(121,4,2,8,8),(122,4,2,9,8),(123,3,2,13,8),(124,3,2,14,8),(125,3,2,15,8),(126,3,2,16,8),(127,3,2,17,8),(128,3,2,18,8),(129,3,2,19,8),(130,3,2,20,8),(131,3,2,31,8),(132,3,2,32,8),(133,3,2,33,8),(134,4,2,1,9),(135,4,2,3,9),(136,3,2,13,9),(137,3,2,14,9),(138,3,2,15,9),(139,3,2,16,9),(140,5,2,17,9),(141,5,2,18,9),(142,3,2,20,9),(143,5,2,22,9),(144,5,2,24,9),(145,3,2,27,9),(146,3,2,28,9),(147,3,2,29,9),(148,3,2,30,9),(149,3,2,31,9),(150,3,2,32,9),(151,3,2,34,9),(152,3,2,35,9),(153,3,2,12,10),(154,3,2,13,10),(155,3,2,14,10),(156,3,2,15,10),(157,5,2,17,10),(158,5,2,18,10),(159,5,2,19,10),(160,5,2,20,10),(161,5,2,21,10),(162,5,2,22,10),(163,5,2,23,10),(164,5,2,24,10),(165,7,2,26,10),(166,3,2,27,10),(167,3,2,28,10),(168,3,2,29,10),(169,3,2,30,10),(170,3,2,31,10),(171,3,2,32,10),(172,3,2,33,10),(173,3,2,34,10),(174,3,2,14,11),(175,3,2,15,11),(176,5,2,16,11),(177,5,2,17,11),(178,5,2,18,11),(179,5,2,19,11),(180,5,2,20,11),(181,5,2,21,11),(182,5,2,23,11),(183,7,2,25,11),(184,7,2,26,11),(185,7,2,27,11),(186,7,2,28,11),(187,3,2,29,11),(188,3,2,30,11),(189,3,2,33,11),(190,3,2,34,11),(191,3,2,36,11),(192,14,2,37,11),(193,3,2,40,11),(194,6,2,9,12),(195,5,2,14,12),(196,5,2,15,12),(197,5,2,16,12),(198,5,2,17,12),(199,5,2,18,12),(200,5,2,19,12),(201,5,2,20,12),(202,5,2,21,12),(203,5,2,22,12),(204,5,2,23,12),(205,5,2,24,12),(206,5,2,25,12),(207,7,2,26,12),(208,7,2,27,12),(209,7,2,29,12),(210,7,2,30,12),(211,3,2,32,12),(212,3,2,33,12),(213,3,2,34,12),(214,3,2,36,12),(215,3,2,40,12),(216,3,2,41,12),(217,3,2,42,12),(218,2,2,0,13),(219,6,2,9,13),(220,5,2,15,13),(221,5,2,16,13),(222,5,2,17,13),(223,5,2,18,13),(224,5,2,19,13),(225,5,2,20,13),(226,5,2,21,13),(227,5,2,22,13),(228,5,2,23,13),(229,7,2,25,13),(230,7,2,26,13),(231,7,2,27,13),(232,7,2,28,13),(233,7,2,29,13),(234,3,2,34,13),(235,3,2,36,13),(236,3,2,40,13),(237,3,2,41,13),(238,3,2,42,13),(239,6,2,9,14),(240,7,2,15,14),(241,5,2,16,14),(242,5,2,17,14),(243,5,2,18,14),(244,7,2,19,14),(245,5,2,20,14),(246,7,2,21,14),(247,5,2,22,14),(248,5,2,23,14),(249,0,2,25,14),(250,7,2,27,14),(251,7,2,28,14),(252,7,2,29,14),(253,7,2,30,14),(254,7,2,31,14),(255,7,2,32,14),(256,3,2,33,14),(257,3,2,34,14),(258,3,2,35,14),(259,3,2,36,14),(260,3,2,40,14),(261,0,2,41,14),(262,6,2,9,15),(263,6,2,10,15),(264,7,2,15,15),(265,7,2,16,15),(266,7,2,17,15),(267,7,2,18,15),(268,7,2,19,15),(269,7,2,20,15),(270,7,2,21,15),(271,7,2,22,15),(272,7,2,23,15),(273,7,2,27,15),(274,7,2,28,15),(275,7,2,29,15),(276,3,2,35,15),(277,3,2,36,15),(278,3,2,37,15),(279,3,2,38,15),(280,3,2,39,15),(281,3,2,40,15),(282,6,2,9,16),(283,6,2,10,16),(284,4,2,13,16),(285,4,2,14,16),(286,7,2,16,16),(287,7,2,17,16),(288,7,2,18,16),(289,7,2,19,16),(290,7,2,20,16),(291,7,2,21,16),(292,7,2,23,16),(293,7,2,24,16),(294,7,2,27,16),(295,7,2,28,16),(296,5,2,30,16),(297,3,2,34,16),(298,3,2,35,16),(299,3,2,37,16),(300,3,2,38,16),(301,3,2,39,16),(302,3,2,40,16),(303,6,2,8,17),(304,6,2,9,17),(305,6,2,10,17),(306,6,2,11,17),(307,4,2,13,17),(308,4,2,14,17),(309,4,2,15,17),(310,7,2,16,17),(311,7,2,17,17),(312,7,2,18,17),(313,7,2,19,17),(314,7,2,20,17),(315,7,2,21,17),(316,7,2,22,17),(317,7,2,23,17),(318,7,2,26,17),(319,7,2,27,17),(320,5,2,29,17),(321,5,2,30,17),(322,5,2,31,17),(323,5,2,32,17),(324,3,2,34,17),(325,3,2,35,17),(326,5,2,36,17),(327,3,2,37,17),(328,3,2,38,17),(329,3,2,39,17),(330,3,2,40,17),(331,3,2,41,17),(332,3,2,42,17),(333,4,2,10,18),(334,4,2,11,18),(335,4,2,12,18),(336,4,2,13,18),(337,7,2,16,18),(338,7,2,17,18),(339,7,2,18,18),(340,7,2,19,18),(341,7,2,20,18),(342,7,2,21,18),(343,7,2,27,18),(344,7,2,28,18),(345,1,2,29,18),(346,5,2,31,18),(347,5,2,32,18),(348,5,2,33,18),(349,5,2,34,18),(350,5,2,36,18),(351,3,2,37,18),(352,3,2,38,18),(353,3,2,39,18),(354,12,2,2,19),(355,4,2,9,19),(356,4,2,10,19),(357,4,2,11,19),(358,4,2,12,19),(359,4,2,13,19),(360,4,2,14,19),(361,4,2,15,19),(362,7,2,17,19),(363,11,2,18,19),(364,5,2,28,19),(365,5,2,31,19),(366,5,2,32,19),(367,5,2,33,19),(368,5,2,34,19),(369,5,2,35,19),(370,5,2,36,19),(371,3,2,38,19),(372,3,2,39,19),(373,3,2,40,19),(374,4,2,9,20),(375,4,2,10,20),(376,4,2,11,20),(377,4,2,13,20),(378,5,2,26,20),(379,5,2,27,20),(380,5,2,28,20),(381,5,2,29,20),(382,5,2,30,20),(383,5,2,31,20),(384,5,2,32,20),(385,5,2,33,20),(386,5,2,34,20),(387,5,2,35,20),(388,4,2,36,20),(389,12,2,37,20),(390,4,2,13,21),(391,4,2,14,21),(392,4,2,16,21),(393,4,2,17,21),(394,5,2,27,21),(395,5,2,28,21),(396,5,2,29,21),(397,5,2,30,21),(398,5,2,31,21),(399,5,2,32,21),(400,5,2,33,21),(401,5,2,34,21),(402,4,2,36,21),(403,4,2,11,22),(404,4,2,14,22),(405,4,2,15,22),(406,4,2,16,22),(407,4,2,17,22),(408,5,2,27,22),(409,5,2,28,22),(410,5,2,29,22),(411,5,2,31,22),(412,5,2,32,22),(413,5,2,33,22),(414,4,2,34,22),(415,4,2,35,22),(416,4,2,36,22),(417,4,2,11,23),(418,4,2,15,23),(419,4,2,16,23),(420,4,2,17,23),(421,5,2,29,23),(422,4,2,30,23),(423,4,2,31,23),(424,4,2,34,23),(425,4,2,36,23),(426,4,2,9,24),(427,4,2,10,24),(428,4,2,11,24),(429,4,2,12,24),(430,4,2,15,24),(431,4,2,16,24),(432,4,2,17,24),(433,5,2,29,24),(434,4,2,30,24),(435,4,2,31,24),(436,4,2,34,24),(437,4,2,35,24),(438,4,2,36,24),(439,4,2,9,25),(440,4,2,12,25),(441,4,2,13,25),(442,6,2,14,25),(443,4,2,15,25),(444,4,2,16,25),(445,4,2,17,25),(446,4,2,18,25),(447,4,2,19,25),(448,4,2,20,25),(449,4,2,21,25),(450,4,2,22,25),(451,4,2,30,25),(452,4,2,31,25),(453,4,2,32,25),(454,4,2,33,25),(455,4,2,34,25),(456,4,2,35,25),(457,4,2,36,25),(458,8,2,2,26),(459,4,2,9,26),(460,4,2,10,26),(461,4,2,11,26),(462,4,2,12,26),(463,6,2,13,26),(464,6,2,14,26),(465,6,2,15,26),(466,4,2,16,26),(467,4,2,17,26),(468,4,2,18,26),(469,4,2,19,26),(470,4,2,20,26),(471,4,2,21,26),(472,9,2,22,26),(473,6,2,32,26),(474,4,2,33,26),(475,4,2,34,26),(476,4,2,35,26),(477,4,2,36,26),(478,4,2,37,26),(479,4,2,10,27),(480,4,2,11,27),(481,4,2,12,27),(482,4,2,13,27),(483,6,2,14,27),(484,6,2,15,27),(485,6,2,16,27),(486,6,2,17,27),(487,4,2,18,27),(488,4,2,19,27),(489,4,2,20,27),(490,4,2,21,27),(491,13,2,26,27),(492,6,2,32,27),(493,4,2,35,27),(494,4,2,9,28),(495,4,2,10,28),(496,4,2,11,28),(497,4,2,13,28),(498,4,2,14,28),(499,6,2,15,28),(500,0,2,16,28),(501,4,2,18,28),(502,4,2,19,28),(503,4,2,20,28),(504,4,2,21,28),(505,6,2,32,28),(506,6,2,33,28),(507,4,2,34,28),(508,4,2,35,28),(509,4,2,36,28),(510,5,2,38,28),(511,4,2,9,29),(512,4,2,10,29),(513,4,2,11,29),(514,4,2,13,29),(515,4,2,14,29),(516,6,2,15,29),(517,4,2,18,29),(518,4,2,19,29),(519,4,2,20,29),(520,4,2,21,29),(521,4,2,22,29),(522,5,2,28,29),(523,5,2,29,29),(524,6,2,30,29),(525,6,2,31,29),(526,6,2,32,29),(527,6,2,33,29),(528,5,2,34,29),(529,5,2,35,29),(530,5,2,36,29),(531,5,2,37,29),(532,5,2,38,29),(533,9,2,39,29),(534,0,2,1,30),(535,4,2,10,30),(536,0,2,12,30),(537,6,2,15,30),(538,4,2,16,30),(539,4,2,17,30),(540,4,2,18,30),(541,4,2,20,30),(542,4,2,21,30),(543,5,2,27,30),(544,5,2,29,30),(545,6,2,30,30),(546,5,2,31,30),(547,6,2,32,30),(548,5,2,33,30),(549,5,2,34,30),(550,5,2,36,30),(551,0,2,8,31),(552,4,2,17,31),(553,4,2,18,31),(554,10,2,20,31),(555,5,2,24,31),(556,5,2,25,31),(557,5,2,26,31),(558,5,2,27,31),(559,5,2,28,31),(560,5,2,29,31),(561,6,2,30,31),(562,5,2,31,31),(563,5,2,32,31),(564,5,2,33,31),(565,5,2,34,31),(566,5,2,35,31),(567,5,2,36,31),(568,5,2,37,31),(569,6,2,1,32),(570,6,2,2,32),(571,5,2,24,32),(572,5,2,25,32),(573,5,2,26,32),(574,5,2,27,32),(575,5,2,28,32),(576,5,2,29,32),(577,5,2,30,32),(578,5,2,31,32),(579,5,2,32,32),(580,5,2,33,32),(581,5,2,34,32),(582,5,2,35,32),(583,5,2,36,32),(584,5,2,37,32),(585,5,2,38,32),(586,5,2,39,32),(587,6,2,1,33),(588,5,2,24,33),(589,5,2,25,33),(590,5,2,26,33),(591,5,2,27,33),(592,5,2,28,33),(593,5,2,29,33),(594,5,2,30,33),(595,5,2,31,33),(596,5,2,32,33),(597,5,2,33,33),(598,5,2,34,33),(599,5,2,35,33),(600,5,2,36,33),(601,5,2,37,33),(602,5,2,38,33),(603,5,2,39,33),(604,5,2,40,33),(605,5,2,41,33),(606,6,2,1,34),(607,5,2,24,34),(608,5,2,25,34),(609,5,2,26,34),(610,5,2,27,34),(611,5,2,28,34),(612,5,2,29,34),(613,5,2,30,34),(614,7,2,31,34),(615,5,2,32,34),(616,5,2,33,34),(617,5,2,34,34),(618,5,2,35,34),(619,5,2,36,34),(620,5,2,37,34),(621,5,2,38,34),(622,5,2,39,34),(623,5,2,41,34),(624,5,2,42,34),(625,6,2,0,35),(626,6,2,1,35),(627,6,2,2,35),(628,6,2,3,35),(629,5,2,23,35),(630,5,2,24,35),(631,5,2,25,35),(632,5,2,26,35),(633,5,2,27,35),(634,5,2,28,35),(635,7,2,29,35),(636,7,2,30,35),(637,7,2,31,35),(638,7,2,32,35),(639,5,2,33,35),(640,5,2,34,35),(641,5,2,35,35),(642,5,2,36,35),(643,5,2,37,35),(644,5,2,38,35),(645,5,2,39,35),(646,5,2,40,35),(647,6,4,11,0),(648,6,4,12,0),(649,6,4,13,0),(650,6,4,14,0),(651,6,4,15,0),(652,6,4,16,0),(653,6,4,17,0),(654,4,4,18,0),(655,4,4,19,0),(656,4,4,20,0),(657,4,4,21,0),(658,4,4,22,0),(659,4,4,23,0),(660,4,4,24,0),(661,4,4,25,0),(662,4,4,26,0),(663,4,4,27,0),(664,4,4,28,0),(665,4,4,29,0),(666,4,4,30,0),(667,6,4,40,0),(668,6,4,41,0),(669,6,4,42,0),(670,14,4,7,1),(671,6,4,11,1),(672,4,4,13,1),(673,6,4,14,1),(674,6,4,15,1),(675,6,4,16,1),(676,4,4,18,1),(677,4,4,19,1),(678,4,4,20,1),(679,12,4,21,1),(680,4,4,27,1),(681,4,4,28,1),(682,6,4,40,1),(683,6,4,42,1),(684,0,4,4,2),(685,4,4,12,2),(686,4,4,13,2),(687,4,4,14,2),(688,4,4,15,2),(689,4,4,17,2),(690,4,4,18,2),(691,4,4,19,2),(692,4,4,20,2),(693,4,4,27,2),(694,4,4,28,2),(695,6,4,42,2),(696,4,4,13,3),(697,4,4,14,3),(698,4,4,16,3),(699,4,4,17,3),(700,4,4,18,3),(701,4,4,19,3),(702,4,4,20,3),(703,3,4,34,3),(704,13,4,35,3),(705,6,4,41,3),(706,6,4,42,3),(707,4,4,13,4),(708,4,4,14,4),(709,4,4,15,4),(710,4,4,18,4),(711,4,4,20,4),(712,3,4,29,4),(713,3,4,30,4),(714,3,4,32,4),(715,3,4,33,4),(716,3,4,34,4),(717,6,4,41,4),(718,6,4,42,4),(719,4,4,11,5),(720,4,4,12,5),(721,4,4,13,5),(722,4,4,14,5),(723,4,4,15,5),(724,4,4,16,5),(725,4,4,17,5),(726,2,4,18,5),(727,3,4,28,5),(728,3,4,29,5),(729,3,4,30,5),(730,3,4,31,5),(731,3,4,32,5),(732,3,4,33,5),(733,3,4,34,5),(734,3,4,35,5),(735,12,4,36,5),(736,6,4,42,5),(737,8,4,9,6),(738,4,4,12,6),(739,4,4,13,6),(740,4,4,14,6),(741,4,4,15,6),(742,4,4,16,6),(743,4,4,17,6),(744,3,4,28,6),(745,3,4,29,6),(746,3,4,30,6),(747,3,4,31,6),(748,3,4,32,6),(749,3,4,33,6),(750,3,4,34,6),(751,3,4,35,6),(752,3,4,42,6),(753,4,4,12,7),(754,4,4,13,7),(755,4,4,14,7),(756,4,4,15,7),(757,4,4,16,7),(758,4,4,17,7),(759,3,4,30,7),(760,3,4,31,7),(761,3,4,32,7),(762,3,4,33,7),(763,3,4,34,7),(764,3,4,35,7),(765,3,4,42,7),(766,6,4,3,8),(767,4,4,12,8),(768,4,4,13,8),(769,4,4,14,8),(770,4,4,15,8),(771,7,4,26,8),(772,3,4,29,8),(773,3,4,30,8),(774,3,4,33,8),(775,3,4,42,8),(776,6,4,3,9),(777,5,4,9,9),(778,5,4,10,9),(779,13,4,11,9),(780,7,4,26,9),(781,7,4,28,9),(782,7,4,29,9),(783,3,4,30,9),(784,3,4,33,9),(785,3,4,42,9),(786,6,4,3,10),(787,6,4,4,10),(788,5,4,9,10),(789,5,4,10,10),(790,7,4,26,10),(791,7,4,27,10),(792,7,4,28,10),(793,7,4,29,10),(794,7,4,30,10),(795,7,4,31,10),(796,3,4,33,10),(797,3,4,34,10),(798,3,4,35,10),(799,3,4,42,10),(800,6,4,2,11),(801,6,4,3,11),(802,6,4,4,11),(803,5,4,8,11),(804,5,4,9,11),(805,5,4,10,11),(806,5,4,11,11),(807,5,4,12,11),(808,7,4,26,11),(809,7,4,27,11),(810,7,4,28,11),(811,7,4,29,11),(812,3,4,30,11),(813,0,4,33,11),(814,3,4,35,11),(815,3,4,36,11),(816,3,4,37,11),(817,3,4,38,11),(818,3,4,39,11),(819,3,4,40,11),(820,3,4,41,11),(821,3,4,42,11),(822,7,4,1,12),(823,6,4,3,12),(824,5,4,7,12),(825,6,4,8,12),(826,5,4,9,12),(827,0,4,10,12),(828,5,4,12,12),(829,3,4,27,12),(830,3,4,28,12),(831,7,4,29,12),(832,3,4,30,12),(833,3,4,31,12),(834,3,4,35,12),(835,3,4,36,12),(836,3,4,38,12),(837,3,4,39,12),(838,3,4,40,12),(839,3,4,41,12),(840,3,4,42,12),(841,7,4,0,13),(842,7,4,1,13),(843,6,4,3,13),(844,6,4,4,13),(845,5,4,6,13),(846,5,4,7,13),(847,6,4,8,13),(848,6,4,9,13),(849,14,4,23,13),(850,3,4,26,13),(851,3,4,27,13),(852,3,4,28,13),(853,3,4,29,13),(854,3,4,30,13),(855,3,4,37,13),(856,3,4,38,13),(857,3,4,39,13),(858,0,4,40,13),(859,3,4,42,13),(860,7,4,0,14),(861,7,4,1,14),(862,7,4,2,14),(863,6,4,3,14),(864,5,4,6,14),(865,5,4,7,14),(866,5,4,8,14),(867,6,4,9,14),(868,6,4,10,14),(869,6,4,11,14),(870,6,4,12,14),(871,6,4,13,14),(872,3,4,26,14),(873,3,4,27,14),(874,3,4,28,14),(875,3,4,29,14),(876,3,4,30,14),(877,3,4,31,14),(878,3,4,42,14),(879,7,4,0,15),(880,7,4,1,15),(881,7,4,2,15),(882,5,4,6,15),(883,5,4,7,15),(884,6,4,11,15),(885,3,4,26,15),(886,3,4,28,15),(887,3,4,29,15),(888,3,4,30,15),(889,3,4,31,15),(890,3,4,32,15),(891,3,4,33,15),(892,3,4,42,15),(893,7,4,0,16),(894,7,4,2,16),(895,7,4,3,16),(896,0,4,4,16),(897,5,4,7,16),(898,0,4,9,16),(899,0,4,17,16),(900,3,4,27,16),(901,3,4,28,16),(902,3,4,29,16),(903,3,4,30,16),(904,9,4,31,16),(905,3,4,41,16),(906,3,4,42,16),(907,7,4,0,17),(908,7,4,2,17),(909,5,4,7,17),(910,5,4,8,17),(911,3,4,28,17),(912,3,4,30,17),(913,3,4,42,17),(914,6,4,7,18),(915,6,4,8,18),(916,6,4,9,18),(917,6,4,10,18),(918,6,4,11,18),(919,5,4,24,18),(920,5,4,25,18),(921,3,4,28,18),(922,3,4,29,18),(923,3,4,30,18),(924,3,4,40,18),(925,3,4,41,18),(926,3,4,42,18),(927,6,4,6,19),(928,6,4,7,19),(929,5,4,25,19),(930,5,4,26,19),(931,5,4,27,19),(932,11,4,34,19),(933,11,4,38,19),(934,6,4,6,20),(935,6,4,7,20),(936,6,4,8,20),(937,6,4,9,20),(938,8,4,11,20),(939,4,4,14,20),(940,5,4,26,20),(941,5,4,27,20),(942,5,4,28,20),(943,4,4,14,21),(944,4,4,15,21),(945,4,4,17,21),(946,10,4,22,21),(947,5,4,26,21),(948,1,4,2,22),(949,4,4,14,22),(950,4,4,15,22),(951,4,4,17,22),(952,5,4,26,22),(953,4,4,11,23),(954,4,4,12,23),(955,4,4,13,23),(956,4,4,14,23),(957,4,4,15,23),(958,4,4,16,23),(959,4,4,17,23),(960,4,4,9,24),(961,4,4,10,24),(962,4,4,11,24),(963,4,4,12,24),(964,4,4,13,24),(965,4,4,14,24),(966,4,4,15,24),(967,4,4,16,24),(968,4,4,17,24),(969,4,4,18,24),(970,4,4,9,25),(971,4,4,10,25),(972,4,4,11,25),(973,4,4,12,25),(974,4,4,13,25),(975,4,4,14,25),(976,4,4,15,25),(977,4,4,17,25),(978,4,4,18,25),(979,3,11,1,0),(980,3,11,2,0),(981,3,11,3,0),(982,3,11,4,0),(983,3,11,7,0),(984,4,11,9,0),(985,4,11,12,0),(986,4,11,14,0),(987,4,11,15,0),(988,4,11,16,0),(989,11,11,17,0),(990,3,11,0,1),(991,3,11,1,1),(992,3,11,2,1),(993,3,11,3,1),(994,3,11,4,1),(995,3,11,5,1),(996,3,11,7,1),(997,4,11,8,1),(998,4,11,9,1),(999,4,11,10,1),(1000,4,11,11,1),(1001,4,11,12,1),(1002,4,11,13,1),(1003,4,11,14,1),(1004,4,11,15,1),(1005,4,11,16,1),(1006,3,11,0,2),(1007,3,11,1,2),(1008,3,11,2,2),(1009,3,11,3,2),(1010,3,11,4,2),(1011,3,11,5,2),(1012,3,11,6,2),(1013,3,11,7,2),(1014,3,11,8,2),(1015,4,11,9,2),(1016,4,11,10,2),(1017,4,11,11,2),(1018,4,11,12,2),(1019,4,11,13,2),(1020,4,11,14,2),(1021,4,11,15,2),(1022,4,11,16,2),(1023,5,11,23,2),(1024,5,11,24,2),(1025,5,11,25,2),(1026,3,11,0,3),(1027,3,11,2,3),(1028,3,11,3,3),(1029,3,11,4,3),(1030,3,11,5,3),(1031,3,11,6,3),(1032,5,11,7,3),(1033,5,11,8,3),(1034,4,11,9,3),(1035,5,11,10,3),(1036,4,11,11,3),(1037,4,11,12,3),(1038,4,11,13,3),(1039,4,11,14,3),(1040,4,11,15,3),(1041,4,11,16,3),(1042,5,11,21,3),(1043,5,11,22,3),(1044,5,11,23,3),(1045,5,11,25,3),(1046,3,11,0,4),(1047,3,11,2,4),(1048,3,11,3,4),(1049,3,11,4,4),(1050,3,11,5,4),(1051,5,11,6,4),(1052,5,11,7,4),(1053,5,11,8,4),(1054,5,11,9,4),(1055,5,11,10,4),(1056,4,11,11,4),(1057,4,11,13,4),(1058,4,11,14,4),(1059,4,11,15,4),(1060,4,11,16,4),(1061,5,11,21,4),(1062,5,11,22,4),(1063,5,11,23,4),(1064,5,11,24,4),(1065,5,11,25,4),(1066,5,11,26,4),(1067,3,11,3,5),(1068,5,11,7,5),(1069,5,11,8,5),(1070,5,11,9,5),(1071,5,11,10,5),(1072,5,11,11,5),(1073,4,11,12,5),(1074,4,11,13,5),(1075,4,11,14,5),(1076,4,11,15,5),(1077,4,11,16,5),(1078,5,11,21,5),(1079,5,11,22,5),(1080,5,11,24,5),(1081,12,11,2,6),(1082,5,11,8,6),(1083,5,11,9,6),(1084,5,11,10,6),(1085,5,11,11,6),(1086,14,11,12,6),(1087,4,11,15,6),(1088,6,11,16,6),(1089,6,11,17,6),(1090,5,11,21,6),(1091,5,11,22,6),(1092,5,11,23,6),(1093,10,11,24,6),(1094,5,11,8,7),(1095,5,11,9,7),(1096,5,11,10,7),(1097,5,11,11,7),(1098,6,11,15,7),(1099,6,11,16,7),(1100,6,11,17,7),(1101,6,11,18,7),(1102,6,11,19,7),(1103,5,11,22,7),(1104,5,11,23,7),(1105,5,11,9,8),(1106,5,11,10,8),(1107,6,11,15,8),(1108,6,11,16,8),(1109,6,11,17,8),(1110,6,11,19,8),(1111,5,11,21,8),(1112,5,11,22,8),(1113,5,11,23,8),(1114,3,11,1,9),(1115,6,11,15,9),(1116,6,11,16,9),(1117,6,11,17,9),(1118,6,11,18,9),(1119,5,11,23,9),(1120,3,11,1,10),(1121,6,11,12,10),(1122,6,11,13,10),(1123,6,11,14,10),(1124,6,11,15,10),(1125,6,11,16,10),(1126,6,11,17,10),(1127,6,11,18,10),(1128,13,11,23,10),(1129,3,11,0,11),(1130,3,11,1,11),(1131,5,11,12,11),(1132,5,11,13,11),(1133,5,11,14,11),(1134,5,11,15,11),(1135,6,11,16,11),(1136,6,11,17,11),(1137,3,11,0,12),(1138,3,11,1,12),(1139,3,11,2,12),(1140,3,11,3,12),(1141,5,11,12,12),(1142,5,11,13,12),(1143,5,11,14,12),(1144,6,11,15,12),(1145,6,11,16,12),(1146,6,11,17,12),(1147,1,11,20,12),(1148,3,11,2,13),(1149,3,11,3,13),(1150,3,11,4,13),(1151,3,11,5,13),(1152,3,11,10,13),(1153,3,11,11,13),(1154,5,11,12,13),(1155,5,11,13,13),(1156,5,11,14,13),(1157,5,11,15,13),(1158,5,11,16,13),(1159,3,11,1,14),(1160,3,11,2,14),(1161,3,11,3,14),(1162,3,11,4,14),(1163,3,11,9,14),(1164,3,11,10,14),(1165,3,11,11,14),(1166,5,11,12,14),(1167,5,11,13,14),(1168,5,11,14,14),(1169,5,11,15,14),(1170,3,11,1,15),(1171,3,11,2,15),(1172,3,11,3,15),(1173,3,11,4,15),(1174,3,11,7,15),(1175,3,11,8,15),(1176,3,11,10,15),(1177,3,11,12,15),(1178,5,11,13,15),(1179,5,11,14,15),(1180,5,11,16,15),(1181,3,11,0,16),(1182,3,11,1,16),(1183,3,11,2,16),(1184,3,11,3,16),(1185,3,11,4,16),(1186,3,11,5,16),(1187,3,11,7,16),(1188,3,11,8,16),(1189,3,11,9,16),(1190,3,11,10,16),(1191,3,11,11,16),(1192,3,11,12,16),(1193,5,11,13,16),(1194,5,11,14,16),(1195,5,11,15,16),(1196,5,11,16,16),(1197,0,11,17,16),(1198,6,11,23,16),(1199,3,11,0,17),(1200,3,11,1,17),(1201,3,11,2,17),(1202,3,11,3,17),(1203,3,11,8,17),(1204,3,11,9,17),(1205,3,11,10,17),(1206,3,11,11,17),(1207,3,11,12,17),(1208,3,11,13,17),(1209,5,11,14,17),(1210,5,11,16,17),(1211,6,11,23,17),(1212,3,11,1,18),(1213,3,11,8,18),(1214,3,11,9,18),(1215,3,11,10,18),(1216,3,11,12,18),(1217,3,11,13,18),(1218,6,11,23,18),(1219,6,11,27,18),(1220,3,11,0,19),(1221,3,11,1,19),(1222,0,11,2,19),(1223,3,11,8,19),(1224,3,11,13,19),(1225,3,11,14,19),(1226,6,11,22,19),(1227,6,11,23,19),(1228,6,11,24,19),(1229,6,11,25,19),(1230,6,11,26,19),(1231,6,11,27,19),(1232,6,11,7,20),(1233,6,11,8,20),(1234,6,11,9,20),(1235,3,11,12,20),(1236,3,11,13,20),(1237,0,11,20,20),(1238,6,11,22,20),(1239,6,11,23,20),(1240,6,11,24,20),(1241,6,11,8,21),(1242,6,11,9,21),(1243,0,11,13,21),(1244,6,11,22,21),(1245,6,11,23,21),(1246,6,11,24,21),(1247,6,11,6,22),(1248,6,11,7,22),(1249,6,11,8,22),(1250,6,11,9,22),(1251,6,11,10,22),(1252,6,11,20,22),(1253,6,11,21,22),(1254,6,11,22,22),(1255,6,11,23,22),(1256,6,11,24,22),(1257,6,11,25,22),(1258,6,11,6,23),(1259,6,11,7,23),(1260,6,11,9,23),(1261,6,11,10,23),(1262,6,11,21,23),(1263,6,11,22,23),(1264,6,11,23,23),(1265,6,11,5,24),(1266,6,11,6,24),(1267,6,11,7,24),(1268,6,11,8,24),(1269,6,11,9,24),(1270,6,11,10,24),(1271,6,11,11,24),(1272,6,11,21,24),(1273,6,11,22,24),(1274,6,11,6,25),(1275,6,11,7,25),(1276,6,11,8,25),(1277,6,11,9,25),(1278,7,11,0,26),(1279,7,11,1,26),(1280,7,11,2,26),(1281,7,11,3,26),(1282,6,11,6,26),(1283,6,11,8,26),(1284,4,11,11,26),(1285,7,11,0,27),(1286,7,11,2,27),(1287,4,11,6,27),(1288,4,11,7,27),(1289,4,11,10,27),(1290,4,11,11,27),(1291,4,11,12,27),(1292,7,11,0,28),(1293,0,11,1,28),(1294,4,11,6,28),(1295,4,11,9,28),(1296,4,11,10,28),(1297,4,11,11,28),(1298,4,11,12,28),(1299,4,11,13,28),(1300,4,11,14,28),(1301,4,11,15,28),(1302,7,11,0,29),(1303,7,11,3,29),(1304,4,11,5,29),(1305,4,11,6,29),(1306,4,11,7,29),(1307,4,11,8,29),(1308,4,11,9,29),(1309,4,11,10,29),(1310,4,11,11,29),(1311,4,11,12,29),(1312,4,11,13,29),(1313,4,11,14,29),(1314,4,11,15,29),(1315,7,11,18,29),(1316,2,11,26,29),(1317,7,11,0,30),(1318,7,11,1,30),(1319,7,11,2,30),(1320,7,11,3,30),(1321,7,11,4,30),(1322,4,11,7,30),(1323,4,11,8,30),(1324,4,11,9,30),(1325,4,11,10,30),(1326,4,11,11,30),(1327,4,11,12,30),(1328,4,11,13,30),(1329,7,11,16,30),(1330,7,11,18,30),(1331,7,11,19,30),(1332,8,11,0,31),(1333,7,11,3,31),(1334,7,11,4,31),(1335,4,11,5,31),(1336,4,11,6,31),(1337,4,11,7,31),(1338,4,11,8,31),(1339,10,11,9,31),(1340,4,11,13,31),(1341,7,11,16,31),(1342,7,11,18,31),(1343,7,11,19,31),(1344,7,11,3,32),(1345,7,11,4,32),(1346,4,11,8,32),(1347,7,11,15,32),(1348,7,11,16,32),(1349,7,11,17,32),(1350,7,11,18,32),(1351,7,11,4,33),(1352,7,11,5,33),(1353,7,11,14,33),(1354,7,11,15,33),(1355,7,11,16,33),(1356,7,11,17,33),(1357,7,11,18,33),(1358,7,11,19,33),(1359,7,11,2,34),(1360,7,11,3,34),(1361,7,11,4,34),(1362,7,11,13,34),(1363,7,11,15,34),(1364,7,11,16,34),(1365,7,11,17,34),(1366,7,11,18,34),(1367,7,11,19,34),(1368,7,11,3,35),(1369,7,11,4,35),(1370,7,11,5,35),(1371,7,11,6,35),(1372,7,11,12,35),(1373,7,11,13,35),(1374,7,11,14,35),(1375,7,11,15,35),(1376,7,11,16,35),(1377,7,11,17,35),(1378,7,11,19,35),(1379,7,11,2,36),(1380,7,11,3,36),(1381,7,11,4,36),(1382,7,11,5,36),(1383,14,11,13,36),(1384,7,11,16,36),(1385,7,11,17,36),(1386,3,11,26,36),(1387,3,11,27,36),(1388,3,11,28,36),(1389,3,11,29,36),(1390,7,11,2,37),(1391,7,11,4,37),(1392,9,11,17,37),(1393,3,11,26,37),(1394,3,11,27,37),(1395,3,11,28,37),(1396,3,11,24,38),(1397,3,11,25,38),(1398,3,11,26,38),(1399,3,11,27,38),(1400,3,11,28,38),(1401,3,11,25,39),(1402,3,11,26,39),(1403,3,11,22,40),(1404,3,11,23,40),(1405,3,11,24,40),(1406,3,11,25,40),(1407,3,11,25,41),(1408,3,11,26,41),(1409,3,11,28,41),(1410,3,11,29,41),(1411,0,11,1,42),(1412,3,11,23,42),(1413,3,11,24,42),(1414,3,11,25,42),(1415,3,11,26,42),(1416,3,11,27,42),(1417,3,11,28,42),(1418,5,11,14,43),(1419,5,11,15,43),(1420,3,11,23,43),(1421,4,11,26,43),(1422,3,11,28,43),(1423,3,11,4,44),(1424,3,11,5,44),(1425,5,11,12,44),(1426,5,11,13,44),(1427,5,11,14,44),(1428,4,11,21,44),(1429,4,11,22,44),(1430,4,11,25,44),(1431,4,11,26,44),(1432,3,11,28,44),(1433,3,11,29,44),(1434,3,11,4,45),(1435,3,11,5,45),(1436,3,11,8,45),(1437,3,11,9,45),(1438,3,11,10,45),(1439,5,11,12,45),(1440,5,11,13,45),(1441,5,11,14,45),(1442,5,11,15,45),(1443,5,11,16,45),(1444,4,11,20,45),(1445,4,11,21,45),(1446,4,11,22,45),(1447,4,11,25,45),(1448,3,11,29,45),(1449,3,11,4,46),(1450,3,11,5,46),(1451,3,11,6,46),(1452,3,11,8,46),(1453,3,11,9,46),(1454,3,11,10,46),(1455,5,11,12,46),(1456,5,11,13,46),(1457,5,11,14,46),(1458,5,11,15,46),(1459,13,11,16,46),(1460,4,11,22,46),(1461,4,11,24,46),(1462,4,11,25,46),(1463,4,11,26,46),(1464,3,11,3,47),(1465,3,11,4,47),(1466,3,11,5,47),(1467,3,11,6,47),(1468,3,11,8,47),(1469,3,11,9,47),(1470,3,11,10,47),(1471,3,11,11,47),(1472,5,11,13,47),(1473,5,11,14,47),(1474,5,11,15,47),(1475,4,11,22,47),(1476,4,11,23,47),(1477,4,11,24,47),(1478,4,11,25,47),(1479,4,11,26,47),(1480,4,11,27,47),(1481,4,11,28,47),(1482,3,11,4,48),(1483,3,11,6,48),(1484,3,11,7,48),(1485,3,11,8,48),(1486,3,11,9,48),(1487,3,11,10,48),(1488,3,11,11,48),(1489,3,11,12,48),(1490,5,11,13,48),(1491,5,11,14,48),(1492,5,11,15,48),(1493,4,11,16,48),(1494,4,11,17,48),(1495,4,11,18,48),(1496,4,11,19,48),(1497,4,11,20,48),(1498,4,11,21,48),(1499,4,11,22,48),(1500,4,11,23,48),(1501,4,11,24,48),(1502,4,11,25,48),(1503,3,11,6,49),(1504,3,11,7,49),(1505,3,11,8,49),(1506,3,11,10,49),(1507,5,11,12,49),(1508,5,11,13,49),(1509,5,11,14,49),(1510,5,11,15,49),(1511,5,11,16,49),(1512,4,11,17,49),(1513,4,11,18,49),(1514,4,11,19,49),(1515,4,11,20,49),(1516,4,11,21,49),(1517,4,11,22,49),(1518,4,11,23,49),(1519,4,11,24,49),(1520,4,11,25,49),(1521,4,11,26,49),(1522,6,20,1,0),(1523,5,20,7,0),(1524,5,20,8,0),(1525,5,20,10,0),(1526,6,20,34,0),(1527,6,20,35,0),(1528,6,20,36,0),(1529,6,20,37,0),(1530,6,20,38,0),(1531,6,20,39,0),(1532,6,20,0,1),(1533,6,20,1,1),(1534,5,20,7,1),(1535,5,20,8,1),(1536,5,20,9,1),(1537,5,20,10,1),(1538,5,20,11,1),(1539,4,20,24,1),(1540,6,20,38,1),(1541,6,20,0,2),(1542,6,20,1,2),(1543,5,20,7,2),(1544,5,20,8,2),(1545,5,20,9,2),(1546,5,20,10,2),(1547,3,20,19,2),(1548,4,20,23,2),(1549,4,20,24,2),(1550,4,20,25,2),(1551,4,20,26,2),(1552,4,20,28,2),(1553,12,20,33,2),(1554,6,20,0,3),(1555,2,20,2,3),(1556,5,20,8,3),(1557,5,20,10,3),(1558,5,20,11,3),(1559,5,20,12,3),(1560,3,20,18,3),(1561,3,20,19,3),(1562,4,20,24,3),(1563,4,20,26,3),(1564,4,20,27,3),(1565,4,20,28,3),(1566,6,20,0,4),(1567,1,20,5,4),(1568,5,20,8,4),(1569,7,20,15,4),(1570,3,20,18,4),(1571,3,20,19,4),(1572,3,20,20,4),(1573,4,20,22,4),(1574,4,20,23,4),(1575,4,20,24,4),(1576,4,20,25,4),(1577,4,20,26,4),(1578,4,20,27,4),(1579,4,20,28,4),(1580,4,20,29,4),(1581,7,20,14,5),(1582,7,20,15,5),(1583,7,20,16,5),(1584,7,20,17,5),(1585,7,20,18,5),(1586,3,20,19,5),(1587,3,20,20,5),(1588,3,20,21,5),(1589,3,20,22,5),(1590,4,20,23,5),(1591,4,20,26,5),(1592,4,20,27,5),(1593,7,20,13,6),(1594,7,20,14,6),(1595,7,20,15,6),(1596,7,20,17,6),(1597,7,20,18,6),(1598,7,20,19,6),(1599,7,20,20,6),(1600,3,20,21,6),(1601,3,20,22,6),(1602,3,20,23,6),(1603,4,20,24,6),(1604,4,20,25,6),(1605,4,20,26,6),(1606,4,20,27,6),(1607,7,20,17,7),(1608,7,20,18,7),(1609,7,20,19,7),(1610,7,20,20,7),(1611,3,20,21,7),(1612,3,20,22,7),(1613,3,20,23,7),(1614,3,20,24,7),(1615,3,20,25,7),(1616,4,20,26,7),(1617,4,20,27,7),(1618,0,20,30,7),(1619,7,20,17,8),(1620,7,20,18,8),(1621,7,20,19,8),(1622,3,20,20,8),(1623,3,20,21,8),(1624,3,20,22,8),(1625,3,20,23,8),(1626,3,20,32,8),(1627,13,20,9,9),(1628,7,20,17,9),(1629,7,20,18,9),(1630,7,20,19,9),(1631,3,20,20,9),(1632,6,20,21,9),(1633,6,20,22,9),(1634,6,20,23,9),(1635,3,20,29,9),(1636,3,20,30,9),(1637,3,20,31,9),(1638,3,20,32,9),(1639,12,20,33,9),(1640,7,20,17,10),(1641,7,20,18,10),(1642,3,20,19,10),(1643,3,20,20,10),(1644,6,20,21,10),(1645,6,20,22,10),(1646,3,20,27,10),(1647,3,20,28,10),(1648,3,20,29,10),(1649,3,20,30,10),(1650,3,20,32,10),(1651,8,20,4,11),(1652,6,20,21,11),(1653,6,20,22,11),(1654,3,20,27,11),(1655,3,20,28,11),(1656,3,20,29,11),(1657,3,20,30,11),(1658,3,20,31,11),(1659,3,20,32,11),(1660,0,20,17,12),(1661,3,20,27,12),(1662,3,20,29,12),(1663,3,20,31,12),(1664,3,20,32,12),(1665,3,20,29,13),(1666,3,20,32,13),(1667,4,20,3,14),(1668,4,20,4,14),(1669,5,20,7,14),(1670,0,20,24,14),(1671,4,20,3,15),(1672,4,20,4,15),(1673,4,20,5,15),(1674,5,20,6,15),(1675,5,20,7,15),(1676,5,20,8,15),(1677,5,20,10,15),(1678,13,20,12,15),(1679,7,20,19,15),(1680,4,20,1,16),(1681,4,20,3,16),(1682,4,20,4,16),(1683,4,20,5,16),(1684,5,20,6,16),(1685,5,20,7,16),(1686,5,20,8,16),(1687,5,20,9,16),(1688,5,20,10,16),(1689,7,20,18,16),(1690,7,20,19,16),(1691,7,20,20,16),(1692,6,20,26,16),(1693,6,20,27,16),(1694,3,20,37,16),(1695,3,20,38,16),(1696,4,20,1,17),(1697,4,20,2,17),(1698,4,20,3,17),(1699,4,20,4,17),(1700,4,20,5,17),(1701,4,20,6,17),(1702,5,20,7,17),(1703,5,20,8,17),(1704,3,20,9,17),(1705,5,20,10,17),(1706,7,20,13,17),(1707,7,20,14,17),(1708,7,20,15,17),(1709,7,20,16,17),(1710,7,20,17,17),(1711,7,20,18,17),(1712,7,20,19,17),(1713,7,20,20,17),(1714,7,20,21,17),(1715,7,20,22,17),(1716,6,20,26,17),(1717,6,20,27,17),(1718,4,20,30,17),(1719,4,20,31,17),(1720,3,20,36,17),(1721,3,20,37,17),(1722,3,20,38,17),(1723,4,20,0,18),(1724,4,20,1,18),(1725,4,20,2,18),(1726,4,20,3,18),(1727,4,20,4,18),(1728,4,20,5,18),(1729,5,20,6,18),(1730,5,20,7,18),(1731,5,20,8,18),(1732,3,20,9,18),(1733,7,20,13,18),(1734,7,20,14,18),(1735,7,20,15,18),(1736,7,20,16,18),(1737,7,20,17,18),(1738,7,20,18,18),(1739,7,20,19,18),(1740,6,20,26,18),(1741,2,20,29,18),(1742,4,20,31,18),(1743,4,20,32,18),(1744,11,20,33,18),(1745,3,20,37,18),(1746,3,20,38,18),(1747,4,20,0,19),(1748,4,20,1,19),(1749,4,20,2,19),(1750,4,20,3,19),(1751,4,20,4,19),(1752,4,20,5,19),(1753,5,20,6,19),(1754,5,20,7,19),(1755,3,20,8,19),(1756,3,20,9,19),(1757,14,20,13,19),(1758,7,20,17,19),(1759,7,20,19,19),(1760,0,20,24,19),(1761,4,20,31,19),(1762,4,20,32,19),(1763,3,20,38,19),(1764,3,20,5,20),(1765,3,20,6,20),(1766,3,20,7,20),(1767,3,20,8,20),(1768,3,20,9,20),(1769,3,20,10,20),(1770,3,20,11,20),(1771,7,20,16,20),(1772,7,20,17,20),(1773,4,20,28,20),(1774,4,20,29,20),(1775,4,20,30,20),(1776,4,20,31,20),(1777,4,20,32,20),(1778,3,20,37,20),(1779,3,20,38,20),(1780,3,20,39,20),(1781,11,20,0,21),(1782,3,20,5,21),(1783,3,20,8,21),(1784,3,20,10,21),(1785,3,20,11,21),(1786,3,20,12,21),(1787,4,20,17,21),(1788,4,20,28,21),(1789,4,20,29,21),(1790,4,20,30,21),(1791,4,20,31,21),(1792,4,20,32,21),(1793,3,20,38,21),(1794,3,20,39,21),(1795,3,20,5,22),(1796,3,20,7,22),(1797,3,20,8,22),(1798,3,20,9,22),(1799,3,20,10,22),(1800,3,20,11,22),(1801,3,20,12,22),(1802,4,20,17,22),(1803,4,20,18,22),(1804,9,20,24,22),(1805,4,20,28,22),(1806,4,20,29,22),(1807,4,20,30,22),(1808,4,20,31,22),(1809,4,20,32,22),(1810,3,20,37,22),(1811,3,20,38,22),(1812,3,20,39,22),(1813,10,20,4,23),(1814,5,20,8,23),(1815,3,20,9,23),(1816,10,20,10,23),(1817,4,20,14,23),(1818,4,20,16,23),(1819,4,20,17,23),(1820,4,20,18,23),(1821,4,20,19,23),(1822,4,20,30,23),(1823,4,20,31,23),(1824,4,20,32,23),(1825,3,20,37,23),(1826,3,20,38,23),(1827,3,20,39,23),(1828,5,20,8,24),(1829,3,20,9,24),(1830,4,20,14,24),(1831,4,20,15,24),(1832,4,20,16,24),(1833,4,20,17,24),(1834,0,20,20,24),(1835,5,20,29,24),(1836,5,20,31,24),(1837,5,20,32,24),(1838,9,20,33,24),(1839,3,20,37,24),(1840,3,20,39,24),(1841,5,20,8,25),(1842,5,20,9,25),(1843,4,20,14,25),(1844,4,20,15,25),(1845,4,20,16,25),(1846,4,20,17,25),(1847,4,20,18,25),(1848,5,20,29,25),(1849,5,20,30,25),(1850,5,20,31,25),(1851,5,20,32,25),(1852,3,20,37,25),(1853,3,20,38,25),(1854,3,20,39,25),(1855,5,20,8,26),(1856,5,20,9,26),(1857,4,20,14,26),(1858,4,20,15,26),(1859,4,20,16,26),(1860,4,20,17,26),(1861,4,20,18,26),(1862,4,20,19,26),(1863,4,20,20,26),(1864,5,20,28,26),(1865,5,20,29,26),(1866,5,20,30,26),(1867,5,20,31,26),(1868,5,20,32,26),(1869,3,20,38,26),(1870,5,20,0,27),(1871,5,20,1,27),(1872,5,20,2,27),(1873,5,20,3,27),(1874,5,20,4,27),(1875,5,20,5,27),(1876,5,20,6,27),(1877,5,20,7,27),(1878,5,20,8,27),(1879,5,20,9,27),(1880,5,20,10,27),(1881,5,20,11,27),(1882,4,20,14,27),(1883,4,20,15,27),(1884,4,20,16,27),(1885,5,20,27,27),(1886,5,20,28,27),(1887,5,20,29,27),(1888,5,20,30,27),(1889,5,20,31,27),(1890,5,20,32,27),(1891,4,21,8,0),(1892,13,21,14,0),(1893,4,21,8,1),(1894,0,21,1,2),(1895,4,21,3,2),(1896,4,21,4,2),(1897,4,21,5,2),(1898,4,21,6,2),(1899,4,21,7,2),(1900,4,21,8,2),(1901,4,21,9,2),(1902,4,21,10,2),(1903,4,21,14,2),(1904,4,21,15,2),(1905,4,21,16,2),(1906,4,21,17,2),(1907,4,21,18,2),(1908,4,21,4,3),(1909,4,21,9,3),(1910,4,21,17,3),(1911,4,21,18,3),(1912,4,21,19,3),(1913,4,21,20,3),(1914,4,21,3,4),(1915,4,21,4,4),(1916,4,21,9,4),(1917,4,21,10,4),(1918,6,21,11,4),(1919,6,21,12,4),(1920,4,21,17,4),(1921,4,21,18,4),(1922,4,21,19,4),(1923,4,21,20,4),(1924,4,21,21,4),(1925,4,21,22,4),(1926,4,21,23,4),(1927,6,21,9,5),(1928,6,21,10,5),(1929,6,21,11,5),(1930,6,21,12,5),(1931,3,21,14,5),(1932,3,21,15,5),(1933,3,21,16,5),(1934,10,21,19,5),(1935,7,21,3,6),(1936,7,21,4,6),(1937,5,21,6,6),(1938,6,21,8,6),(1939,6,21,9,6),(1940,6,21,10,6),(1941,6,21,11,6),(1942,3,21,14,6),(1943,3,21,15,6),(1944,3,21,16,6),(1945,3,21,17,6),(1946,3,21,18,6),(1947,7,21,0,7),(1948,7,21,1,7),(1949,7,21,2,7),(1950,7,21,3,7),(1951,5,21,5,7),(1952,5,21,6,7),(1953,5,21,7,7),(1954,5,21,8,7),(1955,6,21,10,7),(1956,6,21,11,7),(1957,3,21,14,7),(1958,3,21,15,7),(1959,3,21,16,7),(1960,3,21,17,7),(1961,3,21,18,7),(1962,7,21,0,8),(1963,7,21,2,8),(1964,7,21,3,8),(1965,5,21,4,8),(1966,5,21,5,8),(1967,5,21,6,8),(1968,5,21,7,8),(1969,5,21,8,8),(1970,5,21,9,8),(1971,5,21,10,8),(1972,1,21,11,8),(1973,8,21,14,8),(1974,3,21,17,8),(1975,3,21,18,8),(1976,7,21,0,9),(1977,7,21,1,9),(1978,7,21,2,9),(1979,5,21,5,9),(1980,5,21,6,9),(1981,5,21,7,9),(1982,5,21,8,9),(1983,5,21,9,9),(1984,5,21,10,9),(1985,3,21,17,9),(1986,3,21,18,9),(1987,7,21,0,10),(1988,7,21,1,10),(1989,7,21,2,10),(1990,7,21,3,10),(1991,5,21,5,10),(1992,5,21,6,10),(1993,5,21,7,10),(1994,5,21,8,10),(1995,5,21,9,10),(1996,5,21,10,10),(1997,5,21,11,10),(1998,5,21,12,10),(1999,11,21,19,10),(2000,7,21,0,11),(2001,7,21,1,11),(2002,7,21,3,11),(2003,7,21,4,11),(2004,0,21,5,11),(2005,5,21,8,11),(2006,5,21,10,11),(2007,7,21,0,12),(2008,7,21,1,12),(2009,7,21,2,12),(2010,7,21,3,12),(2011,7,21,4,12),(2012,5,21,10,12),(2013,0,21,0,13),(2014,7,21,2,13),(2015,7,21,3,13),(2016,7,21,4,13),(2017,7,21,5,13),(2018,7,21,6,13),(2019,7,21,7,13),(2020,7,21,2,14),(2021,7,21,3,14),(2022,7,21,4,14),(2023,7,21,5,14),(2024,7,21,3,15),(2025,7,21,4,15),(2026,2,21,11,15),(2027,0,21,1,16),(2028,0,21,16,16),(2029,5,21,3,17),(2030,5,21,0,18),(2031,5,21,1,18),(2032,5,21,2,18),(2033,5,21,3,18),(2034,5,21,4,18),(2035,5,21,5,18),(2036,6,21,6,18),(2037,5,21,1,19),(2038,5,21,2,19),(2039,5,21,3,19),(2040,6,21,4,19),(2041,6,21,5,19),(2042,6,21,6,19),(2043,6,21,7,19),(2044,12,21,11,19),(2045,0,21,21,19),(2046,5,21,0,20),(2047,5,21,1,20),(2048,5,21,2,20),(2049,6,21,3,20),(2050,6,21,4,20),(2051,6,21,5,20),(2052,6,21,7,20),(2053,5,21,0,21),(2054,5,21,2,21),(2055,6,21,3,21),(2056,6,21,4,21),(2057,6,21,5,21),(2058,6,21,6,21),(2059,0,21,8,21),(2060,5,21,18,21),(2061,5,21,0,22),(2062,5,21,1,22),(2063,5,21,2,22),(2064,6,21,3,22),(2065,6,21,4,22),(2066,6,21,5,22),(2067,6,21,6,22),(2068,3,21,7,22),(2069,3,21,10,22),(2070,5,21,18,22),(2071,5,21,19,22),(2072,5,21,0,23),(2073,5,21,1,23),(2074,5,21,2,23),(2075,6,21,3,23),(2076,6,21,4,23),(2077,6,21,6,23),(2078,3,21,7,23),(2079,3,21,8,23),(2080,3,21,9,23),(2081,3,21,10,23),(2082,5,21,17,23),(2083,5,21,18,23),(2084,5,21,19,23),(2085,5,21,20,23),(2086,5,21,21,23),(2087,5,21,22,23),(2088,5,21,0,24),(2089,5,21,1,24),(2090,5,21,2,24),(2091,6,21,3,24),(2092,6,21,4,24),(2093,6,21,5,24),(2094,3,21,6,24),(2095,3,21,7,24),(2096,3,21,8,24),(2097,3,21,10,24),(2098,5,21,17,24),(2099,5,21,18,24),(2100,5,21,19,24),(2101,5,21,1,25),(2102,5,21,2,25),(2103,5,21,3,25),(2104,5,21,4,25),(2105,3,21,6,25),(2106,3,21,7,25),(2107,3,21,8,25),(2108,3,21,9,25),(2109,3,21,10,25),(2110,3,21,11,25),(2111,3,21,12,25),(2112,3,21,13,25),(2113,3,21,14,25),(2114,3,21,15,25),(2115,5,21,16,25),(2116,5,21,17,25),(2117,5,21,18,25),(2118,5,21,19,25),(2119,5,21,20,25),(2120,1,21,21,25),(2121,5,21,1,26),(2122,14,21,3,26),(2123,12,21,6,26),(2124,3,21,12,26),(2125,3,21,13,26),(2126,3,21,14,26),(2127,3,21,15,26),(2128,5,21,17,26),(2129,5,21,18,26),(2130,5,21,19,26),(2131,5,21,20,26),(2132,3,21,12,27),(2133,9,21,13,27),(2134,5,21,17,27),(2135,5,21,18,27),(2136,5,21,19,27),(2137,5,21,20,27),(2138,3,21,12,28),(2139,5,21,17,28),(2140,5,21,18,28),(2141,5,21,20,28),(2142,3,21,12,29),(2143,5,21,18,29),(2144,10,21,0,30),(2145,4,21,4,30),(2146,4,21,5,30),(2147,3,21,12,30),(2148,3,21,13,30),(2149,3,21,14,30),(2150,4,21,4,31),(2151,4,21,5,31),(2152,3,21,12,31),(2153,3,21,13,31),(2154,4,21,17,31),(2155,4,21,4,32),(2156,4,21,5,32),(2157,4,21,6,32),(2158,4,21,7,32),(2159,0,21,13,32),(2160,4,21,15,32),(2161,4,21,16,32),(2162,4,21,17,32),(2163,4,21,19,32),(2164,4,21,4,33),(2165,4,21,5,33),(2166,4,21,6,33),(2167,4,21,7,33),(2168,4,21,8,33),(2169,4,21,15,33),(2170,4,21,16,33),(2171,4,21,17,33),(2172,4,21,18,33),(2173,4,21,19,33),(2174,4,21,3,34),(2175,4,21,4,34),(2176,4,21,5,34),(2177,4,21,15,34),(2178,4,21,17,34),(2179,4,21,18,34),(2180,4,21,19,34),(2181,4,21,20,34),(2182,4,25,23,0),(2183,4,25,24,0),(2184,4,25,25,0),(2185,4,25,26,0),(2186,4,25,27,0),(2187,0,25,28,0),(2188,3,25,12,1),(2189,4,25,24,1),(2190,4,25,25,1),(2191,4,25,26,1),(2192,0,25,9,2),(2193,3,25,12,2),(2194,3,25,13,2),(2195,4,25,25,2),(2196,4,25,26,2),(2197,4,25,27,2),(2198,4,25,28,2),(2199,4,25,29,2),(2200,3,25,11,3),(2201,3,25,12,3),(2202,4,25,24,3),(2203,4,25,25,3),(2204,4,25,26,3),(2205,4,25,27,3),(2206,4,25,28,3),(2207,4,25,29,3),(2208,4,25,30,3),(2209,3,25,11,4),(2210,3,25,12,4),(2211,3,25,13,4),(2212,13,25,14,4),(2213,11,25,22,4),(2214,4,25,26,4),(2215,4,25,27,4),(2216,4,25,28,4),(2217,4,25,29,4),(2218,6,25,30,4),(2219,6,25,31,4),(2220,8,25,3,5),(2221,12,25,6,5),(2222,3,25,12,5),(2223,3,25,13,5),(2224,4,25,26,5),(2225,4,25,27,5),(2226,4,25,29,5),(2227,6,25,30,5),(2228,6,25,31,5),(2229,3,25,12,6),(2230,12,25,13,6),(2231,3,25,27,6),(2232,6,25,28,6),(2233,6,25,30,6),(2234,6,25,31,6),(2235,3,25,26,7),(2236,3,25,27,7),(2237,6,25,28,7),(2238,6,25,29,7),(2239,6,25,30,7),(2240,14,25,0,8),(2241,3,25,26,8),(2242,3,25,27,8),(2243,3,25,28,8),(2244,3,25,29,8),(2245,3,25,30,8),(2246,3,25,26,9),(2247,3,25,27,9),(2248,3,25,28,9),(2249,3,25,29,9),(2250,3,25,30,9),(2251,3,25,26,10),(2252,3,25,27,10),(2253,3,25,28,10),(2254,3,25,29,10),(2255,7,25,6,11),(2256,4,25,20,11),(2257,0,25,22,11),(2258,3,25,25,11),(2259,3,25,26,11),(2260,3,25,27,11),(2261,3,25,28,11),(2262,7,25,3,12),(2263,7,25,4,12),(2264,7,25,5,12),(2265,7,25,6,12),(2266,7,25,7,12),(2267,4,25,10,12),(2268,4,25,11,12),(2269,4,25,14,12),(2270,4,25,16,12),(2271,4,25,17,12),(2272,4,25,18,12),(2273,4,25,19,12),(2274,4,25,20,12),(2275,4,25,21,12),(2276,3,25,25,12),(2277,3,25,26,12),(2278,3,25,28,12),(2279,3,25,29,12),(2280,7,25,0,13),(2281,7,25,1,13),(2282,7,25,3,13),(2283,7,25,4,13),(2284,7,25,5,13),(2285,7,25,6,13),(2286,7,25,7,13),(2287,4,25,11,13),(2288,4,25,12,13),(2289,4,25,13,13),(2290,4,25,14,13),(2291,4,25,15,13),(2292,4,25,16,13),(2293,10,25,17,13),(2294,3,25,26,13),(2295,3,25,27,13),(2296,3,25,28,13),(2297,0,25,29,13),(2298,7,25,1,14),(2299,7,25,2,14),(2300,7,25,3,14),(2301,7,25,5,14),(2302,7,25,6,14),(2303,7,25,7,14),(2304,4,25,13,14),(2305,4,25,14,14),(2306,4,25,15,14),(2307,0,25,26,14),(2308,3,25,28,14),(2309,7,25,2,15),(2310,7,25,3,15),(2311,7,25,5,15),(2312,7,25,6,15),(2313,4,25,13,15),(2314,4,25,14,15),(2315,4,25,15,15),(2316,4,25,16,15),(2317,3,25,28,15),(2318,7,25,29,15),(2319,7,25,30,15),(2320,7,25,31,15),(2321,4,25,13,16),(2322,4,25,14,16),(2323,4,25,15,16),(2324,4,25,16,16),(2325,6,25,28,16),(2326,6,25,29,16),(2327,7,25,30,16),(2328,7,25,31,16),(2329,4,25,6,17),(2330,6,25,26,17),(2331,6,25,27,17),(2332,6,25,28,17),(2333,6,25,29,17),(2334,6,25,30,17),(2335,7,25,31,17),(2336,4,25,2,18),(2337,4,25,3,18),(2338,4,25,4,18),(2339,4,25,6,18),(2340,6,25,27,18),(2341,6,25,28,18),(2342,7,25,29,18),(2343,7,25,30,18),(2344,7,25,31,18),(2345,4,25,2,19),(2346,4,25,3,19),(2347,4,25,4,19),(2348,4,25,5,19),(2349,4,25,6,19),(2350,4,25,7,19),(2351,6,25,15,19),(2352,6,25,16,19),(2353,6,25,17,19),(2354,6,25,27,19),(2355,7,25,28,19),(2356,7,25,29,19),(2357,7,25,30,19),(2358,7,25,31,19),(2359,4,25,1,20),(2360,4,25,2,20),(2361,4,25,3,20),(2362,4,25,4,20),(2363,4,25,6,20),(2364,4,25,7,20),(2365,4,25,8,20),(2366,6,25,14,20),(2367,6,25,15,20),(2368,6,25,16,20),(2369,6,25,17,20),(2370,4,25,21,20),(2371,4,25,22,20),(2372,7,25,29,20),(2373,7,25,30,20),(2374,0,25,0,21),(2375,4,25,3,21),(2376,4,25,4,21),(2377,4,25,5,21),(2378,4,25,6,21),(2379,4,25,8,21),(2380,6,25,14,21),(2381,6,25,15,21),(2382,6,25,16,21),(2383,4,25,21,21),(2384,4,25,22,21),(2385,4,25,23,21),(2386,4,25,24,21),(2387,4,25,25,21),(2388,4,25,26,21),(2389,7,25,28,21),(2390,7,25,29,21),(2391,7,25,30,21),(2392,7,25,31,21),(2393,4,25,4,22),(2394,4,25,6,22),(2395,4,25,7,22),(2396,11,25,13,22),(2397,4,25,20,22),(2398,4,25,21,22),(2399,4,25,22,22),(2400,4,25,23,22),(2401,4,25,24,22),(2402,4,25,25,22),(2403,7,25,28,22),(2404,7,25,31,22),(2405,5,25,6,23),(2406,4,25,7,23),(2407,6,25,18,23),(2408,6,25,19,23),(2409,4,25,20,23),(2410,4,25,22,23),(2411,4,25,24,23),(2412,4,25,25,23),(2413,4,25,26,23),(2414,4,25,27,23),(2415,7,25,28,23),(2416,7,25,30,23),(2417,7,25,31,23),(2418,1,25,4,24),(2419,5,25,6,24),(2420,0,25,7,24),(2421,6,25,17,24),(2422,6,25,18,24),(2423,6,25,19,24),(2424,6,25,20,24),(2425,6,25,21,24),(2426,4,25,23,24),(2427,4,25,24,24),(2428,4,25,25,24),(2429,6,25,0,25),(2430,6,25,1,25),(2431,5,25,6,25),(2432,6,25,20,25),(2433,4,25,22,25),(2434,4,25,23,25),(2435,6,25,0,26),(2436,6,25,1,26),(2437,6,25,2,26),(2438,5,25,4,26),(2439,5,25,5,26),(2440,5,25,6,26),(2441,5,25,7,26),(2442,5,25,8,26),(2443,6,25,19,26),(2444,6,25,20,26),(2445,4,25,23,26),(2446,6,25,0,27),(2447,6,25,1,27),(2448,5,25,2,27),(2449,5,25,3,27),(2450,5,25,4,27),(2451,5,25,5,27),(2452,5,25,6,27),(2453,5,25,7,27),(2454,10,25,17,27),(2455,4,25,23,27),(2456,5,25,28,27),(2457,5,25,30,27),(2458,6,25,0,28),(2459,5,25,1,28),(2460,5,25,2,28),(2461,5,25,3,28),(2462,5,25,6,28),(2463,5,25,7,28),(2464,5,25,28,28),(2465,5,25,29,28),(2466,5,25,30,28),(2467,5,25,31,28),(2468,6,25,0,29),(2469,6,25,1,29),(2470,5,25,3,29),(2471,5,25,4,29),(2472,5,25,5,29),(2473,5,25,28,29),(2474,5,25,29,29),(2475,5,25,30,29),(2476,5,25,31,29),(2477,5,25,3,30),(2478,5,25,4,30),(2479,0,25,6,30),(2480,3,25,8,30),(2481,3,25,10,30),(2482,5,25,31,30),(2483,9,25,1,31),(2484,3,25,8,31),(2485,3,25,9,31),(2486,3,25,10,31),(2487,3,25,11,31),(2488,3,25,13,31),(2489,5,25,31,31),(2490,3,25,8,32),(2491,3,25,9,32),(2492,3,25,10,32),(2493,3,25,11,32),(2494,3,25,12,32),(2495,3,25,13,32),(2496,14,25,15,32),(2497,5,25,28,32),(2498,5,25,29,32),(2499,5,25,30,32),(2500,5,25,31,32),(2501,13,25,6,33),(2502,3,25,12,33),(2503,3,25,13,33),(2504,3,25,21,33),(2505,3,25,22,33),(2506,5,25,30,33),(2507,4,25,12,34),(2508,4,25,13,34),(2509,3,25,21,34),(2510,3,25,22,34),(2511,3,25,23,34),(2512,3,25,24,34),(2513,3,25,25,34),(2514,3,25,26,34),(2515,2,25,28,34),(2516,5,25,30,34),(2517,5,25,31,34),(2518,4,25,1,35),(2519,4,25,3,35),(2520,4,25,5,35),(2521,4,25,6,35),(2522,4,25,7,35),(2523,4,25,8,35),(2524,4,25,9,35),(2525,4,25,10,35),(2526,4,25,11,35),(2527,4,25,12,35),(2528,4,25,13,35),(2529,4,25,14,35),(2530,3,25,21,35),(2531,3,25,23,35),(2532,3,25,24,35),(2533,5,25,30,35),(2534,5,25,31,35),(2535,4,25,1,36),(2536,4,25,2,36),(2537,4,25,3,36),(2538,4,25,4,36),(2539,4,25,5,36),(2540,4,25,6,36),(2541,4,25,7,36),(2542,4,25,8,36),(2543,4,25,9,36),(2544,4,25,10,36),(2545,4,25,11,36),(2546,4,25,12,36),(2547,4,25,13,36),(2548,3,25,22,36),(2549,3,25,23,36),(2550,3,25,24,36),(2551,3,25,25,36),(2552,5,25,30,36),(2553,5,25,31,36),(2554,3,30,0,0),(2555,3,30,2,0),(2556,3,30,3,0),(2557,3,30,4,0),(2558,2,30,14,0),(2559,3,30,0,1),(2560,3,30,1,1),(2561,3,30,2,1),(2562,3,30,3,1),(2563,3,30,4,1),(2564,3,30,0,2),(2565,3,30,1,2),(2566,3,30,2,2),(2567,3,30,3,2),(2568,3,30,4,2),(2569,4,30,8,2),(2570,3,30,14,2),(2571,3,30,0,3),(2572,3,30,2,3),(2573,3,30,3,3),(2574,3,30,4,3),(2575,0,30,6,3),(2576,4,30,8,3),(2577,3,30,12,3),(2578,3,30,13,3),(2579,3,30,14,3),(2580,3,30,16,3),(2581,3,30,19,3),(2582,3,30,3,4),(2583,3,30,4,4),(2584,4,30,8,4),(2585,4,30,9,4),(2586,3,30,14,4),(2587,3,30,15,4),(2588,3,30,16,4),(2589,3,30,17,4),(2590,3,30,18,4),(2591,3,30,19,4),(2592,4,30,3,5),(2593,4,30,4,5),(2594,4,30,5,5),(2595,4,30,6,5),(2596,4,30,7,5),(2597,4,30,8,5),(2598,4,30,9,5),(2599,3,30,11,5),(2600,3,30,12,5),(2601,3,30,13,5),(2602,3,30,14,5),(2603,3,30,15,5),(2604,6,30,16,5),(2605,3,30,17,5),(2606,0,30,19,5),(2607,4,30,4,6),(2608,14,30,6,6),(2609,4,30,9,6),(2610,11,30,10,6),(2611,6,30,14,6),(2612,6,30,15,6),(2613,6,30,16,6),(2614,3,30,17,6),(2615,3,30,18,6),(2616,6,30,14,7),(2617,6,30,15,7),(2618,6,30,16,7),(2619,6,30,17,7),(2620,6,30,18,7),(2621,3,30,14,8),(2622,3,30,15,8),(2623,6,30,16,8),(2624,6,30,17,8),(2625,3,30,14,9),(2626,3,30,15,9),(2627,3,30,16,9),(2628,6,30,17,9),(2629,3,30,14,10),(2630,3,30,15,10),(2631,3,30,16,10),(2632,3,30,17,10),(2633,0,30,22,10),(2634,3,30,14,11),(2635,3,30,15,11),(2636,3,30,16,11),(2637,3,30,17,11),(2638,3,30,13,12),(2639,3,30,14,12),(2640,8,30,5,13),(2641,3,30,14,13),(2642,3,30,15,13),(2643,3,30,16,13),(2644,3,30,17,13),(2645,3,30,14,14),(2646,3,30,17,14),(2647,3,30,17,15),(2648,3,30,19,15),(2649,3,30,20,15),(2650,8,30,12,16),(2651,3,30,15,16),(2652,3,30,16,16),(2653,3,30,17,16),(2654,3,30,18,16),(2655,3,30,19,16),(2656,10,30,20,16),(2657,3,30,16,17),(2658,3,30,17,17),(2659,9,30,1,18),(2660,7,30,6,18),(2661,7,30,8,18),(2662,0,30,9,18),(2663,3,30,15,18),(2664,3,30,16,18),(2665,3,30,17,18),(2666,7,30,5,19),(2667,7,30,6,19),(2668,7,30,7,19),(2669,7,30,8,19),(2670,4,30,13,19),(2671,4,30,14,19),(2672,3,30,15,19),(2673,3,30,16,19),(2674,3,30,17,19),(2675,3,30,18,19),(2676,7,30,5,20),(2677,7,30,6,20),(2678,7,30,7,20),(2679,7,30,8,20),(2680,7,30,9,20),(2681,4,30,14,20),(2682,4,30,15,20),(2683,4,30,16,20),(2684,4,30,17,20),(2685,3,30,18,20),(2686,3,30,19,20),(2687,6,30,20,20),(2688,7,30,21,20),(2689,7,30,22,20),(2690,5,30,1,21),(2691,5,30,2,21),(2692,5,30,3,21),(2693,5,30,4,21),(2694,7,30,5,21),(2695,7,30,6,21),(2696,13,30,9,21),(2697,4,30,15,21),(2698,4,30,16,21),(2699,4,30,17,21),(2700,0,30,18,21),(2701,6,30,20,21),(2702,7,30,21,21),(2703,7,30,22,21),(2704,7,30,23,21),(2705,5,30,0,22),(2706,5,30,1,22),(2707,5,30,2,22),(2708,5,30,3,22),(2709,5,30,4,22),(2710,5,30,5,22),(2711,4,30,6,22),(2712,4,30,16,22),(2713,6,30,17,22),(2714,6,30,20,22),(2715,7,30,21,22),(2716,7,30,22,22),(2717,7,30,23,22),(2718,5,30,0,23),(2719,5,30,1,23),(2720,5,30,2,23),(2721,5,30,3,23),(2722,5,30,4,23),(2723,4,30,5,23),(2724,4,30,6,23),(2725,4,30,7,23),(2726,4,30,8,23),(2727,4,30,9,23),(2728,4,30,10,23),(2729,4,30,11,23),(2730,4,30,12,23),(2731,4,30,13,23),(2732,4,30,14,23),(2733,4,30,15,23),(2734,4,30,16,23),(2735,6,30,17,23),(2736,6,30,18,23),(2737,6,30,19,23),(2738,6,30,20,23),(2739,7,30,21,23),(2740,7,30,22,23),(2741,7,30,23,23),(2742,5,30,0,24),(2743,5,30,1,24),(2744,11,30,2,24),(2745,4,30,6,24),(2746,4,30,7,24),(2747,4,30,8,24),(2748,4,30,9,24),(2749,4,30,11,24),(2750,4,30,12,24),(2751,4,30,13,24),(2752,4,30,14,24),(2753,6,30,15,24),(2754,6,30,16,24),(2755,6,30,17,24),(2756,6,30,18,24),(2757,6,30,19,24),(2758,6,30,20,24),(2759,6,30,21,24),(2760,7,30,23,24),(2761,7,30,24,24),(2762,4,30,6,25),(2763,4,30,7,25),(2764,0,30,8,25),(2765,4,30,11,25),(2766,14,30,12,25),(2767,6,30,16,25),(2768,6,30,17,25),(2769,6,30,18,25),(2770,6,30,20,25),(2771,6,30,21,25),(2772,4,30,6,26),(2773,4,30,7,26),(2774,4,30,10,26),(2775,4,30,11,26),(2776,1,30,16,26),(2777,6,30,18,26),(2778,6,30,19,26),(2779,6,30,20,26),(2780,4,30,6,27),(2781,4,30,7,27),(2782,4,30,8,27),(2783,4,30,9,27),(2784,4,30,10,27),(2785,4,30,11,27),(2786,6,30,19,27),(2787,6,30,20,27),(2788,6,30,21,27),(2789,5,30,22,27),(2790,4,30,0,28),(2791,4,30,1,28),(2792,4,30,6,28),(2793,5,30,7,28),(2794,4,30,8,28),(2795,4,30,9,28),(2796,4,30,11,28),(2797,5,30,21,28),(2798,5,30,22,28),(2799,5,30,23,28),(2800,5,30,24,28),(2801,4,30,0,29),(2802,4,30,1,29),(2803,5,30,6,29),(2804,5,30,7,29),(2805,5,30,8,29),(2806,5,30,9,29),(2807,5,30,10,29),(2808,5,30,11,29),(2809,5,30,12,29),(2810,5,30,13,29),(2811,5,30,14,29),(2812,5,30,18,29),(2813,5,30,19,29),(2814,5,30,20,29),(2815,5,30,21,29),(2816,5,30,22,29),(2817,5,30,23,29),(2818,5,30,24,29),(2819,4,30,0,30),(2820,12,30,1,30),(2821,5,30,7,30),(2822,5,30,8,30),(2823,5,30,10,30),(2824,5,30,11,30),(2825,5,30,12,30),(2826,5,30,21,30),(2827,5,30,22,30),(2828,5,30,23,30),(2829,4,30,0,31),(2830,5,30,11,31),(2831,5,30,12,31),(2832,5,30,20,31),(2833,5,30,21,31),(2834,0,30,22,31),(2835,4,30,0,32),(2836,4,30,0,33),(2837,4,30,0,34),(2838,0,30,17,34),(2839,4,30,0,35),(2840,4,30,0,36),(2841,4,30,1,36),(2842,4,30,2,36),(2843,4,30,3,36),(2844,4,30,4,36),(2845,4,30,5,36),(2846,6,36,16,0),(2847,6,36,17,0),(2848,6,36,18,0),(2849,6,36,19,0),(2850,6,36,20,0),(2851,7,36,21,0),(2852,7,36,22,0),(2853,7,36,23,0),(2854,7,36,24,0),(2855,7,36,25,0),(2856,7,36,26,0),(2857,7,36,27,0),(2858,7,36,28,0),(2859,7,36,29,0),(2860,7,36,30,0),(2861,7,36,31,0),(2862,6,36,16,1),(2863,6,36,17,1),(2864,6,36,18,1),(2865,6,36,19,1),(2866,6,36,20,1),(2867,6,36,21,1),(2868,7,36,22,1),(2869,7,36,23,1),(2870,7,36,24,1),(2871,7,36,25,1),(2872,7,36,26,1),(2873,7,36,27,1),(2874,7,36,29,1),(2875,7,36,30,1),(2876,7,36,31,1),(2877,6,36,16,2),(2878,6,36,17,2),(2879,6,36,18,2),(2880,6,36,21,2),(2881,7,36,22,2),(2882,7,36,23,2),(2883,7,36,24,2),(2884,7,36,25,2),(2885,7,36,26,2),(2886,7,36,27,2),(2887,7,36,29,2),(2888,7,36,30,2),(2889,7,36,31,2),(2890,3,36,14,3),(2891,3,36,15,3),(2892,6,36,16,3),(2893,6,36,17,3),(2894,7,36,21,3),(2895,7,36,22,3),(2896,7,36,23,3),(2897,10,36,24,3),(2898,7,36,30,3),(2899,12,36,1,4),(2900,3,36,14,4),(2901,3,36,15,4),(2902,7,36,19,4),(2903,7,36,20,4),(2904,7,36,21,4),(2905,7,36,22,4),(2906,7,36,23,4),(2907,7,36,30,4),(2908,3,36,11,5),(2909,3,36,12,5),(2910,3,36,13,5),(2911,3,36,14,5),(2912,3,36,15,5),(2913,3,36,16,5),(2914,8,36,21,5),(2915,1,36,29,5),(2916,3,36,12,6),(2917,3,36,13,6),(2918,3,36,14,6),(2919,3,36,15,6),(2920,3,36,16,6),(2921,3,36,17,6),(2922,3,36,18,6),(2923,3,36,19,6),(2924,11,36,8,7),(2925,3,36,12,7),(2926,3,36,13,7),(2927,3,36,14,7),(2928,3,36,15,7),(2929,3,36,12,8),(2930,3,36,13,8),(2931,0,36,16,8),(2932,7,36,12,9),(2933,7,36,13,9),(2934,3,36,5,10),(2935,3,36,6,10),(2936,3,36,7,10),(2937,7,36,13,10),(2938,7,36,14,10),(2939,3,36,3,11),(2940,3,36,6,11),(2941,3,36,7,11),(2942,7,36,12,11),(2943,7,36,14,11),(2944,7,36,15,11),(2945,7,36,16,11),(2946,7,36,17,11),(2947,3,36,2,12),(2948,3,36,3,12),(2949,3,36,4,12),(2950,3,36,5,12),(2951,3,36,6,12),(2952,3,36,7,12),(2953,7,36,12,12),(2954,7,36,13,12),(2955,7,36,14,12),(2956,7,36,15,12),(2957,7,36,16,12),(2958,7,36,17,12),(2959,7,36,18,12),(2960,3,36,2,13),(2961,3,36,3,13),(2962,3,36,5,13),(2963,3,36,6,13),(2964,7,36,11,13),(2965,7,36,12,13),(2966,7,36,13,13),(2967,7,36,14,13),(2968,7,36,15,13),(2969,7,36,16,13),(2970,7,36,17,13),(2971,7,36,18,13),(2972,7,36,19,13),(2973,3,36,5,14),(2974,3,36,6,14),(2975,3,36,7,14),(2976,3,36,8,14),(2977,3,36,9,14),(2978,3,36,10,14),(2979,7,36,11,14),(2980,7,36,12,14),(2981,7,36,13,14),(2982,7,36,14,14),(2983,7,36,15,14),(2984,7,36,16,14),(2985,6,36,22,14),(2986,0,36,25,14),(2987,3,36,4,15),(2988,3,36,6,15),(2989,5,36,10,15),(2990,7,36,11,15),(2991,7,36,12,15),(2992,5,36,13,15),(2993,7,36,14,15),(2994,7,36,15,15),(2995,6,36,18,15),(2996,6,36,19,15),(2997,6,36,20,15),(2998,6,36,21,15),(2999,6,36,22,15),(3000,3,36,1,16),(3001,3,36,2,16),(3002,3,36,3,16),(3003,3,36,4,16),(3004,3,36,5,16),(3005,3,36,6,16),(3006,5,36,10,16),(3007,5,36,11,16),(3008,5,36,13,16),(3009,7,36,14,16),(3010,7,36,15,16),(3011,7,36,16,16),(3012,6,36,18,16),(3013,6,36,19,16),(3014,6,36,20,16),(3015,6,36,21,16),(3016,6,36,22,16),(3017,3,36,0,17),(3018,3,36,1,17),(3019,3,36,2,17),(3020,3,36,3,17),(3021,3,36,4,17),(3022,5,36,9,17),(3023,5,36,10,17),(3024,5,36,11,17),(3025,5,36,12,17),(3026,5,36,13,17),(3027,5,36,14,17),(3028,4,36,16,17),(3029,6,36,18,17),(3030,6,36,20,17),(3031,6,36,22,17),(3032,6,36,23,17),(3033,0,36,24,17),(3034,3,36,0,18),(3035,3,36,1,18),(3036,3,36,2,18),(3037,3,36,3,18),(3038,3,36,4,18),(3039,5,36,11,18),(3040,5,36,14,18),(3041,5,36,15,18),(3042,4,36,16,18),(3043,4,36,18,18),(3044,6,36,20,18),(3045,6,36,23,18),(3046,9,36,27,18),(3047,3,36,0,19),(3048,3,36,2,19),(3049,5,36,9,19),(3050,5,36,10,19),(3051,5,36,11,19),(3052,4,36,12,19),(3053,5,36,14,19),(3054,4,36,15,19),(3055,4,36,16,19),(3056,4,36,17,19),(3057,4,36,18,19),(3058,4,36,19,19),(3059,4,36,20,19),(3060,3,36,0,20),(3061,3,36,1,20),(3062,3,36,2,20),(3063,5,36,9,20),(3064,5,36,10,20),(3065,4,36,11,20),(3066,4,36,12,20),(3067,4,36,13,20),(3068,4,36,14,20),(3069,4,36,15,20),(3070,4,36,16,20),(3071,4,36,17,20),(3072,4,36,18,20),(3073,4,36,19,20),(3074,4,36,20,20),(3075,3,36,0,21),(3076,5,36,9,21),(3077,5,36,10,21),(3078,4,36,12,21),(3079,4,36,13,21),(3080,4,36,14,21),(3081,4,36,15,21),(3082,4,36,16,21),(3083,4,36,17,21),(3084,4,36,19,21),(3085,4,36,20,21),(3086,4,36,21,21),(3087,6,36,0,22),(3088,6,36,3,22),(3089,6,36,4,22),(3090,6,36,5,22),(3091,4,36,13,22),(3092,4,36,14,22),(3093,4,36,15,22),(3094,4,36,16,22),(3095,4,36,17,22),(3096,6,36,0,23),(3097,6,36,1,23),(3098,6,36,2,23),(3099,6,36,3,23),(3100,6,36,4,23),(3101,6,36,5,23),(3102,6,36,6,23),(3103,6,36,12,23),(3104,6,36,13,23),(3105,4,36,15,23),(3106,4,36,16,23),(3107,13,36,25,23),(3108,6,36,0,24),(3109,6,36,1,24),(3110,6,36,2,24),(3111,4,36,3,24),(3112,0,36,7,24),(3113,6,36,11,24),(3114,6,36,12,24),(3115,6,36,13,24),(3116,6,36,14,24),(3117,6,36,15,24),(3118,6,36,0,25),(3119,4,36,1,25),(3120,6,36,2,25),(3121,4,36,3,25),(3122,4,36,4,25),(3123,6,36,9,25),(3124,6,36,10,25),(3125,6,36,11,25),(3126,6,36,13,25),(3127,6,36,14,25),(3128,2,36,17,25),(3129,9,36,24,25),(3130,4,36,0,26),(3131,4,36,1,26),(3132,6,36,2,26),(3133,4,36,3,26),(3134,4,36,5,26),(3135,4,36,6,26),(3136,6,36,9,26),(3137,6,36,10,26),(3138,6,36,11,26),(3139,6,36,12,26),(3140,6,36,13,26),(3141,4,36,29,26),(3142,4,36,0,27),(3143,4,36,1,27),(3144,4,36,2,27),(3145,4,36,3,27),(3146,4,36,4,27),(3147,4,36,5,27),(3148,4,36,29,27),(3149,4,36,30,27),(3150,4,36,0,28),(3151,4,36,1,28),(3152,4,36,2,28),(3153,4,36,3,28),(3154,4,36,4,28),(3155,4,36,5,28),(3156,4,36,28,28),(3157,4,36,29,28),(3158,4,36,30,28),(3159,4,36,31,28),(3160,4,36,0,29),(3161,4,36,1,29),(3162,4,36,2,29),(3163,4,36,4,29),(3164,13,36,10,29),(3165,4,36,27,29),(3166,4,36,28,29),(3167,4,36,29,29),(3168,4,36,30,29),(3169,4,36,0,30),(3170,4,36,1,30),(3171,4,36,2,30),(3172,4,36,3,30),(3173,8,36,16,30),(3174,4,36,26,30),(3175,4,36,27,30),(3176,4,36,28,30),(3177,4,36,29,30),(3178,4,36,30,30),(3179,4,36,31,30),(3180,4,36,0,31),(3181,4,36,1,31),(3182,14,36,5,31),(3183,4,36,27,31),(3184,1,36,29,31),(3185,4,36,31,31),(3186,4,36,0,32),(3187,4,36,1,32),(3188,4,36,2,32),(3189,4,36,3,32),(3190,4,36,26,32),(3191,4,36,27,32),(3192,4,36,31,32),(3193,4,36,2,33),(3194,4,36,24,33),(3195,4,36,25,33),(3196,4,36,26,33),(3197,4,36,27,33),(3198,4,36,28,33),(3199,4,36,29,33),(3200,4,36,30,33),(3201,4,36,31,33),(3202,0,36,16,34),(3203,4,36,25,34),(3204,4,36,26,34),(3205,4,36,28,34),(3206,4,36,31,34),(3207,3,36,18,35),(3208,3,36,19,35),(3209,4,36,31,35),(3210,3,36,12,36),(3211,3,36,13,36),(3212,3,36,14,36),(3213,3,36,15,36),(3214,3,36,16,36),(3215,3,36,18,36),(3216,5,36,30,36),(3217,3,36,12,37),(3218,3,36,13,37),(3219,3,36,14,37),(3220,3,36,15,37),(3221,3,36,16,37),(3222,3,36,17,37),(3223,3,36,18,37),(3224,5,36,28,37),(3225,5,36,30,37),(3226,5,36,31,37),(3227,3,36,14,38),(3228,3,36,15,38),(3229,3,36,16,38),(3230,3,36,17,38),(3231,3,36,18,38),(3232,5,36,27,38),(3233,5,36,28,38),(3234,5,36,29,38),(3235,5,36,30,38),(3236,5,36,31,38),(3237,5,36,8,39),(3238,10,36,9,39),(3239,3,36,14,39),(3240,3,36,16,39),(3241,3,36,17,39),(3242,5,36,28,39),(3243,5,36,29,39),(3244,5,36,30,39),(3245,5,36,31,39),(3246,5,36,6,40),(3247,5,36,7,40),(3248,5,36,8,40),(3249,3,36,16,40),(3250,5,36,28,40),(3251,5,36,29,40),(3252,5,36,30,40),(3253,5,36,31,40),(3254,5,36,6,41),(3255,5,36,7,41),(3256,5,36,8,41),(3257,5,36,29,41),(3258,5,36,30,41),(3259,5,36,31,41),(3260,5,36,5,42),(3261,5,36,6,42),(3262,5,36,7,42),(3263,5,36,8,42),(3264,5,36,30,42),(3265,5,36,4,43),(3266,5,36,5,43),(3267,5,36,6,43),(3268,5,36,7,43),(3269,5,36,8,43),(3270,5,36,9,43),(3271,5,36,10,43),(3272,5,36,11,43),(3273,5,36,12,43),(3274,5,36,30,43),(3275,7,38,0,0),(3276,7,38,1,0),(3277,7,38,2,0),(3278,7,38,3,0),(3279,7,38,4,0),(3280,7,38,5,0),(3281,5,38,17,0),(3282,5,38,18,0),(3283,5,38,19,0),(3284,5,38,20,0),(3285,5,38,21,0),(3286,5,38,22,0),(3287,13,38,23,0),(3288,7,38,0,1),(3289,7,38,1,1),(3290,7,38,4,1),(3291,7,38,5,1),(3292,7,38,6,1),(3293,12,38,15,1),(3294,5,38,21,1),(3295,5,38,22,1),(3296,5,38,29,1),(3297,7,38,0,2),(3298,7,38,1,2),(3299,7,38,2,2),(3300,7,38,5,2),(3301,3,38,21,2),(3302,5,38,22,2),(3303,5,38,23,2),(3304,5,38,24,2),(3305,5,38,25,2),(3306,5,38,26,2),(3307,5,38,27,2),(3308,5,38,28,2),(3309,5,38,29,2),(3310,7,38,0,3),(3311,7,38,1,3),(3312,7,38,2,3),(3313,7,38,5,3),(3314,7,38,6,3),(3315,3,38,21,3),(3316,5,38,22,3),(3317,5,38,23,3),(3318,3,38,24,3),(3319,5,38,25,3),(3320,5,38,26,3),(3321,5,38,27,3),(3322,5,38,28,3),(3323,5,38,29,3),(3324,7,38,0,4),(3325,7,38,1,4),(3326,7,38,2,4),(3327,7,38,3,4),(3328,7,38,4,4),(3329,7,38,5,4),(3330,0,38,12,4),(3331,3,38,21,4),(3332,3,38,22,4),(3333,3,38,23,4),(3334,3,38,24,4),(3335,5,38,25,4),(3336,5,38,26,4),(3337,5,38,28,4),(3338,5,38,29,4),(3339,7,38,0,5),(3340,7,38,1,5),(3341,7,38,3,5),(3342,4,38,6,5),(3343,3,38,21,5),(3344,3,38,22,5),(3345,6,38,23,5),(3346,3,38,24,5),(3347,5,38,25,5),(3348,0,38,27,5),(3349,7,38,0,6),(3350,7,38,1,6),(3351,4,38,2,6),(3352,4,38,3,6),(3353,4,38,6,6),(3354,3,38,21,6),(3355,3,38,22,6),(3356,6,38,23,6),(3357,6,38,24,6),(3358,5,38,25,6),(3359,7,38,0,7),(3360,7,38,1,7),(3361,7,38,2,7),(3362,4,38,3,7),(3363,4,38,4,7),(3364,4,38,5,7),(3365,4,38,6,7),(3366,4,38,8,7),(3367,4,38,10,7),(3368,6,38,14,7),(3369,3,38,21,7),(3370,3,38,22,7),(3371,6,38,23,7),(3372,6,38,24,7),(3373,6,38,25,7),(3374,6,38,26,7),(3375,6,38,28,7),(3376,7,38,0,8),(3377,7,38,1,8),(3378,4,38,3,8),(3379,4,38,5,8),(3380,4,38,6,8),(3381,4,38,7,8),(3382,4,38,8,8),(3383,4,38,9,8),(3384,4,38,10,8),(3385,6,38,13,8),(3386,6,38,14,8),(3387,3,38,19,8),(3388,3,38,20,8),(3389,3,38,21,8),(3390,6,38,22,8),(3391,6,38,23,8),(3392,6,38,24,8),(3393,6,38,25,8),(3394,6,38,26,8),(3395,6,38,27,8),(3396,6,38,28,8),(3397,6,38,29,8),(3398,4,38,2,9),(3399,4,38,3,9),(3400,4,38,5,9),(3401,4,38,6,9),(3402,4,38,7,9),(3403,6,38,14,9),(3404,6,38,15,9),(3405,6,38,22,9),(3406,6,38,23,9),(3407,6,38,24,9),(3408,6,38,25,9),(3409,6,38,26,9),(3410,6,38,27,9),(3411,6,38,28,9),(3412,4,38,7,10),(3413,6,38,12,10),(3414,6,38,13,10),(3415,6,38,14,10),(3416,6,38,15,10),(3417,5,38,22,10),(3418,6,38,23,10),(3419,0,38,24,10),(3420,6,38,26,10),(3421,6,38,27,10),(3422,6,38,28,10),(3423,4,38,6,11),(3424,4,38,7,11),(3425,6,38,14,11),(3426,5,38,21,11),(3427,5,38,22,11),(3428,6,38,23,11),(3429,6,38,27,11),(3430,6,38,28,11),(3431,4,38,6,12),(3432,4,38,7,12),(3433,6,38,13,12),(3434,6,38,14,12),(3435,5,38,21,12),(3436,5,38,22,12),(3437,5,38,23,12),(3438,5,38,24,12),(3439,3,38,25,12),(3440,6,38,28,12),(3441,6,38,29,12),(3442,4,38,7,13),(3443,4,38,10,13),(3444,4,38,11,13),(3445,4,38,12,13),(3446,6,38,14,13),(3447,6,38,15,13),(3448,5,38,20,13),(3449,5,38,21,13),(3450,5,38,22,13),(3451,5,38,23,13),(3452,5,38,24,13),(3453,3,38,25,13),(3454,6,38,28,13),(3455,4,38,10,14),(3456,4,38,11,14),(3457,6,38,14,14),(3458,6,38,15,14),(3459,5,38,19,14),(3460,5,38,20,14),(3461,5,38,22,14),(3462,5,38,23,14),(3463,5,38,24,14),(3464,3,38,25,14),(3465,3,38,26,14),(3466,6,38,28,14),(3467,0,38,6,15),(3468,4,38,10,15),(3469,4,38,11,15),(3470,4,38,12,15),(3471,5,38,20,15),(3472,5,38,21,15),(3473,5,38,22,15),(3474,5,38,23,15),(3475,5,38,24,15),(3476,3,38,25,15),(3477,3,38,28,15),(3478,3,38,29,15),(3479,4,38,9,16),(3480,4,38,10,16),(3481,4,38,12,16),(3482,4,38,13,16),(3483,0,38,18,16),(3484,5,38,21,16),(3485,5,38,22,16),(3486,5,38,23,16),(3487,5,38,24,16),(3488,3,38,25,16),(3489,3,38,26,16),(3490,3,38,27,16),(3491,3,38,28,16),(3492,4,38,9,17),(3493,4,38,10,17),(3494,10,38,11,17),(3495,5,38,20,17),(3496,5,38,21,17),(3497,5,38,22,17),(3498,3,38,24,17),(3499,3,38,25,17),(3500,3,38,26,17),(3501,3,38,27,17),(3502,3,38,28,17),(3503,4,38,9,18),(3504,4,38,10,18),(3505,5,38,22,18),(3506,1,38,23,18),(3507,3,38,27,18),(3508,5,38,1,19),(3509,4,38,8,19),(3510,4,38,9,19),(3511,4,38,10,19),(3512,5,38,0,20),(3513,5,38,1,20),(3514,0,38,2,20),(3515,4,38,8,20),(3516,4,38,9,20),(3517,4,38,10,20),(3518,5,38,0,21),(3519,5,38,1,21),(3520,4,38,8,21),(3521,4,38,9,21),(3522,4,38,10,21),(3523,4,38,11,21),(3524,5,38,0,22),(3525,5,38,1,22),(3526,5,38,4,22),(3527,3,38,8,22),(3528,4,38,9,22),(3529,9,38,20,22),(3530,11,38,25,22),(3531,5,38,0,23),(3532,5,38,1,23),(3533,5,38,2,23),(3534,5,38,3,23),(3535,5,38,4,23),(3536,3,38,6,23),(3537,3,38,7,23),(3538,3,38,8,23),(3539,3,38,9,23),(3540,8,38,10,23),(3541,5,38,0,24),(3542,5,38,1,24),(3543,5,38,2,24),(3544,5,38,3,24),(3545,3,38,4,24),(3546,3,38,5,24),(3547,3,38,6,24),(3548,3,38,7,24),(3549,3,38,8,24),(3550,3,38,9,24),(3551,5,38,0,25),(3552,5,38,1,25),(3553,3,38,2,25),(3554,3,38,3,25),(3555,3,38,4,25),(3556,3,38,5,25),(3557,3,38,6,25),(3558,3,38,7,25),(3559,3,38,8,25),(3560,3,38,9,25),(3561,5,38,0,26),(3562,5,38,1,26),(3563,5,38,2,26),(3564,5,38,3,26),(3565,3,38,5,26),(3566,3,38,6,26),(3567,3,38,7,26),(3568,3,38,9,26),(3569,3,38,10,26),(3570,2,38,17,26),(3571,5,38,0,27),(3572,5,38,1,27),(3573,5,38,2,27),(3574,5,38,3,27),(3575,3,38,4,27),(3576,3,38,5,27),(3577,3,38,6,27),(3578,3,38,7,27),(3579,3,38,8,27),(3580,3,38,9,27),(3581,5,38,0,28),(3582,5,38,1,28),(3583,3,38,6,28),(3584,3,38,7,28),(3585,3,38,14,28),(3586,3,38,18,28),(3587,3,38,19,28),(3588,14,38,22,28),(3589,5,38,0,29),(3590,5,38,1,29),(3591,5,38,3,29),(3592,5,38,4,29),(3593,5,38,5,29),(3594,5,38,6,29),(3595,14,38,7,29),(3596,3,38,13,29),(3597,3,38,14,29),(3598,3,38,15,29),(3599,3,38,16,29),(3600,3,38,17,29),(3601,3,38,18,29),(3602,3,38,19,29),(3603,3,38,20,29),(3604,10,38,25,29),(3605,5,38,0,30),(3606,5,38,1,30),(3607,1,38,2,30),(3608,5,38,4,30),(3609,5,38,5,30),(3610,3,38,16,30),(3611,3,38,17,30),(3612,3,38,18,30),(3613,3,38,20,30),(3614,5,38,0,31),(3615,5,38,1,31),(3616,5,38,4,31),(3617,3,38,17,31),(3618,3,38,18,31),(3619,5,38,0,32),(3620,5,38,1,32),(3621,5,38,2,32),(3622,5,38,3,32),(3623,5,38,4,32),(3624,5,38,5,32),(3625,5,38,6,32),(3626,5,38,0,33),(3627,5,38,1,33),(3628,5,38,2,33),(3629,5,38,3,33),(3630,11,38,4,33),(3631,5,38,0,34),(3632,5,38,1,34),(3633,5,38,2,34),(3634,4,38,8,34),(3635,4,38,10,34),(3636,4,38,11,34),(3637,4,38,13,34),(3638,2,38,16,34),(3639,9,38,22,34),(3640,5,38,2,35),(3641,5,38,3,35),(3642,4,38,8,35),(3643,4,38,11,35),(3644,4,38,12,35),(3645,4,38,13,35),(3646,4,38,14,35),(3647,5,38,3,36),(3648,4,38,8,36),(3649,4,38,9,36),(3650,4,38,10,36),(3651,4,38,11,36),(3652,4,38,12,36),(3653,4,38,13,36),(3654,4,38,14,36),(3655,4,38,8,37),(3656,4,38,10,37),(3657,4,38,11,37),(3658,4,38,12,37),(3659,4,38,13,37),(3660,0,38,27,37),(3661,4,38,8,38),(3662,4,38,9,38),(3663,4,38,10,38),(3664,4,38,11,38),(3665,4,38,12,38),(3666,4,38,10,39),(3667,4,38,11,39),(3668,5,32,0,0),(3669,5,32,1,0),(3670,5,32,2,0),(3671,5,32,3,0),(3672,5,32,16,0),(3673,5,32,17,0),(3674,5,32,18,0),(3675,5,32,19,0),(3676,5,32,20,0),(3677,5,32,21,0),(3678,5,32,22,0),(3679,5,32,23,0),(3680,5,32,24,0),(3681,5,32,25,0),(3682,5,32,26,0),(3683,5,32,0,1),(3684,5,32,1,1),(3685,5,32,2,1),(3686,5,32,3,1),(3687,5,32,4,1),(3688,12,32,7,1),(3689,5,32,17,1),(3690,5,32,18,1),(3691,5,32,20,1),(3692,14,32,22,1),(3693,5,32,26,1),(3694,5,32,28,1),(3695,5,32,0,2),(3696,5,32,1,2),(3697,5,32,2,2),(3698,5,32,4,2),(3699,5,32,5,2),(3700,5,32,25,2),(3701,5,32,26,2),(3702,5,32,28,2),(3703,5,32,29,2),(3704,5,32,0,3),(3705,5,32,1,3),(3706,5,32,4,3),(3707,5,32,5,3),(3708,5,32,28,3),(3709,6,32,29,3),(3710,5,32,28,4),(3711,6,32,29,4),(3712,4,32,3,5),(3713,4,32,5,5),(3714,0,32,18,5),(3715,6,32,27,5),(3716,6,32,28,5),(3717,6,32,29,5),(3718,4,32,2,6),(3719,4,32,3,6),(3720,4,32,4,6),(3721,4,32,5,6),(3722,6,32,26,6),(3723,6,32,27,6),(3724,6,32,28,6),(3725,6,32,29,6),(3726,4,32,1,7),(3727,4,32,2,7),(3728,4,32,3,7),(3729,4,32,4,7),(3730,4,32,5,7),(3731,6,32,26,7),(3732,5,32,27,7),(3733,5,32,28,7),(3734,5,32,29,7),(3735,4,32,1,8),(3736,4,32,2,8),(3737,4,32,3,8),(3738,4,32,4,8),(3739,0,32,10,8),(3740,5,32,27,8),(3741,5,32,28,8),(3742,5,32,29,8),(3743,4,32,1,9),(3744,4,32,2,9),(3745,4,32,3,9),(3746,5,32,29,9),(3747,4,32,1,10),(3748,6,32,5,10),(3749,6,32,6,10),(3750,5,32,28,10),(3751,5,32,29,10),(3752,6,32,4,11),(3753,6,32,5,11),(3754,6,32,6,11),(3755,6,32,7,11),(3756,6,32,8,11),(3757,5,32,27,11),(3758,5,32,28,11),(3759,5,32,29,11),(3760,13,32,1,12),(3761,6,32,8,12),(3762,6,32,9,12),(3763,6,32,10,12),(3764,5,32,27,12),(3765,5,32,28,12),(3766,5,32,29,12),(3767,6,32,8,13),(3768,6,32,9,13),(3769,6,32,10,13),(3770,5,32,28,13),(3771,5,32,29,13),(3772,5,32,2,14),(3773,6,32,9,14),(3774,5,32,28,14),(3775,5,32,0,15),(3776,5,32,2,15),(3777,5,32,3,15),(3778,5,32,0,16),(3779,5,32,1,16),(3780,5,32,2,16),(3781,5,32,3,16),(3782,5,32,4,16),(3783,2,32,26,16),(3784,5,32,0,17),(3785,5,32,1,17),(3786,5,32,2,17),(3787,5,32,3,17),(3788,5,32,4,17),(3789,5,32,0,18),(3790,5,32,1,18),(3791,5,32,3,18),(3792,6,32,6,18),(3793,4,32,24,18),(3794,4,32,29,18),(3795,5,32,0,19),(3796,5,32,2,19),(3797,5,32,3,19),(3798,6,32,7,19),(3799,6,32,8,19),(3800,4,32,24,19),(3801,4,32,25,19),(3802,4,32,26,19),(3803,4,32,27,19),(3804,4,32,28,19),(3805,4,32,29,19),(3806,5,32,0,20),(3807,11,32,1,20),(3808,6,32,5,20),(3809,6,32,6,20),(3810,6,32,7,20),(3811,6,32,8,20),(3812,6,32,9,20),(3813,4,32,23,20),(3814,4,32,24,20),(3815,4,32,25,20),(3816,4,32,26,20),(3817,4,32,27,20),(3818,4,32,28,20),(3819,4,32,29,20),(3820,5,32,0,21),(3821,6,32,5,21),(3822,6,32,6,21),(3823,4,32,24,21),(3824,4,32,25,21),(3825,4,32,26,21),(3826,4,32,27,21),(3827,4,32,28,21),(3828,4,32,29,21),(3829,5,32,0,22),(3830,6,32,6,22),(3831,8,32,10,22),(3832,4,32,24,22),(3833,4,32,25,22),(3834,4,32,26,22),(3835,4,32,27,22),(3836,4,32,28,22),(3837,4,32,29,22),(3838,5,32,0,23),(3839,4,32,26,23),(3840,4,32,27,23),(3841,4,32,28,23),(3842,5,32,0,24),(3843,3,32,18,24),(3844,3,32,19,24),(3845,3,32,20,24),(3846,0,32,24,24),(3847,4,32,27,24),(3848,0,32,28,24),(3849,5,32,0,25),(3850,3,32,9,25),(3851,3,32,10,25),(3852,3,32,13,25),(3853,3,32,14,25),(3854,3,32,15,25),(3855,3,32,17,25),(3856,3,32,18,25),(3857,3,32,19,25),(3858,3,32,20,25),(3859,3,32,21,25),(3860,5,32,0,26),(3861,5,32,1,26),(3862,5,32,2,26),(3863,3,32,9,26),(3864,3,32,10,26),(3865,3,32,11,26),(3866,3,32,14,26),(3867,3,32,15,26),(3868,3,32,16,26),(3869,3,32,17,26),(3870,3,32,18,26),(3871,3,32,19,26),(3872,3,32,20,26),(3873,3,32,21,26),(3874,3,32,23,26),(3875,5,32,2,27),(3876,0,32,3,27),(3877,3,32,10,27),(3878,3,32,11,27),(3879,3,32,12,27),(3880,3,32,13,27),(3881,3,32,14,27),(3882,3,32,15,27),(3883,3,32,16,27),(3884,3,32,17,27),(3885,3,32,18,27),(3886,3,32,19,27),(3887,3,32,20,27),(3888,3,32,21,27),(3889,3,32,22,27),(3890,3,32,23,27),(3891,3,32,24,27),(3892,0,32,0,28),(3893,3,32,11,28),(3894,3,32,12,28),(3895,3,32,13,28),(3896,3,32,14,28),(3897,3,32,15,28),(3898,3,32,16,28),(3899,3,32,17,28),(3900,3,32,18,28),(3901,3,32,19,28),(3902,3,32,20,28),(3903,3,32,21,28),(3904,3,32,22,28),(3905,3,32,23,28),(3906,3,32,24,28),(3907,3,32,10,29),(3908,3,32,11,29),(3909,3,32,12,29),(3910,3,32,13,29),(3911,3,32,14,29),(3912,3,32,15,29),(3913,3,32,16,29),(3914,3,32,17,29),(3915,3,32,18,29),(3916,3,32,19,29),(3917,3,32,20,29),(3918,3,32,21,29),(3919,3,32,22,29),(3920,3,32,23,29);
/*!40000 ALTER TABLE `tiles` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `units`
--

DROP TABLE IF EXISTS `units`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `units` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `hp` int(10) unsigned NOT NULL DEFAULT '0',
  `level` tinyint(2) unsigned NOT NULL,
  `location_id` int(10) unsigned NOT NULL,
  `location_type` tinyint(2) unsigned NOT NULL DEFAULT '0',
  `player_id` int(11) DEFAULT NULL,
  `last_update` datetime DEFAULT NULL,
  `upgrade_ends_at` datetime DEFAULT NULL,
  `pause_remainder` int(10) unsigned DEFAULT NULL,
  `xp` mediumint(8) unsigned NOT NULL DEFAULT '0',
  `hp_remainder` int(10) unsigned NOT NULL DEFAULT '0',
  `type` varchar(50) NOT NULL,
  `flank` tinyint(2) unsigned NOT NULL DEFAULT '0',
  `location_x` mediumint(9) DEFAULT NULL,
  `location_y` mediumint(9) DEFAULT NULL,
  `route_id` int(11) DEFAULT NULL,
  `galaxy_id` int(11) NOT NULL,
  `stance` tinyint(2) unsigned NOT NULL DEFAULT '0',
  `construction_mod` tinyint(2) unsigned NOT NULL DEFAULT '0',
  `stored` int(10) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `location` (`player_id`,`location_id`,`location_type`),
  KEY `location_and_player` (`location_type`,`location_id`,`location_x`,`location_y`,`player_id`),
  KEY `index_units_on_route_id` (`route_id`),
  KEY `type` (`player_id`,`type`),
  KEY `group_by_for_fowssentry_status_updates` (`player_id`,`location_id`,`location_type`),
  KEY `foreign_key` (`galaxy_id`),
  CONSTRAINT `units_ibfk_1` FOREIGN KEY (`player_id`) REFERENCES `players` (`id`) ON DELETE SET NULL,
  CONSTRAINT `units_ibfk_2` FOREIGN KEY (`galaxy_id`) REFERENCES `galaxies` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=137 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `units`
--

LOCK TABLES `units` WRITE;
/*!40000 ALTER TABLE `units` DISABLE KEYS */;
INSERT INTO `units` VALUES (1,100,1,32,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,18,28,NULL,1,0,0,0),(2,100,1,32,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,18,28,NULL,1,0,0,0),(3,100,1,32,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,18,28,NULL,1,0,0,0),(4,100,1,32,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,18,28,NULL,1,0,0,0),(5,100,1,32,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,18,28,NULL,1,0,0,0),(6,200,1,32,4,NULL,NULL,NULL,NULL,0,0,'Glancer',0,18,28,NULL,1,0,0,0),(7,200,1,32,4,NULL,NULL,NULL,NULL,0,0,'Glancer',0,18,28,NULL,1,0,0,0),(8,200,1,32,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,18,28,NULL,1,0,0,0),(9,200,1,32,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,18,28,NULL,1,0,0,0),(10,100,1,32,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,18,28,NULL,1,0,0,0),(11,100,1,32,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,18,28,NULL,1,0,0,0),(12,100,1,32,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,18,28,NULL,1,0,0,0),(13,100,1,32,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,26,16,NULL,1,0,0,0),(14,100,1,32,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,26,16,NULL,1,0,0,0),(15,100,1,32,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,26,16,NULL,1,0,0,0),(16,100,1,32,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,26,16,NULL,1,0,0,0),(17,100,1,32,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,26,16,NULL,1,0,0,0),(18,200,1,32,4,NULL,NULL,NULL,NULL,0,0,'Glancer',0,26,16,NULL,1,0,0,0),(19,200,1,32,4,NULL,NULL,NULL,NULL,0,0,'Glancer',0,26,16,NULL,1,0,0,0),(20,200,1,32,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,26,16,NULL,1,0,0,0),(21,200,1,32,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,26,16,NULL,1,0,0,0),(22,100,1,32,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,26,16,NULL,1,0,0,0),(23,100,1,32,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,26,16,NULL,1,0,0,0),(24,100,1,32,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,26,16,NULL,1,0,0,0),(25,100,1,32,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,3,27,NULL,1,0,0,0),(26,100,1,32,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,3,27,NULL,1,0,0,0),(27,100,1,32,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,3,27,NULL,1,0,0,0),(28,100,1,32,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,3,27,NULL,1,0,0,0),(29,100,1,32,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,3,27,NULL,1,0,0,0),(30,200,1,32,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,3,27,NULL,1,0,0,0),(31,200,1,32,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,3,27,NULL,1,0,0,0),(32,100,1,32,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,28,24,NULL,1,0,0,0),(33,100,1,32,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,28,24,NULL,1,0,0,0),(34,100,1,32,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,28,24,NULL,1,0,0,0),(35,100,1,32,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,28,24,NULL,1,0,0,0),(36,100,1,32,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,28,24,NULL,1,0,0,0),(37,200,1,32,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,28,24,NULL,1,0,0,0),(38,200,1,32,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,28,24,NULL,1,0,0,0),(39,100,1,32,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,18,25,NULL,1,0,0,0),(40,100,1,32,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,18,25,NULL,1,0,0,0),(41,100,1,32,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,18,25,NULL,1,0,0,0),(42,100,1,32,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,18,25,NULL,1,0,0,0),(43,100,1,32,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,18,25,NULL,1,0,0,0),(44,200,1,32,4,NULL,NULL,NULL,NULL,0,0,'Glancer',0,18,25,NULL,1,0,0,0),(45,200,1,32,4,NULL,NULL,NULL,NULL,0,0,'Glancer',0,18,25,NULL,1,0,0,0),(46,200,1,32,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,18,25,NULL,1,0,0,0),(47,200,1,32,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,18,25,NULL,1,0,0,0),(48,100,1,32,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,18,25,NULL,1,0,0,0),(49,100,1,32,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,18,25,NULL,1,0,0,0),(50,100,1,32,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,18,25,NULL,1,0,0,0),(51,100,1,32,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,15,26,NULL,1,0,0,0),(52,100,1,32,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,15,26,NULL,1,0,0,0),(53,100,1,32,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,15,26,NULL,1,0,0,0),(54,100,1,32,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,15,26,NULL,1,0,0,0),(55,100,1,32,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,15,26,NULL,1,0,0,0),(56,200,1,32,4,NULL,NULL,NULL,NULL,0,0,'Glancer',0,15,26,NULL,1,0,0,0),(57,200,1,32,4,NULL,NULL,NULL,NULL,0,0,'Glancer',0,15,26,NULL,1,0,0,0),(58,200,1,32,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,15,26,NULL,1,0,0,0),(59,200,1,32,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,15,26,NULL,1,0,0,0),(60,100,1,32,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,15,26,NULL,1,0,0,0),(61,100,1,32,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,15,26,NULL,1,0,0,0),(62,100,1,32,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,15,26,NULL,1,0,0,0),(63,100,1,32,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,7,28,NULL,1,0,0,0),(64,100,1,32,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,7,28,NULL,1,0,0,0),(65,100,1,32,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,7,28,NULL,1,0,0,0),(66,100,1,32,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,7,28,NULL,1,0,0,0),(67,100,1,32,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,7,28,NULL,1,0,0,0),(68,200,1,32,4,NULL,NULL,NULL,NULL,0,0,'Glancer',0,7,28,NULL,1,0,0,0),(69,200,1,32,4,NULL,NULL,NULL,NULL,0,0,'Glancer',0,7,28,NULL,1,0,0,0),(70,200,1,32,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,7,28,NULL,1,0,0,0),(71,200,1,32,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,7,28,NULL,1,0,0,0),(72,100,1,32,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,7,28,NULL,1,0,0,0),(73,100,1,32,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,7,28,NULL,1,0,0,0),(74,100,1,32,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,7,28,NULL,1,0,0,0),(75,100,1,32,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,24,24,NULL,1,0,0,0),(76,100,1,32,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,24,24,NULL,1,0,0,0),(77,100,1,32,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,24,24,NULL,1,0,0,0),(78,100,1,32,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,24,24,NULL,1,0,0,0),(79,100,1,32,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,24,24,NULL,1,0,0,0),(80,200,1,32,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,24,24,NULL,1,0,0,0),(81,200,1,32,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,24,24,NULL,1,0,0,0),(82,100,1,32,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,0,28,NULL,1,0,0,0),(83,100,1,32,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,0,28,NULL,1,0,0,0),(84,100,1,32,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,0,28,NULL,1,0,0,0),(85,100,1,32,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,0,28,NULL,1,0,0,0),(86,100,1,32,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,0,28,NULL,1,0,0,0),(87,200,1,32,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,0,28,NULL,1,0,0,0),(88,200,1,32,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,0,28,NULL,1,0,0,0),(89,100,1,32,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,22,27,NULL,1,0,0,0),(90,100,1,32,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,22,27,NULL,1,0,0,0),(91,100,1,32,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,22,27,NULL,1,0,0,0),(92,100,1,32,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,22,27,NULL,1,0,0,0),(93,100,1,32,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,22,27,NULL,1,0,0,0),(94,200,1,32,4,NULL,NULL,NULL,NULL,0,0,'Glancer',0,22,27,NULL,1,0,0,0),(95,200,1,32,4,NULL,NULL,NULL,NULL,0,0,'Glancer',0,22,27,NULL,1,0,0,0),(96,200,1,32,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,22,27,NULL,1,0,0,0),(97,200,1,32,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,22,27,NULL,1,0,0,0),(98,100,1,32,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,22,27,NULL,1,0,0,0),(99,100,1,32,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,22,27,NULL,1,0,0,0),(100,100,1,32,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,22,27,NULL,1,0,0,0),(101,100,1,32,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,25,20,NULL,1,0,0,0),(102,100,1,32,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,25,20,NULL,1,0,0,0),(103,100,1,32,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,25,20,NULL,1,0,0,0),(104,100,1,32,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,25,20,NULL,1,0,0,0),(105,100,1,32,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,25,20,NULL,1,0,0,0),(106,200,1,32,4,NULL,NULL,NULL,NULL,0,0,'Glancer',0,25,20,NULL,1,0,0,0),(107,200,1,32,4,NULL,NULL,NULL,NULL,0,0,'Glancer',0,25,20,NULL,1,0,0,0),(108,200,1,32,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,25,20,NULL,1,0,0,0),(109,200,1,32,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,25,20,NULL,1,0,0,0),(110,100,1,32,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,25,20,NULL,1,0,0,0),(111,100,1,32,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,25,20,NULL,1,0,0,0),(112,100,1,32,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,25,20,NULL,1,0,0,0),(113,100,1,32,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,12,27,NULL,1,0,0,0),(114,100,1,32,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,12,27,NULL,1,0,0,0),(115,100,1,32,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,12,27,NULL,1,0,0,0),(116,100,1,32,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,12,27,NULL,1,0,0,0),(117,100,1,32,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,12,27,NULL,1,0,0,0),(118,200,1,32,4,NULL,NULL,NULL,NULL,0,0,'Glancer',0,12,27,NULL,1,0,0,0),(119,200,1,32,4,NULL,NULL,NULL,NULL,0,0,'Glancer',0,12,27,NULL,1,0,0,0),(120,200,1,32,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,12,27,NULL,1,0,0,0),(121,200,1,32,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,12,27,NULL,1,0,0,0),(122,100,1,32,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,12,27,NULL,1,0,0,0),(123,100,1,32,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,12,27,NULL,1,0,0,0),(124,100,1,32,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,12,27,NULL,1,0,0,0),(125,100,1,32,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,26,27,NULL,1,0,0,0),(126,100,1,32,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,26,27,NULL,1,0,0,0),(127,100,1,32,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,26,27,NULL,1,0,0,0),(128,100,1,32,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,26,27,NULL,1,0,0,0),(129,100,1,32,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,26,27,NULL,1,0,0,0),(130,200,1,32,4,NULL,NULL,NULL,NULL,0,0,'Glancer',0,26,27,NULL,1,0,0,0),(131,200,1,32,4,NULL,NULL,NULL,NULL,0,0,'Glancer',0,26,27,NULL,1,0,0,0),(132,200,1,32,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,26,27,NULL,1,0,0,0),(133,200,1,32,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,26,27,NULL,1,0,0,0),(134,100,1,32,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,26,27,NULL,1,0,0,0),(135,100,1,32,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,26,27,NULL,1,0,0,0),(136,100,1,32,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,26,27,NULL,1,0,0,0);
/*!40000 ALTER TABLE `units` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2010-10-11 16:20:39
