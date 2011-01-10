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
) ENGINE=InnoDB AUTO_INCREMENT=77 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `buildings`
--

LOCK TABLES `buildings` WRITE;
/*!40000 ALTER TABLE `buildings` DISABLE KEYS */;
INSERT INTO `buildings` VALUES (1,8,1,3,0,0,0,1,'NpcMetalExtractor',NULL,2,4,NULL,1,400,NULL,0,NULL,NULL,0),(2,8,25,10,0,0,0,1,'NpcMetalExtractor',NULL,26,11,NULL,1,400,NULL,0,NULL,NULL,0),(3,8,43,8,0,0,0,1,'NpcGeothermalPlant',NULL,44,9,NULL,1,600,NULL,0,NULL,NULL,0),(4,8,24,14,0,0,0,1,'NpcZetiumExtractor',NULL,25,15,NULL,1,1600,NULL,0,NULL,NULL,0),(5,8,33,4,0,0,0,1,'NpcJumpgate',NULL,37,8,NULL,1,8000,NULL,0,NULL,NULL,0),(6,8,0,11,0,0,0,1,'NpcResearchCenter',NULL,3,14,NULL,1,4000,NULL,0,NULL,NULL,0),(7,8,7,8,0,0,0,1,'NpcExcavationSite',NULL,10,11,NULL,1,3000,NULL,0,NULL,NULL,0),(8,8,45,11,0,0,0,1,'NpcTemple',NULL,47,13,NULL,1,2500,NULL,0,NULL,NULL,0),(9,8,38,4,0,0,0,1,'NpcCommunicationsHub',NULL,40,5,NULL,1,1200,NULL,0,NULL,NULL,0),(10,8,47,5,0,0,0,1,'NpcSolarPlant',NULL,48,6,NULL,1,1000,NULL,0,NULL,NULL,0),(11,8,17,0,0,0,0,1,'NpcSolarPlant',NULL,18,1,NULL,1,1000,NULL,0,NULL,NULL,0),(12,8,36,9,0,0,0,1,'NpcSolarPlant',NULL,37,10,NULL,1,1000,NULL,0,NULL,NULL,0),(13,8,46,14,0,0,0,1,'NpcSolarPlant',NULL,47,15,NULL,1,1000,NULL,0,NULL,NULL,0),(14,11,1,20,0,0,0,1,'NpcMetalExtractor',NULL,2,21,NULL,1,400,NULL,0,NULL,NULL,0),(15,11,6,2,0,0,0,1,'NpcMetalExtractor',NULL,7,3,NULL,1,400,NULL,0,NULL,NULL,0),(16,11,3,25,0,0,0,1,'NpcMetalExtractor',NULL,4,26,NULL,1,400,NULL,0,NULL,NULL,0),(17,11,10,13,0,0,0,1,'NpcMetalExtractor',NULL,11,14,NULL,1,400,NULL,0,NULL,NULL,0),(18,11,6,6,0,0,0,1,'NpcZetiumExtractor',NULL,7,7,NULL,1,1600,NULL,0,NULL,NULL,0),(19,11,10,17,0,0,0,1,'NpcZetiumExtractor',NULL,11,18,NULL,1,1600,NULL,0,NULL,NULL,0),(20,11,10,0,0,0,0,1,'NpcCommunicationsHub',NULL,12,1,NULL,1,1200,NULL,0,NULL,NULL,0),(21,11,0,33,0,0,0,1,'NpcSolarPlant',NULL,1,34,NULL,1,1000,NULL,0,NULL,NULL,0),(22,11,8,33,0,0,0,1,'NpcSolarPlant',NULL,9,34,NULL,1,1000,NULL,0,NULL,NULL,0),(23,11,11,25,0,0,0,1,'NpcSolarPlant',NULL,12,26,NULL,1,1000,NULL,0,NULL,NULL,0),(24,22,0,0,0,0,0,1,'NpcMetalExtractor',NULL,1,1,NULL,1,400,NULL,0,NULL,NULL,0),(25,22,7,0,0,0,0,1,'NpcCommunicationsHub',NULL,9,1,NULL,1,1200,NULL,0,NULL,NULL,0),(26,22,18,0,0,0,0,1,'NpcSolarPlant',NULL,19,1,NULL,1,1000,NULL,0,NULL,NULL,0),(27,22,3,1,0,0,0,1,'NpcMetalExtractor',NULL,4,2,NULL,1,400,NULL,0,NULL,NULL,0),(28,22,12,1,0,0,0,1,'NpcSolarPlant',NULL,13,2,NULL,1,1000,NULL,0,NULL,NULL,0),(29,22,22,1,0,0,0,1,'NpcSolarPlant',NULL,23,2,NULL,1,1000,NULL,0,NULL,NULL,0),(30,22,26,1,0,0,0,1,'NpcCommunicationsHub',NULL,28,2,NULL,1,1200,NULL,0,NULL,NULL,0),(31,22,15,3,0,0,0,1,'NpcSolarPlant',NULL,16,4,NULL,1,1000,NULL,0,NULL,NULL,0),(32,22,18,3,0,0,0,1,'NpcSolarPlant',NULL,19,4,NULL,1,1000,NULL,0,NULL,NULL,0),(33,22,24,4,0,0,0,1,'NpcMetalExtractor',NULL,25,5,NULL,1,400,NULL,0,NULL,NULL,0),(34,22,28,4,0,0,0,1,'NpcMetalExtractor',NULL,29,5,NULL,1,400,NULL,0,NULL,NULL,0),(35,22,7,6,0,0,0,1,'Screamer',NULL,8,7,NULL,1,1300,NULL,0,NULL,NULL,0),(36,22,21,6,0,0,0,1,'Vulcan',NULL,22,7,NULL,1,1000,NULL,0,NULL,NULL,0),(37,22,14,7,0,0,0,1,'Thunder',NULL,15,8,NULL,1,2000,NULL,0,NULL,NULL,0),(38,22,25,8,0,0,0,1,'NpcCommunicationsHub',NULL,27,9,NULL,1,1200,NULL,0,NULL,NULL,0),(39,22,11,10,0,0,0,1,'Mothership',NULL,18,15,NULL,1,10500,NULL,0,NULL,NULL,0),(40,22,7,12,0,0,0,1,'Thunder',NULL,8,13,NULL,1,2000,NULL,0,NULL,NULL,0),(41,22,21,12,0,0,0,1,'Thunder',NULL,22,13,NULL,1,2000,NULL,0,NULL,NULL,0),(42,22,26,12,0,0,0,1,'NpcZetiumExtractor',NULL,27,13,NULL,1,1600,NULL,0,NULL,NULL,0),(43,22,7,19,0,0,0,1,'Vulcan',NULL,8,20,NULL,1,1000,NULL,0,NULL,NULL,0),(44,22,14,19,0,0,0,1,'Thunder',NULL,15,20,NULL,1,2000,NULL,0,NULL,NULL,0),(45,22,21,19,0,0,0,1,'Screamer',NULL,22,20,NULL,1,1300,NULL,0,NULL,NULL,0),(46,26,8,7,0,0,0,1,'NpcMetalExtractor',NULL,9,8,NULL,1,400,NULL,0,NULL,NULL,0),(47,26,15,8,0,0,0,1,'NpcGeothermalPlant',NULL,16,9,NULL,1,600,NULL,0,NULL,NULL,0),(48,26,28,18,0,0,0,1,'NpcZetiumExtractor',NULL,29,19,NULL,1,1600,NULL,0,NULL,NULL,0),(49,26,14,2,0,0,0,1,'NpcZetiumExtractor',NULL,15,3,NULL,1,1600,NULL,0,NULL,NULL,0),(50,26,22,11,0,0,0,1,'NpcResearchCenter',NULL,25,14,NULL,1,4000,NULL,0,NULL,NULL,0),(51,26,23,0,0,0,0,1,'NpcExcavationSite',NULL,26,3,NULL,1,3000,NULL,0,NULL,NULL,0),(52,26,22,7,0,0,0,1,'NpcCommunicationsHub',NULL,24,8,NULL,1,1200,NULL,0,NULL,NULL,0),(53,26,14,5,0,0,0,1,'NpcCommunicationsHub',NULL,16,6,NULL,1,1200,NULL,0,NULL,NULL,0),(54,26,25,9,0,0,0,1,'NpcSolarPlant',NULL,26,10,NULL,1,1000,NULL,0,NULL,NULL,0),(55,26,4,6,0,0,0,1,'NpcSolarPlant',NULL,5,7,NULL,1,1000,NULL,0,NULL,NULL,0),(56,26,1,7,0,0,0,1,'NpcSolarPlant',NULL,2,8,NULL,1,1000,NULL,0,NULL,NULL,0),(57,31,48,18,0,0,0,1,'NpcMetalExtractor',NULL,49,19,NULL,1,400,NULL,0,NULL,NULL,0),(58,31,52,5,0,0,0,1,'NpcMetalExtractor',NULL,53,6,NULL,1,400,NULL,0,NULL,NULL,0),(59,31,37,1,0,0,0,1,'NpcMetalExtractor',NULL,38,2,NULL,1,400,NULL,0,NULL,NULL,0),(60,31,9,10,0,0,0,1,'NpcGeothermalPlant',NULL,10,11,NULL,1,600,NULL,0,NULL,NULL,0),(61,31,38,8,0,0,0,1,'NpcZetiumExtractor',NULL,39,9,NULL,1,1600,NULL,0,NULL,NULL,0),(62,31,12,17,0,0,0,1,'NpcJumpgate',NULL,16,21,NULL,1,8000,NULL,0,NULL,NULL,0),(63,31,22,7,0,0,0,1,'NpcResearchCenter',NULL,25,10,NULL,1,4000,NULL,0,NULL,NULL,0),(64,31,42,13,0,0,0,1,'NpcExcavationSite',NULL,45,16,NULL,1,3000,NULL,0,NULL,NULL,0),(65,31,13,11,0,0,0,1,'NpcCommunicationsHub',NULL,15,12,NULL,1,1200,NULL,0,NULL,NULL,0),(66,31,34,14,0,0,0,1,'NpcCommunicationsHub',NULL,36,15,NULL,1,1200,NULL,0,NULL,NULL,0),(67,31,37,16,0,0,0,1,'NpcSolarPlant',NULL,38,17,NULL,1,1000,NULL,0,NULL,NULL,0),(68,31,42,2,0,0,0,1,'NpcSolarPlant',NULL,43,3,NULL,1,1000,NULL,0,NULL,NULL,0),(69,31,30,8,0,0,0,1,'NpcSolarPlant',NULL,31,9,NULL,1,1000,NULL,0,NULL,NULL,0),(70,52,8,28,0,0,0,1,'NpcMetalExtractor',NULL,9,29,NULL,1,400,NULL,0,NULL,NULL,0),(71,52,8,40,0,0,0,1,'NpcGeothermalPlant',NULL,9,41,NULL,1,600,NULL,0,NULL,NULL,0),(72,52,2,40,0,0,0,1,'NpcTemple',NULL,4,42,NULL,1,2500,NULL,0,NULL,NULL,0),(73,52,0,27,0,0,0,1,'NpcCommunicationsHub',NULL,2,28,NULL,1,1200,NULL,0,NULL,NULL,0),(74,52,9,4,0,0,0,1,'NpcSolarPlant',NULL,10,5,NULL,1,1000,NULL,0,NULL,NULL,0),(75,52,2,20,0,0,0,1,'NpcSolarPlant',NULL,3,21,NULL,1,1000,NULL,0,NULL,NULL,0),(76,52,5,32,0,0,0,1,'NpcSolarPlant',NULL,6,33,NULL,1,1000,NULL,0,NULL,NULL,0);
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
INSERT INTO `folliages` VALUES (8,0,5,6),(8,0,10,12),(8,0,24,12),(8,1,5,3),(8,1,15,4),(8,1,17,0),(8,2,8,12),(8,2,9,7),(8,3,6,13),(8,8,15,7),(8,8,18,0),(8,9,15,10),(8,9,16,6),(8,10,14,4),(8,11,13,10),(8,11,16,3),(8,11,22,4),(8,12,12,7),(8,12,15,1),(8,12,16,11),(8,12,24,13),(8,13,13,1),(8,13,17,6),(8,13,20,7),(8,13,21,3),(8,13,24,4),(8,14,12,2),(8,14,22,6),(8,14,23,10),(8,14,24,4),(8,16,12,13),(8,16,13,5),(8,16,20,1),(8,17,4,2),(8,17,6,0),(8,17,11,2),(8,17,12,13),(8,17,13,4),(8,17,14,12),(8,17,19,3),(8,17,21,12),(8,17,22,7),(8,18,13,4),(8,18,15,11),(8,18,20,4),(8,19,3,5),(8,19,5,11),(8,19,16,12),(8,19,18,10),(8,19,19,6),(8,19,20,0),(8,20,0,11),(8,20,1,9),(8,20,2,6),(8,20,5,4),(8,20,6,13),(8,20,16,7),(8,20,17,13),(8,20,19,2),(8,21,4,11),(8,21,6,4),(8,21,19,0),(8,22,0,7),(8,22,4,11),(8,22,20,10),(8,23,3,7),(8,23,7,3),(8,23,17,13),(8,23,18,1),(8,23,19,10),(8,23,21,12),(8,24,0,0),(8,24,8,11),(8,24,9,2),(8,24,13,1),(8,24,17,10),(8,24,20,9),(8,24,24,3),(8,25,20,11),(8,26,6,11),(8,26,8,2),(8,26,9,11),(8,26,14,7),(8,26,15,0),(8,26,18,10),(8,26,22,7),(8,27,7,12),(8,27,8,11),(8,27,9,1),(8,27,12,3),(8,27,19,4),(8,27,20,0),(8,28,12,10),(8,28,14,9),(8,28,24,7),(8,29,14,11),(8,29,15,3),(8,29,17,9),(8,29,18,0),(8,29,20,11),(8,29,21,7),(8,30,0,3),(8,30,7,6),(8,30,13,1),(8,30,17,12),(8,31,4,2),(8,31,5,0),(8,31,13,11),(8,31,18,1),(8,31,22,2),(8,31,24,4),(8,32,5,11),(8,32,6,1),(8,32,7,7),(8,32,8,5),(8,32,9,13),(8,32,12,3),(8,32,19,12),(8,32,22,0),(8,32,24,6),(8,33,3,11),(8,33,19,1),(8,34,0,4),(8,34,1,11),(8,34,17,7),(8,34,18,11),(8,34,22,11),(8,34,23,5),(8,35,16,11),(8,35,19,7),(8,35,24,13),(8,36,11,5),(8,36,18,8),(8,36,21,10),(8,36,24,1),(8,37,11,9),(8,37,12,1),(8,37,22,13),(8,37,23,6),(8,38,6,12),(8,38,8,13),(8,38,9,1),(8,38,24,4),(8,39,1,10),(8,39,7,6),(8,39,11,8),(8,39,15,10),(8,39,18,10),(8,40,8,1),(8,40,9,12),(8,40,10,1),(8,40,11,13),(8,40,16,8),(8,40,22,3),(8,41,6,6),(8,41,8,3),(8,41,23,1),(8,41,24,7),(8,42,8,7),(8,42,14,2),(8,42,23,12),(8,43,7,6),(8,43,23,3),(8,44,6,5),(8,44,7,10),(8,44,23,10),(8,44,24,9),(8,45,6,7),(8,45,9,6),(8,45,22,10),(8,45,23,3),(8,48,9,4),(8,48,10,12),(8,48,17,6),(11,0,4,13),(11,0,7,8),(11,0,8,10),(11,0,9,5),(11,0,10,3),(11,0,13,4),(11,0,36,10),(11,0,45,1),(11,1,3,3),(11,1,5,6),(11,1,9,4),(11,1,13,8),(11,1,35,2),(11,2,11,12),(11,2,12,11),(11,2,13,2),(11,2,25,3),(11,2,34,9),(11,2,36,0),(11,3,4,9),(11,3,6,6),(11,3,11,1),(11,3,23,2),(11,4,7,11),(11,4,12,0),(11,4,16,2),(11,4,20,9),(11,4,28,4),(11,5,21,0),(11,5,24,13),(11,5,28,6),(11,5,32,2),(11,5,40,2),(11,5,42,3),(11,5,46,4),(11,6,16,1),(11,6,25,2),(11,7,18,3),(11,7,19,10),(11,7,21,9),(11,7,37,12),(11,8,7,3),(11,8,8,10),(11,8,17,1),(11,8,24,0),(11,9,3,5),(11,9,8,0),(11,9,14,13),(11,9,17,7),(11,9,24,2),(11,9,37,2),(11,10,4,1),(11,10,8,6),(11,10,19,6),(11,10,22,10),(11,10,25,8),(11,11,4,2),(11,11,19,2),(11,11,28,1),(11,11,30,8),(11,12,9,13),(11,12,10,10),(11,12,14,13),(11,12,17,2),(11,12,28,5),(22,0,2,10),(22,0,20,7),(22,0,22,9),(22,0,25,5),(22,1,23,6),(22,1,25,0),(22,2,1,8),(22,3,19,13),(22,3,26,13),(22,4,20,11),(22,4,24,7),(22,5,0,6),(22,5,2,0),(22,5,21,11),(22,5,25,0),(22,6,3,2),(22,6,21,1),(22,7,3,1),(22,7,4,10),(22,7,29,0),(22,8,3,10),(22,9,7,2),(22,9,12,11),(22,9,13,1),(22,9,21,7),(22,10,11,4),(22,10,15,5),(22,10,19,9),(22,10,22,11),(22,11,9,0),(22,11,19,0),(22,12,17,8),(22,13,5,0),(22,13,16,0),(22,13,17,3),(22,13,19,0),(22,13,21,5),(22,13,28,13),(22,14,16,9),(22,14,17,9),(22,14,18,2),(22,14,29,11),(22,15,5,11),(22,15,9,1),(22,15,27,1),(22,16,5,0),(22,16,16,0),(22,16,17,11),(22,16,19,8),(22,17,16,4),(22,17,19,10),(22,17,21,6),(22,17,23,5),(22,17,27,7),(22,18,18,11),(22,18,27,3),(22,19,9,11),(22,19,10,5),(22,19,11,1),(22,19,17,3),(22,19,18,9),(22,19,20,7),(22,19,22,2),(22,20,9,4),(22,20,12,8),(22,20,16,9),(22,20,18,0),(22,20,20,8),(22,20,24,5),(22,21,8,6),(22,21,18,6),(22,21,22,8),(22,21,23,0),(22,22,11,2),(22,22,15,6),(22,23,6,11),(22,23,14,5),(22,23,18,1),(22,23,20,9),(22,23,21,4),(22,23,23,4),(22,24,14,7),(22,24,23,1),(22,25,13,8),(22,25,24,8),(22,25,25,11),(22,25,26,4),(22,26,17,2),(22,26,26,11),(22,27,3,2),(22,27,4,1),(22,29,12,9),(22,29,15,10),(26,1,10,12),(26,2,10,8),(26,4,3,3),(26,5,3,1),(26,5,5,3),(26,5,12,4),(26,6,20,8),(26,7,6,11),(26,7,15,5),(26,7,18,4),(26,8,13,4),(26,8,15,6),(26,8,16,2),(26,9,9,10),(26,9,20,7),(26,10,17,11),(26,11,2,5),(26,11,3,4),(26,11,20,7),(26,12,5,9),(26,12,10,2),(26,13,1,8),(26,13,10,2),(26,13,18,3),(26,13,19,2),(26,14,4,7),(26,14,19,12),(26,15,0,9),(26,15,17,6),(26,15,19,8),(26,17,0,2),(26,17,14,1),(26,18,5,4),(26,18,12,8),(26,19,0,8),(26,19,10,9),(26,20,1,7),(26,20,4,6),(26,20,5,1),(26,20,14,5),(26,21,1,11),(26,21,3,10),(26,21,9,11),(26,21,10,7),(26,21,11,2),(26,21,14,0),(26,22,1,1),(26,22,20,9),(26,23,20,4),(26,24,4,4),(26,25,4,10),(26,25,7,1),(26,26,7,3),(26,26,8,1),(26,27,0,13),(26,27,5,10),(26,28,0,5),(26,28,2,5),(26,28,12,5),(26,28,14,6),(26,29,5,6),(26,29,13,4),(26,29,17,10),(26,31,12,3),(26,31,13,9),(26,31,14,5),(26,33,0,0),(26,33,1,13),(26,33,6,0),(26,34,2,2),(26,34,5,2),(26,34,7,3),(26,34,11,13),(26,34,12,3),(31,0,1,0),(31,0,4,3),(31,0,16,11),(31,1,5,0),(31,1,10,7),(31,1,11,2),(31,1,13,9),(31,2,1,8),(31,2,10,4),(31,3,6,4),(31,3,8,4),(31,3,15,2),(31,4,0,9),(31,5,14,8),(31,5,19,3),(31,5,20,12),(31,6,10,7),(31,6,16,0),(31,6,20,6),(31,7,14,8),(31,8,6,0),(31,8,9,9),(31,9,6,7),(31,9,16,7),(31,10,15,2),(31,11,4,1),(31,12,1,4),(31,12,8,11),(31,13,10,8),(31,14,7,8),(31,14,16,11),(31,15,0,6),(31,15,3,4),(31,15,4,2),(31,15,9,4),(31,15,10,1),(31,16,10,0),(31,17,0,3),(31,17,7,1),(31,18,2,11),(31,18,7,4),(31,18,17,2),(31,19,3,2),(31,19,6,8),(31,19,7,2),(31,19,12,11),(31,19,17,0),(31,20,1,5),(31,20,7,2),(31,20,9,5),(31,20,10,5),(31,20,17,1),(31,21,3,9),(31,21,7,5),(31,22,2,4),(31,22,3,10),(31,23,1,9),(31,23,2,3),(31,23,5,5),(31,23,6,11),(31,24,3,9),(31,26,6,8),(31,26,7,13),(31,27,0,9),(31,29,7,7),(31,30,6,10),(31,30,11,7),(31,30,13,4),(31,31,4,3),(31,31,7,10),(31,32,3,2),(31,32,4,3),(31,32,5,3),(31,32,8,2),(31,33,1,2),(31,33,6,3),(31,34,9,10),(31,35,1,12),(31,35,16,10),(31,35,17,13),(31,35,21,0),(31,36,17,2),(31,36,21,1),(31,37,5,4),(31,37,7,9),(31,37,21,2),(31,39,0,6),(31,39,11,1),(31,39,17,5),(31,40,4,9),(31,40,14,1),(31,40,19,11),(31,41,10,0),(31,41,18,3),(31,41,19,7),(31,41,20,11),(31,42,10,0),(31,42,17,9),(31,42,21,13),(31,43,12,13),(31,43,20,0),(31,44,3,2),(31,44,21,4),(31,45,17,4),(31,45,19,8),(31,46,0,11),(31,46,18,11),(31,48,1,9),(31,49,20,12),(31,50,1,5),(31,50,2,9),(31,51,0,12),(31,51,7,13),(31,51,9,1),(31,51,11,13),(31,51,14,2),(31,52,2,11),(31,52,7,3),(31,52,9,10),(31,53,2,4),(31,53,3,2),(31,53,4,10),(31,53,8,2),(31,53,9,1),(31,53,14,7),(31,54,0,9),(31,54,10,3),(31,54,14,10),(31,54,15,10),(31,55,0,4),(31,55,4,8),(31,55,7,7),(31,55,8,7),(31,55,14,7),(31,56,5,13),(31,56,9,11),(31,56,10,10),(31,56,15,12),(31,56,19,4),(31,56,20,5),(52,0,8,9),(52,0,25,6),(52,0,38,10),(52,0,40,8),(52,1,21,7),(52,1,39,13),(52,1,40,11),(52,2,26,10),(52,3,35,4),(52,4,26,12),(52,5,35,2),(52,5,36,7),(52,6,28,10),(52,7,38,3),(52,8,26,1),(52,9,26,5),(52,9,27,8),(52,9,34,6),(52,9,35,2),(52,9,38,13),(52,9,39,12),(52,10,12,2),(52,10,28,7),(52,10,29,4),(52,10,33,8);
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
INSERT INTO `galaxies` VALUES (1,'2011-01-10 13:17:37','dev');
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
INSERT INTO `objectives` VALUES (1,1,'HaveUpgradedTo','Building::CollectorT1',1,1,0,0,NULL),(2,2,'HaveUpgradedTo','Building::MetalExtractor',1,1,0,0,NULL),(3,3,'HaveUpgradedTo','Building::CollectorT1',2,1,0,0,NULL),(4,3,'HaveUpgradedTo','Building::MetalExtractor',2,1,0,0,NULL),(5,22,'ExploreBlock','ExploreBlock',1,NULL,0,0,9),(6,23,'ExploreBlock','ExploreBlock',10,NULL,0,0,9),(7,4,'HaveUpgradedTo','Building::CollectorT1',2,3,0,0,NULL),(8,4,'HaveUpgradedTo','Building::MetalExtractor',2,3,0,0,NULL),(9,5,'HaveUpgradedTo','Building::CollectorT1',2,4,0,0,NULL),(10,5,'HaveUpgradedTo','Building::MetalExtractor',2,4,0,0,NULL),(11,6,'HaveUpgradedTo','Building::Barracks',1,1,0,0,NULL),(12,7,'HaveUpgradedTo','Unit::Trooper',8,1,0,0,NULL),(13,8,'DestroyNpcBuilding','Building::NpcMetalExtractor',1,1,0,0,NULL),(14,32,'HaveUpgradedTo','Building::MetalExtractor',3,4,0,0,NULL),(15,9,'HaveUpgradedTo','Building::MetalExtractor',1,7,0,0,NULL),(16,10,'HaveUpgradedTo','Building::CollectorT1',1,7,0,0,NULL),(17,11,'HaveUpgradedTo','Building::ResearchCenter',1,1,0,0,NULL),(18,24,'ExploreBlock','ExploreBlock',5,NULL,0,0,12),(19,25,'ExploreBlock','ExploreBlock',5,NULL,0,0,16),(20,26,'ExploreBlock','ExploreBlock',10,NULL,0,0,36),(21,12,'HaveUpgradedTo','Unit::Seeker',3,1,0,0,NULL),(22,13,'HaveUpgradedTo','Unit::Trooper',4,2,0,0,NULL),(23,27,'DestroyNpcBuilding','Building::NpcZetiumExtractor',1,1,0,0,NULL),(24,14,'HaveUpgradedTo','Technology::ZetiumExtraction',1,1,0,0,NULL),(25,15,'HaveUpgradedTo','Building::ZetiumExtractor',1,1,0,0,NULL),(26,16,'HavePoints','Player',1,NULL,0,0,20000),(27,28,'HavePoints','Player',1,NULL,0,0,40000),(28,29,'HavePoints','Player',1,NULL,0,0,80000),(29,30,'HavePoints','Player',1,NULL,0,0,120000),(30,33,'HavePoints','Player',1,NULL,0,0,240000),(31,17,'HaveUpgradedTo','Building::MetalStorage',1,2,0,0,NULL),(32,17,'HaveUpgradedTo','Building::EnergyStorage',1,1,0,0,NULL),(33,17,'HaveUpgradedTo','Building::ZetiumStorage',1,1,0,0,NULL),(34,18,'HaveUpgradedTo','Technology::SpaceFactory',1,1,0,0,NULL),(35,19,'HaveUpgradedTo','Building::SpaceFactory',1,1,0,0,NULL),(36,31,'HaveUpgradedTo','Unit::Crow',8,1,0,0,NULL),(37,20,'AnnexPlanet','SsObject::Planet',1,NULL,0,1,NULL),(38,21,'UpgradeTo','Building::Headquarters',1,1,0,0,NULL),(39,34,'HaveUpgradedTo','Building::Radar',1,1,0,0,NULL);
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
) ENGINE=InnoDB AUTO_INCREMENT=35 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `quests`
--

LOCK TABLES `quests` WRITE;
/*!40000 ALTER TABLE `quests` DISABLE KEYS */;
INSERT INTO `quests` VALUES (1,NULL,'{\"metal\":25.2,\"energy\":96.0}','building'),(2,1,'{\"metal\":69.3,\"energy\":140.8}','metal-extraction'),(3,2,'{\"metal\":2712.0,\"energy\":5424.0}',NULL),(4,3,'{\"metal\":412.5,\"energy\":920.7}',NULL),(5,4,'{\"metal\":401.4,\"zetium\":10.8,\"points\":4000}',NULL),(6,3,'{\"metal\":949.2,\"energy\":1898.4,\"zetium\":16.2,\"units\":[{\"level\":1,\"type\":\"Trooper\",\"count\":4,\"hp\":100}]}',NULL),(7,6,'{\"metal\":723.2,\"energy\":1446.4,\"zetium\":16.2}','building-units'),(8,7,'{\"metal\":1865.6,\"energy\":4134.9,\"zetium\":866.8,\"units\":[{\"level\":2,\"type\":\"Trooper\",\"count\":2,\"hp\":50},{\"level\":3,\"type\":\"Trooper\",\"count\":1,\"hp\":30}]}','npc-buildings'),(9,32,'{\"metal\":862.8,\"energy\":4101.6,\"zetium\":16.2,\"points\":2000}',NULL),(10,8,'{\"metal\":1725.6,\"energy\":2461.2,\"zetium\":16.2,\"points\":2000}',NULL),(11,8,'{\"metal\":1853.2,\"energy\":3706.4,\"units\":[{\"level\":1,\"type\":\"Trooper\",\"count\":4,\"hp\":100},{\"level\":1,\"type\":\"Seeker\",\"count\":2,\"hp\":100}]}','researching'),(12,11,'{\"metal\":1374.5,\"energy\":2747.6,\"points\":2000}',NULL),(13,12,'{\"metal\":692.55,\"energy\":1384.15,\"zetium\":12.35,\"points\":2000}',NULL),(14,27,'{\"metal\":39.6,\"energy\":160.8}',NULL),(15,14,'{\"metal\":3110.2,\"energy\":3038.8,\"zetium\":284.4}','extracting-zetium'),(16,15,'{\"units\":[{\"level\":3,\"type\":\"Trooper\",\"count\":1,\"hp\":100},{\"level\":2,\"type\":\"Seeker\",\"count\":1,\"hp\":100},{\"level\":1,\"type\":\"Shocker\",\"count\":3,\"hp\":100}]}','collecting-points'),(17,15,'{\"metal\":9225.6,\"energy\":12915.6,\"zetium\":646.8}','storing-resources'),(18,17,'{\"metal\":15375.2,\"energy\":21525.6,\"zetium\":1076.8}','research-space-factory'),(19,18,'{\"units\":[{\"level\":1,\"type\":\"Crow\",\"count\":4,\"hp\":100}]}',NULL),(20,31,'{\"units\":[{\"level\":1,\"type\":\"Mule\",\"count\":1,\"hp\":100},{\"level\":1,\"type\":\"Mdh\",\"count\":1,\"hp\":100}]}','annexing-planets'),(21,20,'{\"metal\":1158.5844,\"energy\":2560.7376,\"zetium\":117.99765}','colonizing'),(22,3,'{\"units\":[{\"level\":1,\"type\":\"Gnat\",\"count\":1,\"hp\":25}],\"points\":200}','exploring'),(23,22,'{\"units\":[{\"level\":1,\"type\":\"Glancer\",\"count\":1,\"hp\":60}],\"points\":1000}',NULL),(24,11,'{\"units\":[{\"level\":1,\"type\":\"Gnat\",\"count\":2,\"hp\":25},{\"level\":1,\"type\":\"Gnat\",\"count\":2,\"hp\":20},{\"level\":1,\"type\":\"Gnat\",\"count\":2,\"hp\":15},{\"level\":1,\"type\":\"Gnat\",\"count\":2,\"hp\":10}],\"points\":800}',NULL),(25,24,'{\"units\":[{\"level\":1,\"type\":\"Glancer\",\"count\":2,\"hp\":80}],\"points\":800}',NULL),(26,25,'{\"units\":[{\"level\":1,\"type\":\"Spudder\",\"count\":1,\"hp\":96}],\"points\":1600}',NULL),(27,11,'{\"metal\":396.0,\"energy\":1608.0}','zetium'),(28,16,'{\"units\":[{\"level\":2,\"type\":\"Scorpion\",\"count\":2,\"hp\":70},{\"level\":1,\"type\":\"Azure\",\"count\":1,\"hp\":100}]}',NULL),(29,28,'{\"units\":[{\"level\":2,\"type\":\"Cyrix\",\"count\":2,\"hp\":60},{\"level\":1,\"type\":\"Crow\",\"count\":4,\"hp\":100}]}',NULL),(30,29,'{\"units\":[{\"level\":1,\"type\":\"Avenger\",\"count\":4,\"hp\":100},{\"level\":1,\"type\":\"Dart\",\"count\":4,\"hp\":100}]}',NULL),(31,19,'{\"metal\":23064,\"energy\":32292,\"zetium\":1620}','space-combat'),(32,8,'{\"metal\":150.0,\"energy\":627.6,\"points\":2000}',NULL),(33,30,'{\"units\":[{\"level\":1,\"type\":\"Rhyno\",\"count\":1,\"hp\":100},{\"level\":1,\"type\":\"Cyrix\",\"count\":3,\"hp\":100}]}',NULL),(34,21,'{\"metal\":3862.4,\"energy\":25625.92,\"zetium\":524.8}','radar');
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
INSERT INTO `schema_migrations` VALUES ('20090601175224'),('20090601184051'),('20090601184055'),('20090601184059'),('20090701164131'),('20090713165021'),('20090808144214'),('20090809160211'),('20090810173759'),('20090826140238'),('20090826141836'),('20090829202538'),('20090829210029'),('20090829224505'),('20090830143959'),('20090830145319'),('20090901153809'),('20090904190655'),('20090905175341'),('20090905192056'),('20090906135044'),('20090909222719'),('20090911180950'),('20090912165229'),('20090919155819'),('20091024222359'),('20091103164416'),('20091103180558'),('20091103181146'),('20091109191211'),('20091225193714'),('20100114152902'),('20100121142414'),('20100127115341'),('20100127120219'),('20100127120515'),('20100127121337'),('20100129150736'),('20100203202757'),('20100203204803'),('20100204172507'),('20100204173714'),('20100208163239'),('20100210114531'),('20100212134334'),('20100218181507'),('20100219114448'),('20100220144106'),('20100222144003'),('20100223153023'),('20100224153728'),('20100224163525'),('20100225124928'),('20100225153721'),('20100225155505'),('20100225155739'),('20100226122144'),('20100226122651'),('20100301153626'),('20100302131225'),('20100303131706'),('20100308163148'),('20100308164422'),('20100310172315'),('20100310181338'),('20100311123523'),('20100315112858'),('20100319141401'),('20100322184529'),('20100324134243'),('20100324141652'),('20100331125702'),('20100415130556'),('20100415130600'),('20100415130605'),('20100415134627'),('20100419141518'),('20100419142018'),('20100419164230'),('20100426141509'),('20100428130912'),('20100429171200'),('20100430174140'),('20100610151652'),('20100610180750'),('20100614142225'),('20100614160819'),('20100614162423'),('20100616132525'),('20100616135507'),('20100622124252'),('20100706105523'),('20100710121447'),('20100710191351'),('20100716155807'),('20100719131622'),('20100721155359'),('20100722124307'),('20100812164444'),('20100812164449'),('20100812164518'),('20100812164524'),('20100817165213'),('20100819175736'),('20100820185846'),('20100906095758'),('20100915145823'),('20100929111549'),('20101001155323'),('20101005180058'),('20101022155620'),('20101117131430'),('20101208135417'),('20101209122838'),('20101222150446'),('20101223125157'),('20101223172333'),('20110106110617'),('99999999999000'),('99999999999900');
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
INSERT INTO `solar_systems` VALUES (1,'Expansion',1,2,2),(2,'Homeworld',1,2,0),(3,'Expansion',1,1,0),(4,'Resource',1,0,0);
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
) ENGINE=InnoDB AUTO_INCREMENT=56 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ss_objects`
--

LOCK TABLES `ss_objects` WRITE;
/*!40000 ALTER TABLE `ss_objects` DISABLE KEYS */;
INSERT INTO `ss_objects` VALUES (1,1,0,0,1,225,'Asteroid',NULL,'',53,0,0,0,4,0,0,3,0,0,5,NULL,0,NULL,NULL,NULL),(2,1,0,0,2,120,'Asteroid',NULL,'',37,0,0,0,2,0,0,2,0,0,1,NULL,0,NULL,NULL,NULL),(3,1,0,0,2,210,'Asteroid',NULL,'',49,0,0,0,1,0,0,1,0,0,2,NULL,0,NULL,NULL,NULL),(4,1,0,0,1,180,'Asteroid',NULL,'',26,0,0,0,2,0,0,2,0,0,1,NULL,0,NULL,NULL,NULL),(5,1,0,0,1,315,'Asteroid',NULL,'',51,0,0,0,2,0,0,5,0,0,2,NULL,0,NULL,NULL,NULL),(6,1,0,0,3,224,'Jumpgate',NULL,'',38,0,0,0,0,0,0,0,0,0,0,NULL,0,NULL,NULL,NULL),(7,1,0,0,1,0,'Asteroid',NULL,'',30,0,0,0,5,0,0,2,0,0,4,NULL,0,NULL,NULL,NULL),(8,1,49,25,2,150,'Planet',NULL,'P-8',56,2,0,0,0,0,0,0,0,0,0,'2011-01-10 13:17:46',0,NULL,NULL,NULL),(9,1,0,0,2,30,'Asteroid',NULL,'',36,0,0,0,4,0,0,5,0,0,5,NULL,0,NULL,NULL,NULL),(10,1,0,0,2,180,'Asteroid',NULL,'',30,0,0,0,5,0,0,4,0,0,3,NULL,0,NULL,NULL,NULL),(11,1,13,47,1,135,'Planet',NULL,'P-11',50,0,0,0,0,0,0,0,0,0,0,'2011-01-10 13:17:46',0,NULL,NULL,NULL),(12,1,0,0,0,90,'Asteroid',NULL,'',43,0,0,0,5,0,0,5,0,0,2,NULL,0,NULL,NULL,NULL),(13,1,0,0,2,330,'Asteroid',NULL,'',42,0,0,0,5,0,0,2,0,0,3,NULL,0,NULL,NULL,NULL),(14,1,0,0,0,270,'Asteroid',NULL,'',51,0,0,0,2,0,0,1,0,0,2,NULL,0,NULL,NULL,NULL),(15,1,0,0,2,0,'Asteroid',NULL,'',26,0,0,0,2,0,0,2,0,0,1,NULL,0,NULL,NULL,NULL),(16,1,0,0,2,270,'Asteroid',NULL,'',40,0,0,0,2,0,0,3,0,0,5,NULL,0,NULL,NULL,NULL),(17,1,0,0,0,180,'Asteroid',NULL,'',46,0,0,0,1,0,0,2,0,0,1,NULL,0,NULL,NULL,NULL),(18,1,0,0,2,300,'Asteroid',NULL,'',60,0,0,0,4,0,0,2,0,0,2,NULL,0,NULL,NULL,NULL),(19,1,0,0,0,0,'Asteroid',NULL,'',32,0,0,0,1,0,0,1,0,0,2,NULL,0,NULL,NULL,NULL),(20,2,0,0,2,150,'Asteroid',NULL,'',47,0,0,0,2,0,0,1,0,0,2,NULL,0,NULL,NULL,NULL),(21,2,0,0,0,90,'Asteroid',NULL,'',32,0,0,0,2,0,0,1,0,0,1,NULL,0,NULL,NULL,NULL),(22,2,30,30,1,135,'Planet',1,'P-22',50,0,3186.11,2.79,9654.87,7042.03,6.17,21339.5,0,0,2622.17,'2011-01-10 13:17:46',0,NULL,NULL,NULL),(23,2,0,0,3,336,'Jumpgate',NULL,'',59,0,0,0,0,0,0,0,0,0,0,NULL,0,NULL,NULL,NULL),(24,2,0,0,0,270,'Asteroid',NULL,'',54,0,0,0,2,0,0,1,0,0,2,NULL,0,NULL,NULL,NULL),(25,2,0,0,1,315,'Asteroid',NULL,'',25,0,0,0,1,0,0,1,0,0,2,NULL,0,NULL,NULL,NULL),(26,2,35,21,2,240,'Planet',NULL,'P-26',48,1,0,0,0,0,0,0,0,0,0,'2011-01-10 13:17:46',0,NULL,NULL,NULL),(27,2,0,0,2,300,'Asteroid',NULL,'',58,0,0,0,1,0,0,1,0,0,2,NULL,0,NULL,NULL,NULL),(28,3,0,0,2,90,'Asteroid',NULL,'',38,0,0,0,3,0,0,2,0,0,4,NULL,0,NULL,NULL,NULL),(29,3,0,0,2,120,'Asteroid',NULL,'',49,0,0,0,1,0,0,2,0,0,1,NULL,0,NULL,NULL,NULL),(30,3,0,0,3,22,'Jumpgate',NULL,'',59,0,0,0,0,0,0,0,0,0,0,NULL,0,NULL,NULL,NULL),(31,3,57,22,2,240,'Planet',NULL,'P-31',58,0,0,0,0,0,0,0,0,0,0,'2011-01-10 13:17:46',0,NULL,NULL,NULL),(32,3,0,0,1,315,'Asteroid',NULL,'',40,0,0,0,2,0,0,3,0,0,5,NULL,0,NULL,NULL,NULL),(33,3,0,0,1,0,'Asteroid',NULL,'',30,0,0,0,2,0,0,1,0,0,2,NULL,0,NULL,NULL,NULL),(34,3,0,0,2,150,'Asteroid',NULL,'',25,0,0,0,2,0,0,1,0,0,1,NULL,0,NULL,NULL,NULL),(35,3,0,0,0,90,'Asteroid',NULL,'',45,0,0,0,2,0,0,2,0,0,2,NULL,0,NULL,NULL,NULL),(36,3,0,0,1,135,'Asteroid',NULL,'',55,0,0,0,2,0,0,2,0,0,5,NULL,0,NULL,NULL,NULL),(37,3,0,0,2,180,'Asteroid',NULL,'',46,0,0,0,3,0,0,3,0,0,3,NULL,0,NULL,NULL,NULL),(38,3,0,0,2,330,'Asteroid',NULL,'',41,0,0,0,3,0,0,3,0,0,5,NULL,0,NULL,NULL,NULL),(39,3,0,0,0,270,'Asteroid',NULL,'',60,0,0,0,1,0,0,2,0,0,2,NULL,0,NULL,NULL,NULL),(40,3,0,0,2,0,'Asteroid',NULL,'',58,0,0,0,2,0,0,5,0,0,5,NULL,0,NULL,NULL,NULL),(41,3,0,0,2,270,'Asteroid',NULL,'',45,0,0,0,5,0,0,5,0,0,3,NULL,0,NULL,NULL,NULL),(42,3,0,0,0,180,'Asteroid',NULL,'',26,0,0,0,2,0,0,1,0,0,2,NULL,0,NULL,NULL,NULL),(43,3,0,0,2,300,'Asteroid',NULL,'',36,0,0,0,5,0,0,2,0,0,5,NULL,0,NULL,NULL,NULL),(44,4,0,0,1,45,'Asteroid',NULL,'',27,0,0,0,2,0,0,2,0,0,2,NULL,0,NULL,NULL,NULL),(45,4,0,0,2,90,'Asteroid',NULL,'',51,0,0,0,3,0,0,3,0,0,4,NULL,0,NULL,NULL,NULL),(46,4,0,0,0,90,'Asteroid',NULL,'',27,0,0,0,5,0,0,2,0,0,5,NULL,0,NULL,NULL,NULL),(47,4,0,0,1,135,'Asteroid',NULL,'',37,0,0,0,3,0,0,2,0,0,5,NULL,0,NULL,NULL,NULL),(48,4,0,0,3,22,'Jumpgate',NULL,'',27,0,0,0,0,0,0,0,0,0,0,NULL,0,NULL,NULL,NULL),(49,4,0,0,3,336,'Jumpgate',NULL,'',43,0,0,0,0,0,0,0,0,0,0,NULL,0,NULL,NULL,NULL),(50,4,0,0,0,270,'Asteroid',NULL,'',45,0,0,0,3,0,0,3,0,0,2,NULL,0,NULL,NULL,NULL),(51,4,0,0,2,0,'Asteroid',NULL,'',55,0,0,0,3,0,0,5,0,0,2,NULL,0,NULL,NULL,NULL),(52,4,11,43,1,315,'Planet',NULL,'P-52',47,2,0,0,0,0,0,0,0,0,0,'2011-01-10 13:17:46',0,NULL,NULL,NULL),(53,4,0,0,3,224,'Jumpgate',NULL,'',50,0,0,0,0,0,0,0,0,0,0,NULL,0,NULL,NULL,NULL),(54,4,0,0,2,60,'Asteroid',NULL,'',31,0,0,0,2,0,0,3,0,0,4,NULL,0,NULL,NULL,NULL),(55,4,0,0,1,0,'Asteroid',NULL,'',49,0,0,0,2,0,0,5,0,0,5,NULL,0,NULL,NULL,NULL);
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
INSERT INTO `tiles` VALUES (3,8,0,0),(3,8,0,1),(3,8,0,2),(3,8,0,3),(3,8,0,18),(3,8,0,19),(3,8,0,20),(3,8,0,23),(3,8,1,0),(3,8,1,1),(3,8,1,2),(0,8,1,3),(3,8,1,18),(3,8,1,19),(3,8,1,20),(3,8,1,21),(3,8,1,22),(3,8,1,23),(3,8,1,24),(3,8,2,0),(3,8,2,1),(3,8,2,2),(3,8,2,7),(3,8,2,16),(3,8,2,17),(3,8,2,18),(3,8,2,19),(3,8,2,20),(3,8,2,21),(3,8,2,22),(3,8,2,23),(3,8,2,24),(3,8,3,0),(3,8,3,1),(3,8,3,2),(3,8,3,3),(3,8,3,4),(3,8,3,5),(3,8,3,7),(3,8,3,8),(3,8,3,9),(3,8,3,15),(3,8,3,16),(3,8,3,17),(3,8,3,18),(3,8,3,19),(3,8,3,20),(3,8,3,21),(3,8,3,22),(3,8,3,23),(3,8,3,24),(3,8,4,0),(3,8,4,1),(3,8,4,2),(3,8,4,3),(3,8,4,4),(3,8,4,5),(3,8,4,6),(3,8,4,7),(3,8,4,8),(3,8,4,9),(8,8,4,10),(3,8,4,14),(3,8,4,15),(3,8,4,16),(3,8,4,17),(3,8,4,18),(3,8,4,19),(3,8,4,20),(3,8,4,21),(3,8,4,22),(3,8,4,23),(3,8,4,24),(3,8,5,0),(3,8,5,1),(3,8,5,2),(3,8,5,3),(3,8,5,4),(3,8,5,5),(3,8,5,6),(3,8,5,7),(3,8,5,8),(3,8,5,14),(3,8,5,15),(3,8,5,16),(0,8,5,17),(3,8,5,19),(3,8,5,20),(3,8,5,21),(3,8,5,22),(3,8,5,23),(3,8,5,24),(3,8,6,0),(3,8,6,1),(3,8,6,2),(3,8,6,3),(3,8,6,4),(3,8,6,5),(3,8,6,6),(3,8,6,7),(3,8,6,8),(3,8,6,9),(5,8,6,15),(3,8,6,16),(3,8,6,19),(3,8,6,20),(3,8,6,21),(3,8,6,22),(3,8,6,23),(3,8,6,24),(3,8,7,0),(3,8,7,1),(3,8,7,2),(3,8,7,3),(3,8,7,4),(3,8,7,5),(3,8,7,6),(3,8,7,7),(5,8,7,12),(5,8,7,13),(5,8,7,14),(5,8,7,15),(5,8,7,16),(3,8,7,17),(3,8,7,18),(3,8,7,19),(3,8,7,20),(3,8,7,21),(3,8,7,22),(3,8,7,23),(3,8,7,24),(3,8,8,1),(3,8,8,2),(3,8,8,3),(6,8,8,4),(6,8,8,5),(3,8,8,6),(3,8,8,7),(5,8,8,12),(5,8,8,13),(5,8,8,14),(3,8,8,19),(3,8,8,20),(3,8,8,21),(5,8,8,22),(3,8,8,23),(3,8,8,24),(3,8,9,2),(6,8,9,3),(6,8,9,4),(6,8,9,5),(6,8,9,6),(3,8,9,7),(5,8,9,12),(5,8,9,14),(5,8,9,19),(5,8,9,20),(5,8,9,21),(5,8,9,22),(5,8,9,23),(5,8,9,24),(8,8,10,0),(6,8,10,3),(6,8,10,4),(3,8,10,5),(3,8,10,6),(3,8,10,7),(6,8,10,19),(5,8,10,22),(5,8,10,23),(6,8,11,4),(3,8,11,5),(12,8,11,6),(6,8,11,19),(6,8,11,20),(5,8,11,23),(3,8,12,4),(3,8,12,5),(6,8,12,19),(6,8,12,20),(6,8,12,21),(5,8,12,23),(11,8,13,0),(6,8,13,19),(6,8,14,19),(9,8,15,16),(6,8,15,19),(11,8,18,7),(4,8,18,21),(4,8,18,22),(4,8,18,23),(4,8,19,21),(4,8,19,23),(4,8,19,24),(4,8,20,20),(4,8,20,21),(4,8,20,22),(4,8,20,23),(4,8,20,24),(4,8,21,20),(4,8,21,21),(4,8,21,22),(4,8,21,23),(4,8,21,24),(4,8,22,22),(4,8,22,23),(4,8,22,24),(4,8,23,23),(4,8,23,24),(4,8,24,1),(4,8,24,2),(4,8,24,3),(2,8,24,14),(4,8,25,1),(4,8,25,2),(4,8,25,3),(4,8,25,4),(4,8,25,5),(0,8,25,10),(4,8,26,1),(4,8,26,2),(4,8,26,3),(4,8,26,4),(4,8,26,5),(6,8,26,23),(6,8,26,24),(4,8,27,1),(4,8,27,2),(4,8,27,3),(4,8,27,4),(4,8,27,5),(6,8,27,21),(6,8,27,22),(6,8,27,23),(4,8,28,2),(6,8,28,3),(4,8,28,4),(4,8,28,5),(10,8,28,8),(6,8,28,21),(6,8,28,22),(6,8,29,2),(6,8,29,3),(2,8,29,4),(6,8,29,22),(6,8,29,23),(6,8,30,1),(6,8,30,2),(6,8,30,3),(6,8,31,2),(6,8,32,2),(6,8,33,2),(5,8,35,1),(0,8,35,13),(5,8,36,1),(5,8,36,2),(5,8,36,3),(5,8,37,0),(5,8,37,1),(5,8,37,2),(5,8,37,3),(4,8,38,0),(4,8,38,1),(5,8,38,2),(5,8,38,3),(9,8,38,12),(4,8,39,0),(4,8,39,2),(5,8,39,3),(4,8,39,20),(4,8,39,21),(4,8,40,0),(4,8,40,1),(4,8,40,2),(4,8,40,3),(4,8,40,20),(4,8,40,21),(4,8,41,0),(4,8,41,2),(4,8,41,3),(4,8,41,4),(4,8,41,5),(4,8,41,15),(4,8,41,16),(4,8,41,17),(4,8,41,19),(4,8,41,20),(4,8,41,21),(4,8,42,0),(0,8,42,1),(4,8,42,3),(4,8,42,16),(4,8,42,17),(4,8,42,18),(4,8,42,19),(0,8,42,20),(5,8,43,0),(4,8,43,3),(4,8,43,4),(1,8,43,8),(4,8,43,15),(4,8,43,16),(4,8,43,17),(4,8,43,18),(5,8,44,0),(4,8,44,1),(4,8,44,2),(4,8,44,3),(4,8,44,16),(4,8,44,18),(5,8,45,0),(5,8,45,1),(5,8,45,2),(4,8,45,3),(5,8,45,16),(5,8,45,17),(4,8,45,18),(5,8,46,0),(5,8,46,1),(5,8,46,2),(5,8,46,3),(6,8,46,4),(5,8,46,16),(5,8,46,17),(5,8,46,18),(5,8,46,19),(14,8,46,21),(5,8,47,0),(6,8,47,1),(6,8,47,2),(6,8,47,3),(6,8,47,4),(5,8,47,17),(5,8,47,18),(5,8,47,19),(5,8,48,0),(6,8,48,1),(6,8,48,2),(6,8,48,3),(6,8,48,4),(5,8,48,18),(5,8,48,19),(4,11,0,0),(4,11,0,1),(4,11,0,2),(4,11,0,3),(3,11,0,15),(3,11,0,16),(3,11,0,17),(3,11,0,18),(3,11,0,19),(3,11,0,20),(3,11,0,21),(3,11,0,22),(3,11,0,23),(4,11,0,26),(4,11,0,27),(4,11,0,28),(4,11,0,29),(4,11,0,30),(4,11,0,31),(4,11,0,32),(6,11,0,38),(5,11,0,40),(5,11,0,42),(5,11,0,43),(4,11,1,0),(4,11,1,1),(4,11,1,2),(3,11,1,15),(3,11,1,16),(3,11,1,17),(3,11,1,18),(3,11,1,19),(0,11,1,20),(3,11,1,22),(3,11,1,23),(3,11,1,24),(4,11,1,27),(4,11,1,28),(4,11,1,29),(4,11,1,30),(4,11,1,31),(4,11,1,32),(6,11,1,38),(5,11,1,40),(5,11,1,41),(5,11,1,42),(6,11,1,44),(6,11,1,45),(6,11,1,46),(4,11,2,0),(4,11,2,1),(4,11,2,2),(3,11,2,16),(3,11,2,17),(3,11,2,22),(3,11,2,23),(6,11,2,26),(6,11,2,27),(4,11,2,28),(4,11,2,29),(4,11,2,30),(4,11,2,31),(4,11,2,32),(4,11,2,33),(6,11,2,37),(6,11,2,38),(6,11,2,39),(5,11,2,40),(5,11,2,41),(5,11,2,42),(5,11,2,43),(6,11,2,45),(6,11,2,46),(4,11,3,0),(4,11,3,3),(4,11,3,5),(13,11,3,14),(3,11,3,16),(3,11,3,21),(3,11,3,22),(0,11,3,25),(6,11,3,27),(4,11,3,30),(4,11,3,31),(4,11,3,32),(4,11,3,33),(5,11,3,41),(5,11,3,43),(6,11,3,44),(6,11,3,45),(5,11,3,46),(4,11,4,0),(4,11,4,1),(4,11,4,2),(4,11,4,3),(4,11,4,4),(4,11,4,5),(5,11,4,10),(3,11,4,22),(3,11,4,23),(6,11,4,27),(4,11,4,29),(4,11,4,30),(4,11,4,31),(4,11,4,32),(4,11,4,33),(4,11,4,34),(5,11,4,43),(6,11,4,44),(6,11,4,45),(6,11,4,46),(4,11,5,0),(4,11,5,1),(4,11,5,5),(5,11,5,9),(5,11,5,10),(5,11,5,11),(6,11,5,27),(4,11,5,29),(4,11,5,30),(4,11,5,31),(4,11,5,33),(4,11,5,34),(5,11,5,43),(5,11,6,0),(5,11,6,1),(0,11,6,2),(4,11,6,4),(4,11,6,5),(2,11,6,6),(5,11,6,8),(5,11,6,9),(0,11,6,11),(4,11,6,30),(4,11,6,31),(4,11,6,32),(4,11,6,33),(13,11,6,35),(12,11,6,38),(5,11,7,0),(5,11,7,1),(5,11,7,8),(5,11,7,9),(5,11,7,10),(10,11,7,26),(4,11,7,30),(4,11,7,31),(4,11,7,32),(5,11,8,0),(5,11,8,1),(5,11,8,2),(5,11,8,3),(5,11,8,4),(3,11,8,6),(5,11,8,9),(5,11,8,10),(5,11,8,11),(5,11,8,12),(5,11,8,13),(4,11,8,30),(4,11,8,32),(5,11,9,0),(5,11,9,1),(5,11,9,2),(3,11,9,5),(3,11,9,6),(3,11,9,7),(4,11,9,32),(5,11,10,2),(3,11,10,5),(3,11,10,6),(3,11,10,7),(0,11,10,13),(2,11,10,17),(4,11,10,30),(4,11,10,31),(4,11,10,32),(3,11,10,33),(3,11,10,34),(3,11,10,37),(6,11,10,44),(5,11,11,2),(3,11,11,5),(3,11,11,6),(3,11,11,7),(4,11,11,31),(3,11,11,34),(3,11,11,37),(6,11,11,44),(3,11,12,4),(3,11,12,5),(3,11,12,6),(3,11,12,33),(3,11,12,34),(3,11,12,35),(3,11,12,36),(3,11,12,37),(3,11,12,38),(3,11,12,39),(3,11,12,40),(6,11,12,43),(6,11,12,44),(6,11,12,45),(0,22,0,0),(5,22,0,3),(5,22,0,4),(5,22,0,5),(5,22,0,6),(5,22,0,7),(5,22,0,8),(5,22,0,9),(5,22,0,10),(5,22,0,11),(5,22,0,12),(5,22,0,13),(5,22,0,14),(5,22,0,26),(5,22,0,27),(5,22,0,28),(5,22,0,29),(5,22,1,3),(11,22,1,4),(5,22,1,11),(5,22,1,12),(5,22,1,13),(13,22,1,16),(4,22,1,19),(4,22,1,20),(4,22,1,21),(4,22,1,22),(5,22,1,26),(5,22,1,27),(5,22,1,28),(5,22,1,29),(5,22,2,2),(5,22,2,3),(5,22,2,10),(5,22,2,12),(5,22,2,13),(5,22,2,14),(5,22,2,15),(4,22,2,20),(4,22,2,21),(4,22,2,22),(4,22,2,23),(5,22,2,27),(5,22,2,28),(5,22,2,29),(0,22,3,1),(5,22,3,10),(5,22,3,11),(5,22,3,12),(5,22,3,13),(5,22,3,14),(4,22,3,20),(4,22,3,21),(4,22,3,22),(4,22,3,23),(4,22,3,24),(5,22,3,28),(5,22,3,29),(5,22,4,12),(5,22,4,13),(6,22,4,18),(4,22,4,21),(4,22,4,22),(4,22,4,23),(5,22,4,26),(5,22,4,27),(5,22,4,28),(6,22,5,8),(6,22,5,9),(6,22,5,18),(6,22,5,19),(4,22,5,22),(4,22,5,23),(4,22,5,24),(5,22,5,26),(5,22,5,27),(6,22,6,7),(6,22,6,8),(6,22,6,9),(6,22,6,11),(6,22,6,18),(6,22,6,19),(6,22,7,9),(6,22,7,10),(6,22,7,18),(12,22,7,23),(6,22,8,9),(6,22,8,10),(6,22,8,16),(6,22,8,17),(6,22,8,18),(3,22,9,3),(3,22,9,4),(6,22,9,9),(6,22,9,15),(6,22,9,16),(6,22,9,17),(3,22,10,0),(3,22,10,2),(3,22,10,3),(3,22,10,4),(8,22,10,5),(6,22,10,16),(6,22,10,17),(0,22,10,20),(3,22,11,0),(3,22,11,1),(3,22,11,2),(3,22,11,3),(3,22,12,0),(3,22,12,1),(3,22,12,2),(3,22,13,0),(3,22,13,1),(3,22,13,2),(3,22,13,4),(3,22,14,0),(3,22,14,1),(3,22,14,2),(3,22,14,3),(3,22,14,4),(3,22,15,0),(3,22,15,1),(3,22,15,2),(3,22,15,3),(3,22,15,4),(3,22,16,0),(3,22,16,1),(3,22,16,2),(3,22,16,3),(5,22,16,29),(3,22,17,0),(3,22,17,1),(3,22,17,2),(3,22,17,3),(3,22,17,4),(5,22,17,28),(5,22,17,29),(3,22,18,0),(3,22,18,1),(3,22,18,2),(3,22,18,3),(3,22,18,4),(3,22,18,5),(0,22,18,23),(5,22,18,28),(5,22,18,29),(3,22,19,0),(3,22,19,1),(3,22,19,2),(3,22,19,3),(3,22,19,4),(3,22,19,5),(5,22,19,29),(3,22,20,0),(3,22,20,1),(3,22,20,2),(3,22,20,3),(3,22,20,4),(3,22,20,5),(5,22,20,28),(5,22,20,29),(3,22,21,0),(3,22,21,1),(3,22,21,2),(3,22,21,3),(3,22,21,4),(5,22,21,29),(3,22,22,0),(3,22,22,1),(3,22,22,2),(14,22,22,25),(5,22,22,29),(3,22,23,0),(3,22,23,1),(3,22,23,2),(3,22,23,3),(4,22,23,9),(5,22,23,29),(3,22,24,1),(3,22,24,2),(0,22,24,4),(4,22,24,7),(4,22,24,8),(4,22,24,9),(4,22,24,10),(4,22,24,11),(5,22,24,29),(4,22,25,7),(4,22,25,8),(4,22,25,9),(4,22,25,10),(5,22,25,27),(5,22,25,29),(4,22,26,6),(4,22,26,7),(4,22,26,8),(4,22,26,9),(4,22,26,10),(2,22,26,12),(6,22,26,22),(6,22,26,23),(5,22,26,27),(5,22,26,28),(5,22,26,29),(4,22,27,5),(4,22,27,6),(4,22,27,7),(4,22,27,8),(4,22,27,9),(4,22,27,10),(5,22,27,17),(5,22,27,18),(5,22,27,21),(5,22,27,22),(6,22,27,23),(6,22,27,24),(0,22,28,4),(4,22,28,6),(4,22,28,7),(4,22,28,8),(4,22,28,9),(4,22,28,10),(5,22,28,15),(5,22,28,16),(5,22,28,17),(5,22,28,18),(5,22,28,19),(5,22,28,21),(5,22,28,22),(6,22,28,23),(6,22,28,24),(5,22,28,25),(5,22,28,26),(5,22,28,27),(5,22,28,28),(4,22,29,7),(4,22,29,8),(4,22,29,9),(4,22,29,10),(4,22,29,11),(5,22,29,16),(5,22,29,17),(5,22,29,18),(5,22,29,19),(5,22,29,20),(5,22,29,21),(5,22,29,22),(6,22,29,23),(6,22,29,24),(6,22,29,25),(6,22,29,26),(5,22,29,27),(3,26,0,0),(3,26,0,1),(3,26,0,2),(3,26,0,3),(4,26,0,4),(4,26,0,5),(4,26,0,6),(4,26,0,7),(3,26,0,17),(3,26,0,18),(3,26,1,0),(4,26,1,1),(4,26,1,2),(4,26,1,3),(4,26,1,4),(4,26,1,6),(0,26,1,13),(3,26,1,16),(3,26,1,17),(3,26,1,18),(3,26,2,0),(3,26,2,1),(4,26,2,2),(4,26,2,3),(4,26,2,4),(4,26,2,5),(4,26,2,6),(3,26,2,16),(3,26,2,17),(3,26,2,18),(3,26,2,19),(3,26,3,0),(3,26,3,1),(4,26,3,2),(4,26,3,6),(4,26,3,7),(4,26,3,8),(4,26,3,9),(3,26,3,17),(3,26,4,0),(3,26,4,1),(3,26,4,2),(4,26,4,8),(4,26,4,9),(4,26,4,10),(4,26,4,11),(4,26,4,12),(3,26,4,17),(3,26,4,18),(3,26,5,1),(3,26,5,2),(4,26,5,9),(4,26,5,10),(3,26,5,18),(3,26,5,19),(6,26,6,2),(6,26,6,6),(6,26,6,7),(4,26,6,8),(4,26,6,9),(4,26,6,10),(4,26,6,11),(6,26,7,1),(6,26,7,2),(6,26,7,3),(6,26,7,7),(6,26,7,8),(6,26,7,9),(4,26,7,10),(4,26,7,11),(3,26,8,0),(6,26,8,1),(3,26,8,2),(3,26,8,3),(3,26,8,4),(0,26,8,7),(4,26,8,10),(4,26,8,11),(3,26,9,0),(3,26,9,1),(3,26,9,2),(3,26,9,3),(3,26,9,4),(6,26,9,5),(5,26,9,10),(5,26,9,11),(5,26,9,12),(5,26,9,13),(3,26,10,0),(3,26,10,2),(6,26,10,3),(6,26,10,4),(6,26,10,5),(6,26,10,6),(5,26,10,7),(5,26,10,8),(5,26,10,9),(5,26,10,10),(5,26,10,11),(5,26,10,12),(5,26,10,13),(5,26,10,14),(5,26,10,15),(3,26,11,0),(3,26,11,1),(5,26,11,4),(5,26,11,5),(5,26,11,6),(5,26,11,7),(5,26,11,8),(6,26,11,9),(5,26,11,10),(12,26,11,11),(3,26,12,1),(5,26,12,4),(6,26,12,6),(6,26,12,8),(6,26,12,9),(6,26,13,6),(6,26,13,7),(6,26,13,8),(6,26,13,9),(2,26,14,2),(6,26,14,7),(6,26,14,9),(1,26,15,8),(5,26,16,7),(5,26,16,10),(3,26,16,17),(3,26,16,18),(3,26,16,19),(5,26,17,6),(5,26,17,7),(5,26,17,8),(5,26,17,9),(5,26,17,10),(5,26,17,11),(5,26,17,12),(3,26,17,17),(3,26,17,18),(5,26,18,6),(5,26,18,7),(5,26,18,8),(5,26,18,9),(5,26,18,10),(5,26,18,11),(3,26,18,18),(5,26,19,7),(5,26,19,9),(5,26,19,11),(0,26,19,12),(3,26,19,17),(3,26,19,18),(3,26,19,19),(3,26,19,20),(5,26,20,7),(3,26,20,18),(3,26,20,19),(3,26,20,20),(13,26,21,5),(5,26,21,7),(3,26,21,19),(14,26,22,16),(4,26,25,15),(4,26,26,12),(4,26,26,13),(4,26,26,14),(4,26,26,15),(4,26,26,16),(4,26,26,18),(12,26,27,6),(4,26,27,12),(4,26,27,14),(4,26,27,15),(4,26,27,16),(4,26,27,17),(4,26,27,18),(4,26,28,15),(4,26,28,16),(2,26,28,18),(4,26,29,15),(4,26,29,16),(5,26,30,15),(5,26,30,17),(5,26,30,18),(5,26,30,19),(5,26,30,20),(5,26,31,15),(5,26,31,16),(5,26,31,17),(5,26,31,18),(5,26,31,19),(5,26,31,20),(0,26,32,3),(8,26,32,15),(5,26,32,18),(5,26,32,19),(5,26,32,20),(5,26,33,18),(5,26,33,19),(5,26,33,20),(5,26,34,18),(5,26,34,19),(5,26,34,20),(8,31,0,6),(5,31,0,15),(5,31,1,14),(5,31,1,15),(5,31,1,17),(5,31,1,18),(5,31,1,19),(5,31,1,20),(4,31,2,11),(5,31,2,14),(5,31,2,15),(5,31,2,16),(5,31,2,17),(5,31,2,18),(5,31,2,19),(5,31,2,20),(4,31,3,9),(4,31,3,10),(4,31,3,11),(5,31,3,16),(5,31,3,17),(5,31,3,19),(5,31,3,20),(5,31,3,21),(5,31,4,2),(4,31,4,6),(4,31,4,8),(4,31,4,9),(4,31,4,10),(5,31,4,13),(5,31,4,14),(5,31,4,15),(5,31,4,16),(5,31,4,17),(5,31,5,2),(5,31,5,4),(5,31,5,5),(4,31,5,6),(4,31,5,8),(4,31,5,9),(4,31,5,10),(4,31,5,11),(5,31,5,13),(5,31,6,0),(5,31,6,1),(5,31,6,2),(5,31,6,3),(5,31,6,4),(4,31,6,5),(4,31,6,6),(4,31,6,7),(4,31,6,8),(4,31,6,9),(4,31,6,17),(4,31,6,19),(5,31,7,0),(5,31,7,1),(5,31,7,2),(5,31,7,3),(5,31,7,4),(5,31,7,5),(5,31,7,6),(4,31,7,7),(4,31,7,8),(4,31,7,9),(4,31,7,10),(4,31,7,15),(4,31,7,16),(4,31,7,17),(4,31,7,18),(4,31,7,19),(5,31,8,0),(5,31,8,1),(5,31,8,3),(5,31,8,4),(5,31,8,5),(4,31,8,7),(4,31,8,8),(4,31,8,17),(4,31,8,19),(4,31,8,20),(4,31,8,21),(5,31,9,0),(5,31,9,1),(5,31,9,5),(4,31,9,7),(1,31,9,10),(4,31,9,17),(4,31,9,18),(4,31,9,19),(4,31,9,20),(4,31,9,21),(5,31,10,5),(6,31,10,9),(6,31,10,12),(6,31,10,13),(4,31,10,17),(4,31,10,19),(4,31,10,20),(4,31,10,21),(5,31,11,3),(5,31,11,5),(5,31,11,7),(6,31,11,8),(6,31,11,9),(6,31,11,10),(6,31,11,11),(6,31,11,12),(6,31,11,13),(6,31,11,14),(4,31,11,15),(4,31,11,16),(4,31,11,17),(4,31,11,19),(4,31,11,20),(5,31,12,3),(5,31,12,4),(5,31,12,5),(5,31,12,6),(5,31,12,7),(6,31,12,10),(6,31,12,11),(6,31,12,12),(8,31,12,13),(5,31,13,1),(5,31,13,2),(5,31,13,3),(5,31,13,4),(5,31,13,7),(5,31,14,1),(5,31,14,2),(5,31,14,3),(5,31,14,4),(5,31,14,5),(5,31,15,2),(5,31,15,5),(5,31,15,6),(5,31,16,5),(5,31,16,6),(5,31,17,5),(5,31,17,6),(14,31,17,8),(9,31,17,14),(9,31,17,18),(3,31,17,21),(2,31,18,4),(3,31,18,21),(3,31,19,21),(5,31,20,4),(4,31,20,11),(3,31,20,21),(5,31,21,4),(4,31,21,11),(4,31,21,12),(10,31,21,14),(4,31,21,18),(4,31,21,19),(4,31,21,20),(4,31,21,21),(5,31,22,4),(4,31,22,11),(4,31,22,12),(4,31,22,13),(4,31,22,19),(4,31,22,20),(4,31,22,21),(5,31,23,3),(5,31,23,4),(4,31,23,11),(4,31,23,12),(4,31,23,13),(4,31,23,18),(4,31,23,19),(4,31,23,20),(4,31,23,21),(5,31,24,0),(5,31,24,2),(5,31,24,4),(5,31,24,5),(5,31,24,6),(4,31,24,11),(4,31,24,12),(4,31,24,13),(4,31,24,18),(4,31,24,19),(4,31,24,20),(4,31,24,21),(5,31,25,0),(5,31,25,1),(5,31,25,2),(5,31,25,3),(5,31,25,4),(5,31,25,5),(5,31,25,6),(4,31,25,11),(4,31,25,12),(4,31,25,13),(4,31,25,14),(4,31,25,16),(4,31,25,17),(4,31,25,18),(4,31,25,19),(4,31,25,20),(4,31,25,21),(5,31,26,0),(5,31,26,2),(5,31,26,4),(5,31,26,5),(11,31,26,8),(4,31,26,14),(4,31,26,15),(4,31,26,16),(4,31,26,17),(4,31,26,18),(4,31,26,19),(4,31,26,20),(5,31,27,4),(5,31,27,5),(4,31,27,15),(3,31,27,16),(3,31,27,17),(4,31,27,18),(4,31,27,19),(4,31,27,20),(5,31,28,5),(3,31,28,15),(3,31,28,16),(3,31,28,17),(3,31,28,18),(3,31,28,19),(4,31,28,20),(4,31,28,21),(5,31,29,5),(3,31,29,14),(3,31,29,15),(3,31,29,16),(3,31,29,17),(3,31,29,18),(3,31,29,19),(3,31,29,20),(3,31,29,21),(3,31,30,12),(3,31,30,15),(3,31,30,16),(3,31,30,17),(3,31,30,18),(3,31,30,19),(3,31,30,20),(3,31,30,21),(6,31,31,2),(3,31,31,10),(3,31,31,11),(3,31,31,12),(11,31,31,16),(6,31,32,0),(6,31,32,1),(6,31,32,2),(3,31,32,9),(3,31,32,10),(3,31,32,11),(3,31,32,12),(3,31,32,13),(3,31,32,14),(6,31,33,2),(6,31,33,3),(3,31,33,9),(3,31,33,11),(3,31,33,12),(3,31,33,13),(3,31,33,14),(3,31,33,15),(6,31,34,1),(6,31,34,2),(6,31,34,3),(14,31,34,4),(3,31,34,10),(3,31,34,11),(3,31,34,12),(3,31,34,13),(6,31,35,2),(6,31,35,3),(3,31,35,10),(3,31,35,11),(3,31,35,12),(3,31,35,13),(6,31,36,2),(6,31,36,3),(3,31,36,9),(3,31,36,10),(3,31,36,11),(3,31,36,12),(3,31,36,13),(0,31,37,1),(5,31,37,3),(5,31,37,4),(5,31,37,6),(3,31,37,8),(3,31,37,9),(3,31,37,10),(3,31,37,11),(3,31,37,12),(3,31,37,13),(3,31,37,14),(3,31,37,15),(5,31,38,3),(5,31,38,4),(5,31,38,5),(5,31,38,6),(5,31,38,7),(2,31,38,8),(3,31,38,10),(3,31,38,11),(3,31,38,12),(3,31,38,13),(3,31,38,14),(5,31,39,1),(5,31,39,2),(5,31,39,3),(5,31,39,4),(5,31,39,5),(5,31,39,6),(5,31,39,7),(5,31,39,10),(3,31,39,12),(3,31,39,14),(5,31,40,2),(5,31,40,5),(5,31,40,6),(5,31,40,7),(5,31,40,8),(5,31,40,9),(5,31,40,10),(5,31,40,11),(5,31,41,2),(12,31,41,4),(13,31,43,10),(3,31,45,2),(3,31,46,2),(3,31,46,3),(3,31,46,12),(3,31,46,13),(3,31,46,14),(3,31,46,15),(3,31,46,16),(3,31,47,1),(3,31,47,2),(3,31,47,3),(3,31,47,4),(3,31,47,5),(6,31,47,6),(6,31,47,7),(6,31,47,8),(6,31,47,9),(3,31,47,12),(3,31,47,13),(3,31,47,14),(3,31,47,15),(3,31,47,16),(3,31,47,17),(3,31,48,2),(3,31,48,3),(3,31,48,4),(3,31,48,5),(6,31,48,6),(6,31,48,7),(6,31,48,8),(3,31,48,12),(3,31,48,13),(3,31,48,14),(3,31,48,15),(0,31,48,18),(3,31,49,2),(3,31,49,3),(3,31,49,4),(3,31,49,5),(6,31,49,6),(6,31,49,7),(6,31,49,8),(6,31,49,9),(3,31,49,11),(3,31,49,12),(3,31,49,13),(3,31,49,14),(3,31,50,4),(3,31,50,5),(6,31,50,9),(6,31,50,10),(3,31,50,11),(3,31,50,12),(3,31,50,13),(3,31,50,14),(3,31,51,3),(3,31,51,4),(3,31,51,5),(3,31,51,12),(6,31,51,16),(6,31,51,19),(6,31,51,21),(3,31,52,3),(0,31,52,5),(6,31,52,15),(6,31,52,16),(6,31,52,17),(6,31,52,18),(6,31,52,19),(6,31,52,20),(6,31,52,21),(0,31,53,11),(6,31,53,16),(6,31,53,17),(6,31,53,18),(6,31,53,19),(6,31,53,21),(6,31,54,16),(6,31,54,17),(6,31,54,18),(6,31,54,19),(6,31,54,20),(6,31,54,21),(6,31,55,16),(6,31,55,18),(6,31,55,19),(6,31,55,20),(6,31,55,21),(11,52,0,0),(9,52,0,9),(3,52,0,12),(12,52,0,13),(4,52,0,29),(4,52,0,30),(4,52,0,31),(5,52,0,32),(5,52,0,33),(9,52,1,6),(3,52,1,12),(10,52,1,22),(4,52,1,30),(5,52,1,31),(5,52,1,32),(5,52,1,33),(5,52,1,34),(6,52,1,38),(3,52,2,12),(5,52,2,31),(0,52,2,32),(5,52,2,34),(2,52,2,36),(6,52,2,38),(6,52,2,39),(3,52,3,12),(5,52,3,30),(5,52,3,31),(6,52,3,38),(4,52,3,39),(13,52,4,0),(13,52,4,2),(5,52,4,4),(5,52,4,5),(3,52,4,9),(3,52,4,10),(3,52,4,11),(3,52,4,12),(8,52,4,19),(0,52,4,28),(5,52,4,30),(5,52,4,31),(4,52,4,38),(4,52,4,39),(5,52,5,4),(5,52,5,5),(12,52,5,6),(3,52,5,12),(6,52,5,22),(6,52,5,23),(6,52,5,24),(5,52,5,30),(5,52,5,31),(4,52,5,37),(4,52,5,38),(4,52,5,39),(5,52,6,5),(3,52,6,12),(5,52,6,13),(5,52,6,14),(5,52,6,15),(5,52,6,16),(3,52,6,17),(3,52,6,18),(6,52,6,22),(4,52,6,23),(0,52,6,24),(3,52,6,29),(3,52,6,30),(3,52,6,31),(6,52,6,34),(4,52,6,36),(4,52,6,37),(6,52,6,42),(5,52,7,4),(5,52,7,5),(5,52,7,12),(5,52,7,13),(5,52,7,14),(3,52,7,15),(3,52,7,16),(3,52,7,17),(10,52,7,18),(4,52,7,23),(3,52,7,30),(3,52,7,31),(6,52,7,32),(6,52,7,33),(6,52,7,34),(6,52,7,41),(6,52,7,42),(14,52,8,13),(3,52,8,17),(5,52,8,22),(4,52,8,23),(4,52,8,24),(0,52,8,28),(3,52,8,30),(3,52,8,31),(0,52,8,32),(0,52,8,36),(1,52,8,40),(6,52,8,42),(3,52,9,17),(5,52,9,22),(5,52,9,23),(5,52,9,24),(3,52,9,30),(4,52,10,0),(4,52,10,1),(4,52,10,2),(4,52,10,3),(3,52,10,17),(5,52,10,22),(5,52,10,23),(5,52,10,24),(3,52,10,30),(3,52,10,31);
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
) ENGINE=InnoDB AUTO_INCREMENT=739 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `units`
--

LOCK TABLES `units` WRITE;
/*!40000 ALTER TABLE `units` DISABLE KEYS */;
INSERT INTO `units` VALUES (1,4475,1,1,1,NULL,NULL,NULL,NULL,0,0,'Thor',0,3,224,NULL,1,0,0,0,0,0,0),(2,4475,1,1,1,NULL,NULL,NULL,NULL,0,0,'Thor',0,3,224,NULL,1,0,0,0,0,0,0),(3,4475,1,1,1,NULL,NULL,NULL,NULL,0,0,'Thor',0,3,224,NULL,1,0,0,0,0,0,0),(4,4475,1,1,1,NULL,NULL,NULL,NULL,0,0,'Thor',0,3,224,NULL,1,0,0,0,0,0,0),(5,2812,1,1,1,NULL,NULL,NULL,NULL,0,0,'Dirac',0,3,224,NULL,1,0,0,0,0,0,0),(6,2812,1,1,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,3,224,NULL,1,0,0,0,0,0,0),(7,2812,1,1,1,NULL,NULL,NULL,NULL,0,0,'Dirac',0,3,224,NULL,1,0,0,0,0,0,0),(8,2812,1,1,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,3,224,NULL,1,0,0,0,0,0,0),(9,2812,1,1,1,NULL,NULL,NULL,NULL,0,0,'Dirac',0,3,224,NULL,1,0,0,0,0,0,0),(10,2812,1,1,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,3,224,NULL,1,0,0,0,0,0,0),(11,2812,1,1,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,3,224,NULL,1,0,0,0,0,0,0),(12,900,1,5,4,NULL,NULL,NULL,NULL,0,0,'Gnawer',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(13,900,1,5,4,NULL,NULL,NULL,NULL,0,0,'Gnawer',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(14,900,1,5,4,NULL,NULL,NULL,NULL,0,0,'Gnawer',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(15,900,1,5,4,NULL,NULL,NULL,NULL,0,0,'Gnawer',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(16,900,1,5,4,NULL,NULL,NULL,NULL,0,0,'Gnawer',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(17,500,1,5,4,NULL,NULL,NULL,NULL,0,0,'Spudder',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(18,500,1,5,4,NULL,NULL,NULL,NULL,0,0,'Spudder',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(19,500,1,5,4,NULL,NULL,NULL,NULL,0,0,'Spudder',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(20,90,1,5,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(21,90,1,5,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(22,125,1,5,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(23,125,1,5,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(24,125,1,5,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(25,125,1,5,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(26,90,1,5,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(27,90,1,5,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(28,90,1,5,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(29,90,1,5,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(30,90,1,5,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(31,90,1,5,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(32,125,1,5,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(33,125,1,5,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(34,125,1,5,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(35,125,1,5,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(36,125,1,5,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(37,125,1,5,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(38,125,1,5,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(39,125,1,5,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(40,125,1,5,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(41,125,1,5,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(42,900,1,6,4,NULL,NULL,NULL,NULL,0,0,'Gnawer',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(43,900,1,6,4,NULL,NULL,NULL,NULL,0,0,'Gnawer',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(44,500,1,6,4,NULL,NULL,NULL,NULL,0,0,'Spudder',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(45,500,1,6,4,NULL,NULL,NULL,NULL,0,0,'Spudder',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(46,500,1,6,4,NULL,NULL,NULL,NULL,0,0,'Spudder',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(47,900,1,6,4,NULL,NULL,NULL,NULL,0,0,'Gnawer',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(48,500,1,6,4,NULL,NULL,NULL,NULL,0,0,'Spudder',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(49,90,1,6,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(50,90,1,6,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(51,125,1,6,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(52,125,1,6,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(53,125,1,6,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(54,125,1,6,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(55,125,1,6,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(56,90,1,6,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(57,90,1,6,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(58,90,1,6,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(59,90,1,6,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(60,90,1,6,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(61,90,1,6,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(62,125,1,6,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(63,125,1,6,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(64,125,1,6,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(65,125,1,6,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(66,125,1,6,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(67,125,1,6,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(68,125,1,6,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(69,900,1,7,4,NULL,NULL,NULL,NULL,0,0,'Gnawer',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(70,500,1,7,4,NULL,NULL,NULL,NULL,0,0,'Spudder',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(71,500,1,7,4,NULL,NULL,NULL,NULL,0,0,'Spudder',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(72,500,1,7,4,NULL,NULL,NULL,NULL,0,0,'Spudder',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(73,900,1,7,4,NULL,NULL,NULL,NULL,0,0,'Gnawer',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(74,500,1,7,4,NULL,NULL,NULL,NULL,0,0,'Spudder',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(75,500,1,7,4,NULL,NULL,NULL,NULL,0,0,'Spudder',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(76,90,1,7,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(77,90,1,7,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(78,125,1,7,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(79,125,1,7,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(80,125,1,7,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(81,125,1,7,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(82,90,1,7,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(83,90,1,7,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(84,90,1,7,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(85,90,1,7,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(86,90,1,7,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(87,90,1,7,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(88,125,1,7,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(89,125,1,7,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(90,125,1,7,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(91,125,1,7,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(92,125,1,7,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(93,125,1,7,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(94,125,1,7,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(95,125,1,7,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(96,125,1,7,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(97,125,1,7,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(98,500,1,8,4,NULL,NULL,NULL,NULL,0,0,'Spudder',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(99,90,1,8,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(100,90,1,8,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(101,125,1,8,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(102,125,1,8,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(103,125,1,8,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(104,125,1,8,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(105,90,1,8,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(106,90,1,8,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(107,90,1,8,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(108,90,1,8,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(109,90,1,8,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(110,125,1,8,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(111,125,1,8,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(112,125,1,8,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(113,125,1,8,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(114,125,1,8,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(115,125,1,8,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(116,125,1,8,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(117,125,1,8,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(118,125,1,8,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(119,125,1,9,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(120,90,1,9,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(121,90,1,9,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(122,90,1,9,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(123,90,1,9,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(124,90,1,9,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(125,125,1,9,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(126,125,1,9,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(127,125,1,9,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(128,125,1,9,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(129,125,1,9,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(130,125,1,9,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(131,125,1,9,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(132,125,1,9,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(133,125,1,9,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(134,125,1,10,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(135,125,1,10,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(136,125,1,10,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(137,125,1,10,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(138,125,1,10,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(139,125,1,10,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(140,125,1,10,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(141,125,1,10,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(142,125,1,11,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(143,125,1,11,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(144,125,1,11,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(145,125,1,11,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(146,125,1,11,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(147,125,1,11,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(148,125,1,11,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(149,125,1,11,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(150,125,1,11,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(151,125,1,12,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(152,125,1,12,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(153,125,1,12,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(154,125,1,12,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(155,125,1,12,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(156,125,1,12,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(157,125,1,12,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(158,125,1,12,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(159,125,1,12,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(160,125,1,13,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(161,125,1,13,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(162,125,1,13,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(163,125,1,13,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(164,125,1,13,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(165,125,1,13,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(166,125,1,13,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(167,125,1,13,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(168,26875,1,1,1,NULL,NULL,NULL,NULL,0,0,'Demosis',0,2,180,NULL,1,0,0,0,0,0,0),(169,26875,1,1,1,NULL,NULL,NULL,NULL,0,0,'Demosis',0,2,180,NULL,1,0,0,0,0,0,0),(170,4475,1,1,1,NULL,NULL,NULL,NULL,0,0,'Thor',1,2,180,NULL,1,0,0,0,0,0,0),(171,4475,1,1,1,NULL,NULL,NULL,NULL,0,0,'Thor',0,2,180,NULL,1,0,0,0,0,0,0),(172,4475,1,1,1,NULL,NULL,NULL,NULL,0,0,'Thor',0,2,180,NULL,1,0,0,0,0,0,0),(173,4475,1,1,1,NULL,NULL,NULL,NULL,0,0,'Thor',0,2,180,NULL,1,0,0,0,0,0,0),(174,2812,1,1,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,2,180,NULL,1,0,0,0,0,0,0),(175,2812,1,1,1,NULL,NULL,NULL,NULL,0,0,'Dirac',0,2,180,NULL,1,0,0,0,0,0,0),(176,2812,1,1,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,2,180,NULL,1,0,0,0,0,0,0),(177,2812,1,1,1,NULL,NULL,NULL,NULL,0,0,'Dirac',0,2,180,NULL,1,0,0,0,0,0,0),(178,2812,1,1,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,2,180,NULL,1,0,0,0,0,0,0),(179,125,1,20,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(180,90,1,20,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(181,90,1,20,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(182,90,1,20,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(183,90,1,20,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(184,90,1,20,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(185,90,1,20,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(186,90,1,20,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(187,125,1,20,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(188,125,1,20,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(189,125,1,20,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(190,125,1,20,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(191,125,1,20,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(192,125,1,20,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(193,125,1,20,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(194,125,1,20,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(195,125,1,21,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(196,125,1,21,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(197,125,1,21,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(198,125,1,21,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(199,125,1,21,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(200,125,1,21,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(201,125,1,21,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(202,125,1,21,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(203,125,1,22,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(204,125,1,22,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(205,125,1,22,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(206,125,1,22,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(207,125,1,22,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(208,125,1,22,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(209,125,1,22,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(210,125,1,22,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(211,125,1,22,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(212,125,1,23,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(213,125,1,23,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(214,125,1,23,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(215,125,1,23,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(216,125,1,23,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(217,125,1,23,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(218,125,1,23,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(219,4475,1,2,1,NULL,NULL,NULL,NULL,0,0,'Thor',0,2,150,NULL,1,0,0,0,0,0,0),(220,4475,1,2,1,NULL,NULL,NULL,NULL,0,0,'Thor',0,2,150,NULL,1,0,0,0,0,0,0),(221,4475,1,2,1,NULL,NULL,NULL,NULL,0,0,'Thor',1,2,150,NULL,1,0,0,0,0,0,0),(222,2812,1,2,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,2,150,NULL,1,0,0,0,0,0,0),(223,2812,1,2,1,NULL,NULL,NULL,NULL,0,0,'Dirac',0,2,150,NULL,1,0,0,0,0,0,0),(224,2812,1,2,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,2,150,NULL,1,0,0,0,0,0,0),(225,2812,1,2,1,NULL,NULL,NULL,NULL,0,0,'Dirac',0,2,150,NULL,1,0,0,0,0,0,0),(226,2812,1,2,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,2,150,NULL,1,0,0,0,0,0,0),(227,4475,1,2,1,NULL,NULL,NULL,NULL,0,0,'Thor',0,0,90,NULL,1,0,0,0,0,0,0),(228,4475,1,2,1,NULL,NULL,NULL,NULL,0,0,'Thor',0,0,90,NULL,1,0,0,0,0,0,0),(229,4475,1,2,1,NULL,NULL,NULL,NULL,0,0,'Thor',1,0,90,NULL,1,0,0,0,0,0,0),(230,2812,1,2,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,0,90,NULL,1,0,0,0,0,0,0),(231,2812,1,2,1,NULL,NULL,NULL,NULL,0,0,'Dirac',0,0,90,NULL,1,0,0,0,0,0,0),(232,2812,1,2,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,0,90,NULL,1,0,0,0,0,0,0),(233,2812,1,2,1,NULL,NULL,NULL,NULL,0,0,'Dirac',0,0,90,NULL,1,0,0,0,0,0,0),(234,2812,1,2,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,0,90,NULL,1,0,0,0,0,0,0),(235,90,1,24,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(236,125,1,24,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(237,125,1,24,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(238,125,1,24,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(239,125,1,24,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(240,125,1,24,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(241,125,1,24,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(242,125,1,24,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(243,90,1,25,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(244,90,1,25,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(245,125,1,25,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(246,125,1,25,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(247,90,1,25,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(248,125,1,25,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(249,125,1,25,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(250,125,1,25,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(251,125,1,25,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(252,125,1,25,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(253,125,1,25,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(254,125,1,25,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(255,125,1,26,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(256,125,1,26,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(257,125,1,26,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(258,125,1,26,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(259,125,1,26,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(260,125,1,26,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(261,90,1,27,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(262,125,1,27,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(263,125,1,27,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(264,125,1,27,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(265,125,1,27,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(266,125,1,27,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(267,125,1,27,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(268,125,1,27,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(269,125,1,28,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(270,125,1,28,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(271,125,1,28,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(272,125,1,28,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(273,125,1,28,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(274,125,1,28,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(275,125,1,29,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(276,125,1,29,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(277,125,1,29,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(278,125,1,29,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(279,125,1,29,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(280,125,1,29,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(281,90,1,30,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(282,90,1,30,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(283,125,1,30,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(284,125,1,30,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(285,90,1,30,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(286,125,1,30,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(287,125,1,30,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(288,125,1,30,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(289,125,1,30,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(290,125,1,30,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(291,125,1,30,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(292,125,1,30,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(293,125,1,31,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(294,125,1,31,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(295,125,1,31,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(296,125,1,31,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(297,125,1,31,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(298,125,1,31,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(299,125,1,32,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(300,125,1,32,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(301,125,1,32,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(302,125,1,32,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(303,125,1,32,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(304,125,1,32,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(305,90,1,33,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(306,125,1,33,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(307,125,1,33,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(308,125,1,33,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(309,125,1,33,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(310,125,1,33,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(311,125,1,33,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(312,125,1,33,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(313,90,1,34,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(314,125,1,34,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(315,125,1,34,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(316,125,1,34,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(317,125,1,34,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(318,125,1,34,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(319,125,1,34,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(320,125,1,34,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(321,90,1,38,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(322,90,1,38,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(323,125,1,38,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(324,125,1,38,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(325,90,1,38,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(326,125,1,38,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(327,125,1,38,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(328,125,1,38,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(329,125,1,38,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(330,125,1,38,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(331,125,1,38,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(332,125,1,38,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(333,90,1,42,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(334,90,1,42,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(335,125,1,42,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(336,125,1,42,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(337,125,1,42,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(338,125,1,42,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(339,90,1,42,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(340,90,1,42,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(341,125,1,42,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(342,125,1,42,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(343,90,1,42,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(344,125,1,42,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(345,125,1,42,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(346,125,1,42,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(347,125,1,42,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(348,125,1,42,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(349,125,1,42,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(350,125,1,42,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(351,4475,1,2,1,NULL,NULL,NULL,NULL,0,0,'Thor',0,3,336,NULL,1,0,0,0,0,0,0),(352,4475,1,2,1,NULL,NULL,NULL,NULL,0,0,'Thor',0,3,336,NULL,1,0,0,0,0,0,0),(353,4475,1,2,1,NULL,NULL,NULL,NULL,0,0,'Thor',1,3,336,NULL,1,0,0,0,0,0,0),(354,2812,1,2,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,3,336,NULL,1,0,0,0,0,0,0),(355,2812,1,2,1,NULL,NULL,NULL,NULL,0,0,'Dirac',0,3,336,NULL,1,0,0,0,0,0,0),(356,2812,1,2,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,3,336,NULL,1,0,0,0,0,0,0),(357,2812,1,2,1,NULL,NULL,NULL,NULL,0,0,'Dirac',0,3,336,NULL,1,0,0,0,0,0,0),(358,2812,1,2,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,3,336,NULL,1,0,0,0,0,0,0),(359,4475,1,2,1,NULL,NULL,NULL,NULL,0,0,'Thor',0,0,270,NULL,1,0,0,0,0,0,0),(360,4475,1,2,1,NULL,NULL,NULL,NULL,0,0,'Thor',0,0,270,NULL,1,0,0,0,0,0,0),(361,4475,1,2,1,NULL,NULL,NULL,NULL,0,0,'Thor',1,0,270,NULL,1,0,0,0,0,0,0),(362,2812,1,2,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,0,270,NULL,1,0,0,0,0,0,0),(363,2812,1,2,1,NULL,NULL,NULL,NULL,0,0,'Dirac',0,0,270,NULL,1,0,0,0,0,0,0),(364,2812,1,2,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,0,270,NULL,1,0,0,0,0,0,0),(365,2812,1,2,1,NULL,NULL,NULL,NULL,0,0,'Dirac',0,0,270,NULL,1,0,0,0,0,0,0),(366,2812,1,2,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,0,270,NULL,1,0,0,0,0,0,0),(367,4475,1,2,1,NULL,NULL,NULL,NULL,0,0,'Thor',0,1,315,NULL,1,0,0,0,0,0,0),(368,4475,1,2,1,NULL,NULL,NULL,NULL,0,0,'Thor',0,1,315,NULL,1,0,0,0,0,0,0),(369,4475,1,2,1,NULL,NULL,NULL,NULL,0,0,'Thor',1,1,315,NULL,1,0,0,0,0,0,0),(370,2812,1,2,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,1,315,NULL,1,0,0,0,0,0,0),(371,2812,1,2,1,NULL,NULL,NULL,NULL,0,0,'Dirac',0,1,315,NULL,1,0,0,0,0,0,0),(372,2812,1,2,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,1,315,NULL,1,0,0,0,0,0,0),(373,2812,1,2,1,NULL,NULL,NULL,NULL,0,0,'Dirac',0,1,315,NULL,1,0,0,0,0,0,0),(374,2812,1,2,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,1,315,NULL,1,0,0,0,0,0,0),(375,4475,1,2,1,NULL,NULL,NULL,NULL,0,0,'Thor',0,2,240,NULL,1,0,0,0,0,0,0),(376,4475,1,2,1,NULL,NULL,NULL,NULL,0,0,'Thor',0,2,240,NULL,1,0,0,0,0,0,0),(377,4475,1,2,1,NULL,NULL,NULL,NULL,0,0,'Thor',1,2,240,NULL,1,0,0,0,0,0,0),(378,2812,1,2,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,2,240,NULL,1,0,0,0,0,0,0),(379,2812,1,2,1,NULL,NULL,NULL,NULL,0,0,'Dirac',0,2,240,NULL,1,0,0,0,0,0,0),(380,2812,1,2,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,2,240,NULL,1,0,0,0,0,0,0),(381,2812,1,2,1,NULL,NULL,NULL,NULL,0,0,'Dirac',0,2,240,NULL,1,0,0,0,0,0,0),(382,2812,1,2,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,2,240,NULL,1,0,0,0,0,0,0),(383,900,1,50,4,NULL,NULL,NULL,NULL,0,0,'Gnawer',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(384,500,1,50,4,NULL,NULL,NULL,NULL,0,0,'Spudder',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(385,500,1,50,4,NULL,NULL,NULL,NULL,0,0,'Spudder',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(386,500,1,50,4,NULL,NULL,NULL,NULL,0,0,'Spudder',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(387,500,1,50,4,NULL,NULL,NULL,NULL,0,0,'Spudder',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(388,500,1,50,4,NULL,NULL,NULL,NULL,0,0,'Spudder',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(389,90,1,50,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(390,90,1,50,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(391,125,1,50,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(392,125,1,50,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(393,125,1,50,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(394,125,1,50,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(395,90,1,50,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(396,90,1,50,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(397,90,1,50,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(398,90,1,50,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(399,90,1,50,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(400,125,1,50,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(401,125,1,50,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(402,125,1,50,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(403,125,1,50,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(404,125,1,50,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(405,125,1,50,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(406,125,1,50,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(407,125,1,50,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(408,900,1,51,4,NULL,NULL,NULL,NULL,0,0,'Gnawer',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(409,900,1,51,4,NULL,NULL,NULL,NULL,0,0,'Gnawer',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(410,500,1,51,4,NULL,NULL,NULL,NULL,0,0,'Spudder',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(411,500,1,51,4,NULL,NULL,NULL,NULL,0,0,'Spudder',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(412,500,1,51,4,NULL,NULL,NULL,NULL,0,0,'Spudder',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(413,90,1,51,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(414,90,1,51,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(415,125,1,51,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(416,125,1,51,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(417,90,1,51,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(418,90,1,51,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(419,90,1,51,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(420,90,1,51,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(421,90,1,51,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(422,90,1,51,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(423,125,1,51,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(424,125,1,51,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(425,125,1,51,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(426,125,1,51,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(427,125,1,51,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(428,125,1,51,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(429,125,1,51,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(430,125,1,51,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(431,125,1,52,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(432,125,1,52,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(433,90,1,52,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(434,90,1,52,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(435,90,1,52,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(436,90,1,52,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(437,90,1,52,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(438,125,1,52,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(439,125,1,52,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(440,125,1,52,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(441,125,1,52,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(442,125,1,52,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(443,125,1,52,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(444,90,1,53,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(445,90,1,53,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(446,90,1,53,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(447,90,1,53,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(448,90,1,53,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(449,125,1,53,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(450,125,1,53,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(451,125,1,53,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(452,125,1,53,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(453,125,1,53,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(454,125,1,53,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(455,125,1,53,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(456,125,1,53,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(457,125,1,53,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(458,125,1,54,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(459,125,1,54,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(460,125,1,54,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(461,125,1,54,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(462,125,1,54,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(463,125,1,54,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(464,125,1,54,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(465,125,1,54,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(466,125,1,55,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(467,125,1,55,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(468,125,1,55,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(469,125,1,55,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(470,125,1,55,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(471,125,1,55,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(472,125,1,55,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(473,125,1,56,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(474,125,1,56,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(475,125,1,56,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(476,125,1,56,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(477,125,1,56,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(478,125,1,56,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(479,125,1,56,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(480,4475,1,2,1,NULL,NULL,NULL,NULL,0,0,'Thor',0,2,300,NULL,1,0,0,0,0,0,0),(481,4475,1,2,1,NULL,NULL,NULL,NULL,0,0,'Thor',0,2,300,NULL,1,0,0,0,0,0,0),(482,4475,1,2,1,NULL,NULL,NULL,NULL,0,0,'Thor',1,2,300,NULL,1,0,0,0,0,0,0),(483,2812,1,2,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,2,300,NULL,1,0,0,0,0,0,0),(484,2812,1,2,1,NULL,NULL,NULL,NULL,0,0,'Dirac',0,2,300,NULL,1,0,0,0,0,0,0),(485,2812,1,2,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,2,300,NULL,1,0,0,0,0,0,0),(486,2812,1,2,1,NULL,NULL,NULL,NULL,0,0,'Dirac',0,2,300,NULL,1,0,0,0,0,0,0),(487,2812,1,2,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,2,300,NULL,1,0,0,0,0,0,0),(488,4475,1,3,1,NULL,NULL,NULL,NULL,0,0,'Thor',0,3,22,NULL,1,0,0,0,0,0,0),(489,4475,1,3,1,NULL,NULL,NULL,NULL,0,0,'Thor',0,3,22,NULL,1,0,0,0,0,0,0),(490,4475,1,3,1,NULL,NULL,NULL,NULL,0,0,'Thor',0,3,22,NULL,1,0,0,0,0,0,0),(491,2812,1,3,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,3,22,NULL,1,0,0,0,0,0,0),(492,2812,1,3,1,NULL,NULL,NULL,NULL,0,0,'Dirac',0,3,22,NULL,1,0,0,0,0,0,0),(493,2812,1,3,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,3,22,NULL,1,0,0,0,0,0,0),(494,2812,1,3,1,NULL,NULL,NULL,NULL,0,0,'Dirac',0,3,22,NULL,1,0,0,0,0,0,0),(495,2812,1,3,1,NULL,NULL,NULL,NULL,0,0,'Dirac',0,3,22,NULL,1,0,0,0,0,0,0),(496,2812,1,3,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,3,22,NULL,1,0,0,0,0,0,0),(497,2812,1,3,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,3,22,NULL,1,0,0,0,0,0,0),(498,900,1,62,4,NULL,NULL,NULL,NULL,0,0,'Gnawer',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(499,900,1,62,4,NULL,NULL,NULL,NULL,0,0,'Gnawer',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(500,900,1,62,4,NULL,NULL,NULL,NULL,0,0,'Gnawer',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(501,900,1,62,4,NULL,NULL,NULL,NULL,0,0,'Gnawer',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(502,500,1,62,4,NULL,NULL,NULL,NULL,0,0,'Spudder',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(503,500,1,62,4,NULL,NULL,NULL,NULL,0,0,'Spudder',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(504,500,1,62,4,NULL,NULL,NULL,NULL,0,0,'Spudder',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(505,500,1,62,4,NULL,NULL,NULL,NULL,0,0,'Spudder',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(506,90,1,62,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(507,90,1,62,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(508,125,1,62,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(509,125,1,62,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(510,90,1,62,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(511,90,1,62,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(512,90,1,62,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(513,90,1,62,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(514,125,1,62,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(515,125,1,62,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(516,125,1,62,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(517,125,1,62,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(518,125,1,62,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(519,125,1,62,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(520,125,1,62,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(521,125,1,62,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(522,125,1,62,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(523,900,1,63,4,NULL,NULL,NULL,NULL,0,0,'Gnawer',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(524,900,1,63,4,NULL,NULL,NULL,NULL,0,0,'Gnawer',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(525,500,1,63,4,NULL,NULL,NULL,NULL,0,0,'Spudder',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(526,500,1,63,4,NULL,NULL,NULL,NULL,0,0,'Spudder',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(527,500,1,63,4,NULL,NULL,NULL,NULL,0,0,'Spudder',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(528,500,1,63,4,NULL,NULL,NULL,NULL,0,0,'Spudder',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(529,90,1,63,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(530,90,1,63,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(531,125,1,63,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(532,125,1,63,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(533,90,1,63,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(534,90,1,63,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(535,90,1,63,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(536,90,1,63,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(537,90,1,63,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(538,90,1,63,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(539,125,1,63,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(540,125,1,63,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(541,125,1,63,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(542,125,1,63,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(543,125,1,63,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(544,125,1,63,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(545,125,1,63,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(546,125,1,63,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(547,125,1,63,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(548,900,1,64,4,NULL,NULL,NULL,NULL,0,0,'Gnawer',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(549,900,1,64,4,NULL,NULL,NULL,NULL,0,0,'Gnawer',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(550,500,1,64,4,NULL,NULL,NULL,NULL,0,0,'Spudder',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(551,500,1,64,4,NULL,NULL,NULL,NULL,0,0,'Spudder',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(552,500,1,64,4,NULL,NULL,NULL,NULL,0,0,'Spudder',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(553,500,1,64,4,NULL,NULL,NULL,NULL,0,0,'Spudder',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(554,500,1,64,4,NULL,NULL,NULL,NULL,0,0,'Spudder',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(555,500,1,64,4,NULL,NULL,NULL,NULL,0,0,'Spudder',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(556,90,1,64,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(557,90,1,64,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(558,125,1,64,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(559,125,1,64,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(560,90,1,64,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(561,90,1,64,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(562,90,1,64,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(563,90,1,64,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(564,125,1,64,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(565,125,1,64,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(566,125,1,64,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(567,125,1,64,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(568,125,1,64,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(569,125,1,64,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(570,125,1,64,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(571,125,1,64,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(572,125,1,65,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(573,90,1,65,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(574,90,1,65,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(575,90,1,65,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(576,90,1,65,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(577,125,1,65,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(578,125,1,65,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(579,125,1,65,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(580,125,1,65,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(581,125,1,65,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(582,125,1,65,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(583,125,1,65,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(584,125,1,65,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(585,125,1,65,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(586,125,1,65,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(587,125,1,66,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(588,90,1,66,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(589,90,1,66,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(590,90,1,66,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(591,90,1,66,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(592,90,1,66,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(593,125,1,66,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(594,125,1,66,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(595,125,1,66,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(596,125,1,66,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(597,125,1,66,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(598,125,1,66,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(599,125,1,66,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(600,125,1,66,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(601,125,1,66,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(602,125,1,67,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(603,125,1,67,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(604,125,1,67,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(605,125,1,67,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(606,125,1,67,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(607,125,1,67,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(608,125,1,67,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(609,125,1,67,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(610,125,1,68,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(611,125,1,68,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(612,125,1,68,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(613,125,1,68,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(614,125,1,68,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(615,125,1,68,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(616,125,1,68,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(617,125,1,68,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(618,125,1,69,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(619,125,1,69,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(620,125,1,69,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(621,125,1,69,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(622,125,1,69,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(623,125,1,69,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(624,125,1,69,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(625,125,1,69,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(626,26875,1,3,1,NULL,NULL,NULL,NULL,0,0,'Demosis',0,1,135,NULL,1,0,0,0,0,0,0),(627,26875,1,3,1,NULL,NULL,NULL,NULL,0,0,'Demosis',0,1,135,NULL,1,0,0,0,0,0,0),(628,4475,1,3,1,NULL,NULL,NULL,NULL,0,0,'Thor',1,1,135,NULL,1,0,0,0,0,0,0),(629,4475,1,3,1,NULL,NULL,NULL,NULL,0,0,'Thor',0,1,135,NULL,1,0,0,0,0,0,0),(630,4475,1,3,1,NULL,NULL,NULL,NULL,0,0,'Thor',0,1,135,NULL,1,0,0,0,0,0,0),(631,4475,1,3,1,NULL,NULL,NULL,NULL,0,0,'Thor',0,1,135,NULL,1,0,0,0,0,0,0),(632,4475,1,3,1,NULL,NULL,NULL,NULL,0,0,'Thor',0,1,135,NULL,1,0,0,0,0,0,0),(633,4475,1,3,1,NULL,NULL,NULL,NULL,0,0,'Thor',0,1,135,NULL,1,0,0,0,0,0,0),(634,2812,1,3,1,NULL,NULL,NULL,NULL,0,0,'Dirac',0,1,135,NULL,1,0,0,0,0,0,0),(635,2812,1,3,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,1,135,NULL,1,0,0,0,0,0,0),(636,2812,1,3,1,NULL,NULL,NULL,NULL,0,0,'Dirac',0,1,135,NULL,1,0,0,0,0,0,0),(637,2812,1,3,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,1,135,NULL,1,0,0,0,0,0,0),(638,2812,1,3,1,NULL,NULL,NULL,NULL,0,0,'Dirac',0,1,135,NULL,1,0,0,0,0,0,0),(639,2812,1,3,1,NULL,NULL,NULL,NULL,0,0,'Dirac',0,1,135,NULL,1,0,0,0,0,0,0),(640,2812,1,3,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,1,135,NULL,1,0,0,0,0,0,0),(641,2812,1,3,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,1,135,NULL,1,0,0,0,0,0,0),(642,26875,1,3,1,NULL,NULL,NULL,NULL,0,0,'Demosis',0,2,330,NULL,1,0,0,0,0,0,0),(643,26875,1,3,1,NULL,NULL,NULL,NULL,0,0,'Demosis',0,2,330,NULL,1,0,0,0,0,0,0),(644,4475,1,3,1,NULL,NULL,NULL,NULL,0,0,'Thor',0,2,330,NULL,1,0,0,0,0,0,0),(645,4475,1,3,1,NULL,NULL,NULL,NULL,0,0,'Thor',0,2,330,NULL,1,0,0,0,0,0,0),(646,2812,1,3,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,2,330,NULL,1,0,0,0,0,0,0),(647,2812,1,3,1,NULL,NULL,NULL,NULL,0,0,'Dirac',0,2,330,NULL,1,0,0,0,0,0,0),(648,2812,1,3,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,2,330,NULL,1,0,0,0,0,0,0),(649,2812,1,3,1,NULL,NULL,NULL,NULL,0,0,'Dirac',0,2,330,NULL,1,0,0,0,0,0,0),(650,2812,1,3,1,NULL,NULL,NULL,NULL,0,0,'Dirac',0,2,330,NULL,1,0,0,0,0,0,0),(651,2812,1,3,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,2,330,NULL,1,0,0,0,0,0,0),(652,26875,1,3,1,NULL,NULL,NULL,NULL,0,0,'Demosis',0,2,270,NULL,1,0,0,0,0,0,0),(653,26875,1,3,1,NULL,NULL,NULL,NULL,0,0,'Demosis',0,2,270,NULL,1,0,0,0,0,0,0),(654,26875,1,3,1,NULL,NULL,NULL,NULL,0,0,'Demosis',0,2,270,NULL,1,0,0,0,0,0,0),(655,26875,1,3,1,NULL,NULL,NULL,NULL,0,0,'Demosis',1,2,270,NULL,1,0,0,0,0,0,0),(656,4475,1,3,1,NULL,NULL,NULL,NULL,0,0,'Thor',0,2,270,NULL,1,0,0,0,0,0,0),(657,4475,1,3,1,NULL,NULL,NULL,NULL,0,0,'Thor',0,2,270,NULL,1,0,0,0,0,0,0),(658,4475,1,3,1,NULL,NULL,NULL,NULL,0,0,'Thor',0,2,270,NULL,1,0,0,0,0,0,0),(659,4475,1,3,1,NULL,NULL,NULL,NULL,0,0,'Thor',1,2,270,NULL,1,0,0,0,0,0,0),(660,2812,1,3,1,NULL,NULL,NULL,NULL,0,0,'Dirac',0,2,270,NULL,1,0,0,0,0,0,0),(661,2812,1,3,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,2,270,NULL,1,0,0,0,0,0,0),(662,2812,1,3,1,NULL,NULL,NULL,NULL,0,0,'Dirac',0,2,270,NULL,1,0,0,0,0,0,0),(663,2812,1,3,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,2,270,NULL,1,0,0,0,0,0,0),(664,2812,1,3,1,NULL,NULL,NULL,NULL,0,0,'Dirac',0,2,270,NULL,1,0,0,0,0,0,0),(665,2812,1,3,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,2,270,NULL,1,0,0,0,0,0,0),(666,2812,1,3,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,2,270,NULL,1,0,0,0,0,0,0),(667,26875,1,3,1,NULL,NULL,NULL,NULL,0,0,'Demosis',0,0,180,NULL,1,0,0,0,0,0,0),(668,26875,1,3,1,NULL,NULL,NULL,NULL,0,0,'Demosis',0,0,180,NULL,1,0,0,0,0,0,0),(669,26875,1,3,1,NULL,NULL,NULL,NULL,0,0,'Demosis',0,0,180,NULL,1,0,0,0,0,0,0),(670,4475,1,3,1,NULL,NULL,NULL,NULL,0,0,'Thor',1,0,180,NULL,1,0,0,0,0,0,0),(671,4475,1,3,1,NULL,NULL,NULL,NULL,0,0,'Thor',0,0,180,NULL,1,0,0,0,0,0,0),(672,4475,1,3,1,NULL,NULL,NULL,NULL,0,0,'Thor',0,0,180,NULL,1,0,0,0,0,0,0),(673,4475,1,3,1,NULL,NULL,NULL,NULL,0,0,'Thor',0,0,180,NULL,1,0,0,0,0,0,0),(674,4475,1,3,1,NULL,NULL,NULL,NULL,0,0,'Thor',0,0,180,NULL,1,0,0,0,0,0,0),(675,2812,1,3,1,NULL,NULL,NULL,NULL,0,0,'Dirac',0,0,180,NULL,1,0,0,0,0,0,0),(676,2812,1,3,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,0,180,NULL,1,0,0,0,0,0,0),(677,2812,1,3,1,NULL,NULL,NULL,NULL,0,0,'Dirac',0,0,180,NULL,1,0,0,0,0,0,0),(678,2812,1,3,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,0,180,NULL,1,0,0,0,0,0,0),(679,2812,1,3,1,NULL,NULL,NULL,NULL,0,0,'Dirac',0,0,180,NULL,1,0,0,0,0,0,0),(680,2812,1,3,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,0,180,NULL,1,0,0,0,0,0,0),(681,2812,1,3,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,0,180,NULL,1,0,0,0,0,0,0),(682,500,1,72,4,NULL,NULL,NULL,NULL,0,0,'Spudder',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(683,90,1,72,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(684,90,1,72,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(685,125,1,72,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(686,125,1,72,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(687,125,1,72,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(688,125,1,72,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(689,125,1,72,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(690,90,1,72,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(691,90,1,72,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(692,90,1,72,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(693,90,1,72,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(694,90,1,72,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(695,125,1,72,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(696,125,1,72,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(697,125,1,72,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(698,125,1,72,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(699,125,1,72,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(700,125,1,72,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(701,125,1,72,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(702,125,1,73,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(703,90,1,73,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(704,90,1,73,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(705,90,1,73,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(706,90,1,73,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(707,90,1,73,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(708,90,1,73,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(709,125,1,73,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(710,125,1,73,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(711,125,1,73,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(712,125,1,73,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(713,125,1,73,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(714,125,1,73,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(715,125,1,73,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(716,125,1,74,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(717,125,1,74,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(718,125,1,74,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(719,125,1,74,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(720,125,1,74,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(721,125,1,74,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(722,125,1,75,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(723,125,1,75,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(724,125,1,75,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(725,125,1,75,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(726,125,1,75,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(727,125,1,75,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(728,125,1,75,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(729,125,1,75,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(730,125,1,75,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(731,125,1,76,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(732,125,1,76,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(733,125,1,76,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(734,125,1,76,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(735,125,1,76,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(736,125,1,76,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(737,125,1,76,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(738,125,1,76,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,NULL,NULL,NULL,1,0,0,0,0,0,0);
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

-- Dump completed on 2011-01-10 13:17:48
