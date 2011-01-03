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
) ENGINE=InnoDB AUTO_INCREMENT=111 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `buildings`
--

LOCK TABLES `buildings` WRITE;
/*!40000 ALTER TABLE `buildings` DISABLE KEYS */;
INSERT INTO `buildings` VALUES (1,7,4,44,0,0,0,1,'NpcMetalExtractor',NULL,5,45,NULL,1,400,NULL,0,NULL,NULL,0),(2,7,5,33,0,0,0,1,'NpcMetalExtractor',NULL,6,34,NULL,1,400,NULL,0,NULL,NULL,0),(3,7,12,8,0,0,0,1,'NpcGeothermalPlant',NULL,13,9,NULL,1,600,NULL,0,NULL,NULL,0),(4,7,5,22,0,0,0,1,'NpcZetiumExtractor',NULL,6,23,NULL,1,800,NULL,0,NULL,NULL,0),(5,7,8,23,0,0,0,1,'NpcCommunicationsHub',NULL,10,24,NULL,1,1200,NULL,0,NULL,NULL,0),(6,7,10,38,0,0,0,1,'NpcSolarPlant',NULL,11,39,NULL,1,1000,NULL,0,NULL,NULL,0),(7,7,7,38,0,0,0,1,'NpcSolarPlant',NULL,8,39,NULL,1,1000,NULL,0,NULL,NULL,0),(8,7,6,19,0,0,0,1,'NpcSolarPlant',NULL,7,20,NULL,1,1000,NULL,0,NULL,NULL,0),(9,16,2,28,0,0,0,1,'NpcMetalExtractor',NULL,3,29,NULL,1,400,NULL,0,NULL,NULL,0),(10,16,17,28,0,0,0,1,'NpcMetalExtractor',NULL,18,29,NULL,1,400,NULL,0,NULL,NULL,0),(11,16,8,15,0,0,0,1,'NpcGeothermalPlant',NULL,9,16,NULL,1,600,NULL,0,NULL,NULL,0),(12,16,17,22,0,0,0,1,'NpcGeothermalPlant',NULL,18,23,NULL,1,600,NULL,0,NULL,NULL,0),(13,16,5,19,0,0,0,1,'NpcZetiumExtractor',NULL,6,20,NULL,1,800,NULL,0,NULL,NULL,0),(14,16,17,16,0,0,0,1,'NpcZetiumExtractor',NULL,18,17,NULL,1,800,NULL,0,NULL,NULL,0),(15,16,18,25,0,0,0,1,'NpcSolarPlant',NULL,19,26,NULL,1,1000,NULL,0,NULL,NULL,0),(16,16,10,23,0,0,0,1,'NpcSolarPlant',NULL,11,24,NULL,1,1000,NULL,0,NULL,NULL,0),(17,16,0,13,0,0,0,1,'NpcSolarPlant',NULL,1,14,NULL,1,1000,NULL,0,NULL,NULL,0),(18,16,8,27,0,0,0,1,'NpcSolarPlant',NULL,9,28,NULL,1,1000,NULL,0,NULL,NULL,0),(19,17,16,38,0,0,0,1,'NpcMetalExtractor',NULL,17,39,NULL,1,400,NULL,0,NULL,NULL,0),(20,17,8,14,0,0,0,1,'NpcMetalExtractor',NULL,9,15,NULL,1,400,NULL,0,NULL,NULL,0),(21,17,10,32,0,0,0,1,'NpcMetalExtractor',NULL,11,33,NULL,1,400,NULL,0,NULL,NULL,0),(22,17,12,41,0,0,0,1,'NpcMetalExtractor',NULL,13,42,NULL,1,400,NULL,0,NULL,NULL,0),(23,17,3,50,0,0,0,1,'NpcGeothermalPlant',NULL,4,51,NULL,1,600,NULL,0,NULL,NULL,0),(24,17,3,43,0,0,0,1,'NpcZetiumExtractor',NULL,4,44,NULL,1,800,NULL,0,NULL,NULL,0),(25,17,3,22,0,0,0,1,'NpcZetiumExtractor',NULL,4,23,NULL,1,800,NULL,0,NULL,NULL,0),(26,17,12,21,0,0,0,1,'NpcCommunicationsHub',NULL,14,22,NULL,1,1200,NULL,0,NULL,NULL,0),(27,17,5,17,0,0,0,1,'NpcTemple',NULL,7,19,NULL,1,1500,NULL,0,NULL,NULL,0),(28,17,6,47,0,0,0,1,'NpcCommunicationsHub',NULL,8,48,NULL,1,1200,NULL,0,NULL,NULL,0),(29,17,0,46,0,0,0,1,'NpcSolarPlant',NULL,1,47,NULL,1,1000,NULL,0,NULL,NULL,0),(30,17,4,36,0,0,0,1,'NpcSolarPlant',NULL,5,37,NULL,1,1000,NULL,0,NULL,NULL,0),(31,17,17,7,0,0,0,1,'NpcSolarPlant',NULL,18,8,NULL,1,1000,NULL,0,NULL,NULL,0),(32,23,1,12,0,0,0,1,'NpcMetalExtractor',NULL,2,13,NULL,1,400,NULL,0,NULL,NULL,0),(33,23,12,13,0,0,0,1,'NpcMetalExtractor',NULL,13,14,NULL,1,400,NULL,0,NULL,NULL,0),(34,23,48,19,0,0,0,1,'NpcZetiumExtractor',NULL,49,20,NULL,1,800,NULL,0,NULL,NULL,0),(35,23,21,14,0,0,0,1,'NpcResearchCenter',NULL,24,17,NULL,1,4000,NULL,0,NULL,NULL,0),(36,23,18,10,0,0,0,1,'NpcExcavationSite',NULL,21,13,NULL,1,2000,NULL,0,NULL,NULL,0),(37,23,13,17,0,0,0,1,'NpcTemple',NULL,15,19,NULL,1,1500,NULL,0,NULL,NULL,0),(38,23,1,16,0,0,0,1,'NpcCommunicationsHub',NULL,3,17,NULL,1,1200,NULL,0,NULL,NULL,0),(39,23,15,11,0,0,0,1,'NpcSolarPlant',NULL,16,12,NULL,1,1000,NULL,0,NULL,NULL,0),(40,23,3,2,0,0,0,1,'NpcSolarPlant',NULL,4,3,NULL,1,1000,NULL,0,NULL,NULL,0),(41,23,15,9,0,0,0,1,'NpcSolarPlant',NULL,16,10,NULL,1,1000,NULL,0,NULL,NULL,0),(42,23,42,16,0,0,0,1,'NpcSolarPlant',NULL,43,17,NULL,1,1000,NULL,0,NULL,NULL,0),(43,30,24,1,0,0,0,1,'NpcMetalExtractor',NULL,25,2,NULL,1,400,NULL,0,NULL,NULL,0),(44,30,38,12,0,0,0,1,'NpcMetalExtractor',NULL,39,13,NULL,1,400,NULL,0,NULL,NULL,0),(45,30,47,9,0,0,0,1,'NpcMetalExtractor',NULL,48,10,NULL,1,400,NULL,0,NULL,NULL,0),(46,30,30,10,0,0,0,1,'NpcGeothermalPlant',NULL,31,11,NULL,1,600,NULL,0,NULL,NULL,0),(47,30,12,7,0,0,0,1,'NpcGeothermalPlant',NULL,13,8,NULL,1,600,NULL,0,NULL,NULL,0),(48,30,47,5,0,0,0,1,'NpcZetiumExtractor',NULL,48,6,NULL,1,800,NULL,0,NULL,NULL,0),(49,30,56,12,0,0,0,1,'NpcZetiumExtractor',NULL,57,13,NULL,1,800,NULL,0,NULL,NULL,0),(50,30,42,8,0,0,0,1,'NpcResearchCenter',NULL,45,11,NULL,1,4000,NULL,0,NULL,NULL,0),(51,30,20,9,0,0,0,1,'NpcCommunicationsHub',NULL,22,10,NULL,1,1200,NULL,0,NULL,NULL,0),(52,30,15,8,0,0,0,1,'NpcResearchCenter',NULL,18,11,NULL,1,4000,NULL,0,NULL,NULL,0),(53,30,16,12,0,0,0,1,'NpcExcavationSite',NULL,19,15,NULL,1,2000,NULL,0,NULL,NULL,0),(54,30,34,11,0,0,0,1,'NpcTemple',NULL,36,13,NULL,1,1500,NULL,0,NULL,NULL,0),(55,30,51,15,0,0,0,1,'NpcCommunicationsHub',NULL,53,16,NULL,1,1200,NULL,0,NULL,NULL,0),(56,30,28,6,0,0,0,1,'NpcSolarPlant',NULL,29,7,NULL,1,1000,NULL,0,NULL,NULL,0),(57,30,35,15,0,0,0,1,'NpcSolarPlant',NULL,36,16,NULL,1,1000,NULL,0,NULL,NULL,0),(58,30,25,10,0,0,0,1,'NpcSolarPlant',NULL,26,11,NULL,1,1000,NULL,0,NULL,NULL,0),(59,33,31,16,0,0,0,1,'NpcMetalExtractor',NULL,32,17,NULL,1,400,NULL,0,NULL,NULL,0),(60,33,3,11,0,0,0,1,'NpcMetalExtractor',NULL,4,12,NULL,1,400,NULL,0,NULL,NULL,0),(61,33,11,16,0,0,0,1,'NpcGeothermalPlant',NULL,12,17,NULL,1,600,NULL,0,NULL,NULL,0),(62,33,7,8,0,0,0,1,'NpcGeothermalPlant',NULL,8,9,NULL,1,600,NULL,0,NULL,NULL,0),(63,33,27,6,0,0,0,1,'NpcZetiumExtractor',NULL,28,7,NULL,1,800,NULL,0,NULL,NULL,0),(64,33,18,10,0,0,0,1,'NpcZetiumExtractor',NULL,19,11,NULL,1,800,NULL,0,NULL,NULL,0),(65,33,36,15,0,0,0,1,'NpcResearchCenter',NULL,39,18,NULL,1,4000,NULL,0,NULL,NULL,0),(66,33,31,1,0,0,0,1,'NpcExcavationSite',NULL,34,4,NULL,1,2000,NULL,0,NULL,NULL,0),(67,33,0,20,0,0,0,1,'NpcCommunicationsHub',NULL,2,21,NULL,1,1200,NULL,0,NULL,NULL,0),(68,33,15,17,0,0,0,1,'NpcSolarPlant',NULL,16,18,NULL,1,1000,NULL,0,NULL,NULL,0),(69,33,22,19,0,0,0,1,'NpcSolarPlant',NULL,23,20,NULL,1,1000,NULL,0,NULL,NULL,0),(70,33,15,22,0,0,0,1,'NpcSolarPlant',NULL,16,23,NULL,1,1000,NULL,0,NULL,NULL,0),(71,33,30,21,0,0,0,1,'NpcSolarPlant',NULL,31,22,NULL,1,1000,NULL,0,NULL,NULL,0),(72,44,14,12,0,0,0,1,'NpcMetalExtractor',NULL,15,13,NULL,1,400,NULL,0,NULL,NULL,0),(73,44,11,2,0,0,0,1,'NpcMetalExtractor',NULL,12,3,NULL,1,400,NULL,0,NULL,NULL,0),(74,44,18,12,0,0,0,1,'NpcMetalExtractor',NULL,19,13,NULL,1,400,NULL,0,NULL,NULL,0),(75,44,17,6,0,0,0,1,'NpcGeothermalPlant',NULL,18,7,NULL,1,600,NULL,0,NULL,NULL,0),(76,44,22,8,0,0,0,1,'NpcZetiumExtractor',NULL,23,9,NULL,1,800,NULL,0,NULL,NULL,0),(77,44,24,2,0,0,0,1,'NpcSolarPlant',NULL,25,3,NULL,1,1000,NULL,0,NULL,NULL,0),(78,44,21,0,0,0,0,1,'NpcSolarPlant',NULL,22,1,NULL,1,1000,NULL,0,NULL,NULL,0),(79,47,0,0,0,0,0,1,'NpcMetalExtractor',NULL,1,1,NULL,1,400,NULL,0,NULL,NULL,0),(80,47,7,0,0,0,0,1,'NpcCommunicationsHub',NULL,9,1,NULL,1,1200,NULL,0,NULL,NULL,0),(81,47,18,0,0,0,0,1,'NpcSolarPlant',NULL,19,1,NULL,1,1000,NULL,0,NULL,NULL,0),(82,47,3,1,0,0,0,1,'NpcMetalExtractor',NULL,4,2,NULL,1,400,NULL,0,NULL,NULL,0),(83,47,12,1,0,0,0,1,'NpcSolarPlant',NULL,13,2,NULL,1,1000,NULL,0,NULL,NULL,0),(84,47,22,1,0,0,0,1,'NpcSolarPlant',NULL,23,2,NULL,1,1000,NULL,0,NULL,NULL,0),(85,47,26,1,0,0,0,1,'NpcCommunicationsHub',NULL,28,2,NULL,1,1200,NULL,0,NULL,NULL,0),(86,47,15,3,0,0,0,1,'NpcSolarPlant',NULL,16,4,NULL,1,1000,NULL,0,NULL,NULL,0),(87,47,18,3,0,0,0,1,'NpcSolarPlant',NULL,19,4,NULL,1,1000,NULL,0,NULL,NULL,0),(88,47,24,4,0,0,0,1,'NpcMetalExtractor',NULL,25,5,NULL,1,400,NULL,0,NULL,NULL,0),(89,47,28,4,0,0,0,1,'NpcMetalExtractor',NULL,29,5,NULL,1,400,NULL,0,NULL,NULL,0),(90,47,7,6,0,0,0,1,'Screamer',NULL,8,7,NULL,1,1300,NULL,0,NULL,NULL,0),(91,47,21,6,0,0,0,1,'Vulcan',NULL,22,7,NULL,1,1000,NULL,0,NULL,NULL,0),(92,47,14,7,0,0,0,1,'Thunder',NULL,15,8,NULL,1,2000,NULL,0,NULL,NULL,0),(93,47,25,7,0,0,0,1,'NpcTemple',NULL,27,9,NULL,1,1500,NULL,0,NULL,NULL,0),(94,47,11,10,0,0,0,1,'Mothership',NULL,18,15,NULL,1,10500,NULL,0,NULL,NULL,0),(95,47,7,12,0,0,0,1,'Thunder',NULL,8,13,NULL,1,2000,NULL,0,NULL,NULL,0),(96,47,21,12,0,0,0,1,'Thunder',NULL,22,13,NULL,1,2000,NULL,0,NULL,NULL,0),(97,47,26,12,0,0,0,1,'NpcZetiumExtractor',NULL,27,13,NULL,1,800,NULL,0,NULL,NULL,0),(98,47,7,19,0,0,0,1,'Vulcan',NULL,8,20,NULL,1,1000,NULL,0,NULL,NULL,0),(99,47,14,19,0,0,0,1,'Thunder',NULL,15,20,NULL,1,2000,NULL,0,NULL,NULL,0),(100,47,21,19,0,0,0,1,'Screamer',NULL,22,20,NULL,1,1300,NULL,0,NULL,NULL,0),(101,52,9,32,0,0,0,1,'NpcMetalExtractor',NULL,10,33,NULL,1,400,NULL,0,NULL,NULL,0),(102,52,1,50,0,0,0,1,'NpcMetalExtractor',NULL,2,51,NULL,1,400,NULL,0,NULL,NULL,0),(103,52,11,1,0,0,0,1,'NpcMetalExtractor',NULL,12,2,NULL,1,400,NULL,0,NULL,NULL,0),(104,52,11,50,0,0,0,1,'NpcGeothermalPlant',NULL,12,51,NULL,1,600,NULL,0,NULL,NULL,0),(105,52,11,46,0,0,0,1,'NpcZetiumExtractor',NULL,12,47,NULL,1,800,NULL,0,NULL,NULL,0),(106,52,9,26,0,0,0,1,'NpcZetiumExtractor',NULL,10,27,NULL,1,800,NULL,0,NULL,NULL,0),(107,52,4,35,0,0,0,1,'NpcCommunicationsHub',NULL,6,36,NULL,1,1200,NULL,0,NULL,NULL,0),(108,52,7,41,0,0,0,1,'NpcSolarPlant',NULL,8,42,NULL,1,1000,NULL,0,NULL,NULL,0),(109,52,3,38,0,0,0,1,'NpcSolarPlant',NULL,4,39,NULL,1,1000,NULL,0,NULL,NULL,0),(110,52,12,19,0,0,0,1,'NpcSolarPlant',NULL,13,20,NULL,1,1000,NULL,0,NULL,NULL,0);
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
INSERT INTO `folliages` VALUES (7,0,0,9),(7,0,2,2),(7,0,20,9),(7,0,21,12),(7,0,49,11),(7,0,51,11),(7,1,4,5),(7,1,7,4),(7,1,22,7),(7,2,2,5),(7,2,3,1),(7,2,6,4),(7,2,13,11),(7,2,21,9),(7,2,22,3),(7,2,25,1),(7,2,49,4),(7,2,51,11),(7,3,1,4),(7,3,7,0),(7,3,20,3),(7,3,23,8),(7,3,25,4),(7,3,50,3),(7,4,0,11),(7,4,1,5),(7,4,4,4),(7,4,8,7),(7,4,19,8),(7,4,20,10),(7,4,21,0),(7,4,23,4),(7,4,33,2),(7,4,43,3),(7,4,47,3),(7,4,50,5),(7,5,0,11),(7,5,1,4),(7,5,4,7),(7,5,19,5),(7,5,51,4),(7,5,52,11),(7,6,39,1),(7,6,47,13),(7,6,50,3),(7,7,34,7),(7,7,37,11),(7,7,47,3),(7,8,0,7),(7,8,32,4),(7,8,33,8),(7,8,35,2),(7,8,36,0),(7,8,47,10),(7,9,1,11),(7,9,5,3),(7,9,22,4),(7,9,32,7),(7,9,33,9),(7,9,51,7),(7,10,1,10),(7,10,2,6),(7,10,33,8),(7,10,37,1),(7,11,3,12),(7,11,4,1),(7,11,27,2),(7,11,36,5),(7,12,5,9),(7,12,25,10),(7,12,29,3),(7,12,40,1),(7,12,43,10),(7,12,50,9),(7,12,52,0),(7,13,4,3),(7,13,10,8),(7,13,12,2),(7,13,20,11),(7,13,22,7),(7,13,23,10),(7,13,32,2),(7,13,51,7),(7,14,4,11),(7,14,9,6),(7,14,22,4),(7,14,24,3),(7,14,26,9),(7,14,28,2),(7,14,51,4),(7,15,7,11),(7,15,21,5),(7,15,26,11),(7,15,37,1),(7,15,42,10),(7,15,43,0),(7,15,47,6),(7,15,48,13),(7,16,4,8),(7,16,6,7),(7,16,7,5),(7,16,13,12),(7,16,14,9),(7,16,17,9),(7,16,19,10),(7,16,20,0),(7,16,23,0),(7,16,26,12),(7,16,43,10),(7,16,50,2),(7,17,1,7),(7,17,11,8),(7,17,26,0),(7,17,34,7),(7,17,41,10),(7,17,43,11),(7,17,46,4),(7,17,52,10),(16,0,0,0),(16,0,10,9),(16,1,6,2),(16,1,21,13),(16,2,14,5),(16,3,27,11),(16,4,13,4),(16,4,15,7),(16,4,16,10),(16,4,23,12),(16,4,27,10),(16,4,28,13),(16,5,18,5),(16,5,27,4),(16,6,3,11),(16,6,4,10),(16,6,7,3),(16,6,10,6),(16,6,24,1),(16,7,4,7),(16,7,9,3),(16,7,10,5),(16,7,13,11),(16,7,15,2),(16,7,18,7),(16,7,19,5),(16,7,21,5),(16,7,30,5),(16,8,19,3),(16,8,23,1),(16,8,24,11),(16,8,25,10),(16,9,1,4),(16,9,7,0),(16,9,13,4),(16,9,21,9),(16,9,30,11),(16,10,13,13),(16,10,21,13),(16,10,26,3),(16,11,2,11),(16,11,13,3),(16,11,18,7),(16,11,21,6),(16,11,27,10),(16,11,28,3),(16,12,7,0),(16,12,15,6),(16,12,21,12),(16,12,22,12),(16,12,29,4),(16,13,15,3),(16,13,16,5),(16,13,19,11),(16,14,10,2),(16,14,16,8),(16,14,17,4),(16,14,21,1),(16,14,22,13),(16,14,29,3),(16,15,11,4),(16,15,14,1),(16,15,16,5),(16,15,17,2),(16,15,27,5),(16,16,14,7),(16,16,24,10),(16,16,28,2),(16,17,12,11),(16,17,24,3),(16,17,27,10),(16,18,9,3),(16,18,24,2),(16,18,27,3),(16,19,8,0),(16,19,16,3),(17,0,1,10),(17,0,4,2),(17,0,5,13),(17,0,12,13),(17,0,14,0),(17,0,16,9),(17,0,18,11),(17,0,19,4),(17,0,21,6),(17,0,24,12),(17,0,26,6),(17,0,28,10),(17,0,30,4),(17,0,37,1),(17,0,38,4),(17,0,43,11),(17,1,2,5),(17,1,12,4),(17,1,14,12),(17,1,16,2),(17,1,30,6),(17,1,36,2),(17,1,50,7),(17,1,51,1),(17,2,12,10),(17,2,21,1),(17,2,22,3),(17,2,33,13),(17,2,34,6),(17,2,38,4),(17,2,40,3),(17,2,41,6),(17,2,43,11),(17,2,44,8),(17,2,47,3),(17,3,38,6),(17,3,53,7),(17,4,0,10),(17,4,2,11),(17,4,12,6),(17,4,19,7),(17,4,29,11),(17,4,32,1),(17,4,33,2),(17,4,42,0),(17,5,4,4),(17,5,11,11),(17,5,21,10),(17,5,29,10),(17,5,45,7),(17,5,46,1),(17,5,52,13),(17,5,53,0),(17,6,0,11),(17,6,1,12),(17,6,4,3),(17,6,13,6),(17,6,15,3),(17,6,34,1),(17,6,42,7),(17,6,49,6),(17,6,51,8),(17,7,1,10),(17,7,13,3),(17,7,34,3),(17,7,42,4),(17,7,44,13),(17,7,52,2),(17,7,53,6),(17,8,3,3),(17,8,5,4),(17,8,6,8),(17,8,38,4),(17,8,39,12),(17,8,52,11),(17,9,3,3),(17,9,4,6),(17,9,6,11),(17,9,13,10),(17,10,5,4),(17,10,15,2),(17,10,42,0),(17,11,10,4),(17,12,3,13),(17,12,30,2),(17,12,50,10),(17,13,8,13),(17,13,10,2),(17,13,12,2),(17,13,23,12),(17,13,24,7),(17,13,50,2),(17,13,52,12),(17,14,7,3),(17,14,10,6),(17,14,11,6),(17,14,13,0),(17,14,28,5),(17,14,29,5),(17,15,7,10),(17,15,11,4),(17,15,18,12),(17,15,51,12),(17,16,10,12),(17,16,49,0),(17,17,11,2),(17,17,53,2),(17,18,17,11),(17,18,26,9),(17,19,15,1),(17,19,18,4),(17,19,19,11),(17,19,23,2),(17,19,53,4),(23,0,2,5),(23,0,3,12),(23,0,4,8),(23,0,6,7),(23,0,9,4),(23,0,11,3),(23,0,14,3),(23,1,3,11),(23,1,5,8),(23,1,11,11),(23,2,3,5),(23,2,5,3),(23,2,7,2),(23,3,0,6),(23,3,1,9),(23,3,7,7),(23,4,4,1),(23,4,5,1),(23,4,6,0),(23,4,7,4),(23,5,0,11),(23,5,5,3),(23,5,18,8),(23,6,1,8),(23,6,7,9),(23,6,15,0),(23,7,0,11),(23,7,6,8),(23,7,13,3),(23,7,16,3),(23,7,18,8),(23,8,0,4),(23,8,9,0),(23,8,14,7),(23,8,15,9),(23,8,20,0),(23,9,15,0),(23,10,2,0),(23,10,3,11),(23,10,13,11),(23,10,21,1),(23,11,0,8),(23,11,1,4),(23,11,5,2),(23,11,11,11),(23,11,15,4),(23,11,16,10),(23,11,19,6),(23,11,20,7),(23,13,3,3),(23,13,7,5),(23,13,15,10),(23,13,21,1),(23,14,1,7),(23,14,11,13),(23,14,15,7),(23,14,20,9),(23,15,0,3),(23,15,2,1),(23,15,15,1),(23,15,21,1),(23,16,0,6),(23,16,2,4),(23,16,13,8),(23,16,14,8),(23,16,16,11),(23,17,1,5),(23,17,4,4),(23,17,5,4),(23,17,6,8),(23,17,8,0),(23,17,9,10),(23,17,11,4),(23,17,12,9),(23,17,13,3),(23,18,2,9),(23,18,7,3),(23,18,8,4),(23,18,16,5),(23,19,2,9),(23,19,4,7),(23,19,6,10),(23,19,8,5),(23,19,16,5),(23,19,17,3),(23,20,1,10),(23,20,2,1),(23,20,9,7),(23,20,14,1),(23,20,17,3),(23,20,18,1),(23,21,8,7),(23,22,0,5),(23,22,7,9),(23,22,10,10),(23,22,11,9),(23,22,12,8),(23,22,18,8),(23,23,18,9),(23,24,4,8),(23,25,2,2),(23,26,0,4),(23,26,1,10),(23,26,3,7),(23,26,4,11),(23,26,17,5),(23,26,20,3),(23,27,2,4),(23,27,8,9),(23,28,1,1),(23,28,6,5),(23,28,8,8),(23,28,12,7),(23,28,14,7),(23,29,0,6),(23,29,5,3),(23,29,7,1),(23,30,2,2),(23,30,6,10),(23,30,7,9),(23,31,0,8),(23,31,3,0),(23,32,4,4),(23,34,1,7),(23,34,2,2),(23,35,0,9),(23,36,1,6),(23,36,4,10),(23,36,5,11),(23,37,5,7),(23,37,8,6),(23,37,14,12),(23,38,7,6),(23,38,15,4),(23,39,14,9),(23,40,3,10),(23,41,6,11),(23,41,19,10),(23,42,1,3),(23,42,19,2),(23,42,21,11),(23,43,0,11),(23,43,11,3),(23,43,19,3),(23,45,15,7),(23,46,0,5),(23,46,13,9),(23,46,15,12),(23,46,19,2),(23,47,0,4),(23,47,12,7),(23,47,18,6),(23,48,0,8),(23,48,1,11),(23,48,2,0),(23,48,4,10),(23,48,10,3),(23,48,13,6),(23,49,2,2),(23,49,13,6),(23,49,14,2),(23,49,18,10),(23,50,0,8),(23,50,3,8),(23,50,9,11),(23,50,15,7),(23,50,18,7),(23,51,0,7),(23,51,2,3),(23,51,5,0),(23,51,17,2),(23,51,20,13),(23,52,5,1),(23,52,7,2),(23,52,11,11),(23,52,12,1),(23,52,15,0),(23,52,20,4),(30,0,0,4),(30,0,3,6),(30,0,5,1),(30,0,8,8),(30,0,15,7),(30,1,6,7),(30,1,7,12),(30,1,16,12),(30,10,0,3),(30,10,7,0),(30,10,12,11),(30,11,2,2),(30,11,10,0),(30,11,11,5),(30,11,15,3),(30,12,2,11),(30,13,1,6),(30,14,0,3),(30,14,13,11),(30,14,14,0),(30,14,16,7),(30,15,4,4),(30,15,12,13),(30,15,13,11),(30,17,0,0),(30,18,5,12),(30,18,16,3),(30,19,11,1),(30,19,16,7),(30,20,7,0),(30,20,14,3),(30,21,0,2),(30,21,7,3),(30,21,13,6),(30,21,16,2),(30,22,7,0),(30,22,8,4),(30,22,13,1),(30,23,2,8),(30,23,16,2),(30,24,4,2),(30,24,10,4),(30,24,14,12),(30,24,16,9),(30,25,0,6),(30,25,16,0),(30,26,7,4),(30,26,8,10),(30,26,9,7),(30,27,1,1),(30,27,4,3),(30,28,16,1),(30,29,16,5),(30,30,6,4),(30,30,7,4),(30,30,8,10),(30,31,15,7),(30,31,16,3),(30,33,5,7),(30,33,9,6),(30,33,16,10),(30,34,5,0),(30,35,3,0),(30,35,14,7),(30,36,8,6),(30,36,14,4),(30,37,5,2),(30,37,9,6),(30,37,13,11),(30,37,16,0),(30,38,5,12),(30,38,7,11),(30,38,15,7),(30,39,9,7),(30,39,10,0),(30,39,14,11),(30,40,9,4),(30,41,10,2),(30,41,12,12),(30,41,13,2),(30,41,14,3),(30,42,0,10),(30,42,2,1),(30,42,12,1),(30,43,12,2),(30,44,12,3),(30,45,7,0),(30,45,13,4),(30,45,16,7),(30,46,4,5),(30,46,9,2),(30,46,12,3),(30,46,14,10),(30,47,4,13),(30,47,12,6),(30,48,1,3),(30,49,0,10),(30,49,3,6),(30,49,5,4),(30,49,8,10),(30,49,9,4),(30,49,11,11),(30,49,14,3),(30,49,15,10),(30,50,0,4),(30,50,1,0),(30,50,2,5),(30,50,12,0),(30,50,13,9),(30,51,1,3),(30,51,2,12),(30,51,5,11),(30,52,4,11),(30,52,5,8),(30,52,6,8),(30,52,9,2),(30,52,10,4),(30,53,1,8),(30,53,7,10),(30,53,11,4),(30,54,1,10),(30,54,9,3),(30,54,10,1),(30,55,0,9),(30,55,1,0),(30,55,5,2),(30,55,14,10),(30,55,15,0),(30,56,0,10),(30,56,14,12),(30,56,16,3),(30,57,3,7),(30,58,15,4),(30,58,16,12),(30,59,0,3),(30,59,4,1),(30,59,5,7),(30,59,11,13),(30,59,14,1),(33,0,6,9),(33,0,7,6),(33,0,11,10),(33,0,14,8),(33,0,18,13),(33,0,24,5),(33,1,13,3),(33,1,17,2),(33,1,18,5),(33,2,24,0),(33,3,13,6),(33,3,24,3),(33,4,13,7),(33,5,3,7),(33,5,15,4),(33,6,3,5),(33,6,4,3),(33,6,11,3),(33,7,14,6),(33,7,23,6),(33,7,24,5),(33,8,6,1),(33,8,11,7),(33,8,17,12),(33,9,6,12),(33,9,9,4),(33,9,15,12),(33,9,16,2),(33,9,17,12),(33,9,20,0),(33,9,21,6),(33,11,15,7),(33,11,18,11),(33,12,19,6),(33,13,12,1),(33,14,12,13),(33,14,17,7),(33,14,23,5),(33,15,11,3),(33,16,12,3),(33,16,21,0),(33,17,6,10),(33,17,20,2),(33,17,22,9),(33,18,21,10),(33,19,8,0),(33,19,12,1),(33,19,22,13),(33,20,3,3),(33,20,7,0),(33,20,8,12),(33,20,9,10),(33,20,10,5),(33,20,14,13),(33,20,22,5),(33,21,4,2),(33,21,9,10),(33,21,15,13),(33,21,23,4),(33,22,5,12),(33,22,6,3),(33,22,18,12),(33,22,24,12),(33,23,1,2),(33,23,5,0),(33,23,9,7),(33,23,22,6),(33,24,2,1),(33,24,19,3),(33,24,21,3),(33,24,22,3),(33,25,2,4),(33,25,15,5),(33,26,5,2),(33,26,7,5),(33,26,8,11),(33,26,14,12),(33,26,21,5),(33,27,23,12),(33,28,5,0),(33,28,21,4),(33,29,6,5),(33,29,21,13),(33,29,24,4),(33,30,0,13),(33,30,4,7),(33,30,5,7),(33,30,9,7),(33,30,19,5),(33,31,24,5),(33,32,9,3),(33,32,24,13),(33,33,0,1),(33,33,5,11),(33,33,8,12),(33,33,9,10),(33,33,10,9),(33,33,24,1),(33,34,11,0),(33,35,1,6),(33,35,11,2),(33,35,12,2),(33,35,24,2),(33,36,0,11),(33,36,14,2),(33,36,21,6),(33,38,14,2),(33,38,24,0),(33,40,0,11),(33,40,6,2),(33,40,7,11),(33,40,9,2),(33,40,13,12),(33,41,4,11),(33,41,9,11),(33,41,13,0),(33,41,14,12),(44,2,0,11),(44,2,9,7),(44,2,14,4),(44,4,1,13),(44,4,2,0),(44,4,4,0),(44,4,8,10),(44,5,0,5),(44,7,6,8),(44,7,7,13),(44,8,8,11),(44,9,7,10),(44,9,8,11),(44,9,12,11),(44,9,13,13),(44,9,14,5),(44,10,13,3),(44,11,6,9),(44,11,11,10),(44,11,14,6),(44,12,13,4),(44,13,0,6),(44,13,4,13),(44,13,12,10),(44,14,14,6),(44,15,1,8),(44,15,3,2),(44,18,2,1),(44,18,11,12),(44,19,10,7),(44,19,14,7),(44,22,10,9),(44,22,11,6),(44,22,14,8),(44,23,12,13),(44,23,14,8),(44,25,12,10),(44,25,14,4),(44,26,0,2),(44,26,4,9),(44,26,8,3),(44,27,7,7),(44,27,8,10),(44,27,9,13),(44,28,0,1),(44,28,4,9),(44,28,11,6),(44,29,3,3),(44,29,12,2),(44,29,13,2),(44,30,11,4),(44,32,11,8),(44,32,13,7),(44,33,12,12),(44,34,8,6),(44,35,0,5),(44,35,1,4),(44,35,4,2),(44,36,3,12),(44,37,3,2),(44,38,4,10),(44,38,5,7),(44,38,10,11),(44,39,3,3),(44,39,4,11),(44,39,5,13),(44,40,1,2),(44,41,7,5),(44,43,4,8),(47,0,2,12),(47,0,16,8),(47,0,22,13),(47,1,24,10),(47,3,18,0),(47,3,26,3),(47,3,27,2),(47,5,2,1),(47,5,15,4),(47,5,20,11),(47,5,29,5),(47,6,22,0),(47,6,23,1),(47,6,24,12),(47,6,28,9),(47,7,2,12),(47,7,21,0),(47,8,3,10),(47,8,11,10),(47,9,10,1),(47,9,13,7),(47,10,11,6),(47,10,13,4),(47,10,15,0),(47,10,19,4),(47,11,8,0),(47,11,9,13),(47,11,29,8),(47,12,3,12),(47,12,16,5),(47,12,20,13),(47,12,22,4),(47,13,25,10),(47,13,27,12),(47,14,5,8),(47,14,6,10),(47,14,18,9),(47,14,23,0),(47,14,25,2),(47,15,5,8),(47,15,23,1),(47,16,19,5),(47,16,21,5),(47,16,22,1),(47,16,26,7),(47,16,27,2),(47,17,9,5),(47,17,18,9),(47,17,22,12),(47,18,8,4),(47,18,21,2),(47,18,22,0),(47,19,9,7),(47,19,10,6),(47,19,16,3),(47,19,26,8),(47,19,28,1),(47,20,8,9),(47,20,18,13),(47,20,24,5),(47,20,27,3),(47,21,11,0),(47,21,15,10),(47,22,17,9),(47,22,24,3),(47,23,7,13),(47,23,12,4),(47,23,14,8),(47,23,16,2),(47,23,22,7),(47,23,23,9),(47,24,0,5),(47,24,16,6),(47,25,2,11),(47,25,6,6),(47,25,11,7),(47,25,14,2),(47,25,20,11),(47,25,25,1),(47,26,11,3),(47,26,24,5),(47,27,27,0),(47,27,29,1),(47,28,3,9),(47,28,12,3),(47,29,0,3),(47,29,1,11),(47,29,6,9),(47,29,14,6),(52,0,1,11),(52,0,2,9),(52,0,6,10),(52,0,26,4),(52,0,27,1),(52,0,29,1),(52,0,30,4),(52,1,0,7),(52,1,3,11),(52,1,14,9),(52,1,15,3),(52,1,24,11),(52,1,28,4),(52,1,33,10),(52,1,38,0),(52,2,0,13),(52,2,15,6),(52,2,25,2),(52,2,26,4),(52,2,31,4),(52,2,32,10),(52,2,52,2),(52,3,3,0),(52,3,10,4),(52,3,15,7),(52,3,20,1),(52,3,26,5),(52,3,29,6),(52,3,34,8),(52,3,44,11),(52,3,49,6),(52,3,51,3),(52,4,3,3),(52,4,25,9),(52,4,34,6),(52,4,41,8),(52,4,43,7),(52,4,44,11),(52,4,46,2),(52,4,47,11),(52,5,8,9),(52,5,27,1),(52,5,28,13),(52,5,42,7),(52,5,43,12),(52,5,51,2),(52,6,6,6),(52,6,7,10),(52,6,8,0),(52,6,11,13),(52,6,28,4),(52,6,32,4),(52,6,34,12),(52,6,49,13),(52,7,0,12),(52,7,7,12),(52,7,16,12),(52,7,25,1),(52,7,51,3),(52,8,15,11),(52,8,51,7),(52,9,8,5),(52,9,9,12),(52,9,14,2),(52,9,16,0),(52,9,37,8),(52,9,49,0),(52,10,9,12),(52,10,16,9),(52,10,48,9),(52,10,49,6),(52,10,50,10),(52,11,6,1),(52,11,9,10),(52,11,30,9),(52,11,37,2),(52,12,30,2),(52,12,43,1),(52,12,44,12),(52,12,52,10),(52,13,5,5),(52,13,9,1),(52,13,12,0),(52,13,16,6),(52,13,42,0),(52,13,43,6),(52,13,44,0),(52,13,48,0),(52,13,51,4);
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
INSERT INTO `galaxies` VALUES (1,'2011-01-03 15:25:33','dev');
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
) ENGINE=InnoDB AUTO_INCREMENT=25 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `objectives`
--

LOCK TABLES `objectives` WRITE;
/*!40000 ALTER TABLE `objectives` DISABLE KEYS */;
INSERT INTO `objectives` VALUES (1,1,'HaveUpgradedTo','Building::CollectorT1',1,1,0,0,NULL),(2,2,'HaveUpgradedTo','Building::MetalExtractor',1,1,0,0,NULL),(3,3,'HaveUpgradedTo','Building::CollectorT1',2,1,0,0,NULL),(4,3,'HaveUpgradedTo','Building::MetalExtractor',2,1,0,0,NULL),(5,4,'HaveUpgradedTo','Building::CollectorT1',2,3,0,0,NULL),(6,4,'HaveUpgradedTo','Building::MetalExtractor',2,3,0,0,NULL),(7,5,'HaveUpgradedTo','Building::CollectorT1',2,4,0,0,NULL),(8,5,'HaveUpgradedTo','Building::MetalExtractor',2,4,0,0,NULL),(9,6,'HaveUpgradedTo','Building::Barracks',1,1,0,0,NULL),(10,7,'HaveUpgradedTo','Unit::Trooper',2,1,0,0,NULL),(11,8,'DestroyNpcBuilding','Building::NpcMetalExtractor',1,1,0,0,NULL),(12,9,'HaveUpgradedTo','Building::MetalExtractor',1,7,0,0,NULL),(13,10,'HaveUpgradedTo','Building::CollectorT1',1,7,0,0,NULL),(14,11,'HaveUpgradedTo','Building::ResearchCenter',1,1,0,0,NULL),(15,12,'HaveUpgradedTo','Unit::Seeker',3,1,0,0,NULL),(16,13,'HaveUpgradedTo','Unit::Trooper',5,1,0,0,NULL),(17,14,'HaveUpgradedTo','Technology::ZetiumExtraction',1,1,0,0,NULL),(18,15,'HaveUpgradedTo','Building::ZetiumExtractor',1,1,0,0,NULL),(19,16,'HavePoints','Player',1,NULL,0,0,3000),(20,17,'HaveUpgradedTo','Building::EnergyStorage',1,1,0,0,NULL),(21,17,'HaveUpgradedTo','Building::MetalStorage',1,1,0,0,NULL),(22,17,'HaveUpgradedTo','Building::ZetiumStorage',1,1,0,0,NULL),(23,18,'HaveUpgradedTo','Technology::SpaceFactory',1,1,0,0,NULL),(24,19,'HaveUpgradedTo','Building::SpaceFactory',1,1,0,0,NULL);
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
INSERT INTO `players` VALUES (1,1,'0000000000000000000000000000000000000000000000000000000000000000','Test Player',9,9,NULL,0,0);
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
) ENGINE=InnoDB AUTO_INCREMENT=20 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `quests`
--

LOCK TABLES `quests` WRITE;
/*!40000 ALTER TABLE `quests` DISABLE KEYS */;
INSERT INTO `quests` VALUES (1,NULL,'{\"metal\":1000,\"energy\":1000}','building'),(2,1,'{\"metal\":1000,\"energy\":1000}','metal-extraction'),(3,2,'{\"metal\":1000,\"energy\":1000}',NULL),(4,3,'{\"metal\":1000,\"energy\":1000}',NULL),(5,4,'{\"metal\":1000,\"energy\":1000}',NULL),(6,3,'{\"metal\":1500,\"energy\":1500}',NULL),(7,6,'{\"metal\":1000,\"energy\":1000}','building-units'),(8,7,'{\"units\":[{\"level\":2,\"type\":\"Trooper\",\"count\":1,\"hp\":50},{\"level\":3,\"type\":\"Trooper\",\"count\":1,\"hp\":20}]}',NULL),(9,8,'{\"metal\":1000,\"energy\":1000}',NULL),(10,8,'{\"metal\":1000,\"energy\":1000}',NULL),(11,8,'{\"metal\":2000,\"energy\":2000,\"zetium\":600}','researching'),(12,11,'{\"metal\":1000,\"energy\":1000,\"zetium\":100}',NULL),(13,12,'{\"metal\":1000,\"energy\":1000,\"zetium\":100}',NULL),(14,11,'{\"metal\":1000,\"energy\":1000,\"zetium\":200}',NULL),(15,14,'{\"metal\":1000,\"energy\":1000,\"zetium\":200}','extracting-zetium'),(16,15,'{\"units\":[{\"level\":2,\"type\":\"Seeker\",\"count\":2,\"hp\":100},{\"level\":2,\"type\":\"Shocker\",\"count\":2,\"hp\":100}]}','collecting-points'),(17,15,'{\"metal\":4000,\"energy\":4000,\"zetium\":2000}','storing-resources'),(18,17,'{\"metal\":4000,\"energy\":4000,\"zetium\":2000}','space-factory'),(19,18,'{\"metal\":4000,\"energy\":4000,\"zetium\":2000}',NULL);
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
INSERT INTO `solar_systems` VALUES (1,'Expansion',1,2,1),(2,'Expansion',1,2,2),(3,'Resource',1,0,2),(4,'Homeworld',1,2,0);
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
) ENGINE=InnoDB AUTO_INCREMENT=55 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ss_objects`
--

LOCK TABLES `ss_objects` WRITE;
/*!40000 ALTER TABLE `ss_objects` DISABLE KEYS */;
INSERT INTO `ss_objects` VALUES (1,1,0,0,1,45,'Asteroid',NULL,'',49,0,0,0,0,0,0,1,0,0,1,NULL,0,NULL,NULL,NULL),(2,1,0,0,1,225,'Asteroid',NULL,'',31,0,0,0,3,0,0,1,0,0,3,NULL,0,NULL,NULL,NULL),(3,1,0,0,2,90,'Asteroid',NULL,'',59,0,0,0,1,0,0,3,0,0,1,NULL,0,NULL,NULL,NULL),(4,1,0,0,1,180,'Asteroid',NULL,'',57,0,0,0,1,0,0,0,0,0,1,NULL,0,NULL,NULL,NULL),(5,1,0,0,3,134,'Jumpgate',NULL,'',55,0,0,0,0,0,0,0,0,0,0,NULL,0,NULL,NULL,NULL),(6,1,0,0,2,240,'Asteroid',NULL,'',31,0,0,0,3,0,0,1,0,0,1,NULL,0,NULL,NULL,NULL),(7,1,18,53,1,315,'Planet',NULL,'P-7',54,1,0,0,0,0,0,0,0,0,0,'2011-01-03 15:25:41',0,NULL,NULL,NULL),(8,1,0,0,1,0,'Asteroid',NULL,'',43,0,0,0,0,0,0,1,0,0,0,NULL,0,NULL,NULL,NULL),(9,1,0,0,2,60,'Asteroid',NULL,'',54,0,0,0,1,0,0,1,0,0,1,NULL,0,NULL,NULL,NULL),(10,1,0,0,2,150,'Asteroid',NULL,'',30,0,0,0,0,0,0,0,0,0,0,NULL,0,NULL,NULL,NULL),(11,1,0,0,2,30,'Asteroid',NULL,'',60,0,0,0,3,0,0,1,0,0,2,NULL,0,NULL,NULL,NULL),(12,1,0,0,1,135,'Asteroid',NULL,'',37,0,0,0,1,0,0,2,0,0,1,NULL,0,NULL,NULL,NULL),(13,1,0,0,0,90,'Asteroid',NULL,'',53,0,0,0,0,0,0,0,0,0,1,NULL,0,NULL,NULL,NULL),(14,1,0,0,2,180,'Asteroid',NULL,'',53,0,0,0,1,0,0,3,0,0,2,NULL,0,NULL,NULL,NULL),(15,1,0,0,2,330,'Asteroid',NULL,'',56,0,0,0,1,0,0,1,0,0,3,NULL,0,NULL,NULL,NULL),(16,1,20,31,0,270,'Planet',NULL,'P-16',46,2,0,0,0,0,0,0,0,0,0,'2011-01-03 15:25:41',0,NULL,NULL,NULL),(17,1,20,54,2,0,'Planet',NULL,'P-17',56,2,0,0,0,0,0,0,0,0,0,'2011-01-03 15:25:41',0,NULL,NULL,NULL),(18,1,0,0,2,270,'Asteroid',NULL,'',52,0,0,0,1,0,0,0,0,0,0,NULL,0,NULL,NULL,NULL),(19,1,0,0,0,180,'Asteroid',NULL,'',42,0,0,0,0,0,0,0,0,0,0,NULL,0,NULL,NULL,NULL),(20,1,0,0,2,300,'Asteroid',NULL,'',53,0,0,0,1,0,0,1,0,0,1,NULL,0,NULL,NULL,NULL),(21,1,0,0,0,0,'Asteroid',NULL,'',34,0,0,0,3,0,0,3,0,0,1,NULL,0,NULL,NULL,NULL),(22,2,0,0,1,225,'Asteroid',NULL,'',60,0,0,0,0,0,0,0,0,0,1,NULL,0,NULL,NULL,NULL),(23,2,53,22,1,90,'Planet',NULL,'P-23',56,1,0,0,0,0,0,0,0,0,0,'2011-01-03 15:25:41',0,NULL,NULL,NULL),(24,2,0,0,1,135,'Asteroid',NULL,'',57,0,0,0,3,0,0,3,0,0,1,NULL,0,NULL,NULL,NULL),(25,2,0,0,2,180,'Asteroid',NULL,'',37,0,0,0,3,0,0,2,0,0,2,NULL,0,NULL,NULL,NULL),(26,2,0,0,3,22,'Jumpgate',NULL,'',31,0,0,0,0,0,0,0,0,0,0,NULL,0,NULL,NULL,NULL),(27,2,0,0,1,180,'Asteroid',NULL,'',26,0,0,0,1,0,0,0,0,0,1,NULL,0,NULL,NULL,NULL),(28,2,0,0,0,270,'Asteroid',NULL,'',34,0,0,0,0,0,0,0,0,0,1,NULL,0,NULL,NULL,NULL),(29,2,0,0,1,315,'Asteroid',NULL,'',53,0,0,0,1,0,0,3,0,0,1,NULL,0,NULL,NULL,NULL),(30,2,60,17,2,240,'Planet',NULL,'P-30',57,2,0,0,0,0,0,0,0,0,0,'2011-01-03 15:25:41',0,NULL,NULL,NULL),(31,2,0,0,3,224,'Jumpgate',NULL,'',51,0,0,0,0,0,0,0,0,0,0,NULL,0,NULL,NULL,NULL),(32,2,0,0,0,0,'Asteroid',NULL,'',25,0,0,0,0,0,0,0,0,0,0,NULL,0,NULL,NULL,NULL),(33,3,42,25,1,45,'Planet',NULL,'P-33',53,2,0,0,0,0,0,0,0,0,0,'2011-01-03 15:25:41',0,NULL,NULL,NULL),(34,3,0,0,1,225,'Asteroid',NULL,'',26,0,0,0,1,0,0,0,0,0,0,NULL,0,NULL,NULL,NULL),(35,3,0,0,2,120,'Asteroid',NULL,'',45,0,0,0,2,0,0,1,0,0,3,NULL,0,NULL,NULL,NULL),(36,3,0,0,3,22,'Jumpgate',NULL,'',60,0,0,0,0,0,0,0,0,0,0,NULL,0,NULL,NULL,NULL),(37,3,0,0,3,246,'Jumpgate',NULL,'',47,0,0,0,0,0,0,0,0,0,0,NULL,0,NULL,NULL,NULL),(38,3,0,0,2,240,'Asteroid',NULL,'',43,0,0,0,1,0,0,0,0,0,0,NULL,0,NULL,NULL,NULL),(39,3,0,0,3,292,'Jumpgate',NULL,'',54,0,0,0,0,0,0,0,0,0,0,NULL,0,NULL,NULL,NULL),(40,3,0,0,3,112,'Jumpgate',NULL,'',30,0,0,0,0,0,0,0,0,0,0,NULL,0,NULL,NULL,NULL),(41,3,0,0,0,90,'Asteroid',NULL,'',50,0,0,0,3,0,0,2,0,0,3,NULL,0,NULL,NULL,NULL),(42,3,0,0,2,330,'Asteroid',NULL,'',47,0,0,0,3,0,0,1,0,0,3,NULL,0,NULL,NULL,NULL),(43,3,0,0,0,270,'Asteroid',NULL,'',51,0,0,0,2,0,0,2,0,0,1,NULL,0,NULL,NULL,NULL),(44,3,44,15,2,270,'Planet',NULL,'P-44',49,0,0,0,0,0,0,0,0,0,0,'2011-01-03 15:25:41',0,NULL,NULL,NULL),(45,3,0,0,2,300,'Asteroid',NULL,'',40,0,0,0,3,0,0,1,0,0,3,NULL,0,NULL,NULL,NULL),(46,3,0,0,0,0,'Asteroid',NULL,'',58,0,0,0,3,0,0,1,0,0,1,NULL,0,NULL,NULL,NULL),(47,4,30,30,2,150,'Planet',1,'P-47',50,0,3186.11,2.79,9654.87,7042.03,6.17,21339.5,0,0,2622.17,'2011-01-03 15:25:41',0,NULL,NULL,NULL),(48,4,0,0,1,135,'Asteroid',NULL,'',46,0,0,0,1,0,0,0,0,0,0,NULL,0,NULL,NULL,NULL),(49,4,0,0,2,330,'Asteroid',NULL,'',45,0,0,0,1,0,0,0,0,0,1,NULL,0,NULL,NULL,NULL),(50,4,0,0,2,210,'Asteroid',NULL,'',39,0,0,0,0,0,0,1,0,0,1,NULL,0,NULL,NULL,NULL),(51,4,0,0,3,224,'Jumpgate',NULL,'',60,0,0,0,0,0,0,0,0,0,0,NULL,0,NULL,NULL,NULL),(52,4,14,53,0,180,'Planet',NULL,'P-52',53,2,0,0,0,0,0,0,0,0,0,'2011-01-03 15:25:41',0,NULL,NULL,NULL),(53,4,0,0,2,300,'Asteroid',NULL,'',54,0,0,0,0,0,0,1,0,0,0,NULL,0,NULL,NULL,NULL),(54,4,0,0,0,0,'Asteroid',NULL,'',57,0,0,0,0,0,0,1,0,0,1,NULL,0,NULL,NULL,NULL);
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
INSERT INTO `tiles` VALUES (5,7,0,11),(5,7,0,12),(5,7,0,13),(5,7,0,15),(5,7,0,16),(5,7,0,17),(3,7,0,26),(3,7,0,27),(3,7,0,28),(3,7,0,29),(3,7,0,30),(3,7,0,31),(3,7,0,32),(3,7,0,33),(3,7,0,34),(4,7,0,35),(4,7,0,36),(4,7,0,37),(4,7,0,38),(4,7,0,39),(4,7,0,40),(4,7,0,41),(3,7,0,43),(3,7,0,44),(3,7,0,45),(3,7,0,46),(3,7,0,47),(3,7,0,48),(6,7,0,50),(5,7,1,10),(5,7,1,11),(5,7,1,12),(5,7,1,13),(5,7,1,16),(5,7,1,17),(5,7,1,18),(3,7,1,27),(3,7,1,28),(3,7,1,29),(3,7,1,30),(3,7,1,31),(3,7,1,32),(6,7,1,33),(6,7,1,34),(6,7,1,35),(4,7,1,36),(4,7,1,37),(4,7,1,38),(4,7,1,39),(4,7,1,40),(3,7,1,43),(3,7,1,44),(3,7,1,45),(6,7,1,46),(6,7,1,47),(6,7,1,48),(6,7,1,49),(6,7,1,50),(5,7,2,10),(5,7,2,11),(5,7,2,12),(5,7,2,15),(5,7,2,16),(5,7,2,17),(5,7,2,18),(5,7,2,19),(12,7,2,26),(3,7,2,32),(6,7,2,33),(6,7,2,34),(6,7,2,35),(6,7,2,36),(4,7,2,37),(4,7,2,38),(4,7,2,39),(3,7,2,42),(3,7,2,43),(3,7,2,44),(3,7,2,45),(6,7,2,47),(6,7,2,48),(5,7,3,10),(5,7,3,11),(0,7,3,12),(5,7,3,16),(5,7,3,17),(5,7,3,18),(5,7,3,19),(6,7,3,32),(6,7,3,33),(6,7,3,34),(6,7,3,35),(6,7,3,36),(4,7,3,37),(4,7,3,38),(4,7,3,39),(3,7,3,43),(3,7,3,44),(3,7,3,45),(6,7,3,47),(6,7,3,48),(13,7,4,2),(5,7,4,10),(5,7,4,11),(10,7,4,15),(3,7,4,25),(6,7,4,32),(6,7,4,34),(6,7,4,35),(4,7,4,39),(0,7,4,44),(3,7,5,9),(3,7,5,10),(5,7,5,11),(5,7,5,14),(2,7,5,22),(3,7,5,24),(3,7,5,25),(0,7,5,33),(6,7,5,35),(6,7,5,36),(4,7,5,39),(5,7,5,43),(3,7,6,7),(3,7,6,8),(3,7,6,9),(3,7,6,10),(3,7,6,11),(3,7,6,12),(5,7,6,13),(5,7,6,14),(3,7,6,24),(3,7,6,25),(6,7,6,35),(6,7,6,36),(6,7,6,37),(5,7,6,41),(5,7,6,42),(5,7,6,43),(5,7,6,44),(3,7,7,7),(3,7,7,8),(3,7,7,9),(3,7,7,10),(3,7,7,11),(3,7,7,12),(3,7,7,13),(5,7,7,14),(3,7,7,21),(3,7,7,22),(3,7,7,23),(3,7,7,24),(3,7,7,25),(5,7,7,40),(5,7,7,41),(5,7,7,42),(5,7,7,43),(5,7,7,44),(3,7,8,7),(3,7,8,8),(3,7,8,9),(3,7,8,10),(3,7,8,11),(3,7,8,12),(5,7,8,13),(5,7,8,14),(5,7,8,15),(5,7,8,16),(5,7,8,17),(5,7,8,18),(5,7,8,19),(5,7,8,20),(3,7,8,21),(3,7,8,22),(3,7,8,25),(4,7,8,27),(4,7,8,28),(4,7,8,29),(4,7,8,30),(4,7,8,31),(5,7,8,34),(5,7,8,40),(5,7,8,41),(5,7,8,42),(5,7,8,43),(5,7,8,44),(4,7,8,45),(4,7,8,46),(9,7,8,48),(3,7,9,6),(3,7,9,7),(3,7,9,9),(3,7,9,10),(3,7,9,11),(3,7,9,12),(5,7,9,13),(6,7,9,14),(6,7,9,15),(5,7,9,16),(8,7,9,17),(5,7,9,20),(3,7,9,25),(3,7,9,26),(4,7,9,28),(4,7,9,29),(4,7,9,30),(5,7,9,34),(0,7,9,35),(0,7,9,41),(4,7,9,43),(4,7,9,44),(4,7,9,45),(4,7,9,46),(3,7,10,10),(3,7,10,11),(3,7,10,12),(6,7,10,14),(6,7,10,15),(3,7,10,25),(4,7,10,28),(4,7,10,30),(4,7,10,31),(4,7,10,32),(5,7,10,34),(4,7,10,43),(4,7,10,44),(4,7,10,46),(4,7,10,47),(3,7,11,10),(3,7,11,11),(6,7,11,12),(6,7,11,13),(6,7,11,14),(6,7,11,15),(4,7,11,29),(4,7,11,30),(4,7,11,31),(4,7,11,32),(4,7,11,33),(5,7,11,34),(5,7,11,35),(4,7,11,44),(4,7,11,45),(4,7,11,46),(4,7,11,47),(1,7,12,8),(6,7,12,14),(13,7,12,15),(4,7,12,30),(4,7,12,31),(5,7,12,32),(5,7,12,33),(5,7,12,34),(5,7,12,35),(5,7,12,36),(4,7,12,37),(4,7,12,38),(4,7,12,39),(4,7,12,44),(4,7,12,45),(4,7,12,47),(4,7,12,48),(6,7,13,13),(6,7,13,14),(4,7,13,30),(4,7,13,31),(5,7,13,33),(5,7,13,34),(5,7,13,35),(5,7,13,36),(4,7,13,37),(4,7,13,38),(4,7,13,40),(4,7,13,44),(4,7,13,47),(6,7,14,11),(6,7,14,12),(6,7,14,13),(4,7,14,29),(4,7,14,30),(4,7,14,31),(4,7,14,32),(5,7,14,34),(4,7,14,37),(4,7,14,38),(4,7,14,40),(4,7,14,41),(8,7,14,44),(0,7,15,1),(6,7,15,11),(6,7,15,12),(6,7,15,13),(6,7,15,14),(4,7,15,29),(4,7,15,30),(4,7,15,31),(4,7,15,32),(4,7,15,38),(4,7,15,39),(4,7,15,40),(4,7,15,41),(6,7,16,11),(6,7,16,12),(4,7,16,29),(4,7,16,30),(4,7,16,31),(4,7,16,32),(4,7,16,33),(4,7,16,34),(4,7,16,37),(4,7,16,38),(4,7,16,39),(4,7,16,40),(4,7,17,28),(4,7,17,29),(4,7,17,30),(4,7,17,32),(4,7,17,33),(4,7,17,38),(4,7,17,39),(3,16,0,3),(5,16,0,6),(5,16,0,7),(5,16,0,8),(5,16,0,9),(3,16,0,12),(4,16,0,15),(4,16,0,16),(4,16,0,17),(9,16,0,18),(6,16,0,22),(5,16,0,23),(5,16,0,24),(5,16,0,25),(5,16,0,26),(4,16,0,27),(4,16,0,28),(4,16,0,29),(4,16,0,30),(3,16,1,3),(5,16,1,7),(3,16,1,8),(3,16,1,10),(3,16,1,12),(4,16,1,15),(4,16,1,16),(4,16,1,17),(6,16,1,22),(5,16,1,24),(4,16,1,25),(4,16,1,26),(4,16,1,27),(4,16,1,28),(4,16,1,29),(4,16,1,30),(3,16,2,3),(3,16,2,6),(3,16,2,7),(3,16,2,8),(3,16,2,9),(3,16,2,10),(3,16,2,11),(3,16,2,12),(3,16,2,13),(4,16,2,15),(4,16,2,16),(4,16,2,17),(6,16,2,21),(6,16,2,22),(9,16,2,24),(4,16,2,27),(0,16,2,28),(4,16,2,30),(3,16,3,3),(3,16,3,4),(3,16,3,5),(0,16,3,6),(3,16,3,8),(14,16,3,9),(4,16,3,16),(4,16,3,17),(6,16,3,21),(6,16,3,22),(4,16,3,30),(5,16,4,0),(5,16,4,1),(3,16,4,3),(3,16,4,4),(3,16,4,5),(3,16,4,8),(4,16,4,17),(4,16,4,18),(6,16,4,21),(4,16,4,30),(5,16,5,0),(5,16,5,1),(5,16,5,2),(3,16,5,3),(3,16,5,5),(3,16,5,6),(4,16,5,17),(2,16,5,19),(3,16,6,0),(3,16,6,1),(3,16,6,2),(3,16,6,5),(3,16,6,6),(6,16,6,11),(6,16,6,12),(6,16,6,13),(3,16,7,0),(3,16,7,1),(3,16,7,2),(3,16,7,3),(6,16,7,11),(3,16,8,0),(3,16,8,1),(3,16,8,2),(3,16,8,3),(3,16,8,4),(6,16,8,11),(6,16,8,12),(4,16,8,13),(4,16,8,14),(1,16,8,15),(3,16,9,0),(3,16,9,3),(0,16,9,10),(6,16,9,12),(4,16,9,14),(4,16,10,0),(4,16,10,3),(4,16,10,14),(6,16,10,19),(4,16,11,0),(4,16,11,1),(4,16,11,3),(4,16,11,12),(4,16,11,14),(4,16,11,15),(6,16,11,19),(4,16,12,0),(4,16,12,1),(4,16,12,2),(4,16,12,3),(4,16,12,4),(4,16,12,11),(4,16,12,12),(4,16,12,13),(4,16,12,14),(6,16,12,18),(6,16,12,19),(6,16,12,20),(14,16,12,25),(4,16,13,0),(4,16,13,1),(4,16,13,2),(12,16,13,3),(6,16,13,9),(0,16,13,11),(4,16,13,13),(4,16,13,14),(6,16,13,18),(6,16,13,20),(5,16,13,22),(5,16,13,23),(13,16,14,0),(4,16,14,2),(6,16,14,9),(4,16,14,13),(5,16,14,23),(6,16,15,9),(6,16,15,10),(5,16,15,22),(5,16,15,23),(6,16,16,9),(6,16,16,10),(6,16,16,11),(2,16,17,16),(6,16,17,18),(6,16,17,19),(6,16,17,20),(1,16,17,22),(0,16,17,28),(6,16,18,19),(6,16,18,20),(6,16,19,19),(6,16,19,20),(6,17,0,9),(6,17,0,10),(6,17,0,11),(4,17,0,22),(4,17,0,23),(6,17,1,4),(6,17,1,9),(6,17,1,10),(5,17,1,19),(5,17,1,20),(5,17,1,21),(4,17,1,23),(4,17,1,24),(4,17,1,25),(4,17,1,26),(6,17,2,4),(6,17,2,6),(6,17,2,7),(6,17,2,8),(6,17,2,9),(6,17,2,10),(5,17,2,14),(5,17,2,15),(5,17,2,16),(5,17,2,17),(5,17,2,18),(5,17,2,19),(4,17,2,23),(4,17,2,24),(4,17,2,27),(4,17,2,28),(0,17,2,30),(6,17,3,3),(6,17,3,4),(6,17,3,6),(6,17,3,7),(6,17,3,8),(5,17,3,16),(5,17,3,17),(5,17,3,18),(5,17,3,19),(2,17,3,22),(4,17,3,24),(4,17,3,25),(4,17,3,26),(4,17,3,27),(4,17,3,28),(2,17,3,43),(1,17,3,50),(6,17,4,3),(6,17,4,4),(6,17,4,5),(6,17,4,6),(6,17,4,7),(5,17,4,15),(5,17,4,16),(5,17,4,17),(5,17,4,18),(4,17,4,24),(4,17,4,25),(6,17,4,26),(4,17,4,27),(4,17,4,28),(6,17,5,6),(13,17,5,7),(5,17,5,13),(5,17,5,14),(5,17,5,15),(5,17,5,16),(4,17,5,24),(6,17,5,25),(6,17,5,26),(6,17,5,27),(4,17,5,28),(6,17,6,6),(5,17,6,14),(5,17,6,16),(13,17,6,21),(4,17,6,24),(6,17,6,26),(6,17,6,27),(6,17,6,28),(5,17,6,29),(5,17,6,30),(5,17,6,33),(3,17,6,46),(10,17,7,9),(5,17,7,14),(9,17,7,23),(6,17,7,26),(6,17,7,27),(5,17,7,28),(5,17,7,29),(5,17,7,30),(5,17,7,31),(5,17,7,33),(9,17,7,35),(3,17,7,45),(3,17,7,46),(0,17,8,14),(4,17,8,17),(6,17,8,27),(6,17,8,28),(5,17,8,29),(5,17,8,30),(5,17,8,31),(5,17,8,32),(5,17,8,33),(5,17,8,34),(3,17,8,45),(3,17,8,46),(6,17,8,49),(4,17,9,17),(4,17,9,18),(4,17,9,19),(5,17,9,26),(6,17,9,27),(5,17,9,28),(5,17,9,29),(5,17,9,30),(5,17,9,31),(5,17,9,32),(3,17,9,33),(3,17,9,34),(3,17,9,38),(3,17,9,39),(3,17,9,41),(3,17,9,42),(3,17,9,43),(3,17,9,44),(3,17,9,45),(3,17,9,46),(6,17,9,47),(6,17,9,48),(6,17,9,49),(14,17,9,50),(3,17,10,0),(3,17,10,2),(4,17,10,17),(4,17,10,18),(4,17,10,19),(4,17,10,20),(5,17,10,26),(5,17,10,27),(5,17,10,28),(5,17,10,29),(5,17,10,30),(5,17,10,31),(0,17,10,32),(3,17,10,34),(3,17,10,38),(3,17,10,39),(3,17,10,40),(3,17,10,41),(3,17,10,43),(3,17,10,44),(3,17,10,45),(6,17,10,46),(6,17,10,47),(6,17,10,48),(6,17,10,49),(3,17,11,0),(3,17,11,1),(3,17,11,2),(3,17,11,3),(3,17,11,4),(6,17,11,15),(4,17,11,17),(4,17,11,18),(4,17,11,19),(5,17,11,23),(5,17,11,24),(5,17,11,25),(5,17,11,26),(5,17,11,27),(5,17,11,28),(5,17,11,29),(5,17,11,30),(5,17,11,31),(3,17,11,34),(3,17,11,35),(3,17,11,36),(3,17,11,37),(3,17,11,38),(3,17,11,39),(3,17,11,40),(3,17,11,41),(3,17,11,42),(3,17,11,43),(3,17,11,44),(3,17,11,45),(3,17,11,46),(6,17,11,47),(6,17,11,48),(4,17,11,49),(3,17,12,0),(3,17,12,1),(3,17,12,2),(3,17,12,4),(3,17,12,5),(6,17,12,12),(6,17,12,13),(6,17,12,14),(6,17,12,15),(4,17,12,17),(4,17,12,18),(4,17,12,19),(5,17,12,24),(5,17,12,26),(5,17,12,27),(5,17,12,28),(5,17,12,31),(3,17,12,32),(3,17,12,33),(3,17,12,34),(3,17,12,35),(3,17,12,36),(3,17,12,37),(3,17,12,38),(3,17,12,39),(3,17,12,40),(0,17,12,41),(3,17,12,43),(3,17,12,44),(3,17,12,45),(4,17,12,46),(6,17,12,47),(6,17,12,48),(4,17,12,49),(3,17,13,0),(3,17,13,1),(3,17,13,2),(3,17,13,3),(3,17,13,4),(6,17,13,15),(4,17,13,16),(4,17,13,17),(4,17,13,18),(4,17,13,19),(4,17,13,20),(5,17,13,25),(5,17,13,26),(5,17,13,27),(5,17,13,28),(5,17,13,29),(5,17,13,30),(5,17,13,31),(3,17,13,32),(3,17,13,33),(3,17,13,34),(3,17,13,35),(3,17,13,36),(4,17,13,37),(3,17,13,38),(3,17,13,39),(3,17,13,40),(3,17,13,43),(3,17,13,44),(4,17,13,45),(4,17,13,46),(4,17,13,47),(4,17,13,48),(4,17,13,49),(3,17,14,0),(11,17,14,1),(6,17,14,15),(6,17,14,16),(4,17,14,17),(4,17,14,18),(4,17,14,20),(5,17,14,25),(3,17,14,30),(3,17,14,31),(3,17,14,32),(8,17,14,33),(4,17,14,36),(4,17,14,37),(3,17,14,38),(3,17,14,39),(3,17,14,40),(3,17,14,41),(3,17,14,42),(3,17,14,43),(3,17,14,44),(4,17,14,45),(4,17,14,46),(4,17,14,47),(4,17,14,48),(4,17,14,49),(3,17,15,0),(5,17,15,13),(6,17,15,14),(6,17,15,15),(6,17,15,16),(6,17,15,17),(11,17,15,20),(4,17,15,31),(3,17,15,32),(4,17,15,36),(4,17,15,37),(4,17,15,38),(3,17,15,39),(3,17,15,40),(3,17,15,41),(3,17,15,42),(3,17,15,43),(4,17,15,44),(4,17,15,45),(4,17,15,46),(4,17,15,47),(4,17,15,48),(3,17,16,0),(5,17,16,11),(5,17,16,12),(5,17,16,13),(5,17,16,14),(5,17,16,15),(5,17,16,16),(5,17,16,17),(5,17,16,18),(4,17,16,28),(4,17,16,29),(4,17,16,31),(4,17,16,32),(4,17,16,36),(4,17,16,37),(0,17,16,38),(5,17,16,41),(5,17,16,42),(5,17,16,43),(0,17,16,45),(4,17,16,47),(4,17,16,48),(3,17,17,0),(5,17,17,13),(5,17,17,14),(5,17,17,15),(5,17,17,17),(4,17,17,27),(4,17,17,28),(4,17,17,29),(4,17,17,30),(4,17,17,31),(4,17,17,35),(4,17,17,36),(4,17,17,37),(5,17,17,41),(5,17,17,42),(5,17,17,43),(5,17,17,44),(4,17,17,47),(4,17,17,48),(5,17,17,50),(3,17,18,0),(3,17,18,1),(3,17,18,2),(3,17,18,3),(3,17,18,4),(3,17,18,5),(3,17,18,6),(5,17,18,10),(5,17,18,11),(5,17,18,12),(5,17,18,13),(5,17,18,14),(4,17,18,28),(4,17,18,29),(4,17,18,30),(4,17,18,31),(4,17,18,32),(4,17,18,33),(4,17,18,37),(4,17,18,38),(4,17,18,40),(5,17,18,41),(5,17,18,42),(5,17,18,43),(5,17,18,44),(5,17,18,45),(5,17,18,46),(5,17,18,47),(5,17,18,48),(5,17,18,49),(5,17,18,50),(3,17,19,0),(3,17,19,1),(3,17,19,2),(3,17,19,3),(3,17,19,4),(3,17,19,5),(3,17,19,6),(3,17,19,7),(3,17,19,8),(5,17,19,9),(5,17,19,10),(5,17,19,11),(5,17,19,12),(5,17,19,13),(5,17,19,14),(4,17,19,29),(4,17,19,30),(4,17,19,31),(4,17,19,32),(4,17,19,33),(4,17,19,34),(4,17,19,35),(4,17,19,36),(4,17,19,37),(4,17,19,38),(4,17,19,39),(4,17,19,40),(4,17,19,41),(4,17,19,42),(5,17,19,43),(5,17,19,44),(5,17,19,45),(5,17,19,46),(5,17,19,47),(5,17,19,48),(5,23,0,15),(5,23,0,16),(5,23,0,17),(5,23,0,18),(5,23,0,19),(5,23,0,20),(5,23,0,21),(0,23,1,12),(5,23,1,14),(5,23,1,15),(5,23,1,18),(5,23,1,19),(5,23,1,20),(5,23,1,21),(5,23,2,18),(5,23,2,19),(5,23,2,20),(5,23,2,21),(5,23,3,18),(5,23,3,19),(5,23,3,20),(5,23,3,21),(5,23,4,16),(5,23,4,17),(5,23,4,18),(5,23,4,19),(5,23,4,20),(5,23,4,21),(4,23,5,2),(4,23,5,3),(5,23,5,16),(5,23,5,17),(0,23,5,19),(5,23,5,21),(4,23,6,3),(4,23,6,4),(4,23,6,5),(5,23,6,21),(4,23,7,2),(4,23,7,3),(4,23,7,4),(4,23,7,5),(1,23,7,10),(5,23,7,20),(5,23,7,21),(4,23,8,3),(4,23,8,4),(4,23,8,5),(4,23,8,6),(4,23,8,7),(4,23,8,8),(5,23,8,21),(4,23,9,3),(4,23,9,4),(4,23,9,5),(4,23,9,6),(4,23,9,7),(4,23,10,4),(4,23,10,5),(0,23,10,6),(0,23,10,17),(4,23,11,2),(4,23,11,3),(4,23,11,4),(4,23,12,2),(4,23,12,3),(0,23,12,13),(6,23,14,6),(6,23,14,7),(6,23,14,8),(6,23,14,9),(6,23,15,5),(6,23,15,6),(6,23,15,7),(6,23,15,8),(6,23,16,5),(6,23,16,6),(6,23,16,7),(6,23,16,8),(10,23,16,18),(3,23,20,19),(3,23,20,20),(3,23,20,21),(3,23,21,20),(3,23,21,21),(5,23,22,13),(3,23,22,19),(3,23,22,20),(3,23,22,21),(5,23,23,11),(5,23,23,12),(5,23,23,13),(3,23,23,19),(3,23,23,20),(3,23,23,21),(6,23,24,8),(6,23,24,9),(5,23,24,10),(5,23,24,11),(5,23,24,12),(5,23,24,13),(3,23,24,18),(3,23,24,19),(3,23,24,20),(3,23,24,21),(6,23,25,7),(6,23,25,8),(6,23,25,9),(6,23,25,10),(5,23,25,11),(5,23,25,12),(5,23,25,13),(5,23,25,14),(5,23,25,15),(3,23,25,18),(3,23,25,19),(3,23,25,20),(3,23,25,21),(6,23,26,5),(6,23,26,6),(6,23,26,7),(6,23,26,8),(13,23,26,9),(5,23,26,11),(5,23,26,12),(5,23,26,13),(5,23,26,14),(5,23,26,15),(4,23,26,19),(3,23,26,21),(6,23,27,7),(5,23,27,11),(5,23,27,12),(5,23,27,13),(5,23,27,14),(5,23,27,15),(5,23,27,16),(5,23,27,17),(4,23,27,18),(4,23,27,19),(3,23,27,20),(3,23,27,21),(6,23,28,7),(5,23,28,11),(5,23,28,13),(4,23,28,16),(4,23,28,17),(4,23,28,18),(4,23,28,19),(3,23,28,20),(4,23,28,21),(3,23,29,11),(3,23,29,12),(5,23,29,13),(5,23,29,14),(5,23,29,15),(4,23,29,17),(4,23,29,19),(4,23,29,20),(4,23,29,21),(3,23,30,11),(5,23,30,12),(5,23,30,13),(5,23,30,14),(4,23,30,15),(4,23,30,16),(4,23,30,18),(4,23,30,19),(4,23,30,20),(4,23,30,21),(3,23,31,11),(3,23,31,12),(5,23,31,13),(3,23,31,14),(3,23,31,15),(4,23,31,16),(4,23,31,17),(4,23,31,18),(4,23,31,19),(4,23,31,20),(10,23,32,5),(3,23,32,9),(3,23,32,10),(3,23,32,11),(3,23,32,12),(3,23,32,13),(3,23,32,14),(8,23,32,15),(4,23,32,18),(4,23,32,20),(3,23,33,9),(3,23,33,10),(3,23,33,11),(3,23,33,12),(3,23,33,13),(3,23,33,14),(4,23,33,18),(4,23,33,19),(4,23,33,20),(3,23,34,9),(3,23,34,10),(3,23,34,11),(3,23,34,12),(3,23,34,13),(3,23,34,14),(4,23,34,18),(4,23,34,19),(4,23,34,20),(3,23,35,9),(3,23,35,10),(3,23,35,11),(3,23,35,12),(3,23,35,13),(3,23,35,14),(8,23,35,15),(4,23,35,18),(4,23,35,20),(4,23,35,21),(3,23,36,8),(3,23,36,9),(3,23,36,10),(3,23,36,11),(3,23,36,12),(3,23,36,13),(3,23,36,14),(4,23,36,18),(4,23,36,19),(4,23,36,20),(4,23,36,21),(6,23,37,0),(6,23,37,1),(3,23,37,10),(3,23,37,11),(3,23,37,12),(4,23,37,18),(4,23,37,19),(4,23,37,20),(6,23,38,0),(6,23,38,1),(6,23,38,2),(6,23,38,3),(3,23,38,10),(3,23,38,12),(3,23,38,13),(3,23,38,14),(4,23,38,17),(4,23,38,18),(4,23,38,19),(4,23,38,20),(4,23,38,21),(6,23,39,0),(6,23,39,1),(6,23,39,2),(5,23,39,8),(5,23,39,9),(5,23,39,11),(3,23,39,13),(1,23,39,15),(4,23,39,17),(4,23,39,18),(4,23,39,19),(4,23,39,20),(6,23,40,0),(6,23,40,1),(6,23,40,2),(5,23,40,4),(5,23,40,7),(5,23,40,8),(5,23,40,9),(5,23,40,10),(5,23,40,11),(5,23,40,12),(6,23,40,14),(4,23,40,17),(4,23,40,18),(5,23,41,1),(5,23,41,2),(5,23,41,4),(5,23,41,5),(5,23,41,7),(5,23,41,8),(5,23,41,9),(5,23,41,10),(5,23,41,11),(5,23,41,12),(6,23,41,14),(6,23,41,15),(4,23,41,16),(4,23,41,17),(5,23,42,2),(5,23,42,3),(5,23,42,4),(5,23,42,5),(5,23,42,6),(5,23,42,7),(5,23,42,8),(5,23,42,9),(5,23,42,10),(5,23,42,11),(6,23,42,13),(6,23,42,14),(6,23,42,15),(5,23,43,1),(5,23,43,2),(5,23,43,3),(5,23,43,4),(5,23,43,5),(6,23,43,7),(6,23,43,8),(5,23,43,9),(5,23,43,10),(5,23,43,12),(6,23,43,13),(6,23,43,14),(6,23,43,15),(5,23,44,0),(5,23,44,1),(5,23,44,2),(5,23,44,3),(5,23,44,4),(5,23,44,5),(5,23,44,6),(6,23,44,7),(6,23,44,8),(5,23,44,9),(5,23,44,10),(5,23,44,11),(5,23,44,12),(5,23,44,13),(6,23,44,14),(6,23,44,15),(5,23,45,0),(5,23,45,1),(5,23,45,2),(5,23,45,3),(5,23,45,4),(5,23,45,5),(6,23,45,7),(6,23,45,8),(3,23,45,9),(0,23,45,10),(5,23,45,12),(5,23,45,13),(6,23,45,14),(5,23,46,1),(5,23,46,2),(5,23,46,3),(5,23,46,4),(6,23,46,6),(6,23,46,7),(6,23,46,8),(3,23,46,9),(5,23,47,1),(5,23,47,2),(5,23,47,3),(5,23,47,4),(5,23,47,5),(6,23,47,6),(6,23,47,7),(6,23,47,8),(3,23,47,9),(3,23,47,10),(3,23,47,11),(5,23,48,3),(3,23,48,7),(3,23,48,8),(3,23,48,9),(3,23,48,11),(2,23,48,19),(3,23,49,6),(3,23,49,7),(3,23,49,8),(3,23,49,9),(3,23,49,10),(3,23,49,11),(3,23,50,6),(3,23,50,8),(3,23,51,6),(3,23,51,7),(3,23,51,8),(3,23,51,9),(3,23,51,10),(3,23,52,9),(3,30,0,2),(12,30,0,9),(3,30,1,1),(3,30,1,2),(3,30,1,3),(3,30,1,4),(3,30,2,0),(3,30,2,1),(3,30,2,2),(3,30,2,3),(3,30,2,4),(3,30,2,5),(3,30,2,6),(3,30,2,7),(3,30,2,8),(5,30,2,15),(5,30,2,16),(4,30,3,0),(4,30,3,1),(4,30,3,2),(4,30,3,3),(3,30,3,4),(3,30,3,5),(3,30,3,6),(3,30,3,7),(3,30,3,8),(5,30,3,15),(5,30,3,16),(4,30,4,0),(4,30,4,1),(4,30,4,2),(4,30,4,3),(3,30,4,4),(3,30,4,6),(3,30,4,7),(5,30,4,15),(5,30,4,16),(4,30,5,0),(4,30,5,1),(4,30,5,2),(4,30,5,3),(5,30,5,15),(5,30,5,16),(4,30,6,0),(6,30,6,1),(4,30,6,2),(4,30,6,3),(4,30,6,4),(3,30,6,6),(5,30,6,11),(5,30,6,12),(5,30,6,13),(5,30,6,14),(5,30,6,15),(5,30,6,16),(6,30,7,0),(6,30,7,1),(4,30,7,2),(3,30,7,6),(10,30,7,8),(5,30,7,12),(5,30,7,13),(5,30,7,14),(5,30,7,15),(5,30,7,16),(6,30,8,0),(6,30,8,1),(4,30,8,2),(4,30,8,3),(3,30,8,4),(3,30,8,5),(3,30,8,6),(5,30,8,12),(5,30,8,13),(5,30,8,14),(5,30,8,15),(5,30,8,16),(6,30,9,0),(6,30,9,1),(6,30,9,2),(3,30,9,4),(3,30,9,6),(3,30,9,7),(5,30,9,13),(5,30,9,14),(5,30,9,15),(5,30,9,16),(6,30,10,2),(3,30,10,4),(3,30,10,6),(5,30,10,13),(5,30,10,16),(3,30,11,4),(5,30,11,7),(5,30,11,8),(5,30,11,9),(5,30,11,12),(5,30,11,13),(1,30,12,7),(5,30,12,9),(5,30,12,10),(5,30,12,11),(5,30,12,12),(5,30,12,13),(5,30,12,14),(5,30,12,15),(5,30,13,9),(5,30,13,10),(5,30,13,11),(5,30,13,12),(5,30,13,13),(6,30,14,3),(5,30,14,7),(5,30,14,8),(5,30,14,9),(5,30,14,10),(5,30,14,11),(6,30,15,3),(6,30,15,5),(5,30,15,6),(5,30,15,7),(6,30,16,3),(6,30,16,4),(6,30,16,5),(6,30,16,6),(5,30,16,7),(6,30,17,5),(6,30,17,6),(5,30,17,7),(11,30,19,1),(14,30,23,5),(0,30,24,1),(4,30,27,10),(4,30,27,11),(4,30,27,12),(11,30,28,0),(4,30,28,8),(4,30,28,9),(4,30,28,10),(4,30,28,11),(4,30,28,12),(4,30,28,14),(4,30,29,8),(4,30,29,10),(4,30,29,11),(4,30,29,12),(4,30,29,13),(4,30,29,14),(1,30,30,10),(4,30,30,12),(4,30,30,13),(9,30,31,6),(4,30,31,9),(4,30,31,12),(4,30,31,13),(14,30,32,0),(5,30,32,4),(4,30,32,9),(4,30,32,10),(4,30,32,11),(4,30,32,12),(4,30,32,13),(4,30,32,14),(5,30,33,4),(4,30,33,10),(4,30,33,11),(4,30,33,12),(4,30,33,13),(4,30,33,14),(4,30,33,15),(5,30,34,4),(4,30,34,9),(4,30,34,10),(4,30,34,14),(4,30,34,15),(5,30,35,1),(5,30,35,2),(5,30,35,4),(5,30,35,5),(4,30,35,8),(4,30,35,9),(5,30,36,1),(5,30,36,2),(5,30,36,3),(5,30,36,4),(5,30,36,5),(0,30,36,6),(5,30,37,0),(5,30,37,1),(5,30,37,2),(5,30,38,0),(5,30,38,1),(5,30,38,2),(5,30,38,3),(0,30,38,12),(5,30,39,0),(5,30,39,1),(5,30,39,2),(5,30,39,3),(8,30,39,6),(5,30,40,0),(5,30,40,1),(4,30,40,5),(3,30,40,14),(3,30,40,15),(3,30,40,16),(5,30,41,0),(5,30,41,1),(4,30,41,3),(4,30,41,5),(3,30,41,15),(3,30,41,16),(5,30,42,1),(4,30,42,3),(4,30,42,4),(4,30,42,5),(4,30,42,6),(4,30,42,7),(0,30,42,13),(3,30,42,15),(3,30,42,16),(4,30,43,3),(4,30,43,4),(4,30,43,5),(4,30,43,6),(4,30,43,7),(3,30,43,15),(3,30,43,16),(8,30,44,0),(4,30,44,3),(4,30,44,4),(4,30,44,5),(3,30,44,15),(3,30,44,16),(4,30,45,3),(4,30,45,4),(4,30,46,3),(2,30,47,5),(0,30,47,9),(0,30,51,7),(6,30,51,12),(6,30,51,14),(6,30,52,12),(6,30,52,13),(6,30,52,14),(6,30,53,13),(6,30,53,14),(3,30,54,7),(6,30,54,13),(3,30,55,7),(3,30,55,8),(6,30,55,13),(3,30,56,6),(3,30,56,7),(2,30,56,12),(0,30,57,4),(3,30,57,7),(3,30,57,8),(3,30,57,9),(3,30,57,10),(3,30,58,7),(3,30,58,9),(5,33,0,0),(5,33,0,1),(5,33,0,2),(5,33,0,3),(5,33,0,4),(5,33,0,5),(3,33,0,8),(3,33,0,9),(3,33,0,10),(5,33,1,0),(5,33,1,1),(5,33,1,2),(5,33,1,3),(5,33,1,4),(5,33,1,5),(5,33,1,6),(3,33,1,8),(3,33,1,9),(3,33,1,10),(5,33,2,0),(5,33,2,1),(5,33,2,2),(5,33,2,3),(5,33,2,4),(5,33,2,5),(3,33,2,6),(3,33,2,7),(3,33,2,8),(3,33,2,9),(3,33,2,10),(3,33,2,11),(5,33,2,16),(5,33,2,17),(5,33,2,18),(5,33,2,19),(5,33,3,2),(5,33,3,3),(5,33,3,4),(5,33,3,5),(5,33,3,6),(3,33,3,7),(3,33,3,8),(3,33,3,9),(3,33,3,10),(0,33,3,11),(5,33,3,16),(5,33,3,17),(5,33,3,18),(5,33,3,19),(5,33,3,20),(5,33,3,21),(5,33,3,23),(5,33,4,0),(5,33,4,1),(5,33,4,2),(5,33,4,3),(5,33,4,4),(5,33,4,5),(3,33,4,6),(3,33,4,7),(3,33,4,8),(3,33,4,10),(5,33,4,17),(5,33,4,18),(5,33,4,19),(5,33,4,20),(5,33,4,21),(5,33,4,22),(5,33,4,23),(5,33,4,24),(5,33,5,0),(5,33,5,1),(3,33,5,4),(3,33,5,5),(3,33,5,6),(3,33,5,7),(3,33,5,8),(3,33,5,10),(3,33,5,11),(0,33,5,16),(5,33,5,18),(5,33,5,19),(5,33,5,20),(5,33,5,21),(5,33,5,22),(5,33,5,24),(5,33,6,1),(3,33,6,6),(3,33,6,7),(3,33,6,10),(5,33,6,18),(5,33,6,19),(5,33,6,20),(5,33,6,21),(5,33,6,22),(5,33,6,24),(3,33,7,6),(3,33,7,7),(1,33,7,8),(3,33,7,10),(5,33,7,20),(5,33,7,21),(12,33,8,0),(9,33,8,22),(3,33,9,7),(3,33,9,8),(3,33,10,7),(3,33,10,8),(6,33,10,10),(3,33,11,6),(3,33,11,7),(3,33,11,8),(6,33,11,9),(6,33,11,10),(6,33,11,11),(6,33,11,12),(6,33,11,13),(1,33,11,16),(3,33,12,6),(3,33,12,7),(3,33,12,8),(6,33,12,9),(6,33,12,10),(6,33,12,11),(6,33,12,12),(3,33,12,15),(3,33,13,6),(3,33,13,7),(3,33,13,8),(3,33,13,9),(3,33,13,10),(3,33,13,14),(3,33,13,15),(3,33,13,16),(3,33,13,17),(5,33,14,0),(5,33,14,1),(5,33,14,2),(3,33,14,5),(3,33,14,6),(3,33,14,7),(3,33,14,8),(3,33,14,9),(3,33,14,10),(3,33,14,14),(3,33,14,15),(3,33,14,16),(5,33,15,0),(5,33,15,1),(5,33,15,2),(5,33,15,4),(3,33,15,5),(0,33,15,6),(3,33,15,8),(3,33,15,9),(3,33,15,10),(3,33,15,12),(3,33,15,13),(3,33,15,14),(3,33,15,15),(3,33,15,16),(5,33,16,0),(5,33,16,1),(5,33,16,2),(5,33,16,3),(5,33,16,4),(5,33,16,5),(3,33,16,8),(3,33,16,9),(3,33,16,10),(3,33,16,13),(3,33,16,14),(3,33,16,15),(3,33,16,16),(5,33,17,0),(5,33,17,1),(5,33,17,3),(5,33,17,4),(3,33,17,8),(3,33,17,9),(3,33,17,10),(3,33,17,11),(3,33,17,12),(3,33,17,13),(3,33,17,14),(3,33,17,15),(3,33,17,16),(3,33,17,17),(3,33,17,18),(5,33,18,0),(5,33,18,1),(5,33,18,2),(5,33,18,3),(5,33,18,4),(2,33,18,10),(3,33,18,14),(3,33,18,16),(3,33,18,17),(6,33,18,19),(5,33,19,0),(5,33,19,1),(5,33,19,2),(6,33,19,13),(3,33,19,14),(3,33,19,15),(3,33,19,16),(6,33,19,17),(6,33,19,18),(6,33,19,19),(6,33,19,20),(5,33,20,0),(5,33,20,1),(5,33,20,2),(6,33,20,12),(6,33,20,13),(3,33,20,15),(3,33,20,16),(6,33,20,18),(6,33,20,19),(6,33,20,20),(5,33,21,2),(6,33,21,12),(6,33,21,13),(6,33,21,14),(3,33,21,16),(3,33,21,17),(6,33,21,18),(6,33,21,19),(5,33,22,0),(5,33,22,1),(5,33,22,2),(6,33,22,11),(6,33,22,12),(6,33,22,13),(6,33,22,17),(5,33,23,2),(4,33,23,10),(6,33,23,11),(0,33,23,12),(6,33,23,17),(6,33,23,18),(4,33,24,9),(4,33,24,10),(4,33,24,11),(6,33,24,17),(6,33,24,18),(4,33,25,9),(4,33,25,10),(4,33,25,11),(4,33,25,13),(6,33,25,18),(10,33,26,1),(4,33,26,9),(4,33,26,11),(4,33,26,12),(4,33,26,13),(6,33,26,18),(6,33,26,19),(2,33,27,6),(4,33,27,9),(4,33,27,10),(4,33,27,11),(4,33,27,12),(4,33,27,13),(4,33,27,14),(4,33,27,15),(6,33,27,17),(6,33,27,18),(4,33,28,9),(4,33,28,11),(4,33,28,12),(4,33,28,13),(4,33,29,11),(4,33,29,13),(14,33,30,10),(0,33,31,16),(4,33,31,20),(4,33,32,14),(4,33,32,15),(4,33,32,18),(4,33,32,19),(4,33,32,20),(4,33,33,14),(4,33,33,15),(4,33,33,16),(4,33,33,17),(4,33,33,18),(4,33,33,19),(0,33,33,20),(4,33,34,12),(4,33,34,13),(4,33,34,14),(4,33,34,16),(4,33,34,17),(4,33,34,18),(4,33,34,19),(6,33,35,2),(6,33,35,3),(11,33,35,4),(4,33,35,15),(4,33,35,16),(4,33,35,17),(4,33,35,18),(4,33,35,19),(4,33,35,20),(6,33,36,1),(6,33,36,2),(6,33,36,3),(6,33,37,2),(6,33,37,3),(4,33,37,20),(4,33,37,21),(6,33,38,3),(4,33,38,19),(4,33,38,20),(4,33,38,21),(4,33,38,22),(4,33,38,23),(6,33,39,2),(6,33,39,3),(4,33,39,19),(4,33,39,20),(4,33,39,21),(4,33,39,24),(4,33,40,17),(4,33,40,18),(4,33,40,19),(4,33,40,20),(4,33,40,21),(4,33,40,22),(4,33,40,23),(4,33,40,24),(4,33,41,16),(4,33,41,17),(4,33,41,18),(4,33,41,20),(4,33,41,21),(4,33,41,23),(3,44,0,0),(3,44,0,1),(3,44,0,2),(3,44,0,3),(3,44,0,4),(5,44,0,5),(13,44,0,6),(14,44,0,10),(3,44,1,0),(3,44,1,1),(5,44,1,2),(5,44,1,3),(3,44,1,4),(5,44,1,5),(5,44,2,3),(5,44,2,4),(5,44,2,5),(5,44,3,3),(5,44,3,4),(5,44,3,5),(12,44,3,9),(5,44,4,3),(6,44,4,5),(5,44,5,1),(5,44,5,2),(6,44,5,5),(5,44,6,0),(5,44,6,1),(5,44,6,2),(6,44,6,3),(6,44,6,4),(6,44,6,5),(6,44,6,6),(6,44,6,7),(5,44,7,0),(5,44,7,1),(5,44,7,2),(5,44,7,3),(5,44,7,4),(6,44,7,5),(4,44,8,1),(4,44,8,2),(5,44,8,3),(6,44,8,5),(6,44,8,6),(6,44,8,7),(4,44,9,1),(4,44,9,2),(4,44,10,0),(4,44,10,1),(4,44,10,2),(4,44,11,1),(0,44,11,2),(4,44,12,1),(11,44,12,5),(4,44,13,1),(3,44,14,3),(3,44,14,4),(0,44,14,12),(5,44,15,2),(3,44,15,4),(5,44,16,2),(5,44,16,3),(3,44,16,4),(3,44,16,5),(5,44,17,0),(5,44,17,1),(5,44,17,2),(6,44,17,3),(3,44,17,4),(3,44,17,5),(1,44,17,6),(5,44,18,1),(6,44,18,3),(6,44,18,4),(3,44,18,5),(4,44,18,8),(0,44,18,12),(5,44,19,0),(5,44,19,1),(6,44,19,2),(6,44,19,3),(6,44,19,4),(6,44,19,5),(6,44,19,6),(4,44,19,7),(4,44,19,8),(4,44,19,9),(5,44,19,11),(5,44,20,0),(5,44,20,1),(3,44,20,2),(3,44,20,3),(6,44,20,4),(4,44,20,5),(4,44,20,6),(4,44,20,7),(5,44,20,10),(5,44,20,11),(5,44,20,12),(5,44,20,13),(5,44,20,14),(3,44,21,2),(3,44,21,3),(6,44,21,4),(4,44,21,7),(5,44,21,10),(5,44,21,11),(5,44,21,12),(5,44,21,13),(3,44,22,2),(6,44,22,4),(4,44,22,6),(4,44,22,7),(2,44,22,8),(5,44,22,12),(3,44,23,1),(3,44,23,2),(3,44,23,3),(13,44,26,1),(0,44,26,12),(12,44,28,5),(4,44,33,14),(6,44,34,10),(6,44,34,11),(4,44,34,12),(4,44,34,13),(4,44,34,14),(6,44,35,9),(6,44,35,10),(6,44,35,11),(3,44,35,12),(4,44,35,13),(4,44,35,14),(6,44,36,9),(6,44,36,10),(3,44,36,11),(3,44,36,12),(4,44,36,13),(4,44,36,14),(4,44,37,0),(4,44,37,1),(4,44,37,2),(6,44,37,8),(6,44,37,9),(6,44,37,10),(3,44,37,11),(3,44,37,12),(3,44,37,13),(4,44,37,14),(4,44,38,1),(4,44,38,2),(0,44,38,6),(6,44,38,8),(3,44,38,13),(4,44,38,14),(4,44,39,2),(3,44,39,13),(4,44,40,2),(4,44,40,3),(4,44,40,4),(11,44,40,9),(4,44,41,2),(4,44,41,3),(4,44,41,4),(3,44,41,8),(4,44,42,0),(4,44,42,1),(4,44,42,2),(4,44,42,3),(3,44,42,5),(3,44,42,7),(3,44,42,8),(4,44,43,0),(4,44,43,1),(4,44,43,2),(4,44,43,3),(3,44,43,5),(3,44,43,6),(3,44,43,7),(3,44,43,8),(0,47,0,0),(5,47,0,3),(5,47,0,4),(5,47,0,5),(5,47,0,6),(5,47,0,7),(5,47,0,8),(5,47,0,9),(5,47,0,10),(5,47,0,11),(5,47,0,12),(5,47,0,13),(5,47,0,14),(5,47,0,26),(5,47,0,27),(5,47,0,28),(5,47,0,29),(5,47,1,3),(11,47,1,4),(5,47,1,11),(5,47,1,12),(5,47,1,13),(13,47,1,16),(4,47,1,19),(4,47,1,20),(4,47,1,21),(4,47,1,22),(5,47,1,26),(5,47,1,27),(5,47,1,28),(5,47,1,29),(5,47,2,2),(5,47,2,3),(5,47,2,10),(5,47,2,12),(5,47,2,13),(5,47,2,14),(5,47,2,15),(4,47,2,20),(4,47,2,21),(4,47,2,22),(4,47,2,23),(5,47,2,27),(5,47,2,28),(5,47,2,29),(0,47,3,1),(5,47,3,10),(5,47,3,11),(5,47,3,12),(5,47,3,13),(5,47,3,14),(4,47,3,20),(4,47,3,21),(4,47,3,22),(4,47,3,23),(4,47,3,24),(5,47,3,28),(5,47,3,29),(5,47,4,12),(5,47,4,13),(6,47,4,18),(4,47,4,21),(4,47,4,22),(4,47,4,23),(5,47,4,26),(5,47,4,27),(5,47,4,28),(6,47,5,8),(6,47,5,9),(6,47,5,18),(6,47,5,19),(4,47,5,22),(4,47,5,23),(4,47,5,24),(5,47,5,26),(5,47,5,27),(6,47,6,7),(6,47,6,8),(6,47,6,9),(6,47,6,11),(6,47,6,18),(6,47,6,19),(6,47,7,9),(6,47,7,10),(6,47,7,18),(12,47,7,23),(6,47,8,9),(6,47,8,10),(6,47,8,16),(6,47,8,17),(6,47,8,18),(3,47,9,3),(3,47,9,4),(6,47,9,9),(6,47,9,15),(6,47,9,16),(6,47,9,17),(3,47,10,0),(3,47,10,2),(3,47,10,3),(3,47,10,4),(8,47,10,5),(6,47,10,16),(6,47,10,17),(0,47,10,20),(3,47,11,0),(3,47,11,1),(3,47,11,2),(3,47,11,3),(3,47,12,0),(3,47,12,1),(3,47,12,2),(3,47,13,0),(3,47,13,1),(3,47,13,2),(3,47,13,4),(3,47,14,0),(3,47,14,1),(3,47,14,2),(3,47,14,3),(3,47,14,4),(3,47,15,0),(3,47,15,1),(3,47,15,2),(3,47,15,3),(3,47,15,4),(3,47,16,0),(3,47,16,1),(3,47,16,2),(3,47,16,3),(5,47,16,29),(3,47,17,0),(3,47,17,1),(3,47,17,2),(3,47,17,3),(3,47,17,4),(5,47,17,28),(5,47,17,29),(3,47,18,0),(3,47,18,1),(3,47,18,2),(3,47,18,3),(3,47,18,4),(3,47,18,5),(0,47,18,23),(5,47,18,28),(5,47,18,29),(3,47,19,0),(3,47,19,1),(3,47,19,2),(3,47,19,3),(3,47,19,4),(3,47,19,5),(5,47,19,29),(3,47,20,0),(3,47,20,1),(3,47,20,2),(3,47,20,3),(3,47,20,4),(3,47,20,5),(5,47,20,28),(5,47,20,29),(3,47,21,0),(3,47,21,1),(3,47,21,2),(3,47,21,3),(3,47,21,4),(5,47,21,29),(3,47,22,0),(3,47,22,1),(3,47,22,2),(14,47,22,25),(5,47,22,29),(3,47,23,0),(3,47,23,1),(3,47,23,2),(3,47,23,3),(4,47,23,9),(5,47,23,29),(3,47,24,1),(3,47,24,2),(0,47,24,4),(4,47,24,7),(4,47,24,8),(4,47,24,9),(4,47,24,10),(4,47,24,11),(5,47,24,29),(4,47,25,7),(4,47,25,8),(4,47,25,9),(4,47,25,10),(5,47,25,27),(5,47,25,29),(4,47,26,6),(4,47,26,7),(4,47,26,8),(4,47,26,9),(4,47,26,10),(2,47,26,12),(6,47,26,22),(6,47,26,23),(5,47,26,27),(5,47,26,28),(5,47,26,29),(4,47,27,5),(4,47,27,6),(4,47,27,7),(4,47,27,8),(4,47,27,9),(4,47,27,10),(5,47,27,17),(5,47,27,18),(5,47,27,21),(5,47,27,22),(6,47,27,23),(6,47,27,24),(0,47,28,4),(4,47,28,6),(4,47,28,7),(4,47,28,8),(4,47,28,9),(4,47,28,10),(5,47,28,15),(5,47,28,16),(5,47,28,17),(5,47,28,18),(5,47,28,19),(5,47,28,21),(5,47,28,22),(6,47,28,23),(6,47,28,24),(5,47,28,25),(5,47,28,26),(5,47,28,27),(5,47,28,28),(4,47,29,7),(4,47,29,8),(4,47,29,9),(4,47,29,10),(4,47,29,11),(5,47,29,16),(5,47,29,17),(5,47,29,18),(5,47,29,19),(5,47,29,20),(5,47,29,21),(5,47,29,22),(6,47,29,23),(6,47,29,24),(6,47,29,25),(6,47,29,26),(5,47,29,27),(4,52,0,9),(4,52,0,10),(4,52,0,11),(3,52,0,12),(3,52,0,13),(3,52,0,14),(3,52,0,16),(3,52,0,17),(3,52,0,18),(3,52,0,19),(3,52,0,20),(9,52,0,21),(6,52,0,36),(6,52,0,37),(10,52,0,40),(4,52,0,49),(4,52,0,50),(4,52,0,51),(4,52,0,52),(13,52,1,1),(4,52,1,7),(4,52,1,8),(4,52,1,9),(4,52,1,10),(3,52,1,11),(3,52,1,12),(3,52,1,13),(8,52,1,16),(3,52,1,19),(3,52,1,20),(6,52,1,35),(6,52,1,36),(4,52,1,48),(4,52,1,49),(0,52,1,50),(4,52,1,52),(10,52,2,4),(4,52,2,8),(4,52,2,9),(4,52,2,10),(4,52,2,11),(4,52,2,12),(3,52,2,13),(3,52,2,19),(3,52,2,20),(6,52,2,34),(6,52,2,35),(6,52,2,36),(6,52,2,37),(6,52,2,38),(4,52,2,45),(4,52,2,46),(4,52,2,47),(4,52,2,48),(3,52,3,13),(3,52,3,14),(3,52,3,19),(6,52,3,35),(6,52,3,36),(6,52,3,37),(4,52,3,46),(0,52,4,10),(3,52,4,13),(6,52,4,14),(8,52,4,15),(3,52,4,18),(11,52,4,19),(3,52,4,48),(3,52,4,49),(5,52,5,3),(6,52,5,12),(6,52,5,13),(6,52,5,14),(3,52,5,18),(5,52,5,33),(5,52,5,38),(5,52,5,39),(3,52,5,47),(3,52,5,48),(5,52,6,3),(6,52,6,9),(6,52,6,10),(6,52,6,12),(6,52,6,13),(3,52,6,18),(5,52,6,31),(5,52,6,33),(5,52,6,38),(5,52,6,39),(5,52,6,40),(4,52,6,43),(4,52,6,44),(3,52,6,47),(3,52,6,48),(5,52,7,1),(5,52,7,2),(5,52,7,3),(6,52,7,10),(6,52,7,11),(6,52,7,12),(6,52,7,13),(13,52,7,17),(5,52,7,31),(5,52,7,32),(5,52,7,33),(5,52,7,34),(5,52,7,35),(5,52,7,36),(5,52,7,37),(5,52,7,38),(4,52,7,43),(0,52,7,45),(3,52,7,48),(0,52,7,49),(5,52,8,0),(5,52,8,1),(5,52,8,2),(5,52,8,3),(5,52,8,4),(9,52,8,10),(5,52,8,28),(5,52,8,29),(5,52,8,30),(5,52,8,31),(5,52,8,32),(5,52,8,33),(5,52,8,34),(5,52,8,35),(5,52,8,36),(5,52,8,37),(5,52,8,38),(5,52,8,39),(4,52,8,43),(3,52,8,47),(3,52,8,48),(5,52,9,0),(5,52,9,1),(5,52,9,2),(5,52,9,3),(5,52,9,4),(14,52,9,21),(2,52,9,26),(5,52,9,28),(3,52,9,29),(5,52,9,31),(0,52,9,32),(5,52,9,34),(5,52,9,35),(5,52,9,36),(5,52,9,38),(4,52,9,39),(4,52,9,40),(4,52,9,41),(4,52,9,42),(4,52,9,43),(4,52,9,44),(4,52,9,45),(3,52,9,48),(5,52,10,0),(5,52,10,1),(5,52,10,2),(4,52,10,3),(4,52,10,4),(3,52,10,28),(3,52,10,29),(5,52,10,31),(5,52,10,34),(5,52,10,35),(4,52,10,39),(3,52,10,40),(0,52,10,41),(5,52,11,0),(0,52,11,1),(4,52,11,3),(4,52,11,4),(4,52,11,5),(0,52,11,7),(3,52,11,26),(3,52,11,27),(3,52,11,28),(3,52,11,29),(5,52,11,32),(5,52,11,33),(5,52,11,34),(5,52,11,35),(3,52,11,38),(3,52,11,39),(3,52,11,40),(2,52,11,46),(1,52,11,50),(4,52,12,3),(4,52,12,4),(4,52,12,5),(4,52,12,6),(6,52,12,21),(6,52,12,22),(6,52,12,23),(6,52,12,24),(3,52,12,26),(3,52,12,27),(3,52,12,28),(5,52,12,32),(5,52,12,33),(5,52,12,34),(5,52,12,35),(5,52,12,36),(5,52,12,37),(5,52,12,38),(3,52,12,39),(3,52,12,40),(3,52,12,41),(3,52,12,42),(4,52,13,3),(4,52,13,4),(4,52,13,6),(6,52,13,21),(6,52,13,22),(6,52,13,23),(6,52,13,24),(6,52,13,25),(6,52,13,26),(6,52,13,27),(6,52,13,28),(5,52,13,31),(5,52,13,32),(5,52,13,33),(5,52,13,34),(5,52,13,35),(5,52,13,36),(5,52,13,37),(5,52,13,38),(5,52,13,39),(3,52,13,40),(3,52,13,41);
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
) ENGINE=InnoDB AUTO_INCREMENT=475 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `units`
--

LOCK TABLES `units` WRITE;
/*!40000 ALTER TABLE `units` DISABLE KEYS */;
INSERT INTO `units` VALUES (1,26875,1,1,1,NULL,NULL,NULL,NULL,0,0,'Demosis',0,3,134,NULL,1,0,0,0,0,0,0),(2,26875,1,1,1,NULL,NULL,NULL,NULL,0,0,'Demosis',0,3,134,NULL,1,0,0,0,0,0,0),(3,4475,1,1,1,NULL,NULL,NULL,NULL,0,0,'Thor',0,3,134,NULL,1,0,0,0,0,0,0),(4,2812,1,1,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,3,134,NULL,1,0,0,0,0,0,0),(5,2812,1,1,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,3,134,NULL,1,0,0,0,0,0,0),(6,2812,1,1,1,NULL,NULL,NULL,NULL,0,0,'Dirac',0,3,134,NULL,1,0,0,0,0,0,0),(7,26875,1,1,1,NULL,NULL,NULL,NULL,0,0,'Demosis',0,1,315,NULL,1,0,0,0,0,0,0),(8,2812,1,1,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,1,315,NULL,1,0,0,0,0,0,0),(9,2812,1,1,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,1,315,NULL,1,0,0,0,0,0,0),(10,2812,1,1,1,NULL,NULL,NULL,NULL,0,0,'Dirac',0,1,315,NULL,1,0,0,0,0,0,0),(11,90,1,1,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(12,125,1,1,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(13,125,1,1,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(14,90,1,2,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(15,125,1,2,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(16,125,1,2,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(17,90,1,3,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(18,125,1,3,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(19,90,1,3,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(20,125,1,3,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(21,125,1,3,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(22,90,1,4,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(23,125,1,4,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(24,90,1,4,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(25,125,1,4,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(26,125,1,4,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(27,125,1,4,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(28,125,1,5,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(29,125,1,5,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(30,125,1,6,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(31,125,1,6,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(32,125,1,7,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(33,125,1,7,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(34,125,1,8,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(35,125,1,8,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(36,2812,1,1,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,1,135,NULL,1,0,0,0,0,0,0),(37,2812,1,1,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,1,135,NULL,1,0,0,0,0,0,0),(38,2812,1,1,1,NULL,NULL,NULL,NULL,0,0,'Dirac',0,1,135,NULL,1,0,0,0,0,0,0),(39,26875,1,1,1,NULL,NULL,NULL,NULL,0,0,'Demosis',0,2,330,NULL,1,0,0,0,0,0,0),(40,4475,1,1,1,NULL,NULL,NULL,NULL,0,0,'Thor',0,2,330,NULL,1,0,0,0,0,0,0),(41,2812,1,1,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,2,330,NULL,1,0,0,0,0,0,0),(42,2812,1,1,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,2,330,NULL,1,0,0,0,0,0,0),(43,2812,1,1,1,NULL,NULL,NULL,NULL,0,0,'Dirac',0,2,330,NULL,1,0,0,0,0,0,0),(44,90,1,9,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(45,125,1,9,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(46,125,1,9,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(47,125,1,10,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(48,125,1,10,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(49,90,1,11,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(50,125,1,11,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(51,90,1,11,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(52,125,1,11,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(53,125,1,11,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(54,90,1,12,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(55,125,1,12,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(56,90,1,12,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(57,125,1,12,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(58,125,1,12,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(59,125,1,13,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(60,125,1,13,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(61,125,1,13,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(62,125,1,13,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(63,90,1,14,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(64,125,1,14,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(65,90,1,14,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(66,125,1,14,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(67,90,1,14,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(68,125,1,14,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(69,125,1,14,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(70,125,1,15,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(71,125,1,15,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(72,125,1,16,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(73,125,1,17,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(74,125,1,17,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(75,125,1,18,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(76,90,1,19,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(77,125,1,19,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(78,90,1,20,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(79,125,1,20,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(80,125,1,20,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(81,90,1,21,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(82,125,1,21,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(83,125,1,21,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(84,90,1,22,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(85,125,1,22,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(86,125,1,22,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(87,90,1,23,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(88,125,1,23,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(89,125,1,24,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(90,90,1,24,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(91,90,1,24,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(92,125,1,24,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(93,125,1,24,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(94,90,1,25,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(95,125,1,25,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(96,90,1,25,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(97,125,1,25,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(98,90,1,25,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(99,125,1,25,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(100,125,1,25,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(101,90,1,26,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(102,125,1,26,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(103,125,1,26,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(104,125,1,27,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(105,90,1,27,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(106,125,1,27,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(107,125,1,27,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(108,90,1,28,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(109,125,1,28,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(110,125,1,28,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(111,125,1,29,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(112,125,1,29,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(113,125,1,30,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(114,125,1,30,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(115,125,1,31,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(116,26875,1,1,1,NULL,NULL,NULL,NULL,0,0,'Demosis',0,0,0,NULL,1,0,0,0,0,0,0),(117,2812,1,1,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,0,0,NULL,1,0,0,0,0,0,0),(118,2812,1,1,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,0,0,NULL,1,0,0,0,0,0,0),(119,2812,1,1,1,NULL,NULL,NULL,NULL,0,0,'Dirac',0,0,0,NULL,1,0,0,0,0,0,0),(120,125,1,32,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(121,90,1,33,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(122,125,1,33,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(123,125,1,33,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(124,90,1,34,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(125,125,1,34,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(126,90,1,34,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(127,125,1,34,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(128,90,1,34,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(129,125,1,34,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(130,125,1,34,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(131,125,1,35,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(132,90,1,35,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(133,90,1,35,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(134,125,1,35,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(135,90,1,35,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(136,125,1,35,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(137,125,1,35,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(138,125,1,36,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(139,90,1,36,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(140,125,1,36,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(141,125,1,36,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(142,90,1,36,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(143,125,1,36,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(144,125,1,36,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(145,90,1,37,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(146,125,1,37,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(147,90,1,38,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(148,125,1,38,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(149,125,1,38,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(150,125,1,39,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(151,125,1,39,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(152,125,1,40,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(153,125,1,40,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(154,125,1,41,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(155,125,1,41,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(156,125,1,42,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(157,125,1,42,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(158,26875,1,2,1,NULL,NULL,NULL,NULL,0,0,'Demosis',0,3,22,NULL,1,0,0,0,0,0,0),(159,26875,1,2,1,NULL,NULL,NULL,NULL,0,0,'Demosis',0,3,22,NULL,1,0,0,0,0,0,0),(160,2812,1,2,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,3,22,NULL,1,0,0,0,0,0,0),(161,2812,1,2,1,NULL,NULL,NULL,NULL,0,0,'Dirac',0,3,22,NULL,1,0,0,0,0,0,0),(162,90,1,43,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(163,125,1,43,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(164,90,1,44,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(165,125,1,44,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(166,125,1,44,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(167,90,1,45,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(168,125,1,45,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(169,125,1,45,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(170,90,1,46,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(171,125,1,46,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(172,90,1,46,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(173,125,1,46,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(174,125,1,46,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(175,125,1,47,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(176,90,1,47,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(177,125,1,47,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(178,90,1,48,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(179,125,1,48,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(180,90,1,48,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(181,125,1,48,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(182,90,1,48,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(183,125,1,48,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(184,125,1,48,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(185,90,1,49,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(186,125,1,49,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(187,90,1,49,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(188,125,1,49,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(189,90,1,49,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(190,125,1,49,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(191,125,1,49,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(192,125,1,50,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(193,90,1,50,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(194,125,1,50,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(195,90,1,50,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(196,125,1,50,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(197,90,1,50,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(198,125,1,50,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(199,125,1,50,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(200,90,1,51,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(201,125,1,51,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(202,125,1,51,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(203,125,1,52,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(204,90,1,52,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(205,125,1,52,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(206,90,1,52,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(207,125,1,52,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(208,90,1,52,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(209,125,1,52,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(210,125,1,52,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(211,125,1,53,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(212,90,1,53,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(213,125,1,53,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(214,125,1,53,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(215,125,1,53,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(216,125,1,54,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(217,90,1,54,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(218,125,1,54,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(219,90,1,55,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(220,125,1,55,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(221,125,1,55,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(222,125,1,56,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(223,125,1,56,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(224,125,1,57,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(225,125,1,57,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(226,125,1,58,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(227,125,1,58,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(228,26875,1,2,1,NULL,NULL,NULL,NULL,0,0,'Demosis',0,3,224,NULL,1,0,0,0,0,0,0),(229,4475,1,2,1,NULL,NULL,NULL,NULL,0,0,'Thor',0,3,224,NULL,1,0,0,0,0,0,0),(230,2812,1,2,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,3,224,NULL,1,0,0,0,0,0,0),(231,2812,1,2,1,NULL,NULL,NULL,NULL,0,0,'Dirac',0,3,224,NULL,1,0,0,0,0,0,0),(232,125,1,59,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(233,125,1,59,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(234,125,1,60,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(235,125,1,60,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(236,125,1,61,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(237,125,1,61,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(238,125,1,61,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(239,90,1,62,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(240,125,1,62,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(241,90,1,62,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(242,125,1,62,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(243,90,1,63,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(244,125,1,63,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(245,90,1,63,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(246,125,1,63,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(247,90,1,63,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(248,125,1,63,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(249,125,1,63,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(250,90,1,64,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(251,125,1,64,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(252,90,1,64,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(253,125,1,64,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(254,90,1,64,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(255,125,1,64,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(256,125,1,65,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(257,90,1,65,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(258,125,1,65,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(259,90,1,65,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(260,125,1,65,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(261,90,1,65,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(262,125,1,65,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(263,125,1,65,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(264,125,1,66,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(265,90,1,66,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(266,125,1,66,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(267,90,1,66,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(268,125,1,66,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(269,90,1,66,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(270,125,1,66,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(271,125,1,66,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(272,90,1,67,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(273,125,1,67,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(274,125,1,67,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(275,125,1,68,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(276,125,1,68,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(277,125,1,69,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(278,125,1,69,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(279,125,1,70,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(280,125,1,70,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(281,125,1,71,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(282,125,1,71,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(283,26875,1,3,1,NULL,NULL,NULL,NULL,0,0,'Demosis',0,2,120,NULL,1,0,0,0,0,0,0),(284,4475,1,3,1,NULL,NULL,NULL,NULL,0,0,'Thor',1,2,120,NULL,1,0,0,0,0,0,0),(285,2812,1,3,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,2,120,NULL,1,0,0,0,0,0,0),(286,2812,1,3,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,2,120,NULL,1,0,0,0,0,0,0),(287,2812,1,3,1,NULL,NULL,NULL,NULL,0,0,'Dirac',0,2,120,NULL,1,0,0,0,0,0,0),(288,26875,1,3,1,NULL,NULL,NULL,NULL,0,0,'Demosis',0,3,22,NULL,1,0,0,0,0,0,0),(289,26875,1,3,1,NULL,NULL,NULL,NULL,0,0,'Demosis',0,3,22,NULL,1,0,0,0,0,0,0),(290,26875,1,3,1,NULL,NULL,NULL,NULL,0,0,'Demosis',0,3,22,NULL,1,0,0,0,0,0,0),(291,2812,1,3,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,3,22,NULL,1,0,0,0,0,0,0),(292,2812,1,3,1,NULL,NULL,NULL,NULL,0,0,'Dirac',0,3,22,NULL,1,0,0,0,0,0,0),(293,26875,1,3,1,NULL,NULL,NULL,NULL,0,0,'Demosis',0,0,90,NULL,1,0,0,0,0,0,0),(294,26875,1,3,1,NULL,NULL,NULL,NULL,0,0,'Demosis',0,0,90,NULL,1,0,0,0,0,0,0),(295,4475,1,3,1,NULL,NULL,NULL,NULL,0,0,'Thor',1,0,90,NULL,1,0,0,0,0,0,0),(296,2812,1,3,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,0,90,NULL,1,0,0,0,0,0,0),(297,2812,1,3,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,0,90,NULL,1,0,0,0,0,0,0),(298,2812,1,3,1,NULL,NULL,NULL,NULL,0,0,'Dirac',0,0,90,NULL,1,0,0,0,0,0,0),(299,4475,1,3,1,NULL,NULL,NULL,NULL,0,0,'Thor',1,0,270,NULL,1,0,0,0,0,0,0),(300,2812,1,3,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,0,270,NULL,1,0,0,0,0,0,0),(301,2812,1,3,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,0,270,NULL,1,0,0,0,0,0,0),(302,2812,1,3,1,NULL,NULL,NULL,NULL,0,0,'Dirac',0,0,270,NULL,1,0,0,0,0,0,0),(303,90,1,72,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(304,125,1,72,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(305,125,1,72,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(306,125,1,73,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(307,125,1,73,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(308,90,1,74,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(309,125,1,74,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(310,125,1,74,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(311,90,1,75,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(312,125,1,75,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(313,90,1,75,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(314,125,1,75,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(315,125,1,75,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(316,90,1,76,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(317,125,1,76,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(318,90,1,76,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(319,125,1,76,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(320,90,1,76,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(321,125,1,76,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(322,125,1,76,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(323,125,1,77,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(324,125,1,77,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(325,125,1,78,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(326,125,1,78,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(327,26875,1,3,1,NULL,NULL,NULL,NULL,0,0,'Demosis',0,2,300,NULL,1,0,0,0,0,0,0),(328,4475,1,3,1,NULL,NULL,NULL,NULL,0,0,'Thor',1,2,300,NULL,1,0,0,0,0,0,0),(329,2812,1,3,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,2,300,NULL,1,0,0,0,0,0,0),(330,2812,1,3,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,2,300,NULL,1,0,0,0,0,0,0),(331,2812,1,3,1,NULL,NULL,NULL,NULL,0,0,'Dirac',0,2,300,NULL,1,0,0,0,0,0,0),(332,90,1,79,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(333,125,1,79,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(334,125,1,79,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(335,90,1,79,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(336,125,1,79,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(337,125,1,79,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(338,125,1,79,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(339,125,1,79,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(340,90,1,80,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(341,125,1,80,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(342,90,1,80,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(343,125,1,80,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(344,125,1,80,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(345,125,1,80,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(346,125,1,80,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(347,125,1,81,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(348,125,1,81,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(349,125,1,81,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(350,125,1,81,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(351,125,1,81,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(352,125,1,81,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(353,90,1,82,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(354,125,1,82,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(355,125,1,82,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(356,90,1,82,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(357,125,1,82,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(358,125,1,82,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(359,125,1,82,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(360,125,1,82,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(361,125,1,83,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(362,125,1,83,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(363,125,1,83,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(364,125,1,83,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(365,125,1,83,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(366,125,1,83,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(367,125,1,84,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(368,125,1,84,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(369,125,1,84,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(370,125,1,84,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(371,125,1,84,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(372,125,1,84,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(373,125,1,85,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(374,90,1,85,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(375,125,1,85,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(376,125,1,85,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(377,125,1,85,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(378,125,1,85,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(379,125,1,86,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(380,125,1,86,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(381,125,1,86,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(382,125,1,86,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(383,125,1,86,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(384,125,1,86,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(385,125,1,87,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(386,125,1,87,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(387,125,1,87,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(388,125,1,87,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(389,125,1,87,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(390,125,1,87,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(391,90,1,88,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(392,125,1,88,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(393,125,1,88,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(394,90,1,88,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(395,125,1,88,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(396,125,1,88,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(397,125,1,88,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(398,125,1,88,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(399,90,1,89,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(400,125,1,89,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(401,125,1,89,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(402,90,1,89,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(403,125,1,89,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(404,125,1,89,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(405,125,1,89,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(406,125,1,89,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(407,90,1,93,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(408,125,1,93,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(409,125,1,93,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(410,125,1,93,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(411,90,1,93,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(412,125,1,93,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(413,125,1,93,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(414,125,1,93,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(415,125,1,93,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(416,90,1,97,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(417,125,1,97,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(418,90,1,97,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(419,125,1,97,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(420,90,1,97,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(421,125,1,97,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(422,125,1,97,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(423,90,1,97,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(424,125,1,97,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(425,90,1,97,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(426,125,1,97,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(427,90,1,97,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(428,125,1,97,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(429,125,1,97,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(430,125,1,97,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(431,125,1,97,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(432,4475,1,4,1,NULL,NULL,NULL,NULL,0,0,'Thor',0,3,224,NULL,1,0,0,0,0,0,0),(433,4475,1,4,1,NULL,NULL,NULL,NULL,0,0,'Thor',1,3,224,NULL,1,0,0,0,0,0,0),(434,2812,1,4,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,3,224,NULL,1,0,0,0,0,0,0),(435,2812,1,4,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,3,224,NULL,1,0,0,0,0,0,0),(436,2812,1,4,1,NULL,NULL,NULL,NULL,0,0,'Dirac',0,3,224,NULL,1,0,0,0,0,0,0),(437,26875,1,4,1,NULL,NULL,NULL,NULL,0,0,'Demosis',0,0,180,NULL,1,0,0,0,0,0,0),(438,4475,1,4,1,NULL,NULL,NULL,NULL,0,0,'Thor',0,0,180,NULL,1,0,0,0,0,0,0),(439,4475,1,4,1,NULL,NULL,NULL,NULL,0,0,'Thor',1,0,180,NULL,1,0,0,0,0,0,0),(440,2812,1,4,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,0,180,NULL,1,0,0,0,0,0,0),(441,2812,1,4,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,0,180,NULL,1,0,0,0,0,0,0),(442,2812,1,4,1,NULL,NULL,NULL,NULL,0,0,'Dirac',0,0,180,NULL,1,0,0,0,0,0,0),(443,90,1,101,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(444,125,1,101,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(445,125,1,101,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(446,90,1,102,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(447,125,1,102,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(448,125,1,102,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(449,90,1,103,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(450,125,1,103,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(451,125,1,103,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(452,125,1,104,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(453,90,1,104,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(454,125,1,104,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(455,125,1,104,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(456,90,1,105,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(457,125,1,105,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(458,125,1,105,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(459,90,1,105,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(460,125,1,105,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(461,125,1,105,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(462,90,1,106,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(463,125,1,106,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(464,90,1,106,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(465,90,1,106,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(466,125,1,106,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(467,125,1,106,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(468,90,1,107,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0,0,0,0),(469,125,1,107,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(470,125,1,107,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(471,125,1,108,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(472,125,1,109,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(473,125,1,109,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0),(474,125,1,110,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0,0,0,0);
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

-- Dump completed on 2011-01-03 15:25:44
