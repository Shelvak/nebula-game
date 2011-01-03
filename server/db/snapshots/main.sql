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
) ENGINE=InnoDB AUTO_INCREMENT=99 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `buildings`
--

LOCK TABLES `buildings` WRITE;
/*!40000 ALTER TABLE `buildings` DISABLE KEYS */;
INSERT INTO `buildings` VALUES (1,5,4,1,0,0,0,1,'NpcMetalExtractor',NULL,5,2,NULL,1,400,NULL,0,NULL,NULL,0),(2,5,14,20,0,0,0,1,'NpcMetalExtractor',NULL,15,21,NULL,1,400,NULL,0,NULL,NULL,0),(3,5,16,30,0,0,0,1,'NpcMetalExtractor',NULL,17,31,NULL,1,400,NULL,0,NULL,NULL,0),(4,5,9,22,0,0,0,1,'NpcMetalExtractor',NULL,10,23,NULL,1,400,NULL,0,NULL,NULL,0),(5,5,4,29,0,0,0,1,'NpcGeothermalPlant',NULL,5,30,NULL,1,600,NULL,0,NULL,NULL,0),(6,5,10,26,0,0,0,1,'NpcGeothermalPlant',NULL,11,27,NULL,1,600,NULL,0,NULL,NULL,0),(7,5,7,14,0,0,0,1,'NpcZetiumExtractor',NULL,8,15,NULL,1,800,NULL,0,NULL,NULL,0),(8,5,7,4,0,0,0,1,'NpcSolarPlant',NULL,8,5,NULL,1,1000,NULL,0,NULL,NULL,0),(9,5,1,6,0,0,0,1,'NpcSolarPlant',NULL,2,7,NULL,1,1000,NULL,0,NULL,NULL,0),(10,5,7,30,0,0,0,1,'NpcSolarPlant',NULL,8,31,NULL,1,1000,NULL,0,NULL,NULL,0),(11,5,1,22,0,0,0,1,'NpcSolarPlant',NULL,2,23,NULL,1,1000,NULL,0,NULL,NULL,0),(12,14,12,20,0,0,0,1,'NpcMetalExtractor',NULL,13,21,NULL,1,400,NULL,0,NULL,NULL,0),(13,14,7,9,0,0,0,1,'NpcMetalExtractor',NULL,8,10,NULL,1,400,NULL,0,NULL,NULL,0),(14,14,30,7,0,0,0,1,'NpcMetalExtractor',NULL,31,8,NULL,1,400,NULL,0,NULL,NULL,0),(15,14,14,1,0,0,0,1,'NpcGeothermalPlant',NULL,15,2,NULL,1,600,NULL,0,NULL,NULL,0),(16,14,38,5,0,0,0,1,'NpcZetiumExtractor',NULL,39,6,NULL,1,800,NULL,0,NULL,NULL,0),(17,14,37,8,0,0,0,1,'NpcJumpgate',NULL,41,12,NULL,1,8000,NULL,0,NULL,NULL,0),(18,14,20,5,0,0,0,1,'NpcResearchCenter',NULL,23,8,NULL,1,4000,NULL,0,NULL,NULL,0),(19,14,33,4,0,0,0,1,'NpcCommunicationsHub',NULL,35,5,NULL,1,1200,NULL,0,NULL,NULL,0),(20,14,39,14,0,0,0,1,'NpcTemple',NULL,41,16,NULL,1,1500,NULL,0,NULL,NULL,0),(21,14,17,7,0,0,0,1,'NpcCommunicationsHub',NULL,19,8,NULL,1,1200,NULL,0,NULL,NULL,0),(22,14,29,17,0,0,0,1,'NpcSolarPlant',NULL,30,18,NULL,1,1000,NULL,0,NULL,NULL,0),(23,14,14,5,0,0,0,1,'NpcSolarPlant',NULL,15,6,NULL,1,1000,NULL,0,NULL,NULL,0),(24,14,27,14,0,0,0,1,'NpcSolarPlant',NULL,28,15,NULL,1,1000,NULL,0,NULL,NULL,0),(25,14,15,16,0,0,0,1,'NpcSolarPlant',NULL,16,17,NULL,1,1000,NULL,0,NULL,NULL,0),(26,27,13,18,0,0,0,1,'NpcMetalExtractor',NULL,14,19,NULL,1,400,NULL,0,NULL,NULL,0),(27,27,16,7,0,0,0,1,'NpcMetalExtractor',NULL,17,8,NULL,1,400,NULL,0,NULL,NULL,0),(28,27,5,28,0,0,0,1,'NpcGeothermalPlant',NULL,6,29,NULL,1,600,NULL,0,NULL,NULL,0),(29,27,1,25,0,0,0,1,'NpcZetiumExtractor',NULL,2,26,NULL,1,800,NULL,0,NULL,NULL,0),(30,27,9,30,0,0,0,1,'NpcResearchCenter',NULL,12,33,NULL,1,4000,NULL,0,NULL,NULL,0),(31,27,9,25,0,0,0,1,'NpcResearchCenter',NULL,12,28,NULL,1,4000,NULL,0,NULL,NULL,0),(32,27,16,29,0,0,0,1,'NpcCommunicationsHub',NULL,18,30,NULL,1,1200,NULL,0,NULL,NULL,0),(33,27,32,11,0,0,0,1,'NpcSolarPlant',NULL,33,12,NULL,1,1000,NULL,0,NULL,NULL,0),(34,27,30,12,0,0,0,1,'NpcSolarPlant',NULL,31,13,NULL,1,1000,NULL,0,NULL,NULL,0),(35,27,17,16,0,0,0,1,'NpcSolarPlant',NULL,18,17,NULL,1,1000,NULL,0,NULL,NULL,0),(36,38,0,0,0,0,0,1,'NpcMetalExtractor',NULL,1,1,NULL,1,400,NULL,0,NULL,NULL,0),(37,38,7,0,0,0,0,1,'NpcCommunicationsHub',NULL,9,1,NULL,1,1200,NULL,0,NULL,NULL,0),(38,38,18,0,0,0,0,1,'NpcSolarPlant',NULL,19,1,NULL,1,1000,NULL,0,NULL,NULL,0),(39,38,3,1,0,0,0,1,'NpcMetalExtractor',NULL,4,2,NULL,1,400,NULL,0,NULL,NULL,0),(40,38,12,1,0,0,0,1,'NpcSolarPlant',NULL,13,2,NULL,1,1000,NULL,0,NULL,NULL,0),(41,38,22,1,0,0,0,1,'NpcSolarPlant',NULL,23,2,NULL,1,1000,NULL,0,NULL,NULL,0),(42,38,26,1,0,0,0,1,'NpcCommunicationsHub',NULL,28,2,NULL,1,1200,NULL,0,NULL,NULL,0),(43,38,15,3,0,0,0,1,'NpcSolarPlant',NULL,16,4,NULL,1,1000,NULL,0,NULL,NULL,0),(44,38,18,3,0,0,0,1,'NpcSolarPlant',NULL,19,4,NULL,1,1000,NULL,0,NULL,NULL,0),(45,38,24,4,0,0,0,1,'NpcMetalExtractor',NULL,25,5,NULL,1,400,NULL,0,NULL,NULL,0),(46,38,28,4,0,0,0,1,'NpcMetalExtractor',NULL,29,5,NULL,1,400,NULL,0,NULL,NULL,0),(47,38,7,6,0,0,0,1,'Screamer',NULL,8,7,NULL,1,1300,NULL,0,NULL,NULL,0),(48,38,21,6,0,0,0,1,'Vulcan',NULL,22,7,NULL,1,1000,NULL,0,NULL,NULL,0),(49,38,14,7,0,0,0,1,'Thunder',NULL,15,8,NULL,1,2000,NULL,0,NULL,NULL,0),(50,38,25,7,0,0,0,1,'NpcTemple',NULL,27,9,NULL,1,1500,NULL,0,NULL,NULL,0),(51,38,11,10,0,0,0,1,'Mothership',NULL,18,15,NULL,1,10500,NULL,0,NULL,NULL,0),(52,38,7,12,0,0,0,1,'Thunder',NULL,8,13,NULL,1,2000,NULL,0,NULL,NULL,0),(53,38,21,12,0,0,0,1,'Thunder',NULL,22,13,NULL,1,2000,NULL,0,NULL,NULL,0),(54,38,26,12,0,0,0,1,'NpcZetiumExtractor',NULL,27,13,NULL,1,800,NULL,0,NULL,NULL,0),(55,38,7,19,0,0,0,1,'Vulcan',NULL,8,20,NULL,1,1000,NULL,0,NULL,NULL,0),(56,38,14,19,0,0,0,1,'Thunder',NULL,15,20,NULL,1,2000,NULL,0,NULL,NULL,0),(57,38,21,19,0,0,0,1,'Screamer',NULL,22,20,NULL,1,1300,NULL,0,NULL,NULL,0),(58,41,24,6,0,0,0,1,'NpcMetalExtractor',NULL,25,7,NULL,1,400,NULL,0,NULL,NULL,0),(59,41,20,39,0,0,0,1,'NpcGeothermalPlant',NULL,21,40,NULL,1,600,NULL,0,NULL,NULL,0),(60,41,8,3,0,0,0,1,'NpcZetiumExtractor',NULL,9,4,NULL,1,800,NULL,0,NULL,NULL,0),(61,41,13,6,0,0,0,1,'NpcZetiumExtractor',NULL,14,7,NULL,1,800,NULL,0,NULL,NULL,0),(62,41,29,42,0,0,0,1,'NpcCommunicationsHub',NULL,31,43,NULL,1,1200,NULL,0,NULL,NULL,0),(63,41,29,34,0,0,0,1,'NpcExcavationSite',NULL,32,37,NULL,1,2000,NULL,0,NULL,NULL,0),(64,41,25,13,0,0,0,1,'NpcCommunicationsHub',NULL,27,14,NULL,1,1200,NULL,0,NULL,NULL,0),(65,41,10,26,0,0,0,1,'NpcSolarPlant',NULL,11,27,NULL,1,1000,NULL,0,NULL,NULL,0),(66,41,13,22,0,0,0,1,'NpcSolarPlant',NULL,14,23,NULL,1,1000,NULL,0,NULL,NULL,0),(67,41,13,36,0,0,0,1,'NpcSolarPlant',NULL,14,37,NULL,1,1000,NULL,0,NULL,NULL,0),(68,41,28,29,0,0,0,1,'NpcSolarPlant',NULL,29,30,NULL,1,1000,NULL,0,NULL,NULL,0),(69,42,7,13,0,0,0,1,'NpcMetalExtractor',NULL,8,14,NULL,1,400,NULL,0,NULL,NULL,0),(70,42,4,1,0,0,0,1,'NpcMetalExtractor',NULL,5,2,NULL,1,400,NULL,0,NULL,NULL,0),(71,42,1,23,0,0,0,1,'NpcMetalExtractor',NULL,2,24,NULL,1,400,NULL,0,NULL,NULL,0),(72,42,6,23,0,0,0,1,'NpcGeothermalPlant',NULL,7,24,NULL,1,600,NULL,0,NULL,NULL,0),(73,42,9,17,0,0,0,1,'NpcZetiumExtractor',NULL,10,18,NULL,1,800,NULL,0,NULL,NULL,0),(74,42,1,9,0,0,0,1,'NpcSolarPlant',NULL,2,10,NULL,1,1000,NULL,0,NULL,NULL,0),(75,42,10,20,0,0,0,1,'NpcSolarPlant',NULL,11,21,NULL,1,1000,NULL,0,NULL,NULL,0),(76,42,6,16,0,0,0,1,'NpcSolarPlant',NULL,7,17,NULL,1,1000,NULL,0,NULL,NULL,0),(77,49,4,9,0,0,0,1,'NpcMetalExtractor',NULL,5,10,NULL,1,400,NULL,0,NULL,NULL,0),(78,49,28,13,0,0,0,1,'NpcMetalExtractor',NULL,29,14,NULL,1,400,NULL,0,NULL,NULL,0),(79,49,16,2,0,0,0,1,'NpcMetalExtractor',NULL,17,3,NULL,1,400,NULL,0,NULL,NULL,0),(80,49,23,21,0,0,0,1,'NpcMetalExtractor',NULL,24,22,NULL,1,400,NULL,0,NULL,NULL,0),(81,49,8,5,0,0,0,1,'NpcGeothermalPlant',NULL,9,6,NULL,1,600,NULL,0,NULL,NULL,0),(82,49,7,14,0,0,0,1,'NpcZetiumExtractor',NULL,8,15,NULL,1,800,NULL,0,NULL,NULL,0),(83,49,10,12,0,0,0,1,'NpcCommunicationsHub',NULL,12,13,NULL,1,1200,NULL,0,NULL,NULL,0),(84,49,24,3,0,0,0,1,'NpcSolarPlant',NULL,25,4,NULL,1,1000,NULL,0,NULL,NULL,0),(85,49,7,1,0,0,0,1,'NpcSolarPlant',NULL,8,2,NULL,1,1000,NULL,0,NULL,NULL,0),(86,49,11,5,0,0,0,1,'NpcSolarPlant',NULL,12,6,NULL,1,1000,NULL,0,NULL,NULL,0),(87,55,33,2,0,0,0,1,'NpcMetalExtractor',NULL,34,3,NULL,1,400,NULL,0,NULL,NULL,0),(88,55,46,10,0,0,0,1,'NpcMetalExtractor',NULL,47,11,NULL,1,400,NULL,0,NULL,NULL,0),(89,55,41,3,0,0,0,1,'NpcGeothermalPlant',NULL,42,4,NULL,1,600,NULL,0,NULL,NULL,0),(90,55,29,6,0,0,0,1,'NpcZetiumExtractor',NULL,30,7,NULL,1,800,NULL,0,NULL,NULL,0),(91,55,29,14,0,0,0,1,'NpcZetiumExtractor',NULL,30,15,NULL,1,800,NULL,0,NULL,NULL,0),(92,55,32,17,0,0,0,1,'NpcResearchCenter',NULL,35,20,NULL,1,4000,NULL,0,NULL,NULL,0),(93,55,1,1,0,0,0,1,'NpcExcavationSite',NULL,4,4,NULL,1,2000,NULL,0,NULL,NULL,0),(94,55,45,17,0,0,0,1,'NpcTemple',NULL,47,19,NULL,1,1500,NULL,0,NULL,NULL,0),(95,55,32,13,0,0,0,1,'NpcCommunicationsHub',NULL,34,14,NULL,1,1200,NULL,0,NULL,NULL,0),(96,55,49,5,0,0,0,1,'NpcSolarPlant',NULL,50,6,NULL,1,1000,NULL,0,NULL,NULL,0),(97,55,45,7,0,0,0,1,'NpcSolarPlant',NULL,46,8,NULL,1,1000,NULL,0,NULL,NULL,0),(98,55,44,2,0,0,0,1,'NpcSolarPlant',NULL,45,3,NULL,1,1000,NULL,0,NULL,NULL,0);
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
INSERT INTO `folliages` VALUES (5,0,0,7),(5,0,7,7),(5,0,14,3),(5,0,17,10),(5,0,30,3),(5,0,31,6),(5,1,3,6),(5,1,4,13),(5,1,14,6),(5,1,15,9),(5,1,29,1),(5,1,30,12),(5,1,32,4),(5,2,29,8),(5,2,30,10),(5,2,31,7),(5,2,32,9),(5,3,6,8),(5,3,7,0),(5,3,16,11),(5,3,29,5),(5,4,0,10),(5,4,15,10),(5,4,22,8),(5,4,28,11),(5,4,31,10),(5,6,11,10),(5,6,13,6),(5,6,20,9),(5,6,21,12),(5,7,6,12),(5,7,10,4),(5,7,13,10),(5,7,16,7),(5,7,21,11),(5,8,1,4),(5,8,6,10),(5,8,7,9),(5,8,8,9),(5,8,12,1),(5,8,26,6),(5,8,27,1),(5,9,2,3),(5,9,8,3),(5,9,9,8),(5,9,10,4),(5,9,26,10),(5,9,27,10),(5,9,29,12),(5,10,6,2),(5,10,28,3),(5,11,0,10),(5,11,2,4),(5,11,11,10),(5,11,19,11),(5,11,24,13),(5,12,0,6),(5,12,1,4),(5,12,14,4),(5,12,20,10),(5,12,22,11),(5,12,26,2),(5,13,0,13),(5,14,15,7),(5,14,17,1),(5,14,18,6),(5,14,32,2),(5,15,30,7),(5,15,32,1),(5,16,3,6),(5,16,4,4),(5,16,17,0),(5,16,20,8),(5,17,2,11),(5,17,4,11),(5,17,16,11),(5,17,20,10),(5,17,22,11),(5,17,26,10),(5,18,4,2),(5,18,8,13),(5,18,9,10),(5,18,10,0),(5,18,14,13),(5,18,16,0),(5,18,27,7),(14,0,1,11),(14,0,22,10),(14,0,24,3),(14,1,2,1),(14,1,23,8),(14,1,24,2),(14,1,25,9),(14,1,27,3),(14,2,2,5),(14,2,4,3),(14,2,5,6),(14,2,13,5),(14,2,25,10),(14,3,4,12),(14,3,5,0),(14,3,6,11),(14,4,1,12),(14,4,5,0),(14,4,12,6),(14,4,13,1),(14,4,19,9),(14,4,21,5),(14,4,26,2),(14,4,28,7),(14,5,5,10),(14,5,29,8),(14,5,30,9),(14,6,3,2),(14,6,4,1),(14,6,10,4),(14,6,11,2),(14,6,20,6),(14,7,1,8),(14,7,4,10),(14,7,6,11),(14,7,7,0),(14,7,8,11),(14,7,11,8),(14,7,19,13),(14,7,29,3),(14,8,3,6),(14,8,11,7),(14,8,13,9),(14,8,22,3),(14,8,29,10),(14,9,5,0),(14,9,10,6),(14,9,28,2),(14,10,4,10),(14,10,22,13),(14,10,30,4),(14,11,6,4),(14,11,11,4),(14,11,21,8),(14,11,22,0),(14,11,28,5),(14,11,30,12),(14,12,6,13),(14,12,8,9),(14,12,11,3),(14,12,24,4),(14,12,27,8),(14,12,28,9),(14,12,30,6),(14,13,5,2),(14,13,7,9),(14,13,22,7),(14,13,27,7),(14,14,10,0),(14,14,17,6),(14,14,18,2),(14,14,24,11),(14,14,25,2),(14,14,29,0),(14,15,7,0),(14,15,8,10),(14,15,14,3),(14,15,20,5),(14,15,21,9),(14,15,23,0),(14,15,24,11),(14,15,30,4),(14,16,11,1),(14,16,12,7),(14,16,20,3),(14,17,13,12),(14,17,14,3),(14,17,15,2),(14,17,22,1),(14,17,23,6),(14,17,24,9),(14,18,20,3),(14,18,25,0),(14,19,1,2),(14,19,5,4),(14,19,21,7),(14,19,24,0),(14,19,26,11),(14,20,17,11),(14,20,21,2),(14,20,23,8),(14,21,25,1),(14,22,0,7),(14,22,2,6),(14,22,16,6),(14,22,17,2),(14,22,20,5),(14,22,21,3),(14,22,24,5),(14,23,0,8),(14,23,16,0),(14,23,21,6),(14,24,1,1),(14,24,2,8),(14,24,9,4),(14,24,16,2),(14,24,17,6),(14,24,19,4),(14,25,16,8),(14,25,18,3),(14,26,12,1),(14,26,19,2),(14,27,0,2),(14,27,12,9),(14,27,18,9),(14,27,20,5),(14,28,2,3),(14,28,13,13),(14,28,16,7),(14,29,0,11),(14,29,3,11),(14,29,14,2),(14,29,15,6),(14,30,13,10),(14,30,15,8),(14,30,29,9),(14,30,30,9),(14,31,14,3),(14,31,15,7),(14,31,21,2),(14,31,29,4),(14,32,4,9),(14,32,16,9),(14,32,26,10),(14,33,3,11),(14,33,6,4),(14,33,26,13),(14,33,28,10),(14,33,30,8),(14,34,12,3),(14,34,13,2),(14,34,15,1),(14,34,25,2),(14,34,30,9),(14,35,13,13),(14,35,15,2),(14,35,16,9),(14,35,25,0),(14,35,30,1),(14,36,4,6),(14,36,5,7),(14,36,12,7),(14,36,14,6),(14,36,17,11),(14,37,0,9),(14,37,1,10),(14,37,3,9),(14,37,14,4),(14,37,15,8),(14,38,2,3),(14,38,7,8),(14,38,13,7),(14,38,20,2),(14,38,23,3),(14,39,7,8),(14,39,19,3),(14,39,21,3),(14,40,6,2),(14,40,23,1),(14,41,0,12),(14,41,6,13),(14,41,20,3),(14,41,21,7),(14,41,22,2),(14,41,24,1),(27,0,14,2),(27,0,15,5),(27,0,18,13),(27,0,19,3),(27,0,21,13),(27,0,23,4),(27,0,26,9),(27,0,28,9),(27,0,30,8),(27,0,31,10),(27,1,6,6),(27,1,7,1),(27,1,9,3),(27,1,12,6),(27,1,15,10),(27,1,21,10),(27,1,29,9),(27,1,30,2),(27,2,6,11),(27,2,10,10),(27,2,16,5),(27,2,18,3),(27,2,24,1),(27,2,28,10),(27,3,13,10),(27,3,21,2),(27,3,28,6),(27,3,29,2),(27,4,14,3),(27,4,16,11),(27,4,17,5),(27,4,18,2),(27,4,19,9),(27,4,26,3),(27,5,13,11),(27,5,23,13),(27,6,21,3),(27,7,2,0),(27,7,7,9),(27,7,8,3),(27,7,14,11),(27,7,16,10),(27,7,17,5),(27,7,19,11),(27,7,24,2),(27,7,26,3),(27,7,33,4),(27,8,5,1),(27,8,12,6),(27,8,20,7),(27,9,5,9),(27,9,7,10),(27,9,8,5),(27,9,13,12),(27,9,29,8),(27,10,6,0),(27,10,7,2),(27,10,10,6),(27,10,12,5),(27,10,16,3),(27,10,17,0),(27,11,7,1),(27,11,11,7),(27,11,20,9),(27,12,8,12),(27,12,11,6),(27,12,14,1),(27,12,29,0),(27,13,8,10),(27,13,20,3),(27,13,34,11),(27,14,2,3),(27,14,3,2),(27,14,8,9),(27,14,17,2),(27,14,22,7),(27,14,23,11),(27,14,24,5),(27,15,1,9),(27,15,2,4),(27,15,7,1),(27,15,12,0),(27,15,15,12),(27,15,19,8),(27,16,9,3),(27,16,13,3),(27,16,20,0),(27,16,21,9),(27,17,6,8),(27,17,9,3),(27,17,10,9),(27,17,14,3),(27,17,21,5),(27,18,10,5),(27,18,32,0),(27,18,33,1),(27,19,15,7),(27,19,16,7),(27,19,32,3),(27,19,34,1),(27,20,11,0),(27,20,13,10),(27,20,14,8),(27,20,15,0),(27,20,16,5),(27,20,18,7),(27,21,11,2),(27,21,15,6),(27,21,20,7),(27,21,21,11),(27,22,13,5),(27,22,19,3),(27,22,20,2),(27,22,24,11),(27,23,9,10),(27,23,27,9),(27,23,30,3),(27,23,34,3),(27,24,25,4),(27,24,33,2),(27,24,34,3),(27,25,6,8),(27,25,8,4),(27,25,9,4),(27,25,18,6),(27,25,19,6),(27,25,25,4),(27,26,6,3),(27,26,11,11),(27,26,15,4),(27,26,18,4),(27,26,23,3),(27,26,24,10),(27,26,27,10),(27,26,28,0),(27,26,30,7),(27,27,9,13),(27,27,12,13),(27,27,13,0),(27,27,15,0),(27,27,21,10),(27,27,27,3),(27,27,30,5),(27,27,34,8),(27,28,1,4),(27,28,3,7),(27,28,6,11),(27,28,9,0),(27,28,12,2),(27,28,26,13),(27,28,30,4),(27,29,1,8),(27,29,2,6),(27,29,7,9),(27,29,29,7),(27,30,0,10),(27,30,1,5),(27,30,2,5),(27,30,11,7),(27,30,31,2),(27,31,6,2),(27,31,10,0),(27,31,32,11),(27,32,9,9),(27,32,32,9),(27,33,7,4),(27,33,9,8),(27,33,10,6),(27,33,23,3),(27,33,30,4),(27,33,32,13),(27,33,33,5),(27,34,7,6),(27,34,8,9),(27,34,11,4),(27,34,34,7),(38,0,22,11),(38,1,2,11),(38,2,24,6),(38,2,26,10),(38,3,0,2),(38,3,3,8),(38,3,25,0),(38,3,26,11),(38,4,0,5),(38,4,3,7),(38,4,14,8),(38,4,15,11),(38,4,20,7),(38,4,24,10),(38,5,6,10),(38,5,7,3),(38,5,12,4),(38,5,15,5),(38,5,28,7),(38,5,29,10),(38,6,1,3),(38,6,2,3),(38,6,5,7),(38,6,10,13),(38,6,20,2),(38,6,22,4),(38,6,23,6),(38,6,27,7),(38,7,4,6),(38,7,11,3),(38,8,5,6),(38,8,15,2),(38,8,21,10),(38,8,29,9),(38,9,2,2),(38,9,7,10),(38,9,10,9),(38,9,13,1),(38,9,19,1),(38,9,21,0),(38,10,8,4),(38,10,12,4),(38,10,15,4),(38,10,29,3),(38,11,8,1),(38,11,16,3),(38,11,18,0),(38,11,22,6),(38,12,8,11),(38,12,16,7),(38,12,21,8),(38,12,29,11),(38,13,7,8),(38,13,8,9),(38,13,16,12),(38,13,18,10),(38,13,19,10),(38,13,20,5),(38,13,21,0),(38,14,18,4),(38,14,24,10),(38,14,28,3),(38,14,29,3),(38,15,17,10),(38,15,18,11),(38,15,21,8),(38,15,28,9),(38,16,5,11),(38,16,8,9),(38,16,20,8),(38,16,22,7),(38,16,27,10),(38,17,7,2),(38,17,8,8),(38,17,18,11),(38,17,22,11),(38,17,24,3),(38,18,6,5),(38,18,16,5),(38,18,17,3),(38,18,20,8),(38,19,15,8),(38,19,17,8),(38,19,19,8),(38,19,25,10),(38,19,26,0),(38,19,27,8),(38,20,9,2),(38,20,11,2),(38,20,16,6),(38,20,17,4),(38,20,20,8),(38,21,14,4),(38,21,16,4),(38,21,18,9),(38,21,21,1),(38,21,27,11),(38,22,4,0),(38,22,5,6),(38,22,23,7),(38,23,13,3),(38,23,16,3),(38,23,17,8),(38,23,18,8),(38,23,22,6),(38,24,6,8),(38,24,13,7),(38,24,22,3),(38,24,23,3),(38,25,0,4),(38,25,6,13),(38,25,21,11),(38,25,23,1),(38,25,24,3),(38,26,14,1),(38,26,16,9),(38,26,21,7),(38,27,0,2),(38,27,11,1),(38,27,14,9),(38,27,19,12),(38,27,27,3),(38,27,28,0),(38,27,29,3),(38,29,1,11),(38,29,3,9),(38,29,6,2),(38,29,14,11),(38,29,15,10),(41,0,9,8),(41,0,10,10),(41,0,24,3),(41,0,25,12),(41,0,41,11),(41,0,43,8),(41,1,6,11),(41,1,7,4),(41,1,10,7),(41,1,21,5),(41,1,22,3),(41,1,27,2),(41,1,28,2),(41,1,38,4),(41,1,40,3),(41,1,41,8),(41,2,9,5),(41,2,15,10),(41,2,16,0),(41,2,21,6),(41,2,28,6),(41,2,34,5),(41,2,37,10),(41,2,42,7),(41,2,43,5),(41,3,0,4),(41,3,16,8),(41,3,22,11),(41,3,27,5),(41,3,28,1),(41,3,36,4),(41,3,41,1),(41,3,43,10),(41,4,16,8),(41,4,22,7),(41,4,38,10),(41,4,41,13),(41,4,42,3),(41,5,3,12),(41,5,8,3),(41,5,18,2),(41,5,25,2),(41,5,31,3),(41,5,36,3),(41,6,0,1),(41,6,1,1),(41,6,11,13),(41,6,13,1),(41,6,16,0),(41,6,21,3),(41,6,23,2),(41,6,37,11),(41,7,10,4),(41,7,15,10),(41,7,17,0),(41,7,19,7),(41,7,26,8),(41,7,32,6),(41,7,33,1),(41,7,38,11),(41,7,41,1),(41,8,14,9),(41,8,17,0),(41,8,18,10),(41,8,31,0),(41,8,34,1),(41,9,26,0),(41,9,35,3),(41,9,36,7),(41,9,39,9),(41,10,15,8),(41,10,19,7),(41,10,33,4),(41,10,34,11),(41,10,38,11),(41,10,41,11),(41,11,17,12),(41,11,30,10),(41,11,32,3),(41,11,33,3),(41,11,34,2),(41,11,39,9),(41,11,41,5),(41,11,43,0),(41,12,8,7),(41,12,26,8),(41,12,32,1),(41,12,35,2),(41,12,36,8),(41,12,40,2),(41,13,1,9),(41,13,13,3),(41,13,14,10),(41,13,31,8),(41,13,39,12),(41,13,40,1),(41,14,11,7),(41,14,15,6),(41,14,18,1),(41,14,32,8),(41,14,39,11),(41,14,41,9),(41,15,2,9),(41,15,5,11),(41,15,6,4),(41,15,11,5),(41,15,20,5),(41,15,22,1),(41,15,23,8),(41,15,28,8),(41,15,32,4),(41,15,33,10),(41,15,34,8),(41,15,35,5),(41,15,37,4),(41,15,38,8),(41,15,39,6),(41,16,1,9),(41,16,5,6),(41,16,7,8),(41,16,8,0),(41,16,10,4),(41,16,11,7),(41,16,23,11),(41,16,28,2),(41,16,29,2),(41,16,32,5),(41,16,35,4),(41,16,36,8),(41,16,37,4),(41,17,7,8),(41,17,9,0),(41,17,10,5),(41,17,21,1),(41,17,23,4),(41,17,25,10),(41,17,33,0),(41,18,10,10),(41,18,16,8),(41,18,19,8),(41,18,23,6),(41,18,32,9),(41,18,36,8),(41,18,37,0),(41,18,38,10),(41,19,9,12),(41,19,11,9),(41,19,14,4),(41,19,21,6),(41,19,35,8),(41,19,36,11),(41,19,39,0),(41,20,6,6),(41,20,8,13),(41,20,10,3),(41,20,17,7),(41,20,42,0),(41,21,8,9),(41,21,14,1),(41,21,16,6),(41,21,17,11),(41,21,18,11),(41,21,24,9),(41,21,25,4),(41,21,26,2),(41,21,29,10),(41,21,30,1),(41,21,31,9),(41,22,11,10),(41,22,27,9),(41,22,32,11),(41,23,11,2),(41,23,12,3),(41,23,13,12),(41,23,27,4),(41,23,29,8),(41,23,31,6),(41,24,1,8),(41,24,12,11),(41,24,27,4),(41,24,28,5),(41,24,29,3),(41,25,1,1),(41,25,12,1),(41,25,28,6),(41,25,35,8),(41,25,36,13),(41,26,2,6),(41,26,3,5),(41,26,5,6),(41,26,29,7),(41,26,30,8),(41,26,40,11),(41,26,42,9),(41,26,43,5),(41,27,2,4),(41,27,3,4),(41,27,12,11),(41,27,33,1),(41,27,37,4),(41,27,38,2),(41,28,11,4),(41,28,13,5),(41,28,31,1),(41,28,41,5),(41,28,42,13),(41,29,12,11),(41,29,13,5),(41,29,14,11),(41,29,25,5),(41,29,26,7),(41,30,13,3),(41,30,31,7),(41,30,32,9),(41,30,38,2),(41,31,12,10),(41,31,15,9),(41,31,27,8),(41,31,28,4),(41,31,30,6),(41,32,1,1),(41,32,18,0),(41,32,22,7),(41,32,28,13),(41,32,32,11),(41,32,33,4),(41,32,41,8),(42,0,2,2),(42,0,7,13),(42,0,11,2),(42,0,14,12),(42,0,16,7),(42,0,18,1),(42,0,30,11),(42,0,38,5),(42,1,0,5),(42,1,3,9),(42,1,7,10),(42,1,19,9),(42,1,27,10),(42,1,36,9),(42,2,13,1),(42,2,27,3),(42,2,30,0),(42,2,36,8),(42,2,38,1),(42,3,8,11),(42,3,11,4),(42,3,13,2),(42,3,14,2),(42,3,24,10),(42,3,26,6),(42,3,35,0),(42,4,9,2),(42,4,12,7),(42,4,18,7),(42,4,22,3),(42,4,23,8),(42,4,24,9),(42,4,28,9),(42,4,31,2),(42,4,32,13),(42,5,6,10),(42,5,11,6),(42,5,12,13),(42,5,29,2),(42,5,30,6),(42,5,34,2),(42,5,44,10),(42,6,4,4),(42,6,14,10),(42,6,34,2),(42,6,44,11),(42,6,45,13),(42,7,11,2),(42,7,12,5),(42,7,25,2),(42,7,30,9),(42,7,36,3),(42,7,41,10),(42,7,42,3),(42,8,10,4),(42,8,11,3),(42,8,12,0),(42,8,17,9),(42,8,24,10),(42,8,31,3),(42,8,35,10),(42,8,37,2),(42,8,44,4),(42,9,10,5),(42,9,13,0),(42,9,14,6),(42,9,27,7),(42,10,13,12),(42,10,14,7),(42,10,30,2),(42,10,45,10),(42,11,11,7),(42,11,13,3),(42,11,19,0),(42,11,22,6),(42,11,23,12),(42,11,25,5),(42,11,30,5),(42,11,45,9),(49,0,3,12),(49,0,15,1),(49,0,25,4),(49,1,1,8),(49,1,4,0),(49,1,10,13),(49,1,23,13),(49,1,25,6),(49,2,4,6),(49,2,12,6),(49,2,22,10),(49,3,1,11),(49,3,5,5),(49,3,7,9),(49,3,12,2),(49,3,13,6),(49,3,23,10),(49,3,25,8),(49,4,2,6),(49,4,21,1),(49,4,23,1),(49,5,1,4),(49,5,2,7),(49,5,4,5),(49,5,13,3),(49,5,19,11),(49,6,5,5),(49,6,7,11),(49,6,10,2),(49,7,0,7),(49,7,3,0),(49,7,7,6),(49,7,8,0),(49,7,24,0),(49,8,4,10),(49,8,7,1),(49,9,2,3),(49,9,8,3),(49,9,14,5),(49,10,1,11),(49,10,2,8),(49,10,4,4),(49,10,15,3),(49,10,25,8),(49,11,0,11),(49,11,2,5),(49,12,0,11),(49,12,4,6),(49,13,0,12),(49,13,3,0),(49,14,15,10),(49,14,23,6),(49,14,24,9),(49,15,16,11),(49,15,22,2),(49,15,23,7),(49,16,0,9),(49,16,5,13),(49,16,14,6),(49,17,5,2),(49,17,21,2),(49,19,0,1),(49,19,1,11),(49,19,2,7),(49,19,3,3),(49,19,5,1),(49,20,0,3),(49,20,2,12),(49,20,3,10),(49,20,5,13),(49,20,12,5),(49,20,20,6),(49,20,25,8),(49,21,0,13),(49,21,2,0),(49,21,3,0),(49,21,5,1),(49,21,6,10),(49,21,13,6),(49,21,14,5),(49,21,20,10),(49,21,25,8),(49,22,0,6),(49,22,2,7),(49,22,12,9),(49,22,16,3),(49,22,18,4),(49,23,6,1),(49,23,7,9),(49,23,15,4),(49,23,20,10),(49,24,2,13),(49,24,5,1),(49,25,0,3),(49,25,10,3),(49,25,21,11),(49,25,22,10),(49,26,0,3),(49,26,1,9),(49,26,2,7),(49,26,23,0),(49,27,6,7),(49,28,22,4),(49,30,1,0),(49,30,20,12),(55,0,11,9),(55,0,17,5),(55,1,7,7),(55,1,10,6),(55,1,13,11),(55,1,17,4),(55,1,19,4),(55,2,15,11),(55,2,16,4),(55,3,0,3),(55,3,17,4),(55,4,15,5),(55,4,16,7),(55,5,14,9),(55,5,16,5),(55,6,1,6),(55,6,5,1),(55,6,15,13),(55,7,5,5),(55,7,10,1),(55,8,3,11),(55,8,7,7),(55,8,16,5),(55,8,20,5),(55,9,0,7),(55,9,1,3),(55,9,13,2),(55,9,14,11),(55,9,20,0),(55,10,2,7),(55,10,9,8),(55,11,2,5),(55,11,19,0),(55,11,20,5),(55,12,1,0),(55,12,2,1),(55,12,5,9),(55,12,9,4),(55,12,15,8),(55,12,18,6),(55,13,1,3),(55,13,5,4),(55,13,6,7),(55,13,8,3),(55,13,15,11),(55,13,17,8),(55,13,18,6),(55,13,19,2),(55,13,20,4),(55,14,3,5),(55,14,4,5),(55,14,10,0),(55,14,11,3),(55,14,16,7),(55,14,20,0),(55,15,11,8),(55,15,14,7),(55,15,16,9),(55,15,20,3),(55,16,13,9),(55,17,12,9),(55,18,11,0),(55,18,12,8),(55,18,16,8),(55,19,2,6),(55,19,12,4),(55,19,13,10),(55,19,16,3),(55,20,7,1),(55,20,10,5),(55,20,20,11),(55,21,6,9),(55,21,14,10),(55,22,5,3),(55,22,12,6),(55,22,14,9),(55,22,15,0),(55,22,19,13),(55,23,12,6),(55,23,13,0),(55,24,5,6),(55,24,10,9),(55,24,13,9),(55,24,14,11),(55,24,15,3),(55,25,12,11),(55,25,14,5),(55,26,8,2),(55,27,4,3),(55,27,7,3),(55,27,10,3),(55,28,4,2),(55,28,5,4),(55,28,19,10),(55,29,20,4),(55,30,19,5),(55,31,1,1),(55,31,16,5),(55,31,17,1),(55,32,8,11),(55,32,12,10),(55,32,15,7),(55,32,16,8),(55,33,0,10),(55,33,12,3),(55,33,15,13),(55,34,16,4),(55,35,4,9),(55,36,0,10),(55,36,6,0),(55,36,8,8),(55,37,5,9),(55,37,7,10),(55,38,8,8),(55,38,10,2),(55,38,20,6),(55,39,1,11),(55,39,7,1),(55,39,9,2),(55,39,17,10),(55,39,18,11),(55,40,8,3),(55,40,9,11),(55,40,17,13),(55,41,10,2),(55,41,19,7),(55,42,10,7),(55,42,18,9),(55,44,18,9),(55,45,20,3),(55,46,3,1),(55,46,6,5),(55,47,6,10),(55,48,16,8),(55,48,20,11),(55,49,20,8),(55,51,5,11),(55,51,6,4),(55,52,3,5),(55,52,5,1),(55,52,6,1),(55,52,7,11),(55,52,8,8),(55,52,9,7),(55,52,10,13),(55,52,11,4);
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
INSERT INTO `galaxies` VALUES (1,'2011-01-03 14:39:10','dev');
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
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `objective_progresses`
--

LOCK TABLES `objective_progresses` WRITE;
/*!40000 ALTER TABLE `objective_progresses` DISABLE KEYS */;
INSERT INTO `objective_progresses` VALUES (1,1,1,0);
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
) ENGINE=InnoDB AUTO_INCREMENT=25 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `objectives`
--

LOCK TABLES `objectives` WRITE;
/*!40000 ALTER TABLE `objectives` DISABLE KEYS */;
INSERT INTO `objectives` VALUES (1,1,'HaveUpgradedTo','Building::CollectorT1',1,1,0,0,NULL),(2,2,'HaveUpgradedTo','Building::MetalExtractor',1,1,0,0,NULL),(3,3,'HaveUpgradedTo','Building::CollectorT1',2,1,0,0,NULL),(4,3,'HaveUpgradedTo','Building::MetalExtractor',2,1,0,0,NULL),(5,4,'HaveUpgradedTo','Building::CollectorT1',2,3,0,0,NULL),(6,4,'HaveUpgradedTo','Building::MetalExtractor',2,3,0,0,NULL),(7,5,'HaveUpgradedTo','Building::CollectorT1',2,4,0,0,NULL),(8,5,'HaveUpgradedTo','Building::MetalExtractor',2,4,0,0,NULL),(9,6,'HaveUpgradedTo','Building::Barracks',1,1,0,0,NULL),(10,7,'HaveUpgradedTo','Unit::Trooper',2,1,0,0,NULL),(11,8,'DestroyNpcBuilding','Building::NpcMetalExtractor',1,1,0,0,NULL),(12,9,'HaveUpgradedTo','Building::MetalExtractor',1,7,0,0,NULL),(13,10,'HaveUpgradedTo','Building::CollectorT1',1,7,0,0,NULL),(14,11,'HaveUpgradedTo','Building::ResearchCenter',1,1,0,0,NULL),(15,12,'HaveUpgradedTo','Unit::Seeker',3,1,0,0,NULL),(16,13,'HaveUpgradedTo','Unit::Trooper',5,1,0,0,NULL),(17,14,'HaveUpgradedTo','Technology::ZetiumExtraction',1,1,0,0,NULL),(18,15,'HaveUpgradedTo','Building::ZetiumExtractor',1,1,0,0,NULL),(19,16,'HavePoints','Player',1,NULL,0,0,3000),(20,17,'HaveUpgradedTo','Building::EnergyStorage',1,1,0,0,NULL),(21,17,'HaveUpgradedTo','Building::MetalStorage',1,1,0,0,NULL),(22,17,'HaveUpgradedTo','Building::ZetiumStorage',1,1,0,0,NULL),(23,18,'HaveUpgradedTo','Technology::SpaceFactory',1,1,0,0,NULL),(24,19,'HaveUpgradedTo','Building::SpaceFactory',1,1,0,0,NULL);
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
INSERT INTO `players` VALUES (1,1,'0000000000000000000000000000000000000000000000000000000000000000','Test Player',9,9,NULL,0,0);
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
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `quest_progresses`
--

LOCK TABLES `quest_progresses` WRITE;
/*!40000 ALTER TABLE `quest_progresses` DISABLE KEYS */;
INSERT INTO `quest_progresses` VALUES (1,1,1,0,0);
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
) ENGINE=InnoDB AUTO_INCREMENT=20 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `quests`
--

LOCK TABLES `quests` WRITE;
/*!40000 ALTER TABLE `quests` DISABLE KEYS */;
INSERT INTO `quests` VALUES (1,NULL,'{\"metal\":1000,\"energy\":1000}','building'),(2,1,'{\"metal\":1000,\"energy\":1000}','metal-extraction'),(3,2,'{\"metal\":1000,\"energy\":1000}',NULL),(4,3,'{\"metal\":1000,\"energy\":1000}',NULL),(5,4,'{\"metal\":1000,\"energy\":1000}',NULL),(6,3,'{\"metal\":1500,\"energy\":1500}',NULL),(7,6,'{\"metal\":1000,\"energy\":1000}','building-units'),(8,7,'{\"units\":[{\"level\":2,\"type\":\"Trooper\",\"count\":1,\"hp\":50},{\"level\":3,\"type\":\"Trooper\",\"count\":1,\"hp\":20}]}',NULL),(9,8,'{\"metal\":1000,\"energy\":1000}',NULL),(10,8,'{\"metal\":1000,\"energy\":1000}',NULL),(11,8,'{\"metal\":2000,\"energy\":2000,\"zetium\":600}','researching'),(12,11,'{\"metal\":1000,\"energy\":1000,\"zetium\":100}',NULL),(13,12,'{\"metal\":1000,\"energy\":1000,\"zetium\":100}',NULL),(14,11,'{\"metal\":1000,\"energy\":1000,\"zetium\":200}',NULL),(15,14,'{\"metal\":1000,\"energy\":1000,\"zetium\":200}','extracting-zetium'),(16,15,'{\"units\":[{\"level\":2,\"type\":\"Seeker\",\"count\":2,\"hp\":100},{\"level\":2,\"type\":\"Shocker\",\"count\":2,\"hp\":100}]}','collecting-points'),(17,15,'{\"metal\":4000,\"energy\":4000,\"zetium\":2000}','storing-resources'),(18,17,'{\"metal\":4000,\"energy\":4000,\"zetium\":2000}','space-factory'),(19,18,'{\"metal\":4000,\"energy\":4000,\"zetium\":2000}',NULL);
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
INSERT INTO `schema_migrations` VALUES ('20090601175224'),('20090601184051'),('20090601184055'),('20090601184059'),('20090701164131'),('20090713165021'),('20090808144214'),('20090809160211'),('20090810173759'),('20090826140238'),('20090826141836'),('20090829202538'),('20090829210029'),('20090829224505'),('20090830143959'),('20090830145319'),('20090901153809'),('20090904190655'),('20090905175341'),('20090905192056'),('20090906135044'),('20090909222719'),('20090911180950'),('20090912165229'),('20090919155819'),('20091024222359'),('20091103164416'),('20091103180558'),('20091103181146'),('20091109191211'),('20091225193714'),('20100114152902'),('20100121142414'),('20100127115341'),('20100127120219'),('20100127120515'),('20100127121337'),('20100129150736'),('20100203202757'),('20100203204803'),('20100204172507'),('20100204173714'),('20100208163239'),('20100210114531'),('20100212134334'),('20100218181507'),('20100219114448'),('20100220144106'),('20100222144003'),('20100223153023'),('20100224153728'),('20100224163525'),('20100225124928'),('20100225153721'),('20100225155505'),('20100225155739'),('20100226122144'),('20100226122651'),('20100301153626'),('20100302131225'),('20100303131706'),('20100308163148'),('20100308164422'),('20100310172315'),('20100310181338'),('20100311123523'),('20100315112858'),('20100319141401'),('20100322184529'),('20100324134243'),('20100324141652'),('20100331125702'),('20100415130556'),('20100415130600'),('20100415130605'),('20100415134627'),('20100419141518'),('20100419142018'),('20100419164230'),('20100426141509'),('20100428130912'),('20100429171200'),('20100430174140'),('20100610151652'),('20100610180750'),('20100614142225'),('20100614160819'),('20100614162423'),('20100616132525'),('20100616135507'),('20100622124252'),('20100706105523'),('20100710121447'),('20100710191351'),('20100716155807'),('20100719131622'),('20100721155359'),('20100722124307'),('20100812164444'),('20100812164449'),('20100812164518'),('20100812164524'),('20100817165213'),('20100819175736'),('20100820185846'),('20100906095758'),('20100915145823'),('20100929111549'),('20101001155323'),('20101005180058'),('20101022155620'),('20101117131430'),('20101208135417'),('20101209122838'),('20101222150446'),('20101223125157'),('20101223172333'),('99999999999000'),('99999999999900');
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
INSERT INTO `solar_systems` VALUES (1,'Resource',1,1,2),(2,'Expansion',1,0,2),(3,'Homeworld',1,2,0),(4,'Expansion',1,0,1);
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
  `exploration_x` tinyint(2) unsigned DEFAULT NULL,
  `exploration_y` tinyint(2) unsigned DEFAULT NULL,
  `exploration_ends_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uniqueness` (`solar_system_id`,`position`,`angle`),
  KEY `index_planets_on_galaxy_id_and_solar_system_id` (`solar_system_id`),
  KEY `index_planets_on_player_id_and_galaxy_id` (`player_id`),
  KEY `group_by_for_fowssentry_status_updates` (`player_id`,`solar_system_id`),
  CONSTRAINT `ss_objects_ibfk_1` FOREIGN KEY (`solar_system_id`) REFERENCES `solar_systems` (`id`) ON DELETE CASCADE,
  CONSTRAINT `ss_objects_ibfk_2` FOREIGN KEY (`player_id`) REFERENCES `players` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=59 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ss_objects`
--

LOCK TABLES `ss_objects` WRITE;
/*!40000 ALTER TABLE `ss_objects` DISABLE KEYS */;
INSERT INTO `ss_objects` VALUES (1,1,0,0,1,45,'Asteroid',NULL,'',34,0,0,0,1,0,0,2,0,0,1,NULL,0,NULL,NULL,NULL),(2,1,0,0,1,225,'Asteroid',NULL,'',26,0,0,0,1,0,0,0,0,0,1,NULL,0,NULL,NULL,NULL),(3,1,0,0,3,314,'Jumpgate',NULL,'',32,0,0,0,0,0,0,0,0,0,0,NULL,0,NULL,NULL,NULL),(4,1,0,0,1,180,'Asteroid',NULL,'',50,0,0,0,0,0,0,1,0,0,0,NULL,0,NULL,NULL,NULL),(5,1,19,33,1,315,'Planet',NULL,'P-5',46,0,0,0,0,0,0,0,0,0,0,'2011-01-03 14:39:16',0,NULL,NULL,NULL),(6,1,0,0,2,240,'Asteroid',NULL,'',32,0,0,0,1,0,0,3,0,0,2,NULL,0,NULL,NULL,NULL),(7,1,0,0,3,66,'Jumpgate',NULL,'',52,0,0,0,0,0,0,0,0,0,0,NULL,0,NULL,NULL,NULL),(8,1,0,0,3,224,'Jumpgate',NULL,'',55,0,0,0,0,0,0,0,0,0,0,NULL,0,NULL,NULL,NULL),(9,1,0,0,3,44,'Jumpgate',NULL,'',42,0,0,0,0,0,0,0,0,0,0,NULL,0,NULL,NULL,NULL),(10,1,0,0,2,180,'Asteroid',NULL,'',50,0,0,0,1,0,0,3,0,0,3,NULL,0,NULL,NULL,NULL),(11,1,0,0,1,135,'Asteroid',NULL,'',39,0,0,0,2,0,0,3,0,0,2,NULL,0,NULL,NULL,NULL),(12,1,0,0,0,90,'Asteroid',NULL,'',26,0,0,0,3,0,0,2,0,0,3,NULL,0,NULL,NULL,NULL),(13,1,0,0,0,270,'Asteroid',NULL,'',27,0,0,0,2,0,0,1,0,0,1,NULL,0,NULL,NULL,NULL),(14,1,42,31,2,0,'Planet',NULL,'P-14',55,1,0,0,0,0,0,0,0,0,0,'2011-01-03 14:39:16',0,NULL,NULL,NULL),(15,1,0,0,2,270,'Asteroid',NULL,'',35,0,0,0,0,0,0,0,0,0,0,NULL,0,NULL,NULL,NULL),(16,1,0,0,0,180,'Asteroid',NULL,'',26,0,0,0,1,0,0,1,0,0,1,NULL,0,NULL,NULL,NULL),(17,1,0,0,0,0,'Asteroid',NULL,'',38,0,0,0,2,0,0,2,0,0,1,NULL,0,NULL,NULL,NULL),(18,2,0,0,1,45,'Asteroid',NULL,'',57,0,0,0,0,0,0,0,0,0,0,NULL,0,NULL,NULL,NULL),(19,2,0,0,1,225,'Asteroid',NULL,'',33,0,0,0,0,0,0,1,0,0,1,NULL,0,NULL,NULL,NULL),(20,2,0,0,1,180,'Asteroid',NULL,'',52,0,0,0,1,0,0,0,0,0,1,NULL,0,NULL,NULL,NULL),(21,2,0,0,2,210,'Asteroid',NULL,'',27,0,0,0,2,0,0,3,0,0,1,NULL,0,NULL,NULL,NULL),(22,2,0,0,3,292,'Jumpgate',NULL,'',51,0,0,0,0,0,0,0,0,0,0,NULL,0,NULL,NULL,NULL),(23,2,0,0,1,0,'Asteroid',NULL,'',29,0,0,0,1,0,0,0,0,0,0,NULL,0,NULL,NULL,NULL),(24,2,0,0,2,60,'Asteroid',NULL,'',60,0,0,0,1,0,0,2,0,0,3,NULL,0,NULL,NULL,NULL),(25,2,0,0,3,44,'Jumpgate',NULL,'',55,0,0,0,0,0,0,0,0,0,0,NULL,0,NULL,NULL,NULL),(26,2,0,0,2,30,'Asteroid',NULL,'',27,0,0,0,3,0,0,2,0,0,2,NULL,0,NULL,NULL,NULL),(27,2,35,35,0,90,'Planet',NULL,'P-27',54,1,0,0,0,0,0,0,0,0,0,'2011-01-03 14:39:16',0,NULL,NULL,NULL),(28,2,0,0,2,180,'Asteroid',NULL,'',60,0,0,0,1,0,0,0,0,0,1,NULL,0,NULL,NULL,NULL),(29,2,0,0,1,135,'Asteroid',NULL,'',38,0,0,0,1,0,0,3,0,0,1,NULL,0,NULL,NULL,NULL),(30,2,0,0,0,270,'Asteroid',NULL,'',42,0,0,0,3,0,0,1,0,0,3,NULL,0,NULL,NULL,NULL),(31,2,0,0,2,270,'Asteroid',NULL,'',32,0,0,0,1,0,0,1,0,0,0,NULL,0,NULL,NULL,NULL),(32,2,0,0,0,180,'Asteroid',NULL,'',37,0,0,0,0,0,0,0,0,0,1,NULL,0,NULL,NULL,NULL),(33,2,0,0,0,0,'Asteroid',NULL,'',51,0,0,0,3,0,0,2,0,0,3,NULL,0,NULL,NULL,NULL),(34,3,0,0,2,180,'Asteroid',NULL,'',57,0,0,0,1,0,0,1,0,0,0,NULL,0,NULL,NULL,NULL),(35,3,0,0,0,270,'Asteroid',NULL,'',57,0,0,0,0,0,0,1,0,0,1,NULL,0,NULL,NULL,NULL),(36,3,0,0,3,156,'Jumpgate',NULL,'',50,0,0,0,0,0,0,0,0,0,0,NULL,0,NULL,NULL,NULL),(37,3,0,0,1,315,'Asteroid',NULL,'',32,0,0,0,0,0,0,0,0,0,1,NULL,0,NULL,NULL,NULL),(38,3,30,30,2,240,'Planet',1,'P-38',50,0,3186.11,0.0279,9654.87,7042.03,0.0617,21339.5,0,0,2622.17,'2011-01-03 14:39:16',0,NULL,NULL,NULL),(39,3,0,0,0,180,'Asteroid',NULL,'',54,0,0,0,0,0,0,0,0,0,0,NULL,0,NULL,NULL,NULL),(40,3,0,0,1,0,'Asteroid',NULL,'',29,0,0,0,0,0,0,0,0,0,1,NULL,0,NULL,NULL,NULL),(41,3,33,44,0,0,'Planet',NULL,'P-41',57,1,0,0,0,0,0,0,0,0,0,'2011-01-03 14:39:16',0,NULL,NULL,NULL),(42,4,12,46,1,225,'Planet',NULL,'P-42',49,1,0,0,0,0,0,0,0,0,0,'2011-01-03 14:39:16',0,NULL,NULL,NULL),(43,4,0,0,2,90,'Asteroid',NULL,'',26,0,0,0,3,0,0,2,0,0,3,NULL,0,NULL,NULL,NULL),(44,4,0,0,2,210,'Asteroid',NULL,'',43,0,0,0,0,0,0,1,0,0,1,NULL,0,NULL,NULL,NULL),(45,4,0,0,1,180,'Asteroid',NULL,'',51,0,0,0,3,0,0,2,0,0,3,NULL,0,NULL,NULL,NULL),(46,4,0,0,2,240,'Asteroid',NULL,'',55,0,0,0,2,0,0,3,0,0,2,NULL,0,NULL,NULL,NULL),(47,4,0,0,3,292,'Jumpgate',NULL,'',60,0,0,0,0,0,0,0,0,0,0,NULL,0,NULL,NULL,NULL),(48,4,0,0,1,0,'Asteroid',NULL,'',35,0,0,0,1,0,0,0,0,0,1,NULL,0,NULL,NULL,NULL),(49,4,31,26,2,150,'Planet',NULL,'P-49',48,2,0,0,0,0,0,0,0,0,0,'2011-01-03 14:39:16',0,NULL,NULL,NULL),(50,4,0,0,1,135,'Asteroid',NULL,'',37,0,0,0,3,0,0,2,0,0,1,NULL,0,NULL,NULL,NULL),(51,4,0,0,2,180,'Asteroid',NULL,'',28,0,0,0,3,0,0,3,0,0,2,NULL,0,NULL,NULL,NULL),(52,4,0,0,0,90,'Asteroid',NULL,'',41,0,0,0,1,0,0,1,0,0,1,NULL,0,NULL,NULL,NULL),(53,4,0,0,2,330,'Asteroid',NULL,'',26,0,0,0,1,0,0,3,0,0,3,NULL,0,NULL,NULL,NULL),(54,4,0,0,3,336,'Jumpgate',NULL,'',37,0,0,0,0,0,0,0,0,0,0,NULL,0,NULL,NULL,NULL),(55,4,53,21,0,270,'Planet',NULL,'P-55',56,1,0,0,0,0,0,0,0,0,0,'2011-01-03 14:39:16',0,NULL,NULL,NULL),(56,4,0,0,2,0,'Asteroid',NULL,'',55,0,0,0,1,0,0,1,0,0,1,NULL,0,NULL,NULL,NULL),(57,4,0,0,0,180,'Asteroid',NULL,'',28,0,0,0,1,0,0,1,0,0,1,NULL,0,NULL,NULL,NULL),(58,4,0,0,0,0,'Asteroid',NULL,'',46,0,0,0,2,0,0,3,0,0,2,NULL,0,NULL,NULL,NULL);
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
INSERT INTO `tiles` VALUES (12,5,0,8),(6,5,0,18),(3,5,0,19),(3,5,0,20),(3,5,0,21),(3,5,0,22),(3,5,0,23),(3,5,0,24),(13,5,0,25),(3,5,1,5),(6,5,1,17),(6,5,1,18),(4,5,1,19),(3,5,1,20),(3,5,1,21),(3,5,1,24),(3,5,2,5),(6,5,2,16),(6,5,2,17),(4,5,2,18),(4,5,2,19),(4,5,2,20),(4,5,2,21),(3,5,2,24),(3,5,3,5),(4,5,3,17),(4,5,3,18),(4,5,3,19),(4,5,3,20),(4,5,3,21),(3,5,3,23),(3,5,3,24),(0,5,4,1),(3,5,4,3),(3,5,4,4),(3,5,4,5),(3,5,4,6),(3,5,4,7),(8,5,4,17),(4,5,4,20),(4,5,4,21),(3,5,4,23),(5,5,4,24),(1,5,4,29),(5,5,4,32),(3,5,5,3),(3,5,5,4),(3,5,5,5),(4,5,5,21),(4,5,5,22),(5,5,5,23),(5,5,5,24),(3,5,5,27),(3,5,5,28),(5,5,5,32),(6,5,6,3),(3,5,6,4),(3,5,6,5),(4,5,6,22),(5,5,6,24),(5,5,6,25),(3,5,6,26),(3,5,6,27),(3,5,6,28),(3,5,6,29),(5,5,6,32),(6,5,7,2),(6,5,7,3),(2,5,7,14),(5,5,7,17),(5,5,7,18),(5,5,7,19),(4,5,7,22),(5,5,7,23),(5,5,7,24),(3,5,7,25),(3,5,7,26),(3,5,7,27),(3,5,7,28),(3,5,7,29),(5,5,7,32),(6,5,8,2),(6,5,8,3),(5,5,8,17),(5,5,8,18),(5,5,8,19),(5,5,8,20),(5,5,8,22),(5,5,8,23),(5,5,8,24),(5,5,8,25),(3,5,8,28),(3,5,8,29),(5,5,8,32),(3,5,9,0),(3,5,9,1),(3,5,9,3),(3,5,9,4),(3,5,9,5),(3,5,9,6),(5,5,9,12),(6,5,9,18),(5,5,9,19),(5,5,9,20),(5,5,9,21),(0,5,9,22),(5,5,9,24),(5,5,9,25),(5,5,9,30),(5,5,9,31),(5,5,9,32),(3,5,10,0),(3,5,10,1),(3,5,10,2),(3,5,10,3),(3,5,10,4),(3,5,10,5),(5,5,10,12),(5,5,10,13),(5,5,10,14),(5,5,10,15),(5,5,10,16),(6,5,10,18),(6,5,10,19),(5,5,10,20),(5,5,10,24),(1,5,10,26),(5,5,10,30),(5,5,10,31),(5,5,10,32),(3,5,11,1),(12,5,11,5),(5,5,11,12),(5,5,11,15),(5,5,11,16),(6,5,11,17),(6,5,11,18),(5,5,11,20),(5,5,11,21),(5,5,11,22),(0,5,11,30),(5,5,11,32),(5,5,12,11),(5,5,12,12),(5,5,12,15),(5,5,12,16),(5,5,12,17),(5,5,12,18),(13,5,12,23),(5,5,12,32),(5,5,13,11),(5,5,13,12),(5,5,13,13),(5,5,13,15),(5,5,13,16),(5,5,13,32),(5,5,14,11),(5,5,14,12),(5,5,14,13),(5,5,14,14),(0,5,14,20),(5,5,15,11),(5,5,15,12),(5,5,15,13),(4,5,15,15),(4,5,15,16),(4,5,15,17),(0,5,15,26),(5,5,16,13),(4,5,16,14),(4,5,16,15),(4,5,16,16),(4,5,16,28),(4,5,16,29),(0,5,16,30),(6,5,17,6),(6,5,17,7),(4,5,17,9),(4,5,17,10),(4,5,17,11),(4,5,17,12),(4,5,17,13),(4,5,17,14),(4,5,17,15),(4,5,17,27),(4,5,17,28),(4,5,17,29),(6,5,18,5),(6,5,18,6),(6,5,18,7),(4,5,18,11),(4,5,18,12),(4,5,18,13),(4,5,18,29),(4,5,18,30),(4,5,18,31),(4,14,0,7),(4,14,0,8),(4,14,0,9),(4,14,0,10),(5,14,0,14),(5,14,0,15),(5,14,0,16),(5,14,0,17),(5,14,0,18),(5,14,0,19),(5,14,0,20),(5,14,0,21),(4,14,1,6),(4,14,1,7),(4,14,1,8),(4,14,1,9),(4,14,1,10),(4,14,1,11),(5,14,1,13),(5,14,1,14),(5,14,1,15),(5,14,1,16),(5,14,1,17),(5,14,1,18),(5,14,1,19),(5,14,1,20),(4,14,2,6),(4,14,2,7),(4,14,2,8),(4,14,2,9),(5,14,2,15),(5,14,2,16),(5,14,2,17),(5,14,2,18),(5,14,2,19),(5,14,2,20),(3,14,2,24),(4,14,3,7),(4,14,3,8),(4,14,3,9),(4,14,3,10),(4,14,3,11),(4,14,3,12),(5,14,3,14),(5,14,3,16),(5,14,3,17),(5,14,3,18),(5,14,3,19),(5,14,3,20),(3,14,3,23),(3,14,3,24),(3,14,3,25),(3,14,3,27),(4,14,4,6),(4,14,4,7),(4,14,4,9),(4,14,4,11),(5,14,4,14),(5,14,4,15),(5,14,4,16),(5,14,4,17),(5,14,4,18),(5,14,4,20),(3,14,4,24),(3,14,4,25),(3,14,4,27),(4,14,5,7),(4,14,5,8),(4,14,5,9),(4,14,5,11),(5,14,5,13),(5,14,5,14),(5,14,5,15),(5,14,5,16),(5,14,5,17),(5,14,5,18),(3,14,5,22),(3,14,5,23),(3,14,5,24),(3,14,5,25),(3,14,5,26),(3,14,5,27),(5,14,6,13),(5,14,6,14),(5,14,6,15),(5,14,6,16),(5,14,6,17),(5,14,6,18),(3,14,6,23),(3,14,6,24),(3,14,6,25),(3,14,6,26),(3,14,6,27),(3,14,6,28),(3,14,6,29),(3,14,6,30),(5,14,7,5),(0,14,7,9),(5,14,7,14),(3,14,7,15),(3,14,7,16),(5,14,7,17),(3,14,7,22),(3,14,7,23),(3,14,7,24),(3,14,7,25),(3,14,7,26),(3,14,7,27),(3,14,7,28),(5,14,8,0),(5,14,8,2),(5,14,8,4),(5,14,8,5),(5,14,8,6),(5,14,8,14),(3,14,8,15),(3,14,8,16),(3,14,8,17),(0,14,8,18),(3,14,8,24),(3,14,8,25),(3,14,8,27),(3,14,8,28),(5,14,9,0),(5,14,9,2),(5,14,9,3),(5,14,9,4),(3,14,9,9),(3,14,9,12),(3,14,9,13),(3,14,9,14),(3,14,9,15),(3,14,9,16),(3,14,9,17),(8,14,9,25),(5,14,10,0),(5,14,10,1),(5,14,10,2),(5,14,10,3),(3,14,10,9),(3,14,10,10),(3,14,10,11),(3,14,10,12),(3,14,10,13),(3,14,10,14),(3,14,10,15),(3,14,10,16),(3,14,10,17),(5,14,11,1),(5,14,11,2),(5,14,11,3),(5,14,11,4),(3,14,11,9),(3,14,11,12),(3,14,11,13),(3,14,11,14),(6,14,11,15),(6,14,11,16),(6,14,11,17),(6,14,11,18),(5,14,12,0),(5,14,12,1),(5,14,12,3),(3,14,12,12),(3,14,12,13),(6,14,12,14),(6,14,12,15),(6,14,12,16),(6,14,12,17),(0,14,12,20),(5,14,13,0),(5,14,13,1),(5,14,13,2),(5,14,13,3),(3,14,13,10),(3,14,13,11),(3,14,13,12),(3,14,13,13),(3,14,13,14),(6,14,13,15),(6,14,13,16),(6,14,13,17),(6,14,13,18),(5,14,14,0),(1,14,14,1),(5,14,14,4),(3,14,14,13),(6,14,14,15),(6,14,14,16),(5,14,15,0),(5,14,15,3),(5,14,15,4),(6,14,15,15),(5,14,15,26),(5,14,15,27),(5,14,15,28),(5,14,16,0),(5,14,16,1),(5,14,16,2),(5,14,16,3),(5,14,16,4),(5,14,16,5),(5,14,16,6),(13,14,16,18),(5,14,16,26),(5,14,16,27),(5,14,16,28),(5,14,16,29),(5,14,16,30),(5,14,17,0),(5,14,17,1),(5,14,17,2),(5,14,17,3),(5,14,17,5),(3,14,17,9),(0,14,17,11),(5,14,17,26),(5,14,17,27),(5,14,17,28),(5,14,17,29),(5,14,18,0),(5,14,18,1),(5,14,18,3),(3,14,18,9),(3,14,18,10),(3,14,18,13),(3,14,18,14),(5,14,18,26),(5,14,18,27),(5,14,18,28),(5,14,18,29),(5,14,18,30),(5,14,19,0),(3,14,19,9),(3,14,19,10),(3,14,19,12),(3,14,19,13),(5,14,19,27),(5,14,19,28),(5,14,19,29),(5,14,19,30),(5,14,20,0),(5,14,20,1),(5,14,20,2),(3,14,20,9),(3,14,20,10),(3,14,20,11),(3,14,20,12),(3,14,20,13),(13,14,20,14),(10,14,20,26),(5,14,20,30),(3,14,21,9),(3,14,21,10),(3,14,21,11),(3,14,21,12),(3,14,21,13),(5,14,21,30),(3,14,22,9),(3,14,22,10),(3,14,22,11),(3,14,22,12),(3,14,22,13),(5,14,22,30),(3,14,23,9),(3,14,23,10),(3,14,23,11),(3,14,23,12),(3,14,23,13),(10,14,23,22),(5,14,23,30),(4,14,24,4),(4,14,24,5),(4,14,24,7),(4,14,24,8),(3,14,24,10),(3,14,24,13),(4,14,24,21),(5,14,24,26),(5,14,24,27),(5,14,24,28),(5,14,24,29),(5,14,24,30),(4,14,25,2),(4,14,25,3),(4,14,25,4),(4,14,25,5),(4,14,25,6),(4,14,25,7),(4,14,25,8),(4,14,25,9),(4,14,25,10),(3,14,25,12),(3,14,25,13),(4,14,25,21),(5,14,25,26),(5,14,25,27),(5,14,25,28),(5,14,25,29),(5,14,25,30),(4,14,26,3),(4,14,26,4),(4,14,26,5),(4,14,26,6),(3,14,26,7),(3,14,26,8),(4,14,26,9),(4,14,26,10),(4,14,26,17),(4,14,26,20),(4,14,26,21),(5,14,26,26),(5,14,26,27),(5,14,26,28),(5,14,26,29),(5,14,26,30),(4,14,27,4),(4,14,27,5),(4,14,27,6),(3,14,27,7),(3,14,27,8),(4,14,27,9),(4,14,27,10),(4,14,27,11),(4,14,27,17),(4,14,27,21),(4,14,27,22),(4,14,27,23),(4,14,27,24),(9,14,27,25),(5,14,27,28),(5,14,27,29),(5,14,27,30),(6,14,28,1),(3,14,28,4),(4,14,28,5),(4,14,28,6),(3,14,28,7),(3,14,28,8),(4,14,28,9),(3,14,28,10),(3,14,28,11),(3,14,28,12),(4,14,28,17),(4,14,28,18),(4,14,28,19),(4,14,28,20),(4,14,28,21),(4,14,28,22),(4,14,28,23),(5,14,28,28),(5,14,28,29),(5,14,28,30),(6,14,29,1),(6,14,29,2),(3,14,29,4),(3,14,29,5),(3,14,29,6),(3,14,29,7),(3,14,29,8),(3,14,29,9),(3,14,29,10),(3,14,29,11),(4,14,29,19),(4,14,29,21),(4,14,29,22),(4,14,29,23),(5,14,29,28),(5,14,29,29),(5,14,29,30),(6,14,30,0),(6,14,30,1),(6,14,30,2),(6,14,30,3),(3,14,30,4),(3,14,30,5),(3,14,30,6),(0,14,30,7),(3,14,30,9),(3,14,30,10),(3,14,30,11),(4,14,30,19),(4,14,30,20),(4,14,30,21),(4,14,30,23),(6,14,31,0),(6,14,31,1),(6,14,31,2),(6,14,31,3),(3,14,31,5),(3,14,31,6),(3,14,31,9),(3,14,31,10),(3,14,31,11),(4,14,31,18),(4,14,31,19),(4,14,31,20),(6,14,32,0),(6,14,32,1),(6,14,32,2),(3,14,32,9),(3,14,32,10),(12,14,32,19),(6,14,33,0),(3,14,33,10),(3,14,33,11),(14,14,34,0),(0,14,34,10),(6,14,36,18),(12,14,36,25),(6,14,37,16),(6,14,37,17),(6,14,37,18),(2,14,38,5),(6,14,38,16),(6,14,38,17),(6,14,38,18),(0,14,39,1),(6,14,39,17),(6,14,39,18),(6,14,40,17),(6,14,40,18),(6,14,40,19),(6,14,41,17),(6,14,41,18),(6,14,41,19),(3,27,0,0),(3,27,0,2),(3,27,1,0),(3,27,1,1),(3,27,1,2),(2,27,1,25),(5,27,1,32),(3,27,2,0),(3,27,2,1),(3,27,2,2),(5,27,2,11),(5,27,2,32),(3,27,3,0),(3,27,3,1),(3,27,3,2),(3,27,3,3),(3,27,3,4),(5,27,3,11),(5,27,3,30),(5,27,3,31),(5,27,3,32),(5,27,3,33),(5,27,3,34),(3,27,4,0),(3,27,4,1),(3,27,4,2),(3,27,4,3),(5,27,4,8),(5,27,4,9),(5,27,4,10),(5,27,4,11),(4,27,4,21),(6,27,4,27),(5,27,4,29),(5,27,4,30),(5,27,4,31),(5,27,4,32),(5,27,4,33),(5,27,4,34),(3,27,5,0),(3,27,5,1),(3,27,5,3),(3,27,5,4),(3,27,5,5),(3,27,5,6),(5,27,5,7),(5,27,5,8),(5,27,5,9),(5,27,5,10),(5,27,5,11),(5,27,5,12),(4,27,5,21),(4,27,5,22),(6,27,5,24),(6,27,5,26),(6,27,5,27),(1,27,5,28),(5,27,5,30),(5,27,5,31),(5,27,5,32),(5,27,5,33),(3,27,6,1),(3,27,6,4),(5,27,6,5),(5,27,6,6),(5,27,6,7),(5,27,6,8),(5,27,6,9),(5,27,6,10),(5,27,6,11),(5,27,6,12),(4,27,6,22),(4,27,6,23),(6,27,6,24),(6,27,6,25),(6,27,6,26),(6,27,6,27),(5,27,6,30),(5,27,6,31),(5,27,6,32),(3,27,7,3),(3,27,7,4),(5,27,7,6),(5,27,7,9),(5,27,7,10),(5,27,7,11),(4,27,7,21),(4,27,7,22),(4,27,7,23),(6,27,7,25),(6,27,7,27),(6,27,7,28),(6,27,7,29),(6,27,7,30),(5,27,7,31),(5,27,7,32),(5,27,7,34),(3,27,8,0),(3,27,8,1),(3,27,8,2),(3,27,8,3),(5,27,8,7),(5,27,8,8),(5,27,8,9),(4,27,8,21),(4,27,8,22),(4,27,8,23),(4,27,8,24),(6,27,8,25),(6,27,8,26),(6,27,8,27),(5,27,8,30),(5,27,8,31),(5,27,8,32),(5,27,8,33),(5,27,8,34),(3,27,9,0),(3,27,9,1),(3,27,9,2),(3,27,9,3),(3,27,9,4),(5,27,9,9),(4,27,9,19),(4,27,9,20),(4,27,9,21),(4,27,9,22),(4,27,9,23),(4,27,9,24),(5,27,9,34),(3,27,10,0),(3,27,10,1),(3,27,10,2),(3,27,10,3),(3,27,10,4),(5,27,10,9),(4,27,10,19),(4,27,10,20),(4,27,10,21),(4,27,10,22),(4,27,10,23),(4,27,10,24),(3,27,11,0),(3,27,11,1),(3,27,11,2),(3,27,11,3),(4,27,11,21),(4,27,11,22),(4,27,11,23),(4,27,11,24),(3,27,12,0),(3,27,12,1),(3,27,12,2),(3,27,12,3),(4,27,12,22),(4,27,12,23),(4,27,12,24),(3,27,13,0),(3,27,13,1),(0,27,13,18),(4,27,13,22),(4,27,13,23),(4,27,13,24),(4,27,13,25),(14,27,13,26),(6,27,13,31),(6,27,13,32),(6,27,13,33),(3,27,14,0),(3,27,14,1),(4,27,14,21),(4,27,14,25),(6,27,14,31),(6,27,14,32),(6,27,14,33),(6,27,14,34),(3,27,15,0),(4,27,15,20),(4,27,15,21),(4,27,15,22),(4,27,15,23),(4,27,15,24),(4,27,15,25),(6,27,15,32),(6,27,15,33),(12,27,16,0),(0,27,16,7),(4,27,16,23),(4,27,16,24),(4,27,16,25),(4,27,16,26),(4,27,16,27),(4,27,16,28),(6,27,16,31),(6,27,16,32),(6,27,16,33),(4,27,17,22),(4,27,17,23),(4,27,17,24),(0,27,17,26),(4,27,17,28),(6,27,17,31),(6,27,17,32),(6,27,17,33),(6,27,17,34),(5,27,18,7),(5,27,18,8),(5,27,18,9),(4,27,18,20),(4,27,18,21),(4,27,18,22),(4,27,18,23),(4,27,18,24),(4,27,18,28),(5,27,19,7),(5,27,19,8),(5,27,19,9),(5,27,19,10),(5,27,19,11),(5,27,19,12),(4,27,19,19),(4,27,19,20),(4,27,19,21),(4,27,19,22),(4,27,19,23),(4,27,19,24),(4,27,19,25),(4,27,19,26),(4,27,19,27),(4,27,19,28),(5,27,20,6),(5,27,20,7),(5,27,20,8),(5,27,20,9),(5,27,20,12),(0,27,20,22),(4,27,20,24),(4,27,20,26),(4,27,20,27),(4,27,20,28),(5,27,21,6),(5,27,21,7),(5,27,21,8),(5,27,21,9),(4,27,21,24),(4,27,21,25),(4,27,21,26),(4,27,21,27),(4,27,21,28),(4,27,21,29),(4,27,21,31),(4,27,21,32),(12,27,22,0),(5,27,22,6),(5,27,22,8),(5,27,22,9),(5,27,22,10),(5,27,22,11),(4,27,22,26),(4,27,22,27),(4,27,22,28),(4,27,22,29),(4,27,22,30),(4,27,22,31),(6,27,22,32),(5,27,23,7),(5,27,23,8),(5,27,23,11),(5,27,23,12),(4,27,23,26),(4,27,23,28),(4,27,23,29),(6,27,23,31),(6,27,23,32),(5,27,24,8),(5,27,24,12),(4,27,24,26),(4,27,24,28),(6,27,24,32),(4,27,25,28),(6,27,25,29),(6,27,25,30),(6,27,25,31),(6,27,25,32),(6,27,25,33),(6,27,26,20),(6,27,26,21),(6,27,26,31),(6,27,26,32),(6,27,26,33),(6,27,26,34),(0,27,27,10),(6,27,27,20),(6,27,27,22),(6,27,27,31),(6,27,27,32),(6,27,27,33),(3,27,28,4),(3,27,28,16),(5,27,28,17),(5,27,28,18),(6,27,28,19),(6,27,28,20),(6,27,28,21),(6,27,28,22),(6,27,28,23),(6,27,28,24),(6,27,28,25),(3,27,29,4),(3,27,29,5),(3,27,29,15),(3,27,29,16),(3,27,29,17),(5,27,29,18),(5,27,29,19),(5,27,29,20),(6,27,29,22),(6,27,29,23),(14,27,29,24),(3,27,30,3),(3,27,30,4),(3,27,30,5),(3,27,30,6),(3,27,30,15),(3,27,30,16),(5,27,30,18),(5,27,30,19),(5,27,30,20),(6,27,30,21),(6,27,30,22),(6,27,30,23),(3,27,31,0),(3,27,31,2),(3,27,31,3),(3,27,31,4),(3,27,31,5),(3,27,31,14),(3,27,31,15),(3,27,31,16),(3,27,31,17),(5,27,31,18),(5,27,31,19),(5,27,31,20),(5,27,31,21),(5,27,31,22),(5,27,31,23),(6,27,31,28),(6,27,31,29),(3,27,32,0),(3,27,32,1),(3,27,32,3),(3,27,32,4),(3,27,32,13),(3,27,32,14),(3,27,32,15),(3,27,32,16),(3,27,32,17),(5,27,32,18),(5,27,32,19),(5,27,32,20),(5,27,32,21),(5,27,32,22),(5,27,32,23),(6,27,32,25),(6,27,32,26),(6,27,32,27),(6,27,32,28),(6,27,32,29),(3,27,33,0),(3,27,33,1),(3,27,33,2),(3,27,33,3),(3,27,33,4),(3,27,33,13),(3,27,33,14),(3,27,33,15),(3,27,33,16),(3,27,33,17),(3,27,33,18),(5,27,33,19),(5,27,33,20),(5,27,33,21),(5,27,33,22),(6,27,33,26),(6,27,33,27),(6,27,33,28),(3,27,34,0),(3,27,34,1),(3,27,34,2),(3,27,34,3),(3,27,34,4),(3,27,34,5),(3,27,34,12),(3,27,34,13),(3,27,34,14),(3,27,34,15),(3,27,34,17),(3,27,34,18),(5,27,34,19),(5,27,34,20),(5,27,34,21),(5,27,34,22),(5,27,34,23),(6,27,34,24),(6,27,34,25),(6,27,34,26),(6,27,34,27),(6,27,34,28),(6,27,34,29),(0,38,0,0),(5,38,0,3),(5,38,0,4),(5,38,0,5),(5,38,0,6),(5,38,0,7),(5,38,0,8),(5,38,0,9),(5,38,0,10),(5,38,0,11),(5,38,0,12),(5,38,0,13),(5,38,0,14),(5,38,0,26),(5,38,0,27),(5,38,0,28),(5,38,0,29),(5,38,1,3),(11,38,1,4),(5,38,1,11),(5,38,1,12),(5,38,1,13),(13,38,1,16),(4,38,1,19),(4,38,1,20),(4,38,1,21),(4,38,1,22),(5,38,1,26),(5,38,1,27),(5,38,1,28),(5,38,1,29),(5,38,2,2),(5,38,2,3),(5,38,2,10),(5,38,2,12),(5,38,2,13),(5,38,2,14),(5,38,2,15),(4,38,2,20),(4,38,2,21),(4,38,2,22),(4,38,2,23),(5,38,2,27),(5,38,2,28),(5,38,2,29),(0,38,3,1),(5,38,3,10),(5,38,3,11),(5,38,3,12),(5,38,3,13),(5,38,3,14),(4,38,3,20),(4,38,3,21),(4,38,3,22),(4,38,3,23),(4,38,3,24),(5,38,3,28),(5,38,3,29),(5,38,4,12),(5,38,4,13),(6,38,4,18),(4,38,4,21),(4,38,4,22),(4,38,4,23),(5,38,4,26),(5,38,4,27),(5,38,4,28),(6,38,5,8),(6,38,5,9),(6,38,5,18),(6,38,5,19),(4,38,5,22),(4,38,5,23),(4,38,5,24),(5,38,5,26),(5,38,5,27),(6,38,6,7),(6,38,6,8),(6,38,6,9),(6,38,6,11),(6,38,6,18),(6,38,6,19),(6,38,7,9),(6,38,7,10),(6,38,7,18),(12,38,7,23),(6,38,8,9),(6,38,8,10),(6,38,8,16),(6,38,8,17),(6,38,8,18),(3,38,9,3),(3,38,9,4),(6,38,9,9),(6,38,9,15),(6,38,9,16),(6,38,9,17),(3,38,10,0),(3,38,10,2),(3,38,10,3),(3,38,10,4),(8,38,10,5),(6,38,10,16),(6,38,10,17),(0,38,10,20),(3,38,11,0),(3,38,11,1),(3,38,11,2),(3,38,11,3),(3,38,12,0),(3,38,12,1),(3,38,12,2),(3,38,13,0),(3,38,13,1),(3,38,13,2),(3,38,13,4),(3,38,14,0),(3,38,14,1),(3,38,14,2),(3,38,14,3),(3,38,14,4),(3,38,15,0),(3,38,15,1),(3,38,15,2),(3,38,15,3),(3,38,15,4),(3,38,16,0),(3,38,16,1),(3,38,16,2),(3,38,16,3),(5,38,16,29),(3,38,17,0),(3,38,17,1),(3,38,17,2),(3,38,17,3),(3,38,17,4),(5,38,17,28),(5,38,17,29),(3,38,18,0),(3,38,18,1),(3,38,18,2),(3,38,18,3),(3,38,18,4),(3,38,18,5),(0,38,18,23),(5,38,18,28),(5,38,18,29),(3,38,19,0),(3,38,19,1),(3,38,19,2),(3,38,19,3),(3,38,19,4),(3,38,19,5),(5,38,19,29),(3,38,20,0),(3,38,20,1),(3,38,20,2),(3,38,20,3),(3,38,20,4),(3,38,20,5),(5,38,20,28),(5,38,20,29),(3,38,21,0),(3,38,21,1),(3,38,21,2),(3,38,21,3),(3,38,21,4),(5,38,21,29),(3,38,22,0),(3,38,22,1),(3,38,22,2),(14,38,22,25),(5,38,22,29),(3,38,23,0),(3,38,23,1),(3,38,23,2),(3,38,23,3),(4,38,23,9),(5,38,23,29),(3,38,24,1),(3,38,24,2),(0,38,24,4),(4,38,24,7),(4,38,24,8),(4,38,24,9),(4,38,24,10),(4,38,24,11),(5,38,24,29),(4,38,25,7),(4,38,25,8),(4,38,25,9),(4,38,25,10),(5,38,25,27),(5,38,25,29),(4,38,26,6),(4,38,26,7),(4,38,26,8),(4,38,26,9),(4,38,26,10),(2,38,26,12),(6,38,26,22),(6,38,26,23),(5,38,26,27),(5,38,26,28),(5,38,26,29),(4,38,27,5),(4,38,27,6),(4,38,27,7),(4,38,27,8),(4,38,27,9),(4,38,27,10),(5,38,27,17),(5,38,27,18),(5,38,27,21),(5,38,27,22),(6,38,27,23),(6,38,27,24),(0,38,28,4),(4,38,28,6),(4,38,28,7),(4,38,28,8),(4,38,28,9),(4,38,28,10),(5,38,28,15),(5,38,28,16),(5,38,28,17),(5,38,28,18),(5,38,28,19),(5,38,28,21),(5,38,28,22),(6,38,28,23),(6,38,28,24),(5,38,28,25),(5,38,28,26),(5,38,28,27),(5,38,28,28),(4,38,29,7),(4,38,29,8),(4,38,29,9),(4,38,29,10),(4,38,29,11),(5,38,29,16),(5,38,29,17),(5,38,29,18),(5,38,29,19),(5,38,29,20),(5,38,29,21),(5,38,29,22),(6,38,29,23),(6,38,29,24),(6,38,29,25),(6,38,29,26),(5,38,29,27),(4,41,0,0),(4,41,0,1),(4,41,0,2),(4,41,0,3),(4,41,0,4),(4,41,0,5),(5,41,0,11),(5,41,0,12),(5,41,0,13),(3,41,0,30),(3,41,0,31),(3,41,0,32),(3,41,0,33),(4,41,1,0),(4,41,1,1),(4,41,1,2),(4,41,1,3),(4,41,1,4),(4,41,1,5),(4,41,1,8),(5,41,1,11),(5,41,1,12),(5,41,1,13),(5,41,1,14),(3,41,1,30),(3,41,1,32),(3,41,1,33),(3,41,1,34),(4,41,2,0),(4,41,2,1),(0,41,2,2),(4,41,2,4),(4,41,2,5),(4,41,2,6),(4,41,2,7),(4,41,2,8),(5,41,2,10),(5,41,2,11),(5,41,2,12),(5,41,2,13),(5,41,2,14),(3,41,2,29),(3,41,2,30),(3,41,2,31),(3,41,2,32),(3,41,2,33),(4,41,3,4),(4,41,3,5),(4,41,3,6),(4,41,3,7),(5,41,3,8),(5,41,3,9),(5,41,3,10),(5,41,3,11),(5,41,3,12),(5,41,3,13),(5,41,3,14),(3,41,3,29),(3,41,3,30),(3,41,3,31),(3,41,3,32),(3,41,3,33),(3,41,3,34),(4,41,4,4),(4,41,4,5),(4,41,4,6),(4,41,4,7),(4,41,4,8),(5,41,4,9),(5,41,4,10),(5,41,4,11),(5,41,4,12),(5,41,4,13),(6,41,4,27),(6,41,4,28),(3,41,4,29),(3,41,4,30),(3,41,4,31),(3,41,4,32),(3,41,4,33),(3,41,4,34),(3,41,4,35),(3,41,4,36),(3,41,4,37),(4,41,5,4),(4,41,5,6),(4,41,5,7),(5,41,5,9),(5,41,5,10),(6,41,5,26),(6,41,5,28),(6,41,5,29),(6,41,5,30),(3,41,5,32),(3,41,5,33),(3,41,5,34),(3,41,5,35),(3,41,5,37),(4,41,6,3),(4,41,6,4),(4,41,6,5),(4,41,6,6),(4,41,6,7),(4,41,6,8),(6,41,6,26),(6,41,6,27),(6,41,6,28),(6,41,6,29),(6,41,6,30),(3,41,6,33),(3,41,6,34),(5,41,7,0),(4,41,7,3),(4,41,7,4),(4,41,7,5),(4,41,7,7),(5,41,7,11),(12,41,7,20),(6,41,7,27),(6,41,7,28),(6,41,7,29),(6,41,7,30),(6,41,7,31),(3,41,7,34),(5,41,8,0),(2,41,8,3),(4,41,8,5),(4,41,8,6),(4,41,8,7),(4,41,8,8),(5,41,8,11),(5,41,8,12),(6,41,8,27),(6,41,8,28),(6,41,8,29),(6,41,8,30),(5,41,9,0),(5,41,9,1),(5,41,9,2),(5,41,9,5),(5,41,9,6),(4,41,9,7),(4,41,9,8),(5,41,9,9),(5,41,9,10),(5,41,9,11),(5,41,9,12),(0,41,9,16),(6,41,9,27),(6,41,9,28),(6,41,9,30),(6,41,9,31),(5,41,10,0),(5,41,10,1),(5,41,10,2),(5,41,10,3),(5,41,10,4),(5,41,10,5),(5,41,10,6),(4,41,10,7),(4,41,10,8),(4,41,10,9),(5,41,10,10),(5,41,10,11),(6,41,10,28),(6,41,10,31),(5,41,11,0),(5,41,11,1),(5,41,11,2),(5,41,11,3),(5,41,11,4),(5,41,11,5),(5,41,11,6),(5,41,11,7),(4,41,11,8),(5,41,11,9),(5,41,11,10),(5,41,11,11),(5,41,11,12),(5,41,11,13),(3,41,11,14),(3,41,11,18),(6,41,11,28),(6,41,11,29),(5,41,12,0),(5,41,12,1),(5,41,12,2),(5,41,12,3),(5,41,12,4),(5,41,12,5),(5,41,12,6),(5,41,12,9),(5,41,12,10),(5,41,12,11),(5,41,12,12),(5,41,12,13),(3,41,12,14),(3,41,12,15),(3,41,12,16),(3,41,12,17),(3,41,12,18),(3,41,12,19),(6,41,12,27),(6,41,12,28),(5,41,13,2),(5,41,13,3),(5,41,13,4),(5,41,13,5),(2,41,13,6),(5,41,13,8),(5,41,13,9),(5,41,13,10),(5,41,13,12),(3,41,13,15),(3,41,13,16),(3,41,13,17),(3,41,13,18),(3,41,13,19),(6,41,13,24),(6,41,13,25),(6,41,13,26),(6,41,13,27),(6,41,13,28),(5,41,14,1),(5,41,14,2),(5,41,14,3),(5,41,14,4),(5,41,14,5),(5,41,14,12),(3,41,14,13),(3,41,14,14),(3,41,14,16),(3,41,14,17),(3,41,14,19),(3,41,14,20),(6,41,14,24),(6,41,14,25),(6,41,14,26),(6,41,14,27),(6,41,14,28),(6,41,14,29),(0,41,14,30),(5,41,15,4),(5,41,15,12),(3,41,15,14),(3,41,15,15),(3,41,15,16),(3,41,15,18),(3,41,15,19),(6,41,15,24),(6,41,15,25),(6,41,15,26),(6,41,15,27),(5,41,16,2),(5,41,16,3),(5,41,16,4),(5,41,16,12),(3,41,16,14),(3,41,16,15),(3,41,16,16),(3,41,16,17),(3,41,16,19),(6,41,16,25),(6,41,16,26),(6,41,16,27),(5,41,17,0),(5,41,17,1),(5,41,17,2),(5,41,17,3),(5,41,17,4),(5,41,17,5),(4,41,17,13),(3,41,17,14),(3,41,17,15),(3,41,17,17),(11,41,17,26),(3,41,17,41),(3,41,17,42),(5,41,18,2),(5,41,18,4),(4,41,18,13),(3,41,18,15),(3,41,18,17),(3,41,18,40),(3,41,18,41),(3,41,18,42),(3,41,18,43),(5,41,19,3),(5,41,19,4),(4,41,19,12),(4,41,19,13),(3,41,19,15),(3,41,19,17),(3,41,19,40),(3,41,19,41),(3,41,19,42),(3,41,19,43),(10,41,20,0),(5,41,20,4),(4,41,20,11),(4,41,20,12),(3,41,20,19),(3,41,20,20),(3,41,20,21),(4,41,20,33),(1,41,20,39),(3,41,20,41),(5,41,21,4),(5,41,21,5),(5,41,21,7),(4,41,21,10),(4,41,21,11),(4,41,21,12),(4,41,21,13),(3,41,21,20),(3,41,21,21),(3,41,21,22),(3,41,21,23),(4,41,21,32),(4,41,21,33),(4,41,21,34),(4,41,21,37),(3,41,21,41),(3,41,21,42),(3,41,21,43),(5,41,22,5),(5,41,22,6),(5,41,22,7),(5,41,22,8),(5,41,22,9),(4,41,22,10),(4,41,22,13),(4,41,22,14),(4,41,22,15),(14,41,22,16),(3,41,22,20),(10,41,22,21),(4,41,22,33),(4,41,22,34),(4,41,22,35),(4,41,22,36),(4,41,22,37),(4,41,22,38),(4,41,22,39),(4,41,22,40),(3,41,22,41),(3,41,22,42),(3,41,22,43),(5,41,23,7),(5,41,23,8),(5,41,23,9),(4,41,23,14),(4,41,23,15),(3,41,23,20),(4,41,23,33),(4,41,23,34),(4,41,23,35),(4,41,23,36),(4,41,23,37),(4,41,23,38),(3,41,23,39),(3,41,23,40),(3,41,23,41),(3,41,23,42),(3,41,23,43),(0,41,24,6),(5,41,24,8),(5,41,24,9),(5,41,24,10),(4,41,24,13),(4,41,24,14),(4,41,24,15),(3,41,24,20),(4,41,24,33),(4,41,24,34),(4,41,24,36),(4,41,24,37),(3,41,24,38),(3,41,24,39),(3,41,24,40),(3,41,24,41),(3,41,24,42),(3,41,24,43),(5,41,25,8),(5,41,25,9),(4,41,25,15),(4,41,25,16),(4,41,25,17),(6,41,25,18),(6,41,25,19),(3,41,25,20),(4,41,25,33),(4,41,25,34),(4,41,25,37),(3,41,25,38),(3,41,25,39),(3,41,25,40),(3,41,25,41),(3,41,25,42),(3,41,26,4),(3,41,26,6),(3,41,26,7),(5,41,26,8),(5,41,26,9),(0,41,26,10),(4,41,26,15),(4,41,26,16),(4,41,26,17),(6,41,26,18),(6,41,26,19),(3,41,26,20),(3,41,26,21),(3,41,26,22),(3,41,26,23),(3,41,26,24),(14,41,26,25),(3,41,26,38),(3,41,26,39),(3,41,26,41),(3,41,27,4),(3,41,27,5),(3,41,27,6),(3,41,27,7),(3,41,27,8),(5,41,27,9),(4,41,27,15),(6,41,27,16),(6,41,27,17),(6,41,27,18),(6,41,27,19),(6,41,27,20),(3,41,27,21),(3,41,27,22),(3,41,27,23),(3,41,27,24),(3,41,28,0),(3,41,28,1),(3,41,28,2),(3,41,28,3),(3,41,28,4),(3,41,28,5),(3,41,28,6),(3,41,28,7),(3,41,28,8),(5,41,28,9),(6,41,28,15),(6,41,28,16),(6,41,28,17),(6,41,28,18),(6,41,28,19),(6,41,28,20),(6,41,28,21),(6,41,28,22),(6,41,28,23),(3,41,28,24),(3,41,29,0),(3,41,29,1),(3,41,29,2),(3,41,29,3),(3,41,29,4),(3,41,29,5),(3,41,29,6),(3,41,29,7),(5,41,29,8),(5,41,29,9),(5,41,29,10),(6,41,29,15),(6,41,29,16),(8,41,29,17),(6,41,29,20),(6,41,29,21),(6,41,29,22),(3,41,29,23),(3,41,29,24),(3,41,30,0),(0,41,30,1),(3,41,30,3),(3,41,30,4),(0,41,30,5),(3,41,30,7),(5,41,30,8),(5,41,30,9),(6,41,30,20),(3,41,30,21),(3,41,30,22),(3,41,30,23),(3,41,30,24),(3,41,30,25),(3,41,30,26),(3,41,31,3),(3,41,31,4),(3,41,31,7),(3,41,31,8),(3,41,31,21),(3,41,31,22),(3,41,31,23),(3,41,31,24),(3,41,32,4),(3,41,32,5),(3,41,32,7),(3,41,32,24),(3,41,32,25),(3,41,32,26),(5,42,0,20),(5,42,0,21),(5,42,0,22),(5,42,0,23),(14,42,0,32),(11,42,0,40),(5,42,1,17),(5,42,1,18),(5,42,1,20),(5,42,1,21),(5,42,1,22),(0,42,1,23),(5,42,2,1),(5,42,2,3),(0,42,2,15),(5,42,2,18),(5,42,2,19),(5,42,2,20),(5,42,2,21),(5,42,2,22),(3,42,2,39),(5,42,3,0),(5,42,3,1),(5,42,3,2),(5,42,3,3),(5,42,3,4),(0,42,3,19),(5,42,3,21),(5,42,3,25),(1,42,3,29),(3,42,3,39),(5,42,4,0),(0,42,4,1),(5,42,4,3),(5,42,4,4),(5,42,4,5),(0,42,4,7),(3,42,4,14),(3,42,4,15),(3,42,4,17),(5,42,4,21),(5,42,4,25),(5,42,4,26),(3,42,4,36),(3,42,4,37),(3,42,4,38),(3,42,4,39),(3,42,4,40),(3,42,4,41),(3,42,4,42),(3,42,4,43),(3,42,4,44),(5,42,5,3),(5,42,5,4),(5,42,5,5),(3,42,5,13),(3,42,5,14),(3,42,5,15),(3,42,5,16),(3,42,5,17),(5,42,5,19),(5,42,5,20),(5,42,5,21),(5,42,5,26),(5,42,5,27),(0,42,5,36),(4,42,5,38),(4,42,5,39),(4,42,5,41),(3,42,5,42),(5,42,6,5),(3,42,6,15),(5,42,6,18),(5,42,6,19),(5,42,6,20),(5,42,6,21),(1,42,6,23),(5,42,6,26),(5,42,6,27),(5,42,6,28),(4,42,6,38),(4,42,6,39),(4,42,6,40),(4,42,6,41),(4,42,6,42),(4,42,6,43),(11,42,7,0),(6,42,7,6),(6,42,7,7),(0,42,7,13),(3,42,7,15),(5,42,7,18),(5,42,7,19),(5,42,7,20),(5,42,7,21),(5,42,7,22),(5,42,7,27),(5,42,7,28),(5,42,7,29),(4,42,7,38),(4,42,7,39),(4,42,7,40),(6,42,8,6),(6,42,8,7),(0,42,8,8),(3,42,8,15),(3,42,8,16),(5,42,8,20),(6,42,8,21),(5,42,8,22),(6,42,8,23),(5,42,8,28),(5,42,8,29),(5,42,8,30),(4,42,8,33),(4,42,8,34),(6,42,8,38),(6,42,8,39),(6,42,8,40),(6,42,8,41),(4,42,8,42),(6,42,9,6),(6,42,9,7),(2,42,9,17),(6,42,9,20),(6,42,9,21),(6,42,9,22),(6,42,9,23),(5,42,9,28),(4,42,9,32),(4,42,9,33),(4,42,9,34),(4,42,9,35),(6,42,9,39),(6,42,9,40),(4,42,9,41),(4,42,9,42),(6,42,10,6),(3,42,10,7),(6,42,10,23),(4,42,10,33),(4,42,10,34),(4,42,10,35),(4,42,10,36),(6,42,10,39),(4,42,10,40),(4,42,10,41),(3,42,11,0),(3,42,11,1),(3,42,11,2),(3,42,11,3),(3,42,11,4),(3,42,11,5),(3,42,11,6),(3,42,11,7),(3,42,11,8),(3,42,11,9),(3,42,11,10),(4,42,11,33),(4,42,11,34),(4,42,11,35),(4,42,11,36),(4,42,11,37),(4,42,11,38),(4,42,11,39),(4,42,11,40),(4,42,11,41),(5,49,0,5),(5,49,0,6),(5,49,0,7),(5,49,0,8),(5,49,0,9),(5,49,0,10),(5,49,0,11),(5,49,0,12),(5,49,0,14),(5,49,0,16),(5,49,0,17),(5,49,0,18),(5,49,0,19),(5,49,0,20),(5,49,0,21),(5,49,1,6),(5,49,1,7),(5,49,1,8),(5,49,1,9),(5,49,1,11),(5,49,1,12),(5,49,1,13),(5,49,1,14),(5,49,1,15),(5,49,1,16),(5,49,1,17),(5,49,1,18),(5,49,1,19),(5,49,1,20),(5,49,1,21),(5,49,2,5),(5,49,2,6),(5,49,2,7),(5,49,2,8),(5,49,2,9),(5,49,2,10),(5,49,2,11),(5,49,2,13),(5,49,2,14),(0,49,2,15),(5,49,2,17),(5,49,2,18),(5,49,2,19),(5,49,2,20),(5,49,2,21),(5,49,3,6),(5,49,3,8),(5,49,3,9),(5,49,3,14),(5,49,3,17),(5,49,3,18),(0,49,3,19),(5,49,3,21),(5,49,4,6),(5,49,4,7),(5,49,4,8),(0,49,4,9),(5,49,4,13),(5,49,4,14),(5,49,4,15),(5,49,4,16),(5,49,4,17),(5,49,4,18),(5,49,5,7),(6,49,5,14),(6,49,5,15),(5,49,5,16),(6,49,5,17),(5,49,5,18),(6,49,6,14),(6,49,6,15),(6,49,6,16),(6,49,6,17),(5,49,6,18),(3,49,6,19),(3,49,6,21),(2,49,7,14),(6,49,7,16),(6,49,7,17),(6,49,7,18),(3,49,7,19),(3,49,7,20),(3,49,7,21),(1,49,8,5),(4,49,8,10),(4,49,8,11),(4,49,8,12),(6,49,8,16),(6,49,8,17),(6,49,8,18),(3,49,8,19),(3,49,8,20),(3,49,8,21),(0,49,8,22),(3,49,8,24),(4,49,9,11),(4,49,9,12),(3,49,9,17),(6,49,9,18),(3,49,9,19),(3,49,9,21),(3,49,9,24),(4,49,10,6),(4,49,10,7),(4,49,10,9),(4,49,10,10),(4,49,10,11),(3,49,10,17),(3,49,10,18),(3,49,10,19),(3,49,10,20),(3,49,10,21),(3,49,10,22),(3,49,10,23),(3,49,10,24),(4,49,11,7),(4,49,11,8),(4,49,11,10),(4,49,11,11),(0,49,11,17),(3,49,11,19),(3,49,11,21),(3,49,11,22),(3,49,11,23),(3,49,11,24),(3,49,11,25),(4,49,12,7),(4,49,12,8),(4,49,12,9),(6,49,12,10),(6,49,12,11),(3,49,12,22),(3,49,12,23),(3,49,12,24),(3,49,12,25),(4,49,13,6),(4,49,13,7),(4,49,13,8),(6,49,13,9),(6,49,13,10),(6,49,13,11),(6,49,13,12),(6,49,13,13),(6,49,13,14),(6,49,13,15),(6,49,13,16),(3,49,13,22),(3,49,13,23),(3,49,13,25),(12,49,14,6),(6,49,14,12),(6,49,14,13),(6,49,14,14),(13,49,14,19),(3,49,14,22),(3,49,14,25),(6,49,15,13),(3,49,15,15),(3,49,15,24),(3,49,15,25),(0,49,16,2),(3,49,16,13),(3,49,16,15),(3,49,16,16),(3,49,16,17),(13,49,16,23),(3,49,17,12),(3,49,17,13),(3,49,17,14),(3,49,17,15),(3,49,17,16),(4,49,17,17),(4,49,17,22),(3,49,18,12),(3,49,18,13),(3,49,18,14),(3,49,18,15),(3,49,18,16),(4,49,18,17),(4,49,18,18),(4,49,18,21),(4,49,18,22),(3,49,19,13),(3,49,19,14),(4,49,19,18),(4,49,19,21),(4,49,19,22),(10,49,20,8),(3,49,20,14),(3,49,20,15),(4,49,20,16),(4,49,20,17),(4,49,20,18),(4,49,20,19),(4,49,20,21),(4,49,20,22),(4,49,21,16),(4,49,21,18),(4,49,21,21),(4,49,21,22),(4,49,22,22),(5,49,23,12),(14,49,23,16),(0,49,23,21),(4,49,24,6),(5,49,24,9),(5,49,24,10),(5,49,24,11),(5,49,24,12),(3,49,24,13),(3,49,24,14),(3,49,24,15),(6,49,24,24),(4,49,25,5),(4,49,25,6),(4,49,25,7),(5,49,25,11),(5,49,25,12),(5,49,25,13),(5,49,25,14),(3,49,25,15),(6,49,25,23),(6,49,25,24),(6,49,25,25),(4,49,26,6),(4,49,26,7),(5,49,26,10),(5,49,26,11),(5,49,26,12),(3,49,26,13),(3,49,26,14),(3,49,26,15),(3,49,26,16),(3,49,26,17),(9,49,26,18),(6,49,26,24),(6,49,26,25),(10,49,27,2),(4,49,27,7),(4,49,27,8),(4,49,27,9),(5,49,27,10),(5,49,27,11),(5,49,27,12),(5,49,27,13),(3,49,27,14),(3,49,27,15),(3,49,27,16),(3,49,27,17),(6,49,27,24),(6,49,27,25),(4,49,28,7),(5,49,28,8),(5,49,28,9),(5,49,28,10),(5,49,28,11),(5,49,28,12),(0,49,28,13),(3,49,28,16),(3,49,28,17),(6,49,28,23),(6,49,28,24),(5,49,28,25),(5,49,29,7),(5,49,29,8),(5,49,29,9),(5,49,29,10),(5,49,29,11),(5,49,29,12),(3,49,29,15),(3,49,29,16),(3,49,29,17),(6,49,29,23),(6,49,29,24),(5,49,29,25),(5,49,30,8),(5,49,30,9),(5,49,30,10),(5,49,30,11),(5,49,30,12),(3,49,30,16),(6,49,30,23),(6,49,30,24),(5,49,30,25),(5,55,0,8),(5,55,1,8),(5,55,1,14),(5,55,2,7),(5,55,2,8),(5,55,2,9),(5,55,2,10),(5,55,2,11),(5,55,2,12),(5,55,2,13),(5,55,2,14),(6,55,2,19),(6,55,2,20),(5,55,3,6),(5,55,3,7),(5,55,3,8),(5,55,3,9),(5,55,3,10),(5,55,3,11),(5,55,3,12),(5,55,3,13),(5,55,3,14),(6,55,3,20),(5,55,4,5),(5,55,4,6),(5,55,4,7),(5,55,4,8),(5,55,4,9),(5,55,4,10),(5,55,4,11),(5,55,4,12),(5,55,4,13),(6,55,4,19),(6,55,4,20),(5,55,5,7),(5,55,5,9),(5,55,5,10),(5,55,5,11),(5,55,5,12),(5,55,5,13),(6,55,5,17),(6,55,5,18),(6,55,5,19),(6,55,5,20),(5,55,6,10),(5,55,6,11),(5,55,6,12),(6,55,6,17),(6,55,6,18),(6,55,6,19),(6,55,6,20),(3,55,7,4),(3,55,7,6),(3,55,7,8),(5,55,7,11),(5,55,7,12),(5,55,7,13),(6,55,7,17),(3,55,8,4),(3,55,8,5),(3,55,8,6),(3,55,8,8),(6,55,8,12),(3,55,9,4),(3,55,9,5),(3,55,9,6),(3,55,9,7),(3,55,9,8),(6,55,9,12),(3,55,10,4),(3,55,10,5),(3,55,10,6),(3,55,10,7),(3,55,10,8),(6,55,10,12),(6,55,10,13),(6,55,10,14),(3,55,11,4),(3,55,11,5),(3,55,11,7),(3,55,11,8),(6,55,11,12),(6,55,11,13),(6,55,11,14),(6,55,11,15),(3,55,12,6),(3,55,12,7),(3,55,12,8),(6,55,12,11),(6,55,12,12),(3,55,13,7),(3,55,13,9),(6,55,13,11),(6,55,13,12),(6,55,13,13),(4,55,14,2),(3,55,14,7),(3,55,14,8),(3,55,14,9),(0,55,14,18),(4,55,15,0),(4,55,15,1),(4,55,15,2),(4,55,15,3),(4,55,15,4),(13,55,15,5),(3,55,15,7),(3,55,15,9),(4,55,16,0),(4,55,16,1),(4,55,16,2),(4,55,16,3),(4,55,16,4),(3,55,16,7),(3,55,16,8),(3,55,16,9),(3,55,16,10),(4,55,17,0),(4,55,17,1),(4,55,17,2),(4,55,17,3),(4,55,17,4),(3,55,17,7),(3,55,17,8),(3,55,17,9),(3,55,18,0),(4,55,18,1),(4,55,18,3),(4,55,18,4),(3,55,18,7),(3,55,18,8),(3,55,18,9),(3,55,18,10),(0,55,18,14),(3,55,19,0),(3,55,19,1),(4,55,19,3),(4,55,19,4),(3,55,19,7),(3,55,19,10),(0,55,19,18),(3,55,20,0),(3,55,20,1),(3,55,20,2),(4,55,20,3),(3,55,21,0),(3,55,21,1),(3,55,21,2),(3,55,21,3),(5,55,21,18),(5,55,21,19),(5,55,21,20),(3,55,22,0),(3,55,22,1),(3,55,22,2),(3,55,22,3),(14,55,22,6),(5,55,22,18),(5,55,22,20),(3,55,23,0),(3,55,23,1),(4,55,23,2),(3,55,23,3),(3,55,23,4),(3,55,23,5),(5,55,23,17),(5,55,23,18),(5,55,23,19),(5,55,23,20),(3,55,24,0),(3,55,24,1),(4,55,24,2),(4,55,24,3),(3,55,24,4),(5,55,24,16),(5,55,24,17),(5,55,24,18),(5,55,24,19),(5,55,24,20),(4,55,25,0),(4,55,25,1),(4,55,25,2),(4,55,25,3),(5,55,25,16),(5,55,25,18),(5,55,25,19),(5,55,25,20),(4,55,26,0),(4,55,26,1),(5,55,26,15),(5,55,26,16),(5,55,26,17),(5,55,26,18),(5,55,26,19),(5,55,26,20),(4,55,27,0),(4,55,27,1),(4,55,27,2),(6,55,27,11),(5,55,27,15),(5,55,27,17),(5,55,27,18),(5,55,27,19),(5,55,27,20),(4,55,28,0),(4,55,28,1),(4,55,28,2),(4,55,28,3),(6,55,28,11),(6,55,28,12),(6,55,28,13),(6,55,28,14),(5,55,28,15),(5,55,28,16),(5,55,28,17),(5,55,28,18),(4,55,29,0),(4,55,29,1),(4,55,29,2),(4,55,29,3),(6,55,29,4),(6,55,29,5),(2,55,29,6),(6,55,29,10),(6,55,29,11),(6,55,29,12),(6,55,29,13),(2,55,29,14),(5,55,29,16),(5,55,29,17),(5,55,29,18),(5,55,29,19),(4,55,30,0),(4,55,30,1),(6,55,30,4),(6,55,30,5),(6,55,30,8),(6,55,30,9),(6,55,30,10),(6,55,30,12),(6,55,30,13),(5,55,30,16),(5,55,30,17),(5,55,30,18),(6,55,31,2),(6,55,31,4),(6,55,31,5),(6,55,31,6),(4,55,31,10),(5,55,31,18),(6,55,32,2),(6,55,32,3),(6,55,32,4),(6,55,32,5),(4,55,32,9),(4,55,32,10),(3,55,32,11),(0,55,33,2),(6,55,33,4),(4,55,33,7),(4,55,33,8),(4,55,33,9),(4,55,33,10),(3,55,33,11),(6,55,34,4),(4,55,34,8),(4,55,34,9),(4,55,34,10),(3,55,34,11),(3,55,34,12),(4,55,35,5),(4,55,35,6),(4,55,35,7),(4,55,35,8),(4,55,35,9),(4,55,35,10),(4,55,35,11),(3,55,35,12),(3,55,35,13),(3,55,35,14),(3,55,35,15),(3,55,35,16),(4,55,36,5),(4,55,36,9),(4,55,36,10),(4,55,36,11),(3,55,36,12),(3,55,36,13),(3,55,36,14),(3,55,36,15),(3,55,36,16),(3,55,36,17),(4,55,37,2),(4,55,37,3),(4,55,37,4),(4,55,37,10),(3,55,37,11),(3,55,37,12),(3,55,37,13),(3,55,37,14),(3,55,37,15),(3,55,37,16),(3,55,37,17),(4,55,38,0),(4,55,38,1),(4,55,38,2),(4,55,38,3),(4,55,38,4),(4,55,38,5),(12,55,38,11),(4,55,39,0),(4,55,39,2),(4,55,39,3),(4,55,39,4),(4,55,39,5),(4,55,40,0),(4,55,40,1),(4,55,40,2),(4,55,40,3),(4,55,40,4),(4,55,41,0),(4,55,41,1),(5,55,41,2),(1,55,41,3),(5,55,41,5),(5,55,41,8),(4,55,42,0),(5,55,42,1),(5,55,42,2),(5,55,42,5),(5,55,42,6),(5,55,42,7),(5,55,42,8),(5,55,43,0),(5,55,43,1),(5,55,43,2),(5,55,43,3),(5,55,43,4),(5,55,43,5),(5,55,43,6),(5,55,43,7),(5,55,44,0),(5,55,44,1),(5,55,44,4),(5,55,44,5),(5,55,44,6),(6,55,44,11),(6,55,44,12),(6,55,44,13),(6,55,44,14),(5,55,45,0),(5,55,45,1),(5,55,45,4),(6,55,45,13),(6,55,45,14),(5,55,46,0),(5,55,46,1),(5,55,46,2),(0,55,46,10),(6,55,46,12),(6,55,46,13),(6,55,46,14),(5,55,47,0),(5,55,47,1),(5,55,47,2),(6,55,47,12),(6,55,47,13),(6,55,47,14),(6,55,47,15),(5,55,48,1),(5,55,48,2),(4,55,48,8),(4,55,48,9),(4,55,48,10),(4,55,48,11),(4,55,48,12),(4,55,48,13),(6,55,48,14),(3,55,48,15),(3,55,48,17),(3,55,48,18),(3,55,48,19),(5,55,49,0),(5,55,49,1),(5,55,49,2),(5,55,49,3),(4,55,49,7),(4,55,49,8),(4,55,49,9),(4,55,49,10),(4,55,49,11),(4,55,49,12),(3,55,49,15),(3,55,49,16),(3,55,49,17),(3,55,49,18),(5,55,50,1),(5,55,50,2),(4,55,50,7),(0,55,50,8),(4,55,50,10),(4,55,50,11),(4,55,50,12),(4,55,50,13),(4,55,50,14),(0,55,50,15),(3,55,50,17),(3,55,50,18),(3,55,50,19),(3,55,50,20),(5,55,51,1),(5,55,51,2),(4,55,51,11),(4,55,51,13),(4,55,51,14),(3,55,51,17),(3,55,51,18),(3,55,51,19),(3,55,51,20),(4,55,52,14),(3,55,52,15),(3,55,52,16),(3,55,52,17),(3,55,52,18),(3,55,52,19),(3,55,52,20);
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
) ENGINE=InnoDB AUTO_INCREMENT=440 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `units`
--

LOCK TABLES `units` WRITE;
/*!40000 ALTER TABLE `units` DISABLE KEYS */;
INSERT INTO `units` VALUES (1,4475,1,1,1,NULL,NULL,NULL,NULL,0,0,'Thor',1,1,45,NULL,1,0,0,0,0,0,0),(2,2812,1,1,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,1,45,NULL,1,0,0,0,0,0,0),(3,2812,1,1,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,1,45,NULL,1,0,0,0,0,0,0),(4,2812,1,1,1,NULL,NULL,NULL,NULL,0,0,'Dirac',0,1,45,NULL,1,0,0,0,0,0,0),(5,90,1,1,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(6,125,1,1,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(7,125,1,1,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(8,125,1,2,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(9,125,1,2,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(10,90,1,3,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(11,125,1,3,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(12,125,1,3,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(13,90,1,4,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(14,125,1,4,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(15,125,1,4,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(16,90,1,5,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(17,125,1,5,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(18,90,1,5,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(19,125,1,5,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(20,125,1,5,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(21,90,1,6,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(22,125,1,6,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(23,90,1,6,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(24,125,1,6,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(25,125,1,6,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(26,90,1,7,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(27,125,1,7,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(28,90,1,7,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(29,125,1,7,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(30,90,1,7,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(31,125,1,7,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(32,125,1,7,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(33,125,1,8,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(34,125,1,8,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(35,125,1,9,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(36,125,1,9,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(37,125,1,10,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(38,125,1,10,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(39,125,1,11,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(40,125,1,11,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(41,26875,1,1,1,NULL,NULL,NULL,NULL,0,0,'Demosis',0,2,180,NULL,1,0,0,0,0,0,0),(42,26875,1,1,1,NULL,NULL,NULL,NULL,0,0,'Demosis',0,2,180,NULL,1,0,0,0,0,0,0),(43,4475,1,1,1,NULL,NULL,NULL,NULL,0,0,'Thor',0,2,180,NULL,1,0,0,0,0,0,0),(44,2812,1,1,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,2,180,NULL,1,0,0,0,0,0,0),(45,2812,1,1,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,2,180,NULL,1,0,0,0,0,0,0),(46,2812,1,1,1,NULL,NULL,NULL,NULL,0,0,'Dirac',0,2,180,NULL,1,0,0,0,0,0,0),(47,90,1,12,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(48,125,1,12,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(49,125,1,12,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(50,90,1,13,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(51,125,1,13,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(52,125,1,13,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(53,125,1,14,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(54,125,1,14,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(55,90,1,15,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(56,90,1,15,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(57,125,1,15,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(58,125,1,15,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(59,90,1,16,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(60,125,1,16,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(61,125,1,16,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(62,90,1,16,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(63,125,1,16,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(64,125,1,16,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(65,125,1,17,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(66,90,1,17,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(67,125,1,17,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(68,90,1,17,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(69,125,1,17,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(70,125,1,17,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(71,90,1,18,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(72,125,1,18,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(73,90,1,18,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(74,125,1,18,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(75,90,1,18,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(76,125,1,18,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(77,125,1,18,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(78,90,1,19,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(79,125,1,19,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(80,125,1,19,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(81,125,1,20,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(82,90,1,20,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(83,125,1,20,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(84,125,1,20,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(85,90,1,21,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(86,125,1,21,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(87,125,1,22,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(88,125,1,22,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(89,125,1,23,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(90,125,1,23,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(91,125,1,24,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(92,125,1,24,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(93,125,1,25,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(94,26875,1,2,1,NULL,NULL,NULL,NULL,0,0,'Demosis',0,3,292,NULL,1,0,0,0,0,0,0),(95,4475,1,2,1,NULL,NULL,NULL,NULL,0,0,'Thor',0,3,292,NULL,1,0,0,0,0,0,0),(96,4475,1,2,1,NULL,NULL,NULL,NULL,0,0,'Thor',1,3,292,NULL,1,0,0,0,0,0,0),(97,2812,1,2,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,3,292,NULL,1,0,0,0,0,0,0),(98,2812,1,2,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,3,292,NULL,1,0,0,0,0,0,0),(99,2812,1,2,1,NULL,NULL,NULL,NULL,0,0,'Dirac',0,3,292,NULL,1,0,0,0,0,0,0),(100,26875,1,2,1,NULL,NULL,NULL,NULL,0,0,'Demosis',0,2,60,NULL,1,0,0,0,0,0,0),(101,26875,1,2,1,NULL,NULL,NULL,NULL,0,0,'Demosis',0,2,60,NULL,1,0,0,0,0,0,0),(102,2812,1,2,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,2,60,NULL,1,0,0,0,0,0,0),(103,2812,1,2,1,NULL,NULL,NULL,NULL,0,0,'Dirac',0,2,60,NULL,1,0,0,0,0,0,0),(104,26875,1,2,1,NULL,NULL,NULL,NULL,0,0,'Demosis',0,3,44,NULL,1,0,0,0,0,0,0),(105,26875,1,2,1,NULL,NULL,NULL,NULL,0,0,'Demosis',0,3,44,NULL,1,0,0,0,0,0,0),(106,4475,1,2,1,NULL,NULL,NULL,NULL,0,0,'Thor',1,3,44,NULL,1,0,0,0,0,0,0),(107,2812,1,2,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,3,44,NULL,1,0,0,0,0,0,0),(108,2812,1,2,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,3,44,NULL,1,0,0,0,0,0,0),(109,2812,1,2,1,NULL,NULL,NULL,NULL,0,0,'Dirac',0,3,44,NULL,1,0,0,0,0,0,0),(110,26875,1,2,1,NULL,NULL,NULL,NULL,0,0,'Demosis',0,0,90,NULL,1,0,0,0,0,0,0),(111,4475,1,2,1,NULL,NULL,NULL,NULL,0,0,'Thor',0,0,90,NULL,1,0,0,0,0,0,0),(112,2812,1,2,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,0,90,NULL,1,0,0,0,0,0,0),(113,2812,1,2,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,0,90,NULL,1,0,0,0,0,0,0),(114,2812,1,2,1,NULL,NULL,NULL,NULL,0,0,'Dirac',0,0,90,NULL,1,0,0,0,0,0,0),(115,90,1,26,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(116,125,1,26,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(117,125,1,26,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(118,90,1,27,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(119,125,1,27,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(120,125,1,27,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(121,90,1,28,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(122,125,1,28,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(123,125,1,28,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(124,125,1,28,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(125,90,1,29,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(126,125,1,29,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(127,90,1,29,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(128,125,1,29,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(129,90,1,29,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(130,125,1,29,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(131,125,1,29,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(132,125,1,30,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(133,90,1,30,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(134,125,1,30,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(135,125,1,30,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(136,90,1,30,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(137,125,1,30,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(138,125,1,30,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(139,90,1,31,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(140,125,1,31,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(141,90,1,31,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(142,125,1,31,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(143,90,1,31,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(144,125,1,31,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(145,125,1,31,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(146,90,1,32,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(147,125,1,32,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(148,125,1,33,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(149,125,1,33,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(150,125,1,34,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(151,125,1,34,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(152,125,1,35,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(153,125,1,35,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(154,4475,1,2,1,NULL,NULL,NULL,NULL,0,0,'Thor',0,1,135,NULL,1,0,0,0,0,0,0),(155,2812,1,2,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,1,135,NULL,1,0,0,0,0,0,0),(156,2812,1,2,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,1,135,NULL,1,0,0,0,0,0,0),(157,2812,1,2,1,NULL,NULL,NULL,NULL,0,0,'Dirac',0,1,135,NULL,1,0,0,0,0,0,0),(158,4475,1,2,1,NULL,NULL,NULL,NULL,0,0,'Thor',1,0,270,NULL,1,0,0,0,0,0,0),(159,2812,1,2,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,0,270,NULL,1,0,0,0,0,0,0),(160,2812,1,2,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,0,270,NULL,1,0,0,0,0,0,0),(161,2812,1,2,1,NULL,NULL,NULL,NULL,0,0,'Dirac',0,0,270,NULL,1,0,0,0,0,0,0),(162,4475,1,3,1,NULL,NULL,NULL,NULL,0,0,'Thor',0,3,156,NULL,1,0,0,0,0,0,0),(163,4475,1,3,1,NULL,NULL,NULL,NULL,0,0,'Thor',1,3,156,NULL,1,0,0,0,0,0,0),(164,2812,1,3,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,3,156,NULL,1,0,0,0,0,0,0),(165,2812,1,3,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,3,156,NULL,1,0,0,0,0,0,0),(166,2812,1,3,1,NULL,NULL,NULL,NULL,0,0,'Dirac',0,3,156,NULL,1,0,0,0,0,0,0),(167,90,1,36,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(168,125,1,36,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(169,125,1,36,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(170,90,1,36,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(171,125,1,36,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(172,125,1,36,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(173,125,1,36,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(174,125,1,36,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(175,90,1,37,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(176,125,1,37,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(177,125,1,37,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(178,90,1,37,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(179,125,1,37,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(180,125,1,37,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(181,125,1,37,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(182,125,1,37,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(183,125,1,38,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(184,125,1,38,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(185,125,1,38,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(186,125,1,38,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(187,125,1,38,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(188,90,1,39,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(189,125,1,39,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(190,125,1,39,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(191,90,1,39,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(192,125,1,39,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(193,125,1,39,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(194,125,1,39,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(195,125,1,39,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(196,125,1,40,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(197,125,1,40,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(198,125,1,40,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(199,125,1,40,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(200,125,1,40,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(201,125,1,40,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(202,125,1,41,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(203,125,1,41,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(204,125,1,41,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(205,125,1,41,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(206,125,1,41,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(207,125,1,41,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(208,90,1,42,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(209,125,1,42,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(210,125,1,42,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(211,90,1,42,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(212,125,1,42,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(213,125,1,42,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(214,125,1,42,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(215,125,1,42,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(216,125,1,43,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(217,125,1,43,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(218,125,1,43,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(219,125,1,43,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(220,125,1,43,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(221,125,1,43,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(222,125,1,44,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(223,125,1,44,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(224,125,1,44,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(225,125,1,44,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(226,125,1,44,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(227,125,1,44,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(228,90,1,45,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(229,125,1,45,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(230,125,1,45,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(231,90,1,45,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(232,125,1,45,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(233,125,1,45,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(234,125,1,45,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(235,125,1,45,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(236,90,1,46,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(237,125,1,46,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(238,125,1,46,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(239,90,1,46,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(240,125,1,46,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(241,125,1,46,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(242,125,1,46,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(243,125,1,46,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(244,90,1,50,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(245,125,1,50,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(246,125,1,50,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(247,125,1,50,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(248,90,1,50,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(249,125,1,50,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(250,125,1,50,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(251,125,1,50,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(252,125,1,50,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(253,90,1,54,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(254,125,1,54,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(255,90,1,54,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(256,125,1,54,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(257,125,1,54,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(258,90,1,54,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(259,125,1,54,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(260,90,1,54,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(261,125,1,54,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(262,90,1,54,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(263,125,1,54,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(264,125,1,54,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(265,125,1,54,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(266,125,1,54,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(267,26875,1,3,1,NULL,NULL,NULL,NULL,0,0,'Demosis',0,0,0,NULL,1,0,0,0,0,0,0),(268,26875,1,3,1,NULL,NULL,NULL,NULL,0,0,'Demosis',0,0,0,NULL,1,0,0,0,0,0,0),(269,26875,1,3,1,NULL,NULL,NULL,NULL,0,0,'Demosis',0,0,0,NULL,1,0,0,0,0,0,0),(270,4475,1,3,1,NULL,NULL,NULL,NULL,0,0,'Thor',0,0,0,NULL,1,0,0,0,0,0,0),(271,4475,1,3,1,NULL,NULL,NULL,NULL,0,0,'Thor',1,0,0,NULL,1,0,0,0,0,0,0),(272,2812,1,3,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,0,0,NULL,1,0,0,0,0,0,0),(273,2812,1,3,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,0,0,NULL,1,0,0,0,0,0,0),(274,2812,1,3,1,NULL,NULL,NULL,NULL,0,0,'Dirac',0,0,0,NULL,1,0,0,0,0,0,0),(275,90,1,58,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(276,125,1,58,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(277,125,1,58,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(278,90,1,59,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(279,90,1,59,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(280,125,1,59,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(281,125,1,59,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(282,90,1,60,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(283,125,1,60,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(284,90,1,60,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(285,125,1,60,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(286,125,1,60,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(287,125,1,60,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(288,90,1,61,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(289,125,1,61,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(290,125,1,61,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(291,125,1,61,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(292,90,1,62,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(293,125,1,62,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(294,125,1,62,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(295,125,1,63,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(296,90,1,63,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(297,125,1,63,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(298,90,1,63,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(299,125,1,63,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(300,90,1,63,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(301,125,1,63,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(302,125,1,63,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(303,125,1,64,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(304,125,1,64,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(305,125,1,65,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(306,125,1,65,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(307,125,1,66,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(308,125,1,66,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(309,125,1,67,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(310,125,1,67,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(311,125,1,68,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(312,125,1,68,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(313,125,1,69,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(314,125,1,69,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(315,90,1,70,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(316,125,1,70,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(317,125,1,70,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(318,125,1,71,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(319,125,1,71,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(320,125,1,72,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(321,90,1,72,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(322,125,1,72,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(323,125,1,72,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(324,90,1,73,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(325,125,1,73,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(326,90,1,73,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(327,90,1,73,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(328,125,1,73,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(329,125,1,73,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(330,125,1,74,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(331,125,1,74,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(332,125,1,75,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(333,125,1,75,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(334,125,1,76,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(335,125,1,76,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(336,26875,1,4,1,NULL,NULL,NULL,NULL,0,0,'Demosis',0,2,90,NULL,1,0,0,0,0,0,0),(337,2812,1,4,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,2,90,NULL,1,0,0,0,0,0,0),(338,2812,1,4,1,NULL,NULL,NULL,NULL,0,0,'Dirac',0,2,90,NULL,1,0,0,0,0,0,0),(339,4475,1,4,1,NULL,NULL,NULL,NULL,0,0,'Thor',0,1,180,NULL,1,0,0,0,0,0,0),(340,2812,1,4,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,1,180,NULL,1,0,0,0,0,0,0),(341,2812,1,4,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,1,180,NULL,1,0,0,0,0,0,0),(342,2812,1,4,1,NULL,NULL,NULL,NULL,0,0,'Dirac',0,1,180,NULL,1,0,0,0,0,0,0),(343,26875,1,4,1,NULL,NULL,NULL,NULL,0,0,'Demosis',0,2,240,NULL,1,0,0,0,0,0,0),(344,2812,1,4,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,2,240,NULL,1,0,0,0,0,0,0),(345,2812,1,4,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,2,240,NULL,1,0,0,0,0,0,0),(346,2812,1,4,1,NULL,NULL,NULL,NULL,0,0,'Dirac',0,2,240,NULL,1,0,0,0,0,0,0),(347,26875,1,4,1,NULL,NULL,NULL,NULL,0,0,'Demosis',0,3,292,NULL,1,0,0,0,0,0,0),(348,26875,1,4,1,NULL,NULL,NULL,NULL,0,0,'Demosis',0,3,292,NULL,1,0,0,0,0,0,0),(349,4475,1,4,1,NULL,NULL,NULL,NULL,0,0,'Thor',0,3,292,NULL,1,0,0,0,0,0,0),(350,2812,1,4,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,3,292,NULL,1,0,0,0,0,0,0),(351,2812,1,4,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,3,292,NULL,1,0,0,0,0,0,0),(352,2812,1,4,1,NULL,NULL,NULL,NULL,0,0,'Dirac',0,3,292,NULL,1,0,0,0,0,0,0),(353,90,1,77,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(354,125,1,77,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(355,125,1,77,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(356,90,1,78,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(357,125,1,78,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(358,125,1,78,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(359,90,1,79,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(360,125,1,79,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(361,125,1,79,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(362,125,1,80,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(363,125,1,80,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(364,90,1,81,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(365,125,1,81,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(366,90,1,81,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(367,125,1,81,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(368,125,1,81,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(369,90,1,82,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(370,125,1,82,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(371,125,1,82,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(372,90,1,82,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(373,125,1,82,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(374,125,1,82,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(375,125,1,83,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(376,125,1,83,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(377,125,1,84,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(378,125,1,85,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(379,125,1,85,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(380,125,1,86,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(381,4475,1,4,1,NULL,NULL,NULL,NULL,0,0,'Thor',0,1,135,NULL,1,0,0,0,0,0,0),(382,4475,1,4,1,NULL,NULL,NULL,NULL,0,0,'Thor',1,1,135,NULL,1,0,0,0,0,0,0),(383,2812,1,4,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,1,135,NULL,1,0,0,0,0,0,0),(384,2812,1,4,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,1,135,NULL,1,0,0,0,0,0,0),(385,2812,1,4,1,NULL,NULL,NULL,NULL,0,0,'Dirac',0,1,135,NULL,1,0,0,0,0,0,0),(386,26875,1,4,1,NULL,NULL,NULL,NULL,0,0,'Demosis',0,2,330,NULL,1,0,0,0,0,0,0),(387,26875,1,4,1,NULL,NULL,NULL,NULL,0,0,'Demosis',0,2,330,NULL,1,0,0,0,0,0,0),(388,26875,1,4,1,NULL,NULL,NULL,NULL,0,0,'Demosis',0,2,330,NULL,1,0,0,0,0,0,0),(389,4475,1,4,1,NULL,NULL,NULL,NULL,0,0,'Thor',1,2,330,NULL,1,0,0,0,0,0,0),(390,2812,1,4,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,2,330,NULL,1,0,0,0,0,0,0),(391,2812,1,4,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,2,330,NULL,1,0,0,0,0,0,0),(392,2812,1,4,1,NULL,NULL,NULL,NULL,0,0,'Dirac',0,2,330,NULL,1,0,0,0,0,0,0),(393,2812,1,4,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,0,270,NULL,1,0,0,0,0,0,0),(394,2812,1,4,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,0,270,NULL,1,0,0,0,0,0,0),(395,2812,1,4,1,NULL,NULL,NULL,NULL,0,0,'Dirac',0,0,270,NULL,1,0,0,0,0,0,0),(396,90,1,87,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(397,125,1,87,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(398,90,1,88,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(399,125,1,88,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(400,125,1,88,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(401,90,1,89,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(402,125,1,89,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(403,90,1,89,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(404,125,1,89,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(405,125,1,89,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(406,90,1,90,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(407,90,1,90,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(408,125,1,90,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(409,125,1,90,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(410,125,1,90,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(411,90,1,91,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(412,90,1,91,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(413,125,1,91,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(414,90,1,91,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(415,125,1,91,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(416,125,1,92,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(417,125,1,92,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(418,90,1,92,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(419,125,1,92,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(420,90,1,92,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(421,125,1,92,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(422,125,1,92,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(423,125,1,93,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(424,90,1,93,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(425,125,1,93,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(426,90,1,93,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(427,125,1,93,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(428,125,1,93,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(429,125,1,94,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(430,125,1,94,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(431,90,1,95,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(432,125,1,95,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(433,125,1,95,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(434,125,1,96,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(435,125,1,96,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(436,125,1,97,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(437,125,1,97,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(438,125,1,98,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(439,125,1,98,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0);
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

-- Dump completed on 2011-01-03 14:39:19
