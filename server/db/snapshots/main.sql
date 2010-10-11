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
) ENGINE=InnoDB AUTO_INCREMENT=23 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `buildings`
--

LOCK TABLES `buildings` WRITE;
/*!40000 ALTER TABLE `buildings` DISABLE KEYS */;
INSERT INTO `buildings` VALUES (1,33,7,16,0,0,0,1,'Thunder',NULL,8,17,NULL,1,300,NULL,0,NULL,NULL,0),(2,33,21,16,0,0,0,1,'Thunder',NULL,22,17,NULL,1,300,NULL,0,NULL,NULL,0),(3,33,21,9,0,0,0,1,'Screamer',NULL,22,10,NULL,1,300,NULL,0,NULL,NULL,0),(4,33,18,28,0,0,0,1,'NpcSolarPlant',NULL,19,29,NULL,0,1000,NULL,0,NULL,NULL,0),(5,33,7,9,0,0,0,1,'Vulcan',NULL,8,10,NULL,1,300,NULL,0,NULL,NULL,0),(6,33,14,22,0,0,0,1,'Thunder',NULL,15,23,NULL,1,300,NULL,0,NULL,NULL,0),(7,33,26,16,0,0,0,1,'NpcZetiumExtractor',NULL,27,17,NULL,0,800,NULL,0,NULL,NULL,0),(8,33,3,27,0,0,0,1,'NpcMetalExtractor',NULL,4,28,NULL,0,400,NULL,0,NULL,NULL,0),(9,33,28,24,0,0,0,1,'NpcMetalExtractor',NULL,29,25,NULL,0,400,NULL,0,NULL,NULL,0),(10,33,18,25,0,0,0,1,'NpcSolarPlant',NULL,19,26,NULL,0,1000,NULL,0,NULL,NULL,0),(11,33,15,26,0,0,0,1,'NpcSolarPlant',NULL,16,27,NULL,0,1000,NULL,0,NULL,NULL,0),(12,33,7,28,0,0,0,1,'NpcCommunicationsHub',NULL,9,29,NULL,0,1200,NULL,0,NULL,NULL,0),(13,33,21,22,0,0,0,1,'Vulcan',NULL,22,23,NULL,1,300,NULL,0,NULL,NULL,0),(14,33,24,24,0,0,0,1,'NpcMetalExtractor',NULL,25,25,NULL,0,400,NULL,0,NULL,NULL,0),(15,33,0,28,0,0,0,1,'NpcMetalExtractor',NULL,1,29,NULL,0,400,NULL,0,NULL,NULL,0),(16,33,11,14,0,0,0,1,'Mothership',NULL,18,19,NULL,1,10500,NULL,0,NULL,NULL,0),(17,33,22,27,0,0,0,1,'NpcSolarPlant',NULL,23,28,NULL,0,1000,NULL,0,NULL,NULL,0),(18,33,14,9,0,0,0,1,'Thunder',NULL,15,10,NULL,1,300,NULL,0,NULL,NULL,0),(19,33,25,20,0,0,0,1,'NpcTemple',NULL,27,22,NULL,0,1500,NULL,0,NULL,NULL,0),(20,33,12,27,0,0,0,1,'NpcSolarPlant',NULL,13,28,NULL,0,1000,NULL,0,NULL,NULL,0),(21,33,7,22,0,0,0,1,'Screamer',NULL,8,23,NULL,1,300,NULL,0,NULL,NULL,0),(22,33,26,27,0,0,0,1,'NpcCommunicationsHub',NULL,28,28,NULL,0,1200,NULL,0,NULL,NULL,0);
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
  `variation` tinyint(2) unsigned NOT NULL DEFAULT '0',
  UNIQUE KEY `coords` (`planet_id`,`x`,`y`),
  CONSTRAINT `folliages_ibfk_1` FOREIGN KEY (`planet_id`) REFERENCES `planets` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `folliages`
--

LOCK TABLES `folliages` WRITE;
/*!40000 ALTER TABLE `folliages` DISABLE KEYS */;
INSERT INTO `folliages` VALUES (2,0,0,12),(2,0,5,13),(2,0,6,2),(2,0,18,6),(2,0,28,3),(2,0,29,10),(2,0,50,0),(2,0,51,7),(2,1,7,12),(2,1,10,9),(2,1,11,4),(2,1,13,7),(2,1,15,13),(2,1,29,12),(2,1,51,13),(2,1,53,6),(2,1,54,12),(2,1,55,0),(2,2,2,6),(2,2,9,10),(2,2,12,10),(2,2,17,4),(2,2,19,4),(2,2,23,3),(2,2,24,8),(2,2,25,3),(2,2,26,12),(2,2,30,0),(2,2,31,3),(2,2,33,5),(2,2,50,9),(2,2,53,12),(2,3,6,2),(2,3,8,13),(2,3,9,12),(2,3,21,13),(2,3,31,3),(2,3,48,7),(2,3,49,1),(2,4,10,10),(2,4,15,4),(2,4,23,7),(2,4,24,10),(2,4,30,12),(2,4,32,10),(2,4,51,7),(2,4,55,3),(2,5,0,9),(2,5,4,6),(2,5,8,12),(2,5,10,7),(2,5,11,6),(2,5,21,1),(2,6,0,1),(2,6,21,11),(2,6,22,12),(2,6,32,0),(2,6,34,7),(2,6,35,10),(2,6,48,11),(2,6,50,11),(2,7,0,7),(2,7,2,10),(2,7,12,9),(2,7,13,12),(2,7,14,8),(2,7,15,4),(2,7,16,2),(2,7,17,1),(2,7,20,12),(2,7,22,3),(2,7,44,4),(2,7,45,5),(2,7,49,9),(2,8,1,0),(2,8,7,13),(2,8,8,7),(2,8,12,2),(2,8,13,5),(2,8,14,13),(2,8,18,8),(2,8,19,12),(2,8,26,7),(2,8,41,0),(2,8,46,5),(2,8,47,12),(2,8,49,4),(2,9,0,4),(2,9,14,13),(2,9,15,5),(2,9,22,8),(2,9,25,11),(2,9,31,0),(2,9,45,7),(2,9,49,12),(2,10,18,6),(2,10,19,1),(2,10,21,1),(2,10,25,6),(2,10,31,8),(2,10,43,6),(2,10,47,13),(2,10,49,7),(2,10,50,2),(2,10,53,5),(2,11,4,12),(2,11,19,11),(2,11,21,9),(2,11,23,7),(2,11,24,5),(2,11,28,10),(2,11,34,9),(2,11,35,1),(2,11,45,2),(2,11,47,6),(2,11,48,11),(2,11,50,1),(2,11,53,8),(2,11,55,5),(2,12,2,5),(2,12,7,8),(2,12,11,13),(2,12,23,8),(2,12,24,4),(2,12,26,4),(2,12,29,4),(2,12,35,4),(2,12,44,12),(2,12,45,3),(2,12,47,8),(2,12,49,13),(2,12,55,4),(2,13,7,12),(2,13,10,8),(2,13,15,10),(2,13,16,1),(2,13,19,9),(2,13,20,13),(2,13,24,2),(2,13,42,1),(2,13,45,10),(2,13,48,6),(2,13,50,2),(2,13,52,1),(2,13,54,13),(2,13,55,2),(2,14,7,4),(2,14,8,7),(2,14,14,9),(2,14,48,8),(2,14,54,10),(2,15,10,10),(2,15,14,11),(2,15,20,0),(2,15,29,9),(2,15,31,6),(2,15,32,3),(2,15,47,6),(2,16,6,13),(2,16,13,0),(2,16,14,8),(2,16,26,7),(2,16,27,10),(2,16,47,9),(2,17,16,12),(2,17,24,4),(2,17,28,12),(2,18,15,9),(2,18,16,4),(2,18,17,6),(2,18,29,9),(2,18,50,2),(2,19,13,7),(2,19,27,5),(2,19,28,10),(2,19,29,12),(2,20,1,11),(2,20,17,3),(2,20,34,1),(2,20,47,5),(2,21,4,10),(2,21,14,7),(2,21,16,13),(2,21,24,5),(2,21,43,8),(2,22,1,3),(2,22,4,13),(2,22,13,5),(2,22,15,8),(2,22,41,7),(2,22,44,12),(2,23,15,12),(2,23,38,8),(2,23,42,2),(2,23,43,9),(2,23,44,8),(2,23,45,2),(2,23,55,13),(2,24,0,4),(2,24,13,8),(2,24,16,7),(2,24,18,7),(2,24,31,7),(2,24,34,5),(2,24,38,7),(2,24,44,0),(2,24,45,5),(2,24,46,0),(2,24,47,13),(3,0,12,5),(3,0,19,8),(3,0,23,5),(3,0,30,5),(3,1,10,10),(3,1,13,8),(3,1,24,4),(3,1,27,4),(3,2,10,12),(3,2,28,4),(3,2,29,12),(3,3,0,10),(3,3,1,3),(3,3,24,5),(3,3,25,9),(3,3,28,10),(3,4,0,2),(3,4,1,4),(3,4,30,6),(3,5,2,12),(3,5,23,10),(3,5,24,12),(3,5,26,8),(3,5,29,12),(3,6,1,9),(3,6,4,9),(3,6,25,10),(3,6,27,12),(3,6,30,7),(3,7,1,7),(3,7,3,2),(3,7,4,12),(3,7,24,5),(3,7,29,9),(3,8,0,6),(3,8,14,6),(3,8,16,5),(3,8,21,10),(3,8,22,11),(3,8,23,0),(3,8,30,8),(3,9,3,3),(3,9,12,7),(3,9,19,1),(3,9,24,10),(3,9,29,13),(3,10,9,0),(3,10,20,2),(3,10,21,6),(3,11,2,6),(3,11,10,7),(3,11,11,2),(3,11,18,9),(3,11,19,0),(3,11,20,13),(3,12,2,6),(3,12,3,12),(3,12,6,5),(3,12,9,3),(3,12,15,5),(3,12,16,8),(3,12,17,12),(3,12,19,13),(3,12,21,13),(3,13,6,0),(3,13,14,10),(3,13,15,12),(3,13,18,5),(3,13,21,2),(3,13,29,11),(3,14,5,2),(3,14,18,10),(3,14,19,3),(3,14,27,4),(3,14,28,10),(3,14,30,8),(3,15,14,12),(3,15,15,8),(3,15,17,6),(3,15,22,8),(3,15,26,10),(3,16,2,9),(3,16,6,3),(3,16,17,11),(3,16,19,13),(3,16,21,11),(3,16,26,13),(3,16,29,2),(3,17,20,7),(3,17,21,7),(3,18,0,12),(3,18,19,3),(3,19,0,0),(3,19,2,8),(3,19,4,0),(3,20,2,11),(3,20,11,11),(3,20,30,11),(3,21,25,2),(3,22,2,2),(3,22,4,13),(3,22,5,6),(3,22,18,0),(3,22,28,13),(3,22,29,6),(3,23,6,10),(3,24,7,0),(3,24,29,11),(3,25,4,3),(3,25,5,3),(3,25,7,10),(3,25,8,5),(3,25,28,12),(3,26,4,8),(3,26,7,5),(3,26,13,3),(3,26,28,0),(3,26,30,12),(3,27,1,5),(3,27,3,12),(3,27,11,1),(3,27,14,1),(3,27,26,9),(3,28,1,2),(3,28,25,10),(3,28,29,9),(3,28,30,10),(3,29,0,2),(3,29,12,4),(3,29,26,12),(3,30,0,2),(3,30,8,0),(3,30,22,11),(3,30,26,10),(3,30,30,5),(3,31,0,13),(3,31,5,12),(3,31,6,2),(3,31,10,2),(3,31,12,12),(3,32,22,5),(3,32,29,3),(3,32,30,10),(3,33,1,9),(3,33,2,1),(3,33,3,7),(3,33,7,12),(3,33,22,7),(3,34,2,4),(3,34,6,12),(3,34,14,5),(3,34,22,4),(3,34,23,0),(3,35,5,1),(3,35,6,13),(3,36,2,12),(3,36,22,9),(3,37,1,1),(3,37,2,0),(3,37,4,9),(3,38,1,7),(3,38,4,13),(3,39,0,12),(3,39,16,10),(3,39,23,12),(3,39,24,12),(3,39,26,6),(7,0,15,7),(7,0,17,5),(7,0,18,6),(7,0,28,8),(7,0,39,0),(7,1,6,3),(7,1,14,7),(7,1,33,10),(7,2,6,7),(7,2,16,4),(7,2,18,2),(7,2,19,7),(7,2,26,12),(7,3,4,4),(7,3,5,10),(7,3,6,5),(7,3,13,6),(7,3,16,11),(7,3,20,8),(7,3,25,4),(7,3,33,13),(7,4,13,12),(7,4,25,10),(7,4,33,6),(7,5,2,0),(7,5,8,2),(7,5,25,4),(7,5,26,3),(7,6,1,11),(7,6,2,9),(7,6,7,12),(7,6,12,0),(7,7,1,9),(7,7,4,11),(7,7,12,11),(7,7,22,2),(7,8,0,4),(7,8,1,9),(7,8,6,5),(7,8,9,9),(7,8,30,6),(7,9,0,8),(7,9,3,3),(7,9,16,1),(7,9,23,13),(7,10,3,6),(7,10,17,3),(7,10,20,3),(7,10,22,13),(7,11,17,5),(7,12,15,4),(7,12,21,9),(7,12,38,9),(7,13,14,1),(7,13,16,11),(7,13,19,2),(7,13,21,1),(7,14,7,2),(7,14,15,12),(7,14,17,5),(7,14,39,10),(7,15,12,10),(7,15,32,7),(7,16,13,3),(7,16,19,9),(7,16,30,12),(7,16,33,3),(7,16,38,10),(7,17,11,5),(7,17,12,10),(7,17,33,2),(7,17,37,12),(7,18,14,1),(7,18,34,11),(7,18,39,10),(7,19,0,5),(7,19,1,2),(7,19,4,1),(7,19,16,9),(7,19,23,9),(7,19,31,4),(7,19,34,10),(7,20,1,1),(7,20,11,7),(7,20,14,0),(7,20,17,6),(7,20,29,8),(7,21,2,10),(7,21,4,13),(7,21,6,7),(7,21,7,12),(7,21,8,11),(7,21,9,3),(7,21,34,1),(7,21,35,12),(7,21,36,7),(7,21,39,9),(7,22,5,5),(7,22,30,3),(7,22,37,5),(7,22,38,0),(7,22,40,13),(7,23,2,7),(7,23,15,13),(7,23,40,8),(7,24,0,9),(7,24,4,4),(7,24,5,7),(7,24,35,8),(7,24,38,1),(7,24,39,6),(7,24,40,6),(7,25,3,7),(7,25,31,0),(7,25,33,2),(7,25,36,6),(7,25,38,6),(7,26,0,9),(7,26,2,5),(7,26,39,12),(7,27,0,1),(7,27,3,3),(7,28,1,3),(7,28,3,13),(7,28,19,6),(7,28,22,9),(7,28,34,6),(7,29,1,2),(7,29,2,2),(7,29,4,13),(7,29,14,2),(7,29,15,9),(7,29,34,5),(7,30,1,2),(7,30,13,1),(7,30,36,4),(7,31,13,12),(7,31,36,12),(7,32,0,6),(7,32,1,4),(7,32,11,4),(7,32,22,12),(7,32,35,1),(7,32,38,12),(20,0,5,7),(20,0,6,4),(20,0,7,10),(20,0,19,10),(20,0,21,7),(20,1,5,13),(20,1,20,7),(20,2,8,0),(20,2,9,12),(20,2,18,8),(20,4,12,11),(20,4,15,4),(20,5,2,1),(20,5,10,13),(20,5,16,9),(20,7,7,12),(20,8,7,0),(20,13,7,5),(20,14,2,4),(20,14,6,4),(20,14,11,6),(20,14,12,2),(20,15,9,4),(20,16,1,3),(20,16,13,10),(20,16,14,9),(20,17,8,1),(20,17,10,6),(20,17,12,3),(20,18,0,8),(20,18,1,4),(20,18,11,13),(20,20,4,12),(20,20,10,11),(20,20,19,13),(20,20,20,2),(20,21,1,5),(20,21,2,13),(20,21,15,7),(20,21,16,0),(20,21,18,3),(20,21,21,9),(20,22,6,13),(20,22,12,10),(20,22,20,10),(20,23,7,2),(20,23,9,7),(20,23,11,4),(20,23,17,9),(20,24,0,3),(20,24,7,11),(20,24,10,8),(20,24,12,4),(20,24,13,10),(20,24,14,10),(20,24,18,4),(20,25,4,5),(20,25,5,4),(20,25,6,10),(20,25,7,0),(20,25,11,2),(20,25,12,7),(20,25,13,11),(20,26,0,5),(20,26,4,10),(20,26,5,4),(20,26,6,13),(20,26,13,1),(20,27,6,12),(20,27,14,7),(20,27,19,8),(20,27,21,12),(20,28,6,3),(20,28,7,3),(20,28,9,0),(20,29,3,12),(20,29,4,3),(20,29,5,1),(20,29,7,1),(20,29,8,5),(20,29,9,5),(20,29,15,2),(20,29,18,11),(20,30,19,4),(20,31,6,1),(20,31,13,9),(20,31,21,7),(20,32,5,7),(20,32,21,9),(20,33,0,11),(20,33,13,12),(20,34,9,1),(20,34,10,10),(20,34,14,8),(20,35,7,9),(20,35,8,9),(20,35,9,11),(20,35,10,8),(20,35,12,0),(20,36,0,5),(20,36,7,3),(20,36,11,9),(20,37,2,9),(20,37,6,13),(21,0,11,12),(21,0,12,10),(21,0,14,0),(21,0,23,6),(21,0,24,11),(21,0,25,0),(21,0,28,6),(21,0,30,10),(21,1,1,10),(21,1,2,8),(21,1,3,7),(21,1,6,8),(21,1,10,5),(21,1,12,9),(21,1,24,10),(21,1,31,7),(21,2,1,12),(21,2,6,12),(21,2,9,5),(21,2,12,4),(21,2,21,0),(21,2,22,4),(21,2,24,6),(21,3,2,5),(21,3,12,6),(21,3,21,13),(21,3,22,11),(21,3,29,12),(21,4,4,3),(21,4,5,9),(21,4,10,1),(21,4,11,4),(21,4,16,10),(21,4,21,1),(21,5,12,1),(21,5,16,9),(21,5,20,9),(21,5,28,13),(21,5,31,4),(21,6,11,3),(21,6,13,3),(21,6,14,2),(21,6,30,3),(21,7,5,12),(21,8,9,13),(21,9,5,7),(21,9,7,7),(21,9,11,2),(21,9,15,7),(21,9,16,10),(21,10,8,9),(21,10,15,7),(21,12,0,13),(21,12,9,1),(21,12,18,6),(21,12,31,4),(21,13,7,13),(21,13,13,10),(21,13,18,8),(21,13,19,11),(21,14,0,6),(21,14,1,3),(21,14,7,12),(21,14,17,12),(21,14,20,3),(21,15,2,12),(21,15,4,2),(21,15,9,10),(21,15,11,8),(21,15,17,0),(21,15,22,7),(21,15,29,8),(21,15,30,13),(21,16,6,3),(21,16,8,10),(21,16,24,7),(21,16,25,6),(21,16,26,11),(21,17,0,8),(21,17,3,10),(21,17,15,4),(21,17,17,1),(21,18,2,6),(21,18,3,13),(21,18,13,13),(21,18,15,11),(21,18,18,8),(21,18,22,2),(21,18,25,5),(21,19,13,13),(21,19,15,13),(21,19,16,6),(21,19,19,0),(21,19,20,1),(21,19,24,13),(21,20,6,6),(21,20,12,4),(21,20,17,5),(21,20,19,6),(21,20,31,10),(21,21,14,12),(21,22,16,4),(21,22,20,13),(21,22,21,11),(21,22,22,13),(21,23,14,12),(21,23,23,2),(21,23,25,6),(21,24,17,10),(21,24,18,4),(21,25,25,9),(21,27,0,9),(21,27,1,1),(21,27,9,9),(21,27,28,6),(21,27,29,10),(21,27,30,11),(21,28,30,2),(21,28,31,3),(21,29,0,12),(21,29,1,9),(21,29,25,11),(21,29,30,11),(21,30,25,5),(21,31,1,1),(21,31,18,12),(21,31,29,8),(21,32,0,7),(21,32,28,3),(21,33,2,4),(21,33,8,11),(21,33,18,11),(21,33,19,8),(21,33,22,12),(26,0,6,10),(26,0,9,2),(26,0,10,0),(26,0,20,11),(26,0,22,1),(26,0,25,7),(26,0,27,11),(26,1,6,3),(26,1,10,13),(26,1,19,3),(26,1,21,10),(26,1,25,13),(26,1,29,9),(26,2,2,3),(26,2,3,4),(26,2,4,5),(26,2,9,0),(26,2,11,12),(26,2,26,6),(26,3,5,3),(26,3,7,9),(26,3,12,11),(26,3,17,3),(26,3,20,13),(26,3,21,5),(26,3,26,5),(26,4,0,4),(26,4,9,12),(26,4,12,1),(26,4,28,6),(26,5,9,3),(26,5,23,0),(26,6,0,1),(26,6,5,1),(26,6,6,7),(26,6,12,2),(26,6,14,3),(26,6,29,10),(26,7,0,5),(26,7,4,3),(26,7,5,11),(26,7,10,3),(26,8,8,7),(26,8,29,10),(26,9,1,8),(26,9,5,10),(26,9,10,3),(26,9,17,5),(26,10,0,12),(26,10,1,10),(26,10,3,5),(26,10,5,7),(26,10,8,12),(26,11,2,12),(26,11,4,9),(26,11,5,3),(26,11,21,8),(26,12,2,8),(26,12,4,3),(26,12,22,6),(26,12,23,0),(26,12,28,5),(26,13,4,0),(26,13,7,11),(26,13,11,0),(26,13,13,6),(26,13,27,12),(26,14,0,1),(26,14,7,2),(26,14,11,12),(26,14,16,9),(26,14,19,8),(26,14,21,2),(26,14,25,3),(26,14,26,7),(26,15,6,12),(26,15,11,13),(26,15,16,0),(26,15,20,3),(26,15,22,9),(26,16,1,2),(26,16,7,11),(26,16,20,5),(26,16,22,3),(26,16,25,7),(26,16,26,6),(26,17,4,0),(26,17,13,6),(26,17,17,7),(26,17,19,1),(26,17,20,13),(26,17,22,4),(26,17,26,11),(26,17,28,9),(26,18,0,4),(26,18,5,0),(26,18,9,11),(26,18,20,13),(26,18,23,11),(26,18,26,13),(26,19,7,6),(26,19,9,1),(26,20,4,2),(26,20,9,12),(26,20,10,9),(26,20,13,12),(26,20,16,5),(26,21,8,8),(26,21,10,11),(26,21,15,7),(26,21,17,7),(26,23,9,13),(26,23,26,2),(26,23,27,11),(26,24,20,4),(26,24,23,13),(26,24,29,2),(26,25,22,13),(26,25,23,3),(26,25,24,5),(26,25,25,0),(26,26,25,3),(26,26,28,11),(26,27,21,4),(26,27,26,6),(26,28,20,13),(26,28,21,12),(26,28,22,12),(26,28,23,1),(26,28,24,6),(26,28,28,9),(26,28,29,4),(26,29,9,0),(26,29,20,0),(26,29,23,3),(26,29,27,0),(26,29,28,12),(26,30,8,11),(26,30,11,8),(26,30,17,0),(26,30,20,8),(26,31,2,2),(26,31,5,2),(26,31,7,2),(26,31,8,1),(26,31,10,7),(26,31,12,5),(26,31,16,0),(26,31,20,11),(26,31,21,3),(26,32,1,3),(26,32,3,8),(26,32,4,10),(26,32,6,6),(26,32,8,7),(26,32,10,6),(26,32,11,1),(26,32,12,3),(26,32,15,8),(26,32,18,6),(26,32,29,6),(26,33,2,2),(26,33,3,4),(26,33,8,10),(26,33,9,3),(26,33,11,11),(26,33,19,5),(26,33,20,6),(26,34,7,3),(26,34,8,13),(26,34,9,3),(26,34,11,4),(26,34,17,0),(26,34,23,11),(26,34,29,5),(26,35,3,9),(26,35,7,12),(26,35,8,0),(26,35,12,12),(26,36,1,3),(26,36,3,4),(26,36,4,7),(26,36,16,0),(26,36,17,7),(26,36,23,5),(26,36,29,4),(26,37,2,7),(26,37,8,10),(26,37,15,10),(26,37,16,11),(26,37,18,6),(26,38,14,6),(26,38,17,3),(26,38,25,11),(26,38,29,7),(26,39,4,0),(26,39,10,12),(26,40,11,2),(26,40,18,0),(26,41,7,7),(26,41,10,1),(26,41,14,10),(26,41,15,7),(26,41,16,4),(26,42,9,2),(26,42,11,12),(26,42,17,0),(26,42,26,3),(26,43,5,12),(26,43,7,8),(26,43,8,7),(26,43,10,5),(26,43,12,4),(26,43,14,9),(26,43,16,0),(26,43,17,2),(26,43,29,6),(26,44,5,4),(26,44,9,12),(26,44,14,5),(26,45,9,7),(26,45,10,3),(26,45,12,9),(26,45,19,5),(26,45,21,7),(26,45,22,3),(26,45,28,11),(26,46,15,8),(26,46,21,1),(26,48,0,4),(26,48,4,6),(26,48,7,1),(26,48,8,6),(26,48,9,13),(26,48,18,1),(26,49,9,5),(26,49,12,1),(26,49,15,9),(26,49,16,12),(26,49,19,12),(26,49,22,10),(26,50,9,8),(26,50,11,4),(26,50,12,4),(26,51,3,7),(26,51,11,9),(26,52,4,1),(26,52,9,8),(26,52,11,3),(26,52,25,6),(26,52,27,0),(28,0,7,12),(28,0,15,8),(28,1,0,13),(28,1,29,5),(28,2,0,7),(28,2,9,2),(28,2,10,9),(28,2,11,0),(28,2,13,10),(28,2,15,13),(28,2,17,13),(28,3,11,12),(28,4,1,6),(28,4,2,2),(28,4,5,8),(28,4,8,3),(28,4,13,12),(28,4,22,12),(28,4,29,10),(28,5,19,11),(28,5,20,0),(28,6,0,1),(28,6,27,8),(28,6,29,9),(28,7,1,4),(28,7,7,1),(28,7,8,10),(28,7,13,12),(28,7,28,1),(28,8,1,3),(28,8,2,12),(28,8,22,4),(28,8,26,1),(28,9,0,4),(28,9,2,9),(28,9,26,10),(28,10,8,11),(28,10,19,11),(28,11,27,10),(28,12,28,10),(28,12,29,13),(28,13,6,2),(28,13,20,0),(28,14,19,9),(28,14,22,1),(28,14,23,10),(28,14,28,4),(28,14,29,9),(28,15,3,11),(28,15,6,6),(28,15,7,12),(28,15,19,12),(28,15,20,11),(28,15,21,3),(28,15,29,8),(28,16,1,2),(28,16,2,12),(28,16,20,10),(28,16,23,8),(28,17,0,7),(28,17,3,2),(28,17,5,1),(28,17,10,8),(28,17,18,9),(28,17,19,10),(28,17,22,9),(28,17,28,1),(28,18,2,7),(28,18,4,11),(28,18,5,6),(28,18,7,5),(28,18,21,8),(28,18,26,7),(28,18,29,3),(28,19,1,7),(28,19,2,9),(28,19,4,2),(28,19,19,2),(28,19,22,9),(28,19,25,12),(28,19,26,12),(28,20,1,4),(28,20,2,6),(28,20,3,4),(28,20,4,4),(28,20,5,11),(28,20,7,4),(28,20,18,7),(28,20,26,10),(28,20,27,6),(28,20,28,13),(28,21,8,6),(28,21,21,1),(28,21,22,6),(28,21,26,10),(28,21,28,5),(28,22,0,13),(28,22,2,7),(28,23,1,7),(28,23,2,4),(28,23,6,13),(28,23,16,12),(28,23,19,0),(28,23,26,6),(28,23,29,13),(28,24,0,4),(28,24,6,3),(28,24,22,4),(28,24,23,0),(28,24,26,0),(28,24,28,3),(28,25,0,1),(28,25,7,12),(28,25,9,12),(28,25,10,2),(28,25,15,9),(28,25,16,6),(28,25,17,5),(28,25,18,5),(28,25,19,4),(28,25,26,3),(28,26,2,9),(28,26,4,2),(28,26,12,11),(28,26,13,0),(28,26,14,6),(28,26,15,2),(28,26,16,0),(28,26,19,0),(28,26,21,0),(28,27,1,13),(28,27,3,11),(28,27,5,6),(28,27,11,6),(28,27,16,7),(28,27,24,9),(28,27,27,2),(28,27,28,3),(28,28,3,0),(28,28,5,10),(28,28,8,13),(28,28,27,11),(28,29,13,9),(28,29,16,3),(28,29,27,3),(28,30,15,3),(28,30,28,8),(28,31,5,10),(28,31,15,3),(28,31,16,10),(28,31,29,13),(28,32,6,5),(28,32,11,9),(28,32,14,8),(28,32,18,12),(28,33,19,12),(28,33,20,8),(28,34,14,10),(28,34,15,13),(28,36,13,6),(28,36,14,5),(28,36,18,7),(28,36,20,12),(28,37,5,11),(28,37,7,11),(28,37,23,10),(28,38,22,9),(28,38,26,7),(28,39,19,0),(28,39,20,5),(28,39,22,8),(28,39,26,12),(28,41,4,10),(28,42,16,0),(28,42,18,2),(28,42,20,1),(28,43,8,5),(28,43,13,0),(28,43,23,9),(28,43,25,1),(28,44,7,3),(28,45,8,12),(28,45,24,9),(28,47,7,11),(28,47,8,13),(28,47,15,11),(28,47,23,9),(28,48,7,11),(28,48,11,12),(28,49,7,12),(28,49,9,6),(28,49,16,2),(28,49,17,11),(28,49,18,3),(28,49,20,13),(30,0,8,12),(30,2,6,2),(30,3,1,9),(30,3,14,5),(30,4,1,0),(30,6,0,12),(30,7,1,8),(30,7,3,5),(30,7,4,12),(30,7,13,3),(30,8,2,8),(30,8,3,9),(30,8,11,11),(30,9,2,6),(30,9,3,6),(30,9,5,6),(30,10,0,6),(30,10,2,6),(30,10,10,13),(30,10,11,0),(30,10,13,6),(30,11,2,3),(30,11,6,1),(30,11,10,7),(30,11,14,12),(30,11,21,1),(30,12,0,11),(30,12,1,1),(30,12,4,4),(30,12,8,3),(30,12,9,10),(30,12,15,5),(30,13,0,5),(30,13,1,12),(30,13,7,8),(30,13,16,4),(30,14,0,7),(30,14,6,4),(30,15,3,3),(30,15,5,9),(30,16,3,6),(30,16,6,1),(30,16,18,4),(30,17,0,2),(30,17,7,0),(30,17,8,6),(30,17,17,9),(30,17,19,7),(30,17,20,7),(30,18,4,8),(30,18,5,1),(30,18,9,13),(30,18,17,1),(30,18,18,8),(30,19,3,0),(30,20,0,8),(30,20,3,10),(30,20,16,1),(30,20,21,5),(30,21,2,9),(30,21,3,7),(30,21,5,8),(30,21,7,13),(30,21,15,6),(30,22,14,12),(30,23,2,11),(30,23,11,1),(30,23,14,12),(30,23,21,3),(30,24,8,6),(30,24,11,1),(30,24,14,0),(30,24,15,1),(30,24,18,7),(30,24,19,12),(30,25,14,3),(30,25,18,2),(30,25,19,13),(30,25,20,13),(30,26,19,1),(30,26,21,9),(30,27,13,0),(30,27,17,2),(30,28,0,10),(30,29,8,5),(30,29,12,0),(30,29,14,4),(30,30,6,3),(30,30,7,8),(30,30,11,3),(30,30,15,4),(30,31,11,4),(30,31,13,8),(30,31,15,4),(30,31,17,10),(30,31,21,7),(30,32,4,5),(30,32,5,5),(30,32,8,9),(30,32,14,8),(30,32,15,8),(30,33,5,2),(30,35,21,9),(30,36,0,10),(30,36,1,0),(30,36,3,6),(30,36,4,8),(30,36,6,2),(30,36,19,2),(30,36,20,11),(30,37,1,0),(30,37,2,4),(30,37,3,7),(30,37,5,2),(30,37,15,7),(30,38,17,2),(30,38,19,10),(30,39,0,12),(30,39,3,5),(30,39,17,12),(30,39,21,13),(30,40,1,6),(30,40,6,2),(30,40,16,12),(30,40,21,4),(30,41,0,1),(30,41,20,10),(30,41,21,0),(30,42,0,10),(30,43,15,7),(30,43,16,10),(30,44,11,7),(30,45,0,3),(30,45,12,0),(30,45,16,6),(30,45,21,7),(30,46,13,10),(30,46,21,11),(30,47,1,12),(30,47,8,12),(30,47,10,0),(30,47,12,1),(30,47,14,7),(30,48,4,10),(30,48,6,9),(30,48,8,1),(30,48,11,0),(30,48,14,3),(30,49,7,8),(30,49,10,7),(30,49,13,1),(30,49,20,10),(30,50,6,9),(30,50,9,3),(30,50,12,4),(30,50,13,12),(30,50,16,6),(30,50,19,9),(33,0,13,5),(33,0,27,10),(33,2,5,12),(33,2,28,7),(33,3,3,13),(33,3,10,6),(33,3,26,1),(33,3,29,1),(33,4,5,5),(33,5,19,0),(33,5,22,6),(33,5,24,5),(33,5,25,12),(33,5,27,4),(33,5,28,2),(33,5,29,10),(33,6,3,3),(33,6,4,4),(33,6,8,2),(33,6,16,2),(33,6,17,7),(33,7,8,11),(33,7,21,11),(33,7,24,5),(33,8,7,13),(33,8,25,0),(33,9,9,13),(33,9,11,9),(33,9,17,0),(33,9,18,4),(33,9,23,1),(33,10,0,13),(33,10,16,5),(33,10,17,6),(33,10,21,0),(33,12,7,0),(33,12,10,9),(33,12,11,12),(33,12,13,7),(33,12,20,3),(33,12,21,7),(33,13,0,4),(33,13,1,1),(33,13,3,5),(33,13,8,13),(33,13,20,5),(33,13,21,10),(33,14,0,8),(33,14,3,11),(33,14,8,10),(33,14,21,11),(33,15,3,12),(33,15,4,0),(33,15,13,6),(33,16,3,0),(33,16,8,12),(33,16,9,0),(33,17,4,6),(33,18,12,12),(33,18,13,1),(33,19,2,2),(33,19,3,1),(33,19,14,4),(33,19,22,5),(33,19,23,1),(33,20,2,0),(33,20,4,2),(33,21,7,1),(33,21,14,9),(33,21,21,7),(33,21,24,10),(33,22,7,2),(33,23,8,8),(33,23,21,7),(33,23,22,6),(33,23,25,9),(33,24,7,6),(33,24,16,9),(33,24,17,0),(33,25,4,9),(33,25,8,9),(33,25,9,8),(33,25,12,11),(33,26,5,2),(33,26,12,5),(33,26,29,6),(33,29,1,12),(33,29,23,13),(36,0,6,5),(36,0,10,1),(36,0,17,2),(36,1,2,1),(36,2,9,6),(36,2,11,8),(36,2,14,7),(36,2,16,11),(36,2,31,12),(36,3,31,6),(36,4,0,5),(36,4,2,13),(36,4,14,9),(36,4,16,0),(36,5,1,4),(36,5,14,4),(36,5,15,9),(36,5,26,6),(36,6,14,11),(36,6,15,6),(36,6,25,11),(36,7,2,10),(36,7,3,2),(36,7,9,10),(36,8,3,10),(36,8,22,7),(36,9,9,3),(36,9,13,12),(36,9,24,1),(36,10,1,0),(36,10,8,12),(36,10,16,6),(36,10,20,9),(36,10,22,9),(36,10,23,4),(36,11,2,2),(36,11,3,4),(36,11,4,6),(36,11,9,7),(36,11,10,0),(36,11,18,0),(36,11,19,13),(36,11,24,6),(36,11,27,5),(36,12,4,1),(36,12,8,0),(36,12,11,0),(36,12,19,7),(36,12,25,0),(36,12,29,6),(36,13,0,6),(36,13,30,8),(36,14,0,3),(36,14,9,2),(36,14,10,0),(36,14,11,13),(36,14,18,0),(36,14,21,1),(36,14,31,8),(36,15,2,9),(36,15,19,2),(36,15,21,13),(36,15,29,5),(36,16,2,7),(36,16,21,8),(36,17,12,8),(36,17,23,5),(36,17,29,7),(36,18,14,0),(36,18,15,2),(36,18,21,1),(36,18,25,0),(36,18,27,3),(36,18,30,4),(36,19,6,0),(36,19,7,5),(36,19,9,2),(36,19,13,7),(36,19,30,7),(36,20,13,1),(36,20,17,3),(36,20,26,5),(36,21,1,10),(36,21,26,11),(36,22,4,12),(36,22,29,0),(36,23,30,3),(36,24,17,3),(36,24,18,13),(36,24,20,2),(36,24,27,13),(36,24,29,1),(36,24,30,1),(36,25,2,0),(36,25,20,0),(36,25,27,10),(36,25,28,11),(36,25,31,8),(36,26,16,2),(36,26,20,1),(36,27,2,2),(36,27,10,3),(36,27,27,13),(36,27,29,2),(36,28,14,3),(36,28,16,8),(36,28,28,11),(36,29,0,13),(36,29,7,3),(36,29,9,8),(36,29,18,9),(36,30,11,10),(36,30,18,0),(36,31,4,9),(36,31,5,11),(36,31,7,5),(36,31,15,4),(36,32,5,10),(36,32,10,7),(36,33,7,5),(36,33,8,6),(36,33,9,8),(36,33,16,4),(36,33,18,3),(36,33,23,9),(36,33,27,4),(36,33,28,10),(36,34,18,5),(36,34,25,11),(36,34,31,3),(36,35,17,3),(36,35,21,10),(36,35,27,5),(36,35,31,3),(36,36,15,4),(36,36,18,6),(36,37,2,1),(36,37,13,6),(36,37,18,11),(36,37,22,13),(36,37,23,4),(36,38,21,5),(36,39,3,6),(36,39,5,10),(36,39,8,5),(36,39,15,10),(36,40,15,8),(36,41,2,3),(36,41,3,10),(36,41,11,4),(36,41,13,1),(36,41,16,7),(36,41,24,10),(36,42,1,6),(36,42,3,1),(36,42,14,2),(36,42,24,5),(36,43,0,8),(36,43,1,3),(36,43,6,12),(36,43,23,7),(36,43,24,4),(36,43,26,5),(36,43,29,10),(36,44,3,7),(36,44,16,8),(36,44,17,7),(36,44,31,7),(36,45,4,12),(36,45,5,7),(36,45,22,4),(36,46,22,2),(36,47,1,8),(36,47,15,13),(36,47,17,13),(36,48,6,12),(36,48,7,0),(36,48,17,13),(36,48,20,1),(36,48,21,0),(36,49,0,7),(36,49,3,8),(36,49,18,7),(36,50,0,2),(36,50,4,0),(36,50,5,10),(36,50,7,12),(36,50,10,6);
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
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `fow_galaxy_entries`
--

LOCK TABLES `fow_galaxy_entries` WRITE;
/*!40000 ALTER TABLE `fow_galaxy_entries` DISABLE KEYS */;
INSERT INTO `fow_galaxy_entries` VALUES (1,1,1,NULL,-3,-3,3,3,1);
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
INSERT INTO `fow_ss_entries` VALUES (1,4,1,2,1,0,0,0,NULL,NULL,NULL,NULL,NULL),(2,3,1,1,0,0,0,0,NULL,NULL,NULL,NULL,NULL),(3,1,1,1,0,0,0,0,NULL,NULL,NULL,NULL,NULL),(4,2,1,1,0,0,0,0,NULL,NULL,NULL,NULL,NULL);
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
INSERT INTO `galaxies` VALUES (1,'2010-10-11 10:29:08','dev');
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
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `notifications`
--

LOCK TABLES `notifications` WRITE;
/*!40000 ALTER TABLE `notifications` DISABLE KEYS */;
INSERT INTO `notifications` VALUES (1,1,'2010-10-11 10:29:13','2010-10-25 10:29:13',3,'--- \n:id: 1\n',0,0),(2,1,'2010-10-11 10:29:13','2010-10-25 10:29:13',3,'--- \n:id: 2\n',0,0);
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
  `metal_rate` int(10) unsigned DEFAULT NULL,
  `energy_rate` int(10) unsigned DEFAULT NULL,
  `zetium_rate` int(10) unsigned DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uniqueness` (`solar_system_id`,`position`),
  KEY `index_planets_on_galaxy_id_and_solar_system_id` (`solar_system_id`),
  KEY `index_planets_on_player_id_and_galaxy_id` (`player_id`),
  KEY `group_by_for_fowssentry_status_updates` (`player_id`,`solar_system_id`),
  CONSTRAINT `planets_ibfk_2` FOREIGN KEY (`player_id`) REFERENCES `players` (`id`) ON DELETE SET NULL,
  CONSTRAINT `planets_ibfk_1` FOREIGN KEY (`solar_system_id`) REFERENCES `solar_systems` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=37 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `planets`
--

LOCK TABLES `planets` WRITE;
/*!40000 ALTER TABLE `planets` DISABLE KEYS */;
INSERT INTO `planets` VALUES (1,1,NULL,NULL,0,180,3,'Resource',NULL,'G1-S1-P1',57,172,248,355),(2,1,25,56,1,315,0,'Regular',NULL,'G1-S1-P2',64,NULL,NULL,NULL),(3,1,40,31,2,270,1,'Regular',NULL,'G1-S1-P3',56,NULL,NULL,NULL),(4,1,NULL,NULL,3,134,1,'Resource',NULL,'G1-S1-P4',51,232,238,262),(5,1,NULL,NULL,4,342,4,'Mining',NULL,'G1-S1-P5',31,125,361,204),(6,1,NULL,NULL,5,225,0,'Npc',NULL,'G1-S1-P6',28,NULL,NULL,NULL),(7,1,33,41,6,126,8,'Regular',NULL,'G1-S1-P7',59,NULL,NULL,NULL),(8,1,NULL,NULL,7,347,1,'Jumpgate',NULL,'G1-S1-P8',55,NULL,NULL,NULL),(9,1,NULL,NULL,8,230,2,'Resource',NULL,'G1-S1-P9',41,296,399,140),(10,1,NULL,NULL,11,298,5,'Mining',NULL,'G1-S1-P10',40,225,165,216),(11,1,NULL,NULL,12,336,3,'Resource',NULL,'G1-S1-P11',42,208,326,337),(12,1,NULL,NULL,13,108,0,'Mining',NULL,'G1-S1-P12',49,230,268,212),(13,1,NULL,NULL,14,84,1,'Jumpgate',NULL,'G1-S1-P13',33,NULL,NULL,NULL),(14,2,NULL,NULL,1,225,1,'Jumpgate',NULL,'G1-S2-P14',39,NULL,NULL,NULL),(15,2,NULL,NULL,2,240,6,'Mining',NULL,'G1-S2-P15',30,279,212,226),(16,2,NULL,NULL,3,44,1,'Mining',NULL,'G1-S2-P16',60,233,126,190),(17,2,NULL,NULL,4,162,1,'Jumpgate',NULL,'G1-S2-P17',36,NULL,NULL,NULL),(18,2,NULL,NULL,5,75,1,'Mining',NULL,'G1-S2-P18',28,277,242,118),(19,2,NULL,NULL,6,216,2,'Jumpgate',NULL,'G1-S2-P19',31,NULL,NULL,NULL),(20,2,38,22,7,167,0,'Regular',NULL,'G1-S2-P20',48,NULL,NULL,NULL),(21,2,34,32,8,40,2,'Regular',NULL,'G1-S2-P21',52,NULL,NULL,NULL),(22,2,NULL,NULL,9,18,0,'Npc',NULL,'G1-S2-P22',56,NULL,NULL,NULL),(23,2,NULL,NULL,10,326,1,'Resource',NULL,'G1-S2-P23',37,184,180,295),(24,3,NULL,NULL,0,180,2,'Jumpgate',NULL,'G1-S3-P24',52,NULL,NULL,NULL),(25,3,NULL,NULL,1,135,1,'Jumpgate',NULL,'G1-S3-P25',46,NULL,NULL,NULL),(26,3,53,30,2,90,3,'Regular',NULL,'G1-S3-P26',66,NULL,NULL,NULL),(27,3,NULL,NULL,4,324,2,'Mining',NULL,'G1-S3-P27',48,192,375,309),(28,3,50,30,5,255,5,'Regular',NULL,'G1-S3-P28',64,NULL,NULL,NULL),(29,3,NULL,NULL,6,252,4,'Mining',NULL,'G1-S3-P29',46,231,346,385),(30,4,51,22,0,90,3,'Regular',NULL,'G1-S4-P30',58,NULL,NULL,NULL),(31,4,NULL,NULL,1,90,2,'Mining',NULL,'G1-S4-P31',46,279,125,156),(32,4,NULL,NULL,2,210,0,'Jumpgate',NULL,'G1-S4-P32',36,NULL,NULL,NULL),(33,4,30,30,3,292,0,'Homeworld',1,'G1-S4-P33',50,NULL,NULL,NULL),(34,4,NULL,NULL,4,0,0,'Npc',NULL,'G1-S4-P34',56,NULL,NULL,NULL),(35,4,NULL,NULL,5,105,2,'Mining',NULL,'G1-S4-P35',34,250,387,393),(36,4,51,32,6,12,3,'Regular',NULL,'G1-S4-P36',66,NULL,NULL,NULL);
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
) ENGINE=InnoDB AUTO_INCREMENT=37 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `resources_entries`
--

LOCK TABLES `resources_entries` WRITE;
/*!40000 ALTER TABLE `resources_entries` DISABLE KEYS */;
INSERT INTO `resources_entries` VALUES (1,0,0,0,0,0,0,0,0,0,NULL,0),(2,0,0,0,0,0,0,0,0,0,NULL,0),(3,0,0,0,0,0,0,0,0,0,NULL,0),(4,0,0,0,0,0,0,0,0,0,NULL,0),(5,0,0,0,0,0,0,0,0,0,NULL,0),(6,0,0,0,0,0,0,0,0,0,NULL,0),(7,0,0,0,0,0,0,0,0,0,NULL,0),(8,0,0,0,0,0,0,0,0,0,NULL,0),(9,0,0,0,0,0,0,0,0,0,NULL,0),(10,0,0,0,0,0,0,0,0,0,NULL,0),(11,0,0,0,0,0,0,0,0,0,NULL,0),(12,0,0,0,0,0,0,0,0,0,NULL,0),(13,0,0,0,0,0,0,0,0,0,NULL,0),(14,0,0,0,0,0,0,0,0,0,NULL,0),(15,0,0,0,0,0,0,0,0,0,NULL,0),(16,0,0,0,0,0,0,0,0,0,NULL,0),(17,0,0,0,0,0,0,0,0,0,NULL,0),(18,0,0,0,0,0,0,0,0,0,NULL,0),(19,0,0,0,0,0,0,0,0,0,NULL,0),(20,0,0,0,0,0,0,0,0,0,NULL,0),(21,0,0,0,0,0,0,0,0,0,NULL,0),(22,0,0,0,0,0,0,0,0,0,NULL,0),(23,0,0,0,0,0,0,0,0,0,NULL,0),(24,0,0,0,0,0,0,0,0,0,NULL,0),(25,0,0,0,0,0,0,0,0,0,NULL,0),(26,0,0,0,0,0,0,0,0,0,NULL,0),(27,0,0,0,0,0,0,0,0,0,NULL,0),(28,0,0,0,0,0,0,0,0,0,NULL,0),(29,0,0,0,0,0,0,0,0,0,NULL,0),(30,0,0,0,0,0,0,0,0,0,NULL,0),(31,0,0,0,0,0,0,0,0,0,NULL,0),(32,0,0,0,0,0,0,0,0,0,NULL,0),(33,864,3024,1728,6048,0,604.8,50,100,0,'2010-10-11 10:29:12',0),(34,0,0,0,0,0,0,0,0,0,NULL,0),(35,0,0,0,0,0,0,0,0,0,NULL,0),(36,0,0,0,0,0,0,0,0,0,NULL,0);
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
INSERT INTO `schema_migrations` VALUES ('20090601175224'),('20090601184051'),('20090601184055'),('20090601184059'),('20090701164131'),('20090713165021'),('20090808144214'),('20090809160211'),('20090810173759'),('20090826140238'),('20090826141836'),('20090829202538'),('20090829210029'),('20090829224505'),('20090830143959'),('20090830145319'),('20090901153809'),('20090904190655'),('20090905175341'),('20090905192056'),('20090906135044'),('20090909222719'),('20090911180950'),('20090912165229'),('20090919155819'),('20091024222359'),('20091103164416'),('20091103180558'),('20091103181146'),('20091109191211'),('20091225193714'),('20100114152902'),('20100121142414'),('20100127115341'),('20100127120219'),('20100127120515'),('20100127121337'),('20100129150736'),('20100203202757'),('20100203204803'),('20100204172507'),('20100204173714'),('20100208163239'),('20100210114531'),('20100212134334'),('20100218181507'),('20100219114448'),('20100220144106'),('20100222144003'),('20100223153023'),('20100224153728'),('20100224163525'),('20100225124928'),('20100225153721'),('20100225155505'),('20100225155739'),('20100226122144'),('20100226122651'),('20100301153626'),('20100302131225'),('20100303131706'),('20100308163148'),('20100308164422'),('20100310172315'),('20100310181338'),('20100311123523'),('20100315112858'),('20100319141401'),('20100322184529'),('20100324134243'),('20100324141652'),('20100331125702'),('20100415130556'),('20100415130600'),('20100415130605'),('20100415134627'),('20100419141518'),('20100419142018'),('20100419164230'),('20100426141509'),('20100428130912'),('20100429171200'),('20100430174140'),('20100610151652'),('20100610180750'),('20100614142225'),('20100614160819'),('20100614162423'),('20100616132525'),('20100616135507'),('20100622124252'),('20100706105523'),('20100710121447'),('20100710191351'),('20100716155807'),('20100719131622'),('20100721155359'),('20100722124307'),('20100812164444'),('20100812164449'),('20100812164518'),('20100812164524'),('20100817165213'),('20100819175736'),('20100820185846'),('20100906095758'),('20100915145823'),('20100929111549'),('20101001155323'),('20101005180058'),('99999999999000'),('99999999999900');
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
INSERT INTO `solar_systems` VALUES (1,'Resource',1,2,1),(2,'Expansion',1,3,-3),(3,'Expansion',1,-3,2),(4,'Homeworld',1,0,0);
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
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `kind` tinyint(2) unsigned NOT NULL DEFAULT '0',
  `planet_id` int(11) NOT NULL,
  `x` tinyint(2) unsigned NOT NULL DEFAULT '0',
  `y` tinyint(2) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uniqueness` (`planet_id`,`x`,`y`),
  CONSTRAINT `tiles_ibfk_1` FOREIGN KEY (`planet_id`) REFERENCES `planets` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=4262 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tiles`
--

LOCK TABLES `tiles` WRITE;
/*!40000 ALTER TABLE `tiles` DISABLE KEYS */;
INSERT INTO `tiles` VALUES (1,6,2,13,0),(2,6,2,14,0),(3,6,2,15,0),(4,6,2,16,0),(5,6,2,17,0),(6,6,2,13,1),(7,5,2,14,1),(8,6,2,15,1),(9,6,2,16,1),(10,6,2,17,1),(11,6,2,18,1),(12,0,2,4,2),(13,0,2,8,2),(14,5,2,10,2),(15,5,2,14,2),(16,6,2,15,2),(17,6,2,16,2),(18,6,2,17,2),(19,6,2,18,2),(20,6,2,19,2),(21,6,2,20,2),(22,5,2,10,3),(23,5,2,14,3),(24,6,2,15,3),(25,6,2,16,3),(26,6,2,17,3),(27,6,2,18,3),(28,6,2,23,3),(29,5,2,10,4),(30,5,2,13,4),(31,5,2,14,4),(32,6,2,15,4),(33,6,2,16,4),(34,6,2,17,4),(35,6,2,23,4),(36,6,2,24,4),(37,5,2,9,5),(38,5,2,10,5),(39,5,2,11,5),(40,5,2,12,5),(41,5,2,13,5),(42,5,2,14,5),(43,5,2,15,5),(44,5,2,16,5),(45,5,2,17,5),(46,13,2,18,5),(47,6,2,24,5),(48,1,2,5,6),(49,5,2,9,6),(50,5,2,10,6),(51,5,2,11,6),(52,5,2,12,6),(53,5,2,13,6),(54,5,2,15,6),(55,6,2,24,6),(56,5,2,10,7),(57,0,2,16,7),(58,5,2,18,7),(59,5,2,19,7),(60,5,2,21,7),(61,6,2,22,7),(62,6,2,23,7),(63,6,2,24,7),(64,3,2,10,8),(65,3,2,13,8),(66,5,2,15,8),(67,5,2,18,8),(68,5,2,21,8),(69,6,2,22,8),(70,6,2,23,8),(71,6,2,24,8),(72,0,2,6,9),(73,3,2,10,9),(74,3,2,11,9),(75,3,2,12,9),(76,3,2,13,9),(77,3,2,14,9),(78,5,2,15,9),(79,5,2,16,9),(80,5,2,17,9),(81,5,2,18,9),(82,5,2,19,9),(83,5,2,20,9),(84,5,2,21,9),(85,5,2,22,9),(86,6,2,23,9),(87,6,2,24,9),(88,3,2,10,10),(89,3,2,11,10),(90,3,2,12,10),(91,5,2,16,10),(92,5,2,17,10),(93,5,2,18,10),(94,5,2,20,10),(95,6,2,21,10),(96,6,2,22,10),(97,6,2,23,10),(98,6,2,24,10),(99,0,2,3,11),(100,3,2,10,11),(101,3,2,11,11),(102,5,2,14,11),(103,5,2,15,11),(104,5,2,16,11),(105,5,2,17,11),(106,5,2,18,11),(107,5,2,19,11),(108,6,2,21,11),(109,6,2,22,11),(110,6,2,23,11),(111,6,2,24,11),(112,3,2,10,12),(113,3,2,11,12),(114,3,2,12,12),(115,5,2,17,12),(116,5,2,18,12),(117,6,2,21,12),(118,6,2,23,12),(119,3,2,9,13),(120,3,2,10,13),(121,3,2,11,13),(122,3,2,12,13),(123,3,2,10,14),(124,3,2,12,14),(125,3,2,10,15),(126,8,2,4,18),(127,12,2,18,18),(128,4,2,15,19),(129,4,2,16,19),(130,4,2,17,19),(131,0,2,0,20),(132,4,2,14,20),(133,4,2,16,20),(134,4,2,17,20),(135,4,2,12,21),(136,4,2,14,21),(137,4,2,15,21),(138,4,2,16,21),(139,4,2,17,21),(140,4,2,11,22),(141,4,2,12,22),(142,4,2,13,22),(143,4,2,14,22),(144,4,2,15,22),(145,4,2,16,22),(146,4,2,17,22),(147,4,2,13,23),(148,4,2,14,23),(149,4,2,15,23),(150,4,2,16,23),(151,4,2,17,23),(152,4,2,14,24),(153,4,2,15,24),(154,4,2,16,24),(155,3,2,5,25),(156,3,2,6,25),(157,2,2,13,25),(158,11,2,20,25),(159,3,2,5,26),(160,3,2,6,26),(161,3,2,4,27),(162,3,2,5,27),(163,3,2,6,27),(164,3,2,7,27),(165,3,2,4,28),(166,3,2,5,28),(167,3,2,6,28),(168,3,2,7,28),(169,3,2,3,29),(170,3,2,4,29),(171,3,2,5,29),(172,3,2,7,29),(173,1,2,8,29),(174,7,2,16,29),(175,3,2,5,30),(176,3,2,6,30),(177,7,2,16,30),(178,7,2,18,30),(179,7,2,19,30),(180,7,2,16,31),(181,7,2,17,31),(182,7,2,18,31),(183,7,2,19,31),(184,7,2,20,31),(185,14,2,21,31),(186,3,2,10,32),(187,3,2,12,32),(188,3,2,13,32),(189,3,2,14,32),(190,7,2,16,32),(191,7,2,17,32),(192,7,2,18,32),(193,7,2,20,32),(194,5,2,1,33),(195,3,2,9,33),(196,3,2,10,33),(197,3,2,11,33),(198,3,2,12,33),(199,3,2,13,33),(200,3,2,14,33),(201,3,2,15,33),(202,7,2,16,33),(203,7,2,17,33),(204,7,2,18,33),(205,5,2,0,34),(206,5,2,1,34),(207,5,2,2,34),(208,11,2,7,34),(209,3,2,12,34),(210,3,2,13,34),(211,3,2,14,34),(212,3,2,15,34),(213,7,2,16,34),(214,7,2,17,34),(215,7,2,18,34),(216,5,2,0,35),(217,5,2,1,35),(218,5,2,3,35),(219,3,2,13,35),(220,3,2,14,35),(221,7,2,15,35),(222,7,2,16,35),(223,7,2,17,35),(224,3,2,21,35),(225,3,2,22,35),(226,3,2,23,35),(227,5,2,0,36),(228,5,2,1,36),(229,5,2,2,36),(230,5,2,3,36),(231,3,2,11,36),(232,3,2,12,36),(233,3,2,13,36),(234,3,2,14,36),(235,7,2,15,36),(236,7,2,16,36),(237,7,2,17,36),(238,3,2,18,36),(239,3,2,19,36),(240,3,2,20,36),(241,3,2,21,36),(242,3,2,22,36),(243,3,2,23,36),(244,3,2,24,36),(245,5,2,0,37),(246,5,2,1,37),(247,5,2,2,37),(248,5,2,3,37),(249,3,2,11,37),(250,7,2,12,37),(251,7,2,13,37),(252,7,2,14,37),(253,7,2,15,37),(254,7,2,16,37),(255,7,2,17,37),(256,7,2,18,37),(257,3,2,20,37),(258,3,2,21,37),(259,3,2,22,37),(260,3,2,24,37),(261,5,2,0,38),(262,5,2,1,38),(263,5,2,2,38),(264,5,2,3,38),(265,4,2,4,38),(266,4,2,6,38),(267,7,2,11,38),(268,7,2,12,38),(269,7,2,13,38),(270,7,2,14,38),(271,7,2,15,38),(272,7,2,16,38),(273,7,2,17,38),(274,7,2,18,38),(275,7,2,19,38),(276,3,2,21,38),(277,3,2,22,38),(278,5,2,0,39),(279,5,2,1,39),(280,5,2,2,39),(281,4,2,3,39),(282,4,2,4,39),(283,4,2,5,39),(284,4,2,6,39),(285,7,2,11,39),(286,7,2,12,39),(287,7,2,13,39),(288,7,2,14,39),(289,7,2,15,39),(290,7,2,17,39),(291,7,2,18,39),(292,3,2,19,39),(293,3,2,20,39),(294,3,2,21,39),(295,3,2,22,39),(296,5,2,0,40),(297,5,2,1,40),(298,8,2,2,40),(299,4,2,5,40),(300,4,2,6,40),(301,4,2,7,40),(302,7,2,9,40),(303,7,2,10,40),(304,7,2,11,40),(305,7,2,12,40),(306,7,2,13,40),(307,7,2,14,40),(308,7,2,15,40),(309,7,2,16,40),(310,4,2,17,40),(311,7,2,18,40),(312,7,2,19,40),(313,3,2,21,40),(314,3,2,22,40),(315,5,2,0,41),(316,5,2,1,41),(317,4,2,5,41),(318,4,2,6,41),(319,4,2,7,41),(320,7,2,9,41),(321,7,2,10,41),(322,7,2,11,41),(323,7,2,12,41),(324,7,2,13,41),(325,7,2,14,41),(326,7,2,15,41),(327,7,2,16,41),(328,4,2,17,41),(329,4,2,18,41),(330,4,2,19,41),(331,5,2,0,42),(332,5,2,1,42),(333,4,2,5,42),(334,4,2,6,42),(335,7,2,9,42),(336,7,2,10,42),(337,7,2,11,42),(338,7,2,12,42),(339,7,2,14,42),(340,7,2,15,42),(341,7,2,16,42),(342,4,2,17,42),(343,4,2,18,42),(344,4,2,19,42),(345,5,2,0,43),(346,5,2,1,43),(347,5,2,2,43),(348,5,2,3,43),(349,4,2,4,43),(350,4,2,5,43),(351,4,2,6,43),(352,7,2,9,43),(353,10,2,14,43),(354,4,2,18,43),(355,4,2,19,43),(356,4,2,20,43),(357,5,2,0,44),(358,4,2,1,44),(359,4,2,2,44),(360,4,2,3,44),(361,4,2,4,44),(362,4,2,5,44),(363,4,2,18,44),(364,4,2,19,44),(365,4,2,20,44),(366,5,2,0,45),(367,5,2,1,45),(368,5,2,2,45),(369,5,2,3,45),(370,4,2,4,45),(371,4,2,18,45),(372,4,2,19,45),(373,4,2,20,45),(374,4,2,21,45),(375,5,2,0,46),(376,5,2,1,46),(377,5,2,2,46),(378,4,2,3,46),(379,4,2,4,46),(380,4,2,5,46),(381,4,2,18,46),(382,4,2,19,46),(383,4,2,20,46),(384,4,2,21,46),(385,4,2,22,46),(386,4,2,23,46),(387,5,2,0,47),(388,5,2,1,47),(389,5,2,2,47),(390,5,2,3,47),(391,5,2,4,47),(392,5,2,5,47),(393,5,2,6,47),(394,0,2,17,47),(395,4,2,21,47),(396,4,2,22,47),(397,4,2,23,47),(398,5,2,2,48),(399,5,2,5,48),(400,4,2,20,48),(401,4,2,21,48),(402,4,2,22,48),(403,4,2,23,48),(404,4,2,24,48),(405,5,2,5,49),(406,5,2,6,49),(407,0,2,16,49),(408,4,2,19,49),(409,4,2,20,49),(410,4,2,21,49),(411,4,2,22,49),(412,4,2,23,49),(413,4,2,24,49),(414,5,2,5,50),(415,6,2,8,50),(416,4,2,20,50),(417,4,2,21,50),(418,4,2,22,50),(419,4,2,23,50),(420,4,2,24,50),(421,6,2,7,51),(422,6,2,8,51),(423,6,2,9,51),(424,3,2,14,51),(425,3,2,15,51),(426,3,2,16,51),(427,3,2,17,51),(428,4,2,18,51),(429,4,2,19,51),(430,4,2,20,51),(431,4,2,21,51),(432,4,2,22,51),(433,4,2,23,51),(434,6,2,6,52),(435,6,2,8,52),(436,3,2,15,52),(437,3,2,16,52),(438,3,2,17,52),(439,3,2,18,52),(440,4,2,19,52),(441,9,2,20,52),(442,6,2,3,53),(443,6,2,6,53),(444,6,2,7,53),(445,6,2,8,53),(446,6,2,9,53),(447,3,2,16,53),(448,3,2,17,53),(449,3,2,18,53),(450,4,2,19,53),(451,6,2,2,54),(452,6,2,3,54),(453,6,2,4,54),(454,6,2,5,54),(455,6,2,6,54),(456,6,2,7,54),(457,6,2,8,54),(458,6,2,9,54),(459,3,2,15,54),(460,3,2,16,54),(461,3,2,17,54),(462,3,2,18,54),(463,3,2,19,54),(464,6,2,5,55),(465,6,2,7,55),(466,6,2,8,55),(467,6,2,9,55),(468,3,2,15,55),(469,3,2,17,55),(470,3,2,18,55),(471,3,2,19,55),(472,3,2,20,55),(473,3,2,21,55),(474,5,3,1,0),(475,5,3,20,0),(476,5,3,21,0),(477,5,3,22,0),(478,5,3,23,0),(479,5,3,24,0),(480,5,3,25,0),(481,5,3,26,0),(482,5,3,0,1),(483,5,3,1,1),(484,5,3,19,1),(485,5,3,20,1),(486,5,3,21,1),(487,5,3,22,1),(488,5,3,23,1),(489,5,3,24,1),(490,5,3,25,1),(491,5,3,26,1),(492,5,3,0,2),(493,5,3,1,2),(494,5,3,2,2),(495,5,3,3,2),(496,8,3,13,2),(497,5,3,23,2),(498,5,3,24,2),(499,5,3,25,2),(500,5,3,26,2),(501,5,3,27,2),(502,5,3,0,3),(503,5,3,1,3),(504,5,3,2,3),(505,5,3,3,3),(506,5,3,4,3),(507,3,3,5,3),(508,3,3,6,3),(509,2,3,20,3),(510,5,3,23,3),(511,5,3,24,3),(512,5,3,25,3),(513,5,3,26,3),(514,5,3,0,4),(515,3,3,1,4),(516,3,3,2,4),(517,3,3,3,4),(518,3,3,4,4),(519,3,3,5,4),(520,1,3,9,4),(521,10,3,27,4),(522,5,3,0,5),(523,5,3,1,5),(524,5,3,2,5),(525,3,3,3,5),(526,3,3,4,5),(527,3,3,5,5),(528,3,3,6,5),(529,5,3,0,6),(530,5,3,1,6),(531,3,3,2,6),(532,3,3,3,6),(533,3,3,4,6),(534,3,3,5,6),(535,3,3,6,6),(536,3,3,7,6),(537,0,3,10,6),(538,6,3,19,6),(539,6,3,20,6),(540,6,3,21,6),(541,6,3,36,6),(542,6,3,37,6),(543,5,3,0,7),(544,5,3,1,7),(545,3,3,3,7),(546,4,3,4,7),(547,3,3,5,7),(548,3,3,6,7),(549,3,3,7,7),(550,3,3,8,7),(551,6,3,16,7),(552,6,3,17,7),(553,6,3,18,7),(554,6,3,19,7),(555,6,3,20,7),(556,6,3,36,7),(557,6,3,37,7),(558,6,3,38,7),(559,6,3,39,7),(560,5,3,1,8),(561,5,3,2,8),(562,5,3,3,8),(563,4,3,4,8),(564,3,3,5,8),(565,3,3,6,8),(566,3,3,7,8),(567,4,3,8,8),(568,14,3,13,8),(569,6,3,16,8),(570,6,3,17,8),(571,6,3,18,8),(572,6,3,19,8),(573,6,3,22,8),(574,0,3,23,8),(575,6,3,34,8),(576,6,3,35,8),(577,6,3,36,8),(578,6,3,37,8),(579,6,3,38,8),(580,7,3,39,8),(581,5,3,1,9),(582,5,3,2,9),(583,4,3,3,9),(584,4,3,4,9),(585,4,3,5,9),(586,4,3,6,9),(587,4,3,7,9),(588,4,3,8,9),(589,6,3,17,9),(590,6,3,18,9),(591,6,3,19,9),(592,6,3,20,9),(593,6,3,22,9),(594,6,3,28,9),(595,6,3,36,9),(596,7,3,37,9),(597,7,3,38,9),(598,7,3,39,9),(599,4,3,3,10),(600,4,3,4,10),(601,4,3,5,10),(602,4,3,6,10),(603,4,3,7,10),(604,4,3,8,10),(605,4,3,9,10),(606,6,3,17,10),(607,6,3,20,10),(608,6,3,21,10),(609,6,3,22,10),(610,6,3,23,10),(611,6,3,27,10),(612,6,3,28,10),(613,6,3,29,10),(614,6,3,35,10),(615,6,3,36,10),(616,7,3,37,10),(617,7,3,38,10),(618,7,3,39,10),(619,4,3,4,11),(620,4,3,5,11),(621,4,3,6,11),(622,4,3,7,11),(623,4,3,8,11),(624,4,3,9,11),(625,4,3,10,11),(626,6,3,21,11),(627,6,3,22,11),(628,6,3,23,11),(629,6,3,28,11),(630,6,3,29,11),(631,6,3,30,11),(632,6,3,31,11),(633,6,3,32,11),(634,7,3,34,11),(635,7,3,35,11),(636,7,3,36,11),(637,7,3,37,11),(638,7,3,39,11),(639,4,3,4,12),(640,4,3,5,12),(641,4,3,6,12),(642,4,3,7,12),(643,4,3,8,12),(644,4,3,10,12),(645,6,3,20,12),(646,6,3,21,12),(647,6,3,27,12),(648,6,3,28,12),(649,6,3,30,12),(650,7,3,32,12),(651,7,3,33,12),(652,7,3,34,12),(653,7,3,35,12),(654,7,3,36,12),(655,7,3,37,12),(656,7,3,38,12),(657,7,3,39,12),(658,3,3,0,13),(659,3,3,2,13),(660,3,3,3,13),(661,3,3,4,13),(662,3,3,5,13),(663,4,3,6,13),(664,4,3,7,13),(665,4,3,10,13),(666,4,3,11,13),(667,4,3,19,13),(668,4,3,20,13),(669,4,3,22,13),(670,6,3,27,13),(671,6,3,28,13),(672,2,3,29,13),(673,7,3,32,13),(674,7,3,33,13),(675,7,3,34,13),(676,7,3,35,13),(677,7,3,36,13),(678,7,3,37,13),(679,3,3,38,13),(680,3,3,39,13),(681,3,3,0,14),(682,3,3,1,14),(683,3,3,2,14),(684,3,3,3,14),(685,3,3,4,14),(686,3,3,5,14),(687,4,3,6,14),(688,4,3,7,14),(689,4,3,10,14),(690,4,3,17,14),(691,4,3,18,14),(692,4,3,19,14),(693,4,3,22,14),(694,4,3,24,14),(695,4,3,26,14),(696,4,3,28,14),(697,7,3,32,14),(698,7,3,33,14),(699,7,3,35,14),(700,7,3,36,14),(701,7,3,37,14),(702,7,3,38,14),(703,3,3,39,14),(704,3,3,0,15),(705,3,3,1,15),(706,3,3,2,15),(707,3,3,3,15),(708,3,3,4,15),(709,3,3,5,15),(710,3,3,6,15),(711,3,3,7,15),(712,3,3,8,15),(713,3,3,9,15),(714,3,3,10,15),(715,4,3,17,15),(716,4,3,18,15),(717,4,3,19,15),(718,4,3,22,15),(719,4,3,23,15),(720,4,3,24,15),(721,4,3,26,15),(722,4,3,27,15),(723,4,3,28,15),(724,4,3,29,15),(725,12,3,30,15),(726,7,3,37,15),(727,3,3,38,15),(728,3,3,39,15),(729,3,3,0,16),(730,3,3,1,16),(731,0,3,2,16),(732,3,3,4,16),(733,3,3,5,16),(734,3,3,6,16),(735,3,3,9,16),(736,3,3,10,16),(737,4,3,17,16),(738,4,3,18,16),(739,4,3,19,16),(740,4,3,21,16),(741,4,3,22,16),(742,4,3,23,16),(743,4,3,24,16),(744,4,3,25,16),(745,4,3,26,16),(746,4,3,27,16),(747,4,3,28,16),(748,4,3,29,16),(749,3,3,38,16),(750,3,3,0,17),(751,3,3,1,17),(752,3,3,4,17),(753,3,3,5,17),(754,3,3,6,17),(755,3,3,7,17),(756,3,3,8,17),(757,3,3,9,17),(758,4,3,17,17),(759,4,3,18,17),(760,4,3,19,17),(761,4,3,20,17),(762,4,3,23,17),(763,4,3,24,17),(764,4,3,25,17),(765,4,3,26,17),(766,4,3,27,17),(767,4,3,28,17),(768,4,3,29,17),(769,3,3,37,17),(770,3,3,38,17),(771,3,3,39,17),(772,3,3,0,18),(773,11,3,1,18),(774,3,3,5,18),(775,3,3,6,18),(776,3,3,8,18),(777,3,3,9,18),(778,4,3,19,18),(779,4,3,25,18),(780,4,3,26,18),(781,4,3,27,18),(782,4,3,28,18),(783,4,3,29,18),(784,3,3,37,18),(785,3,3,38,18),(786,3,3,39,18),(787,3,3,5,19),(788,3,3,6,19),(789,4,3,19,19),(790,4,3,20,19),(791,5,3,23,19),(792,4,3,24,19),(793,4,3,25,19),(794,10,3,26,19),(795,3,3,37,19),(796,3,3,38,19),(797,3,3,39,19),(798,3,3,5,20),(799,3,3,6,20),(800,3,3,7,20),(801,4,3,18,20),(802,4,3,19,20),(803,4,3,20,20),(804,4,3,21,20),(805,4,3,22,20),(806,5,3,23,20),(807,4,3,25,20),(808,3,3,37,20),(809,3,3,38,20),(810,3,3,39,20),(811,3,3,5,21),(812,3,3,6,21),(813,4,3,19,21),(814,4,3,20,21),(815,4,3,21,21),(816,4,3,22,21),(817,5,3,23,21),(818,5,3,24,21),(819,3,3,35,21),(820,3,3,36,21),(821,3,3,37,21),(822,3,3,38,21),(823,3,3,39,21),(824,4,3,17,22),(825,4,3,18,22),(826,4,3,19,22),(827,4,3,20,22),(828,4,3,21,22),(829,4,3,22,22),(830,5,3,23,22),(831,5,3,24,22),(832,5,3,25,22),(833,3,3,38,22),(834,3,3,39,22),(835,5,3,13,23),(836,5,3,14,23),(837,9,3,15,23),(838,4,3,19,23),(839,4,3,20,23),(840,4,3,21,23),(841,5,3,22,23),(842,5,3,23,23),(843,5,3,24,23),(844,5,3,25,23),(845,13,3,26,23),(846,5,3,12,24),(847,5,3,13,24),(848,5,3,14,24),(849,0,3,19,24),(850,5,3,23,24),(851,5,3,24,24),(852,5,3,25,24),(853,12,3,33,24),(854,5,3,9,25),(855,5,3,11,25),(856,5,3,12,25),(857,5,3,13,25),(858,5,3,14,25),(859,5,3,24,25),(860,5,3,25,25),(861,5,3,26,25),(862,5,3,9,26),(863,5,3,10,26),(864,5,3,11,26),(865,5,3,12,26),(866,5,3,13,26),(867,5,3,14,26),(868,14,3,18,26),(869,0,3,21,26),(870,5,3,23,26),(871,5,3,24,26),(872,5,3,25,26),(873,5,3,26,26),(874,5,3,8,27),(875,5,3,9,27),(876,5,3,10,27),(877,5,3,11,27),(878,5,3,12,27),(879,5,3,13,27),(880,5,3,23,27),(881,5,3,25,27),(882,5,3,26,27),(883,8,3,29,27),(884,5,3,9,28),(885,5,3,10,28),(886,5,3,12,28),(887,5,3,23,28),(888,4,7,0,0),(889,4,7,1,0),(890,4,7,2,0),(891,4,7,3,0),(892,4,7,0,1),(893,4,7,1,1),(894,4,7,2,1),(895,4,7,3,1),(896,4,7,4,1),(897,8,7,14,1),(898,4,7,0,2),(899,4,7,1,2),(900,4,7,2,2),(901,4,7,3,2),(902,5,7,24,2),(903,4,7,0,3),(904,4,7,1,3),(905,4,7,2,3),(906,4,7,3,3),(907,4,7,4,3),(908,4,7,5,3),(909,5,7,23,3),(910,5,7,24,3),(911,4,7,0,4),(912,4,7,1,4),(913,4,7,2,4),(914,4,7,4,4),(915,11,7,9,4),(916,5,7,23,4),(917,5,7,28,4),(918,4,7,0,5),(919,4,7,1,5),(920,4,7,4,5),(921,5,7,23,5),(922,5,7,25,5),(923,5,7,26,5),(924,5,7,27,5),(925,5,7,28,5),(926,5,7,29,5),(927,5,7,30,5),(928,4,7,0,6),(929,5,7,15,6),(930,5,7,16,6),(931,5,7,22,6),(932,5,7,23,6),(933,5,7,24,6),(934,5,7,25,6),(935,5,7,28,6),(936,8,7,29,6),(937,4,7,0,7),(938,4,7,1,7),(939,4,7,2,7),(940,5,7,13,7),(941,5,7,15,7),(942,5,7,16,7),(943,5,7,22,7),(944,5,7,23,7),(945,5,7,24,7),(946,5,7,25,7),(947,5,7,26,7),(948,5,7,27,7),(949,5,7,28,7),(950,4,7,0,8),(951,4,7,1,8),(952,4,7,2,8),(953,5,7,13,8),(954,5,7,14,8),(955,5,7,15,8),(956,5,7,16,8),(957,5,7,17,8),(958,5,7,18,8),(959,5,7,22,8),(960,5,7,23,8),(961,5,7,24,8),(962,5,7,25,8),(963,5,7,26,8),(964,5,7,27,8),(965,5,7,28,8),(966,4,7,0,9),(967,4,7,1,9),(968,4,7,2,9),(969,5,7,13,9),(970,5,7,14,9),(971,5,7,15,9),(972,5,7,16,9),(973,5,7,24,9),(974,5,7,25,9),(975,13,7,26,9),(976,4,7,0,10),(977,4,7,1,10),(978,4,7,2,10),(979,0,7,6,10),(980,5,7,9,10),(981,5,7,10,10),(982,5,7,11,10),(983,5,7,12,10),(984,5,7,13,10),(985,5,7,14,10),(986,5,7,15,10),(987,5,7,16,10),(988,6,7,22,10),(989,6,7,23,10),(990,6,7,24,10),(991,6,7,25,10),(992,4,7,0,11),(993,4,7,1,11),(994,4,7,2,11),(995,4,7,3,11),(996,3,7,8,11),(997,3,7,9,11),(998,3,7,10,11),(999,3,7,11,11),(1000,5,7,12,11),(1001,5,7,13,11),(1002,5,7,14,11),(1003,5,7,15,11),(1004,1,7,22,11),(1005,6,7,24,11),(1006,6,7,25,11),(1007,6,7,26,11),(1008,6,7,27,11),(1009,3,7,28,11),(1010,3,7,29,11),(1011,4,7,0,12),(1012,4,7,2,12),(1013,4,7,3,12),(1014,3,7,9,12),(1015,3,7,10,12),(1016,5,7,11,12),(1017,5,7,12,12),(1018,5,7,13,12),(1019,5,7,14,12),(1020,3,7,21,12),(1021,6,7,24,12),(1022,6,7,25,12),(1023,6,7,26,12),(1024,3,7,27,12),(1025,3,7,28,12),(1026,3,7,29,12),(1027,3,7,30,12),(1028,4,7,0,13),(1029,3,7,5,13),(1030,3,7,6,13),(1031,3,7,8,13),(1032,3,7,9,13),(1033,5,7,11,13),(1034,5,7,12,13),(1035,3,7,21,13),(1036,3,7,22,13),(1037,3,7,23,13),(1038,3,7,24,13),(1039,3,7,25,13),(1040,3,7,26,13),(1041,3,7,27,13),(1042,3,7,28,13),(1043,4,7,0,14),(1044,3,7,3,14),(1045,3,7,4,14),(1046,3,7,5,14),(1047,3,7,6,14),(1048,3,7,7,14),(1049,3,7,8,14),(1050,0,7,9,14),(1051,2,7,21,14),(1052,3,7,24,14),(1053,3,7,25,14),(1054,3,7,26,14),(1055,3,7,27,14),(1056,3,7,28,14),(1057,3,7,5,15),(1058,3,7,6,15),(1059,3,7,7,15),(1060,3,7,8,15),(1061,10,7,24,15),(1062,3,7,28,15),(1063,9,7,4,16),(1064,3,7,8,16),(1065,0,7,30,16),(1066,4,7,18,18),(1067,4,7,20,18),(1068,4,7,21,18),(1069,0,7,0,19),(1070,3,7,3,19),(1071,3,7,4,19),(1072,6,7,14,19),(1073,6,7,15,19),(1074,4,7,17,19),(1075,4,7,18,19),(1076,4,7,19,19),(1077,4,7,20,19),(1078,4,7,21,19),(1079,12,7,22,19),(1080,6,7,29,19),(1081,6,7,30,19),(1082,6,7,31,19),(1083,3,7,2,20),(1084,3,7,4,20),(1085,6,7,14,20),(1086,4,7,17,20),(1087,4,7,18,20),(1088,4,7,19,20),(1089,4,7,20,20),(1090,4,7,21,20),(1091,6,7,29,20),(1092,7,7,30,20),(1093,6,7,31,20),(1094,3,7,0,21),(1095,3,7,1,21),(1096,3,7,2,21),(1097,3,7,3,21),(1098,3,7,4,21),(1099,6,7,14,21),(1100,4,7,15,21),(1101,4,7,16,21),(1102,4,7,17,21),(1103,4,7,18,21),(1104,4,7,19,21),(1105,4,7,20,21),(1106,4,7,21,21),(1107,7,7,28,21),(1108,7,7,29,21),(1109,7,7,30,21),(1110,6,7,31,21),(1111,6,7,32,21),(1112,3,7,0,22),(1113,3,7,1,22),(1114,3,7,2,22),(1115,3,7,3,22),(1116,6,7,12,22),(1117,6,7,13,22),(1118,6,7,14,22),(1119,6,7,15,22),(1120,6,7,16,22),(1121,4,7,17,22),(1122,4,7,18,22),(1123,4,7,19,22),(1124,4,7,20,22),(1125,4,7,21,22),(1126,7,7,29,22),(1127,7,7,30,22),(1128,6,7,31,22),(1129,3,7,0,23),(1130,3,7,1,23),(1131,3,7,2,23),(1132,13,7,3,23),(1133,6,7,11,23),(1134,6,7,12,23),(1135,6,7,13,23),(1136,6,7,14,23),(1137,6,7,15,23),(1138,6,7,16,23),(1139,6,7,17,23),(1140,4,7,20,23),(1141,4,7,21,23),(1142,7,7,28,23),(1143,7,7,29,23),(1144,6,7,30,23),(1145,6,7,31,23),(1146,6,7,32,23),(1147,3,7,0,24),(1148,3,7,1,24),(1149,3,7,2,24),(1150,6,7,9,24),(1151,6,7,10,24),(1152,6,7,11,24),(1153,6,7,12,24),(1154,6,7,13,24),(1155,6,7,14,24),(1156,6,7,15,24),(1157,6,7,16,24),(1158,6,7,17,24),(1159,4,7,18,24),(1160,4,7,19,24),(1161,4,7,20,24),(1162,4,7,21,24),(1163,7,7,28,24),(1164,7,7,29,24),(1165,7,7,30,24),(1166,6,7,31,24),(1167,6,7,32,24),(1168,3,7,0,25),(1169,5,7,9,25),(1170,6,7,10,25),(1171,5,7,11,25),(1172,5,7,13,25),(1173,5,7,16,25),(1174,6,7,17,25),(1175,5,7,18,25),(1176,4,7,21,25),(1177,4,7,22,25),(1178,4,7,23,25),(1179,2,7,24,25),(1180,7,7,26,25),(1181,7,7,27,25),(1182,7,7,28,25),(1183,7,7,29,25),(1184,7,7,30,25),(1185,7,7,31,25),(1186,6,7,32,25),(1187,3,7,0,26),(1188,5,7,7,26),(1189,5,7,8,26),(1190,5,7,9,26),(1191,6,7,10,26),(1192,5,7,11,26),(1193,5,7,12,26),(1194,5,7,13,26),(1195,5,7,14,26),(1196,5,7,15,26),(1197,5,7,16,26),(1198,5,7,17,26),(1199,5,7,18,26),(1200,4,7,20,26),(1201,4,7,21,26),(1202,4,7,22,26),(1203,7,7,26,26),(1204,7,7,27,26),(1205,7,7,28,26),(1206,14,7,29,26),(1207,5,7,6,27),(1208,5,7,7,27),(1209,5,7,9,27),(1210,5,7,10,27),(1211,5,7,11,27),(1212,5,7,12,27),(1213,5,7,13,27),(1214,5,7,14,27),(1215,5,7,15,27),(1216,5,7,16,27),(1217,5,7,17,27),(1218,5,7,18,27),(1219,4,7,21,27),(1220,4,7,22,27),(1221,4,7,23,27),(1222,4,7,24,27),(1223,4,7,25,27),(1224,7,7,26,27),(1225,7,7,27,27),(1226,7,7,28,27),(1227,5,7,4,28),(1228,5,7,5,28),(1229,5,7,6,28),(1230,5,7,7,28),(1231,5,7,8,28),(1232,5,7,10,28),(1233,5,7,13,28),(1234,5,7,14,28),(1235,5,7,15,28),(1236,5,7,16,28),(1237,5,7,17,28),(1238,5,7,18,28),(1239,5,7,19,28),(1240,5,7,20,28),(1241,0,7,22,28),(1242,4,7,24,28),(1243,4,7,25,28),(1244,4,7,26,28),(1245,7,7,27,28),(1246,7,7,28,28),(1247,9,7,0,29),(1248,5,7,6,29),(1249,5,7,7,29),(1250,5,7,8,29),(1251,5,7,9,29),(1252,5,7,10,29),(1253,3,7,12,29),(1254,3,7,13,29),(1255,3,7,14,29),(1256,5,7,15,29),(1257,5,7,16,29),(1258,5,7,17,29),(1259,5,7,18,29),(1260,4,7,24,29),(1261,4,7,26,29),(1262,4,7,27,29),(1263,7,7,28,29),(1264,5,7,4,30),(1265,5,7,5,30),(1266,5,7,6,30),(1267,5,7,7,30),(1268,5,7,9,30),(1269,5,7,10,30),(1270,5,7,11,30),(1271,3,7,12,30),(1272,3,7,13,30),(1273,3,7,14,30),(1274,5,7,15,30),(1275,6,7,23,30),(1276,6,7,24,30),(1277,7,7,26,30),(1278,7,7,27,30),(1279,7,7,28,30),(1280,7,7,29,30),(1281,7,7,30,30),(1282,5,7,5,31),(1283,5,7,6,31),(1284,5,7,7,31),(1285,5,7,8,31),(1286,5,7,9,31),(1287,5,7,10,31),(1288,5,7,11,31),(1289,5,7,12,31),(1290,3,7,13,31),(1291,3,7,14,31),(1292,3,7,15,31),(1293,6,7,21,31),(1294,6,7,22,31),(1295,6,7,23,31),(1296,6,7,24,31),(1297,7,7,28,31),(1298,7,7,29,31),(1299,7,7,30,31),(1300,7,7,31,31),(1301,5,7,2,32),(1302,5,7,3,32),(1303,5,7,4,32),(1304,5,7,5,32),(1305,5,7,6,32),(1306,5,7,7,32),(1307,5,7,8,32),(1308,5,7,9,32),(1309,5,7,10,32),(1310,5,7,11,32),(1311,3,7,12,32),(1312,3,7,13,32),(1313,6,7,21,32),(1314,6,7,22,32),(1315,6,7,23,32),(1316,6,7,24,32),(1317,7,7,28,32),(1318,7,7,29,32),(1319,5,7,5,33),(1320,5,7,6,33),(1321,5,7,7,33),(1322,5,7,8,33),(1323,5,7,9,33),(1324,5,7,10,33),(1325,5,7,11,33),(1326,3,7,12,33),(1327,3,7,13,33),(1328,3,7,14,33),(1329,3,7,15,33),(1330,6,7,22,33),(1331,6,7,23,33),(1332,6,7,24,33),(1333,11,7,3,34),(1334,5,7,7,34),(1335,5,7,8,34),(1336,5,7,9,34),(1337,5,7,10,34),(1338,5,7,11,34),(1339,5,7,12,34),(1340,3,7,13,34),(1341,3,7,14,34),(1342,6,7,22,34),(1343,5,7,8,35),(1344,5,7,9,35),(1345,5,7,11,35),(1346,5,7,12,35),(1347,3,7,13,35),(1348,10,7,26,35),(1349,5,7,8,36),(1350,5,7,9,36),(1351,5,7,10,36),(1352,5,7,11,36),(1353,5,7,12,36),(1354,3,7,13,36),(1355,4,7,8,37),(1356,4,7,9,37),(1357,4,7,10,37),(1358,4,7,11,37),(1359,4,7,7,38),(1360,4,7,8,38),(1361,4,7,9,38),(1362,4,7,7,39),(1363,4,7,8,39),(1364,4,7,9,39),(1365,4,7,10,39),(1366,4,7,11,39),(1367,4,7,13,39),(1368,4,7,4,40),(1369,4,7,5,40),(1370,4,7,6,40),(1371,4,7,7,40),(1372,4,7,8,40),(1373,4,7,9,40),(1374,4,7,10,40),(1375,4,7,11,40),(1376,4,7,12,40),(1377,4,7,13,40),(1378,4,7,14,40),(1379,5,20,2,0),(1380,5,20,3,0),(1381,5,20,4,0),(1382,5,20,5,0),(1383,5,20,6,0),(1384,8,20,7,0),(1385,5,20,10,0),(1386,5,20,11,0),(1387,5,20,12,0),(1388,5,20,13,0),(1389,0,20,14,0),(1390,5,20,27,0),(1391,5,20,28,0),(1392,5,20,29,0),(1393,5,20,34,0),(1394,5,20,1,1),(1395,5,20,2,1),(1396,5,20,3,1),(1397,5,20,4,1),(1398,5,20,10,1),(1399,5,20,11,1),(1400,5,20,12,1),(1401,5,20,13,1),(1402,13,20,22,1),(1403,5,20,28,1),(1404,5,20,29,1),(1405,5,20,30,1),(1406,5,20,31,1),(1407,5,20,32,1),(1408,5,20,33,1),(1409,5,20,34,1),(1410,5,20,35,1),(1411,5,20,2,2),(1412,5,20,3,2),(1413,4,20,6,2),(1414,5,20,10,2),(1415,5,20,11,2),(1416,5,20,12,2),(1417,5,20,13,2),(1418,0,20,17,2),(1419,4,20,20,2),(1420,5,20,28,2),(1421,5,20,32,2),(1422,5,20,33,2),(1423,5,20,34,2),(1424,5,20,0,3),(1425,5,20,1,3),(1426,5,20,2,3),(1427,6,20,5,3),(1428,4,20,6,3),(1429,4,20,7,3),(1430,0,20,8,3),(1431,5,20,10,3),(1432,5,20,11,3),(1433,5,20,12,3),(1434,5,20,13,3),(1435,5,20,14,3),(1436,3,20,15,3),(1437,3,20,16,3),(1438,4,20,19,3),(1439,4,20,20,3),(1440,4,20,21,3),(1441,4,20,22,3),(1442,4,20,23,3),(1443,4,20,24,3),(1444,1,20,27,3),(1445,5,20,32,3),(1446,5,20,33,3),(1447,3,20,34,3),(1448,5,20,2,4),(1449,5,20,3,4),(1450,6,20,4,4),(1451,6,20,5,4),(1452,6,20,6,4),(1453,4,20,7,4),(1454,14,20,10,4),(1455,5,20,13,4),(1456,5,20,14,4),(1457,3,20,15,4),(1458,3,20,16,4),(1459,6,20,17,4),(1460,3,20,18,4),(1461,4,20,19,4),(1462,4,20,21,4),(1463,4,20,22,4),(1464,4,20,23,4),(1465,2,20,30,4),(1466,5,20,32,4),(1467,5,20,33,4),(1468,3,20,34,4),(1469,3,20,35,4),(1470,3,20,36,4),(1471,5,20,2,5),(1472,5,20,3,5),(1473,6,20,4,5),(1474,6,20,5,5),(1475,4,20,6,5),(1476,4,20,7,5),(1477,4,20,8,5),(1478,4,20,9,5),(1479,5,20,13,5),(1480,3,20,15,5),(1481,3,20,16,5),(1482,3,20,17,5),(1483,3,20,18,5),(1484,3,20,19,5),(1485,4,20,22,5),(1486,3,20,33,5),(1487,3,20,34,5),(1488,3,20,35,5),(1489,3,20,36,5),(1490,3,20,37,5),(1491,5,20,2,6),(1492,5,20,3,6),(1493,6,20,4,6),(1494,6,20,5,6),(1495,6,20,6,6),(1496,4,20,7,6),(1497,4,20,8,6),(1498,3,20,16,6),(1499,3,20,17,6),(1500,9,20,18,6),(1501,3,20,33,6),(1502,3,20,34,6),(1503,3,20,36,6),(1504,9,20,3,7),(1505,11,20,30,7),(1506,12,20,8,8),(1507,11,20,0,10),(1508,4,20,4,10),(1509,4,20,7,10),(1510,3,20,27,10),(1511,3,20,29,10),(1512,4,20,4,11),(1513,4,20,5,11),(1514,4,20,6,11),(1515,4,20,7,11),(1516,3,20,27,11),(1517,3,20,28,11),(1518,3,20,29,11),(1519,4,20,5,12),(1520,4,20,6,12),(1521,4,20,7,12),(1522,4,20,15,12),(1523,4,20,16,12),(1524,3,20,26,12),(1525,3,20,27,12),(1526,3,20,28,12),(1527,4,20,5,13),(1528,4,20,6,13),(1529,4,20,14,13),(1530,4,20,15,13),(1531,3,20,27,13),(1532,3,20,28,13),(1533,4,20,5,14),(1534,6,20,7,14),(1535,6,20,8,14),(1536,6,20,9,14),(1537,4,20,10,14),(1538,4,20,11,14),(1539,4,20,12,14),(1540,4,20,13,14),(1541,4,20,14,14),(1542,4,20,15,14),(1543,6,20,25,14),(1544,3,20,28,14),(1545,3,20,29,14),(1546,4,20,37,14),(1547,7,20,6,15),(1548,6,20,7,15),(1549,6,20,8,15),(1550,6,20,9,15),(1551,6,20,10,15),(1552,6,20,11,15),(1553,4,20,12,15),(1554,4,20,13,15),(1555,0,20,14,15),(1556,6,20,23,15),(1557,6,20,24,15),(1558,6,20,25,15),(1559,6,20,26,15),(1560,12,20,31,15),(1561,4,20,37,15),(1562,1,20,2,16),(1563,7,20,6,16),(1564,7,20,7,16),(1565,10,20,8,16),(1566,3,20,12,16),(1567,3,20,13,16),(1568,3,20,16,16),(1569,3,20,17,16),(1570,6,20,25,16),(1571,6,20,26,16),(1572,4,20,37,16),(1573,7,20,5,17),(1574,7,20,6,17),(1575,3,20,12,17),(1576,3,20,13,17),(1577,3,20,14,17),(1578,3,20,15,17),(1579,3,20,16,17),(1580,3,20,17,17),(1581,3,20,18,17),(1582,3,20,19,17),(1583,3,20,20,17),(1584,6,20,25,17),(1585,6,20,26,17),(1586,4,20,37,17),(1587,7,20,3,18),(1588,7,20,4,18),(1589,7,20,5,18),(1590,7,20,6,18),(1591,7,20,7,18),(1592,3,20,12,18),(1593,3,20,13,18),(1594,3,20,14,18),(1595,3,20,15,18),(1596,3,20,16,18),(1597,3,20,17,18),(1598,3,20,18,18),(1599,4,20,37,18),(1600,7,20,3,19),(1601,7,20,4,19),(1602,7,20,5,19),(1603,0,20,6,19),(1604,13,20,13,19),(1605,4,20,37,19),(1606,7,20,2,20),(1607,7,20,3,20),(1608,7,20,4,20),(1609,7,20,5,20),(1610,7,20,8,20),(1611,7,20,9,20),(1612,7,20,10,20),(1613,7,20,11,20),(1614,6,20,12,20),(1615,4,20,37,20),(1616,7,20,2,21),(1617,7,20,4,21),(1618,7,20,5,21),(1619,7,20,6,21),(1620,7,20,7,21),(1621,7,20,8,21),(1622,7,20,9,21),(1623,7,20,10,21),(1624,6,20,11,21),(1625,6,20,12,21),(1626,6,20,13,21),(1627,6,20,14,21),(1628,6,20,15,21),(1629,6,20,16,21),(1630,6,20,17,21),(1631,6,20,18,21),(1632,4,20,33,21),(1633,4,20,34,21),(1634,4,20,35,21),(1635,4,20,36,21),(1636,4,20,37,21),(1637,6,21,9,0),(1638,6,21,10,0),(1639,4,21,11,0),(1640,7,21,19,0),(1641,7,21,20,0),(1642,7,21,21,0),(1643,7,21,22,0),(1644,7,21,23,0),(1645,7,21,24,0),(1646,6,21,10,1),(1647,4,21,11,1),(1648,7,21,20,1),(1649,7,21,21,1),(1650,7,21,22,1),(1651,7,21,23,1),(1652,7,21,24,1),(1653,7,21,25,1),(1654,6,21,7,2),(1655,6,21,8,2),(1656,6,21,9,2),(1657,6,21,10,2),(1658,4,21,11,2),(1659,4,21,12,2),(1660,4,21,13,2),(1661,4,21,14,2),(1662,7,21,21,2),(1663,7,21,22,2),(1664,7,21,23,2),(1665,7,21,24,2),(1666,7,21,25,2),(1667,7,21,26,2),(1668,7,21,27,2),(1669,7,21,28,2),(1670,7,21,29,2),(1671,7,21,30,2),(1672,13,21,5,3),(1673,4,21,11,3),(1674,4,21,12,3),(1675,4,21,14,3),(1676,4,21,15,3),(1677,6,21,16,3),(1678,7,21,20,3),(1679,7,21,21,3),(1680,7,21,22,3),(1681,7,21,23,3),(1682,7,21,24,3),(1683,7,21,25,3),(1684,7,21,26,3),(1685,7,21,27,3),(1686,7,21,28,3),(1687,7,21,29,3),(1688,7,21,30,3),(1689,0,21,31,3),(1690,4,21,13,4),(1691,4,21,14,4),(1692,6,21,16,4),(1693,6,21,17,4),(1694,7,21,19,4),(1695,7,21,20,4),(1696,7,21,21,4),(1697,7,21,22,4),(1698,7,21,23,4),(1699,7,21,24,4),(1700,7,21,25,4),(1701,7,21,26,4),(1702,7,21,27,4),(1703,7,21,28,4),(1704,7,21,29,4),(1705,3,21,30,4),(1706,4,21,2,5),(1707,4,21,3,5),(1708,4,21,5,5),(1709,6,21,17,5),(1710,7,21,18,5),(1711,7,21,19,5),(1712,7,21,20,5),(1713,9,21,21,5),(1714,6,21,25,5),(1715,6,21,26,5),(1716,6,21,27,5),(1717,7,21,29,5),(1718,3,21,30,5),(1719,3,21,31,5),(1720,4,21,3,6),(1721,4,21,4,6),(1722,4,21,5,6),(1723,4,21,6,6),(1724,7,21,19,6),(1725,2,21,25,6),(1726,6,21,27,6),(1727,3,21,28,6),(1728,3,21,29,6),(1729,3,21,30,6),(1730,3,21,31,6),(1731,3,21,32,6),(1732,4,21,3,7),(1733,4,21,4,7),(1734,14,21,5,7),(1735,6,21,27,7),(1736,6,21,28,7),(1737,3,21,29,7),(1738,3,21,30,7),(1739,3,21,31,7),(1740,3,21,32,7),(1741,4,21,3,8),(1742,4,21,4,8),(1743,11,21,21,8),(1744,6,21,27,8),(1745,3,21,29,8),(1746,3,21,30,8),(1747,3,21,31,8),(1748,4,21,3,9),(1749,5,21,16,9),(1750,5,21,17,9),(1751,5,21,25,9),(1752,5,21,29,9),(1753,5,21,30,9),(1754,5,21,31,9),(1755,5,21,32,9),(1756,0,21,10,10),(1757,5,21,14,10),(1758,5,21,15,10),(1759,5,21,16,10),(1760,5,21,17,10),(1761,5,21,18,10),(1762,5,21,25,10),(1763,5,21,26,10),(1764,5,21,28,10),(1765,5,21,29,10),(1766,5,21,30,10),(1767,5,21,14,11),(1768,5,21,16,11),(1769,0,21,17,11),(1770,5,21,25,11),(1771,5,21,26,11),(1772,5,21,27,11),(1773,5,21,28,11),(1774,5,21,29,11),(1775,5,21,30,11),(1776,5,21,31,11),(1777,5,21,32,11),(1778,5,21,33,11),(1779,5,21,13,12),(1780,5,21,14,12),(1781,5,21,16,12),(1782,5,21,25,12),(1783,5,21,26,12),(1784,5,21,27,12),(1785,5,21,28,12),(1786,10,21,29,12),(1787,5,21,12,13),(1788,5,21,14,13),(1789,5,21,15,13),(1790,5,21,16,13),(1791,5,21,17,13),(1792,8,21,26,13),(1793,5,21,12,14),(1794,5,21,13,14),(1795,5,21,14,14),(1796,5,21,15,14),(1797,5,21,17,14),(1798,0,21,24,14),(1799,3,21,1,15),(1800,4,21,7,15),(1801,5,21,14,15),(1802,5,21,15,15),(1803,5,21,16,15),(1804,3,21,0,16),(1805,3,21,1,16),(1806,4,21,7,16),(1807,5,21,10,16),(1808,5,21,11,16),(1809,5,21,12,16),(1810,5,21,26,16),(1811,5,21,27,16),(1812,5,21,28,16),(1813,3,21,0,17),(1814,3,21,1,17),(1815,6,21,5,17),(1816,4,21,6,17),(1817,4,21,7,17),(1818,4,21,9,17),(1819,4,21,10,17),(1820,5,21,11,17),(1821,5,21,12,17),(1822,5,21,13,17),(1823,5,21,25,17),(1824,5,21,26,17),(1825,5,21,27,17),(1826,1,21,28,17),(1827,3,21,1,18),(1828,3,21,2,18),(1829,6,21,3,18),(1830,6,21,4,18),(1831,6,21,5,18),(1832,6,21,6,18),(1833,4,21,7,18),(1834,4,21,8,18),(1835,4,21,9,18),(1836,5,21,10,18),(1837,5,21,11,18),(1838,5,21,25,18),(1839,5,21,26,18),(1840,5,21,27,18),(1841,3,21,0,19),(1842,3,21,1,19),(1843,3,21,2,19),(1844,6,21,3,19),(1845,6,21,4,19),(1846,4,21,6,19),(1847,4,21,7,19),(1848,4,21,8,19),(1849,5,21,9,19),(1850,5,21,10,19),(1851,5,21,11,19),(1852,5,21,12,19),(1853,8,21,16,19),(1854,5,21,24,19),(1855,5,21,25,19),(1856,5,21,26,19),(1857,12,21,27,19),(1858,3,21,0,20),(1859,3,21,1,20),(1860,3,21,2,20),(1861,5,21,7,20),(1862,5,21,8,20),(1863,5,21,10,20),(1864,5,21,11,20),(1865,5,21,12,20),(1866,5,21,23,20),(1867,5,21,24,20),(1868,5,21,25,20),(1869,5,21,26,20),(1870,3,21,0,21),(1871,3,21,1,21),(1872,5,21,7,21),(1873,5,21,8,21),(1874,5,21,9,21),(1875,5,21,10,21),(1876,5,21,11,21),(1877,5,21,12,21),(1878,5,21,13,21),(1879,5,21,14,21),(1880,5,21,23,21),(1881,5,21,24,21),(1882,5,21,25,21),(1883,5,21,26,21),(1884,12,21,5,22),(1885,11,21,11,22),(1886,5,21,23,22),(1887,5,21,24,22),(1888,5,21,26,22),(1889,5,21,24,23),(1890,5,21,25,23),(1891,4,21,33,23),(1892,4,21,33,24),(1893,14,21,2,25),(1894,6,21,21,25),(1895,3,21,24,25),(1896,4,21,31,25),(1897,4,21,32,25),(1898,4,21,33,25),(1899,0,21,0,26),(1900,3,21,18,26),(1901,3,21,19,26),(1902,6,21,20,26),(1903,6,21,21,26),(1904,6,21,22,26),(1905,6,21,23,26),(1906,3,21,24,26),(1907,3,21,25,26),(1908,4,21,31,26),(1909,4,21,32,26),(1910,4,21,33,26),(1911,3,21,15,27),(1912,3,21,16,27),(1913,3,21,17,27),(1914,3,21,18,27),(1915,0,21,19,27),(1916,6,21,21,27),(1917,3,21,22,27),(1918,3,21,23,27),(1919,3,21,24,27),(1920,3,21,26,27),(1921,3,21,27,27),(1922,4,21,31,27),(1923,4,21,33,27),(1924,4,21,8,28),(1925,4,21,9,28),(1926,4,21,11,28),(1927,3,21,16,28),(1928,3,21,17,28),(1929,6,21,21,28),(1930,3,21,22,28),(1931,3,21,23,28),(1932,3,21,24,28),(1933,3,21,25,28),(1934,3,21,26,28),(1935,1,21,28,28),(1936,4,21,33,28),(1937,4,21,7,29),(1938,4,21,8,29),(1939,4,21,9,29),(1940,4,21,10,29),(1941,4,21,11,29),(1942,3,21,17,29),(1943,3,21,18,29),(1944,3,21,19,29),(1945,13,21,20,29),(1946,3,21,26,29),(1947,4,21,33,29),(1948,4,21,7,30),(1949,4,21,8,30),(1950,4,21,9,30),(1951,3,21,17,30),(1952,3,21,18,30),(1953,3,21,19,30),(1954,3,21,26,30),(1955,4,21,8,31),(1956,3,21,19,31),(1957,7,26,19,0),(1958,7,26,20,0),(1959,7,26,21,0),(1960,7,26,22,0),(1961,7,26,23,0),(1962,7,26,24,0),(1963,7,26,25,0),(1964,7,26,26,0),(1965,7,26,27,0),(1966,7,26,28,0),(1967,7,26,29,0),(1968,0,26,30,0),(1969,4,26,40,0),(1970,4,26,41,0),(1971,4,26,42,0),(1972,4,26,43,0),(1973,4,26,44,0),(1974,4,26,45,0),(1975,4,26,46,0),(1976,4,26,47,0),(1977,4,26,49,0),(1978,4,26,50,0),(1979,4,26,51,0),(1980,4,26,52,0),(1981,7,26,18,1),(1982,7,26,19,1),(1983,7,26,20,1),(1984,7,26,21,1),(1985,7,26,22,1),(1986,7,26,23,1),(1987,7,26,24,1),(1988,7,26,25,1),(1989,7,26,26,1),(1990,7,26,27,1),(1991,7,26,28,1),(1992,7,26,29,1),(1993,4,26,40,1),(1994,2,26,41,1),(1995,4,26,43,1),(1996,4,26,44,1),(1997,4,26,45,1),(1998,4,26,46,1),(1999,4,26,48,1),(2000,4,26,49,1),(2001,4,26,50,1),(2002,4,26,51,1),(2003,4,26,52,1),(2004,0,26,14,2),(2005,7,26,17,2),(2006,7,26,18,2),(2007,7,26,19,2),(2008,7,26,20,2),(2009,7,26,21,2),(2010,7,26,24,2),(2011,7,26,25,2),(2012,7,26,26,2),(2013,7,26,27,2),(2014,7,26,28,2),(2015,7,26,29,2),(2016,7,26,30,2),(2017,5,26,39,2),(2018,5,26,40,2),(2019,4,26,43,2),(2020,4,26,44,2),(2021,4,26,45,2),(2022,4,26,46,2),(2023,4,26,47,2),(2024,4,26,48,2),(2025,4,26,49,2),(2026,4,26,51,2),(2027,0,26,0,3),(2028,7,26,19,3),(2029,7,26,21,3),(2030,7,26,22,3),(2031,7,26,23,3),(2032,7,26,24,3),(2033,7,26,25,3),(2034,7,26,26,3),(2035,7,26,27,3),(2036,7,26,28,3),(2037,7,26,29,3),(2038,5,26,39,3),(2039,5,26,40,3),(2040,4,26,41,3),(2041,4,26,42,3),(2042,4,26,43,3),(2043,4,26,44,3),(2044,4,26,45,3),(2045,4,26,46,3),(2046,4,26,47,3),(2047,4,26,48,3),(2048,4,26,49,3),(2049,4,26,50,3),(2050,7,26,21,4),(2051,7,26,22,4),(2052,7,26,23,4),(2053,7,26,25,4),(2054,7,26,26,4),(2055,7,26,28,4),(2056,7,26,29,4),(2057,5,26,40,4),(2058,5,26,41,4),(2059,4,26,42,4),(2060,4,26,43,4),(2061,4,26,45,4),(2062,4,26,46,4),(2063,4,26,47,4),(2064,7,26,22,5),(2065,7,26,23,5),(2066,7,26,24,5),(2067,7,26,25,5),(2068,7,26,26,5),(2069,7,26,27,5),(2070,7,26,29,5),(2071,5,26,38,5),(2072,5,26,40,5),(2073,5,26,41,5),(2074,4,26,46,5),(2075,7,26,24,6),(2076,7,26,26,6),(2077,7,26,27,6),(2078,5,26,36,6),(2079,5,26,37,6),(2080,5,26,38,6),(2081,5,26,39,6),(2082,5,26,40,6),(2083,5,26,41,6),(2084,5,26,42,6),(2085,4,26,46,6),(2086,2,26,1,7),(2087,6,26,6,7),(2088,6,26,7,7),(2089,6,26,8,7),(2090,7,26,22,7),(2091,7,26,23,7),(2092,7,26,24,7),(2093,4,26,27,7),(2094,4,26,28,7),(2095,5,26,40,7),(2096,5,26,42,7),(2097,0,26,49,7),(2098,6,26,3,8),(2099,6,26,4,8),(2100,6,26,5,8),(2101,6,26,6,8),(2102,8,26,24,8),(2103,4,26,27,8),(2104,4,26,28,8),(2105,4,26,29,8),(2106,5,26,38,8),(2107,5,26,39,8),(2108,5,26,40,8),(2109,5,26,41,8),(2110,5,26,42,8),(2111,6,26,6,9),(2112,6,26,7,9),(2113,4,26,27,9),(2114,0,26,35,9),(2115,5,26,39,9),(2116,5,26,41,9),(2117,6,26,46,9),(2118,6,26,47,9),(2119,6,26,4,10),(2120,6,26,5,10),(2121,6,26,6,10),(2122,6,26,17,10),(2123,6,26,18,10),(2124,4,26,27,10),(2125,6,26,44,10),(2126,6,26,47,10),(2127,6,26,48,10),(2128,3,26,5,11),(2129,1,26,9,11),(2130,6,26,17,11),(2131,6,26,18,11),(2132,4,26,23,11),(2133,4,26,24,11),(2134,4,26,25,11),(2135,4,26,26,11),(2136,4,26,27,11),(2137,4,26,28,11),(2138,4,26,29,11),(2139,6,26,44,11),(2140,6,26,45,11),(2141,6,26,46,11),(2142,6,26,47,11),(2143,6,26,48,11),(2144,3,26,5,12),(2145,5,26,7,12),(2146,5,26,8,12),(2147,5,26,11,12),(2148,5,26,12,12),(2149,6,26,15,12),(2150,6,26,16,12),(2151,6,26,17,12),(2152,6,26,18,12),(2153,6,26,19,12),(2154,4,26,20,12),(2155,4,26,21,12),(2156,4,26,22,12),(2157,4,26,23,12),(2158,4,26,24,12),(2159,4,26,25,12),(2160,4,26,26,12),(2161,4,26,27,12),(2162,4,26,28,12),(2163,4,26,29,12),(2164,4,26,30,12),(2165,6,26,44,12),(2166,6,26,46,12),(2167,6,26,47,12),(2168,3,26,0,13),(2169,3,26,1,13),(2170,3,26,2,13),(2171,3,26,5,13),(2172,3,26,6,13),(2173,5,26,7,13),(2174,5,26,8,13),(2175,5,26,9,13),(2176,5,26,10,13),(2177,5,26,11,13),(2178,6,26,15,13),(2179,6,26,16,13),(2180,6,26,18,13),(2181,4,26,21,13),(2182,4,26,22,13),(2183,4,26,23,13),(2184,4,26,24,13),(2185,4,26,25,13),(2186,4,26,26,13),(2187,4,26,27,13),(2188,4,26,28,13),(2189,4,26,29,13),(2190,4,26,30,13),(2191,8,26,34,13),(2192,13,26,46,13),(2193,3,26,0,14),(2194,3,26,1,14),(2195,3,26,2,14),(2196,3,26,3,14),(2197,3,26,5,14),(2198,5,26,7,14),(2199,5,26,8,14),(2200,5,26,9,14),(2201,5,26,10,14),(2202,5,26,11,14),(2203,5,26,12,14),(2204,5,26,13,14),(2205,6,26,16,14),(2206,4,26,21,14),(2207,4,26,22,14),(2208,4,26,23,14),(2209,4,26,24,14),(2210,10,26,25,14),(2211,4,26,30,14),(2212,3,26,0,15),(2213,3,26,1,15),(2214,3,26,2,15),(2215,3,26,3,15),(2216,3,26,4,15),(2217,3,26,5,15),(2218,3,26,6,15),(2219,5,26,7,15),(2220,5,26,8,15),(2221,5,26,9,15),(2222,5,26,10,15),(2223,5,26,12,15),(2224,5,26,13,15),(2225,4,26,23,15),(2226,4,26,24,15),(2227,4,26,30,15),(2228,3,26,1,16),(2229,3,26,2,16),(2230,3,26,3,16),(2231,3,26,4,16),(2232,3,26,5,16),(2233,3,26,6,16),(2234,3,26,7,16),(2235,3,26,8,16),(2236,5,26,9,16),(2237,5,26,12,16),(2238,3,26,18,16),(2239,3,26,19,16),(2240,3,26,22,16),(2241,3,26,23,16),(2242,4,26,24,16),(2243,3,26,51,16),(2244,3,26,0,17),(2245,3,26,1,17),(2246,3,26,2,17),(2247,11,26,4,17),(2248,6,26,12,17),(2249,6,26,13,17),(2250,6,26,14,17),(2251,3,26,19,17),(2252,3,26,20,17),(2253,3,26,22,17),(2254,3,26,23,17),(2255,4,26,24,17),(2256,3,26,50,17),(2257,3,26,51,17),(2258,3,26,0,18),(2259,3,26,1,18),(2260,3,26,2,18),(2261,6,26,10,18),(2262,6,26,11,18),(2263,6,26,12,18),(2264,6,26,13,18),(2265,6,26,14,18),(2266,3,26,19,18),(2267,3,26,20,18),(2268,3,26,21,18),(2269,3,26,22,18),(2270,3,26,23,18),(2271,4,26,24,18),(2272,4,26,25,18),(2273,3,26,26,18),(2274,3,26,50,18),(2275,3,26,51,18),(2276,3,26,52,18),(2277,6,26,9,19),(2278,6,26,10,19),(2279,6,26,11,19),(2280,6,26,13,19),(2281,3,26,18,19),(2282,3,26,19,19),(2283,3,26,20,19),(2284,3,26,21,19),(2285,3,26,22,19),(2286,3,26,23,19),(2287,3,26,24,19),(2288,3,26,25,19),(2289,3,26,26,19),(2290,12,26,37,19),(2291,3,26,51,19),(2292,3,26,52,19),(2293,6,26,13,20),(2294,3,26,19,20),(2295,3,26,20,20),(2296,3,26,22,20),(2297,3,26,23,20),(2298,3,26,26,20),(2299,3,26,48,20),(2300,3,26,50,20),(2301,3,26,51,20),(2302,3,26,52,20),(2303,11,26,19,21),(2304,3,26,23,21),(2305,3,26,24,21),(2306,3,26,25,21),(2307,3,26,48,21),(2308,3,26,49,21),(2309,3,26,50,21),(2310,3,26,51,21),(2311,3,26,52,21),(2312,3,26,23,22),(2313,3,26,24,22),(2314,5,26,30,22),(2315,5,26,31,22),(2316,5,26,32,22),(2317,3,26,47,22),(2318,3,26,48,22),(2319,3,26,50,22),(2320,3,26,51,22),(2321,3,26,52,22),(2322,12,26,6,23),(2323,5,26,30,23),(2324,5,26,31,23),(2325,5,26,32,23),(2326,5,26,33,23),(2327,4,26,44,23),(2328,4,26,45,23),(2329,4,26,46,23),(2330,3,26,47,23),(2331,3,26,48,23),(2332,3,26,49,23),(2333,3,26,50,23),(2334,3,26,51,23),(2335,3,26,52,23),(2336,0,26,2,24),(2337,0,26,17,24),(2338,5,26,29,24),(2339,5,26,31,24),(2340,5,26,33,24),(2341,5,26,34,24),(2342,5,26,35,24),(2343,5,26,36,24),(2344,4,26,44,24),(2345,4,26,45,24),(2346,3,26,48,24),(2347,3,26,49,24),(2348,3,26,50,24),(2349,4,26,51,24),(2350,4,26,52,24),(2351,0,26,4,25),(2352,5,26,29,25),(2353,5,26,30,25),(2354,5,26,31,25),(2355,5,26,32,25),(2356,5,26,33,25),(2357,14,26,35,25),(2358,4,26,45,25),(2359,4,26,48,25),(2360,4,26,49,25),(2361,4,26,50,25),(2362,4,26,51,25),(2363,5,26,31,26),(2364,5,26,32,26),(2365,5,26,33,26),(2366,5,26,34,26),(2367,9,26,38,26),(2368,4,26,45,26),(2369,4,26,46,26),(2370,4,26,47,26),(2371,4,26,48,26),(2372,4,26,49,26),(2373,4,26,50,26),(2374,4,26,51,26),(2375,5,26,31,27),(2376,5,26,32,27),(2377,5,26,33,27),(2378,4,26,42,27),(2379,4,26,43,27),(2380,4,26,44,27),(2381,4,26,45,27),(2382,4,26,46,27),(2383,4,26,47,27),(2384,4,26,48,27),(2385,4,26,49,27),(2386,4,26,50,27),(2387,4,26,51,27),(2388,4,26,43,28),(2389,4,26,44,28),(2390,4,26,46,28),(2391,4,26,47,28),(2392,4,26,48,28),(2393,4,26,49,28),(2394,4,26,50,28),(2395,4,26,51,28),(2396,4,26,52,28),(2397,4,26,44,29),(2398,4,26,47,29),(2399,4,26,48,29),(2400,4,26,49,29),(2401,4,26,50,29),(2402,4,26,51,29),(2403,4,26,52,29),(2404,3,28,0,0),(2405,5,28,35,0),(2406,5,28,36,0),(2407,5,28,37,0),(2408,5,28,38,0),(2409,5,28,39,0),(2410,5,28,40,0),(2411,5,28,41,0),(2412,5,28,42,0),(2413,5,28,43,0),(2414,5,28,44,0),(2415,5,28,45,0),(2416,5,28,46,0),(2417,5,28,47,0),(2418,5,28,48,0),(2419,5,28,49,0),(2420,3,28,0,1),(2421,3,28,1,1),(2422,3,28,2,1),(2423,10,28,11,1),(2424,5,28,33,1),(2425,5,28,34,1),(2426,5,28,35,1),(2427,5,28,36,1),(2428,5,28,37,1),(2429,5,28,38,1),(2430,5,28,39,1),(2431,5,28,40,1),(2432,5,28,41,1),(2433,5,28,42,1),(2434,5,28,43,1),(2435,5,28,44,1),(2436,5,28,45,1),(2437,5,28,46,1),(2438,5,28,47,1),(2439,5,28,48,1),(2440,5,28,49,1),(2441,3,28,0,2),(2442,3,28,1,2),(2443,3,28,2,2),(2444,3,28,3,2),(2445,3,28,7,2),(2446,6,28,24,2),(2447,5,28,32,2),(2448,5,28,33,2),(2449,5,28,34,2),(2450,5,28,35,2),(2451,5,28,36,2),(2452,5,28,37,2),(2453,5,28,38,2),(2454,5,28,39,2),(2455,5,28,40,2),(2456,5,28,41,2),(2457,5,28,42,2),(2458,5,28,43,2),(2459,5,28,44,2),(2460,5,28,45,2),(2461,5,28,46,2),(2462,5,28,47,2),(2463,5,28,48,2),(2464,5,28,49,2),(2465,3,28,0,3),(2466,3,28,1,3),(2467,3,28,2,3),(2468,3,28,3,3),(2469,3,28,4,3),(2470,3,28,5,3),(2471,3,28,6,3),(2472,3,28,7,3),(2473,8,28,8,3),(2474,6,28,22,3),(2475,6,28,23,3),(2476,6,28,24,3),(2477,5,28,32,3),(2478,4,28,33,3),(2479,5,28,35,3),(2480,5,28,36,3),(2481,5,28,37,3),(2482,5,28,38,3),(2483,5,28,39,3),(2484,5,28,40,3),(2485,5,28,41,3),(2486,4,28,42,3),(2487,4,28,43,3),(2488,5,28,44,3),(2489,5,28,45,3),(2490,5,28,46,3),(2491,5,28,47,3),(2492,5,28,48,3),(2493,5,28,49,3),(2494,3,28,0,4),(2495,3,28,1,4),(2496,3,28,2,4),(2497,3,28,3,4),(2498,3,28,5,4),(2499,3,28,6,4),(2500,3,28,7,4),(2501,6,28,21,4),(2502,6,28,22,4),(2503,6,28,23,4),(2504,6,28,24,4),(2505,6,28,25,4),(2506,4,28,32,4),(2507,4,28,33,4),(2508,4,28,34,4),(2509,4,28,35,4),(2510,5,28,36,4),(2511,5,28,38,4),(2512,5,28,39,4),(2513,4,28,40,4),(2514,4,28,42,4),(2515,4,28,43,4),(2516,4,28,44,4),(2517,5,28,45,4),(2518,5,28,46,4),(2519,5,28,47,4),(2520,5,28,48,4),(2521,5,28,49,4),(2522,3,28,0,5),(2523,3,28,1,5),(2524,3,28,2,5),(2525,3,28,6,5),(2526,3,28,7,5),(2527,3,28,11,5),(2528,6,28,21,5),(2529,6,28,22,5),(2530,6,28,23,5),(2531,6,28,25,5),(2532,4,28,33,5),(2533,4,28,34,5),(2534,4,28,36,5),(2535,0,28,38,5),(2536,4,28,40,5),(2537,4,28,41,5),(2538,4,28,42,5),(2539,5,28,45,5),(2540,5,28,46,5),(2541,5,28,47,5),(2542,5,28,49,5),(2543,3,28,1,6),(2544,3,28,2,6),(2545,3,28,3,6),(2546,3,28,4,6),(2547,3,28,5,6),(2548,3,28,6,6),(2549,3,28,7,6),(2550,3,28,8,6),(2551,3,28,9,6),(2552,3,28,10,6),(2553,3,28,11,6),(2554,6,28,21,6),(2555,0,28,29,6),(2556,4,28,34,6),(2557,4,28,35,6),(2558,4,28,36,6),(2559,4,28,37,6),(2560,4,28,40,6),(2561,4,28,41,6),(2562,4,28,42,6),(2563,5,28,45,6),(2564,5,28,46,6),(2565,5,28,47,6),(2566,5,28,48,6),(2567,3,28,1,7),(2568,3,28,4,7),(2569,3,28,5,7),(2570,3,28,6,7),(2571,3,28,8,7),(2572,3,28,9,7),(2573,3,28,10,7),(2574,10,28,11,7),(2575,14,28,22,7),(2576,4,28,31,7),(2577,4,28,32,7),(2578,4,28,34,7),(2579,4,28,35,7),(2580,4,28,36,7),(2581,4,28,38,7),(2582,4,28,39,7),(2583,4,28,40,7),(2584,4,28,42,7),(2585,3,28,1,8),(2586,3,28,2,8),(2587,3,28,5,8),(2588,3,28,6,8),(2589,3,28,8,8),(2590,3,28,9,8),(2591,4,28,29,8),(2592,4,28,30,8),(2593,4,28,31,8),(2594,4,28,32,8),(2595,4,28,33,8),(2596,4,28,34,8),(2597,4,28,35,8),(2598,4,28,36,8),(2599,4,28,37,8),(2600,4,28,38,8),(2601,4,28,39,8),(2602,4,28,40,8),(2603,4,28,41,8),(2604,4,28,42,8),(2605,3,28,46,8),(2606,6,28,0,9),(2607,6,28,1,9),(2608,3,28,8,9),(2609,3,28,9,9),(2610,4,28,29,9),(2611,4,28,30,9),(2612,4,28,31,9),(2613,4,28,32,9),(2614,4,28,33,9),(2615,4,28,34,9),(2616,4,28,35,9),(2617,4,28,36,9),(2618,4,28,37,9),(2619,4,28,38,9),(2620,4,28,39,9),(2621,4,28,40,9),(2622,4,28,41,9),(2623,4,28,42,9),(2624,4,28,43,9),(2625,3,28,46,9),(2626,6,28,0,10),(2627,6,28,1,10),(2628,3,28,8,10),(2629,3,28,9,10),(2630,3,28,10,10),(2631,5,28,15,10),(2632,5,28,16,10),(2633,4,28,27,10),(2634,4,28,28,10),(2635,4,28,29,10),(2636,4,28,30,10),(2637,4,28,31,10),(2638,4,28,32,10),(2639,4,28,33,10),(2640,9,28,34,10),(2641,4,28,38,10),(2642,4,28,39,10),(2643,4,28,40,10),(2644,4,28,41,10),(2645,4,28,42,10),(2646,4,28,43,10),(2647,3,28,44,10),(2648,3,28,46,10),(2649,6,28,0,11),(2650,6,28,1,11),(2651,3,28,7,11),(2652,3,28,8,11),(2653,3,28,9,11),(2654,3,28,10,11),(2655,3,28,11,11),(2656,3,28,12,11),(2657,3,28,13,11),(2658,3,28,14,11),(2659,5,28,15,11),(2660,5,28,16,11),(2661,5,28,17,11),(2662,13,28,19,11),(2663,4,28,28,11),(2664,4,28,29,11),(2665,4,28,30,11),(2666,4,28,31,11),(2667,4,28,33,11),(2668,4,28,38,11),(2669,4,28,39,11),(2670,4,28,40,11),(2671,4,28,41,11),(2672,4,28,42,11),(2673,3,28,43,11),(2674,3,28,44,11),(2675,3,28,45,11),(2676,3,28,46,11),(2677,3,28,47,11),(2678,6,28,0,12),(2679,6,28,1,12),(2680,6,28,2,12),(2681,6,28,3,12),(2682,3,28,7,12),(2683,3,28,9,12),(2684,3,28,10,12),(2685,3,28,11,12),(2686,3,28,12,12),(2687,3,28,13,12),(2688,3,28,14,12),(2689,5,28,15,12),(2690,5,28,16,12),(2691,5,28,17,12),(2692,5,28,18,12),(2693,4,28,28,12),(2694,4,28,29,12),(2695,4,28,32,12),(2696,4,28,33,12),(2697,4,28,38,12),(2698,4,28,39,12),(2699,4,28,40,12),(2700,4,28,41,12),(2701,4,28,42,12),(2702,4,28,43,12),(2703,3,28,44,12),(2704,3,28,45,12),(2705,3,28,46,12),(2706,3,28,47,12),(2707,3,28,49,12),(2708,6,28,0,13),(2709,6,28,1,13),(2710,14,28,8,13),(2711,3,28,11,13),(2712,3,28,12,13),(2713,5,28,13,13),(2714,5,28,14,13),(2715,5,28,15,13),(2716,5,28,16,13),(2717,5,28,17,13),(2718,5,28,18,13),(2719,5,28,19,13),(2720,5,28,20,13),(2721,7,28,22,13),(2722,7,28,23,13),(2723,7,28,24,13),(2724,4,28,31,13),(2725,4,28,32,13),(2726,4,28,33,13),(2727,11,28,37,13),(2728,4,28,42,13),(2729,3,28,44,13),(2730,3,28,45,13),(2731,3,28,46,13),(2732,3,28,47,13),(2733,3,28,48,13),(2734,3,28,49,13),(2735,6,28,1,14),(2736,6,28,2,14),(2737,4,28,3,14),(2738,9,28,4,14),(2739,3,28,11,14),(2740,3,28,12,14),(2741,5,28,13,14),(2742,5,28,14,14),(2743,5,28,15,14),(2744,5,28,16,14),(2745,5,28,17,14),(2746,5,28,18,14),(2747,5,28,19,14),(2748,7,28,21,14),(2749,7,28,22,14),(2750,7,28,23,14),(2751,7,28,24,14),(2752,4,28,41,14),(2753,4,28,42,14),(2754,4,28,43,14),(2755,3,28,44,14),(2756,3,28,45,14),(2757,3,28,46,14),(2758,4,28,3,15),(2759,1,28,11,15),(2760,5,28,13,15),(2761,5,28,14,15),(2762,5,28,15,15),(2763,5,28,16,15),(2764,5,28,17,15),(2765,5,28,18,15),(2766,7,28,19,15),(2767,7,28,20,15),(2768,7,28,21,15),(2769,7,28,22,15),(2770,7,28,23,15),(2771,4,28,41,15),(2772,4,28,42,15),(2773,4,28,43,15),(2774,3,28,46,15),(2775,0,28,0,16),(2776,4,28,2,16),(2777,4,28,3,16),(2778,5,28,13,16),(2779,4,28,14,16),(2780,5,28,16,16),(2781,5,28,17,16),(2782,7,28,19,16),(2783,7,28,20,16),(2784,7,28,21,16),(2785,7,28,22,16),(2786,6,28,28,16),(2787,4,28,41,16),(2788,4,28,43,16),(2789,3,28,46,16),(2790,3,28,47,16),(2791,4,28,3,17),(2792,4,28,4,17),(2793,4,28,6,17),(2794,4,28,7,17),(2795,4,28,8,17),(2796,4,28,9,17),(2797,4,28,10,17),(2798,4,28,11,17),(2799,4,28,12,17),(2800,4,28,13,17),(2801,4,28,14,17),(2802,5,28,15,17),(2803,5,28,16,17),(2804,5,28,17,17),(2805,5,28,18,17),(2806,7,28,19,17),(2807,7,28,20,17),(2808,7,28,21,17),(2809,7,28,22,17),(2810,0,28,23,17),(2811,6,28,27,17),(2812,6,28,28,17),(2813,12,28,43,17),(2814,6,28,0,18),(2815,6,28,1,18),(2816,4,28,2,18),(2817,4,28,3,18),(2818,4,28,4,18),(2819,4,28,5,18),(2820,4,28,6,18),(2821,4,28,7,18),(2822,4,28,8,18),(2823,4,28,9,18),(2824,4,28,10,18),(2825,4,28,11,18),(2826,4,28,12,18),(2827,4,28,13,18),(2828,4,28,14,18),(2829,5,28,18,18),(2830,7,28,21,18),(2831,7,28,22,18),(2832,6,28,26,18),(2833,6,28,27,18),(2834,6,28,0,19),(2835,6,28,1,19),(2836,4,28,2,19),(2837,4,28,3,19),(2838,4,28,4,19),(2839,4,28,6,19),(2840,4,28,7,19),(2841,4,28,8,19),(2842,4,28,9,19),(2843,4,28,11,19),(2844,4,28,12,19),(2845,4,28,13,19),(2846,7,28,21,19),(2847,7,28,22,19),(2848,6,28,27,19),(2849,6,28,28,19),(2850,5,28,29,19),(2851,5,28,30,19),(2852,6,28,0,20),(2853,6,28,1,20),(2854,6,28,2,20),(2855,4,28,3,20),(2856,4,28,4,20),(2857,4,28,9,20),(2858,4,28,10,20),(2859,4,28,11,20),(2860,4,28,12,20),(2861,7,28,21,20),(2862,7,28,22,20),(2863,6,28,25,20),(2864,6,28,26,20),(2865,6,28,27,20),(2866,5,28,28,20),(2867,5,28,29,20),(2868,5,28,30,20),(2869,6,28,0,21),(2870,6,28,1,21),(2871,6,28,2,21),(2872,6,28,3,21),(2873,4,28,4,21),(2874,4,28,10,21),(2875,4,28,11,21),(2876,6,28,24,21),(2877,6,28,25,21),(2878,6,28,27,21),(2879,5,28,28,21),(2880,5,28,29,21),(2881,5,28,30,21),(2882,5,28,31,21),(2883,0,28,40,21),(2884,6,28,0,22),(2885,6,28,1,22),(2886,6,28,2,22),(2887,4,28,10,22),(2888,4,28,11,22),(2889,4,28,12,22),(2890,6,28,25,22),(2891,5,28,27,22),(2892,5,28,28,22),(2893,5,28,29,22),(2894,5,28,31,22),(2895,5,28,32,22),(2896,5,28,34,22),(2897,12,28,0,23),(2898,3,28,6,23),(2899,3,28,8,23),(2900,4,28,9,23),(2901,4,28,10,23),(2902,4,28,11,23),(2903,3,28,12,23),(2904,5,28,28,23),(2905,5,28,29,23),(2906,5,28,30,23),(2907,5,28,31,23),(2908,5,28,32,23),(2909,5,28,33,23),(2910,5,28,34,23),(2911,5,28,35,23),(2912,5,28,44,23),(2913,3,28,6,24),(2914,3,28,7,24),(2915,3,28,8,24),(2916,3,28,9,24),(2917,3,28,10,24),(2918,3,28,11,24),(2919,3,28,12,24),(2920,3,28,13,24),(2921,5,28,28,24),(2922,5,28,29,24),(2923,5,28,30,24),(2924,5,28,31,24),(2925,5,28,32,24),(2926,5,28,33,24),(2927,5,28,34,24),(2928,0,28,35,24),(2929,5,28,44,24),(2930,5,28,46,24),(2931,5,28,47,24),(2932,5,28,48,24),(2933,5,28,49,24),(2934,3,28,6,25),(2935,3,28,7,25),(2936,3,28,8,25),(2937,3,28,9,25),(2938,3,28,10,25),(2939,3,28,11,25),(2940,3,28,12,25),(2941,2,28,13,25),(2942,5,28,27,25),(2943,5,28,28,25),(2944,5,28,29,25),(2945,5,28,32,25),(2946,5,28,33,25),(2947,5,28,34,25),(2948,5,28,44,25),(2949,5,28,45,25),(2950,5,28,46,25),(2951,5,28,47,25),(2952,5,28,48,25),(2953,5,28,49,25),(2954,3,28,7,26),(2955,3,28,10,26),(2956,3,28,11,26),(2957,3,28,12,26),(2958,5,28,27,26),(2959,5,28,28,26),(2960,5,28,29,26),(2961,7,28,31,26),(2962,7,28,32,26),(2963,5,28,33,26),(2964,7,28,34,26),(2965,7,28,36,26),(2966,5,28,42,26),(2967,5,28,43,26),(2968,5,28,44,26),(2969,5,28,45,26),(2970,5,28,46,26),(2971,5,28,47,26),(2972,5,28,48,26),(2973,5,28,49,26),(2974,3,28,7,27),(2975,3,28,9,27),(2976,3,28,10,27),(2977,7,28,30,27),(2978,7,28,31,27),(2979,7,28,32,27),(2980,7,28,33,27),(2981,7,28,34,27),(2982,7,28,35,27),(2983,7,28,36,27),(2984,7,28,37,27),(2985,5,28,43,27),(2986,5,28,44,27),(2987,5,28,45,27),(2988,5,28,46,27),(2989,5,28,47,27),(2990,5,28,48,27),(2991,5,28,49,27),(2992,7,28,33,28),(2993,7,28,34,28),(2994,7,28,35,28),(2995,7,28,36,28),(2996,7,28,37,28),(2997,7,28,38,28),(2998,5,28,43,28),(2999,5,28,44,28),(3000,5,28,45,28),(3001,5,28,46,28),(3002,5,28,47,28),(3003,5,28,48,28),(3004,5,28,49,28),(3005,7,28,32,29),(3006,7,28,33,29),(3007,7,28,34,29),(3008,7,28,35,29),(3009,7,28,36,29),(3010,7,28,37,29),(3011,7,28,38,29),(3012,7,28,39,29),(3013,5,28,43,29),(3014,5,28,44,29),(3015,5,28,45,29),(3016,5,28,46,29),(3017,5,28,47,29),(3018,5,28,49,29),(3019,5,30,0,0),(3020,5,30,1,0),(3021,5,30,2,0),(3022,5,30,3,0),(3023,4,30,24,0),(3024,4,30,26,0),(3025,3,30,29,0),(3026,3,30,31,0),(3027,3,30,32,0),(3028,3,30,33,0),(3029,3,30,35,0),(3030,3,30,47,0),(3031,3,30,48,0),(3032,3,30,49,0),(3033,3,30,50,0),(3034,5,30,0,1),(3035,5,30,1,1),(3036,0,30,18,1),(3037,4,30,23,1),(3038,4,30,24,1),(3039,4,30,25,1),(3040,4,30,26,1),(3041,4,30,27,1),(3042,4,30,28,1),(3043,3,30,29,1),(3044,3,30,30,1),(3045,3,30,31,1),(3046,3,30,32,1),(3047,3,30,33,1),(3048,3,30,34,1),(3049,3,30,35,1),(3050,9,30,42,1),(3051,3,30,48,1),(3052,3,30,49,1),(3053,3,30,50,1),(3054,5,30,1,2),(3055,5,30,2,2),(3056,5,30,3,2),(3057,5,30,4,2),(3058,4,30,24,2),(3059,4,30,25,2),(3060,4,30,27,2),(3061,5,30,29,2),(3062,5,30,30,2),(3063,3,30,31,2),(3064,3,30,32,2),(3065,3,30,33,2),(3066,3,30,34,2),(3067,3,30,46,2),(3068,3,30,47,2),(3069,3,30,48,2),(3070,3,30,49,2),(3071,3,30,50,2),(3072,5,30,0,3),(3073,5,30,1,3),(3074,5,30,2,3),(3075,5,30,3,3),(3076,14,30,4,3),(3077,4,30,23,3),(3078,4,30,24,3),(3079,4,30,25,3),(3080,4,30,26,3),(3081,4,30,27,3),(3082,5,30,28,3),(3083,5,30,29,3),(3084,5,30,30,3),(3085,3,30,31,3),(3086,3,30,33,3),(3087,3,30,34,3),(3088,3,30,35,3),(3089,7,30,41,3),(3090,7,30,46,3),(3091,3,30,47,3),(3092,3,30,48,3),(3093,3,30,49,3),(3094,3,30,50,3),(3095,5,30,0,4),(3096,5,30,1,4),(3097,5,30,2,4),(3098,5,30,3,4),(3099,4,30,24,4),(3100,4,30,25,4),(3101,5,30,26,4),(3102,5,30,27,4),(3103,5,30,28,4),(3104,5,30,29,4),(3105,5,30,30,4),(3106,3,30,33,4),(3107,3,30,34,4),(3108,7,30,40,4),(3109,7,30,41,4),(3110,7,30,42,4),(3111,7,30,43,4),(3112,7,30,44,4),(3113,7,30,46,4),(3114,3,30,49,4),(3115,3,30,50,4),(3116,5,30,0,5),(3117,5,30,2,5),(3118,5,30,3,5),(3119,0,30,7,5),(3120,4,30,23,5),(3121,4,30,24,5),(3122,5,30,25,5),(3123,5,30,26,5),(3124,5,30,27,5),(3125,5,30,28,5),(3126,5,30,29,5),(3127,6,30,39,5),(3128,7,30,40,5),(3129,7,30,41,5),(3130,7,30,42,5),(3131,7,30,43,5),(3132,7,30,44,5),(3133,7,30,45,5),(3134,7,30,46,5),(3135,7,30,47,5),(3136,7,30,48,5),(3137,7,30,49,5),(3138,3,30,50,5),(3139,5,30,0,6),(3140,0,30,24,6),(3141,5,30,26,6),(3142,5,30,27,6),(3143,5,30,29,6),(3144,6,30,39,6),(3145,7,30,41,6),(3146,7,30,42,6),(3147,7,30,43,6),(3148,7,30,44,6),(3149,7,30,45,6),(3150,7,30,46,6),(3151,7,30,49,6),(3152,5,30,0,7),(3153,2,30,2,7),(3154,4,30,4,7),(3155,4,30,5,7),(3156,4,30,6,7),(3157,4,30,7,7),(3158,0,30,8,7),(3159,0,30,22,7),(3160,3,30,26,7),(3161,5,30,28,7),(3162,5,30,29,7),(3163,11,30,34,7),(3164,6,30,38,7),(3165,6,30,39,7),(3166,6,30,40,7),(3167,6,30,41,7),(3168,6,30,42,7),(3169,7,30,43,7),(3170,7,30,44,7),(3171,7,30,45,7),(3172,7,30,46,7),(3173,4,30,4,8),(3174,4,30,5,8),(3175,4,30,6,8),(3176,4,30,7,8),(3177,9,30,13,8),(3178,3,30,19,8),(3179,3,30,26,8),(3180,5,30,27,8),(3181,5,30,28,8),(3182,7,30,38,8),(3183,6,30,39,8),(3184,7,30,40,8),(3185,7,30,41,8),(3186,7,30,42,8),(3187,7,30,43,8),(3188,6,30,44,8),(3189,6,30,45,8),(3190,6,30,46,8),(3191,4,30,4,9),(3192,4,30,5,9),(3193,4,30,6,9),(3194,4,30,7,9),(3195,4,30,8,9),(3196,3,30,19,9),(3197,3,30,22,9),(3198,3,30,23,9),(3199,3,30,26,9),(3200,5,30,28,9),(3201,4,30,29,9),(3202,4,30,30,9),(3203,4,30,31,9),(3204,4,30,32,9),(3205,7,30,38,9),(3206,7,30,39,9),(3207,7,30,40,9),(3208,7,30,41,9),(3209,7,30,42,9),(3210,7,30,43,9),(3211,7,30,44,9),(3212,6,30,45,9),(3213,6,30,46,9),(3214,6,30,47,9),(3215,4,30,4,10),(3216,4,30,5,10),(3217,4,30,6,10),(3218,3,30,18,10),(3219,3,30,19,10),(3220,3,30,21,10),(3221,3,30,22,10),(3222,3,30,23,10),(3223,3,30,24,10),(3224,3,30,25,10),(3225,3,30,26,10),(3226,3,30,27,10),(3227,4,30,28,10),(3228,4,30,29,10),(3229,4,30,30,10),(3230,4,30,31,10),(3231,4,30,32,10),(3232,4,30,33,10),(3233,7,30,38,10),(3234,7,30,39,10),(3235,7,30,40,10),(3236,7,30,41,10),(3237,7,30,42,10),(3238,7,30,43,10),(3239,6,30,44,10),(3240,6,30,45,10),(3241,6,30,46,10),(3242,4,30,3,11),(3243,4,30,4,11),(3244,4,30,5,11),(3245,4,30,6,11),(3246,3,30,14,11),(3247,3,30,15,11),(3248,3,30,16,11),(3249,3,30,17,11),(3250,3,30,19,11),(3251,3,30,20,11),(3252,3,30,21,11),(3253,3,30,22,11),(3254,4,30,28,11),(3255,4,30,29,11),(3256,4,30,32,11),(3257,4,30,33,11),(3258,7,30,38,11),(3259,7,30,39,11),(3260,7,30,40,11),(3261,8,30,41,11),(3262,6,30,45,11),(3263,13,30,0,12),(3264,3,30,15,12),(3265,3,30,16,12),(3266,3,30,17,12),(3267,3,30,18,12),(3268,3,30,19,12),(3269,13,30,21,12),(3270,4,30,28,12),(3271,4,30,33,12),(3272,7,30,38,12),(3273,7,30,39,12),(3274,7,30,40,12),(3275,3,30,13,13),(3276,3,30,14,13),(3277,3,30,15,13),(3278,3,30,16,13),(3279,3,30,17,13),(3280,3,30,18,13),(3281,3,30,19,13),(3282,4,30,33,13),(3283,4,30,34,13),(3284,5,30,35,13),(3285,5,30,36,13),(3286,5,30,37,13),(3287,5,30,38,13),(3288,6,30,39,13),(3289,6,30,40,13),(3290,3,30,0,14),(3291,3,30,1,14),(3292,4,30,9,14),(3293,4,30,10,14),(3294,3,30,14,14),(3295,3,30,16,14),(3296,3,30,18,14),(3297,3,30,19,14),(3298,5,30,33,14),(3299,5,30,35,14),(3300,5,30,36,14),(3301,5,30,37,14),(3302,5,30,38,14),(3303,6,30,40,14),(3304,3,30,0,15),(3305,12,30,3,15),(3306,4,30,9,15),(3307,4,30,10,15),(3308,4,30,11,15),(3309,3,30,16,15),(3310,3,30,17,15),(3311,3,30,18,15),(3312,3,30,19,15),(3313,0,30,26,15),(3314,6,30,28,15),(3315,6,30,29,15),(3316,5,30,33,15),(3317,5,30,34,15),(3318,5,30,35,15),(3319,5,30,36,15),(3320,6,30,39,15),(3321,6,30,40,15),(3322,6,30,41,15),(3323,0,30,46,15),(3324,3,30,0,16),(3325,1,30,1,16),(3326,4,30,9,16),(3327,4,30,10,16),(3328,4,30,11,16),(3329,4,30,12,16),(3330,6,30,28,16),(3331,6,30,29,16),(3332,6,30,30,16),(3333,4,30,33,16),(3334,5,30,34,16),(3335,5,30,35,16),(3336,5,30,36,16),(3337,6,30,41,16),(3338,3,30,0,17),(3339,4,30,9,17),(3340,4,30,10,17),(3341,4,30,11,17),(3342,5,30,12,17),(3343,5,30,13,17),(3344,5,30,14,17),(3345,5,30,15,17),(3346,10,30,19,17),(3347,6,30,28,17),(3348,6,30,29,17),(3349,4,30,30,17),(3350,4,30,33,17),(3351,5,30,34,17),(3352,5,30,35,17),(3353,5,30,36,17),(3354,5,30,37,17),(3355,6,30,41,17),(3356,6,30,42,17),(3357,10,30,44,17),(3358,2,30,48,17),(3359,3,30,0,18),(3360,3,30,1,18),(3361,3,30,2,18),(3362,4,30,9,18),(3363,5,30,10,18),(3364,5,30,11,18),(3365,5,30,12,18),(3366,5,30,13,18),(3367,5,30,15,18),(3368,6,30,27,18),(3369,6,30,28,18),(3370,6,30,29,18),(3371,4,30,30,18),(3372,4,30,31,18),(3373,4,30,32,18),(3374,4,30,33,18),(3375,4,30,34,18),(3376,4,30,35,18),(3377,5,30,36,18),(3378,5,30,37,18),(3379,5,30,38,18),(3380,0,30,39,18),(3381,6,30,41,18),(3382,3,30,0,19),(3383,3,30,1,19),(3384,3,30,2,19),(3385,4,30,9,19),(3386,4,30,10,19),(3387,5,30,11,19),(3388,5,30,12,19),(3389,5,30,13,19),(3390,5,30,14,19),(3391,5,30,15,19),(3392,4,30,29,19),(3393,4,30,30,19),(3394,4,30,31,19),(3395,4,30,32,19),(3396,4,30,33,19),(3397,4,30,35,19),(3398,3,30,0,20),(3399,3,30,1,20),(3400,3,30,2,20),(3401,4,30,9,20),(3402,4,30,10,20),(3403,5,30,11,20),(3404,5,30,12,20),(3405,5,30,13,20),(3406,5,30,14,20),(3407,5,30,15,20),(3408,5,30,16,20),(3409,4,30,31,20),(3410,4,30,32,20),(3411,4,30,33,20),(3412,3,30,0,21),(3413,3,30,1,21),(3414,3,30,2,21),(3415,3,30,3,21),(3416,3,30,4,21),(3417,3,30,5,21),(3418,3,30,6,21),(3419,3,30,7,21),(3420,4,30,8,21),(3421,4,30,9,21),(3422,4,30,10,21),(3423,5,30,12,21),(3424,5,30,13,21),(3425,5,30,14,21),(3426,4,30,32,21),(3427,4,30,33,21),(3428,4,36,16,0),(3429,4,36,17,0),(3430,4,36,18,0),(3431,4,36,19,0),(3432,4,36,20,0),(3433,4,36,21,0),(3434,13,36,23,0),(3435,3,36,30,0),(3436,3,36,31,0),(3437,3,36,32,0),(3438,3,36,33,0),(3439,3,36,34,0),(3440,2,36,35,0),(3441,4,36,13,1),(3442,4,36,14,1),(3443,4,36,15,1),(3444,4,36,16,1),(3445,4,36,17,1),(3446,4,36,18,1),(3447,4,36,19,1),(3448,4,36,20,1),(3449,3,36,29,1),(3450,3,36,30,1),(3451,3,36,31,1),(3452,3,36,32,1),(3453,3,36,33,1),(3454,3,36,34,1),(3455,4,36,17,2),(3456,4,36,18,2),(3457,4,36,19,2),(3458,4,36,20,2),(3459,4,36,21,2),(3460,4,36,22,2),(3461,5,36,24,2),(3462,5,36,26,2),(3463,3,36,28,2),(3464,3,36,29,2),(3465,3,36,30,2),(3466,3,36,31,2),(3467,3,36,32,2),(3468,3,36,33,2),(3469,1,36,34,2),(3470,3,36,36,2),(3471,12,36,1,3),(3472,12,36,13,3),(3473,4,36,19,3),(3474,4,36,20,3),(3475,4,36,22,3),(3476,5,36,23,3),(3477,5,36,24,3),(3478,5,36,25,3),(3479,5,36,26,3),(3480,5,36,27,3),(3481,3,36,28,3),(3482,3,36,29,3),(3483,3,36,30,3),(3484,3,36,31,3),(3485,3,36,32,3),(3486,3,36,33,3),(3487,3,36,36,3),(3488,3,36,37,3),(3489,3,36,38,3),(3490,4,36,19,4),(3491,4,36,20,4),(3492,5,36,24,4),(3493,5,36,25,4),(3494,5,36,26,4),(3495,5,36,27,4),(3496,3,36,28,4),(3497,3,36,29,4),(3498,3,36,30,4),(3499,3,36,32,4),(3500,3,36,33,4),(3501,3,36,34,4),(3502,3,36,35,4),(3503,3,36,36,4),(3504,3,36,37,4),(3505,3,36,38,4),(3506,4,36,20,5),(3507,4,36,21,5),(3508,5,36,22,5),(3509,5,36,23,5),(3510,5,36,24,5),(3511,5,36,25,5),(3512,5,36,26,5),(3513,5,36,27,5),(3514,3,36,30,5),(3515,0,36,34,5),(3516,3,36,36,5),(3517,3,36,37,5),(3518,3,36,38,5),(3519,4,36,20,6),(3520,5,36,22,6),(3521,5,36,23,6),(3522,5,36,24,6),(3523,5,36,25,6),(3524,5,36,26,6),(3525,5,36,27,6),(3526,5,36,28,6),(3527,3,36,29,6),(3528,3,36,30,6),(3529,3,36,31,6),(3530,3,36,36,6),(3531,3,36,37,6),(3532,3,36,38,6),(3533,4,36,20,7),(3534,5,36,22,7),(3535,5,36,23,7),(3536,5,36,24,7),(3537,5,36,25,7),(3538,5,36,26,7),(3539,5,36,27,7),(3540,3,36,28,7),(3541,3,36,30,7),(3542,3,36,35,7),(3543,3,36,36,7),(3544,7,36,38,7),(3545,7,36,44,7),(3546,7,36,45,7),(3547,3,36,24,8),(3548,5,36,25,8),(3549,5,36,26,8),(3550,3,36,27,8),(3551,3,36,28,8),(3552,3,36,30,8),(3553,3,36,36,8),(3554,7,36,37,8),(3555,7,36,38,8),(3556,7,36,42,8),(3557,7,36,44,8),(3558,7,36,45,8),(3559,5,36,6,9),(3560,2,36,17,9),(3561,3,36,23,9),(3562,3,36,24,9),(3563,3,36,25,9),(3564,3,36,26,9),(3565,3,36,27,9),(3566,3,36,28,9),(3567,7,36,37,9),(3568,7,36,38,9),(3569,7,36,41,9),(3570,7,36,42,9),(3571,7,36,43,9),(3572,7,36,44,9),(3573,7,36,45,9),(3574,7,36,46,9),(3575,7,36,47,9),(3576,5,36,3,10),(3577,5,36,4,10),(3578,5,36,5,10),(3579,5,36,6,10),(3580,5,36,7,10),(3581,5,36,12,10),(3582,5,36,13,10),(3583,3,36,19,10),(3584,3,36,20,10),(3585,3,36,23,10),(3586,3,36,24,10),(3587,3,36,25,10),(3588,3,36,26,10),(3589,3,36,28,10),(3590,3,36,29,10),(3591,3,36,30,10),(3592,7,36,36,10),(3593,7,36,37,10),(3594,7,36,38,10),(3595,7,36,39,10),(3596,7,36,40,10),(3597,7,36,41,10),(3598,7,36,42,10),(3599,7,36,43,10),(3600,7,36,44,10),(3601,7,36,45,10),(3602,7,36,46,10),(3603,7,36,47,10),(3604,7,36,48,10),(3605,7,36,49,10),(3606,5,36,3,11),(3607,5,36,4,11),(3608,5,36,5,11),(3609,5,36,6,11),(3610,5,36,7,11),(3611,5,36,8,11),(3612,5,36,13,11),(3613,3,36,19,11),(3614,3,36,20,11),(3615,3,36,21,11),(3616,3,36,22,11),(3617,3,36,23,11),(3618,3,36,24,11),(3619,3,36,25,11),(3620,3,36,26,11),(3621,3,36,27,11),(3622,3,36,28,11),(3623,7,36,35,11),(3624,7,36,36,11),(3625,7,36,37,11),(3626,7,36,38,11),(3627,7,36,39,11),(3628,7,36,40,11),(3629,7,36,42,11),(3630,7,36,43,11),(3631,7,36,44,11),(3632,7,36,45,11),(3633,7,36,46,11),(3634,7,36,47,11),(3635,6,36,50,11),(3636,5,36,4,12),(3637,5,36,5,12),(3638,5,36,6,12),(3639,5,36,7,12),(3640,5,36,8,12),(3641,5,36,9,12),(3642,5,36,11,12),(3643,5,36,12,12),(3644,5,36,13,12),(3645,3,36,21,12),(3646,3,36,22,12),(3647,3,36,23,12),(3648,3,36,24,12),(3649,3,36,25,12),(3650,3,36,26,12),(3651,3,36,27,12),(3652,3,36,28,12),(3653,9,36,32,12),(3654,7,36,36,12),(3655,7,36,37,12),(3656,7,36,38,12),(3657,7,36,40,12),(3658,7,36,41,12),(3659,7,36,42,12),(3660,7,36,44,12),(3661,7,36,45,12),(3662,7,36,46,12),(3663,6,36,49,12),(3664,6,36,50,12),(3665,5,36,5,13),(3666,5,36,6,13),(3667,5,36,7,13),(3668,5,36,10,13),(3669,5,36,11,13),(3670,5,36,12,13),(3671,5,36,13,13),(3672,5,36,14,13),(3673,5,36,15,13),(3674,5,36,16,13),(3675,3,36,21,13),(3676,3,36,22,13),(3677,3,36,23,13),(3678,3,36,24,13),(3679,3,36,25,13),(3680,3,36,26,13),(3681,3,36,27,13),(3682,7,36,36,13),(3683,7,36,45,13),(3684,6,36,48,13),(3685,6,36,49,13),(3686,6,36,50,13),(3687,5,36,7,14),(3688,5,36,8,14),(3689,5,36,9,14),(3690,5,36,10,14),(3691,5,36,11,14),(3692,5,36,12,14),(3693,5,36,13,14),(3694,5,36,14,14),(3695,14,36,15,14),(3696,3,36,20,14),(3697,3,36,21,14),(3698,8,36,22,14),(3699,3,36,25,14),(3700,7,36,45,14),(3701,7,36,46,14),(3702,6,36,49,14),(3703,6,36,50,14),(3704,5,36,7,15),(3705,5,36,8,15),(3706,5,36,9,15),(3707,5,36,10,15),(3708,5,36,11,15),(3709,5,36,12,15),(3710,5,36,13,15),(3711,5,36,14,15),(3712,3,36,20,15),(3713,3,36,21,15),(3714,3,36,25,15),(3715,6,36,48,15),(3716,6,36,49,15),(3717,6,36,50,15),(3718,3,36,3,16),(3719,5,36,5,16),(3720,5,36,6,16),(3721,5,36,7,16),(3722,5,36,11,16),(3723,5,36,12,16),(3724,5,36,13,16),(3725,5,36,14,16),(3726,3,36,21,16),(3727,6,36,48,16),(3728,6,36,50,16),(3729,3,36,1,17),(3730,3,36,2,17),(3731,3,36,3,17),(3732,5,36,6,17),(3733,5,36,7,17),(3734,5,36,10,17),(3735,5,36,11,17),(3736,5,36,12,17),(3737,5,36,13,17),(3738,5,36,14,17),(3739,0,36,22,17),(3740,10,36,38,17),(3741,3,36,0,18),(3742,3,36,3,18),(3743,3,36,4,18),(3744,3,36,5,18),(3745,3,36,6,18),(3746,3,36,7,18),(3747,3,36,0,19),(3748,0,36,1,19),(3749,3,36,3,19),(3750,3,36,4,19),(3751,3,36,5,19),(3752,3,36,6,19),(3753,3,36,7,19),(3754,3,36,8,19),(3755,4,36,31,19),(3756,0,36,32,19),(3757,3,36,0,20),(3758,3,36,3,20),(3759,3,36,4,20),(3760,3,36,5,20),(3761,3,36,6,20),(3762,3,36,7,20),(3763,3,36,8,20),(3764,4,36,31,20),(3765,4,36,45,20),(3766,3,36,0,21),(3767,3,36,1,21),(3768,3,36,2,21),(3769,3,36,3,21),(3770,3,36,4,21),(3771,3,36,5,21),(3772,3,36,6,21),(3773,3,36,7,21),(3774,4,36,22,21),(3775,4,36,23,21),(3776,4,36,24,21),(3777,4,36,25,21),(3778,6,36,26,21),(3779,4,36,28,21),(3780,4,36,29,21),(3781,4,36,30,21),(3782,4,36,31,21),(3783,4,36,32,21),(3784,4,36,33,21),(3785,6,36,39,21),(3786,6,36,40,21),(3787,6,36,41,21),(3788,4,36,45,21),(3789,4,36,46,21),(3790,4,36,47,21),(3791,3,36,0,22),(3792,3,36,1,22),(3793,3,36,2,22),(3794,3,36,3,22),(3795,4,36,4,22),(3796,3,36,5,22),(3797,3,36,6,22),(3798,3,36,7,22),(3799,4,36,21,22),(3800,4,36,22,22),(3801,4,36,23,22),(3802,4,36,24,22),(3803,6,36,25,22),(3804,6,36,26,22),(3805,4,36,27,22),(3806,4,36,28,22),(3807,4,36,29,22),(3808,4,36,30,22),(3809,4,36,31,22),(3810,4,36,34,22),(3811,4,36,35,22),(3812,6,36,39,22),(3813,6,36,40,22),(3814,6,36,41,22),(3815,6,36,42,22),(3816,4,36,47,22),(3817,4,36,49,22),(3818,4,36,50,22),(3819,3,36,0,23),(3820,3,36,1,23),(3821,3,36,2,23),(3822,3,36,3,23),(3823,4,36,4,23),(3824,4,36,5,23),(3825,3,36,6,23),(3826,3,36,7,23),(3827,3,36,8,23),(3828,4,36,19,23),(3829,4,36,20,23),(3830,4,36,21,23),(3831,4,36,23,23),(3832,4,36,24,23),(3833,4,36,25,23),(3834,6,36,26,23),(3835,4,36,27,23),(3836,4,36,29,23),(3837,4,36,31,23),(3838,4,36,32,23),(3839,4,36,35,23),(3840,6,36,39,23),(3841,6,36,40,23),(3842,6,36,42,23),(3843,4,36,47,23),(3844,4,36,48,23),(3845,4,36,49,23),(3846,4,36,50,23),(3847,3,36,0,24),(3848,3,36,1,24),(3849,4,36,2,24),(3850,3,36,3,24),(3851,4,36,4,24),(3852,3,36,5,24),(3853,3,36,6,24),(3854,4,36,18,24),(3855,4,36,19,24),(3856,4,36,20,24),(3857,4,36,21,24),(3858,4,36,22,24),(3859,4,36,23,24),(3860,4,36,24,24),(3861,6,36,25,24),(3862,6,36,26,24),(3863,6,36,27,24),(3864,4,36,28,24),(3865,4,36,29,24),(3866,4,36,31,24),(3867,4,36,32,24),(3868,4,36,33,24),(3869,4,36,34,24),(3870,4,36,35,24),(3871,6,36,38,24),(3872,6,36,39,24),(3873,6,36,40,24),(3874,4,36,47,24),(3875,4,36,48,24),(3876,4,36,49,24),(3877,4,36,50,24),(3878,3,36,0,25),(3879,4,36,1,25),(3880,4,36,2,25),(3881,4,36,3,25),(3882,4,36,4,25),(3883,6,36,9,25),(3884,14,36,15,25),(3885,4,36,21,25),(3886,4,36,22,25),(3887,4,36,23,25),(3888,4,36,24,25),(3889,6,36,25,25),(3890,6,36,26,25),(3891,6,36,27,25),(3892,6,36,28,25),(3893,11,36,29,25),(3894,4,36,33,25),(3895,4,36,35,25),(3896,4,36,48,25),(3897,4,36,49,25),(3898,4,36,50,25),(3899,4,36,0,26),(3900,4,36,1,26),(3901,4,36,2,26),(3902,4,36,3,26),(3903,4,36,4,26),(3904,5,36,6,26),(3905,5,36,7,26),(3906,6,36,8,26),(3907,6,36,9,26),(3908,6,36,10,26),(3909,6,36,11,26),(3910,6,36,12,26),(3911,6,36,13,26),(3912,6,36,14,26),(3913,4,36,22,26),(3914,4,36,23,26),(3915,6,36,26,26),(3916,4,36,46,26),(3917,4,36,47,26),(3918,4,36,48,26),(3919,4,36,49,26),(3920,4,36,50,26),(3921,4,36,0,27),(3922,4,36,1,27),(3923,4,36,3,27),(3924,4,36,4,27),(3925,5,36,5,27),(3926,5,36,6,27),(3927,5,36,7,27),(3928,5,36,8,27),(3929,5,36,9,27),(3930,6,36,10,27),(3931,6,36,12,27),(3932,6,36,13,27),(3933,0,36,19,27),(3934,4,36,22,27),(3935,4,36,23,27),(3936,6,36,26,27),(3937,5,36,46,27),(3938,4,36,47,27),(3939,5,36,48,27),(3940,4,36,49,27),(3941,4,36,50,27),(3942,4,36,1,28),(3943,4,36,3,28),(3944,4,36,4,28),(3945,4,36,5,28),(3946,5,36,6,28),(3947,5,36,9,28),(3948,6,36,13,28),(3949,8,36,34,28),(3950,5,36,43,28),(3951,5,36,44,28),(3952,5,36,45,28),(3953,5,36,46,28),(3954,5,36,47,28),(3955,5,36,48,28),(3956,4,36,49,28),(3957,4,36,50,28),(3958,4,36,2,29),(3959,4,36,3,29),(3960,4,36,5,29),(3961,5,36,6,29),(3962,5,36,8,29),(3963,5,36,9,29),(3964,5,36,10,29),(3965,5,36,44,29),(3966,5,36,45,29),(3967,5,36,46,29),(3968,5,36,47,29),(3969,5,36,48,29),(3970,5,36,49,29),(3971,4,36,50,29),(3972,5,36,2,30),(3973,5,36,3,30),(3974,5,36,4,30),(3975,5,36,5,30),(3976,5,36,6,30),(3977,5,36,7,30),(3978,5,36,8,30),(3979,5,36,9,30),(3980,5,36,10,30),(3981,5,36,11,30),(3982,5,36,12,30),(3983,5,36,41,30),(3984,5,36,42,30),(3985,5,36,43,30),(3986,5,36,44,30),(3987,5,36,45,30),(3988,5,36,46,30),(3989,5,36,47,30),(3990,5,36,48,30),(3991,5,36,49,30),(3992,5,36,50,30),(3993,5,36,4,31),(3994,5,36,5,31),(3995,5,36,7,31),(3996,5,36,8,31),(3997,5,36,9,31),(3998,5,36,10,31),(3999,5,36,11,31),(4000,5,36,12,31),(4001,5,36,41,31),(4002,5,36,42,31),(4003,5,36,45,31),(4004,5,36,46,31),(4005,5,36,47,31),(4006,5,36,48,31),(4007,5,36,49,31),(4008,5,36,50,31),(4009,5,33,0,0),(4010,5,33,1,0),(4011,5,33,2,0),(4012,5,33,3,0),(4013,5,33,16,0),(4014,5,33,17,0),(4015,5,33,18,0),(4016,5,33,19,0),(4017,5,33,20,0),(4018,5,33,21,0),(4019,5,33,22,0),(4020,5,33,23,0),(4021,5,33,24,0),(4022,5,33,25,0),(4023,5,33,26,0),(4024,5,33,0,1),(4025,5,33,1,1),(4026,5,33,2,1),(4027,5,33,3,1),(4028,5,33,4,1),(4029,12,33,7,1),(4030,5,33,17,1),(4031,5,33,18,1),(4032,5,33,20,1),(4033,14,33,22,1),(4034,5,33,26,1),(4035,5,33,28,1),(4036,5,33,0,2),(4037,5,33,1,2),(4038,5,33,2,2),(4039,5,33,4,2),(4040,5,33,5,2),(4041,5,33,25,2),(4042,5,33,26,2),(4043,5,33,28,2),(4044,5,33,29,2),(4045,5,33,0,3),(4046,5,33,1,3),(4047,5,33,4,3),(4048,5,33,5,3),(4049,5,33,28,3),(4050,6,33,29,3),(4051,5,33,28,4),(4052,6,33,29,4),(4053,4,33,3,5),(4054,4,33,5,5),(4055,0,33,18,5),(4056,6,33,27,5),(4057,6,33,28,5),(4058,6,33,29,5),(4059,4,33,2,6),(4060,4,33,3,6),(4061,4,33,4,6),(4062,4,33,5,6),(4063,6,33,26,6),(4064,6,33,27,6),(4065,6,33,28,6),(4066,6,33,29,6),(4067,4,33,1,7),(4068,4,33,2,7),(4069,4,33,3,7),(4070,4,33,4,7),(4071,4,33,5,7),(4072,6,33,26,7),(4073,5,33,27,7),(4074,5,33,28,7),(4075,5,33,29,7),(4076,4,33,1,8),(4077,4,33,2,8),(4078,4,33,3,8),(4079,4,33,4,8),(4080,0,33,10,8),(4081,5,33,27,8),(4082,5,33,28,8),(4083,5,33,29,8),(4084,4,33,1,9),(4085,4,33,2,9),(4086,4,33,3,9),(4087,5,33,29,9),(4088,4,33,1,10),(4089,6,33,5,10),(4090,6,33,6,10),(4091,5,33,28,10),(4092,5,33,29,10),(4093,6,33,4,11),(4094,6,33,5,11),(4095,6,33,6,11),(4096,6,33,7,11),(4097,6,33,8,11),(4098,5,33,27,11),(4099,5,33,28,11),(4100,5,33,29,11),(4101,13,33,1,12),(4102,6,33,8,12),(4103,6,33,9,12),(4104,6,33,10,12),(4105,5,33,27,12),(4106,5,33,28,12),(4107,5,33,29,12),(4108,6,33,8,13),(4109,6,33,9,13),(4110,6,33,10,13),(4111,5,33,28,13),(4112,5,33,29,13),(4113,5,33,2,14),(4114,6,33,9,14),(4115,5,33,28,14),(4116,5,33,0,15),(4117,5,33,2,15),(4118,5,33,3,15),(4119,5,33,0,16),(4120,5,33,1,16),(4121,5,33,2,16),(4122,5,33,3,16),(4123,5,33,4,16),(4124,2,33,26,16),(4125,5,33,0,17),(4126,5,33,1,17),(4127,5,33,2,17),(4128,5,33,3,17),(4129,5,33,4,17),(4130,5,33,0,18),(4131,5,33,1,18),(4132,5,33,3,18),(4133,6,33,6,18),(4134,4,33,24,18),(4135,4,33,29,18),(4136,5,33,0,19),(4137,5,33,2,19),(4138,5,33,3,19),(4139,6,33,7,19),(4140,6,33,8,19),(4141,4,33,24,19),(4142,4,33,25,19),(4143,4,33,26,19),(4144,4,33,27,19),(4145,4,33,28,19),(4146,4,33,29,19),(4147,5,33,0,20),(4148,11,33,1,20),(4149,6,33,5,20),(4150,6,33,6,20),(4151,6,33,7,20),(4152,6,33,8,20),(4153,6,33,9,20),(4154,4,33,23,20),(4155,4,33,24,20),(4156,4,33,25,20),(4157,4,33,26,20),(4158,4,33,27,20),(4159,4,33,28,20),(4160,4,33,29,20),(4161,5,33,0,21),(4162,6,33,5,21),(4163,6,33,6,21),(4164,4,33,24,21),(4165,4,33,25,21),(4166,4,33,26,21),(4167,4,33,27,21),(4168,4,33,28,21),(4169,4,33,29,21),(4170,5,33,0,22),(4171,6,33,6,22),(4172,8,33,10,22),(4173,4,33,24,22),(4174,4,33,25,22),(4175,4,33,26,22),(4176,4,33,27,22),(4177,4,33,28,22),(4178,4,33,29,22),(4179,5,33,0,23),(4180,4,33,26,23),(4181,4,33,27,23),(4182,4,33,28,23),(4183,5,33,0,24),(4184,3,33,18,24),(4185,3,33,19,24),(4186,3,33,20,24),(4187,0,33,24,24),(4188,4,33,27,24),(4189,0,33,28,24),(4190,5,33,0,25),(4191,3,33,9,25),(4192,3,33,10,25),(4193,3,33,13,25),(4194,3,33,14,25),(4195,3,33,15,25),(4196,3,33,17,25),(4197,3,33,18,25),(4198,3,33,19,25),(4199,3,33,20,25),(4200,3,33,21,25),(4201,5,33,0,26),(4202,5,33,1,26),(4203,5,33,2,26),(4204,3,33,9,26),(4205,3,33,10,26),(4206,3,33,11,26),(4207,3,33,14,26),(4208,3,33,15,26),(4209,3,33,16,26),(4210,3,33,17,26),(4211,3,33,18,26),(4212,3,33,19,26),(4213,3,33,20,26),(4214,3,33,21,26),(4215,3,33,23,26),(4216,5,33,2,27),(4217,0,33,3,27),(4218,3,33,10,27),(4219,3,33,11,27),(4220,3,33,12,27),(4221,3,33,13,27),(4222,3,33,14,27),(4223,3,33,15,27),(4224,3,33,16,27),(4225,3,33,17,27),(4226,3,33,18,27),(4227,3,33,19,27),(4228,3,33,20,27),(4229,3,33,21,27),(4230,3,33,22,27),(4231,3,33,23,27),(4232,3,33,24,27),(4233,0,33,0,28),(4234,3,33,11,28),(4235,3,33,12,28),(4236,3,33,13,28),(4237,3,33,14,28),(4238,3,33,15,28),(4239,3,33,16,28),(4240,3,33,17,28),(4241,3,33,18,28),(4242,3,33,19,28),(4243,3,33,20,28),(4244,3,33,21,28),(4245,3,33,22,28),(4246,3,33,23,28),(4247,3,33,24,28),(4248,3,33,10,29),(4249,3,33,11,29),(4250,3,33,12,29),(4251,3,33,13,29),(4252,3,33,14,29),(4253,3,33,15,29),(4254,3,33,16,29),(4255,3,33,17,29),(4256,3,33,18,29),(4257,3,33,19,29),(4258,3,33,20,29),(4259,3,33,21,29),(4260,3,33,22,29),(4261,3,33,23,29);
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
) ENGINE=InnoDB AUTO_INCREMENT=137 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `units`
--

LOCK TABLES `units` WRITE;
/*!40000 ALTER TABLE `units` DISABLE KEYS */;
INSERT INTO `units` VALUES (1,100,1,33,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,18,28,NULL,1,0,0,0),(2,100,1,33,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,18,28,NULL,1,0,0,0),(3,100,1,33,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,18,28,NULL,1,0,0,0),(4,100,1,33,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,18,28,NULL,1,0,0,0),(5,100,1,33,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,18,28,NULL,1,0,0,0),(6,200,1,33,4,NULL,NULL,NULL,NULL,0,0,'Glancer',0,18,28,NULL,1,0,0,0),(7,200,1,33,4,NULL,NULL,NULL,NULL,0,0,'Glancer',0,18,28,NULL,1,0,0,0),(8,200,1,33,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,18,28,NULL,1,0,0,0),(9,200,1,33,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,18,28,NULL,1,0,0,0),(10,100,1,33,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,18,28,NULL,1,0,0,0),(11,100,1,33,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,18,28,NULL,1,0,0,0),(12,100,1,33,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,18,28,NULL,1,0,0,0),(13,100,1,33,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,26,16,NULL,1,0,0,0),(14,100,1,33,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,26,16,NULL,1,0,0,0),(15,100,1,33,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,26,16,NULL,1,0,0,0),(16,100,1,33,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,26,16,NULL,1,0,0,0),(17,100,1,33,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,26,16,NULL,1,0,0,0),(18,200,1,33,4,NULL,NULL,NULL,NULL,0,0,'Glancer',0,26,16,NULL,1,0,0,0),(19,200,1,33,4,NULL,NULL,NULL,NULL,0,0,'Glancer',0,26,16,NULL,1,0,0,0),(20,200,1,33,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,26,16,NULL,1,0,0,0),(21,200,1,33,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,26,16,NULL,1,0,0,0),(22,100,1,33,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,26,16,NULL,1,0,0,0),(23,100,1,33,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,26,16,NULL,1,0,0,0),(24,100,1,33,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,26,16,NULL,1,0,0,0),(25,100,1,33,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,3,27,NULL,1,0,0,0),(26,100,1,33,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,3,27,NULL,1,0,0,0),(27,100,1,33,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,3,27,NULL,1,0,0,0),(28,100,1,33,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,3,27,NULL,1,0,0,0),(29,100,1,33,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,3,27,NULL,1,0,0,0),(30,200,1,33,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,3,27,NULL,1,0,0,0),(31,200,1,33,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,3,27,NULL,1,0,0,0),(32,100,1,33,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,28,24,NULL,1,0,0,0),(33,100,1,33,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,28,24,NULL,1,0,0,0),(34,100,1,33,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,28,24,NULL,1,0,0,0),(35,100,1,33,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,28,24,NULL,1,0,0,0),(36,100,1,33,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,28,24,NULL,1,0,0,0),(37,200,1,33,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,28,24,NULL,1,0,0,0),(38,200,1,33,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,28,24,NULL,1,0,0,0),(39,100,1,33,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,18,25,NULL,1,0,0,0),(40,100,1,33,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,18,25,NULL,1,0,0,0),(41,100,1,33,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,18,25,NULL,1,0,0,0),(42,100,1,33,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,18,25,NULL,1,0,0,0),(43,100,1,33,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,18,25,NULL,1,0,0,0),(44,200,1,33,4,NULL,NULL,NULL,NULL,0,0,'Glancer',0,18,25,NULL,1,0,0,0),(45,200,1,33,4,NULL,NULL,NULL,NULL,0,0,'Glancer',0,18,25,NULL,1,0,0,0),(46,200,1,33,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,18,25,NULL,1,0,0,0),(47,200,1,33,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,18,25,NULL,1,0,0,0),(48,100,1,33,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,18,25,NULL,1,0,0,0),(49,100,1,33,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,18,25,NULL,1,0,0,0),(50,100,1,33,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,18,25,NULL,1,0,0,0),(51,100,1,33,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,15,26,NULL,1,0,0,0),(52,100,1,33,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,15,26,NULL,1,0,0,0),(53,100,1,33,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,15,26,NULL,1,0,0,0),(54,100,1,33,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,15,26,NULL,1,0,0,0),(55,100,1,33,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,15,26,NULL,1,0,0,0),(56,200,1,33,4,NULL,NULL,NULL,NULL,0,0,'Glancer',0,15,26,NULL,1,0,0,0),(57,200,1,33,4,NULL,NULL,NULL,NULL,0,0,'Glancer',0,15,26,NULL,1,0,0,0),(58,200,1,33,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,15,26,NULL,1,0,0,0),(59,200,1,33,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,15,26,NULL,1,0,0,0),(60,100,1,33,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,15,26,NULL,1,0,0,0),(61,100,1,33,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,15,26,NULL,1,0,0,0),(62,100,1,33,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,15,26,NULL,1,0,0,0),(63,100,1,33,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,7,28,NULL,1,0,0,0),(64,100,1,33,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,7,28,NULL,1,0,0,0),(65,100,1,33,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,7,28,NULL,1,0,0,0),(66,100,1,33,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,7,28,NULL,1,0,0,0),(67,100,1,33,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,7,28,NULL,1,0,0,0),(68,200,1,33,4,NULL,NULL,NULL,NULL,0,0,'Glancer',0,7,28,NULL,1,0,0,0),(69,200,1,33,4,NULL,NULL,NULL,NULL,0,0,'Glancer',0,7,28,NULL,1,0,0,0),(70,200,1,33,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,7,28,NULL,1,0,0,0),(71,200,1,33,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,7,28,NULL,1,0,0,0),(72,100,1,33,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,7,28,NULL,1,0,0,0),(73,100,1,33,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,7,28,NULL,1,0,0,0),(74,100,1,33,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,7,28,NULL,1,0,0,0),(75,100,1,33,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,24,24,NULL,1,0,0,0),(76,100,1,33,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,24,24,NULL,1,0,0,0),(77,100,1,33,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,24,24,NULL,1,0,0,0),(78,100,1,33,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,24,24,NULL,1,0,0,0),(79,100,1,33,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,24,24,NULL,1,0,0,0),(80,200,1,33,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,24,24,NULL,1,0,0,0),(81,200,1,33,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,24,24,NULL,1,0,0,0),(82,100,1,33,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,0,28,NULL,1,0,0,0),(83,100,1,33,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,0,28,NULL,1,0,0,0),(84,100,1,33,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,0,28,NULL,1,0,0,0),(85,100,1,33,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,0,28,NULL,1,0,0,0),(86,100,1,33,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,0,28,NULL,1,0,0,0),(87,200,1,33,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,0,28,NULL,1,0,0,0),(88,200,1,33,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,0,28,NULL,1,0,0,0),(89,100,1,33,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,22,27,NULL,1,0,0,0),(90,100,1,33,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,22,27,NULL,1,0,0,0),(91,100,1,33,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,22,27,NULL,1,0,0,0),(92,100,1,33,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,22,27,NULL,1,0,0,0),(93,100,1,33,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,22,27,NULL,1,0,0,0),(94,200,1,33,4,NULL,NULL,NULL,NULL,0,0,'Glancer',0,22,27,NULL,1,0,0,0),(95,200,1,33,4,NULL,NULL,NULL,NULL,0,0,'Glancer',0,22,27,NULL,1,0,0,0),(96,200,1,33,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,22,27,NULL,1,0,0,0),(97,200,1,33,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,22,27,NULL,1,0,0,0),(98,100,1,33,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,22,27,NULL,1,0,0,0),(99,100,1,33,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,22,27,NULL,1,0,0,0),(100,100,1,33,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,22,27,NULL,1,0,0,0),(101,100,1,33,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,25,20,NULL,1,0,0,0),(102,100,1,33,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,25,20,NULL,1,0,0,0),(103,100,1,33,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,25,20,NULL,1,0,0,0),(104,100,1,33,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,25,20,NULL,1,0,0,0),(105,100,1,33,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,25,20,NULL,1,0,0,0),(106,200,1,33,4,NULL,NULL,NULL,NULL,0,0,'Glancer',0,25,20,NULL,1,0,0,0),(107,200,1,33,4,NULL,NULL,NULL,NULL,0,0,'Glancer',0,25,20,NULL,1,0,0,0),(108,200,1,33,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,25,20,NULL,1,0,0,0),(109,200,1,33,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,25,20,NULL,1,0,0,0),(110,100,1,33,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,25,20,NULL,1,0,0,0),(111,100,1,33,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,25,20,NULL,1,0,0,0),(112,100,1,33,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,25,20,NULL,1,0,0,0),(113,100,1,33,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,12,27,NULL,1,0,0,0),(114,100,1,33,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,12,27,NULL,1,0,0,0),(115,100,1,33,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,12,27,NULL,1,0,0,0),(116,100,1,33,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,12,27,NULL,1,0,0,0),(117,100,1,33,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,12,27,NULL,1,0,0,0),(118,200,1,33,4,NULL,NULL,NULL,NULL,0,0,'Glancer',0,12,27,NULL,1,0,0,0),(119,200,1,33,4,NULL,NULL,NULL,NULL,0,0,'Glancer',0,12,27,NULL,1,0,0,0),(120,200,1,33,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,12,27,NULL,1,0,0,0),(121,200,1,33,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,12,27,NULL,1,0,0,0),(122,100,1,33,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,12,27,NULL,1,0,0,0),(123,100,1,33,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,12,27,NULL,1,0,0,0),(124,100,1,33,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,12,27,NULL,1,0,0,0),(125,100,1,33,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,26,27,NULL,1,0,0,0),(126,100,1,33,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,26,27,NULL,1,0,0,0),(127,100,1,33,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,26,27,NULL,1,0,0,0),(128,100,1,33,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,26,27,NULL,1,0,0,0),(129,100,1,33,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,26,27,NULL,1,0,0,0),(130,200,1,33,4,NULL,NULL,NULL,NULL,0,0,'Glancer',0,26,27,NULL,1,0,0,0),(131,200,1,33,4,NULL,NULL,NULL,NULL,0,0,'Glancer',0,26,27,NULL,1,0,0,0),(132,200,1,33,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,26,27,NULL,1,0,0,0),(133,200,1,33,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,26,27,NULL,1,0,0,0),(134,100,1,33,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,26,27,NULL,1,0,0,0),(135,100,1,33,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,26,27,NULL,1,0,0,0),(136,100,1,33,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,26,27,NULL,1,0,0,0);
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

-- Dump completed on 2010-10-11 10:29:14
