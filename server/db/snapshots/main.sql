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
) ENGINE=InnoDB AUTO_INCREMENT=90 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `buildings`
--

LOCK TABLES `buildings` WRITE;
/*!40000 ALTER TABLE `buildings` DISABLE KEYS */;
INSERT INTO `buildings` VALUES (1,1,7,9,0,0,0,1,'NpcMetalExtractor',NULL,8,10,NULL,1,400,NULL,0,NULL,NULL,0),(2,1,11,26,0,0,0,1,'NpcMetalExtractor',NULL,12,27,NULL,1,400,NULL,0,NULL,NULL,0),(3,1,3,24,0,0,0,1,'NpcGeothermalPlant',NULL,4,25,NULL,1,600,NULL,0,NULL,NULL,0),(4,1,13,19,0,0,0,1,'NpcZetiumExtractor',NULL,14,20,NULL,1,800,NULL,0,NULL,NULL,0),(5,1,3,4,0,0,0,1,'NpcSolarPlant',NULL,4,5,NULL,1,1000,NULL,0,NULL,NULL,0),(6,1,0,29,0,0,0,1,'NpcSolarPlant',NULL,1,30,NULL,1,1000,NULL,0,NULL,NULL,0),(7,6,20,16,0,0,0,1,'NpcMetalExtractor',NULL,21,17,NULL,1,400,NULL,0,NULL,NULL,0),(8,6,26,8,0,0,0,1,'NpcMetalExtractor',NULL,27,9,NULL,1,400,NULL,0,NULL,NULL,0),(9,6,20,4,0,0,0,1,'NpcMetalExtractor',NULL,21,5,NULL,1,400,NULL,0,NULL,NULL,0),(10,6,37,10,0,0,0,1,'NpcGeothermalPlant',NULL,38,11,NULL,1,600,NULL,0,NULL,NULL,0),(11,6,37,3,0,0,0,1,'NpcZetiumExtractor',NULL,38,4,NULL,1,800,NULL,0,NULL,NULL,0),(12,6,4,19,0,0,0,1,'NpcSolarPlant',NULL,5,20,NULL,1,1000,NULL,0,NULL,NULL,0),(13,6,2,18,0,0,0,1,'NpcSolarPlant',NULL,3,19,NULL,1,1000,NULL,0,NULL,NULL,0),(14,6,23,18,0,0,0,1,'NpcSolarPlant',NULL,24,19,NULL,1,1000,NULL,0,NULL,NULL,0),(15,6,33,13,0,0,0,1,'NpcSolarPlant',NULL,34,14,NULL,1,1000,NULL,0,NULL,NULL,0),(16,33,22,47,0,0,0,1,'NpcMetalExtractor',NULL,23,48,NULL,1,400,NULL,0,NULL,NULL,0),(17,33,1,35,0,0,0,1,'NpcMetalExtractor',NULL,2,36,NULL,1,400,NULL,0,NULL,NULL,0),(18,33,9,40,0,0,0,1,'NpcMetalExtractor',NULL,10,41,NULL,1,400,NULL,0,NULL,NULL,0),(19,33,4,41,0,0,0,1,'NpcMetalExtractor',NULL,5,42,NULL,1,400,NULL,0,NULL,NULL,0),(20,33,12,35,0,0,0,1,'NpcMetalExtractor',NULL,13,36,NULL,1,400,NULL,0,NULL,NULL,0),(21,33,5,36,0,0,0,1,'NpcMetalExtractor',NULL,6,37,NULL,1,400,NULL,0,NULL,NULL,0),(22,33,17,51,0,0,0,1,'NpcGeothermalPlant',NULL,18,52,NULL,1,600,NULL,0,NULL,NULL,0),(23,33,9,45,0,0,0,1,'NpcZetiumExtractor',NULL,10,46,NULL,1,800,NULL,0,NULL,NULL,0),(24,33,20,40,0,0,0,1,'NpcJumpgate',NULL,24,44,NULL,1,8000,NULL,0,NULL,NULL,0),(25,33,20,50,0,0,0,1,'NpcResearchCenter',NULL,23,53,NULL,1,4000,NULL,0,NULL,NULL,0),(26,33,16,42,0,0,0,1,'NpcTemple',NULL,18,44,NULL,1,1500,NULL,0,NULL,NULL,0),(27,33,8,48,0,0,0,1,'NpcCommunicationsHub',NULL,10,49,NULL,1,1200,NULL,0,NULL,NULL,0),(28,33,18,39,0,0,0,1,'NpcSolarPlant',NULL,19,40,NULL,1,1000,NULL,0,NULL,NULL,0),(29,33,15,15,0,0,0,1,'NpcSolarPlant',NULL,16,16,NULL,1,1000,NULL,0,NULL,NULL,0),(30,33,13,47,0,0,0,1,'NpcSolarPlant',NULL,14,48,NULL,1,1000,NULL,0,NULL,NULL,0),(31,38,48,18,0,0,0,1,'NpcMetalExtractor',NULL,49,19,NULL,1,400,NULL,0,NULL,NULL,0),(32,38,20,1,0,0,0,1,'NpcMetalExtractor',NULL,21,2,NULL,1,400,NULL,0,NULL,NULL,0),(33,38,32,11,0,0,0,1,'NpcMetalExtractor',NULL,33,12,NULL,1,400,NULL,0,NULL,NULL,0),(34,38,11,2,0,0,0,1,'NpcMetalExtractor',NULL,12,3,NULL,1,400,NULL,0,NULL,NULL,0),(35,38,27,8,0,0,0,1,'NpcGeothermalPlant',NULL,28,9,NULL,1,600,NULL,0,NULL,NULL,0),(36,38,12,15,0,0,0,1,'NpcGeothermalPlant',NULL,13,16,NULL,1,600,NULL,0,NULL,NULL,0),(37,38,28,19,0,0,0,1,'NpcZetiumExtractor',NULL,29,20,NULL,1,800,NULL,0,NULL,NULL,0),(38,38,6,21,0,0,0,1,'NpcZetiumExtractor',NULL,7,22,NULL,1,800,NULL,0,NULL,NULL,0),(39,38,24,2,0,0,0,1,'NpcJumpgate',NULL,28,6,NULL,1,8000,NULL,0,NULL,NULL,0),(40,38,7,12,0,0,0,1,'NpcResearchCenter',NULL,10,15,NULL,1,4000,NULL,0,NULL,NULL,0),(41,38,12,5,0,0,0,1,'NpcCommunicationsHub',NULL,14,6,NULL,1,1200,NULL,0,NULL,NULL,0),(42,38,22,14,0,0,0,1,'NpcSolarPlant',NULL,23,15,NULL,1,1000,NULL,0,NULL,NULL,0),(43,38,16,12,0,0,0,1,'NpcSolarPlant',NULL,17,13,NULL,1,1000,NULL,0,NULL,NULL,0),(44,38,35,14,0,0,0,1,'NpcSolarPlant',NULL,36,15,NULL,1,1000,NULL,0,NULL,NULL,0),(45,38,43,17,0,0,0,1,'NpcSolarPlant',NULL,44,18,NULL,1,1000,NULL,0,NULL,NULL,0),(46,39,1,10,0,0,0,1,'NpcMetalExtractor',NULL,2,11,NULL,1,400,NULL,0,NULL,NULL,0),(47,39,1,6,0,0,0,1,'NpcMetalExtractor',NULL,2,7,NULL,1,400,NULL,0,NULL,NULL,0),(48,39,2,1,0,0,0,1,'NpcMetalExtractor',NULL,3,2,NULL,1,400,NULL,0,NULL,NULL,0),(49,39,2,38,0,0,0,1,'NpcMetalExtractor',NULL,3,39,NULL,1,400,NULL,0,NULL,NULL,0),(50,39,5,20,0,0,0,1,'NpcMetalExtractor',NULL,6,21,NULL,1,400,NULL,0,NULL,NULL,0),(51,39,5,24,0,0,0,1,'NpcGeothermalPlant',NULL,6,25,NULL,1,600,NULL,0,NULL,NULL,0),(52,39,7,34,0,0,0,1,'NpcGeothermalPlant',NULL,8,35,NULL,1,600,NULL,0,NULL,NULL,0),(53,39,1,25,0,0,0,1,'NpcZetiumExtractor',NULL,2,26,NULL,1,800,NULL,0,NULL,NULL,0),(54,39,2,15,0,0,0,1,'NpcZetiumExtractor',NULL,3,16,NULL,1,800,NULL,0,NULL,NULL,0),(55,39,4,7,0,0,0,1,'NpcSolarPlant',NULL,5,8,NULL,1,1000,NULL,0,NULL,NULL,0),(56,39,9,11,0,0,0,1,'NpcSolarPlant',NULL,10,12,NULL,1,1000,NULL,0,NULL,NULL,0),(57,39,8,22,0,0,0,1,'NpcSolarPlant',NULL,9,23,NULL,1,1000,NULL,0,NULL,NULL,0),(58,43,0,0,0,0,0,1,'NpcMetalExtractor',NULL,1,1,NULL,1,400,NULL,0,NULL,NULL,0),(59,43,7,0,0,0,0,1,'NpcCommunicationsHub',NULL,9,1,NULL,1,1200,NULL,0,NULL,NULL,0),(60,43,18,0,0,0,0,1,'NpcSolarPlant',NULL,19,1,NULL,1,1000,NULL,0,NULL,NULL,0),(61,43,3,1,0,0,0,1,'NpcMetalExtractor',NULL,4,2,NULL,1,400,NULL,0,NULL,NULL,0),(62,43,12,1,0,0,0,1,'NpcSolarPlant',NULL,13,2,NULL,1,1000,NULL,0,NULL,NULL,0),(63,43,22,1,0,0,0,1,'NpcSolarPlant',NULL,23,2,NULL,1,1000,NULL,0,NULL,NULL,0),(64,43,26,1,0,0,0,1,'NpcCommunicationsHub',NULL,28,2,NULL,1,1200,NULL,0,NULL,NULL,0),(65,43,15,3,0,0,0,1,'NpcSolarPlant',NULL,16,4,NULL,1,1000,NULL,0,NULL,NULL,0),(66,43,18,3,0,0,0,1,'NpcSolarPlant',NULL,19,4,NULL,1,1000,NULL,0,NULL,NULL,0),(67,43,24,4,0,0,0,1,'NpcMetalExtractor',NULL,25,5,NULL,1,400,NULL,0,NULL,NULL,0),(68,43,28,4,0,0,0,1,'NpcMetalExtractor',NULL,29,5,NULL,1,400,NULL,0,NULL,NULL,0),(69,43,7,6,0,0,0,1,'Screamer',NULL,8,7,NULL,1,1700,NULL,0,NULL,NULL,0),(70,43,21,6,0,0,0,1,'Vulcan',NULL,22,7,NULL,1,1400,NULL,0,NULL,NULL,0),(71,43,14,7,0,0,0,1,'Thunder',NULL,15,8,NULL,1,2400,NULL,0,NULL,NULL,0),(72,43,25,7,0,0,0,1,'NpcTemple',NULL,27,9,NULL,1,1500,NULL,0,NULL,NULL,0),(73,43,11,10,0,0,0,1,'Mothership',NULL,18,15,NULL,1,10500,NULL,0,NULL,NULL,0),(74,43,7,12,0,0,0,1,'Thunder',NULL,8,13,NULL,1,2400,NULL,0,NULL,NULL,0),(75,43,21,12,0,0,0,1,'Thunder',NULL,22,13,NULL,1,2400,NULL,0,NULL,NULL,0),(76,43,26,12,0,0,0,1,'NpcZetiumExtractor',NULL,27,13,NULL,1,800,NULL,0,NULL,NULL,0),(77,43,7,19,0,0,0,1,'Vulcan',NULL,8,20,NULL,1,1400,NULL,0,NULL,NULL,0),(78,43,14,19,0,0,0,1,'Thunder',NULL,15,20,NULL,1,2400,NULL,0,NULL,NULL,0),(79,43,21,19,0,0,0,1,'Screamer',NULL,22,20,NULL,1,1700,NULL,0,NULL,NULL,0),(80,47,3,5,0,0,0,1,'NpcMetalExtractor',NULL,4,6,NULL,1,400,NULL,0,NULL,NULL,0),(81,47,12,17,0,0,0,1,'NpcMetalExtractor',NULL,13,18,NULL,1,400,NULL,0,NULL,NULL,0),(82,47,8,23,0,0,0,1,'NpcMetalExtractor',NULL,9,24,NULL,1,400,NULL,0,NULL,NULL,0),(83,47,3,15,0,0,0,1,'NpcGeothermalPlant',NULL,4,16,NULL,1,600,NULL,0,NULL,NULL,0),(84,47,7,12,0,0,0,1,'NpcZetiumExtractor',NULL,8,13,NULL,1,800,NULL,0,NULL,NULL,0),(85,47,12,8,0,0,0,1,'NpcZetiumExtractor',NULL,13,9,NULL,1,800,NULL,0,NULL,NULL,0),(86,47,19,13,0,0,0,1,'NpcSolarPlant',NULL,20,14,NULL,1,1000,NULL,0,NULL,NULL,0),(87,47,11,20,0,0,0,1,'NpcSolarPlant',NULL,12,21,NULL,1,1000,NULL,0,NULL,NULL,0),(88,47,20,28,0,0,0,1,'NpcSolarPlant',NULL,21,29,NULL,1,1000,NULL,0,NULL,NULL,0),(89,47,19,0,0,0,0,1,'NpcSolarPlant',NULL,20,1,NULL,1,1000,NULL,0,NULL,NULL,0);
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
INSERT INTO `folliages` VALUES (1,0,14,9),(1,0,15,7),(1,0,17,2),(1,1,16,8),(1,1,22,0),(1,1,28,11),(1,2,5,10),(1,2,7,10),(1,2,15,7),(1,2,20,9),(1,3,14,13),(1,3,17,7),(1,3,21,13),(1,3,22,0),(1,4,12,3),(1,4,13,6),(1,4,14,7),(1,4,17,4),(1,4,18,5),(1,5,10,11),(1,5,13,4),(1,5,24,4),(1,5,34,13),(1,6,5,5),(1,6,6,10),(1,6,23,1),(1,7,1,13),(1,7,13,1),(1,7,15,1),(1,7,16,8),(1,8,12,12),(1,8,14,0),(1,8,16,4),(1,8,24,2),(1,9,4,5),(1,9,21,10),(1,9,28,12),(1,9,36,1),(1,10,0,9),(1,10,17,2),(1,11,17,10),(1,11,18,0),(1,11,31,3),(1,12,5,2),(1,12,6,8),(1,12,17,3),(1,12,18,2),(1,12,20,4),(1,13,1,0),(1,13,2,1),(1,13,6,13),(1,13,17,7),(1,13,18,9),(1,13,22,13),(1,13,25,10),(1,13,27,0),(1,13,36,10),(1,14,1,12),(1,14,17,0),(1,14,27,2),(1,14,28,3),(1,14,29,7),(1,14,35,10),(1,14,36,3),(1,15,0,7),(1,15,1,4),(1,15,4,3),(1,15,5,11),(1,15,6,13),(1,15,8,11),(1,15,11,7),(1,15,17,9),(1,15,18,9),(1,15,19,9),(1,15,20,2),(1,15,21,10),(1,15,23,13),(1,15,25,4),(1,15,28,11),(1,15,31,4),(1,15,32,12),(6,0,1,11),(6,0,13,8),(6,0,19,3),(6,1,20,9),(6,2,15,7),(6,2,17,7),(6,3,1,11),(6,3,6,2),(6,3,15,10),(6,3,20,1),(6,4,1,13),(6,4,3,11),(6,4,6,13),(6,4,7,9),(6,5,0,0),(6,5,6,7),(6,5,7,5),(6,5,10,10),(6,5,14,2),(6,5,15,0),(6,5,16,7),(6,5,18,13),(6,6,19,1),(6,7,2,3),(6,7,4,11),(6,7,6,1),(6,8,2,4),(6,8,3,13),(6,8,4,11),(6,8,6,13),(6,8,14,0),(6,8,16,7),(6,10,4,13),(6,10,6,13),(6,11,5,8),(6,11,7,0),(6,11,20,8),(6,12,6,10),(6,12,16,0),(6,12,20,7),(6,13,7,7),(6,13,20,8),(6,14,6,4),(6,14,8,13),(6,14,9,6),(6,15,8,4),(6,15,9,0),(6,15,10,1),(6,16,3,7),(6,16,7,12),(6,16,9,13),(6,16,13,3),(6,16,18,12),(6,17,4,8),(6,17,7,7),(6,17,12,11),(6,17,18,0),(6,18,2,7),(6,18,15,4),(6,18,19,1),(6,18,20,7),(6,19,9,2),(6,19,10,9),(6,20,6,6),(6,20,11,13),(6,20,13,5),(6,21,7,4),(6,21,10,7),(6,21,12,1),(6,22,7,7),(6,22,12,0),(6,22,18,4),(6,23,6,7),(6,24,2,6),(6,24,6,13),(6,24,8,9),(6,24,9,13),(6,24,14,6),(6,24,17,4),(6,25,1,4),(6,25,10,6),(6,25,14,13),(6,25,15,10),(6,25,19,8),(6,26,3,10),(6,27,10,10),(6,27,11,11),(6,27,12,4),(6,27,15,5),(6,28,1,12),(6,28,4,4),(6,28,6,12),(6,29,0,6),(6,29,7,7),(6,30,8,6),(6,30,10,0),(6,31,10,1),(6,31,16,4),(6,32,4,1),(6,32,11,4),(6,34,5,13),(6,34,11,6),(6,34,12,0),(6,35,4,2),(6,35,14,12),(6,38,7,7),(6,38,16,8),(6,39,6,10),(6,39,7,3),(6,39,16,3),(33,0,12,2),(33,0,15,2),(33,0,16,8),(33,0,19,6),(33,0,25,10),(33,0,34,0),(33,0,40,5),(33,0,44,6),(33,0,46,9),(33,0,47,9),(33,0,49,8),(33,0,52,8),(33,0,53,0),(33,1,10,2),(33,1,12,2),(33,1,15,4),(33,1,28,3),(33,1,33,5),(33,1,49,8),(33,2,9,7),(33,2,13,1),(33,2,15,2),(33,2,16,7),(33,2,17,3),(33,2,32,3),(33,2,45,2),(33,2,46,7),(33,2,48,3),(33,2,49,6),(33,3,5,2),(33,3,9,11),(33,3,11,8),(33,3,13,12),(33,3,27,6),(33,3,32,1),(33,3,35,6),(33,3,41,1),(33,3,44,11),(33,3,48,1),(33,4,11,3),(33,4,14,1),(33,4,16,3),(33,4,19,0),(33,4,28,4),(33,4,30,7),(33,4,31,4),(33,4,39,4),(33,4,43,2),(33,5,3,8),(33,5,9,7),(33,5,13,11),(33,5,15,9),(33,5,19,9),(33,5,32,3),(33,5,50,9),(33,5,51,11),(33,6,30,6),(33,6,33,8),(33,6,35,4),(33,6,42,3),(33,6,52,0),(33,7,31,9),(33,7,52,5),(33,8,5,5),(33,8,18,8),(33,8,20,11),(33,8,24,5),(33,8,26,12),(33,8,41,6),(33,8,45,1),(33,8,47,13),(33,9,6,1),(33,9,8,1),(33,9,26,4),(33,9,27,4),(33,9,30,5),(33,10,7,11),(33,10,8,9),(33,10,9,10),(33,10,14,6),(33,10,20,8),(33,10,24,4),(33,10,25,11),(33,11,5,5),(33,11,7,11),(33,11,8,10),(33,11,27,9),(33,11,35,11),(33,11,36,6),(33,11,41,11),(33,11,43,5),(33,11,48,1),(33,11,50,5),(33,11,52,5),(33,12,4,11),(33,12,6,1),(33,12,40,3),(33,12,51,9),(33,13,5,3),(33,13,27,9),(33,13,28,12),(33,13,45,6),(33,14,0,1),(33,14,3,10),(33,14,25,2),(33,14,28,13),(33,14,43,8),(33,14,50,3),(33,14,53,5),(33,15,0,10),(33,15,19,2),(33,15,23,8),(33,15,31,11),(33,15,49,2),(33,15,50,3),(33,16,0,13),(33,16,1,0),(33,16,2,7),(33,16,3,7),(33,16,6,7),(33,16,22,4),(33,16,24,2),(33,16,25,7),(33,16,26,1),(33,16,36,13),(33,16,38,2),(33,16,48,4),(33,16,52,3),(33,17,0,4),(33,17,16,4),(33,17,17,7),(33,17,22,4),(33,17,24,3),(33,17,25,9),(33,17,26,11),(33,17,48,2),(33,17,49,13),(33,18,6,12),(33,18,16,5),(33,18,21,3),(33,19,4,3),(33,19,16,6),(33,19,17,3),(33,19,21,3),(33,19,23,6),(33,19,33,6),(33,19,47,8),(33,19,53,3),(33,20,3,7),(33,20,14,11),(33,20,18,2),(33,20,22,2),(33,20,39,1),(33,20,47,1),(33,20,48,1),(33,21,2,7),(33,21,15,12),(33,21,20,13),(33,21,23,10),(33,21,24,2),(33,21,26,11),(33,21,37,5),(33,21,47,6),(33,22,4,6),(33,22,15,2),(33,22,19,5),(33,22,26,1),(33,22,27,7),(33,22,34,12),(33,22,35,1),(33,22,37,5),(33,23,28,7),(33,23,33,5),(33,24,4,10),(33,24,5,6),(33,24,12,7),(33,24,19,11),(33,24,23,6),(33,24,26,5),(33,24,29,8),(33,24,31,5),(33,24,33,10),(33,24,37,3),(33,24,50,3),(33,24,52,5),(33,25,5,5),(33,25,11,9),(33,25,16,3),(33,25,21,10),(33,25,22,8),(33,25,24,11),(33,25,26,9),(33,25,29,13),(33,25,30,3),(33,25,31,0),(33,25,36,3),(33,25,43,3),(33,25,44,3),(33,25,46,4),(33,25,48,10),(38,0,7,6),(38,2,1,8),(38,2,9,11),(38,3,10,8),(38,4,1,8),(38,6,17,5),(38,6,18,6),(38,7,16,11),(38,7,19,1),(38,7,20,7),(38,8,0,10),(38,8,21,10),(38,9,19,7),(38,9,22,8),(38,9,23,4),(38,10,0,7),(38,10,3,9),(38,10,18,6),(38,10,21,12),(38,10,23,10),(38,11,0,8),(38,11,1,0),(38,11,4,11),(38,11,5,10),(38,11,6,0),(38,11,8,13),(38,11,17,3),(38,12,1,4),(38,12,4,5),(38,12,14,5),(38,12,18,7),(38,13,7,10),(38,13,11,6),(38,13,17,2),(38,13,20,10),(38,13,21,5),(38,14,8,10),(38,14,12,9),(38,14,16,3),(38,14,18,0),(38,14,19,4),(38,14,22,5),(38,15,7,6),(38,15,11,3),(38,15,20,4),(38,15,23,11),(38,17,2,6),(38,17,6,5),(38,17,8,2),(38,17,11,5),(38,17,19,1),(38,17,20,7),(38,18,21,0),(38,19,4,2),(38,19,8,10),(38,20,4,2),(38,20,5,1),(38,21,4,7),(38,21,5,3),(38,22,16,11),(38,22,17,0),(38,23,6,6),(38,23,9,1),(38,23,10,0),(38,23,13,11),(38,24,7,4),(38,24,11,6),(38,24,15,5),(38,24,17,8),(38,25,14,0),(38,25,15,13),(38,25,16,0),(38,26,7,6),(38,26,8,3),(38,26,9,11),(38,26,17,6),(38,27,13,2),(38,27,17,11),(38,28,7,9),(38,28,16,0),(38,29,12,5),(38,29,14,9),(38,29,15,12),(38,30,6,10),(38,30,14,4),(38,31,0,12),(38,32,5,3),(38,32,6,13),(38,33,2,7),(38,33,8,6),(38,33,9,0),(38,34,2,8),(38,34,11,11),(38,34,12,8),(38,35,7,4),(38,35,10,4),(38,35,11,1),(38,36,7,10),(38,36,11,8),(38,36,17,8),(38,36,22,7),(38,36,23,3),(38,37,4,1),(38,37,7,7),(38,37,8,8),(38,37,9,4),(38,37,11,10),(38,37,12,7),(38,37,13,11),(38,38,5,3),(38,38,7,7),(38,38,9,2),(38,38,10,3),(38,38,12,5),(38,38,19,1),(38,39,1,3),(38,39,4,2),(38,39,8,8),(38,39,12,1),(38,40,2,1),(38,40,11,2),(38,40,14,8),(38,41,17,10),(38,41,18,5),(38,41,19,9),(38,42,8,7),(38,42,10,11),(38,42,14,1),(38,42,15,12),(38,42,17,7),(38,42,18,11),(38,43,14,8),(38,43,15,8),(38,44,3,8),(38,44,7,6),(38,44,12,11),(38,45,10,10),(38,45,15,10),(38,45,17,7),(38,46,13,7),(38,46,19,2),(38,46,23,7),(38,47,7,6),(38,47,15,7),(38,47,23,0),(38,48,8,13),(38,48,15,5),(38,50,1,12),(38,50,14,5),(38,51,0,9),(38,51,13,1),(38,51,19,11),(38,51,23,9),(38,52,17,0),(38,53,17,11),(38,53,20,5),(38,53,23,5),(38,54,0,0),(38,54,2,6),(38,54,17,0),(38,54,19,4),(38,54,20,2),(38,54,21,11),(38,54,23,10),(39,0,7,3),(39,1,16,12),(39,1,41,6),(39,2,0,4),(39,2,12,7),(39,2,41,2),(39,3,20,3),(39,3,41,8),(39,3,42,12),(39,4,0,12),(39,4,1,4),(39,4,9,11),(39,4,10,5),(39,4,18,3),(39,4,28,0),(39,4,29,2),(39,4,30,2),(39,5,0,4),(39,5,2,2),(39,5,6,10),(39,6,5,7),(39,6,7,10),(39,7,0,12),(39,7,7,0),(39,7,8,4),(39,7,28,7),(39,8,0,8),(39,8,20,4),(39,8,29,5),(39,8,33,5),(39,9,21,11),(39,9,29,6),(39,9,34,0),(39,10,2,7),(39,10,22,8),(39,10,28,0),(39,10,32,10),(39,10,33,11),(39,10,34,9),(39,10,35,0),(43,0,2,8),(43,0,15,5),(43,0,23,2),(43,1,2,9),(43,1,15,11),(43,2,11,8),(43,3,3,8),(43,3,26,1),(43,4,0,8),(43,4,3,11),(43,4,20,10),(43,4,25,4),(43,5,2,9),(43,5,4,8),(43,5,5,5),(43,5,10,4),(43,5,11,12),(43,5,12,2),(43,5,15,1),(43,6,0,4),(43,6,1,9),(43,6,2,4),(43,6,21,7),(43,6,22,3),(43,6,24,11),(43,7,4,9),(43,7,5,9),(43,7,11,9),(43,7,17,9),(43,7,22,11),(43,7,29,0),(43,8,2,12),(43,8,8,3),(43,8,14,2),(43,8,21,1),(43,9,2,7),(43,9,11,7),(43,9,21,1),(43,10,10,5),(43,10,14,12),(43,10,15,10),(43,11,4,7),(43,11,17,8),(43,11,29,12),(43,12,16,9),(43,12,17,3),(43,12,21,2),(43,13,17,11),(43,13,20,7),(43,13,28,3),(43,14,9,5),(43,14,16,8),(43,14,22,2),(43,14,23,7),(43,14,24,8),(43,14,29,8),(43,15,26,4),(43,16,5,6),(43,16,7,6),(43,16,17,0),(43,16,18,5),(43,16,20,4),(43,16,26,7),(43,16,28,4),(43,17,5,12),(43,17,16,0),(43,17,21,13),(43,17,25,0),(43,17,26,13),(43,18,7,11),(43,18,16,7),(43,18,19,9),(43,18,20,1),(43,18,22,7),(43,19,7,2),(43,19,11,11),(43,19,13,1),(43,19,17,2),(43,19,18,4),(43,19,19,7),(43,19,22,11),(43,19,25,10),(43,20,6,5),(43,20,9,8),(43,20,12,7),(43,20,18,8),(43,20,21,6),(43,20,24,1),(43,20,25,9),(43,20,27,0),(43,21,5,1),(43,21,21,3),(43,21,25,8),(43,21,27,0),(43,21,28,7),(43,22,9,2),(43,22,17,6),(43,23,13,0),(43,23,16,1),(43,23,23,12),(43,23,24,12),(43,24,6,13),(43,24,12,12),(43,24,15,10),(43,24,23,9),(43,24,24,2),(43,25,14,7),(43,25,21,0),(43,26,15,7),(43,26,16,5),(43,26,18,0),(43,26,20,8),(43,26,24,0),(43,26,26,10),(43,27,16,2),(43,27,19,11),(43,27,25,1),(43,28,11,11),(43,28,29,3),(43,29,3,4),(47,0,10,9),(47,0,12,13),(47,0,14,11),(47,0,19,7),(47,0,20,0),(47,0,21,5),(47,0,28,0),(47,1,0,3),(47,1,19,10),(47,1,21,9),(47,2,4,1),(47,2,5,5),(47,2,6,6),(47,3,1,8),(47,3,2,7),(47,3,4,11),(47,3,7,4),(47,3,17,9),(47,3,18,13),(47,3,19,9),(47,4,2,7),(47,4,3,8),(47,4,17,8),(47,4,21,0),(47,5,4,10),(47,5,17,0),(47,5,22,8),(47,5,27,3),(47,6,2,2),(47,6,4,6),(47,6,5,6),(47,6,6,8),(47,7,0,1),(47,7,9,10),(47,7,16,9),(47,7,18,7),(47,7,25,9),(47,8,2,1),(47,8,3,5),(47,9,0,1),(47,9,1,6),(47,9,2,1),(47,9,4,1),(47,9,7,2),(47,9,9,8),(47,10,7,9),(47,10,16,6),(47,10,18,4),(47,11,3,7),(47,11,16,12),(47,11,18,2),(47,12,11,8),(47,12,13,7),(47,12,19,2),(47,13,5,13),(47,13,10,5),(47,13,14,1),(47,13,16,9),(47,14,5,8),(47,14,12,4),(47,14,14,5),(47,14,24,11),(47,15,7,2),(47,15,10,12),(47,15,14,9),(47,15,21,0),(47,16,8,0),(47,16,12,0),(47,16,23,6),(47,17,21,6),(47,18,0,7),(47,18,6,4),(47,18,8,6),(47,18,21,4),(47,19,3,5),(47,19,5,2),(47,19,8,6),(47,19,19,1),(47,19,29,13),(47,20,2,2),(47,20,5,9),(47,21,2,0),(47,21,5,11),(47,21,7,5),(47,21,20,3),(47,22,0,12),(47,22,7,13),(47,22,11,0),(47,22,20,0),(47,22,28,2);
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
INSERT INTO `galaxies` VALUES (1,'2010-12-08 15:44:35','dev');
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
INSERT INTO `quests` VALUES (1,NULL,'{\"metal\":100,\"energy\":100,\"zetium\":100}','resources'),(2,NULL,'{\"units\":[{\"level\":1,\"count\":5,\"type\":\"Trooper\",\"hp\":100}]}','army'),(3,2,'{\"metal\":300,\"energy\":500,\"zetium\":400}','units'),(4,3,'{\"units\":[{\"level\":3,\"count\":3,\"type\":\"Shocker\",\"hp\":100},{\"level\":3,\"count\":3,\"type\":\"Seeker\",\"hp\":100}],\"zetium\":100}','units'),(5,4,'{\"units\":[{\"level\":3,\"count\":1,\"type\":\"Scorpion\",\"hp\":100}]}','combat'),(6,5,'{\"units\":[{\"level\":1,\"count\":2,\"type\":\"Scorpion\",\"hp\":100}]}','ground-factory'),(7,6,'{\"units\":[{\"level\":1,\"count\":2,\"type\":\"Crow\",\"hp\":100}]}','space-factory'),(8,7,'{\"metal\":2000,\"energy\":2000,\"zetium\":1500}','annexation'),(9,8,'{\"xp\":1000,\"metal\":2000,\"energy\":2000,\"units\":[{\"level\":2,\"count\":1,\"type\":\"Cyrix\",\"hp\":100}],\"zetium\":1500,\"points\":2000}','enemy-annexation'),(10,4,'{\"xp\":1000,\"zetium\":1000,\"points\":1000}',NULL);
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
INSERT INTO `schema_migrations` VALUES ('20090601175224'),('20090601184051'),('20090601184055'),('20090601184059'),('20090701164131'),('20090713165021'),('20090808144214'),('20090809160211'),('20090810173759'),('20090826140238'),('20090826141836'),('20090829202538'),('20090829210029'),('20090829224505'),('20090830143959'),('20090830145319'),('20090901153809'),('20090904190655'),('20090905175341'),('20090905192056'),('20090906135044'),('20090909222719'),('20090911180950'),('20090912165229'),('20090919155819'),('20091024222359'),('20091103164416'),('20091103180558'),('20091103181146'),('20091109191211'),('20091225193714'),('20100114152902'),('20100121142414'),('20100127115341'),('20100127120219'),('20100127120515'),('20100127121337'),('20100129150736'),('20100203202757'),('20100203204803'),('20100204172507'),('20100204173714'),('20100208163239'),('20100210114531'),('20100212134334'),('20100218181507'),('20100219114448'),('20100220144106'),('20100222144003'),('20100223153023'),('20100224153728'),('20100224163525'),('20100225124928'),('20100225153721'),('20100225155505'),('20100225155739'),('20100226122144'),('20100226122651'),('20100301153626'),('20100302131225'),('20100303131706'),('20100308163148'),('20100308164422'),('20100310172315'),('20100310181338'),('20100311123523'),('20100315112858'),('20100319141401'),('20100322184529'),('20100324134243'),('20100324141652'),('20100331125702'),('20100415130556'),('20100415130600'),('20100415130605'),('20100415134627'),('20100419141518'),('20100419142018'),('20100419164230'),('20100426141509'),('20100428130912'),('20100429171200'),('20100430174140'),('20100610151652'),('20100610180750'),('20100614142225'),('20100614160819'),('20100614162423'),('20100616132525'),('20100616135507'),('20100622124252'),('20100706105523'),('20100710121447'),('20100710191351'),('20100716155807'),('20100719131622'),('20100721155359'),('20100722124307'),('20100812164444'),('20100812164449'),('20100812164518'),('20100812164524'),('20100817165213'),('20100819175736'),('20100820185846'),('20100906095758'),('20100915145823'),('20100929111549'),('20101001155323'),('20101005180058'),('20101022155620'),('20101117131430'),('20101208135417'),('99999999999000'),('99999999999900');
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
INSERT INTO `solar_systems` VALUES (1,'Expansion',1,1,2),(2,'Resource',1,0,2),(3,'Expansion',1,2,0),(4,'Homeworld',1,1,1);
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
) ENGINE=InnoDB AUTO_INCREMENT=50 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ss_objects`
--

LOCK TABLES `ss_objects` WRITE;
/*!40000 ALTER TABLE `ss_objects` DISABLE KEYS */;
INSERT INTO `ss_objects` VALUES (1,1,16,37,1,45,'Planet',NULL,'P-1',47,1,0,0,0,0,0,0,0,0,0,'2010-12-08 15:44:41',0,NULL,NULL,NULL),(2,1,0,0,2,90,'Asteroid',NULL,'',28,0,0,0,1,0,0,3,0,0,1,NULL,0,NULL,NULL,NULL),(3,1,0,0,2,120,'Asteroid',NULL,'',55,0,0,0,0,0,0,1,0,0,0,NULL,0,NULL,NULL,NULL),(4,1,0,0,2,150,'Asteroid',NULL,'',55,0,0,0,2,0,0,3,0,0,1,NULL,0,NULL,NULL,NULL),(5,1,0,0,3,246,'Jumpgate',NULL,'',54,0,0,0,0,0,0,0,0,0,0,NULL,0,NULL,NULL,NULL),(6,1,40,21,2,330,'Planet',NULL,'P-6',50,2,0,0,0,0,0,0,0,0,0,'2010-12-08 15:44:41',0,NULL,NULL,NULL),(7,1,0,0,0,270,'Asteroid',NULL,'',32,0,0,0,2,0,0,2,0,0,2,NULL,0,NULL,NULL,NULL),(8,1,0,0,2,0,'Asteroid',NULL,'',45,0,0,0,0,0,0,1,0,0,0,NULL,0,NULL,NULL,NULL),(9,1,0,0,3,292,'Jumpgate',NULL,'',52,0,0,0,0,0,0,0,0,0,0,NULL,0,NULL,NULL,NULL),(10,1,0,0,0,180,'Asteroid',NULL,'',50,0,0,0,0,0,0,1,0,0,1,NULL,0,NULL,NULL,NULL),(11,1,0,0,2,300,'Asteroid',NULL,'',35,0,0,0,3,0,0,2,0,0,1,NULL,0,NULL,NULL,NULL),(12,1,0,0,0,0,'Asteroid',NULL,'',48,0,0,0,1,0,0,1,0,0,0,NULL,0,NULL,NULL,NULL),(13,2,0,0,1,225,'Asteroid',NULL,'',43,0,0,0,0,0,0,1,0,0,0,NULL,0,NULL,NULL,NULL),(14,2,0,0,2,120,'Asteroid',NULL,'',52,0,0,0,2,0,0,2,0,0,1,NULL,0,NULL,NULL,NULL),(15,2,0,0,3,22,'Jumpgate',NULL,'',46,0,0,0,0,0,0,0,0,0,0,NULL,0,NULL,NULL,NULL),(16,2,0,0,1,180,'Asteroid',NULL,'',28,0,0,0,0,0,0,1,0,0,1,NULL,0,NULL,NULL,NULL),(17,2,0,0,3,134,'Jumpgate',NULL,'',46,0,0,0,0,0,0,0,0,0,0,NULL,0,NULL,NULL,NULL),(18,2,0,0,1,315,'Asteroid',NULL,'',38,0,0,0,1,0,0,3,0,0,3,NULL,0,NULL,NULL,NULL),(19,2,0,0,3,66,'Jumpgate',NULL,'',58,0,0,0,0,0,0,0,0,0,0,NULL,0,NULL,NULL,NULL),(20,2,0,0,1,0,'Asteroid',NULL,'',48,0,0,0,3,0,0,3,0,0,2,NULL,0,NULL,NULL,NULL),(21,2,0,0,1,270,'Asteroid',NULL,'',44,0,0,0,1,0,0,2,0,0,2,NULL,0,NULL,NULL,NULL),(22,2,0,0,2,150,'Asteroid',NULL,'',59,0,0,0,1,0,0,1,0,0,1,NULL,0,NULL,NULL,NULL),(23,2,0,0,2,180,'Asteroid',NULL,'',59,0,0,0,1,0,0,0,0,0,0,NULL,0,NULL,NULL,NULL),(24,2,0,0,0,90,'Asteroid',NULL,'',45,0,0,0,3,0,0,1,0,0,2,NULL,0,NULL,NULL,NULL),(25,2,0,0,0,180,'Asteroid',NULL,'',36,0,0,0,2,0,0,3,0,0,2,NULL,0,NULL,NULL,NULL),(26,2,0,0,2,300,'Asteroid',NULL,'',32,0,0,0,2,0,0,1,0,0,1,NULL,0,NULL,NULL,NULL),(27,3,0,0,1,45,'Asteroid',NULL,'',28,0,0,0,3,0,0,3,0,0,3,NULL,0,NULL,NULL,NULL),(28,3,0,0,1,225,'Asteroid',NULL,'',55,0,0,0,0,0,0,1,0,0,0,NULL,0,NULL,NULL,NULL),(29,3,0,0,2,120,'Asteroid',NULL,'',45,0,0,0,3,0,0,3,0,0,2,NULL,0,NULL,NULL,NULL),(30,3,0,0,2,210,'Asteroid',NULL,'',30,0,0,0,2,0,0,2,0,0,2,NULL,0,NULL,NULL,NULL),(31,3,0,0,1,180,'Asteroid',NULL,'',31,0,0,0,0,0,0,1,0,0,0,NULL,0,NULL,NULL,NULL),(32,3,0,0,1,315,'Asteroid',NULL,'',58,0,0,0,1,0,0,2,0,0,1,NULL,0,NULL,NULL,NULL),(33,3,26,54,1,0,'Planet',NULL,'P-33',58,0,0,0,0,0,0,0,0,0,0,'2010-12-08 15:44:41',0,NULL,NULL,NULL),(34,3,0,0,2,60,'Asteroid',NULL,'',41,0,0,0,1,0,0,1,0,0,0,NULL,0,NULL,NULL,NULL),(35,3,0,0,2,30,'Asteroid',NULL,'',29,0,0,0,3,0,0,3,0,0,1,NULL,0,NULL,NULL,NULL),(36,3,0,0,0,90,'Asteroid',NULL,'',47,0,0,0,1,0,0,0,0,0,0,NULL,0,NULL,NULL,NULL),(37,3,0,0,3,336,'Jumpgate',NULL,'',51,0,0,0,0,0,0,0,0,0,0,NULL,0,NULL,NULL,NULL),(38,3,55,24,0,270,'Planet',NULL,'P-38',58,1,0,0,0,0,0,0,0,0,0,'2010-12-08 15:44:41',0,NULL,NULL,NULL),(39,3,11,43,2,0,'Planet',NULL,'P-39',47,2,0,0,0,0,0,0,0,0,0,'2010-12-08 15:44:41',0,NULL,NULL,NULL),(40,3,0,0,2,270,'Asteroid',NULL,'',38,0,0,0,1,0,0,0,0,0,1,NULL,0,NULL,NULL,NULL),(41,3,0,0,0,0,'Asteroid',NULL,'',60,0,0,0,3,0,0,2,0,0,1,NULL,0,NULL,NULL,NULL),(42,4,0,0,3,180,'Jumpgate',NULL,'',41,0,0,0,0,0,0,0,0,0,0,NULL,0,NULL,NULL,NULL),(43,4,30,30,0,90,'Planet',1,'P-43',50,0,864,20,3024,1728,40,6048,0,0,604.8,'2010-12-08 15:44:41',0,NULL,NULL,NULL),(44,4,0,0,2,330,'Asteroid',NULL,'',41,0,0,0,1,0,0,1,0,0,1,NULL,0,NULL,NULL,NULL),(45,4,0,0,1,315,'Asteroid',NULL,'',38,0,0,0,1,0,0,0,0,0,0,NULL,0,NULL,NULL,NULL),(46,4,0,0,0,180,'Asteroid',NULL,'',46,0,0,0,1,0,0,1,0,0,0,NULL,0,NULL,NULL,NULL),(47,4,23,30,1,0,'Planet',NULL,'P-47',47,1,0,0,0,0,0,0,0,0,0,'2010-12-08 15:44:41',0,NULL,NULL,NULL),(48,4,0,0,2,300,'Asteroid',NULL,'',54,0,0,0,0,0,0,1,0,0,1,NULL,0,NULL,NULL,NULL),(49,4,0,0,0,0,'Asteroid',NULL,'',26,0,0,0,1,0,0,1,0,0,0,NULL,0,NULL,NULL,NULL);
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
INSERT INTO `tiles` VALUES (5,1,0,0),(5,1,0,1),(5,1,0,2),(5,1,0,3),(5,1,0,4),(5,1,0,5),(5,1,0,6),(9,1,0,8),(6,1,0,23),(6,1,0,24),(6,1,0,25),(6,1,0,26),(6,1,0,27),(6,1,0,28),(4,1,0,31),(4,1,0,32),(4,1,0,33),(4,1,0,34),(4,1,0,35),(4,1,0,36),(10,1,1,0),(5,1,1,4),(5,1,1,5),(6,1,1,26),(11,1,1,31),(5,1,2,4),(0,1,2,18),(6,1,2,25),(6,1,2,26),(10,1,2,27),(4,1,3,6),(1,1,3,24),(6,1,3,26),(4,1,4,6),(4,1,4,7),(4,1,4,8),(6,1,4,26),(9,1,5,2),(4,1,5,6),(4,1,5,7),(4,1,5,8),(0,1,5,14),(11,1,5,17),(6,1,5,25),(6,1,5,26),(6,1,5,33),(5,1,5,35),(4,1,6,7),(4,1,6,8),(5,1,6,11),(5,1,6,12),(6,1,6,25),(6,1,6,26),(8,1,6,28),(6,1,6,32),(6,1,6,33),(5,1,6,34),(5,1,6,35),(5,1,6,36),(0,1,7,9),(5,1,7,11),(5,1,7,12),(6,1,7,26),(6,1,7,27),(6,1,7,31),(6,1,7,32),(6,1,7,33),(6,1,7,34),(5,1,7,35),(5,1,7,36),(5,1,8,11),(6,1,8,25),(6,1,8,26),(6,1,8,27),(6,1,8,33),(5,1,8,34),(5,1,8,35),(5,1,8,36),(4,1,9,2),(3,1,9,6),(3,1,9,7),(3,1,9,8),(3,1,9,9),(5,1,9,10),(5,1,9,11),(4,1,9,12),(4,1,9,13),(4,1,9,14),(13,1,9,15),(3,1,9,25),(6,1,9,32),(6,1,9,33),(5,1,9,34),(3,1,9,35),(4,1,10,1),(4,1,10,2),(4,1,10,3),(4,1,10,4),(3,1,10,6),(3,1,10,7),(3,1,10,8),(3,1,10,9),(5,1,10,10),(5,1,10,11),(5,1,10,12),(4,1,10,13),(4,1,10,14),(3,1,10,24),(3,1,10,25),(3,1,10,26),(3,1,10,27),(3,1,10,28),(3,1,10,29),(0,1,10,32),(3,1,10,35),(3,1,10,36),(4,1,11,1),(4,1,11,2),(4,1,11,3),(3,1,11,7),(3,1,11,8),(5,1,11,9),(5,1,11,10),(5,1,11,11),(5,1,11,12),(4,1,11,13),(4,1,11,14),(3,1,11,24),(3,1,11,25),(0,1,11,26),(3,1,11,34),(3,1,11,35),(3,1,11,36),(4,1,12,3),(4,1,12,7),(5,1,12,10),(5,1,12,11),(5,1,12,12),(4,1,12,13),(4,1,12,14),(3,1,12,24),(4,1,12,31),(4,1,12,32),(3,1,12,34),(3,1,12,35),(3,1,12,36),(4,1,13,7),(4,1,13,8),(4,1,13,9),(5,1,13,10),(5,1,13,12),(2,1,13,19),(4,1,13,31),(4,1,13,32),(4,1,13,33),(4,1,13,34),(3,1,13,35),(4,1,14,7),(4,1,14,8),(4,1,14,9),(5,1,14,10),(4,1,14,31),(4,1,14,32),(4,1,14,34),(4,1,15,7),(4,1,15,9),(8,6,0,6),(3,6,0,9),(3,6,0,10),(3,6,0,11),(6,6,0,14),(6,6,0,15),(6,6,0,16),(6,6,0,17),(3,6,1,9),(3,6,1,11),(3,6,1,12),(3,6,1,13),(6,6,1,16),(3,6,2,9),(3,6,2,10),(3,6,2,11),(3,6,2,12),(6,6,2,16),(3,6,3,7),(3,6,3,8),(3,6,3,9),(3,6,3,10),(3,6,3,11),(3,6,4,8),(3,6,4,11),(6,6,6,1),(6,6,6,2),(6,6,6,3),(6,6,6,4),(6,6,6,5),(6,6,6,6),(14,6,6,8),(14,6,9,8),(5,6,10,1),(5,6,10,2),(5,6,11,0),(5,6,11,1),(5,6,11,2),(5,6,11,3),(5,6,11,4),(5,6,12,0),(5,6,12,1),(5,6,12,2),(5,6,12,3),(5,6,13,0),(5,6,13,1),(5,6,13,2),(5,6,13,3),(5,6,13,4),(5,6,13,5),(4,6,13,11),(4,6,13,12),(4,6,13,13),(4,6,13,14),(5,6,14,0),(5,6,14,1),(5,6,14,2),(4,6,14,11),(4,6,14,12),(4,6,14,13),(4,6,14,14),(5,6,15,0),(5,6,15,1),(5,6,15,2),(4,6,15,11),(4,6,15,12),(4,6,15,13),(4,6,15,14),(6,6,15,16),(6,6,15,17),(4,6,16,12),(4,6,16,14),(6,6,16,16),(6,6,16,17),(5,6,17,0),(6,6,17,16),(6,6,17,17),(5,6,18,0),(5,6,18,1),(5,6,19,1),(5,6,19,2),(3,6,19,15),(3,6,19,16),(5,6,20,1),(5,6,20,2),(5,6,20,3),(0,6,20,4),(3,6,20,14),(3,6,20,15),(0,6,20,16),(5,6,21,1),(5,6,21,3),(3,6,21,13),(3,6,21,14),(3,6,21,15),(4,6,21,19),(4,6,21,20),(5,6,22,1),(5,6,22,2),(5,6,22,3),(5,6,22,4),(5,6,22,5),(3,6,22,10),(3,6,22,11),(3,6,22,13),(3,6,22,14),(4,6,22,20),(5,6,23,0),(5,6,23,1),(5,6,23,3),(5,6,23,4),(5,6,23,5),(3,6,23,10),(3,6,23,11),(3,6,23,12),(3,6,23,13),(3,6,23,14),(4,6,23,20),(5,6,24,0),(5,6,24,5),(4,6,24,7),(3,6,24,13),(4,6,24,20),(5,6,25,0),(4,6,25,4),(4,6,25,5),(4,6,25,6),(4,6,25,7),(3,6,25,13),(4,6,25,17),(4,6,25,20),(4,6,26,4),(4,6,26,5),(4,6,26,6),(4,6,26,7),(0,6,26,8),(4,6,26,17),(4,6,26,18),(4,6,26,19),(4,6,26,20),(4,6,27,4),(4,6,27,5),(4,6,27,6),(4,6,27,7),(3,6,27,13),(3,6,27,14),(3,6,27,16),(3,6,27,17),(3,6,27,18),(3,6,27,19),(4,6,27,20),(4,6,28,5),(3,6,28,11),(3,6,28,12),(3,6,28,13),(3,6,28,14),(3,6,28,15),(3,6,28,16),(3,6,28,17),(3,6,28,18),(3,6,28,19),(4,6,28,20),(4,6,29,5),(4,6,29,6),(9,6,29,12),(3,6,29,15),(3,6,29,16),(9,6,29,17),(4,6,29,20),(10,6,30,0),(4,6,30,4),(4,6,30,5),(4,6,30,6),(4,6,30,7),(4,6,30,15),(3,6,30,16),(5,6,30,20),(4,6,31,5),(4,6,31,7),(4,6,31,8),(4,6,31,9),(4,6,31,15),(5,6,31,20),(4,6,32,5),(4,6,32,6),(4,6,32,7),(4,6,32,15),(4,6,32,16),(5,6,32,20),(4,6,33,5),(0,6,33,9),(4,6,33,15),(4,6,33,16),(4,6,33,17),(4,6,33,18),(5,6,33,19),(5,6,33,20),(3,6,34,0),(3,6,34,1),(4,6,34,15),(4,6,34,16),(4,6,34,17),(4,6,34,18),(5,6,34,19),(5,6,34,20),(3,6,35,0),(3,6,35,1),(3,6,35,2),(6,6,35,7),(6,6,35,8),(6,6,35,9),(6,6,35,10),(6,6,35,13),(4,6,35,17),(4,6,35,18),(5,6,35,19),(5,6,35,20),(3,6,36,0),(3,6,36,1),(3,6,36,2),(3,6,36,3),(3,6,36,4),(3,6,36,5),(6,6,36,9),(6,6,36,10),(6,6,36,13),(6,6,36,14),(0,6,36,15),(5,6,36,17),(5,6,36,18),(5,6,36,19),(5,6,36,20),(3,6,37,0),(3,6,37,1),(3,6,37,2),(2,6,37,3),(1,6,37,10),(6,6,37,12),(6,6,37,13),(6,6,37,14),(5,6,37,17),(5,6,37,18),(5,6,37,19),(5,6,37,20),(3,6,38,0),(3,6,38,1),(5,6,38,17),(5,6,38,18),(5,6,38,19),(5,6,38,20),(3,6,39,0),(3,6,39,1),(5,6,39,17),(5,6,39,19),(5,33,0,0),(5,33,0,1),(5,33,0,2),(5,33,0,3),(5,33,0,4),(5,33,0,5),(5,33,0,6),(5,33,0,7),(5,33,0,20),(5,33,0,21),(5,33,0,22),(5,33,0,23),(5,33,0,26),(5,33,0,27),(5,33,0,28),(5,33,0,29),(5,33,0,30),(6,33,0,37),(5,33,1,0),(9,33,1,1),(5,33,1,4),(5,33,1,5),(5,33,1,6),(5,33,1,7),(5,33,1,8),(5,33,1,20),(5,33,1,21),(5,33,1,22),(5,33,1,23),(5,33,1,24),(5,33,1,25),(5,33,1,26),(5,33,1,27),(5,33,1,29),(5,33,1,30),(0,33,1,35),(6,33,1,37),(6,33,1,38),(6,33,1,39),(6,33,1,40),(5,33,2,0),(5,33,2,4),(5,33,2,5),(5,33,2,6),(5,33,2,7),(5,33,2,19),(5,33,2,20),(5,33,2,21),(5,33,2,22),(5,33,2,23),(5,33,2,24),(5,33,2,25),(5,33,2,26),(5,33,2,27),(5,33,2,28),(5,33,2,29),(5,33,2,30),(6,33,2,37),(6,33,2,39),(6,33,2,40),(6,33,2,41),(5,33,3,0),(5,33,3,21),(5,33,3,23),(5,33,3,24),(5,33,3,25),(5,33,3,26),(5,33,3,28),(6,33,3,36),(6,33,3,37),(6,33,3,38),(6,33,3,40),(0,33,3,51),(5,33,4,0),(3,33,4,17),(5,33,4,21),(5,33,4,22),(5,33,4,23),(5,33,4,24),(5,33,4,25),(5,33,4,26),(5,33,4,27),(6,33,4,40),(0,33,4,41),(11,33,4,44),(5,33,5,0),(5,33,5,1),(5,33,5,2),(5,33,5,4),(5,33,5,5),(8,33,5,6),(3,33,5,16),(3,33,5,17),(3,33,5,18),(5,33,5,21),(5,33,5,22),(5,33,5,23),(5,33,5,24),(5,33,5,25),(0,33,5,36),(5,33,6,0),(5,33,6,1),(5,33,6,2),(5,33,6,3),(5,33,6,4),(5,33,6,5),(11,33,6,9),(3,33,6,15),(3,33,6,16),(3,33,6,17),(3,33,6,18),(3,33,6,19),(5,33,6,21),(5,33,6,23),(5,33,6,24),(5,33,6,25),(5,33,6,26),(5,33,6,27),(3,33,6,39),(6,33,6,50),(5,33,7,0),(5,33,7,1),(3,33,7,2),(3,33,7,3),(5,33,7,4),(5,33,7,5),(3,33,7,15),(3,33,7,16),(3,33,7,17),(4,33,7,18),(4,33,7,19),(4,33,7,20),(5,33,7,21),(5,33,7,26),(3,33,7,34),(3,33,7,35),(3,33,7,36),(3,33,7,37),(3,33,7,38),(3,33,7,39),(3,33,7,40),(6,33,7,50),(6,33,7,51),(5,33,8,0),(5,33,8,1),(3,33,8,2),(5,33,8,3),(5,33,8,4),(3,33,8,16),(4,33,8,19),(4,33,8,21),(4,33,8,23),(3,33,8,35),(3,33,8,37),(3,33,8,38),(3,33,8,39),(6,33,8,43),(6,33,8,50),(6,33,8,51),(6,33,8,52),(5,33,9,0),(5,33,9,1),(5,33,9,2),(5,33,9,3),(5,33,9,4),(5,33,9,5),(3,33,9,15),(3,33,9,16),(4,33,9,17),(4,33,9,18),(4,33,9,19),(4,33,9,20),(4,33,9,21),(4,33,9,23),(13,33,9,32),(3,33,9,36),(3,33,9,37),(3,33,9,39),(0,33,9,40),(6,33,9,43),(6,33,9,44),(2,33,9,45),(6,33,9,50),(6,33,9,51),(6,33,9,52),(6,33,9,53),(5,33,10,0),(5,33,10,1),(5,33,10,4),(3,33,10,15),(3,33,10,16),(4,33,10,17),(4,33,10,18),(4,33,10,19),(4,33,10,21),(4,33,10,22),(4,33,10,23),(4,33,10,30),(3,33,10,37),(4,33,10,42),(6,33,10,43),(6,33,10,44),(6,33,10,50),(6,33,10,51),(6,33,10,52),(6,33,10,53),(5,33,11,0),(5,33,11,1),(3,33,11,14),(3,33,11,15),(3,33,11,16),(4,33,11,17),(4,33,11,18),(4,33,11,19),(4,33,11,20),(4,33,11,21),(4,33,11,22),(4,33,11,23),(4,33,11,28),(4,33,11,30),(4,33,11,31),(3,33,11,37),(3,33,11,38),(3,33,11,39),(4,33,11,42),(6,33,11,44),(5,33,12,1),(5,33,12,2),(5,33,12,7),(6,33,12,9),(3,33,12,12),(3,33,12,13),(3,33,12,14),(3,33,12,15),(3,33,12,16),(4,33,12,17),(4,33,12,18),(4,33,12,19),(4,33,12,20),(4,33,12,21),(4,33,12,23),(4,33,12,24),(4,33,12,25),(4,33,12,26),(4,33,12,27),(4,33,12,28),(4,33,12,29),(4,33,12,30),(4,33,12,31),(0,33,12,35),(3,33,12,37),(4,33,12,38),(4,33,12,41),(4,33,12,42),(4,33,12,43),(6,33,12,44),(6,33,12,45),(5,33,13,0),(5,33,13,1),(5,33,13,2),(5,33,13,7),(6,33,13,8),(6,33,13,9),(6,33,13,10),(3,33,13,13),(3,33,13,14),(3,33,13,15),(3,33,13,16),(3,33,13,17),(4,33,13,19),(4,33,13,20),(4,33,13,21),(4,33,13,22),(4,33,13,23),(4,33,13,29),(4,33,13,30),(4,33,13,31),(4,33,13,37),(4,33,13,38),(4,33,13,40),(4,33,13,41),(6,33,13,42),(6,33,13,43),(6,33,13,44),(5,33,14,2),(5,33,14,7),(6,33,14,8),(6,33,14,9),(6,33,14,10),(6,33,14,11),(6,33,14,12),(6,33,14,13),(6,33,14,14),(3,33,14,15),(3,33,14,17),(3,33,14,18),(4,33,14,21),(4,33,14,22),(4,33,14,29),(4,33,14,30),(4,33,14,31),(4,33,14,35),(4,33,14,36),(4,33,14,38),(4,33,14,39),(4,33,14,40),(4,33,14,41),(6,33,14,42),(6,33,14,44),(6,33,14,45),(5,33,15,7),(5,33,15,8),(5,33,15,9),(6,33,15,10),(6,33,15,11),(5,33,15,13),(3,33,15,17),(3,33,15,18),(4,33,15,30),(4,33,15,36),(4,33,15,37),(4,33,15,38),(4,33,15,39),(4,33,15,40),(4,33,15,41),(4,33,15,42),(4,33,15,43),(4,33,15,44),(13,33,15,45),(5,33,16,8),(5,33,16,9),(5,33,16,10),(6,33,16,11),(5,33,16,13),(5,33,16,14),(3,33,16,17),(3,33,16,18),(3,33,16,19),(9,33,16,27),(4,33,16,30),(0,33,16,31),(4,33,16,37),(4,33,16,40),(4,33,16,41),(5,33,17,7),(5,33,17,8),(5,33,17,9),(5,33,17,10),(5,33,17,11),(5,33,17,12),(5,33,17,13),(5,33,17,14),(3,33,17,18),(4,33,17,30),(10,33,17,34),(4,33,17,38),(4,33,17,39),(4,33,17,40),(4,33,17,41),(1,33,17,51),(5,33,18,5),(5,33,18,7),(5,33,18,8),(5,33,18,9),(5,33,18,10),(5,33,18,11),(5,33,18,13),(3,33,18,18),(4,33,18,30),(4,33,18,31),(4,33,18,32),(4,33,18,33),(4,33,18,38),(4,33,18,41),(5,33,19,5),(5,33,19,6),(5,33,19,7),(5,33,19,8),(5,33,19,9),(5,33,19,10),(5,33,19,11),(5,33,19,12),(5,33,19,13),(5,33,19,14),(5,33,19,15),(4,33,19,31),(4,33,19,32),(4,33,19,41),(4,33,19,42),(4,33,19,43),(4,33,19,44),(3,33,20,0),(3,33,20,1),(3,33,20,2),(5,33,20,9),(5,33,20,10),(5,33,20,11),(5,33,20,12),(5,33,20,13),(4,33,20,30),(4,33,20,31),(4,33,20,32),(3,33,21,0),(3,33,21,1),(5,33,21,8),(5,33,21,9),(5,33,21,10),(5,33,21,11),(5,33,21,12),(5,33,21,13),(3,33,21,17),(4,33,21,29),(4,33,21,30),(4,33,21,31),(4,33,21,32),(3,33,22,0),(3,33,22,1),(3,33,22,2),(3,33,22,3),(6,33,22,6),(6,33,22,7),(5,33,22,8),(5,33,22,9),(5,33,22,10),(5,33,22,11),(5,33,22,13),(3,33,22,14),(3,33,22,17),(4,33,22,30),(4,33,22,31),(0,33,22,47),(3,33,23,0),(3,33,23,1),(3,33,23,2),(3,33,23,3),(6,33,23,4),(6,33,23,5),(6,33,23,6),(6,33,23,7),(6,33,23,8),(5,33,23,11),(5,33,23,12),(5,33,23,13),(3,33,23,14),(3,33,23,15),(3,33,23,16),(3,33,23,17),(3,33,23,18),(3,33,23,19),(3,33,23,20),(3,33,23,21),(4,33,23,29),(4,33,23,30),(3,33,24,0),(3,33,24,1),(3,33,24,2),(3,33,24,3),(6,33,24,6),(6,33,24,7),(6,33,24,8),(6,33,24,9),(3,33,24,15),(3,33,24,16),(3,33,24,18),(3,33,24,20),(3,33,24,21),(3,33,25,0),(3,33,25,2),(3,33,25,3),(6,33,25,7),(6,33,25,8),(6,33,25,9),(3,33,25,15),(3,33,25,17),(3,33,25,18),(3,33,25,19),(3,38,0,0),(3,38,0,1),(3,38,0,2),(3,38,0,3),(3,38,0,4),(3,38,0,5),(3,38,0,6),(3,38,0,8),(3,38,0,9),(4,38,0,11),(4,38,0,12),(4,38,0,13),(4,38,0,14),(4,38,0,15),(4,38,0,16),(4,38,0,17),(4,38,0,18),(4,38,0,19),(4,38,0,20),(4,38,0,21),(4,38,0,22),(4,38,0,23),(3,38,1,0),(3,38,1,1),(3,38,1,2),(3,38,1,3),(3,38,1,4),(3,38,1,5),(3,38,1,6),(3,38,1,7),(3,38,1,8),(3,38,1,9),(9,38,1,11),(4,38,1,14),(4,38,1,15),(4,38,1,16),(4,38,1,17),(4,38,1,18),(4,38,1,19),(4,38,1,20),(9,38,1,21),(3,38,2,0),(3,38,2,2),(3,38,2,3),(3,38,2,4),(3,38,2,5),(3,38,2,6),(3,38,2,7),(11,38,2,14),(4,38,2,20),(3,38,3,0),(3,38,3,1),(3,38,3,2),(3,38,3,3),(3,38,3,5),(3,38,3,6),(4,38,3,20),(3,38,4,0),(3,38,4,3),(3,38,4,4),(3,38,4,5),(3,38,4,6),(0,38,4,7),(3,38,4,9),(3,38,4,10),(4,38,4,20),(3,38,5,2),(3,38,5,3),(3,38,5,4),(3,38,5,5),(3,38,5,6),(3,38,5,9),(3,38,5,10),(3,38,5,11),(3,38,5,12),(3,38,5,13),(4,38,5,20),(4,38,5,21),(4,38,5,22),(3,38,6,1),(3,38,6,2),(3,38,6,3),(3,38,6,4),(3,38,6,5),(3,38,6,6),(3,38,6,7),(3,38,6,8),(3,38,6,9),(3,38,6,10),(3,38,6,11),(3,38,6,12),(3,38,6,13),(3,38,6,14),(3,38,6,15),(4,38,6,20),(2,38,6,21),(8,38,7,2),(3,38,7,5),(3,38,7,6),(3,38,7,7),(3,38,7,8),(3,38,7,9),(3,38,7,10),(3,38,7,11),(14,38,8,5),(3,38,8,9),(3,38,8,10),(3,38,9,9),(3,38,9,10),(3,38,9,11),(3,38,10,10),(3,38,10,11),(0,38,11,2),(3,38,11,9),(3,38,11,10),(3,38,11,11),(3,38,11,12),(3,38,11,13),(3,38,12,9),(3,38,12,10),(3,38,12,12),(3,38,12,13),(1,38,12,15),(3,38,13,10),(3,38,13,12),(3,38,13,13),(4,38,15,14),(4,38,15,15),(4,38,15,17),(6,38,16,0),(6,38,16,1),(4,38,16,14),(4,38,16,15),(4,38,16,17),(6,38,17,0),(6,38,17,1),(4,38,17,14),(4,38,17,15),(4,38,17,16),(4,38,17,17),(6,38,18,0),(6,38,18,1),(6,38,18,2),(6,38,18,3),(6,38,18,4),(11,38,18,9),(4,38,18,15),(4,38,18,16),(4,38,18,17),(4,38,18,18),(4,38,18,19),(4,38,18,20),(4,38,18,22),(6,38,19,0),(6,38,19,1),(6,38,19,2),(4,38,19,15),(4,38,19,16),(4,38,19,17),(4,38,19,18),(4,38,19,19),(4,38,19,20),(4,38,19,21),(4,38,19,22),(6,38,20,0),(0,38,20,1),(4,38,20,16),(4,38,20,17),(12,38,20,18),(6,38,21,0),(6,38,22,0),(6,38,22,1),(6,38,22,2),(6,38,22,3),(6,38,23,0),(6,38,23,1),(6,38,23,2),(6,38,24,0),(6,38,24,1),(6,38,25,0),(6,38,25,1),(6,38,26,0),(6,38,26,1),(4,38,26,10),(5,38,26,18),(5,38,26,19),(5,38,26,20),(5,38,26,21),(5,38,26,22),(6,38,27,0),(6,38,27,1),(1,38,27,8),(4,38,27,10),(4,38,27,11),(4,38,27,18),(5,38,27,19),(5,38,27,20),(5,38,27,22),(6,38,28,1),(4,38,28,10),(4,38,28,11),(4,38,28,12),(4,38,28,17),(4,38,28,18),(2,38,28,19),(5,38,28,22),(5,38,28,23),(4,38,29,7),(4,38,29,9),(4,38,29,10),(4,38,29,11),(4,38,29,17),(4,38,29,18),(5,38,29,23),(4,38,30,7),(4,38,30,8),(4,38,30,9),(4,38,30,10),(4,38,30,17),(4,38,30,18),(4,38,30,19),(4,38,30,20),(5,38,30,23),(4,38,31,6),(4,38,31,7),(4,38,31,8),(4,38,31,9),(4,38,31,10),(4,38,31,11),(4,38,31,12),(4,38,31,14),(4,38,31,15),(4,38,31,16),(4,38,31,17),(4,38,31,18),(4,38,31,19),(4,38,31,20),(4,38,31,21),(5,38,31,23),(4,38,32,7),(4,38,32,8),(4,38,32,9),(4,38,32,10),(0,38,32,11),(0,38,32,16),(4,38,32,18),(4,38,32,19),(4,38,32,20),(4,38,32,21),(5,38,32,22),(5,38,32,23),(4,38,33,7),(4,38,33,10),(4,38,33,18),(4,38,33,20),(5,38,33,21),(5,38,33,22),(5,38,33,23),(5,38,34,0),(4,38,34,18),(4,38,34,19),(4,38,34,20),(5,38,34,21),(5,38,34,22),(5,38,34,23),(5,38,35,0),(5,38,35,3),(5,38,35,4),(4,38,35,18),(5,38,35,19),(5,38,35,21),(5,38,35,22),(5,38,35,23),(5,38,36,0),(5,38,36,1),(5,38,36,2),(5,38,36,3),(5,38,36,19),(5,38,36,20),(5,38,36,21),(5,38,37,1),(8,38,37,15),(5,38,37,18),(5,38,37,19),(10,38,37,20),(5,38,38,1),(13,38,40,0),(4,38,40,4),(4,38,41,3),(4,38,41,4),(6,38,41,21),(6,38,41,22),(4,38,42,4),(6,38,42,21),(6,38,42,22),(6,38,42,23),(4,38,43,4),(4,38,43,5),(6,38,43,20),(6,38,43,21),(6,38,43,22),(6,38,43,23),(4,38,44,4),(4,38,44,5),(6,38,44,19),(6,38,44,20),(6,38,44,21),(6,38,44,23),(4,38,45,2),(4,38,45,4),(4,38,45,5),(4,38,45,6),(4,38,45,7),(6,38,45,20),(6,38,46,0),(4,38,46,1),(4,38,46,2),(4,38,46,3),(4,38,46,4),(4,38,46,5),(4,38,46,6),(6,38,46,20),(6,38,47,0),(6,38,47,1),(4,38,47,2),(6,38,47,3),(6,38,47,4),(4,38,47,5),(4,38,47,6),(6,38,48,0),(6,38,48,1),(6,38,48,2),(6,38,48,3),(6,38,48,4),(6,38,48,5),(4,38,48,6),(3,38,48,9),(3,38,48,12),(3,38,48,13),(0,38,48,18),(6,38,49,0),(6,38,49,1),(6,38,49,2),(6,38,49,3),(4,38,49,6),(3,38,49,7),(3,38,49,8),(3,38,49,9),(3,38,49,10),(3,38,49,11),(3,38,49,12),(3,38,49,13),(4,38,50,5),(4,38,50,6),(3,38,50,7),(3,38,50,8),(3,38,50,9),(3,38,50,10),(3,38,50,11),(3,38,50,12),(3,38,50,13),(5,38,50,16),(6,38,51,2),(6,38,51,3),(6,38,51,4),(6,38,51,5),(4,38,51,6),(3,38,51,7),(3,38,51,8),(3,38,51,9),(3,38,51,10),(5,38,51,11),(5,38,51,12),(5,38,51,15),(5,38,51,16),(6,38,52,1),(6,38,52,2),(6,38,52,3),(6,38,52,4),(6,38,52,5),(6,38,52,6),(6,38,52,7),(3,38,52,8),(3,38,52,9),(3,38,52,10),(3,38,52,11),(5,38,52,12),(5,38,52,13),(5,38,52,14),(5,38,52,15),(6,38,53,1),(6,38,53,2),(6,38,53,3),(6,38,53,4),(3,38,53,5),(3,38,53,6),(3,38,53,8),(3,38,53,9),(3,38,53,10),(3,38,53,11),(3,38,53,12),(5,38,53,14),(3,38,53,15),(3,38,54,4),(3,38,54,5),(3,38,54,6),(3,38,54,7),(3,38,54,8),(3,38,54,9),(3,38,54,10),(3,38,54,11),(3,38,54,12),(3,38,54,13),(3,38,54,14),(3,38,54,15),(6,39,0,1),(6,39,0,2),(4,39,0,3),(4,39,0,4),(4,39,0,8),(4,39,0,9),(4,39,0,10),(3,39,0,13),(3,39,0,14),(8,39,0,18),(9,39,0,21),(6,39,0,24),(6,39,0,25),(5,39,0,26),(5,39,0,27),(5,39,0,28),(9,39,0,29),(10,39,0,33),(3,39,0,38),(6,39,0,40),(4,39,1,2),(4,39,1,3),(4,39,1,4),(0,39,1,6),(4,39,1,8),(4,39,1,9),(0,39,1,10),(3,39,1,12),(3,39,1,13),(4,39,1,24),(2,39,1,25),(5,39,1,27),(5,39,1,28),(3,39,1,37),(3,39,1,38),(3,39,1,39),(6,39,1,40),(0,39,2,1),(5,39,2,3),(4,39,2,4),(4,39,2,8),(4,39,2,9),(3,39,2,13),(3,39,2,14),(2,39,2,15),(6,39,2,17),(4,39,2,24),(5,39,2,27),(3,39,2,37),(0,39,2,38),(5,39,3,3),(4,39,3,4),(5,39,3,5),(5,39,3,6),(5,39,3,7),(3,39,3,11),(3,39,3,12),(3,39,3,13),(3,39,3,14),(6,39,3,17),(4,39,3,24),(4,39,3,25),(4,39,3,26),(5,39,3,27),(5,39,3,28),(3,39,3,37),(5,39,4,2),(5,39,4,3),(5,39,4,4),(5,39,4,5),(5,39,4,6),(4,39,4,23),(4,39,4,24),(4,39,4,25),(5,39,4,26),(5,39,4,27),(4,39,4,31),(4,39,4,32),(5,39,4,34),(5,39,4,35),(5,39,4,36),(3,39,4,37),(3,39,4,38),(3,39,4,39),(3,39,4,40),(3,39,5,3),(5,39,5,4),(5,39,5,5),(13,39,5,9),(12,39,5,13),(0,39,5,20),(4,39,5,22),(4,39,5,23),(1,39,5,24),(5,39,5,27),(4,39,5,29),(4,39,5,30),(4,39,5,31),(4,39,5,32),(5,39,5,35),(5,39,5,36),(12,39,5,37),(3,39,6,3),(5,39,6,4),(4,39,6,22),(4,39,6,23),(5,39,6,27),(0,39,6,29),(4,39,6,31),(5,39,6,34),(5,39,6,35),(5,39,6,36),(0,39,7,1),(3,39,7,3),(3,39,7,4),(0,39,7,5),(4,39,7,22),(4,39,7,23),(5,39,7,27),(1,39,7,34),(5,39,7,36),(3,39,8,3),(3,39,8,4),(14,39,8,24),(5,39,8,36),(3,39,9,3),(3,39,9,4),(3,39,9,5),(3,39,9,6),(5,39,9,35),(5,39,9,36),(5,39,10,36),(0,43,0,0),(5,43,0,3),(5,43,0,4),(5,43,0,5),(5,43,0,6),(5,43,0,7),(5,43,0,8),(5,43,0,9),(5,43,0,10),(5,43,0,11),(5,43,0,12),(5,43,0,13),(5,43,0,14),(5,43,0,26),(5,43,0,27),(5,43,0,28),(5,43,0,29),(5,43,1,3),(11,43,1,4),(5,43,1,11),(5,43,1,12),(5,43,1,13),(13,43,1,16),(4,43,1,19),(4,43,1,20),(4,43,1,21),(4,43,1,22),(5,43,1,26),(5,43,1,27),(5,43,1,28),(5,43,1,29),(5,43,2,2),(5,43,2,3),(5,43,2,10),(5,43,2,12),(5,43,2,13),(5,43,2,14),(5,43,2,15),(4,43,2,20),(4,43,2,21),(4,43,2,22),(4,43,2,23),(5,43,2,27),(5,43,2,28),(5,43,2,29),(0,43,3,1),(5,43,3,10),(5,43,3,11),(5,43,3,12),(5,43,3,13),(5,43,3,14),(4,43,3,20),(4,43,3,21),(4,43,3,22),(4,43,3,23),(4,43,3,24),(5,43,3,28),(5,43,3,29),(5,43,4,12),(5,43,4,13),(6,43,4,18),(4,43,4,21),(4,43,4,22),(4,43,4,23),(5,43,4,26),(5,43,4,27),(5,43,4,28),(6,43,5,8),(6,43,5,9),(6,43,5,18),(6,43,5,19),(4,43,5,22),(4,43,5,23),(4,43,5,24),(5,43,5,26),(5,43,5,27),(6,43,6,7),(6,43,6,8),(6,43,6,9),(6,43,6,11),(6,43,6,18),(6,43,6,19),(6,43,7,9),(6,43,7,10),(6,43,7,18),(12,43,7,23),(6,43,8,9),(6,43,8,10),(6,43,8,16),(6,43,8,17),(6,43,8,18),(3,43,9,3),(3,43,9,4),(6,43,9,9),(6,43,9,15),(6,43,9,16),(6,43,9,17),(3,43,10,0),(3,43,10,2),(3,43,10,3),(3,43,10,4),(8,43,10,5),(6,43,10,16),(6,43,10,17),(0,43,10,20),(3,43,11,0),(3,43,11,1),(3,43,11,2),(3,43,11,3),(3,43,12,0),(3,43,12,1),(3,43,12,2),(3,43,13,0),(3,43,13,1),(3,43,13,2),(3,43,13,4),(3,43,14,0),(3,43,14,1),(3,43,14,2),(3,43,14,3),(3,43,14,4),(3,43,15,0),(3,43,15,1),(3,43,15,2),(3,43,15,3),(3,43,15,4),(3,43,16,0),(3,43,16,1),(3,43,16,2),(3,43,16,3),(5,43,16,29),(3,43,17,0),(3,43,17,1),(3,43,17,2),(3,43,17,3),(3,43,17,4),(5,43,17,28),(5,43,17,29),(3,43,18,0),(3,43,18,1),(3,43,18,2),(3,43,18,3),(3,43,18,4),(3,43,18,5),(0,43,18,23),(5,43,18,28),(5,43,18,29),(3,43,19,0),(3,43,19,1),(3,43,19,2),(3,43,19,3),(3,43,19,4),(3,43,19,5),(5,43,19,29),(3,43,20,0),(3,43,20,1),(3,43,20,2),(3,43,20,3),(3,43,20,4),(3,43,20,5),(5,43,20,28),(5,43,20,29),(3,43,21,0),(3,43,21,1),(3,43,21,2),(3,43,21,3),(3,43,21,4),(5,43,21,29),(3,43,22,0),(3,43,22,1),(3,43,22,2),(14,43,22,25),(5,43,22,29),(3,43,23,0),(3,43,23,1),(3,43,23,2),(3,43,23,3),(4,43,23,9),(5,43,23,29),(3,43,24,1),(3,43,24,2),(0,43,24,4),(4,43,24,7),(4,43,24,8),(4,43,24,9),(4,43,24,10),(4,43,24,11),(5,43,24,29),(4,43,25,7),(4,43,25,8),(4,43,25,9),(4,43,25,10),(5,43,25,27),(5,43,25,29),(4,43,26,6),(4,43,26,7),(4,43,26,8),(4,43,26,9),(4,43,26,10),(2,43,26,12),(6,43,26,22),(6,43,26,23),(5,43,26,27),(5,43,26,28),(5,43,26,29),(4,43,27,5),(4,43,27,6),(4,43,27,7),(4,43,27,8),(4,43,27,9),(4,43,27,10),(5,43,27,17),(5,43,27,18),(5,43,27,21),(5,43,27,22),(6,43,27,23),(6,43,27,24),(0,43,28,4),(4,43,28,6),(4,43,28,7),(4,43,28,8),(4,43,28,9),(4,43,28,10),(5,43,28,15),(5,43,28,16),(5,43,28,17),(5,43,28,18),(5,43,28,19),(5,43,28,21),(5,43,28,22),(6,43,28,23),(6,43,28,24),(5,43,28,25),(5,43,28,26),(5,43,28,27),(5,43,28,28),(4,43,29,7),(4,43,29,8),(4,43,29,9),(4,43,29,10),(4,43,29,11),(5,43,29,16),(5,43,29,17),(5,43,29,18),(5,43,29,19),(5,43,29,20),(5,43,29,21),(5,43,29,22),(6,43,29,23),(6,43,29,24),(6,43,29,25),(6,43,29,26),(5,43,29,27),(4,47,0,11),(0,47,1,1),(4,47,1,7),(4,47,1,8),(4,47,1,9),(4,47,1,10),(4,47,1,11),(4,47,1,12),(4,47,1,13),(5,47,1,14),(5,47,1,15),(10,47,1,23),(13,47,1,28),(4,47,2,10),(5,47,2,11),(4,47,2,12),(5,47,2,13),(5,47,2,14),(5,47,2,15),(5,47,2,16),(0,47,3,5),(4,47,3,10),(5,47,3,11),(5,47,3,12),(5,47,3,13),(5,47,3,14),(1,47,3,15),(4,47,4,9),(4,47,4,10),(5,47,4,11),(5,47,4,12),(5,47,4,13),(5,47,4,14),(5,47,5,11),(5,47,5,12),(5,47,5,13),(4,47,5,23),(4,47,5,24),(4,47,5,25),(4,47,6,10),(4,47,6,11),(5,47,6,12),(4,47,6,23),(4,47,6,24),(4,47,6,25),(4,47,6,26),(4,47,6,27),(0,47,7,4),(4,47,7,11),(2,47,7,12),(4,47,7,19),(4,47,7,20),(3,47,7,21),(3,47,7,22),(3,47,7,23),(4,47,7,24),(4,47,7,26),(4,47,7,27),(5,47,7,28),(5,47,7,29),(4,47,8,10),(4,47,8,11),(4,47,8,18),(4,47,8,19),(4,47,8,21),(3,47,8,22),(0,47,8,23),(4,47,8,26),(4,47,8,27),(5,47,8,28),(5,47,8,29),(4,47,9,10),(4,47,9,11),(4,47,9,12),(4,47,9,18),(4,47,9,19),(4,47,9,20),(4,47,9,21),(3,47,9,22),(3,47,9,25),(6,47,9,26),(6,47,9,27),(5,47,9,28),(5,47,9,29),(3,47,10,0),(3,47,10,1),(4,47,10,10),(4,47,10,11),(4,47,10,12),(4,47,10,19),(4,47,10,20),(4,47,10,21),(3,47,10,22),(3,47,10,23),(3,47,10,24),(3,47,10,25),(3,47,10,26),(6,47,10,27),(6,47,10,28),(5,47,10,29),(3,47,11,0),(3,47,11,1),(3,47,11,2),(3,47,11,4),(4,47,11,10),(4,47,11,11),(4,47,11,19),(3,47,11,22),(8,47,11,23),(6,47,11,26),(6,47,11,27),(5,47,11,28),(5,47,11,29),(3,47,12,0),(3,47,12,1),(3,47,12,2),(3,47,12,3),(3,47,12,4),(6,47,12,5),(6,47,12,6),(6,47,12,7),(2,47,12,8),(0,47,12,17),(3,47,12,22),(5,47,12,26),(5,47,12,27),(5,47,12,28),(5,47,12,29),(3,47,13,0),(3,47,13,1),(3,47,13,2),(6,47,13,6),(6,47,13,7),(3,47,13,20),(3,47,13,21),(3,47,13,22),(5,47,13,28),(5,47,13,29),(3,47,14,0),(3,47,14,1),(3,47,14,2),(3,47,14,3),(4,47,14,4),(6,47,14,6),(3,47,14,19),(3,47,14,20),(3,47,14,21),(3,47,14,22),(3,47,14,23),(5,47,14,26),(5,47,14,27),(5,47,14,28),(5,47,14,29),(3,47,15,0),(3,47,15,1),(3,47,15,2),(4,47,15,4),(4,47,15,5),(3,47,15,11),(3,47,15,13),(11,47,15,15),(3,47,15,22),(3,47,15,23),(3,47,15,24),(3,47,15,25),(8,47,15,26),(3,47,16,0),(3,47,16,1),(3,47,16,2),(4,47,16,3),(4,47,16,4),(4,47,16,5),(3,47,16,9),(3,47,16,10),(3,47,16,11),(3,47,16,13),(3,47,16,24),(3,47,17,0),(3,47,17,2),(4,47,17,3),(4,47,17,4),(4,47,17,5),(4,47,17,6),(3,47,17,7),(3,47,17,8),(3,47,17,9),(3,47,17,10),(3,47,17,11),(3,47,17,12),(3,47,17,13),(3,47,17,14),(4,47,18,3),(4,47,18,4),(4,47,18,5),(3,47,18,9),(3,47,18,10),(3,47,18,11),(3,47,18,12),(3,47,18,13),(3,47,18,14),(11,47,18,22),(3,47,19,9),(6,47,19,10),(3,47,19,11),(3,47,19,12),(5,47,19,15),(5,47,19,16),(5,47,19,17),(6,47,20,9),(6,47,20,10),(6,47,20,11),(3,47,20,12),(5,47,20,16),(5,47,20,17),(5,47,20,18),(5,47,20,19),(6,47,21,10),(6,47,21,11),(3,47,21,12),(3,47,21,13),(5,47,21,14),(5,47,21,15),(5,47,21,16),(5,47,21,18),(5,47,21,19),(5,47,22,12),(5,47,22,13),(5,47,22,14),(5,47,22,16),(5,47,22,17),(5,47,22,18),(5,47,22,19),(6,47,22,21),(6,47,22,22),(6,47,22,23),(6,47,22,24),(6,47,22,25),(6,47,22,26);
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
) ENGINE=InnoDB AUTO_INCREMENT=370 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `units`
--

LOCK TABLES `units` WRITE;
/*!40000 ALTER TABLE `units` DISABLE KEYS */;
INSERT INTO `units` VALUES (1,1590,1,1,1,NULL,NULL,NULL,NULL,0,0,'Thor',1,1,45,NULL,1,0,0,0),(2,1200,1,1,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,1,45,NULL,1,0,0,0),(3,1200,1,1,1,NULL,NULL,NULL,NULL,0,0,'Dirac',0,1,45,NULL,1,0,0,0),(4,120,1,1,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(5,140,1,2,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(6,120,1,2,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(7,120,1,2,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(8,140,1,3,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(9,120,1,3,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(10,140,1,3,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(11,120,1,3,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(12,120,1,3,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(13,140,1,4,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(14,120,1,4,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(15,140,1,4,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(16,120,1,4,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(17,120,1,4,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(18,120,1,5,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(19,120,1,5,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(20,120,1,6,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(21,120,1,6,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(22,2500,1,1,1,NULL,NULL,NULL,NULL,0,0,'Demosis',0,3,246,NULL,1,0,0,0),(23,1590,1,1,1,NULL,NULL,NULL,NULL,0,0,'Thor',0,3,246,NULL,1,0,0,0),(24,1200,1,1,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,3,246,NULL,1,0,0,0),(25,1200,1,1,1,NULL,NULL,NULL,NULL,0,0,'Dirac',0,3,246,NULL,1,0,0,0),(26,140,1,7,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(27,120,1,7,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(28,120,1,7,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(29,140,1,8,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(30,120,1,8,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(31,120,1,8,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(32,140,1,9,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(33,120,1,9,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(34,120,1,9,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(35,140,1,10,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(36,120,1,10,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(37,120,1,10,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(38,140,1,11,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(39,140,1,11,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(40,120,1,11,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(41,140,1,11,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(42,120,1,11,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(43,120,1,11,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(44,120,1,12,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(45,120,1,12,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(46,120,1,13,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(47,120,1,14,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(48,120,1,14,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(49,120,1,15,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(50,1200,1,1,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,2,300,NULL,1,0,0,0),(51,1200,1,1,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,2,300,NULL,1,0,0,0),(52,1200,1,1,1,NULL,NULL,NULL,NULL,0,0,'Dirac',0,2,300,NULL,1,0,0,0),(53,2500,1,2,1,NULL,NULL,NULL,NULL,0,0,'Demosis',0,3,66,NULL,1,0,0,0),(54,1590,1,2,1,NULL,NULL,NULL,NULL,0,0,'Thor',1,3,66,NULL,1,0,0,0),(55,1200,1,2,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,3,66,NULL,1,0,0,0),(56,1200,1,2,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,3,66,NULL,1,0,0,0),(57,1200,1,2,1,NULL,NULL,NULL,NULL,0,0,'Dirac',0,3,66,NULL,1,0,0,0),(58,2500,1,2,1,NULL,NULL,NULL,NULL,0,0,'Demosis',0,1,0,NULL,1,0,0,0),(59,1200,1,2,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,1,0,NULL,1,0,0,0),(60,1200,1,2,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,1,0,NULL,1,0,0,0),(61,1200,1,2,1,NULL,NULL,NULL,NULL,0,0,'Dirac',0,1,0,NULL,1,0,0,0),(62,1590,1,2,1,NULL,NULL,NULL,NULL,0,0,'Thor',1,1,270,NULL,1,0,0,0),(63,1200,1,2,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,1,270,NULL,1,0,0,0),(64,1200,1,2,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,1,270,NULL,1,0,0,0),(65,1200,1,2,1,NULL,NULL,NULL,NULL,0,0,'Dirac',0,1,270,NULL,1,0,0,0),(66,2500,1,2,1,NULL,NULL,NULL,NULL,0,0,'Demosis',0,0,180,NULL,1,0,0,0),(67,2500,1,2,1,NULL,NULL,NULL,NULL,0,0,'Demosis',0,0,180,NULL,1,0,0,0),(68,1590,1,2,1,NULL,NULL,NULL,NULL,0,0,'Thor',0,0,180,NULL,1,0,0,0),(69,1590,1,2,1,NULL,NULL,NULL,NULL,0,0,'Thor',1,0,180,NULL,1,0,0,0),(70,1200,1,2,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,0,180,NULL,1,0,0,0),(71,1200,1,2,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,0,180,NULL,1,0,0,0),(72,1200,1,2,1,NULL,NULL,NULL,NULL,0,0,'Dirac',0,0,180,NULL,1,0,0,0),(73,2500,1,3,1,NULL,NULL,NULL,NULL,0,0,'Demosis',0,1,45,NULL,1,0,0,0),(74,2500,1,3,1,NULL,NULL,NULL,NULL,0,0,'Demosis',0,1,45,NULL,1,0,0,0),(75,2500,1,3,1,NULL,NULL,NULL,NULL,0,0,'Demosis',0,1,45,NULL,1,0,0,0),(76,1200,1,3,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,1,45,NULL,1,0,0,0),(77,1200,1,3,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,1,45,NULL,1,0,0,0),(78,1200,1,3,1,NULL,NULL,NULL,NULL,0,0,'Dirac',0,1,45,NULL,1,0,0,0),(79,1590,1,3,1,NULL,NULL,NULL,NULL,0,0,'Thor',0,2,210,NULL,1,0,0,0),(80,1200,1,3,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,2,210,NULL,1,0,0,0),(81,1200,1,3,1,NULL,NULL,NULL,NULL,0,0,'Dirac',0,2,210,NULL,1,0,0,0),(82,1590,1,3,1,NULL,NULL,NULL,NULL,0,0,'Thor',1,1,315,NULL,1,0,0,0),(83,1200,1,3,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,1,315,NULL,1,0,0,0),(84,1200,1,3,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,1,315,NULL,1,0,0,0),(85,1200,1,3,1,NULL,NULL,NULL,NULL,0,0,'Dirac',0,1,315,NULL,1,0,0,0),(86,140,1,16,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(87,120,1,16,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(88,120,1,16,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(89,140,1,17,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(90,120,1,17,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(91,120,1,17,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(92,120,1,18,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(93,140,1,19,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(94,120,1,19,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(95,120,1,19,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(96,120,1,20,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(97,140,1,21,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(98,120,1,21,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(99,120,1,21,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(100,140,1,22,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(101,120,1,22,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(102,140,1,22,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(103,120,1,22,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(104,120,1,22,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(105,120,1,23,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(106,140,1,23,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(107,140,1,23,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(108,120,1,23,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(109,120,1,23,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(110,120,1,24,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(111,140,1,24,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(112,140,1,24,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(113,120,1,24,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(114,120,1,24,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(115,120,1,25,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(116,140,1,25,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(117,140,1,25,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(118,120,1,25,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(119,120,1,25,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(120,140,1,26,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(121,120,1,26,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(122,120,1,26,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(123,120,1,27,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(124,120,1,27,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(125,120,1,28,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(126,120,1,28,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(127,120,1,29,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(128,120,1,29,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(129,120,1,30,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(130,120,1,30,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(131,2500,1,3,1,NULL,NULL,NULL,NULL,0,0,'Demosis',0,2,30,NULL,1,0,0,0),(132,1590,1,3,1,NULL,NULL,NULL,NULL,0,0,'Thor',0,2,30,NULL,1,0,0,0),(133,1200,1,3,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,2,30,NULL,1,0,0,0),(134,1200,1,3,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,2,30,NULL,1,0,0,0),(135,1200,1,3,1,NULL,NULL,NULL,NULL,0,0,'Dirac',0,2,30,NULL,1,0,0,0),(136,2500,1,3,1,NULL,NULL,NULL,NULL,0,0,'Demosis',0,0,270,NULL,1,0,0,0),(137,2500,1,3,1,NULL,NULL,NULL,NULL,0,0,'Demosis',0,0,270,NULL,1,0,0,0),(138,1200,1,3,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,0,270,NULL,1,0,0,0),(139,1200,1,3,1,NULL,NULL,NULL,NULL,0,0,'Dirac',0,0,270,NULL,1,0,0,0),(140,140,1,31,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(141,120,1,31,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(142,140,1,32,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(143,120,1,32,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(144,120,1,32,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(145,120,1,33,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(146,140,1,34,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(147,120,1,34,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(148,120,1,34,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(149,120,1,35,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(150,140,1,35,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(151,120,1,35,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(152,120,1,35,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(153,140,1,36,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(154,140,1,36,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(155,120,1,36,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(156,120,1,36,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(157,140,1,37,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(158,140,1,37,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(159,120,1,37,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(160,140,1,37,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(161,120,1,37,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(162,140,1,38,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(163,120,1,38,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(164,140,1,38,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(165,120,1,38,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(166,140,1,38,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(167,120,1,38,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(168,120,1,38,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(169,120,1,39,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(170,140,1,39,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(171,120,1,39,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(172,140,1,39,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(173,120,1,39,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(174,120,1,39,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(175,120,1,40,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(176,140,1,40,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(177,120,1,40,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(178,140,1,40,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(179,120,1,40,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(180,120,1,40,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(181,120,1,40,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(182,120,1,41,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(183,120,1,41,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(184,120,1,42,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(185,120,1,43,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(186,120,1,43,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(187,120,1,44,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(188,120,1,44,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(189,120,1,45,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(190,120,1,45,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(191,140,1,46,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(192,120,1,46,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(193,140,1,47,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(194,120,1,47,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(195,120,1,47,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(196,140,1,48,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(197,120,1,48,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(198,140,1,49,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(199,120,1,49,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(200,120,1,49,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(201,140,1,50,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(202,120,1,50,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(203,120,1,50,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(204,140,1,51,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(205,120,1,51,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(206,140,1,51,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(207,120,1,51,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(208,120,1,51,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(209,140,1,52,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(210,120,1,52,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(211,140,1,52,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(212,120,1,52,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(213,120,1,52,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(214,120,1,53,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(215,120,1,53,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(216,120,1,53,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(217,120,1,53,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(218,140,1,54,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(219,120,1,54,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(220,140,1,54,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(221,140,1,54,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(222,120,1,54,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(223,120,1,54,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(224,120,1,55,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(225,120,1,55,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(226,120,1,56,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(227,120,1,57,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(228,120,1,57,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(229,1590,1,3,1,NULL,NULL,NULL,NULL,0,0,'Thor',0,0,0,NULL,1,0,0,0),(230,1200,1,3,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,0,0,NULL,1,0,0,0),(231,1200,1,3,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,0,0,NULL,1,0,0,0),(232,1200,1,3,1,NULL,NULL,NULL,NULL,0,0,'Dirac',0,0,0,NULL,1,0,0,0),(233,1590,1,4,1,NULL,NULL,NULL,NULL,0,0,'Thor',0,3,180,NULL,1,0,0,0),(234,1590,1,4,1,NULL,NULL,NULL,NULL,0,0,'Thor',1,3,180,NULL,1,0,0,0),(235,1200,1,4,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,3,180,NULL,1,0,0,0),(236,1200,1,4,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,3,180,NULL,1,0,0,0),(237,1200,1,4,1,NULL,NULL,NULL,NULL,0,0,'Dirac',0,3,180,NULL,1,0,0,0),(238,120,1,58,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(239,120,1,58,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(240,140,1,58,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(241,120,1,58,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(242,120,1,58,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(243,120,1,58,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(244,120,1,58,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(245,120,1,59,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(246,120,1,59,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(247,140,1,59,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(248,120,1,59,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(249,120,1,59,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(250,120,1,59,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(251,120,1,59,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(252,120,1,60,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(253,120,1,60,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(254,120,1,60,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(255,120,1,60,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(256,120,1,60,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(257,140,1,61,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(258,120,1,61,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(259,120,1,61,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(260,140,1,61,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(261,120,1,61,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(262,120,1,61,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(263,120,1,61,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(264,120,1,61,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(265,120,1,62,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(266,120,1,62,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(267,120,1,62,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(268,120,1,62,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(269,120,1,62,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(270,120,1,62,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(271,120,1,63,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(272,120,1,63,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(273,120,1,63,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(274,120,1,63,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(275,120,1,63,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(276,120,1,63,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(277,140,1,64,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(278,120,1,64,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(279,120,1,64,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(280,140,1,64,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(281,120,1,64,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(282,120,1,64,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(283,120,1,64,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(284,120,1,64,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(285,120,1,65,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(286,120,1,65,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(287,120,1,65,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(288,120,1,65,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(289,120,1,65,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(290,120,1,65,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(291,120,1,66,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(292,120,1,66,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(293,120,1,66,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(294,120,1,66,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(295,120,1,66,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(296,120,1,66,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(297,140,1,67,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(298,120,1,67,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(299,120,1,67,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(300,140,1,67,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(301,120,1,67,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(302,120,1,67,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(303,120,1,67,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(304,120,1,67,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(305,140,1,68,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(306,120,1,68,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(307,120,1,68,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(308,140,1,68,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(309,120,1,68,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(310,120,1,68,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(311,120,1,68,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(312,120,1,68,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(313,120,1,72,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(314,140,1,72,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(315,120,1,72,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(316,120,1,72,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(317,120,1,72,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(318,140,1,72,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(319,120,1,72,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(320,120,1,72,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(321,120,1,72,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(322,120,1,72,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(323,140,1,76,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(324,120,1,76,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(325,120,1,76,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(326,140,1,76,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(327,120,1,76,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(328,120,1,76,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(329,140,1,76,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(330,120,1,76,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(331,140,1,76,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(332,120,1,76,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(333,140,1,76,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(334,120,1,76,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(335,120,1,76,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(336,120,1,76,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(337,120,1,76,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(338,1590,1,4,1,NULL,NULL,NULL,NULL,0,0,'Thor',0,1,0,NULL,1,0,0,0),(339,1590,1,4,1,NULL,NULL,NULL,NULL,0,0,'Thor',1,1,0,NULL,1,0,0,0),(340,1200,1,4,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,1,0,NULL,1,0,0,0),(341,1200,1,4,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,1,0,NULL,1,0,0,0),(342,1200,1,4,1,NULL,NULL,NULL,NULL,0,0,'Dirac',0,1,0,NULL,1,0,0,0),(343,140,1,80,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(344,120,1,80,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(345,120,1,80,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(346,140,1,81,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(347,120,1,81,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(348,120,1,81,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(349,120,1,82,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(350,140,1,83,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(351,140,1,83,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(352,120,1,83,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(353,120,1,84,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(354,120,1,84,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(355,140,1,84,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(356,120,1,84,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(357,120,1,84,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(358,140,1,85,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(359,120,1,85,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(360,120,1,85,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(361,140,1,85,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(362,120,1,85,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(363,120,1,86,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(364,120,1,86,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(365,120,1,87,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(366,120,1,87,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(367,120,1,88,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(368,120,1,88,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(369,120,1,89,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0);
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

-- Dump completed on 2010-12-08 15:44:43
