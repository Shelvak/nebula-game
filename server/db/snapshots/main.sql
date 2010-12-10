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
) ENGINE=InnoDB AUTO_INCREMENT=98 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `buildings`
--

LOCK TABLES `buildings` WRITE;
/*!40000 ALTER TABLE `buildings` DISABLE KEYS */;
INSERT INTO `buildings` VALUES (1,15,31,5,0,0,0,1,'NpcMetalExtractor',NULL,32,6,NULL,1,400,NULL,0,NULL,NULL,0),(2,15,37,7,0,0,0,1,'NpcMetalExtractor',NULL,38,8,NULL,1,400,NULL,0,NULL,NULL,0),(3,15,9,1,0,0,0,1,'NpcGeothermalPlant',NULL,10,2,NULL,1,600,NULL,0,NULL,NULL,0),(4,15,9,10,0,0,0,1,'NpcGeothermalPlant',NULL,10,11,NULL,1,600,NULL,0,NULL,NULL,0),(5,15,2,2,0,0,0,1,'NpcZetiumExtractor',NULL,3,3,NULL,1,800,NULL,0,NULL,NULL,0),(6,15,19,0,0,0,0,1,'NpcResearchCenter',NULL,22,3,NULL,1,4000,NULL,0,NULL,NULL,0),(7,15,17,7,0,0,0,1,'NpcCommunicationsHub',NULL,19,8,NULL,1,1200,NULL,0,NULL,NULL,0),(8,15,13,7,0,0,0,1,'NpcExcavationSite',NULL,16,10,NULL,1,2000,NULL,0,NULL,NULL,0),(9,15,23,1,0,0,0,1,'NpcCommunicationsHub',NULL,25,2,NULL,1,1200,NULL,0,NULL,NULL,0),(10,15,11,4,0,0,0,1,'NpcSolarPlant',NULL,12,5,NULL,1,1000,NULL,0,NULL,NULL,0),(11,15,17,16,0,0,0,1,'NpcSolarPlant',NULL,18,17,NULL,1,1000,NULL,0,NULL,NULL,0),(12,15,28,7,0,0,0,1,'NpcSolarPlant',NULL,29,8,NULL,1,1000,NULL,0,NULL,NULL,0),(13,15,42,10,0,0,0,1,'NpcSolarPlant',NULL,43,11,NULL,1,1000,NULL,0,NULL,NULL,0),(14,25,2,13,0,0,0,1,'NpcMetalExtractor',NULL,3,14,NULL,1,400,NULL,0,NULL,NULL,0),(15,25,29,4,0,0,0,1,'NpcMetalExtractor',NULL,30,5,NULL,1,400,NULL,0,NULL,NULL,0),(16,25,33,9,0,0,0,1,'NpcMetalExtractor',NULL,34,10,NULL,1,400,NULL,0,NULL,NULL,0),(17,25,19,6,0,0,0,1,'NpcZetiumExtractor',NULL,20,7,NULL,1,800,NULL,0,NULL,NULL,0),(18,25,12,13,0,0,0,1,'NpcResearchCenter',NULL,15,16,NULL,1,4000,NULL,0,NULL,NULL,0),(19,25,45,12,0,0,0,1,'NpcExcavationSite',NULL,48,15,NULL,1,2000,NULL,0,NULL,NULL,0),(20,25,15,17,0,0,0,1,'NpcTemple',NULL,17,19,NULL,1,1500,NULL,0,NULL,NULL,0),(21,25,13,8,0,0,0,1,'NpcCommunicationsHub',NULL,15,9,NULL,1,1200,NULL,0,NULL,NULL,0),(22,25,9,10,0,0,0,1,'NpcSolarPlant',NULL,10,11,NULL,1,1000,NULL,0,NULL,NULL,0),(23,25,10,0,0,0,0,1,'NpcSolarPlant',NULL,11,1,NULL,1,1000,NULL,0,NULL,NULL,0),(24,25,23,8,0,0,0,1,'NpcSolarPlant',NULL,24,9,NULL,1,1000,NULL,0,NULL,NULL,0),(25,25,11,10,0,0,0,1,'NpcSolarPlant',NULL,12,11,NULL,1,1000,NULL,0,NULL,NULL,0),(26,29,8,49,0,0,0,1,'NpcMetalExtractor',NULL,9,50,NULL,1,400,NULL,0,NULL,NULL,0),(27,29,1,21,0,0,0,1,'NpcMetalExtractor',NULL,2,22,NULL,1,400,NULL,0,NULL,NULL,0),(28,29,14,26,0,0,0,1,'NpcMetalExtractor',NULL,15,27,NULL,1,400,NULL,0,NULL,NULL,0),(29,29,9,25,0,0,0,1,'NpcMetalExtractor',NULL,10,26,NULL,1,400,NULL,0,NULL,NULL,0),(30,29,4,39,0,0,0,1,'NpcMetalExtractor',NULL,5,40,NULL,1,400,NULL,0,NULL,NULL,0),(31,29,4,33,0,0,0,1,'NpcGeothermalPlant',NULL,5,34,NULL,1,600,NULL,0,NULL,NULL,0),(32,29,5,45,0,0,0,1,'NpcZetiumExtractor',NULL,6,46,NULL,1,800,NULL,0,NULL,NULL,0),(33,29,4,11,0,0,0,1,'NpcTemple',NULL,6,13,NULL,1,1500,NULL,0,NULL,NULL,0),(34,29,2,42,0,0,0,1,'NpcCommunicationsHub',NULL,4,43,NULL,1,1200,NULL,0,NULL,NULL,0),(35,29,0,43,0,0,0,1,'NpcSolarPlant',NULL,1,44,NULL,1,1000,NULL,0,NULL,NULL,0),(36,29,6,42,0,0,0,1,'NpcSolarPlant',NULL,7,43,NULL,1,1000,NULL,0,NULL,NULL,0),(37,29,4,0,0,0,0,1,'NpcSolarPlant',NULL,5,1,NULL,1,1000,NULL,0,NULL,NULL,0),(38,29,2,8,0,0,0,1,'NpcSolarPlant',NULL,3,9,NULL,1,1000,NULL,0,NULL,NULL,0),(39,35,11,25,0,0,0,1,'NpcMetalExtractor',NULL,12,26,NULL,1,400,NULL,0,NULL,NULL,0),(40,35,1,12,0,0,0,1,'NpcMetalExtractor',NULL,2,13,NULL,1,400,NULL,0,NULL,NULL,0),(41,35,1,21,0,0,0,1,'NpcGeothermalPlant',NULL,2,22,NULL,1,600,NULL,0,NULL,NULL,0),(42,35,12,2,0,0,0,1,'NpcZetiumExtractor',NULL,13,3,NULL,1,800,NULL,0,NULL,NULL,0),(43,35,17,8,0,0,0,1,'NpcSolarPlant',NULL,18,9,NULL,1,1000,NULL,0,NULL,NULL,0),(44,35,9,12,0,0,0,1,'NpcSolarPlant',NULL,10,13,NULL,1,1000,NULL,0,NULL,NULL,0),(45,35,15,12,0,0,0,1,'NpcSolarPlant',NULL,16,13,NULL,1,1000,NULL,0,NULL,NULL,0),(46,35,12,33,0,0,0,1,'NpcSolarPlant',NULL,13,34,NULL,1,1000,NULL,0,NULL,NULL,0),(47,39,4,1,0,0,0,1,'NpcMetalExtractor',NULL,5,2,NULL,1,400,NULL,0,NULL,NULL,0),(48,39,1,22,0,0,0,1,'NpcMetalExtractor',NULL,2,23,NULL,1,400,NULL,0,NULL,NULL,0),(49,39,1,8,0,0,0,1,'NpcMetalExtractor',NULL,2,9,NULL,1,400,NULL,0,NULL,NULL,0),(50,39,4,28,0,0,0,1,'NpcMetalExtractor',NULL,5,29,NULL,1,400,NULL,0,NULL,NULL,0),(51,39,1,35,0,0,0,1,'NpcGeothermalPlant',NULL,2,36,NULL,1,600,NULL,0,NULL,NULL,0),(52,39,10,38,0,0,0,1,'NpcZetiumExtractor',NULL,11,39,NULL,1,800,NULL,0,NULL,NULL,0),(53,39,5,35,0,0,0,1,'NpcSolarPlant',NULL,6,36,NULL,1,1000,NULL,0,NULL,NULL,0),(54,39,3,31,0,0,0,1,'NpcSolarPlant',NULL,4,32,NULL,1,1000,NULL,0,NULL,NULL,0),(55,47,20,35,0,0,0,1,'NpcMetalExtractor',NULL,21,36,NULL,1,400,NULL,0,NULL,NULL,0),(56,47,2,3,0,0,0,1,'NpcMetalExtractor',NULL,3,4,NULL,1,400,NULL,0,NULL,NULL,0),(57,47,6,36,0,0,0,1,'NpcMetalExtractor',NULL,7,37,NULL,1,400,NULL,0,NULL,NULL,0),(58,47,13,30,0,0,0,1,'NpcMetalExtractor',NULL,14,31,NULL,1,400,NULL,0,NULL,NULL,0),(59,47,16,13,0,0,0,1,'NpcGeothermalPlant',NULL,17,14,NULL,1,600,NULL,0,NULL,NULL,0),(60,47,16,39,0,0,0,1,'NpcZetiumExtractor',NULL,17,40,NULL,1,800,NULL,0,NULL,NULL,0),(61,47,16,2,0,0,0,1,'NpcTemple',NULL,18,4,NULL,1,1500,NULL,0,NULL,NULL,0),(62,47,19,4,0,0,0,1,'NpcCommunicationsHub',NULL,21,5,NULL,1,1200,NULL,0,NULL,NULL,0),(63,47,19,30,0,0,0,1,'NpcSolarPlant',NULL,20,31,NULL,1,1000,NULL,0,NULL,NULL,0),(64,47,5,32,0,0,0,1,'NpcSolarPlant',NULL,6,33,NULL,1,1000,NULL,0,NULL,NULL,0),(65,47,12,6,0,0,0,1,'NpcSolarPlant',NULL,13,7,NULL,1,1000,NULL,0,NULL,NULL,0),(66,47,15,16,0,0,0,1,'NpcSolarPlant',NULL,16,17,NULL,1,1000,NULL,0,NULL,NULL,0),(67,55,30,4,0,0,0,1,'NpcMetalExtractor',NULL,31,5,NULL,1,400,NULL,0,NULL,NULL,0),(68,55,16,14,0,0,0,1,'NpcMetalExtractor',NULL,17,15,NULL,1,400,NULL,0,NULL,NULL,0),(69,55,52,1,0,0,0,1,'NpcGeothermalPlant',NULL,53,2,NULL,1,600,NULL,0,NULL,NULL,0),(70,55,1,8,0,0,0,1,'NpcZetiumExtractor',NULL,2,9,NULL,1,800,NULL,0,NULL,NULL,0),(71,55,47,7,0,0,0,1,'NpcCommunicationsHub',NULL,49,8,NULL,1,1200,NULL,0,NULL,NULL,0),(72,55,51,14,0,0,0,1,'NpcSolarPlant',NULL,52,15,NULL,1,1000,NULL,0,NULL,NULL,0),(73,55,12,8,0,0,0,1,'NpcSolarPlant',NULL,13,9,NULL,1,1000,NULL,0,NULL,NULL,0),(74,55,3,14,0,0,0,1,'NpcSolarPlant',NULL,4,15,NULL,1,1000,NULL,0,NULL,NULL,0),(75,55,47,9,0,0,0,1,'NpcSolarPlant',NULL,48,10,NULL,1,1000,NULL,0,NULL,NULL,0),(76,58,0,0,0,0,0,1,'NpcMetalExtractor',NULL,1,1,NULL,1,400,NULL,0,NULL,NULL,0),(77,58,7,0,0,0,0,1,'NpcCommunicationsHub',NULL,9,1,NULL,1,1200,NULL,0,NULL,NULL,0),(78,58,18,0,0,0,0,1,'NpcSolarPlant',NULL,19,1,NULL,1,1000,NULL,0,NULL,NULL,0),(79,58,3,1,0,0,0,1,'NpcMetalExtractor',NULL,4,2,NULL,1,400,NULL,0,NULL,NULL,0),(80,58,12,1,0,0,0,1,'NpcSolarPlant',NULL,13,2,NULL,1,1000,NULL,0,NULL,NULL,0),(81,58,22,1,0,0,0,1,'NpcSolarPlant',NULL,23,2,NULL,1,1000,NULL,0,NULL,NULL,0),(82,58,26,1,0,0,0,1,'NpcCommunicationsHub',NULL,28,2,NULL,1,1200,NULL,0,NULL,NULL,0),(83,58,15,3,0,0,0,1,'NpcSolarPlant',NULL,16,4,NULL,1,1000,NULL,0,NULL,NULL,0),(84,58,18,3,0,0,0,1,'NpcSolarPlant',NULL,19,4,NULL,1,1000,NULL,0,NULL,NULL,0),(85,58,24,4,0,0,0,1,'NpcMetalExtractor',NULL,25,5,NULL,1,400,NULL,0,NULL,NULL,0),(86,58,28,4,0,0,0,1,'NpcMetalExtractor',NULL,29,5,NULL,1,400,NULL,0,NULL,NULL,0),(87,58,7,6,0,0,0,1,'Screamer',NULL,8,7,NULL,1,1700,NULL,0,NULL,NULL,0),(88,58,21,6,0,0,0,1,'Vulcan',NULL,22,7,NULL,1,1400,NULL,0,NULL,NULL,0),(89,58,14,7,0,0,0,1,'Thunder',NULL,15,8,NULL,1,2400,NULL,0,NULL,NULL,0),(90,58,25,7,0,0,0,1,'NpcTemple',NULL,27,9,NULL,1,1500,NULL,0,NULL,NULL,0),(91,58,11,10,0,0,0,1,'Mothership',NULL,18,15,NULL,1,10500,NULL,0,NULL,NULL,0),(92,58,7,12,0,0,0,1,'Thunder',NULL,8,13,NULL,1,2400,NULL,0,NULL,NULL,0),(93,58,21,12,0,0,0,1,'Thunder',NULL,22,13,NULL,1,2400,NULL,0,NULL,NULL,0),(94,58,26,12,0,0,0,1,'NpcZetiumExtractor',NULL,27,13,NULL,1,800,NULL,0,NULL,NULL,0),(95,58,7,19,0,0,0,1,'Vulcan',NULL,8,20,NULL,1,1400,NULL,0,NULL,NULL,0),(96,58,14,19,0,0,0,1,'Thunder',NULL,15,20,NULL,1,2400,NULL,0,NULL,NULL,0),(97,58,21,19,0,0,0,1,'Screamer',NULL,22,20,NULL,1,1700,NULL,0,NULL,NULL,0);
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
INSERT INTO `folliages` VALUES (15,0,5,1),(15,0,8,3),(15,0,9,7),(15,0,12,13),(15,0,13,11),(15,0,15,11),(15,0,16,10),(15,0,17,11),(15,1,2,1),(15,1,3,6),(15,1,9,13),(15,1,11,0),(15,1,12,10),(15,1,14,7),(15,2,14,1),(15,2,15,1),(15,2,24,5),(15,3,9,10),(15,3,14,2),(15,4,12,6),(15,5,10,7),(15,5,11,8),(15,5,16,12),(15,5,21,10),(15,5,24,3),(15,6,6,13),(15,6,13,4),(15,7,11,5),(15,7,16,9),(15,8,2,13),(15,8,9,7),(15,8,17,11),(15,8,18,1),(15,9,15,6),(15,9,18,4),(15,9,19,1),(15,9,22,12),(15,9,23,13),(15,10,17,5),(15,10,23,13),(15,10,24,5),(15,11,16,5),(15,11,24,2),(15,12,3,0),(15,12,17,13),(15,12,21,11),(15,12,24,5),(15,13,11,13),(15,14,18,2),(15,14,23,1),(15,15,15,0),(15,15,19,12),(15,15,23,12),(15,16,22,11),(15,17,12,1),(15,17,20,12),(15,17,22,7),(15,17,24,5),(15,18,9,7),(15,19,9,12),(15,19,10,6),(15,19,11,12),(15,19,15,0),(15,20,7,2),(15,20,15,10),(15,21,24,0),(15,22,4,13),(15,22,8,13),(15,22,9,11),(15,22,15,4),(15,22,16,1),(15,22,19,10),(15,23,0,11),(15,23,8,0),(15,24,10,6),(15,24,20,1),(15,25,8,2),(15,25,11,10),(15,26,8,3),(15,26,12,1),(15,26,14,13),(15,26,23,11),(15,26,24,2),(15,27,4,0),(15,27,5,1),(15,27,9,6),(15,27,12,11),(15,28,14,1),(15,28,21,10),(15,29,6,3),(15,29,9,13),(15,29,10,13),(15,29,13,3),(15,29,17,0),(15,29,22,2),(15,30,3,6),(15,30,9,5),(15,30,11,7),(15,30,13,7),(15,30,21,4),(15,30,22,12),(15,30,23,6),(15,30,24,7),(15,31,4,1),(15,31,21,11),(15,32,4,0),(15,32,8,6),(15,32,22,4),(15,32,23,10),(15,33,12,6),(15,33,23,11),(15,34,1,0),(15,34,10,13),(15,34,12,2),(15,34,23,6),(15,35,0,0),(15,35,6,4),(15,35,11,0),(15,36,6,3),(15,36,9,1),(15,36,11,5),(15,36,12,11),(15,36,18,7),(15,37,2,11),(15,37,18,8),(15,37,21,0),(15,37,23,7),(15,38,10,3),(15,38,19,1),(15,39,17,0),(15,39,19,1),(15,39,20,5),(15,39,22,0),(15,40,5,12),(15,40,12,2),(15,41,6,1),(15,41,13,7),(15,41,15,13),(15,41,18,1),(15,45,21,11),(15,45,24,7),(25,0,0,2),(25,0,7,4),(25,0,8,1),(25,1,8,11),(25,1,10,2),(25,1,19,5),(25,2,18,6),(25,3,8,6),(25,3,19,13),(25,4,1,0),(25,4,2,7),(25,4,6,10),(25,4,10,6),(25,4,18,12),(25,5,3,6),(25,5,6,8),(25,5,11,5),(25,5,14,7),(25,5,15,9),(25,5,18,1),(25,5,19,10),(25,6,5,4),(25,6,14,9),(25,7,7,11),(25,7,8,0),(25,7,10,1),(25,7,14,9),(25,8,8,0),(25,9,1,12),(25,9,16,0),(25,10,2,5),(25,10,14,5),(25,10,15,10),(25,12,18,5),(25,12,19,8),(25,13,10,13),(25,15,4,13),(25,16,7,8),(25,16,16,5),(25,17,16,2),(25,18,16,1),(25,18,18,7),(25,19,16,1),(25,19,18,6),(25,20,4,8),(25,20,5,13),(25,20,19,9),(25,21,10,3),(25,21,16,3),(25,22,14,7),(25,23,19,11),(25,24,7,1),(25,25,0,8),(25,26,9,3),(25,26,19,12),(25,27,8,2),(25,27,11,10),(25,27,19,4),(25,28,1,0),(25,28,2,0),(25,28,4,6),(25,28,7,0),(25,28,17,0),(25,29,6,7),(25,29,8,9),(25,30,6,4),(25,30,7,0),(25,30,8,11),(25,31,0,10),(25,31,5,10),(25,32,4,12),(25,32,9,11),(25,32,10,13),(25,32,14,0),(25,33,1,6),(25,33,4,7),(25,33,5,9),(25,34,17,3),(25,34,18,6),(25,35,2,8),(25,35,9,2),(25,35,10,11),(25,35,14,5),(25,35,19,10),(25,38,0,13),(25,40,19,3),(25,42,9,11),(25,42,14,13),(25,42,15,5),(25,42,16,11),(25,42,19,5),(25,43,0,6),(25,44,3,10),(25,44,7,2),(25,44,12,0),(25,44,15,3),(25,46,5,3),(25,46,6,8),(25,46,16,7),(25,46,17,8),(25,47,3,8),(25,47,7,5),(25,48,6,11),(25,48,18,8),(25,49,3,11),(25,49,16,2),(25,49,19,6),(25,50,15,11),(25,50,16,8),(25,50,17,4),(25,52,0,9),(25,52,17,9),(25,52,19,0),(25,53,19,0),(25,54,14,12),(25,54,16,5),(29,0,0,9),(29,0,2,4),(29,0,11,2),(29,0,25,1),(29,0,26,4),(29,0,30,10),(29,0,38,9),(29,0,47,1),(29,0,48,6),(29,1,23,8),(29,1,37,6),(29,1,38,10),(29,1,41,1),(29,2,0,4),(29,2,10,0),(29,2,13,2),(29,2,20,5),(29,2,24,4),(29,2,27,7),(29,2,34,13),(29,2,39,0),(29,2,41,2),(29,2,44,7),(29,3,3,2),(29,3,6,13),(29,3,7,6),(29,3,11,2),(29,3,12,1),(29,3,13,7),(29,3,24,1),(29,3,27,1),(29,3,37,5),(29,3,39,9),(29,3,40,5),(29,4,8,2),(29,4,9,0),(29,4,35,6),(29,4,37,7),(29,5,3,10),(29,5,29,4),(29,6,7,2),(29,6,9,7),(29,6,10,8),(29,6,16,3),(29,6,28,9),(29,6,47,5),(29,7,1,10),(29,7,3,6),(29,7,8,0),(29,7,15,4),(29,7,16,1),(29,7,47,6),(29,8,2,4),(29,8,6,6),(29,8,7,5),(29,8,8,2),(29,8,9,1),(29,8,15,1),(29,8,27,3),(29,8,47,4),(29,9,1,5),(29,9,2,5),(29,9,3,2),(29,9,27,11),(29,10,13,10),(29,10,19,6),(29,11,0,2),(29,11,5,3),(29,11,43,7),(29,11,44,8),(29,12,0,0),(29,12,1,5),(29,12,2,5),(29,12,3,4),(29,12,4,2),(29,12,19,5),(29,12,22,6),(29,12,25,3),(29,12,32,5),(29,12,33,7),(29,12,40,11),(29,12,43,3),(29,12,44,9),(29,12,50,11),(29,13,3,6),(29,13,5,9),(29,13,16,8),(29,13,18,2),(29,13,33,1),(29,13,35,11),(29,13,43,8),(29,13,50,9),(29,14,3,12),(29,14,10,2),(29,14,12,4),(29,14,16,4),(29,14,24,11),(29,14,28,1),(29,14,34,4),(29,14,39,5),(29,15,0,8),(29,15,8,8),(29,15,9,5),(29,15,29,10),(29,15,30,0),(29,15,39,11),(29,15,43,9),(29,15,45,6),(29,15,46,5),(29,15,47,3),(29,16,0,4),(29,16,8,10),(29,16,11,2),(29,16,13,6),(29,16,14,4),(29,16,18,3),(29,16,19,10),(29,16,24,6),(29,16,25,3),(29,16,30,13),(29,16,45,0),(35,0,3,12),(35,0,23,12),(35,0,30,0),(35,1,14,11),(35,1,31,0),(35,1,34,11),(35,2,14,4),(35,2,23,2),(35,3,12,3),(35,4,3,4),(35,4,26,5),(35,4,30,0),(35,5,0,9),(35,5,2,4),(35,5,16,4),(35,5,26,7),(35,6,1,4),(35,6,7,3),(35,6,8,11),(35,6,11,4),(35,6,13,8),(35,6,14,2),(35,6,15,2),(35,7,0,3),(35,7,5,7),(35,7,18,3),(35,7,24,6),(35,8,12,11),(35,8,15,9),(35,8,18,9),(35,9,15,5),(35,9,25,3),(35,9,26,6),(35,10,11,1),(35,10,24,10),(35,10,26,7),(35,10,30,12),(35,10,33,5),(35,12,12,13),(35,12,32,9),(35,13,0,10),(35,14,14,11),(35,14,21,2),(35,15,33,0),(35,16,4,5),(35,16,6,8),(35,16,14,1),(35,16,28,13),(35,16,29,1),(35,17,16,10),(35,18,12,4),(35,18,27,1),(35,18,34,1),(35,19,32,4),(35,19,33,1),(39,1,1,0),(39,1,26,12),(39,1,33,8),(39,2,2,5),(39,2,3,2),(39,2,10,12),(39,3,10,2),(39,4,3,11),(39,4,8,1),(39,4,9,4),(39,4,30,1),(39,5,7,8),(39,5,10,3),(39,5,19,13),(39,5,27,11),(39,5,30,11),(39,6,2,12),(39,6,4,13),(39,6,10,11),(39,7,0,3),(39,7,5,2),(39,7,8,2),(39,7,9,12),(39,7,11,9),(39,7,13,1),(39,7,40,5),(39,8,4,2),(39,8,7,10),(39,8,17,9),(39,8,37,6),(39,8,40,9),(39,8,44,13),(39,9,3,11),(39,9,4,9),(39,9,16,0),(39,9,17,0),(39,9,40,13),(39,9,41,5),(39,9,42,12),(39,9,45,6),(39,10,3,3),(39,10,13,3),(39,10,26,0),(39,11,3,0),(39,11,4,10),(39,11,32,1),(39,11,40,9),(39,11,41,2),(39,11,46,2),(39,12,22,7),(39,12,38,7),(39,12,43,11),(39,12,46,5),(47,0,0,6),(47,0,13,10),(47,0,14,12),(47,0,15,9),(47,0,24,8),(47,0,28,8),(47,0,30,5),(47,0,35,6),(47,0,36,0),(47,0,38,7),(47,1,2,0),(47,1,12,8),(47,1,24,2),(47,1,34,7),(47,2,8,11),(47,2,13,4),(47,2,15,7),(47,2,16,11),(47,2,22,4),(47,2,24,10),(47,3,5,12),(47,3,7,4),(47,3,26,7),(47,4,1,8),(47,4,13,3),(47,4,14,3),(47,4,15,0),(47,4,30,9),(47,4,34,1),(47,4,36,5),(47,4,37,5),(47,4,41,9),(47,5,10,11),(47,5,11,4),(47,5,14,7),(47,5,25,8),(47,5,39,9),(47,6,24,2),(47,6,39,11),(47,6,41,8),(47,7,5,5),(47,7,7,11),(47,7,9,2),(47,7,11,12),(47,7,25,9),(47,8,3,10),(47,8,4,5),(47,8,11,0),(47,8,17,3),(47,8,20,3),(47,8,27,5),(47,8,34,10),(47,8,41,9),(47,9,5,4),(47,9,6,1),(47,9,12,11),(47,9,27,9),(47,9,28,5),(47,9,32,9),(47,10,7,1),(47,10,20,8),(47,10,32,11),(47,12,18,12),(47,12,20,8),(47,13,0,2),(47,13,1,10),(47,13,18,5),(47,14,0,0),(47,14,7,7),(47,14,9,3),(47,14,11,0),(47,14,12,7),(47,14,13,0),(47,14,16,0),(47,14,17,6),(47,14,18,10),(47,14,32,11),(47,14,34,11),(47,14,39,12),(47,14,40,3),(47,15,0,8),(47,15,1,2),(47,15,14,8),(47,15,29,13),(47,15,32,7),(47,15,35,8),(47,16,1,1),(47,16,6,9),(47,16,7,5),(47,16,8,12),(47,16,11,3),(47,16,15,11),(47,16,18,6),(47,16,29,7),(47,16,31,2),(47,16,33,9),(47,17,1,3),(47,17,6,2),(47,17,15,12),(47,17,17,11),(47,17,24,3),(47,17,25,1),(47,17,29,3),(47,17,33,6),(47,17,41,8),(47,18,17,2),(47,18,18,4),(47,18,19,7),(47,18,21,2),(47,18,24,6),(47,18,25,4),(47,18,26,5),(47,18,33,6),(47,18,35,8),(47,18,36,9),(47,19,2,0),(47,19,9,1),(47,19,13,0),(47,19,21,6),(47,19,23,1),(47,19,25,11),(47,19,28,0),(47,19,33,2),(47,20,6,6),(47,20,12,6),(47,20,17,9),(47,20,18,5),(47,20,19,5),(47,20,23,1),(47,20,29,11),(47,21,19,0),(47,21,23,11),(47,21,31,3),(47,21,34,5),(47,22,2,12),(47,22,12,8),(47,22,18,5),(47,22,19,3),(47,22,21,0),(47,22,24,1),(47,22,30,10),(47,22,33,0),(55,0,5,4),(55,0,6,5),(55,0,9,5),(55,0,10,11),(55,1,11,0),(55,2,5,2),(55,2,6,12),(55,3,5,10),(55,3,9,4),(55,5,7,5),(55,5,9,6),(55,7,4,13),(55,9,11,9),(55,9,15,11),(55,9,16,11),(55,10,0,2),(55,10,1,4),(55,11,1,9),(55,11,10,12),(55,12,14,13),(55,12,16,13),(55,13,0,12),(55,13,16,9),(55,15,1,0),(55,16,6,12),(55,16,7,10),(55,16,9,1),(55,17,8,1),(55,17,9,3),(55,18,0,4),(55,19,7,8),(55,19,13,11),(55,21,13,7),(55,22,5,7),(55,22,12,6),(55,23,5,7),(55,23,6,2),(55,23,13,2),(55,23,15,1),(55,24,15,1),(55,25,8,1),(55,25,16,8),(55,26,15,6),(55,27,15,8),(55,27,16,3),(55,28,8,3),(55,28,15,4),(55,29,6,11),(55,29,15,7),(55,30,15,4),(55,30,16,3),(55,31,15,12),(55,31,16,13),(55,32,3,3),(55,32,6,8),(55,32,7,9),(55,32,16,4),(55,33,3,2),(55,33,14,3),(55,34,4,6),(55,34,9,12),(55,35,12,9),(55,37,2,2),(55,37,8,13),(55,38,10,6),(55,38,11,5),(55,38,13,2),(55,40,11,6),(55,40,14,6),(55,41,0,12),(55,41,10,9),(55,41,15,3),(55,42,4,8),(55,42,7,12),(55,43,3,4),(55,43,12,11),(55,43,15,10),(55,44,9,13),(55,44,16,6),(55,47,15,11),(55,49,9,5),(55,51,9,1),(55,51,11,13),(55,51,12,5),(55,52,13,13),(55,53,13,4),(55,54,4,8),(55,54,9,13),(55,54,13,13),(55,54,14,5),(58,0,23,2),(58,1,2,8),(58,1,14,6),(58,1,23,5),(58,2,1,12),(58,3,0,3),(58,3,3,4),(58,3,15,12),(58,4,10,7),(58,4,14,8),(58,4,25,5),(58,5,1,2),(58,5,3,6),(58,5,6,4),(58,5,10,0),(58,5,13,8),(58,5,14,11),(58,6,15,3),(58,7,8,3),(58,7,11,5),(58,8,5,10),(58,8,15,3),(58,9,6,8),(58,9,8,12),(58,9,10,1),(58,9,20,13),(58,10,1,2),(58,10,13,4),(58,10,18,4),(58,11,8,5),(58,11,18,11),(58,11,19,7),(58,11,22,4),(58,11,29,3),(58,12,20,11),(58,12,22,0),(58,13,3,8),(58,13,7,8),(58,13,16,11),(58,13,23,6),(58,13,28,4),(58,14,16,9),(58,14,21,7),(58,14,26,7),(58,14,28,6),(58,14,29,12),(58,15,5,0),(58,15,6,13),(58,15,22,2),(58,15,27,2),(58,16,7,3),(58,16,8,6),(58,17,6,10),(58,17,18,13),(58,17,26,3),(58,17,27,2),(58,18,6,4),(58,18,7,4),(58,19,9,4),(58,19,13,5),(58,19,16,1),(58,19,20,11),(58,19,27,3),(58,20,6,12),(58,20,15,11),(58,20,18,5),(58,20,22,1),(58,21,10,9),(58,21,11,8),(58,21,22,4),(58,22,8,2),(58,22,10,12),(58,22,16,7),(58,23,8,0),(58,23,14,3),(58,23,16,10),(58,24,3,9),(58,24,13,13),(58,24,14,4),(58,24,21,12),(58,25,1,4),(58,25,2,12),(58,25,23,9),(58,25,26,8),(58,26,0,7),(58,26,11,7),(58,27,28,4),(58,28,11,4),(58,29,13,9);
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
INSERT INTO `fow_ss_entries` VALUES (1,4,1,1,1,0,0,0,NULL,NULL,NULL,NULL,NULL);
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
INSERT INTO `galaxies` VALUES (1,'2010-12-09 14:14:28','dev');
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
) ENGINE=InnoDB AUTO_INCREMENT=25 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `objectives`
--

LOCK TABLES `objectives` WRITE;
/*!40000 ALTER TABLE `objectives` DISABLE KEYS */;
INSERT INTO `objectives` VALUES (1,1,'HaveUpgradedTo','Building::SolarPlant',1,1,0,0,NULL),(2,2,'HaveUpgradedTo','Building::MetalExtractor',1,1,0,0,NULL),(3,3,'HaveUpgradedTo','Building::SolarPlant',2,1,0,0,NULL),(4,3,'HaveUpgradedTo','Building::MetalExtractor',2,1,0,0,NULL),(5,4,'HaveUpgradedTo','Building::SolarPlant',2,3,0,0,NULL),(6,4,'HaveUpgradedTo','Building::MetalExtractor',2,3,0,0,NULL),(7,5,'HaveUpgradedTo','Building::SolarPlant',2,4,0,0,NULL),(8,5,'HaveUpgradedTo','Building::MetalExtractor',2,4,0,0,NULL),(9,6,'HaveUpgradedTo','Building::Barracks',1,1,0,0,NULL),(10,7,'HaveUpgradedTo','Unit::Trooper',2,1,0,0,NULL),(11,8,'DestroyNpcBuilding','Building::NpcMetalExtractor',1,1,0,0,NULL),(12,9,'HaveUpgradedTo','Building::MetalExtractor',1,7,0,0,NULL),(13,10,'HaveUpgradedTo','Building::SolarPlant',1,7,0,0,NULL),(14,11,'HaveUpgradedTo','Building::ResearchCenter',1,1,0,0,NULL),(15,12,'HaveUpgradedTo','Unit::Seeker',3,1,0,0,NULL),(16,13,'HaveUpgradedTo','Unit::Trooper',5,1,0,0,NULL),(17,14,'HaveUpgradedTo','Technology::ZetiumExtraction',1,1,0,0,NULL),(18,15,'HaveUpgradedTo','Building::ZetiumExtractor',1,1,0,0,NULL),(19,16,'HavePoints','Player',1,NULL,0,0,3000),(20,17,'HaveUpgradedTo','Building::EnergyStorage',1,1,0,0,NULL),(21,17,'HaveUpgradedTo','Building::MetalStorage',1,1,0,0,NULL),(22,17,'HaveUpgradedTo','Building::ZetiumStorage',1,1,0,0,NULL),(23,18,'HaveUpgradedTo','Technology::SpaceFactory',1,1,0,0,NULL),(24,19,'HaveUpgradedTo','Building::SpaceFactory',1,1,0,0,NULL);
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
) ENGINE=InnoDB AUTO_INCREMENT=20 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `quests`
--

LOCK TABLES `quests` WRITE;
/*!40000 ALTER TABLE `quests` DISABLE KEYS */;
INSERT INTO `quests` VALUES (1,1,'{\"metal\":1000,\"energy\":1000}','building'),(2,2,'{\"metal\":1000,\"energy\":1000}','metal-extraction'),(3,3,'{\"metal\":1000,\"energy\":1000}',NULL),(4,4,'{\"metal\":1000,\"energy\":1000}',NULL),(5,5,'{\"metal\":1000,\"energy\":1000}',NULL),(6,6,'{\"metal\":1500,\"energy\":1500}',NULL),(7,7,'{\"metal\":1000,\"energy\":1000}','building-units'),(8,8,'{\"units\":[{\"level\":2,\"count\":1,\"type\":\"Trooper\",\"hp\":50},{\"level\":3,\"count\":1,\"type\":\"Trooper\",\"hp\":20}]}',NULL),(9,9,'{\"metal\":1000,\"energy\":1000}',NULL),(10,10,'{\"metal\":1000,\"energy\":1000}',NULL),(11,11,'{\"metal\":2000,\"energy\":2000,\"zetium\":600}','researching'),(12,12,'{\"metal\":1000,\"energy\":1000,\"zetium\":100}',NULL),(13,13,'{\"metal\":1000,\"energy\":1000,\"zetium\":100}',NULL),(14,14,'{\"metal\":1000,\"energy\":1000,\"zetium\":200}',NULL),(15,15,'{\"metal\":1000,\"energy\":1000,\"zetium\":200}','extracting-zetium'),(16,16,'{\"units\":[{\"level\":2,\"count\":2,\"type\":\"Seeker\",\"hp\":100},{\"level\":2,\"count\":2,\"type\":\"Shocker\",\"hp\":100}]}','collecting-points'),(17,17,'{\"metal\":4000,\"energy\":4000,\"zetium\":2000}','storing-resources'),(18,18,'{\"metal\":4000,\"energy\":4000,\"zetium\":2000}','space-factory'),(19,19,'{\"metal\":4000,\"energy\":4000,\"zetium\":2000}',NULL);
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
INSERT INTO `schema_migrations` VALUES ('20090601175224'),('20090601184051'),('20090601184055'),('20090601184059'),('20090701164131'),('20090713165021'),('20090808144214'),('20090809160211'),('20090810173759'),('20090826140238'),('20090826141836'),('20090829202538'),('20090829210029'),('20090829224505'),('20090830143959'),('20090830145319'),('20090901153809'),('20090904190655'),('20090905175341'),('20090905192056'),('20090906135044'),('20090909222719'),('20090911180950'),('20090912165229'),('20090919155819'),('20091024222359'),('20091103164416'),('20091103180558'),('20091103181146'),('20091109191211'),('20091225193714'),('20100114152902'),('20100121142414'),('20100127115341'),('20100127120219'),('20100127120515'),('20100127121337'),('20100129150736'),('20100203202757'),('20100203204803'),('20100204172507'),('20100204173714'),('20100208163239'),('20100210114531'),('20100212134334'),('20100218181507'),('20100219114448'),('20100220144106'),('20100222144003'),('20100223153023'),('20100224153728'),('20100224163525'),('20100225124928'),('20100225153721'),('20100225155505'),('20100225155739'),('20100226122144'),('20100226122651'),('20100301153626'),('20100302131225'),('20100303131706'),('20100308163148'),('20100308164422'),('20100310172315'),('20100310181338'),('20100311123523'),('20100315112858'),('20100319141401'),('20100322184529'),('20100324134243'),('20100324141652'),('20100331125702'),('20100415130556'),('20100415130600'),('20100415130605'),('20100415134627'),('20100419141518'),('20100419142018'),('20100419164230'),('20100426141509'),('20100428130912'),('20100429171200'),('20100430174140'),('20100610151652'),('20100610180750'),('20100614142225'),('20100614160819'),('20100614162423'),('20100616132525'),('20100616135507'),('20100622124252'),('20100706105523'),('20100710121447'),('20100710191351'),('20100716155807'),('20100719131622'),('20100721155359'),('20100722124307'),('20100812164444'),('20100812164449'),('20100812164518'),('20100812164524'),('20100817165213'),('20100819175736'),('20100820185846'),('20100906095758'),('20100915145823'),('20100929111549'),('20101001155323'),('20101005180058'),('20101022155620'),('20101117131430'),('20101208135417'),('20101209122838'),('99999999999000'),('99999999999900');
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
INSERT INTO `solar_systems` VALUES (1,'Resource',1,2,0),(2,'Expansion',1,1,0),(3,'Expansion',1,0,1),(4,'Homeworld',1,0,0);
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
) ENGINE=InnoDB AUTO_INCREMENT=60 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ss_objects`
--

LOCK TABLES `ss_objects` WRITE;
/*!40000 ALTER TABLE `ss_objects` DISABLE KEYS */;
INSERT INTO `ss_objects` VALUES (1,1,0,0,1,225,'Asteroid',NULL,'',32,0,0,0,2,0,0,2,0,0,3,NULL,0,NULL,NULL,NULL),(2,1,0,0,2,90,'Asteroid',NULL,'',42,0,0,0,2,0,0,1,0,0,3,NULL,0,NULL,NULL,NULL),(3,1,0,0,1,315,'Asteroid',NULL,'',60,0,0,0,0,0,0,0,0,0,1,NULL,0,NULL,NULL,NULL),(4,1,0,0,3,134,'Jumpgate',NULL,'',28,0,0,0,0,0,0,0,0,0,0,NULL,0,NULL,NULL,NULL),(5,1,0,0,3,66,'Jumpgate',NULL,'',58,0,0,0,0,0,0,0,0,0,0,NULL,0,NULL,NULL,NULL),(6,1,0,0,2,60,'Asteroid',NULL,'',52,0,0,0,2,0,0,1,0,0,1,NULL,0,NULL,NULL,NULL),(7,1,0,0,1,0,'Asteroid',NULL,'',54,0,0,0,1,0,0,2,0,0,3,NULL,0,NULL,NULL,NULL),(8,1,0,0,2,30,'Asteroid',NULL,'',45,0,0,0,0,0,0,1,0,0,0,NULL,0,NULL,NULL,NULL),(9,1,0,0,3,44,'Jumpgate',NULL,'',25,0,0,0,0,0,0,0,0,0,0,NULL,0,NULL,NULL,NULL),(10,1,0,0,0,90,'Asteroid',NULL,'',60,0,0,0,0,0,0,0,0,0,1,NULL,0,NULL,NULL,NULL),(11,1,0,0,3,270,'Jumpgate',NULL,'',29,0,0,0,0,0,0,0,0,0,0,NULL,0,NULL,NULL,NULL),(12,1,0,0,0,270,'Asteroid',NULL,'',32,0,0,0,1,0,0,0,0,0,1,NULL,0,NULL,NULL,NULL),(13,1,0,0,2,0,'Asteroid',NULL,'',46,0,0,0,1,0,0,2,0,0,3,NULL,0,NULL,NULL,NULL),(14,1,0,0,0,180,'Asteroid',NULL,'',59,0,0,0,1,0,0,2,0,0,1,NULL,0,NULL,NULL,NULL),(15,2,46,25,1,45,'Planet',NULL,'P-15',54,2,0,0,0,0,0,0,0,0,0,'2010-12-09 14:14:30',0,NULL,NULL,NULL),(16,2,0,0,1,225,'Asteroid',NULL,'',32,0,0,0,1,0,0,1,0,0,1,NULL,0,NULL,NULL,NULL),(17,2,0,0,2,120,'Asteroid',NULL,'',38,0,0,0,0,0,0,0,0,0,0,NULL,0,NULL,NULL,NULL),(18,2,0,0,3,246,'Jumpgate',NULL,'',44,0,0,0,0,0,0,0,0,0,0,NULL,0,NULL,NULL,NULL),(19,2,0,0,2,210,'Asteroid',NULL,'',56,0,0,0,1,0,0,2,0,0,2,NULL,0,NULL,NULL,NULL),(20,2,0,0,1,315,'Asteroid',NULL,'',44,0,0,0,2,0,0,2,0,0,3,NULL,0,NULL,NULL,NULL),(21,2,0,0,2,240,'Asteroid',NULL,'',34,0,0,0,0,0,0,1,0,0,1,NULL,0,NULL,NULL,NULL),(22,2,0,0,3,292,'Jumpgate',NULL,'',47,0,0,0,0,0,0,0,0,0,0,NULL,0,NULL,NULL,NULL),(23,2,0,0,2,60,'Asteroid',NULL,'',60,0,0,0,0,0,0,0,0,0,0,NULL,0,NULL,NULL,NULL),(24,2,0,0,1,90,'Asteroid',NULL,'',52,0,0,0,1,0,0,1,0,0,1,NULL,0,NULL,NULL,NULL),(25,2,55,20,2,150,'Planet',NULL,'P-25',56,0,0,0,0,0,0,0,0,0,0,'2010-12-09 14:14:30',0,NULL,NULL,NULL),(26,2,0,0,2,30,'Asteroid',NULL,'',31,0,0,0,3,0,0,3,0,0,3,NULL,0,NULL,NULL,NULL),(27,2,0,0,1,135,'Asteroid',NULL,'',33,0,0,0,2,0,0,2,0,0,3,NULL,0,NULL,NULL,NULL),(28,2,0,0,2,330,'Asteroid',NULL,'',50,0,0,0,3,0,0,1,0,0,2,NULL,0,NULL,NULL,NULL),(29,2,17,52,0,270,'Planet',NULL,'P-29',54,0,0,0,0,0,0,0,0,0,0,'2010-12-09 14:14:30',0,NULL,NULL,NULL),(30,2,0,0,2,0,'Asteroid',NULL,'',60,0,0,0,3,0,0,1,0,0,2,NULL,0,NULL,NULL,NULL),(31,2,0,0,0,180,'Asteroid',NULL,'',29,0,0,0,1,0,0,0,0,0,1,NULL,0,NULL,NULL,NULL),(32,2,0,0,2,300,'Asteroid',NULL,'',32,0,0,0,3,0,0,1,0,0,2,NULL,0,NULL,NULL,NULL),(33,2,0,0,0,0,'Asteroid',NULL,'',39,0,0,0,1,0,0,0,0,0,1,NULL,0,NULL,NULL,NULL),(34,3,0,0,1,45,'Asteroid',NULL,'',48,0,0,0,1,0,0,1,0,0,0,NULL,0,NULL,NULL,NULL),(35,3,20,35,2,90,'Planet',NULL,'P-35',48,0,0,0,0,0,0,0,0,0,0,'2010-12-09 14:14:30',0,NULL,NULL,NULL),(36,3,0,0,2,120,'Asteroid',NULL,'',56,0,0,0,3,0,0,1,0,0,1,NULL,0,NULL,NULL,NULL),(37,3,0,0,3,314,'Jumpgate',NULL,'',47,0,0,0,0,0,0,0,0,0,0,NULL,0,NULL,NULL,NULL),(38,3,0,0,1,180,'Asteroid',NULL,'',45,0,0,0,2,0,0,2,0,0,3,NULL,0,NULL,NULL,NULL),(39,3,13,50,1,315,'Planet',NULL,'P-39',51,2,0,0,0,0,0,0,0,0,0,'2010-12-09 14:14:30',0,NULL,NULL,NULL),(40,3,0,0,2,240,'Asteroid',NULL,'',28,0,0,0,2,0,0,3,0,0,1,NULL,0,NULL,NULL,NULL),(41,3,0,0,1,0,'Asteroid',NULL,'',27,0,0,0,3,0,0,3,0,0,1,NULL,0,NULL,NULL,NULL),(42,3,0,0,2,60,'Asteroid',NULL,'',37,0,0,0,1,0,0,0,0,0,0,NULL,0,NULL,NULL,NULL),(43,3,0,0,2,150,'Asteroid',NULL,'',31,0,0,0,0,0,0,0,0,0,1,NULL,0,NULL,NULL,NULL),(44,3,0,0,2,30,'Asteroid',NULL,'',35,0,0,0,1,0,0,1,0,0,3,NULL,0,NULL,NULL,NULL),(45,3,0,0,0,90,'Asteroid',NULL,'',33,0,0,0,3,0,0,2,0,0,3,NULL,0,NULL,NULL,NULL),(46,3,0,0,1,135,'Asteroid',NULL,'',40,0,0,0,1,0,0,1,0,0,1,NULL,0,NULL,NULL,NULL),(47,3,23,42,0,270,'Planet',NULL,'P-47',52,0,0,0,0,0,0,0,0,0,0,'2010-12-09 14:14:30',0,NULL,NULL,NULL),(48,3,0,0,2,0,'Asteroid',NULL,'',59,0,0,0,3,0,0,3,0,0,1,NULL,0,NULL,NULL,NULL),(49,3,0,0,2,270,'Asteroid',NULL,'',28,0,0,0,1,0,0,2,0,0,3,NULL,0,NULL,NULL,NULL),(50,3,0,0,0,180,'Asteroid',NULL,'',50,0,0,0,0,0,0,0,0,0,0,NULL,0,NULL,NULL,NULL),(51,3,0,0,0,0,'Asteroid',NULL,'',28,0,0,0,2,0,0,3,0,0,3,NULL,0,NULL,NULL,NULL),(52,4,0,0,1,45,'Asteroid',NULL,'',43,0,0,0,0,0,0,1,0,0,1,NULL,0,NULL,NULL,NULL),(53,4,0,0,2,150,'Asteroid',NULL,'',35,0,0,0,1,0,0,0,0,0,1,NULL,0,NULL,NULL,NULL),(54,4,0,0,0,90,'Asteroid',NULL,'',52,0,0,0,1,0,0,1,0,0,1,NULL,0,NULL,NULL,NULL),(55,4,55,17,2,330,'Planet',NULL,'P-55',55,2,0,0,0,0,0,0,0,0,0,'2010-12-09 14:14:30',0,NULL,NULL,NULL),(56,4,0,0,3,156,'Jumpgate',NULL,'',49,0,0,0,0,0,0,0,0,0,0,NULL,0,NULL,NULL,NULL),(57,4,0,0,1,315,'Asteroid',NULL,'',25,0,0,0,1,0,0,0,0,0,1,NULL,0,NULL,NULL,NULL),(58,4,30,30,1,270,'Planet',1,'P-58',50,0,864,20,3024,1728,40,6048,0,0,604.8,'2010-12-09 14:14:30',0,NULL,NULL,NULL),(59,4,0,0,0,0,'Asteroid',NULL,'',45,0,0,0,1,0,0,1,0,0,0,NULL,0,NULL,NULL,NULL);
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
INSERT INTO `tiles` VALUES (5,15,0,18),(5,15,0,19),(5,15,0,20),(5,15,0,21),(5,15,0,22),(5,15,0,24),(14,15,1,5),(5,15,1,18),(5,15,1,19),(5,15,1,20),(5,15,1,21),(5,15,1,22),(5,15,1,23),(5,15,1,24),(2,15,2,2),(5,15,2,17),(5,15,2,18),(5,15,2,19),(5,15,2,20),(5,15,2,22),(5,15,2,23),(5,15,3,1),(4,15,3,21),(4,15,3,22),(4,15,3,23),(5,15,4,0),(5,15,4,1),(5,15,4,2),(5,15,4,3),(4,15,4,22),(4,15,4,23),(5,15,5,0),(5,15,5,1),(5,15,5,2),(5,15,5,3),(5,15,5,4),(4,15,5,19),(4,15,5,20),(4,15,5,23),(5,15,6,0),(5,15,6,1),(5,15,6,2),(5,15,6,3),(5,15,6,4),(5,15,6,7),(3,15,6,9),(3,15,6,10),(3,15,6,11),(3,15,6,12),(4,15,6,19),(4,15,6,20),(4,15,6,21),(4,15,6,22),(4,15,6,23),(5,15,7,1),(5,15,7,2),(5,15,7,3),(5,15,7,5),(5,15,7,6),(5,15,7,7),(5,15,7,8),(5,15,7,9),(3,15,7,12),(3,15,7,13),(4,15,7,20),(4,15,7,21),(4,15,7,22),(4,15,7,23),(5,15,8,1),(5,15,8,3),(5,15,8,4),(5,15,8,5),(5,15,8,6),(5,15,8,7),(5,15,8,8),(3,15,8,11),(3,15,8,12),(3,15,8,13),(3,15,8,14),(4,15,8,20),(4,15,8,21),(1,15,9,1),(5,15,9,3),(5,15,9,5),(5,15,9,6),(5,15,9,7),(1,15,9,10),(3,15,9,12),(3,15,9,13),(3,15,9,14),(4,15,9,20),(4,15,9,21),(5,15,10,5),(5,15,10,7),(5,15,10,8),(3,15,10,12),(3,15,10,13),(3,15,10,14),(3,15,10,15),(3,15,10,16),(4,15,10,21),(3,15,11,6),(3,15,11,7),(3,15,11,11),(3,15,11,12),(3,15,11,13),(3,15,11,14),(3,15,11,15),(4,15,11,21),(4,15,11,22),(4,15,11,23),(3,15,12,6),(3,15,12,7),(3,15,12,8),(3,15,12,9),(3,15,12,10),(3,15,12,11),(3,15,12,12),(3,15,12,13),(3,15,12,14),(3,15,12,15),(4,15,12,19),(4,15,12,20),(4,15,12,22),(4,15,12,23),(3,15,13,1),(3,15,13,3),(3,15,13,4),(3,15,13,5),(3,15,13,6),(3,15,13,12),(3,15,13,13),(4,15,13,20),(4,15,13,21),(4,15,13,22),(4,15,13,23),(3,15,14,1),(3,15,14,2),(3,15,14,3),(3,15,14,4),(3,15,14,5),(3,15,14,6),(3,15,14,11),(3,15,14,12),(3,15,14,13),(3,15,14,14),(4,15,14,20),(4,15,14,21),(4,15,14,22),(3,15,15,1),(3,15,15,3),(3,15,15,4),(3,15,15,5),(3,15,15,6),(3,15,15,11),(3,15,15,13),(4,15,15,18),(4,15,15,20),(4,15,15,21),(4,15,15,22),(3,15,16,0),(3,15,16,1),(3,15,16,2),(3,15,16,3),(3,15,16,4),(13,15,16,5),(4,15,16,12),(4,15,16,13),(4,15,16,14),(4,15,16,15),(4,15,16,17),(4,15,16,18),(4,15,16,19),(4,15,16,20),(3,15,17,1),(3,15,17,2),(3,15,17,3),(3,15,17,4),(4,15,17,10),(4,15,17,11),(4,15,17,13),(4,15,17,14),(4,15,17,19),(3,15,18,0),(3,15,18,1),(3,15,18,2),(3,15,18,3),(3,15,18,4),(4,15,18,10),(4,15,18,11),(4,15,18,12),(4,15,18,13),(4,15,18,14),(4,15,18,15),(4,15,18,19),(9,15,18,21),(3,15,19,4),(4,15,19,12),(4,15,19,13),(4,15,19,14),(4,15,20,12),(4,15,20,13),(4,15,20,14),(4,15,21,14),(4,15,21,15),(13,15,22,6),(4,15,22,14),(14,15,22,21),(4,15,23,15),(4,15,23,16),(4,15,24,13),(4,15,24,14),(4,15,24,15),(4,15,24,16),(4,15,24,17),(4,15,24,18),(4,15,25,15),(4,15,25,17),(4,15,25,18),(4,15,25,21),(6,15,26,0),(6,15,26,1),(6,15,26,2),(0,15,26,10),(4,15,26,18),(4,15,26,19),(4,15,26,20),(4,15,26,21),(6,15,27,1),(6,15,27,2),(6,15,27,3),(4,15,27,17),(4,15,27,18),(4,15,27,19),(4,15,27,20),(6,15,28,0),(6,15,28,1),(6,15,28,2),(6,15,28,3),(6,15,28,4),(4,15,28,18),(4,15,28,20),(6,15,29,0),(6,15,29,1),(6,15,29,2),(6,15,29,3),(6,15,29,4),(4,15,29,20),(6,15,30,0),(6,15,30,1),(6,15,30,2),(4,15,30,7),(5,15,30,16),(5,15,30,18),(5,15,30,19),(5,15,30,20),(6,15,31,0),(0,15,31,1),(0,15,31,5),(4,15,31,7),(4,15,31,8),(5,15,31,14),(5,15,31,15),(5,15,31,16),(5,15,31,18),(6,15,32,0),(4,15,32,7),(0,15,32,13),(5,15,32,15),(5,15,32,16),(5,15,32,17),(5,15,32,18),(5,15,32,19),(5,15,32,20),(4,15,33,1),(4,15,33,2),(4,15,33,3),(4,15,33,5),(4,15,33,6),(4,15,33,7),(4,15,33,8),(4,15,33,9),(6,15,33,15),(5,15,33,17),(5,15,33,18),(4,15,34,2),(4,15,34,3),(4,15,34,4),(4,15,34,5),(4,15,34,6),(6,15,34,14),(6,15,34,15),(5,15,34,18),(5,15,34,19),(0,15,34,21),(4,15,35,3),(4,15,35,4),(4,15,35,5),(6,15,35,13),(6,15,35,14),(6,15,35,15),(6,15,35,16),(5,15,35,18),(3,15,36,0),(4,15,36,3),(4,15,36,4),(6,15,36,13),(6,15,36,14),(6,15,36,15),(6,15,36,16),(6,15,36,17),(3,15,37,0),(3,15,37,1),(4,15,37,3),(3,15,37,4),(0,15,37,7),(6,15,37,14),(0,15,37,15),(3,15,38,0),(3,15,38,1),(3,15,38,2),(3,15,38,3),(3,15,38,4),(6,15,38,13),(6,15,38,14),(3,15,39,0),(3,15,39,1),(3,15,39,2),(3,15,39,3),(3,15,39,4),(3,15,39,5),(6,15,39,10),(6,15,39,13),(6,15,39,14),(6,15,39,15),(6,15,39,16),(3,15,40,0),(3,15,40,1),(3,15,40,2),(3,15,40,3),(3,15,40,4),(6,15,40,10),(6,15,40,13),(6,15,40,14),(11,15,40,19),(3,15,41,0),(3,15,41,1),(3,15,41,2),(9,15,41,3),(6,15,41,9),(6,15,41,10),(3,15,42,0),(3,15,42,1),(3,15,42,2),(6,15,42,9),(11,15,42,13),(3,15,43,0),(3,15,43,1),(3,15,43,2),(6,15,43,7),(6,15,43,9),(6,15,43,12),(3,15,44,0),(3,15,44,1),(3,15,44,2),(6,15,44,6),(6,15,44,7),(6,15,44,8),(6,15,44,9),(6,15,44,10),(6,15,44,11),(6,15,44,12),(3,15,45,0),(3,15,45,1),(3,15,45,2),(3,15,45,3),(3,15,45,4),(6,15,45,7),(6,15,45,8),(6,15,45,9),(6,15,45,10),(6,15,45,11),(6,15,45,12),(5,25,0,2),(5,25,0,3),(5,25,0,4),(5,25,0,5),(5,25,0,6),(5,25,1,2),(5,25,1,3),(5,25,1,4),(5,25,1,5),(5,25,2,3),(5,25,2,4),(5,25,2,5),(0,25,2,13),(5,25,3,2),(5,25,3,3),(5,25,3,4),(5,25,3,5),(5,25,3,6),(5,25,4,4),(0,25,4,8),(9,25,6,17),(6,25,7,9),(6,25,8,6),(6,25,8,7),(6,25,8,9),(13,25,9,3),(6,25,9,5),(6,25,9,6),(6,25,9,7),(6,25,9,8),(6,25,9,9),(5,25,10,5),(5,25,10,6),(5,25,10,7),(5,25,10,8),(6,25,10,9),(5,25,11,5),(5,25,11,6),(5,25,11,7),(5,25,11,8),(5,25,12,5),(5,25,12,6),(5,25,12,7),(5,25,12,8),(5,25,12,9),(5,25,13,6),(5,25,13,7),(9,25,14,0),(5,25,14,5),(5,25,14,6),(5,25,14,7),(3,25,14,10),(3,25,14,11),(3,25,14,12),(3,25,15,6),(3,25,15,10),(3,25,15,11),(3,25,15,12),(3,25,16,4),(3,25,16,5),(3,25,16,6),(3,25,16,8),(3,25,16,9),(3,25,16,10),(3,25,16,11),(3,25,16,12),(3,25,17,5),(3,25,17,6),(3,25,17,7),(3,25,17,8),(3,25,17,9),(4,25,17,10),(3,25,17,11),(4,25,17,12),(4,25,17,13),(4,25,17,14),(4,25,17,15),(3,25,18,0),(3,25,18,6),(3,25,18,7),(4,25,18,8),(4,25,18,9),(4,25,18,10),(4,25,18,11),(4,25,18,12),(4,25,18,13),(4,25,18,14),(4,25,18,15),(3,25,19,0),(2,25,19,6),(6,25,19,8),(6,25,19,9),(4,25,19,10),(4,25,19,11),(4,25,19,12),(4,25,19,13),(4,25,19,14),(4,25,19,15),(3,25,20,0),(1,25,20,1),(6,25,20,8),(6,25,20,9),(6,25,20,10),(4,25,20,12),(1,25,20,14),(3,25,21,0),(3,25,21,3),(3,25,21,5),(3,25,21,6),(6,25,21,7),(6,25,21,8),(6,25,21,9),(4,25,21,12),(6,25,21,13),(3,25,22,0),(3,25,22,1),(3,25,22,2),(3,25,22,3),(3,25,22,4),(3,25,22,5),(3,25,22,6),(6,25,22,7),(6,25,22,8),(6,25,22,11),(6,25,22,12),(6,25,22,13),(3,25,23,0),(3,25,23,1),(3,25,23,2),(3,25,23,3),(3,25,23,4),(3,25,23,5),(3,25,23,6),(3,25,23,7),(6,25,23,11),(6,25,23,12),(6,25,23,13),(6,25,23,14),(6,25,23,15),(3,25,24,0),(11,25,24,1),(6,25,24,11),(11,25,24,12),(4,25,28,10),(4,25,28,11),(14,25,28,12),(0,25,29,4),(4,25,29,10),(4,25,29,11),(14,25,29,16),(4,25,30,11),(4,25,31,10),(4,25,31,11),(4,25,31,12),(4,25,31,13),(6,25,32,6),(6,25,32,7),(4,25,32,11),(4,25,32,12),(4,25,32,13),(6,25,33,7),(6,25,33,8),(0,25,33,9),(4,25,33,11),(4,25,33,12),(4,25,33,13),(4,25,34,3),(4,25,34,4),(4,25,34,5),(6,25,34,6),(6,25,34,7),(6,25,34,8),(4,25,34,11),(4,25,34,12),(4,25,34,13),(4,25,34,14),(4,25,34,15),(4,25,34,16),(4,25,35,3),(4,25,35,4),(6,25,35,6),(6,25,35,7),(4,25,35,8),(4,25,35,11),(4,25,35,12),(4,25,35,13),(4,25,35,16),(4,25,36,2),(4,25,36,3),(4,25,36,4),(6,25,36,7),(4,25,36,8),(4,25,36,9),(4,25,36,10),(4,25,36,11),(4,25,36,12),(4,25,36,13),(4,25,36,14),(4,25,36,15),(4,25,36,16),(4,25,37,3),(4,25,37,4),(4,25,37,5),(0,25,37,6),(4,25,37,8),(4,25,37,11),(3,25,37,12),(4,25,37,14),(4,25,37,15),(4,25,37,16),(4,25,37,17),(4,25,38,3),(4,25,38,4),(4,25,38,5),(3,25,38,10),(4,25,38,11),(3,25,38,12),(10,25,38,13),(4,25,39,3),(4,25,39,4),(4,25,39,5),(4,25,39,6),(3,25,39,7),(3,25,39,8),(3,25,39,10),(3,25,39,11),(3,25,39,12),(4,25,40,3),(4,25,40,4),(4,25,40,5),(3,25,40,8),(3,25,40,9),(3,25,40,10),(3,25,40,11),(3,25,40,12),(4,25,41,1),(4,25,41,2),(4,25,41,3),(4,25,41,4),(4,25,41,5),(4,25,41,6),(0,25,41,7),(3,25,41,9),(3,25,41,11),(3,25,41,12),(4,25,42,0),(4,25,42,1),(4,25,42,2),(4,25,42,3),(4,25,42,4),(4,25,42,5),(4,25,42,6),(3,25,42,10),(3,25,42,11),(3,25,42,12),(3,25,42,13),(4,25,43,4),(4,25,43,5),(4,25,43,6),(4,25,43,7),(4,25,43,8),(4,25,43,9),(4,25,43,10),(3,25,43,11),(3,25,43,12),(4,25,44,8),(5,25,44,9),(5,25,44,10),(3,25,44,11),(5,25,45,7),(5,25,45,8),(5,25,45,9),(5,25,45,10),(5,25,45,11),(6,25,46,4),(5,25,46,8),(5,25,46,9),(5,25,46,10),(6,25,47,4),(5,25,47,8),(5,25,47,9),(5,25,47,10),(5,25,47,11),(6,25,48,4),(6,25,48,5),(5,25,48,8),(5,25,48,9),(5,25,48,10),(5,25,48,11),(6,25,49,4),(10,25,49,10),(6,25,50,2),(6,25,50,3),(6,25,50,4),(5,25,50,6),(5,25,50,7),(5,25,50,8),(5,25,50,9),(6,25,51,3),(6,25,51,4),(5,25,51,7),(5,25,51,8),(5,25,51,9),(8,25,52,2),(5,25,52,5),(5,25,52,6),(5,25,52,7),(5,25,52,8),(5,25,53,5),(5,25,53,6),(5,25,53,7),(5,25,53,8),(5,25,53,9),(5,25,54,5),(5,25,54,6),(4,29,0,5),(3,29,0,27),(3,29,0,28),(3,29,0,29),(3,29,0,31),(3,29,0,32),(3,29,0,33),(3,29,0,45),(4,29,1,3),(4,29,1,5),(4,29,1,6),(4,29,1,7),(11,29,1,14),(0,29,1,21),(3,29,1,27),(3,29,1,28),(3,29,1,29),(3,29,1,30),(3,29,1,31),(3,29,1,32),(3,29,1,45),(3,29,1,46),(13,29,1,48),(6,29,1,50),(4,29,2,3),(4,29,2,4),(4,29,2,5),(4,29,2,6),(4,29,2,7),(3,29,2,28),(3,29,2,29),(3,29,2,30),(3,29,2,31),(3,29,2,45),(3,29,2,46),(6,29,2,50),(6,29,2,51),(4,29,3,4),(4,29,3,5),(4,29,3,23),(4,29,3,25),(3,29,3,28),(2,29,3,29),(3,29,3,31),(3,29,3,44),(3,29,3,45),(3,29,3,47),(6,29,3,50),(6,29,3,51),(4,29,4,3),(4,29,4,4),(4,29,4,5),(4,29,4,6),(4,29,4,21),(4,29,4,22),(4,29,4,23),(4,29,4,24),(4,29,4,25),(4,29,4,26),(3,29,4,31),(3,29,4,32),(1,29,4,33),(0,29,4,39),(3,29,4,44),(3,29,4,45),(3,29,4,46),(3,29,4,47),(6,29,4,50),(6,29,4,51),(4,29,5,5),(4,29,5,6),(10,29,5,17),(4,29,5,21),(4,29,5,22),(4,29,5,23),(4,29,5,24),(4,29,5,25),(4,29,5,26),(3,29,5,30),(3,29,5,31),(3,29,5,32),(13,29,5,36),(4,29,5,38),(6,29,5,41),(3,29,5,42),(3,29,5,43),(3,29,5,44),(2,29,5,45),(3,29,5,47),(6,29,5,50),(6,29,5,51),(0,29,6,5),(4,29,6,21),(4,29,6,22),(3,29,6,23),(4,29,6,24),(3,29,6,30),(3,29,6,31),(3,29,6,32),(3,29,6,33),(3,29,6,34),(3,29,6,35),(4,29,6,38),(6,29,6,39),(6,29,6,40),(6,29,6,41),(3,29,6,44),(6,29,6,50),(6,29,6,51),(6,29,7,4),(3,29,7,21),(3,29,7,22),(3,29,7,23),(4,29,7,24),(5,29,7,25),(5,29,7,26),(3,29,7,31),(3,29,7,32),(3,29,7,33),(3,29,7,34),(3,29,7,35),(4,29,7,38),(4,29,7,39),(4,29,7,40),(6,29,7,41),(6,29,7,44),(4,29,7,48),(6,29,7,49),(6,29,7,50),(6,29,7,51),(6,29,8,4),(6,29,8,5),(5,29,8,21),(5,29,8,22),(5,29,8,23),(5,29,8,24),(5,29,8,25),(11,29,8,29),(4,29,8,38),(4,29,8,39),(6,29,8,40),(6,29,8,41),(6,29,8,42),(6,29,8,43),(6,29,8,44),(6,29,8,45),(4,29,8,48),(0,29,8,49),(6,29,8,51),(6,29,9,4),(6,29,9,5),(4,29,9,6),(4,29,9,7),(4,29,9,9),(4,29,9,10),(9,29,9,16),(14,29,9,20),(5,29,9,24),(0,29,9,25),(4,29,9,39),(6,29,9,41),(6,29,9,42),(6,29,9,45),(4,29,9,47),(4,29,9,48),(6,29,9,51),(6,29,10,0),(6,29,10,1),(6,29,10,3),(6,29,10,4),(6,29,10,5),(6,29,10,6),(4,29,10,7),(4,29,10,8),(4,29,10,9),(5,29,10,24),(4,29,10,38),(4,29,10,39),(4,29,10,40),(6,29,10,42),(4,29,10,47),(4,29,10,48),(4,29,10,49),(4,29,10,50),(4,29,10,51),(6,29,11,1),(6,29,11,2),(6,29,11,3),(6,29,11,4),(6,29,11,6),(4,29,11,7),(4,29,11,8),(4,29,11,9),(4,29,11,10),(4,29,11,11),(5,29,11,24),(4,29,11,35),(4,29,11,36),(4,29,11,37),(4,29,11,38),(4,29,11,39),(4,29,11,47),(4,29,11,48),(4,29,11,50),(4,29,12,6),(4,29,12,7),(4,29,12,9),(4,29,12,10),(4,29,12,11),(5,29,12,15),(4,29,12,36),(4,29,12,37),(4,29,12,47),(4,29,12,48),(4,29,12,49),(3,29,13,1),(3,29,13,2),(4,29,13,6),(3,29,13,7),(5,29,13,14),(5,29,13,15),(14,29,13,20),(9,29,13,40),(4,29,13,46),(4,29,13,47),(4,29,13,49),(5,29,13,51),(3,29,14,2),(3,29,14,4),(0,29,14,5),(3,29,14,7),(5,29,14,14),(5,29,14,15),(0,29,14,26),(3,29,14,35),(3,29,14,38),(5,29,14,50),(5,29,14,51),(3,29,15,1),(3,29,15,2),(3,29,15,3),(3,29,15,4),(3,29,15,7),(5,29,15,15),(5,29,15,16),(3,29,15,32),(3,29,15,33),(3,29,15,34),(3,29,15,35),(3,29,15,36),(3,29,15,37),(3,29,15,38),(5,29,15,48),(5,29,15,49),(5,29,15,50),(5,29,15,51),(3,29,16,2),(3,29,16,3),(3,29,16,4),(3,29,16,5),(3,29,16,6),(3,29,16,7),(5,29,16,15),(5,29,16,16),(5,29,16,17),(3,29,16,31),(3,29,16,32),(3,29,16,33),(3,29,16,34),(3,29,16,36),(3,29,16,37),(3,29,16,38),(3,29,16,39),(5,29,16,49),(5,29,16,50),(5,29,16,51),(12,35,0,5),(6,35,0,11),(6,35,0,12),(6,35,0,13),(10,35,0,15),(5,35,0,20),(5,35,0,21),(11,35,0,24),(6,35,1,11),(0,35,1,12),(5,35,1,19),(5,35,1,20),(1,35,1,21),(0,35,1,32),(6,35,2,11),(5,35,2,19),(5,35,2,20),(5,35,3,19),(5,35,3,20),(3,35,3,32),(3,35,3,33),(3,35,3,34),(5,35,4,15),(5,35,4,16),(5,35,4,17),(5,35,4,18),(5,35,4,19),(8,35,4,20),(3,35,4,33),(3,35,4,34),(5,35,5,15),(5,35,5,18),(5,35,5,19),(1,35,5,24),(9,35,5,27),(3,35,5,32),(3,35,5,33),(3,35,5,34),(9,35,6,2),(0,35,6,31),(13,35,7,21),(3,35,7,33),(3,35,7,34),(5,35,8,0),(5,35,8,1),(12,35,8,5),(0,35,8,16),(3,35,8,31),(3,35,8,33),(5,35,9,0),(5,35,9,1),(3,35,9,18),(3,35,9,30),(3,35,9,31),(3,35,9,32),(3,35,9,33),(5,35,10,0),(5,35,10,1),(5,35,10,2),(5,35,10,3),(5,35,10,4),(3,35,10,14),(3,35,10,15),(3,35,10,16),(3,35,10,17),(3,35,10,18),(3,35,10,19),(3,35,10,20),(5,35,10,28),(5,35,10,29),(5,35,11,0),(5,35,11,1),(5,35,11,4),(11,35,11,15),(4,35,11,24),(0,35,11,25),(5,35,11,27),(5,35,11,28),(5,35,11,29),(5,35,12,0),(5,35,12,1),(2,35,12,2),(4,35,12,4),(4,35,12,23),(4,35,12,24),(5,35,12,28),(5,35,12,29),(0,35,12,30),(5,35,13,1),(4,35,13,4),(4,35,13,23),(4,35,13,24),(4,35,13,25),(5,35,13,27),(5,35,13,28),(5,35,13,29),(5,35,14,1),(4,35,14,3),(4,35,14,4),(5,35,14,5),(5,35,14,6),(5,35,14,7),(5,35,14,8),(6,35,14,9),(6,35,14,10),(4,35,14,23),(4,35,14,24),(4,35,14,25),(4,35,14,26),(4,35,14,27),(5,35,14,28),(5,35,14,29),(5,35,14,30),(6,35,14,33),(6,35,14,34),(4,35,15,3),(4,35,15,4),(4,35,15,5),(5,35,15,6),(5,35,15,7),(5,35,15,8),(6,35,15,9),(6,35,15,10),(6,35,15,11),(4,35,15,20),(4,35,15,21),(4,35,15,22),(4,35,15,23),(4,35,15,24),(0,35,15,26),(5,35,15,28),(5,35,15,29),(5,35,15,30),(6,35,15,34),(4,35,16,0),(4,35,16,1),(4,35,16,2),(4,35,16,3),(4,35,16,5),(5,35,16,8),(5,35,16,9),(5,35,16,10),(5,35,16,11),(4,35,16,15),(0,35,16,17),(4,35,16,19),(4,35,16,20),(10,35,16,21),(3,35,16,25),(6,35,16,33),(6,35,16,34),(5,35,17,0),(5,35,17,1),(5,35,17,2),(4,35,17,3),(4,35,17,4),(4,35,17,5),(4,35,17,6),(5,35,17,10),(4,35,17,14),(4,35,17,15),(4,35,17,19),(4,35,17,20),(3,35,17,25),(3,35,17,26),(3,35,17,27),(3,35,17,28),(5,35,18,0),(5,35,18,1),(5,35,18,2),(4,35,18,3),(4,35,18,5),(5,35,18,6),(5,35,18,7),(5,35,18,10),(5,35,18,11),(4,35,18,15),(4,35,18,16),(4,35,18,17),(4,35,18,18),(4,35,18,19),(4,35,18,20),(3,35,18,25),(3,35,18,26),(5,35,19,0),(5,35,19,1),(5,35,19,2),(5,35,19,3),(5,35,19,4),(5,35,19,5),(5,35,19,6),(5,35,19,7),(5,35,19,10),(5,35,19,11),(4,35,19,13),(4,35,19,14),(4,35,19,15),(4,35,19,17),(4,35,19,18),(4,35,19,19),(4,35,19,20),(3,35,19,25),(9,39,0,4),(3,39,0,8),(3,39,0,9),(3,39,0,10),(3,39,0,11),(3,39,0,12),(3,39,0,13),(3,39,0,14),(3,39,0,15),(3,39,0,16),(3,39,0,17),(3,39,0,18),(3,39,0,19),(5,39,0,26),(5,39,0,27),(5,39,0,28),(5,39,0,29),(5,39,0,30),(4,39,0,35),(4,39,0,36),(4,39,0,37),(4,39,0,38),(4,39,0,39),(4,39,0,40),(4,39,0,41),(4,39,0,42),(4,39,0,43),(4,39,0,44),(3,39,0,45),(3,39,0,46),(3,39,0,47),(3,39,0,48),(3,39,0,49),(0,39,1,8),(12,39,1,11),(13,39,1,17),(3,39,1,19),(3,39,1,20),(3,39,1,21),(0,39,1,22),(5,39,1,25),(5,39,1,27),(5,39,1,28),(6,39,1,29),(5,39,1,30),(1,39,1,35),(4,39,1,37),(4,39,1,38),(4,39,1,39),(4,39,1,40),(4,39,1,41),(4,39,1,42),(3,39,1,43),(3,39,1,44),(3,39,1,45),(14,39,1,46),(3,39,2,20),(3,39,2,21),(5,39,2,25),(5,39,2,26),(5,39,2,27),(6,39,2,28),(6,39,2,29),(4,39,2,38),(4,39,2,39),(11,39,2,40),(3,39,3,20),(3,39,3,21),(3,39,3,22),(6,39,3,28),(6,39,3,29),(6,39,3,30),(5,39,3,36),(13,39,3,38),(0,39,4,1),(6,39,4,6),(6,39,4,20),(3,39,4,21),(8,39,4,24),(0,39,4,28),(5,39,4,33),(5,39,4,34),(5,39,4,35),(5,39,4,36),(5,39,4,37),(4,39,4,46),(4,39,4,47),(6,39,5,3),(6,39,5,4),(6,39,5,5),(6,39,5,6),(0,39,5,8),(6,39,5,20),(3,39,5,21),(5,39,5,33),(5,39,5,34),(5,39,5,37),(4,39,5,46),(4,39,5,47),(4,39,5,48),(4,39,5,49),(3,39,6,3),(6,39,6,6),(6,39,6,20),(6,39,6,21),(6,39,6,22),(6,39,6,23),(5,39,6,32),(5,39,6,33),(5,39,6,37),(5,39,6,40),(5,39,6,41),(5,39,6,42),(5,39,6,43),(4,39,6,44),(4,39,6,45),(4,39,6,46),(4,39,6,47),(4,39,6,48),(4,39,6,49),(3,39,7,1),(3,39,7,2),(3,39,7,3),(4,39,7,15),(10,39,7,19),(14,39,7,23),(11,39,7,28),(5,39,7,42),(5,39,7,43),(4,39,7,45),(4,39,7,47),(4,39,7,48),(3,39,8,0),(3,39,8,1),(3,39,8,2),(3,39,8,3),(3,39,8,8),(3,39,8,9),(5,39,8,10),(4,39,8,12),(4,39,8,13),(4,39,8,15),(4,39,8,16),(5,39,8,42),(5,39,8,43),(4,39,8,45),(4,39,8,46),(4,39,8,47),(3,39,9,2),(3,39,9,7),(3,39,9,8),(3,39,9,9),(5,39,9,10),(5,39,9,11),(4,39,9,12),(4,39,9,13),(4,39,9,14),(4,39,9,15),(4,39,9,18),(6,39,9,35),(5,39,9,43),(5,39,9,44),(0,39,9,47),(3,39,10,2),(8,39,10,5),(3,39,10,9),(3,39,10,10),(5,39,10,11),(5,39,10,12),(4,39,10,14),(4,39,10,15),(4,39,10,16),(4,39,10,17),(4,39,10,18),(6,39,10,35),(6,39,10,36),(2,39,10,38),(5,39,10,43),(5,39,10,44),(3,39,11,2),(3,39,11,8),(3,39,11,9),(5,39,11,10),(5,39,11,11),(5,39,11,12),(5,39,11,13),(5,39,11,14),(4,39,11,15),(5,39,11,16),(4,39,11,17),(4,39,11,18),(5,39,11,19),(5,39,11,20),(6,39,11,34),(6,39,11,35),(6,39,11,36),(3,39,12,8),(3,39,12,9),(5,39,12,10),(5,39,12,11),(5,39,12,12),(5,39,12,13),(5,39,12,14),(5,39,12,15),(5,39,12,16),(5,39,12,17),(5,39,12,18),(5,39,12,19),(5,39,12,20),(3,47,0,6),(3,47,0,7),(4,47,0,19),(4,47,0,20),(4,47,0,21),(6,47,0,39),(6,47,0,41),(3,47,1,6),(4,47,1,16),(4,47,1,17),(4,47,1,18),(4,47,1,19),(4,47,1,20),(4,47,1,21),(4,47,1,22),(4,47,1,23),(5,47,1,26),(5,47,1,27),(5,47,1,28),(6,47,1,39),(6,47,1,40),(6,47,1,41),(0,47,2,3),(3,47,2,6),(4,47,2,17),(4,47,2,19),(4,47,2,20),(4,47,2,21),(5,47,2,27),(5,47,2,28),(5,47,2,29),(5,47,2,31),(5,47,2,32),(5,47,2,33),(6,47,2,39),(6,47,2,41),(3,47,3,6),(4,47,3,19),(4,47,3,20),(4,47,3,21),(4,47,3,22),(5,47,3,27),(5,47,3,28),(5,47,3,29),(5,47,3,30),(5,47,3,31),(5,47,3,32),(5,47,3,33),(6,47,3,41),(4,47,4,2),(4,47,4,3),(4,47,4,4),(4,47,4,5),(3,47,4,6),(3,47,4,7),(3,47,4,8),(11,47,4,16),(5,47,4,26),(5,47,4,27),(5,47,4,28),(5,47,4,29),(5,47,4,31),(5,47,4,32),(5,47,4,33),(4,47,5,0),(4,47,5,1),(4,47,5,2),(4,47,5,3),(3,47,5,4),(3,47,5,5),(3,47,5,6),(5,47,5,26),(5,47,5,27),(5,47,5,28),(5,47,5,29),(5,47,5,30),(5,47,5,31),(3,47,5,38),(4,47,6,1),(4,47,6,2),(4,47,6,3),(3,47,6,4),(3,47,6,5),(3,47,6,6),(5,47,6,28),(5,47,6,29),(5,47,6,30),(5,47,6,31),(0,47,6,36),(3,47,6,38),(4,47,7,1),(4,47,7,2),(4,47,7,3),(4,47,7,4),(0,47,7,23),(5,47,7,28),(5,47,7,29),(5,47,7,30),(3,47,7,38),(4,47,8,0),(4,47,8,1),(4,47,8,2),(5,47,8,22),(5,47,8,26),(9,47,8,29),(3,47,8,35),(3,47,8,36),(3,47,8,37),(3,47,8,38),(4,47,9,1),(4,47,9,2),(5,47,9,21),(5,47,9,22),(5,47,9,23),(5,47,9,25),(5,47,9,26),(3,47,9,36),(3,47,9,37),(3,47,9,38),(3,47,9,39),(3,47,9,40),(3,47,9,41),(4,47,10,1),(4,47,10,2),(4,47,10,4),(11,47,10,8),(3,47,10,14),(5,47,10,23),(5,47,10,25),(6,47,10,27),(6,47,10,28),(3,47,10,36),(3,47,10,37),(3,47,10,38),(3,47,10,39),(3,47,10,40),(3,47,10,41),(4,47,11,2),(4,47,11,3),(4,47,11,4),(3,47,11,14),(3,47,11,15),(3,47,11,16),(3,47,11,17),(5,47,11,21),(5,47,11,22),(5,47,11,23),(5,47,11,24),(5,47,11,25),(6,47,11,26),(6,47,11,27),(6,47,11,28),(6,47,11,32),(6,47,11,33),(3,47,11,37),(3,47,11,38),(3,47,11,39),(3,47,11,40),(3,47,11,41),(4,47,12,0),(4,47,12,1),(4,47,12,2),(4,47,12,3),(4,47,12,4),(3,47,12,14),(3,47,12,15),(3,47,12,17),(4,47,12,21),(5,47,12,22),(5,47,12,23),(5,47,12,24),(5,47,12,25),(5,47,12,26),(5,47,12,27),(6,47,12,28),(6,47,12,29),(6,47,12,30),(6,47,12,31),(6,47,12,32),(6,47,12,33),(3,47,12,36),(3,47,12,37),(0,47,12,39),(3,47,12,41),(4,47,13,3),(4,47,13,4),(4,47,13,5),(3,47,13,14),(3,47,13,15),(3,47,13,16),(0,47,13,19),(4,47,13,21),(4,47,13,22),(5,47,13,23),(5,47,13,24),(5,47,13,25),(5,47,13,26),(5,47,13,27),(5,47,13,28),(6,47,13,29),(0,47,13,30),(6,47,13,32),(6,47,13,33),(3,47,13,37),(5,47,13,38),(4,47,14,4),(4,47,14,5),(4,47,14,6),(3,47,14,14),(3,47,14,15),(4,47,14,21),(4,47,14,22),(5,47,14,23),(5,47,14,24),(5,47,14,25),(5,47,14,26),(5,47,14,27),(5,47,14,28),(5,47,14,29),(5,47,14,37),(5,47,14,38),(4,47,15,4),(3,47,15,15),(4,47,15,19),(4,47,15,20),(4,47,15,21),(4,47,15,22),(5,47,15,25),(5,47,15,26),(5,47,15,28),(5,47,15,36),(5,47,15,37),(5,47,15,38),(5,47,15,39),(1,47,16,13),(4,47,16,19),(4,47,16,20),(4,47,16,21),(4,47,16,22),(4,47,16,23),(5,47,16,37),(2,47,16,39),(0,47,17,8),(4,47,17,19),(4,47,17,20),(4,47,17,21),(4,47,17,23),(5,47,17,34),(5,47,17,36),(5,47,17,37),(5,47,17,38),(3,47,18,7),(4,47,18,23),(5,47,18,34),(5,47,18,37),(5,47,18,38),(5,47,18,39),(5,47,18,40),(3,47,19,6),(3,47,19,7),(3,47,19,8),(6,47,19,16),(5,47,19,34),(5,47,19,35),(5,47,19,36),(5,47,19,37),(5,47,19,38),(5,47,19,39),(5,47,19,41),(3,47,20,7),(3,47,20,8),(3,47,20,9),(3,47,20,10),(6,47,20,13),(6,47,20,14),(6,47,20,15),(6,47,20,16),(0,47,20,35),(5,47,20,37),(5,47,20,38),(5,47,20,39),(5,47,20,40),(5,47,20,41),(3,47,21,7),(3,47,21,8),(3,47,21,10),(6,47,21,15),(6,47,21,16),(5,47,21,37),(5,47,21,38),(5,47,21,39),(5,47,21,40),(3,47,22,7),(3,47,22,8),(3,47,22,9),(6,47,22,15),(5,47,22,38),(5,47,22,39),(5,47,22,40),(5,55,0,0),(5,55,0,1),(5,55,0,2),(14,55,0,13),(5,55,1,0),(5,55,1,1),(5,55,1,2),(2,55,1,8),(4,55,1,10),(5,55,2,0),(5,55,2,2),(4,55,2,10),(4,55,2,11),(4,55,2,12),(5,55,3,0),(5,55,3,1),(5,55,3,2),(5,55,3,3),(4,55,3,10),(4,55,3,11),(4,55,3,12),(4,55,3,13),(5,55,4,1),(5,55,4,2),(4,55,4,10),(4,55,4,11),(4,55,4,12),(4,55,4,13),(5,55,5,2),(5,55,5,3),(4,55,5,10),(4,55,5,11),(4,55,5,12),(4,55,5,13),(4,55,5,14),(4,55,5,15),(4,55,5,16),(4,55,6,7),(4,55,6,8),(4,55,6,9),(4,55,6,10),(4,55,6,11),(4,55,6,12),(4,55,6,13),(0,55,6,14),(4,55,6,16),(4,55,7,7),(4,55,7,9),(4,55,7,11),(4,55,7,12),(4,55,7,13),(4,55,7,16),(4,55,8,8),(4,55,8,9),(4,55,8,10),(4,55,8,11),(4,55,8,14),(4,55,8,15),(4,55,8,16),(4,55,9,12),(4,55,9,13),(4,55,9,14),(12,55,10,2),(4,55,10,10),(4,55,10,11),(4,55,10,12),(4,55,10,13),(4,55,10,14),(0,55,11,11),(4,55,11,13),(4,55,11,14),(6,55,13,14),(6,55,14,13),(6,55,14,14),(6,55,14,16),(6,55,15,12),(6,55,15,13),(6,55,15,14),(6,55,15,15),(6,55,15,16),(3,55,16,0),(3,55,16,1),(3,55,16,2),(3,55,16,3),(3,55,16,4),(0,55,16,14),(6,55,16,16),(3,55,17,0),(3,55,17,2),(8,55,17,4),(3,55,18,1),(3,55,18,2),(3,55,18,3),(5,55,18,8),(3,55,19,0),(3,55,19,1),(3,55,19,2),(3,55,19,3),(5,55,19,8),(8,55,19,14),(3,55,20,0),(3,55,20,1),(3,55,20,3),(3,55,20,4),(5,55,20,7),(5,55,20,8),(5,55,20,9),(4,55,21,0),(3,55,21,1),(3,55,21,2),(3,55,21,3),(3,55,21,4),(3,55,21,5),(5,55,21,7),(5,55,21,8),(5,55,21,9),(0,55,21,10),(4,55,22,0),(3,55,22,1),(3,55,22,2),(3,55,22,3),(3,55,22,4),(5,55,22,7),(5,55,22,8),(5,55,22,9),(4,55,23,0),(4,55,23,1),(4,55,23,2),(4,55,23,3),(5,55,23,7),(5,55,23,8),(5,55,23,9),(5,55,23,10),(4,55,24,0),(11,55,24,1),(5,55,24,8),(4,55,25,0),(9,55,25,11),(4,55,26,0),(4,55,27,0),(4,55,28,0),(4,55,28,1),(4,55,28,2),(4,55,28,3),(4,55,28,4),(4,55,28,5),(4,55,29,0),(4,55,29,1),(4,55,29,2),(4,55,29,3),(11,55,29,8),(4,55,30,0),(4,55,30,1),(4,55,30,3),(0,55,30,4),(4,55,31,0),(4,55,31,1),(3,55,33,15),(3,55,33,16),(4,55,34,7),(3,55,34,14),(3,55,34,15),(3,55,34,16),(4,55,35,5),(4,55,35,6),(4,55,35,7),(4,55,35,8),(3,55,35,13),(3,55,35,14),(3,55,35,15),(13,55,36,3),(4,55,36,5),(4,55,36,6),(4,55,36,7),(4,55,36,8),(3,55,36,10),(3,55,36,11),(3,55,36,12),(3,55,36,13),(3,55,36,14),(3,55,36,15),(3,55,36,16),(4,55,37,5),(4,55,37,6),(4,55,37,7),(3,55,37,11),(3,55,37,12),(3,55,37,13),(3,55,37,14),(3,55,37,16),(4,55,38,5),(4,55,38,6),(4,55,38,7),(3,55,38,12),(3,55,38,14),(3,55,38,16),(4,55,39,5),(4,55,39,6),(4,55,39,7),(4,55,39,8),(3,55,39,16),(4,55,40,5),(4,55,40,6),(4,55,40,7),(3,55,40,16),(4,55,41,5),(4,55,41,6),(3,55,41,16),(4,55,42,6),(3,55,43,13),(3,55,44,1),(3,55,44,3),(3,55,44,6),(3,55,44,10),(3,55,44,12),(3,55,44,13),(3,55,44,14),(3,55,45,0),(3,55,45,1),(3,55,45,2),(3,55,45,3),(3,55,45,4),(3,55,45,5),(3,55,45,6),(3,55,45,7),(3,55,45,10),(3,55,45,13),(3,55,45,15),(3,55,45,16),(3,55,46,0),(3,55,46,1),(3,55,46,2),(3,55,46,3),(3,55,46,4),(3,55,46,5),(3,55,46,9),(3,55,46,10),(3,55,46,11),(3,55,46,12),(3,55,46,13),(3,55,46,14),(3,55,46,15),(3,55,46,16),(3,55,47,0),(3,55,47,1),(3,55,47,2),(6,55,47,3),(3,55,47,4),(3,55,47,5),(3,55,47,6),(3,55,47,11),(3,55,47,12),(3,55,47,13),(6,55,47,14),(3,55,47,16),(3,55,48,0),(6,55,48,1),(6,55,48,2),(6,55,48,3),(3,55,48,4),(3,55,48,6),(3,55,48,11),(3,55,48,12),(3,55,48,13),(6,55,48,14),(6,55,49,0),(6,55,49,1),(6,55,49,2),(6,55,49,3),(6,55,49,4),(6,55,49,5),(3,55,49,11),(6,55,49,12),(6,55,49,13),(6,55,49,14),(6,55,49,15),(5,55,50,0),(5,55,50,1),(5,55,50,2),(5,55,50,3),(3,55,50,11),(6,55,50,15),(6,55,50,16),(5,55,51,0),(5,55,51,1),(5,55,51,2),(5,55,51,3),(5,55,51,4),(6,55,51,8),(6,55,51,16),(5,55,52,0),(1,55,52,1),(5,55,52,4),(6,55,52,7),(6,55,52,8),(6,55,52,9),(6,55,52,16),(5,55,53,0),(5,55,53,3),(5,55,53,4),(6,55,53,6),(6,55,53,7),(6,55,53,8),(5,55,54,0),(5,55,54,1),(6,55,54,6),(6,55,54,7),(6,55,54,8),(0,58,0,0),(5,58,0,3),(5,58,0,4),(5,58,0,5),(5,58,0,6),(5,58,0,7),(5,58,0,8),(5,58,0,9),(5,58,0,10),(5,58,0,11),(5,58,0,12),(5,58,0,13),(5,58,0,14),(5,58,0,26),(5,58,0,27),(5,58,0,28),(5,58,0,29),(5,58,1,3),(11,58,1,4),(5,58,1,11),(5,58,1,12),(5,58,1,13),(13,58,1,16),(4,58,1,19),(4,58,1,20),(4,58,1,21),(4,58,1,22),(5,58,1,26),(5,58,1,27),(5,58,1,28),(5,58,1,29),(5,58,2,2),(5,58,2,3),(5,58,2,10),(5,58,2,12),(5,58,2,13),(5,58,2,14),(5,58,2,15),(4,58,2,20),(4,58,2,21),(4,58,2,22),(4,58,2,23),(5,58,2,27),(5,58,2,28),(5,58,2,29),(0,58,3,1),(5,58,3,10),(5,58,3,11),(5,58,3,12),(5,58,3,13),(5,58,3,14),(4,58,3,20),(4,58,3,21),(4,58,3,22),(4,58,3,23),(4,58,3,24),(5,58,3,28),(5,58,3,29),(5,58,4,12),(5,58,4,13),(6,58,4,18),(4,58,4,21),(4,58,4,22),(4,58,4,23),(5,58,4,26),(5,58,4,27),(5,58,4,28),(6,58,5,8),(6,58,5,9),(6,58,5,18),(6,58,5,19),(4,58,5,22),(4,58,5,23),(4,58,5,24),(5,58,5,26),(5,58,5,27),(6,58,6,7),(6,58,6,8),(6,58,6,9),(6,58,6,11),(6,58,6,18),(6,58,6,19),(6,58,7,9),(6,58,7,10),(6,58,7,18),(12,58,7,23),(6,58,8,9),(6,58,8,10),(6,58,8,16),(6,58,8,17),(6,58,8,18),(3,58,9,3),(3,58,9,4),(6,58,9,9),(6,58,9,15),(6,58,9,16),(6,58,9,17),(3,58,10,0),(3,58,10,2),(3,58,10,3),(3,58,10,4),(8,58,10,5),(6,58,10,16),(6,58,10,17),(0,58,10,20),(3,58,11,0),(3,58,11,1),(3,58,11,2),(3,58,11,3),(3,58,12,0),(3,58,12,1),(3,58,12,2),(3,58,13,0),(3,58,13,1),(3,58,13,2),(3,58,13,4),(3,58,14,0),(3,58,14,1),(3,58,14,2),(3,58,14,3),(3,58,14,4),(3,58,15,0),(3,58,15,1),(3,58,15,2),(3,58,15,3),(3,58,15,4),(3,58,16,0),(3,58,16,1),(3,58,16,2),(3,58,16,3),(5,58,16,29),(3,58,17,0),(3,58,17,1),(3,58,17,2),(3,58,17,3),(3,58,17,4),(5,58,17,28),(5,58,17,29),(3,58,18,0),(3,58,18,1),(3,58,18,2),(3,58,18,3),(3,58,18,4),(3,58,18,5),(0,58,18,23),(5,58,18,28),(5,58,18,29),(3,58,19,0),(3,58,19,1),(3,58,19,2),(3,58,19,3),(3,58,19,4),(3,58,19,5),(5,58,19,29),(3,58,20,0),(3,58,20,1),(3,58,20,2),(3,58,20,3),(3,58,20,4),(3,58,20,5),(5,58,20,28),(5,58,20,29),(3,58,21,0),(3,58,21,1),(3,58,21,2),(3,58,21,3),(3,58,21,4),(5,58,21,29),(3,58,22,0),(3,58,22,1),(3,58,22,2),(14,58,22,25),(5,58,22,29),(3,58,23,0),(3,58,23,1),(3,58,23,2),(3,58,23,3),(4,58,23,9),(5,58,23,29),(3,58,24,1),(3,58,24,2),(0,58,24,4),(4,58,24,7),(4,58,24,8),(4,58,24,9),(4,58,24,10),(4,58,24,11),(5,58,24,29),(4,58,25,7),(4,58,25,8),(4,58,25,9),(4,58,25,10),(5,58,25,27),(5,58,25,29),(4,58,26,6),(4,58,26,7),(4,58,26,8),(4,58,26,9),(4,58,26,10),(2,58,26,12),(6,58,26,22),(6,58,26,23),(5,58,26,27),(5,58,26,28),(5,58,26,29),(4,58,27,5),(4,58,27,6),(4,58,27,7),(4,58,27,8),(4,58,27,9),(4,58,27,10),(5,58,27,17),(5,58,27,18),(5,58,27,21),(5,58,27,22),(6,58,27,23),(6,58,27,24),(0,58,28,4),(4,58,28,6),(4,58,28,7),(4,58,28,8),(4,58,28,9),(4,58,28,10),(5,58,28,15),(5,58,28,16),(5,58,28,17),(5,58,28,18),(5,58,28,19),(5,58,28,21),(5,58,28,22),(6,58,28,23),(6,58,28,24),(5,58,28,25),(5,58,28,26),(5,58,28,27),(5,58,28,28),(4,58,29,7),(4,58,29,8),(4,58,29,9),(4,58,29,10),(4,58,29,11),(5,58,29,16),(5,58,29,17),(5,58,29,18),(5,58,29,19),(5,58,29,20),(5,58,29,21),(5,58,29,22),(6,58,29,23),(6,58,29,24),(6,58,29,25),(6,58,29,26),(5,58,29,27);
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
) ENGINE=InnoDB AUTO_INCREMENT=401 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `units`
--

LOCK TABLES `units` WRITE;
/*!40000 ALTER TABLE `units` DISABLE KEYS */;
INSERT INTO `units` VALUES (1,2500,1,1,1,NULL,NULL,NULL,NULL,0,0,'Demosis',0,1,225,NULL,1,0,0,0),(2,2500,1,1,1,NULL,NULL,NULL,NULL,0,0,'Demosis',0,1,225,NULL,1,0,0,0),(3,1590,1,1,1,NULL,NULL,NULL,NULL,0,0,'Thor',1,1,225,NULL,1,0,0,0),(4,1200,1,1,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,1,225,NULL,1,0,0,0),(5,1200,1,1,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,1,225,NULL,1,0,0,0),(6,1200,1,1,1,NULL,NULL,NULL,NULL,0,0,'Dirac',0,1,225,NULL,1,0,0,0),(7,2500,1,2,1,NULL,NULL,NULL,NULL,0,0,'Demosis',0,1,45,NULL,1,0,0,0),(8,1590,1,2,1,NULL,NULL,NULL,NULL,0,0,'Thor',0,1,45,NULL,1,0,0,0),(9,1200,1,2,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,1,45,NULL,1,0,0,0),(10,1200,1,2,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,1,45,NULL,1,0,0,0),(11,1200,1,2,1,NULL,NULL,NULL,NULL,0,0,'Dirac',0,1,45,NULL,1,0,0,0),(12,140,1,1,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(13,120,1,1,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(14,120,1,2,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(15,120,1,2,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(16,140,1,3,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(17,120,1,3,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(18,140,1,3,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(19,120,1,3,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(20,120,1,3,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(21,140,1,4,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(22,120,1,4,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(23,140,1,4,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(24,120,1,4,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(25,120,1,4,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(26,140,1,5,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(27,140,1,5,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(28,120,1,5,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(29,140,1,5,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(30,120,1,5,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(31,120,1,5,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(32,120,1,6,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(33,140,1,6,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(34,140,1,6,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(35,120,1,6,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(36,120,1,6,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(37,120,1,6,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(38,140,1,7,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(39,120,1,7,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(40,120,1,7,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(41,140,1,8,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(42,140,1,8,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(43,120,1,8,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(44,120,1,8,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(45,140,1,9,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(46,120,1,9,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(47,120,1,9,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(48,120,1,10,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(49,120,1,10,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(50,120,1,11,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(51,120,1,11,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(52,120,1,12,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(53,120,1,12,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(54,120,1,13,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(55,120,1,13,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(56,2500,1,2,1,NULL,NULL,NULL,NULL,0,0,'Demosis',0,3,246,NULL,1,0,0,0),(57,2500,1,2,1,NULL,NULL,NULL,NULL,0,0,'Demosis',0,3,246,NULL,1,0,0,0),(58,1590,1,2,1,NULL,NULL,NULL,NULL,0,0,'Thor',1,3,246,NULL,1,0,0,0),(59,1200,1,2,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,3,246,NULL,1,0,0,0),(60,1200,1,2,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,3,246,NULL,1,0,0,0),(61,1200,1,2,1,NULL,NULL,NULL,NULL,0,0,'Dirac',0,3,246,NULL,1,0,0,0),(62,1590,1,2,1,NULL,NULL,NULL,NULL,0,0,'Thor',0,2,210,NULL,1,0,0,0),(63,1200,1,2,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,2,210,NULL,1,0,0,0),(64,1200,1,2,1,NULL,NULL,NULL,NULL,0,0,'Dirac',0,2,210,NULL,1,0,0,0),(65,120,1,14,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(66,120,1,14,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(67,140,1,15,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(68,120,1,15,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(69,120,1,15,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(70,140,1,16,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(71,120,1,16,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(72,120,1,16,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(73,120,1,17,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(74,140,1,17,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(75,120,1,17,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(76,140,1,17,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(77,120,1,17,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(78,120,1,17,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(79,120,1,18,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(80,140,1,18,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(81,120,1,18,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(82,140,1,18,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(83,120,1,18,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(84,120,1,18,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(85,120,1,18,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(86,120,1,19,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(87,140,1,19,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(88,120,1,19,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(89,140,1,19,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(90,120,1,19,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(91,140,1,19,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(92,120,1,19,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(93,120,1,19,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(94,120,1,20,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(95,140,1,20,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(96,120,1,20,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(97,120,1,20,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(98,140,1,21,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(99,120,1,21,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(100,120,1,21,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(101,120,1,22,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(102,120,1,23,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(103,120,1,23,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(104,120,1,24,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(105,120,1,24,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(106,120,1,25,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(107,120,1,25,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(108,1590,1,2,1,NULL,NULL,NULL,NULL,0,0,'Thor',0,1,135,NULL,1,0,0,0),(109,1590,1,2,1,NULL,NULL,NULL,NULL,0,0,'Thor',1,1,135,NULL,1,0,0,0),(110,1200,1,2,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,1,135,NULL,1,0,0,0),(111,1200,1,2,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,1,135,NULL,1,0,0,0),(112,1200,1,2,1,NULL,NULL,NULL,NULL,0,0,'Dirac',0,1,135,NULL,1,0,0,0),(113,140,1,26,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(114,120,1,26,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(115,120,1,26,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(116,140,1,27,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(117,120,1,27,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(118,120,1,27,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(119,120,1,28,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(120,120,1,28,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(121,140,1,29,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(122,120,1,29,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(123,120,1,29,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(124,120,1,30,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(125,140,1,31,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(126,140,1,31,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(127,120,1,31,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(128,120,1,31,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(129,120,1,32,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(130,120,1,32,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(131,120,1,32,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(132,120,1,32,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(133,120,1,33,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(134,140,1,33,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(135,120,1,33,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(136,140,1,34,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(137,120,1,34,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(138,120,1,34,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(139,120,1,35,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(140,120,1,35,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(141,120,1,36,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(142,120,1,36,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(143,120,1,37,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(144,120,1,37,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(145,120,1,38,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(146,120,1,38,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(147,140,1,39,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(148,120,1,39,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(149,120,1,39,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(150,140,1,40,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(151,120,1,40,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(152,120,1,40,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(153,140,1,41,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(154,120,1,41,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(155,140,1,41,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(156,120,1,41,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(157,120,1,41,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(158,140,1,42,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(159,120,1,42,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(160,140,1,42,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(161,120,1,42,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(162,140,1,42,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(163,120,1,42,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(164,120,1,42,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(165,120,1,43,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(166,120,1,44,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(167,120,1,44,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(168,120,1,45,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(169,120,1,45,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(170,120,1,46,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(171,1590,1,3,1,NULL,NULL,NULL,NULL,0,0,'Thor',1,2,120,NULL,1,0,0,0),(172,1200,1,3,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,2,120,NULL,1,0,0,0),(173,1200,1,3,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,2,120,NULL,1,0,0,0),(174,1200,1,3,1,NULL,NULL,NULL,NULL,0,0,'Dirac',0,2,120,NULL,1,0,0,0),(175,2500,1,3,1,NULL,NULL,NULL,NULL,0,0,'Demosis',0,3,314,NULL,1,0,0,0),(176,2500,1,3,1,NULL,NULL,NULL,NULL,0,0,'Demosis',0,3,314,NULL,1,0,0,0),(177,2500,1,3,1,NULL,NULL,NULL,NULL,0,0,'Demosis',0,3,314,NULL,1,0,0,0),(178,1200,1,3,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,3,314,NULL,1,0,0,0),(179,1200,1,3,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,3,314,NULL,1,0,0,0),(180,1200,1,3,1,NULL,NULL,NULL,NULL,0,0,'Dirac',0,3,314,NULL,1,0,0,0),(181,2500,1,3,1,NULL,NULL,NULL,NULL,0,0,'Demosis',0,1,180,NULL,1,0,0,0),(182,2500,1,3,1,NULL,NULL,NULL,NULL,0,0,'Demosis',0,1,180,NULL,1,0,0,0),(183,1590,1,3,1,NULL,NULL,NULL,NULL,0,0,'Thor',0,1,180,NULL,1,0,0,0),(184,1200,1,3,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,1,180,NULL,1,0,0,0),(185,1200,1,3,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,1,180,NULL,1,0,0,0),(186,1200,1,3,1,NULL,NULL,NULL,NULL,0,0,'Dirac',0,1,180,NULL,1,0,0,0),(187,140,1,47,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(188,120,1,47,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(189,140,1,48,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(190,120,1,48,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(191,120,1,49,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(192,120,1,49,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(193,140,1,50,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(194,120,1,50,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(195,120,1,50,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(196,120,1,51,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(197,140,1,51,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(198,120,1,51,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(199,120,1,51,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(200,120,1,52,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(201,120,1,52,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(202,140,1,52,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(203,120,1,52,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(204,120,1,52,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(205,120,1,53,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(206,120,1,53,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(207,120,1,54,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(208,120,1,54,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(209,1590,1,3,1,NULL,NULL,NULL,NULL,0,0,'Thor',0,2,240,NULL,1,0,0,0),(210,1200,1,3,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,2,240,NULL,1,0,0,0),(211,1200,1,3,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,2,240,NULL,1,0,0,0),(212,1200,1,3,1,NULL,NULL,NULL,NULL,0,0,'Dirac',0,2,240,NULL,1,0,0,0),(213,1590,1,3,1,NULL,NULL,NULL,NULL,0,0,'Thor',1,1,0,NULL,1,0,0,0),(214,1200,1,3,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,1,0,NULL,1,0,0,0),(215,1200,1,3,1,NULL,NULL,NULL,NULL,0,0,'Dirac',0,1,0,NULL,1,0,0,0),(216,1590,1,3,1,NULL,NULL,NULL,NULL,0,0,'Thor',1,2,30,NULL,1,0,0,0),(217,1200,1,3,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,2,30,NULL,1,0,0,0),(218,1200,1,3,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,2,30,NULL,1,0,0,0),(219,1200,1,3,1,NULL,NULL,NULL,NULL,0,0,'Dirac',0,2,30,NULL,1,0,0,0),(220,1590,1,3,1,NULL,NULL,NULL,NULL,0,0,'Thor',1,0,270,NULL,1,0,0,0),(221,1200,1,3,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,0,270,NULL,1,0,0,0),(222,1200,1,3,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,0,270,NULL,1,0,0,0),(223,1200,1,3,1,NULL,NULL,NULL,NULL,0,0,'Dirac',0,0,270,NULL,1,0,0,0),(224,140,1,55,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(225,120,1,55,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(226,120,1,55,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(227,140,1,56,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(228,120,1,56,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(229,120,1,56,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(230,140,1,57,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(231,120,1,57,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(232,120,1,57,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(233,140,1,58,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(234,120,1,58,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(235,120,1,58,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(236,140,1,59,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(237,120,1,59,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(238,120,1,59,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(239,120,1,59,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(240,140,1,60,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(241,120,1,60,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(242,120,1,61,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(243,140,1,61,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(244,120,1,61,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(245,120,1,61,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(246,120,1,62,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(247,120,1,62,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(248,120,1,63,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(249,120,1,64,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(250,120,1,65,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(251,120,1,65,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(252,120,1,66,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(253,120,1,66,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(254,2500,1,3,1,NULL,NULL,NULL,NULL,0,0,'Demosis',0,2,270,NULL,1,0,0,0),(255,1590,1,3,1,NULL,NULL,NULL,NULL,0,0,'Thor',0,2,270,NULL,1,0,0,0),(256,1200,1,3,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,2,270,NULL,1,0,0,0),(257,1200,1,3,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,2,270,NULL,1,0,0,0),(258,1200,1,3,1,NULL,NULL,NULL,NULL,0,0,'Dirac',0,2,270,NULL,1,0,0,0),(259,2500,1,3,1,NULL,NULL,NULL,NULL,0,0,'Demosis',0,0,0,NULL,1,0,0,0),(260,2500,1,3,1,NULL,NULL,NULL,NULL,0,0,'Demosis',0,0,0,NULL,1,0,0,0),(261,2500,1,3,1,NULL,NULL,NULL,NULL,0,0,'Demosis',0,0,0,NULL,1,0,0,0),(262,1590,1,3,1,NULL,NULL,NULL,NULL,0,0,'Thor',1,0,0,NULL,1,0,0,0),(263,1200,1,3,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,0,0,NULL,1,0,0,0),(264,1200,1,3,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,0,0,NULL,1,0,0,0),(265,1200,1,3,1,NULL,NULL,NULL,NULL,0,0,'Dirac',0,0,0,NULL,1,0,0,0),(266,2500,1,4,1,NULL,NULL,NULL,NULL,0,0,'Demosis',0,2,330,NULL,1,0,0,0),(267,1590,1,4,1,NULL,NULL,NULL,NULL,0,0,'Thor',0,2,330,NULL,1,0,0,0),(268,1590,1,4,1,NULL,NULL,NULL,NULL,0,0,'Thor',1,2,330,NULL,1,0,0,0),(269,1200,1,4,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,2,330,NULL,1,0,0,0),(270,1200,1,4,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,2,330,NULL,1,0,0,0),(271,1200,1,4,1,NULL,NULL,NULL,NULL,0,0,'Dirac',0,2,330,NULL,1,0,0,0),(272,140,1,67,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(273,120,1,67,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(274,120,1,67,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(275,120,1,68,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(276,120,1,68,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(277,140,1,69,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(278,140,1,69,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(279,120,1,69,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(280,120,1,69,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(281,140,1,70,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(282,120,1,70,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(283,120,1,70,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(284,140,1,70,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(285,120,1,70,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(286,120,1,70,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(287,140,1,71,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(288,120,1,71,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(289,120,1,72,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(290,120,1,72,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(291,120,1,73,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(292,120,1,73,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(293,120,1,74,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(294,120,1,74,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(295,120,1,75,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(296,1590,1,4,1,NULL,NULL,NULL,NULL,0,0,'Thor',0,3,156,NULL,1,0,0,0),(297,1590,1,4,1,NULL,NULL,NULL,NULL,0,0,'Thor',1,3,156,NULL,1,0,0,0),(298,1200,1,4,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,3,156,NULL,1,0,0,0),(299,1200,1,4,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,3,156,NULL,1,0,0,0),(300,1200,1,4,1,NULL,NULL,NULL,NULL,0,0,'Dirac',0,3,156,NULL,1,0,0,0),(301,140,1,76,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(302,120,1,76,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(303,120,1,76,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(304,140,1,76,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(305,120,1,76,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(306,120,1,76,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(307,120,1,76,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(308,120,1,76,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(309,140,1,77,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(310,120,1,77,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(311,140,1,77,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(312,120,1,77,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(313,120,1,77,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(314,120,1,77,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(315,120,1,77,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(316,120,1,78,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(317,120,1,78,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(318,120,1,78,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(319,120,1,78,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(320,120,1,78,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(321,140,1,79,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(322,120,1,79,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(323,120,1,79,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(324,140,1,79,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(325,120,1,79,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(326,120,1,79,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(327,120,1,79,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(328,120,1,79,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(329,120,1,80,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(330,120,1,80,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(331,120,1,80,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(332,120,1,80,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(333,120,1,80,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(334,120,1,80,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(335,120,1,81,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(336,120,1,81,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(337,120,1,81,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(338,120,1,81,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(339,120,1,81,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(340,120,1,81,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(341,140,1,82,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(342,120,1,82,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(343,120,1,82,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(344,140,1,82,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(345,120,1,82,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(346,120,1,82,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(347,120,1,82,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(348,120,1,82,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(349,120,1,83,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(350,120,1,83,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(351,120,1,83,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(352,120,1,83,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(353,120,1,83,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(354,120,1,83,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(355,120,1,84,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(356,120,1,84,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(357,120,1,84,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(358,120,1,84,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(359,120,1,84,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(360,120,1,84,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(361,140,1,85,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(362,120,1,85,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(363,120,1,85,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(364,140,1,85,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(365,120,1,85,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(366,120,1,85,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(367,120,1,85,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(368,120,1,85,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(369,140,1,86,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(370,120,1,86,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(371,140,1,86,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(372,120,1,86,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(373,120,1,86,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(374,120,1,86,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(375,120,1,86,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(376,120,1,90,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(377,140,1,90,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(378,120,1,90,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(379,120,1,90,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(380,120,1,90,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(381,140,1,90,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(382,120,1,90,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(383,120,1,90,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(384,120,1,90,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(385,120,1,90,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(386,140,1,94,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(387,120,1,94,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(388,120,1,94,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(389,140,1,94,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(390,120,1,94,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(391,120,1,94,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(392,140,1,94,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(393,120,1,94,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(394,140,1,94,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(395,120,1,94,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(396,140,1,94,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(397,120,1,94,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(398,120,1,94,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(399,120,1,94,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(400,120,1,94,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0);
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

-- Dump completed on 2010-12-09 14:14:31
