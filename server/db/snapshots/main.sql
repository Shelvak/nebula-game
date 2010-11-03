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
) ENGINE=InnoDB AUTO_INCREMENT=51 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `buildings`
--

LOCK TABLES `buildings` WRITE;
/*!40000 ALTER TABLE `buildings` DISABLE KEYS */;
INSERT INTO `buildings` VALUES (1,1,13,14,0,0,0,1,'NpcMetalExtractor',NULL,15,16,NULL,0,400,NULL,0,NULL,NULL,0),(2,1,5,7,0,0,0,1,'NpcMetalExtractor',NULL,7,9,NULL,0,400,NULL,0,NULL,NULL,0),(3,1,9,2,0,0,0,1,'NpcMetalExtractor',NULL,11,4,NULL,0,400,NULL,0,NULL,NULL,0),(4,1,5,1,0,0,0,1,'NpcMetalExtractor',NULL,7,3,NULL,0,400,NULL,0,NULL,NULL,0),(5,1,1,2,0,0,0,1,'NpcMetalExtractor',NULL,3,4,NULL,0,400,NULL,0,NULL,NULL,0),(6,1,9,15,0,0,0,1,'NpcZetiumExtractor',NULL,11,17,NULL,0,800,NULL,0,NULL,NULL,0),(7,11,9,43,0,0,0,1,'NpcMetalExtractor',NULL,11,45,NULL,0,400,NULL,0,NULL,NULL,0),(8,11,5,41,0,0,0,1,'NpcMetalExtractor',NULL,7,43,NULL,0,400,NULL,0,NULL,NULL,0),(9,16,27,26,0,0,0,1,'NpcMetalExtractor',NULL,29,28,NULL,0,400,NULL,0,NULL,NULL,0),(10,16,28,33,0,0,0,1,'NpcMetalExtractor',NULL,30,35,NULL,0,400,NULL,0,NULL,NULL,0),(11,16,27,10,0,0,0,1,'NpcMetalExtractor',NULL,29,12,NULL,0,400,NULL,0,NULL,NULL,0),(12,16,27,3,0,0,0,1,'NpcMetalExtractor',NULL,29,5,NULL,0,400,NULL,0,NULL,NULL,0),(13,16,21,2,0,0,0,1,'NpcGeothermalPlant',NULL,23,4,NULL,0,600,NULL,0,NULL,NULL,0),(14,18,28,3,0,0,0,1,'NpcMetalExtractor',NULL,30,5,NULL,0,400,NULL,0,NULL,NULL,0),(15,18,34,12,0,0,0,1,'NpcMetalExtractor',NULL,36,14,NULL,0,400,NULL,0,NULL,NULL,0),(16,18,33,3,0,0,0,1,'NpcMetalExtractor',NULL,35,5,NULL,0,400,NULL,0,NULL,NULL,0),(17,18,44,8,0,0,0,1,'NpcMetalExtractor',NULL,46,10,NULL,0,400,NULL,0,NULL,NULL,0),(18,18,43,1,0,0,0,1,'NpcMetalExtractor',NULL,45,3,NULL,0,400,NULL,0,NULL,NULL,0),(19,18,39,1,0,0,0,1,'NpcMetalExtractor',NULL,41,3,NULL,0,400,NULL,0,NULL,NULL,0),(20,27,7,9,0,0,0,1,'Vulcan',NULL,9,11,NULL,0,300,NULL,0,NULL,NULL,0),(21,27,14,9,0,0,0,1,'Thunder',NULL,16,11,NULL,0,300,NULL,0,NULL,NULL,0),(22,27,21,9,0,0,0,1,'Screamer',NULL,23,11,NULL,0,300,NULL,0,NULL,NULL,0),(23,27,11,14,0,0,0,1,'Mothership',NULL,19,20,NULL,0,10500,NULL,0,NULL,NULL,0),(24,27,7,16,0,0,0,1,'Thunder',NULL,9,18,NULL,0,300,NULL,0,NULL,NULL,0),(25,27,21,16,0,0,0,1,'Thunder',NULL,23,18,NULL,0,300,NULL,0,NULL,NULL,0),(26,27,26,16,0,0,0,1,'NpcZetiumExtractor',NULL,28,18,NULL,0,800,NULL,0,NULL,NULL,0),(27,27,25,20,0,0,0,1,'NpcTemple',NULL,28,23,NULL,0,1500,NULL,0,NULL,NULL,0),(28,27,7,22,0,0,0,1,'Screamer',NULL,9,24,NULL,0,300,NULL,0,NULL,NULL,0),(29,27,14,22,0,0,0,1,'Thunder',NULL,16,24,NULL,0,300,NULL,0,NULL,NULL,0),(30,27,21,22,0,0,0,1,'Vulcan',NULL,23,24,NULL,0,300,NULL,0,NULL,NULL,0),(31,27,24,24,0,0,0,1,'NpcMetalExtractor',NULL,26,26,NULL,0,400,NULL,0,NULL,NULL,0),(32,27,28,24,0,0,0,1,'NpcMetalExtractor',NULL,30,26,NULL,0,400,NULL,0,NULL,NULL,0),(33,27,18,25,0,0,0,1,'NpcSolarPlant',NULL,20,27,NULL,0,1000,NULL,0,NULL,NULL,0),(34,27,15,26,0,0,0,1,'NpcSolarPlant',NULL,17,28,NULL,0,1000,NULL,0,NULL,NULL,0),(35,27,3,27,0,0,0,1,'NpcMetalExtractor',NULL,5,29,NULL,0,400,NULL,0,NULL,NULL,0),(36,27,12,27,0,0,0,1,'NpcSolarPlant',NULL,14,29,NULL,0,1000,NULL,0,NULL,NULL,0),(37,27,22,27,0,0,0,1,'NpcSolarPlant',NULL,24,29,NULL,0,1000,NULL,0,NULL,NULL,0),(38,27,26,27,0,0,0,1,'NpcCommunicationsHub',NULL,29,29,NULL,0,1200,NULL,0,NULL,NULL,0),(39,27,0,28,0,0,0,1,'NpcMetalExtractor',NULL,2,30,NULL,0,400,NULL,0,NULL,NULL,0),(40,27,7,28,0,0,0,1,'NpcCommunicationsHub',NULL,10,30,NULL,0,1200,NULL,0,NULL,NULL,0),(41,27,18,28,0,0,0,1,'NpcSolarPlant',NULL,20,30,NULL,0,1000,NULL,0,NULL,NULL,0),(42,30,14,19,0,0,0,1,'NpcMetalExtractor',NULL,16,21,NULL,0,400,NULL,0,NULL,NULL,0),(43,30,2,8,0,0,0,1,'NpcMetalExtractor',NULL,4,10,NULL,0,400,NULL,0,NULL,NULL,0),(44,30,2,3,0,0,0,1,'NpcMetalExtractor',NULL,4,5,NULL,0,400,NULL,0,NULL,NULL,0),(45,30,22,3,0,0,0,1,'NpcMetalExtractor',NULL,24,5,NULL,0,400,NULL,0,NULL,NULL,0),(46,30,27,2,0,0,0,1,'NpcMetalExtractor',NULL,29,4,NULL,0,400,NULL,0,NULL,NULL,0),(47,30,16,3,0,0,0,1,'NpcGeothermalPlant',NULL,18,5,NULL,0,600,NULL,0,NULL,NULL,0),(48,40,21,38,0,0,0,1,'NpcMetalExtractor',NULL,23,40,NULL,0,400,NULL,0,NULL,NULL,0),(49,40,26,42,0,0,0,1,'NpcMetalExtractor',NULL,28,44,NULL,0,400,NULL,0,NULL,NULL,0),(50,40,25,47,0,0,0,1,'NpcMetalExtractor',NULL,27,49,NULL,0,400,NULL,0,NULL,NULL,0);
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
INSERT INTO `folliages` VALUES (1,0,0,3),(1,1,9,10),(1,1,11,13),(1,2,1,0),(1,2,13,13),(1,3,8,4),(1,3,15,6),(1,3,16,5),(1,4,25,0),(1,7,2,2),(1,7,7,6),(1,8,1,13),(1,8,2,9),(1,8,7,10),(1,8,8,1),(1,8,9,0),(1,8,16,11),(1,9,4,0),(1,9,9,13),(1,9,14,7),(1,9,25,11),(1,10,0,1),(1,10,18,6),(1,10,21,7),(1,11,1,11),(1,11,15,12),(1,11,16,5),(1,11,21,3),(1,12,2,2),(1,12,11,0),(1,12,12,1),(1,12,14,5),(1,12,15,11),(1,12,17,8),(1,12,20,7),(1,13,10,9),(1,13,11,6),(1,13,16,5),(1,13,21,4),(1,14,0,8),(1,14,13,13),(1,15,13,3),(1,15,19,13),(1,16,1,2),(1,17,13,6),(1,17,14,0),(1,18,17,2),(1,18,24,10),(1,19,0,2),(1,19,17,0),(1,20,16,9),(1,20,18,9),(1,20,19,2),(1,21,13,12),(1,21,14,10),(1,21,15,13),(1,21,19,11),(1,21,20,2),(1,21,25,9),(1,22,10,12),(1,22,12,6),(1,22,25,6),(1,23,11,9),(1,23,14,4),(1,23,17,3),(1,23,19,0),(1,24,0,12),(1,24,3,9),(1,24,14,7),(1,24,17,0),(1,24,18,3),(1,24,19,5),(1,25,16,5),(1,25,18,9),(1,25,20,3),(1,25,23,0),(1,26,9,0),(1,26,19,1),(1,27,2,6),(1,27,4,2),(1,27,6,3),(1,27,7,10),(1,28,2,6),(1,29,13,1),(1,30,4,11),(1,30,5,13),(1,31,5,12),(1,31,15,9),(1,31,21,8),(1,32,0,4),(1,32,3,0),(1,32,4,9),(1,32,16,11),(1,32,17,0),(1,33,5,4),(1,33,8,6),(1,33,13,9),(1,33,14,1),(1,33,17,4),(1,33,19,7),(1,34,11,10),(1,34,12,10),(1,34,13,10),(1,34,14,4),(1,34,15,10),(1,34,16,1),(1,34,17,7),(1,34,19,4),(1,35,0,12),(1,35,1,11),(1,35,6,10),(1,35,7,4),(1,35,9,1),(1,35,13,2),(1,35,16,13),(1,35,20,5),(1,36,2,12),(1,36,10,5),(1,36,20,10),(1,36,24,5),(1,37,10,9),(1,37,13,4),(1,37,15,4),(1,38,4,0),(1,38,13,4),(1,38,23,13),(1,38,24,3),(1,38,25,1),(1,39,5,13),(1,39,11,10),(1,39,13,2),(1,39,14,10),(1,39,17,2),(11,0,11,3),(11,0,32,5),(11,0,33,7),(11,0,41,4),(11,0,44,0),(11,1,0,12),(11,1,11,5),(11,1,15,7),(11,1,40,6),(11,2,13,12),(11,2,14,2),(11,2,33,2),(11,3,11,7),(11,4,0,5),(11,4,10,10),(11,4,11,13),(11,5,0,7),(11,5,2,13),(11,5,8,13),(11,6,2,3),(11,6,4,4),(11,6,19,5),(11,7,7,8),(11,7,8,5),(11,7,10,11),(11,7,11,7),(11,7,18,10),(11,7,21,12),(11,8,0,10),(11,8,6,0),(11,8,7,0),(11,8,8,4),(11,8,9,10),(11,8,17,11),(11,8,20,5),(11,8,22,1),(11,8,27,4),(11,8,37,11),(11,8,43,0),(11,9,2,10),(11,9,26,12),(11,9,39,10),(11,10,2,5),(11,10,3,3),(11,10,17,0),(11,10,40,12),(11,11,6,1),(11,11,12,4),(11,11,45,4),(11,12,6,1),(11,12,16,4),(11,12,45,4),(11,13,7,6),(11,13,9,2),(11,13,10,6),(11,13,11,12),(11,13,20,6),(11,13,26,3),(11,13,38,2),(11,13,45,2),(11,14,1,1),(11,14,12,5),(11,14,17,1),(11,14,34,1),(11,14,39,2),(11,14,42,10),(11,15,2,5),(11,15,8,12),(11,15,9,11),(11,15,20,13),(11,15,24,1),(11,15,40,4),(11,16,13,3),(11,16,14,11),(11,16,26,11),(11,16,38,1),(11,17,10,9),(11,17,11,2),(11,17,12,6),(11,17,23,13),(11,17,43,12),(11,17,45,1),(11,18,8,11),(11,18,15,7),(11,18,18,0),(11,18,20,12),(11,18,29,5),(11,19,7,4),(11,19,43,5),(11,19,45,1),(11,20,16,1),(11,20,26,4),(11,20,35,11),(11,20,39,0),(11,20,41,0),(11,20,45,13),(11,21,5,7),(11,21,7,3),(11,21,18,12),(11,21,20,11),(11,21,28,3),(11,21,29,11),(11,21,34,11),(11,21,35,2),(11,21,36,1),(11,22,3,7),(11,22,7,5),(11,22,23,6),(11,22,24,0),(11,22,25,5),(11,22,28,7),(11,22,36,13),(11,22,39,10),(11,22,40,10),(11,23,3,10),(11,23,10,11),(11,23,16,4),(11,23,18,2),(11,23,19,7),(11,23,22,11),(11,23,25,12),(11,23,26,11),(11,23,27,12),(11,23,35,10),(11,23,36,6),(11,23,37,10),(11,23,39,11),(11,23,45,0),(11,24,7,0),(11,24,18,7),(11,24,22,6),(11,25,20,7),(11,25,26,10),(11,25,28,12),(11,25,45,1),(11,26,14,11),(11,26,15,8),(11,26,20,5),(11,26,21,11),(11,26,22,3),(11,26,23,4),(11,27,2,13),(11,27,22,2),(11,27,24,6),(11,27,26,0),(11,27,28,13),(11,27,36,1),(11,27,37,10),(11,27,39,4),(11,28,1,3),(11,28,18,0),(11,28,21,11),(11,28,22,10),(11,28,27,2),(11,28,38,12),(11,28,39,12),(11,28,45,10),(11,29,13,10),(11,29,14,13),(11,29,20,11),(11,29,22,0),(11,29,23,3),(11,29,25,1),(11,29,28,7),(11,29,37,5),(11,30,0,0),(11,30,10,6),(11,30,14,13),(11,30,17,7),(11,30,19,10),(11,30,23,13),(11,30,25,7),(11,30,27,13),(11,30,29,13),(11,30,38,5),(16,0,6,6),(16,0,9,0),(16,0,10,11),(16,0,11,8),(16,0,12,4),(16,0,18,5),(16,0,21,2),(16,0,22,0),(16,0,23,2),(16,0,27,6),(16,0,28,11),(16,0,33,12),(16,0,35,4),(16,1,7,0),(16,1,8,5),(16,1,9,6),(16,1,14,1),(16,1,24,13),(16,1,27,11),(16,2,3,13),(16,2,5,3),(16,2,11,3),(16,2,12,3),(16,2,19,10),(16,2,22,0),(16,2,31,4),(16,2,33,12),(16,3,2,4),(16,3,7,0),(16,3,9,6),(16,3,17,2),(16,3,19,1),(16,3,21,3),(16,3,26,12),(16,3,31,3),(16,3,35,3),(16,4,6,13),(16,4,17,0),(16,4,20,1),(16,4,22,9),(16,4,25,3),(16,4,30,7),(16,4,35,13),(16,5,22,5),(16,6,11,11),(16,6,20,0),(16,6,30,10),(16,6,35,6),(16,7,8,11),(16,7,9,13),(16,7,10,2),(16,7,11,11),(16,8,1,9),(16,8,9,13),(16,8,25,5),(16,8,29,1),(16,8,30,7),(16,8,33,3),(16,9,0,0),(16,9,6,11),(16,9,25,7),(16,9,26,0),(16,9,27,10),(16,9,34,9),(16,9,35,4),(16,10,5,4),(16,10,6,10),(16,10,13,1),(16,10,15,7),(16,10,35,3),(16,11,7,6),(16,11,9,8),(16,11,13,12),(16,11,14,6),(16,11,34,9),(16,12,5,1),(16,12,7,2),(16,12,8,7),(16,12,10,10),(16,12,13,3),(16,12,34,2),(16,13,19,10),(16,13,21,2),(16,13,23,1),(16,14,6,2),(16,14,7,0),(16,14,23,3),(16,14,25,7),(16,14,27,1),(16,15,7,11),(16,15,9,1),(16,15,10,10),(16,15,11,5),(16,15,16,10),(16,15,21,7),(16,15,22,10),(16,15,24,4),(16,15,31,2),(16,16,3,0),(16,16,5,11),(16,16,7,12),(16,16,8,12),(16,16,9,9),(16,16,21,2),(16,16,32,3),(16,17,9,12),(16,17,10,5),(16,18,2,2),(16,18,4,5),(16,18,5,10),(16,18,6,2),(16,18,8,8),(16,18,12,7),(16,18,15,3),(16,19,3,12),(16,19,4,11),(16,19,8,12),(16,19,10,11),(16,19,16,12),(16,20,12,0),(16,21,11,2),(16,21,13,12),(16,21,17,7),(16,22,1,2),(16,22,12,13),(16,23,9,5),(16,23,11,1),(16,23,13,5),(16,24,17,9),(16,26,12,11),(16,27,3,13),(16,27,21,10),(16,28,9,11),(16,29,4,13),(18,0,3,9),(18,0,17,0),(18,0,19,11),(18,1,0,10),(18,1,1,12),(18,1,5,3),(18,1,12,12),(18,1,13,1),(18,1,17,11),(18,1,18,2),(18,1,19,0),(18,1,24,8),(18,2,1,11),(18,2,2,4),(18,2,10,2),(18,2,13,10),(18,2,15,8),(18,2,18,11),(18,2,26,2),(18,3,2,3),(18,3,13,12),(18,3,16,1),(18,3,18,6),(18,3,19,9),(18,3,26,5),(18,4,3,5),(18,4,10,3),(18,4,14,5),(18,4,16,5),(18,4,19,7),(18,4,20,9),(18,5,1,8),(18,5,6,9),(18,5,15,11),(18,6,1,1),(18,6,4,2),(18,6,9,9),(18,6,17,5),(18,6,18,3),(18,6,19,9),(18,7,5,7),(18,7,6,0),(18,7,8,6),(18,7,9,9),(18,7,12,7),(18,7,13,11),(18,7,21,11),(18,8,8,5),(18,8,17,4),(18,8,22,11),(18,9,3,4),(18,9,4,9),(18,9,5,11),(18,9,15,8),(18,9,22,7),(18,9,25,12),(18,10,1,10),(18,10,3,5),(18,10,15,13),(18,10,21,7),(18,10,26,2),(18,11,5,2),(18,11,15,5),(18,11,17,3),(18,11,24,5),(18,12,0,11),(18,12,1,3),(18,12,6,7),(18,12,17,9),(18,12,19,7),(18,12,20,4),(18,13,3,8),(18,13,10,10),(18,13,11,11),(18,13,12,12),(18,13,13,1),(18,13,20,7),(18,13,25,3),(18,14,2,0),(18,14,4,10),(18,14,13,10),(18,14,15,11),(18,14,16,8),(18,15,0,6),(18,15,12,6),(18,16,2,8),(18,16,12,10),(18,16,13,0),(18,16,21,9),(18,17,3,8),(18,17,8,11),(18,17,12,12),(18,18,3,4),(18,18,6,9),(18,18,8,6),(18,18,9,4),(18,18,25,6),(18,19,2,10),(18,19,4,7),(18,20,3,3),(18,20,4,7),(18,20,5,11),(18,20,7,4),(18,20,26,9),(18,21,0,5),(18,21,3,9),(18,21,11,7),(18,22,1,8),(18,22,4,7),(18,23,26,7),(18,24,8,10),(18,25,12,9),(18,25,17,5),(18,25,22,10),(18,26,6,5),(18,26,7,5),(18,27,8,12),(18,27,16,0),(18,27,17,1),(18,27,21,11),(18,27,25,4),(18,28,5,5),(18,28,6,9),(18,28,12,7),(18,28,16,10),(18,28,22,12),(18,28,26,4),(18,30,5,9),(18,30,18,4),(18,30,22,9),(18,30,25,4),(18,30,26,10),(18,31,4,0),(18,32,6,11),(18,32,8,4),(18,32,16,11),(18,33,12,1),(18,33,16,6),(18,34,15,5),(18,35,11,7),(18,35,14,9),(18,37,8,11),(18,37,10,11),(18,37,11,2),(18,38,10,2),(18,38,24,8),(18,39,10,8),(18,39,24,12),(18,40,24,6),(18,44,6,12),(18,44,7,0),(18,44,17,9),(18,45,13,7),(18,46,16,6),(18,46,17,8),(18,46,24,2),(27,0,27,4),(27,3,3,8),(27,3,10,7),(27,3,11,3),(27,3,27,4),(27,4,4,5),(27,4,5,7),(27,4,18,1),(27,4,26,2),(27,5,9,4),(27,5,23,2),(27,5,25,6),(27,5,26,6),(27,6,4,2),(27,6,5,5),(27,6,6,2),(27,6,28,2),(27,7,10,10),(27,7,13,8),(27,7,23,11),(27,7,26,0),(27,7,29,13),(27,8,8,3),(27,8,16,0),(27,8,27,10),(27,9,15,11),(27,9,17,13),(27,9,18,6),(27,10,7,7),(27,10,10,3),(27,10,21,5),(27,11,7,3),(27,11,17,2),(27,11,20,5),(27,12,7,5),(27,12,8,9),(27,12,9,7),(27,12,10,8),(27,12,11,2),(27,12,20,4),(27,13,1,4),(27,13,3,6),(27,13,5,0),(27,13,9,7),(27,13,10,11),(27,13,11,12),(27,13,13,0),(27,13,19,6),(27,14,1,0),(27,14,8,2),(27,14,10,4),(27,14,16,7),(27,14,24,4),(27,15,5,9),(27,15,7,6),(27,15,8,10),(27,15,12,9),(27,15,14,11),(27,16,1,8),(27,16,6,4),(27,16,11,9),(27,16,21,3),(27,17,3,12),(27,17,12,11),(27,17,16,2),(27,17,21,8),(27,17,23,9),(27,18,5,9),(27,18,7,0),(27,18,10,1),(27,18,14,3),(27,19,1,9),(27,19,12,1),(27,20,5,3),(27,20,10,11),(27,20,11,4),(27,20,14,11),(27,20,18,5),(27,20,21,8),(27,20,23,13),(27,21,16,0),(27,22,8,5),(27,22,13,0),(27,22,15,8),(27,22,20,10),(27,22,23,0),(27,22,26,2),(27,23,5,4),(27,23,11,5),(27,23,14,1),(27,23,17,0),(27,23,25,11),(27,24,7,4),(27,24,23,3),(27,24,26,9),(27,25,4,13),(27,25,5,6),(27,25,7,8),(27,25,8,5),(27,25,11,6),(27,25,12,3),(27,25,17,10),(27,26,8,3),(27,26,15,4),(27,27,0,9),(27,27,13,5),(27,27,15,8),(27,27,18,7),(30,0,23,0),(30,1,12,13),(30,1,21,8),(30,2,3,0),(30,3,2,7),(30,4,1,4),(30,4,14,8),(30,5,7,1),(30,5,21,3),(30,5,22,13),(30,5,24,2),(30,6,1,4),(30,6,19,6),(30,6,20,5),(30,6,21,5),(30,7,0,10),(30,7,13,10),(30,7,16,1),(30,7,22,10),(30,7,24,1),(30,8,0,11),(30,8,15,0),(30,8,23,6),(30,8,24,12),(30,9,4,7),(30,9,10,12),(30,9,17,8),(30,9,18,6),(30,9,19,2),(30,10,0,10),(30,10,1,8),(30,10,4,13),(30,10,6,8),(30,10,18,11),(30,10,20,2),(30,11,6,5),(30,11,14,0),(30,11,22,5),(30,12,0,6),(30,12,19,6),(30,12,20,7),(30,12,24,9),(30,13,0,8),(30,13,21,2),(30,14,10,13),(30,14,19,1),(30,15,3,4),(30,15,5,11),(30,16,9,1),(30,16,10,2),(30,17,2,4),(30,18,5,7),(30,18,10,5),(30,22,0,13),(30,22,2,9),(30,22,6,6),(30,22,12,0),(30,23,6,3),(30,23,10,13),(30,23,15,9),(30,23,16,9),(30,23,19,10),(30,23,24,12),(30,24,5,12),(30,24,19,10),(30,25,8,4),(30,26,11,2),(30,26,12,10),(30,26,20,7),(30,27,16,8),(30,27,20,7),(30,28,20,0),(30,28,23,3),(30,29,1,5),(30,29,20,4),(30,29,22,12),(30,30,5,5),(30,31,6,9),(30,31,9,8),(30,31,24,7),(40,0,1,13),(40,0,5,1),(40,0,8,2),(40,0,11,0),(40,0,13,0),(40,0,24,0),(40,0,27,5),(40,0,31,6),(40,0,35,12),(40,0,37,13),(40,0,39,10),(40,0,44,11),(40,1,5,0),(40,1,12,5),(40,1,15,13),(40,1,22,12),(40,1,25,5),(40,1,27,13),(40,1,28,0),(40,1,29,5),(40,1,31,12),(40,1,34,7),(40,2,9,11),(40,2,10,11),(40,2,11,2),(40,2,16,6),(40,2,23,0),(40,2,25,5),(40,2,26,6),(40,2,28,10),(40,2,30,4),(40,3,1,5),(40,3,12,4),(40,3,13,12),(40,3,15,7),(40,3,26,4),(40,3,33,11),(40,3,34,7),(40,3,44,10),(40,3,49,9),(40,4,0,11),(40,4,2,13),(40,4,7,3),(40,4,10,13),(40,4,11,4),(40,4,12,13),(40,4,18,3),(40,4,24,12),(40,4,26,11),(40,4,34,13),(40,4,37,12),(40,4,47,12),(40,5,1,6),(40,5,4,2),(40,5,14,11),(40,5,16,0),(40,5,17,11),(40,5,19,1),(40,5,22,10),(40,5,23,7),(40,5,24,4),(40,5,27,6),(40,5,31,5),(40,5,32,12),(40,5,41,4),(40,5,45,0),(40,6,6,4),(40,6,12,12),(40,6,17,3),(40,6,19,0),(40,6,21,7),(40,6,26,3),(40,6,29,10),(40,6,38,10),(40,6,40,3),(40,6,47,11),(40,6,49,13),(40,7,1,11),(40,7,2,13),(40,7,3,4),(40,7,4,6),(40,7,5,7),(40,7,14,6),(40,7,38,11),(40,7,40,4),(40,7,42,1),(40,7,46,0),(40,7,49,4),(40,8,1,1),(40,8,3,4),(40,8,10,6),(40,8,29,5),(40,8,48,7),(40,9,9,5),(40,9,12,11),(40,9,16,12),(40,9,22,0),(40,9,26,3),(40,9,27,7),(40,9,29,7),(40,9,30,11),(40,9,39,11),(40,10,3,13),(40,10,10,2),(40,10,11,10),(40,10,14,2),(40,10,15,7),(40,10,17,6),(40,10,25,12),(40,10,27,11),(40,10,29,7),(40,11,4,6),(40,11,5,8),(40,11,6,4),(40,11,10,4),(40,11,14,13),(40,11,15,11),(40,11,16,4),(40,11,17,6),(40,11,26,5),(40,11,27,1),(40,11,46,12),(40,11,49,0),(40,12,15,12),(40,12,26,7),(40,12,31,1),(40,13,3,4),(40,13,4,2),(40,13,5,5),(40,13,11,2),(40,13,23,6),(40,13,24,7),(40,13,26,0),(40,14,6,7),(40,14,7,4),(40,14,28,2),(40,15,1,1),(40,15,3,2),(40,15,5,3),(40,15,15,12),(40,15,18,12),(40,15,24,5),(40,16,20,2),(40,16,23,11),(40,16,26,0),(40,16,31,0),(40,16,38,12),(40,17,0,0),(40,17,5,12),(40,17,7,7),(40,17,8,1),(40,17,18,12),(40,17,22,2),(40,17,25,5),(40,17,37,1),(40,17,38,6),(40,17,40,12),(40,18,5,3),(40,18,7,10),(40,18,9,4),(40,18,15,5),(40,18,22,5),(40,18,38,1),(40,18,39,10),(40,19,3,4),(40,19,17,1),(40,19,25,3),(40,19,34,6),(40,19,40,0),(40,20,6,6),(40,20,22,1),(40,20,23,11),(40,20,26,4),(40,20,30,2),(40,20,39,4),(40,20,40,5),(40,20,42,12),(40,21,19,5),(40,21,23,13),(40,21,24,0),(40,21,25,12),(40,21,35,1),(40,21,38,5),(40,21,41,7),(40,22,8,7),(40,22,18,11),(40,22,22,10),(40,22,24,6),(40,22,28,12),(40,22,32,6),(40,22,36,5),(40,23,8,7),(40,23,14,12),(40,23,20,10),(40,23,24,7),(40,23,26,6),(40,23,29,0),(40,23,30,13),(40,23,36,6),(40,23,41,7),(40,24,11,10),(40,24,22,13),(40,24,26,0),(40,24,27,4),(40,24,36,4),(40,24,37,1),(40,24,40,3),(40,25,22,4),(40,25,23,6),(40,25,33,7),(40,25,38,3),(40,26,23,6),(40,26,31,0),(40,26,35,12),(40,26,49,6),(40,27,22,11),(40,27,33,4),(40,27,35,7),(40,27,36,6),(40,28,27,10),(40,28,29,5),(40,28,31,6),(40,28,32,1),(40,28,33,8),(40,28,35,1),(40,28,37,11),(40,29,9,5),(40,29,32,7),(40,29,33,10),(40,29,34,7),(40,29,35,12),(40,30,7,10),(40,30,16,3),(40,30,17,3),(40,30,21,1),(40,30,23,6),(40,30,27,10),(40,30,28,13),(40,30,34,3),(40,30,36,1);
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
INSERT INTO `galaxies` VALUES (1,'2010-11-03 16:40:37','dev');
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
INSERT INTO `solar_systems` VALUES (1,'Expansion',1,2,1),(2,'Expansion',1,0,2),(3,'Homeworld',1,1,1),(4,'Resource',1,0,0);
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
INSERT INTO `ss_objects` VALUES (1,1,40,26,1,45,'Planet',NULL,'P-1',52,2,0,0,0,0,0,0,0,0,0,'2010-11-03 16:40:40',0),(2,1,0,0,4,72,'Asteroid',NULL,'',29,0,0,0,2,0,0,1,0,0,3,NULL,0),(3,1,0,0,2,120,'Asteroid',NULL,'',49,0,0,0,3,0,0,1,0,0,1,NULL,0),(4,1,0,0,5,15,'Jumpgate',NULL,'',42,0,0,0,0,0,0,0,0,0,0,NULL,0),(5,1,0,0,3,292,'Asteroid',NULL,'',46,0,0,0,0,0,0,1,0,0,0,NULL,0),(6,1,0,0,4,108,'Asteroid',NULL,'',37,0,0,0,1,0,0,0,0,0,0,NULL,0),(7,1,0,0,3,112,'Asteroid',NULL,'',32,0,0,0,3,0,0,1,0,0,1,NULL,0),(8,1,0,0,4,198,'Asteroid',NULL,'',38,0,0,0,0,0,0,0,0,0,0,NULL,0),(9,1,0,0,2,150,'Asteroid',NULL,'',42,0,0,0,3,0,0,1,0,0,3,NULL,0),(10,1,0,0,3,44,'Asteroid',NULL,'',45,0,0,0,0,0,0,1,0,0,1,NULL,0),(11,1,31,46,2,180,'Planet',NULL,'P-11',57,2,0,0,0,0,0,0,0,0,0,'2010-11-03 16:40:40',0),(12,1,0,0,4,234,'Asteroid',NULL,'',40,0,0,0,0,0,0,0,0,0,0,NULL,0),(13,1,0,0,3,336,'Asteroid',NULL,'',28,0,0,0,0,0,0,0,0,0,1,NULL,0),(14,1,0,0,0,270,'Asteroid',NULL,'',58,0,0,0,1,0,0,1,0,0,0,NULL,0),(15,1,0,0,2,270,'Asteroid',NULL,'',44,0,0,0,2,0,0,2,0,0,2,NULL,0),(16,1,31,36,0,180,'Planet',NULL,'P-16',53,2,0,0,0,0,0,0,0,0,0,'2010-11-03 16:40:40',0),(17,1,0,0,0,0,'Asteroid',NULL,'',40,0,0,0,0,0,0,0,0,0,1,NULL,0),(18,2,47,27,3,112,'Planet',NULL,'P-18',56,0,0,0,0,0,0,0,0,0,0,'2010-11-03 16:40:40',0),(19,2,0,0,5,345,'Jumpgate',NULL,'',39,0,0,0,0,0,0,0,0,0,0,NULL,0),(20,2,0,0,4,180,'Asteroid',NULL,'',43,0,0,0,2,0,0,2,0,0,3,NULL,0),(21,2,0,0,3,22,'Asteroid',NULL,'',47,0,0,0,0,0,0,1,0,0,1,NULL,0),(22,2,0,0,2,210,'Asteroid',NULL,'',49,0,0,0,0,0,0,0,0,0,0,NULL,0),(23,2,0,0,0,270,'Asteroid',NULL,'',52,0,0,0,1,0,0,1,0,0,1,NULL,0),(24,2,0,0,3,202,'Asteroid',NULL,'',34,0,0,0,1,0,0,1,0,0,1,NULL,0),(25,2,0,0,3,90,'Asteroid',NULL,'',27,0,0,0,1,0,0,1,0,0,3,NULL,0),(26,3,0,0,2,90,'Asteroid',NULL,'',53,0,0,0,0,0,0,1,0,0,0,NULL,0),(27,3,28,42,4,198,'Planet',1,'P-27',54,0,864,1,3024,1728,2,6048,0,0,604.8,'2010-11-03 16:40:40',0),(28,3,0,0,0,90,'Asteroid',NULL,'',59,0,0,0,0,0,0,0,0,0,1,NULL,0),(29,3,0,0,3,22,'Asteroid',NULL,'',42,0,0,0,1,0,0,0,0,0,1,NULL,0),(30,3,32,25,3,246,'Planet',NULL,'P-30',48,1,0,0,0,0,0,0,0,0,0,'2010-11-03 16:40:40',0),(31,3,0,0,3,134,'Asteroid',NULL,'',32,0,0,0,0,0,0,1,0,0,1,NULL,0),(32,3,0,0,5,30,'Jumpgate',NULL,'',38,0,0,0,0,0,0,0,0,0,0,NULL,0),(33,3,0,0,4,144,'Asteroid',NULL,'',25,0,0,0,0,0,0,0,0,0,0,NULL,0),(34,4,0,0,5,210,'Jumpgate',NULL,'',39,0,0,0,0,0,0,0,0,0,0,NULL,0),(35,4,0,0,2,90,'Asteroid',NULL,'',34,0,0,0,3,0,0,1,0,0,1,NULL,0),(36,4,0,0,3,180,'Asteroid',NULL,'',29,0,0,0,1,0,0,3,0,0,3,NULL,0),(37,4,0,0,2,180,'Asteroid',NULL,'',36,0,0,0,2,0,0,1,0,0,2,NULL,0),(38,4,0,0,5,150,'Jumpgate',NULL,'',37,0,0,0,0,0,0,0,0,0,0,NULL,0),(39,4,0,0,1,180,'Asteroid',NULL,'',37,0,0,0,0,0,0,1,0,0,1,NULL,0),(40,4,31,50,3,270,'Planet',NULL,'P-40',58,2,0,0,0,0,0,0,0,0,0,'2010-11-03 16:40:40',0),(41,4,0,0,1,315,'Asteroid',NULL,'',41,0,0,0,3,0,0,3,0,0,1,NULL,0),(42,4,0,0,0,180,'Asteroid',NULL,'',55,0,0,0,1,0,0,2,0,0,2,NULL,0),(43,4,0,0,4,342,'Asteroid',NULL,'',43,0,0,0,3,0,0,3,0,0,1,NULL,0),(44,4,0,0,1,270,'Asteroid',NULL,'',58,0,0,0,0,0,0,0,0,0,0,NULL,0),(45,4,0,0,5,180,'Jumpgate',NULL,'',52,0,0,0,0,0,0,0,0,0,0,NULL,0);
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
INSERT INTO `tiles` VALUES (5,1,0,1),(5,1,0,2),(5,1,0,3),(5,1,0,4),(5,1,0,5),(5,1,0,6),(5,1,0,7),(14,1,0,14),(3,1,0,18),(3,1,0,19),(3,1,0,20),(3,1,0,21),(10,1,0,22),(5,1,1,2),(5,1,1,4),(5,1,1,5),(1,1,1,6),(5,1,2,4),(5,1,2,5),(5,1,3,3),(5,1,3,4),(5,1,3,5),(11,1,4,12),(10,1,8,10),(3,1,9,5),(3,1,9,6),(2,1,9,15),(2,1,9,19),(1,1,9,23),(3,1,10,4),(3,1,10,5),(5,1,10,25),(3,1,11,4),(3,1,11,5),(3,1,11,6),(3,1,11,7),(3,1,11,8),(5,1,11,22),(5,1,11,25),(3,1,12,3),(3,1,12,4),(3,1,12,5),(3,1,12,6),(3,1,12,7),(3,1,12,8),(3,1,12,9),(5,1,12,22),(5,1,12,23),(5,1,12,25),(13,1,13,3),(3,1,13,5),(3,1,13,6),(3,1,13,7),(3,1,13,8),(4,1,13,17),(4,1,13,18),(4,1,13,20),(5,1,13,23),(5,1,13,24),(5,1,13,25),(3,1,14,5),(14,1,14,6),(4,1,14,16),(4,1,14,17),(4,1,14,18),(4,1,14,19),(4,1,14,20),(4,1,14,21),(5,1,14,22),(5,1,14,23),(5,1,14,24),(5,1,14,25),(3,1,15,5),(4,1,15,15),(4,1,15,16),(4,1,15,17),(4,1,15,18),(4,1,15,20),(4,1,15,21),(4,1,15,22),(5,1,15,23),(5,1,15,24),(3,1,16,5),(4,1,16,14),(4,1,16,15),(4,1,16,16),(4,1,16,18),(4,1,16,19),(4,1,16,20),(4,1,16,21),(4,1,16,22),(4,1,16,23),(3,1,17,5),(3,1,17,6),(3,1,17,7),(3,1,17,8),(6,1,17,10),(6,1,17,11),(4,1,17,16),(4,1,17,17),(4,1,17,19),(4,1,17,20),(4,1,17,21),(4,1,17,22),(3,1,18,5),(5,1,18,6),(5,1,18,8),(6,1,18,9),(6,1,18,10),(6,1,18,11),(6,1,18,12),(4,1,18,19),(4,1,18,20),(4,1,18,21),(5,1,19,5),(5,1,19,6),(5,1,19,7),(5,1,19,8),(6,1,19,9),(6,1,19,10),(6,1,19,11),(4,1,19,19),(4,1,19,20),(4,1,19,21),(4,1,19,22),(11,1,20,0),(5,1,20,6),(5,1,20,7),(5,1,20,8),(5,1,20,9),(5,1,20,10),(5,1,20,11),(6,1,20,12),(4,1,20,20),(4,1,20,21),(4,1,20,22),(4,1,20,23),(5,1,21,6),(5,1,21,7),(6,1,21,8),(6,1,21,9),(6,1,21,10),(6,1,21,11),(6,1,21,12),(4,1,21,21),(4,1,21,22),(4,1,21,23),(5,1,22,7),(5,1,22,8),(6,1,22,9),(4,1,22,18),(4,1,22,19),(4,1,22,20),(4,1,22,21),(4,1,22,22),(4,1,22,23),(4,1,22,24),(5,1,23,7),(5,1,23,8),(6,1,23,9),(3,1,23,13),(4,1,23,20),(4,1,23,21),(4,1,23,22),(4,1,23,23),(4,1,23,24),(4,1,23,25),(5,1,24,4),(5,1,24,5),(5,1,24,7),(5,1,24,8),(6,1,24,9),(3,1,24,12),(3,1,24,13),(3,1,24,15),(4,1,24,21),(4,1,24,22),(4,1,24,23),(4,1,24,24),(4,1,24,25),(5,1,25,4),(5,1,25,5),(5,1,25,6),(5,1,25,7),(3,1,25,12),(3,1,25,14),(3,1,25,15),(4,1,25,21),(4,1,25,22),(4,1,25,24),(4,1,25,25),(5,1,26,4),(5,1,26,6),(5,1,26,7),(5,1,26,8),(3,1,26,10),(3,1,26,12),(3,1,26,13),(3,1,26,14),(3,1,26,15),(3,1,26,16),(4,1,26,20),(4,1,26,21),(4,1,26,22),(4,1,26,23),(4,1,26,24),(4,1,26,25),(5,1,27,0),(5,1,27,1),(4,1,27,9),(3,1,27,10),(3,1,27,11),(3,1,27,12),(3,1,27,13),(3,1,27,14),(3,1,27,15),(4,1,27,18),(4,1,27,19),(4,1,27,20),(4,1,27,21),(4,1,27,22),(4,1,27,23),(4,1,27,24),(3,1,27,25),(5,1,28,0),(5,1,28,1),(5,1,28,3),(4,1,28,7),(4,1,28,9),(3,1,28,11),(3,1,28,12),(3,1,28,13),(3,1,28,14),(3,1,28,15),(3,1,28,16),(3,1,28,17),(3,1,28,18),(3,1,28,19),(3,1,28,20),(3,1,28,21),(4,1,28,22),(3,1,28,23),(4,1,28,24),(3,1,28,25),(5,1,29,0),(5,1,29,1),(5,1,29,2),(5,1,29,3),(4,1,29,5),(4,1,29,6),(4,1,29,7),(4,1,29,8),(4,1,29,9),(4,1,29,10),(3,1,29,11),(3,1,29,12),(3,1,29,14),(3,1,29,15),(3,1,29,16),(3,1,29,17),(3,1,29,18),(3,1,29,19),(3,1,29,20),(3,1,29,21),(3,1,29,22),(3,1,29,23),(4,1,29,24),(3,1,29,25),(5,1,30,0),(5,1,30,2),(5,1,30,3),(4,1,30,6),(4,1,30,7),(4,1,30,8),(4,1,30,9),(4,1,30,10),(4,1,30,11),(3,1,30,12),(3,1,30,13),(3,1,30,15),(3,1,30,16),(3,1,30,17),(3,1,30,18),(3,1,30,19),(3,1,30,20),(3,1,30,22),(3,1,30,23),(4,1,30,24),(3,1,30,25),(5,1,31,0),(5,1,31,1),(4,1,31,8),(4,1,31,9),(6,1,31,10),(6,1,31,11),(6,1,31,12),(6,1,31,13),(3,1,31,17),(3,1,31,18),(3,1,31,19),(3,1,31,20),(3,1,31,22),(3,1,31,23),(3,1,31,24),(3,1,31,25),(5,1,32,1),(4,1,32,6),(4,1,32,7),(4,1,32,8),(4,1,32,9),(6,1,32,10),(6,1,32,11),(6,1,32,12),(6,1,32,13),(3,1,32,19),(3,1,32,20),(3,1,32,21),(3,1,32,22),(3,1,32,23),(3,1,32,24),(3,1,32,25),(6,1,33,11),(3,1,33,20),(3,1,33,22),(3,1,33,23),(3,1,33,24),(3,1,33,25),(3,1,34,22),(3,1,34,24),(3,1,34,25),(3,1,35,24),(3,1,35,25),(6,1,36,22),(3,1,36,25),(6,1,37,19),(6,1,37,20),(6,1,37,21),(6,1,37,22),(3,1,37,25),(6,1,38,21),(6,1,38,22),(6,1,39,21),(6,1,39,22),(12,11,0,18),(12,11,1,24),(2,11,1,31),(5,11,1,43),(5,11,2,43),(11,11,3,12),(5,11,3,40),(5,11,3,41),(5,11,3,42),(5,11,3,43),(14,11,4,30),(5,11,4,40),(5,11,4,41),(5,11,4,42),(5,11,4,43),(5,11,5,40),(5,11,5,41),(5,11,5,43),(4,11,6,34),(4,11,6,35),(5,11,6,39),(5,11,6,40),(5,11,6,43),(4,11,7,12),(4,11,7,13),(4,11,7,14),(4,11,7,15),(4,11,7,16),(3,11,7,22),(3,11,7,23),(3,11,7,24),(3,11,7,25),(4,11,7,29),(4,11,7,31),(4,11,7,32),(4,11,7,34),(4,11,7,35),(5,11,7,40),(5,11,7,41),(5,11,7,43),(4,11,8,11),(4,11,8,12),(4,11,8,13),(4,11,8,14),(4,11,8,15),(4,11,8,18),(3,11,8,24),(3,11,8,25),(4,11,8,29),(4,11,8,30),(4,11,8,31),(4,11,8,32),(4,11,8,33),(4,11,8,34),(4,11,8,35),(4,11,9,11),(4,11,9,12),(4,11,9,13),(4,11,9,14),(4,11,9,15),(4,11,9,16),(4,11,9,17),(4,11,9,18),(3,11,9,22),(3,11,9,23),(3,11,9,24),(3,11,9,25),(4,11,9,28),(4,11,9,30),(4,11,9,31),(4,11,9,32),(4,11,9,33),(4,11,9,34),(4,11,9,35),(4,11,9,36),(4,11,10,10),(4,11,10,11),(4,11,10,13),(4,11,10,14),(4,11,10,15),(4,11,10,18),(4,11,10,19),(3,11,10,22),(3,11,10,23),(3,11,10,24),(3,11,10,25),(3,11,10,26),(3,11,10,27),(4,11,10,28),(4,11,10,29),(4,11,10,30),(4,11,10,31),(4,11,10,32),(4,11,10,33),(4,11,10,34),(4,11,10,35),(4,11,10,36),(4,11,10,37),(4,11,10,38),(4,11,11,11),(4,11,11,13),(4,11,11,14),(4,11,11,15),(4,11,11,16),(4,11,11,19),(3,11,11,23),(3,11,11,24),(3,11,11,25),(3,11,11,26),(3,11,11,27),(4,11,11,28),(4,11,11,29),(4,11,11,30),(4,11,11,31),(4,11,11,32),(4,11,11,33),(4,11,11,34),(4,11,11,35),(4,11,11,36),(4,11,11,37),(4,11,11,39),(4,11,12,11),(4,11,12,19),(3,11,12,23),(3,11,12,26),(3,11,12,27),(3,11,12,30),(4,11,12,31),(4,11,12,32),(4,11,12,34),(4,11,12,35),(4,11,12,36),(4,11,12,37),(4,11,12,38),(4,11,12,39),(4,11,12,40),(4,11,12,41),(4,11,13,0),(4,11,13,1),(3,11,13,2),(3,11,13,3),(3,11,13,29),(3,11,13,30),(3,11,13,31),(3,11,13,32),(3,11,13,33),(4,11,13,34),(4,11,13,35),(4,11,13,36),(4,11,13,37),(4,11,13,39),(4,11,13,40),(4,11,13,41),(4,11,13,42),(1,11,13,43),(4,11,14,0),(3,11,14,2),(3,11,14,3),(3,11,14,4),(3,11,14,5),(3,11,14,6),(3,11,14,27),(3,11,14,28),(3,11,14,29),(3,11,14,30),(3,11,14,31),(5,11,14,33),(4,11,14,35),(4,11,14,36),(4,11,14,41),(4,11,15,0),(4,11,15,1),(3,11,15,3),(3,11,15,4),(3,11,15,5),(3,11,15,27),(3,11,15,28),(3,11,15,29),(3,11,15,30),(3,11,15,31),(3,11,15,32),(5,11,15,33),(5,11,15,34),(4,11,15,35),(4,11,15,36),(4,11,15,37),(6,11,15,38),(6,11,15,39),(4,11,16,0),(3,11,16,1),(3,11,16,2),(3,11,16,3),(3,11,16,4),(3,11,16,5),(3,11,16,6),(3,11,16,7),(3,11,16,8),(6,11,16,18),(6,11,16,19),(6,11,16,20),(6,11,16,21),(3,11,16,27),(3,11,16,28),(3,11,16,29),(3,11,16,30),(3,11,16,31),(3,11,16,32),(5,11,16,33),(5,11,16,34),(5,11,16,35),(5,11,16,36),(5,11,16,37),(6,11,16,39),(6,11,16,40),(4,11,17,0),(3,11,17,1),(3,11,17,2),(3,11,17,3),(3,11,17,5),(3,11,17,6),(6,11,17,19),(6,11,17,20),(6,11,17,21),(3,11,17,26),(3,11,17,27),(3,11,17,29),(10,11,17,30),(5,11,17,34),(5,11,17,35),(5,11,17,36),(5,11,17,37),(6,11,17,38),(6,11,17,39),(6,11,17,40),(6,11,17,41),(4,11,18,0),(4,11,18,1),(4,11,18,2),(3,11,18,3),(4,11,18,4),(4,11,18,6),(6,11,18,11),(6,11,18,12),(6,11,18,13),(6,11,18,19),(6,11,18,21),(6,11,18,22),(5,11,18,34),(5,11,18,35),(5,11,18,36),(5,11,18,37),(6,11,18,38),(6,11,18,39),(6,11,18,40),(4,11,19,0),(4,11,19,1),(4,11,19,2),(4,11,19,3),(4,11,19,4),(4,11,19,5),(4,11,19,6),(5,11,19,10),(6,11,19,11),(6,11,19,12),(6,11,19,13),(6,11,19,20),(6,11,19,21),(6,11,19,22),(6,11,19,23),(6,11,19,24),(5,11,19,34),(5,11,19,35),(5,11,19,36),(6,11,19,38),(6,11,19,39),(6,11,19,40),(6,11,19,41),(4,11,20,0),(4,11,20,1),(4,11,20,2),(4,11,20,3),(4,11,20,5),(5,11,20,8),(5,11,20,9),(5,11,20,10),(5,11,20,11),(6,11,20,12),(6,11,20,13),(6,11,20,14),(6,11,20,15),(6,11,20,22),(6,11,20,40),(4,11,21,0),(4,11,21,1),(4,11,21,2),(4,11,21,3),(4,11,21,4),(5,11,21,8),(5,11,21,9),(5,11,21,10),(5,11,21,11),(5,11,21,12),(5,11,21,13),(6,11,21,14),(6,11,21,15),(4,11,22,0),(4,11,22,4),(5,11,22,8),(5,11,22,9),(5,11,22,10),(5,11,22,11),(5,11,22,12),(6,11,22,13),(6,11,22,14),(6,11,22,15),(4,11,23,0),(4,11,23,1),(4,11,23,2),(4,11,23,4),(4,11,23,5),(4,11,23,6),(5,11,23,11),(5,11,23,12),(5,11,23,13),(6,11,23,15),(10,11,23,30),(13,11,23,40),(4,11,24,0),(4,11,24,1),(4,11,24,2),(4,11,24,3),(4,11,24,4),(4,11,24,5),(4,11,24,6),(3,11,24,8),(3,11,24,9),(3,11,24,10),(3,11,24,11),(3,11,24,12),(5,11,24,19),(4,11,25,0),(4,11,25,1),(4,11,25,2),(4,11,25,3),(4,11,25,4),(4,11,25,5),(4,11,25,6),(4,11,25,7),(4,11,25,8),(3,11,25,9),(3,11,25,10),(3,11,25,11),(5,11,25,14),(5,11,25,15),(5,11,25,16),(5,11,25,17),(5,11,25,19),(4,11,26,0),(4,11,26,1),(4,11,26,3),(4,11,26,4),(4,11,26,5),(4,11,26,7),(4,11,26,8),(5,11,26,9),(3,11,26,10),(3,11,26,11),(3,11,26,12),(5,11,26,17),(5,11,26,18),(5,11,26,19),(2,11,26,43),(4,11,27,1),(4,11,27,3),(4,11,27,4),(5,11,27,5),(5,11,27,6),(5,11,27,7),(5,11,27,8),(5,11,27,9),(3,11,27,10),(3,11,27,11),(3,11,27,12),(3,11,27,13),(5,11,27,15),(5,11,27,16),(5,11,27,17),(5,11,27,18),(5,11,27,19),(5,11,27,20),(9,11,27,30),(9,11,27,33),(4,11,28,3),(4,11,28,4),(5,11,28,5),(5,11,28,6),(5,11,28,7),(5,11,28,8),(5,11,28,9),(3,11,28,10),(3,11,28,11),(3,11,28,12),(3,11,28,13),(3,11,28,14),(5,11,28,15),(5,11,28,17),(5,11,28,19),(4,11,29,1),(4,11,29,2),(4,11,29,3),(5,11,29,4),(5,11,29,5),(5,11,29,7),(3,11,29,10),(3,11,29,11),(3,11,29,12),(5,11,29,17),(5,11,30,3),(5,11,30,4),(5,11,30,5),(5,11,30,6),(5,11,30,7),(3,11,30,11),(13,16,2,0),(8,16,3,3),(3,16,3,13),(3,16,3,14),(3,16,3,15),(3,16,3,16),(6,16,3,27),(3,16,4,12),(3,16,4,13),(3,16,4,14),(3,16,4,15),(3,16,4,16),(6,16,4,26),(6,16,4,27),(3,16,5,11),(3,16,5,12),(3,16,5,13),(3,16,5,14),(5,16,5,17),(5,16,5,18),(6,16,5,26),(6,16,5,27),(6,16,5,28),(3,16,6,13),(3,16,6,14),(3,16,6,15),(3,16,6,16),(5,16,6,17),(5,16,6,18),(5,16,6,19),(6,16,6,26),(6,16,6,27),(3,16,7,12),(3,16,7,13),(3,16,7,14),(3,16,7,15),(5,16,7,16),(5,16,7,17),(5,16,7,18),(5,16,7,20),(5,16,7,21),(3,16,8,11),(3,16,8,12),(3,16,8,13),(3,16,8,14),(5,16,8,15),(5,16,8,16),(5,16,8,17),(5,16,8,18),(5,16,8,19),(5,16,8,20),(5,16,8,21),(5,16,8,22),(5,16,8,23),(4,16,8,28),(4,16,8,31),(2,16,9,2),(3,16,9,10),(3,16,9,11),(3,16,9,12),(3,16,9,13),(3,16,9,14),(5,16,9,15),(5,16,9,16),(5,16,9,17),(5,16,9,18),(5,16,9,19),(5,16,9,20),(5,16,9,22),(4,16,9,28),(4,16,9,29),(4,16,9,30),(4,16,9,31),(3,16,10,12),(5,16,10,16),(5,16,10,17),(5,16,10,18),(5,16,10,19),(5,16,10,20),(5,16,10,21),(4,16,10,27),(4,16,10,28),(4,16,10,29),(4,16,10,30),(4,16,10,31),(3,16,11,12),(5,16,11,15),(5,16,11,16),(5,16,11,17),(4,16,11,18),(5,16,11,19),(5,16,11,20),(5,16,11,21),(6,16,11,22),(6,16,11,23),(6,16,11,24),(4,16,11,28),(4,16,11,29),(4,16,11,30),(4,16,11,31),(4,16,11,32),(5,16,12,15),(5,16,12,16),(4,16,12,17),(4,16,12,18),(5,16,12,19),(5,16,12,21),(6,16,12,22),(6,16,12,23),(6,16,12,24),(4,16,12,28),(4,16,12,29),(4,16,12,30),(13,16,13,0),(6,16,13,4),(5,16,13,15),(4,16,13,17),(4,16,13,18),(4,16,13,20),(6,16,13,22),(6,16,13,24),(4,16,13,27),(4,16,13,28),(4,16,13,29),(4,16,13,30),(4,16,13,31),(4,16,13,32),(6,16,14,3),(6,16,14,4),(6,16,14,5),(4,16,14,15),(4,16,14,16),(4,16,14,18),(4,16,14,19),(4,16,14,20),(4,16,14,29),(4,16,14,31),(4,16,14,32),(3,16,14,33),(6,16,15,2),(6,16,15,3),(6,16,15,4),(6,16,15,5),(4,16,15,15),(4,16,15,18),(4,16,15,19),(4,16,15,20),(4,16,15,23),(4,16,15,32),(3,16,15,33),(4,16,16,14),(4,16,16,15),(4,16,16,16),(4,16,16,17),(4,16,16,18),(4,16,16,19),(4,16,16,22),(4,16,16,23),(3,16,16,33),(3,16,16,34),(3,16,16,35),(4,16,17,15),(4,16,17,17),(4,16,17,18),(4,16,17,19),(4,16,17,21),(4,16,17,22),(4,16,17,23),(4,16,17,24),(4,16,17,25),(3,16,17,29),(3,16,17,30),(3,16,17,31),(3,16,17,32),(3,16,17,33),(3,16,17,34),(4,16,18,17),(4,16,18,19),(4,16,18,20),(4,16,18,21),(4,16,18,22),(4,16,18,23),(4,16,18,24),(4,16,18,25),(4,16,18,26),(3,16,18,29),(3,16,18,30),(3,16,18,31),(3,16,18,33),(3,16,18,34),(3,16,18,35),(4,16,19,17),(4,16,19,18),(3,16,19,19),(3,16,19,20),(3,16,19,21),(4,16,19,22),(4,16,19,23),(4,16,19,24),(4,16,19,25),(4,16,19,26),(4,16,19,27),(3,16,19,29),(3,16,19,30),(3,16,19,31),(3,16,19,32),(3,16,19,33),(3,16,19,34),(3,16,19,35),(6,16,20,4),(4,16,20,17),(3,16,20,19),(3,16,20,20),(4,16,20,21),(4,16,20,22),(4,16,20,24),(4,16,20,25),(5,16,20,30),(3,16,20,31),(3,16,20,32),(3,16,20,33),(3,16,20,34),(3,16,20,35),(1,16,21,2),(6,16,21,4),(3,16,21,19),(3,16,21,20),(3,16,21,21),(3,16,21,22),(3,16,21,23),(3,16,21,24),(4,16,21,25),(5,16,21,28),(5,16,21,29),(5,16,21,30),(5,16,21,31),(3,16,21,32),(3,16,21,33),(6,16,21,34),(3,16,21,35),(6,16,22,4),(6,16,22,5),(6,16,22,6),(6,16,22,7),(3,16,22,20),(3,16,22,21),(3,16,22,22),(3,16,22,23),(3,16,22,24),(4,16,22,25),(4,16,22,26),(5,16,22,27),(5,16,22,28),(5,16,22,29),(5,16,22,30),(5,16,22,31),(5,16,22,32),(6,16,22,33),(6,16,22,34),(6,16,22,35),(6,16,23,5),(6,16,23,6),(5,16,23,7),(3,16,23,19),(3,16,23,20),(3,16,23,21),(3,16,23,22),(3,16,23,23),(5,16,23,24),(5,16,23,25),(5,16,23,26),(5,16,23,27),(5,16,23,28),(5,16,23,29),(5,16,23,30),(5,16,23,31),(5,16,23,32),(6,16,23,33),(6,16,23,34),(3,16,24,18),(3,16,24,19),(3,16,24,20),(3,16,24,21),(5,16,24,22),(5,16,24,23),(5,16,24,26),(5,16,24,27),(5,16,24,28),(5,16,24,29),(5,16,24,30),(5,16,24,31),(5,16,24,32),(5,16,24,33),(6,16,24,34),(6,16,24,35),(3,16,25,16),(3,16,25,17),(3,16,25,18),(3,16,25,19),(3,16,25,20),(3,16,25,21),(3,16,25,22),(5,16,25,23),(5,16,25,24),(5,16,25,25),(5,16,25,26),(5,16,25,27),(5,16,25,28),(5,16,25,29),(5,16,25,30),(5,16,25,31),(5,16,25,32),(5,16,25,33),(5,16,25,34),(5,16,25,35),(3,16,26,16),(3,16,26,18),(3,16,26,19),(3,16,26,20),(5,16,26,21),(5,16,26,22),(5,16,26,23),(5,16,26,24),(5,16,26,25),(5,16,26,26),(5,16,26,27),(5,16,26,28),(5,16,26,29),(5,16,26,30),(5,16,26,31),(5,16,26,32),(5,16,26,33),(5,16,26,34),(5,16,26,35),(3,16,27,14),(3,16,27,18),(3,16,27,19),(3,16,27,20),(5,16,27,22),(5,16,27,24),(5,16,27,25),(5,16,27,26),(5,16,27,28),(5,16,27,33),(5,16,27,34),(5,16,27,35),(8,16,28,6),(3,16,28,14),(3,16,28,15),(3,16,28,18),(3,16,28,19),(3,16,28,20),(3,16,28,21),(5,16,28,24),(5,16,28,25),(5,16,28,28),(5,16,28,33),(5,16,28,35),(3,16,29,14),(3,16,29,15),(3,16,29,17),(3,16,29,18),(3,16,29,19),(3,16,29,20),(3,16,29,21),(3,16,29,22),(5,16,29,23),(5,16,29,24),(5,16,29,25),(5,16,29,26),(5,16,29,27),(5,16,29,28),(5,16,29,35),(3,16,30,12),(3,16,30,13),(3,16,30,14),(3,16,30,15),(3,16,30,16),(3,16,30,17),(3,16,30,18),(3,16,30,19),(3,16,30,20),(3,16,30,21),(5,16,30,22),(5,16,30,23),(5,16,30,24),(5,16,30,25),(5,16,30,26),(5,16,30,27),(5,16,30,28),(5,16,30,35),(4,18,0,6),(4,18,0,7),(4,18,0,8),(4,18,0,9),(4,18,0,10),(4,18,0,11),(4,18,0,12),(4,18,1,4),(4,18,1,6),(4,18,1,7),(4,18,1,8),(4,18,1,9),(4,18,1,10),(4,18,1,21),(4,18,1,22),(4,18,1,23),(4,18,2,4),(4,18,2,5),(4,18,2,6),(4,18,2,7),(4,18,2,8),(4,18,2,9),(4,18,2,19),(4,18,2,20),(4,18,2,21),(4,18,2,22),(4,18,2,23),(4,18,2,24),(4,18,3,5),(4,18,3,6),(4,18,3,7),(4,18,3,8),(4,18,3,9),(4,18,3,10),(4,18,3,21),(4,18,3,22),(4,18,3,23),(4,18,3,24),(4,18,3,25),(4,18,4,8),(4,18,4,9),(4,18,4,22),(4,18,4,23),(4,18,4,24),(4,18,4,25),(4,18,4,26),(4,18,5,7),(4,18,5,8),(4,18,5,9),(4,18,5,21),(4,18,5,22),(4,18,5,23),(4,18,5,24),(4,18,5,25),(4,18,5,26),(4,18,6,22),(4,18,6,24),(4,18,6,25),(4,18,7,24),(4,18,7,25),(5,18,8,9),(5,18,8,10),(5,18,9,7),(5,18,9,8),(5,18,9,10),(5,18,9,11),(5,18,9,12),(5,18,10,6),(5,18,10,7),(5,18,10,8),(5,18,10,9),(5,18,10,10),(5,18,11,8),(5,18,11,9),(5,18,11,10),(5,18,11,11),(5,18,11,12),(5,18,12,8),(5,18,12,9),(3,18,13,17),(6,18,14,5),(6,18,14,6),(3,18,14,17),(3,18,14,18),(6,18,15,3),(6,18,15,4),(6,18,15,5),(6,18,15,6),(3,18,15,16),(3,18,15,17),(3,18,15,18),(3,18,15,19),(6,18,16,3),(6,18,16,4),(6,18,16,5),(3,18,16,16),(3,18,16,17),(3,18,16,18),(3,18,16,19),(6,18,17,5),(6,18,17,6),(6,18,17,7),(5,18,17,14),(3,18,17,15),(3,18,17,16),(3,18,17,17),(3,18,17,18),(3,18,17,19),(3,18,17,20),(3,18,17,21),(3,18,17,22),(3,18,17,24),(6,18,18,5),(5,18,18,13),(5,18,18,14),(5,18,18,15),(3,18,18,16),(3,18,18,17),(3,18,18,18),(3,18,18,19),(3,18,18,20),(3,18,18,22),(3,18,18,23),(3,18,18,24),(6,18,19,5),(5,18,19,9),(5,18,19,10),(5,18,19,11),(5,18,19,12),(5,18,19,13),(5,18,19,14),(5,18,19,15),(3,18,19,16),(3,18,19,17),(3,18,19,18),(3,18,19,19),(3,18,19,20),(3,18,19,21),(3,18,19,22),(3,18,19,23),(3,18,19,24),(5,18,20,11),(5,18,20,12),(5,18,20,13),(5,18,20,14),(5,18,20,15),(3,18,20,16),(3,18,20,17),(3,18,20,18),(3,18,20,19),(3,18,20,20),(3,18,20,21),(3,18,20,22),(3,18,20,23),(3,18,20,24),(6,18,20,25),(6,18,21,7),(6,18,21,9),(5,18,21,12),(5,18,21,14),(3,18,21,15),(3,18,21,16),(3,18,21,17),(3,18,21,18),(3,18,21,19),(3,18,21,20),(3,18,21,21),(3,18,21,22),(3,18,21,23),(6,18,21,24),(6,18,21,25),(3,18,22,0),(6,18,22,7),(6,18,22,9),(6,18,22,10),(5,18,22,12),(5,18,22,13),(5,18,22,14),(5,18,22,15),(5,18,22,16),(5,18,22,17),(3,18,22,18),(3,18,22,19),(3,18,22,20),(3,18,22,21),(3,18,22,22),(3,18,22,23),(6,18,22,24),(6,18,22,25),(3,18,23,0),(3,18,23,1),(3,18,23,2),(6,18,23,6),(6,18,23,7),(6,18,23,8),(6,18,23,9),(6,18,23,10),(5,18,23,12),(5,18,23,13),(5,18,23,14),(5,18,23,15),(5,18,23,16),(5,18,23,17),(3,18,23,18),(3,18,23,20),(3,18,23,21),(6,18,23,22),(6,18,23,23),(6,18,23,24),(6,18,23,25),(3,18,24,0),(3,18,24,1),(3,18,24,2),(3,18,24,3),(3,18,24,4),(3,18,24,5),(3,18,24,6),(6,18,24,7),(6,18,24,9),(6,18,24,10),(6,18,24,11),(5,18,24,12),(5,18,24,13),(5,18,24,14),(5,18,24,15),(5,18,24,16),(3,18,24,20),(3,18,24,21),(6,18,24,22),(6,18,24,23),(6,18,24,24),(3,18,25,0),(3,18,25,1),(3,18,25,2),(3,18,25,3),(3,18,25,4),(3,18,25,5),(3,18,25,6),(3,18,25,7),(4,18,25,10),(4,18,25,11),(5,18,25,15),(5,18,25,16),(6,18,25,23),(6,18,25,24),(3,18,26,0),(3,18,26,1),(3,18,26,2),(3,18,26,3),(3,18,26,5),(4,18,26,10),(4,18,26,11),(5,18,26,15),(3,18,27,0),(3,18,27,1),(3,18,27,2),(3,18,27,3),(3,18,27,4),(3,18,27,5),(4,18,27,9),(4,18,27,10),(4,18,27,11),(3,18,28,1),(3,18,28,2),(3,18,28,3),(4,18,28,10),(4,18,29,9),(4,18,29,10),(4,18,29,11),(4,18,29,12),(4,18,29,13),(4,18,30,8),(4,18,30,9),(4,18,30,10),(4,18,30,11),(4,18,30,12),(4,18,30,13),(4,18,31,10),(4,18,31,11),(4,18,31,12),(4,18,31,13),(4,18,31,14),(4,18,31,15),(3,18,32,7),(4,18,32,9),(4,18,32,10),(4,18,32,11),(4,18,32,12),(3,18,33,7),(1,18,33,8),(4,18,33,11),(10,18,33,23),(3,18,34,0),(3,18,34,1),(3,18,34,2),(3,18,34,5),(3,18,34,6),(3,18,34,7),(4,18,34,16),(4,18,34,17),(3,18,35,0),(3,18,35,1),(3,18,35,2),(3,18,35,3),(3,18,35,4),(3,18,35,5),(3,18,35,6),(3,18,35,7),(3,18,35,8),(4,18,35,16),(4,18,35,17),(3,18,36,0),(3,18,36,1),(3,18,36,2),(3,18,36,3),(3,18,36,4),(3,18,36,5),(4,18,36,14),(4,18,36,15),(4,18,36,16),(4,18,36,17),(4,18,36,18),(4,18,36,19),(4,18,36,20),(4,18,36,21),(4,18,36,22),(3,18,37,0),(3,18,37,1),(3,18,37,2),(3,18,37,3),(11,18,37,12),(4,18,37,18),(4,18,37,19),(4,18,37,20),(4,18,37,21),(4,18,37,22),(4,18,37,23),(4,18,37,24),(13,18,37,25),(3,18,38,0),(3,18,38,1),(3,18,38,2),(3,18,38,3),(4,18,38,18),(4,18,38,19),(4,18,38,20),(4,18,38,21),(2,18,38,22),(4,18,39,0),(3,18,39,1),(3,18,39,3),(4,18,39,18),(4,18,39,19),(4,18,39,20),(4,18,39,21),(4,18,40,0),(6,18,40,9),(4,18,40,21),(4,18,40,22),(4,18,41,0),(4,18,41,1),(4,18,41,3),(6,18,41,7),(6,18,41,8),(6,18,41,9),(6,18,41,10),(6,18,41,11),(5,18,41,12),(5,18,41,13),(5,18,41,14),(4,18,42,0),(4,18,42,1),(4,18,42,2),(4,18,42,3),(6,18,42,7),(6,18,42,8),(6,18,42,9),(6,18,42,10),(6,18,42,11),(6,18,42,12),(5,18,42,13),(4,18,43,0),(4,18,43,1),(4,18,43,3),(4,18,43,4),(6,18,43,8),(6,18,43,9),(5,18,43,10),(5,18,43,11),(5,18,43,12),(5,18,43,13),(5,18,43,14),(8,18,43,24),(4,18,44,0),(4,18,44,3),(4,18,44,4),(5,18,44,10),(5,18,44,11),(5,18,44,12),(5,18,44,14),(1,18,44,15),(2,18,44,21),(4,18,45,0),(4,18,45,1),(4,18,45,2),(4,18,45,3),(4,18,45,4),(4,18,45,5),(5,18,45,10),(5,18,45,12),(4,18,46,0),(4,18,46,1),(4,18,46,2),(4,18,46,3),(4,18,46,4),(4,18,46,5),(4,18,46,6),(4,18,46,7),(5,18,46,9),(5,18,46,10),(5,18,46,11),(5,18,46,12),(5,27,0,0),(5,27,0,1),(5,27,0,2),(5,27,0,3),(5,27,0,15),(5,27,0,16),(5,27,0,17),(5,27,0,18),(5,27,0,19),(5,27,0,20),(5,27,0,21),(5,27,0,22),(5,27,0,23),(5,27,0,24),(5,27,0,25),(5,27,0,26),(5,27,1,0),(5,27,1,1),(5,27,1,2),(5,27,1,3),(4,27,1,7),(4,27,1,8),(4,27,1,9),(4,27,1,10),(13,27,1,12),(5,27,1,16),(5,27,1,17),(5,27,1,18),(11,27,1,20),(5,27,1,26),(5,27,2,0),(5,27,2,1),(5,27,2,2),(4,27,2,6),(4,27,2,7),(4,27,2,8),(4,27,2,9),(5,27,2,14),(5,27,2,15),(5,27,2,16),(5,27,2,17),(5,27,2,19),(5,27,2,26),(5,27,2,27),(5,27,3,0),(5,27,3,1),(4,27,3,5),(4,27,3,6),(4,27,3,7),(4,27,3,8),(4,27,3,9),(5,27,3,15),(5,27,3,16),(5,27,3,17),(5,27,3,18),(5,27,3,19),(5,27,4,1),(5,27,4,2),(5,27,4,3),(4,27,4,6),(4,27,4,7),(4,27,4,8),(6,27,4,11),(5,27,4,16),(5,27,4,17),(5,27,5,2),(5,27,5,3),(4,27,5,5),(4,27,5,6),(4,27,5,7),(6,27,5,10),(6,27,5,11),(6,27,5,20),(6,27,5,21),(6,27,6,10),(6,27,6,11),(6,27,6,18),(6,27,6,20),(6,27,6,21),(6,27,6,22),(12,27,7,1),(6,27,7,11),(6,27,7,19),(6,27,7,20),(6,27,8,11),(6,27,8,12),(6,27,8,13),(6,27,8,19),(6,27,8,20),(6,27,9,12),(6,27,9,13),(6,27,9,14),(6,27,9,20),(3,27,9,25),(3,27,9,26),(6,27,10,12),(6,27,10,13),(8,27,10,22),(3,27,10,25),(3,27,10,26),(3,27,10,27),(3,27,10,29),(3,27,11,26),(3,27,11,27),(3,27,11,28),(3,27,11,29),(3,27,12,27),(3,27,12,28),(3,27,12,29),(3,27,13,25),(3,27,13,27),(3,27,13,28),(3,27,13,29),(3,27,14,25),(3,27,14,26),(3,27,14,27),(3,27,14,28),(3,27,14,29),(3,27,15,25),(3,27,15,26),(3,27,15,27),(3,27,15,28),(3,27,15,29),(5,27,16,0),(3,27,16,26),(3,27,16,27),(3,27,16,28),(3,27,16,29),(5,27,17,0),(5,27,17,1),(3,27,17,25),(3,27,17,26),(3,27,17,27),(3,27,17,28),(3,27,17,29),(5,27,18,0),(5,27,18,1),(3,27,18,24),(3,27,18,25),(3,27,18,26),(3,27,18,27),(3,27,18,28),(3,27,18,29),(5,27,19,0),(3,27,19,24),(3,27,19,25),(3,27,19,26),(3,27,19,27),(3,27,19,28),(3,27,19,29),(5,27,20,0),(5,27,20,1),(3,27,20,24),(3,27,20,25),(3,27,20,26),(3,27,20,27),(3,27,20,28),(3,27,20,29),(5,27,21,0),(3,27,21,25),(3,27,21,26),(3,27,21,27),(3,27,21,28),(3,27,21,29),(5,27,22,0),(14,27,22,1),(3,27,22,27),(3,27,22,28),(3,27,22,29),(5,27,23,0),(4,27,23,20),(3,27,23,26),(3,27,23,27),(3,27,23,28),(3,27,23,29),(5,27,24,0),(4,27,24,18),(4,27,24,19),(4,27,24,20),(4,27,24,21),(4,27,24,22),(3,27,24,27),(3,27,24,28),(5,27,25,0),(5,27,25,2),(4,27,25,19),(4,27,25,20),(4,27,25,21),(4,27,25,22),(5,27,26,0),(5,27,26,1),(5,27,26,2),(6,27,26,6),(6,27,26,7),(2,27,26,16),(4,27,26,19),(4,27,26,20),(4,27,26,21),(4,27,26,22),(4,27,26,23),(6,27,27,5),(6,27,27,6),(5,27,27,7),(5,27,27,8),(5,27,27,11),(5,27,27,12),(4,27,27,19),(4,27,27,20),(4,27,27,21),(4,27,27,22),(4,27,27,23),(4,27,27,24),(5,27,28,1),(5,27,28,2),(5,27,28,3),(5,27,28,4),(6,27,28,5),(6,27,28,6),(5,27,28,7),(5,27,28,8),(5,27,28,10),(5,27,28,11),(5,27,28,12),(5,27,28,13),(5,27,28,14),(4,27,28,19),(4,27,28,20),(4,27,28,21),(4,27,28,22),(4,27,28,23),(5,27,29,2),(6,27,29,3),(6,27,29,4),(6,27,29,5),(6,27,29,6),(5,27,29,7),(5,27,29,8),(5,27,29,9),(5,27,29,10),(5,27,29,11),(5,27,29,12),(5,27,29,13),(4,27,29,18),(4,27,29,19),(4,27,29,20),(4,27,29,21),(4,27,29,22),(5,30,0,7),(5,30,0,8),(5,30,0,9),(5,30,0,10),(5,30,0,11),(5,30,0,14),(3,30,0,15),(3,30,0,16),(3,30,0,17),(3,30,0,18),(3,30,0,19),(5,30,1,8),(5,30,1,9),(5,30,1,10),(5,30,1,11),(5,30,1,13),(5,30,1,14),(3,30,1,15),(3,30,1,16),(3,30,1,17),(3,30,1,18),(3,30,1,19),(3,30,1,20),(5,30,2,10),(5,30,2,11),(5,30,2,12),(5,30,2,13),(5,30,2,14),(3,30,2,15),(3,30,2,16),(3,30,2,17),(3,30,2,18),(5,30,3,10),(5,30,3,11),(5,30,3,12),(5,30,3,13),(5,30,3,14),(3,30,3,15),(3,30,3,16),(3,30,3,17),(3,30,3,18),(3,30,3,19),(4,30,4,4),(5,30,4,8),(5,30,4,9),(5,30,4,10),(5,30,4,11),(5,30,4,12),(5,30,4,13),(3,30,4,15),(3,30,4,17),(4,30,5,3),(4,30,5,4),(4,30,5,5),(4,30,5,6),(5,30,5,9),(5,30,5,10),(5,30,5,11),(5,30,5,12),(5,30,5,13),(3,30,5,17),(3,30,5,18),(4,30,6,4),(4,30,6,5),(4,30,6,6),(4,30,6,7),(5,30,6,9),(5,30,6,12),(5,30,6,13),(5,30,6,14),(3,30,6,17),(3,30,6,18),(4,30,7,4),(4,30,7,5),(4,30,7,6),(5,30,7,8),(5,30,7,9),(5,30,7,10),(5,30,7,11),(5,30,7,14),(5,30,7,15),(4,30,8,3),(4,30,8,4),(4,30,8,5),(4,30,8,6),(4,30,8,7),(5,30,8,9),(5,30,8,10),(5,30,8,13),(5,30,8,14),(4,30,9,5),(4,30,9,6),(5,30,9,8),(5,30,9,9),(5,30,9,11),(5,30,9,12),(5,30,9,13),(5,30,9,14),(5,30,9,15),(5,30,10,8),(5,30,10,9),(5,30,10,10),(5,30,10,11),(5,30,10,12),(5,30,10,23),(5,30,11,8),(5,30,11,9),(5,30,11,10),(5,30,11,11),(5,30,11,12),(5,30,11,23),(14,30,12,1),(10,30,12,6),(5,30,12,10),(5,30,12,11),(5,30,12,12),(5,30,12,22),(5,30,12,23),(5,30,13,10),(5,30,13,11),(11,30,13,12),(5,30,13,22),(5,30,13,23),(5,30,13,24),(5,30,14,11),(5,30,14,21),(5,30,14,22),(5,30,14,23),(5,30,14,24),(5,30,15,18),(5,30,15,21),(5,30,15,22),(5,30,15,23),(5,30,15,24),(1,30,16,3),(5,30,16,18),(5,30,16,19),(5,30,16,20),(5,30,16,21),(5,30,16,22),(5,30,16,23),(5,30,16,24),(3,30,17,16),(3,30,17,17),(5,30,17,18),(5,30,17,20),(5,30,17,22),(5,30,17,23),(5,30,17,24),(2,30,18,8),(3,30,18,16),(2,30,18,17),(3,30,18,19),(5,30,18,20),(1,30,18,21),(5,30,18,23),(5,30,18,24),(6,30,19,11),(3,30,19,16),(3,30,19,19),(5,30,19,23),(5,30,19,24),(6,30,20,9),(6,30,20,10),(6,30,20,11),(3,30,20,16),(3,30,20,17),(3,30,20,18),(3,30,20,19),(3,30,20,20),(3,30,20,21),(3,30,20,22),(3,30,20,23),(5,30,20,24),(6,30,21,9),(6,30,21,10),(6,30,21,11),(6,30,21,12),(4,30,21,13),(3,30,21,14),(3,30,21,15),(3,30,21,16),(3,30,21,17),(3,30,21,18),(3,30,21,19),(3,30,21,20),(3,30,21,21),(3,30,21,22),(3,30,21,23),(5,30,21,24),(6,30,22,9),(4,30,22,13),(4,30,22,14),(4,30,22,15),(3,30,22,16),(3,30,22,17),(3,30,22,18),(3,30,22,19),(3,30,22,20),(3,30,22,21),(3,30,22,22),(3,30,22,23),(3,30,22,24),(6,30,23,0),(6,30,23,1),(6,30,23,2),(6,30,23,9),(4,30,23,12),(4,30,23,13),(3,30,23,17),(3,30,23,18),(3,30,23,20),(3,30,23,21),(3,30,23,22),(6,30,24,0),(6,30,24,1),(4,30,24,10),(4,30,24,12),(4,30,24,13),(3,30,24,17),(3,30,24,20),(3,30,24,21),(3,30,24,22),(3,30,24,23),(6,30,25,0),(6,30,25,1),(6,30,25,2),(4,30,25,10),(4,30,25,11),(4,30,25,12),(4,30,25,13),(4,30,25,14),(3,30,25,19),(3,30,25,20),(3,30,25,21),(3,30,25,22),(3,30,25,23),(6,30,26,0),(6,30,26,2),(6,30,26,6),(4,30,26,9),(4,30,26,10),(4,30,26,13),(4,30,26,14),(3,30,26,22),(3,30,26,23),(3,30,26,24),(6,30,27,4),(6,30,27,5),(6,30,27,6),(4,30,27,13),(4,30,27,14),(3,30,27,24),(6,30,28,4),(6,30,28,5),(6,30,28,6),(6,30,28,7),(6,30,28,8),(4,30,28,9),(4,30,28,10),(4,30,28,11),(4,30,28,12),(4,30,28,13),(4,30,28,14),(4,30,28,15),(4,30,28,16),(3,30,28,24),(6,30,29,5),(4,30,29,11),(4,30,29,12),(4,30,29,13),(4,30,29,14),(4,30,29,15),(4,30,29,16),(6,30,29,19),(6,30,29,21),(4,30,30,13),(4,30,30,15),(4,30,30,16),(4,30,30,17),(6,30,30,18),(6,30,30,19),(6,30,30,20),(6,30,30,21),(6,30,30,22),(6,30,31,18),(6,30,31,19),(6,30,31,20),(5,40,0,2),(5,40,0,3),(6,40,0,40),(6,40,0,41),(6,40,0,42),(5,40,1,2),(5,40,1,3),(5,40,1,6),(6,40,1,38),(6,40,1,39),(6,40,1,40),(6,40,1,41),(6,40,1,42),(1,40,1,43),(5,40,2,3),(5,40,2,4),(5,40,2,5),(5,40,2,6),(5,40,2,7),(6,40,2,40),(6,40,2,41),(6,40,2,42),(5,40,3,3),(5,40,3,4),(5,40,3,5),(5,40,3,6),(5,40,3,7),(5,40,3,8),(6,40,3,36),(6,40,3,41),(6,40,3,42),(5,40,4,6),(6,40,4,36),(5,40,5,6),(5,40,5,33),(6,40,5,35),(6,40,5,36),(6,40,5,37),(6,40,5,38),(1,40,5,42),(5,40,6,33),(6,40,6,34),(6,40,6,35),(6,40,6,36),(6,40,6,37),(5,40,7,33),(6,40,7,34),(6,40,7,35),(4,40,8,19),(4,40,8,20),(5,40,8,32),(5,40,8,33),(6,40,8,34),(10,40,8,41),(4,40,9,19),(4,40,9,20),(4,40,9,24),(5,40,9,31),(5,40,9,32),(5,40,9,33),(5,40,9,34),(5,40,9,35),(4,40,9,36),(3,40,9,38),(6,40,10,0),(6,40,10,12),(4,40,10,18),(4,40,10,19),(4,40,10,20),(4,40,10,21),(4,40,10,22),(4,40,10,23),(4,40,10,24),(5,40,10,30),(5,40,10,31),(5,40,10,32),(5,40,10,33),(5,40,10,34),(5,40,10,35),(4,40,10,36),(3,40,10,37),(3,40,10,38),(3,40,10,39),(6,40,11,0),(6,40,11,11),(6,40,11,12),(4,40,11,18),(4,40,11,19),(4,40,11,21),(4,40,11,22),(4,40,11,24),(5,40,11,30),(4,40,11,32),(4,40,11,33),(4,40,11,35),(4,40,11,36),(3,40,11,37),(3,40,11,38),(3,40,11,39),(3,40,11,40),(6,40,12,0),(6,40,12,1),(6,40,12,2),(6,40,12,11),(6,40,12,12),(6,40,12,13),(6,40,12,14),(4,40,12,17),(4,40,12,18),(4,40,12,19),(4,40,12,20),(4,40,12,21),(4,40,12,22),(4,40,12,24),(5,40,12,30),(4,40,12,32),(4,40,12,33),(4,40,12,34),(4,40,12,35),(3,40,12,36),(3,40,12,37),(3,40,12,38),(3,40,12,39),(3,40,12,40),(11,40,12,41),(9,40,12,47),(6,40,13,0),(6,40,13,1),(6,40,13,2),(6,40,13,12),(6,40,13,13),(6,40,13,14),(6,40,13,15),(6,40,13,16),(4,40,13,18),(4,40,13,19),(4,40,13,20),(4,40,13,30),(4,40,13,31),(4,40,13,32),(4,40,13,33),(4,40,13,34),(3,40,13,36),(3,40,13,37),(3,40,13,38),(3,40,13,39),(3,40,13,40),(6,40,14,0),(6,40,14,1),(6,40,14,2),(3,40,14,11),(3,40,14,12),(3,40,14,13),(3,40,14,14),(6,40,14,15),(4,40,14,18),(4,40,14,19),(4,40,14,20),(4,40,14,27),(4,40,14,29),(4,40,14,30),(4,40,14,31),(4,40,14,32),(4,40,14,33),(4,40,14,34),(4,40,14,35),(3,40,14,36),(3,40,14,37),(3,40,14,38),(3,40,14,39),(3,40,14,40),(6,40,15,0),(3,40,15,10),(3,40,15,12),(3,40,15,13),(4,40,15,20),(4,40,15,21),(4,40,15,27),(4,40,15,28),(4,40,15,29),(4,40,15,30),(4,40,15,31),(4,40,15,32),(4,40,15,33),(4,40,15,34),(3,40,15,36),(3,40,15,37),(3,40,15,38),(3,40,15,39),(3,40,15,40),(6,40,16,0),(3,40,16,10),(3,40,16,11),(3,40,16,12),(3,40,16,13),(3,40,16,14),(3,40,16,16),(4,40,16,28),(4,40,16,29),(4,40,16,30),(4,40,16,32),(4,40,16,33),(4,40,16,34),(3,40,16,40),(10,40,16,41),(5,40,16,45),(5,40,16,46),(5,40,16,47),(5,40,16,48),(5,40,16,49),(3,40,17,2),(3,40,17,10),(3,40,17,11),(3,40,17,12),(3,40,17,13),(3,40,17,14),(3,40,17,15),(3,40,17,16),(3,40,17,17),(4,40,17,27),(4,40,17,28),(4,40,17,29),(4,40,17,30),(4,40,17,31),(4,40,17,32),(4,40,17,33),(5,40,17,45),(2,40,17,46),(5,40,17,48),(5,40,17,49),(3,40,18,1),(3,40,18,2),(3,40,18,3),(3,40,18,11),(3,40,18,12),(3,40,18,13),(3,40,18,16),(3,40,18,18),(4,40,18,25),(4,40,18,26),(4,40,18,27),(4,40,18,28),(4,40,18,29),(4,40,18,30),(4,40,18,32),(4,40,18,33),(5,40,18,45),(5,40,18,48),(5,40,18,49),(3,40,19,0),(3,40,19,1),(3,40,19,2),(3,40,19,11),(3,40,19,12),(3,40,19,13),(3,40,19,14),(3,40,19,16),(3,40,19,18),(3,40,19,19),(3,40,19,20),(3,40,19,21),(4,40,19,27),(4,40,19,28),(4,40,19,29),(4,40,19,30),(4,40,19,31),(5,40,19,45),(5,40,19,46),(5,40,19,47),(5,40,20,0),(3,40,20,1),(3,40,20,2),(3,40,20,5),(3,40,20,8),(3,40,20,9),(3,40,20,11),(3,40,20,12),(3,40,20,13),(3,40,20,14),(3,40,20,16),(3,40,20,17),(3,40,20,18),(3,40,20,19),(4,40,20,28),(4,40,20,29),(5,40,20,44),(5,40,20,45),(5,40,21,0),(3,40,21,1),(3,40,21,2),(3,40,21,3),(3,40,21,4),(3,40,21,5),(3,40,21,6),(3,40,21,7),(3,40,21,8),(3,40,21,9),(3,40,21,12),(3,40,21,13),(3,40,21,14),(3,40,21,15),(3,40,21,16),(4,40,21,27),(4,40,21,28),(4,40,21,29),(4,40,21,30),(2,40,21,43),(5,40,21,45),(5,40,22,0),(5,40,22,1),(5,40,22,2),(3,40,22,3),(3,40,22,4),(3,40,22,5),(3,40,22,6),(3,40,22,12),(3,40,22,13),(3,40,22,14),(3,40,22,15),(3,40,22,16),(3,40,22,17),(4,40,22,30),(5,40,22,45),(5,40,23,0),(5,40,23,1),(3,40,23,2),(3,40,23,3),(3,40,23,4),(3,40,23,5),(3,40,23,13),(3,40,23,15),(6,40,23,43),(6,40,23,45),(5,40,24,0),(5,40,24,1),(14,40,24,2),(13,40,24,6),(3,40,24,14),(3,40,24,15),(5,40,24,25),(5,40,24,28),(3,40,24,41),(3,40,24,42),(6,40,24,43),(6,40,24,44),(6,40,24,45),(5,40,25,0),(5,40,25,1),(9,40,25,8),(8,40,25,11),(13,40,25,14),(5,40,25,24),(5,40,25,25),(5,40,25,27),(5,40,25,28),(3,40,25,40),(3,40,25,41),(3,40,25,42),(6,40,25,43),(6,40,25,44),(6,40,25,45),(6,40,25,46),(5,40,26,0),(5,40,26,1),(5,40,26,25),(5,40,26,26),(5,40,26,27),(5,40,26,28),(3,40,26,41),(3,40,26,42),(6,40,26,44),(6,40,26,45),(6,40,26,46),(5,40,27,0),(5,40,27,1),(5,40,27,26),(5,40,27,28),(5,40,27,29),(3,40,27,39),(3,40,27,40),(3,40,27,41),(3,40,27,44),(6,40,27,45),(5,40,28,0),(14,40,28,1),(8,40,28,11),(5,40,28,26),(5,40,28,28),(3,40,28,38),(3,40,28,39),(3,40,28,40),(3,40,28,41),(3,40,28,42),(3,40,28,43),(3,40,28,44),(5,40,29,0),(5,40,29,26),(5,40,29,27),(5,40,29,28),(3,40,29,39),(3,40,29,40),(3,40,29,41),(3,40,29,42),(3,40,29,43),(3,40,29,44),(5,40,30,0),(3,40,30,38),(3,40,30,39),(3,40,30,40),(3,40,30,41),(3,40,30,42),(3,40,30,43),(3,40,30,44);
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
) ENGINE=InnoDB AUTO_INCREMENT=103 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `units`
--

LOCK TABLES `units` WRITE;
/*!40000 ALTER TABLE `units` DISABLE KEYS */;
INSERT INTO `units` VALUES (1,3000,1,1,1,NULL,NULL,NULL,NULL,0,0,'Rhyno',0,1,45,NULL,1,0,0,0),(2,3400,1,1,1,NULL,NULL,NULL,NULL,0,0,'Thor',0,1,45,NULL,1,0,0,0),(3,8000,1,1,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,1,45,NULL,1,0,0,0),(4,8000,1,1,1,NULL,NULL,NULL,NULL,0,0,'Dirac',0,1,45,NULL,1,0,0,0),(5,3000,1,1,1,NULL,NULL,NULL,NULL,0,0,'Rhyno',0,4,72,NULL,1,0,0,0),(6,3400,1,1,1,NULL,NULL,NULL,NULL,0,0,'Thor',0,4,72,NULL,1,0,0,0),(7,8000,1,1,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,4,72,NULL,1,0,0,0),(8,8000,1,1,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,4,72,NULL,1,0,0,0),(9,8000,1,1,1,NULL,NULL,NULL,NULL,0,0,'Dirac',0,4,72,NULL,1,0,0,0),(10,3400,1,1,1,NULL,NULL,NULL,NULL,0,0,'Thor',1,3,112,NULL,1,0,0,0),(11,8000,1,1,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,3,112,NULL,1,0,0,0),(12,8000,1,1,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,3,112,NULL,1,0,0,0),(13,8000,1,1,1,NULL,NULL,NULL,NULL,0,0,'Dirac',0,3,112,NULL,1,0,0,0),(14,3000,1,1,1,NULL,NULL,NULL,NULL,0,0,'Rhyno',0,2,180,NULL,1,0,0,0),(15,3400,1,1,1,NULL,NULL,NULL,NULL,0,0,'Thor',0,2,180,NULL,1,0,0,0),(16,3400,1,1,1,NULL,NULL,NULL,NULL,0,0,'Thor',1,2,180,NULL,1,0,0,0),(17,8000,1,1,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,2,180,NULL,1,0,0,0),(18,8000,1,1,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,2,180,NULL,1,0,0,0),(19,8000,1,1,1,NULL,NULL,NULL,NULL,0,0,'Dirac',0,2,180,NULL,1,0,0,0),(20,3400,1,1,1,NULL,NULL,NULL,NULL,0,0,'Thor',0,0,180,NULL,1,0,0,0),(21,3400,1,1,1,NULL,NULL,NULL,NULL,0,0,'Thor',1,0,180,NULL,1,0,0,0),(22,8000,1,1,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,0,180,NULL,1,0,0,0),(23,8000,1,1,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,0,180,NULL,1,0,0,0),(24,8000,1,1,1,NULL,NULL,NULL,NULL,0,0,'Dirac',0,0,180,NULL,1,0,0,0),(25,3000,1,2,1,NULL,NULL,NULL,NULL,0,0,'Rhyno',0,3,112,NULL,1,0,0,0),(26,3000,1,2,1,NULL,NULL,NULL,NULL,0,0,'Rhyno',0,3,112,NULL,1,0,0,0),(27,3000,1,2,1,NULL,NULL,NULL,NULL,0,0,'Rhyno',0,3,112,NULL,1,0,0,0),(28,3400,1,2,1,NULL,NULL,NULL,NULL,0,0,'Thor',0,3,112,NULL,1,0,0,0),(29,3400,1,2,1,NULL,NULL,NULL,NULL,0,0,'Thor',1,3,112,NULL,1,0,0,0),(30,8000,1,2,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,3,112,NULL,1,0,0,0),(31,8000,1,2,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,3,112,NULL,1,0,0,0),(32,8000,1,2,1,NULL,NULL,NULL,NULL,0,0,'Dirac',0,3,112,NULL,1,0,0,0),(33,200,1,26,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(34,100,1,26,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(35,200,1,26,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(36,100,1,26,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(37,200,1,26,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(38,100,1,26,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(39,100,1,26,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(40,100,1,27,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(41,200,1,27,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(42,100,1,27,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(43,100,1,27,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(44,200,1,31,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(45,100,1,31,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(46,100,1,31,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(47,200,1,32,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(48,100,1,32,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(49,100,1,32,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(50,100,1,33,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(51,100,1,33,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(52,100,1,34,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(53,100,1,34,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(54,200,1,35,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(55,100,1,35,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(56,100,1,35,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(57,100,1,36,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(58,100,1,36,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(59,100,1,37,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(60,100,1,37,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(61,200,1,38,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(62,100,1,38,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(63,100,1,38,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(64,200,1,39,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(65,100,1,39,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(66,100,1,39,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(67,200,1,40,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(68,100,1,40,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(69,100,1,40,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(70,100,1,41,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(71,100,1,41,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(72,3000,1,3,1,NULL,NULL,NULL,NULL,0,0,'Rhyno',0,3,246,NULL,1,0,0,0),(73,3400,1,3,1,NULL,NULL,NULL,NULL,0,0,'Thor',0,3,246,NULL,1,0,0,0),(74,3400,1,3,1,NULL,NULL,NULL,NULL,0,0,'Thor',1,3,246,NULL,1,0,0,0),(75,8000,1,3,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,3,246,NULL,1,0,0,0),(76,8000,1,3,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,3,246,NULL,1,0,0,0),(77,8000,1,3,1,NULL,NULL,NULL,NULL,0,0,'Dirac',0,3,246,NULL,1,0,0,0),(78,3400,1,3,1,NULL,NULL,NULL,NULL,0,0,'Thor',0,5,30,NULL,1,0,0,0),(79,3400,1,3,1,NULL,NULL,NULL,NULL,0,0,'Thor',1,5,30,NULL,1,0,0,0),(80,8000,1,3,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,5,30,NULL,1,0,0,0),(81,8000,1,3,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,5,30,NULL,1,0,0,0),(82,8000,1,3,1,NULL,NULL,NULL,NULL,0,0,'Dirac',0,5,30,NULL,1,0,0,0),(83,3000,1,4,1,NULL,NULL,NULL,NULL,0,0,'Rhyno',0,5,210,NULL,1,0,0,0),(84,3000,1,4,1,NULL,NULL,NULL,NULL,0,0,'Rhyno',0,5,210,NULL,1,0,0,0),(85,8000,1,4,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,5,210,NULL,1,0,0,0),(86,8000,1,4,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,5,210,NULL,1,0,0,0),(87,8000,1,4,1,NULL,NULL,NULL,NULL,0,0,'Dirac',0,5,210,NULL,1,0,0,0),(88,3400,1,4,1,NULL,NULL,NULL,NULL,0,0,'Thor',1,2,90,NULL,1,0,0,0),(89,8000,1,4,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,2,90,NULL,1,0,0,0),(90,8000,1,4,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,2,90,NULL,1,0,0,0),(91,8000,1,4,1,NULL,NULL,NULL,NULL,0,0,'Dirac',0,2,90,NULL,1,0,0,0),(92,3000,1,4,1,NULL,NULL,NULL,NULL,0,0,'Rhyno',0,3,180,NULL,1,0,0,0),(93,3000,1,4,1,NULL,NULL,NULL,NULL,0,0,'Rhyno',0,3,180,NULL,1,0,0,0),(94,3400,1,4,1,NULL,NULL,NULL,NULL,0,0,'Thor',0,3,180,NULL,1,0,0,0),(95,8000,1,4,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,3,180,NULL,1,0,0,0),(96,8000,1,4,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,3,180,NULL,1,0,0,0),(97,8000,1,4,1,NULL,NULL,NULL,NULL,0,0,'Dirac',0,3,180,NULL,1,0,0,0),(98,3000,1,4,1,NULL,NULL,NULL,NULL,0,0,'Rhyno',0,5,150,NULL,1,0,0,0),(99,3000,1,4,1,NULL,NULL,NULL,NULL,0,0,'Rhyno',0,5,150,NULL,1,0,0,0),(100,8000,1,4,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,5,150,NULL,1,0,0,0),(101,8000,1,4,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,5,150,NULL,1,0,0,0),(102,8000,1,4,1,NULL,NULL,NULL,NULL,0,0,'Dirac',0,5,150,NULL,1,0,0,0);
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

-- Dump completed on 2010-11-03 16:40:42
