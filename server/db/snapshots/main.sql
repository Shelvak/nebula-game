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
) ENGINE=InnoDB AUTO_INCREMENT=95 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `buildings`
--

LOCK TABLES `buildings` WRITE;
/*!40000 ALTER TABLE `buildings` DISABLE KEYS */;
INSERT INTO `buildings` VALUES (1,4,33,9,0,0,0,1,'NpcMetalExtractor',NULL,34,10,NULL,1,400,NULL,0,NULL,NULL,0),(2,4,42,21,0,0,0,1,'NpcMetalExtractor',NULL,43,22,NULL,1,400,NULL,0,NULL,NULL,0),(3,4,45,25,0,0,0,1,'NpcMetalExtractor',NULL,46,26,NULL,1,400,NULL,0,NULL,NULL,0),(4,4,37,2,0,0,0,1,'NpcMetalExtractor',NULL,38,3,NULL,1,400,NULL,0,NULL,NULL,0),(5,4,41,1,0,0,0,1,'NpcMetalExtractor',NULL,42,2,NULL,1,400,NULL,0,NULL,NULL,0),(6,4,45,4,0,0,0,1,'NpcMetalExtractor',NULL,46,5,NULL,1,400,NULL,0,NULL,NULL,0),(7,4,41,5,0,0,0,1,'NpcMetalExtractor',NULL,42,6,NULL,1,400,NULL,0,NULL,NULL,0),(8,4,36,8,0,0,0,1,'NpcResearchCenter',NULL,39,11,NULL,1,4000,NULL,0,NULL,NULL,0),(9,4,45,0,0,0,0,1,'NpcCommunicationsHub',NULL,47,1,NULL,1,1200,NULL,0,NULL,NULL,0),(10,4,44,8,0,0,0,1,'NpcExcavationSite',NULL,47,11,NULL,1,2000,NULL,0,NULL,NULL,0),(11,4,36,5,0,0,0,1,'NpcTemple',NULL,38,7,NULL,1,1500,NULL,0,NULL,NULL,0),(12,4,36,24,0,0,0,1,'NpcCommunicationsHub',NULL,38,25,NULL,1,1200,NULL,0,NULL,NULL,0),(13,4,37,26,0,0,0,1,'NpcSolarPlant',NULL,38,27,NULL,1,1000,NULL,0,NULL,NULL,0),(14,4,40,16,0,0,0,1,'NpcSolarPlant',NULL,41,17,NULL,1,1000,NULL,0,NULL,NULL,0),(15,4,40,18,0,0,0,1,'NpcSolarPlant',NULL,41,19,NULL,1,1000,NULL,0,NULL,NULL,0),(16,13,7,31,0,0,0,1,'NpcMetalExtractor',NULL,8,32,NULL,1,400,NULL,0,NULL,NULL,0),(17,13,3,31,0,0,0,1,'NpcMetalExtractor',NULL,4,32,NULL,1,400,NULL,0,NULL,NULL,0),(18,13,13,32,0,0,0,1,'NpcMetalExtractor',NULL,14,33,NULL,1,400,NULL,0,NULL,NULL,0),(19,13,23,32,0,0,0,1,'NpcMetalExtractor',NULL,24,33,NULL,1,400,NULL,0,NULL,NULL,0),(20,13,29,31,0,0,0,1,'NpcMetalExtractor',NULL,30,32,NULL,1,400,NULL,0,NULL,NULL,0),(21,13,19,6,0,0,0,1,'NpcMetalExtractor',NULL,20,7,NULL,1,400,NULL,0,NULL,NULL,0),(22,13,23,0,0,0,0,1,'NpcResearchCenter',NULL,26,3,NULL,1,4000,NULL,0,NULL,NULL,0),(23,13,32,33,0,0,0,1,'NpcCommunicationsHub',NULL,34,34,NULL,1,1200,NULL,0,NULL,NULL,0),(24,13,4,0,0,0,0,1,'NpcExcavationSite',NULL,7,3,NULL,1,2000,NULL,0,NULL,NULL,0),(25,13,32,30,0,0,0,1,'NpcTemple',NULL,34,32,NULL,1,1500,NULL,0,NULL,NULL,0),(26,13,21,0,0,0,0,1,'NpcSolarPlant',NULL,22,1,NULL,1,1000,NULL,0,NULL,NULL,0),(27,13,21,3,0,0,0,1,'NpcSolarPlant',NULL,22,4,NULL,1,1000,NULL,0,NULL,NULL,0),(28,13,0,30,0,0,0,1,'NpcSolarPlant',NULL,1,31,NULL,1,1000,NULL,0,NULL,NULL,0),(29,36,7,9,0,0,0,1,'Vulcan',NULL,8,10,NULL,1,300,NULL,0,NULL,NULL,0),(30,36,14,9,0,0,0,1,'Thunder',NULL,15,10,NULL,1,300,NULL,0,NULL,NULL,0),(31,36,21,9,0,0,0,1,'Screamer',NULL,22,10,NULL,1,300,NULL,0,NULL,NULL,0),(32,36,11,14,0,0,0,1,'Mothership',NULL,18,19,NULL,1,10500,NULL,0,NULL,NULL,0),(33,36,7,16,0,0,0,1,'Thunder',NULL,8,17,NULL,1,300,NULL,0,NULL,NULL,0),(34,36,21,16,0,0,0,1,'Thunder',NULL,22,17,NULL,1,300,NULL,0,NULL,NULL,0),(35,36,26,16,0,0,0,1,'NpcZetiumExtractor',NULL,27,17,NULL,1,800,NULL,0,NULL,NULL,0),(36,36,25,20,0,0,0,1,'NpcTemple',NULL,27,22,NULL,1,1500,NULL,0,NULL,NULL,0),(37,36,7,22,0,0,0,1,'Screamer',NULL,8,23,NULL,1,300,NULL,0,NULL,NULL,0),(38,36,14,22,0,0,0,1,'Thunder',NULL,15,23,NULL,1,300,NULL,0,NULL,NULL,0),(39,36,21,22,0,0,0,1,'Vulcan',NULL,22,23,NULL,1,300,NULL,0,NULL,NULL,0),(40,36,24,24,0,0,0,1,'NpcMetalExtractor',NULL,25,25,NULL,1,400,NULL,0,NULL,NULL,0),(41,36,28,24,0,0,0,1,'NpcMetalExtractor',NULL,29,25,NULL,1,400,NULL,0,NULL,NULL,0),(42,36,18,25,0,0,0,1,'NpcSolarPlant',NULL,19,26,NULL,1,1000,NULL,0,NULL,NULL,0),(43,36,15,26,0,0,0,1,'NpcSolarPlant',NULL,16,27,NULL,1,1000,NULL,0,NULL,NULL,0),(44,36,3,27,0,0,0,1,'NpcMetalExtractor',NULL,4,28,NULL,1,400,NULL,0,NULL,NULL,0),(45,36,12,27,0,0,0,1,'NpcSolarPlant',NULL,13,28,NULL,1,1000,NULL,0,NULL,NULL,0),(46,36,22,27,0,0,0,1,'NpcSolarPlant',NULL,23,28,NULL,1,1000,NULL,0,NULL,NULL,0),(47,36,26,27,0,0,0,1,'NpcCommunicationsHub',NULL,28,28,NULL,1,1200,NULL,0,NULL,NULL,0),(48,36,0,28,0,0,0,1,'NpcMetalExtractor',NULL,1,29,NULL,1,400,NULL,0,NULL,NULL,0),(49,36,7,28,0,0,0,1,'NpcCommunicationsHub',NULL,9,29,NULL,1,1200,NULL,0,NULL,NULL,0),(50,36,18,28,0,0,0,1,'NpcSolarPlant',NULL,19,29,NULL,1,1000,NULL,0,NULL,NULL,0),(51,39,23,1,0,0,0,1,'NpcMetalExtractor',NULL,24,2,NULL,1,400,NULL,0,NULL,NULL,0),(52,39,34,2,0,0,0,1,'NpcMetalExtractor',NULL,35,3,NULL,1,400,NULL,0,NULL,NULL,0),(53,39,16,1,0,0,0,1,'NpcMetalExtractor',NULL,17,2,NULL,1,400,NULL,0,NULL,NULL,0),(54,39,12,28,0,0,0,1,'NpcZetiumExtractor',NULL,13,29,NULL,1,800,NULL,0,NULL,NULL,0),(55,39,10,13,0,0,0,1,'NpcJumpgate',NULL,14,17,NULL,1,8000,NULL,0,NULL,NULL,0),(56,39,16,27,0,0,0,1,'NpcResearchCenter',NULL,19,30,NULL,1,4000,NULL,0,NULL,NULL,0),(57,39,19,3,0,0,0,1,'NpcCommunicationsHub',NULL,21,4,NULL,1,1200,NULL,0,NULL,NULL,0),(58,39,19,0,0,0,0,1,'NpcTemple',NULL,21,2,NULL,1,1500,NULL,0,NULL,NULL,0),(59,39,11,19,0,0,0,1,'NpcCommunicationsHub',NULL,13,20,NULL,1,1200,NULL,0,NULL,NULL,0),(60,39,37,0,0,0,0,1,'NpcSolarPlant',NULL,38,1,NULL,1,1000,NULL,0,NULL,NULL,0),(61,39,37,3,0,0,0,1,'NpcSolarPlant',NULL,38,4,NULL,1,1000,NULL,0,NULL,NULL,0),(62,39,26,1,0,0,0,1,'NpcSolarPlant',NULL,27,2,NULL,1,1000,NULL,0,NULL,NULL,0),(63,40,2,3,0,0,0,1,'NpcMetalExtractor',NULL,3,4,NULL,1,400,NULL,0,NULL,NULL,0),(64,40,22,8,0,0,0,1,'NpcMetalExtractor',NULL,23,9,NULL,1,400,NULL,0,NULL,NULL,0),(65,40,26,1,0,0,0,1,'NpcResearchCenter',NULL,29,4,NULL,1,4000,NULL,0,NULL,NULL,0),(66,40,20,1,0,0,0,1,'NpcResearchCenter',NULL,23,4,NULL,1,4000,NULL,0,NULL,NULL,0),(67,40,11,0,0,0,0,1,'NpcExcavationSite',NULL,14,3,NULL,1,2000,NULL,0,NULL,NULL,0),(68,40,12,4,0,0,0,1,'NpcTemple',NULL,14,6,NULL,1,1500,NULL,0,NULL,NULL,0),(69,40,31,5,0,0,0,1,'NpcCommunicationsHub',NULL,33,6,NULL,1,1200,NULL,0,NULL,NULL,0),(70,40,10,4,0,0,0,1,'NpcSolarPlant',NULL,11,5,NULL,1,1000,NULL,0,NULL,NULL,0),(71,40,24,0,0,0,0,1,'NpcSolarPlant',NULL,25,1,NULL,1,1000,NULL,0,NULL,NULL,0),(72,40,24,4,0,0,0,1,'NpcSolarPlant',NULL,25,5,NULL,1,1000,NULL,0,NULL,NULL,0),(73,40,24,2,0,0,0,1,'NpcSolarPlant',NULL,25,3,NULL,1,1000,NULL,0,NULL,NULL,0),(74,49,31,2,0,0,0,1,'NpcMetalExtractor',NULL,32,3,NULL,1,400,NULL,0,NULL,NULL,0),(75,49,36,25,0,0,0,1,'NpcMetalExtractor',NULL,37,26,NULL,1,400,NULL,0,NULL,NULL,0),(76,49,36,1,0,0,0,1,'NpcMetalExtractor',NULL,37,2,NULL,1,400,NULL,0,NULL,NULL,0),(77,49,35,21,0,0,0,1,'NpcMetalExtractor',NULL,36,22,NULL,1,400,NULL,0,NULL,NULL,0),(78,49,2,5,0,0,0,1,'NpcResearchCenter',NULL,5,8,NULL,1,4000,NULL,0,NULL,NULL,0),(79,49,35,33,0,0,0,1,'NpcTemple',NULL,37,35,NULL,1,1500,NULL,0,NULL,NULL,0),(80,49,2,13,0,0,0,1,'NpcCommunicationsHub',NULL,4,14,NULL,1,1200,NULL,0,NULL,NULL,0),(81,49,0,13,0,0,0,1,'NpcSolarPlant',NULL,1,14,NULL,1,1000,NULL,0,NULL,NULL,0),(82,49,38,34,0,0,0,1,'NpcSolarPlant',NULL,39,35,NULL,1,1000,NULL,0,NULL,NULL,0),(83,51,30,26,0,0,0,1,'NpcMetalExtractor',NULL,31,27,NULL,1,400,NULL,0,NULL,NULL,0),(84,51,34,15,0,0,0,1,'NpcMetalExtractor',NULL,35,16,NULL,1,400,NULL,0,NULL,NULL,0),(85,51,34,24,0,0,0,1,'NpcMetalExtractor',NULL,35,25,NULL,1,400,NULL,0,NULL,NULL,0),(86,51,34,28,0,0,0,1,'NpcMetalExtractor',NULL,35,29,NULL,1,400,NULL,0,NULL,NULL,0),(87,51,35,6,0,0,0,1,'NpcMetalExtractor',NULL,36,7,NULL,1,400,NULL,0,NULL,NULL,0),(88,51,30,5,0,0,0,1,'NpcResearchCenter',NULL,33,8,NULL,1,4000,NULL,0,NULL,NULL,0),(89,51,12,0,0,0,0,1,'NpcExcavationSite',NULL,15,3,NULL,1,2000,NULL,0,NULL,NULL,0),(90,51,30,2,0,0,0,1,'NpcCommunicationsHub',NULL,32,3,NULL,1,1200,NULL,0,NULL,NULL,0),(91,51,30,0,0,0,0,1,'NpcSolarPlant',NULL,31,1,NULL,1,1000,NULL,0,NULL,NULL,0),(92,51,31,11,0,0,0,1,'NpcSolarPlant',NULL,32,12,NULL,1,1000,NULL,0,NULL,NULL,0),(93,51,31,9,0,0,0,1,'NpcSolarPlant',NULL,32,10,NULL,1,1000,NULL,0,NULL,NULL,0),(94,51,31,19,0,0,0,1,'NpcSolarPlant',NULL,32,20,NULL,1,1000,NULL,0,NULL,NULL,0);
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
INSERT INTO `folliages` VALUES (4,0,20,10),(4,0,24,6),(4,1,10,7),(4,1,14,2),(4,1,16,2),(4,1,17,12),(4,1,21,4),(4,1,24,11),(4,1,25,4),(4,1,27,5),(4,2,14,7),(4,2,15,6),(4,2,17,1),(4,2,19,7),(4,2,20,11),(4,2,21,6),(4,3,15,0),(4,3,16,2),(4,3,18,9),(4,4,15,1),(4,5,1,3),(4,5,13,12),(4,5,15,10),(4,5,20,12),(4,5,22,11),(4,6,13,7),(4,6,26,0),(4,7,10,5),(4,7,11,0),(4,7,19,2),(4,8,11,12),(4,8,13,2),(4,8,14,7),(4,8,16,5),(4,8,22,13),(4,9,9,1),(4,9,25,9),(4,10,7,11),(4,10,11,9),(4,10,27,10),(4,11,5,12),(4,11,9,5),(4,11,17,11),(4,12,5,3),(4,12,8,5),(4,12,17,7),(4,12,27,13),(4,13,7,10),(4,13,17,11),(4,13,18,4),(4,13,19,12),(4,14,6,5),(4,14,8,11),(4,14,9,8),(4,14,18,3),(4,14,19,7),(4,14,20,6),(4,14,21,12),(4,15,8,12),(4,16,0,13),(4,16,1,7),(4,16,4,13),(4,16,6,12),(4,16,12,7),(4,16,15,11),(4,16,23,3),(4,17,0,11),(4,17,1,3),(4,17,15,12),(4,17,16,11),(4,17,18,4),(4,17,20,8),(4,17,21,3),(4,17,24,5),(4,17,27,11),(4,18,0,13),(4,18,5,4),(4,18,6,7),(4,18,7,3),(4,18,9,3),(4,18,10,13),(4,18,18,7),(4,18,20,5),(4,19,1,7),(4,19,3,2),(4,19,6,10),(4,19,7,2),(4,19,8,10),(4,20,2,11),(4,20,9,5),(4,20,12,6),(4,21,6,0),(4,21,9,5),(4,21,27,13),(4,22,0,2),(4,22,2,3),(4,22,6,6),(4,22,12,2),(4,22,13,7),(4,23,0,0),(4,23,4,13),(4,23,5,5),(4,23,11,10),(4,23,12,5),(4,23,13,8),(4,23,14,6),(4,23,16,13),(4,24,11,11),(4,24,13,13),(4,24,24,7),(4,25,9,4),(4,25,10,12),(4,25,20,0),(4,26,9,5),(4,26,12,11),(4,26,20,12),(4,28,7,4),(4,28,9,5),(4,28,20,7),(4,29,3,0),(4,29,9,2),(4,29,14,0),(4,29,16,5),(4,29,17,1),(4,29,18,6),(4,29,20,7),(4,30,3,7),(4,30,14,3),(4,30,15,7),(4,30,17,4),(4,31,5,12),(4,31,11,13),(4,32,8,6),(4,32,16,3),(4,32,27,7),(4,33,12,7),(4,33,26,13),(4,34,2,2),(4,34,5,4),(4,34,14,0),(4,34,16,10),(4,34,24,0),(4,34,26,5),(4,34,27,5),(4,35,1,0),(4,35,5,8),(4,35,7,5),(4,35,13,1),(4,35,25,1),(4,35,26,8),(4,35,27,0),(4,36,26,5),(4,37,4,7),(4,38,1,4),(4,39,1,3),(4,39,2,12),(4,39,5,7),(4,39,6,2),(4,39,25,11),(4,40,3,12),(4,40,22,5),(4,40,24,7),(4,41,23,0),(4,42,25,6),(4,42,26,1),(4,43,1,12),(4,43,2,12),(4,43,3,10),(4,43,20,3),(4,44,2,5),(4,44,3,3),(4,44,4,10),(4,44,21,10),(4,44,22,12),(4,45,27,11),(4,46,27,6),(4,47,3,4),(4,47,4,10),(4,47,27,10),(13,0,17,10),(13,0,20,6),(13,0,21,10),(13,0,23,4),(13,0,34,2),(13,1,10,9),(13,1,12,12),(13,1,22,5),(13,1,24,2),(13,1,25,6),(13,1,32,0),(13,1,33,0),(13,2,11,7),(13,2,12,3),(13,2,29,10),(13,2,33,5),(13,3,13,6),(13,3,29,12),(13,3,33,9),(13,4,4,8),(13,4,5,6),(13,4,13,13),(13,4,14,2),(13,4,22,11),(13,4,23,8),(13,4,24,3),(13,4,33,5),(13,5,20,1),(13,5,25,3),(13,6,21,10),(13,6,23,4),(13,6,30,0),(13,6,31,3),(13,7,5,7),(13,7,11,5),(13,7,12,3),(13,7,14,10),(13,7,19,10),(13,7,23,7),(13,7,25,12),(13,7,30,6),(13,8,4,13),(13,8,8,12),(13,8,11,6),(13,8,13,7),(13,8,25,7),(13,8,29,10),(13,9,8,1),(13,9,11,3),(13,9,14,11),(13,9,15,8),(13,9,18,6),(13,9,22,10),(13,9,23,6),(13,9,25,11),(13,9,26,13),(13,9,28,8),(13,9,33,13),(13,10,0,1),(13,10,9,13),(13,10,13,3),(13,10,16,5),(13,10,17,2),(13,10,19,11),(13,10,23,5),(13,10,28,3),(13,10,29,1),(13,10,30,13),(13,11,0,6),(13,11,6,0),(13,11,9,13),(13,11,13,13),(13,11,18,2),(13,11,22,7),(13,11,27,12),(13,12,4,2),(13,12,9,3),(13,12,10,8),(13,12,19,1),(13,12,21,0),(13,12,25,4),(13,12,30,4),(13,12,32,7),(13,12,33,1),(13,13,3,2),(13,13,12,7),(13,13,21,4),(13,13,24,13),(13,13,25,7),(13,13,28,5),(13,13,34,7),(13,14,10,13),(13,14,12,7),(13,14,23,5),(13,14,25,9),(13,14,28,6),(13,14,30,1),(13,15,5,12),(13,15,7,11),(13,15,11,2),(13,15,12,0),(13,15,13,9),(13,15,15,5),(13,15,23,12),(13,15,31,4),(13,16,4,7),(13,16,9,13),(13,16,12,0),(13,16,16,4),(13,16,17,13),(13,16,22,13),(13,16,24,12),(13,16,32,8),(13,17,9,8),(13,17,16,9),(13,17,18,11),(13,17,19,3),(13,17,22,10),(13,17,24,4),(13,17,29,6),(13,17,31,7),(13,18,8,3),(13,18,10,5),(13,19,19,7),(13,19,30,4),(13,20,8,2),(13,20,12,9),(13,20,15,12),(13,20,17,7),(13,20,21,8),(13,20,29,4),(13,21,8,2),(13,21,16,10),(13,21,18,3),(13,21,21,1),(13,22,8,10),(13,22,16,4),(13,22,20,8),(13,22,26,12),(13,23,4,0),(13,23,6,7),(13,23,10,1),(13,23,13,8),(13,23,17,4),(13,23,23,3),(13,23,26,0),(13,23,27,13),(13,24,5,11),(13,24,12,4),(13,24,17,12),(13,24,21,10),(13,24,22,10),(13,24,24,12),(13,24,25,12),(13,24,27,1),(13,24,29,8),(13,24,30,0),(13,25,5,3),(13,25,10,0),(13,25,13,11),(13,25,17,10),(13,25,20,7),(13,25,21,1),(13,25,23,11),(13,25,24,10),(13,26,4,1),(13,26,5,1),(13,26,6,8),(13,26,13,1),(13,26,17,5),(13,26,18,6),(13,26,24,11),(13,26,25,4),(13,26,30,4),(13,27,13,12),(13,27,19,1),(13,27,21,13),(13,27,22,9),(13,27,23,10),(13,27,25,10),(13,27,29,11),(13,27,30,13),(13,28,14,12),(13,28,17,13),(13,28,18,6),(13,28,19,2),(13,28,22,8),(13,29,17,11),(13,29,22,3),(13,29,24,0),(13,29,26,11),(13,30,8,13),(13,30,14,11),(13,30,16,7),(13,30,26,4),(13,30,28,6),(13,30,29,0),(13,30,30,3),(13,31,0,0),(13,31,11,5),(13,31,27,0),(13,32,0,2),(13,32,5,13),(13,32,14,6),(13,32,17,3),(13,32,21,3),(13,32,25,9),(13,32,29,6),(13,33,2,9),(13,33,3,5),(13,33,14,6),(13,33,18,13),(13,33,19,0),(13,34,3,3),(13,34,16,8),(13,34,19,5),(36,0,7,2),(36,0,9,8),(36,0,11,6),(36,0,12,8),(36,0,14,1),(36,1,4,11),(36,1,5,11),(36,1,15,9),(36,2,3,3),(36,2,5,6),(36,2,18,7),(36,3,2,12),(36,3,3,4),(36,3,10,9),(36,3,29,0),(36,4,4,7),(36,4,14,10),(36,4,15,2),(36,4,18,11),(36,4,19,7),(36,4,26,4),(36,4,29,1),(36,5,4,4),(36,5,15,1),(36,5,17,7),(36,5,18,6),(36,5,23,8),(36,5,24,8),(36,5,26,10),(36,5,29,0),(36,6,2,9),(36,6,25,9),(36,6,26,7),(36,6,28,12),(36,7,7,9),(36,7,24,4),(36,7,26,2),(36,7,27,0),(36,8,7,9),(36,8,18,4),(36,8,27,3),(36,9,27,7),(36,10,10,4),(36,10,20,2),(36,11,0,4),(36,11,11,7),(36,11,21,5),(36,12,7,4),(36,12,8,8),(36,12,21,6),(36,13,0,6),(36,13,1,7),(36,13,2,6),(36,13,3,6),(36,13,4,0),(36,13,7,4),(36,13,8,8),(36,13,9,11),(36,13,13,9),(36,13,22,8),(36,13,23,5),(36,14,6,6),(36,14,8,7),(36,14,12,4),(36,14,21,6),(36,14,24,0),(36,15,1,7),(36,15,2,8),(36,15,13,7),(36,15,24,5),(36,16,1,2),(36,16,3,7),(36,16,4,13),(36,16,6,11),(36,16,7,11),(36,16,10,4),(36,16,20,6),(36,16,24,7),(36,16,25,11),(36,19,7,8),(36,19,8,3),(36,19,11,8),(36,19,12,2),(36,19,13,3),(36,19,14,3),(36,19,15,1),(36,19,16,4),(36,20,5,9),(36,20,13,5),(36,20,22,8),(36,21,5,11),(36,21,7,7),(36,21,8,13),(36,21,11,6),(36,21,13,10),(36,21,20,4),(36,22,11,9),(36,22,12,11),(36,22,15,5),(36,22,21,5),(36,22,25,8),(36,23,6,5),(36,23,11,7),(36,23,13,2),(36,23,21,8),(36,23,25,9),(36,24,5,6),(36,24,8,5),(36,24,10,4),(36,24,14,10),(36,24,15,8),(36,24,29,9),(36,25,1,1),(36,25,4,10),(36,25,8,10),(36,25,10,2),(36,25,18,4),(36,26,4,6),(36,26,9,3),(36,26,14,5),(36,26,24,4),(36,27,0,2),(36,27,3,9),(36,27,13,2),(36,27,15,9),(36,27,26,8),(36,28,26,3),(36,29,14,5),(36,29,15,7),(39,0,0,0),(39,0,2,2),(39,0,5,4),(39,0,6,4),(39,0,7,3),(39,0,8,0),(39,0,13,12),(39,0,15,3),(39,0,16,4),(39,0,23,7),(39,0,27,1),(39,0,29,6),(39,1,11,5),(39,1,12,3),(39,1,20,5),(39,1,25,6),(39,2,5,10),(39,2,8,1),(39,2,21,12),(39,3,5,11),(39,3,6,7),(39,3,12,0),(39,3,19,2),(39,3,23,11),(39,4,6,2),(39,4,8,4),(39,4,10,1),(39,4,19,4),(39,4,28,6),(39,5,9,12),(39,5,20,0),(39,5,27,6),(39,5,28,13),(39,5,29,2),(39,6,4,1),(39,6,10,10),(39,6,17,5),(39,6,20,12),(39,7,3,5),(39,7,10,6),(39,7,16,7),(39,7,17,4),(39,7,18,13),(39,7,22,1),(39,7,24,9),(39,7,26,5),(39,8,3,1),(39,8,4,4),(39,8,5,7),(39,8,12,1),(39,8,19,11),(39,8,20,0),(39,8,24,0),(39,9,1,11),(39,9,2,0),(39,9,3,12),(39,9,7,1),(39,9,8,7),(39,9,14,4),(39,9,28,5),(39,10,4,5),(39,10,6,6),(39,10,27,13),(39,10,29,11),(39,11,4,6),(39,12,5,1),(39,12,30,7),(39,16,19,5),(39,17,3,2),(39,18,13,5),(39,18,23,4),(39,19,8,2),(39,19,9,11),(39,19,11,10),(39,19,13,10),(39,20,12,6),(39,20,19,4),(39,20,20,0),(39,20,21,1),(39,20,22,4),(39,21,18,5),(39,22,10,2),(39,22,11,2),(39,22,12,3),(39,22,13,13),(39,22,14,6),(39,22,18,2),(39,22,21,2),(39,22,23,4),(39,23,11,1),(39,23,17,10),(39,23,18,5),(39,23,19,3),(39,23,25,5),(39,24,7,5),(39,24,12,4),(39,24,13,1),(39,24,18,10),(39,24,24,3),(39,24,26,2),(39,25,12,4),(39,25,24,13),(39,25,26,2),(39,26,13,4),(39,26,14,6),(39,26,16,5),(39,26,17,6),(39,26,20,5),(39,26,24,0),(39,26,28,5),(39,26,29,2),(39,27,12,3),(39,27,17,0),(39,27,18,3),(39,27,20,6),(39,27,25,0),(39,28,13,3),(39,28,15,11),(39,28,16,12),(39,28,17,3),(39,28,27,12),(39,29,1,4),(39,29,13,11),(39,29,15,4),(39,29,18,3),(39,29,25,4),(39,29,27,8),(39,29,29,7),(39,29,30,12),(39,30,4,11),(39,30,13,0),(39,30,16,2),(39,30,18,5),(39,30,20,10),(39,30,23,10),(39,30,24,4),(39,30,25,10),(39,30,26,3),(39,30,27,4),(39,30,30,13),(39,31,4,0),(39,31,13,10),(39,31,19,12),(39,31,22,6),(39,31,23,2),(39,31,26,10),(39,31,27,4),(39,31,28,13),(39,31,29,6),(39,32,7,10),(39,32,8,13),(39,32,11,7),(39,32,20,4),(39,33,20,7),(39,33,29,2),(39,34,4,7),(39,34,8,2),(39,34,11,1),(39,34,15,6),(39,34,20,12),(39,34,21,4),(39,35,10,4),(39,35,12,12),(39,35,15,13),(39,35,16,0),(39,35,18,11),(39,35,19,2),(39,35,22,4),(39,35,24,7),(39,36,9,0),(39,36,10,7),(39,36,23,9),(39,36,29,10),(39,37,8,13),(39,37,10,5),(39,37,14,7),(39,37,16,4),(39,37,18,5),(39,37,22,1),(39,37,25,7),(39,37,26,10),(39,37,30,12),(39,38,16,6),(39,38,18,1),(39,38,19,6),(39,38,29,12),(39,38,30,5),(40,0,2,4),(40,0,8,10),(40,0,9,8),(40,0,12,3),(40,0,15,1),(40,0,16,9),(40,0,24,9),(40,0,28,1),(40,0,32,8),(40,0,35,6),(40,1,4,4),(40,1,13,13),(40,1,14,1),(40,1,28,3),(40,1,34,1),(40,1,36,1),(40,2,10,6),(40,2,12,3),(40,2,14,2),(40,2,27,1),(40,2,28,10),(40,3,6,2),(40,3,9,6),(40,3,14,1),(40,3,33,6),(40,3,35,10),(40,3,36,11),(40,4,4,1),(40,4,5,0),(40,4,8,6),(40,4,9,7),(40,4,12,8),(40,4,13,2),(40,4,20,9),(40,4,22,1),(40,4,35,5),(40,5,4,10),(40,5,7,3),(40,5,11,8),(40,5,12,10),(40,5,18,3),(40,5,30,7),(40,6,1,2),(40,6,4,9),(40,6,7,11),(40,6,9,9),(40,6,25,7),(40,6,27,5),(40,6,32,1),(40,7,1,11),(40,7,9,2),(40,7,12,3),(40,7,13,5),(40,7,16,8),(40,7,17,6),(40,7,31,10),(40,7,32,4),(40,7,36,6),(40,8,1,9),(40,8,5,10),(40,8,7,7),(40,8,8,2),(40,8,10,6),(40,8,12,2),(40,8,25,12),(40,8,31,3),(40,8,33,6),(40,8,36,1),(40,9,5,4),(40,9,9,6),(40,9,11,9),(40,9,20,9),(40,9,23,11),(40,9,35,5),(40,10,3,3),(40,10,9,12),(40,10,11,9),(40,10,18,5),(40,10,23,11),(40,10,24,3),(40,10,33,2),(40,10,35,1),(40,11,6,8),(40,11,10,7),(40,11,12,3),(40,11,15,1),(40,11,19,10),(40,11,26,9),(40,12,14,3),(40,12,15,11),(40,12,18,2),(40,12,19,10),(40,12,20,2),(40,12,21,1),(40,12,25,8),(40,12,27,7),(40,12,30,1),(40,12,34,8),(40,13,9,4),(40,13,15,3),(40,13,16,12),(40,13,19,7),(40,13,21,0),(40,13,22,13),(40,13,23,9),(40,13,24,2),(40,13,25,7),(40,13,27,3),(40,13,29,13),(40,13,34,8),(40,14,13,2),(40,14,14,2),(40,14,17,9),(40,14,18,4),(40,14,19,4),(40,14,20,0),(40,14,21,7),(40,14,27,8),(40,14,28,2),(40,15,7,6),(40,15,11,4),(40,15,26,6),(40,16,12,11),(40,16,24,1),(40,16,25,9),(40,16,30,8),(40,17,6,11),(40,17,21,5),(40,17,34,8),(40,18,22,1),(40,18,23,10),(40,18,27,2),(40,18,33,3),(40,19,13,1),(40,19,18,1),(40,19,29,8),(40,19,36,0),(40,20,17,5),(40,20,18,3),(40,20,22,1),(40,20,26,3),(40,20,27,10),(40,20,28,6),(40,20,32,10),(40,21,14,2),(40,21,17,1),(40,21,20,1),(40,21,22,3),(40,21,24,12),(40,21,28,10),(40,21,31,1),(40,21,32,4),(40,21,34,12),(40,22,0,0),(40,22,11,5),(40,22,14,11),(40,23,10,10),(40,23,11,4),(40,23,13,0),(40,23,15,11),(40,23,19,12),(40,23,23,7),(40,23,25,3),(40,23,29,6),(40,23,30,4),(40,23,33,0),(40,24,11,4),(40,24,16,4),(40,24,21,8),(40,24,24,0),(40,24,36,1),(40,25,7,5),(40,25,8,3),(40,25,16,5),(40,25,21,4),(40,25,23,7),(40,25,28,4),(40,26,0,2),(40,26,5,1),(40,26,9,11),(40,26,10,2),(40,26,18,8),(40,26,20,9),(40,26,22,9),(40,26,25,2),(40,26,26,8),(40,26,27,8),(40,27,11,12),(40,27,22,6),(40,28,0,4),(40,28,12,8),(40,28,16,2),(40,28,18,12),(40,28,19,2),(40,28,22,7),(40,28,24,7),(40,29,0,9),(40,29,5,5),(40,29,10,2),(40,29,11,7),(40,29,14,7),(40,29,17,0),(40,29,18,1),(40,29,21,8),(40,29,23,11),(40,29,32,13),(40,30,15,11),(40,30,16,10),(40,30,23,4),(40,30,24,11),(40,30,25,4),(40,31,16,0),(40,31,19,6),(40,31,20,6),(40,31,22,5),(40,32,1,2),(40,32,14,7),(40,32,17,2),(40,32,22,6),(40,32,23,12),(40,32,25,3),(40,33,2,2),(40,33,3,3),(40,33,7,6),(40,33,8,5),(40,33,10,4),(40,33,14,6),(40,33,16,1),(49,0,0,10),(49,0,21,0),(49,0,23,9),(49,1,17,3),(49,2,17,2),(49,3,18,6),(49,4,1,10),(49,4,2,11),(49,4,21,10),(49,4,23,3),(49,6,20,11),(49,6,28,1),(49,6,30,6),(49,6,35,11),(49,7,13,6),(49,7,23,1),(49,8,12,6),(49,8,24,1),(49,8,27,5),(49,8,31,12),(49,8,34,5),(49,9,0,12),(49,9,10,8),(49,9,12,6),(49,9,22,0),(49,9,24,2),(49,9,28,0),(49,9,33,2),(49,10,12,0),(49,10,15,4),(49,10,16,7),(49,10,17,7),(49,10,23,0),(49,10,24,10),(49,10,26,3),(49,10,29,6),(49,11,5,4),(49,11,6,10),(49,11,13,0),(49,11,24,2),(49,12,12,8),(49,12,13,11),(49,12,14,1),(49,12,15,10),(49,12,19,13),(49,12,23,3),(49,12,24,6),(49,13,4,1),(49,13,12,0),(49,13,13,6),(49,13,16,4),(49,13,17,5),(49,13,18,2),(49,13,19,11),(49,13,25,13),(49,13,30,11),(49,13,31,0),(49,13,35,10),(49,14,5,7),(49,14,30,3),(49,14,34,4),(49,15,0,4),(49,15,1,11),(49,15,4,8),(49,15,11,12),(49,15,18,7),(49,15,19,1),(49,15,23,5),(49,15,31,3),(49,15,32,3),(49,16,0,6),(49,16,3,0),(49,16,4,7),(49,16,5,12),(49,16,7,10),(49,16,10,2),(49,16,11,7),(49,16,13,13),(49,16,16,13),(49,16,17,3),(49,16,19,5),(49,16,26,3),(49,16,35,8),(49,17,2,0),(49,17,3,3),(49,17,11,11),(49,17,12,7),(49,17,20,4),(49,17,21,8),(49,17,35,7),(49,18,0,13),(49,18,3,1),(49,18,4,13),(49,18,14,0),(49,18,15,8),(49,18,20,12),(49,18,24,13),(49,18,28,13),(49,18,29,11),(49,18,33,12),(49,18,34,13),(49,19,0,5),(49,19,3,7),(49,19,14,5),(49,19,19,11),(49,19,20,10),(49,19,21,0),(49,19,28,5),(49,19,34,5),(49,19,35,4),(49,20,9,1),(49,20,10,11),(49,20,12,3),(49,20,18,4),(49,20,23,2),(49,20,24,4),(49,20,32,3),(49,21,8,4),(49,21,16,11),(49,21,17,3),(49,21,19,5),(49,21,30,3),(49,21,35,13),(49,22,15,10),(49,22,18,2),(49,22,35,1),(49,23,8,3),(49,23,13,4),(49,23,17,4),(49,23,22,2),(49,23,23,5),(49,24,9,1),(49,24,14,3),(49,24,16,13),(49,24,17,6),(49,24,20,3),(49,25,6,5),(49,25,17,6),(49,25,18,12),(49,25,20,12),(49,25,21,10),(49,25,35,0),(49,26,16,10),(49,26,22,0),(49,26,34,12),(49,27,4,12),(49,27,10,12),(49,27,18,13),(49,27,30,0),(49,28,9,11),(49,28,22,8),(49,28,31,10),(49,29,5,10),(49,29,7,0),(49,29,21,6),(49,29,24,12),(49,29,35,5),(49,31,4,6),(49,31,12,12),(49,31,32,7),(49,32,0,1),(49,32,1,1),(49,32,4,13),(49,32,10,0),(49,32,32,13),(49,33,8,4),(49,33,22,4),(49,33,32,10),(49,34,8,5),(49,34,17,7),(49,35,17,4),(49,36,3,11),(49,36,9,13),(49,36,20,1),(49,37,10,13),(49,37,13,4),(49,37,16,13),(49,38,12,11),(49,38,13,9),(49,38,26,7),(49,38,27,5),(49,38,29,9),(49,39,17,1),(49,39,28,6),(49,39,29,8),(51,0,2,8),(51,0,4,5),(51,0,5,8),(51,0,13,7),(51,0,16,11),(51,0,19,3),(51,0,28,10),(51,1,1,2),(51,1,3,7),(51,1,5,2),(51,1,8,7),(51,1,10,3),(51,1,12,4),(51,1,13,4),(51,1,16,11),(51,1,18,9),(51,1,20,13),(51,1,29,13),(51,1,30,2),(51,2,1,3),(51,2,12,3),(51,2,14,1),(51,2,15,2),(51,2,16,0),(51,2,18,11),(51,2,20,9),(51,2,25,3),(51,3,0,1),(51,3,3,4),(51,3,4,0),(51,3,7,3),(51,3,11,10),(51,3,17,2),(51,3,18,8),(51,3,22,6),(51,3,27,8),(51,3,30,6),(51,4,2,10),(51,4,12,2),(51,4,13,12),(51,4,15,3),(51,4,16,2),(51,4,17,10),(51,4,18,6),(51,4,26,6),(51,4,29,2),(51,4,30,10),(51,5,0,2),(51,5,3,8),(51,5,4,1),(51,5,5,2),(51,5,6,12),(51,5,17,6),(51,5,20,11),(51,5,22,6),(51,5,26,9),(51,6,2,2),(51,6,6,3),(51,6,15,13),(51,6,17,2),(51,6,19,4),(51,6,23,4),(51,7,1,4),(51,7,3,5),(51,7,14,5),(51,7,15,9),(51,7,23,2),(51,7,24,0),(51,7,25,5),(51,8,0,8),(51,8,2,9),(51,8,5,0),(51,8,10,8),(51,8,12,5),(51,8,13,3),(51,8,17,11),(51,8,24,7),(51,8,25,1),(51,8,26,4),(51,8,30,4),(51,9,2,8),(51,9,3,0),(51,9,9,5),(51,9,14,7),(51,10,0,10),(51,10,2,11),(51,10,15,9),(51,10,23,12),(51,10,25,3),(51,11,0,2),(51,11,2,1),(51,11,3,1),(51,11,5,12),(51,11,7,7),(51,11,8,2),(51,11,10,10),(51,11,25,7),(51,11,30,0),(51,12,5,11),(51,12,20,3),(51,12,21,11),(51,12,27,3),(51,12,30,9),(51,13,10,12),(51,13,27,9),(51,14,5,9),(51,14,17,6),(51,14,25,5),(51,14,29,10),(51,14,30,5),(51,15,28,2),(51,16,14,8),(51,16,26,8),(51,17,14,4),(51,17,27,7),(51,18,14,6),(51,18,25,3),(51,18,30,4),(51,19,15,10),(51,19,19,0),(51,19,28,12),(51,20,26,6),(51,20,27,4),(51,21,14,1),(51,21,26,8),(51,21,28,1),(51,21,29,4),(51,23,18,2),(51,24,13,3),(51,24,27,7),(51,26,12,10),(51,26,17,3),(51,26,28,7),(51,26,29,11),(51,26,30,4),(51,27,13,10),(51,27,28,1),(51,28,12,6),(51,28,13,0),(51,28,15,5),(51,29,12,2),(51,29,13,5),(51,29,14,6),(51,29,15,6),(51,29,17,4),(51,30,16,10),(51,30,18,13),(51,30,30,11),(51,31,13,8),(51,31,17,2),(51,31,18,9),(51,31,29,5),(51,32,0,8),(51,32,17,6),(51,32,24,10),(51,32,26,9),(51,32,28,10),(51,32,29,12),(51,33,0,8),(51,33,1,2),(51,33,9,1),(51,33,10,3),(51,33,19,5),(51,33,24,9),(51,33,28,5),(51,33,30,6),(51,34,8,10),(51,34,27,13),(51,35,22,10),(51,36,1,6),(51,36,22,7),(51,36,25,1),(51,36,29,8),(51,37,0,6),(51,37,1,1),(51,37,2,10),(51,37,23,13),(51,37,29,5);
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
INSERT INTO `galaxies` VALUES (1,'2010-11-16 17:23:41','dev');
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
INSERT INTO `solar_systems` VALUES (1,'Expansion',1,2,1),(2,'Resource',1,0,2),(3,'Homeworld',1,2,0),(4,'Expansion',1,1,0);
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
) ENGINE=InnoDB AUTO_INCREMENT=54 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ss_objects`
--

LOCK TABLES `ss_objects` WRITE;
/*!40000 ALTER TABLE `ss_objects` DISABLE KEYS */;
INSERT INTO `ss_objects` VALUES (1,1,0,0,1,45,'Asteroid',NULL,'',39,0,0,0,1,0,0,1,0,0,2,NULL,0),(2,1,0,0,1,225,'Asteroid',NULL,'',33,0,0,0,3,0,0,1,0,0,1,NULL,0),(3,1,0,0,2,90,'Asteroid',NULL,'',54,0,0,0,1,0,0,2,0,0,1,NULL,0),(4,1,48,28,2,120,'Planet',NULL,'P-4',56,2,0,0,0,0,0,0,0,0,0,'2010-11-16 17:23:48',0),(5,1,0,0,3,22,'Jumpgate',NULL,'',49,0,0,0,0,0,0,0,0,0,0,NULL,0),(6,1,0,0,1,180,'Asteroid',NULL,'',33,0,0,0,1,0,0,0,0,0,1,NULL,0),(7,1,0,0,2,240,'Asteroid',NULL,'',42,0,0,0,3,0,0,2,0,0,2,NULL,0),(8,1,0,0,1,315,'Asteroid',NULL,'',31,0,0,0,3,0,0,3,0,0,1,NULL,0),(9,1,0,0,1,0,'Asteroid',NULL,'',53,0,0,0,1,0,0,1,0,0,2,NULL,0),(10,1,0,0,2,60,'Asteroid',NULL,'',48,0,0,0,1,0,0,1,0,0,1,NULL,0),(11,1,0,0,3,44,'Jumpgate',NULL,'',31,0,0,0,0,0,0,0,0,0,0,NULL,0),(12,1,0,0,2,30,'Asteroid',NULL,'',48,0,0,0,1,0,0,0,0,0,1,NULL,0),(13,1,35,35,1,135,'Planet',NULL,'P-13',54,2,0,0,0,0,0,0,0,0,0,'2010-11-16 17:23:48',0),(14,1,0,0,2,180,'Asteroid',NULL,'',57,0,0,0,0,0,0,0,0,0,0,NULL,0),(15,1,0,0,0,270,'Asteroid',NULL,'',51,0,0,0,2,0,0,1,0,0,2,NULL,0),(16,1,0,0,2,270,'Asteroid',NULL,'',37,0,0,0,0,0,0,1,0,0,0,NULL,0),(17,1,0,0,0,180,'Asteroid',NULL,'',48,0,0,0,1,0,0,1,0,0,1,NULL,0),(18,1,0,0,2,300,'Asteroid',NULL,'',50,0,0,0,0,0,0,1,0,0,0,NULL,0),(19,1,0,0,0,0,'Asteroid',NULL,'',35,0,0,0,1,0,0,0,0,0,1,NULL,0),(20,2,0,0,1,45,'Asteroid',NULL,'',49,0,0,0,2,0,0,3,0,0,2,NULL,0),(21,2,0,0,3,180,'Jumpgate',NULL,'',36,0,0,0,0,0,0,0,0,0,0,NULL,0),(22,2,0,0,3,22,'Jumpgate',NULL,'',26,0,0,0,0,0,0,0,0,0,0,NULL,0),(23,2,0,0,1,180,'Asteroid',NULL,'',46,0,0,0,1,0,0,2,0,0,2,NULL,0),(24,2,0,0,0,270,'Asteroid',NULL,'',52,0,0,0,1,0,0,3,0,0,1,NULL,0),(25,2,0,0,1,315,'Asteroid',NULL,'',57,0,0,0,3,0,0,2,0,0,3,NULL,0),(26,2,0,0,2,240,'Asteroid',NULL,'',30,0,0,0,1,0,0,1,0,0,0,NULL,0),(27,2,0,0,3,90,'Jumpgate',NULL,'',38,0,0,0,0,0,0,0,0,0,0,NULL,0),(28,2,0,0,2,270,'Asteroid',NULL,'',48,0,0,0,1,0,0,0,0,0,0,NULL,0),(29,2,0,0,0,180,'Asteroid',NULL,'',26,0,0,0,0,0,0,1,0,0,0,NULL,0),(30,2,0,0,1,0,'Asteroid',NULL,'',54,0,0,0,0,0,0,0,0,0,1,NULL,0),(31,2,0,0,2,300,'Asteroid',NULL,'',59,0,0,0,3,0,0,1,0,0,2,NULL,0),(32,3,0,0,1,45,'Asteroid',NULL,'',31,0,0,0,0,0,0,0,0,0,0,NULL,0),(33,3,0,0,1,225,'Asteroid',NULL,'',51,0,0,0,1,0,0,0,0,0,1,NULL,0),(34,3,0,0,1,135,'Asteroid',NULL,'',49,0,0,0,1,0,0,1,0,0,0,NULL,0),(35,3,0,0,1,180,'Asteroid',NULL,'',27,0,0,0,0,0,0,0,0,0,1,NULL,0),(36,3,30,30,2,330,'Planet',1,'P-36',50,0,864,1,3024,1728,2,6048,0,0,604.8,'2010-11-16 17:23:48',0),(37,3,0,0,3,336,'Jumpgate',NULL,'',26,0,0,0,0,0,0,0,0,0,0,NULL,0),(38,3,0,0,2,270,'Asteroid',NULL,'',31,0,0,0,0,0,0,0,0,0,1,NULL,0),(39,3,39,31,1,0,'Planet',NULL,'P-39',54,2,0,0,0,0,0,0,0,0,0,'2010-11-16 17:23:48',0),(40,4,34,37,1,225,'Planet',NULL,'P-40',54,0,0,0,0,0,0,0,0,0,0,'2010-11-16 17:23:48',0),(41,4,0,0,1,180,'Asteroid',NULL,'',37,0,0,0,1,0,0,3,0,0,1,NULL,0),(42,4,0,0,3,202,'Jumpgate',NULL,'',26,0,0,0,0,0,0,0,0,0,0,NULL,0),(43,4,0,0,3,292,'Jumpgate',NULL,'',41,0,0,0,0,0,0,0,0,0,0,NULL,0),(44,4,0,0,1,0,'Asteroid',NULL,'',31,0,0,0,1,0,0,1,0,0,1,NULL,0),(45,4,0,0,1,270,'Asteroid',NULL,'',43,0,0,0,0,0,0,1,0,0,1,NULL,0),(46,4,0,0,2,30,'Asteroid',NULL,'',26,0,0,0,3,0,0,1,0,0,2,NULL,0),(47,4,0,0,1,135,'Asteroid',NULL,'',27,0,0,0,0,0,0,0,0,0,1,NULL,0),(48,4,0,0,0,90,'Asteroid',NULL,'',39,0,0,0,3,0,0,1,0,0,1,NULL,0),(49,4,40,36,2,330,'Planet',NULL,'P-49',56,2,0,0,0,0,0,0,0,0,0,'2010-11-16 17:23:48',0),(50,4,0,0,2,0,'Asteroid',NULL,'',32,0,0,0,1,0,0,1,0,0,2,NULL,0),(51,4,38,31,0,180,'Planet',NULL,'P-51',54,0,0,0,0,0,0,0,0,0,0,'2010-11-16 17:23:48',0),(52,4,0,0,2,300,'Asteroid',NULL,'',30,0,0,0,1,0,0,0,0,0,0,NULL,0),(53,4,0,0,0,0,'Asteroid',NULL,'',40,0,0,0,2,0,0,1,0,0,3,NULL,0);
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
INSERT INTO `tiles` VALUES (3,4,0,0),(3,4,0,1),(3,4,0,2),(3,4,0,3),(3,4,0,4),(3,4,0,5),(3,4,0,6),(3,4,0,7),(3,4,0,8),(3,4,1,1),(6,4,1,2),(6,4,1,3),(3,4,1,4),(3,4,1,5),(3,4,1,6),(5,4,1,7),(5,4,1,8),(5,4,1,9),(4,4,1,26),(3,4,2,0),(3,4,2,1),(6,4,2,2),(6,4,2,3),(3,4,2,4),(3,4,2,5),(3,4,2,6),(3,4,2,7),(5,4,2,8),(5,4,2,9),(5,4,2,10),(4,4,2,25),(4,4,2,26),(4,4,2,27),(3,4,3,0),(6,4,3,2),(3,4,3,3),(3,4,3,4),(3,4,3,5),(3,4,3,6),(5,4,3,7),(5,4,3,8),(5,4,3,9),(5,4,3,10),(5,4,3,11),(4,4,3,24),(4,4,3,25),(4,4,3,26),(6,4,4,1),(6,4,4,2),(6,4,4,3),(3,4,4,4),(3,4,4,5),(3,4,4,6),(3,4,4,7),(5,4,4,9),(5,4,4,10),(5,4,4,11),(4,4,4,18),(4,4,4,23),(4,4,4,24),(4,4,4,25),(4,4,4,26),(4,4,4,27),(6,4,5,3),(3,4,5,4),(3,4,5,5),(3,4,5,6),(5,4,5,7),(5,4,5,8),(5,4,5,9),(4,4,5,17),(4,4,5,18),(4,4,5,24),(4,4,5,25),(4,4,5,26),(4,4,5,27),(5,4,6,1),(5,4,6,2),(5,4,6,3),(3,4,6,4),(3,4,6,6),(6,4,6,7),(5,4,6,8),(4,4,6,15),(4,4,6,16),(4,4,6,17),(4,4,6,18),(4,4,6,19),(4,4,6,20),(4,4,6,21),(4,4,6,22),(5,4,6,23),(5,4,6,24),(4,4,6,25),(4,4,6,27),(5,4,7,0),(5,4,7,1),(5,4,7,2),(3,4,7,4),(3,4,7,6),(6,4,7,7),(6,4,7,8),(6,4,7,9),(4,4,7,16),(4,4,7,17),(4,4,7,18),(5,4,7,23),(5,4,7,24),(5,4,7,25),(5,4,7,26),(5,4,7,27),(5,4,8,0),(5,4,8,1),(5,4,8,2),(5,4,8,3),(3,4,8,4),(6,4,8,7),(6,4,8,8),(6,4,8,9),(6,4,8,10),(4,4,8,18),(4,4,8,19),(5,4,8,21),(5,4,8,24),(5,4,8,26),(5,4,8,27),(5,4,9,0),(5,4,9,2),(5,4,9,3),(6,4,9,10),(5,4,9,15),(5,4,9,16),(4,4,9,18),(4,4,9,19),(5,4,9,20),(5,4,9,21),(5,4,9,22),(5,4,9,24),(5,4,9,26),(5,4,9,27),(5,4,10,0),(5,4,10,2),(5,4,10,3),(5,4,10,4),(5,4,10,14),(5,4,10,15),(5,4,10,16),(5,4,10,18),(5,4,10,19),(5,4,10,20),(5,4,10,21),(5,4,10,22),(5,4,10,24),(3,4,10,25),(5,4,10,26),(5,4,11,3),(5,4,11,12),(5,4,11,13),(5,4,11,14),(5,4,11,15),(5,4,11,16),(5,4,11,18),(5,4,11,19),(5,4,11,20),(5,4,11,21),(5,4,11,22),(5,4,11,23),(5,4,11,24),(3,4,11,25),(5,4,11,26),(4,4,12,10),(5,4,12,12),(5,4,12,13),(5,4,12,14),(5,4,12,18),(5,4,12,19),(5,4,12,21),(5,4,12,22),(3,4,12,23),(3,4,12,24),(3,4,12,25),(3,4,12,26),(4,4,13,8),(4,4,13,9),(4,4,13,10),(4,4,13,11),(5,4,13,13),(5,4,13,14),(5,4,13,15),(5,4,13,16),(3,4,13,21),(3,4,13,22),(3,4,13,23),(3,4,13,24),(3,4,13,25),(3,4,13,26),(3,4,13,27),(4,4,14,10),(4,4,14,11),(4,4,14,12),(5,4,14,13),(4,4,14,14),(3,4,14,22),(3,4,14,23),(3,4,14,24),(3,4,14,25),(3,4,14,26),(3,4,14,27),(4,4,15,11),(4,4,15,12),(4,4,15,13),(4,4,15,14),(4,4,15,15),(4,4,15,16),(3,4,15,20),(3,4,15,21),(3,4,15,22),(3,4,15,23),(3,4,15,24),(3,4,15,25),(3,4,15,26),(4,4,16,11),(4,4,16,14),(3,4,16,21),(3,4,16,22),(3,4,16,24),(3,4,16,25),(3,4,16,26),(3,4,16,27),(4,4,17,14),(3,4,17,26),(3,4,18,26),(3,4,18,27),(12,4,19,18),(3,4,19,26),(6,4,20,14),(6,4,20,15),(3,4,21,3),(6,4,21,12),(6,4,21,13),(6,4,21,14),(6,4,21,15),(6,4,21,16),(3,4,22,3),(6,4,22,15),(3,4,23,1),(3,4,23,2),(3,4,23,3),(6,4,23,15),(3,4,24,0),(3,4,24,1),(3,4,24,2),(3,4,24,4),(3,4,24,6),(4,4,24,26),(3,4,25,0),(3,4,25,1),(3,4,25,2),(3,4,25,3),(3,4,25,4),(3,4,25,5),(3,4,25,6),(3,4,25,7),(10,4,25,16),(9,4,25,21),(4,4,25,24),(4,4,25,25),(4,4,25,26),(3,4,26,0),(3,4,26,1),(3,4,26,2),(3,4,26,3),(3,4,26,4),(3,4,26,5),(8,4,26,13),(4,4,26,24),(4,4,26,25),(4,4,26,26),(3,4,27,0),(3,4,27,1),(3,4,27,2),(3,4,27,3),(3,4,27,4),(4,4,27,24),(8,4,27,25),(3,4,28,0),(3,4,28,1),(3,4,28,2),(4,4,28,24),(3,4,29,0),(3,4,29,1),(6,4,29,2),(4,4,29,21),(4,4,29,22),(4,4,29,23),(4,4,29,24),(3,4,30,0),(3,4,30,1),(6,4,30,2),(12,4,30,18),(4,4,30,24),(4,4,30,25),(6,4,31,0),(6,4,31,1),(6,4,31,2),(4,4,31,24),(4,4,31,25),(6,4,32,0),(6,4,32,2),(4,4,32,25),(6,4,33,2),(6,4,33,3),(0,4,33,9),(11,4,36,12),(11,4,36,18),(0,4,37,2),(6,4,40,8),(6,4,40,9),(4,4,40,11),(4,4,40,12),(4,4,40,13),(4,4,40,14),(4,4,40,15),(0,4,40,25),(0,4,41,1),(0,4,41,5),(6,4,41,7),(6,4,41,8),(2,4,41,9),(4,4,41,11),(4,4,41,12),(1,4,41,13),(4,4,41,15),(6,4,42,7),(6,4,42,8),(4,4,42,11),(4,4,42,12),(4,4,42,15),(13,4,42,16),(13,4,42,18),(0,4,42,21),(6,4,43,6),(6,4,43,7),(6,4,43,8),(4,4,43,9),(4,4,43,10),(4,4,43,11),(4,4,43,12),(4,4,43,13),(4,4,43,14),(4,4,43,15),(9,4,44,12),(0,4,45,4),(14,4,45,20),(0,4,45,25),(10,13,0,0),(3,13,0,4),(3,13,0,5),(3,13,0,6),(3,13,0,8),(3,13,0,9),(3,13,0,10),(6,13,0,25),(6,13,0,26),(6,13,0,27),(6,13,0,28),(3,13,1,4),(3,13,1,5),(3,13,1,6),(3,13,1,7),(3,13,1,8),(4,13,1,9),(3,13,1,17),(6,13,1,19),(6,13,1,26),(6,13,1,27),(6,13,1,28),(3,13,2,4),(3,13,2,5),(3,13,2,6),(3,13,2,7),(3,13,2,8),(4,13,2,9),(3,13,2,17),(6,13,2,18),(6,13,2,19),(6,13,2,20),(6,13,2,21),(6,13,2,27),(6,13,2,28),(3,13,3,6),(3,13,3,7),(4,13,3,8),(4,13,3,9),(4,13,3,10),(3,13,3,17),(6,13,3,18),(6,13,3,19),(6,13,3,20),(6,13,3,21),(6,13,3,25),(6,13,3,26),(6,13,3,27),(0,13,3,31),(4,13,4,6),(4,13,4,7),(4,13,4,9),(4,13,4,10),(3,13,4,17),(6,13,4,18),(6,13,4,19),(0,13,4,27),(3,13,4,34),(4,13,5,6),(4,13,5,7),(4,13,5,8),(4,13,5,9),(4,13,5,10),(3,13,5,15),(3,13,5,16),(3,13,5,17),(6,13,5,18),(3,13,5,33),(3,13,5,34),(4,13,6,5),(4,13,6,6),(4,13,6,7),(4,13,6,8),(4,13,6,9),(4,13,6,10),(4,13,6,11),(3,13,6,13),(3,13,6,14),(3,13,6,15),(3,13,6,17),(3,13,6,18),(3,13,6,34),(4,13,7,6),(4,13,7,7),(4,13,7,8),(4,13,7,9),(3,13,7,15),(3,13,7,16),(3,13,7,17),(3,13,7,18),(0,13,7,31),(3,13,7,33),(3,13,7,34),(4,13,8,7),(3,13,8,14),(3,13,8,15),(3,13,8,33),(3,13,8,34),(2,13,9,1),(3,13,9,34),(3,13,10,31),(3,13,10,32),(3,13,10,33),(3,13,10,34),(3,13,11,31),(3,13,11,32),(3,13,11,33),(3,13,11,34),(6,13,12,0),(6,13,12,1),(3,13,12,34),(6,13,13,0),(2,13,13,1),(6,13,13,8),(6,13,13,9),(0,13,13,32),(6,13,14,0),(4,13,14,3),(6,13,14,6),(6,13,14,8),(6,13,15,0),(4,13,15,1),(4,13,15,2),(4,13,15,3),(6,13,15,6),(6,13,15,8),(6,13,15,9),(6,13,15,10),(6,13,16,0),(6,13,16,1),(4,13,16,2),(4,13,16,3),(6,13,16,6),(6,13,16,7),(6,13,16,8),(6,13,17,0),(6,13,17,1),(4,13,17,2),(4,13,17,3),(4,13,17,4),(4,13,17,6),(6,13,17,8),(5,13,17,20),(5,13,17,21),(6,13,18,0),(1,13,18,1),(4,13,18,3),(4,13,18,4),(4,13,18,5),(4,13,18,6),(4,13,18,12),(4,13,18,13),(5,13,18,17),(5,13,18,18),(5,13,18,19),(5,13,18,20),(5,13,18,21),(5,13,18,22),(5,13,18,23),(5,13,18,24),(6,13,19,0),(4,13,19,3),(4,13,19,4),(4,13,19,5),(0,13,19,6),(4,13,19,10),(4,13,19,11),(4,13,19,13),(4,13,19,14),(4,13,19,15),(5,13,19,20),(5,13,19,21),(5,13,19,22),(3,13,19,31),(0,13,19,32),(6,13,20,0),(4,13,20,3),(4,13,20,4),(4,13,20,5),(4,13,20,10),(4,13,20,11),(4,13,20,13),(5,13,20,19),(5,13,20,20),(5,13,20,22),(5,13,20,23),(5,13,20,24),(3,13,20,28),(3,13,20,31),(4,13,21,5),(4,13,21,6),(4,13,21,7),(4,13,21,9),(4,13,21,10),(4,13,21,11),(4,13,21,12),(4,13,21,13),(4,13,21,14),(4,13,21,15),(5,13,21,22),(3,13,21,27),(3,13,21,28),(3,13,21,29),(3,13,21,30),(3,13,21,31),(3,13,21,32),(3,13,21,33),(4,13,22,5),(4,13,22,6),(4,13,22,9),(4,13,22,10),(4,13,22,11),(4,13,22,12),(4,13,22,14),(3,13,22,28),(3,13,22,29),(3,13,22,31),(3,13,22,32),(6,13,22,33),(6,13,22,34),(4,13,23,5),(4,13,23,12),(4,13,23,14),(3,13,23,28),(3,13,23,29),(3,13,23,30),(0,13,23,32),(6,13,23,34),(4,13,24,14),(4,13,24,15),(3,13,24,28),(6,13,24,34),(6,13,25,31),(6,13,25,32),(6,13,25,33),(6,13,25,34),(4,13,26,7),(3,13,26,31),(6,13,26,32),(6,13,26,33),(6,13,26,34),(14,13,27,0),(4,13,27,5),(4,13,27,7),(4,13,27,8),(4,13,27,9),(4,13,27,11),(3,13,27,31),(3,13,27,32),(3,13,27,33),(6,13,27,34),(4,13,28,5),(4,13,28,6),(4,13,28,7),(4,13,28,8),(4,13,28,9),(4,13,28,10),(4,13,28,11),(4,13,28,12),(4,13,28,13),(3,13,28,28),(3,13,28,29),(3,13,28,30),(3,13,28,31),(3,13,28,32),(3,13,28,33),(3,13,28,34),(4,13,29,5),(4,13,29,7),(4,13,29,8),(4,13,29,9),(4,13,29,10),(4,13,29,11),(4,13,29,12),(4,13,29,13),(0,13,29,31),(3,13,29,33),(3,13,29,34),(8,13,30,2),(4,13,30,6),(4,13,30,7),(4,13,30,11),(5,13,30,23),(3,13,30,33),(3,13,30,34),(5,13,31,5),(5,13,31,6),(5,13,31,10),(5,13,31,20),(5,13,31,21),(5,13,31,22),(5,13,31,23),(3,13,31,32),(3,13,31,33),(3,13,31,34),(5,13,32,6),(5,13,32,7),(5,13,32,8),(5,13,32,9),(5,13,32,10),(5,13,32,22),(5,13,32,23),(5,13,33,5),(5,13,33,6),(5,13,33,7),(5,13,33,8),(5,13,33,9),(5,13,33,10),(5,13,33,11),(5,13,33,21),(5,13,33,23),(5,13,33,24),(5,13,33,25),(5,13,33,26),(5,13,34,5),(5,13,34,8),(5,13,34,9),(5,13,34,10),(5,13,34,20),(5,13,34,21),(5,13,34,22),(5,13,34,23),(5,13,34,24),(5,13,34,25),(5,13,34,26),(5,36,0,0),(5,36,0,1),(5,36,0,2),(5,36,0,3),(5,36,0,15),(5,36,0,16),(5,36,0,17),(5,36,0,18),(5,36,0,19),(5,36,0,20),(5,36,0,21),(5,36,0,22),(5,36,0,23),(5,36,0,24),(5,36,0,25),(5,36,0,26),(0,36,0,28),(5,36,1,0),(5,36,1,1),(5,36,1,2),(5,36,1,3),(4,36,1,7),(4,36,1,8),(4,36,1,9),(4,36,1,10),(13,36,1,12),(5,36,1,16),(5,36,1,17),(5,36,1,18),(11,36,1,20),(5,36,1,26),(5,36,2,0),(5,36,2,1),(5,36,2,2),(4,36,2,6),(4,36,2,7),(4,36,2,8),(4,36,2,9),(5,36,2,14),(5,36,2,15),(5,36,2,16),(5,36,2,17),(5,36,2,19),(5,36,2,26),(5,36,2,27),(5,36,3,0),(5,36,3,1),(4,36,3,5),(4,36,3,6),(4,36,3,7),(4,36,3,8),(4,36,3,9),(5,36,3,15),(5,36,3,16),(5,36,3,17),(5,36,3,18),(5,36,3,19),(0,36,3,27),(5,36,4,1),(5,36,4,2),(5,36,4,3),(4,36,4,6),(4,36,4,7),(4,36,4,8),(6,36,4,11),(5,36,4,16),(5,36,4,17),(5,36,5,2),(5,36,5,3),(4,36,5,5),(4,36,5,6),(4,36,5,7),(6,36,5,10),(6,36,5,11),(6,36,5,20),(6,36,5,21),(6,36,6,10),(6,36,6,11),(6,36,6,18),(6,36,6,20),(6,36,6,21),(6,36,6,22),(12,36,7,1),(6,36,7,11),(6,36,7,19),(6,36,7,20),(6,36,8,11),(6,36,8,12),(6,36,8,13),(6,36,8,19),(6,36,8,20),(6,36,9,12),(6,36,9,13),(6,36,9,14),(6,36,9,20),(3,36,9,25),(3,36,9,26),(0,36,10,8),(6,36,10,12),(6,36,10,13),(8,36,10,22),(3,36,10,25),(3,36,10,26),(3,36,10,27),(3,36,10,29),(3,36,11,26),(3,36,11,27),(3,36,11,28),(3,36,11,29),(3,36,12,27),(3,36,12,28),(3,36,12,29),(3,36,13,25),(3,36,13,27),(3,36,13,28),(3,36,13,29),(3,36,14,25),(3,36,14,26),(3,36,14,27),(3,36,14,28),(3,36,14,29),(3,36,15,25),(3,36,15,26),(3,36,15,27),(3,36,15,28),(3,36,15,29),(5,36,16,0),(3,36,16,26),(3,36,16,27),(3,36,16,28),(3,36,16,29),(5,36,17,0),(5,36,17,1),(3,36,17,25),(3,36,17,26),(3,36,17,27),(3,36,17,28),(3,36,17,29),(5,36,18,0),(5,36,18,1),(0,36,18,5),(3,36,18,24),(3,36,18,25),(3,36,18,26),(3,36,18,27),(3,36,18,28),(3,36,18,29),(5,36,19,0),(3,36,19,24),(3,36,19,25),(3,36,19,26),(3,36,19,27),(3,36,19,28),(3,36,19,29),(5,36,20,0),(5,36,20,1),(3,36,20,24),(3,36,20,25),(3,36,20,26),(3,36,20,27),(3,36,20,28),(3,36,20,29),(5,36,21,0),(3,36,21,25),(3,36,21,26),(3,36,21,27),(3,36,21,28),(3,36,21,29),(5,36,22,0),(14,36,22,1),(3,36,22,27),(3,36,22,28),(3,36,22,29),(5,36,23,0),(4,36,23,20),(3,36,23,26),(3,36,23,27),(3,36,23,28),(3,36,23,29),(5,36,24,0),(4,36,24,18),(4,36,24,19),(4,36,24,20),(4,36,24,21),(4,36,24,22),(0,36,24,24),(3,36,24,27),(3,36,24,28),(5,36,25,0),(5,36,25,2),(4,36,25,19),(4,36,25,20),(4,36,25,21),(4,36,25,22),(5,36,26,0),(5,36,26,1),(5,36,26,2),(6,36,26,6),(6,36,26,7),(2,36,26,16),(4,36,26,19),(4,36,26,20),(4,36,26,21),(4,36,26,22),(4,36,26,23),(6,36,27,5),(6,36,27,6),(5,36,27,7),(5,36,27,8),(5,36,27,11),(5,36,27,12),(4,36,27,19),(4,36,27,20),(4,36,27,21),(4,36,27,22),(4,36,27,23),(4,36,27,24),(5,36,28,1),(5,36,28,2),(5,36,28,3),(5,36,28,4),(6,36,28,5),(6,36,28,6),(5,36,28,7),(5,36,28,8),(5,36,28,10),(5,36,28,11),(5,36,28,12),(5,36,28,13),(5,36,28,14),(4,36,28,19),(4,36,28,20),(4,36,28,21),(4,36,28,22),(4,36,28,23),(0,36,28,24),(5,36,29,2),(6,36,29,3),(6,36,29,4),(6,36,29,5),(6,36,29,6),(5,36,29,7),(5,36,29,8),(5,36,29,9),(5,36,29,10),(5,36,29,11),(5,36,29,12),(5,36,29,13),(4,36,29,18),(4,36,29,19),(4,36,29,20),(4,36,29,21),(4,36,29,22),(4,39,0,1),(4,39,0,17),(4,39,0,18),(4,39,1,0),(4,39,1,1),(0,39,1,2),(4,39,1,14),(4,39,1,16),(4,39,1,17),(4,39,1,18),(4,39,1,19),(4,39,1,26),(8,39,1,27),(4,39,2,1),(4,39,2,13),(4,39,2,14),(4,39,2,15),(4,39,2,16),(4,39,2,17),(4,39,2,18),(4,39,2,19),(4,39,2,24),(4,39,2,25),(4,39,2,26),(4,39,3,0),(4,39,3,1),(4,39,3,2),(4,39,3,3),(4,39,3,4),(6,39,3,13),(6,39,3,14),(4,39,3,16),(4,39,3,17),(4,39,3,18),(4,39,3,24),(4,39,3,25),(4,39,3,26),(4,39,4,0),(4,39,4,1),(4,39,4,2),(4,39,4,4),(6,39,4,13),(6,39,4,14),(4,39,4,16),(4,39,4,17),(4,39,4,18),(4,39,4,21),(4,39,4,22),(4,39,4,23),(4,39,4,24),(4,39,4,25),(4,39,4,26),(4,39,5,1),(4,39,5,2),(4,39,5,3),(4,39,5,4),(6,39,5,13),(6,39,5,14),(6,39,5,15),(4,39,5,17),(4,39,5,21),(4,39,5,22),(4,39,5,24),(4,39,5,25),(4,39,6,0),(4,39,6,1),(4,39,6,2),(4,39,6,3),(6,39,6,13),(4,39,6,21),(4,39,6,24),(4,39,6,25),(14,39,6,27),(0,39,7,1),(5,39,7,21),(5,39,7,23),(4,39,7,25),(5,39,8,21),(5,39,8,22),(5,39,8,23),(6,39,9,18),(5,39,9,19),(5,39,9,20),(5,39,9,21),(5,39,9,23),(5,39,9,24),(5,39,9,25),(5,39,9,26),(5,39,9,27),(4,39,10,0),(4,39,10,1),(11,39,10,7),(6,39,10,18),(6,39,10,19),(6,39,10,20),(5,39,10,21),(5,39,10,22),(5,39,10,23),(5,39,10,24),(5,39,10,25),(5,39,10,26),(4,39,11,0),(4,39,11,1),(1,39,11,2),(6,39,11,18),(5,39,11,21),(5,39,11,22),(5,39,11,23),(2,39,11,24),(3,39,11,26),(3,39,11,27),(4,39,12,0),(4,39,12,1),(6,39,12,18),(5,39,12,21),(5,39,12,22),(3,39,12,23),(3,39,12,26),(3,39,12,27),(2,39,12,28),(4,39,13,0),(4,39,13,1),(4,39,13,2),(6,39,13,18),(3,39,13,21),(3,39,13,22),(3,39,13,23),(3,39,13,24),(3,39,13,25),(3,39,13,26),(3,39,13,27),(4,39,14,0),(4,39,14,1),(4,39,14,2),(4,39,14,3),(3,39,14,11),(3,39,14,12),(6,39,14,18),(3,39,14,19),(3,39,14,22),(3,39,14,23),(3,39,14,24),(3,39,14,25),(3,39,14,26),(3,39,14,27),(3,39,14,28),(3,39,14,29),(4,39,15,0),(4,39,15,1),(4,39,15,2),(4,39,15,3),(13,39,15,5),(3,39,15,8),(3,39,15,10),(3,39,15,11),(3,39,15,12),(3,39,15,13),(3,39,15,14),(3,39,15,15),(3,39,15,16),(3,39,15,18),(3,39,15,19),(3,39,15,23),(3,39,15,24),(3,39,15,25),(3,39,15,26),(3,39,15,27),(3,39,15,28),(3,39,15,29),(3,39,15,30),(4,39,16,0),(0,39,16,1),(4,39,16,3),(3,39,16,7),(3,39,16,8),(3,39,16,9),(3,39,16,10),(3,39,16,11),(3,39,16,12),(3,39,16,13),(3,39,16,14),(3,39,16,15),(3,39,16,16),(3,39,16,17),(3,39,16,18),(3,39,16,22),(3,39,16,23),(3,39,16,24),(3,39,16,25),(3,39,16,26),(4,39,17,0),(3,39,17,7),(3,39,17,8),(3,39,17,9),(3,39,17,10),(3,39,17,11),(3,39,17,12),(3,39,17,13),(3,39,17,14),(3,39,17,15),(3,39,17,16),(5,39,17,17),(5,39,17,18),(5,39,17,19),(5,39,17,20),(3,39,17,24),(3,39,17,25),(3,39,17,26),(4,39,18,0),(3,39,18,7),(3,39,18,8),(3,39,18,9),(3,39,18,10),(3,39,18,11),(3,39,18,12),(3,39,18,14),(5,39,18,16),(5,39,18,17),(5,39,18,18),(3,39,18,25),(3,39,18,26),(3,39,19,7),(3,39,19,14),(5,39,19,16),(5,39,19,17),(5,39,19,18),(5,39,19,19),(5,39,19,20),(3,39,19,24),(3,39,19,25),(3,39,19,26),(3,39,20,7),(3,39,20,8),(3,39,20,9),(5,39,20,15),(5,39,20,16),(5,39,20,17),(5,39,20,18),(3,39,20,24),(3,39,20,25),(5,39,20,26),(5,39,20,27),(3,39,21,5),(3,39,21,6),(3,39,21,7),(3,39,21,8),(3,39,21,9),(5,39,21,16),(5,39,21,17),(3,39,21,25),(5,39,21,26),(5,39,21,27),(5,39,21,28),(3,39,22,0),(3,39,22,1),(3,39,22,2),(3,39,22,3),(3,39,22,4),(3,39,22,5),(0,39,22,6),(3,39,22,8),(3,39,22,9),(5,39,22,15),(5,39,22,16),(6,39,22,22),(3,39,22,24),(3,39,22,25),(5,39,22,27),(5,39,22,28),(5,39,22,29),(5,39,22,30),(3,39,23,0),(0,39,23,1),(3,39,23,3),(3,39,23,4),(3,39,23,5),(3,39,23,8),(3,39,23,9),(3,39,23,10),(5,39,23,15),(5,39,23,16),(6,39,23,21),(6,39,23,22),(5,39,23,27),(5,39,23,28),(5,39,23,29),(5,39,23,30),(3,39,24,0),(3,39,24,3),(3,39,24,4),(3,39,24,5),(3,39,24,6),(3,39,24,9),(5,39,24,16),(5,39,24,17),(6,39,24,20),(6,39,24,21),(6,39,24,22),(5,39,24,28),(5,39,24,29),(5,39,24,30),(3,39,25,0),(3,39,25,1),(3,39,25,2),(3,39,25,3),(3,39,25,4),(3,39,25,5),(3,39,25,6),(3,39,25,9),(3,39,25,10),(6,39,25,22),(6,39,25,23),(5,39,25,27),(5,39,25,28),(5,39,25,29),(5,39,25,30),(3,39,26,0),(3,39,26,3),(3,39,26,4),(3,39,26,5),(3,39,26,6),(3,39,26,7),(3,39,26,8),(3,39,26,9),(3,39,26,10),(3,39,26,11),(3,39,26,12),(5,39,26,27),(5,39,26,30),(3,39,27,0),(3,39,27,3),(3,39,27,4),(6,39,27,5),(3,39,27,7),(3,39,27,8),(3,39,27,9),(3,39,27,10),(3,39,27,11),(5,39,27,26),(5,39,27,27),(3,39,28,0),(6,39,28,1),(6,39,28,2),(6,39,28,3),(6,39,28,4),(6,39,28,5),(6,39,28,6),(3,39,28,7),(3,39,28,8),(3,39,28,9),(3,39,28,10),(3,39,28,11),(3,39,28,12),(5,39,29,0),(0,39,29,2),(6,39,29,4),(3,39,29,6),(3,39,29,7),(3,39,29,8),(3,39,29,10),(3,39,29,11),(3,39,29,12),(5,39,30,0),(5,39,30,1),(3,39,30,6),(3,39,30,7),(3,39,30,8),(3,39,30,9),(3,39,30,11),(3,39,30,12),(5,39,31,0),(5,39,31,1),(5,39,31,2),(5,39,31,3),(3,39,31,7),(3,39,31,9),(3,39,31,11),(5,39,32,0),(5,39,32,1),(5,39,32,2),(5,39,32,3),(5,39,32,4),(5,39,32,5),(5,39,32,6),(6,39,32,25),(6,39,32,26),(5,39,33,0),(5,39,33,1),(5,39,33,2),(5,39,33,3),(5,39,33,4),(5,39,33,5),(5,39,33,6),(5,39,33,7),(5,39,33,8),(6,39,33,26),(6,39,33,27),(5,39,34,0),(5,39,34,1),(0,39,34,2),(5,39,34,5),(5,39,34,6),(5,39,34,7),(6,39,34,25),(6,39,34,26),(6,39,34,27),(5,39,35,0),(5,39,35,1),(5,39,35,4),(5,39,35,5),(5,39,35,6),(5,39,35,7),(5,39,35,8),(5,39,35,9),(6,39,35,25),(5,39,36,0),(5,39,36,1),(5,39,36,2),(5,39,36,3),(5,39,36,4),(5,39,36,5),(5,39,36,6),(5,39,36,7),(5,39,37,2),(5,39,37,5),(5,39,38,2),(5,39,38,5),(13,40,0,0),(5,40,0,17),(5,40,0,18),(5,40,0,19),(5,40,0,20),(5,40,0,21),(5,40,0,22),(5,40,0,23),(4,40,0,30),(5,40,1,18),(5,40,1,20),(5,40,1,21),(5,40,1,22),(5,40,1,24),(4,40,1,29),(4,40,1,30),(4,40,1,31),(4,40,1,32),(0,40,2,3),(0,40,2,7),(3,40,2,15),(3,40,2,16),(3,40,2,17),(3,40,2,18),(3,40,2,19),(5,40,2,20),(5,40,2,21),(5,40,2,22),(5,40,2,23),(5,40,2,24),(5,40,2,25),(4,40,2,29),(4,40,2,30),(4,40,2,31),(4,40,2,32),(4,40,2,33),(3,40,3,16),(3,40,3,17),(3,40,3,18),(3,40,3,19),(3,40,3,20),(5,40,3,22),(5,40,3,23),(5,40,3,24),(5,40,3,25),(4,40,3,28),(4,40,3,29),(4,40,3,30),(3,40,4,16),(3,40,4,17),(3,40,4,18),(3,40,4,19),(5,40,4,23),(5,40,4,24),(5,40,4,25),(4,40,4,28),(4,40,4,29),(4,40,4,30),(4,40,4,31),(3,40,5,15),(3,40,5,16),(3,40,5,17),(4,40,5,19),(4,40,5,20),(4,40,5,22),(4,40,5,23),(5,40,5,24),(4,40,5,29),(4,40,5,31),(4,40,5,32),(4,40,5,33),(3,40,6,13),(3,40,6,14),(3,40,6,15),(3,40,6,16),(4,40,6,19),(4,40,6,20),(4,40,6,21),(4,40,6,22),(4,40,6,24),(4,40,6,29),(0,40,7,3),(3,40,7,15),(4,40,7,18),(4,40,7,19),(4,40,7,20),(4,40,7,21),(4,40,7,22),(4,40,7,23),(4,40,7,24),(3,40,8,14),(3,40,8,15),(4,40,8,19),(4,40,8,22),(4,40,8,24),(3,40,9,14),(3,40,9,15),(4,40,9,18),(4,40,9,19),(4,40,9,22),(3,40,10,14),(3,40,10,15),(3,40,10,16),(3,40,11,13),(3,40,11,14),(3,40,11,16),(6,40,11,32),(6,40,12,32),(5,40,12,36),(6,40,13,32),(6,40,13,33),(5,40,13,35),(5,40,13,36),(8,40,14,8),(6,40,14,32),(6,40,14,33),(5,40,14,36),(11,40,15,0),(6,40,15,15),(4,40,15,16),(4,40,15,17),(6,40,15,32),(6,40,15,33),(6,40,15,34),(5,40,15,35),(5,40,15,36),(6,40,16,14),(6,40,16,15),(4,40,16,16),(4,40,16,17),(4,40,16,18),(4,40,16,20),(5,40,16,26),(5,40,16,28),(5,40,16,29),(6,40,16,33),(5,40,16,34),(5,40,16,35),(5,40,16,36),(14,40,17,7),(0,40,17,12),(6,40,17,14),(6,40,17,15),(4,40,17,16),(4,40,17,17),(4,40,17,18),(4,40,17,19),(4,40,17,20),(5,40,17,24),(5,40,17,25),(5,40,17,26),(5,40,17,27),(5,40,17,28),(6,40,17,33),(5,40,17,35),(5,40,17,36),(3,40,18,6),(6,40,18,14),(6,40,18,15),(6,40,18,16),(4,40,18,17),(4,40,18,18),(4,40,18,19),(4,40,18,20),(5,40,18,25),(5,40,18,26),(5,40,18,28),(5,40,18,35),(5,40,18,36),(3,40,19,0),(3,40,19,1),(3,40,19,2),(3,40,19,3),(3,40,19,4),(3,40,19,5),(3,40,19,6),(6,40,19,14),(6,40,19,15),(4,40,19,16),(4,40,19,17),(4,40,19,19),(4,40,19,20),(5,40,19,25),(5,40,19,26),(3,40,20,0),(3,40,20,5),(3,40,20,6),(3,40,20,7),(3,40,20,8),(3,40,20,9),(3,40,20,10),(6,40,20,15),(4,40,20,16),(4,40,20,20),(4,40,20,21),(3,40,21,0),(3,40,21,5),(3,40,21,6),(3,40,21,7),(3,40,21,8),(3,40,21,9),(3,40,21,10),(3,40,22,5),(3,40,22,6),(3,40,22,7),(0,40,22,8),(3,40,23,5),(3,40,23,6),(3,40,23,7),(5,40,23,14),(3,40,24,6),(3,40,24,7),(3,40,24,8),(5,40,24,13),(5,40,24,14),(3,40,25,6),(5,40,25,11),(5,40,25,12),(5,40,25,13),(5,40,25,14),(5,40,25,15),(11,40,25,29),(5,40,26,12),(5,40,26,13),(5,40,26,15),(5,40,26,16),(1,40,27,7),(5,40,27,16),(3,40,27,25),(13,40,27,35),(3,40,28,25),(3,40,28,27),(3,40,28,28),(6,40,29,6),(6,40,29,9),(3,40,29,25),(3,40,29,26),(3,40,29,27),(3,40,29,28),(3,40,29,29),(3,40,29,30),(4,40,29,33),(4,40,29,34),(6,40,30,2),(6,40,30,3),(6,40,30,4),(6,40,30,5),(6,40,30,6),(6,40,30,7),(6,40,30,9),(6,40,30,10),(6,40,30,12),(3,40,30,26),(3,40,30,27),(3,40,30,28),(3,40,30,29),(4,40,30,30),(4,40,30,33),(2,40,31,2),(6,40,31,4),(6,40,31,7),(0,40,31,8),(6,40,31,10),(6,40,31,11),(6,40,31,12),(3,40,31,25),(3,40,31,26),(3,40,31,27),(4,40,31,28),(4,40,31,29),(4,40,31,30),(4,40,31,31),(4,40,31,32),(4,40,31,33),(4,40,31,34),(6,40,32,4),(6,40,32,10),(6,40,32,11),(6,40,32,12),(3,40,32,26),(3,40,32,27),(3,40,32,28),(3,40,32,29),(4,40,32,30),(4,40,32,31),(4,40,32,32),(4,40,32,33),(4,40,32,34),(6,40,33,4),(6,40,33,11),(3,40,33,20),(3,40,33,21),(3,40,33,22),(3,40,33,23),(3,40,33,24),(3,40,33,25),(3,40,33,26),(3,40,33,27),(3,40,33,28),(3,40,33,29),(3,40,33,30),(4,40,33,31),(4,40,33,32),(4,40,33,33),(4,40,33,34),(4,40,33,35),(4,40,33,36),(9,49,0,1),(3,49,0,4),(3,49,0,5),(3,49,0,6),(3,49,0,7),(3,49,0,8),(3,49,0,9),(3,49,0,10),(3,49,0,11),(3,49,0,12),(12,49,0,24),(12,49,0,30),(3,49,1,4),(3,49,1,5),(3,49,1,6),(3,49,1,7),(3,49,1,8),(3,49,1,9),(2,49,1,10),(3,49,1,12),(3,49,2,4),(3,49,2,9),(3,49,2,12),(4,49,2,15),(1,49,2,21),(3,49,3,4),(3,49,3,9),(3,49,3,10),(3,49,3,11),(3,49,3,12),(4,49,3,15),(2,49,3,16),(3,49,4,3),(3,49,4,4),(3,49,4,9),(3,49,4,10),(3,49,4,11),(4,49,4,12),(4,49,4,15),(3,49,5,1),(3,49,5,3),(3,49,5,4),(3,49,5,9),(3,49,5,10),(4,49,5,11),(4,49,5,12),(4,49,5,13),(4,49,5,14),(4,49,5,15),(4,49,5,16),(4,49,5,17),(4,49,5,18),(3,49,6,0),(3,49,6,1),(3,49,6,2),(3,49,6,3),(3,49,6,4),(3,49,6,5),(3,49,6,6),(3,49,6,7),(3,49,6,8),(3,49,6,9),(3,49,6,10),(3,49,6,11),(4,49,6,14),(4,49,6,15),(4,49,6,16),(4,49,6,17),(4,49,6,18),(4,49,6,19),(3,49,7,0),(3,49,7,1),(3,49,7,2),(3,49,7,3),(3,49,7,4),(3,49,7,5),(3,49,7,6),(3,49,7,7),(3,49,7,8),(3,49,7,9),(3,49,7,11),(3,49,7,12),(4,49,7,14),(4,49,7,15),(4,49,7,16),(4,49,7,19),(1,49,7,21),(3,49,8,0),(3,49,8,1),(3,49,8,2),(3,49,8,3),(3,49,8,4),(3,49,8,5),(3,49,8,6),(3,49,8,7),(4,49,8,16),(4,49,8,17),(4,49,8,18),(4,49,8,19),(3,49,9,1),(3,49,9,2),(3,49,9,3),(3,49,9,4),(3,49,9,5),(3,49,9,6),(3,49,9,7),(3,49,9,8),(3,49,9,9),(4,49,9,16),(4,49,9,18),(3,49,10,1),(3,49,10,2),(3,49,10,3),(3,49,10,4),(3,49,10,5),(3,49,10,6),(3,49,10,7),(3,49,10,8),(3,49,10,9),(3,49,11,0),(3,49,11,1),(3,49,11,2),(3,49,11,3),(3,49,11,4),(3,49,11,7),(3,49,11,8),(3,49,11,9),(3,49,12,0),(3,49,12,1),(3,49,12,2),(3,49,12,3),(3,49,12,4),(3,49,12,8),(3,49,12,9),(3,49,13,0),(3,49,13,1),(4,49,13,7),(4,49,13,8),(4,49,14,6),(4,49,14,7),(4,49,14,8),(4,49,15,5),(4,49,15,6),(4,49,15,7),(4,49,15,8),(4,49,15,9),(4,49,16,6),(4,49,16,8),(4,49,16,9),(4,49,17,4),(4,49,17,5),(4,49,17,6),(4,49,17,7),(4,49,17,8),(4,49,17,9),(4,49,17,10),(3,49,18,5),(4,49,18,6),(4,49,18,7),(4,49,18,8),(4,49,18,9),(4,49,18,10),(4,49,18,11),(3,49,19,4),(3,49,19,5),(4,49,19,6),(4,49,19,8),(3,49,20,1),(3,49,20,2),(3,49,20,3),(3,49,20,4),(3,49,20,6),(3,49,20,7),(3,49,20,27),(3,49,20,28),(3,49,21,0),(3,49,21,1),(3,49,21,2),(3,49,21,3),(3,49,21,4),(3,49,21,5),(3,49,21,6),(4,49,21,12),(3,49,21,23),(3,49,21,26),(3,49,21,27),(3,49,21,28),(3,49,21,29),(3,49,21,31),(3,49,22,0),(3,49,22,1),(3,49,22,2),(3,49,22,3),(3,49,22,5),(3,49,22,6),(3,49,22,7),(4,49,22,11),(4,49,22,12),(4,49,22,13),(3,49,22,23),(3,49,22,24),(3,49,22,25),(3,49,22,26),(3,49,22,27),(3,49,22,28),(3,49,22,29),(3,49,22,30),(3,49,22,31),(3,49,22,32),(6,49,22,33),(6,49,22,34),(3,49,23,0),(3,49,23,1),(3,49,23,2),(3,49,23,3),(3,49,23,5),(3,49,23,6),(4,49,23,10),(4,49,23,11),(4,49,23,12),(3,49,23,24),(3,49,23,25),(3,49,23,26),(3,49,23,27),(3,49,23,28),(3,49,23,29),(3,49,23,30),(3,49,23,31),(6,49,23,33),(3,49,24,0),(4,49,24,1),(3,49,24,2),(3,49,24,3),(3,49,24,4),(3,49,24,5),(3,49,24,6),(4,49,24,10),(4,49,24,11),(4,49,24,12),(4,49,24,13),(3,49,24,25),(3,49,24,26),(3,49,24,27),(3,49,24,28),(3,49,24,29),(3,49,24,30),(3,49,24,31),(3,49,24,32),(6,49,24,33),(6,49,24,34),(4,49,25,0),(4,49,25,1),(3,49,25,2),(4,49,25,3),(5,49,25,7),(4,49,25,11),(4,49,25,12),(4,49,25,13),(11,49,25,24),(3,49,25,30),(3,49,25,31),(6,49,25,32),(6,49,25,33),(4,49,26,0),(4,49,26,1),(4,49,26,2),(4,49,26,3),(5,49,26,6),(5,49,26,7),(5,49,26,8),(4,49,26,9),(4,49,26,10),(4,49,26,11),(4,49,26,12),(4,49,26,13),(4,49,26,14),(6,49,26,31),(6,49,26,32),(6,49,26,33),(4,49,27,0),(4,49,27,1),(4,49,27,2),(4,49,27,3),(5,49,27,5),(5,49,27,6),(5,49,27,7),(5,49,27,8),(5,49,27,9),(4,49,27,11),(4,49,27,12),(4,49,27,13),(4,49,27,14),(4,49,27,15),(6,49,27,19),(6,49,27,20),(6,49,27,31),(6,49,27,32),(6,49,27,33),(4,49,28,0),(4,49,28,1),(4,49,28,2),(4,49,28,3),(4,49,28,4),(5,49,28,6),(5,49,28,7),(5,49,28,8),(4,49,28,11),(4,49,28,12),(6,49,28,16),(6,49,28,17),(6,49,28,18),(6,49,28,19),(4,49,29,0),(4,49,29,1),(4,49,29,2),(4,49,29,3),(4,49,29,4),(5,49,29,6),(5,49,29,8),(4,49,29,12),(6,49,29,16),(6,49,29,17),(5,49,29,18),(6,49,29,19),(13,49,29,30),(4,49,30,0),(4,49,30,2),(4,49,30,3),(4,49,30,4),(5,49,30,6),(5,49,30,7),(5,49,30,8),(5,49,30,9),(5,49,30,10),(5,49,30,11),(6,49,30,15),(6,49,30,16),(5,49,30,17),(5,49,30,18),(6,49,30,19),(8,49,30,21),(11,49,30,24),(9,49,30,33),(4,49,31,0),(4,49,31,1),(0,49,31,2),(5,49,31,6),(5,49,31,8),(5,49,31,9),(5,49,31,10),(6,49,31,11),(6,49,31,15),(5,49,31,16),(5,49,31,17),(5,49,31,18),(5,49,31,19),(5,49,31,20),(5,49,32,7),(5,49,32,8),(5,49,32,9),(6,49,32,11),(6,49,32,13),(5,49,32,14),(5,49,32,15),(5,49,32,16),(5,49,32,17),(5,49,32,18),(5,49,32,19),(5,49,32,20),(5,49,33,1),(5,49,33,2),(5,49,33,3),(5,49,33,7),(6,49,33,9),(6,49,33,10),(6,49,33,11),(6,49,33,12),(6,49,33,13),(5,49,33,14),(5,49,33,15),(5,49,33,16),(5,49,33,17),(5,49,33,18),(5,49,33,19),(5,49,33,20),(5,49,33,23),(5,49,34,0),(5,49,34,1),(5,49,34,2),(5,49,34,3),(5,49,34,4),(6,49,34,10),(6,49,34,11),(6,49,34,12),(6,49,34,13),(13,49,34,14),(5,49,34,16),(5,49,34,20),(5,49,34,21),(5,49,34,22),(5,49,34,23),(5,49,34,24),(5,49,34,25),(5,49,34,26),(5,49,34,27),(5,49,34,28),(5,49,34,29),(5,49,35,0),(5,49,35,1),(0,49,35,10),(6,49,35,13),(5,49,35,16),(0,49,35,21),(5,49,35,23),(5,49,35,24),(5,49,35,25),(5,49,35,26),(5,49,35,27),(5,49,35,28),(5,49,35,29),(5,49,35,30),(5,49,36,0),(0,49,36,1),(0,49,36,6),(5,49,36,16),(5,49,36,17),(5,49,36,23),(5,49,36,24),(0,49,36,25),(5,49,36,27),(5,49,36,28),(5,49,36,30),(5,49,37,0),(5,49,37,5),(0,49,37,17),(5,49,37,24),(0,49,37,30),(5,49,38,0),(5,49,38,1),(5,49,38,2),(5,49,38,3),(5,49,38,4),(5,49,38,5),(5,49,38,6),(5,49,38,7),(5,49,38,23),(5,49,38,24),(5,49,38,25),(5,49,39,0),(5,49,39,1),(5,49,39,2),(5,49,39,3),(5,49,39,4),(5,49,39,5),(5,49,39,7),(5,49,39,25),(5,49,39,26),(5,51,1,22),(5,51,2,21),(5,51,2,22),(5,51,3,20),(5,51,3,21),(5,51,4,20),(5,51,4,21),(6,51,5,7),(6,51,5,8),(6,51,5,9),(5,51,5,12),(5,51,5,21),(6,51,6,8),(5,51,6,9),(5,51,6,10),(5,51,6,11),(5,51,6,12),(4,51,6,20),(4,51,6,21),(4,51,6,22),(6,51,7,7),(6,51,7,8),(5,51,7,9),(5,51,7,10),(5,51,7,12),(4,51,7,19),(4,51,7,20),(4,51,7,21),(4,51,7,22),(6,51,8,6),(6,51,8,7),(6,51,8,8),(4,51,8,16),(4,51,8,19),(4,51,8,20),(4,51,8,21),(4,51,8,22),(6,51,9,8),(4,51,9,16),(4,51,9,17),(4,51,9,19),(4,51,9,21),(4,51,9,22),(4,51,10,16),(4,51,10,17),(4,51,10,18),(4,51,10,19),(4,51,10,20),(4,51,10,21),(4,51,10,22),(4,51,11,16),(4,51,11,17),(4,51,11,18),(4,51,11,19),(4,51,11,20),(4,51,11,21),(4,51,11,22),(3,51,12,8),(3,51,12,9),(3,51,12,10),(3,51,12,14),(3,51,12,15),(4,51,12,16),(4,51,12,17),(4,51,12,18),(4,51,12,19),(4,51,12,22),(3,51,13,6),(3,51,13,7),(3,51,13,8),(3,51,13,9),(3,51,13,13),(3,51,13,14),(3,51,13,15),(3,51,13,16),(4,51,13,18),(4,51,13,19),(4,51,13,20),(4,51,13,21),(3,51,13,22),(3,51,13,24),(6,51,14,6),(3,51,14,7),(3,51,14,8),(3,51,14,9),(3,51,14,11),(3,51,14,12),(3,51,14,13),(3,51,14,14),(4,51,14,19),(4,51,14,20),(3,51,14,22),(3,51,14,24),(5,51,14,27),(5,51,14,28),(6,51,15,4),(6,51,15,5),(6,51,15,6),(6,51,15,7),(3,51,15,8),(3,51,15,9),(3,51,15,10),(3,51,15,11),(3,51,15,12),(3,51,15,13),(3,51,15,14),(3,51,15,15),(3,51,15,16),(3,51,15,18),(4,51,15,19),(4,51,15,20),(4,51,15,21),(3,51,15,22),(3,51,15,23),(3,51,15,24),(3,51,15,25),(5,51,15,26),(5,51,15,27),(3,51,16,0),(3,51,16,1),(3,51,16,2),(6,51,16,3),(6,51,16,4),(6,51,16,5),(6,51,16,6),(6,51,16,7),(3,51,16,8),(3,51,16,9),(3,51,16,10),(3,51,16,11),(3,51,16,12),(3,51,16,13),(3,51,16,18),(3,51,16,19),(4,51,16,20),(3,51,16,21),(3,51,16,22),(3,51,16,23),(3,51,16,24),(3,51,16,25),(5,51,16,27),(5,51,16,28),(5,51,16,29),(3,51,17,0),(12,51,17,1),(3,51,17,7),(3,51,17,8),(3,51,17,9),(3,51,17,10),(3,51,17,11),(3,51,17,12),(3,51,17,13),(3,51,17,16),(3,51,17,17),(3,51,17,18),(3,51,17,19),(3,51,17,20),(3,51,17,21),(3,51,17,22),(3,51,17,23),(3,51,17,24),(3,51,17,25),(3,51,17,26),(5,51,17,29),(3,51,18,0),(3,51,18,7),(11,51,18,8),(3,51,18,15),(3,51,18,16),(3,51,18,17),(3,51,18,18),(3,51,18,19),(3,51,18,20),(3,51,18,21),(3,51,18,22),(3,51,18,23),(3,51,18,24),(3,51,19,0),(3,51,19,7),(3,51,19,17),(5,51,19,18),(3,51,19,20),(3,51,19,21),(3,51,19,22),(3,51,19,23),(3,51,19,24),(3,51,20,0),(3,51,20,7),(5,51,20,16),(5,51,20,17),(5,51,20,18),(5,51,20,19),(5,51,20,20),(5,51,20,21),(3,51,20,22),(3,51,20,23),(3,51,20,24),(3,51,20,25),(3,51,21,0),(3,51,21,7),(5,51,21,18),(3,51,21,24),(5,51,21,30),(3,51,22,0),(3,51,22,7),(3,51,22,8),(9,51,22,14),(5,51,22,30),(3,51,23,0),(3,51,23,1),(3,51,23,2),(3,51,23,3),(3,51,23,4),(3,51,23,5),(12,51,23,6),(4,51,23,20),(4,51,23,21),(4,51,23,23),(5,51,23,28),(5,51,23,29),(5,51,23,30),(3,51,24,0),(3,51,24,1),(3,51,24,2),(3,51,24,3),(3,51,24,4),(3,51,24,5),(4,51,24,21),(4,51,24,22),(4,51,24,23),(4,51,24,24),(5,51,24,28),(5,51,24,29),(3,51,25,0),(3,51,25,1),(3,51,25,2),(3,51,25,3),(3,51,25,4),(3,51,25,5),(4,51,25,19),(4,51,25,20),(4,51,25,21),(4,51,25,22),(4,51,25,23),(4,51,25,24),(4,51,25,25),(5,51,25,29),(3,51,26,0),(3,51,26,1),(3,51,26,2),(3,51,26,3),(3,51,26,4),(3,51,26,5),(4,51,26,19),(4,51,26,20),(4,51,26,21),(4,51,26,22),(4,51,26,23),(4,51,26,24),(4,51,26,25),(3,51,27,0),(3,51,27,1),(2,51,27,2),(3,51,27,4),(3,51,27,5),(4,51,27,19),(4,51,27,20),(4,51,27,21),(4,51,27,22),(4,51,27,23),(4,51,27,24),(4,51,27,25),(4,51,27,26),(3,51,28,0),(3,51,28,1),(3,51,28,4),(3,51,28,5),(4,51,28,20),(4,51,28,21),(3,51,28,22),(4,51,28,23),(4,51,28,24),(4,51,28,25),(4,51,28,26),(4,51,28,27),(4,51,28,28),(3,51,29,0),(3,51,29,1),(3,51,29,2),(3,51,29,3),(3,51,29,4),(3,51,29,5),(6,51,29,6),(6,51,29,7),(6,51,29,8),(6,51,29,9),(6,51,29,10),(6,51,29,11),(4,51,29,19),(4,51,29,20),(4,51,29,21),(4,51,29,22),(4,51,29,23),(4,51,29,24),(4,51,29,27),(3,51,30,4),(6,51,30,10),(6,51,30,11),(6,51,30,12),(6,51,30,13),(4,51,30,20),(6,51,30,21),(6,51,30,22),(6,51,30,23),(4,51,30,24),(0,51,30,26),(4,51,31,14),(4,51,31,15),(6,51,31,21),(6,51,31,23),(4,51,32,13),(4,51,32,14),(4,51,32,15),(4,51,32,16),(6,51,32,21),(6,51,32,22),(4,51,33,13),(4,51,33,14),(4,51,33,15),(4,51,33,16),(6,51,33,20),(6,51,33,21),(6,51,33,22),(1,51,34,1),(4,51,34,10),(0,51,34,11),(4,51,34,13),(4,51,34,14),(0,51,34,15),(4,51,34,17),(4,51,34,18),(0,51,34,20),(0,51,34,24),(0,51,34,28),(0,51,35,6),(4,51,35,8),(4,51,35,9),(4,51,35,10),(4,51,35,13),(4,51,35,14),(4,51,35,17),(4,51,35,18),(4,51,35,19),(4,51,36,8),(4,51,36,9),(4,51,36,10),(4,51,36,11),(4,51,36,12),(4,51,36,13),(4,51,36,14),(4,51,36,15),(4,51,36,16),(4,51,36,17),(4,51,36,18),(4,51,36,19),(4,51,36,20),(4,51,37,8),(4,51,37,9),(4,51,37,10),(4,51,37,11),(4,51,37,12),(4,51,37,13),(4,51,37,14),(4,51,37,15),(4,51,37,16),(4,51,37,17);
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
) ENGINE=InnoDB AUTO_INCREMENT=265 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `units`
--

LOCK TABLES `units` WRITE;
/*!40000 ALTER TABLE `units` DISABLE KEYS */;
INSERT INTO `units` VALUES (1,3000,1,1,1,NULL,NULL,NULL,NULL,0,0,'Rhyno',0,2,120,NULL,1,0,0,0),(2,3000,1,1,1,NULL,NULL,NULL,NULL,0,0,'Rhyno',0,2,120,NULL,1,0,0,0),(3,3400,1,1,1,NULL,NULL,NULL,NULL,0,0,'Thor',0,2,120,NULL,1,0,0,0),(4,8000,1,1,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,2,120,NULL,1,0,0,0),(5,8000,1,1,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,2,120,NULL,1,0,0,0),(6,8000,1,1,1,NULL,NULL,NULL,NULL,0,0,'Dirac',0,2,120,NULL,1,0,0,0),(7,100,1,8,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(8,200,1,8,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(9,100,1,8,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(10,200,1,8,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(11,100,1,8,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(12,200,1,8,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(13,100,1,8,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(14,100,1,8,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(15,200,1,9,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(16,100,1,9,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(17,100,1,9,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(18,100,1,10,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(19,200,1,10,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(20,100,1,10,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(21,100,1,10,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(22,200,1,10,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(23,100,1,10,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(24,100,1,10,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(25,100,1,11,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(26,100,1,11,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(27,100,1,11,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(28,200,1,12,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(29,100,1,12,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(30,100,1,12,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(31,100,1,13,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(32,100,1,13,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(33,100,1,14,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(34,100,1,14,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(35,100,1,15,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(36,3000,1,1,1,NULL,NULL,NULL,NULL,0,0,'Rhyno',0,3,44,NULL,1,0,0,0),(37,3000,1,1,1,NULL,NULL,NULL,NULL,0,0,'Rhyno',0,3,44,NULL,1,0,0,0),(38,3400,1,1,1,NULL,NULL,NULL,NULL,0,0,'Thor',0,3,44,NULL,1,0,0,0),(39,3400,1,1,1,NULL,NULL,NULL,NULL,0,0,'Thor',1,3,44,NULL,1,0,0,0),(40,8000,1,1,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,3,44,NULL,1,0,0,0),(41,8000,1,1,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,3,44,NULL,1,0,0,0),(42,8000,1,1,1,NULL,NULL,NULL,NULL,0,0,'Dirac',0,3,44,NULL,1,0,0,0),(43,3000,1,1,1,NULL,NULL,NULL,NULL,0,0,'Rhyno',0,1,135,NULL,1,0,0,0),(44,3000,1,1,1,NULL,NULL,NULL,NULL,0,0,'Rhyno',0,1,135,NULL,1,0,0,0),(45,3000,1,1,1,NULL,NULL,NULL,NULL,0,0,'Rhyno',0,1,135,NULL,1,0,0,0),(46,3400,1,1,1,NULL,NULL,NULL,NULL,0,0,'Thor',0,1,135,NULL,1,0,0,0),(47,8000,1,1,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,1,135,NULL,1,0,0,0),(48,8000,1,1,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,1,135,NULL,1,0,0,0),(49,8000,1,1,1,NULL,NULL,NULL,NULL,0,0,'Dirac',0,1,135,NULL,1,0,0,0),(50,100,1,22,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(51,100,1,22,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(52,200,1,22,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(53,100,1,22,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(54,100,1,22,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(55,200,1,23,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(56,100,1,23,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(57,100,1,23,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(58,100,1,24,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(59,200,1,24,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(60,100,1,24,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(61,200,1,24,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(62,100,1,24,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(63,200,1,24,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(64,100,1,24,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(65,100,1,25,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(66,200,1,25,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(67,100,1,25,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(68,100,1,25,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(69,100,1,26,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(70,100,1,26,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(71,100,1,27,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(72,100,1,27,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(73,100,1,28,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(74,100,1,28,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(75,3000,1,2,1,NULL,NULL,NULL,NULL,0,0,'Rhyno',0,3,180,NULL,1,0,0,0),(76,3000,1,2,1,NULL,NULL,NULL,NULL,0,0,'Rhyno',0,3,180,NULL,1,0,0,0),(77,8000,1,2,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,3,180,NULL,1,0,0,0),(78,8000,1,2,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,3,180,NULL,1,0,0,0),(79,8000,1,2,1,NULL,NULL,NULL,NULL,0,0,'Dirac',0,3,180,NULL,1,0,0,0),(80,3000,1,2,1,NULL,NULL,NULL,NULL,0,0,'Rhyno',0,3,22,NULL,1,0,0,0),(81,3000,1,2,1,NULL,NULL,NULL,NULL,0,0,'Rhyno',0,3,22,NULL,1,0,0,0),(82,3400,1,2,1,NULL,NULL,NULL,NULL,0,0,'Thor',0,3,22,NULL,1,0,0,0),(83,3400,1,2,1,NULL,NULL,NULL,NULL,0,0,'Thor',1,3,22,NULL,1,0,0,0),(84,8000,1,2,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,3,22,NULL,1,0,0,0),(85,8000,1,2,1,NULL,NULL,NULL,NULL,0,0,'Dirac',0,3,22,NULL,1,0,0,0),(86,3000,1,2,1,NULL,NULL,NULL,NULL,0,0,'Rhyno',0,1,315,NULL,1,0,0,0),(87,3400,1,2,1,NULL,NULL,NULL,NULL,0,0,'Thor',0,1,315,NULL,1,0,0,0),(88,3400,1,2,1,NULL,NULL,NULL,NULL,0,0,'Thor',1,1,315,NULL,1,0,0,0),(89,8000,1,2,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,1,315,NULL,1,0,0,0),(90,8000,1,2,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,1,315,NULL,1,0,0,0),(91,8000,1,2,1,NULL,NULL,NULL,NULL,0,0,'Dirac',0,1,315,NULL,1,0,0,0),(92,8000,1,2,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,2,300,NULL,1,0,0,0),(93,8000,1,2,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,2,300,NULL,1,0,0,0),(94,8000,1,2,1,NULL,NULL,NULL,NULL,0,0,'Dirac',0,2,300,NULL,1,0,0,0),(95,200,1,35,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(96,100,1,35,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(97,200,1,35,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(98,100,1,35,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(99,200,1,35,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(100,100,1,35,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(101,100,1,35,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(102,100,1,36,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(103,200,1,36,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(104,100,1,36,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(105,100,1,36,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(106,200,1,40,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(107,100,1,40,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(108,100,1,40,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(109,200,1,41,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(110,100,1,41,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(111,100,1,41,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(112,100,1,42,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(113,100,1,42,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(114,100,1,43,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(115,100,1,43,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(116,200,1,44,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(117,100,1,44,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(118,100,1,44,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(119,100,1,45,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(120,100,1,45,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(121,100,1,46,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(122,100,1,46,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(123,200,1,47,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(124,100,1,47,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(125,100,1,47,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(126,200,1,48,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(127,100,1,48,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(128,100,1,48,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(129,200,1,49,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(130,100,1,49,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(131,100,1,49,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(132,100,1,50,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(133,100,1,50,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(134,3400,1,3,1,NULL,NULL,NULL,NULL,0,0,'Thor',0,3,336,NULL,1,0,0,0),(135,3400,1,3,1,NULL,NULL,NULL,NULL,0,0,'Thor',1,3,336,NULL,1,0,0,0),(136,8000,1,3,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,3,336,NULL,1,0,0,0),(137,8000,1,3,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,3,336,NULL,1,0,0,0),(138,8000,1,3,1,NULL,NULL,NULL,NULL,0,0,'Dirac',0,3,336,NULL,1,0,0,0),(139,3000,1,3,1,NULL,NULL,NULL,NULL,0,0,'Rhyno',0,1,0,NULL,1,0,0,0),(140,3000,1,3,1,NULL,NULL,NULL,NULL,0,0,'Rhyno',0,1,0,NULL,1,0,0,0),(141,3000,1,3,1,NULL,NULL,NULL,NULL,0,0,'Rhyno',0,1,0,NULL,1,0,0,0),(142,3400,1,3,1,NULL,NULL,NULL,NULL,0,0,'Thor',0,1,0,NULL,1,0,0,0),(143,3400,1,3,1,NULL,NULL,NULL,NULL,0,0,'Thor',1,1,0,NULL,1,0,0,0),(144,8000,1,3,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,1,0,NULL,1,0,0,0),(145,8000,1,3,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,1,0,NULL,1,0,0,0),(146,8000,1,3,1,NULL,NULL,NULL,NULL,0,0,'Dirac',0,1,0,NULL,1,0,0,0),(147,100,1,55,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(148,200,1,55,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(149,100,1,55,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(150,200,1,55,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(151,200,1,55,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(152,100,1,55,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(153,100,1,55,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(154,100,1,56,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(155,200,1,56,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(156,100,1,56,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(157,100,1,56,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(158,100,1,56,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(159,100,1,56,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(160,200,1,57,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(161,100,1,57,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(162,100,1,57,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(163,100,1,58,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(164,200,1,58,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(165,100,1,58,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(166,200,1,59,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(167,100,1,59,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(168,100,1,59,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(169,100,1,60,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(170,100,1,60,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(171,100,1,61,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(172,100,1,61,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(173,100,1,62,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(174,100,1,62,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(175,100,1,65,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(176,200,1,65,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(177,100,1,65,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(178,200,1,65,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(179,100,1,65,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(180,200,1,65,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(181,100,1,65,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(182,100,1,65,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(183,200,1,66,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(184,100,1,66,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(185,200,1,66,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(186,100,1,66,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(187,100,1,66,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(188,100,1,67,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(189,100,1,67,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(190,100,1,67,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(191,100,1,67,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(192,100,1,67,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(193,100,1,68,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(194,200,1,68,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(195,100,1,68,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(196,200,1,69,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(197,100,1,69,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(198,100,1,69,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(199,100,1,70,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(200,100,1,70,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(201,100,1,71,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(202,100,1,71,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(203,100,1,72,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(204,100,1,72,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(205,100,1,73,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(206,100,1,73,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(207,3000,1,4,1,NULL,NULL,NULL,NULL,0,0,'Rhyno',0,3,292,NULL,1,0,0,0),(208,3000,1,4,1,NULL,NULL,NULL,NULL,0,0,'Rhyno',0,3,292,NULL,1,0,0,0),(209,3400,1,4,1,NULL,NULL,NULL,NULL,0,0,'Thor',1,3,292,NULL,1,0,0,0),(210,8000,1,4,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,3,292,NULL,1,0,0,0),(211,8000,1,4,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,3,292,NULL,1,0,0,0),(212,8000,1,4,1,NULL,NULL,NULL,NULL,0,0,'Dirac',0,3,292,NULL,1,0,0,0),(213,3400,1,4,1,NULL,NULL,NULL,NULL,0,0,'Thor',0,2,30,NULL,1,0,0,0),(214,8000,1,4,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,2,30,NULL,1,0,0,0),(215,8000,1,4,1,NULL,NULL,NULL,NULL,0,0,'Dirac',0,2,30,NULL,1,0,0,0),(216,3000,1,4,1,NULL,NULL,NULL,NULL,0,0,'Rhyno',0,2,330,NULL,1,0,0,0),(217,3000,1,4,1,NULL,NULL,NULL,NULL,0,0,'Rhyno',0,2,330,NULL,1,0,0,0),(218,3400,1,4,1,NULL,NULL,NULL,NULL,0,0,'Thor',1,2,330,NULL,1,0,0,0),(219,8000,1,4,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,2,330,NULL,1,0,0,0),(220,8000,1,4,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,2,330,NULL,1,0,0,0),(221,8000,1,4,1,NULL,NULL,NULL,NULL,0,0,'Dirac',0,2,330,NULL,1,0,0,0),(222,100,1,78,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(223,200,1,78,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(224,100,1,78,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(225,200,1,78,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(226,100,1,78,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(227,100,1,78,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(228,100,1,79,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(229,100,1,79,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(230,100,1,79,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(231,200,1,80,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(232,100,1,80,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(233,100,1,80,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(234,100,1,81,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(235,100,1,81,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(236,100,1,82,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(237,100,1,82,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(238,3400,1,4,1,NULL,NULL,NULL,NULL,0,0,'Thor',1,2,0,NULL,1,0,0,0),(239,8000,1,4,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,2,0,NULL,1,0,0,0),(240,8000,1,4,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,2,0,NULL,1,0,0,0),(241,8000,1,4,1,NULL,NULL,NULL,NULL,0,0,'Dirac',0,2,0,NULL,1,0,0,0),(242,100,1,88,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(243,200,1,88,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(244,100,1,88,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(245,200,1,88,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(246,100,1,88,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(247,100,1,89,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(248,200,1,89,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(249,100,1,89,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(250,200,1,89,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(251,100,1,89,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(252,200,1,89,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(253,100,1,89,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(254,200,1,90,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(255,100,1,90,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(256,100,1,90,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(257,100,1,91,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(258,100,1,91,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(259,100,1,92,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(260,100,1,92,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(261,100,1,93,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(262,100,1,93,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(263,100,1,94,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(264,100,1,94,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0);
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

-- Dump completed on 2010-11-16 17:23:50
