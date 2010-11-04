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
) ENGINE=InnoDB AUTO_INCREMENT=130 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `buildings`
--

LOCK TABLES `buildings` WRITE;
/*!40000 ALTER TABLE `buildings` DISABLE KEYS */;
INSERT INTO `buildings` VALUES (1,4,18,27,0,0,0,1,'NpcMetalExtractor',NULL,19,28,NULL,0,400,NULL,0,NULL,NULL,0),(2,4,24,10,0,0,0,1,'NpcMetalExtractor',NULL,25,11,NULL,0,400,NULL,0,NULL,NULL,0),(3,4,2,2,0,0,0,1,'NpcMetalExtractor',NULL,3,3,NULL,0,400,NULL,0,NULL,NULL,0),(4,4,11,6,0,0,0,1,'NpcMetalExtractor',NULL,12,7,NULL,0,400,NULL,0,NULL,NULL,0),(5,4,17,1,0,0,0,1,'NpcMetalExtractor',NULL,18,2,NULL,0,400,NULL,0,NULL,NULL,0),(6,4,9,0,0,0,0,1,'NpcResearchCenter',NULL,12,3,NULL,0,4000,NULL,0,NULL,NULL,0),(7,4,13,0,0,0,0,1,'NpcCommunicationsHub',NULL,15,1,NULL,0,1200,NULL,0,NULL,NULL,0),(8,4,19,17,0,0,0,1,'NpcResearchCenter',NULL,22,20,NULL,0,4000,NULL,0,NULL,NULL,0),(9,4,13,2,0,0,0,1,'NpcTemple',NULL,15,4,NULL,0,1500,NULL,0,NULL,NULL,0),(10,4,20,0,0,0,0,1,'NpcCommunicationsHub',NULL,22,1,NULL,0,1200,NULL,0,NULL,NULL,0),(11,4,0,7,0,0,0,1,'NpcSolarPlant',NULL,1,8,NULL,0,1000,NULL,0,NULL,NULL,0),(12,4,0,5,0,0,0,1,'NpcSolarPlant',NULL,1,6,NULL,0,1000,NULL,0,NULL,NULL,0),(13,4,20,3,0,0,0,1,'NpcSolarPlant',NULL,21,4,NULL,0,1000,NULL,0,NULL,NULL,0),(14,4,20,6,0,0,0,1,'NpcSolarPlant',NULL,21,7,NULL,0,1000,NULL,0,NULL,NULL,0),(15,12,34,17,0,0,0,1,'NpcMetalExtractor',NULL,35,18,NULL,0,400,NULL,0,NULL,NULL,0),(16,12,34,2,0,0,0,1,'NpcMetalExtractor',NULL,35,3,NULL,0,400,NULL,0,NULL,NULL,0),(17,12,34,8,0,0,0,1,'NpcMetalExtractor',NULL,35,9,NULL,0,400,NULL,0,NULL,NULL,0),(18,12,34,12,0,0,0,1,'NpcMetalExtractor',NULL,35,13,NULL,0,400,NULL,0,NULL,NULL,0),(19,12,2,11,0,0,0,1,'NpcJumpgate',NULL,6,15,NULL,0,8000,NULL,0,NULL,NULL,0),(20,12,33,24,0,0,0,1,'NpcResearchCenter',NULL,36,27,NULL,0,4000,NULL,0,NULL,NULL,0),(21,12,33,41,0,0,0,1,'NpcCommunicationsHub',NULL,35,42,NULL,0,1200,NULL,0,NULL,NULL,0),(22,12,34,34,0,0,0,1,'NpcTemple',NULL,36,36,NULL,0,1500,NULL,0,NULL,NULL,0),(23,12,33,28,0,0,0,1,'NpcCommunicationsHub',NULL,35,29,NULL,0,1200,NULL,0,NULL,NULL,0),(24,12,34,5,0,0,0,1,'NpcSolarPlant',NULL,35,6,NULL,0,1000,NULL,0,NULL,NULL,0),(25,12,0,11,0,0,0,1,'NpcSolarPlant',NULL,1,12,NULL,0,1000,NULL,0,NULL,NULL,0),(26,12,0,13,0,0,0,1,'NpcSolarPlant',NULL,1,14,NULL,0,1000,NULL,0,NULL,NULL,0),(27,18,7,2,0,0,0,1,'NpcMetalExtractor',NULL,8,3,NULL,0,400,NULL,0,NULL,NULL,0),(28,18,32,1,0,0,0,1,'NpcMetalExtractor',NULL,33,2,NULL,0,400,NULL,0,NULL,NULL,0),(29,18,38,2,0,0,0,1,'NpcMetalExtractor',NULL,39,3,NULL,0,400,NULL,0,NULL,NULL,0),(30,18,13,1,0,0,0,1,'NpcMetalExtractor',NULL,14,2,NULL,0,400,NULL,0,NULL,NULL,0),(31,18,21,1,0,0,0,1,'NpcGeothermalPlant',NULL,22,2,NULL,0,600,NULL,0,NULL,NULL,0),(32,18,0,21,0,0,0,1,'NpcResearchCenter',NULL,3,24,NULL,0,4000,NULL,0,NULL,NULL,0),(33,18,2,30,0,0,0,1,'NpcTemple',NULL,4,32,NULL,0,1500,NULL,0,NULL,NULL,0),(34,18,2,35,0,0,0,1,'NpcCommunicationsHub',NULL,4,36,NULL,0,1200,NULL,0,NULL,NULL,0),(35,18,4,33,0,0,0,1,'NpcSolarPlant',NULL,5,34,NULL,0,1000,NULL,0,NULL,NULL,0),(36,18,0,35,0,0,0,1,'NpcSolarPlant',NULL,1,36,NULL,0,1000,NULL,0,NULL,NULL,0),(37,18,0,33,0,0,0,1,'NpcSolarPlant',NULL,1,34,NULL,0,1000,NULL,0,NULL,NULL,0),(38,18,2,33,0,0,0,1,'NpcSolarPlant',NULL,3,34,NULL,0,1000,NULL,0,NULL,NULL,0),(39,19,30,13,0,0,0,1,'NpcMetalExtractor',NULL,31,14,NULL,0,400,NULL,0,NULL,NULL,0),(40,19,23,19,0,0,0,1,'NpcMetalExtractor',NULL,24,20,NULL,0,400,NULL,0,NULL,NULL,0),(41,19,9,19,0,0,0,1,'NpcMetalExtractor',NULL,10,20,NULL,0,400,NULL,0,NULL,NULL,0),(42,19,5,18,0,0,0,1,'NpcMetalExtractor',NULL,6,19,NULL,0,400,NULL,0,NULL,NULL,0),(43,19,1,19,0,0,0,1,'NpcMetalExtractor',NULL,2,20,NULL,0,400,NULL,0,NULL,NULL,0),(44,19,4,12,0,0,0,1,'NpcResearchCenter',NULL,7,15,NULL,0,4000,NULL,0,NULL,NULL,0),(45,19,19,16,0,0,0,1,'NpcCommunicationsHub',NULL,21,17,NULL,0,1200,NULL,0,NULL,NULL,0),(46,19,1,15,0,0,0,1,'NpcTemple',NULL,3,17,NULL,0,1500,NULL,0,NULL,NULL,0),(47,19,5,10,0,0,0,1,'NpcCommunicationsHub',NULL,7,11,NULL,0,1200,NULL,0,NULL,NULL,0),(48,19,20,20,0,0,0,1,'NpcSolarPlant',NULL,21,21,NULL,0,1000,NULL,0,NULL,NULL,0),(49,19,19,18,0,0,0,1,'NpcSolarPlant',NULL,20,19,NULL,0,1000,NULL,0,NULL,NULL,0),(50,19,9,15,0,0,0,1,'NpcSolarPlant',NULL,10,16,NULL,0,1000,NULL,0,NULL,NULL,0),(51,19,11,16,0,0,0,1,'NpcSolarPlant',NULL,12,17,NULL,0,1000,NULL,0,NULL,NULL,0),(52,27,23,30,0,0,0,1,'NpcMetalExtractor',NULL,24,31,NULL,0,400,NULL,0,NULL,NULL,0),(53,27,13,30,0,0,0,1,'NpcMetalExtractor',NULL,14,31,NULL,0,400,NULL,0,NULL,NULL,0),(54,27,9,29,0,0,0,1,'NpcTemple',NULL,11,31,NULL,0,1500,NULL,0,NULL,NULL,0),(55,27,9,27,0,0,0,1,'NpcCommunicationsHub',NULL,11,28,NULL,0,1200,NULL,0,NULL,NULL,0),(56,27,14,27,0,0,0,1,'NpcSolarPlant',NULL,15,28,NULL,0,1000,NULL,0,NULL,NULL,0),(57,27,12,27,0,0,0,1,'NpcSolarPlant',NULL,13,28,NULL,0,1000,NULL,0,NULL,NULL,0),(58,27,0,31,0,0,0,1,'NpcSolarPlant',NULL,1,32,NULL,0,1000,NULL,0,NULL,NULL,0),(59,27,3,31,0,0,0,1,'NpcSolarPlant',NULL,4,32,NULL,0,1000,NULL,0,NULL,NULL,0),(60,30,7,9,0,0,0,1,'Vulcan',NULL,8,10,NULL,0,300,NULL,0,NULL,NULL,0),(61,30,14,9,0,0,0,1,'Thunder',NULL,15,10,NULL,0,300,NULL,0,NULL,NULL,0),(62,30,21,9,0,0,0,1,'Screamer',NULL,22,10,NULL,0,300,NULL,0,NULL,NULL,0),(63,30,11,14,0,0,0,1,'Mothership',NULL,18,19,NULL,0,10500,NULL,0,NULL,NULL,0),(64,30,7,16,0,0,0,1,'Thunder',NULL,8,17,NULL,0,300,NULL,0,NULL,NULL,0),(65,30,21,16,0,0,0,1,'Thunder',NULL,22,17,NULL,0,300,NULL,0,NULL,NULL,0),(66,30,26,16,0,0,0,1,'NpcZetiumExtractor',NULL,27,17,NULL,0,800,NULL,0,NULL,NULL,0),(67,30,25,20,0,0,0,1,'NpcTemple',NULL,27,22,NULL,0,1500,NULL,0,NULL,NULL,0),(68,30,7,22,0,0,0,1,'Screamer',NULL,8,23,NULL,0,300,NULL,0,NULL,NULL,0),(69,30,14,22,0,0,0,1,'Thunder',NULL,15,23,NULL,0,300,NULL,0,NULL,NULL,0),(70,30,21,22,0,0,0,1,'Vulcan',NULL,22,23,NULL,0,300,NULL,0,NULL,NULL,0),(71,30,24,24,0,0,0,1,'NpcMetalExtractor',NULL,25,25,NULL,0,400,NULL,0,NULL,NULL,0),(72,30,28,24,0,0,0,1,'NpcMetalExtractor',NULL,29,25,NULL,0,400,NULL,0,NULL,NULL,0),(73,30,18,25,0,0,0,1,'NpcSolarPlant',NULL,19,26,NULL,0,1000,NULL,0,NULL,NULL,0),(74,30,15,26,0,0,0,1,'NpcSolarPlant',NULL,16,27,NULL,0,1000,NULL,0,NULL,NULL,0),(75,30,3,27,0,0,0,1,'NpcMetalExtractor',NULL,4,28,NULL,0,400,NULL,0,NULL,NULL,0),(76,30,12,27,0,0,0,1,'NpcSolarPlant',NULL,13,28,NULL,0,1000,NULL,0,NULL,NULL,0),(77,30,22,27,0,0,0,1,'NpcSolarPlant',NULL,23,28,NULL,0,1000,NULL,0,NULL,NULL,0),(78,30,26,27,0,0,0,1,'NpcCommunicationsHub',NULL,28,28,NULL,0,1200,NULL,0,NULL,NULL,0),(79,30,0,28,0,0,0,1,'NpcMetalExtractor',NULL,1,29,NULL,0,400,NULL,0,NULL,NULL,0),(80,30,7,28,0,0,0,1,'NpcCommunicationsHub',NULL,9,29,NULL,0,1200,NULL,0,NULL,NULL,0),(81,30,18,28,0,0,0,1,'NpcSolarPlant',NULL,19,29,NULL,0,1000,NULL,0,NULL,NULL,0),(82,36,5,5,0,0,0,1,'NpcMetalExtractor',NULL,6,6,NULL,0,400,NULL,0,NULL,NULL,0),(83,36,8,1,0,0,0,1,'NpcMetalExtractor',NULL,9,2,NULL,0,400,NULL,0,NULL,NULL,0),(84,36,1,25,0,0,0,1,'NpcMetalExtractor',NULL,2,26,NULL,0,400,NULL,0,NULL,NULL,0),(85,36,1,8,0,0,0,1,'NpcMetalExtractor',NULL,2,9,NULL,0,400,NULL,0,NULL,NULL,0),(86,36,0,33,0,0,0,1,'NpcCommunicationsHub',NULL,2,34,NULL,0,1200,NULL,0,NULL,NULL,0),(87,36,0,0,0,0,0,1,'NpcSolarPlant',NULL,1,1,NULL,0,1000,NULL,0,NULL,NULL,0),(88,36,0,2,0,0,0,1,'NpcSolarPlant',NULL,1,3,NULL,0,1000,NULL,0,NULL,NULL,0),(89,36,0,4,0,0,0,1,'NpcSolarPlant',NULL,1,5,NULL,0,1000,NULL,0,NULL,NULL,0),(90,36,2,5,0,0,0,1,'NpcSolarPlant',NULL,3,6,NULL,0,1000,NULL,0,NULL,NULL,0),(91,40,1,8,0,0,0,1,'NpcMetalExtractor',NULL,2,9,NULL,0,400,NULL,0,NULL,NULL,0),(92,40,1,2,0,0,0,1,'NpcMetalExtractor',NULL,2,3,NULL,0,400,NULL,0,NULL,NULL,0),(93,40,22,3,0,0,0,1,'NpcMetalExtractor',NULL,23,4,NULL,0,400,NULL,0,NULL,NULL,0),(94,40,28,4,0,0,0,1,'NpcMetalExtractor',NULL,29,5,NULL,0,400,NULL,0,NULL,NULL,0),(95,40,9,3,0,0,0,1,'NpcMetalExtractor',NULL,10,4,NULL,0,400,NULL,0,NULL,NULL,0),(96,40,1,5,0,0,0,1,'NpcCommunicationsHub',NULL,3,6,NULL,0,1200,NULL,0,NULL,NULL,0),(97,40,25,5,0,0,0,1,'NpcSolarPlant',NULL,26,6,NULL,0,1000,NULL,0,NULL,NULL,0),(98,40,5,5,0,0,0,1,'NpcSolarPlant',NULL,6,6,NULL,0,1000,NULL,0,NULL,NULL,0),(99,40,9,0,0,0,0,1,'NpcSolarPlant',NULL,10,1,NULL,0,1000,NULL,0,NULL,NULL,0),(100,42,22,1,0,0,0,1,'NpcMetalExtractor',NULL,23,2,NULL,0,400,NULL,0,NULL,NULL,0),(101,42,37,9,0,0,0,1,'NpcMetalExtractor',NULL,38,10,NULL,0,400,NULL,0,NULL,NULL,0),(102,42,41,16,0,0,0,1,'NpcMetalExtractor',NULL,42,17,NULL,0,400,NULL,0,NULL,NULL,0),(103,42,41,20,0,0,0,1,'NpcMetalExtractor',NULL,42,21,NULL,0,400,NULL,0,NULL,NULL,0),(104,42,43,8,0,0,0,1,'NpcMetalExtractor',NULL,44,9,NULL,0,400,NULL,0,NULL,NULL,0),(105,42,41,12,0,0,0,1,'NpcMetalExtractor',NULL,42,13,NULL,0,400,NULL,0,NULL,NULL,0),(106,42,34,15,0,0,0,1,'NpcJumpgate',NULL,38,19,NULL,0,8000,NULL,0,NULL,NULL,0),(107,42,32,6,0,0,0,1,'NpcResearchCenter',NULL,35,9,NULL,0,4000,NULL,0,NULL,NULL,0),(108,42,36,4,0,0,0,1,'NpcResearchCenter',NULL,39,7,NULL,0,4000,NULL,0,NULL,NULL,0),(109,42,37,0,0,0,0,1,'NpcExcavationSite',NULL,40,3,NULL,0,2000,NULL,0,NULL,NULL,0),(110,42,37,12,0,0,0,1,'NpcTemple',NULL,39,14,NULL,0,1500,NULL,0,NULL,NULL,0),(111,42,30,4,0,0,0,1,'NpcCommunicationsHub',NULL,32,5,NULL,0,1200,NULL,0,NULL,NULL,0),(112,42,40,4,0,0,0,1,'NpcSolarPlant',NULL,41,5,NULL,0,1000,NULL,0,NULL,NULL,0),(113,42,40,6,0,0,0,1,'NpcSolarPlant',NULL,41,7,NULL,0,1000,NULL,0,NULL,NULL,0),(114,42,40,8,0,0,0,1,'NpcSolarPlant',NULL,41,9,NULL,0,1000,NULL,0,NULL,NULL,0),(115,42,33,4,0,0,0,1,'NpcSolarPlant',NULL,34,5,NULL,0,1000,NULL,0,NULL,NULL,0),(116,47,12,17,0,0,0,1,'NpcMetalExtractor',NULL,13,18,NULL,0,400,NULL,0,NULL,NULL,0),(117,47,19,8,0,0,0,1,'NpcMetalExtractor',NULL,20,9,NULL,0,400,NULL,0,NULL,NULL,0),(118,47,22,13,0,0,0,1,'NpcMetalExtractor',NULL,23,14,NULL,0,400,NULL,0,NULL,NULL,0),(119,47,17,4,0,0,0,1,'NpcMetalExtractor',NULL,18,5,NULL,0,400,NULL,0,NULL,NULL,0),(120,47,14,9,0,0,0,1,'NpcMetalExtractor',NULL,15,10,NULL,0,400,NULL,0,NULL,NULL,0),(121,47,9,13,0,0,0,1,'NpcZetiumExtractor',NULL,10,14,NULL,0,800,NULL,0,NULL,NULL,0),(122,47,0,12,0,0,0,1,'NpcResearchCenter',NULL,3,15,NULL,0,4000,NULL,0,NULL,NULL,0),(123,47,4,12,0,0,0,1,'NpcExcavationSite',NULL,7,15,NULL,0,2000,NULL,0,NULL,NULL,0),(124,47,15,0,0,0,0,1,'NpcTemple',NULL,17,2,NULL,0,1500,NULL,0,NULL,NULL,0),(125,47,8,0,0,0,0,1,'NpcCommunicationsHub',NULL,10,1,NULL,0,1200,NULL,0,NULL,NULL,0),(126,47,11,0,0,0,0,1,'NpcSolarPlant',NULL,12,1,NULL,0,1000,NULL,0,NULL,NULL,0),(127,47,13,0,0,0,0,1,'NpcSolarPlant',NULL,14,1,NULL,0,1000,NULL,0,NULL,NULL,0),(128,47,18,0,0,0,0,1,'NpcSolarPlant',NULL,19,1,NULL,0,1000,NULL,0,NULL,NULL,0),(129,47,11,3,0,0,0,1,'NpcSolarPlant',NULL,12,4,NULL,0,1000,NULL,0,NULL,NULL,0);
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
INSERT INTO `folliages` VALUES (4,0,1,13),(4,0,19,6),(4,0,21,3),(4,0,28,1),(4,0,43,1),(4,1,2,3),(4,1,20,10),(4,1,28,8),(4,1,29,13),(4,1,41,7),(4,1,43,6),(4,1,44,2),(4,1,46,9),(4,1,50,5),(4,2,4,10),(4,2,6,5),(4,2,27,3),(4,2,40,5),(4,2,41,2),(4,2,42,1),(4,2,44,13),(4,2,45,7),(4,2,49,4),(4,3,44,1),(4,4,4,12),(4,4,23,11),(4,4,27,12),(4,4,49,2),(4,4,50,5),(4,5,2,8),(4,5,25,7),(4,5,45,3),(4,5,49,12),(4,5,50,11),(4,6,3,0),(4,6,31,11),(4,6,46,10),(4,7,0,5),(4,7,3,8),(4,7,8,13),(4,7,27,10),(4,7,29,0),(4,7,39,6),(4,7,41,4),(4,7,42,0),(4,8,5,4),(4,8,27,13),(4,8,39,3),(4,8,40,2),(4,8,44,4),(4,9,4,5),(4,9,7,0),(4,9,8,11),(4,9,24,7),(4,10,6,3),(4,10,35,12),(4,10,36,4),(4,10,39,2),(4,10,41,7),(4,10,43,10),(4,10,47,4),(4,10,50,7),(4,11,8,4),(4,11,16,0),(4,11,17,7),(4,11,19,12),(4,11,21,3),(4,11,38,12),(4,11,43,9),(4,12,9,12),(4,12,16,3),(4,12,17,4),(4,12,20,3),(4,12,21,4),(4,12,42,2),(4,12,43,5),(4,12,50,1),(4,13,7,10),(4,13,8,3),(4,13,9,3),(4,13,17,1),(4,13,21,10),(4,13,22,11),(4,13,23,11),(4,13,24,0),(4,13,40,9),(4,13,42,11),(4,14,9,12),(4,14,12,13),(4,14,13,1),(4,14,17,1),(4,14,18,13),(4,14,19,1),(4,14,27,2),(4,14,50,12),(4,15,8,10),(4,15,15,7),(4,15,25,4),(4,15,50,5),(4,16,3,11),(4,16,4,6),(4,16,5,13),(4,16,17,7),(4,16,25,6),(4,16,50,13),(4,17,20,10),(4,18,3,13),(4,18,7,13),(4,18,16,8),(4,18,17,0),(4,18,24,7),(4,18,45,4),(4,18,46,5),(4,18,47,1),(4,19,3,9),(4,19,4,11),(4,19,6,4),(4,19,16,12),(4,19,32,3),(4,19,34,13),(4,19,37,1),(4,20,36,2),(4,20,37,12),(4,20,45,13),(4,20,46,6),(4,21,2,5),(4,21,5,13),(4,21,8,5),(4,21,10,2),(4,21,34,10),(4,21,35,13),(4,21,38,1),(4,22,3,6),(4,22,5,4),(4,22,8,4),(4,22,9,5),(4,22,21,12),(4,22,28,10),(4,22,38,6),(4,22,45,10),(4,22,46,3),(4,22,47,6),(4,22,49,13),(4,22,50,2),(4,23,8,4),(4,23,12,2),(4,23,35,13),(4,23,38,3),(4,23,39,3),(4,23,42,13),(4,24,7,11),(4,24,15,12),(4,24,26,10),(4,24,46,4),(4,24,47,6),(4,24,49,7),(4,25,7,10),(4,25,12,4),(4,25,26,7),(4,25,28,0),(4,25,31,6),(4,25,33,0),(4,25,34,11),(4,25,40,10),(4,25,42,12),(4,25,46,7),(4,25,50,4),(4,26,7,5),(4,26,12,6),(4,26,14,12),(4,26,16,7),(4,26,25,5),(4,26,27,0),(4,26,28,0),(4,26,30,10),(4,26,32,3),(4,26,33,9),(4,26,35,4),(4,26,36,4),(4,26,37,10),(4,26,38,2),(4,26,44,0),(4,26,46,2),(4,26,47,2),(4,26,49,10),(12,0,1,11),(12,0,17,6),(12,0,18,9),(12,0,20,11),(12,0,21,0),(12,0,22,3),(12,0,24,1),(12,0,35,11),(12,0,36,4),(12,1,0,12),(12,1,16,11),(12,1,18,1),(12,1,20,13),(12,1,21,3),(12,1,22,5),(12,1,28,11),(12,1,30,4),(12,1,33,12),(12,1,35,4),(12,1,42,6),(12,2,0,11),(12,2,20,1),(12,2,24,7),(12,2,25,13),(12,2,27,5),(12,2,28,8),(12,2,29,0),(12,2,31,0),(12,2,34,3),(12,2,37,10),(12,2,39,0),(12,2,42,9),(12,3,7,4),(12,3,8,10),(12,3,23,7),(12,3,24,10),(12,3,30,6),(12,3,34,1),(12,3,38,6),(12,3,41,9),(12,3,42,1),(12,4,3,2),(12,4,17,1),(12,4,29,12),(12,4,32,10),(12,5,4,7),(12,5,7,5),(12,5,16,11),(12,5,20,4),(12,5,23,1),(12,5,26,6),(12,5,33,13),(12,5,40,10),(12,6,16,3),(12,6,17,5),(12,6,18,10),(12,6,19,1),(12,6,21,5),(12,6,25,5),(12,7,0,10),(12,7,17,6),(12,7,30,8),(12,8,0,3),(12,8,12,10),(12,8,20,7),(12,8,26,10),(12,8,29,10),(12,9,2,11),(12,9,5,9),(12,9,11,0),(12,9,21,2),(12,9,25,6),(12,9,27,10),(12,9,42,0),(12,10,18,13),(12,10,19,6),(12,10,21,11),(12,10,28,0),(12,11,1,2),(12,11,15,13),(12,11,17,5),(12,11,18,12),(12,11,20,8),(12,11,21,3),(12,11,34,10),(12,11,40,9),(12,11,41,10),(12,11,42,2),(12,12,4,12),(12,12,8,1),(12,12,10,12),(12,12,14,10),(12,12,17,3),(12,12,21,5),(12,12,39,0),(12,12,41,2),(12,13,2,8),(12,13,4,0),(12,13,14,5),(12,13,33,4),(12,13,41,10),(12,14,1,6),(12,14,5,12),(12,14,12,3),(12,15,13,9),(12,15,14,8),(12,15,32,7),(12,15,33,5),(12,15,36,3),(12,16,15,12),(12,16,30,3),(12,16,42,1),(12,17,13,6),(12,18,3,3),(12,18,4,10),(12,18,15,12),(12,18,29,13),(12,18,38,4),(12,18,39,4),(12,19,4,7),(12,19,13,4),(12,19,15,6),(12,19,35,13),(12,19,39,10),(12,19,40,6),(12,20,2,6),(12,20,16,1),(12,20,23,13),(12,20,26,10),(12,20,29,0),(12,20,40,10),(12,20,42,12),(12,21,3,9),(12,21,4,3),(12,21,7,6),(12,21,8,5),(12,21,9,2),(12,21,34,1),(12,21,37,1),(12,21,39,7),(12,22,4,4),(12,22,13,8),(12,22,14,1),(12,22,31,4),(12,22,35,9),(12,22,36,8),(12,22,37,5),(12,23,3,3),(12,23,4,12),(12,23,13,13),(12,23,19,0),(12,23,25,3),(12,23,38,2),(12,23,41,3),(12,24,3,2),(12,25,0,12),(12,25,19,8),(12,25,23,6),(12,25,25,4),(12,25,26,1),(12,26,4,9),(12,26,12,0),(12,26,19,10),(12,26,21,11),(12,27,3,1),(12,27,13,0),(12,27,20,4),(12,27,21,2),(12,27,24,13),(12,28,2,3),(12,28,3,13),(12,28,12,7),(12,28,13,7),(12,28,14,8),(12,28,24,0),(12,28,32,11),(12,28,41,0),(12,29,12,6),(12,29,15,2),(12,29,42,10),(12,30,11,2),(12,30,15,2),(12,30,41,9),(12,31,16,4),(12,31,23,13),(12,31,34,10),(12,31,38,2),(12,32,0,0),(12,32,23,12),(12,32,25,9),(12,32,36,5),(12,32,37,6),(12,32,40,11),(12,32,41,0),(12,33,1,3),(12,33,2,2),(12,33,7,9),(12,33,8,7),(12,33,17,4),(12,33,18,6),(12,33,19,9),(12,33,33,7),(12,33,38,10),(12,34,4,4),(12,34,7,6),(12,34,14,7),(12,34,37,6),(12,35,0,2),(12,35,15,1),(12,35,19,6),(12,36,4,12),(12,36,7,7),(12,36,12,1),(12,36,13,8),(12,36,14,4),(12,36,18,13),(12,36,41,6),(18,0,0,8),(18,0,2,9),(18,0,5,5),(18,0,9,0),(18,0,25,7),(18,0,26,7),(18,0,27,2),(18,0,30,12),(18,1,2,0),(18,1,6,0),(18,1,7,10),(18,1,10,6),(18,1,13,6),(18,1,29,11),(18,1,32,10),(18,2,3,7),(18,2,6,3),(18,2,7,3),(18,3,10,12),(18,3,15,10),(18,3,25,8),(18,4,0,9),(18,4,1,13),(18,4,6,3),(18,4,22,8),(18,5,4,8),(18,5,6,1),(18,5,7,0),(18,5,30,8),(18,5,32,11),(18,6,4,2),(18,6,11,8),(18,6,28,13),(18,6,34,4),(18,7,0,8),(18,7,1,9),(18,7,13,4),(18,7,14,10),(18,7,16,1),(18,8,1,1),(18,8,4,11),(18,8,5,1),(18,8,13,3),(18,8,17,3),(18,8,20,6),(18,8,21,4),(18,8,25,11),(18,9,1,3),(18,9,7,11),(18,9,17,6),(18,10,4,6),(18,10,7,2),(18,10,8,11),(18,10,12,2),(18,10,14,0),(18,11,2,5),(18,11,11,10),(18,11,13,13),(18,11,21,2),(18,11,32,6),(18,11,37,3),(18,12,11,10),(18,12,16,2),(18,12,21,9),(18,13,10,8),(18,13,21,9),(18,14,8,0),(18,14,10,6),(18,14,13,9),(18,14,18,1),(18,14,28,8),(18,14,32,1),(18,14,36,6),(18,15,0,6),(18,15,2,11),(18,15,18,8),(18,15,27,6),(18,15,37,1),(18,15,39,10),(18,16,1,13),(18,16,3,6),(18,16,10,13),(18,16,21,5),(18,16,24,9),(18,16,28,8),(18,16,31,6),(18,16,32,8),(18,16,37,5),(18,16,38,8),(18,17,3,4),(18,17,11,11),(18,17,13,0),(18,17,14,8),(18,17,20,3),(18,17,22,3),(18,17,26,0),(18,18,10,1),(18,19,0,5),(18,19,1,7),(18,19,12,6),(18,19,16,3),(18,19,25,7),(18,20,1,11),(18,20,3,10),(18,20,10,4),(18,20,12,10),(18,20,16,3),(18,20,18,4),(18,20,25,7),(18,21,4,7),(18,21,8,1),(18,21,23,9),(18,21,25,13),(18,21,32,4),(18,21,37,2),(18,22,4,11),(18,22,5,6),(18,22,15,0),(18,22,16,5),(18,22,31,0),(18,22,32,1),(18,23,1,5),(18,23,4,12),(18,23,11,1),(18,23,17,3),(18,23,19,10),(18,23,21,5),(18,23,23,0),(18,23,24,2),(18,23,31,12),(18,24,20,2),(18,24,21,9),(18,24,24,3),(18,25,19,1),(18,25,22,1),(18,26,18,2),(18,26,19,7),(18,26,27,12),(18,26,28,7),(18,27,0,4),(18,27,25,4),(18,27,28,4),(18,27,31,9),(18,28,18,11),(18,28,26,11),(18,28,32,7),(18,28,40,4),(18,29,2,11),(18,29,8,11),(18,29,22,7),(18,29,30,1),(18,29,37,0),(18,29,38,5),(18,30,39,13),(18,31,1,6),(18,31,17,11),(18,31,22,10),(18,31,24,5),(18,31,30,7),(18,31,38,9),(18,32,5,10),(18,32,19,4),(18,32,20,10),(18,32,21,1),(18,32,22,12),(18,32,26,5),(18,32,29,6),(18,32,32,6),(18,32,40,3),(18,33,4,13),(18,33,14,8),(18,33,20,8),(18,33,23,0),(18,33,26,7),(18,33,30,2),(18,33,39,2),(18,34,8,11),(18,34,15,6),(18,34,22,6),(18,34,36,7),(18,35,8,9),(18,35,13,2),(18,35,14,5),(18,35,19,7),(18,35,21,8),(18,36,9,13),(18,36,15,9),(18,36,19,3),(18,36,20,3),(18,36,21,1),(18,36,22,0),(18,37,15,5),(18,37,16,0),(18,37,18,8),(18,37,24,2),(18,38,17,9),(18,38,18,2),(18,38,22,13),(18,38,35,4),(18,38,37,0),(18,39,1,10),(18,39,16,3),(18,39,19,3),(18,39,21,9),(18,39,24,6),(18,40,1,13),(18,41,0,8),(18,41,1,3),(18,41,14,7),(18,41,15,10),(18,41,18,12),(18,41,36,11),(18,41,39,6),(19,0,7,2),(19,0,8,0),(19,0,13,6),(19,0,14,1),(19,0,20,8),(19,1,4,13),(19,1,5,7),(19,1,11,9),(19,2,1,6),(19,3,3,7),(19,3,4,4),(19,3,7,4),(19,3,9,3),(19,4,18,0),(19,5,4,2),(19,8,1,4),(19,8,7,5),(19,8,8,13),(19,9,2,12),(19,10,0,12),(19,11,20,8),(19,12,15,10),(19,14,3,6),(19,15,0,4),(19,16,2,12),(19,16,4,9),(19,16,12,8),(19,16,16,10),(19,17,4,12),(19,17,6,7),(19,17,8,9),(19,18,0,6),(19,18,4,13),(19,18,5,2),(19,18,7,6),(19,19,0,3),(19,19,1,11),(19,19,2,2),(19,19,6,10),(19,19,7,1),(19,19,8,5),(19,20,3,10),(19,20,9,3),(19,21,0,5),(19,21,1,8),(19,21,2,12),(19,21,6,9),(19,21,7,12),(19,22,2,11),(19,22,20,11),(19,23,0,12),(19,24,8,12),(19,24,9,6),(19,24,12,7),(19,24,14,7),(19,25,8,11),(19,25,9,10),(19,25,13,5),(19,26,2,3),(19,26,3,0),(19,26,14,11),(19,27,12,3),(19,27,19,4),(19,28,0,10),(19,28,10,4),(19,28,11,0),(19,28,13,0),(19,28,15,7),(19,28,19,1),(19,28,20,0),(19,28,21,7),(19,29,15,12),(19,29,17,13),(19,29,20,2),(19,30,6,6),(19,30,15,10),(19,30,18,3),(19,31,6,0),(19,31,8,11),(19,31,15,2),(19,31,16,2),(19,31,17,10),(19,31,19,8),(19,32,1,9),(19,32,3,13),(19,32,15,2),(19,32,18,11),(19,32,19,3),(19,32,21,5),(19,33,11,9),(19,33,18,7),(19,33,21,1),(19,34,1,0),(19,34,4,13),(19,34,11,2),(19,34,12,3),(19,34,14,0),(19,34,19,13),(19,35,2,5),(19,35,4,7),(19,35,9,7),(19,35,13,3),(19,35,19,10),(19,36,11,10),(19,36,13,10),(19,37,0,10),(19,37,1,3),(19,37,5,3),(19,37,7,6),(19,37,16,11),(19,38,7,1),(19,38,14,1),(19,39,0,7),(19,40,14,10),(19,40,16,12),(19,40,21,0),(19,41,14,12),(19,41,19,11),(19,41,21,8),(19,42,1,13),(19,42,12,6),(19,43,17,0),(19,43,18,2),(19,44,2,4),(19,44,6,1),(19,44,7,6),(19,44,11,4),(19,44,12,12),(19,44,14,5),(19,44,16,9),(19,45,7,7),(19,45,12,12),(19,45,17,10),(19,46,0,13),(19,46,13,3),(19,47,1,11),(19,47,4,0),(19,47,8,11),(19,47,12,10),(19,48,5,0),(19,48,7,13),(19,48,8,6),(19,48,14,3),(19,48,16,10),(19,48,21,9),(27,0,0,1),(27,0,2,7),(27,0,9,3),(27,0,21,5),(27,0,26,0),(27,0,27,3),(27,1,0,6),(27,1,26,3),(27,1,30,9),(27,2,26,0),(27,2,27,0),(27,3,1,11),(27,4,11,6),(27,4,13,5),(27,4,27,5),(27,5,28,3),(27,6,15,3),(27,6,17,4),(27,6,19,12),(27,6,28,11),(27,7,11,0),(27,8,4,7),(27,8,5,9),(27,8,17,10),(27,8,19,13),(27,9,0,3),(27,9,5,13),(27,9,7,5),(27,9,19,4),(27,9,20,5),(27,10,4,3),(27,10,6,10),(27,10,14,10),(27,10,16,12),(27,10,19,13),(27,10,23,11),(27,10,24,13),(27,11,1,12),(27,11,4,1),(27,11,7,12),(27,11,12,5),(27,11,21,10),(27,12,3,0),(27,12,4,5),(27,12,15,2),(27,12,16,5),(27,12,18,7),(27,12,25,12),(27,12,26,11),(27,12,30,5),(27,12,31,6),(27,13,0,1),(27,13,3,13),(27,13,4,5),(27,13,7,5),(27,13,21,1),(27,14,3,1),(27,14,11,1),(27,14,19,11),(27,14,21,7),(27,15,0,6),(27,15,6,8),(27,15,11,11),(27,15,12,3),(27,15,29,0),(27,16,3,0),(27,16,17,12),(27,16,21,10),(27,16,27,0),(27,16,31,1),(27,17,1,13),(27,17,4,10),(27,17,7,4),(27,17,14,9),(27,17,18,4),(27,17,28,3),(27,17,32,2),(27,18,9,6),(27,18,32,0),(27,19,7,7),(27,19,14,1),(27,19,15,12),(27,19,16,13),(27,19,22,4),(27,19,27,1),(27,20,5,11),(27,20,14,1),(27,20,18,0),(27,20,21,3),(27,20,31,7),(27,21,6,3),(27,21,7,3),(27,21,8,2),(27,21,18,7),(27,21,20,0),(27,21,22,5),(27,22,11,2),(27,22,18,11),(27,22,22,1),(27,22,26,13),(27,23,5,11),(27,23,11,8),(27,23,16,10),(27,23,25,4),(27,24,26,4),(27,25,0,7),(27,25,11,2),(27,25,15,4),(27,25,22,6),(27,25,25,9),(27,26,4,12),(27,26,14,6),(27,26,15,13),(27,26,18,13),(27,26,20,8),(30,0,4,10),(30,0,14,0),(30,1,5,2),(30,1,19,2),(30,2,4,4),(30,2,5,2),(30,2,10,3),(30,2,29,4),(30,3,2,2),(30,3,10,2),(30,4,5,6),(30,4,10,12),(30,4,18,7),(30,4,26,10),(30,5,0,7),(30,5,1,3),(30,5,8,10),(30,5,16,0),(30,5,18,7),(30,6,0,9),(30,6,24,4),(30,7,14,9),(30,7,15,13),(30,7,24,12),(30,7,26,11),(30,8,27,3),(30,9,7,11),(30,9,9,2),(30,9,15,7),(30,9,27,5),(30,10,7,13),(30,10,16,8),(30,10,17,1),(30,11,13,3),(30,11,25,3),(30,12,0,2),(30,12,10,11),(30,12,12,7),(30,12,25,0),(30,13,0,3),(30,13,1,0),(30,13,12,4),(30,14,0,2),(30,14,2,0),(30,14,5,9),(30,14,6,8),(30,14,8,12),(30,14,21,13),(30,15,2,1),(30,15,6,13),(30,16,11,3),(30,16,13,13),(30,16,24,1),(30,17,2,5),(30,17,3,6),(30,17,5,9),(30,17,9,3),(30,17,11,11),(30,18,10,0),(30,18,20,5),(30,19,7,7),(30,19,8,0),(30,20,3,0),(30,20,4,0),(30,20,11,9),(30,20,12,6),(30,20,16,1),(30,20,19,10),(30,20,21,9),(30,20,23,12),(30,21,5,9),(30,21,11,1),(30,21,13,11),(30,21,14,9),(30,21,19,4),(30,22,6,9),(30,22,7,3),(30,22,14,9),(30,22,20,6),(30,22,21,2),(30,23,8,10),(30,23,12,2),(30,23,13,7),(30,23,15,0),(30,23,19,6),(30,23,21,0),(30,23,24,4),(30,24,7,6),(30,24,12,3),(30,24,16,3),(30,25,3,6),(30,25,12,5),(30,25,13,10),(30,25,15,13),(30,25,17,1),(30,25,18,10),(30,25,23,9),(30,25,27,0),(30,26,11,2),(30,26,12,6),(30,26,24,5),(30,26,26,2),(30,27,0,0),(30,27,2,10),(30,27,4,7),(30,27,14,11),(30,28,17,11),(30,28,26,4),(30,28,29,9),(30,29,1,2),(30,29,15,1),(30,29,16,3),(30,29,23,2),(30,29,27,13),(30,29,29,4),(36,0,7,2),(36,0,9,13),(36,0,10,8),(36,0,12,3),(36,0,25,1),(36,0,26,2),(36,0,27,4),(36,0,31,7),(36,1,6,1),(36,1,19,10),(36,1,22,5),(36,1,27,2),(36,1,28,11),(36,2,15,9),(36,2,19,3),(36,2,28,8),(36,2,32,11),(36,3,7,5),(36,3,8,9),(36,3,14,6),(36,3,20,1),(36,3,22,3),(36,3,27,0),(36,3,29,0),(36,4,19,2),(36,4,21,1),(36,4,26,11),(36,5,7,9),(36,5,16,0),(36,5,30,13),(36,6,22,3),(36,6,25,7),(36,6,26,9),(36,6,27,3),(36,7,20,2),(36,7,23,0),(36,8,17,10),(36,8,19,5),(36,8,22,8),(36,8,23,2),(36,8,24,7),(36,8,25,12),(36,8,30,10),(36,8,31,11),(36,8,34,1),(36,9,3,11),(36,9,10,3),(36,9,18,0),(36,9,19,11),(36,9,22,9),(36,9,34,6),(36,10,2,8),(36,10,9,2),(36,10,13,4),(36,10,21,9),(36,10,22,2),(36,10,23,10),(36,10,24,7),(36,10,25,6),(36,11,11,7),(36,11,17,10),(36,11,22,8),(36,11,29,6),(36,11,32,3),(36,12,4,5),(36,12,14,0),(36,12,17,0),(36,12,24,7),(36,12,27,1),(36,12,30,0),(36,13,28,0),(36,13,31,10),(36,14,2,1),(36,14,17,5),(36,14,25,0),(36,14,32,4),(36,15,18,10),(36,15,28,8),(36,15,30,4),(36,16,26,7),(36,16,27,3),(36,16,28,4),(36,16,30,6),(36,17,3,7),(36,17,24,1),(36,17,26,10),(36,18,6,0),(36,18,7,13),(36,18,26,7),(36,18,28,1),(36,18,29,1),(36,18,31,2),(36,18,32,7),(40,0,1,6),(40,0,3,8),(40,0,6,13),(40,0,7,4),(40,0,8,12),(40,0,12,5),(40,0,22,1),(40,2,4,13),(40,2,10,8),(40,2,24,13),(40,3,4,3),(40,3,7,13),(40,3,8,6),(40,3,19,11),(40,3,21,3),(40,4,0,5),(40,4,4,5),(40,4,5,10),(40,4,10,13),(40,4,20,5),(40,5,3,2),(40,5,20,12),(40,6,0,3),(40,6,20,2),(40,6,21,6),(40,7,2,9),(40,7,3,4),(40,7,15,7),(40,7,21,2),(40,8,12,3),(40,8,13,9),(40,9,23,0),(40,10,2,13),(40,10,10,11),(40,10,11,1),(40,10,15,2),(40,10,23,11),(40,11,12,6),(40,11,15,3),(40,12,4,9),(40,12,11,11),(40,12,13,13),(40,12,15,12),(40,12,16,6),(40,12,23,10),(40,13,5,6),(40,13,13,4),(40,13,14,7),(40,13,21,7),(40,13,22,11),(40,13,23,4),(40,14,8,6),(40,14,12,9),(40,14,13,12),(40,14,14,12),(40,14,18,7),(40,14,20,4),(40,14,23,8),(40,15,1,7),(40,15,5,0),(40,15,8,5),(40,15,10,11),(40,15,11,5),(40,15,13,6),(40,15,17,9),(40,15,18,4),(40,16,4,6),(40,16,9,6),(40,16,10,2),(40,16,20,10),(40,16,23,6),(40,17,10,6),(40,17,14,1),(40,17,18,5),(40,18,7,7),(40,18,9,6),(40,18,11,0),(40,18,12,13),(40,18,13,4),(40,18,19,12),(40,19,8,4),(40,19,10,6),(40,19,24,1),(40,20,10,7),(40,21,9,3),(40,21,19,2),(40,21,23,4),(40,22,1,12),(40,22,7,3),(40,22,8,5),(40,22,9,3),(40,22,11,9),(40,22,19,2),(40,22,22,1),(40,22,24,7),(40,23,0,8),(40,23,9,1),(40,23,13,5),(40,23,22,11),(40,24,1,12),(40,24,6,7),(40,24,8,4),(40,24,16,9),(40,24,21,2),(40,25,2,10),(40,25,15,4),(40,25,18,4),(40,25,21,9),(40,25,22,6),(40,26,17,3),(40,26,22,7),(40,27,15,10),(40,28,10,3),(40,28,17,2),(40,28,18,0),(40,28,22,4),(40,28,23,3),(40,29,11,4),(40,29,24,0),(40,30,12,12),(40,30,13,11),(40,30,15,6),(40,30,16,7),(40,30,20,9),(40,30,24,12),(40,31,0,10),(40,31,10,3),(40,31,14,7),(40,31,16,11),(40,31,18,10),(42,0,4,2),(42,0,20,1),(42,0,24,5),(42,1,4,4),(42,1,10,0),(42,1,16,9),(42,1,24,9),(42,2,3,8),(42,2,4,3),(42,2,12,4),(42,2,15,0),(42,2,19,5),(42,3,5,5),(42,3,6,2),(42,3,18,4),(42,3,22,4),(42,4,10,1),(42,4,18,1),(42,4,19,0),(42,4,23,7),(42,5,6,2),(42,5,7,11),(42,5,20,5),(42,5,21,5),(42,5,24,0),(42,6,1,12),(42,6,8,4),(42,6,16,1),(42,7,8,13),(42,7,19,11),(42,7,20,8),(42,7,24,5),(42,8,13,2),(42,8,15,3),(42,8,20,9),(42,9,8,8),(42,9,17,3),(42,10,10,3),(42,10,11,3),(42,11,5,7),(42,12,5,4),(42,12,8,10),(42,13,6,5),(42,14,4,10),(42,14,5,10),(42,14,6,5),(42,14,7,9),(42,14,10,10),(42,15,2,0),(42,15,3,0),(42,15,4,2),(42,15,5,6),(42,15,6,11),(42,15,12,2),(42,15,21,3),(42,15,22,6),(42,15,23,1),(42,16,19,3),(42,16,22,7),(42,17,3,7),(42,17,11,2),(42,17,14,2),(42,17,19,1),(42,17,21,4),(42,17,23,7),(42,18,3,7),(42,18,7,7),(42,18,10,4),(42,18,19,1),(42,19,8,1),(42,19,19,6),(42,19,24,12),(42,20,9,3),(42,20,11,1),(42,20,13,5),(42,20,21,8),(42,21,5,3),(42,21,7,6),(42,21,23,2),(42,21,24,5),(42,22,20,1),(42,22,21,6),(42,22,22,1),(42,23,3,1),(42,23,4,3),(42,23,6,7),(42,23,8,11),(42,23,18,3),(42,24,0,9),(42,24,1,8),(42,24,5,0),(42,24,7,10),(42,24,20,5),(42,24,21,3),(42,25,22,6),(42,25,23,12),(42,26,15,13),(42,26,19,7),(42,27,15,4),(42,27,16,1),(42,27,17,8),(42,27,21,3),(42,28,18,10),(42,29,21,7),(42,29,22,5),(42,29,24,10),(42,30,18,5),(42,30,22,0),(42,31,15,7),(42,32,24,5),(42,34,14,12),(42,35,0,6),(42,35,4,7),(42,35,5,1),(42,36,0,7),(42,40,10,11),(42,41,3,2),(42,42,0,7),(42,42,1,10),(42,43,3,10),(42,43,14,9),(42,43,16,11),(42,44,7,13),(42,45,0,1),(42,45,16,2),(47,0,4,9),(47,0,20,0),(47,0,22,3),(47,1,4,0),(47,1,17,9),(47,1,18,11),(47,1,22,13),(47,1,46,3),(47,2,20,3),(47,4,17,13),(47,4,28,5),(47,4,39,5),(47,4,47,9),(47,5,19,13),(47,5,20,2),(47,5,45,6),(47,6,16,11),(47,6,17,2),(47,8,12,1),(47,8,15,13),(47,8,22,10),(47,8,27,11),(47,8,42,0),(47,9,17,6),(47,9,22,9),(47,9,26,0),(47,9,29,9),(47,9,31,0),(47,10,6,4),(47,10,11,5),(47,10,16,11),(47,10,27,0),(47,10,31,11),(47,11,14,13),(47,11,16,11),(47,11,18,11),(47,11,19,7),(47,11,22,4),(47,11,26,7),(47,11,32,3),(47,11,37,0),(47,12,9,1),(47,12,10,2),(47,12,16,12),(47,12,25,13),(47,12,29,10),(47,12,31,11),(47,12,32,10),(47,12,37,3),(47,13,4,12),(47,13,9,5),(47,13,19,12),(47,13,27,12),(47,13,41,4),(47,14,2,11),(47,14,12,6),(47,14,19,4),(47,14,26,4),(47,14,32,12),(47,14,40,5),(47,15,6,11),(47,15,11,11),(47,15,14,1),(47,15,16,10),(47,15,20,1),(47,15,22,3),(47,15,25,8),(47,15,28,11),(47,15,34,1),(47,15,42,12),(47,15,43,4),(47,15,45,3),(47,15,47,13),(47,16,5,11),(47,16,20,10),(47,16,23,6),(47,16,25,10),(47,16,26,4),(47,16,28,10),(47,16,30,2),(47,16,36,11),(47,17,6,6),(47,17,7,0),(47,17,16,6),(47,17,21,11),(47,17,25,1),(47,17,26,11),(47,17,32,6),(47,17,35,4),(47,17,45,3),(47,18,9,3),(47,18,18,11),(47,18,20,12),(47,18,24,11),(47,18,33,1),(47,18,45,10),(47,18,46,10),(47,19,5,2),(47,19,21,4),(47,19,24,7),(47,19,30,7),(47,19,32,13),(47,19,33,11),(47,19,44,1),(47,19,46,9),(47,20,0,3),(47,20,7,5),(47,20,11,13),(47,20,20,7),(47,20,22,13),(47,20,37,6),(47,20,47,2),(47,21,21,0),(47,21,24,7),(47,21,25,12),(47,21,28,10),(47,21,32,10),(47,21,46,4),(47,21,47,0),(47,22,0,9),(47,22,3,8),(47,22,20,4),(47,22,22,9),(47,22,23,2),(47,22,32,7),(47,22,33,8),(47,22,43,13),(47,23,0,10),(47,23,2,0),(47,23,21,3),(47,23,28,12),(47,23,32,0),(47,23,42,5),(47,23,43,1),(47,23,44,0),(47,24,3,11),(47,24,19,6),(47,24,29,0),(47,24,30,0),(47,24,45,3);
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
INSERT INTO `galaxies` VALUES (1,'2010-11-04 13:22:13','dev');
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
INSERT INTO `solar_systems` VALUES (1,'Resource',1,2,2),(2,'Expansion',1,1,1),(3,'Homeworld',1,2,0),(4,'Expansion',1,0,1);
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
INSERT INTO `ss_objects` VALUES (1,1,0,0,1,45,'Asteroid',NULL,'',31,0,0,0,1,0,0,0,0,0,1,NULL,0),(2,1,0,0,4,72,'Asteroid',NULL,'',38,0,0,0,3,0,0,2,0,0,3,NULL,0),(3,1,0,0,5,300,'Jumpgate',NULL,'',49,0,0,0,0,0,0,0,0,0,0,NULL,0),(4,1,27,51,1,180,'Planet',NULL,'P-4',57,2,0,0,0,0,0,0,0,0,0,'2010-11-04 13:22:15',0),(5,1,0,0,3,156,'Asteroid',NULL,'',47,0,0,0,1,0,0,1,0,0,1,NULL,0),(6,1,0,0,3,66,'Asteroid',NULL,'',54,0,0,0,1,0,0,1,0,0,3,NULL,0),(7,1,0,0,1,0,'Asteroid',NULL,'',52,0,0,0,3,0,0,2,0,0,2,NULL,0),(8,1,0,0,1,270,'Asteroid',NULL,'',35,0,0,0,0,0,0,1,0,0,1,NULL,0),(9,1,0,0,5,345,'Jumpgate',NULL,'',29,0,0,0,0,0,0,0,0,0,0,NULL,0),(10,1,0,0,5,315,'Jumpgate',NULL,'',43,0,0,0,0,0,0,0,0,0,0,NULL,0),(11,1,0,0,1,135,'Asteroid',NULL,'',37,0,0,0,1,0,0,0,0,0,0,NULL,0),(12,1,37,43,3,90,'Planet',NULL,'P-12',58,2,0,0,0,0,0,0,0,0,0,'2010-11-04 13:22:15',0),(13,1,0,0,0,180,'Asteroid',NULL,'',36,0,0,0,1,0,0,0,0,0,0,NULL,0),(14,1,0,0,2,300,'Asteroid',NULL,'',28,0,0,0,2,0,0,3,0,0,1,NULL,0),(15,1,0,0,5,180,'Jumpgate',NULL,'',35,0,0,0,0,0,0,0,0,0,0,NULL,0),(16,2,0,0,5,75,'Jumpgate',NULL,'',29,0,0,0,0,0,0,0,0,0,0,NULL,0),(17,2,0,0,1,45,'Asteroid',NULL,'',47,0,0,0,1,0,0,0,0,0,1,NULL,0),(18,2,42,41,2,120,'Planet',NULL,'P-18',60,1,0,0,0,0,0,0,0,0,0,'2010-11-04 13:22:15',0),(19,2,49,22,1,180,'Planet',NULL,'P-19',54,2,0,0,0,0,0,0,0,0,0,'2010-11-04 13:22:15',0),(20,2,0,0,4,54,'Asteroid',NULL,'',53,0,0,0,0,0,0,1,0,0,0,NULL,0),(21,2,0,0,3,292,'Asteroid',NULL,'',44,0,0,0,1,0,0,0,0,0,0,NULL,0),(22,2,0,0,1,270,'Asteroid',NULL,'',49,0,0,0,0,0,0,0,0,0,0,NULL,0),(23,2,0,0,4,216,'Asteroid',NULL,'',25,0,0,0,1,0,0,3,0,0,3,NULL,0),(24,2,0,0,3,44,'Asteroid',NULL,'',47,0,0,0,2,0,0,2,0,0,1,NULL,0),(25,2,0,0,3,0,'Asteroid',NULL,'',36,0,0,0,3,0,0,2,0,0,3,NULL,0),(26,2,0,0,0,90,'Asteroid',NULL,'',37,0,0,0,1,0,0,1,0,0,1,NULL,0),(27,2,27,33,3,270,'Planet',NULL,'P-27',50,2,0,0,0,0,0,0,0,0,0,'2010-11-04 13:22:15',0),(28,2,0,0,2,300,'Asteroid',NULL,'',29,0,0,0,0,0,0,1,0,0,0,NULL,0),(29,2,0,0,5,180,'Jumpgate',NULL,'',35,0,0,0,0,0,0,0,0,0,0,NULL,0),(30,3,30,30,4,126,'Planet',1,'P-30',50,0,864,1,3024,1728,2,6048,0,0,604.8,'2010-11-04 13:22:15',0),(31,3,0,0,5,195,'Jumpgate',NULL,'',25,0,0,0,0,0,0,0,0,0,0,NULL,0),(32,3,0,0,0,270,'Asteroid',NULL,'',45,0,0,0,0,0,0,1,0,0,0,NULL,0),(33,3,0,0,3,156,'Asteroid',NULL,'',50,0,0,0,0,0,0,0,0,0,1,NULL,0),(34,3,0,0,1,315,'Asteroid',NULL,'',55,0,0,0,0,0,0,0,0,0,1,NULL,0),(35,3,0,0,1,0,'Asteroid',NULL,'',46,0,0,0,0,0,0,0,0,0,0,NULL,0),(36,3,19,36,2,60,'Planet',NULL,'P-36',48,1,0,0,0,0,0,0,0,0,0,'2010-11-04 13:22:15',0),(37,3,0,0,0,0,'Asteroid',NULL,'',37,0,0,0,1,0,0,0,0,0,0,NULL,0),(38,4,0,0,4,306,'Asteroid',NULL,'',54,0,0,0,1,0,0,1,0,0,0,NULL,0),(39,4,0,0,1,225,'Asteroid',NULL,'',43,0,0,0,3,0,0,2,0,0,3,NULL,0),(40,4,32,25,3,22,'Planet',NULL,'P-40',48,2,0,0,0,0,0,0,0,0,0,'2010-11-04 13:22:15',0),(41,4,0,0,4,18,'Asteroid',NULL,'',53,0,0,0,0,0,0,1,0,0,0,NULL,0),(42,4,46,25,2,210,'Planet',NULL,'P-42',54,0,0,0,0,0,0,0,0,0,0,'2010-11-04 13:22:15',0),(43,4,0,0,3,156,'Asteroid',NULL,'',54,0,0,0,2,0,0,1,0,0,1,NULL,0),(44,4,0,0,4,90,'Asteroid',NULL,'',31,0,0,0,2,0,0,2,0,0,1,NULL,0),(45,4,0,0,4,108,'Asteroid',NULL,'',46,0,0,0,0,0,0,0,0,0,0,NULL,0),(46,4,0,0,1,0,'Asteroid',NULL,'',28,0,0,0,3,0,0,3,0,0,3,NULL,0),(47,4,25,49,1,270,'Planet',NULL,'P-47',56,2,0,0,0,0,0,0,0,0,0,'2010-11-04 13:22:15',0),(48,4,0,0,5,330,'Jumpgate',NULL,'',39,0,0,0,0,0,0,0,0,0,0,NULL,0),(49,4,0,0,3,180,'Asteroid',NULL,'',46,0,0,0,3,0,0,2,0,0,3,NULL,0),(50,4,0,0,4,126,'Asteroid',NULL,'',46,0,0,0,0,0,0,0,0,0,0,NULL,0),(51,4,0,0,0,90,'Asteroid',NULL,'',53,0,0,0,1,0,0,0,0,0,0,NULL,0),(52,4,0,0,0,180,'Asteroid',NULL,'',48,0,0,0,0,0,0,1,0,0,0,NULL,0);
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
INSERT INTO `tiles` VALUES (5,4,0,9),(5,4,0,10),(5,4,0,12),(5,4,0,13),(5,4,0,14),(5,4,0,15),(3,4,0,32),(3,4,0,33),(3,4,0,34),(3,4,0,35),(3,4,0,36),(3,4,0,37),(3,4,0,38),(3,4,0,40),(4,4,1,9),(5,4,1,10),(5,4,1,11),(5,4,1,12),(5,4,1,13),(5,4,1,14),(3,4,1,31),(3,4,1,32),(3,4,1,33),(3,4,1,34),(3,4,1,35),(3,4,1,36),(3,4,1,37),(3,4,1,38),(3,4,1,39),(3,4,1,40),(0,4,2,2),(4,4,2,8),(4,4,2,9),(5,4,2,10),(5,4,2,11),(5,4,2,12),(5,4,2,13),(5,4,2,14),(8,4,2,15),(5,4,2,18),(5,4,2,22),(6,4,2,29),(6,4,2,30),(6,4,2,31),(3,4,2,32),(3,4,2,33),(3,4,2,34),(3,4,2,35),(3,4,2,36),(3,4,2,37),(4,4,3,5),(1,4,3,6),(4,4,3,8),(4,4,3,9),(5,4,3,10),(5,4,3,11),(5,4,3,12),(5,4,3,13),(5,4,3,14),(5,4,3,18),(5,4,3,20),(5,4,3,21),(5,4,3,22),(5,4,3,23),(6,4,3,30),(6,4,3,31),(3,4,3,32),(3,4,3,33),(3,4,3,34),(3,4,3,35),(3,4,3,36),(3,4,3,37),(3,4,3,38),(3,4,3,39),(4,4,4,5),(4,4,4,8),(4,4,4,9),(4,4,4,10),(5,4,4,11),(5,4,4,12),(5,4,4,13),(5,4,4,14),(5,4,4,18),(5,4,4,19),(5,4,4,20),(5,4,4,21),(4,4,4,29),(6,4,4,30),(6,4,4,31),(6,4,4,32),(6,4,4,33),(3,4,4,34),(6,4,4,35),(3,4,4,36),(3,4,4,37),(3,4,4,38),(3,4,4,39),(4,4,5,5),(4,4,5,6),(4,4,5,7),(4,4,5,8),(8,4,5,9),(14,4,5,12),(5,4,5,16),(5,4,5,17),(5,4,5,18),(5,4,5,19),(5,4,5,20),(4,4,5,29),(6,4,5,30),(6,4,5,31),(6,4,5,32),(6,4,5,33),(6,4,5,34),(6,4,5,35),(6,4,5,36),(3,4,5,37),(3,4,5,38),(5,4,5,48),(2,4,6,1),(4,4,6,4),(4,4,6,5),(4,4,6,6),(4,4,6,7),(4,4,6,8),(5,4,6,16),(5,4,6,17),(11,4,6,18),(4,4,6,29),(4,4,6,30),(6,4,6,32),(6,4,6,33),(6,4,6,34),(6,4,6,35),(6,4,6,36),(4,4,6,37),(5,4,6,48),(5,4,6,49),(5,4,6,50),(1,4,7,6),(5,4,7,16),(5,4,7,17),(6,4,7,24),(6,4,7,25),(6,4,7,26),(4,4,7,30),(4,4,7,31),(4,4,7,32),(6,4,7,33),(6,4,7,34),(6,4,7,35),(4,4,7,36),(4,4,7,37),(4,4,7,38),(5,4,7,46),(5,4,7,48),(5,4,7,49),(5,4,7,50),(12,4,8,10),(5,4,8,16),(5,4,8,17),(6,4,8,24),(6,4,8,25),(6,4,8,26),(4,4,8,31),(4,4,8,32),(4,4,8,34),(4,4,8,35),(4,4,8,36),(4,4,8,37),(4,4,8,38),(5,4,8,45),(5,4,8,46),(5,4,8,47),(5,4,8,48),(5,4,8,49),(5,4,8,50),(5,4,9,16),(5,4,9,17),(6,4,9,25),(6,4,9,26),(6,4,9,27),(6,4,9,28),(6,4,9,29),(4,4,9,30),(4,4,9,31),(4,4,9,32),(3,4,9,34),(4,4,9,36),(4,4,9,37),(4,4,9,38),(5,4,9,45),(5,4,9,46),(5,4,9,48),(5,4,9,49),(5,4,9,50),(5,4,10,17),(6,4,10,24),(6,4,10,25),(6,4,10,26),(6,4,10,27),(6,4,10,28),(4,4,10,29),(4,4,10,30),(4,4,10,31),(3,4,10,33),(3,4,10,34),(4,4,10,37),(5,4,10,45),(5,4,10,46),(5,4,10,48),(0,4,11,6),(6,4,11,24),(6,4,11,25),(6,4,11,26),(6,4,11,27),(6,4,11,28),(6,4,11,29),(4,4,11,31),(4,4,11,32),(4,4,11,33),(3,4,11,34),(3,4,11,35),(3,4,11,36),(4,4,11,37),(5,4,11,45),(5,4,11,46),(5,4,11,48),(6,4,12,26),(4,4,12,31),(3,4,12,32),(3,4,12,33),(3,4,12,34),(3,4,12,35),(4,4,12,37),(4,4,12,38),(6,4,12,45),(6,4,13,26),(3,4,13,29),(3,4,13,30),(3,4,13,31),(3,4,13,32),(3,4,13,34),(3,4,13,35),(3,4,13,36),(4,4,13,37),(6,4,13,45),(6,4,13,46),(6,4,13,47),(4,4,14,21),(6,4,14,26),(4,4,14,28),(4,4,14,29),(4,4,14,30),(3,4,14,32),(3,4,14,33),(3,4,14,34),(3,4,14,35),(3,4,14,36),(4,4,14,37),(4,4,14,38),(6,4,14,42),(6,4,14,45),(6,4,14,46),(6,4,14,47),(12,4,15,9),(4,4,15,19),(4,4,15,20),(4,4,15,21),(4,4,15,22),(4,4,15,23),(4,4,15,27),(4,4,15,28),(4,4,15,29),(4,4,15,30),(3,4,15,31),(3,4,15,32),(3,4,15,33),(3,4,15,34),(3,4,15,35),(3,4,15,36),(6,4,15,41),(6,4,15,42),(6,4,15,43),(6,4,15,44),(6,4,15,45),(6,4,15,47),(0,4,16,6),(3,4,16,15),(4,4,16,18),(4,4,16,19),(4,4,16,20),(4,4,16,21),(4,4,16,22),(4,4,16,23),(4,4,16,28),(4,4,16,29),(4,4,16,30),(3,4,16,31),(3,4,16,32),(3,4,16,33),(3,4,16,34),(3,4,16,35),(3,4,16,36),(3,4,16,37),(3,4,16,38),(5,4,16,41),(6,4,16,43),(6,4,16,45),(6,4,16,46),(6,4,16,47),(6,4,16,48),(0,4,17,1),(3,4,17,15),(4,4,17,19),(4,4,17,21),(4,4,17,22),(4,4,17,23),(4,4,17,29),(4,4,17,30),(4,4,17,31),(4,4,17,32),(3,4,17,33),(3,4,17,34),(3,4,17,35),(5,4,17,40),(5,4,17,41),(6,4,17,42),(6,4,17,43),(6,4,17,44),(6,4,17,45),(3,4,18,15),(4,4,18,20),(4,4,18,21),(4,4,18,22),(0,4,18,27),(4,4,18,29),(4,4,18,30),(5,4,18,31),(4,4,18,32),(5,4,18,38),(5,4,18,39),(5,4,18,40),(5,4,18,41),(6,4,18,42),(5,4,18,43),(6,4,18,44),(3,4,19,15),(10,4,19,22),(4,4,19,29),(4,4,19,30),(5,4,19,31),(5,4,19,40),(5,4,19,41),(5,4,19,42),(5,4,19,43),(3,4,20,15),(3,4,20,16),(5,4,20,26),(5,4,20,29),(5,4,20,30),(5,4,20,31),(5,4,20,38),(5,4,20,39),(5,4,20,40),(5,4,20,41),(5,4,20,42),(5,4,20,43),(3,4,21,11),(3,4,21,12),(3,4,21,13),(3,4,21,14),(3,4,21,15),(3,4,21,16),(5,4,21,26),(5,4,21,27),(5,4,21,28),(5,4,21,29),(5,4,21,30),(5,4,21,32),(5,4,21,39),(5,4,21,40),(5,4,21,41),(3,4,22,10),(3,4,22,11),(3,4,22,12),(3,4,22,13),(3,4,22,14),(3,4,22,15),(3,4,22,16),(5,4,22,26),(5,4,22,29),(5,4,22,30),(5,4,22,31),(5,4,22,32),(5,4,22,41),(5,4,22,42),(9,4,23,0),(0,4,23,4),(3,4,23,10),(3,4,23,11),(3,4,23,14),(3,4,23,15),(3,4,23,16),(3,4,23,17),(3,4,23,18),(3,4,23,19),(3,4,23,20),(10,4,23,21),(5,4,23,26),(5,4,23,27),(5,4,23,28),(5,4,23,29),(5,4,23,30),(5,4,23,40),(5,4,23,41),(0,4,24,10),(3,4,24,13),(3,4,24,14),(3,4,24,16),(3,4,24,17),(3,4,24,18),(3,4,24,19),(3,4,24,20),(5,4,24,28),(5,4,24,29),(3,4,25,13),(3,4,25,18),(3,4,25,20),(5,4,25,29),(3,4,26,18),(6,12,0,3),(6,12,0,4),(6,12,0,5),(6,12,0,6),(14,12,0,7),(6,12,1,2),(6,12,1,3),(6,12,1,4),(6,12,1,5),(6,12,1,6),(6,12,2,1),(6,12,2,2),(6,12,2,3),(6,12,2,4),(6,12,2,5),(6,12,2,6),(6,12,3,1),(6,12,3,2),(6,12,3,3),(6,12,3,4),(13,12,3,5),(6,12,4,1),(6,12,4,2),(6,12,4,4),(3,12,4,36),(3,12,4,38),(3,12,4,39),(3,12,4,40),(6,12,5,0),(6,12,5,1),(6,12,5,2),(6,12,5,3),(3,12,5,9),(6,12,5,22),(3,12,5,31),(3,12,5,36),(3,12,5,37),(3,12,5,38),(3,12,5,39),(6,12,6,0),(6,12,6,1),(6,12,6,2),(6,12,6,3),(6,12,6,4),(3,12,6,7),(3,12,6,8),(3,12,6,9),(3,12,6,10),(6,12,6,22),(6,12,6,23),(6,12,6,24),(3,12,6,31),(3,12,6,32),(3,12,6,36),(3,12,6,37),(3,12,6,38),(3,12,6,39),(6,12,7,1),(6,12,7,2),(6,12,7,3),(6,12,7,4),(3,12,7,7),(3,12,7,8),(3,12,7,9),(3,12,7,10),(3,12,7,11),(6,12,7,12),(6,12,7,13),(6,12,7,14),(6,12,7,15),(6,12,7,16),(6,12,7,22),(6,12,7,23),(6,12,7,24),(6,12,7,25),(3,12,7,32),(3,12,7,33),(3,12,7,34),(3,12,7,35),(3,12,7,36),(3,12,7,37),(3,12,7,38),(3,12,7,39),(6,12,8,3),(3,12,8,7),(3,12,8,8),(3,12,8,9),(3,12,8,10),(6,12,8,14),(6,12,8,15),(6,12,8,16),(6,12,8,17),(6,12,8,18),(6,12,8,19),(6,12,8,22),(6,12,8,23),(6,12,8,24),(6,12,8,25),(4,12,8,30),(4,12,8,31),(3,12,8,32),(3,12,8,33),(3,12,8,34),(3,12,8,35),(3,12,8,36),(3,12,8,37),(3,12,8,38),(3,12,8,39),(3,12,9,6),(3,12,9,7),(3,12,9,8),(3,12,9,9),(3,12,9,10),(3,12,9,13),(6,12,9,14),(6,12,9,16),(6,12,9,17),(6,12,9,18),(6,12,9,22),(6,12,9,24),(4,12,9,29),(4,12,9,30),(4,12,9,31),(4,12,9,32),(4,12,9,34),(4,12,9,35),(3,12,9,36),(4,12,9,37),(4,12,9,38),(3,12,9,39),(3,12,10,6),(3,12,10,9),(3,12,10,10),(3,12,10,11),(3,12,10,12),(3,12,10,13),(6,12,10,15),(6,12,10,16),(6,12,10,17),(5,12,10,22),(6,12,10,23),(6,12,10,24),(4,12,10,30),(4,12,10,31),(4,12,10,32),(4,12,10,33),(4,12,10,34),(4,12,10,35),(4,12,10,36),(4,12,10,37),(4,12,10,38),(4,12,10,39),(4,12,10,40),(3,12,11,6),(3,12,11,7),(3,12,11,8),(3,12,11,9),(3,12,11,10),(3,12,11,11),(3,12,11,13),(5,12,11,22),(6,12,11,23),(6,12,11,24),(5,12,11,25),(4,12,11,29),(4,12,11,30),(4,12,11,31),(4,12,11,32),(4,12,11,33),(4,12,11,36),(4,12,11,37),(4,12,11,38),(5,12,12,22),(5,12,12,23),(5,12,12,24),(5,12,12,25),(5,12,12,26),(5,12,12,27),(5,12,12,28),(4,12,12,30),(4,12,12,31),(4,12,12,32),(4,12,12,35),(4,12,12,36),(4,12,12,37),(4,12,12,38),(5,12,13,16),(5,12,13,18),(5,12,13,19),(5,12,13,22),(5,12,13,23),(5,12,13,24),(5,12,13,26),(5,12,13,27),(5,12,13,28),(5,12,13,29),(4,12,13,30),(4,12,13,31),(4,12,13,32),(4,12,13,34),(4,12,13,35),(4,12,13,36),(5,12,14,15),(5,12,14,16),(5,12,14,17),(5,12,14,18),(5,12,14,19),(5,12,14,20),(5,12,14,21),(5,12,14,22),(5,12,14,23),(5,12,14,24),(5,12,14,25),(5,12,14,26),(5,12,14,27),(5,12,14,28),(5,12,14,29),(4,12,14,30),(4,12,14,32),(4,12,14,33),(4,12,14,35),(12,12,15,5),(5,12,15,17),(5,12,15,18),(5,12,15,19),(5,12,15,20),(5,12,15,22),(5,12,15,23),(5,12,15,25),(5,12,15,26),(5,12,15,27),(5,12,15,28),(5,12,15,29),(4,12,15,30),(4,12,15,31),(5,12,16,18),(5,12,16,19),(5,12,16,20),(5,12,16,21),(5,12,16,22),(5,12,16,23),(5,12,16,25),(5,12,16,27),(5,12,16,28),(5,12,17,17),(5,12,17,18),(5,12,17,19),(5,12,17,20),(4,12,17,21),(4,12,17,22),(4,12,17,23),(4,12,17,25),(5,12,17,27),(5,12,17,28),(5,12,18,17),(3,12,18,18),(3,12,18,19),(3,12,18,20),(3,12,18,21),(3,12,18,22),(4,12,18,23),(4,12,18,24),(4,12,18,25),(4,12,18,26),(4,12,18,27),(3,12,19,16),(3,12,19,17),(3,12,19,18),(3,12,19,19),(3,12,19,21),(4,12,19,22),(4,12,19,23),(4,12,19,24),(4,12,19,25),(4,12,19,26),(4,12,19,27),(3,12,20,18),(3,12,20,19),(3,12,20,20),(3,12,20,21),(3,12,20,22),(4,12,20,24),(4,12,20,25),(4,12,20,27),(3,12,21,16),(3,12,21,17),(3,12,21,18),(3,12,21,19),(3,12,21,20),(3,12,21,21),(3,12,21,22),(3,12,21,23),(3,12,21,24),(4,12,21,25),(4,12,21,26),(4,12,21,27),(4,12,21,28),(6,12,22,16),(3,12,22,17),(3,12,22,18),(3,12,22,19),(3,12,22,20),(3,12,22,21),(3,12,22,22),(4,12,22,25),(4,12,22,26),(4,12,22,27),(4,12,22,28),(4,12,22,29),(4,12,22,30),(12,12,23,5),(6,12,23,14),(6,12,23,15),(6,12,23,16),(3,12,23,17),(3,12,23,20),(3,12,23,21),(4,12,23,26),(4,12,23,27),(4,12,23,28),(4,12,23,29),(4,12,23,30),(5,12,23,37),(6,12,24,14),(6,12,24,15),(6,12,24,16),(6,12,24,17),(6,12,24,18),(4,12,24,26),(4,12,24,27),(4,12,24,28),(4,12,24,29),(4,12,24,30),(4,12,24,31),(5,12,24,34),(5,12,24,35),(5,12,24,36),(5,12,24,37),(5,12,24,38),(6,12,25,15),(6,12,25,16),(6,12,25,17),(6,12,25,18),(4,12,25,27),(4,12,25,28),(4,12,25,29),(4,12,25,30),(4,12,25,31),(5,12,25,32),(5,12,25,34),(5,12,25,35),(5,12,25,36),(5,12,25,37),(6,12,26,14),(6,12,26,15),(6,12,26,16),(6,12,26,17),(3,12,26,18),(4,12,26,26),(4,12,26,27),(4,12,26,28),(5,12,26,31),(5,12,26,32),(5,12,26,33),(5,12,26,34),(5,12,26,35),(5,12,26,36),(5,12,26,37),(5,12,26,38),(5,12,26,40),(6,12,27,15),(3,12,27,16),(3,12,27,17),(3,12,27,18),(3,12,27,19),(5,12,27,25),(4,12,27,28),(5,12,27,32),(5,12,27,34),(5,12,27,35),(5,12,27,36),(5,12,27,37),(5,12,27,38),(5,12,27,39),(5,12,27,40),(3,12,28,18),(3,12,28,19),(3,12,28,20),(3,12,28,21),(5,12,28,25),(5,12,28,26),(5,12,28,30),(5,12,28,33),(5,12,28,34),(5,12,28,35),(5,12,28,36),(5,12,28,37),(5,12,28,38),(5,12,28,39),(11,12,29,5),(3,12,29,16),(3,12,29,17),(3,12,29,18),(3,12,29,19),(3,12,29,20),(3,12,29,21),(5,12,29,24),(5,12,29,25),(5,12,29,26),(5,12,29,27),(5,12,29,30),(5,12,29,31),(5,12,29,32),(5,12,29,33),(5,12,29,34),(5,12,29,35),(5,12,29,36),(5,12,29,37),(5,12,29,38),(14,12,30,1),(8,12,30,12),(3,12,30,16),(3,12,30,17),(3,12,30,18),(3,12,30,19),(3,12,30,20),(3,12,30,21),(0,12,30,24),(5,12,30,27),(5,12,30,28),(5,12,30,29),(5,12,30,30),(5,12,30,31),(5,12,30,32),(5,12,30,33),(5,12,30,34),(5,12,30,35),(5,12,30,36),(5,12,30,37),(5,12,30,38),(3,12,31,17),(3,12,31,18),(3,12,31,19),(3,12,31,20),(3,12,31,21),(5,12,31,26),(5,12,31,27),(5,12,31,28),(5,12,31,29),(5,12,31,30),(5,12,31,31),(5,12,31,32),(5,12,31,33),(5,12,31,35),(3,12,32,17),(3,12,32,18),(3,12,32,20),(3,12,32,21),(5,12,32,26),(5,12,32,27),(5,12,32,28),(5,12,32,29),(5,12,32,30),(5,12,32,31),(5,12,32,32),(5,12,32,33),(5,12,32,34),(5,12,32,35),(3,12,33,20),(5,12,33,30),(5,12,33,31),(5,12,33,34),(5,12,33,35),(0,12,34,2),(0,12,34,8),(0,12,34,12),(0,12,34,17),(3,12,34,20),(2,12,34,21),(5,12,34,30),(0,12,34,31),(1,12,34,38),(3,12,35,20),(5,12,35,30),(5,12,36,30),(5,12,36,31),(5,12,36,32),(5,12,36,33),(10,18,0,37),(5,18,1,15),(5,18,1,16),(5,18,1,17),(5,18,1,18),(0,18,2,1),(5,18,2,15),(5,18,2,16),(5,18,2,17),(5,18,2,19),(5,18,2,20),(10,18,2,26),(5,18,3,13),(5,18,3,16),(5,18,3,17),(5,18,3,18),(5,18,3,19),(5,18,3,20),(5,18,4,11),(5,18,4,12),(5,18,4,13),(5,18,4,14),(5,18,4,15),(5,18,4,16),(5,18,4,17),(5,18,5,13),(5,18,5,14),(5,18,5,15),(5,18,5,16),(14,18,5,17),(12,18,5,35),(0,18,7,2),(6,18,7,24),(13,18,7,33),(6,18,8,23),(6,18,8,24),(11,18,8,26),(6,18,9,24),(6,18,10,23),(6,18,10,24),(6,18,10,25),(3,18,11,3),(3,18,11,4),(3,18,11,6),(6,18,11,24),(6,18,11,25),(3,18,11,35),(3,18,11,36),(3,18,12,3),(3,18,12,4),(3,18,12,5),(3,18,12,6),(3,18,12,7),(3,18,12,8),(3,18,12,9),(3,18,12,10),(6,18,12,23),(6,18,12,24),(6,18,12,25),(6,18,12,26),(3,18,12,35),(3,18,12,36),(3,18,12,37),(3,18,12,38),(3,18,12,39),(0,18,13,1),(3,18,13,3),(3,18,13,4),(3,18,13,5),(3,18,13,6),(3,18,13,7),(3,18,13,8),(6,18,13,22),(6,18,13,23),(6,18,13,24),(3,18,13,30),(3,18,13,33),(3,18,13,34),(3,18,13,35),(3,18,13,36),(3,18,13,37),(3,18,13,39),(3,18,14,3),(3,18,14,4),(3,18,14,5),(0,18,14,6),(3,18,14,30),(3,18,14,33),(3,18,14,34),(3,18,14,35),(3,18,14,37),(3,18,15,4),(3,18,15,5),(3,18,15,29),(3,18,15,30),(3,18,15,32),(3,18,15,33),(3,18,15,34),(3,18,16,4),(6,18,16,5),(6,18,16,6),(3,18,16,30),(3,18,16,33),(5,18,16,40),(0,18,17,1),(6,18,17,5),(6,18,17,6),(6,18,17,7),(3,18,17,29),(3,18,17,30),(3,18,17,33),(5,18,17,35),(5,18,17,36),(5,18,17,37),(5,18,17,38),(5,18,17,39),(5,18,17,40),(6,18,18,4),(6,18,18,5),(6,18,18,6),(6,18,18,7),(3,18,18,27),(3,18,18,28),(3,18,18,29),(3,18,18,30),(3,18,18,31),(3,18,18,32),(3,18,18,33),(5,18,18,35),(5,18,18,36),(5,18,18,37),(5,18,18,38),(5,18,18,39),(5,18,18,40),(6,18,19,4),(6,18,19,5),(6,18,19,6),(6,18,19,7),(6,18,19,8),(6,18,19,27),(3,18,19,28),(3,18,19,29),(3,18,19,30),(3,18,19,31),(3,18,19,32),(3,18,19,33),(5,18,19,35),(5,18,19,36),(5,18,19,37),(5,18,19,38),(5,18,19,39),(5,18,19,40),(6,18,20,6),(6,18,20,7),(6,18,20,26),(6,18,20,27),(3,18,20,28),(3,18,20,29),(3,18,20,30),(3,18,20,31),(5,18,20,32),(5,18,20,33),(5,18,20,34),(5,18,20,35),(5,18,20,36),(5,18,20,37),(5,18,20,38),(5,18,20,39),(5,18,20,40),(1,18,21,1),(6,18,21,27),(6,18,21,28),(6,18,21,29),(6,18,21,30),(6,18,21,31),(5,18,21,34),(5,18,21,35),(5,18,21,36),(5,18,21,38),(5,18,21,39),(5,18,21,40),(6,18,22,26),(6,18,22,27),(6,18,22,28),(6,18,22,29),(6,18,22,30),(4,18,22,34),(5,18,22,36),(5,18,22,37),(5,18,22,38),(5,18,22,39),(5,18,22,40),(4,18,23,6),(5,18,23,13),(6,18,23,26),(6,18,23,27),(6,18,23,30),(4,18,23,33),(4,18,23,34),(5,18,23,35),(5,18,23,36),(5,18,23,37),(5,18,23,38),(5,18,23,39),(5,18,23,40),(4,18,24,4),(4,18,24,6),(4,18,24,7),(5,18,24,9),(5,18,24,11),(5,18,24,12),(5,18,24,13),(4,18,24,32),(4,18,24,33),(4,18,24,34),(4,18,24,35),(4,18,24,37),(4,18,24,38),(5,18,24,39),(5,18,24,40),(4,18,25,1),(4,18,25,2),(4,18,25,4),(4,18,25,7),(5,18,25,9),(5,18,25,10),(5,18,25,11),(5,18,25,12),(5,18,25,13),(5,18,25,15),(5,18,25,17),(4,18,25,31),(4,18,25,32),(4,18,25,33),(4,18,25,34),(4,18,25,35),(4,18,25,36),(4,18,25,37),(5,18,25,38),(5,18,25,39),(5,18,25,40),(4,18,26,0),(4,18,26,1),(4,18,26,2),(4,18,26,3),(4,18,26,4),(4,18,26,6),(4,18,26,7),(4,18,26,8),(4,18,26,9),(5,18,26,11),(5,18,26,12),(5,18,26,13),(5,18,26,14),(5,18,26,15),(5,18,26,16),(5,18,26,17),(4,18,26,30),(4,18,26,31),(4,18,26,32),(4,18,26,33),(4,18,26,34),(4,18,26,35),(4,18,26,36),(4,18,26,37),(4,18,26,38),(5,18,26,40),(2,18,27,1),(4,18,27,3),(4,18,27,4),(4,18,27,5),(4,18,27,6),(4,18,27,7),(5,18,27,10),(5,18,27,11),(5,18,27,12),(5,18,27,13),(5,18,27,14),(6,18,27,15),(6,18,27,16),(4,18,27,33),(4,18,27,34),(4,18,27,35),(4,18,27,36),(4,18,27,38),(5,18,27,40),(4,18,28,3),(4,18,28,4),(4,18,28,5),(3,18,28,10),(5,18,28,13),(6,18,28,14),(6,18,28,15),(6,18,28,16),(4,18,28,33),(4,18,28,34),(4,18,28,35),(4,18,28,36),(4,18,28,37),(4,18,29,3),(4,18,29,4),(4,18,29,5),(4,18,29,6),(4,18,29,7),(3,18,29,10),(3,18,29,12),(5,18,29,13),(6,18,29,14),(6,18,29,15),(6,18,29,16),(6,18,29,17),(4,18,29,32),(4,18,29,33),(4,18,29,34),(4,18,29,35),(4,18,29,36),(4,18,30,3),(4,18,30,4),(4,18,30,6),(4,18,30,7),(3,18,30,10),(3,18,30,11),(3,18,30,12),(3,18,30,13),(3,18,30,14),(6,18,30,15),(4,18,30,34),(4,18,30,35),(4,18,31,3),(4,18,31,6),(4,18,31,8),(3,18,31,9),(3,18,31,10),(3,18,31,11),(3,18,31,12),(3,18,31,13),(6,18,31,14),(6,18,31,15),(6,18,31,16),(13,18,31,33),(4,18,31,35),(0,18,32,1),(4,18,32,6),(4,18,32,7),(4,18,32,8),(4,18,32,9),(3,18,32,11),(3,18,32,12),(3,18,32,13),(6,18,32,15),(6,18,32,16),(6,18,32,17),(4,18,33,6),(4,18,33,9),(3,18,33,10),(3,18,33,11),(3,18,33,12),(3,18,33,13),(4,18,33,32),(3,18,34,0),(3,18,34,1),(3,18,34,2),(3,18,34,3),(3,18,34,4),(3,18,34,10),(3,18,34,13),(4,18,34,26),(4,18,34,27),(4,18,34,28),(4,18,34,29),(4,18,34,30),(4,18,34,32),(3,18,35,0),(3,18,35,1),(3,18,35,2),(3,18,35,3),(3,18,35,4),(3,18,35,5),(3,18,35,6),(4,18,35,7),(3,18,35,10),(4,18,35,23),(4,18,35,24),(4,18,35,25),(4,18,35,26),(4,18,35,27),(4,18,35,28),(4,18,35,29),(4,18,35,30),(4,18,35,31),(4,18,35,32),(14,18,35,35),(3,18,36,0),(3,18,36,1),(3,18,36,2),(3,18,36,3),(3,18,36,4),(3,18,36,5),(4,18,36,6),(4,18,36,7),(4,18,36,24),(4,18,36,25),(4,18,36,28),(4,18,36,29),(4,18,36,30),(4,18,36,31),(4,18,36,32),(3,18,37,0),(3,18,37,1),(3,18,37,2),(4,18,37,3),(4,18,37,4),(4,18,37,5),(4,18,37,6),(4,18,37,7),(4,18,37,8),(4,18,37,9),(4,18,37,11),(4,18,37,25),(4,18,37,26),(4,18,37,27),(4,18,37,28),(4,18,37,29),(4,18,37,30),(4,18,37,31),(9,18,37,32),(3,18,38,0),(3,18,38,1),(0,18,38,2),(4,18,38,4),(4,18,38,5),(4,18,38,6),(4,18,38,7),(4,18,38,8),(4,18,38,9),(4,18,38,10),(4,18,38,11),(4,18,38,25),(9,18,38,26),(4,18,38,29),(4,18,38,30),(4,18,38,31),(4,18,39,4),(4,18,39,5),(4,18,39,6),(4,18,39,7),(4,18,39,9),(4,18,39,10),(4,18,39,11),(4,18,39,12),(4,18,39,25),(4,18,39,29),(4,18,39,30),(4,18,39,31),(0,18,39,38),(4,18,40,4),(4,18,40,5),(4,18,40,6),(4,18,40,7),(4,18,40,8),(4,18,40,9),(4,18,40,10),(4,18,40,11),(4,18,40,12),(4,18,40,30),(4,18,40,31),(4,18,41,3),(4,18,41,4),(4,18,41,6),(4,18,41,7),(4,18,41,8),(4,18,41,9),(4,18,41,10),(4,18,41,30),(4,18,41,31),(3,19,0,21),(1,19,1,2),(2,19,1,7),(2,19,1,12),(0,19,1,19),(3,19,1,21),(3,19,2,21),(4,19,3,0),(4,19,3,1),(4,19,3,2),(3,19,3,20),(3,19,3,21),(4,19,4,0),(4,19,4,1),(4,19,4,2),(9,19,4,7),(3,19,4,21),(4,19,5,0),(4,19,5,1),(4,19,5,2),(4,19,5,3),(0,19,5,18),(3,19,5,20),(3,19,5,21),(4,19,6,1),(4,19,6,2),(4,19,6,5),(3,19,6,17),(3,19,6,20),(3,19,6,21),(4,19,7,2),(4,19,7,3),(4,19,7,4),(4,19,7,5),(4,19,7,6),(3,19,7,16),(3,19,7,17),(3,19,7,18),(3,19,7,19),(3,19,7,20),(3,19,7,21),(4,19,8,2),(4,19,8,4),(4,19,8,5),(4,19,8,6),(14,19,8,11),(3,19,8,15),(3,19,8,16),(3,19,8,17),(3,19,8,18),(3,19,8,19),(3,19,8,20),(3,19,8,21),(5,19,9,3),(12,19,9,5),(3,19,9,17),(3,19,9,18),(0,19,9,19),(3,19,9,21),(5,19,10,1),(5,19,10,2),(5,19,10,3),(5,19,10,4),(3,19,10,17),(3,19,10,18),(3,19,10,21),(9,19,11,0),(5,19,11,4),(10,19,11,11),(3,19,11,19),(3,19,11,21),(5,19,12,3),(5,19,12,4),(3,19,12,19),(3,19,12,20),(3,19,12,21),(5,19,13,3),(5,19,13,4),(6,19,13,17),(6,19,13,19),(6,19,13,20),(6,19,13,21),(5,19,14,4),(3,19,14,15),(6,19,14,17),(6,19,14,18),(6,19,14,19),(13,19,15,10),(3,19,15,15),(6,19,15,18),(6,19,15,19),(6,19,15,20),(3,19,16,14),(3,19,16,15),(0,19,16,17),(5,19,16,19),(6,19,16,20),(6,19,16,21),(3,19,17,13),(3,19,17,14),(3,19,17,15),(3,19,17,16),(5,19,17,19),(5,19,17,20),(3,19,18,12),(3,19,18,14),(3,19,18,15),(5,19,18,16),(5,19,18,17),(5,19,18,18),(5,19,18,19),(5,19,18,20),(5,19,18,21),(3,19,19,12),(3,19,19,13),(3,19,19,14),(3,19,19,15),(5,19,19,20),(5,19,19,21),(3,19,20,8),(3,19,20,12),(3,19,20,13),(3,19,20,14),(3,19,20,15),(3,19,21,8),(3,19,21,9),(3,19,21,10),(3,19,21,12),(3,19,21,13),(3,19,21,14),(3,19,21,15),(3,19,22,4),(3,19,22,6),(3,19,22,7),(3,19,22,8),(3,19,22,9),(13,19,22,10),(3,19,22,12),(3,19,22,15),(3,19,22,16),(3,19,22,17),(5,19,22,18),(5,19,22,19),(3,19,23,1),(3,19,23,2),(3,19,23,3),(3,19,23,4),(3,19,23,5),(3,19,23,6),(3,19,23,7),(3,19,23,8),(3,19,23,15),(3,19,23,16),(3,19,23,17),(5,19,23,18),(0,19,23,19),(3,19,24,0),(3,19,24,1),(3,19,24,2),(3,19,24,3),(3,19,24,4),(3,19,24,5),(3,19,24,6),(3,19,24,7),(3,19,24,15),(3,19,24,16),(3,19,24,17),(5,19,24,18),(3,19,25,0),(3,19,25,2),(3,19,25,3),(3,19,25,4),(3,19,25,6),(3,19,25,7),(3,19,25,15),(3,19,25,17),(5,19,25,18),(5,19,25,19),(3,19,26,4),(3,19,26,6),(3,19,26,7),(3,19,26,8),(5,19,26,18),(5,19,26,19),(4,19,27,4),(4,19,27,5),(4,19,27,6),(4,19,27,7),(4,19,27,8),(5,19,27,18),(4,19,28,4),(4,19,28,5),(4,19,28,6),(4,19,28,7),(4,19,28,8),(4,19,28,9),(5,19,28,17),(5,19,28,18),(4,19,29,3),(4,19,29,4),(4,19,29,5),(4,19,29,6),(4,19,29,7),(4,19,29,8),(4,19,30,3),(4,19,30,4),(4,19,30,5),(4,19,30,8),(4,19,30,10),(0,19,30,13),(4,19,31,4),(4,19,31,9),(4,19,31,10),(4,19,32,8),(4,19,32,9),(4,19,33,6),(4,19,33,7),(4,19,33,9),(4,19,33,10),(4,19,34,6),(4,19,34,7),(4,19,34,8),(4,19,34,9),(4,19,35,5),(4,19,35,6),(4,19,35,7),(4,19,35,8),(4,19,36,5),(4,19,36,6),(4,19,36,8),(4,19,36,9),(5,19,36,18),(5,19,36,20),(4,19,37,3),(4,19,37,4),(4,19,37,8),(6,19,37,9),(6,19,37,12),(6,19,37,13),(5,19,37,17),(5,19,37,18),(5,19,37,19),(5,19,37,20),(4,19,38,2),(4,19,38,3),(6,19,38,8),(6,19,38,9),(6,19,38,10),(6,19,38,11),(6,19,38,13),(5,19,38,17),(5,19,38,18),(5,19,38,19),(5,19,38,20),(4,19,39,2),(4,19,39,3),(6,19,39,7),(6,19,39,8),(4,19,39,10),(6,19,39,11),(6,19,39,12),(6,19,39,13),(5,19,39,19),(4,19,40,1),(4,19,40,2),(4,19,40,3),(4,19,40,4),(4,19,40,5),(6,19,40,6),(6,19,40,7),(6,19,40,8),(6,19,40,9),(4,19,40,10),(4,19,40,11),(6,19,40,13),(4,19,41,1),(4,19,41,2),(4,19,41,3),(4,19,41,4),(4,19,41,5),(6,19,41,6),(6,19,41,7),(6,19,41,8),(6,19,41,9),(4,19,41,10),(4,19,42,3),(4,19,42,4),(4,19,42,5),(6,19,42,7),(6,19,42,8),(4,19,42,9),(4,19,42,10),(4,19,42,11),(4,19,43,2),(4,19,43,3),(4,19,43,5),(4,19,43,7),(4,19,43,8),(4,19,43,9),(4,19,43,10),(4,19,43,11),(4,19,43,12),(6,19,43,19),(6,19,43,20),(4,19,44,10),(6,19,44,17),(6,19,44,18),(6,19,44,19),(6,19,44,20),(4,19,45,10),(4,19,45,11),(5,19,45,16),(5,19,45,18),(6,19,45,19),(6,19,45,20),(6,19,45,21),(4,19,46,10),(4,19,46,11),(4,19,46,12),(5,19,46,16),(5,19,46,17),(5,19,46,18),(5,19,46,19),(6,19,46,20),(6,19,46,21),(4,19,47,9),(4,19,47,10),(4,19,47,11),(5,19,47,16),(5,19,47,17),(5,19,47,18),(5,19,47,19),(6,19,47,20),(5,19,48,17),(5,27,0,11),(5,27,0,12),(5,27,0,13),(5,27,0,14),(5,27,0,15),(5,27,0,16),(5,27,0,17),(5,27,0,18),(4,27,0,23),(4,27,0,24),(2,27,1,1),(11,27,1,4),(5,27,1,11),(5,27,1,12),(5,27,1,13),(5,27,1,14),(5,27,1,15),(5,27,1,16),(5,27,1,17),(4,27,1,22),(4,27,1,23),(4,27,1,24),(4,27,1,25),(1,27,1,28),(2,27,2,12),(4,27,2,14),(4,27,2,15),(5,27,2,17),(5,27,2,18),(6,27,2,19),(4,27,2,23),(4,27,2,24),(4,27,2,25),(4,27,3,14),(5,27,3,17),(6,27,3,18),(6,27,3,19),(6,27,3,20),(4,27,3,22),(4,27,3,23),(4,27,3,24),(4,27,3,25),(14,27,4,0),(4,27,4,12),(4,27,4,14),(4,27,4,15),(4,27,4,16),(5,27,4,17),(6,27,4,18),(6,27,4,19),(6,27,4,20),(4,27,4,22),(4,27,4,23),(4,27,4,24),(4,27,4,25),(4,27,4,26),(14,27,5,4),(9,27,5,8),(4,27,5,11),(4,27,5,12),(4,27,5,13),(4,27,5,14),(4,27,5,15),(4,27,5,16),(6,27,5,17),(6,27,5,18),(4,27,5,22),(4,27,5,24),(4,27,5,25),(4,27,5,26),(4,27,6,11),(4,27,6,12),(4,27,6,13),(4,27,6,14),(4,27,6,21),(4,27,6,22),(4,27,6,23),(4,27,6,24),(4,27,6,25),(4,27,6,26),(3,27,6,29),(0,27,6,30),(9,27,7,1),(4,27,7,14),(4,27,7,21),(4,27,7,22),(4,27,7,24),(4,27,7,25),(3,27,7,28),(3,27,7,29),(3,27,7,32),(4,27,8,22),(4,27,8,23),(4,27,8,25),(3,27,8,29),(3,27,8,30),(3,27,8,31),(3,27,8,32),(3,27,9,9),(3,27,9,10),(3,27,9,11),(3,27,9,12),(3,27,9,13),(4,27,9,22),(3,27,9,32),(3,27,10,8),(3,27,10,9),(3,27,10,11),(3,27,10,12),(3,27,10,32),(3,27,11,9),(3,27,11,10),(3,27,11,11),(6,27,11,13),(3,27,11,32),(5,27,12,5),(5,27,12,6),(5,27,12,7),(5,27,12,8),(5,27,12,9),(3,27,12,10),(5,27,12,11),(6,27,12,13),(6,27,12,14),(3,27,12,32),(5,27,13,9),(5,27,13,10),(5,27,13,11),(6,27,13,14),(5,27,13,18),(0,27,13,30),(3,27,13,32),(3,27,14,1),(5,27,14,7),(5,27,14,8),(5,27,14,9),(5,27,14,10),(6,27,14,13),(6,27,14,14),(5,27,14,16),(5,27,14,17),(5,27,14,18),(5,27,14,22),(0,27,14,24),(4,27,14,26),(3,27,15,1),(5,27,15,7),(5,27,15,8),(5,27,15,9),(5,27,15,10),(6,27,15,13),(6,27,15,14),(5,27,15,17),(5,27,15,18),(5,27,15,19),(5,27,15,20),(5,27,15,21),(5,27,15,22),(4,27,15,23),(4,27,15,26),(3,27,16,0),(3,27,16,1),(3,27,16,2),(5,27,16,7),(5,27,16,9),(6,27,16,10),(6,27,16,11),(6,27,16,14),(5,27,16,19),(5,27,16,20),(4,27,16,22),(4,27,16,23),(4,27,16,24),(4,27,16,25),(4,27,16,26),(3,27,17,0),(3,27,17,3),(6,27,17,10),(6,27,17,11),(6,27,17,12),(5,27,17,19),(5,27,17,20),(4,27,17,23),(4,27,17,24),(4,27,17,26),(4,27,17,27),(0,27,17,29),(3,27,18,0),(3,27,18,1),(3,27,18,2),(3,27,18,3),(6,27,18,10),(5,27,18,19),(5,27,18,20),(4,27,18,23),(4,27,18,24),(4,27,18,25),(4,27,18,26),(4,27,18,27),(3,27,19,0),(5,27,19,1),(5,27,19,2),(6,27,19,10),(5,27,19,19),(5,27,19,20),(4,27,19,23),(3,27,20,0),(5,27,20,1),(5,27,20,2),(5,27,20,4),(6,27,20,10),(6,27,20,11),(4,27,20,13),(13,27,20,27),(5,27,21,0),(5,27,21,1),(5,27,21,2),(5,27,21,3),(5,27,21,4),(4,27,21,13),(4,27,21,14),(5,27,22,2),(5,27,22,3),(4,27,22,13),(4,27,22,14),(4,27,22,15),(4,27,22,16),(5,27,22,29),(5,27,22,30),(5,27,23,2),(5,27,23,3),(3,27,23,10),(4,27,23,13),(4,27,23,14),(4,27,23,15),(5,27,23,29),(0,27,23,30),(5,27,23,32),(5,27,24,3),(5,27,24,4),(5,27,24,5),(5,27,24,6),(3,27,24,9),(3,27,24,10),(3,27,24,11),(3,27,24,12),(4,27,24,14),(4,27,24,15),(4,27,24,16),(5,27,24,29),(5,27,24,32),(5,27,25,5),(3,27,25,7),(3,27,25,8),(3,27,25,9),(3,27,25,10),(4,27,25,12),(4,27,25,13),(4,27,25,14),(4,27,25,16),(5,27,25,26),(5,27,25,29),(5,27,25,30),(5,27,25,31),(5,27,25,32),(3,27,26,9),(3,27,26,10),(3,27,26,11),(3,27,26,12),(4,27,26,16),(5,27,26,25),(5,27,26,26),(5,27,26,27),(5,27,26,28),(5,27,26,29),(5,27,26,30),(5,27,26,31),(5,27,26,32),(5,30,0,0),(5,30,0,1),(5,30,0,2),(5,30,0,3),(5,30,0,15),(5,30,0,16),(5,30,0,17),(5,30,0,18),(5,30,0,19),(5,30,0,20),(5,30,0,21),(5,30,0,22),(5,30,0,23),(5,30,0,24),(5,30,0,25),(5,30,0,26),(0,30,0,28),(5,30,1,0),(5,30,1,1),(5,30,1,2),(5,30,1,3),(4,30,1,7),(4,30,1,8),(4,30,1,9),(4,30,1,10),(13,30,1,12),(5,30,1,16),(5,30,1,17),(5,30,1,18),(11,30,1,20),(5,30,1,26),(5,30,2,0),(5,30,2,1),(5,30,2,2),(4,30,2,6),(4,30,2,7),(4,30,2,8),(4,30,2,9),(5,30,2,14),(5,30,2,15),(5,30,2,16),(5,30,2,17),(5,30,2,19),(5,30,2,26),(5,30,2,27),(5,30,3,0),(5,30,3,1),(4,30,3,5),(4,30,3,6),(4,30,3,7),(4,30,3,8),(4,30,3,9),(5,30,3,15),(5,30,3,16),(5,30,3,17),(5,30,3,18),(5,30,3,19),(0,30,3,27),(5,30,4,1),(5,30,4,2),(5,30,4,3),(4,30,4,6),(4,30,4,7),(4,30,4,8),(6,30,4,11),(5,30,4,16),(5,30,4,17),(5,30,5,2),(5,30,5,3),(4,30,5,5),(4,30,5,6),(4,30,5,7),(6,30,5,10),(6,30,5,11),(6,30,5,20),(6,30,5,21),(6,30,6,10),(6,30,6,11),(6,30,6,18),(6,30,6,20),(6,30,6,21),(6,30,6,22),(12,30,7,1),(6,30,7,11),(6,30,7,19),(6,30,7,20),(6,30,8,11),(6,30,8,12),(6,30,8,13),(6,30,8,19),(6,30,8,20),(6,30,9,12),(6,30,9,13),(6,30,9,14),(6,30,9,20),(3,30,9,25),(3,30,9,26),(0,30,10,8),(6,30,10,12),(6,30,10,13),(8,30,10,22),(3,30,10,25),(3,30,10,26),(3,30,10,27),(3,30,10,29),(3,30,11,26),(3,30,11,27),(3,30,11,28),(3,30,11,29),(3,30,12,27),(3,30,12,28),(3,30,12,29),(3,30,13,25),(3,30,13,27),(3,30,13,28),(3,30,13,29),(3,30,14,25),(3,30,14,26),(3,30,14,27),(3,30,14,28),(3,30,14,29),(3,30,15,25),(3,30,15,26),(3,30,15,27),(3,30,15,28),(3,30,15,29),(5,30,16,0),(3,30,16,26),(3,30,16,27),(3,30,16,28),(3,30,16,29),(5,30,17,0),(5,30,17,1),(3,30,17,25),(3,30,17,26),(3,30,17,27),(3,30,17,28),(3,30,17,29),(5,30,18,0),(5,30,18,1),(0,30,18,5),(3,30,18,24),(3,30,18,25),(3,30,18,26),(3,30,18,27),(3,30,18,28),(3,30,18,29),(5,30,19,0),(3,30,19,24),(3,30,19,25),(3,30,19,26),(3,30,19,27),(3,30,19,28),(3,30,19,29),(5,30,20,0),(5,30,20,1),(3,30,20,24),(3,30,20,25),(3,30,20,26),(3,30,20,27),(3,30,20,28),(3,30,20,29),(5,30,21,0),(3,30,21,25),(3,30,21,26),(3,30,21,27),(3,30,21,28),(3,30,21,29),(5,30,22,0),(14,30,22,1),(3,30,22,27),(3,30,22,28),(3,30,22,29),(5,30,23,0),(4,30,23,20),(3,30,23,26),(3,30,23,27),(3,30,23,28),(3,30,23,29),(5,30,24,0),(4,30,24,18),(4,30,24,19),(4,30,24,20),(4,30,24,21),(4,30,24,22),(0,30,24,24),(3,30,24,27),(3,30,24,28),(5,30,25,0),(5,30,25,2),(4,30,25,19),(4,30,25,20),(4,30,25,21),(4,30,25,22),(5,30,26,0),(5,30,26,1),(5,30,26,2),(6,30,26,6),(6,30,26,7),(2,30,26,16),(4,30,26,19),(4,30,26,20),(4,30,26,21),(4,30,26,22),(4,30,26,23),(6,30,27,5),(6,30,27,6),(5,30,27,7),(5,30,27,8),(5,30,27,11),(5,30,27,12),(4,30,27,19),(4,30,27,20),(4,30,27,21),(4,30,27,22),(4,30,27,23),(4,30,27,24),(5,30,28,1),(5,30,28,2),(5,30,28,3),(5,30,28,4),(6,30,28,5),(6,30,28,6),(5,30,28,7),(5,30,28,8),(5,30,28,10),(5,30,28,11),(5,30,28,12),(5,30,28,13),(5,30,28,14),(4,30,28,19),(4,30,28,20),(4,30,28,21),(4,30,28,22),(4,30,28,23),(0,30,28,24),(5,30,29,2),(6,30,29,3),(6,30,29,4),(6,30,29,5),(6,30,29,6),(5,30,29,7),(5,30,29,8),(5,30,29,9),(5,30,29,10),(5,30,29,11),(5,30,29,12),(5,30,29,13),(4,30,29,18),(4,30,29,19),(4,30,29,20),(4,30,29,21),(4,30,29,22),(5,36,0,16),(5,36,0,17),(5,36,0,18),(5,36,0,19),(5,36,0,20),(5,36,0,35),(0,36,1,8),(5,36,1,10),(1,36,1,12),(1,36,1,16),(5,36,1,18),(2,36,1,20),(0,36,1,25),(0,36,1,30),(5,36,1,35),(4,36,2,0),(4,36,2,1),(4,36,2,2),(4,36,2,3),(4,36,2,4),(5,36,2,10),(5,36,2,18),(5,36,2,35),(4,36,3,0),(0,36,3,1),(4,36,3,3),(4,36,3,4),(5,36,3,10),(5,36,3,11),(5,36,3,12),(5,36,3,17),(5,36,3,18),(6,36,3,28),(5,36,3,33),(5,36,3,34),(5,36,3,35),(4,36,4,0),(4,36,4,3),(4,36,4,4),(4,36,4,5),(13,36,4,8),(5,36,4,10),(5,36,4,17),(6,36,4,18),(6,36,4,20),(6,36,4,28),(5,36,4,33),(5,36,4,34),(5,36,4,35),(4,36,5,1),(4,36,5,2),(4,36,5,3),(3,36,5,4),(0,36,5,5),(5,36,5,10),(5,36,5,11),(5,36,5,12),(6,36,5,18),(6,36,5,19),(6,36,5,20),(6,36,5,21),(6,36,5,28),(6,36,5,29),(5,36,5,31),(5,36,5,32),(5,36,5,33),(5,36,5,35),(4,36,6,0),(4,36,6,1),(4,36,6,2),(3,36,6,3),(3,36,6,4),(3,36,6,7),(5,36,6,10),(10,36,6,11),(6,36,6,17),(6,36,6,18),(6,36,6,20),(6,36,6,29),(6,36,6,30),(6,36,6,31),(5,36,6,32),(5,36,6,33),(5,36,6,34),(4,36,7,0),(4,36,7,2),(4,36,7,3),(3,36,7,4),(3,36,7,5),(3,36,7,6),(3,36,7,7),(5,36,7,15),(6,36,7,29),(6,36,7,30),(5,36,7,31),(5,36,7,32),(5,36,7,33),(5,36,7,34),(0,36,8,1),(4,36,8,3),(14,36,8,4),(5,36,8,15),(5,36,8,16),(5,36,9,15),(5,36,9,16),(5,36,9,17),(3,36,9,26),(3,36,9,27),(4,36,9,35),(5,36,10,14),(5,36,10,15),(5,36,10,16),(5,36,10,17),(4,36,10,18),(4,36,10,19),(3,36,10,26),(3,36,10,27),(4,36,10,33),(4,36,10,34),(4,36,10,35),(11,36,11,5),(2,36,11,12),(4,36,11,18),(4,36,11,19),(3,36,11,26),(3,36,11,27),(3,36,11,28),(4,36,11,33),(3,36,11,34),(4,36,11,35),(6,36,12,0),(0,36,12,1),(4,36,12,18),(4,36,12,19),(3,36,12,25),(3,36,12,26),(4,36,12,34),(4,36,12,35),(6,36,13,0),(4,36,13,17),(4,36,13,18),(4,36,13,19),(4,36,13,20),(3,36,13,25),(3,36,13,26),(3,36,13,27),(4,36,13,34),(4,36,13,35),(6,36,14,0),(10,36,14,11),(4,36,14,18),(3,36,14,26),(3,36,14,27),(3,36,14,34),(4,36,14,35),(6,36,15,0),(6,36,15,1),(6,36,15,2),(14,36,15,4),(9,36,15,8),(3,36,15,15),(6,36,15,23),(3,36,15,25),(3,36,15,26),(3,36,15,33),(3,36,15,34),(3,36,15,35),(6,36,16,0),(0,36,16,1),(3,36,16,15),(8,36,16,16),(8,36,16,19),(6,36,16,23),(6,36,16,24),(6,36,16,25),(3,36,16,35),(6,36,17,0),(3,36,17,15),(6,36,17,22),(6,36,17,23),(6,36,17,25),(3,36,17,34),(3,36,17,35),(6,36,18,0),(3,36,18,11),(3,36,18,12),(3,36,18,13),(3,36,18,14),(3,36,18,15),(6,36,18,22),(6,36,18,23),(3,36,18,34),(5,40,0,0),(3,40,0,13),(3,40,0,14),(3,40,0,15),(14,40,0,16),(5,40,1,0),(0,40,1,2),(0,40,1,8),(3,40,1,12),(3,40,1,13),(3,40,1,14),(3,40,1,15),(5,40,2,0),(5,40,2,1),(3,40,2,12),(3,40,2,13),(3,40,2,14),(3,40,2,15),(5,40,3,0),(5,40,3,1),(5,40,3,2),(3,40,3,14),(3,40,3,15),(5,40,4,1),(5,40,4,2),(14,40,4,11),(9,40,4,16),(3,40,4,23),(3,40,4,24),(0,40,5,1),(4,40,5,4),(4,40,5,7),(4,40,5,8),(4,40,5,9),(3,40,5,21),(3,40,5,22),(3,40,5,23),(4,40,6,3),(4,40,6,4),(4,40,6,8),(4,40,6,9),(4,40,6,10),(3,40,6,23),(3,40,6,24),(4,40,7,4),(4,40,7,5),(4,40,7,6),(4,40,7,7),(4,40,7,8),(4,40,7,9),(4,40,7,10),(3,40,7,22),(3,40,7,23),(3,40,7,24),(4,40,8,2),(4,40,8,3),(4,40,8,4),(4,40,8,5),(4,40,8,6),(4,40,8,7),(4,40,8,9),(4,40,8,10),(10,40,8,16),(3,40,8,24),(0,40,9,3),(4,40,9,5),(4,40,9,6),(2,40,9,8),(2,40,9,13),(1,40,9,21),(3,40,9,24),(4,40,10,5),(4,40,10,6),(5,40,10,7),(6,40,10,20),(3,40,10,24),(4,40,11,5),(5,40,11,7),(5,40,11,8),(6,40,11,20),(6,40,11,21),(5,40,12,7),(5,40,12,8),(6,40,12,18),(6,40,12,19),(6,40,12,20),(6,40,12,21),(6,40,12,22),(0,40,13,3),(5,40,13,6),(5,40,13,7),(5,40,13,8),(5,40,13,9),(6,40,13,17),(6,40,13,18),(6,40,13,19),(6,40,13,20),(6,40,14,19),(3,40,15,0),(3,40,16,0),(3,40,16,1),(3,40,16,2),(6,40,16,5),(5,40,16,22),(5,40,16,24),(3,40,17,0),(3,40,17,1),(3,40,17,2),(6,40,17,3),(6,40,17,4),(6,40,17,5),(5,40,17,22),(5,40,17,24),(3,40,18,0),(3,40,18,1),(1,40,18,2),(6,40,18,4),(6,40,18,5),(6,40,18,6),(5,40,18,22),(5,40,18,23),(5,40,18,24),(3,40,19,0),(3,40,19,1),(6,40,19,4),(6,40,19,5),(6,40,19,6),(4,40,19,12),(4,40,19,16),(4,40,19,17),(5,40,19,22),(5,40,19,23),(3,40,20,0),(6,40,20,4),(6,40,20,6),(6,40,20,7),(4,40,20,11),(4,40,20,12),(4,40,20,13),(4,40,20,14),(4,40,20,15),(4,40,20,16),(3,40,21,0),(4,40,21,12),(4,40,21,13),(4,40,21,14),(4,40,21,15),(4,40,21,16),(4,40,21,17),(4,40,21,18),(0,40,22,3),(4,40,22,12),(4,40,22,13),(4,40,22,14),(4,40,22,15),(4,40,22,16),(4,40,22,18),(3,40,23,11),(4,40,23,12),(5,40,23,14),(4,40,23,16),(4,40,23,17),(4,40,23,18),(4,40,23,19),(4,40,24,0),(4,40,24,3),(4,40,24,4),(4,40,24,5),(3,40,24,11),(3,40,24,12),(3,40,24,13),(5,40,24,14),(4,40,24,18),(4,40,24,19),(4,40,25,0),(4,40,25,1),(4,40,25,3),(4,40,25,4),(3,40,25,7),(3,40,25,8),(3,40,25,9),(3,40,25,10),(3,40,25,11),(3,40,25,12),(3,40,25,13),(5,40,25,14),(4,40,26,1),(4,40,26,2),(4,40,26,3),(4,40,26,4),(3,40,26,7),(3,40,26,8),(3,40,26,11),(3,40,26,12),(5,40,26,13),(5,40,26,14),(5,40,26,15),(5,40,26,16),(5,40,26,18),(5,40,26,19),(5,40,26,20),(5,40,26,21),(4,40,27,0),(4,40,27,1),(4,40,27,2),(4,40,27,3),(4,40,27,4),(4,40,27,5),(3,40,27,6),(3,40,27,7),(3,40,27,8),(3,40,27,12),(5,40,27,13),(5,40,27,14),(5,40,27,19),(4,40,28,0),(4,40,28,1),(4,40,28,2),(4,40,28,3),(0,40,28,4),(6,40,28,6),(3,40,28,8),(3,40,28,9),(3,40,28,12),(5,40,28,19),(4,40,29,0),(4,40,29,1),(4,40,29,2),(4,40,29,3),(6,40,29,6),(3,40,29,8),(3,40,29,9),(5,40,29,19),(5,40,29,20),(4,40,30,1),(6,40,30,2),(4,40,30,3),(6,40,30,4),(6,40,30,5),(6,40,30,6),(6,40,30,7),(6,40,30,8),(3,40,30,9),(5,40,30,19),(4,40,31,1),(6,40,31,2),(6,40,31,3),(6,40,31,4),(6,40,31,5),(6,40,31,6),(3,40,31,9),(6,42,0,0),(6,42,0,1),(6,42,0,2),(5,42,0,5),(5,42,0,6),(5,42,0,7),(5,42,0,8),(5,42,0,9),(5,42,0,10),(5,42,0,11),(6,42,0,12),(6,42,0,13),(6,42,0,14),(6,42,0,15),(6,42,0,16),(6,42,0,17),(6,42,0,18),(6,42,0,19),(6,42,1,0),(6,42,1,1),(5,42,1,7),(5,42,1,8),(5,42,1,9),(5,42,1,11),(5,42,1,12),(5,42,1,13),(6,42,1,17),(6,42,1,18),(6,42,1,19),(6,42,2,0),(6,42,2,1),(5,42,2,2),(5,42,2,7),(5,42,2,8),(5,42,2,9),(5,42,2,10),(5,42,2,11),(3,42,2,16),(6,42,2,17),(6,42,3,0),(5,42,3,2),(5,42,3,3),(5,42,3,4),(5,42,3,8),(5,42,3,9),(5,42,3,10),(3,42,3,14),(3,42,3,15),(3,42,3,16),(3,42,3,17),(6,42,4,0),(6,42,4,1),(5,42,4,2),(5,42,4,3),(5,42,4,8),(5,42,4,9),(5,42,4,11),(3,42,4,13),(3,42,4,14),(3,42,4,15),(3,42,4,16),(3,42,4,17),(6,42,5,0),(5,42,5,2),(5,42,5,8),(5,42,5,9),(5,42,5,10),(5,42,5,11),(3,42,5,12),(3,42,5,13),(3,42,5,14),(3,42,5,15),(3,42,5,16),(3,42,5,17),(6,42,6,0),(5,42,6,2),(5,42,6,3),(5,42,6,10),(3,42,6,11),(3,42,6,12),(3,42,6,13),(3,42,6,14),(3,42,6,15),(3,42,6,17),(3,42,6,18),(3,42,6,19),(3,42,6,20),(5,42,7,0),(5,42,7,1),(5,42,7,2),(5,42,7,3),(6,42,7,5),(3,42,7,10),(3,42,7,11),(3,42,7,12),(3,42,7,13),(3,42,7,16),(3,42,7,17),(5,42,8,0),(5,42,8,1),(6,42,8,5),(6,42,8,6),(6,42,8,7),(3,42,8,17),(4,42,8,23),(4,42,8,24),(5,42,9,0),(5,42,9,1),(5,42,9,2),(6,42,9,3),(6,42,9,4),(6,42,9,5),(6,42,9,6),(6,42,9,7),(4,42,9,23),(4,42,9,24),(5,42,10,0),(5,42,10,1),(5,42,10,2),(6,42,10,3),(6,42,10,4),(6,42,10,6),(4,42,10,20),(4,42,10,21),(4,42,10,23),(4,42,10,24),(5,42,11,0),(5,42,11,1),(5,42,11,2),(5,42,11,3),(6,42,11,17),(4,42,11,20),(4,42,11,21),(4,42,11,22),(4,42,11,23),(4,42,11,24),(5,42,12,0),(5,42,12,1),(5,42,12,2),(5,42,12,12),(6,42,12,13),(6,42,12,14),(6,42,12,15),(6,42,12,17),(6,42,12,18),(4,42,12,20),(4,42,12,21),(4,42,12,23),(4,42,12,24),(5,42,13,0),(5,42,13,11),(5,42,13,12),(5,42,13,13),(6,42,13,14),(6,42,13,15),(6,42,13,16),(6,42,13,17),(6,42,13,18),(4,42,13,21),(4,42,13,22),(4,42,13,23),(4,42,13,24),(5,42,14,1),(5,42,14,12),(5,42,14,13),(5,42,14,14),(6,42,14,15),(6,42,14,16),(6,42,14,17),(6,42,14,18),(6,42,14,19),(4,42,14,21),(4,42,14,23),(4,42,14,24),(5,42,15,0),(5,42,15,1),(5,42,15,9),(5,42,15,10),(5,42,15,13),(5,42,15,14),(6,42,15,15),(6,42,15,17),(6,42,15,18),(5,42,16,0),(5,42,16,1),(5,42,16,9),(5,42,16,10),(5,42,16,11),(5,42,16,12),(5,42,16,13),(5,42,16,14),(5,42,16,15),(6,42,16,16),(6,42,16,17),(6,42,16,18),(5,42,17,0),(5,42,17,1),(5,42,17,9),(5,42,17,10),(5,42,17,12),(5,42,17,13),(5,42,17,15),(5,42,17,16),(6,42,17,18),(5,42,18,0),(5,42,18,1),(5,42,18,6),(5,42,18,11),(5,42,18,12),(6,42,18,18),(5,42,19,0),(5,42,19,1),(5,42,19,2),(5,42,19,3),(5,42,19,4),(5,42,19,6),(5,42,19,12),(5,42,19,13),(5,42,19,14),(5,42,19,16),(5,42,19,17),(5,42,19,18),(5,42,20,0),(5,42,20,1),(5,42,20,2),(5,42,20,3),(5,42,20,4),(5,42,20,5),(5,42,20,6),(5,42,20,12),(5,42,20,14),(5,42,20,16),(5,42,20,17),(5,42,20,18),(5,42,21,0),(5,42,21,1),(5,42,21,2),(5,42,21,3),(5,42,21,6),(5,42,21,13),(5,42,21,14),(5,42,21,15),(5,42,21,16),(5,42,21,17),(0,42,22,1),(5,42,22,6),(5,42,22,12),(5,42,22,13),(5,42,22,14),(5,42,22,16),(5,42,23,11),(5,42,23,12),(5,42,23,13),(5,42,23,14),(5,42,23,15),(5,42,23,16),(5,42,23,17),(3,42,24,12),(3,42,24,13),(5,42,24,14),(5,42,24,16),(5,42,24,17),(11,42,25,0),(13,42,25,6),(3,42,25,9),(3,42,25,10),(3,42,25,11),(3,42,25,12),(3,42,25,13),(3,42,25,14),(3,42,25,15),(5,42,25,17),(5,42,25,18),(3,42,26,8),(3,42,26,9),(3,42,26,10),(3,42,26,11),(3,42,26,12),(3,42,26,13),(3,42,27,8),(3,42,27,9),(3,42,27,10),(3,42,27,11),(3,42,27,12),(2,42,27,22),(3,42,28,9),(3,42,28,10),(3,42,28,11),(2,42,28,15),(10,42,29,0),(3,42,29,8),(3,42,29,9),(3,42,29,10),(3,42,29,11),(3,42,29,12),(3,42,30,9),(14,42,30,10),(4,42,30,23),(4,42,30,24),(3,42,31,7),(3,42,31,8),(3,42,31,9),(8,42,31,17),(4,42,31,20),(4,42,31,21),(4,42,31,22),(4,42,31,23),(4,42,31,24),(4,42,32,20),(4,42,32,21),(4,42,32,22),(9,42,33,1),(14,42,33,10),(4,42,33,20),(4,42,33,21),(4,42,33,22),(4,42,33,23),(4,42,33,24),(1,42,34,21),(4,42,34,23),(4,42,34,24),(4,42,35,23),(4,42,35,24),(4,42,36,21),(4,42,36,22),(4,42,36,23),(4,42,36,24),(0,42,37,9),(4,42,37,21),(8,42,37,22),(3,42,38,20),(3,42,38,21),(4,42,39,11),(3,42,39,17),(3,42,39,18),(3,42,39,19),(3,42,39,20),(3,42,39,21),(4,42,40,11),(3,42,40,17),(3,42,40,19),(3,42,40,20),(3,42,40,21),(3,42,40,22),(13,42,40,23),(4,42,41,10),(4,42,41,11),(0,42,41,12),(0,42,41,16),(3,42,41,19),(0,42,41,20),(3,42,41,22),(9,42,42,4),(4,42,42,9),(4,42,42,10),(4,42,42,11),(3,42,42,19),(3,42,42,22),(1,42,43,1),(0,42,43,8),(4,42,43,10),(4,42,43,11),(4,42,43,12),(4,42,43,13),(3,42,43,17),(3,42,43,18),(3,42,43,19),(3,42,43,20),(3,42,43,21),(3,42,43,22),(4,42,44,10),(4,42,44,11),(4,42,44,12),(4,42,44,13),(4,42,44,14),(3,42,44,16),(3,42,44,17),(3,42,44,18),(3,42,44,19),(3,42,44,20),(3,42,44,21),(3,42,44,22),(4,42,45,7),(4,42,45,8),(4,42,45,9),(4,42,45,10),(4,42,45,11),(4,42,45,12),(4,42,45,13),(4,42,45,14),(3,42,45,18),(3,42,45,19),(3,42,45,20),(3,42,45,21),(3,42,45,22),(4,47,0,7),(4,47,0,8),(4,47,0,9),(4,47,0,10),(4,47,0,11),(4,47,0,24),(4,47,0,25),(4,47,0,26),(4,47,0,27),(4,47,0,28),(4,47,0,29),(4,47,0,30),(4,47,0,31),(4,47,0,32),(4,47,0,33),(4,47,0,34),(4,47,0,35),(4,47,0,37),(3,47,0,39),(3,47,0,40),(3,47,0,41),(3,47,0,42),(3,47,0,43),(3,47,0,44),(4,47,1,7),(4,47,1,8),(4,47,1,9),(4,47,1,10),(4,47,1,11),(4,47,1,23),(4,47,1,24),(4,47,1,25),(4,47,1,27),(4,47,1,28),(4,47,1,29),(4,47,1,30),(4,47,1,31),(4,47,1,32),(4,47,1,33),(4,47,1,34),(4,47,1,35),(4,47,1,36),(4,47,1,37),(3,47,1,38),(3,47,1,39),(3,47,1,40),(3,47,1,41),(3,47,1,42),(3,47,1,43),(3,47,1,44),(11,47,2,1),(4,47,2,7),(4,47,2,8),(4,47,2,9),(4,47,2,10),(4,47,2,11),(13,47,2,22),(4,47,2,26),(4,47,2,27),(4,47,2,29),(4,47,2,30),(4,47,2,31),(4,47,2,32),(4,47,2,33),(4,47,2,34),(4,47,2,35),(4,47,2,36),(4,47,2,37),(4,47,2,38),(3,47,2,39),(3,47,2,40),(3,47,2,41),(3,47,2,42),(3,47,2,43),(3,47,2,44),(3,47,2,45),(3,47,3,0),(4,47,3,7),(4,47,3,8),(4,47,3,9),(4,47,3,10),(4,47,3,11),(4,47,3,26),(4,47,3,27),(4,47,3,28),(4,47,3,29),(4,47,3,30),(4,47,3,31),(4,47,3,32),(4,47,3,33),(4,47,3,34),(4,47,3,35),(4,47,3,36),(4,47,3,37),(4,47,3,38),(4,47,3,39),(4,47,3,40),(5,47,3,41),(5,47,3,42),(3,47,3,43),(3,47,3,44),(3,47,4,0),(4,47,4,7),(1,47,4,9),(4,47,4,11),(10,47,4,24),(11,47,4,29),(4,47,4,35),(4,47,4,36),(4,47,4,37),(5,47,4,42),(5,47,4,43),(5,47,4,44),(5,47,4,48),(3,47,5,0),(4,47,5,7),(4,47,5,8),(4,47,5,11),(4,47,5,35),(4,47,5,36),(4,47,5,37),(4,47,5,38),(4,47,5,39),(5,47,5,40),(5,47,5,41),(5,47,5,42),(5,47,5,43),(5,47,5,44),(5,47,5,47),(5,47,5,48),(3,47,6,0),(3,47,6,1),(3,47,6,2),(3,47,6,3),(3,47,6,4),(3,47,6,5),(3,47,6,6),(4,47,6,8),(4,47,6,9),(4,47,6,10),(4,47,6,11),(4,47,6,35),(3,47,6,36),(4,47,6,37),(5,47,6,42),(5,47,6,43),(5,47,6,44),(5,47,6,45),(5,47,6,47),(5,47,6,48),(3,47,7,0),(3,47,7,1),(3,47,7,2),(3,47,7,3),(3,47,7,4),(3,47,7,5),(3,47,7,6),(4,47,7,10),(4,47,7,11),(10,47,7,18),(3,47,7,35),(3,47,7,36),(3,47,7,37),(5,47,7,38),(5,47,7,39),(5,47,7,40),(5,47,7,41),(5,47,7,42),(5,47,7,43),(5,47,7,44),(5,47,7,45),(5,47,7,46),(5,47,7,47),(5,47,7,48),(3,47,8,2),(2,47,8,3),(3,47,8,5),(3,47,8,6),(3,47,8,7),(1,47,8,8),(4,47,8,11),(3,47,8,32),(3,47,8,33),(3,47,8,34),(3,47,8,35),(3,47,8,36),(6,47,8,37),(5,47,8,38),(5,47,8,39),(5,47,8,40),(5,47,8,41),(5,47,8,43),(5,47,8,44),(5,47,8,46),(5,47,8,47),(5,47,8,48),(3,47,9,2),(2,47,9,13),(3,47,9,32),(3,47,9,33),(3,47,9,34),(3,47,9,35),(6,47,9,36),(6,47,9,37),(5,47,9,39),(5,47,9,40),(5,47,9,41),(5,47,9,43),(5,47,9,44),(5,47,9,45),(5,47,9,46),(5,47,9,47),(5,47,9,48),(3,47,10,33),(3,47,10,34),(6,47,10,35),(6,47,10,36),(6,47,10,37),(5,47,10,40),(5,47,10,41),(5,47,10,42),(5,47,10,43),(5,47,10,44),(5,47,10,45),(5,47,10,46),(5,47,10,47),(5,47,10,48),(9,47,11,5),(3,47,11,33),(3,47,11,34),(6,47,11,35),(6,47,11,36),(5,47,11,44),(5,47,11,45),(5,47,11,46),(5,47,11,47),(5,47,11,48),(0,47,12,17),(3,47,12,34),(6,47,12,36),(5,47,12,44),(5,47,12,45),(6,47,12,48),(0,47,13,13),(3,47,13,32),(3,47,13,33),(3,47,13,34),(6,47,13,36),(6,47,13,37),(3,47,13,38),(3,47,13,39),(6,47,13,44),(6,47,13,48),(0,47,14,9),(3,47,14,34),(6,47,14,35),(6,47,14,36),(6,47,14,37),(6,47,14,38),(3,47,14,39),(6,47,14,44),(6,47,14,45),(6,47,14,46),(6,47,14,47),(6,47,14,48),(5,47,15,12),(5,47,15,13),(6,47,15,35),(6,47,15,37),(3,47,15,38),(3,47,15,39),(3,47,15,40),(3,47,15,41),(6,47,15,48),(5,47,16,7),(5,47,16,8),(5,47,16,9),(5,47,16,10),(5,47,16,11),(5,47,16,12),(5,47,16,13),(6,47,16,37),(3,47,16,38),(3,47,16,41),(3,47,16,42),(0,47,17,4),(5,47,17,8),(5,47,17,9),(5,47,17,10),(5,47,17,11),(5,47,17,12),(5,47,17,13),(5,47,17,14),(3,47,17,15),(3,47,17,36),(3,47,17,37),(3,47,17,38),(3,47,17,39),(3,47,17,40),(3,47,17,42),(3,47,17,43),(5,47,18,10),(5,47,18,11),(5,47,18,12),(0,47,18,13),(3,47,18,15),(3,47,18,16),(3,47,18,17),(4,47,18,35),(3,47,18,36),(3,47,18,38),(3,47,18,39),(0,47,19,8),(5,47,19,10),(5,47,19,11),(5,47,19,12),(3,47,19,15),(3,47,19,17),(3,47,19,18),(4,47,19,34),(4,47,19,35),(3,47,19,38),(3,47,19,39),(9,47,20,4),(5,47,20,10),(5,47,20,12),(5,47,20,13),(3,47,20,14),(3,47,20,15),(3,47,20,16),(3,47,20,17),(4,47,20,35),(4,47,20,40),(0,47,21,1),(5,47,21,12),(5,47,21,13),(5,47,21,14),(3,47,21,15),(6,47,21,16),(3,47,21,17),(3,47,21,18),(3,47,21,19),(4,47,21,35),(4,47,21,38),(4,47,21,40),(6,47,21,48),(8,47,22,8),(5,47,22,11),(5,47,22,12),(0,47,22,13),(3,47,22,15),(6,47,22,16),(6,47,22,17),(6,47,22,18),(4,47,22,34),(4,47,22,35),(4,47,22,36),(4,47,22,38),(4,47,22,39),(4,47,22,40),(4,47,22,41),(6,47,22,45),(6,47,22,46),(6,47,22,47),(6,47,22,48),(5,47,23,11),(5,47,23,12),(3,47,23,15),(6,47,23,16),(6,47,23,17),(6,47,23,18),(4,47,23,33),(4,47,23,34),(4,47,23,35),(4,47,23,36),(4,47,23,37),(4,47,23,39),(4,47,23,40),(4,47,23,41),(6,47,23,46),(6,47,23,47),(6,47,23,48),(3,47,24,11),(3,47,24,12),(3,47,24,13),(3,47,24,14),(3,47,24,15),(6,47,24,16),(6,47,24,17),(4,47,24,33),(4,47,24,34),(4,47,24,35),(4,47,24,36),(4,47,24,37),(4,47,24,38),(4,47,24,39),(4,47,24,41),(4,47,24,42),(6,47,24,47);
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
) ENGINE=InnoDB AUTO_INCREMENT=290 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `units`
--

LOCK TABLES `units` WRITE;
/*!40000 ALTER TABLE `units` DISABLE KEYS */;
INSERT INTO `units` VALUES (1,3000,1,1,1,NULL,NULL,NULL,NULL,0,0,'Rhyno',0,4,72,NULL,1,0,0,0),(2,3000,1,1,1,NULL,NULL,NULL,NULL,0,0,'Rhyno',0,4,72,NULL,1,0,0,0),(3,3000,1,1,1,NULL,NULL,NULL,NULL,0,0,'Rhyno',0,4,72,NULL,1,0,0,0),(4,3400,1,1,1,NULL,NULL,NULL,NULL,0,0,'Thor',0,4,72,NULL,1,0,0,0),(5,8000,1,1,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,4,72,NULL,1,0,0,0),(6,8000,1,1,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,4,72,NULL,1,0,0,0),(7,8000,1,1,1,NULL,NULL,NULL,NULL,0,0,'Dirac',0,4,72,NULL,1,0,0,0),(8,100,1,6,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(9,100,1,6,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(10,200,1,6,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(11,100,1,6,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(12,100,1,6,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(13,100,1,6,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(14,200,1,7,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(15,100,1,7,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(16,100,1,8,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(17,200,1,8,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(18,100,1,8,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(19,200,1,8,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(20,100,1,8,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(21,100,1,8,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(22,100,1,8,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(23,100,1,9,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(24,200,1,9,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(25,100,1,9,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(26,200,1,10,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(27,100,1,10,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(28,100,1,10,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(29,100,1,11,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(30,100,1,11,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(31,100,1,12,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(32,100,1,12,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(33,100,1,13,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(34,100,1,13,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(35,100,1,14,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(36,100,1,14,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(37,3400,1,1,1,NULL,NULL,NULL,NULL,0,0,'Thor',0,5,345,NULL,1,0,0,0),(38,8000,1,1,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,5,345,NULL,1,0,0,0),(39,8000,1,1,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,5,345,NULL,1,0,0,0),(40,8000,1,1,1,NULL,NULL,NULL,NULL,0,0,'Dirac',0,5,345,NULL,1,0,0,0),(41,3000,1,1,1,NULL,NULL,NULL,NULL,0,0,'Rhyno',0,3,90,NULL,1,0,0,0),(42,3400,1,1,1,NULL,NULL,NULL,NULL,0,0,'Thor',0,3,90,NULL,1,0,0,0),(43,3400,1,1,1,NULL,NULL,NULL,NULL,0,0,'Thor',1,3,90,NULL,1,0,0,0),(44,8000,1,1,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,3,90,NULL,1,0,0,0),(45,8000,1,1,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,3,90,NULL,1,0,0,0),(46,8000,1,1,1,NULL,NULL,NULL,NULL,0,0,'Dirac',0,3,90,NULL,1,0,0,0),(47,100,1,19,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(48,200,1,19,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(49,100,1,19,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(50,200,1,19,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(51,100,1,19,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(52,200,1,19,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(53,100,1,19,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(54,200,1,19,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(55,100,1,19,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(56,100,1,20,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(57,200,1,20,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(58,200,1,20,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(59,100,1,20,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(60,100,1,20,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(61,100,1,21,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(62,100,1,21,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(63,100,1,22,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(64,100,1,22,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(65,100,1,22,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(66,200,1,23,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(67,100,1,23,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(68,100,1,23,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(69,100,1,24,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(70,100,1,24,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(71,100,1,25,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(72,100,1,25,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(73,100,1,26,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(74,100,1,26,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(75,100,1,32,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(76,200,1,32,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(77,100,1,32,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(78,100,1,32,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(79,200,1,32,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(80,100,1,32,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(81,100,1,32,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(82,100,1,33,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(83,200,1,33,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(84,100,1,33,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(85,100,1,33,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(86,100,1,34,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(87,100,1,34,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(88,100,1,35,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(89,100,1,35,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(90,100,1,36,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(91,100,1,36,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(92,100,1,37,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(93,100,1,37,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(94,100,1,38,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(95,100,1,38,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(96,3000,1,2,1,NULL,NULL,NULL,NULL,0,0,'Rhyno',0,1,180,NULL,1,0,0,0),(97,3400,1,2,1,NULL,NULL,NULL,NULL,0,0,'Thor',1,1,180,NULL,1,0,0,0),(98,8000,1,2,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,1,180,NULL,1,0,0,0),(99,8000,1,2,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,1,180,NULL,1,0,0,0),(100,8000,1,2,1,NULL,NULL,NULL,NULL,0,0,'Dirac',0,1,180,NULL,1,0,0,0),(101,100,1,44,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(102,100,1,44,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(103,200,1,44,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(104,100,1,44,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(105,100,1,44,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(106,200,1,45,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(107,100,1,45,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(108,100,1,45,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(109,200,1,46,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(110,100,1,46,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(111,100,1,46,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(112,200,1,47,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(113,100,1,47,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(114,100,1,47,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(115,100,1,48,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(116,100,1,49,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(117,100,1,49,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(118,100,1,50,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(119,100,1,50,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(120,100,1,51,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(121,3400,1,2,1,NULL,NULL,NULL,NULL,0,0,'Thor',1,3,44,NULL,1,0,0,0),(122,8000,1,2,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,3,44,NULL,1,0,0,0),(123,8000,1,2,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,3,44,NULL,1,0,0,0),(124,8000,1,2,1,NULL,NULL,NULL,NULL,0,0,'Dirac',0,3,44,NULL,1,0,0,0),(125,3400,1,2,1,NULL,NULL,NULL,NULL,0,0,'Thor',1,3,270,NULL,1,0,0,0),(126,8000,1,2,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,3,270,NULL,1,0,0,0),(127,8000,1,2,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,3,270,NULL,1,0,0,0),(128,8000,1,2,1,NULL,NULL,NULL,NULL,0,0,'Dirac',0,3,270,NULL,1,0,0,0),(129,100,1,54,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(130,100,1,54,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(131,100,1,54,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(132,200,1,55,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(133,100,1,55,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(134,100,1,55,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(135,100,1,56,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(136,100,1,56,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(137,100,1,57,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(138,100,1,57,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(139,100,1,58,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(140,100,1,58,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(141,100,1,59,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(142,100,1,59,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(143,200,1,66,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(144,100,1,66,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(145,200,1,66,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(146,100,1,66,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(147,200,1,66,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(148,100,1,66,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(149,100,1,66,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(150,100,1,67,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(151,200,1,67,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(152,100,1,67,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(153,100,1,67,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(154,200,1,71,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(155,100,1,71,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(156,100,1,71,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(157,200,1,72,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(158,100,1,72,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(159,100,1,72,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(160,100,1,73,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(161,100,1,73,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(162,100,1,74,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(163,100,1,74,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(164,200,1,75,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(165,100,1,75,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(166,100,1,75,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(167,100,1,76,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(168,100,1,76,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(169,100,1,77,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(170,100,1,77,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(171,200,1,78,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(172,100,1,78,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(173,100,1,78,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(174,200,1,79,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(175,100,1,79,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(176,100,1,79,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(177,200,1,80,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(178,100,1,80,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(179,100,1,80,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(180,100,1,81,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(181,100,1,81,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(182,3400,1,3,1,NULL,NULL,NULL,NULL,0,0,'Thor',0,5,195,NULL,1,0,0,0),(183,3400,1,3,1,NULL,NULL,NULL,NULL,0,0,'Thor',1,5,195,NULL,1,0,0,0),(184,8000,1,3,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,5,195,NULL,1,0,0,0),(185,8000,1,3,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,5,195,NULL,1,0,0,0),(186,8000,1,3,1,NULL,NULL,NULL,NULL,0,0,'Dirac',0,5,195,NULL,1,0,0,0),(187,3000,1,3,1,NULL,NULL,NULL,NULL,0,0,'Rhyno',0,2,60,NULL,1,0,0,0),(188,3400,1,3,1,NULL,NULL,NULL,NULL,0,0,'Thor',0,2,60,NULL,1,0,0,0),(189,3400,1,3,1,NULL,NULL,NULL,NULL,0,0,'Thor',1,2,60,NULL,1,0,0,0),(190,8000,1,3,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,2,60,NULL,1,0,0,0),(191,8000,1,3,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,2,60,NULL,1,0,0,0),(192,8000,1,3,1,NULL,NULL,NULL,NULL,0,0,'Dirac',0,2,60,NULL,1,0,0,0),(193,200,1,86,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(194,100,1,86,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(195,100,1,86,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(196,100,1,87,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(197,100,1,87,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(198,100,1,88,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(199,100,1,88,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(200,100,1,89,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(201,100,1,89,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(202,100,1,90,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(203,100,1,90,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(204,200,1,96,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(205,100,1,96,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(206,100,1,96,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(207,100,1,97,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(208,100,1,97,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(209,100,1,98,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(210,100,1,99,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(211,100,1,99,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(212,100,1,106,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(213,200,1,106,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(214,100,1,106,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(215,200,1,106,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(216,100,1,106,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(217,200,1,106,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(218,100,1,106,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(219,200,1,106,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(220,100,1,106,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(221,100,1,107,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(222,100,1,107,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(223,200,1,107,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(224,100,1,107,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(225,100,1,107,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(226,100,1,108,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(227,200,1,108,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(228,100,1,108,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(229,200,1,108,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(230,100,1,108,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(231,200,1,108,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(232,100,1,108,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(233,100,1,108,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(234,100,1,109,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(235,200,1,109,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(236,100,1,109,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(237,200,1,109,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(238,100,1,109,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(239,200,1,109,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(240,100,1,109,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(241,100,1,109,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(242,200,1,110,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(243,100,1,110,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(244,200,1,111,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(245,100,1,111,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(246,100,1,112,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(247,100,1,113,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(248,100,1,113,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(249,100,1,114,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(250,100,1,114,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(251,100,1,115,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(252,100,1,115,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(253,3400,1,4,1,NULL,NULL,NULL,NULL,0,0,'Thor',1,4,90,NULL,1,0,0,0),(254,8000,1,4,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,4,90,NULL,1,0,0,0),(255,8000,1,4,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,4,90,NULL,1,0,0,0),(256,8000,1,4,1,NULL,NULL,NULL,NULL,0,0,'Dirac',0,4,90,NULL,1,0,0,0),(257,100,1,122,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(258,200,1,122,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(259,200,1,122,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(260,200,1,122,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(261,100,1,122,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(262,100,1,122,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(263,100,1,123,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(264,200,1,123,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(265,100,1,123,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(266,200,1,123,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(267,100,1,123,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(268,200,1,123,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(269,100,1,123,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(270,100,1,124,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(271,100,1,124,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(272,100,1,124,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(273,200,1,125,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,NULL,NULL,NULL,1,0,0,0),(274,100,1,125,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(275,100,1,125,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(276,100,1,126,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(277,100,1,126,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(278,100,1,127,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(279,100,1,127,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(280,100,1,128,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(281,100,1,128,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(282,100,1,129,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(283,100,1,129,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,NULL,NULL,NULL,1,0,0,0),(284,3000,1,4,1,NULL,NULL,NULL,NULL,0,0,'Rhyno',0,3,180,NULL,1,0,0,0),(285,3000,1,4,1,NULL,NULL,NULL,NULL,0,0,'Rhyno',0,3,180,NULL,1,0,0,0),(286,3000,1,4,1,NULL,NULL,NULL,NULL,0,0,'Rhyno',0,3,180,NULL,1,0,0,0),(287,3400,1,4,1,NULL,NULL,NULL,NULL,0,0,'Thor',0,3,180,NULL,1,0,0,0),(288,8000,1,4,1,NULL,NULL,NULL,NULL,0,0,'Dirac',1,3,180,NULL,1,0,0,0),(289,8000,1,4,1,NULL,NULL,NULL,NULL,0,0,'Dirac',0,3,180,NULL,1,0,0,0);
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

-- Dump completed on 2010-11-04 13:22:17
