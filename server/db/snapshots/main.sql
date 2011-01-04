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
) ENGINE=InnoDB AUTO_INCREMENT=82 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `buildings`
--

LOCK TABLES `buildings` WRITE;
/*!40000 ALTER TABLE `buildings` DISABLE KEYS */;
INSERT INTO `buildings` VALUES (1,6,0,0,0,0,0,1,'NpcMetalExtractor',NULL,1,1,NULL,1,400,NULL,0,NULL,NULL,0),(2,6,7,0,0,0,0,1,'NpcCommunicationsHub',NULL,9,1,NULL,1,1200,NULL,0,NULL,NULL,0),(3,6,18,0,0,0,0,1,'NpcSolarPlant',NULL,19,1,NULL,1,1000,NULL,0,NULL,NULL,0),(4,6,3,1,0,0,0,1,'NpcMetalExtractor',NULL,4,2,NULL,1,400,NULL,0,NULL,NULL,0),(5,6,12,1,0,0,0,1,'NpcSolarPlant',NULL,13,2,NULL,1,1000,NULL,0,NULL,NULL,0),(6,6,22,1,0,0,0,1,'NpcSolarPlant',NULL,23,2,NULL,1,1000,NULL,0,NULL,NULL,0),(7,6,26,1,0,0,0,1,'NpcCommunicationsHub',NULL,28,2,NULL,1,1200,NULL,0,NULL,NULL,0),(8,6,15,3,0,0,0,1,'NpcSolarPlant',NULL,16,4,NULL,1,1000,NULL,0,NULL,NULL,0),(9,6,18,3,0,0,0,1,'NpcSolarPlant',NULL,19,4,NULL,1,1000,NULL,0,NULL,NULL,0),(10,6,24,4,0,0,0,1,'NpcMetalExtractor',NULL,25,5,NULL,1,400,NULL,0,NULL,NULL,0),(11,6,28,4,0,0,0,1,'NpcMetalExtractor',NULL,29,5,NULL,1,400,NULL,0,NULL,NULL,0),(12,6,7,6,0,0,0,1,'Screamer',NULL,8,7,NULL,1,1300,NULL,0,NULL,NULL,0),(13,6,21,6,0,0,0,1,'Vulcan',NULL,22,7,NULL,1,1000,NULL,0,NULL,NULL,0),(14,6,14,7,0,0,0,1,'Thunder',NULL,15,8,NULL,1,2000,NULL,0,NULL,NULL,0),(15,6,25,7,0,0,0,1,'NpcTemple',NULL,27,9,NULL,1,1500,NULL,0,NULL,NULL,0),(16,6,11,10,0,0,0,1,'Mothership',NULL,18,15,NULL,1,10500,NULL,0,NULL,NULL,0),(17,6,7,12,0,0,0,1,'Thunder',NULL,8,13,NULL,1,2000,NULL,0,NULL,NULL,0),(18,6,21,12,0,0,0,1,'Thunder',NULL,22,13,NULL,1,2000,NULL,0,NULL,NULL,0),(19,6,26,12,0,0,0,1,'NpcZetiumExtractor',NULL,27,13,NULL,1,800,NULL,0,NULL,NULL,0),(20,6,7,19,0,0,0,1,'Vulcan',NULL,8,20,NULL,1,1000,NULL,0,NULL,NULL,0),(21,6,14,19,0,0,0,1,'Thunder',NULL,15,20,NULL,1,2000,NULL,0,NULL,NULL,0),(22,6,21,19,0,0,0,1,'Screamer',NULL,22,20,NULL,1,1300,NULL,0,NULL,NULL,0),(23,7,13,6,0,0,0,1,'NpcGeothermalPlant',NULL,14,7,NULL,1,600,NULL,0,NULL,NULL,0),(24,7,17,48,0,0,0,1,'NpcZetiumExtractor',NULL,18,49,NULL,1,800,NULL,0,NULL,NULL,0),(25,7,10,22,0,0,0,1,'NpcResearchCenter',NULL,13,25,NULL,1,4000,NULL,0,NULL,NULL,0),(26,7,15,3,0,0,0,1,'NpcCommunicationsHub',NULL,17,4,NULL,1,1200,NULL,0,NULL,NULL,0),(27,7,10,41,0,0,0,1,'NpcCommunicationsHub',NULL,12,42,NULL,1,1200,NULL,0,NULL,NULL,0),(28,7,10,16,0,0,0,1,'NpcSolarPlant',NULL,11,17,NULL,1,1000,NULL,0,NULL,NULL,0),(29,7,24,43,0,0,0,1,'NpcSolarPlant',NULL,25,44,NULL,1,1000,NULL,0,NULL,NULL,0),(30,7,16,13,0,0,0,1,'NpcSolarPlant',NULL,17,14,NULL,1,1000,NULL,0,NULL,NULL,0),(31,16,6,39,0,0,0,1,'NpcMetalExtractor',NULL,7,40,NULL,1,400,NULL,0,NULL,NULL,0),(32,16,15,16,0,0,0,1,'NpcMetalExtractor',NULL,16,17,NULL,1,400,NULL,0,NULL,NULL,0),(33,16,12,48,0,0,0,1,'NpcMetalExtractor',NULL,13,49,NULL,1,400,NULL,0,NULL,NULL,0),(34,16,1,3,0,0,0,1,'NpcGeothermalPlant',NULL,2,4,NULL,1,600,NULL,0,NULL,NULL,0),(35,16,7,12,0,0,0,1,'NpcZetiumExtractor',NULL,8,13,NULL,1,800,NULL,0,NULL,NULL,0),(36,16,4,24,0,0,0,1,'NpcTemple',NULL,6,26,NULL,1,1500,NULL,0,NULL,NULL,0),(37,16,8,45,0,0,0,1,'NpcCommunicationsHub',NULL,10,46,NULL,1,1200,NULL,0,NULL,NULL,0),(38,16,0,30,0,0,0,1,'NpcSolarPlant',NULL,1,31,NULL,1,1000,NULL,0,NULL,NULL,0),(39,16,3,44,0,0,0,1,'NpcSolarPlant',NULL,4,45,NULL,1,1000,NULL,0,NULL,NULL,0),(40,16,2,33,0,0,0,1,'NpcSolarPlant',NULL,3,34,NULL,1,1000,NULL,0,NULL,NULL,0),(41,16,2,20,0,0,0,1,'NpcSolarPlant',NULL,3,21,NULL,1,1000,NULL,0,NULL,NULL,0),(42,23,4,31,0,0,0,1,'NpcMetalExtractor',NULL,5,32,NULL,1,400,NULL,0,NULL,NULL,0),(43,23,8,8,0,0,0,1,'NpcMetalExtractor',NULL,9,9,NULL,1,400,NULL,0,NULL,NULL,0),(44,23,8,28,0,0,0,1,'NpcMetalExtractor',NULL,9,29,NULL,1,400,NULL,0,NULL,NULL,0),(45,23,6,17,0,0,0,1,'NpcGeothermalPlant',NULL,7,18,NULL,1,600,NULL,0,NULL,NULL,0),(46,23,9,4,0,0,0,1,'NpcZetiumExtractor',NULL,10,5,NULL,1,800,NULL,0,NULL,NULL,0),(47,23,5,12,0,0,0,1,'NpcSolarPlant',NULL,6,13,NULL,1,1000,NULL,0,NULL,NULL,0),(48,24,4,5,0,0,0,1,'NpcMetalExtractor',NULL,5,6,NULL,1,400,NULL,0,NULL,NULL,0),(49,24,14,6,0,0,0,1,'NpcMetalExtractor',NULL,15,7,NULL,1,400,NULL,0,NULL,NULL,0),(50,24,6,10,0,0,0,1,'NpcMetalExtractor',NULL,7,11,NULL,1,400,NULL,0,NULL,NULL,0),(51,24,12,31,0,0,0,1,'NpcGeothermalPlant',NULL,13,32,NULL,1,600,NULL,0,NULL,NULL,0),(52,24,11,22,0,0,0,1,'NpcGeothermalPlant',NULL,12,23,NULL,1,600,NULL,0,NULL,NULL,0),(53,24,8,37,0,0,0,1,'NpcZetiumExtractor',NULL,9,38,NULL,1,800,NULL,0,NULL,NULL,0),(54,24,0,34,0,0,0,1,'NpcCommunicationsHub',NULL,2,35,NULL,1,1200,NULL,0,NULL,NULL,0),(55,24,6,19,0,0,0,1,'NpcSolarPlant',NULL,7,20,NULL,1,1000,NULL,0,NULL,NULL,0),(56,24,4,32,0,0,0,1,'NpcSolarPlant',NULL,5,33,NULL,1,1000,NULL,0,NULL,NULL,0),(57,24,9,15,0,0,0,1,'NpcSolarPlant',NULL,10,16,NULL,1,1000,NULL,0,NULL,NULL,0),(58,24,8,1,0,0,0,1,'NpcSolarPlant',NULL,9,2,NULL,1,1000,NULL,0,NULL,NULL,0),(59,42,8,36,0,0,0,1,'NpcMetalExtractor',NULL,9,37,NULL,1,400,NULL,0,NULL,NULL,0),(60,42,28,26,0,0,0,1,'NpcMetalExtractor',NULL,29,27,NULL,1,400,NULL,0,NULL,NULL,0),(61,42,26,21,0,0,0,1,'NpcMetalExtractor',NULL,27,22,NULL,1,400,NULL,0,NULL,NULL,0),(62,42,16,31,0,0,0,1,'NpcMetalExtractor',NULL,17,32,NULL,1,400,NULL,0,NULL,NULL,0),(63,42,15,36,0,0,0,1,'NpcGeothermalPlant',NULL,16,37,NULL,1,600,NULL,0,NULL,NULL,0),(64,42,26,31,0,0,0,1,'NpcGeothermalPlant',NULL,27,32,NULL,1,600,NULL,0,NULL,NULL,0),(65,42,20,27,0,0,0,1,'NpcZetiumExtractor',NULL,21,28,NULL,1,800,NULL,0,NULL,NULL,0),(66,42,5,30,0,0,0,1,'NpcJumpgate',NULL,9,34,NULL,1,8000,NULL,0,NULL,NULL,0),(67,42,23,11,0,0,0,1,'NpcResearchCenter',NULL,26,14,NULL,1,4000,NULL,0,NULL,NULL,0),(68,42,21,20,0,0,0,1,'NpcCommunicationsHub',NULL,23,21,NULL,1,1200,NULL,0,NULL,NULL,0),(69,42,23,9,0,0,0,1,'NpcSolarPlant',NULL,24,10,NULL,1,1000,NULL,0,NULL,NULL,0),(70,42,23,30,0,0,0,1,'NpcSolarPlant',NULL,24,31,NULL,1,1000,NULL,0,NULL,NULL,0),(71,42,14,23,0,0,0,1,'NpcSolarPlant',NULL,15,24,NULL,1,1000,NULL,0,NULL,NULL,0),(72,48,14,24,0,0,0,1,'NpcMetalExtractor',NULL,15,25,NULL,1,400,NULL,0,NULL,NULL,0),(73,48,10,4,0,0,0,1,'NpcMetalExtractor',NULL,11,5,NULL,1,400,NULL,0,NULL,NULL,0),(74,48,2,24,0,0,0,1,'NpcMetalExtractor',NULL,3,25,NULL,1,400,NULL,0,NULL,NULL,0),(75,48,9,16,0,0,0,1,'NpcMetalExtractor',NULL,10,17,NULL,1,400,NULL,0,NULL,NULL,0),(76,48,6,25,0,0,0,1,'NpcGeothermalPlant',NULL,7,26,NULL,1,600,NULL,0,NULL,NULL,0),(77,48,7,20,0,0,0,1,'NpcGeothermalPlant',NULL,8,21,NULL,1,600,NULL,0,NULL,NULL,0),(78,48,1,11,0,0,0,1,'NpcZetiumExtractor',NULL,2,12,NULL,1,800,NULL,0,NULL,NULL,0),(79,48,6,32,0,0,0,1,'NpcSolarPlant',NULL,7,33,NULL,1,1000,NULL,0,NULL,NULL,0),(80,48,0,31,0,0,0,1,'NpcSolarPlant',NULL,1,32,NULL,1,1000,NULL,0,NULL,NULL,0),(81,48,13,27,0,0,0,1,'NpcSolarPlant',NULL,14,28,NULL,1,1000,NULL,0,NULL,NULL,0);
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
INSERT INTO `folliages` VALUES (6,0,15,4),(6,0,23,5),(6,3,0,8),(6,3,15,1),(6,3,25,5),(6,4,0,13),(6,4,20,0),(6,5,0,4),(6,5,3,0),(6,5,6,7),(6,5,7,13),(6,5,14,0),(6,5,20,10),(6,5,21,5),(6,6,3,4),(6,6,13,4),(6,6,20,5),(6,6,21,12),(6,6,23,13),(6,7,8,4),(6,7,14,4),(6,7,22,0),(6,8,2,7),(6,8,4,10),(6,8,8,7),(6,8,11,9),(6,8,15,3),(6,9,5,5),(6,9,6,1),(6,9,8,6),(6,9,13,3),(6,9,19,11),(6,9,20,8),(6,10,9,2),(6,10,10,4),(6,10,29,9),(6,11,4,6),(6,11,9,10),(6,11,19,7),(6,12,16,11),(6,13,7,3),(6,13,9,5),(6,13,20,0),(6,13,23,1),(6,13,26,10),(6,14,22,8),(6,14,23,11),(6,14,27,0),(6,15,21,2),(6,15,24,2),(6,16,19,1),(6,17,6,1),(6,17,7,8),(6,17,21,4),(6,17,22,11),(6,18,19,12),(6,19,6,6),(6,19,10,0),(6,19,13,5),(6,19,14,7),(6,19,17,3),(6,19,26,10),(6,19,27,9),(6,19,28,2),(6,20,16,3),(6,20,18,0),(6,20,19,4),(6,20,21,4),(6,20,23,3),(6,21,9,0),(6,21,15,4),(6,21,17,4),(6,21,25,9),(6,21,27,8),(6,22,8,1),(6,22,9,9),(6,22,14,10),(6,22,16,10),(6,22,17,12),(6,23,6,1),(6,23,8,2),(6,23,10,5),(6,23,12,5),(6,23,14,12),(6,23,16,10),(6,23,17,11),(6,23,20,2),(6,23,21,11),(6,23,22,5),(6,24,14,4),(6,24,20,2),(6,25,1,2),(6,25,3,4),(6,25,12,10),(6,25,14,7),(6,25,16,9),(6,25,18,2),(6,25,24,5),(6,26,11,9),(6,27,3,6),(6,28,12,8),(6,28,20,5),(6,29,1,6),(6,29,2,7),(6,29,6,9),(6,29,12,0),(7,0,2,0),(7,0,8,0),(7,0,39,4),(7,0,44,11),(7,1,6,6),(7,1,7,11),(7,1,39,8),(7,1,40,7),(7,2,7,9),(7,2,16,6),(7,2,30,9),(7,2,31,7),(7,2,32,4),(7,4,15,1),(7,4,16,8),(7,4,27,6),(7,4,28,9),(7,4,29,2),(7,4,31,11),(7,4,37,7),(7,4,38,1),(7,4,40,0),(7,5,8,6),(7,5,14,7),(7,5,27,5),(7,5,29,11),(7,5,31,3),(7,5,37,3),(7,5,40,11),(7,5,42,7),(7,6,6,2),(7,6,7,5),(7,6,9,6),(7,6,13,2),(7,6,17,11),(7,6,35,9),(7,6,37,12),(7,6,42,8),(7,6,43,10),(7,7,6,9),(7,7,7,4),(7,7,12,8),(7,7,15,5),(7,7,30,9),(7,7,35,6),(7,7,41,11),(7,7,44,5),(7,8,0,4),(7,8,2,1),(7,8,5,6),(7,8,7,5),(7,8,15,9),(7,8,27,5),(7,8,39,4),(7,8,40,9),(7,9,1,7),(7,9,3,13),(7,9,4,9),(7,9,6,2),(7,9,16,5),(7,9,28,6),(7,9,29,13),(7,9,35,0),(7,9,40,2),(7,10,0,4),(7,10,2,0),(7,10,3,0),(7,10,7,2),(7,10,9,4),(7,10,10,11),(7,10,21,2),(7,10,34,2),(7,10,37,5),(7,10,39,9),(7,10,44,4),(7,11,8,1),(7,11,14,6),(7,11,27,4),(7,11,33,0),(7,11,37,8),(7,11,43,8),(7,11,44,0),(7,11,45,7),(7,12,6,5),(7,12,8,10),(7,12,13,0),(7,12,15,4),(7,12,19,4),(7,12,27,8),(7,12,36,4),(7,12,49,9),(7,13,8,7),(7,13,11,12),(7,13,13,1),(7,13,17,3),(7,13,18,4),(7,13,28,4),(7,13,29,6),(7,13,35,3),(7,13,36,0),(7,13,39,13),(7,13,40,1),(7,13,44,1),(7,13,47,2),(7,14,5,2),(7,14,8,3),(7,14,10,0),(7,14,15,7),(7,14,20,6),(7,14,24,2),(7,14,38,3),(7,14,39,8),(7,14,49,4),(7,15,8,4),(7,15,13,5),(7,15,18,11),(7,15,30,10),(7,15,33,7),(7,15,36,3),(7,15,37,0),(7,15,38,13),(7,16,5,8),(7,16,6,2),(7,16,11,10),(7,16,12,11),(7,16,15,3),(7,16,18,1),(7,16,39,8),(7,16,41,0),(7,16,44,6),(7,16,50,0),(7,17,5,2),(7,17,8,11),(7,17,12,8),(7,17,17,9),(7,17,19,9),(7,17,35,7),(7,17,39,1),(7,17,43,9),(7,18,1,9),(7,18,9,4),(7,18,21,0),(7,18,30,1),(7,18,32,2),(7,18,35,3),(7,18,36,11),(7,18,37,13),(7,18,38,5),(7,18,39,1),(7,18,41,5),(7,19,8,3),(7,19,9,10),(7,19,34,7),(7,19,35,8),(7,19,36,9),(7,19,38,1),(7,20,1,10),(7,20,20,11),(7,20,22,2),(7,20,29,5),(7,20,31,6),(7,20,32,12),(7,20,36,9),(7,20,38,3),(7,21,0,3),(7,21,8,3),(7,21,20,9),(7,21,22,7),(7,21,34,8),(7,21,36,2),(7,21,43,10),(7,22,8,11),(7,22,12,2),(7,22,20,2),(7,22,29,1),(7,22,30,9),(7,22,35,11),(7,22,36,5),(7,22,39,5),(7,22,43,5),(7,22,44,2),(7,23,5,2),(7,23,20,8),(7,23,22,12),(7,23,32,8),(7,23,39,4),(7,24,1,9),(7,24,5,7),(7,24,13,9),(7,24,18,8),(7,24,24,8),(7,24,28,8),(7,25,11,0),(7,25,13,10),(7,25,33,9),(7,25,35,7),(7,25,39,4),(7,25,46,2),(7,26,5,3),(7,26,12,11),(7,26,14,4),(7,26,37,6),(7,26,38,5),(7,26,45,0),(7,26,46,6),(7,27,1,5),(7,27,7,10),(7,27,8,10),(7,27,10,11),(7,27,12,1),(7,27,15,7),(7,27,25,3),(7,27,31,5),(7,27,33,9),(7,27,41,1),(7,27,42,4),(7,27,43,4),(7,27,47,7),(7,28,4,10),(7,28,9,11),(7,28,12,8),(7,28,15,8),(7,28,16,4),(7,28,30,7),(7,28,34,1),(7,28,35,8),(7,28,38,3),(7,28,42,9),(7,28,43,2),(7,28,47,6),(16,0,0,3),(16,0,3,8),(16,0,4,3),(16,0,6,6),(16,0,22,3),(16,0,25,4),(16,0,28,5),(16,0,32,7),(16,0,33,4),(16,0,38,6),(16,0,45,3),(16,1,5,2),(16,1,28,1),(16,1,34,0),(16,1,36,10),(16,1,44,7),(16,2,5,9),(16,2,7,2),(16,2,9,2),(16,2,10,6),(16,2,32,2),(16,2,35,8),(16,2,36,12),(16,2,38,3),(16,3,2,13),(16,3,25,13),(16,3,26,7),(16,3,29,4),(16,3,38,6),(16,3,40,13),(16,4,6,4),(16,4,27,6),(16,4,29,6),(16,5,17,1),(16,5,20,6),(16,5,21,10),(16,5,27,9),(16,5,31,3),(16,5,32,1),(16,5,33,13),(16,5,36,2),(16,5,37,7),(16,5,39,3),(16,6,16,10),(16,6,27,13),(16,6,32,10),(16,6,38,3),(16,7,10,0),(16,7,15,4),(16,7,36,0),(16,8,3,0),(16,8,16,7),(16,8,17,4),(16,8,23,11),(16,8,26,0),(16,8,27,7),(16,8,28,4),(16,8,33,0),(16,8,40,12),(16,9,0,9),(16,9,2,3),(16,9,8,7),(16,9,11,3),(16,9,17,9),(16,9,18,4),(16,9,33,11),(16,9,35,11),(16,9,36,2),(16,9,37,3),(16,10,1,12),(16,10,19,10),(16,10,20,3),(16,10,24,6),(16,10,34,5),(16,11,14,6),(16,12,0,5),(16,12,4,4),(16,12,25,11),(16,12,26,1),(16,12,33,1),(16,12,35,10),(16,12,36,1),(16,13,2,10),(16,13,9,13),(16,13,35,0),(16,14,25,5),(16,14,36,3),(16,14,40,11),(16,15,15,7),(16,15,34,8),(16,16,2,4),(16,16,5,7),(16,16,24,9),(16,16,25,10),(16,16,36,11),(16,16,39,11),(16,17,0,7),(16,17,5,0),(16,17,6,4),(16,17,15,5),(16,17,16,0),(16,17,17,5),(16,17,32,3),(16,17,33,4),(16,17,36,2),(16,17,38,12),(16,17,39,9),(16,17,41,9),(16,17,50,6),(23,0,10,12),(23,0,14,5),(23,0,22,12),(23,0,34,2),(23,0,35,1),(23,2,15,6),(23,2,28,5),(23,3,10,8),(23,3,36,2),(23,4,3,3),(23,4,5,10),(23,4,29,5),(23,4,30,10),(23,5,8,5),(23,5,15,13),(23,5,30,13),(23,5,36,5),(23,6,4,13),(23,6,35,1),(23,7,2,6),(23,7,4,8),(23,7,5,4),(23,8,0,13),(23,8,2,10),(23,8,3,13),(23,8,4,12),(23,8,15,12),(23,8,17,9),(23,8,20,1),(23,8,30,10),(23,9,3,13),(23,9,21,13),(23,9,26,12),(23,9,27,8),(23,9,31,8),(23,10,0,2),(23,10,20,1),(23,10,24,11),(23,10,37,10),(23,11,19,0),(23,11,20,10),(23,11,24,4),(23,11,31,1),(23,11,33,3),(23,11,37,7),(23,12,3,2),(23,12,37,0),(24,0,3,7),(24,0,7,4),(24,0,14,10),(24,0,16,2),(24,0,19,10),(24,0,20,2),(24,0,21,5),(24,0,29,12),(24,0,30,2),(24,0,36,8),(24,0,41,12),(24,0,44,4),(24,1,5,4),(24,1,8,0),(24,1,13,0),(24,1,16,12),(24,1,19,5),(24,1,20,1),(24,1,31,1),(24,1,33,8),(24,1,41,6),(24,1,42,12),(24,1,43,3),(24,1,45,4),(24,2,19,1),(24,2,21,11),(24,2,29,4),(24,2,39,8),(24,3,7,11),(24,3,10,2),(24,3,16,12),(24,3,18,9),(24,3,30,1),(24,3,32,1),(24,3,33,2),(24,3,39,4),(24,4,11,11),(24,4,16,3),(24,4,29,2),(24,4,40,6),(24,5,0,1),(24,5,21,0),(24,5,22,12),(24,5,30,4),(24,5,34,11),(24,5,35,7),(24,5,45,1),(24,6,21,2),(24,6,26,1),(24,6,30,12),(24,6,32,4),(24,6,38,12),(24,6,40,10),(24,6,44,4),(24,7,9,12),(24,7,23,0),(24,7,31,0),(24,7,36,11),(24,7,37,5),(24,7,43,3),(24,8,4,13),(24,8,8,4),(24,8,20,3),(24,8,21,5),(24,8,24,6),(24,8,32,11),(24,8,33,3),(24,8,43,1),(24,9,7,4),(24,9,8,12),(24,9,31,5),(24,10,9,13),(24,10,12,2),(24,10,14,10),(24,10,19,2),(24,10,28,4),(24,10,29,13),(24,10,31,13),(24,11,14,5),(24,11,15,1),(24,11,19,9),(24,11,32,11),(24,12,4,9),(24,12,8,0),(24,12,9,12),(24,12,12,4),(24,12,16,6),(24,13,5,12),(24,13,6,10),(24,13,12,7),(24,13,13,10),(24,13,15,4),(24,13,19,2),(24,13,21,12),(24,13,23,0),(24,13,24,4),(24,13,44,1),(24,14,9,5),(24,14,19,7),(24,14,22,11),(24,14,23,0),(24,14,35,8),(24,14,39,7),(24,14,45,0),(24,15,12,13),(24,15,33,1),(24,15,39,11),(24,16,21,5),(24,16,27,10),(24,16,32,6),(24,16,45,7),(24,17,13,4),(24,17,18,3),(24,17,19,7),(24,17,21,6),(24,17,22,7),(24,17,32,11),(24,17,34,0),(24,18,21,1),(24,18,22,2),(24,18,32,13),(24,18,33,2),(24,18,36,3),(24,18,39,0),(42,0,0,1),(42,0,4,7),(42,0,5,1),(42,0,6,9),(42,0,11,1),(42,0,13,4),(42,0,26,0),(42,0,29,6),(42,0,30,2),(42,0,32,3),(42,0,34,6),(42,1,1,2),(42,1,5,7),(42,1,6,1),(42,1,14,6),(42,1,27,3),(42,1,30,1),(42,1,36,9),(42,1,38,0),(42,2,0,2),(42,2,2,1),(42,2,29,1),(42,2,36,10),(42,2,37,0),(42,3,0,3),(42,3,26,1),(42,3,28,0),(42,3,33,11),(42,3,35,10),(42,3,37,11),(42,4,11,3),(42,4,12,5),(42,4,14,2),(42,4,25,1),(42,4,33,10),(42,4,35,10),(42,4,36,10),(42,5,14,0),(42,5,24,5),(42,5,26,7),(42,5,35,10),(42,6,0,0),(42,6,2,5),(42,6,7,2),(42,6,14,7),(42,6,19,5),(42,6,25,13),(42,6,26,10),(42,6,28,5),(42,6,36,0),(42,6,37,6),(42,6,38,9),(42,7,1,5),(42,7,6,6),(42,7,9,12),(42,7,24,6),(42,7,28,5),(42,8,1,7),(42,8,16,1),(42,8,25,9),(42,8,26,9),(42,8,28,0),(42,8,38,1),(42,9,1,3),(42,9,10,11),(42,9,11,8),(42,10,0,1),(42,10,7,8),(42,10,8,7),(42,10,12,8),(42,10,26,0),(42,10,28,8),(42,10,37,1),(42,11,6,9),(42,11,31,11),(42,11,36,2),(42,12,19,11),(42,12,38,11),(42,13,17,0),(42,14,32,9),(42,14,38,7),(42,15,4,5),(42,15,12,7),(42,15,13,11),(42,15,14,7),(42,15,22,10),(42,15,30,13),(42,15,32,13),(42,15,38,12),(42,16,2,3),(42,16,10,10),(42,16,11,6),(42,16,13,11),(42,16,19,9),(42,16,28,0),(42,16,34,4),(42,16,35,1),(42,17,1,9),(42,17,4,2),(42,17,7,5),(42,17,13,8),(42,17,14,2),(42,17,24,4),(42,17,25,9),(42,17,26,11),(42,17,34,3),(42,18,0,8),(42,18,2,6),(42,18,10,5),(42,18,13,9),(42,18,14,1),(42,18,21,4),(42,18,25,9),(42,18,26,6),(42,18,33,3),(42,18,36,10),(42,18,38,7),(42,19,3,9),(42,19,6,10),(42,19,9,9),(42,19,10,6),(42,19,35,7),(42,20,10,11),(42,20,11,8),(42,20,38,4),(42,21,4,5),(42,21,9,8),(42,21,13,1),(42,21,16,11),(42,21,23,6),(42,21,29,7),(42,21,30,4),(42,22,1,5),(42,22,8,4),(42,22,16,10),(42,22,27,9),(42,22,28,5),(42,22,29,9),(42,22,30,4),(42,22,38,4),(42,23,1,2),(42,23,4,3),(42,23,27,9),(42,24,0,5),(42,24,16,1),(42,24,33,13),(42,25,3,2),(42,25,5,4),(42,25,6,5),(42,25,8,2),(42,25,9,1),(42,25,17,1),(42,25,21,7),(42,25,26,7),(42,25,28,4),(42,25,31,8),(42,25,37,3),(42,25,38,5),(42,26,2,9),(42,26,3,13),(42,26,4,3),(42,26,5,0),(42,26,6,2),(42,26,10,1),(42,26,15,1),(42,26,28,12),(42,26,30,5),(42,27,0,4),(42,27,1,0),(42,27,5,4),(42,27,11,2),(42,27,15,9),(42,27,34,4),(42,27,35,3),(42,27,37,2),(42,27,38,3),(42,28,2,9),(42,28,5,11),(42,28,9,6),(42,28,12,9),(42,28,36,7),(42,28,37,11),(42,29,12,6),(42,29,14,4),(42,29,15,7),(42,29,28,1),(42,29,38,9),(42,30,14,1),(42,30,19,11),(42,30,35,0),(42,31,1,6),(42,31,10,2),(42,31,16,1),(42,31,35,7),(42,31,38,7),(42,32,6,1),(42,32,14,6),(42,32,18,8),(42,32,19,11),(42,32,37,5),(42,32,38,8),(42,33,38,9),(42,34,3,1),(42,34,6,4),(42,34,13,5),(42,34,20,13),(42,34,21,4),(48,0,11,0),(48,0,14,7),(48,0,20,10),(48,0,23,9),(48,1,8,6),(48,1,23,3),(48,2,1,3),(48,2,6,6),(48,2,7,7),(48,3,12,12),(48,3,14,13),(48,3,26,3),(48,3,28,4),(48,4,7,10),(48,4,17,13),(48,4,18,10),(48,4,27,4),(48,4,29,11),(48,5,15,0),(48,5,18,2),(48,5,24,4),(48,5,27,3),(48,5,28,11),(48,6,17,1),(48,6,19,1),(48,6,21,6),(48,6,23,3),(48,6,27,0),(48,6,29,11),(48,7,23,10),(48,8,2,2),(48,8,4,7),(48,8,5,1),(48,8,13,2),(48,8,17,7),(48,8,28,6),(48,8,32,5),(48,9,4,9),(48,9,6,4),(48,9,8,6),(48,10,10,11),(48,10,13,11),(48,10,20,6),(48,10,32,2),(48,11,3,6),(48,11,12,2),(48,11,14,10),(48,11,28,6),(48,11,32,7),(48,12,4,0),(48,12,5,0),(48,12,12,7),(48,12,30,8),(48,12,31,10),(48,13,25,2),(48,13,31,0),(48,13,32,10),(48,15,26,12),(48,15,27,2),(48,16,14,8),(48,16,25,7),(48,16,26,9),(48,17,18,10),(48,17,19,1),(48,17,24,4),(48,17,25,7),(48,17,27,13),(48,18,20,2),(48,18,27,7);
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
INSERT INTO `galaxies` VALUES (1,'2011-01-03 22:05:00','dev');
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
) ENGINE=InnoDB AUTO_INCREMENT=32 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `objectives`
--

LOCK TABLES `objectives` WRITE;
/*!40000 ALTER TABLE `objectives` DISABLE KEYS */;
INSERT INTO `objectives` VALUES (1,1,'HaveUpgradedTo','Building::CollectorT1',1,1,0,0,NULL),(2,2,'HaveUpgradedTo','Building::MetalExtractor',1,1,0,0,NULL),(3,3,'HaveUpgradedTo','Building::CollectorT1',2,1,0,0,NULL),(4,3,'HaveUpgradedTo','Building::MetalExtractor',2,1,0,0,NULL),(5,22,'ExploreBlock','ExploreBlock',1,NULL,0,0,9),(6,23,'ExploreBlock','ExploreBlock',10,NULL,0,0,9),(7,4,'HaveUpgradedTo','Building::CollectorT1',2,3,0,0,NULL),(8,4,'HaveUpgradedTo','Building::MetalExtractor',2,3,0,0,NULL),(9,5,'HaveUpgradedTo','Building::CollectorT1',2,4,0,0,NULL),(10,5,'HaveUpgradedTo','Building::MetalExtractor',2,4,0,0,NULL),(11,6,'HaveUpgradedTo','Building::Barracks',1,1,0,0,NULL),(12,7,'HaveUpgradedTo','Unit::Trooper',5,1,0,0,NULL),(13,8,'DestroyNpcBuilding','Building::NpcMetalExtractor',1,1,0,0,NULL),(14,9,'HaveUpgradedTo','Building::MetalExtractor',1,7,0,0,NULL),(15,10,'HaveUpgradedTo','Building::CollectorT1',1,7,0,0,NULL),(16,11,'HaveUpgradedTo','Building::ResearchCenter',1,1,0,0,NULL),(17,24,'ExploreBlock','ExploreBlock',5,NULL,0,0,12),(18,25,'ExploreBlock','ExploreBlock',5,NULL,0,0,16),(19,26,'ExploreBlock','ExploreBlock',10,NULL,0,0,36),(20,12,'HaveUpgradedTo','Unit::Seeker',3,1,0,0,NULL),(21,13,'HaveUpgradedTo','Unit::Trooper',10,1,0,0,NULL),(22,14,'HaveUpgradedTo','Technology::ZetiumExtraction',1,1,0,0,NULL),(23,15,'HaveUpgradedTo','Building::ZetiumExtractor',1,1,0,0,NULL),(24,16,'HavePoints','Player',1,NULL,0,0,20000),(25,17,'HaveUpgradedTo','Building::EnergyStorage',1,1,0,0,NULL),(26,17,'HaveUpgradedTo','Building::MetalStorage',1,1,0,0,NULL),(27,17,'HaveUpgradedTo','Building::ZetiumStorage',1,1,0,0,NULL),(28,18,'HaveUpgradedTo','Technology::SpaceFactory',1,1,0,0,NULL),(29,19,'HaveUpgradedTo','Building::SpaceFactory',1,1,0,0,NULL),(30,20,'AnnexPlanet','SsObject::Planet',1,NULL,0,1,NULL),(31,21,'UpgradeTo','Building::Headquarters',1,1,0,0,NULL);
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
INSERT INTO `players` VALUES (1,1,'0000000000000000000000000000000000000000000000000000000000000000','Test Player',18,18,NULL,0,0);
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
) ENGINE=InnoDB AUTO_INCREMENT=27 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `quests`
--

LOCK TABLES `quests` WRITE;
/*!40000 ALTER TABLE `quests` DISABLE KEYS */;
INSERT INTO `quests` VALUES (1,NULL,'{\"metal\":25.2,\"energy\":96.0}','building'),(2,1,'{\"metal\":69.3,\"energy\":140.8}','metal-extraction'),(3,2,'{\"metal\":2712.0,\"energy\":5424.0}',NULL),(4,3,'{\"metal\":412.5,\"energy\":920.7}',NULL),(5,4,'{\"metal\":401.4,\"zetium\":10.8,\"points\":4000}',NULL),(6,3,'{\"metal\":723.2,\"energy\":1446.4,\"zetium\":16.2,\"units\":[{\"level\":1,\"type\":\"Trooper\",\"count\":2,\"hp\":100}]}',NULL),(7,6,'{\"metal\":723.2,\"energy\":1446.4,\"zetium\":16.2}','building-units'),(8,7,'{\"metal\":1865.6,\"energy\":4134.9,\"zetium\":866.8,\"units\":[{\"level\":2,\"type\":\"Trooper\",\"count\":2,\"hp\":50},{\"level\":3,\"type\":\"Trooper\",\"count\":1,\"hp\":30}]}','npc-buildings'),(9,8,'{\"metal\":862.8,\"energy\":4101.6,\"zetium\":16.2,\"points\":2000}',NULL),(10,8,'{\"metal\":1725.6,\"energy\":2461.2,\"zetium\":16.2,\"points\":2000}',NULL),(11,8,'{\"metal\":396.0,\"energy\":1608.0}','researching'),(12,11,'{\"metal\":1374.5,\"energy\":2747.6,\"points\":2000}',NULL),(13,12,'{\"metal\":583.2,\"energy\":1165.6,\"zetium\":10.4,\"points\":2000}',NULL),(14,11,'{\"metal\":39.6,\"energy\":160.8}',NULL),(15,14,'{\"metal\":223.2,\"energy\":285.6,\"zetium\":31.2}','extracting-zetium'),(16,15,'{\"units\":[{\"level\":3,\"type\":\"Trooper\",\"count\":1,\"hp\":100},{\"level\":2,\"type\":\"Seeker\",\"count\":1,\"hp\":100},{\"level\":1,\"type\":\"Shocker\",\"count\":3,\"hp\":100}]}','collecting-points'),(17,15,'{\"metal\":4590.4,\"energy\":6426.4,\"zetium\":321.6}','storing-resources'),(18,17,'{\"metal\":11475.2,\"energy\":16065.6,\"zetium\":804.0}','research-space-factory'),(19,18,'{\"units\":[{\"level\":1,\"type\":\"Crow\",\"count\":2,\"hp\":100}]}',NULL),(20,19,'{\"units\":[{\"level\":1,\"type\":\"Mule\",\"count\":1,\"hp\":100},{\"level\":1,\"type\":\"Mdh\",\"count\":1,\"hp\":100}]}','annexing-planets'),(21,20,'{\"metal\":1158.5844,\"energy\":2560.7376,\"zetium\":78.6651}','colonizing'),(22,3,'{\"units\":[{\"level\":1,\"type\":\"Gnat\",\"count\":1,\"hp\":25}],\"points\":200}','exploring'),(23,22,'{\"units\":[{\"level\":1,\"type\":\"Glancer\",\"count\":1,\"hp\":60}],\"points\":1000}',NULL),(24,11,'{\"units\":[{\"level\":1,\"type\":\"Gnat\",\"count\":2,\"hp\":25},{\"level\":1,\"type\":\"Gnat\",\"count\":2,\"hp\":20},{\"level\":1,\"type\":\"Gnat\",\"count\":2,\"hp\":15},{\"level\":1,\"type\":\"Gnat\",\"count\":2,\"hp\":10}],\"points\":800}',NULL),(25,24,'{\"units\":[{\"level\":1,\"type\":\"Glancer\",\"count\":2,\"hp\":80}],\"points\":800}',NULL),(26,25,'{\"units\":[{\"level\":1,\"type\":\"Spudder\",\"count\":1,\"hp\":96}],\"points\":1600}',NULL);
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
INSERT INTO `solar_systems` VALUES (1,'Homeworld',1,2,2),(2,'Expansion',1,1,1),(3,'Resource',1,0,1),(4,'Expansion',1,1,0);
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
) ENGINE=InnoDB AUTO_INCREMENT=51 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ss_objects`
--

LOCK TABLES `ss_objects` WRITE;
/*!40000 ALTER TABLE `ss_objects` DISABLE KEYS */;
INSERT INTO `ss_objects` VALUES (1,1,0,0,3,112,'Jumpgate',NULL,'',32,0,0,0,0,0,0,0,0,0,0,NULL,0,NULL,NULL,NULL),(2,1,0,0,2,120,'Asteroid',NULL,'',55,0,0,0,1,0,0,0,0,0,1,NULL,0,NULL,NULL,NULL),(3,1,0,0,2,30,'Asteroid',NULL,'',37,0,0,0,0,0,0,1,0,0,1,NULL,0,NULL,NULL,NULL),(4,1,0,0,0,180,'Asteroid',NULL,'',29,0,0,0,0,0,0,1,0,0,0,NULL,0,NULL,NULL,NULL),(5,1,0,0,1,0,'Asteroid',NULL,'',38,0,0,0,0,0,0,0,0,0,1,NULL,0,NULL,NULL,NULL),(6,1,30,30,2,60,'Planet',1,'P-6',50,0,3186.11,2.79,9654.87,7042.03,6.17,21339.5,0,0,2622.17,'2011-01-03 22:05:10',0,NULL,NULL,NULL),(7,1,29,51,1,270,'Planet',NULL,'P-7',58,0,0,0,0,0,0,0,0,0,0,'2011-01-03 22:05:10',0,NULL,NULL,NULL),(8,1,0,0,0,0,'Asteroid',NULL,'',38,0,0,0,0,0,0,1,0,0,1,NULL,0,NULL,NULL,NULL),(9,2,0,0,1,45,'Asteroid',NULL,'',38,0,0,0,1,0,0,1,0,0,1,NULL,0,NULL,NULL,NULL),(10,2,0,0,1,225,'Asteroid',NULL,'',57,0,0,0,2,0,0,3,0,0,2,NULL,0,NULL,NULL,NULL),(11,2,0,0,2,120,'Asteroid',NULL,'',38,0,0,0,1,0,0,1,0,0,2,NULL,0,NULL,NULL,NULL),(12,2,0,0,1,315,'Asteroid',NULL,'',45,0,0,0,2,0,0,2,0,0,1,NULL,0,NULL,NULL,NULL),(13,2,0,0,3,66,'Jumpgate',NULL,'',33,0,0,0,0,0,0,0,0,0,0,NULL,0,NULL,NULL,NULL),(14,2,0,0,2,60,'Asteroid',NULL,'',34,0,0,0,2,0,0,2,0,0,1,NULL,0,NULL,NULL,NULL),(15,2,0,0,1,0,'Asteroid',NULL,'',28,0,0,0,2,0,0,3,0,0,2,NULL,0,NULL,NULL,NULL),(16,2,18,52,1,270,'Planet',NULL,'P-16',54,2,0,0,0,0,0,0,0,0,0,'2011-01-03 22:05:10',0,NULL,NULL,NULL),(17,2,0,0,1,90,'Asteroid',NULL,'',46,0,0,0,0,0,0,0,0,0,1,NULL,0,NULL,NULL,NULL),(18,2,0,0,2,30,'Asteroid',NULL,'',52,0,0,0,3,0,0,2,0,0,2,NULL,0,NULL,NULL,NULL),(19,2,0,0,2,180,'Asteroid',NULL,'',55,0,0,0,0,0,0,1,0,0,1,NULL,0,NULL,NULL,NULL),(20,2,0,0,2,0,'Asteroid',NULL,'',49,0,0,0,1,0,0,2,0,0,1,NULL,0,NULL,NULL,NULL),(21,2,0,0,3,90,'Jumpgate',NULL,'',53,0,0,0,0,0,0,0,0,0,0,NULL,0,NULL,NULL,NULL),(22,2,0,0,0,180,'Asteroid',NULL,'',58,0,0,0,2,0,0,1,0,0,2,NULL,0,NULL,NULL,NULL),(23,2,13,38,0,0,'Planet',NULL,'P-23',46,2,0,0,0,0,0,0,0,0,0,'2011-01-03 22:05:10',0,NULL,NULL,NULL),(24,3,19,46,1,45,'Planet',NULL,'P-24',52,2,0,0,0,0,0,0,0,0,0,'2011-01-03 22:05:10',0,NULL,NULL,NULL),(25,3,0,0,2,120,'Asteroid',NULL,'',27,0,0,0,0,0,0,0,0,0,1,NULL,0,NULL,NULL,NULL),(26,3,0,0,2,30,'Asteroid',NULL,'',56,0,0,0,3,0,0,2,0,0,1,NULL,0,NULL,NULL,NULL),(27,3,0,0,0,90,'Asteroid',NULL,'',29,0,0,0,3,0,0,2,0,0,2,NULL,0,NULL,NULL,NULL),(28,3,0,0,0,270,'Asteroid',NULL,'',53,0,0,0,3,0,0,3,0,0,1,NULL,0,NULL,NULL,NULL),(29,3,0,0,3,202,'Jumpgate',NULL,'',45,0,0,0,0,0,0,0,0,0,0,NULL,0,NULL,NULL,NULL),(30,3,0,0,2,270,'Asteroid',NULL,'',34,0,0,0,3,0,0,3,0,0,3,NULL,0,NULL,NULL,NULL),(31,3,0,0,3,224,'Jumpgate',NULL,'',35,0,0,0,0,0,0,0,0,0,0,NULL,0,NULL,NULL,NULL),(32,3,0,0,0,0,'Asteroid',NULL,'',44,0,0,0,1,0,0,2,0,0,1,NULL,0,NULL,NULL,NULL),(33,4,0,0,1,225,'Asteroid',NULL,'',35,0,0,0,2,0,0,1,0,0,1,NULL,0,NULL,NULL,NULL),(34,4,0,0,2,120,'Asteroid',NULL,'',31,0,0,0,1,0,0,1,0,0,2,NULL,0,NULL,NULL,NULL),(35,4,0,0,1,180,'Asteroid',NULL,'',58,0,0,0,1,0,0,0,0,0,1,NULL,0,NULL,NULL,NULL),(36,4,0,0,2,210,'Asteroid',NULL,'',59,0,0,0,2,0,0,2,0,0,1,NULL,0,NULL,NULL,NULL),(37,4,0,0,1,315,'Asteroid',NULL,'',54,0,0,0,1,0,0,0,0,0,1,NULL,0,NULL,NULL,NULL),(38,4,0,0,3,224,'Jumpgate',NULL,'',59,0,0,0,0,0,0,0,0,0,0,NULL,0,NULL,NULL,NULL),(39,4,0,0,2,60,'Asteroid',NULL,'',38,0,0,0,1,0,0,1,0,0,1,NULL,0,NULL,NULL,NULL),(40,4,0,0,1,0,'Asteroid',NULL,'',51,0,0,0,1,0,0,2,0,0,3,NULL,0,NULL,NULL,NULL),(41,4,0,0,1,270,'Asteroid',NULL,'',26,0,0,0,1,0,0,1,0,0,1,NULL,0,NULL,NULL,NULL),(42,4,35,39,1,90,'Planet',NULL,'P-42',56,1,0,0,0,0,0,0,0,0,0,'2011-01-03 22:05:10',0,NULL,NULL,NULL),(43,4,0,0,2,30,'Asteroid',NULL,'',43,0,0,0,1,0,0,1,0,0,1,NULL,0,NULL,NULL,NULL),(44,4,0,0,2,180,'Asteroid',NULL,'',37,0,0,0,3,0,0,1,0,0,3,NULL,0,NULL,NULL,NULL),(45,4,0,0,1,135,'Asteroid',NULL,'',59,0,0,0,0,0,0,0,0,0,1,NULL,0,NULL,NULL,NULL),(46,4,0,0,2,330,'Asteroid',NULL,'',52,0,0,0,1,0,0,1,0,0,3,NULL,0,NULL,NULL,NULL),(47,4,0,0,2,0,'Asteroid',NULL,'',29,0,0,0,1,0,0,1,0,0,0,NULL,0,NULL,NULL,NULL),(48,4,19,34,0,180,'Planet',NULL,'P-48',47,2,0,0,0,0,0,0,0,0,0,'2011-01-03 22:05:10',0,NULL,NULL,NULL),(49,4,0,0,2,300,'Asteroid',NULL,'',28,0,0,0,1,0,0,3,0,0,2,NULL,0,NULL,NULL,NULL),(50,4,0,0,0,0,'Asteroid',NULL,'',36,0,0,0,3,0,0,2,0,0,3,NULL,0,NULL,NULL,NULL);
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
INSERT INTO `tiles` VALUES (0,6,0,0),(5,6,0,3),(5,6,0,4),(5,6,0,5),(5,6,0,6),(5,6,0,7),(5,6,0,8),(5,6,0,9),(5,6,0,10),(5,6,0,11),(5,6,0,12),(5,6,0,13),(5,6,0,14),(5,6,0,26),(5,6,0,27),(5,6,0,28),(5,6,0,29),(5,6,1,3),(11,6,1,4),(5,6,1,11),(5,6,1,12),(5,6,1,13),(13,6,1,16),(4,6,1,19),(4,6,1,20),(4,6,1,21),(4,6,1,22),(5,6,1,26),(5,6,1,27),(5,6,1,28),(5,6,1,29),(5,6,2,2),(5,6,2,3),(5,6,2,10),(5,6,2,12),(5,6,2,13),(5,6,2,14),(5,6,2,15),(4,6,2,20),(4,6,2,21),(4,6,2,22),(4,6,2,23),(5,6,2,27),(5,6,2,28),(5,6,2,29),(0,6,3,1),(5,6,3,10),(5,6,3,11),(5,6,3,12),(5,6,3,13),(5,6,3,14),(4,6,3,20),(4,6,3,21),(4,6,3,22),(4,6,3,23),(4,6,3,24),(5,6,3,28),(5,6,3,29),(5,6,4,12),(5,6,4,13),(6,6,4,18),(4,6,4,21),(4,6,4,22),(4,6,4,23),(5,6,4,26),(5,6,4,27),(5,6,4,28),(6,6,5,8),(6,6,5,9),(6,6,5,18),(6,6,5,19),(4,6,5,22),(4,6,5,23),(4,6,5,24),(5,6,5,26),(5,6,5,27),(6,6,6,7),(6,6,6,8),(6,6,6,9),(6,6,6,11),(6,6,6,18),(6,6,6,19),(6,6,7,9),(6,6,7,10),(6,6,7,18),(12,6,7,23),(6,6,8,9),(6,6,8,10),(6,6,8,16),(6,6,8,17),(6,6,8,18),(3,6,9,3),(3,6,9,4),(6,6,9,9),(6,6,9,15),(6,6,9,16),(6,6,9,17),(3,6,10,0),(3,6,10,2),(3,6,10,3),(3,6,10,4),(8,6,10,5),(6,6,10,16),(6,6,10,17),(0,6,10,20),(3,6,11,0),(3,6,11,1),(3,6,11,2),(3,6,11,3),(3,6,12,0),(3,6,12,1),(3,6,12,2),(3,6,13,0),(3,6,13,1),(3,6,13,2),(3,6,13,4),(3,6,14,0),(3,6,14,1),(3,6,14,2),(3,6,14,3),(3,6,14,4),(3,6,15,0),(3,6,15,1),(3,6,15,2),(3,6,15,3),(3,6,15,4),(3,6,16,0),(3,6,16,1),(3,6,16,2),(3,6,16,3),(5,6,16,29),(3,6,17,0),(3,6,17,1),(3,6,17,2),(3,6,17,3),(3,6,17,4),(5,6,17,28),(5,6,17,29),(3,6,18,0),(3,6,18,1),(3,6,18,2),(3,6,18,3),(3,6,18,4),(3,6,18,5),(0,6,18,23),(5,6,18,28),(5,6,18,29),(3,6,19,0),(3,6,19,1),(3,6,19,2),(3,6,19,3),(3,6,19,4),(3,6,19,5),(5,6,19,29),(3,6,20,0),(3,6,20,1),(3,6,20,2),(3,6,20,3),(3,6,20,4),(3,6,20,5),(5,6,20,28),(5,6,20,29),(3,6,21,0),(3,6,21,1),(3,6,21,2),(3,6,21,3),(3,6,21,4),(5,6,21,29),(3,6,22,0),(3,6,22,1),(3,6,22,2),(14,6,22,25),(5,6,22,29),(3,6,23,0),(3,6,23,1),(3,6,23,2),(3,6,23,3),(4,6,23,9),(5,6,23,29),(3,6,24,1),(3,6,24,2),(0,6,24,4),(4,6,24,7),(4,6,24,8),(4,6,24,9),(4,6,24,10),(4,6,24,11),(5,6,24,29),(4,6,25,7),(4,6,25,8),(4,6,25,9),(4,6,25,10),(5,6,25,27),(5,6,25,29),(4,6,26,6),(4,6,26,7),(4,6,26,8),(4,6,26,9),(4,6,26,10),(2,6,26,12),(6,6,26,22),(6,6,26,23),(5,6,26,27),(5,6,26,28),(5,6,26,29),(4,6,27,5),(4,6,27,6),(4,6,27,7),(4,6,27,8),(4,6,27,9),(4,6,27,10),(5,6,27,17),(5,6,27,18),(5,6,27,21),(5,6,27,22),(6,6,27,23),(6,6,27,24),(0,6,28,4),(4,6,28,6),(4,6,28,7),(4,6,28,8),(4,6,28,9),(4,6,28,10),(5,6,28,15),(5,6,28,16),(5,6,28,17),(5,6,28,18),(5,6,28,19),(5,6,28,21),(5,6,28,22),(6,6,28,23),(6,6,28,24),(5,6,28,25),(5,6,28,26),(5,6,28,27),(5,6,28,28),(4,6,29,7),(4,6,29,8),(4,6,29,9),(4,6,29,10),(4,6,29,11),(5,6,29,16),(5,6,29,17),(5,6,29,18),(5,6,29,19),(5,6,29,20),(5,6,29,21),(5,6,29,22),(6,6,29,23),(6,6,29,24),(6,6,29,25),(6,6,29,26),(5,6,29,27),(6,7,0,9),(6,7,0,10),(6,7,0,12),(6,7,0,13),(6,7,0,14),(6,7,0,15),(6,7,0,16),(3,7,0,17),(6,7,0,18),(6,7,0,19),(6,7,0,20),(6,7,0,21),(6,7,0,22),(6,7,0,23),(6,7,0,24),(6,7,0,25),(6,7,0,26),(6,7,0,27),(6,7,0,28),(6,7,0,29),(6,7,0,30),(5,7,0,34),(5,7,0,35),(3,7,0,41),(3,7,0,42),(3,7,0,45),(3,7,0,46),(3,7,0,47),(3,7,0,48),(3,7,0,49),(3,7,0,50),(6,7,1,9),(6,7,1,10),(6,7,1,11),(6,7,1,12),(6,7,1,13),(6,7,1,14),(6,7,1,15),(6,7,1,16),(6,7,1,17),(6,7,1,18),(6,7,1,19),(0,7,1,20),(6,7,1,22),(6,7,1,23),(6,7,1,24),(6,7,1,25),(6,7,1,26),(6,7,1,27),(6,7,1,28),(6,7,1,29),(6,7,1,30),(6,7,1,31),(5,7,1,35),(5,7,1,36),(5,7,1,37),(5,7,1,38),(3,7,1,42),(3,7,1,43),(3,7,1,44),(3,7,1,45),(3,7,1,46),(3,7,1,47),(3,7,1,48),(3,7,1,49),(3,7,1,50),(11,7,2,1),(6,7,2,8),(6,7,2,9),(6,7,2,10),(6,7,2,11),(6,7,2,12),(6,7,2,13),(6,7,2,14),(6,7,2,15),(6,7,2,17),(6,7,2,18),(6,7,2,19),(6,7,2,22),(4,7,2,23),(6,7,2,24),(6,7,2,25),(6,7,2,26),(6,7,2,27),(6,7,2,28),(5,7,2,36),(5,7,2,37),(5,7,2,38),(3,7,2,42),(3,7,2,43),(3,7,2,44),(4,7,2,45),(4,7,2,46),(3,7,2,47),(3,7,2,48),(3,7,2,49),(3,7,2,50),(6,7,3,11),(6,7,3,14),(4,7,3,17),(4,7,3,18),(6,7,3,19),(4,7,3,21),(4,7,3,22),(4,7,3,23),(4,7,3,24),(6,7,3,25),(6,7,3,26),(6,7,3,27),(5,7,3,34),(5,7,3,35),(5,7,3,36),(3,7,3,41),(3,7,3,42),(3,7,3,43),(3,7,3,44),(4,7,3,46),(4,7,3,47),(4,7,3,48),(3,7,3,49),(3,7,3,50),(6,7,4,9),(6,7,4,10),(6,7,4,11),(6,7,4,12),(4,7,4,17),(4,7,4,18),(4,7,4,19),(4,7,4,22),(4,7,4,23),(4,7,4,24),(6,7,4,25),(4,7,4,26),(5,7,4,34),(5,7,4,35),(3,7,4,42),(4,7,4,46),(4,7,4,48),(4,7,4,49),(3,7,4,50),(6,7,5,11),(6,7,5,12),(6,7,5,13),(4,7,5,18),(4,7,5,19),(4,7,5,20),(4,7,5,21),(4,7,5,22),(4,7,5,23),(4,7,5,24),(4,7,5,25),(4,7,5,26),(9,7,5,32),(4,7,5,44),(4,7,5,45),(4,7,5,46),(4,7,5,47),(4,7,5,48),(4,7,5,49),(3,7,5,50),(14,7,6,18),(4,7,6,22),(4,7,6,23),(4,7,6,24),(4,7,6,25),(4,7,6,45),(4,7,6,46),(4,7,6,47),(4,7,6,48),(4,7,6,49),(3,7,6,50),(0,7,7,8),(4,7,7,22),(4,7,7,23),(4,7,7,24),(4,7,7,25),(4,7,7,26),(4,7,7,45),(4,7,7,46),(4,7,7,47),(4,7,7,48),(4,7,7,50),(4,7,8,22),(4,7,8,23),(4,7,8,24),(4,7,8,25),(4,7,8,26),(4,7,8,45),(4,7,8,46),(4,7,8,47),(4,7,8,48),(4,7,8,49),(4,7,8,50),(4,7,9,19),(4,7,9,20),(4,7,9,21),(4,7,9,22),(4,7,9,24),(4,7,9,26),(5,7,9,31),(5,7,9,32),(5,7,9,33),(5,7,9,34),(4,7,9,43),(4,7,9,44),(4,7,9,45),(4,7,9,46),(4,7,9,47),(4,7,9,48),(4,7,9,49),(4,7,9,50),(4,7,10,18),(4,7,10,19),(4,7,10,20),(5,7,10,31),(5,7,10,32),(5,7,10,33),(4,7,10,43),(4,7,10,45),(4,7,10,47),(4,7,10,48),(4,7,10,49),(4,7,10,50),(14,7,11,0),(4,7,11,18),(4,7,11,19),(4,7,11,20),(5,7,11,32),(4,7,11,46),(4,7,11,47),(4,7,11,48),(4,7,11,49),(4,7,11,50),(4,7,12,20),(4,7,12,26),(5,7,12,32),(5,7,12,33),(5,7,12,34),(5,7,12,35),(3,7,12,45),(3,7,12,46),(4,7,12,48),(1,7,13,6),(4,7,13,20),(4,7,13,26),(4,7,13,27),(5,7,13,32),(5,7,13,33),(3,7,13,46),(4,7,13,48),(5,7,14,16),(5,7,14,17),(5,7,14,18),(5,7,14,19),(5,7,14,21),(5,7,14,22),(4,7,14,25),(4,7,14,26),(4,7,14,27),(4,7,14,28),(3,7,14,44),(3,7,14,46),(3,7,14,47),(3,7,15,2),(5,7,15,10),(5,7,15,11),(5,7,15,12),(5,7,15,17),(5,7,15,19),(5,7,15,21),(5,7,15,22),(4,7,15,25),(4,7,15,26),(4,7,15,27),(4,7,15,28),(4,7,15,29),(3,7,15,44),(3,7,15,45),(3,7,15,47),(3,7,15,48),(3,7,15,49),(3,7,16,1),(3,7,16,2),(5,7,16,9),(5,7,16,10),(5,7,16,19),(5,7,16,20),(5,7,16,21),(5,7,16,22),(4,7,16,23),(4,7,16,24),(4,7,16,25),(4,7,16,26),(4,7,16,27),(4,7,16,28),(4,7,16,29),(4,7,16,30),(3,7,16,45),(3,7,16,46),(3,7,16,47),(3,7,16,48),(3,7,17,0),(3,7,17,1),(3,7,17,2),(5,7,17,10),(5,7,17,11),(4,7,17,22),(4,7,17,23),(4,7,17,24),(4,7,17,25),(4,7,17,26),(4,7,17,27),(4,7,17,28),(4,7,17,29),(3,7,17,44),(3,7,17,45),(3,7,17,46),(3,7,17,47),(2,7,17,48),(3,7,18,2),(3,7,18,3),(3,7,18,4),(3,7,18,5),(5,7,18,10),(5,7,18,11),(5,7,18,12),(3,7,18,13),(3,7,18,14),(3,7,18,16),(4,7,18,23),(4,7,18,24),(4,7,18,25),(4,7,18,26),(4,7,18,27),(4,7,18,28),(3,7,18,43),(3,7,18,44),(3,7,18,45),(3,7,18,46),(3,7,18,47),(3,7,18,50),(3,7,19,1),(3,7,19,2),(3,7,19,3),(3,7,19,4),(0,7,19,5),(5,7,19,10),(5,7,19,11),(5,7,19,12),(3,7,19,13),(3,7,19,14),(3,7,19,15),(3,7,19,16),(3,7,19,17),(0,7,19,18),(4,7,19,23),(4,7,19,24),(4,7,19,25),(4,7,19,27),(4,7,19,28),(3,7,19,44),(3,7,19,45),(3,7,19,46),(3,7,19,47),(3,7,19,48),(3,7,19,49),(3,7,19,50),(3,7,20,2),(3,7,20,3),(3,7,20,4),(3,7,20,10),(3,7,20,11),(5,7,20,12),(3,7,20,13),(3,7,20,14),(4,7,20,23),(4,7,20,24),(4,7,20,25),(4,7,20,26),(4,7,20,27),(3,7,20,43),(3,7,20,44),(3,7,20,45),(3,7,20,46),(3,7,20,47),(3,7,20,48),(3,7,20,49),(3,7,20,50),(0,7,21,1),(3,7,21,3),(3,7,21,4),(3,7,21,5),(3,7,21,6),(3,7,21,10),(3,7,21,11),(3,7,21,12),(3,7,21,13),(3,7,21,14),(3,7,21,15),(3,7,21,16),(3,7,21,17),(4,7,21,24),(4,7,21,25),(3,7,21,46),(3,7,21,47),(3,7,21,48),(3,7,21,49),(3,7,21,50),(3,7,22,3),(3,7,22,4),(3,7,22,5),(3,7,22,6),(3,7,22,7),(3,7,22,11),(3,7,22,13),(3,7,22,14),(3,7,22,15),(3,7,22,17),(6,7,22,21),(4,7,22,23),(4,7,22,24),(4,7,22,25),(4,7,22,26),(3,7,22,46),(3,7,22,48),(3,7,22,49),(3,7,22,50),(3,7,23,3),(3,7,23,6),(3,7,23,7),(3,7,23,12),(3,7,23,13),(3,7,23,15),(3,7,23,16),(3,7,23,17),(6,7,23,19),(6,7,23,21),(4,7,23,25),(3,7,23,46),(3,7,23,47),(3,7,23,48),(3,7,23,49),(3,7,23,50),(3,7,24,2),(3,7,24,3),(3,7,24,7),(3,7,24,16),(3,7,24,17),(6,7,24,19),(6,7,24,20),(6,7,24,21),(5,7,24,26),(5,7,24,27),(3,7,24,45),(3,7,24,46),(3,7,24,47),(3,7,24,48),(3,7,24,49),(3,7,24,50),(3,7,25,3),(0,7,25,9),(0,7,25,15),(3,7,25,17),(3,7,25,18),(6,7,25,19),(6,7,25,21),(5,7,25,26),(5,7,25,27),(5,7,25,28),(5,7,25,29),(5,7,25,30),(5,7,25,31),(3,7,25,45),(3,7,25,48),(3,7,25,49),(3,7,25,50),(3,7,26,3),(6,7,26,19),(6,7,26,21),(6,7,26,22),(6,7,26,23),(6,7,26,24),(5,7,26,27),(5,7,26,28),(3,7,26,47),(3,7,26,48),(3,7,26,49),(6,7,27,18),(6,7,27,19),(6,7,27,20),(6,7,27,21),(6,7,27,22),(6,7,27,23),(5,7,27,27),(5,7,27,28),(5,7,27,29),(3,7,27,49),(6,7,28,18),(6,7,28,19),(6,7,28,20),(6,7,28,21),(6,7,28,23),(5,7,28,29),(11,16,0,14),(3,16,0,20),(3,16,0,21),(5,16,0,40),(5,16,0,41),(6,16,0,46),(3,16,0,47),(3,16,0,48),(3,16,0,49),(3,16,0,50),(3,16,0,51),(1,16,1,3),(3,16,1,20),(3,16,1,21),(3,16,1,22),(3,16,1,24),(3,16,1,25),(5,16,1,40),(5,16,1,41),(5,16,1,42),(6,16,1,46),(3,16,1,47),(3,16,1,48),(3,16,1,49),(3,16,1,50),(3,16,1,51),(3,16,2,22),(3,16,2,23),(3,16,2,24),(3,16,2,25),(5,16,2,39),(5,16,2,40),(5,16,2,41),(6,16,2,45),(6,16,2,46),(6,16,2,47),(6,16,2,48),(6,16,2,49),(3,16,2,51),(6,16,3,10),(0,16,3,11),(3,16,3,22),(3,16,3,23),(3,16,3,24),(5,16,3,41),(5,16,3,42),(6,16,3,46),(6,16,3,47),(6,16,3,48),(6,16,3,49),(3,16,3,50),(3,16,3,51),(4,16,4,1),(4,16,4,3),(4,16,4,4),(4,16,4,5),(6,16,4,9),(6,16,4,10),(3,16,4,21),(3,16,4,22),(3,16,4,23),(5,16,4,37),(5,16,4,38),(5,16,4,39),(5,16,4,40),(5,16,4,41),(5,16,4,42),(5,16,4,43),(10,16,4,47),(3,16,4,51),(4,16,5,0),(4,16,5,1),(4,16,5,3),(4,16,5,4),(0,16,5,5),(6,16,5,9),(6,16,5,10),(6,16,5,11),(6,16,5,12),(3,16,5,22),(3,16,5,23),(5,16,5,38),(5,16,5,41),(5,16,5,42),(5,16,5,43),(5,16,5,44),(3,16,5,51),(4,16,6,0),(4,16,6,1),(4,16,6,2),(4,16,6,3),(4,16,6,4),(6,16,6,10),(6,16,6,11),(6,16,6,12),(6,16,6,13),(13,16,6,21),(3,16,6,23),(0,16,6,39),(5,16,6,41),(5,16,6,42),(5,16,6,43),(5,16,6,44),(5,16,6,45),(3,16,6,51),(4,16,7,1),(4,16,7,2),(2,16,7,12),(5,16,7,41),(5,16,7,43),(5,16,7,44),(5,16,7,45),(5,16,7,46),(3,16,7,51),(3,16,8,10),(3,16,8,29),(8,16,8,30),(5,16,8,41),(5,16,8,42),(5,16,8,43),(5,16,8,44),(4,16,8,48),(4,16,8,49),(3,16,8,50),(3,16,8,51),(0,16,9,4),(3,16,9,10),(3,16,9,12),(6,16,9,25),(6,16,9,26),(6,16,9,27),(3,16,9,28),(3,16,9,29),(5,16,9,41),(5,16,9,43),(5,16,9,44),(4,16,9,48),(4,16,9,49),(4,16,9,50),(3,16,9,51),(3,16,10,9),(3,16,10,10),(3,16,10,11),(3,16,10,12),(14,16,10,15),(6,16,10,25),(6,16,10,26),(6,16,10,27),(6,16,10,28),(3,16,10,29),(8,16,10,39),(13,16,10,42),(3,16,10,44),(4,16,10,47),(4,16,10,48),(4,16,10,49),(4,16,10,50),(4,16,10,51),(3,16,11,8),(3,16,11,9),(3,16,11,10),(3,16,11,11),(3,16,11,12),(5,16,11,19),(5,16,11,20),(6,16,11,26),(6,16,11,27),(3,16,11,28),(3,16,11,29),(3,16,11,30),(3,16,11,31),(3,16,11,32),(3,16,11,33),(3,16,11,44),(3,16,11,45),(3,16,11,46),(3,16,11,47),(3,16,11,48),(4,16,11,49),(4,16,11,50),(4,16,11,51),(5,16,12,5),(5,16,12,6),(3,16,12,7),(3,16,12,8),(3,16,12,9),(0,16,12,10),(3,16,12,12),(3,16,12,13),(3,16,12,14),(5,16,12,19),(5,16,12,20),(5,16,12,21),(5,16,12,22),(6,16,12,27),(3,16,12,28),(3,16,12,29),(3,16,12,30),(3,16,12,31),(3,16,12,32),(3,16,12,44),(3,16,12,45),(3,16,12,46),(3,16,12,47),(0,16,12,48),(4,16,12,51),(5,16,13,5),(5,16,13,6),(5,16,13,7),(5,16,13,8),(3,16,13,12),(3,16,13,13),(5,16,13,14),(5,16,13,15),(5,16,13,17),(5,16,13,18),(5,16,13,19),(5,16,13,20),(5,16,13,21),(5,16,13,22),(5,16,13,23),(4,16,13,26),(6,16,13,27),(4,16,13,28),(3,16,13,29),(3,16,13,30),(3,16,13,31),(4,16,13,32),(4,16,13,33),(4,16,13,34),(3,16,13,44),(6,16,13,45),(3,16,13,46),(3,16,13,47),(4,16,13,50),(4,16,13,51),(0,16,14,1),(5,16,14,5),(5,16,14,6),(5,16,14,7),(5,16,14,8),(5,16,14,9),(5,16,14,10),(5,16,14,11),(5,16,14,13),(5,16,14,14),(5,16,14,15),(5,16,14,16),(5,16,14,17),(5,16,14,18),(5,16,14,20),(5,16,14,21),(5,16,14,22),(5,16,14,23),(4,16,14,26),(4,16,14,27),(4,16,14,28),(3,16,14,29),(3,16,14,30),(4,16,14,31),(4,16,14,32),(4,16,14,33),(4,16,14,34),(4,16,14,35),(3,16,14,44),(6,16,14,45),(3,16,14,46),(3,16,14,47),(4,16,14,48),(4,16,14,49),(4,16,14,50),(5,16,15,4),(5,16,15,5),(5,16,15,6),(5,16,15,7),(5,16,15,8),(5,16,15,9),(5,16,15,10),(5,16,15,11),(5,16,15,12),(5,16,15,13),(0,16,15,16),(5,16,15,18),(5,16,15,19),(5,16,15,20),(5,16,15,21),(5,16,15,22),(4,16,15,27),(4,16,15,28),(4,16,15,29),(4,16,15,30),(4,16,15,31),(4,16,15,32),(6,16,15,44),(6,16,15,45),(3,16,15,46),(3,16,15,47),(4,16,15,48),(4,16,15,49),(4,16,15,50),(4,16,15,51),(5,16,16,6),(5,16,16,7),(5,16,16,8),(5,16,16,9),(5,16,16,10),(5,16,16,11),(5,16,16,12),(5,16,16,13),(5,16,16,18),(5,16,16,19),(5,16,16,20),(5,16,16,21),(5,16,16,23),(4,16,16,27),(4,16,16,28),(4,16,16,29),(4,16,16,30),(4,16,16,31),(4,16,16,32),(6,16,16,43),(6,16,16,44),(6,16,16,45),(6,16,16,46),(3,16,16,47),(4,16,16,48),(4,16,16,49),(4,16,16,50),(5,16,17,7),(5,16,17,8),(5,16,17,9),(5,16,17,10),(5,16,17,11),(5,16,17,13),(5,16,17,18),(5,16,17,19),(5,16,17,20),(5,16,17,21),(5,16,17,22),(5,16,17,23),(4,16,17,27),(4,16,17,28),(4,16,17,29),(4,16,17,30),(4,16,17,31),(6,16,17,43),(6,16,17,44),(6,16,17,45),(4,16,17,46),(4,16,17,47),(4,16,17,48),(4,16,17,49),(8,23,0,1),(3,23,0,4),(3,23,0,5),(3,23,0,6),(3,23,0,7),(3,23,0,8),(3,23,0,9),(11,23,0,16),(4,23,0,27),(4,23,0,28),(4,23,0,29),(4,23,0,30),(4,23,0,31),(3,23,1,4),(3,23,1,5),(0,23,1,6),(3,23,1,9),(9,23,1,11),(4,23,1,29),(4,23,1,30),(4,23,1,31),(4,23,1,32),(6,23,2,4),(0,23,2,25),(4,23,2,29),(4,23,2,30),(4,23,2,31),(3,23,2,32),(6,23,2,33),(6,23,3,3),(6,23,3,4),(6,23,3,5),(6,23,3,6),(3,23,3,27),(4,23,3,31),(3,23,3,32),(6,23,3,33),(6,23,3,34),(6,23,3,35),(5,23,4,16),(5,23,4,17),(5,23,4,18),(5,23,4,19),(5,23,4,20),(5,23,4,21),(5,23,4,22),(4,23,4,25),(3,23,4,26),(3,23,4,27),(0,23,4,31),(6,23,4,34),(6,23,5,2),(5,23,5,7),(5,23,5,9),(5,23,5,10),(5,23,5,17),(5,23,5,19),(5,23,5,21),(4,23,5,25),(3,23,5,26),(3,23,5,27),(3,23,5,28),(3,23,5,29),(6,23,6,1),(6,23,6,2),(6,23,6,3),(5,23,6,7),(5,23,6,9),(5,23,6,10),(3,23,6,14),(1,23,6,17),(5,23,6,19),(5,23,6,21),(5,23,6,22),(4,23,6,24),(4,23,6,25),(4,23,6,26),(3,23,6,27),(3,23,6,29),(3,23,6,34),(6,23,7,1),(5,23,7,6),(5,23,7,7),(5,23,7,9),(5,23,7,10),(3,23,7,12),(3,23,7,13),(3,23,7,14),(3,23,7,15),(5,23,7,21),(5,23,7,22),(4,23,7,23),(4,23,7,24),(4,23,7,25),(4,23,7,26),(4,23,7,27),(3,23,7,33),(3,23,7,34),(5,23,8,5),(5,23,8,6),(5,23,8,7),(0,23,8,8),(5,23,8,10),(5,23,8,11),(3,23,8,12),(3,23,8,13),(3,23,8,14),(5,23,8,22),(4,23,8,23),(4,23,8,24),(4,23,8,25),(0,23,8,28),(3,23,8,32),(3,23,8,33),(3,23,8,34),(3,23,8,35),(2,23,9,4),(5,23,9,6),(5,23,9,10),(5,23,9,11),(3,23,9,12),(11,23,9,13),(3,23,9,33),(3,23,9,34),(0,23,9,35),(3,23,10,9),(3,23,10,10),(5,23,10,11),(5,23,10,12),(0,23,10,21),(4,23,10,28),(4,23,10,29),(4,23,10,30),(3,23,11,7),(3,23,11,8),(3,23,11,9),(3,23,11,10),(5,23,11,11),(5,23,11,12),(4,23,11,27),(4,23,11,28),(6,23,11,34),(6,23,11,35),(6,23,11,36),(3,23,12,7),(3,23,12,8),(3,23,12,9),(5,23,12,10),(5,23,12,11),(4,23,12,24),(4,23,12,25),(4,23,12,26),(4,23,12,27),(4,23,12,28),(4,23,12,29),(4,23,12,30),(4,23,12,31),(6,23,12,35),(6,23,12,36),(3,24,0,0),(3,24,0,1),(3,24,0,2),(3,24,0,4),(3,24,0,5),(3,24,0,6),(14,24,0,9),(12,24,0,23),(3,24,1,0),(3,24,1,1),(3,24,1,2),(3,24,1,3),(3,24,1,4),(3,24,2,0),(3,24,2,2),(3,24,2,3),(3,24,2,4),(3,24,2,6),(3,24,3,0),(3,24,3,1),(3,24,3,2),(3,24,3,3),(3,24,3,4),(3,24,3,5),(3,24,3,6),(0,24,3,14),(3,24,4,0),(3,24,4,1),(3,24,4,2),(3,24,4,3),(3,24,4,4),(0,24,4,5),(6,24,4,7),(3,24,4,12),(3,24,4,13),(3,24,4,17),(3,24,4,18),(3,24,4,19),(3,24,5,1),(3,24,5,2),(3,24,5,3),(6,24,5,7),(6,24,5,8),(3,24,5,12),(3,24,5,13),(3,24,5,14),(3,24,5,15),(3,24,5,16),(3,24,5,17),(3,24,5,18),(3,24,6,1),(3,24,6,2),(6,24,6,6),(6,24,6,7),(6,24,6,8),(6,24,6,9),(0,24,6,10),(3,24,6,12),(3,24,6,13),(3,24,6,14),(3,24,6,15),(3,24,6,16),(3,24,6,17),(3,24,6,18),(4,24,6,41),(4,24,6,42),(6,24,7,5),(6,24,7,6),(6,24,7,7),(3,24,7,12),(3,24,7,13),(3,24,7,14),(3,24,7,15),(3,24,7,16),(3,24,7,18),(4,24,7,39),(4,24,7,40),(4,24,7,41),(4,24,7,42),(5,24,8,3),(6,24,8,5),(6,24,8,6),(3,24,8,13),(3,24,8,15),(3,24,8,16),(3,24,8,17),(3,24,8,18),(4,24,8,22),(3,24,8,25),(6,24,8,34),(2,24,8,37),(4,24,8,39),(4,24,8,40),(4,24,8,41),(5,24,9,3),(6,24,9,5),(4,24,9,6),(3,24,9,17),(3,24,9,18),(4,24,9,19),(4,24,9,20),(4,24,9,21),(4,24,9,22),(4,24,9,23),(3,24,9,25),(6,24,9,34),(6,24,9,35),(5,24,9,39),(5,24,9,40),(4,24,9,41),(4,24,9,42),(5,24,10,0),(5,24,10,1),(5,24,10,2),(5,24,10,3),(5,24,10,4),(4,24,10,5),(4,24,10,6),(13,24,10,10),(3,24,10,17),(4,24,10,20),(4,24,10,21),(4,24,10,22),(3,24,10,24),(3,24,10,25),(3,24,10,26),(3,24,10,27),(6,24,10,32),(6,24,10,33),(6,24,10,34),(6,24,10,35),(6,24,10,36),(6,24,10,37),(5,24,10,38),(5,24,10,39),(5,24,10,40),(5,24,10,41),(5,24,10,42),(5,24,10,43),(5,24,11,0),(5,24,11,1),(5,24,11,2),(5,24,11,3),(5,24,11,4),(4,24,11,5),(4,24,11,6),(4,24,11,7),(4,24,11,8),(4,24,11,20),(4,24,11,21),(1,24,11,22),(3,24,11,26),(3,24,11,27),(6,24,11,33),(6,24,11,35),(6,24,11,36),(5,24,11,38),(5,24,11,39),(5,24,11,40),(5,24,11,41),(5,24,11,43),(5,24,12,0),(5,24,12,1),(5,24,12,2),(5,24,12,3),(4,24,12,5),(4,24,12,6),(4,24,12,7),(3,24,12,25),(3,24,12,26),(3,24,12,27),(1,24,12,31),(6,24,12,35),(6,24,12,36),(6,24,12,37),(5,24,12,39),(5,24,12,40),(5,24,12,41),(5,24,12,42),(5,24,13,0),(5,24,13,1),(5,24,13,2),(5,24,13,3),(4,24,13,7),(3,24,13,26),(3,24,13,27),(3,24,13,28),(6,24,13,34),(6,24,13,35),(6,24,13,36),(6,24,13,37),(6,24,13,38),(5,24,13,39),(5,24,13,40),(5,24,13,41),(5,24,13,42),(5,24,14,0),(5,24,14,1),(5,24,14,2),(5,24,14,3),(5,24,14,4),(5,24,14,5),(0,24,14,6),(3,24,14,25),(3,24,14,26),(3,24,14,27),(3,24,14,28),(6,24,14,34),(6,24,14,36),(4,24,14,37),(5,24,14,40),(5,24,14,41),(5,24,14,42),(5,24,14,43),(5,24,15,0),(5,24,15,1),(5,24,15,2),(5,24,15,3),(5,24,15,4),(5,24,15,5),(4,24,15,15),(4,24,15,16),(4,24,15,17),(4,24,15,18),(4,24,15,19),(4,24,15,20),(3,24,15,24),(3,24,15,25),(3,24,15,26),(3,24,15,27),(3,24,15,28),(3,24,15,29),(6,24,15,34),(6,24,15,35),(6,24,15,36),(4,24,15,37),(5,24,15,40),(5,24,15,41),(5,24,15,43),(5,24,15,44),(5,24,15,45),(5,24,16,0),(5,24,16,1),(5,24,16,2),(5,24,16,3),(5,24,16,4),(5,24,16,5),(5,24,16,6),(5,24,16,7),(5,24,16,10),(4,24,16,14),(4,24,16,15),(4,24,16,16),(4,24,16,17),(3,24,16,24),(3,24,16,25),(3,24,16,26),(0,24,16,29),(6,24,16,35),(4,24,16,36),(4,24,16,37),(4,24,16,38),(4,24,16,39),(5,24,17,0),(5,24,17,1),(5,24,17,2),(5,24,17,3),(5,24,17,4),(5,24,17,5),(5,24,17,6),(5,24,17,7),(5,24,17,8),(5,24,17,9),(5,24,17,10),(4,24,17,17),(3,24,17,24),(3,24,17,25),(3,24,17,26),(3,24,17,27),(4,24,17,35),(4,24,17,36),(4,24,17,38),(5,24,18,0),(5,24,18,1),(5,24,18,2),(5,24,18,3),(5,24,18,4),(5,24,18,5),(5,24,18,6),(5,24,18,7),(3,24,18,25),(3,24,18,27),(4,24,18,37),(4,24,18,38),(4,42,0,7),(4,42,0,8),(4,42,0,9),(4,42,0,15),(3,42,0,16),(3,42,0,17),(3,42,0,18),(3,42,0,19),(11,42,0,20),(4,42,1,7),(4,42,1,8),(4,42,1,9),(4,42,1,10),(4,42,1,15),(4,42,1,16),(3,42,1,17),(3,42,1,18),(4,42,1,19),(4,42,2,7),(4,42,2,8),(4,42,2,9),(4,42,2,10),(4,42,2,11),(4,42,2,13),(4,42,2,14),(4,42,2,15),(4,42,2,16),(3,42,2,17),(3,42,2,18),(4,42,2,19),(4,42,3,6),(4,42,3,7),(4,42,3,8),(4,42,3,9),(4,42,3,10),(4,42,3,12),(4,42,3,13),(4,42,3,14),(4,42,3,15),(4,42,3,16),(4,42,3,17),(4,42,3,18),(4,42,3,19),(4,42,4,5),(4,42,4,6),(4,42,4,7),(4,42,4,8),(4,42,4,9),(4,42,4,10),(4,42,4,13),(4,42,4,16),(4,42,4,17),(4,42,4,18),(4,42,4,19),(4,42,4,20),(4,42,4,21),(13,42,4,22),(4,42,5,6),(4,42,5,8),(4,42,5,9),(4,42,5,16),(4,42,5,18),(4,42,5,19),(4,42,5,20),(4,42,5,21),(4,42,6,4),(4,42,6,5),(4,42,6,6),(4,42,6,8),(4,42,6,9),(14,42,6,10),(4,42,6,16),(4,42,6,18),(4,42,6,20),(4,42,6,21),(5,42,7,2),(5,42,7,3),(5,42,7,4),(5,42,7,5),(4,42,7,8),(6,42,7,14),(6,42,7,15),(4,42,7,16),(4,42,7,17),(4,42,7,18),(4,42,7,20),(4,42,7,21),(5,42,8,2),(5,42,8,3),(5,42,8,4),(5,42,8,5),(5,42,8,6),(5,42,8,7),(4,42,8,8),(6,42,8,14),(6,42,8,15),(4,42,8,17),(4,42,8,20),(4,42,8,21),(4,42,8,24),(0,42,8,36),(5,42,9,2),(5,42,9,3),(5,42,9,4),(4,42,9,8),(6,42,9,14),(6,42,9,15),(6,42,9,16),(4,42,9,17),(4,42,9,18),(4,42,9,19),(4,42,9,20),(4,42,9,21),(4,42,9,24),(5,42,10,1),(5,42,10,2),(5,42,10,3),(5,42,10,4),(5,42,10,5),(4,42,10,9),(6,42,10,13),(6,42,10,14),(6,42,10,15),(6,42,10,16),(6,42,10,17),(4,42,10,18),(4,42,10,19),(4,42,10,20),(4,42,10,21),(4,42,10,22),(4,42,10,23),(4,42,10,24),(4,42,10,25),(6,42,10,29),(6,42,10,30),(6,42,10,31),(6,42,10,32),(6,42,10,33),(6,42,10,34),(6,42,10,35),(5,42,11,1),(5,42,11,2),(5,42,11,3),(5,42,11,4),(5,42,11,5),(4,42,11,7),(4,42,11,8),(4,42,11,9),(4,42,11,10),(9,42,11,12),(6,42,11,15),(6,42,11,16),(0,42,11,17),(4,42,11,19),(4,42,11,20),(4,42,11,21),(4,42,11,22),(4,42,11,23),(4,42,11,25),(4,42,11,26),(6,42,11,28),(6,42,11,29),(6,42,11,32),(6,42,11,33),(6,42,11,35),(5,42,12,0),(5,42,12,1),(5,42,12,2),(5,42,12,3),(5,42,12,4),(5,42,12,5),(4,42,12,6),(4,42,12,7),(4,42,12,8),(4,42,12,9),(4,42,12,10),(4,42,12,11),(6,42,12,15),(6,42,12,16),(4,42,12,21),(4,42,12,22),(10,42,12,26),(6,42,12,32),(6,42,12,33),(6,42,12,34),(5,42,13,1),(5,42,13,2),(5,42,13,3),(5,42,13,4),(5,42,13,5),(4,42,13,6),(4,42,13,7),(4,42,13,8),(4,42,13,9),(4,42,13,10),(6,42,13,15),(4,42,13,20),(4,42,13,21),(6,42,13,32),(6,42,13,33),(5,42,14,0),(5,42,14,1),(5,42,14,2),(5,42,14,3),(5,42,14,4),(4,42,14,5),(4,42,14,6),(4,42,14,7),(4,42,14,8),(4,42,14,9),(4,42,14,10),(4,42,14,11),(6,42,14,15),(4,42,14,21),(6,42,14,33),(5,42,15,3),(4,42,15,6),(4,42,15,7),(4,42,15,8),(4,42,15,9),(10,42,15,15),(1,42,15,36),(4,42,16,6),(4,42,16,7),(4,42,16,8),(4,42,16,9),(0,42,16,31),(4,42,17,5),(4,42,17,6),(4,42,17,8),(5,42,17,19),(3,42,17,29),(3,42,17,30),(5,42,18,19),(5,42,18,20),(5,42,18,22),(5,42,18,23),(3,42,18,30),(3,42,18,31),(3,42,18,34),(3,42,18,35),(5,42,19,18),(5,42,19,19),(5,42,19,20),(5,42,19,21),(5,42,19,22),(5,42,19,23),(13,42,19,24),(3,42,19,28),(3,42,19,29),(3,42,19,30),(3,42,19,31),(3,42,19,33),(3,42,19,34),(0,42,20,6),(5,42,20,18),(5,42,20,19),(5,42,20,20),(5,42,20,21),(5,42,20,23),(2,42,20,27),(3,42,20,29),(3,42,20,30),(3,42,20,31),(3,42,20,32),(3,42,20,33),(3,42,20,34),(3,42,20,35),(5,42,21,19),(3,42,21,31),(3,42,21,32),(3,42,21,33),(3,42,21,34),(3,42,21,37),(5,42,22,18),(5,42,22,19),(3,42,22,23),(3,42,22,32),(3,42,22,33),(3,42,22,34),(3,42,22,37),(5,42,23,18),(3,42,23,23),(3,42,23,32),(3,42,23,34),(3,42,23,35),(3,42,23,36),(3,42,23,37),(3,42,23,38),(3,42,24,19),(3,42,24,20),(3,42,24,21),(3,42,24,22),(3,42,24,23),(3,42,24,34),(3,42,24,35),(3,42,24,37),(3,42,25,15),(3,42,25,16),(3,42,25,19),(3,42,25,20),(3,42,25,22),(6,42,25,24),(3,42,25,29),(3,42,25,33),(3,42,25,34),(3,42,25,35),(3,42,25,36),(3,42,26,16),(3,42,26,17),(3,42,26,18),(3,42,26,19),(3,42,26,20),(0,42,26,21),(6,42,26,23),(6,42,26,24),(6,42,26,25),(6,42,26,26),(3,42,26,29),(1,42,26,31),(3,42,26,36),(3,42,26,37),(3,42,27,16),(3,42,27,17),(3,42,27,18),(3,42,27,19),(3,42,27,20),(6,42,27,23),(6,42,27,24),(6,42,27,25),(6,42,27,26),(3,42,27,28),(3,42,27,29),(3,42,27,30),(3,42,27,33),(3,42,27,36),(5,42,28,0),(5,42,28,1),(5,42,28,3),(9,42,28,6),(3,42,28,15),(3,42,28,16),(3,42,28,17),(3,42,28,18),(3,42,28,19),(3,42,28,20),(3,42,28,21),(3,42,28,22),(6,42,28,23),(6,42,28,24),(6,42,28,25),(0,42,28,26),(3,42,28,28),(3,42,28,29),(3,42,28,30),(3,42,28,31),(3,42,28,32),(3,42,28,33),(3,42,28,34),(5,42,29,0),(5,42,29,1),(5,42,29,2),(5,42,29,3),(5,42,29,4),(5,42,29,5),(3,42,29,17),(3,42,29,18),(3,42,29,19),(3,42,29,20),(3,42,29,21),(6,42,29,22),(6,42,29,23),(6,42,29,24),(6,42,29,25),(3,42,29,29),(3,42,29,30),(3,42,29,31),(3,42,29,33),(3,42,29,34),(5,42,30,0),(5,42,30,1),(5,42,30,2),(5,42,30,3),(5,42,30,4),(5,42,30,5),(3,42,30,16),(3,42,30,17),(3,42,30,18),(3,42,30,20),(3,42,30,21),(6,42,30,24),(6,42,30,25),(3,42,30,29),(3,42,30,30),(3,42,30,31),(3,42,30,32),(0,42,30,33),(5,42,31,0),(5,42,31,2),(5,42,31,9),(5,42,31,11),(0,42,31,12),(3,42,31,17),(3,42,31,18),(3,42,31,21),(11,42,31,22),(3,42,31,29),(3,42,31,30),(3,42,31,31),(3,42,31,32),(5,42,32,2),(5,42,32,7),(5,42,32,8),(5,42,32,9),(5,42,32,10),(5,42,32,11),(3,42,32,17),(3,42,32,29),(3,42,32,30),(3,42,32,31),(3,42,32,32),(5,42,33,2),(5,42,33,3),(5,42,33,6),(5,42,33,7),(5,42,33,8),(5,42,33,9),(5,42,33,10),(5,42,33,11),(5,42,33,12),(5,42,33,13),(3,42,33,29),(3,42,33,30),(3,42,33,31),(3,42,33,32),(3,42,33,33),(5,42,34,8),(5,42,34,9),(5,42,34,10),(5,42,34,11),(5,42,34,12),(3,42,34,29),(3,42,34,30),(3,42,34,31),(3,42,34,32),(3,42,34,33),(3,42,34,34),(3,42,34,35),(3,42,34,36),(3,42,34,37),(4,48,0,0),(4,48,0,1),(4,48,0,2),(4,48,0,3),(4,48,0,4),(4,48,0,5),(3,48,0,8),(3,48,0,9),(3,48,0,10),(4,48,0,15),(4,48,0,16),(4,48,0,17),(4,48,0,18),(13,48,0,21),(5,48,0,30),(3,48,0,33),(4,48,1,0),(4,48,1,1),(4,48,1,2),(4,48,1,3),(4,48,1,4),(4,48,1,5),(3,48,1,9),(3,48,1,10),(2,48,1,11),(4,48,1,14),(4,48,1,15),(4,48,1,16),(4,48,1,17),(5,48,1,28),(5,48,1,29),(5,48,1,30),(3,48,1,33),(4,48,2,0),(4,48,2,2),(3,48,2,8),(3,48,2,9),(3,48,2,10),(4,48,2,16),(4,48,2,17),(4,48,2,18),(0,48,2,24),(5,48,2,29),(5,48,2,30),(3,48,2,31),(3,48,2,32),(3,48,2,33),(4,48,3,0),(4,48,3,2),(3,48,3,8),(3,48,3,9),(3,48,3,10),(3,48,3,11),(4,48,3,16),(4,48,3,17),(4,48,3,18),(5,48,3,29),(0,48,3,30),(3,48,3,32),(3,48,3,33),(10,48,4,0),(9,48,4,4),(3,48,4,9),(3,48,4,10),(4,48,4,16),(3,48,4,32),(3,48,4,33),(11,48,5,7),(6,48,5,13),(6,48,5,14),(4,48,5,16),(3,48,5,29),(3,48,5,30),(3,48,5,31),(3,48,5,32),(3,48,5,33),(6,48,6,13),(6,48,6,14),(6,48,6,15),(6,48,6,24),(1,48,6,25),(5,48,6,30),(5,48,6,31),(6,48,7,14),(5,48,7,15),(5,48,7,16),(5,48,7,19),(1,48,7,20),(6,48,7,24),(5,48,7,30),(5,48,8,14),(5,48,8,15),(5,48,8,16),(5,48,8,18),(5,48,8,19),(6,48,8,24),(6,48,8,25),(6,48,8,26),(6,48,8,27),(5,48,8,29),(5,48,8,30),(5,48,8,31),(9,48,9,0),(5,48,9,14),(5,48,9,15),(0,48,9,16),(5,48,9,18),(5,48,9,19),(5,48,9,20),(5,48,9,21),(4,48,9,22),(4,48,9,23),(10,48,9,24),(5,48,9,30),(0,48,10,4),(5,48,10,18),(4,48,10,23),(0,48,10,29),(6,48,11,8),(5,48,11,17),(5,48,11,18),(5,48,11,19),(0,48,11,20),(4,48,11,22),(4,48,11,23),(6,48,12,7),(6,48,12,8),(6,48,12,9),(6,48,12,10),(6,48,12,11),(6,48,12,14),(6,48,12,15),(6,48,12,16),(6,48,12,17),(5,48,12,18),(5,48,12,19),(4,48,12,22),(4,48,12,23),(4,48,13,0),(4,48,13,1),(12,48,13,2),(12,48,13,8),(6,48,13,15),(5,48,13,19),(3,48,13,20),(3,48,13,21),(4,48,13,22),(4,48,13,23),(4,48,13,24),(4,48,14,0),(4,48,14,1),(6,48,14,15),(3,48,14,16),(3,48,14,17),(3,48,14,19),(3,48,14,20),(4,48,14,21),(4,48,14,22),(4,48,14,23),(0,48,14,24),(4,48,15,0),(4,48,15,1),(3,48,15,17),(3,48,15,18),(3,48,15,19),(0,48,15,20),(4,48,15,22),(11,48,15,28),(4,48,16,0),(4,48,16,1),(3,48,16,17),(3,48,16,18),(3,48,16,19),(4,48,16,22),(4,48,16,23),(4,48,17,0),(4,48,17,1),(3,48,17,16),(3,48,17,17),(4,48,18,0),(4,48,18,1);
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
) ENGINE=InnoDB AUTO_INCREMENT=352 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `units`
--

LOCK TABLES `units` WRITE;
/*!40000 ALTER TABLE `units` DISABLE KEYS */;
INSERT INTO `units` VALUES (1,4475,1,1,1,NULL,NULL,NULL,NULL,0,0,'Thor',0,3,112,NULL,1,0,0,0,0,0,0),(2,4475,1,1,1,NULL,NULL,NULL,NULL,0,0,'Thor',1,3,112,NULL,1,0,0,0,0,0,0),(3,2812,1,1,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,3,112,NULL,1,0,0,0,0,0,0),(4,2812,1,1,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,3,112,NULL,1,0,0,0,0,0,0),(5,2812,1,1,1,NULL,NULL,NULL,NULL,0,0,'Dirac',0,3,112,NULL,1,0,0,0,0,0,0),(6,125,1,1,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(7,125,1,1,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(8,90,1,1,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(9,125,1,1,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(10,125,1,1,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(11,125,1,1,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(12,125,1,1,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(13,90,1,2,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(14,125,1,2,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(15,125,1,2,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(16,90,1,2,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(17,125,1,2,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(18,125,1,2,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(19,125,1,2,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(20,125,1,2,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(21,125,1,3,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(22,125,1,3,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(23,125,1,3,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(24,125,1,3,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(25,125,1,3,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(26,125,1,3,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(27,125,1,4,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(28,125,1,4,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(29,90,1,4,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(30,125,1,4,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(31,125,1,4,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(32,125,1,4,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(33,125,1,4,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(34,125,1,5,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(35,125,1,5,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(36,125,1,5,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(37,125,1,5,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(38,125,1,5,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(39,125,1,5,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(40,125,1,6,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(41,125,1,6,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(42,125,1,6,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(43,125,1,6,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(44,125,1,6,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(45,125,1,6,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(46,90,1,7,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(47,125,1,7,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(48,125,1,7,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(49,90,1,7,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(50,125,1,7,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(51,125,1,7,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(52,125,1,7,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(53,125,1,7,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(54,125,1,8,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(55,125,1,8,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(56,125,1,8,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(57,125,1,8,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(58,125,1,8,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(59,125,1,8,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(60,125,1,9,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(61,125,1,9,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(62,125,1,9,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(63,125,1,9,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(64,125,1,9,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(65,125,1,9,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(66,90,1,10,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(67,125,1,10,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(68,125,1,10,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(69,90,1,10,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(70,125,1,10,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(71,125,1,10,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(72,125,1,10,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(73,125,1,10,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(74,90,1,11,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(75,125,1,11,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(76,125,1,11,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(77,90,1,11,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(78,125,1,11,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(79,125,1,11,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(80,125,1,11,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(81,125,1,11,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(82,125,1,15,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(83,125,1,15,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(84,125,1,15,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(85,125,1,15,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(86,90,1,15,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(87,125,1,15,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(88,125,1,15,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(89,125,1,15,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(90,125,1,15,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(91,90,1,19,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(92,125,1,19,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(93,90,1,19,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(94,125,1,19,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(95,125,1,19,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(96,90,1,19,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(97,125,1,19,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(98,90,1,19,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(99,125,1,19,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(100,90,1,19,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(101,125,1,19,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(102,125,1,19,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(103,125,1,19,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(104,125,1,19,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(105,26875,1,1,1,NULL,NULL,NULL,NULL,0,0,'Demosis',0,1,270,NULL,1,0,0,0,0,0,0),(106,26875,1,1,1,NULL,NULL,NULL,NULL,0,0,'Demosis',0,1,270,NULL,1,0,0,0,0,0,0),(107,26875,1,1,1,NULL,NULL,NULL,NULL,0,0,'Demosis',0,1,270,NULL,1,0,0,0,0,0,0),(108,4475,1,1,1,NULL,NULL,NULL,NULL,0,0,'Thor',0,1,270,NULL,1,0,0,0,0,0,0),(109,4475,1,1,1,NULL,NULL,NULL,NULL,0,0,'Thor',1,1,270,NULL,1,0,0,0,0,0,0),(110,2812,1,1,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,1,270,NULL,1,0,0,0,0,0,0),(111,2812,1,1,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,1,270,NULL,1,0,0,0,0,0,0),(112,2812,1,1,1,NULL,NULL,NULL,NULL,0,0,'Dirac',0,1,270,NULL,1,0,0,0,0,0,0),(113,90,1,23,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(114,125,1,23,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(115,90,1,23,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(116,125,1,23,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(117,125,1,23,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(118,90,1,24,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(119,125,1,24,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(120,90,1,24,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(121,125,1,24,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(122,125,1,24,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(123,125,1,25,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(124,90,1,25,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(125,125,1,25,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(126,125,1,25,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(127,90,1,25,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(128,125,1,25,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(129,125,1,25,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(130,90,1,26,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(131,125,1,26,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(132,125,1,26,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(133,90,1,27,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(134,125,1,27,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(135,125,1,27,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(136,125,1,28,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(137,125,1,28,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(138,125,1,29,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(139,125,1,29,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(140,125,1,30,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(141,125,1,30,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(142,4475,1,2,1,NULL,NULL,NULL,NULL,0,0,'Thor',1,2,120,NULL,1,0,0,0,0,0,0),(143,2812,1,2,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,2,120,NULL,1,0,0,0,0,0,0),(144,2812,1,2,1,NULL,NULL,NULL,NULL,0,0,'Dirac',0,2,120,NULL,1,0,0,0,0,0,0),(145,2812,1,2,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,1,315,NULL,1,0,0,0,0,0,0),(146,2812,1,2,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,1,315,NULL,1,0,0,0,0,0,0),(147,2812,1,2,1,NULL,NULL,NULL,NULL,0,0,'Dirac',0,1,315,NULL,1,0,0,0,0,0,0),(148,26875,1,2,1,NULL,NULL,NULL,NULL,0,0,'Demosis',0,1,0,NULL,1,0,0,0,0,0,0),(149,26875,1,2,1,NULL,NULL,NULL,NULL,0,0,'Demosis',0,1,0,NULL,1,0,0,0,0,0,0),(150,2812,1,2,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,1,0,NULL,1,0,0,0,0,0,0),(151,2812,1,2,1,NULL,NULL,NULL,NULL,0,0,'Dirac',0,1,0,NULL,1,0,0,0,0,0,0),(152,90,1,31,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(153,125,1,31,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(154,125,1,31,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(155,90,1,32,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(156,125,1,32,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(157,125,1,32,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(158,90,1,33,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(159,125,1,33,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(160,125,1,33,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(161,90,1,34,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(162,125,1,34,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(163,90,1,34,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(164,125,1,34,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(165,125,1,34,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(166,125,1,35,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(167,90,1,35,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(168,125,1,35,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(169,90,1,35,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(170,125,1,35,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(171,125,1,36,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(172,90,1,36,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(173,125,1,36,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(174,125,1,36,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(175,90,1,37,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(176,125,1,37,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(177,125,1,38,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(178,125,1,38,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(179,125,1,39,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(180,125,1,39,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(181,125,1,40,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(182,125,1,40,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(183,125,1,41,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(184,2812,1,2,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,0,0,NULL,1,0,0,0,0,0,0),(185,2812,1,2,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,0,0,NULL,1,0,0,0,0,0,0),(186,2812,1,2,1,NULL,NULL,NULL,NULL,0,0,'Dirac',0,0,0,NULL,1,0,0,0,0,0,0),(187,90,1,42,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(188,125,1,42,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(189,125,1,43,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(190,125,1,43,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(191,90,1,44,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(192,125,1,44,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(193,125,1,44,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(194,125,1,45,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(195,90,1,45,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(196,125,1,45,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(197,125,1,45,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(198,90,1,46,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(199,125,1,46,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(200,90,1,46,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(201,125,1,46,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(202,90,1,46,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(203,125,1,46,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(204,125,1,46,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(205,125,1,47,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(206,125,1,47,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(207,90,1,48,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(208,125,1,48,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(209,125,1,48,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(210,125,1,49,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(211,90,1,50,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(212,125,1,50,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(213,125,1,50,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(214,90,1,51,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(215,125,1,51,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(216,90,1,51,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(217,125,1,51,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(218,90,1,52,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(219,90,1,52,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(220,125,1,52,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(221,90,1,53,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(222,125,1,53,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(223,90,1,53,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(224,125,1,53,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(225,90,1,53,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(226,125,1,53,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(227,125,1,53,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(228,90,1,54,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(229,125,1,54,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(230,125,1,54,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(231,125,1,55,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(232,125,1,55,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(233,125,1,56,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(234,125,1,56,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(235,125,1,57,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(236,125,1,57,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(237,125,1,58,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(238,125,1,58,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(239,4475,1,3,1,NULL,NULL,NULL,NULL,0,0,'Thor',0,0,90,NULL,1,0,0,0,0,0,0),(240,2812,1,3,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,0,90,NULL,1,0,0,0,0,0,0),(241,2812,1,3,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,0,90,NULL,1,0,0,0,0,0,0),(242,2812,1,3,1,NULL,NULL,NULL,NULL,0,0,'Dirac',0,0,90,NULL,1,0,0,0,0,0,0),(243,26875,1,3,1,NULL,NULL,NULL,NULL,0,0,'Demosis',0,3,202,NULL,1,0,0,0,0,0,0),(244,4475,1,3,1,NULL,NULL,NULL,NULL,0,0,'Thor',1,3,202,NULL,1,0,0,0,0,0,0),(245,2812,1,3,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,3,202,NULL,1,0,0,0,0,0,0),(246,2812,1,3,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,3,202,NULL,1,0,0,0,0,0,0),(247,2812,1,3,1,NULL,NULL,NULL,NULL,0,0,'Dirac',0,3,202,NULL,1,0,0,0,0,0,0),(248,4475,1,3,1,NULL,NULL,NULL,NULL,0,0,'Thor',0,2,270,NULL,1,0,0,0,0,0,0),(249,4475,1,3,1,NULL,NULL,NULL,NULL,0,0,'Thor',1,2,270,NULL,1,0,0,0,0,0,0),(250,2812,1,3,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,2,270,NULL,1,0,0,0,0,0,0),(251,2812,1,3,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,2,270,NULL,1,0,0,0,0,0,0),(252,2812,1,3,1,NULL,NULL,NULL,NULL,0,0,'Dirac',0,2,270,NULL,1,0,0,0,0,0,0),(253,26875,1,3,1,NULL,NULL,NULL,NULL,0,0,'Demosis',0,3,224,NULL,1,0,0,0,0,0,0),(254,26875,1,3,1,NULL,NULL,NULL,NULL,0,0,'Demosis',0,3,224,NULL,1,0,0,0,0,0,0),(255,4475,1,3,1,NULL,NULL,NULL,NULL,0,0,'Thor',1,3,224,NULL,1,0,0,0,0,0,0),(256,2812,1,3,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,3,224,NULL,1,0,0,0,0,0,0),(257,2812,1,3,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,3,224,NULL,1,0,0,0,0,0,0),(258,2812,1,3,1,NULL,NULL,NULL,NULL,0,0,'Dirac',0,3,224,NULL,1,0,0,0,0,0,0),(259,26875,1,4,1,NULL,NULL,NULL,NULL,0,0,'Demosis',0,3,224,NULL,1,0,0,0,0,0,0),(260,26875,1,4,1,NULL,NULL,NULL,NULL,0,0,'Demosis',0,3,224,NULL,1,0,0,0,0,0,0),(261,26875,1,4,1,NULL,NULL,NULL,NULL,0,0,'Demosis',0,3,224,NULL,1,0,0,0,0,0,0),(262,4475,1,4,1,NULL,NULL,NULL,NULL,0,0,'Thor',0,3,224,NULL,1,0,0,0,0,0,0),(263,4475,1,4,1,NULL,NULL,NULL,NULL,0,0,'Thor',1,3,224,NULL,1,0,0,0,0,0,0),(264,2812,1,4,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,3,224,NULL,1,0,0,0,0,0,0),(265,2812,1,4,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,3,224,NULL,1,0,0,0,0,0,0),(266,2812,1,4,1,NULL,NULL,NULL,NULL,0,0,'Dirac',0,3,224,NULL,1,0,0,0,0,0,0),(267,90,1,59,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(268,125,1,59,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(269,125,1,59,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(270,90,1,60,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(271,125,1,60,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(272,125,1,60,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(273,90,1,61,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(274,125,1,61,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(275,125,1,61,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(276,90,1,62,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(277,125,1,62,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(278,125,1,62,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(279,90,1,63,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(280,125,1,63,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(281,90,1,63,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(282,125,1,63,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(283,125,1,63,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(284,90,1,64,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(285,125,1,64,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(286,90,1,64,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(287,125,1,64,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(288,125,1,64,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(289,90,1,65,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(290,90,1,65,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(291,125,1,65,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(292,90,1,65,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(293,125,1,65,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(294,125,1,65,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(295,125,1,66,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(296,90,1,66,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(297,125,1,66,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(298,90,1,66,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(299,90,1,66,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(300,125,1,66,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(301,90,1,66,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(302,125,1,66,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(303,90,1,67,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(304,125,1,67,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(305,90,1,67,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(306,125,1,67,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(307,90,1,67,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(308,125,1,67,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(309,125,1,67,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(310,90,1,68,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(311,125,1,68,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(312,125,1,68,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(313,125,1,69,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(314,125,1,69,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(315,125,1,70,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(316,125,1,70,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(317,125,1,71,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(318,125,1,71,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(319,90,1,72,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(320,125,1,72,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(321,90,1,73,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(322,125,1,73,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(323,90,1,74,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(324,125,1,74,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(325,125,1,74,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(326,90,1,75,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(327,125,1,75,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(328,90,1,76,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(329,90,1,76,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(330,125,1,76,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(331,125,1,76,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(332,125,1,77,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(333,125,1,77,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(334,125,1,77,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(335,90,1,78,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(336,125,1,78,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(337,90,1,78,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(338,125,1,78,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(339,125,1,78,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(340,125,1,79,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(341,125,1,79,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(342,125,1,80,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(343,125,1,80,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(344,125,1,81,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(345,26875,1,4,1,NULL,NULL,NULL,NULL,0,0,'Demosis',0,0,0,NULL,1,0,0,0,0,0,0),(346,26875,1,4,1,NULL,NULL,NULL,NULL,0,0,'Demosis',0,0,0,NULL,1,0,0,0,0,0,0),(347,26875,1,4,1,NULL,NULL,NULL,NULL,0,0,'Demosis',0,0,0,NULL,1,0,0,0,0,0,0),(348,4475,1,4,1,NULL,NULL,NULL,NULL,0,0,'Thor',0,0,0,NULL,1,0,0,0,0,0,0),(349,4475,1,4,1,NULL,NULL,NULL,NULL,0,0,'Thor',1,0,0,NULL,1,0,0,0,0,0,0),(350,2812,1,4,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,0,0,NULL,1,0,0,0,0,0,0),(351,2812,1,4,1,NULL,NULL,NULL,NULL,0,0,'Dirac',0,0,0,NULL,1,0,0,0,0,0,0);
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

-- Dump completed on 2011-01-03 22:05:13
