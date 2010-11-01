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
) ENGINE=InnoDB AUTO_INCREMENT=53 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `buildings`
--

LOCK TABLES `buildings` WRITE;
/*!40000 ALTER TABLE `buildings` DISABLE KEYS */;
INSERT INTO `buildings` VALUES (1,9,6,15,0,0,0,1,'NpcMetalExtractor',NULL,8,17,NULL,0,400,NULL,0,NULL,NULL,0),(2,9,1,2,0,0,0,1,'NpcMetalExtractor',NULL,3,4,NULL,0,400,NULL,0,NULL,NULL,0),(3,9,2,18,0,0,0,1,'NpcMetalExtractor',NULL,4,20,NULL,0,400,NULL,0,NULL,NULL,0),(4,9,2,10,0,0,0,1,'NpcMetalExtractor',NULL,4,12,NULL,0,400,NULL,0,NULL,NULL,0),(5,9,1,6,0,0,0,1,'NpcMetalExtractor',NULL,3,8,NULL,0,400,NULL,0,NULL,NULL,0),(6,9,2,14,0,0,0,1,'NpcMetalExtractor',NULL,4,16,NULL,0,400,NULL,0,NULL,NULL,0),(7,9,6,6,0,0,0,1,'NpcZetiumExtractor',NULL,8,8,NULL,0,800,NULL,0,NULL,NULL,0),(8,23,12,40,0,0,0,1,'NpcMetalExtractor',NULL,14,42,NULL,0,400,NULL,0,NULL,NULL,0),(9,23,7,39,0,0,0,1,'NpcMetalExtractor',NULL,9,41,NULL,0,400,NULL,0,NULL,NULL,0),(10,23,17,38,0,0,0,1,'NpcMetalExtractor',NULL,19,40,NULL,0,400,NULL,0,NULL,NULL,0),(11,23,25,39,0,0,0,1,'NpcMetalExtractor',NULL,27,41,NULL,0,400,NULL,0,NULL,NULL,0),(12,23,7,23,0,0,0,1,'NpcGeothermalPlant',NULL,9,25,NULL,0,600,NULL,0,NULL,NULL,0),(13,23,8,33,0,0,0,1,'NpcZetiumExtractor',NULL,10,35,NULL,0,800,NULL,0,NULL,NULL,0),(14,27,13,23,0,0,0,1,'NpcMetalExtractor',NULL,15,25,NULL,0,400,NULL,0,NULL,NULL,0),(15,27,19,27,0,0,0,1,'NpcMetalExtractor',NULL,21,29,NULL,0,400,NULL,0,NULL,NULL,0),(16,27,18,2,0,0,0,1,'NpcMetalExtractor',NULL,20,4,NULL,0,400,NULL,0,NULL,NULL,0),(17,27,17,11,0,0,0,1,'NpcMetalExtractor',NULL,19,13,NULL,0,400,NULL,0,NULL,NULL,0),(18,27,24,6,0,0,0,1,'NpcGeothermalPlant',NULL,26,8,NULL,0,600,NULL,0,NULL,NULL,0),(19,33,7,9,0,0,0,1,'Vulcan',NULL,9,11,NULL,0,300,NULL,0,NULL,NULL,0),(20,33,14,9,0,0,0,1,'Thunder',NULL,16,11,NULL,0,300,NULL,0,NULL,NULL,0),(21,33,21,9,0,0,0,1,'Screamer',NULL,23,11,NULL,0,300,NULL,0,NULL,NULL,0),(22,33,11,14,0,0,0,1,'Mothership',NULL,19,20,NULL,0,10500,NULL,0,NULL,NULL,0),(23,33,7,16,0,0,0,1,'Thunder',NULL,9,18,NULL,0,300,NULL,0,NULL,NULL,0),(24,33,21,16,0,0,0,1,'Thunder',NULL,23,18,NULL,0,300,NULL,0,NULL,NULL,0),(25,33,26,16,0,0,0,1,'NpcZetiumExtractor',NULL,28,18,NULL,0,800,NULL,0,NULL,NULL,0),(26,33,25,20,0,0,0,1,'NpcTemple',NULL,28,23,NULL,0,1500,NULL,0,NULL,NULL,0),(27,33,7,22,0,0,0,1,'Screamer',NULL,9,24,NULL,0,300,NULL,0,NULL,NULL,0),(28,33,14,22,0,0,0,1,'Thunder',NULL,16,24,NULL,0,300,NULL,0,NULL,NULL,0),(29,33,21,22,0,0,0,1,'Vulcan',NULL,23,24,NULL,0,300,NULL,0,NULL,NULL,0),(30,33,24,24,0,0,0,1,'NpcMetalExtractor',NULL,26,26,NULL,0,400,NULL,0,NULL,NULL,0),(31,33,28,24,0,0,0,1,'NpcMetalExtractor',NULL,30,26,NULL,0,400,NULL,0,NULL,NULL,0),(32,33,18,25,0,0,0,1,'NpcSolarPlant',NULL,20,27,NULL,0,1000,NULL,0,NULL,NULL,0),(33,33,15,26,0,0,0,1,'NpcSolarPlant',NULL,17,28,NULL,0,1000,NULL,0,NULL,NULL,0),(34,33,3,27,0,0,0,1,'NpcMetalExtractor',NULL,5,29,NULL,0,400,NULL,0,NULL,NULL,0),(35,33,12,27,0,0,0,1,'NpcSolarPlant',NULL,14,29,NULL,0,1000,NULL,0,NULL,NULL,0),(36,33,22,27,0,0,0,1,'NpcSolarPlant',NULL,24,29,NULL,0,1000,NULL,0,NULL,NULL,0),(37,33,26,27,0,0,0,1,'NpcCommunicationsHub',NULL,29,29,NULL,0,1200,NULL,0,NULL,NULL,0),(38,33,0,28,0,0,0,1,'NpcMetalExtractor',NULL,2,30,NULL,0,400,NULL,0,NULL,NULL,0),(39,33,7,28,0,0,0,1,'NpcCommunicationsHub',NULL,10,30,NULL,0,1200,NULL,0,NULL,NULL,0),(40,33,18,28,0,0,0,1,'NpcSolarPlant',NULL,20,30,NULL,0,1000,NULL,0,NULL,NULL,0),(41,37,26,11,0,0,0,1,'NpcMetalExtractor',NULL,28,13,NULL,0,400,NULL,0,NULL,NULL,0),(42,37,43,3,0,0,0,1,'NpcMetalExtractor',NULL,45,5,NULL,0,400,NULL,0,NULL,NULL,0),(43,37,44,7,0,0,0,1,'NpcMetalExtractor',NULL,46,9,NULL,0,400,NULL,0,NULL,NULL,0),(44,37,39,7,0,0,0,1,'NpcMetalExtractor',NULL,41,9,NULL,0,400,NULL,0,NULL,NULL,0),(45,42,5,18,0,0,0,1,'NpcMetalExtractor',NULL,7,20,NULL,0,400,NULL,0,NULL,NULL,0),(46,42,6,24,0,0,0,1,'NpcMetalExtractor',NULL,8,26,NULL,0,400,NULL,0,NULL,NULL,0),(47,42,2,23,0,0,0,1,'NpcMetalExtractor',NULL,4,25,NULL,0,400,NULL,0,NULL,NULL,0),(48,53,45,2,0,0,0,1,'NpcMetalExtractor',NULL,47,4,NULL,0,400,NULL,0,NULL,NULL,0),(49,53,1,1,0,0,0,1,'NpcMetalExtractor',NULL,3,3,NULL,0,400,NULL,0,NULL,NULL,0),(50,53,5,1,0,0,0,1,'NpcMetalExtractor',NULL,7,3,NULL,0,400,NULL,0,NULL,NULL,0),(51,53,10,22,0,0,0,1,'NpcMetalExtractor',NULL,12,24,NULL,0,400,NULL,0,NULL,NULL,0),(52,53,5,27,0,0,0,1,'NpcZetiumExtractor',NULL,7,29,NULL,0,800,NULL,0,NULL,NULL,0);
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
INSERT INTO `folliages` VALUES (9,0,0,3),(9,0,1,4),(9,0,15,3),(9,0,23,12),(9,1,9,13),(9,1,12,7),(9,1,14,3),(9,2,1,5),(9,2,5,5),(9,2,12,5),(9,2,14,10),(9,3,9,10),(9,3,12,2),(9,4,0,5),(9,4,16,1),(9,4,22,11),(9,4,23,8),(9,5,19,8),(9,6,0,12),(9,6,1,11),(9,6,2,10),(9,6,19,0),(9,6,23,3),(9,7,3,9),(9,7,18,11),(9,8,1,7),(9,8,5,5),(9,8,8,1),(9,8,10,5),(9,8,13,9),(9,8,14,12),(9,8,17,7),(9,8,23,3),(9,9,1,3),(9,9,5,11),(9,9,8,3),(9,9,19,10),(9,9,22,2),(9,10,3,0),(9,10,5,8),(9,10,14,2),(9,10,15,5),(9,10,16,4),(9,11,13,8),(9,11,14,0),(9,12,13,11),(9,12,16,9),(9,13,14,10),(9,13,18,2),(9,13,23,12),(9,14,1,11),(9,14,2,10),(9,14,15,6),(9,14,16,10),(9,15,14,5),(9,15,23,11),(9,16,0,4),(9,16,1,8),(9,16,14,10),(9,17,7,6),(9,18,1,2),(9,18,7,12),(9,18,20,11),(9,19,1,5),(9,19,23,7),(9,21,7,6),(9,21,20,9),(9,22,13,3),(9,22,14,13),(9,22,19,9),(9,22,23,12),(9,24,18,13),(9,24,23,2),(9,25,13,6),(9,25,15,6),(9,25,18,1),(9,25,20,1),(9,25,23,8),(9,26,13,7),(9,26,16,10),(9,26,18,8),(9,27,5,6),(9,27,19,13),(9,27,22,6),(9,28,16,2),(9,28,17,3),(9,28,19,8),(9,28,22,11),(9,29,14,4),(9,30,0,12),(9,30,17,1),(9,30,19,9),(9,31,7,2),(9,31,15,3),(23,0,9,11),(23,0,17,9),(23,0,23,10),(23,0,33,12),(23,1,12,8),(23,1,16,5),(23,1,17,10),(23,1,20,12),(23,1,22,7),(23,2,21,1),(23,3,19,3),(23,3,20,9),(23,3,21,4),(23,3,40,2),(23,4,23,8),(23,4,24,9),(23,4,40,11),(23,4,43,5),(23,5,8,10),(23,5,18,1),(23,5,19,8),(23,5,20,8),(23,5,24,7),(23,5,25,2),(23,5,40,0),(23,5,41,9),(23,6,20,10),(23,6,21,1),(23,6,25,2),(23,6,26,6),(23,6,33,7),(23,6,38,10),(23,6,43,0),(23,7,3,0),(23,7,15,9),(23,7,20,1),(23,7,32,10),(23,8,16,5),(23,8,21,2),(23,8,22,6),(23,8,35,7),(23,8,41,11),(23,8,42,2),(23,9,1,11),(23,9,14,10),(23,9,16,4),(23,9,21,11),(23,9,23,12),(23,9,24,9),(23,9,28,8),(23,9,35,4),(23,9,39,2),(23,9,42,13),(23,10,0,3),(23,10,1,2),(23,10,3,6),(23,10,23,2),(23,10,25,0),(23,10,29,12),(23,11,0,2),(23,11,1,2),(23,11,2,13),(23,11,5,3),(23,11,6,3),(23,11,7,11),(23,11,8,11),(23,11,13,8),(23,11,26,4),(23,11,33,2),(23,12,1,8),(23,12,3,5),(23,12,7,1),(23,12,11,0),(23,12,23,0),(23,12,26,4),(23,12,31,1),(23,12,43,1),(23,13,4,1),(23,13,8,10),(23,13,13,2),(23,13,16,8),(23,13,18,1),(23,13,19,2),(23,13,30,10),(23,14,1,1),(23,14,2,8),(23,14,6,10),(23,14,13,0),(23,14,14,7),(23,14,19,4),(23,14,43,3),(23,15,1,8),(23,15,6,1),(23,15,38,3),(23,16,17,5),(23,16,37,4),(23,17,0,6),(23,17,33,8),(23,17,34,4),(23,17,40,0),(23,18,0,5),(23,18,2,5),(23,18,20,6),(23,18,33,4),(23,18,40,8),(23,19,1,4),(23,19,3,9),(23,19,16,5),(23,20,3,3),(23,20,32,1),(23,20,42,2),(23,20,43,1),(23,21,24,12),(23,21,39,7),(23,22,0,2),(23,22,17,0),(23,22,30,2),(23,22,31,11),(23,22,43,2),(23,23,19,11),(23,23,37,6),(23,24,16,2),(23,24,19,4),(23,25,4,10),(23,25,10,5),(23,25,13,10),(23,25,16,6),(23,25,17,11),(23,25,35,6),(23,25,36,10),(23,25,38,5),(23,26,7,10),(23,26,11,0),(23,26,12,9),(23,26,19,10),(23,26,38,5),(23,27,0,6),(23,27,15,11),(23,27,23,11),(23,27,24,5),(23,28,13,2),(23,28,14,12),(23,28,21,1),(23,28,24,0),(23,28,41,7),(23,28,43,3),(27,0,10,3),(27,0,11,0),(27,0,12,1),(27,0,13,10),(27,0,15,4),(27,0,29,0),(27,1,6,11),(27,1,8,3),(27,1,9,6),(27,1,10,4),(27,1,12,1),(27,1,15,2),(27,1,16,13),(27,2,7,7),(27,2,8,10),(27,2,9,3),(27,2,10,5),(27,3,10,3),(27,3,13,1),(27,3,15,1),(27,3,16,1),(27,4,1,3),(27,4,10,7),(27,4,11,1),(27,4,14,11),(27,4,30,3),(27,5,4,4),(27,5,13,10),(27,5,14,10),(27,5,15,0),(27,6,6,2),(27,6,11,0),(27,6,18,8),(27,6,27,13),(27,6,29,5),(27,7,2,8),(27,7,8,2),(27,7,14,9),(27,7,26,3),(27,7,29,12),(27,8,8,3),(27,8,11,13),(27,8,15,10),(27,8,16,9),(27,8,18,5),(27,9,3,9),(27,9,7,7),(27,9,17,9),(27,9,18,5),(27,10,4,2),(27,10,15,2),(27,10,16,13),(27,10,20,2),(27,10,26,9),(27,11,25,7),(27,11,26,1),(27,11,29,7),(27,12,15,8),(27,12,19,1),(27,12,22,4),(27,12,24,1),(27,12,26,12),(27,13,0,6),(27,13,10,1),(27,13,13,7),(27,13,20,4),(27,13,25,11),(27,13,28,9),(27,14,11,1),(27,14,13,13),(27,14,18,3),(27,14,20,12),(27,14,21,3),(27,15,2,1),(27,15,6,1),(27,15,11,4),(27,15,12,3),(27,15,14,11),(27,15,23,2),(27,15,28,3),(27,15,29,8),(27,16,11,5),(27,16,12,6),(27,16,28,7),(27,16,30,11),(27,17,13,1),(27,17,17,2),(27,17,18,4),(27,18,0,11),(27,18,9,4),(27,18,30,4),(27,18,31,1),(27,19,0,8),(27,19,1,8),(27,19,8,4),(27,19,13,2),(27,19,15,5),(27,20,2,5),(27,20,3,2),(27,20,4,13),(27,20,15,2),(27,20,20,1),(27,21,0,7),(27,21,4,8),(27,21,13,3),(27,21,14,3),(27,21,17,5),(27,21,18,9),(27,21,22,11),(27,21,23,13),(27,21,25,4),(27,21,29,8),(27,22,13,7),(27,22,20,4),(27,22,21,2),(27,22,22,10),(27,22,24,7),(27,22,27,12),(27,22,30,7),(27,23,1,5),(27,23,7,2),(27,23,31,9),(27,24,5,8),(27,25,2,3),(27,25,3,6),(27,25,20,7),(27,25,21,4),(27,26,0,1),(27,26,3,10),(27,26,7,8),(27,27,7,2),(27,27,19,3),(27,28,0,11),(27,28,4,13),(27,28,20,8),(33,0,4,3),(33,0,10,2),(33,0,11,1),(33,0,13,6),(33,0,28,5),(33,1,4,11),(33,1,11,10),(33,1,15,11),(33,2,3,10),(33,2,11,4),(33,3,2,1),(33,3,4,6),(33,4,4,12),(33,4,10,1),(33,4,14,13),(33,4,26,12),(33,5,1,6),(33,5,4,5),(33,5,14,9),(33,5,18,1),(33,5,19,13),(33,5,25,5),(33,6,0,12),(33,6,3,5),(33,6,4,0),(33,6,7,7),(33,6,15,10),(33,6,26,12),(33,6,28,2),(33,7,12,8),(33,7,15,9),(33,7,22,9),(33,7,23,10),(33,7,25,10),(33,7,27,5),(33,8,15,5),(33,8,18,6),(33,8,29,3),(33,9,7,3),(33,9,8,6),(33,9,15,7),(33,9,27,0),(33,9,28,5),(33,10,8,4),(33,10,15,9),(33,10,16,13),(33,10,18,4),(33,10,19,7),(33,10,20,6),(33,10,21,11),(33,11,0,10),(33,11,7,8),(33,11,16,10),(33,11,18,3),(33,11,20,0),(33,12,7,7),(33,12,10,13),(33,12,11,10),(33,12,14,11),(33,13,0,13),(33,13,6,0),(33,13,7,5),(33,13,10,5),(33,13,13,2),(33,13,15,1),(33,13,18,1),(33,13,24,0),(33,14,7,7),(33,14,10,1),(33,14,17,11),(33,15,3,7),(33,15,4,9),(33,15,9,2),(33,15,17,13),(33,15,18,2),(33,15,19,4),(33,15,23,0),(33,15,24,5),(33,16,1,7),(33,16,7,9),(33,16,16,4),(33,16,17,5),(33,16,19,7),(33,17,2,11),(33,17,3,4),(33,17,7,10),(33,17,11,6),(33,17,24,1),(33,18,9,0),(33,18,10,8),(33,18,15,3),(33,18,17,3),(33,18,18,1),(33,18,21,9),(33,18,22,5),(33,19,3,10),(33,19,4,11),(33,19,7,9),(33,19,12,12),(33,19,22,1),(33,19,23,2),(33,20,3,6),(33,20,12,10),(33,20,17,1),(33,20,19,6),(33,20,22,7),(33,20,23,5),(33,21,2,0),(33,21,7,8),(33,21,8,1),(33,21,9,10),(33,21,18,11),(33,22,6,6),(33,22,7,8),(33,22,9,11),(33,22,11,1),(33,22,18,8),(33,22,20,11),(33,22,21,11),(33,22,23,0),(33,22,25,6),(33,23,7,10),(33,23,10,9),(33,23,15,5),(33,23,16,3),(33,23,21,1),(33,23,22,5),(33,24,5,8),(33,24,7,7),(33,24,10,3),(33,24,11,10),(33,24,14,3),(33,25,3,11),(33,25,5,1),(33,25,7,13),(33,25,11,11),(33,25,12,6),(33,25,13,7),(33,25,18,5),(33,25,27,9),(33,25,29,3),(33,26,3,11),(33,26,8,6),(33,26,9,10),(33,26,11,2),(33,26,18,13),(33,27,4,0),(33,27,25,0),(33,28,18,8),(33,29,1,5),(33,29,15,6),(33,29,27,4),(37,0,25,1),(37,0,28,2),(37,1,8,6),(37,1,9,10),(37,1,27,4),(37,1,28,6),(37,2,5,4),(37,2,17,2),(37,2,18,10),(37,2,20,2),(37,2,26,3),(37,2,32,3),(37,3,7,6),(37,3,16,3),(37,3,18,0),(37,3,20,3),(37,3,23,3),(37,3,27,6),(37,4,9,7),(37,4,25,5),(37,4,28,13),(37,6,13,6),(37,6,16,10),(37,7,12,10),(37,7,23,3),(37,7,24,10),(37,7,27,5),(37,8,0,9),(37,8,1,7),(37,8,9,13),(37,8,10,2),(37,8,13,2),(37,8,17,3),(37,8,18,10),(37,8,22,7),(37,9,8,2),(37,9,11,11),(37,9,13,12),(37,9,20,0),(37,9,24,4),(37,9,26,5),(37,9,28,2),(37,10,11,5),(37,10,13,13),(37,10,15,3),(37,10,20,13),(37,10,21,7),(37,10,22,0),(37,10,27,2),(37,11,1,6),(37,11,3,12),(37,11,4,7),(37,11,10,12),(37,11,12,2),(37,11,23,3),(37,12,3,4),(37,12,7,11),(37,12,8,5),(37,12,10,12),(37,12,19,4),(37,12,21,0),(37,12,24,4),(37,12,26,11),(37,12,28,4),(37,13,3,13),(37,13,4,13),(37,13,7,4),(37,13,9,10),(37,13,13,2),(37,13,23,4),(37,13,30,11),(37,14,7,7),(37,14,8,13),(37,14,9,0),(37,14,10,0),(37,14,11,0),(37,14,22,11),(37,14,32,12),(37,15,3,3),(37,15,10,3),(37,15,11,13),(37,15,18,5),(37,15,22,2),(37,15,32,11),(37,16,3,0),(37,16,8,2),(37,16,12,5),(37,16,17,2),(37,17,9,0),(37,17,13,10),(37,17,14,1),(37,17,15,6),(37,17,19,10),(37,17,22,6),(37,17,26,2),(37,18,12,13),(37,18,13,6),(37,18,15,11),(37,18,16,1),(37,18,17,6),(37,18,31,11),(37,18,32,13),(37,19,5,0),(37,19,12,6),(37,19,13,1),(37,19,14,13),(37,19,24,10),(37,19,26,6),(37,19,27,4),(37,20,16,13),(37,20,18,6),(37,20,25,4),(37,20,26,12),(37,20,27,4),(37,20,29,4),(37,21,6,2),(37,21,7,13),(37,21,17,3),(37,21,20,6),(37,21,23,11),(37,21,26,1),(37,21,29,6),(37,22,16,3),(37,22,19,3),(37,22,21,3),(37,23,11,7),(37,23,12,0),(37,23,13,3),(37,23,15,0),(37,23,17,7),(37,23,19,13),(37,23,20,11),(37,23,23,12),(37,23,31,5),(37,24,8,5),(37,24,12,3),(37,24,13,10),(37,24,21,4),(37,24,27,3),(37,25,13,13),(37,25,14,2),(37,25,15,6),(37,25,18,3),(37,25,20,10),(37,25,22,5),(37,25,23,9),(37,25,24,11),(37,25,25,1),(37,25,26,10),(37,26,9,7),(37,26,17,3),(37,26,19,13),(37,26,22,8),(37,26,28,1),(37,27,9,11),(37,27,13,0),(37,27,14,13),(37,27,19,3),(37,27,20,6),(37,27,26,10),(37,27,32,12),(37,28,4,5),(37,28,10,3),(37,28,13,4),(37,28,19,3),(37,28,26,11),(37,28,28,0),(37,28,31,0),(37,29,3,6),(37,29,12,7),(37,29,15,5),(37,29,16,1),(37,29,18,10),(37,29,22,4),(37,29,29,6),(37,29,30,11),(37,29,31,13),(37,30,7,10),(37,30,10,11),(37,30,11,6),(37,30,15,4),(37,30,23,13),(37,30,24,12),(37,30,28,4),(37,30,29,1),(37,30,31,7),(37,30,32,10),(37,31,7,7),(37,31,8,11),(37,31,13,2),(37,31,20,3),(37,31,25,10),(37,31,27,12),(37,31,28,2),(37,31,29,5),(37,31,30,3),(37,31,31,12),(37,31,32,13),(37,32,0,12),(37,32,5,12),(37,32,19,6),(37,32,21,11),(37,32,22,8),(37,32,27,4),(37,33,1,5),(37,33,10,4),(37,33,12,6),(37,33,13,12),(37,33,28,7),(37,34,0,10),(37,34,15,2),(37,34,19,1),(37,34,20,3),(37,34,30,3),(37,35,0,8),(37,35,4,6),(37,35,11,1),(37,35,31,6),(37,36,0,2),(37,36,2,12),(37,36,6,6),(37,36,16,6),(37,37,0,13),(37,37,7,4),(37,37,14,1),(37,37,15,10),(37,37,32,4),(37,38,0,3),(37,38,19,2),(37,38,23,1),(37,38,24,3),(37,38,25,4),(37,38,26,4),(37,38,27,11),(37,39,0,6),(37,39,10,10),(37,39,17,5),(37,39,18,12),(37,39,24,3),(37,40,0,5),(37,40,25,11),(37,40,26,4),(37,40,30,3),(37,40,31,2),(37,41,0,11),(37,41,15,3),(37,41,17,2),(37,41,18,5),(37,41,19,2),(37,41,21,10),(37,41,24,2),(37,41,25,6),(37,41,26,1),(37,41,28,3),(37,41,30,7),(37,42,0,1),(37,42,2,4),(37,42,5,7),(37,42,8,7),(37,42,20,3),(37,42,22,7),(37,42,30,7),(37,42,31,0),(37,43,0,10),(37,43,5,6),(37,43,8,11),(37,43,19,13),(37,43,21,12),(37,44,2,0),(37,44,21,1),(37,44,22,1),(37,45,18,13),(37,45,19,7),(37,45,22,3),(37,46,1,11),(37,46,8,2),(37,46,10,5),(37,46,16,0),(37,46,19,13),(37,46,29,2),(37,46,30,7),(37,46,31,1),(37,46,32,3),(42,0,22,13),(42,1,11,3),(42,2,23,10),(42,3,19,7),(42,3,20,7),(42,4,3,1),(42,4,6,5),(42,4,19,2),(42,4,22,10),(42,4,24,5),(42,5,6,11),(42,5,17,1),(42,5,20,12),(42,6,24,8),(42,7,6,4),(42,8,2,12),(42,8,23,5),(42,8,24,7),(42,9,0,3),(42,9,24,11),(42,9,25,1),(42,10,3,6),(42,10,13,7),(42,10,16,0),(42,10,26,1),(42,11,7,12),(42,11,8,0),(42,11,10,11),(42,11,14,7),(42,11,23,4),(42,12,1,8),(42,12,12,6),(42,12,13,11),(42,12,15,1),(42,12,16,12),(42,12,22,3),(42,12,26,6),(42,13,1,2),(42,13,2,13),(42,13,7,3),(42,13,8,1),(42,13,9,10),(42,14,3,2),(42,14,5,9),(42,14,9,3),(42,14,10,4),(42,14,15,4),(42,15,0,1),(42,15,3,8),(42,15,13,3),(42,15,20,3),(42,16,2,4),(42,16,11,5),(42,16,12,6),(42,16,16,12),(42,16,17,3),(42,16,18,10),(42,16,19,6),(42,17,18,4),(42,17,20,5),(42,18,0,9),(42,19,4,1),(42,19,5,8),(42,19,8,4),(42,19,12,5),(42,20,2,5),(42,20,3,0),(42,20,5,11),(42,20,25,12),(42,21,3,2),(42,21,8,12),(42,21,9,0),(42,21,13,5),(42,21,15,1),(42,22,5,7),(42,22,13,6),(42,23,0,6),(42,23,6,3),(42,23,24,2),(42,23,26,4),(42,24,0,6),(42,24,4,10),(42,24,6,3),(42,24,13,5),(42,24,25,7),(42,25,0,7),(42,25,1,1),(42,25,2,1),(42,25,3,6),(42,25,14,11),(42,25,15,12),(42,25,25,2),(42,26,2,3),(42,26,15,4),(42,26,25,7),(42,27,5,3),(42,27,22,4),(42,27,24,5),(42,27,25,11),(42,28,3,8),(42,28,4,7),(42,29,0,8),(42,29,4,1),(42,29,8,2),(42,29,14,11),(42,29,20,7),(42,30,5,6),(42,30,13,5),(42,30,15,8),(42,31,3,12),(42,31,4,7),(42,31,8,3),(42,31,16,2),(42,31,19,9),(42,31,22,2),(42,31,26,8),(42,32,4,9),(42,32,5,9),(42,32,10,9),(42,32,13,9),(42,32,14,13),(42,32,15,6),(42,33,3,5),(42,33,16,8),(42,33,21,7),(42,33,22,8),(42,34,24,3),(42,35,16,3),(42,35,21,0),(42,35,22,2),(42,35,25,2),(42,35,26,7),(42,36,2,2),(42,36,13,3),(42,36,26,12),(53,0,3,4),(53,0,4,9),(53,0,7,8),(53,0,13,7),(53,0,14,6),(53,0,17,4),(53,0,20,10),(53,0,21,2),(53,1,1,8),(53,1,3,6),(53,1,8,6),(53,1,13,5),(53,2,7,12),(53,2,8,11),(53,2,14,8),(53,2,15,4),(53,3,1,5),(53,3,3,13),(53,4,2,0),(53,4,13,12),(53,6,3,6),(53,6,12,3),(53,7,0,2),(53,7,17,1),(53,8,3,9),(53,9,21,10),(53,10,0,6),(53,10,2,1),(53,10,21,0),(53,10,22,12),(53,11,13,7),(53,11,14,4),(53,11,15,2),(53,12,13,0),(53,12,17,1),(53,12,21,5),(53,12,23,10),(53,13,8,6),(53,13,11,8),(53,13,17,2),(53,13,22,6),(53,13,23,2),(53,14,12,13),(53,14,16,1),(53,14,20,10),(53,15,12,1),(53,15,17,10),(53,15,20,13),(53,15,25,10),(53,15,27,10),(53,16,19,12),(53,16,20,10),(53,16,29,0),(53,18,8,13),(53,18,17,8),(53,19,8,11),(53,19,9,1),(53,19,11,7),(53,19,17,10),(53,19,28,5),(53,20,5,13),(53,20,6,8),(53,20,9,5),(53,20,15,1),(53,20,18,6),(53,20,20,12),(53,21,2,2),(53,21,9,13),(53,21,13,5),(53,21,23,6),(53,21,27,11),(53,22,8,3),(53,22,10,8),(53,22,12,0),(53,22,15,8),(53,22,18,12),(53,23,0,13),(53,23,4,2),(53,23,5,10),(53,23,10,12),(53,23,15,10),(53,23,19,7),(53,23,21,5),(53,23,27,3),(53,23,29,13),(53,24,0,12),(53,24,7,13),(53,24,14,5),(53,24,17,2),(53,24,19,1),(53,24,22,4),(53,25,8,7),(53,25,21,9),(53,25,29,1),(53,26,4,2),(53,26,5,5),(53,26,8,4),(53,26,16,0),(53,26,22,10),(53,27,5,0),(53,27,8,13),(53,27,20,10),(53,27,21,12),(53,27,24,13),(53,28,2,2),(53,28,5,7),(53,28,10,5),(53,28,16,13),(53,28,17,11),(53,28,23,4),(53,28,28,7),(53,28,29,8),(53,29,1,1),(53,29,3,9),(53,29,6,0),(53,29,7,5),(53,29,18,10),(53,30,0,13),(53,30,3,7),(53,30,4,13),(53,30,5,11),(53,30,6,13),(53,30,8,9),(53,30,17,9),(53,30,19,13),(53,31,0,4),(53,31,3,11),(53,31,8,10),(53,31,9,10),(53,31,11,6),(53,31,13,2),(53,31,15,0),(53,31,27,6),(53,31,29,12),(53,32,8,11),(53,32,12,6),(53,32,14,7),(53,32,18,5),(53,32,29,1),(53,33,6,12),(53,33,7,6),(53,33,13,1),(53,33,14,4),(53,34,1,3),(53,34,10,13),(53,34,11,10),(53,34,27,4),(53,35,9,10),(53,35,25,6),(53,36,1,0),(53,36,2,12),(53,36,3,10),(53,36,13,4),(53,36,25,9),(53,36,28,11),(53,37,1,10),(53,37,3,4),(53,37,11,13),(53,37,29,10),(53,38,3,10),(53,38,18,2),(53,38,19,3),(53,38,27,6),(53,39,1,8),(53,39,18,5),(53,39,21,6),(53,40,2,6),(53,40,11,5),(53,40,21,3),(53,40,22,7),(53,40,23,6),(53,40,28,0),(53,41,11,1),(53,41,26,8),(53,42,0,7),(53,42,2,7),(53,42,3,1),(53,42,6,11),(53,42,12,5),(53,42,22,2),(53,42,23,11),(53,42,27,10),(53,42,29,13),(53,43,1,8),(53,43,3,4),(53,43,12,7),(53,43,23,10),(53,43,29,6),(53,44,2,6),(53,44,5,3),(53,44,6,1),(53,44,24,2),(53,44,29,3),(53,45,2,12),(53,45,17,12),(53,45,24,1),(53,45,26,5),(53,45,27,1),(53,46,11,1),(53,46,19,12),(53,46,24,2),(53,46,25,13),(53,46,26,8),(53,47,1,9),(53,47,2,2),(53,47,3,2),(53,47,9,1),(53,47,13,0),(53,47,17,13),(53,47,21,12),(53,47,26,7),(53,48,3,3),(53,48,7,5),(53,48,11,13),(53,48,14,10),(53,48,18,0),(53,48,19,2),(53,48,20,1),(53,48,28,12),(53,49,0,4),(53,49,6,11),(53,49,7,3),(53,49,10,9),(53,49,17,11),(53,49,18,11),(53,49,20,11),(53,49,23,2),(53,49,29,1);
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
INSERT INTO `galaxies` VALUES (1,'2010-10-29 15:02:20','dev');
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
INSERT INTO `solar_systems` VALUES (1,'Resource',1,2,1),(2,'Expansion',1,2,0),(3,'Homeworld',1,1,1),(4,'Expansion',1,1,0);
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
) ENGINE=InnoDB AUTO_INCREMENT=55 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ss_objects`
--

LOCK TABLES `ss_objects` WRITE;
/*!40000 ALTER TABLE `ss_objects` DISABLE KEYS */;
INSERT INTO `ss_objects` VALUES (1,1,0,0,5,75,'Jumpgate',NULL,'',33,0,0,0,0,0,0,0,0,0,0,NULL,0),(2,1,0,0,1,225,'Asteroid',NULL,'',36,0,0,0,2,0,0,1,0,0,1,NULL,0),(3,1,0,0,5,150,'Jumpgate',NULL,'',58,0,0,0,0,0,0,0,0,0,0,NULL,0),(4,1,0,0,3,246,'Asteroid',NULL,'',54,0,0,0,1,0,0,2,0,0,3,NULL,0),(5,1,0,0,1,0,'Asteroid',NULL,'',49,0,0,0,1,0,0,0,0,0,1,NULL,0),(6,1,0,0,5,30,'Jumpgate',NULL,'',56,0,0,0,0,0,0,0,0,0,0,NULL,0),(7,1,0,0,4,198,'Asteroid',NULL,'',35,0,0,0,1,0,0,0,0,0,0,NULL,0),(8,1,0,0,3,44,'Asteroid',NULL,'',34,0,0,0,3,0,0,2,0,0,2,NULL,0),(9,1,32,24,0,90,'Planet',NULL,'P-9',48,0,0,0,0,0,0,0,0,0,0,'2010-10-29 15:02:25',0),(10,1,0,0,1,135,'Asteroid',NULL,'',26,0,0,0,3,0,0,1,0,0,3,NULL,0),(11,1,0,0,3,270,'Asteroid',NULL,'',44,0,0,0,2,0,0,1,0,0,2,NULL,0),(12,1,0,0,3,336,'Asteroid',NULL,'',40,0,0,0,1,0,0,0,0,0,1,NULL,0),(13,1,0,0,0,270,'Asteroid',NULL,'',26,0,0,0,1,0,0,1,0,0,3,NULL,0),(14,2,0,0,4,306,'Asteroid',NULL,'',29,0,0,0,1,0,0,0,0,0,1,NULL,0),(15,2,0,0,1,45,'Asteroid',NULL,'',55,0,0,0,2,0,0,1,0,0,3,NULL,0),(16,2,0,0,4,72,'Asteroid',NULL,'',28,0,0,0,3,0,0,3,0,0,2,NULL,0),(17,2,0,0,4,270,'Asteroid',NULL,'',29,0,0,0,1,0,0,2,0,0,2,NULL,0),(18,2,0,0,5,285,'Jumpgate',NULL,'',38,0,0,0,0,0,0,0,0,0,0,NULL,0),(19,2,0,0,3,246,'Asteroid',NULL,'',29,0,0,0,1,0,0,0,0,0,1,NULL,0),(20,2,0,0,1,180,'Asteroid',NULL,'',52,0,0,0,1,0,0,0,0,0,0,NULL,0),(21,2,0,0,4,108,'Asteroid',NULL,'',51,0,0,0,3,0,0,1,0,0,2,NULL,0),(22,2,0,0,1,90,'Asteroid',NULL,'',29,0,0,0,1,0,0,1,0,0,0,NULL,0),(23,2,29,44,2,30,'Planet',NULL,'P-23',55,1,0,0,0,0,0,0,0,0,0,'2010-10-29 15:02:25',0),(24,2,0,0,3,44,'Asteroid',NULL,'',41,0,0,0,1,0,0,0,0,0,0,NULL,0),(25,2,0,0,4,234,'Asteroid',NULL,'',57,0,0,0,2,0,0,2,0,0,1,NULL,0),(26,2,0,0,1,135,'Asteroid',NULL,'',27,0,0,0,1,0,0,3,0,0,3,NULL,0),(27,2,29,32,0,270,'Planet',NULL,'P-27',50,1,0,0,0,0,0,0,0,0,0,'2010-10-29 15:02:25',0),(28,2,0,0,4,252,'Asteroid',NULL,'',60,0,0,0,1,0,0,1,0,0,1,NULL,0),(29,2,0,0,0,0,'Asteroid',NULL,'',32,0,0,0,3,0,0,1,0,0,2,NULL,0),(30,3,0,0,5,300,'Jumpgate',NULL,'',37,0,0,0,0,0,0,0,0,0,0,NULL,0),(31,3,0,0,2,30,'Asteroid',NULL,'',47,0,0,0,1,0,0,0,0,0,0,NULL,0),(32,3,0,0,0,90,'Asteroid',NULL,'',45,0,0,0,0,0,0,0,0,0,1,NULL,0),(33,3,27,34,2,180,'Planet',1,'P-33',50,0,864,1,3024,1728,2,6048,0,0,604.8,'2010-10-29 15:02:25',0),(34,3,0,0,3,202,'Asteroid',NULL,'',58,0,0,0,1,0,0,1,0,0,1,NULL,0),(35,3,0,0,3,66,'Asteroid',NULL,'',59,0,0,0,0,0,0,0,0,0,0,NULL,0),(36,3,0,0,4,162,'Asteroid',NULL,'',42,0,0,0,0,0,0,1,0,0,0,NULL,0),(37,3,47,33,1,270,'Planet',NULL,'P-37',58,2,0,0,0,0,0,0,0,0,0,'2010-10-29 15:02:25',0),(38,4,0,0,5,75,'Jumpgate',NULL,'',55,0,0,0,0,0,0,0,0,0,0,NULL,0),(39,4,0,0,3,22,'Asteroid',NULL,'',37,0,0,0,3,0,0,2,0,0,2,NULL,0),(40,4,0,0,3,246,'Asteroid',NULL,'',46,0,0,0,1,0,0,1,0,0,1,NULL,0),(41,4,0,0,4,90,'Asteroid',NULL,'',39,0,0,0,1,0,0,1,0,0,1,NULL,0),(42,4,37,27,4,342,'Planet',NULL,'P-42',51,0,0,0,0,0,0,0,0,0,0,'2010-10-29 15:02:25',0),(43,4,0,0,4,108,'Asteroid',NULL,'',44,0,0,0,1,0,0,1,0,0,0,NULL,0),(44,4,0,0,1,0,'Asteroid',NULL,'',29,0,0,0,3,0,0,2,0,0,1,NULL,0),(45,4,0,0,3,112,'Asteroid',NULL,'',46,0,0,0,3,0,0,1,0,0,3,NULL,0),(46,4,0,0,4,198,'Asteroid',NULL,'',43,0,0,0,0,0,0,1,0,0,0,NULL,0),(47,4,0,0,5,135,'Jumpgate',NULL,'',36,0,0,0,0,0,0,0,0,0,0,NULL,0),(48,4,0,0,2,30,'Asteroid',NULL,'',52,0,0,0,1,0,0,0,0,0,1,NULL,0),(49,4,0,0,0,90,'Asteroid',NULL,'',39,0,0,0,0,0,0,1,0,0,1,NULL,0),(50,4,0,0,1,135,'Asteroid',NULL,'',25,0,0,0,3,0,0,1,0,0,3,NULL,0),(51,4,0,0,0,270,'Asteroid',NULL,'',58,0,0,0,1,0,0,1,0,0,0,NULL,0),(52,4,0,0,2,0,'Asteroid',NULL,'',51,0,0,0,2,0,0,2,0,0,1,NULL,0),(53,4,50,30,0,0,'Planet',NULL,'P-53',58,2,0,0,0,0,0,0,0,0,0,'2010-10-29 15:02:25',0),(54,4,0,0,4,144,'Asteroid',NULL,'',42,0,0,0,1,0,0,0,0,0,0,NULL,0);
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
INSERT INTO `tiles` VALUES (6,9,0,4),(3,9,0,17),(3,9,0,19),(6,9,1,4),(3,9,1,15),(3,9,1,16),(3,9,1,17),(3,9,1,18),(3,9,1,19),(6,9,2,4),(6,9,2,8),(3,9,2,16),(3,9,2,17),(6,9,3,3),(6,9,3,4),(4,9,3,7),(6,9,3,8),(3,9,3,17),(4,9,4,4),(4,9,4,5),(4,9,4,7),(6,9,4,8),(6,9,4,9),(6,9,4,10),(4,9,5,4),(4,9,5,5),(4,9,5,6),(4,9,5,7),(3,9,5,9),(6,9,5,10),(6,9,5,11),(6,9,5,12),(4,9,6,5),(2,9,6,6),(3,9,6,8),(3,9,6,9),(3,9,6,10),(3,9,6,11),(6,9,6,12),(6,9,6,13),(4,9,7,5),(3,9,7,8),(3,9,7,9),(2,9,7,11),(3,9,8,9),(3,9,9,0),(3,9,9,7),(3,9,9,9),(3,9,9,10),(3,9,10,0),(3,9,10,1),(3,9,10,2),(3,9,10,7),(3,9,10,8),(10,9,10,9),(3,9,11,0),(8,9,11,2),(1,9,11,6),(3,9,11,8),(5,9,11,19),(5,9,11,20),(5,9,11,21),(3,9,12,0),(3,9,12,1),(3,9,12,8),(5,9,12,19),(3,9,13,0),(3,9,13,1),(3,9,13,5),(3,9,13,6),(3,9,13,7),(3,9,13,8),(5,9,13,19),(5,9,13,20),(3,9,14,0),(6,9,14,3),(6,9,14,4),(13,9,14,5),(3,9,14,7),(12,9,14,8),(5,9,14,17),(5,9,14,18),(5,9,14,19),(5,9,14,20),(5,9,14,21),(5,9,14,22),(5,9,14,23),(6,9,15,2),(6,9,15,3),(6,9,15,4),(5,9,15,17),(5,9,15,18),(5,9,15,19),(5,9,15,20),(5,9,15,21),(5,9,15,22),(9,9,16,2),(5,9,16,16),(5,9,16,17),(5,9,16,18),(5,9,16,19),(5,9,16,20),(5,9,16,21),(5,9,16,22),(5,9,17,17),(5,9,17,18),(5,9,17,19),(5,9,17,20),(5,9,17,21),(5,9,17,22),(5,9,17,23),(5,9,18,17),(5,9,18,18),(5,9,18,19),(5,9,18,21),(5,9,18,22),(5,9,18,23),(3,9,19,16),(3,9,19,17),(5,9,19,19),(5,9,19,22),(5,9,20,0),(5,9,20,1),(8,9,20,2),(13,9,20,5),(4,9,20,7),(4,9,20,8),(4,9,20,9),(4,9,20,10),(4,9,20,11),(4,9,20,12),(3,9,20,15),(3,9,20,16),(3,9,20,17),(3,9,20,18),(5,9,20,19),(5,9,21,0),(5,9,21,1),(4,9,21,8),(4,9,21,9),(4,9,21,11),(4,9,21,12),(3,9,21,16),(3,9,21,17),(3,9,21,18),(3,9,21,19),(5,9,22,0),(12,9,22,7),(4,9,22,17),(4,9,22,18),(5,9,23,0),(9,9,23,1),(4,9,23,18),(4,9,23,19),(4,9,23,21),(5,9,24,0),(4,9,24,19),(4,9,24,20),(4,9,24,21),(5,9,25,0),(4,9,25,19),(5,9,26,0),(4,9,26,19),(5,9,27,0),(5,9,27,1),(5,9,27,2),(5,9,27,3),(6,9,27,13),(6,9,27,14),(6,9,27,15),(6,9,27,16),(5,9,28,0),(11,9,28,1),(11,9,28,8),(6,9,28,15),(4,9,29,20),(4,9,29,21),(4,9,29,22),(4,9,29,23),(4,9,30,20),(4,9,30,21),(4,9,30,22),(4,9,30,23),(4,9,31,20),(4,9,31,23),(5,23,0,0),(5,23,0,1),(5,23,0,2),(5,23,0,3),(3,23,0,4),(3,23,0,5),(3,23,0,6),(3,23,0,7),(3,23,0,8),(12,23,0,26),(3,23,0,35),(3,23,0,36),(3,23,0,37),(3,23,0,38),(3,23,0,39),(9,23,0,41),(5,23,1,0),(5,23,1,1),(5,23,1,2),(5,23,1,3),(5,23,1,4),(3,23,1,5),(3,23,1,6),(3,23,1,7),(3,23,1,8),(3,23,1,9),(6,23,1,15),(8,23,1,33),(3,23,1,36),(3,23,1,37),(3,23,1,38),(3,23,1,39),(5,23,2,0),(5,23,2,2),(5,23,2,3),(3,23,2,4),(3,23,2,5),(3,23,2,6),(3,23,2,7),(3,23,2,8),(3,23,2,9),(6,23,2,10),(6,23,2,14),(6,23,2,15),(3,23,2,36),(3,23,2,37),(3,23,2,38),(3,23,2,39),(3,23,2,40),(5,23,3,0),(5,23,3,1),(5,23,3,2),(3,23,3,3),(3,23,3,4),(3,23,3,6),(3,23,3,7),(3,23,3,8),(3,23,3,9),(6,23,3,10),(6,23,3,13),(6,23,3,14),(6,23,3,15),(6,23,3,16),(6,23,3,17),(3,23,3,36),(3,23,3,37),(3,23,3,38),(5,23,4,0),(5,23,4,1),(5,23,4,2),(5,23,4,3),(3,23,4,5),(3,23,4,6),(3,23,4,7),(3,23,4,8),(3,23,4,9),(6,23,4,10),(6,23,4,11),(6,23,4,12),(6,23,4,13),(6,23,4,14),(6,23,4,15),(3,23,4,36),(3,23,4,37),(5,23,5,0),(5,23,5,1),(5,23,5,2),(5,23,5,3),(3,23,5,4),(3,23,5,5),(3,23,5,6),(3,23,5,7),(3,23,5,9),(6,23,5,10),(6,23,5,12),(6,23,5,13),(6,23,5,14),(3,23,5,37),(3,23,5,38),(3,23,5,39),(5,23,6,0),(5,23,6,1),(5,23,6,3),(3,23,6,4),(3,23,6,5),(3,23,6,6),(3,23,6,7),(3,23,6,8),(6,23,6,10),(6,23,6,12),(6,23,6,13),(6,23,6,14),(6,23,6,15),(6,23,6,16),(13,23,6,36),(3,23,7,4),(3,23,7,5),(3,23,7,6),(6,23,7,7),(6,23,7,9),(6,23,7,10),(6,23,7,12),(6,23,7,13),(6,23,7,14),(6,23,7,19),(1,23,7,23),(3,23,8,4),(3,23,8,5),(3,23,8,6),(6,23,8,7),(6,23,8,8),(6,23,8,9),(6,23,8,10),(6,23,8,11),(6,23,8,12),(6,23,8,14),(6,23,8,18),(6,23,8,19),(2,23,8,33),(3,23,9,5),(6,23,9,6),(6,23,9,7),(6,23,9,8),(6,23,9,9),(6,23,9,10),(6,23,9,11),(6,23,9,19),(6,23,9,20),(6,23,9,22),(6,23,10,8),(6,23,10,9),(6,23,10,10),(6,23,10,11),(6,23,10,15),(6,23,10,16),(6,23,10,17),(6,23,10,18),(6,23,10,19),(6,23,10,20),(6,23,10,21),(6,23,10,22),(6,23,11,9),(6,23,11,11),(6,23,11,12),(6,23,11,16),(6,23,11,17),(6,23,11,19),(6,23,11,20),(6,23,11,22),(6,23,12,20),(6,23,12,21),(6,23,12,22),(3,23,12,24),(3,23,12,27),(3,23,12,28),(3,23,12,29),(3,23,12,30),(11,23,12,32),(4,23,13,9),(4,23,13,12),(6,23,13,20),(6,23,13,21),(6,23,13,22),(6,23,13,23),(3,23,13,24),(3,23,13,25),(3,23,13,26),(3,23,13,27),(3,23,13,28),(4,23,14,9),(4,23,14,10),(4,23,14,11),(4,23,14,12),(4,23,14,18),(4,23,14,20),(4,23,14,21),(3,23,14,22),(3,23,14,23),(3,23,14,24),(3,23,14,25),(3,23,14,26),(3,23,14,28),(4,23,15,7),(4,23,15,8),(4,23,15,10),(4,23,15,12),(4,23,15,14),(4,23,15,18),(4,23,15,19),(4,23,15,20),(3,23,15,21),(3,23,15,22),(3,23,15,23),(3,23,15,24),(3,23,15,25),(3,23,15,26),(9,23,15,41),(4,23,16,6),(4,23,16,7),(4,23,16,8),(4,23,16,9),(4,23,16,10),(4,23,16,11),(4,23,16,12),(4,23,16,13),(4,23,16,14),(4,23,16,19),(4,23,16,20),(4,23,16,21),(4,23,16,22),(4,23,16,23),(4,23,16,24),(12,23,16,26),(4,23,17,6),(4,23,17,7),(4,23,17,9),(4,23,17,10),(4,23,17,11),(4,23,17,12),(4,23,17,13),(4,23,17,17),(4,23,17,18),(4,23,17,20),(4,23,17,21),(4,23,17,22),(5,23,18,4),(4,23,18,6),(4,23,18,7),(4,23,18,8),(4,23,18,9),(4,23,18,10),(4,23,18,11),(4,23,18,12),(4,23,18,13),(4,23,18,14),(4,23,18,15),(4,23,18,18),(4,23,18,21),(4,23,18,22),(4,23,18,23),(4,23,18,24),(4,23,18,25),(5,23,18,34),(5,23,18,35),(5,23,19,4),(4,23,19,5),(4,23,19,6),(4,23,19,8),(4,23,19,9),(4,23,19,10),(4,23,19,11),(4,23,19,12),(4,23,19,13),(4,23,19,14),(4,23,19,18),(4,23,19,19),(4,23,19,20),(4,23,19,21),(4,23,19,22),(4,23,19,23),(4,23,19,25),(5,23,19,32),(5,23,19,33),(5,23,19,34),(5,23,20,4),(5,23,20,5),(4,23,20,6),(4,23,20,7),(4,23,20,8),(4,23,20,9),(5,23,20,10),(5,23,20,11),(4,23,20,12),(4,23,20,13),(4,23,20,14),(4,23,20,15),(4,23,20,16),(4,23,20,17),(4,23,20,18),(4,23,20,20),(4,23,20,21),(4,23,20,22),(4,23,20,23),(4,23,20,24),(4,23,20,25),(5,23,20,33),(5,23,21,1),(5,23,21,2),(5,23,21,3),(5,23,21,4),(5,23,21,5),(5,23,21,6),(5,23,21,7),(4,23,21,8),(5,23,21,9),(5,23,21,10),(5,23,21,11),(4,23,21,12),(4,23,21,13),(4,23,21,16),(4,23,21,17),(4,23,21,18),(4,23,21,19),(4,23,21,20),(4,23,21,21),(4,23,21,22),(4,23,21,25),(5,23,21,32),(5,23,21,33),(5,23,21,35),(5,23,21,36),(5,23,21,37),(1,23,21,41),(5,23,22,3),(5,23,22,4),(5,23,22,5),(5,23,22,6),(5,23,22,7),(4,23,22,8),(4,23,22,9),(5,23,22,10),(5,23,22,11),(5,23,22,12),(4,23,22,13),(4,23,22,19),(4,23,22,20),(4,23,22,21),(4,23,22,22),(4,23,22,23),(4,23,22,24),(4,23,22,25),(10,23,22,26),(5,23,22,32),(5,23,22,33),(5,23,22,34),(5,23,22,35),(3,23,23,2),(5,23,23,3),(5,23,23,4),(5,23,23,5),(5,23,23,6),(5,23,23,7),(5,23,23,8),(4,23,23,9),(4,23,23,10),(5,23,23,11),(4,23,23,12),(4,23,23,13),(4,23,23,14),(4,23,23,21),(4,23,23,22),(4,23,23,23),(4,23,23,24),(4,23,23,25),(13,23,23,30),(5,23,23,32),(5,23,23,33),(5,23,23,34),(3,23,24,0),(3,23,24,1),(3,23,24,2),(3,23,24,3),(5,23,24,4),(5,23,24,5),(5,23,24,6),(4,23,24,10),(4,23,24,11),(4,23,24,12),(4,23,24,13),(4,23,24,14),(4,23,24,21),(4,23,24,22),(4,23,24,23),(4,23,24,24),(4,23,24,25),(5,23,24,32),(5,23,24,33),(3,23,25,1),(3,23,25,2),(3,23,25,3),(5,23,25,6),(4,23,25,20),(4,23,25,21),(4,23,25,22),(4,23,25,23),(4,23,25,24),(5,23,25,32),(5,23,25,33),(5,23,25,34),(3,23,26,1),(3,23,26,2),(3,23,26,3),(3,23,26,4),(4,23,26,21),(14,23,26,26),(5,23,26,32),(14,23,26,34),(3,23,27,1),(3,23,27,2),(3,23,27,3),(3,23,27,4),(3,23,27,5),(5,23,27,32),(3,23,28,2),(3,23,28,3),(3,23,28,4),(3,23,28,5),(3,23,28,6),(5,23,28,32),(4,27,0,0),(4,27,0,1),(4,27,0,2),(4,27,0,3),(4,27,0,4),(4,27,0,5),(4,27,0,6),(4,27,0,7),(3,27,0,17),(3,27,0,18),(3,27,0,19),(3,27,0,20),(3,27,0,22),(3,27,0,23),(3,27,0,24),(3,27,0,26),(3,27,0,27),(3,27,0,28),(4,27,1,0),(4,27,1,1),(4,27,1,3),(4,27,1,7),(3,27,1,18),(3,27,1,19),(3,27,1,20),(3,27,1,21),(3,27,1,22),(3,27,1,23),(3,27,1,24),(3,27,1,25),(3,27,1,26),(3,27,1,27),(3,27,1,28),(3,27,1,29),(3,27,1,30),(4,27,2,0),(4,27,2,1),(4,27,2,2),(4,27,2,3),(4,27,2,4),(4,27,2,5),(3,27,2,16),(3,27,2,17),(3,27,2,18),(3,27,2,19),(3,27,2,20),(3,27,2,22),(3,27,2,23),(3,27,2,24),(3,27,2,26),(3,27,2,27),(3,27,2,28),(3,27,2,29),(4,27,3,1),(4,27,3,2),(4,27,3,3),(4,27,3,4),(4,27,3,5),(4,27,3,6),(3,27,3,18),(3,27,3,19),(3,27,3,20),(3,27,3,21),(3,27,3,22),(3,27,3,23),(3,27,3,24),(3,27,3,25),(3,27,3,27),(3,27,3,28),(4,27,4,3),(4,27,4,6),(5,27,4,7),(5,27,4,8),(5,27,4,9),(3,27,4,16),(3,27,4,17),(3,27,4,18),(3,27,4,19),(3,27,4,22),(3,27,4,23),(3,27,4,24),(3,27,4,25),(6,27,4,31),(6,27,5,5),(6,27,5,6),(5,27,5,7),(5,27,5,8),(5,27,5,9),(3,27,5,16),(3,27,5,17),(3,27,5,18),(3,27,5,19),(3,27,5,20),(3,27,5,21),(3,27,5,22),(3,27,5,24),(3,27,5,25),(3,27,5,26),(6,27,5,31),(6,27,6,5),(5,27,6,7),(5,27,6,8),(5,27,6,9),(3,27,6,16),(3,27,6,19),(4,27,6,20),(3,27,6,22),(4,27,6,24),(4,27,6,25),(4,27,6,26),(6,27,6,30),(6,27,6,31),(6,27,7,3),(6,27,7,4),(6,27,7,5),(5,27,7,9),(3,27,7,16),(4,27,7,20),(4,27,7,21),(3,27,7,22),(4,27,7,23),(4,27,7,24),(4,27,7,25),(6,27,7,31),(6,27,8,2),(6,27,8,3),(6,27,8,4),(6,27,8,5),(6,27,8,6),(4,27,8,19),(4,27,8,20),(4,27,8,21),(4,27,8,22),(4,27,8,23),(4,27,8,24),(4,27,8,25),(4,27,8,26),(6,27,8,31),(4,27,9,0),(4,27,9,1),(4,27,9,2),(6,27,9,5),(6,27,9,6),(6,27,9,12),(6,27,9,13),(4,27,9,20),(4,27,9,22),(4,27,9,23),(4,27,9,25),(6,27,9,28),(6,27,9,29),(6,27,9,30),(6,27,9,31),(4,27,10,0),(4,27,10,1),(4,27,10,2),(4,27,10,3),(3,27,10,5),(6,27,10,6),(3,27,10,7),(3,27,10,9),(6,27,10,11),(6,27,10,12),(4,27,10,22),(4,27,10,23),(6,27,10,29),(6,27,10,30),(4,27,11,0),(4,27,11,1),(4,27,11,2),(4,27,11,3),(3,27,11,4),(3,27,11,5),(3,27,11,6),(3,27,11,7),(3,27,11,8),(3,27,11,9),(6,27,11,10),(6,27,11,11),(6,27,11,12),(6,27,11,13),(6,27,11,14),(5,27,11,16),(4,27,11,21),(4,27,11,22),(4,27,11,23),(6,27,11,30),(6,27,11,31),(4,27,12,1),(4,27,12,2),(3,27,12,3),(3,27,12,4),(3,27,12,5),(3,27,12,6),(3,27,12,7),(3,27,12,8),(3,27,12,9),(6,27,12,11),(6,27,12,12),(6,27,12,13),(5,27,12,16),(5,27,12,18),(4,27,13,1),(4,27,13,2),(4,27,13,3),(3,27,13,4),(3,27,13,5),(3,27,13,6),(3,27,13,7),(3,27,13,8),(6,27,13,11),(6,27,13,12),(5,27,13,14),(5,27,13,15),(5,27,13,16),(5,27,13,17),(5,27,13,18),(5,27,13,19),(4,27,14,0),(4,27,14,1),(4,27,14,2),(4,27,14,3),(3,27,14,4),(3,27,14,5),(3,27,14,6),(3,27,14,7),(3,27,14,8),(3,27,14,9),(3,27,14,10),(5,27,14,15),(4,27,15,3),(4,27,15,4),(3,27,15,5),(3,27,15,7),(3,27,15,8),(4,27,16,3),(4,27,16,4),(4,27,16,5),(4,27,16,6),(3,27,16,8),(3,27,16,9),(11,27,16,20),(1,27,17,6),(3,27,17,9),(5,27,17,10),(5,27,18,10),(5,27,19,10),(5,27,19,11),(5,27,19,12),(2,27,19,17),(14,27,20,5),(5,27,20,9),(5,27,20,10),(5,27,20,11),(5,27,20,12),(5,27,20,13),(10,27,21,9),(11,27,22,14),(2,27,23,2),(12,27,23,22),(1,27,24,6),(5,27,25,4),(5,27,25,5),(10,27,25,9),(5,27,26,5),(8,27,26,13),(8,27,26,16),(14,27,26,28),(5,27,27,5),(5,27,27,6),(5,27,27,8),(5,27,28,5),(5,27,28,6),(5,27,28,7),(5,27,28,8),(5,33,0,0),(5,33,0,1),(5,33,0,2),(5,33,0,3),(5,33,0,15),(5,33,0,16),(5,33,0,17),(5,33,0,18),(5,33,0,19),(5,33,0,20),(5,33,0,21),(5,33,0,22),(5,33,0,23),(5,33,0,24),(5,33,0,25),(5,33,0,26),(5,33,1,0),(5,33,1,1),(5,33,1,2),(5,33,1,3),(4,33,1,7),(4,33,1,8),(4,33,1,9),(4,33,1,10),(13,33,1,12),(5,33,1,16),(5,33,1,17),(5,33,1,18),(11,33,1,20),(5,33,1,26),(5,33,2,0),(5,33,2,1),(5,33,2,2),(4,33,2,6),(4,33,2,7),(4,33,2,8),(4,33,2,9),(5,33,2,14),(5,33,2,15),(5,33,2,16),(5,33,2,17),(5,33,2,19),(5,33,2,26),(5,33,2,27),(5,33,3,0),(5,33,3,1),(4,33,3,5),(4,33,3,6),(4,33,3,7),(4,33,3,8),(4,33,3,9),(5,33,3,15),(5,33,3,16),(5,33,3,17),(5,33,3,18),(5,33,3,19),(5,33,4,1),(5,33,4,2),(5,33,4,3),(4,33,4,6),(4,33,4,7),(4,33,4,8),(6,33,4,11),(5,33,4,16),(5,33,4,17),(5,33,5,2),(5,33,5,3),(4,33,5,5),(4,33,5,6),(4,33,5,7),(6,33,5,10),(6,33,5,11),(6,33,5,20),(6,33,5,21),(6,33,6,10),(6,33,6,11),(6,33,6,18),(6,33,6,20),(6,33,6,21),(6,33,6,22),(12,33,7,1),(6,33,7,11),(6,33,7,19),(6,33,7,20),(6,33,8,11),(6,33,8,12),(6,33,8,13),(6,33,8,19),(6,33,8,20),(6,33,9,12),(6,33,9,13),(6,33,9,14),(6,33,9,20),(3,33,9,25),(3,33,9,26),(6,33,10,12),(6,33,10,13),(8,33,10,22),(3,33,10,25),(3,33,10,26),(3,33,10,27),(3,33,10,29),(3,33,11,26),(3,33,11,27),(3,33,11,28),(3,33,11,29),(3,33,12,27),(3,33,12,28),(3,33,12,29),(3,33,13,25),(3,33,13,27),(3,33,13,28),(3,33,13,29),(3,33,14,25),(3,33,14,26),(3,33,14,27),(3,33,14,28),(3,33,14,29),(3,33,15,25),(3,33,15,26),(3,33,15,27),(3,33,15,28),(3,33,15,29),(5,33,16,0),(3,33,16,26),(3,33,16,27),(3,33,16,28),(3,33,16,29),(5,33,17,0),(5,33,17,1),(3,33,17,25),(3,33,17,26),(3,33,17,27),(3,33,17,28),(3,33,17,29),(5,33,18,0),(5,33,18,1),(3,33,18,24),(3,33,18,25),(3,33,18,26),(3,33,18,27),(3,33,18,28),(3,33,18,29),(5,33,19,0),(3,33,19,24),(3,33,19,25),(3,33,19,26),(3,33,19,27),(3,33,19,28),(3,33,19,29),(5,33,20,0),(5,33,20,1),(3,33,20,24),(3,33,20,25),(3,33,20,26),(3,33,20,27),(3,33,20,28),(3,33,20,29),(5,33,21,0),(3,33,21,25),(3,33,21,26),(3,33,21,27),(3,33,21,28),(3,33,21,29),(5,33,22,0),(14,33,22,1),(3,33,22,27),(3,33,22,28),(3,33,22,29),(5,33,23,0),(4,33,23,20),(3,33,23,26),(3,33,23,27),(3,33,23,28),(3,33,23,29),(5,33,24,0),(4,33,24,18),(4,33,24,19),(4,33,24,20),(4,33,24,21),(4,33,24,22),(3,33,24,27),(3,33,24,28),(5,33,25,0),(5,33,25,2),(4,33,25,19),(4,33,25,20),(4,33,25,21),(4,33,25,22),(5,33,26,0),(5,33,26,1),(5,33,26,2),(6,33,26,6),(6,33,26,7),(2,33,26,16),(4,33,26,19),(4,33,26,20),(4,33,26,21),(4,33,26,22),(4,33,26,23),(6,33,27,5),(6,33,27,6),(5,33,27,7),(5,33,27,8),(5,33,27,11),(5,33,27,12),(4,33,27,19),(4,33,27,20),(4,33,27,21),(4,33,27,22),(4,33,27,23),(4,33,27,24),(5,33,28,1),(5,33,28,2),(5,33,28,3),(5,33,28,4),(6,33,28,5),(6,33,28,6),(5,33,28,7),(5,33,28,8),(5,33,28,10),(5,33,28,11),(5,33,28,12),(5,33,28,13),(5,33,28,14),(4,33,28,19),(4,33,28,20),(4,33,28,21),(4,33,28,22),(4,33,28,23),(5,33,29,2),(6,33,29,3),(6,33,29,4),(6,33,29,5),(6,33,29,6),(5,33,29,7),(5,33,29,8),(5,33,29,9),(5,33,29,10),(5,33,29,11),(5,33,29,12),(5,33,29,13),(4,33,29,18),(4,33,29,19),(4,33,29,20),(4,33,29,21),(4,33,29,22),(5,37,0,0),(5,37,0,1),(5,37,0,2),(3,37,0,10),(3,37,0,11),(3,37,0,12),(3,37,0,13),(3,37,0,14),(3,37,0,15),(3,37,0,16),(3,37,0,17),(3,37,0,18),(3,37,0,19),(6,37,0,22),(6,37,0,23),(5,37,1,0),(5,37,1,1),(5,37,1,2),(3,37,1,10),(3,37,1,11),(3,37,1,12),(3,37,1,13),(3,37,1,14),(3,37,1,15),(3,37,1,16),(3,37,1,17),(3,37,1,18),(6,37,1,23),(6,37,1,24),(5,37,2,0),(5,37,2,1),(5,37,2,2),(5,37,2,3),(6,37,2,10),(6,37,2,11),(3,37,2,12),(3,37,2,13),(3,37,2,14),(3,37,2,15),(3,37,2,16),(6,37,2,21),(6,37,2,22),(6,37,2,23),(6,37,2,24),(6,37,2,25),(4,37,2,28),(5,37,3,0),(5,37,3,1),(5,37,3,3),(5,37,3,4),(3,37,3,5),(6,37,3,8),(6,37,3,9),(6,37,3,10),(6,37,3,11),(3,37,3,12),(3,37,3,13),(3,37,3,14),(3,37,3,15),(6,37,3,21),(6,37,3,22),(6,37,3,24),(6,37,3,25),(4,37,3,28),(4,37,3,29),(4,37,3,31),(5,37,4,0),(3,37,4,1),(3,37,4,4),(3,37,4,5),(3,37,4,7),(3,37,4,8),(6,37,4,10),(6,37,4,11),(6,37,4,12),(6,37,4,13),(3,37,4,14),(3,37,4,15),(3,37,4,16),(3,37,4,17),(6,37,4,21),(6,37,4,22),(6,37,4,23),(6,37,4,24),(4,37,4,29),(4,37,4,30),(4,37,4,31),(5,37,5,0),(3,37,5,1),(3,37,5,2),(3,37,5,4),(3,37,5,5),(3,37,5,6),(3,37,5,7),(3,37,5,8),(6,37,5,9),(6,37,5,10),(6,37,5,11),(6,37,5,12),(6,37,5,22),(6,37,5,23),(6,37,5,24),(6,37,5,25),(4,37,5,26),(4,37,5,27),(4,37,5,28),(4,37,5,29),(4,37,5,30),(4,37,5,31),(4,37,5,32),(5,37,6,0),(5,37,6,1),(3,37,6,2),(3,37,6,3),(3,37,6,4),(3,37,6,5),(3,37,6,6),(6,37,6,7),(6,37,6,8),(6,37,6,9),(6,37,6,10),(6,37,6,11),(6,37,6,12),(6,37,6,23),(6,37,6,24),(4,37,6,26),(4,37,6,28),(4,37,6,30),(4,37,6,31),(4,37,6,32),(5,37,7,0),(3,37,7,1),(3,37,7,2),(3,37,7,3),(3,37,7,4),(3,37,7,5),(3,37,7,6),(3,37,7,7),(6,37,7,8),(6,37,7,9),(6,37,7,11),(4,37,7,28),(4,37,7,29),(4,37,7,30),(4,37,7,31),(4,37,7,32),(3,37,8,2),(3,37,8,4),(3,37,8,5),(3,37,8,6),(4,37,8,26),(4,37,8,27),(4,37,8,28),(4,37,8,29),(4,37,8,30),(4,37,8,31),(4,37,8,32),(3,37,9,3),(3,37,9,4),(3,37,9,6),(4,37,9,29),(4,37,9,30),(4,37,9,31),(4,37,9,32),(4,37,10,28),(4,37,10,29),(4,37,10,30),(4,37,10,31),(4,37,10,32),(6,37,11,13),(6,37,11,14),(6,37,11,16),(4,37,11,27),(4,37,11,28),(4,37,11,29),(4,37,11,30),(4,37,11,31),(4,37,11,32),(3,37,12,1),(6,37,12,13),(6,37,12,14),(6,37,12,15),(6,37,12,16),(6,37,12,17),(6,37,12,18),(3,37,12,27),(4,37,12,29),(4,37,12,30),(4,37,12,31),(3,37,13,0),(3,37,13,1),(6,37,13,14),(6,37,13,15),(6,37,13,16),(6,37,13,17),(6,37,13,18),(6,37,13,19),(3,37,13,26),(3,37,13,27),(4,37,13,28),(4,37,13,29),(3,37,14,0),(3,37,14,1),(3,37,14,2),(3,37,14,3),(3,37,14,4),(3,37,14,5),(6,37,14,13),(6,37,14,14),(6,37,14,15),(6,37,14,16),(3,37,14,25),(3,37,14,26),(3,37,14,27),(4,37,14,28),(3,37,14,29),(3,37,14,31),(3,37,15,0),(3,37,15,1),(3,37,15,2),(6,37,15,13),(6,37,15,14),(6,37,15,15),(3,37,15,24),(3,37,15,25),(3,37,15,26),(3,37,15,27),(3,37,15,28),(3,37,15,29),(3,37,15,30),(3,37,15,31),(3,37,16,0),(3,37,16,1),(3,37,16,2),(4,37,16,5),(4,37,16,6),(6,37,16,14),(3,37,16,24),(3,37,16,25),(3,37,16,26),(3,37,16,27),(3,37,16,28),(3,37,16,29),(3,37,16,30),(3,37,16,31),(3,37,17,0),(3,37,17,1),(3,37,17,3),(3,37,17,4),(3,37,17,5),(4,37,17,6),(4,37,17,7),(4,37,17,8),(4,37,17,10),(4,37,17,11),(3,37,17,27),(3,37,17,28),(3,37,17,29),(3,37,17,30),(3,37,18,0),(3,37,18,1),(3,37,18,2),(3,37,18,3),(3,37,18,4),(4,37,18,6),(4,37,18,7),(4,37,18,8),(4,37,18,9),(4,37,18,10),(4,37,18,11),(3,37,18,27),(3,37,18,28),(3,37,18,29),(3,37,19,0),(3,37,19,1),(3,37,19,2),(3,37,19,3),(3,37,19,4),(4,37,19,6),(4,37,19,7),(4,37,19,8),(4,37,19,9),(4,37,19,10),(4,37,19,11),(3,37,19,29),(4,37,20,0),(3,37,20,1),(3,37,20,2),(4,37,20,7),(4,37,20,8),(4,37,20,9),(4,37,20,10),(4,37,20,11),(4,37,20,13),(4,37,20,14),(4,37,21,0),(4,37,21,3),(4,37,21,4),(4,37,21,8),(4,37,21,9),(4,37,21,10),(4,37,21,11),(4,37,21,12),(4,37,21,13),(4,37,21,14),(4,37,21,15),(4,37,21,16),(4,37,22,0),(4,37,22,1),(4,37,22,2),(4,37,22,3),(4,37,22,4),(4,37,22,5),(4,37,22,6),(4,37,22,7),(4,37,22,8),(4,37,22,9),(4,37,22,10),(4,37,22,11),(4,37,22,12),(4,37,22,13),(4,37,22,14),(4,37,22,15),(4,37,23,0),(4,37,23,1),(4,37,23,2),(4,37,23,3),(4,37,23,4),(4,37,23,6),(4,37,23,7),(4,37,23,10),(4,37,23,14),(4,37,24,0),(4,37,24,1),(4,37,24,2),(4,37,24,3),(4,37,24,4),(4,37,24,5),(4,37,24,6),(4,37,24,7),(4,37,24,9),(4,37,24,10),(4,37,24,11),(4,37,24,14),(4,37,25,0),(4,37,25,1),(4,37,25,2),(4,37,25,3),(4,37,25,4),(4,37,25,5),(4,37,25,7),(4,37,25,10),(4,37,25,11),(4,37,26,0),(4,37,26,1),(4,37,26,2),(4,37,26,3),(4,37,26,4),(4,37,26,5),(4,37,26,7),(4,37,26,10),(4,37,27,0),(4,37,27,1),(4,37,27,2),(4,37,27,3),(4,37,27,4),(4,37,27,5),(4,37,28,0),(4,37,28,1),(4,37,28,2),(4,37,28,3),(4,37,29,1),(2,37,30,3),(5,37,30,16),(5,37,30,17),(5,37,31,14),(5,37,31,16),(1,37,32,7),(5,37,32,14),(5,37,32,15),(5,37,32,16),(5,37,32,17),(5,37,33,14),(5,37,33,15),(5,37,33,16),(5,37,33,17),(1,37,34,1),(5,37,34,13),(5,37,34,14),(5,37,34,16),(5,37,34,17),(5,37,35,12),(5,37,35,13),(5,37,35,14),(5,37,35,15),(5,37,35,16),(5,37,35,17),(13,37,35,21),(14,37,35,24),(8,37,35,28),(5,37,36,10),(5,37,36,11),(5,37,36,12),(5,37,36,13),(5,37,36,14),(5,37,36,15),(6,37,37,3),(6,37,37,4),(6,37,37,5),(5,37,37,8),(5,37,37,9),(5,37,37,10),(5,37,37,11),(5,37,37,12),(5,37,37,13),(6,37,38,1),(6,37,38,2),(6,37,38,3),(6,37,38,4),(6,37,38,5),(6,37,38,6),(6,37,38,7),(6,37,38,8),(6,37,38,9),(5,37,38,10),(5,37,38,11),(5,37,38,12),(6,37,39,3),(6,37,39,4),(6,37,39,5),(6,37,39,7),(6,37,39,9),(5,37,39,11),(5,37,39,12),(5,37,39,14),(6,37,40,3),(6,37,40,4),(6,37,40,5),(5,37,40,9),(5,37,40,10),(5,37,40,11),(5,37,40,12),(5,37,40,13),(5,37,40,14),(5,37,40,15),(6,37,41,4),(6,37,41,5),(5,37,41,8),(5,37,41,9),(5,37,41,10),(5,37,41,11),(5,37,41,12),(6,37,42,4),(5,37,42,9),(5,37,42,10),(11,37,42,11),(5,37,43,9),(5,37,43,10),(11,37,43,23),(14,37,43,29),(5,37,44,9),(10,42,0,3),(14,42,0,7),(3,42,0,13),(3,42,0,14),(3,42,0,15),(3,42,0,16),(3,42,0,17),(3,42,0,18),(5,42,1,0),(3,42,1,13),(3,42,1,14),(3,42,1,15),(3,42,1,16),(3,42,1,17),(1,42,1,18),(5,42,2,0),(3,42,2,12),(3,42,2,13),(3,42,2,14),(6,42,2,16),(3,42,2,17),(5,42,3,0),(6,42,3,2),(12,42,3,7),(6,42,3,16),(3,42,3,17),(6,42,3,18),(5,42,4,0),(6,42,4,1),(6,42,4,2),(6,42,4,13),(6,42,4,14),(6,42,4,15),(6,42,4,16),(6,42,4,17),(6,42,4,18),(5,42,5,0),(6,42,5,1),(6,42,5,2),(10,42,5,13),(6,42,5,18),(5,42,6,0),(5,42,6,1),(6,42,6,2),(6,42,6,3),(2,42,6,4),(3,42,6,20),(3,42,6,21),(3,42,6,22),(5,42,7,0),(5,42,7,1),(6,42,7,2),(6,42,7,3),(3,42,7,21),(3,42,7,22),(5,42,8,0),(6,42,8,3),(3,42,8,20),(3,42,8,21),(5,42,9,19),(3,42,9,20),(3,42,9,21),(3,42,9,22),(5,42,10,18),(5,42,10,19),(3,42,10,20),(3,42,10,21),(3,42,10,22),(3,42,10,23),(3,42,11,2),(3,42,11,3),(3,42,11,6),(5,42,11,19),(5,42,11,20),(3,42,11,21),(3,42,11,22),(3,42,12,2),(3,42,12,3),(3,42,12,4),(3,42,12,5),(3,42,12,6),(3,42,12,7),(5,42,12,20),(3,42,13,4),(3,42,13,5),(3,42,13,6),(5,42,13,19),(5,42,13,20),(3,42,13,24),(3,42,14,4),(5,42,14,19),(5,42,14,20),(3,42,14,24),(3,42,14,26),(3,42,15,4),(3,42,15,5),(3,42,15,8),(3,42,15,9),(5,42,15,10),(3,42,15,23),(3,42,15,24),(3,42,15,25),(3,42,15,26),(3,42,16,4),(3,42,16,6),(3,42,16,7),(3,42,16,8),(5,42,16,10),(3,42,16,21),(3,42,16,22),(3,42,16,23),(3,42,16,24),(3,42,16,25),(3,42,16,26),(3,42,17,4),(3,42,17,5),(3,42,17,6),(3,42,17,7),(3,42,17,8),(5,42,17,9),(5,42,17,10),(5,42,17,11),(5,42,17,12),(5,42,17,13),(4,42,17,21),(4,42,17,22),(3,42,17,24),(3,42,17,26),(3,42,18,7),(3,42,18,8),(5,42,18,9),(5,42,18,10),(4,42,18,20),(4,42,18,21),(4,42,18,22),(4,42,18,23),(3,42,18,26),(3,42,19,7),(5,42,19,10),(4,42,19,16),(4,42,19,17),(4,42,19,18),(4,42,19,19),(4,42,19,20),(4,42,19,21),(4,42,19,22),(4,42,19,23),(3,42,20,7),(3,42,20,8),(4,42,20,16),(4,42,20,17),(4,42,20,19),(4,42,20,20),(4,42,20,21),(4,42,20,22),(3,42,21,7),(4,42,21,17),(4,42,21,18),(4,42,21,19),(4,42,21,20),(12,42,22,7),(4,42,22,16),(4,42,22,17),(4,42,22,22),(4,42,22,23),(4,42,22,24),(4,42,22,25),(4,42,23,16),(4,42,23,17),(4,42,23,23),(4,42,24,20),(4,42,24,21),(4,42,24,22),(4,42,24,23),(6,42,25,19),(6,42,25,20),(6,42,25,21),(4,42,25,22),(4,42,25,23),(4,42,25,24),(6,42,26,17),(6,42,26,18),(6,42,26,19),(6,42,26,20),(6,42,26,21),(4,42,26,22),(4,42,26,23),(6,42,27,16),(6,42,27,17),(6,42,27,18),(6,42,27,19),(6,42,27,20),(6,42,27,21),(6,42,28,17),(6,42,28,18),(6,42,28,19),(6,42,28,20),(6,42,28,21),(14,42,29,9),(4,42,29,17),(6,42,29,18),(4,42,29,19),(4,42,30,16),(4,42,30,17),(4,42,30,18),(4,42,30,19),(4,42,30,20),(5,42,31,0),(4,42,31,17),(5,42,32,0),(5,42,32,1),(9,42,32,7),(4,42,32,17),(4,42,32,18),(4,42,32,19),(5,42,33,0),(5,42,33,2),(4,42,33,5),(4,42,33,6),(8,42,33,10),(4,42,33,17),(6,42,33,18),(6,42,33,20),(5,42,34,0),(5,42,34,1),(5,42,34,2),(5,42,34,3),(4,42,34,4),(4,42,34,5),(4,42,34,6),(4,42,34,17),(6,42,34,18),(6,42,34,19),(6,42,34,20),(5,42,35,1),(4,42,35,4),(4,42,35,5),(4,42,35,17),(6,42,35,18),(6,42,35,19),(6,42,35,20),(4,42,36,4),(4,42,36,5),(4,42,36,6),(4,42,36,7),(4,42,36,8),(4,42,36,9),(4,42,36,10),(6,42,36,18),(6,42,36,19),(9,53,0,10),(9,53,0,22),(3,53,0,25),(3,53,0,26),(3,53,0,27),(3,53,0,28),(3,53,0,29),(3,53,1,25),(3,53,1,26),(2,53,1,27),(3,53,1,29),(4,53,2,4),(13,53,2,18),(3,53,2,25),(3,53,2,26),(3,53,2,29),(4,53,3,4),(4,53,3,5),(3,53,3,9),(13,53,3,15),(3,53,3,25),(3,53,3,26),(3,53,3,27),(3,53,3,28),(3,53,3,29),(4,53,4,3),(4,53,4,4),(4,53,4,5),(4,53,4,8),(3,53,4,9),(3,53,4,10),(3,53,4,11),(10,53,4,21),(3,53,4,25),(3,53,4,26),(3,53,4,27),(3,53,4,28),(3,53,4,29),(4,53,5,3),(4,53,5,4),(4,53,5,5),(4,53,5,6),(4,53,5,7),(4,53,5,8),(4,53,5,9),(3,53,5,10),(3,53,5,11),(3,53,5,25),(3,53,5,26),(2,53,5,27),(3,53,5,29),(4,53,6,4),(4,53,6,5),(4,53,6,6),(3,53,6,7),(3,53,6,8),(3,53,6,9),(3,53,6,10),(3,53,6,11),(3,53,6,13),(3,53,6,25),(3,53,6,26),(4,53,6,29),(4,53,7,2),(4,53,7,3),(4,53,7,4),(4,53,7,5),(4,53,7,6),(4,53,7,7),(3,53,7,8),(5,53,7,9),(3,53,7,10),(3,53,7,11),(3,53,7,12),(3,53,7,13),(3,53,7,14),(3,53,7,25),(3,53,7,26),(3,53,7,27),(3,53,7,28),(4,53,7,29),(4,53,8,2),(4,53,8,4),(4,53,8,5),(5,53,8,6),(5,53,8,7),(3,53,8,8),(5,53,8,9),(3,53,8,10),(3,53,8,11),(3,53,8,12),(3,53,8,13),(3,53,8,14),(10,53,8,17),(4,53,8,22),(4,53,8,23),(4,53,8,24),(4,53,8,25),(4,53,8,26),(3,53,8,27),(4,53,8,28),(4,53,8,29),(4,53,9,1),(4,53,9,2),(4,53,9,3),(4,53,9,4),(4,53,9,5),(5,53,9,7),(5,53,9,8),(5,53,9,9),(3,53,9,10),(3,53,9,12),(3,53,9,13),(4,53,9,23),(4,53,9,24),(4,53,9,25),(1,53,9,26),(4,53,9,28),(4,53,9,29),(4,53,10,1),(4,53,10,4),(4,53,10,6),(5,53,10,7),(5,53,10,8),(5,53,10,9),(5,53,10,10),(3,53,10,11),(3,53,10,12),(3,53,10,13),(3,53,10,14),(4,53,10,24),(4,53,10,25),(4,53,10,28),(4,53,10,29),(4,53,11,4),(4,53,11,5),(4,53,11,6),(4,53,11,7),(5,53,11,8),(5,53,11,9),(5,53,11,10),(3,53,11,12),(4,53,11,24),(4,53,11,25),(4,53,11,26),(4,53,11,27),(4,53,11,28),(4,53,11,29),(4,53,12,0),(4,53,12,1),(4,53,12,2),(4,53,12,3),(4,53,12,4),(4,53,12,5),(4,53,12,6),(5,53,12,7),(5,53,12,8),(5,53,12,9),(3,53,12,12),(4,53,12,24),(4,53,12,26),(4,53,12,27),(4,53,12,28),(4,53,12,29),(4,53,13,0),(4,53,13,1),(4,53,13,2),(4,53,13,3),(4,53,13,5),(4,53,13,6),(5,53,13,7),(5,53,13,9),(5,53,13,10),(3,53,13,12),(3,53,13,13),(4,53,13,25),(4,53,13,26),(4,53,13,27),(4,53,13,28),(4,53,14,0),(4,53,14,1),(4,53,14,3),(4,53,14,5),(4,53,14,6),(5,53,14,10),(5,53,14,11),(3,53,14,22),(3,53,14,23),(4,53,14,24),(4,53,14,25),(4,53,14,26),(4,53,14,27),(4,53,14,28),(4,53,14,29),(4,53,15,0),(3,53,15,3),(4,53,15,4),(4,53,15,5),(5,53,15,10),(5,53,15,11),(5,53,15,15),(5,53,15,16),(3,53,15,23),(4,53,15,28),(4,53,15,29),(4,53,16,0),(4,53,16,1),(4,53,16,2),(3,53,16,3),(4,53,16,4),(4,53,16,5),(4,53,16,6),(4,53,16,7),(5,53,16,10),(5,53,16,11),(5,53,16,12),(5,53,16,14),(5,53,16,15),(3,53,16,23),(3,53,16,24),(3,53,16,25),(4,53,16,26),(4,53,16,27),(4,53,16,28),(4,53,17,0),(4,53,17,1),(4,53,17,2),(4,53,17,3),(4,53,17,4),(4,53,17,5),(4,53,17,6),(4,53,17,7),(5,53,17,11),(5,53,17,12),(5,53,17,13),(5,53,17,14),(5,53,17,15),(3,53,17,20),(3,53,17,21),(3,53,17,22),(3,53,17,23),(4,53,17,27),(4,53,17,28),(4,53,18,0),(4,53,18,1),(4,53,18,2),(4,53,18,3),(4,53,18,4),(5,53,18,10),(5,53,18,11),(5,53,18,12),(5,53,18,13),(3,53,18,20),(3,53,18,21),(3,53,18,22),(3,53,18,23),(3,53,18,24),(3,53,18,25),(3,53,18,26),(3,53,18,27),(3,53,18,28),(4,53,19,0),(4,53,19,1),(4,53,19,2),(4,53,19,3),(4,53,19,4),(4,53,19,5),(5,53,19,12),(5,53,19,13),(5,53,19,14),(5,53,19,15),(3,53,19,19),(3,53,19,20),(3,53,19,21),(3,53,19,22),(3,53,19,23),(3,53,19,24),(3,53,19,25),(3,53,19,26),(3,53,19,27),(6,53,19,29),(4,53,20,0),(4,53,20,1),(4,53,20,2),(4,53,20,3),(5,53,20,14),(3,53,20,21),(3,53,20,22),(3,53,20,23),(3,53,20,24),(3,53,20,25),(6,53,20,26),(6,53,20,27),(6,53,20,28),(6,53,20,29),(4,53,21,0),(4,53,21,3),(4,53,21,4),(6,53,21,11),(5,53,21,14),(3,53,21,21),(3,53,21,22),(6,53,21,26),(6,53,21,28),(6,53,21,29),(6,53,22,11),(6,53,22,25),(6,53,22,26),(6,53,22,27),(6,53,22,28),(6,53,22,29),(6,53,23,11),(6,53,23,26),(6,53,23,28),(6,53,24,9),(6,53,24,10),(6,53,24,11),(6,53,24,12),(6,53,24,13),(6,53,24,24),(6,53,24,26),(6,53,24,27),(6,53,24,28),(6,53,24,29),(6,53,25,10),(6,53,25,11),(6,53,25,12),(6,53,25,13),(6,53,25,23),(6,53,25,24),(6,53,25,25),(6,53,25,26),(6,53,25,27),(6,53,26,10),(6,53,26,11),(6,53,26,13),(6,53,26,14),(6,53,26,23),(6,53,26,24),(6,53,26,25),(6,53,26,26),(6,53,26,27),(6,53,27,10),(6,53,27,14),(6,53,27,23),(6,53,27,25),(6,53,27,26),(3,53,28,20),(3,53,28,21),(3,53,28,22),(6,53,28,25),(6,53,28,26),(3,53,29,20),(3,53,29,21),(3,53,29,22),(3,53,29,24),(6,53,29,26),(3,53,30,20),(3,53,30,21),(3,53,30,22),(3,53,30,23),(3,53,30,24),(3,53,30,26),(5,53,31,16),(3,53,31,19),(3,53,31,20),(3,53,31,21),(3,53,31,22),(3,53,31,23),(3,53,31,24),(3,53,31,25),(3,53,31,26),(5,53,32,16),(5,53,32,17),(3,53,32,20),(3,53,32,21),(3,53,32,22),(3,53,32,23),(3,53,32,24),(3,53,32,25),(3,53,32,26),(5,53,33,17),(5,53,33,18),(3,53,33,22),(3,53,33,23),(5,53,33,24),(3,53,33,25),(3,53,33,26),(6,53,34,13),(6,53,34,14),(6,53,34,15),(5,53,34,16),(5,53,34,17),(5,53,34,19),(5,53,34,20),(5,53,34,21),(3,53,34,22),(5,53,34,23),(5,53,34,24),(3,53,34,25),(3,53,34,26),(4,53,35,12),(6,53,35,13),(6,53,35,14),(6,53,35,15),(5,53,35,16),(5,53,35,17),(5,53,35,18),(5,53,35,19),(5,53,35,23),(5,53,35,24),(4,53,36,7),(4,53,36,12),(6,53,36,14),(6,53,36,15),(5,53,36,16),(5,53,36,17),(5,53,36,18),(5,53,36,19),(5,53,36,21),(5,53,36,22),(5,53,36,23),(5,53,36,24),(4,53,37,6),(4,53,37,7),(4,53,37,8),(4,53,37,9),(4,53,37,12),(6,53,37,13),(6,53,37,14),(6,53,37,15),(5,53,37,16),(5,53,37,17),(5,53,37,18),(5,53,37,22),(5,53,37,23),(5,53,37,24),(5,53,37,25),(4,53,38,5),(4,53,38,6),(4,53,38,7),(4,53,38,8),(4,53,38,9),(4,53,38,10),(4,53,38,12),(4,53,38,13),(6,53,38,14),(6,53,38,15),(6,53,38,16),(5,53,38,17),(5,53,38,22),(5,53,38,23),(5,53,38,24),(4,53,39,6),(4,53,39,7),(4,53,39,8),(4,53,39,9),(4,53,39,10),(4,53,39,11),(4,53,39,12),(4,53,39,13),(6,53,39,14),(3,53,39,16),(5,53,39,17),(3,53,39,19),(5,53,39,24),(5,53,39,25),(5,53,39,26),(5,53,39,27),(4,53,40,6),(4,53,40,7),(4,53,40,8),(4,53,40,9),(4,53,40,10),(4,53,40,12),(4,53,40,13),(6,53,40,14),(3,53,40,15),(3,53,40,16),(3,53,40,17),(3,53,40,18),(3,53,40,19),(5,53,40,24),(4,53,41,9),(4,53,41,10),(4,53,41,12),(6,53,41,13),(6,53,41,14),(3,53,41,15),(3,53,41,16),(3,53,41,17),(3,53,41,19),(5,53,41,24),(5,53,41,25),(4,53,42,9),(4,53,42,10),(3,53,42,13),(3,53,42,14),(3,53,42,15),(3,53,42,16),(3,53,42,17),(3,53,42,18),(3,53,42,19),(4,53,43,7),(4,53,43,8),(4,53,43,9),(4,53,43,10),(3,53,43,13),(3,53,43,14),(3,53,43,15),(3,53,43,16),(3,53,43,17),(3,53,43,18),(3,53,43,19),(3,53,43,20),(3,53,43,21),(4,53,44,7),(4,53,44,8),(4,53,44,9),(6,53,44,10),(6,53,44,12),(6,53,44,13),(3,53,44,14),(3,53,44,15),(3,53,44,16),(3,53,44,17),(3,53,44,18),(3,53,44,19),(3,53,44,20),(4,53,45,5),(4,53,45,6),(4,53,45,7),(6,53,45,9),(6,53,45,10),(6,53,45,11),(6,53,45,12),(6,53,45,13),(3,53,45,20),(6,53,46,6),(6,53,46,7),(6,53,46,8),(6,53,46,9),(6,53,46,10),(6,53,46,12),(6,53,47,8),(6,53,47,10),(6,53,47,11),(6,53,48,8);
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
) ENGINE=InnoDB AUTO_INCREMENT=102 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `units`
--

LOCK TABLES `units` WRITE;
/*!40000 ALTER TABLE `units` DISABLE KEYS */;
INSERT INTO `units` VALUES (1,3400,1,1,1,NULL,NULL,NULL,NULL,0,0,'Thor',0,5,30,NULL,1,0,0,0),(2,8000,1,1,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,5,30,NULL,1,0,0,0),(3,8000,1,1,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,5,30,NULL,1,0,0,0),(4,8000,1,1,1,NULL,NULL,NULL,NULL,0,0,'Dirac',0,5,30,NULL,1,0,0,0),(5,3000,1,1,1,NULL,NULL,NULL,NULL,0,0,'Rhyno',0,3,44,NULL,1,0,0,0),(6,8000,1,1,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,3,44,NULL,1,0,0,0),(7,8000,1,1,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,3,44,NULL,1,0,0,0),(8,8000,1,1,1,NULL,NULL,NULL,NULL,0,0,'Dirac',0,3,44,NULL,1,0,0,0),(9,3000,1,1,1,NULL,NULL,NULL,NULL,0,0,'Rhyno',0,0,90,NULL,1,0,0,0),(10,3400,1,1,1,NULL,NULL,NULL,NULL,0,0,'Thor',0,0,90,NULL,1,0,0,0),(11,8000,1,1,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,0,90,NULL,1,0,0,0),(12,8000,1,1,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,0,90,NULL,1,0,0,0),(13,8000,1,1,1,NULL,NULL,NULL,NULL,0,0,'Dirac',0,0,90,NULL,1,0,0,0),(14,3000,1,1,1,NULL,NULL,NULL,NULL,0,0,'Rhyno',0,1,135,NULL,1,0,0,0),(15,3000,1,1,1,NULL,NULL,NULL,NULL,0,0,'Rhyno',0,1,135,NULL,1,0,0,0),(16,3400,1,1,1,NULL,NULL,NULL,NULL,0,0,'Thor',1,1,135,NULL,1,0,0,0),(17,8000,1,1,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,1,135,NULL,1,0,0,0),(18,8000,1,1,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,1,135,NULL,1,0,0,0),(19,8000,1,1,1,NULL,NULL,NULL,NULL,0,0,'Dirac',0,1,135,NULL,1,0,0,0),(20,3400,1,2,1,NULL,NULL,NULL,NULL,0,0,'Thor',0,1,45,NULL,1,0,0,0),(21,3400,1,2,1,NULL,NULL,NULL,NULL,0,0,'Thor',1,1,45,NULL,1,0,0,0),(22,8000,1,2,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,1,45,NULL,1,0,0,0),(23,8000,1,2,1,NULL,NULL,NULL,NULL,0,0,'Dirac',0,1,45,NULL,1,0,0,0),(24,3400,1,2,1,NULL,NULL,NULL,NULL,0,0,'Thor',0,4,270,NULL,1,0,0,0),(25,3400,1,2,1,NULL,NULL,NULL,NULL,0,0,'Thor',1,4,270,NULL,1,0,0,0),(26,8000,1,2,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,4,270,NULL,1,0,0,0),(27,8000,1,2,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,4,270,NULL,1,0,0,0),(28,8000,1,2,1,NULL,NULL,NULL,NULL,0,0,'Dirac',0,4,270,NULL,1,0,0,0),(29,3000,1,2,1,NULL,NULL,NULL,NULL,0,0,'Rhyno',0,5,285,NULL,1,0,0,0),(30,3000,1,2,1,NULL,NULL,NULL,NULL,0,0,'Rhyno',0,5,285,NULL,1,0,0,0),(31,8000,1,2,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,5,285,NULL,1,0,0,0),(32,8000,1,2,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,5,285,NULL,1,0,0,0),(33,8000,1,2,1,NULL,NULL,NULL,NULL,0,0,'Dirac',0,5,285,NULL,1,0,0,0),(34,3400,1,2,1,NULL,NULL,NULL,NULL,0,0,'Thor',1,4,108,NULL,1,0,0,0),(35,8000,1,2,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,4,108,NULL,1,0,0,0),(36,8000,1,2,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,4,108,NULL,1,0,0,0),(37,8000,1,2,1,NULL,NULL,NULL,NULL,0,0,'Dirac',0,4,108,NULL,1,0,0,0),(38,3400,1,3,1,NULL,NULL,NULL,NULL,0,0,'Thor',0,5,300,NULL,1,0,0,0),(39,3400,1,3,1,NULL,NULL,NULL,NULL,0,0,'Thor',1,5,300,NULL,1,0,0,0),(40,8000,1,3,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,5,300,NULL,1,0,0,0),(41,8000,1,3,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,5,300,NULL,1,0,0,0),(42,8000,1,3,1,NULL,NULL,NULL,NULL,0,0,'Dirac',0,5,300,NULL,1,0,0,0),(43,200,1,25,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,26,16,NULL,1,0,0,0),(44,100,1,25,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,26,16,NULL,1,0,0,0),(45,200,1,25,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,26,16,NULL,1,0,0,0),(46,100,1,25,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,26,16,NULL,1,0,0,0),(47,200,1,25,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,26,16,NULL,1,0,0,0),(48,100,1,25,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,26,16,NULL,1,0,0,0),(49,100,1,25,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,26,16,NULL,1,0,0,0),(50,100,1,26,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,25,20,NULL,1,0,0,0),(51,200,1,26,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,25,20,NULL,1,0,0,0),(52,100,1,26,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,25,20,NULL,1,0,0,0),(53,100,1,26,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,25,20,NULL,1,0,0,0),(54,200,1,30,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,24,24,NULL,1,0,0,0),(55,100,1,30,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,24,24,NULL,1,0,0,0),(56,100,1,30,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,24,24,NULL,1,0,0,0),(57,200,1,31,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,28,24,NULL,1,0,0,0),(58,100,1,31,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,28,24,NULL,1,0,0,0),(59,100,1,31,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,28,24,NULL,1,0,0,0),(60,100,1,32,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,18,25,NULL,1,0,0,0),(61,100,1,32,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,18,25,NULL,1,0,0,0),(62,100,1,33,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,15,26,NULL,1,0,0,0),(63,100,1,33,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,15,26,NULL,1,0,0,0),(64,200,1,34,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,3,27,NULL,1,0,0,0),(65,100,1,34,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,3,27,NULL,1,0,0,0),(66,100,1,34,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,3,27,NULL,1,0,0,0),(67,100,1,35,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,12,27,NULL,1,0,0,0),(68,100,1,35,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,12,27,NULL,1,0,0,0),(69,100,1,36,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,22,27,NULL,1,0,0,0),(70,100,1,36,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,22,27,NULL,1,0,0,0),(71,200,1,37,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,26,27,NULL,1,0,0,0),(72,100,1,37,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,26,27,NULL,1,0,0,0),(73,100,1,37,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,26,27,NULL,1,0,0,0),(74,200,1,38,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,0,28,NULL,1,0,0,0),(75,100,1,38,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,0,28,NULL,1,0,0,0),(76,100,1,38,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,0,28,NULL,1,0,0,0),(77,200,1,39,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,7,28,NULL,1,0,0,0),(78,100,1,39,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,7,28,NULL,1,0,0,0),(79,100,1,39,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,7,28,NULL,1,0,0,0),(80,100,1,40,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,18,28,NULL,1,0,0,0),(81,100,1,40,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,18,28,NULL,1,0,0,0),(82,3000,1,3,1,NULL,NULL,NULL,NULL,0,0,'Rhyno',0,1,270,NULL,1,0,0,0),(83,3000,1,3,1,NULL,NULL,NULL,NULL,0,0,'Rhyno',0,1,270,NULL,1,0,0,0),(84,3000,1,3,1,NULL,NULL,NULL,NULL,0,0,'Rhyno',0,1,270,NULL,1,0,0,0),(85,3400,1,3,1,NULL,NULL,NULL,NULL,0,0,'Thor',0,1,270,NULL,1,0,0,0),(86,3400,1,3,1,NULL,NULL,NULL,NULL,0,0,'Thor',1,1,270,NULL,1,0,0,0),(87,8000,1,3,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,1,270,NULL,1,0,0,0),(88,8000,1,3,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,1,270,NULL,1,0,0,0),(89,8000,1,3,1,NULL,NULL,NULL,NULL,0,0,'Dirac',0,1,270,NULL,1,0,0,0),(90,3000,1,4,1,NULL,NULL,NULL,NULL,0,0,'Rhyno',0,3,112,NULL,1,0,0,0),(91,3400,1,4,1,NULL,NULL,NULL,NULL,0,0,'Thor',1,3,112,NULL,1,0,0,0),(92,8000,1,4,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,3,112,NULL,1,0,0,0),(93,8000,1,4,1,NULL,NULL,NULL,NULL,0,0,'Dirac',0,3,112,NULL,1,0,0,0),(94,3400,1,4,1,NULL,NULL,NULL,NULL,0,0,'Thor',1,2,0,NULL,1,0,0,0),(95,8000,1,4,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,2,0,NULL,1,0,0,0),(96,8000,1,4,1,NULL,NULL,NULL,NULL,0,0,'Dirac',0,2,0,NULL,1,0,0,0),(97,3000,1,4,1,NULL,NULL,NULL,NULL,0,0,'Rhyno',0,0,0,NULL,1,0,0,0),(98,3400,1,4,1,NULL,NULL,NULL,NULL,0,0,'Thor',1,0,0,NULL,1,0,0,0),(99,8000,1,4,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,0,0,NULL,1,0,0,0),(100,8000,1,4,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,0,0,NULL,1,0,0,0),(101,8000,1,4,1,NULL,NULL,NULL,NULL,0,0,'Dirac',0,0,0,NULL,1,0,0,0);
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

-- Dump completed on 2010-10-29 15:02:27
