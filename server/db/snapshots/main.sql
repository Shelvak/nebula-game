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
) ENGINE=InnoDB AUTO_INCREMENT=93 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `buildings`
--

LOCK TABLES `buildings` WRITE;
/*!40000 ALTER TABLE `buildings` DISABLE KEYS */;
INSERT INTO `buildings` VALUES (1,2,12,27,0,0,0,1,'NpcMetalExtractor',NULL,13,28,NULL,1,400,NULL,0,NULL,NULL,0),(2,2,16,32,0,0,0,1,'NpcMetalExtractor',NULL,17,33,NULL,1,400,NULL,0,NULL,NULL,0),(3,2,23,37,0,0,0,1,'NpcMetalExtractor',NULL,24,38,NULL,1,400,NULL,0,NULL,NULL,0),(4,2,16,38,0,0,0,1,'NpcMetalExtractor',NULL,17,39,NULL,1,400,NULL,0,NULL,NULL,0),(5,2,29,39,0,0,0,1,'NpcMetalExtractor',NULL,30,40,NULL,1,400,NULL,0,NULL,NULL,0),(6,2,32,31,0,0,0,1,'NpcMetalExtractor',NULL,33,32,NULL,1,400,NULL,0,NULL,NULL,0),(7,2,11,36,0,0,0,1,'NpcResearchCenter',NULL,14,39,NULL,1,4000,NULL,0,NULL,NULL,0),(8,2,32,40,0,0,0,1,'NpcTemple',NULL,34,42,NULL,1,1500,NULL,0,NULL,NULL,0),(9,2,32,34,0,0,0,1,'NpcCommunicationsHub',NULL,34,35,NULL,1,1200,NULL,0,NULL,NULL,0),(10,2,26,36,0,0,0,1,'NpcSolarPlant',NULL,27,37,NULL,1,1000,NULL,0,NULL,NULL,0),(11,2,26,34,0,0,0,1,'NpcSolarPlant',NULL,27,35,NULL,1,1000,NULL,0,NULL,NULL,0),(12,2,33,36,0,0,0,1,'NpcSolarPlant',NULL,34,37,NULL,1,1000,NULL,0,NULL,NULL,0),(13,2,33,38,0,0,0,1,'NpcSolarPlant',NULL,34,39,NULL,1,1000,NULL,0,NULL,NULL,0),(14,13,13,40,0,0,0,1,'NpcMetalExtractor',NULL,14,41,NULL,1,400,NULL,0,NULL,NULL,0),(15,13,17,36,0,0,0,1,'NpcMetalExtractor',NULL,18,37,NULL,1,400,NULL,0,NULL,NULL,0),(16,13,2,40,0,0,0,1,'NpcGeothermalPlant',NULL,3,41,NULL,1,600,NULL,0,NULL,NULL,0),(17,13,16,33,0,0,0,1,'NpcCommunicationsHub',NULL,18,34,NULL,1,1200,NULL,0,NULL,NULL,0),(18,13,0,43,0,0,0,1,'NpcSolarPlant',NULL,1,44,NULL,1,1000,NULL,0,NULL,NULL,0),(19,13,0,33,0,0,0,1,'NpcSolarPlant',NULL,1,34,NULL,1,1000,NULL,0,NULL,NULL,0),(20,13,0,36,0,0,0,1,'NpcSolarPlant',NULL,1,37,NULL,1,1000,NULL,0,NULL,NULL,0),(21,13,4,43,0,0,0,1,'NpcSolarPlant',NULL,5,44,NULL,1,1000,NULL,0,NULL,NULL,0),(22,17,6,4,0,0,0,1,'NpcMetalExtractor',NULL,7,5,NULL,1,400,NULL,0,NULL,NULL,0),(23,17,2,2,0,0,0,1,'NpcMetalExtractor',NULL,3,3,NULL,1,400,NULL,0,NULL,NULL,0),(24,17,2,14,0,0,0,1,'NpcMetalExtractor',NULL,3,15,NULL,1,400,NULL,0,NULL,NULL,0),(25,17,2,18,0,0,0,1,'NpcMetalExtractor',NULL,3,19,NULL,1,400,NULL,0,NULL,NULL,0),(26,17,6,19,0,0,0,1,'NpcMetalExtractor',NULL,7,20,NULL,1,400,NULL,0,NULL,NULL,0),(27,17,10,14,0,0,0,1,'NpcGeothermalPlant',NULL,11,15,NULL,1,600,NULL,0,NULL,NULL,0),(28,17,10,10,0,0,0,1,'NpcZetiumExtractor',NULL,11,11,NULL,1,800,NULL,0,NULL,NULL,0),(29,17,10,7,0,0,0,1,'NpcCommunicationsHub',NULL,12,8,NULL,1,1200,NULL,0,NULL,NULL,0),(30,17,5,8,0,0,0,1,'NpcExcavationSite',NULL,8,11,NULL,1,2000,NULL,0,NULL,NULL,0),(31,17,10,21,0,0,0,1,'NpcCommunicationsHub',NULL,12,22,NULL,1,1200,NULL,0,NULL,NULL,0),(32,17,5,16,0,0,0,1,'NpcSolarPlant',NULL,6,17,NULL,1,1000,NULL,0,NULL,NULL,0),(33,17,7,16,0,0,0,1,'NpcSolarPlant',NULL,8,17,NULL,1,1000,NULL,0,NULL,NULL,0),(34,17,7,14,0,0,0,1,'NpcSolarPlant',NULL,8,15,NULL,1,1000,NULL,0,NULL,NULL,0),(35,17,7,12,0,0,0,1,'NpcSolarPlant',NULL,8,13,NULL,1,1000,NULL,0,NULL,NULL,0),(36,21,5,20,0,0,0,1,'NpcMetalExtractor',NULL,6,21,NULL,1,400,NULL,0,NULL,NULL,0),(37,21,1,7,0,0,0,1,'NpcMetalExtractor',NULL,2,8,NULL,1,400,NULL,0,NULL,NULL,0),(38,21,1,2,0,0,0,1,'NpcMetalExtractor',NULL,2,3,NULL,1,400,NULL,0,NULL,NULL,0),(39,21,8,1,0,0,0,1,'NpcMetalExtractor',NULL,9,2,NULL,1,400,NULL,0,NULL,NULL,0),(40,21,13,3,0,0,0,1,'NpcGeothermalPlant',NULL,14,4,NULL,1,600,NULL,0,NULL,NULL,0),(41,21,4,0,0,0,0,1,'NpcCommunicationsHub',NULL,6,1,NULL,1,1200,NULL,0,NULL,NULL,0),(42,21,10,4,0,0,0,1,'NpcSolarPlant',NULL,11,5,NULL,1,1000,NULL,0,NULL,NULL,0),(43,21,8,4,0,0,0,1,'NpcSolarPlant',NULL,9,5,NULL,1,1000,NULL,0,NULL,NULL,0),(44,21,4,4,0,0,0,1,'NpcSolarPlant',NULL,5,5,NULL,1,1000,NULL,0,NULL,NULL,0),(45,21,6,4,0,0,0,1,'NpcSolarPlant',NULL,7,5,NULL,1,1000,NULL,0,NULL,NULL,0),(46,30,7,9,0,0,0,1,'Vulcan',NULL,8,10,NULL,1,1400,NULL,0,NULL,NULL,0),(47,30,14,9,0,0,0,1,'Thunder',NULL,15,10,NULL,1,2400,NULL,0,NULL,NULL,0),(48,30,21,9,0,0,0,1,'Screamer',NULL,22,10,NULL,1,1700,NULL,0,NULL,NULL,0),(49,30,11,14,0,0,0,1,'Mothership',NULL,18,19,NULL,1,10500,NULL,0,NULL,NULL,0),(50,30,7,16,0,0,0,1,'Thunder',NULL,8,17,NULL,1,2400,NULL,0,NULL,NULL,0),(51,30,21,16,0,0,0,1,'Thunder',NULL,22,17,NULL,1,2400,NULL,0,NULL,NULL,0),(52,30,26,16,0,0,0,1,'NpcZetiumExtractor',NULL,27,17,NULL,1,800,NULL,0,NULL,NULL,0),(53,30,25,20,0,0,0,1,'NpcTemple',NULL,27,22,NULL,1,1500,NULL,0,NULL,NULL,0),(54,30,7,22,0,0,0,1,'Screamer',NULL,8,23,NULL,1,1700,NULL,0,NULL,NULL,0),(55,30,14,22,0,0,0,1,'Thunder',NULL,15,23,NULL,1,2400,NULL,0,NULL,NULL,0),(56,30,21,22,0,0,0,1,'Vulcan',NULL,22,23,NULL,1,1400,NULL,0,NULL,NULL,0),(57,30,24,24,0,0,0,1,'NpcMetalExtractor',NULL,25,25,NULL,1,400,NULL,0,NULL,NULL,0),(58,30,28,24,0,0,0,1,'NpcMetalExtractor',NULL,29,25,NULL,1,400,NULL,0,NULL,NULL,0),(59,30,18,25,0,0,0,1,'NpcSolarPlant',NULL,19,26,NULL,1,1000,NULL,0,NULL,NULL,0),(60,30,15,26,0,0,0,1,'NpcSolarPlant',NULL,16,27,NULL,1,1000,NULL,0,NULL,NULL,0),(61,30,3,27,0,0,0,1,'NpcMetalExtractor',NULL,4,28,NULL,1,400,NULL,0,NULL,NULL,0),(62,30,12,27,0,0,0,1,'NpcSolarPlant',NULL,13,28,NULL,1,1000,NULL,0,NULL,NULL,0),(63,30,22,27,0,0,0,1,'NpcSolarPlant',NULL,23,28,NULL,1,1000,NULL,0,NULL,NULL,0),(64,30,26,27,0,0,0,1,'NpcCommunicationsHub',NULL,28,28,NULL,1,1200,NULL,0,NULL,NULL,0),(65,30,0,28,0,0,0,1,'NpcMetalExtractor',NULL,1,29,NULL,1,400,NULL,0,NULL,NULL,0),(66,30,7,28,0,0,0,1,'NpcCommunicationsHub',NULL,9,29,NULL,1,1200,NULL,0,NULL,NULL,0),(67,30,18,28,0,0,0,1,'NpcSolarPlant',NULL,19,29,NULL,1,1000,NULL,0,NULL,NULL,0),(68,31,8,35,0,0,0,1,'NpcMetalExtractor',NULL,9,36,NULL,1,400,NULL,0,NULL,NULL,0),(69,31,14,35,0,0,0,1,'NpcMetalExtractor',NULL,15,36,NULL,1,400,NULL,0,NULL,NULL,0),(70,31,2,35,0,0,0,1,'NpcMetalExtractor',NULL,3,36,NULL,1,400,NULL,0,NULL,NULL,0),(71,31,14,22,0,0,0,1,'NpcMetalExtractor',NULL,15,23,NULL,1,400,NULL,0,NULL,NULL,0),(72,31,12,26,0,0,0,1,'NpcMetalExtractor',NULL,13,27,NULL,1,400,NULL,0,NULL,NULL,0),(73,31,14,30,0,0,0,1,'NpcMetalExtractor',NULL,15,31,NULL,1,400,NULL,0,NULL,NULL,0),(74,31,0,31,0,0,0,1,'NpcCommunicationsHub',NULL,2,32,NULL,1,1200,NULL,0,NULL,NULL,0),(75,31,0,29,0,0,0,1,'NpcSolarPlant',NULL,1,30,NULL,1,1000,NULL,0,NULL,NULL,0),(76,31,11,35,0,0,0,1,'NpcSolarPlant',NULL,12,36,NULL,1,1000,NULL,0,NULL,NULL,0),(77,31,5,27,0,0,0,1,'NpcSolarPlant',NULL,6,28,NULL,1,1000,NULL,0,NULL,NULL,0),(78,31,5,25,0,0,0,1,'NpcSolarPlant',NULL,6,26,NULL,1,1000,NULL,0,NULL,NULL,0),(79,42,1,18,0,0,0,1,'NpcMetalExtractor',NULL,2,19,NULL,1,400,NULL,0,NULL,NULL,0),(80,42,13,7,0,0,0,1,'NpcMetalExtractor',NULL,14,8,NULL,1,400,NULL,0,NULL,NULL,0),(81,42,15,2,0,0,0,1,'NpcMetalExtractor',NULL,16,3,NULL,1,400,NULL,0,NULL,NULL,0),(82,42,10,3,0,0,0,1,'NpcMetalExtractor',NULL,11,4,NULL,1,400,NULL,0,NULL,NULL,0),(83,42,5,5,0,0,0,1,'NpcMetalExtractor',NULL,6,6,NULL,1,400,NULL,0,NULL,NULL,0),(84,42,1,5,0,0,0,1,'NpcGeothermalPlant',NULL,2,6,NULL,1,600,NULL,0,NULL,NULL,0),(85,42,25,0,0,0,0,1,'NpcJumpgate',NULL,29,4,NULL,1,8000,NULL,0,NULL,NULL,0),(86,42,21,0,0,0,0,1,'NpcResearchCenter',NULL,24,3,NULL,1,4000,NULL,0,NULL,NULL,0),(87,42,18,8,0,0,0,1,'NpcExcavationSite',NULL,21,11,NULL,1,2000,NULL,0,NULL,NULL,0),(88,42,18,12,0,0,0,1,'NpcTemple',NULL,20,14,NULL,1,1500,NULL,0,NULL,NULL,0),(89,42,9,0,0,0,0,1,'NpcCommunicationsHub',NULL,11,1,NULL,1,1200,NULL,0,NULL,NULL,0),(90,42,12,0,0,0,0,1,'NpcSolarPlant',NULL,13,1,NULL,1,1000,NULL,0,NULL,NULL,0),(91,42,19,15,0,0,0,1,'NpcSolarPlant',NULL,20,16,NULL,1,1000,NULL,0,NULL,NULL,0),(92,42,17,15,0,0,0,1,'NpcSolarPlant',NULL,18,16,NULL,1,1000,NULL,0,NULL,NULL,0);
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
INSERT INTO `folliages` VALUES (2,0,0,7),(2,0,1,11),(2,0,24,1),(2,0,26,2),(2,0,42,10),(2,1,0,8),(2,1,1,6),(2,1,2,4),(2,1,6,8),(2,1,8,11),(2,1,24,8),(2,1,27,4),(2,1,38,9),(2,2,18,10),(2,2,22,7),(2,2,26,13),(2,3,3,2),(2,3,6,0),(2,3,23,10),(2,3,24,10),(2,3,29,3),(2,3,30,11),(2,3,33,2),(2,4,3,4),(2,4,8,0),(2,4,28,4),(2,4,33,5),(2,5,2,11),(2,5,3,4),(2,5,31,3),(2,5,36,6),(2,6,10,5),(2,6,21,5),(2,6,39,2),(2,6,40,12),(2,7,9,5),(2,7,11,10),(2,7,35,9),(2,8,13,12),(2,8,36,1),(2,8,39,6),(2,9,12,4),(2,9,31,12),(2,9,34,2),(2,9,39,9),(2,10,8,6),(2,10,9,4),(2,10,11,5),(2,10,13,10),(2,10,15,12),(2,10,17,2),(2,10,18,4),(2,10,32,0),(2,11,8,4),(2,11,17,6),(2,11,18,8),(2,11,21,2),(2,12,12,7),(2,12,18,6),(2,12,19,6),(2,12,22,8),(2,12,23,5),(2,13,4,6),(2,13,8,3),(2,13,10,6),(2,13,13,4),(2,13,19,8),(2,13,20,11),(2,13,22,11),(2,13,25,9),(2,13,35,4),(2,14,5,11),(2,14,7,2),(2,14,11,9),(2,14,12,6),(2,14,13,7),(2,14,17,4),(2,14,23,3),(2,15,0,12),(2,15,3,3),(2,15,4,4),(2,15,5,8),(2,15,6,11),(2,15,12,2),(2,15,17,12),(2,15,19,7),(2,15,24,7),(2,15,37,3),(2,15,38,3),(2,15,42,5),(2,16,7,4),(2,16,10,10),(2,16,18,1),(2,16,22,7),(2,16,25,5),(2,16,35,13),(2,17,6,11),(2,17,7,0),(2,17,10,6),(2,17,19,10),(2,18,7,9),(2,18,12,3),(2,18,25,4),(2,18,36,8),(2,18,39,2),(2,19,2,3),(2,19,5,5),(2,19,9,2),(2,19,10,13),(2,19,14,7),(2,19,30,10),(2,20,8,8),(2,20,12,6),(2,20,13,8),(2,20,26,4),(2,20,28,8),(2,20,29,6),(2,20,39,0),(2,21,14,2),(2,21,19,0),(2,21,25,11),(2,21,29,0),(2,21,33,3),(2,22,1,4),(2,22,14,4),(2,22,24,9),(2,22,27,8),(2,22,29,13),(2,22,36,0),(2,22,38,10),(2,23,14,2),(2,23,24,3),(2,23,30,0),(2,23,39,8),(2,24,0,6),(2,24,1,7),(2,24,12,8),(2,24,14,13),(2,24,23,4),(2,24,27,4),(2,24,39,4),(2,25,2,6),(2,25,3,5),(2,25,10,9),(2,25,28,3),(2,25,34,12),(2,25,38,9),(2,25,41,13),(2,25,42,1),(2,26,5,4),(2,26,8,10),(2,26,11,8),(2,26,26,6),(2,26,40,0),(2,27,0,12),(2,27,2,2),(2,27,27,2),(2,27,40,0),(2,28,2,11),(2,28,8,3),(2,28,12,5),(2,28,13,10),(2,28,14,9),(2,28,25,13),(2,28,30,9),(2,29,4,0),(2,29,5,11),(2,29,7,9),(2,29,13,1),(2,29,16,3),(2,29,42,11),(2,30,7,10),(2,30,12,8),(2,30,13,7),(2,30,28,7),(2,30,37,12),(2,30,41,9),(2,31,0,1),(2,31,5,2),(2,31,6,12),(2,31,13,2),(2,31,26,9),(2,31,37,8),(2,32,0,6),(2,32,8,3),(2,32,11,13),(2,32,12,9),(2,32,14,9),(2,32,28,10),(2,33,0,3),(2,33,6,11),(2,33,9,11),(2,33,27,1),(2,34,0,2),(2,34,2,7),(2,34,6,10),(13,0,5,13),(13,0,8,4),(13,0,29,0),(13,1,10,9),(13,1,11,0),(13,1,20,5),(13,1,22,7),(13,1,29,9),(13,1,41,13),(13,2,3,4),(13,2,4,2),(13,2,6,7),(13,2,7,5),(13,2,10,7),(13,2,25,7),(13,2,29,0),(13,2,30,2),(13,2,39,1),(13,3,7,3),(13,3,8,8),(13,3,11,5),(13,3,15,0),(13,3,37,1),(13,3,44,5),(13,4,7,4),(13,4,9,4),(13,4,11,3),(13,4,12,8),(13,4,17,10),(13,4,26,1),(13,4,34,11),(13,4,37,7),(13,4,39,5),(13,5,4,6),(13,5,6,3),(13,5,9,3),(13,5,10,10),(13,5,11,1),(13,5,24,6),(13,5,25,9),(13,5,29,13),(13,5,33,6),(13,5,40,10),(13,5,41,11),(13,5,42,8),(13,6,17,13),(13,6,25,10),(13,6,26,10),(13,6,27,2),(13,6,28,3),(13,6,39,0),(13,6,41,0),(13,6,43,6),(13,6,44,3),(13,7,6,11),(13,7,7,3),(13,7,14,5),(13,7,17,2),(13,7,25,4),(13,7,40,0),(13,8,5,4),(13,8,11,13),(13,8,19,5),(13,9,1,13),(13,9,2,1),(13,9,6,13),(13,9,8,10),(13,9,10,3),(13,9,13,5),(13,9,16,13),(13,9,20,3),(13,9,32,10),(13,9,40,0),(13,9,42,12),(13,9,44,11),(13,10,0,1),(13,10,7,6),(13,10,27,10),(13,10,32,8),(13,10,35,10),(13,10,39,0),(13,11,6,0),(13,11,10,9),(13,11,12,6),(13,11,19,0),(13,11,20,11),(13,11,22,6),(13,11,24,6),(13,11,25,12),(13,11,32,4),(13,11,34,9),(13,11,36,5),(13,11,37,2),(13,11,40,10),(13,11,41,3),(13,11,42,10),(13,12,1,8),(13,12,14,6),(13,12,19,6),(13,12,21,5),(13,12,23,2),(13,12,33,3),(13,12,41,12),(13,12,42,0),(13,13,13,11),(13,13,18,4),(13,13,19,13),(13,13,21,1),(13,13,23,1),(13,13,25,0),(13,13,27,1),(13,13,30,9),(13,13,34,2),(13,13,35,3),(13,13,39,4),(13,14,9,3),(13,14,10,6),(13,14,11,0),(13,14,27,2),(13,14,32,5),(13,14,38,7),(13,14,39,5),(13,15,17,12),(13,15,19,10),(13,15,22,5),(13,15,37,6),(13,15,39,9),(13,15,40,9),(13,16,6,11),(13,16,10,7),(13,16,12,7),(13,16,19,6),(13,16,22,4),(13,16,25,8),(13,16,39,1),(13,17,6,11),(13,17,7,7),(13,17,8,10),(13,17,18,10),(13,17,23,5),(13,17,24,11),(13,17,25,0),(13,17,35,0),(13,18,8,9),(13,18,16,0),(13,18,18,13),(13,18,20,7),(13,18,35,4),(13,19,8,2),(13,19,12,9),(13,19,13,0),(13,19,18,6),(13,19,22,5),(13,19,24,9),(13,19,28,8),(13,19,32,0),(13,19,36,6),(13,19,39,2),(17,0,1,10),(17,1,1,10),(17,1,3,3),(17,2,0,11),(17,2,4,0),(17,2,13,7),(17,3,4,11),(17,4,2,11),(17,4,12,3),(17,4,14,10),(17,5,6,2),(17,6,12,2),(17,6,14,10),(17,6,18,12),(17,6,22,4),(17,8,6,4),(17,9,8,0),(17,9,10,9),(17,9,17,0),(17,9,19,4),(17,10,12,2),(17,10,16,6),(17,11,12,5),(17,11,17,5),(17,11,20,11),(17,12,18,1),(17,12,19,0),(17,13,4,2),(17,13,6,9),(17,13,7,7),(17,13,10,6),(17,13,12,12),(17,13,15,10),(17,13,16,11),(17,14,7,10),(17,15,4,4),(17,15,5,0),(17,15,6,4),(17,17,7,12),(17,17,8,9),(17,17,9,1),(17,17,10,7),(17,17,13,6),(17,17,16,7),(17,18,3,4),(17,18,7,3),(17,19,1,8),(17,19,5,10),(17,19,13,13),(17,19,17,4),(17,19,21,2),(17,20,1,11),(17,20,6,5),(17,21,2,7),(17,23,0,9),(17,23,2,8),(17,24,1,11),(17,24,7,8),(17,24,12,10),(17,24,20,3),(17,25,6,0),(17,25,7,5),(17,25,8,12),(17,25,9,11),(17,25,11,1),(17,26,6,0),(17,27,0,11),(17,27,3,3),(17,27,5,4),(17,27,7,2),(17,27,13,5),(17,27,15,12),(17,28,4,5),(17,28,7,10),(17,28,16,6),(17,29,1,0),(17,29,7,0),(17,30,5,6),(17,30,9,10),(17,31,4,4),(17,31,8,10),(17,31,16,6),(17,31,19,1),(17,32,3,0),(17,32,21,3),(17,33,0,2),(17,33,2,5),(17,33,6,13),(17,33,8,7),(17,33,12,11),(17,33,14,6),(17,34,2,7),(17,35,1,9),(17,35,2,7),(17,35,3,8),(17,35,5,11),(17,36,12,6),(17,37,1,12),(17,37,2,5),(17,37,8,3),(17,38,12,9),(17,39,17,5),(17,40,5,12),(17,40,9,7),(17,41,12,9),(17,42,4,2),(17,42,8,5),(17,42,15,2),(17,43,15,9),(17,44,0,3),(17,44,16,9),(21,0,4,12),(21,0,15,13),(21,0,16,9),(21,0,18,4),(21,0,36,7),(21,0,38,8),(21,0,39,0),(21,0,41,5),(21,0,42,1),(21,1,9,13),(21,1,28,10),(21,1,36,1),(21,2,10,8),(21,2,11,10),(21,2,19,4),(21,2,22,4),(21,2,30,11),(21,2,31,10),(21,2,34,6),(21,2,35,7),(21,3,10,4),(21,3,32,6),(21,3,33,13),(21,4,33,2),(21,4,35,10),(21,4,36,2),(21,5,3,10),(21,5,22,7),(21,5,31,3),(21,5,33,3),(21,6,2,7),(21,6,24,1),(21,6,33,1),(21,6,34,3),(21,6,35,10),(21,7,2,9),(21,7,6,6),(21,7,20,7),(21,7,23,3),(21,7,33,0),(21,8,16,8),(21,8,17,9),(21,8,21,10),(21,8,22,13),(21,8,33,6),(21,8,34,10),(21,9,0,2),(21,9,6,2),(21,9,9,1),(21,9,22,6),(21,9,24,11),(21,9,26,7),(21,9,27,10),(21,9,39,2),(21,10,0,11),(21,10,9,0),(21,10,17,3),(21,10,30,4),(21,10,31,7),(21,11,9,13),(21,11,33,12),(21,12,9,2),(21,12,18,11),(21,12,20,3),(21,12,23,3),(21,12,25,1),(21,12,27,13),(21,12,43,11),(21,13,9,9),(21,13,10,7),(21,13,24,8),(21,13,26,5),(21,13,28,7),(21,13,29,1),(21,14,21,13),(21,14,31,2),(21,15,19,11),(21,15,32,9),(21,16,23,7),(21,16,28,3),(21,16,29,3),(21,17,9,5),(21,17,12,12),(21,17,14,2),(21,17,15,0),(21,17,18,0),(21,17,20,7),(21,17,21,1),(21,17,42,1),(21,18,12,13),(21,18,13,1),(21,18,14,7),(21,18,16,6),(21,18,22,12),(21,18,26,11),(21,18,28,7),(21,19,15,1),(21,19,25,10),(21,20,14,12),(21,20,15,7),(21,20,16,10),(21,20,23,10),(21,20,25,6),(21,20,26,7),(21,20,27,6),(21,21,7,0),(21,21,22,4),(21,21,25,2),(21,21,31,4),(21,21,34,0),(30,0,7,7),(30,0,12,0),(30,2,3,6),(30,2,29,11),(30,3,2,8),(30,3,29,11),(30,4,9,11),(30,4,14,7),(30,5,8,3),(30,5,15,10),(30,5,16,8),(30,5,17,5),(30,5,19,5),(30,5,23,6),(30,5,24,3),(30,5,27,11),(30,5,29,11),(30,6,5,6),(30,6,19,3),(30,6,24,6),(30,7,0,11),(30,7,14,11),(30,7,15,7),(30,7,21,10),(30,7,25,7),(30,8,24,5),(30,8,25,12),(30,8,27,4),(30,9,7,10),(30,9,21,3),(30,9,23,3),(30,9,24,3),(30,10,7,8),(30,11,0,2),(30,11,10,1),(30,11,20,1),(30,12,7,3),(30,12,20,4),(30,13,0,8),(30,13,8,5),(30,13,11,1),(30,13,13,12),(30,13,20,4),(30,13,21,6),(30,14,3,7),(30,14,11,1),(30,15,1,10),(30,15,2,7),(30,15,3,10),(30,15,12,2),(30,16,8,3),(30,16,9,9),(30,16,13,3),(30,16,20,2),(30,16,22,6),(30,17,3,8),(30,17,7,5),(30,17,13,5),(30,18,7,11),(30,18,22,12),(30,19,12,1),(30,19,13,7),(30,19,17,9),(30,20,2,7),(30,20,5,7),(30,20,7,10),(30,20,10,13),(30,20,14,0),(30,20,18,6),(30,21,3,10),(30,21,7,9),(30,21,12,4),(30,21,15,4),(30,21,18,7),(30,21,24,4),(30,22,13,5),(30,22,20,13),(30,22,21,5),(30,23,6,13),(30,23,17,6),(30,23,18,4),(30,24,9,0),(30,24,13,3),(30,24,17,11),(30,25,9,6),(30,25,10,5),(30,25,11,0),(30,26,3,4),(30,26,10,5),(30,26,12,11),(30,26,29,4),(30,27,0,5),(30,27,2,6),(30,27,4,10),(30,28,17,2),(30,28,18,4),(30,29,14,3),(30,29,16,5),(30,29,23,9),(30,29,27,6),(30,29,28,9),(30,29,29,4),(31,0,2,6),(31,0,9,3),(31,0,11,10),(31,0,26,12),(31,0,27,9),(31,0,36,2),(31,0,37,11),(31,1,2,5),(31,1,10,12),(31,1,12,12),(31,1,21,1),(31,1,23,7),(31,1,27,6),(31,1,34,3),(31,1,35,1),(31,1,37,5),(31,2,1,7),(31,2,17,2),(31,2,20,5),(31,3,6,0),(31,3,11,4),(31,3,14,6),(31,3,20,2),(31,3,21,4),(31,3,32,3),(31,3,33,0),(31,3,34,13),(31,4,0,5),(31,4,6,7),(31,4,11,13),(31,4,29,12),(31,4,33,4),(31,5,3,13),(31,5,6,3),(31,5,17,10),(31,5,34,11),(31,5,35,13),(31,6,3,4),(31,6,5,7),(31,6,9,5),(31,6,15,2),(31,6,16,2),(31,6,19,7),(31,6,31,4),(31,6,32,13),(31,6,35,3),(31,7,15,4),(31,7,16,12),(31,7,18,3),(31,7,30,4),(31,7,33,13),(31,9,19,7),(31,9,21,5),(31,9,37,2),(31,10,16,5),(31,10,18,0),(31,10,25,13),(31,10,36,8),(31,11,0,1),(31,11,1,1),(31,11,3,4),(31,11,4,4),(31,11,12,10),(31,11,15,3),(31,11,18,10),(31,11,22,2),(31,11,23,0),(31,11,27,3),(31,11,32,4),(31,12,3,2),(31,12,5,13),(31,12,13,5),(31,12,14,0),(31,12,17,4),(31,12,19,1),(31,12,22,2),(31,12,25,4),(31,12,28,5),(31,12,31,6),(31,13,2,0),(31,13,3,0),(31,13,9,4),(31,13,10,5),(31,13,17,10),(31,13,23,0),(31,13,24,4),(31,13,33,6),(31,13,34,1),(31,14,5,7),(31,14,10,11),(31,14,14,2),(31,15,3,7),(31,15,4,5),(31,15,9,9),(31,15,26,13),(31,16,2,9),(31,16,3,2),(31,16,4,4),(31,16,9,3),(31,16,20,3),(31,16,21,7),(31,16,26,3),(42,0,0,5),(42,0,8,6),(42,0,11,0),(42,0,18,4),(42,0,25,12),(42,0,34,1),(42,0,45,5),(42,0,48,5),(42,1,1,0),(42,1,2,0),(42,1,16,1),(42,1,26,10),(42,1,29,7),(42,1,35,0),(42,1,37,7),(42,1,40,12),(42,1,41,1),(42,1,42,6),(42,1,48,3),(42,2,16,12),(42,2,17,7),(42,2,20,13),(42,2,24,10),(42,2,28,3),(42,2,31,10),(42,2,42,11),(42,2,45,9),(42,3,0,0),(42,3,16,5),(42,3,30,12),(42,3,33,0),(42,3,44,1),(42,3,45,13),(42,3,46,3),(42,3,48,6),(42,4,10,10),(42,4,12,1),(42,4,14,4),(42,4,16,7),(42,4,17,0),(42,4,34,3),(42,4,35,3),(42,4,36,3),(42,4,48,10),(42,5,0,12),(42,5,13,1),(42,5,16,2),(42,5,42,2),(42,5,46,10),(42,5,48,3),(42,6,18,4),(42,6,26,7),(42,6,33,10),(42,6,41,11),(42,7,0,13),(42,7,3,11),(42,7,11,5),(42,7,17,8),(42,7,20,0),(42,7,39,1),(42,7,45,0),(42,7,46,6),(42,8,0,11),(42,8,3,11),(42,8,8,6),(42,8,24,3),(42,8,26,13),(42,8,46,2),(42,9,2,2),(42,9,14,1),(42,9,16,5),(42,9,22,11),(42,9,28,1),(42,9,36,0),(42,9,37,5),(42,9,45,5),(42,10,5,6),(42,10,12,1),(42,10,13,7),(42,10,15,11),(42,10,21,13),(42,10,24,4),(42,10,34,1),(42,10,39,6),(42,10,41,5),(42,10,47,7),(42,11,15,1),(42,11,18,3),(42,11,19,12),(42,11,21,5),(42,11,22,1),(42,11,26,7),(42,11,30,1),(42,11,36,2),(42,11,40,0),(42,11,41,7),(42,12,12,4),(42,12,15,0),(42,12,18,5),(42,12,24,6),(42,12,35,0),(42,12,43,12),(42,13,5,2),(42,13,12,7),(42,13,13,5),(42,13,15,3),(42,13,19,10),(42,13,25,6),(42,13,33,12),(42,13,34,2),(42,14,3,7),(42,14,19,12),(42,14,21,2),(42,14,22,1),(42,14,25,13),(42,14,27,2),(42,14,34,2),(42,14,42,3),(42,14,44,0),(42,15,5,3),(42,15,10,2),(42,15,11,5),(42,15,21,11),(42,15,22,7),(42,15,25,5),(42,15,28,2),(42,15,37,4),(42,15,38,11),(42,15,40,11),(42,15,41,7),(42,15,42,13),(42,16,0,0),(42,16,5,7),(42,16,22,13),(42,16,23,3),(42,16,25,13),(42,16,27,4),(42,16,30,3),(42,16,35,11),(42,16,42,0),(42,17,2,6),(42,17,18,4),(42,17,19,4),(42,17,23,1),(42,17,26,11),(42,17,27,4),(42,17,28,1),(42,17,29,1),(42,17,33,2),(42,17,34,12),(42,17,37,5),(42,17,38,11),(42,17,39,13),(42,18,6,11),(42,18,7,6),(42,18,17,0),(42,18,18,7),(42,18,27,5),(42,18,30,4),(42,18,33,6),(42,18,37,1),(42,18,44,1),(42,19,1,11),(42,19,4,3),(42,19,7,13),(42,19,18,0),(42,19,20,1),(42,19,24,5),(42,19,29,3),(42,20,3,1),(42,20,7,7),(42,20,17,11),(42,20,22,1),(42,20,29,0),(42,20,37,5),(42,20,38,12),(42,21,5,7),(42,21,12,10),(42,21,14,13),(42,21,15,6),(42,21,19,13),(42,21,22,5),(42,21,26,13),(42,21,30,5),(42,22,9,6),(42,22,10,6),(42,22,12,10),(42,22,13,11),(42,22,16,4),(42,22,38,2),(42,22,40,1),(42,23,6,5),(42,23,7,12),(42,23,8,1),(42,23,9,12),(42,23,13,5),(42,23,14,7),(42,23,17,1),(42,23,19,2),(42,23,22,0),(42,23,24,13),(42,23,27,1),(42,23,28,12),(42,23,30,4),(42,23,31,1),(42,24,14,13),(42,24,18,4),(42,24,19,0),(42,24,22,2),(42,24,23,6),(42,24,26,13),(42,24,28,11),(42,24,29,5),(42,24,30,5),(42,24,32,12),(42,24,36,4),(42,25,6,11),(42,25,15,4),(42,25,16,7),(42,25,18,4),(42,25,20,12),(42,25,29,1),(42,26,10,11),(42,26,22,4),(42,26,24,11),(42,26,26,3),(42,26,27,2),(42,26,30,6),(42,26,39,8),(42,27,7,10),(42,27,14,13),(42,27,16,2),(42,27,20,7),(42,27,21,0),(42,27,22,11),(42,27,24,3),(42,27,26,4),(42,27,31,2),(42,27,48,1),(42,28,14,12),(42,28,26,7),(42,28,27,1),(42,28,47,2),(42,29,21,10),(42,29,23,10),(42,29,27,4);
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
INSERT INTO `fow_ss_entries` VALUES (1,3,1,1,1,0,0,0,NULL,NULL,NULL,NULL,NULL);
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
INSERT INTO `galaxies` VALUES (1,'2010-11-19 14:36:41','dev');
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
INSERT INTO `objectives` VALUES (1,1,'HaveUpgradedTo','Building::MetalExtractor',1,1,0,0),(2,1,'HaveUpgradedTo','Building::SolarPlant',2,1,0,0),(3,2,'HaveUpgradedTo','Building::Barracks',1,1,0,0),(4,3,'UpgradeTo','Unit::Trooper',3,1,0,0),(5,4,'UpgradeTo','Unit::Shocker',2,1,0,0),(6,5,'Destroy','Unit::Gnat',10,1,0,0),(7,5,'Destroy','Unit::Glancer',5,1,0,0),(8,6,'HaveUpgradedTo','Building::GroundFactory',1,1,0,0),(9,7,'HaveUpgradedTo','Building::SpaceFactory',1,1,0,0),(10,8,'AnnexPlanet','SsObject::Planet',1,NULL,0,1),(11,9,'AnnexPlanet','SsObject::Planet',1,NULL,0,0),(12,10,'HaveUpgradedTo','Unit::Trooper',10,1,0,0),(13,10,'HaveUpgradedTo','Unit::Shocker',5,1,0,0),(14,10,'HaveUpgradedTo','Unit::Seeker',5,1,0,0);
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
INSERT INTO `schema_migrations` VALUES ('20090601175224'),('20090601184051'),('20090601184055'),('20090601184059'),('20090701164131'),('20090713165021'),('20090808144214'),('20090809160211'),('20090810173759'),('20090826140238'),('20090826141836'),('20090829202538'),('20090829210029'),('20090829224505'),('20090830143959'),('20090830145319'),('20090901153809'),('20090904190655'),('20090905175341'),('20090905192056'),('20090906135044'),('20090909222719'),('20090911180950'),('20090912165229'),('20090919155819'),('20091024222359'),('20091103164416'),('20091103180558'),('20091103181146'),('20091109191211'),('20091225193714'),('20100114152902'),('20100121142414'),('20100127115341'),('20100127120219'),('20100127120515'),('20100127121337'),('20100129150736'),('20100203202757'),('20100203204803'),('20100204172507'),('20100204173714'),('20100208163239'),('20100210114531'),('20100212134334'),('20100218181507'),('20100219114448'),('20100220144106'),('20100222144003'),('20100223153023'),('20100224153728'),('20100224163525'),('20100225124928'),('20100225153721'),('20100225155505'),('20100225155739'),('20100226122144'),('20100226122651'),('20100301153626'),('20100302131225'),('20100303131706'),('20100308163148'),('20100308164422'),('20100310172315'),('20100310181338'),('20100311123523'),('20100315112858'),('20100319141401'),('20100322184529'),('20100324134243'),('20100324141652'),('20100331125702'),('20100415130556'),('20100415130600'),('20100415130605'),('20100415134627'),('20100419141518'),('20100419142018'),('20100419164230'),('20100426141509'),('20100428130912'),('20100429171200'),('20100430174140'),('20100610151652'),('20100610180750'),('20100614142225'),('20100614160819'),('20100614162423'),('20100616132525'),('20100616135507'),('20100622124252'),('20100706105523'),('20100710121447'),('20100710191351'),('20100716155807'),('20100719131622'),('20100721155359'),('20100722124307'),('20100812164444'),('20100812164449'),('20100812164518'),('20100812164524'),('20100817165213'),('20100819175736'),('20100820185846'),('20100906095758'),('20100915145823'),('20100929111549'),('20101001155323'),('20101005180058'),('20101022155620'),('20101117131430'),('99999999999000'),('99999999999900');
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
INSERT INTO `solar_systems` VALUES (1,'Resource',1,2,1),(2,'Expansion',1,2,2),(3,'Homeworld',1,1,2),(4,'Expansion',1,2,0);
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
  `name` varchar(20) NOT NULL DEFAULT '',
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
  PRIMARY KEY (`id`),
  UNIQUE KEY `uniqueness` (`solar_system_id`,`position`,`angle`),
  KEY `index_planets_on_galaxy_id_and_solar_system_id` (`solar_system_id`),
  KEY `index_planets_on_player_id_and_galaxy_id` (`player_id`),
  KEY `group_by_for_fowssentry_status_updates` (`player_id`,`solar_system_id`),
  CONSTRAINT `ss_objects_ibfk_1` FOREIGN KEY (`solar_system_id`) REFERENCES `solar_systems` (`id`) ON DELETE CASCADE,
  CONSTRAINT `ss_objects_ibfk_2` FOREIGN KEY (`player_id`) REFERENCES `players` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=49 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ss_objects`
--

LOCK TABLES `ss_objects` WRITE;
/*!40000 ALTER TABLE `ss_objects` DISABLE KEYS */;
INSERT INTO `ss_objects` VALUES (1,1,0,0,1,45,'Asteroid',NULL,'',44,0,0,0,1,0,0,2,0,0,1,NULL,0),(2,1,35,43,2,120,'Planet',NULL,'P-2',57,0,0,0,0,0,0,0,0,0,0,'2010-11-19 14:36:47',0),(3,1,0,0,2,210,'Asteroid',NULL,'',48,0,0,0,1,0,0,2,0,0,2,NULL,0),(4,1,0,0,3,202,'Jumpgate',NULL,'',53,0,0,0,0,0,0,0,0,0,0,NULL,0),(5,1,0,0,2,60,'Asteroid',NULL,'',33,0,0,0,0,0,0,1,0,0,1,NULL,0),(6,1,0,0,1,0,'Asteroid',NULL,'',33,0,0,0,1,0,0,2,0,0,1,NULL,0),(7,1,0,0,1,270,'Asteroid',NULL,'',53,0,0,0,1,0,0,1,0,0,2,NULL,0),(8,1,0,0,2,30,'Asteroid',NULL,'',42,0,0,0,1,0,0,1,0,0,0,NULL,0),(9,1,0,0,0,90,'Asteroid',NULL,'',47,0,0,0,1,0,0,1,0,0,3,NULL,0),(10,1,0,0,2,180,'Asteroid',NULL,'',47,0,0,0,3,0,0,3,0,0,2,NULL,0),(11,1,0,0,1,135,'Asteroid',NULL,'',42,0,0,0,1,0,0,3,0,0,3,NULL,0),(12,1,0,0,3,270,'Jumpgate',NULL,'',31,0,0,0,0,0,0,0,0,0,0,NULL,0),(13,1,20,45,0,180,'Planet',NULL,'P-13',52,0,0,0,0,0,0,0,0,0,0,'2010-11-19 14:36:47',0),(14,1,0,0,0,0,'Asteroid',NULL,'',47,0,0,0,1,0,0,0,0,0,0,NULL,0),(15,2,0,0,2,90,'Asteroid',NULL,'',31,0,0,0,1,0,0,0,0,0,0,NULL,0),(16,2,0,0,2,30,'Asteroid',NULL,'',44,0,0,0,0,0,0,0,0,0,1,NULL,0),(17,2,45,23,0,90,'Planet',NULL,'P-17',53,1,0,0,0,0,0,0,0,0,0,'2010-11-19 14:36:47',0),(18,2,0,0,2,210,'Asteroid',NULL,'',47,0,0,0,1,0,0,2,0,0,3,NULL,0),(19,2,0,0,1,180,'Asteroid',NULL,'',29,0,0,0,1,0,0,1,0,0,1,NULL,0),(20,2,0,0,3,202,'Jumpgate',NULL,'',39,0,0,0,0,0,0,0,0,0,0,NULL,0),(21,2,22,44,2,240,'Planet',NULL,'P-21',52,2,0,0,0,0,0,0,0,0,0,'2010-11-19 14:36:47',0),(22,2,0,0,0,180,'Asteroid',NULL,'',26,0,0,0,1,0,0,0,0,0,0,NULL,0),(23,2,0,0,1,0,'Asteroid',NULL,'',42,0,0,0,1,0,0,1,0,0,1,NULL,0),(24,2,0,0,1,270,'Asteroid',NULL,'',44,0,0,0,1,0,0,1,0,0,0,NULL,0),(25,2,0,0,0,0,'Asteroid',NULL,'',45,0,0,0,2,0,0,2,0,0,2,NULL,0),(26,3,0,0,1,90,'Asteroid',NULL,'',60,0,0,0,1,0,0,0,0,0,1,NULL,0),(27,3,0,0,1,135,'Asteroid',NULL,'',56,0,0,0,0,0,0,1,0,0,1,NULL,0),(28,3,0,0,0,270,'Asteroid',NULL,'',58,0,0,0,1,0,0,0,0,0,0,NULL,0),(29,3,0,0,3,156,'Jumpgate',NULL,'',28,0,0,0,0,0,0,0,0,0,0,NULL,0),(30,3,30,30,1,315,'Planet',1,'P-30',50,0,864,1,3024,1728,2,6048,0,0,604.8,'2010-11-19 14:36:47',0),(31,3,17,38,2,270,'Planet',NULL,'P-31',48,2,0,0,0,0,0,0,0,0,0,'2010-11-19 14:36:47',0),(32,3,0,0,1,0,'Asteroid',NULL,'',34,0,0,0,0,0,0,1,0,0,1,NULL,0),(33,3,0,0,0,180,'Asteroid',NULL,'',28,0,0,0,1,0,0,1,0,0,1,NULL,0),(34,4,0,0,1,225,'Asteroid',NULL,'',32,0,0,0,2,0,0,3,0,0,3,NULL,0),(35,4,0,0,2,120,'Asteroid',NULL,'',49,0,0,0,3,0,0,3,0,0,1,NULL,0),(36,4,0,0,3,314,'Jumpgate',NULL,'',40,0,0,0,0,0,0,0,0,0,0,NULL,0),(37,4,0,0,1,180,'Asteroid',NULL,'',33,0,0,0,1,0,0,3,0,0,2,NULL,0),(38,4,0,0,1,0,'Asteroid',NULL,'',60,0,0,0,1,0,0,1,0,0,0,NULL,0),(39,4,0,0,2,60,'Asteroid',NULL,'',60,0,0,0,1,0,0,1,0,0,1,NULL,0),(40,4,0,0,1,270,'Asteroid',NULL,'',54,0,0,0,1,0,0,0,0,0,0,NULL,0),(41,4,0,0,2,30,'Asteroid',NULL,'',40,0,0,0,0,0,0,1,0,0,0,NULL,0),(42,4,30,49,0,90,'Planet',NULL,'P-42',58,2,0,0,0,0,0,0,0,0,0,'2010-11-19 14:36:47',0),(43,4,0,0,1,135,'Asteroid',NULL,'',37,0,0,0,0,0,0,1,0,0,0,NULL,0),(44,4,0,0,2,330,'Asteroid',NULL,'',58,0,0,0,2,0,0,1,0,0,1,NULL,0),(45,4,0,0,3,336,'Jumpgate',NULL,'',51,0,0,0,0,0,0,0,0,0,0,NULL,0),(46,4,0,0,0,180,'Asteroid',NULL,'',53,0,0,0,0,0,0,1,0,0,0,NULL,0),(47,4,0,0,2,300,'Asteroid',NULL,'',46,0,0,0,3,0,0,3,0,0,3,NULL,0),(48,4,0,0,0,0,'Asteroid',NULL,'',37,0,0,0,3,0,0,3,0,0,2,NULL,0);
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
INSERT INTO `tiles` VALUES (4,2,0,7),(4,2,0,8),(4,2,0,9),(4,2,0,11),(4,2,0,12),(4,2,0,13),(6,2,0,28),(6,2,0,29),(6,2,0,30),(6,2,0,31),(6,2,0,32),(6,2,0,33),(6,2,0,34),(4,2,1,4),(4,2,1,7),(4,2,1,9),(4,2,1,10),(4,2,1,12),(4,2,1,13),(6,2,1,28),(6,2,1,29),(6,2,1,30),(6,2,1,31),(6,2,1,32),(6,2,1,33),(6,2,1,34),(4,2,2,1),(4,2,2,3),(4,2,2,4),(4,2,2,8),(4,2,2,9),(4,2,2,10),(4,2,2,11),(4,2,2,12),(4,2,2,13),(4,2,2,15),(4,2,2,16),(4,2,2,17),(6,2,2,27),(6,2,2,28),(6,2,2,29),(6,2,2,30),(6,2,2,32),(6,2,2,33),(10,2,2,38),(4,2,3,1),(4,2,3,4),(4,2,3,5),(4,2,3,8),(4,2,3,9),(4,2,3,10),(4,2,3,11),(4,2,3,12),(4,2,3,13),(4,2,3,14),(4,2,3,15),(4,2,3,17),(4,2,3,18),(4,2,3,19),(3,2,3,21),(3,2,3,22),(3,2,3,25),(6,2,3,26),(6,2,3,27),(6,2,3,28),(5,2,3,34),(5,2,3,35),(4,2,4,1),(4,2,4,2),(4,2,4,4),(4,2,4,5),(4,2,4,6),(4,2,4,9),(4,2,4,10),(4,2,4,11),(4,2,4,12),(4,2,4,13),(4,2,4,14),(4,2,4,15),(4,2,4,16),(4,2,4,17),(4,2,4,18),(3,2,4,22),(3,2,4,24),(3,2,4,25),(3,2,4,26),(6,2,4,27),(5,2,4,34),(5,2,4,35),(4,2,5,0),(4,2,5,1),(4,2,5,4),(4,2,5,5),(4,2,5,8),(4,2,5,9),(4,2,5,11),(4,2,5,12),(4,2,5,13),(4,2,5,14),(4,2,5,15),(4,2,5,16),(4,2,5,17),(4,2,5,18),(3,2,5,22),(3,2,5,23),(3,2,5,24),(3,2,5,25),(3,2,5,26),(6,2,5,27),(6,2,5,28),(5,2,5,32),(5,2,5,33),(5,2,5,34),(5,2,5,35),(4,2,6,1),(4,2,6,2),(4,2,6,3),(4,2,6,4),(4,2,6,6),(4,2,6,7),(4,2,6,8),(4,2,6,9),(4,2,6,11),(4,2,6,12),(4,2,6,13),(4,2,6,14),(4,2,6,15),(4,2,6,17),(4,2,6,18),(3,2,6,22),(3,2,6,23),(3,2,6,24),(3,2,6,25),(3,2,6,26),(3,2,6,27),(6,2,6,28),(5,2,6,32),(5,2,6,33),(5,2,6,34),(5,2,6,35),(5,2,6,36),(5,2,6,37),(4,2,7,0),(4,2,7,2),(4,2,7,3),(4,2,7,4),(4,2,7,5),(4,2,7,6),(4,2,7,8),(4,2,7,13),(4,2,7,14),(4,2,7,15),(3,2,7,21),(3,2,7,22),(3,2,7,24),(3,2,7,25),(3,2,7,26),(3,2,7,27),(6,2,7,28),(6,2,7,29),(5,2,7,33),(5,2,7,34),(5,2,7,37),(4,2,8,0),(4,2,8,1),(4,2,8,2),(4,2,8,3),(4,2,8,4),(4,2,8,5),(4,2,8,6),(4,2,8,7),(4,2,8,14),(4,2,8,15),(4,2,8,16),(3,2,8,22),(3,2,8,23),(3,2,8,24),(3,2,8,25),(3,2,8,26),(6,2,8,27),(6,2,8,29),(5,2,8,34),(5,2,8,35),(2,2,8,37),(8,2,8,40),(4,2,9,0),(4,2,9,1),(4,2,9,2),(4,2,9,3),(4,2,9,4),(4,2,9,5),(4,2,9,14),(3,2,9,21),(3,2,9,22),(3,2,9,23),(3,2,9,24),(3,2,9,25),(6,2,9,26),(6,2,9,27),(6,2,9,28),(6,2,9,29),(6,2,9,30),(4,2,10,0),(4,2,10,1),(4,2,10,2),(4,2,10,3),(4,2,10,5),(4,2,10,6),(3,2,10,23),(6,2,10,25),(6,2,10,26),(6,2,10,27),(6,2,10,28),(6,2,10,29),(6,2,10,30),(4,2,11,0),(5,2,11,1),(4,2,11,2),(4,2,11,3),(4,2,11,4),(4,2,11,5),(4,2,11,6),(4,2,11,7),(6,2,11,25),(6,2,11,26),(6,2,11,27),(6,2,11,28),(6,2,11,29),(6,2,11,30),(10,2,11,31),(9,2,11,40),(4,2,12,0),(5,2,12,1),(4,2,12,2),(4,2,12,3),(0,2,12,27),(6,2,12,30),(5,2,13,0),(5,2,13,1),(5,2,13,2),(4,2,13,3),(3,2,13,26),(3,2,13,30),(5,2,14,0),(5,2,14,1),(5,2,14,2),(4,2,14,3),(3,2,14,26),(3,2,14,27),(3,2,14,28),(3,2,14,29),(3,2,14,30),(3,2,14,35),(5,2,15,1),(5,2,15,2),(3,2,15,20),(3,2,15,27),(3,2,15,28),(3,2,15,29),(3,2,15,30),(3,2,15,31),(3,2,15,32),(3,2,15,33),(3,2,15,34),(3,2,15,35),(3,2,15,36),(5,2,16,0),(5,2,16,1),(5,2,16,2),(5,2,16,3),(5,2,16,16),(3,2,16,20),(3,2,16,26),(3,2,16,27),(3,2,16,28),(3,2,16,29),(3,2,16,30),(3,2,16,31),(0,2,16,32),(0,2,16,38),(13,2,16,41),(5,2,17,0),(3,2,17,1),(5,2,17,2),(5,2,17,3),(5,2,17,4),(5,2,17,16),(3,2,17,20),(3,2,17,21),(3,2,17,22),(3,2,17,23),(3,2,17,24),(3,2,17,26),(3,2,17,27),(3,2,17,28),(3,2,17,29),(3,2,17,30),(3,2,17,31),(3,2,18,1),(3,2,18,2),(3,2,18,3),(5,2,18,4),(5,2,18,15),(5,2,18,16),(5,2,18,17),(5,2,18,18),(5,2,18,19),(5,2,18,20),(3,2,18,21),(3,2,18,22),(3,2,18,23),(3,2,18,24),(3,2,18,30),(3,2,18,31),(3,2,18,32),(3,2,19,0),(3,2,19,1),(3,2,19,3),(3,2,19,4),(5,2,19,15),(5,2,19,16),(5,2,19,17),(5,2,19,18),(3,2,19,19),(3,2,19,20),(3,2,19,21),(3,2,19,22),(3,2,19,23),(3,2,19,24),(3,2,19,25),(3,2,19,31),(3,2,19,32),(14,2,19,35),(3,2,20,0),(3,2,20,1),(3,2,20,2),(3,2,20,3),(3,2,20,4),(3,2,20,5),(3,2,20,6),(3,2,20,7),(5,2,20,15),(5,2,20,16),(5,2,20,18),(3,2,20,19),(3,2,20,20),(3,2,20,21),(3,2,21,0),(3,2,21,2),(3,2,21,3),(3,2,21,4),(3,2,21,5),(3,2,21,6),(3,2,21,7),(5,2,21,15),(5,2,21,16),(5,2,21,17),(3,2,21,20),(3,2,21,21),(3,2,21,22),(2,2,21,31),(3,2,22,0),(3,2,22,3),(3,2,22,4),(3,2,22,6),(5,2,22,15),(3,2,22,18),(3,2,22,19),(3,2,22,20),(3,2,22,21),(3,2,22,22),(3,2,22,23),(4,2,22,33),(8,2,22,40),(3,2,23,0),(3,2,23,1),(3,2,23,2),(3,2,23,3),(3,2,23,5),(3,2,23,6),(3,2,23,7),(3,2,23,18),(3,2,23,19),(6,2,23,20),(3,2,23,21),(3,2,23,22),(4,2,23,31),(4,2,23,32),(4,2,23,33),(4,2,23,35),(0,2,23,37),(3,2,24,6),(6,2,24,20),(3,2,24,22),(4,2,24,29),(4,2,24,30),(4,2,24,31),(4,2,24,32),(4,2,24,33),(4,2,24,34),(4,2,24,35),(6,2,25,19),(6,2,25,20),(6,2,25,21),(3,2,25,23),(3,2,25,24),(4,2,25,31),(4,2,25,32),(4,2,25,33),(6,2,26,19),(6,2,26,20),(6,2,26,21),(3,2,26,23),(3,2,26,24),(4,2,26,32),(4,2,26,33),(6,2,27,17),(6,2,27,18),(6,2,27,19),(6,2,27,20),(6,2,27,21),(3,2,27,23),(4,2,27,28),(1,2,27,31),(4,2,27,33),(4,2,27,38),(6,2,28,17),(6,2,28,18),(6,2,28,19),(6,2,28,20),(6,2,28,21),(6,2,28,22),(3,2,28,23),(3,2,28,24),(4,2,28,26),(4,2,28,27),(4,2,28,28),(4,2,28,33),(4,2,28,34),(4,2,28,35),(4,2,28,36),(4,2,28,37),(4,2,28,38),(6,2,29,18),(6,2,29,19),(6,2,29,20),(3,2,29,21),(3,2,29,22),(3,2,29,23),(3,2,29,24),(3,2,29,25),(3,2,29,26),(4,2,29,27),(4,2,29,28),(4,2,29,29),(4,2,29,30),(4,2,29,31),(4,2,29,32),(4,2,29,33),(4,2,29,34),(0,2,29,35),(0,2,29,39),(5,2,30,18),(6,2,30,19),(3,2,30,20),(3,2,30,21),(3,2,30,22),(3,2,30,23),(3,2,30,24),(3,2,30,25),(3,2,30,26),(4,2,30,29),(4,2,30,30),(4,2,30,31),(4,2,30,32),(4,2,30,33),(4,2,30,34),(5,2,31,18),(3,2,31,19),(3,2,31,20),(3,2,31,21),(3,2,31,24),(3,2,31,25),(4,2,31,28),(4,2,31,29),(4,2,31,30),(4,2,31,31),(4,2,31,32),(4,2,31,33),(4,2,31,34),(4,2,31,35),(4,2,31,36),(5,2,32,15),(5,2,32,17),(5,2,32,18),(3,2,32,19),(5,2,32,20),(3,2,32,21),(3,2,32,22),(3,2,32,23),(3,2,32,24),(3,2,32,25),(4,2,32,30),(0,2,32,31),(4,2,32,33),(4,2,32,36),(5,2,33,15),(5,2,33,16),(5,2,33,17),(5,2,33,18),(5,2,33,19),(5,2,33,20),(3,2,33,21),(3,2,33,22),(3,2,33,23),(4,2,33,30),(4,2,33,33),(5,2,34,15),(5,2,34,16),(5,2,34,17),(5,2,34,18),(5,2,34,19),(5,2,34,20),(5,2,34,21),(3,2,34,23),(4,2,34,27),(4,2,34,28),(4,2,34,29),(4,2,34,30),(4,2,34,31),(4,2,34,32),(4,2,34,33),(3,13,0,1),(3,13,0,2),(4,13,0,15),(4,13,0,16),(4,13,0,17),(4,13,0,18),(4,13,0,19),(5,13,0,30),(5,13,0,31),(5,13,0,32),(3,13,1,0),(3,13,1,1),(3,13,1,2),(4,13,1,16),(4,13,1,17),(4,13,1,18),(4,13,1,19),(5,13,1,30),(5,13,1,31),(5,13,1,32),(5,13,1,35),(3,13,2,1),(4,13,2,14),(4,13,2,15),(4,13,2,16),(4,13,2,17),(4,13,2,18),(4,13,2,19),(4,13,2,20),(4,13,2,21),(5,13,2,31),(5,13,2,32),(5,13,2,33),(5,13,2,34),(5,13,2,35),(5,13,2,36),(5,13,2,37),(5,13,2,38),(1,13,2,40),(3,13,3,0),(3,13,3,1),(3,13,3,2),(3,13,3,3),(4,13,3,14),(4,13,3,16),(4,13,3,17),(6,13,3,18),(6,13,3,19),(4,13,3,20),(4,13,3,21),(0,13,3,30),(5,13,3,32),(5,13,3,33),(2,13,3,35),(5,13,3,38),(3,13,4,0),(3,13,4,1),(3,13,4,2),(3,13,4,3),(3,13,4,13),(3,13,4,14),(3,13,4,15),(6,13,4,18),(6,13,4,19),(4,13,4,21),(5,13,4,32),(5,13,4,33),(3,13,5,3),(3,13,5,14),(3,13,5,15),(3,13,5,16),(6,13,5,19),(6,13,5,20),(6,13,5,21),(6,13,5,22),(8,13,6,0),(3,13,6,14),(3,13,6,15),(3,13,6,16),(6,13,6,19),(6,13,6,20),(6,13,6,21),(6,13,6,22),(4,13,6,29),(4,13,6,30),(4,13,6,31),(11,13,6,33),(3,13,7,15),(3,13,7,16),(6,13,7,19),(6,13,7,20),(6,13,7,21),(6,13,7,22),(6,13,7,23),(6,13,7,24),(4,13,7,26),(4,13,7,27),(4,13,7,28),(4,13,7,29),(4,13,7,30),(4,13,7,31),(4,13,7,32),(1,13,7,42),(3,13,8,15),(3,13,8,16),(6,13,8,20),(6,13,8,21),(6,13,8,22),(6,13,8,23),(6,13,8,24),(4,13,8,27),(4,13,8,28),(4,13,8,29),(4,13,8,30),(4,13,8,32),(3,13,9,14),(3,13,9,15),(6,13,9,21),(6,13,9,22),(6,13,9,24),(4,13,9,27),(4,13,9,28),(4,13,9,29),(4,13,10,28),(4,13,10,29),(13,13,10,43),(4,13,11,2),(4,13,11,3),(4,13,11,4),(5,13,11,7),(3,13,11,15),(3,13,11,16),(4,13,11,28),(4,13,12,2),(4,13,12,3),(4,13,12,4),(4,13,12,5),(5,13,12,7),(5,13,12,8),(3,13,12,15),(3,13,12,16),(3,13,12,17),(4,13,12,27),(4,13,12,28),(0,13,12,36),(4,13,13,0),(4,13,13,1),(4,13,13,2),(4,13,13,3),(5,13,13,4),(4,13,13,5),(5,13,13,7),(5,13,13,8),(5,13,13,9),(5,13,13,10),(3,13,13,14),(3,13,13,15),(3,13,13,16),(3,13,13,17),(5,13,13,28),(5,13,13,29),(5,13,13,31),(5,13,13,32),(0,13,13,40),(4,13,14,0),(6,13,14,1),(4,13,14,2),(4,13,14,3),(5,13,14,4),(5,13,14,5),(5,13,14,6),(5,13,14,7),(5,13,14,8),(3,13,14,14),(3,13,14,15),(3,13,14,16),(3,13,14,17),(5,13,14,28),(5,13,14,29),(5,13,14,30),(5,13,14,31),(4,13,14,42),(4,13,15,0),(4,13,15,1),(4,13,15,2),(4,13,15,3),(4,13,15,4),(5,13,15,5),(5,13,15,6),(5,13,15,7),(5,13,15,8),(5,13,15,9),(3,13,15,15),(3,13,15,16),(6,13,15,27),(5,13,15,29),(5,13,15,30),(5,13,15,31),(5,13,15,32),(5,13,15,33),(5,13,15,34),(5,13,15,35),(4,13,15,42),(4,13,16,0),(4,13,16,1),(4,13,16,2),(9,13,16,3),(5,13,16,7),(5,13,16,8),(3,13,16,13),(3,13,16,14),(3,13,16,15),(3,13,16,16),(6,13,16,26),(6,13,16,27),(6,13,16,28),(6,13,16,29),(5,13,16,31),(5,13,16,32),(5,13,16,35),(5,13,16,36),(4,13,16,40),(4,13,16,41),(4,13,16,42),(4,13,16,43),(4,13,16,44),(8,13,17,0),(3,13,17,12),(3,13,17,13),(3,13,17,14),(3,13,17,15),(3,13,17,16),(6,13,17,26),(6,13,17,27),(6,13,17,28),(6,13,17,29),(5,13,17,31),(0,13,17,36),(4,13,17,38),(4,13,17,39),(4,13,17,40),(4,13,17,41),(0,13,17,42),(4,13,17,44),(3,13,18,12),(3,13,18,13),(3,13,18,14),(3,13,18,15),(6,13,18,26),(6,13,18,27),(6,13,18,28),(6,13,18,29),(4,13,18,38),(4,13,18,39),(4,13,18,40),(4,13,18,41),(4,13,18,44),(3,13,19,14),(3,13,19,15),(4,13,19,38),(4,13,19,40),(4,13,19,41),(4,13,19,42),(4,13,19,43),(4,13,19,44),(4,17,0,7),(5,17,0,9),(5,17,0,10),(5,17,0,11),(5,17,0,12),(5,17,0,13),(5,17,0,14),(3,17,0,15),(3,17,0,16),(3,17,0,17),(3,17,0,18),(3,17,0,19),(3,17,0,20),(3,17,0,21),(3,17,0,22),(4,17,1,7),(4,17,1,8),(5,17,1,10),(5,17,1,11),(5,17,1,12),(5,17,1,13),(5,17,1,14),(3,17,1,15),(3,17,1,16),(3,17,1,17),(3,17,1,18),(3,17,1,19),(3,17,1,20),(3,17,1,21),(3,17,1,22),(0,17,2,2),(4,17,2,6),(4,17,2,7),(0,17,2,8),(5,17,2,10),(5,17,2,11),(5,17,2,12),(0,17,2,14),(3,17,2,17),(0,17,2,18),(3,17,2,20),(3,17,2,21),(3,17,2,22),(4,17,3,5),(4,17,3,7),(5,17,3,10),(5,17,3,11),(5,17,3,12),(3,17,3,16),(3,17,3,17),(3,17,3,20),(3,17,3,21),(3,17,3,22),(4,17,4,4),(4,17,4,5),(4,17,4,6),(4,17,4,7),(5,17,4,11),(3,17,4,15),(3,17,4,16),(3,17,4,17),(3,17,4,18),(3,17,4,19),(3,17,4,20),(3,17,4,21),(3,17,4,22),(9,17,5,0),(4,17,5,3),(4,17,5,4),(4,17,5,5),(4,17,5,7),(3,17,5,13),(3,17,5,14),(3,17,5,15),(3,17,5,18),(3,17,5,19),(3,17,5,20),(3,17,5,21),(3,17,5,22),(0,17,6,4),(4,17,6,6),(4,17,6,7),(3,17,6,15),(0,17,6,19),(3,17,6,21),(3,17,7,21),(3,17,7,22),(3,17,8,21),(4,17,9,0),(11,17,9,1),(4,17,10,0),(2,17,10,10),(1,17,10,14),(1,17,10,18),(4,17,11,0),(4,17,12,0),(4,17,13,0),(4,17,13,1),(12,17,13,17),(4,17,14,0),(4,17,14,1),(4,17,14,2),(0,17,14,13),(4,17,15,0),(4,17,15,1),(4,17,16,0),(4,17,16,1),(4,17,17,0),(4,17,17,1),(4,17,17,2),(3,17,17,12),(3,17,17,14),(4,17,18,0),(3,17,18,11),(3,17,18,12),(3,17,18,14),(3,17,18,15),(6,17,19,6),(6,17,19,7),(6,17,19,8),(3,17,19,12),(3,17,19,14),(3,17,19,15),(6,17,20,7),(6,17,20,10),(3,17,20,12),(3,17,20,13),(3,17,20,14),(3,17,20,15),(3,17,20,16),(11,17,20,17),(6,17,21,5),(6,17,21,6),(6,17,21,7),(6,17,21,8),(6,17,21,9),(6,17,21,10),(6,17,21,11),(3,17,21,12),(3,17,21,13),(3,17,21,14),(3,17,21,15),(6,17,22,7),(6,17,22,8),(6,17,22,9),(6,17,22,10),(3,17,22,11),(3,17,22,12),(3,17,22,13),(4,17,22,14),(4,17,22,15),(6,17,23,7),(6,17,23,10),(3,17,23,11),(3,17,23,12),(4,17,23,13),(4,17,23,14),(4,17,23,15),(4,17,23,16),(4,17,24,13),(4,17,24,15),(4,17,24,16),(4,17,24,17),(4,17,24,18),(5,17,25,3),(5,17,25,4),(4,17,25,12),(4,17,25,13),(4,17,25,15),(4,17,25,16),(12,17,25,17),(5,17,26,0),(5,17,26,1),(5,17,26,2),(5,17,26,3),(4,17,26,13),(4,17,26,16),(5,17,27,2),(5,17,28,2),(5,17,28,3),(5,17,29,0),(5,17,29,2),(5,17,29,3),(5,17,29,14),(5,17,30,0),(5,17,30,1),(5,17,30,2),(5,17,30,3),(5,17,30,12),(5,17,30,13),(5,17,30,14),(5,17,30,15),(5,17,31,1),(5,17,31,3),(5,17,31,13),(5,17,31,14),(5,17,32,9),(5,17,32,10),(5,17,32,11),(5,17,32,12),(5,17,32,13),(5,17,32,14),(5,17,32,15),(5,17,32,16),(10,17,32,17),(3,17,33,5),(5,17,33,13),(3,17,34,5),(3,17,34,6),(3,17,34,7),(3,17,34,9),(3,17,34,10),(3,17,34,11),(5,17,34,12),(5,17,34,13),(3,17,35,6),(3,17,35,7),(3,17,35,8),(3,17,35,9),(3,17,35,10),(3,17,35,11),(6,17,35,14),(6,17,35,15),(3,17,36,5),(3,17,36,6),(3,17,36,7),(3,17,36,8),(3,17,36,9),(3,17,36,10),(6,17,36,14),(6,17,36,15),(6,17,36,16),(8,17,36,17),(8,17,36,20),(3,17,37,5),(3,17,37,6),(3,17,37,7),(6,17,37,13),(6,17,37,14),(6,17,37,15),(6,17,37,16),(3,17,38,6),(4,17,38,8),(6,17,38,14),(6,17,38,15),(6,17,38,16),(6,17,39,0),(4,17,39,6),(4,17,39,8),(6,17,39,14),(6,17,39,15),(4,17,39,18),(4,17,39,19),(4,17,39,20),(4,17,39,21),(4,17,39,22),(6,17,40,0),(6,17,40,2),(4,17,40,6),(4,17,40,7),(4,17,40,8),(6,17,40,14),(10,17,40,18),(4,17,40,22),(6,17,41,0),(6,17,41,1),(6,17,41,2),(6,17,41,3),(4,17,41,5),(4,17,41,6),(4,17,41,7),(5,17,41,10),(6,17,41,14),(4,17,41,22),(6,17,42,0),(6,17,42,1),(6,17,42,2),(6,17,42,3),(4,17,42,5),(4,17,42,6),(4,17,42,7),(5,17,42,9),(5,17,42,10),(5,17,42,12),(6,17,42,13),(6,17,42,14),(4,17,42,17),(4,17,42,22),(6,17,43,0),(6,17,43,1),(6,17,43,2),(6,17,43,3),(4,17,43,4),(4,17,43,5),(4,17,43,6),(5,17,43,7),(5,17,43,8),(5,17,43,9),(5,17,43,10),(5,17,43,11),(5,17,43,12),(5,17,43,13),(5,17,43,14),(4,17,43,17),(4,17,43,22),(6,17,44,2),(6,17,44,3),(6,17,44,4),(4,17,44,5),(4,17,44,6),(5,17,44,7),(5,17,44,8),(5,17,44,9),(5,17,44,10),(5,17,44,12),(5,17,44,13),(4,17,44,17),(4,17,44,18),(4,17,44,19),(4,17,44,20),(4,17,44,21),(4,17,44,22),(3,21,0,25),(3,21,0,26),(3,21,0,27),(0,21,1,2),(0,21,1,7),(11,21,1,12),(3,21,1,22),(3,21,1,23),(3,21,1,24),(3,21,1,25),(3,21,1,26),(3,21,1,27),(3,21,1,40),(3,21,1,41),(3,21,1,42),(4,21,2,5),(4,21,2,6),(3,21,2,24),(3,21,2,25),(3,21,2,26),(3,21,2,27),(3,21,2,28),(3,21,2,29),(3,21,2,40),(3,21,2,41),(3,21,2,42),(3,21,2,43),(4,21,3,5),(4,21,3,6),(4,21,3,7),(3,21,3,25),(3,21,3,26),(3,21,3,27),(3,21,3,28),(3,21,3,30),(3,21,3,38),(3,21,3,39),(3,21,3,40),(3,21,3,41),(3,21,3,42),(3,21,3,43),(4,21,4,6),(4,21,4,7),(4,21,4,8),(3,21,4,25),(3,21,4,26),(5,21,4,27),(3,21,4,28),(3,21,4,29),(3,21,4,30),(3,21,4,31),(3,21,4,39),(3,21,4,40),(3,21,4,41),(3,21,4,42),(3,21,4,43),(4,21,5,6),(4,21,5,7),(4,21,5,8),(4,21,5,9),(12,21,5,10),(8,21,5,16),(0,21,5,20),(5,21,5,25),(5,21,5,26),(5,21,5,27),(5,21,5,28),(3,21,5,30),(3,21,5,39),(3,21,5,40),(3,21,5,41),(3,21,5,43),(4,21,6,7),(4,21,6,8),(4,21,6,9),(5,21,6,26),(5,21,6,27),(5,21,6,28),(5,21,6,29),(3,21,6,40),(5,21,6,41),(3,21,6,42),(3,21,6,43),(4,21,7,7),(4,21,7,8),(4,21,7,9),(5,21,7,25),(5,21,7,26),(5,21,7,27),(5,21,7,28),(5,21,7,29),(5,21,7,30),(3,21,7,40),(5,21,7,41),(5,21,7,42),(3,21,7,43),(0,21,8,1),(4,21,8,7),(4,21,8,8),(4,21,8,9),(5,21,8,26),(5,21,8,27),(5,21,8,28),(5,21,8,30),(5,21,8,31),(5,21,8,40),(5,21,8,42),(5,21,8,43),(4,21,9,8),(5,21,9,28),(4,21,9,34),(4,21,9,35),(5,21,9,40),(5,21,9,41),(5,21,9,42),(5,21,9,43),(5,21,10,26),(5,21,10,27),(5,21,10,28),(5,21,10,29),(4,21,10,35),(4,21,10,36),(4,21,10,37),(4,21,10,38),(4,21,10,39),(4,21,10,40),(4,21,10,41),(5,21,10,42),(5,21,10,43),(4,21,11,0),(4,21,11,1),(4,21,11,2),(12,21,11,11),(4,21,11,36),(4,21,11,37),(4,21,11,38),(4,21,11,39),(4,21,11,40),(5,21,11,41),(5,21,11,42),(4,21,12,0),(4,21,12,1),(4,21,12,2),(4,21,12,3),(4,21,12,4),(4,21,12,5),(4,21,12,6),(2,21,12,7),(4,21,12,34),(4,21,12,35),(4,21,12,36),(4,21,12,37),(4,21,12,38),(4,21,12,39),(4,21,12,40),(5,21,12,41),(5,21,12,42),(6,21,13,0),(4,21,13,1),(4,21,13,2),(1,21,13,3),(4,21,13,5),(4,21,13,6),(4,21,13,34),(4,21,13,36),(4,21,13,37),(4,21,13,39),(4,21,13,40),(5,21,13,41),(5,21,13,42),(5,21,13,43),(6,21,14,0),(6,21,14,1),(4,21,14,2),(4,21,14,5),(4,21,14,6),(4,21,14,7),(4,21,14,8),(6,21,14,17),(6,21,14,18),(4,21,14,34),(4,21,14,35),(4,21,14,36),(4,21,14,37),(4,21,14,38),(4,21,14,39),(4,21,14,40),(5,21,14,41),(5,21,14,42),(5,21,14,43),(6,21,15,0),(6,21,15,1),(6,21,15,2),(4,21,15,3),(4,21,15,4),(4,21,15,5),(4,21,15,6),(4,21,15,7),(4,21,15,8),(4,21,15,9),(6,21,15,17),(6,21,15,18),(3,21,15,33),(3,21,15,34),(4,21,15,35),(4,21,15,36),(4,21,15,37),(4,21,15,38),(4,21,15,39),(5,21,15,41),(5,21,15,42),(5,21,15,43),(6,21,16,0),(6,21,16,1),(6,21,16,2),(4,21,16,5),(4,21,16,6),(4,21,16,7),(4,21,16,8),(4,21,16,9),(6,21,16,17),(6,21,16,18),(6,21,16,24),(6,21,16,25),(6,21,16,26),(3,21,16,34),(3,21,16,35),(4,21,16,36),(4,21,16,37),(4,21,16,38),(4,21,16,39),(5,21,16,41),(5,21,16,42),(5,21,16,43),(6,21,17,0),(3,21,17,1),(6,21,17,2),(4,21,17,5),(4,21,17,6),(4,21,17,7),(4,21,17,8),(4,21,17,10),(6,21,17,16),(6,21,17,17),(6,21,17,24),(6,21,17,25),(6,21,17,26),(6,21,17,27),(6,21,17,28),(3,21,17,33),(3,21,17,34),(3,21,17,35),(4,21,17,36),(4,21,17,37),(5,21,17,41),(5,21,17,43),(3,21,18,0),(3,21,18,1),(6,21,18,2),(0,21,18,3),(4,21,18,5),(4,21,18,6),(4,21,18,7),(4,21,18,8),(4,21,18,9),(4,21,18,10),(6,21,18,17),(6,21,18,18),(6,21,18,19),(6,21,18,23),(6,21,18,24),(6,21,18,25),(6,21,18,27),(3,21,18,31),(3,21,18,34),(3,21,18,35),(3,21,18,36),(3,21,18,37),(5,21,18,38),(5,21,18,39),(5,21,18,40),(5,21,18,41),(5,21,18,43),(3,21,19,0),(3,21,19,1),(6,21,19,2),(3,21,19,5),(4,21,19,6),(4,21,19,7),(3,21,19,9),(6,21,19,18),(6,21,19,24),(3,21,19,31),(3,21,19,32),(3,21,19,33),(3,21,19,34),(3,21,19,35),(3,21,19,36),(3,21,19,37),(5,21,19,38),(5,21,19,39),(5,21,19,40),(5,21,19,41),(5,21,19,42),(5,21,19,43),(3,21,20,0),(3,21,20,1),(3,21,20,2),(3,21,20,3),(3,21,20,4),(3,21,20,5),(3,21,20,6),(3,21,20,7),(3,21,20,8),(3,21,20,9),(3,21,20,10),(3,21,20,11),(6,21,20,18),(3,21,20,33),(3,21,20,34),(3,21,20,35),(3,21,20,36),(3,21,20,37),(3,21,20,38),(5,21,20,39),(5,21,20,40),(5,21,20,41),(5,21,20,42),(5,21,20,43),(3,21,21,0),(3,21,21,1),(3,21,21,2),(3,21,21,3),(3,21,21,4),(3,21,21,5),(3,21,21,6),(3,21,21,9),(3,21,21,36),(3,21,21,37),(5,21,21,40),(5,21,21,41),(5,21,21,42),(5,21,21,43),(5,30,0,0),(5,30,0,1),(5,30,0,2),(5,30,0,3),(5,30,0,15),(5,30,0,16),(5,30,0,17),(5,30,0,18),(5,30,0,19),(5,30,0,20),(5,30,0,21),(5,30,0,22),(5,30,0,23),(5,30,0,24),(5,30,0,25),(5,30,0,26),(0,30,0,28),(5,30,1,0),(5,30,1,1),(5,30,1,2),(5,30,1,3),(4,30,1,7),(4,30,1,8),(4,30,1,9),(4,30,1,10),(13,30,1,12),(5,30,1,16),(5,30,1,17),(5,30,1,18),(11,30,1,20),(5,30,1,26),(5,30,2,0),(5,30,2,1),(5,30,2,2),(4,30,2,6),(4,30,2,7),(4,30,2,8),(4,30,2,9),(5,30,2,14),(5,30,2,15),(5,30,2,16),(5,30,2,17),(5,30,2,19),(5,30,2,26),(5,30,2,27),(5,30,3,0),(5,30,3,1),(4,30,3,5),(4,30,3,6),(4,30,3,7),(4,30,3,8),(4,30,3,9),(5,30,3,15),(5,30,3,16),(5,30,3,17),(5,30,3,18),(5,30,3,19),(0,30,3,27),(5,30,4,1),(5,30,4,2),(5,30,4,3),(4,30,4,6),(4,30,4,7),(4,30,4,8),(6,30,4,11),(5,30,4,16),(5,30,4,17),(5,30,5,2),(5,30,5,3),(4,30,5,5),(4,30,5,6),(4,30,5,7),(6,30,5,10),(6,30,5,11),(6,30,5,20),(6,30,5,21),(6,30,6,10),(6,30,6,11),(6,30,6,18),(6,30,6,20),(6,30,6,21),(6,30,6,22),(12,30,7,1),(6,30,7,11),(6,30,7,19),(6,30,7,20),(6,30,8,11),(6,30,8,12),(6,30,8,13),(6,30,8,19),(6,30,8,20),(6,30,9,12),(6,30,9,13),(6,30,9,14),(6,30,9,20),(3,30,9,25),(3,30,9,26),(0,30,10,8),(6,30,10,12),(6,30,10,13),(8,30,10,22),(3,30,10,25),(3,30,10,26),(3,30,10,27),(3,30,10,29),(3,30,11,26),(3,30,11,27),(3,30,11,28),(3,30,11,29),(3,30,12,27),(3,30,12,28),(3,30,12,29),(3,30,13,25),(3,30,13,27),(3,30,13,28),(3,30,13,29),(3,30,14,25),(3,30,14,26),(3,30,14,27),(3,30,14,28),(3,30,14,29),(3,30,15,25),(3,30,15,26),(3,30,15,27),(3,30,15,28),(3,30,15,29),(5,30,16,0),(3,30,16,26),(3,30,16,27),(3,30,16,28),(3,30,16,29),(5,30,17,0),(5,30,17,1),(3,30,17,25),(3,30,17,26),(3,30,17,27),(3,30,17,28),(3,30,17,29),(5,30,18,0),(5,30,18,1),(0,30,18,5),(3,30,18,24),(3,30,18,25),(3,30,18,26),(3,30,18,27),(3,30,18,28),(3,30,18,29),(5,30,19,0),(3,30,19,24),(3,30,19,25),(3,30,19,26),(3,30,19,27),(3,30,19,28),(3,30,19,29),(5,30,20,0),(5,30,20,1),(3,30,20,24),(3,30,20,25),(3,30,20,26),(3,30,20,27),(3,30,20,28),(3,30,20,29),(5,30,21,0),(3,30,21,25),(3,30,21,26),(3,30,21,27),(3,30,21,28),(3,30,21,29),(5,30,22,0),(14,30,22,1),(3,30,22,27),(3,30,22,28),(3,30,22,29),(5,30,23,0),(4,30,23,20),(3,30,23,26),(3,30,23,27),(3,30,23,28),(3,30,23,29),(5,30,24,0),(4,30,24,18),(4,30,24,19),(4,30,24,20),(4,30,24,21),(4,30,24,22),(0,30,24,24),(3,30,24,27),(3,30,24,28),(5,30,25,0),(5,30,25,2),(4,30,25,19),(4,30,25,20),(4,30,25,21),(4,30,25,22),(5,30,26,0),(5,30,26,1),(5,30,26,2),(6,30,26,6),(6,30,26,7),(2,30,26,16),(4,30,26,19),(4,30,26,20),(4,30,26,21),(4,30,26,22),(4,30,26,23),(6,30,27,5),(6,30,27,6),(5,30,27,7),(5,30,27,8),(5,30,27,11),(5,30,27,12),(4,30,27,19),(4,30,27,20),(4,30,27,21),(4,30,27,22),(4,30,27,23),(4,30,27,24),(5,30,28,1),(5,30,28,2),(5,30,28,3),(5,30,28,4),(6,30,28,5),(6,30,28,6),(5,30,28,7),(5,30,28,8),(5,30,28,10),(5,30,28,11),(5,30,28,12),(5,30,28,13),(5,30,28,14),(4,30,28,19),(4,30,28,20),(4,30,28,21),(4,30,28,22),(4,30,28,23),(0,30,28,24),(5,30,29,2),(6,30,29,3),(6,30,29,4),(6,30,29,5),(6,30,29,6),(5,30,29,7),(5,30,29,8),(5,30,29,9),(5,30,29,10),(5,30,29,11),(5,30,29,12),(5,30,29,13),(4,30,29,18),(4,30,29,19),(4,30,29,20),(4,30,29,21),(4,30,29,22),(8,31,0,3),(13,31,0,7),(3,31,0,12),(3,31,0,13),(3,31,0,14),(6,31,0,17),(6,31,0,18),(5,31,0,28),(3,31,1,13),(3,31,1,14),(3,31,1,15),(3,31,1,16),(6,31,1,18),(6,31,1,19),(5,31,1,28),(3,31,2,13),(3,31,2,14),(3,31,2,15),(6,31,2,18),(6,31,2,19),(4,31,2,23),(4,31,2,25),(1,31,2,26),(5,31,2,28),(5,31,2,29),(0,31,2,35),(6,31,3,3),(6,31,3,4),(6,31,3,5),(6,31,3,9),(3,31,3,12),(3,31,3,13),(3,31,3,19),(4,31,3,22),(4,31,3,23),(4,31,3,24),(4,31,3,25),(5,31,3,28),(5,31,3,29),(5,31,3,30),(6,31,4,4),(6,31,4,5),(6,31,4,9),(6,31,4,10),(3,31,4,18),(3,31,4,19),(3,31,4,20),(3,31,4,21),(4,31,4,22),(4,31,4,23),(4,31,4,24),(5,31,4,30),(0,31,4,31),(6,31,5,4),(6,31,5,9),(6,31,5,10),(3,31,5,21),(3,31,5,22),(4,31,5,23),(4,31,5,24),(5,31,5,29),(5,31,5,30),(6,31,5,37),(6,31,6,10),(3,31,6,20),(3,31,6,21),(3,31,6,22),(3,31,6,23),(3,31,6,24),(5,31,6,29),(5,31,6,30),(6,31,6,36),(6,31,6,37),(11,31,7,0),(5,31,7,6),(13,31,7,7),(11,31,7,9),(3,31,7,20),(3,31,7,22),(3,31,7,23),(3,31,7,24),(3,31,7,25),(3,31,7,26),(3,31,7,27),(4,31,7,28),(4,31,7,29),(6,31,7,35),(6,31,7,36),(6,31,7,37),(5,31,8,6),(2,31,8,17),(2,31,8,22),(3,31,8,24),(3,31,8,25),(1,31,8,26),(4,31,8,28),(4,31,8,29),(0,31,8,30),(6,31,8,33),(0,31,8,35),(5,31,9,6),(3,31,9,24),(4,31,9,29),(6,31,9,32),(6,31,9,33),(5,31,10,6),(3,31,10,24),(4,31,10,28),(4,31,10,29),(4,31,10,30),(4,31,10,31),(6,31,10,32),(6,31,10,33),(6,31,10,34),(5,31,11,6),(3,31,11,24),(4,31,11,28),(4,31,11,29),(4,31,11,30),(4,31,11,31),(5,31,12,6),(0,31,12,26),(4,31,12,29),(4,31,12,30),(3,31,12,32),(9,31,13,6),(4,31,13,28),(4,31,13,29),(4,31,13,30),(3,31,13,32),(4,31,14,15),(0,31,14,22),(4,31,14,28),(0,31,14,30),(3,31,14,32),(0,31,14,35),(4,31,15,14),(4,31,15,15),(4,31,15,17),(4,31,15,28),(4,31,15,29),(3,31,15,32),(3,31,15,33),(3,31,15,34),(4,31,16,12),(4,31,16,13),(4,31,16,14),(4,31,16,15),(4,31,16,16),(4,31,16,17),(4,31,16,18),(4,31,16,28),(3,31,16,29),(3,31,16,30),(3,31,16,31),(3,31,16,32),(3,31,16,33),(3,31,16,34),(5,42,0,21),(5,42,0,23),(3,42,0,39),(6,42,1,3),(1,42,1,5),(3,42,1,8),(3,42,1,9),(3,42,1,10),(0,42,1,18),(5,42,1,20),(5,42,1,21),(5,42,1,23),(3,42,1,38),(3,42,1,39),(0,42,2,1),(6,42,2,3),(3,42,2,8),(0,42,2,9),(1,42,2,14),(5,42,2,21),(5,42,2,22),(5,42,2,23),(5,42,2,25),(5,42,2,26),(3,42,2,36),(3,42,2,37),(3,42,2,38),(3,42,2,39),(3,42,2,40),(3,42,2,41),(6,42,3,3),(6,42,3,4),(3,42,3,5),(3,42,3,6),(3,42,3,7),(3,42,3,8),(5,42,3,20),(5,42,3,21),(5,42,3,22),(5,42,3,23),(5,42,3,24),(5,42,3,25),(5,42,3,27),(5,42,3,28),(5,42,3,29),(5,42,3,31),(5,42,3,32),(3,42,3,36),(3,42,3,37),(3,42,3,38),(3,42,3,39),(3,42,3,40),(6,42,4,1),(6,42,4,2),(6,42,4,3),(3,42,4,4),(3,42,4,5),(3,42,4,6),(3,42,4,7),(3,42,4,8),(3,42,4,9),(5,42,4,19),(5,42,4,20),(5,42,4,21),(5,42,4,22),(5,42,4,23),(5,42,4,24),(5,42,4,25),(5,42,4,26),(5,42,4,27),(5,42,4,30),(5,42,4,31),(5,42,4,32),(5,42,4,33),(3,42,4,38),(3,42,4,39),(3,42,4,40),(6,42,5,1),(6,42,5,2),(6,42,5,3),(6,42,5,4),(0,42,5,5),(3,42,5,7),(5,42,5,20),(5,42,5,22),(5,42,5,23),(5,42,5,24),(5,42,5,25),(5,42,5,26),(5,42,5,27),(5,42,5,28),(5,42,5,29),(5,42,5,30),(5,42,5,31),(5,42,5,32),(6,42,5,35),(3,42,5,37),(3,42,5,38),(3,42,5,39),(3,42,5,40),(0,42,6,1),(6,42,6,3),(6,42,6,4),(3,42,6,7),(3,42,6,8),(2,42,6,9),(2,42,6,14),(5,42,6,20),(5,42,6,21),(5,42,6,22),(5,42,6,23),(5,42,6,24),(5,42,6,28),(5,42,6,29),(5,42,6,30),(5,42,6,31),(4,42,6,32),(6,42,6,34),(6,42,6,35),(6,42,6,36),(6,42,6,37),(6,42,6,38),(3,42,6,39),(6,42,7,4),(3,42,7,5),(3,42,7,6),(3,42,7,7),(3,42,7,8),(5,42,7,21),(5,42,7,23),(5,42,7,24),(5,42,7,27),(5,42,7,28),(4,42,7,31),(4,42,7,32),(4,42,7,33),(6,42,7,35),(6,42,7,36),(6,42,7,37),(6,42,7,38),(3,42,8,7),(5,42,8,23),(5,42,8,28),(4,42,8,29),(4,42,8,30),(4,42,8,31),(4,42,8,32),(4,42,8,33),(6,42,8,35),(6,42,8,37),(6,42,8,38),(6,42,8,39),(6,42,8,40),(6,42,8,41),(6,42,8,42),(6,42,8,43),(6,42,8,44),(6,42,8,45),(8,42,9,6),(8,42,9,9),(4,42,9,26),(4,42,9,27),(4,42,9,29),(4,42,9,30),(4,42,9,31),(4,42,9,32),(6,42,9,35),(6,42,9,40),(6,42,9,41),(6,42,9,42),(6,42,9,43),(6,42,9,44),(0,42,10,3),(4,42,10,26),(4,42,10,27),(4,42,10,28),(4,42,10,29),(4,42,10,30),(4,42,10,31),(4,42,10,32),(4,42,10,33),(6,42,10,43),(6,42,10,44),(4,42,11,28),(4,42,11,29),(4,42,11,31),(4,42,11,32),(3,42,11,45),(3,42,11,48),(5,42,12,17),(4,42,12,28),(4,42,12,29),(4,42,12,30),(4,42,12,31),(4,42,12,32),(4,42,12,33),(4,42,12,34),(3,42,12,45),(3,42,12,46),(3,42,12,47),(3,42,12,48),(0,42,13,7),(5,42,13,17),(5,42,13,18),(4,42,13,29),(4,42,13,30),(4,42,13,31),(3,42,13,44),(3,42,13,45),(3,42,13,46),(3,42,13,47),(3,42,13,48),(5,42,14,12),(5,42,14,13),(5,42,14,14),(5,42,14,15),(5,42,14,16),(5,42,14,17),(3,42,14,45),(3,42,14,47),(3,42,14,48),(0,42,15,2),(5,42,15,12),(5,42,15,13),(5,42,15,14),(5,42,15,15),(5,42,15,16),(5,42,15,17),(5,42,15,18),(5,42,15,19),(4,42,15,43),(4,42,15,45),(3,42,15,46),(3,42,15,47),(3,42,15,48),(5,42,16,11),(5,42,16,12),(5,42,16,13),(5,42,16,14),(5,42,16,16),(5,42,16,17),(5,42,16,18),(4,42,16,40),(4,42,16,41),(4,42,16,43),(4,42,16,44),(4,42,16,45),(3,42,16,46),(3,42,16,47),(3,42,16,48),(5,42,17,9),(5,42,17,10),(5,42,17,11),(5,42,17,12),(5,42,17,13),(5,42,17,14),(5,42,17,17),(4,42,17,40),(4,42,17,41),(4,42,17,42),(4,42,17,43),(4,42,17,44),(4,42,17,45),(4,42,17,46),(4,42,17,47),(3,42,17,48),(3,42,18,32),(4,42,18,39),(4,42,18,40),(4,42,18,41),(4,42,18,42),(4,42,18,43),(4,42,18,45),(4,42,18,47),(3,42,18,48),(3,42,19,30),(3,42,19,31),(3,42,19,32),(3,42,19,33),(4,42,19,38),(4,42,19,39),(4,42,19,40),(4,42,19,41),(4,42,19,42),(4,42,19,43),(4,42,19,44),(4,42,19,45),(4,42,19,46),(4,42,19,47),(4,42,19,48),(3,42,20,30),(3,42,20,31),(3,42,20,32),(3,42,20,33),(3,42,20,34),(3,42,20,35),(4,42,20,39),(4,42,20,40),(4,42,20,41),(4,42,20,42),(4,42,20,43),(4,42,20,44),(4,42,20,45),(4,42,20,46),(4,42,20,47),(4,42,20,48),(3,42,21,31),(3,42,21,33),(3,42,21,34),(3,42,21,35),(5,42,21,37),(4,42,21,39),(4,42,21,41),(4,42,21,42),(4,42,21,43),(4,42,21,44),(4,42,21,45),(4,42,21,46),(4,42,21,47),(4,42,21,48),(3,42,22,33),(3,42,22,34),(3,42,22,35),(3,42,22,36),(5,42,22,37),(4,42,22,41),(4,42,22,42),(4,42,22,43),(4,42,22,44),(4,42,22,45),(4,42,22,46),(4,42,22,48),(3,42,23,33),(3,42,23,34),(3,42,23,35),(5,42,23,37),(5,42,23,38),(4,42,23,40),(4,42,23,42),(4,42,23,43),(4,42,23,44),(4,42,23,45),(4,42,23,46),(4,42,23,47),(4,42,23,48),(6,42,24,7),(6,42,24,9),(3,42,24,33),(3,42,24,34),(3,42,24,35),(5,42,24,37),(5,42,24,38),(4,42,24,40),(4,42,24,42),(4,42,24,43),(4,42,24,44),(4,42,24,45),(4,42,24,46),(4,42,24,47),(4,42,24,48),(6,42,25,7),(6,42,25,8),(6,42,25,9),(6,42,25,10),(3,42,25,33),(5,42,25,34),(5,42,25,36),(5,42,25,38),(5,42,25,39),(4,42,25,40),(4,42,25,41),(4,42,25,42),(4,42,25,43),(4,42,25,44),(4,42,25,45),(4,42,25,46),(4,42,25,47),(4,42,25,48),(6,42,26,6),(6,42,26,7),(6,42,26,8),(6,42,26,9),(3,42,26,32),(3,42,26,33),(5,42,26,34),(5,42,26,35),(5,42,26,36),(5,42,26,37),(5,42,26,38),(4,42,26,40),(4,42,26,41),(4,42,26,42),(4,42,26,43),(4,42,26,44),(4,42,26,45),(4,42,26,46),(4,42,26,47),(6,42,27,8),(6,42,27,9),(3,42,27,32),(3,42,27,33),(3,42,27,34),(5,42,27,36),(5,42,27,37),(5,42,27,38),(4,42,27,39),(4,42,27,40),(4,42,27,41),(4,42,27,42),(4,42,27,43),(4,42,27,44),(4,42,27,45),(4,42,27,46),(4,42,27,47),(6,42,28,8),(3,42,28,28),(3,42,28,29),(3,42,28,30),(3,42,28,31),(3,42,28,32),(3,42,28,33),(5,42,28,34),(5,42,28,35),(5,42,28,36),(5,42,28,37),(5,42,28,38),(5,42,28,39),(5,42,28,40),(4,42,28,41),(4,42,28,42),(4,42,28,43),(4,42,28,44),(4,42,28,45),(4,42,28,46),(6,42,29,8),(3,42,29,28),(3,42,29,29),(3,42,29,30),(3,42,29,31),(3,42,29,32),(3,42,29,33),(3,42,29,34),(5,42,29,35),(5,42,29,36),(5,42,29,37),(5,42,29,38),(5,42,29,39),(5,42,29,40),(4,42,29,41),(4,42,29,43),(4,42,29,44),(4,42,29,45);
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
  CONSTRAINT `units_ibfk_3` FOREIGN KEY (`route_id`) REFERENCES `routes` (`id`) ON DELETE SET NULL,
  CONSTRAINT `units_ibfk_1` FOREIGN KEY (`player_id`) REFERENCES `players` (`id`) ON DELETE SET NULL,
  CONSTRAINT `units_ibfk_2` FOREIGN KEY (`galaxy_id`) REFERENCES `galaxies` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=191 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `units`
--

LOCK TABLES `units` WRITE;
/*!40000 ALTER TABLE `units` DISABLE KEYS */;
INSERT INTO `units` VALUES (1,2500,1,1,1,NULL,NULL,NULL,NULL,0,0,'Demosis',0,2,120,NULL,1,0,0,0),(2,2500,1,1,1,NULL,NULL,NULL,NULL,0,0,'Demosis',0,2,120,NULL,1,0,0,0),(3,1590,1,1,1,NULL,NULL,NULL,NULL,0,0,'Thor',0,2,120,NULL,1,0,0,0),(4,1200,1,1,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,2,120,NULL,1,0,0,0),(5,1200,1,1,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,2,120,NULL,1,0,0,0),(6,1200,1,1,1,NULL,NULL,NULL,NULL,0,0,'Dirac',0,2,120,NULL,1,0,0,0),(7,120,1,7,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(8,140,1,7,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(9,140,1,7,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(10,120,1,7,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(11,140,1,7,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(12,120,1,7,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(13,120,1,7,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(14,120,1,8,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(15,140,1,8,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(16,120,1,8,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(17,120,1,8,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(18,140,1,9,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(19,120,1,9,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(20,120,1,9,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(21,120,1,10,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(22,120,1,10,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(23,120,1,11,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(24,120,1,11,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(25,120,1,12,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(26,120,1,12,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(27,120,1,13,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(28,120,1,13,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(29,1200,1,1,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,2,210,NULL,1,0,0,0),(30,1200,1,1,1,NULL,NULL,NULL,NULL,0,0,'Dirac',0,2,210,NULL,1,0,0,0),(31,1590,1,1,1,NULL,NULL,NULL,NULL,0,0,'Thor',1,1,0,NULL,1,0,0,0),(32,1200,1,1,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,1,0,NULL,1,0,0,0),(33,1200,1,1,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,1,0,NULL,1,0,0,0),(34,1200,1,1,1,NULL,NULL,NULL,NULL,0,0,'Dirac',0,1,0,NULL,1,0,0,0),(35,1590,1,1,1,NULL,NULL,NULL,NULL,0,0,'Thor',1,1,270,NULL,1,0,0,0),(36,1200,1,1,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,1,270,NULL,1,0,0,0),(37,1200,1,1,1,NULL,NULL,NULL,NULL,0,0,'Dirac',0,1,270,NULL,1,0,0,0),(38,2500,1,1,1,NULL,NULL,NULL,NULL,0,0,'Demosis',0,2,180,NULL,1,0,0,0),(39,1590,1,1,1,NULL,NULL,NULL,NULL,0,0,'Thor',0,2,180,NULL,1,0,0,0),(40,1590,1,1,1,NULL,NULL,NULL,NULL,0,0,'Thor',1,2,180,NULL,1,0,0,0),(41,1200,1,1,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,2,180,NULL,1,0,0,0),(42,1200,1,1,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,2,180,NULL,1,0,0,0),(43,1200,1,1,1,NULL,NULL,NULL,NULL,0,0,'Dirac',0,2,180,NULL,1,0,0,0),(44,2500,1,1,1,NULL,NULL,NULL,NULL,0,0,'Demosis',0,1,135,NULL,1,0,0,0),(45,1590,1,1,1,NULL,NULL,NULL,NULL,0,0,'Thor',0,1,135,NULL,1,0,0,0),(46,1200,1,1,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,1,135,NULL,1,0,0,0),(47,1200,1,1,1,NULL,NULL,NULL,NULL,0,0,'Dirac',0,1,135,NULL,1,0,0,0),(48,140,1,17,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(49,120,1,17,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(50,120,1,18,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(51,120,1,18,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(52,120,1,19,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(53,120,1,20,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(54,120,1,20,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(55,120,1,21,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(56,120,1,21,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(57,140,1,29,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(58,120,1,29,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(59,120,1,29,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(60,120,1,30,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(61,140,1,30,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(62,140,1,30,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(63,120,1,30,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(64,140,1,30,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(65,120,1,30,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(66,120,1,30,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(67,140,1,31,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(68,120,1,31,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(69,120,1,32,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(70,120,1,32,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(71,120,1,33,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(72,120,1,33,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(73,120,1,34,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(74,120,1,34,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(75,120,1,35,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(76,120,1,35,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(77,140,1,41,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(78,120,1,41,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(79,120,1,41,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(80,120,1,42,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(81,120,1,43,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(82,120,1,44,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(83,120,1,44,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(84,120,1,45,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(85,120,1,45,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(86,2500,1,2,1,NULL,NULL,NULL,NULL,0,0,'Demosis',0,0,0,NULL,1,0,0,0),(87,1590,1,2,1,NULL,NULL,NULL,NULL,0,0,'Thor',1,0,0,NULL,1,0,0,0),(88,1200,1,2,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,0,0,NULL,1,0,0,0),(89,1200,1,2,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,0,0,NULL,1,0,0,0),(90,1200,1,2,1,NULL,NULL,NULL,NULL,0,0,'Dirac',0,0,0,NULL,1,0,0,0),(91,1590,1,3,1,NULL,NULL,NULL,NULL,0,0,'Thor',0,3,156,NULL,1,0,0,0),(92,1590,1,3,1,NULL,NULL,NULL,NULL,0,0,'Thor',1,3,156,NULL,1,0,0,0),(93,1200,1,3,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,3,156,NULL,1,0,0,0),(94,1200,1,3,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,3,156,NULL,1,0,0,0),(95,1200,1,3,1,NULL,NULL,NULL,NULL,0,0,'Dirac',0,3,156,NULL,1,0,0,0),(96,140,1,52,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(97,120,1,52,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(98,140,1,52,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(99,120,1,52,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(100,140,1,52,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(101,120,1,52,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(102,120,1,52,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(103,120,1,53,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(104,140,1,53,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(105,120,1,53,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(106,120,1,53,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(107,140,1,57,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(108,120,1,57,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(109,120,1,57,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(110,140,1,58,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(111,120,1,58,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(112,120,1,58,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(113,120,1,59,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(114,120,1,59,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(115,120,1,60,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(116,120,1,60,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(117,140,1,61,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(118,120,1,61,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(119,120,1,61,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(120,120,1,62,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(121,120,1,62,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(122,120,1,63,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(123,120,1,63,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(124,140,1,64,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(125,120,1,64,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(126,120,1,64,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(127,140,1,65,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(128,120,1,65,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(129,120,1,65,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(130,140,1,66,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(131,120,1,66,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(132,120,1,66,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(133,120,1,67,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(134,120,1,67,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(135,2500,1,3,1,NULL,NULL,NULL,NULL,0,0,'Demosis',0,2,270,NULL,1,0,0,0),(136,1590,1,3,1,NULL,NULL,NULL,NULL,0,0,'Thor',0,2,270,NULL,1,0,0,0),(137,1590,1,3,1,NULL,NULL,NULL,NULL,0,0,'Thor',1,2,270,NULL,1,0,0,0),(138,1200,1,3,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,2,270,NULL,1,0,0,0),(139,1200,1,3,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,2,270,NULL,1,0,0,0),(140,1200,1,3,1,NULL,NULL,NULL,NULL,0,0,'Dirac',0,2,270,NULL,1,0,0,0),(141,140,1,74,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(142,120,1,74,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(143,120,1,74,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(144,120,1,75,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(145,120,1,75,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(146,120,1,76,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(147,120,1,76,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(148,120,1,77,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(149,120,1,77,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(150,120,1,78,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(151,120,1,78,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(152,120,1,85,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(153,140,1,85,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(154,120,1,85,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(155,120,1,85,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(156,140,1,85,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(157,120,1,85,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(158,140,1,85,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(159,120,1,85,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(160,120,1,85,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(161,120,1,86,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(162,140,1,86,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(163,120,1,86,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(164,140,1,86,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(165,120,1,86,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(166,140,1,86,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(167,120,1,86,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(168,140,1,87,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(169,120,1,87,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(170,140,1,87,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(171,120,1,87,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(172,140,1,87,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(173,120,1,87,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(174,120,1,88,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(175,140,1,88,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(176,120,1,88,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(177,120,1,88,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(178,140,1,89,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(179,120,1,89,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(180,120,1,90,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(181,120,1,90,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(182,120,1,91,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(183,120,1,91,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(184,120,1,92,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(185,120,1,92,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(186,2500,1,4,1,NULL,NULL,NULL,NULL,0,0,'Demosis',0,2,300,NULL,1,0,0,0),(187,2500,1,4,1,NULL,NULL,NULL,NULL,0,0,'Demosis',0,2,300,NULL,1,0,0,0),(188,1590,1,4,1,NULL,NULL,NULL,NULL,0,0,'Thor',1,2,300,NULL,1,0,0,0),(189,1200,1,4,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,2,300,NULL,1,0,0,0),(190,1200,1,4,1,NULL,NULL,NULL,NULL,0,0,'Dirac',0,2,300,NULL,1,0,0,0);
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

-- Dump completed on 2010-11-19 14:36:49
