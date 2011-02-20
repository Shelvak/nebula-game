-- MySQL dump 10.13  Distrib 5.1.49, for debian-linux-gnu (i686)
--
-- Host: localhost    Database: spacegame
-- ------------------------------------------------------
-- Server version	5.1.49-1ubuntu8.1

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
  CONSTRAINT `buildings_ibfk_1` FOREIGN KEY (`planet_id`) REFERENCES `ss_objects` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=87 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `buildings`
--

LOCK TABLES `buildings` WRITE;
/*!40000 ALTER TABLE `buildings` DISABLE KEYS */;
INSERT INTO `buildings` VALUES (1,2,32,9,0,0,0,1,'NpcMetalExtractor',NULL,33,10,NULL,1,400,NULL,0,NULL,NULL,0),(2,2,18,1,0,0,0,1,'NpcMetalExtractor',NULL,19,2,NULL,1,400,NULL,0,NULL,NULL,0),(3,2,13,8,0,0,0,1,'NpcMetalExtractor',NULL,14,9,NULL,1,400,NULL,0,NULL,NULL,0),(4,2,25,5,0,0,0,1,'NpcMetalExtractor',NULL,26,6,NULL,1,400,NULL,0,NULL,NULL,0),(5,2,3,1,0,0,0,1,'NpcMetalExtractor',NULL,4,2,NULL,1,400,NULL,0,NULL,NULL,0),(6,2,23,30,0,0,0,1,'NpcMetalExtractor',NULL,24,31,NULL,1,400,NULL,0,NULL,NULL,0),(7,2,27,22,0,0,0,1,'NpcMetalExtractor',NULL,28,23,NULL,1,400,NULL,0,NULL,NULL,0),(8,2,26,1,0,0,0,1,'NpcGeothermalPlant',NULL,27,2,NULL,1,600,NULL,0,NULL,NULL,0),(9,2,19,25,0,0,0,1,'NpcZetiumExtractor',NULL,20,26,NULL,1,1600,NULL,0,NULL,NULL,0),(10,2,24,37,0,0,0,1,'NpcZetiumExtractor',NULL,25,38,NULL,1,1600,NULL,0,NULL,NULL,0),(11,2,19,9,0,0,0,1,'NpcJumpgate',NULL,23,13,NULL,1,8000,NULL,0,NULL,NULL,0),(12,2,5,15,0,0,0,1,'NpcJumpgate',NULL,9,19,NULL,1,8000,NULL,0,NULL,NULL,0),(13,2,16,4,0,0,0,1,'NpcJumpgate',NULL,20,8,NULL,1,8000,NULL,0,NULL,NULL,0),(14,2,11,2,0,0,0,1,'NpcResearchCenter',NULL,14,5,NULL,1,4000,NULL,0,NULL,NULL,0),(15,2,11,27,0,0,0,1,'NpcExcavationSite',NULL,14,30,NULL,1,3000,NULL,0,NULL,NULL,0),(16,2,0,18,0,0,0,1,'NpcCommunicationsHub',NULL,3,19,NULL,1,1200,NULL,0,NULL,NULL,0),(17,2,29,0,0,0,0,1,'NpcTemple',NULL,31,2,NULL,1,2500,NULL,0,NULL,NULL,0),(18,2,10,17,0,0,0,1,'NpcCommunicationsHub',NULL,13,18,NULL,1,1200,NULL,0,NULL,NULL,0),(19,2,16,21,0,0,0,1,'NpcSolarPlant',NULL,17,22,NULL,1,1000,NULL,0,NULL,NULL,0),(20,2,22,7,0,0,0,1,'NpcSolarPlant',NULL,23,8,NULL,1,1000,NULL,0,NULL,NULL,0),(21,2,0,4,0,0,0,1,'NpcSolarPlant',NULL,1,5,NULL,1,1000,NULL,0,NULL,NULL,0),(22,2,29,10,0,0,0,1,'NpcSolarPlant',NULL,30,11,NULL,1,1000,NULL,0,NULL,NULL,0),(23,5,0,0,0,0,0,1,'NpcMetalExtractor',NULL,1,1,NULL,1,400,NULL,0,NULL,NULL,0),(24,5,7,0,0,0,0,1,'NpcCommunicationsHub',NULL,10,1,NULL,1,1200,NULL,0,NULL,NULL,0),(25,5,18,0,0,0,0,1,'NpcSolarPlant',NULL,19,1,NULL,1,1000,NULL,0,NULL,NULL,0),(26,5,3,1,0,0,0,1,'NpcMetalExtractor',NULL,4,2,NULL,1,400,NULL,0,NULL,NULL,0),(27,5,12,1,0,0,0,1,'NpcSolarPlant',NULL,13,2,NULL,1,1000,NULL,0,NULL,NULL,0),(28,5,22,1,0,0,0,1,'NpcSolarPlant',NULL,23,2,NULL,1,1000,NULL,0,NULL,NULL,0),(29,5,26,1,0,0,0,1,'NpcCommunicationsHub',NULL,29,2,NULL,1,1200,NULL,0,NULL,NULL,0),(30,5,15,3,0,0,0,1,'NpcSolarPlant',NULL,16,4,NULL,1,1000,NULL,0,NULL,NULL,0),(31,5,18,3,0,0,0,1,'NpcSolarPlant',NULL,19,4,NULL,1,1000,NULL,0,NULL,NULL,0),(32,5,24,4,0,0,0,1,'NpcMetalExtractor',NULL,25,5,NULL,1,400,NULL,0,NULL,NULL,0),(33,5,28,4,0,0,0,1,'NpcMetalExtractor',NULL,29,5,NULL,1,400,NULL,0,NULL,NULL,0),(34,5,7,6,0,0,0,1,'Screamer',NULL,8,7,NULL,1,1300,NULL,0,NULL,NULL,0),(35,5,21,6,0,0,0,1,'Vulcan',NULL,22,7,NULL,1,1000,NULL,0,NULL,NULL,0),(36,5,14,7,0,0,0,1,'Thunder',NULL,15,8,NULL,1,2000,NULL,0,NULL,NULL,0),(37,5,10,8,0,0,0,1,'Thunder',NULL,11,9,NULL,1,2000,NULL,0,NULL,NULL,0),(38,5,18,8,0,0,0,1,'Screamer',NULL,19,9,NULL,1,1300,NULL,0,NULL,NULL,0),(39,5,25,8,0,0,0,1,'NpcCommunicationsHub',NULL,28,9,NULL,1,1200,NULL,0,NULL,NULL,0),(40,5,11,10,0,0,0,1,'Mothership',NULL,18,15,NULL,1,10500,NULL,0,NULL,NULL,0),(41,5,20,10,0,0,0,1,'Thunder',NULL,21,11,NULL,1,2000,NULL,0,NULL,NULL,0),(42,5,7,12,0,0,0,1,'Thunder',NULL,8,13,NULL,1,2000,NULL,0,NULL,NULL,0),(43,5,21,12,0,0,0,1,'Thunder',NULL,22,13,NULL,1,2000,NULL,0,NULL,NULL,0),(44,5,26,12,0,0,0,1,'NpcZetiumExtractor',NULL,27,13,NULL,1,1600,NULL,0,NULL,NULL,0),(45,5,11,17,0,0,0,1,'Vulcan',NULL,12,18,NULL,1,1000,NULL,0,NULL,NULL,0),(46,5,17,17,0,0,0,1,'Thunder',NULL,18,18,NULL,1,2000,NULL,0,NULL,NULL,0),(47,5,7,19,0,0,0,1,'Vulcan',NULL,8,20,NULL,1,1000,NULL,0,NULL,NULL,0),(48,5,14,19,0,0,0,1,'Thunder',NULL,15,20,NULL,1,2000,NULL,0,NULL,NULL,0),(49,5,21,19,0,0,0,1,'Screamer',NULL,22,20,NULL,1,1300,NULL,0,NULL,NULL,0),(50,5,13,26,0,0,0,1,'NpcSolarPlant',NULL,14,27,NULL,1,1000,NULL,0,NULL,NULL,0),(51,5,20,27,0,0,0,1,'NpcSolarPlant',NULL,21,28,NULL,1,1000,NULL,0,NULL,NULL,0),(52,5,0,28,0,0,0,1,'NpcSolarPlant',NULL,1,29,NULL,1,1000,NULL,0,NULL,NULL,0),(53,5,3,28,0,0,0,1,'NpcSolarPlant',NULL,4,29,NULL,1,1000,NULL,0,NULL,NULL,0),(54,5,17,28,0,0,0,1,'NpcZetiumExtractor',NULL,18,29,NULL,1,1600,NULL,0,NULL,NULL,0),(55,5,28,28,0,0,0,1,'NpcSolarPlant',NULL,29,29,NULL,1,1000,NULL,0,NULL,NULL,0),(56,9,3,11,0,0,0,1,'NpcMetalExtractor',NULL,4,12,NULL,1,400,NULL,0,NULL,NULL,0),(57,9,18,8,0,0,0,1,'NpcGeothermalPlant',NULL,19,9,NULL,1,600,NULL,0,NULL,NULL,0),(58,9,22,17,0,0,0,1,'NpcZetiumExtractor',NULL,23,18,NULL,1,1600,NULL,0,NULL,NULL,0),(59,9,1,22,0,0,0,1,'NpcZetiumExtractor',NULL,2,23,NULL,1,1600,NULL,0,NULL,NULL,0),(60,9,26,16,0,0,0,1,'NpcZetiumExtractor',NULL,27,17,NULL,1,1600,NULL,0,NULL,NULL,0),(61,9,9,15,0,0,0,1,'NpcJumpgate',NULL,13,19,NULL,1,8000,NULL,0,NULL,NULL,0),(62,9,14,12,0,0,0,1,'NpcResearchCenter',NULL,17,15,NULL,1,4000,NULL,0,NULL,NULL,0),(63,9,1,1,0,0,0,1,'NpcExcavationSite',NULL,4,4,NULL,1,3000,NULL,0,NULL,NULL,0),(64,9,24,6,0,0,0,1,'NpcExcavationSite',NULL,27,9,NULL,1,3000,NULL,0,NULL,NULL,0),(65,9,28,8,0,0,0,1,'NpcTemple',NULL,30,10,NULL,1,2500,NULL,0,NULL,NULL,0),(66,9,27,4,0,0,0,1,'NpcCommunicationsHub',NULL,30,5,NULL,1,1200,NULL,0,NULL,NULL,0),(67,9,0,6,0,0,0,1,'NpcSolarPlant',NULL,1,7,NULL,1,1000,NULL,0,NULL,NULL,0),(68,9,7,5,0,0,0,1,'NpcSolarPlant',NULL,8,6,NULL,1,1000,NULL,0,NULL,NULL,0),(69,9,6,16,0,0,0,1,'NpcSolarPlant',NULL,7,17,NULL,1,1000,NULL,0,NULL,NULL,0),(70,9,0,27,0,0,0,1,'NpcSolarPlant',NULL,1,28,NULL,1,1000,NULL,0,NULL,NULL,0),(71,25,8,33,0,0,0,1,'NpcMetalExtractor',NULL,9,34,NULL,1,400,NULL,0,NULL,NULL,0),(72,25,3,34,0,0,0,1,'NpcMetalExtractor',NULL,4,35,NULL,1,400,NULL,0,NULL,NULL,0),(73,25,7,19,0,0,0,1,'NpcMetalExtractor',NULL,8,20,NULL,1,400,NULL,0,NULL,NULL,0),(74,25,13,17,0,0,0,1,'NpcGeothermalPlant',NULL,14,18,NULL,1,600,NULL,0,NULL,NULL,0),(75,25,32,10,0,0,0,1,'NpcGeothermalPlant',NULL,33,11,NULL,1,600,NULL,0,NULL,NULL,0),(76,25,9,8,0,0,0,1,'NpcZetiumExtractor',NULL,10,9,NULL,1,1600,NULL,0,NULL,NULL,0),(77,25,14,29,0,0,0,1,'NpcZetiumExtractor',NULL,15,30,NULL,1,1600,NULL,0,NULL,NULL,0),(78,25,33,29,0,0,0,1,'NpcZetiumExtractor',NULL,34,30,NULL,1,1600,NULL,0,NULL,NULL,0),(79,25,34,34,0,0,0,1,'NpcJumpgate',NULL,38,38,NULL,1,8000,NULL,0,NULL,NULL,0),(80,25,1,12,0,0,0,1,'NpcResearchCenter',NULL,4,15,NULL,1,4000,NULL,0,NULL,NULL,0),(81,25,25,36,0,0,0,1,'NpcTemple',NULL,27,38,NULL,1,2500,NULL,0,NULL,NULL,0),(82,25,22,10,0,0,0,1,'NpcCommunicationsHub',NULL,25,11,NULL,1,1200,NULL,0,NULL,NULL,0),(83,25,6,12,0,0,0,1,'NpcSolarPlant',NULL,7,13,NULL,1,1000,NULL,0,NULL,NULL,0),(84,25,18,12,0,0,0,1,'NpcSolarPlant',NULL,19,13,NULL,1,1000,NULL,0,NULL,NULL,0),(85,25,11,11,0,0,0,1,'NpcSolarPlant',NULL,12,12,NULL,1,1000,NULL,0,NULL,NULL,0),(86,25,29,6,0,0,0,1,'NpcSolarPlant',NULL,30,7,NULL,1,1000,NULL,0,NULL,NULL,0);
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
  KEY `tick` (`ends_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `callbacks`
--

LOCK TABLES `callbacks` WRITE;
/*!40000 ALTER TABLE `callbacks` DISABLE KEYS */;
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
  `kind` tinyint(2) unsigned NOT NULL DEFAULT '0',
  UNIQUE KEY `coords` (`planet_id`,`x`,`y`),
  CONSTRAINT `folliages_ibfk_1` FOREIGN KEY (`planet_id`) REFERENCES `ss_objects` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `folliages`
--

LOCK TABLES `folliages` WRITE;
/*!40000 ALTER TABLE `folliages` DISABLE KEYS */;
INSERT INTO `folliages` VALUES (2,0,12,1),(2,0,17,0),(2,0,20,1),(2,0,34,8),(2,0,41,4),(2,1,21,6),(2,1,25,10),(2,1,33,1),(2,1,38,1),(2,2,22,12),(2,2,29,5),(2,2,34,9),(2,2,35,8),(2,3,20,9),(2,4,14,1),(2,4,23,2),(2,4,24,5),(2,4,27,13),(2,4,31,8),(2,6,20,8),(2,6,25,8),(2,6,42,12),(2,7,24,9),(2,7,32,2),(2,8,11,4),(2,8,23,8),(2,8,26,7),(2,8,30,10),(2,8,42,11),(2,9,11,7),(2,9,36,7),(2,10,27,4),(2,10,32,1),(2,10,33,3),(2,11,8,4),(2,11,9,10),(2,11,15,7),(2,11,26,6),(2,11,31,5),(2,11,35,9),(2,11,41,10),(2,12,9,4),(2,12,25,10),(2,12,31,7),(2,12,32,1),(2,12,35,1),(2,12,41,7),(2,13,6,7),(2,13,12,9),(2,13,15,12),(2,13,16,2),(2,13,19,7),(2,14,19,11),(2,14,20,7),(2,14,26,11),(2,14,32,5),(2,14,36,3),(2,14,38,2),(2,15,6,6),(2,15,7,7),(2,15,20,10),(2,15,23,0),(2,15,33,7),(2,15,35,3),(2,15,41,1),(2,16,2,4),(2,16,16,4),(2,16,31,11),(2,16,32,8),(2,16,35,8),(2,16,42,6),(2,17,2,8),(2,17,20,1),(2,17,26,2),(2,17,27,12),(2,17,40,10),(2,18,15,8),(2,18,21,3),(2,18,27,9),(2,18,28,2),(2,18,30,5),(2,18,34,5),(2,18,35,4),(2,18,42,1),(2,19,18,1),(2,19,22,1),(2,19,32,2),(2,20,21,7),(2,21,18,3),(2,21,24,11),(2,21,27,5),(2,21,28,4),(2,21,37,5),(2,22,1,1),(2,22,2,3),(2,22,20,11),(2,22,21,6),(2,22,25,0),(2,23,0,3),(2,23,5,6),(2,23,14,11),(2,23,19,10),(2,23,20,4),(2,23,22,4),(2,23,26,5),(2,23,29,5),(2,23,32,10),(2,23,33,3),(2,23,41,1),(2,24,4,4),(2,24,5,1),(2,24,7,4),(2,24,33,2),(2,24,35,4),(2,24,40,3),(2,24,41,9),(2,24,42,1),(2,25,9,10),(2,25,12,3),(2,25,34,8),(2,26,4,1),(2,26,10,0),(2,26,31,1),(2,26,41,5),(2,27,11,8),(2,27,12,4),(2,27,24,3),(2,27,25,10),(2,27,26,6),(2,27,28,9),(2,27,39,6),(2,27,42,0),(2,28,12,5),(2,28,16,6),(2,28,17,0),(2,28,26,4),(2,28,38,10),(2,28,40,2),(2,28,41,3),(2,29,3,8),(2,29,4,3),(2,29,13,2),(2,29,15,8),(2,29,18,9),(2,29,21,2),(2,29,23,1),(2,29,26,8),(2,29,27,9),(2,29,28,1),(2,29,36,9),(2,29,38,2),(2,29,41,7),(2,30,12,5),(2,30,13,11),(2,30,18,3),(2,30,20,13),(2,30,22,9),(2,30,24,7),(2,30,40,13),(2,30,41,3),(2,30,42,6),(2,31,7,2),(2,31,8,8),(2,31,19,9),(2,31,20,6),(2,31,21,0),(2,31,24,10),(2,31,25,10),(2,31,40,8),(2,31,42,13),(2,32,4,2),(2,32,7,2),(2,32,13,2),(2,32,14,2),(2,32,17,4),(2,32,24,9),(2,32,37,2),(2,33,2,1),(2,33,6,6),(2,33,21,2),(2,33,22,9),(2,33,38,2),(2,33,39,4),(2,34,2,7),(2,34,17,6),(2,35,5,1),(2,35,14,3),(2,35,25,3),(2,35,36,2),(2,36,3,11),(2,36,33,0),(2,36,39,0),(2,36,40,3),(5,0,16,7),(5,0,21,0),(5,0,25,4),(5,1,15,12),(5,1,24,11),(5,2,26,3),(5,3,18,0),(5,3,26,13),(5,4,11,12),(5,5,7,8),(5,5,10,10),(5,5,20,8),(5,6,3,10),(5,6,20,1),(5,6,23,2),(5,7,4,13),(5,7,11,0),(5,8,2,10),(5,8,3,7),(5,8,22,12),(5,8,29,8),(5,9,5,4),(5,9,10,2),(5,9,13,0),(5,10,15,1),(5,10,18,2),(5,10,22,6),(5,12,20,4),(5,12,21,10),(5,12,29,11),(5,13,16,9),(5,13,19,1),(5,13,23,5),(5,13,24,5),(5,13,28,3),(5,14,16,3),(5,14,23,6),(5,15,17,0),(5,15,24,12),(5,15,27,10),(5,15,28,10),(5,16,6,9),(5,16,7,2),(5,17,6,3),(5,17,7,6),(5,17,22,8),(5,17,23,6),(5,17,25,7),(5,18,6,12),(5,18,20,5),(5,19,14,2),(5,19,16,3),(5,19,22,3),(5,19,26,3),(5,19,28,2),(5,20,15,10),(5,20,17,9),(5,21,8,8),(5,21,22,6),(5,21,25,8),(5,22,3,8),(5,22,10,7),(5,22,11,11),(5,22,14,1),(5,22,15,4),(5,22,22,3),(5,23,6,8),(5,23,8,10),(5,23,21,8),(5,23,23,1),(5,24,13,11),(5,24,15,10),(5,24,19,12),(5,24,21,0),(5,25,1,0),(5,25,2,0),(5,25,3,10),(5,25,18,4),(5,25,22,9),(5,25,26,12),(5,26,5,1),(5,26,11,8),(5,26,16,0),(5,26,18,2),(5,26,20,11),(5,27,0,0),(5,27,20,0),(5,27,25,6),(5,28,12,6),(5,28,20,4),(9,0,0,5),(9,0,11,11),(9,0,14,7),(9,0,15,3),(9,0,16,11),(9,0,20,3),(9,0,23,12),(9,1,0,7),(9,1,9,12),(9,1,16,0),(9,1,18,6),(9,1,20,10),(9,2,12,12),(9,2,15,10),(9,2,20,0),(9,2,21,4),(9,3,5,3),(9,3,15,0),(9,3,22,1),(9,3,32,10),(9,4,13,9),(9,4,20,1),(9,4,31,1),(9,5,2,9),(9,6,2,1),(9,6,21,3),(9,6,26,3),(9,6,31,10),(9,7,0,3),(9,7,2,1),(9,7,3,4),(9,7,15,13),(9,7,27,11),(9,7,29,1),(9,7,31,7),(9,8,1,13),(9,8,9,11),(9,8,19,5),(9,8,25,7),(9,8,29,6),(9,9,5,10),(9,9,20,7),(9,9,25,13),(9,9,26,3),(9,9,27,12),(9,10,1,4),(9,10,4,2),(9,10,9,2),(9,10,20,13),(9,10,25,7),(9,10,27,5),(9,10,30,5),(9,11,8,10),(9,11,25,10),(9,12,1,12),(9,12,6,7),(9,12,23,7),(9,12,24,1),(9,12,25,11),(9,12,32,10),(9,13,6,7),(9,13,32,10),(9,14,6,12),(9,14,32,12),(9,15,0,1),(9,15,1,11),(9,15,2,7),(9,15,6,2),(9,15,7,7),(9,16,0,10),(9,16,1,4),(9,16,2,1),(9,16,7,12),(9,16,10,10),(9,16,11,13),(9,16,32,10),(9,17,0,1),(9,17,5,7),(9,17,6,11),(9,18,0,0),(9,18,10,13),(9,18,12,4),(9,18,13,2),(9,18,14,10),(9,18,21,3),(9,19,4,12),(9,19,7,2),(9,19,10,2),(9,19,23,1),(9,20,3,13),(9,20,4,9),(9,20,11,0),(9,21,2,10),(9,21,10,10),(9,21,11,2),(9,21,32,5),(9,22,3,10),(9,22,6,0),(9,22,9,13),(9,22,14,2),(9,22,16,12),(9,23,1,1),(9,23,3,13),(9,23,5,10),(9,23,6,7),(9,23,8,11),(9,23,12,6),(9,23,14,3),(9,24,5,6),(9,24,15,5),(9,24,17,1),(9,25,13,13),(9,25,29,0),(9,26,2,13),(9,26,19,6),(9,26,29,4),(9,28,19,12),(9,29,6,13),(9,29,7,10),(9,29,17,13),(9,29,23,2),(9,30,6,6),(9,30,13,13),(9,30,27,1),(25,0,19,10),(25,0,22,6),(25,0,28,8),(25,0,30,4),(25,0,36,13),(25,0,37,3),(25,0,38,1),(25,1,7,1),(25,1,24,2),(25,1,31,10),(25,1,37,13),(25,3,11,13),(25,4,7,9),(25,4,8,10),(25,4,20,0),(25,5,0,6),(25,5,13,8),(25,6,20,11),(25,6,21,10),(25,6,32,13),(25,6,33,0),(25,6,38,4),(25,7,21,13),(25,7,38,3),(25,8,1,6),(25,8,6,10),(25,8,16,0),(25,8,21,9),(25,8,24,10),(25,8,37,10),(25,9,17,7),(25,9,19,12),(25,9,25,6),(25,10,1,0),(25,10,6,9),(25,10,10,1),(25,10,18,7),(25,10,23,1),(25,11,0,4),(25,11,1,3),(25,11,3,13),(25,11,9,5),(25,11,10,3),(25,11,30,6),(25,12,7,11),(25,12,8,11),(25,12,17,0),(25,12,30,13),(25,12,34,11),(25,12,37,0),(25,13,8,3),(25,13,37,5),(25,14,5,10),(25,14,12,9),(25,14,31,11),(25,15,9,8),(25,15,13,1),(25,15,15,11),(25,15,23,11),(25,15,24,9),(25,16,8,10),(25,16,13,12),(25,16,15,6),(25,16,24,7),(25,16,26,6),(25,16,27,10),(25,16,31,3),(25,17,4,3),(25,18,7,10),(25,18,25,5),(25,18,30,10),(25,18,31,12),(25,18,35,4),(25,18,38,13),(25,19,6,13),(25,19,8,0),(25,19,10,11),(25,19,14,2),(25,19,15,13),(25,19,25,8),(25,19,29,2),(25,19,36,7),(25,20,6,9),(25,20,8,10),(25,20,26,1),(25,20,37,3),(25,21,7,13),(25,21,10,7),(25,21,11,6),(25,21,25,5),(25,21,26,12),(25,21,32,9),(25,22,8,0),(25,22,9,3),(25,22,12,0),(25,22,14,0),(25,22,15,0),(25,22,25,0),(25,22,27,5),(25,22,31,4),(25,22,37,9),(25,23,13,12),(25,23,25,3),(25,23,37,4),(25,24,6,13),(25,24,12,11),(25,24,17,11),(25,24,25,9),(25,25,13,13),(25,26,8,0),(25,26,9,0),(25,26,13,1),(25,26,16,4),(25,26,26,12),(25,26,32,4),(25,27,6,2),(25,27,10,5),(25,27,12,5),(25,28,13,12),(25,28,28,3),(25,28,29,0),(25,28,31,11),(25,28,36,8),(25,28,37,1),(25,29,0,2),(25,29,3,7),(25,29,12,5),(25,29,25,5),(25,29,28,9),(25,30,1,7),(25,30,2,6),(25,30,12,6),(25,30,28,0),(25,30,30,5),(25,30,35,11),(25,30,38,0),(25,31,10,2),(25,31,22,13),(25,31,37,3),(25,31,38,6),(25,32,9,6),(25,32,23,7),(25,32,25,12),(25,32,29,12),(25,32,34,7),(25,33,0,5),(25,33,26,10),(25,33,34,2),(25,33,35,0),(25,34,7,13),(25,34,27,4),(25,35,0,0),(25,35,27,6),(25,35,31,4),(25,35,33,6),(25,36,0,4),(25,36,3,13),(25,36,4,5),(25,36,5,6),(25,36,9,8),(25,36,26,12),(25,36,27,13),(25,36,28,5),(25,36,33,9),(25,37,1,10),(25,37,4,12),(25,37,9,6),(25,37,13,1),(25,37,32,13),(25,38,0,12),(25,38,2,5),(25,38,4,2),(25,38,9,5),(25,38,17,13),(25,38,28,8),(25,38,30,1);
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `fow_galaxy_entries`
--

LOCK TABLES `fow_galaxy_entries` WRITE;
/*!40000 ALTER TABLE `fow_galaxy_entries` DISABLE KEYS */;
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
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `fow_ss_entries`
--

LOCK TABLES `fow_ss_entries` WRITE;
/*!40000 ALTER TABLE `fow_ss_entries` DISABLE KEYS */;
INSERT INTO `fow_ss_entries` VALUES (1,1,1,1,1,0,0,0,NULL,NULL,NULL,NULL,NULL);
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
INSERT INTO `galaxies` VALUES (1,'2011-02-21 00:55:50','dev');
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `notifications`
--

LOCK TABLES `notifications` WRITE;
/*!40000 ALTER TABLE `notifications` DISABLE KEYS */;
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `objective_progresses`
--

LOCK TABLES `objective_progresses` WRITE;
/*!40000 ALTER TABLE `objective_progresses` DISABLE KEYS */;
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
  `limit` int(10) unsigned DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `quest_objectives` (`quest_id`),
  KEY `on_progress` (`type`,`key`),
  CONSTRAINT `objectives_ibfk_1` FOREIGN KEY (`quest_id`) REFERENCES `quests` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=40 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `objectives`
--

LOCK TABLES `objectives` WRITE;
/*!40000 ALTER TABLE `objectives` DISABLE KEYS */;
INSERT INTO `objectives` VALUES (1,1,'HaveUpgradedTo','Building::CollectorT1',1,1,0,0,NULL),(2,2,'HaveUpgradedTo','Building::MetalExtractor',1,1,0,0,NULL),(3,3,'HaveUpgradedTo','Building::CollectorT1',2,1,0,0,NULL),(4,3,'HaveUpgradedTo','Building::MetalExtractor',2,1,0,0,NULL),(5,22,'ExploreBlock','ExploreBlock',1,NULL,0,0,9),(6,23,'ExploreBlock','ExploreBlock',10,NULL,0,0,9),(7,4,'HaveUpgradedTo','Building::CollectorT1',2,3,0,0,NULL),(8,4,'HaveUpgradedTo','Building::MetalExtractor',2,3,0,0,NULL),(9,5,'HaveUpgradedTo','Building::CollectorT1',2,4,0,0,NULL),(10,5,'HaveUpgradedTo','Building::MetalExtractor',2,4,0,0,NULL),(11,6,'HaveUpgradedTo','Building::Barracks',1,1,0,0,NULL),(12,7,'HaveUpgradedTo','Unit::Trooper',8,1,0,0,NULL),(13,8,'DestroyNpcBuilding','Building::NpcMetalExtractor',1,1,0,0,NULL),(14,32,'HaveUpgradedTo','Building::MetalExtractor',3,4,0,0,NULL),(15,9,'HaveUpgradedTo','Building::MetalExtractor',1,7,0,0,NULL),(16,10,'HaveUpgradedTo','Building::CollectorT1',1,7,0,0,NULL),(17,11,'HaveUpgradedTo','Building::ResearchCenter',1,1,0,0,NULL),(18,24,'ExploreBlock','ExploreBlock',5,NULL,0,0,12),(19,25,'ExploreBlock','ExploreBlock',5,NULL,0,0,16),(20,26,'ExploreBlock','ExploreBlock',10,NULL,0,0,36),(21,12,'HaveUpgradedTo','Unit::Seeker',3,1,0,0,NULL),(22,13,'HaveUpgradedTo','Unit::Trooper',4,2,0,0,NULL),(23,27,'DestroyNpcBuilding','Building::NpcZetiumExtractor',1,1,0,0,NULL),(24,14,'HaveUpgradedTo','Technology::ZetiumExtraction',1,1,0,0,NULL),(25,15,'HaveUpgradedTo','Building::ZetiumExtractor',1,1,0,0,NULL),(26,16,'HavePoints','Player',1,NULL,0,0,15000),(27,28,'HavePoints','Player',1,NULL,0,0,30000),(28,29,'HavePoints','Player',1,NULL,0,0,60000),(29,30,'HavePoints','Player',1,NULL,0,0,80000),(30,33,'HavePoints','Player',1,NULL,0,0,150000),(31,17,'HaveUpgradedTo','Building::MetalStorage',1,2,0,0,NULL),(32,17,'HaveUpgradedTo','Building::EnergyStorage',1,1,0,0,NULL),(33,17,'HaveUpgradedTo','Building::ZetiumStorage',1,1,0,0,NULL),(34,18,'HaveUpgradedTo','Technology::SpaceFactory',1,1,0,0,NULL),(35,19,'HaveUpgradedTo','Building::SpaceFactory',1,1,0,0,NULL),(36,31,'HaveUpgradedTo','Unit::Crow',8,1,0,0,NULL),(37,20,'AnnexPlanet','SsObject::Planet',1,NULL,0,1,NULL),(38,21,'UpgradeTo','Building::Headquarters',1,1,0,0,NULL),(39,34,'HaveUpgradedTo','Building::Radar',1,1,0,0,NULL);
/*!40000 ALTER TABLE `objectives` ENABLE KEYS */;
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
  `war_points` int(10) unsigned NOT NULL DEFAULT '0',
  `first_time` tinyint(1) NOT NULL DEFAULT '1',
  `army_points` int(10) unsigned NOT NULL DEFAULT '0',
  `science_points` int(10) unsigned NOT NULL DEFAULT '0',
  `economy_points` int(10) unsigned NOT NULL DEFAULT '0',
  `planets_count` tinyint(2) unsigned NOT NULL,
  `last_login` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `authentication` (`galaxy_id`,`auth_token`),
  KEY `index_players_on_alliance_id` (`alliance_id`),
  KEY `last_login` (`last_login`),
  CONSTRAINT `players_ibfk_1` FOREIGN KEY (`galaxy_id`) REFERENCES `galaxies` (`id`) ON DELETE CASCADE,
  CONSTRAINT `players_ibfk_2` FOREIGN KEY (`alliance_id`) REFERENCES `alliances` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `players`
--

LOCK TABLES `players` WRITE;
/*!40000 ALTER TABLE `players` DISABLE KEYS */;
INSERT INTO `players` VALUES (1,1,'0000000000000000000000000000000000000000000000000000000000000000','Test Player',18,18,NULL,0,0,1,0,0,0,1,NULL);
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `quest_progresses`
--

LOCK TABLES `quest_progresses` WRITE;
/*!40000 ALTER TABLE `quest_progresses` DISABLE KEYS */;
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
) ENGINE=InnoDB AUTO_INCREMENT=35 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `quests`
--

LOCK TABLES `quests` WRITE;
/*!40000 ALTER TABLE `quests` DISABLE KEYS */;
INSERT INTO `quests` VALUES (1,NULL,'{\"metal\":25.2,\"energy\":96.0}','Constructing Buildings'),(2,1,'{\"metal\":69.3,\"energy\":140.8}','Extracting Metal'),(3,2,'{\"metal\":2712.0,\"energy\":5424.0}',NULL),(4,3,'{\"metal\":412.5,\"energy\":920.7}','Upgrading Buildings'),(5,4,'{\"metal\":401.4,\"zetium\":10.8,\"points\":4000}',NULL),(6,3,'{\"metal\":949.2,\"energy\":1898.4,\"zetium\":16.2,\"units\":[{\"level\":1,\"type\":\"Trooper\",\"count\":4,\"hp\":100}]}',NULL),(7,6,'{\"metal\":723.2,\"energy\":1446.4,\"zetium\":16.2}','Building Units'),(8,6,'{\"metal\":1865.6,\"energy\":4134.9,\"zetium\":866.8,\"units\":[{\"level\":2,\"type\":\"Trooper\",\"count\":2,\"hp\":50},{\"level\":3,\"type\":\"Trooper\",\"count\":1,\"hp\":30}]}','Attacking NPC Buildings'),(9,32,'{\"metal\":862.8,\"energy\":4101.6,\"zetium\":16.2,\"points\":2000}',NULL),(10,8,'{\"metal\":1725.6,\"energy\":2461.2,\"zetium\":16.2,\"points\":2000}',NULL),(11,8,'{\"metal\":1853.2,\"energy\":3706.4,\"units\":[{\"level\":1,\"type\":\"Trooper\",\"count\":4,\"hp\":100},{\"level\":1,\"type\":\"Seeker\",\"count\":2,\"hp\":100}]}',NULL),(12,11,'{\"metal\":1374.5,\"energy\":2747.6,\"points\":2000}','Researching Technologies'),(13,12,'{\"metal\":692.55,\"energy\":1384.15,\"zetium\":12.35,\"points\":2000}',NULL),(14,11,'{\"metal\":39.6,\"energy\":160.8}',NULL),(15,14,'{\"metal\":3110.2,\"energy\":3038.8,\"zetium\":284.4}','Extracting Zetium'),(16,15,'{\"units\":[{\"level\":3,\"type\":\"Trooper\",\"count\":1,\"hp\":100},{\"level\":2,\"type\":\"Seeker\",\"count\":1,\"hp\":100},{\"level\":1,\"type\":\"Shocker\",\"count\":3,\"hp\":100}]}','Collecting Points'),(17,15,'{\"metal\":9225.6,\"energy\":12915.6,\"zetium\":646.8}',NULL),(18,17,'{\"metal\":15375.2,\"energy\":21525.6,\"zetium\":1076.8}',NULL),(19,18,'{\"metal\":16144.8,\"energy\":22604.4,\"zetium\":1134.0,\"units\":[{\"level\":1,\"type\":\"Crow\",\"count\":4,\"hp\":100}]}',NULL),(20,19,'{\"units\":[{\"level\":1,\"type\":\"Mule\",\"count\":1,\"hp\":100},{\"level\":1,\"type\":\"Mdh\",\"count\":1,\"hp\":100}]}','Annexing Planets'),(21,20,'{\"metal\":1158.5844,\"energy\":2560.7376,\"zetium\":117.99765}','Colonizing Planets'),(22,3,'{\"units\":[{\"level\":1,\"type\":\"Gnat\",\"count\":1,\"hp\":25}],\"points\":200}','Exploring Objects'),(23,22,'{\"units\":[{\"level\":1,\"type\":\"Glancer\",\"count\":1,\"hp\":60}],\"points\":1000}',NULL),(24,11,'{\"units\":[{\"level\":1,\"type\":\"Gnat\",\"count\":2,\"hp\":25},{\"level\":1,\"type\":\"Gnat\",\"count\":2,\"hp\":20},{\"level\":1,\"type\":\"Gnat\",\"count\":2,\"hp\":15},{\"level\":1,\"type\":\"Gnat\",\"count\":2,\"hp\":10}],\"points\":800}',NULL),(25,24,'{\"units\":[{\"level\":1,\"type\":\"Glancer\",\"count\":2,\"hp\":80}],\"points\":800}',NULL),(26,25,'{\"units\":[{\"level\":1,\"type\":\"Spudder\",\"count\":1,\"hp\":96}],\"points\":1600}',NULL),(27,11,'{\"metal\":396.0,\"energy\":1608.0}','Zetium Crystals'),(28,16,'{\"units\":[{\"level\":2,\"type\":\"Scorpion\",\"count\":2,\"hp\":70},{\"level\":1,\"type\":\"Azure\",\"count\":1,\"hp\":100}]}',NULL),(29,28,'{\"units\":[{\"level\":2,\"type\":\"Cyrix\",\"count\":2,\"hp\":60},{\"level\":1,\"type\":\"Crow\",\"count\":4,\"hp\":100}]}',NULL),(30,29,'{\"units\":[{\"level\":1,\"type\":\"Avenger\",\"count\":4,\"hp\":100},{\"level\":1,\"type\":\"Dart\",\"count\":4,\"hp\":100}]}',NULL),(31,19,'{\"metal\":23064,\"energy\":32292,\"zetium\":1620}','Fighting in Space'),(32,8,'{\"metal\":150.0,\"energy\":627.6,\"points\":2000}',NULL),(33,30,'{\"units\":[{\"level\":1,\"type\":\"Rhyno\",\"count\":1,\"hp\":100},{\"level\":1,\"type\":\"Cyrix\",\"count\":3,\"hp\":100}]}',NULL),(34,21,'{\"metal\":3862.4,\"energy\":25625.92,\"zetium\":524.8}','Exploring Galaxy');
/*!40000 ALTER TABLE `quests` ENABLE KEYS */;
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
INSERT INTO `schema_migrations` VALUES ('20090601175224'),('20090601184051'),('20090601184055'),('20090601184059'),('20090701164131'),('20090713165021'),('20090808144214'),('20090809160211'),('20090810173759'),('20090826140238'),('20090826141836'),('20090829202538'),('20090829210029'),('20090829224505'),('20090830143959'),('20090830145319'),('20090901153809'),('20090904190655'),('20090905175341'),('20090905192056'),('20090906135044'),('20090909222719'),('20090911180950'),('20090912165229'),('20090919155819'),('20091024222359'),('20091103164416'),('20091103180558'),('20091103181146'),('20091109191211'),('20091225193714'),('20100114152902'),('20100121142414'),('20100127115341'),('20100127120219'),('20100127120515'),('20100127121337'),('20100129150736'),('20100203202757'),('20100203204803'),('20100204172507'),('20100204173714'),('20100208163239'),('20100210114531'),('20100212134334'),('20100218181507'),('20100219114448'),('20100220144106'),('20100222144003'),('20100223153023'),('20100224153728'),('20100224163525'),('20100225124928'),('20100225153721'),('20100225155505'),('20100225155739'),('20100226122144'),('20100226122651'),('20100301153626'),('20100302131225'),('20100303131706'),('20100308163148'),('20100308164422'),('20100310172315'),('20100310181338'),('20100311123523'),('20100315112858'),('20100319141401'),('20100322184529'),('20100324134243'),('20100324141652'),('20100331125702'),('20100415130556'),('20100415130600'),('20100415130605'),('20100415134627'),('20100419141518'),('20100419142018'),('20100419164230'),('20100426141509'),('20100428130912'),('20100429171200'),('20100430174140'),('20100610151652'),('20100610180750'),('20100614142225'),('20100614160819'),('20100614162423'),('20100616132525'),('20100616135507'),('20100622124252'),('20100706105523'),('20100710121447'),('20100710191351'),('20100716155807'),('20100719131622'),('20100721155359'),('20100722124307'),('20100812164444'),('20100812164449'),('20100812164518'),('20100812164524'),('20100817165213'),('20100819175736'),('20100820185846'),('20100906095758'),('20100915145823'),('20100929111549'),('20101001155323'),('20101005180058'),('20101022155620'),('20101117131430'),('20101208135417'),('20101209122838'),('20101222150446'),('20101223125157'),('20101223172333'),('20110106110617'),('20110117182616'),('20110119121807'),('20110125161025'),('20110128094012'),('20110201122224'),('20110211124612'),('20110214165108'),('20110215161039'),('99999999999000'),('99999999999900');
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
  `galaxy_id` int(11) NOT NULL,
  `x` mediumint(9) NOT NULL,
  `y` mediumint(9) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uniqueness` (`galaxy_id`,`x`,`y`),
  CONSTRAINT `solar_systems_ibfk_1` FOREIGN KEY (`galaxy_id`) REFERENCES `galaxies` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `solar_systems`
--

LOCK TABLES `solar_systems` WRITE;
/*!40000 ALTER TABLE `solar_systems` DISABLE KEYS */;
INSERT INTO `solar_systems` VALUES (2,1,-1,-3),(1,1,-1,-2);
/*!40000 ALTER TABLE `solar_systems` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ss_objects`
--

DROP TABLE IF EXISTS `ss_objects`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ss_objects` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `solar_system_id` int(11) NOT NULL,
  `width` int(11) DEFAULT NULL,
  `height` int(11) DEFAULT NULL,
  `position` int(11) NOT NULL DEFAULT '0',
  `angle` int(11) NOT NULL DEFAULT '0',
  `type` varchar(255) NOT NULL,
  `player_id` int(11) DEFAULT NULL,
  `name` varchar(12) NOT NULL DEFAULT '',
  `size` int(11) NOT NULL DEFAULT '0',
  `terrain` tinyint(2) unsigned NOT NULL DEFAULT '0',
  `metal` float NOT NULL DEFAULT '0',
  `metal_rate` float NOT NULL DEFAULT '0',
  `metal_storage` float NOT NULL DEFAULT '0',
  `energy` float NOT NULL DEFAULT '0',
  `energy_rate` float NOT NULL DEFAULT '0',
  `energy_storage` float NOT NULL DEFAULT '0',
  `zetium` float NOT NULL DEFAULT '0',
  `zetium_rate` float NOT NULL DEFAULT '0',
  `zetium_storage` float NOT NULL DEFAULT '0',
  `last_resources_update` datetime DEFAULT NULL,
  `energy_diminish_registered` tinyint(1) NOT NULL DEFAULT '0',
  `exploration_x` tinyint(2) unsigned DEFAULT NULL,
  `exploration_y` tinyint(2) unsigned DEFAULT NULL,
  `exploration_ends_at` datetime DEFAULT NULL,
  `can_destroy_building_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uniqueness` (`solar_system_id`,`position`,`angle`),
  KEY `index_planets_on_galaxy_id_and_solar_system_id` (`solar_system_id`),
  KEY `index_planets_on_player_id_and_galaxy_id` (`player_id`),
  KEY `group_by_for_fowssentry_status_updates` (`player_id`,`solar_system_id`),
  CONSTRAINT `ss_objects_ibfk_1` FOREIGN KEY (`solar_system_id`) REFERENCES `solar_systems` (`id`) ON DELETE CASCADE,
  CONSTRAINT `ss_objects_ibfk_2` FOREIGN KEY (`player_id`) REFERENCES `players` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=27 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ss_objects`
--

LOCK TABLES `ss_objects` WRITE;
/*!40000 ALTER TABLE `ss_objects` DISABLE KEYS */;
INSERT INTO `ss_objects` VALUES (1,1,0,0,2,120,'Asteroid',NULL,'',41,0,0,0,1,0,0,1,0,0,1,NULL,0,NULL,NULL,NULL,NULL),(2,1,37,43,1,135,'Planet',NULL,'P-2',58,0,0,0,0,0,0,0,0,0,0,'2011-02-21 00:55:55',0,NULL,NULL,NULL,NULL),(3,1,0,0,2,210,'Asteroid',NULL,'',56,0,0,0,2,0,0,2,0,0,1,NULL,0,NULL,NULL,NULL,NULL),(4,1,0,0,1,180,'Asteroid',NULL,'',44,0,0,0,1,0,0,2,0,0,1,NULL,0,NULL,NULL,NULL,NULL),(5,1,30,30,0,270,'Planet',1,'P-5',50,0,3186.11,27900,9654.87,7042.03,61700,21339.5,0,0,2622.17,'2011-02-21 00:55:55',0,NULL,NULL,NULL,NULL),(6,1,0,0,3,90,'Jumpgate',NULL,'',52,0,0,0,0,0,0,0,0,0,0,NULL,0,NULL,NULL,NULL,NULL),(7,1,0,0,1,0,'Asteroid',NULL,'',60,0,0,0,1,0,0,1,0,0,1,NULL,0,NULL,NULL,NULL,NULL),(8,1,0,0,2,300,'Asteroid',NULL,'',34,0,0,0,2,0,0,2,0,0,2,NULL,0,NULL,NULL,NULL,NULL),(9,2,31,33,1,45,'Planet',NULL,'P-9',51,2,0,0,0,0,0,0,0,0,0,'2011-02-21 00:55:55',0,NULL,NULL,NULL,NULL),(10,2,0,0,2,90,'Asteroid',NULL,'',25,0,0,0,1,0,0,2,0,0,2,NULL,0,NULL,NULL,NULL,NULL),(11,2,0,0,1,225,'Asteroid',NULL,'',33,0,0,0,4,0,0,2,0,0,5,NULL,0,NULL,NULL,NULL,NULL),(12,2,0,0,1,180,'Asteroid',NULL,'',38,0,0,0,1,0,0,1,0,0,2,NULL,0,NULL,NULL,NULL,NULL),(13,2,0,0,2,210,'Asteroid',NULL,'',54,0,0,0,4,0,0,5,0,0,5,NULL,0,NULL,NULL,NULL,NULL),(14,2,0,0,3,202,'Jumpgate',NULL,'',56,0,0,0,0,0,0,0,0,0,0,NULL,0,NULL,NULL,NULL,NULL),(15,2,0,0,1,315,'Asteroid',NULL,'',27,0,0,0,1,0,0,1,0,0,2,NULL,0,NULL,NULL,NULL,NULL),(16,2,0,0,2,240,'Asteroid',NULL,'',53,0,0,0,1,0,0,2,0,0,1,NULL,0,NULL,NULL,NULL,NULL),(17,2,0,0,2,60,'Asteroid',NULL,'',54,0,0,0,4,0,0,4,0,0,3,NULL,0,NULL,NULL,NULL,NULL),(18,2,0,0,2,150,'Asteroid',NULL,'',47,0,0,0,2,0,0,1,0,0,1,NULL,0,NULL,NULL,NULL,NULL),(19,2,0,0,2,30,'Asteroid',NULL,'',41,0,0,0,2,0,0,2,0,0,2,NULL,0,NULL,NULL,NULL,NULL),(20,2,0,0,0,90,'Asteroid',NULL,'',36,0,0,0,4,0,0,2,0,0,2,NULL,0,NULL,NULL,NULL,NULL),(21,2,0,0,2,180,'Asteroid',NULL,'',47,0,0,0,5,0,0,3,0,0,2,NULL,0,NULL,NULL,NULL,NULL),(22,2,0,0,2,330,'Asteroid',NULL,'',38,0,0,0,4,0,0,5,0,0,5,NULL,0,NULL,NULL,NULL,NULL),(23,2,0,0,0,270,'Asteroid',NULL,'',56,0,0,0,5,0,0,2,0,0,4,NULL,0,NULL,NULL,NULL,NULL),(24,2,0,0,2,270,'Asteroid',NULL,'',35,0,0,0,1,0,0,2,0,0,2,NULL,0,NULL,NULL,NULL,NULL),(25,2,39,39,0,180,'Planet',NULL,'P-25',57,2,0,0,0,0,0,0,0,0,0,'2011-02-21 00:55:55',0,NULL,NULL,NULL,NULL),(26,2,0,0,0,0,'Asteroid',NULL,'',44,0,0,0,2,0,0,2,0,0,2,NULL,0,NULL,NULL,NULL,NULL);
/*!40000 ALTER TABLE `ss_objects` ENABLE KEYS */;
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
  `speed_up` tinyint(1) NOT NULL DEFAULT '0',
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
  `kind` tinyint(2) unsigned NOT NULL DEFAULT '0',
  `planet_id` int(11) NOT NULL,
  `x` tinyint(2) unsigned NOT NULL DEFAULT '0',
  `y` tinyint(2) unsigned NOT NULL DEFAULT '0',
  UNIQUE KEY `uniqueness` (`planet_id`,`x`,`y`),
  CONSTRAINT `tiles_ibfk_1` FOREIGN KEY (`planet_id`) REFERENCES `ss_objects` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tiles`
--

LOCK TABLES `tiles` WRITE;
/*!40000 ALTER TABLE `tiles` DISABLE KEYS */;
INSERT INTO `tiles` VALUES (4,2,0,3),(4,2,0,6),(4,2,0,7),(4,2,0,8),(6,2,0,26),(6,2,0,27),(6,2,0,28),(6,2,0,29),(6,2,0,30),(6,2,0,31),(6,2,0,32),(4,2,1,2),(4,2,1,3),(4,2,1,6),(4,2,1,7),(3,2,1,10),(3,2,1,11),(3,2,1,12),(6,2,1,27),(6,2,1,28),(6,2,1,30),(6,2,1,31),(4,2,2,3),(4,2,2,4),(4,2,2,5),(4,2,2,6),(4,2,2,8),(4,2,2,9),(3,2,2,11),(3,2,2,12),(3,2,2,13),(6,2,2,26),(6,2,2,27),(6,2,2,28),(12,2,2,36),(0,2,3,1),(4,2,3,3),(4,2,3,4),(4,2,3,5),(4,2,3,6),(4,2,3,7),(4,2,3,8),(4,2,3,9),(3,2,3,10),(3,2,3,11),(3,2,3,12),(6,2,3,26),(6,2,3,27),(6,2,3,28),(4,2,4,3),(4,2,4,4),(4,2,4,5),(4,2,4,6),(4,2,4,7),(4,2,4,8),(4,2,4,9),(3,2,4,11),(3,2,4,12),(3,2,4,13),(6,2,4,26),(6,2,4,28),(6,2,4,30),(3,2,5,0),(3,2,5,1),(4,2,5,3),(4,2,5,4),(4,2,5,5),(4,2,5,6),(4,2,5,7),(3,2,5,8),(3,2,5,9),(3,2,5,10),(3,2,5,11),(3,2,5,12),(3,2,5,13),(5,2,5,21),(6,2,5,26),(6,2,5,28),(6,2,5,29),(6,2,5,30),(3,2,6,0),(3,2,6,1),(4,2,6,2),(4,2,6,3),(4,2,6,4),(4,2,6,5),(4,2,6,6),(4,2,6,7),(4,2,6,8),(3,2,6,9),(3,2,6,10),(3,2,6,11),(3,2,6,12),(3,2,6,13),(3,2,6,14),(5,2,6,21),(5,2,6,22),(5,2,6,23),(5,2,6,24),(6,2,6,26),(6,2,6,27),(6,2,6,28),(6,2,6,29),(6,2,6,30),(6,2,6,31),(3,2,7,0),(3,2,7,1),(3,2,7,2),(3,2,7,3),(3,2,7,4),(3,2,7,5),(4,2,7,7),(3,2,7,8),(3,2,7,9),(3,2,7,10),(3,2,7,11),(3,2,7,13),(5,2,7,20),(5,2,7,21),(5,2,7,22),(6,2,7,26),(6,2,7,28),(6,2,7,29),(3,2,8,0),(3,2,8,1),(3,2,8,2),(3,2,8,3),(3,2,8,4),(0,2,8,5),(3,2,8,7),(3,2,8,8),(3,2,8,9),(3,2,8,10),(6,2,8,13),(5,2,8,20),(5,2,8,21),(5,2,8,24),(5,2,8,25),(6,2,8,29),(3,2,9,0),(3,2,9,1),(3,2,9,2),(3,2,9,3),(3,2,9,4),(3,2,9,7),(3,2,9,8),(3,2,9,9),(3,2,9,10),(6,2,9,12),(6,2,9,13),(5,2,9,20),(5,2,9,21),(5,2,9,22),(5,2,9,23),(5,2,9,24),(5,2,9,25),(3,2,10,0),(3,2,10,1),(3,2,10,2),(3,2,10,3),(3,2,10,4),(3,2,10,5),(3,2,10,6),(3,2,10,7),(6,2,10,8),(6,2,10,9),(6,2,10,10),(6,2,10,11),(6,2,10,12),(6,2,10,13),(5,2,10,19),(5,2,10,20),(5,2,10,21),(5,2,10,22),(5,2,10,23),(5,2,10,24),(5,2,10,25),(3,2,11,0),(3,2,11,1),(6,2,11,10),(6,2,11,11),(6,2,11,12),(6,2,11,13),(5,2,11,19),(5,2,11,21),(5,2,11,22),(5,2,11,23),(5,2,11,24),(5,2,11,25),(3,2,12,0),(3,2,12,1),(6,2,12,11),(6,2,12,12),(4,2,12,14),(4,2,12,15),(14,2,12,21),(3,2,13,0),(3,2,13,1),(0,2,13,8),(6,2,13,10),(6,2,13,11),(4,2,13,13),(4,2,13,14),(3,2,14,0),(3,2,14,1),(4,2,14,10),(4,2,14,11),(4,2,14,12),(4,2,14,13),(4,2,14,15),(4,2,14,16),(4,2,14,17),(4,2,14,18),(3,2,15,1),(3,2,15,2),(4,2,15,8),(4,2,15,9),(4,2,15,10),(4,2,15,11),(4,2,15,12),(4,2,15,13),(4,2,15,14),(4,2,15,15),(4,2,15,16),(4,2,15,38),(4,2,15,40),(3,2,16,1),(4,2,16,9),(4,2,16,10),(4,2,16,11),(4,2,16,12),(4,2,16,13),(4,2,16,14),(4,2,16,15),(4,2,16,38),(4,2,16,39),(4,2,16,40),(4,2,16,41),(4,2,17,9),(4,2,17,10),(4,2,17,11),(4,2,17,12),(4,2,17,13),(4,2,17,15),(4,2,17,16),(4,2,17,37),(4,2,17,38),(4,2,17,39),(4,2,17,41),(0,2,18,1),(4,2,18,9),(4,2,18,10),(4,2,18,11),(4,2,18,12),(4,2,18,13),(4,2,18,14),(4,2,18,38),(4,2,18,39),(2,2,19,25),(4,2,19,38),(4,2,19,39),(4,2,19,40),(4,2,19,41),(4,2,20,36),(4,2,20,37),(4,2,20,38),(4,2,20,39),(4,2,20,40),(4,2,20,41),(4,2,20,42),(4,2,21,35),(4,2,21,36),(4,2,21,38),(4,2,21,39),(4,2,21,40),(4,2,22,36),(4,2,22,37),(4,2,22,38),(4,2,22,39),(4,2,22,40),(4,2,22,41),(4,2,22,42),(3,2,23,23),(0,2,23,30),(4,2,23,36),(4,2,23,39),(4,2,23,40),(3,2,24,17),(3,2,24,19),(3,2,24,20),(3,2,24,22),(3,2,24,23),(3,2,24,25),(2,2,24,37),(4,2,24,39),(0,2,25,5),(3,2,25,16),(3,2,25,17),(3,2,25,18),(3,2,25,19),(3,2,25,20),(3,2,25,21),(3,2,25,22),(3,2,25,23),(3,2,25,24),(3,2,25,25),(5,2,25,35),(5,2,25,36),(4,2,25,39),(4,2,25,40),(1,2,26,1),(3,2,26,15),(3,2,26,16),(3,2,26,17),(3,2,26,18),(3,2,26,19),(3,2,26,20),(3,2,26,21),(3,2,26,22),(3,2,26,23),(3,2,26,24),(5,2,26,32),(5,2,26,34),(5,2,26,35),(5,2,26,36),(5,2,26,37),(3,2,27,15),(3,2,27,16),(3,2,27,17),(3,2,27,18),(3,2,27,19),(3,2,27,20),(3,2,27,21),(0,2,27,22),(5,2,27,29),(5,2,27,32),(5,2,27,33),(5,2,27,35),(5,2,27,36),(3,2,28,14),(3,2,28,15),(3,2,28,18),(3,2,28,20),(5,2,28,27),(5,2,28,28),(5,2,28,29),(5,2,28,30),(5,2,28,31),(5,2,28,32),(5,2,28,33),(5,2,28,34),(5,2,28,35),(5,2,28,36),(5,2,29,30),(5,2,29,31),(5,2,29,32),(5,2,29,33),(5,2,29,34),(5,2,29,35),(3,2,30,28),(3,2,30,29),(3,2,30,30),(3,2,30,31),(3,2,30,32),(5,2,30,33),(5,2,30,34),(5,2,30,35),(4,2,31,11),(4,2,31,12),(5,2,31,23),(5,2,31,27),(3,2,31,28),(3,2,31,29),(3,2,31,30),(3,2,31,31),(3,2,31,32),(14,2,31,33),(0,2,32,9),(4,2,32,11),(4,2,32,12),(5,2,32,23),(5,2,32,27),(3,2,32,28),(3,2,32,29),(3,2,32,30),(3,2,32,31),(3,2,32,32),(4,2,33,7),(4,2,33,8),(4,2,33,11),(4,2,33,12),(4,2,33,13),(4,2,33,14),(5,2,33,23),(5,2,33,24),(5,2,33,26),(5,2,33,27),(5,2,33,28),(3,2,33,29),(3,2,33,30),(3,2,33,31),(3,2,33,32),(4,2,34,6),(4,2,34,7),(4,2,34,8),(4,2,34,9),(4,2,34,10),(4,2,34,11),(4,2,34,12),(4,2,34,13),(4,2,34,14),(4,2,34,15),(5,2,34,21),(5,2,34,22),(5,2,34,23),(3,2,34,24),(5,2,34,25),(5,2,34,26),(5,2,34,27),(5,2,34,28),(5,2,34,29),(3,2,34,30),(3,2,34,31),(3,2,34,32),(3,2,34,33),(3,2,34,34),(3,2,34,35),(3,2,34,36),(4,2,35,6),(4,2,35,7),(4,2,35,8),(4,2,35,9),(4,2,35,10),(4,2,35,11),(4,2,35,12),(4,2,35,13),(4,2,35,15),(5,2,35,21),(5,2,35,22),(5,2,35,23),(5,2,35,24),(5,2,35,26),(5,2,35,27),(5,2,35,28),(3,2,35,29),(3,2,35,30),(3,2,35,31),(3,2,35,32),(3,2,35,33),(3,2,35,34),(3,2,35,35),(4,2,36,5),(4,2,36,6),(4,2,36,7),(4,2,36,8),(4,2,36,9),(4,2,36,10),(4,2,36,11),(4,2,36,12),(4,2,36,13),(4,2,36,14),(4,2,36,15),(4,2,36,16),(5,2,36,23),(5,2,36,24),(5,2,36,25),(5,2,36,26),(5,2,36,27),(5,2,36,28),(5,2,36,29),(3,2,36,30),(3,2,36,31),(3,2,36,32),(3,2,36,34),(3,2,36,35),(0,5,0,0),(5,5,0,3),(5,5,0,4),(5,5,0,5),(5,5,0,6),(5,5,0,7),(5,5,0,8),(5,5,0,9),(5,5,0,10),(5,5,0,11),(5,5,0,12),(5,5,0,13),(5,5,0,14),(5,5,0,26),(5,5,0,27),(5,5,0,28),(5,5,0,29),(5,5,1,3),(11,5,1,4),(5,5,1,11),(5,5,1,12),(5,5,1,13),(13,5,1,16),(4,5,1,19),(4,5,1,20),(4,5,1,21),(4,5,1,22),(5,5,1,26),(5,5,1,27),(5,5,1,28),(5,5,1,29),(5,5,2,2),(5,5,2,3),(5,5,2,10),(5,5,2,12),(5,5,2,13),(5,5,2,14),(5,5,2,15),(4,5,2,20),(4,5,2,21),(4,5,2,22),(4,5,2,23),(5,5,2,27),(5,5,2,28),(5,5,2,29),(0,5,3,1),(5,5,3,10),(5,5,3,11),(5,5,3,12),(5,5,3,13),(5,5,3,14),(4,5,3,20),(4,5,3,21),(4,5,3,22),(4,5,3,23),(4,5,3,24),(5,5,3,28),(5,5,3,29),(5,5,4,12),(5,5,4,13),(6,5,4,18),(4,5,4,21),(4,5,4,22),(4,5,4,23),(5,5,4,26),(5,5,4,27),(5,5,4,28),(6,5,5,8),(6,5,5,9),(6,5,5,18),(6,5,5,19),(4,5,5,22),(4,5,5,23),(4,5,5,24),(5,5,5,26),(5,5,5,27),(6,5,6,7),(6,5,6,8),(6,5,6,9),(6,5,6,11),(6,5,6,18),(6,5,6,19),(6,5,7,9),(6,5,7,10),(6,5,7,18),(12,5,7,23),(6,5,8,9),(6,5,8,10),(6,5,8,16),(6,5,8,17),(6,5,8,18),(3,5,9,3),(3,5,9,4),(6,5,9,9),(6,5,9,15),(6,5,9,16),(6,5,9,17),(3,5,10,0),(3,5,10,2),(3,5,10,3),(3,5,10,4),(8,5,10,5),(6,5,10,16),(6,5,10,17),(0,5,10,20),(3,5,11,0),(3,5,11,1),(3,5,11,2),(3,5,11,3),(3,5,12,0),(3,5,12,1),(3,5,12,2),(3,5,13,0),(3,5,13,1),(3,5,13,2),(3,5,13,4),(3,5,14,0),(3,5,14,1),(3,5,14,2),(3,5,14,3),(3,5,14,4),(3,5,15,0),(3,5,15,1),(3,5,15,2),(3,5,15,3),(3,5,15,4),(3,5,16,0),(3,5,16,1),(3,5,16,2),(3,5,16,3),(5,5,16,29),(3,5,17,0),(3,5,17,1),(3,5,17,2),(3,5,17,3),(3,5,17,4),(2,5,17,28),(3,5,18,0),(3,5,18,1),(3,5,18,2),(3,5,18,3),(3,5,18,4),(3,5,18,5),(0,5,18,23),(3,5,19,0),(3,5,19,1),(3,5,19,2),(3,5,19,3),(3,5,19,4),(3,5,19,5),(5,5,19,29),(3,5,20,0),(3,5,20,1),(3,5,20,2),(3,5,20,3),(3,5,20,4),(3,5,20,5),(5,5,20,28),(5,5,20,29),(3,5,21,0),(3,5,21,1),(3,5,21,2),(3,5,21,3),(3,5,21,4),(5,5,21,29),(3,5,22,0),(3,5,22,1),(3,5,22,2),(14,5,22,25),(5,5,22,29),(3,5,23,0),(3,5,23,1),(3,5,23,2),(3,5,23,3),(4,5,23,9),(5,5,23,29),(3,5,24,1),(3,5,24,2),(0,5,24,4),(4,5,24,7),(4,5,24,8),(4,5,24,9),(4,5,24,10),(4,5,24,11),(5,5,24,29),(4,5,25,7),(4,5,25,8),(4,5,25,9),(4,5,25,10),(5,5,25,27),(5,5,25,29),(4,5,26,6),(4,5,26,7),(4,5,26,8),(4,5,26,9),(4,5,26,10),(2,5,26,12),(6,5,26,22),(6,5,26,23),(5,5,26,27),(5,5,26,28),(5,5,26,29),(4,5,27,5),(4,5,27,6),(4,5,27,7),(4,5,27,8),(4,5,27,9),(4,5,27,10),(5,5,27,17),(5,5,27,18),(5,5,27,21),(5,5,27,22),(6,5,27,23),(6,5,27,24),(0,5,28,4),(4,5,28,6),(4,5,28,7),(4,5,28,8),(4,5,28,9),(4,5,28,10),(5,5,28,15),(5,5,28,16),(5,5,28,17),(5,5,28,18),(5,5,28,19),(5,5,28,21),(5,5,28,22),(6,5,28,23),(6,5,28,24),(5,5,28,25),(5,5,28,26),(5,5,28,27),(5,5,28,28),(4,5,29,7),(4,5,29,8),(4,5,29,9),(4,5,29,10),(4,5,29,11),(5,5,29,16),(5,5,29,17),(5,5,29,18),(5,5,29,19),(5,5,29,20),(5,5,29,21),(5,5,29,22),(6,5,29,23),(6,5,29,24),(6,5,29,25),(6,5,29,26),(5,5,29,27),(4,9,0,29),(4,9,0,30),(4,9,0,32),(2,9,1,22),(4,9,1,26),(4,9,1,29),(4,9,1,30),(4,9,1,31),(4,9,1,32),(4,9,2,6),(4,9,2,7),(4,9,2,8),(4,9,2,9),(10,9,2,16),(4,9,2,24),(4,9,2,25),(4,9,2,26),(4,9,2,27),(4,9,2,28),(4,9,2,29),(4,9,2,30),(4,9,2,31),(4,9,2,32),(4,9,3,6),(4,9,3,8),(4,9,3,9),(4,9,3,10),(0,9,3,11),(4,9,3,25),(4,9,3,26),(4,9,3,27),(4,9,3,28),(4,9,3,29),(4,9,3,30),(4,9,3,31),(3,9,4,5),(3,9,4,8),(4,9,4,10),(4,9,4,25),(4,9,4,26),(4,9,4,27),(4,9,4,28),(4,9,4,29),(4,9,4,30),(3,9,5,3),(3,9,5,5),(3,9,5,6),(3,9,5,7),(3,9,5,8),(4,9,5,9),(4,9,5,10),(4,9,5,11),(4,9,5,27),(4,9,5,29),(4,9,5,30),(3,9,6,3),(3,9,6,4),(3,9,6,5),(3,9,6,6),(3,9,6,7),(4,9,6,9),(4,9,6,10),(4,9,6,29),(3,9,7,4),(4,9,7,9),(4,9,7,10),(3,9,8,3),(3,9,8,4),(4,9,8,10),(10,9,8,11),(0,9,8,21),(3,9,9,3),(3,9,9,4),(3,9,10,3),(3,9,10,7),(5,9,10,21),(5,9,10,22),(3,9,11,0),(3,9,11,1),(3,9,11,2),(3,9,11,3),(3,9,11,4),(3,9,11,5),(3,9,11,6),(3,9,11,7),(5,9,11,10),(5,9,11,21),(5,9,11,22),(5,9,11,23),(5,9,11,24),(12,9,11,26),(3,9,12,2),(3,9,12,3),(5,9,12,8),(5,9,12,9),(5,9,12,10),(5,9,12,11),(5,9,12,12),(5,9,12,13),(5,9,12,21),(5,9,12,22),(3,9,13,0),(3,9,13,1),(3,9,13,2),(3,9,13,3),(0,9,13,7),(5,9,13,9),(5,9,13,10),(5,9,13,11),(5,9,13,12),(5,9,13,13),(5,9,13,14),(5,9,13,22),(5,9,13,23),(3,9,14,1),(5,9,14,9),(5,9,14,10),(5,9,14,11),(5,9,14,16),(5,9,14,17),(5,9,14,18),(5,9,14,19),(5,9,14,20),(5,9,14,21),(5,9,14,22),(5,9,14,23),(5,9,14,24),(5,9,15,9),(5,9,15,11),(5,9,15,16),(5,9,15,17),(5,9,15,18),(5,9,15,19),(5,9,15,23),(5,9,15,24),(5,9,15,25),(5,9,16,9),(5,9,16,16),(5,9,16,17),(5,9,16,18),(5,9,16,19),(5,9,16,23),(6,9,16,25),(5,9,17,16),(5,9,17,17),(5,9,17,18),(5,9,17,19),(6,9,17,25),(6,9,17,26),(6,9,17,27),(3,9,17,28),(3,9,17,29),(9,9,17,30),(1,9,18,8),(5,9,18,15),(5,9,18,16),(5,9,18,17),(5,9,18,18),(5,9,18,19),(5,9,18,20),(6,9,18,24),(6,9,18,25),(6,9,18,26),(6,9,18,27),(3,9,18,28),(3,9,18,29),(5,9,19,12),(5,9,19,13),(5,9,19,14),(5,9,19,15),(5,9,19,16),(5,9,19,17),(5,9,19,18),(5,9,19,19),(5,9,19,24),(6,9,19,25),(6,9,19,26),(3,9,19,28),(3,9,19,29),(2,9,20,12),(5,9,20,14),(5,9,20,15),(5,9,20,16),(5,9,20,17),(5,9,20,18),(5,9,20,19),(5,9,20,20),(5,9,20,21),(5,9,20,22),(5,9,20,23),(5,9,20,24),(5,9,20,25),(5,9,20,27),(5,9,20,28),(3,9,20,29),(5,9,21,18),(3,9,21,19),(3,9,21,20),(3,9,21,21),(5,9,21,22),(5,9,21,23),(5,9,21,24),(5,9,21,25),(5,9,21,26),(5,9,21,27),(5,9,21,28),(3,9,21,29),(3,9,21,30),(3,9,21,31),(2,9,22,17),(3,9,22,19),(3,9,22,20),(3,9,22,21),(3,9,22,22),(3,9,22,23),(5,9,22,24),(5,9,22,25),(5,9,22,26),(5,9,22,27),(3,9,22,28),(3,9,22,29),(3,9,22,30),(3,9,22,31),(3,9,22,32),(4,9,23,19),(4,9,23,20),(3,9,23,21),(12,9,23,22),(3,9,23,29),(3,9,23,31),(0,9,24,2),(3,9,24,10),(3,9,24,12),(3,9,24,13),(4,9,24,18),(4,9,24,19),(4,9,24,20),(4,9,24,21),(3,9,25,10),(3,9,25,12),(3,9,25,14),(3,9,25,15),(4,9,25,18),(4,9,25,19),(4,9,25,20),(4,9,25,21),(4,9,26,1),(4,9,26,3),(3,9,26,10),(3,9,26,11),(3,9,26,12),(3,9,26,13),(3,9,26,14),(2,9,26,16),(4,9,26,20),(4,9,26,21),(4,9,27,0),(4,9,27,1),(4,9,27,2),(4,9,27,3),(3,9,27,10),(3,9,27,11),(3,9,27,12),(6,9,27,13),(6,9,27,14),(6,9,27,15),(4,9,27,19),(4,9,27,20),(4,9,27,21),(6,9,27,30),(6,9,27,31),(4,9,28,0),(4,9,28,1),(4,9,28,2),(4,9,28,3),(3,9,28,11),(3,9,28,12),(6,9,28,13),(6,9,28,14),(4,9,28,20),(4,9,28,21),(6,9,28,29),(6,9,28,30),(6,9,28,31),(4,9,29,0),(4,9,29,1),(4,9,29,2),(4,9,29,3),(6,9,29,11),(6,9,29,12),(6,9,29,13),(6,9,29,14),(3,9,29,19),(3,9,29,20),(3,9,29,21),(3,9,29,22),(3,9,29,24),(3,9,29,25),(3,9,29,26),(3,9,29,27),(6,9,29,29),(6,9,29,30),(4,9,30,0),(4,9,30,2),(4,9,30,3),(6,9,30,11),(3,9,30,18),(3,9,30,19),(3,9,30,20),(3,9,30,21),(3,9,30,22),(3,9,30,23),(3,9,30,24),(3,9,30,25),(3,9,30,26),(6,9,30,29),(6,9,30,30),(6,9,30,31),(4,25,0,0),(4,25,0,1),(4,25,0,2),(4,25,0,3),(4,25,0,4),(4,25,0,5),(4,25,0,6),(4,25,0,7),(4,25,0,8),(4,25,0,9),(4,25,0,10),(4,25,0,11),(4,25,0,12),(4,25,0,13),(4,25,0,14),(4,25,0,15),(4,25,0,16),(4,25,0,17),(4,25,0,18),(4,25,0,20),(4,25,1,0),(4,25,1,1),(4,25,1,2),(4,25,1,3),(4,25,1,4),(4,25,1,5),(4,25,1,8),(4,25,1,9),(4,25,1,10),(4,25,1,11),(4,25,1,16),(4,25,1,17),(4,25,1,18),(4,25,1,19),(4,25,1,20),(4,25,1,21),(5,25,1,27),(0,25,1,28),(4,25,2,0),(4,25,2,1),(4,25,2,2),(4,25,2,3),(4,25,2,4),(4,25,2,7),(4,25,2,8),(4,25,2,10),(4,25,2,11),(4,25,2,16),(4,25,2,17),(4,25,2,18),(4,25,2,19),(4,25,2,20),(5,25,2,27),(5,25,2,36),(5,25,2,38),(4,25,3,0),(4,25,3,1),(4,25,3,2),(4,25,3,3),(4,25,3,4),(0,25,3,5),(4,25,3,16),(4,25,3,17),(4,25,3,18),(4,25,3,20),(5,25,3,25),(5,25,3,26),(5,25,3,27),(5,25,3,28),(0,25,3,34),(5,25,3,36),(5,25,3,37),(5,25,3,38),(4,25,4,0),(4,25,4,2),(4,25,4,3),(4,25,4,4),(4,25,4,16),(4,25,4,17),(4,25,4,18),(4,25,4,19),(5,25,4,25),(5,25,4,27),(5,25,4,28),(5,25,4,29),(5,25,4,31),(5,25,4,32),(5,25,4,36),(5,25,4,37),(4,25,5,1),(4,25,5,2),(4,25,5,3),(4,25,5,4),(4,25,5,5),(4,25,5,6),(4,25,5,7),(4,25,5,14),(4,25,5,15),(4,25,5,16),(4,25,5,17),(4,25,5,18),(5,25,5,23),(5,25,5,24),(5,25,5,25),(5,25,5,26),(5,25,5,27),(5,25,5,28),(5,25,5,29),(5,25,5,30),(5,25,5,31),(5,25,5,32),(5,25,5,33),(5,25,5,34),(5,25,5,35),(5,25,5,36),(5,25,5,37),(5,25,5,38),(4,25,6,0),(4,25,6,1),(4,25,6,2),(4,25,6,3),(4,25,6,4),(4,25,6,5),(4,25,6,6),(4,25,6,7),(6,25,6,11),(6,25,6,14),(4,25,6,16),(4,25,6,17),(5,25,6,25),(5,25,6,26),(5,25,6,27),(5,25,6,28),(5,25,6,30),(5,25,6,31),(5,25,6,34),(5,25,6,35),(5,25,6,36),(5,25,6,37),(4,25,7,2),(4,25,7,5),(4,25,7,6),(6,25,7,11),(6,25,7,14),(4,25,7,15),(4,25,7,16),(4,25,7,17),(0,25,7,19),(5,25,7,24),(5,25,7,25),(5,25,7,26),(5,25,7,27),(5,25,7,28),(5,25,7,29),(5,25,7,30),(5,25,7,31),(5,25,7,32),(5,25,7,33),(5,25,7,34),(5,25,7,35),(5,25,7,36),(5,25,7,37),(4,25,8,5),(6,25,8,10),(6,25,8,11),(6,25,8,12),(6,25,8,13),(6,25,8,14),(6,25,8,15),(4,25,8,17),(5,25,8,25),(5,25,8,26),(6,25,8,27),(6,25,8,28),(5,25,8,29),(5,25,8,31),(0,25,8,33),(5,25,8,35),(5,25,8,36),(4,25,9,5),(2,25,9,8),(6,25,9,11),(6,25,9,12),(6,25,9,13),(6,25,9,15),(6,25,9,16),(5,25,9,26),(6,25,9,27),(6,25,9,29),(6,25,9,30),(5,25,9,35),(6,25,10,11),(6,25,10,12),(6,25,10,13),(6,25,10,14),(6,25,10,15),(6,25,10,16),(6,25,10,17),(6,25,10,27),(6,25,10,28),(6,25,10,29),(6,25,10,30),(6,25,10,31),(5,25,10,35),(3,25,11,2),(6,25,11,14),(6,25,11,15),(6,25,11,17),(2,25,11,24),(6,25,11,26),(6,25,11,27),(6,25,11,28),(6,25,11,29),(5,25,11,33),(5,25,11,34),(5,25,11,35),(5,25,11,36),(3,25,12,0),(3,25,12,1),(3,25,12,2),(3,25,12,3),(6,25,12,26),(6,25,12,27),(6,25,12,28),(6,25,12,29),(5,25,12,33),(5,25,12,35),(5,25,12,36),(3,25,13,0),(3,25,13,1),(3,25,13,2),(3,25,13,3),(1,25,13,17),(4,25,13,19),(4,25,13,20),(4,25,13,21),(6,25,13,27),(6,25,13,28),(6,25,13,29),(5,25,13,32),(5,25,13,35),(3,25,14,0),(3,25,14,1),(3,25,14,2),(3,25,14,3),(4,25,14,19),(8,25,14,20),(6,25,14,26),(6,25,14,27),(6,25,14,28),(2,25,14,29),(5,25,14,32),(5,25,14,33),(5,25,14,34),(5,25,14,35),(5,25,14,36),(5,25,14,37),(5,25,14,38),(3,25,15,0),(3,25,15,1),(3,25,15,2),(3,25,15,4),(3,25,15,5),(4,25,15,18),(4,25,15,19),(6,25,15,27),(5,25,15,31),(5,25,15,32),(5,25,15,33),(5,25,15,34),(5,25,15,35),(5,25,15,36),(5,25,15,37),(5,25,15,38),(3,25,16,0),(3,25,16,1),(3,25,16,2),(3,25,16,3),(3,25,16,4),(13,25,16,16),(4,25,16,18),(4,25,16,19),(5,25,16,32),(5,25,16,33),(5,25,16,34),(5,25,16,35),(5,25,16,36),(3,25,17,0),(0,25,17,1),(3,25,17,3),(4,25,17,18),(4,25,17,19),(4,25,17,20),(4,25,17,21),(13,25,17,23),(5,25,17,32),(3,25,18,0),(3,25,18,3),(3,25,18,4),(3,25,18,5),(4,25,18,18),(4,25,18,19),(4,25,18,20),(4,25,18,21),(4,25,18,22),(5,25,18,32),(3,25,19,0),(3,25,19,1),(3,25,19,2),(4,25,19,18),(4,25,19,19),(4,25,19,20),(4,25,19,21),(4,25,19,22),(3,25,20,0),(3,25,20,1),(3,25,20,2),(4,25,20,18),(4,25,20,19),(4,25,20,20),(4,25,20,21),(4,25,20,22),(3,25,21,2),(3,25,21,3),(4,25,21,18),(4,25,21,19),(4,25,21,20),(4,25,21,21),(4,25,21,22),(3,25,22,2),(4,25,22,18),(4,25,22,19),(4,25,22,20),(4,25,22,21),(4,25,22,22),(12,25,23,0),(4,25,23,18),(4,25,23,19),(4,25,23,20),(4,25,23,21),(5,25,23,30),(5,25,23,31),(5,25,23,32),(5,25,23,33),(4,25,24,18),(4,25,24,19),(4,25,24,20),(4,25,24,21),(4,25,24,22),(5,25,24,29),(5,25,24,30),(5,25,24,31),(5,25,24,32),(5,25,24,33),(3,25,25,16),(3,25,25,17),(3,25,25,18),(3,25,25,19),(4,25,25,20),(4,25,25,21),(3,25,25,22),(5,25,25,29),(5,25,25,30),(5,25,25,31),(5,25,25,32),(5,25,25,33),(5,25,25,35),(0,25,26,14),(3,25,26,17),(3,25,26,18),(3,25,26,19),(4,25,26,20),(3,25,26,22),(3,25,26,23),(3,25,26,24),(5,25,26,27),(5,25,26,28),(5,25,26,29),(5,25,26,30),(5,25,26,31),(5,25,26,33),(5,25,26,35),(3,25,27,16),(3,25,27,17),(3,25,27,18),(3,25,27,19),(3,25,27,20),(3,25,27,21),(3,25,27,22),(3,25,27,24),(3,25,27,25),(3,25,27,26),(5,25,27,28),(5,25,27,29),(5,25,27,30),(5,25,27,31),(5,25,27,32),(5,25,27,33),(5,25,27,34),(5,25,27,35),(3,25,28,14),(3,25,28,15),(3,25,28,16),(6,25,28,17),(3,25,28,18),(3,25,28,19),(3,25,28,20),(3,25,28,21),(3,25,28,22),(3,25,28,23),(5,25,28,32),(5,25,28,33),(5,25,29,4),(6,25,29,14),(6,25,29,15),(6,25,29,17),(3,25,29,18),(3,25,29,19),(3,25,29,20),(3,25,29,22),(5,25,29,33),(5,25,30,4),(5,25,30,5),(6,25,30,14),(6,25,30,15),(6,25,30,16),(6,25,30,17),(3,25,30,18),(3,25,30,19),(3,25,30,20),(3,25,30,22),(5,25,31,2),(5,25,31,4),(5,25,31,5),(5,25,31,6),(6,25,31,14),(6,25,31,15),(6,25,31,16),(6,25,31,17),(3,25,31,18),(3,25,31,19),(3,25,31,20),(5,25,32,2),(5,25,32,3),(5,25,32,4),(5,25,32,5),(5,25,32,6),(5,25,32,7),(5,25,32,8),(1,25,32,10),(6,25,32,12),(6,25,32,13),(6,25,32,14),(6,25,32,15),(6,25,32,16),(6,25,32,17),(6,25,32,18),(3,25,32,19),(3,25,32,20),(3,25,32,21),(3,25,32,22),(5,25,33,3),(5,25,33,4),(5,25,33,5),(5,25,33,6),(5,25,33,7),(5,25,33,8),(5,25,33,9),(6,25,33,12),(6,25,33,14),(6,25,33,16),(6,25,33,17),(3,25,33,18),(3,25,33,19),(3,25,33,20),(3,25,33,21),(3,25,33,22),(3,25,33,23),(3,25,33,24),(2,25,33,29),(5,25,34,4),(5,25,34,5),(5,25,34,6),(5,25,34,8),(6,25,34,13),(6,25,34,14),(6,25,34,15),(6,25,34,16),(6,25,34,17),(3,25,34,18),(3,25,34,19),(3,25,34,20),(3,25,34,22),(3,25,34,24),(3,25,34,25),(5,25,35,5),(5,25,35,6),(5,25,35,7),(5,25,35,8),(5,25,35,9),(6,25,35,12),(6,25,35,13),(6,25,35,14),(6,25,35,15),(6,25,35,16),(6,25,35,17),(3,25,35,18),(3,25,35,19),(3,25,35,20),(3,25,35,21),(3,25,35,22),(3,25,35,23),(5,25,36,6),(6,25,36,13),(6,25,36,14),(6,25,36,15),(6,25,36,16),(6,25,36,17),(3,25,36,18),(3,25,36,19),(3,25,36,20),(3,25,36,21),(3,25,36,22),(3,25,36,23),(5,25,37,5),(5,25,37,6),(6,25,37,12),(6,25,37,14),(6,25,37,15),(6,25,37,16),(6,25,37,17),(6,25,37,18),(3,25,37,19),(3,25,37,20),(3,25,37,21),(3,25,37,22),(6,25,38,12),(6,25,38,13),(6,25,38,14),(6,25,38,15),(6,25,38,18),(3,25,38,20),(3,25,38,21);
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
  `metal` float NOT NULL DEFAULT '0',
  `energy` float NOT NULL DEFAULT '0',
  `zetium` float NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `location` (`player_id`,`location_id`,`location_type`),
  KEY `location_and_player` (`location_type`,`location_id`,`location_x`,`location_y`,`player_id`),
  KEY `index_units_on_route_id` (`route_id`),
  KEY `type` (`player_id`,`type`),
  KEY `foreign_key` (`galaxy_id`),
  CONSTRAINT `units_ibfk_1` FOREIGN KEY (`player_id`) REFERENCES `players` (`id`) ON DELETE SET NULL,
  CONSTRAINT `units_ibfk_2` FOREIGN KEY (`galaxy_id`) REFERENCES `galaxies` (`id`) ON DELETE CASCADE,
  CONSTRAINT `units_ibfk_3` FOREIGN KEY (`route_id`) REFERENCES `routes` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=1162 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `units`
--

LOCK TABLES `units` WRITE;
/*!40000 ALTER TABLE `units` DISABLE KEYS */;
INSERT INTO `units` VALUES (1,2812,1,1,1,NULL,NULL,NULL,NULL,0,0,'Dirac',0,2,120,NULL,1,0,0,0,0,0,0),(2,2812,1,1,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,2,120,NULL,1,0,0,0,0,0,0),(3,2812,1,1,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,2,120,NULL,1,0,0,0,0,0,0),(4,2812,1,1,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,2,120,NULL,1,0,0,0,0,0,0),(5,2812,1,1,1,NULL,NULL,NULL,NULL,0,0,'Dirac',0,2,120,NULL,1,0,0,0,0,0,0),(6,2812,1,1,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,2,120,NULL,1,0,0,0,0,0,0),(7,2812,1,1,1,NULL,NULL,NULL,NULL,0,0,'Dirac',0,2,120,NULL,1,0,0,0,0,0,0),(8,2812,1,1,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,2,120,NULL,1,0,0,0,0,0,0),(9,2812,1,1,1,NULL,NULL,NULL,NULL,0,0,'Dirac',0,1,135,NULL,1,0,0,0,0,0,0),(10,2812,1,1,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,1,135,NULL,1,0,0,0,0,0,0),(11,2812,1,1,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,1,135,NULL,1,0,0,0,0,0,0),(12,2812,1,1,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,1,135,NULL,1,0,0,0,0,0,0),(13,2812,1,1,1,NULL,NULL,NULL,NULL,0,0,'Dirac',0,1,135,NULL,1,0,0,0,0,0,0),(14,2812,1,1,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,1,135,NULL,1,0,0,0,0,0,0),(15,2812,1,1,1,NULL,NULL,NULL,NULL,0,0,'Dirac',0,1,135,NULL,1,0,0,0,0,0,0),(16,2812,1,1,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,1,135,NULL,1,0,0,0,0,0,0),(17,90,1,1,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(18,90,1,1,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(19,90,1,1,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(20,90,1,1,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(21,125,1,1,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(22,125,1,1,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(23,125,1,1,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(24,125,1,1,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(25,125,1,1,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(26,125,1,1,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(27,125,1,1,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(28,90,1,2,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(29,90,1,2,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(30,90,1,2,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(31,90,1,2,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(32,125,1,2,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(33,125,1,2,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(34,125,1,2,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(35,125,1,2,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(36,125,1,2,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(37,125,1,2,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(38,125,1,2,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(39,125,1,2,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(40,90,1,3,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(41,90,1,3,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(42,90,1,3,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(43,125,1,3,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(44,125,1,3,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(45,125,1,3,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(46,125,1,3,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(47,125,1,3,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(48,125,1,3,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(49,125,1,3,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(50,125,1,3,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(51,90,1,4,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(52,90,1,4,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(53,125,1,4,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(54,125,1,4,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(55,125,1,4,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(56,125,1,4,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(57,125,1,4,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(58,125,1,4,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(59,125,1,4,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(60,125,1,4,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(61,125,1,4,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(62,125,1,4,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(63,90,1,5,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(64,90,1,5,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(65,90,1,5,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(66,125,1,5,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(67,125,1,5,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(68,125,1,5,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(69,125,1,5,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(70,125,1,5,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(71,125,1,5,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(72,125,1,5,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(73,125,1,5,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(74,125,1,5,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(75,90,1,6,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(76,90,1,6,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(77,90,1,6,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(78,90,1,6,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(79,125,1,6,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(80,125,1,6,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(81,125,1,6,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(82,125,1,6,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(83,125,1,6,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(84,125,1,6,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(85,125,1,6,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(86,90,1,7,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(87,90,1,7,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(88,90,1,7,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(89,90,1,7,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(90,125,1,7,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(91,125,1,7,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(92,125,1,7,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(93,125,1,7,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(94,125,1,7,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(95,125,1,7,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(96,125,1,7,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(97,125,1,7,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(98,900,1,8,4,NULL,NULL,NULL,NULL,0,0,'Gnawer',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(99,500,1,8,4,NULL,NULL,NULL,NULL,0,0,'Spudder',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(100,500,1,8,4,NULL,NULL,NULL,NULL,0,0,'Spudder',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(101,500,1,8,4,NULL,NULL,NULL,NULL,0,0,'Spudder',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(102,500,1,8,4,NULL,NULL,NULL,NULL,0,0,'Spudder',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(103,500,1,8,4,NULL,NULL,NULL,NULL,0,0,'Spudder',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(104,90,1,8,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(105,90,1,8,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(106,125,1,8,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(107,125,1,8,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(108,125,1,8,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(109,90,1,8,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(110,90,1,8,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(111,90,1,8,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(112,90,1,8,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(113,90,1,8,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(114,90,1,8,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(115,125,1,8,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(116,125,1,8,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(117,125,1,8,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(118,125,1,8,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(119,125,1,8,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(120,125,1,8,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(121,125,1,8,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(122,125,1,8,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(123,125,1,8,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(124,500,1,9,4,NULL,NULL,NULL,NULL,0,0,'Spudder',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(125,500,1,9,4,NULL,NULL,NULL,NULL,0,0,'Spudder',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(126,90,1,9,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(127,90,1,9,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(128,125,1,9,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(129,125,1,9,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(130,125,1,9,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(131,90,1,9,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(132,90,1,9,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(133,90,1,9,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(134,90,1,9,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(135,125,1,9,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(136,125,1,9,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(137,125,1,9,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(138,125,1,9,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(139,125,1,9,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(140,125,1,9,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(141,125,1,9,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(142,500,1,10,4,NULL,NULL,NULL,NULL,0,0,'Spudder',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(143,500,1,10,4,NULL,NULL,NULL,NULL,0,0,'Spudder',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(144,90,1,10,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(145,90,1,10,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(146,125,1,10,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(147,125,1,10,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(148,125,1,10,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(149,90,1,10,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(150,90,1,10,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(151,90,1,10,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(152,90,1,10,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(153,90,1,10,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(154,90,1,10,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(155,125,1,10,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(156,125,1,10,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(157,125,1,10,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(158,125,1,10,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(159,125,1,10,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(160,125,1,10,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(161,125,1,10,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(162,125,1,10,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(163,900,1,11,4,NULL,NULL,NULL,NULL,0,0,'Gnawer',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(164,900,1,11,4,NULL,NULL,NULL,NULL,0,0,'Gnawer',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(165,900,1,11,4,NULL,NULL,NULL,NULL,0,0,'Gnawer',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(166,900,1,11,4,NULL,NULL,NULL,NULL,0,0,'Gnawer',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(167,500,1,11,4,NULL,NULL,NULL,NULL,0,0,'Spudder',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(168,500,1,11,4,NULL,NULL,NULL,NULL,0,0,'Spudder',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(169,500,1,11,4,NULL,NULL,NULL,NULL,0,0,'Spudder',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(170,500,1,11,4,NULL,NULL,NULL,NULL,0,0,'Spudder',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(171,90,1,11,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(172,90,1,11,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(173,125,1,11,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(174,125,1,11,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(175,90,1,11,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(176,90,1,11,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(177,90,1,11,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(178,90,1,11,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(179,90,1,11,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(180,125,1,11,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(181,125,1,11,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(182,125,1,11,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(183,125,1,11,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(184,125,1,11,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(185,125,1,11,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(186,125,1,11,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(187,125,1,11,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(188,125,1,11,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(189,900,1,12,4,NULL,NULL,NULL,NULL,0,0,'Gnawer',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(190,900,1,12,4,NULL,NULL,NULL,NULL,0,0,'Gnawer',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(191,900,1,12,4,NULL,NULL,NULL,NULL,0,0,'Gnawer',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(192,900,1,12,4,NULL,NULL,NULL,NULL,0,0,'Gnawer',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(193,500,1,12,4,NULL,NULL,NULL,NULL,0,0,'Spudder',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(194,500,1,12,4,NULL,NULL,NULL,NULL,0,0,'Spudder',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(195,500,1,12,4,NULL,NULL,NULL,NULL,0,0,'Spudder',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(196,500,1,12,4,NULL,NULL,NULL,NULL,0,0,'Spudder',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(197,90,1,12,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(198,125,1,12,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(199,125,1,12,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(200,125,1,12,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(201,90,1,12,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(202,90,1,12,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(203,90,1,12,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(204,90,1,12,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(205,90,1,12,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(206,125,1,12,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(207,125,1,12,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(208,125,1,12,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(209,125,1,12,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(210,125,1,12,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(211,125,1,12,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(212,125,1,12,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(213,125,1,12,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(214,125,1,12,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(215,900,1,13,4,NULL,NULL,NULL,NULL,0,0,'Gnawer',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(216,900,1,13,4,NULL,NULL,NULL,NULL,0,0,'Gnawer',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(217,900,1,13,4,NULL,NULL,NULL,NULL,0,0,'Gnawer',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(218,500,1,13,4,NULL,NULL,NULL,NULL,0,0,'Spudder',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(219,500,1,13,4,NULL,NULL,NULL,NULL,0,0,'Spudder',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(220,500,1,13,4,NULL,NULL,NULL,NULL,0,0,'Spudder',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(221,500,1,13,4,NULL,NULL,NULL,NULL,0,0,'Spudder',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(222,500,1,13,4,NULL,NULL,NULL,NULL,0,0,'Spudder',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(223,500,1,13,4,NULL,NULL,NULL,NULL,0,0,'Spudder',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(224,90,1,13,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(225,90,1,13,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(226,125,1,13,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(227,125,1,13,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(228,125,1,13,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(229,90,1,13,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(230,90,1,13,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(231,90,1,13,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(232,90,1,13,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(233,90,1,13,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(234,125,1,13,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(235,125,1,13,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(236,125,1,13,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(237,125,1,13,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(238,125,1,13,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(239,125,1,13,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(240,125,1,13,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(241,125,1,13,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(242,900,1,14,4,NULL,NULL,NULL,NULL,0,0,'Gnawer',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(243,500,1,14,4,NULL,NULL,NULL,NULL,0,0,'Spudder',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(244,500,1,14,4,NULL,NULL,NULL,NULL,0,0,'Spudder',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(245,500,1,14,4,NULL,NULL,NULL,NULL,0,0,'Spudder',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(246,500,1,14,4,NULL,NULL,NULL,NULL,0,0,'Spudder',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(247,90,1,14,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(248,90,1,14,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(249,125,1,14,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(250,125,1,14,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(251,90,1,14,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(252,90,1,14,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(253,90,1,14,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(254,90,1,14,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(255,90,1,14,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(256,90,1,14,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(257,90,1,14,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(258,125,1,14,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(259,125,1,14,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(260,125,1,14,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(261,125,1,14,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(262,125,1,14,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(263,125,1,14,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(264,125,1,14,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(265,125,1,14,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(266,900,1,15,4,NULL,NULL,NULL,NULL,0,0,'Gnawer',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(267,500,1,15,4,NULL,NULL,NULL,NULL,0,0,'Spudder',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(268,500,1,15,4,NULL,NULL,NULL,NULL,0,0,'Spudder',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(269,500,1,15,4,NULL,NULL,NULL,NULL,0,0,'Spudder',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(270,500,1,15,4,NULL,NULL,NULL,NULL,0,0,'Spudder',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(271,500,1,15,4,NULL,NULL,NULL,NULL,0,0,'Spudder',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(272,90,1,15,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(273,90,1,15,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(274,125,1,15,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(275,125,1,15,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(276,125,1,15,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(277,125,1,15,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(278,90,1,15,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(279,90,1,15,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(280,90,1,15,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(281,90,1,15,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(282,125,1,15,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(283,125,1,15,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(284,125,1,15,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(285,125,1,15,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(286,125,1,15,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(287,125,1,15,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(288,125,1,15,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(289,125,1,15,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(290,90,1,16,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(291,90,1,16,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(292,125,1,16,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(293,125,1,16,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(294,90,1,16,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(295,90,1,16,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(296,90,1,16,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(297,90,1,16,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(298,90,1,16,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(299,125,1,16,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(300,125,1,16,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(301,125,1,16,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(302,125,1,16,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(303,125,1,16,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(304,125,1,16,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(305,125,1,16,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(306,125,1,16,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(307,125,1,16,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(308,500,1,17,4,NULL,NULL,NULL,NULL,0,0,'Spudder',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(309,90,1,17,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(310,90,1,17,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(311,125,1,17,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(312,125,1,17,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(313,90,1,17,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(314,90,1,17,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(315,90,1,17,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(316,90,1,17,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(317,90,1,17,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(318,90,1,17,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(319,125,1,17,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(320,125,1,17,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(321,125,1,17,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(322,125,1,17,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(323,125,1,17,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(324,125,1,17,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(325,125,1,17,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(326,125,1,17,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(327,90,1,18,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(328,90,1,18,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(329,125,1,18,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(330,125,1,18,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(331,90,1,18,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(332,90,1,18,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(333,90,1,18,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(334,90,1,18,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(335,90,1,18,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(336,90,1,18,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(337,125,1,18,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(338,125,1,18,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(339,125,1,18,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(340,125,1,18,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(341,125,1,18,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(342,125,1,18,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(343,125,1,18,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(344,125,1,18,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(345,125,1,19,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(346,125,1,19,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(347,125,1,19,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(348,125,1,19,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(349,125,1,19,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(350,125,1,19,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(351,125,1,19,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(352,125,1,19,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(353,125,1,19,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(354,125,1,20,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(355,125,1,20,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(356,125,1,20,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(357,125,1,20,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(358,125,1,20,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(359,125,1,20,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(360,125,1,20,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(361,125,1,20,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(362,125,1,21,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(363,125,1,21,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(364,125,1,21,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(365,125,1,21,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(366,125,1,21,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(367,125,1,21,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(368,125,1,21,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(369,125,1,22,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(370,125,1,22,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(371,125,1,22,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(372,125,1,22,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(373,125,1,22,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(374,125,1,22,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(375,2812,1,1,1,NULL,NULL,NULL,NULL,0,0,'Dirac',0,2,210,NULL,1,0,0,0,0,0,0),(376,2812,1,1,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,2,210,NULL,1,0,0,0,0,0,0),(377,2812,1,1,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,2,210,NULL,1,0,0,0,0,0,0),(378,2812,1,1,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,2,210,NULL,1,0,0,0,0,0,0),(379,2812,1,1,1,NULL,NULL,NULL,NULL,0,0,'Dirac',0,2,210,NULL,1,0,0,0,0,0,0),(380,2812,1,1,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,2,210,NULL,1,0,0,0,0,0,0),(381,2812,1,1,1,NULL,NULL,NULL,NULL,0,0,'Dirac',0,2,210,NULL,1,0,0,0,0,0,0),(382,2812,1,1,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,2,210,NULL,1,0,0,0,0,0,0),(383,2812,1,1,1,NULL,NULL,NULL,NULL,0,0,'Dirac',0,1,180,NULL,1,0,0,0,0,0,0),(384,2812,1,1,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,1,180,NULL,1,0,0,0,0,0,0),(385,2812,1,1,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,1,180,NULL,1,0,0,0,0,0,0),(386,2812,1,1,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,1,180,NULL,1,0,0,0,0,0,0),(387,2812,1,1,1,NULL,NULL,NULL,NULL,0,0,'Dirac',0,1,180,NULL,1,0,0,0,0,0,0),(388,2812,1,1,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,1,180,NULL,1,0,0,0,0,0,0),(389,2812,1,1,1,NULL,NULL,NULL,NULL,0,0,'Dirac',0,1,180,NULL,1,0,0,0,0,0,0),(390,2812,1,1,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,1,180,NULL,1,0,0,0,0,0,0),(391,90,1,23,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(392,125,1,23,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(393,125,1,23,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(394,125,1,23,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(395,125,1,23,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(396,125,1,23,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(397,125,1,23,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(398,125,1,23,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(399,90,1,24,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(400,90,1,24,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(401,125,1,24,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(402,125,1,24,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(403,125,1,24,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(404,125,1,24,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(405,90,1,24,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(406,90,1,24,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(407,125,1,24,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(408,125,1,24,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(409,90,1,24,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(410,125,1,24,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(411,125,1,24,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(412,125,1,24,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(413,125,1,24,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(414,125,1,24,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(415,125,1,24,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(416,125,1,24,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(417,125,1,25,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(418,125,1,25,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(419,125,1,25,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(420,125,1,25,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(421,125,1,25,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(422,125,1,25,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(423,90,1,26,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(424,125,1,26,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(425,125,1,26,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(426,125,1,26,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(427,125,1,26,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(428,125,1,26,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(429,125,1,26,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(430,125,1,26,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(431,125,1,27,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(432,125,1,27,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(433,125,1,27,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(434,125,1,27,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(435,125,1,27,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(436,125,1,27,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(437,125,1,28,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(438,125,1,28,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(439,125,1,28,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(440,125,1,28,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(441,125,1,28,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(442,125,1,28,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(443,90,1,29,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(444,90,1,29,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(445,125,1,29,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(446,125,1,29,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(447,125,1,29,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(448,125,1,29,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(449,90,1,29,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(450,90,1,29,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(451,125,1,29,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(452,125,1,29,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(453,90,1,29,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(454,125,1,29,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(455,125,1,29,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(456,125,1,29,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(457,125,1,29,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(458,125,1,29,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(459,125,1,29,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(460,125,1,29,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(461,125,1,30,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(462,125,1,30,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(463,125,1,30,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(464,125,1,30,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(465,125,1,30,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(466,125,1,30,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(467,125,1,31,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(468,125,1,31,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(469,125,1,31,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(470,125,1,31,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(471,125,1,31,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(472,125,1,31,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(473,90,1,32,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(474,125,1,32,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(475,125,1,32,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(476,125,1,32,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(477,125,1,32,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(478,125,1,32,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(479,125,1,32,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(480,125,1,32,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(481,90,1,33,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(482,125,1,33,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(483,125,1,33,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(484,125,1,33,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(485,125,1,33,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(486,125,1,33,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(487,125,1,33,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(488,125,1,33,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(489,90,1,39,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(490,90,1,39,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(491,125,1,39,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(492,125,1,39,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(493,125,1,39,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(494,125,1,39,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(495,90,1,39,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(496,90,1,39,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(497,125,1,39,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(498,125,1,39,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(499,90,1,39,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(500,125,1,39,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(501,125,1,39,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(502,125,1,39,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(503,125,1,39,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(504,125,1,39,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(505,125,1,39,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(506,125,1,39,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(507,90,1,44,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(508,90,1,44,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(509,125,1,44,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(510,125,1,44,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(511,125,1,44,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(512,125,1,44,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(513,90,1,44,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(514,90,1,44,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(515,125,1,44,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(516,125,1,44,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(517,90,1,44,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(518,125,1,44,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(519,125,1,44,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(520,125,1,44,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(521,125,1,44,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(522,125,1,44,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(523,125,1,44,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(524,125,1,44,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(525,125,1,50,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(526,125,1,50,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(527,125,1,50,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(528,125,1,50,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(529,125,1,50,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(530,125,1,50,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(531,125,1,51,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(532,125,1,51,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(533,125,1,51,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(534,125,1,51,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(535,125,1,51,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(536,125,1,51,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(537,125,1,52,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(538,125,1,52,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(539,125,1,52,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(540,125,1,52,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(541,125,1,52,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(542,125,1,52,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(543,125,1,53,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(544,125,1,53,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(545,125,1,53,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(546,125,1,53,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(547,125,1,53,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(548,125,1,53,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(549,90,1,54,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(550,90,1,54,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(551,125,1,54,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(552,125,1,54,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(553,125,1,54,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(554,125,1,54,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(555,90,1,54,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(556,90,1,54,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(557,125,1,54,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(558,125,1,54,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(559,90,1,54,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(560,125,1,54,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(561,125,1,54,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(562,125,1,54,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(563,125,1,54,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(564,125,1,54,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(565,125,1,54,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(566,125,1,54,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(567,125,1,55,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(568,125,1,55,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(569,125,1,55,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(570,125,1,55,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(571,125,1,55,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(572,125,1,55,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(573,4475,1,1,1,NULL,NULL,NULL,NULL,0,0,'Thor',0,3,90,NULL,1,0,0,0,0,0,0),(574,4475,1,1,1,NULL,NULL,NULL,NULL,0,0,'Thor',0,3,90,NULL,1,0,0,0,0,0,0),(575,4475,1,1,1,NULL,NULL,NULL,NULL,0,0,'Thor',1,3,90,NULL,1,0,0,0,0,0,0),(576,2812,1,1,1,NULL,NULL,NULL,NULL,0,0,'Dirac',0,3,90,NULL,1,0,0,0,0,0,0),(577,2812,1,1,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,3,90,NULL,1,0,0,0,0,0,0),(578,2812,1,1,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,3,90,NULL,1,0,0,0,0,0,0),(579,2812,1,1,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,3,90,NULL,1,0,0,0,0,0,0),(580,2812,1,1,1,NULL,NULL,NULL,NULL,0,0,'Dirac',0,3,90,NULL,1,0,0,0,0,0,0),(581,2812,1,1,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,3,90,NULL,1,0,0,0,0,0,0),(582,2812,1,1,1,NULL,NULL,NULL,NULL,0,0,'Dirac',0,3,90,NULL,1,0,0,0,0,0,0),(583,2812,1,1,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,3,90,NULL,1,0,0,0,0,0,0),(584,2812,1,1,1,NULL,NULL,NULL,NULL,0,0,'Dirac',0,1,0,NULL,1,0,0,0,0,0,0),(585,2812,1,1,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,1,0,NULL,1,0,0,0,0,0,0),(586,2812,1,1,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,1,0,NULL,1,0,0,0,0,0,0),(587,2812,1,1,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,1,0,NULL,1,0,0,0,0,0,0),(588,2812,1,1,1,NULL,NULL,NULL,NULL,0,0,'Dirac',0,1,0,NULL,1,0,0,0,0,0,0),(589,2812,1,1,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,1,0,NULL,1,0,0,0,0,0,0),(590,2812,1,1,1,NULL,NULL,NULL,NULL,0,0,'Dirac',0,1,0,NULL,1,0,0,0,0,0,0),(591,2812,1,1,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,1,0,NULL,1,0,0,0,0,0,0),(592,4475,1,1,1,NULL,NULL,NULL,NULL,0,0,'Thor',0,2,300,NULL,1,0,0,0,0,0,0),(593,4475,1,1,1,NULL,NULL,NULL,NULL,0,0,'Thor',0,2,300,NULL,1,0,0,0,0,0,0),(594,4475,1,1,1,NULL,NULL,NULL,NULL,0,0,'Thor',1,2,300,NULL,1,0,0,0,0,0,0),(595,2812,1,1,1,NULL,NULL,NULL,NULL,0,0,'Dirac',0,2,300,NULL,1,0,0,0,0,0,0),(596,2812,1,1,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,2,300,NULL,1,0,0,0,0,0,0),(597,2812,1,1,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,2,300,NULL,1,0,0,0,0,0,0),(598,2812,1,1,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,2,300,NULL,1,0,0,0,0,0,0),(599,2812,1,1,1,NULL,NULL,NULL,NULL,0,0,'Dirac',0,2,300,NULL,1,0,0,0,0,0,0),(600,2812,1,1,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,2,300,NULL,1,0,0,0,0,0,0),(601,2812,1,1,1,NULL,NULL,NULL,NULL,0,0,'Dirac',0,2,300,NULL,1,0,0,0,0,0,0),(602,2812,1,1,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,2,300,NULL,1,0,0,0,0,0,0),(603,26875,1,2,1,NULL,NULL,NULL,NULL,0,0,'Demosis',1,1,45,NULL,1,0,0,0,0,0,0),(604,4475,1,2,1,NULL,NULL,NULL,NULL,0,0,'Thor',1,1,45,NULL,1,0,0,0,0,0,0),(605,4475,1,2,1,NULL,NULL,NULL,NULL,0,0,'Thor',0,1,45,NULL,1,0,0,0,0,0,0),(606,4475,1,2,1,NULL,NULL,NULL,NULL,0,0,'Thor',0,1,45,NULL,1,0,0,0,0,0,0),(607,4475,1,2,1,NULL,NULL,NULL,NULL,0,0,'Thor',0,1,45,NULL,1,0,0,0,0,0,0),(608,4475,1,2,1,NULL,NULL,NULL,NULL,0,0,'Thor',1,1,45,NULL,1,0,0,0,0,0,0),(609,4475,1,2,1,NULL,NULL,NULL,NULL,0,0,'Thor',0,1,45,NULL,1,0,0,0,0,0,0),(610,2812,1,2,1,NULL,NULL,NULL,NULL,0,0,'Dirac',0,1,45,NULL,1,0,0,0,0,0,0),(611,2812,1,2,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,1,45,NULL,1,0,0,0,0,0,0),(612,2812,1,2,1,NULL,NULL,NULL,NULL,0,0,'Dirac',0,1,45,NULL,1,0,0,0,0,0,0),(613,2812,1,2,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,1,45,NULL,1,0,0,0,0,0,0),(614,2812,1,2,1,NULL,NULL,NULL,NULL,0,0,'Dirac',0,1,45,NULL,1,0,0,0,0,0,0),(615,2812,1,2,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,1,45,NULL,1,0,0,0,0,0,0),(616,2812,1,2,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,1,45,NULL,1,0,0,0,0,0,0),(617,90,1,56,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(618,90,1,56,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(619,90,1,56,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(620,90,1,56,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(621,125,1,56,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(622,125,1,56,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(623,125,1,56,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(624,125,1,56,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(625,125,1,56,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(626,125,1,56,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(627,125,1,56,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(628,900,1,57,4,NULL,NULL,NULL,NULL,0,0,'Gnawer',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(629,900,1,57,4,NULL,NULL,NULL,NULL,0,0,'Gnawer',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(630,900,1,57,4,NULL,NULL,NULL,NULL,0,0,'Gnawer',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(631,500,1,57,4,NULL,NULL,NULL,NULL,0,0,'Spudder',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(632,500,1,57,4,NULL,NULL,NULL,NULL,0,0,'Spudder',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(633,500,1,57,4,NULL,NULL,NULL,NULL,0,0,'Spudder',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(634,500,1,57,4,NULL,NULL,NULL,NULL,0,0,'Spudder',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(635,500,1,57,4,NULL,NULL,NULL,NULL,0,0,'Spudder',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(636,500,1,57,4,NULL,NULL,NULL,NULL,0,0,'Spudder',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(637,90,1,57,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(638,90,1,57,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(639,125,1,57,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(640,125,1,57,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(641,125,1,57,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(642,125,1,57,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(643,90,1,57,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(644,90,1,57,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(645,90,1,57,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(646,90,1,57,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(647,90,1,57,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(648,125,1,57,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(649,125,1,57,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(650,125,1,57,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(651,125,1,57,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(652,125,1,57,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(653,125,1,57,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(654,125,1,57,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(655,125,1,57,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(656,500,1,58,4,NULL,NULL,NULL,NULL,0,0,'Spudder',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(657,500,1,58,4,NULL,NULL,NULL,NULL,0,0,'Spudder',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(658,90,1,58,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(659,90,1,58,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(660,125,1,58,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(661,125,1,58,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(662,90,1,58,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(663,90,1,58,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(664,90,1,58,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(665,90,1,58,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(666,90,1,58,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(667,125,1,58,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(668,125,1,58,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(669,125,1,58,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(670,125,1,58,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(671,125,1,58,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(672,125,1,58,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(673,125,1,58,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(674,125,1,58,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(675,125,1,58,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(676,500,1,59,4,NULL,NULL,NULL,NULL,0,0,'Spudder',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(677,500,1,59,4,NULL,NULL,NULL,NULL,0,0,'Spudder',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(678,90,1,59,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(679,90,1,59,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(680,90,1,59,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(681,90,1,59,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(682,90,1,59,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(683,90,1,59,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(684,125,1,59,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(685,125,1,59,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(686,125,1,59,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(687,125,1,59,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(688,125,1,59,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(689,125,1,59,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(690,125,1,59,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(691,500,1,60,4,NULL,NULL,NULL,NULL,0,0,'Spudder',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(692,500,1,60,4,NULL,NULL,NULL,NULL,0,0,'Spudder',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(693,500,1,60,4,NULL,NULL,NULL,NULL,0,0,'Spudder',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(694,90,1,60,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(695,90,1,60,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(696,125,1,60,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(697,125,1,60,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(698,125,1,60,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(699,125,1,60,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(700,125,1,60,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(701,90,1,60,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(702,90,1,60,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(703,90,1,60,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(704,90,1,60,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(705,90,1,60,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(706,90,1,60,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(707,125,1,60,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(708,125,1,60,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(709,125,1,60,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(710,125,1,60,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(711,125,1,60,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(712,125,1,60,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(713,125,1,60,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(714,125,1,60,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(715,125,1,60,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(716,900,1,61,4,NULL,NULL,NULL,NULL,0,0,'Gnawer',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(717,900,1,61,4,NULL,NULL,NULL,NULL,0,0,'Gnawer',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(718,900,1,61,4,NULL,NULL,NULL,NULL,0,0,'Gnawer',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(719,900,1,61,4,NULL,NULL,NULL,NULL,0,0,'Gnawer',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(720,500,1,61,4,NULL,NULL,NULL,NULL,0,0,'Spudder',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(721,500,1,61,4,NULL,NULL,NULL,NULL,0,0,'Spudder',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(722,500,1,61,4,NULL,NULL,NULL,NULL,0,0,'Spudder',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(723,90,1,61,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(724,90,1,61,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(725,125,1,61,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(726,125,1,61,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(727,90,1,61,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(728,90,1,61,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(729,90,1,61,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(730,90,1,61,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(731,90,1,61,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(732,125,1,61,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(733,125,1,61,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(734,125,1,61,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(735,125,1,61,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(736,125,1,61,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(737,125,1,61,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(738,125,1,61,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(739,125,1,61,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(740,125,1,61,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(741,900,1,62,4,NULL,NULL,NULL,NULL,0,0,'Gnawer',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(742,500,1,62,4,NULL,NULL,NULL,NULL,0,0,'Spudder',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(743,500,1,62,4,NULL,NULL,NULL,NULL,0,0,'Spudder',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(744,500,1,62,4,NULL,NULL,NULL,NULL,0,0,'Spudder',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(745,500,1,62,4,NULL,NULL,NULL,NULL,0,0,'Spudder',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(746,500,1,62,4,NULL,NULL,NULL,NULL,0,0,'Spudder',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(747,90,1,62,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(748,90,1,62,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(749,90,1,62,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(750,90,1,62,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(751,90,1,62,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(752,90,1,62,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(753,90,1,62,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(754,90,1,62,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(755,125,1,62,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(756,125,1,62,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(757,125,1,62,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(758,125,1,62,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(759,125,1,62,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(760,125,1,62,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(761,125,1,62,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(762,900,1,63,4,NULL,NULL,NULL,NULL,0,0,'Gnawer',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(763,500,1,63,4,NULL,NULL,NULL,NULL,0,0,'Spudder',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(764,500,1,63,4,NULL,NULL,NULL,NULL,0,0,'Spudder',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(765,500,1,63,4,NULL,NULL,NULL,NULL,0,0,'Spudder',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(766,500,1,63,4,NULL,NULL,NULL,NULL,0,0,'Spudder',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(767,500,1,63,4,NULL,NULL,NULL,NULL,0,0,'Spudder',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(768,90,1,63,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(769,90,1,63,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(770,125,1,63,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(771,125,1,63,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(772,125,1,63,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(773,90,1,63,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(774,90,1,63,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(775,90,1,63,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(776,90,1,63,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(777,90,1,63,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(778,90,1,63,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(779,125,1,63,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(780,125,1,63,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(781,125,1,63,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(782,125,1,63,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(783,125,1,63,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(784,125,1,63,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(785,900,1,64,4,NULL,NULL,NULL,NULL,0,0,'Gnawer',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(786,900,1,64,4,NULL,NULL,NULL,NULL,0,0,'Gnawer',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(787,500,1,64,4,NULL,NULL,NULL,NULL,0,0,'Spudder',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(788,500,1,64,4,NULL,NULL,NULL,NULL,0,0,'Spudder',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(789,500,1,64,4,NULL,NULL,NULL,NULL,0,0,'Spudder',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(790,90,1,64,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(791,90,1,64,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(792,125,1,64,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(793,125,1,64,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(794,125,1,64,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(795,90,1,64,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(796,90,1,64,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(797,90,1,64,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(798,90,1,64,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(799,90,1,64,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(800,90,1,64,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(801,125,1,64,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(802,125,1,64,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(803,125,1,64,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(804,125,1,64,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(805,125,1,64,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(806,125,1,64,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(807,125,1,64,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(808,125,1,64,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(809,500,1,65,4,NULL,NULL,NULL,NULL,0,0,'Spudder',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(810,90,1,65,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(811,125,1,65,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(812,125,1,65,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(813,90,1,65,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(814,90,1,65,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(815,90,1,65,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(816,90,1,65,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(817,90,1,65,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(818,125,1,65,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(819,125,1,65,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(820,125,1,65,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(821,125,1,65,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(822,125,1,65,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(823,125,1,65,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(824,125,1,65,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(825,90,1,66,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(826,90,1,66,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(827,125,1,66,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(828,125,1,66,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(829,125,1,66,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(830,125,1,66,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(831,90,1,66,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(832,90,1,66,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(833,90,1,66,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(834,90,1,66,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(835,90,1,66,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(836,125,1,66,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(837,125,1,66,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(838,125,1,66,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(839,125,1,66,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(840,125,1,66,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(841,125,1,66,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(842,125,1,66,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(843,125,1,66,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(844,125,1,67,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(845,125,1,67,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(846,125,1,67,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(847,125,1,67,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(848,125,1,67,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(849,125,1,67,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(850,125,1,68,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(851,125,1,68,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(852,125,1,68,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(853,125,1,68,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(854,125,1,68,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(855,125,1,68,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(856,125,1,68,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(857,125,1,68,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(858,125,1,69,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(859,125,1,69,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(860,125,1,69,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(861,125,1,69,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(862,125,1,69,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(863,125,1,69,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(864,125,1,69,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(865,125,1,69,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(866,125,1,69,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(867,125,1,70,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(868,125,1,70,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(869,125,1,70,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(870,125,1,70,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(871,125,1,70,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(872,125,1,70,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(873,125,1,70,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(874,125,1,70,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(875,125,1,70,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(876,26875,1,2,1,NULL,NULL,NULL,NULL,0,0,'Demosis',0,1,225,NULL,1,0,0,0,0,0,0),(877,26875,1,2,1,NULL,NULL,NULL,NULL,0,0,'Demosis',0,1,225,NULL,1,0,0,0,0,0,0),(878,26875,1,2,1,NULL,NULL,NULL,NULL,0,0,'Demosis',1,1,225,NULL,1,0,0,0,0,0,0),(879,4475,1,2,1,NULL,NULL,NULL,NULL,0,0,'Thor',0,1,225,NULL,1,0,0,0,0,0,0),(880,4475,1,2,1,NULL,NULL,NULL,NULL,0,0,'Thor',0,1,225,NULL,1,0,0,0,0,0,0),(881,4475,1,2,1,NULL,NULL,NULL,NULL,0,0,'Thor',0,1,225,NULL,1,0,0,0,0,0,0),(882,2812,1,2,1,NULL,NULL,NULL,NULL,0,0,'Dirac',0,1,225,NULL,1,0,0,0,0,0,0),(883,2812,1,2,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,1,225,NULL,1,0,0,0,0,0,0),(884,2812,1,2,1,NULL,NULL,NULL,NULL,0,0,'Dirac',0,1,225,NULL,1,0,0,0,0,0,0),(885,2812,1,2,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,1,225,NULL,1,0,0,0,0,0,0),(886,2812,1,2,1,NULL,NULL,NULL,NULL,0,0,'Dirac',0,1,225,NULL,1,0,0,0,0,0,0),(887,2812,1,2,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,1,225,NULL,1,0,0,0,0,0,0),(888,2812,1,2,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,1,225,NULL,1,0,0,0,0,0,0),(889,26875,1,2,1,NULL,NULL,NULL,NULL,0,0,'Demosis',0,2,30,NULL,1,0,0,0,0,0,0),(890,26875,1,2,1,NULL,NULL,NULL,NULL,0,0,'Demosis',0,2,30,NULL,1,0,0,0,0,0,0),(891,26875,1,2,1,NULL,NULL,NULL,NULL,0,0,'Demosis',1,2,30,NULL,1,0,0,0,0,0,0),(892,4475,1,2,1,NULL,NULL,NULL,NULL,0,0,'Thor',1,2,30,NULL,1,0,0,0,0,0,0),(893,4475,1,2,1,NULL,NULL,NULL,NULL,0,0,'Thor',0,2,30,NULL,1,0,0,0,0,0,0),(894,4475,1,2,1,NULL,NULL,NULL,NULL,0,0,'Thor',0,2,30,NULL,1,0,0,0,0,0,0),(895,4475,1,2,1,NULL,NULL,NULL,NULL,0,0,'Thor',0,2,30,NULL,1,0,0,0,0,0,0),(896,2812,1,2,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,2,30,NULL,1,0,0,0,0,0,0),(897,2812,1,2,1,NULL,NULL,NULL,NULL,0,0,'Dirac',0,2,30,NULL,1,0,0,0,0,0,0),(898,2812,1,2,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,2,30,NULL,1,0,0,0,0,0,0),(899,2812,1,2,1,NULL,NULL,NULL,NULL,0,0,'Dirac',0,2,30,NULL,1,0,0,0,0,0,0),(900,2812,1,2,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,2,30,NULL,1,0,0,0,0,0,0),(901,90,1,71,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(902,90,1,71,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(903,90,1,71,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(904,125,1,71,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(905,125,1,71,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(906,125,1,71,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(907,125,1,71,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(908,125,1,71,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(909,125,1,71,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(910,125,1,71,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(911,125,1,71,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(912,125,1,71,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(913,125,1,71,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(914,90,1,72,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(915,90,1,72,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(916,90,1,72,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(917,90,1,72,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(918,125,1,72,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(919,125,1,72,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(920,125,1,72,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(921,125,1,72,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(922,125,1,72,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(923,125,1,72,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(924,125,1,72,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(925,125,1,72,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(926,90,1,73,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(927,90,1,73,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(928,90,1,73,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(929,125,1,73,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(930,125,1,73,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(931,125,1,73,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(932,125,1,73,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(933,125,1,73,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(934,125,1,73,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(935,125,1,73,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(936,125,1,73,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(937,900,1,74,4,NULL,NULL,NULL,NULL,0,0,'Gnawer',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(938,500,1,74,4,NULL,NULL,NULL,NULL,0,0,'Spudder',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(939,500,1,74,4,NULL,NULL,NULL,NULL,0,0,'Spudder',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(940,900,1,74,4,NULL,NULL,NULL,NULL,0,0,'Gnawer',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(941,500,1,74,4,NULL,NULL,NULL,NULL,0,0,'Spudder',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(942,500,1,74,4,NULL,NULL,NULL,NULL,0,0,'Spudder',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(943,500,1,74,4,NULL,NULL,NULL,NULL,0,0,'Spudder',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(944,90,1,74,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(945,90,1,74,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(946,125,1,74,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(947,125,1,74,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(948,90,1,74,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(949,90,1,74,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(950,90,1,74,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(951,90,1,74,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(952,125,1,74,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(953,125,1,74,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(954,125,1,74,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(955,125,1,74,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(956,125,1,74,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(957,125,1,74,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(958,125,1,74,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(959,125,1,74,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(960,125,1,74,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(961,900,1,75,4,NULL,NULL,NULL,NULL,0,0,'Gnawer',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(962,900,1,75,4,NULL,NULL,NULL,NULL,0,0,'Gnawer',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(963,500,1,75,4,NULL,NULL,NULL,NULL,0,0,'Spudder',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(964,500,1,75,4,NULL,NULL,NULL,NULL,0,0,'Spudder',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(965,500,1,75,4,NULL,NULL,NULL,NULL,0,0,'Spudder',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(966,90,1,75,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(967,90,1,75,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(968,90,1,75,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(969,90,1,75,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(970,90,1,75,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(971,90,1,75,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(972,90,1,75,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(973,125,1,75,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(974,125,1,75,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(975,125,1,75,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(976,125,1,75,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(977,125,1,75,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(978,125,1,75,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(979,125,1,75,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(980,125,1,75,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(981,500,1,76,4,NULL,NULL,NULL,NULL,0,0,'Spudder',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(982,500,1,76,4,NULL,NULL,NULL,NULL,0,0,'Spudder',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(983,90,1,76,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(984,90,1,76,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(985,125,1,76,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(986,125,1,76,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(987,125,1,76,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(988,90,1,76,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(989,90,1,76,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(990,90,1,76,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(991,90,1,76,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(992,90,1,76,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(993,125,1,76,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(994,125,1,76,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(995,125,1,76,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(996,125,1,76,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(997,125,1,76,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(998,125,1,76,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(999,125,1,76,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(1000,125,1,76,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(1001,125,1,76,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(1002,500,1,77,4,NULL,NULL,NULL,NULL,0,0,'Spudder',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(1003,500,1,77,4,NULL,NULL,NULL,NULL,0,0,'Spudder',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(1004,90,1,77,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(1005,90,1,77,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(1006,125,1,77,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(1007,125,1,77,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(1008,90,1,77,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(1009,90,1,77,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(1010,90,1,77,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(1011,90,1,77,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(1012,90,1,77,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(1013,125,1,77,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(1014,125,1,77,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(1015,125,1,77,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(1016,125,1,77,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(1017,125,1,77,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(1018,125,1,77,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(1019,125,1,77,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(1020,500,1,78,4,NULL,NULL,NULL,NULL,0,0,'Spudder',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(1021,500,1,78,4,NULL,NULL,NULL,NULL,0,0,'Spudder',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(1022,90,1,78,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(1023,90,1,78,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(1024,125,1,78,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(1025,125,1,78,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(1026,125,1,78,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(1027,125,1,78,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(1028,90,1,78,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(1029,90,1,78,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(1030,90,1,78,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(1031,90,1,78,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(1032,90,1,78,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(1033,125,1,78,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(1034,125,1,78,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(1035,125,1,78,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(1036,125,1,78,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(1037,125,1,78,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(1038,125,1,78,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(1039,125,1,78,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(1040,125,1,78,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(1041,125,1,78,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(1042,900,1,79,4,NULL,NULL,NULL,NULL,0,0,'Gnawer',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(1043,900,1,79,4,NULL,NULL,NULL,NULL,0,0,'Gnawer',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(1044,900,1,79,4,NULL,NULL,NULL,NULL,0,0,'Gnawer',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(1045,500,1,79,4,NULL,NULL,NULL,NULL,0,0,'Spudder',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(1046,500,1,79,4,NULL,NULL,NULL,NULL,0,0,'Spudder',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(1047,500,1,79,4,NULL,NULL,NULL,NULL,0,0,'Spudder',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(1048,500,1,79,4,NULL,NULL,NULL,NULL,0,0,'Spudder',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(1049,90,1,79,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(1050,90,1,79,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(1051,125,1,79,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(1052,125,1,79,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(1053,90,1,79,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(1054,90,1,79,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(1055,90,1,79,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(1056,90,1,79,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(1057,90,1,79,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(1058,90,1,79,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(1059,125,1,79,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(1060,125,1,79,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(1061,125,1,79,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(1062,125,1,79,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(1063,125,1,79,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(1064,125,1,79,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(1065,125,1,79,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(1066,900,1,80,4,NULL,NULL,NULL,NULL,0,0,'Gnawer',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(1067,500,1,80,4,NULL,NULL,NULL,NULL,0,0,'Spudder',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(1068,500,1,80,4,NULL,NULL,NULL,NULL,0,0,'Spudder',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(1069,500,1,80,4,NULL,NULL,NULL,NULL,0,0,'Spudder',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(1070,500,1,80,4,NULL,NULL,NULL,NULL,0,0,'Spudder',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(1071,500,1,80,4,NULL,NULL,NULL,NULL,0,0,'Spudder',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(1072,90,1,80,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(1073,90,1,80,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(1074,125,1,80,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(1075,125,1,80,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(1076,125,1,80,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(1077,90,1,80,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(1078,90,1,80,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(1079,90,1,80,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(1080,90,1,80,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(1081,90,1,80,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(1082,125,1,80,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(1083,125,1,80,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(1084,125,1,80,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(1085,125,1,80,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(1086,125,1,80,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(1087,125,1,80,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(1088,125,1,80,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(1089,125,1,80,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(1090,500,1,81,4,NULL,NULL,NULL,NULL,0,0,'Spudder',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(1091,90,1,81,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(1092,90,1,81,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(1093,125,1,81,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(1094,125,1,81,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(1095,125,1,81,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(1096,125,1,81,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(1097,125,1,81,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(1098,90,1,81,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(1099,90,1,81,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(1100,90,1,81,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(1101,90,1,81,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(1102,90,1,81,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(1103,125,1,81,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(1104,125,1,81,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(1105,125,1,81,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(1106,125,1,81,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(1107,125,1,81,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(1108,125,1,81,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(1109,125,1,81,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(1110,125,1,81,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(1111,90,1,82,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(1112,90,1,82,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(1113,125,1,82,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(1114,125,1,82,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(1115,90,1,82,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(1116,90,1,82,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(1117,90,1,82,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(1118,90,1,82,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(1119,90,1,82,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(1120,90,1,82,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(1121,125,1,82,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(1122,125,1,82,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(1123,125,1,82,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(1124,125,1,82,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(1125,125,1,82,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(1126,125,1,82,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(1127,125,1,82,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(1128,125,1,82,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(1129,125,1,82,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(1130,125,1,83,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(1131,125,1,83,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(1132,125,1,83,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(1133,125,1,83,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(1134,125,1,83,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(1135,125,1,83,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(1136,125,1,83,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(1137,125,1,83,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(1138,125,1,84,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(1139,125,1,84,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(1140,125,1,84,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(1141,125,1,84,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(1142,125,1,84,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(1143,125,1,84,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(1144,125,1,84,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(1145,125,1,84,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(1146,125,1,84,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(1147,125,1,84,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(1148,125,1,85,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(1149,125,1,85,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(1150,125,1,85,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(1151,125,1,85,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(1152,125,1,85,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(1153,125,1,85,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(1154,125,1,85,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(1155,125,1,85,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(1156,125,1,86,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(1157,125,1,86,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(1158,125,1,86,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(1159,125,1,86,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(1160,125,1,86,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(1161,125,1,86,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,NULL,NULL,NULL,1,0,0,0,0,0,0);
/*!40000 ALTER TABLE `units` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `wreckages`
--

DROP TABLE IF EXISTS `wreckages`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `wreckages` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `galaxy_id` int(11) DEFAULT NULL,
  `location_id` int(11) NOT NULL,
  `location_type` tinyint(3) unsigned NOT NULL,
  `location_x` smallint(6) NOT NULL,
  `location_y` smallint(6) NOT NULL,
  `metal` float NOT NULL DEFAULT '0',
  `energy` float NOT NULL DEFAULT '0',
  `zetium` float NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `location` (`location_id`,`location_type`,`location_x`,`location_y`),
  KEY `galaxy_id` (`galaxy_id`),
  CONSTRAINT `wreckages_ibfk_1` FOREIGN KEY (`galaxy_id`) REFERENCES `galaxies` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `wreckages`
--

LOCK TABLES `wreckages` WRITE;
/*!40000 ALTER TABLE `wreckages` DISABLE KEYS */;
/*!40000 ALTER TABLE `wreckages` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2011-02-21  0:55:57
