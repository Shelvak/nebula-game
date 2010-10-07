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
INSERT INTO `buildings` VALUES (1,3,7,16,0,0,0,1,'Thunder',NULL,8,17,NULL,1,300,NULL,0,NULL,NULL,0),(2,3,21,16,0,0,0,1,'Thunder',NULL,22,17,NULL,1,300,NULL,0,NULL,NULL,0),(3,3,21,9,0,0,0,1,'Screamer',NULL,22,10,NULL,1,300,NULL,0,NULL,NULL,0),(4,3,18,28,0,0,0,1,'NpcSolarPlant',NULL,19,29,NULL,0,1000,NULL,0,NULL,NULL,0),(5,3,7,9,0,0,0,1,'Vulcan',NULL,8,10,NULL,1,300,NULL,0,NULL,NULL,0),(6,3,14,22,0,0,0,1,'Thunder',NULL,15,23,NULL,1,300,NULL,0,NULL,NULL,0),(7,3,26,16,0,0,0,1,'NpcZetiumExtractor',NULL,27,17,NULL,0,800,NULL,0,NULL,NULL,0),(8,3,3,27,0,0,0,1,'NpcMetalExtractor',NULL,4,28,NULL,0,400,NULL,0,NULL,NULL,0),(9,3,28,24,0,0,0,1,'NpcMetalExtractor',NULL,29,25,NULL,0,400,NULL,0,NULL,NULL,0),(10,3,18,25,0,0,0,1,'NpcSolarPlant',NULL,19,26,NULL,0,1000,NULL,0,NULL,NULL,0),(11,3,15,26,0,0,0,1,'NpcSolarPlant',NULL,16,27,NULL,0,1000,NULL,0,NULL,NULL,0),(12,3,7,28,0,0,0,1,'NpcCommunicationsHub',NULL,9,29,NULL,0,1200,NULL,0,NULL,NULL,0),(13,3,21,22,0,0,0,1,'Vulcan',NULL,22,23,NULL,1,300,NULL,0,NULL,NULL,0),(14,3,24,24,0,0,0,1,'NpcMetalExtractor',NULL,25,25,NULL,0,400,NULL,0,NULL,NULL,0),(15,3,0,28,0,0,0,1,'NpcMetalExtractor',NULL,1,29,NULL,0,400,NULL,0,NULL,NULL,0),(16,3,11,14,0,0,0,1,'Mothership',NULL,18,19,NULL,1,10500,NULL,0,NULL,NULL,0),(17,3,22,27,0,0,0,1,'NpcSolarPlant',NULL,23,28,NULL,0,1000,NULL,0,NULL,NULL,0),(18,3,14,9,0,0,0,1,'Thunder',NULL,15,10,NULL,1,300,NULL,0,NULL,NULL,0),(19,3,25,20,0,0,0,1,'NpcTemple',NULL,27,22,NULL,0,1500,NULL,0,NULL,NULL,0),(20,3,12,27,0,0,0,1,'NpcSolarPlant',NULL,13,28,NULL,0,1000,NULL,0,NULL,NULL,0),(21,3,7,22,0,0,0,1,'Screamer',NULL,8,23,NULL,1,300,NULL,0,NULL,NULL,0),(22,3,26,27,0,0,0,1,'NpcCommunicationsHub',NULL,28,28,NULL,0,1200,NULL,0,NULL,NULL,0);
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
INSERT INTO `folliages` VALUES (1,0,2,0),(1,0,11,6),(1,0,16,3),(1,0,22,4),(1,1,0,3),(1,1,1,0),(1,1,15,13),(1,1,22,10),(1,2,12,1),(1,2,13,10),(1,2,19,7),(1,3,1,8),(1,3,12,10),(1,4,0,13),(1,4,12,6),(1,5,1,11),(1,6,9,5),(1,6,17,13),(1,8,0,9),(1,9,0,6),(1,9,11,7),(1,9,19,12),(1,9,21,2),(1,10,0,0),(1,10,2,1),(1,11,1,4),(1,11,21,7),(1,12,1,8),(1,12,2,10),(1,12,4,2),(1,12,5,7),(1,12,19,11),(1,13,1,2),(1,13,11,9),(1,14,10,2),(1,14,11,0),(1,17,0,7),(1,18,1,4),(1,19,16,3),(1,20,7,6),(1,20,16,13),(1,21,7,0),(1,22,9,10),(1,22,14,5),(1,23,9,8),(1,23,13,7),(1,23,18,7),(1,24,16,2),(1,25,9,8),(1,25,12,1),(1,25,15,3),(1,26,3,6),(1,26,5,0),(1,26,8,1),(1,26,10,7),(1,26,15,11),(1,27,4,5),(1,27,9,4),(1,27,11,12),(1,27,13,7),(1,28,6,8),(1,28,11,4),(1,29,13,13),(1,29,20,11),(1,29,22,2),(1,30,13,13),(1,31,14,0),(1,32,7,6),(1,32,9,9),(1,32,12,8),(1,32,17,0),(1,32,22,12),(1,33,0,2),(1,33,1,10),(1,33,3,6),(1,33,7,13),(1,33,8,2),(1,33,10,12),(1,33,12,12),(1,33,15,2),(1,33,17,0),(1,34,3,13),(1,34,6,11),(1,34,8,9),(1,34,10,10),(1,34,11,12),(1,34,12,0),(1,34,15,10),(1,35,2,5),(1,35,3,11),(1,35,13,13),(1,36,1,5),(1,36,5,9),(1,36,6,8),(1,36,10,8),(1,36,15,8),(1,36,16,10),(1,36,22,12),(1,37,1,0),(1,37,2,0),(1,37,3,6),(1,37,9,2),(1,37,11,3),(1,37,15,0),(1,37,17,1),(3,0,10,8),(3,0,12,1),(3,0,13,3),(3,0,27,7),(3,1,5,12),(3,1,15,13),(3,2,5,4),(3,2,11,6),(3,3,26,3),(3,3,29,6),(3,4,15,10),(3,4,19,13),(3,5,1,4),(3,5,4,5),(3,5,8,6),(3,5,23,5),(3,5,29,3),(3,6,2,0),(3,6,5,11),(3,6,7,6),(3,6,8,6),(3,6,15,8),(3,6,27,13),(3,6,28,4),(3,7,0,13),(3,7,15,8),(3,7,27,7),(3,8,0,8),(3,8,14,8),(3,9,9,6),(3,9,11,10),(3,9,16,7),(3,9,17,2),(3,9,19,9),(3,9,27,8),(3,10,0,13),(3,10,20,1),(3,11,12,12),(3,12,7,2),(3,13,0,5),(3,13,4,12),(3,13,5,6),(3,13,10,3),(3,13,22,3),(3,14,0,1),(3,14,1,3),(3,14,6,2),(3,14,7,13),(3,14,11,7),(3,15,1,5),(3,15,2,9),(3,15,13,11),(3,16,3,9),(3,16,4,1),(3,16,6,11),(3,16,7,5),(3,16,12,9),(3,16,20,3),(3,16,21,12),(3,16,25,5),(3,17,2,0),(3,17,5,1),(3,17,12,5),(3,17,21,13),(3,18,2,5),(3,18,4,5),(3,18,10,11),(3,18,13,1),(3,18,22,1),(3,19,9,3),(3,19,13,12),(3,19,15,8),(3,19,17,0),(3,19,22,11),(3,20,7,0),(3,20,11,6),(3,20,14,5),(3,20,21,10),(3,21,1,10),(3,21,21,11),(3,22,5,10),(3,22,7,9),(3,22,8,1),(3,22,13,0),(3,22,20,9),(3,23,5,6),(3,23,8,6),(3,23,9,6),(3,23,10,12),(3,23,11,6),(3,23,13,4),(3,23,17,10),(3,23,23,4),(3,23,24,12),(3,24,7,9),(3,24,9,3),(3,24,10,11),(3,24,11,5),(3,24,13,8),(3,24,17,1),(3,25,5,0),(3,25,10,13),(3,26,5,6),(3,26,8,7),(3,26,14,11),(3,26,26,1),(3,27,14,4),(3,28,16,13),(3,29,1,3),(3,29,17,3),(3,29,26,11),(5,0,4,6),(5,0,10,2),(5,0,14,8),(5,0,15,8),(5,0,20,3),(5,1,2,3),(5,1,4,6),(5,1,11,0),(5,1,12,12),(5,1,17,9),(5,1,18,11),(5,1,20,1),(5,1,22,9),(5,2,3,13),(5,2,5,10),(5,2,8,9),(5,2,12,0),(5,2,20,12),(5,3,0,8),(5,3,1,6),(5,3,3,12),(5,3,8,8),(5,3,17,9),(5,3,20,1),(5,4,7,3),(5,4,8,9),(5,4,11,8),(5,4,12,10),(5,4,13,5),(5,4,18,2),(5,4,19,5),(5,5,3,11),(5,5,7,10),(5,5,13,8),(5,6,0,10),(5,6,8,9),(5,6,17,5),(5,6,19,5),(5,7,4,1),(5,7,6,7),(5,7,18,10),(5,7,24,11),(5,7,29,11),(5,8,0,12),(5,8,1,3),(5,8,2,8),(5,8,5,8),(5,8,7,12),(5,8,29,11),(5,9,1,4),(5,9,6,0),(5,9,7,4),(5,9,19,8),(5,9,29,9),(5,10,0,4),(5,10,3,7),(5,10,7,12),(5,10,9,4),(5,10,24,4),(5,10,25,2),(5,10,26,4),(5,11,10,7),(5,11,11,7),(5,11,16,0),(5,11,17,6),(5,11,18,5),(5,11,20,9),(5,12,1,8),(5,12,8,3),(5,12,9,7),(5,12,11,12),(5,12,17,4),(5,12,18,11),(5,12,20,4),(5,12,26,6),(5,12,28,3),(5,13,12,5),(5,13,17,9),(5,13,18,12),(5,13,25,3),(5,13,27,12),(5,14,9,4),(5,14,12,3),(5,14,20,3),(5,14,25,11),(5,14,28,13),(5,14,29,6),(5,15,1,2),(5,15,3,10),(5,15,4,2),(5,15,9,13),(5,15,17,4),(5,15,26,3),(5,16,1,0),(5,16,2,2),(5,16,22,3),(5,16,27,0),(5,16,28,1),(5,17,1,2),(5,17,2,6),(5,17,6,1),(5,17,26,3),(5,17,27,7),(5,18,2,2),(5,18,6,9),(5,18,15,10),(5,18,21,0),(5,18,26,5),(5,18,28,12),(5,19,6,12),(5,19,8,1),(5,19,24,11),(5,20,10,11),(5,20,11,9),(5,20,14,13),(5,20,25,11),(5,20,27,10),(5,21,4,0),(5,21,7,3),(5,21,8,4),(5,21,12,4),(5,21,13,0),(5,21,15,6),(5,22,4,2),(5,22,8,0),(5,22,12,9),(5,22,14,1),(5,23,0,2),(5,23,7,9),(5,23,8,7),(5,23,13,5),(5,23,15,3),(5,23,18,6),(5,23,19,5),(5,23,20,0),(5,23,21,2),(5,23,22,8),(5,24,1,10),(5,24,2,7),(5,24,4,3),(5,24,6,2),(5,24,7,5),(5,24,11,4),(5,24,15,10),(5,24,19,4),(5,24,20,12),(5,24,22,3),(5,24,26,0),(5,25,2,12),(5,25,3,9),(5,25,6,3),(5,25,10,9),(5,25,11,4),(5,25,18,11),(5,25,20,8),(5,26,0,0),(5,26,8,4),(5,26,12,13),(5,26,16,0),(5,26,17,10),(5,26,24,5),(5,27,1,5),(5,27,22,3),(5,27,24,9),(5,27,28,11),(5,28,24,0),(5,28,26,3),(5,28,29,1),(5,29,0,9),(5,29,2,10),(5,29,6,13),(5,29,14,5),(5,29,16,6),(5,29,18,9),(5,30,0,2),(5,30,1,7),(5,30,6,13),(5,30,14,11),(5,30,15,5),(5,30,24,10),(5,30,26,0),(5,30,28,13),(5,30,29,1),(5,31,2,7),(5,31,8,10),(5,31,12,12),(5,31,22,10),(5,31,27,9),(5,32,3,0),(5,32,4,6),(5,32,5,4),(5,32,7,4),(5,32,27,7),(5,32,29,4),(5,33,4,6),(5,33,18,10),(5,33,27,10),(5,33,29,13),(5,34,5,6),(5,34,6,8),(5,34,8,4),(5,34,19,5),(5,35,27,4),(5,38,20,10),(5,38,29,5),(5,39,29,3),(5,40,23,7),(5,40,28,7),(5,41,28,6),(17,0,0,1),(17,0,2,13),(17,1,13,6),(17,4,2,2),(17,6,5,13),(17,7,3,1),(17,7,5,11),(17,8,1,12),(17,8,2,3),(17,9,4,8),(17,10,0,6),(17,10,1,13),(17,10,4,0),(17,10,5,11),(17,10,13,6),(17,11,0,10),(17,11,13,2),(17,12,6,12),(17,13,2,13),(17,13,13,7),(17,14,3,8),(17,14,8,5),(17,15,1,3),(17,15,4,5),(17,15,11,3),(17,16,0,13),(17,16,6,6),(17,17,1,12),(17,18,0,9),(17,18,6,8),(17,20,13,0),(17,21,13,12),(17,24,3,2),(17,24,10,8),(17,24,11,13),(17,24,12,5),(17,25,4,0),(17,25,12,13),(17,26,5,3),(17,28,12,0),(17,28,13,2),(17,30,9,5),(17,31,4,0),(17,31,6,8),(17,31,10,5),(17,31,13,9),(17,32,4,11),(17,32,13,10),(17,34,10,5),(17,37,2,2),(17,37,9,7),(17,38,4,3),(17,38,10,11),(17,39,4,7),(17,39,11,4),(17,41,12,11),(17,41,13,10),(17,42,2,6),(17,43,12,3),(17,44,6,8),(17,44,8,6),(19,0,0,10),(19,0,7,1),(19,0,11,2),(19,1,0,4),(19,1,1,10),(19,1,7,1),(19,2,1,3),(19,2,3,12),(19,2,4,8),(19,2,5,2),(19,2,6,5),(19,2,8,13),(19,2,13,10),(19,3,5,3),(19,3,13,4),(19,5,4,2),(19,6,3,7),(19,6,7,3),(19,7,0,7),(19,7,2,4),(19,7,6,4),(19,8,6,2),(19,8,14,4),(19,9,0,5),(19,9,8,2),(19,9,9,5),(19,9,22,11),(19,10,1,2),(19,10,4,4),(19,10,14,9),(19,10,15,2),(19,11,0,7),(19,12,1,6),(19,12,13,6),(19,12,20,0),(19,13,15,0),(19,13,19,0),(19,13,22,1),(19,14,1,5),(19,14,6,0),(19,14,13,12),(19,14,14,12),(19,15,2,13),(19,15,4,0),(19,15,5,6),(19,15,6,5),(19,15,16,3),(19,17,13,8),(19,19,4,11),(19,19,6,8),(19,19,13,10),(19,20,0,1),(19,21,5,11),(19,21,14,0),(19,21,15,10),(19,21,16,6),(19,21,18,13),(19,22,4,12),(19,22,7,6),(19,22,10,10),(19,22,15,9),(19,22,16,0),(19,23,0,9),(19,23,5,7),(19,23,6,12),(19,23,10,13),(19,23,11,3),(19,24,5,5),(19,24,8,13),(19,24,10,1),(19,25,4,3),(19,26,10,10),(19,26,12,8),(19,26,17,13),(19,26,18,7),(19,26,19,2),(19,27,11,7),(19,27,13,12),(19,28,1,1),(19,28,15,0),(19,28,16,0),(19,28,17,4),(19,28,18,5),(19,29,14,12),(19,29,17,12),(19,30,3,7),(19,31,1,8),(19,31,2,7),(19,31,16,8),(19,32,0,8),(19,32,4,4),(19,32,7,6),(19,32,17,8),(19,33,3,10),(19,34,1,6),(19,34,3,4),(19,34,11,1),(19,34,12,7),(19,36,22,5),(19,37,21,2),(19,38,15,8),(19,39,1,8),(19,39,15,3),(19,40,2,10),(19,40,8,10),(19,41,2,1),(19,41,8,2),(19,41,19,4),(19,41,20,8),(19,41,21,13),(19,42,14,1),(19,42,19,5),(19,42,21,0),(19,42,22,4),(21,0,0,10),(21,1,1,13),(21,2,0,4),(21,2,5,12),(21,2,14,8),(21,5,2,2),(21,5,5,7),(21,6,1,4),(21,6,2,8),(21,7,1,12),(21,7,7,11),(21,7,10,3),(21,7,11,7),(21,8,11,9),(21,9,1,10),(21,9,17,5),(21,9,18,5),(21,10,10,1),(21,10,12,12),(21,10,13,11),(21,10,17,5),(21,11,1,2),(21,12,2,9),(21,12,3,1),(21,12,17,5),(21,14,8,11),(21,14,13,2),(21,14,16,9),(21,15,14,1),(21,16,13,11),(21,17,1,13),(21,17,11,6),(21,17,12,2),(21,18,0,2),(21,22,3,0),(21,24,0,5),(21,24,6,9),(21,24,9,9),(21,24,16,12),(21,25,16,10),(21,26,0,10),(21,26,16,10),(21,27,12,11),(21,27,16,11),(21,27,18,7),(21,28,9,8),(21,28,12,4),(21,28,14,13),(21,30,17,13),(21,31,3,8),(21,31,4,11),(21,31,15,3),(21,31,18,4),(21,33,15,7),(21,34,16,3),(21,35,16,11),(21,36,4,13),(21,36,9,5),(21,36,12,6),(21,37,15,6),(21,39,9,12),(21,41,11,6),(21,42,10,13),(21,42,18,11),(21,43,10,10),(21,43,16,11),(21,44,18,2),(21,45,7,8),(21,45,18,7),(21,46,12,2),(21,46,16,2),(21,46,17,7),(21,47,7,3),(21,47,8,9),(21,48,3,3),(21,48,9,0),(21,48,12,5),(21,48,17,12),(23,0,1,1),(23,0,3,6),(23,0,14,7),(23,0,15,3),(23,0,16,11),(23,1,3,12),(23,1,10,2),(23,1,16,10),(23,2,3,11),(23,2,6,6),(23,3,0,3),(23,3,17,12),(23,4,2,6),(23,4,17,13),(23,6,15,11),(23,7,1,1),(23,7,5,11),(23,7,6,9),(23,7,12,0),(23,7,13,2),(23,8,4,4),(23,9,12,4),(23,10,5,3),(23,11,3,11),(23,12,4,8),(23,13,6,5),(23,13,20,13),(23,14,1,12),(23,14,19,5),(23,15,19,10),(23,16,10,4),(23,17,3,8),(23,17,8,12),(23,18,6,12),(23,18,7,13),(23,19,4,2),(23,19,20,8),(23,20,2,5),(23,20,6,10),(23,20,8,11),(23,20,12,10),(23,20,19,3),(23,20,20,3),(23,21,2,3),(23,21,7,9),(23,21,9,9),(23,22,2,9),(23,23,0,5),(23,24,1,12),(23,24,3,13),(23,25,0,0),(23,25,1,9),(23,26,0,0),(23,26,12,4),(23,28,8,12),(23,28,11,0),(23,29,11,8),(23,29,12,0),(23,29,18,8),(23,30,11,1),(23,30,12,1),(23,31,4,3),(23,31,9,1),(23,31,19,10),(23,32,12,13),(23,32,13,12),(23,32,19,4),(23,33,1,8),(23,33,8,0),(23,33,11,4),(23,33,13,3),(23,33,19,11),(23,35,4,1),(23,35,5,9),(23,35,6,3),(23,35,7,0),(23,35,12,12),(23,36,3,6),(23,36,12,4),(23,37,5,6),(23,37,14,3),(23,37,19,5),(23,38,4,7),(23,38,10,3),(23,38,11,7),(23,38,13,7),(23,39,19,6),(23,40,5,2),(23,40,15,1),(23,40,16,1),(23,41,0,8),(23,43,17,8),(23,46,0,0),(23,46,4,5),(23,46,7,6),(23,46,11,8),(23,46,15,1),(23,47,3,12),(23,49,12,10),(23,49,14,7),(23,50,1,7),(23,50,7,2),(23,50,12,4),(23,51,0,10),(23,52,0,3),(23,52,14,8),(23,52,16,8),(23,52,20,4),(26,0,6,6),(26,0,7,8),(26,0,8,7),(26,1,2,6),(26,2,6,2),(26,2,7,1),(26,3,5,5),(26,4,15,5),(26,5,4,2),(26,5,5,9),(26,5,9,2),(26,5,10,11),(26,6,5,1),(26,6,9,13),(26,8,1,6),(26,8,6,2),(26,8,15,13),(26,10,13,7),(26,11,13,11),(26,11,15,6),(26,13,8,2),(26,13,14,9),(26,14,8,12),(26,14,13,6),(26,15,0,0),(26,15,4,8),(26,15,5,4),(26,17,7,12),(26,18,7,6),(26,19,3,9),(26,19,9,11),(26,20,14,5),(26,21,1,11),(26,21,10,0),(26,21,14,13),(26,21,15,10),(26,23,1,13),(26,23,4,2),(26,23,15,12),(26,24,0,3),(26,25,9,10),(26,25,13,13),(26,26,3,7),(26,26,7,10),(26,26,14,1),(26,27,4,13),(26,27,6,13),(26,27,8,10),(26,28,4,5),(26,28,5,6),(26,28,7,13),(26,30,3,11),(26,31,15,5),(26,32,13,7),(26,33,0,1),(26,33,5,1),(26,34,11,1),(26,35,0,10),(26,35,3,2),(26,35,13,10),(26,36,2,4),(26,36,4,6),(26,37,4,11),(26,37,8,8),(26,37,11,13),(26,37,12,0),(26,38,8,10),(26,40,11,11),(26,40,12,2),(26,45,0,4),(26,46,15,9),(26,47,1,1),(26,47,15,6),(26,49,10,0),(26,49,13,12),(27,0,7,11),(27,0,13,0),(27,1,2,6),(27,1,16,7),(27,2,7,0),(27,4,6,11),(27,4,7,2),(27,4,8,5),(27,5,15,6),(27,6,9,0),(27,6,11,4),(27,7,8,11),(27,7,15,11),(27,8,10,1),(27,8,11,1),(27,9,6,13),(27,10,12,1),(27,11,9,4),(27,11,12,11),(27,13,16,7),(27,14,0,3),(27,14,3,8),(27,14,4,4),(27,15,0,10),(27,15,1,8),(27,17,2,8),(27,18,0,5),(27,19,0,1),(27,19,16,4),(27,20,0,5),(27,20,5,1),(27,20,13,9),(27,20,14,4),(27,20,15,11),(27,21,2,4),(27,21,4,3),(27,21,12,10),(27,22,1,7),(27,22,13,12),(27,23,0,9),(27,23,9,4),(27,24,0,1),(27,24,10,0),(27,25,0,0),(27,25,11,8),(27,27,0,7),(27,27,2,12),(27,27,9,13),(27,27,10,3),(27,28,0,3),(27,28,3,13),(27,29,0,6),(27,29,10,1),(27,30,1,2),(27,30,13,13),(27,32,0,8),(27,33,1,2),(27,34,6,8),(27,34,13,11),(27,35,13,5),(27,36,7,8),(27,36,9,10),(27,37,9,3),(27,38,9,9),(27,38,10,4),(27,39,5,12),(27,39,9,13),(27,39,15,13),(27,40,4,12),(27,40,5,5),(27,40,8,3),(27,40,10,3),(27,41,5,6),(27,41,9,5),(27,41,16,12),(27,43,3,11),(27,43,16,11),(27,44,13,11),(27,46,5,10),(27,46,7,11),(27,46,13,10),(35,0,1,10),(35,0,10,12),(35,1,1,2),(35,1,4,3),(35,1,5,12),(35,1,6,1),(35,2,0,5),(35,2,3,5),(35,3,5,4),(35,3,8,8),(35,4,2,3),(35,4,4,7),(35,4,9,5),(35,4,13,6),(35,4,14,13),(35,6,1,10),(35,6,9,2),(35,7,7,6),(35,7,8,5),(35,7,9,1),(35,7,14,9),(35,7,18,0),(35,8,2,2),(35,8,3,4),(35,8,14,13),(35,9,0,12),(35,9,6,0),(35,9,9,10),(35,10,2,12),(35,11,2,7),(35,11,12,8),(35,11,17,10),(35,12,0,0),(35,12,1,2),(35,12,2,1),(35,12,6,2),(35,13,2,12),(35,13,13,2),(35,14,0,3),(35,14,5,2),(35,14,12,0),(35,15,3,12),(35,15,6,5),(35,15,7,8),(35,15,15,5),(35,16,12,9),(35,16,16,11),(35,17,3,1),(35,17,8,11),(35,17,9,8),(35,19,14,11),(35,22,1,3),(35,22,4,10),(35,23,3,8),(35,23,14,6),(35,24,3,8),(35,24,13,13),(35,24,14,7),(35,24,18,8),(35,25,4,1),(35,27,0,4),(35,28,15,2),(35,29,16,0),(35,31,13,10),(35,33,8,9),(35,33,9,6),(35,33,10,1),(35,35,0,6),(35,36,10,13),(35,36,12,7),(35,38,0,0),(35,38,12,0),(35,40,1,1),(35,40,7,2),(35,42,2,11),(35,43,0,5),(35,43,18,13),(35,44,4,4),(35,44,9,5),(35,44,14,7),(35,44,16,12),(35,45,7,11),(35,45,9,3),(35,45,17,8),(35,46,6,12),(35,46,13,1),(35,46,16,3),(35,47,4,5),(35,47,9,4),(35,47,11,5),(35,47,12,9),(35,48,4,9),(35,48,10,5),(35,48,15,2),(35,49,4,11),(35,49,11,1),(35,49,13,10),(35,50,17,11),(35,51,1,11),(35,51,2,3),(35,51,3,5),(35,51,10,5),(35,51,17,0),(35,52,3,11),(35,52,12,4),(36,0,6,13),(36,0,7,6),(36,0,11,2),(36,0,13,6),(36,0,16,11),(36,1,0,11),(36,1,12,1),(36,1,14,13),(36,2,8,2),(36,2,12,11),(36,3,0,3),(36,3,14,6),(36,3,16,11),(36,4,15,2),(36,4,16,7),(36,5,14,10),(36,6,8,12),(36,6,13,8),(36,6,16,3),(36,10,0,1),(36,10,15,8),(36,11,2,3),(36,12,0,9),(36,12,1,10),(36,12,2,13),(36,13,0,8),(36,13,10,0),(36,14,9,10),(36,14,10,13),(36,15,13,5),(36,16,9,0),(36,17,3,8),(36,17,4,9),(36,17,8,5),(36,17,10,10),(36,17,14,5),(36,18,3,6),(36,20,0,12),(36,20,2,9),(36,20,3,2),(36,20,4,4),(36,20,15,6),(36,21,4,1),(36,22,6,1),(36,22,16,10),(36,23,7,8),(36,26,0,3),(36,26,1,12),(36,26,16,9),(36,27,1,11),(36,27,2,13),(36,27,16,5),(36,28,0,9),(36,28,3,8),(36,29,1,3),(36,29,15,10),(36,30,9,11),(36,30,15,1),(36,30,16,12),(36,31,10,10),(36,31,11,11),(36,31,12,12),(36,31,16,2),(36,32,5,1),(36,32,10,13),(36,32,16,9),(36,33,10,2),(36,34,1,2),(36,34,4,8),(36,35,1,0),(36,35,4,0),(36,35,5,8),(36,36,5,3),(36,37,5,10),(36,38,8,0),(36,39,7,9),(36,39,8,9),(36,39,10,10),(36,40,2,7),(36,40,3,10),(36,40,5,13),(36,40,7,10),(36,40,10,11),(36,40,16,8),(36,41,5,6),(36,41,9,10),(36,41,10,2),(36,41,11,11),(36,43,3,8),(36,43,6,4),(36,43,7,2),(36,43,8,8),(36,43,12,12),(36,44,7,11),(36,44,8,2),(36,45,6,5),(36,45,7,13),(36,46,1,5),(36,46,10,10),(36,46,14,0),(37,0,0,2),(37,0,1,5),(37,0,19,2),(37,1,2,2),(37,1,16,3),(37,1,18,7),(37,2,5,6),(37,3,1,9),(37,3,14,3),(37,3,21,1),(37,4,1,1),(37,4,8,4),(37,4,9,12),(37,4,17,13),(37,4,19,13),(37,5,11,8),(37,5,13,11),(37,5,18,3),(37,5,21,2),(37,6,2,10),(37,6,14,5),(37,6,22,7),(37,7,13,13),(37,7,15,0),(37,7,20,9),(37,7,21,10),(37,9,5,4),(37,9,9,5),(37,9,21,8),(37,10,1,5),(37,10,9,12),(37,10,14,3),(37,11,5,0),(37,12,4,8),(37,13,4,4),(37,13,5,2),(37,13,6,2),(37,15,5,2),(37,15,6,12),(37,16,2,7),(37,16,22,13),(37,17,6,11),(37,18,6,3),(37,19,6,2),(37,19,13,12),(37,19,21,2),(37,20,4,11),(37,20,19,2),(37,20,21,0),(37,23,21,13),(37,25,17,13),(37,27,8,8),(37,28,8,5),(37,29,0,9),(37,29,6,11),(37,29,8,10),(37,30,8,1),(37,31,8,12),(37,31,14,8),(37,32,0,1),(37,32,8,11),(37,32,17,1),(37,33,18,6),(37,34,6,4),(37,34,7,9),(37,34,8,1),(37,34,16,5),(37,35,0,11),(37,35,1,12),(37,35,2,2),(37,35,6,13),(37,35,15,12),(37,35,19,1),(37,35,22,9);
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
INSERT INTO `fow_ss_entries` VALUES (1,1,1,2,1,0,0,0,NULL,NULL,NULL,NULL,NULL),(2,2,1,1,0,0,0,0,NULL,NULL,NULL,NULL,NULL),(3,4,1,1,0,0,0,0,NULL,NULL,NULL,NULL,NULL),(4,3,1,1,0,0,0,0,NULL,NULL,NULL,NULL,NULL);
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
INSERT INTO `galaxies` VALUES (1,'2010-10-07 11:04:31','dev');
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
INSERT INTO `notifications` VALUES (1,1,'2010-10-07 11:04:35','2010-10-21 11:04:35',3,'--- \n:id: 1\n',0,0),(2,1,'2010-10-07 11:04:35','2010-10-21 11:04:35',3,'--- \n:id: 2\n',0,0);
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
) ENGINE=InnoDB AUTO_INCREMENT=40 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `planets`
--

LOCK TABLES `planets` WRITE;
/*!40000 ALTER TABLE `planets` DISABLE KEYS */;
INSERT INTO `planets` VALUES (1,1,38,23,0,90,7,'Regular',NULL,'G1-S1-P1',48,NULL,NULL,NULL),(2,1,NULL,NULL,1,0,0,'Npc',NULL,'G1-S1-P2',46,NULL,NULL,NULL),(3,1,30,30,2,30,0,'Homeworld',1,'G1-S1-P3',38,NULL,NULL,NULL),(4,1,NULL,NULL,3,156,1,'Jumpgate',NULL,'G1-S1-P4',60,NULL,NULL,NULL),(5,1,43,30,4,252,1,'Regular',NULL,'G1-S1-P5',58,NULL,NULL,NULL),(6,1,NULL,NULL,5,330,0,'Mining',NULL,'G1-S1-P6',46,247,345,273),(7,1,NULL,NULL,6,24,4,'Mining',NULL,'G1-S1-P7',33,329,370,203),(8,2,NULL,NULL,0,270,2,'Jumpgate',NULL,'G1-S2-P8',27,NULL,NULL,NULL),(9,2,NULL,NULL,2,270,1,'Resource',NULL,'G1-S2-P9',51,223,375,273),(10,2,NULL,NULL,3,0,1,'Jumpgate',NULL,'G1-S2-P10',31,NULL,NULL,NULL),(11,2,NULL,NULL,4,198,0,'Npc',NULL,'G1-S2-P11',43,NULL,NULL,NULL),(12,2,NULL,NULL,5,180,0,'Jumpgate',NULL,'G1-S2-P12',32,NULL,NULL,NULL),(13,2,NULL,NULL,6,126,3,'Mining',NULL,'G1-S2-P13',51,166,131,175),(14,2,NULL,NULL,7,314,3,'Mining',NULL,'G1-S2-P14',37,297,345,398),(15,2,NULL,NULL,8,230,3,'Resource',NULL,'G1-S2-P15',27,292,119,128),(16,2,NULL,NULL,9,81,0,'Resource',NULL,'G1-S2-P16',57,199,132,144),(17,2,45,14,10,326,8,'Regular',NULL,'G1-S2-P17',47,NULL,NULL,NULL),(18,2,NULL,NULL,11,104,1,'Mining',NULL,'G1-S2-P18',30,158,296,300),(19,2,43,23,13,342,4,'Regular',NULL,'G1-S2-P19',52,NULL,NULL,NULL),(20,3,NULL,NULL,0,180,6,'Resource',NULL,'G1-S3-P20',59,153,215,387),(21,3,49,19,1,0,6,'Regular',NULL,'G1-S3-P21',54,NULL,NULL,NULL),(22,3,NULL,NULL,2,240,6,'Mining',NULL,'G1-S3-P22',39,291,168,130),(23,3,53,21,3,134,3,'Regular',NULL,'G1-S3-P23',59,NULL,NULL,NULL),(24,3,NULL,NULL,4,36,2,'Mining',NULL,'G1-S3-P24',46,319,182,184),(25,3,NULL,NULL,5,240,1,'Mining',NULL,'G1-S3-P25',29,160,369,120),(26,3,50,16,6,0,2,'Regular',NULL,'G1-S3-P26',52,NULL,NULL,NULL),(27,3,47,17,7,134,5,'Regular',NULL,'G1-S3-P27',51,NULL,NULL,NULL),(28,3,NULL,NULL,8,20,2,'Jumpgate',NULL,'G1-S3-P28',55,NULL,NULL,NULL),(29,3,NULL,NULL,9,27,2,'Jumpgate',NULL,'G1-S3-P29',30,NULL,NULL,NULL),(30,4,NULL,NULL,0,0,1,'Mining',NULL,'G1-S4-P30',56,282,140,271),(31,4,NULL,NULL,1,225,4,'Resource',NULL,'G1-S4-P31',42,146,148,335),(32,4,NULL,NULL,2,300,1,'Jumpgate',NULL,'G1-S4-P32',32,NULL,NULL,NULL),(33,4,NULL,NULL,4,162,1,'Jumpgate',NULL,'G1-S4-P33',58,NULL,NULL,NULL),(34,4,NULL,NULL,5,240,0,'Jumpgate',NULL,'G1-S4-P34',28,NULL,NULL,NULL),(35,4,53,19,6,24,0,'Regular',NULL,'G1-S4-P35',57,NULL,NULL,NULL),(36,4,47,17,7,0,2,'Regular',NULL,'G1-S4-P36',51,NULL,NULL,NULL),(37,4,36,23,8,30,8,'Regular',NULL,'G1-S4-P37',47,NULL,NULL,NULL),(38,4,NULL,NULL,9,324,2,'Mining',NULL,'G1-S4-P38',49,222,255,103),(39,4,NULL,NULL,10,180,3,'Mining',NULL,'G1-S4-P39',36,307,155,287);
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
) ENGINE=InnoDB AUTO_INCREMENT=40 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `resources_entries`
--

LOCK TABLES `resources_entries` WRITE;
/*!40000 ALTER TABLE `resources_entries` DISABLE KEYS */;
INSERT INTO `resources_entries` VALUES (1,0,0,0,0,0,0,0,0,0,NULL,0),(2,0,0,0,0,0,0,0,0,0,NULL,0),(3,864,3024,1728,6048,0,604.8,50,100,0,'2010-10-07 11:04:34',0),(4,0,0,0,0,0,0,0,0,0,NULL,0),(5,0,0,0,0,0,0,0,0,0,NULL,0),(6,0,0,0,0,0,0,0,0,0,NULL,0),(7,0,0,0,0,0,0,0,0,0,NULL,0),(8,0,0,0,0,0,0,0,0,0,NULL,0),(9,0,0,0,0,0,0,0,0,0,NULL,0),(10,0,0,0,0,0,0,0,0,0,NULL,0),(11,0,0,0,0,0,0,0,0,0,NULL,0),(12,0,0,0,0,0,0,0,0,0,NULL,0),(13,0,0,0,0,0,0,0,0,0,NULL,0),(14,0,0,0,0,0,0,0,0,0,NULL,0),(15,0,0,0,0,0,0,0,0,0,NULL,0),(16,0,0,0,0,0,0,0,0,0,NULL,0),(17,0,0,0,0,0,0,0,0,0,NULL,0),(18,0,0,0,0,0,0,0,0,0,NULL,0),(19,0,0,0,0,0,0,0,0,0,NULL,0),(20,0,0,0,0,0,0,0,0,0,NULL,0),(21,0,0,0,0,0,0,0,0,0,NULL,0),(22,0,0,0,0,0,0,0,0,0,NULL,0),(23,0,0,0,0,0,0,0,0,0,NULL,0),(24,0,0,0,0,0,0,0,0,0,NULL,0),(25,0,0,0,0,0,0,0,0,0,NULL,0),(26,0,0,0,0,0,0,0,0,0,NULL,0),(27,0,0,0,0,0,0,0,0,0,NULL,0),(28,0,0,0,0,0,0,0,0,0,NULL,0),(29,0,0,0,0,0,0,0,0,0,NULL,0),(30,0,0,0,0,0,0,0,0,0,NULL,0),(31,0,0,0,0,0,0,0,0,0,NULL,0),(32,0,0,0,0,0,0,0,0,0,NULL,0),(33,0,0,0,0,0,0,0,0,0,NULL,0),(34,0,0,0,0,0,0,0,0,0,NULL,0),(35,0,0,0,0,0,0,0,0,0,NULL,0),(36,0,0,0,0,0,0,0,0,0,NULL,0),(37,0,0,0,0,0,0,0,0,0,NULL,0),(38,0,0,0,0,0,0,0,0,0,NULL,0),(39,0,0,0,0,0,0,0,0,0,NULL,0);
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
INSERT INTO `solar_systems` VALUES (1,'Homeworld',1,0,0),(2,'Resource',1,-3,-2),(3,'Expansion',1,3,0),(4,'Expansion',1,-2,3);
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
) ENGINE=InnoDB AUTO_INCREMENT=3349 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tiles`
--

LOCK TABLES `tiles` WRITE;
/*!40000 ALTER TABLE `tiles` DISABLE KEYS */;
INSERT INTO `tiles` VALUES (1,5,1,20,0),(2,5,1,21,0),(3,5,1,22,0),(4,5,1,23,0),(5,5,1,24,0),(6,5,1,26,0),(7,10,1,6,1),(8,5,1,20,1),(9,5,1,21,1),(10,5,1,22,1),(11,5,1,23,1),(12,5,1,24,1),(13,5,1,26,1),(14,5,1,27,1),(15,5,1,28,1),(16,5,1,30,1),(17,3,1,15,2),(18,5,1,20,2),(19,5,1,21,2),(20,5,1,22,2),(21,5,1,23,2),(22,5,1,24,2),(23,5,1,25,2),(24,5,1,26,2),(25,5,1,27,2),(26,5,1,29,2),(27,5,1,30,2),(28,5,1,31,2),(29,3,1,1,3),(30,8,1,3,3),(31,3,1,14,3),(32,3,1,15,3),(33,3,1,16,3),(34,5,1,19,3),(35,5,1,20,3),(36,5,1,21,3),(37,11,1,22,3),(38,5,1,27,3),(39,5,1,28,3),(40,5,1,29,3),(41,5,1,30,3),(42,3,1,0,4),(43,3,1,1,4),(44,3,1,2,4),(45,3,1,13,4),(46,3,1,14,4),(47,3,1,15,4),(48,3,1,16,4),(49,6,1,17,4),(50,6,1,18,4),(51,5,1,19,4),(52,5,1,20,4),(53,5,1,21,4),(54,5,1,28,4),(55,13,1,29,4),(56,3,1,1,5),(57,3,1,2,5),(58,0,1,10,5),(59,6,1,13,5),(60,3,1,15,5),(61,3,1,16,5),(62,6,1,17,5),(63,6,1,18,5),(64,5,1,19,5),(65,3,1,0,6),(66,3,1,1,6),(67,11,1,2,6),(68,6,1,12,6),(69,6,1,13,6),(70,6,1,14,6),(71,6,1,15,6),(72,6,1,16,6),(73,6,1,17,6),(74,6,1,18,6),(75,6,1,19,6),(76,6,1,20,6),(77,14,1,29,6),(78,3,1,0,7),(79,3,1,1,7),(80,4,1,8,7),(81,10,1,9,7),(82,6,1,14,7),(83,6,1,15,7),(84,6,1,16,7),(85,6,1,17,7),(86,6,1,18,7),(87,6,1,19,7),(88,3,1,36,7),(89,3,1,37,7),(90,2,1,0,8),(91,4,1,8,8),(92,6,1,14,8),(93,12,1,16,8),(94,3,1,35,8),(95,3,1,36,8),(96,4,1,7,9),(97,4,1,8,9),(98,6,1,14,9),(99,3,1,35,9),(100,3,1,36,9),(101,4,1,6,10),(102,4,1,7,10),(103,4,1,8,10),(104,2,1,22,10),(105,3,1,35,10),(106,4,1,6,11),(107,4,1,7,11),(108,4,1,8,11),(109,3,1,35,11),(110,3,1,36,11),(111,7,1,5,12),(112,4,1,7,12),(113,12,1,10,12),(114,7,1,4,13),(115,7,1,5,13),(116,7,1,6,13),(117,7,1,1,14),(118,7,1,2,14),(119,7,1,3,14),(120,7,1,4,14),(121,9,1,6,14),(122,3,1,16,14),(123,3,1,17,14),(124,3,1,18,14),(125,0,1,27,14),(126,7,1,3,15),(127,7,1,4,15),(128,7,1,5,15),(129,3,1,16,15),(130,3,1,17,15),(131,3,1,18,15),(132,5,1,35,15),(133,3,1,1,16),(134,7,1,3,16),(135,7,1,5,16),(136,3,1,16,16),(137,3,1,17,16),(138,0,1,25,16),(139,4,1,27,16),(140,4,1,28,16),(141,4,1,29,16),(142,5,1,34,16),(143,5,1,35,16),(144,3,1,0,17),(145,3,1,1,17),(146,3,1,17,17),(147,3,1,18,17),(148,4,1,27,17),(149,4,1,28,17),(150,4,1,29,17),(151,4,1,30,17),(152,5,1,34,17),(153,5,1,35,17),(154,5,1,36,17),(155,3,1,1,18),(156,4,1,6,18),(157,7,1,9,18),(158,7,1,10,18),(159,7,1,11,18),(160,7,1,12,18),(161,7,1,13,18),(162,7,1,14,18),(163,7,1,15,18),(164,6,1,16,18),(165,1,1,18,18),(166,6,1,20,18),(167,4,1,27,18),(168,4,1,28,18),(169,4,1,29,18),(170,14,1,30,18),(171,5,1,34,18),(172,5,1,35,18),(173,5,1,36,18),(174,5,1,37,18),(175,3,1,0,19),(176,3,1,1,19),(177,4,1,4,19),(178,4,1,5,19),(179,4,1,6,19),(180,7,1,10,19),(181,7,1,11,19),(182,7,1,13,19),(183,4,1,14,19),(184,6,1,16,19),(185,6,1,17,19),(186,6,1,20,19),(187,6,1,21,19),(188,0,1,22,19),(189,8,1,24,19),(190,4,1,27,19),(191,4,1,28,19),(192,0,1,33,19),(193,5,1,36,19),(194,5,1,37,19),(195,3,1,1,20),(196,3,1,2,20),(197,4,1,4,20),(198,4,1,5,20),(199,4,1,6,20),(200,0,1,7,20),(201,7,1,11,20),(202,7,1,12,20),(203,7,1,13,20),(204,4,1,14,20),(205,6,1,15,20),(206,6,1,16,20),(207,6,1,17,20),(208,6,1,18,20),(209,6,1,19,20),(210,6,1,20,20),(211,6,1,21,20),(212,4,1,28,20),(213,5,1,35,20),(214,5,1,36,20),(215,5,1,37,20),(216,3,1,2,21),(217,4,1,5,21),(218,4,1,6,21),(219,4,1,12,21),(220,4,1,13,21),(221,4,1,14,21),(222,6,1,16,21),(223,4,1,17,21),(224,6,1,18,21),(225,6,1,19,21),(226,6,1,20,21),(227,6,1,21,21),(228,6,1,22,21),(229,6,1,23,21),(230,4,1,28,21),(231,5,1,35,21),(232,5,1,37,21),(233,3,1,2,22),(234,4,1,3,22),(235,4,1,4,22),(236,4,1,5,22),(237,4,1,6,22),(238,4,1,7,22),(239,4,1,10,22),(240,4,1,11,22),(241,4,1,12,22),(242,4,1,13,22),(243,4,1,14,22),(244,4,1,15,22),(245,4,1,16,22),(246,4,1,17,22),(247,6,1,20,22),(248,6,1,22,22),(249,5,1,35,22),(250,5,1,37,22),(251,4,5,33,0),(252,4,5,34,0),(253,4,5,35,0),(254,4,5,37,0),(255,4,5,38,0),(256,4,5,39,0),(257,4,5,40,0),(258,4,5,41,0),(259,4,5,35,1),(260,4,5,36,1),(261,4,5,37,1),(262,4,5,38,1),(263,4,5,39,1),(264,4,5,40,1),(265,4,5,41,1),(266,4,5,42,1),(267,4,5,36,2),(268,4,5,37,2),(269,4,5,38,2),(270,4,5,39,2),(271,4,5,40,2),(272,4,5,41,2),(273,4,5,42,2),(274,14,5,12,3),(275,9,5,28,3),(276,4,5,35,3),(277,4,5,36,3),(278,4,5,37,3),(279,4,5,38,3),(280,7,5,39,3),(281,7,5,40,3),(282,4,5,41,3),(283,4,5,42,3),(284,1,5,25,4),(285,4,5,35,4),(286,4,5,37,4),(287,4,5,38,4),(288,7,5,40,4),(289,7,5,41,4),(290,7,5,42,4),(291,4,5,36,5),(292,4,5,37,5),(293,4,5,38,5),(294,7,5,39,5),(295,7,5,40,5),(296,7,5,41,5),(297,7,5,42,5),(298,5,5,16,6),(299,3,5,35,6),(300,3,5,36,6),(301,3,5,37,6),(302,4,5,38,6),(303,7,5,39,6),(304,7,5,40,6),(305,7,5,41,6),(306,7,5,42,6),(307,5,5,16,7),(308,5,5,17,7),(309,5,5,18,7),(310,11,5,27,7),(311,3,5,33,7),(312,3,5,34,7),(313,3,5,35,7),(314,3,5,36,7),(315,3,5,37,7),(316,3,5,38,7),(317,3,5,39,7),(318,7,5,40,7),(319,7,5,41,7),(320,7,5,42,7),(321,5,5,15,8),(322,5,5,16,8),(323,5,5,17,8),(324,5,5,18,8),(325,0,5,32,8),(326,3,5,35,8),(327,3,5,36,8),(328,3,5,37,8),(329,7,5,38,8),(330,7,5,39,8),(331,7,5,40,8),(332,7,5,41,8),(333,7,5,42,8),(334,10,5,5,9),(335,5,5,21,9),(336,5,5,22,9),(337,5,5,23,9),(338,5,5,24,9),(339,3,5,34,9),(340,3,5,35,9),(341,3,5,36,9),(342,7,5,37,9),(343,7,5,38,9),(344,7,5,39,9),(345,7,5,40,9),(346,4,5,41,9),(347,7,5,42,9),(348,0,5,2,10),(349,9,5,15,10),(350,5,5,21,10),(351,5,5,22,10),(352,5,5,23,10),(353,3,5,31,10),(354,3,5,32,10),(355,3,5,33,10),(356,3,5,34,10),(357,3,5,35,10),(358,3,5,36,10),(359,7,5,37,10),(360,7,5,38,10),(361,7,5,39,10),(362,7,5,40,10),(363,4,5,41,10),(364,4,5,42,10),(365,0,5,9,11),(366,5,5,22,11),(367,3,5,31,11),(368,3,5,32,11),(369,3,5,33,11),(370,3,5,34,11),(371,3,5,35,11),(372,3,5,36,11),(373,3,5,37,11),(374,7,5,38,11),(375,7,5,39,11),(376,4,5,40,11),(377,4,5,41,11),(378,4,5,42,11),(379,6,5,11,12),(380,6,5,12,12),(381,3,5,32,12),(382,3,5,33,12),(383,3,5,34,12),(384,3,5,35,12),(385,3,5,36,12),(386,7,5,37,12),(387,7,5,38,12),(388,4,5,39,12),(389,4,5,40,12),(390,4,5,41,12),(391,4,5,42,12),(392,6,5,7,13),(393,6,5,8,13),(394,6,5,9,13),(395,6,5,10,13),(396,6,5,11,13),(397,6,5,12,13),(398,6,5,13,13),(399,6,5,14,13),(400,0,5,27,13),(401,5,5,31,13),(402,5,5,32,13),(403,3,5,33,13),(404,3,5,34,13),(405,3,5,35,13),(406,7,5,36,13),(407,7,5,37,13),(408,7,5,38,13),(409,4,5,39,13),(410,4,5,40,13),(411,4,5,41,13),(412,6,5,7,14),(413,6,5,8,14),(414,6,5,9,14),(415,6,5,10,14),(416,6,5,11,14),(417,6,5,12,14),(418,6,5,13,14),(419,6,5,14,14),(420,0,5,16,14),(421,5,5,32,14),(422,5,5,33,14),(423,3,5,34,14),(424,7,5,35,14),(425,7,5,36,14),(426,7,5,37,14),(427,7,5,38,14),(428,4,5,39,14),(429,4,5,41,14),(430,4,5,42,14),(431,5,5,4,15),(432,5,5,5,15),(433,6,5,6,15),(434,6,5,7,15),(435,6,5,8,15),(436,6,5,9,15),(437,6,5,10,15),(438,6,5,11,15),(439,6,5,12,15),(440,6,5,13,15),(441,6,5,14,15),(442,5,5,31,15),(443,5,5,32,15),(444,7,5,33,15),(445,7,5,34,15),(446,7,5,35,15),(447,7,5,36,15),(448,7,5,37,15),(449,4,5,38,15),(450,4,5,39,15),(451,4,5,40,15),(452,4,5,41,15),(453,4,5,42,15),(454,5,5,3,16),(455,5,5,4,16),(456,5,5,5,16),(457,5,5,6,16),(458,5,5,7,16),(459,6,5,8,16),(460,6,5,9,16),(461,6,5,12,16),(462,6,5,13,16),(463,3,5,16,16),(464,3,5,18,16),(465,3,5,19,16),(466,3,5,20,16),(467,3,5,21,16),(468,5,5,31,16),(469,5,5,32,16),(470,7,5,33,16),(471,7,5,34,16),(472,7,5,35,16),(473,7,5,36,16),(474,7,5,37,16),(475,4,5,38,16),(476,4,5,39,16),(477,4,5,40,16),(478,4,5,41,16),(479,4,5,42,16),(480,5,5,5,17),(481,6,5,8,17),(482,3,5,16,17),(483,3,5,17,17),(484,3,5,18,17),(485,3,5,19,17),(486,3,5,20,17),(487,3,5,21,17),(488,0,5,30,17),(489,7,5,32,17),(490,7,5,33,17),(491,7,5,34,17),(492,7,5,35,17),(493,7,5,36,17),(494,7,5,37,17),(495,4,5,38,17),(496,4,5,39,17),(497,4,5,40,17),(498,4,5,41,17),(499,4,5,42,17),(500,3,5,15,18),(501,3,5,16,18),(502,3,5,17,18),(503,3,5,18,18),(504,3,5,19,18),(505,3,5,21,18),(506,7,5,35,18),(507,4,5,39,18),(508,4,5,40,18),(509,4,5,41,18),(510,6,5,13,19),(511,3,5,15,19),(512,3,5,16,19),(513,3,5,17,19),(514,3,5,18,19),(515,3,5,19,19),(516,3,5,20,19),(517,3,5,21,19),(518,3,5,22,19),(519,13,5,28,19),(520,7,5,35,19),(521,4,5,39,19),(522,4,5,40,19),(523,4,5,41,19),(524,3,5,4,20),(525,3,5,5,20),(526,3,5,6,20),(527,3,5,7,20),(528,3,5,8,20),(529,6,5,13,20),(530,6,5,15,20),(531,3,5,16,20),(532,3,5,17,20),(533,3,5,18,20),(534,3,5,19,20),(535,3,5,20,20),(536,3,5,21,20),(537,3,5,22,20),(538,7,5,35,20),(539,4,5,39,20),(540,4,5,40,20),(541,4,5,41,20),(542,4,5,0,21),(543,3,5,2,21),(544,3,5,4,21),(545,3,5,6,21),(546,3,5,9,21),(547,6,5,11,21),(548,6,5,12,21),(549,6,5,13,21),(550,6,5,14,21),(551,6,5,15,21),(552,6,5,16,21),(553,3,5,17,21),(554,3,5,19,21),(555,3,5,20,21),(556,3,5,21,21),(557,3,5,22,21),(558,12,5,32,21),(559,4,5,38,21),(560,4,5,39,21),(561,4,5,40,21),(562,4,5,41,21),(563,4,5,42,21),(564,4,5,0,22),(565,3,5,2,22),(566,3,5,3,22),(567,3,5,4,22),(568,3,5,5,22),(569,3,5,6,22),(570,3,5,7,22),(571,3,5,8,22),(572,3,5,9,22),(573,3,5,10,22),(574,6,5,13,22),(575,6,5,14,22),(576,6,5,15,22),(577,3,5,19,22),(578,8,5,20,22),(579,4,5,38,22),(580,4,5,39,22),(581,4,5,40,22),(582,4,5,41,22),(583,4,5,42,22),(584,4,5,0,23),(585,4,5,1,23),(586,3,5,3,23),(587,3,5,4,23),(588,3,5,5,23),(589,3,5,6,23),(590,3,5,7,23),(591,3,5,8,23),(592,3,5,9,23),(593,6,5,13,23),(594,6,5,14,23),(595,6,5,15,23),(596,6,5,16,23),(597,4,5,38,23),(598,4,5,39,23),(599,4,5,41,23),(600,4,5,42,23),(601,4,5,0,24),(602,4,5,1,24),(603,3,5,2,24),(604,3,5,3,24),(605,3,5,4,24),(606,3,5,5,24),(607,3,5,6,24),(608,3,5,9,24),(609,1,5,15,24),(610,4,5,38,24),(611,4,5,39,24),(612,4,5,40,24),(613,4,5,41,24),(614,4,5,42,24),(615,4,5,0,25),(616,4,5,1,25),(617,4,5,2,25),(618,4,5,3,25),(619,3,5,4,25),(620,3,5,5,25),(621,4,5,6,25),(622,3,5,8,25),(623,3,5,9,25),(624,4,5,39,25),(625,2,5,40,25),(626,4,5,42,25),(627,4,5,0,26),(628,4,5,1,26),(629,4,5,2,26),(630,4,5,3,26),(631,4,5,4,26),(632,4,5,5,26),(633,4,5,6,26),(634,4,5,7,26),(635,5,5,8,26),(636,3,5,9,26),(637,6,5,23,26),(638,4,5,38,26),(639,4,5,39,26),(640,4,5,42,26),(641,4,5,0,27),(642,4,5,1,27),(643,4,5,2,27),(644,2,5,3,27),(645,4,5,5,27),(646,4,5,6,27),(647,4,5,7,27),(648,5,5,8,27),(649,5,5,9,27),(650,6,5,22,27),(651,6,5,23,27),(652,4,5,36,27),(653,4,5,37,27),(654,4,5,38,27),(655,4,5,39,27),(656,4,5,42,27),(657,4,5,0,28),(658,4,5,1,28),(659,4,5,2,28),(660,4,5,5,28),(661,4,5,6,28),(662,5,5,7,28),(663,5,5,8,28),(664,5,5,9,28),(665,5,5,10,28),(666,5,5,11,28),(667,6,5,21,28),(668,6,5,22,28),(669,6,5,23,28),(670,6,5,24,28),(671,6,5,25,28),(672,4,5,36,28),(673,4,5,38,28),(674,4,5,39,28),(675,4,5,0,29),(676,4,5,1,29),(677,4,5,2,29),(678,4,5,3,29),(679,4,5,4,29),(680,4,5,5,29),(681,6,5,18,29),(682,6,5,19,29),(683,6,5,20,29),(684,6,5,21,29),(685,6,5,22,29),(686,6,5,23,29),(687,6,5,24,29),(688,6,5,25,29),(689,3,17,1,0),(690,3,17,2,0),(691,3,17,3,0),(692,3,17,4,0),(693,3,17,5,0),(694,3,17,6,0),(695,4,17,22,0),(696,4,17,23,0),(697,4,17,24,0),(698,4,17,25,0),(699,4,17,26,0),(700,4,17,27,0),(701,4,17,28,0),(702,4,17,29,0),(703,4,17,30,0),(704,5,17,31,0),(705,5,17,32,0),(706,5,17,33,0),(707,5,17,34,0),(708,5,17,35,0),(709,10,17,38,0),(710,7,17,44,0),(711,3,17,2,1),(712,3,17,4,1),(713,3,17,5,1),(714,3,17,6,1),(715,13,17,20,1),(716,4,17,26,1),(717,4,17,27,1),(718,13,17,28,1),(719,5,17,34,1),(720,7,17,42,1),(721,7,17,43,1),(722,7,17,44,1),(723,3,17,5,2),(724,3,17,6,2),(725,6,17,7,2),(726,6,17,10,2),(727,6,17,11,2),(728,10,17,16,2),(729,1,17,26,2),(730,5,17,34,2),(731,7,17,43,2),(732,7,17,44,2),(733,6,17,10,3),(734,0,17,12,3),(735,7,17,20,3),(736,7,17,21,3),(737,4,17,29,3),(738,9,17,33,3),(739,7,17,42,3),(740,7,17,43,3),(741,7,17,44,3),(742,11,17,2,4),(743,7,17,20,4),(744,7,17,21,4),(745,7,17,22,4),(746,7,17,23,4),(747,4,17,27,4),(748,4,17,29,4),(749,7,17,43,4),(750,7,17,44,4),(751,0,17,0,5),(752,0,17,8,5),(753,3,17,11,5),(754,0,17,14,5),(755,7,17,20,5),(756,7,17,21,5),(757,4,17,25,5),(758,4,17,27,5),(759,4,17,28,5),(760,4,17,29,5),(761,4,17,30,5),(762,4,17,31,5),(763,4,17,32,5),(764,7,17,43,5),(765,3,17,10,6),(766,3,17,11,6),(767,7,17,20,6),(768,7,17,21,6),(769,7,17,22,6),(770,4,17,24,6),(771,4,17,25,6),(772,4,17,26,6),(773,4,17,27,6),(774,4,17,28,6),(775,14,17,32,6),(776,4,17,0,7),(777,4,17,1,7),(778,11,17,6,7),(779,3,17,11,7),(780,12,17,16,7),(781,4,17,24,7),(782,4,17,25,7),(783,4,17,26,7),(784,4,17,27,7),(785,4,17,35,7),(786,4,17,36,7),(787,3,17,38,7),(788,3,17,40,7),(789,3,17,41,7),(790,4,17,0,8),(791,4,17,1,8),(792,3,17,10,8),(793,3,17,11,8),(794,3,17,22,8),(795,3,17,24,8),(796,4,17,25,8),(797,4,17,26,8),(798,4,17,27,8),(799,6,17,36,8),(800,3,17,38,8),(801,3,17,39,8),(802,3,17,40,8),(803,3,17,41,8),(804,3,17,42,8),(805,3,17,43,8),(806,4,17,0,9),(807,4,17,1,9),(808,3,17,10,9),(809,3,17,11,9),(810,3,17,12,9),(811,3,17,13,9),(812,3,17,22,9),(813,3,17,23,9),(814,3,17,24,9),(815,3,17,25,9),(816,3,17,26,9),(817,6,17,36,9),(818,3,17,38,9),(819,3,17,40,9),(820,3,17,41,9),(821,5,17,43,9),(822,0,17,0,10),(823,9,17,2,10),(824,3,17,11,10),(825,8,17,12,10),(826,3,17,23,10),(827,3,17,25,10),(828,3,17,26,10),(829,0,17,28,10),(830,5,17,33,10),(831,6,17,36,10),(832,5,17,41,10),(833,5,17,42,10),(834,5,17,43,10),(835,3,17,11,11),(836,2,17,22,11),(837,3,17,25,11),(838,3,17,26,11),(839,5,17,27,11),(840,5,17,32,11),(841,5,17,33,11),(842,5,17,34,11),(843,0,17,36,11),(844,5,17,43,11),(845,5,17,44,11),(846,5,17,26,12),(847,5,17,27,12),(848,5,17,31,12),(849,5,17,32,12),(850,5,17,33,12),(851,6,17,38,12),(852,6,17,39,12),(853,5,17,44,12),(854,6,17,5,13),(855,6,17,6,13),(856,6,17,7,13),(857,5,17,24,13),(858,5,17,25,13),(859,5,17,26,13),(860,5,17,27,13),(861,6,17,38,13),(862,0,19,18,0),(863,7,19,33,0),(864,7,19,34,0),(865,7,19,35,0),(866,7,19,36,0),(867,7,19,37,0),(868,7,19,38,0),(869,7,19,39,0),(870,8,19,3,1),(871,7,19,13,1),(872,0,19,22,1),(873,0,19,29,1),(874,7,19,33,1),(875,7,19,35,1),(876,7,19,36,1),(877,7,19,37,1),(878,7,19,38,1),(879,7,19,10,2),(880,7,19,13,2),(881,4,19,26,2),(882,0,19,35,2),(883,7,19,37,2),(884,7,19,38,2),(885,7,19,9,3),(886,7,19,10,3),(887,7,19,11,3),(888,7,19,12,3),(889,7,19,13,3),(890,7,19,14,3),(891,0,19,20,3),(892,4,19,25,3),(893,4,19,26,3),(894,4,19,27,3),(895,4,19,28,3),(896,4,19,29,3),(897,7,19,37,3),(898,7,19,38,3),(899,7,19,39,3),(900,7,19,40,3),(901,4,19,42,3),(902,7,19,11,4),(903,7,19,12,4),(904,7,19,13,4),(905,4,19,27,4),(906,9,19,34,4),(907,3,19,38,4),(908,4,19,41,4),(909,4,19,42,4),(910,5,19,4,5),(911,5,19,6,5),(912,5,19,7,5),(913,7,19,11,5),(914,7,19,12,5),(915,7,19,13,5),(916,4,19,27,5),(917,4,19,28,5),(918,4,19,29,5),(919,0,19,32,5),(920,3,19,38,5),(921,3,19,39,5),(922,4,19,40,5),(923,4,19,41,5),(924,4,19,42,5),(925,5,19,3,6),(926,5,19,4,6),(927,5,19,5,6),(928,5,19,6,6),(929,7,19,11,6),(930,7,19,12,6),(931,7,19,13,6),(932,4,19,26,6),(933,4,19,27,6),(934,4,19,29,6),(935,3,19,38,6),(936,3,19,39,6),(937,3,19,40,6),(938,4,19,41,6),(939,4,19,42,6),(940,5,19,3,7),(941,5,19,5,7),(942,11,19,12,7),(943,12,19,16,7),(944,4,19,29,7),(945,3,19,34,7),(946,3,19,35,7),(947,3,19,36,7),(948,3,19,37,7),(949,3,19,38,7),(950,3,19,39,7),(951,3,19,40,7),(952,4,19,42,7),(953,5,19,4,8),(954,5,19,5,8),(955,12,19,28,8),(956,3,19,35,8),(957,10,19,36,8),(958,4,19,42,8),(959,1,19,3,9),(960,5,19,5,9),(961,5,19,6,9),(962,3,19,34,9),(963,3,19,35,9),(964,4,19,41,9),(965,4,19,42,9),(966,4,19,2,10),(967,5,19,5,10),(968,5,19,6,10),(969,3,19,35,10),(970,4,19,41,10),(971,4,19,42,10),(972,4,19,2,11),(973,4,19,3,11),(974,5,19,4,11),(975,5,19,5,11),(976,5,19,6,11),(977,5,19,7,11),(978,9,19,8,11),(979,1,19,24,11),(980,3,19,35,11),(981,4,19,0,12),(982,4,19,1,12),(983,4,19,2,12),(984,4,19,3,12),(985,5,19,4,12),(986,5,19,5,12),(987,5,19,6,12),(988,5,19,7,12),(989,3,19,35,12),(990,4,19,0,13),(991,4,19,1,13),(992,5,19,4,13),(993,5,19,6,13),(994,5,19,7,13),(995,3,19,21,13),(996,3,19,22,13),(997,3,19,23,13),(998,3,19,24,13),(999,3,19,25,13),(1000,3,19,26,13),(1001,5,19,34,13),(1002,5,19,35,13),(1003,5,19,36,13),(1004,5,19,37,13),(1005,4,19,0,14),(1006,4,19,1,14),(1007,4,19,2,14),(1008,14,19,3,14),(1009,5,19,6,14),(1010,11,19,17,14),(1011,3,19,23,14),(1012,3,19,24,14),(1013,3,19,25,14),(1014,3,19,26,14),(1015,3,19,27,14),(1016,3,19,28,14),(1017,5,19,33,14),(1018,5,19,34,14),(1019,5,19,35,14),(1020,4,19,0,15),(1021,5,19,6,15),(1022,5,19,8,15),(1023,3,19,23,15),(1024,3,19,24,15),(1025,3,19,25,15),(1026,3,19,26,15),(1027,2,19,29,15),(1028,2,19,32,15),(1029,5,19,34,15),(1030,5,19,35,15),(1031,5,19,36,15),(1032,5,19,37,15),(1033,4,19,0,16),(1034,5,19,8,16),(1035,5,19,9,16),(1036,4,19,10,16),(1037,4,19,11,16),(1038,4,19,12,16),(1039,4,19,13,16),(1040,4,19,14,16),(1041,3,19,25,16),(1042,5,19,34,16),(1043,5,19,35,16),(1044,5,19,36,16),(1045,5,19,37,16),(1046,5,19,38,16),(1047,3,19,0,17),(1048,3,19,1,17),(1049,3,19,2,17),(1050,5,19,6,17),(1051,5,19,7,17),(1052,5,19,8,17),(1053,4,19,11,17),(1054,4,19,12,17),(1055,4,19,13,17),(1056,4,19,14,17),(1057,4,19,15,17),(1058,4,19,16,17),(1059,3,19,25,17),(1060,5,19,33,17),(1061,5,19,34,17),(1062,5,19,35,17),(1063,5,19,36,17),(1064,5,19,37,17),(1065,0,19,38,17),(1066,3,19,0,18),(1067,3,19,1,18),(1068,5,19,8,18),(1069,5,19,9,18),(1070,5,19,10,18),(1071,4,19,11,18),(1072,4,19,13,18),(1073,4,19,14,18),(1074,6,19,22,18),(1075,4,19,24,18),(1076,3,19,25,18),(1077,4,19,27,18),(1078,6,19,30,18),(1079,6,19,31,18),(1080,5,19,32,18),(1081,5,19,33,18),(1082,5,19,34,18),(1083,6,19,35,18),(1084,5,19,36,18),(1085,5,19,37,18),(1086,3,19,0,19),(1087,3,19,1,19),(1088,3,19,2,19),(1089,3,19,4,19),(1090,5,19,8,19),(1091,5,19,9,19),(1092,5,19,10,19),(1093,5,19,11,19),(1094,6,19,21,19),(1095,6,19,22,19),(1096,4,19,24,19),(1097,3,19,25,19),(1098,4,19,27,19),(1099,4,19,28,19),(1100,6,19,30,19),(1101,6,19,33,19),(1102,6,19,34,19),(1103,6,19,35,19),(1104,5,19,37,19),(1105,8,19,38,19),(1106,3,19,1,20),(1107,3,19,2,20),(1108,3,19,3,20),(1109,3,19,4,20),(1110,3,19,5,20),(1111,3,19,6,20),(1112,5,19,7,20),(1113,5,19,8,20),(1114,5,19,9,20),(1115,5,19,10,20),(1116,5,19,11,20),(1117,0,19,13,20),(1118,13,19,15,20),(1119,6,19,22,20),(1120,6,19,23,20),(1121,4,19,24,20),(1122,4,19,25,20),(1123,4,19,26,20),(1124,4,19,27,20),(1125,4,19,28,20),(1126,6,19,30,20),(1127,6,19,32,20),(1128,6,19,33,20),(1129,6,19,34,20),(1130,6,19,35,20),(1131,5,19,37,20),(1132,3,19,2,21),(1133,3,19,3,21),(1134,3,19,4,21),(1135,5,19,5,21),(1136,5,19,6,21),(1137,5,19,7,21),(1138,5,19,9,21),(1139,6,19,22,21),(1140,6,19,23,21),(1141,6,19,24,21),(1142,6,19,25,21),(1143,4,19,27,21),(1144,4,19,28,21),(1145,4,19,29,21),(1146,6,19,30,21),(1147,6,19,31,21),(1148,6,19,32,21),(1149,6,19,33,21),(1150,6,19,34,21),(1151,6,19,35,21),(1152,3,19,3,22),(1153,3,19,4,22),(1154,5,19,5,22),(1155,5,19,6,22),(1156,5,19,7,22),(1157,5,19,8,22),(1158,6,19,22,22),(1159,6,19,23,22),(1160,6,19,25,22),(1161,4,19,27,22),(1162,6,19,28,22),(1163,6,19,29,22),(1164,6,19,30,22),(1165,6,19,31,22),(1166,6,19,33,22),(1167,6,19,34,22),(1168,4,21,19,0),(1169,4,21,20,0),(1170,4,21,21,0),(1171,7,21,27,0),(1172,7,21,28,0),(1173,7,21,29,0),(1174,7,21,30,0),(1175,7,21,31,0),(1176,7,21,32,0),(1177,7,21,33,0),(1178,7,21,34,0),(1179,7,21,35,0),(1180,7,21,36,0),(1181,7,21,37,0),(1182,7,21,38,0),(1183,7,21,39,0),(1184,7,21,40,0),(1185,7,21,41,0),(1186,7,21,42,0),(1187,7,21,43,0),(1188,4,21,44,0),(1189,4,21,45,0),(1190,4,21,46,0),(1191,4,21,47,0),(1192,4,21,0,1),(1193,4,21,16,1),(1194,4,21,18,1),(1195,4,21,19,1),(1196,4,21,20,1),(1197,4,21,21,1),(1198,4,21,22,1),(1199,4,21,23,1),(1200,5,21,27,1),(1201,5,21,28,1),(1202,5,21,29,1),(1203,5,21,30,1),(1204,7,21,31,1),(1205,7,21,32,1),(1206,7,21,33,1),(1207,7,21,34,1),(1208,7,21,35,1),(1209,3,21,36,1),(1210,3,21,37,1),(1211,3,21,38,1),(1212,12,21,39,1),(1213,4,21,45,1),(1214,4,21,46,1),(1215,4,21,47,1),(1216,4,21,48,1),(1217,4,21,0,2),(1218,4,21,1,2),(1219,4,21,2,2),(1220,3,21,8,2),(1221,3,21,9,2),(1222,4,21,14,2),(1223,4,21,15,2),(1224,4,21,16,2),(1225,0,21,17,2),(1226,4,21,20,2),(1227,4,21,21,2),(1228,4,21,22,2),(1229,2,21,23,2),(1230,5,21,25,2),(1231,5,21,26,2),(1232,5,21,27,2),(1233,5,21,28,2),(1234,7,21,30,2),(1235,7,21,31,2),(1236,7,21,32,2),(1237,7,21,33,2),(1238,3,21,34,2),(1239,3,21,35,2),(1240,3,21,36,2),(1241,3,21,38,2),(1242,4,21,45,2),(1243,4,21,48,2),(1244,4,21,0,3),(1245,4,21,2,3),(1246,3,21,7,3),(1247,3,21,8,3),(1248,3,21,9,3),(1249,3,21,10,3),(1250,3,21,11,3),(1251,4,21,15,3),(1252,4,21,16,3),(1253,6,21,19,3),(1254,6,21,20,3),(1255,4,21,21,3),(1256,5,21,25,3),(1257,5,21,26,3),(1258,5,21,27,3),(1259,5,21,28,3),(1260,7,21,30,3),(1261,7,21,32,3),(1262,7,21,33,3),(1263,3,21,35,3),(1264,3,21,36,3),(1265,3,21,37,3),(1266,3,21,38,3),(1267,4,21,45,3),(1268,4,21,46,3),(1269,4,21,47,3),(1270,4,21,0,4),(1271,4,21,1,4),(1272,4,21,2,4),(1273,1,21,3,4),(1274,3,21,7,4),(1275,3,21,8,4),(1276,3,21,9,4),(1277,3,21,10,4),(1278,9,21,11,4),(1279,4,21,15,4),(1280,4,21,16,4),(1281,4,21,17,4),(1282,6,21,18,4),(1283,6,21,19,4),(1284,6,21,20,4),(1285,4,21,21,4),(1286,4,21,22,4),(1287,4,21,23,4),(1288,5,21,24,4),(1289,5,21,25,4),(1290,5,21,26,4),(1291,5,21,27,4),(1292,5,21,28,4),(1293,7,21,33,4),(1294,3,21,34,4),(1295,3,21,35,4),(1296,3,21,37,4),(1297,3,21,38,4),(1298,4,21,45,4),(1299,4,21,1,5),(1300,3,21,8,5),(1301,3,21,9,5),(1302,3,21,10,5),(1303,4,21,15,5),(1304,4,21,16,5),(1305,4,21,17,5),(1306,4,21,18,5),(1307,6,21,19,5),(1308,6,21,20,5),(1309,6,21,21,5),(1310,6,21,22,5),(1311,5,21,23,5),(1312,5,21,24,5),(1313,5,21,25,5),(1314,5,21,26,5),(1315,5,21,27,5),(1316,5,21,28,5),(1317,5,21,29,5),(1318,0,21,31,5),(1319,0,21,33,5),(1320,3,21,35,5),(1321,3,21,36,5),(1322,3,21,37,5),(1323,3,21,38,5),(1324,4,21,45,5),(1325,4,21,0,6),(1326,4,21,1,6),(1327,0,21,2,6),(1328,3,21,6,6),(1329,3,21,7,6),(1330,3,21,8,6),(1331,3,21,9,6),(1332,4,21,15,6),(1333,4,21,16,6),(1334,4,21,17,6),(1335,0,21,18,6),(1336,6,21,20,6),(1337,6,21,22,6),(1338,5,21,23,6),(1339,5,21,25,6),(1340,5,21,26,6),(1341,5,21,27,6),(1342,5,21,29,6),(1343,5,21,30,6),(1344,3,21,36,6),(1345,3,21,37,6),(1346,3,21,38,6),(1347,4,21,45,6),(1348,4,21,0,7),(1349,4,21,1,7),(1350,3,21,8,7),(1351,3,21,9,7),(1352,3,21,10,7),(1353,3,21,11,7),(1354,3,21,12,7),(1355,4,21,15,7),(1356,4,21,16,7),(1357,6,21,20,7),(1358,8,21,21,7),(1359,5,21,26,7),(1360,5,21,27,7),(1361,5,21,28,7),(1362,5,21,29,7),(1363,5,21,30,7),(1364,13,21,31,7),(1365,3,21,37,7),(1366,4,21,0,8),(1367,10,21,2,8),(1368,13,21,8,8),(1369,4,21,15,8),(1370,4,21,16,8),(1371,4,21,17,8),(1372,4,21,18,8),(1373,5,21,24,8),(1374,5,21,25,8),(1375,5,21,26,8),(1376,5,21,27,8),(1377,5,21,28,8),(1378,5,21,29,8),(1379,3,21,30,8),(1380,3,21,37,8),(1381,4,21,0,9),(1382,4,21,14,9),(1383,4,21,15,9),(1384,4,21,16,9),(1385,4,21,17,9),(1386,5,21,25,9),(1387,5,21,26,9),(1388,5,21,27,9),(1389,5,21,29,9),(1390,3,21,30,9),(1391,3,21,31,9),(1392,3,21,32,9),(1393,3,21,33,9),(1394,3,21,34,9),(1395,4,21,16,10),(1396,4,21,17,10),(1397,4,21,18,10),(1398,4,21,19,10),(1399,5,21,21,10),(1400,14,21,24,10),(1401,5,21,27,10),(1402,3,21,28,10),(1403,3,21,29,10),(1404,3,21,31,10),(1405,3,21,32,10),(1406,3,21,33,10),(1407,3,21,34,10),(1408,3,21,35,10),(1409,8,21,11,11),(1410,4,21,16,11),(1411,5,21,18,11),(1412,5,21,19,11),(1413,5,21,20,11),(1414,5,21,21,11),(1415,5,21,22,11),(1416,5,21,23,11),(1417,3,21,27,11),(1418,3,21,28,11),(1419,3,21,29,11),(1420,3,21,30,11),(1421,3,21,31,11),(1422,3,21,32,11),(1423,3,21,33,11),(1424,3,21,34,11),(1425,12,21,3,12),(1426,5,21,18,12),(1427,5,21,19,12),(1428,11,21,20,12),(1429,3,21,29,12),(1430,3,21,30,12),(1431,3,21,32,12),(1432,11,21,39,12),(1433,5,21,17,13),(1434,5,21,18,13),(1435,5,21,19,13),(1436,9,21,44,13),(1437,7,21,0,14),(1438,7,21,1,14),(1439,1,21,9,14),(1440,5,21,16,14),(1441,5,21,17,14),(1442,5,21,18,14),(1443,5,21,19,14),(1444,7,21,0,15),(1445,7,21,1,15),(1446,6,21,2,15),(1447,6,21,15,15),(1448,6,21,16,15),(1449,5,21,17,15),(1450,5,21,18,15),(1451,5,21,19,15),(1452,7,21,0,16),(1453,6,21,1,16),(1454,6,21,2,16),(1455,6,21,15,16),(1456,6,21,16,16),(1457,5,21,17,16),(1458,6,21,18,16),(1459,5,21,19,16),(1460,0,21,37,16),(1461,7,21,0,17),(1462,6,21,1,17),(1463,6,21,2,17),(1464,6,21,16,17),(1465,6,21,17,17),(1466,6,21,18,17),(1467,6,21,19,17),(1468,6,21,0,18),(1469,6,21,1,18),(1470,6,21,2,18),(1471,6,21,3,18),(1472,6,21,4,18),(1473,6,21,5,18),(1474,6,21,6,18),(1475,6,21,7,18),(1476,6,21,19,18),(1477,6,21,20,18),(1478,6,21,21,18),(1479,6,21,22,18),(1480,4,23,6,0),(1481,4,23,7,0),(1482,4,23,8,0),(1483,4,23,9,0),(1484,4,23,10,0),(1485,4,23,11,0),(1486,4,23,12,0),(1487,4,23,13,0),(1488,3,23,30,0),(1489,3,23,31,0),(1490,3,23,32,0),(1491,3,23,35,0),(1492,3,23,36,0),(1493,3,23,37,0),(1494,6,23,38,0),(1495,4,23,40,0),(1496,4,23,44,0),(1497,6,23,48,0),(1498,6,23,49,0),(1499,4,23,6,1),(1500,4,23,8,1),(1501,4,23,9,1),(1502,4,23,10,1),(1503,4,23,11,1),(1504,4,23,12,1),(1505,4,23,13,1),(1506,3,23,30,1),(1507,3,23,31,1),(1508,3,23,32,1),(1509,3,23,34,1),(1510,3,23,35,1),(1511,6,23,36,1),(1512,6,23,37,1),(1513,6,23,38,1),(1514,6,23,39,1),(1515,4,23,40,1),(1516,4,23,41,1),(1517,4,23,42,1),(1518,4,23,43,1),(1519,4,23,44,1),(1520,4,23,45,1),(1521,6,23,47,1),(1522,6,23,48,1),(1523,6,23,49,1),(1524,4,23,5,2),(1525,4,23,6,2),(1526,4,23,8,2),(1527,4,23,9,2),(1528,4,23,10,2),(1529,4,23,11,2),(1530,4,23,12,2),(1531,4,23,13,2),(1532,4,23,14,2),(1533,12,23,25,2),(1534,3,23,31,2),(1535,3,23,32,2),(1536,3,23,33,2),(1537,3,23,34,2),(1538,3,23,35,2),(1539,3,23,36,2),(1540,6,23,37,2),(1541,6,23,38,2),(1542,6,23,39,2),(1543,4,23,40,2),(1544,4,23,41,2),(1545,4,23,42,2),(1546,4,23,43,2),(1547,4,23,44,2),(1548,4,23,45,2),(1549,4,23,46,2),(1550,6,23,47,2),(1551,6,23,49,2),(1552,0,23,50,2),(1553,14,23,3,3),(1554,4,23,9,3),(1555,4,23,10,3),(1556,4,23,12,3),(1557,4,23,13,3),(1558,4,23,14,3),(1559,4,23,15,3),(1560,7,23,21,3),(1561,7,23,22,3),(1562,3,23,31,3),(1563,3,23,32,3),(1564,3,23,33,3),(1565,3,23,34,3),(1566,6,23,37,3),(1567,4,23,39,3),(1568,4,23,40,3),(1569,4,23,41,3),(1570,4,23,42,3),(1571,4,23,43,3),(1572,4,23,44,3),(1573,4,23,45,3),(1574,4,23,13,4),(1575,7,23,20,4),(1576,7,23,21,4),(1577,7,23,22,4),(1578,7,23,23,4),(1579,7,23,24,4),(1580,3,23,32,4),(1581,3,23,33,4),(1582,3,23,34,4),(1583,6,23,37,4),(1584,4,23,40,4),(1585,3,23,41,4),(1586,4,23,43,4),(1587,4,23,44,4),(1588,4,23,45,4),(1589,7,23,23,5),(1590,7,23,24,5),(1591,3,23,32,5),(1592,3,23,33,5),(1593,3,23,34,5),(1594,0,23,38,5),(1595,3,23,41,5),(1596,4,23,42,5),(1597,4,23,43,5),(1598,4,23,44,5),(1599,4,23,45,5),(1600,5,23,48,5),(1601,0,23,8,6),(1602,7,23,21,6),(1603,7,23,22,6),(1604,7,23,23,6),(1605,3,23,33,6),(1606,3,23,37,6),(1607,3,23,40,6),(1608,3,23,41,6),(1609,4,23,43,6),(1610,5,23,48,6),(1611,5,23,49,6),(1612,5,23,50,6),(1613,5,23,52,6),(1614,14,23,3,7),(1615,9,23,12,7),(1616,7,23,22,7),(1617,7,23,23,7),(1618,7,23,24,7),(1619,3,23,33,7),(1620,3,23,36,7),(1621,3,23,37,7),(1622,3,23,38,7),(1623,3,23,39,7),(1624,3,23,40,7),(1625,3,23,41,7),(1626,3,23,42,7),(1627,5,23,44,7),(1628,5,23,48,7),(1629,5,23,49,7),(1630,5,23,52,7),(1631,0,23,1,8),(1632,9,23,6,8),(1633,7,23,23,8),(1634,5,23,25,8),(1635,3,23,37,8),(1636,3,23,38,8),(1637,3,23,39,8),(1638,3,23,40,8),(1639,3,23,41,8),(1640,3,23,42,8),(1641,3,23,43,8),(1642,5,23,44,8),(1643,5,23,45,8),(1644,5,23,46,8),(1645,5,23,47,8),(1646,5,23,48,8),(1647,5,23,49,8),(1648,5,23,50,8),(1649,5,23,51,8),(1650,5,23,52,8),(1651,1,23,10,9),(1652,5,23,22,9),(1653,5,23,23,9),(1654,5,23,24,9),(1655,5,23,25,9),(1656,3,23,37,9),(1657,3,23,39,9),(1658,3,23,41,9),(1659,3,23,42,9),(1660,3,23,43,9),(1661,3,23,44,9),(1662,3,23,45,9),(1663,5,23,46,9),(1664,5,23,47,9),(1665,5,23,48,9),(1666,5,23,49,9),(1667,5,23,51,9),(1668,5,23,52,9),(1669,5,23,13,10),(1670,5,23,14,10),(1671,5,23,15,10),(1672,5,23,22,10),(1673,5,23,23,10),(1674,5,23,25,10),(1675,3,23,41,10),(1676,3,23,42,10),(1677,5,23,46,10),(1678,5,23,47,10),(1679,5,23,48,10),(1680,5,23,49,10),(1681,5,23,50,10),(1682,5,23,51,10),(1683,5,23,52,10),(1684,10,23,3,11),(1685,2,23,10,11),(1686,5,23,13,11),(1687,5,23,14,11),(1688,5,23,21,11),(1689,5,23,22,11),(1690,5,23,23,11),(1691,5,23,24,11),(1692,5,23,25,11),(1693,3,23,42,11),(1694,5,23,47,11),(1695,5,23,48,11),(1696,5,23,49,11),(1697,5,23,50,11),(1698,5,23,51,11),(1699,5,23,52,11),(1700,5,23,12,12),(1701,5,23,13,12),(1702,5,23,14,12),(1703,5,23,21,12),(1704,5,23,22,12),(1705,5,23,23,12),(1706,5,23,24,12),(1707,5,23,41,12),(1708,5,23,42,12),(1709,5,23,43,12),(1710,5,23,44,12),(1711,0,23,46,12),(1712,5,23,48,12),(1713,5,23,11,13),(1714,5,23,12,13),(1715,5,23,13,13),(1716,12,23,14,13),(1717,5,23,22,13),(1718,5,23,23,13),(1719,5,23,24,13),(1720,13,23,25,13),(1721,5,23,43,13),(1722,5,23,44,13),(1723,5,23,45,13),(1724,5,23,48,13),(1725,2,23,1,14),(1726,8,23,8,14),(1727,5,23,11,14),(1728,5,23,12,14),(1729,5,23,13,14),(1730,11,23,21,14),(1731,13,23,31,14),(1732,4,23,38,14),(1733,5,23,41,14),(1734,5,23,42,14),(1735,5,23,43,14),(1736,5,23,44,14),(1737,5,23,45,14),(1738,5,23,48,14),(1739,6,23,11,15),(1740,5,23,12,15),(1741,5,23,13,15),(1742,3,23,25,15),(1743,3,23,26,15),(1744,3,23,27,15),(1745,3,23,28,15),(1746,3,23,29,15),(1747,4,23,38,15),(1748,4,23,39,15),(1749,5,23,42,15),(1750,5,23,45,15),(1751,6,23,11,16),(1752,5,23,12,16),(1753,5,23,13,16),(1754,3,23,25,16),(1755,3,23,26,16),(1756,3,23,28,16),(1757,3,23,29,16),(1758,4,23,30,16),(1759,4,23,31,16),(1760,4,23,32,16),(1761,4,23,33,16),(1762,4,23,34,16),(1763,4,23,35,16),(1764,4,23,36,16),(1765,4,23,37,16),(1766,4,23,38,16),(1767,1,23,41,16),(1768,5,23,44,16),(1769,5,23,45,16),(1770,10,23,48,16),(1771,8,23,6,17),(1772,6,23,9,17),(1773,6,23,10,17),(1774,6,23,11,17),(1775,5,23,12,17),(1776,5,23,13,17),(1777,3,23,25,17),(1778,3,23,26,17),(1779,3,23,27,17),(1780,3,23,28,17),(1781,3,23,29,17),(1782,4,23,30,17),(1783,4,23,31,17),(1784,4,23,32,17),(1785,4,23,33,17),(1786,4,23,34,17),(1787,4,23,35,17),(1788,4,23,37,17),(1789,4,23,38,17),(1790,4,23,39,17),(1791,7,23,45,17),(1792,7,23,46,17),(1793,7,23,47,17),(1794,6,23,9,18),(1795,6,23,10,18),(1796,6,23,12,18),(1797,3,23,25,18),(1798,3,23,26,18),(1799,3,23,28,18),(1800,4,23,30,18),(1801,4,23,31,18),(1802,4,23,34,18),(1803,4,23,38,18),(1804,4,23,39,18),(1805,7,23,45,18),(1806,7,23,46,18),(1807,7,23,47,18),(1808,6,23,9,19),(1809,6,23,10,19),(1810,6,23,11,19),(1811,6,23,12,19),(1812,6,23,13,19),(1813,3,23,25,19),(1814,3,23,26,19),(1815,3,23,27,19),(1816,3,23,28,19),(1817,4,23,30,19),(1818,4,23,34,19),(1819,7,23,45,19),(1820,7,23,46,19),(1821,7,23,47,19),(1822,6,23,6,20),(1823,6,23,7,20),(1824,6,23,8,20),(1825,6,23,9,20),(1826,6,23,10,20),(1827,6,23,11,20),(1828,6,23,12,20),(1829,3,23,22,20),(1830,3,23,23,20),(1831,3,23,24,20),(1832,3,23,25,20),(1833,3,23,26,20),(1834,3,23,27,20),(1835,4,23,33,20),(1836,4,23,34,20),(1837,4,23,35,20),(1838,7,23,43,20),(1839,7,23,44,20),(1840,7,23,45,20),(1841,7,23,46,20),(1842,7,23,47,20),(1843,7,23,48,20),(1844,7,23,49,20),(1845,5,26,0,0),(1846,5,26,1,0),(1847,5,26,2,0),(1848,5,26,3,0),(1849,5,26,4,0),(1850,5,26,5,0),(1851,5,26,6,0),(1852,5,26,7,0),(1853,7,26,12,0),(1854,7,26,13,0),(1855,7,26,14,0),(1856,4,26,19,0),(1857,4,26,20,0),(1858,0,26,25,0),(1859,5,26,27,0),(1860,5,26,28,0),(1861,5,26,29,0),(1862,5,26,30,0),(1863,5,26,31,0),(1864,4,26,32,0),(1865,6,26,38,0),(1866,5,26,40,0),(1867,5,26,41,0),(1868,5,26,42,0),(1869,5,26,43,0),(1870,4,26,44,0),(1871,5,26,0,1),(1872,5,26,1,1),(1873,9,26,2,1),(1874,5,26,6,1),(1875,5,26,7,1),(1876,7,26,11,1),(1877,7,26,12,1),(1878,7,26,13,1),(1879,7,26,14,1),(1880,4,26,16,1),(1881,4,26,17,1),(1882,4,26,18,1),(1883,4,26,19,1),(1884,4,26,24,1),(1885,5,26,27,1),(1886,5,26,28,1),(1887,5,26,29,1),(1888,5,26,30,1),(1889,5,26,31,1),(1890,4,26,32,1),(1891,6,26,37,1),(1892,6,26,38,1),(1893,5,26,42,1),(1894,4,26,43,1),(1895,4,26,44,1),(1896,7,26,11,2),(1897,7,26,13,2),(1898,7,26,14,2),(1899,4,26,17,2),(1900,4,26,18,2),(1901,4,26,21,2),(1902,4,26,24,2),(1903,5,26,26,2),(1904,5,26,27,2),(1905,4,26,28,2),(1906,4,26,29,2),(1907,4,26,30,2),(1908,4,26,31,2),(1909,4,26,32,2),(1910,6,26,37,2),(1911,6,26,38,2),(1912,5,26,39,2),(1913,5,26,40,2),(1914,5,26,41,2),(1915,5,26,42,2),(1916,4,26,43,2),(1917,4,26,44,2),(1918,14,26,46,2),(1919,7,26,49,2),(1920,13,26,6,3),(1921,7,26,12,3),(1922,7,26,13,3),(1923,4,26,17,3),(1924,4,26,21,3),(1925,4,26,22,3),(1926,4,26,23,3),(1927,4,26,24,3),(1928,4,26,25,3),(1929,4,26,28,3),(1930,4,26,32,3),(1931,6,26,37,3),(1932,6,26,38,3),(1933,6,26,39,3),(1934,5,26,40,3),(1935,4,26,41,3),(1936,4,26,42,3),(1937,4,26,43,3),(1938,3,26,44,3),(1939,3,26,45,3),(1940,7,26,49,3),(1941,8,26,19,4),(1942,4,26,22,4),(1943,11,26,29,4),(1944,5,26,39,4),(1945,5,26,40,4),(1946,4,26,43,4),(1947,3,26,45,4),(1948,7,26,49,4),(1949,14,26,10,5),(1950,0,26,22,5),(1951,0,26,43,5),(1952,3,26,45,5),(1953,7,26,49,5),(1954,9,26,3,6),(1955,3,26,42,6),(1956,3,26,45,6),(1957,3,26,46,6),(1958,7,26,47,6),(1959,7,26,48,6),(1960,7,26,49,6),(1961,6,26,19,7),(1962,6,26,20,7),(1963,6,26,21,7),(1964,6,26,22,7),(1965,6,26,23,7),(1966,2,26,24,7),(1967,5,26,35,7),(1968,3,26,42,7),(1969,3,26,43,7),(1970,3,26,44,7),(1971,3,26,45,7),(1972,3,26,46,7),(1973,3,26,47,7),(1974,7,26,48,7),(1975,7,26,49,7),(1976,6,26,21,8),(1977,5,26,22,8),(1978,6,26,23,8),(1979,5,26,33,8),(1980,5,26,34,8),(1981,5,26,35,8),(1982,5,26,36,8),(1983,3,26,40,8),(1984,3,26,41,8),(1985,3,26,42,8),(1986,3,26,43,8),(1987,3,26,44,8),(1988,3,26,45,8),(1989,3,26,46,8),(1990,7,26,47,8),(1991,7,26,48,8),(1992,7,26,49,8),(1993,11,26,0,9),(1994,10,26,8,9),(1995,10,26,12,9),(1996,5,26,21,9),(1997,5,26,22,9),(1998,6,26,23,9),(1999,5,26,33,9),(2000,5,26,34,9),(2001,5,26,35,9),(2002,5,26,36,9),(2003,12,26,43,9),(2004,3,26,7,10),(2005,5,26,22,10),(2006,5,26,23,10),(2007,5,26,24,10),(2008,5,26,25,10),(2009,3,26,26,10),(2010,3,26,27,10),(2011,3,26,28,10),(2012,3,26,29,10),(2013,3,26,30,10),(2014,3,26,31,10),(2015,3,26,32,10),(2016,5,26,34,10),(2017,5,26,35,10),(2018,3,26,4,11),(2019,3,26,5,11),(2020,3,26,7,11),(2021,6,26,19,11),(2022,6,26,20,11),(2023,5,26,21,11),(2024,5,26,22,11),(2025,3,26,27,11),(2026,3,26,28,11),(2027,3,26,29,11),(2028,3,26,30,11),(2029,3,26,31,11),(2030,0,26,32,11),(2031,5,26,35,11),(2032,4,26,41,11),(2033,3,26,5,12),(2034,3,26,7,12),(2035,6,26,20,12),(2036,6,26,21,12),(2037,5,26,22,12),(2038,0,26,26,12),(2039,3,26,28,12),(2040,3,26,29,12),(2041,3,26,30,12),(2042,3,26,31,12),(2043,4,26,41,12),(2044,3,26,5,13),(2045,3,26,6,13),(2046,3,26,7,13),(2047,3,26,8,13),(2048,3,26,9,13),(2049,3,26,12,13),(2050,6,26,20,13),(2051,6,26,21,13),(2052,1,26,23,13),(2053,3,26,28,13),(2054,3,26,29,13),(2055,3,26,30,13),(2056,0,26,33,13),(2057,4,26,41,13),(2058,3,26,8,14),(2059,3,26,9,14),(2060,3,26,10,14),(2061,3,26,11,14),(2062,3,26,12,14),(2063,3,26,29,14),(2064,4,26,41,14),(2065,3,26,10,15),(2066,4,26,40,15),(2067,4,26,41,15),(2068,4,26,42,15),(2069,4,26,43,15),(2070,4,26,44,15),(2071,3,27,0,0),(2072,3,27,1,0),(2073,3,27,2,0),(2074,3,27,3,0),(2075,3,27,4,0),(2076,3,27,5,0),(2077,3,27,6,0),(2078,3,27,7,0),(2079,3,27,10,0),(2080,3,27,11,0),(2081,3,27,12,0),(2082,4,27,33,0),(2083,4,27,34,0),(2084,4,27,35,0),(2085,4,27,36,0),(2086,4,27,37,0),(2087,4,27,39,0),(2088,4,27,40,0),(2089,4,27,41,0),(2090,5,27,42,0),(2091,5,27,43,0),(2092,6,27,44,0),(2093,6,27,45,0),(2094,6,27,46,0),(2095,3,27,1,1),(2096,3,27,2,1),(2097,3,27,3,1),(2098,3,27,4,1),(2099,11,27,5,1),(2100,3,27,9,1),(2101,3,27,10,1),(2102,3,27,11,1),(2103,3,27,12,1),(2104,0,27,18,1),(2105,6,27,31,1),(2106,6,27,32,1),(2107,4,27,34,1),(2108,4,27,35,1),(2109,4,27,36,1),(2110,4,27,37,1),(2111,4,27,38,1),(2112,4,27,39,1),(2113,4,27,40,1),(2114,5,27,41,1),(2115,5,27,42,1),(2116,5,27,43,1),(2117,5,27,44,1),(2118,5,27,45,1),(2119,6,27,46,1),(2120,3,27,2,2),(2121,3,27,3,2),(2122,3,27,4,2),(2123,3,27,9,2),(2124,3,27,10,2),(2125,3,27,11,2),(2126,3,27,12,2),(2127,3,27,13,2),(2128,3,27,14,2),(2129,3,27,15,2),(2130,3,27,16,2),(2131,6,27,32,2),(2132,6,27,33,2),(2133,0,27,36,2),(2134,4,27,38,2),(2135,4,27,39,2),(2136,4,27,40,2),(2137,4,27,41,2),(2138,4,27,42,2),(2139,6,27,45,2),(2140,6,27,46,2),(2141,3,27,0,3),(2142,3,27,1,3),(2143,3,27,2,3),(2144,3,27,4,3),(2145,3,27,9,3),(2146,3,27,12,3),(2147,3,27,13,3),(2148,3,27,16,3),(2149,3,27,17,3),(2150,12,27,22,3),(2151,6,27,30,3),(2152,6,27,31,3),(2153,6,27,32,3),(2154,4,27,39,3),(2155,4,27,40,3),(2156,4,27,41,3),(2157,6,27,46,3),(2158,3,27,3,4),(2159,3,27,4,4),(2160,3,27,13,4),(2161,4,27,15,4),(2162,5,27,16,4),(2163,5,27,17,4),(2164,5,27,18,4),(2165,13,27,29,4),(2166,0,27,44,4),(2167,10,27,10,5),(2168,4,27,15,5),(2169,5,27,16,5),(2170,5,27,17,5),(2171,5,27,18,5),(2172,5,27,19,5),(2173,2,27,37,5),(2174,4,27,14,6),(2175,4,27,15,6),(2176,4,27,16,6),(2177,4,27,17,6),(2178,4,27,18,6),(2179,8,27,19,6),(2180,9,27,42,6),(2181,4,27,14,7),(2182,4,27,15,7),(2183,4,27,16,7),(2184,4,27,17,7),(2185,4,27,18,7),(2186,1,27,28,7),(2187,12,27,30,7),(2188,4,27,14,8),(2189,4,27,15,8),(2190,4,27,16,8),(2191,4,27,17,8),(2192,4,27,18,8),(2193,6,27,0,9),(2194,6,27,1,9),(2195,6,27,2,9),(2196,2,27,3,9),(2197,5,27,10,9),(2198,4,27,14,9),(2199,4,27,15,9),(2200,10,27,16,9),(2201,6,27,0,10),(2202,6,27,1,10),(2203,6,27,2,10),(2204,5,27,10,10),(2205,5,27,11,10),(2206,5,27,12,10),(2207,4,27,13,10),(2208,4,27,14,10),(2209,4,27,15,10),(2210,0,27,20,10),(2211,6,27,0,11),(2212,6,27,4,11),(2213,5,27,10,11),(2214,5,27,12,11),(2215,5,27,13,11),(2216,4,27,14,11),(2217,5,27,15,11),(2218,6,27,46,11),(2219,6,27,3,12),(2220,6,27,4,12),(2221,6,27,6,12),(2222,7,27,12,12),(2223,5,27,13,12),(2224,5,27,14,12),(2225,5,27,15,12),(2226,13,27,24,12),(2227,14,27,41,12),(2228,6,27,44,12),(2229,6,27,45,12),(2230,6,27,46,12),(2231,6,27,4,13),(2232,6,27,5,13),(2233,6,27,6,13),(2234,7,27,11,13),(2235,7,27,12,13),(2236,7,27,13,13),(2237,7,27,14,13),(2238,5,27,15,13),(2239,5,27,16,13),(2240,3,27,33,13),(2241,1,27,36,13),(2242,6,27,45,13),(2243,0,27,1,14),(2244,7,27,11,14),(2245,7,27,12,14),(2246,7,27,13,14),(2247,7,27,14,14),(2248,7,27,15,14),(2249,5,27,16,14),(2250,0,27,22,14),(2251,4,27,24,14),(2252,4,27,25,14),(2253,4,27,26,14),(2254,4,27,27,14),(2255,4,27,28,14),(2256,3,27,30,14),(2257,3,27,31,14),(2258,3,27,32,14),(2259,3,27,33,14),(2260,3,27,34,14),(2261,3,27,35,14),(2262,6,27,44,14),(2263,6,27,45,14),(2264,7,27,10,15),(2265,7,27,11,15),(2266,7,27,12,15),(2267,7,27,13,15),(2268,7,27,14,15),(2269,5,27,16,15),(2270,5,27,17,15),(2271,5,27,18,15),(2272,4,27,24,15),(2273,4,27,25,15),(2274,4,27,26,15),(2275,4,27,27,15),(2276,4,27,28,15),(2277,4,27,29,15),(2278,4,27,30,15),(2279,4,27,31,15),(2280,3,27,32,15),(2281,3,27,33,15),(2282,3,27,34,15),(2283,3,27,35,15),(2284,3,27,36,15),(2285,3,27,37,15),(2286,3,27,38,15),(2287,7,27,8,16),(2288,7,27,9,16),(2289,7,27,10,16),(2290,7,27,11,16),(2291,7,27,14,16),(2292,7,27,15,16),(2293,5,27,16,16),(2294,5,27,17,16),(2295,4,27,22,16),(2296,4,27,23,16),(2297,4,27,24,16),(2298,4,27,25,16),(2299,4,27,26,16),(2300,4,27,27,16),(2301,4,27,28,16),(2302,4,27,29,16),(2303,4,27,31,16),(2304,4,27,32,16),(2305,3,27,33,16),(2306,3,27,34,16),(2307,3,27,35,16),(2308,3,27,36,16),(2309,3,27,37,16),(2310,3,27,38,16),(2311,3,27,39,16),(2312,6,35,8,0),(2313,6,35,10,0),(2314,6,35,15,0),(2315,6,35,16,0),(2316,5,35,28,0),(2317,5,35,29,0),(2318,5,35,30,0),(2319,1,35,31,0),(2320,3,35,44,0),(2321,3,35,45,0),(2322,3,35,48,0),(2323,6,35,8,1),(2324,6,35,9,1),(2325,6,35,10,1),(2326,6,35,11,1),(2327,6,35,16,1),(2328,6,35,17,1),(2329,6,35,18,1),(2330,6,35,19,1),(2331,6,35,20,1),(2332,5,35,25,1),(2333,5,35,26,1),(2334,5,35,27,1),(2335,5,35,28,1),(2336,5,35,29,1),(2337,5,35,30,1),(2338,4,35,34,1),(2339,4,35,35,1),(2340,3,35,42,1),(2341,3,35,43,1),(2342,3,35,45,1),(2343,3,35,46,1),(2344,3,35,47,1),(2345,3,35,48,1),(2346,0,35,5,2),(2347,6,35,9,2),(2348,6,35,15,2),(2349,6,35,16,2),(2350,6,35,17,2),(2351,11,35,26,2),(2352,11,35,30,2),(2353,4,35,34,2),(2354,4,35,35,2),(2355,3,35,43,2),(2356,3,35,44,2),(2357,3,35,45,2),(2358,3,35,46,2),(2359,6,35,9,3),(2360,4,35,10,3),(2361,4,35,11,3),(2362,4,35,12,3),(2363,8,35,19,3),(2364,4,35,34,3),(2365,4,35,35,3),(2366,4,35,36,3),(2367,4,35,37,3),(2368,3,35,40,3),(2369,3,35,41,3),(2370,3,35,42,3),(2371,3,35,43,3),(2372,3,35,44,3),(2373,3,35,45,3),(2374,3,35,46,3),(2375,3,35,47,3),(2376,3,35,48,3),(2377,3,35,49,3),(2378,4,35,11,4),(2379,4,35,12,4),(2380,4,35,13,4),(2381,4,35,34,4),(2382,4,35,35,4),(2383,4,35,36,4),(2384,4,35,37,4),(2385,4,35,38,4),(2386,3,35,45,4),(2387,4,35,9,5),(2388,4,35,10,5),(2389,4,35,11,5),(2390,4,35,12,5),(2391,0,35,24,5),(2392,4,35,34,5),(2393,4,35,35,5),(2394,3,35,45,5),(2395,4,35,10,6),(2396,4,35,11,6),(2397,0,35,17,6),(2398,9,35,19,6),(2399,13,35,34,6),(2400,3,35,41,6),(2401,3,35,45,6),(2402,10,35,48,6),(2403,4,35,10,7),(2404,4,35,11,7),(2405,3,35,41,7),(2406,0,35,43,7),(2407,12,35,25,8),(2408,3,35,34,8),(2409,3,35,35,8),(2410,3,35,36,8),(2411,3,35,37,8),(2412,3,35,38,8),(2413,3,35,39,8),(2414,3,35,40,8),(2415,3,35,41,8),(2416,3,35,42,8),(2417,4,35,11,9),(2418,4,35,12,9),(2419,4,35,13,9),(2420,4,35,14,9),(2421,5,35,20,9),(2422,10,35,21,9),(2423,2,35,31,9),(2424,3,35,36,9),(2425,3,35,37,9),(2426,3,35,38,9),(2427,3,35,39,9),(2428,3,35,40,9),(2429,3,35,41,9),(2430,0,35,42,9),(2431,0,35,1,10),(2432,4,35,9,10),(2433,4,35,10,10),(2434,4,35,11,10),(2435,4,35,12,10),(2436,4,35,13,10),(2437,4,35,14,10),(2438,5,35,17,10),(2439,5,35,20,10),(2440,1,35,37,10),(2441,3,35,39,10),(2442,3,35,40,10),(2443,3,35,41,10),(2444,4,35,10,11),(2445,4,35,11,11),(2446,5,35,16,11),(2447,5,35,17,11),(2448,5,35,18,11),(2449,5,35,19,11),(2450,5,35,20,11),(2451,6,35,31,11),(2452,6,35,32,11),(2453,3,35,39,11),(2454,3,35,41,11),(2455,9,35,42,11),(2456,14,35,0,12),(2457,5,35,8,12),(2458,5,35,18,12),(2459,3,35,19,12),(2460,5,35,20,12),(2461,6,35,32,12),(2462,6,35,33,12),(2463,7,35,35,12),(2464,3,35,39,12),(2465,3,35,41,12),(2466,5,35,8,13),(2467,5,35,9,13),(2468,5,35,10,13),(2469,5,35,11,13),(2470,3,35,17,13),(2471,3,35,18,13),(2472,3,35,19,13),(2473,5,35,20,13),(2474,5,35,21,13),(2475,6,35,32,13),(2476,6,35,33,13),(2477,7,35,35,13),(2478,7,35,36,13),(2479,7,35,38,13),(2480,3,35,40,13),(2481,3,35,41,13),(2482,4,35,3,14),(2483,5,35,10,14),(2484,5,35,11,14),(2485,3,35,17,14),(2486,3,35,18,14),(2487,3,35,20,14),(2488,6,35,32,14),(2489,7,35,34,14),(2490,7,35,35,14),(2491,7,35,36,14),(2492,7,35,37,14),(2493,7,35,38,14),(2494,7,35,39,14),(2495,7,35,40,14),(2496,7,35,41,14),(2497,5,35,49,14),(2498,5,35,51,14),(2499,4,35,3,15),(2500,0,35,7,15),(2501,5,35,11,15),(2502,5,35,12,15),(2503,3,35,18,15),(2504,3,35,19,15),(2505,3,35,20,15),(2506,13,35,22,15),(2507,6,35,32,15),(2508,6,35,33,15),(2509,6,35,34,15),(2510,7,35,35,15),(2511,7,35,36,15),(2512,7,35,37,15),(2513,7,35,38,15),(2514,7,35,39,15),(2515,5,35,49,15),(2516,5,35,50,15),(2517,5,35,51,15),(2518,4,35,0,16),(2519,4,35,1,16),(2520,4,35,2,16),(2521,4,35,3,16),(2522,4,35,4,16),(2523,5,35,10,16),(2524,5,35,11,16),(2525,5,35,12,16),(2526,3,35,18,16),(2527,3,35,19,16),(2528,3,35,20,16),(2529,3,35,21,16),(2530,7,35,34,16),(2531,7,35,35,16),(2532,7,35,36,16),(2533,7,35,37,16),(2534,7,35,38,16),(2535,7,35,39,16),(2536,7,35,40,16),(2537,7,35,41,16),(2538,5,35,47,16),(2539,5,35,48,16),(2540,5,35,49,16),(2541,4,35,0,17),(2542,4,35,1,17),(2543,4,35,2,17),(2544,4,35,3,17),(2545,4,35,4,17),(2546,3,35,17,17),(2547,3,35,18,17),(2548,3,35,19,17),(2549,3,35,20,17),(2550,3,35,21,17),(2551,7,35,31,17),(2552,7,35,32,17),(2553,7,35,33,17),(2554,7,35,34,17),(2555,7,35,35,17),(2556,7,35,36,17),(2557,7,35,37,17),(2558,7,35,38,17),(2559,7,35,39,17),(2560,7,35,40,17),(2561,7,35,41,17),(2562,7,35,42,17),(2563,5,35,48,17),(2564,5,35,49,17),(2565,4,35,0,18),(2566,4,35,1,18),(2567,4,35,2,18),(2568,4,35,3,18),(2569,4,35,4,18),(2570,4,35,5,18),(2571,3,35,15,18),(2572,3,35,16,18),(2573,3,35,17,18),(2574,3,35,18,18),(2575,3,35,19,18),(2576,3,35,20,18),(2577,3,35,21,18),(2578,7,35,31,18),(2579,7,35,32,18),(2580,7,35,33,18),(2581,7,35,34,18),(2582,7,35,35,18),(2583,7,35,36,18),(2584,7,35,37,18),(2585,7,35,38,18),(2586,7,35,39,18),(2587,7,35,40,18),(2588,5,35,47,18),(2589,5,35,48,18),(2590,11,36,4,0),(2591,3,36,8,0),(2592,3,36,9,0),(2593,2,36,21,0),(2594,6,36,29,0),(2595,6,36,30,0),(2596,6,36,31,0),(2597,6,36,32,0),(2598,6,36,33,0),(2599,6,36,34,0),(2600,6,36,35,0),(2601,3,36,39,0),(2602,9,36,41,0),(2603,4,36,0,1),(2604,4,36,1,1),(2605,3,36,8,1),(2606,0,36,9,1),(2607,14,36,13,1),(2608,8,36,23,1),(2609,6,36,31,1),(2610,0,36,32,1),(2611,3,36,39,1),(2612,3,36,40,1),(2613,4,36,0,2),(2614,4,36,1,2),(2615,4,36,2,2),(2616,4,36,3,2),(2617,3,36,8,2),(2618,3,36,37,2),(2619,3,36,38,2),(2620,3,36,39,2),(2621,4,36,0,3),(2622,4,36,1,3),(2623,4,36,3,3),(2624,3,36,8,3),(2625,3,36,9,3),(2626,3,36,10,3),(2627,3,36,11,3),(2628,3,36,37,3),(2629,3,36,38,3),(2630,3,36,39,3),(2631,5,36,45,3),(2632,5,36,46,3),(2633,4,36,0,4),(2634,14,36,1,4),(2635,3,36,8,4),(2636,3,36,9,4),(2637,3,36,10,4),(2638,3,36,11,4),(2639,3,36,12,4),(2640,12,36,24,4),(2641,3,36,37,4),(2642,3,36,38,4),(2643,3,36,39,4),(2644,3,36,40,4),(2645,5,36,45,4),(2646,5,36,46,4),(2647,3,36,8,5),(2648,3,36,9,5),(2649,3,36,10,5),(2650,6,36,11,5),(2651,3,36,12,5),(2652,10,36,13,5),(2653,3,36,34,5),(2654,3,36,39,5),(2655,5,36,45,5),(2656,5,36,46,5),(2657,3,36,6,6),(2658,3,36,7,6),(2659,3,36,8,6),(2660,3,36,9,6),(2661,3,36,10,6),(2662,6,36,11,6),(2663,3,36,12,6),(2664,0,36,17,6),(2665,3,36,33,6),(2666,3,36,34,6),(2667,3,36,35,6),(2668,6,36,36,6),(2669,0,36,37,6),(2670,3,36,39,6),(2671,5,36,46,6),(2672,3,36,6,7),(2673,3,36,7,7),(2674,3,36,8,7),(2675,6,36,9,7),(2676,3,36,10,7),(2677,6,36,11,7),(2678,6,36,12,7),(2679,3,36,32,7),(2680,3,36,33,7),(2681,3,36,34,7),(2682,3,36,35,7),(2683,6,36,36,7),(2684,0,36,41,7),(2685,3,36,8,8),(2686,6,36,9,8),(2687,3,36,10,8),(2688,3,36,11,8),(2689,6,36,12,8),(2690,13,36,18,8),(2691,3,36,33,8),(2692,3,36,34,8),(2693,3,36,35,8),(2694,6,36,36,8),(2695,6,36,37,8),(2696,2,36,3,9),(2697,4,36,6,9),(2698,4,36,7,9),(2699,4,36,8,9),(2700,6,36,9,9),(2701,6,36,10,9),(2702,0,36,11,9),(2703,3,36,32,9),(2704,3,36,33,9),(2705,3,36,34,9),(2706,6,36,36,9),(2707,6,36,37,9),(2708,6,36,38,9),(2709,6,36,39,9),(2710,9,36,42,9),(2711,4,36,5,10),(2712,4,36,6,10),(2713,4,36,7,10),(2714,4,36,8,10),(2715,4,36,9,10),(2716,6,36,10,10),(2717,12,36,21,10),(2718,4,36,27,10),(2719,6,36,37,10),(2720,6,36,38,10),(2721,8,36,3,11),(2722,4,36,7,11),(2723,5,36,8,11),(2724,5,36,9,11),(2725,6,36,10,11),(2726,10,36,11,11),(2727,1,36,17,11),(2728,0,36,19,11),(2729,4,36,27,11),(2730,4,36,29,11),(2731,7,36,33,11),(2732,7,36,34,11),(2733,7,36,35,11),(2734,7,36,36,11),(2735,7,36,37,11),(2736,4,36,38,11),(2737,4,36,7,12),(2738,5,36,8,12),(2739,6,36,9,12),(2740,6,36,10,12),(2741,4,36,27,12),(2742,4,36,28,12),(2743,4,36,29,12),(2744,7,36,32,12),(2745,7,36,33,12),(2746,7,36,34,12),(2747,7,36,35,12),(2748,7,36,36,12),(2749,7,36,37,12),(2750,4,36,38,12),(2751,4,36,39,12),(2752,4,36,40,12),(2753,4,36,41,12),(2754,5,36,7,13),(2755,5,36,8,13),(2756,6,36,9,13),(2757,6,36,10,13),(2758,1,36,19,13),(2759,4,36,27,13),(2760,4,36,28,13),(2761,4,36,29,13),(2762,7,36,32,13),(2763,7,36,33,13),(2764,7,36,34,13),(2765,0,36,35,13),(2766,7,36,37,13),(2767,4,36,38,13),(2768,4,36,39,13),(2769,4,36,40,13),(2770,4,36,41,13),(2771,4,36,42,13),(2772,5,36,7,14),(2773,3,36,9,14),(2774,3,36,10,14),(2775,5,36,16,14),(2776,4,36,29,14),(2777,7,36,32,14),(2778,7,36,33,14),(2779,7,36,34,14),(2780,13,36,37,14),(2781,6,36,0,15),(2782,6,36,1,15),(2783,6,36,2,15),(2784,3,36,9,15),(2785,3,36,11,15),(2786,3,36,12,15),(2787,3,36,13,15),(2788,3,36,14,15),(2789,5,36,15,15),(2790,5,36,16,15),(2791,5,36,17,15),(2792,5,36,18,15),(2793,7,36,32,15),(2794,7,36,33,15),(2795,7,36,34,15),(2796,7,36,35,15),(2797,7,36,36,15),(2798,6,36,1,16),(2799,6,36,2,16),(2800,3,36,7,16),(2801,3,36,8,16),(2802,3,36,9,16),(2803,3,36,10,16),(2804,3,36,11,16),(2805,3,36,12,16),(2806,3,36,13,16),(2807,3,36,14,16),(2808,5,36,15,16),(2809,5,36,16,16),(2810,7,36,33,16),(2811,7,36,34,16),(2812,7,36,36,16),(2813,5,37,11,0),(2814,5,37,12,0),(2815,5,37,13,0),(2816,5,37,14,0),(2817,5,37,15,0),(2818,5,37,16,0),(2819,6,37,17,0),(2820,5,37,11,1),(2821,5,37,12,1),(2822,5,37,13,1),(2823,5,37,14,1),(2824,5,37,15,1),(2825,6,37,17,1),(2826,6,37,18,1),(2827,6,37,19,1),(2828,5,37,25,1),(2829,5,37,26,1),(2830,1,37,33,1),(2831,7,37,2,2),(2832,7,37,3,2),(2833,0,37,11,2),(2834,5,37,13,2),(2835,5,37,14,2),(2836,6,37,17,2),(2837,6,37,18,2),(2838,5,37,23,2),(2839,5,37,25,2),(2840,5,37,26,2),(2841,5,37,27,2),(2842,14,37,28,2),(2843,7,37,0,3),(2844,7,37,1,3),(2845,7,37,2,3),(2846,7,37,3,3),(2847,7,37,4,3),(2848,7,37,5,3),(2849,14,37,6,3),(2850,5,37,14,3),(2851,5,37,15,3),(2852,5,37,16,3),(2853,6,37,17,3),(2854,6,37,18,3),(2855,1,37,21,3),(2856,5,37,23,3),(2857,5,37,24,3),(2858,5,37,25,3),(2859,5,37,26,3),(2860,5,37,27,3),(2861,9,37,31,3),(2862,7,37,1,4),(2863,7,37,2,4),(2864,7,37,3,4),(2865,7,37,4,4),(2866,7,37,5,4),(2867,6,37,17,4),(2868,6,37,18,4),(2869,6,37,19,4),(2870,3,37,23,4),(2871,3,37,24,4),(2872,3,37,25,4),(2873,3,37,26,4),(2874,5,37,27,4),(2875,7,37,0,5),(2876,7,37,1,5),(2877,7,37,3,5),(2878,7,37,4,5),(2879,7,37,5,5),(2880,6,37,17,5),(2881,3,37,23,5),(2882,3,37,24,5),(2883,3,37,25,5),(2884,3,37,26,5),(2885,5,37,27,5),(2886,7,37,0,6),(2887,7,37,1,6),(2888,7,37,2,6),(2889,7,37,3,6),(2890,7,37,4,6),(2891,4,37,5,6),(2892,0,37,22,6),(2893,3,37,24,6),(2894,3,37,25,6),(2895,5,37,26,6),(2896,5,37,27,6),(2897,5,37,28,6),(2898,7,37,0,7),(2899,7,37,1,7),(2900,3,37,2,7),(2901,4,37,3,7),(2902,4,37,4,7),(2903,4,37,5,7),(2904,4,37,6,7),(2905,4,37,7,7),(2906,4,37,8,7),(2907,4,37,9,7),(2908,4,37,10,7),(2909,4,37,11,7),(2910,12,37,15,7),(2911,3,37,24,7),(2912,3,37,25,7),(2913,3,37,26,7),(2914,3,37,1,8),(2915,3,37,2,8),(2916,4,37,3,8),(2917,2,37,5,8),(2918,4,37,7,8),(2919,4,37,8,8),(2920,11,37,11,8),(2921,3,37,22,8),(2922,4,37,25,8),(2923,3,37,0,9),(2924,3,37,1,9),(2925,3,37,2,9),(2926,4,37,7,9),(2927,4,37,8,9),(2928,3,37,21,9),(2929,3,37,22,9),(2930,4,37,25,9),(2931,4,37,26,9),(2932,4,37,27,9),(2933,4,37,28,9),(2934,10,37,31,9),(2935,3,37,0,10),(2936,3,37,1,10),(2937,3,37,2,10),(2938,3,37,3,10),(2939,8,37,7,10),(2940,3,37,21,10),(2941,3,37,22,10),(2942,3,37,24,10),(2943,4,37,25,10),(2944,4,37,26,10),(2945,4,37,27,10),(2946,4,37,28,10),(2947,4,37,29,10),(2948,3,37,0,11),(2949,3,37,1,11),(2950,3,37,22,11),(2951,3,37,23,11),(2952,3,37,24,11),(2953,5,37,25,11),(2954,5,37,26,11),(2955,4,37,27,11),(2956,4,37,28,11),(2957,4,37,29,11),(2958,3,37,1,12),(2959,0,37,21,12),(2960,3,37,23,12),(2961,5,37,24,12),(2962,5,37,25,12),(2963,5,37,26,12),(2964,4,37,27,12),(2965,4,37,28,12),(2966,6,37,29,12),(2967,6,37,30,12),(2968,4,37,15,13),(2969,4,37,16,13),(2970,5,37,23,13),(2971,5,37,24,13),(2972,5,37,25,13),(2973,5,37,26,13),(2974,6,37,29,13),(2975,6,37,30,13),(2976,0,37,33,13),(2977,5,37,11,14),(2978,4,37,12,14),(2979,4,37,13,14),(2980,4,37,14,14),(2981,4,37,15,14),(2982,4,37,16,14),(2983,13,37,17,14),(2984,5,37,24,14),(2985,5,37,25,14),(2986,5,37,26,14),(2987,6,37,30,14),(2988,5,37,11,15),(2989,4,37,12,15),(2990,4,37,13,15),(2991,4,37,14,15),(2992,4,37,15,15),(2993,4,37,16,15),(2994,5,37,24,15),(2995,5,37,25,15),(2996,0,37,2,16),(2997,5,37,8,16),(2998,5,37,9,16),(2999,5,37,10,16),(3000,5,37,11,16),(3001,11,37,12,16),(3002,4,37,16,16),(3003,4,37,17,16),(3004,3,37,18,16),(3005,5,37,24,16),(3006,5,37,25,16),(3007,5,37,26,16),(3008,5,37,7,17),(3009,5,37,8,17),(3010,5,37,9,17),(3011,5,37,10,17),(3012,5,37,11,17),(3013,3,37,16,17),(3014,3,37,18,17),(3015,5,37,26,17),(3016,9,37,27,17),(3017,5,37,8,18),(3018,5,37,9,18),(3019,5,37,10,18),(3020,5,37,11,18),(3021,3,37,16,18),(3022,3,37,17,18),(3023,3,37,18,18),(3024,3,37,19,18),(3025,8,37,23,18),(3026,5,37,26,18),(3027,4,37,32,18),(3028,3,37,1,19),(3029,6,37,5,19),(3030,6,37,6,19),(3031,5,37,9,19),(3032,4,37,11,19),(3033,3,37,16,19),(3034,3,37,17,19),(3035,3,37,18,19),(3036,5,37,26,19),(3037,4,37,31,19),(3038,4,37,32,19),(3039,3,37,0,20),(3040,3,37,1,20),(3041,3,37,2,20),(3042,3,37,3,20),(3043,6,37,4,20),(3044,6,37,5,20),(3045,6,37,6,20),(3046,4,37,8,20),(3047,4,37,9,20),(3048,4,37,10,20),(3049,4,37,11,20),(3050,3,37,16,20),(3051,5,37,26,20),(3052,5,37,29,20),(3053,4,37,30,20),(3054,4,37,31,20),(3055,4,37,32,20),(3056,4,37,33,20),(3057,4,37,34,20),(3058,4,37,35,20),(3059,3,37,0,21),(3060,3,37,1,21),(3061,3,37,2,21),(3062,6,37,4,21),(3063,4,37,10,21),(3064,4,37,11,21),(3065,3,37,16,21),(3066,3,37,17,21),(3067,5,37,25,21),(3068,5,37,26,21),(3069,5,37,27,21),(3070,5,37,28,21),(3071,5,37,29,21),(3072,4,37,30,21),(3073,4,37,31,21),(3074,4,37,32,21),(3075,4,37,33,21),(3076,4,37,34,21),(3077,3,37,0,22),(3078,3,37,1,22),(3079,3,37,2,22),(3080,3,37,3,22),(3081,3,37,4,22),(3082,4,37,8,22),(3083,4,37,9,22),(3084,4,37,10,22),(3085,4,37,11,22),(3086,4,37,12,22),(3087,4,37,13,22),(3088,4,37,14,22),(3089,4,37,15,22),(3090,5,37,26,22),(3091,5,37,27,22),(3092,5,37,28,22),(3093,5,37,29,22),(3094,5,37,30,22),(3095,4,37,32,22),(3096,5,3,0,0),(3097,5,3,1,0),(3098,5,3,2,0),(3099,5,3,3,0),(3100,5,3,16,0),(3101,5,3,17,0),(3102,5,3,18,0),(3103,5,3,19,0),(3104,5,3,20,0),(3105,5,3,21,0),(3106,5,3,22,0),(3107,5,3,23,0),(3108,5,3,24,0),(3109,5,3,25,0),(3110,5,3,26,0),(3111,5,3,0,1),(3112,5,3,1,1),(3113,5,3,2,1),(3114,5,3,3,1),(3115,5,3,4,1),(3116,12,3,7,1),(3117,5,3,17,1),(3118,5,3,18,1),(3119,5,3,20,1),(3120,14,3,22,1),(3121,5,3,26,1),(3122,5,3,28,1),(3123,5,3,0,2),(3124,5,3,1,2),(3125,5,3,2,2),(3126,5,3,4,2),(3127,5,3,5,2),(3128,5,3,25,2),(3129,5,3,26,2),(3130,5,3,28,2),(3131,5,3,29,2),(3132,5,3,0,3),(3133,5,3,1,3),(3134,5,3,4,3),(3135,5,3,5,3),(3136,5,3,28,3),(3137,6,3,29,3),(3138,5,3,28,4),(3139,6,3,29,4),(3140,4,3,3,5),(3141,4,3,5,5),(3142,0,3,18,5),(3143,6,3,27,5),(3144,6,3,28,5),(3145,6,3,29,5),(3146,4,3,2,6),(3147,4,3,3,6),(3148,4,3,4,6),(3149,4,3,5,6),(3150,6,3,26,6),(3151,6,3,27,6),(3152,6,3,28,6),(3153,6,3,29,6),(3154,4,3,1,7),(3155,4,3,2,7),(3156,4,3,3,7),(3157,4,3,4,7),(3158,4,3,5,7),(3159,6,3,26,7),(3160,5,3,27,7),(3161,5,3,28,7),(3162,5,3,29,7),(3163,4,3,1,8),(3164,4,3,2,8),(3165,4,3,3,8),(3166,4,3,4,8),(3167,0,3,10,8),(3168,5,3,27,8),(3169,5,3,28,8),(3170,5,3,29,8),(3171,4,3,1,9),(3172,4,3,2,9),(3173,4,3,3,9),(3174,5,3,29,9),(3175,4,3,1,10),(3176,6,3,5,10),(3177,6,3,6,10),(3178,5,3,28,10),(3179,5,3,29,10),(3180,6,3,4,11),(3181,6,3,5,11),(3182,6,3,6,11),(3183,6,3,7,11),(3184,6,3,8,11),(3185,5,3,27,11),(3186,5,3,28,11),(3187,5,3,29,11),(3188,13,3,1,12),(3189,6,3,8,12),(3190,6,3,9,12),(3191,6,3,10,12),(3192,5,3,27,12),(3193,5,3,28,12),(3194,5,3,29,12),(3195,6,3,8,13),(3196,6,3,9,13),(3197,6,3,10,13),(3198,5,3,28,13),(3199,5,3,29,13),(3200,5,3,2,14),(3201,6,3,9,14),(3202,5,3,28,14),(3203,5,3,0,15),(3204,5,3,2,15),(3205,5,3,3,15),(3206,5,3,0,16),(3207,5,3,1,16),(3208,5,3,2,16),(3209,5,3,3,16),(3210,5,3,4,16),(3211,2,3,26,16),(3212,5,3,0,17),(3213,5,3,1,17),(3214,5,3,2,17),(3215,5,3,3,17),(3216,5,3,4,17),(3217,5,3,0,18),(3218,5,3,1,18),(3219,5,3,3,18),(3220,6,3,6,18),(3221,4,3,24,18),(3222,4,3,29,18),(3223,5,3,0,19),(3224,5,3,2,19),(3225,5,3,3,19),(3226,6,3,7,19),(3227,6,3,8,19),(3228,4,3,24,19),(3229,4,3,25,19),(3230,4,3,26,19),(3231,4,3,27,19),(3232,4,3,28,19),(3233,4,3,29,19),(3234,5,3,0,20),(3235,11,3,1,20),(3236,6,3,5,20),(3237,6,3,6,20),(3238,6,3,7,20),(3239,6,3,8,20),(3240,6,3,9,20),(3241,4,3,23,20),(3242,4,3,24,20),(3243,4,3,25,20),(3244,4,3,26,20),(3245,4,3,27,20),(3246,4,3,28,20),(3247,4,3,29,20),(3248,5,3,0,21),(3249,6,3,5,21),(3250,6,3,6,21),(3251,4,3,24,21),(3252,4,3,25,21),(3253,4,3,26,21),(3254,4,3,27,21),(3255,4,3,28,21),(3256,4,3,29,21),(3257,5,3,0,22),(3258,6,3,6,22),(3259,8,3,10,22),(3260,4,3,24,22),(3261,4,3,25,22),(3262,4,3,26,22),(3263,4,3,27,22),(3264,4,3,28,22),(3265,4,3,29,22),(3266,5,3,0,23),(3267,4,3,26,23),(3268,4,3,27,23),(3269,4,3,28,23),(3270,5,3,0,24),(3271,3,3,18,24),(3272,3,3,19,24),(3273,3,3,20,24),(3274,0,3,24,24),(3275,4,3,27,24),(3276,0,3,28,24),(3277,5,3,0,25),(3278,3,3,9,25),(3279,3,3,10,25),(3280,3,3,13,25),(3281,3,3,14,25),(3282,3,3,15,25),(3283,3,3,17,25),(3284,3,3,18,25),(3285,3,3,19,25),(3286,3,3,20,25),(3287,3,3,21,25),(3288,5,3,0,26),(3289,5,3,1,26),(3290,5,3,2,26),(3291,3,3,9,26),(3292,3,3,10,26),(3293,3,3,11,26),(3294,3,3,14,26),(3295,3,3,15,26),(3296,3,3,16,26),(3297,3,3,17,26),(3298,3,3,18,26),(3299,3,3,19,26),(3300,3,3,20,26),(3301,3,3,21,26),(3302,3,3,23,26),(3303,5,3,2,27),(3304,0,3,3,27),(3305,3,3,10,27),(3306,3,3,11,27),(3307,3,3,12,27),(3308,3,3,13,27),(3309,3,3,14,27),(3310,3,3,15,27),(3311,3,3,16,27),(3312,3,3,17,27),(3313,3,3,18,27),(3314,3,3,19,27),(3315,3,3,20,27),(3316,3,3,21,27),(3317,3,3,22,27),(3318,3,3,23,27),(3319,3,3,24,27),(3320,0,3,0,28),(3321,3,3,11,28),(3322,3,3,12,28),(3323,3,3,13,28),(3324,3,3,14,28),(3325,3,3,15,28),(3326,3,3,16,28),(3327,3,3,17,28),(3328,3,3,18,28),(3329,3,3,19,28),(3330,3,3,20,28),(3331,3,3,21,28),(3332,3,3,22,28),(3333,3,3,23,28),(3334,3,3,24,28),(3335,3,3,10,29),(3336,3,3,11,29),(3337,3,3,12,29),(3338,3,3,13,29),(3339,3,3,14,29),(3340,3,3,15,29),(3341,3,3,16,29),(3342,3,3,17,29),(3343,3,3,18,29),(3344,3,3,19,29),(3345,3,3,20,29),(3346,3,3,21,29),(3347,3,3,22,29),(3348,3,3,23,29);
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
  `stored` int(10) unsigned NOT NULL default '0',
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
INSERT INTO `units` VALUES (1,100,1,3,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,18,28,NULL,1,0,0,0),(2,100,1,3,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,18,28,NULL,1,0,0,0),(3,100,1,3,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,18,28,NULL,1,0,0,0),(4,100,1,3,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,18,28,NULL,1,0,0,0),(5,100,1,3,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,18,28,NULL,1,0,0,0),(6,200,1,3,4,NULL,NULL,NULL,NULL,0,0,'Glancer',0,18,28,NULL,1,0,0,0),(7,200,1,3,4,NULL,NULL,NULL,NULL,0,0,'Glancer',0,18,28,NULL,1,0,0,0),(8,200,1,3,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,18,28,NULL,1,0,0,0),(9,200,1,3,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,18,28,NULL,1,0,0,0),(10,100,1,3,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,18,28,NULL,1,0,0,0),(11,100,1,3,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,18,28,NULL,1,0,0,0),(12,100,1,3,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,18,28,NULL,1,0,0,0),(13,100,1,3,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,26,16,NULL,1,0,0,0),(14,100,1,3,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,26,16,NULL,1,0,0,0),(15,100,1,3,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,26,16,NULL,1,0,0,0),(16,100,1,3,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,26,16,NULL,1,0,0,0),(17,100,1,3,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,26,16,NULL,1,0,0,0),(18,200,1,3,4,NULL,NULL,NULL,NULL,0,0,'Glancer',0,26,16,NULL,1,0,0,0),(19,200,1,3,4,NULL,NULL,NULL,NULL,0,0,'Glancer',0,26,16,NULL,1,0,0,0),(20,200,1,3,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,26,16,NULL,1,0,0,0),(21,200,1,3,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,26,16,NULL,1,0,0,0),(22,100,1,3,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,26,16,NULL,1,0,0,0),(23,100,1,3,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,26,16,NULL,1,0,0,0),(24,100,1,3,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,26,16,NULL,1,0,0,0),(25,100,1,3,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,3,27,NULL,1,0,0,0),(26,100,1,3,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,3,27,NULL,1,0,0,0),(27,100,1,3,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,3,27,NULL,1,0,0,0),(28,100,1,3,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,3,27,NULL,1,0,0,0),(29,100,1,3,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,3,27,NULL,1,0,0,0),(30,200,1,3,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,3,27,NULL,1,0,0,0),(31,200,1,3,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,3,27,NULL,1,0,0,0),(32,100,1,3,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,28,24,NULL,1,0,0,0),(33,100,1,3,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,28,24,NULL,1,0,0,0),(34,100,1,3,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,28,24,NULL,1,0,0,0),(35,100,1,3,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,28,24,NULL,1,0,0,0),(36,100,1,3,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,28,24,NULL,1,0,0,0),(37,200,1,3,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,28,24,NULL,1,0,0,0),(38,200,1,3,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,28,24,NULL,1,0,0,0),(39,100,1,3,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,18,25,NULL,1,0,0,0),(40,100,1,3,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,18,25,NULL,1,0,0,0),(41,100,1,3,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,18,25,NULL,1,0,0,0),(42,100,1,3,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,18,25,NULL,1,0,0,0),(43,100,1,3,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,18,25,NULL,1,0,0,0),(44,200,1,3,4,NULL,NULL,NULL,NULL,0,0,'Glancer',0,18,25,NULL,1,0,0,0),(45,200,1,3,4,NULL,NULL,NULL,NULL,0,0,'Glancer',0,18,25,NULL,1,0,0,0),(46,200,1,3,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,18,25,NULL,1,0,0,0),(47,200,1,3,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,18,25,NULL,1,0,0,0),(48,100,1,3,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,18,25,NULL,1,0,0,0),(49,100,1,3,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,18,25,NULL,1,0,0,0),(50,100,1,3,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,18,25,NULL,1,0,0,0),(51,100,1,3,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,15,26,NULL,1,0,0,0),(52,100,1,3,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,15,26,NULL,1,0,0,0),(53,100,1,3,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,15,26,NULL,1,0,0,0),(54,100,1,3,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,15,26,NULL,1,0,0,0),(55,100,1,3,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,15,26,NULL,1,0,0,0),(56,200,1,3,4,NULL,NULL,NULL,NULL,0,0,'Glancer',0,15,26,NULL,1,0,0,0),(57,200,1,3,4,NULL,NULL,NULL,NULL,0,0,'Glancer',0,15,26,NULL,1,0,0,0),(58,200,1,3,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,15,26,NULL,1,0,0,0),(59,200,1,3,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,15,26,NULL,1,0,0,0),(60,100,1,3,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,15,26,NULL,1,0,0,0),(61,100,1,3,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,15,26,NULL,1,0,0,0),(62,100,1,3,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,15,26,NULL,1,0,0,0),(63,100,1,3,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,7,28,NULL,1,0,0,0),(64,100,1,3,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,7,28,NULL,1,0,0,0),(65,100,1,3,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,7,28,NULL,1,0,0,0),(66,100,1,3,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,7,28,NULL,1,0,0,0),(67,100,1,3,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,7,28,NULL,1,0,0,0),(68,200,1,3,4,NULL,NULL,NULL,NULL,0,0,'Glancer',0,7,28,NULL,1,0,0,0),(69,200,1,3,4,NULL,NULL,NULL,NULL,0,0,'Glancer',0,7,28,NULL,1,0,0,0),(70,200,1,3,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,7,28,NULL,1,0,0,0),(71,200,1,3,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,7,28,NULL,1,0,0,0),(72,100,1,3,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,7,28,NULL,1,0,0,0),(73,100,1,3,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,7,28,NULL,1,0,0,0),(74,100,1,3,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,7,28,NULL,1,0,0,0),(75,100,1,3,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,24,24,NULL,1,0,0,0),(76,100,1,3,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,24,24,NULL,1,0,0,0),(77,100,1,3,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,24,24,NULL,1,0,0,0),(78,100,1,3,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,24,24,NULL,1,0,0,0),(79,100,1,3,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,24,24,NULL,1,0,0,0),(80,200,1,3,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,24,24,NULL,1,0,0,0),(81,200,1,3,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,24,24,NULL,1,0,0,0),(82,100,1,3,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,0,28,NULL,1,0,0,0),(83,100,1,3,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,0,28,NULL,1,0,0,0),(84,100,1,3,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,0,28,NULL,1,0,0,0),(85,100,1,3,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,0,28,NULL,1,0,0,0),(86,100,1,3,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,0,28,NULL,1,0,0,0),(87,200,1,3,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,0,28,NULL,1,0,0,0),(88,200,1,3,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,0,28,NULL,1,0,0,0),(89,100,1,3,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,22,27,NULL,1,0,0,0),(90,100,1,3,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,22,27,NULL,1,0,0,0),(91,100,1,3,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,22,27,NULL,1,0,0,0),(92,100,1,3,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,22,27,NULL,1,0,0,0),(93,100,1,3,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,22,27,NULL,1,0,0,0),(94,200,1,3,4,NULL,NULL,NULL,NULL,0,0,'Glancer',0,22,27,NULL,1,0,0,0),(95,200,1,3,4,NULL,NULL,NULL,NULL,0,0,'Glancer',0,22,27,NULL,1,0,0,0),(96,200,1,3,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,22,27,NULL,1,0,0,0),(97,200,1,3,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,22,27,NULL,1,0,0,0),(98,100,1,3,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,22,27,NULL,1,0,0,0),(99,100,1,3,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,22,27,NULL,1,0,0,0),(100,100,1,3,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,22,27,NULL,1,0,0,0),(101,100,1,3,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,25,20,NULL,1,0,0,0),(102,100,1,3,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,25,20,NULL,1,0,0,0),(103,100,1,3,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,25,20,NULL,1,0,0,0),(104,100,1,3,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,25,20,NULL,1,0,0,0),(105,100,1,3,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,25,20,NULL,1,0,0,0),(106,200,1,3,4,NULL,NULL,NULL,NULL,0,0,'Glancer',0,25,20,NULL,1,0,0,0),(107,200,1,3,4,NULL,NULL,NULL,NULL,0,0,'Glancer',0,25,20,NULL,1,0,0,0),(108,200,1,3,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,25,20,NULL,1,0,0,0),(109,200,1,3,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,25,20,NULL,1,0,0,0),(110,100,1,3,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,25,20,NULL,1,0,0,0),(111,100,1,3,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,25,20,NULL,1,0,0,0),(112,100,1,3,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,25,20,NULL,1,0,0,0),(113,100,1,3,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,12,27,NULL,1,0,0,0),(114,100,1,3,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,12,27,NULL,1,0,0,0),(115,100,1,3,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,12,27,NULL,1,0,0,0),(116,100,1,3,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,12,27,NULL,1,0,0,0),(117,100,1,3,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,12,27,NULL,1,0,0,0),(118,200,1,3,4,NULL,NULL,NULL,NULL,0,0,'Glancer',0,12,27,NULL,1,0,0,0),(119,200,1,3,4,NULL,NULL,NULL,NULL,0,0,'Glancer',0,12,27,NULL,1,0,0,0),(120,200,1,3,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,12,27,NULL,1,0,0,0),(121,200,1,3,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,12,27,NULL,1,0,0,0),(122,100,1,3,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,12,27,NULL,1,0,0,0),(123,100,1,3,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,12,27,NULL,1,0,0,0),(124,100,1,3,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,12,27,NULL,1,0,0,0),(125,100,1,3,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,26,27,NULL,1,0,0,0),(126,100,1,3,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,26,27,NULL,1,0,0,0),(127,100,1,3,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,26,27,NULL,1,0,0,0),(128,100,1,3,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,26,27,NULL,1,0,0,0),(129,100,1,3,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,26,27,NULL,1,0,0,0),(130,200,1,3,4,NULL,NULL,NULL,NULL,0,0,'Glancer',0,26,27,NULL,1,0,0,0),(131,200,1,3,4,NULL,NULL,NULL,NULL,0,0,'Glancer',0,26,27,NULL,1,0,0,0),(132,200,1,3,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,26,27,NULL,1,0,0,0),(133,200,1,3,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,26,27,NULL,1,0,0,0),(134,100,1,3,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,26,27,NULL,1,0,0,0),(135,100,1,3,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,26,27,NULL,1,0,0,0),(136,100,1,3,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,26,27,NULL,1,0,0,0);
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

-- Dump completed on 2010-10-07 11:04:58
