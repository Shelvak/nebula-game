-- MySQL dump 10.13  Distrib 5.1.49, for debian-linux-gnu (i686)
--
-- Host: localhost    Database: spacegame
-- ------------------------------------------------------
-- Server version	5.1.49-1ubuntu8

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
) ENGINE=InnoDB AUTO_INCREMENT=101 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `buildings`
--

LOCK TABLES `buildings` WRITE;
/*!40000 ALTER TABLE `buildings` DISABLE KEYS */;
INSERT INTO `buildings` VALUES (1,3,31,17,0,0,0,1,'NpcMetalExtractor',NULL,32,18,NULL,1,400,NULL,0,NULL,NULL,0),(2,3,25,26,0,0,0,1,'NpcMetalExtractor',NULL,26,27,NULL,1,400,NULL,0,NULL,NULL,0),(3,3,30,21,0,0,0,1,'NpcMetalExtractor',NULL,31,22,NULL,1,400,NULL,0,NULL,NULL,0),(4,3,10,22,0,0,0,1,'NpcMetalExtractor',NULL,11,23,NULL,1,400,NULL,0,NULL,NULL,0),(5,3,20,20,0,0,0,1,'NpcResearchCenter',NULL,23,23,NULL,1,4000,NULL,0,NULL,NULL,0),(6,3,33,21,0,0,0,1,'NpcCommunicationsHub',NULL,35,22,NULL,1,1200,NULL,0,NULL,NULL,0),(7,3,0,21,0,0,0,1,'NpcTemple',NULL,2,23,NULL,1,1500,NULL,0,NULL,NULL,0),(8,3,33,23,0,0,0,1,'NpcCommunicationsHub',NULL,35,24,NULL,1,1200,NULL,0,NULL,NULL,0),(9,3,0,27,0,0,0,1,'NpcSolarPlant',NULL,1,28,NULL,1,1000,NULL,0,NULL,NULL,0),(10,3,0,25,0,0,0,1,'NpcSolarPlant',NULL,1,26,NULL,1,1000,NULL,0,NULL,NULL,0),(11,3,7,23,0,0,0,1,'NpcSolarPlant',NULL,8,24,NULL,1,1000,NULL,0,NULL,NULL,0),(12,3,7,20,0,0,0,1,'NpcSolarPlant',NULL,8,21,NULL,1,1000,NULL,0,NULL,NULL,0),(13,9,11,17,0,0,0,1,'NpcMetalExtractor',NULL,12,18,NULL,1,400,NULL,0,NULL,NULL,0),(14,9,2,30,0,0,0,1,'NpcMetalExtractor',NULL,3,31,NULL,1,400,NULL,0,NULL,NULL,0),(15,9,7,31,0,0,0,1,'NpcMetalExtractor',NULL,8,32,NULL,1,400,NULL,0,NULL,NULL,0),(16,9,13,30,0,0,0,1,'NpcMetalExtractor',NULL,14,31,NULL,1,400,NULL,0,NULL,NULL,0),(17,9,6,21,0,0,0,1,'NpcMetalExtractor',NULL,7,22,NULL,1,400,NULL,0,NULL,NULL,0),(18,9,16,21,0,0,0,1,'NpcTemple',NULL,18,23,NULL,1,1500,NULL,0,NULL,NULL,0),(19,9,16,28,0,0,0,1,'NpcCommunicationsHub',NULL,18,29,NULL,1,1200,NULL,0,NULL,NULL,0),(20,9,23,27,0,0,0,1,'NpcSolarPlant',NULL,24,28,NULL,1,1000,NULL,0,NULL,NULL,0),(21,9,10,32,0,0,0,1,'NpcSolarPlant',NULL,11,33,NULL,1,1000,NULL,0,NULL,NULL,0),(22,9,10,29,0,0,0,1,'NpcSolarPlant',NULL,11,30,NULL,1,1000,NULL,0,NULL,NULL,0),(23,19,20,27,0,0,0,1,'NpcMetalExtractor',NULL,21,28,NULL,1,400,NULL,0,NULL,NULL,0),(24,19,1,28,0,0,0,1,'NpcMetalExtractor',NULL,2,29,NULL,1,400,NULL,0,NULL,NULL,0),(25,19,16,27,0,0,0,1,'NpcMetalExtractor',NULL,17,28,NULL,1,400,NULL,0,NULL,NULL,0),(26,19,7,27,0,0,0,1,'NpcMetalExtractor',NULL,8,28,NULL,1,400,NULL,0,NULL,NULL,0),(27,19,11,27,0,0,0,1,'NpcMetalExtractor',NULL,12,28,NULL,1,400,NULL,0,NULL,NULL,0),(28,19,16,11,0,0,0,1,'NpcMetalExtractor',NULL,17,12,NULL,1,400,NULL,0,NULL,NULL,0),(29,19,16,5,0,0,0,1,'NpcMetalExtractor',NULL,17,6,NULL,1,400,NULL,0,NULL,NULL,0),(30,19,17,8,0,0,0,1,'NpcSolarPlant',NULL,18,9,NULL,1,1000,NULL,0,NULL,NULL,0),(31,19,15,8,0,0,0,1,'NpcSolarPlant',NULL,16,9,NULL,1,1000,NULL,0,NULL,NULL,0),(32,19,19,0,0,0,0,1,'NpcSolarPlant',NULL,20,1,NULL,1,1000,NULL,0,NULL,NULL,0),(33,19,19,2,0,0,0,1,'NpcSolarPlant',NULL,20,3,NULL,1,1000,NULL,0,NULL,NULL,0),(34,29,8,3,0,0,0,1,'NpcMetalExtractor',NULL,9,4,NULL,1,400,NULL,0,NULL,NULL,0),(35,29,1,12,0,0,0,1,'NpcMetalExtractor',NULL,2,13,NULL,1,400,NULL,0,NULL,NULL,0),(36,29,8,20,0,0,0,1,'NpcResearchCenter',NULL,11,23,NULL,1,4000,NULL,0,NULL,NULL,0),(37,29,0,20,0,0,0,1,'NpcCommunicationsHub',NULL,2,21,NULL,1,1200,NULL,0,NULL,NULL,0),(38,29,8,24,0,0,0,1,'NpcExcavationSite',NULL,11,27,NULL,1,2000,NULL,0,NULL,NULL,0),(39,29,0,26,0,0,0,1,'NpcTemple',NULL,2,28,NULL,1,1500,NULL,0,NULL,NULL,0),(40,29,8,0,0,0,0,1,'NpcCommunicationsHub',NULL,10,1,NULL,1,1200,NULL,0,NULL,NULL,0),(41,29,6,20,0,0,0,1,'NpcSolarPlant',NULL,7,21,NULL,1,1000,NULL,0,NULL,NULL,0),(42,29,3,20,0,0,0,1,'NpcSolarPlant',NULL,4,21,NULL,1,1000,NULL,0,NULL,NULL,0),(43,29,4,23,0,0,0,1,'NpcSolarPlant',NULL,5,24,NULL,1,1000,NULL,0,NULL,NULL,0),(44,29,6,23,0,0,0,1,'NpcSolarPlant',NULL,7,24,NULL,1,1000,NULL,0,NULL,NULL,0),(45,37,6,4,0,0,0,1,'NpcMetalExtractor',NULL,7,5,NULL,1,400,NULL,0,NULL,NULL,0),(46,37,2,11,0,0,0,1,'NpcMetalExtractor',NULL,3,12,NULL,1,400,NULL,0,NULL,NULL,0),(47,37,2,3,0,0,0,1,'NpcMetalExtractor',NULL,3,4,NULL,1,400,NULL,0,NULL,NULL,0),(48,37,1,7,0,0,0,1,'NpcMetalExtractor',NULL,2,8,NULL,1,400,NULL,0,NULL,NULL,0),(49,37,1,26,0,0,0,1,'NpcMetalExtractor',NULL,2,27,NULL,1,400,NULL,0,NULL,NULL,0),(50,37,1,15,0,0,0,1,'NpcMetalExtractor',NULL,2,16,NULL,1,400,NULL,0,NULL,NULL,0),(51,37,1,33,0,0,0,1,'NpcTemple',NULL,3,35,NULL,1,1500,NULL,0,NULL,NULL,0),(52,37,1,40,0,0,0,1,'NpcCommunicationsHub',NULL,3,41,NULL,1,1200,NULL,0,NULL,NULL,0),(53,37,0,23,0,0,0,1,'NpcSolarPlant',NULL,1,24,NULL,1,1000,NULL,0,NULL,NULL,0),(54,37,2,23,0,0,0,1,'NpcSolarPlant',NULL,3,24,NULL,1,1000,NULL,0,NULL,NULL,0),(55,37,0,0,0,0,0,1,'NpcSolarPlant',NULL,1,1,NULL,1,1000,NULL,0,NULL,NULL,0),(56,42,19,28,0,0,0,1,'NpcMetalExtractor',NULL,20,29,NULL,1,400,NULL,0,NULL,NULL,0),(57,42,10,32,0,0,0,1,'NpcMetalExtractor',NULL,11,33,NULL,1,400,NULL,0,NULL,NULL,0),(58,42,4,32,0,0,0,1,'NpcMetalExtractor',NULL,5,33,NULL,1,400,NULL,0,NULL,NULL,0),(59,42,16,32,0,0,0,1,'NpcMetalExtractor',NULL,17,33,NULL,1,400,NULL,0,NULL,NULL,0),(60,42,14,28,0,0,0,1,'NpcMetalExtractor',NULL,15,29,NULL,1,400,NULL,0,NULL,NULL,0),(61,42,14,19,0,0,0,1,'NpcZetiumExtractor',NULL,15,20,NULL,1,800,NULL,0,NULL,NULL,0),(62,42,10,27,0,0,0,1,'NpcTemple',NULL,12,29,NULL,1,1500,NULL,0,NULL,NULL,0),(63,42,13,32,0,0,0,1,'NpcSolarPlant',NULL,14,33,NULL,1,1000,NULL,0,NULL,NULL,0),(64,42,7,33,0,0,0,1,'NpcSolarPlant',NULL,8,34,NULL,1,1000,NULL,0,NULL,NULL,0),(65,42,7,31,0,0,0,1,'NpcSolarPlant',NULL,8,32,NULL,1,1000,NULL,0,NULL,NULL,0),(66,42,0,27,0,0,0,1,'NpcSolarPlant',NULL,1,28,NULL,1,1000,NULL,0,NULL,NULL,0),(67,48,8,2,0,0,0,1,'NpcMetalExtractor',NULL,9,3,NULL,1,400,NULL,0,NULL,NULL,0),(68,48,4,3,0,0,0,1,'NpcMetalExtractor',NULL,5,4,NULL,1,400,NULL,0,NULL,NULL,0),(69,48,18,3,0,0,0,1,'NpcMetalExtractor',NULL,19,4,NULL,1,400,NULL,0,NULL,NULL,0),(70,48,13,5,0,0,0,1,'NpcMetalExtractor',NULL,14,6,NULL,1,400,NULL,0,NULL,NULL,0),(71,48,14,12,0,0,0,1,'NpcMetalExtractor',NULL,15,13,NULL,1,400,NULL,0,NULL,NULL,0),(72,48,21,13,0,0,0,1,'NpcZetiumExtractor',NULL,22,14,NULL,1,800,NULL,0,NULL,NULL,0),(73,48,21,8,0,0,0,1,'NpcTemple',NULL,23,10,NULL,1,1500,NULL,0,NULL,NULL,0),(74,48,21,16,0,0,0,1,'NpcCommunicationsHub',NULL,23,17,NULL,1,1200,NULL,0,NULL,NULL,0),(75,48,5,0,0,0,0,1,'NpcSolarPlant',NULL,6,1,NULL,1,1000,NULL,0,NULL,NULL,0),(76,48,5,8,0,0,0,1,'NpcSolarPlant',NULL,6,9,NULL,1,1000,NULL,0,NULL,NULL,0),(77,48,5,6,0,0,0,1,'NpcSolarPlant',NULL,6,7,NULL,1,1000,NULL,0,NULL,NULL,0),(78,48,22,6,0,0,0,1,'NpcSolarPlant',NULL,23,7,NULL,1,1000,NULL,0,NULL,NULL,0),(79,49,7,9,0,0,0,1,'Vulcan',NULL,8,10,NULL,1,300,NULL,0,NULL,NULL,0),(80,49,14,9,0,0,0,1,'Thunder',NULL,15,10,NULL,1,300,NULL,0,NULL,NULL,0),(81,49,21,9,0,0,0,1,'Screamer',NULL,22,10,NULL,1,300,NULL,0,NULL,NULL,0),(82,49,11,14,0,0,0,1,'Mothership',NULL,18,19,NULL,1,10500,NULL,0,NULL,NULL,0),(83,49,7,16,0,0,0,1,'Thunder',NULL,8,17,NULL,1,300,NULL,0,NULL,NULL,0),(84,49,21,16,0,0,0,1,'Thunder',NULL,22,17,NULL,1,300,NULL,0,NULL,NULL,0),(85,49,26,16,0,0,0,1,'NpcZetiumExtractor',NULL,27,17,NULL,1,800,NULL,0,NULL,NULL,0),(86,49,25,20,0,0,0,1,'NpcTemple',NULL,27,22,NULL,1,1500,NULL,0,NULL,NULL,0),(87,49,7,22,0,0,0,1,'Screamer',NULL,8,23,NULL,1,300,NULL,0,NULL,NULL,0),(88,49,14,22,0,0,0,1,'Thunder',NULL,15,23,NULL,1,300,NULL,0,NULL,NULL,0),(89,49,21,22,0,0,0,1,'Vulcan',NULL,22,23,NULL,1,300,NULL,0,NULL,NULL,0),(90,49,24,24,0,0,0,1,'NpcMetalExtractor',NULL,25,25,NULL,1,400,NULL,0,NULL,NULL,0),(91,49,28,24,0,0,0,1,'NpcMetalExtractor',NULL,29,25,NULL,1,400,NULL,0,NULL,NULL,0),(92,49,18,25,0,0,0,1,'NpcSolarPlant',NULL,19,26,NULL,1,1000,NULL,0,NULL,NULL,0),(93,49,15,26,0,0,0,1,'NpcSolarPlant',NULL,16,27,NULL,1,1000,NULL,0,NULL,NULL,0),(94,49,3,27,0,0,0,1,'NpcMetalExtractor',NULL,4,28,NULL,1,400,NULL,0,NULL,NULL,0),(95,49,12,27,0,0,0,1,'NpcSolarPlant',NULL,13,28,NULL,1,1000,NULL,0,NULL,NULL,0),(96,49,22,27,0,0,0,1,'NpcSolarPlant',NULL,23,28,NULL,1,1000,NULL,0,NULL,NULL,0),(97,49,26,27,0,0,0,1,'NpcCommunicationsHub',NULL,28,28,NULL,1,1200,NULL,0,NULL,NULL,0),(98,49,0,28,0,0,0,1,'NpcMetalExtractor',NULL,1,29,NULL,1,400,NULL,0,NULL,NULL,0),(99,49,7,28,0,0,0,1,'NpcCommunicationsHub',NULL,9,29,NULL,1,1200,NULL,0,NULL,NULL,0),(100,49,18,28,0,0,0,1,'NpcSolarPlant',NULL,19,29,NULL,1,1000,NULL,0,NULL,NULL,0);
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
INSERT INTO `folliages` VALUES (3,0,7,4),(3,0,9,7),(3,0,11,4),(3,1,3,0),(3,1,8,5),(3,1,10,8),(3,1,18,11),(3,2,1,9),(3,2,8,11),(3,2,28,4),(3,3,6,10),(3,3,9,10),(3,3,10,6),(3,3,13,0),(3,4,0,13),(3,4,7,9),(3,4,9,12),(3,4,10,0),(3,4,14,7),(3,4,20,7),(3,4,24,0),(3,5,9,9),(3,6,19,7),(3,6,20,10),(3,7,18,3),(3,9,5,11),(3,9,12,8),(3,10,3,10),(3,10,12,4),(3,10,21,9),(3,10,24,5),(3,11,8,3),(3,11,24,13),(3,12,0,4),(3,12,5,2),(3,12,7,1),(3,12,12,10),(3,12,22,4),(3,13,0,11),(3,13,3,9),(3,14,1,6),(3,14,9,6),(3,15,3,3),(3,15,5,9),(3,16,0,2),(3,16,9,9),(3,16,13,4),(3,17,1,5),(3,17,6,4),(3,18,1,4),(3,18,4,9),(3,18,5,4),(3,18,12,3),(3,19,1,10),(3,19,22,10),(3,19,26,0),(3,19,27,10),(3,19,28,8),(3,20,0,0),(3,20,5,11),(3,20,6,10),(3,20,11,3),(3,20,26,6),(3,20,28,0),(3,21,18,4),(3,22,1,5),(3,22,2,1),(3,22,13,6),(3,22,19,4),(3,22,25,8),(3,23,1,9),(3,23,7,3),(3,23,17,4),(3,23,19,8),(3,23,25,3),(3,24,0,0),(3,24,10,9),(3,24,15,7),(3,24,19,4),(3,24,28,9),(3,25,3,3),(3,25,7,8),(3,25,9,2),(3,25,10,9),(3,25,11,3),(3,25,12,9),(3,25,14,0),(3,26,5,9),(3,26,9,2),(3,26,12,3),(3,26,18,13),(3,26,24,1),(3,27,3,10),(3,27,6,1),(3,27,8,5),(3,27,11,11),(3,28,6,5),(3,28,12,9),(3,28,14,0),(3,28,20,0),(3,28,22,9),(3,29,2,1),(3,29,12,13),(3,29,17,13),(3,30,9,0),(3,30,20,9),(3,31,0,8),(3,32,0,0),(3,33,2,11),(3,33,8,5),(3,33,18,9),(3,34,8,0),(3,35,0,5),(3,35,4,13),(3,35,9,6),(3,35,20,7),(9,0,6,10),(9,0,14,10),(9,0,22,11),(9,0,33,10),(9,1,0,1),(9,1,1,10),(9,1,13,10),(9,1,29,12),(9,1,31,6),(9,2,2,12),(9,2,3,1),(9,2,14,3),(9,2,16,5),(9,2,21,10),(9,2,23,1),(9,2,26,8),(9,2,29,6),(9,3,3,7),(9,3,16,2),(9,3,19,0),(9,3,22,1),(9,3,28,11),(9,3,32,12),(9,3,33,0),(9,4,4,11),(9,4,10,5),(9,4,23,1),(9,4,24,7),(9,4,29,4),(9,4,30,5),(9,4,31,2),(9,4,32,8),(9,5,7,7),(9,5,10,10),(9,5,17,4),(9,5,24,0),(9,5,28,9),(9,5,33,0),(9,6,9,7),(9,6,16,4),(9,6,17,10),(9,6,19,6),(9,6,29,4),(9,6,33,7),(9,7,18,7),(9,7,19,1),(9,7,20,3),(9,7,33,2),(9,8,12,12),(9,8,17,1),(9,8,25,7),(9,8,29,11),(9,9,2,8),(9,9,10,3),(9,9,13,1),(9,9,22,11),(9,9,25,0),(9,9,26,0),(9,9,27,13),(9,9,29,11),(9,10,15,9),(9,11,9,0),(9,11,15,4),(9,12,0,8),(9,12,4,10),(9,12,6,5),(9,12,10,7),(9,12,11,2),(9,12,12,1),(9,12,13,3),(9,12,29,3),(9,13,3,4),(9,13,10,5),(9,13,24,3),(9,13,27,6),(9,13,33,12),(9,14,6,12),(9,14,8,4),(9,14,14,3),(9,14,16,7),(9,14,27,7),(9,14,28,6),(9,15,5,9),(9,15,14,6),(9,15,21,9),(9,16,0,4),(9,16,4,4),(9,16,14,7),(9,16,17,4),(9,17,1,7),(9,17,6,7),(9,17,16,8),(9,17,20,5),(9,17,27,10),(9,18,2,4),(9,18,13,10),(9,18,17,8),(9,18,19,3),(9,18,24,8),(9,18,25,9),(9,19,0,7),(9,19,26,0),(9,19,27,0),(9,19,28,2),(9,20,26,13),(9,20,27,5),(9,20,28,3),(9,21,28,3),(9,23,8,2),(9,23,21,3),(9,23,29,9),(19,0,1,4),(19,0,3,6),(19,0,15,0),(19,1,5,1),(19,1,13,0),(19,1,17,4),(19,2,6,11),(19,2,9,3),(19,2,30,11),(19,3,4,10),(19,3,7,11),(19,3,14,1),(19,4,2,11),(19,4,5,5),(19,4,7,1),(19,4,10,2),(19,4,13,4),(19,4,14,9),(19,5,13,0),(19,5,27,13),(19,5,28,1),(19,6,4,3),(19,6,16,1),(19,6,24,2),(19,6,25,1),(19,6,28,2),(19,6,30,11),(19,7,4,0),(19,7,5,2),(19,7,6,10),(19,7,21,1),(19,7,23,7),(19,7,25,2),(19,7,26,2),(19,8,10,5),(19,8,17,10),(19,8,19,8),(19,8,26,10),(19,9,1,6),(19,9,2,2),(19,9,7,4),(19,9,16,13),(19,9,27,1),(19,9,29,7),(19,10,4,4),(19,10,5,0),(19,10,6,1),(19,10,7,0),(19,10,18,10),(19,10,20,7),(19,10,21,5),(19,10,25,6),(19,10,26,4),(19,10,27,4),(19,11,0,4),(19,11,7,2),(19,11,15,0),(19,12,1,10),(19,12,2,8),(19,12,3,8),(19,12,4,13),(19,13,0,5),(19,13,3,2),(19,13,7,9),(19,14,1,1),(19,14,2,0),(19,14,10,8),(19,14,14,5),(19,15,3,2),(19,15,11,0),(19,16,0,3),(19,16,10,0),(19,16,13,3),(19,16,14,3),(19,17,3,6),(19,17,4,5),(19,17,14,4),(19,17,26,8),(19,17,30,3),(19,18,10,4),(19,18,14,5),(19,18,15,3),(19,18,16,8),(19,19,11,5),(19,19,23,1),(19,19,24,8),(19,20,15,0),(19,20,24,3),(19,21,1,10),(19,21,11,10),(19,21,17,0),(19,21,18,9),(19,21,25,10),(19,22,3,12),(19,22,17,1),(19,22,18,11),(19,22,20,10),(19,23,0,6),(19,23,15,1),(19,23,18,8),(19,23,29,11),(19,24,16,3),(19,24,17,3),(19,24,22,5),(19,24,28,2),(19,24,29,4),(19,24,30,3),(29,0,6,0),(29,0,10,11),(29,0,11,3),(29,0,23,7),(29,1,0,0),(29,1,10,11),(29,1,19,0),(29,1,25,0),(29,2,10,10),(29,2,25,0),(29,3,8,3),(29,3,10,6),(29,3,25,8),(29,3,27,1),(29,4,1,2),(29,4,18,8),(29,4,19,11),(29,4,27,8),(29,5,22,9),(29,5,28,7),(29,6,22,3),(29,7,19,10),(29,7,22,8),(29,7,28,2),(29,8,2,6),(29,8,28,0),(29,9,28,10),(29,11,4,11),(29,11,19,7),(29,12,7,4),(29,12,14,6),(29,12,15,11),(29,12,20,10),(29,12,22,3),(29,13,7,4),(29,13,8,1),(29,13,10,11),(29,13,14,1),(29,13,15,1),(29,13,17,4),(29,13,22,9),(29,13,28,12),(29,14,9,8),(29,14,18,5),(29,15,18,8),(29,15,20,8),(29,16,7,9),(29,16,8,1),(29,16,15,10),(29,16,17,8),(29,16,18,0),(29,17,6,13),(29,17,10,7),(29,17,12,6),(29,17,28,7),(29,18,0,6),(29,18,3,10),(29,18,4,9),(29,18,15,3),(29,18,16,12),(29,18,25,8),(29,19,11,2),(29,19,13,10),(29,19,27,7),(29,20,11,13),(29,20,12,1),(29,20,16,3),(29,20,18,13),(29,20,25,6),(29,21,9,7),(29,21,13,9),(29,21,17,3),(29,21,21,9),(29,21,26,3),(29,22,8,1),(29,23,5,11),(29,23,8,1),(29,23,13,4),(29,23,14,10),(29,23,17,8),(29,23,25,1),(29,24,2,0),(29,24,3,4),(29,24,5,4),(29,24,6,7),(29,24,12,3),(29,24,13,7),(29,25,8,9),(29,25,11,5),(29,25,15,9),(29,25,17,8),(29,25,20,2),(29,26,6,8),(29,26,7,7),(29,26,10,8),(29,26,12,2),(29,26,25,5),(29,26,28,12),(29,27,7,10),(29,27,20,0),(29,27,25,5),(29,27,28,8),(29,28,7,13),(29,28,10,3),(29,28,13,3),(29,28,21,1),(29,28,26,10),(29,29,5,6),(29,29,10,9),(29,29,19,11),(29,29,22,6),(29,29,27,11),(29,30,0,9),(29,30,11,3),(29,30,15,2),(29,30,20,11),(29,30,26,6),(29,30,28,8),(29,31,10,7),(29,31,17,4),(29,31,23,2),(29,32,23,6),(29,33,1,3),(29,33,2,3),(29,33,11,7),(29,33,13,13),(29,33,28,7),(29,34,10,6),(29,34,12,9),(29,34,26,9),(29,35,1,10),(29,35,8,3),(29,35,9,1),(29,35,17,7),(29,36,7,3),(29,36,19,11),(29,37,0,3),(29,37,1,4),(29,37,2,4),(29,37,17,4),(29,37,18,12),(29,38,0,10),(29,38,15,5),(29,38,18,5),(29,39,0,8),(29,39,1,1),(29,39,4,3),(29,39,5,8),(29,39,6,13),(29,39,17,3),(37,0,4,4),(37,0,11,2),(37,0,14,7),(37,0,16,6),(37,0,19,8),(37,0,22,13),(37,0,34,9),(37,1,2,11),(37,1,4,8),(37,1,20,3),(37,1,21,6),(37,1,39,11),(37,2,1,3),(37,2,2,8),(37,2,13,9),(37,2,39,7),(37,3,0,8),(37,3,2,12),(37,3,5,4),(37,3,14,7),(37,3,16,3),(37,3,17,5),(37,3,19,6),(37,3,25,1),(37,3,36,13),(37,3,37,2),(37,4,3,2),(37,4,7,2),(37,4,8,0),(37,4,10,8),(37,4,11,4),(37,4,12,9),(37,4,14,2),(37,4,21,3),(37,4,24,6),(37,4,26,8),(37,4,38,6),(37,4,41,9),(37,5,0,7),(37,5,1,7),(37,5,5,1),(37,5,6,11),(37,5,8,10),(37,5,20,0),(37,5,21,4),(37,5,22,9),(37,5,23,2),(37,5,24,8),(37,5,25,7),(37,5,39,9),(37,6,40,6),(37,6,41,1),(37,7,2,10),(37,8,6,5),(37,8,26,6),(37,8,27,9),(37,9,3,0),(37,9,9,13),(37,9,10,6),(37,9,26,12),(37,9,38,11),(37,10,8,0),(37,10,27,1),(37,10,28,5),(37,10,34,9),(37,10,37,0),(37,11,0,1),(37,11,5,4),(37,11,11,11),(37,11,23,6),(37,11,25,4),(37,11,27,11),(37,11,31,3),(37,11,33,3),(37,11,40,10),(37,11,41,10),(37,12,2,1),(37,12,6,2),(37,12,10,6),(37,12,11,8),(37,12,21,4),(37,12,26,0),(37,12,32,2),(37,12,35,5),(37,13,0,0),(37,13,5,13),(37,13,10,0),(37,13,11,5),(37,13,14,6),(37,13,16,10),(37,13,40,3),(37,14,0,10),(37,14,5,6),(37,14,10,3),(37,14,12,2),(37,14,13,9),(37,14,31,13),(37,14,33,2),(37,14,37,5),(37,15,4,8),(37,15,5,9),(37,15,19,3),(37,15,37,12),(37,15,39,3),(37,16,0,13),(37,16,6,10),(37,16,12,6),(37,16,18,1),(37,16,34,12),(37,16,35,4),(37,16,36,0),(37,17,0,6),(37,17,1,7),(37,17,6,13),(37,17,11,4),(37,17,18,5),(37,17,20,1),(37,17,29,5),(37,17,41,1),(37,18,2,9),(37,18,11,10),(37,18,14,6),(37,18,15,7),(37,18,20,5),(37,18,27,2),(37,18,33,9),(37,18,40,7),(37,18,41,4),(37,19,2,10),(37,19,6,5),(37,19,11,2),(37,19,12,13),(37,19,14,2),(37,19,15,10),(37,19,20,5),(37,19,23,0),(37,19,41,8),(37,20,14,1),(37,20,15,2),(37,20,18,11),(37,20,23,13),(37,20,27,4),(37,20,32,9),(37,20,41,1),(42,0,1,12),(42,0,4,10),(42,0,5,5),(42,0,29,0),(42,1,1,2),(42,1,14,8),(42,1,20,4),(42,2,5,3),(42,2,27,5),(42,2,29,2),(42,2,30,3),(42,3,30,8),(42,3,32,2),(42,3,33,3),(42,3,34,13),(42,4,20,4),(42,4,24,9),(42,5,1,0),(42,5,13,6),(42,5,34,6),(42,6,0,9),(42,6,1,5),(42,7,4,10),(42,7,8,8),(42,8,2,12),(42,8,4,10),(42,8,13,3),(42,9,9,11),(42,9,10,3),(42,9,19,2),(42,9,25,2),(42,9,29,3),(42,10,0,7),(42,11,7,0),(42,11,9,11),(42,11,12,1),(42,11,15,12),(42,11,30,1),(42,11,34,10),(42,12,0,3),(42,12,3,5),(42,12,6,6),(42,12,14,6),(42,12,19,1),(42,12,32,0),(42,13,1,13),(42,13,18,0),(42,13,19,9),(42,13,27,10),(42,13,28,6),(42,13,30,1),(42,14,6,10),(42,14,30,6),(42,14,34,10),(42,15,31,7),(42,16,27,0),(42,16,31,9),(42,16,34,4),(42,18,11,12),(42,18,12,3),(42,18,30,2),(42,18,31,2),(42,19,9,3),(42,19,11,1),(42,19,31,13),(42,19,33,5),(42,21,12,10),(42,21,16,8),(42,22,9,8),(42,22,13,1),(42,22,26,7),(42,22,28,11),(48,0,10,9),(48,0,16,11),(48,0,18,12),(48,0,25,9),(48,0,32,3),(48,0,37,1),(48,1,21,11),(48,1,29,10),(48,1,36,1),(48,1,37,6),(48,2,11,9),(48,2,36,1),(48,3,35,4),(48,4,18,1),(48,4,19,8),(48,4,26,6),(48,4,36,1),(48,4,37,1),(48,5,20,1),(48,5,22,4),(48,5,26,4),(48,5,27,1),(48,5,36,5),(48,6,2,10),(48,6,3,2),(48,6,18,3),(48,6,19,10),(48,6,27,10),(48,6,31,10),(48,6,35,9),(48,7,0,6),(48,7,11,5),(48,7,12,12),(48,7,13,7),(48,7,20,10),(48,7,26,5),(48,7,35,10),(48,8,0,0),(48,8,20,11),(48,8,22,4),(48,8,24,10),(48,9,21,11),(48,9,22,1),(48,9,23,10),(48,10,0,6),(48,10,12,2),(48,10,21,2),(48,10,23,6),(48,11,2,12),(48,11,7,10),(48,11,21,8),(48,11,26,10),(48,11,27,2),(48,11,31,3),(48,12,2,7),(48,12,12,2),(48,12,13,8),(48,12,18,3),(48,12,24,0),(48,12,26,8),(48,13,0,5),(48,13,10,8),(48,13,12,13),(48,13,22,8),(48,13,23,3),(48,13,28,6),(48,14,7,6),(48,14,18,6),(48,14,20,10),(48,15,0,11),(48,15,10,5),(48,15,14,9),(48,15,25,11),(48,16,0,11),(48,16,13,5),(48,16,15,11),(48,16,19,6),(48,17,9,3),(48,17,11,13),(48,17,15,3),(48,17,21,1),(48,18,1,3),(48,18,10,1),(48,18,11,9),(48,18,17,5),(48,18,18,6),(48,19,6,12),(48,19,23,4),(48,20,9,7),(48,21,34,5),(48,22,5,6),(48,22,27,8),(48,22,35,3),(48,23,0,12),(48,23,33,8),(48,23,36,8),(48,23,37,3),(49,0,13,9),(49,0,14,8),(49,1,15,10),(49,1,27,4),(49,2,10,7),(49,3,3,2),(49,3,26,2),(49,4,9,11),(49,4,19,11),(49,5,8,5),(49,6,2,4),(49,6,6,2),(49,6,9,3),(49,6,17,9),(49,6,19,5),(49,6,23,12),(49,6,27,7),(49,6,28,3),(49,7,12,6),(49,7,15,10),(49,7,18,0),(49,7,21,4),(49,7,24,6),(49,8,24,7),(49,8,27,0),(49,9,18,10),(49,9,19,12),(49,9,27,9),(49,10,0,7),(49,10,10,4),(49,10,16,9),(49,10,17,8),(49,10,19,11),(49,11,10,6),(49,11,11,3),(49,11,21,11),(49,12,9,4),(49,12,20,9),(49,12,26,8),(49,13,13,9),(49,14,1,7),(49,14,2,6),(49,15,2,1),(49,15,4,5),(49,15,5,6),(49,15,12,7),(49,16,8,0),(49,16,13,5),(49,17,5,9),(49,17,20,4),(49,17,22,2),(49,18,2,8),(49,18,10,4),(49,18,12,9),(49,18,21,8),(49,19,1,5),(49,19,2,2),(49,19,3,9),(49,19,8,1),(49,19,9,3),(49,19,12,5),(49,19,16,1),(49,19,17,3),(49,19,18,8),(49,20,6,8),(49,20,13,4),(49,20,14,3),(49,20,16,0),(49,20,19,1),(49,20,20,11),(49,21,3,4),(49,21,4,2),(49,21,5,10),(49,21,6,10),(49,21,11,7),(49,21,19,4),(49,21,20,3),(49,21,21,10),(49,21,24,11),(49,22,14,2),(49,22,15,11),(49,22,18,0),(49,22,19,8),(49,22,24,12),(49,22,25,10),(49,22,26,2),(49,23,7,11),(49,23,8,11),(49,24,7,1),(49,24,8,10),(49,24,17,9),(49,24,23,7),(49,24,29,5),(49,25,7,6),(49,25,9,13),(49,25,13,11),(49,25,16,13),(49,26,3,12),(49,26,4,3),(49,26,5,10),(49,26,10,6),(49,26,11,8),(49,26,14,0),(49,26,29,2),(49,27,1,10),(49,27,2,8),(49,27,9,0),(49,27,10,4),(49,27,18,0),(49,27,25,2),(49,27,26,9),(49,28,15,5),(49,28,18,10),(49,29,17,0),(49,29,23,2);
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
INSERT INTO `galaxies` VALUES (1,'2010-11-04 14:13:31','dev');
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
INSERT INTO `schema_migrations` VALUES ('20090601175224'),('20090601184051'),('20090601184055'),('20090601184059'),('20090701164131'),('20090713165021'),('20090808144214'),('20090809160211'),('20090810173759'),('20090826140238'),('20090826141836'),('20090829202538'),('20090829210029'),('20090829224505'),('20090830143959'),('20090830145319'),('20090901153809'),('20090904190655'),('20090905175341'),('20090905192056'),('20090906135044'),('20090909222719'),('20090911180950'),('20090912165229'),('20090919155819'),('20091024222359'),('20091103164416'),('20091103180558'),('20091103181146'),('20091109191211'),('20091225193714'),('20100114152902'),('20100121142414'),('20100127115341'),('20100127120219'),('20100127120515'),('20100127121337'),('20100129150736'),('20100203202757'),('20100203204803'),('20100204172507'),('20100204173714'),('20100208163239'),('20100210114531'),('20100212134334'),('20100218181507'),('20100219114448'),('20100220144106'),('20100222144003'),('20100223153023'),('20100224153728'),('20100224163525'),('20100225124928'),('20100225153721'),('20100225155505'),('20100225155739'),('20100226122144'),('20100226122651'),('20100301153626'),('20100302131225'),('20100303131706'),('20100308163148'),('20100308164422'),('20100310172315'),('20100310181338'),('20100311123523'),('20100315112858'),('20100319141401'),('20100322184529'),('20100324134243'),('20100324141652'),('20100331125702'),('20100415130556'),('20100415130600'),('20100415130605'),('20100415134627'),('20100419141518'),('20100419142018'),('20100419164230'),('20100426141509'),('20100428130912'),('20100429171200'),('20100430174140'),('20100610151652'),('20100610180750'),('20100614142225'),('20100614160819'),('20100614162423'),('20100616132525'),('20100616135507'),('20100622124252'),('20100706105523'),('20100710121447'),('20100710191351'),('20100716155807'),('20100719131622'),('20100721155359'),('20100722124307'),('20100812164444'),('20100812164449'),('20100812164518'),('20100812164524'),('20100817165213'),('20100819175736'),('20100820185846'),('20100906095758'),('20100915145823'),('20100929111549'),('20101001155323'),('20101005180058'),('20101022155620'),('99999999999000'),('99999999999900');
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
INSERT INTO `solar_systems` VALUES (1,'Expansion',1,2,2),(2,'Resource',1,0,2),(3,'Expansion',1,2,0),(4,'Homeworld',1,1,1);
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
) ENGINE=InnoDB AUTO_INCREMENT=52 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ss_objects`
--

LOCK TABLES `ss_objects` WRITE;
/*!40000 ALTER TABLE `ss_objects` DISABLE KEYS */;
INSERT INTO `ss_objects` VALUES (1,1,0,0,4,306,'Asteroid',NULL,'',30,0,0,0,1,0,0,3,0,0,2,NULL,0),(2,1,0,0,4,72,'Asteroid',NULL,'',25,0,0,0,3,0,0,3,0,0,2,NULL,0),(3,1,36,29,3,246,'Planet',NULL,'P-3',52,1,0,0,0,0,0,0,0,0,0,'2010-11-04 14:13:34',0),(4,1,0,0,1,180,'Asteroid',NULL,'',39,0,0,0,1,0,0,1,0,0,1,NULL,0),(5,1,0,0,2,210,'Asteroid',NULL,'',45,0,0,0,3,0,0,2,0,0,3,NULL,0),(6,1,0,0,3,202,'Asteroid',NULL,'',43,0,0,0,2,0,0,3,0,0,2,NULL,0),(7,1,0,0,2,240,'Asteroid',NULL,'',35,0,0,0,2,0,0,2,0,0,1,NULL,0),(8,1,0,0,1,315,'Asteroid',NULL,'',60,0,0,0,1,0,0,0,0,0,1,NULL,0),(9,1,25,34,4,162,'Planet',NULL,'P-9',49,0,0,0,0,0,0,0,0,0,0,'2010-11-04 14:13:34',0),(10,1,0,0,1,0,'Asteroid',NULL,'',48,0,0,0,2,0,0,3,0,0,3,NULL,0),(11,1,0,0,3,112,'Asteroid',NULL,'',43,0,0,0,0,0,0,1,0,0,0,NULL,0),(12,1,0,0,3,180,'Asteroid',NULL,'',33,0,0,0,1,0,0,3,0,0,2,NULL,0),(13,1,0,0,4,234,'Asteroid',NULL,'',38,0,0,0,3,0,0,1,0,0,2,NULL,0),(14,1,0,0,2,180,'Asteroid',NULL,'',45,0,0,0,3,0,0,2,0,0,1,NULL,0),(15,1,0,0,0,90,'Asteroid',NULL,'',32,0,0,0,1,0,0,1,0,0,0,NULL,0),(16,1,0,0,5,105,'Jumpgate',NULL,'',48,0,0,0,0,0,0,0,0,0,0,NULL,0),(17,1,0,0,0,270,'Asteroid',NULL,'',30,0,0,0,1,0,0,0,0,0,0,NULL,0),(18,1,0,0,2,0,'Asteroid',NULL,'',46,0,0,0,1,0,0,1,0,0,1,NULL,0),(19,1,25,31,0,180,'Planet',NULL,'P-19',48,0,0,0,0,0,0,0,0,0,0,'2010-11-04 14:13:34',0),(20,1,0,0,0,0,'Asteroid',NULL,'',27,0,0,0,1,0,0,1,0,0,1,NULL,0),(21,2,0,0,4,306,'Asteroid',NULL,'',44,0,0,0,0,0,0,1,0,0,0,NULL,0),(22,2,0,0,5,75,'Jumpgate',NULL,'',52,0,0,0,0,0,0,0,0,0,0,NULL,0),(23,2,0,0,2,120,'Asteroid',NULL,'',32,0,0,0,1,0,0,2,0,0,1,NULL,0),(24,2,0,0,1,180,'Asteroid',NULL,'',29,0,0,0,2,0,0,3,0,0,2,NULL,0),(25,2,0,0,3,202,'Asteroid',NULL,'',42,0,0,0,1,0,0,2,0,0,1,NULL,0),(26,2,0,0,5,255,'Jumpgate',NULL,'',34,0,0,0,0,0,0,0,0,0,0,NULL,0),(27,2,0,0,5,30,'Jumpgate',NULL,'',50,0,0,0,0,0,0,0,0,0,0,NULL,0),(28,2,0,0,3,112,'Asteroid',NULL,'',40,0,0,0,3,0,0,3,0,0,2,NULL,0),(29,2,40,29,2,150,'Planet',NULL,'P-29',54,1,0,0,0,0,0,0,0,0,0,'2010-11-04 14:13:34',0),(30,2,0,0,5,135,'Jumpgate',NULL,'',34,0,0,0,0,0,0,0,0,0,0,NULL,0),(31,2,0,0,0,90,'Asteroid',NULL,'',29,0,0,0,1,0,0,3,0,0,2,NULL,0),(32,2,0,0,3,90,'Asteroid',NULL,'',29,0,0,0,1,0,0,2,0,0,2,NULL,0),(33,2,0,0,0,180,'Asteroid',NULL,'',30,0,0,0,0,0,0,1,0,0,0,NULL,0),(34,3,0,0,4,0,'Asteroid',NULL,'',40,0,0,0,1,0,0,1,0,0,1,NULL,0),(35,3,0,0,4,288,'Asteroid',NULL,'',26,0,0,0,1,0,0,1,0,0,1,NULL,0),(36,3,0,0,1,180,'Asteroid',NULL,'',28,0,0,0,3,0,0,1,0,0,3,NULL,0),(37,3,21,42,2,330,'Planet',NULL,'P-37',51,1,0,0,0,0,0,0,0,0,0,'2010-11-04 14:13:34',0),(38,3,0,0,4,252,'Asteroid',NULL,'',38,0,0,0,2,0,0,1,0,0,2,NULL,0),(39,3,0,0,4,90,'Asteroid',NULL,'',50,0,0,0,1,0,0,1,0,0,0,NULL,0),(40,3,0,0,5,15,'Jumpgate',NULL,'',30,0,0,0,0,0,0,0,0,0,0,NULL,0),(41,3,0,0,3,66,'Asteroid',NULL,'',50,0,0,0,2,0,0,1,0,0,2,NULL,0),(42,3,23,35,3,292,'Planet',NULL,'P-42',49,2,0,0,0,0,0,0,0,0,0,'2010-11-04 14:13:34',0),(43,3,0,0,0,0,'Asteroid',NULL,'',34,0,0,0,0,0,0,0,0,0,1,NULL,0),(44,4,0,0,3,180,'Asteroid',NULL,'',33,0,0,0,1,0,0,0,0,0,1,NULL,0),(45,4,0,0,3,0,'Asteroid',NULL,'',40,0,0,0,1,0,0,0,0,0,1,NULL,0),(46,4,0,0,0,90,'Asteroid',NULL,'',54,0,0,0,1,0,0,0,0,0,1,NULL,0),(47,4,0,0,5,285,'Jumpgate',NULL,'',57,0,0,0,0,0,0,0,0,0,0,NULL,0),(48,4,24,38,3,336,'Planet',NULL,'P-48',50,1,0,0,0,0,0,0,0,0,0,'2010-11-04 14:13:34',0),(49,4,30,30,2,0,'Planet',1,'P-49',50,0,864,1,3024,1728,2,6048,0,0,604.8,'2010-11-04 14:13:34',0),(50,4,0,0,0,180,'Asteroid',NULL,'',29,0,0,0,1,0,0,0,0,0,1,NULL,0),(51,4,0,0,1,270,'Asteroid',NULL,'',28,0,0,0,1,0,0,1,0,0,0,NULL,0);
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
INSERT INTO `tiles` VALUES (4,3,0,14),(4,3,0,15),(4,3,0,16),(4,3,0,17),(4,3,0,18),(4,3,0,19),(4,3,0,20),(4,3,1,15),(4,3,1,16),(4,3,1,17),(4,3,1,19),(4,3,1,20),(4,3,2,15),(4,3,2,16),(4,3,2,20),(4,3,2,25),(4,3,3,14),(4,3,3,15),(4,3,3,16),(4,3,3,17),(4,3,3,19),(4,3,3,20),(4,3,3,22),(4,3,3,23),(4,3,3,24),(4,3,3,25),(1,3,3,26),(4,3,4,15),(6,3,4,16),(6,3,4,17),(1,3,4,21),(4,3,4,23),(4,3,4,25),(6,3,5,1),(6,3,5,2),(6,3,5,3),(4,3,5,6),(4,3,5,8),(6,3,5,14),(4,3,5,15),(6,3,5,16),(6,3,5,17),(6,3,5,18),(6,3,5,19),(4,3,5,23),(4,3,5,24),(4,3,5,25),(4,3,5,26),(4,3,5,27),(4,3,5,28),(6,3,6,0),(6,3,6,1),(6,3,6,3),(6,3,6,4),(6,3,6,5),(4,3,6,6),(4,3,6,7),(4,3,6,8),(4,3,6,9),(6,3,6,13),(6,3,6,14),(6,3,6,15),(6,3,6,16),(6,3,6,17),(6,3,6,18),(4,3,6,23),(4,3,6,24),(4,3,6,25),(4,3,6,26),(4,3,6,27),(4,3,6,28),(6,3,7,0),(6,3,7,1),(6,3,7,2),(4,3,7,3),(4,3,7,4),(4,3,7,5),(4,3,7,6),(4,3,7,7),(13,3,7,13),(8,3,7,15),(4,3,7,25),(4,3,7,26),(4,3,7,27),(4,3,7,28),(6,3,8,1),(4,3,8,3),(4,3,8,4),(4,3,8,5),(4,3,8,6),(4,3,8,7),(4,3,8,8),(10,3,8,25),(6,3,9,1),(4,3,9,6),(4,3,9,7),(4,3,10,6),(4,3,10,7),(4,3,10,8),(4,3,10,11),(3,3,10,15),(3,3,10,16),(14,3,10,17),(0,3,10,22),(4,3,11,7),(4,3,11,11),(4,3,11,12),(3,3,11,15),(3,3,11,16),(4,3,12,10),(4,3,12,11),(3,3,12,15),(3,3,12,16),(9,3,12,25),(5,3,13,4),(5,3,13,6),(4,3,13,11),(4,3,13,12),(4,3,13,13),(4,3,13,15),(3,3,13,16),(3,3,13,17),(12,3,13,18),(5,3,14,4),(5,3,14,5),(5,3,14,6),(5,3,14,7),(5,3,14,8),(4,3,14,10),(4,3,14,11),(4,3,14,12),(4,3,14,13),(4,3,14,14),(4,3,14,15),(3,3,14,16),(3,3,14,17),(5,3,15,6),(3,3,15,7),(5,3,15,8),(4,3,15,11),(4,3,15,12),(4,3,15,14),(4,3,15,15),(3,3,15,16),(3,3,15,17),(5,3,15,24),(3,3,16,5),(3,3,16,6),(3,3,16,7),(3,3,16,8),(4,3,16,11),(4,3,16,12),(4,3,16,14),(4,3,16,15),(3,3,16,16),(3,3,16,17),(5,3,16,24),(5,3,16,25),(5,3,16,26),(3,3,17,4),(3,3,17,5),(3,3,17,7),(3,3,17,8),(3,3,17,9),(3,3,17,10),(3,3,17,13),(3,3,17,14),(3,3,17,15),(3,3,17,16),(3,3,17,17),(5,3,17,24),(5,3,17,25),(2,3,17,26),(3,3,18,7),(3,3,18,8),(3,3,18,9),(3,3,18,10),(3,3,18,15),(3,3,18,16),(3,3,18,17),(5,3,18,24),(5,3,18,25),(3,3,19,7),(3,3,19,8),(3,3,19,9),(3,3,19,10),(3,3,19,11),(3,3,19,12),(3,3,19,13),(3,3,19,14),(3,3,19,15),(3,3,19,16),(3,3,19,17),(3,3,19,18),(3,3,19,19),(5,3,19,25),(3,3,20,7),(3,3,20,8),(3,3,20,10),(3,3,20,12),(3,3,20,13),(3,3,20,14),(3,3,20,15),(3,3,20,16),(3,3,20,17),(3,3,21,9),(3,3,21,10),(3,3,21,11),(3,3,21,12),(3,3,21,13),(3,3,21,14),(3,3,21,15),(3,3,21,16),(3,3,21,17),(2,3,21,26),(3,3,22,9),(3,3,22,10),(3,3,22,11),(3,3,22,12),(3,3,23,12),(3,3,24,12),(10,3,24,20),(6,3,25,0),(0,3,25,26),(6,3,26,0),(6,3,26,1),(6,3,27,0),(6,3,27,1),(6,3,28,1),(6,3,28,2),(5,3,28,7),(4,3,28,23),(14,3,28,25),(6,3,29,0),(6,3,29,1),(5,3,29,6),(5,3,29,7),(4,3,29,23),(4,3,29,24),(6,3,30,1),(6,3,30,2),(5,3,30,5),(5,3,30,6),(3,3,30,11),(3,3,30,12),(0,3,30,21),(4,3,30,23),(4,3,30,24),(6,3,31,1),(5,3,31,5),(5,3,31,6),(5,3,31,7),(5,3,31,8),(3,3,31,12),(3,3,31,13),(3,3,31,14),(3,3,31,15),(3,3,31,16),(0,3,31,17),(4,3,31,24),(4,3,31,25),(4,3,31,26),(4,3,31,27),(4,3,31,28),(6,3,32,1),(5,3,32,2),(5,3,32,3),(5,3,32,4),(5,3,32,5),(5,3,32,7),(5,3,32,8),(3,3,32,11),(3,3,32,12),(3,3,32,13),(3,3,32,14),(3,3,32,15),(3,3,32,16),(4,3,32,24),(4,3,32,25),(0,3,32,26),(4,3,32,28),(5,3,33,4),(3,3,33,9),(3,3,33,10),(3,3,33,11),(3,3,33,12),(3,3,33,13),(3,3,33,14),(3,3,33,15),(3,3,33,16),(3,3,33,17),(4,3,33,25),(4,3,33,28),(5,3,34,4),(5,3,34,5),(3,3,34,10),(3,3,34,11),(3,3,34,12),(3,3,34,13),(3,3,34,14),(3,3,34,15),(3,3,34,16),(4,3,34,25),(4,3,34,26),(4,3,34,27),(4,3,34,28),(3,3,35,10),(3,3,35,11),(3,3,35,12),(3,3,35,13),(3,3,35,14),(3,3,35,15),(3,3,35,16),(3,3,35,17),(4,3,35,25),(4,3,35,26),(4,3,35,27),(4,3,35,28),(6,9,0,1),(6,9,0,2),(6,9,0,3),(6,9,0,4),(6,9,0,5),(3,9,0,17),(3,9,0,18),(3,9,0,19),(3,9,0,20),(3,9,0,21),(6,9,1,2),(6,9,1,4),(6,9,1,5),(3,9,1,17),(3,9,1,18),(3,9,1,19),(3,9,1,20),(3,9,1,21),(3,9,1,22),(0,9,1,24),(6,9,2,8),(3,9,2,17),(3,9,2,18),(3,9,2,19),(3,9,2,20),(0,9,2,30),(5,9,3,0),(5,9,3,1),(6,9,3,5),(6,9,3,6),(6,9,3,7),(6,9,3,8),(3,9,3,17),(3,9,3,18),(3,9,3,20),(5,9,4,0),(5,9,4,1),(5,9,4,2),(5,9,4,3),(6,9,4,6),(5,9,5,0),(5,9,5,1),(5,9,5,2),(5,9,5,3),(5,9,5,4),(6,9,5,5),(6,9,5,6),(5,9,6,0),(5,9,6,1),(5,9,6,2),(5,9,6,3),(5,9,6,4),(5,9,6,5),(5,9,6,6),(5,9,6,7),(6,9,6,14),(0,9,6,21),(1,9,6,26),(5,9,7,0),(5,9,7,1),(5,9,7,2),(5,9,7,4),(5,9,7,5),(5,9,7,6),(5,9,7,7),(5,9,7,8),(5,9,7,9),(6,9,7,13),(6,9,7,14),(6,9,7,15),(0,9,7,31),(5,9,8,0),(5,9,8,1),(5,9,8,2),(5,9,8,3),(5,9,8,4),(5,9,8,5),(5,9,8,6),(5,9,8,8),(5,9,8,9),(6,9,8,14),(6,9,8,15),(5,9,8,18),(5,9,9,1),(5,9,9,3),(5,9,9,4),(4,9,9,5),(5,9,9,6),(5,9,9,7),(5,9,9,8),(5,9,9,9),(6,9,9,15),(6,9,9,16),(5,9,9,17),(5,9,9,18),(5,9,9,19),(5,9,9,20),(6,9,9,24),(5,9,10,0),(5,9,10,1),(4,9,10,2),(4,9,10,3),(5,9,10,4),(4,9,10,5),(4,9,10,6),(5,9,10,8),(5,9,10,9),(5,9,10,16),(5,9,10,17),(5,9,10,18),(5,9,10,19),(10,9,10,20),(6,9,10,24),(6,9,10,25),(6,9,10,26),(4,9,11,2),(4,9,11,3),(4,9,11,4),(4,9,11,5),(4,9,11,6),(4,9,11,7),(5,9,11,8),(5,9,11,16),(0,9,11,17),(5,9,11,19),(6,9,11,24),(6,9,11,25),(2,9,11,26),(4,9,12,1),(4,9,12,2),(4,9,12,5),(5,9,12,16),(5,9,12,19),(6,9,12,24),(6,9,12,25),(4,9,13,0),(4,9,13,1),(4,9,13,2),(5,9,13,18),(5,9,13,19),(3,9,13,25),(0,9,13,30),(4,9,14,0),(4,9,14,1),(4,9,14,2),(4,9,14,3),(4,9,14,7),(4,9,14,9),(4,9,14,10),(9,9,14,11),(5,9,14,17),(5,9,14,18),(5,9,14,19),(3,9,14,23),(3,9,14,24),(3,9,14,25),(3,9,14,33),(4,9,15,0),(4,9,15,6),(4,9,15,7),(4,9,15,8),(4,9,15,9),(4,9,15,10),(5,9,15,17),(5,9,15,18),(5,9,15,19),(5,9,15,20),(3,9,15,23),(3,9,15,24),(3,9,15,25),(3,9,15,26),(3,9,15,27),(3,9,15,30),(3,9,15,31),(3,9,15,32),(3,9,15,33),(4,9,16,5),(4,9,16,6),(4,9,16,7),(4,9,16,8),(4,9,16,9),(4,9,16,10),(5,9,16,18),(5,9,16,19),(2,9,16,25),(3,9,16,30),(3,9,16,31),(3,9,16,32),(3,9,16,33),(4,9,17,7),(4,9,17,8),(4,9,17,9),(4,9,17,10),(5,9,17,19),(4,9,17,31),(13,9,17,32),(4,9,18,7),(4,9,18,8),(4,9,18,9),(4,9,18,10),(4,9,18,30),(4,9,18,31),(10,9,19,1),(11,9,19,5),(9,9,19,11),(13,9,19,14),(14,9,19,16),(11,9,19,20),(4,9,19,30),(4,9,19,31),(3,9,20,0),(0,9,20,29),(4,9,20,31),(3,9,21,0),(4,9,21,31),(3,9,22,0),(4,9,22,16),(8,9,22,17),(4,9,22,26),(4,9,22,27),(4,9,22,28),(4,9,22,29),(4,9,22,30),(4,9,22,31),(3,9,23,0),(3,9,23,1),(4,9,23,16),(4,9,23,30),(4,9,23,31),(4,9,23,32),(4,9,23,33),(3,9,24,0),(3,9,24,1),(3,9,24,2),(3,9,24,3),(4,9,24,16),(4,9,24,29),(4,9,24,30),(4,9,24,31),(4,9,24,32),(4,9,24,33),(5,19,0,10),(5,19,0,11),(3,19,0,17),(3,19,0,18),(4,19,0,21),(4,19,0,22),(14,19,1,0),(5,19,1,10),(5,19,1,11),(5,19,1,12),(3,19,1,18),(3,19,1,19),(4,19,1,20),(4,19,1,21),(4,19,1,22),(4,19,1,23),(4,19,1,24),(4,19,1,25),(4,19,1,26),(0,19,1,28),(5,19,2,10),(5,19,2,11),(5,19,2,12),(5,19,2,13),(5,19,2,14),(3,19,2,19),(3,19,2,20),(3,19,2,21),(3,19,2,22),(4,19,2,24),(4,19,2,26),(5,19,3,10),(5,19,3,11),(5,19,3,12),(5,19,3,13),(3,19,3,16),(3,19,3,18),(3,19,3,19),(3,19,3,20),(3,19,3,21),(3,19,3,22),(5,19,4,8),(5,19,4,11),(5,19,4,12),(3,19,4,16),(3,19,4,17),(3,19,4,18),(3,19,4,19),(3,19,4,20),(3,19,4,21),(10,19,5,0),(5,19,5,8),(5,19,5,9),(5,19,5,10),(5,19,5,11),(5,19,5,12),(6,19,5,14),(3,19,5,17),(3,19,5,20),(5,19,6,9),(5,19,6,10),(5,19,6,11),(6,19,6,13),(6,19,6,14),(6,19,6,15),(5,19,7,9),(5,19,7,11),(6,19,7,12),(6,19,7,13),(6,19,7,14),(0,19,7,27),(5,19,8,11),(6,19,8,13),(6,19,8,14),(4,19,8,24),(4,19,8,25),(13,19,9,8),(5,19,9,10),(5,19,9,11),(6,19,9,12),(6,19,9,13),(6,19,9,14),(6,19,9,15),(4,19,9,21),(4,19,9,22),(4,19,9,23),(4,19,9,24),(4,19,9,25),(4,19,9,26),(5,19,10,10),(5,19,10,11),(6,19,10,12),(6,19,10,15),(4,19,10,17),(4,19,10,23),(4,19,10,24),(5,19,11,10),(5,19,11,11),(5,19,11,12),(4,19,11,16),(4,19,11,17),(4,19,11,18),(6,19,11,19),(6,19,11,20),(6,19,11,21),(6,19,11,22),(6,19,11,23),(4,19,11,24),(3,19,11,25),(0,19,11,27),(5,19,12,10),(5,19,12,11),(5,19,12,12),(4,19,12,16),(4,19,12,17),(4,19,12,18),(6,19,12,19),(6,19,12,20),(6,19,12,21),(6,19,12,22),(0,19,12,23),(3,19,12,25),(3,19,12,26),(4,19,13,5),(4,19,13,6),(5,19,13,10),(5,19,13,12),(5,19,13,13),(4,19,13,16),(4,19,13,17),(4,19,13,18),(6,19,13,20),(6,19,13,21),(6,19,13,22),(3,19,13,25),(3,19,13,26),(3,19,13,27),(3,19,13,28),(3,19,13,29),(3,19,13,30),(4,19,14,5),(4,19,14,6),(5,19,14,12),(4,19,14,16),(6,19,14,20),(6,19,14,21),(6,19,14,22),(3,19,14,23),(3,19,14,24),(3,19,14,25),(3,19,14,26),(3,19,14,27),(3,19,14,28),(3,19,14,29),(4,19,15,6),(4,19,15,7),(11,19,15,17),(9,19,15,23),(3,19,15,26),(3,19,15,27),(3,19,15,28),(3,19,15,29),(3,19,15,30),(1,19,16,1),(0,19,16,5),(4,19,16,7),(0,19,16,11),(0,19,16,27),(3,19,16,30),(4,19,17,7),(4,19,18,5),(4,19,18,6),(4,19,18,7),(6,19,18,27),(6,19,18,28),(6,19,18,29),(6,19,18,30),(12,19,19,4),(5,19,19,17),(5,19,19,18),(5,19,19,19),(5,19,19,20),(5,19,19,22),(6,19,19,27),(6,19,19,28),(6,19,19,29),(6,19,19,30),(3,19,20,11),(3,19,20,12),(5,19,20,19),(5,19,20,20),(5,19,20,21),(5,19,20,22),(0,19,20,27),(6,19,20,29),(6,19,20,30),(3,19,21,12),(3,19,21,13),(3,19,21,14),(5,19,21,20),(5,19,21,22),(4,19,21,23),(4,19,21,24),(6,19,21,29),(6,19,21,30),(2,19,22,1),(3,19,22,10),(3,19,22,11),(3,19,22,12),(3,19,22,13),(3,19,22,14),(3,19,22,15),(3,19,22,16),(5,19,22,22),(4,19,22,23),(4,19,22,24),(6,19,22,28),(6,19,22,29),(6,19,22,30),(3,19,23,10),(3,19,23,11),(3,19,23,12),(3,19,23,13),(3,19,23,14),(5,19,23,21),(5,19,23,22),(4,19,23,23),(4,19,23,24),(4,19,23,25),(3,19,24,10),(3,19,24,11),(3,19,24,12),(3,19,24,13),(3,19,24,14),(4,19,24,23),(4,19,24,24),(4,19,24,25),(4,19,24,26),(14,29,0,1),(4,29,0,13),(4,29,0,14),(4,29,0,16),(4,29,0,17),(4,29,1,5),(4,29,1,6),(0,29,1,7),(0,29,1,12),(4,29,1,14),(4,29,1,15),(4,29,1,16),(1,29,1,17),(1,29,1,23),(4,29,2,5),(4,29,2,6),(4,29,2,15),(4,29,2,16),(4,29,3,3),(4,29,3,4),(4,29,3,5),(4,29,3,6),(5,29,3,9),(4,29,3,12),(4,29,3,13),(4,29,3,14),(4,29,3,15),(4,29,3,16),(4,29,3,17),(0,29,4,2),(4,29,4,4),(4,29,4,5),(4,29,4,6),(4,29,4,7),(4,29,4,8),(5,29,4,9),(9,29,4,10),(4,29,4,13),(4,29,4,14),(4,29,4,16),(4,29,4,17),(4,29,5,4),(4,29,5,5),(0,29,5,7),(5,29,5,9),(12,29,5,13),(2,29,5,26),(4,29,6,3),(4,29,6,4),(4,29,6,5),(5,29,6,6),(5,29,6,9),(4,29,7,4),(5,29,7,5),(5,29,7,6),(5,29,7,7),(5,29,7,8),(5,29,7,9),(0,29,8,3),(5,29,8,5),(5,29,8,6),(11,29,8,7),(5,29,9,5),(5,29,10,5),(5,29,10,6),(12,29,12,0),(0,29,13,23),(3,29,13,25),(3,29,13,26),(3,29,14,10),(3,29,14,13),(4,29,14,20),(4,29,14,21),(4,29,14,22),(3,29,14,25),(3,29,14,27),(3,29,14,28),(3,29,15,10),(3,29,15,11),(3,29,15,12),(3,29,15,13),(3,29,15,14),(3,29,15,15),(4,29,15,21),(4,29,15,22),(4,29,15,23),(3,29,15,24),(3,29,15,25),(3,29,15,26),(3,29,15,27),(3,29,15,28),(3,29,16,9),(3,29,16,10),(3,29,16,11),(3,29,16,12),(3,29,16,13),(3,29,16,14),(4,29,16,21),(4,29,16,22),(4,29,16,23),(3,29,16,24),(3,29,16,25),(3,29,16,26),(3,29,16,27),(3,29,17,8),(3,29,17,11),(3,29,17,14),(4,29,17,21),(4,29,17,22),(4,29,17,23),(3,29,17,24),(3,29,17,25),(3,29,17,26),(3,29,18,5),(3,29,18,6),(3,29,18,7),(3,29,18,8),(3,29,18,10),(3,29,18,11),(4,29,18,21),(4,29,18,22),(3,29,18,26),(13,29,19,0),(10,29,19,2),(3,29,19,7),(3,29,19,8),(3,29,19,9),(3,29,19,10),(5,29,19,18),(5,29,19,19),(5,29,19,20),(4,29,19,22),(4,29,19,23),(3,29,20,6),(3,29,20,7),(3,29,20,8),(3,29,20,9),(3,29,20,10),(5,29,20,19),(5,29,20,20),(4,29,20,22),(4,29,20,23),(3,29,21,6),(3,29,21,7),(3,29,21,8),(5,29,21,19),(5,29,21,20),(4,29,21,23),(3,29,21,24),(3,29,22,7),(5,29,22,19),(5,29,22,20),(5,29,22,21),(3,29,22,22),(3,29,22,23),(3,29,22,24),(5,29,23,18),(5,29,23,19),(5,29,23,20),(3,29,23,21),(3,29,23,22),(3,29,23,23),(5,29,24,14),(5,29,24,18),(5,29,24,20),(3,29,24,21),(3,29,24,22),(3,29,24,23),(3,29,24,24),(11,29,25,0),(5,29,25,14),(3,29,25,22),(3,29,25,23),(3,29,25,24),(5,29,26,14),(5,29,26,15),(5,29,26,16),(5,29,26,17),(3,29,26,21),(3,29,26,22),(3,29,26,23),(3,29,26,24),(5,29,27,16),(5,29,27,17),(5,29,28,14),(5,29,28,15),(5,29,28,16),(5,29,29,13),(5,29,29,14),(5,29,29,15),(5,29,29,16),(14,29,30,2),(6,29,30,8),(6,29,31,6),(6,29,31,8),(6,29,32,6),(6,29,32,7),(6,29,32,8),(6,29,32,9),(6,29,32,10),(6,29,32,22),(3,29,32,24),(3,29,32,25),(3,29,32,26),(3,29,32,27),(3,29,32,28),(6,29,33,6),(6,29,33,7),(6,29,33,8),(6,29,33,9),(6,29,33,22),(6,29,33,23),(3,29,33,24),(9,29,34,3),(6,29,34,6),(6,29,34,7),(6,29,34,8),(6,29,34,22),(3,29,34,23),(3,29,34,24),(3,29,34,25),(3,29,34,27),(6,29,35,7),(6,29,35,10),(6,29,35,11),(6,29,35,21),(6,29,35,22),(3,29,35,23),(3,29,35,24),(3,29,35,25),(3,29,35,26),(3,29,35,27),(3,29,35,28),(6,29,36,9),(6,29,36,10),(6,29,36,11),(6,29,36,12),(6,29,36,13),(6,29,36,14),(6,29,36,21),(6,29,36,22),(6,29,36,23),(6,29,36,24),(3,29,36,25),(3,29,36,26),(4,29,36,27),(4,29,36,28),(6,29,37,10),(6,29,37,11),(6,29,37,12),(6,29,37,21),(6,29,37,22),(6,29,37,23),(6,29,37,24),(6,29,37,25),(6,29,37,26),(4,29,37,27),(4,29,37,28),(6,29,38,11),(6,29,38,12),(6,29,38,13),(4,29,38,20),(4,29,38,21),(4,29,38,22),(4,29,38,23),(4,29,38,24),(4,29,38,25),(4,29,38,26),(4,29,38,27),(6,29,39,10),(6,29,39,11),(4,29,39,22),(4,29,39,23),(4,29,39,24),(4,29,39,25),(4,29,39,26),(4,29,39,27),(4,29,39,28),(6,37,0,7),(6,37,0,8),(6,37,0,9),(4,37,0,25),(4,37,0,26),(4,37,0,27),(4,37,0,28),(4,37,0,29),(4,37,0,31),(4,37,0,32),(4,37,0,33),(0,37,1,7),(6,37,1,9),(6,37,1,10),(0,37,1,15),(0,37,1,26),(4,37,1,28),(4,37,1,29),(4,37,1,30),(4,37,1,31),(4,37,1,32),(0,37,1,37),(0,37,2,3),(6,37,2,9),(6,37,2,10),(0,37,2,11),(0,37,2,20),(4,37,2,28),(4,37,2,29),(1,37,2,30),(4,37,2,32),(6,37,3,10),(4,37,3,27),(4,37,3,28),(4,37,3,29),(3,37,3,32),(5,37,4,16),(5,37,4,18),(3,37,4,27),(4,37,4,28),(3,37,4,29),(3,37,4,30),(3,37,4,31),(3,37,4,32),(3,37,4,33),(3,37,4,34),(3,37,4,35),(6,37,4,36),(6,37,4,37),(11,37,5,9),(5,37,5,16),(5,37,5,17),(5,37,5,18),(3,37,5,26),(3,37,5,27),(3,37,5,29),(3,37,5,30),(3,37,5,31),(3,37,5,32),(3,37,5,33),(3,37,5,34),(3,37,5,35),(6,37,5,36),(6,37,5,37),(6,37,5,38),(0,37,6,4),(5,37,6,15),(2,37,6,16),(5,37,6,18),(11,37,6,19),(3,37,6,26),(3,37,6,27),(3,37,6,28),(3,37,6,29),(3,37,6,30),(3,37,6,31),(5,37,6,32),(5,37,6,33),(5,37,6,34),(3,37,6,35),(5,37,6,36),(6,37,6,37),(6,37,6,38),(6,37,6,39),(5,37,7,15),(5,37,7,18),(3,37,7,25),(3,37,7,26),(3,37,7,27),(3,37,7,28),(5,37,7,32),(5,37,7,33),(5,37,7,34),(5,37,7,35),(5,37,7,36),(5,37,7,37),(5,37,7,38),(5,37,7,39),(5,37,8,15),(5,37,8,16),(5,37,8,17),(5,37,8,18),(3,37,8,28),(5,37,8,33),(5,37,8,34),(5,37,8,35),(5,37,8,36),(5,37,8,37),(5,37,8,38),(5,37,8,39),(6,37,9,12),(5,37,9,13),(5,37,9,14),(5,37,9,15),(5,37,9,16),(5,37,9,17),(5,37,9,18),(5,37,9,34),(5,37,9,35),(5,37,9,36),(6,37,10,11),(6,37,10,12),(6,37,10,13),(6,37,10,14),(6,37,10,15),(6,37,10,16),(5,37,10,17),(5,37,10,18),(5,37,10,19),(6,37,10,20),(6,37,10,21),(6,37,10,22),(6,37,10,23),(5,37,10,35),(13,37,11,7),(6,37,11,14),(1,37,11,15),(5,37,11,17),(5,37,11,18),(5,37,11,19),(5,37,11,20),(6,37,11,21),(6,37,11,22),(5,37,12,17),(5,37,12,18),(5,37,12,19),(5,37,12,20),(6,37,12,22),(13,37,12,23),(3,37,12,27),(5,37,13,17),(5,37,13,18),(5,37,13,19),(5,37,13,20),(5,37,13,21),(6,37,13,22),(3,37,13,26),(3,37,13,27),(3,37,13,28),(3,37,13,29),(10,37,14,14),(5,37,14,18),(5,37,14,19),(5,37,14,20),(5,37,14,21),(5,37,14,22),(3,37,14,25),(3,37,14,26),(3,37,14,27),(3,37,14,28),(5,37,15,18),(5,37,15,21),(5,37,15,22),(3,37,15,25),(3,37,15,26),(3,37,15,27),(3,37,15,28),(3,37,15,29),(4,37,16,1),(4,37,16,2),(4,37,16,3),(5,37,16,21),(5,37,16,22),(3,37,16,25),(3,37,16,26),(3,37,16,27),(3,37,16,28),(4,37,17,2),(4,37,17,3),(4,37,17,4),(4,37,17,5),(9,37,17,7),(5,37,17,21),(3,37,17,25),(3,37,17,26),(3,37,17,27),(3,37,17,28),(4,37,17,31),(4,37,17,36),(6,37,17,37),(6,37,17,38),(6,37,17,39),(4,37,18,3),(4,37,18,4),(4,37,18,5),(3,37,18,23),(3,37,18,24),(3,37,18,25),(3,37,18,26),(4,37,18,28),(4,37,18,29),(4,37,18,31),(4,37,18,32),(4,37,18,35),(4,37,18,36),(6,37,18,38),(6,37,18,39),(4,37,19,3),(4,37,19,4),(4,37,19,5),(3,37,19,24),(3,37,19,25),(3,37,19,26),(4,37,19,28),(4,37,19,31),(4,37,19,32),(4,37,19,33),(4,37,19,34),(4,37,19,35),(6,37,19,37),(6,37,19,38),(6,37,19,39),(4,37,20,0),(4,37,20,1),(4,37,20,2),(4,37,20,3),(4,37,20,4),(4,37,20,5),(4,37,20,6),(3,37,20,26),(4,37,20,28),(4,37,20,29),(4,37,20,30),(4,37,20,31),(4,37,20,35),(4,37,20,36),(4,42,0,0),(3,42,0,6),(3,42,0,7),(3,42,0,8),(3,42,0,9),(3,42,0,10),(3,42,0,11),(4,42,0,12),(4,42,0,13),(6,42,0,21),(13,42,0,22),(9,42,0,24),(8,42,0,32),(4,42,1,0),(3,42,1,7),(3,42,1,8),(3,42,1,9),(3,42,1,10),(3,42,1,11),(5,42,1,12),(4,42,1,13),(4,42,1,15),(4,42,1,16),(6,42,1,21),(4,42,2,0),(4,42,2,3),(3,42,2,6),(3,42,2,7),(3,42,2,8),(3,42,2,9),(3,42,2,10),(3,42,2,11),(5,42,2,12),(4,42,2,13),(4,42,2,14),(4,42,2,15),(4,42,2,16),(4,42,2,17),(6,42,2,21),(4,42,3,0),(4,42,3,1),(4,42,3,2),(4,42,3,3),(4,42,3,4),(4,42,3,7),(3,42,3,8),(3,42,3,9),(3,42,3,10),(3,42,3,11),(5,42,3,12),(5,42,3,13),(4,42,3,14),(4,42,3,16),(4,42,3,17),(6,42,3,20),(6,42,3,21),(1,42,3,28),(4,42,4,0),(4,42,4,1),(4,42,4,2),(4,42,4,3),(4,42,4,5),(4,42,4,6),(4,42,4,7),(3,42,4,8),(3,42,4,9),(3,42,4,10),(5,42,4,11),(5,42,4,12),(6,42,4,21),(0,42,4,32),(4,42,5,5),(4,42,5,6),(4,42,5,7),(4,42,5,8),(4,42,5,9),(3,42,5,10),(5,42,5,11),(4,42,5,15),(5,42,5,17),(5,42,5,18),(5,42,5,19),(5,42,5,20),(9,42,5,24),(4,42,6,6),(4,42,6,7),(4,42,6,15),(5,42,6,19),(5,42,6,20),(5,42,6,21),(4,42,7,5),(4,42,7,6),(4,42,7,15),(4,42,7,16),(4,42,7,17),(4,42,7,18),(4,42,7,19),(4,42,7,20),(1,42,7,28),(5,42,8,5),(4,42,8,15),(4,42,8,16),(4,42,8,17),(4,42,8,19),(5,42,9,4),(5,42,9,5),(6,42,9,6),(6,42,9,7),(6,42,9,8),(4,42,9,16),(5,42,10,4),(5,42,10,5),(6,42,10,6),(6,42,10,7),(5,42,10,17),(5,42,10,18),(5,42,10,19),(5,42,10,20),(5,42,10,21),(5,42,10,22),(5,42,10,23),(8,42,10,24),(0,42,10,32),(5,42,11,4),(5,42,11,5),(6,42,11,6),(5,42,11,19),(5,42,11,20),(5,42,11,21),(5,42,11,22),(5,42,11,23),(5,42,12,20),(3,42,12,21),(3,42,12,22),(5,42,12,23),(3,42,13,21),(3,42,13,22),(3,42,13,23),(3,42,13,24),(3,42,13,25),(3,42,13,26),(11,42,14,0),(11,42,14,7),(2,42,14,14),(4,42,14,16),(4,42,14,17),(4,42,14,18),(2,42,14,19),(3,42,14,21),(3,42,14,22),(3,42,14,23),(3,42,14,24),(3,42,14,25),(0,42,14,28),(4,42,15,16),(4,42,15,17),(4,42,15,18),(3,42,15,21),(3,42,15,22),(3,42,15,23),(0,42,15,24),(3,42,16,6),(4,42,16,13),(4,42,16,14),(4,42,16,15),(4,42,16,16),(4,42,16,17),(4,42,16,18),(4,42,16,19),(3,42,16,20),(3,42,16,21),(3,42,16,22),(3,42,16,23),(0,42,16,32),(3,42,17,6),(10,42,17,13),(12,42,17,17),(3,42,17,23),(3,42,17,24),(3,42,17,25),(3,42,17,26),(3,42,17,27),(3,42,18,0),(3,42,18,1),(3,42,18,2),(3,42,18,3),(3,42,18,4),(3,42,18,5),(3,42,18,6),(3,42,18,7),(3,42,18,8),(3,42,18,9),(3,42,18,10),(10,42,18,23),(3,42,19,0),(3,42,19,1),(3,42,19,2),(3,42,19,3),(3,42,19,4),(3,42,19,5),(3,42,19,6),(3,42,19,7),(3,42,19,8),(0,42,19,28),(6,42,19,34),(3,42,20,0),(3,42,20,1),(3,42,20,2),(3,42,20,3),(3,42,20,4),(3,42,20,5),(3,42,20,6),(3,42,20,7),(6,42,20,8),(6,42,20,9),(6,42,20,10),(0,42,20,32),(6,42,20,34),(3,42,21,0),(3,42,21,1),(3,42,21,2),(3,42,21,3),(3,42,21,4),(3,42,21,5),(3,42,21,6),(3,42,21,7),(6,42,21,9),(6,42,21,10),(6,42,21,11),(6,42,21,34),(3,42,22,0),(3,42,22,1),(3,42,22,2),(3,42,22,3),(3,42,22,4),(3,42,22,5),(3,42,22,6),(6,42,22,32),(6,42,22,33),(6,42,22,34),(3,48,0,0),(3,48,0,1),(3,48,0,2),(3,48,0,3),(3,48,0,4),(3,48,0,5),(3,48,0,6),(3,48,0,7),(3,48,0,8),(4,48,0,26),(4,48,0,27),(3,48,1,0),(3,48,1,1),(3,48,1,2),(3,48,1,3),(3,48,1,4),(3,48,1,5),(3,48,1,7),(12,48,1,12),(4,48,1,24),(4,48,1,25),(4,48,1,26),(3,48,2,0),(3,48,2,1),(3,48,2,2),(3,48,2,3),(3,48,2,4),(0,48,2,9),(4,48,2,21),(4,48,2,22),(4,48,2,23),(4,48,2,24),(4,48,2,25),(4,48,2,26),(4,48,2,27),(3,48,3,0),(3,48,3,1),(3,48,3,2),(3,48,3,3),(3,48,3,4),(3,48,3,5),(3,48,3,6),(3,48,3,7),(6,48,3,8),(4,48,3,22),(4,48,3,23),(4,48,3,24),(4,48,3,25),(4,48,3,26),(4,48,3,27),(4,48,3,28),(3,48,4,0),(3,48,4,1),(3,48,4,2),(0,48,4,3),(3,48,4,5),(6,48,4,8),(6,48,4,9),(6,48,4,10),(6,48,4,11),(4,48,4,22),(4,48,4,23),(4,48,4,24),(4,48,4,25),(6,48,5,10),(4,48,5,23),(4,48,5,24),(6,48,6,10),(6,48,6,11),(4,48,6,23),(4,48,6,24),(10,48,7,6),(6,48,7,10),(10,48,7,14),(4,48,7,23),(4,48,7,24),(5,48,7,29),(5,48,7,30),(5,48,7,33),(5,48,7,34),(0,48,8,2),(6,48,8,10),(2,48,8,11),(6,48,8,27),(6,48,8,28),(5,48,8,30),(5,48,8,31),(5,48,8,32),(5,48,8,33),(5,48,8,34),(5,48,8,35),(5,48,8,36),(5,48,8,37),(0,48,9,19),(6,48,9,26),(6,48,9,27),(6,48,9,28),(6,48,9,29),(6,48,9,30),(5,48,9,31),(5,48,9,32),(5,48,9,33),(5,48,9,34),(5,48,9,35),(5,48,9,36),(5,48,9,37),(6,48,10,28),(6,48,10,29),(5,48,10,31),(5,48,10,32),(5,48,10,33),(5,48,10,34),(5,48,10,35),(5,48,10,36),(4,48,10,37),(13,48,11,8),(9,48,11,15),(6,48,11,28),(5,48,11,32),(4,48,11,34),(4,48,11,35),(4,48,11,36),(4,48,11,37),(3,48,12,4),(4,48,12,25),(4,48,12,27),(6,48,12,29),(6,48,12,31),(5,48,12,32),(5,48,12,33),(4,48,12,34),(4,48,12,35),(4,48,12,36),(4,48,12,37),(0,48,13,1),(3,48,13,4),(0,48,13,5),(4,48,13,24),(4,48,13,25),(4,48,13,26),(4,48,13,27),(6,48,13,29),(6,48,13,30),(6,48,13,31),(6,48,13,32),(4,48,13,33),(4,48,13,34),(4,48,13,35),(4,48,13,36),(4,48,13,37),(3,48,14,4),(0,48,14,12),(4,48,14,25),(4,48,14,26),(4,48,14,27),(4,48,14,28),(6,48,14,29),(6,48,14,30),(6,48,14,31),(4,48,14,32),(4,48,14,33),(4,48,14,34),(4,48,14,35),(4,48,14,36),(4,48,14,37),(3,48,15,1),(3,48,15,2),(3,48,15,3),(3,48,15,4),(3,48,15,5),(3,48,15,6),(3,48,15,7),(4,48,15,22),(4,48,15,23),(4,48,15,26),(4,48,15,27),(6,48,15,29),(3,48,15,30),(4,48,15,31),(4,48,15,32),(4,48,15,33),(4,48,15,34),(5,48,15,35),(4,48,15,37),(3,48,16,1),(3,48,16,2),(3,48,16,3),(3,48,16,4),(3,48,16,5),(3,48,16,6),(3,48,16,7),(4,48,16,22),(4,48,16,23),(4,48,16,24),(4,48,16,25),(4,48,16,26),(4,48,16,27),(4,48,16,28),(4,48,16,29),(3,48,16,30),(4,48,16,31),(4,48,16,32),(4,48,16,33),(5,48,16,34),(5,48,16,35),(5,48,16,36),(5,48,16,37),(3,48,17,2),(3,48,17,3),(3,48,17,4),(3,48,17,5),(3,48,17,6),(3,48,17,7),(3,48,17,8),(4,48,17,25),(4,48,17,26),(4,48,17,27),(4,48,17,28),(3,48,17,29),(3,48,17,30),(6,48,17,31),(5,48,17,32),(4,48,17,33),(5,48,17,34),(5,48,17,35),(5,48,17,36),(0,48,18,3),(3,48,18,5),(3,48,18,6),(3,48,18,7),(1,48,18,8),(5,48,18,21),(4,48,18,26),(3,48,18,27),(3,48,18,28),(3,48,18,29),(3,48,18,30),(6,48,18,31),(5,48,18,32),(5,48,18,33),(5,48,18,34),(5,48,18,35),(5,48,18,36),(3,48,19,5),(3,48,19,7),(6,48,19,15),(6,48,19,16),(6,48,19,17),(5,48,19,19),(5,48,19,20),(5,48,19,21),(5,48,19,22),(4,48,19,26),(3,48,19,27),(3,48,19,28),(3,48,19,29),(3,48,19,30),(6,48,19,31),(6,48,19,32),(5,48,19,33),(5,48,19,34),(5,48,19,35),(3,48,20,4),(3,48,20,5),(3,48,20,7),(6,48,20,12),(6,48,20,13),(6,48,20,14),(6,48,20,15),(6,48,20,16),(6,48,20,17),(5,48,20,18),(5,48,20,20),(5,48,20,21),(4,48,20,26),(3,48,20,27),(3,48,20,28),(3,48,20,29),(3,48,20,30),(6,48,20,31),(6,48,20,32),(5,48,20,33),(5,48,20,34),(5,48,20,35),(14,48,21,1),(3,48,21,7),(2,48,21,13),(6,48,21,15),(5,48,21,18),(5,48,21,19),(5,48,21,20),(5,48,21,21),(5,48,21,22),(5,48,21,23),(3,48,21,24),(3,48,21,25),(3,48,21,26),(3,48,21,27),(3,48,21,28),(3,48,21,29),(3,48,21,30),(6,48,21,31),(6,48,21,32),(6,48,21,33),(5,48,21,35),(5,48,21,36),(5,48,21,37),(5,48,22,18),(5,48,22,19),(5,48,22,20),(5,48,22,21),(5,48,22,22),(3,48,22,25),(3,48,22,28),(3,48,22,29),(3,48,22,30),(3,48,22,31),(6,48,22,32),(5,48,23,18),(5,48,23,19),(5,48,23,20),(5,48,23,21),(3,48,23,26),(3,48,23,27),(3,48,23,28),(3,48,23,29),(3,48,23,30),(5,49,0,0),(5,49,0,1),(5,49,0,2),(5,49,0,3),(5,49,0,15),(5,49,0,16),(5,49,0,17),(5,49,0,18),(5,49,0,19),(5,49,0,20),(5,49,0,21),(5,49,0,22),(5,49,0,23),(5,49,0,24),(5,49,0,25),(5,49,0,26),(0,49,0,28),(5,49,1,0),(5,49,1,1),(5,49,1,2),(5,49,1,3),(4,49,1,7),(4,49,1,8),(4,49,1,9),(4,49,1,10),(13,49,1,12),(5,49,1,16),(5,49,1,17),(5,49,1,18),(11,49,1,20),(5,49,1,26),(5,49,2,0),(5,49,2,1),(5,49,2,2),(4,49,2,6),(4,49,2,7),(4,49,2,8),(4,49,2,9),(5,49,2,14),(5,49,2,15),(5,49,2,16),(5,49,2,17),(5,49,2,19),(5,49,2,26),(5,49,2,27),(5,49,3,0),(5,49,3,1),(4,49,3,5),(4,49,3,6),(4,49,3,7),(4,49,3,8),(4,49,3,9),(5,49,3,15),(5,49,3,16),(5,49,3,17),(5,49,3,18),(5,49,3,19),(0,49,3,27),(5,49,4,1),(5,49,4,2),(5,49,4,3),(4,49,4,6),(4,49,4,7),(4,49,4,8),(6,49,4,11),(5,49,4,16),(5,49,4,17),(5,49,5,2),(5,49,5,3),(4,49,5,5),(4,49,5,6),(4,49,5,7),(6,49,5,10),(6,49,5,11),(6,49,5,20),(6,49,5,21),(6,49,6,10),(6,49,6,11),(6,49,6,18),(6,49,6,20),(6,49,6,21),(6,49,6,22),(12,49,7,1),(6,49,7,11),(6,49,7,19),(6,49,7,20),(6,49,8,11),(6,49,8,12),(6,49,8,13),(6,49,8,19),(6,49,8,20),(6,49,9,12),(6,49,9,13),(6,49,9,14),(6,49,9,20),(3,49,9,25),(3,49,9,26),(0,49,10,8),(6,49,10,12),(6,49,10,13),(8,49,10,22),(3,49,10,25),(3,49,10,26),(3,49,10,27),(3,49,10,29),(3,49,11,26),(3,49,11,27),(3,49,11,28),(3,49,11,29),(3,49,12,27),(3,49,12,28),(3,49,12,29),(3,49,13,25),(3,49,13,27),(3,49,13,28),(3,49,13,29),(3,49,14,25),(3,49,14,26),(3,49,14,27),(3,49,14,28),(3,49,14,29),(3,49,15,25),(3,49,15,26),(3,49,15,27),(3,49,15,28),(3,49,15,29),(5,49,16,0),(3,49,16,26),(3,49,16,27),(3,49,16,28),(3,49,16,29),(5,49,17,0),(5,49,17,1),(3,49,17,25),(3,49,17,26),(3,49,17,27),(3,49,17,28),(3,49,17,29),(5,49,18,0),(5,49,18,1),(0,49,18,5),(3,49,18,24),(3,49,18,25),(3,49,18,26),(3,49,18,27),(3,49,18,28),(3,49,18,29),(5,49,19,0),(3,49,19,24),(3,49,19,25),(3,49,19,26),(3,49,19,27),(3,49,19,28),(3,49,19,29),(5,49,20,0),(5,49,20,1),(3,49,20,24),(3,49,20,25),(3,49,20,26),(3,49,20,27),(3,49,20,28),(3,49,20,29),(5,49,21,0),(3,49,21,25),(3,49,21,26),(3,49,21,27),(3,49,21,28),(3,49,21,29),(5,49,22,0),(14,49,22,1),(3,49,22,27),(3,49,22,28),(3,49,22,29),(5,49,23,0),(4,49,23,20),(3,49,23,26),(3,49,23,27),(3,49,23,28),(3,49,23,29),(5,49,24,0),(4,49,24,18),(4,49,24,19),(4,49,24,20),(4,49,24,21),(4,49,24,22),(0,49,24,24),(3,49,24,27),(3,49,24,28),(5,49,25,0),(5,49,25,2),(4,49,25,19),(4,49,25,20),(4,49,25,21),(4,49,25,22),(5,49,26,0),(5,49,26,1),(5,49,26,2),(6,49,26,6),(6,49,26,7),(2,49,26,16),(4,49,26,19),(4,49,26,20),(4,49,26,21),(4,49,26,22),(4,49,26,23),(6,49,27,5),(6,49,27,6),(5,49,27,7),(5,49,27,8),(5,49,27,11),(5,49,27,12),(4,49,27,19),(4,49,27,20),(4,49,27,21),(4,49,27,22),(4,49,27,23),(4,49,27,24),(5,49,28,1),(5,49,28,2),(5,49,28,3),(5,49,28,4),(6,49,28,5),(6,49,28,6),(5,49,28,7),(5,49,28,8),(5,49,28,10),(5,49,28,11),(5,49,28,12),(5,49,28,13),(5,49,28,14),(4,49,28,19),(4,49,28,20),(4,49,28,21),(4,49,28,22),(4,49,28,23),(0,49,28,24),(5,49,29,2),(6,49,29,3),(6,49,29,4),(6,49,29,5),(6,49,29,6),(5,49,29,7),(5,49,29,8),(5,49,29,9),(5,49,29,10),(5,49,29,11),(5,49,29,12),(5,49,29,13),(4,49,29,18),(4,49,29,19),(4,49,29,20),(4,49,29,21),(4,49,29,22);
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
) ENGINE=InnoDB AUTO_INCREMENT=239 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `units`
--

LOCK TABLES `units` WRITE;
/*!40000 ALTER TABLE `units` DISABLE KEYS */;
INSERT INTO `units` VALUES (1,3000,1,1,1,NULL,NULL,NULL,NULL,0,0,'Rhyno',0,4,72,NULL,1,0,0,0),(2,3400,1,1,1,NULL,NULL,NULL,NULL,0,0,'Thor',0,4,72,NULL,1,0,0,0),(3,3400,1,1,1,NULL,NULL,NULL,NULL,0,0,'Thor',1,4,72,NULL,1,0,0,0),(4,8000,1,1,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,4,72,NULL,1,0,0,0),(5,8000,1,1,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,4,72,NULL,1,0,0,0),(6,8000,1,1,1,NULL,NULL,NULL,NULL,0,0,'Dirac',0,4,72,NULL,1,0,0,0),(7,100,1,5,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(8,200,1,5,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(9,200,1,5,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(10,100,1,5,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(11,100,1,5,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(12,100,1,5,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(13,200,1,6,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(14,100,1,6,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(15,100,1,6,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(16,100,1,7,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(17,200,1,7,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(18,100,1,7,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(19,100,1,7,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(20,200,1,8,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(21,100,1,8,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(22,100,1,8,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(23,100,1,9,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(24,100,1,10,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(25,100,1,10,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(26,100,1,11,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(27,100,1,11,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(28,100,1,12,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(29,100,1,12,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(30,100,1,18,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(31,200,1,18,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(32,100,1,18,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(33,200,1,19,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(34,100,1,19,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(35,100,1,19,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(36,100,1,20,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(37,100,1,21,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(38,100,1,21,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(39,100,1,22,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(40,100,1,22,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(41,3000,1,1,1,NULL,NULL,NULL,NULL,0,0,'Rhyno',0,1,0,NULL,1,0,0,0),(42,3000,1,1,1,NULL,NULL,NULL,NULL,0,0,'Rhyno',0,1,0,NULL,1,0,0,0),(43,3400,1,1,1,NULL,NULL,NULL,NULL,0,0,'Thor',0,1,0,NULL,1,0,0,0),(44,3400,1,1,1,NULL,NULL,NULL,NULL,0,0,'Thor',1,1,0,NULL,1,0,0,0),(45,8000,1,1,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,1,0,NULL,1,0,0,0),(46,8000,1,1,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,1,0,NULL,1,0,0,0),(47,8000,1,1,1,NULL,NULL,NULL,NULL,0,0,'Dirac',0,1,0,NULL,1,0,0,0),(48,8000,1,1,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,3,180,NULL,1,0,0,0),(49,8000,1,1,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,3,180,NULL,1,0,0,0),(50,8000,1,1,1,NULL,NULL,NULL,NULL,0,0,'Dirac',0,3,180,NULL,1,0,0,0),(51,8000,1,1,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,2,180,NULL,1,0,0,0),(52,8000,1,1,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,2,180,NULL,1,0,0,0),(53,8000,1,1,1,NULL,NULL,NULL,NULL,0,0,'Dirac',0,2,180,NULL,1,0,0,0),(54,3000,1,1,1,NULL,NULL,NULL,NULL,0,0,'Rhyno',0,5,105,NULL,1,0,0,0),(55,3400,1,1,1,NULL,NULL,NULL,NULL,0,0,'Thor',0,5,105,NULL,1,0,0,0),(56,3400,1,1,1,NULL,NULL,NULL,NULL,0,0,'Thor',1,5,105,NULL,1,0,0,0),(57,8000,1,1,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,5,105,NULL,1,0,0,0),(58,8000,1,1,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,5,105,NULL,1,0,0,0),(59,8000,1,1,1,NULL,NULL,NULL,NULL,0,0,'Dirac',0,5,105,NULL,1,0,0,0),(60,3400,1,1,1,NULL,NULL,NULL,NULL,0,0,'Thor',0,0,180,NULL,1,0,0,0),(61,3400,1,1,1,NULL,NULL,NULL,NULL,0,0,'Thor',1,0,180,NULL,1,0,0,0),(62,8000,1,1,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,0,180,NULL,1,0,0,0),(63,8000,1,1,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,0,180,NULL,1,0,0,0),(64,8000,1,1,1,NULL,NULL,NULL,NULL,0,0,'Dirac',0,0,180,NULL,1,0,0,0),(65,100,1,30,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(66,100,1,30,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(67,100,1,31,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(68,100,1,31,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(69,100,1,32,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(70,100,1,32,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(71,100,1,33,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(72,100,1,33,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(73,3000,1,2,1,NULL,NULL,NULL,NULL,0,0,'Rhyno',0,5,75,NULL,1,0,0,0),(74,3000,1,2,1,NULL,NULL,NULL,NULL,0,0,'Rhyno',0,5,75,NULL,1,0,0,0),(75,3400,1,2,1,NULL,NULL,NULL,NULL,0,0,'Thor',0,5,75,NULL,1,0,0,0),(76,3400,1,2,1,NULL,NULL,NULL,NULL,0,0,'Thor',1,5,75,NULL,1,0,0,0),(77,8000,1,2,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,5,75,NULL,1,0,0,0),(78,8000,1,2,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,5,75,NULL,1,0,0,0),(79,8000,1,2,1,NULL,NULL,NULL,NULL,0,0,'Dirac',0,5,75,NULL,1,0,0,0),(80,3000,1,2,1,NULL,NULL,NULL,NULL,0,0,'Rhyno',0,3,112,NULL,1,0,0,0),(81,3400,1,2,1,NULL,NULL,NULL,NULL,0,0,'Thor',0,3,112,NULL,1,0,0,0),(82,3400,1,2,1,NULL,NULL,NULL,NULL,0,0,'Thor',1,3,112,NULL,1,0,0,0),(83,8000,1,2,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,3,112,NULL,1,0,0,0),(84,8000,1,2,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,3,112,NULL,1,0,0,0),(85,8000,1,2,1,NULL,NULL,NULL,NULL,0,0,'Dirac',0,3,112,NULL,1,0,0,0),(86,3400,1,2,1,NULL,NULL,NULL,NULL,0,0,'Thor',0,2,150,NULL,1,0,0,0),(87,8000,1,2,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,2,150,NULL,1,0,0,0),(88,8000,1,2,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,2,150,NULL,1,0,0,0),(89,8000,1,2,1,NULL,NULL,NULL,NULL,0,0,'Dirac',0,2,150,NULL,1,0,0,0),(90,200,1,36,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(91,100,1,36,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(92,200,1,36,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(93,200,1,36,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(94,100,1,36,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(95,100,1,36,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(96,200,1,37,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(97,100,1,37,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(98,100,1,37,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(99,100,1,38,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(100,200,1,38,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(101,100,1,38,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(102,200,1,38,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(103,100,1,38,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(104,200,1,38,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(105,100,1,38,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(106,100,1,38,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(107,200,1,39,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(108,100,1,39,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(109,100,1,39,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(110,200,1,40,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(111,100,1,40,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(112,100,1,40,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(113,100,1,41,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(114,100,1,41,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(115,100,1,42,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(116,100,1,42,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(117,100,1,43,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(118,100,1,43,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(119,100,1,44,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(120,3000,1,2,1,NULL,NULL,NULL,NULL,0,0,'Rhyno',0,5,135,NULL,1,0,0,0),(121,3000,1,2,1,NULL,NULL,NULL,NULL,0,0,'Rhyno',0,5,135,NULL,1,0,0,0),(122,3400,1,2,1,NULL,NULL,NULL,NULL,0,0,'Thor',1,5,135,NULL,1,0,0,0),(123,8000,1,2,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,5,135,NULL,1,0,0,0),(124,8000,1,2,1,NULL,NULL,NULL,NULL,0,0,'Dirac',0,5,135,NULL,1,0,0,0),(125,3000,1,2,1,NULL,NULL,NULL,NULL,0,0,'Rhyno',0,0,90,NULL,1,0,0,0),(126,8000,1,2,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,0,90,NULL,1,0,0,0),(127,8000,1,2,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,0,90,NULL,1,0,0,0),(128,8000,1,2,1,NULL,NULL,NULL,NULL,0,0,'Dirac',0,0,90,NULL,1,0,0,0),(129,3400,1,2,1,NULL,NULL,NULL,NULL,0,0,'Thor',0,3,90,NULL,1,0,0,0),(130,8000,1,2,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,3,90,NULL,1,0,0,0),(131,8000,1,2,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,3,90,NULL,1,0,0,0),(132,8000,1,2,1,NULL,NULL,NULL,NULL,0,0,'Dirac',0,3,90,NULL,1,0,0,0),(133,3000,1,3,1,NULL,NULL,NULL,NULL,0,0,'Rhyno',0,1,180,NULL,1,0,0,0),(134,3400,1,3,1,NULL,NULL,NULL,NULL,0,0,'Thor',0,1,180,NULL,1,0,0,0),(135,3400,1,3,1,NULL,NULL,NULL,NULL,0,0,'Thor',1,1,180,NULL,1,0,0,0),(136,8000,1,3,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,1,180,NULL,1,0,0,0),(137,8000,1,3,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,1,180,NULL,1,0,0,0),(138,8000,1,3,1,NULL,NULL,NULL,NULL,0,0,'Dirac',0,1,180,NULL,1,0,0,0),(139,3400,1,3,1,NULL,NULL,NULL,NULL,0,0,'Thor',1,2,330,NULL,1,0,0,0),(140,8000,1,3,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,2,330,NULL,1,0,0,0),(141,8000,1,3,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,2,330,NULL,1,0,0,0),(142,8000,1,3,1,NULL,NULL,NULL,NULL,0,0,'Dirac',0,2,330,NULL,1,0,0,0),(143,100,1,51,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(144,200,1,51,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(145,100,1,51,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(146,100,1,51,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(147,200,1,52,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(148,100,1,52,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(149,100,1,52,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(150,100,1,53,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(151,100,1,53,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(152,100,1,54,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(153,100,1,54,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(154,100,1,55,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(155,100,1,55,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(156,8000,1,3,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,3,66,NULL,1,0,0,0),(157,8000,1,3,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,3,66,NULL,1,0,0,0),(158,8000,1,3,1,NULL,NULL,NULL,NULL,0,0,'Dirac',0,3,66,NULL,1,0,0,0),(159,3400,1,3,1,NULL,NULL,NULL,NULL,0,0,'Thor',0,3,292,NULL,1,0,0,0),(160,3400,1,3,1,NULL,NULL,NULL,NULL,0,0,'Thor',1,3,292,NULL,1,0,0,0),(161,8000,1,3,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,3,292,NULL,1,0,0,0),(162,8000,1,3,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,3,292,NULL,1,0,0,0),(163,8000,1,3,1,NULL,NULL,NULL,NULL,0,0,'Dirac',0,3,292,NULL,1,0,0,0),(164,100,1,62,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(165,200,1,62,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(166,100,1,62,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(167,100,1,62,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(168,100,1,63,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(169,100,1,63,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(170,100,1,64,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(171,100,1,65,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(172,100,1,65,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(173,100,1,66,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(174,100,1,66,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(175,3400,1,4,1,NULL,NULL,NULL,NULL,0,0,'Thor',0,5,285,NULL,1,0,0,0),(176,3400,1,4,1,NULL,NULL,NULL,NULL,0,0,'Thor',1,5,285,NULL,1,0,0,0),(177,8000,1,4,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,5,285,NULL,1,0,0,0),(178,8000,1,4,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,5,285,NULL,1,0,0,0),(179,8000,1,4,1,NULL,NULL,NULL,NULL,0,0,'Dirac',0,5,285,NULL,1,0,0,0),(180,3000,1,4,1,NULL,NULL,NULL,NULL,0,0,'Rhyno',0,3,336,NULL,1,0,0,0),(181,3000,1,4,1,NULL,NULL,NULL,NULL,0,0,'Rhyno',0,3,336,NULL,1,0,0,0),(182,3400,1,4,1,NULL,NULL,NULL,NULL,0,0,'Thor',0,3,336,NULL,1,0,0,0),(183,3400,1,4,1,NULL,NULL,NULL,NULL,0,0,'Thor',1,3,336,NULL,1,0,0,0),(184,8000,1,4,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,3,336,NULL,1,0,0,0),(185,8000,1,4,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,3,336,NULL,1,0,0,0),(186,8000,1,4,1,NULL,NULL,NULL,NULL,0,0,'Dirac',0,3,336,NULL,1,0,0,0),(187,100,1,73,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(188,200,1,73,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(189,100,1,73,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(190,100,1,73,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(191,200,1,74,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(192,100,1,74,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(193,100,1,74,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(194,100,1,75,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(195,100,1,75,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(196,100,1,76,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(197,100,1,76,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(198,100,1,77,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(199,100,1,78,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(200,200,1,85,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(201,100,1,85,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(202,200,1,85,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(203,100,1,85,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(204,200,1,85,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(205,100,1,85,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(206,100,1,85,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(207,100,1,86,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(208,200,1,86,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(209,100,1,86,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(210,100,1,86,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(211,200,1,90,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(212,100,1,90,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(213,100,1,90,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(214,200,1,91,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(215,100,1,91,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(216,100,1,91,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(217,100,1,92,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(218,100,1,92,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(219,100,1,93,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(220,100,1,93,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(221,200,1,94,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(222,100,1,94,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(223,100,1,94,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(224,100,1,95,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(225,100,1,95,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(226,100,1,96,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(227,100,1,96,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(228,200,1,97,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(229,100,1,97,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(230,100,1,97,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(231,200,1,98,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(232,100,1,98,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(233,100,1,98,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(234,200,1,99,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(235,100,1,99,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(236,100,1,99,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(237,100,1,100,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(238,100,1,100,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0);
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

-- Dump completed on 2010-11-04 14:13:35
