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
  `cooldown_ends_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `tiles_taken` (`planet_id`,`x`,`y`,`x_end`,`y_end`),
  KEY `index_buildings_on_construction_ends` (`upgrade_ends_at`),
  KEY `buildings_by_type` (`planet_id`,`type`),
  CONSTRAINT `buildings_ibfk_1` FOREIGN KEY (`planet_id`) REFERENCES `ss_objects` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=68 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `buildings`
--

LOCK TABLES `buildings` WRITE;
/*!40000 ALTER TABLE `buildings` DISABLE KEYS */;
INSERT INTO `buildings` VALUES (1,1,2,3,0,0,0,1,'NpcTankFactory',NULL,5,6,NULL,1,200000,NULL,0,NULL,NULL,0,NULL),(2,1,13,4,0,0,0,1,'NpcSpaceFactory',NULL,16,8,NULL,1,450000,NULL,0,NULL,NULL,0,NULL),(3,1,10,7,0,0,0,1,'NpcHall',NULL,11,8,NULL,1,145000,NULL,0,NULL,NULL,0,NULL),(4,1,5,9,0,0,0,1,'NpcInfantryFactory',NULL,7,11,NULL,1,60000,NULL,0,NULL,NULL,0,NULL),(5,4,2,2,0,0,0,1,'NpcSpaceFactory',NULL,5,6,NULL,1,450000,NULL,0,NULL,NULL,0,NULL),(6,4,6,8,0,0,0,1,'NpcHall',NULL,7,9,NULL,1,145000,NULL,0,NULL,NULL,0,NULL),(7,4,1,10,0,0,0,1,'NpcInfantryFactory',NULL,3,12,NULL,1,60000,NULL,0,NULL,NULL,0,NULL),(8,4,10,11,0,0,0,1,'NpcTankFactory',NULL,13,14,NULL,1,200000,NULL,0,NULL,NULL,0,NULL),(9,5,6,5,0,0,0,1,'NpcInfantryFactory',NULL,8,7,NULL,1,60000,NULL,0,NULL,NULL,0,NULL),(10,5,10,8,0,0,0,1,'NpcHall',NULL,11,9,NULL,1,145000,NULL,0,NULL,NULL,0,NULL),(11,5,2,11,0,0,0,1,'NpcTankFactory',NULL,5,14,NULL,1,200000,NULL,0,NULL,NULL,0,NULL),(12,5,14,11,0,0,0,1,'NpcSpaceFactory',NULL,17,15,NULL,1,450000,NULL,0,NULL,NULL,0,NULL),(13,13,22,8,0,0,0,1,'NpcMetalExtractor',NULL,23,9,NULL,1,400,NULL,0,NULL,NULL,0,NULL),(14,13,25,13,0,0,0,1,'NpcMetalExtractor',NULL,26,14,NULL,1,400,NULL,0,NULL,NULL,0,NULL),(15,13,26,32,0,0,0,1,'NpcGeothermalPlant',NULL,27,33,NULL,1,600,NULL,0,NULL,NULL,0,NULL),(16,13,9,29,0,0,0,1,'NpcGeothermalPlant',NULL,10,30,NULL,1,600,NULL,0,NULL,NULL,0,NULL),(17,13,8,23,0,0,0,1,'NpcZetiumExtractor',NULL,9,24,NULL,1,1600,NULL,0,NULL,NULL,0,NULL),(18,13,13,22,0,0,0,1,'NpcZetiumExtractor',NULL,14,23,NULL,1,1600,NULL,0,NULL,NULL,0,NULL),(19,13,24,22,0,0,0,1,'NpcJumpgate',NULL,28,26,NULL,1,8000,NULL,0,NULL,NULL,0,NULL),(20,13,18,24,0,0,0,1,'NpcJumpgate',NULL,22,28,NULL,1,8000,NULL,0,NULL,NULL,0,NULL),(21,13,7,17,0,0,0,1,'NpcResearchCenter',NULL,10,20,NULL,1,4000,NULL,0,NULL,NULL,0,NULL),(22,13,16,31,0,0,0,1,'NpcExcavationSite',NULL,19,34,NULL,1,3000,NULL,0,NULL,NULL,0,NULL),(23,13,10,26,0,0,0,1,'NpcCommunicationsHub',NULL,13,27,NULL,1,1200,NULL,0,NULL,NULL,0,NULL),(24,13,31,8,0,0,0,1,'NpcTemple',NULL,33,10,NULL,1,2500,NULL,0,NULL,NULL,0,NULL),(25,13,9,8,0,0,0,1,'NpcCommunicationsHub',NULL,12,9,NULL,1,1200,NULL,0,NULL,NULL,0,NULL),(26,13,8,26,0,0,0,1,'NpcSolarPlant',NULL,9,27,NULL,1,1000,NULL,0,NULL,NULL,0,NULL),(27,13,11,6,0,0,0,1,'NpcSolarPlant',NULL,12,7,NULL,1,1000,NULL,0,NULL,NULL,0,NULL),(28,13,24,29,0,0,0,1,'NpcSolarPlant',NULL,25,30,NULL,1,1000,NULL,0,NULL,NULL,0,NULL),(29,13,16,29,0,0,0,1,'NpcSolarPlant',NULL,17,30,NULL,1,1000,NULL,0,NULL,NULL,0,NULL),(30,15,0,0,0,0,0,1,'NpcMetalExtractor',NULL,1,1,NULL,1,400,NULL,0,NULL,NULL,0,NULL),(31,15,7,0,0,0,0,1,'NpcCommunicationsHub',NULL,10,1,NULL,1,1200,NULL,0,NULL,NULL,0,NULL),(32,15,18,0,0,0,0,1,'NpcSolarPlant',NULL,19,1,NULL,1,1000,NULL,0,NULL,NULL,0,NULL),(33,15,3,1,0,0,0,1,'NpcMetalExtractor',NULL,4,2,NULL,1,400,NULL,0,NULL,NULL,0,NULL),(34,15,12,1,0,0,0,1,'NpcSolarPlant',NULL,13,2,NULL,1,1000,NULL,0,NULL,NULL,0,NULL),(35,15,22,1,0,0,0,1,'NpcSolarPlant',NULL,23,2,NULL,1,1000,NULL,0,NULL,NULL,0,NULL),(36,15,26,1,0,0,0,1,'NpcCommunicationsHub',NULL,29,2,NULL,1,1200,NULL,0,NULL,NULL,0,NULL),(37,15,15,3,0,0,0,1,'NpcSolarPlant',NULL,16,4,NULL,1,1000,NULL,0,NULL,NULL,0,NULL),(38,15,18,3,0,0,0,1,'NpcSolarPlant',NULL,19,4,NULL,1,1000,NULL,0,NULL,NULL,0,NULL),(39,15,24,4,0,0,0,1,'NpcMetalExtractor',NULL,25,5,NULL,1,400,NULL,0,NULL,NULL,0,NULL),(40,15,28,4,0,0,0,1,'NpcMetalExtractor',NULL,29,5,NULL,1,400,NULL,0,NULL,NULL,0,NULL),(41,15,9,8,0,0,0,1,'Vulcan',NULL,10,9,NULL,1,2000,NULL,0,NULL,NULL,0,NULL),(42,15,11,8,0,0,0,1,'Screamer',NULL,12,9,NULL,1,2600,NULL,0,NULL,NULL,0,NULL),(43,15,13,8,0,0,0,1,'Thunder',NULL,14,9,NULL,1,4000,NULL,0,NULL,NULL,0,NULL),(44,15,15,8,0,0,0,1,'Vulcan',NULL,16,9,NULL,1,2000,NULL,0,NULL,NULL,0,NULL),(45,15,17,8,0,0,0,1,'Screamer',NULL,18,9,NULL,1,2600,NULL,0,NULL,NULL,0,NULL),(46,15,19,8,0,0,0,1,'Thunder',NULL,20,9,NULL,1,4000,NULL,0,NULL,NULL,0,NULL),(47,15,25,8,0,0,0,1,'NpcCommunicationsHub',NULL,28,9,NULL,1,1200,NULL,0,NULL,NULL,0,NULL),(48,15,9,10,0,0,0,1,'Thunder',NULL,10,11,NULL,1,4000,NULL,0,NULL,NULL,0,NULL),(49,15,11,10,0,0,0,1,'Mothership',NULL,18,15,NULL,1,10500,NULL,0,NULL,NULL,0,NULL),(50,15,19,10,0,0,0,1,'Vulcan',NULL,20,11,NULL,1,2000,NULL,0,NULL,NULL,0,NULL),(51,15,9,12,0,0,0,1,'Screamer',NULL,10,13,NULL,1,2600,NULL,0,NULL,NULL,0,NULL),(52,15,19,12,0,0,0,1,'Screamer',NULL,20,13,NULL,1,2600,NULL,0,NULL,NULL,0,NULL),(53,15,26,12,0,0,0,1,'NpcZetiumExtractor',NULL,27,13,NULL,1,1600,NULL,0,NULL,NULL,0,NULL),(54,15,9,14,0,0,0,1,'Vulcan',NULL,10,15,NULL,1,2000,NULL,0,NULL,NULL,0,NULL),(55,15,19,14,0,0,0,1,'Thunder',NULL,20,15,NULL,1,4000,NULL,0,NULL,NULL,0,NULL),(56,15,9,16,0,0,0,1,'Thunder',NULL,10,17,NULL,1,4000,NULL,0,NULL,NULL,0,NULL),(57,15,11,16,0,0,0,1,'Vulcan',NULL,12,17,NULL,1,2000,NULL,0,NULL,NULL,0,NULL),(58,15,13,16,0,0,0,1,'Thunder',NULL,14,17,NULL,1,4000,NULL,0,NULL,NULL,0,NULL),(59,15,15,16,0,0,0,1,'Screamer',NULL,16,17,NULL,1,2600,NULL,0,NULL,NULL,0,NULL),(60,15,17,16,0,0,0,1,'Thunder',NULL,18,17,NULL,1,4000,NULL,0,NULL,NULL,0,NULL),(61,15,19,16,0,0,0,1,'Vulcan',NULL,20,17,NULL,1,2000,NULL,0,NULL,NULL,0,NULL),(62,15,13,26,0,0,0,1,'NpcSolarPlant',NULL,14,27,NULL,1,1000,NULL,0,NULL,NULL,0,NULL),(63,15,20,27,0,0,0,1,'NpcSolarPlant',NULL,21,28,NULL,1,1000,NULL,0,NULL,NULL,0,NULL),(64,15,0,28,0,0,0,1,'NpcSolarPlant',NULL,1,29,NULL,1,1000,NULL,0,NULL,NULL,0,NULL),(65,15,3,28,0,0,0,1,'NpcSolarPlant',NULL,4,29,NULL,1,1000,NULL,0,NULL,NULL,0,NULL),(66,15,17,28,0,0,0,1,'NpcZetiumExtractor',NULL,18,29,NULL,1,1600,NULL,0,NULL,NULL,0,NULL),(67,15,28,28,0,0,0,1,'NpcSolarPlant',NULL,29,29,NULL,1,1000,NULL,0,NULL,NULL,0,NULL);
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
INSERT INTO `folliages` VALUES (1,0,0,8),(1,0,1,4),(1,0,5,13),(1,0,7,4),(1,1,2,13),(1,1,4,8),(1,1,12,13),(1,3,2,2),(1,3,9,1),(1,3,10,3),(1,3,11,12),(1,4,7,0),(1,4,10,5),(1,5,2,11),(1,6,5,2),(1,7,2,0),(1,8,12,9),(1,9,0,9),(1,9,6,7),(1,9,12,5),(1,10,0,11),(1,10,2,2),(1,10,6,6),(1,11,9,10),(1,12,3,8),(1,12,6,13),(1,12,7,7),(1,13,0,6),(1,13,9,1),(1,13,11,4),(1,16,0,10),(1,16,9,11),(1,17,7,9),(1,17,12,5),(1,18,5,11),(1,18,7,9),(1,18,8,5),(1,18,12,0),(1,19,4,1),(1,20,4,5),(1,20,9,5),(1,20,10,7),(1,21,3,9),(1,21,11,0),(1,22,0,7),(1,22,2,0),(4,0,0,11),(4,0,2,0),(4,0,3,2),(4,0,6,8),(4,0,7,4),(4,0,9,11),(4,0,11,8),(4,1,8,1),(4,2,0,8),(4,4,1,4),(4,4,7,7),(4,4,13,1),(4,5,9,12),(4,5,14,6),(4,6,2,3),(4,6,5,7),(4,6,7,7),(4,6,14,0),(4,7,3,9),(4,8,8,1),(4,8,10,6),(4,9,14,11),(4,11,10,4),(4,13,7,5),(4,14,10,4),(5,0,2,1),(5,0,16,4),(5,1,6,7),(5,2,2,11),(5,3,7,10),(5,4,6,13),(5,5,2,1),(5,5,4,7),(5,5,6,5),(5,5,8,13),(5,5,10,8),(5,6,0,13),(5,6,8,7),(5,6,12,12),(5,7,10,4),(5,7,15,13),(5,8,9,6),(5,8,10,5),(5,8,15,3),(5,10,7,13),(5,10,11,5),(5,10,16,2),(5,11,0,13),(5,11,2,0),(5,11,5,6),(5,11,10,11),(5,11,15,8),(5,12,2,3),(5,12,10,9),(5,12,12,2),(5,13,0,1),(5,13,4,8),(5,13,7,6),(5,13,16,8),(5,15,6,1),(5,17,9,13),(5,17,16,0),(5,18,6,11),(5,18,12,5),(5,19,8,9),(5,20,2,8),(5,20,6,4),(5,20,7,8),(5,20,8,7),(13,0,10,9),(13,0,22,5),(13,1,5,1),(13,1,8,2),(13,1,11,2),(13,1,14,9),(13,1,15,8),(13,1,19,0),(13,1,21,1),(13,1,23,0),(13,2,4,5),(13,2,7,13),(13,2,14,8),(13,2,19,8),(13,3,16,2),(13,3,24,10),(13,4,7,1),(13,4,8,1),(13,4,15,1),(13,4,23,6),(13,4,25,10),(13,5,6,7),(13,5,8,1),(13,5,17,6),(13,5,23,2),(13,5,25,7),(13,5,31,6),(13,6,3,8),(13,6,5,6),(13,6,12,12),(13,6,16,6),(13,7,2,3),(13,7,7,3),(13,7,8,3),(13,7,12,7),(13,7,13,6),(13,7,29,0),(13,7,30,10),(13,8,11,8),(13,8,13,3),(13,8,29,10),(13,9,3,13),(13,9,4,6),(13,9,5,2),(13,9,12,6),(13,10,1,4),(13,10,12,4),(13,10,21,5),(13,10,25,1),(13,11,4,11),(13,11,5,5),(13,11,22,5),(13,11,23,10),(13,11,25,9),(13,12,2,5),(13,12,5,5),(13,12,16,9),(13,12,28,3),(13,12,29,7),(13,13,5,7),(13,13,6,1),(13,13,9,9),(13,13,10,3),(13,13,12,10),(13,13,13,8),(13,13,21,7),(13,13,24,4),(13,14,0,11),(13,14,2,3),(13,14,24,11),(13,14,31,2),(13,14,32,8),(13,15,1,6),(13,15,6,7),(13,15,14,5),(13,15,18,4),(13,15,28,1),(13,15,29,9),(13,15,32,7),(13,15,33,9),(13,16,8,5),(13,16,10,10),(13,16,14,6),(13,16,19,4),(13,16,25,5),(13,17,5,6),(13,17,10,13),(13,17,12,4),(13,17,17,7),(13,17,18,8),(13,17,19,5),(13,19,2,1),(13,19,3,7),(13,19,6,8),(13,19,10,1),(13,19,11,3),(13,19,18,4),(13,20,11,6),(13,20,32,8),(13,20,34,3),(13,21,1,11),(13,21,34,3),(13,22,11,9),(13,22,16,11),(13,22,29,8),(13,22,31,1),(13,22,33,10),(13,22,35,8),(13,23,10,5),(13,23,29,10),(13,23,35,5),(13,24,8,2),(13,24,10,4),(13,24,31,8),(13,24,32,6),(13,25,3,4),(13,25,9,1),(13,25,12,5),(13,26,7,0),(13,26,11,9),(13,26,29,6),(13,26,35,13),(13,27,27,10),(13,27,30,9),(13,27,35,8),(13,28,8,2),(13,28,12,7),(13,29,5,1),(13,29,6,6),(13,29,7,4),(13,29,9,5),(13,29,26,10),(13,29,28,10),(13,30,15,5),(13,30,27,5),(13,30,35,5),(13,31,0,8),(13,31,29,2),(13,31,30,11),(13,32,18,7),(13,32,22,0),(13,32,24,8),(13,33,27,5),(13,33,28,11),(13,33,32,8),(15,0,16,8),(15,0,17,7),(15,0,23,3),(15,1,15,7),(15,2,0,4),(15,2,19,12),(15,3,25,13),(15,4,24,11),(15,5,0,8),(15,5,4,5),(15,5,13,13),(15,5,15,3),(15,5,28,0),(15,6,0,3),(15,6,5,2),(15,6,15,1),(15,6,24,3),(15,7,14,8),(15,7,19,9),(15,8,3,4),(15,8,7,0),(15,8,15,4),(15,8,22,6),(15,9,6,9),(15,9,19,13),(15,11,22,2),(15,12,19,4),(15,12,29,3),(15,13,19,0),(15,14,18,8),(15,14,20,7),(15,14,24,13),(15,15,20,7),(15,15,27,1),(15,16,7,5),(15,16,19,11),(15,16,24,6),(15,16,28,9),(15,17,5,2),(15,17,18,10),(15,17,19,10),(15,17,21,13),(15,17,22,3),(15,18,7,11),(15,18,20,1),(15,18,21,1),(15,18,26,3),(15,18,27,5),(15,19,18,13),(15,19,20,9),(15,19,25,9),(15,20,18,2),(15,21,6,13),(15,21,12,12),(15,21,17,2),(15,21,18,0),(15,21,23,5),(15,21,25,5),(15,21,26,4),(15,22,3,11),(15,22,7,7),(15,22,10,3),(15,22,16,10),(15,22,17,6),(15,22,18,7),(15,22,21,5),(15,22,24,12),(15,23,4,0),(15,23,5,10),(15,23,10,11),(15,23,12,7),(15,23,14,4),(15,23,18,1),(15,23,21,7),(15,23,22,11),(15,24,0,7),(15,24,15,5),(15,24,22,2),(15,25,20,10),(15,25,22,6),(15,25,24,0),(15,25,28,1),(15,26,0,5),(15,26,4,7),(15,26,5,13),(15,26,11,2),(15,26,14,0),(15,26,19,11),(15,26,20,5),(15,26,26,9),(15,27,3,9),(15,27,16,12),(15,27,28,4),(15,27,29,13),(15,28,3,5),(15,28,12,7),(15,28,14,6),(15,29,0,5),(15,29,6,7);
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
INSERT INTO `fow_ss_entries` VALUES (1,2,1,1,1,0,0,0,NULL,NULL,NULL,NULL,NULL);
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
INSERT INTO `galaxies` VALUES (1,'2011-03-01 13:50:27','dev');
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
  `victory_points` mediumint(8) unsigned NOT NULL DEFAULT '0',
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
INSERT INTO `players` VALUES (1,1,'0000000000000000000000000000000000000000000000000000000000000000','Test Player',18,18,NULL,0,0,1,0,0,0,1,NULL,0);
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
) ENGINE=InnoDB AUTO_INCREMENT=35 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `quests`
--

LOCK TABLES `quests` WRITE;
/*!40000 ALTER TABLE `quests` DISABLE KEYS */;
INSERT INTO `quests` VALUES (1,NULL,'{\"metal\":25.2,\"energy\":96.0}','Constructing Buildings'),(2,1,'{\"metal\":69.3,\"energy\":140.8}','Extracting Metal'),(3,2,'{\"metal\":2712.0,\"energy\":5424.0}',NULL),(4,3,'{\"metal\":412.5,\"energy\":920.7}','Upgrading Buildings'),(5,4,'{\"metal\":401.4,\"zetium\":10.8,\"points\":4000}',NULL),(6,3,'{\"metal\":949.2,\"energy\":1898.4,\"zetium\":16.2,\"units\":[{\"level\":1,\"type\":\"Trooper\",\"count\":4,\"hp\":100}]}',NULL),(7,6,'{\"metal\":723.2,\"energy\":1446.4,\"zetium\":16.2}','Building Units'),(8,6,'{\"metal\":1865.6,\"energy\":4134.9,\"zetium\":866.8,\"units\":[{\"level\":2,\"type\":\"Trooper\",\"count\":2,\"hp\":50},{\"level\":3,\"type\":\"Trooper\",\"count\":1,\"hp\":30}]}','Attacking NPC Buildings'),(9,32,'{\"metal\":862.8,\"energy\":4101.6,\"zetium\":16.2,\"points\":2000}',NULL),(10,8,'{\"metal\":1725.6,\"energy\":2461.2,\"zetium\":16.2,\"points\":2000}',NULL),(11,8,'{\"metal\":1853.2,\"energy\":3706.4,\"units\":[{\"level\":1,\"type\":\"Trooper\",\"count\":4,\"hp\":100},{\"level\":1,\"type\":\"Seeker\",\"count\":2,\"hp\":100}]}',NULL),(12,11,'{\"metal\":1374.5,\"energy\":2747.6,\"points\":2000}','Researching Technologies'),(13,12,'{\"metal\":692.55,\"energy\":1384.15,\"zetium\":12.35,\"points\":2000}',NULL),(14,11,'{\"metal\":595.2,\"energy\":1814.4}',NULL),(15,14,'{\"metal\":3475.0,\"energy\":3149.2,\"zetium\":284.4}','Extracting Zetium'),(16,15,'{\"units\":[{\"level\":3,\"type\":\"Trooper\",\"count\":1,\"hp\":100},{\"level\":2,\"type\":\"Seeker\",\"count\":1,\"hp\":100},{\"level\":1,\"type\":\"Shocker\",\"count\":3,\"hp\":100}]}','Collecting Points'),(17,15,'{\"metal\":9225.6,\"energy\":12915.6,\"zetium\":646.8}',NULL),(18,17,'{\"metal\":15375.2,\"energy\":21525.6,\"zetium\":1076.8}',NULL),(19,18,'{\"metal\":16144.8,\"energy\":22604.4,\"zetium\":1134.0,\"units\":[{\"level\":1,\"type\":\"Crow\",\"count\":4,\"hp\":100}]}',NULL),(20,19,'{\"units\":[{\"level\":1,\"type\":\"Mule\",\"count\":1,\"hp\":100},{\"level\":1,\"type\":\"Mdh\",\"count\":1,\"hp\":100}]}','Annexing Planets'),(21,20,'{\"metal\":1158.5844,\"energy\":2560.7376,\"zetium\":117.99765}','Colonizing Planets'),(22,3,'{\"units\":[{\"level\":1,\"type\":\"Gnat\",\"count\":1,\"hp\":25}],\"points\":200}','Exploring Objects'),(23,22,'{\"units\":[{\"level\":1,\"type\":\"Glancer\",\"count\":1,\"hp\":60}],\"points\":1000}',NULL),(24,11,'{\"units\":[{\"level\":1,\"type\":\"Gnat\",\"count\":2,\"hp\":25},{\"level\":1,\"type\":\"Gnat\",\"count\":2,\"hp\":20},{\"level\":1,\"type\":\"Gnat\",\"count\":2,\"hp\":15},{\"level\":1,\"type\":\"Gnat\",\"count\":2,\"hp\":10}],\"points\":800}',NULL),(25,24,'{\"units\":[{\"level\":1,\"type\":\"Glancer\",\"count\":2,\"hp\":80}],\"points\":800}',NULL),(26,25,'{\"units\":[{\"level\":1,\"type\":\"Spudder\",\"count\":1,\"hp\":96}],\"points\":1600}',NULL),(27,11,'{\"metal\":5940.0,\"energy\":18144.0}','Zetium Crystals'),(28,16,'{\"units\":[{\"level\":2,\"type\":\"Scorpion\",\"count\":2,\"hp\":70},{\"level\":1,\"type\":\"Azure\",\"count\":1,\"hp\":100}]}',NULL),(29,28,'{\"units\":[{\"level\":2,\"type\":\"Cyrix\",\"count\":2,\"hp\":60},{\"level\":1,\"type\":\"Crow\",\"count\":4,\"hp\":100}]}',NULL),(30,29,'{\"units\":[{\"level\":1,\"type\":\"Avenger\",\"count\":4,\"hp\":100},{\"level\":1,\"type\":\"Dart\",\"count\":4,\"hp\":100}]}',NULL),(31,19,'{\"metal\":23064,\"energy\":32292,\"zetium\":1620}','Fighting in Space'),(32,8,'{\"metal\":150.0,\"energy\":627.6,\"points\":2000}',NULL),(33,30,'{\"units\":[{\"level\":1,\"type\":\"Rhyno\",\"count\":1,\"hp\":100},{\"level\":1,\"type\":\"Cyrix\",\"count\":3,\"hp\":100}]}',NULL),(34,21,'{\"metal\":3862.4,\"energy\":25625.92,\"zetium\":524.8}','Exploring Galaxy');
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
INSERT INTO `schema_migrations` VALUES ('20090601175224'),('20090601184051'),('20090601184055'),('20090601184059'),('20090701164131'),('20090713165021'),('20090808144214'),('20090809160211'),('20090810173759'),('20090826140238'),('20090826141836'),('20090829202538'),('20090829210029'),('20090829224505'),('20090830143959'),('20090830145319'),('20090901153809'),('20090904190655'),('20090905175341'),('20090905192056'),('20090906135044'),('20090909222719'),('20090911180950'),('20090912165229'),('20090919155819'),('20091024222359'),('20091103164416'),('20091103180558'),('20091103181146'),('20091109191211'),('20091225193714'),('20100114152902'),('20100121142414'),('20100127115341'),('20100127120219'),('20100127120515'),('20100127121337'),('20100129150736'),('20100203202757'),('20100203204803'),('20100204172507'),('20100204173714'),('20100208163239'),('20100210114531'),('20100212134334'),('20100218181507'),('20100219114448'),('20100220144106'),('20100222144003'),('20100223153023'),('20100224153728'),('20100224163525'),('20100225124928'),('20100225153721'),('20100225155505'),('20100225155739'),('20100226122144'),('20100226122651'),('20100301153626'),('20100302131225'),('20100303131706'),('20100308163148'),('20100308164422'),('20100310172315'),('20100310181338'),('20100311123523'),('20100315112858'),('20100319141401'),('20100322184529'),('20100324134243'),('20100324141652'),('20100331125702'),('20100415130556'),('20100415130600'),('20100415130605'),('20100415134627'),('20100419141518'),('20100419142018'),('20100419164230'),('20100426141509'),('20100428130912'),('20100429171200'),('20100430174140'),('20100610151652'),('20100610180750'),('20100614142225'),('20100614160819'),('20100614162423'),('20100616132525'),('20100616135507'),('20100622124252'),('20100706105523'),('20100710121447'),('20100710191351'),('20100716155807'),('20100719131622'),('20100721155359'),('20100722124307'),('20100812164444'),('20100812164449'),('20100812164518'),('20100812164524'),('20100817165213'),('20100819175736'),('20100820185846'),('20100906095758'),('20100915145823'),('20100929111549'),('20101001155323'),('20101005180058'),('20101022155620'),('20101117131430'),('20101208135417'),('20101209122838'),('20101222150446'),('20101223125157'),('20101223172333'),('20110106110617'),('20110117182616'),('20110119121807'),('20110125161025'),('20110128094012'),('20110201122224'),('20110211124612'),('20110214130700'),('20110214165108'),('20110215161039'),('20110221105637'),('20110224162141'),('20110224174209'),('99999999999000'),('99999999999900');
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
  `x` mediumint(9) DEFAULT NULL,
  `y` mediumint(9) DEFAULT NULL,
  `wormhole` tinyint(1) NOT NULL DEFAULT '0',
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
INSERT INTO `solar_systems` VALUES (1,1,NULL,NULL,0),(2,1,1,-5,0);
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
  `special` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uniqueness` (`solar_system_id`,`position`,`angle`),
  KEY `index_planets_on_galaxy_id_and_solar_system_id` (`solar_system_id`),
  KEY `index_planets_on_player_id_and_galaxy_id` (`player_id`),
  KEY `group_by_for_fowssentry_status_updates` (`player_id`,`solar_system_id`),
  CONSTRAINT `ss_objects_ibfk_1` FOREIGN KEY (`solar_system_id`) REFERENCES `solar_systems` (`id`) ON DELETE CASCADE,
  CONSTRAINT `ss_objects_ibfk_2` FOREIGN KEY (`player_id`) REFERENCES `players` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=17 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ss_objects`
--

LOCK TABLES `ss_objects` WRITE;
/*!40000 ALTER TABLE `ss_objects` DISABLE KEYS */;
INSERT INTO `ss_objects` VALUES (1,1,23,13,1,45,'Planet',NULL,'Inculta',40,1,0,0,0,0,0,0,0,0,0,'2011-03-01 13:50:28',0,NULL,NULL,NULL,NULL,1),(2,1,0,0,3,22,'Jumpgate',NULL,'',42,0,0,0,0,0,0,0,0,0,0,NULL,0,NULL,NULL,NULL,NULL,0),(3,1,0,0,3,270,'Jumpgate',NULL,'',46,0,0,0,0,0,0,0,0,0,0,NULL,0,NULL,NULL,NULL,NULL,0),(4,1,15,15,2,210,'Planet',NULL,'Limus',37,2,0,0,0,0,0,0,0,0,0,'2011-03-01 13:50:28',0,NULL,NULL,NULL,NULL,1),(5,1,21,17,0,270,'Planet',NULL,'Gramen',40,0,0,0,0,0,0,0,0,0,0,'2011-03-01 13:50:28',0,NULL,NULL,NULL,NULL,1),(6,1,0,0,3,134,'Jumpgate',NULL,'',35,0,0,0,0,0,0,0,0,0,0,NULL,0,NULL,NULL,NULL,NULL,0),(7,2,0,0,1,45,'Asteroid',NULL,'',30,0,0,0,2,0,0,2,0,0,1,NULL,0,NULL,NULL,NULL,NULL,0),(8,2,0,0,2,150,'Asteroid',NULL,'',51,0,0,0,1,0,0,1,0,0,2,NULL,0,NULL,NULL,NULL,NULL,0),(9,2,0,0,3,0,'Jumpgate',NULL,'',54,0,0,0,0,0,0,0,0,0,0,NULL,0,NULL,NULL,NULL,NULL,0),(10,2,0,0,0,90,'Asteroid',NULL,'',26,0,0,0,1,0,0,2,0,0,2,NULL,0,NULL,NULL,NULL,NULL,0),(11,2,0,0,2,60,'Asteroid',NULL,'',57,0,0,0,2,0,0,2,0,0,1,NULL,0,NULL,NULL,NULL,NULL,0),(12,2,0,0,1,0,'Asteroid',NULL,'',29,0,0,0,1,0,0,1,0,0,2,NULL,0,NULL,NULL,NULL,NULL,0),(13,2,34,36,0,180,'Planet',NULL,'P-13',54,1,0,0,0,0,0,0,0,0,0,'2011-03-01 13:50:29',0,NULL,NULL,NULL,NULL,0),(14,2,0,0,2,300,'Asteroid',NULL,'',25,0,0,0,2,0,0,2,0,0,2,NULL,0,NULL,NULL,NULL,NULL,0),(15,2,30,30,1,270,'Planet',1,'P-15',50,0,3186.11,139.5,9654.87,7042.03,308.5,21339.5,0,0,2622.17,'2011-03-01 13:50:29',0,NULL,NULL,NULL,NULL,0),(16,2,0,0,0,0,'Asteroid',NULL,'',60,0,0,0,2,0,0,1,0,0,2,NULL,0,NULL,NULL,NULL,NULL,0);
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
INSERT INTO `tiles` VALUES (14,1,0,8),(13,1,1,0),(8,1,7,3),(8,1,10,10),(13,1,11,1),(13,1,14,10),(9,1,18,0),(9,1,19,5),(9,4,5,11),(12,4,9,1),(13,4,9,8),(13,5,0,0),(8,5,0,7),(8,5,2,3),(10,5,7,0),(9,5,7,12),(12,5,14,0),(14,5,14,7),(3,13,0,0),(3,13,0,1),(3,13,0,2),(3,13,0,3),(3,13,0,4),(3,13,0,5),(4,13,0,30),(4,13,0,31),(14,13,0,32),(3,13,1,0),(3,13,1,1),(3,13,1,2),(3,13,1,3),(4,13,1,29),(4,13,1,30),(4,13,1,31),(3,13,2,0),(3,13,2,1),(3,13,2,2),(3,13,2,3),(4,13,2,27),(4,13,2,29),(4,13,2,30),(4,13,2,31),(3,13,3,0),(3,13,3,1),(3,13,3,2),(3,13,3,3),(3,13,3,11),(3,13,3,14),(6,13,3,21),(6,13,3,22),(4,13,3,27),(4,13,3,28),(4,13,3,29),(4,13,3,30),(4,13,3,31),(4,13,3,32),(4,13,3,33),(3,13,3,34),(3,13,3,35),(3,13,4,1),(3,13,4,2),(3,13,4,3),(3,13,4,9),(3,13,4,11),(3,13,4,12),(3,13,4,14),(0,13,4,18),(6,13,4,20),(6,13,4,21),(6,13,4,22),(4,13,4,28),(4,13,4,29),(4,13,4,30),(4,13,4,31),(4,13,4,32),(4,13,4,33),(3,13,4,34),(3,13,4,35),(3,13,5,9),(3,13,5,10),(3,13,5,11),(3,13,5,12),(3,13,5,13),(3,13,5,14),(3,13,5,15),(6,13,5,20),(6,13,5,21),(6,13,5,22),(4,13,5,29),(4,13,5,30),(3,13,5,32),(3,13,5,33),(3,13,5,34),(3,13,5,35),(3,13,6,8),(3,13,6,9),(3,13,6,10),(3,13,6,11),(3,13,6,13),(3,13,6,14),(3,13,6,15),(6,13,6,20),(6,13,6,21),(6,13,6,22),(6,13,6,23),(4,13,6,29),(4,13,6,30),(3,13,6,31),(3,13,6,32),(3,13,6,33),(3,13,6,34),(3,13,6,35),(3,13,7,14),(6,13,7,21),(6,13,7,22),(6,13,7,23),(6,13,7,31),(6,13,7,32),(3,13,7,33),(3,13,7,34),(3,13,7,35),(6,13,8,21),(6,13,8,22),(2,13,8,23),(6,13,8,32),(3,13,8,33),(3,13,8,34),(3,13,8,35),(6,13,9,22),(1,13,9,29),(6,13,9,31),(6,13,9,32),(3,13,9,34),(3,13,9,35),(6,13,10,22),(6,13,10,28),(6,13,10,31),(6,13,10,32),(6,13,10,33),(10,13,11,17),(6,13,11,28),(6,13,11,29),(6,13,11,30),(6,13,11,31),(6,13,11,32),(6,13,11,33),(6,13,12,30),(6,13,12,31),(6,13,12,32),(2,13,13,22),(0,13,13,29),(6,13,13,31),(0,13,15,3),(6,13,15,20),(6,13,15,22),(6,13,15,23),(6,13,16,20),(6,13,16,21),(6,13,16,22),(6,13,16,23),(0,13,17,13),(6,13,17,21),(6,13,17,22),(6,13,17,23),(5,13,18,8),(6,13,18,20),(6,13,18,21),(6,13,18,22),(5,13,19,7),(5,13,19,8),(5,13,19,19),(6,13,19,21),(5,13,20,2),(5,13,20,3),(5,13,20,4),(5,13,20,5),(5,13,20,6),(5,13,20,7),(9,13,20,13),(5,13,20,18),(5,13,20,19),(6,13,20,21),(6,13,20,22),(6,13,20,23),(5,13,21,2),(5,13,21,3),(5,13,21,4),(5,13,21,5),(5,13,21,6),(5,13,21,7),(5,13,21,18),(5,13,21,20),(6,13,21,21),(6,13,21,23),(5,13,22,2),(5,13,22,3),(5,13,22,5),(5,13,22,7),(0,13,22,8),(4,13,22,17),(5,13,22,18),(5,13,22,19),(5,13,22,20),(5,13,22,21),(5,13,22,22),(5,13,22,23),(5,13,23,2),(5,13,23,3),(5,13,23,4),(5,13,23,5),(5,13,23,6),(5,13,23,7),(4,13,23,16),(4,13,23,17),(5,13,23,19),(5,13,23,20),(5,13,23,21),(5,13,23,22),(5,13,23,23),(5,13,24,2),(5,13,24,3),(5,13,24,4),(5,13,24,6),(4,13,24,14),(4,13,24,15),(4,13,24,16),(4,13,24,17),(5,13,24,18),(5,13,24,19),(5,13,24,20),(5,13,24,21),(5,13,25,4),(5,13,25,5),(5,13,25,6),(0,13,25,13),(4,13,25,15),(4,13,25,16),(4,13,25,17),(4,13,25,18),(5,13,25,19),(5,13,25,20),(5,13,25,21),(5,13,26,1),(4,13,26,15),(4,13,26,16),(4,13,26,17),(0,13,26,18),(5,13,26,20),(5,13,26,21),(1,13,26,32),(5,13,27,1),(4,13,27,12),(4,13,27,13),(4,13,27,14),(4,13,27,15),(4,13,27,16),(4,13,27,17),(5,13,27,20),(5,13,27,21),(3,13,27,34),(5,13,28,1),(5,13,28,4),(5,13,28,5),(4,13,28,13),(4,13,28,14),(4,13,28,16),(4,13,28,17),(5,13,28,21),(3,13,28,30),(3,13,28,31),(3,13,28,32),(3,13,28,33),(3,13,28,34),(5,13,29,0),(5,13,29,1),(5,13,29,2),(5,13,29,3),(5,13,29,4),(4,13,29,10),(4,13,29,12),(4,13,29,13),(4,13,29,16),(5,13,29,19),(5,13,29,20),(5,13,29,21),(3,13,29,29),(3,13,29,30),(3,13,29,31),(3,13,29,32),(3,13,29,33),(3,13,29,34),(3,13,29,35),(5,13,30,0),(5,13,30,1),(5,13,30,2),(5,13,30,4),(5,13,30,5),(4,13,30,8),(4,13,30,9),(4,13,30,10),(4,13,30,11),(4,13,30,12),(4,13,30,13),(4,13,30,16),(2,13,30,17),(5,13,30,20),(0,13,30,23),(3,13,30,29),(3,13,30,30),(3,13,30,31),(3,13,30,32),(3,13,30,33),(5,13,31,1),(5,13,31,2),(5,13,31,3),(5,13,31,4),(5,13,31,5),(5,13,31,6),(4,13,31,11),(4,13,31,12),(4,13,31,13),(4,13,31,14),(4,13,31,16),(3,13,31,32),(3,13,31,33),(3,13,31,34),(5,13,32,0),(5,13,32,1),(5,13,32,2),(5,13,32,3),(5,13,32,4),(5,13,32,5),(5,13,32,6),(4,13,32,11),(4,13,32,13),(4,13,32,14),(4,13,32,15),(4,13,32,16),(4,13,32,17),(5,13,33,0),(5,13,33,1),(5,13,33,2),(5,13,33,4),(4,13,33,11),(4,13,33,12),(4,13,33,13),(4,13,33,14),(4,13,33,15),(4,13,33,17),(0,15,0,0),(5,15,0,3),(5,15,0,4),(5,15,0,5),(5,15,0,6),(5,15,0,7),(5,15,0,8),(5,15,0,9),(5,15,0,10),(5,15,0,11),(5,15,0,12),(5,15,0,13),(5,15,0,14),(5,15,0,26),(5,15,0,27),(5,15,0,28),(5,15,0,29),(5,15,1,3),(11,15,1,4),(5,15,1,11),(5,15,1,12),(5,15,1,13),(13,15,1,16),(4,15,1,19),(4,15,1,20),(4,15,1,21),(4,15,1,22),(5,15,1,26),(5,15,1,27),(5,15,1,28),(5,15,1,29),(5,15,2,2),(5,15,2,3),(5,15,2,10),(5,15,2,12),(5,15,2,13),(5,15,2,14),(5,15,2,15),(4,15,2,20),(4,15,2,21),(4,15,2,22),(4,15,2,23),(5,15,2,27),(5,15,2,28),(5,15,2,29),(0,15,3,1),(5,15,3,10),(5,15,3,11),(5,15,3,12),(5,15,3,13),(5,15,3,14),(4,15,3,20),(4,15,3,21),(4,15,3,22),(4,15,3,23),(4,15,3,24),(5,15,3,28),(5,15,3,29),(5,15,4,12),(5,15,4,13),(6,15,4,18),(4,15,4,21),(4,15,4,22),(4,15,4,23),(5,15,4,26),(5,15,4,27),(5,15,4,28),(6,15,5,8),(6,15,5,9),(6,15,5,18),(6,15,5,19),(4,15,5,22),(4,15,5,23),(4,15,5,24),(5,15,5,26),(5,15,5,27),(6,15,6,7),(6,15,6,8),(6,15,6,9),(6,15,6,11),(6,15,6,18),(6,15,6,19),(6,15,7,9),(6,15,7,10),(6,15,7,18),(12,15,7,23),(6,15,8,9),(6,15,8,10),(6,15,8,16),(6,15,8,17),(6,15,8,18),(3,15,9,3),(3,15,9,4),(3,15,10,0),(3,15,10,2),(3,15,10,3),(3,15,10,4),(8,15,10,5),(0,15,10,20),(3,15,11,0),(3,15,11,1),(3,15,11,2),(3,15,11,3),(3,15,12,0),(3,15,12,1),(3,15,12,2),(3,15,13,0),(3,15,13,1),(3,15,13,2),(3,15,13,4),(3,15,14,0),(3,15,14,1),(3,15,14,2),(3,15,14,3),(3,15,14,4),(3,15,15,0),(3,15,15,1),(3,15,15,2),(3,15,15,3),(3,15,15,4),(3,15,16,0),(3,15,16,1),(3,15,16,2),(3,15,16,3),(5,15,16,29),(3,15,17,0),(3,15,17,1),(3,15,17,2),(3,15,17,3),(3,15,17,4),(2,15,17,28),(3,15,18,0),(3,15,18,1),(3,15,18,2),(3,15,18,3),(3,15,18,4),(3,15,18,5),(0,15,18,23),(3,15,19,0),(3,15,19,1),(3,15,19,2),(3,15,19,3),(3,15,19,4),(3,15,19,5),(5,15,19,29),(3,15,20,0),(3,15,20,1),(3,15,20,2),(3,15,20,3),(3,15,20,4),(3,15,20,5),(5,15,20,28),(5,15,20,29),(3,15,21,0),(3,15,21,1),(3,15,21,2),(3,15,21,3),(3,15,21,4),(5,15,21,29),(3,15,22,0),(3,15,22,1),(3,15,22,2),(14,15,22,25),(5,15,22,29),(3,15,23,0),(3,15,23,1),(3,15,23,2),(3,15,23,3),(4,15,23,9),(5,15,23,29),(3,15,24,1),(3,15,24,2),(0,15,24,4),(4,15,24,7),(4,15,24,8),(4,15,24,9),(4,15,24,10),(4,15,24,11),(5,15,24,29),(4,15,25,7),(4,15,25,8),(4,15,25,9),(4,15,25,10),(5,15,25,27),(5,15,25,29),(4,15,26,6),(4,15,26,7),(4,15,26,8),(4,15,26,9),(4,15,26,10),(2,15,26,12),(6,15,26,22),(6,15,26,23),(5,15,26,27),(5,15,26,28),(5,15,26,29),(4,15,27,5),(4,15,27,6),(4,15,27,7),(4,15,27,8),(4,15,27,9),(4,15,27,10),(5,15,27,17),(5,15,27,18),(5,15,27,21),(5,15,27,22),(6,15,27,23),(6,15,27,24),(0,15,28,4),(4,15,28,6),(4,15,28,7),(4,15,28,8),(4,15,28,9),(4,15,28,10),(5,15,28,15),(5,15,28,16),(5,15,28,17),(5,15,28,18),(5,15,28,19),(5,15,28,21),(5,15,28,22),(6,15,28,23),(6,15,28,24),(5,15,28,25),(5,15,28,26),(5,15,28,27),(5,15,28,28),(4,15,29,7),(4,15,29,8),(4,15,29,9),(4,15,29,10),(4,15,29,11),(5,15,29,16),(5,15,29,17),(5,15,29,18),(5,15,29,19),(5,15,29,20),(5,15,29,21),(5,15,29,22),(6,15,29,23),(6,15,29,24),(6,15,29,25),(6,15,29,26),(5,15,29,27);
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
) ENGINE=InnoDB AUTO_INCREMENT=555 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `units`
--

LOCK TABLES `units` WRITE;
/*!40000 ALTER TABLE `units` DISABLE KEYS */;
INSERT INTO `units` VALUES (1,2812,1,2,1,NULL,NULL,NULL,NULL,0,0,'Dirac',0,1,45,NULL,1,0,0,0,0,0,0),(2,2812,1,2,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,1,45,NULL,1,0,0,0,0,0,0),(3,2812,1,2,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,1,45,NULL,1,0,0,0,0,0,0),(4,2812,1,2,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,1,45,NULL,1,0,0,0,0,0,0),(5,2812,1,2,1,NULL,NULL,NULL,NULL,0,0,'Dirac',0,1,45,NULL,1,0,0,0,0,0,0),(6,2812,1,2,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,1,45,NULL,1,0,0,0,0,0,0),(7,2812,1,2,1,NULL,NULL,NULL,NULL,0,0,'Dirac',0,1,45,NULL,1,0,0,0,0,0,0),(8,2812,1,2,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,1,45,NULL,1,0,0,0,0,0,0),(9,2812,1,2,1,NULL,NULL,NULL,NULL,0,0,'Dirac',0,2,150,NULL,1,0,0,0,0,0,0),(10,2812,1,2,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,2,150,NULL,1,0,0,0,0,0,0),(11,2812,1,2,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,2,150,NULL,1,0,0,0,0,0,0),(12,2812,1,2,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,2,150,NULL,1,0,0,0,0,0,0),(13,2812,1,2,1,NULL,NULL,NULL,NULL,0,0,'Dirac',0,2,150,NULL,1,0,0,0,0,0,0),(14,2812,1,2,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,2,150,NULL,1,0,0,0,0,0,0),(15,2812,1,2,1,NULL,NULL,NULL,NULL,0,0,'Dirac',0,2,150,NULL,1,0,0,0,0,0,0),(16,2812,1,2,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,2,150,NULL,1,0,0,0,0,0,0),(17,4475,1,2,1,NULL,NULL,NULL,NULL,0,0,'Thor',0,3,0,NULL,1,0,0,0,0,0,0),(18,4475,1,2,1,NULL,NULL,NULL,NULL,0,0,'Thor',0,3,0,NULL,1,0,0,0,0,0,0),(19,4475,1,2,1,NULL,NULL,NULL,NULL,0,0,'Thor',1,3,0,NULL,1,0,0,0,0,0,0),(20,2812,1,2,1,NULL,NULL,NULL,NULL,0,0,'Dirac',0,3,0,NULL,1,0,0,0,0,0,0),(21,2812,1,2,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,3,0,NULL,1,0,0,0,0,0,0),(22,2812,1,2,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,3,0,NULL,1,0,0,0,0,0,0),(23,2812,1,2,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,3,0,NULL,1,0,0,0,0,0,0),(24,2812,1,2,1,NULL,NULL,NULL,NULL,0,0,'Dirac',0,3,0,NULL,1,0,0,0,0,0,0),(25,2812,1,2,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,3,0,NULL,1,0,0,0,0,0,0),(26,2812,1,2,1,NULL,NULL,NULL,NULL,0,0,'Dirac',0,3,0,NULL,1,0,0,0,0,0,0),(27,2812,1,2,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,3,0,NULL,1,0,0,0,0,0,0),(28,2812,1,2,1,NULL,NULL,NULL,NULL,0,0,'Dirac',0,0,90,NULL,1,0,0,0,0,0,0),(29,2812,1,2,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,0,90,NULL,1,0,0,0,0,0,0),(30,2812,1,2,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,0,90,NULL,1,0,0,0,0,0,0),(31,2812,1,2,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,0,90,NULL,1,0,0,0,0,0,0),(32,2812,1,2,1,NULL,NULL,NULL,NULL,0,0,'Dirac',0,0,90,NULL,1,0,0,0,0,0,0),(33,2812,1,2,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,0,90,NULL,1,0,0,0,0,0,0),(34,2812,1,2,1,NULL,NULL,NULL,NULL,0,0,'Dirac',0,0,90,NULL,1,0,0,0,0,0,0),(35,2812,1,2,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,0,90,NULL,1,0,0,0,0,0,0),(36,2812,1,2,1,NULL,NULL,NULL,NULL,0,0,'Dirac',0,2,60,NULL,1,0,0,0,0,0,0),(37,2812,1,2,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,2,60,NULL,1,0,0,0,0,0,0),(38,2812,1,2,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,2,60,NULL,1,0,0,0,0,0,0),(39,2812,1,2,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,2,60,NULL,1,0,0,0,0,0,0),(40,2812,1,2,1,NULL,NULL,NULL,NULL,0,0,'Dirac',0,2,60,NULL,1,0,0,0,0,0,0),(41,2812,1,2,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,2,60,NULL,1,0,0,0,0,0,0),(42,2812,1,2,1,NULL,NULL,NULL,NULL,0,0,'Dirac',0,2,60,NULL,1,0,0,0,0,0,0),(43,2812,1,2,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,2,60,NULL,1,0,0,0,0,0,0),(44,2812,1,2,1,NULL,NULL,NULL,NULL,0,0,'Dirac',0,1,0,NULL,1,0,0,0,0,0,0),(45,2812,1,2,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,1,0,NULL,1,0,0,0,0,0,0),(46,2812,1,2,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,1,0,NULL,1,0,0,0,0,0,0),(47,2812,1,2,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,1,0,NULL,1,0,0,0,0,0,0),(48,2812,1,2,1,NULL,NULL,NULL,NULL,0,0,'Dirac',0,1,0,NULL,1,0,0,0,0,0,0),(49,2812,1,2,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,1,0,NULL,1,0,0,0,0,0,0),(50,2812,1,2,1,NULL,NULL,NULL,NULL,0,0,'Dirac',0,1,0,NULL,1,0,0,0,0,0,0),(51,2812,1,2,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,1,0,NULL,1,0,0,0,0,0,0),(52,2812,1,2,1,NULL,NULL,NULL,NULL,0,0,'Dirac',0,0,180,NULL,1,0,0,0,0,0,0),(53,2812,1,2,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,0,180,NULL,1,0,0,0,0,0,0),(54,2812,1,2,1,NULL,NULL,NULL,NULL,0,0,'Dirac',0,0,180,NULL,1,0,0,0,0,0,0),(55,2812,1,2,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,0,180,NULL,1,0,0,0,0,0,0),(56,90,1,13,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(57,90,1,13,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(58,125,1,13,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(59,125,1,13,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(60,125,1,13,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(61,125,1,13,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(62,125,1,13,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(63,125,1,13,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(64,125,1,13,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(65,90,1,14,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(66,90,1,14,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(67,90,1,14,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(68,90,1,14,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(69,125,1,14,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(70,125,1,14,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(71,125,1,14,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(72,125,1,14,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(73,125,1,14,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(74,125,1,14,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(75,125,1,14,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(76,900,1,15,4,NULL,NULL,NULL,NULL,0,0,'Gnawer',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(77,900,1,15,4,NULL,NULL,NULL,NULL,0,0,'Gnawer',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(78,500,1,15,4,NULL,NULL,NULL,NULL,0,0,'Spudder',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(79,500,1,15,4,NULL,NULL,NULL,NULL,0,0,'Spudder',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(80,500,1,15,4,NULL,NULL,NULL,NULL,0,0,'Spudder',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(81,500,1,15,4,NULL,NULL,NULL,NULL,0,0,'Spudder',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(82,90,1,15,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(83,90,1,15,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(84,125,1,15,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(85,90,1,15,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(86,90,1,15,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(87,90,1,15,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(88,90,1,15,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(89,90,1,15,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(90,90,1,15,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(91,125,1,15,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(92,125,1,15,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(93,125,1,15,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(94,125,1,15,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(95,125,1,15,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(96,125,1,15,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(97,125,1,15,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(98,900,1,16,4,NULL,NULL,NULL,NULL,0,0,'Gnawer',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(99,900,1,16,4,NULL,NULL,NULL,NULL,0,0,'Gnawer',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(100,500,1,16,4,NULL,NULL,NULL,NULL,0,0,'Spudder',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(101,500,1,16,4,NULL,NULL,NULL,NULL,0,0,'Spudder',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(102,500,1,16,4,NULL,NULL,NULL,NULL,0,0,'Spudder',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(103,500,1,16,4,NULL,NULL,NULL,NULL,0,0,'Spudder',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(104,500,1,16,4,NULL,NULL,NULL,NULL,0,0,'Spudder',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(105,90,1,16,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(106,90,1,16,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(107,125,1,16,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(108,125,1,16,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(109,125,1,16,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(110,125,1,16,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(111,90,1,16,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(112,90,1,16,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(113,90,1,16,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(114,90,1,16,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(115,90,1,16,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(116,125,1,16,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(117,125,1,16,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(118,125,1,16,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(119,125,1,16,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(120,125,1,16,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(121,125,1,16,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(122,125,1,16,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(123,500,1,17,4,NULL,NULL,NULL,NULL,0,0,'Spudder',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(124,500,1,17,4,NULL,NULL,NULL,NULL,0,0,'Spudder',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(125,90,1,17,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(126,90,1,17,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(127,125,1,17,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(128,90,1,17,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(129,90,1,17,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(130,90,1,17,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(131,90,1,17,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(132,90,1,17,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(133,125,1,17,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(134,125,1,17,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(135,125,1,17,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(136,125,1,17,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(137,125,1,17,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(138,125,1,17,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(139,125,1,17,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(140,125,1,17,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(141,500,1,18,4,NULL,NULL,NULL,NULL,0,0,'Spudder',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(142,500,1,18,4,NULL,NULL,NULL,NULL,0,0,'Spudder',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(143,90,1,18,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(144,90,1,18,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(145,125,1,18,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(146,125,1,18,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(147,125,1,18,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(148,125,1,18,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(149,90,1,18,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(150,90,1,18,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(151,90,1,18,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(152,90,1,18,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(153,90,1,18,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(154,125,1,18,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(155,125,1,18,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(156,125,1,18,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(157,125,1,18,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(158,125,1,18,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(159,125,1,18,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(160,125,1,18,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(161,125,1,18,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(162,125,1,18,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(163,125,1,18,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(164,125,1,18,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(165,900,1,19,4,NULL,NULL,NULL,NULL,0,0,'Gnawer',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(166,900,1,19,4,NULL,NULL,NULL,NULL,0,0,'Gnawer',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(167,900,1,19,4,NULL,NULL,NULL,NULL,0,0,'Gnawer',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(168,900,1,19,4,NULL,NULL,NULL,NULL,0,0,'Gnawer',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(169,500,1,19,4,NULL,NULL,NULL,NULL,0,0,'Spudder',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(170,500,1,19,4,NULL,NULL,NULL,NULL,0,0,'Spudder',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(171,500,1,19,4,NULL,NULL,NULL,NULL,0,0,'Spudder',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(172,500,1,19,4,NULL,NULL,NULL,NULL,0,0,'Spudder',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(173,90,1,19,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(174,125,1,19,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(175,125,1,19,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(176,125,1,19,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(177,125,1,19,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(178,90,1,19,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(179,90,1,19,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(180,90,1,19,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(181,90,1,19,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(182,90,1,19,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(183,90,1,19,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(184,125,1,19,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(185,125,1,19,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(186,125,1,19,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(187,125,1,19,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(188,125,1,19,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(189,125,1,19,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(190,125,1,19,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(191,900,1,20,4,NULL,NULL,NULL,NULL,0,0,'Gnawer',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(192,900,1,20,4,NULL,NULL,NULL,NULL,0,0,'Gnawer',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(193,900,1,20,4,NULL,NULL,NULL,NULL,0,0,'Gnawer',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(194,500,1,20,4,NULL,NULL,NULL,NULL,0,0,'Spudder',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(195,500,1,20,4,NULL,NULL,NULL,NULL,0,0,'Spudder',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(196,500,1,20,4,NULL,NULL,NULL,NULL,0,0,'Spudder',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(197,500,1,20,4,NULL,NULL,NULL,NULL,0,0,'Spudder',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(198,500,1,20,4,NULL,NULL,NULL,NULL,0,0,'Spudder',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(199,500,1,20,4,NULL,NULL,NULL,NULL,0,0,'Spudder',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(200,500,1,20,4,NULL,NULL,NULL,NULL,0,0,'Spudder',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(201,90,1,20,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(202,90,1,20,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(203,90,1,20,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(204,90,1,20,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(205,90,1,20,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(206,90,1,20,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(207,90,1,20,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(208,125,1,20,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(209,125,1,20,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(210,125,1,20,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(211,125,1,20,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(212,125,1,20,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(213,125,1,20,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(214,125,1,20,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(215,125,1,20,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(216,125,1,20,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(217,125,1,20,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(218,900,1,21,4,NULL,NULL,NULL,NULL,0,0,'Gnawer',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(219,900,1,21,4,NULL,NULL,NULL,NULL,0,0,'Gnawer',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(220,500,1,21,4,NULL,NULL,NULL,NULL,0,0,'Spudder',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(221,500,1,21,4,NULL,NULL,NULL,NULL,0,0,'Spudder',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(222,500,1,21,4,NULL,NULL,NULL,NULL,0,0,'Spudder',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(223,500,1,21,4,NULL,NULL,NULL,NULL,0,0,'Spudder',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(224,500,1,21,4,NULL,NULL,NULL,NULL,0,0,'Spudder',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(225,90,1,21,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(226,90,1,21,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(227,125,1,21,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(228,125,1,21,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(229,125,1,21,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(230,90,1,21,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(231,90,1,21,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(232,90,1,21,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(233,90,1,21,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(234,90,1,21,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(235,125,1,21,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(236,125,1,21,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(237,125,1,21,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(238,125,1,21,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(239,125,1,21,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(240,125,1,21,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(241,125,1,21,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(242,900,1,22,4,NULL,NULL,NULL,NULL,0,0,'Gnawer',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(243,900,1,22,4,NULL,NULL,NULL,NULL,0,0,'Gnawer',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(244,500,1,22,4,NULL,NULL,NULL,NULL,0,0,'Spudder',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(245,500,1,22,4,NULL,NULL,NULL,NULL,0,0,'Spudder',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(246,500,1,22,4,NULL,NULL,NULL,NULL,0,0,'Spudder',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(247,500,1,22,4,NULL,NULL,NULL,NULL,0,0,'Spudder',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(248,500,1,22,4,NULL,NULL,NULL,NULL,0,0,'Spudder',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(249,90,1,22,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(250,90,1,22,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(251,125,1,22,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(252,90,1,22,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(253,90,1,22,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(254,90,1,22,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(255,90,1,22,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(256,90,1,22,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(257,125,1,22,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(258,125,1,22,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(259,125,1,22,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(260,125,1,22,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(261,125,1,22,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(262,125,1,22,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(263,125,1,22,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(264,90,1,23,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(265,90,1,23,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(266,125,1,23,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(267,125,1,23,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(268,125,1,23,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(269,90,1,23,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(270,90,1,23,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(271,90,1,23,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(272,90,1,23,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(273,90,1,23,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(274,90,1,23,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(275,90,1,23,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(276,125,1,23,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(277,125,1,23,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(278,125,1,23,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(279,125,1,23,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(280,125,1,23,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(281,125,1,23,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(282,125,1,23,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(283,500,1,24,4,NULL,NULL,NULL,NULL,0,0,'Spudder',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(284,90,1,24,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(285,125,1,24,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(286,125,1,24,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(287,125,1,24,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(288,90,1,24,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(289,90,1,24,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(290,90,1,24,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(291,90,1,24,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(292,90,1,24,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(293,90,1,24,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(294,90,1,24,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(295,125,1,24,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(296,125,1,24,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(297,125,1,24,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(298,125,1,24,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(299,125,1,24,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(300,125,1,24,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(301,125,1,24,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(302,125,1,24,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(303,125,1,24,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(304,90,1,25,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(305,90,1,25,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(306,125,1,25,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(307,125,1,25,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(308,125,1,25,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(309,125,1,25,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(310,90,1,25,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(311,90,1,25,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(312,90,1,25,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(313,90,1,25,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(314,90,1,25,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(315,90,1,25,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(316,125,1,25,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(317,125,1,25,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(318,125,1,25,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(319,125,1,25,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(320,125,1,25,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(321,125,1,25,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(322,125,1,25,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(323,125,1,26,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(324,125,1,26,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(325,125,1,26,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(326,125,1,26,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(327,125,1,26,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(328,125,1,26,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(329,125,1,26,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(330,125,1,27,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(331,125,1,27,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(332,125,1,27,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(333,125,1,27,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(334,125,1,27,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(335,125,1,27,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(336,125,1,27,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(337,125,1,28,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(338,125,1,28,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(339,125,1,28,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(340,125,1,28,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(341,125,1,28,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(342,125,1,28,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(343,125,1,28,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(344,125,1,28,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(345,125,1,29,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(346,125,1,29,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(347,125,1,29,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(348,125,1,29,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(349,125,1,29,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(350,125,1,29,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(351,125,1,29,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(352,125,1,29,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(353,125,1,29,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(354,4475,1,2,1,NULL,NULL,NULL,NULL,0,0,'Thor',0,2,300,NULL,1,0,0,0,0,0,0),(355,4475,1,2,1,NULL,NULL,NULL,NULL,0,0,'Thor',0,2,300,NULL,1,0,0,0,0,0,0),(356,4475,1,2,1,NULL,NULL,NULL,NULL,0,0,'Thor',1,2,300,NULL,1,0,0,0,0,0,0),(357,2812,1,2,1,NULL,NULL,NULL,NULL,0,0,'Dirac',0,2,300,NULL,1,0,0,0,0,0,0),(358,2812,1,2,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,2,300,NULL,1,0,0,0,0,0,0),(359,2812,1,2,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,2,300,NULL,1,0,0,0,0,0,0),(360,2812,1,2,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,2,300,NULL,1,0,0,0,0,0,0),(361,2812,1,2,1,NULL,NULL,NULL,NULL,0,0,'Dirac',0,2,300,NULL,1,0,0,0,0,0,0),(362,2812,1,2,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,2,300,NULL,1,0,0,0,0,0,0),(363,2812,1,2,1,NULL,NULL,NULL,NULL,0,0,'Dirac',0,2,300,NULL,1,0,0,0,0,0,0),(364,2812,1,2,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,2,300,NULL,1,0,0,0,0,0,0),(365,90,1,30,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(366,125,1,30,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(367,125,1,30,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(368,125,1,30,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(369,125,1,30,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(370,125,1,30,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(371,125,1,30,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(372,125,1,30,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(373,90,1,31,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(374,90,1,31,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(375,125,1,31,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(376,125,1,31,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(377,125,1,31,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(378,125,1,31,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(379,90,1,31,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(380,90,1,31,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(381,125,1,31,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(382,125,1,31,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(383,90,1,31,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(384,125,1,31,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(385,125,1,31,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(386,125,1,31,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(387,125,1,31,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(388,125,1,31,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(389,125,1,31,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(390,125,1,31,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(391,125,1,32,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(392,125,1,32,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(393,125,1,32,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(394,125,1,32,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(395,125,1,32,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(396,125,1,32,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(397,90,1,33,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(398,125,1,33,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(399,125,1,33,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(400,125,1,33,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(401,125,1,33,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(402,125,1,33,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(403,125,1,33,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(404,125,1,33,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(405,125,1,34,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(406,125,1,34,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(407,125,1,34,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(408,125,1,34,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(409,125,1,34,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(410,125,1,34,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(411,125,1,35,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(412,125,1,35,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(413,125,1,35,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(414,125,1,35,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(415,125,1,35,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(416,125,1,35,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(417,90,1,36,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(418,90,1,36,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(419,125,1,36,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(420,125,1,36,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(421,125,1,36,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(422,125,1,36,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(423,90,1,36,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(424,90,1,36,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(425,125,1,36,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(426,125,1,36,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(427,90,1,36,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(428,125,1,36,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(429,125,1,36,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(430,125,1,36,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(431,125,1,36,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(432,125,1,36,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(433,125,1,36,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(434,125,1,36,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(435,125,1,37,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(436,125,1,37,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(437,125,1,37,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(438,125,1,37,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(439,125,1,37,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(440,125,1,37,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(441,125,1,38,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(442,125,1,38,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(443,125,1,38,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(444,125,1,38,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(445,125,1,38,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(446,125,1,38,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(447,90,1,39,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(448,125,1,39,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(449,125,1,39,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(450,125,1,39,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(451,125,1,39,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(452,125,1,39,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(453,125,1,39,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(454,125,1,39,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(455,90,1,40,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(456,125,1,40,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(457,125,1,40,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(458,125,1,40,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(459,125,1,40,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(460,125,1,40,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(461,125,1,40,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(462,125,1,40,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(463,90,1,47,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(464,90,1,47,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(465,125,1,47,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(466,125,1,47,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(467,125,1,47,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(468,125,1,47,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(469,90,1,47,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(470,90,1,47,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(471,125,1,47,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(472,125,1,47,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(473,90,1,47,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(474,125,1,47,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(475,125,1,47,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(476,125,1,47,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(477,125,1,47,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(478,125,1,47,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(479,125,1,47,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(480,125,1,47,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(481,90,1,53,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(482,90,1,53,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(483,125,1,53,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(484,125,1,53,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(485,125,1,53,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(486,125,1,53,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(487,90,1,53,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(488,90,1,53,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(489,125,1,53,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(490,125,1,53,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(491,90,1,53,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(492,125,1,53,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(493,125,1,53,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(494,125,1,53,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(495,125,1,53,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(496,125,1,53,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(497,125,1,53,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(498,125,1,53,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(499,125,1,62,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(500,125,1,62,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(501,125,1,62,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(502,125,1,62,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(503,125,1,62,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(504,125,1,62,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(505,125,1,63,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(506,125,1,63,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(507,125,1,63,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(508,125,1,63,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(509,125,1,63,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(510,125,1,63,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(511,125,1,64,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(512,125,1,64,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(513,125,1,64,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(514,125,1,64,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(515,125,1,64,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(516,125,1,64,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(517,125,1,65,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(518,125,1,65,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(519,125,1,65,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(520,125,1,65,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(521,125,1,65,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(522,125,1,65,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(523,90,1,66,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(524,90,1,66,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(525,125,1,66,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(526,125,1,66,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(527,125,1,66,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(528,125,1,66,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(529,90,1,66,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(530,90,1,66,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(531,125,1,66,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(532,125,1,66,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(533,90,1,66,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(534,125,1,66,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(535,125,1,66,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(536,125,1,66,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(537,125,1,66,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(538,125,1,66,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(539,125,1,66,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(540,125,1,66,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(541,125,1,67,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(542,125,1,67,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(543,125,1,67,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(544,125,1,67,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(545,125,1,67,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(546,125,1,67,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(547,2812,1,2,1,NULL,NULL,NULL,NULL,0,0,'Dirac',0,0,0,NULL,1,0,0,0,0,0,0),(548,2812,1,2,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,0,0,NULL,1,0,0,0,0,0,0),(549,2812,1,2,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,0,0,NULL,1,0,0,0,0,0,0),(550,2812,1,2,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,0,0,NULL,1,0,0,0,0,0,0),(551,2812,1,2,1,NULL,NULL,NULL,NULL,0,0,'Dirac',0,0,0,NULL,1,0,0,0,0,0,0),(552,2812,1,2,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,0,0,NULL,1,0,0,0,0,0,0),(553,2812,1,2,1,NULL,NULL,NULL,NULL,0,0,'Dirac',0,0,0,NULL,1,0,0,0,0,0,0),(554,2812,1,2,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,0,0,NULL,1,0,0,0,0,0,0);
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

-- Dump completed on 2011-03-01 13:50:30
