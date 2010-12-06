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
) ENGINE=InnoDB AUTO_INCREMENT=76 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `buildings`
--

LOCK TABLES `buildings` WRITE;
/*!40000 ALTER TABLE `buildings` DISABLE KEYS */;
INSERT INTO `buildings` VALUES (1,1,24,27,0,0,0,1,'NpcMetalExtractor',NULL,25,28,NULL,1,400,NULL,0,NULL,NULL,0),(2,1,28,39,0,0,0,1,'NpcMetalExtractor',NULL,29,40,NULL,1,400,NULL,0,NULL,NULL,0),(3,1,23,31,0,0,0,1,'NpcMetalExtractor',NULL,24,32,NULL,1,400,NULL,0,NULL,NULL,0),(4,1,28,34,0,0,0,1,'NpcMetalExtractor',NULL,29,35,NULL,1,400,NULL,0,NULL,NULL,0),(5,1,3,23,0,0,0,1,'NpcGeothermalPlant',NULL,4,24,NULL,1,600,NULL,0,NULL,NULL,0),(6,1,2,11,0,0,0,1,'NpcZetiumExtractor',NULL,3,12,NULL,1,800,NULL,0,NULL,NULL,0),(7,1,18,25,0,0,0,1,'NpcResearchCenter',NULL,21,28,NULL,1,4000,NULL,0,NULL,NULL,0),(8,1,11,26,0,0,0,1,'NpcCommunicationsHub',NULL,13,27,NULL,1,1200,NULL,0,NULL,NULL,0),(9,1,16,23,0,0,0,1,'NpcCommunicationsHub',NULL,18,24,NULL,1,1200,NULL,0,NULL,NULL,0),(10,1,32,42,0,0,0,1,'NpcSolarPlant',NULL,33,43,NULL,1,1000,NULL,0,NULL,NULL,0),(11,1,9,27,0,0,0,1,'NpcSolarPlant',NULL,10,28,NULL,1,1000,NULL,0,NULL,NULL,0),(12,1,6,32,0,0,0,1,'NpcSolarPlant',NULL,7,33,NULL,1,1000,NULL,0,NULL,NULL,0),(13,1,8,34,0,0,0,1,'NpcSolarPlant',NULL,9,35,NULL,1,1000,NULL,0,NULL,NULL,0),(14,8,32,9,0,0,0,1,'NpcMetalExtractor',NULL,33,10,NULL,1,400,NULL,0,NULL,NULL,0),(15,8,23,12,0,0,0,1,'NpcMetalExtractor',NULL,24,13,NULL,1,400,NULL,0,NULL,NULL,0),(16,8,8,13,0,0,0,1,'NpcMetalExtractor',NULL,9,14,NULL,1,400,NULL,0,NULL,NULL,0),(17,8,19,16,0,0,0,1,'NpcGeothermalPlant',NULL,20,17,NULL,1,600,NULL,0,NULL,NULL,0),(18,8,16,9,0,0,0,1,'NpcZetiumExtractor',NULL,17,10,NULL,1,800,NULL,0,NULL,NULL,0),(19,8,11,13,0,0,0,1,'NpcResearchCenter',NULL,14,16,NULL,1,4000,NULL,0,NULL,NULL,0),(20,8,16,6,0,0,0,1,'NpcCommunicationsHub',NULL,18,7,NULL,1,1200,NULL,0,NULL,NULL,0),(21,8,5,6,0,0,0,1,'NpcResearchCenter',NULL,8,9,NULL,1,4000,NULL,0,NULL,NULL,0),(22,8,1,8,0,0,0,1,'NpcTemple',NULL,3,10,NULL,1,1500,NULL,0,NULL,NULL,0),(23,8,11,11,0,0,0,1,'NpcCommunicationsHub',NULL,13,12,NULL,1,1200,NULL,0,NULL,NULL,0),(24,8,0,15,0,0,0,1,'NpcSolarPlant',NULL,1,16,NULL,1,1000,NULL,0,NULL,NULL,0),(25,8,11,8,0,0,0,1,'NpcSolarPlant',NULL,12,9,NULL,1,1000,NULL,0,NULL,NULL,0),(26,14,6,34,0,0,0,1,'NpcMetalExtractor',NULL,7,35,NULL,1,400,NULL,0,NULL,NULL,0),(27,14,18,33,0,0,0,1,'NpcGeothermalPlant',NULL,19,34,NULL,1,600,NULL,0,NULL,NULL,0),(28,14,21,38,0,0,0,1,'NpcZetiumExtractor',NULL,22,39,NULL,1,800,NULL,0,NULL,NULL,0),(29,14,20,24,0,0,0,1,'NpcResearchCenter',NULL,23,27,NULL,1,4000,NULL,0,NULL,NULL,0),(30,14,16,14,0,0,0,1,'NpcCommunicationsHub',NULL,18,15,NULL,1,1200,NULL,0,NULL,NULL,0),(31,14,18,29,0,0,0,1,'NpcSolarPlant',NULL,19,30,NULL,1,1000,NULL,0,NULL,NULL,0),(32,14,18,39,0,0,0,1,'NpcSolarPlant',NULL,19,40,NULL,1,1000,NULL,0,NULL,NULL,0),(33,14,30,29,0,0,0,1,'NpcSolarPlant',NULL,31,30,NULL,1,1000,NULL,0,NULL,NULL,0),(34,16,19,18,0,0,0,1,'NpcMetalExtractor',NULL,20,19,NULL,1,400,NULL,0,NULL,NULL,0),(35,16,7,38,0,0,0,1,'NpcMetalExtractor',NULL,8,39,NULL,1,400,NULL,0,NULL,NULL,0),(36,16,3,29,0,0,0,1,'NpcGeothermalPlant',NULL,4,30,NULL,1,600,NULL,0,NULL,NULL,0),(37,16,20,29,0,0,0,1,'NpcZetiumExtractor',NULL,21,30,NULL,1,800,NULL,0,NULL,NULL,0),(38,16,0,4,0,0,0,1,'NpcCommunicationsHub',NULL,2,5,NULL,1,1200,NULL,0,NULL,NULL,0),(39,16,14,9,0,0,0,1,'NpcSolarPlant',NULL,15,10,NULL,1,1000,NULL,0,NULL,NULL,0),(40,16,23,7,0,0,0,1,'NpcSolarPlant',NULL,24,8,NULL,1,1000,NULL,0,NULL,NULL,0),(41,16,0,0,0,0,0,1,'NpcSolarPlant',NULL,1,1,NULL,1,1000,NULL,0,NULL,NULL,0),(42,23,28,10,0,0,0,1,'NpcMetalExtractor',NULL,29,11,NULL,1,400,NULL,0,NULL,NULL,0),(43,23,24,9,0,0,0,1,'NpcGeothermalPlant',NULL,25,10,NULL,1,600,NULL,0,NULL,NULL,0),(44,23,31,6,0,0,0,1,'NpcZetiumExtractor',NULL,32,7,NULL,1,800,NULL,0,NULL,NULL,0),(45,23,27,4,0,0,0,1,'NpcSolarPlant',NULL,28,5,NULL,1,1000,NULL,0,NULL,NULL,0),(46,23,25,0,0,0,0,1,'NpcSolarPlant',NULL,26,1,NULL,1,1000,NULL,0,NULL,NULL,0),(47,31,7,20,0,0,0,1,'NpcMetalExtractor',NULL,8,21,NULL,1,400,NULL,0,NULL,NULL,0),(48,31,3,18,0,0,0,1,'NpcMetalExtractor',NULL,4,19,NULL,1,400,NULL,0,NULL,NULL,0),(49,31,16,20,0,0,0,1,'NpcMetalExtractor',NULL,17,21,NULL,1,400,NULL,0,NULL,NULL,0),(50,31,11,15,0,0,0,1,'NpcMetalExtractor',NULL,12,16,NULL,1,400,NULL,0,NULL,NULL,0),(51,31,21,8,0,0,0,1,'NpcSolarPlant',NULL,22,9,NULL,1,1000,NULL,0,NULL,NULL,0),(52,31,17,3,0,0,0,1,'NpcSolarPlant',NULL,18,4,NULL,1,1000,NULL,0,NULL,NULL,0),(53,31,24,8,0,0,0,1,'NpcSolarPlant',NULL,25,9,NULL,1,1000,NULL,0,NULL,NULL,0),(54,35,0,0,0,0,0,1,'NpcMetalExtractor',NULL,1,1,NULL,1,400,NULL,0,NULL,NULL,0),(55,35,7,0,0,0,0,1,'NpcCommunicationsHub',NULL,9,1,NULL,1,1200,NULL,0,NULL,NULL,0),(56,35,18,0,0,0,0,1,'NpcSolarPlant',NULL,19,1,NULL,1,1000,NULL,0,NULL,NULL,0),(57,35,3,1,0,0,0,1,'NpcMetalExtractor',NULL,4,2,NULL,1,400,NULL,0,NULL,NULL,0),(58,35,12,1,0,0,0,1,'NpcSolarPlant',NULL,13,2,NULL,1,1000,NULL,0,NULL,NULL,0),(59,35,22,1,0,0,0,1,'NpcSolarPlant',NULL,23,2,NULL,1,1000,NULL,0,NULL,NULL,0),(60,35,26,1,0,0,0,1,'NpcCommunicationsHub',NULL,28,2,NULL,1,1200,NULL,0,NULL,NULL,0),(61,35,15,3,0,0,0,1,'NpcSolarPlant',NULL,16,4,NULL,1,1000,NULL,0,NULL,NULL,0),(62,35,18,3,0,0,0,1,'NpcSolarPlant',NULL,19,4,NULL,1,1000,NULL,0,NULL,NULL,0),(63,35,24,4,0,0,0,1,'NpcMetalExtractor',NULL,25,5,NULL,1,400,NULL,0,NULL,NULL,0),(64,35,28,4,0,0,0,1,'NpcMetalExtractor',NULL,29,5,NULL,1,400,NULL,0,NULL,NULL,0),(65,35,7,6,0,0,0,1,'Screamer',NULL,8,7,NULL,1,1700,NULL,0,NULL,NULL,0),(66,35,21,6,0,0,0,1,'Vulcan',NULL,22,7,NULL,1,1400,NULL,0,NULL,NULL,0),(67,35,14,7,0,0,0,1,'Thunder',NULL,15,8,NULL,1,2400,NULL,0,NULL,NULL,0),(68,35,25,7,0,0,0,1,'NpcTemple',NULL,27,9,NULL,1,1500,NULL,0,NULL,NULL,0),(69,35,11,10,0,0,0,1,'Mothership',NULL,18,15,NULL,1,10500,NULL,0,NULL,NULL,0),(70,35,7,12,0,0,0,1,'Thunder',NULL,8,13,NULL,1,2400,NULL,0,NULL,NULL,0),(71,35,21,12,0,0,0,1,'Thunder',NULL,22,13,NULL,1,2400,NULL,0,NULL,NULL,0),(72,35,26,12,0,0,0,1,'NpcZetiumExtractor',NULL,27,13,NULL,1,800,NULL,0,NULL,NULL,0),(73,35,7,19,0,0,0,1,'Vulcan',NULL,8,20,NULL,1,1400,NULL,0,NULL,NULL,0),(74,35,14,19,0,0,0,1,'Thunder',NULL,15,20,NULL,1,2400,NULL,0,NULL,NULL,0),(75,35,21,19,0,0,0,1,'Screamer',NULL,22,20,NULL,1,1700,NULL,0,NULL,NULL,0);
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
INSERT INTO `folliages` VALUES (1,0,6,10),(1,0,39,5),(1,0,43,2),(1,1,0,6),(1,1,6,12),(1,1,9,6),(1,1,14,9),(1,1,24,7),(1,2,14,3),(1,2,36,13),(1,3,7,6),(1,3,42,9),(1,4,9,2),(1,4,15,11),(1,5,2,3),(1,5,3,5),(1,5,36,10),(1,5,43,10),(1,6,6,0),(1,6,31,12),(1,6,35,5),(1,6,36,6),(1,6,41,7),(1,7,3,1),(1,7,5,2),(1,7,6,11),(1,7,19,5),(1,7,26,6),(1,7,31,9),(1,7,35,0),(1,7,41,11),(1,7,42,7),(1,7,43,9),(1,8,0,12),(1,8,4,1),(1,8,5,2),(1,8,6,7),(1,8,7,8),(1,8,16,6),(1,8,18,2),(1,8,26,9),(1,8,31,3),(1,8,32,4),(1,8,33,5),(1,8,40,7),(1,8,41,6),(1,8,43,6),(1,9,9,1),(1,9,15,6),(1,9,19,9),(1,9,22,1),(1,9,42,3),(1,9,43,1),(1,10,9,13),(1,10,15,7),(1,10,16,1),(1,10,19,4),(1,10,21,0),(1,10,29,1),(1,10,32,7),(1,11,2,2),(1,11,17,2),(1,12,1,0),(1,12,5,11),(1,12,16,3),(1,12,21,7),(1,12,24,6),(1,12,35,2),(1,12,36,1),(1,12,39,0),(1,13,2,10),(1,13,17,4),(1,13,18,9),(1,13,22,3),(1,13,23,5),(1,14,3,5),(1,14,18,8),(1,14,26,11),(1,14,30,10),(1,14,36,2),(1,14,37,4),(1,15,11,4),(1,15,28,3),(1,15,29,0),(1,15,32,5),(1,15,36,7),(1,16,0,12),(1,16,3,1),(1,16,33,4),(1,17,2,5),(1,17,29,9),(1,18,10,6),(1,18,14,10),(1,18,15,6),(1,18,16,2),(1,18,30,7),(1,18,32,3),(1,18,33,13),(1,18,35,5),(1,19,2,10),(1,19,24,0),(1,20,14,7),(1,20,17,4),(1,20,22,11),(1,20,33,11),(1,20,36,2),(1,20,37,0),(1,21,3,8),(1,21,12,4),(1,21,14,7),(1,21,24,7),(1,21,37,2),(1,22,3,7),(1,22,17,4),(1,22,19,13),(1,22,20,7),(1,22,22,0),(1,22,23,8),(1,22,27,3),(1,22,29,10),(1,22,32,7),(1,22,37,4),(1,23,0,1),(1,23,14,4),(1,23,15,0),(1,23,16,10),(1,23,20,8),(1,23,22,7),(1,23,25,6),(1,23,40,0),(1,24,16,9),(1,24,18,6),(1,24,19,3),(1,24,22,3),(1,24,24,6),(1,24,30,10),(1,24,38,11),(1,24,39,6),(1,24,40,11),(1,24,41,4),(1,24,42,8),(1,25,3,1),(1,25,12,9),(1,25,13,2),(1,25,22,4),(1,25,24,6),(1,26,0,6),(1,26,2,2),(1,26,10,5),(1,26,23,2),(1,26,30,10),(1,26,32,8),(1,26,40,5),(1,26,42,11),(1,26,43,4),(1,27,3,3),(1,27,13,2),(1,27,28,11),(1,27,31,13),(1,27,33,3),(1,27,39,8),(1,27,40,6),(1,27,43,11),(1,28,0,0),(1,28,2,11),(1,28,14,7),(1,28,28,7),(1,28,30,4),(1,28,32,6),(1,29,0,5),(1,29,11,6),(1,29,14,9),(1,29,18,6),(1,29,28,0),(1,29,36,5),(1,29,41,4),(1,29,42,5),(1,30,3,0),(1,30,14,6),(1,30,33,3),(1,30,35,13),(1,30,36,5),(1,30,38,5),(1,30,42,4),(1,31,14,0),(1,31,15,0),(1,31,17,11),(1,31,31,11),(1,31,32,8),(1,31,36,4),(1,31,38,4),(1,32,20,1),(1,32,37,8),(1,33,9,11),(1,33,13,7),(1,33,14,9),(1,33,15,1),(1,33,16,11),(1,33,33,1),(1,33,36,2),(8,0,7,6),(8,0,8,4),(8,0,13,0),(8,0,17,13),(8,0,25,4),(8,0,29,11),(8,1,7,8),(8,1,28,4),(8,2,15,6),(8,2,19,7),(8,3,23,0),(8,3,27,10),(8,4,27,6),(8,5,23,12),(8,5,29,10),(8,6,1,4),(8,6,27,11),(8,6,30,13),(8,6,31,6),(8,7,30,2),(8,7,31,1),(8,8,26,13),(8,8,31,11),(8,9,24,6),(8,9,25,5),(8,9,28,6),(8,9,31,11),(8,10,26,6),(8,10,27,13),(8,11,24,3),(8,12,21,5),(8,12,26,2),(8,13,0,3),(8,13,18,8),(8,13,21,1),(8,13,27,11),(8,14,21,11),(8,14,31,1),(8,15,1,4),(8,15,6,13),(8,15,26,5),(8,15,27,2),(8,15,30,10),(8,16,0,1),(8,16,15,6),(8,16,25,2),(8,16,28,2),(8,17,2,11),(8,18,9,0),(8,18,11,2),(8,18,29,13),(8,19,6,11),(8,19,27,4),(8,20,18,6),(8,20,21,13),(8,20,27,2),(8,21,1,1),(8,21,18,10),(8,21,19,1),(8,21,21,13),(8,21,22,1),(8,21,28,1),(8,22,3,11),(8,22,16,13),(8,23,9,11),(8,23,11,11),(8,23,17,8),(8,23,18,5),(8,24,8,2),(8,24,10,1),(8,24,19,12),(8,24,24,5),(8,24,25,1),(8,25,0,13),(8,25,3,5),(8,25,6,9),(8,25,12,9),(8,25,18,1),(8,25,22,11),(8,26,2,13),(8,26,10,5),(8,26,12,12),(8,26,14,3),(8,26,23,7),(8,26,24,11),(8,27,0,7),(8,27,15,8),(8,28,8,2),(8,28,11,4),(8,28,14,13),(8,28,15,1),(8,28,16,12),(8,29,16,2),(8,29,17,3),(8,30,5,13),(8,30,10,7),(8,30,11,10),(8,30,15,0),(8,30,17,1),(8,30,19,12),(8,30,20,13),(8,31,2,10),(8,31,5,7),(8,31,6,10),(8,31,10,5),(8,31,11,11),(8,31,18,3),(8,31,19,10),(8,32,18,8),(8,33,1,0),(8,33,6,0),(8,33,15,6),(8,33,21,0),(8,34,11,1),(8,35,6,1),(8,35,10,7),(8,35,11,13),(8,35,12,10),(8,36,15,10),(8,36,19,3),(8,36,22,12),(14,0,6,8),(14,0,21,5),(14,0,24,6),(14,0,29,12),(14,0,31,5),(14,0,32,3),(14,0,33,11),(14,0,34,13),(14,0,35,10),(14,0,36,2),(14,0,37,4),(14,1,7,3),(14,1,9,0),(14,1,10,10),(14,1,11,13),(14,1,19,6),(14,1,27,0),(14,1,31,6),(14,1,32,13),(14,1,33,11),(14,1,40,11),(14,2,3,2),(14,2,5,2),(14,2,6,2),(14,2,8,6),(14,2,10,0),(14,2,14,5),(14,2,20,6),(14,2,21,8),(14,2,24,13),(14,2,25,3),(14,2,28,10),(14,2,34,10),(14,2,36,5),(14,2,37,2),(14,2,38,9),(14,2,40,0),(14,3,4,7),(14,3,8,12),(14,3,13,7),(14,3,14,3),(14,3,27,9),(14,3,29,6),(14,3,31,0),(14,3,33,6),(14,3,37,5),(14,4,24,11),(14,4,34,6),(14,4,40,2),(14,5,7,9),(14,5,30,13),(14,6,0,7),(14,6,3,6),(14,6,6,5),(14,6,27,4),(14,6,28,10),(14,7,27,1),(14,7,28,8),(14,7,31,5),(14,7,32,11),(14,8,0,3),(14,9,11,0),(14,9,13,1),(14,9,28,6),(14,9,31,2),(14,10,0,1),(14,10,1,3),(14,10,2,0),(14,10,13,5),(14,10,28,8),(14,10,32,13),(14,11,4,9),(14,11,11,11),(14,11,12,7),(14,11,22,10),(14,11,28,11),(14,11,30,7),(14,11,31,6),(14,11,37,2),(14,11,39,12),(14,11,40,1),(14,12,8,2),(14,12,11,0),(14,12,28,13),(14,12,37,12),(14,13,1,3),(14,13,3,10),(14,13,4,12),(14,13,11,12),(14,13,12,9),(14,13,17,8),(14,13,22,1),(14,14,0,5),(14,14,4,6),(14,14,11,2),(14,14,24,5),(14,14,25,4),(14,14,32,8),(14,14,35,13),(14,15,0,11),(14,15,2,2),(14,15,3,7),(14,15,4,10),(14,15,13,2),(14,15,14,6),(14,15,32,1),(14,16,7,7),(14,16,13,5),(14,16,18,2),(14,16,19,2),(14,16,21,13),(14,16,22,10),(14,16,28,0),(14,17,16,12),(14,17,20,0),(14,17,23,4),(14,18,17,5),(14,18,18,12),(14,18,19,2),(14,18,24,6),(14,18,31,5),(14,18,37,3),(14,19,4,11),(14,19,16,9),(14,19,24,12),(14,19,31,11),(14,19,32,8),(14,19,38,5),(14,20,3,9),(14,20,4,13),(14,20,37,13),(14,20,38,2),(14,21,4,7),(14,21,5,11),(14,21,19,1),(14,21,37,4),(14,22,1,4),(14,22,3,13),(14,22,5,5),(14,22,21,5),(14,22,23,1),(14,22,40,9),(14,23,4,7),(14,23,13,2),(14,23,19,1),(14,23,20,12),(14,23,39,5),(14,23,40,12),(14,24,0,1),(14,24,2,13),(14,24,7,4),(14,24,22,5),(14,24,23,7),(14,24,40,5),(14,25,1,12),(14,25,4,7),(14,25,7,7),(14,25,11,2),(14,25,20,5),(14,25,23,13),(14,26,2,2),(14,26,8,1),(14,26,10,3),(14,26,15,5),(14,26,17,5),(14,26,18,1),(14,26,21,9),(14,26,26,9),(14,26,29,1),(14,27,14,1),(14,27,16,2),(14,27,20,1),(14,27,22,1),(14,27,26,2),(14,27,27,12),(14,27,28,2),(14,27,32,1),(14,27,33,5),(14,28,3,12),(14,28,5,13),(14,28,13,4),(14,28,14,5),(14,28,21,2),(14,28,22,6),(14,28,26,0),(14,28,33,3),(14,28,35,4),(14,28,37,12),(14,29,0,8),(14,29,14,0),(14,29,25,1),(14,29,37,13),(14,29,38,5),(14,30,0,6),(14,30,1,11),(14,30,2,5),(14,30,6,3),(14,30,13,12),(14,30,20,1),(14,30,21,5),(14,30,23,12),(14,31,9,7),(14,31,14,2),(14,31,18,10),(14,31,20,2),(14,31,22,11),(14,31,24,13),(14,31,33,8),(14,31,35,2),(14,31,37,5),(14,32,1,6),(14,32,5,8),(14,32,8,0),(14,32,9,4),(14,32,10,7),(14,32,14,0),(14,32,16,9),(14,32,20,4),(14,32,21,7),(14,32,23,7),(14,32,24,10),(16,0,9,13),(16,0,15,11),(16,0,16,12),(16,0,18,5),(16,0,19,9),(16,0,26,5),(16,0,28,6),(16,0,32,11),(16,0,36,2),(16,0,37,0),(16,1,2,5),(16,1,9,5),(16,1,13,10),(16,1,27,0),(16,1,28,12),(16,1,31,9),(16,1,33,8),(16,1,36,13),(16,2,3,1),(16,2,6,11),(16,2,9,10),(16,2,19,2),(16,3,0,3),(16,3,2,5),(16,3,3,6),(16,3,10,1),(16,3,12,8),(16,3,13,9),(16,3,17,0),(16,3,19,5),(16,3,31,12),(16,4,0,0),(16,4,5,6),(16,4,10,7),(16,4,12,4),(16,4,17,4),(16,4,20,11),(16,4,28,6),(16,4,31,1),(16,4,33,8),(16,5,3,11),(16,5,14,8),(16,5,16,4),(16,5,17,7),(16,5,23,10),(16,5,29,1),(16,5,33,3),(16,5,38,9),(16,5,40,9),(16,6,1,10),(16,6,2,1),(16,6,16,10),(16,6,18,4),(16,6,21,10),(16,6,29,1),(16,6,34,8),(16,6,37,12),(16,7,7,3),(16,7,16,3),(16,7,18,9),(16,7,19,4),(16,7,20,11),(16,7,28,0),(16,7,33,3),(16,8,4,13),(16,8,10,2),(16,8,12,11),(16,8,15,11),(16,8,17,11),(16,8,19,9),(16,8,40,8),(16,9,10,8),(16,9,13,12),(16,9,16,11),(16,9,28,0),(16,9,31,7),(16,9,39,7),(16,10,18,3),(16,11,0,13),(16,11,6,10),(16,11,40,3),(16,12,26,6),(16,12,33,10),(16,12,40,0),(16,13,25,11),(16,13,27,4),(16,13,33,4),(16,14,33,0),(16,14,34,0),(16,15,27,4),(16,15,28,5),(16,15,34,12),(16,16,27,10),(16,16,30,9),(16,16,32,6),(16,17,2,9),(16,17,15,11),(16,17,31,4),(16,17,32,0),(16,17,34,5),(16,18,0,3),(16,18,27,4),(16,18,29,11),(16,18,31,3),(16,19,1,6),(16,19,2,6),(16,19,14,9),(16,19,27,10),(16,20,12,10),(16,20,20,8),(16,20,31,5),(16,21,2,12),(16,21,12,5),(16,21,15,4),(16,21,19,13),(16,21,28,6),(16,21,39,2),(16,22,6,11),(16,22,8,1),(16,22,12,12),(16,22,13,11),(16,22,32,11),(16,22,33,7),(16,23,0,11),(16,23,5,3),(16,23,32,13),(16,23,33,1),(16,24,0,9),(16,24,6,13),(16,24,9,1),(16,24,14,6),(16,24,16,7),(16,24,30,1),(16,25,6,0),(16,25,7,8),(16,25,9,8),(16,25,14,6),(16,25,29,4),(16,25,38,7),(16,25,40,1),(16,26,5,1),(16,26,8,9),(16,26,18,12),(16,26,21,4),(16,27,7,10),(16,27,10,4),(16,27,16,2),(16,27,18,5),(16,27,21,6),(16,27,24,8),(16,27,29,6),(16,27,30,5),(16,28,11,0),(16,28,19,3),(16,28,20,11),(23,1,13,0),(23,3,1,6),(23,4,13,11),(23,5,0,4),(23,5,3,5),(23,5,12,1),(23,6,0,1),(23,6,8,13),(23,6,9,9),(23,7,5,11),(23,8,2,6),(23,8,9,4),(23,10,9,8),(23,11,10,13),(23,12,9,1),(23,13,8,10),(23,13,9,0),(23,14,10,13),(23,15,6,3),(23,16,5,7),(23,17,13,1),(23,18,10,5),(23,18,12,13),(23,19,7,12),(23,19,13,12),(23,20,3,9),(23,20,13,8),(23,21,6,2),(23,21,7,13),(23,21,13,12),(23,22,5,5),(23,22,7,12),(23,22,13,0),(23,23,0,11),(23,24,0,4),(23,24,5,1),(23,24,12,5),(23,26,13,7),(23,27,13,11),(23,28,9,10),(23,28,13,12),(23,29,5,8),(23,29,8,1),(23,29,9,3),(23,30,8,1),(23,30,9,5),(23,31,3,3),(23,31,8,3),(23,31,11,7),(23,31,12,4),(23,32,9,3),(23,32,13,6),(23,33,5,13),(23,33,9,0),(23,34,3,8),(23,34,7,3),(23,34,11,1),(23,35,0,13),(23,35,2,6),(23,35,8,1),(23,35,9,0),(23,35,10,4),(23,35,11,5),(23,36,5,0),(23,37,0,11),(23,37,1,0),(23,37,11,0),(23,38,3,9),(23,38,4,12),(23,38,9,10),(23,39,0,1),(23,39,3,5),(23,39,9,7),(23,39,13,11),(23,40,0,11),(23,40,3,6),(23,40,12,5),(23,40,13,10),(23,41,0,2),(23,41,9,9),(23,41,10,3),(23,42,3,5),(23,43,2,9),(23,43,3,1),(23,44,1,2),(23,44,4,3),(23,45,0,6),(23,46,4,6),(23,46,5,8),(23,48,5,1),(23,49,6,2),(23,50,4,6),(23,50,5,6),(31,0,1,2),(31,0,7,0),(31,0,8,13),(31,0,9,12),(31,0,21,10),(31,1,6,7),(31,1,8,9),(31,1,23,8),(31,2,6,0),(31,2,7,2),(31,2,17,6),(31,2,23,2),(31,3,12,8),(31,3,21,2),(31,3,22,11),(31,4,11,3),(31,4,17,6),(31,4,22,12),(31,5,19,11),(31,6,16,0),(31,6,18,8),(31,7,3,11),(31,7,6,13),(31,7,12,7),(31,7,19,4),(31,8,13,7),(31,8,16,2),(31,8,19,4),(31,9,17,9),(31,9,18,2),(31,9,19,11),(31,10,3,0),(31,10,11,6),(31,10,13,0),(31,10,15,8),(31,11,0,2),(31,11,4,11),(31,11,5,10),(31,11,7,1),(31,11,8,8),(31,11,12,11),(31,11,14,2),(31,11,17,5),(31,11,21,4),(31,12,6,2),(31,12,7,3),(31,12,8,11),(31,13,1,8),(31,13,8,8),(31,13,18,4),(31,13,19,12),(31,13,20,6),(31,14,2,3),(31,14,15,11),(31,14,16,11),(31,14,23,8),(31,15,17,3),(31,15,18,0),(31,15,19,3),(31,15,20,9),(31,15,21,11),(31,15,22,6),(31,15,23,10),(31,16,10,7),(31,16,19,4),(31,17,7,10),(31,17,9,9),(31,17,16,6),(31,17,17,9),(31,17,18,10),(31,18,18,6),(31,19,2,4),(31,19,5,2),(31,19,6,12),(31,19,8,3),(31,19,9,7),(31,19,16,7),(31,19,18,2),(31,19,20,7),(31,19,22,13),(31,20,2,11),(31,20,6,4),(31,20,10,4),(31,20,11,12),(31,20,12,12),(31,21,1,7),(31,21,23,8),(31,22,1,6),(31,22,4,9),(31,22,5,3),(31,22,7,8),(31,22,18,13),(31,22,20,11),(31,23,2,7),(31,23,4,3),(31,23,5,0),(31,23,7,9),(31,24,6,9),(31,24,7,9),(31,25,19,3),(31,25,21,7),(31,25,22,13),(31,26,21,7),(31,27,6,6),(31,27,10,9),(31,28,1,4),(31,28,5,0),(31,28,8,9),(31,28,10,10),(31,28,14,5),(31,28,16,6),(31,28,22,2),(31,29,4,5),(31,29,9,1),(31,29,21,4),(31,30,0,2),(31,30,5,4),(35,0,15,12),(35,0,17,5),(35,1,18,10),(35,1,23,10),(35,1,24,10),(35,1,25,8),(35,2,1,6),(35,2,18,2),(35,2,25,7),(35,3,3,3),(35,3,18,1),(35,3,19,0),(35,3,25,3),(35,3,26,0),(35,4,0,8),(35,4,3,11),(35,4,10,6),(35,4,11,9),(35,4,20,2),(35,5,2,11),(35,5,21,11),(35,5,25,0),(35,5,28,13),(35,5,29,6),(35,6,0,2),(35,6,6,11),(35,6,13,12),(35,6,14,5),(35,6,15,4),(35,6,20,2),(35,6,29,12),(35,7,3,11),(35,7,15,6),(35,7,17,0),(35,8,4,0),(35,8,11,2),(35,9,6,3),(35,9,10,6),(35,9,11,7),(35,9,14,9),(35,9,22,4),(35,10,1,1),(35,10,14,8),(35,10,19,11),(35,10,22,3),(35,12,4,10),(35,12,8,0),(35,13,3,11),(35,13,5,6),(35,13,7,12),(35,13,8,6),(35,13,9,2),(35,13,20,6),(35,13,22,7),(35,13,26,0),(35,13,29,5),(35,14,6,4),(35,14,22,7),(35,14,25,13),(35,15,22,7),(35,15,23,9),(35,16,7,9),(35,16,19,4),(35,16,22,4),(35,16,28,9),(35,17,6,13),(35,17,18,10),(35,18,8,5),(35,18,21,12),(35,18,26,2),(35,19,7,1),(35,19,14,5),(35,19,15,11),(35,19,19,8),(35,19,20,6),(35,20,13,9),(35,20,18,11),(35,20,19,1),(35,21,11,6),(35,21,16,2),(35,21,25,1),(35,22,5,7),(35,22,11,11),(35,22,23,5),(35,22,24,5),(35,23,5,3),(35,23,15,0),(35,23,16,4),(35,23,17,8),(35,23,19,9),(35,23,22,2),(35,23,23,3),(35,24,0,4),(35,24,3,7),(35,24,6,0),(35,24,12,1),(35,24,13,7),(35,24,19,2),(35,24,20,5),(35,24,21,7),(35,24,24,6),(35,25,2,9),(35,25,11,11),(35,25,13,8),(35,25,17,2),(35,25,18,0),(35,25,21,4),(35,25,22,3),(35,25,23,1),(35,25,26,12),(35,25,28,5),(35,26,0,5),(35,26,11,4),(35,26,15,11),(35,26,17,12),(35,26,21,6),(35,26,24,0),(35,26,26,5),(35,27,0,3),(35,27,16,11),(35,27,20,11),(35,27,27,6),(35,28,12,3),(35,29,13,6);
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
INSERT INTO `galaxies` VALUES (1,'2010-12-01 20:40:09','dev');
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
INSERT INTO `schema_migrations` VALUES ('20090601175224'),('20090601184051'),('20090601184055'),('20090601184059'),('20090701164131'),('20090713165021'),('20090808144214'),('20090809160211'),('20090810173759'),('20090826140238'),('20090826141836'),('20090829202538'),('20090829210029'),('20090829224505'),('20090830143959'),('20090830145319'),('20090901153809'),('20090904190655'),('20090905175341'),('20090905192056'),('20090906135044'),('20090909222719'),('20090911180950'),('20090912165229'),('20090919155819'),('20091024222359'),('20091103164416'),('20091103180558'),('20091103181146'),('20091109191211'),('20091225193714'),('20100114152902'),('20100121142414'),('20100127115341'),('20100127120219'),('20100127120515'),('20100127121337'),('20100129150736'),('20100203202757'),('20100203204803'),('20100204172507'),('20100204173714'),('20100208163239'),('20100210114531'),('20100212134334'),('20100218181507'),('20100219114448'),('20100220144106'),('20100222144003'),('20100223153023'),('20100224153728'),('20100224163525'),('20100225124928'),('20100225153721'),('20100225155505'),('20100225155739'),('20100226122144'),('20100226122651'),('20100301153626'),('20100302131225'),('20100303131706'),('20100308163148'),('20100308164422'),('20100310172315'),('20100310181338'),('20100311123523'),('20100315112858'),('20100319141401'),('20100322184529'),('20100324134243'),('20100324141652'),('20100331125702'),('20100415130556'),('20100415130600'),('20100415130605'),('20100415134627'),('20100419141518'),('20100419142018'),('20100419164230'),('20100426141509'),('20100428130912'),('20100429171200'),('20100430174140'),('20100610151652'),('20100610180750'),('20100614142225'),('20100614160819'),('20100614162423'),('20100616132525'),('20100616135507'),('20100622124252'),('20100706105523'),('20100710121447'),('20100710191351'),('20100716155807'),('20100719131622'),('20100721155359'),('20100722124307'),('20100812164444'),('20100812164449'),('20100812164518'),('20100812164524'),('20100817165213'),('20100819175736'),('20100820185846'),('20100906095758'),('20100915145823'),('20100929111549'),('20101001155323'),('20101005180058'),('20101022155620'),('20101117131430'),('99999999999000'),('99999999999900');
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
INSERT INTO `solar_systems` VALUES (1,'Expansion',1,2,2),(2,'Expansion',1,2,1),(3,'Homeworld',1,2,0),(4,'Resource',1,1,0);
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
) ENGINE=InnoDB AUTO_INCREMENT=48 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ss_objects`
--

LOCK TABLES `ss_objects` WRITE;
/*!40000 ALTER TABLE `ss_objects` DISABLE KEYS */;
INSERT INTO `ss_objects` VALUES (1,1,34,44,1,225,'Planet',NULL,'P-1',57,1,0,0,0,0,0,0,0,0,0,'2010-12-01 20:40:12',0),(2,1,0,0,2,120,'Asteroid',NULL,'',42,0,0,0,1,0,0,1,0,0,1,NULL,0),(3,1,0,0,1,180,'Asteroid',NULL,'',38,0,0,0,1,0,0,1,0,0,1,NULL,0),(4,1,0,0,2,210,'Asteroid',NULL,'',43,0,0,0,3,0,0,3,0,0,1,NULL,0),(5,1,0,0,3,156,'Jumpgate',NULL,'',60,0,0,0,0,0,0,0,0,0,0,NULL,0),(6,1,0,0,2,60,'Asteroid',NULL,'',28,0,0,0,0,0,0,0,0,0,1,NULL,0),(7,1,0,0,1,90,'Asteroid',NULL,'',46,0,0,0,1,0,0,1,0,0,0,NULL,0),(8,1,37,32,2,150,'Planet',NULL,'P-8',54,2,0,0,0,0,0,0,0,0,0,'2010-12-01 20:40:12',0),(9,1,0,0,1,135,'Asteroid',NULL,'',53,0,0,0,3,0,0,3,0,0,1,NULL,0),(10,1,0,0,2,180,'Asteroid',NULL,'',46,0,0,0,3,0,0,1,0,0,1,NULL,0),(11,1,0,0,0,270,'Asteroid',NULL,'',49,0,0,0,1,0,0,1,0,0,1,NULL,0),(12,1,0,0,2,0,'Asteroid',NULL,'',27,0,0,0,3,0,0,3,0,0,1,NULL,0),(13,1,0,0,0,180,'Asteroid',NULL,'',26,0,0,0,0,0,0,0,0,0,1,NULL,0),(14,1,33,41,0,0,'Planet',NULL,'P-14',56,2,0,0,0,0,0,0,0,0,0,'2010-12-01 20:40:12',0),(15,2,0,0,1,45,'Asteroid',NULL,'',55,0,0,0,2,0,0,1,0,0,2,NULL,0),(16,2,29,41,1,225,'Planet',NULL,'P-16',54,1,0,0,0,0,0,0,0,0,0,'2010-12-01 20:40:12',0),(17,2,0,0,2,90,'Asteroid',NULL,'',34,0,0,0,3,0,0,1,0,0,2,NULL,0),(18,2,0,0,2,120,'Asteroid',NULL,'',30,0,0,0,1,0,0,0,0,0,0,NULL,0),(19,2,0,0,3,246,'Jumpgate',NULL,'',32,0,0,0,0,0,0,0,0,0,0,NULL,0),(20,2,0,0,2,210,'Asteroid',NULL,'',33,0,0,0,1,0,0,1,0,0,1,NULL,0),(21,2,0,0,1,0,'Asteroid',NULL,'',30,0,0,0,2,0,0,2,0,0,3,NULL,0),(22,2,0,0,2,30,'Asteroid',NULL,'',39,0,0,0,2,0,0,1,0,0,3,NULL,0),(23,2,51,14,0,90,'Planet',NULL,'P-23',52,2,0,0,0,0,0,0,0,0,0,'2010-12-01 20:40:12',0),(24,2,0,0,2,180,'Asteroid',NULL,'',44,0,0,0,0,0,0,0,0,0,1,NULL,0),(25,2,0,0,1,135,'Asteroid',NULL,'',49,0,0,0,2,0,0,3,0,0,3,NULL,0),(26,2,0,0,0,270,'Asteroid',NULL,'',51,0,0,0,3,0,0,2,0,0,1,NULL,0),(27,2,0,0,2,270,'Asteroid',NULL,'',30,0,0,0,0,0,0,1,0,0,1,NULL,0),(28,2,0,0,0,0,'Asteroid',NULL,'',27,0,0,0,1,0,0,0,0,0,0,NULL,0),(29,3,0,0,2,120,'Asteroid',NULL,'',46,0,0,0,1,0,0,1,0,0,1,NULL,0),(30,3,0,0,0,90,'Asteroid',NULL,'',33,0,0,0,0,0,0,0,0,0,0,NULL,0),(31,3,31,24,1,135,'Planet',NULL,'P-31',48,1,0,0,0,0,0,0,0,0,0,'2010-12-01 20:40:12',0),(32,3,0,0,0,270,'Asteroid',NULL,'',45,0,0,0,0,0,0,1,0,0,1,NULL,0),(33,3,0,0,2,240,'Asteroid',NULL,'',60,0,0,0,1,0,0,0,0,0,1,NULL,0),(34,3,0,0,3,90,'Jumpgate',NULL,'',47,0,0,0,0,0,0,0,0,0,0,NULL,0),(35,3,30,30,0,180,'Planet',1,'P-35',50,0,864,2,3024,1728,4,6048,0,0,604.8,'2010-12-01 20:40:12',0),(36,3,0,0,0,0,'Asteroid',NULL,'',30,0,0,0,1,0,0,0,0,0,0,NULL,0),(37,4,0,0,2,30,'Asteroid',NULL,'',44,0,0,0,2,0,0,3,0,0,2,NULL,0),(38,4,0,0,0,90,'Asteroid',NULL,'',32,0,0,0,3,0,0,1,0,0,3,NULL,0),(39,4,0,0,1,135,'Asteroid',NULL,'',52,0,0,0,0,0,0,0,0,0,1,NULL,0),(40,4,0,0,0,270,'Asteroid',NULL,'',28,0,0,0,1,0,0,0,0,0,1,NULL,0),(41,4,0,0,3,202,'Jumpgate',NULL,'',59,0,0,0,0,0,0,0,0,0,0,NULL,0),(42,4,0,0,2,0,'Asteroid',NULL,'',30,0,0,0,2,0,0,1,0,0,1,NULL,0),(43,4,0,0,3,66,'Jumpgate',NULL,'',26,0,0,0,0,0,0,0,0,0,0,NULL,0),(44,4,0,0,2,270,'Asteroid',NULL,'',52,0,0,0,1,0,0,3,0,0,3,NULL,0),(45,4,0,0,3,224,'Jumpgate',NULL,'',34,0,0,0,0,0,0,0,0,0,0,NULL,0),(46,4,0,0,2,60,'Asteroid',NULL,'',54,0,0,0,1,0,0,2,0,0,3,NULL,0),(47,4,0,0,0,180,'Asteroid',NULL,'',57,0,0,0,0,0,0,1,0,0,1,NULL,0);
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
INSERT INTO `tiles` VALUES (5,1,0,0),(5,1,0,1),(5,1,0,2),(5,1,0,3),(5,1,0,4),(5,1,0,5),(4,1,0,17),(4,1,0,18),(4,1,0,20),(4,1,0,21),(4,1,0,22),(4,1,0,23),(12,1,0,30),(6,1,0,36),(6,1,0,37),(6,1,0,38),(8,1,0,40),(5,1,1,1),(5,1,1,2),(5,1,1,3),(5,1,1,4),(5,1,1,5),(4,1,1,16),(4,1,1,17),(4,1,1,18),(4,1,1,19),(4,1,1,20),(4,1,1,21),(4,1,1,22),(5,1,1,27),(5,1,1,28),(5,1,1,29),(6,1,1,37),(6,1,1,38),(5,1,2,0),(5,1,2,1),(5,1,2,2),(5,1,2,3),(5,1,2,4),(5,1,2,5),(5,1,2,6),(5,1,2,7),(5,1,2,8),(5,1,2,9),(4,1,2,10),(2,1,2,11),(4,1,2,17),(4,1,2,18),(4,1,2,20),(4,1,2,21),(4,1,2,22),(4,1,2,23),(5,1,2,25),(5,1,2,26),(5,1,2,27),(5,1,2,28),(5,1,2,29),(6,1,2,37),(6,1,2,38),(6,1,2,39),(5,1,3,0),(5,1,3,1),(5,1,3,2),(5,1,3,3),(5,1,3,4),(5,1,3,5),(5,1,3,6),(4,1,3,10),(4,1,3,18),(4,1,3,19),(4,1,3,20),(4,1,3,21),(4,1,3,22),(1,1,3,23),(5,1,3,25),(5,1,3,26),(5,1,3,27),(5,1,3,28),(5,1,3,29),(6,1,3,38),(6,1,3,39),(6,1,3,40),(5,1,4,0),(5,1,4,1),(5,1,4,2),(5,1,4,3),(5,1,4,4),(5,1,4,5),(4,1,4,8),(4,1,4,10),(4,1,4,11),(4,1,4,13),(4,1,4,16),(4,1,4,18),(4,1,4,19),(4,1,4,20),(4,1,4,21),(4,1,4,22),(5,1,4,25),(5,1,4,26),(5,1,4,27),(5,1,4,28),(5,1,4,29),(6,1,4,38),(6,1,4,39),(5,1,5,0),(5,1,5,1),(5,1,5,4),(4,1,5,8),(4,1,5,9),(4,1,5,10),(4,1,5,11),(4,1,5,12),(4,1,5,13),(4,1,5,14),(4,1,5,15),(4,1,5,16),(4,1,5,18),(4,1,5,19),(4,1,5,20),(5,1,5,23),(5,1,5,24),(5,1,5,25),(5,1,5,26),(5,1,5,27),(5,1,5,28),(5,1,5,29),(6,1,5,37),(6,1,5,38),(5,1,6,0),(5,1,6,2),(5,1,6,3),(5,1,6,4),(4,1,6,9),(4,1,6,10),(4,1,6,11),(4,1,6,12),(4,1,6,13),(4,1,6,14),(0,1,6,15),(4,1,6,18),(4,1,6,19),(4,1,6,20),(4,1,6,21),(4,1,6,22),(5,1,6,23),(5,1,6,24),(5,1,6,25),(5,1,6,26),(5,1,6,27),(5,1,6,28),(5,1,6,29),(6,1,6,37),(6,1,6,38),(4,1,7,10),(4,1,7,11),(4,1,7,12),(4,1,7,13),(4,1,7,14),(4,1,7,20),(4,1,7,22),(5,1,7,23),(5,1,7,24),(5,1,7,27),(5,1,7,29),(5,1,7,30),(6,1,7,38),(4,1,8,9),(4,1,8,10),(4,1,8,11),(4,1,8,12),(4,1,8,13),(4,1,8,14),(5,1,8,23),(5,1,8,24),(5,1,8,29),(10,1,8,36),(3,1,9,7),(4,1,9,10),(4,1,9,12),(4,1,9,13),(4,1,9,14),(5,1,9,23),(3,1,10,6),(3,1,10,7),(3,1,10,8),(3,1,10,10),(4,1,10,13),(4,1,10,14),(10,1,10,40),(3,1,11,6),(3,1,11,7),(3,1,11,8),(3,1,11,9),(3,1,11,10),(3,1,11,12),(3,1,11,13),(3,1,11,14),(3,1,11,15),(3,1,12,7),(3,1,12,9),(3,1,12,10),(3,1,12,11),(3,1,12,12),(3,1,12,13),(3,1,13,6),(3,1,13,7),(3,1,13,8),(3,1,13,9),(3,1,13,10),(3,1,13,12),(3,1,13,13),(5,1,13,15),(5,1,13,16),(0,1,13,19),(4,1,14,6),(3,1,14,7),(3,1,14,8),(3,1,14,9),(3,1,14,10),(3,1,14,11),(8,1,14,12),(5,1,14,16),(5,1,14,17),(5,1,14,21),(5,1,14,22),(4,1,15,6),(3,1,15,7),(3,1,15,8),(4,1,15,9),(4,1,15,10),(5,1,15,15),(5,1,15,16),(5,1,15,17),(5,1,15,18),(5,1,15,19),(5,1,15,20),(5,1,15,21),(5,1,15,22),(5,1,15,23),(1,1,15,26),(6,1,15,40),(6,1,15,41),(4,1,16,5),(4,1,16,6),(4,1,16,7),(4,1,16,8),(4,1,16,9),(4,1,16,11),(5,1,16,16),(5,1,16,17),(5,1,16,18),(5,1,16,19),(5,1,16,20),(5,1,16,21),(5,1,16,22),(0,1,16,35),(6,1,16,39),(6,1,16,40),(6,1,16,41),(6,1,16,42),(6,1,16,43),(13,1,17,0),(4,1,17,6),(4,1,17,7),(4,1,17,8),(4,1,17,9),(4,1,17,10),(4,1,17,11),(5,1,17,16),(5,1,17,17),(5,1,17,18),(5,1,17,19),(5,1,17,20),(5,1,17,21),(5,1,17,22),(6,1,17,38),(6,1,17,39),(6,1,17,40),(6,1,17,41),(6,1,17,42),(6,1,17,43),(4,1,18,4),(4,1,18,5),(4,1,18,6),(4,1,18,7),(4,1,18,8),(4,1,18,11),(5,1,18,17),(5,1,18,18),(5,1,18,19),(5,1,18,20),(6,1,18,37),(6,1,18,38),(6,1,18,39),(6,1,18,40),(6,1,18,42),(6,1,18,43),(4,1,19,4),(4,1,19,5),(4,1,19,6),(4,1,19,7),(4,1,19,8),(4,1,19,9),(5,1,19,17),(5,1,19,18),(3,1,19,34),(6,1,19,38),(6,1,19,39),(6,1,19,40),(6,1,19,41),(6,1,19,42),(6,1,19,43),(4,1,20,2),(4,1,20,3),(4,1,20,4),(4,1,20,5),(4,1,20,6),(4,1,20,7),(4,1,20,8),(4,1,20,9),(4,1,20,10),(4,1,20,11),(4,1,20,12),(5,1,20,18),(5,1,20,19),(3,1,20,34),(6,1,20,38),(6,1,20,39),(6,1,20,40),(6,1,20,41),(6,1,20,43),(12,1,21,4),(5,1,21,19),(5,1,21,20),(5,1,21,21),(3,1,21,30),(3,1,21,31),(3,1,21,32),(3,1,21,33),(3,1,21,34),(6,1,21,38),(6,1,21,39),(6,1,21,40),(6,1,21,41),(6,1,21,42),(6,1,21,43),(5,1,22,21),(3,1,22,33),(3,1,22,34),(3,1,22,35),(3,1,22,36),(0,1,22,41),(0,1,23,31),(3,1,23,33),(3,1,23,34),(3,1,23,35),(0,1,24,27),(3,1,24,33),(3,1,24,34),(3,1,24,35),(3,1,24,36),(3,1,25,16),(3,1,25,17),(3,1,25,18),(3,1,25,19),(3,1,25,20),(3,1,25,21),(3,1,25,35),(3,1,25,36),(3,1,25,37),(3,1,25,38),(3,1,26,18),(3,1,26,19),(3,1,26,21),(3,1,26,22),(4,1,26,24),(4,1,26,25),(4,1,26,26),(3,1,26,33),(3,1,26,34),(3,1,26,35),(3,1,26,38),(4,1,27,4),(4,1,27,5),(4,1,27,6),(4,1,27,7),(4,1,27,8),(4,1,27,9),(4,1,27,10),(4,1,27,11),(3,1,27,17),(3,1,27,18),(3,1,27,19),(3,1,27,20),(3,1,27,21),(3,1,27,22),(4,1,27,23),(4,1,27,24),(4,1,27,25),(3,1,27,34),(3,1,27,35),(3,1,27,36),(3,1,27,37),(4,1,28,3),(4,1,28,4),(4,1,28,5),(4,1,28,6),(4,1,28,7),(4,1,28,8),(4,1,28,9),(4,1,28,11),(4,1,28,12),(3,1,28,18),(3,1,28,19),(3,1,28,21),(3,1,28,22),(3,1,28,23),(4,1,28,24),(4,1,28,25),(4,1,28,26),(0,1,28,34),(3,1,28,36),(3,1,28,37),(0,1,28,39),(4,1,29,3),(4,1,29,4),(4,1,29,5),(4,1,29,6),(4,1,29,9),(4,1,29,10),(3,1,29,19),(3,1,29,20),(3,1,29,21),(3,1,29,22),(3,1,29,23),(3,1,29,24),(4,1,29,25),(4,1,29,26),(4,1,29,27),(3,1,29,37),(3,1,29,38),(4,1,30,4),(4,1,30,5),(4,1,30,6),(4,1,30,7),(4,1,30,8),(4,1,30,10),(3,1,30,19),(3,1,30,20),(3,1,30,21),(3,1,30,23),(3,1,30,24),(4,1,30,25),(4,1,30,26),(4,1,30,27),(4,1,30,28),(4,1,30,29),(4,1,31,4),(4,1,31,5),(4,1,31,6),(4,1,31,7),(4,1,31,8),(4,1,31,9),(3,1,31,20),(3,1,31,21),(4,1,31,22),(4,1,31,23),(4,1,31,24),(4,1,31,25),(4,1,31,26),(4,1,31,27),(4,1,31,29),(4,1,32,6),(4,1,32,23),(4,1,32,24),(4,1,32,25),(4,1,32,26),(4,1,32,27),(4,1,32,28),(4,1,32,29),(4,1,32,30),(4,1,33,5),(4,1,33,6),(4,1,33,7),(4,1,33,23),(4,1,33,24),(4,1,33,25),(4,1,33,26),(4,1,33,27),(4,1,33,28),(4,1,33,29),(6,8,0,0),(6,8,0,1),(6,8,0,3),(6,8,0,4),(4,8,0,5),(5,8,0,12),(5,8,0,21),(6,8,1,0),(6,8,1,1),(6,8,1,2),(6,8,1,3),(4,8,1,5),(4,8,1,6),(5,8,1,11),(5,8,1,12),(5,8,1,13),(5,8,1,14),(5,8,1,18),(5,8,1,21),(5,8,1,22),(5,8,1,23),(6,8,2,0),(6,8,2,1),(6,8,2,2),(6,8,2,3),(4,8,2,4),(4,8,2,5),(5,8,2,6),(5,8,2,7),(5,8,2,11),(5,8,2,12),(5,8,2,13),(5,8,2,14),(5,8,2,18),(5,8,2,20),(5,8,2,21),(5,8,2,22),(6,8,3,1),(6,8,3,2),(4,8,3,3),(4,8,3,4),(4,8,3,5),(5,8,3,6),(5,8,3,7),(5,8,3,11),(5,8,3,12),(5,8,3,13),(5,8,3,14),(5,8,3,15),(5,8,3,16),(5,8,3,17),(5,8,3,18),(5,8,3,19),(5,8,3,20),(5,8,3,21),(4,8,4,1),(4,8,4,2),(4,8,4,3),(4,8,4,4),(4,8,4,5),(4,8,4,6),(5,8,4,7),(5,8,4,8),(5,8,4,9),(5,8,4,10),(5,8,4,11),(5,8,4,12),(5,8,4,13),(5,8,4,14),(5,8,4,15),(0,8,4,16),(5,8,4,18),(5,8,4,19),(5,8,4,20),(5,8,4,21),(5,8,4,22),(4,8,5,2),(4,8,5,3),(4,8,5,4),(4,8,5,5),(5,8,5,10),(5,8,5,11),(5,8,5,12),(5,8,5,13),(5,8,5,14),(5,8,5,15),(5,8,5,19),(5,8,5,20),(5,8,5,21),(4,8,6,2),(4,8,6,3),(4,8,6,5),(5,8,6,10),(5,8,6,11),(5,8,6,12),(5,8,6,13),(5,8,6,14),(5,8,6,15),(5,8,6,16),(5,8,6,17),(5,8,6,18),(5,8,6,19),(5,8,6,20),(5,8,6,21),(5,8,6,22),(4,8,7,3),(4,8,7,4),(4,8,7,5),(3,8,7,10),(5,8,7,11),(5,8,7,12),(5,8,7,13),(5,8,7,14),(5,8,7,15),(5,8,7,16),(5,8,7,17),(5,8,7,18),(5,8,7,19),(5,8,7,20),(5,8,7,22),(5,8,7,23),(14,8,8,0),(4,8,8,4),(4,8,8,5),(3,8,8,10),(5,8,8,11),(5,8,8,12),(0,8,8,13),(5,8,8,15),(3,8,8,16),(3,8,8,17),(10,8,8,18),(4,8,9,4),(4,8,9,5),(4,8,9,6),(4,8,9,7),(3,8,9,8),(3,8,9,9),(3,8,9,10),(3,8,9,11),(3,8,9,12),(3,8,9,15),(3,8,9,16),(3,8,9,17),(4,8,10,4),(4,8,10,5),(4,8,10,6),(4,8,10,7),(4,8,10,8),(3,8,10,9),(3,8,10,10),(3,8,10,11),(3,8,10,12),(3,8,10,13),(3,8,10,14),(3,8,10,15),(3,8,10,16),(3,8,10,17),(4,8,11,2),(6,8,11,3),(6,8,11,4),(4,8,11,5),(4,8,11,6),(4,8,11,7),(4,8,11,10),(3,8,11,17),(4,8,12,1),(4,8,12,2),(4,8,12,3),(4,8,12,4),(4,8,12,5),(4,8,12,6),(4,8,12,7),(4,8,12,10),(4,8,12,19),(4,8,12,20),(0,8,13,2),(4,8,13,4),(4,8,13,5),(4,8,13,6),(4,8,13,7),(4,8,13,8),(4,8,13,9),(4,8,13,10),(4,8,13,17),(4,8,13,20),(4,8,14,4),(4,8,14,5),(4,8,14,7),(4,8,14,8),(4,8,14,9),(4,8,14,10),(4,8,14,17),(4,8,14,18),(4,8,14,19),(4,8,14,20),(4,8,15,3),(4,8,15,4),(4,8,15,5),(4,8,15,8),(4,8,15,9),(4,8,15,10),(4,8,15,16),(4,8,15,17),(4,8,15,18),(4,8,15,19),(0,8,15,20),(3,8,16,1),(3,8,16,2),(3,8,16,3),(3,8,16,4),(3,8,16,5),(4,8,16,8),(2,8,16,9),(4,8,16,16),(4,8,16,17),(4,8,16,18),(4,8,16,19),(3,8,16,22),(3,8,16,23),(3,8,16,24),(3,8,17,3),(3,8,17,4),(3,8,17,5),(3,8,17,13),(4,8,17,16),(4,8,17,17),(4,8,17,18),(4,8,17,19),(4,8,17,20),(3,8,17,21),(3,8,17,22),(3,8,17,23),(3,8,17,24),(3,8,17,25),(0,8,17,27),(3,8,18,1),(3,8,18,3),(3,8,18,4),(3,8,18,5),(3,8,18,13),(4,8,18,14),(4,8,18,15),(4,8,18,16),(4,8,18,17),(4,8,18,18),(4,8,18,19),(4,8,18,20),(3,8,18,21),(3,8,18,22),(3,8,18,23),(3,8,18,24),(3,8,18,25),(6,8,18,30),(3,8,19,1),(3,8,19,2),(3,8,19,3),(3,8,19,4),(14,8,19,8),(3,8,19,13),(3,8,19,14),(1,8,19,16),(4,8,19,19),(4,8,19,20),(4,8,19,21),(4,8,19,22),(3,8,19,23),(3,8,19,24),(3,8,19,25),(3,8,19,26),(6,8,19,30),(3,8,20,1),(3,8,20,2),(3,8,20,3),(3,8,20,4),(3,8,20,12),(3,8,20,13),(3,8,20,14),(3,8,20,15),(4,8,20,19),(4,8,20,20),(3,8,20,22),(3,8,20,23),(3,8,20,24),(3,8,20,25),(3,8,20,26),(6,8,20,30),(6,8,20,31),(3,8,21,3),(3,8,21,4),(9,8,21,5),(3,8,21,12),(3,8,21,13),(3,8,21,14),(3,8,21,15),(3,8,21,16),(3,8,21,17),(3,8,21,26),(3,8,21,27),(6,8,21,29),(6,8,21,30),(6,8,21,31),(3,8,22,13),(3,8,22,14),(3,8,22,15),(3,8,22,26),(6,8,22,27),(6,8,22,28),(6,8,22,29),(6,8,22,30),(6,8,22,31),(0,8,23,12),(3,8,23,14),(3,8,23,15),(3,8,23,16),(5,8,23,26),(5,8,23,27),(6,8,23,29),(6,8,23,30),(5,8,23,31),(3,8,24,14),(1,8,24,16),(0,8,24,20),(5,8,24,27),(5,8,24,29),(5,8,24,30),(5,8,24,31),(4,8,25,5),(4,8,25,7),(3,8,25,14),(5,8,25,27),(5,8,25,28),(5,8,25,29),(5,8,25,30),(5,8,25,31),(4,8,26,4),(4,8,26,5),(4,8,26,6),(4,8,26,7),(4,8,26,8),(6,8,26,22),(5,8,26,26),(5,8,26,27),(5,8,26,29),(5,8,26,30),(5,8,26,31),(4,8,27,1),(4,8,27,2),(4,8,27,3),(4,8,27,4),(4,8,27,5),(4,8,27,6),(4,8,27,7),(4,8,27,8),(6,8,27,20),(6,8,27,21),(6,8,27,22),(6,8,27,23),(9,8,27,24),(5,8,27,27),(5,8,27,28),(5,8,27,29),(5,8,27,30),(4,8,28,0),(4,8,28,1),(4,8,28,2),(4,8,28,3),(4,8,28,4),(4,8,28,5),(4,8,28,6),(4,8,28,7),(4,8,28,9),(4,8,28,10),(6,8,28,21),(6,8,28,22),(6,8,28,23),(5,8,28,27),(5,8,28,28),(5,8,28,29),(5,8,28,30),(5,8,28,31),(3,8,29,0),(4,8,29,4),(4,8,29,5),(4,8,29,6),(4,8,29,7),(4,8,29,8),(4,8,29,9),(6,8,29,20),(6,8,29,21),(6,8,29,22),(5,8,29,27),(5,8,29,28),(5,8,29,29),(5,8,29,30),(5,8,29,31),(3,8,30,0),(4,8,30,7),(4,8,30,8),(6,8,30,21),(5,8,30,27),(5,8,30,28),(5,8,30,29),(5,8,30,30),(5,8,30,31),(3,8,31,0),(3,8,31,1),(4,8,31,8),(6,8,31,21),(5,8,31,24),(5,8,31,25),(5,8,31,26),(5,8,31,27),(5,8,31,28),(5,8,31,29),(5,8,31,30),(5,8,31,31),(3,8,32,0),(3,8,32,2),(3,8,32,5),(0,8,32,9),(6,8,32,21),(5,8,32,22),(5,8,32,23),(5,8,32,24),(5,8,32,25),(5,8,32,26),(5,8,32,28),(5,8,32,29),(5,8,32,30),(5,8,32,31),(3,8,33,0),(3,8,33,2),(3,8,33,3),(3,8,33,5),(5,8,33,25),(5,8,33,26),(5,8,33,28),(5,8,33,29),(5,8,33,30),(5,8,33,31),(3,8,34,0),(3,8,34,1),(3,8,34,2),(3,8,34,3),(3,8,34,4),(3,8,34,5),(5,8,34,23),(5,8,34,24),(5,8,34,25),(5,8,34,26),(5,8,34,27),(5,8,34,28),(5,8,34,29),(5,8,34,30),(5,8,34,31),(3,8,35,0),(3,8,35,2),(3,8,35,3),(3,8,35,5),(5,8,35,24),(5,8,35,25),(5,8,35,26),(5,8,35,27),(5,8,35,28),(5,8,35,29),(5,8,35,30),(5,8,35,31),(3,8,36,0),(5,8,36,24),(5,8,36,25),(5,8,36,26),(5,8,36,27),(5,8,36,28),(5,8,36,29),(5,8,36,30),(5,8,36,31),(4,14,0,0),(4,14,0,1),(4,14,0,2),(4,14,0,3),(5,14,0,22),(5,14,0,23),(5,14,0,25),(4,14,1,0),(4,14,1,1),(4,14,1,2),(4,14,1,3),(4,14,1,4),(4,14,1,5),(3,14,1,15),(3,14,1,16),(3,14,1,17),(5,14,1,22),(5,14,1,23),(5,14,1,24),(5,14,1,25),(4,14,2,0),(4,14,2,1),(4,14,2,2),(4,14,2,4),(3,14,2,15),(3,14,2,16),(3,14,2,17),(5,14,2,22),(5,14,2,23),(4,14,3,0),(4,14,3,1),(4,14,3,3),(6,14,3,10),(3,14,3,11),(3,14,3,12),(3,14,3,16),(3,14,3,17),(5,14,3,21),(5,14,3,22),(5,14,3,23),(5,14,3,24),(3,14,3,39),(4,14,4,0),(4,14,4,1),(4,14,4,2),(4,14,4,3),(4,14,4,4),(6,14,4,9),(6,14,4,10),(3,14,4,12),(3,14,4,13),(3,14,4,14),(3,14,4,16),(3,14,4,17),(3,14,4,18),(5,14,4,21),(5,14,4,22),(3,14,4,37),(3,14,4,38),(3,14,4,39),(4,14,5,0),(4,14,5,1),(4,14,5,3),(4,14,5,4),(4,14,5,5),(6,14,5,10),(6,14,5,12),(3,14,5,14),(3,14,5,15),(3,14,5,16),(3,14,5,17),(3,14,5,18),(3,14,5,19),(6,14,5,20),(12,14,5,21),(3,14,5,34),(3,14,5,35),(3,14,5,36),(3,14,5,37),(3,14,5,39),(4,14,6,1),(4,14,6,2),(4,14,6,5),(6,14,6,9),(6,14,6,10),(6,14,6,11),(6,14,6,12),(6,14,6,13),(3,14,6,14),(3,14,6,15),(3,14,6,16),(3,14,6,17),(3,14,6,18),(6,14,6,19),(6,14,6,20),(1,14,6,29),(0,14,6,34),(3,14,6,36),(3,14,6,37),(3,14,6,39),(6,14,7,2),(6,14,7,4),(6,14,7,5),(6,14,7,9),(6,14,7,10),(6,14,7,12),(6,14,7,13),(3,14,7,14),(3,14,7,15),(3,14,7,16),(6,14,7,19),(6,14,7,20),(3,14,7,36),(3,14,7,37),(3,14,7,38),(3,14,7,39),(3,14,7,40),(6,14,8,2),(6,14,8,4),(6,14,8,5),(6,14,8,6),(6,14,8,7),(6,14,8,9),(6,14,8,10),(6,14,8,11),(3,14,8,14),(3,14,8,16),(3,14,8,17),(6,14,8,19),(6,14,8,20),(3,14,8,34),(3,14,8,35),(3,14,8,36),(3,14,8,37),(3,14,8,38),(3,14,8,39),(3,14,8,40),(6,14,9,1),(6,14,9,2),(6,14,9,3),(6,14,9,4),(6,14,9,5),(6,14,9,6),(6,14,9,7),(6,14,9,8),(3,14,9,15),(3,14,9,16),(6,14,9,17),(6,14,9,18),(6,14,9,19),(6,14,9,20),(3,14,9,35),(3,14,9,36),(3,14,9,37),(3,14,9,38),(3,14,9,39),(3,14,9,40),(6,14,10,5),(6,14,10,6),(6,14,10,7),(6,14,10,8),(6,14,10,9),(3,14,10,14),(3,14,10,15),(3,14,10,16),(3,14,10,17),(3,14,10,18),(6,14,10,19),(6,14,10,20),(3,14,10,34),(3,14,10,35),(3,14,10,36),(3,14,10,37),(3,14,10,38),(3,14,10,39),(0,14,11,2),(6,14,11,5),(6,14,11,6),(6,14,11,7),(6,14,11,8),(6,14,11,9),(5,14,11,13),(3,14,11,14),(3,14,11,15),(3,14,11,16),(5,14,11,17),(5,14,11,18),(6,14,11,19),(14,14,11,24),(3,14,11,34),(3,14,11,35),(3,14,11,38),(6,14,12,4),(6,14,12,5),(6,14,12,6),(6,14,12,7),(6,14,12,9),(6,14,12,10),(5,14,12,13),(5,14,12,14),(5,14,12,15),(5,14,12,16),(5,14,12,17),(6,14,12,19),(6,14,12,20),(3,14,12,31),(3,14,12,32),(3,14,12,33),(3,14,12,34),(13,14,13,5),(6,14,13,7),(6,14,13,9),(5,14,13,13),(5,14,13,14),(5,14,13,15),(5,14,13,16),(6,14,13,19),(4,14,13,34),(4,14,13,35),(5,14,14,12),(5,14,14,13),(5,14,14,14),(4,14,14,33),(4,14,14,34),(4,14,14,37),(0,14,14,38),(5,14,15,9),(5,14,15,10),(5,14,15,11),(5,14,15,12),(0,14,15,29),(4,14,15,33),(4,14,15,34),(4,14,15,35),(4,14,15,37),(5,14,16,9),(5,14,16,10),(5,14,16,11),(5,14,16,12),(4,14,16,33),(4,14,16,34),(4,14,16,35),(4,14,16,36),(4,14,16,37),(4,14,16,38),(4,14,16,39),(4,14,16,40),(5,14,17,7),(5,14,17,8),(5,14,17,9),(5,14,17,10),(5,14,17,11),(5,14,17,12),(5,14,17,13),(4,14,17,31),(4,14,17,32),(4,14,17,33),(4,14,17,34),(4,14,17,35),(4,14,17,36),(4,14,17,37),(4,14,17,39),(4,14,17,40),(9,14,18,0),(12,14,18,7),(4,14,18,13),(9,14,18,21),(1,14,18,33),(4,14,18,35),(4,14,18,36),(4,14,19,13),(4,14,19,14),(4,14,19,15),(4,14,19,35),(4,14,19,36),(4,14,20,13),(4,14,20,14),(4,14,20,15),(4,14,20,16),(4,14,20,17),(4,14,20,18),(3,14,20,30),(3,14,20,31),(3,14,20,32),(3,14,20,33),(4,14,21,13),(4,14,21,14),(4,14,21,15),(4,14,21,16),(4,14,21,17),(4,14,21,18),(3,14,21,28),(3,14,21,29),(3,14,21,30),(3,14,21,31),(2,14,21,38),(4,14,22,13),(4,14,22,14),(4,14,22,15),(4,14,22,16),(4,14,22,17),(3,14,22,28),(3,14,22,29),(3,14,22,30),(3,14,22,31),(3,14,22,32),(3,14,22,34),(3,14,22,35),(4,14,23,14),(4,14,23,16),(4,14,23,17),(3,14,23,28),(3,14,23,29),(3,14,23,30),(3,14,23,31),(3,14,23,32),(3,14,23,33),(3,14,23,35),(4,14,23,38),(4,14,24,13),(4,14,24,14),(4,14,24,15),(4,14,24,16),(4,14,24,17),(3,14,24,27),(3,14,24,28),(3,14,24,29),(3,14,24,30),(3,14,24,31),(3,14,24,32),(3,14,24,33),(3,14,24,34),(3,14,24,35),(3,14,24,36),(3,14,24,37),(4,14,24,38),(4,14,24,39),(4,14,25,5),(4,14,25,13),(3,14,25,29),(3,14,25,31),(0,14,25,32),(3,14,25,34),(3,14,25,35),(4,14,25,36),(4,14,25,37),(4,14,25,38),(4,14,25,39),(4,14,25,40),(4,14,26,4),(4,14,26,5),(4,14,26,6),(4,14,26,7),(4,14,26,9),(3,14,26,30),(3,14,26,31),(3,14,26,34),(3,14,26,35),(4,14,26,36),(4,14,26,37),(4,14,26,38),(4,14,26,39),(4,14,26,40),(4,14,27,5),(4,14,27,6),(4,14,27,7),(4,14,27,8),(4,14,27,9),(4,14,27,10),(4,14,27,11),(3,14,27,34),(3,14,27,35),(4,14,27,36),(4,14,27,38),(4,14,27,39),(4,14,27,40),(4,14,28,6),(4,14,28,7),(4,14,28,8),(4,14,28,9),(4,14,28,10),(0,14,28,15),(5,14,28,28),(5,14,28,29),(5,14,28,30),(4,14,28,36),(4,14,28,39),(4,14,28,40),(4,14,29,3),(4,14,29,4),(4,14,29,5),(4,14,29,6),(4,14,29,7),(4,14,29,8),(4,14,29,9),(4,14,29,10),(5,14,29,26),(5,14,29,27),(5,14,29,28),(5,14,29,29),(6,14,29,32),(6,14,29,33),(6,14,29,35),(4,14,29,39),(4,14,29,40),(4,14,30,3),(4,14,30,8),(4,14,30,9),(4,14,30,10),(5,14,30,26),(5,14,30,27),(5,14,30,28),(6,14,30,32),(6,14,30,33),(6,14,30,34),(6,14,30,35),(4,14,30,39),(4,14,30,40),(5,14,31,26),(5,14,31,27),(5,14,31,28),(6,14,31,31),(6,14,31,32),(6,14,31,34),(4,14,31,38),(4,14,31,39),(4,14,31,40),(5,14,32,27),(5,14,32,28),(6,14,32,29),(6,14,32,30),(6,14,32,31),(6,14,32,32),(6,14,32,33),(6,14,32,34),(6,14,32,35),(4,14,32,38),(4,14,32,39),(4,14,32,40),(3,16,0,38),(5,16,1,6),(5,16,1,7),(11,16,1,21),(3,16,1,32),(3,16,1,35),(3,16,1,37),(3,16,1,38),(5,16,2,7),(5,16,2,8),(3,16,2,31),(3,16,2,32),(3,16,2,33),(3,16,2,34),(3,16,2,35),(3,16,2,36),(3,16,2,37),(3,16,2,38),(3,16,2,40),(5,16,3,7),(5,16,3,9),(0,16,3,14),(1,16,3,29),(3,16,3,34),(3,16,3,35),(3,16,3,36),(3,16,3,37),(3,16,3,38),(3,16,3,39),(3,16,3,40),(5,16,4,7),(5,16,4,8),(5,16,4,9),(5,16,4,11),(3,16,4,34),(3,16,4,35),(3,16,4,36),(3,16,4,37),(3,16,4,38),(5,16,5,5),(5,16,5,6),(5,16,5,7),(5,16,5,8),(5,16,5,9),(5,16,5,10),(5,16,5,11),(5,16,5,12),(5,16,5,13),(3,16,5,35),(5,16,5,36),(5,16,6,5),(5,16,6,6),(5,16,6,7),(5,16,6,8),(5,16,6,9),(5,16,6,10),(5,16,6,35),(5,16,6,36),(0,16,7,1),(5,16,7,5),(5,16,7,6),(5,16,7,9),(4,16,7,21),(5,16,7,34),(5,16,7,35),(5,16,7,36),(5,16,7,37),(0,16,7,38),(3,16,8,3),(5,16,8,5),(4,16,8,14),(4,16,8,20),(4,16,8,21),(11,16,8,22),(5,16,8,32),(5,16,8,33),(5,16,8,34),(5,16,8,35),(5,16,8,36),(5,16,8,37),(3,16,9,0),(3,16,9,2),(3,16,9,3),(3,16,9,4),(4,16,9,14),(4,16,9,20),(5,16,9,32),(5,16,9,33),(5,16,9,34),(5,16,9,35),(5,16,9,36),(4,16,9,38),(3,16,10,0),(3,16,10,1),(3,16,10,2),(3,16,10,3),(3,16,10,4),(3,16,10,5),(4,16,10,12),(4,16,10,13),(4,16,10,14),(4,16,10,15),(4,16,10,20),(9,16,10,28),(5,16,10,31),(5,16,10,32),(5,16,10,33),(5,16,10,34),(5,16,10,35),(5,16,10,36),(5,16,10,37),(4,16,10,38),(3,16,11,1),(3,16,11,2),(3,16,11,3),(3,16,11,4),(3,16,11,5),(4,16,11,8),(4,16,11,9),(4,16,11,10),(4,16,11,12),(4,16,11,13),(4,16,11,14),(4,16,11,15),(4,16,11,16),(4,16,11,19),(4,16,11,20),(4,16,11,21),(5,16,11,31),(5,16,11,32),(5,16,11,33),(4,16,11,34),(4,16,11,35),(4,16,11,36),(4,16,11,37),(4,16,11,38),(4,16,11,39),(3,16,12,1),(3,16,12,2),(3,16,12,3),(3,16,12,4),(3,16,12,5),(4,16,12,8),(4,16,12,9),(4,16,12,11),(4,16,12,12),(4,16,12,13),(4,16,12,14),(4,16,12,19),(4,16,12,20),(4,16,12,21),(4,16,12,22),(4,16,12,23),(4,16,12,24),(5,16,12,31),(4,16,12,34),(4,16,12,35),(4,16,12,37),(4,16,12,38),(3,16,13,0),(3,16,13,1),(3,16,13,2),(3,16,13,3),(3,16,13,4),(3,16,13,5),(4,16,13,6),(4,16,13,7),(4,16,13,8),(4,16,13,9),(4,16,13,10),(4,16,13,11),(4,16,13,12),(4,16,13,13),(4,16,13,14),(4,16,13,15),(4,16,13,16),(4,16,13,17),(4,16,13,18),(4,16,13,19),(4,16,13,20),(4,16,13,21),(4,16,13,22),(4,16,13,23),(4,16,13,24),(4,16,13,36),(4,16,13,37),(0,16,13,38),(3,16,14,0),(3,16,14,1),(3,16,14,2),(3,16,14,3),(4,16,14,4),(4,16,14,5),(4,16,14,6),(4,16,14,7),(4,16,14,8),(4,16,14,11),(4,16,14,12),(4,16,14,13),(4,16,14,14),(4,16,14,15),(4,16,14,16),(4,16,14,17),(5,16,14,19),(4,16,14,20),(4,16,14,21),(4,16,14,22),(4,16,14,23),(4,16,14,24),(4,16,14,25),(4,16,14,36),(4,16,14,37),(3,16,15,0),(3,16,15,1),(3,16,15,2),(3,16,15,3),(3,16,15,4),(4,16,15,5),(4,16,15,6),(4,16,15,7),(4,16,15,8),(4,16,15,11),(4,16,15,12),(4,16,15,13),(4,16,15,14),(4,16,15,15),(4,16,15,16),(4,16,15,17),(5,16,15,18),(5,16,15,19),(4,16,15,20),(4,16,15,22),(4,16,15,24),(4,16,15,32),(4,16,15,33),(4,16,15,35),(4,16,15,36),(4,16,15,37),(4,16,15,38),(4,16,15,39),(4,16,15,40),(3,16,16,0),(3,16,16,1),(3,16,16,2),(3,16,16,3),(3,16,16,4),(3,16,16,5),(12,16,16,6),(4,16,16,12),(4,16,16,13),(4,16,16,14),(4,16,16,16),(4,16,16,17),(4,16,16,18),(5,16,16,19),(4,16,16,20),(12,16,16,21),(4,16,16,33),(4,16,16,34),(4,16,16,35),(4,16,16,36),(4,16,16,37),(5,16,16,38),(5,16,16,39),(5,16,16,40),(3,16,17,0),(3,16,17,4),(3,16,17,5),(4,16,17,12),(4,16,17,13),(4,16,17,14),(5,16,17,17),(5,16,17,18),(5,16,17,19),(5,16,17,20),(4,16,17,35),(4,16,17,36),(4,16,17,37),(5,16,17,38),(5,16,17,39),(5,16,17,40),(3,16,18,1),(3,16,18,2),(3,16,18,3),(3,16,18,4),(3,16,18,5),(4,16,18,12),(5,16,18,14),(5,16,18,15),(5,16,18,16),(5,16,18,17),(5,16,18,18),(5,16,18,19),(5,16,18,20),(4,16,18,36),(5,16,18,37),(5,16,18,38),(5,16,18,39),(5,16,18,40),(3,16,19,3),(3,16,19,4),(4,16,19,12),(4,16,19,13),(5,16,19,15),(5,16,19,16),(5,16,19,17),(0,16,19,18),(5,16,19,20),(5,16,19,34),(5,16,19,35),(5,16,19,36),(5,16,19,37),(5,16,19,38),(5,16,19,39),(5,16,19,40),(3,16,20,4),(3,16,20,5),(4,16,20,13),(5,16,20,14),(5,16,20,15),(5,16,20,16),(5,16,20,17),(3,16,20,27),(3,16,20,28),(2,16,20,29),(5,16,20,34),(5,16,20,35),(5,16,20,36),(5,16,20,37),(5,16,20,38),(5,16,20,39),(5,16,20,40),(5,16,21,16),(5,16,21,17),(5,16,21,18),(3,16,21,27),(5,16,21,33),(5,16,21,34),(14,16,21,35),(5,16,21,40),(3,16,22,2),(3,16,22,3),(6,16,22,10),(6,16,22,11),(5,16,22,15),(5,16,22,16),(6,16,22,18),(6,16,22,19),(6,16,22,20),(6,16,22,21),(6,16,22,22),(3,16,22,23),(3,16,22,24),(3,16,22,25),(3,16,22,26),(3,16,22,27),(3,16,22,28),(5,16,22,34),(5,16,22,40),(3,16,23,1),(3,16,23,2),(6,16,23,10),(6,16,23,11),(6,16,23,12),(5,16,23,15),(6,16,23,17),(6,16,23,18),(6,16,23,19),(6,16,23,20),(6,16,23,21),(6,16,23,22),(6,16,23,23),(3,16,23,24),(3,16,23,25),(3,16,23,26),(3,16,23,27),(3,16,23,28),(5,16,23,39),(3,16,24,2),(3,16,24,4),(6,16,24,10),(6,16,24,11),(6,16,24,12),(6,16,24,13),(6,16,24,17),(6,16,24,18),(6,16,24,19),(6,16,24,20),(6,16,24,21),(6,16,24,22),(6,16,24,23),(3,16,24,25),(3,16,24,26),(3,16,24,27),(3,16,24,28),(5,16,24,34),(5,16,24,35),(5,16,24,36),(5,16,24,37),(5,16,24,38),(5,16,24,39),(5,16,24,40),(3,16,25,1),(3,16,25,2),(3,16,25,3),(3,16,25,4),(6,16,25,10),(6,16,25,11),(6,16,25,12),(6,16,25,13),(6,16,25,16),(6,16,25,17),(6,16,25,18),(6,16,25,19),(6,16,25,20),(6,16,25,21),(6,16,25,22),(6,16,25,23),(3,16,25,24),(3,16,25,25),(3,16,25,26),(3,16,25,27),(8,16,25,32),(5,16,25,35),(5,16,25,36),(5,16,25,37),(5,16,25,39),(3,16,26,0),(3,16,26,1),(3,16,26,2),(3,16,26,3),(6,16,26,11),(6,16,26,17),(3,16,26,24),(3,16,26,25),(3,16,26,27),(3,16,26,28),(5,16,26,35),(5,16,26,36),(5,16,26,37),(5,16,26,38),(5,16,26,39),(5,16,26,40),(3,16,27,0),(3,16,27,1),(3,16,27,2),(3,16,27,3),(3,16,27,4),(3,16,27,5),(3,16,27,28),(5,16,27,35),(5,16,27,36),(5,16,27,37),(5,16,27,38),(5,16,27,39),(5,16,27,40),(3,16,28,0),(3,16,28,1),(3,16,28,2),(3,16,28,3),(3,16,28,4),(3,16,28,5),(3,16,28,6),(5,16,28,36),(5,16,28,37),(5,16,28,38),(5,16,28,39),(5,16,28,40),(5,23,0,2),(3,23,0,3),(12,23,0,4),(5,23,0,10),(5,23,1,1),(5,23,1,2),(3,23,1,3),(5,23,1,10),(5,23,1,11),(5,23,2,1),(5,23,2,2),(5,23,2,3),(5,23,2,10),(5,23,2,11),(5,23,2,12),(5,23,2,13),(5,23,3,3),(5,23,3,10),(3,23,4,2),(5,23,4,3),(3,23,5,2),(3,23,6,2),(3,23,6,3),(13,23,6,6),(3,23,7,0),(3,23,7,1),(3,23,7,2),(3,23,7,3),(3,23,8,0),(3,23,8,1),(3,23,8,3),(13,23,8,4),(14,23,8,10),(3,23,9,0),(3,23,9,1),(3,23,9,3),(3,23,10,1),(3,23,10,3),(3,23,11,1),(3,23,11,11),(3,23,11,12),(3,23,11,13),(3,23,12,12),(3,23,12,13),(4,23,13,0),(4,23,13,3),(3,23,13,11),(3,23,13,12),(3,23,13,13),(4,23,14,0),(0,23,14,1),(4,23,14,3),(4,23,14,4),(3,23,14,11),(3,23,14,12),(4,23,15,0),(4,23,15,3),(4,23,15,4),(3,23,15,10),(3,23,15,11),(4,23,16,0),(4,23,16,1),(4,23,16,2),(4,23,16,3),(4,23,16,4),(3,23,16,10),(3,23,16,11),(4,23,17,0),(4,23,17,1),(4,23,17,2),(4,23,17,3),(4,23,17,4),(3,23,17,9),(3,23,17,10),(4,23,18,0),(4,23,18,1),(4,23,18,2),(4,23,18,3),(4,23,18,4),(4,23,18,5),(3,23,18,9),(4,23,19,0),(4,23,19,1),(4,23,19,2),(4,23,19,3),(4,23,19,4),(0,23,19,5),(4,23,19,10),(4,23,19,11),(4,23,20,1),(4,23,20,10),(4,23,20,11),(4,23,21,10),(4,23,21,11),(4,23,21,12),(14,23,22,1),(6,23,22,8),(6,23,22,9),(4,23,22,10),(4,23,22,11),(4,23,22,12),(6,23,23,6),(6,23,23,7),(6,23,23,8),(6,23,23,9),(4,23,23,10),(4,23,23,11),(4,23,23,12),(4,23,24,8),(1,23,24,9),(4,23,24,11),(3,23,25,2),(3,23,25,3),(3,23,25,4),(4,23,25,5),(4,23,25,7),(4,23,25,8),(4,23,25,11),(3,23,26,2),(3,23,26,3),(4,23,26,4),(4,23,26,5),(4,23,26,6),(4,23,26,7),(4,23,26,8),(4,23,26,9),(3,23,27,0),(3,23,27,1),(3,23,27,2),(3,23,27,3),(4,23,27,6),(4,23,27,7),(4,23,27,8),(3,23,28,0),(3,23,28,1),(3,23,28,2),(3,23,28,3),(4,23,28,7),(4,23,28,8),(0,23,28,10),(9,23,29,0),(3,23,29,3),(6,23,29,4),(6,23,30,3),(6,23,30,4),(6,23,30,5),(6,23,31,4),(2,23,31,6),(5,23,32,3),(6,23,32,4),(5,23,33,0),(5,23,33,1),(5,23,33,2),(5,23,33,3),(5,23,33,4),(5,23,34,0),(5,23,34,1),(0,23,35,3),(6,23,36,7),(6,23,37,3),(6,23,37,4),(6,23,37,5),(6,23,37,6),(6,23,37,7),(10,23,38,5),(0,23,39,1),(0,23,39,10),(6,23,42,5),(6,23,42,6),(6,23,42,7),(12,23,42,8),(6,23,43,5),(6,23,43,6),(6,23,43,7),(0,23,45,1),(5,23,47,0),(5,23,47,1),(3,23,47,7),(5,23,48,0),(5,23,48,1),(5,23,48,2),(5,23,48,3),(3,23,48,7),(3,23,48,8),(3,23,48,9),(3,23,48,10),(3,23,48,11),(3,23,48,12),(3,23,48,13),(5,23,49,0),(5,23,49,1),(3,23,49,7),(3,23,49,8),(3,23,49,9),(3,23,49,10),(3,23,49,11),(3,23,49,12),(3,23,49,13),(3,23,50,7),(3,23,50,8),(3,23,50,9),(3,23,50,10),(3,23,50,11),(3,23,50,12),(3,23,50,13),(8,31,0,11),(3,31,1,15),(6,31,2,5),(5,31,2,9),(5,31,2,10),(3,31,2,15),(3,31,3,0),(3,31,3,1),(6,31,3,4),(6,31,3,5),(6,31,3,6),(6,31,3,7),(5,31,3,9),(5,31,3,10),(3,31,3,14),(3,31,3,15),(0,31,3,18),(3,31,4,0),(3,31,4,1),(3,31,4,2),(3,31,4,3),(6,31,4,5),(6,31,4,6),(6,31,4,7),(5,31,4,8),(5,31,4,9),(6,31,4,12),(3,31,4,13),(3,31,4,14),(3,31,4,15),(3,31,5,0),(3,31,5,1),(3,31,5,3),(6,31,5,4),(6,31,5,5),(6,31,5,6),(5,31,5,7),(5,31,5,8),(5,31,5,9),(5,31,5,10),(6,31,5,11),(6,31,5,12),(6,31,5,13),(3,31,5,15),(3,31,5,16),(3,31,6,0),(3,31,6,1),(3,31,6,2),(5,31,6,5),(5,31,6,6),(5,31,6,7),(5,31,6,8),(5,31,6,9),(5,31,6,10),(6,31,6,11),(6,31,6,12),(6,31,6,13),(6,31,6,14),(3,31,6,15),(9,31,7,0),(5,31,7,5),(5,31,7,7),(5,31,7,8),(5,31,7,9),(6,31,7,10),(6,31,7,11),(6,31,7,14),(3,31,7,15),(0,31,7,20),(5,31,8,5),(5,31,8,7),(5,31,8,8),(5,31,8,9),(5,31,8,10),(5,31,8,11),(5,31,8,12),(3,31,8,15),(5,31,9,7),(5,31,9,9),(5,31,9,10),(5,31,9,11),(5,31,9,12),(5,31,9,13),(5,31,10,8),(5,31,10,9),(5,31,10,10),(0,31,11,15),(4,31,12,14),(0,31,13,5),(1,31,13,10),(4,31,13,14),(4,31,13,15),(13,31,14,0),(4,31,14,12),(4,31,14,13),(4,31,14,14),(3,31,15,2),(3,31,15,3),(3,31,15,4),(3,31,15,5),(3,31,15,6),(4,31,15,11),(4,31,15,12),(4,31,15,13),(3,31,16,2),(3,31,16,3),(3,31,16,4),(3,31,16,5),(3,31,16,6),(3,31,16,7),(4,31,16,12),(4,31,16,13),(4,31,16,14),(0,31,16,20),(3,31,17,2),(14,31,17,10),(4,31,17,14),(4,31,17,15),(4,31,18,14),(9,31,20,14),(4,31,20,17),(4,31,20,18),(2,31,20,20),(5,31,21,10),(5,31,21,11),(5,31,21,13),(4,31,21,17),(5,31,22,10),(5,31,22,12),(5,31,22,13),(4,31,22,17),(3,31,23,0),(3,31,23,1),(5,31,23,10),(5,31,23,12),(5,31,23,13),(4,31,23,17),(4,31,23,18),(4,31,23,19),(4,31,23,20),(4,31,23,21),(4,31,23,22),(3,31,24,0),(3,31,24,1),(13,31,24,2),(5,31,24,10),(5,31,24,11),(5,31,24,12),(5,31,24,13),(5,31,24,14),(4,31,24,15),(4,31,24,17),(4,31,24,18),(4,31,24,21),(3,31,25,0),(3,31,25,1),(6,31,25,6),(5,31,25,10),(4,31,25,11),(5,31,25,12),(5,31,25,13),(5,31,25,14),(4,31,25,15),(0,31,25,16),(4,31,25,18),(3,31,26,0),(3,31,26,1),(6,31,26,5),(6,31,26,6),(6,31,26,7),(4,31,26,10),(4,31,26,11),(4,31,26,12),(4,31,26,13),(4,31,26,14),(4,31,26,15),(4,31,26,18),(4,31,26,19),(3,31,27,0),(3,31,27,1),(6,31,27,5),(6,31,27,7),(6,31,27,8),(4,31,27,12),(4,31,27,13),(4,31,27,14),(4,31,27,15),(4,31,27,16),(4,31,27,18),(4,31,27,19),(3,31,28,0),(6,31,28,6),(6,31,28,7),(4,31,28,15),(4,31,28,17),(4,31,28,18),(4,31,28,19),(4,31,28,20),(3,31,29,0),(6,31,29,7),(6,31,29,8),(4,31,29,16),(4,31,29,17),(4,31,29,18),(4,31,29,19),(4,31,30,16),(4,31,30,17),(4,31,30,18),(4,31,30,19),(0,35,0,0),(5,35,0,3),(5,35,0,4),(5,35,0,5),(5,35,0,6),(5,35,0,7),(5,35,0,8),(5,35,0,9),(5,35,0,10),(5,35,0,11),(5,35,0,12),(5,35,0,13),(5,35,0,14),(5,35,0,26),(5,35,0,27),(5,35,0,28),(5,35,0,29),(5,35,1,3),(11,35,1,4),(5,35,1,11),(5,35,1,12),(5,35,1,13),(13,35,1,16),(4,35,1,19),(4,35,1,20),(4,35,1,21),(4,35,1,22),(5,35,1,26),(5,35,1,27),(5,35,1,28),(5,35,1,29),(5,35,2,2),(5,35,2,3),(5,35,2,10),(5,35,2,12),(5,35,2,13),(5,35,2,14),(5,35,2,15),(4,35,2,20),(4,35,2,21),(4,35,2,22),(4,35,2,23),(5,35,2,27),(5,35,2,28),(5,35,2,29),(0,35,3,1),(5,35,3,10),(5,35,3,11),(5,35,3,12),(5,35,3,13),(5,35,3,14),(4,35,3,20),(4,35,3,21),(4,35,3,22),(4,35,3,23),(4,35,3,24),(5,35,3,28),(5,35,3,29),(5,35,4,12),(5,35,4,13),(6,35,4,18),(4,35,4,21),(4,35,4,22),(4,35,4,23),(5,35,4,26),(5,35,4,27),(5,35,4,28),(6,35,5,8),(6,35,5,9),(6,35,5,18),(6,35,5,19),(4,35,5,22),(4,35,5,23),(4,35,5,24),(5,35,5,26),(5,35,5,27),(6,35,6,7),(6,35,6,8),(6,35,6,9),(6,35,6,11),(6,35,6,18),(6,35,6,19),(6,35,7,9),(6,35,7,10),(6,35,7,18),(12,35,7,23),(6,35,8,9),(6,35,8,10),(6,35,8,16),(6,35,8,17),(6,35,8,18),(3,35,9,3),(3,35,9,4),(6,35,9,9),(6,35,9,15),(6,35,9,16),(6,35,9,17),(3,35,10,0),(3,35,10,2),(3,35,10,3),(3,35,10,4),(8,35,10,5),(6,35,10,16),(6,35,10,17),(0,35,10,20),(3,35,11,0),(3,35,11,1),(3,35,11,2),(3,35,11,3),(3,35,12,0),(3,35,12,1),(3,35,12,2),(3,35,13,0),(3,35,13,1),(3,35,13,2),(3,35,13,4),(3,35,14,0),(3,35,14,1),(3,35,14,2),(3,35,14,3),(3,35,14,4),(3,35,15,0),(3,35,15,1),(3,35,15,2),(3,35,15,3),(3,35,15,4),(3,35,16,0),(3,35,16,1),(3,35,16,2),(3,35,16,3),(5,35,16,29),(3,35,17,0),(3,35,17,1),(3,35,17,2),(3,35,17,3),(3,35,17,4),(5,35,17,28),(5,35,17,29),(3,35,18,0),(3,35,18,1),(3,35,18,2),(3,35,18,3),(3,35,18,4),(3,35,18,5),(0,35,18,23),(5,35,18,28),(5,35,18,29),(3,35,19,0),(3,35,19,1),(3,35,19,2),(3,35,19,3),(3,35,19,4),(3,35,19,5),(5,35,19,29),(3,35,20,0),(3,35,20,1),(3,35,20,2),(3,35,20,3),(3,35,20,4),(3,35,20,5),(5,35,20,28),(5,35,20,29),(3,35,21,0),(3,35,21,1),(3,35,21,2),(3,35,21,3),(3,35,21,4),(5,35,21,29),(3,35,22,0),(3,35,22,1),(3,35,22,2),(14,35,22,25),(5,35,22,29),(3,35,23,0),(3,35,23,1),(3,35,23,2),(3,35,23,3),(4,35,23,9),(5,35,23,29),(3,35,24,1),(3,35,24,2),(0,35,24,4),(4,35,24,7),(4,35,24,8),(4,35,24,9),(4,35,24,10),(4,35,24,11),(5,35,24,29),(4,35,25,7),(4,35,25,8),(4,35,25,9),(4,35,25,10),(5,35,25,27),(5,35,25,29),(4,35,26,6),(4,35,26,7),(4,35,26,8),(4,35,26,9),(4,35,26,10),(2,35,26,12),(6,35,26,22),(6,35,26,23),(5,35,26,27),(5,35,26,28),(5,35,26,29),(4,35,27,5),(4,35,27,6),(4,35,27,7),(4,35,27,8),(4,35,27,9),(4,35,27,10),(5,35,27,17),(5,35,27,18),(5,35,27,21),(5,35,27,22),(6,35,27,23),(6,35,27,24),(0,35,28,4),(4,35,28,6),(4,35,28,7),(4,35,28,8),(4,35,28,9),(4,35,28,10),(5,35,28,15),(5,35,28,16),(5,35,28,17),(5,35,28,18),(5,35,28,19),(5,35,28,21),(5,35,28,22),(6,35,28,23),(6,35,28,24),(5,35,28,25),(5,35,28,26),(5,35,28,27),(5,35,28,28),(4,35,29,7),(4,35,29,8),(4,35,29,9),(4,35,29,10),(4,35,29,11),(5,35,29,16),(5,35,29,17),(5,35,29,18),(5,35,29,19),(5,35,29,20),(5,35,29,21),(5,35,29,22),(6,35,29,23),(6,35,29,24),(6,35,29,25),(6,35,29,26),(5,35,29,27);
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
) ENGINE=InnoDB AUTO_INCREMENT=336 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `units`
--

LOCK TABLES `units` WRITE;
/*!40000 ALTER TABLE `units` DISABLE KEYS */;
INSERT INTO `units` VALUES (1,140,1,1,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(2,120,1,1,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(3,140,1,2,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(4,120,1,2,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(5,120,1,2,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(6,140,1,3,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(7,120,1,3,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(8,120,1,3,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(9,120,1,4,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(10,120,1,4,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(11,140,1,5,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(12,120,1,5,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(13,140,1,5,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(14,120,1,5,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(15,120,1,5,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(16,140,1,6,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(17,120,1,6,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(18,140,1,6,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(19,120,1,6,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(20,120,1,6,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(21,120,1,7,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(22,140,1,7,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(23,120,1,7,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(24,120,1,7,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(25,120,1,7,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(26,120,1,7,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(27,140,1,8,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(28,120,1,8,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(29,120,1,8,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(30,140,1,9,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(31,120,1,9,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(32,120,1,9,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(33,120,1,10,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(34,120,1,10,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(35,120,1,11,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(36,120,1,11,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(37,120,1,12,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(38,120,1,12,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(39,120,1,13,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(40,2500,1,1,1,NULL,NULL,NULL,NULL,0,0,'Demosis',0,2,210,NULL,1,0,0,0),(41,1590,1,1,1,NULL,NULL,NULL,NULL,0,0,'Thor',0,2,210,NULL,1,0,0,0),(42,1200,1,1,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,2,210,NULL,1,0,0,0),(43,1200,1,1,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,2,210,NULL,1,0,0,0),(44,1200,1,1,1,NULL,NULL,NULL,NULL,0,0,'Dirac',0,2,210,NULL,1,0,0,0),(45,2500,1,1,1,NULL,NULL,NULL,NULL,0,0,'Demosis',0,2,150,NULL,1,0,0,0),(46,1590,1,1,1,NULL,NULL,NULL,NULL,0,0,'Thor',0,2,150,NULL,1,0,0,0),(47,1200,1,1,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,2,150,NULL,1,0,0,0),(48,1200,1,1,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,2,150,NULL,1,0,0,0),(49,1200,1,1,1,NULL,NULL,NULL,NULL,0,0,'Dirac',0,2,150,NULL,1,0,0,0),(50,140,1,14,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(51,120,1,14,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(52,120,1,14,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(53,140,1,15,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(54,120,1,15,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(55,120,1,15,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(56,140,1,16,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(57,120,1,16,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(58,120,1,16,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(59,120,1,17,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(60,120,1,17,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(61,120,1,17,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(62,120,1,18,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(63,120,1,18,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(64,120,1,18,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(65,120,1,19,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(66,120,1,19,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(67,140,1,19,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(68,120,1,19,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(69,140,1,19,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(70,120,1,19,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(71,140,1,20,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(72,120,1,20,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(73,120,1,20,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(74,120,1,21,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(75,140,1,21,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(76,140,1,21,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(77,120,1,21,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(78,120,1,21,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(79,120,1,22,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(80,120,1,22,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(81,120,1,22,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(82,140,1,23,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(83,120,1,23,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(84,120,1,23,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(85,120,1,24,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(86,120,1,25,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(87,1590,1,1,1,NULL,NULL,NULL,NULL,0,0,'Thor',0,1,135,NULL,1,0,0,0),(88,1590,1,1,1,NULL,NULL,NULL,NULL,0,0,'Thor',1,1,135,NULL,1,0,0,0),(89,1200,1,1,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,1,135,NULL,1,0,0,0),(90,1200,1,1,1,NULL,NULL,NULL,NULL,0,0,'Dirac',0,1,135,NULL,1,0,0,0),(91,1200,1,1,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,2,180,NULL,1,0,0,0),(92,1200,1,1,1,NULL,NULL,NULL,NULL,0,0,'Dirac',0,2,180,NULL,1,0,0,0),(93,2500,1,1,1,NULL,NULL,NULL,NULL,0,0,'Demosis',0,0,0,NULL,1,0,0,0),(94,1200,1,1,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,0,0,NULL,1,0,0,0),(95,1200,1,1,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,0,0,NULL,1,0,0,0),(96,1200,1,1,1,NULL,NULL,NULL,NULL,0,0,'Dirac',0,0,0,NULL,1,0,0,0),(97,140,1,26,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(98,120,1,26,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(99,120,1,26,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(100,120,1,27,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(101,140,1,27,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(102,120,1,27,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(103,120,1,27,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(104,140,1,28,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(105,120,1,28,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(106,140,1,28,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(107,120,1,28,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(108,140,1,28,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(109,120,1,28,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(110,120,1,28,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(111,120,1,29,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(112,140,1,29,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(113,120,1,29,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(114,140,1,29,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(115,120,1,29,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(116,120,1,29,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(117,120,1,29,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(118,140,1,30,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(119,120,1,30,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(120,120,1,30,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(121,120,1,31,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(122,120,1,31,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(123,120,1,32,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(124,120,1,32,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(125,120,1,33,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(126,140,1,34,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(127,120,1,34,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(128,120,1,34,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(129,140,1,35,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(130,120,1,35,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(131,120,1,35,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(132,140,1,36,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(133,120,1,36,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(134,140,1,36,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(135,120,1,36,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(136,120,1,36,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(137,120,1,37,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(138,140,1,37,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(139,140,1,37,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(140,120,1,37,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(141,120,1,37,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(142,140,1,38,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(143,120,1,38,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(144,120,1,38,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(145,120,1,39,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(146,120,1,39,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(147,120,1,40,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(148,120,1,40,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(149,120,1,41,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(150,120,1,41,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(151,2500,1,2,1,NULL,NULL,NULL,NULL,0,0,'Demosis',0,3,246,NULL,1,0,0,0),(152,1590,1,2,1,NULL,NULL,NULL,NULL,0,0,'Thor',0,3,246,NULL,1,0,0,0),(153,1200,1,2,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,3,246,NULL,1,0,0,0),(154,1200,1,2,1,NULL,NULL,NULL,NULL,0,0,'Dirac',0,3,246,NULL,1,0,0,0),(155,2500,1,2,1,NULL,NULL,NULL,NULL,0,0,'Demosis',0,1,0,NULL,1,0,0,0),(156,1590,1,2,1,NULL,NULL,NULL,NULL,0,0,'Thor',0,1,0,NULL,1,0,0,0),(157,1590,1,2,1,NULL,NULL,NULL,NULL,0,0,'Thor',1,1,0,NULL,1,0,0,0),(158,1200,1,2,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,1,0,NULL,1,0,0,0),(159,1200,1,2,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,1,0,NULL,1,0,0,0),(160,1200,1,2,1,NULL,NULL,NULL,NULL,0,0,'Dirac',0,1,0,NULL,1,0,0,0),(161,2500,1,2,1,NULL,NULL,NULL,NULL,0,0,'Demosis',0,2,30,NULL,1,0,0,0),(162,1590,1,2,1,NULL,NULL,NULL,NULL,0,0,'Thor',1,2,30,NULL,1,0,0,0),(163,1200,1,2,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,2,30,NULL,1,0,0,0),(164,1200,1,2,1,NULL,NULL,NULL,NULL,0,0,'Dirac',0,2,30,NULL,1,0,0,0),(165,140,1,42,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(166,120,1,42,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(167,120,1,42,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(168,140,1,43,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(169,120,1,43,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(170,140,1,43,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(171,120,1,43,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(172,140,1,44,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(173,120,1,44,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(174,120,1,44,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(175,120,1,44,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(176,120,1,45,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(177,120,1,46,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(178,1590,1,2,1,NULL,NULL,NULL,NULL,0,0,'Thor',1,0,270,NULL,1,0,0,0),(179,1200,1,2,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,0,270,NULL,1,0,0,0),(180,1200,1,2,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,0,270,NULL,1,0,0,0),(181,1200,1,2,1,NULL,NULL,NULL,NULL,0,0,'Dirac',0,0,270,NULL,1,0,0,0),(182,1590,1,3,1,NULL,NULL,NULL,NULL,0,0,'Thor',0,1,135,NULL,1,0,0,0),(183,1590,1,3,1,NULL,NULL,NULL,NULL,0,0,'Thor',1,1,135,NULL,1,0,0,0),(184,1200,1,3,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,1,135,NULL,1,0,0,0),(185,1200,1,3,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,1,135,NULL,1,0,0,0),(186,1200,1,3,1,NULL,NULL,NULL,NULL,0,0,'Dirac',0,1,135,NULL,1,0,0,0),(187,140,1,47,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(188,120,1,47,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(189,120,1,47,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(190,140,1,48,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(191,120,1,48,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(192,140,1,49,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(193,120,1,49,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(194,120,1,49,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(195,140,1,50,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(196,120,1,50,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(197,120,1,50,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(198,120,1,51,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(199,120,1,51,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(200,120,1,52,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(201,120,1,52,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(202,120,1,53,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(203,1590,1,3,1,NULL,NULL,NULL,NULL,0,0,'Thor',0,3,90,NULL,1,0,0,0),(204,1590,1,3,1,NULL,NULL,NULL,NULL,0,0,'Thor',1,3,90,NULL,1,0,0,0),(205,1200,1,3,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,3,90,NULL,1,0,0,0),(206,1200,1,3,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,3,90,NULL,1,0,0,0),(207,1200,1,3,1,NULL,NULL,NULL,NULL,0,0,'Dirac',0,3,90,NULL,1,0,0,0),(208,140,1,54,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(209,120,1,54,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(210,120,1,54,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(211,140,1,54,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(212,120,1,54,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(213,120,1,54,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(214,120,1,54,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(215,120,1,54,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(216,140,1,55,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(217,120,1,55,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(218,120,1,55,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(219,140,1,55,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(220,120,1,55,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(221,120,1,55,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(222,120,1,55,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(223,120,1,55,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(224,120,1,56,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(225,120,1,56,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(226,120,1,56,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(227,120,1,56,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(228,120,1,56,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(229,120,1,56,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(230,140,1,57,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(231,120,1,57,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(232,140,1,57,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(233,120,1,57,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(234,120,1,57,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(235,120,1,57,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(236,120,1,57,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(237,120,1,58,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(238,120,1,58,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(239,120,1,58,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(240,120,1,58,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(241,120,1,58,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(242,120,1,58,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(243,120,1,59,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(244,120,1,59,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(245,120,1,59,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(246,120,1,59,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(247,120,1,59,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(248,120,1,60,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(249,120,1,60,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(250,140,1,60,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(251,120,1,60,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(252,120,1,60,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(253,120,1,60,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(254,120,1,60,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(255,120,1,61,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(256,120,1,61,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(257,120,1,61,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(258,120,1,61,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(259,120,1,61,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(260,120,1,61,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(261,120,1,62,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(262,120,1,62,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(263,120,1,62,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(264,120,1,62,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(265,120,1,62,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(266,120,1,62,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(267,120,1,63,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(268,120,1,63,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(269,140,1,63,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(270,120,1,63,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(271,120,1,63,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(272,120,1,63,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(273,120,1,63,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(274,140,1,64,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(275,120,1,64,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(276,120,1,64,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(277,140,1,64,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(278,120,1,64,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(279,120,1,64,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(280,120,1,64,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(281,120,1,64,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(282,120,1,68,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(283,140,1,68,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(284,120,1,68,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(285,120,1,68,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(286,120,1,68,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(287,140,1,68,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(288,120,1,68,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(289,120,1,68,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(290,120,1,68,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(291,120,1,68,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(292,140,1,72,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(293,120,1,72,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(294,120,1,72,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(295,140,1,72,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(296,120,1,72,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(297,120,1,72,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(298,140,1,72,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(299,120,1,72,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(300,140,1,72,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(301,120,1,72,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(302,140,1,72,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(303,120,1,72,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(304,120,1,72,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(305,120,1,72,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(306,120,1,72,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(307,2500,1,4,1,NULL,NULL,NULL,NULL,0,0,'Demosis',0,2,30,NULL,1,0,0,0),(308,2500,1,4,1,NULL,NULL,NULL,NULL,0,0,'Demosis',0,2,30,NULL,1,0,0,0),(309,1200,1,4,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,2,30,NULL,1,0,0,0),(310,1200,1,4,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,2,30,NULL,1,0,0,0),(311,1200,1,4,1,NULL,NULL,NULL,NULL,0,0,'Dirac',0,2,30,NULL,1,0,0,0),(312,2500,1,4,1,NULL,NULL,NULL,NULL,0,0,'Demosis',0,3,202,NULL,1,0,0,0),(313,2500,1,4,1,NULL,NULL,NULL,NULL,0,0,'Demosis',0,3,202,NULL,1,0,0,0),(314,1590,1,4,1,NULL,NULL,NULL,NULL,0,0,'Thor',1,3,202,NULL,1,0,0,0),(315,1200,1,4,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,3,202,NULL,1,0,0,0),(316,1200,1,4,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,3,202,NULL,1,0,0,0),(317,1200,1,4,1,NULL,NULL,NULL,NULL,0,0,'Dirac',0,3,202,NULL,1,0,0,0),(318,2500,1,4,1,NULL,NULL,NULL,NULL,0,0,'Demosis',0,3,66,NULL,1,0,0,0),(319,2500,1,4,1,NULL,NULL,NULL,NULL,0,0,'Demosis',0,3,66,NULL,1,0,0,0),(320,2500,1,4,1,NULL,NULL,NULL,NULL,0,0,'Demosis',0,3,66,NULL,1,0,0,0),(321,1200,1,4,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,3,66,NULL,1,0,0,0),(322,1200,1,4,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,3,66,NULL,1,0,0,0),(323,1200,1,4,1,NULL,NULL,NULL,NULL,0,0,'Dirac',0,3,66,NULL,1,0,0,0),(324,2500,1,4,1,NULL,NULL,NULL,NULL,0,0,'Demosis',0,2,270,NULL,1,0,0,0),(325,1200,1,4,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,2,270,NULL,1,0,0,0),(326,1200,1,4,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,2,270,NULL,1,0,0,0),(327,1200,1,4,1,NULL,NULL,NULL,NULL,0,0,'Dirac',0,2,270,NULL,1,0,0,0),(328,2500,1,4,1,NULL,NULL,NULL,NULL,0,0,'Demosis',0,3,224,NULL,1,0,0,0),(329,2500,1,4,1,NULL,NULL,NULL,NULL,0,0,'Demosis',0,3,224,NULL,1,0,0,0),(330,1590,1,4,1,NULL,NULL,NULL,NULL,0,0,'Thor',1,3,224,NULL,1,0,0,0),(331,1200,1,4,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,3,224,NULL,1,0,0,0),(332,1200,1,4,1,NULL,NULL,NULL,NULL,0,0,'Dirac',0,3,224,NULL,1,0,0,0),(333,1590,1,4,1,NULL,NULL,NULL,NULL,0,0,'Thor',0,2,60,NULL,1,0,0,0),(334,1200,1,4,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,2,60,NULL,1,0,0,0),(335,1200,1,4,1,NULL,NULL,NULL,NULL,0,0,'Dirac',0,2,60,NULL,1,0,0,0);
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

-- Dump completed on 2010-12-01 20:40:13
