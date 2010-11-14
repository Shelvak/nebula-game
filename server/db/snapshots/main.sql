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
) ENGINE=InnoDB AUTO_INCREMENT=72 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `buildings`
--

LOCK TABLES `buildings` WRITE;
/*!40000 ALTER TABLE `buildings` DISABLE KEYS */;
INSERT INTO `buildings` VALUES (1,6,7,9,0,0,0,1,'Vulcan',NULL,8,10,NULL,1,300,NULL,0,NULL,NULL,0),(2,6,14,9,0,0,0,1,'Thunder',NULL,15,10,NULL,1,300,NULL,0,NULL,NULL,0),(3,6,21,9,0,0,0,1,'Screamer',NULL,22,10,NULL,1,300,NULL,0,NULL,NULL,0),(4,6,11,14,0,0,0,1,'Mothership',NULL,18,19,NULL,1,10500,NULL,0,NULL,NULL,0),(5,6,7,16,0,0,0,1,'Thunder',NULL,8,17,NULL,1,300,NULL,0,NULL,NULL,0),(6,6,21,16,0,0,0,1,'Thunder',NULL,22,17,NULL,1,300,NULL,0,NULL,NULL,0),(7,6,26,16,0,0,0,1,'NpcZetiumExtractor',NULL,27,17,NULL,1,800,NULL,0,NULL,NULL,0),(8,6,25,20,0,0,0,1,'NpcTemple',NULL,27,22,NULL,1,1500,NULL,0,NULL,NULL,0),(9,6,7,22,0,0,0,1,'Screamer',NULL,8,23,NULL,1,300,NULL,0,NULL,NULL,0),(10,6,14,22,0,0,0,1,'Thunder',NULL,15,23,NULL,1,300,NULL,0,NULL,NULL,0),(11,6,21,22,0,0,0,1,'Vulcan',NULL,22,23,NULL,1,300,NULL,0,NULL,NULL,0),(12,6,24,24,0,0,0,1,'NpcMetalExtractor',NULL,25,25,NULL,1,400,NULL,0,NULL,NULL,0),(13,6,28,24,0,0,0,1,'NpcMetalExtractor',NULL,29,25,NULL,1,400,NULL,0,NULL,NULL,0),(14,6,18,25,0,0,0,1,'NpcSolarPlant',NULL,19,26,NULL,1,1000,NULL,0,NULL,NULL,0),(15,6,15,26,0,0,0,1,'NpcSolarPlant',NULL,16,27,NULL,1,1000,NULL,0,NULL,NULL,0),(16,6,3,27,0,0,0,1,'NpcMetalExtractor',NULL,4,28,NULL,1,400,NULL,0,NULL,NULL,0),(17,6,12,27,0,0,0,1,'NpcSolarPlant',NULL,13,28,NULL,1,1000,NULL,0,NULL,NULL,0),(18,6,22,27,0,0,0,1,'NpcSolarPlant',NULL,23,28,NULL,1,1000,NULL,0,NULL,NULL,0),(19,6,26,27,0,0,0,1,'NpcCommunicationsHub',NULL,28,28,NULL,1,1200,NULL,0,NULL,NULL,0),(20,6,0,28,0,0,0,1,'NpcMetalExtractor',NULL,1,29,NULL,1,400,NULL,0,NULL,NULL,0),(21,6,7,28,0,0,0,1,'NpcCommunicationsHub',NULL,9,29,NULL,1,1200,NULL,0,NULL,NULL,0),(22,6,18,28,0,0,0,1,'NpcSolarPlant',NULL,19,29,NULL,1,1000,NULL,0,NULL,NULL,0),(23,8,6,23,0,0,0,1,'NpcMetalExtractor',NULL,7,24,NULL,1,400,NULL,0,NULL,NULL,0),(24,8,27,23,0,0,0,1,'NpcMetalExtractor',NULL,28,24,NULL,1,400,NULL,0,NULL,NULL,0),(25,8,17,24,0,0,0,1,'NpcMetalExtractor',NULL,18,25,NULL,1,400,NULL,0,NULL,NULL,0),(26,8,22,24,0,0,0,1,'NpcMetalExtractor',NULL,23,25,NULL,1,400,NULL,0,NULL,NULL,0),(27,8,22,8,0,0,0,1,'NpcGeothermalPlant',NULL,23,9,NULL,1,600,NULL,0,NULL,NULL,0),(28,8,21,20,0,0,0,1,'NpcTemple',NULL,23,22,NULL,1,1500,NULL,0,NULL,NULL,0),(29,8,27,20,0,0,0,1,'NpcCommunicationsHub',NULL,29,21,NULL,1,1200,NULL,0,NULL,NULL,0),(30,8,24,21,0,0,0,1,'NpcSolarPlant',NULL,25,22,NULL,1,1000,NULL,0,NULL,NULL,0),(31,8,9,23,0,0,0,1,'NpcSolarPlant',NULL,10,24,NULL,1,1000,NULL,0,NULL,NULL,0),(32,8,9,25,0,0,0,1,'NpcSolarPlant',NULL,10,26,NULL,1,1000,NULL,0,NULL,NULL,0),(33,8,34,22,0,0,0,1,'NpcSolarPlant',NULL,35,23,NULL,1,1000,NULL,0,NULL,NULL,0),(34,9,15,4,0,0,0,1,'NpcMetalExtractor',NULL,16,5,NULL,1,400,NULL,0,NULL,NULL,0),(35,9,22,30,0,0,0,1,'NpcMetalExtractor',NULL,23,31,NULL,1,400,NULL,0,NULL,NULL,0),(36,9,23,22,0,0,0,1,'NpcMetalExtractor',NULL,24,23,NULL,1,400,NULL,0,NULL,NULL,0),(37,9,23,17,0,0,0,1,'NpcMetalExtractor',NULL,24,18,NULL,1,400,NULL,0,NULL,NULL,0),(38,9,23,9,0,0,0,1,'NpcMetalExtractor',NULL,24,10,NULL,1,400,NULL,0,NULL,NULL,0),(39,9,18,23,0,0,0,1,'NpcCommunicationsHub',NULL,20,24,NULL,1,1200,NULL,0,NULL,NULL,0),(40,9,24,25,0,0,0,1,'NpcSolarPlant',NULL,25,26,NULL,1,1000,NULL,0,NULL,NULL,0),(41,9,24,27,0,0,0,1,'NpcSolarPlant',NULL,25,28,NULL,1,1000,NULL,0,NULL,NULL,0),(42,9,18,25,0,0,0,1,'NpcSolarPlant',NULL,19,26,NULL,1,1000,NULL,0,NULL,NULL,0),(43,9,18,27,0,0,0,1,'NpcSolarPlant',NULL,19,28,NULL,1,1000,NULL,0,NULL,NULL,0),(44,15,15,9,0,0,0,1,'NpcMetalExtractor',NULL,16,10,NULL,1,400,NULL,0,NULL,NULL,0),(45,15,8,13,0,0,0,1,'NpcMetalExtractor',NULL,9,14,NULL,1,400,NULL,0,NULL,NULL,0),(46,15,9,1,0,0,0,1,'NpcMetalExtractor',NULL,10,2,NULL,1,400,NULL,0,NULL,NULL,0),(47,15,10,5,0,0,0,1,'NpcMetalExtractor',NULL,11,6,NULL,1,400,NULL,0,NULL,NULL,0),(48,15,2,9,0,0,0,1,'NpcGeothermalPlant',NULL,3,10,NULL,1,600,NULL,0,NULL,NULL,0),(49,15,12,1,0,0,0,1,'NpcSolarPlant',NULL,13,2,NULL,1,1000,NULL,0,NULL,NULL,0),(50,15,5,10,0,0,0,1,'NpcSolarPlant',NULL,6,11,NULL,1,1000,NULL,0,NULL,NULL,0),(51,15,5,8,0,0,0,1,'NpcSolarPlant',NULL,6,9,NULL,1,1000,NULL,0,NULL,NULL,0),(52,18,2,18,0,0,0,1,'NpcMetalExtractor',NULL,3,19,NULL,1,400,NULL,0,NULL,NULL,0),(53,18,41,17,0,0,0,1,'NpcMetalExtractor',NULL,42,18,NULL,1,400,NULL,0,NULL,NULL,0),(54,18,40,21,0,0,0,1,'NpcMetalExtractor',NULL,41,22,NULL,1,400,NULL,0,NULL,NULL,0),(55,18,48,16,0,0,0,1,'NpcResearchCenter',NULL,51,19,NULL,1,4000,NULL,0,NULL,NULL,0),(56,18,45,18,0,0,0,1,'NpcCommunicationsHub',NULL,47,19,NULL,1,1200,NULL,0,NULL,NULL,0),(57,18,53,16,0,0,0,1,'NpcExcavationSite',NULL,56,19,NULL,1,2000,NULL,0,NULL,NULL,0),(58,18,48,4,0,0,0,1,'NpcTemple',NULL,50,6,NULL,1,1500,NULL,0,NULL,NULL,0),(59,18,45,16,0,0,0,1,'NpcCommunicationsHub',NULL,47,17,NULL,1,1200,NULL,0,NULL,NULL,0),(60,18,48,2,0,0,0,1,'NpcSolarPlant',NULL,49,3,NULL,1,1000,NULL,0,NULL,NULL,0),(61,18,50,1,0,0,0,1,'NpcSolarPlant',NULL,51,2,NULL,1,1000,NULL,0,NULL,NULL,0),(62,18,48,0,0,0,0,1,'NpcSolarPlant',NULL,49,1,NULL,1,1000,NULL,0,NULL,NULL,0),(63,39,8,10,0,0,0,1,'NpcMetalExtractor',NULL,9,11,NULL,1,400,NULL,0,NULL,NULL,0),(64,39,4,13,0,0,0,1,'NpcMetalExtractor',NULL,5,14,NULL,1,400,NULL,0,NULL,NULL,0),(65,39,2,5,0,0,0,1,'NpcMetalExtractor',NULL,3,6,NULL,1,400,NULL,0,NULL,NULL,0),(66,39,2,9,0,0,0,1,'NpcMetalExtractor',NULL,3,10,NULL,1,400,NULL,0,NULL,NULL,0),(67,39,22,1,0,0,0,1,'NpcMetalExtractor',NULL,23,2,NULL,1,400,NULL,0,NULL,NULL,0),(68,39,0,23,0,0,0,1,'NpcCommunicationsHub',NULL,2,24,NULL,1,1200,NULL,0,NULL,NULL,0),(69,39,5,8,0,0,0,1,'NpcSolarPlant',NULL,6,9,NULL,1,1000,NULL,0,NULL,NULL,0),(70,39,5,10,0,0,0,1,'NpcSolarPlant',NULL,6,11,NULL,1,1000,NULL,0,NULL,NULL,0),(71,39,5,1,0,0,0,1,'NpcSolarPlant',NULL,6,2,NULL,1,1000,NULL,0,NULL,NULL,0);
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
INSERT INTO `folliages` VALUES (6,0,6,8),(6,0,9,7),(6,0,27,13),(6,1,4,7),(6,1,15,9),(6,1,27,9),(6,2,11,0),(6,2,18,5),(6,2,28,11),(6,3,2,7),(6,3,4,1),(6,3,11,12),(6,3,26,3),(6,4,0,12),(6,4,9,9),(6,4,15,1),(6,5,0,8),(6,5,16,2),(6,5,18,8),(6,5,19,9),(6,5,22,3),(6,5,24,9),(6,6,16,6),(6,6,17,9),(6,6,26,2),(6,6,28,9),(6,7,8,4),(6,7,14,8),(6,7,24,7),(6,7,26,7),(6,8,15,11),(6,9,16,8),(6,9,23,1),(6,10,0,10),(6,10,14,1),(6,10,19,4),(6,10,28,2),(6,11,0,5),(6,11,11,4),(6,11,12,8),(6,11,20,8),(6,11,21,4),(6,12,12,2),(6,12,20,1),(6,13,1,2),(6,13,4,10),(6,13,7,0),(6,13,10,0),(6,13,21,9),(6,14,13,11),(6,14,20,10),(6,15,0,11),(6,15,4,6),(6,15,6,7),(6,15,8,12),(6,15,12,6),(6,15,13,3),(6,16,3,3),(6,16,4,4),(6,16,8,1),(6,16,11,7),(6,16,25,11),(6,17,13,12),(6,17,24,8),(6,18,8,0),(6,18,9,6),(6,18,22,9),(6,19,1,13),(6,19,3,8),(6,19,12,4),(6,19,14,9),(6,20,5,9),(6,20,8,11),(6,20,15,1),(6,20,17,2),(6,21,3,4),(6,21,7,0),(6,21,14,7),(6,21,24,8),(6,22,6,11),(6,22,12,6),(6,22,13,0),(6,22,20,12),(6,22,24,3),(6,22,25,5),(6,23,5,8),(6,23,6,4),(6,23,8,3),(6,23,11,6),(6,23,12,6),(6,23,13,6),(6,23,19,11),(6,23,21,3),(6,24,10,4),(6,24,15,1),(6,24,16,3),(6,24,23,11),(6,24,26,3),(6,24,29,1),(6,25,4,6),(6,25,5,10),(6,25,10,10),(6,25,11,7),(6,25,28,5),(6,25,29,11),(6,26,9,0),(6,26,18,10),(6,26,26,4),(6,27,3,2),(6,27,4,9),(6,27,15,9),(6,28,17,0),(6,28,18,1),(6,28,29,3),(6,29,1,11),(8,0,5,9),(8,0,6,1),(8,0,8,5),(8,0,13,7),(8,0,25,3),(8,0,26,3),(8,1,6,6),(8,1,10,1),(8,1,24,10),(8,1,26,6),(8,2,4,10),(8,2,8,5),(8,2,10,3),(8,2,20,9),(8,3,0,4),(8,3,2,0),(8,3,12,11),(8,3,14,0),(8,3,15,6),(8,3,18,9),(8,3,19,2),(8,3,26,0),(8,4,0,2),(8,4,8,6),(8,4,11,13),(8,4,13,12),(8,4,14,3),(8,4,16,2),(8,5,5,1),(8,5,11,8),(8,5,14,10),(8,5,23,2),(8,5,24,9),(8,6,7,8),(8,6,26,6),(8,7,2,4),(8,7,5,12),(8,7,8,4),(8,7,10,2),(8,7,13,10),(8,7,14,6),(8,7,26,4),(8,8,2,10),(8,8,6,6),(8,8,9,9),(8,8,21,8),(8,8,22,7),(8,8,24,10),(8,9,3,0),(8,9,4,2),(8,9,13,6),(8,9,14,11),(8,9,16,5),(8,10,1,0),(8,10,13,9),(8,10,16,5),(8,10,18,7),(8,11,1,7),(8,11,3,6),(8,11,8,0),(8,11,18,11),(8,11,22,8),(8,12,9,4),(8,12,13,3),(8,12,15,4),(8,12,17,1),(8,12,19,4),(8,13,0,8),(8,13,15,10),(8,13,16,0),(8,13,18,0),(8,13,26,1),(8,14,4,3),(8,14,5,6),(8,14,13,11),(8,14,14,5),(8,14,20,6),(8,15,0,4),(8,15,4,8),(8,15,6,3),(8,15,11,1),(8,15,12,13),(8,15,17,10),(8,15,19,0),(8,16,8,6),(8,16,13,5),(8,16,14,6),(8,16,15,11),(8,17,1,10),(8,17,15,2),(8,18,1,2),(8,18,2,5),(8,18,6,0),(8,19,3,1),(8,19,4,10),(8,19,6,1),(8,19,10,11),(8,19,26,2),(8,20,6,9),(8,20,7,7),(8,21,7,5),(8,21,13,4),(8,21,23,5),(8,21,24,0),(8,21,25,6),(8,21,26,8),(8,22,14,4),(8,23,14,3),(8,23,15,1),(8,23,16,1),(8,23,19,2),(8,24,6,11),(8,24,7,9),(8,24,20,3),(8,24,26,0),(8,25,19,8),(8,25,24,11),(8,25,25,5),(8,26,23,1),(8,26,25,7),(8,26,26,11),(8,27,22,1),(8,27,26,1),(8,28,0,1),(8,28,8,1),(8,28,25,11),(8,29,7,0),(8,29,8,2),(8,29,13,6),(8,29,15,5),(8,29,26,8),(8,30,5,6),(8,30,22,0),(8,30,25,2),(8,31,4,0),(8,31,26,7),(8,32,3,2),(8,32,6,1),(8,32,7,1),(8,32,22,3),(8,33,3,3),(8,33,11,0),(8,33,25,1),(8,33,26,8),(8,34,3,2),(8,34,4,10),(8,34,5,8),(8,34,6,11),(8,34,11,7),(8,34,18,9),(8,34,19,7),(8,35,5,8),(8,35,10,1),(8,35,11,10),(8,35,18,9),(9,0,0,7),(9,0,2,3),(9,0,3,11),(9,0,29,10),(9,0,30,4),(9,0,31,9),(9,1,10,7),(9,1,19,10),(9,1,20,8),(9,1,30,6),(9,2,10,3),(9,2,20,4),(9,2,22,8),(9,3,13,5),(9,3,20,2),(9,3,22,6),(9,3,29,6),(9,4,7,0),(9,4,8,13),(9,4,13,13),(9,4,15,7),(9,4,17,10),(9,4,18,12),(9,4,21,13),(9,4,29,11),(9,5,0,11),(9,5,1,10),(9,5,2,3),(9,5,3,7),(9,5,14,0),(9,5,15,7),(9,5,19,4),(9,5,20,10),(9,5,22,5),(9,5,33,9),(9,6,1,0),(9,6,7,9),(9,6,8,2),(9,6,10,6),(9,6,14,11),(9,6,16,6),(9,6,20,8),(9,6,30,5),(9,7,2,4),(9,7,3,4),(9,7,7,11),(9,7,14,3),(9,7,17,11),(9,7,32,11),(9,8,10,11),(9,8,16,13),(9,8,19,0),(9,8,21,11),(9,8,22,9),(9,9,4,5),(9,9,6,4),(9,9,8,5),(9,9,11,0),(9,9,13,8),(9,9,17,13),(9,10,2,9),(9,10,4,11),(9,10,12,10),(9,10,17,3),(9,10,33,2),(9,11,15,9),(9,11,18,9),(9,11,33,6),(9,12,10,5),(9,13,6,3),(9,13,12,5),(9,13,17,10),(9,14,20,1),(9,14,29,5),(9,15,11,9),(9,15,20,2),(9,15,29,6),(9,15,30,3),(9,16,10,7),(9,16,12,9),(9,16,13,11),(9,16,18,10),(9,16,20,11),(9,17,4,1),(9,17,11,8),(9,17,19,3),(9,17,20,11),(9,17,21,7),(9,18,7,5),(9,18,9,1),(9,18,20,7),(9,19,8,2),(9,19,16,5),(9,19,17,1),(9,19,18,7),(9,20,8,8),(9,21,16,13),(9,22,0,5),(9,22,9,2),(9,22,14,1),(9,22,15,7),(9,22,16,2),(9,22,18,0),(9,23,8,13),(9,23,21,2),(9,24,0,1),(9,24,8,13),(9,24,11,3),(9,24,21,1),(9,24,24,12),(9,24,29,9),(9,24,32,3),(9,25,0,13),(9,25,14,2),(9,25,21,0),(9,25,24,6),(9,25,30,7),(9,25,31,7),(15,0,10,12),(15,0,14,0),(15,0,15,1),(15,1,1,10),(15,1,11,0),(15,1,14,13),(15,1,17,0),(15,2,0,9),(15,2,11,3),(15,3,11,10),(15,3,14,2),(15,3,16,4),(15,3,17,4),(15,4,14,8),(15,5,12,12),(15,6,16,8),(15,6,17,5),(15,8,12,4),(15,9,17,12),(15,10,12,11),(15,11,16,2),(15,14,4,8),(15,14,8,11),(15,14,9,8),(15,14,15,1),(15,15,4,10),(15,16,3,6),(15,17,14,12),(15,18,1,5),(15,18,17,8),(15,19,7,7),(15,19,13,5),(15,19,17,1),(15,20,7,2),(15,20,8,0),(15,20,17,3),(15,21,2,1),(15,21,11,4),(15,22,0,5),(15,23,2,2),(15,24,1,4),(15,24,2,0),(15,25,10,5),(15,26,1,3),(15,26,6,8),(15,27,3,5),(15,27,4,6),(15,27,7,1),(15,28,10,4),(15,28,11,1),(15,28,15,7),(15,28,16,6),(15,29,8,10),(15,29,15,4),(15,30,7,3),(15,30,13,8),(15,30,17,12),(15,31,1,7),(15,31,10,1),(15,31,11,9),(15,32,3,2),(15,32,4,9),(15,32,11,10),(15,32,15,3),(15,33,10,9),(15,33,12,2),(15,34,11,9),(15,34,14,11),(15,35,10,1),(15,35,12,6),(15,36,16,10),(15,37,5,10),(18,0,1,10),(18,0,16,12),(18,0,19,5),(18,1,6,12),(18,1,7,13),(18,2,2,6),(18,2,7,10),(18,2,10,1),(18,2,15,0),(18,3,8,1),(18,4,0,8),(18,4,6,6),(18,4,9,0),(18,5,3,2),(18,5,12,6),(18,6,4,3),(18,6,5,10),(18,6,12,9),(18,6,18,12),(18,7,7,7),(18,7,13,4),(18,8,5,3),(18,8,9,12),(18,10,15,4),(18,10,18,7),(18,11,0,12),(18,11,15,13),(18,12,9,11),(18,14,5,5),(18,15,7,4),(18,16,7,7),(18,17,7,0),(18,17,8,7),(18,17,10,10),(18,17,12,3),(18,17,17,4),(18,18,16,10),(18,18,21,0),(18,19,4,10),(18,19,11,0),(18,19,17,8),(18,20,18,13),(18,21,6,11),(18,21,10,4),(18,21,12,13),(18,21,13,0),(18,21,14,4),(18,21,18,12),(18,21,22,2),(18,22,10,2),(18,22,14,0),(18,22,20,5),(18,22,22,4),(18,23,11,5),(18,23,14,0),(18,23,15,3),(18,23,21,5),(18,24,5,11),(18,24,10,11),(18,24,20,10),(18,24,21,7),(18,25,8,9),(18,25,12,5),(18,26,2,4),(18,26,10,1),(18,26,20,13),(18,27,4,2),(18,27,5,12),(18,27,7,10),(18,27,9,0),(18,27,13,8),(18,28,8,6),(18,28,17,0),(18,29,2,6),(18,29,4,7),(18,29,13,0),(18,29,14,11),(18,30,1,2),(18,31,0,12),(18,31,12,8),(18,31,18,5),(18,32,0,10),(18,32,7,1),(18,32,15,2),(18,32,16,7),(18,33,4,9),(18,33,7,5),(18,34,6,7),(18,34,10,0),(18,34,18,11),(18,35,2,12),(18,35,8,7),(18,35,9,5),(18,35,19,4),(18,35,20,2),(18,36,0,5),(18,36,3,3),(18,36,7,10),(18,36,14,9),(18,37,0,2),(18,37,15,13),(18,37,16,7),(18,37,23,2),(18,38,1,6),(18,38,8,8),(18,38,15,7),(18,38,17,13),(18,38,23,5),(18,39,0,11),(18,39,2,9),(18,39,22,11),(18,39,23,5),(18,40,3,11),(18,41,1,2),(18,41,3,4),(18,41,5,13),(18,41,6,5),(18,41,20,11),(18,41,23,1),(18,42,3,8),(18,42,5,10),(18,42,19,4),(18,43,2,3),(18,43,4,0),(18,43,9,2),(18,43,16,4),(18,43,18,8),(18,44,3,12),(18,44,16,1),(18,44,19,11),(18,44,20,4),(18,45,12,12),(18,45,13,1),(18,45,15,7),(18,46,11,4),(18,46,13,8),(18,46,15,7),(18,47,13,4),(18,48,9,11),(18,50,3,12),(18,51,3,5),(18,52,1,12),(18,52,2,6),(18,52,14,4),(18,52,21,13),(18,55,15,12),(18,55,20,2),(18,56,4,10),(39,0,2,4),(39,1,0,12),(39,1,2,10),(39,1,18,8),(39,2,21,8),(39,3,3,6),(39,3,22,5),(39,3,24,6),(39,4,18,3),(39,4,19,0),(39,4,24,4),(39,5,15,1),(39,5,24,1),(39,6,15,13),(39,6,18,0),(39,6,21,6),(39,6,24,10),(39,7,17,1),(39,7,18,8),(39,7,20,13),(39,9,19,2),(39,9,22,4),(39,9,24,6),(39,10,21,11),(39,11,0,1),(39,12,7,6),(39,12,8,4),(39,12,13,7),(39,12,16,9),(39,12,17,13),(39,12,24,11),(39,13,2,3),(39,13,15,1),(39,13,18,0),(39,14,9,11),(39,14,12,8),(39,14,24,8),(39,15,8,0),(39,16,1,2),(39,16,12,7),(39,17,0,5),(39,17,8,8),(39,18,4,11),(39,18,14,2),(39,18,16,6),(39,18,24,9),(39,20,2,2),(39,20,13,4),(39,20,19,12),(39,20,21,11),(39,21,12,1),(39,21,14,2),(39,21,17,4),(39,21,19,6),(39,22,4,7),(39,22,10,10),(39,22,15,11),(39,22,16,3),(39,23,3,6),(39,23,12,13),(39,24,3,9),(39,24,5,13),(39,24,10,3),(39,24,11,8),(39,24,19,3),(39,24,20,11),(39,24,22,5),(39,25,9,4),(39,25,10,6),(39,25,16,8),(39,26,20,9),(39,27,7,8),(39,27,10,8),(39,27,24,13),(39,28,9,7),(39,28,14,13),(39,28,23,3),(39,29,1,3),(39,29,8,0),(39,29,13,4),(39,29,15,7),(39,29,21,9),(39,29,22,6),(39,30,3,0),(39,30,5,11),(39,30,14,3),(39,30,15,10),(39,30,23,0),(39,31,5,0),(39,31,22,0),(39,32,0,9),(39,32,4,7),(39,32,6,4),(39,33,3,12),(39,33,22,4),(39,34,0,6),(39,34,3,10);
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
INSERT INTO `galaxies` VALUES (1,'2010-11-12 12:08:47','dev');
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
INSERT INTO `solar_systems` VALUES (1,'Homeworld',1,2,2),(2,'Expansion',1,0,2),(3,'Expansion',1,1,0),(4,'Resource',1,0,0);
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
) ENGINE=InnoDB AUTO_INCREMENT=53 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ss_objects`
--

LOCK TABLES `ss_objects` WRITE;
/*!40000 ALTER TABLE `ss_objects` DISABLE KEYS */;
INSERT INTO `ss_objects` VALUES (1,1,0,0,3,112,'Asteroid',NULL,'',46,0,0,0,0,0,0,1,0,0,0,NULL,0),(2,1,0,0,4,216,'Asteroid',NULL,'',32,0,0,0,1,0,0,1,0,0,0,NULL,0),(3,1,0,0,3,180,'Asteroid',NULL,'',60,0,0,0,0,0,0,0,0,0,0,NULL,0),(4,1,0,0,3,314,'Asteroid',NULL,'',38,0,0,0,1,0,0,0,0,0,1,NULL,0),(5,1,0,0,3,336,'Asteroid',NULL,'',39,0,0,0,1,0,0,1,0,0,0,NULL,0),(6,1,30,30,0,270,'Planet',1,'P-6',50,0,864,1,3024,1728,2,6048,0,0,604.8,'2010-11-12 12:08:54',0),(7,1,0,0,5,0,'Jumpgate',NULL,'',28,0,0,0,0,0,0,0,0,0,0,NULL,0),(8,1,36,27,2,60,'Planet',NULL,'P-8',51,0,0,0,0,0,0,0,0,0,0,'2010-11-12 12:08:54',0),(9,2,26,34,4,72,'Planet',NULL,'P-9',50,0,0,0,0,0,0,0,0,0,0,'2010-11-12 12:08:54',0),(10,2,0,0,4,288,'Asteroid',NULL,'',40,0,0,0,1,0,0,3,0,0,1,NULL,0),(11,2,0,0,1,180,'Asteroid',NULL,'',29,0,0,0,1,0,0,2,0,0,1,NULL,0),(12,2,0,0,1,0,'Asteroid',NULL,'',46,0,0,0,1,0,0,1,0,0,1,NULL,0),(13,2,0,0,3,292,'Asteroid',NULL,'',37,0,0,0,1,0,0,0,0,0,1,NULL,0),(14,2,0,0,5,45,'Jumpgate',NULL,'',48,0,0,0,0,0,0,0,0,0,0,NULL,0),(15,2,38,18,1,270,'Planet',NULL,'P-15',48,0,0,0,0,0,0,0,0,0,0,'2010-11-12 12:08:54',0),(16,2,0,0,2,150,'Asteroid',NULL,'',37,0,0,0,1,0,0,3,0,0,3,NULL,0),(17,2,0,0,4,216,'Asteroid',NULL,'',40,0,0,0,0,0,0,0,0,0,1,NULL,0),(18,2,57,24,2,30,'Planet',NULL,'P-18',58,2,0,0,0,0,0,0,0,0,0,'2010-11-12 12:08:54',0),(19,2,0,0,4,234,'Asteroid',NULL,'',31,0,0,0,1,0,0,0,0,0,0,NULL,0),(20,2,0,0,4,36,'Asteroid',NULL,'',33,0,0,0,1,0,0,0,0,0,1,NULL,0),(21,2,0,0,2,330,'Asteroid',NULL,'',50,0,0,0,0,0,0,1,0,0,1,NULL,0),(22,2,0,0,2,0,'Asteroid',NULL,'',26,0,0,0,0,0,0,0,0,0,1,NULL,0),(23,2,0,0,4,252,'Asteroid',NULL,'',38,0,0,0,1,0,0,2,0,0,1,NULL,0),(24,2,0,0,0,180,'Asteroid',NULL,'',48,0,0,0,3,0,0,3,0,0,3,NULL,0),(25,2,0,0,5,180,'Jumpgate',NULL,'',25,0,0,0,0,0,0,0,0,0,0,NULL,0),(26,2,0,0,0,0,'Asteroid',NULL,'',27,0,0,0,0,0,0,0,0,0,0,NULL,0),(27,3,0,0,1,225,'Asteroid',NULL,'',42,0,0,0,0,0,0,1,0,0,1,NULL,0),(28,3,0,0,4,180,'Asteroid',NULL,'',40,0,0,0,1,0,0,3,0,0,3,NULL,0),(29,3,0,0,5,285,'Jumpgate',NULL,'',47,0,0,0,0,0,0,0,0,0,0,NULL,0),(30,3,0,0,4,162,'Asteroid',NULL,'',51,0,0,0,3,0,0,3,0,0,1,NULL,0),(31,3,0,0,1,90,'Asteroid',NULL,'',35,0,0,0,1,0,0,1,0,0,1,NULL,0),(32,3,0,0,3,44,'Asteroid',NULL,'',31,0,0,0,0,0,0,0,0,0,0,NULL,0),(33,3,0,0,4,0,'Asteroid',NULL,'',46,0,0,0,1,0,0,0,0,0,0,NULL,0),(34,3,0,0,2,180,'Asteroid',NULL,'',47,0,0,0,2,0,0,1,0,0,3,NULL,0),(35,3,0,0,4,324,'Asteroid',NULL,'',27,0,0,0,1,0,0,3,0,0,1,NULL,0),(36,3,0,0,2,0,'Asteroid',NULL,'',56,0,0,0,3,0,0,2,0,0,3,NULL,0),(37,3,0,0,2,270,'Asteroid',NULL,'',42,0,0,0,2,0,0,3,0,0,1,NULL,0),(38,3,0,0,3,90,'Asteroid',NULL,'',31,0,0,0,3,0,0,1,0,0,3,NULL,0),(39,3,37,25,0,180,'Planet',NULL,'P-39',50,0,0,0,0,0,0,0,0,0,0,'2010-11-12 12:08:54',0),(40,3,0,0,0,0,'Asteroid',NULL,'',57,0,0,0,2,0,0,3,0,0,1,NULL,0),(41,4,0,0,2,30,'Asteroid',NULL,'',36,0,0,0,1,0,0,1,0,0,1,NULL,0),(42,4,0,0,3,0,'Asteroid',NULL,'',42,0,0,0,1,0,0,1,0,0,3,NULL,0),(43,4,0,0,0,90,'Asteroid',NULL,'',57,0,0,0,2,0,0,1,0,0,3,NULL,0),(44,4,0,0,2,180,'Asteroid',NULL,'',56,0,0,0,3,0,0,2,0,0,3,NULL,0),(45,4,0,0,4,18,'Asteroid',NULL,'',52,0,0,0,0,0,0,0,0,0,0,NULL,0),(46,4,0,0,3,314,'Asteroid',NULL,'',43,0,0,0,1,0,0,1,0,0,1,NULL,0),(47,4,0,0,5,0,'Jumpgate',NULL,'',43,0,0,0,0,0,0,0,0,0,0,NULL,0),(48,4,0,0,4,252,'Asteroid',NULL,'',36,0,0,0,3,0,0,3,0,0,3,NULL,0),(49,4,0,0,3,292,'Asteroid',NULL,'',31,0,0,0,2,0,0,2,0,0,3,NULL,0),(50,4,0,0,3,224,'Asteroid',NULL,'',58,0,0,0,0,0,0,1,0,0,0,NULL,0),(51,4,0,0,5,165,'Jumpgate',NULL,'',58,0,0,0,0,0,0,0,0,0,0,NULL,0),(52,4,0,0,0,0,'Asteroid',NULL,'',26,0,0,0,0,0,0,1,0,0,1,NULL,0);
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
INSERT INTO `tiles` VALUES (5,6,0,0),(5,6,0,1),(5,6,0,2),(5,6,0,3),(5,6,0,15),(5,6,0,16),(5,6,0,17),(5,6,0,18),(5,6,0,19),(5,6,0,20),(5,6,0,21),(5,6,0,22),(5,6,0,23),(5,6,0,24),(5,6,0,25),(5,6,0,26),(0,6,0,28),(5,6,1,0),(5,6,1,1),(5,6,1,2),(5,6,1,3),(4,6,1,7),(4,6,1,8),(4,6,1,9),(4,6,1,10),(13,6,1,12),(5,6,1,16),(5,6,1,17),(5,6,1,18),(11,6,1,20),(5,6,1,26),(5,6,2,0),(5,6,2,1),(5,6,2,2),(4,6,2,6),(4,6,2,7),(4,6,2,8),(4,6,2,9),(5,6,2,14),(5,6,2,15),(5,6,2,16),(5,6,2,17),(5,6,2,19),(5,6,2,26),(5,6,2,27),(5,6,3,0),(5,6,3,1),(4,6,3,5),(4,6,3,6),(4,6,3,7),(4,6,3,8),(4,6,3,9),(5,6,3,15),(5,6,3,16),(5,6,3,17),(5,6,3,18),(5,6,3,19),(0,6,3,27),(5,6,4,1),(5,6,4,2),(5,6,4,3),(4,6,4,6),(4,6,4,7),(4,6,4,8),(6,6,4,11),(5,6,4,16),(5,6,4,17),(5,6,5,2),(5,6,5,3),(4,6,5,5),(4,6,5,6),(4,6,5,7),(6,6,5,10),(6,6,5,11),(6,6,5,20),(6,6,5,21),(6,6,6,10),(6,6,6,11),(6,6,6,18),(6,6,6,20),(6,6,6,21),(6,6,6,22),(12,6,7,1),(6,6,7,11),(6,6,7,19),(6,6,7,20),(6,6,8,11),(6,6,8,12),(6,6,8,13),(6,6,8,19),(6,6,8,20),(6,6,9,12),(6,6,9,13),(6,6,9,14),(6,6,9,20),(3,6,9,25),(3,6,9,26),(0,6,10,8),(6,6,10,12),(6,6,10,13),(8,6,10,22),(3,6,10,25),(3,6,10,26),(3,6,10,27),(3,6,10,29),(3,6,11,26),(3,6,11,27),(3,6,11,28),(3,6,11,29),(3,6,12,27),(3,6,12,28),(3,6,12,29),(3,6,13,25),(3,6,13,27),(3,6,13,28),(3,6,13,29),(3,6,14,25),(3,6,14,26),(3,6,14,27),(3,6,14,28),(3,6,14,29),(3,6,15,25),(3,6,15,26),(3,6,15,27),(3,6,15,28),(3,6,15,29),(5,6,16,0),(3,6,16,26),(3,6,16,27),(3,6,16,28),(3,6,16,29),(5,6,17,0),(5,6,17,1),(3,6,17,25),(3,6,17,26),(3,6,17,27),(3,6,17,28),(3,6,17,29),(5,6,18,0),(5,6,18,1),(0,6,18,5),(3,6,18,24),(3,6,18,25),(3,6,18,26),(3,6,18,27),(3,6,18,28),(3,6,18,29),(5,6,19,0),(3,6,19,24),(3,6,19,25),(3,6,19,26),(3,6,19,27),(3,6,19,28),(3,6,19,29),(5,6,20,0),(5,6,20,1),(3,6,20,24),(3,6,20,25),(3,6,20,26),(3,6,20,27),(3,6,20,28),(3,6,20,29),(5,6,21,0),(3,6,21,25),(3,6,21,26),(3,6,21,27),(3,6,21,28),(3,6,21,29),(5,6,22,0),(14,6,22,1),(3,6,22,27),(3,6,22,28),(3,6,22,29),(5,6,23,0),(4,6,23,20),(3,6,23,26),(3,6,23,27),(3,6,23,28),(3,6,23,29),(5,6,24,0),(4,6,24,18),(4,6,24,19),(4,6,24,20),(4,6,24,21),(4,6,24,22),(0,6,24,24),(3,6,24,27),(3,6,24,28),(5,6,25,0),(5,6,25,2),(4,6,25,19),(4,6,25,20),(4,6,25,21),(4,6,25,22),(5,6,26,0),(5,6,26,1),(5,6,26,2),(6,6,26,6),(6,6,26,7),(2,6,26,16),(4,6,26,19),(4,6,26,20),(4,6,26,21),(4,6,26,22),(4,6,26,23),(6,6,27,5),(6,6,27,6),(5,6,27,7),(5,6,27,8),(5,6,27,11),(5,6,27,12),(4,6,27,19),(4,6,27,20),(4,6,27,21),(4,6,27,22),(4,6,27,23),(4,6,27,24),(5,6,28,1),(5,6,28,2),(5,6,28,3),(5,6,28,4),(6,6,28,5),(6,6,28,6),(5,6,28,7),(5,6,28,8),(5,6,28,10),(5,6,28,11),(5,6,28,12),(5,6,28,13),(5,6,28,14),(4,6,28,19),(4,6,28,20),(4,6,28,21),(4,6,28,22),(4,6,28,23),(0,6,28,24),(5,6,29,2),(6,6,29,3),(6,6,29,4),(6,6,29,5),(6,6,29,6),(5,6,29,7),(5,6,29,8),(5,6,29,9),(5,6,29,10),(5,6,29,11),(5,6,29,12),(5,6,29,13),(4,6,29,18),(4,6,29,19),(4,6,29,20),(4,6,29,21),(4,6,29,22),(6,8,0,0),(6,8,0,1),(6,8,0,2),(6,8,0,3),(6,8,0,4),(3,8,0,15),(3,8,0,16),(3,8,0,18),(3,8,0,19),(5,8,0,21),(5,8,0,22),(5,8,0,23),(5,8,0,24),(6,8,1,0),(6,8,1,1),(6,8,1,2),(6,8,1,3),(6,8,1,4),(3,8,1,15),(3,8,1,16),(3,8,1,17),(3,8,1,18),(3,8,1,19),(5,8,1,22),(5,8,1,23),(6,8,2,1),(6,8,2,3),(3,8,2,6),(3,8,2,16),(3,8,2,17),(3,8,2,18),(5,8,2,21),(5,8,2,22),(0,8,2,24),(3,8,3,6),(3,8,3,16),(3,8,3,17),(5,8,3,21),(5,8,3,22),(3,8,4,3),(3,8,4,4),(3,8,4,5),(3,8,4,6),(3,8,4,7),(0,8,4,19),(3,8,5,3),(3,8,5,4),(3,8,5,6),(3,8,5,7),(3,8,6,3),(3,8,6,5),(3,8,6,6),(4,8,6,16),(4,8,6,18),(0,8,6,23),(4,8,7,16),(4,8,7,18),(4,8,7,19),(4,8,7,20),(3,8,8,7),(6,8,8,10),(6,8,8,11),(4,8,8,15),(4,8,8,16),(4,8,8,17),(4,8,8,18),(4,8,8,19),(4,8,8,20),(3,8,9,6),(3,8,9,7),(6,8,9,9),(6,8,9,10),(6,8,9,11),(6,8,9,12),(4,8,9,18),(4,8,9,19),(4,8,9,20),(3,8,10,4),(3,8,10,5),(3,8,10,6),(3,8,10,7),(6,8,10,9),(6,8,10,10),(6,8,10,11),(4,8,11,2),(4,8,11,4),(3,8,11,5),(3,8,11,6),(3,8,11,7),(6,8,11,11),(4,8,12,2),(4,8,12,4),(4,8,12,5),(3,8,12,6),(3,8,12,7),(3,8,12,8),(3,8,12,10),(6,8,12,11),(6,8,12,12),(0,8,12,23),(4,8,13,1),(4,8,13,2),(4,8,13,3),(4,8,13,4),(4,8,13,5),(3,8,13,6),(3,8,13,8),(3,8,13,9),(3,8,13,10),(3,8,13,11),(3,8,13,12),(4,8,14,1),(4,8,14,3),(3,8,14,6),(3,8,14,8),(3,8,14,9),(3,8,14,10),(3,8,14,11),(3,8,14,12),(4,8,14,22),(4,8,14,23),(4,8,14,24),(4,8,14,25),(4,8,15,1),(4,8,15,2),(4,8,15,3),(3,8,15,9),(3,8,15,10),(4,8,15,22),(4,8,15,23),(4,8,15,24),(4,8,15,25),(4,8,15,26),(3,8,16,11),(6,8,16,17),(9,8,16,20),(4,8,16,23),(4,8,16,24),(4,8,16,25),(4,8,16,26),(3,8,17,11),(3,8,17,12),(6,8,17,17),(4,8,17,23),(0,8,17,24),(4,8,17,26),(3,8,18,11),(3,8,18,12),(3,8,18,13),(3,8,18,14),(6,8,18,15),(6,8,18,16),(6,8,18,17),(5,8,18,18),(3,8,19,11),(3,8,19,12),(3,8,19,13),(3,8,19,14),(6,8,19,15),(6,8,19,16),(6,8,19,17),(5,8,19,18),(5,8,19,19),(12,8,20,0),(4,8,20,10),(3,8,20,11),(3,8,20,12),(3,8,20,14),(6,8,20,15),(6,8,20,16),(5,8,20,19),(5,8,20,20),(5,8,20,21),(5,8,20,22),(4,8,21,9),(4,8,21,10),(4,8,21,11),(6,8,21,14),(6,8,21,15),(5,8,21,18),(5,8,21,19),(1,8,22,8),(4,8,22,10),(4,8,22,11),(2,8,22,12),(1,8,22,17),(5,8,22,19),(0,8,22,24),(4,8,23,10),(4,8,23,11),(4,8,24,9),(4,8,24,10),(4,8,24,11),(4,8,24,12),(4,8,25,9),(4,8,25,10),(4,8,25,11),(10,8,25,12),(11,8,26,1),(9,8,26,9),(10,8,26,16),(0,8,27,23),(5,8,30,8),(8,8,30,9),(14,8,30,12),(13,8,30,16),(13,8,30,20),(5,8,31,1),(5,8,31,7),(5,8,31,8),(0,8,31,23),(5,8,32,0),(5,8,32,1),(5,8,32,8),(5,8,33,0),(5,8,33,1),(5,8,33,2),(5,8,33,6),(5,8,33,7),(5,8,33,8),(14,8,33,12),(5,8,34,0),(5,8,34,1),(5,8,34,7),(5,8,34,8),(5,8,35,0),(5,8,35,1),(5,8,35,7),(5,9,0,4),(5,9,0,5),(5,9,0,6),(5,9,0,7),(5,9,0,8),(4,9,0,9),(4,9,0,10),(4,9,0,11),(4,9,0,12),(4,9,0,13),(4,9,0,15),(4,9,0,21),(4,9,0,22),(4,9,0,23),(4,9,0,24),(4,9,0,25),(4,9,0,26),(4,9,0,27),(4,9,0,28),(4,9,0,32),(4,9,0,33),(5,9,1,4),(5,9,1,5),(5,9,1,6),(5,9,1,7),(5,9,1,8),(4,9,1,9),(4,9,1,12),(4,9,1,13),(4,9,1,14),(4,9,1,15),(4,9,1,16),(4,9,1,21),(4,9,1,22),(4,9,1,23),(4,9,1,24),(4,9,1,25),(4,9,1,26),(4,9,1,27),(4,9,1,28),(4,9,1,29),(4,9,1,32),(4,9,1,33),(3,9,2,3),(3,9,2,4),(3,9,2,5),(3,9,2,6),(5,9,2,7),(5,9,2,8),(5,9,2,9),(4,9,2,12),(4,9,2,13),(4,9,2,15),(12,9,2,23),(4,9,2,29),(4,9,2,30),(4,9,2,31),(4,9,2,32),(4,9,2,33),(3,9,3,0),(3,9,3,1),(3,9,3,2),(3,9,3,3),(3,9,3,4),(3,9,3,5),(5,9,3,6),(5,9,3,7),(5,9,3,8),(4,9,3,12),(4,9,3,15),(4,9,3,30),(4,9,3,32),(4,9,3,33),(3,9,4,1),(3,9,4,2),(3,9,4,3),(5,9,4,4),(5,9,4,5),(5,9,4,6),(4,9,4,32),(4,9,4,33),(5,9,5,6),(5,9,5,7),(6,9,5,12),(4,9,5,31),(4,9,5,32),(6,9,6,11),(6,9,6,12),(4,9,6,32),(6,9,7,12),(6,9,8,12),(12,9,8,23),(13,9,8,29),(13,9,8,31),(4,9,9,19),(4,9,9,21),(4,9,9,22),(6,9,10,6),(6,9,10,7),(6,9,10,8),(6,9,10,9),(4,9,10,18),(4,9,10,19),(4,9,10,20),(4,9,10,21),(5,9,11,0),(5,9,11,1),(5,9,11,3),(5,9,11,4),(6,9,11,5),(6,9,11,6),(5,9,11,7),(6,9,11,8),(6,9,11,9),(4,9,11,19),(4,9,11,20),(4,9,11,21),(4,9,11,22),(5,9,12,0),(5,9,12,1),(5,9,12,2),(5,9,12,3),(5,9,12,7),(6,9,12,8),(6,9,12,9),(4,9,12,19),(4,9,12,20),(4,9,12,21),(4,9,12,22),(5,9,13,0),(5,9,13,1),(5,9,13,2),(5,9,13,3),(5,9,13,4),(5,9,13,5),(5,9,13,7),(5,9,13,8),(5,9,13,9),(5,9,13,10),(3,9,13,14),(4,9,13,21),(4,9,13,22),(5,9,14,0),(5,9,14,1),(5,9,14,2),(5,9,14,3),(5,9,14,4),(5,9,14,5),(5,9,14,6),(5,9,14,7),(5,9,14,8),(5,9,14,9),(5,9,14,10),(3,9,14,14),(3,9,14,15),(3,9,14,16),(11,9,14,23),(9,9,14,31),(6,9,15,0),(5,9,15,1),(5,9,15,2),(5,9,15,3),(0,9,15,4),(5,9,15,6),(5,9,15,7),(5,9,15,8),(3,9,15,15),(3,9,15,16),(3,9,15,17),(3,9,15,18),(6,9,16,0),(5,9,16,1),(5,9,16,2),(5,9,16,6),(5,9,16,8),(5,9,16,9),(3,9,16,14),(3,9,16,15),(3,9,16,16),(3,9,16,17),(5,9,16,22),(6,9,17,0),(6,9,17,1),(6,9,17,2),(3,9,17,15),(5,9,17,22),(10,9,18,0),(5,9,18,21),(5,9,18,22),(14,9,18,29),(3,9,19,4),(2,9,19,5),(3,9,19,7),(2,9,19,9),(4,9,19,11),(4,9,19,12),(4,9,19,13),(4,9,19,14),(4,9,19,15),(0,9,19,20),(5,9,19,22),(3,9,20,4),(3,9,20,7),(4,9,20,12),(4,9,20,13),(4,9,20,14),(4,9,20,15),(5,9,20,18),(5,9,20,22),(5,9,20,25),(5,9,20,26),(3,9,20,27),(3,9,20,28),(3,9,21,4),(3,9,21,5),(3,9,21,6),(3,9,21,7),(4,9,21,10),(4,9,21,11),(4,9,21,12),(4,9,21,13),(4,9,21,14),(4,9,21,15),(5,9,21,18),(5,9,21,19),(5,9,21,20),(5,9,21,21),(5,9,21,22),(5,9,21,23),(5,9,21,24),(5,9,21,25),(0,9,21,26),(3,9,21,28),(3,9,21,29),(3,9,21,30),(3,9,21,31),(3,9,21,32),(3,9,21,33),(3,9,22,4),(3,9,22,5),(3,9,22,6),(3,9,22,7),(4,9,22,11),(4,9,22,13),(5,9,22,21),(5,9,22,22),(5,9,22,23),(5,9,22,24),(6,9,22,25),(3,9,22,28),(3,9,22,29),(0,9,22,30),(3,9,22,32),(1,9,23,1),(1,9,23,5),(3,9,23,7),(0,9,23,9),(0,9,23,13),(0,9,23,17),(0,9,23,22),(6,9,23,24),(6,9,23,25),(6,9,23,26),(6,9,23,27),(3,9,23,28),(3,9,23,32),(3,15,0,0),(3,15,0,1),(3,15,0,2),(3,15,0,3),(3,15,0,4),(3,15,0,5),(3,15,0,6),(3,15,0,7),(3,15,0,8),(6,15,1,2),(6,15,1,3),(3,15,1,4),(2,15,1,5),(3,15,1,7),(3,15,1,8),(6,15,2,1),(6,15,2,2),(6,15,2,3),(6,15,2,4),(3,15,2,7),(1,15,2,9),(6,15,3,3),(5,15,3,7),(14,15,4,0),(5,15,4,7),(0,15,4,15),(9,15,5,4),(5,15,5,7),(5,15,6,7),(4,15,7,0),(4,15,7,1),(4,15,7,2),(4,15,7,3),(5,15,7,7),(5,15,7,8),(5,15,7,9),(5,15,7,10),(4,15,8,0),(4,15,8,1),(4,15,8,2),(4,15,8,3),(5,15,8,7),(5,15,8,8),(0,15,8,9),(5,15,8,11),(0,15,8,13),(4,15,9,0),(0,15,9,1),(4,15,9,3),(4,15,9,4),(5,15,9,5),(5,15,9,6),(5,15,9,7),(5,15,9,8),(5,15,9,11),(5,15,9,12),(4,15,10,0),(4,15,10,3),(4,15,10,4),(0,15,10,5),(5,15,10,7),(5,15,10,8),(5,15,10,9),(5,15,10,10),(5,15,10,11),(5,15,10,14),(4,15,11,0),(4,15,11,1),(4,15,11,2),(4,15,11,3),(4,15,11,4),(5,15,11,7),(14,15,11,8),(5,15,11,12),(5,15,11,13),(5,15,11,14),(5,15,11,15),(4,15,12,0),(4,15,12,3),(4,15,12,4),(5,15,12,5),(5,15,12,6),(5,15,12,7),(5,15,12,12),(5,15,12,13),(5,15,12,14),(5,15,12,15),(5,15,12,16),(5,15,12,17),(4,15,13,0),(4,15,13,3),(4,15,13,4),(4,15,13,5),(5,15,13,6),(5,15,13,7),(5,15,13,12),(5,15,13,13),(5,15,13,14),(5,15,13,15),(5,15,13,16),(5,15,13,17),(4,15,14,0),(4,15,14,1),(4,15,14,2),(4,15,14,3),(4,15,14,5),(4,15,14,6),(4,15,14,7),(5,15,14,11),(5,15,14,12),(5,15,14,13),(5,15,14,14),(4,15,15,0),(4,15,15,1),(4,15,15,6),(4,15,15,7),(0,15,15,9),(5,15,15,11),(5,15,15,12),(5,15,15,13),(5,15,15,14),(4,15,16,0),(4,15,16,4),(4,15,16,5),(4,15,16,6),(4,15,16,7),(4,15,16,8),(3,15,16,11),(5,15,16,12),(5,15,16,13),(5,15,16,14),(4,15,17,2),(4,15,17,3),(4,15,17,4),(4,15,17,5),(4,15,17,7),(4,15,17,8),(3,15,17,9),(3,15,17,10),(3,15,17,11),(4,15,18,4),(4,15,18,7),(3,15,18,8),(3,15,18,9),(3,15,18,10),(3,15,18,11),(3,15,18,12),(3,15,18,13),(3,15,19,10),(3,15,19,12),(3,15,20,11),(3,15,20,12),(4,15,21,4),(4,15,21,6),(4,15,21,7),(4,15,21,8),(12,15,21,12),(4,15,22,2),(4,15,22,3),(4,15,22,4),(4,15,22,5),(4,15,22,6),(4,15,22,7),(6,15,22,8),(6,15,22,9),(4,15,23,4),(4,15,23,5),(4,15,23,6),(4,15,23,7),(3,15,23,8),(6,15,23,9),(6,15,23,10),(6,15,23,11),(4,15,24,4),(4,15,24,5),(3,15,24,6),(3,15,24,7),(3,15,24,8),(6,15,24,9),(4,15,25,5),(3,15,25,7),(3,15,25,8),(6,15,25,9),(3,15,26,8),(3,15,26,9),(3,15,26,10),(3,15,26,11),(3,15,27,9),(3,15,27,10),(3,15,27,11),(6,15,29,4),(6,15,29,5),(6,15,29,6),(6,15,30,6),(3,15,30,9),(6,15,30,16),(6,15,31,6),(6,15,31,7),(6,15,31,8),(3,15,31,9),(6,15,31,15),(6,15,31,16),(6,15,31,17),(5,15,32,0),(3,15,32,6),(3,15,32,7),(3,15,32,8),(3,15,32,9),(6,15,32,17),(5,15,33,0),(5,15,33,1),(5,15,33,3),(5,15,33,6),(3,15,33,7),(3,15,33,8),(3,15,33,9),(6,15,33,17),(5,15,34,1),(5,15,34,2),(5,15,34,3),(5,15,34,4),(5,15,34,5),(5,15,34,6),(3,15,34,8),(6,15,34,17),(5,15,35,1),(5,15,35,2),(5,15,35,3),(5,15,35,4),(5,15,35,5),(3,15,35,8),(3,15,35,9),(5,15,36,0),(5,15,36,1),(5,15,36,2),(5,15,36,3),(5,15,36,4),(5,15,36,5),(5,15,36,6),(3,15,36,8),(6,15,36,11),(6,15,36,12),(6,15,36,13),(6,15,36,14),(5,15,37,0),(5,15,37,1),(5,15,37,2),(5,15,37,3),(5,15,37,4),(6,15,37,11),(6,15,37,12),(6,15,37,13),(6,18,0,20),(5,18,1,17),(6,18,1,19),(6,18,1,20),(6,18,1,21),(6,18,1,22),(5,18,2,16),(5,18,2,17),(0,18,2,18),(6,18,2,20),(6,18,2,21),(5,18,3,16),(5,18,3,17),(6,18,3,20),(6,18,3,21),(6,18,3,22),(3,18,4,2),(5,18,4,15),(5,18,4,16),(6,18,4,20),(6,18,4,21),(6,18,4,22),(6,18,4,23),(3,18,5,0),(3,18,5,1),(3,18,5,2),(5,18,5,16),(5,18,5,17),(3,18,5,18),(3,18,5,19),(6,18,5,20),(6,18,5,21),(6,18,5,22),(6,18,5,23),(3,18,6,0),(3,18,6,1),(3,18,6,2),(3,18,6,3),(5,18,6,15),(5,18,6,17),(3,18,6,19),(3,18,6,20),(3,18,6,21),(3,18,6,22),(6,18,6,23),(3,18,7,0),(3,18,7,1),(3,18,7,2),(3,18,7,3),(3,18,7,4),(3,18,7,5),(3,18,7,6),(5,18,7,12),(5,18,7,15),(5,18,7,16),(5,18,7,17),(5,18,7,18),(3,18,7,19),(3,18,7,20),(3,18,7,21),(3,18,7,22),(3,18,7,23),(3,18,8,1),(3,18,8,3),(3,18,8,4),(3,18,8,6),(5,18,8,12),(5,18,8,13),(5,18,8,14),(5,18,8,15),(5,18,8,16),(5,18,8,17),(5,18,8,18),(3,18,8,20),(3,18,8,21),(3,18,8,22),(3,18,8,23),(5,18,9,1),(5,18,9,2),(3,18,9,3),(3,18,9,4),(3,18,9,6),(5,18,9,10),(5,18,9,11),(5,18,9,12),(5,18,9,13),(5,18,9,14),(5,18,9,15),(5,18,9,16),(5,18,9,17),(5,18,9,18),(5,18,9,19),(5,18,9,20),(5,18,9,21),(3,18,9,22),(3,18,9,23),(5,18,10,1),(5,18,10,2),(3,18,10,3),(3,18,10,4),(5,18,10,10),(3,18,10,11),(3,18,10,12),(5,18,10,13),(5,18,10,14),(5,18,10,16),(5,18,10,17),(5,18,10,19),(3,18,10,20),(3,18,10,21),(3,18,10,22),(3,18,10,23),(5,18,11,1),(5,18,11,2),(5,18,11,4),(5,18,11,5),(3,18,11,8),(3,18,11,9),(3,18,11,10),(3,18,11,11),(3,18,11,12),(5,18,11,13),(5,18,11,14),(5,18,11,17),(5,18,11,18),(5,18,11,19),(5,18,11,20),(4,18,11,21),(3,18,11,22),(3,18,11,23),(5,18,12,1),(5,18,12,2),(5,18,12,3),(5,18,12,4),(3,18,12,10),(5,18,12,11),(5,18,12,12),(5,18,12,13),(5,18,12,14),(5,18,12,15),(5,18,12,16),(5,18,12,17),(5,18,12,18),(5,18,12,19),(5,18,12,20),(4,18,12,21),(4,18,12,22),(3,18,12,23),(5,18,13,1),(5,18,13,2),(5,18,13,4),(3,18,13,9),(3,18,13,10),(3,18,13,11),(5,18,13,12),(5,18,13,13),(5,18,13,14),(5,18,13,15),(5,18,13,16),(5,18,13,17),(5,18,13,19),(5,18,13,20),(4,18,13,21),(4,18,13,22),(4,18,13,23),(5,18,14,0),(5,18,14,1),(5,18,14,2),(5,18,14,3),(5,18,14,4),(3,18,14,9),(3,18,14,10),(3,18,14,11),(3,18,14,12),(5,18,14,13),(5,18,14,14),(5,18,14,15),(5,18,14,16),(5,18,14,17),(5,18,14,18),(4,18,14,19),(4,18,14,20),(4,18,14,21),(4,18,14,22),(4,18,14,23),(5,18,15,0),(5,18,15,1),(5,18,15,2),(5,18,15,3),(5,18,15,4),(5,18,15,5),(3,18,15,11),(5,18,15,16),(5,18,15,17),(5,18,15,18),(4,18,15,20),(4,18,15,21),(4,18,15,22),(4,18,15,23),(5,18,16,0),(5,18,16,1),(5,18,16,2),(5,18,16,3),(3,18,16,9),(3,18,16,10),(3,18,16,11),(3,18,16,12),(3,18,16,13),(3,18,16,14),(5,18,16,16),(5,18,16,17),(5,18,16,18),(4,18,16,19),(4,18,16,20),(4,18,16,21),(5,18,17,0),(5,18,17,1),(5,18,17,2),(5,18,17,3),(3,18,17,11),(3,18,17,14),(4,18,17,18),(4,18,17,19),(4,18,17,21),(4,18,17,22),(4,18,17,23),(5,18,18,0),(5,18,18,1),(5,18,18,2),(5,18,18,3),(5,18,18,4),(5,18,18,5),(4,18,18,18),(5,18,19,0),(5,18,19,1),(5,18,19,2),(5,18,19,3),(5,18,19,5),(5,18,19,6),(4,18,19,15),(5,18,20,0),(5,18,20,1),(5,18,20,2),(5,18,20,3),(5,18,20,4),(5,18,20,5),(5,18,20,6),(5,18,20,7),(5,18,20,8),(4,18,20,15),(5,18,21,0),(5,18,21,1),(5,18,21,2),(5,18,21,3),(5,18,21,4),(5,18,21,5),(4,18,21,15),(4,18,21,16),(4,18,21,17),(6,18,21,23),(5,18,22,0),(5,18,22,1),(5,18,22,2),(5,18,22,3),(5,18,22,4),(5,18,22,5),(5,18,22,6),(5,18,22,7),(4,18,22,15),(4,18,22,16),(4,18,22,17),(6,18,22,23),(5,18,23,1),(5,18,23,2),(5,18,23,3),(4,18,23,16),(4,18,23,17),(4,18,23,18),(6,18,23,22),(6,18,23,23),(5,18,24,1),(5,18,24,3),(5,18,24,4),(4,18,24,14),(4,18,24,15),(4,18,24,16),(4,18,24,17),(4,18,24,18),(4,18,24,19),(6,18,24,22),(6,18,24,23),(5,18,25,1),(4,18,25,14),(4,18,25,15),(4,18,25,16),(4,18,25,17),(4,18,25,18),(4,18,25,19),(6,18,25,20),(6,18,25,21),(6,18,25,22),(6,18,25,23),(5,18,26,1),(4,18,26,18),(6,18,26,19),(6,18,26,21),(6,18,26,22),(6,18,26,23),(6,18,27,18),(6,18,27,19),(6,18,27,20),(6,18,27,21),(6,18,27,22),(6,18,27,23),(6,18,28,18),(6,18,28,19),(6,18,28,21),(6,18,28,22),(6,18,28,23),(6,18,29,20),(6,18,29,21),(6,18,29,22),(6,18,29,23),(6,18,30,21),(6,18,30,22),(6,18,30,23),(0,18,31,13),(6,18,31,21),(6,18,31,22),(3,18,32,11),(3,18,32,12),(6,18,32,21),(6,18,32,22),(6,18,32,23),(3,18,33,12),(3,18,33,13),(6,18,33,21),(3,18,34,11),(3,18,34,12),(3,18,34,13),(3,18,34,14),(3,18,34,15),(4,18,35,6),(3,18,35,10),(3,18,35,11),(3,18,35,12),(3,18,35,13),(3,18,35,14),(3,18,35,15),(4,18,36,5),(4,18,36,6),(3,18,36,8),(3,18,36,9),(3,18,36,10),(3,18,36,11),(3,18,36,12),(3,18,36,13),(3,18,36,15),(0,18,36,21),(4,18,37,5),(4,18,37,6),(4,18,37,7),(4,18,37,10),(4,18,37,11),(3,18,37,12),(3,18,37,13),(4,18,38,4),(4,18,38,5),(4,18,38,6),(4,18,38,7),(4,18,38,9),(4,18,38,10),(4,18,38,12),(4,18,39,5),(4,18,39,6),(4,18,39,7),(4,18,39,8),(4,18,39,9),(4,18,39,10),(4,18,39,11),(4,18,39,12),(4,18,39,13),(4,18,39,14),(4,18,40,7),(4,18,40,8),(4,18,40,9),(4,18,40,10),(4,18,40,11),(4,18,40,12),(4,18,40,13),(4,18,40,14),(4,18,40,15),(4,18,40,16),(0,18,40,21),(4,18,41,8),(4,18,41,9),(4,18,41,11),(4,18,41,12),(4,18,41,13),(4,18,41,16),(0,18,41,17),(4,18,42,8),(4,18,42,9),(4,18,42,10),(4,18,42,11),(4,18,42,12),(4,18,42,16),(4,18,43,12),(9,18,44,0),(1,18,45,21),(4,18,45,23),(4,18,46,20),(4,18,46,23),(5,18,47,10),(4,18,47,20),(4,18,47,21),(4,18,47,22),(4,18,47,23),(5,18,48,7),(5,18,48,10),(5,18,48,11),(5,18,48,12),(5,18,48,14),(4,18,48,20),(4,18,48,21),(4,18,48,22),(4,18,48,23),(5,18,49,7),(5,18,49,8),(5,18,49,9),(5,18,49,10),(5,18,49,12),(5,18,49,13),(5,18,49,14),(4,18,49,20),(2,18,49,21),(4,18,49,23),(5,18,50,7),(5,18,50,8),(5,18,50,9),(5,18,50,10),(5,18,50,11),(5,18,50,12),(5,18,50,13),(4,18,50,20),(4,18,50,23),(5,18,51,4),(5,18,51,5),(5,18,51,6),(5,18,51,8),(5,18,51,9),(5,18,51,10),(5,18,51,11),(5,18,51,12),(5,18,51,13),(4,18,51,20),(4,18,51,21),(4,18,51,22),(4,18,51,23),(5,18,52,3),(5,18,52,4),(5,18,52,6),(5,18,52,7),(5,18,52,8),(5,18,52,9),(5,18,52,10),(5,18,52,11),(5,18,52,12),(5,18,52,13),(4,18,52,19),(4,18,52,20),(4,18,52,22),(4,18,52,23),(5,18,53,3),(5,18,53,4),(5,18,53,5),(5,18,53,8),(5,18,53,9),(5,18,53,10),(5,18,53,11),(4,18,53,20),(1,18,53,21),(14,18,54,0),(5,18,54,4),(5,18,54,5),(5,18,54,6),(5,18,54,7),(5,18,54,8),(5,18,54,9),(5,18,54,10),(5,18,54,11),(5,18,54,12),(5,18,54,13),(5,18,55,4),(5,18,55,5),(5,18,55,6),(5,18,55,7),(5,18,55,8),(5,18,55,9),(5,18,55,10),(5,18,55,11),(5,18,55,12),(5,18,55,13),(5,18,55,14),(5,18,56,6),(5,18,56,7),(5,18,56,8),(5,18,56,9),(5,18,56,10),(5,18,56,11),(5,18,56,12),(5,18,56,13),(5,18,56,14),(5,18,56,15),(6,39,0,7),(6,39,0,8),(6,39,0,9),(3,39,0,11),(3,39,0,12),(3,39,0,13),(3,39,0,14),(3,39,0,15),(3,39,0,16),(3,39,0,17),(3,39,0,18),(6,39,1,7),(6,39,1,8),(3,39,1,10),(3,39,1,11),(3,39,1,12),(3,39,1,13),(3,39,1,14),(3,39,1,15),(3,39,1,16),(3,39,1,17),(0,39,2,1),(0,39,2,5),(6,39,2,7),(6,39,2,8),(0,39,2,9),(3,39,2,11),(3,39,2,12),(3,39,2,13),(3,39,2,14),(3,39,2,15),(3,39,2,16),(3,39,2,17),(3,39,2,18),(0,39,2,19),(6,39,3,7),(6,39,3,8),(3,39,3,11),(3,39,3,13),(3,39,3,14),(3,39,3,15),(3,39,3,16),(3,39,3,17),(3,39,4,3),(3,39,4,4),(3,39,4,5),(3,39,4,6),(3,39,4,7),(3,39,4,8),(3,39,4,12),(0,39,4,13),(3,39,4,15),(5,39,5,3),(3,39,5,4),(3,39,5,5),(3,39,5,6),(3,39,5,7),(3,39,5,12),(5,39,6,3),(5,39,6,4),(5,39,6,5),(3,39,6,6),(3,39,6,7),(3,39,6,12),(3,39,6,14),(6,39,7,0),(6,39,7,1),(5,39,7,2),(5,39,7,3),(5,39,7,4),(5,39,7,5),(3,39,7,6),(3,39,7,7),(3,39,7,8),(3,39,7,9),(3,39,7,10),(3,39,7,11),(3,39,7,12),(3,39,7,13),(3,39,7,14),(3,39,7,15),(6,39,8,0),(6,39,8,1),(5,39,8,2),(5,39,8,3),(5,39,8,4),(5,39,8,5),(3,39,8,6),(5,39,8,7),(3,39,8,8),(3,39,8,9),(0,39,8,10),(3,39,8,13),(6,39,9,1),(6,39,9,2),(5,39,9,3),(5,39,9,4),(5,39,9,5),(5,39,9,6),(5,39,9,7),(5,39,9,8),(5,39,9,9),(3,39,9,13),(6,39,10,1),(6,39,10,2),(5,39,10,3),(5,39,10,4),(5,39,10,5),(5,39,10,6),(5,39,10,7),(5,39,10,8),(5,39,10,9),(6,39,10,11),(6,39,10,12),(6,39,10,13),(5,39,10,23),(6,39,11,2),(5,39,11,3),(5,39,11,4),(5,39,11,5),(5,39,11,6),(5,39,11,7),(5,39,11,8),(6,39,11,10),(6,39,11,11),(6,39,11,12),(5,39,11,20),(5,39,11,21),(5,39,11,22),(5,39,11,23),(5,39,11,24),(5,39,12,2),(5,39,12,3),(5,39,12,4),(5,39,12,5),(5,39,12,6),(6,39,12,11),(6,39,12,12),(5,39,12,19),(5,39,12,20),(5,39,12,21),(5,39,12,22),(5,39,13,0),(5,39,13,1),(5,39,13,3),(5,39,13,4),(6,39,13,11),(5,39,13,20),(5,39,13,21),(5,39,13,22),(5,39,14,1),(5,39,14,2),(5,39,14,3),(5,39,14,4),(5,39,14,5),(5,39,14,20),(5,39,14,21),(5,39,14,22),(5,39,14,23),(5,39,15,1),(5,39,15,2),(5,39,15,3),(5,39,15,4),(3,39,15,6),(3,39,15,7),(5,39,15,19),(5,39,15,20),(5,39,15,21),(5,39,15,22),(5,39,15,23),(3,39,16,5),(3,39,16,6),(3,39,16,7),(5,39,16,18),(5,39,16,20),(5,39,16,21),(5,39,16,22),(5,39,16,23),(5,39,16,24),(3,39,17,5),(3,39,17,6),(3,39,17,7),(5,39,17,17),(5,39,17,18),(5,39,17,19),(5,39,17,20),(5,39,17,21),(5,39,17,22),(5,39,17,23),(5,39,17,24),(3,39,18,6),(3,39,18,8),(3,39,18,9),(5,39,18,18),(5,39,18,20),(5,39,18,21),(5,39,18,22),(5,39,18,23),(3,39,19,5),(3,39,19,6),(3,39,19,7),(3,39,19,8),(3,39,19,9),(5,39,19,16),(5,39,19,17),(5,39,19,18),(5,39,19,19),(5,39,19,22),(5,39,19,23),(5,39,19,24),(3,39,20,3),(3,39,20,4),(3,39,20,5),(3,39,20,6),(3,39,20,7),(3,39,20,8),(3,39,20,9),(5,39,20,17),(5,39,20,23),(5,39,20,24),(3,39,21,5),(3,39,21,6),(3,39,21,7),(3,39,21,9),(4,39,21,23),(4,39,21,24),(6,39,22,0),(0,39,22,1),(3,39,22,6),(3,39,22,7),(3,39,22,8),(4,39,22,19),(4,39,22,20),(4,39,22,21),(4,39,22,23),(6,39,23,0),(4,39,23,5),(4,39,23,6),(4,39,23,7),(3,39,23,8),(4,39,23,21),(4,39,23,22),(4,39,23,23),(4,39,23,24),(6,39,24,0),(6,39,24,1),(4,39,24,6),(3,39,24,18),(4,39,24,21),(4,39,24,23),(4,39,24,24),(6,39,25,0),(6,39,25,1),(6,39,25,2),(4,39,25,4),(4,39,25,5),(4,39,25,6),(4,39,25,7),(3,39,25,18),(3,39,25,19),(4,39,25,20),(4,39,25,21),(4,39,25,22),(4,39,25,23),(4,39,25,24),(6,39,26,0),(1,39,26,1),(4,39,26,4),(4,39,26,5),(4,39,26,6),(4,39,26,7),(3,39,26,18),(3,39,26,19),(4,39,26,21),(4,39,26,23),(4,39,26,24),(6,39,27,0),(4,39,27,4),(4,39,27,5),(3,39,27,16),(3,39,27,18),(3,39,27,19),(3,39,27,20),(3,39,27,21),(3,39,27,22),(4,39,28,4),(4,39,28,5),(4,39,28,6),(4,39,28,7),(3,39,28,16),(3,39,28,17),(3,39,28,18),(3,39,28,19),(3,39,28,20),(3,39,28,21),(4,39,29,4),(4,39,29,5),(3,39,29,16),(3,39,29,17),(3,39,29,18),(3,39,29,19),(3,39,29,20),(4,39,30,4),(5,39,30,9),(3,39,30,16),(3,39,30,17),(3,39,30,19),(5,39,31,8),(5,39,31,9),(5,39,31,11),(3,39,31,15),(3,39,31,16),(3,39,31,17),(3,39,31,18),(5,39,32,8),(5,39,32,10),(5,39,32,11),(5,39,32,12),(6,39,32,13),(6,39,32,14),(6,39,32,15),(3,39,32,17),(3,39,32,18),(2,39,33,1),(5,39,33,6),(5,39,33,7),(5,39,33,8),(5,39,33,10),(5,39,33,11),(6,39,33,12),(6,39,33,13),(6,39,33,14),(6,39,33,15),(4,39,33,18),(4,39,33,19),(4,39,33,20),(4,39,33,21),(5,39,34,5),(5,39,34,7),(5,39,34,8),(5,39,34,9),(5,39,34,10),(5,39,34,11),(5,39,34,12),(5,39,34,13),(6,39,34,14),(6,39,34,15),(5,39,34,16),(5,39,34,17),(5,39,34,18),(4,39,34,19),(4,39,34,20),(4,39,34,21),(4,39,34,22),(5,39,35,4),(5,39,35,5),(5,39,35,6),(5,39,35,7),(5,39,35,8),(5,39,35,9),(5,39,35,10),(5,39,35,11),(5,39,35,12),(5,39,35,13),(5,39,35,14),(5,39,35,15),(5,39,35,16),(5,39,35,17),(5,39,35,18),(4,39,35,19),(4,39,35,20),(4,39,35,21),(4,39,35,22),(4,39,35,23),(4,39,35,24),(5,39,36,5),(5,39,36,6),(5,39,36,7),(5,39,36,9),(5,39,36,10),(5,39,36,11),(5,39,36,12),(5,39,36,13),(5,39,36,14),(5,39,36,15),(5,39,36,16),(5,39,36,17),(4,39,36,18),(4,39,36,19),(4,39,36,20),(4,39,36,21),(4,39,36,22),(4,39,36,23),(4,39,36,24);
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
) ENGINE=InnoDB AUTO_INCREMENT=172 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `units`
--

LOCK TABLES `units` WRITE;
/*!40000 ALTER TABLE `units` DISABLE KEYS */;
INSERT INTO `units` VALUES (1,200,1,7,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(2,100,1,7,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(3,200,1,7,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(4,100,1,7,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(5,200,1,7,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(6,100,1,7,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(7,100,1,7,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(8,100,1,8,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(9,200,1,8,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(10,100,1,8,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(11,100,1,8,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(12,200,1,12,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(13,100,1,12,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(14,100,1,12,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(15,200,1,13,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(16,100,1,13,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(17,100,1,13,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(18,100,1,14,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(19,100,1,14,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(20,100,1,15,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(21,100,1,15,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(22,200,1,16,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(23,100,1,16,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(24,100,1,16,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(25,100,1,17,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(26,100,1,17,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(27,100,1,18,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(28,100,1,18,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(29,200,1,19,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(30,100,1,19,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(31,100,1,19,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(32,200,1,20,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(33,100,1,20,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(34,100,1,20,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(35,200,1,21,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(36,100,1,21,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(37,100,1,21,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(38,100,1,22,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(39,100,1,22,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(40,3400,1,1,1,NULL,NULL,NULL,NULL,0,0,'Thor',0,5,0,NULL,1,0,0,0),(41,3400,1,1,1,NULL,NULL,NULL,NULL,0,0,'Thor',1,5,0,NULL,1,0,0,0),(42,8000,1,1,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,5,0,NULL,1,0,0,0),(43,8000,1,1,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,5,0,NULL,1,0,0,0),(44,8000,1,1,1,NULL,NULL,NULL,NULL,0,0,'Dirac',0,5,0,NULL,1,0,0,0),(45,3000,1,1,1,NULL,NULL,NULL,NULL,0,0,'Rhyno',0,2,60,NULL,1,0,0,0),(46,3000,1,1,1,NULL,NULL,NULL,NULL,0,0,'Rhyno',0,2,60,NULL,1,0,0,0),(47,3400,1,1,1,NULL,NULL,NULL,NULL,0,0,'Thor',0,2,60,NULL,1,0,0,0),(48,3400,1,1,1,NULL,NULL,NULL,NULL,0,0,'Thor',1,2,60,NULL,1,0,0,0),(49,8000,1,1,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,2,60,NULL,1,0,0,0),(50,8000,1,1,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,2,60,NULL,1,0,0,0),(51,8000,1,1,1,NULL,NULL,NULL,NULL,0,0,'Dirac',0,2,60,NULL,1,0,0,0),(52,100,1,28,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(53,200,1,28,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(54,100,1,28,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(55,100,1,28,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(56,200,1,29,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(57,100,1,29,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(58,100,1,29,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(59,100,1,30,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(60,100,1,30,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(61,100,1,31,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(62,100,1,31,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(63,100,1,32,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(64,100,1,32,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(65,100,1,33,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(66,100,1,33,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(67,200,1,39,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(68,100,1,39,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(69,100,1,39,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(70,100,1,40,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(71,100,1,40,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(72,100,1,41,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(73,100,1,42,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(74,100,1,43,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(75,100,1,43,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(76,3400,1,2,1,NULL,NULL,NULL,NULL,0,0,'Thor',0,4,288,NULL,1,0,0,0),(77,8000,1,2,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,4,288,NULL,1,0,0,0),(78,8000,1,2,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,4,288,NULL,1,0,0,0),(79,8000,1,2,1,NULL,NULL,NULL,NULL,0,0,'Dirac',0,4,288,NULL,1,0,0,0),(80,3400,1,2,1,NULL,NULL,NULL,NULL,0,0,'Thor',1,1,180,NULL,1,0,0,0),(81,8000,1,2,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,1,180,NULL,1,0,0,0),(82,8000,1,2,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,1,180,NULL,1,0,0,0),(83,8000,1,2,1,NULL,NULL,NULL,NULL,0,0,'Dirac',0,1,180,NULL,1,0,0,0),(84,100,1,49,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(85,100,1,50,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(86,100,1,50,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(87,100,1,51,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(88,100,1,51,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(89,3000,1,2,1,NULL,NULL,NULL,NULL,0,0,'Rhyno',0,2,30,NULL,1,0,0,0),(90,3000,1,2,1,NULL,NULL,NULL,NULL,0,0,'Rhyno',0,2,30,NULL,1,0,0,0),(91,3400,1,2,1,NULL,NULL,NULL,NULL,0,0,'Thor',0,2,30,NULL,1,0,0,0),(92,3400,1,2,1,NULL,NULL,NULL,NULL,0,0,'Thor',1,2,30,NULL,1,0,0,0),(93,8000,1,2,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,2,30,NULL,1,0,0,0),(94,8000,1,2,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,2,30,NULL,1,0,0,0),(95,8000,1,2,1,NULL,NULL,NULL,NULL,0,0,'Dirac',0,2,30,NULL,1,0,0,0),(96,100,1,55,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(97,100,1,55,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(98,200,1,55,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(99,100,1,55,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(100,200,1,55,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(101,100,1,55,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(102,100,1,55,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(103,200,1,56,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(104,100,1,56,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(105,100,1,56,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(106,100,1,57,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(107,100,1,57,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(108,200,1,57,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(109,100,1,57,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(110,200,1,57,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(111,100,1,57,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(112,100,1,58,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(113,200,1,58,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(114,100,1,58,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(115,100,1,58,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(116,200,1,59,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(117,100,1,59,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(118,100,1,59,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(119,100,1,60,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(120,100,1,60,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(121,100,1,61,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(122,100,1,61,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(123,100,1,62,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(124,100,1,62,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(125,3400,1,2,1,NULL,NULL,NULL,NULL,0,0,'Thor',1,4,252,NULL,1,0,0,0),(126,8000,1,2,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,4,252,NULL,1,0,0,0),(127,8000,1,2,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,4,252,NULL,1,0,0,0),(128,8000,1,2,1,NULL,NULL,NULL,NULL,0,0,'Dirac',0,4,252,NULL,1,0,0,0),(129,3000,1,2,1,NULL,NULL,NULL,NULL,0,0,'Rhyno',0,0,180,NULL,1,0,0,0),(130,3000,1,2,1,NULL,NULL,NULL,NULL,0,0,'Rhyno',0,0,180,NULL,1,0,0,0),(131,3400,1,2,1,NULL,NULL,NULL,NULL,0,0,'Thor',0,0,180,NULL,1,0,0,0),(132,8000,1,2,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,0,180,NULL,1,0,0,0),(133,8000,1,2,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,0,180,NULL,1,0,0,0),(134,8000,1,2,1,NULL,NULL,NULL,NULL,0,0,'Dirac',0,0,180,NULL,1,0,0,0),(135,8000,1,3,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,4,162,NULL,1,0,0,0),(136,8000,1,3,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,4,162,NULL,1,0,0,0),(137,8000,1,3,1,NULL,NULL,NULL,NULL,0,0,'Dirac',0,4,162,NULL,1,0,0,0),(138,3400,1,3,1,NULL,NULL,NULL,NULL,0,0,'Thor',1,2,180,NULL,1,0,0,0),(139,8000,1,3,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,2,180,NULL,1,0,0,0),(140,8000,1,3,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,2,180,NULL,1,0,0,0),(141,8000,1,3,1,NULL,NULL,NULL,NULL,0,0,'Dirac',0,2,180,NULL,1,0,0,0),(142,3000,1,3,1,NULL,NULL,NULL,NULL,0,0,'Rhyno',0,0,180,NULL,1,0,0,0),(143,3400,1,3,1,NULL,NULL,NULL,NULL,0,0,'Thor',0,0,180,NULL,1,0,0,0),(144,8000,1,3,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,0,180,NULL,1,0,0,0),(145,8000,1,3,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,0,180,NULL,1,0,0,0),(146,8000,1,3,1,NULL,NULL,NULL,NULL,0,0,'Dirac',0,0,180,NULL,1,0,0,0),(147,100,1,68,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(148,100,1,68,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(149,100,1,69,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(150,100,1,69,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(151,100,1,70,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(152,100,1,71,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(153,100,1,71,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(154,3400,1,3,1,NULL,NULL,NULL,NULL,0,0,'Thor',0,0,0,NULL,1,0,0,0),(155,3400,1,3,1,NULL,NULL,NULL,NULL,0,0,'Thor',1,0,0,NULL,1,0,0,0),(156,8000,1,3,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,0,0,NULL,1,0,0,0),(157,8000,1,3,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,0,0,NULL,1,0,0,0),(158,8000,1,3,1,NULL,NULL,NULL,NULL,0,0,'Dirac',0,0,0,NULL,1,0,0,0),(159,8000,1,4,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,0,90,NULL,1,0,0,0),(160,8000,1,4,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,0,90,NULL,1,0,0,0),(161,8000,1,4,1,NULL,NULL,NULL,NULL,0,0,'Dirac',0,0,90,NULL,1,0,0,0),(162,3000,1,4,1,NULL,NULL,NULL,NULL,0,0,'Rhyno',0,3,292,NULL,1,0,0,0),(163,3000,1,4,1,NULL,NULL,NULL,NULL,0,0,'Rhyno',0,3,292,NULL,1,0,0,0),(164,3400,1,4,1,NULL,NULL,NULL,NULL,0,0,'Thor',0,3,292,NULL,1,0,0,0),(165,8000,1,4,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,3,292,NULL,1,0,0,0),(166,8000,1,4,1,NULL,NULL,NULL,NULL,0,0,'Dirac',0,3,292,NULL,1,0,0,0),(167,3000,1,4,1,NULL,NULL,NULL,NULL,0,0,'Rhyno',0,5,165,NULL,1,0,0,0),(168,3400,1,4,1,NULL,NULL,NULL,NULL,0,0,'Thor',0,5,165,NULL,1,0,0,0),(169,3400,1,4,1,NULL,NULL,NULL,NULL,0,0,'Thor',1,5,165,NULL,1,0,0,0),(170,8000,1,4,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,5,165,NULL,1,0,0,0),(171,8000,1,4,1,NULL,NULL,NULL,NULL,0,0,'Dirac',0,5,165,NULL,1,0,0,0);
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

-- Dump completed on 2010-11-12 12:08:55
