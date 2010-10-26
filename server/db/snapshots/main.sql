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
  CONSTRAINT `buildings_ibfk_1` FOREIGN KEY (`planet_id`) REFERENCES `planets` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=39 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `buildings`
--

LOCK TABLES `buildings` WRITE;
/*!40000 ALTER TABLE `buildings` DISABLE KEYS */;
INSERT INTO `buildings` VALUES (1,19,10,24,0,0,0,1,'NpcMetalExtractor',NULL,12,26,NULL,0,400,NULL,0,NULL,NULL,0),(2,19,6,18,0,0,0,1,'NpcMetalExtractor',NULL,8,20,NULL,0,400,NULL,0,NULL,NULL,0),(3,19,2,2,0,0,0,1,'NpcMetalExtractor',NULL,4,4,NULL,0,400,NULL,0,NULL,NULL,0),(4,19,6,6,0,0,0,1,'NpcMetalExtractor',NULL,8,8,NULL,0,400,NULL,0,NULL,NULL,0),(5,19,6,11,0,0,0,1,'NpcMetalExtractor',NULL,8,13,NULL,0,400,NULL,0,NULL,NULL,0),(6,19,1,13,0,0,0,1,'NpcGeothermalPlant',NULL,3,15,NULL,0,600,NULL,0,NULL,NULL,0),(7,19,2,32,0,0,0,1,'NpcZetiumExtractor',NULL,4,34,NULL,0,800,NULL,0,NULL,NULL,0),(8,21,7,9,0,0,0,1,'Vulcan',NULL,9,11,NULL,0,300,NULL,0,NULL,NULL,0),(9,21,14,9,0,0,0,1,'Thunder',NULL,16,11,NULL,0,300,NULL,0,NULL,NULL,0),(10,21,21,9,0,0,0,1,'Screamer',NULL,23,11,NULL,0,300,NULL,0,NULL,NULL,0),(11,21,11,14,0,0,0,1,'Mothership',NULL,19,20,NULL,0,10500,NULL,0,NULL,NULL,0),(12,21,7,16,0,0,0,1,'Thunder',NULL,9,18,NULL,0,300,NULL,0,NULL,NULL,0),(13,21,21,16,0,0,0,1,'Thunder',NULL,23,18,NULL,0,300,NULL,0,NULL,NULL,0),(14,21,26,16,0,0,0,1,'NpcZetiumExtractor',NULL,28,18,NULL,0,800,NULL,0,NULL,NULL,0),(15,21,25,20,0,0,0,1,'NpcTemple',NULL,28,23,NULL,0,1500,NULL,0,NULL,NULL,0),(16,21,7,22,0,0,0,1,'Screamer',NULL,9,24,NULL,0,300,NULL,0,NULL,NULL,0),(17,21,14,22,0,0,0,1,'Thunder',NULL,16,24,NULL,0,300,NULL,0,NULL,NULL,0),(18,21,21,22,0,0,0,1,'Vulcan',NULL,23,24,NULL,0,300,NULL,0,NULL,NULL,0),(19,21,24,24,0,0,0,1,'NpcMetalExtractor',NULL,26,26,NULL,0,400,NULL,0,NULL,NULL,0),(20,21,28,24,0,0,0,1,'NpcMetalExtractor',NULL,30,26,NULL,0,400,NULL,0,NULL,NULL,0),(21,21,18,25,0,0,0,1,'NpcSolarPlant',NULL,20,27,NULL,0,1000,NULL,0,NULL,NULL,0),(22,21,15,26,0,0,0,1,'NpcSolarPlant',NULL,17,28,NULL,0,1000,NULL,0,NULL,NULL,0),(23,21,3,27,0,0,0,1,'NpcMetalExtractor',NULL,5,29,NULL,0,400,NULL,0,NULL,NULL,0),(24,21,12,27,0,0,0,1,'NpcSolarPlant',NULL,14,29,NULL,0,1000,NULL,0,NULL,NULL,0),(25,21,22,27,0,0,0,1,'NpcSolarPlant',NULL,24,29,NULL,0,1000,NULL,0,NULL,NULL,0),(26,21,26,27,0,0,0,1,'NpcCommunicationsHub',NULL,29,29,NULL,0,1200,NULL,0,NULL,NULL,0),(27,21,0,28,0,0,0,1,'NpcMetalExtractor',NULL,2,30,NULL,0,400,NULL,0,NULL,NULL,0),(28,21,7,28,0,0,0,1,'NpcCommunicationsHub',NULL,10,30,NULL,0,1200,NULL,0,NULL,NULL,0),(29,21,18,28,0,0,0,1,'NpcSolarPlant',NULL,20,30,NULL,0,1000,NULL,0,NULL,NULL,0),(30,30,3,22,0,0,0,1,'NpcMetalExtractor',NULL,5,24,NULL,0,400,NULL,0,NULL,NULL,0),(31,30,6,26,0,0,0,1,'NpcMetalExtractor',NULL,8,28,NULL,0,400,NULL,0,NULL,NULL,0),(32,30,18,26,0,0,0,1,'NpcMetalExtractor',NULL,20,28,NULL,0,400,NULL,0,NULL,NULL,0),(33,30,22,26,0,0,0,1,'NpcMetalExtractor',NULL,24,28,NULL,0,400,NULL,0,NULL,NULL,0),(34,47,19,13,0,0,0,1,'NpcMetalExtractor',NULL,21,15,NULL,0,400,NULL,0,NULL,NULL,0),(35,47,1,9,0,0,0,1,'NpcMetalExtractor',NULL,3,11,NULL,0,400,NULL,0,NULL,NULL,0),(36,47,5,2,0,0,0,1,'NpcMetalExtractor',NULL,7,4,NULL,0,400,NULL,0,NULL,NULL,0),(37,47,1,1,0,0,0,1,'NpcMetalExtractor',NULL,3,3,NULL,0,400,NULL,0,NULL,NULL,0),(38,47,1,5,0,0,0,1,'NpcMetalExtractor',NULL,3,7,NULL,0,400,NULL,0,NULL,NULL,0);
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
  CONSTRAINT `folliages_ibfk_1` FOREIGN KEY (`planet_id`) REFERENCES `planets` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `folliages`
--

LOCK TABLES `folliages` WRITE;
/*!40000 ALTER TABLE `folliages` DISABLE KEYS */;
INSERT INTO `folliages` VALUES (19,0,2,10),(19,0,9,13),(19,0,10,7),(19,0,22,1),(19,1,4,7),(19,1,22,6),(19,2,1,1),(19,2,2,12),(19,2,19,10),(19,3,1,3),(19,3,5,3),(19,3,8,1),(19,3,9,3),(19,3,15,11),(19,4,0,2),(19,5,4,5),(19,5,22,4),(19,5,23,5),(19,6,4,9),(19,6,5,3),(19,7,26,6),(19,8,5,4),(19,8,25,4),(19,9,3,2),(19,9,4,12),(19,9,6,1),(19,9,8,3),(19,9,10,8),(19,9,11,13),(19,9,12,1),(19,9,27,9),(19,9,31,6),(19,10,1,2),(19,10,28,13),(19,10,33,1),(19,10,34,2),(19,11,2,0),(19,11,3,0),(19,11,8,6),(19,11,20,9),(19,11,27,3),(19,11,36,12),(19,12,10,2),(19,12,11,3),(19,12,16,1),(19,12,24,5),(19,12,28,5),(19,12,33,7),(19,12,35,3),(19,13,35,7),(19,14,5,3),(19,14,17,0),(19,14,33,6),(19,14,34,11),(19,14,35,4),(19,15,0,1),(19,15,4,9),(19,15,6,8),(19,15,24,9),(19,15,33,0),(19,16,0,8),(19,16,3,12),(19,16,13,11),(19,16,17,1),(19,16,30,9),(19,16,31,10),(19,16,33,0),(19,17,1,0),(19,17,4,8),(19,17,10,10),(19,17,19,8),(19,17,23,7),(19,17,29,12),(19,17,35,4),(19,18,8,5),(19,18,10,11),(19,18,28,5),(19,18,29,8),(19,18,30,5),(19,18,36,3),(19,19,24,8),(19,19,34,1),(19,19,35,8),(19,20,1,11),(19,20,6,4),(19,20,23,7),(19,21,34,4),(19,22,2,4),(19,22,12,7),(19,23,0,7),(19,23,1,1),(19,23,8,9),(19,23,23,6),(19,23,29,0),(19,24,7,11),(19,24,33,1),(19,24,36,8),(19,25,3,5),(19,25,4,10),(19,25,7,7),(19,25,25,10),(19,25,28,11),(19,26,1,1),(19,26,7,7),(19,26,9,1),(19,26,26,9),(19,27,4,4),(19,27,9,2),(19,27,27,11),(19,27,30,4),(19,27,35,7),(19,28,5,9),(19,28,6,8),(19,28,7,2),(19,28,8,4),(19,28,10,10),(19,28,18,4),(19,28,29,12),(19,28,34,13),(19,28,35,0),(19,29,6,1),(19,29,13,2),(19,29,16,2),(19,29,23,5),(19,29,32,10),(19,29,33,7),(19,30,9,3),(19,30,13,1),(19,30,19,8),(19,30,20,12),(19,30,26,3),(19,30,28,3),(19,31,4,5),(19,31,19,9),(19,32,21,13),(19,32,28,2),(19,33,1,2),(19,33,13,12),(19,33,16,12),(19,33,21,2),(19,33,27,12),(19,34,2,2),(19,34,4,1),(19,34,6,9),(19,34,16,0),(19,34,17,6),(19,35,2,5),(19,35,4,1),(19,35,19,9),(19,35,22,4),(19,36,1,13),(19,36,4,9),(19,36,17,4),(19,37,17,7),(19,38,0,12),(19,38,20,4),(19,39,21,4),(19,40,17,3),(19,40,18,2),(19,40,19,2),(19,40,20,8),(19,40,27,7),(21,0,27,9),(21,1,19,9),(21,1,27,9),(21,2,4,0),(21,2,5,10),(21,2,28,5),(21,3,2,11),(21,3,4,1),(21,3,14,11),(21,4,9,2),(21,5,4,2),(21,5,9,13),(21,5,17,11),(21,5,23,3),(21,5,27,8),(21,5,29,3),(21,6,7,0),(21,6,9,12),(21,6,15,3),(21,6,23,4),(21,6,25,2),(21,6,26,7),(21,6,28,6),(21,6,29,0),(21,7,0,3),(21,7,10,10),(21,7,13,1),(21,7,14,9),(21,7,16,0),(21,7,18,4),(21,7,24,0),(21,7,27,11),(21,7,28,5),(21,8,7,4),(21,8,10,6),(21,8,17,12),(21,8,18,9),(21,8,23,13),(21,8,25,4),(21,8,26,0),(21,8,29,4),(21,9,9,4),(21,9,17,5),(21,9,23,5),(21,9,29,7),(21,10,0,0),(21,10,7,3),(21,10,17,4),(21,11,0,1),(21,11,10,0),(21,11,13,3),(21,11,20,8),(21,12,18,7),(21,13,2,13),(21,13,4,9),(21,13,6,6),(21,13,8,6),(21,13,11,11),(21,13,13,13),(21,13,15,1),(21,13,17,2),(21,13,26,7),(21,14,0,5),(21,14,2,6),(21,14,4,1),(21,14,8,6),(21,14,9,4),(21,14,18,12),(21,15,2,0),(21,15,6,8),(21,15,20,0),(21,16,2,10),(21,16,8,2),(21,16,11,0),(21,16,13,1),(21,16,17,1),(21,16,20,10),(21,16,21,4),(21,16,23,1),(21,16,24,11),(21,17,3,2),(21,17,5,5),(21,17,6,2),(21,17,10,9),(21,17,14,4),(21,17,24,8),(21,18,5,7),(21,18,10,4),(21,18,13,1),(21,18,16,13),(21,18,17,1),(21,18,20,1),(21,18,22,9),(21,19,1,7),(21,19,9,9),(21,19,13,8),(21,19,16,7),(21,19,17,5),(21,19,18,2),(21,19,20,6),(21,20,9,2),(21,20,10,0),(21,20,11,9),(21,20,13,10),(21,20,18,4),(21,20,21,2),(21,21,6,3),(21,21,10,2),(21,21,11,13),(21,21,16,0),(21,21,21,6),(21,21,23,4),(21,22,14,0),(21,22,18,2),(21,22,19,7),(21,22,22,8),(21,23,11,8),(21,23,12,2),(21,23,14,8),(21,23,15,12),(21,23,17,3),(21,23,24,11),(21,24,6,0),(21,24,8,10),(21,24,15,2),(21,25,11,3),(21,25,12,0),(21,25,14,1),(21,25,15,10),(21,25,18,5),(21,25,28,9),(21,26,10,6),(21,26,24,10),(21,26,26,11),(21,26,29,3),(21,27,2,13),(21,27,13,10),(21,27,29,3),(21,29,14,6),(21,29,26,8),(21,29,28,10),(30,0,0,10),(30,0,4,3),(30,0,5,12),(30,0,8,8),(30,0,14,3),(30,0,17,5),(30,0,20,2),(30,1,6,7),(30,1,9,10),(30,1,12,8),(30,1,13,0),(30,1,15,13),(30,1,19,8),(30,2,2,1),(30,2,3,7),(30,2,7,13),(30,2,14,13),(30,2,15,10),(30,3,3,3),(30,3,5,10),(30,3,11,4),(30,3,19,10),(30,4,2,5),(30,4,3,13),(30,4,12,10),(30,4,15,4),(30,4,16,5),(30,4,18,6),(30,4,21,2),(30,5,13,12),(30,5,15,2),(30,5,16,2),(30,5,19,0),(30,6,3,6),(30,6,4,12),(30,6,5,12),(30,6,26,6),(30,7,25,12),(30,8,5,12),(30,8,26,6),(30,9,1,13),(30,9,26,3),(30,10,27,4),(30,11,14,0),(30,12,2,3),(30,12,6,7),(30,12,14,5),(30,13,28,13),(30,14,2,10),(30,14,26,6),(30,15,3,0),(30,15,14,1),(30,15,26,2),(30,15,28,8),(30,16,2,11),(30,16,27,10),(30,17,4,10),(30,17,15,6),(30,17,17,5),(30,18,0,11),(30,18,16,6),(30,18,17,11),(30,19,10,5),(30,19,12,3),(30,19,15,3),(30,20,6,3),(30,20,23,10),(30,21,10,0),(30,21,13,13),(30,22,4,5),(30,22,7,13),(30,22,10,4),(30,23,6,4),(30,23,11,8),(30,23,28,4),(30,24,2,2),(30,24,22,10),(30,24,23,10),(30,25,8,3),(30,25,10,7),(30,25,12,7),(30,25,23,9),(30,25,25,4),(30,25,26,4),(30,25,27,3),(47,0,4,13),(47,0,7,6),(47,0,13,9),(47,0,27,10),(47,0,30,5),(47,1,22,5),(47,1,27,6),(47,1,33,0),(47,2,14,10),(47,2,17,4),(47,2,22,12),(47,2,23,11),(47,3,1,8),(47,3,15,1),(47,4,2,7),(47,4,4,8),(47,4,5,11),(47,4,18,3),(47,4,20,13),(47,4,27,7),(47,4,30,0),(47,5,1,1),(47,5,2,8),(47,5,4,1),(47,5,15,9),(47,5,37,6),(47,6,15,4),(47,6,33,2),(47,7,2,2),(47,7,5,7),(47,7,12,4),(47,7,17,6),(47,7,22,9),(47,7,27,1),(47,7,34,11),(47,8,13,2),(47,8,25,4),(47,9,2,3),(47,9,8,6),(47,9,14,9),(47,9,20,1),(47,9,21,7),(47,9,23,9),(47,9,24,8),(47,10,4,7),(47,10,5,11),(47,10,11,1),(47,10,14,10),(47,10,21,8),(47,11,3,8),(47,11,8,4),(47,11,9,6),(47,11,10,9),(47,11,26,8),(47,11,33,9),(47,12,7,8),(47,12,17,11),(47,13,5,6),(47,13,7,5),(47,13,15,12),(47,13,18,1),(47,13,20,11),(47,13,24,11),(47,13,25,2),(47,13,35,5),(47,14,15,6),(47,14,17,0),(47,16,11,7),(47,16,13,11),(47,16,14,0),(47,17,7,3),(47,17,13,2),(47,17,14,3),(47,17,15,5),(47,17,19,0),(47,17,37,4),(47,18,8,8),(47,18,18,5),(47,18,19,6),(47,18,25,12),(47,19,18,5),(47,19,26,1),(47,19,29,6),(47,19,33,2),(47,19,34,0),(47,20,2,4),(47,20,18,5),(47,20,26,1),(47,20,30,2),(47,21,1,4),(47,21,2,1),(47,21,18,7),(47,21,30,7),(47,21,33,9);
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
INSERT INTO `galaxies` VALUES (1,'2010-10-26 11:43:28','dev');
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
-- Table structure for table `planets`
--

DROP TABLE IF EXISTS `planets`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `planets` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `solar_system_id` int(11) NOT NULL,
  `width` int(11) DEFAULT NULL,
  `height` int(11) DEFAULT NULL,
  `position` int(11) NOT NULL DEFAULT '0',
  `angle` int(11) NOT NULL DEFAULT '0',
  `variation` int(11) NOT NULL DEFAULT '0',
  `type` varchar(255) NOT NULL,
  `player_id` int(11) DEFAULT NULL,
  `name` varchar(255) NOT NULL DEFAULT '',
  `size` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uniqueness` (`solar_system_id`,`position`,`angle`),
  KEY `index_planets_on_galaxy_id_and_solar_system_id` (`solar_system_id`),
  KEY `index_planets_on_player_id_and_galaxy_id` (`player_id`),
  KEY `group_by_for_fowssentry_status_updates` (`player_id`,`solar_system_id`),
  CONSTRAINT `planets_ibfk_1` FOREIGN KEY (`solar_system_id`) REFERENCES `solar_systems` (`id`) ON DELETE CASCADE,
  CONSTRAINT `planets_ibfk_2` FOREIGN KEY (`player_id`) REFERENCES `players` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=49 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `planets`
--

LOCK TABLES `planets` WRITE;
/*!40000 ALTER TABLE `planets` DISABLE KEYS */;
INSERT INTO `planets` VALUES (1,1,0,0,5,225,0,'Jumpgate',NULL,'JG-1',53),(2,1,0,0,5,300,0,'Jumpgate',NULL,'JG-2',31),(3,1,0,0,3,246,0,'Asteroid',NULL,'A-3',46),(4,1,0,0,2,210,0,'RichAsteroid',NULL,'RA-4',32),(5,1,0,0,1,315,0,'RichAsteroid',NULL,'RA-5',46),(6,1,0,0,3,156,0,'RichAsteroid',NULL,'RA-6',31),(7,1,0,0,4,342,0,'Asteroid',NULL,'A-7',48),(8,1,0,0,5,315,0,'Jumpgate',NULL,'JG-8',58),(9,1,0,0,4,198,0,'Asteroid',NULL,'A-9',41),(10,1,0,0,5,330,0,'Jumpgate',NULL,'JG-10',41),(11,1,0,0,3,44,0,'RichAsteroid',NULL,'RA-11',60),(12,1,0,0,4,36,0,'RichAsteroid',NULL,'RA-12',41),(13,1,0,0,0,270,0,'RichAsteroid',NULL,'RA-13',41),(14,1,0,0,2,270,0,'Asteroid',NULL,'A-14',55),(15,1,0,0,2,300,0,'RichAsteroid',NULL,'RA-15',27),(16,2,0,0,1,45,0,'Asteroid',NULL,'A-16',49),(17,2,0,0,5,270,0,'HomeJumpgate',NULL,'JG-17',29),(18,2,0,0,4,198,0,'Asteroid',NULL,'A-18',39),(19,2,41,37,3,180,0,'Planet',NULL,'P-19',57),(20,2,0,0,3,0,0,'Asteroid',NULL,'A-20',40),(21,2,40,34,4,126,0,'Homeworld',1,'P-21',56),(22,2,0,0,3,270,0,'Asteroid',NULL,'A-22',31),(23,2,0,0,3,134,0,'Asteroid',NULL,'A-23',33),(24,3,0,0,1,45,0,'RichAsteroid',NULL,'RA-24',53),(25,3,0,0,2,90,0,'RichAsteroid',NULL,'RA-25',50),(26,3,0,0,5,225,0,'Jumpgate',NULL,'JG-26',35),(27,3,0,0,4,270,0,'Asteroid',NULL,'A-27',55),(28,3,0,0,4,18,0,'RichAsteroid',NULL,'RA-28',48),(29,3,0,0,4,288,0,'RichAsteroid',NULL,'RA-29',27),(30,3,26,29,3,202,2,'Planet',NULL,'P-30',48),(31,3,0,0,3,134,0,'RichAsteroid',NULL,'RA-31',52),(32,3,0,0,4,342,0,'RichAsteroid',NULL,'RA-32',45),(33,3,0,0,5,240,0,'Jumpgate',NULL,'JG-33',33),(34,3,0,0,2,150,0,'RichAsteroid',NULL,'RA-34',43),(35,3,0,0,0,270,0,'Asteroid',NULL,'A-35',46),(36,3,0,0,0,180,0,'Asteroid',NULL,'A-36',59),(37,3,0,0,2,300,0,'RichAsteroid',NULL,'RA-37',25),(38,4,0,0,1,225,0,'Asteroid',NULL,'A-38',49),(39,4,0,0,2,150,0,'RichAsteroid',NULL,'RA-39',48),(40,4,0,0,5,90,0,'Jumpgate',NULL,'JG-40',58),(41,4,0,0,4,270,0,'Asteroid',NULL,'A-41',45),(42,4,0,0,5,195,0,'Jumpgate',NULL,'JG-42',47),(43,4,0,0,1,180,0,'Asteroid',NULL,'A-43',30),(44,4,0,0,1,0,0,'Asteroid',NULL,'A-44',38),(45,4,0,0,4,54,0,'Asteroid',NULL,'A-45',39),(46,4,0,0,4,108,0,'Asteroid',NULL,'A-46',30),(47,4,22,38,3,224,1,'Planet',NULL,'P-47',50),(48,4,0,0,2,300,0,'RichAsteroid',NULL,'RA-48',31);
/*!40000 ALTER TABLE `planets` ENABLE KEYS */;
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
-- Table structure for table `resources_entries`
--

DROP TABLE IF EXISTS `resources_entries`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `resources_entries` (
  `planet_id` int(11) NOT NULL AUTO_INCREMENT,
  `metal` float NOT NULL DEFAULT '0',
  `metal_storage` float NOT NULL DEFAULT '0',
  `energy` float NOT NULL DEFAULT '0',
  `energy_storage` float NOT NULL DEFAULT '0',
  `zetium` float NOT NULL DEFAULT '0',
  `zetium_storage` float NOT NULL DEFAULT '0',
  `metal_rate` float NOT NULL DEFAULT '0',
  `energy_rate` float NOT NULL DEFAULT '0',
  `zetium_rate` float NOT NULL DEFAULT '0',
  `last_update` datetime DEFAULT NULL,
  `energy_diminish_registered` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`planet_id`),
  KEY `index_resources_entries_on_last_update` (`last_update`),
  CONSTRAINT `resources_entries_ibfk_1` FOREIGN KEY (`planet_id`) REFERENCES `planets` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=49 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `resources_entries`
--

LOCK TABLES `resources_entries` WRITE;
/*!40000 ALTER TABLE `resources_entries` DISABLE KEYS */;
INSERT INTO `resources_entries` VALUES (3,0,0,0,0,0,0,0,0,0,NULL,0),(4,0,3,0,3,0,1,0,0,0,NULL,0),(5,0,2,0,1,0,1,0,0,0,NULL,0),(6,0,2,0,1,0,3,0,0,0,NULL,0),(7,0,0,0,0,0,0,0,0,0,NULL,0),(9,0,0,0,1,0,1,0,0,0,NULL,0),(11,0,1,0,2,0,2,0,0,0,NULL,0),(12,0,1,0,1,0,2,0,0,0,NULL,0),(13,0,2,0,3,0,3,0,0,0,NULL,0),(14,0,0,0,0,0,1,0,0,0,NULL,0),(15,0,1,0,3,0,2,0,0,0,NULL,0),(16,0,0,0,1,0,0,0,0,0,NULL,0),(18,0,0,0,0,0,1,0,0,0,NULL,0),(19,0,0,0,0,0,0,0,0,0,NULL,0),(20,0,1,0,1,0,1,0,0,0,NULL,0),(21,0,0,0,0,0,0,0,0,0,NULL,0),(22,0,0,0,0,0,0,0,0,0,NULL,0),(23,0,0,0,0,0,1,0,0,0,NULL,0),(24,0,1,0,3,0,3,0,0,0,NULL,0),(25,0,3,0,1,0,3,0,0,0,NULL,0),(27,0,0,0,1,0,0,0,0,0,NULL,0),(28,0,1,0,3,0,1,0,0,0,NULL,0),(29,0,1,0,1,0,3,0,0,0,NULL,0),(30,0,0,0,0,0,0,0,0,0,NULL,0),(31,0,1,0,2,0,1,0,0,0,NULL,0),(32,0,1,0,2,0,1,0,0,0,NULL,0),(34,0,1,0,2,0,2,0,0,0,NULL,0),(35,0,1,0,0,0,1,0,0,0,NULL,0),(36,0,1,0,0,0,0,0,0,0,NULL,0),(37,0,1,0,3,0,2,0,0,0,NULL,0),(38,0,0,0,0,0,1,0,0,0,NULL,0),(39,0,3,0,2,0,1,0,0,0,NULL,0),(41,0,1,0,0,0,0,0,0,0,NULL,0),(43,0,0,0,0,0,0,0,0,0,NULL,0),(44,0,0,0,0,0,1,0,0,0,NULL,0),(45,0,1,0,1,0,1,0,0,0,NULL,0),(46,0,0,0,1,0,1,0,0,0,NULL,0),(47,0,0,0,0,0,0,0,0,0,NULL,0),(48,0,3,0,2,0,1,0,0,0,NULL,0);
/*!40000 ALTER TABLE `resources_entries` ENABLE KEYS */;
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
INSERT INTO `solar_systems` VALUES (1,'Resource',1,2,1),(2,'Homeworld',1,2,2),(3,'Expansion',1,1,1),(4,'Expansion',1,0,0);
/*!40000 ALTER TABLE `solar_systems` ENABLE KEYS */;
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
  CONSTRAINT `tiles_ibfk_1` FOREIGN KEY (`planet_id`) REFERENCES `planets` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tiles`
--

LOCK TABLES `tiles` WRITE;
/*!40000 ALTER TABLE `tiles` DISABLE KEYS */;
INSERT INTO `tiles` VALUES (4,19,0,18),(5,19,0,23),(5,19,0,25),(5,19,0,26),(5,19,0,27),(5,19,0,28),(5,19,0,29),(5,19,0,30),(5,19,0,31),(5,19,0,32),(5,19,0,34),(5,19,0,35),(5,19,1,9),(5,19,1,11),(5,19,1,12),(1,19,1,13),(4,19,1,16),(4,19,1,17),(4,19,1,18),(1,19,1,20),(5,19,1,23),(5,19,1,25),(5,19,1,26),(5,19,1,27),(5,19,1,28),(5,19,1,29),(5,19,1,30),(5,19,1,32),(5,19,1,33),(5,19,1,34),(5,19,1,35),(5,19,2,9),(5,19,2,10),(5,19,2,11),(5,19,2,12),(4,19,2,16),(4,19,2,18),(5,19,2,22),(5,19,2,23),(5,19,2,24),(5,19,2,25),(5,19,2,26),(5,19,2,27),(5,19,2,28),(5,19,2,29),(2,19,2,32),(5,19,2,34),(5,19,3,7),(5,19,3,10),(5,19,3,11),(5,19,3,12),(5,19,3,13),(5,19,3,14),(4,19,3,16),(4,19,3,18),(4,19,3,20),(4,19,3,21),(4,19,3,22),(4,19,3,23),(4,19,3,24),(4,19,3,25),(4,19,3,26),(5,19,3,27),(5,19,3,28),(5,19,3,29),(5,19,3,30),(5,19,3,34),(5,19,4,7),(5,19,4,8),(5,19,4,9),(5,19,4,10),(5,19,4,11),(5,19,4,12),(5,19,4,13),(5,19,4,14),(5,19,4,15),(4,19,4,16),(4,19,4,17),(4,19,4,18),(4,19,4,19),(4,19,4,20),(4,19,4,21),(4,19,4,22),(4,19,4,23),(4,19,4,24),(4,19,4,25),(4,19,4,26),(5,19,4,28),(5,19,4,30),(5,19,4,34),(5,19,5,7),(5,19,5,8),(5,19,5,9),(5,19,5,10),(5,19,5,11),(5,19,5,12),(5,19,5,13),(4,19,5,14),(5,19,5,15),(4,19,5,16),(4,19,5,17),(4,19,5,18),(4,19,5,19),(4,19,5,20),(4,19,5,21),(4,19,5,24),(4,19,5,25),(4,19,5,26),(11,19,5,27),(5,19,6,8),(5,19,6,9),(5,19,6,10),(5,19,6,11),(5,19,6,13),(4,19,6,14),(5,19,6,15),(4,19,6,16),(4,19,6,17),(4,19,6,20),(4,19,6,21),(4,19,6,22),(4,19,6,23),(4,19,6,24),(4,19,6,25),(4,19,6,26),(5,19,7,8),(5,19,7,10),(4,19,7,13),(4,19,7,14),(4,19,7,15),(4,19,7,16),(4,19,7,20),(4,19,7,21),(4,19,7,22),(4,19,7,23),(4,19,7,24),(4,19,7,25),(5,19,8,10),(4,19,8,13),(4,19,8,14),(4,19,8,15),(4,19,8,16),(4,19,8,17),(4,19,8,18),(4,19,8,19),(4,19,8,20),(4,19,8,22),(4,19,8,23),(4,19,9,14),(4,19,9,15),(4,19,9,16),(4,19,9,17),(4,19,9,18),(4,19,9,19),(4,19,9,20),(4,19,9,21),(4,19,9,22),(4,19,9,23),(4,19,9,24),(4,19,10,13),(4,19,10,14),(4,19,10,15),(4,19,10,16),(4,19,10,17),(4,19,10,18),(4,19,10,19),(4,19,10,23),(4,19,11,13),(4,19,11,14),(4,19,11,15),(4,19,11,16),(4,19,11,17),(4,19,11,18),(4,19,11,19),(4,19,12,13),(4,19,12,14),(4,19,12,15),(4,19,12,17),(4,19,12,18),(4,19,12,19),(4,19,12,20),(4,19,13,12),(4,19,13,13),(4,19,13,14),(4,19,13,15),(4,19,13,16),(4,19,13,18),(4,19,13,19),(4,19,13,20),(4,19,13,21),(4,19,13,22),(6,19,13,27),(4,19,14,13),(4,19,14,16),(4,19,14,18),(4,19,14,20),(6,19,14,27),(6,19,14,28),(5,19,15,5),(5,19,15,11),(5,19,15,12),(4,19,15,15),(4,19,15,16),(4,19,15,17),(6,19,15,25),(6,19,15,26),(6,19,15,27),(6,19,15,28),(6,19,15,29),(5,19,16,5),(5,19,16,7),(5,19,16,8),(5,19,16,9),(5,19,16,10),(5,19,16,11),(5,19,16,12),(6,19,16,15),(6,19,16,16),(6,19,16,18),(6,19,16,25),(6,19,16,26),(6,19,16,27),(5,19,17,3),(5,19,17,5),(5,19,17,6),(5,19,17,7),(5,19,17,8),(5,19,17,11),(5,19,17,12),(5,19,17,13),(6,19,17,14),(6,19,17,15),(6,19,17,16),(6,19,17,17),(6,19,17,18),(6,19,17,25),(6,19,17,26),(4,19,17,27),(5,19,18,3),(5,19,18,4),(5,19,18,5),(5,19,18,6),(5,19,18,11),(5,19,18,13),(6,19,18,14),(6,19,18,15),(5,19,18,17),(6,19,18,18),(6,19,18,19),(6,19,18,20),(4,19,18,24),(4,19,18,25),(4,19,18,26),(4,19,18,27),(4,19,18,31),(4,19,18,32),(5,19,19,4),(5,19,19,5),(5,19,19,6),(5,19,19,7),(5,19,19,8),(5,19,19,11),(5,19,19,12),(5,19,19,13),(5,19,19,14),(6,19,19,15),(6,19,19,16),(5,19,19,17),(6,19,19,18),(6,19,19,19),(6,19,19,20),(4,19,19,25),(4,19,19,26),(4,19,19,27),(4,19,19,28),(4,19,19,29),(4,19,19,30),(4,19,19,31),(4,19,19,32),(4,19,19,33),(5,19,20,5),(5,19,20,7),(5,19,20,8),(5,19,20,9),(5,19,20,10),(5,19,20,11),(5,19,20,12),(5,19,20,13),(5,19,20,14),(6,19,20,15),(5,19,20,16),(5,19,20,17),(6,19,20,18),(6,19,20,19),(6,19,20,20),(6,19,20,21),(4,19,20,25),(4,19,20,26),(4,19,20,27),(4,19,20,28),(4,19,20,29),(4,19,20,30),(4,19,20,32),(4,19,20,33),(4,19,20,34),(4,19,20,35),(5,19,21,2),(5,19,21,3),(5,19,21,4),(5,19,21,5),(5,19,21,6),(5,19,21,7),(5,19,21,8),(5,19,21,9),(5,19,21,10),(5,19,21,11),(5,19,21,12),(5,19,21,13),(5,19,21,14),(5,19,21,15),(5,19,21,16),(5,19,21,17),(6,19,21,18),(6,19,21,19),(6,19,21,20),(4,19,21,23),(4,19,21,24),(4,19,21,25),(4,19,21,26),(4,19,21,27),(4,19,21,28),(4,19,21,29),(4,19,21,30),(4,19,21,31),(4,19,21,32),(5,19,22,3),(5,19,22,4),(5,19,22,5),(5,19,22,6),(5,19,22,7),(5,19,22,9),(5,19,22,10),(5,19,22,11),(5,19,22,13),(5,19,22,14),(5,19,22,15),(5,19,22,16),(3,19,22,17),(3,19,22,18),(3,19,22,19),(3,19,22,20),(3,19,22,21),(3,19,22,22),(4,19,22,24),(4,19,22,27),(4,19,22,28),(4,19,22,29),(4,19,22,30),(4,19,22,32),(4,19,22,33),(4,19,22,34),(5,19,23,4),(5,19,23,5),(12,19,23,11),(3,19,23,17),(3,19,23,18),(3,19,23,19),(3,19,23,20),(4,19,23,24),(4,19,23,27),(4,19,23,28),(4,19,23,30),(4,19,23,31),(4,19,23,32),(4,19,23,33),(5,19,24,4),(5,19,24,5),(3,19,24,17),(3,19,24,18),(3,19,24,19),(3,19,24,20),(4,19,24,27),(4,19,24,30),(4,19,24,31),(3,19,25,17),(3,19,25,18),(3,19,25,19),(3,19,25,20),(3,19,25,21),(4,19,25,31),(4,19,25,32),(4,19,25,33),(3,19,26,17),(3,19,26,18),(3,19,26,19),(3,19,26,20),(4,19,26,33),(3,19,27,17),(3,19,27,18),(3,19,27,19),(3,19,27,20),(3,19,27,21),(3,19,28,17),(3,19,28,20),(13,19,29,14),(3,19,29,18),(3,19,29,19),(3,19,29,20),(3,19,29,21),(3,19,29,22),(10,19,30,5),(6,19,30,17),(3,19,30,24),(3,19,30,33),(3,19,30,35),(3,19,30,36),(10,19,31,9),(6,19,31,17),(6,19,31,20),(3,19,31,24),(3,19,31,29),(3,19,31,30),(3,19,31,31),(3,19,31,32),(3,19,31,33),(3,19,31,34),(3,19,31,35),(3,19,31,36),(6,19,32,17),(6,19,32,18),(6,19,32,19),(6,19,32,20),(3,19,32,23),(3,19,32,24),(3,19,32,32),(3,19,32,33),(3,19,32,34),(3,19,32,35),(3,19,32,36),(6,19,33,18),(6,19,33,20),(3,19,33,24),(5,19,33,29),(3,19,33,32),(3,19,33,33),(3,19,33,34),(3,19,33,35),(3,19,33,36),(6,19,34,18),(6,19,34,19),(6,19,34,20),(3,19,34,21),(3,19,34,24),(3,19,34,25),(5,19,34,29),(3,19,34,32),(3,19,34,33),(3,19,34,34),(3,19,34,35),(3,19,34,36),(14,19,35,5),(13,19,35,9),(12,19,35,11),(6,19,35,20),(3,19,35,21),(3,19,35,23),(3,19,35,24),(3,19,35,25),(3,19,35,26),(5,19,35,28),(5,19,35,29),(5,19,35,30),(3,19,35,32),(3,19,35,33),(3,19,35,34),(3,19,35,35),(3,19,35,36),(3,19,36,20),(3,19,36,21),(3,19,36,22),(3,19,36,23),(3,19,36,25),(3,19,36,26),(5,19,36,28),(5,19,36,29),(5,19,36,30),(5,19,36,31),(3,19,36,32),(3,19,36,33),(5,19,36,34),(3,19,36,35),(5,19,36,36),(3,19,37,22),(3,19,37,23),(3,19,37,24),(3,19,37,25),(5,19,37,28),(5,19,37,29),(5,19,37,32),(5,19,37,33),(5,19,37,34),(3,19,37,35),(5,19,37,36),(8,19,38,1),(14,19,38,5),(3,19,38,21),(3,19,38,22),(3,19,38,23),(3,19,38,24),(5,19,38,27),(5,19,38,28),(5,19,38,29),(5,19,38,30),(5,19,38,32),(5,19,38,34),(5,19,38,35),(5,19,38,36),(3,19,39,22),(3,19,39,23),(3,19,39,24),(3,19,39,25),(5,19,39,29),(5,19,39,30),(5,19,39,31),(5,19,39,32),(5,19,39,33),(5,19,39,34),(5,19,39,35),(5,19,39,36),(3,19,40,21),(3,19,40,22),(3,19,40,23),(3,19,40,25),(5,19,40,29),(5,19,40,30),(5,19,40,31),(5,19,40,32),(5,19,40,34),(5,19,40,35),(5,21,0,0),(5,21,0,1),(5,21,0,2),(5,21,0,3),(5,21,0,15),(5,21,0,16),(5,21,0,17),(5,21,0,18),(5,21,0,19),(5,21,0,20),(5,21,0,21),(5,21,0,22),(5,21,0,23),(5,21,0,24),(5,21,0,25),(5,21,0,26),(5,21,1,0),(5,21,1,1),(5,21,1,2),(5,21,1,3),(4,21,1,7),(4,21,1,8),(4,21,1,9),(4,21,1,10),(13,21,1,12),(5,21,1,16),(5,21,1,17),(5,21,1,18),(11,21,1,20),(5,21,1,26),(5,21,2,0),(5,21,2,1),(5,21,2,2),(4,21,2,6),(4,21,2,7),(4,21,2,8),(4,21,2,9),(5,21,2,14),(5,21,2,15),(5,21,2,16),(5,21,2,17),(5,21,2,19),(5,21,2,26),(5,21,2,27),(5,21,3,0),(5,21,3,1),(4,21,3,5),(4,21,3,6),(4,21,3,7),(4,21,3,8),(4,21,3,9),(5,21,3,15),(5,21,3,16),(5,21,3,17),(5,21,3,18),(5,21,3,19),(5,21,4,1),(5,21,4,2),(5,21,4,3),(4,21,4,6),(4,21,4,7),(4,21,4,8),(6,21,4,11),(5,21,4,16),(5,21,4,17),(5,21,5,2),(5,21,5,3),(4,21,5,5),(4,21,5,6),(4,21,5,7),(6,21,5,10),(6,21,5,11),(6,21,5,20),(6,21,5,21),(6,21,6,10),(6,21,6,11),(6,21,6,18),(6,21,6,20),(6,21,6,21),(6,21,6,22),(12,21,7,1),(6,21,7,11),(6,21,7,19),(6,21,7,20),(6,21,8,11),(6,21,8,12),(6,21,8,13),(6,21,8,19),(6,21,8,20),(6,21,9,12),(6,21,9,13),(6,21,9,14),(6,21,9,20),(3,21,9,25),(3,21,9,26),(6,21,10,12),(6,21,10,13),(8,21,10,22),(3,21,10,25),(3,21,10,26),(3,21,10,27),(3,21,10,29),(3,21,11,26),(3,21,11,27),(3,21,11,28),(3,21,11,29),(3,21,12,27),(3,21,12,28),(3,21,12,29),(3,21,13,25),(3,21,13,27),(3,21,13,28),(3,21,13,29),(3,21,14,25),(3,21,14,26),(3,21,14,27),(3,21,14,28),(3,21,14,29),(3,21,15,25),(3,21,15,26),(3,21,15,27),(3,21,15,28),(3,21,15,29),(5,21,16,0),(3,21,16,26),(3,21,16,27),(3,21,16,28),(3,21,16,29),(5,21,17,0),(5,21,17,1),(3,21,17,25),(3,21,17,26),(3,21,17,27),(3,21,17,28),(3,21,17,29),(5,21,18,0),(5,21,18,1),(3,21,18,24),(3,21,18,25),(3,21,18,26),(3,21,18,27),(3,21,18,28),(3,21,18,29),(5,21,19,0),(3,21,19,24),(3,21,19,25),(3,21,19,26),(3,21,19,27),(3,21,19,28),(3,21,19,29),(5,21,20,0),(5,21,20,1),(3,21,20,24),(3,21,20,25),(3,21,20,26),(3,21,20,27),(3,21,20,28),(3,21,20,29),(5,21,21,0),(3,21,21,25),(3,21,21,26),(3,21,21,27),(3,21,21,28),(3,21,21,29),(5,21,22,0),(14,21,22,1),(3,21,22,27),(3,21,22,28),(3,21,22,29),(5,21,23,0),(4,21,23,20),(3,21,23,26),(3,21,23,27),(3,21,23,28),(3,21,23,29),(5,21,24,0),(4,21,24,18),(4,21,24,19),(4,21,24,20),(4,21,24,21),(4,21,24,22),(3,21,24,27),(3,21,24,28),(5,21,25,0),(5,21,25,2),(4,21,25,19),(4,21,25,20),(4,21,25,21),(4,21,25,22),(5,21,26,0),(5,21,26,1),(5,21,26,2),(6,21,26,6),(6,21,26,7),(2,21,26,16),(4,21,26,19),(4,21,26,20),(4,21,26,21),(4,21,26,22),(4,21,26,23),(6,21,27,5),(6,21,27,6),(5,21,27,7),(5,21,27,8),(5,21,27,11),(5,21,27,12),(4,21,27,19),(4,21,27,20),(4,21,27,21),(4,21,27,22),(4,21,27,23),(4,21,27,24),(5,21,28,1),(5,21,28,2),(5,21,28,3),(5,21,28,4),(6,21,28,5),(6,21,28,6),(5,21,28,7),(5,21,28,8),(5,21,28,10),(5,21,28,11),(5,21,28,12),(5,21,28,13),(5,21,28,14),(4,21,28,19),(4,21,28,20),(4,21,28,21),(4,21,28,22),(4,21,28,23),(5,21,29,2),(6,21,29,3),(6,21,29,4),(6,21,29,5),(6,21,29,6),(5,21,29,7),(5,21,29,8),(5,21,29,9),(5,21,29,10),(5,21,29,11),(5,21,29,12),(5,21,29,13),(4,21,29,18),(4,21,29,19),(4,21,29,20),(4,21,29,21),(4,21,29,22),(5,30,0,23),(5,30,0,24),(5,30,0,25),(5,30,0,26),(5,30,0,27),(5,30,0,28),(3,30,1,16),(3,30,1,17),(5,30,1,22),(5,30,1,24),(5,30,1,25),(5,30,1,26),(5,30,1,28),(3,30,2,16),(3,30,2,17),(5,30,2,21),(5,30,2,22),(5,30,2,23),(5,30,2,24),(5,30,2,25),(3,30,3,13),(3,30,3,14),(3,30,3,15),(3,30,3,16),(5,30,3,22),(5,30,3,24),(5,30,3,25),(5,30,3,26),(5,30,3,27),(3,30,4,0),(3,30,4,1),(5,30,4,7),(3,30,4,14),(5,30,4,24),(5,30,4,25),(5,30,4,26),(5,30,4,27),(3,30,4,28),(3,30,5,0),(3,30,5,1),(3,30,5,2),(3,30,5,3),(5,30,5,7),(5,30,5,8),(5,30,5,25),(5,30,5,26),(5,30,5,27),(3,30,5,28),(3,30,6,0),(3,30,6,1),(5,30,6,6),(5,30,6,8),(11,30,6,15),(14,30,6,21),(3,30,6,28),(3,30,7,1),(5,30,7,6),(5,30,7,7),(5,30,7,8),(5,30,7,9),(5,30,7,10),(3,30,7,28),(5,30,8,7),(5,30,8,8),(5,30,8,9),(5,30,8,10),(5,30,8,11),(3,30,8,27),(3,30,8,28),(6,30,9,0),(5,30,9,6),(5,30,9,7),(4,30,9,8),(5,30,9,9),(5,30,9,10),(5,30,9,11),(10,30,9,21),(3,30,9,27),(3,30,9,28),(6,30,10,0),(6,30,10,2),(5,30,10,7),(4,30,10,8),(5,30,10,9),(5,30,10,10),(5,30,10,11),(5,30,10,12),(3,30,10,28),(6,30,11,0),(6,30,11,1),(6,30,11,2),(6,30,11,3),(5,30,11,7),(4,30,11,8),(5,30,11,9),(4,30,11,10),(12,30,11,15),(6,30,12,0),(4,30,12,7),(4,30,12,8),(5,30,12,9),(4,30,12,10),(4,30,12,11),(1,30,12,26),(3,30,13,6),(4,30,13,7),(4,30,13,8),(4,30,13,9),(4,30,13,10),(4,30,13,11),(4,30,13,12),(10,30,13,21),(3,30,14,4),(3,30,14,5),(3,30,14,6),(4,30,14,7),(4,30,14,8),(4,30,14,9),(4,30,14,10),(4,30,14,11),(4,30,14,12),(4,30,14,13),(3,30,15,4),(3,30,15,5),(3,30,15,6),(4,30,15,7),(4,30,15,8),(4,30,15,9),(4,30,15,10),(4,30,15,11),(4,30,15,12),(5,30,16,1),(5,30,16,3),(5,30,16,4),(3,30,16,6),(4,30,16,7),(4,30,16,8),(4,30,16,9),(4,30,16,11),(4,30,16,12),(5,30,17,0),(5,30,17,1),(5,30,17,2),(5,30,17,3),(3,30,17,6),(4,30,17,7),(4,30,17,8),(4,30,17,9),(4,30,17,10),(4,30,17,11),(4,30,17,12),(14,30,17,21),(5,30,18,1),(5,30,18,2),(4,30,18,6),(4,30,18,7),(4,30,18,8),(4,30,18,9),(4,30,18,10),(4,30,18,11),(4,30,18,25),(4,30,18,26),(5,30,19,0),(5,30,19,1),(5,30,19,2),(5,30,19,3),(5,30,19,4),(5,30,19,5),(4,30,19,6),(4,30,19,7),(4,30,19,8),(4,30,19,9),(6,30,19,14),(4,30,19,25),(5,30,20,1),(5,30,20,2),(5,30,20,3),(5,30,20,4),(5,30,20,5),(4,30,20,7),(4,30,20,9),(6,30,20,13),(6,30,20,14),(12,30,20,15),(4,30,20,21),(4,30,20,22),(4,30,20,24),(4,30,20,25),(4,30,20,26),(4,30,20,27),(5,30,21,0),(5,30,21,1),(5,30,21,2),(5,30,21,3),(5,30,21,4),(5,30,21,5),(5,30,21,6),(4,30,21,9),(6,30,21,12),(6,30,21,14),(4,30,21,21),(4,30,21,22),(4,30,21,23),(4,30,21,24),(4,30,21,25),(4,30,21,27),(4,30,21,28),(5,30,22,1),(6,30,22,12),(6,30,22,13),(6,30,22,14),(4,30,22,21),(2,30,22,22),(3,30,23,8),(6,30,23,12),(6,30,23,13),(6,30,23,14),(3,30,24,4),(3,30,24,5),(3,30,24,6),(3,30,24,7),(3,30,24,8),(6,30,24,11),(6,30,24,12),(6,30,24,13),(3,30,25,5),(3,30,25,6),(3,30,25,7),(6,30,25,13),(6,30,25,14),(6,47,0,12),(3,47,0,31),(3,47,0,32),(3,47,0,33),(4,47,0,34),(4,47,0,36),(4,47,0,37),(6,47,1,11),(6,47,1,12),(4,47,1,28),(3,47,1,30),(3,47,1,31),(3,47,1,32),(4,47,1,34),(4,47,1,35),(4,47,1,37),(6,47,2,11),(6,47,2,12),(6,47,2,13),(6,47,2,24),(4,47,2,28),(4,47,2,29),(3,47,2,30),(3,47,2,31),(3,47,2,32),(4,47,2,34),(4,47,2,35),(4,47,2,36),(4,47,2,37),(6,47,3,10),(6,47,3,11),(6,47,3,12),(6,47,3,13),(6,47,3,14),(6,47,3,22),(6,47,3,23),(6,47,3,24),(6,47,3,25),(4,47,3,29),(3,47,3,30),(3,47,3,31),(3,47,3,32),(4,47,3,34),(4,47,3,35),(4,47,3,36),(4,47,3,37),(13,47,4,10),(8,47,4,12),(6,47,4,22),(6,47,4,23),(6,47,4,24),(6,47,4,25),(6,47,4,26),(4,47,4,28),(4,47,4,29),(3,47,4,31),(4,47,4,35),(8,47,5,18),(6,47,5,25),(4,47,5,27),(4,47,5,28),(4,47,5,29),(4,47,5,30),(3,47,5,31),(3,47,5,32),(3,47,5,33),(4,47,5,35),(4,47,6,27),(4,47,6,28),(4,47,6,29),(4,47,6,30),(4,47,6,35),(4,47,7,28),(5,47,7,29),(5,47,7,30),(6,47,8,9),(3,47,8,17),(3,47,8,19),(4,47,8,28),(4,47,8,29),(5,47,8,30),(5,47,8,31),(6,47,9,6),(6,47,9,7),(6,47,9,9),(4,47,9,12),(3,47,9,16),(3,47,9,17),(3,47,9,18),(3,47,9,19),(5,47,9,28),(5,47,9,29),(5,47,9,30),(5,47,9,31),(5,47,9,32),(5,47,9,33),(5,47,9,34),(3,47,10,0),(6,47,10,6),(6,47,10,7),(6,47,10,8),(6,47,10,9),(4,47,10,12),(4,47,10,13),(3,47,10,15),(3,47,10,16),(3,47,10,17),(3,47,10,18),(3,47,10,19),(4,47,10,23),(4,47,10,24),(5,47,10,26),(5,47,10,27),(5,47,10,28),(5,47,10,29),(5,47,10,30),(5,47,10,31),(5,47,10,32),(3,47,11,0),(3,47,11,1),(6,47,11,4),(6,47,11,5),(6,47,11,6),(4,47,11,12),(4,47,11,13),(4,47,11,14),(4,47,11,15),(3,47,11,16),(3,47,11,17),(3,47,11,18),(4,47,11,21),(4,47,11,22),(4,47,11,23),(4,47,11,24),(4,47,11,25),(5,47,11,28),(5,47,11,29),(3,47,11,30),(5,47,11,31),(5,47,11,32),(3,47,12,0),(3,47,12,1),(4,47,12,9),(4,47,12,10),(4,47,12,11),(4,47,12,12),(3,47,12,16),(3,47,12,18),(4,47,12,21),(4,47,12,22),(4,47,12,23),(4,47,12,24),(4,47,12,25),(4,47,12,26),(4,47,12,27),(3,47,12,28),(3,47,12,29),(3,47,12,30),(3,47,12,31),(5,47,12,32),(3,47,13,0),(3,47,13,1),(3,47,13,2),(3,47,13,3),(2,47,13,8),(4,47,13,10),(4,47,13,11),(4,47,13,12),(4,47,13,13),(4,47,13,22),(4,47,13,23),(4,47,13,26),(3,47,13,27),(3,47,13,28),(3,47,13,29),(5,47,13,30),(5,47,13,31),(5,47,13,32),(5,47,13,33),(3,47,14,0),(3,47,14,1),(3,47,14,2),(4,47,14,11),(4,47,14,13),(5,47,14,21),(5,47,14,22),(5,47,14,25),(5,47,14,26),(3,47,14,27),(3,47,14,28),(5,47,14,29),(5,47,14,30),(5,47,14,31),(5,47,14,32),(5,47,14,33),(13,47,15,0),(3,47,15,2),(3,47,15,3),(1,47,15,4),(5,47,15,22),(5,47,15,23),(5,47,15,24),(5,47,15,25),(5,47,15,26),(5,47,15,27),(5,47,15,28),(5,47,15,29),(5,47,15,30),(5,47,15,31),(5,47,15,33),(5,47,15,34),(6,47,15,35),(3,47,16,2),(5,47,16,21),(5,47,16,22),(5,47,16,23),(5,47,16,24),(5,47,16,25),(5,47,16,26),(5,47,16,27),(5,47,16,28),(5,47,16,29),(5,47,16,30),(5,47,16,31),(5,47,16,32),(5,47,16,33),(6,47,16,34),(6,47,16,35),(6,47,16,36),(6,47,16,37),(3,47,17,2),(5,47,17,21),(5,47,17,23),(5,47,17,24),(5,47,17,25),(5,47,17,26),(5,47,17,29),(5,47,17,31),(5,47,17,32),(5,47,17,33),(5,47,17,34),(5,47,17,35),(6,47,17,36),(6,47,18,11),(6,47,18,12),(5,47,18,22),(5,47,18,23),(5,47,18,24),(5,47,18,29),(5,47,18,30),(5,47,18,31),(5,47,18,32),(6,47,18,34),(6,47,18,35),(6,47,18,36),(14,47,19,4),(2,47,19,9),(6,47,19,11),(6,47,19,12),(6,47,19,13),(3,47,19,22),(5,47,19,23),(3,47,19,24),(3,47,19,25),(5,47,19,32),(6,47,19,35),(6,47,19,36),(6,47,20,11),(6,47,20,12),(3,47,20,20),(3,47,20,21),(3,47,20,22),(3,47,20,23),(3,47,20,24),(3,47,20,25),(6,47,21,9),(6,47,21,10),(6,47,21,11),(6,47,21,12),(3,47,21,20),(3,47,21,21),(3,47,21,22),(3,47,21,23),(3,47,21,24),(3,47,21,25),(3,47,21,26);
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
) ENGINE=InnoDB AUTO_INCREMENT=104 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `units`
--

LOCK TABLES `units` WRITE;
/*!40000 ALTER TABLE `units` DISABLE KEYS */;
INSERT INTO `units` VALUES (1,8000,1,1,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,2,210,NULL,1,0,0,0),(2,8000,1,1,1,NULL,NULL,NULL,NULL,0,0,'Dirac',0,2,210,NULL,1,0,0,0),(3,3000,1,1,1,NULL,NULL,NULL,NULL,0,0,'Rhyno',0,5,315,NULL,1,0,0,0),(4,3000,1,1,1,NULL,NULL,NULL,NULL,0,0,'Rhyno',0,5,315,NULL,1,0,0,0),(5,3400,1,1,1,NULL,NULL,NULL,NULL,0,0,'Thor',1,5,315,NULL,1,0,0,0),(6,8000,1,1,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,5,315,NULL,1,0,0,0),(7,8000,1,1,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,5,315,NULL,1,0,0,0),(8,8000,1,1,1,NULL,NULL,NULL,NULL,0,0,'Dirac',0,5,315,NULL,1,0,0,0),(9,3400,1,1,1,NULL,NULL,NULL,NULL,0,0,'Thor',0,5,330,NULL,1,0,0,0),(10,8000,1,1,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,5,330,NULL,1,0,0,0),(11,8000,1,1,1,NULL,NULL,NULL,NULL,0,0,'Dirac',0,5,330,NULL,1,0,0,0),(12,3400,1,1,1,NULL,NULL,NULL,NULL,0,0,'Thor',1,3,44,NULL,1,0,0,0),(13,8000,1,1,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,3,44,NULL,1,0,0,0),(14,8000,1,1,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,3,44,NULL,1,0,0,0),(15,8000,1,1,1,NULL,NULL,NULL,NULL,0,0,'Dirac',0,3,44,NULL,1,0,0,0),(16,3400,1,2,1,NULL,NULL,NULL,NULL,0,0,'Thor',0,5,270,NULL,1,0,0,0),(17,3400,1,2,1,NULL,NULL,NULL,NULL,0,0,'Thor',1,5,270,NULL,1,0,0,0),(18,8000,1,2,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,5,270,NULL,1,0,0,0),(19,8000,1,2,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,5,270,NULL,1,0,0,0),(20,8000,1,2,1,NULL,NULL,NULL,NULL,0,0,'Dirac',0,5,270,NULL,1,0,0,0),(21,3000,1,2,1,NULL,NULL,NULL,NULL,0,0,'Rhyno',0,3,180,NULL,1,0,0,0),(22,3000,1,2,1,NULL,NULL,NULL,NULL,0,0,'Rhyno',0,3,180,NULL,1,0,0,0),(23,3000,1,2,1,NULL,NULL,NULL,NULL,0,0,'Rhyno',0,3,180,NULL,1,0,0,0),(24,3400,1,2,1,NULL,NULL,NULL,NULL,0,0,'Thor',0,3,180,NULL,1,0,0,0),(25,3400,1,2,1,NULL,NULL,NULL,NULL,0,0,'Thor',1,3,180,NULL,1,0,0,0),(26,8000,1,2,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,3,180,NULL,1,0,0,0),(27,8000,1,2,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,3,180,NULL,1,0,0,0),(28,8000,1,2,1,NULL,NULL,NULL,NULL,0,0,'Dirac',0,3,180,NULL,1,0,0,0),(29,200,1,14,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,26,16,NULL,1,0,0,0),(30,100,1,14,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,26,16,NULL,1,0,0,0),(31,200,1,14,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,26,16,NULL,1,0,0,0),(32,100,1,14,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,26,16,NULL,1,0,0,0),(33,200,1,14,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,26,16,NULL,1,0,0,0),(34,100,1,14,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,26,16,NULL,1,0,0,0),(35,100,1,14,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,26,16,NULL,1,0,0,0),(36,100,1,15,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,25,20,NULL,1,0,0,0),(37,200,1,15,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,25,20,NULL,1,0,0,0),(38,100,1,15,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,25,20,NULL,1,0,0,0),(39,100,1,15,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,25,20,NULL,1,0,0,0),(40,200,1,19,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,24,24,NULL,1,0,0,0),(41,100,1,19,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,24,24,NULL,1,0,0,0),(42,100,1,19,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,24,24,NULL,1,0,0,0),(43,200,1,20,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,28,24,NULL,1,0,0,0),(44,100,1,20,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,28,24,NULL,1,0,0,0),(45,100,1,20,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,28,24,NULL,1,0,0,0),(46,100,1,21,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,18,25,NULL,1,0,0,0),(47,100,1,21,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,18,25,NULL,1,0,0,0),(48,100,1,22,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,15,26,NULL,1,0,0,0),(49,100,1,22,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,15,26,NULL,1,0,0,0),(50,200,1,23,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,3,27,NULL,1,0,0,0),(51,100,1,23,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,3,27,NULL,1,0,0,0),(52,100,1,23,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,3,27,NULL,1,0,0,0),(53,100,1,24,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,12,27,NULL,1,0,0,0),(54,100,1,24,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,12,27,NULL,1,0,0,0),(55,100,1,25,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,22,27,NULL,1,0,0,0),(56,100,1,25,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,22,27,NULL,1,0,0,0),(57,200,1,26,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,26,27,NULL,1,0,0,0),(58,100,1,26,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,26,27,NULL,1,0,0,0),(59,100,1,26,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,26,27,NULL,1,0,0,0),(60,200,1,27,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,0,28,NULL,1,0,0,0),(61,100,1,27,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,0,28,NULL,1,0,0,0),(62,100,1,27,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,0,28,NULL,1,0,0,0),(63,200,1,28,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,7,28,NULL,1,0,0,0),(64,100,1,28,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,7,28,NULL,1,0,0,0),(65,100,1,28,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,7,28,NULL,1,0,0,0),(66,100,1,29,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,18,28,NULL,1,0,0,0),(67,100,1,29,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,18,28,NULL,1,0,0,0),(68,3000,1,3,1,NULL,NULL,NULL,NULL,0,0,'Rhyno',0,2,90,NULL,1,0,0,0),(69,3400,1,3,1,NULL,NULL,NULL,NULL,0,0,'Thor',0,2,90,NULL,1,0,0,0),(70,8000,1,3,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,2,90,NULL,1,0,0,0),(71,8000,1,3,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,2,90,NULL,1,0,0,0),(72,8000,1,3,1,NULL,NULL,NULL,NULL,0,0,'Dirac',0,2,90,NULL,1,0,0,0),(73,3000,1,3,1,NULL,NULL,NULL,NULL,0,0,'Rhyno',0,5,225,NULL,1,0,0,0),(74,3000,1,3,1,NULL,NULL,NULL,NULL,0,0,'Rhyno',0,5,225,NULL,1,0,0,0),(75,3400,1,3,1,NULL,NULL,NULL,NULL,0,0,'Thor',0,5,225,NULL,1,0,0,0),(76,8000,1,3,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,5,225,NULL,1,0,0,0),(77,8000,1,3,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,5,225,NULL,1,0,0,0),(78,8000,1,3,1,NULL,NULL,NULL,NULL,0,0,'Dirac',0,5,225,NULL,1,0,0,0),(79,3000,1,3,1,NULL,NULL,NULL,NULL,0,0,'Rhyno',0,4,288,NULL,1,0,0,0),(80,3400,1,3,1,NULL,NULL,NULL,NULL,0,0,'Thor',0,4,288,NULL,1,0,0,0),(81,8000,1,3,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,4,288,NULL,1,0,0,0),(82,8000,1,3,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,4,288,NULL,1,0,0,0),(83,8000,1,3,1,NULL,NULL,NULL,NULL,0,0,'Dirac',0,4,288,NULL,1,0,0,0),(84,8000,1,3,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,3,202,NULL,1,0,0,0),(85,8000,1,3,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,3,202,NULL,1,0,0,0),(86,8000,1,3,1,NULL,NULL,NULL,NULL,0,0,'Dirac',0,3,202,NULL,1,0,0,0),(87,3400,1,3,1,NULL,NULL,NULL,NULL,0,0,'Thor',1,3,134,NULL,1,0,0,0),(88,8000,1,3,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,3,134,NULL,1,0,0,0),(89,8000,1,3,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,3,134,NULL,1,0,0,0),(90,8000,1,3,1,NULL,NULL,NULL,NULL,0,0,'Dirac',0,3,134,NULL,1,0,0,0),(91,3000,1,3,1,NULL,NULL,NULL,NULL,0,0,'Rhyno',0,5,240,NULL,1,0,0,0),(92,8000,1,3,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,5,240,NULL,1,0,0,0),(93,8000,1,3,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,5,240,NULL,1,0,0,0),(94,8000,1,3,1,NULL,NULL,NULL,NULL,0,0,'Dirac',0,5,240,NULL,1,0,0,0),(95,3400,1,3,1,NULL,NULL,NULL,NULL,0,0,'Thor',0,2,300,NULL,1,0,0,0),(96,8000,1,3,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,2,300,NULL,1,0,0,0),(97,8000,1,3,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,2,300,NULL,1,0,0,0),(98,8000,1,3,1,NULL,NULL,NULL,NULL,0,0,'Dirac',0,2,300,NULL,1,0,0,0),(99,3400,1,4,1,NULL,NULL,NULL,NULL,0,0,'Thor',0,2,150,NULL,1,0,0,0),(100,3400,1,4,1,NULL,NULL,NULL,NULL,0,0,'Thor',1,2,150,NULL,1,0,0,0),(101,8000,1,4,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,2,150,NULL,1,0,0,0),(102,8000,1,4,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,2,150,NULL,1,0,0,0),(103,8000,1,4,1,NULL,NULL,NULL,NULL,0,0,'Dirac',0,2,150,NULL,1,0,0,0);
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

-- Dump completed on 2010-10-26 11:43:32
