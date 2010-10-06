-- MySQL dump 10.11
--
-- Host: localhost    Database: spacegame
-- ------------------------------------------------------
-- Server version	5.0.91-community-nt

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
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(255) NOT NULL,
  `galaxy_id` int(11) NOT NULL,
  PRIMARY KEY  (`id`),
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
  `id` int(11) NOT NULL auto_increment,
  `planet_id` int(11) default NULL,
  `x` tinyint(2) unsigned NOT NULL,
  `y` tinyint(2) unsigned NOT NULL,
  `armor_mod` int(11) NOT NULL,
  `constructor_mod` int(11) NOT NULL,
  `energy_mod` int(11) NOT NULL,
  `level` tinyint(2) unsigned NOT NULL default '0',
  `type` varchar(255) NOT NULL,
  `upgrade_ends_at` datetime default NULL,
  `x_end` tinyint(2) unsigned NOT NULL,
  `y_end` tinyint(2) unsigned NOT NULL,
  `last_update` datetime default NULL,
  `state` tinyint(2) NOT NULL default '0',
  `hp` int(10) unsigned NOT NULL,
  `pause_remainder` int(10) unsigned default NULL,
  `hp_remainder` int(10) unsigned NOT NULL default '0',
  `constructable_type` varchar(100) default NULL,
  `constructable_id` int(11) default NULL,
  `construction_mod` tinyint(2) unsigned NOT NULL default '0',
  PRIMARY KEY  (`id`),
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
INSERT INTO `buildings` VALUES (1,4,7,16,0,0,0,1,'Thunder',NULL,8,17,NULL,1,300,NULL,0,NULL,NULL,0),(2,4,21,16,0,0,0,1,'Thunder',NULL,22,17,NULL,1,300,NULL,0,NULL,NULL,0),(3,4,21,9,0,0,0,1,'Screamer',NULL,22,10,NULL,1,300,NULL,0,NULL,NULL,0),(4,4,18,28,0,0,0,1,'NpcSolarPlant',NULL,19,29,NULL,0,1000,NULL,0,NULL,NULL,0),(5,4,7,9,0,0,0,1,'Vulcan',NULL,8,10,NULL,1,300,NULL,0,NULL,NULL,0),(6,4,14,22,0,0,0,1,'Thunder',NULL,15,23,NULL,1,300,NULL,0,NULL,NULL,0),(7,4,26,16,0,0,0,1,'NpcZetiumExtractor',NULL,27,17,NULL,0,800,NULL,0,NULL,NULL,0),(8,4,3,27,0,0,0,1,'NpcMetalExtractor',NULL,4,28,NULL,0,400,NULL,0,NULL,NULL,0),(9,4,28,24,0,0,0,1,'NpcMetalExtractor',NULL,29,25,NULL,0,400,NULL,0,NULL,NULL,0),(10,4,18,25,0,0,0,1,'NpcSolarPlant',NULL,19,26,NULL,0,1000,NULL,0,NULL,NULL,0),(11,4,15,26,0,0,0,1,'NpcSolarPlant',NULL,16,27,NULL,0,1000,NULL,0,NULL,NULL,0),(12,4,7,28,0,0,0,1,'NpcCommunicationsHub',NULL,9,29,NULL,0,1200,NULL,0,NULL,NULL,0),(13,4,21,22,0,0,0,1,'Vulcan',NULL,22,23,NULL,1,300,NULL,0,NULL,NULL,0),(14,4,24,24,0,0,0,1,'NpcMetalExtractor',NULL,25,25,NULL,0,400,NULL,0,NULL,NULL,0),(15,4,0,28,0,0,0,1,'NpcMetalExtractor',NULL,1,29,NULL,0,400,NULL,0,NULL,NULL,0),(16,4,11,14,0,0,0,1,'Mothership',NULL,18,19,NULL,1,10500,NULL,0,NULL,NULL,0),(17,4,22,27,0,0,0,1,'NpcSolarPlant',NULL,23,28,NULL,0,1000,NULL,0,NULL,NULL,0),(18,4,14,9,0,0,0,1,'Thunder',NULL,15,10,NULL,1,300,NULL,0,NULL,NULL,0),(19,4,25,20,0,0,0,1,'NpcTemple',NULL,27,22,NULL,0,1500,NULL,0,NULL,NULL,0),(20,4,12,27,0,0,0,1,'NpcSolarPlant',NULL,13,28,NULL,0,1000,NULL,0,NULL,NULL,0),(21,4,7,22,0,0,0,1,'Screamer',NULL,8,23,NULL,1,300,NULL,0,NULL,NULL,0),(22,4,26,27,0,0,0,1,'NpcCommunicationsHub',NULL,28,28,NULL,0,1200,NULL,0,NULL,NULL,0);
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
  `event` tinyint(2) unsigned NOT NULL default '0',
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
  PRIMARY KEY  (`sha1_id`),
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
  `id` int(11) NOT NULL auto_increment,
  `constructable_type` varchar(100) NOT NULL,
  `constructor_id` int(11) NOT NULL,
  `count` int(11) NOT NULL,
  `position` smallint(2) unsigned NOT NULL default '0',
  `params` text,
  PRIMARY KEY  (`id`),
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
  `id` int(11) NOT NULL auto_increment,
  `location_id` int(10) unsigned NOT NULL,
  `location_type` tinyint(2) unsigned NOT NULL,
  `location_x` int(11) default NULL,
  `location_y` int(11) default NULL,
  PRIMARY KEY  (`id`),
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
  `x` tinyint(2) unsigned NOT NULL,
  `y` tinyint(2) unsigned NOT NULL,
  `variation` tinyint(2) unsigned NOT NULL,
  UNIQUE KEY `coords` (`planet_id`,`x`,`y`),
  CONSTRAINT `folliages_ibfk_1` FOREIGN KEY (`planet_id`) REFERENCES `planets` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `folliages`
--

LOCK TABLES `folliages` WRITE;
/*!40000 ALTER TABLE `folliages` DISABLE KEYS */;
INSERT INTO `folliages` VALUES (2,0,4,3),(2,0,7,3),(2,0,10,0),(2,0,13,5),(2,0,14,6),(2,0,15,6),(2,0,21,9),(2,0,22,3),(2,1,2,8),(2,1,6,2),(2,2,4,9),(2,2,14,12),(2,2,21,11),(2,3,8,7),(2,3,12,2),(2,3,13,0),(2,3,22,7),(2,5,1,4),(2,5,2,5),(2,5,5,2),(2,5,6,5),(2,5,7,7),(2,5,10,0),(2,6,3,12),(2,6,5,9),(2,6,9,5),(2,7,4,11),(2,7,5,0),(2,7,6,13),(2,7,10,0),(2,7,12,2),(2,7,13,12),(2,8,2,2),(2,8,4,11),(2,8,5,13),(2,8,10,10),(2,9,2,10),(2,9,5,5),(2,9,8,9),(2,9,11,0),(2,10,0,10),(2,10,1,4),(2,10,3,7),(2,10,4,0),(2,11,4,12),(2,11,6,0),(2,11,9,2),(2,12,8,7),(2,12,10,13),(2,13,4,4),(2,13,5,8),(2,14,8,5),(2,14,17,8),(2,14,21,12),(2,15,3,4),(2,15,6,3),(2,15,9,9),(2,15,10,5),(2,15,17,8),(2,15,20,5),(2,15,21,13),(2,16,0,9),(2,16,3,0),(2,16,4,10),(2,16,19,2),(2,16,22,3),(2,17,0,2),(2,17,4,7),(2,17,5,4),(2,17,19,0),(2,17,20,10),(2,17,21,10),(2,17,22,13),(2,18,6,9),(2,18,11,5),(2,19,14,11),(2,19,22,10),(2,20,1,13),(2,20,6,0),(2,21,1,3),(2,21,7,5),(2,21,13,10),(2,22,1,4),(2,22,2,11),(2,22,4,6),(2,22,15,8),(2,23,6,5),(2,23,15,6),(2,24,4,8),(2,24,21,6),(2,24,22,7),(2,25,0,1),(2,25,16,1),(2,25,17,5),(2,25,20,0),(2,25,21,2),(2,26,15,10),(2,26,16,5),(2,26,19,3),(2,26,20,4),(2,27,12,8),(2,27,15,10),(2,27,16,9),(2,27,17,12),(2,28,0,4),(2,28,2,4),(2,28,9,12),(2,28,16,4),(2,28,20,8),(2,29,7,1),(2,29,13,6),(2,29,14,1),(2,29,16,2),(2,29,17,8),(2,30,8,6),(2,30,9,9),(2,30,10,13),(2,30,11,13),(2,30,16,6),(2,31,8,4),(2,31,9,0),(2,31,10,1),(2,31,15,0),(2,32,1,6),(2,32,2,2),(2,32,3,9),(2,32,6,12),(2,32,7,9),(2,32,14,4),(2,33,6,1),(2,33,8,7),(2,33,14,9),(2,34,0,6),(2,34,1,12),(2,34,5,8),(2,34,8,2),(2,34,16,10),(2,34,19,10),(2,35,1,12),(2,35,2,5),(2,35,8,10),(2,35,9,0),(2,35,19,11),(2,36,4,6),(2,36,6,6),(2,36,8,3),(2,36,12,7),(2,37,3,8),(2,37,5,7),(2,37,17,4),(2,37,20,9),(2,38,5,4),(2,38,6,7),(2,38,17,12),(2,38,20,13),(2,39,21,1),(2,40,17,2),(2,40,19,12),(2,40,20,2),(2,40,21,11),(2,41,8,10),(2,41,9,9),(2,42,19,8),(2,44,0,9),(2,44,1,8),(2,44,8,6),(2,45,9,9),(2,45,10,9),(2,45,12,2),(2,45,13,2),(2,46,8,9),(2,47,0,13),(2,47,2,6),(2,47,6,2),(2,47,12,3),(2,47,13,13),(2,48,2,12),(2,48,9,12),(2,49,1,6),(2,49,3,11),(2,49,9,1),(2,50,8,7),(2,51,4,13),(2,52,8,1),(4,0,4,11),(4,0,5,0),(4,0,8,2),(4,0,12,11),(4,0,13,2),(4,0,14,1),(4,0,27,3),(4,1,14,4),(4,1,15,11),(4,1,19,1),(4,2,5,8),(4,2,11,5),(4,3,4,2),(4,4,5,1),(4,4,10,13),(4,4,18,2),(4,4,29,0),(4,5,0,11),(4,5,4,0),(4,5,16,11),(4,5,24,6),(4,5,25,9),(4,6,3,9),(4,6,4,10),(4,6,9,12),(4,6,14,12),(4,6,25,2),(4,6,26,10),(4,6,27,5),(4,6,29,1),(4,7,0,13),(4,7,8,7),(4,7,26,9),(4,8,0,3),(4,8,15,1),(4,8,21,11),(4,9,16,10),(4,9,21,5),(4,9,27,9),(4,10,7,5),(4,10,17,7),(4,10,18,0),(4,11,7,10),(4,11,10,6),(4,11,12,7),(4,12,0,6),(4,12,8,12),(4,13,4,13),(4,13,21,10),(4,14,0,7),(4,14,3,1),(4,14,6,2),(4,14,11,2),(4,14,12,4),(4,14,21,1),(4,15,12,9),(4,15,13,10),(4,15,20,4),(4,16,1,0),(4,16,9,7),(4,16,11,0),(4,16,13,12),(4,16,23,9),(4,17,2,8),(4,17,5,13),(4,17,9,5),(4,17,23,10),(4,18,2,10),(4,18,3,6),(4,18,7,1),(4,18,8,7),(4,18,10,9),(4,18,12,12),(4,18,13,2),(4,18,23,12),(4,19,3,7),(4,19,7,6),(4,19,9,5),(4,19,15,2),(4,20,2,4),(4,20,4,4),(4,20,8,12),(4,20,11,5),(4,20,13,7),(4,20,17,2),(4,20,20,10),(4,21,1,1),(4,21,3,3),(4,21,4,1),(4,21,7,3),(4,21,8,1),(4,21,11,7),(4,21,12,1),(4,21,14,5),(4,21,15,13),(4,21,20,5),(4,22,6,9),(4,22,7,6),(4,22,12,11),(4,22,25,7),(4,22,26,13),(4,23,5,4),(4,23,12,9),(4,23,13,3),(4,23,14,1),(4,23,18,6),(4,23,22,11),(4,23,24,0),(4,23,25,13),(4,24,9,13),(4,24,10,3),(4,24,29,2),(4,25,3,10),(4,25,7,6),(4,25,8,1),(4,25,9,8),(4,25,14,7),(4,25,15,1),(4,26,4,5),(4,26,12,3),(4,26,14,8),(4,26,26,2),(4,27,2,3),(4,27,10,0),(4,27,14,12),(4,28,0,9),(4,28,9,8),(4,28,17,13),(4,28,18,2),(4,29,1,7),(4,29,23,6),(4,29,27,12),(4,29,29,6),(7,0,15,3),(7,0,21,3),(7,0,23,6),(7,1,7,11),(7,1,8,11),(7,1,22,3),(7,2,7,12),(7,2,20,11),(7,2,21,5),(7,2,24,11),(7,3,8,1),(7,3,20,10),(7,4,6,5),(7,4,7,13),(7,5,7,4),(7,5,8,11),(7,6,7,7),(7,8,6,1),(7,8,9,10),(7,9,7,7),(7,9,10,10),(7,9,18,13),(7,11,0,8),(7,12,1,8),(7,12,8,6),(7,12,10,10),(7,12,25,7),(7,15,1,4),(7,15,19,13),(7,16,22,12),(7,17,14,0),(7,18,16,7),(7,19,8,5),(7,20,25,8),(7,21,17,3),(7,22,10,13),(7,22,14,7),(7,22,15,10),(7,22,16,7),(7,23,1,13),(7,23,10,13),(7,23,13,13),(7,23,17,5),(7,23,18,12),(7,23,24,12),(7,23,25,1),(7,24,0,1),(7,24,11,6),(7,24,12,9),(7,24,13,3),(7,24,23,7),(7,24,24,7),(7,25,0,11),(7,25,14,3),(7,25,23,9),(7,25,25,4),(7,26,0,6),(7,26,13,8),(7,27,2,13),(7,27,9,7),(7,27,24,6),(7,28,12,4),(7,28,25,2),(7,29,0,7),(7,29,4,5),(7,29,11,0),(7,29,12,8),(7,29,25,13),(7,30,4,11),(7,30,6,10),(7,30,14,5),(7,30,19,13),(7,31,9,0),(7,31,18,8),(7,31,24,8),(7,32,5,1),(7,32,9,9),(7,32,17,9),(7,33,4,11),(7,33,7,3),(7,33,8,8),(7,33,10,2),(7,33,15,3),(7,33,18,2),(7,34,5,1),(7,35,5,12),(7,35,6,12),(7,35,10,9),(7,35,13,11),(7,36,20,9),(7,36,25,7),(7,38,3,6),(7,38,11,13),(7,39,25,12),(7,41,2,12),(7,41,8,8),(7,42,1,1),(7,42,5,2),(7,42,25,3),(7,43,1,8),(7,43,2,9),(7,43,4,8),(7,44,9,8),(7,44,14,13),(7,44,25,5),(7,45,7,6),(7,45,16,10),(7,46,14,6),(7,47,0,6),(7,47,14,12),(7,47,23,0),(7,48,8,2),(7,48,16,1),(7,48,20,5),(7,49,5,7),(7,49,19,4),(7,49,21,7),(7,50,14,5),(7,50,17,2),(7,50,18,6),(7,50,20,0),(7,50,21,9),(10,0,1,9),(10,0,9,2),(10,0,13,10),(10,0,20,13),(10,0,23,2),(10,1,7,5),(10,1,8,6),(10,1,23,0),(10,2,0,12),(10,2,2,8),(10,2,8,7),(10,2,14,3),(10,2,26,7),(10,3,7,4),(10,3,11,7),(10,3,23,7),(10,4,7,11),(10,4,8,11),(10,4,14,0),(10,4,20,1),(10,5,10,0),(10,5,12,7),(10,5,13,2),(10,5,15,3),(10,5,16,2),(10,5,18,10),(10,5,22,13),(10,6,10,2),(10,6,15,3),(10,6,17,9),(10,6,19,4),(10,6,22,0),(10,6,24,5),(10,7,3,13),(10,7,12,4),(10,7,17,3),(10,7,19,4),(10,7,22,11),(10,7,24,5),(10,8,12,3),(10,8,20,7),(10,9,29,8),(10,10,4,6),(10,10,6,6),(10,10,7,12),(10,10,26,0),(10,11,25,6),(10,12,6,3),(10,12,11,6),(10,12,17,5),(10,12,26,4),(10,12,28,8),(10,13,0,10),(10,13,5,4),(10,13,7,11),(10,13,11,4),(10,13,17,12),(10,13,29,8),(10,14,2,6),(10,14,5,4),(10,14,12,3),(10,14,13,12),(10,14,14,0),(10,14,17,9),(10,15,2,1),(10,15,12,7),(10,15,13,0),(10,15,14,1),(10,16,1,8),(10,16,6,10),(10,16,13,13),(10,16,29,5),(10,17,3,4),(10,17,6,4),(10,17,7,10),(10,17,14,7),(10,17,26,3),(10,17,27,8),(10,18,11,1),(10,18,12,7),(10,18,14,1),(10,18,16,9),(10,18,22,7),(10,18,28,7),(10,19,4,13),(10,19,12,11),(10,19,18,11),(10,19,22,11),(10,19,24,13),(10,19,27,7),(10,19,28,11),(10,20,7,7),(10,20,12,8),(10,20,13,8),(10,20,19,4),(10,21,8,1),(10,21,13,2),(10,21,21,6),(10,21,23,3),(10,21,27,3),(10,22,13,9),(10,23,10,0),(10,23,16,12),(10,24,0,0),(10,24,4,13),(10,24,11,9),(10,24,13,7),(10,24,16,2),(10,25,1,0),(10,25,2,4),(10,25,6,5),(10,25,8,0),(10,25,9,9),(10,26,8,7),(10,26,13,0),(10,26,18,6),(10,27,2,7),(10,27,8,11),(10,27,15,7),(10,28,5,4),(10,28,9,13),(10,28,15,2),(10,29,4,3),(10,29,5,11),(10,29,7,8),(10,29,10,9),(10,29,11,6),(10,29,15,6),(10,29,20,11),(10,30,0,8),(10,30,6,4),(10,30,13,11),(10,30,18,12),(10,30,24,0),(10,30,25,5),(10,31,7,3),(10,31,16,2),(10,31,21,8),(10,31,25,9),(10,32,0,8),(10,32,17,12),(10,32,18,0),(10,32,20,2),(10,32,24,10),(10,33,0,0),(10,33,11,4),(10,33,13,12),(10,33,18,7),(10,34,3,10),(10,34,8,7),(10,34,9,0),(10,34,12,13),(10,34,13,10),(10,34,15,9),(10,34,16,1),(10,34,24,10),(10,35,4,12),(10,35,9,13),(10,35,11,11),(10,35,13,9),(10,36,3,2),(10,36,4,13),(10,37,1,6),(10,37,5,2),(10,37,7,6),(10,37,9,13),(10,37,13,6),(10,38,11,1),(10,39,14,8),(10,39,15,6),(10,40,0,11),(10,40,7,11),(10,40,16,8),(10,41,0,3),(10,41,7,13),(10,42,6,12),(17,0,3,6),(17,0,15,5),(17,1,3,3),(17,1,4,8),(17,1,17,13),(17,2,3,1),(17,3,12,10),(17,4,3,0),(17,4,16,10),(17,4,19,3),(17,5,1,4),(17,5,2,6),(17,6,7,10),(17,6,8,8),(17,6,9,12),(17,6,15,13),(17,6,16,2),(17,6,20,1),(17,7,0,11),(17,7,7,3),(17,7,19,8),(17,7,20,1),(17,8,8,6),(17,8,19,12),(17,8,20,1),(17,11,1,0),(17,11,2,10),(17,11,10,7),(17,12,2,10),(17,12,4,8),(17,12,17,0),(17,13,0,12),(17,13,14,5),(17,13,15,12),(17,13,17,0),(17,13,20,12),(17,14,8,8),(17,14,12,12),(17,14,13,9),(17,14,15,12),(17,15,0,2),(17,15,1,11),(17,15,4,8),(17,15,6,2),(17,15,9,0),(17,15,11,0),(17,15,18,6),(17,16,7,4),(17,16,9,5),(17,17,4,11),(17,17,7,3),(17,17,17,2),(17,17,20,5),(17,18,7,8),(17,19,0,3),(17,19,1,1),(17,19,14,5),(17,19,16,10),(17,19,18,10),(17,20,1,8),(17,20,4,13),(17,20,6,5),(17,21,1,9),(17,21,14,7),(17,21,20,2),(17,22,12,13),(17,22,18,5),(17,22,20,12),(17,23,20,8),(17,24,0,0),(17,24,1,10),(17,24,6,3),(17,24,10,4),(17,24,12,4),(17,24,15,0),(17,24,18,1),(17,24,19,13),(17,25,11,12),(17,26,3,2),(17,26,18,3),(17,26,20,0),(17,27,1,10),(17,27,20,3),(17,28,0,2),(17,28,2,11),(17,30,0,7),(17,31,7,3),(17,31,12,10),(17,31,20,11),(17,32,0,2),(17,32,5,7),(17,32,7,5),(17,32,10,2),(17,32,13,4),(17,32,14,7),(17,32,17,12),(17,32,20,4),(17,33,6,1),(17,33,8,2),(17,33,19,13),(17,34,6,1),(17,34,8,6),(17,34,9,3),(17,34,11,2),(17,34,12,5),(17,35,1,5),(17,35,2,6),(17,35,6,9),(17,35,16,3),(17,36,12,4),(17,36,20,4),(17,37,2,2),(17,38,3,12),(17,38,8,7),(17,38,19,10),(17,39,3,0),(17,39,17,2),(17,39,18,1),(17,39,20,0),(17,40,1,0),(17,41,7,9),(17,41,13,12),(17,41,18,10),(17,41,19,10),(17,42,1,9),(17,42,13,2),(17,42,16,6),(17,42,17,9),(17,42,18,13),(17,43,0,10),(17,44,4,9),(17,44,5,2),(17,44,12,0),(17,45,0,5),(17,45,5,5),(17,46,0,5),(17,46,9,13),(17,47,4,13),(17,48,3,3),(17,48,19,1),(17,49,1,13),(17,50,1,8),(17,50,6,6),(17,50,7,4),(17,50,13,8),(17,50,14,9),(17,51,6,3),(17,51,8,12),(17,51,16,7),(17,52,12,4),(17,52,19,9),(17,53,0,5),(17,53,2,11),(17,53,9,7),(17,53,11,10),(17,53,18,1),(17,53,20,3),(17,54,1,1),(17,54,8,3),(17,54,10,3),(17,54,15,12),(17,54,19,9),(23,0,2,8),(23,0,13,4),(23,0,16,1),(23,1,2,11),(23,2,9,1),(23,2,10,0),(23,2,11,2),(23,3,4,7),(23,3,11,13),(23,3,22,0),(23,4,4,5),(23,4,14,0),(23,4,17,0),(23,4,22,1),(23,5,17,6),(23,5,22,13),(23,6,0,7),(23,6,7,11),(23,6,14,11),(23,6,15,2),(23,7,7,1),(23,7,16,7),(23,7,18,2),(23,7,23,0),(23,8,0,13),(23,8,1,5),(23,8,6,13),(23,8,8,13),(23,8,18,0),(23,8,22,8),(23,9,6,5),(23,10,1,1),(23,10,7,5),(23,10,23,9),(23,11,4,1),(23,11,7,11),(23,11,18,4),(23,11,19,10),(23,11,22,10),(23,12,8,4),(23,12,13,3),(23,12,14,2),(23,12,21,12),(23,12,22,4),(23,13,4,3),(23,13,7,6),(23,13,10,13),(23,13,11,3),(23,13,15,11),(23,13,16,3),(23,13,17,7),(23,13,22,8),(23,14,5,13),(23,14,11,8),(23,14,23,11),(23,15,5,12),(23,15,6,10),(23,15,7,12),(23,16,2,5),(23,16,6,7),(23,16,7,1),(23,17,1,1),(23,17,5,4),(23,17,7,5),(23,17,8,8),(23,17,21,9),(23,18,0,10),(23,19,0,12),(23,19,1,3),(23,19,2,11),(23,20,0,11),(23,20,11,12),(23,21,16,13),(23,21,17,2),(23,22,1,5),(23,23,0,7),(23,23,20,7),(23,24,3,3),(23,24,6,5),(23,25,4,5),(23,25,11,9),(23,25,12,12),(23,26,4,4),(23,26,8,4),(23,26,16,8),(23,26,23,10),(23,27,9,11),(23,27,16,0),(23,28,7,5),(23,29,1,10),(23,29,2,11),(23,29,18,4),(23,30,23,0),(23,33,14,7),(23,34,15,2),(23,35,15,5),(23,36,15,12),(25,0,15,2),(25,1,1,3),(25,1,17,1),(25,2,8,1),(25,2,15,10),(25,3,0,5),(25,3,1,6),(25,3,8,2),(25,3,15,9),(25,4,2,3),(25,4,5,12),(25,4,8,6),(25,4,9,11),(25,4,19,1),(25,4,20,7),(25,5,2,1),(25,5,3,6),(25,5,14,4),(25,6,0,0),(25,6,4,13),(25,6,5,0),(25,6,8,4),(25,6,19,12),(25,7,4,3),(25,7,5,11),(25,7,6,7),(25,7,8,4),(25,8,1,12),(25,8,2,3),(25,9,3,3),(25,10,0,12),(25,11,22,5),(25,12,0,1),(25,12,1,3),(25,12,19,13),(25,12,20,7),(25,12,21,8),(25,13,1,0),(25,13,2,13),(25,13,3,3),(25,14,10,8),(25,14,20,10),(25,14,21,11),(25,15,3,3),(25,15,10,12),(25,15,17,5),(25,16,0,11),(25,16,2,5),(25,16,11,0),(25,16,12,11),(25,16,13,7),(25,16,19,2),(25,17,12,12),(25,17,13,6),(25,17,21,9),(25,18,0,12),(25,18,8,8),(25,18,10,5),(25,18,16,1),(25,19,1,1),(25,19,5,12),(25,19,9,10),(25,19,19,4),(25,19,20,4),(25,20,0,8),(25,21,15,12),(25,21,22,11),(25,23,6,11),(25,23,22,12),(25,24,1,9),(25,24,2,4),(25,24,5,0),(25,24,15,0),(25,24,18,1),(25,24,22,7),(25,25,1,2),(25,25,17,7),(25,25,18,2),(25,26,22,1),(25,27,16,4),(25,28,12,0),(25,28,13,7),(25,28,17,5),(25,28,22,1),(25,29,0,1),(25,29,2,13),(25,29,3,8),(25,29,4,12),(25,29,10,12),(25,29,11,8),(25,29,21,6),(25,30,0,11),(25,30,4,9),(25,30,13,9),(25,30,22,0),(25,31,1,7),(25,31,2,13),(25,31,12,6),(25,31,13,7),(25,31,18,9),(25,32,0,9),(25,32,11,12),(25,32,14,7),(25,32,16,13),(25,32,20,2),(25,32,22,4),(25,33,0,10),(25,33,1,12),(25,33,2,10),(25,33,18,10),(25,33,19,0),(25,33,22,6),(25,34,14,10),(25,34,17,7),(25,34,21,10),(25,35,10,1),(25,35,16,12),(25,35,17,2),(25,37,15,1),(25,37,22,3),(25,38,17,13),(25,39,1,6),(25,40,0,1),(25,40,16,7),(25,41,8,8),(25,42,1,3),(25,42,3,8),(25,42,8,7),(25,42,11,11),(25,43,4,3),(25,43,21,0),(25,44,6,0),(25,45,2,9),(25,45,4,1),(25,45,14,7),(28,0,1,3),(28,0,2,10),(28,0,4,7),(28,0,5,12),(28,1,5,10),(28,2,6,4),(28,3,9,1),(28,4,2,8),(28,5,2,0),(28,5,6,0),(28,5,8,1),(28,5,9,7),(28,5,20,3),(28,6,5,13),(28,6,7,1),(28,6,8,4),(28,6,9,13),(28,6,18,1),(28,6,22,9),(28,7,2,10),(28,7,8,3),(28,7,17,8),(28,8,0,11),(28,8,2,0),(28,8,17,10),(28,8,18,11),(28,8,24,1),(28,10,2,2),(28,10,9,12),(28,10,19,9),(28,11,2,9),(28,11,8,10),(28,11,18,9),(28,11,19,10),(28,11,20,2),(28,12,20,7),(28,13,19,11),(28,14,7,12),(28,14,15,12),(28,14,22,6),(28,15,0,2),(28,15,6,10),(28,15,19,0),(28,15,21,4),(28,15,23,5),(28,16,7,12),(28,16,8,2),(28,16,9,7),(28,16,10,1),(28,16,14,0),(28,16,15,2),(28,16,20,6),(28,16,21,6),(28,17,6,10),(28,18,0,13),(28,18,16,7),(28,20,6,0),(28,20,8,3),(28,21,5,8),(28,21,9,6),(28,21,10,6),(28,21,13,10),(28,22,17,3),(28,23,9,2),(28,23,11,11),(28,23,13,2),(28,23,16,9),(28,23,24,4),(28,24,6,7),(28,24,10,12),(28,24,11,11),(28,25,6,6),(28,25,7,8),(28,25,12,13),(28,25,23,2),(28,26,14,5),(28,27,15,7),(28,28,21,4),(28,28,23,13),(28,29,1,10),(28,29,21,11),(28,29,22,11),(28,29,24,12),(28,30,18,5),(28,30,20,9),(28,30,23,1),(28,31,17,1),(28,31,18,1),(28,31,22,13),(28,32,17,4),(28,32,21,2),(28,32,23,13),(28,33,0,8),(28,33,1,13),(28,33,20,8),(28,33,24,6),(28,34,0,6),(28,34,5,9),(28,34,10,7),(28,34,21,12),(28,34,24,9),(28,35,22,3),(28,35,24,6),(28,36,10,0),(28,36,15,2),(28,36,18,3),(28,37,13,0),(28,37,16,8),(28,38,16,5),(28,38,17,10),(28,38,18,11),(28,39,3,4),(28,39,4,6),(28,39,12,6),(28,39,21,3),(28,39,23,13),(28,39,24,11),(28,40,4,12),(28,40,15,4),(28,40,19,5),(28,41,0,3),(28,41,13,8),(28,41,18,8),(28,41,20,3),(28,41,21,11),(28,41,22,8),(28,41,24,3),(28,42,12,0),(28,42,14,4),(28,42,17,3),(28,42,22,2),(28,42,23,7),(28,42,24,3),(28,43,1,2),(28,43,17,13),(28,43,18,10),(28,43,23,3),(28,43,24,1),(28,45,9,12),(28,45,21,7),(28,45,24,13),(28,46,10,3),(28,46,11,4),(28,46,12,8),(28,46,19,6),(28,46,24,7),(28,47,7,4),(28,47,10,11),(28,47,13,12),(28,47,18,6),(28,47,19,9),(28,48,7,7),(28,48,8,5),(28,48,10,0),(28,48,24,8),(28,49,6,10),(28,49,17,6),(28,50,5,0),(28,50,12,10),(28,50,13,4),(28,50,16,12),(28,51,18,3),(28,51,20,7),(28,51,22,8),(28,52,21,4),(28,53,0,4),(28,53,3,6),(28,53,19,0),(28,53,24,8),(28,54,5,10),(28,54,18,7),(28,54,22,9),(28,55,2,11),(28,55,3,0),(28,55,21,2),(28,55,24,11),(28,56,3,9),(28,56,4,6),(28,56,5,6),(28,56,6,9),(28,56,18,3),(28,56,20,10),(28,56,22,7),(28,56,24,4),(28,57,2,8),(28,57,3,6),(28,57,5,13),(28,57,8,9),(28,57,12,3),(28,57,15,13),(28,57,16,3),(28,57,18,1),(28,57,21,4),(29,3,0,11),(29,6,11,8),(29,7,5,6),(29,7,6,1),(29,7,7,5),(29,7,12,7),(29,8,2,2),(29,8,3,5),(29,8,8,1),(29,9,6,13),(29,9,8,5),(29,9,12,0),(29,9,13,1),(29,10,2,5),(29,10,15,6),(29,11,0,0),(29,11,12,12),(29,11,13,5),(29,12,4,5),(29,12,16,5),(29,15,0,4),(29,15,6,6),(29,15,7,6),(29,15,14,6),(29,16,5,12),(29,16,7,5),(29,16,13,6),(29,18,12,13),(29,19,10,2),(29,20,7,9),(29,21,16,9),(29,23,5,5),(29,25,0,11),(29,25,1,4),(29,25,17,6),(29,26,1,12),(29,26,2,12),(29,27,6,1),(29,28,4,9),(29,28,7,12),(29,28,15,11),(29,28,17,11),(29,29,14,6),(29,30,2,0),(29,30,15,6),(29,31,9,6),(29,31,11,8),(29,31,12,12),(29,32,17,3),(29,33,11,1),(29,33,13,1),(29,33,14,10),(29,34,10,8),(29,35,8,8),(29,35,11,10),(29,35,13,10),(29,35,14,8),(29,36,3,0),(29,37,0,0),(29,37,3,9),(29,37,5,11),(29,37,8,0),(29,38,15,5),(29,38,16,0),(29,39,3,13),(29,39,4,6),(29,39,11,12),(29,39,12,3),(29,39,14,0),(29,39,15,8),(29,39,17,13),(29,40,9,1),(29,40,11,0),(29,40,13,9),(29,40,16,1),(29,40,17,4),(29,41,8,5),(29,41,9,4),(29,41,10,0),(29,41,13,6),(29,41,15,4),(29,41,16,2),(29,41,17,13),(29,42,5,2),(29,42,6,10),(29,42,8,5),(29,43,1,2),(29,43,5,1),(29,43,7,5),(29,43,10,3),(29,44,5,6),(29,44,6,9),(29,45,4,8),(29,45,6,1),(29,45,12,5),(29,45,17,0),(29,46,1,12),(29,46,12,0),(29,47,3,1),(29,47,5,8),(29,47,8,3),(29,47,13,6),(29,47,15,9),(35,0,2,5),(35,0,11,13),(35,0,13,9),(35,0,18,10),(35,0,19,8),(35,1,2,13),(35,2,5,2),(35,2,8,13),(35,2,14,1),(35,2,16,12),(35,2,19,4),(35,3,5,6),(35,3,9,7),(35,3,11,9),(35,3,15,10),(35,4,8,7),(35,5,6,6),(35,5,8,13),(35,5,14,11),(35,5,15,2),(35,5,18,0),(35,6,6,0),(35,6,7,4),(35,6,8,1),(35,6,16,12),(35,6,19,4),(35,7,0,6),(35,7,15,10),(35,7,17,6),(35,8,4,5),(35,8,18,13),(35,8,19,9),(35,9,4,8),(35,9,18,8),(35,11,2,8),(35,12,6,5),(35,12,8,8),(35,13,0,0),(35,14,4,0),(35,14,5,7),(35,14,6,5),(35,15,5,7),(35,15,7,1),(35,16,2,10),(35,16,14,13),(35,17,0,12),(35,17,1,8),(35,17,9,10),(35,17,15,3),(35,18,19,11),(35,19,7,11),(35,19,13,0),(35,19,17,0),(35,20,0,1),(35,20,10,12),(35,21,0,11),(35,21,2,12),(35,21,17,3),(35,22,2,5),(35,23,5,13),(35,24,2,7),(35,24,18,4),(35,25,7,13),(35,25,17,8),(35,26,0,4),(35,27,0,13),(35,27,8,7),(35,27,17,4),(35,28,0,1),(35,28,1,6),(35,28,6,4),(35,28,9,9),(35,28,14,10),(35,28,19,12),(35,31,0,3),(35,31,14,1),(35,31,18,11),(35,32,0,8),(35,32,9,13),(35,32,14,2),(35,34,5,5),(35,34,9,11),(35,34,12,10),(35,35,4,4),(35,36,0,11),(35,36,1,12),(35,36,12,11),(35,37,14,5),(35,37,16,2),(35,38,2,4),(35,41,12,8),(35,41,13,4),(35,43,12,6),(35,44,12,0),(35,45,12,13),(35,46,1,3),(35,47,16,1),(35,48,1,5),(35,48,7,2),(35,48,8,13),(35,48,10,5),(35,48,16,6),(35,49,2,8),(35,49,3,11),(35,49,5,7),(35,49,6,4),(35,49,11,5),(35,50,3,4),(35,50,7,6),(35,50,8,13),(35,50,10,13),(35,50,11,3),(37,0,1,7),(37,1,0,1),(37,1,11,0),(37,2,13,3),(37,3,4,3),(37,4,4,2),(37,4,13,12),(37,5,0,9),(37,5,3,4),(37,5,12,12),(37,5,14,7),(37,6,0,3),(37,6,11,10),(37,8,8,8),(37,8,12,6),(37,9,5,10),(37,9,12,1),(37,10,6,7),(37,11,14,0),(37,12,2,8),(37,12,7,0),(37,12,12,8),(37,13,8,5),(37,13,10,13),(37,13,11,10),(37,14,1,11),(37,14,11,2),(37,15,10,10),(37,15,12,0),(37,16,0,0),(37,16,4,5),(37,17,0,9),(37,17,7,1),(37,17,9,4),(37,19,12,10),(37,22,4,2),(37,22,14,13),(37,24,7,9),(37,26,6,6),(37,27,6,6),(37,30,0,4),(37,31,6,13),(37,31,8,11),(37,31,14,5),(37,34,10,6),(37,35,10,5),(37,35,13,3),(37,37,8,13),(37,37,13,1),(37,38,5,11),(37,39,5,10),(37,39,7,13),(37,39,13,4),(40,0,1,11),(40,0,2,5),(40,0,11,11),(40,1,1,11),(40,1,13,8),(40,1,14,11),(40,2,0,0),(40,2,1,3),(40,2,2,5),(40,4,5,0),(40,5,3,6),(40,5,4,10),(40,5,14,13),(40,6,0,8),(40,6,14,4),(40,7,6,1),(40,7,10,7),(40,7,14,13),(40,8,11,1),(40,8,17,13),(40,9,0,9),(40,9,5,0),(40,9,7,6),(40,9,12,11),(40,9,14,5),(40,10,4,4),(40,10,7,3),(40,11,7,6),(40,11,9,4),(40,11,21,3),(40,12,0,0),(40,12,1,12),(40,12,10,3),(40,12,12,1),(40,12,19,1),(40,12,23,3),(40,13,0,9),(40,13,4,5),(40,13,7,10),(40,13,10,13),(40,13,11,0),(40,13,13,2),(40,13,14,12),(40,13,15,2),(40,13,18,8),(40,13,25,4),(40,14,0,6),(40,14,6,0),(40,14,7,2),(40,14,9,2),(40,14,12,10),(40,14,13,8),(40,14,14,4),(40,14,17,8),(40,14,19,0),(40,14,21,13),(40,14,22,4),(40,14,24,7),(40,14,25,8),(40,15,3,6),(40,15,6,1),(40,15,10,9),(40,16,0,4),(40,16,3,7),(40,16,24,13),(40,16,25,9),(40,17,3,12),(40,17,11,1),(40,18,5,7),(40,18,7,3),(40,18,9,5),(40,18,10,11),(40,19,16,10),(40,21,25,7),(40,22,4,9),(40,23,2,2),(40,23,3,3),(40,23,4,10),(40,23,24,5),(40,23,25,4),(40,24,5,11),(40,24,23,2),(40,27,25,1),(40,28,14,13),(40,28,16,2),(40,29,17,10),(40,29,22,13),(40,30,19,4),(40,31,0,3),(40,31,2,3),(40,31,13,5),(40,31,25,11),(40,32,2,10),(40,32,12,10),(40,32,20,12),(40,33,1,8),(40,33,2,8),(40,33,19,3),(40,33,20,5),(40,33,22,11),(40,34,3,6),(40,34,5,4),(40,34,10,2),(40,34,20,2),(40,34,22,2),(40,35,6,11),(40,35,8,3),(40,35,20,4),(40,35,23,7),(40,36,8,4),(40,36,10,6),(40,36,11,1),(40,36,23,5),(40,36,24,1),(40,37,4,3),(40,37,15,0),(40,37,23,13),(40,38,3,6),(40,38,4,0),(40,38,7,12),(40,38,17,7),(40,38,18,10),(40,38,20,10),(40,38,24,12),(40,39,13,2),(40,39,17,5),(40,39,22,4),(40,40,21,2),(40,41,0,1),(40,41,1,5),(40,41,3,1),(40,41,17,5),(40,41,21,11),(40,42,3,1),(40,42,4,9),(40,42,5,8),(40,42,6,10),(40,42,8,2),(40,42,15,13),(40,42,17,6),(40,43,0,8),(40,43,10,4),(40,43,16,9),(40,43,24,9),(40,43,25,7),(40,44,4,0),(40,44,7,3),(40,44,8,2),(40,44,10,3),(40,44,11,13),(40,44,15,7),(40,44,16,10),(40,44,18,2),(40,45,2,9),(40,45,3,11),(40,45,5,3),(40,45,9,12),(40,45,13,10),(40,45,16,4),(40,45,17,11),(40,45,18,12),(40,45,24,11);
/*!40000 ALTER TABLE `folliages` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `fow_galaxy_entries`
--

DROP TABLE IF EXISTS `fow_galaxy_entries`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `fow_galaxy_entries` (
  `id` int(11) NOT NULL auto_increment,
  `galaxy_id` int(11) NOT NULL,
  `player_id` int(11) default NULL,
  `alliance_id` int(11) default NULL,
  `x` int(11) NOT NULL,
  `y` int(11) NOT NULL,
  `x_end` int(11) NOT NULL,
  `y_end` int(11) NOT NULL,
  `counter` tinyint(2) unsigned NOT NULL default '1',
  PRIMARY KEY  (`id`),
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
  `id` int(11) NOT NULL auto_increment,
  `solar_system_id` int(11) NOT NULL,
  `player_id` int(11) default NULL,
  `counter` int(11) NOT NULL default '0',
  `player_planets` tinyint(1) default NULL,
  `player_ships` tinyint(1) default NULL,
  `enemy_planets` tinyint(1) NOT NULL default '0',
  `enemy_ships` tinyint(1) NOT NULL default '0',
  `alliance_id` int(11) default NULL,
  `alliance_planet_player_ids` text,
  `alliance_ship_player_ids` text,
  `nap_planets` tinyint(1) default NULL,
  `nap_ships` tinyint(1) default NULL,
  PRIMARY KEY  (`id`),
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
INSERT INTO `fow_ss_entries` VALUES (1,1,1,2,1,0,0,0,NULL,NULL,NULL,NULL,NULL),(2,4,1,1,0,0,0,0,NULL,NULL,NULL,NULL,NULL),(3,2,1,1,0,0,0,0,NULL,NULL,NULL,NULL,NULL),(4,3,1,1,0,0,0,0,NULL,NULL,NULL,NULL,NULL);
/*!40000 ALTER TABLE `fow_ss_entries` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `galaxies`
--

DROP TABLE IF EXISTS `galaxies`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `galaxies` (
  `id` int(11) NOT NULL auto_increment,
  `created_at` datetime NOT NULL,
  `ruleset` varchar(30) NOT NULL default 'default',
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `galaxies`
--

LOCK TABLES `galaxies` WRITE;
/*!40000 ALTER TABLE `galaxies` DISABLE KEYS */;
INSERT INTO `galaxies` VALUES (1,'2010-10-06 11:37:08','dev');
/*!40000 ALTER TABLE `galaxies` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `naps`
--

DROP TABLE IF EXISTS `naps`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `naps` (
  `id` int(11) NOT NULL auto_increment,
  `initiator_id` int(11) NOT NULL,
  `acceptor_id` int(11) NOT NULL,
  `status` tinyint(2) unsigned NOT NULL default '0',
  `created_at` datetime NOT NULL,
  `expires_at` datetime default NULL,
  PRIMARY KEY  (`id`),
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
  `id` int(11) NOT NULL auto_increment,
  `player_id` int(11) NOT NULL,
  `created_at` datetime NOT NULL,
  `expires_at` datetime NOT NULL,
  `event` tinyint(2) unsigned NOT NULL,
  `params` text,
  `starred` tinyint(1) NOT NULL default '0',
  `read` tinyint(1) NOT NULL default '0',
  PRIMARY KEY  (`id`),
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
INSERT INTO `notifications` VALUES (1,1,'2010-10-06 11:37:11','2010-10-20 11:37:11',3,'--- \n:id: 1\n',0,0),(2,1,'2010-10-06 11:37:11','2010-10-20 11:37:11',3,'--- \n:id: 2\n',0,0);
/*!40000 ALTER TABLE `notifications` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `objective_progresses`
--

DROP TABLE IF EXISTS `objective_progresses`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `objective_progresses` (
  `id` int(11) NOT NULL auto_increment,
  `objective_id` int(11) default NULL,
  `player_id` int(11) default NULL,
  `completed` tinyint(2) unsigned NOT NULL default '0',
  PRIMARY KEY  (`id`),
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
  `id` int(11) NOT NULL auto_increment,
  `quest_id` int(11) NOT NULL,
  `type` varchar(255) NOT NULL,
  `key` varchar(255) default NULL,
  `count` tinyint(2) unsigned NOT NULL default '1',
  `level` tinyint(2) unsigned default NULL,
  `alliance` tinyint(1) NOT NULL default '0',
  `npc` tinyint(1) NOT NULL default '0',
  PRIMARY KEY  (`id`),
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
  `id` int(11) NOT NULL auto_increment,
  `solar_system_id` int(11) NOT NULL,
  `width` int(11) default NULL,
  `height` int(11) default NULL,
  `position` int(11) NOT NULL default '0',
  `angle` int(11) NOT NULL default '0',
  `variation` int(11) NOT NULL default '0',
  `type` varchar(255) NOT NULL,
  `player_id` int(11) default NULL,
  `name` varchar(255) NOT NULL default '',
  `size` int(11) NOT NULL default '0',
  `metal_rate` int(10) unsigned default NULL,
  `energy_rate` int(10) unsigned default NULL,
  `zetium_rate` int(10) unsigned default NULL,
  PRIMARY KEY  (`id`),
  UNIQUE KEY `uniqueness` (`solar_system_id`,`position`),
  KEY `index_planets_on_galaxy_id_and_solar_system_id` (`solar_system_id`),
  KEY `index_planets_on_player_id_and_galaxy_id` (`player_id`),
  KEY `group_by_for_fowssentry_status_updates` (`player_id`,`solar_system_id`),
  CONSTRAINT `planets_ibfk_2` FOREIGN KEY (`player_id`) REFERENCES `players` (`id`) ON DELETE SET NULL,
  CONSTRAINT `planets_ibfk_1` FOREIGN KEY (`solar_system_id`) REFERENCES `solar_systems` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=41 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `planets`
--

LOCK TABLES `planets` WRITE;
/*!40000 ALTER TABLE `planets` DISABLE KEYS */;
INSERT INTO `planets` VALUES (1,1,NULL,NULL,0,90,5,'Mining',NULL,'G1-S1-P1',32,273,193,224),(2,1,53,23,1,45,2,'Regular',NULL,'G1-S1-P2',60,NULL,NULL,NULL),(3,1,NULL,NULL,2,60,0,'Mining',NULL,'G1-S1-P3',25,395,262,346),(4,1,30,30,3,112,0,'Homeworld',1,'G1-S1-P4',57,NULL,NULL,NULL),(5,1,NULL,NULL,4,306,0,'Npc',NULL,'G1-S1-P5',56,NULL,NULL,NULL),(6,1,NULL,NULL,5,315,1,'Jumpgate',NULL,'G1-S1-P6',43,NULL,NULL,NULL),(7,1,51,26,6,60,5,'Regular',NULL,'G1-S1-P7',61,NULL,NULL,NULL),(8,2,NULL,NULL,1,225,1,'Jumpgate',NULL,'G1-S2-P8',49,NULL,NULL,NULL),(9,2,NULL,NULL,3,270,2,'Jumpgate',NULL,'G1-S2-P9',37,NULL,NULL,NULL),(10,2,43,30,4,198,8,'Regular',NULL,'G1-S2-P10',58,NULL,NULL,NULL),(11,2,NULL,NULL,5,270,0,'Npc',NULL,'G1-S2-P11',47,NULL,NULL,NULL),(12,2,NULL,NULL,6,90,2,'Jumpgate',NULL,'G1-S2-P12',31,NULL,NULL,NULL),(13,2,NULL,NULL,7,11,4,'Resource',NULL,'G1-S2-P13',53,393,176,238),(14,2,NULL,NULL,8,100,4,'Mining',NULL,'G1-S2-P14',44,344,121,108),(15,2,NULL,NULL,9,351,0,'Jumpgate',NULL,'G1-S2-P15',55,NULL,NULL,NULL),(16,2,NULL,NULL,10,310,2,'Mining',NULL,'G1-S2-P16',48,303,339,163),(17,2,55,21,11,104,2,'Regular',NULL,'G1-S2-P17',60,NULL,NULL,NULL),(18,2,NULL,NULL,13,66,2,'Mining',NULL,'G1-S2-P18',51,185,392,230),(19,2,NULL,NULL,14,192,4,'Mining',NULL,'G1-S2-P19',58,124,293,287),(20,2,NULL,NULL,15,25,2,'Resource',NULL,'G1-S2-P20',30,227,193,256),(21,2,NULL,NULL,16,15,4,'Resource',NULL,'G1-S2-P21',58,195,205,206),(22,2,NULL,NULL,17,35,2,'Mining',NULL,'G1-S2-P22',33,357,321,209),(23,2,38,24,18,184,2,'Regular',NULL,'G1-S2-P23',49,NULL,NULL,NULL),(24,3,NULL,NULL,0,90,5,'Resource',NULL,'G1-S3-P24',48,242,325,146),(25,3,46,23,1,45,8,'Regular',NULL,'G1-S3-P25',55,NULL,NULL,NULL),(26,3,NULL,NULL,3,270,1,'Mining',NULL,'G1-S3-P26',50,400,340,193),(27,3,NULL,NULL,4,270,1,'Jumpgate',NULL,'G1-S3-P27',44,NULL,NULL,NULL),(28,3,58,25,5,270,6,'Regular',NULL,'G1-S3-P28',66,NULL,NULL,NULL),(29,3,48,18,6,216,7,'Regular',NULL,'G1-S3-P29',52,NULL,NULL,NULL),(30,3,NULL,NULL,7,66,0,'Npc',NULL,'G1-S3-P30',48,NULL,NULL,NULL),(31,3,NULL,NULL,9,117,3,'Mining',NULL,'G1-S3-P31',42,146,179,118),(32,3,NULL,NULL,10,286,2,'Jumpgate',NULL,'G1-S3-P32',43,NULL,NULL,NULL),(33,4,NULL,NULL,0,90,6,'Mining',NULL,'G1-S4-P33',60,215,320,400),(34,4,NULL,NULL,1,90,0,'Jumpgate',NULL,'G1-S4-P34',27,NULL,NULL,NULL),(35,4,51,20,2,150,3,'Regular',NULL,'G1-S4-P35',56,NULL,NULL,NULL),(36,4,NULL,NULL,4,108,0,'Jumpgate',NULL,'G1-S4-P36',36,NULL,NULL,NULL),(37,4,40,15,5,345,7,'Regular',NULL,'G1-S4-P37',44,NULL,NULL,NULL),(38,4,NULL,NULL,6,36,3,'Mining',NULL,'G1-S4-P38',44,279,142,356),(39,4,NULL,NULL,7,22,2,'Jumpgate',NULL,'G1-S4-P39',53,NULL,NULL,NULL),(40,4,46,26,8,320,8,'Regular',NULL,'G1-S4-P40',57,NULL,NULL,NULL);
/*!40000 ALTER TABLE `planets` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `players`
--

DROP TABLE IF EXISTS `players`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `players` (
  `id` int(11) NOT NULL auto_increment,
  `galaxy_id` int(11) default NULL,
  `auth_token` char(64) NOT NULL,
  `name` varchar(64) NOT NULL,
  `scientists` int(10) unsigned NOT NULL default '0',
  `scientists_total` int(10) unsigned NOT NULL default '0',
  `alliance_id` int(11) default NULL,
  `xp` int(10) unsigned NOT NULL default '0',
  `points` int(10) unsigned NOT NULL default '0',
  PRIMARY KEY  (`id`),
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
  `id` int(11) NOT NULL auto_increment,
  `quest_id` int(11) NOT NULL,
  `player_id` int(11) NOT NULL,
  `status` tinyint(2) unsigned NOT NULL,
  `completed` tinyint(2) unsigned NOT NULL default '0',
  PRIMARY KEY  (`id`),
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
  `id` int(11) NOT NULL auto_increment,
  `parent_id` int(11) default NULL,
  `rewards` text NOT NULL,
  `help_url_id` varchar(255) default NULL,
  PRIMARY KEY  (`id`),
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
  `planet_id` int(11) NOT NULL auto_increment,
  `metal` float NOT NULL default '0',
  `metal_storage` float NOT NULL default '0',
  `energy` float NOT NULL default '0',
  `energy_storage` float NOT NULL default '0',
  `zetium` float NOT NULL default '0',
  `zetium_storage` float NOT NULL default '0',
  `metal_rate` float NOT NULL default '0',
  `energy_rate` float NOT NULL default '0',
  `zetium_rate` float NOT NULL default '0',
  `last_update` datetime default NULL,
  `energy_diminish_registered` tinyint(1) NOT NULL default '0',
  PRIMARY KEY  (`planet_id`),
  KEY `index_resources_entries_on_last_update` (`last_update`),
  CONSTRAINT `resources_entries_ibfk_1` FOREIGN KEY (`planet_id`) REFERENCES `planets` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=41 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `resources_entries`
--

LOCK TABLES `resources_entries` WRITE;
/*!40000 ALTER TABLE `resources_entries` DISABLE KEYS */;
INSERT INTO `resources_entries` VALUES (1,0,0,0,0,0,0,0,0,0,NULL,0),(2,0,0,0,0,0,0,0,0,0,NULL,0),(3,0,0,0,0,0,0,0,0,0,NULL,0),(4,864,3024,1728,6048,0,604.8,50,100,0,'2010-10-06 11:37:10',0),(5,0,0,0,0,0,0,0,0,0,NULL,0),(6,0,0,0,0,0,0,0,0,0,NULL,0),(7,0,0,0,0,0,0,0,0,0,NULL,0),(8,0,0,0,0,0,0,0,0,0,NULL,0),(9,0,0,0,0,0,0,0,0,0,NULL,0),(10,0,0,0,0,0,0,0,0,0,NULL,0),(11,0,0,0,0,0,0,0,0,0,NULL,0),(12,0,0,0,0,0,0,0,0,0,NULL,0),(13,0,0,0,0,0,0,0,0,0,NULL,0),(14,0,0,0,0,0,0,0,0,0,NULL,0),(15,0,0,0,0,0,0,0,0,0,NULL,0),(16,0,0,0,0,0,0,0,0,0,NULL,0),(17,0,0,0,0,0,0,0,0,0,NULL,0),(18,0,0,0,0,0,0,0,0,0,NULL,0),(19,0,0,0,0,0,0,0,0,0,NULL,0),(20,0,0,0,0,0,0,0,0,0,NULL,0),(21,0,0,0,0,0,0,0,0,0,NULL,0),(22,0,0,0,0,0,0,0,0,0,NULL,0),(23,0,0,0,0,0,0,0,0,0,NULL,0),(24,0,0,0,0,0,0,0,0,0,NULL,0),(25,0,0,0,0,0,0,0,0,0,NULL,0),(26,0,0,0,0,0,0,0,0,0,NULL,0),(27,0,0,0,0,0,0,0,0,0,NULL,0),(28,0,0,0,0,0,0,0,0,0,NULL,0),(29,0,0,0,0,0,0,0,0,0,NULL,0),(30,0,0,0,0,0,0,0,0,0,NULL,0),(31,0,0,0,0,0,0,0,0,0,NULL,0),(32,0,0,0,0,0,0,0,0,0,NULL,0),(33,0,0,0,0,0,0,0,0,0,NULL,0),(34,0,0,0,0,0,0,0,0,0,NULL,0),(35,0,0,0,0,0,0,0,0,0,NULL,0),(36,0,0,0,0,0,0,0,0,0,NULL,0),(37,0,0,0,0,0,0,0,0,0,NULL,0),(38,0,0,0,0,0,0,0,0,0,NULL,0),(39,0,0,0,0,0,0,0,0,0,NULL,0),(40,0,0,0,0,0,0,0,0,0,NULL,0);
/*!40000 ALTER TABLE `resources_entries` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `route_hops`
--

DROP TABLE IF EXISTS `route_hops`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `route_hops` (
  `id` int(11) NOT NULL auto_increment,
  `route_id` int(11) NOT NULL,
  `location_type` tinyint(2) unsigned NOT NULL,
  `location_id` int(10) unsigned NOT NULL,
  `location_x` int(11) default NULL,
  `location_y` int(11) default NULL,
  `arrives_at` datetime NOT NULL,
  `index` smallint(6) NOT NULL,
  `next` tinyint(1) NOT NULL default '0',
  `jumps_at` datetime default NULL,
  PRIMARY KEY  (`id`),
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
  `id` int(11) NOT NULL auto_increment,
  `target_type` tinyint(2) unsigned NOT NULL,
  `target_id` int(10) unsigned NOT NULL,
  `arrives_at` datetime NOT NULL,
  `cached_units` text NOT NULL,
  `player_id` int(11) NOT NULL,
  `target_x` int(11) NOT NULL,
  `target_y` int(11) NOT NULL,
  `target_name` varchar(255) default NULL,
  `target_variation` tinyint(2) unsigned default NULL,
  `target_solar_system_id` int(11) default NULL,
  `current_id` int(11) unsigned NOT NULL,
  `current_type` tinyint(2) unsigned NOT NULL,
  `current_x` int(11) NOT NULL,
  `current_y` int(11) NOT NULL,
  `current_name` varchar(255) default NULL,
  `current_variation` tinyint(2) unsigned default NULL,
  `current_solar_system_id` int(11) default NULL,
  `source_id` int(11) unsigned NOT NULL,
  `source_type` tinyint(2) unsigned NOT NULL,
  `source_x` int(11) NOT NULL,
  `source_y` int(11) NOT NULL,
  `source_name` varchar(255) default NULL,
  `source_variation` tinyint(2) unsigned default NULL,
  `source_solar_system_id` int(11) default NULL,
  PRIMARY KEY  (`id`),
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
INSERT INTO `schema_migrations` VALUES ('20090601175224'),('20090601184051'),('20090601184055'),('20090601184059'),('20090701164131'),('20090713165021'),('20090808144214'),('20090809160211'),('20090810173759'),('20090826140238'),('20090826141836'),('20090829202538'),('20090829210029'),('20090829224505'),('20090830143959'),('20090830145319'),('20090901153809'),('20090904190655'),('20090905175341'),('20090905192056'),('20090906135044'),('20090909222719'),('20090911180950'),('20090912165229'),('20090919155819'),('20091024222359'),('20091103164416'),('20091103180558'),('20091103181146'),('20091109191211'),('20091225193714'),('20100114152902'),('20100121142414'),('20100127115341'),('20100127120219'),('20100127120515'),('20100127121337'),('20100129150736'),('20100203202757'),('20100203204803'),('20100204172507'),('20100204173714'),('20100208163239'),('20100210114531'),('20100212134334'),('20100218181507'),('20100219114448'),('20100220144106'),('20100222144003'),('20100223153023'),('20100224153728'),('20100224163525'),('20100225124928'),('20100225153721'),('20100225155505'),('20100225155739'),('20100226122144'),('20100226122651'),('20100301153626'),('20100302131225'),('20100303131706'),('20100308163148'),('20100308164422'),('20100310172315'),('20100310181338'),('20100311123523'),('20100315112858'),('20100319141401'),('20100322184529'),('20100324134243'),('20100324141652'),('20100331125702'),('20100415130556'),('20100415130600'),('20100415130605'),('20100415134627'),('20100419141518'),('20100419142018'),('20100419164230'),('20100426141509'),('20100428130912'),('20100429171200'),('20100430174140'),('20100610151652'),('20100610180750'),('20100614142225'),('20100614160819'),('20100614162423'),('20100616132525'),('20100616135507'),('20100622124252'),('20100706105523'),('20100710121447'),('20100710191351'),('20100716155807'),('20100719131622'),('20100721155359'),('20100722124307'),('20100812164444'),('20100812164449'),('20100812164518'),('20100812164524'),('20100817165213'),('20100819175736'),('20100820185846'),('20100906095758'),('20100915145823'),('20100929111549'),('20101001155323'),('99999999999000'),('99999999999900');
/*!40000 ALTER TABLE `schema_migrations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `solar_systems`
--

DROP TABLE IF EXISTS `solar_systems`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `solar_systems` (
  `id` int(11) NOT NULL auto_increment,
  `type` varchar(255) NOT NULL,
  `galaxy_id` int(11) NOT NULL,
  `x` mediumint(9) NOT NULL,
  `y` mediumint(9) NOT NULL,
  PRIMARY KEY  (`id`),
  UNIQUE KEY `uniqueness` (`galaxy_id`,`x`,`y`),
  CONSTRAINT `solar_systems_ibfk_1` FOREIGN KEY (`galaxy_id`) REFERENCES `galaxies` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `solar_systems`
--

LOCK TABLES `solar_systems` WRITE;
/*!40000 ALTER TABLE `solar_systems` DISABLE KEYS */;
INSERT INTO `solar_systems` VALUES (1,'Homeworld',1,0,0),(2,'Resource',1,-2,2),(3,'Expansion',1,1,2),(4,'Expansion',1,-3,-2);
/*!40000 ALTER TABLE `solar_systems` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `technologies`
--

DROP TABLE IF EXISTS `technologies`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `technologies` (
  `id` int(11) NOT NULL auto_increment,
  `last_update` datetime default NULL,
  `upgrade_ends_at` datetime default NULL,
  `pause_remainder` int(10) unsigned default NULL,
  `scientists` int(10) unsigned default '0',
  `level` tinyint(2) unsigned NOT NULL,
  `player_id` int(11) NOT NULL,
  `type` varchar(50) NOT NULL,
  `pause_scientists` int(10) unsigned default NULL,
  PRIMARY KEY  (`id`),
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
  `id` int(11) NOT NULL auto_increment,
  `kind` tinyint(2) unsigned NOT NULL,
  `planet_id` int(11) NOT NULL,
  `x` tinyint(2) unsigned NOT NULL,
  `y` tinyint(2) unsigned NOT NULL,
  PRIMARY KEY  (`id`),
  UNIQUE KEY `uniqueness` (`planet_id`,`x`,`y`),
  CONSTRAINT `tiles_ibfk_1` FOREIGN KEY (`planet_id`) REFERENCES `planets` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=4326 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tiles`
--

LOCK TABLES `tiles` WRITE;
/*!40000 ALTER TABLE `tiles` DISABLE KEYS */;
INSERT INTO `tiles` VALUES (1,0,2,6,0),(2,14,2,12,0),(3,3,2,22,0),(4,3,2,23,0),(5,3,2,24,0),(6,4,2,36,0),(7,4,2,37,0),(8,4,2,38,0),(9,4,2,39,0),(10,4,2,40,0),(11,4,2,41,0),(12,4,2,42,0),(13,4,2,43,0),(14,0,2,3,1),(15,3,2,23,1),(16,3,2,24,1),(17,3,2,25,1),(18,4,2,36,1),(19,4,2,37,1),(20,4,2,38,1),(21,4,2,39,1),(22,4,2,40,1),(23,4,2,41,1),(24,4,2,42,1),(25,4,2,43,1),(26,6,2,18,2),(27,6,2,19,2),(28,6,2,20,2),(29,3,2,23,2),(30,3,2,24,2),(31,3,2,27,2),(32,5,2,29,2),(33,5,2,30,2),(34,4,2,39,2),(35,4,2,40,2),(36,0,2,41,2),(37,4,2,43,2),(38,4,2,44,2),(39,6,2,17,3),(40,6,2,18,3),(41,6,2,19,3),(42,6,2,20,3),(43,6,2,21,3),(44,6,2,22,3),(45,3,2,24,3),(46,3,2,25,3),(47,3,2,26,3),(48,3,2,27,3),(49,3,2,28,3),(50,5,2,29,3),(51,5,2,30,3),(52,5,2,31,3),(53,5,2,33,3),(54,4,2,39,3),(55,4,2,43,3),(56,4,2,44,3),(57,0,2,45,3),(58,6,2,18,4),(59,6,2,19,4),(60,6,2,20,4),(61,3,2,26,4),(62,3,2,27,4),(63,3,2,28,4),(64,5,2,29,4),(65,5,2,30,4),(66,5,2,31,4),(67,5,2,32,4),(68,5,2,33,4),(69,4,2,37,4),(70,4,2,38,4),(71,4,2,39,4),(72,4,2,40,4),(73,4,2,41,4),(74,4,2,42,4),(75,4,2,43,4),(76,4,2,44,4),(77,3,2,25,5),(78,3,2,26,5),(79,3,2,27,5),(80,3,2,28,5),(81,5,2,29,5),(82,5,2,30,5),(83,5,2,31,5),(84,5,2,32,5),(85,4,2,40,5),(86,4,2,41,5),(87,4,2,43,5),(88,4,2,44,5),(89,4,2,45,5),(90,9,2,48,5),(91,2,2,13,6),(92,3,2,24,6),(93,3,2,25,6),(94,3,2,26,6),(95,3,2,27,6),(96,3,2,28,6),(97,3,2,29,6),(98,5,2,30,6),(99,4,2,41,6),(100,4,2,42,6),(101,4,2,43,6),(102,4,2,44,6),(103,4,2,45,6),(104,3,2,20,7),(105,3,2,23,7),(106,3,2,24,7),(107,3,2,25,7),(108,3,2,26,7),(109,3,2,27,7),(110,3,2,28,7),(111,5,2,30,7),(112,4,2,41,7),(113,4,2,42,7),(114,4,2,44,7),(115,6,2,1,8),(116,3,2,20,8),(117,3,2,22,8),(118,3,2,23,8),(119,3,2,24,8),(120,2,2,26,8),(121,3,2,28,8),(122,5,2,38,8),(123,5,2,42,8),(124,7,2,51,8),(125,6,2,1,9),(126,6,2,2,9),(127,3,2,16,9),(128,3,2,17,9),(129,3,2,18,9),(130,3,2,19,9),(131,3,2,20,9),(132,3,2,21,9),(133,3,2,22,9),(134,3,2,23,9),(135,3,2,24,9),(136,3,2,25,9),(137,5,2,38,9),(138,5,2,39,9),(139,5,2,40,9),(140,5,2,42,9),(141,5,2,43,9),(142,7,2,50,9),(143,7,2,51,9),(144,7,2,52,9),(145,6,2,1,10),(146,0,2,13,10),(147,3,2,17,10),(148,3,2,18,10),(149,3,2,19,10),(150,3,2,20,10),(151,3,2,21,10),(152,3,2,22,10),(153,3,2,23,10),(154,3,2,24,10),(155,3,2,25,10),(156,3,2,26,10),(157,3,2,27,10),(158,5,2,33,10),(159,5,2,35,10),(160,5,2,36,10),(161,5,2,39,10),(162,5,2,40,10),(163,5,2,41,10),(164,5,2,42,10),(165,5,2,43,10),(166,7,2,51,10),(167,7,2,52,10),(168,6,2,0,11),(169,6,2,1,11),(170,6,2,2,11),(171,1,2,5,11),(172,0,2,19,11),(173,3,2,22,11),(174,3,2,23,11),(175,3,2,24,11),(176,3,2,26,11),(177,3,2,27,11),(178,5,2,31,11),(179,5,2,32,11),(180,5,2,33,11),(181,5,2,34,11),(182,5,2,35,11),(183,5,2,36,11),(184,12,2,37,11),(185,5,2,43,11),(186,5,2,44,11),(187,5,2,45,11),(188,5,2,46,11),(189,5,2,47,11),(190,10,2,48,11),(191,7,2,52,11),(192,6,2,0,12),(193,6,2,1,12),(194,6,2,2,12),(195,7,2,12,12),(196,7,2,13,12),(197,3,2,21,12),(198,3,2,22,12),(199,3,2,23,12),(200,3,2,24,12),(201,3,2,25,12),(202,5,2,32,12),(203,1,2,33,12),(204,5,2,35,12),(205,4,2,43,12),(206,5,2,44,12),(207,5,2,46,12),(208,7,2,52,12),(209,6,2,2,13),(210,7,2,11,13),(211,7,2,12,13),(212,7,2,13,13),(213,6,2,14,13),(214,6,2,15,13),(215,6,2,16,13),(216,13,2,22,13),(217,5,2,35,13),(218,5,2,36,13),(219,4,2,43,13),(220,4,2,44,13),(221,7,2,52,13),(222,3,2,3,14),(223,3,2,4,14),(224,3,2,5,14),(225,3,2,6,14),(226,3,2,7,14),(227,3,2,8,14),(228,3,2,9,14),(229,7,2,10,14),(230,7,2,11,14),(231,7,2,12,14),(232,7,2,13,14),(233,6,2,14,14),(234,6,2,15,14),(235,6,2,16,14),(236,6,2,17,14),(237,6,2,18,14),(238,5,2,35,14),(239,5,2,36,14),(240,4,2,43,14),(241,4,2,44,14),(242,4,2,45,14),(243,4,2,46,14),(244,4,2,47,14),(245,7,2,52,14),(246,3,2,1,15),(247,3,2,2,15),(248,3,2,3,15),(249,3,2,4,15),(250,3,2,5,15),(251,3,2,6,15),(252,3,2,7,15),(253,7,2,9,15),(254,7,2,10,15),(255,7,2,12,15),(256,7,2,13,15),(257,6,2,14,15),(258,6,2,16,15),(259,6,2,17,15),(260,6,2,18,15),(261,5,2,35,15),(262,5,2,36,15),(263,4,2,43,15),(264,4,2,44,15),(265,4,2,45,15),(266,11,2,46,15),(267,7,2,50,15),(268,7,2,51,15),(269,7,2,52,15),(270,3,2,1,16),(271,3,2,2,16),(272,3,2,3,16),(273,3,2,4,16),(274,3,2,6,16),(275,3,2,7,16),(276,7,2,12,16),(277,7,2,13,16),(278,12,2,18,16),(279,5,2,35,16),(280,5,2,36,16),(281,4,2,43,16),(282,4,2,44,16),(283,4,2,45,16),(284,7,2,50,16),(285,7,2,51,16),(286,7,2,52,16),(287,3,2,1,17),(288,3,2,2,17),(289,3,2,3,17),(290,3,2,4,17),(291,3,2,5,17),(292,3,2,6,17),(293,3,2,7,17),(294,3,2,8,17),(295,3,2,9,17),(296,3,2,10,17),(297,7,2,11,17),(298,7,2,12,17),(299,7,2,13,17),(300,13,2,31,17),(301,4,2,41,17),(302,4,2,42,17),(303,4,2,43,17),(304,4,2,44,17),(305,4,2,45,17),(306,7,2,50,17),(307,7,2,51,17),(308,7,2,52,17),(309,3,2,4,18),(310,3,2,5,18),(311,3,2,6,18),(312,4,2,7,18),(313,4,2,8,18),(314,4,2,9,18),(315,7,2,10,18),(316,7,2,11,18),(317,7,2,12,18),(318,7,2,13,18),(319,7,2,14,18),(320,7,2,15,18),(321,7,2,16,18),(322,4,2,28,18),(323,4,2,30,18),(324,4,2,41,18),(325,4,2,42,18),(326,4,2,43,18),(327,4,2,44,18),(328,4,2,45,18),(329,7,2,50,18),(330,7,2,51,18),(331,7,2,52,18),(332,3,2,3,19),(333,3,2,4,19),(334,4,2,6,19),(335,4,2,7,19),(336,8,2,8,19),(337,7,2,11,19),(338,7,2,13,19),(339,4,2,28,19),(340,4,2,29,19),(341,4,2,30,19),(342,4,2,31,19),(343,4,2,32,19),(344,8,2,43,19),(345,7,2,50,19),(346,7,2,51,19),(347,7,2,52,19),(348,4,2,4,20),(349,4,2,5,20),(350,4,2,7,20),(351,7,2,11,20),(352,4,2,12,20),(353,4,2,13,20),(354,4,2,29,20),(355,4,2,30,20),(356,4,2,31,20),(357,4,2,32,20),(358,7,2,50,20),(359,5,2,51,20),(360,7,2,52,20),(361,4,2,4,21),(362,4,2,5,21),(363,4,2,6,21),(364,4,2,7,21),(365,4,2,13,21),(366,4,2,29,21),(367,4,2,30,21),(368,4,2,31,21),(369,4,2,32,21),(370,4,2,33,21),(371,4,2,34,21),(372,4,2,35,21),(373,5,2,46,21),(374,5,2,47,21),(375,5,2,48,21),(376,5,2,49,21),(377,5,2,50,21),(378,5,2,51,21),(379,5,2,52,21),(380,4,2,5,22),(381,7,2,6,22),(382,4,2,7,22),(383,4,2,8,22),(384,4,2,9,22),(385,4,2,10,22),(386,4,2,11,22),(387,4,2,12,22),(388,4,2,13,22),(389,4,2,14,22),(390,4,2,26,22),(391,4,2,27,22),(392,4,2,28,22),(393,4,2,29,22),(394,4,2,30,22),(395,4,2,31,22),(396,5,2,42,22),(397,5,2,43,22),(398,5,2,44,22),(399,5,2,45,22),(400,5,2,46,22),(401,5,2,47,22),(402,5,2,48,22),(403,5,2,49,22),(404,5,2,50,22),(405,5,2,51,22),(406,5,2,52,22),(407,5,7,2,0),(408,5,7,3,0),(409,5,7,4,0),(410,5,7,5,0),(411,5,7,6,0),(412,5,7,7,0),(413,4,7,16,0),(414,4,7,17,0),(415,4,7,18,0),(416,0,7,32,0),(417,7,7,36,0),(418,7,7,37,0),(419,7,7,38,0),(420,7,7,39,0),(421,1,7,40,0),(422,5,7,45,0),(423,5,7,46,0),(424,5,7,48,0),(425,5,7,49,0),(426,5,7,2,1),(427,5,7,3,1),(428,5,7,4,1),(429,5,7,5,1),(430,5,7,6,1),(431,5,7,7,1),(432,5,7,8,1),(433,4,7,13,1),(434,4,7,16,1),(435,4,7,17,1),(436,4,7,18,1),(437,7,7,35,1),(438,7,7,36,1),(439,7,7,37,1),(440,7,7,38,1),(441,7,7,39,1),(442,5,7,45,1),(443,5,7,46,1),(444,5,7,47,1),(445,5,7,48,1),(446,5,7,49,1),(447,5,7,3,2),(448,5,7,4,2),(449,5,7,5,2),(450,5,7,6,2),(451,5,7,7,2),(452,4,7,10,2),(453,4,7,13,2),(454,4,7,14,2),(455,4,7,15,2),(456,4,7,16,2),(457,4,7,17,2),(458,5,7,18,2),(459,12,7,19,2),(460,7,7,32,2),(461,7,7,33,2),(462,7,7,34,2),(463,7,7,35,2),(464,7,7,36,2),(465,7,7,37,2),(466,7,7,38,2),(467,7,7,39,2),(468,5,7,45,2),(469,5,7,46,2),(470,5,7,47,2),(471,5,7,48,2),(472,5,7,49,2),(473,5,7,50,2),(474,5,7,0,3),(475,5,7,1,3),(476,5,7,2,3),(477,5,7,3,3),(478,5,7,4,3),(479,5,7,5,3),(480,5,7,6,3),(481,4,7,10,3),(482,4,7,11,3),(483,4,7,12,3),(484,4,7,13,3),(485,4,7,14,3),(486,4,7,15,3),(487,4,7,16,3),(488,4,7,17,3),(489,5,7,18,3),(490,7,7,35,3),(491,7,7,39,3),(492,5,7,45,3),(493,5,7,46,3),(494,5,7,47,3),(495,5,7,48,3),(496,5,7,49,3),(497,5,7,50,3),(498,5,7,2,4),(499,5,7,3,4),(500,5,7,4,4),(501,5,7,5,4),(502,5,7,6,4),(503,5,7,7,4),(504,8,7,9,4),(505,4,7,12,4),(506,4,7,14,4),(507,4,7,15,4),(508,4,7,16,4),(509,4,7,17,4),(510,5,7,18,4),(511,8,7,25,4),(512,7,7,35,4),(513,3,7,36,4),(514,3,7,37,4),(515,3,7,38,4),(516,7,7,39,4),(517,7,7,41,4),(518,5,7,46,4),(519,5,7,47,4),(520,5,7,48,4),(521,5,7,49,4),(522,5,7,3,5),(523,5,7,4,5),(524,5,7,5,5),(525,5,7,6,5),(526,4,7,12,5),(527,4,7,13,5),(528,4,7,14,5),(529,4,7,15,5),(530,4,7,16,5),(531,5,7,17,5),(532,5,7,18,5),(533,3,7,37,5),(534,7,7,38,5),(535,7,7,39,5),(536,7,7,40,5),(537,7,7,41,5),(538,5,7,47,5),(539,5,7,6,6),(540,4,7,12,6),(541,4,7,13,6),(542,5,7,14,6),(543,5,7,15,6),(544,5,7,16,6),(545,5,7,17,6),(546,5,7,18,6),(547,3,7,37,6),(548,5,7,46,6),(549,5,7,47,6),(550,5,7,48,6),(551,5,7,49,6),(552,13,7,13,7),(553,3,7,35,7),(554,3,7,36,7),(555,3,7,37,7),(556,3,7,40,7),(557,5,7,46,7),(558,5,7,47,7),(559,5,7,49,7),(560,3,7,35,8),(561,3,7,36,8),(562,3,7,37,8),(563,3,7,38,8),(564,3,7,39,8),(565,3,7,40,8),(566,6,7,43,8),(567,5,7,47,8),(568,6,7,10,9),(569,7,7,13,9),(570,7,7,14,9),(571,4,7,36,9),(572,3,7,37,9),(573,3,7,38,9),(574,3,7,40,9),(575,3,7,41,9),(576,6,7,42,9),(577,6,7,43,9),(578,10,7,0,10),(579,6,7,10,10),(580,6,7,11,10),(581,7,7,13,10),(582,7,7,14,10),(583,7,7,15,10),(584,0,7,16,10),(585,4,7,36,10),(586,3,7,37,10),(587,3,7,39,10),(588,3,7,40,10),(589,3,7,41,10),(590,6,7,42,10),(591,6,7,43,10),(592,6,7,44,10),(593,6,7,45,10),(594,6,7,46,10),(595,3,7,49,10),(596,3,7,50,10),(597,6,7,7,11),(598,6,7,8,11),(599,6,7,9,11),(600,6,7,10,11),(601,6,7,11,11),(602,7,7,12,11),(603,7,7,13,11),(604,7,7,14,11),(605,7,7,15,11),(606,0,7,21,11),(607,4,7,35,11),(608,4,7,36,11),(609,4,7,37,11),(610,3,7,39,11),(611,3,7,40,11),(612,3,7,41,11),(613,6,7,42,11),(614,6,7,43,11),(615,6,7,44,11),(616,6,7,45,11),(617,3,7,46,11),(618,3,7,47,11),(619,3,7,48,11),(620,3,7,49,11),(621,3,7,50,11),(622,6,7,6,12),(623,6,7,7,12),(624,6,7,9,12),(625,6,7,11,12),(626,6,7,12,12),(627,7,7,13,12),(628,7,7,14,12),(629,7,7,15,12),(630,7,7,16,12),(631,7,7,17,12),(632,4,7,36,12),(633,4,7,37,12),(634,4,7,38,12),(635,3,7,39,12),(636,3,7,40,12),(637,3,7,41,12),(638,3,7,42,12),(639,3,7,43,12),(640,3,7,44,12),(641,3,7,45,12),(642,3,7,46,12),(643,3,7,47,12),(644,3,7,48,12),(645,3,7,49,12),(646,3,7,50,12),(647,13,7,6,13),(648,7,7,14,13),(649,7,7,15,13),(650,7,7,16,13),(651,7,7,17,13),(652,7,7,18,13),(653,7,7,19,13),(654,4,7,34,13),(655,4,7,36,13),(656,4,7,37,13),(657,4,7,38,13),(658,4,7,39,13),(659,3,7,40,13),(660,3,7,41,13),(661,3,7,42,13),(662,3,7,46,13),(663,3,7,47,13),(664,3,7,48,13),(665,3,7,49,13),(666,6,7,1,14),(667,6,7,2,14),(668,6,7,3,14),(669,6,7,4,14),(670,6,7,5,14),(671,7,7,12,14),(672,7,7,13,14),(673,7,7,14,14),(674,5,7,15,14),(675,5,7,16,14),(676,7,7,18,14),(677,0,7,19,14),(678,3,7,27,14),(679,3,7,28,14),(680,4,7,34,14),(681,4,7,35,14),(682,4,7,36,14),(683,4,7,37,14),(684,4,7,38,14),(685,3,7,39,14),(686,3,7,40,14),(687,3,7,41,14),(688,3,7,42,14),(689,3,7,43,14),(690,3,7,48,14),(691,3,7,49,14),(692,6,7,1,15),(693,6,7,3,15),(694,6,7,4,15),(695,5,7,10,15),(696,5,7,12,15),(697,5,7,13,15),(698,7,7,14,15),(699,5,7,15,15),(700,3,7,25,15),(701,3,7,27,15),(702,0,7,28,15),(703,4,7,35,15),(704,4,7,36,15),(705,4,7,37,15),(706,4,7,38,15),(707,4,7,39,15),(708,3,7,40,15),(709,3,7,41,15),(710,3,7,42,15),(711,6,7,0,16),(712,6,7,1,16),(713,6,7,2,16),(714,5,7,4,16),(715,5,7,5,16),(716,5,7,6,16),(717,5,7,7,16),(718,5,7,10,16),(719,5,7,11,16),(720,5,7,12,16),(721,5,7,13,16),(722,5,7,14,16),(723,5,7,15,16),(724,5,7,16,16),(725,4,7,19,16),(726,4,7,20,16),(727,3,7,23,16),(728,3,7,24,16),(729,3,7,25,16),(730,3,7,26,16),(731,3,7,27,16),(732,4,7,35,16),(733,4,7,36,16),(734,4,7,37,16),(735,4,7,38,16),(736,4,7,39,16),(737,3,7,40,16),(738,3,7,41,16),(739,6,7,0,17),(740,5,7,2,17),(741,5,7,3,17),(742,5,7,4,17),(743,5,7,5,17),(744,5,7,6,17),(745,5,7,9,17),(746,5,7,10,17),(747,5,7,12,17),(748,5,7,13,17),(749,5,7,14,17),(750,5,7,16,17),(751,4,7,19,17),(752,4,7,20,17),(753,3,7,25,17),(754,3,7,27,17),(755,3,7,28,17),(756,3,7,29,17),(757,3,7,30,17),(758,3,7,31,17),(759,4,7,36,17),(760,4,7,37,17),(761,3,7,41,17),(762,6,7,45,17),(763,6,7,46,17),(764,5,7,2,18),(765,5,7,3,18),(766,5,7,4,18),(767,5,7,5,18),(768,5,7,6,18),(769,5,7,8,18),(770,5,7,10,18),(771,5,7,11,18),(772,5,7,12,18),(773,5,7,13,18),(774,5,7,14,18),(775,5,7,16,18),(776,4,7,18,18),(777,4,7,19,18),(778,14,7,20,18),(779,3,7,26,18),(780,3,7,27,18),(781,3,7,29,18),(782,4,7,36,18),(783,4,7,37,18),(784,3,7,39,18),(785,3,7,40,18),(786,3,7,41,18),(787,6,7,44,18),(788,6,7,45,18),(789,6,7,46,18),(790,6,7,47,18),(791,5,7,1,19),(792,5,7,2,19),(793,5,7,3,19),(794,5,7,4,19),(795,5,7,5,19),(796,5,7,6,19),(797,5,7,8,19),(798,5,7,9,19),(799,11,7,10,19),(800,5,7,16,19),(801,4,7,17,19),(802,4,7,18,19),(803,4,7,19,19),(804,3,7,25,19),(805,3,7,26,19),(806,3,7,29,19),(807,4,7,32,19),(808,4,7,33,19),(809,4,7,37,19),(810,4,7,38,19),(811,12,7,39,19),(812,6,7,45,19),(813,6,7,47,19),(814,5,7,4,20),(815,5,7,5,20),(816,5,7,6,20),(817,5,7,7,20),(818,5,7,8,20),(819,3,7,9,20),(820,4,7,18,20),(821,4,7,19,20),(822,3,7,26,20),(823,3,7,27,20),(824,4,7,28,20),(825,4,7,29,20),(826,4,7,32,20),(827,4,7,33,20),(828,4,7,34,20),(829,4,7,37,20),(830,6,7,45,20),(831,6,7,46,20),(832,6,7,47,20),(833,5,7,3,21),(834,5,7,4,21),(835,5,7,5,21),(836,5,7,6,21),(837,3,7,7,21),(838,5,7,8,21),(839,3,7,9,21),(840,4,7,15,21),(841,4,7,16,21),(842,4,7,17,21),(843,4,7,18,21),(844,4,7,19,21),(845,3,7,26,21),(846,4,7,28,21),(847,4,7,29,21),(848,4,7,30,21),(849,4,7,31,21),(850,4,7,32,21),(851,4,7,33,21),(852,4,7,34,21),(853,2,7,35,21),(854,0,7,37,21),(855,6,7,46,21),(856,6,7,47,21),(857,5,7,3,22),(858,5,7,4,22),(859,0,7,5,22),(860,3,7,7,22),(861,3,7,9,22),(862,4,7,14,22),(863,4,7,15,22),(864,4,7,17,22),(865,4,7,18,22),(866,9,7,19,22),(867,4,7,29,22),(868,4,7,30,22),(869,4,7,31,22),(870,4,7,33,22),(871,4,7,34,22),(872,3,7,3,23),(873,5,7,4,23),(874,3,7,7,23),(875,3,7,8,23),(876,3,7,9,23),(877,4,7,14,23),(878,4,7,15,23),(879,4,7,16,23),(880,4,7,17,23),(881,4,7,18,23),(882,4,7,29,23),(883,4,7,30,23),(884,4,7,31,23),(885,4,7,32,23),(886,4,7,33,23),(887,4,7,35,23),(888,4,7,36,23),(889,3,7,3,24),(890,3,7,4,24),(891,3,7,5,24),(892,3,7,6,24),(893,3,7,7,24),(894,3,7,8,24),(895,3,7,9,24),(896,4,7,14,24),(897,4,7,15,24),(898,4,7,16,24),(899,4,7,17,24),(900,4,7,18,24),(901,4,7,32,24),(902,4,7,33,24),(903,4,7,34,24),(904,4,7,35,24),(905,3,7,3,25),(906,3,7,4,25),(907,3,7,6,25),(908,3,7,7,25),(909,3,7,8,25),(910,3,7,9,25),(911,3,7,10,25),(912,3,7,11,25),(913,4,7,13,25),(914,4,7,14,25),(915,4,7,15,25),(916,6,7,16,25),(917,4,7,17,25),(918,4,7,18,25),(919,4,7,31,25),(920,4,7,32,25),(921,4,7,33,25),(922,4,7,34,25),(923,4,7,35,25),(924,4,10,3,0),(925,4,10,4,0),(926,4,10,5,0),(927,4,10,6,0),(928,0,10,7,0),(929,3,10,18,0),(930,3,10,19,0),(931,3,10,20,0),(932,3,10,21,0),(933,3,10,22,0),(934,3,10,23,0),(935,6,10,28,0),(936,4,10,3,1),(937,4,10,4,1),(938,4,10,5,1),(939,4,10,6,1),(940,4,10,9,1),(941,4,10,10,1),(942,4,10,11,1),(943,4,10,12,1),(944,3,10,20,1),(945,3,10,21,1),(946,3,10,22,1),(947,3,10,23,1),(948,3,10,24,1),(949,6,10,28,1),(950,6,10,31,1),(951,11,10,38,1),(952,4,10,4,2),(953,4,10,5,2),(954,4,10,6,2),(955,4,10,7,2),(956,4,10,8,2),(957,4,10,9,2),(958,4,10,11,2),(959,3,10,19,2),(960,3,10,20,2),(961,3,10,21,2),(962,6,10,28,2),(963,6,10,29,2),(964,6,10,30,2),(965,6,10,31,2),(966,6,10,32,2),(967,6,10,33,2),(968,4,10,2,3),(969,4,10,3,3),(970,4,10,4,3),(971,4,10,5,3),(972,4,10,6,3),(973,4,10,9,3),(974,4,10,10,3),(975,4,10,11,3),(976,4,10,12,3),(977,0,10,13,3),(978,3,10,19,3),(979,3,10,20,3),(980,3,10,21,3),(981,3,10,22,3),(982,3,10,23,3),(983,8,10,25,3),(984,6,10,29,3),(985,4,10,0,4),(986,4,10,1,4),(987,4,10,2,4),(988,4,10,3,4),(989,4,10,4,4),(990,4,10,5,4),(991,4,10,7,4),(992,4,10,8,4),(993,4,10,9,4),(994,4,10,11,4),(995,4,10,12,4),(996,3,10,20,4),(997,3,10,22,4),(998,3,10,23,4),(999,4,10,1,5),(1000,4,10,3,5),(1001,4,10,4,5),(1002,4,10,5,5),(1003,4,10,6,5),(1004,4,10,7,5),(1005,4,10,8,5),(1006,4,10,9,5),(1007,3,10,21,5),(1008,3,10,22,5),(1009,3,10,23,5),(1010,3,10,24,5),(1011,4,10,5,6),(1012,4,10,6,6),(1013,4,10,7,6),(1014,4,10,8,6),(1015,3,10,21,6),(1016,3,10,22,6),(1017,3,10,23,6),(1018,3,10,24,6),(1019,4,10,5,7),(1020,4,10,6,7),(1021,4,10,7,7),(1022,4,10,8,7),(1023,4,10,9,7),(1024,3,10,22,7),(1025,3,10,23,7),(1026,6,10,18,8),(1027,6,10,19,8),(1028,3,10,23,8),(1029,3,10,24,8),(1030,3,10,10,9),(1031,3,10,11,9),(1032,6,10,13,9),(1033,6,10,14,9),(1034,6,10,15,9),(1035,6,10,16,9),(1036,6,10,17,9),(1037,6,10,18,9),(1038,6,10,19,9),(1039,6,10,20,9),(1040,1,10,21,9),(1041,3,10,23,9),(1042,14,10,30,9),(1043,3,10,10,10),(1044,6,10,13,10),(1045,6,10,14,10),(1046,6,10,15,10),(1047,6,10,16,10),(1048,6,10,17,10),(1049,6,10,19,10),(1050,0,10,25,10),(1051,0,10,40,10),(1052,3,10,9,11),(1053,3,10,10,11),(1054,3,10,11,11),(1055,6,10,14,11),(1056,6,10,15,11),(1057,6,10,16,11),(1058,6,10,19,11),(1059,7,10,1,12),(1060,7,10,2,12),(1061,7,10,3,12),(1062,3,10,9,12),(1063,3,10,10,12),(1064,3,10,11,12),(1065,3,10,12,12),(1066,7,10,1,13),(1067,7,10,2,13),(1068,7,10,3,13),(1069,7,10,4,13),(1070,3,10,8,13),(1071,3,10,9,13),(1072,3,10,10,13),(1073,3,10,11,13),(1074,3,10,12,13),(1075,0,10,31,13),(1076,5,10,41,13),(1077,7,10,0,14),(1078,7,10,1,14),(1079,7,10,3,14),(1080,3,10,8,14),(1081,3,10,9,14),(1082,3,10,11,14),(1083,3,10,12,14),(1084,3,10,13,14),(1085,6,10,22,14),(1086,5,10,41,14),(1087,7,10,1,15),(1088,7,10,2,15),(1089,7,10,3,15),(1090,7,10,4,15),(1091,3,10,8,15),(1092,3,10,9,15),(1093,3,10,10,15),(1094,3,10,11,15),(1095,3,10,12,15),(1096,3,10,13,15),(1097,6,10,22,15),(1098,6,10,23,15),(1099,3,10,26,15),(1100,0,10,35,15),(1101,5,10,40,15),(1102,5,10,41,15),(1103,7,10,0,16),(1104,7,10,1,16),(1105,7,10,2,16),(1106,7,10,3,16),(1107,7,10,4,16),(1108,3,10,8,16),(1109,3,10,9,16),(1110,5,10,10,16),(1111,3,10,11,16),(1112,3,10,12,16),(1113,5,10,15,16),(1114,6,10,19,16),(1115,6,10,20,16),(1116,6,10,21,16),(1117,6,10,22,16),(1118,3,10,26,16),(1119,3,10,27,16),(1120,3,10,28,16),(1121,3,10,29,16),(1122,3,10,30,16),(1123,5,10,41,16),(1124,5,10,42,16),(1125,7,10,1,17),(1126,7,10,2,17),(1127,7,10,4,17),(1128,7,10,5,17),(1129,3,10,9,17),(1130,5,10,10,17),(1131,3,10,11,17),(1132,5,10,15,17),(1133,5,10,16,17),(1134,6,10,19,17),(1135,6,10,20,17),(1136,6,10,21,17),(1137,3,10,26,17),(1138,3,10,27,17),(1139,3,10,28,17),(1140,3,10,29,17),(1141,3,10,30,17),(1142,0,10,34,17),(1143,0,10,36,17),(1144,5,10,38,17),(1145,5,10,40,17),(1146,5,10,41,17),(1147,7,10,0,18),(1148,7,10,1,18),(1149,7,10,2,18),(1150,7,10,4,18),(1151,3,10,9,18),(1152,5,10,10,18),(1153,3,10,11,18),(1154,5,10,12,18),(1155,5,10,13,18),(1156,5,10,14,18),(1157,5,10,15,18),(1158,5,10,16,18),(1159,5,10,17,18),(1160,3,10,23,18),(1161,3,10,24,18),(1162,3,10,25,18),(1163,3,10,27,18),(1164,3,10,28,18),(1165,5,10,38,18),(1166,5,10,39,18),(1167,5,10,40,18),(1168,5,10,41,18),(1169,5,10,42,18),(1170,7,10,0,19),(1171,7,10,2,19),(1172,7,10,3,19),(1173,7,10,4,19),(1174,7,10,5,19),(1175,3,10,9,19),(1176,5,10,10,19),(1177,5,10,11,19),(1178,5,10,12,19),(1179,5,10,14,19),(1180,5,10,15,19),(1181,5,10,17,19),(1182,3,10,22,19),(1183,3,10,23,19),(1184,3,10,24,19),(1185,3,10,25,19),(1186,3,10,26,19),(1187,3,10,27,19),(1188,3,10,28,19),(1189,3,10,29,19),(1190,3,10,30,19),(1191,5,10,35,19),(1192,5,10,36,19),(1193,5,10,37,19),(1194,5,10,38,19),(1195,5,10,39,19),(1196,5,10,40,19),(1197,5,10,41,19),(1198,5,10,42,19),(1199,7,10,3,20),(1200,5,10,9,20),(1201,5,10,10,20),(1202,5,10,11,20),(1203,5,10,12,20),(1204,5,10,13,20),(1205,5,10,14,20),(1206,5,10,15,20),(1207,5,10,16,20),(1208,5,10,17,20),(1209,3,10,24,20),(1210,3,10,25,20),(1211,3,10,26,20),(1212,3,10,27,20),(1213,3,10,28,20),(1214,5,10,35,20),(1215,5,10,36,20),(1216,5,10,37,20),(1217,5,10,38,20),(1218,5,10,39,20),(1219,5,10,40,20),(1220,5,10,41,20),(1221,5,10,42,20),(1222,7,10,3,21),(1223,2,10,8,21),(1224,5,10,10,21),(1225,5,10,11,21),(1226,14,10,12,21),(1227,5,10,15,21),(1228,5,10,16,21),(1229,5,10,17,21),(1230,5,10,18,21),(1231,5,10,23,21),(1232,3,10,24,21),(1233,3,10,25,21),(1234,2,10,26,21),(1235,3,10,28,21),(1236,3,10,29,21),(1237,7,10,30,21),(1238,9,10,32,21),(1239,5,10,36,21),(1240,5,10,37,21),(1241,5,10,38,21),(1242,5,10,39,21),(1243,1,10,40,21),(1244,5,10,42,21),(1245,7,10,1,22),(1246,7,10,2,22),(1247,7,10,3,22),(1248,7,10,4,22),(1249,5,10,10,22),(1250,5,10,11,22),(1251,5,10,15,22),(1252,5,10,16,22),(1253,5,10,17,22),(1254,5,10,22,22),(1255,5,10,23,22),(1256,3,10,24,22),(1257,5,10,25,22),(1258,7,10,28,22),(1259,7,10,29,22),(1260,7,10,30,22),(1261,6,10,31,22),(1262,5,10,36,22),(1263,5,10,37,22),(1264,5,10,38,22),(1265,5,10,39,22),(1266,5,10,42,22),(1267,5,10,10,23),(1268,5,10,11,23),(1269,5,10,22,23),(1270,5,10,23,23),(1271,5,10,24,23),(1272,5,10,25,23),(1273,5,10,26,23),(1274,7,10,27,23),(1275,7,10,28,23),(1276,6,10,29,23),(1277,6,10,30,23),(1278,6,10,31,23),(1279,12,10,36,23),(1280,5,10,11,24),(1281,5,10,20,24),(1282,5,10,21,24),(1283,5,10,22,24),(1284,5,10,23,24),(1285,5,10,24,24),(1286,5,10,25,24),(1287,5,10,26,24),(1288,5,10,27,24),(1289,7,10,28,24),(1290,6,10,29,24),(1291,4,10,0,25),(1292,4,10,4,25),(1293,4,10,5,25),(1294,10,10,13,25),(1295,5,10,19,25),(1296,5,10,20,25),(1297,5,10,21,25),(1298,5,10,22,25),(1299,5,10,23,25),(1300,5,10,24,25),(1301,5,10,26,25),(1302,5,10,27,25),(1303,7,10,28,25),(1304,6,10,29,25),(1305,4,10,0,26),(1306,4,10,1,26),(1307,4,10,5,26),(1308,4,10,6,26),(1309,5,10,22,26),(1310,5,10,23,26),(1311,5,10,24,26),(1312,5,10,25,26),(1313,5,10,26,26),(1314,5,10,27,26),(1315,7,10,28,26),(1316,7,10,29,26),(1317,13,10,30,26),(1318,4,10,1,27),(1319,4,10,2,27),(1320,4,10,3,27),(1321,4,10,5,27),(1322,4,10,6,27),(1323,5,10,22,27),(1324,5,10,23,27),(1325,5,10,24,27),(1326,7,10,25,27),(1327,7,10,26,27),(1328,5,10,27,27),(1329,7,10,28,27),(1330,7,10,29,27),(1331,4,10,1,28),(1332,4,10,2,28),(1333,4,10,3,28),(1334,4,10,4,28),(1335,4,10,5,28),(1336,4,10,6,28),(1337,4,10,7,28),(1338,4,10,8,28),(1339,5,10,20,28),(1340,5,10,21,28),(1341,5,10,22,28),(1342,5,10,24,28),(1343,7,10,25,28),(1344,7,10,26,28),(1345,7,10,27,28),(1346,7,10,28,28),(1347,7,10,29,28),(1348,7,10,30,28),(1349,7,10,31,28),(1350,7,10,32,28),(1351,7,10,33,28),(1352,7,10,34,28),(1353,7,10,35,28),(1354,4,10,0,29),(1355,4,10,1,29),(1356,4,10,2,29),(1357,4,10,3,29),(1358,4,10,4,29),(1359,4,10,5,29),(1360,4,10,6,29),(1361,4,10,8,29),(1362,5,10,22,29),(1363,5,10,24,29),(1364,7,10,25,29),(1365,7,10,26,29),(1366,7,10,27,29),(1367,7,10,28,29),(1368,7,10,29,29),(1369,7,10,30,29),(1370,7,10,31,29),(1371,7,10,32,29),(1372,7,10,33,29),(1373,7,10,34,29),(1374,7,10,35,29),(1375,7,10,36,29),(1376,4,17,33,0),(1377,4,17,34,0),(1378,4,17,35,0),(1379,4,17,36,0),(1380,4,17,37,0),(1381,4,17,38,0),(1382,4,17,39,0),(1383,4,17,40,0),(1384,4,17,41,0),(1385,7,17,3,1),(1386,3,17,30,1),(1387,3,17,31,1),(1388,4,17,32,1),(1389,4,17,33,1),(1390,4,17,34,1),(1391,4,17,36,1),(1392,4,17,37,1),(1393,4,17,38,1),(1394,4,17,39,1),(1395,5,17,45,1),(1396,7,17,3,2),(1397,5,17,7,2),(1398,5,17,8,2),(1399,5,17,9,2),(1400,5,17,10,2),(1401,4,17,19,2),(1402,4,17,20,2),(1403,4,17,22,2),(1404,4,17,24,2),(1405,4,17,25,2),(1406,3,17,31,2),(1407,3,17,32,2),(1408,3,17,33,2),(1409,4,17,34,2),(1410,4,17,38,2),(1411,4,17,39,2),(1412,5,17,42,2),(1413,5,17,44,2),(1414,5,17,45,2),(1415,5,17,46,2),(1416,5,17,47,2),(1417,5,17,48,2),(1418,7,17,3,3),(1419,5,17,7,3),(1420,5,17,10,3),(1421,4,17,20,3),(1422,4,17,21,3),(1423,4,17,22,3),(1424,4,17,23,3),(1425,4,17,24,3),(1426,7,17,25,3),(1427,3,17,30,3),(1428,3,17,31,3),(1429,3,17,32,3),(1430,3,17,33,3),(1431,3,17,34,3),(1432,5,17,40,3),(1433,5,17,41,3),(1434,5,17,42,3),(1435,5,17,43,3),(1436,5,17,44,3),(1437,5,17,45,3),(1438,7,17,2,4),(1439,7,17,3,4),(1440,7,17,4,4),(1441,7,17,5,4),(1442,5,17,6,4),(1443,5,17,7,4),(1444,5,17,8,4),(1445,5,17,9,4),(1446,5,17,10,4),(1447,5,17,11,4),(1448,4,17,21,4),(1449,4,17,22,4),(1450,4,17,23,4),(1451,4,17,24,4),(1452,7,17,25,4),(1453,7,17,26,4),(1454,7,17,27,4),(1455,7,17,28,4),(1456,3,17,29,4),(1457,3,17,30,4),(1458,3,17,31,4),(1459,3,17,32,4),(1460,3,17,33,4),(1461,13,17,34,4),(1462,5,17,42,4),(1463,5,17,45,4),(1464,5,17,46,4),(1465,7,17,1,5),(1466,7,17,2,5),(1467,7,17,3,5),(1468,7,17,4,5),(1469,1,17,6,5),(1470,5,17,8,5),(1471,5,17,9,5),(1472,5,17,10,5),(1473,5,17,11,5),(1474,4,17,21,5),(1475,4,17,22,5),(1476,4,17,23,5),(1477,7,17,26,5),(1478,7,17,27,5),(1479,7,17,28,5),(1480,3,17,29,5),(1481,3,17,30,5),(1482,3,17,42,5),(1483,7,17,0,6),(1484,7,17,1,6),(1485,7,17,2,6),(1486,7,17,3,6),(1487,7,17,4,6),(1488,5,17,8,6),(1489,10,17,9,6),(1490,0,17,13,6),(1491,4,17,21,6),(1492,4,17,23,6),(1493,7,17,25,6),(1494,7,17,26,6),(1495,7,17,27,6),(1496,7,17,28,6),(1497,7,17,29,6),(1498,3,17,30,6),(1499,3,17,31,6),(1500,4,17,39,6),(1501,3,17,42,6),(1502,7,17,0,7),(1503,7,17,1,7),(1504,7,17,2,7),(1505,7,17,3,7),(1506,4,17,4,7),(1507,5,17,8,7),(1508,7,17,22,7),(1509,7,17,23,7),(1510,7,17,24,7),(1511,7,17,25,7),(1512,7,17,26,7),(1513,7,17,28,7),(1514,7,17,29,7),(1515,3,17,30,7),(1516,4,17,39,7),(1517,3,17,42,7),(1518,3,17,44,7),(1519,3,17,45,7),(1520,4,17,47,7),(1521,4,17,48,7),(1522,7,17,0,8),(1523,7,17,1,8),(1524,7,17,2,8),(1525,7,17,3,8),(1526,4,17,4,8),(1527,4,17,5,8),(1528,5,17,18,8),(1529,5,17,19,8),(1530,5,17,21,8),(1531,5,17,22,8),(1532,7,17,23,8),(1533,7,17,25,8),(1534,7,17,26,8),(1535,7,17,27,8),(1536,7,17,28,8),(1537,7,17,29,8),(1538,3,17,30,8),(1539,3,17,31,8),(1540,4,17,39,8),(1541,4,17,40,8),(1542,4,17,41,8),(1543,3,17,42,8),(1544,3,17,43,8),(1545,3,17,44,8),(1546,3,17,45,8),(1547,4,17,47,8),(1548,4,17,48,8),(1549,4,17,49,8),(1550,7,17,0,9),(1551,7,17,2,9),(1552,7,17,3,9),(1553,4,17,4,9),(1554,0,17,7,9),(1555,5,17,18,9),(1556,5,17,19,9),(1557,5,17,21,9),(1558,5,17,22,9),(1559,7,17,23,9),(1560,7,17,25,9),(1561,11,17,26,9),(1562,2,17,30,9),(1563,4,17,38,9),(1564,4,17,39,9),(1565,4,17,40,9),(1566,4,17,41,9),(1567,3,17,43,9),(1568,3,17,44,9),(1569,4,17,47,9),(1570,4,17,48,9),(1571,4,17,49,9),(1572,4,17,50,9),(1573,4,17,1,10),(1574,4,17,2,10),(1575,4,17,3,10),(1576,4,17,4,10),(1577,5,17,16,10),(1578,5,17,17,10),(1579,5,17,18,10),(1580,5,17,19,10),(1581,5,17,20,10),(1582,5,17,21,10),(1583,0,17,37,10),(1584,4,17,39,10),(1585,4,17,40,10),(1586,4,17,41,10),(1587,4,17,42,10),(1588,3,17,43,10),(1589,3,17,44,10),(1590,4,17,46,10),(1591,4,17,47,10),(1592,4,17,48,10),(1593,4,17,49,10),(1594,4,17,50,10),(1595,4,17,51,10),(1596,4,17,52,10),(1597,0,17,0,11),(1598,4,17,2,11),(1599,4,17,3,11),(1600,4,17,4,11),(1601,12,17,7,11),(1602,5,17,17,11),(1603,6,17,18,11),(1604,5,17,19,11),(1605,5,17,20,11),(1606,5,17,22,11),(1607,5,17,23,11),(1608,5,17,24,11),(1609,4,17,41,11),(1610,4,17,42,11),(1611,4,17,43,11),(1612,3,17,44,11),(1613,3,17,45,11),(1614,3,17,46,11),(1615,5,17,47,11),(1616,5,17,48,11),(1617,5,17,49,11),(1618,4,17,50,11),(1619,4,17,51,11),(1620,4,17,4,12),(1621,4,17,5,12),(1622,4,17,6,12),(1623,6,17,15,12),(1624,6,17,16,12),(1625,6,17,18,12),(1626,6,17,19,12),(1627,5,17,20,12),(1628,5,17,23,12),(1629,4,17,40,12),(1630,4,17,41,12),(1631,4,17,42,12),(1632,3,17,43,12),(1633,3,17,45,12),(1634,3,17,46,12),(1635,5,17,47,12),(1636,5,17,48,12),(1637,5,17,49,12),(1638,5,17,50,12),(1639,4,17,51,12),(1640,0,17,2,13),(1641,4,17,4,13),(1642,4,17,5,13),(1643,6,17,15,13),(1644,6,17,16,13),(1645,6,17,17,13),(1646,6,17,18,13),(1647,6,17,19,13),(1648,5,17,22,13),(1649,5,17,23,13),(1650,5,17,24,13),(1651,0,17,34,13),(1652,14,17,36,13),(1653,6,17,39,13),(1654,3,17,43,13),(1655,3,17,44,13),(1656,3,17,45,13),(1657,5,17,46,13),(1658,5,17,47,13),(1659,5,17,48,13),(1660,3,17,49,13),(1661,0,17,52,13),(1662,4,17,4,14),(1663,3,17,14,14),(1664,3,17,15,14),(1665,6,17,16,14),(1666,3,17,17,14),(1667,5,17,23,14),(1668,5,17,24,14),(1669,6,17,39,14),(1670,6,17,40,14),(1671,5,17,44,14),(1672,5,17,45,14),(1673,5,17,46,14),(1674,5,17,47,14),(1675,3,17,48,14),(1676,3,17,49,14),(1677,4,17,4,15),(1678,4,17,5,15),(1679,3,17,15,15),(1680,3,17,16,15),(1681,3,17,17,15),(1682,5,17,22,15),(1683,5,17,23,15),(1684,13,17,26,15),(1685,6,17,39,15),(1686,6,17,40,15),(1687,6,17,41,15),(1688,6,17,42,15),(1689,5,17,45,15),(1690,5,17,46,15),(1691,3,17,47,15),(1692,3,17,48,15),(1693,3,17,49,15),(1694,3,17,13,16),(1695,3,17,14,16),(1696,3,17,15,16),(1697,3,17,16,16),(1698,5,17,21,16),(1699,5,17,22,16),(1700,5,17,23,16),(1701,5,17,24,16),(1702,5,17,25,16),(1703,6,17,39,16),(1704,6,17,40,16),(1705,6,17,41,16),(1706,5,17,45,16),(1707,5,17,46,16),(1708,3,17,47,16),(1709,3,17,48,16),(1710,3,17,49,16),(1711,3,17,50,16),(1712,0,17,3,17),(1713,3,17,14,17),(1714,3,17,15,17),(1715,3,17,16,17),(1716,3,17,18,17),(1717,5,17,24,17),(1718,5,17,25,17),(1719,9,17,27,17),(1720,8,17,35,17),(1721,6,17,40,17),(1722,9,17,44,17),(1723,3,17,48,17),(1724,3,17,50,17),(1725,3,17,51,17),(1726,3,17,52,17),(1727,6,17,0,18),(1728,6,17,2,18),(1729,3,17,13,18),(1730,3,17,14,18),(1731,3,17,16,18),(1732,3,17,17,18),(1733,3,17,18,18),(1734,6,17,43,18),(1735,3,17,48,18),(1736,3,17,49,18),(1737,3,17,50,18),(1738,3,17,51,18),(1739,3,17,52,18),(1740,6,17,0,19),(1741,6,17,1,19),(1742,6,17,2,19),(1743,3,17,13,19),(1744,3,17,16,19),(1745,3,17,17,19),(1746,6,17,42,19),(1747,6,17,43,19),(1748,3,17,49,19),(1749,3,17,50,19),(1750,3,17,51,19),(1751,6,17,0,20),(1752,6,17,1,20),(1753,6,17,2,20),(1754,6,17,3,20),(1755,6,17,4,20),(1756,6,17,5,20),(1757,6,17,43,20),(1758,6,17,44,20),(1759,6,17,45,20),(1760,6,17,46,20),(1761,6,17,47,20),(1762,6,17,48,20),(1763,6,17,49,20),(1764,6,17,50,20),(1765,3,23,2,0),(1766,3,23,3,0),(1767,3,23,4,0),(1768,3,23,5,0),(1769,14,23,12,0),(1770,13,23,30,0),(1771,3,23,4,1),(1772,3,23,5,1),(1773,3,23,6,1),(1774,3,23,3,2),(1775,3,23,4,2),(1776,3,23,5,2),(1777,3,23,6,2),(1778,10,23,20,2),(1779,0,23,30,2),(1780,5,23,33,2),(1781,5,23,34,2),(1782,5,23,35,2),(1783,5,23,36,2),(1784,6,23,0,3),(1785,3,23,3,3),(1786,3,23,5,3),(1787,3,23,28,3),(1788,3,23,29,3),(1789,5,23,34,3),(1790,5,23,35,3),(1791,4,23,36,3),(1792,6,23,0,4),(1793,0,23,1,4),(1794,3,23,5,4),(1795,6,23,19,4),(1796,3,23,27,4),(1797,3,23,28,4),(1798,3,23,29,4),(1799,3,23,32,4),(1800,4,23,36,4),(1801,4,23,37,4),(1802,6,23,0,5),(1803,3,23,5,5),(1804,6,23,19,5),(1805,3,23,28,5),(1806,3,23,29,5),(1807,3,23,30,5),(1808,3,23,31,5),(1809,3,23,32,5),(1810,4,23,36,5),(1811,4,23,37,5),(1812,6,23,0,6),(1813,6,23,1,6),(1814,9,23,2,6),(1815,6,23,18,6),(1816,6,23,19,6),(1817,6,23,20,6),(1818,6,23,21,6),(1819,3,23,28,6),(1820,3,23,29,6),(1821,12,23,30,6),(1822,4,23,36,6),(1823,6,23,0,7),(1824,6,23,1,7),(1825,6,23,19,7),(1826,6,23,20,7),(1827,6,23,21,7),(1828,3,23,29,7),(1829,4,23,36,7),(1830,4,23,37,7),(1831,6,23,0,8),(1832,6,23,1,8),(1833,3,23,27,8),(1834,3,23,28,8),(1835,3,23,29,8),(1836,4,23,36,8),(1837,4,23,37,8),(1838,4,23,17,9),(1839,2,23,21,9),(1840,0,23,24,9),(1841,3,23,29,9),(1842,4,23,37,9),(1843,4,23,16,10),(1844,4,23,17,10),(1845,4,23,19,10),(1846,11,23,26,10),(1847,4,23,36,10),(1848,4,23,37,10),(1849,5,23,8,11),(1850,4,23,16,11),(1851,4,23,17,11),(1852,4,23,18,11),(1853,4,23,19,11),(1854,0,23,22,11),(1855,4,23,36,11),(1856,4,23,37,11),(1857,5,23,3,12),(1858,5,23,4,12),(1859,5,23,5,12),(1860,5,23,6,12),(1861,5,23,7,12),(1862,5,23,8,12),(1863,5,23,9,12),(1864,4,23,14,12),(1865,4,23,15,12),(1866,4,23,16,12),(1867,4,23,17,12),(1868,4,23,18,12),(1869,4,23,19,12),(1870,4,23,20,12),(1871,4,23,21,12),(1872,5,23,30,12),(1873,5,23,31,12),(1874,5,23,32,12),(1875,4,23,33,12),(1876,4,23,34,12),(1877,4,23,35,12),(1878,4,23,36,12),(1879,4,23,37,12),(1880,1,23,2,13),(1881,5,23,5,13),(1882,5,23,6,13),(1883,5,23,7,13),(1884,4,23,15,13),(1885,4,23,16,13),(1886,4,23,17,13),(1887,4,23,18,13),(1888,4,23,19,13),(1889,4,23,20,13),(1890,4,23,21,13),(1891,5,23,30,13),(1892,4,23,32,13),(1893,4,23,33,13),(1894,4,23,34,13),(1895,4,23,35,13),(1896,4,23,36,13),(1897,4,23,37,13),(1898,5,23,7,14),(1899,4,23,15,14),(1900,4,23,16,14),(1901,4,23,18,14),(1902,4,23,19,14),(1903,4,23,20,14),(1904,9,23,22,14),(1905,5,23,30,14),(1906,6,23,31,14),(1907,6,23,32,14),(1908,4,23,34,14),(1909,4,23,35,14),(1910,4,23,36,14),(1911,4,23,37,14),(1912,3,23,15,15),(1913,4,23,16,15),(1914,6,23,18,15),(1915,4,23,19,15),(1916,6,23,31,15),(1917,6,23,32,15),(1918,6,23,33,15),(1919,3,23,14,16),(1920,3,23,15,16),(1921,3,23,16,16),(1922,6,23,17,16),(1923,6,23,18,16),(1924,6,23,19,16),(1925,7,23,32,16),(1926,6,23,33,16),(1927,8,23,34,16),(1928,3,23,15,17),(1929,3,23,16,17),(1930,3,23,17,17),(1931,6,23,18,17),(1932,6,23,19,17),(1933,6,23,20,17),(1934,4,23,22,17),(1935,4,23,23,17),(1936,4,23,24,17),(1937,4,23,26,17),(1938,4,23,27,17),(1939,4,23,28,17),(1940,7,23,31,17),(1941,7,23,32,17),(1942,6,23,33,17),(1943,7,23,37,17),(1944,3,23,13,18),(1945,3,23,14,18),(1946,3,23,15,18),(1947,3,23,16,18),(1948,3,23,17,18),(1949,3,23,18,18),(1950,6,23,19,18),(1951,6,23,20,18),(1952,4,23,23,18),(1953,4,23,24,18),(1954,4,23,25,18),(1955,4,23,26,18),(1956,4,23,27,18),(1957,7,23,31,18),(1958,7,23,32,18),(1959,7,23,37,18),(1960,2,23,4,19),(1961,0,23,6,19),(1962,0,23,12,19),(1963,3,23,14,19),(1964,3,23,15,19),(1965,3,23,16,19),(1966,3,23,17,19),(1967,3,23,18,19),(1968,4,23,22,19),(1969,4,23,23,19),(1970,4,23,24,19),(1971,4,23,25,19),(1972,4,23,26,19),(1973,4,23,27,19),(1974,4,23,28,19),(1975,7,23,29,19),(1976,7,23,30,19),(1977,7,23,32,19),(1978,7,23,33,19),(1979,7,23,34,19),(1980,7,23,35,19),(1981,7,23,36,19),(1982,7,23,37,19),(1983,5,23,14,20),(1984,3,23,15,20),(1985,3,23,16,20),(1986,3,23,17,20),(1987,3,23,18,20),(1988,8,23,19,20),(1989,4,23,24,20),(1990,4,23,25,20),(1991,4,23,26,20),(1992,4,23,27,20),(1993,7,23,28,20),(1994,7,23,29,20),(1995,7,23,30,20),(1996,7,23,31,20),(1997,7,23,32,20),(1998,7,23,33,20),(1999,7,23,34,20),(2000,7,23,35,20),(2001,7,23,36,20),(2002,7,23,37,20),(2003,3,23,13,21),(2004,3,23,14,21),(2005,3,23,15,21),(2006,3,23,16,21),(2007,3,23,18,21),(2008,4,23,23,21),(2009,4,23,24,21),(2010,4,23,25,21),(2011,4,23,26,21),(2012,7,23,27,21),(2013,7,23,28,21),(2014,7,23,29,21),(2015,7,23,30,21),(2016,5,23,31,21),(2017,5,23,32,21),(2018,7,23,33,21),(2019,7,23,34,21),(2020,0,23,35,21),(2021,7,23,37,21),(2022,3,23,14,22),(2023,3,23,15,22),(2024,3,23,16,22),(2025,3,23,17,22),(2026,3,23,18,22),(2027,4,23,23,22),(2028,4,23,24,22),(2029,4,23,26,22),(2030,7,23,29,22),(2031,5,23,32,22),(2032,7,23,33,22),(2033,7,23,34,22),(2034,7,23,37,22),(2035,3,23,16,23),(2036,3,23,17,23),(2037,3,23,18,23),(2038,3,23,19,23),(2039,4,23,24,23),(2040,7,23,29,23),(2041,5,23,31,23),(2042,5,23,32,23),(2043,5,23,33,23),(2044,7,23,34,23),(2045,7,23,35,23),(2046,7,23,36,23),(2047,7,23,37,23),(2048,14,25,34,0),(2049,5,25,37,0),(2050,5,25,38,0),(2051,2,25,9,1),(2052,0,25,27,1),(2053,5,25,37,1),(2054,5,25,38,1),(2055,5,25,40,1),(2056,11,25,0,2),(2057,0,25,18,2),(2058,4,25,20,2),(2059,4,25,21,2),(2060,4,25,22,2),(2061,4,25,23,2),(2062,5,25,37,2),(2063,5,25,38,2),(2064,5,25,39,2),(2065,5,25,40,2),(2066,4,25,20,3),(2067,4,25,21,3),(2068,4,25,22,3),(2069,4,25,23,3),(2070,4,25,25,3),(2071,4,25,32,3),(2072,4,25,37,3),(2073,5,25,38,3),(2074,5,25,39,3),(2075,5,25,40,3),(2076,5,25,41,3),(2077,12,25,8,4),(2078,0,25,17,4),(2079,4,25,21,4),(2080,4,25,22,4),(2081,4,25,23,4),(2082,4,25,24,4),(2083,4,25,25,4),(2084,4,25,32,4),(2085,4,25,33,4),(2086,4,25,34,4),(2087,4,25,35,4),(2088,4,25,36,4),(2089,4,25,37,4),(2090,5,25,38,4),(2091,5,25,39,4),(2092,5,25,40,4),(2093,5,25,41,4),(2094,5,25,42,4),(2095,4,25,20,5),(2096,4,25,21,5),(2097,4,25,22,5),(2098,4,25,23,5),(2099,14,25,25,5),(2100,4,25,30,5),(2101,4,25,31,5),(2102,4,25,32,5),(2103,4,25,33,5),(2104,4,25,34,5),(2105,4,25,35,5),(2106,7,25,36,5),(2107,4,25,37,5),(2108,5,25,38,5),(2109,5,25,39,5),(2110,5,25,40,5),(2111,5,25,41,5),(2112,5,25,42,5),(2113,9,25,14,6),(2114,4,25,19,6),(2115,4,25,20,6),(2116,4,25,21,6),(2117,4,25,22,6),(2118,0,25,31,6),(2119,4,25,33,6),(2120,4,25,34,6),(2121,4,25,35,6),(2122,7,25,36,6),(2123,4,25,37,6),(2124,5,25,38,6),(2125,5,25,39,6),(2126,5,25,40,6),(2127,5,25,41,6),(2128,5,25,42,6),(2129,3,25,43,6),(2130,4,25,19,7),(2131,4,25,20,7),(2132,4,25,21,7),(2133,4,25,22,7),(2134,7,25,23,7),(2135,7,25,24,7),(2136,7,25,28,7),(2137,4,25,33,7),(2138,4,25,35,7),(2139,6,25,36,7),(2140,6,25,37,7),(2141,6,25,38,7),(2142,5,25,39,7),(2143,5,25,40,7),(2144,3,25,41,7),(2145,3,25,42,7),(2146,3,25,43,7),(2147,3,25,44,7),(2148,3,25,45,7),(2149,6,25,0,8),(2150,4,25,19,8),(2151,4,25,20,8),(2152,4,25,21,8),(2153,4,25,22,8),(2154,7,25,23,8),(2155,7,25,24,8),(2156,7,25,28,8),(2157,8,25,30,8),(2158,4,25,33,8),(2159,4,25,35,8),(2160,6,25,36,8),(2161,6,25,37,8),(2162,6,25,38,8),(2163,3,25,39,8),(2164,3,25,43,8),(2165,3,25,44,8),(2166,6,25,0,9),(2167,6,25,6,9),(2168,6,25,7,9),(2169,4,25,20,9),(2170,4,25,22,9),(2171,4,25,23,9),(2172,7,25,24,9),(2173,7,25,25,9),(2174,7,25,26,9),(2175,7,25,27,9),(2176,7,25,28,9),(2177,3,25,37,9),(2178,3,25,38,9),(2179,3,25,39,9),(2180,3,25,43,9),(2181,6,25,0,10),(2182,6,25,1,10),(2183,6,25,2,10),(2184,6,25,4,10),(2185,6,25,5,10),(2186,6,25,6,10),(2187,12,25,7,10),(2188,4,25,19,10),(2189,4,25,20,10),(2190,4,25,21,10),(2191,4,25,22,10),(2192,4,25,23,10),(2193,7,25,24,10),(2194,7,25,25,10),(2195,7,25,26,10),(2196,7,25,27,10),(2197,7,25,28,10),(2198,3,25,36,10),(2199,3,25,37,10),(2200,3,25,38,10),(2201,3,25,39,10),(2202,3,25,43,10),(2203,6,25,5,11),(2204,5,25,13,11),(2205,5,25,14,11),(2206,4,25,20,11),(2207,4,25,21,11),(2208,4,25,22,11),(2209,4,25,23,11),(2210,4,25,24,11),(2211,7,25,25,11),(2212,7,25,26,11),(2213,7,25,27,11),(2214,7,25,28,11),(2215,0,25,34,11),(2216,7,25,36,11),(2217,3,25,37,11),(2218,3,25,38,11),(2219,3,25,39,11),(2220,3,25,40,11),(2221,3,25,43,11),(2222,5,25,13,12),(2223,5,25,14,12),(2224,5,25,15,12),(2225,4,25,21,12),(2226,4,25,22,12),(2227,4,25,23,12),(2228,4,25,24,12),(2229,4,25,25,12),(2230,4,25,26,12),(2231,4,25,27,12),(2232,7,25,36,12),(2233,7,25,38,12),(2234,7,25,39,12),(2235,7,25,40,12),(2236,7,25,41,12),(2237,3,25,43,12),(2238,5,25,13,13),(2239,13,25,22,13),(2240,7,25,35,13),(2241,7,25,36,13),(2242,7,25,37,13),(2243,7,25,38,13),(2244,7,25,39,13),(2245,7,25,40,13),(2246,7,25,41,13),(2247,0,25,42,13),(2248,5,25,44,13),(2249,5,25,45,13),(2250,5,25,13,14),(2251,5,25,14,14),(2252,1,25,15,14),(2253,2,25,35,14),(2254,7,25,37,14),(2255,7,25,38,14),(2256,7,25,39,14),(2257,5,25,44,14),(2258,3,25,6,15),(2259,5,25,13,15),(2260,5,25,14,15),(2261,7,25,39,15),(2262,5,25,43,15),(2263,5,25,44,15),(2264,5,25,45,15),(2265,3,25,5,16),(2266,3,25,6,16),(2267,3,25,7,16),(2268,3,25,8,16),(2269,5,25,9,16),(2270,5,25,10,16),(2271,5,25,11,16),(2272,5,25,12,16),(2273,5,25,13,16),(2274,5,25,14,16),(2275,5,25,15,16),(2276,11,25,20,16),(2277,7,25,39,16),(2278,5,25,42,16),(2279,5,25,43,16),(2280,5,25,44,16),(2281,3,25,4,17),(2282,3,25,5,17),(2283,3,25,6,17),(2284,3,25,7,17),(2285,3,25,8,17),(2286,5,25,9,17),(2287,5,25,10,17),(2288,5,25,11,17),(2289,5,25,12,17),(2290,5,25,13,17),(2291,5,25,14,17),(2292,5,25,42,17),(2293,5,25,43,17),(2294,5,25,44,17),(2295,5,25,45,17),(2296,3,25,0,18),(2297,6,25,2,18),(2298,6,25,3,18),(2299,6,25,4,18),(2300,6,25,5,18),(2301,3,25,6,18),(2302,3,25,7,18),(2303,5,25,9,18),(2304,3,25,10,18),(2305,5,25,11,18),(2306,5,25,12,18),(2307,5,25,13,18),(2308,5,25,14,18),(2309,6,25,34,18),(2310,6,25,35,18),(2311,10,25,36,18),(2312,5,25,43,18),(2313,5,25,44,18),(2314,5,25,45,18),(2315,3,25,0,19),(2316,3,25,1,19),(2317,6,25,5,19),(2318,3,25,8,19),(2319,3,25,9,19),(2320,3,25,10,19),(2321,5,25,13,19),(2322,9,25,25,19),(2323,6,25,34,19),(2324,5,25,42,19),(2325,5,25,43,19),(2326,5,25,44,19),(2327,5,25,45,19),(2328,3,25,0,20),(2329,3,25,1,20),(2330,3,25,2,20),(2331,3,25,3,20),(2332,6,25,5,20),(2333,0,25,7,20),(2334,3,25,9,20),(2335,5,25,13,20),(2336,6,25,33,20),(2337,6,25,34,20),(2338,6,25,35,20),(2339,5,25,42,20),(2340,5,25,44,20),(2341,5,25,45,20),(2342,3,25,0,21),(2343,3,25,1,21),(2344,3,25,2,21),(2345,3,25,9,21),(2346,3,25,10,21),(2347,5,25,42,21),(2348,5,25,45,21),(2349,3,25,0,22),(2350,3,25,1,22),(2351,3,25,7,22),(2352,3,25,8,22),(2353,3,25,9,22),(2354,3,25,10,22),(2355,5,25,42,22),(2356,5,25,43,22),(2357,5,25,44,22),(2358,5,25,45,22),(2359,2,28,3,0),(2360,3,28,9,0),(2361,3,28,10,0),(2362,3,28,11,0),(2363,3,28,12,0),(2364,3,28,13,0),(2365,3,28,17,0),(2366,4,28,19,0),(2367,4,28,20,0),(2368,3,28,21,0),(2369,3,28,22,0),(2370,3,28,23,0),(2371,3,28,24,0),(2372,3,28,25,0),(2373,3,28,27,0),(2374,3,28,28,0),(2375,3,28,29,0),(2376,3,28,30,0),(2377,7,28,43,0),(2378,7,28,44,0),(2379,7,28,45,0),(2380,7,28,46,0),(2381,7,28,47,0),(2382,7,28,48,0),(2383,7,28,49,0),(2384,7,28,50,0),(2385,6,28,51,0),(2386,3,28,11,1),(2387,3,28,12,1),(2388,3,28,13,1),(2389,3,28,14,1),(2390,3,28,15,1),(2391,3,28,16,1),(2392,3,28,17,1),(2393,4,28,18,1),(2394,4,28,19,1),(2395,4,28,20,1),(2396,3,28,21,1),(2397,3,28,22,1),(2398,4,28,23,1),(2399,3,28,24,1),(2400,3,28,25,1),(2401,3,28,26,1),(2402,3,28,27,1),(2403,3,28,28,1),(2404,7,28,44,1),(2405,7,28,45,1),(2406,7,28,46,1),(2407,7,28,47,1),(2408,6,28,48,1),(2409,7,28,49,1),(2410,7,28,50,1),(2411,6,28,51,1),(2412,6,28,52,1),(2413,3,28,12,2),(2414,3,28,13,2),(2415,3,28,14,2),(2416,3,28,15,2),(2417,3,28,16,2),(2418,3,28,17,2),(2419,3,28,18,2),(2420,4,28,19,2),(2421,4,28,20,2),(2422,4,28,21,2),(2423,3,28,22,2),(2424,4,28,23,2),(2425,3,28,24,2),(2426,3,28,25,2),(2427,3,28,26,2),(2428,3,28,27,2),(2429,3,28,28,2),(2430,1,28,29,2),(2431,0,28,31,2),(2432,7,28,44,2),(2433,7,28,45,2),(2434,7,28,46,2),(2435,7,28,47,2),(2436,6,28,48,2),(2437,6,28,49,2),(2438,6,28,50,2),(2439,6,28,51,2),(2440,6,28,52,2),(2441,6,28,53,2),(2442,5,28,11,3),(2443,5,28,12,3),(2444,5,28,13,3),(2445,3,28,14,3),(2446,3,28,15,3),(2447,3,28,16,3),(2448,3,28,17,3),(2449,3,28,18,3),(2450,4,28,19,3),(2451,4,28,20,3),(2452,4,28,21,3),(2453,4,28,22,3),(2454,4,28,23,3),(2455,3,28,24,3),(2456,3,28,25,3),(2457,3,28,26,3),(2458,3,28,27,3),(2459,13,28,33,3),(2460,7,28,45,3),(2461,7,28,46,3),(2462,7,28,47,3),(2463,7,28,48,3),(2464,7,28,49,3),(2465,7,28,50,3),(2466,7,28,51,3),(2467,7,28,52,3),(2468,8,28,7,4),(2469,5,28,10,4),(2470,5,28,11,4),(2471,5,28,12,4),(2472,5,28,13,4),(2473,5,28,14,4),(2474,5,28,15,4),(2475,3,28,16,4),(2476,4,28,18,4),(2477,4,28,19,4),(2478,4,28,20,4),(2479,4,28,21,4),(2480,4,28,22,4),(2481,4,28,23,4),(2482,4,28,24,4),(2483,3,28,25,4),(2484,3,28,26,4),(2485,4,28,29,4),(2486,4,28,30,4),(2487,4,28,31,4),(2488,4,28,32,4),(2489,7,28,42,4),(2490,7,28,43,4),(2491,7,28,44,4),(2492,7,28,45,4),(2493,7,28,46,4),(2494,7,28,47,4),(2495,7,28,48,4),(2496,7,28,49,4),(2497,7,28,50,4),(2498,7,28,51,4),(2499,7,28,52,4),(2500,5,28,10,5),(2501,5,28,11,5),(2502,5,28,12,5),(2503,5,28,13,5),(2504,5,28,14,5),(2505,3,28,15,5),(2506,3,28,16,5),(2507,3,28,17,5),(2508,3,28,18,5),(2509,4,28,22,5),(2510,12,28,26,5),(2511,4,28,32,5),(2512,4,28,33,5),(2513,4,28,35,5),(2514,4,28,36,5),(2515,3,28,37,5),(2516,7,28,43,5),(2517,7,28,44,5),(2518,7,28,45,5),(2519,7,28,46,5),(2520,7,28,47,5),(2521,7,28,51,5),(2522,3,28,52,5),(2523,3,28,53,5),(2524,5,28,0,6),(2525,5,28,1,6),(2526,5,28,10,6),(2527,5,28,11,6),(2528,5,28,12,6),(2529,5,28,13,6),(2530,4,28,21,6),(2531,4,28,22,6),(2532,4,28,32,6),(2533,4,28,34,6),(2534,4,28,35,6),(2535,4,28,36,6),(2536,3,28,37,6),(2537,3,28,38,6),(2538,3,28,39,6),(2539,7,28,43,6),(2540,7,28,45,6),(2541,7,28,46,6),(2542,7,28,47,6),(2543,7,28,48,6),(2544,3,28,51,6),(2545,3,28,52,6),(2546,3,28,53,6),(2547,3,28,54,6),(2548,5,28,0,7),(2549,5,28,1,7),(2550,5,28,10,7),(2551,5,28,12,7),(2552,4,28,22,7),(2553,4,28,32,7),(2554,4,28,33,7),(2555,4,28,34,7),(2556,4,28,35,7),(2557,3,28,36,7),(2558,3,28,37,7),(2559,13,28,38,7),(2560,0,28,44,7),(2561,7,28,46,7),(2562,10,28,49,7),(2563,3,28,53,7),(2564,3,28,54,7),(2565,3,28,55,7),(2566,3,28,56,7),(2567,5,28,1,8),(2568,5,28,10,8),(2569,5,28,12,8),(2570,5,28,13,8),(2571,6,28,18,8),(2572,4,28,32,8),(2573,4,28,33,8),(2574,4,28,34,8),(2575,4,28,35,8),(2576,3,28,36,8),(2577,3,28,37,8),(2578,7,28,46,8),(2579,3,28,53,8),(2580,3,28,54,8),(2581,3,28,55,8),(2582,3,28,56,8),(2583,5,28,0,9),(2584,5,28,1,9),(2585,5,28,2,9),(2586,9,28,11,9),(2587,6,28,17,9),(2588,6,28,18,9),(2589,0,28,19,9),(2590,4,28,32,9),(2591,4,28,33,9),(2592,4,28,35,9),(2593,4,28,36,9),(2594,3,28,37,9),(2595,3,28,38,9),(2596,3,28,39,9),(2597,7,28,46,9),(2598,7,28,47,9),(2599,3,28,53,9),(2600,3,28,54,9),(2601,3,28,55,9),(2602,5,28,0,10),(2603,12,28,2,10),(2604,4,28,10,10),(2605,6,28,17,10),(2606,6,28,18,10),(2607,4,28,32,10),(2608,3,28,35,10),(2609,3,28,38,10),(2610,3,28,39,10),(2611,3,28,53,10),(2612,3,28,54,10),(2613,3,28,55,10),(2614,3,28,56,10),(2615,5,28,0,11),(2616,5,28,1,11),(2617,4,28,10,11),(2618,6,28,17,11),(2619,6,28,18,11),(2620,6,28,19,11),(2621,6,28,20,11),(2622,5,28,26,11),(2623,5,28,27,11),(2624,5,28,28,11),(2625,5,28,29,11),(2626,5,28,30,11),(2627,5,28,31,11),(2628,4,28,32,11),(2629,3,28,33,11),(2630,3,28,34,11),(2631,3,28,35,11),(2632,3,28,36,11),(2633,3,28,37,11),(2634,3,28,38,11),(2635,3,28,51,11),(2636,3,28,52,11),(2637,3,28,53,11),(2638,3,28,54,11),(2639,3,28,55,11),(2640,3,28,56,11),(2641,3,28,57,11),(2642,5,28,0,12),(2643,5,28,1,12),(2644,4,28,10,12),(2645,4,28,11,12),(2646,4,28,12,12),(2647,4,28,13,12),(2648,4,28,14,12),(2649,6,28,15,12),(2650,6,28,16,12),(2651,6,28,17,12),(2652,8,28,18,12),(2653,5,28,28,12),(2654,5,28,29,12),(2655,5,28,30,12),(2656,5,28,31,12),(2657,5,28,32,12),(2658,4,28,33,12),(2659,3,28,36,12),(2660,3,28,37,12),(2661,0,28,43,12),(2662,6,28,45,12),(2663,11,28,51,12),(2664,3,28,55,12),(2665,3,28,56,12),(2666,5,28,0,13),(2667,5,28,1,13),(2668,4,28,9,13),(2669,4,28,10,13),(2670,4,28,11,13),(2671,4,28,12,13),(2672,0,28,13,13),(2673,6,28,17,13),(2674,2,28,24,13),(2675,5,28,26,13),(2676,5,28,27,13),(2677,5,28,28,13),(2678,5,28,30,13),(2679,4,28,31,13),(2680,4,28,32,13),(2681,4,28,33,13),(2682,4,28,34,13),(2683,3,28,35,13),(2684,3,28,36,13),(2685,3,28,38,13),(2686,6,28,39,13),(2687,6,28,45,13),(2688,6,28,46,13),(2689,5,28,0,14),(2690,5,28,1,14),(2691,4,28,8,14),(2692,4,28,9,14),(2693,4,28,10,14),(2694,4,28,11,14),(2695,4,28,12,14),(2696,6,28,17,14),(2697,6,28,22,14),(2698,5,28,27,14),(2699,5,28,28,14),(2700,5,28,30,14),(2701,5,28,31,14),(2702,5,28,32,14),(2703,4,28,34,14),(2704,3,28,35,14),(2705,3,28,36,14),(2706,3,28,37,14),(2707,3,28,38,14),(2708,6,28,39,14),(2709,6,28,40,14),(2710,6,28,41,14),(2711,6,28,43,14),(2712,6,28,44,14),(2713,6,28,45,14),(2714,6,28,46,14),(2715,5,28,0,15),(2716,5,28,1,15),(2717,4,28,10,15),(2718,4,28,11,15),(2719,4,28,12,15),(2720,6,28,19,15),(2721,6,28,21,15),(2722,6,28,22,15),(2723,6,28,23,15),(2724,5,28,31,15),(2725,5,28,32,15),(2726,4,28,33,15),(2727,4,28,34,15),(2728,3,28,35,15),(2729,6,28,39,15),(2730,6,28,41,15),(2731,6,28,42,15),(2732,6,28,43,15),(2733,6,28,45,15),(2734,6,28,46,15),(2735,6,28,47,15),(2736,6,28,48,15),(2737,5,28,0,16),(2738,5,28,1,16),(2739,5,28,2,16),(2740,4,28,9,16),(2741,4,28,10,16),(2742,4,28,11,16),(2743,4,28,12,16),(2744,4,28,13,16),(2745,6,28,17,16),(2746,6,28,19,16),(2747,6,28,20,16),(2748,6,28,21,16),(2749,6,28,22,16),(2750,5,28,31,16),(2751,4,28,32,16),(2752,4,28,33,16),(2753,4,28,34,16),(2754,4,28,35,16),(2755,4,28,36,16),(2756,6,28,39,16),(2757,6,28,40,16),(2758,6,28,41,16),(2759,6,28,43,16),(2760,6,28,45,16),(2761,6,28,46,16),(2762,5,28,0,17),(2763,3,28,1,17),(2764,3,28,2,17),(2765,4,28,10,17),(2766,4,28,11,17),(2767,6,28,17,17),(2768,6,28,18,17),(2769,6,28,19,17),(2770,4,28,21,17),(2771,4,28,33,17),(2772,4,28,34,17),(2773,4,28,35,17),(2774,6,28,40,17),(2775,6,28,44,17),(2776,6,28,45,17),(2777,3,28,0,18),(2778,3,28,1,18),(2779,3,28,2,18),(2780,3,28,4,18),(2781,6,28,19,18),(2782,4,28,20,18),(2783,4,28,21,18),(2784,4,28,22,18),(2785,4,28,23,18),(2786,4,28,26,18),(2787,4,28,32,18),(2788,4,28,33,18),(2789,4,28,34,18),(2790,4,28,35,18),(2791,0,28,48,18),(2792,3,28,0,19),(2793,3,28,1,19),(2794,3,28,2,19),(2795,3,28,3,19),(2796,3,28,4,19),(2797,3,28,5,19),(2798,3,28,6,19),(2799,4,28,19,19),(2800,4,28,20,19),(2801,5,28,21,19),(2802,4,28,22,19),(2803,4,28,23,19),(2804,4,28,25,19),(2805,4,28,26,19),(2806,4,28,27,19),(2807,4,28,32,19),(2808,4,28,34,19),(2809,4,28,35,19),(2810,3,28,1,20),(2811,3,28,2,20),(2812,5,28,19,20),(2813,5,28,20,20),(2814,5,28,21,20),(2815,4,28,22,20),(2816,4,28,23,20),(2817,4,28,24,20),(2818,4,28,25,20),(2819,4,28,26,20),(2820,4,28,32,20),(2821,4,28,34,20),(2822,4,28,35,20),(2823,14,28,36,20),(2824,10,28,47,20),(2825,3,28,0,21),(2826,3,28,1,21),(2827,3,28,2,21),(2828,3,28,3,21),(2829,9,28,10,21),(2830,5,28,17,21),(2831,5,28,18,21),(2832,5,28,19,21),(2833,5,28,20,21),(2834,5,28,21,21),(2835,5,28,22,21),(2836,4,28,23,21),(2837,4,28,24,21),(2838,4,28,25,21),(2839,0,28,26,21),(2840,3,28,0,22),(2841,3,28,1,22),(2842,3,28,3,22),(2843,5,28,16,22),(2844,5,28,17,22),(2845,5,28,18,22),(2846,5,28,19,22),(2847,5,28,20,22),(2848,5,28,21,22),(2849,4,28,22,22),(2850,4,28,23,22),(2851,4,28,24,22),(2852,4,28,25,22),(2853,3,28,0,23),(2854,3,28,1,23),(2855,3,28,2,23),(2856,3,28,3,23),(2857,5,28,16,23),(2858,5,28,17,23),(2859,5,28,18,23),(2860,5,28,19,23),(2861,5,28,20,23),(2862,4,28,23,23),(2863,3,28,0,24),(2864,3,28,1,24),(2865,3,28,2,24),(2866,3,28,3,24),(2867,5,28,20,24),(2868,5,28,21,24),(2869,5,29,2,0),(2870,14,29,5,0),(2871,3,29,18,0),(2872,3,29,19,0),(2873,3,29,20,0),(2874,5,29,23,0),(2875,5,29,24,0),(2876,6,29,32,0),(2877,6,29,33,0),(2878,6,29,34,0),(2879,6,29,35,0),(2880,0,29,0,1),(2881,5,29,2,1),(2882,0,29,13,1),(2883,3,29,17,1),(2884,3,29,18,1),(2885,5,29,22,1),(2886,5,29,23,1),(2887,5,29,24,1),(2888,4,29,31,1),(2889,4,29,32,1),(2890,13,29,33,1),(2891,5,29,2,2),(2892,0,29,3,2),(2893,7,29,9,2),(2894,3,29,15,2),(2895,3,29,16,2),(2896,3,29,17,2),(2897,3,29,18,2),(2898,3,29,19,2),(2899,3,29,20,2),(2900,5,29,21,2),(2901,5,29,22,2),(2902,5,29,23,2),(2903,5,29,24,2),(2904,5,29,25,2),(2905,0,29,28,2),(2906,4,29,31,2),(2907,4,29,32,2),(2908,5,29,0,3),(2909,5,29,1,3),(2910,5,29,2,3),(2911,7,29,9,3),(2912,7,29,10,3),(2913,0,29,15,3),(2914,3,29,18,3),(2915,3,29,19,3),(2916,3,29,20,3),(2917,5,29,21,3),(2918,6,29,22,3),(2919,5,29,24,3),(2920,5,29,25,3),(2921,5,29,26,3),(2922,5,29,27,3),(2923,4,29,30,3),(2924,4,29,31,3),(2925,4,29,32,3),(2926,4,29,33,3),(2927,3,29,34,3),(2928,3,29,35,3),(2929,5,29,0,4),(2930,5,29,1,4),(2931,5,29,2,4),(2932,11,29,3,4),(2933,7,29,8,4),(2934,7,29,9,4),(2935,7,29,10,4),(2936,3,29,17,4),(2937,3,29,18,4),(2938,5,29,20,4),(2939,5,29,21,4),(2940,6,29,22,4),(2941,5,29,23,4),(2942,5,29,24,4),(2943,0,29,25,4),(2944,4,29,30,4),(2945,4,29,31,4),(2946,4,29,32,4),(2947,3,29,33,4),(2948,3,29,34,4),(2949,3,29,35,4),(2950,5,29,0,5),(2951,5,29,1,5),(2952,5,29,2,5),(2953,7,29,8,5),(2954,7,29,9,5),(2955,7,29,10,5),(2956,7,29,11,5),(2957,7,29,13,5),(2958,7,29,14,5),(2959,6,29,20,5),(2960,6,29,21,5),(2961,6,29,22,5),(2962,5,29,24,5),(2963,1,29,28,5),(2964,4,29,30,5),(2965,3,29,31,5),(2966,3,29,32,5),(2967,3,29,33,5),(2968,3,29,34,5),(2969,3,29,35,5),(2970,3,29,36,5),(2971,5,29,0,6),(2972,5,29,1,6),(2973,5,29,2,6),(2974,7,29,8,6),(2975,7,29,10,6),(2976,7,29,11,6),(2977,7,29,12,6),(2978,7,29,13,6),(2979,4,29,20,6),(2980,4,29,21,6),(2981,6,29,22,6),(2982,9,29,23,6),(2983,4,29,30,6),(2984,4,29,31,6),(2985,3,29,32,6),(2986,3,29,33,6),(2987,3,29,34,6),(2988,0,29,35,6),(2989,5,29,40,6),(2990,2,29,0,7),(2991,5,29,2,7),(2992,7,29,9,7),(2993,7,29,10,7),(2994,7,29,11,7),(2995,7,29,12,7),(2996,4,29,18,7),(2997,4,29,19,7),(2998,4,29,21,7),(2999,4,29,29,7),(3000,4,29,30,7),(3001,4,29,31,7),(3002,4,29,32,7),(3003,3,29,33,7),(3004,3,29,34,7),(3005,5,29,39,7),(3006,5,29,40,7),(3007,5,29,41,7),(3008,5,29,2,8),(3009,7,29,10,8),(3010,7,29,11,8),(3011,7,29,12,8),(3012,10,29,15,8),(3013,4,29,19,8),(3014,4,29,20,8),(3015,4,29,21,8),(3016,4,29,22,8),(3017,11,29,27,8),(3018,4,29,31,8),(3019,4,29,32,8),(3020,4,29,33,8),(3021,5,29,36,8),(3022,5,29,38,8),(3023,5,29,39,8),(3024,5,29,40,8),(3025,5,29,0,9),(3026,5,29,1,9),(3027,5,29,2,9),(3028,8,29,7,9),(3029,7,29,10,9),(3030,7,29,11,9),(3031,7,29,12,9),(3032,7,29,13,9),(3033,4,29,19,9),(3034,4,29,20,9),(3035,4,29,21,9),(3036,4,29,22,9),(3037,3,29,23,9),(3038,3,29,24,9),(3039,3,29,25,9),(3040,3,29,26,9),(3041,5,29,36,9),(3042,5,29,37,9),(3043,5,29,38,9),(3044,5,29,39,9),(3045,12,29,0,10),(3046,7,29,11,10),(3047,7,29,12,10),(3048,0,29,13,10),(3049,4,29,20,10),(3050,3,29,21,10),(3051,3,29,22,10),(3052,3,29,23,10),(3053,3,29,24,10),(3054,3,29,25,10),(3055,3,29,26,10),(3056,5,29,36,10),(3057,5,29,37,10),(3058,5,29,38,10),(3059,5,29,39,10),(3060,5,29,40,10),(3061,7,29,10,11),(3062,7,29,11,11),(3063,7,29,12,11),(3064,4,29,20,11),(3065,4,29,21,11),(3066,4,29,22,11),(3067,4,29,23,11),(3068,3,29,24,11),(3069,3,29,25,11),(3070,3,29,26,11),(3071,5,29,36,11),(3072,5,29,38,11),(3073,6,29,13,12),(3074,6,29,14,12),(3075,6,29,15,12),(3076,4,29,20,12),(3077,4,29,21,12),(3078,4,29,22,12),(3079,4,29,23,12),(3080,3,29,24,12),(3081,3,29,25,12),(3082,3,29,26,12),(3083,5,29,36,12),(3084,14,29,6,13),(3085,6,29,12,13),(3086,6,29,13,13),(3087,6,29,14,13),(3088,6,29,15,13),(3089,9,29,17,13),(3090,13,29,21,13),(3091,2,29,31,13),(3092,10,29,43,13),(3093,6,29,13,14),(3094,6,29,14,14),(3095,6,29,12,15),(3096,6,29,13,15),(3097,6,29,14,15),(3098,3,29,24,15),(3099,3,29,25,15),(3100,3,29,26,15),(3101,3,29,27,15),(3102,3,29,0,16),(3103,3,29,1,16),(3104,3,29,2,16),(3105,3,29,3,16),(3106,3,29,4,16),(3107,3,29,5,16),(3108,3,29,23,16),(3109,3,29,24,16),(3110,3,29,25,16),(3111,3,29,26,16),(3112,3,29,27,16),(3113,3,29,28,16),(3114,3,29,29,16),(3115,3,29,30,16),(3116,3,29,0,17),(3117,3,29,1,17),(3118,3,29,2,17),(3119,3,29,3,17),(3120,3,29,4,17),(3121,3,29,5,17),(3122,3,29,6,17),(3123,3,29,7,17),(3124,3,29,8,17),(3125,3,29,9,17),(3126,3,29,24,17),(3127,3,29,26,17),(3128,3,29,29,17),(3129,3,29,30,17),(3130,6,35,3,0),(3131,3,35,14,0),(3132,3,35,15,0),(3133,3,35,38,0),(3134,3,35,39,0),(3135,3,35,40,0),(3136,3,35,41,0),(3137,3,35,42,0),(3138,3,35,43,0),(3139,3,35,44,0),(3140,3,35,45,0),(3141,6,35,3,1),(3142,6,35,4,1),(3143,6,35,5,1),(3144,6,35,6,1),(3145,6,35,7,1),(3146,3,35,15,1),(3147,3,35,16,1),(3148,7,35,26,1),(3149,8,35,30,1),(3150,3,35,38,1),(3151,3,35,39,1),(3152,3,35,40,1),(3153,3,35,41,1),(3154,3,35,42,1),(3155,3,35,43,1),(3156,6,35,3,2),(3157,6,35,4,2),(3158,6,35,5,2),(3159,6,35,6,2),(3160,6,35,7,2),(3161,6,35,8,2),(3162,3,35,13,2),(3163,3,35,14,2),(3164,3,35,15,2),(3165,3,35,17,2),(3166,3,35,18,2),(3167,7,35,25,2),(3168,7,35,26,2),(3169,7,35,27,2),(3170,7,35,28,2),(3171,7,35,29,2),(3172,3,35,40,2),(3173,3,35,41,2),(3174,3,35,42,2),(3175,11,35,43,2),(3176,6,35,1,3),(3177,6,35,2,3),(3178,6,35,3,3),(3179,9,35,4,3),(3180,3,35,15,3),(3181,3,35,16,3),(3182,3,35,17,3),(3183,7,35,25,3),(3184,7,35,26,3),(3185,7,35,28,3),(3186,0,35,36,3),(3187,9,35,39,3),(3188,1,35,47,3),(3189,6,35,0,4),(3190,6,35,1,4),(3191,3,35,16,4),(3192,3,35,17,4),(3193,3,35,18,4),(3194,0,35,19,4),(3195,7,35,24,4),(3196,7,35,25,4),(3197,7,35,26,4),(3198,7,35,28,4),(3199,10,35,30,4),(3200,5,35,0,5),(3201,5,35,1,5),(3202,3,35,16,5),(3203,3,35,18,5),(3204,7,35,26,5),(3205,6,35,37,5),(3206,5,35,0,6),(3207,5,35,1,6),(3208,5,35,2,6),(3209,0,35,7,6),(3210,0,35,10,6),(3211,6,35,35,6),(3212,6,35,37,6),(3213,6,35,38,6),(3214,6,35,39,6),(3215,6,35,40,6),(3216,0,35,41,6),(3217,5,35,0,7),(3218,5,35,1,7),(3219,5,35,2,7),(3220,5,35,3,7),(3221,3,35,24,7),(3222,6,35,35,7),(3223,6,35,36,7),(3224,6,35,37,7),(3225,6,35,38,7),(3226,6,35,39,7),(3227,6,35,40,7),(3228,5,35,0,8),(3229,5,35,1,8),(3230,5,35,3,8),(3231,5,35,18,8),(3232,14,35,21,8),(3233,3,35,24,8),(3234,3,35,25,8),(3235,6,35,34,8),(3236,6,35,35,8),(3237,6,35,36,8),(3238,6,35,37,8),(3239,6,35,38,8),(3240,6,35,39,8),(3241,6,35,40,8),(3242,6,35,41,8),(3243,6,35,42,8),(3244,6,35,43,8),(3245,5,35,0,9),(3246,14,35,4,9),(3247,5,35,10,9),(3248,10,35,11,9),(3249,5,35,16,9),(3250,5,35,18,9),(3251,3,35,24,9),(3252,3,35,25,9),(3253,6,35,35,9),(3254,6,35,36,9),(3255,6,35,37,9),(3256,6,35,38,9),(3257,6,35,39,9),(3258,6,35,40,9),(3259,6,35,41,9),(3260,6,35,42,9),(3261,6,35,43,9),(3262,6,35,44,9),(3263,5,35,10,10),(3264,5,35,16,10),(3265,5,35,17,10),(3266,5,35,18,10),(3267,5,35,19,10),(3268,3,35,24,10),(3269,3,35,25,10),(3270,8,35,26,10),(3271,4,35,29,10),(3272,4,35,30,10),(3273,2,35,35,10),(3274,6,35,37,10),(3275,6,35,38,10),(3276,6,35,39,10),(3277,6,35,40,10),(3278,1,35,41,10),(3279,5,35,8,11),(3280,5,35,9,11),(3281,5,35,10,11),(3282,5,35,16,11),(3283,5,35,17,11),(3284,4,35,20,11),(3285,3,35,24,11),(3286,3,35,25,11),(3287,4,35,30,11),(3288,4,35,31,11),(3289,6,35,39,11),(3290,6,35,40,11),(3291,5,35,8,12),(3292,5,35,9,12),(3293,5,35,10,12),(3294,5,35,15,12),(3295,5,35,16,12),(3296,5,35,17,12),(3297,4,35,18,12),(3298,4,35,20,12),(3299,4,35,21,12),(3300,4,35,22,12),(3301,4,35,23,12),(3302,3,35,24,12),(3303,3,35,25,12),(3304,4,35,29,12),(3305,4,35,30,12),(3306,4,35,31,12),(3307,5,35,8,13),(3308,5,35,9,13),(3309,12,35,10,13),(3310,5,35,16,13),(3311,4,35,18,13),(3312,4,35,20,13),(3313,4,35,21,13),(3314,4,35,22,13),(3315,3,35,23,13),(3316,3,35,24,13),(3317,3,35,25,13),(3318,3,35,26,13),(3319,3,35,27,13),(3320,4,35,28,13),(3321,4,35,29,13),(3322,4,35,30,13),(3323,4,35,31,13),(3324,4,35,32,13),(3325,13,35,44,13),(3326,5,35,9,14),(3327,4,35,18,14),(3328,4,35,19,14),(3329,4,35,20,14),(3330,0,35,21,14),(3331,4,35,23,14),(3332,4,35,24,14),(3333,4,35,25,14),(3334,4,35,26,14),(3335,3,35,27,14),(3336,4,35,29,14),(3337,2,35,8,15),(3338,5,35,18,15),(3339,4,35,23,15),(3340,4,35,24,15),(3341,4,35,25,15),(3342,4,35,26,15),(3343,4,35,27,15),(3344,4,35,28,15),(3345,4,35,29,15),(3346,4,35,30,15),(3347,7,35,34,15),(3348,5,35,39,15),(3349,4,35,50,15),(3350,5,35,16,16),(3351,5,35,17,16),(3352,5,35,18,16),(3353,4,35,23,16),(3354,4,35,24,16),(3355,4,35,25,16),(3356,4,35,26,16),(3357,4,35,28,16),(3358,4,35,29,16),(3359,4,35,30,16),(3360,4,35,31,16),(3361,4,35,32,16),(3362,7,35,33,16),(3363,7,35,34,16),(3364,5,35,39,16),(3365,3,35,43,16),(3366,4,35,46,16),(3367,4,35,50,16),(3368,5,35,16,17),(3369,5,35,17,17),(3370,5,35,18,17),(3371,4,35,22,17),(3372,4,35,23,17),(3373,4,35,24,17),(3374,4,35,28,17),(3375,7,35,31,17),(3376,7,35,32,17),(3377,7,35,33,17),(3378,7,35,34,17),(3379,5,35,39,17),(3380,5,35,40,17),(3381,3,35,41,17),(3382,3,35,42,17),(3383,3,35,43,17),(3384,3,35,44,17),(3385,4,35,46,17),(3386,4,35,47,17),(3387,4,35,48,17),(3388,4,35,49,17),(3389,4,35,50,17),(3390,5,35,16,18),(3391,5,35,17,18),(3392,5,35,18,18),(3393,5,35,19,18),(3394,4,35,28,18),(3395,7,35,32,18),(3396,7,35,33,18),(3397,7,35,34,18),(3398,7,35,35,18),(3399,7,35,36,18),(3400,7,35,37,18),(3401,5,35,38,18),(3402,5,35,39,18),(3403,5,35,40,18),(3404,3,35,41,18),(3405,3,35,42,18),(3406,3,35,43,18),(3407,3,35,44,18),(3408,3,35,45,18),(3409,4,35,47,18),(3410,4,35,49,18),(3411,4,35,50,18),(3412,5,35,16,19),(3413,5,35,17,19),(3414,7,35,33,19),(3415,7,35,35,19),(3416,5,35,36,19),(3417,5,35,37,19),(3418,5,35,38,19),(3419,5,35,39,19),(3420,5,35,40,19),(3421,5,35,41,19),(3422,3,35,42,19),(3423,3,35,43,19),(3424,3,35,44,19),(3425,3,35,45,19),(3426,3,35,46,19),(3427,3,37,3,0),(3428,3,37,7,0),(3429,3,37,8,0),(3430,3,37,10,0),(3431,3,37,11,0),(3432,10,37,18,0),(3433,5,37,22,0),(3434,5,37,23,0),(3435,5,37,24,0),(3436,5,37,25,0),(3437,5,37,26,0),(3438,5,37,27,0),(3439,4,37,28,0),(3440,4,37,33,0),(3441,4,37,34,0),(3442,4,37,35,0),(3443,4,37,36,0),(3444,4,37,37,0),(3445,4,37,38,0),(3446,4,37,39,0),(3447,3,37,1,1),(3448,3,37,2,1),(3449,3,37,3,1),(3450,3,37,4,1),(3451,3,37,7,1),(3452,3,37,8,1),(3453,3,37,9,1),(3454,3,37,11,1),(3455,3,37,12,1),(3456,8,37,15,1),(3457,5,37,22,1),(3458,5,37,23,1),(3459,5,37,24,1),(3460,5,37,26,1),(3461,4,37,27,1),(3462,4,37,28,1),(3463,4,37,30,1),(3464,13,37,32,1),(3465,4,37,38,1),(3466,5,37,0,2),(3467,5,37,1,2),(3468,5,37,2,2),(3469,5,37,3,2),(3470,5,37,4,2),(3471,3,37,8,2),(3472,3,37,9,2),(3473,3,37,10,2),(3474,3,37,11,2),(3475,5,37,22,2),(3476,5,37,23,2),(3477,5,37,24,2),(3478,5,37,26,2),(3479,4,37,27,2),(3480,4,37,28,2),(3481,4,37,29,2),(3482,4,37,30,2),(3483,4,37,38,2),(3484,5,37,0,3),(3485,5,37,1,3),(3486,5,37,2,3),(3487,5,37,4,3),(3488,0,37,6,3),(3489,3,37,10,3),(3490,3,37,11,3),(3491,3,37,12,3),(3492,5,37,23,3),(3493,5,37,24,3),(3494,5,37,25,3),(3495,5,37,26,3),(3496,5,37,27,3),(3497,4,37,28,3),(3498,9,37,30,3),(3499,4,37,35,3),(3500,4,37,36,3),(3501,4,37,37,3),(3502,4,37,39,3),(3503,5,37,0,4),(3504,5,37,1,4),(3505,5,37,2,4),(3506,5,37,5,4),(3507,9,37,12,4),(3508,2,37,20,4),(3509,5,37,23,4),(3510,5,37,24,4),(3511,5,37,25,4),(3512,5,37,26,4),(3513,1,37,27,4),(3514,4,37,35,4),(3515,4,37,37,4),(3516,4,37,38,4),(3517,4,37,39,4),(3518,0,37,0,5),(3519,5,37,2,5),(3520,5,37,3,5),(3521,5,37,4,5),(3522,5,37,5,5),(3523,0,37,6,5),(3524,5,37,24,5),(3525,5,37,25,5),(3526,5,37,26,5),(3527,4,37,37,5),(3528,5,37,2,6),(3529,5,37,4,6),(3530,7,37,8,6),(3531,7,37,9,6),(3532,10,37,33,6),(3533,0,37,37,6),(3534,5,37,2,7),(3535,5,37,3,7),(3536,5,37,4,7),(3537,14,37,5,7),(3538,7,37,9,7),(3539,5,37,1,8),(3540,5,37,2,8),(3541,0,37,3,8),(3542,7,37,9,8),(3543,7,37,10,8),(3544,6,37,18,8),(3545,6,37,19,8),(3546,11,37,20,8),(3547,12,37,25,8),(3548,5,37,1,9),(3549,5,37,2,9),(3550,7,37,8,9),(3551,7,37,9,9),(3552,7,37,10,9),(3553,7,37,11,9),(3554,6,37,18,9),(3555,5,37,0,10),(3556,5,37,1,10),(3557,8,37,2,10),(3558,7,37,8,10),(3559,7,37,9,10),(3560,7,37,10,10),(3561,7,37,11,10),(3562,3,37,18,10),(3563,6,37,24,10),(3564,6,37,31,10),(3565,7,37,9,11),(3566,0,37,16,11),(3567,3,37,18,11),(3568,6,37,24,11),(3569,6,37,31,11),(3570,6,37,32,11),(3571,4,37,35,11),(3572,4,37,37,11),(3573,6,37,38,11),(3574,6,37,39,11),(3575,3,37,18,12),(3576,6,37,24,12),(3577,4,37,32,12),(3578,4,37,33,12),(3579,4,37,34,12),(3580,4,37,35,12),(3581,4,37,36,12),(3582,4,37,37,12),(3583,4,37,38,12),(3584,6,37,39,12),(3585,4,37,15,13),(3586,4,37,17,13),(3587,3,37,18,13),(3588,3,37,19,13),(3589,6,37,24,13),(3590,4,37,13,14),(3591,4,37,14,14),(3592,4,37,15,14),(3593,4,37,16,14),(3594,4,37,17,14),(3595,4,37,18,14),(3596,3,37,19,14),(3597,3,37,20,14),(3598,3,37,21,14),(3599,6,37,23,14),(3600,6,37,24,14),(3601,8,40,3,0),(3602,3,40,19,0),(3603,3,40,20,0),(3604,3,40,21,0),(3605,3,40,22,0),(3606,3,40,23,0),(3607,3,40,24,0),(3608,3,40,25,0),(3609,3,40,26,0),(3610,1,40,34,0),(3611,4,40,36,0),(3612,4,40,37,0),(3613,4,40,38,0),(3614,4,40,39,0),(3615,4,40,40,0),(3616,3,40,20,1),(3617,3,40,21,1),(3618,3,40,22,1),(3619,3,40,23,1),(3620,3,40,24,1),(3621,12,40,25,1),(3622,4,40,37,1),(3623,4,40,38,1),(3624,4,40,39,1),(3625,4,40,40,1),(3626,3,40,1,2),(3627,9,40,6,2),(3628,3,40,20,2),(3629,3,40,21,2),(3630,3,40,22,2),(3631,3,40,24,2),(3632,0,40,36,2),(3633,4,40,38,2),(3634,4,40,39,2),(3635,4,40,40,2),(3636,4,40,41,2),(3637,3,40,0,3),(3638,3,40,1,3),(3639,3,40,2,3),(3640,3,40,18,3),(3641,3,40,19,3),(3642,3,40,20,3),(3643,3,40,21,3),(3644,3,40,22,3),(3645,4,40,39,3),(3646,4,40,40,3),(3647,3,40,0,4),(3648,3,40,1,4),(3649,3,40,2,4),(3650,3,40,3,4),(3651,3,40,16,4),(3652,3,40,17,4),(3653,3,40,18,4),(3654,3,40,19,4),(3655,3,40,20,4),(3656,3,40,31,4),(3657,4,40,39,4),(3658,4,40,40,4),(3659,4,40,41,4),(3660,3,40,0,5),(3661,3,40,1,5),(3662,3,40,2,5),(3663,3,40,3,5),(3664,5,40,5,5),(3665,5,40,6,5),(3666,5,40,7,5),(3667,5,40,8,5),(3668,3,40,15,5),(3669,3,40,16,5),(3670,3,40,17,5),(3671,5,40,19,5),(3672,3,40,20,5),(3673,3,40,21,5),(3674,3,40,31,5),(3675,3,40,32,5),(3676,2,40,37,5),(3677,4,40,39,5),(3678,4,40,40,5),(3679,0,40,43,5),(3680,3,40,0,6),(3681,3,40,1,6),(3682,3,40,2,6),(3683,3,40,3,6),(3684,5,40,4,6),(3685,5,40,5,6),(3686,5,40,6,6),(3687,5,40,8,6),(3688,3,40,16,6),(3689,3,40,17,6),(3690,3,40,18,6),(3691,5,40,19,6),(3692,3,40,21,6),(3693,5,40,22,6),(3694,5,40,24,6),(3695,3,40,31,6),(3696,3,40,32,6),(3697,3,40,33,6),(3698,3,40,34,6),(3699,6,40,39,6),(3700,6,40,40,6),(3701,3,40,0,7),(3702,3,40,1,7),(3703,5,40,2,7),(3704,5,40,3,7),(3705,5,40,4,7),(3706,5,40,5,7),(3707,5,40,6,7),(3708,5,40,7,7),(3709,5,40,8,7),(3710,3,40,15,7),(3711,3,40,16,7),(3712,5,40,19,7),(3713,5,40,20,7),(3714,5,40,21,7),(3715,5,40,22,7),(3716,5,40,23,7),(3717,5,40,24,7),(3718,7,40,25,7),(3719,7,40,26,7),(3720,7,40,27,7),(3721,7,40,28,7),(3722,7,40,29,7),(3723,7,40,30,7),(3724,3,40,31,7),(3725,3,40,32,7),(3726,1,40,33,7),(3727,6,40,39,7),(3728,6,40,40,7),(3729,6,40,41,7),(3730,3,40,0,8),(3731,5,40,1,8),(3732,5,40,2,8),(3733,5,40,3,8),(3734,5,40,4,8),(3735,5,40,5,8),(3736,5,40,6,8),(3737,5,40,8,8),(3738,5,40,9,8),(3739,5,40,19,8),(3740,5,40,21,8),(3741,5,40,22,8),(3742,5,40,23,8),(3743,7,40,24,8),(3744,7,40,25,8),(3745,7,40,26,8),(3746,7,40,27,8),(3747,7,40,28,8),(3748,7,40,29,8),(3749,3,40,30,8),(3750,3,40,31,8),(3751,3,40,32,8),(3752,6,40,38,8),(3753,6,40,39,8),(3754,6,40,40,8),(3755,5,40,1,9),(3756,5,40,2,9),(3757,5,40,3,9),(3758,5,40,4,9),(3759,5,40,5,9),(3760,5,40,6,9),(3761,5,40,7,9),(3762,5,40,8,9),(3763,5,40,19,9),(3764,5,40,20,9),(3765,5,40,22,9),(3766,7,40,23,9),(3767,7,40,24,9),(3768,5,40,25,9),(3769,5,40,26,9),(3770,7,40,27,9),(3771,7,40,28,9),(3772,7,40,29,9),(3773,3,40,30,9),(3774,3,40,31,9),(3775,3,40,32,9),(3776,6,40,40,9),(3777,6,40,41,9),(3778,6,40,42,9),(3779,5,40,2,10),(3780,5,40,3,10),(3781,5,40,4,10),(3782,5,40,5,10),(3783,5,40,6,10),(3784,5,40,8,10),(3785,5,40,9,10),(3786,5,40,19,10),(3787,5,40,21,10),(3788,5,40,22,10),(3789,5,40,23,10),(3790,5,40,24,10),(3791,5,40,25,10),(3792,7,40,26,10),(3793,7,40,27,10),(3794,14,40,28,10),(3795,3,40,31,10),(3796,3,40,32,10),(3797,5,40,1,11),(3798,5,40,2,11),(3799,5,40,3,11),(3800,5,40,4,11),(3801,5,40,5,11),(3802,5,40,6,11),(3803,5,40,9,11),(3804,5,40,18,11),(3805,5,40,19,11),(3806,5,40,20,11),(3807,5,40,21,11),(3808,5,40,22,11),(3809,5,40,23,11),(3810,5,40,24,11),(3811,5,40,25,11),(3812,5,40,26,11),(3813,7,40,27,11),(3814,3,40,32,11),(3815,3,40,33,11),(3816,6,40,38,11),(3817,6,40,39,11),(3818,5,40,3,12),(3819,5,40,4,12),(3820,5,40,18,12),(3821,5,40,19,12),(3822,5,40,20,12),(3823,5,40,21,12),(3824,5,40,22,12),(3825,5,40,23,12),(3826,7,40,24,12),(3827,7,40,25,12),(3828,7,40,26,12),(3829,7,40,27,12),(3830,6,40,37,12),(3831,6,40,38,12),(3832,6,40,39,12),(3833,6,40,40,12),(3834,5,40,4,13),(3835,3,40,9,13),(3836,3,40,10,13),(3837,3,40,11,13),(3838,3,40,12,13),(3839,5,40,17,13),(3840,5,40,18,13),(3841,5,40,19,13),(3842,5,40,20,13),(3843,10,40,21,13),(3844,7,40,25,13),(3845,7,40,26,13),(3846,7,40,27,13),(3847,4,40,33,13),(3848,4,40,34,13),(3849,4,40,35,13),(3850,6,40,36,13),(3851,6,40,37,13),(3852,6,40,38,13),(3853,5,40,4,14),(3854,3,40,10,14),(3855,3,40,11,14),(3856,3,40,12,14),(3857,5,40,16,14),(3858,5,40,17,14),(3859,5,40,18,14),(3860,5,40,20,14),(3861,7,40,25,14),(3862,7,40,26,14),(3863,6,40,27,14),(3864,10,40,30,14),(3865,4,40,34,14),(3866,4,40,35,14),(3867,4,40,36,14),(3868,4,40,37,14),(3869,5,40,2,15),(3870,5,40,3,15),(3871,5,40,4,15),(3872,3,40,10,15),(3873,3,40,11,15),(3874,4,40,16,15),(3875,4,40,17,15),(3876,4,40,18,15),(3877,5,40,20,15),(3878,7,40,25,15),(3879,7,40,26,15),(3880,6,40,27,15),(3881,4,40,34,15),(3882,4,40,35,15),(3883,4,40,36,15),(3884,5,40,0,16),(3885,5,40,1,16),(3886,5,40,2,16),(3887,5,40,3,16),(3888,5,40,5,16),(3889,5,40,6,16),(3890,5,40,7,16),(3891,3,40,8,16),(3892,3,40,9,16),(3893,3,40,10,16),(3894,3,40,11,16),(3895,3,40,12,16),(3896,3,40,13,16),(3897,4,40,14,16),(3898,4,40,15,16),(3899,4,40,16,16),(3900,4,40,17,16),(3901,4,40,18,16),(3902,7,40,25,16),(3903,7,40,26,16),(3904,6,40,27,16),(3905,4,40,34,16),(3906,4,40,35,16),(3907,4,40,36,16),(3908,4,40,37,16),(3909,4,40,38,16),(3910,4,40,39,16),(3911,4,40,40,16),(3912,5,40,0,17),(3913,5,40,1,17),(3914,5,40,2,17),(3915,5,40,3,17),(3916,5,40,4,17),(3917,5,40,5,17),(3918,5,40,6,17),(3919,5,40,7,17),(3920,3,40,10,17),(3921,3,40,11,17),(3922,4,40,16,17),(3923,4,40,17,17),(3924,11,40,18,17),(3925,6,40,22,17),(3926,6,40,23,17),(3927,7,40,24,17),(3928,7,40,25,17),(3929,7,40,26,17),(3930,6,40,27,17),(3931,6,40,28,17),(3932,4,40,35,17),(3933,4,40,36,17),(3934,4,40,37,17),(3935,5,40,0,18),(3936,5,40,1,18),(3937,5,40,2,18),(3938,5,40,3,18),(3939,5,40,4,18),(3940,5,40,6,18),(3941,5,40,7,18),(3942,4,40,14,18),(3943,4,40,15,18),(3944,4,40,16,18),(3945,4,40,17,18),(3946,6,40,22,18),(3947,0,40,23,18),(3948,7,40,25,18),(3949,6,40,26,18),(3950,6,40,27,18),(3951,6,40,28,18),(3952,6,40,29,18),(3953,6,40,34,18),(3954,6,40,36,18),(3955,5,40,0,19),(3956,5,40,1,19),(3957,4,40,2,19),(3958,5,40,3,19),(3959,5,40,4,19),(3960,5,40,5,19),(3961,5,40,6,19),(3962,11,40,7,19),(3963,4,40,16,19),(3964,4,40,17,19),(3965,6,40,22,19),(3966,7,40,25,19),(3967,7,40,26,19),(3968,6,40,27,19),(3969,6,40,28,19),(3970,6,40,34,19),(3971,6,40,35,19),(3972,6,40,36,19),(3973,6,40,37,19),(3974,6,40,38,19),(3975,0,40,0,20),(3976,4,40,2,20),(3977,4,40,3,20),(3978,5,40,4,20),(3979,5,40,5,20),(3980,5,40,6,20),(3981,4,40,15,20),(3982,4,40,16,20),(3983,6,40,22,20),(3984,7,40,23,20),(3985,7,40,24,20),(3986,7,40,25,20),(3987,7,40,26,20),(3988,7,40,27,20),(3989,7,40,28,20),(3990,7,40,30,20),(3991,6,40,36,20),(3992,6,40,37,20),(3993,4,40,2,21),(3994,4,40,3,21),(3995,5,40,4,21),(3996,5,40,5,21),(3997,5,40,6,21),(3998,4,40,15,21),(3999,4,40,16,21),(4000,4,40,17,21),(4001,6,40,22,21),(4002,6,40,23,21),(4003,6,40,24,21),(4004,6,40,25,21),(4005,6,40,26,21),(4006,7,40,27,21),(4007,7,40,28,21),(4008,7,40,29,21),(4009,7,40,30,21),(4010,7,40,31,21),(4011,7,40,32,21),(4012,0,40,35,21),(4013,6,40,37,21),(4014,8,40,42,21),(4015,4,40,0,22),(4016,4,40,2,22),(4017,5,40,3,22),(4018,5,40,4,22),(4019,5,40,5,22),(4020,5,40,6,22),(4021,4,40,16,22),(4022,4,40,17,22),(4023,4,40,22,22),(4024,4,40,23,22),(4025,6,40,25,22),(4026,7,40,26,22),(4027,7,40,27,22),(4028,7,40,28,22),(4029,6,40,37,22),(4030,4,40,0,23),(4031,4,40,1,23),(4032,4,40,2,23),(4033,4,40,3,23),(4034,4,40,4,23),(4035,5,40,5,23),(4036,5,40,6,23),(4037,4,40,16,23),(4038,4,40,17,23),(4039,4,40,18,23),(4040,4,40,19,23),(4041,4,40,20,23),(4042,4,40,21,23),(4043,4,40,22,23),(4044,7,40,26,23),(4045,7,40,28,23),(4046,13,40,29,23),(4047,4,40,0,24),(4048,4,40,1,24),(4049,4,40,2,24),(4050,4,40,3,24),(4051,4,40,4,24),(4052,5,40,5,24),(4053,5,40,6,24),(4054,4,40,18,24),(4055,4,40,19,24),(4056,4,40,22,24),(4057,7,40,25,24),(4058,7,40,26,24),(4059,7,40,27,24),(4060,7,40,28,24),(4061,4,40,0,25),(4062,4,40,1,25),(4063,4,40,4,25),(4064,5,40,5,25),(4065,5,40,6,25),(4066,5,40,7,25),(4067,4,40,17,25),(4068,4,40,18,25),(4069,4,40,19,25),(4070,4,40,20,25),(4071,4,40,22,25),(4072,7,40,26,25),(4073,5,4,0,0),(4074,5,4,1,0),(4075,5,4,2,0),(4076,5,4,3,0),(4077,5,4,16,0),(4078,5,4,17,0),(4079,5,4,18,0),(4080,5,4,19,0),(4081,5,4,20,0),(4082,5,4,21,0),(4083,5,4,22,0),(4084,5,4,23,0),(4085,5,4,24,0),(4086,5,4,25,0),(4087,5,4,26,0),(4088,5,4,0,1),(4089,5,4,1,1),(4090,5,4,2,1),(4091,5,4,3,1),(4092,5,4,4,1),(4093,12,4,7,1),(4094,5,4,17,1),(4095,5,4,18,1),(4096,5,4,20,1),(4097,14,4,22,1),(4098,5,4,26,1),(4099,5,4,28,1),(4100,5,4,0,2),(4101,5,4,1,2),(4102,5,4,2,2),(4103,5,4,4,2),(4104,5,4,5,2),(4105,5,4,25,2),(4106,5,4,26,2),(4107,5,4,28,2),(4108,5,4,29,2),(4109,5,4,0,3),(4110,5,4,1,3),(4111,5,4,4,3),(4112,5,4,5,3),(4113,5,4,28,3),(4114,6,4,29,3),(4115,5,4,28,4),(4116,6,4,29,4),(4117,4,4,3,5),(4118,4,4,5,5),(4119,0,4,18,5),(4120,6,4,27,5),(4121,6,4,28,5),(4122,6,4,29,5),(4123,4,4,2,6),(4124,4,4,3,6),(4125,4,4,4,6),(4126,4,4,5,6),(4127,6,4,26,6),(4128,6,4,27,6),(4129,6,4,28,6),(4130,6,4,29,6),(4131,4,4,1,7),(4132,4,4,2,7),(4133,4,4,3,7),(4134,4,4,4,7),(4135,4,4,5,7),(4136,6,4,26,7),(4137,5,4,27,7),(4138,5,4,28,7),(4139,5,4,29,7),(4140,4,4,1,8),(4141,4,4,2,8),(4142,4,4,3,8),(4143,4,4,4,8),(4144,0,4,10,8),(4145,5,4,27,8),(4146,5,4,28,8),(4147,5,4,29,8),(4148,4,4,1,9),(4149,4,4,2,9),(4150,4,4,3,9),(4151,5,4,29,9),(4152,4,4,1,10),(4153,6,4,5,10),(4154,6,4,6,10),(4155,5,4,28,10),(4156,5,4,29,10),(4157,6,4,4,11),(4158,6,4,5,11),(4159,6,4,6,11),(4160,6,4,7,11),(4161,6,4,8,11),(4162,5,4,27,11),(4163,5,4,28,11),(4164,5,4,29,11),(4165,13,4,1,12),(4166,6,4,8,12),(4167,6,4,9,12),(4168,6,4,10,12),(4169,5,4,27,12),(4170,5,4,28,12),(4171,5,4,29,12),(4172,6,4,8,13),(4173,6,4,9,13),(4174,6,4,10,13),(4175,5,4,28,13),(4176,5,4,29,13),(4177,5,4,2,14),(4178,6,4,9,14),(4179,5,4,28,14),(4180,5,4,0,15),(4181,5,4,2,15),(4182,5,4,3,15),(4183,5,4,0,16),(4184,5,4,1,16),(4185,5,4,2,16),(4186,5,4,3,16),(4187,5,4,4,16),(4188,2,4,26,16),(4189,5,4,0,17),(4190,5,4,1,17),(4191,5,4,2,17),(4192,5,4,3,17),(4193,5,4,4,17),(4194,5,4,0,18),(4195,5,4,1,18),(4196,5,4,3,18),(4197,6,4,6,18),(4198,4,4,24,18),(4199,4,4,29,18),(4200,5,4,0,19),(4201,5,4,2,19),(4202,5,4,3,19),(4203,6,4,7,19),(4204,6,4,8,19),(4205,4,4,24,19),(4206,4,4,25,19),(4207,4,4,26,19),(4208,4,4,27,19),(4209,4,4,28,19),(4210,4,4,29,19),(4211,5,4,0,20),(4212,11,4,1,20),(4213,6,4,5,20),(4214,6,4,6,20),(4215,6,4,7,20),(4216,6,4,8,20),(4217,6,4,9,20),(4218,4,4,23,20),(4219,4,4,24,20),(4220,4,4,25,20),(4221,4,4,26,20),(4222,4,4,27,20),(4223,4,4,28,20),(4224,4,4,29,20),(4225,5,4,0,21),(4226,6,4,5,21),(4227,6,4,6,21),(4228,4,4,24,21),(4229,4,4,25,21),(4230,4,4,26,21),(4231,4,4,27,21),(4232,4,4,28,21),(4233,4,4,29,21),(4234,5,4,0,22),(4235,6,4,6,22),(4236,8,4,10,22),(4237,4,4,24,22),(4238,4,4,25,22),(4239,4,4,26,22),(4240,4,4,27,22),(4241,4,4,28,22),(4242,4,4,29,22),(4243,5,4,0,23),(4244,4,4,26,23),(4245,4,4,27,23),(4246,4,4,28,23),(4247,5,4,0,24),(4248,3,4,18,24),(4249,3,4,19,24),(4250,3,4,20,24),(4251,0,4,24,24),(4252,4,4,27,24),(4253,0,4,28,24),(4254,5,4,0,25),(4255,3,4,9,25),(4256,3,4,10,25),(4257,3,4,13,25),(4258,3,4,14,25),(4259,3,4,15,25),(4260,3,4,17,25),(4261,3,4,18,25),(4262,3,4,19,25),(4263,3,4,20,25),(4264,3,4,21,25),(4265,5,4,0,26),(4266,5,4,1,26),(4267,5,4,2,26),(4268,3,4,9,26),(4269,3,4,10,26),(4270,3,4,11,26),(4271,3,4,14,26),(4272,3,4,15,26),(4273,3,4,16,26),(4274,3,4,17,26),(4275,3,4,18,26),(4276,3,4,19,26),(4277,3,4,20,26),(4278,3,4,21,26),(4279,3,4,23,26),(4280,5,4,2,27),(4281,0,4,3,27),(4282,3,4,10,27),(4283,3,4,11,27),(4284,3,4,12,27),(4285,3,4,13,27),(4286,3,4,14,27),(4287,3,4,15,27),(4288,3,4,16,27),(4289,3,4,17,27),(4290,3,4,18,27),(4291,3,4,19,27),(4292,3,4,20,27),(4293,3,4,21,27),(4294,3,4,22,27),(4295,3,4,23,27),(4296,3,4,24,27),(4297,0,4,0,28),(4298,3,4,11,28),(4299,3,4,12,28),(4300,3,4,13,28),(4301,3,4,14,28),(4302,3,4,15,28),(4303,3,4,16,28),(4304,3,4,17,28),(4305,3,4,18,28),(4306,3,4,19,28),(4307,3,4,20,28),(4308,3,4,21,28),(4309,3,4,22,28),(4310,3,4,23,28),(4311,3,4,24,28),(4312,3,4,10,29),(4313,3,4,11,29),(4314,3,4,12,29),(4315,3,4,13,29),(4316,3,4,14,29),(4317,3,4,15,29),(4318,3,4,16,29),(4319,3,4,17,29),(4320,3,4,18,29),(4321,3,4,19,29),(4322,3,4,20,29),(4323,3,4,21,29),(4324,3,4,22,29),(4325,3,4,23,29);
/*!40000 ALTER TABLE `tiles` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `units`
--

DROP TABLE IF EXISTS `units`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `units` (
  `id` int(11) NOT NULL auto_increment,
  `hp` int(10) unsigned NOT NULL default '0',
  `level` tinyint(2) unsigned NOT NULL,
  `location_id` int(10) unsigned NOT NULL,
  `location_type` tinyint(2) unsigned NOT NULL,
  `player_id` int(11) default NULL,
  `last_update` datetime default NULL,
  `upgrade_ends_at` datetime default NULL,
  `pause_remainder` int(10) unsigned default NULL,
  `xp` mediumint(8) unsigned NOT NULL default '0',
  `hp_remainder` int(10) unsigned NOT NULL default '0',
  `type` varchar(50) NOT NULL,
  `flank` tinyint(2) unsigned NOT NULL default '0',
  `location_x` mediumint(9) default NULL,
  `location_y` mediumint(9) default NULL,
  `route_id` int(11) default NULL,
  `galaxy_id` int(11) NOT NULL,
  `stance` tinyint(2) unsigned NOT NULL default '0',
  `construction_mod` tinyint(2) unsigned NOT NULL default '0',
  PRIMARY KEY  (`id`),
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
INSERT INTO `units` VALUES (1,100,1,4,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,18,28,NULL,1,0,0),(2,100,1,4,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,18,28,NULL,1,0,0),(3,100,1,4,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,18,28,NULL,1,0,0),(4,100,1,4,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,18,28,NULL,1,0,0),(5,100,1,4,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,18,28,NULL,1,0,0),(6,200,1,4,4,NULL,NULL,NULL,NULL,0,0,'Glancer',0,18,28,NULL,1,0,0),(7,200,1,4,4,NULL,NULL,NULL,NULL,0,0,'Glancer',0,18,28,NULL,1,0,0),(8,200,1,4,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,18,28,NULL,1,0,0),(9,200,1,4,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,18,28,NULL,1,0,0),(10,100,1,4,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,18,28,NULL,1,0,0),(11,100,1,4,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,18,28,NULL,1,0,0),(12,100,1,4,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,18,28,NULL,1,0,0),(13,100,1,4,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,26,16,NULL,1,0,0),(14,100,1,4,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,26,16,NULL,1,0,0),(15,100,1,4,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,26,16,NULL,1,0,0),(16,100,1,4,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,26,16,NULL,1,0,0),(17,100,1,4,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,26,16,NULL,1,0,0),(18,200,1,4,4,NULL,NULL,NULL,NULL,0,0,'Glancer',0,26,16,NULL,1,0,0),(19,200,1,4,4,NULL,NULL,NULL,NULL,0,0,'Glancer',0,26,16,NULL,1,0,0),(20,200,1,4,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,26,16,NULL,1,0,0),(21,200,1,4,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,26,16,NULL,1,0,0),(22,100,1,4,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,26,16,NULL,1,0,0),(23,100,1,4,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,26,16,NULL,1,0,0),(24,100,1,4,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,26,16,NULL,1,0,0),(25,100,1,4,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,3,27,NULL,1,0,0),(26,100,1,4,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,3,27,NULL,1,0,0),(27,100,1,4,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,3,27,NULL,1,0,0),(28,100,1,4,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,3,27,NULL,1,0,0),(29,100,1,4,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,3,27,NULL,1,0,0),(30,200,1,4,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,3,27,NULL,1,0,0),(31,200,1,4,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,3,27,NULL,1,0,0),(32,100,1,4,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,28,24,NULL,1,0,0),(33,100,1,4,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,28,24,NULL,1,0,0),(34,100,1,4,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,28,24,NULL,1,0,0),(35,100,1,4,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,28,24,NULL,1,0,0),(36,100,1,4,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,28,24,NULL,1,0,0),(37,200,1,4,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,28,24,NULL,1,0,0),(38,200,1,4,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,28,24,NULL,1,0,0),(39,100,1,4,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,18,25,NULL,1,0,0),(40,100,1,4,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,18,25,NULL,1,0,0),(41,100,1,4,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,18,25,NULL,1,0,0),(42,100,1,4,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,18,25,NULL,1,0,0),(43,100,1,4,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,18,25,NULL,1,0,0),(44,200,1,4,4,NULL,NULL,NULL,NULL,0,0,'Glancer',0,18,25,NULL,1,0,0),(45,200,1,4,4,NULL,NULL,NULL,NULL,0,0,'Glancer',0,18,25,NULL,1,0,0),(46,200,1,4,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,18,25,NULL,1,0,0),(47,200,1,4,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,18,25,NULL,1,0,0),(48,100,1,4,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,18,25,NULL,1,0,0),(49,100,1,4,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,18,25,NULL,1,0,0),(50,100,1,4,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,18,25,NULL,1,0,0),(51,100,1,4,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,15,26,NULL,1,0,0),(52,100,1,4,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,15,26,NULL,1,0,0),(53,100,1,4,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,15,26,NULL,1,0,0),(54,100,1,4,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,15,26,NULL,1,0,0),(55,100,1,4,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,15,26,NULL,1,0,0),(56,200,1,4,4,NULL,NULL,NULL,NULL,0,0,'Glancer',0,15,26,NULL,1,0,0),(57,200,1,4,4,NULL,NULL,NULL,NULL,0,0,'Glancer',0,15,26,NULL,1,0,0),(58,200,1,4,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,15,26,NULL,1,0,0),(59,200,1,4,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,15,26,NULL,1,0,0),(60,100,1,4,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,15,26,NULL,1,0,0),(61,100,1,4,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,15,26,NULL,1,0,0),(62,100,1,4,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,15,26,NULL,1,0,0),(63,100,1,4,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,7,28,NULL,1,0,0),(64,100,1,4,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,7,28,NULL,1,0,0),(65,100,1,4,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,7,28,NULL,1,0,0),(66,100,1,4,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,7,28,NULL,1,0,0),(67,100,1,4,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,7,28,NULL,1,0,0),(68,200,1,4,4,NULL,NULL,NULL,NULL,0,0,'Glancer',0,7,28,NULL,1,0,0),(69,200,1,4,4,NULL,NULL,NULL,NULL,0,0,'Glancer',0,7,28,NULL,1,0,0),(70,200,1,4,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,7,28,NULL,1,0,0),(71,200,1,4,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,7,28,NULL,1,0,0),(72,100,1,4,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,7,28,NULL,1,0,0),(73,100,1,4,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,7,28,NULL,1,0,0),(74,100,1,4,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,7,28,NULL,1,0,0),(75,100,1,4,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,24,24,NULL,1,0,0),(76,100,1,4,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,24,24,NULL,1,0,0),(77,100,1,4,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,24,24,NULL,1,0,0),(78,100,1,4,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,24,24,NULL,1,0,0),(79,100,1,4,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,24,24,NULL,1,0,0),(80,200,1,4,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,24,24,NULL,1,0,0),(81,200,1,4,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,24,24,NULL,1,0,0),(82,100,1,4,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,0,28,NULL,1,0,0),(83,100,1,4,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,0,28,NULL,1,0,0),(84,100,1,4,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,0,28,NULL,1,0,0),(85,100,1,4,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,0,28,NULL,1,0,0),(86,100,1,4,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,0,28,NULL,1,0,0),(87,200,1,4,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,0,28,NULL,1,0,0),(88,200,1,4,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,0,28,NULL,1,0,0),(89,100,1,4,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,22,27,NULL,1,0,0),(90,100,1,4,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,22,27,NULL,1,0,0),(91,100,1,4,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,22,27,NULL,1,0,0),(92,100,1,4,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,22,27,NULL,1,0,0),(93,100,1,4,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,22,27,NULL,1,0,0),(94,200,1,4,4,NULL,NULL,NULL,NULL,0,0,'Glancer',0,22,27,NULL,1,0,0),(95,200,1,4,4,NULL,NULL,NULL,NULL,0,0,'Glancer',0,22,27,NULL,1,0,0),(96,200,1,4,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,22,27,NULL,1,0,0),(97,200,1,4,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,22,27,NULL,1,0,0),(98,100,1,4,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,22,27,NULL,1,0,0),(99,100,1,4,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,22,27,NULL,1,0,0),(100,100,1,4,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,22,27,NULL,1,0,0),(101,100,1,4,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,25,20,NULL,1,0,0),(102,100,1,4,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,25,20,NULL,1,0,0),(103,100,1,4,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,25,20,NULL,1,0,0),(104,100,1,4,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,25,20,NULL,1,0,0),(105,100,1,4,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,25,20,NULL,1,0,0),(106,200,1,4,4,NULL,NULL,NULL,NULL,0,0,'Glancer',0,25,20,NULL,1,0,0),(107,200,1,4,4,NULL,NULL,NULL,NULL,0,0,'Glancer',0,25,20,NULL,1,0,0),(108,200,1,4,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,25,20,NULL,1,0,0),(109,200,1,4,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,25,20,NULL,1,0,0),(110,100,1,4,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,25,20,NULL,1,0,0),(111,100,1,4,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,25,20,NULL,1,0,0),(112,100,1,4,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,25,20,NULL,1,0,0),(113,100,1,4,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,12,27,NULL,1,0,0),(114,100,1,4,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,12,27,NULL,1,0,0),(115,100,1,4,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,12,27,NULL,1,0,0),(116,100,1,4,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,12,27,NULL,1,0,0),(117,100,1,4,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,12,27,NULL,1,0,0),(118,200,1,4,4,NULL,NULL,NULL,NULL,0,0,'Glancer',0,12,27,NULL,1,0,0),(119,200,1,4,4,NULL,NULL,NULL,NULL,0,0,'Glancer',0,12,27,NULL,1,0,0),(120,200,1,4,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,12,27,NULL,1,0,0),(121,200,1,4,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,12,27,NULL,1,0,0),(122,100,1,4,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,12,27,NULL,1,0,0),(123,100,1,4,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,12,27,NULL,1,0,0),(124,100,1,4,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,12,27,NULL,1,0,0),(125,100,1,4,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,26,27,NULL,1,0,0),(126,100,1,4,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,26,27,NULL,1,0,0),(127,100,1,4,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,26,27,NULL,1,0,0),(128,100,1,4,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,26,27,NULL,1,0,0),(129,100,1,4,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,26,27,NULL,1,0,0),(130,200,1,4,4,NULL,NULL,NULL,NULL,0,0,'Glancer',0,26,27,NULL,1,0,0),(131,200,1,4,4,NULL,NULL,NULL,NULL,0,0,'Glancer',0,26,27,NULL,1,0,0),(132,200,1,4,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,26,27,NULL,1,0,0),(133,200,1,4,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,26,27,NULL,1,0,0),(134,100,1,4,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,26,27,NULL,1,0,0),(135,100,1,4,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,26,27,NULL,1,0,0),(136,100,1,4,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,26,27,NULL,1,0,0);
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

-- Dump completed on 2010-10-06 11:37:31
