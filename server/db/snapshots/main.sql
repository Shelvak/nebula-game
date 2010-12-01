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
INSERT INTO `buildings` VALUES (1,6,11,43,0,0,0,1,'NpcMetalExtractor',NULL,12,44,NULL,1,400,NULL,0,NULL,NULL,0),(2,6,6,48,0,0,0,1,'NpcMetalExtractor',NULL,7,49,NULL,1,400,NULL,0,NULL,NULL,0),(3,6,1,48,0,0,0,1,'NpcMetalExtractor',NULL,2,49,NULL,1,400,NULL,0,NULL,NULL,0),(4,6,1,8,0,0,0,1,'NpcMetalExtractor',NULL,2,9,NULL,1,400,NULL,0,NULL,NULL,0),(5,6,2,3,0,0,0,1,'NpcMetalExtractor',NULL,3,4,NULL,1,400,NULL,0,NULL,NULL,0),(6,6,7,4,0,0,0,1,'NpcGeothermalPlant',NULL,8,5,NULL,1,600,NULL,0,NULL,NULL,0),(7,6,11,2,0,0,0,1,'NpcZetiumExtractor',NULL,12,3,NULL,1,800,NULL,0,NULL,NULL,0),(8,6,5,0,0,0,0,1,'NpcTemple',NULL,7,2,NULL,1,1500,NULL,0,NULL,NULL,0),(9,6,2,0,0,0,0,1,'NpcCommunicationsHub',NULL,4,1,NULL,1,1200,NULL,0,NULL,NULL,0),(10,6,0,0,0,0,0,1,'NpcSolarPlant',NULL,1,1,NULL,1,1000,NULL,0,NULL,NULL,0),(11,6,8,0,0,0,0,1,'NpcSolarPlant',NULL,9,1,NULL,1,1000,NULL,0,NULL,NULL,0),(12,8,0,0,0,0,0,1,'NpcMetalExtractor',NULL,1,1,NULL,1,400,NULL,0,NULL,NULL,0),(13,8,7,0,0,0,0,1,'NpcCommunicationsHub',NULL,9,1,NULL,1,1200,NULL,0,NULL,NULL,0),(14,8,18,0,0,0,0,1,'NpcSolarPlant',NULL,19,1,NULL,1,1000,NULL,0,NULL,NULL,0),(15,8,3,1,0,0,0,1,'NpcMetalExtractor',NULL,4,2,NULL,1,400,NULL,0,NULL,NULL,0),(16,8,12,1,0,0,0,1,'NpcSolarPlant',NULL,13,2,NULL,1,1000,NULL,0,NULL,NULL,0),(17,8,22,1,0,0,0,1,'NpcSolarPlant',NULL,23,2,NULL,1,1000,NULL,0,NULL,NULL,0),(18,8,26,1,0,0,0,1,'NpcCommunicationsHub',NULL,28,2,NULL,1,1200,NULL,0,NULL,NULL,0),(19,8,15,3,0,0,0,1,'NpcSolarPlant',NULL,16,4,NULL,1,1000,NULL,0,NULL,NULL,0),(20,8,18,3,0,0,0,1,'NpcSolarPlant',NULL,19,4,NULL,1,1000,NULL,0,NULL,NULL,0),(21,8,24,4,0,0,0,1,'NpcMetalExtractor',NULL,25,5,NULL,1,400,NULL,0,NULL,NULL,0),(22,8,28,4,0,0,0,1,'NpcMetalExtractor',NULL,29,5,NULL,1,400,NULL,0,NULL,NULL,0),(23,8,7,6,0,0,0,1,'Screamer',NULL,8,7,NULL,1,1700,NULL,0,NULL,NULL,0),(24,8,21,6,0,0,0,1,'Vulcan',NULL,22,7,NULL,1,1400,NULL,0,NULL,NULL,0),(25,8,14,7,0,0,0,1,'Thunder',NULL,15,8,NULL,1,2400,NULL,0,NULL,NULL,0),(26,8,25,7,0,0,0,1,'NpcTemple',NULL,27,9,NULL,1,1500,NULL,0,NULL,NULL,0),(27,8,11,10,0,0,0,1,'Mothership',NULL,18,15,NULL,1,10500,NULL,0,NULL,NULL,0),(28,8,7,12,0,0,0,1,'Thunder',NULL,8,13,NULL,1,2400,NULL,0,NULL,NULL,0),(29,8,21,12,0,0,0,1,'Thunder',NULL,22,13,NULL,1,2400,NULL,0,NULL,NULL,0),(30,8,26,12,0,0,0,1,'NpcZetiumExtractor',NULL,27,13,NULL,1,800,NULL,0,NULL,NULL,0),(31,8,7,19,0,0,0,1,'Vulcan',NULL,8,20,NULL,1,1400,NULL,0,NULL,NULL,0),(32,8,14,19,0,0,0,1,'Thunder',NULL,15,20,NULL,1,2400,NULL,0,NULL,NULL,0),(33,8,21,19,0,0,0,1,'Screamer',NULL,22,20,NULL,1,1700,NULL,0,NULL,NULL,0),(34,10,6,2,0,0,0,1,'NpcMetalExtractor',NULL,7,3,NULL,1,400,NULL,0,NULL,NULL,0),(35,10,2,1,0,0,0,1,'NpcMetalExtractor',NULL,3,2,NULL,1,400,NULL,0,NULL,NULL,0),(36,10,8,8,0,0,0,1,'NpcMetalExtractor',NULL,9,9,NULL,1,400,NULL,0,NULL,NULL,0),(37,10,18,8,0,0,0,1,'NpcGeothermalPlant',NULL,19,9,NULL,1,600,NULL,0,NULL,NULL,0),(38,10,24,8,0,0,0,1,'NpcGeothermalPlant',NULL,25,9,NULL,1,600,NULL,0,NULL,NULL,0),(39,10,24,3,0,0,0,1,'NpcZetiumExtractor',NULL,25,4,NULL,1,800,NULL,0,NULL,NULL,0),(40,10,6,5,0,0,0,1,'NpcCommunicationsHub',NULL,8,6,NULL,1,1200,NULL,0,NULL,NULL,0),(41,10,21,9,0,0,0,1,'NpcSolarPlant',NULL,22,10,NULL,1,1000,NULL,0,NULL,NULL,0),(42,10,21,7,0,0,0,1,'NpcSolarPlant',NULL,22,8,NULL,1,1000,NULL,0,NULL,NULL,0),(43,10,15,9,0,0,0,1,'NpcSolarPlant',NULL,16,10,NULL,1,1000,NULL,0,NULL,NULL,0),(44,10,15,7,0,0,0,1,'NpcSolarPlant',NULL,16,8,NULL,1,1000,NULL,0,NULL,NULL,0),(45,19,6,10,0,0,0,1,'NpcMetalExtractor',NULL,7,11,NULL,1,400,NULL,0,NULL,NULL,0),(46,19,6,4,0,0,0,1,'NpcMetalExtractor',NULL,7,5,NULL,1,400,NULL,0,NULL,NULL,0),(47,19,1,1,0,0,0,1,'NpcMetalExtractor',NULL,2,2,NULL,1,400,NULL,0,NULL,NULL,0),(48,19,10,5,0,0,0,1,'NpcGeothermalPlant',NULL,11,6,NULL,1,600,NULL,0,NULL,NULL,0),(49,19,10,1,0,0,0,1,'NpcZetiumExtractor',NULL,11,2,NULL,1,800,NULL,0,NULL,NULL,0),(50,19,0,15,0,0,0,1,'NpcResearchCenter',NULL,3,18,NULL,1,4000,NULL,0,NULL,NULL,0),(51,19,1,11,0,0,0,1,'NpcExcavationSite',NULL,4,14,NULL,1,2000,NULL,0,NULL,NULL,0),(52,19,6,0,0,0,0,1,'NpcTemple',NULL,8,2,NULL,1,1500,NULL,0,NULL,NULL,0),(53,19,2,9,0,0,0,1,'NpcCommunicationsHub',NULL,4,10,NULL,1,1200,NULL,0,NULL,NULL,0),(54,19,0,9,0,0,0,1,'NpcSolarPlant',NULL,1,10,NULL,1,1000,NULL,0,NULL,NULL,0),(55,19,4,1,0,0,0,1,'NpcSolarPlant',NULL,5,2,NULL,1,1000,NULL,0,NULL,NULL,0),(56,19,5,7,0,0,0,1,'NpcSolarPlant',NULL,6,8,NULL,1,1000,NULL,0,NULL,NULL,0),(57,30,5,8,0,0,0,1,'NpcMetalExtractor',NULL,6,9,NULL,1,400,NULL,0,NULL,NULL,0),(58,30,1,7,0,0,0,1,'NpcMetalExtractor',NULL,2,8,NULL,1,400,NULL,0,NULL,NULL,0),(59,30,1,3,0,0,0,1,'NpcMetalExtractor',NULL,2,4,NULL,1,400,NULL,0,NULL,NULL,0),(60,30,48,2,0,0,0,1,'NpcMetalExtractor',NULL,49,3,NULL,1,400,NULL,0,NULL,NULL,0),(61,30,7,1,0,0,0,1,'NpcMetalExtractor',NULL,8,2,NULL,1,400,NULL,0,NULL,NULL,0),(62,30,11,3,0,0,0,1,'NpcMetalExtractor',NULL,12,4,NULL,1,400,NULL,0,NULL,NULL,0),(63,30,12,8,0,0,0,1,'NpcGeothermalPlant',NULL,13,9,NULL,1,600,NULL,0,NULL,NULL,0),(64,30,9,12,0,0,0,1,'NpcZetiumExtractor',NULL,10,13,NULL,1,800,NULL,0,NULL,NULL,0),(65,30,5,12,0,0,0,1,'NpcZetiumExtractor',NULL,6,13,NULL,1,800,NULL,0,NULL,NULL,0),(66,30,36,1,0,0,0,1,'NpcResearchCenter',NULL,39,4,NULL,1,4000,NULL,0,NULL,NULL,0),(67,30,40,2,0,0,0,1,'NpcExcavationSite',NULL,43,5,NULL,1,2000,NULL,0,NULL,NULL,0),(68,30,1,14,0,0,0,1,'NpcTemple',NULL,3,16,NULL,1,1500,NULL,0,NULL,NULL,0),(69,30,44,5,0,0,0,1,'NpcCommunicationsHub',NULL,46,6,NULL,1,1200,NULL,0,NULL,NULL,0),(70,30,14,5,0,0,0,1,'NpcSolarPlant',NULL,15,6,NULL,1,1000,NULL,0,NULL,NULL,0),(71,30,8,15,0,0,0,1,'NpcSolarPlant',NULL,9,16,NULL,1,1000,NULL,0,NULL,NULL,0),(72,30,4,0,0,0,0,1,'NpcSolarPlant',NULL,5,1,NULL,1,1000,NULL,0,NULL,NULL,0),(73,30,10,15,0,0,0,1,'NpcSolarPlant',NULL,11,16,NULL,1,1000,NULL,0,NULL,NULL,0),(74,31,1,1,0,0,0,1,'NpcMetalExtractor',NULL,2,2,NULL,1,400,NULL,0,NULL,NULL,0),(75,31,1,5,0,0,0,1,'NpcMetalExtractor',NULL,2,6,NULL,1,400,NULL,0,NULL,NULL,0),(76,31,1,15,0,0,0,1,'NpcMetalExtractor',NULL,2,16,NULL,1,400,NULL,0,NULL,NULL,0),(77,31,9,22,0,0,0,1,'NpcMetalExtractor',NULL,10,23,NULL,1,400,NULL,0,NULL,NULL,0),(78,31,13,22,0,0,0,1,'NpcZetiumExtractor',NULL,14,23,NULL,1,800,NULL,0,NULL,NULL,0),(79,31,1,8,0,0,0,1,'NpcSolarPlant',NULL,2,9,NULL,1,1000,NULL,0,NULL,NULL,0),(80,31,0,18,0,0,0,1,'NpcSolarPlant',NULL,1,19,NULL,1,1000,NULL,0,NULL,NULL,0),(81,31,2,19,0,0,0,1,'NpcSolarPlant',NULL,3,20,NULL,1,1000,NULL,0,NULL,NULL,0),(82,31,22,21,0,0,0,1,'NpcSolarPlant',NULL,23,22,NULL,1,1000,NULL,0,NULL,NULL,0),(83,43,19,9,0,0,0,1,'NpcMetalExtractor',NULL,20,10,NULL,1,400,NULL,0,NULL,NULL,0),(84,43,7,4,0,0,0,1,'NpcMetalExtractor',NULL,8,5,NULL,1,400,NULL,0,NULL,NULL,0),(85,43,1,30,0,0,0,1,'NpcMetalExtractor',NULL,2,31,NULL,1,400,NULL,0,NULL,NULL,0),(86,43,14,35,0,0,0,1,'NpcMetalExtractor',NULL,15,36,NULL,1,400,NULL,0,NULL,NULL,0),(87,43,5,25,0,0,0,1,'NpcZetiumExtractor',NULL,6,26,NULL,1,800,NULL,0,NULL,NULL,0),(88,43,6,29,0,0,0,1,'NpcZetiumExtractor',NULL,7,30,NULL,1,800,NULL,0,NULL,NULL,0),(89,43,9,28,0,0,0,1,'NpcResearchCenter',NULL,12,31,NULL,1,4000,NULL,0,NULL,NULL,0),(90,43,13,28,0,0,0,1,'NpcResearchCenter',NULL,16,31,NULL,1,4000,NULL,0,NULL,NULL,0),(91,43,5,16,0,0,0,1,'NpcExcavationSite',NULL,8,19,NULL,1,2000,NULL,0,NULL,NULL,0),(92,43,10,37,0,0,0,1,'NpcCommunicationsHub',NULL,12,38,NULL,1,1200,NULL,0,NULL,NULL,0),(93,43,0,33,0,0,0,1,'NpcSolarPlant',NULL,1,34,NULL,1,1000,NULL,0,NULL,NULL,0),(94,43,4,33,0,0,0,1,'NpcSolarPlant',NULL,5,34,NULL,1,1000,NULL,0,NULL,NULL,0),(95,43,2,33,0,0,0,1,'NpcSolarPlant',NULL,3,34,NULL,1,1000,NULL,0,NULL,NULL,0),(96,52,20,2,0,0,0,1,'NpcMetalExtractor',NULL,21,3,NULL,1,400,NULL,0,NULL,NULL,0),(97,52,27,3,0,0,0,1,'NpcMetalExtractor',NULL,28,4,NULL,1,400,NULL,0,NULL,NULL,0),(98,52,33,2,0,0,0,1,'NpcMetalExtractor',NULL,34,3,NULL,1,400,NULL,0,NULL,NULL,0),(99,52,10,3,0,0,0,1,'NpcMetalExtractor',NULL,11,4,NULL,1,400,NULL,0,NULL,NULL,0),(100,52,16,2,0,0,0,1,'NpcMetalExtractor',NULL,17,3,NULL,1,400,NULL,0,NULL,NULL,0),(101,52,14,22,0,0,0,1,'NpcMetalExtractor',NULL,15,23,NULL,1,400,NULL,0,NULL,NULL,0),(102,52,15,26,0,0,0,1,'NpcGeothermalPlant',NULL,16,27,NULL,1,600,NULL,0,NULL,NULL,0),(103,52,7,26,0,0,0,1,'NpcZetiumExtractor',NULL,8,27,NULL,1,800,NULL,0,NULL,NULL,0),(104,52,0,25,0,0,0,1,'NpcResearchCenter',NULL,3,28,NULL,1,4000,NULL,0,NULL,NULL,0),(105,52,36,0,0,0,0,1,'NpcCommunicationsHub',NULL,38,1,NULL,1,1200,NULL,0,NULL,NULL,0),(106,52,6,14,0,0,0,1,'NpcResearchCenter',NULL,9,17,NULL,1,4000,NULL,0,NULL,NULL,0),(107,52,4,26,0,0,0,1,'NpcSolarPlant',NULL,5,27,NULL,1,1000,NULL,0,NULL,NULL,0),(108,52,18,25,0,0,0,1,'NpcSolarPlant',NULL,19,26,NULL,1,1000,NULL,0,NULL,NULL,0),(109,52,18,27,0,0,0,1,'NpcSolarPlant',NULL,19,28,NULL,1,1000,NULL,0,NULL,NULL,0),(110,52,0,2,0,0,0,1,'NpcSolarPlant',NULL,1,3,NULL,1,1000,NULL,0,NULL,NULL,0);
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
INSERT INTO `folliages` VALUES (6,0,13,1),(6,0,14,10),(6,0,17,4),(6,0,19,9),(6,0,20,4),(6,0,29,1),(6,0,44,6),(6,0,47,1),(6,0,48,0),(6,1,10,8),(6,1,15,11),(6,1,21,3),(6,1,26,5),(6,1,28,10),(6,1,29,6),(6,1,31,1),(6,1,32,13),(6,1,40,7),(6,2,11,10),(6,2,12,3),(6,2,17,11),(6,2,19,7),(6,2,21,7),(6,2,25,5),(6,2,26,4),(6,2,27,12),(6,2,29,5),(6,2,31,0),(6,2,34,3),(6,2,39,13),(6,2,45,6),(6,2,46,2),(6,3,18,4),(6,3,26,1),(6,3,29,5),(6,3,37,6),(6,3,45,11),(6,4,18,7),(6,4,20,12),(6,4,33,2),(6,4,34,4),(6,4,38,10),(6,4,39,5),(6,4,41,9),(6,5,11,1),(6,5,17,5),(6,5,18,0),(6,5,27,7),(6,5,28,11),(6,5,32,10),(6,5,33,8),(6,5,39,12),(6,5,42,4),(6,5,49,1),(6,6,3,4),(6,6,9,2),(6,6,10,10),(6,6,11,10),(6,6,14,4),(6,6,21,9),(6,6,26,2),(6,6,27,12),(6,6,33,13),(6,6,44,3),(6,7,14,3),(6,7,21,5),(6,7,31,9),(6,7,40,6),(6,7,41,2),(6,8,2,12),(6,8,3,10),(6,8,6,0),(6,8,17,1),(6,8,18,5),(6,8,29,6),(6,8,38,7),(6,8,43,4),(6,9,13,2),(6,9,29,9),(6,9,30,6),(6,9,34,8),(6,10,11,7),(6,10,16,8),(6,10,21,1),(6,10,23,10),(6,10,40,6),(6,11,5,5),(6,11,12,8),(6,11,25,7),(6,11,26,13),(6,11,28,10),(6,11,42,5),(6,12,0,3),(6,12,1,2),(6,12,5,8),(6,12,8,3),(6,12,11,8),(6,12,15,9),(6,12,16,5),(6,12,42,2),(6,13,1,11),(6,13,2,0),(6,13,5,5),(6,13,6,2),(6,13,9,12),(6,13,20,9),(6,13,26,3),(6,13,42,4),(6,13,50,9),(6,14,3,13),(6,14,4,5),(6,14,6,9),(6,14,7,11),(6,14,12,4),(6,14,14,1),(6,14,22,0),(6,14,50,12),(6,15,7,2),(6,15,12,1),(6,15,19,0),(6,15,39,3),(6,15,41,0),(6,15,50,5),(6,16,7,1),(6,16,13,3),(6,16,14,10),(6,16,15,2),(6,16,17,5),(6,16,19,0),(6,16,23,13),(6,16,25,1),(6,16,27,3),(6,16,28,12),(6,17,9,5),(6,17,14,12),(6,17,16,0),(6,17,18,8),(6,17,26,8),(6,17,27,12),(6,17,33,5),(6,17,40,8),(6,18,15,7),(6,18,16,6),(6,18,27,8),(6,18,39,8),(6,18,43,7),(6,18,50,0),(6,19,10,5),(6,19,16,10),(6,19,30,6),(6,19,34,2),(6,19,45,5),(8,0,15,9),(8,0,18,1),(8,0,23,2),(8,1,23,5),(8,1,24,11),(8,2,24,11),(8,3,15,11),(8,4,25,11),(8,5,5,10),(8,5,6,0),(8,5,11,1),(8,5,21,1),(8,5,28,9),(8,6,0,0),(8,6,6,8),(8,6,12,7),(8,6,13,3),(8,6,24,1),(8,6,25,4),(8,6,27,1),(8,7,22,10),(8,9,6,12),(8,9,10,2),(8,9,13,7),(8,9,14,4),(8,10,14,11),(8,11,4,8),(8,11,8,7),(8,11,9,2),(8,11,19,3),(8,11,22,9),(8,12,3,5),(8,12,16,8),(8,12,20,6),(8,12,21,0),(8,13,17,0),(8,13,19,8),(8,13,26,6),(8,14,21,8),(8,14,22,1),(8,14,27,9),(8,14,28,1),(8,14,29,8),(8,15,6,4),(8,15,26,6),(8,16,8,7),(8,16,19,7),(8,16,22,6),(8,16,27,3),(8,17,6,11),(8,17,20,0),(8,17,21,11),(8,17,22,10),(8,17,25,9),(8,18,6,8),(8,18,8,8),(8,18,17,0),(8,18,19,4),(8,18,20,6),(8,18,26,8),(8,19,7,10),(8,19,10,7),(8,19,15,1),(8,19,27,9),(8,20,10,7),(8,20,18,1),(8,20,20,10),(8,20,25,5),(8,21,5,9),(8,21,17,5),(8,21,21,1),(8,21,28,8),(8,22,4,8),(8,22,8,13),(8,22,18,3),(8,23,8,10),(8,23,11,9),(8,23,12,6),(8,23,17,5),(8,24,6,5),(8,24,13,10),(8,24,14,1),(8,24,17,12),(8,24,19,5),(8,24,24,2),(8,25,20,5),(8,26,5,7),(8,26,11,10),(8,26,14,11),(8,26,15,3),(8,26,25,3),(8,27,0,4),(8,27,16,9),(8,27,19,10),(8,27,28,6),(8,28,14,2),(8,29,0,0),(10,0,1,7),(10,0,4,3),(10,0,5,7),(10,0,8,3),(10,0,29,13),(10,1,1,4),(10,1,4,0),(10,1,7,2),(10,1,28,5),(10,1,31,10),(10,1,34,10),(10,2,8,6),(10,2,26,10),(10,2,28,1),(10,2,35,13),(10,3,26,9),(10,4,12,11),(10,4,25,8),(10,5,8,11),(10,5,26,0),(10,5,29,10),(10,5,30,2),(10,5,32,4),(10,6,24,6),(10,6,28,2),(10,6,31,7),(10,7,30,6),(10,7,35,8),(10,8,2,10),(10,8,12,9),(10,8,36,0),(10,9,11,11),(10,9,35,7),(10,10,9,13),(10,10,18,9),(10,10,20,13),(10,10,29,10),(10,10,35,0),(10,11,18,7),(10,11,19,7),(10,12,5,2),(10,12,35,13),(10,13,6,11),(10,13,11,4),(10,13,32,1),(10,14,4,3),(10,14,5,4),(10,14,12,8),(10,14,18,11),(10,14,31,0),(10,14,32,4),(10,15,15,11),(10,15,17,9),(10,15,18,11),(10,15,22,1),(10,15,34,6),(10,16,6,8),(10,16,16,7),(10,16,18,13),(10,16,31,1),(10,16,32,11),(10,16,35,8),(10,17,6,13),(10,17,14,6),(10,17,29,3),(10,17,30,5),(10,17,33,3),(10,17,34,13),(10,17,35,0),(10,18,6,1),(10,18,7,0),(10,18,25,3),(10,18,28,6),(10,18,34,0),(10,18,36,6),(10,19,6,7),(10,19,10,5),(10,19,11,13),(10,19,24,5),(10,19,29,4),(10,19,32,11),(10,19,34,4),(10,20,6,13),(10,20,11,7),(10,20,25,10),(10,20,30,8),(10,20,32,10),(10,21,6,8),(10,21,15,6),(10,21,23,6),(10,21,25,11),(10,21,32,1),(10,21,36,8),(10,22,18,0),(10,22,22,8),(10,22,23,12),(10,22,24,7),(10,22,25,0),(10,22,28,11),(10,23,10,3),(10,23,19,5),(10,23,22,10),(10,23,23,4),(10,23,27,7),(10,23,35,4),(10,23,36,8),(10,24,17,10),(10,24,19,1),(10,24,23,2),(10,24,24,3),(10,24,29,0),(10,25,14,8),(10,25,24,13),(10,25,27,5),(10,26,7,12),(10,26,8,13),(10,26,13,4),(10,26,14,3),(10,26,15,9),(10,26,16,2),(10,26,21,10),(10,26,22,3),(10,26,32,12),(19,0,0,0),(19,0,2,1),(19,0,6,2),(19,0,7,6),(19,0,11,11),(19,0,25,12),(19,0,44,3),(19,1,8,13),(19,1,25,7),(19,1,29,10),(19,1,41,5),(19,1,44,0),(19,2,4,13),(19,2,29,10),(19,2,38,2),(19,2,42,7),(19,2,43,6),(19,2,45,2),(19,2,46,13),(19,3,6,7),(19,3,7,11),(19,3,39,10),(19,3,48,10),(19,4,6,11),(19,4,7,2),(19,4,26,6),(19,4,33,11),(19,4,34,12),(19,4,36,0),(19,4,46,7),(19,4,54,4),(19,5,10,3),(19,5,11,13),(19,5,13,10),(19,5,30,5),(19,5,38,11),(19,5,41,9),(19,6,21,0),(19,7,3,6),(19,7,16,3),(19,7,17,1),(19,7,31,8),(19,7,35,2),(19,7,38,7),(19,7,42,5),(19,7,54,6),(19,8,12,11),(19,8,13,13),(19,8,16,4),(19,8,17,12),(19,8,19,12),(19,8,28,7),(19,8,32,6),(19,8,35,13),(19,8,36,5),(19,8,40,1),(19,8,45,4),(19,8,46,5),(19,8,50,6),(19,8,55,5),(19,9,7,5),(19,9,10,4),(19,9,21,0),(19,9,23,7),(19,9,28,13),(19,9,29,0),(19,9,48,6),(19,9,51,13),(19,10,8,10),(19,10,13,10),(19,10,15,6),(19,10,16,6),(19,10,29,12),(19,10,31,0),(19,10,33,1),(19,10,41,4),(19,10,43,7),(19,10,45,6),(19,10,54,2),(19,11,7,6),(19,11,10,2),(19,11,15,12),(19,11,22,0),(19,11,30,10),(19,11,40,12),(19,11,50,10),(19,11,52,2),(19,12,9,4),(19,12,10,3),(19,12,11,12),(19,12,12,9),(19,12,13,1),(19,12,14,2),(19,12,28,12),(19,12,32,4),(19,12,34,13),(19,12,49,2),(19,12,53,11),(19,13,12,5),(19,13,17,1),(19,13,28,5),(19,13,43,1),(19,13,48,1),(19,13,50,1),(19,13,52,6),(19,13,53,11),(19,14,10,4),(19,14,15,12),(19,14,18,12),(19,14,21,1),(19,14,38,13),(19,14,45,0),(19,14,49,11),(19,14,50,13),(19,15,3,6),(19,15,17,11),(19,15,18,13),(19,15,19,4),(19,15,43,0),(19,15,49,2),(19,15,55,1),(19,16,3,13),(19,16,9,13),(19,16,29,10),(19,16,38,3),(19,16,39,3),(19,16,40,4),(19,16,43,4),(19,16,49,0),(19,16,50,13),(19,17,3,13),(19,17,4,6),(19,17,6,2),(19,17,23,4),(19,17,41,4),(19,17,46,11),(19,18,5,13),(19,18,22,8),(19,18,44,7),(19,18,47,4),(19,18,49,1),(19,18,51,3),(19,18,52,5),(19,19,3,2),(19,19,6,1),(19,19,9,7),(19,19,11,0),(19,19,14,7),(19,19,20,5),(19,19,37,6),(19,19,50,3),(19,19,55,5),(30,0,2,5),(30,0,11,8),(30,0,13,6),(30,1,0,11),(30,1,1,9),(30,1,10,9),(30,2,13,8),(30,3,4,13),(30,6,0,3),(30,7,0,6),(30,7,3,3),(30,7,10,0),(30,7,12,0),(30,8,10,1),(30,9,0,3),(30,9,1,11),(30,9,2,5),(30,10,2,8),(30,10,10,10),(30,10,14,7),(30,11,6,8),(30,11,8,8),(30,11,9,5),(30,11,10,8),(30,11,12,10),(30,11,14,2),(30,12,13,5),(30,12,14,5),(30,12,15,6),(30,13,2,6),(30,13,3,13),(30,13,15,6),(30,14,7,5),(30,14,8,8),(30,14,9,8),(30,14,12,6),(30,15,8,0),(30,16,9,7),(30,17,9,0),(30,18,6,0),(30,18,14,11),(30,19,3,11),(30,19,5,3),(30,19,14,8),(30,19,15,10),(30,20,8,6),(30,20,12,13),(30,21,1,11),(30,21,6,11),(30,21,7,5),(30,22,2,5),(30,22,5,2),(30,23,2,2),(30,23,7,8),(30,24,3,6),(30,24,14,0),(30,24,15,2),(30,25,2,11),(30,25,7,1),(30,25,16,2),(30,26,5,13),(30,26,7,8),(30,26,10,9),(30,26,11,12),(30,26,16,7),(30,27,2,6),(30,27,6,5),(30,27,7,9),(30,27,8,7),(30,27,15,13),(30,27,16,3),(30,28,8,6),(30,28,10,8),(30,28,11,9),(30,28,12,3),(30,28,13,11),(30,28,14,5),(30,29,1,0),(30,29,6,10),(30,29,7,8),(30,29,14,11),(30,30,1,8),(30,30,4,4),(30,30,5,10),(30,30,7,11),(30,30,9,10),(30,30,11,3),(30,30,14,11),(30,31,0,3),(30,31,2,4),(30,31,11,4),(30,31,14,1),(30,31,16,2),(30,32,0,9),(30,32,1,13),(30,32,4,1),(30,32,8,6),(30,32,11,7),(30,32,13,9),(30,33,1,3),(30,33,5,6),(30,33,6,4),(30,33,11,10),(30,33,13,6),(30,33,14,13),(30,34,3,13),(30,34,5,6),(30,34,9,12),(30,35,2,9),(30,35,5,5),(30,35,6,7),(30,35,13,8),(30,36,0,9),(30,36,7,2),(30,36,11,8),(30,36,12,1),(30,37,5,11),(30,37,6,1),(30,37,9,1),(30,37,10,5),(30,37,14,5),(30,37,15,5),(30,38,0,3),(30,38,10,2),(30,38,12,11),(30,38,14,3),(30,39,0,0),(30,40,1,5),(30,40,12,5),(30,41,7,7),(30,41,12,10),(30,42,8,9),(30,42,9,9),(30,43,0,9),(30,43,15,1),(30,45,0,4),(30,45,11,7),(30,46,4,12),(30,47,0,0),(30,47,3,9),(30,47,8,9),(30,47,14,3),(30,47,15,11),(30,48,1,12),(30,50,2,0),(30,50,3,8),(30,51,0,11),(30,51,16,1),(31,2,4,0),(31,3,5,11),(31,3,6,4),(31,4,5,9),(31,4,13,11),(31,7,10,3),(31,7,14,0),(31,8,10,6),(31,8,12,1),(31,8,13,5),(31,8,24,3),(31,9,4,6),(31,11,9,9),(31,11,15,12),(31,12,3,9),(31,12,18,5),(31,13,18,3),(31,14,18,0),(31,16,6,4),(31,17,4,13),(31,17,20,3),(31,18,2,7),(31,18,14,6),(31,18,17,11),(31,18,23,9),(31,18,24,3),(31,19,12,11),(31,19,17,11),(31,20,0,13),(31,20,3,10),(31,20,6,10),(31,20,24,11),(31,21,2,3),(31,21,3,9),(31,21,4,5),(31,21,12,10),(31,21,14,0),(31,21,20,7),(31,22,4,8),(31,22,6,0),(31,22,8,11),(31,22,9,11),(31,22,17,3),(31,22,19,6),(31,22,20,13),(31,23,2,3),(31,23,7,8),(31,24,1,13),(31,24,5,2),(31,24,24,3),(31,25,2,0),(31,25,5,5),(31,25,15,13),(31,25,19,7),(43,0,2,2),(43,0,3,11),(43,0,5,3),(43,0,18,11),(43,0,20,1),(43,0,32,4),(43,0,36,13),(43,1,2,6),(43,1,5,5),(43,1,32,4),(43,2,1,4),(43,2,5,12),(43,2,6,0),(43,2,28,11),(43,2,38,3),(43,3,0,9),(43,3,2,3),(43,3,6,5),(43,3,7,2),(43,4,2,3),(43,4,38,13),(43,5,0,12),(43,5,4,1),(43,5,5,9),(43,5,36,2),(43,6,1,6),(43,6,8,11),(43,7,0,5),(43,7,2,3),(43,7,7,1),(43,7,9,3),(43,7,12,0),(43,7,13,7),(43,7,38,6),(43,8,3,13),(43,8,12,2),(43,8,13,9),(43,8,37,12),(43,9,0,3),(43,9,7,13),(43,9,36,6),(43,9,37,5),(43,10,4,7),(43,10,5,8),(43,10,19,4),(43,11,0,11),(43,11,1,12),(43,11,2,7),(43,11,3,7),(43,11,5,6),(43,12,0,0),(43,12,1,6),(43,12,5,3),(43,12,25,3),(43,14,0,9),(43,14,5,11),(43,15,3,12),(43,15,33,4),(43,16,17,11),(43,16,18,1),(43,16,19,2),(43,16,33,4),(43,16,35,6),(43,16,38,7),(43,17,17,9),(43,17,18,3),(43,17,27,0),(43,17,38,3),(43,18,7,3),(43,19,20,3),(43,19,21,5),(43,19,22,13),(43,19,23,7),(43,19,24,3),(43,19,28,3),(43,19,33,6),(43,19,37,7),(43,20,8,3),(43,20,13,11),(43,20,22,10),(43,20,25,12),(43,20,26,8),(43,20,35,6),(43,20,37,10),(43,21,8,3),(43,21,16,13),(43,21,19,5),(43,21,21,11),(43,21,22,1),(43,21,23,0),(43,21,32,13),(43,21,33,8),(43,21,34,3),(43,21,37,10),(43,22,18,4),(43,22,19,7),(43,22,23,6),(43,22,31,8),(43,22,35,1),(43,22,36,5),(43,23,10,3),(43,23,19,3),(43,23,22,3),(43,24,16,13),(43,24,33,1),(43,24,34,3),(43,24,37,11),(43,25,11,11),(43,25,14,10),(43,25,16,2),(43,25,18,10),(43,25,20,8),(43,25,23,10),(43,25,33,2),(43,25,37,10),(43,25,38,2),(43,26,10,12),(43,26,11,10),(43,26,21,4),(43,26,33,13),(43,26,36,5),(43,26,38,0),(43,27,2,2),(43,27,14,9),(43,27,23,4),(43,27,24,5),(43,27,33,2),(43,27,34,2),(43,27,37,2),(43,27,38,11),(43,28,17,4),(43,28,26,0),(43,28,34,7),(43,28,37,8),(43,29,1,5),(43,29,15,2),(43,29,17,4),(43,29,20,7),(43,29,22,9),(43,29,24,3),(43,29,25,7),(43,29,33,4),(43,29,36,10),(43,30,0,5),(43,30,1,10),(43,30,2,7),(43,30,3,2),(43,30,16,4),(43,30,19,12),(43,30,21,10),(43,30,22,10),(43,30,24,13),(43,30,31,5),(43,30,33,2),(43,30,38,1),(43,31,2,1),(43,31,16,5),(43,31,18,12),(43,31,20,7),(43,31,23,13),(43,31,25,2),(43,31,32,5),(43,31,34,4),(43,32,19,2),(43,32,32,7),(43,32,36,5),(43,33,1,5),(43,33,2,6),(43,33,3,8),(43,33,4,6),(43,33,12,0),(43,33,25,12),(43,33,31,10),(43,34,0,13),(43,34,2,5),(43,34,8,8),(43,34,20,3),(43,34,21,7),(43,34,29,3),(43,35,0,4),(43,35,28,6),(43,35,30,12),(43,35,31,13),(43,35,35,13),(43,36,8,12),(43,36,11,9),(43,36,18,13),(43,36,20,11),(43,36,27,7),(43,36,28,0),(43,36,31,3),(43,36,35,5),(43,37,14,4),(43,37,20,10),(43,37,21,6),(43,37,23,13),(43,37,27,1),(43,37,31,11),(43,37,32,9),(43,38,7,13),(43,38,14,12),(43,38,18,2),(43,38,20,4),(43,38,21,8),(43,38,29,4),(43,38,31,6),(52,0,4,8),(52,0,8,12),(52,0,9,2),(52,0,10,7),(52,0,14,4),(52,0,16,5),(52,0,24,4),(52,1,1,8),(52,1,14,6),(52,1,24,10),(52,2,5,0),(52,3,0,11),(52,3,5,11),(52,3,24,5),(52,4,1,0),(52,4,5,9),(52,4,25,7),(52,5,3,7),(52,5,7,1),(52,5,9,11),(52,5,16,1),(52,5,18,11),(52,6,4,1),(52,8,1,6),(52,8,24,6),(52,8,25,10),(52,9,24,6),(52,9,26,10),(52,10,26,10),(52,11,24,11),(52,12,9,2),(52,12,21,11),(52,12,28,0),(52,13,26,0),(52,14,24,5),(52,14,26,10),(52,14,27,4),(52,16,9,3),(52,16,23,2),(52,17,0,3),(52,17,21,3),(52,17,22,8),(52,17,24,5),(52,17,25,2),(52,18,4,5),(52,18,10,2),(52,18,22,8),(52,19,23,12),(52,20,0,7),(52,20,1,7),(52,20,26,10),(52,21,0,0),(52,21,4,0),(52,21,5,4),(52,21,17,5),(52,21,18,10),(52,21,19,4),(52,22,4,5),(52,22,6,9),(52,22,10,3),(52,22,19,2),(52,22,27,6),(52,23,16,10),(52,23,19,12),(52,24,0,13),(52,24,6,9),(52,24,11,2),(52,24,19,7),(52,25,2,0),(52,25,10,2),(52,25,11,6),(52,25,14,2),(52,25,20,13),(52,26,6,7),(52,26,10,3),(52,26,12,3),(52,26,13,9),(52,26,15,10),(52,27,7,3),(52,27,9,4),(52,27,10,7),(52,28,7,5),(52,28,9,6),(52,28,12,2),(52,28,16,5),(52,28,17,3),(52,29,5,3),(52,29,6,11),(52,29,8,7),(52,29,10,3),(52,29,15,7),(52,29,23,6),(52,29,28,5),(52,30,5,7),(52,30,7,1),(52,30,18,0),(52,30,20,7),(52,31,8,4),(52,31,20,13),(52,32,5,11),(52,33,5,0),(52,33,12,3),(52,33,22,11),(52,34,23,5),(52,34,24,8),(52,36,12,7),(52,36,18,13),(52,36,23,10),(52,36,24,2),(52,36,25,0),(52,36,27,11),(52,37,21,11),(52,37,26,10),(52,38,8,12),(52,38,14,4),(52,38,17,7),(52,38,21,7),(52,38,26,4),(52,38,28,0);
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
INSERT INTO `galaxies` VALUES (1,'2010-11-23 17:51:28','dev');
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
INSERT INTO `solar_systems` VALUES (1,'Homeworld',1,2,2),(2,'Resource',1,0,2),(3,'Expansion',1,0,1),(4,'Expansion',1,1,0);
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
INSERT INTO `ss_objects` VALUES (1,1,0,0,1,45,'Asteroid',NULL,'',47,0,0,0,1,0,0,0,0,0,0,NULL,0),(2,1,0,0,1,225,'Asteroid',NULL,'',55,0,0,0,1,0,0,0,0,0,0,NULL,0),(3,1,0,0,1,90,'Asteroid',NULL,'',25,0,0,0,0,0,0,0,0,0,0,NULL,0),(4,1,0,0,3,0,'Jumpgate',NULL,'',54,0,0,0,0,0,0,0,0,0,0,NULL,0),(5,1,0,0,1,135,'Asteroid',NULL,'',38,0,0,0,0,0,0,0,0,0,1,NULL,0),(6,1,20,51,0,270,'Planet',NULL,'P-6',54,1,0,0,0,0,0,0,0,0,0,'2010-11-23 17:51:31',0),(7,1,0,0,1,315,'Asteroid',NULL,'',40,0,0,0,0,0,0,1,0,0,1,NULL,0),(8,1,30,30,2,60,'Planet',1,'P-8',50,0,864,2,3024,1728,4,6048,0,0,604.8,'2010-11-23 17:51:31',0),(9,2,0,0,1,45,'Asteroid',NULL,'',59,0,0,0,1,0,0,2,0,0,2,NULL,0),(10,2,27,37,2,90,'Planet',NULL,'P-10',51,2,0,0,0,0,0,0,0,0,0,'2010-11-23 17:51:31',0),(11,2,0,0,1,225,'Asteroid',NULL,'',33,0,0,0,1,0,0,0,0,0,1,NULL,0),(12,2,0,0,3,22,'Jumpgate',NULL,'',40,0,0,0,0,0,0,0,0,0,0,NULL,0),(13,2,0,0,3,246,'Jumpgate',NULL,'',59,0,0,0,0,0,0,0,0,0,0,NULL,0),(14,2,0,0,1,315,'Asteroid',NULL,'',35,0,0,0,0,0,0,0,0,0,0,NULL,0),(15,2,0,0,2,60,'Asteroid',NULL,'',54,0,0,0,2,0,0,3,0,0,1,NULL,0),(16,2,0,0,1,0,'Asteroid',NULL,'',58,0,0,0,2,0,0,2,0,0,2,NULL,0),(17,2,0,0,3,292,'Jumpgate',NULL,'',60,0,0,0,0,0,0,0,0,0,0,NULL,0),(18,2,0,0,2,30,'Asteroid',NULL,'',28,0,0,0,0,0,0,0,0,0,1,NULL,0),(19,2,20,56,0,90,'Planet',NULL,'P-19',56,2,0,0,0,0,0,0,0,0,0,'2010-11-23 17:51:31',0),(20,2,0,0,0,270,'Asteroid',NULL,'',56,0,0,0,3,0,0,1,0,0,3,NULL,0),(21,2,0,0,2,270,'Asteroid',NULL,'',48,0,0,0,3,0,0,3,0,0,2,NULL,0),(22,2,0,0,0,0,'Asteroid',NULL,'',49,0,0,0,0,0,0,1,0,0,0,NULL,0),(23,3,0,0,1,45,'Asteroid',NULL,'',41,0,0,0,3,0,0,3,0,0,2,NULL,0),(24,3,0,0,1,90,'Asteroid',NULL,'',51,0,0,0,0,0,0,0,0,0,0,NULL,0),(25,3,0,0,2,150,'Asteroid',NULL,'',39,0,0,0,2,0,0,1,0,0,1,NULL,0),(26,3,0,0,1,135,'Asteroid',NULL,'',46,0,0,0,1,0,0,1,0,0,0,NULL,0),(27,3,0,0,2,330,'Asteroid',NULL,'',29,0,0,0,1,0,0,1,0,0,3,NULL,0),(28,3,0,0,2,210,'Asteroid',NULL,'',29,0,0,0,0,0,0,1,0,0,1,NULL,0),(29,3,0,0,3,156,'Jumpgate',NULL,'',54,0,0,0,0,0,0,0,0,0,0,NULL,0),(30,3,52,17,1,315,'Planet',NULL,'P-30',54,0,0,0,0,0,0,0,0,0,0,'2010-11-23 17:51:31',0),(31,3,26,25,0,180,'Planet',NULL,'P-31',46,1,0,0,0,0,0,0,0,0,0,'2010-11-23 17:51:31',0),(32,3,0,0,0,0,'Asteroid',NULL,'',33,0,0,0,0,0,0,0,0,0,1,NULL,0),(33,4,0,0,1,45,'Asteroid',NULL,'',39,0,0,0,0,0,0,1,0,0,0,NULL,0),(34,4,0,0,2,90,'Asteroid',NULL,'',30,0,0,0,2,0,0,3,0,0,3,NULL,0),(35,4,0,0,1,225,'Asteroid',NULL,'',32,0,0,0,1,0,0,0,0,0,1,NULL,0),(36,4,0,0,2,120,'Asteroid',NULL,'',30,0,0,0,1,0,0,1,0,0,1,NULL,0),(37,4,0,0,1,180,'Asteroid',NULL,'',47,0,0,0,3,0,0,3,0,0,1,NULL,0),(38,4,0,0,2,210,'Asteroid',NULL,'',52,0,0,0,1,0,0,1,0,0,1,NULL,0),(39,4,0,0,3,202,'Jumpgate',NULL,'',60,0,0,0,0,0,0,0,0,0,0,NULL,0),(40,4,0,0,1,315,'Asteroid',NULL,'',35,0,0,0,2,0,0,2,0,0,2,NULL,0),(41,4,0,0,2,60,'Asteroid',NULL,'',40,0,0,0,1,0,0,1,0,0,3,NULL,0),(42,4,0,0,1,0,'Asteroid',NULL,'',31,0,0,0,0,0,0,1,0,0,1,NULL,0),(43,4,39,39,1,270,'Planet',NULL,'P-43',57,2,0,0,0,0,0,0,0,0,0,'2010-11-23 17:51:31',0),(44,4,0,0,2,150,'Asteroid',NULL,'',53,0,0,0,2,0,0,2,0,0,3,NULL,0),(45,4,0,0,2,30,'Asteroid',NULL,'',34,0,0,0,3,0,0,2,0,0,1,NULL,0),(46,4,0,0,2,180,'Asteroid',NULL,'',44,0,0,0,2,0,0,3,0,0,1,NULL,0),(47,4,0,0,0,90,'Asteroid',NULL,'',32,0,0,0,1,0,0,0,0,0,0,NULL,0),(48,4,0,0,1,135,'Asteroid',NULL,'',41,0,0,0,0,0,0,0,0,0,1,NULL,0),(49,4,0,0,2,0,'Asteroid',NULL,'',32,0,0,0,1,0,0,1,0,0,1,NULL,0),(50,4,0,0,0,180,'Asteroid',NULL,'',29,0,0,0,3,0,0,2,0,0,3,NULL,0),(51,4,0,0,2,300,'Asteroid',NULL,'',38,0,0,0,0,0,0,1,0,0,0,NULL,0),(52,4,39,29,0,0,'Planet',NULL,'P-52',53,1,0,0,0,0,0,0,0,0,0,'2010-11-23 17:51:31',0);
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
INSERT INTO `tiles` VALUES (3,6,0,2),(3,6,0,3),(3,6,0,4),(3,6,0,5),(3,6,0,6),(3,6,0,7),(3,6,0,8),(3,6,0,9),(3,6,0,24),(3,6,0,25),(4,6,0,36),(4,6,0,37),(4,6,0,38),(4,6,0,39),(4,6,0,40),(4,6,0,49),(4,6,0,50),(3,6,1,2),(3,6,1,3),(3,6,1,4),(3,6,1,5),(3,6,1,6),(0,6,1,8),(3,6,1,23),(3,6,1,24),(3,6,1,25),(4,6,1,34),(4,6,1,35),(4,6,1,36),(4,6,1,37),(4,6,1,38),(4,6,1,39),(4,6,1,44),(4,6,1,46),(4,6,1,47),(0,6,1,48),(4,6,1,50),(0,6,2,3),(3,6,2,5),(3,6,2,6),(3,6,2,7),(3,6,2,22),(3,6,2,23),(3,6,2,24),(4,6,2,36),(4,6,2,37),(4,6,2,38),(4,6,2,44),(4,6,2,47),(4,6,2,50),(3,6,3,5),(3,6,3,7),(3,6,3,8),(5,6,3,22),(3,6,3,23),(3,6,3,24),(3,6,3,25),(4,6,3,35),(4,6,3,36),(4,6,3,42),(4,6,3,43),(4,6,3,44),(4,6,3,46),(4,6,3,47),(4,6,3,48),(4,6,3,49),(4,6,3,50),(6,6,4,6),(3,6,4,7),(3,6,4,8),(5,6,4,22),(3,6,4,23),(3,6,4,25),(4,6,4,42),(4,6,4,43),(4,6,4,44),(4,6,4,45),(4,6,4,46),(4,6,4,47),(4,6,4,48),(4,6,4,50),(6,6,5,5),(6,6,5,6),(6,6,5,7),(6,6,5,8),(5,6,5,20),(5,6,5,22),(3,6,5,23),(3,6,5,25),(3,6,5,26),(14,6,5,35),(4,6,5,43),(4,6,5,44),(4,6,5,45),(4,6,5,46),(4,6,5,47),(4,6,5,48),(6,6,6,5),(6,6,6,6),(6,6,6,7),(6,6,6,8),(5,6,6,19),(5,6,6,20),(5,6,6,22),(3,6,6,23),(3,6,6,24),(3,6,6,25),(4,6,6,45),(3,6,6,46),(3,6,6,47),(0,6,6,48),(3,6,6,50),(1,6,7,4),(6,6,7,6),(6,6,7,7),(6,6,7,8),(5,6,7,19),(5,6,7,20),(5,6,7,22),(5,6,7,23),(3,6,7,24),(3,6,7,46),(3,6,7,47),(3,6,7,50),(6,6,8,7),(6,6,8,8),(6,6,8,9),(5,6,8,19),(5,6,8,20),(5,6,8,21),(5,6,8,22),(3,6,8,24),(5,6,8,45),(3,6,8,46),(3,6,8,47),(3,6,8,48),(3,6,8,49),(3,6,8,50),(6,6,9,6),(6,6,9,7),(6,6,9,8),(5,6,9,19),(5,6,9,20),(5,6,9,21),(5,6,9,22),(5,6,9,44),(5,6,9,45),(3,6,9,46),(3,6,9,47),(3,6,9,48),(3,6,9,49),(3,6,9,50),(6,6,10,7),(6,6,10,8),(5,6,10,19),(5,6,10,20),(11,6,10,29),(5,6,10,44),(5,6,10,45),(5,6,10,46),(5,6,10,47),(3,6,10,48),(3,6,10,49),(3,6,10,50),(2,6,11,2),(5,6,11,18),(5,6,11,19),(5,6,11,20),(5,6,11,21),(5,6,11,23),(10,6,11,35),(8,6,11,39),(0,6,11,43),(5,6,11,45),(5,6,11,46),(5,6,11,47),(0,6,11,48),(3,6,11,50),(5,6,12,17),(5,6,12,18),(5,6,12,19),(5,6,12,20),(5,6,12,21),(5,6,12,23),(5,6,12,45),(5,6,12,46),(5,6,12,47),(3,6,12,50),(5,6,13,18),(5,6,13,21),(5,6,13,22),(5,6,13,23),(5,6,13,24),(5,6,13,45),(5,6,13,46),(5,6,13,47),(5,6,13,48),(6,6,14,0),(3,6,14,21),(5,6,14,23),(3,6,14,30),(3,6,14,31),(3,6,14,32),(3,6,14,33),(3,6,14,34),(5,6,14,44),(5,6,14,45),(6,6,15,0),(11,6,15,1),(3,6,15,20),(3,6,15,21),(3,6,15,31),(3,6,15,32),(3,6,15,33),(3,6,15,34),(3,6,15,35),(3,6,15,36),(3,6,15,37),(3,6,15,38),(14,6,15,42),(0,6,15,47),(6,6,16,0),(4,6,16,10),(6,6,16,20),(3,6,16,21),(3,6,16,22),(3,6,16,31),(3,6,16,32),(3,6,16,33),(3,6,16,34),(10,6,16,35),(6,6,17,0),(4,6,17,8),(4,6,17,10),(4,6,17,11),(4,6,17,12),(4,6,17,13),(6,6,17,19),(6,6,17,20),(3,6,17,21),(3,6,17,22),(3,6,17,23),(3,6,17,24),(3,6,17,25),(3,6,17,31),(3,6,17,32),(3,6,17,34),(6,6,18,0),(4,6,18,7),(4,6,18,8),(4,6,18,9),(4,6,18,10),(4,6,18,12),(6,6,18,18),(6,6,18,19),(6,6,18,20),(6,6,18,21),(3,6,18,22),(3,6,18,23),(3,6,18,24),(3,6,18,25),(3,6,18,26),(3,6,18,34),(5,6,18,40),(5,6,18,41),(5,6,18,42),(5,6,18,44),(5,6,18,45),(5,6,18,46),(5,6,18,48),(5,6,18,49),(6,6,19,0),(6,6,19,1),(6,6,19,2),(6,6,19,3),(6,6,19,4),(4,6,19,5),(4,6,19,6),(4,6,19,7),(4,6,19,8),(4,6,19,9),(6,6,19,19),(6,6,19,20),(6,6,19,21),(3,6,19,22),(3,6,19,23),(3,6,19,24),(3,6,19,25),(3,6,19,26),(3,6,19,27),(5,6,19,39),(5,6,19,40),(5,6,19,41),(5,6,19,42),(5,6,19,43),(5,6,19,44),(5,6,19,46),(5,6,19,47),(5,6,19,48),(5,6,19,49),(5,6,19,50),(0,8,0,0),(5,8,0,3),(5,8,0,4),(5,8,0,5),(5,8,0,6),(5,8,0,7),(5,8,0,8),(5,8,0,9),(5,8,0,10),(5,8,0,11),(5,8,0,12),(5,8,0,13),(5,8,0,14),(5,8,0,26),(5,8,0,27),(5,8,0,28),(5,8,0,29),(5,8,1,3),(11,8,1,4),(5,8,1,11),(5,8,1,12),(5,8,1,13),(13,8,1,16),(4,8,1,19),(4,8,1,20),(4,8,1,21),(4,8,1,22),(5,8,1,26),(5,8,1,27),(5,8,1,28),(5,8,1,29),(5,8,2,2),(5,8,2,3),(5,8,2,10),(5,8,2,12),(5,8,2,13),(5,8,2,14),(5,8,2,15),(4,8,2,20),(4,8,2,21),(4,8,2,22),(4,8,2,23),(5,8,2,27),(5,8,2,28),(5,8,2,29),(0,8,3,1),(5,8,3,10),(5,8,3,11),(5,8,3,12),(5,8,3,13),(5,8,3,14),(4,8,3,20),(4,8,3,21),(4,8,3,22),(4,8,3,23),(4,8,3,24),(5,8,3,28),(5,8,3,29),(5,8,4,12),(5,8,4,13),(6,8,4,18),(4,8,4,21),(4,8,4,22),(4,8,4,23),(5,8,4,26),(5,8,4,27),(5,8,4,28),(6,8,5,8),(6,8,5,9),(6,8,5,18),(6,8,5,19),(4,8,5,22),(4,8,5,23),(4,8,5,24),(5,8,5,26),(5,8,5,27),(6,8,6,7),(6,8,6,8),(6,8,6,9),(6,8,6,11),(6,8,6,18),(6,8,6,19),(6,8,7,9),(6,8,7,10),(6,8,7,18),(12,8,7,23),(6,8,8,9),(6,8,8,10),(6,8,8,16),(6,8,8,17),(6,8,8,18),(3,8,9,3),(3,8,9,4),(6,8,9,9),(6,8,9,15),(6,8,9,16),(6,8,9,17),(3,8,10,0),(3,8,10,2),(3,8,10,3),(3,8,10,4),(8,8,10,5),(6,8,10,16),(6,8,10,17),(0,8,10,20),(3,8,11,0),(3,8,11,1),(3,8,11,2),(3,8,11,3),(3,8,12,0),(3,8,12,1),(3,8,12,2),(3,8,13,0),(3,8,13,1),(3,8,13,2),(3,8,13,4),(3,8,14,0),(3,8,14,1),(3,8,14,2),(3,8,14,3),(3,8,14,4),(3,8,15,0),(3,8,15,1),(3,8,15,2),(3,8,15,3),(3,8,15,4),(3,8,16,0),(3,8,16,1),(3,8,16,2),(3,8,16,3),(5,8,16,29),(3,8,17,0),(3,8,17,1),(3,8,17,2),(3,8,17,3),(3,8,17,4),(5,8,17,28),(5,8,17,29),(3,8,18,0),(3,8,18,1),(3,8,18,2),(3,8,18,3),(3,8,18,4),(3,8,18,5),(0,8,18,23),(5,8,18,28),(5,8,18,29),(3,8,19,0),(3,8,19,1),(3,8,19,2),(3,8,19,3),(3,8,19,4),(3,8,19,5),(5,8,19,29),(3,8,20,0),(3,8,20,1),(3,8,20,2),(3,8,20,3),(3,8,20,4),(3,8,20,5),(5,8,20,28),(5,8,20,29),(3,8,21,0),(3,8,21,1),(3,8,21,2),(3,8,21,3),(3,8,21,4),(5,8,21,29),(3,8,22,0),(3,8,22,1),(3,8,22,2),(14,8,22,25),(5,8,22,29),(3,8,23,0),(3,8,23,1),(3,8,23,2),(3,8,23,3),(4,8,23,9),(5,8,23,29),(3,8,24,1),(3,8,24,2),(0,8,24,4),(4,8,24,7),(4,8,24,8),(4,8,24,9),(4,8,24,10),(4,8,24,11),(5,8,24,29),(4,8,25,7),(4,8,25,8),(4,8,25,9),(4,8,25,10),(5,8,25,27),(5,8,25,29),(4,8,26,6),(4,8,26,7),(4,8,26,8),(4,8,26,9),(4,8,26,10),(2,8,26,12),(6,8,26,22),(6,8,26,23),(5,8,26,27),(5,8,26,28),(5,8,26,29),(4,8,27,5),(4,8,27,6),(4,8,27,7),(4,8,27,8),(4,8,27,9),(4,8,27,10),(5,8,27,17),(5,8,27,18),(5,8,27,21),(5,8,27,22),(6,8,27,23),(6,8,27,24),(0,8,28,4),(4,8,28,6),(4,8,28,7),(4,8,28,8),(4,8,28,9),(4,8,28,10),(5,8,28,15),(5,8,28,16),(5,8,28,17),(5,8,28,18),(5,8,28,19),(5,8,28,21),(5,8,28,22),(6,8,28,23),(6,8,28,24),(5,8,28,25),(5,8,28,26),(5,8,28,27),(5,8,28,28),(4,8,29,7),(4,8,29,8),(4,8,29,9),(4,8,29,10),(4,8,29,11),(5,8,29,16),(5,8,29,17),(5,8,29,18),(5,8,29,19),(5,8,29,20),(5,8,29,21),(5,8,29,22),(6,8,29,23),(6,8,29,24),(6,8,29,25),(6,8,29,26),(5,8,29,27),(4,10,0,10),(4,10,0,11),(4,10,0,12),(4,10,0,13),(4,10,0,14),(4,10,0,15),(4,10,0,16),(4,10,0,18),(4,10,0,19),(4,10,0,20),(4,10,0,21),(4,10,1,3),(13,10,1,9),(4,10,1,11),(4,10,1,12),(4,10,1,13),(4,10,1,14),(4,10,1,15),(4,10,1,16),(4,10,1,17),(4,10,1,18),(4,10,1,19),(4,10,1,20),(4,10,1,21),(4,10,1,22),(4,10,1,23),(3,10,1,33),(4,10,2,0),(0,10,2,1),(4,10,2,3),(4,10,2,11),(4,10,2,12),(4,10,2,13),(4,10,2,14),(4,10,2,16),(4,10,2,17),(4,10,2,18),(4,10,2,19),(4,10,2,21),(4,10,2,22),(4,10,2,23),(3,10,2,31),(3,10,2,32),(3,10,2,33),(4,10,3,0),(4,10,3,3),(4,10,3,4),(4,10,3,5),(0,10,3,6),(4,10,3,11),(4,10,3,12),(4,10,3,14),(4,10,3,15),(4,10,3,16),(4,10,3,17),(4,10,3,18),(4,10,3,19),(4,10,3,21),(4,10,3,22),(4,10,3,23),(3,10,3,29),(3,10,3,30),(3,10,3,31),(3,10,3,32),(3,10,3,33),(3,10,3,34),(3,10,3,35),(4,10,4,0),(4,10,4,1),(4,10,4,2),(4,10,4,3),(4,10,4,4),(4,10,4,5),(5,10,4,14),(5,10,4,15),(4,10,4,16),(5,10,4,17),(4,10,4,18),(4,10,4,19),(4,10,4,20),(4,10,4,21),(4,10,4,22),(4,10,4,23),(3,10,4,31),(3,10,4,32),(3,10,4,33),(3,10,4,34),(6,10,4,35),(4,10,5,1),(4,10,5,2),(4,10,5,3),(4,10,5,4),(4,10,5,5),(4,10,5,6),(4,10,5,7),(5,10,5,14),(5,10,5,15),(5,10,5,16),(5,10,5,17),(5,10,5,18),(4,10,5,19),(4,10,5,20),(4,10,5,21),(4,10,5,22),(4,10,5,23),(6,10,5,33),(6,10,5,34),(6,10,5,35),(4,10,6,1),(0,10,6,2),(4,10,6,4),(4,10,6,7),(4,10,6,8),(5,10,6,14),(5,10,6,15),(5,10,6,16),(5,10,6,17),(5,10,6,18),(5,10,6,19),(5,10,6,20),(4,10,6,21),(4,10,6,22),(4,10,6,23),(6,10,6,32),(6,10,6,33),(6,10,6,34),(6,10,6,35),(6,10,6,36),(4,10,7,0),(4,10,7,1),(4,10,7,4),(4,10,7,7),(4,10,7,8),(4,10,7,9),(5,10,7,12),(5,10,7,13),(5,10,7,14),(5,10,7,15),(5,10,7,16),(5,10,7,17),(5,10,7,18),(5,10,7,19),(4,10,7,21),(4,10,7,23),(4,10,7,24),(5,10,7,26),(6,10,7,33),(6,10,7,34),(6,10,7,36),(4,10,8,0),(6,10,8,3),(6,10,8,4),(4,10,8,7),(0,10,8,8),(5,10,8,13),(5,10,8,14),(5,10,8,15),(5,10,8,16),(5,10,8,17),(5,10,8,18),(5,10,8,21),(5,10,8,22),(5,10,8,23),(5,10,8,24),(5,10,8,25),(5,10,8,26),(6,10,8,33),(9,10,9,0),(6,10,9,4),(6,10,9,5),(6,10,9,6),(6,10,9,7),(5,10,9,13),(5,10,9,14),(5,10,9,15),(5,10,9,16),(5,10,9,17),(5,10,9,22),(5,10,9,23),(5,10,9,24),(5,10,9,25),(5,10,9,26),(5,10,9,27),(5,10,9,28),(0,10,10,4),(6,10,10,6),(6,10,10,7),(6,10,10,8),(5,10,10,13),(5,10,10,14),(5,10,10,15),(5,10,10,21),(5,10,10,22),(5,10,10,23),(5,10,10,24),(5,10,10,25),(5,10,10,26),(5,10,10,27),(6,10,11,7),(6,10,11,8),(5,10,11,13),(5,10,11,14),(5,10,11,15),(5,10,11,16),(5,10,11,21),(5,10,11,22),(6,10,11,23),(6,10,11,24),(6,10,11,25),(6,10,11,26),(5,10,11,27),(6,10,12,6),(6,10,12,7),(0,10,12,8),(5,10,12,13),(5,10,12,14),(5,10,12,15),(5,10,12,16),(3,10,12,21),(3,10,12,22),(6,10,12,26),(3,10,12,29),(3,10,12,30),(3,10,12,31),(14,10,13,0),(5,10,13,15),(5,10,13,16),(3,10,13,21),(3,10,13,22),(6,10,13,25),(6,10,13,26),(6,10,13,27),(6,10,13,28),(3,10,13,29),(3,10,13,30),(5,10,14,16),(3,10,14,22),(3,10,14,23),(6,10,14,25),(6,10,14,26),(6,10,14,27),(3,10,14,28),(3,10,14,29),(3,10,14,30),(0,10,15,12),(3,10,15,19),(3,10,15,21),(3,10,15,23),(6,10,15,25),(3,10,15,26),(3,10,15,28),(3,10,15,29),(3,10,15,30),(3,10,15,31),(12,10,16,0),(3,10,16,19),(3,10,16,21),(3,10,16,22),(3,10,16,23),(3,10,16,24),(3,10,16,25),(3,10,16,26),(3,10,16,28),(3,10,16,29),(3,10,16,30),(3,10,17,18),(3,10,17,19),(3,10,17,20),(3,10,17,21),(3,10,17,23),(3,10,17,24),(1,10,18,8),(3,10,18,18),(3,10,18,19),(3,10,18,20),(3,10,18,21),(3,10,18,22),(3,10,19,17),(3,10,19,18),(3,10,20,13),(3,10,21,12),(3,10,21,13),(5,10,22,0),(5,10,22,1),(5,10,22,2),(5,10,22,3),(5,10,22,4),(5,10,22,6),(3,10,22,12),(3,10,22,13),(3,10,22,14),(5,10,22,32),(5,10,23,0),(5,10,23,1),(5,10,23,2),(5,10,23,3),(5,10,23,4),(5,10,23,5),(5,10,23,6),(5,10,23,7),(3,10,23,13),(3,10,23,14),(3,10,23,15),(3,10,23,16),(5,10,23,31),(5,10,23,32),(5,10,23,33),(5,10,23,34),(5,10,24,1),(5,10,24,2),(2,10,24,3),(1,10,24,8),(3,10,24,11),(3,10,24,12),(3,10,24,13),(3,10,24,15),(5,10,24,30),(5,10,24,31),(5,10,24,32),(5,10,24,33),(5,10,24,34),(5,10,24,35),(5,10,24,36),(5,10,25,0),(5,10,25,1),(5,10,25,2),(3,10,25,13),(5,10,25,30),(5,10,25,31),(5,10,25,32),(5,10,25,33),(5,10,25,34),(5,10,25,35),(5,10,25,36),(5,10,26,0),(5,10,26,1),(5,10,26,2),(5,10,26,3),(5,10,26,4),(5,10,26,30),(5,10,26,31),(5,10,26,34),(5,10,26,35),(5,10,26,36),(5,19,0,19),(4,19,0,20),(4,19,0,21),(4,19,0,23),(4,19,0,24),(3,19,0,34),(3,19,0,35),(3,19,0,36),(3,19,0,37),(3,19,0,38),(3,19,0,39),(3,19,0,40),(4,19,0,50),(4,19,0,51),(4,19,0,52),(4,19,0,54),(4,19,0,55),(0,19,1,1),(0,19,1,6),(5,19,1,19),(5,19,1,20),(4,19,1,21),(4,19,1,22),(4,19,1,23),(4,19,1,24),(3,19,1,35),(3,19,1,36),(3,19,1,37),(3,19,1,38),(3,19,1,39),(4,19,1,51),(4,19,1,52),(4,19,1,53),(4,19,1,54),(4,19,1,55),(5,19,2,19),(4,19,2,20),(4,19,2,21),(4,19,2,23),(4,19,2,24),(4,19,2,25),(4,19,2,28),(4,19,2,30),(3,19,2,37),(3,19,2,39),(3,19,2,40),(3,19,2,41),(4,19,2,50),(4,19,2,51),(4,19,2,53),(4,19,2,54),(4,19,2,55),(5,19,3,19),(4,19,3,22),(4,19,3,23),(4,19,3,24),(4,19,3,25),(4,19,3,27),(4,19,3,28),(4,19,3,29),(4,19,3,30),(3,19,3,37),(3,19,3,38),(3,19,3,40),(3,19,3,41),(4,19,3,50),(4,19,3,53),(4,19,3,54),(4,19,3,55),(5,19,4,18),(5,19,4,19),(4,19,4,20),(4,19,4,21),(4,19,4,22),(3,19,4,24),(4,19,4,27),(4,19,4,28),(4,19,4,29),(4,19,4,30),(4,19,4,31),(4,19,4,32),(3,19,4,40),(3,19,4,41),(4,19,4,48),(4,19,4,50),(4,19,4,51),(4,19,4,53),(6,19,5,6),(5,19,5,17),(5,19,5,18),(5,19,5,19),(3,19,5,23),(3,19,5,24),(3,19,5,25),(3,19,5,27),(4,19,5,28),(4,19,5,31),(4,19,5,32),(4,19,5,46),(4,19,5,48),(4,19,5,49),(4,19,5,50),(4,19,5,52),(4,19,5,53),(0,19,6,4),(6,19,6,6),(0,19,6,10),(5,19,6,17),(5,19,6,18),(5,19,6,19),(3,19,6,24),(3,19,6,26),(3,19,6,27),(4,19,6,30),(4,19,6,31),(4,19,6,32),(4,19,6,46),(4,19,6,47),(4,19,6,48),(4,19,6,49),(4,19,6,50),(4,19,6,51),(6,19,7,6),(5,19,7,19),(5,19,7,20),(5,19,7,21),(3,19,7,23),(3,19,7,24),(3,19,7,25),(3,19,7,26),(3,19,7,27),(4,19,7,32),(4,19,7,33),(4,19,7,47),(4,19,7,48),(4,19,7,49),(6,19,8,4),(6,19,8,5),(6,19,8,6),(6,19,8,7),(3,19,8,22),(3,19,8,23),(3,19,8,25),(3,19,8,26),(3,19,8,27),(4,19,8,47),(3,19,9,0),(3,19,9,1),(3,19,9,2),(3,19,9,3),(6,19,9,6),(4,19,9,18),(4,19,9,19),(4,19,9,20),(3,19,9,24),(3,19,9,25),(3,19,9,27),(5,19,9,35),(4,19,9,47),(6,19,9,49),(3,19,10,0),(2,19,10,1),(1,19,10,5),(4,19,10,17),(4,19,10,18),(4,19,10,19),(4,19,10,20),(4,19,10,21),(3,19,10,27),(5,19,10,35),(5,19,10,36),(6,19,10,47),(6,19,10,48),(6,19,10,49),(6,19,10,50),(6,19,10,51),(3,19,11,0),(3,19,11,3),(4,19,11,16),(4,19,11,17),(4,19,11,18),(4,19,11,19),(4,19,11,21),(5,19,11,35),(5,19,11,36),(5,19,11,37),(5,19,11,38),(6,19,11,48),(6,19,11,49),(3,19,12,0),(3,19,12,1),(3,19,12,2),(3,19,12,3),(4,19,12,18),(4,19,12,19),(4,19,12,20),(4,19,12,21),(5,19,12,35),(5,19,12,36),(5,19,12,37),(5,19,12,38),(3,19,13,0),(3,19,13,1),(3,19,13,2),(3,19,13,3),(3,19,13,4),(3,19,13,5),(4,19,13,19),(4,19,13,20),(6,19,13,27),(5,19,13,36),(5,19,13,37),(3,19,14,0),(3,19,14,1),(3,19,14,2),(3,19,14,3),(3,19,14,5),(13,19,14,7),(5,19,14,12),(5,19,14,16),(4,19,14,19),(6,19,14,25),(6,19,14,26),(6,19,14,27),(3,19,14,28),(12,19,14,30),(5,19,14,36),(5,19,14,37),(10,19,14,51),(9,19,15,0),(0,19,15,4),(5,19,15,11),(5,19,15,12),(5,19,15,13),(5,19,15,14),(5,19,15,15),(5,19,15,16),(6,19,15,26),(6,19,15,27),(3,19,15,28),(3,19,15,29),(5,19,15,36),(6,19,15,37),(5,19,16,11),(5,19,16,12),(5,19,16,13),(5,19,16,14),(5,19,16,15),(5,19,16,16),(6,19,16,19),(3,19,16,24),(6,19,16,26),(6,19,16,27),(3,19,16,28),(6,19,16,37),(5,19,17,10),(5,19,17,11),(5,19,17,12),(5,19,17,13),(5,19,17,14),(5,19,17,15),(6,19,17,16),(6,19,17,17),(6,19,17,18),(6,19,17,19),(3,19,17,24),(3,19,17,27),(3,19,17,28),(3,19,17,29),(6,19,17,36),(6,19,17,37),(5,19,18,9),(5,19,18,10),(5,19,18,11),(5,19,18,12),(5,19,18,13),(5,19,18,15),(5,19,18,16),(5,19,18,17),(6,19,18,18),(3,19,18,24),(3,19,18,25),(3,19,18,26),(3,19,18,27),(3,19,18,28),(3,19,18,29),(6,19,18,37),(6,19,18,38),(6,19,18,39),(5,19,19,10),(5,19,19,13),(5,19,19,15),(5,19,19,16),(6,19,19,17),(6,19,19,18),(3,19,19,23),(3,19,19,24),(3,19,19,25),(3,19,19,26),(3,19,19,27),(3,19,19,28),(3,19,19,29),(6,19,19,38),(0,30,1,3),(0,30,1,7),(0,30,1,11),(6,30,2,5),(6,30,2,6),(6,30,3,6),(6,30,3,7),(6,30,3,8),(6,30,3,9),(5,30,3,10),(5,30,3,11),(5,30,3,12),(5,30,3,13),(13,30,4,4),(6,30,4,6),(6,30,4,8),(6,30,4,9),(5,30,4,10),(5,30,4,11),(5,30,4,12),(5,30,4,13),(5,30,4,14),(5,30,4,16),(6,30,5,6),(6,30,5,7),(0,30,5,8),(5,30,5,10),(5,30,5,11),(2,30,5,12),(5,30,5,14),(5,30,5,15),(5,30,5,16),(6,30,6,6),(5,30,6,10),(5,30,6,11),(5,30,6,14),(5,30,6,15),(5,30,6,16),(0,30,7,1),(6,30,7,6),(6,30,7,7),(5,30,7,8),(5,30,7,9),(5,30,7,11),(5,30,7,13),(5,30,7,14),(5,30,7,15),(5,30,7,16),(5,30,8,6),(5,30,8,7),(5,30,8,8),(5,30,8,9),(5,30,8,11),(5,30,8,12),(5,30,8,13),(5,30,8,14),(5,30,9,6),(5,30,9,7),(5,30,9,8),(5,30,9,9),(5,30,9,10),(2,30,9,12),(5,30,9,14),(13,30,10,0),(5,30,10,7),(5,30,10,8),(0,30,11,3),(6,30,11,5),(5,30,11,7),(6,30,12,5),(5,30,12,7),(1,30,12,8),(6,30,13,4),(6,30,13,5),(1,30,13,13),(6,30,14,2),(6,30,14,3),(6,30,14,4),(6,30,14,16),(6,30,15,2),(6,30,15,3),(6,30,15,4),(6,30,15,15),(6,30,15,16),(6,30,16,1),(6,30,16,2),(6,30,16,4),(6,30,16,5),(3,30,16,6),(3,30,16,7),(6,30,16,14),(6,30,16,15),(6,30,16,16),(0,30,17,3),(3,30,17,6),(3,30,17,7),(3,30,17,11),(6,30,17,12),(6,30,17,13),(6,30,17,14),(6,30,17,15),(6,30,17,16),(3,30,18,2),(3,30,18,7),(3,30,18,8),(3,30,18,9),(3,30,18,10),(3,30,18,11),(6,30,18,12),(6,30,18,15),(6,30,18,16),(3,30,19,0),(3,30,19,1),(3,30,19,2),(3,30,19,4),(3,30,19,7),(4,30,19,16),(3,30,20,1),(3,30,20,2),(3,30,20,3),(3,30,20,4),(3,30,20,5),(3,30,20,6),(3,30,20,7),(4,30,20,15),(4,30,20,16),(3,30,21,2),(4,30,21,8),(4,30,21,9),(4,30,21,10),(4,30,21,11),(4,30,21,13),(4,30,21,14),(4,30,21,15),(4,30,21,16),(4,30,22,7),(4,30,22,8),(4,30,22,9),(4,30,22,10),(4,30,22,11),(4,30,22,13),(4,30,22,14),(4,30,22,15),(4,30,22,16),(4,30,23,8),(4,30,23,9),(4,30,23,10),(4,30,23,11),(4,30,23,12),(4,30,23,13),(4,30,23,14),(4,30,23,16),(4,30,24,7),(4,30,24,8),(4,30,24,9),(4,30,24,10),(4,30,24,13),(4,30,24,16),(4,30,25,8),(4,30,26,8),(3,30,37,7),(3,30,38,7),(3,30,38,16),(3,30,39,7),(3,30,39,8),(3,30,39,9),(3,30,39,10),(3,30,39,14),(3,30,39,15),(3,30,39,16),(3,30,40,6),(3,30,40,7),(3,30,40,14),(3,30,40,15),(3,30,40,16),(3,30,41,6),(3,30,41,14),(3,30,41,15),(3,30,42,6),(3,30,42,7),(3,30,42,13),(3,30,42,14),(3,30,43,6),(3,30,43,9),(3,30,43,10),(3,30,43,11),(3,30,43,13),(8,30,44,1),(3,30,44,7),(3,30,44,8),(3,30,44,9),(3,30,44,10),(3,30,44,11),(4,30,44,13),(4,30,44,14),(3,30,45,7),(3,30,45,8),(3,30,45,10),(4,30,45,12),(4,30,45,13),(4,30,45,14),(3,30,46,10),(4,30,46,12),(4,30,46,13),(4,30,46,14),(4,30,47,13),(0,30,48,2),(9,30,48,5),(10,30,48,8),(4,30,48,12),(4,30,48,13),(4,30,49,12),(4,30,49,13),(4,30,49,14),(4,30,50,12),(4,30,50,13),(4,30,51,13),(4,30,51,14),(4,31,0,0),(4,31,0,1),(4,31,0,2),(4,31,0,3),(4,31,0,4),(4,31,0,5),(3,31,0,9),(3,31,0,10),(3,31,0,11),(3,31,0,12),(3,31,0,13),(3,31,0,14),(3,31,0,15),(3,31,0,16),(3,31,0,17),(5,31,0,20),(5,31,0,21),(5,31,0,22),(5,31,0,23),(5,31,0,24),(4,31,1,0),(0,31,1,1),(4,31,1,3),(4,31,1,4),(0,31,1,5),(0,31,1,11),(3,31,1,13),(3,31,1,14),(0,31,1,15),(3,31,1,17),(5,31,1,20),(5,31,1,21),(0,31,1,22),(4,31,1,24),(4,31,2,0),(4,31,2,3),(3,31,2,13),(3,31,2,14),(3,31,2,17),(3,31,2,18),(4,31,2,21),(4,31,2,24),(4,31,3,0),(4,31,3,1),(3,31,3,12),(3,31,3,13),(3,31,3,14),(3,31,3,15),(3,31,3,16),(3,31,3,17),(4,31,3,18),(4,31,3,21),(4,31,3,22),(4,31,3,23),(4,31,3,24),(10,31,4,0),(6,31,4,12),(8,31,4,14),(4,31,4,17),(4,31,4,18),(3,31,4,19),(3,31,4,20),(4,31,4,21),(4,31,4,22),(4,31,4,23),(4,31,4,24),(11,31,5,4),(6,31,5,12),(6,31,5,13),(4,31,5,17),(0,31,5,18),(3,31,5,20),(3,31,5,21),(1,31,5,22),(4,31,5,24),(6,31,6,11),(6,31,6,12),(4,31,6,17),(3,31,6,20),(3,31,6,21),(4,31,6,24),(4,31,7,15),(4,31,7,16),(4,31,7,17),(4,31,7,18),(4,31,7,19),(3,31,7,20),(3,31,7,21),(3,31,7,22),(3,31,7,23),(3,31,7,24),(10,31,8,0),(4,31,8,15),(4,31,8,16),(5,31,8,17),(5,31,8,18),(5,31,8,19),(5,31,8,20),(5,31,8,21),(3,31,8,22),(14,31,9,5),(14,31,9,11),(4,31,9,15),(5,31,9,16),(5,31,9,17),(8,31,9,18),(0,31,9,22),(5,31,10,16),(5,31,11,16),(4,31,11,22),(4,31,11,23),(5,31,12,1),(5,31,12,2),(11,31,12,4),(3,31,12,11),(3,31,12,12),(4,31,12,21),(4,31,12,22),(5,31,13,0),(5,31,13,1),(5,31,13,2),(5,31,13,3),(3,31,13,10),(3,31,13,11),(3,31,13,12),(3,31,13,13),(3,31,13,14),(4,31,13,19),(4,31,13,20),(4,31,13,21),(2,31,13,22),(5,31,13,24),(5,31,14,0),(3,31,14,1),(5,31,14,2),(5,31,14,3),(3,31,14,10),(4,31,14,11),(3,31,14,12),(3,31,14,13),(4,31,14,20),(4,31,14,21),(5,31,14,24),(3,31,15,0),(3,31,15,1),(4,31,15,10),(4,31,15,11),(3,31,15,12),(3,31,15,13),(4,31,15,20),(4,31,15,21),(5,31,15,22),(5,31,15,23),(5,31,15,24),(3,31,16,0),(3,31,16,1),(3,31,16,2),(3,31,16,3),(3,31,16,4),(4,31,16,9),(4,31,16,10),(4,31,16,11),(4,31,16,12),(4,31,16,13),(4,31,16,20),(4,31,16,21),(5,31,16,22),(5,31,16,24),(3,31,17,0),(4,31,17,10),(4,31,17,11),(4,31,17,12),(4,31,17,13),(5,31,17,23),(5,31,17,24),(3,31,18,0),(3,31,18,1),(5,31,18,8),(5,31,18,9),(5,31,18,10),(4,31,18,11),(3,31,19,0),(5,31,19,7),(5,31,19,8),(5,31,19,9),(5,31,19,10),(6,31,19,14),(6,31,20,8),(5,31,20,10),(5,31,20,11),(6,31,20,12),(6,31,20,13),(6,31,20,14),(6,31,20,15),(6,31,21,7),(6,31,21,8),(6,31,21,9),(6,31,21,10),(3,31,21,15),(3,31,21,16),(3,31,21,17),(3,31,22,12),(3,31,22,13),(3,31,22,14),(3,31,22,15),(3,31,22,16),(6,31,22,18),(6,31,22,23),(6,31,22,24),(3,31,23,14),(3,31,23,15),(3,31,23,16),(3,31,23,17),(6,31,23,18),(6,31,23,19),(6,31,23,23),(6,31,23,24),(6,31,24,18),(6,31,24,19),(6,31,24,23),(12,43,0,8),(13,43,0,14),(6,43,0,21),(6,43,0,23),(6,43,0,24),(5,43,0,25),(5,43,0,26),(5,43,0,27),(5,43,0,28),(5,43,0,29),(5,43,0,30),(6,43,1,19),(6,43,1,20),(6,43,1,21),(6,43,1,22),(6,43,1,23),(6,43,1,24),(5,43,1,25),(5,43,1,26),(5,43,1,27),(5,43,1,28),(5,43,1,29),(0,43,1,30),(0,43,1,36),(6,43,2,19),(6,43,2,21),(6,43,2,22),(6,43,2,23),(6,43,2,24),(5,43,2,25),(5,43,2,26),(5,43,2,27),(0,43,3,4),(6,43,3,19),(6,43,3,22),(6,43,3,23),(6,43,3,24),(5,43,3,26),(5,43,3,27),(5,43,3,28),(5,43,3,29),(10,43,4,20),(5,43,4,26),(5,43,4,27),(5,43,4,28),(5,43,4,29),(2,43,5,25),(5,43,5,27),(6,43,5,28),(3,43,6,10),(6,43,6,27),(6,43,6,28),(2,43,6,29),(8,43,6,32),(1,43,6,36),(0,43,7,4),(3,43,7,10),(13,43,7,14),(6,43,7,24),(6,43,7,25),(6,43,7,26),(6,43,7,27),(6,43,7,28),(3,43,8,10),(3,43,8,11),(11,43,8,20),(6,43,8,26),(6,43,8,27),(6,43,8,28),(3,43,9,6),(3,43,9,8),(3,43,9,9),(3,43,9,10),(3,43,9,11),(3,43,9,12),(6,43,9,26),(6,43,9,27),(3,43,10,6),(3,43,10,7),(3,43,10,8),(3,43,10,9),(3,43,10,10),(3,43,10,11),(8,43,10,16),(6,43,10,26),(6,43,10,27),(0,43,10,34),(3,43,11,6),(3,43,11,7),(3,43,11,8),(3,43,11,9),(3,43,11,10),(3,43,11,11),(6,43,11,27),(3,43,12,6),(3,43,12,8),(3,43,12,9),(4,43,12,10),(3,43,12,11),(3,43,12,20),(3,43,12,21),(3,43,12,22),(3,43,12,23),(3,43,12,24),(6,43,12,26),(6,43,12,27),(3,43,13,5),(3,43,13,6),(3,43,13,8),(4,43,13,9),(4,43,13,10),(4,43,13,11),(3,43,13,17),(3,43,13,18),(3,43,13,19),(3,43,13,20),(3,43,13,21),(3,43,13,22),(3,43,13,23),(3,43,13,24),(3,43,13,25),(3,43,13,26),(3,43,13,27),(4,43,14,10),(4,43,14,11),(4,43,14,12),(4,43,14,13),(4,43,14,15),(3,43,14,19),(3,43,14,22),(3,43,14,23),(3,43,14,24),(3,43,14,25),(0,43,14,35),(5,43,15,5),(5,43,15,8),(4,43,15,10),(4,43,15,11),(4,43,15,12),(4,43,15,13),(4,43,15,14),(4,43,15,15),(4,43,15,16),(4,43,15,17),(3,43,15,22),(3,43,15,25),(5,43,16,4),(5,43,16,5),(5,43,16,6),(5,43,16,7),(5,43,16,8),(4,43,16,10),(4,43,16,11),(4,43,16,12),(4,43,16,13),(4,43,16,14),(4,43,16,15),(4,43,16,16),(3,43,16,22),(3,43,16,23),(3,43,16,24),(3,43,16,25),(3,43,16,26),(5,43,17,4),(5,43,17,5),(5,43,17,6),(5,43,17,7),(4,43,17,8),(4,43,17,9),(4,43,17,10),(4,43,17,11),(4,43,17,12),(4,43,17,13),(4,43,17,14),(4,43,17,16),(3,43,17,26),(5,43,18,3),(5,43,18,4),(5,43,18,5),(5,43,18,6),(4,43,18,8),(4,43,18,9),(4,43,18,10),(4,43,18,11),(4,43,18,12),(4,43,18,13),(4,43,18,14),(4,43,18,15),(4,43,18,16),(4,43,18,17),(4,43,18,18),(4,43,18,19),(5,43,19,4),(5,43,19,5),(5,43,19,6),(5,43,19,7),(4,43,19,8),(0,43,19,9),(4,43,19,11),(4,43,19,12),(4,43,19,13),(4,43,19,14),(4,43,20,0),(4,43,20,2),(4,43,20,4),(5,43,20,5),(5,43,20,6),(5,43,20,7),(6,43,20,11),(6,43,20,12),(4,43,20,14),(3,43,20,27),(3,43,20,28),(4,43,21,0),(4,43,21,1),(4,43,21,2),(4,43,21,3),(4,43,21,4),(4,43,21,5),(5,43,21,6),(4,43,21,7),(6,43,21,11),(6,43,21,12),(6,43,21,13),(6,43,21,14),(6,43,21,15),(3,43,21,27),(3,43,21,29),(3,43,21,30),(3,43,21,31),(4,43,22,0),(4,43,22,1),(4,43,22,2),(4,43,22,4),(4,43,22,5),(4,43,22,6),(4,43,22,7),(4,43,22,8),(6,43,22,10),(6,43,22,11),(6,43,22,12),(6,43,22,13),(6,43,22,14),(3,43,22,25),(3,43,22,26),(3,43,22,27),(3,43,22,29),(4,43,23,0),(4,43,23,1),(4,43,23,2),(4,43,23,3),(4,43,23,4),(4,43,23,5),(4,43,23,6),(4,43,23,7),(4,43,23,8),(6,43,23,12),(6,43,23,13),(3,43,23,25),(3,43,23,27),(3,43,23,28),(3,43,23,29),(3,43,23,30),(4,43,24,1),(4,43,24,2),(4,43,24,3),(4,43,24,5),(4,43,24,6),(4,43,24,7),(4,43,24,8),(6,43,24,11),(6,43,24,12),(6,43,24,13),(3,43,24,26),(3,43,24,27),(3,43,24,28),(3,43,24,29),(4,43,25,1),(4,43,25,2),(4,43,25,3),(4,43,25,4),(4,43,25,5),(4,43,25,6),(4,43,25,7),(4,43,25,8),(5,43,25,9),(6,43,25,13),(3,43,25,26),(3,43,25,27),(3,43,25,28),(3,43,25,29),(4,43,26,1),(4,43,26,2),(4,43,26,3),(4,43,26,4),(4,43,26,5),(4,43,26,7),(5,43,26,9),(3,43,26,24),(3,43,26,25),(3,43,26,26),(3,43,26,27),(3,43,26,29),(3,43,26,30),(4,43,27,0),(4,43,27,1),(4,43,27,3),(4,43,27,4),(4,43,27,5),(4,43,27,6),(4,43,27,7),(4,43,27,8),(5,43,27,9),(5,43,27,10),(5,43,27,12),(6,43,27,28),(6,43,27,29),(4,43,28,0),(4,43,28,1),(4,43,28,2),(4,43,28,3),(4,43,28,4),(4,43,28,6),(4,43,28,7),(4,43,28,8),(5,43,28,9),(5,43,28,10),(5,43,28,11),(5,43,28,12),(5,43,28,13),(6,43,28,28),(6,43,28,29),(6,43,28,30),(6,43,28,31),(6,43,28,32),(4,43,29,4),(4,43,29,5),(4,43,29,6),(4,43,29,7),(4,43,29,8),(5,43,29,9),(5,43,29,10),(5,43,29,11),(5,43,29,12),(5,43,29,13),(6,43,29,27),(6,43,29,28),(6,43,29,29),(6,43,29,30),(6,43,29,31),(4,43,30,5),(4,43,30,6),(4,43,30,7),(4,43,30,8),(4,43,30,9),(5,43,30,10),(5,43,30,11),(5,43,30,12),(6,43,30,26),(6,43,30,27),(6,43,30,29),(6,43,30,30),(4,43,31,4),(4,43,31,5),(4,43,31,6),(4,43,31,7),(4,43,31,8),(4,43,31,9),(4,43,31,10),(5,43,31,11),(5,43,31,12),(5,43,31,13),(5,43,31,14),(3,43,31,22),(3,43,31,26),(6,43,31,27),(6,43,31,29),(4,43,32,4),(4,43,32,6),(4,43,32,7),(4,43,32,8),(4,43,32,9),(4,43,32,10),(4,43,32,11),(5,43,32,13),(3,43,32,14),(3,43,32,15),(3,43,32,21),(3,43,32,22),(3,43,32,23),(3,43,32,24),(3,43,32,26),(3,43,32,27),(4,43,33,6),(4,43,33,7),(4,43,33,8),(4,43,33,9),(3,43,33,11),(3,43,33,13),(3,43,33,14),(3,43,33,16),(3,43,33,17),(3,43,33,18),(3,43,33,19),(3,43,33,20),(3,43,33,22),(3,43,33,23),(3,43,33,24),(3,43,33,26),(4,43,34,6),(4,43,34,9),(3,43,34,11),(3,43,34,12),(3,43,34,13),(3,43,34,14),(3,43,34,15),(3,43,34,16),(3,43,34,17),(3,43,34,18),(3,43,34,19),(3,43,34,24),(3,43,34,25),(3,43,34,26),(4,43,35,6),(4,43,35,7),(4,43,35,9),(3,43,35,12),(3,43,35,13),(3,43,35,14),(3,43,35,15),(3,43,35,16),(3,43,35,17),(3,43,35,18),(3,43,35,19),(3,43,35,22),(3,43,35,23),(3,43,35,24),(3,43,35,25),(3,43,35,26),(3,43,35,27),(4,43,36,6),(4,43,36,7),(3,43,36,16),(3,43,36,23),(3,43,36,24),(3,43,36,25),(3,43,36,26),(4,43,37,6),(3,43,37,16),(3,43,37,24),(3,43,37,25),(3,43,38,23),(3,43,38,24),(10,52,1,6),(10,52,1,10),(11,52,1,18),(0,52,3,3),(8,52,6,5),(11,52,6,8),(12,52,6,18),(2,52,7,26),(3,52,8,4),(3,52,9,4),(3,52,9,5),(3,52,10,2),(0,52,10,3),(3,52,10,5),(3,52,10,6),(3,52,10,7),(3,52,10,10),(3,52,10,12),(4,52,10,14),(4,52,10,15),(4,52,10,16),(4,52,10,17),(3,52,11,2),(3,52,11,5),(3,52,11,6),(3,52,11,7),(3,52,11,8),(3,52,11,10),(3,52,11,11),(3,52,11,12),(4,52,11,13),(4,52,11,14),(4,52,11,15),(4,52,11,16),(4,52,11,17),(1,52,11,26),(3,52,12,2),(3,52,12,3),(3,52,12,4),(3,52,12,5),(3,52,12,6),(3,52,12,10),(3,52,12,11),(3,52,12,12),(3,52,12,13),(4,52,12,14),(4,52,12,15),(4,52,12,16),(4,52,12,17),(9,52,12,18),(3,52,13,3),(3,52,13,4),(3,52,13,6),(3,52,13,9),(3,52,13,10),(3,52,13,11),(3,52,13,12),(3,52,13,13),(3,52,13,14),(3,52,13,15),(4,52,13,16),(4,52,13,17),(3,52,14,2),(3,52,14,3),(3,52,14,4),(3,52,14,5),(3,52,14,6),(3,52,14,7),(6,52,14,8),(3,52,14,11),(3,52,14,12),(3,52,14,13),(3,52,14,14),(4,52,14,15),(4,52,14,16),(4,52,14,17),(0,52,14,22),(3,52,15,3),(3,52,15,4),(6,52,15,6),(6,52,15,7),(6,52,15,8),(6,52,15,9),(3,52,15,10),(3,52,15,11),(3,52,15,12),(3,52,15,13),(3,52,15,14),(4,52,15,15),(4,52,15,16),(4,52,15,17),(1,52,15,26),(0,52,16,2),(3,52,16,4),(6,52,16,5),(6,52,16,6),(6,52,16,7),(6,52,16,8),(3,52,16,11),(3,52,16,12),(3,52,16,13),(3,52,16,14),(3,52,16,15),(4,52,16,16),(4,52,16,17),(8,52,16,18),(3,52,17,4),(6,52,17,6),(6,52,17,7),(6,52,17,8),(3,52,17,11),(3,52,17,12),(3,52,17,13),(3,52,17,14),(6,52,17,15),(4,52,17,17),(3,52,18,12),(3,52,18,13),(6,52,18,14),(6,52,18,15),(6,52,18,16),(6,52,18,17),(3,52,19,10),(3,52,19,11),(3,52,19,12),(6,52,19,14),(6,52,19,15),(6,52,19,16),(6,52,19,17),(0,52,20,2),(3,52,20,8),(3,52,20,9),(3,52,20,10),(3,52,20,11),(3,52,20,12),(3,52,20,13),(6,52,20,14),(6,52,20,15),(6,52,20,17),(5,52,20,22),(5,52,20,23),(5,52,20,24),(5,52,20,25),(0,52,21,7),(3,52,21,11),(3,52,21,12),(3,52,21,13),(5,52,21,22),(5,52,21,24),(5,52,21,25),(5,52,21,26),(5,52,21,27),(3,52,22,12),(3,52,22,13),(5,52,22,22),(5,52,22,23),(5,52,22,24),(5,52,22,25),(5,52,22,26),(3,52,23,10),(3,52,23,11),(3,52,23,12),(3,52,23,13),(6,52,23,22),(5,52,23,23),(5,52,23,24),(5,52,23,25),(5,52,24,3),(5,52,24,4),(3,52,24,10),(3,52,24,12),(3,52,24,13),(3,52,24,14),(6,52,24,21),(6,52,24,22),(6,52,24,23),(4,52,24,24),(4,52,24,25),(4,52,24,26),(5,52,25,0),(5,52,25,1),(5,52,25,3),(5,52,25,4),(3,52,25,12),(3,52,25,13),(6,52,25,21),(6,52,25,22),(4,52,25,23),(4,52,25,24),(5,52,26,0),(5,52,26,1),(5,52,26,2),(5,52,26,3),(6,52,26,20),(6,52,26,21),(4,52,26,22),(4,52,26,23),(4,52,26,24),(5,52,27,0),(5,52,27,1),(5,52,27,2),(0,52,27,3),(6,52,27,19),(6,52,27,20),(6,52,27,21),(4,52,27,22),(4,52,27,23),(4,52,27,24),(4,52,27,25),(4,52,27,26),(3,52,27,27),(5,52,28,0),(5,52,28,1),(5,52,28,2),(6,52,28,19),(4,52,28,20),(4,52,28,21),(4,52,28,22),(4,52,28,24),(4,52,28,25),(3,52,28,27),(3,52,28,28),(3,52,29,0),(5,52,29,1),(4,52,29,20),(4,52,29,21),(4,52,29,22),(4,52,29,24),(3,52,29,25),(3,52,29,26),(3,52,29,27),(3,52,30,0),(3,52,30,1),(5,52,30,2),(5,52,30,3),(5,52,30,4),(5,52,30,11),(4,52,30,16),(4,52,30,17),(4,52,30,21),(3,52,30,24),(3,52,30,25),(3,52,30,26),(3,52,30,27),(3,52,30,28),(3,52,31,0),(5,52,31,1),(5,52,31,2),(5,52,31,9),(5,52,31,11),(5,52,31,12),(4,52,31,15),(4,52,31,16),(4,52,31,17),(4,52,31,18),(4,52,31,21),(3,52,31,24),(3,52,31,25),(3,52,31,26),(3,52,31,27),(3,52,31,28),(5,52,32,0),(5,52,32,1),(5,52,32,2),(5,52,32,3),(5,52,32,4),(5,52,32,7),(5,52,32,8),(5,52,32,9),(5,52,32,10),(5,52,32,11),(5,52,32,12),(4,52,32,13),(4,52,32,14),(4,52,32,15),(4,52,32,16),(4,52,32,17),(4,52,32,18),(6,52,32,21),(3,52,32,24),(3,52,32,25),(3,52,32,26),(3,52,32,27),(3,52,32,28),(5,52,33,0),(5,52,33,1),(0,52,33,2),(4,52,33,7),(5,52,33,8),(5,52,33,9),(5,52,33,10),(5,52,33,11),(5,52,33,14),(4,52,33,15),(4,52,33,16),(4,52,33,17),(4,52,33,18),(4,52,33,19),(4,52,33,20),(6,52,33,21),(3,52,33,25),(3,52,33,26),(3,52,33,27),(3,52,33,28),(5,52,34,0),(5,52,34,1),(4,52,34,6),(4,52,34,7),(4,52,34,8),(5,52,34,10),(5,52,34,11),(5,52,34,12),(5,52,34,13),(5,52,34,14),(5,52,34,15),(4,52,34,16),(4,52,34,17),(4,52,34,19),(6,52,34,20),(6,52,34,21),(6,52,34,22),(3,52,34,25),(3,52,34,27),(3,52,34,28),(5,52,35,0),(5,52,35,1),(5,52,35,2),(4,52,35,4),(4,52,35,5),(4,52,35,6),(3,52,35,7),(4,52,35,8),(4,52,35,9),(5,52,35,11),(5,52,35,12),(5,52,35,13),(5,52,35,14),(5,52,35,15),(4,52,35,17),(6,52,35,20),(6,52,35,22),(3,52,35,27),(3,52,35,28),(14,52,36,2),(4,52,36,6),(4,52,36,7),(4,52,36,8),(4,52,36,10),(4,52,36,11),(5,52,36,13),(5,52,36,14),(3,52,36,15),(4,52,36,16),(4,52,36,17),(6,52,36,20),(6,52,36,21),(6,52,36,22),(4,52,37,6),(4,52,37,7),(4,52,37,8),(4,52,37,9),(4,52,37,10),(4,52,37,11),(5,52,37,12),(5,52,37,13),(5,52,37,14),(5,52,37,15),(5,52,37,16),(6,52,37,22),(4,52,38,6),(4,52,38,7),(4,52,38,9),(4,52,38,10),(5,52,38,12),(6,52,38,22);
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
) ENGINE=InnoDB AUTO_INCREMENT=415 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `units`
--

LOCK TABLES `units` WRITE;
/*!40000 ALTER TABLE `units` DISABLE KEYS */;
INSERT INTO `units` VALUES (1,1590,1,1,1,NULL,NULL,NULL,NULL,0,0,'Thor',0,3,0,NULL,1,0,0,0),(2,1590,1,1,1,NULL,NULL,NULL,NULL,0,0,'Thor',1,3,0,NULL,1,0,0,0),(3,1200,1,1,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,3,0,NULL,1,0,0,0),(4,1200,1,1,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,3,0,NULL,1,0,0,0),(5,1200,1,1,1,NULL,NULL,NULL,NULL,0,0,'Dirac',0,3,0,NULL,1,0,0,0),(6,2500,1,1,1,NULL,NULL,NULL,NULL,0,0,'Demosis',0,0,270,NULL,1,0,0,0),(7,1590,1,1,1,NULL,NULL,NULL,NULL,0,0,'Thor',0,0,270,NULL,1,0,0,0),(8,1590,1,1,1,NULL,NULL,NULL,NULL,0,0,'Thor',1,0,270,NULL,1,0,0,0),(9,1200,1,1,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,0,270,NULL,1,0,0,0),(10,1200,1,1,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,0,270,NULL,1,0,0,0),(11,1200,1,1,1,NULL,NULL,NULL,NULL,0,0,'Dirac',0,0,270,NULL,1,0,0,0),(12,140,1,1,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(13,120,1,1,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(14,120,1,1,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(15,140,1,2,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(16,120,1,2,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(17,140,1,3,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(18,120,1,3,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(19,140,1,4,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(20,120,1,4,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(21,120,1,4,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(22,140,1,5,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(23,120,1,5,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(24,140,1,6,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(25,120,1,6,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(26,140,1,6,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(27,120,1,6,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(28,120,1,6,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(29,140,1,7,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(30,120,1,7,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(31,120,1,7,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(32,140,1,7,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(33,120,1,7,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(34,120,1,8,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(35,140,1,8,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(36,120,1,8,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(37,120,1,8,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(38,140,1,9,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(39,120,1,9,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(40,120,1,10,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(41,120,1,11,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(42,120,1,11,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(43,120,1,12,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(44,120,1,12,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(45,140,1,12,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(46,120,1,12,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(47,120,1,12,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(48,140,1,13,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(49,120,1,13,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(50,120,1,13,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(51,140,1,13,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(52,120,1,13,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(53,120,1,13,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(54,120,1,14,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(55,120,1,14,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(56,120,1,14,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(57,120,1,14,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(58,120,1,15,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(59,120,1,15,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(60,140,1,15,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(61,120,1,15,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(62,120,1,15,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(63,120,1,16,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(64,120,1,16,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(65,120,1,16,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(66,120,1,16,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(67,120,1,17,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(68,120,1,17,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(69,120,1,17,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(70,120,1,17,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(71,140,1,18,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(72,120,1,18,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(73,120,1,18,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(74,140,1,18,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(75,120,1,18,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(76,120,1,18,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(77,120,1,19,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(78,120,1,19,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(79,120,1,19,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(80,120,1,19,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(81,120,1,20,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(82,120,1,20,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(83,120,1,20,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(84,140,1,21,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(85,120,1,21,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(86,120,1,21,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(87,140,1,21,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(88,120,1,21,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(89,120,1,21,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(90,120,1,22,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(91,120,1,22,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(92,140,1,22,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(93,120,1,22,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(94,120,1,22,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(95,120,1,26,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(96,120,1,26,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(97,120,1,26,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(98,140,1,26,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(99,120,1,26,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(100,120,1,26,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(101,140,1,30,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(102,140,1,30,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(103,120,1,30,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(104,140,1,30,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(105,120,1,30,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(106,120,1,30,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(107,140,1,30,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(108,120,1,30,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(109,140,1,30,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(110,120,1,30,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(111,140,1,30,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(112,120,1,30,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(113,120,1,30,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(114,2500,1,2,1,NULL,NULL,NULL,NULL,0,0,'Demosis',0,2,90,NULL,1,0,0,0),(115,2500,1,2,1,NULL,NULL,NULL,NULL,0,0,'Demosis',0,2,90,NULL,1,0,0,0),(116,1200,1,2,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,2,90,NULL,1,0,0,0),(117,1200,1,2,1,NULL,NULL,NULL,NULL,0,0,'Dirac',0,2,90,NULL,1,0,0,0),(118,140,1,34,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(119,120,1,34,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(120,120,1,34,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(121,140,1,35,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(122,120,1,35,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(123,120,1,35,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(124,140,1,36,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(125,120,1,36,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(126,120,1,36,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(127,140,1,37,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(128,120,1,37,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(129,140,1,37,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(130,120,1,37,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(131,120,1,37,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(132,140,1,38,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(133,120,1,38,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(134,140,1,39,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(135,140,1,39,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(136,120,1,39,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(137,140,1,39,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(138,120,1,39,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(139,120,1,39,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(140,140,1,40,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(141,120,1,40,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(142,120,1,40,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(143,120,1,41,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(144,120,1,41,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(145,120,1,42,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(146,120,1,42,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(147,120,1,43,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(148,120,1,44,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(149,120,1,44,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(150,1590,1,2,1,NULL,NULL,NULL,NULL,0,0,'Thor',0,2,60,NULL,1,0,0,0),(151,1200,1,2,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,2,60,NULL,1,0,0,0),(152,1200,1,2,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,2,60,NULL,1,0,0,0),(153,1200,1,2,1,NULL,NULL,NULL,NULL,0,0,'Dirac',0,2,60,NULL,1,0,0,0),(154,2500,1,2,1,NULL,NULL,NULL,NULL,0,0,'Demosis',0,1,0,NULL,1,0,0,0),(155,1590,1,2,1,NULL,NULL,NULL,NULL,0,0,'Thor',0,1,0,NULL,1,0,0,0),(156,1200,1,2,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,1,0,NULL,1,0,0,0),(157,1200,1,2,1,NULL,NULL,NULL,NULL,0,0,'Dirac',0,1,0,NULL,1,0,0,0),(158,140,1,45,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(159,120,1,45,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(160,120,1,45,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(161,120,1,46,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(162,140,1,47,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(163,120,1,47,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(164,120,1,47,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(165,120,1,48,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(166,140,1,48,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(167,120,1,48,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(168,120,1,48,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(169,140,1,49,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(170,120,1,49,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(171,120,1,49,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(172,120,1,50,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(173,140,1,50,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(174,120,1,50,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(175,120,1,50,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(176,140,1,50,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(177,120,1,50,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(178,120,1,50,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(179,120,1,51,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(180,140,1,51,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(181,120,1,51,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(182,120,1,51,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(183,140,1,51,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(184,120,1,51,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(185,120,1,51,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(186,120,1,52,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(187,140,1,52,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(188,120,1,52,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(189,140,1,53,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(190,120,1,53,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(191,120,1,54,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(192,120,1,54,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(193,120,1,55,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(194,120,1,55,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(195,120,1,56,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(196,120,1,56,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(197,2500,1,2,1,NULL,NULL,NULL,NULL,0,0,'Demosis',0,2,270,NULL,1,0,0,0),(198,2500,1,2,1,NULL,NULL,NULL,NULL,0,0,'Demosis',0,2,270,NULL,1,0,0,0),(199,1200,1,2,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,2,270,NULL,1,0,0,0),(200,1200,1,2,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,2,270,NULL,1,0,0,0),(201,1200,1,2,1,NULL,NULL,NULL,NULL,0,0,'Dirac',0,2,270,NULL,1,0,0,0),(202,2500,1,3,1,NULL,NULL,NULL,NULL,0,0,'Demosis',0,1,45,NULL,1,0,0,0),(203,2500,1,3,1,NULL,NULL,NULL,NULL,0,0,'Demosis',0,1,45,NULL,1,0,0,0),(204,1590,1,3,1,NULL,NULL,NULL,NULL,0,0,'Thor',0,1,45,NULL,1,0,0,0),(205,1200,1,3,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,1,45,NULL,1,0,0,0),(206,1200,1,3,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,1,45,NULL,1,0,0,0),(207,1200,1,3,1,NULL,NULL,NULL,NULL,0,0,'Dirac',0,1,45,NULL,1,0,0,0),(208,2500,1,3,1,NULL,NULL,NULL,NULL,0,0,'Demosis',0,1,315,NULL,1,0,0,0),(209,2500,1,3,1,NULL,NULL,NULL,NULL,0,0,'Demosis',0,1,315,NULL,1,0,0,0),(210,1590,1,3,1,NULL,NULL,NULL,NULL,0,0,'Thor',0,1,315,NULL,1,0,0,0),(211,1200,1,3,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,1,315,NULL,1,0,0,0),(212,1200,1,3,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,1,315,NULL,1,0,0,0),(213,1200,1,3,1,NULL,NULL,NULL,NULL,0,0,'Dirac',0,1,315,NULL,1,0,0,0),(214,120,1,57,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(215,120,1,57,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(216,120,1,58,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(217,120,1,58,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(218,140,1,59,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(219,120,1,59,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(220,120,1,59,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(221,120,1,60,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(222,120,1,60,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(223,140,1,61,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(224,120,1,61,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(225,120,1,61,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(226,140,1,62,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(227,120,1,62,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(228,120,1,62,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(229,140,1,63,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(230,120,1,63,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(231,140,1,63,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(232,120,1,63,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(233,120,1,63,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(234,120,1,64,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(235,120,1,64,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(236,120,1,64,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(237,120,1,65,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(238,140,1,65,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(239,120,1,65,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(240,140,1,65,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(241,120,1,65,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(242,120,1,65,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(243,120,1,66,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(244,140,1,66,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(245,120,1,66,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(246,140,1,66,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(247,120,1,66,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(248,140,1,66,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(249,120,1,66,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(250,120,1,66,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(251,120,1,67,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(252,140,1,67,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(253,140,1,67,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(254,120,1,67,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(255,140,1,67,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(256,120,1,67,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(257,120,1,67,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(258,120,1,68,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(259,120,1,68,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(260,120,1,68,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(261,140,1,69,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(262,120,1,69,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(263,120,1,69,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(264,120,1,70,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(265,120,1,70,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(266,120,1,71,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(267,120,1,71,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(268,120,1,72,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(269,120,1,72,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(270,120,1,73,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(271,140,1,74,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(272,120,1,74,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(273,140,1,75,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(274,120,1,75,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(275,140,1,76,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(276,120,1,76,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(277,120,1,76,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(278,140,1,77,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(279,120,1,77,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(280,120,1,77,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(281,140,1,78,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(282,120,1,78,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(283,140,1,78,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(284,140,1,78,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(285,120,1,78,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(286,120,1,78,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(287,120,1,79,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(288,120,1,79,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(289,120,1,80,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(290,120,1,80,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(291,120,1,81,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(292,120,1,81,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(293,120,1,82,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(294,120,1,82,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(295,2500,1,4,1,NULL,NULL,NULL,NULL,0,0,'Demosis',0,2,90,NULL,1,0,0,0),(296,1590,1,4,1,NULL,NULL,NULL,NULL,0,0,'Thor',0,2,90,NULL,1,0,0,0),(297,1200,1,4,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,2,90,NULL,1,0,0,0),(298,1200,1,4,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,2,90,NULL,1,0,0,0),(299,1200,1,4,1,NULL,NULL,NULL,NULL,0,0,'Dirac',0,2,90,NULL,1,0,0,0),(300,2500,1,4,1,NULL,NULL,NULL,NULL,0,0,'Demosis',0,3,202,NULL,1,0,0,0),(301,1590,1,4,1,NULL,NULL,NULL,NULL,0,0,'Thor',0,3,202,NULL,1,0,0,0),(302,1590,1,4,1,NULL,NULL,NULL,NULL,0,0,'Thor',1,3,202,NULL,1,0,0,0),(303,1200,1,4,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,3,202,NULL,1,0,0,0),(304,1200,1,4,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,3,202,NULL,1,0,0,0),(305,1200,1,4,1,NULL,NULL,NULL,NULL,0,0,'Dirac',0,3,202,NULL,1,0,0,0),(306,140,1,83,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(307,120,1,83,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(308,120,1,83,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(309,140,1,84,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(310,120,1,84,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(311,140,1,85,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(312,120,1,85,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(313,120,1,85,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(314,140,1,86,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(315,120,1,86,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(316,140,1,87,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(317,120,1,87,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(318,120,1,87,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(319,140,1,87,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(320,120,1,87,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(321,120,1,87,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(322,120,1,88,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(323,140,1,88,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(324,120,1,88,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(325,140,1,88,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(326,120,1,88,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(327,120,1,88,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(328,120,1,89,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(329,140,1,89,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(330,120,1,89,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(331,140,1,89,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(332,140,1,89,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(333,120,1,89,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(334,120,1,90,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(335,140,1,90,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(336,120,1,90,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(337,140,1,90,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(338,140,1,90,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(339,120,1,90,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(340,120,1,90,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(341,120,1,91,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(342,140,1,91,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(343,120,1,91,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(344,140,1,91,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(345,120,1,91,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(346,120,1,91,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(347,120,1,91,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(348,140,1,92,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(349,120,1,92,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(350,120,1,92,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(351,120,1,93,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(352,120,1,93,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(353,120,1,94,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(354,120,1,94,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(355,120,1,95,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(356,120,1,95,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(357,1590,1,4,1,NULL,NULL,NULL,NULL,0,0,'Thor',0,2,30,NULL,1,0,0,0),(358,1200,1,4,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,2,30,NULL,1,0,0,0),(359,1200,1,4,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,2,30,NULL,1,0,0,0),(360,1200,1,4,1,NULL,NULL,NULL,NULL,0,0,'Dirac',0,2,30,NULL,1,0,0,0),(361,1590,1,4,1,NULL,NULL,NULL,NULL,0,0,'Thor',1,2,180,NULL,1,0,0,0),(362,1200,1,4,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,2,180,NULL,1,0,0,0),(363,1200,1,4,1,NULL,NULL,NULL,NULL,0,0,'Dirac',0,2,180,NULL,1,0,0,0),(364,140,1,96,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(365,120,1,96,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(366,120,1,96,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(367,140,1,97,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(368,120,1,97,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(369,120,1,97,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(370,140,1,98,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(371,120,1,98,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(372,120,1,98,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(373,140,1,99,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(374,120,1,99,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(375,140,1,100,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(376,120,1,100,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(377,120,1,100,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(378,140,1,101,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(379,120,1,101,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(380,120,1,101,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(381,140,1,102,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(382,140,1,102,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(383,120,1,102,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(384,140,1,103,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(385,120,1,103,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(386,140,1,103,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(387,140,1,103,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(388,120,1,103,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(389,120,1,103,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(390,120,1,104,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(391,140,1,104,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(392,120,1,104,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(393,140,1,104,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(394,120,1,104,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(395,140,1,104,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(396,120,1,104,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(397,120,1,104,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(398,140,1,105,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(399,120,1,105,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(400,120,1,106,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(401,140,1,106,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(402,140,1,106,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(403,120,1,106,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(404,140,1,106,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(405,120,1,106,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(406,120,1,106,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(407,120,1,107,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(408,120,1,107,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(409,120,1,108,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(410,120,1,108,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(411,120,1,109,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(412,120,1,109,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(413,120,1,110,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(414,120,1,110,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0);
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

-- Dump completed on 2010-11-23 17:51:33
