-- MySQL dump 10.13  Distrib 5.1.41, for debian-linux-gnu (i486)
--
-- Host: localhost    Database: spacegame
-- ------------------------------------------------------
-- Server version	5.1.41-3ubuntu12.6

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
) ENGINE=InnoDB AUTO_INCREMENT=53 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `buildings`
--

LOCK TABLES `buildings` WRITE;
/*!40000 ALTER TABLE `buildings` DISABLE KEYS */;
INSERT INTO `buildings` VALUES (1,11,17,30,0,0,0,1,'NpcMetalExtractor',NULL,19,32,NULL,0,400,NULL,0,NULL,NULL,0),(2,11,1,9,0,0,0,1,'NpcMetalExtractor',NULL,3,11,NULL,0,400,NULL,0,NULL,NULL,0),(3,11,1,20,0,0,0,1,'NpcZetiumExtractor',NULL,3,22,NULL,0,800,NULL,0,NULL,NULL,0),(4,12,3,14,0,0,0,1,'NpcMetalExtractor',NULL,5,16,NULL,0,400,NULL,0,NULL,NULL,0),(5,12,15,1,0,0,0,1,'NpcMetalExtractor',NULL,17,3,NULL,0,400,NULL,0,NULL,NULL,0),(6,19,25,28,0,0,0,1,'NpcMetalExtractor',NULL,27,30,NULL,0,400,NULL,0,NULL,NULL,0),(7,19,33,5,0,0,0,1,'NpcMetalExtractor',NULL,35,7,NULL,0,400,NULL,0,NULL,NULL,0),(8,19,2,1,0,0,0,1,'NpcMetalExtractor',NULL,4,3,NULL,0,400,NULL,0,NULL,NULL,0),(9,19,13,1,0,0,0,1,'NpcMetalExtractor',NULL,15,3,NULL,0,400,NULL,0,NULL,NULL,0),(10,22,7,9,0,0,0,1,'Vulcan',NULL,9,11,NULL,0,300,NULL,0,NULL,NULL,0),(11,22,14,9,0,0,0,1,'Thunder',NULL,16,11,NULL,0,300,NULL,0,NULL,NULL,0),(12,22,21,9,0,0,0,1,'Screamer',NULL,23,11,NULL,0,300,NULL,0,NULL,NULL,0),(13,22,11,14,0,0,0,1,'Mothership',NULL,19,20,NULL,0,10500,NULL,0,NULL,NULL,0),(14,22,7,16,0,0,0,1,'Thunder',NULL,9,18,NULL,0,300,NULL,0,NULL,NULL,0),(15,22,21,16,0,0,0,1,'Thunder',NULL,23,18,NULL,0,300,NULL,0,NULL,NULL,0),(16,22,26,16,0,0,0,1,'NpcZetiumExtractor',NULL,28,18,NULL,0,800,NULL,0,NULL,NULL,0),(17,22,25,20,0,0,0,1,'NpcTemple',NULL,28,23,NULL,0,1500,NULL,0,NULL,NULL,0),(18,22,7,22,0,0,0,1,'Screamer',NULL,9,24,NULL,0,300,NULL,0,NULL,NULL,0),(19,22,14,22,0,0,0,1,'Thunder',NULL,16,24,NULL,0,300,NULL,0,NULL,NULL,0),(20,22,21,22,0,0,0,1,'Vulcan',NULL,23,24,NULL,0,300,NULL,0,NULL,NULL,0),(21,22,24,24,0,0,0,1,'NpcMetalExtractor',NULL,26,26,NULL,0,400,NULL,0,NULL,NULL,0),(22,22,28,24,0,0,0,1,'NpcMetalExtractor',NULL,30,26,NULL,0,400,NULL,0,NULL,NULL,0),(23,22,18,25,0,0,0,1,'NpcSolarPlant',NULL,20,27,NULL,0,1000,NULL,0,NULL,NULL,0),(24,22,15,26,0,0,0,1,'NpcSolarPlant',NULL,17,28,NULL,0,1000,NULL,0,NULL,NULL,0),(25,22,3,27,0,0,0,1,'NpcMetalExtractor',NULL,5,29,NULL,0,400,NULL,0,NULL,NULL,0),(26,22,12,27,0,0,0,1,'NpcSolarPlant',NULL,14,29,NULL,0,1000,NULL,0,NULL,NULL,0),(27,22,22,27,0,0,0,1,'NpcSolarPlant',NULL,24,29,NULL,0,1000,NULL,0,NULL,NULL,0),(28,22,26,27,0,0,0,1,'NpcCommunicationsHub',NULL,29,29,NULL,0,1200,NULL,0,NULL,NULL,0),(29,22,0,28,0,0,0,1,'NpcMetalExtractor',NULL,2,30,NULL,0,400,NULL,0,NULL,NULL,0),(30,22,7,28,0,0,0,1,'NpcCommunicationsHub',NULL,10,30,NULL,0,1200,NULL,0,NULL,NULL,0),(31,22,18,28,0,0,0,1,'NpcSolarPlant',NULL,20,30,NULL,0,1000,NULL,0,NULL,NULL,0),(32,27,14,15,0,0,0,1,'NpcMetalExtractor',NULL,16,17,NULL,0,400,NULL,0,NULL,NULL,0),(33,27,29,22,0,0,0,1,'NpcMetalExtractor',NULL,31,24,NULL,0,400,NULL,0,NULL,NULL,0),(34,27,33,25,0,0,0,1,'NpcMetalExtractor',NULL,35,27,NULL,0,400,NULL,0,NULL,NULL,0),(35,27,33,5,0,0,0,1,'NpcMetalExtractor',NULL,35,7,NULL,0,400,NULL,0,NULL,NULL,0),(36,27,33,9,0,0,0,1,'NpcMetalExtractor',NULL,35,11,NULL,0,400,NULL,0,NULL,NULL,0),(37,38,19,30,0,0,0,1,'NpcMetalExtractor',NULL,21,32,NULL,0,400,NULL,0,NULL,NULL,0),(38,38,26,30,0,0,0,1,'NpcMetalExtractor',NULL,28,32,NULL,0,400,NULL,0,NULL,NULL,0),(39,38,14,30,0,0,0,1,'NpcMetalExtractor',NULL,16,32,NULL,0,400,NULL,0,NULL,NULL,0),(40,39,18,47,0,0,0,1,'NpcMetalExtractor',NULL,20,49,NULL,0,400,NULL,0,NULL,NULL,0),(41,39,20,51,0,0,0,1,'NpcMetalExtractor',NULL,22,53,NULL,0,400,NULL,0,NULL,NULL,0),(42,39,22,12,0,0,0,1,'NpcMetalExtractor',NULL,24,14,NULL,0,400,NULL,0,NULL,NULL,0),(43,39,23,2,0,0,0,1,'NpcMetalExtractor',NULL,25,4,NULL,0,400,NULL,0,NULL,NULL,0),(44,39,23,7,0,0,0,1,'NpcMetalExtractor',NULL,25,9,NULL,0,400,NULL,0,NULL,NULL,0),(45,39,18,2,0,0,0,1,'NpcMetalExtractor',NULL,20,4,NULL,0,400,NULL,0,NULL,NULL,0),(46,39,10,2,0,0,0,1,'NpcGeothermalPlant',NULL,12,4,NULL,0,600,NULL,0,NULL,NULL,0),(47,39,14,7,0,0,0,1,'NpcZetiumExtractor',NULL,16,9,NULL,0,800,NULL,0,NULL,NULL,0),(48,45,19,23,0,0,0,1,'NpcMetalExtractor',NULL,21,25,NULL,0,400,NULL,0,NULL,NULL,0),(49,45,6,28,0,0,0,1,'NpcMetalExtractor',NULL,8,30,NULL,0,400,NULL,0,NULL,NULL,0),(50,45,2,37,0,0,0,1,'NpcMetalExtractor',NULL,4,39,NULL,0,400,NULL,0,NULL,NULL,0),(51,45,2,42,0,0,0,1,'NpcMetalExtractor',NULL,4,44,NULL,0,400,NULL,0,NULL,NULL,0),(52,45,2,29,0,0,0,1,'NpcMetalExtractor',NULL,4,31,NULL,0,400,NULL,0,NULL,NULL,0);
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
INSERT INTO `folliages` VALUES (11,0,24,6),(11,0,28,5),(11,0,30,5),(11,0,35,2),(11,1,0,5),(11,1,1,2),(11,1,2,0),(11,1,11,0),(11,1,12,7),(11,1,22,1),(11,1,25,11),(11,1,34,0),(11,2,0,11),(11,2,2,11),(11,2,27,10),(11,2,31,9),(11,2,33,6),(11,2,34,4),(11,3,1,4),(11,3,5,8),(11,3,10,6),(11,3,14,2),(11,3,18,11),(11,3,23,6),(11,3,25,6),(11,3,29,2),(11,3,30,3),(11,3,32,3),(11,3,34,0),(11,3,38,2),(11,4,2,11),(11,4,3,11),(11,4,4,5),(11,4,18,0),(11,4,20,3),(11,4,21,2),(11,4,29,10),(11,5,4,4),(11,5,10,2),(11,5,13,3),(11,5,14,10),(11,5,15,4),(11,5,29,7),(11,5,33,5),(11,6,5,3),(11,6,13,1),(11,6,14,3),(11,7,11,8),(11,7,13,11),(11,7,14,9),(11,7,29,10),(11,7,30,8),(11,7,36,0),(11,7,37,4),(11,8,8,2),(11,8,11,4),(11,8,22,5),(11,8,26,2),(11,8,27,0),(11,8,31,7),(11,8,34,11),(11,9,5,7),(11,9,6,6),(11,9,12,7),(11,9,14,6),(11,9,15,3),(11,9,28,13),(11,9,33,0),(11,9,36,12),(11,10,4,9),(11,10,5,2),(11,10,13,7),(11,10,15,13),(11,10,26,4),(11,10,27,7),(11,10,36,1),(11,11,26,4),(11,11,27,6),(11,11,35,10),(11,12,5,5),(11,12,13,11),(11,12,27,0),(11,12,29,1),(11,12,30,10),(11,12,35,5),(11,13,2,2),(11,13,4,1),(11,13,13,0),(11,13,25,10),(11,13,27,6),(11,13,28,3),(11,14,2,12),(11,14,27,8),(11,14,35,0),(11,15,9,4),(11,15,34,1),(11,15,35,11),(11,16,4,6),(11,16,8,8),(11,16,9,5),(11,16,37,3),(11,17,3,2),(11,17,9,4),(11,17,14,5),(11,17,22,12),(11,17,29,8),(11,17,37,2),(11,18,10,7),(11,18,19,0),(11,19,4,11),(11,19,7,7),(11,19,9,2),(11,19,15,2),(11,19,18,11),(11,19,22,0),(11,19,24,7),(11,19,35,3),(11,19,36,8),(11,20,5,7),(11,20,11,11),(11,20,17,1),(11,20,24,0),(11,20,35,7),(11,21,4,1),(11,21,6,4),(11,21,15,12),(11,21,16,5),(11,21,22,9),(11,21,37,2),(11,22,12,7),(11,22,13,5),(11,22,16,4),(11,22,37,2),(11,23,5,3),(11,23,6,7),(11,23,9,10),(11,23,12,0),(11,23,13,4),(11,23,16,1),(11,23,20,9),(11,23,21,10),(11,23,24,8),(11,23,25,10),(11,24,19,6),(11,24,22,13),(11,24,38,0),(11,25,6,13),(11,25,7,1),(11,25,8,8),(11,25,11,0),(11,25,17,13),(11,25,19,2),(11,25,22,10),(11,25,23,6),(11,25,24,5),(11,25,32,5),(11,25,33,11),(11,25,36,5),(11,25,37,4),(11,26,6,10),(11,26,10,0),(11,26,23,5),(11,26,25,9),(11,26,33,5),(11,26,34,10),(11,26,37,8),(11,27,1,11),(11,27,14,1),(11,27,26,11),(11,27,34,8),(11,28,0,7),(11,28,10,1),(11,28,22,0),(11,28,23,6),(11,28,24,11),(11,28,33,2),(11,29,21,11),(11,29,26,2),(11,30,0,0),(11,30,2,1),(11,30,17,7),(11,30,19,1),(11,30,22,5),(11,30,23,7),(11,30,25,2),(11,30,38,13),(11,31,0,10),(11,31,9,13),(11,31,13,3),(11,31,25,1),(11,31,30,4),(12,0,0,4),(12,0,29,7),(12,0,30,2),(12,0,35,6),(12,1,0,9),(12,1,31,10),(12,3,0,8),(12,3,3,10),(12,4,1,9),(12,4,13,8),(12,4,25,4),(12,4,32,7),(12,4,34,1),(12,4,37,9),(12,5,2,5),(12,5,23,6),(12,5,24,5),(12,5,25,7),(12,5,26,4),(12,5,33,7),(12,6,0,3),(12,6,9,7),(12,6,37,6),(12,7,0,7),(12,7,1,0),(12,7,3,9),(12,7,7,1),(12,7,25,8),(12,7,26,9),(12,7,27,7),(12,7,31,11),(12,7,34,8),(12,7,35,10),(12,7,36,11),(12,8,3,9),(12,8,22,3),(12,8,25,4),(12,8,27,5),(12,9,6,2),(12,9,7,2),(12,9,8,1),(12,9,9,8),(12,9,10,10),(12,9,15,10),(12,9,17,3),(12,9,23,1),(12,9,24,6),(12,9,26,0),(12,9,27,2),(12,9,32,6),(12,9,36,0),(12,10,9,3),(12,10,10,1),(12,10,13,0),(12,10,15,7),(12,10,17,10),(12,10,21,6),(12,10,22,0),(12,10,37,10),(12,11,8,9),(12,11,23,6),(12,11,24,0),(12,11,25,8),(12,11,33,7),(12,11,35,10),(12,12,8,8),(12,12,13,4),(12,12,29,11),(12,12,30,0),(12,12,33,6),(12,13,1,1),(12,13,3,13),(12,13,13,7),(12,13,15,4),(12,13,17,0),(12,13,20,7),(12,13,26,3),(12,13,34,11),(12,14,3,0),(12,14,5,5),(12,14,17,4),(12,14,19,6),(12,14,22,9),(12,14,23,2),(12,14,28,11),(12,14,34,10),(12,14,36,4),(12,15,3,1),(12,15,4,6),(12,15,6,4),(12,15,14,5),(12,15,15,4),(12,15,18,2),(12,15,20,8),(12,15,25,6),(12,15,31,7),(12,15,34,1),(12,16,4,1),(12,16,6,2),(12,16,13,9),(12,16,18,1),(12,16,23,8),(12,16,24,9),(12,16,25,9),(12,16,26,13),(12,16,28,7),(12,16,34,5),(12,16,37,13),(12,17,2,11),(12,17,6,2),(12,17,16,8),(12,17,17,1),(12,17,23,10),(12,17,36,10),(12,18,2,8),(12,18,3,6),(12,18,4,10),(12,18,34,9),(12,19,2,9),(12,19,4,11),(12,19,12,5),(12,19,18,2),(12,19,33,12),(12,20,3,4),(12,20,7,7),(12,20,24,6),(12,20,30,11),(12,21,7,10),(12,21,14,3),(12,21,16,3),(12,21,21,8),(12,21,27,9),(12,21,30,1),(12,21,37,11),(12,22,4,5),(12,22,5,3),(12,22,11,10),(12,22,14,8),(12,22,15,8),(12,22,16,9),(12,22,19,5),(12,22,25,7),(12,22,31,5),(12,22,34,1),(12,23,18,4),(12,23,20,4),(12,23,21,1),(12,23,23,5),(12,23,25,8),(12,23,29,1),(12,23,32,1),(12,23,34,9),(12,23,36,9),(12,24,7,1),(12,24,8,9),(12,24,18,1),(12,24,20,6),(12,24,21,10),(12,25,8,4),(12,25,19,10),(12,25,22,4),(12,25,30,9),(12,25,32,2),(12,26,7,7),(12,26,24,5),(12,26,29,4),(12,26,30,3),(12,26,31,1),(19,0,1,1),(19,0,2,2),(19,0,8,11),(19,0,28,6),(19,0,29,0),(19,0,30,9),(19,0,34,5),(19,0,39,1),(19,1,0,4),(19,1,3,12),(19,1,11,0),(19,1,32,0),(19,1,35,1),(19,2,9,7),(19,2,10,10),(19,2,23,6),(19,2,28,12),(19,2,33,10),(19,2,36,4),(19,3,7,9),(19,3,9,11),(19,3,11,1),(19,3,12,1),(19,3,23,7),(19,3,32,5),(19,4,3,5),(19,4,12,9),(19,4,13,1),(19,4,18,9),(19,4,21,7),(19,4,22,0),(19,4,34,5),(19,5,0,10),(19,5,8,11),(19,5,11,1),(19,5,15,0),(19,5,22,1),(19,5,31,10),(19,6,10,5),(19,6,11,2),(19,6,16,4),(19,6,18,2),(19,7,18,1),(19,7,36,13),(19,8,6,5),(19,8,9,9),(19,8,19,7),(19,8,23,5),(19,8,27,5),(19,8,28,0),(19,8,40,11),(19,9,18,4),(19,9,27,10),(19,10,3,12),(19,10,19,11),(19,10,21,1),(19,10,27,0),(19,10,28,10),(19,10,32,5),(19,10,39,9),(19,11,0,3),(19,11,14,7),(19,11,20,6),(19,11,23,8),(19,11,25,2),(19,11,26,4),(19,11,30,12),(19,12,5,3),(19,12,10,10),(19,12,12,0),(19,12,14,7),(19,12,16,2),(19,12,38,13),(19,12,40,10),(19,13,8,6),(19,13,9,8),(19,13,12,13),(19,13,13,11),(19,13,24,9),(19,13,28,8),(19,13,30,9),(19,13,31,12),(19,13,40,6),(19,14,0,0),(19,14,4,12),(19,14,5,0),(19,14,10,8),(19,14,14,2),(19,14,15,11),(19,14,18,5),(19,14,24,3),(19,14,29,7),(19,14,35,5),(19,14,38,7),(19,15,1,6),(19,15,2,10),(19,15,10,0),(19,15,18,6),(19,15,30,0),(19,15,37,8),(19,16,0,5),(19,16,8,1),(19,16,9,8),(19,16,10,8),(19,16,11,13),(19,16,13,0),(19,16,14,0),(19,16,15,7),(19,16,19,10),(19,16,30,2),(19,16,31,1),(19,16,36,9),(19,16,39,3),(19,17,7,3),(19,17,12,6),(19,17,16,10),(19,17,17,0),(19,17,29,7),(19,17,30,11),(19,17,32,8),(19,17,33,1),(19,17,39,11),(19,18,18,2),(19,19,2,7),(19,20,0,13),(19,20,3,6),(19,20,14,2),(19,20,19,2),(19,21,5,12),(19,21,15,8),(19,21,17,13),(19,22,1,10),(19,22,2,3),(19,22,5,2),(19,22,13,7),(19,22,18,0),(19,23,12,6),(19,23,17,2),(19,23,20,1),(19,23,22,2),(19,23,24,11),(19,23,25,1),(19,23,26,2),(19,23,37,0),(19,24,0,4),(19,24,17,3),(19,24,22,7),(19,24,23,11),(19,24,25,11),(19,24,28,0),(19,25,20,10),(19,25,24,7),(19,25,28,1),(19,26,10,5),(19,27,7,8),(19,27,12,2),(19,27,25,1),(19,27,26,4),(19,27,39,2),(19,27,40,7),(19,28,7,12),(19,28,10,7),(19,28,14,13),(19,28,23,9),(19,28,26,13),(19,28,27,6),(19,28,28,0),(19,28,30,9),(19,28,31,6),(19,28,33,2),(19,29,15,6),(19,29,16,4),(19,29,24,5),(19,29,31,8),(19,29,36,2),(19,29,40,9),(19,30,23,2),(19,30,29,7),(19,30,35,2),(19,30,37,8),(19,31,24,6),(19,31,37,10),(19,32,4,8),(19,32,24,4),(19,32,35,0),(19,32,37,13),(19,32,40,1),(19,33,7,6),(19,33,37,8),(19,33,40,11),(19,34,3,0),(19,34,4,3),(19,34,10,2),(19,34,35,11),(19,34,40,7),(19,35,4,2),(19,35,13,5),(19,35,15,0),(19,35,16,13),(19,36,17,5),(19,36,22,3),(19,36,25,0),(19,36,40,9),(22,0,5,3),(22,0,6,7),(22,0,9,6),(22,1,27,11),(22,2,28,4),(22,3,2,11),(22,3,11,3),(22,4,5,5),(22,5,1,12),(22,5,17,2),(22,5,19,11),(22,6,1,5),(22,6,3,4),(22,6,8,1),(22,6,9,5),(22,6,16,4),(22,7,9,6),(22,7,10,6),(22,7,13,13),(22,8,9,10),(22,9,7,2),(22,9,9,8),(22,9,10,9),(22,10,19,1),(22,10,20,7),(22,11,0,9),(22,11,10,4),(22,11,13,9),(22,11,15,11),(22,11,20,12),(22,11,21,7),(22,12,7,9),(22,12,8,8),(22,12,15,6),(22,12,21,1),(22,13,0,1),(22,13,4,11),(22,13,7,1),(22,13,8,6),(22,13,9,11),(22,13,19,3),(22,13,21,3),(22,13,22,7),(22,13,26,9),(22,14,4,1),(22,14,6,4),(22,14,23,3),(22,14,24,1),(22,15,0,1),(22,15,7,6),(22,15,17,3),(22,15,18,8),(22,15,19,2),(22,15,24,3),(22,16,3,10),(22,16,6,1),(22,16,24,0),(22,16,25,5),(22,17,2,7),(22,17,17,9),(22,17,19,4),(22,17,23,2),(22,18,3,0),(22,18,4,9),(22,18,11,3),(22,18,14,6),(22,18,17,5),(22,18,18,6),(22,18,19,3),(22,18,23,6),(22,19,3,1),(22,19,9,10),(22,19,12,1),(22,19,18,5),(22,19,19,5),(22,19,20,6),(22,19,21,7),(22,19,23,9),(22,20,2,2),(22,20,5,12),(22,20,16,0),(22,21,1,11),(22,21,12,3),(22,21,16,0),(22,21,17,5),(22,21,20,13),(22,21,24,2),(22,22,6,10),(22,22,8,7),(22,22,9,2),(22,22,12,9),(22,22,21,3),(22,22,25,2),(22,23,6,11),(22,23,9,10),(22,23,10,11),(22,23,12,8),(22,23,14,8),(22,23,17,4),(22,23,22,9),(22,24,5,3),(22,24,9,7),(22,24,14,1),(22,24,16,4),(22,24,23,1),(22,25,1,3),(22,25,6,2),(22,25,7,7),(22,26,4,7),(22,26,11,9),(22,26,18,7),(22,27,4,1),(22,27,9,0),(22,27,10,3),(22,27,15,1),(22,27,29,9),(22,28,9,9),(22,28,16,7),(22,29,16,7),(27,0,7,0),(27,0,13,4),(27,0,21,3),(27,0,22,4),(27,0,23,3),(27,0,24,6),(27,0,27,0),(27,1,16,7),(27,1,22,1),(27,2,7,10),(27,2,25,11),(27,2,26,9),(27,3,19,13),(27,3,20,12),(27,3,21,6),(27,3,24,3),(27,4,0,11),(27,4,17,10),(27,4,18,5),(27,4,25,6),(27,4,26,12),(27,5,17,12),(27,5,27,6),(27,6,1,9),(27,6,19,3),(27,6,21,9),(27,6,25,6),(27,7,0,7),(27,7,11,13),(27,7,19,0),(27,8,1,0),(27,8,11,4),(27,8,14,4),(27,8,19,11),(27,8,21,13),(27,8,27,13),(27,9,2,7),(27,9,5,12),(27,9,7,2),(27,9,15,5),(27,9,16,10),(27,9,18,2),(27,10,6,3),(27,10,15,2),(27,10,16,0),(27,11,0,13),(27,11,4,5),(27,11,6,4),(27,11,18,7),(27,12,8,5),(27,12,14,3),(27,12,19,1),(27,13,3,12),(27,13,10,8),(27,13,13,11),(27,14,10,13),(27,14,13,7),(27,14,15,6),(27,14,19,11),(27,15,1,13),(27,15,14,13),(27,16,22,5),(27,17,21,5),(27,19,1,1),(27,19,2,8),(27,19,7,1),(27,19,21,9),(27,19,22,7),(27,19,23,5),(27,20,8,2),(27,20,16,2),(27,20,19,4),(27,20,21,12),(27,20,26,5),(27,21,3,9),(27,22,3,4),(27,22,7,7),(27,22,8,11),(27,22,9,11),(27,22,16,8),(27,22,20,10),(27,22,21,2),(27,23,4,6),(27,23,18,2),(27,23,20,5),(27,23,21,1),(27,24,5,8),(27,24,10,1),(27,24,14,1),(27,24,16,6),(27,24,18,1),(27,24,22,0),(27,25,4,1),(27,25,7,3),(27,25,12,2),(27,25,13,1),(27,25,16,10),(27,26,4,5),(27,26,5,2),(27,26,6,12),(27,26,17,10),(27,26,20,9),(27,26,21,11),(27,27,3,10),(27,27,16,1),(27,28,0,5),(27,28,13,4),(27,28,15,3),(27,28,18,11),(27,28,25,5),(27,29,2,11),(27,29,14,3),(27,29,21,10),(27,29,22,3),(27,30,2,4),(27,30,3,0),(27,30,4,4),(27,31,2,11),(27,31,10,11),(27,32,3,13),(27,32,15,0),(27,34,7,2),(27,34,8,12),(27,35,0,7),(27,35,2,5),(27,35,3,1),(27,35,6,13),(27,35,25,13),(38,0,0,11),(38,0,3,11),(38,0,4,4),(38,0,13,2),(38,0,15,13),(38,0,18,4),(38,0,19,10),(38,0,22,12),(38,0,30,0),(38,0,31,11),(38,1,12,11),(38,1,15,9),(38,1,30,7),(38,2,3,10),(38,2,5,4),(38,2,11,6),(38,2,15,7),(38,2,18,2),(38,2,19,10),(38,2,22,8),(38,2,32,12),(38,3,3,3),(38,4,4,10),(38,4,5,6),(38,4,7,1),(38,4,9,10),(38,4,26,5),(38,5,4,3),(38,5,6,1),(38,5,8,10),(38,5,13,8),(38,5,22,13),(38,5,23,2),(38,5,24,0),(38,5,25,11),(38,5,27,13),(38,6,7,1),(38,6,8,12),(38,6,11,10),(38,6,23,2),(38,6,27,11),(38,7,7,7),(38,7,13,10),(38,7,17,9),(38,7,27,4),(38,8,0,2),(38,8,13,12),(38,8,24,1),(38,8,25,12),(38,9,17,6),(38,9,23,0),(38,9,24,7),(38,9,31,7),(38,10,0,3),(38,10,15,10),(38,10,16,8),(38,10,23,1),(38,11,1,10),(38,11,6,11),(38,11,15,7),(38,11,24,10),(38,11,25,6),(38,12,8,4),(38,12,25,9),(38,12,26,9),(38,12,27,12),(38,12,28,11),(38,12,29,4),(38,12,30,5),(38,13,8,10),(38,13,10,2),(38,13,14,11),(38,13,15,7),(38,13,25,13),(38,13,27,6),(38,13,29,4),(38,14,9,6),(38,14,15,2),(38,14,21,9),(38,14,24,1),(38,14,30,1),(38,14,32,6),(38,15,10,3),(38,15,20,13),(38,15,21,6),(38,15,22,11),(38,15,23,10),(38,15,27,0),(38,16,0,11),(38,16,22,1),(38,16,29,0),(38,16,31,11),(38,17,0,12),(38,17,20,6),(38,17,23,6),(38,17,25,1),(38,17,26,8),(38,17,31,5),(38,17,32,7),(38,18,8,11),(38,18,19,5),(38,18,20,9),(38,18,25,4),(38,18,27,6),(38,18,31,6),(38,19,6,10),(38,19,15,6),(38,19,22,7),(38,19,23,6),(38,20,6,3),(38,20,15,11),(38,20,25,6),(38,21,17,11),(38,21,19,13),(38,21,28,5),(38,21,30,0),(38,22,16,5),(38,22,18,11),(38,22,22,11),(38,22,31,7),(38,23,7,13),(38,23,13,1),(38,24,5,6),(38,24,6,2),(38,24,7,11),(38,24,8,9),(38,24,10,10),(38,24,21,3),(38,24,22,3),(38,24,26,3),(38,24,28,3),(38,25,8,2),(38,25,16,9),(38,25,17,8),(38,25,29,13),(38,25,31,5),(38,25,32,1),(38,26,7,4),(38,26,8,13),(38,26,10,9),(38,26,13,10),(38,26,15,1),(38,26,18,5),(38,26,24,6),(38,26,26,9),(38,27,8,6),(38,27,18,10),(38,27,19,5),(38,27,28,9),(38,27,32,4),(38,28,8,3),(38,28,12,3),(38,28,16,0),(38,28,18,13),(38,28,19,6),(38,28,26,1),(38,28,27,0),(38,29,7,10),(38,29,8,1),(38,29,9,8),(38,29,13,1),(38,29,14,1),(38,29,16,3),(38,29,19,0),(38,29,21,10),(39,0,0,5),(39,0,1,0),(39,0,11,9),(39,0,15,3),(39,0,16,9),(39,0,27,1),(39,0,31,9),(39,0,41,5),(39,0,42,6),(39,0,43,11),(39,0,48,3),(39,0,52,0),(39,1,2,2),(39,1,20,4),(39,1,21,11),(39,1,22,0),(39,1,37,13),(39,1,38,9),(39,1,43,3),(39,2,0,2),(39,2,1,3),(39,2,3,1),(39,2,4,12),(39,2,10,1),(39,2,20,0),(39,2,22,6),(39,2,37,3),(39,2,41,11),(39,2,47,7),(39,2,49,5),(39,2,50,6),(39,3,19,0),(39,3,51,8),(39,4,11,11),(39,4,15,7),(39,4,16,4),(39,4,17,10),(39,4,21,5),(39,4,34,12),(39,4,36,10),(39,4,42,3),(39,4,46,13),(39,5,0,5),(39,5,2,3),(39,5,4,4),(39,5,17,6),(39,5,42,0),(39,5,43,7),(39,5,48,5),(39,6,1,10),(39,6,2,3),(39,6,12,7),(39,6,26,5),(39,6,36,4),(39,6,40,8),(39,6,42,3),(39,6,46,4),(39,7,1,1),(39,7,36,0),(39,7,41,3),(39,7,43,0),(39,8,12,11),(39,8,13,2),(39,8,14,5),(39,8,15,9),(39,8,19,3),(39,8,20,7),(39,8,24,9),(39,8,27,4),(39,8,38,6),(39,8,39,4),(39,8,40,2),(39,8,42,11),(39,9,3,2),(39,9,11,6),(39,9,16,2),(39,9,25,10),(39,9,31,10),(39,9,36,3),(39,9,37,9),(39,9,39,3),(39,9,41,0),(39,9,42,10),(39,9,44,6),(39,9,51,3),(39,9,53,4),(39,10,0,9),(39,10,4,1),(39,10,11,4),(39,10,16,2),(39,10,18,8),(39,10,36,5),(39,10,42,8),(39,10,43,0),(39,10,44,3),(39,10,53,2),(39,10,54,1),(39,11,17,10),(39,11,18,10),(39,11,24,9),(39,11,35,1),(39,11,37,7),(39,11,41,4),(39,12,24,8),(39,12,25,8),(39,12,33,10),(39,12,39,10),(39,12,40,4),(39,12,43,4),(39,12,52,1),(39,13,2,2),(39,13,27,10),(39,13,38,9),(39,13,41,4),(39,13,42,2),(39,13,43,9),(39,13,48,7),(39,14,0,2),(39,14,3,2),(39,14,5,11),(39,14,17,3),(39,14,39,10),(39,14,40,10),(39,14,43,5),(39,14,44,6),(39,15,4,13),(39,15,24,3),(39,15,47,7),(39,16,22,9),(39,16,45,7),(39,16,46,6),(39,17,0,4),(39,17,6,4),(39,17,7,6),(39,17,15,7),(39,17,24,4),(39,17,29,0),(39,17,30,12),(39,17,50,11),(39,18,8,11),(39,18,22,5),(39,18,23,0),(39,18,25,3),(39,18,29,10),(39,18,41,4),(39,19,1,0),(39,19,4,1),(39,19,5,7),(39,19,22,5),(39,19,37,2),(39,19,40,5),(39,19,42,13),(39,20,0,4),(39,20,2,7),(39,20,22,10),(39,20,24,7),(39,20,32,4),(39,20,54,3),(39,21,5,5),(39,21,7,0),(39,21,9,1),(39,21,10,0),(39,21,11,0),(39,21,12,13),(39,21,13,4),(39,21,25,11),(39,21,31,6),(39,21,38,4),(39,21,42,2),(39,22,1,5),(39,22,3,7),(39,22,4,9),(39,22,8,10),(39,22,11,10),(39,22,15,13),(39,22,23,3),(39,22,24,0),(39,22,31,7),(39,22,38,1),(39,22,41,6),(39,22,53,7),(39,22,54,9),(39,23,6,9),(39,23,7,8),(39,23,31,10),(39,23,33,9),(39,23,41,10),(39,23,48,8),(39,24,0,6),(39,24,1,8),(39,24,18,3),(39,24,38,0),(39,24,41,4),(39,24,45,9),(39,25,0,2),(39,25,3,13),(39,25,4,6),(39,25,10,8),(39,25,15,4),(39,25,17,11),(39,25,25,0),(39,25,28,9),(39,25,30,2),(39,25,32,3),(39,25,33,2),(39,25,37,7),(39,25,40,13),(39,25,41,7),(39,25,43,10),(39,25,44,10),(39,25,48,4),(39,25,49,3),(45,0,11,8),(45,0,15,4),(45,0,19,11),(45,0,33,1),(45,0,37,8),(45,0,41,10),(45,1,1,5),(45,1,10,6),(45,1,11,7),(45,1,12,3),(45,1,13,5),(45,1,14,12),(45,1,26,10),(45,1,33,6),(45,1,38,11),(45,1,39,11),(45,2,0,3),(45,2,2,10),(45,2,5,2),(45,2,6,10),(45,2,8,9),(45,2,10,1),(45,2,11,11),(45,2,17,3),(45,2,31,4),(45,2,36,11),(45,2,39,10),(45,2,42,11),(45,3,0,13),(45,3,6,1),(45,3,7,2),(45,3,10,7),(45,3,17,11),(45,3,20,9),(45,3,27,5),(45,3,31,4),(45,3,36,2),(45,4,0,8),(45,4,11,9),(45,4,14,6),(45,5,30,2),(45,6,9,0),(45,6,20,0),(45,6,31,11),(45,6,37,13),(45,6,39,4),(45,6,40,5),(45,7,8,6),(45,7,10,7),(45,7,17,10),(45,7,23,4),(45,7,30,1),(45,7,33,12),(45,8,9,6),(45,8,18,9),(45,8,38,5),(45,8,44,8),(45,9,3,0),(45,9,25,4),(45,9,34,11),(45,9,36,4),(45,9,38,5),(45,9,39,2),(45,9,42,7),(45,9,43,8),(45,9,45,5),(45,10,1,0),(45,10,16,7),(45,11,2,4),(45,11,10,8),(45,11,20,1),(45,11,35,7),(45,11,42,6),(45,11,43,6),(45,12,1,4),(45,12,5,10),(45,12,12,4),(45,12,39,11),(45,13,11,11),(45,13,24,3),(45,13,41,11),(45,14,17,6),(45,14,24,1),(45,14,34,8),(45,14,42,7),(45,15,12,9),(45,15,16,4),(45,15,18,7),(45,15,22,11),(45,15,32,13),(45,15,34,3),(45,16,0,2),(45,16,19,1),(45,16,33,6),(45,16,35,3),(45,16,39,4),(45,16,41,8),(45,17,5,7),(45,17,22,5),(45,18,1,9),(45,18,3,9),(45,18,4,11),(45,18,11,6),(45,18,17,4),(45,18,34,0),(45,19,25,8),(45,19,33,10),(45,20,19,0),(45,20,21,0),(45,20,25,3),(45,20,32,11),(45,21,17,11),(45,21,21,11),(45,21,25,11),(45,22,33,4),(45,22,34,9),(45,22,43,1),(45,22,45,11),(45,23,12,1),(45,23,16,2),(45,23,18,7),(45,23,19,1),(45,23,23,4),(45,23,33,7),(45,23,43,9),(45,24,15,6),(45,24,19,7),(45,24,25,5),(45,24,45,7);
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
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `fow_ss_entries`
--

LOCK TABLES `fow_ss_entries` WRITE;
/*!40000 ALTER TABLE `fow_ss_entries` DISABLE KEYS */;
INSERT INTO `fow_ss_entries` VALUES (1,1,1,1,1,0,0,0,NULL,NULL,NULL,NULL,NULL),(2,2,1,1,1,0,0,0,NULL,NULL,NULL,NULL,NULL),(3,3,1,1,1,0,0,0,NULL,NULL,NULL,NULL,NULL),(4,4,1,1,1,0,0,0,NULL,NULL,NULL,NULL,NULL);
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
INSERT INTO `galaxies` VALUES (1,'2010-10-26 17:39:18','dev');
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
INSERT INTO `objectives` VALUES (1,1,'HaveUpgradedTo','Building::MetalExtractor',1,1,0,0),(2,1,'HaveUpgradedTo','Building::SolarPlant',2,1,0,0),(3,2,'HaveUpgradedTo','Building::Barracks',1,1,0,0),(4,3,'UpgradeTo','Unit::Trooper',3,1,0,0),(5,4,'UpgradeTo','Unit::Shocker',2,1,0,0),(6,5,'Destroy','Unit::Gnat',10,1,0,0),(7,5,'Destroy','Unit::Glancer',5,1,0,0),(8,6,'HaveUpgradedTo','Building::GroundFactory',1,1,0,0),(9,7,'HaveUpgradedTo','Building::SpaceFactory',1,1,0,0),(10,8,'AnnexPlanet','Planet',1,NULL,0,1),(11,9,'AnnexPlanet','Planet',1,NULL,0,0),(12,10,'HaveUpgradedTo','Unit::Trooper',10,1,0,0),(13,10,'HaveUpgradedTo','Unit::Shocker',5,1,0,0),(14,10,'HaveUpgradedTo','Unit::Seeker',5,1,0,0);
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
INSERT INTO `solar_systems` VALUES (1,'Resource',1,2,1),(2,'Expansion',1,2,0),(3,'Homeworld',1,1,1),(4,'Expansion',1,0,1);
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
) ENGINE=InnoDB AUTO_INCREMENT=46 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ss_objects`
--

LOCK TABLES `ss_objects` WRITE;
/*!40000 ALTER TABLE `ss_objects` DISABLE KEYS */;
INSERT INTO `ss_objects` VALUES (1,1,0,0,5,75,'Jumpgate',NULL,'',33,0,0,0,0,0,0,0,0,0,0,NULL,0),(2,1,0,0,3,112,'Asteroid',NULL,'',28,0,0,0,1,0,0,3,0,0,1,NULL,0),(3,1,0,0,1,225,'Asteroid',NULL,'',27,0,0,0,1,0,0,0,0,0,0,NULL,0),(4,1,0,0,1,90,'Asteroid',NULL,'',30,0,0,0,3,0,0,1,0,0,1,NULL,0),(5,1,0,0,5,285,'Jumpgate',NULL,'',46,0,0,0,0,0,0,0,0,0,0,NULL,0),(6,1,0,0,3,336,'Asteroid',NULL,'',55,0,0,0,3,0,0,1,0,0,1,NULL,0),(7,1,0,0,1,315,'Asteroid',NULL,'',38,0,0,0,1,0,0,2,0,0,1,NULL,0),(8,1,0,0,3,90,'Asteroid',NULL,'',39,0,0,0,1,0,0,3,0,0,1,NULL,0),(9,1,0,0,3,224,'Asteroid',NULL,'',58,0,0,0,1,0,0,1,0,0,3,NULL,0),(10,1,0,0,0,180,'Asteroid',NULL,'',41,0,0,0,1,0,0,1,0,0,1,NULL,0),(11,1,32,39,0,0,'Planet',NULL,'P-11',54,1,0,0,0,0,0,0,0,0,0,NULL,0),(12,2,27,38,2,120,'Planet',NULL,'P-12',52,1,0,0,0,0,0,0,0,0,0,NULL,0),(13,2,0,0,2,180,'Asteroid',NULL,'',35,0,0,0,1,0,0,0,0,0,0,NULL,0),(14,2,0,0,2,240,'Asteroid',NULL,'',35,0,0,0,3,0,0,3,0,0,1,NULL,0),(15,2,0,0,3,156,'Asteroid',NULL,'',50,0,0,0,2,0,0,2,0,0,3,NULL,0),(16,2,0,0,3,90,'Asteroid',NULL,'',32,0,0,0,2,0,0,2,0,0,2,NULL,0),(17,2,0,0,3,66,'Asteroid',NULL,'',40,0,0,0,0,0,0,0,0,0,0,NULL,0),(18,2,0,0,1,0,'Asteroid',NULL,'',60,0,0,0,0,0,0,1,0,0,1,NULL,0),(19,2,37,41,3,224,'Planet',NULL,'P-19',57,1,0,0,0,0,0,0,0,0,0,NULL,0),(20,2,0,0,5,165,'Jumpgate',NULL,'',46,0,0,0,0,0,0,0,0,0,0,NULL,0),(21,3,0,0,1,45,'Asteroid',NULL,'',25,0,0,0,1,0,0,0,0,0,1,NULL,0),(22,3,34,21,4,306,'Planet',1,'P-22',48,0,864,1,3024,1728,2,6048,0,0,604.8,NULL,0),(23,3,0,0,5,225,'Jumpgate',NULL,'',33,0,0,0,0,0,0,0,0,0,0,NULL,0),(24,3,0,0,0,90,'Asteroid',NULL,'',31,0,0,0,0,0,0,0,0,0,0,NULL,0),(25,3,0,0,1,315,'Asteroid',NULL,'',37,0,0,0,1,0,0,0,0,0,1,NULL,0),(26,3,0,0,1,0,'Asteroid',NULL,'',38,0,0,0,0,0,0,1,0,0,1,NULL,0),(27,3,36,28,3,292,'Planet',NULL,'P-27',51,2,0,0,0,0,0,0,0,0,0,NULL,0),(28,3,0,0,1,270,'Asteroid',NULL,'',52,0,0,0,1,0,0,1,0,0,1,NULL,0),(29,4,0,0,1,45,'Asteroid',NULL,'',48,0,0,0,3,0,0,3,0,0,1,NULL,0),(30,4,0,0,5,150,'Jumpgate',NULL,'',48,0,0,0,0,0,0,0,0,0,0,NULL,0),(31,4,0,0,1,180,'Asteroid',NULL,'',46,0,0,0,1,0,0,2,0,0,3,NULL,0),(32,4,0,0,4,90,'Asteroid',NULL,'',47,0,0,0,1,0,0,3,0,0,1,NULL,0),(33,4,0,0,4,108,'Asteroid',NULL,'',37,0,0,0,1,0,0,0,0,0,1,NULL,0),(34,4,0,0,3,224,'Asteroid',NULL,'',51,0,0,0,2,0,0,2,0,0,1,NULL,0),(35,4,0,0,1,90,'Asteroid',NULL,'',39,0,0,0,1,0,0,3,0,0,3,NULL,0),(36,4,0,0,2,150,'Asteroid',NULL,'',39,0,0,0,1,0,0,1,0,0,1,NULL,0),(37,4,0,0,4,216,'Asteroid',NULL,'',31,0,0,0,3,0,0,1,0,0,1,NULL,0),(38,4,30,33,3,44,'Planet',NULL,'P-38',51,1,0,0,0,0,0,0,0,0,0,NULL,0),(39,4,26,55,1,135,'Planet',NULL,'P-39',58,0,0,0,0,0,0,0,0,0,0,NULL,0),(40,4,0,0,2,180,'Asteroid',NULL,'',51,0,0,0,1,0,0,0,0,0,1,NULL,0),(41,4,0,0,4,0,'Asteroid',NULL,'',26,0,0,0,0,0,0,0,0,0,0,NULL,0),(42,4,0,0,4,324,'Asteroid',NULL,'',51,0,0,0,0,0,0,1,0,0,0,NULL,0),(43,4,0,0,3,336,'Asteroid',NULL,'',43,0,0,0,0,0,0,0,0,0,1,NULL,0),(44,4,0,0,2,270,'Asteroid',NULL,'',49,0,0,0,1,0,0,3,0,0,1,NULL,0),(45,4,25,46,0,180,'Planet',NULL,'P-45',54,0,0,0,0,0,0,0,0,0,0,NULL,0);
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
INSERT INTO `tiles` VALUES (6,11,0,12),(6,11,0,13),(6,11,0,14),(6,11,0,15),(6,11,0,16),(6,11,0,17),(6,11,1,6),(6,11,1,7),(6,11,1,8),(1,11,1,14),(6,11,1,16),(6,11,1,17),(6,11,1,18),(6,11,1,19),(2,11,1,20),(6,11,2,7),(6,11,2,8),(6,11,2,16),(6,11,2,19),(6,11,3,6),(6,11,3,7),(6,11,3,8),(6,11,3,9),(6,11,3,16),(6,11,3,17),(6,11,3,19),(6,11,4,6),(6,11,4,8),(6,11,4,9),(6,11,4,10),(6,11,4,16),(6,11,4,17),(9,11,4,23),(9,11,4,26),(8,11,4,30),(4,11,5,1),(6,11,5,6),(6,11,5,8),(6,11,5,9),(4,11,5,17),(4,11,5,18),(4,11,6,1),(4,11,6,2),(4,11,6,3),(4,11,6,4),(6,11,6,9),(4,11,6,17),(4,11,6,18),(4,11,6,19),(4,11,6,20),(4,11,6,21),(4,11,7,0),(4,11,7,1),(4,11,7,2),(4,11,7,3),(4,11,7,18),(4,11,7,19),(4,11,7,20),(4,11,7,21),(4,11,8,0),(4,11,8,1),(4,11,8,2),(4,11,8,3),(4,11,8,18),(4,11,8,19),(4,11,8,20),(13,11,8,37),(4,11,9,0),(4,11,9,1),(4,11,9,2),(4,11,9,3),(5,11,9,7),(5,11,9,8),(5,11,9,9),(4,11,9,16),(4,11,9,17),(4,11,9,18),(4,11,9,19),(4,11,9,20),(4,11,9,21),(4,11,9,22),(13,11,9,23),(3,11,9,31),(3,11,9,32),(4,11,10,0),(4,11,10,1),(4,11,10,2),(5,11,10,6),(5,11,10,7),(5,11,10,8),(5,11,10,9),(5,11,10,10),(5,11,10,11),(4,11,10,16),(4,11,10,17),(4,11,10,18),(4,11,10,19),(5,11,10,20),(5,11,10,21),(4,11,10,22),(3,11,10,30),(3,11,10,31),(3,11,10,32),(4,11,11,0),(4,11,11,1),(4,11,11,2),(4,11,11,3),(5,11,11,6),(5,11,11,7),(5,11,11,9),(5,11,11,10),(5,11,11,11),(5,11,11,12),(5,11,11,13),(5,11,11,14),(5,11,11,16),(5,11,11,17),(4,11,11,18),(4,11,11,19),(5,11,11,20),(5,11,11,21),(5,11,11,22),(3,11,11,31),(4,11,12,0),(4,11,12,3),(5,11,12,6),(5,11,12,7),(5,11,12,8),(5,11,12,9),(5,11,12,10),(5,11,12,11),(5,11,12,12),(5,11,12,15),(5,11,12,16),(5,11,12,17),(5,11,12,18),(4,11,12,19),(5,11,12,20),(5,11,12,21),(5,11,12,22),(3,11,12,31),(3,11,12,32),(3,11,12,33),(3,11,12,34),(4,11,13,0),(4,11,13,3),(5,11,13,5),(5,11,13,6),(5,11,13,7),(5,11,13,8),(5,11,13,9),(5,11,13,10),(5,11,13,11),(5,11,13,14),(5,11,13,15),(5,11,13,16),(5,11,13,17),(5,11,13,18),(5,11,13,19),(5,11,13,20),(5,11,13,21),(5,11,13,22),(3,11,13,31),(3,11,13,32),(4,11,14,0),(5,11,14,4),(5,11,14,5),(5,11,14,6),(5,11,14,7),(5,11,14,8),(5,11,14,9),(5,11,14,10),(5,11,14,11),(5,11,14,12),(5,11,14,16),(6,11,14,17),(5,11,14,18),(6,11,14,19),(5,11,14,20),(5,11,14,21),(5,11,14,22),(5,11,14,25),(3,11,14,29),(3,11,14,30),(3,11,14,31),(3,11,14,32),(3,11,15,2),(5,11,15,5),(5,11,15,6),(5,11,15,7),(5,11,15,8),(5,11,15,10),(5,11,15,12),(5,11,15,13),(5,11,15,14),(5,11,15,15),(5,11,15,16),(6,11,15,17),(6,11,15,18),(6,11,15,19),(5,11,15,20),(5,11,15,21),(5,11,15,22),(5,11,15,23),(5,11,15,24),(5,11,15,25),(5,11,15,26),(3,11,15,29),(3,11,15,30),(3,11,15,31),(3,11,15,32),(3,11,15,33),(3,11,16,0),(3,11,16,1),(3,11,16,2),(5,11,16,6),(5,11,16,13),(5,11,16,14),(5,11,16,15),(5,11,16,16),(6,11,16,17),(6,11,16,18),(6,11,16,19),(6,11,16,20),(6,11,16,21),(6,11,16,22),(5,11,16,23),(5,11,16,25),(5,11,16,26),(3,11,16,30),(3,11,16,31),(3,11,16,33),(3,11,17,0),(3,11,17,1),(5,11,17,13),(5,11,17,15),(6,11,17,17),(6,11,17,21),(5,11,17,23),(5,11,17,24),(5,11,17,26),(5,11,17,34),(3,11,18,1),(6,11,18,16),(6,11,18,17),(6,11,18,18),(5,11,18,24),(5,11,18,26),(5,11,18,27),(5,11,18,28),(5,11,18,32),(5,11,18,33),(5,11,18,34),(3,11,19,0),(3,11,19,1),(3,11,19,2),(3,11,19,3),(6,11,19,16),(5,11,19,27),(5,11,19,28),(5,11,19,30),(5,11,19,31),(5,11,19,32),(5,11,19,33),(5,11,19,34),(3,11,20,0),(3,11,20,1),(3,11,20,2),(5,11,20,28),(5,11,20,29),(5,11,20,30),(5,11,20,31),(5,11,20,32),(5,11,20,33),(5,11,20,34),(5,11,20,36),(5,11,20,37),(5,11,20,38),(3,11,21,0),(4,11,21,1),(4,11,21,2),(4,11,21,3),(6,11,21,28),(5,11,21,29),(5,11,21,30),(5,11,21,31),(5,11,21,32),(5,11,21,33),(5,11,21,34),(5,11,21,35),(5,11,21,36),(3,11,22,0),(3,11,22,1),(4,11,22,2),(4,11,22,3),(6,11,22,28),(6,11,22,29),(5,11,22,30),(5,11,22,31),(5,11,22,32),(5,11,22,34),(5,11,22,35),(5,11,22,36),(3,11,23,0),(3,11,23,1),(4,11,23,2),(4,11,23,3),(4,11,23,4),(6,11,23,27),(6,11,23,28),(6,11,23,29),(6,11,23,30),(5,11,23,31),(5,11,23,32),(5,11,23,33),(5,11,23,34),(5,11,23,35),(3,11,24,0),(4,11,24,1),(4,11,24,2),(4,11,24,3),(4,11,24,4),(4,11,24,5),(6,11,24,26),(6,11,24,27),(6,11,24,28),(6,11,24,29),(6,11,24,30),(5,11,24,31),(5,11,24,32),(5,11,24,33),(5,11,24,34),(5,11,24,35),(5,11,24,36),(3,11,25,0),(3,11,25,1),(4,11,25,2),(4,11,25,3),(4,11,25,4),(4,11,25,5),(4,11,25,13),(6,11,25,25),(6,11,25,26),(3,11,25,27),(3,11,25,28),(6,11,25,29),(6,11,25,30),(5,11,25,31),(3,11,26,0),(4,11,26,1),(4,11,26,2),(4,11,26,3),(4,11,26,4),(4,11,26,5),(4,11,26,12),(4,11,26,13),(3,11,26,27),(3,11,26,28),(3,11,26,29),(6,11,26,30),(3,11,27,0),(4,11,27,2),(4,11,27,3),(4,11,27,4),(4,11,27,8),(4,11,27,9),(4,11,27,10),(4,11,27,12),(4,11,27,13),(3,11,27,28),(3,11,27,29),(3,11,27,30),(3,11,27,31),(3,11,27,32),(3,11,27,33),(4,11,28,2),(4,11,28,4),(4,11,28,8),(4,11,28,9),(4,11,28,11),(4,11,28,12),(4,11,28,13),(4,11,28,14),(4,11,28,15),(3,11,28,27),(3,11,28,28),(3,11,28,29),(3,11,28,30),(3,11,28,31),(3,11,28,32),(3,11,28,34),(3,11,28,35),(4,11,29,4),(4,11,29,5),(4,11,29,9),(4,11,29,10),(4,11,29,11),(4,11,29,12),(4,11,29,13),(4,11,29,14),(4,11,29,15),(4,11,29,16),(4,11,29,17),(3,11,29,27),(3,11,29,28),(3,11,29,29),(3,11,29,30),(3,11,29,31),(3,11,29,32),(3,11,29,33),(3,11,29,34),(3,11,29,35),(3,11,29,36),(4,11,30,9),(4,11,30,10),(4,11,30,11),(4,11,30,15),(3,11,30,26),(3,11,30,27),(3,11,30,28),(3,11,30,29),(3,11,30,30),(3,11,30,31),(3,11,30,32),(3,11,30,33),(3,11,30,34),(3,11,30,35),(3,11,30,36),(4,11,31,10),(3,11,31,27),(3,11,31,28),(3,11,31,29),(3,11,31,31),(3,11,31,33),(3,11,31,34),(3,11,31,35),(3,11,31,36),(6,12,0,2),(6,12,0,3),(6,12,0,4),(12,12,0,5),(13,12,0,11),(4,12,0,13),(4,12,0,14),(4,12,0,15),(4,12,0,16),(4,12,0,17),(4,12,0,18),(4,12,0,19),(4,12,0,20),(4,12,0,21),(4,12,0,23),(4,12,0,24),(3,12,0,36),(3,12,0,37),(1,12,1,1),(6,12,1,3),(6,12,1,4),(4,12,1,13),(4,12,1,14),(4,12,1,15),(4,12,1,16),(4,12,1,17),(4,12,1,18),(4,12,1,19),(4,12,1,20),(4,12,1,21),(4,12,1,22),(4,12,1,23),(4,12,1,24),(4,12,1,25),(3,12,1,34),(3,12,1,35),(3,12,1,36),(3,12,1,37),(6,12,2,3),(6,12,2,4),(4,12,2,13),(4,12,2,14),(4,12,2,15),(4,12,2,16),(4,12,2,17),(4,12,2,20),(4,12,2,22),(4,12,2,23),(4,12,2,24),(3,12,2,33),(3,12,2,34),(3,12,2,35),(3,12,2,36),(3,12,2,37),(6,12,3,4),(4,12,3,13),(4,12,3,14),(4,12,3,16),(4,12,3,17),(4,12,3,18),(4,12,3,19),(4,12,3,20),(4,12,3,21),(4,12,3,22),(4,12,3,23),(4,12,3,24),(4,12,3,25),(5,12,3,28),(5,12,3,29),(3,12,3,33),(3,12,3,36),(3,12,3,37),(6,12,4,3),(6,12,4,4),(4,12,4,16),(4,12,4,17),(4,12,4,20),(4,12,4,21),(4,12,4,22),(4,12,4,23),(4,12,4,24),(5,12,4,28),(5,12,4,29),(5,12,4,31),(6,12,5,3),(6,12,5,4),(4,12,5,18),(4,12,5,19),(4,12,5,20),(4,12,5,21),(4,12,5,22),(5,12,5,27),(5,12,5,28),(5,12,5,29),(5,12,5,30),(5,12,5,31),(6,12,6,1),(6,12,6,2),(6,12,6,3),(6,12,6,4),(6,12,6,5),(13,12,6,11),(4,12,6,15),(4,12,6,16),(4,12,6,17),(4,12,6,18),(4,12,6,19),(4,12,6,20),(4,12,6,21),(4,12,6,22),(4,12,6,23),(4,12,6,24),(4,12,6,25),(5,12,6,28),(5,12,6,29),(5,12,6,30),(5,12,6,31),(5,12,6,32),(6,12,7,4),(6,12,7,5),(4,12,7,16),(4,12,7,17),(4,12,7,18),(4,12,7,19),(4,12,7,20),(4,12,7,21),(4,12,7,24),(5,12,7,29),(5,12,7,32),(4,12,8,18),(4,12,8,19),(4,12,8,21),(5,12,8,28),(5,12,8,29),(5,12,8,30),(5,12,8,31),(5,12,8,32),(5,12,8,33),(5,12,8,34),(5,12,9,4),(5,12,9,5),(5,12,9,30),(6,12,9,31),(5,12,9,33),(5,12,9,34),(5,12,9,35),(5,12,10,2),(5,12,10,3),(5,12,10,4),(5,12,10,5),(5,12,10,6),(6,12,10,29),(5,12,10,30),(6,12,10,31),(6,12,10,32),(5,12,10,33),(3,12,11,0),(5,12,11,4),(5,12,11,5),(5,12,11,6),(5,12,11,7),(6,12,11,28),(6,12,11,29),(6,12,11,30),(6,12,11,31),(6,12,11,32),(3,12,12,0),(5,12,12,3),(5,12,12,4),(5,12,12,5),(14,12,12,9),(6,12,12,27),(6,12,12,28),(6,12,12,31),(6,12,12,32),(3,12,13,0),(5,12,13,4),(6,12,13,30),(6,12,13,31),(6,12,13,32),(3,12,14,0),(3,12,14,1),(6,12,14,30),(6,12,14,31),(6,12,14,32),(3,12,15,0),(3,12,15,1),(11,12,15,7),(4,12,15,30),(3,12,16,0),(3,12,16,20),(3,12,16,21),(3,12,16,22),(4,12,16,29),(4,12,16,30),(4,12,16,31),(4,12,16,32),(3,12,17,0),(3,12,17,1),(3,12,17,18),(3,12,17,19),(3,12,17,20),(3,12,17,21),(4,12,17,26),(4,12,17,27),(4,12,17,28),(4,12,17,29),(4,12,17,30),(4,12,17,31),(3,12,18,0),(3,12,18,1),(3,12,18,18),(3,12,18,19),(3,12,18,21),(4,12,18,25),(4,12,18,26),(4,12,18,27),(4,12,18,28),(4,12,18,29),(4,12,18,30),(3,12,19,0),(3,12,19,8),(3,12,19,9),(3,12,19,11),(3,12,19,19),(3,12,19,20),(3,12,19,21),(3,12,19,22),(4,12,19,25),(4,12,19,26),(4,12,19,27),(4,12,19,28),(4,12,19,29),(3,12,20,0),(2,12,20,1),(3,12,20,8),(3,12,20,9),(3,12,20,10),(3,12,20,11),(3,12,20,12),(4,12,20,26),(4,12,20,27),(4,12,20,28),(3,12,21,0),(3,12,21,3),(3,12,21,4),(5,12,21,6),(3,12,21,8),(3,12,21,9),(3,12,21,10),(3,12,21,12),(4,12,21,28),(3,12,22,0),(3,12,22,1),(3,12,22,2),(3,12,22,3),(5,12,22,6),(5,12,22,7),(3,12,22,8),(3,12,22,9),(6,12,22,35),(6,12,22,36),(6,12,22,37),(3,12,23,0),(3,12,23,1),(5,12,23,5),(5,12,23,6),(10,12,23,9),(5,12,23,13),(6,12,23,35),(6,12,23,37),(3,12,24,0),(2,12,24,1),(5,12,24,3),(5,12,24,4),(5,12,24,5),(5,12,24,6),(5,12,24,13),(5,12,24,14),(5,12,24,15),(5,12,24,16),(6,12,24,35),(6,12,24,36),(6,12,24,37),(3,12,25,0),(5,12,25,3),(5,12,25,4),(5,12,25,5),(5,12,25,6),(5,12,25,13),(5,12,25,14),(5,12,25,15),(5,12,25,16),(5,12,25,17),(5,12,25,18),(6,12,25,33),(6,12,25,34),(6,12,25,35),(6,12,25,36),(6,12,25,37),(3,12,26,0),(3,12,26,1),(3,12,26,2),(5,12,26,3),(5,12,26,4),(5,12,26,13),(5,12,26,14),(5,12,26,15),(5,12,26,16),(6,12,26,32),(6,12,26,33),(6,12,26,34),(6,12,26,35),(6,12,26,36),(6,12,26,37),(4,19,0,17),(4,19,0,18),(4,19,0,19),(4,19,0,20),(4,19,0,21),(4,19,0,22),(4,19,0,23),(4,19,0,24),(4,19,0,25),(4,19,0,26),(4,19,0,27),(4,19,1,6),(4,19,1,18),(4,19,1,19),(4,19,1,20),(4,19,1,21),(4,19,1,22),(4,19,1,23),(4,19,1,24),(4,19,1,25),(4,19,1,26),(3,19,1,37),(4,19,2,6),(4,19,2,18),(4,19,2,19),(4,19,2,20),(4,19,2,21),(4,19,2,22),(4,19,2,24),(4,19,2,25),(4,19,2,26),(4,19,2,27),(5,19,2,29),(5,19,2,30),(3,19,2,34),(3,19,2,35),(3,19,2,37),(4,19,3,4),(4,19,3,5),(4,19,3,6),(4,19,3,19),(4,19,3,20),(4,19,3,21),(4,19,3,26),(4,19,3,27),(5,19,3,28),(5,19,3,29),(5,19,3,30),(3,19,3,35),(3,19,3,36),(3,19,3,37),(3,19,3,38),(3,19,3,39),(3,19,3,40),(4,19,4,4),(4,19,4,5),(4,19,4,6),(4,19,4,7),(4,19,4,8),(4,19,4,20),(5,19,4,27),(5,19,4,28),(5,19,4,29),(5,19,4,30),(5,19,4,31),(5,19,4,33),(3,19,4,37),(3,19,4,38),(3,19,4,40),(4,19,5,4),(4,19,5,20),(4,19,5,21),(4,19,5,23),(5,19,5,26),(5,19,5,27),(5,19,5,28),(5,19,5,29),(5,19,5,30),(5,19,5,32),(5,19,5,33),(5,19,5,34),(5,19,5,35),(5,19,5,36),(3,19,5,37),(3,19,5,38),(3,19,5,39),(3,19,5,40),(4,19,6,2),(4,19,6,4),(4,19,6,5),(4,19,6,6),(4,19,6,7),(4,19,6,8),(6,19,6,13),(6,19,6,14),(4,19,6,20),(4,19,6,21),(4,19,6,22),(4,19,6,23),(4,19,6,24),(4,19,6,25),(4,19,6,26),(4,19,6,27),(5,19,6,28),(4,19,6,29),(5,19,6,30),(5,19,6,31),(5,19,6,32),(5,19,6,35),(3,19,6,37),(3,19,6,38),(3,19,6,39),(3,19,6,40),(4,19,7,1),(4,19,7,2),(4,19,7,3),(4,19,7,4),(4,19,7,5),(4,19,7,6),(4,19,7,7),(4,19,7,8),(4,19,7,9),(6,19,7,13),(6,19,7,14),(6,19,7,15),(6,19,7,16),(4,19,7,21),(4,19,7,22),(4,19,7,23),(4,19,7,24),(4,19,7,25),(4,19,7,26),(4,19,7,27),(4,19,7,28),(4,19,7,29),(5,19,7,30),(5,19,7,32),(3,19,7,37),(3,19,7,38),(3,19,7,39),(4,19,8,3),(4,19,8,4),(4,19,8,7),(4,19,8,8),(6,19,8,12),(6,19,8,13),(6,19,8,14),(6,19,8,15),(6,19,8,16),(4,19,8,21),(4,19,8,22),(4,19,8,24),(4,19,8,25),(4,19,8,26),(4,19,8,29),(5,19,8,30),(5,19,8,31),(5,19,8,32),(5,19,8,33),(5,19,8,34),(5,19,8,35),(3,19,8,38),(1,19,9,1),(4,19,9,8),(6,19,9,10),(6,19,9,11),(6,19,9,13),(6,19,9,14),(6,19,9,15),(6,19,9,16),(4,19,9,20),(4,19,9,21),(4,19,9,22),(4,19,9,23),(4,19,9,24),(4,19,9,26),(4,19,9,28),(4,19,9,29),(5,19,9,30),(5,19,9,31),(5,19,9,32),(3,19,9,33),(5,19,9,34),(5,19,9,35),(3,19,9,36),(3,19,9,38),(4,19,10,6),(4,19,10,7),(4,19,10,8),(6,19,10,10),(6,19,10,11),(6,19,10,12),(6,19,10,13),(6,19,10,14),(6,19,10,15),(6,19,10,22),(3,19,10,33),(3,19,10,34),(3,19,10,36),(3,19,10,37),(3,19,10,38),(4,19,11,8),(6,19,11,11),(6,19,11,12),(6,19,11,22),(3,19,11,33),(3,19,11,34),(3,19,11,36),(3,19,11,37),(6,19,12,17),(6,19,12,20),(6,19,12,21),(6,19,12,22),(3,19,12,33),(3,19,12,34),(3,19,12,35),(3,19,12,36),(5,19,13,7),(6,19,13,15),(6,19,13,16),(6,19,13,17),(6,19,13,18),(6,19,13,19),(6,19,13,20),(6,19,13,21),(6,19,13,22),(6,19,13,23),(3,19,13,32),(3,19,13,33),(3,19,13,34),(5,19,14,6),(5,19,14,7),(5,19,14,8),(6,19,14,16),(6,19,14,17),(6,19,14,19),(6,19,14,20),(6,19,14,21),(6,19,14,22),(6,19,14,23),(3,19,14,31),(3,19,14,32),(3,19,14,33),(5,19,15,5),(5,19,15,6),(6,19,15,19),(6,19,15,20),(6,19,15,21),(3,19,15,31),(3,19,15,32),(3,19,15,33),(5,19,16,1),(5,19,16,2),(5,19,16,4),(5,19,16,5),(5,19,16,6),(5,19,16,7),(12,19,16,20),(8,19,16,26),(5,19,17,0),(5,19,17,1),(5,19,17,2),(5,19,17,4),(5,19,17,5),(5,19,17,6),(5,19,18,1),(5,19,18,2),(5,19,18,3),(5,19,18,4),(5,19,18,5),(5,19,18,6),(5,19,18,7),(5,19,18,8),(5,19,19,1),(5,19,19,3),(5,19,19,4),(5,19,19,5),(5,19,19,6),(5,19,19,7),(5,19,19,8),(5,19,19,9),(9,19,19,26),(11,19,19,29),(11,19,19,35),(5,19,20,1),(5,19,20,4),(5,19,20,5),(3,19,20,13),(5,19,21,3),(5,19,21,4),(5,19,21,6),(3,19,21,13),(3,19,21,14),(5,19,22,3),(5,19,22,4),(5,19,22,6),(5,19,22,7),(5,19,22,8),(3,19,22,14),(3,19,22,15),(5,19,23,3),(5,19,23,4),(5,19,23,5),(5,19,23,6),(5,19,23,7),(3,19,23,13),(3,19,23,14),(3,19,23,15),(4,19,23,31),(4,19,23,32),(4,19,23,33),(4,19,23,34),(4,19,23,35),(4,19,23,36),(4,19,23,38),(4,19,23,39),(4,19,23,40),(2,19,24,1),(5,19,24,3),(5,19,24,4),(5,19,24,5),(5,19,24,6),(5,19,24,7),(5,19,24,8),(5,19,24,9),(5,19,24,10),(3,19,24,11),(3,19,24,12),(3,19,24,13),(3,19,24,14),(10,19,24,31),(4,19,24,35),(4,19,24,36),(4,19,24,37),(4,19,24,38),(4,19,24,40),(3,19,25,0),(5,19,25,3),(5,19,25,4),(5,19,25,5),(5,19,25,6),(5,19,25,7),(3,19,25,10),(3,19,25,11),(3,19,25,12),(3,19,25,13),(3,19,25,14),(3,19,25,15),(3,19,25,16),(3,19,25,17),(4,19,25,35),(4,19,25,36),(4,19,25,37),(4,19,25,38),(4,19,25,40),(3,19,26,0),(5,19,26,3),(5,19,26,4),(5,19,26,5),(5,19,26,6),(5,19,26,7),(3,19,26,12),(3,19,26,15),(3,19,26,17),(3,19,26,18),(4,19,26,35),(4,19,26,36),(4,19,26,37),(4,19,26,38),(4,19,26,39),(3,19,27,0),(3,19,27,1),(3,19,27,2),(5,19,27,3),(5,19,27,4),(5,19,27,5),(5,19,27,6),(5,19,27,11),(3,19,27,15),(4,19,27,35),(4,19,27,36),(4,19,27,37),(4,19,27,38),(3,19,28,0),(3,19,28,1),(5,19,28,2),(5,19,28,3),(5,19,28,4),(5,19,28,5),(5,19,28,6),(5,19,28,9),(5,19,28,11),(4,19,28,17),(4,19,28,18),(4,19,28,19),(3,19,28,20),(3,19,28,21),(3,19,28,22),(4,19,28,34),(4,19,28,35),(4,19,28,38),(4,19,28,39),(3,19,29,0),(3,19,29,1),(3,19,29,2),(3,19,29,3),(3,19,29,4),(3,19,29,5),(5,19,29,6),(5,19,29,9),(5,19,29,10),(5,19,29,11),(5,19,29,12),(4,19,29,17),(4,19,29,18),(3,19,29,19),(3,19,29,21),(4,19,29,32),(4,19,29,33),(4,19,29,34),(3,19,30,0),(3,19,30,1),(3,19,30,3),(3,19,30,4),(3,19,30,5),(3,19,30,6),(5,19,30,11),(5,19,30,12),(5,19,30,13),(4,19,30,16),(4,19,30,17),(3,19,30,18),(3,19,30,19),(3,19,30,20),(3,19,30,21),(3,19,30,22),(6,19,30,27),(10,19,30,31),(3,19,31,3),(3,19,31,4),(3,19,31,6),(3,19,31,7),(3,19,31,8),(5,19,31,11),(5,19,31,12),(5,19,31,13),(4,19,31,15),(4,19,31,16),(4,19,31,17),(4,19,31,18),(4,19,31,19),(3,19,31,20),(3,19,31,21),(3,19,31,22),(3,19,31,23),(6,19,31,26),(6,19,31,27),(3,19,32,6),(5,19,32,8),(5,19,32,9),(5,19,32,10),(5,19,32,11),(5,19,32,12),(5,19,32,13),(5,19,32,14),(4,19,32,15),(4,19,32,16),(4,19,32,17),(4,19,32,18),(4,19,32,19),(4,19,32,20),(3,19,32,21),(3,19,32,22),(3,19,32,23),(6,19,32,25),(6,19,32,26),(6,19,32,29),(5,19,33,8),(5,19,33,10),(5,19,33,11),(4,19,33,15),(4,19,33,17),(4,19,33,18),(4,19,33,19),(3,19,33,20),(3,19,33,21),(3,19,33,22),(3,19,33,23),(6,19,33,24),(6,19,33,26),(6,19,33,27),(6,19,33,28),(6,19,33,29),(6,19,33,30),(5,19,34,7),(5,19,34,8),(5,19,34,9),(5,19,34,11),(5,19,34,12),(4,19,34,14),(4,19,34,15),(4,19,34,17),(4,19,34,18),(4,19,34,19),(4,19,34,20),(3,19,34,21),(3,19,34,22),(6,19,34,24),(6,19,34,25),(6,19,34,26),(6,19,34,27),(6,19,34,28),(6,19,34,29),(8,19,34,31),(5,19,35,7),(5,19,35,8),(5,19,35,9),(5,19,35,10),(5,19,35,11),(5,19,35,12),(4,19,35,17),(4,19,35,18),(4,19,35,19),(4,19,35,20),(3,19,35,21),(3,19,35,22),(6,19,35,26),(6,19,35,27),(6,19,35,29),(6,19,35,30),(5,19,36,6),(5,19,36,7),(5,19,36,10),(5,19,36,11),(5,19,36,12),(4,19,36,19),(4,19,36,20),(4,19,36,21),(6,19,36,28),(6,19,36,29),(6,19,36,30),(5,22,0,0),(5,22,0,1),(5,22,0,2),(5,22,0,3),(5,22,0,15),(5,22,0,16),(5,22,0,17),(5,22,0,18),(5,22,0,19),(5,22,0,20),(5,22,0,21),(5,22,0,22),(5,22,0,23),(5,22,0,24),(5,22,0,25),(5,22,0,26),(5,22,1,0),(5,22,1,1),(5,22,1,2),(5,22,1,3),(4,22,1,7),(4,22,1,8),(4,22,1,9),(4,22,1,10),(13,22,1,12),(5,22,1,16),(5,22,1,17),(5,22,1,18),(11,22,1,20),(5,22,1,26),(5,22,2,0),(5,22,2,1),(5,22,2,2),(4,22,2,6),(4,22,2,7),(4,22,2,8),(4,22,2,9),(5,22,2,14),(5,22,2,15),(5,22,2,16),(5,22,2,17),(5,22,2,19),(5,22,2,26),(5,22,2,27),(5,22,3,0),(5,22,3,1),(4,22,3,5),(4,22,3,6),(4,22,3,7),(4,22,3,8),(4,22,3,9),(5,22,3,15),(5,22,3,16),(5,22,3,17),(5,22,3,18),(5,22,3,19),(5,22,4,1),(5,22,4,2),(5,22,4,3),(4,22,4,6),(4,22,4,7),(4,22,4,8),(6,22,4,11),(5,22,4,16),(5,22,4,17),(5,22,5,2),(5,22,5,3),(4,22,5,5),(4,22,5,6),(4,22,5,7),(6,22,5,10),(6,22,5,11),(6,22,5,20),(6,22,5,21),(6,22,6,10),(6,22,6,11),(6,22,6,18),(6,22,6,20),(6,22,6,21),(6,22,6,22),(12,22,7,1),(6,22,7,11),(6,22,7,19),(6,22,7,20),(6,22,8,11),(6,22,8,12),(6,22,8,13),(6,22,8,19),(6,22,8,20),(6,22,9,12),(6,22,9,13),(6,22,9,14),(6,22,9,20),(3,22,9,25),(3,22,9,26),(6,22,10,12),(6,22,10,13),(8,22,10,22),(3,22,10,25),(3,22,10,26),(3,22,10,27),(3,22,10,29),(3,22,11,26),(3,22,11,27),(3,22,11,28),(3,22,11,29),(3,22,12,27),(3,22,12,28),(3,22,12,29),(3,22,13,25),(3,22,13,27),(3,22,13,28),(3,22,13,29),(3,22,14,25),(3,22,14,26),(3,22,14,27),(3,22,14,28),(3,22,14,29),(3,22,15,25),(3,22,15,26),(3,22,15,27),(3,22,15,28),(3,22,15,29),(5,22,16,0),(3,22,16,26),(3,22,16,27),(3,22,16,28),(3,22,16,29),(5,22,17,0),(5,22,17,1),(3,22,17,25),(3,22,17,26),(3,22,17,27),(3,22,17,28),(3,22,17,29),(5,22,18,0),(5,22,18,1),(3,22,18,24),(3,22,18,25),(3,22,18,26),(3,22,18,27),(3,22,18,28),(3,22,18,29),(5,22,19,0),(3,22,19,24),(3,22,19,25),(3,22,19,26),(3,22,19,27),(3,22,19,28),(3,22,19,29),(5,22,20,0),(5,22,20,1),(3,22,20,24),(3,22,20,25),(3,22,20,26),(3,22,20,27),(3,22,20,28),(3,22,20,29),(5,22,21,0),(3,22,21,25),(3,22,21,26),(3,22,21,27),(3,22,21,28),(3,22,21,29),(5,22,22,0),(14,22,22,1),(3,22,22,27),(3,22,22,28),(3,22,22,29),(5,22,23,0),(4,22,23,20),(3,22,23,26),(3,22,23,27),(3,22,23,28),(3,22,23,29),(5,22,24,0),(4,22,24,18),(4,22,24,19),(4,22,24,20),(4,22,24,21),(4,22,24,22),(3,22,24,27),(3,22,24,28),(5,22,25,0),(5,22,25,2),(4,22,25,19),(4,22,25,20),(4,22,25,21),(4,22,25,22),(5,22,26,0),(5,22,26,1),(5,22,26,2),(6,22,26,6),(6,22,26,7),(2,22,26,16),(4,22,26,19),(4,22,26,20),(4,22,26,21),(4,22,26,22),(4,22,26,23),(6,22,27,5),(6,22,27,6),(5,22,27,7),(5,22,27,8),(5,22,27,11),(5,22,27,12),(4,22,27,19),(4,22,27,20),(4,22,27,21),(4,22,27,22),(4,22,27,23),(4,22,27,24),(5,22,28,1),(5,22,28,2),(5,22,28,3),(5,22,28,4),(6,22,28,5),(6,22,28,6),(5,22,28,7),(5,22,28,8),(5,22,28,10),(5,22,28,11),(5,22,28,12),(5,22,28,13),(5,22,28,14),(4,22,28,19),(4,22,28,20),(4,22,28,21),(4,22,28,22),(4,22,28,23),(5,22,29,2),(6,22,29,3),(6,22,29,4),(6,22,29,5),(6,22,29,6),(5,22,29,7),(5,22,29,8),(5,22,29,9),(5,22,29,10),(5,22,29,11),(5,22,29,12),(5,22,29,13),(4,22,29,18),(4,22,29,19),(4,22,29,20),(4,22,29,21),(4,22,29,22),(11,27,0,0),(8,27,0,8),(13,27,1,12),(4,27,2,14),(4,27,2,15),(4,27,2,17),(4,27,3,14),(4,27,3,15),(4,27,3,16),(4,27,3,17),(4,27,3,18),(6,27,3,23),(14,27,4,4),(14,27,4,8),(4,27,4,15),(4,27,4,16),(6,27,4,21),(6,27,4,22),(6,27,4,23),(6,27,4,24),(4,27,5,14),(4,27,5,15),(4,27,5,16),(6,27,5,22),(6,27,5,23),(6,27,5,24),(4,27,6,14),(4,27,6,15),(4,27,6,16),(4,27,6,17),(6,27,6,22),(6,27,6,23),(9,27,7,8),(13,27,7,12),(4,27,7,15),(4,27,7,16),(4,27,7,17),(6,27,7,22),(6,27,7,23),(4,27,8,16),(4,27,8,17),(6,27,8,22),(6,27,8,23),(4,27,8,24),(4,27,8,26),(4,27,9,20),(4,27,9,21),(4,27,9,24),(4,27,9,25),(4,27,9,26),(4,27,9,27),(2,27,10,1),(4,27,10,20),(4,27,10,21),(4,27,10,22),(4,27,10,23),(4,27,10,24),(4,27,10,25),(4,27,10,26),(4,27,11,22),(4,27,11,23),(5,27,11,24),(4,27,11,25),(4,27,11,26),(5,27,12,17),(4,27,12,21),(4,27,12,22),(4,27,12,23),(5,27,12,24),(5,27,12,25),(3,27,12,26),(3,27,12,27),(12,27,13,4),(5,27,13,16),(5,27,13,17),(5,27,13,18),(5,27,13,19),(5,27,13,22),(5,27,13,23),(5,27,13,24),(5,27,13,25),(5,27,13,26),(3,27,13,27),(5,27,14,17),(5,27,14,22),(5,27,14,23),(5,27,14,24),(5,27,14,25),(3,27,14,26),(3,27,14,27),(10,27,15,10),(5,27,15,17),(5,27,15,18),(5,27,15,23),(5,27,15,24),(3,27,15,25),(3,27,15,26),(3,27,15,27),(5,27,16,16),(5,27,16,17),(5,27,16,18),(5,27,16,23),(3,27,16,24),(3,27,16,25),(3,27,16,26),(3,27,16,27),(5,27,17,17),(5,27,17,18),(5,27,17,23),(3,27,17,25),(3,27,17,26),(3,27,17,27),(5,27,18,17),(3,27,18,23),(3,27,18,24),(3,27,18,25),(3,27,18,26),(3,27,18,27),(3,27,19,9),(3,27,19,10),(3,27,19,11),(3,27,19,12),(5,27,19,17),(5,27,19,25),(5,27,19,26),(3,27,19,27),(1,27,20,1),(3,27,20,9),(3,27,20,10),(3,27,20,11),(3,27,20,12),(3,27,20,13),(3,27,20,14),(5,27,20,17),(5,27,20,25),(3,27,21,9),(3,27,21,10),(3,27,21,11),(3,27,21,12),(5,27,21,24),(5,27,21,25),(5,27,21,26),(3,27,22,10),(3,27,22,11),(3,27,22,12),(3,27,22,13),(5,27,22,24),(5,27,22,25),(5,27,22,26),(5,27,22,27),(5,27,23,0),(5,27,23,2),(5,27,23,3),(3,27,23,9),(3,27,23,10),(5,27,23,24),(5,27,23,25),(5,27,23,26),(5,27,23,27),(5,27,24,0),(5,27,24,2),(5,27,24,3),(5,27,24,4),(3,27,24,9),(5,27,24,24),(6,27,24,25),(5,27,24,27),(5,27,25,0),(5,27,25,1),(5,27,25,2),(5,27,25,3),(3,27,25,8),(3,27,25,11),(6,27,25,23),(6,27,25,25),(5,27,26,0),(5,27,26,1),(5,27,26,2),(5,27,26,3),(3,27,26,8),(3,27,26,10),(3,27,26,11),(3,27,26,12),(3,27,26,13),(6,27,26,22),(6,27,26,23),(6,27,26,24),(6,27,26,25),(5,27,27,0),(2,27,27,1),(3,27,27,5),(3,27,27,8),(3,27,27,9),(3,27,27,10),(3,27,27,11),(6,27,27,22),(6,27,27,24),(6,27,27,25),(6,27,27,26),(6,27,27,27),(3,27,28,5),(3,27,28,6),(3,27,28,8),(3,27,28,9),(3,27,28,10),(3,27,28,11),(3,27,28,12),(6,27,28,23),(6,27,28,24),(3,27,29,4),(3,27,29,5),(3,27,29,6),(3,27,29,8),(3,27,29,9),(3,27,29,10),(3,27,29,11),(3,27,29,12),(3,27,29,13),(6,27,29,19),(3,27,29,24),(3,27,29,25),(3,27,30,6),(3,27,30,7),(3,27,30,8),(3,27,30,10),(3,27,30,11),(3,27,30,12),(3,27,30,13),(4,27,30,18),(6,27,30,19),(6,27,30,20),(6,27,30,21),(3,27,30,24),(3,27,30,25),(3,27,30,26),(3,27,31,6),(3,27,31,7),(3,27,31,8),(3,27,31,12),(4,27,31,16),(4,27,31,17),(4,27,31,18),(6,27,31,19),(6,27,31,20),(6,27,31,21),(6,27,31,22),(6,27,31,23),(3,27,31,24),(3,27,31,25),(3,27,31,26),(3,27,31,27),(3,27,32,5),(3,27,32,6),(3,27,32,7),(9,27,32,12),(4,27,32,16),(4,27,32,17),(4,27,32,18),(6,27,32,19),(6,27,32,20),(6,27,32,21),(6,27,32,22),(3,27,32,23),(3,27,32,24),(3,27,32,25),(3,27,32,26),(3,27,32,27),(1,27,33,16),(4,27,33,18),(4,27,33,19),(4,27,33,20),(6,27,33,22),(3,27,33,23),(3,27,33,24),(3,27,33,25),(3,27,33,27),(4,27,34,18),(4,27,34,19),(4,27,34,22),(3,27,34,23),(3,27,34,24),(3,27,34,27),(4,27,35,15),(4,27,35,16),(4,27,35,17),(4,27,35,18),(4,27,35,19),(4,27,35,20),(4,27,35,21),(4,27,35,22),(4,27,35,23),(3,38,0,5),(3,38,0,6),(3,38,0,7),(3,38,0,8),(3,38,0,9),(3,38,0,10),(3,38,0,11),(14,38,0,24),(3,38,1,5),(3,38,1,6),(3,38,1,7),(3,38,1,8),(3,38,1,9),(3,38,1,10),(3,38,1,11),(3,38,1,13),(3,38,1,14),(6,38,1,16),(6,38,1,17),(6,38,1,18),(6,38,1,19),(6,38,1,20),(4,38,1,28),(3,38,2,0),(3,38,2,1),(3,38,2,9),(3,38,2,10),(3,38,2,13),(3,38,2,14),(6,38,2,16),(6,38,2,17),(6,38,2,20),(6,38,2,21),(4,38,2,28),(3,38,3,0),(3,38,3,1),(3,38,3,2),(3,38,3,9),(3,38,3,10),(3,38,3,11),(3,38,3,12),(3,38,3,13),(6,38,3,16),(6,38,3,17),(6,38,3,18),(6,38,3,19),(6,38,3,20),(4,38,3,28),(4,38,3,29),(4,38,3,30),(4,38,3,31),(4,38,3,32),(3,38,4,0),(3,38,4,1),(3,38,4,2),(3,38,4,3),(3,38,4,11),(3,38,4,12),(3,38,4,13),(3,38,4,14),(4,38,4,16),(6,38,4,20),(4,38,4,29),(4,38,4,30),(4,38,4,31),(3,38,5,0),(3,38,5,1),(3,38,5,2),(3,38,5,11),(4,38,5,15),(4,38,5,16),(4,38,5,17),(4,38,5,18),(6,38,5,20),(5,38,5,28),(5,38,5,29),(4,38,5,31),(4,38,5,32),(3,38,6,1),(3,38,6,4),(4,38,6,14),(4,38,6,15),(4,38,6,16),(4,38,6,17),(4,38,6,18),(4,38,6,19),(5,38,6,29),(5,38,6,32),(3,38,7,1),(3,38,7,2),(3,38,7,3),(3,38,7,4),(4,38,7,16),(5,38,7,19),(5,38,7,20),(5,38,7,29),(5,38,7,32),(3,38,8,1),(3,38,8,2),(3,38,8,3),(3,38,8,4),(3,38,8,5),(3,38,8,6),(5,38,8,18),(5,38,8,19),(5,38,8,20),(5,38,8,21),(5,38,8,28),(5,38,8,29),(5,38,8,30),(5,38,8,31),(5,38,8,32),(3,38,9,1),(3,38,9,2),(3,38,9,3),(3,38,9,4),(6,38,9,12),(5,38,9,18),(5,38,9,19),(5,38,9,20),(5,38,9,27),(5,38,9,28),(5,38,9,29),(5,38,9,30),(5,38,9,32),(3,38,10,2),(3,38,10,3),(6,38,10,11),(6,38,10,12),(6,38,10,13),(6,38,10,14),(5,38,10,17),(5,38,10,18),(5,38,10,19),(5,38,10,20),(1,38,10,21),(1,38,10,26),(5,38,10,28),(5,38,10,29),(5,38,10,30),(5,38,10,32),(6,38,11,11),(6,38,11,12),(5,38,11,16),(5,38,11,17),(5,38,11,18),(5,38,11,19),(5,38,11,20),(5,38,11,32),(12,38,12,1),(6,38,12,11),(5,38,12,19),(5,38,12,20),(5,38,12,21),(5,38,12,22),(5,38,12,31),(5,38,12,32),(5,38,13,20),(5,38,14,12),(4,38,14,18),(4,38,14,19),(5,38,15,11),(5,38,15,12),(5,38,15,13),(4,38,15,19),(2,38,15,25),(5,38,16,9),(5,38,16,10),(5,38,16,11),(5,38,16,12),(5,38,16,13),(4,38,16,17),(4,38,16,18),(4,38,16,19),(5,38,17,8),(5,38,17,9),(5,38,17,10),(5,38,17,11),(5,38,17,12),(4,38,17,16),(4,38,17,17),(4,38,17,18),(5,38,17,24),(3,38,18,0),(3,38,18,1),(3,38,18,2),(5,38,18,10),(5,38,18,11),(5,38,18,12),(5,38,18,13),(4,38,18,14),(4,38,18,15),(4,38,18,16),(4,38,18,17),(5,38,18,21),(5,38,18,24),(3,38,19,0),(13,38,19,1),(13,38,19,3),(5,38,19,8),(5,38,19,10),(5,38,19,11),(5,38,19,12),(5,38,19,13),(5,38,19,14),(4,38,19,16),(4,38,19,17),(4,38,19,18),(5,38,19,21),(5,38,19,24),(5,38,19,25),(5,38,19,26),(3,38,20,0),(5,38,20,8),(5,38,20,9),(5,38,20,10),(5,38,20,11),(5,38,20,12),(5,38,20,13),(4,38,20,16),(4,38,20,17),(4,38,20,18),(5,38,20,20),(5,38,20,21),(5,38,20,22),(5,38,20,23),(5,38,20,24),(5,38,20,26),(3,38,21,0),(5,38,21,8),(5,38,21,10),(5,38,21,11),(5,38,21,12),(5,38,21,13),(4,38,21,14),(4,38,21,15),(4,38,21,16),(5,38,21,21),(5,38,21,22),(5,38,21,23),(5,38,21,24),(2,38,21,25),(3,38,22,0),(5,38,22,8),(5,38,22,10),(5,38,22,11),(5,38,22,12),(5,38,22,13),(5,38,22,14),(4,38,22,15),(5,38,22,23),(5,38,22,24),(3,38,23,0),(5,38,23,11),(5,38,23,12),(5,38,23,14),(4,38,23,15),(5,38,23,24),(3,38,24,0),(5,38,24,14),(5,38,24,15),(5,38,24,24),(3,38,25,0),(3,38,25,1),(3,38,25,2),(14,38,25,3),(5,38,25,23),(5,38,25,24),(3,38,26,0),(3,38,26,1),(3,38,26,2),(4,38,26,14),(8,38,27,0),(4,38,27,10),(4,38,27,11),(4,38,27,12),(4,38,27,13),(4,38,27,14),(4,38,27,15),(6,38,27,25),(4,38,28,11),(4,38,28,14),(6,38,28,25),(6,38,28,28),(6,38,28,29),(6,38,28,30),(6,38,28,31),(6,38,28,32),(4,38,29,10),(4,38,29,11),(4,38,29,12),(6,38,29,24),(6,38,29,25),(6,38,29,26),(6,38,29,27),(6,38,29,28),(6,38,29,29),(6,38,29,30),(6,38,29,31),(6,38,29,32),(14,39,0,5),(3,39,0,22),(3,39,0,23),(3,39,0,25),(5,39,0,26),(5,39,0,28),(5,39,0,29),(5,39,0,30),(5,39,0,32),(5,39,0,33),(4,39,0,35),(4,39,0,36),(4,39,0,37),(6,39,0,38),(6,39,0,39),(6,39,0,40),(14,39,1,11),(3,39,1,23),(3,39,1,24),(3,39,1,25),(5,39,1,26),(5,39,1,27),(5,39,1,28),(5,39,1,29),(5,39,1,30),(5,39,1,31),(5,39,1,32),(4,39,1,34),(4,39,1,35),(4,39,1,36),(6,39,1,39),(6,39,1,40),(9,39,1,52),(3,39,2,21),(3,39,2,23),(3,39,2,24),(3,39,2,25),(3,39,2,26),(5,39,2,28),(5,39,2,29),(5,39,2,30),(5,39,2,31),(4,39,2,32),(4,39,2,33),(4,39,2,34),(4,39,2,35),(4,39,2,36),(6,39,2,38),(6,39,2,39),(6,39,2,40),(12,39,3,5),(3,39,3,20),(3,39,3,21),(3,39,3,22),(3,39,3,23),(3,39,3,24),(3,39,3,25),(3,39,3,26),(5,39,3,27),(5,39,3,28),(5,39,3,29),(5,39,3,30),(5,39,3,31),(5,39,3,32),(4,39,3,33),(4,39,3,34),(4,39,3,36),(4,39,3,37),(6,39,3,38),(6,39,3,39),(3,39,4,22),(3,39,4,23),(3,39,4,24),(3,39,4,25),(3,39,4,26),(5,39,4,27),(5,39,4,28),(5,39,4,29),(5,39,4,30),(5,39,4,31),(5,39,4,32),(4,39,4,33),(6,39,4,37),(6,39,4,38),(6,39,4,39),(6,39,4,40),(8,39,5,13),(3,39,5,21),(3,39,5,22),(3,39,5,23),(3,39,5,24),(3,39,5,25),(3,39,5,26),(5,39,5,27),(5,39,5,28),(5,39,5,29),(5,39,5,30),(5,39,5,31),(5,39,5,32),(5,39,5,33),(5,39,5,35),(6,39,5,39),(6,39,5,49),(9,39,5,52),(3,39,6,21),(3,39,6,22),(3,39,6,23),(3,39,6,24),(3,39,6,25),(5,39,6,29),(5,39,6,30),(5,39,6,31),(3,39,6,32),(5,39,6,33),(5,39,6,34),(5,39,6,35),(6,39,6,39),(6,39,6,48),(6,39,6,49),(6,39,6,50),(3,39,7,20),(3,39,7,21),(3,39,7,22),(3,39,7,25),(5,39,7,28),(5,39,7,29),(5,39,7,30),(5,39,7,31),(5,39,7,32),(5,39,7,33),(5,39,7,34),(5,39,7,35),(6,39,7,47),(6,39,7,48),(6,39,7,49),(6,39,7,50),(6,39,7,51),(3,39,8,21),(3,39,8,22),(3,39,8,23),(3,39,8,25),(5,39,8,28),(5,39,8,29),(3,39,8,30),(5,39,8,31),(5,39,8,32),(5,39,8,33),(5,39,8,34),(6,39,8,46),(6,39,8,47),(6,39,8,48),(6,39,8,49),(6,39,8,50),(6,39,8,51),(11,39,9,5),(10,39,9,12),(3,39,9,17),(3,39,9,18),(3,39,9,19),(3,39,9,20),(3,39,9,21),(3,39,9,22),(3,39,9,23),(3,39,9,24),(3,39,9,27),(3,39,9,28),(3,39,9,29),(3,39,9,30),(5,39,9,32),(5,39,9,33),(5,39,9,34),(4,39,9,47),(4,39,9,48),(6,39,9,50),(1,39,10,2),(3,39,10,19),(3,39,10,20),(3,39,10,21),(3,39,10,23),(3,39,10,24),(3,39,10,25),(3,39,10,26),(3,39,10,27),(3,39,10,28),(3,39,10,29),(3,39,10,30),(3,39,10,32),(5,39,10,33),(5,39,10,34),(4,39,10,45),(4,39,10,47),(4,39,10,48),(3,39,11,19),(3,39,11,20),(3,39,11,21),(3,39,11,22),(3,39,11,23),(3,39,11,26),(3,39,11,27),(3,39,11,28),(3,39,11,29),(3,39,11,30),(3,39,11,31),(3,39,11,32),(5,39,11,33),(5,39,11,34),(4,39,11,44),(4,39,11,45),(4,39,11,46),(4,39,11,47),(4,39,11,48),(13,39,11,53),(5,39,12,17),(5,39,12,18),(5,39,12,19),(5,39,12,20),(5,39,12,22),(3,39,12,27),(3,39,12,28),(3,39,12,29),(3,39,12,30),(3,39,12,31),(3,39,12,32),(4,39,12,45),(4,39,12,46),(4,39,12,47),(11,39,13,10),(5,39,13,18),(5,39,13,19),(5,39,13,20),(5,39,13,21),(5,39,13,22),(5,39,13,23),(5,39,13,24),(5,39,13,25),(3,39,13,29),(3,39,13,30),(5,39,13,31),(5,39,13,32),(5,39,13,33),(5,39,13,36),(5,39,13,37),(4,39,13,46),(4,39,13,51),(4,39,13,52),(1,39,14,1),(2,39,14,7),(5,39,14,18),(5,39,14,20),(5,39,14,21),(5,39,14,22),(5,39,14,23),(5,39,14,26),(5,39,14,28),(3,39,14,29),(3,39,14,30),(3,39,14,31),(5,39,14,32),(5,39,14,33),(5,39,14,36),(5,39,14,38),(4,39,14,46),(4,39,14,47),(4,39,14,52),(5,39,15,16),(5,39,15,17),(5,39,15,18),(5,39,15,19),(5,39,15,20),(5,39,15,21),(5,39,15,22),(5,39,15,23),(5,39,15,26),(5,39,15,27),(5,39,15,28),(5,39,15,29),(5,39,15,30),(5,39,15,31),(5,39,15,32),(5,39,15,33),(5,39,15,34),(5,39,15,35),(5,39,15,36),(5,39,15,37),(5,39,15,38),(4,39,15,51),(4,39,15,52),(5,39,16,16),(5,39,16,17),(5,39,16,18),(5,39,16,19),(5,39,16,20),(5,39,16,21),(5,39,16,27),(5,39,16,28),(5,39,16,29),(5,39,16,30),(5,39,16,31),(5,39,16,32),(5,39,16,33),(5,39,16,34),(5,39,16,35),(5,39,16,36),(5,39,16,37),(5,39,16,38),(4,39,16,44),(4,39,16,47),(4,39,16,51),(4,39,16,52),(10,39,17,11),(12,39,17,16),(5,39,17,26),(5,39,17,27),(5,39,17,28),(5,39,17,32),(5,39,17,33),(5,39,17,35),(5,39,17,36),(5,39,17,37),(5,39,17,38),(5,39,17,39),(5,39,17,40),(4,39,17,44),(4,39,17,45),(4,39,17,46),(4,39,17,47),(4,39,17,51),(4,39,17,52),(3,39,18,26),(5,39,18,27),(5,39,18,28),(5,39,18,33),(5,39,18,34),(5,39,18,35),(5,39,18,36),(5,39,18,37),(5,39,18,38),(4,39,18,44),(4,39,18,45),(4,39,18,46),(4,39,18,47),(4,39,18,49),(4,39,18,50),(4,39,18,51),(4,39,18,52),(4,39,18,53),(3,39,19,26),(3,39,19,27),(3,39,19,28),(5,39,19,36),(5,39,19,38),(5,39,19,39),(4,39,19,44),(4,39,19,45),(4,39,19,46),(3,39,19,49),(4,39,19,50),(4,39,19,51),(3,39,20,26),(3,39,20,27),(3,39,20,28),(3,39,20,29),(5,39,20,34),(5,39,20,35),(5,39,20,36),(5,39,20,37),(5,39,20,38),(3,39,20,44),(4,39,20,45),(4,39,20,46),(3,39,20,47),(3,39,20,48),(3,39,20,49),(3,39,20,50),(3,39,20,51),(3,39,21,26),(3,39,21,27),(3,39,21,28),(5,39,21,36),(3,39,21,44),(3,39,21,45),(4,39,21,46),(3,39,21,47),(3,39,21,48),(3,39,21,49),(3,39,21,50),(3,39,22,25),(3,39,22,26),(3,39,22,27),(3,39,22,28),(3,39,22,44),(3,39,22,45),(3,39,22,46),(3,39,22,47),(3,39,22,48),(3,39,22,49),(6,39,22,50),(6,39,22,51),(6,39,22,52),(6,39,23,10),(6,39,23,11),(6,39,23,14),(6,39,23,15),(4,39,23,19),(4,39,23,20),(4,39,23,21),(4,39,23,22),(4,39,23,23),(3,39,23,26),(3,39,23,27),(3,39,23,28),(3,39,23,29),(3,39,23,30),(8,39,23,34),(3,39,23,44),(3,39,23,45),(3,39,23,46),(3,39,23,47),(3,39,23,49),(6,39,23,50),(6,39,23,51),(6,39,23,52),(6,39,23,53),(6,39,24,9),(6,39,24,10),(6,39,24,11),(6,39,24,12),(6,39,24,13),(6,39,24,14),(4,39,24,19),(4,39,24,20),(4,39,24,21),(4,39,24,22),(4,39,24,23),(4,39,24,24),(3,39,24,25),(3,39,24,26),(3,39,24,27),(3,39,24,28),(3,39,24,29),(3,39,24,30),(3,39,24,31),(3,39,24,43),(3,39,24,44),(3,39,24,46),(3,39,24,47),(6,39,24,49),(6,39,24,50),(6,39,24,51),(6,39,24,52),(6,39,24,53),(6,39,24,54),(6,39,25,8),(6,39,25,9),(6,39,25,11),(6,39,25,12),(6,39,25,13),(6,39,25,14),(4,39,25,18),(4,39,25,19),(4,39,25,20),(4,39,25,22),(4,39,25,23),(3,39,25,26),(3,39,25,29),(3,39,25,31),(3,39,25,46),(3,39,25,47),(6,39,25,50),(6,39,25,53),(6,39,25,54),(4,45,0,20),(4,45,0,21),(4,45,0,22),(4,45,0,23),(4,45,0,24),(4,45,0,25),(6,45,0,28),(6,45,0,29),(6,45,0,30),(5,45,0,42),(5,45,0,43),(5,45,0,44),(5,45,0,45),(4,45,1,20),(4,45,1,21),(4,45,1,22),(4,45,1,23),(6,45,1,28),(6,45,1,30),(6,45,1,31),(5,45,1,40),(5,45,1,41),(5,45,1,42),(5,45,1,43),(5,45,1,44),(5,45,1,45),(3,45,2,3),(4,45,2,22),(4,45,2,23),(6,45,2,27),(6,45,2,28),(6,45,2,29),(1,45,2,33),(5,45,2,44),(5,45,2,45),(3,45,3,3),(3,45,3,5),(5,45,3,13),(5,45,3,18),(4,45,3,21),(4,45,3,22),(4,45,3,23),(4,45,3,24),(4,45,3,25),(6,45,3,28),(5,45,3,39),(5,45,3,40),(5,45,3,41),(5,45,3,44),(5,45,3,45),(3,45,4,2),(3,45,4,3),(3,45,4,5),(5,45,4,10),(5,45,4,13),(5,45,4,16),(5,45,4,18),(4,45,4,22),(4,45,4,23),(4,45,4,24),(4,45,4,25),(4,45,4,26),(4,45,4,27),(5,45,4,39),(5,45,4,41),(5,45,4,42),(5,45,4,43),(5,45,4,44),(5,45,4,45),(3,45,5,0),(3,45,5,1),(3,45,5,2),(3,45,5,3),(3,45,5,4),(3,45,5,5),(3,45,5,6),(5,45,5,10),(5,45,5,11),(5,45,5,13),(5,45,5,14),(5,45,5,16),(5,45,5,17),(5,45,5,18),(5,45,5,19),(5,45,5,20),(4,45,5,21),(4,45,5,22),(4,45,5,25),(4,45,5,26),(6,45,5,27),(6,45,5,28),(5,45,5,41),(5,45,5,43),(5,45,5,44),(5,45,5,45),(3,45,6,1),(3,45,6,2),(3,45,6,3),(3,45,6,4),(3,45,6,5),(3,45,6,6),(5,45,6,10),(5,45,6,11),(5,45,6,12),(5,45,6,13),(5,45,6,14),(5,45,6,15),(5,45,6,16),(5,45,6,17),(5,45,6,19),(4,45,6,25),(6,45,6,26),(6,45,6,27),(5,45,6,41),(5,45,6,42),(5,45,6,43),(5,45,6,44),(5,45,6,45),(3,45,7,0),(3,45,7,1),(3,45,7,2),(3,45,7,4),(3,45,7,5),(3,45,7,6),(3,45,7,7),(5,45,7,11),(5,45,7,12),(5,45,7,13),(5,45,7,14),(5,45,7,15),(5,45,7,19),(4,45,7,24),(4,45,7,25),(6,45,7,26),(6,45,7,27),(5,45,7,42),(5,45,7,43),(5,45,7,44),(5,45,7,45),(3,45,8,0),(3,45,8,2),(3,45,8,3),(3,45,8,4),(3,45,8,5),(3,45,8,7),(5,45,8,12),(5,45,8,13),(5,45,8,15),(4,45,8,21),(4,45,8,25),(6,45,8,26),(6,45,8,27),(6,45,8,28),(6,45,8,29),(5,45,8,41),(5,45,8,42),(5,45,8,43),(3,45,9,0),(3,45,9,1),(3,45,9,2),(3,45,9,4),(6,45,9,5),(5,45,9,10),(5,45,9,11),(5,45,9,12),(5,45,9,13),(5,45,9,14),(5,45,9,15),(4,45,9,19),(4,45,9,20),(4,45,9,21),(4,45,9,22),(11,45,9,26),(6,45,10,4),(6,45,10,5),(4,45,10,19),(4,45,10,21),(4,45,10,22),(4,45,10,23),(6,45,11,4),(6,45,11,5),(6,45,11,6),(4,45,11,19),(4,45,11,21),(4,45,11,22),(2,45,11,33),(8,45,11,36),(6,45,12,3),(6,45,12,4),(5,45,12,6),(4,45,12,17),(4,45,12,19),(4,45,12,20),(4,45,12,21),(4,45,12,22),(4,45,12,23),(4,45,12,43),(6,45,13,4),(5,45,13,5),(5,45,13,6),(5,45,13,7),(4,45,13,17),(4,45,13,18),(4,45,13,19),(4,45,13,20),(4,45,13,21),(4,45,13,23),(12,45,13,26),(4,45,13,43),(4,45,13,44),(4,45,13,45),(6,45,14,4),(5,45,14,5),(5,45,14,6),(5,45,14,7),(5,45,14,8),(4,45,14,19),(4,45,14,20),(4,45,14,21),(4,45,14,22),(4,45,14,23),(9,45,14,36),(4,45,14,43),(4,45,14,44),(4,45,14,45),(5,45,15,3),(5,45,15,4),(5,45,15,5),(5,45,15,6),(5,45,15,7),(5,45,15,9),(6,45,15,13),(6,45,15,14),(4,45,15,20),(4,45,15,21),(4,45,15,43),(4,45,15,44),(4,45,15,45),(5,45,16,1),(5,45,16,2),(5,45,16,3),(5,45,16,4),(5,45,16,5),(5,45,16,6),(5,45,16,7),(5,45,16,9),(6,45,16,11),(6,45,16,12),(6,45,16,13),(6,45,16,14),(4,45,16,42),(4,45,16,43),(4,45,16,44),(4,45,16,45),(3,45,17,0),(5,45,17,3),(5,45,17,4),(5,45,17,6),(5,45,17,7),(5,45,17,8),(5,45,17,9),(5,45,17,10),(6,45,17,12),(6,45,17,13),(6,45,17,14),(4,45,17,39),(4,45,17,40),(4,45,17,41),(4,45,17,42),(4,45,17,43),(4,45,17,44),(4,45,17,45),(3,45,18,0),(5,45,18,7),(5,45,18,8),(5,45,18,9),(5,45,18,10),(3,45,18,12),(3,45,18,13),(6,45,18,14),(13,45,18,36),(4,45,18,40),(4,45,18,42),(4,45,18,43),(4,45,18,45),(3,45,19,0),(3,45,19,1),(3,45,19,2),(3,45,19,4),(5,45,19,7),(5,45,19,8),(5,45,19,9),(3,45,19,10),(3,45,19,11),(3,45,19,12),(12,45,19,26),(13,45,19,39),(4,45,19,43),(4,45,19,45),(3,45,20,0),(3,45,20,1),(3,45,20,3),(3,45,20,4),(3,45,20,5),(5,45,20,7),(3,45,20,8),(5,45,20,9),(3,45,20,10),(3,45,20,11),(3,45,20,13),(4,45,20,43),(4,45,20,44),(4,45,20,45),(3,45,21,0),(3,45,21,1),(3,45,21,2),(3,45,21,3),(3,45,21,4),(5,45,21,7),(3,45,21,8),(3,45,21,9),(3,45,21,10),(3,45,21,11),(3,45,21,12),(3,45,21,13),(6,45,21,41),(6,45,21,42),(6,45,21,43),(4,45,21,44),(3,45,22,0),(3,45,22,1),(3,45,22,3),(3,45,22,6),(3,45,22,7),(3,45,22,8),(3,45,22,9),(3,45,22,10),(3,45,22,11),(3,45,22,12),(3,45,22,13),(3,45,22,14),(6,45,22,41),(6,45,22,42),(3,45,23,0),(3,45,23,1),(3,45,23,2),(3,45,23,3),(3,45,23,4),(3,45,23,5),(3,45,23,6),(3,45,23,7),(3,45,23,8),(3,45,23,9),(3,45,23,10),(3,45,23,11),(3,45,23,13),(3,45,23,14),(6,45,23,41),(6,45,23,42),(3,45,24,0),(3,45,24,1),(3,45,24,2),(3,45,24,3),(3,45,24,4),(3,45,24,5),(3,45,24,6),(3,45,24,7),(3,45,24,8),(3,45,24,9),(3,45,24,10),(3,45,24,11),(3,45,24,12),(3,45,24,13),(3,45,24,14),(6,45,24,41),(6,45,24,42),(6,45,24,43);
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
) ENGINE=InnoDB AUTO_INCREMENT=97 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `units`
--

LOCK TABLES `units` WRITE;
/*!40000 ALTER TABLE `units` DISABLE KEYS */;
INSERT INTO `units` VALUES (1,8000,1,1,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,1,90,NULL,1,0,0,0),(2,8000,1,1,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,1,90,NULL,1,0,0,0),(3,8000,1,1,1,NULL,NULL,NULL,NULL,0,0,'Dirac',0,1,90,NULL,1,0,0,0),(4,3400,1,1,1,NULL,NULL,NULL,NULL,0,0,'Thor',1,3,336,NULL,1,0,0,0),(5,8000,1,1,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,3,336,NULL,1,0,0,0),(6,8000,1,1,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,3,336,NULL,1,0,0,0),(7,8000,1,1,1,NULL,NULL,NULL,NULL,0,0,'Dirac',0,3,336,NULL,1,0,0,0),(8,3400,1,1,1,NULL,NULL,NULL,NULL,0,0,'Thor',1,1,315,NULL,1,0,0,0),(9,8000,1,1,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,1,315,NULL,1,0,0,0),(10,8000,1,1,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,1,315,NULL,1,0,0,0),(11,8000,1,1,1,NULL,NULL,NULL,NULL,0,0,'Dirac',0,1,315,NULL,1,0,0,0),(12,3400,1,2,1,NULL,NULL,NULL,NULL,0,0,'Thor',0,2,120,NULL,1,0,0,0),(13,8000,1,2,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,2,120,NULL,1,0,0,0),(14,8000,1,2,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,2,120,NULL,1,0,0,0),(15,8000,1,2,1,NULL,NULL,NULL,NULL,0,0,'Dirac',0,2,120,NULL,1,0,0,0),(16,3000,1,2,1,NULL,NULL,NULL,NULL,0,0,'Rhyno',0,3,156,NULL,1,0,0,0),(17,3400,1,2,1,NULL,NULL,NULL,NULL,0,0,'Thor',0,3,156,NULL,1,0,0,0),(18,3400,1,2,1,NULL,NULL,NULL,NULL,0,0,'Thor',1,3,156,NULL,1,0,0,0),(19,8000,1,2,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,3,156,NULL,1,0,0,0),(20,8000,1,2,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,3,156,NULL,1,0,0,0),(21,8000,1,2,1,NULL,NULL,NULL,NULL,0,0,'Dirac',0,3,156,NULL,1,0,0,0),(22,200,1,16,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,26,16,NULL,1,0,0,0),(23,100,1,16,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,26,16,NULL,1,0,0,0),(24,200,1,16,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,26,16,NULL,1,0,0,0),(25,100,1,16,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,26,16,NULL,1,0,0,0),(26,200,1,16,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,26,16,NULL,1,0,0,0),(27,100,1,16,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,26,16,NULL,1,0,0,0),(28,100,1,16,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,26,16,NULL,1,0,0,0),(29,100,1,17,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,25,20,NULL,1,0,0,0),(30,200,1,17,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,25,20,NULL,1,0,0,0),(31,100,1,17,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,25,20,NULL,1,0,0,0),(32,100,1,17,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,25,20,NULL,1,0,0,0),(33,200,1,21,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,24,24,NULL,1,0,0,0),(34,100,1,21,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,24,24,NULL,1,0,0,0),(35,100,1,21,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,24,24,NULL,1,0,0,0),(36,200,1,22,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,28,24,NULL,1,0,0,0),(37,100,1,22,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,28,24,NULL,1,0,0,0),(38,100,1,22,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,28,24,NULL,1,0,0,0),(39,100,1,23,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,18,25,NULL,1,0,0,0),(40,100,1,23,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,18,25,NULL,1,0,0,0),(41,100,1,24,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,15,26,NULL,1,0,0,0),(42,100,1,24,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,15,26,NULL,1,0,0,0),(43,200,1,25,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,3,27,NULL,1,0,0,0),(44,100,1,25,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,3,27,NULL,1,0,0,0),(45,100,1,25,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,3,27,NULL,1,0,0,0),(46,100,1,26,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,12,27,NULL,1,0,0,0),(47,100,1,26,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,12,27,NULL,1,0,0,0),(48,100,1,27,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,22,27,NULL,1,0,0,0),(49,100,1,27,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,22,27,NULL,1,0,0,0),(50,200,1,28,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,26,27,NULL,1,0,0,0),(51,100,1,28,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,26,27,NULL,1,0,0,0),(52,100,1,28,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,26,27,NULL,1,0,0,0),(53,200,1,29,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,0,28,NULL,1,0,0,0),(54,100,1,29,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,0,28,NULL,1,0,0,0),(55,100,1,29,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,0,28,NULL,1,0,0,0),(56,200,1,30,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,7,28,NULL,1,0,0,0),(57,100,1,30,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,7,28,NULL,1,0,0,0),(58,100,1,30,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,7,28,NULL,1,0,0,0),(59,100,1,31,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,18,28,NULL,1,0,0,0),(60,100,1,31,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,18,28,NULL,1,0,0,0),(61,3400,1,3,1,NULL,NULL,NULL,NULL,0,0,'Thor',0,5,225,NULL,1,0,0,0),(62,3400,1,3,1,NULL,NULL,NULL,NULL,0,0,'Thor',1,5,225,NULL,1,0,0,0),(63,8000,1,3,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,5,225,NULL,1,0,0,0),(64,8000,1,3,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,5,225,NULL,1,0,0,0),(65,8000,1,3,1,NULL,NULL,NULL,NULL,0,0,'Dirac',0,5,225,NULL,1,0,0,0),(66,3000,1,3,1,NULL,NULL,NULL,NULL,0,0,'Rhyno',0,3,292,NULL,1,0,0,0),(67,3000,1,3,1,NULL,NULL,NULL,NULL,0,0,'Rhyno',0,3,292,NULL,1,0,0,0),(68,3400,1,3,1,NULL,NULL,NULL,NULL,0,0,'Thor',0,3,292,NULL,1,0,0,0),(69,3400,1,3,1,NULL,NULL,NULL,NULL,0,0,'Thor',1,3,292,NULL,1,0,0,0),(70,8000,1,3,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,3,292,NULL,1,0,0,0),(71,8000,1,3,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,3,292,NULL,1,0,0,0),(72,8000,1,3,1,NULL,NULL,NULL,NULL,0,0,'Dirac',0,3,292,NULL,1,0,0,0),(73,3400,1,4,1,NULL,NULL,NULL,NULL,0,0,'Thor',1,4,90,NULL,1,0,0,0),(74,8000,1,4,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,4,90,NULL,1,0,0,0),(75,8000,1,4,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,4,90,NULL,1,0,0,0),(76,8000,1,4,1,NULL,NULL,NULL,NULL,0,0,'Dirac',0,4,90,NULL,1,0,0,0),(77,3000,1,4,1,NULL,NULL,NULL,NULL,0,0,'Rhyno',0,1,90,NULL,1,0,0,0),(78,3000,1,4,1,NULL,NULL,NULL,NULL,0,0,'Rhyno',0,1,90,NULL,1,0,0,0),(79,3400,1,4,1,NULL,NULL,NULL,NULL,0,0,'Thor',1,1,90,NULL,1,0,0,0),(80,8000,1,4,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,1,90,NULL,1,0,0,0),(81,8000,1,4,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,1,90,NULL,1,0,0,0),(82,8000,1,4,1,NULL,NULL,NULL,NULL,0,0,'Dirac',0,1,90,NULL,1,0,0,0),(83,8000,1,4,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,4,216,NULL,1,0,0,0),(84,8000,1,4,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,4,216,NULL,1,0,0,0),(85,8000,1,4,1,NULL,NULL,NULL,NULL,0,0,'Dirac',0,4,216,NULL,1,0,0,0),(86,3000,1,4,1,NULL,NULL,NULL,NULL,0,0,'Rhyno',0,3,44,NULL,1,0,0,0),(87,3000,1,4,1,NULL,NULL,NULL,NULL,0,0,'Rhyno',0,3,44,NULL,1,0,0,0),(88,3400,1,4,1,NULL,NULL,NULL,NULL,0,0,'Thor',0,3,44,NULL,1,0,0,0),(89,8000,1,4,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,3,44,NULL,1,0,0,0),(90,8000,1,4,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,3,44,NULL,1,0,0,0),(91,8000,1,4,1,NULL,NULL,NULL,NULL,0,0,'Dirac',0,3,44,NULL,1,0,0,0),(92,3400,1,4,1,NULL,NULL,NULL,NULL,0,0,'Thor',0,2,270,NULL,1,0,0,0),(93,3400,1,4,1,NULL,NULL,NULL,NULL,0,0,'Thor',1,2,270,NULL,1,0,0,0),(94,8000,1,4,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,2,270,NULL,1,0,0,0),(95,8000,1,4,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,2,270,NULL,1,0,0,0),(96,8000,1,4,1,NULL,NULL,NULL,NULL,0,0,'Dirac',0,2,270,NULL,1,0,0,0);
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

-- Dump completed on 2010-10-26 17:39:26
