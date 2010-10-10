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
INSERT INTO `buildings` VALUES (1,32,7,16,0,0,0,1,'Thunder',NULL,8,17,NULL,1,300,NULL,0,NULL,NULL,0),(2,32,21,16,0,0,0,1,'Thunder',NULL,22,17,NULL,1,300,NULL,0,NULL,NULL,0),(3,32,21,9,0,0,0,1,'Screamer',NULL,22,10,NULL,1,300,NULL,0,NULL,NULL,0),(4,32,18,28,0,0,0,1,'NpcSolarPlant',NULL,19,29,NULL,0,1000,NULL,0,NULL,NULL,0),(5,32,7,9,0,0,0,1,'Vulcan',NULL,8,10,NULL,1,300,NULL,0,NULL,NULL,0),(6,32,14,22,0,0,0,1,'Thunder',NULL,15,23,NULL,1,300,NULL,0,NULL,NULL,0),(7,32,26,16,0,0,0,1,'NpcZetiumExtractor',NULL,27,17,NULL,0,800,NULL,0,NULL,NULL,0),(8,32,3,27,0,0,0,1,'NpcMetalExtractor',NULL,4,28,NULL,0,400,NULL,0,NULL,NULL,0),(9,32,28,24,0,0,0,1,'NpcMetalExtractor',NULL,29,25,NULL,0,400,NULL,0,NULL,NULL,0),(10,32,18,25,0,0,0,1,'NpcSolarPlant',NULL,19,26,NULL,0,1000,NULL,0,NULL,NULL,0),(11,32,15,26,0,0,0,1,'NpcSolarPlant',NULL,16,27,NULL,0,1000,NULL,0,NULL,NULL,0),(12,32,7,28,0,0,0,1,'NpcCommunicationsHub',NULL,9,29,NULL,0,1200,NULL,0,NULL,NULL,0),(13,32,21,22,0,0,0,1,'Vulcan',NULL,22,23,NULL,1,300,NULL,0,NULL,NULL,0),(14,32,24,24,0,0,0,1,'NpcMetalExtractor',NULL,25,25,NULL,0,400,NULL,0,NULL,NULL,0),(15,32,0,28,0,0,0,1,'NpcMetalExtractor',NULL,1,29,NULL,0,400,NULL,0,NULL,NULL,0),(16,32,11,14,0,0,0,1,'Mothership',NULL,18,19,NULL,1,10500,NULL,0,NULL,NULL,0),(17,32,22,27,0,0,0,1,'NpcSolarPlant',NULL,23,28,NULL,0,1000,NULL,0,NULL,NULL,0),(18,32,14,9,0,0,0,1,'Thunder',NULL,15,10,NULL,1,300,NULL,0,NULL,NULL,0),(19,32,25,20,0,0,0,1,'NpcTemple',NULL,27,22,NULL,0,1500,NULL,0,NULL,NULL,0),(20,32,12,27,0,0,0,1,'NpcSolarPlant',NULL,13,28,NULL,0,1000,NULL,0,NULL,NULL,0),(21,32,7,22,0,0,0,1,'Screamer',NULL,8,23,NULL,1,300,NULL,0,NULL,NULL,0),(22,32,26,27,0,0,0,1,'NpcCommunicationsHub',NULL,28,28,NULL,0,1200,NULL,0,NULL,NULL,0);
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
INSERT INTO `folliages` VALUES (12,0,1,6),(12,0,3,2),(12,0,4,6),(12,0,5,1),(12,0,13,9),(12,0,14,11),(12,1,3,2),(12,1,6,4),(12,1,7,1),(12,1,17,0),(12,2,6,12),(12,2,7,1),(12,2,8,3),(12,2,14,0),(12,3,1,0),(12,3,2,4),(12,3,6,5),(12,3,7,5),(12,3,8,9),(12,3,12,13),(12,3,13,2),(12,3,14,7),(12,3,16,4),(12,4,4,0),(12,4,6,8),(12,4,11,7),(12,4,22,7),(12,5,3,12),(12,5,6,4),(12,6,6,7),(12,7,1,5),(12,7,20,3),(12,8,19,5),(12,9,7,10),(12,9,19,5),(12,10,10,10),(12,10,14,3),(12,10,16,4),(12,10,17,7),(12,11,5,11),(12,11,6,12),(12,11,8,13),(12,11,10,12),(12,11,11,13),(12,11,16,4),(12,12,10,6),(12,12,11,9),(12,13,8,7),(12,13,9,9),(12,13,21,13),(12,14,3,3),(12,14,4,12),(12,14,5,2),(12,14,7,3),(12,14,9,13),(12,14,12,1),(12,14,15,6),(12,14,19,11),(12,14,22,10),(12,15,7,4),(12,15,19,10),(12,15,20,11),(12,16,4,13),(12,16,7,6),(12,16,8,8),(12,16,9,2),(12,16,11,6),(12,16,20,11),(12,17,0,8),(12,17,7,7),(12,17,8,0),(12,17,9,4),(12,17,15,4),(12,17,17,8),(12,18,0,9),(12,18,13,5),(12,18,17,12),(12,18,22,2),(12,19,0,2),(12,19,2,3),(12,19,14,6),(12,19,16,0),(12,19,17,8),(12,20,0,8),(12,20,3,8),(12,20,11,12),(12,20,13,10),(12,20,15,8),(12,20,16,5),(12,20,18,6),(12,21,1,4),(12,21,4,10),(12,21,12,2),(12,21,18,8),(12,22,0,4),(12,22,2,0),(12,22,3,3),(12,22,4,8),(12,22,12,12),(12,23,3,12),(12,23,8,8),(12,23,11,9),(12,23,14,4),(12,24,0,3),(12,24,2,4),(12,24,3,13),(12,24,4,5),(12,24,5,11),(12,24,8,5),(12,25,0,2),(12,25,1,0),(12,25,3,0),(12,25,4,13),(12,25,8,7),(12,26,10,13),(12,26,11,10),(12,27,20,4),(12,27,21,2),(12,28,0,5),(12,28,22,13),(12,29,1,1),(12,29,12,6),(12,30,3,5),(12,30,11,13),(12,30,22,0),(12,31,0,11),(12,31,1,0),(12,31,11,11),(12,31,22,13),(12,32,0,9),(12,32,5,5),(12,32,7,10),(12,33,1,10),(12,33,3,4),(12,33,4,12),(12,33,8,8),(12,33,11,0),(12,33,15,0),(12,33,22,9),(12,34,4,11),(12,36,6,0),(12,36,9,11),(12,36,13,9),(12,37,4,4),(12,37,11,12),(12,37,12,12),(12,37,13,13),(12,37,21,13),(12,38,3,12),(12,38,4,12),(12,38,12,10),(12,39,14,13),(12,39,17,12),(12,40,1,5),(12,40,16,12),(12,41,3,0),(12,41,4,6),(12,41,5,6),(12,41,7,13),(12,41,14,8),(12,41,18,2),(12,43,18,1),(12,44,2,10),(12,44,7,9),(12,45,3,6),(12,45,4,7),(12,45,16,5),(12,46,9,7),(12,47,2,5),(12,47,7,2),(12,47,9,0),(12,48,6,9),(12,48,8,9),(12,48,10,13),(12,49,7,9),(12,49,15,11),(14,0,9,9),(14,0,11,2),(14,0,15,8),(14,0,19,0),(14,0,20,5),(14,3,22,2),(14,4,11,4),(14,4,12,2),(14,4,17,11),(14,4,18,3),(14,4,25,13),(14,5,3,7),(14,5,5,10),(14,5,11,12),(14,5,13,11),(14,5,17,2),(14,5,22,5),(14,6,11,8),(14,6,12,12),(14,6,19,7),(14,6,22,2),(14,7,3,7),(14,7,7,5),(14,7,12,4),(14,7,16,8),(14,7,19,7),(14,7,25,11),(14,8,7,2),(14,8,8,13),(14,8,16,10),(14,9,25,1),(14,10,0,11),(14,10,1,3),(14,10,6,10),(14,10,14,5),(14,10,20,6),(14,10,23,8),(14,11,1,4),(14,11,24,5),(14,12,0,7),(14,12,1,11),(14,12,19,8),(14,12,21,13),(14,13,6,11),(14,14,3,11),(14,14,7,1),(14,15,15,11),(14,16,0,6),(14,16,1,12),(14,16,12,5),(14,17,1,13),(14,17,16,11),(14,18,9,11),(14,18,11,3),(14,18,14,13),(14,18,17,8),(14,18,18,5),(14,18,19,13),(14,18,21,7),(14,18,22,7),(14,18,23,3),(14,19,1,6),(14,19,7,12),(14,19,10,4),(14,19,16,4),(14,19,25,1),(14,20,8,9),(14,20,24,3),(14,21,12,5),(14,21,14,13),(14,22,4,2),(14,22,12,11),(14,22,17,6),(14,23,0,13),(14,23,21,8),(14,23,22,10),(14,24,1,9),(14,24,3,6),(14,24,8,0),(14,24,15,0),(14,24,16,8),(14,24,19,13),(14,24,21,1),(14,25,2,2),(14,25,3,1),(14,25,19,6),(14,26,16,10),(14,26,18,7),(14,27,3,6),(14,27,5,5),(14,27,20,12),(14,27,25,1),(14,28,6,0),(14,29,6,3),(14,29,18,5),(14,29,22,3),(14,30,5,8),(14,30,22,6),(14,31,6,0),(14,31,22,6),(14,32,9,13),(14,33,0,2),(14,33,3,4),(14,33,4,5),(14,34,9,5),(14,35,1,11),(14,35,2,12),(14,35,13,5),(14,36,19,1),(14,36,25,8),(14,37,4,7),(14,37,19,6),(14,38,18,3),(14,39,14,13),(14,40,11,7),(14,40,12,12),(14,41,1,7),(14,42,1,8),(18,0,3,4),(18,0,5,6),(18,0,9,3),(18,0,11,8),(18,0,13,9),(18,1,1,1),(18,1,15,11),(18,2,20,0),(18,2,21,9),(18,3,2,4),(18,3,10,7),(18,3,13,5),(18,3,17,8),(18,4,10,3),(18,4,15,13),(18,4,17,13),(18,4,18,1),(18,5,22,1),(18,6,9,8),(18,6,22,4),(18,7,7,3),(18,7,9,7),(18,9,8,13),(18,9,22,11),(18,10,3,4),(18,11,5,4),(18,11,22,4),(18,12,1,11),(18,12,3,7),(18,12,7,5),(18,12,20,3),(18,12,22,8),(18,13,1,2),(18,13,3,7),(18,13,7,7),(18,13,8,6),(18,13,20,3),(18,14,7,3),(18,14,8,8),(18,14,22,13),(18,15,7,10),(18,16,0,2),(18,16,1,7),(18,16,21,0),(18,17,0,3),(18,17,8,13),(18,17,13,3),(18,17,16,4),(18,17,19,9),(18,17,20,9),(18,17,21,5),(18,17,22,4),(18,18,0,3),(18,18,14,4),(18,18,21,9),(18,18,22,13),(18,19,8,5),(18,19,11,12),(18,19,22,3),(18,20,0,6),(18,20,8,0),(18,20,9,8),(18,20,16,13),(18,20,17,0),(18,20,19,6),(18,21,8,5),(18,21,11,5),(18,21,18,12),(18,21,22,6),(18,22,12,2),(18,22,15,11),(18,22,16,1),(18,23,2,0),(18,23,4,2),(18,23,8,7),(18,23,19,5),(18,23,22,7),(18,24,2,8),(18,24,10,5),(18,26,14,1),(18,26,15,9),(18,26,17,13),(18,27,9,9),(18,27,11,5),(18,27,15,13),(18,27,16,7),(18,27,17,11),(18,28,10,13),(18,28,12,10),(18,28,15,1),(18,28,16,12),(18,28,19,2),(18,29,14,6),(18,29,16,13),(18,29,17,13),(18,29,20,1),(18,30,11,1),(18,30,12,6),(18,30,15,1),(18,32,20,13),(18,32,21,8),(18,33,19,0),(18,33,21,9),(18,34,9,11),(18,34,18,10),(18,35,10,0),(18,35,11,4),(18,35,14,7),(18,35,17,6),(20,1,6,13),(20,2,4,5),(20,11,5,1),(20,13,13,5),(20,14,2,3),(20,14,11,12),(20,14,12,0),(20,17,11,13),(20,17,12,12),(20,18,17,13),(20,19,13,10),(20,21,2,4),(20,21,4,8),(20,21,13,1),(20,21,16,2),(20,22,2,10),(20,22,3,8),(20,22,11,5),(20,22,15,0),(20,23,4,4),(20,23,15,13),(20,24,4,8),(20,24,12,13),(20,25,0,13),(20,25,5,9),(20,25,6,11),(20,25,9,13),(20,26,7,11),(20,26,9,9),(20,26,14,3),(20,26,15,2),(20,27,8,12),(20,27,9,3),(20,27,10,4),(20,28,3,10),(20,28,8,13),(20,29,0,2),(20,29,1,9),(20,29,2,0),(20,29,16,6),(20,29,17,7),(20,30,1,5),(20,32,2,4),(20,33,1,3),(20,33,4,4),(20,33,9,12),(20,33,10,5),(20,34,1,3),(20,34,3,13),(20,34,5,9),(20,34,7,4),(20,34,10,10),(20,34,17,3),(20,36,3,0),(20,36,12,2),(20,36,13,4),(20,37,17,3),(20,38,0,10),(20,38,3,6),(20,38,13,7),(20,38,16,1),(20,39,2,2),(20,40,2,0),(20,40,4,4),(20,40,5,7),(20,41,2,7),(20,41,3,13),(20,41,6,9),(20,41,13,9),(20,41,17,12),(27,0,1,5),(27,0,14,2),(27,0,15,13),(27,0,16,2),(27,0,17,7),(27,1,2,6),(27,1,8,9),(27,1,16,11),(27,1,19,4),(27,2,1,6),(27,2,4,7),(27,2,5,6),(27,2,10,4),(27,2,22,6),(27,3,0,7),(27,3,3,0),(27,3,4,10),(27,3,21,1),(27,3,22,9),(27,4,19,1),(27,4,20,3),(27,4,21,7),(27,5,9,10),(27,6,11,8),(27,6,15,5),(27,6,16,12),(27,7,9,10),(27,7,22,5),(27,10,9,8),(27,10,13,6),(27,10,14,13),(27,10,20,11),(27,11,6,5),(27,11,14,0),(27,11,15,8),(27,11,19,5),(27,11,20,10),(27,12,14,8),(27,12,17,5),(27,12,18,1),(27,13,5,11),(27,13,12,10),(27,13,17,13),(27,13,19,10),(27,14,0,7),(27,14,21,2),(27,14,22,13),(27,15,0,4),(27,17,0,8),(27,19,1,2),(27,21,17,11),(27,22,3,0),(27,22,5,10),(27,22,6,9),(27,22,13,0),(27,24,9,3),(27,24,13,9),(27,24,15,9),(27,25,4,10),(27,25,10,8),(27,25,11,2),(27,26,12,8),(27,26,18,4),(27,27,11,1),(27,27,16,10),(27,27,21,2),(27,28,2,9),(27,28,15,1),(27,29,0,8),(27,29,5,6),(27,29,17,3),(27,29,22,6),(27,30,3,7),(27,30,13,11),(27,30,16,0),(27,30,22,7),(27,31,22,3),(27,32,3,11),(27,32,5,4),(27,32,15,11),(27,32,16,10),(27,32,17,3),(27,33,17,5),(27,33,22,8),(27,34,1,0),(27,34,2,13),(27,34,3,5),(27,34,12,1),(27,34,16,2),(27,34,20,0),(27,35,0,6),(27,35,1,8),(27,35,2,3),(27,35,15,2),(27,35,17,1),(27,35,18,2),(27,36,0,8),(27,36,17,2),(27,37,3,7),(27,37,11,4),(27,37,12,5),(27,37,13,12),(27,37,15,7),(27,37,17,12),(27,38,2,1),(27,38,15,12),(27,38,16,12),(27,38,20,13),(27,38,22,8),(28,3,4,4),(28,3,5,2),(28,3,9,9),(28,3,14,4),(28,4,5,12),(28,4,10,5),(28,5,12,7),(28,6,6,4),(28,6,14,11),(28,7,5,0),(28,7,6,4),(28,7,12,3),(28,7,14,5),(28,8,1,7),(28,8,8,1),(28,8,10,0),(28,8,11,6),(28,9,0,8),(28,9,5,9),(28,9,12,8),(28,10,6,10),(28,10,8,4),(28,10,14,8),(28,11,0,7),(28,11,2,4),(28,11,7,13),(28,11,9,9),(28,11,10,1),(28,12,1,3),(28,12,7,11),(28,12,8,6),(28,12,13,5),(28,13,0,3),(28,13,6,12),(28,14,7,6),(28,15,0,7),(28,15,7,10),(28,15,11,11),(28,17,6,10),(28,17,7,1),(28,18,1,9),(28,18,5,3),(28,19,14,2),(28,20,5,8),(28,20,14,6),(28,21,7,5),(28,22,1,12),(28,22,6,13),(28,22,7,1),(28,23,0,12),(28,23,3,4),(28,23,4,8),(28,24,2,12),(28,24,5,3),(28,24,9,4),(28,24,11,2),(28,25,2,11),(28,25,6,11),(28,28,14,13),(28,30,0,0),(28,30,14,6),(28,32,14,13),(28,36,5,1),(28,36,12,8),(28,37,7,7),(28,37,9,10),(28,38,0,3),(28,38,8,0),(28,40,7,2),(28,41,1,8),(28,41,2,7),(28,41,5,2),(28,41,6,10),(28,41,9,5),(28,42,2,2),(28,42,6,11),(28,42,9,2),(28,44,1,11),(28,44,6,2),(28,44,12,10),(28,45,1,12),(28,46,0,6),(28,46,1,1),(28,46,5,9),(28,46,6,7),(28,46,10,11),(28,47,1,2),(28,47,5,6),(28,47,10,9),(29,0,0,6),(29,0,16,8),(29,1,2,3),(29,1,19,3),(29,2,10,2),(29,2,14,4),(29,2,16,0),(29,3,14,8),(29,3,22,0),(29,4,11,10),(29,4,13,7),(29,5,14,12),(29,6,10,3),(29,6,14,9),(29,6,21,4),(29,7,16,9),(29,7,21,12),(29,8,10,3),(29,8,22,5),(29,10,9,12),(29,10,13,11),(29,11,8,8),(29,11,9,7),(29,11,10,11),(29,12,15,12),(29,13,17,13),(29,14,3,9),(29,14,22,3),(29,15,17,1),(29,15,18,4),(29,16,3,4),(29,16,5,8),(29,17,1,0),(29,17,5,8),(29,17,14,10),(29,18,0,5),(29,18,1,12),(29,18,3,13),(29,18,4,2),(29,18,7,8),(29,18,21,6),(29,19,2,13),(29,19,6,2),(29,19,14,4),(29,19,22,7),(29,20,3,1),(29,21,0,2),(29,21,6,6),(29,21,7,8),(29,21,18,2),(29,22,0,13),(29,22,6,2),(29,22,9,13),(29,22,14,4),(29,23,11,9),(29,23,13,9),(29,24,0,0),(29,24,9,7),(29,24,10,12),(29,24,12,8),(29,24,13,10),(29,24,16,5),(29,24,21,5),(29,25,11,5),(29,25,13,6),(29,25,17,10),(29,26,6,4),(29,26,7,13),(29,26,12,1),(29,26,16,7),(29,27,8,6),(29,27,9,11),(29,27,12,5),(29,28,9,13),(29,28,13,11),(29,28,16,2),(29,28,17,0),(29,29,0,13),(29,29,17,12),(29,29,22,0),(29,30,7,12),(29,30,15,0),(29,30,16,9),(29,31,0,10),(29,31,7,2),(29,31,8,1),(29,31,10,3),(29,31,11,3),(29,31,13,0),(29,31,14,5),(29,31,22,13),(29,33,7,11),(29,33,8,12),(29,33,13,3),(29,34,7,3),(29,34,8,10),(29,34,12,13),(29,34,16,9),(29,35,8,2),(29,35,17,6),(29,35,20,10),(29,35,21,0),(29,35,22,3),(29,36,0,5),(29,36,8,12),(29,36,20,2),(29,38,0,1),(29,38,21,0),(29,39,3,7),(29,39,4,12),(29,39,7,8),(29,39,10,6),(29,39,12,1),(29,39,14,7),(29,39,17,6),(29,39,22,1),(29,40,2,8),(29,40,4,0),(29,40,10,10),(29,40,12,2),(29,41,2,3),(29,41,15,10),(29,41,17,8),(29,41,22,12),(29,42,17,7),(29,42,20,3),(29,43,6,3),(29,43,13,4),(29,43,18,11),(29,43,20,2),(29,43,21,8),(29,44,0,7),(29,44,3,10),(29,44,12,7),(29,44,20,9),(30,0,1,9),(30,0,4,0),(30,0,8,13),(30,1,1,1),(30,1,2,2),(30,1,7,9),(30,1,14,12),(30,2,1,13),(30,2,6,11),(30,2,7,10),(30,2,12,6),(30,2,15,8),(30,2,25,2),(30,3,5,6),(30,3,14,8),(30,3,15,11),(30,4,1,5),(30,4,4,8),(30,4,9,13),(30,4,16,3),(30,4,25,7),(30,6,4,4),(30,6,24,6),(30,6,25,3),(30,7,23,7),(30,8,2,11),(30,9,12,6),(30,12,0,13),(30,13,1,3),(30,14,4,11),(30,14,5,4),(30,14,6,9),(30,15,4,7),(30,15,7,1),(30,16,0,7),(30,16,6,2),(30,16,7,7),(30,17,2,9),(30,17,3,13),(30,17,4,10),(30,18,2,1),(30,18,3,8),(30,18,5,13),(30,18,7,6),(30,18,9,13),(30,18,23,1),(30,19,4,1),(30,19,5,7),(30,19,11,6),(30,20,0,2),(30,20,8,11),(30,20,20,13),(30,22,0,2),(30,22,16,5),(30,22,22,2),(30,23,21,7),(30,24,9,12),(30,24,21,9),(30,25,25,0),(30,26,0,0),(30,26,15,5),(30,26,24,2),(30,27,0,2),(30,27,8,2),(30,28,1,8),(30,29,16,13),(30,30,2,12),(30,30,7,2),(30,30,23,10),(30,30,24,13),(30,31,23,9),(30,32,17,2),(30,32,23,3),(30,33,2,12),(30,33,20,2),(30,35,12,4),(30,35,14,2),(30,35,18,0),(30,36,4,0),(30,36,12,11),(30,36,13,5),(30,36,18,6),(30,36,20,13),(30,36,21,0),(30,36,24,13),(30,37,13,2),(30,37,14,10),(30,37,17,0),(30,38,1,9),(30,38,4,4),(30,38,6,5),(30,38,23,8),(30,39,8,4),(30,41,2,5),(30,41,22,2),(30,42,4,3),(30,43,0,4),(30,43,9,8),(30,43,11,11),(30,43,13,7),(30,44,1,0),(30,44,18,7),(30,44,20,11),(30,44,21,8),(30,45,0,12),(30,45,1,10),(30,45,3,5),(30,45,7,6),(30,45,10,3),(30,45,11,13),(30,45,12,9),(30,45,13,3),(30,45,14,13),(30,45,22,0),(30,46,0,2),(30,46,2,5),(30,46,4,4),(30,46,5,7),(30,46,6,6),(30,46,8,5),(30,46,13,6),(30,47,2,1),(30,48,2,0),(30,48,20,0),(30,49,3,9),(30,49,5,11),(30,49,23,3),(30,50,5,5),(30,50,6,8),(30,50,19,4),(30,51,0,9),(30,51,4,11),(30,51,5,11),(30,51,7,4),(30,51,14,9),(30,51,19,11),(30,51,20,3),(30,51,24,9),(32,0,7,2),(32,0,13,3),(32,1,4,5),(32,1,11,9),(32,2,4,12),(32,2,5,0),(32,2,10,4),(32,3,2,6),(32,3,11,6),(32,3,29,1),(32,4,9,2),(32,4,10,7),(32,4,14,1),(32,5,8,1),(32,5,9,2),(32,6,9,12),(32,6,17,2),(32,7,0,12),(32,7,21,1),(32,7,27,4),(32,8,0,9),(32,8,7,0),(32,8,14,1),(32,8,26,4),(32,9,0,6),(32,9,8,0),(32,9,10,11),(32,9,11,2),(32,9,22,0),(32,9,23,12),(32,10,21,11),(32,11,12,10),(32,12,12,7),(32,13,0,7),(32,13,1,12),(32,13,2,1),(32,13,4,8),(32,13,5,3),(32,13,12,12),(32,13,13,9),(32,13,20,13),(32,13,24,6),(32,13,26,9),(32,14,2,9),(32,14,6,13),(32,14,8,0),(32,14,11,13),(32,14,21,4),(32,15,0,11),(32,15,8,5),(32,15,13,3),(32,16,3,3),(32,16,5,2),(32,16,13,11),(32,16,23,6),(32,17,2,10),(32,17,4,7),(32,17,5,1),(32,17,12,11),(32,18,3,2),(32,18,4,12),(32,18,7,10),(32,18,8,3),(32,18,10,3),(32,18,20,10),(32,19,1,3),(32,19,4,9),(32,19,8,3),(32,19,15,8),(32,19,19,6),(32,19,20,3),(32,19,22,1),(32,20,3,3),(32,20,9,5),(32,20,19,12),(32,20,21,3),(32,20,23,7),(32,21,4,11),(32,21,5,6),(32,21,6,8),(32,21,14,8),(32,21,15,13),(32,21,20,5),(32,21,21,7),(32,22,6,2),(32,22,14,8),(32,22,25,12),(32,23,7,12),(32,23,10,11),(32,23,13,10),(32,23,17,4),(32,23,23,9),(32,24,14,5),(32,24,16,2),(32,25,4,1),(32,25,11,1),(32,25,14,4),(32,25,26,10),(32,26,3,9),(32,26,4,0),(32,26,24,9),(32,27,0,12),(32,27,1,12),(32,27,3,1),(32,27,4,12),(32,27,15,0),(32,27,26,1),(32,28,17,12),(32,29,0,12),(32,29,14,3),(32,29,15,12),(32,29,23,10),(32,29,27,13),(32,29,28,1),(32,29,29,10),(33,0,8,6),(33,0,11,11),(33,0,12,5),(33,0,16,10),(33,0,21,6),(33,0,23,10),(33,0,26,10),(33,1,2,3),(33,1,6,10),(33,1,10,10),(33,1,20,2),(33,1,21,10),(33,1,22,13),(33,2,1,0),(33,2,3,5),(33,2,4,2),(33,2,5,12),(33,2,6,6),(33,2,8,7),(33,2,12,11),(33,2,14,9),(33,2,19,0),(33,2,20,13),(33,2,21,13),(33,2,23,2),(33,2,25,12),(33,3,4,12),(33,3,8,7),(33,3,19,12),(33,3,22,7),(33,3,26,11),(33,4,1,10),(33,4,6,5),(33,4,7,0),(33,4,20,12),(33,4,24,5),(33,5,21,9),(33,6,5,0),(33,6,8,5),(33,6,9,10),(33,6,13,4),(33,6,22,5),(33,6,23,0),(33,7,2,13),(33,7,5,11),(33,7,7,7),(33,7,11,8),(33,7,23,3),(33,8,2,2),(33,8,3,1),(33,8,5,3),(33,8,22,8),(33,8,23,8),(33,9,3,3),(33,9,6,7),(33,9,7,7),(33,9,8,13),(33,9,11,11),(33,10,0,6),(33,10,7,1),(33,10,8,9),(33,10,9,0),(33,10,10,6),(33,10,11,3),(33,10,13,11),(33,10,20,0),(33,10,21,5),(33,11,1,13),(33,11,4,0),(33,11,7,6),(33,12,7,10),(33,12,19,11),(33,12,20,12),(33,12,21,8),(33,12,27,7),(33,13,6,2),(33,13,9,11),(33,13,19,8),(33,14,9,8),(33,14,20,9),(33,14,27,9),(33,15,5,7),(33,15,6,12),(33,15,16,7),(33,16,3,6),(33,16,9,13),(33,16,25,9),(33,16,26,2),(33,17,13,6),(33,17,19,0),(33,17,20,1),(33,17,23,12),(33,18,0,5),(33,18,1,7),(33,18,19,12),(33,18,21,9),(33,18,27,6),(33,19,1,1),(33,19,12,4),(33,19,13,9),(33,19,14,9),(33,19,22,13),(33,20,1,8),(33,20,7,7),(33,20,15,2),(33,20,18,3),(33,20,25,2),(33,20,26,9),(33,21,5,10),(33,21,12,8),(33,21,13,9),(33,22,2,7),(33,22,3,5),(33,22,19,1),(33,22,23,7),(33,22,25,2),(33,23,10,7),(33,23,15,9),(33,23,16,10),(33,23,19,11),(33,23,27,0),(33,24,4,5),(33,24,12,10),(33,24,16,11),(33,24,21,12),(33,24,22,7),(33,24,24,5),(33,25,1,0),(33,25,21,8),(33,25,23,1),(33,26,2,13),(33,26,5,13),(33,26,17,1),(33,26,22,5),(33,26,25,5),(33,27,0,9),(33,27,2,13),(33,27,3,10),(33,27,18,3),(33,28,0,11),(33,28,15,3),(33,28,17,12),(33,29,0,11),(33,29,1,11),(33,29,2,11),(33,29,16,10),(33,29,21,10),(33,29,27,2),(33,30,16,7),(33,30,19,9),(33,31,10,9),(33,31,18,2),(33,32,6,5),(33,32,21,2),(33,32,26,0),(33,33,10,11),(33,33,13,10),(33,33,23,12),(33,33,27,3),(33,34,1,2),(33,34,17,4),(33,34,19,0),(33,34,20,11),(33,34,22,7),(33,34,23,10),(33,35,5,3),(33,35,8,7),(33,35,13,11),(33,35,14,3),(33,35,23,7),(33,35,26,0),(33,35,27,4),(33,36,6,0),(33,36,8,8),(33,36,13,5),(33,36,22,12),(33,38,14,3),(33,38,19,4),(33,39,12,12),(33,42,2,0),(33,43,1,0),(33,43,3,6),(33,43,16,8),(33,44,0,0),(33,44,16,8),(33,47,2,11),(33,47,9,2),(33,47,14,6),(33,48,1,2),(33,48,10,9),(33,49,1,8),(33,49,9,13),(33,49,10,2),(33,49,11,4),(33,49,14,8),(33,49,17,9),(33,51,0,11),(33,51,8,5),(33,51,9,5),(33,51,12,13),(33,52,1,4),(33,52,11,7),(33,52,22,1),(33,53,0,12),(33,53,5,7),(33,53,9,8),(33,53,10,2),(33,53,12,1),(33,53,13,13),(33,53,15,6),(33,53,16,5),(33,53,17,11),(33,53,19,5),(33,53,22,11),(33,53,23,10),(33,53,24,1),(33,53,25,6),(33,53,27,5),(38,0,2,11),(38,0,16,11),(38,0,18,13),(38,0,22,7),(38,0,24,13),(38,1,2,5),(38,1,15,2),(38,1,16,3),(38,2,24,7),(38,3,1,9),(38,3,4,10),(38,3,20,12),(38,4,2,6),(38,4,4,1),(38,4,6,9),(38,4,10,7),(38,5,0,2),(38,5,1,9),(38,6,10,13),(38,6,11,10),(38,6,20,3),(38,6,25,1),(38,7,0,4),(38,7,4,10),(38,7,11,3),(38,7,13,7),(38,7,23,9),(38,8,0,10),(38,8,14,0),(38,8,19,9),(38,8,22,12),(38,8,23,9),(38,8,24,8),(38,9,10,4),(38,9,12,7),(38,9,21,10),(38,9,25,3),(38,10,2,13),(38,10,11,11),(38,10,12,13),(38,10,17,6),(38,11,8,11),(38,11,12,2),(38,11,18,7),(38,12,0,10),(38,12,5,1),(38,12,15,7),(38,12,16,7),(38,12,18,5),(38,12,19,1),(38,12,22,2),(38,12,24,5),(38,13,0,11),(38,13,18,1),(38,13,19,8),(38,13,23,7),(38,14,5,8),(38,14,15,11),(38,14,19,2),(38,14,20,10),(38,14,21,7),(38,14,24,0),(38,15,5,7),(38,15,14,1),(38,16,4,7),(38,16,8,13),(38,16,21,2),(38,16,25,3),(38,17,1,1),(38,17,6,10),(38,17,21,4),(38,17,24,12),(38,18,4,12),(38,18,12,2),(38,18,25,13),(38,19,0,13),(38,19,2,12),(38,19,16,13),(38,20,0,3),(38,20,9,6),(38,20,11,3),(38,20,25,8),(38,21,9,7),(38,22,5,4),(38,22,25,5),(38,23,25,3),(38,24,6,10),(38,24,11,13),(38,25,5,3),(38,25,6,0),(38,25,7,11),(38,26,6,3),(38,26,7,3),(38,26,9,8),(38,27,7,12),(38,27,11,13),(38,27,25,6),(38,28,9,11),(38,28,12,2),(38,28,14,5),(38,29,3,3),(38,29,8,12),(38,29,16,9),(38,30,1,7),(38,31,8,13),(38,31,9,2),(38,31,14,5),(38,31,23,12),(38,31,25,12),(38,32,0,1),(38,32,7,2),(38,33,4,7),(38,33,5,8),(38,34,3,3),(38,34,6,11),(38,35,3,9),(38,35,23,12),(38,36,1,9),(38,36,16,1),(38,37,12,5),(38,38,8,11),(38,40,6,8),(38,40,10,7),(38,40,17,12),(38,41,15,0),(38,41,19,9),(38,41,24,4),(38,42,0,1),(38,42,11,13),(38,42,16,6),(38,42,18,12),(38,42,21,3),(38,42,22,2),(38,42,23,13),(38,42,25,2),(38,43,1,11),(38,43,15,8),(38,43,21,4),(38,44,0,12),(38,44,19,6),(38,44,22,10),(38,44,25,4),(38,45,0,2),(38,45,25,4),(38,46,16,6),(38,47,15,0),(38,48,4,7),(38,48,25,11),(38,49,25,13),(38,51,8,8);
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
INSERT INTO `fow_ss_entries` VALUES (1,4,1,2,1,0,0,0,NULL,NULL,NULL,NULL,NULL),(2,1,1,1,0,0,0,0,NULL,NULL,NULL,NULL,NULL),(3,2,1,1,0,0,0,0,NULL,NULL,NULL,NULL,NULL),(4,3,1,1,0,0,0,0,NULL,NULL,NULL,NULL,NULL);
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
INSERT INTO `galaxies` VALUES (1,'2010-10-08 09:36:20','dev');
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
INSERT INTO `notifications` VALUES (1,1,'2010-10-08 09:36:26','2010-10-22 09:36:26',3,'--- \n:id: 1\n',0,0),(2,1,'2010-10-08 09:36:26','2010-10-22 09:36:26',3,'--- \n:id: 2\n',0,0);
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
) ENGINE=InnoDB AUTO_INCREMENT=39 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `planets`
--

LOCK TABLES `planets` WRITE;
/*!40000 ALTER TABLE `planets` DISABLE KEYS */;
INSERT INTO `planets` VALUES (1,1,NULL,NULL,0,180,1,'Resource',NULL,'G1-S1-P1',56,361,288,271),(2,1,NULL,NULL,1,180,3,'Resource',NULL,'G1-S1-P2',40,239,144,386),(3,1,NULL,NULL,3,292,4,'Mining',NULL,'G1-S1-P3',50,168,239,162),(4,1,NULL,NULL,5,315,5,'Mining',NULL,'G1-S1-P4',29,299,250,318),(5,1,NULL,NULL,8,100,5,'Resource',NULL,'G1-S1-P5',56,141,365,168),(6,1,NULL,NULL,9,342,4,'Resource',NULL,'G1-S1-P6',54,280,177,332),(7,1,NULL,NULL,10,244,1,'Jumpgate',NULL,'G1-S1-P7',51,NULL,NULL,NULL),(8,1,NULL,NULL,11,243,2,'Mining',NULL,'G1-S1-P8',34,216,314,325),(9,1,NULL,NULL,12,96,1,'Jumpgate',NULL,'G1-S1-P9',34,NULL,NULL,NULL),(10,1,NULL,NULL,13,138,0,'Jumpgate',NULL,'G1-S1-P10',42,NULL,NULL,NULL),(11,1,NULL,NULL,14,342,0,'Npc',NULL,'G1-S1-P11',34,NULL,NULL,NULL),(12,1,50,23,15,235,5,'Regular',NULL,'G1-S1-P12',58,NULL,NULL,NULL),(13,1,NULL,NULL,16,235,4,'Resource',NULL,'G1-S1-P13',48,343,283,283),(14,1,43,26,17,25,7,'Regular',NULL,'G1-S1-P14',55,NULL,NULL,NULL),(15,1,NULL,NULL,18,126,2,'Jumpgate',NULL,'G1-S1-P15',25,NULL,NULL,NULL),(16,2,NULL,NULL,0,270,1,'Jumpgate',NULL,'G1-S2-P16',46,NULL,NULL,NULL),(17,2,NULL,NULL,1,90,2,'Jumpgate',NULL,'G1-S2-P17',32,NULL,NULL,NULL),(18,2,36,23,2,300,4,'Regular',NULL,'G1-S2-P18',47,NULL,NULL,NULL),(19,2,NULL,NULL,3,224,1,'Mining',NULL,'G1-S2-P19',48,186,392,371),(20,2,42,18,4,342,7,'Regular',NULL,'G1-S2-P20',48,NULL,NULL,NULL),(21,2,NULL,NULL,5,315,3,'Mining',NULL,'G1-S2-P21',59,231,266,188),(22,2,NULL,NULL,7,134,0,'Jumpgate',NULL,'G1-S2-P22',36,NULL,NULL,NULL),(23,3,NULL,NULL,0,180,2,'Mining',NULL,'G1-S3-P23',42,349,117,171),(24,3,NULL,NULL,1,180,0,'Jumpgate',NULL,'G1-S3-P24',33,NULL,NULL,NULL),(25,3,NULL,NULL,2,180,0,'Jumpgate',NULL,'G1-S3-P25',35,NULL,NULL,NULL),(26,3,NULL,NULL,3,0,0,'Jumpgate',NULL,'G1-S3-P26',38,NULL,NULL,NULL),(27,3,39,23,4,234,0,'Regular',NULL,'G1-S3-P27',49,NULL,NULL,NULL),(28,3,48,15,5,195,7,'Regular',NULL,'G1-S3-P28',50,NULL,NULL,NULL),(29,3,45,23,6,138,6,'Regular',NULL,'G1-S3-P29',54,NULL,NULL,NULL),(30,3,52,26,7,281,8,'Regular',NULL,'G1-S3-P30',62,NULL,NULL,NULL),(31,3,NULL,NULL,8,50,2,'Mining',NULL,'G1-S3-P31',44,210,118,283),(32,4,30,30,0,90,0,'Homeworld',1,'G1-S4-P32',40,NULL,NULL,NULL),(33,4,54,28,1,90,7,'Regular',NULL,'G1-S4-P33',65,NULL,NULL,NULL),(34,4,NULL,NULL,2,30,5,'Mining',NULL,'G1-S4-P34',56,343,317,132),(35,4,NULL,NULL,3,0,2,'Mining',NULL,'G1-S4-P35',59,398,283,185),(36,4,NULL,NULL,4,72,0,'Npc',NULL,'G1-S4-P36',42,NULL,NULL,NULL),(37,4,NULL,NULL,5,195,0,'Jumpgate',NULL,'G1-S4-P37',44,NULL,NULL,NULL),(38,4,52,26,6,342,1,'Regular',NULL,'G1-S4-P38',62,NULL,NULL,NULL);
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
) ENGINE=InnoDB AUTO_INCREMENT=39 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `resources_entries`
--

LOCK TABLES `resources_entries` WRITE;
/*!40000 ALTER TABLE `resources_entries` DISABLE KEYS */;
INSERT INTO `resources_entries` VALUES (1,0,0,0,0,0,0,0,0,0,NULL,0),(2,0,0,0,0,0,0,0,0,0,NULL,0),(3,0,0,0,0,0,0,0,0,0,NULL,0),(4,0,0,0,0,0,0,0,0,0,NULL,0),(5,0,0,0,0,0,0,0,0,0,NULL,0),(6,0,0,0,0,0,0,0,0,0,NULL,0),(7,0,0,0,0,0,0,0,0,0,NULL,0),(8,0,0,0,0,0,0,0,0,0,NULL,0),(9,0,0,0,0,0,0,0,0,0,NULL,0),(10,0,0,0,0,0,0,0,0,0,NULL,0),(11,0,0,0,0,0,0,0,0,0,NULL,0),(12,0,0,0,0,0,0,0,0,0,NULL,0),(13,0,0,0,0,0,0,0,0,0,NULL,0),(14,0,0,0,0,0,0,0,0,0,NULL,0),(15,0,0,0,0,0,0,0,0,0,NULL,0),(16,0,0,0,0,0,0,0,0,0,NULL,0),(17,0,0,0,0,0,0,0,0,0,NULL,0),(18,0,0,0,0,0,0,0,0,0,NULL,0),(19,0,0,0,0,0,0,0,0,0,NULL,0),(20,0,0,0,0,0,0,0,0,0,NULL,0),(21,0,0,0,0,0,0,0,0,0,NULL,0),(22,0,0,0,0,0,0,0,0,0,NULL,0),(23,0,0,0,0,0,0,0,0,0,NULL,0),(24,0,0,0,0,0,0,0,0,0,NULL,0),(25,0,0,0,0,0,0,0,0,0,NULL,0),(26,0,0,0,0,0,0,0,0,0,NULL,0),(27,0,0,0,0,0,0,0,0,0,NULL,0),(28,0,0,0,0,0,0,0,0,0,NULL,0),(29,0,0,0,0,0,0,0,0,0,NULL,0),(30,0,0,0,0,0,0,0,0,0,NULL,0),(31,0,0,0,0,0,0,0,0,0,NULL,0),(32,864,3024,1728,6048,0,604.8,50,100,0,'2010-10-08 09:36:24',0),(33,0,0,0,0,0,0,0,0,0,NULL,0),(34,0,0,0,0,0,0,0,0,0,NULL,0),(35,0,0,0,0,0,0,0,0,0,NULL,0),(36,0,0,0,0,0,0,0,0,0,NULL,0),(37,0,0,0,0,0,0,0,0,0,NULL,0),(38,0,0,0,0,0,0,0,0,0,NULL,0);
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
INSERT INTO `solar_systems` VALUES (1,'Resource',1,-1,-1),(2,'Expansion',1,0,-2),(3,'Expansion',1,2,-3),(4,'Homeworld',1,0,0);
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
) ENGINE=InnoDB AUTO_INCREMENT=3833 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tiles`
--

LOCK TABLES `tiles` WRITE;
/*!40000 ALTER TABLE `tiles` DISABLE KEYS */;
INSERT INTO `tiles` VALUES (1,4,12,4,0),(2,4,12,5,0),(3,4,12,6,0),(4,4,12,7,0),(5,4,12,8,0),(6,4,12,9,0),(7,4,12,10,0),(8,4,12,11,0),(9,4,12,12,0),(10,0,12,26,0),(11,3,12,33,0),(12,3,12,34,0),(13,3,12,35,0),(14,3,12,36,0),(15,3,12,37,0),(16,3,12,38,0),(17,3,12,39,0),(18,5,12,43,0),(19,5,12,44,0),(20,5,12,45,0),(21,5,12,46,0),(22,5,12,47,0),(23,5,12,48,0),(24,5,12,49,0),(25,4,12,4,1),(26,4,12,5,1),(27,4,12,6,1),(28,4,12,8,1),(29,4,12,9,1),(30,4,12,10,1),(31,4,12,12,1),(32,3,12,34,1),(33,3,12,35,1),(34,3,12,36,1),(35,5,12,45,1),(36,5,12,46,1),(37,5,12,47,1),(38,5,12,48,1),(39,5,12,49,1),(40,4,12,6,2),(41,4,12,7,2),(42,4,12,8,2),(43,4,12,9,2),(44,4,12,10,2),(45,4,12,11,2),(46,4,12,12,2),(47,4,12,13,2),(48,5,12,17,2),(49,5,12,18,2),(50,3,12,32,2),(51,3,12,33,2),(52,3,12,34,2),(53,3,12,35,2),(54,3,12,36,2),(55,3,12,37,2),(56,3,12,38,2),(57,5,12,45,2),(58,5,12,48,2),(59,5,12,49,2),(60,14,12,7,3),(61,4,12,10,3),(62,4,12,11,3),(63,4,12,12,3),(64,4,12,13,3),(65,5,12,15,3),(66,5,12,16,3),(67,5,12,17,3),(68,5,12,18,3),(69,5,12,19,3),(70,3,12,35,3),(71,3,12,36,3),(72,3,12,37,3),(73,14,12,42,3),(74,5,12,48,3),(75,4,12,10,4),(76,4,12,11,4),(77,6,12,12,4),(78,5,12,18,4),(79,5,12,19,4),(80,5,12,20,4),(81,5,12,23,4),(82,12,12,26,4),(83,3,12,35,4),(84,3,12,36,4),(85,6,12,12,5),(86,5,12,17,5),(87,5,12,18,5),(88,5,12,19,5),(89,5,12,20,5),(90,5,12,21,5),(91,5,12,22,5),(92,5,12,23,5),(93,10,12,37,5),(94,6,12,12,6),(95,5,12,17,6),(96,5,12,18,6),(97,5,12,19,6),(98,5,12,20,6),(99,5,12,21,6),(100,5,12,23,6),(101,3,12,35,6),(102,9,12,5,7),(103,6,12,11,7),(104,6,12,12,7),(105,5,12,18,7),(106,5,12,19,7),(107,5,12,20,7),(108,5,12,21,7),(109,5,12,22,7),(110,3,12,34,7),(111,3,12,35,7),(112,3,12,36,7),(113,6,12,12,8),(114,5,12,19,8),(115,3,12,34,8),(116,3,12,35,8),(117,3,12,36,8),(118,4,12,45,8),(119,6,12,12,9),(120,3,12,32,9),(121,3,12,33,9),(122,3,12,34,9),(123,3,12,35,9),(124,10,12,40,9),(125,4,12,45,9),(126,7,12,8,10),(127,1,12,17,10),(128,0,12,28,10),(129,3,12,33,10),(130,3,12,34,10),(131,3,12,35,10),(132,3,12,36,10),(133,4,12,44,10),(134,4,12,45,10),(135,0,12,46,10),(136,0,12,0,11),(137,7,12,7,11),(138,7,12,8,11),(139,7,12,9,11),(140,7,12,10,11),(141,3,12,34,11),(142,3,12,35,11),(143,3,12,36,11),(144,4,12,44,11),(145,4,12,45,11),(146,4,12,48,11),(147,7,12,6,12),(148,7,12,7,12),(149,7,12,8,12),(150,7,12,9,12),(151,7,12,10,12),(152,6,12,15,12),(153,6,12,26,12),(154,3,12,34,12),(155,4,12,44,12),(156,4,12,45,12),(157,4,12,46,12),(158,4,12,47,12),(159,4,12,48,12),(160,4,12,49,12),(161,11,12,4,13),(162,7,12,8,13),(163,7,12,9,13),(164,7,12,10,13),(165,7,12,11,13),(166,7,12,12,13),(167,6,12,15,13),(168,6,12,16,13),(169,6,12,24,13),(170,6,12,25,13),(171,6,12,26,13),(172,3,12,32,13),(173,3,12,33,13),(174,3,12,34,13),(175,3,12,35,13),(176,6,12,39,13),(177,6,12,40,13),(178,6,12,41,13),(179,4,12,44,13),(180,4,12,45,13),(181,4,12,46,13),(182,4,12,47,13),(183,4,12,48,13),(184,4,12,49,13),(185,7,12,9,14),(186,6,12,13,14),(187,6,12,14,14),(188,6,12,15,14),(189,6,12,16,14),(190,6,12,24,14),(191,6,12,25,14),(192,6,12,26,14),(193,12,12,27,14),(194,3,12,34,14),(195,3,12,35,14),(196,0,12,36,14),(197,6,12,40,14),(198,0,12,42,14),(199,4,12,44,14),(200,4,12,45,14),(201,4,12,46,14),(202,4,12,49,14),(203,0,12,15,15),(204,7,12,24,15),(205,3,12,35,15),(206,4,12,45,15),(207,4,12,46,15),(208,4,12,47,15),(209,4,12,2,16),(210,7,12,23,16),(211,7,12,24,16),(212,7,12,25,16),(213,3,12,34,16),(214,3,12,35,16),(215,3,12,36,16),(216,3,12,37,16),(217,4,12,46,16),(218,4,12,47,16),(219,4,12,48,16),(220,4,12,49,16),(221,4,12,2,17),(222,4,12,3,17),(223,7,12,22,17),(224,7,12,23,17),(225,7,12,24,17),(226,7,12,25,17),(227,3,12,35,17),(228,3,12,36,17),(229,3,12,37,17),(230,4,12,46,17),(231,7,12,47,17),(232,7,12,48,17),(233,7,12,49,17),(234,4,12,0,18),(235,4,12,1,18),(236,4,12,2,18),(237,4,12,3,18),(238,7,12,22,18),(239,7,12,23,18),(240,7,12,24,18),(241,7,12,25,18),(242,3,12,34,18),(243,3,12,35,18),(244,3,12,36,18),(245,3,12,37,18),(246,5,12,45,18),(247,5,12,46,18),(248,5,12,47,18),(249,7,12,48,18),(250,7,12,49,18),(251,4,12,0,19),(252,4,12,1,19),(253,4,12,2,19),(254,4,12,3,19),(255,4,12,4,19),(256,4,12,5,19),(257,4,12,6,19),(258,4,12,7,19),(259,6,12,12,19),(260,8,12,20,19),(261,7,12,23,19),(262,8,12,24,19),(263,3,12,33,19),(264,3,12,34,19),(265,3,12,35,19),(266,3,12,36,19),(267,3,12,37,19),(268,3,12,38,19),(269,3,12,39,19),(270,13,12,40,19),(271,5,12,46,19),(272,5,12,47,19),(273,7,12,48,19),(274,7,12,49,19),(275,4,12,0,20),(276,4,12,1,20),(277,4,12,2,20),(278,4,12,3,20),(279,4,12,4,20),(280,4,12,5,20),(281,2,12,9,20),(282,6,12,11,20),(283,6,12,12,20),(284,7,12,17,20),(285,7,12,23,20),(286,3,12,32,20),(287,3,12,33,20),(288,3,12,34,20),(289,3,12,35,20),(290,3,12,36,20),(291,3,12,37,20),(292,3,12,38,20),(293,3,12,39,20),(294,5,12,46,20),(295,0,12,47,20),(296,7,12,49,20),(297,4,12,0,21),(298,4,12,1,21),(299,4,12,2,21),(300,4,12,3,21),(301,4,12,4,21),(302,4,12,5,21),(303,6,12,11,21),(304,6,12,12,21),(305,7,12,17,21),(306,7,12,18,21),(307,7,12,19,21),(308,7,12,23,21),(309,3,12,32,21),(310,3,12,35,21),(311,3,12,36,21),(312,3,12,38,21),(313,3,12,39,21),(314,3,12,40,21),(315,5,12,41,21),(316,5,12,42,21),(317,5,12,43,21),(318,5,12,44,21),(319,5,12,45,21),(320,5,12,46,21),(321,7,12,49,21),(322,4,12,0,22),(323,4,12,1,22),(324,4,12,2,22),(325,4,12,3,22),(326,6,12,10,22),(327,6,12,11,22),(328,7,12,19,22),(329,7,12,20,22),(330,7,12,21,22),(331,7,12,22,22),(332,7,12,23,22),(333,7,12,24,22),(334,7,12,25,22),(335,7,12,26,22),(336,7,12,27,22),(337,3,12,37,22),(338,3,12,38,22),(339,3,12,39,22),(340,3,12,40,22),(341,3,12,41,22),(342,3,12,42,22),(343,5,12,43,22),(344,5,12,44,22),(345,5,12,45,22),(346,5,12,46,22),(347,7,12,47,22),(348,7,12,48,22),(349,7,12,49,22),(350,3,14,0,0),(351,3,14,1,0),(352,3,14,2,0),(353,3,14,3,0),(354,5,14,29,0),(355,5,14,31,0),(356,3,14,0,1),(357,14,14,1,1),(358,5,14,28,1),(359,5,14,29,1),(360,5,14,30,1),(361,5,14,31,1),(362,3,14,0,2),(363,8,14,10,2),(364,9,14,15,2),(365,3,14,19,2),(366,3,14,20,2),(367,3,14,21,2),(368,5,14,29,2),(369,5,14,30,2),(370,5,14,41,2),(371,5,14,42,2),(372,3,14,0,3),(373,3,14,4,3),(374,0,14,8,3),(375,3,14,19,3),(376,3,14,20,3),(377,3,14,21,3),(378,3,14,22,3),(379,3,14,23,3),(380,5,14,29,3),(381,5,14,30,3),(382,5,14,31,3),(383,5,14,41,3),(384,5,14,42,3),(385,3,14,0,4),(386,3,14,4,4),(387,3,14,19,4),(388,3,14,20,4),(389,3,14,21,4),(390,5,14,28,4),(391,5,14,29,4),(392,5,14,30,4),(393,5,14,31,4),(394,5,14,40,4),(395,5,14,42,4),(396,3,14,0,5),(397,3,14,1,5),(398,3,14,2,5),(399,3,14,3,5),(400,3,14,4,5),(401,3,14,18,5),(402,3,14,19,5),(403,3,14,20,5),(404,3,14,21,5),(405,5,14,31,5),(406,10,14,32,5),(407,5,14,40,5),(408,5,14,41,5),(409,5,14,42,5),(410,3,14,0,6),(411,3,14,1,6),(412,0,14,4,6),(413,3,14,12,6),(414,5,14,15,6),(415,3,14,17,6),(416,3,14,18,6),(417,3,14,19,6),(418,3,14,20,6),(419,4,14,37,6),(420,4,14,39,6),(421,4,14,40,6),(422,5,14,41,6),(423,5,14,42,6),(424,3,14,0,7),(425,2,14,9,7),(426,3,14,12,7),(427,5,14,15,7),(428,12,14,25,7),(429,4,14,37,7),(430,4,14,39,7),(431,4,14,40,7),(432,4,14,41,7),(433,5,14,42,7),(434,3,14,12,8),(435,3,14,13,8),(436,5,14,14,8),(437,5,14,15,8),(438,4,14,36,8),(439,4,14,37,8),(440,4,14,38,8),(441,4,14,39,8),(442,4,14,40,8),(443,4,14,41,8),(444,5,14,42,8),(445,3,14,11,9),(446,3,14,12,9),(447,3,14,13,9),(448,5,14,14,9),(449,5,14,15,9),(450,5,14,16,9),(451,4,14,23,9),(452,6,14,36,9),(453,6,14,37,9),(454,6,14,38,9),(455,6,14,39,9),(456,4,14,40,9),(457,4,14,41,9),(458,5,14,42,9),(459,4,14,7,10),(460,4,14,8,10),(461,3,14,12,10),(462,5,14,13,10),(463,5,14,14,10),(464,5,14,15,10),(465,5,14,16,10),(466,5,14,17,10),(467,5,14,18,10),(468,4,14,22,10),(469,4,14,23,10),(470,4,14,24,10),(471,6,14,33,10),(472,6,14,34,10),(473,6,14,36,10),(474,6,14,37,10),(475,6,14,38,10),(476,6,14,39,10),(477,4,14,40,10),(478,5,14,41,10),(479,5,14,42,10),(480,4,14,7,11),(481,4,14,8,11),(482,3,14,11,11),(483,3,14,12,11),(484,5,14,14,11),(485,5,14,15,11),(486,5,14,16,11),(487,4,14,21,11),(488,4,14,22,11),(489,4,14,23,11),(490,6,14,31,11),(491,6,14,32,11),(492,6,14,33,11),(493,6,14,34,11),(494,6,14,39,11),(495,3,14,41,11),(496,3,14,42,11),(497,4,14,8,12),(498,4,14,9,12),(499,4,14,10,12),(500,3,14,11,12),(501,3,14,12,12),(502,3,14,13,12),(503,4,14,23,12),(504,6,14,33,12),(505,6,14,34,12),(506,6,14,35,12),(507,6,14,39,12),(508,3,14,42,12),(509,4,14,6,13),(510,4,14,7,13),(511,4,14,8,13),(512,4,14,9,13),(513,4,14,10,13),(514,3,14,11,13),(515,3,14,12,13),(516,4,14,21,13),(517,4,14,22,13),(518,4,14,23,13),(519,4,14,24,13),(520,4,14,25,13),(521,6,14,27,13),(522,6,14,28,13),(523,6,14,29,13),(524,3,14,42,13),(525,13,14,1,14),(526,4,14,9,14),(527,3,14,11,14),(528,3,14,12,14),(529,5,14,16,14),(530,4,14,25,14),(531,6,14,28,14),(532,6,14,29,14),(533,2,14,30,14),(534,7,14,34,14),(535,7,14,35,14),(536,7,14,36,14),(537,7,14,37,14),(538,3,14,42,14),(539,3,14,11,15),(540,3,14,12,15),(541,5,14,13,15),(542,5,14,14,15),(543,5,14,16,15),(544,5,14,17,15),(545,0,14,21,15),(546,4,14,25,15),(547,6,14,27,15),(548,6,14,28,15),(549,6,14,29,15),(550,0,14,34,15),(551,7,14,36,15),(552,7,14,37,15),(553,7,14,38,15),(554,3,14,40,15),(555,3,14,41,15),(556,3,14,42,15),(557,5,14,11,16),(558,5,14,12,16),(559,5,14,13,16),(560,5,14,14,16),(561,5,14,15,16),(562,5,14,16,16),(563,4,14,25,16),(564,6,14,29,16),(565,11,14,30,16),(566,7,14,36,16),(567,7,14,37,16),(568,3,14,38,16),(569,3,14,39,16),(570,3,14,40,16),(571,3,14,41,16),(572,3,14,42,16),(573,5,14,10,17),(574,5,14,11,17),(575,5,14,12,17),(576,5,14,13,17),(577,11,14,14,17),(578,7,14,20,17),(579,7,14,23,17),(580,7,14,24,17),(581,6,14,29,17),(582,7,14,34,17),(583,7,14,35,17),(584,7,14,36,17),(585,7,14,37,17),(586,3,14,40,17),(587,3,14,41,17),(588,3,14,42,17),(589,1,14,10,18),(590,5,14,12,18),(591,7,14,20,18),(592,7,14,21,18),(593,7,14,22,18),(594,7,14,23,18),(595,7,14,24,18),(596,7,14,34,18),(597,7,14,35,18),(598,7,14,37,18),(599,14,14,39,18),(600,3,14,42,18),(601,8,14,2,19),(602,7,14,19,19),(603,7,14,20,19),(604,7,14,21,19),(605,7,14,22,19),(606,7,14,23,19),(607,7,14,34,19),(608,3,14,42,19),(609,6,14,8,20),(610,7,14,19,20),(611,7,14,20,20),(612,7,14,21,20),(613,7,14,23,20),(614,7,14,24,20),(615,0,14,28,20),(616,3,14,42,20),(617,6,14,7,21),(618,6,14,8,21),(619,6,14,9,21),(620,6,14,20,21),(621,6,14,21,21),(622,6,14,22,21),(623,4,14,27,21),(624,6,14,8,22),(625,6,14,9,22),(626,6,14,10,22),(627,3,14,13,22),(628,6,14,20,22),(629,6,14,21,22),(630,4,14,25,22),(631,4,14,26,22),(632,4,14,27,22),(633,4,14,28,22),(634,5,14,38,22),(635,5,14,39,22),(636,5,14,40,22),(637,0,14,5,23),(638,6,14,7,23),(639,6,14,8,23),(640,6,14,9,23),(641,3,14,13,23),(642,3,14,14,23),(643,3,14,15,23),(644,3,14,16,23),(645,3,14,17,23),(646,3,14,19,23),(647,6,14,20,23),(648,6,14,21,23),(649,6,14,22,23),(650,0,14,23,23),(651,4,14,25,23),(652,4,14,26,23),(653,4,14,27,23),(654,0,14,32,23),(655,5,14,37,23),(656,5,14,38,23),(657,5,14,39,23),(658,3,14,13,24),(659,3,14,14,24),(660,3,14,15,24),(661,3,14,16,24),(662,3,14,17,24),(663,3,14,18,24),(664,3,14,19,24),(665,6,14,21,24),(666,6,14,22,24),(667,4,14,25,24),(668,4,14,26,24),(669,5,14,38,24),(670,5,14,39,24),(671,5,14,40,24),(672,5,14,41,24),(673,3,14,13,25),(674,3,14,14,25),(675,3,14,15,25),(676,3,14,17,25),(677,3,14,18,25),(678,4,14,21,25),(679,4,14,22,25),(680,4,14,23,25),(681,4,14,24,25),(682,4,14,25,25),(683,4,14,26,25),(684,5,14,38,25),(685,5,14,39,25),(686,5,14,40,25),(687,5,14,41,25),(688,5,14,42,25),(689,12,18,4,0),(690,3,18,14,0),(691,3,18,15,0),(692,4,18,21,0),(693,4,18,22,0),(694,4,18,23,0),(695,1,18,24,0),(696,0,18,26,0),(697,4,18,28,0),(698,4,18,29,0),(699,7,18,30,0),(700,7,18,31,0),(701,7,18,32,0),(702,7,18,33,0),(703,7,18,34,0),(704,7,18,35,0),(705,3,18,14,1),(706,3,18,15,1),(707,4,18,18,1),(708,4,18,20,1),(709,4,18,21,1),(710,4,18,22,1),(711,4,18,28,1),(712,4,18,30,1),(713,8,18,31,1),(714,7,18,34,1),(715,7,18,35,1),(716,3,18,14,2),(717,4,18,18,2),(718,4,18,19,2),(719,4,18,21,2),(720,4,18,22,2),(721,4,18,25,2),(722,4,18,26,2),(723,4,18,27,2),(724,4,18,28,2),(725,4,18,29,2),(726,4,18,30,2),(727,7,18,34,2),(728,7,18,35,2),(729,3,18,14,3),(730,3,18,15,3),(731,4,18,17,3),(732,4,18,18,3),(733,4,18,19,3),(734,4,18,20,3),(735,4,18,21,3),(736,4,18,22,3),(737,0,18,25,3),(738,4,18,27,3),(739,4,18,28,3),(740,4,18,29,3),(741,4,18,30,3),(742,7,18,34,3),(743,7,18,35,3),(744,14,18,1,4),(745,5,18,10,4),(746,0,18,12,4),(747,3,18,14,4),(748,3,18,15,4),(749,4,18,16,4),(750,4,18,17,4),(751,4,18,18,4),(752,4,18,19,4),(753,4,18,20,4),(754,4,18,27,4),(755,4,18,28,4),(756,4,18,29,4),(757,4,18,30,4),(758,4,18,31,4),(759,7,18,33,4),(760,7,18,34,4),(761,7,18,35,4),(762,5,18,10,5),(763,3,18,14,5),(764,3,18,15,5),(765,4,18,16,5),(766,4,18,17,5),(767,4,18,18,5),(768,13,18,24,5),(769,4,18,30,5),(770,4,18,31,5),(771,7,18,33,5),(772,7,18,35,5),(773,5,18,10,6),(774,5,18,11,6),(775,5,18,12,6),(776,5,18,13,6),(777,3,18,14,6),(778,4,18,15,6),(779,4,18,16,6),(780,4,18,17,6),(781,4,18,18,6),(782,4,18,30,6),(783,4,18,31,6),(784,4,18,32,6),(785,7,18,33,6),(786,7,18,34,6),(787,7,18,35,6),(788,5,18,9,7),(789,5,18,10,7),(790,5,18,11,7),(791,5,18,17,7),(792,5,18,18,7),(793,4,18,28,7),(794,4,18,29,7),(795,4,18,30,7),(796,4,18,31,7),(797,4,18,32,7),(798,5,18,11,8),(799,5,18,12,8),(800,5,18,18,8),(801,4,18,29,8),(802,3,18,30,8),(803,4,18,31,8),(804,3,18,32,8),(805,3,18,33,8),(806,7,18,10,9),(807,5,18,11,9),(808,5,18,12,9),(809,11,18,13,9),(810,5,18,17,9),(811,5,18,18,9),(812,5,18,19,9),(813,6,18,21,9),(814,6,18,22,9),(815,6,18,23,9),(816,4,18,29,9),(817,3,18,30,9),(818,3,18,31,9),(819,3,18,32,9),(820,7,18,8,10),(821,7,18,9,10),(822,7,18,10,10),(823,7,18,11,10),(824,7,18,12,10),(825,5,18,17,10),(826,5,18,18,10),(827,5,18,19,10),(828,6,18,20,10),(829,6,18,23,10),(830,3,18,26,10),(831,3,18,30,10),(832,3,18,32,10),(833,3,18,33,10),(834,3,18,34,10),(835,9,18,5,11),(836,14,18,9,11),(837,7,18,12,11),(838,5,18,17,11),(839,5,18,18,11),(840,6,18,20,11),(841,6,18,22,11),(842,6,18,23,11),(843,2,18,24,11),(844,3,18,26,11),(845,3,18,31,11),(846,3,18,32,11),(847,3,18,33,11),(848,3,18,34,11),(849,7,18,12,12),(850,5,18,17,12),(851,5,18,18,12),(852,6,18,19,12),(853,6,18,20,12),(854,3,18,23,12),(855,3,18,26,12),(856,11,18,31,12),(857,5,18,4,13),(858,7,18,12,13),(859,6,18,20,13),(860,6,18,21,13),(861,3,18,22,13),(862,3,18,23,13),(863,3,18,24,13),(864,3,18,25,13),(865,3,18,26,13),(866,5,18,3,14),(867,5,18,4,14),(868,5,18,5,14),(869,5,18,6,14),(870,5,18,7,14),(871,5,18,8,14),(872,7,18,12,14),(873,0,18,19,14),(874,3,18,24,14),(875,3,18,25,14),(876,5,18,5,15),(877,5,18,6,15),(878,5,18,7,15),(879,5,18,8,15),(880,5,18,9,15),(881,5,18,10,15),(882,3,18,11,15),(883,3,18,12,15),(884,3,18,13,15),(885,3,18,14,15),(886,2,18,15,15),(887,3,18,23,15),(888,3,18,24,15),(889,12,18,5,16),(890,3,18,11,16),(891,3,18,12,16),(892,3,18,13,16),(893,3,18,14,16),(894,6,18,23,16),(895,3,18,24,16),(896,0,18,0,17),(897,3,18,11,17),(898,3,18,12,17),(899,13,18,13,17),(900,6,18,23,17),(901,6,18,24,17),(902,3,18,11,18),(903,3,18,12,18),(904,6,18,23,18),(905,10,18,24,18),(906,5,18,30,18),(907,5,18,31,18),(908,6,18,3,19),(909,3,18,11,19),(910,5,18,30,19),(911,5,18,31,19),(912,5,18,32,19),(913,6,18,34,19),(914,6,18,35,19),(915,6,18,3,20),(916,6,18,4,20),(917,3,18,11,20),(918,5,18,30,20),(919,5,18,31,20),(920,6,18,33,20),(921,6,18,34,20),(922,6,18,35,20),(923,6,18,4,21),(924,5,18,30,21),(925,5,18,31,21),(926,6,18,35,21),(927,6,18,3,22),(928,6,18,4,22),(929,5,18,29,22),(930,5,18,30,22),(931,5,18,31,22),(932,5,18,32,22),(933,5,20,0,0),(934,4,20,3,0),(935,4,20,4,0),(936,4,20,5,0),(937,4,20,6,0),(938,4,20,7,0),(939,0,20,8,0),(940,5,20,10,0),(941,5,20,11,0),(942,5,20,12,0),(943,5,20,13,0),(944,3,20,16,0),(945,3,20,17,0),(946,3,20,18,0),(947,3,20,19,0),(948,3,20,20,0),(949,8,20,35,0),(950,5,20,0,1),(951,5,20,1,1),(952,5,20,2,1),(953,4,20,3,1),(954,4,20,4,1),(955,4,20,5,1),(956,4,20,6,1),(957,4,20,7,1),(958,5,20,10,1),(959,5,20,11,1),(960,0,20,12,1),(961,2,20,15,1),(962,3,20,17,1),(963,3,20,18,1),(964,5,20,0,2),(965,5,20,1,2),(966,5,20,2,2),(967,5,20,3,2),(968,5,20,4,2),(969,4,20,5,2),(970,4,20,6,2),(971,4,20,7,2),(972,4,20,8,2),(973,5,20,9,2),(974,5,20,10,2),(975,5,20,11,2),(976,3,20,17,2),(977,3,20,18,2),(978,3,20,19,2),(979,3,20,20,2),(980,5,20,0,3),(981,5,20,2,3),(982,5,20,3,3),(983,4,20,4,3),(984,4,20,5,3),(985,4,20,6,3),(986,4,20,7,3),(987,4,20,8,3),(988,4,20,9,3),(989,5,20,10,3),(990,5,20,11,3),(991,5,20,12,3),(992,3,20,13,3),(993,11,20,14,3),(994,3,20,18,3),(995,3,20,19,3),(996,3,20,20,3),(997,4,20,3,4),(998,4,20,4,4),(999,4,20,5,4),(1000,4,20,6,4),(1001,10,20,7,4),(1002,3,20,11,4),(1003,3,20,12,4),(1004,3,20,13,4),(1005,3,20,18,4),(1006,3,20,19,4),(1007,3,20,20,4),(1008,1,20,28,4),(1009,6,20,5,5),(1010,3,20,12,5),(1011,3,20,13,5),(1012,12,20,18,5),(1013,5,20,33,5),(1014,6,20,4,6),(1015,6,20,5,6),(1016,3,20,12,6),(1017,3,20,13,6),(1018,5,20,29,6),(1019,5,20,33,6),(1020,6,20,0,7),(1021,6,20,1,7),(1022,6,20,2,7),(1023,6,20,3,7),(1024,6,20,4,7),(1025,0,20,5,7),(1026,3,20,11,7),(1027,3,20,12,7),(1028,3,20,13,7),(1029,5,20,28,7),(1030,5,20,29,7),(1031,5,20,30,7),(1032,5,20,31,7),(1033,5,20,32,7),(1034,5,20,33,7),(1035,11,20,37,7),(1036,6,20,0,8),(1037,6,20,1,8),(1038,0,20,2,8),(1039,6,20,4,8),(1040,4,20,7,8),(1041,4,20,8,8),(1042,4,20,9,8),(1043,4,20,10,8),(1044,3,20,11,8),(1045,3,20,12,8),(1046,3,20,13,8),(1047,5,20,30,8),(1048,5,20,31,8),(1049,5,20,32,8),(1050,6,20,1,9),(1051,4,20,4,9),(1052,4,20,5,9),(1053,4,20,6,9),(1054,4,20,7,9),(1055,4,20,8,9),(1056,4,20,9,9),(1057,4,20,10,9),(1058,3,20,11,9),(1059,13,20,12,9),(1060,4,20,29,9),(1061,4,20,30,9),(1062,7,20,0,10),(1063,7,20,2,10),(1064,4,20,3,10),(1065,4,20,4,10),(1066,4,20,5,10),(1067,4,20,6,10),(1068,4,20,7,10),(1069,4,20,8,10),(1070,4,20,9,10),(1071,3,20,10,10),(1072,3,20,11,10),(1073,4,20,25,10),(1074,4,20,26,10),(1075,4,20,28,10),(1076,4,20,29,10),(1077,4,20,30,10),(1078,3,20,31,10),(1079,3,20,32,10),(1080,7,20,0,11),(1081,7,20,1,11),(1082,7,20,2,11),(1083,7,20,3,11),(1084,4,20,4,11),(1085,4,20,5,11),(1086,4,20,6,11),(1087,12,20,7,11),(1088,5,20,20,11),(1089,5,20,21,11),(1090,4,20,26,11),(1091,4,20,27,11),(1092,4,20,28,11),(1093,3,20,29,11),(1094,3,20,30,11),(1095,3,20,31,11),(1096,3,20,33,11),(1097,3,20,34,11),(1098,3,20,35,11),(1099,7,20,0,12),(1100,7,20,1,12),(1101,7,20,2,12),(1102,7,20,3,12),(1103,4,20,4,12),(1104,5,20,18,12),(1105,5,20,19,12),(1106,5,20,20,12),(1107,5,20,21,12),(1108,4,20,25,12),(1109,4,20,26,12),(1110,4,20,27,12),(1111,4,20,28,12),(1112,3,20,29,12),(1113,3,20,30,12),(1114,3,20,31,12),(1115,3,20,32,12),(1116,3,20,33,12),(1117,3,20,34,12),(1118,7,20,0,13),(1119,7,20,1,13),(1120,7,20,2,13),(1121,7,20,3,13),(1122,7,20,4,13),(1123,5,20,20,13),(1124,4,20,24,13),(1125,4,20,25,13),(1126,4,20,26,13),(1127,4,20,28,13),(1128,4,20,29,13),(1129,3,20,30,13),(1130,14,20,31,13),(1131,7,20,0,14),(1132,7,20,1,14),(1133,7,20,2,14),(1134,7,20,3,14),(1135,7,20,4,14),(1136,7,20,5,14),(1137,6,20,13,14),(1138,6,20,16,14),(1139,6,20,17,14),(1140,0,20,18,14),(1141,5,20,20,14),(1142,5,20,21,14),(1143,4,20,25,14),(1144,4,20,27,14),(1145,4,20,28,14),(1146,9,20,34,14),(1147,7,20,0,15),(1148,7,20,1,15),(1149,3,20,2,15),(1150,3,20,3,15),(1151,3,20,4,15),(1152,3,20,5,15),(1153,6,20,13,15),(1154,0,20,14,15),(1155,6,20,17,15),(1156,5,20,20,15),(1157,4,20,25,15),(1158,4,20,27,15),(1159,6,20,40,15),(1160,7,20,0,16),(1161,3,20,1,16),(1162,3,20,2,16),(1163,3,20,3,16),(1164,3,20,5,16),(1165,3,20,6,16),(1166,6,20,13,16),(1167,6,20,16,16),(1168,6,20,17,16),(1169,6,20,18,16),(1170,6,20,39,16),(1171,6,20,40,16),(1172,3,20,0,17),(1173,3,20,1,17),(1174,3,20,2,17),(1175,3,20,3,17),(1176,3,20,4,17),(1177,3,20,5,17),(1178,3,20,6,17),(1179,3,20,7,17),(1180,6,20,11,17),(1181,6,20,12,17),(1182,6,20,13,17),(1183,6,20,39,17),(1184,6,20,40,17),(1185,3,27,4,0),(1186,3,27,6,0),(1187,3,27,7,0),(1188,3,27,8,0),(1189,3,27,9,0),(1190,3,27,10,0),(1191,3,27,12,0),(1192,6,27,30,0),(1193,6,27,31,0),(1194,6,27,32,0),(1195,6,27,33,0),(1196,3,27,3,1),(1197,3,27,4,1),(1198,3,27,5,1),(1199,3,27,6,1),(1200,3,27,7,1),(1201,3,27,8,1),(1202,3,27,9,1),(1203,3,27,10,1),(1204,3,27,11,1),(1205,3,27,12,1),(1206,3,27,13,1),(1207,3,27,14,1),(1208,3,27,15,1),(1209,3,27,16,1),(1210,13,27,22,1),(1211,6,27,30,1),(1212,6,27,31,1),(1213,5,27,32,1),(1214,6,27,33,1),(1215,0,27,36,1),(1216,12,27,4,2),(1217,3,27,10,2),(1218,3,27,11,2),(1219,3,27,12,2),(1220,3,27,13,2),(1221,3,27,14,2),(1222,3,27,15,2),(1223,3,27,16,2),(1224,3,27,17,2),(1225,10,27,18,2),(1226,6,27,30,2),(1227,5,27,32,2),(1228,5,27,33,2),(1229,5,27,10,3),(1230,3,27,11,3),(1231,3,27,12,3),(1232,3,27,13,3),(1233,3,27,14,3),(1234,3,27,15,3),(1235,3,27,16,3),(1236,3,27,17,3),(1237,14,27,26,3),(1238,5,27,33,3),(1239,5,27,10,4),(1240,3,27,11,4),(1241,3,27,12,4),(1242,3,27,13,4),(1243,3,27,14,4),(1244,3,27,15,4),(1245,3,27,16,4),(1246,3,27,17,4),(1247,4,27,31,4),(1248,4,27,32,4),(1249,5,27,33,4),(1250,4,27,36,4),(1251,4,27,37,4),(1252,4,27,38,4),(1253,5,27,10,5),(1254,3,27,11,5),(1255,3,27,12,5),(1256,3,27,14,5),(1257,3,27,15,5),(1258,3,27,16,5),(1259,3,27,17,5),(1260,4,27,30,5),(1261,4,27,31,5),(1262,1,27,34,5),(1263,4,27,36,5),(1264,4,27,38,5),(1265,3,27,12,6),(1266,3,27,13,6),(1267,3,27,14,6),(1268,14,27,15,6),(1269,4,27,30,6),(1270,4,27,31,6),(1271,4,27,32,6),(1272,4,27,33,6),(1273,4,27,36,6),(1274,4,27,38,6),(1275,3,27,12,7),(1276,3,27,13,7),(1277,12,27,18,7),(1278,4,27,30,7),(1279,4,27,31,7),(1280,4,27,36,7),(1281,4,27,37,7),(1282,4,27,38,7),(1283,5,27,9,8),(1284,5,27,10,8),(1285,5,27,11,8),(1286,5,27,12,8),(1287,3,27,13,8),(1288,3,27,14,8),(1289,9,27,26,8),(1290,4,27,30,8),(1291,4,27,31,8),(1292,4,27,32,8),(1293,4,27,33,8),(1294,4,27,34,8),(1295,4,27,35,8),(1296,4,27,36,8),(1297,4,27,37,8),(1298,2,27,3,9),(1299,5,27,11,9),(1300,3,27,14,9),(1301,4,27,30,9),(1302,4,27,31,9),(1303,4,27,32,9),(1304,4,27,33,9),(1305,4,27,34,9),(1306,4,27,35,9),(1307,4,27,36,9),(1308,4,27,37,9),(1309,4,27,38,9),(1310,0,27,0,10),(1311,3,27,12,10),(1312,3,27,13,10),(1313,3,27,14,10),(1314,3,27,15,10),(1315,3,27,16,10),(1316,3,27,17,10),(1317,4,27,30,10),(1318,4,27,31,10),(1319,4,27,32,10),(1320,4,27,33,10),(1321,4,27,34,10),(1322,4,27,35,10),(1323,4,27,36,10),(1324,4,27,37,10),(1325,5,27,8,11),(1326,3,27,12,11),(1327,3,27,13,11),(1328,3,27,14,11),(1329,3,27,15,11),(1330,3,27,16,11),(1331,3,27,17,11),(1332,0,27,28,11),(1333,2,27,30,11),(1334,4,27,32,11),(1335,4,27,34,11),(1336,4,27,35,11),(1337,4,27,36,11),(1338,6,27,0,12),(1339,6,27,1,12),(1340,6,27,2,12),(1341,6,27,3,12),(1342,5,27,6,12),(1343,5,27,7,12),(1344,5,27,8,12),(1345,3,27,14,12),(1346,3,27,15,12),(1347,3,27,16,12),(1348,3,27,17,12),(1349,4,27,32,12),(1350,4,27,36,12),(1351,6,27,1,13),(1352,6,27,2,13),(1353,8,27,3,13),(1354,5,27,7,13),(1355,3,27,14,13),(1356,3,27,15,13),(1357,3,27,16,13),(1358,3,27,17,13),(1359,3,27,18,13),(1360,4,27,31,13),(1361,4,27,32,13),(1362,6,27,1,14),(1363,6,27,2,14),(1364,3,27,14,14),(1365,3,27,15,14),(1366,3,27,16,14),(1367,0,27,17,14),(1368,9,27,19,14),(1369,5,27,23,14),(1370,4,27,32,14),(1371,1,27,12,15),(1372,3,27,14,15),(1373,5,27,23,15),(1374,3,27,14,16),(1375,11,27,15,16),(1376,5,27,23,16),(1377,5,27,24,16),(1378,5,27,25,16),(1379,0,27,2,17),(1380,7,27,19,17),(1381,7,27,20,17),(1382,7,27,22,17),(1383,7,27,23,17),(1384,7,27,24,17),(1385,7,27,25,17),(1386,4,27,27,17),(1387,4,27,30,17),(1388,10,27,5,18),(1389,7,27,20,18),(1390,7,27,21,18),(1391,7,27,22,18),(1392,7,27,23,18),(1393,7,27,24,18),(1394,7,27,25,18),(1395,4,27,27,18),(1396,4,27,28,18),(1397,4,27,29,18),(1398,4,27,30,18),(1399,4,27,31,18),(1400,6,27,9,19),(1401,7,27,19,19),(1402,7,27,20,19),(1403,7,27,21,19),(1404,7,27,22,19),(1405,4,27,23,19),(1406,4,27,24,19),(1407,4,27,25,19),(1408,4,27,26,19),(1409,4,27,27,19),(1410,4,27,28,19),(1411,4,27,29,19),(1412,4,27,31,19),(1413,4,27,32,19),(1414,6,27,9,20),(1415,7,27,19,20),(1416,7,27,20,20),(1417,7,27,21,20),(1418,7,27,22,20),(1419,7,27,23,20),(1420,4,27,24,20),(1421,4,27,25,20),(1422,4,27,26,20),(1423,4,27,27,20),(1424,4,27,28,20),(1425,6,27,9,21),(1426,6,27,10,21),(1427,6,27,11,21),(1428,7,27,19,21),(1429,7,27,20,21),(1430,7,27,21,21),(1431,7,27,22,21),(1432,7,27,23,21),(1433,7,27,24,21),(1434,4,27,25,21),(1435,4,27,26,21),(1436,4,27,28,21),(1437,4,27,29,21),(1438,6,27,9,22),(1439,6,27,10,22),(1440,7,27,18,22),(1441,7,27,19,22),(1442,7,27,20,22),(1443,7,27,21,22),(1444,7,27,22,22),(1445,7,27,23,22),(1446,7,27,24,22),(1447,4,27,25,22),(1448,4,27,28,22),(1449,5,28,0,0),(1450,5,28,1,0),(1451,5,28,2,0),(1452,5,28,3,0),(1453,5,28,4,0),(1454,5,28,5,0),(1455,6,28,6,0),(1456,6,28,7,0),(1457,6,28,8,0),(1458,4,28,19,0),(1459,4,28,20,0),(1460,3,28,28,0),(1461,3,28,29,0),(1462,3,28,31,0),(1463,3,28,32,0),(1464,5,28,33,0),(1465,5,28,34,0),(1466,5,28,36,0),(1467,5,28,37,0),(1468,5,28,0,1),(1469,4,28,1,1),(1470,5,28,2,1),(1471,5,28,3,1),(1472,5,28,5,1),(1473,6,28,6,1),(1474,6,28,7,1),(1475,1,28,9,1),(1476,0,28,16,1),(1477,4,28,19,1),(1478,4,28,20,1),(1479,4,28,21,1),(1480,3,28,28,1),(1481,3,28,29,1),(1482,3,28,30,1),(1483,3,28,31,1),(1484,3,28,32,1),(1485,3,28,33,1),(1486,5,28,34,1),(1487,5,28,35,1),(1488,5,28,36,1),(1489,5,28,37,1),(1490,2,28,39,1),(1491,5,28,0,2),(1492,4,28,1,2),(1493,5,28,2,2),(1494,5,28,3,2),(1495,5,28,4,2),(1496,6,28,7,2),(1497,6,28,12,2),(1498,6,28,13,2),(1499,6,28,14,2),(1500,6,28,15,2),(1501,0,28,18,2),(1502,4,28,20,2),(1503,4,28,21,2),(1504,3,28,27,2),(1505,3,28,28,2),(1506,3,28,29,2),(1507,0,28,30,2),(1508,0,28,33,2),(1509,5,28,35,2),(1510,5,28,36,2),(1511,5,28,37,2),(1512,5,28,38,2),(1513,4,28,44,2),(1514,4,28,45,2),(1515,5,28,0,3),(1516,4,28,1,3),(1517,4,28,2,3),(1518,13,28,6,3),(1519,6,28,13,3),(1520,9,28,14,3),(1521,4,28,20,3),(1522,4,28,21,3),(1523,3,28,27,3),(1524,0,28,28,3),(1525,5,28,35,3),(1526,5,28,36,3),(1527,5,28,37,3),(1528,7,28,38,3),(1529,7,28,39,3),(1530,7,28,40,3),(1531,0,28,41,3),(1532,4,28,45,3),(1533,4,28,0,4),(1534,4,28,1,4),(1535,6,28,12,4),(1536,6,28,13,4),(1537,4,28,18,4),(1538,4,28,19,4),(1539,4,28,20,4),(1540,4,28,21,4),(1541,3,28,27,4),(1542,12,28,30,4),(1543,7,28,37,4),(1544,7,28,39,4),(1545,4,28,44,4),(1546,4,28,45,4),(1547,4,28,46,4),(1548,4,28,0,5),(1549,4,28,1,5),(1550,7,28,5,5),(1551,4,28,21,5),(1552,4,28,22,5),(1553,4,28,23,5),(1554,7,28,37,5),(1555,7,28,38,5),(1556,7,28,39,5),(1557,4,28,43,5),(1558,4,28,44,5),(1559,5,28,0,6),(1560,5,28,1,6),(1561,5,28,3,6),(1562,5,28,4,6),(1563,7,28,5,6),(1564,14,28,26,6),(1565,7,28,37,6),(1566,5,28,0,7),(1567,5,28,1,7),(1568,5,28,2,7),(1569,5,28,3,7),(1570,5,28,4,7),(1571,7,28,5,7),(1572,7,28,6,7),(1573,3,28,29,7),(1574,1,28,41,7),(1575,9,28,43,7),(1576,5,28,0,8),(1577,5,28,1,8),(1578,5,28,3,8),(1579,7,28,4,8),(1580,7,28,5,8),(1581,7,28,6,8),(1582,3,28,7,8),(1583,8,28,13,8),(1584,11,28,16,8),(1585,11,28,20,8),(1586,3,28,29,8),(1587,5,28,0,9),(1588,5,28,1,9),(1589,7,28,4,9),(1590,7,28,5,9),(1591,3,28,6,9),(1592,3,28,7,9),(1593,3,28,8,9),(1594,3,28,29,9),(1595,5,28,36,9),(1596,0,28,38,9),(1597,5,28,0,10),(1598,3,28,3,10),(1599,3,28,5,10),(1600,3,28,6,10),(1601,3,28,7,10),(1602,10,28,25,10),(1603,3,28,29,10),(1604,3,28,30,10),(1605,3,28,31,10),(1606,3,28,32,10),(1607,5,28,33,10),(1608,5,28,34,10),(1609,5,28,36,10),(1610,10,28,40,10),(1611,3,28,3,11),(1612,3,28,4,11),(1613,3,28,5,11),(1614,3,28,6,11),(1615,0,28,12,11),(1616,3,28,29,11),(1617,3,28,30,11),(1618,3,28,31,11),(1619,5,28,32,11),(1620,5,28,33,11),(1621,5,28,34,11),(1622,5,28,35,11),(1623,5,28,36,11),(1624,5,28,37,11),(1625,5,28,38,11),(1626,5,28,39,11),(1627,3,28,46,11),(1628,3,28,47,11),(1629,6,28,15,12),(1630,3,28,31,12),(1631,3,28,32,12),(1632,5,28,33,12),(1633,5,28,34,12),(1634,5,28,35,12),(1635,5,28,37,12),(1636,5,28,38,12),(1637,5,28,39,12),(1638,3,28,45,12),(1639,3,28,46,12),(1640,3,28,47,12),(1641,4,28,5,13),(1642,4,28,6,13),(1643,4,28,7,13),(1644,4,28,8,13),(1645,4,28,9,13),(1646,6,28,15,13),(1647,3,28,32,13),(1648,3,28,33,13),(1649,3,28,34,13),(1650,5,28,35,13),(1651,5,28,36,13),(1652,5,28,37,13),(1653,5,28,38,13),(1654,5,28,39,13),(1655,3,28,44,13),(1656,3,28,45,13),(1657,3,28,46,13),(1658,3,28,47,13),(1659,4,28,9,14),(1660,6,28,14,14),(1661,6,28,15,14),(1662,6,28,16,14),(1663,6,28,17,14),(1664,6,28,18,14),(1665,5,28,35,14),(1666,5,28,36,14),(1667,5,28,37,14),(1668,5,28,38,14),(1669,3,28,42,14),(1670,3,28,43,14),(1671,3,28,44,14),(1672,3,28,45,14),(1673,3,28,46,14),(1674,3,28,47,14),(1675,3,29,7,0),(1676,3,29,8,0),(1677,3,29,9,0),(1678,3,29,10,0),(1679,3,29,11,0),(1680,3,29,12,0),(1681,3,29,13,0),(1682,3,29,14,0),(1683,3,29,15,0),(1684,3,29,16,0),(1685,5,29,40,0),(1686,5,29,41,0),(1687,5,29,42,0),(1688,5,29,43,0),(1689,9,29,2,1),(1690,3,29,8,1),(1691,3,29,9,1),(1692,3,29,10,1),(1693,3,29,11,1),(1694,3,29,12,1),(1695,3,29,13,1),(1696,3,29,14,1),(1697,3,29,15,1),(1698,3,29,16,1),(1699,0,29,23,1),(1700,7,29,28,1),(1701,7,29,29,1),(1702,6,29,32,1),(1703,11,29,35,1),(1704,5,29,39,1),(1705,5,29,40,1),(1706,5,29,41,1),(1707,5,29,42,1),(1708,5,29,43,1),(1709,3,29,8,2),(1710,3,29,9,2),(1711,3,29,10,2),(1712,3,29,11,2),(1713,3,29,12,2),(1714,3,29,15,2),(1715,7,29,25,2),(1716,7,29,26,2),(1717,7,29,27,2),(1718,7,29,28,2),(1719,1,29,29,2),(1720,6,29,31,2),(1721,6,29,32,2),(1722,5,29,42,2),(1723,5,29,43,2),(1724,3,29,7,3),(1725,3,29,8,3),(1726,3,29,9,3),(1727,3,29,10,3),(1728,3,29,11,3),(1729,3,29,12,3),(1730,3,29,13,3),(1731,8,29,21,3),(1732,7,29,26,3),(1733,7,29,27,3),(1734,7,29,28,3),(1735,6,29,31,3),(1736,6,29,32,3),(1737,6,29,34,3),(1738,5,29,40,3),(1739,5,29,41,3),(1740,5,29,42,3),(1741,12,29,4,4),(1742,3,29,10,4),(1743,7,29,26,4),(1744,7,29,27,4),(1745,7,29,28,4),(1746,7,29,29,4),(1747,6,29,30,4),(1748,6,29,31,4),(1749,6,29,32,4),(1750,6,29,33,4),(1751,6,29,34,4),(1752,5,29,41,4),(1753,6,29,43,4),(1754,14,29,13,5),(1755,7,29,25,5),(1756,7,29,26,5),(1757,7,29,27,5),(1758,7,29,28,5),(1759,0,29,29,5),(1760,6,29,31,5),(1761,6,29,32,5),(1762,6,29,33,5),(1763,6,29,40,5),(1764,6,29,41,5),(1765,6,29,42,5),(1766,6,29,43,5),(1767,6,29,44,5),(1768,10,29,0,6),(1769,7,29,27,6),(1770,7,29,28,6),(1771,6,29,31,6),(1772,6,29,32,6),(1773,6,29,40,6),(1774,6,29,41,6),(1775,6,29,42,6),(1776,6,29,44,6),(1777,6,29,32,7),(1778,6,29,37,7),(1779,6,29,41,7),(1780,6,29,42,7),(1781,6,29,43,7),(1782,4,29,12,8),(1783,6,29,37,8),(1784,6,29,38,8),(1785,6,29,40,8),(1786,6,29,41,8),(1787,5,29,42,8),(1788,6,29,43,8),(1789,4,29,12,9),(1790,4,29,13,9),(1791,13,29,14,9),(1792,6,29,35,9),(1793,6,29,36,9),(1794,6,29,37,9),(1795,6,29,38,9),(1796,6,29,40,9),(1797,5,29,42,9),(1798,5,29,43,9),(1799,4,29,12,10),(1800,4,29,13,10),(1801,6,29,34,10),(1802,6,29,35,10),(1803,6,29,36,10),(1804,6,29,37,10),(1805,5,29,42,10),(1806,5,29,43,10),(1807,5,29,44,10),(1808,4,29,11,11),(1809,4,29,12,11),(1810,4,29,13,11),(1811,4,29,14,11),(1812,4,29,15,11),(1813,4,29,16,11),(1814,4,29,17,11),(1815,4,29,18,11),(1816,4,29,20,11),(1817,4,29,21,11),(1818,6,29,34,11),(1819,6,29,35,11),(1820,6,29,36,11),(1821,6,29,37,11),(1822,6,29,38,11),(1823,5,29,41,11),(1824,5,29,42,11),(1825,4,29,10,12),(1826,4,29,11,12),(1827,4,29,12,12),(1828,4,29,13,12),(1829,4,29,14,12),(1830,4,29,15,12),(1831,4,29,16,12),(1832,4,29,17,12),(1833,4,29,18,12),(1834,4,29,19,12),(1835,4,29,20,12),(1836,4,29,21,12),(1837,6,29,36,12),(1838,7,29,37,12),(1839,7,29,38,12),(1840,5,29,42,12),(1841,4,29,11,13),(1842,4,29,12,13),(1843,4,29,13,13),(1844,4,29,14,13),(1845,4,29,15,13),(1846,4,29,16,13),(1847,4,29,17,13),(1848,4,29,18,13),(1849,4,29,19,13),(1850,4,29,21,13),(1851,7,29,34,13),(1852,7,29,36,13),(1853,7,29,37,13),(1854,5,29,42,13),(1855,3,29,7,14),(1856,3,29,8,14),(1857,3,29,9,14),(1858,3,29,10,14),(1859,4,29,11,14),(1860,4,29,13,14),(1861,4,29,18,14),(1862,0,29,20,14),(1863,0,29,28,14),(1864,7,29,33,14),(1865,7,29,34,14),(1866,7,29,35,14),(1867,7,29,36,14),(1868,7,29,37,14),(1869,5,29,42,14),(1870,3,29,5,15),(1871,3,29,6,15),(1872,3,29,7,15),(1873,3,29,8,15),(1874,4,29,16,15),(1875,4,29,17,15),(1876,4,29,18,15),(1877,4,29,19,15),(1878,7,29,34,15),(1879,7,29,35,15),(1880,7,29,36,15),(1881,7,29,37,15),(1882,2,29,42,15),(1883,3,29,3,16),(1884,3,29,5,16),(1885,3,29,8,16),(1886,3,29,9,16),(1887,3,29,10,16),(1888,3,29,11,16),(1889,3,29,12,16),(1890,4,29,15,16),(1891,4,29,16,16),(1892,4,29,17,16),(1893,5,29,18,16),(1894,4,29,19,16),(1895,4,29,20,16),(1896,4,29,21,16),(1897,5,29,31,16),(1898,5,29,32,16),(1899,7,29,36,16),(1900,7,29,37,16),(1901,3,29,3,17),(1902,3,29,5,17),(1903,3,29,6,17),(1904,3,29,7,17),(1905,3,29,8,17),(1906,3,29,9,17),(1907,3,29,10,17),(1908,3,29,11,17),(1909,3,29,12,17),(1910,0,29,18,17),(1911,4,29,22,17),(1912,4,29,23,17),(1913,4,29,24,17),(1914,5,29,30,17),(1915,5,29,31,17),(1916,5,29,32,17),(1917,7,29,36,17),(1918,7,29,37,17),(1919,7,29,38,17),(1920,3,29,0,18),(1921,3,29,1,18),(1922,3,29,2,18),(1923,3,29,3,18),(1924,3,29,4,18),(1925,3,29,5,18),(1926,3,29,6,18),(1927,3,29,9,18),(1928,3,29,10,18),(1929,3,29,11,18),(1930,3,29,12,18),(1931,4,29,22,18),(1932,4,29,23,18),(1933,4,29,24,18),(1934,4,29,25,18),(1935,4,29,26,18),(1936,5,29,28,18),(1937,5,29,30,18),(1938,5,29,32,18),(1939,5,29,33,18),(1940,0,29,34,18),(1941,7,29,38,18),(1942,14,29,39,18),(1943,3,29,0,19),(1944,3,29,2,19),(1945,3,29,3,19),(1946,3,29,4,19),(1947,3,29,6,19),(1948,3,29,7,19),(1949,3,29,8,19),(1950,3,29,9,19),(1951,3,29,10,19),(1952,3,29,11,19),(1953,8,29,12,19),(1954,5,29,15,19),(1955,5,29,18,19),(1956,4,29,22,19),(1957,4,29,23,19),(1958,4,29,24,19),(1959,4,29,25,19),(1960,4,29,26,19),(1961,4,29,27,19),(1962,5,29,28,19),(1963,5,29,29,19),(1964,5,29,30,19),(1965,5,29,31,19),(1966,5,29,32,19),(1967,5,29,33,19),(1968,3,29,2,20),(1969,3,29,3,20),(1970,3,29,4,20),(1971,3,29,5,20),(1972,3,29,6,20),(1973,3,29,7,20),(1974,3,29,8,20),(1975,3,29,9,20),(1976,3,29,10,20),(1977,3,29,11,20),(1978,5,29,15,20),(1979,5,29,16,20),(1980,5,29,17,20),(1981,5,29,18,20),(1982,5,29,19,20),(1983,5,29,20,20),(1984,4,29,22,20),(1985,4,29,23,20),(1986,4,29,24,20),(1987,4,29,25,20),(1988,5,29,26,20),(1989,5,29,27,20),(1990,5,29,28,20),(1991,5,29,29,20),(1992,5,29,30,20),(1993,5,29,31,20),(1994,5,29,32,20),(1995,2,29,33,20),(1996,3,29,1,21),(1997,3,29,2,21),(1998,3,29,3,21),(1999,3,29,4,21),(2000,3,29,9,21),(2001,3,29,10,21),(2002,3,29,11,21),(2003,5,29,15,21),(2004,5,29,16,21),(2005,5,29,17,21),(2006,5,29,19,21),(2007,4,29,22,21),(2008,4,29,23,21),(2009,4,29,25,21),(2010,5,29,26,21),(2011,5,29,27,21),(2012,5,29,28,21),(2013,5,29,29,21),(2014,5,29,31,21),(2015,3,29,11,22),(2016,3,29,12,22),(2017,5,29,16,22),(2018,5,29,17,22),(2019,5,29,18,22),(2020,4,29,21,22),(2021,4,29,22,22),(2022,4,29,23,22),(2023,4,29,24,22),(2024,5,29,25,22),(2025,5,29,26,22),(2026,5,29,27,22),(2027,3,30,7,0),(2028,3,30,8,0),(2029,3,30,10,0),(2030,3,30,11,0),(2031,5,30,23,0),(2032,5,30,25,0),(2033,3,30,30,0),(2034,4,30,31,0),(2035,4,30,32,0),(2036,4,30,33,0),(2037,4,30,34,0),(2038,4,30,35,0),(2039,4,30,36,0),(2040,4,30,37,0),(2041,4,30,38,0),(2042,4,30,39,0),(2043,4,30,40,0),(2044,3,30,8,1),(2045,3,30,9,1),(2046,3,30,10,1),(2047,3,30,11,1),(2048,3,30,12,1),(2049,3,30,14,1),(2050,3,30,15,1),(2051,5,30,22,1),(2052,5,30,23,1),(2053,5,30,24,1),(2054,5,30,25,1),(2055,5,30,26,1),(2056,3,30,30,1),(2057,3,30,31,1),(2058,4,30,33,1),(2059,4,30,34,1),(2060,4,30,35,1),(2061,4,30,36,1),(2062,4,30,37,1),(2063,4,30,39,1),(2064,4,30,40,1),(2065,3,30,9,2),(2066,3,30,10,2),(2067,3,30,11,2),(2068,3,30,12,2),(2069,3,30,13,2),(2070,3,30,14,2),(2071,5,30,25,2),(2072,5,30,26,2),(2073,5,30,27,2),(2074,3,30,29,2),(2075,3,30,31,2),(2076,3,30,32,2),(2077,4,30,34,2),(2078,4,30,35,2),(2079,4,30,36,2),(2080,4,30,37,2),(2081,4,30,38,2),(2082,3,30,9,3),(2083,3,30,10,3),(2084,3,30,11,3),(2085,3,30,12,3),(2086,3,30,13,3),(2087,3,30,14,3),(2088,3,30,15,3),(2089,5,30,21,3),(2090,5,30,22,3),(2091,5,30,23,3),(2092,5,30,24,3),(2093,5,30,25,3),(2094,5,30,26,3),(2095,5,30,27,3),(2096,3,30,29,3),(2097,3,30,30,3),(2098,3,30,31,3),(2099,4,30,32,3),(2100,4,30,33,3),(2101,4,30,34,3),(2102,4,30,35,3),(2103,4,30,38,3),(2104,3,30,9,4),(2105,3,30,10,4),(2106,3,30,11,4),(2107,3,30,12,4),(2108,3,30,13,4),(2109,5,30,21,4),(2110,5,30,22,4),(2111,5,30,23,4),(2112,5,30,24,4),(2113,5,30,25,4),(2114,3,30,26,4),(2115,5,30,27,4),(2116,3,30,29,4),(2117,3,30,30,4),(2118,3,30,31,4),(2119,3,30,32,4),(2120,4,30,33,4),(2121,4,30,34,4),(2122,4,30,35,4),(2123,9,30,7,5),(2124,3,30,11,5),(2125,3,30,12,5),(2126,5,30,20,5),(2127,5,30,21,5),(2128,5,30,22,5),(2129,5,30,23,5),(2130,5,30,24,5),(2131,5,30,25,5),(2132,3,30,26,5),(2133,3,30,28,5),(2134,3,30,29,5),(2135,3,30,31,5),(2136,7,30,33,5),(2137,4,30,34,5),(2138,4,30,35,5),(2139,7,30,36,5),(2140,7,30,37,5),(2141,7,30,38,5),(2142,2,30,11,6),(2143,5,30,21,6),(2144,5,30,22,6),(2145,5,30,23,6),(2146,5,30,24,6),(2147,5,30,25,6),(2148,3,30,26,6),(2149,3,30,27,6),(2150,3,30,28,6),(2151,3,30,29,6),(2152,3,30,31,6),(2153,3,30,32,6),(2154,7,30,33,6),(2155,7,30,34,6),(2156,7,30,35,6),(2157,7,30,36,6),(2158,7,30,37,6),(2159,5,30,21,7),(2160,5,30,22,7),(2161,5,30,23,7),(2162,5,30,24,7),(2163,5,30,25,7),(2164,3,30,26,7),(2165,3,30,27,7),(2166,3,30,28,7),(2167,3,30,31,7),(2168,7,30,32,7),(2169,7,30,33,7),(2170,7,30,34,7),(2171,7,30,35,7),(2172,7,30,36,7),(2173,7,30,37,7),(2174,10,30,47,7),(2175,6,30,5,8),(2176,6,30,6,8),(2177,6,30,7,8),(2178,6,30,8,8),(2179,3,30,9,8),(2180,3,30,10,8),(2181,3,30,11,8),(2182,3,30,12,8),(2183,5,30,22,8),(2184,5,30,25,8),(2185,3,30,26,8),(2186,3,30,28,8),(2187,3,30,29,8),(2188,7,30,30,8),(2189,7,30,31,8),(2190,7,30,32,8),(2191,7,30,34,8),(2192,7,30,35,8),(2193,7,30,36,8),(2194,7,30,37,8),(2195,0,30,44,8),(2196,6,30,5,9),(2197,6,30,6,9),(2198,6,30,7,9),(2199,6,30,8,9),(2200,6,30,9,9),(2201,3,30,10,9),(2202,3,30,11,9),(2203,3,30,12,9),(2204,3,30,13,9),(2205,3,30,14,9),(2206,3,30,15,9),(2207,3,30,16,9),(2208,8,30,20,9),(2209,3,30,27,9),(2210,3,30,28,9),(2211,7,30,29,9),(2212,7,30,30,9),(2213,7,30,31,9),(2214,7,30,32,9),(2215,0,30,33,9),(2216,9,30,35,9),(2217,6,30,6,10),(2218,6,30,7,10),(2219,6,30,8,10),(2220,3,30,9,10),(2221,3,30,10,10),(2222,3,30,11,10),(2223,3,30,12,10),(2224,3,30,13,10),(2225,3,30,14,10),(2226,3,30,15,10),(2227,3,30,16,10),(2228,3,30,17,10),(2229,0,30,24,10),(2230,6,30,26,10),(2231,3,30,27,10),(2232,7,30,28,10),(2233,7,30,29,10),(2234,7,30,30,10),(2235,7,30,31,10),(2236,7,30,32,10),(2237,6,30,40,10),(2238,6,30,41,10),(2239,3,30,7,11),(2240,3,30,8,11),(2241,3,30,9,11),(2242,3,30,10,11),(2243,3,30,11,11),(2244,3,30,12,11),(2245,3,30,13,11),(2246,3,30,14,11),(2247,3,30,15,11),(2248,3,30,16,11),(2249,3,30,17,11),(2250,6,30,26,11),(2251,7,30,27,11),(2252,7,30,28,11),(2253,7,30,29,11),(2254,7,30,30,11),(2255,7,30,31,11),(2256,7,30,32,11),(2257,7,30,33,11),(2258,7,30,34,11),(2259,6,30,40,11),(2260,11,30,47,11),(2261,5,30,6,12),(2262,3,30,7,12),(2263,3,30,10,12),(2264,5,30,11,12),(2265,5,30,12,12),(2266,5,30,13,12),(2267,3,30,14,12),(2268,3,30,15,12),(2269,3,30,18,12),(2270,6,30,24,12),(2271,6,30,25,12),(2272,6,30,26,12),(2273,7,30,27,12),(2274,7,30,28,12),(2275,14,30,29,12),(2276,7,30,32,12),(2277,7,30,33,12),(2278,7,30,34,12),(2279,6,30,39,12),(2280,6,30,40,12),(2281,6,30,42,12),(2282,5,30,3,13),(2283,5,30,4,13),(2284,5,30,5,13),(2285,5,30,6,13),(2286,3,30,7,13),(2287,5,30,8,13),(2288,5,30,10,13),(2289,5,30,11,13),(2290,5,30,12,13),(2291,5,30,13,13),(2292,3,30,14,13),(2293,3,30,15,13),(2294,3,30,16,13),(2295,3,30,17,13),(2296,3,30,18,13),(2297,3,30,19,13),(2298,6,30,23,13),(2299,6,30,24,13),(2300,6,30,25,13),(2301,6,30,26,13),(2302,7,30,27,13),(2303,7,30,28,13),(2304,7,30,32,13),(2305,7,30,33,13),(2306,7,30,34,13),(2307,6,30,40,13),(2308,6,30,41,13),(2309,6,30,42,13),(2310,5,30,4,14),(2311,5,30,5,14),(2312,5,30,6,14),(2313,5,30,7,14),(2314,5,30,8,14),(2315,5,30,9,14),(2316,5,30,10,14),(2317,5,30,11,14),(2318,5,30,12,14),(2319,5,30,13,14),(2320,5,30,14,14),(2321,5,30,15,14),(2322,3,30,16,14),(2323,3,30,17,14),(2324,3,30,18,14),(2325,3,30,19,14),(2326,3,30,20,14),(2327,6,30,25,14),(2328,6,30,26,14),(2329,6,30,27,14),(2330,7,30,28,14),(2331,7,30,32,14),(2332,7,30,33,14),(2333,7,30,34,14),(2334,6,30,38,14),(2335,6,30,39,14),(2336,6,30,40,14),(2337,6,30,41,14),(2338,6,30,42,14),(2339,5,30,4,15),(2340,5,30,5,15),(2341,5,30,6,15),(2342,5,30,7,15),(2343,5,30,8,15),(2344,0,30,9,15),(2345,5,30,11,15),(2346,5,30,12,15),(2347,5,30,13,15),(2348,3,30,14,15),(2349,3,30,15,15),(2350,3,30,16,15),(2351,3,30,17,15),(2352,3,30,18,15),(2353,3,30,19,15),(2354,3,30,20,15),(2355,3,30,21,15),(2356,4,30,25,15),(2357,6,30,27,15),(2358,6,30,28,15),(2359,7,30,32,15),(2360,7,30,33,15),(2361,7,30,34,15),(2362,6,30,39,15),(2363,6,30,41,15),(2364,6,30,42,15),(2365,6,30,43,15),(2366,5,30,5,16),(2367,5,30,6,16),(2368,5,30,7,16),(2369,5,30,8,16),(2370,5,30,11,16),(2371,5,30,12,16),(2372,5,30,13,16),(2373,5,30,14,16),(2374,5,30,15,16),(2375,5,30,16,16),(2376,5,30,17,16),(2377,5,30,18,16),(2378,3,30,19,16),(2379,3,30,20,16),(2380,3,30,21,16),(2381,4,30,25,16),(2382,4,30,26,16),(2383,6,30,27,16),(2384,4,30,28,16),(2385,7,30,31,16),(2386,7,30,32,16),(2387,7,30,33,16),(2388,6,30,39,16),(2389,6,30,40,16),(2390,6,30,41,16),(2391,6,30,42,16),(2392,5,30,5,17),(2393,5,30,6,17),(2394,5,30,7,17),(2395,5,30,8,17),(2396,0,30,9,17),(2397,5,30,11,17),(2398,4,30,12,17),(2399,5,30,13,17),(2400,5,30,14,17),(2401,5,30,15,17),(2402,5,30,16,17),(2403,3,30,17,17),(2404,3,30,18,17),(2405,3,30,19,17),(2406,3,30,21,17),(2407,4,30,25,17),(2408,4,30,26,17),(2409,4,30,27,17),(2410,4,30,28,17),(2411,7,30,31,17),(2412,6,30,38,17),(2413,6,30,39,17),(2414,6,30,40,17),(2415,6,30,41,17),(2416,6,30,42,17),(2417,5,30,43,17),(2418,5,30,44,17),(2419,13,30,45,17),(2420,5,30,3,18),(2421,5,30,4,18),(2422,5,30,5,18),(2423,5,30,6,18),(2424,5,30,7,18),(2425,5,30,8,18),(2426,5,30,11,18),(2427,4,30,12,18),(2428,4,30,13,18),(2429,4,30,14,18),(2430,5,30,15,18),(2431,5,30,16,18),(2432,5,30,17,18),(2433,5,30,18,18),(2434,3,30,19,18),(2435,3,30,20,18),(2436,3,30,21,18),(2437,3,30,22,18),(2438,4,30,24,18),(2439,4,30,25,18),(2440,4,30,26,18),(2441,4,30,27,18),(2442,4,30,28,18),(2443,4,30,29,18),(2444,4,30,30,18),(2445,7,30,31,18),(2446,6,30,38,18),(2447,6,30,39,18),(2448,6,30,41,18),(2449,5,30,42,18),(2450,5,30,43,18),(2451,12,30,0,19),(2452,5,30,6,19),(2453,5,30,7,19),(2454,5,30,8,19),(2455,11,30,9,19),(2456,4,30,13,19),(2457,4,30,14,19),(2458,14,30,15,19),(2459,5,30,18,19),(2460,5,30,19,19),(2461,3,30,20,19),(2462,4,30,23,19),(2463,4,30,24,19),(2464,4,30,25,19),(2465,4,30,26,19),(2466,4,30,27,19),(2467,4,30,28,19),(2468,4,30,29,19),(2469,4,30,30,19),(2470,1,30,31,19),(2471,5,30,43,19),(2472,5,30,44,19),(2473,5,30,45,19),(2474,5,30,6,20),(2475,5,30,7,20),(2476,5,30,8,20),(2477,4,30,13,20),(2478,4,30,14,20),(2479,5,30,18,20),(2480,5,30,19,20),(2481,4,30,25,20),(2482,4,30,26,20),(2483,4,30,27,20),(2484,4,30,28,20),(2485,4,30,29,20),(2486,4,30,30,20),(2487,5,30,42,20),(2488,5,30,43,20),(2489,5,30,45,20),(2490,5,30,6,21),(2491,5,30,7,21),(2492,4,30,13,21),(2493,5,30,18,21),(2494,5,30,19,21),(2495,4,30,25,21),(2496,4,30,26,21),(2497,4,30,27,21),(2498,4,30,28,21),(2499,4,30,30,21),(2500,5,30,38,21),(2501,5,30,39,21),(2502,5,30,40,21),(2503,5,30,41,21),(2504,5,30,42,21),(2505,5,30,43,21),(2506,5,30,45,21),(2507,5,30,6,22),(2508,4,30,13,22),(2509,4,30,14,22),(2510,13,30,24,22),(2511,5,30,38,22),(2512,5,30,39,22),(2513,5,30,40,22),(2514,5,30,42,22),(2515,5,30,43,22),(2516,5,30,44,22),(2517,4,30,13,23),(2518,4,30,14,23),(2519,4,30,15,23),(2520,4,30,16,23),(2521,4,30,17,23),(2522,5,30,39,23),(2523,5,30,40,23),(2524,5,30,41,23),(2525,5,30,42,23),(2526,5,30,43,23),(2527,5,30,44,23),(2528,4,30,13,24),(2529,4,30,14,24),(2530,4,30,16,24),(2531,4,30,17,24),(2532,4,30,18,24),(2533,4,30,19,24),(2534,5,30,42,24),(2535,5,30,43,24),(2536,5,30,44,24),(2537,5,30,45,24),(2538,5,30,47,24),(2539,4,30,10,25),(2540,4,30,11,25),(2541,4,30,12,25),(2542,4,30,13,25),(2543,4,30,14,25),(2544,4,30,15,25),(2545,4,30,16,25),(2546,4,30,17,25),(2547,4,30,18,25),(2548,4,30,19,25),(2549,4,30,20,25),(2550,4,30,21,25),(2551,5,30,42,25),(2552,5,30,43,25),(2553,5,30,44,25),(2554,5,30,45,25),(2555,5,30,46,25),(2556,5,30,47,25),(2557,5,30,48,25),(2558,6,33,5,0),(2559,6,33,6,0),(2560,6,33,7,0),(2561,6,33,8,0),(2562,6,33,9,0),(2563,4,33,12,0),(2564,4,33,13,0),(2565,4,33,14,0),(2566,4,33,15,0),(2567,3,33,30,0),(2568,3,33,31,0),(2569,3,33,32,0),(2570,3,33,33,0),(2571,3,33,34,0),(2572,3,33,35,0),(2573,3,33,36,0),(2574,3,33,37,0),(2575,3,33,38,0),(2576,3,33,39,0),(2577,3,33,40,0),(2578,0,33,46,0),(2579,6,33,5,1),(2580,6,33,6,1),(2581,6,33,7,1),(2582,4,33,12,1),(2583,4,33,13,1),(2584,4,33,14,1),(2585,4,33,15,1),(2586,3,33,30,1),(2587,3,33,31,1),(2588,3,33,32,1),(2589,3,33,33,1),(2590,3,33,35,1),(2591,10,33,36,1),(2592,6,33,6,2),(2593,4,33,10,2),(2594,4,33,11,2),(2595,4,33,12,2),(2596,4,33,13,2),(2597,4,33,14,2),(2598,4,33,15,2),(2599,4,33,16,2),(2600,4,33,17,2),(2601,2,33,18,2),(2602,2,33,20,2),(2603,3,33,30,2),(2604,3,33,32,2),(2605,3,33,33,2),(2606,3,33,34,2),(2607,3,33,35,2),(2608,3,33,41,2),(2609,3,33,44,2),(2610,3,33,45,2),(2611,4,33,10,3),(2612,4,33,11,3),(2613,4,33,12,3),(2614,4,33,13,3),(2615,4,33,14,3),(2616,4,33,15,3),(2617,5,33,28,3),(2618,3,33,30,3),(2619,3,33,31,3),(2620,3,33,32,3),(2621,3,33,33,3),(2622,3,33,34,3),(2623,3,33,35,3),(2624,3,33,40,3),(2625,3,33,41,3),(2626,3,33,44,3),(2627,12,33,45,3),(2628,4,33,13,4),(2629,4,33,14,4),(2630,4,33,15,4),(2631,4,33,16,4),(2632,4,33,17,4),(2633,0,33,19,4),(2634,5,33,28,4),(2635,3,33,29,4),(2636,3,33,30,4),(2637,3,33,31,4),(2638,3,33,32,4),(2639,3,33,33,4),(2640,3,33,34,4),(2641,3,33,35,4),(2642,3,33,41,4),(2643,3,33,42,4),(2644,3,33,43,4),(2645,3,33,44,4),(2646,4,33,14,5),(2647,4,33,16,5),(2648,4,33,17,5),(2649,5,33,27,5),(2650,5,33,28,5),(2651,5,33,29,5),(2652,5,33,30,5),(2653,3,33,31,5),(2654,3,33,32,5),(2655,3,33,33,5),(2656,3,33,34,5),(2657,3,33,37,5),(2658,3,33,38,5),(2659,3,33,39,5),(2660,3,33,40,5),(2661,3,33,41,5),(2662,3,33,42,5),(2663,3,33,43,5),(2664,3,33,44,5),(2665,4,33,14,6),(2666,4,33,16,6),(2667,4,33,17,6),(2668,4,33,19,6),(2669,10,33,21,6),(2670,11,33,25,6),(2671,5,33,29,6),(2672,3,33,30,6),(2673,3,33,31,6),(2674,3,33,33,6),(2675,3,33,34,6),(2676,3,33,37,6),(2677,3,33,39,6),(2678,3,33,41,6),(2679,3,33,42,6),(2680,3,33,43,6),(2681,3,33,44,6),(2682,4,33,13,7),(2683,4,33,14,7),(2684,4,33,15,7),(2685,4,33,16,7),(2686,4,33,17,7),(2687,4,33,18,7),(2688,4,33,19,7),(2689,5,33,29,7),(2690,5,33,30,7),(2691,5,33,31,7),(2692,3,33,37,7),(2693,3,33,40,7),(2694,3,33,41,7),(2695,3,33,42,7),(2696,3,33,43,7),(2697,3,33,44,7),(2698,4,33,13,8),(2699,4,33,15,8),(2700,4,33,16,8),(2701,4,33,17,8),(2702,4,33,18,8),(2703,4,33,19,8),(2704,4,33,20,8),(2705,5,33,29,8),(2706,5,33,30,8),(2707,5,33,31,8),(2708,3,33,37,8),(2709,6,33,38,8),(2710,3,33,39,8),(2711,3,33,40,8),(2712,3,33,41,8),(2713,3,33,42,8),(2714,3,33,43,8),(2715,3,33,44,8),(2716,5,33,15,9),(2717,4,33,17,9),(2718,4,33,18,9),(2719,4,33,19,9),(2720,5,33,30,9),(2721,6,33,38,9),(2722,3,33,40,9),(2723,12,33,41,9),(2724,0,33,3,10),(2725,5,33,15,10),(2726,5,33,16,10),(2727,5,33,17,10),(2728,4,33,18,10),(2729,4,33,19,10),(2730,4,33,20,10),(2731,4,33,29,10),(2732,6,33,36,10),(2733,6,33,37,10),(2734,6,33,38,10),(2735,3,33,39,10),(2736,3,33,40,10),(2737,5,33,15,11),(2738,5,33,16,11),(2739,4,33,18,11),(2740,4,33,19,11),(2741,4,33,20,11),(2742,5,33,21,11),(2743,5,33,22,11),(2744,5,33,23,11),(2745,5,33,24,11),(2746,4,33,29,11),(2747,4,33,30,11),(2748,4,33,31,11),(2749,4,33,32,11),(2750,4,33,33,11),(2751,4,33,35,11),(2752,6,33,36,11),(2753,6,33,37,11),(2754,6,33,38,11),(2755,6,33,39,11),(2756,3,33,40,11),(2757,14,33,3,12),(2758,4,33,9,12),(2759,4,33,10,12),(2760,5,33,14,12),(2761,5,33,15,12),(2762,5,33,16,12),(2763,5,33,17,12),(2764,4,33,18,12),(2765,5,33,22,12),(2766,5,33,23,12),(2767,4,33,27,12),(2768,4,33,28,12),(2769,4,33,29,12),(2770,4,33,30,12),(2771,4,33,31,12),(2772,4,33,32,12),(2773,4,33,33,12),(2774,4,33,34,12),(2775,4,33,35,12),(2776,3,33,40,12),(2777,4,33,8,13),(2778,4,33,9,13),(2779,5,33,15,13),(2780,5,33,16,13),(2781,5,33,22,13),(2782,5,33,23,13),(2783,5,33,24,13),(2784,6,33,27,13),(2785,6,33,28,13),(2786,4,33,30,13),(2787,4,33,31,13),(2788,4,33,32,13),(2789,4,33,8,14),(2790,4,33,9,14),(2791,4,33,10,14),(2792,4,33,11,14),(2793,5,33,15,14),(2794,6,33,17,14),(2795,5,33,24,14),(2796,6,33,25,14),(2797,6,33,26,14),(2798,6,33,27,14),(2799,6,33,28,14),(2800,6,33,29,14),(2801,4,33,30,14),(2802,4,33,31,14),(2803,3,33,40,14),(2804,4,33,7,15),(2805,4,33,8,15),(2806,4,33,9,15),(2807,4,33,10,15),(2808,4,33,11,15),(2809,4,33,12,15),(2810,4,33,13,15),(2811,5,33,15,15),(2812,6,33,17,15),(2813,6,33,18,15),(2814,6,33,25,15),(2815,6,33,26,15),(2816,4,33,30,15),(2817,4,33,31,15),(2818,4,33,32,15),(2819,3,33,39,15),(2820,3,33,40,15),(2821,4,33,44,15),(2822,4,33,45,15),(2823,4,33,46,15),(2824,4,33,47,15),(2825,4,33,48,15),(2826,4,33,49,15),(2827,4,33,51,15),(2828,9,33,1,16),(2829,4,33,7,16),(2830,4,33,8,16),(2831,4,33,9,16),(2832,4,33,10,16),(2833,4,33,11,16),(2834,4,33,12,16),(2835,4,33,13,16),(2836,4,33,14,16),(2837,6,33,16,16),(2838,6,33,17,16),(2839,6,33,18,16),(2840,6,33,19,16),(2841,6,33,20,16),(2842,4,33,31,16),(2843,8,33,35,16),(2844,3,33,39,16),(2845,3,33,40,16),(2846,1,33,41,16),(2847,4,33,45,16),(2848,4,33,46,16),(2849,4,33,47,16),(2850,4,33,48,16),(2851,4,33,49,16),(2852,4,33,50,16),(2853,4,33,51,16),(2854,4,33,52,16),(2855,4,33,6,17),(2856,4,33,7,17),(2857,4,33,8,17),(2858,4,33,9,17),(2859,4,33,10,17),(2860,4,33,11,17),(2861,4,33,13,17),(2862,4,33,14,17),(2863,6,33,16,17),(2864,6,33,17,17),(2865,6,33,18,17),(2866,6,33,19,17),(2867,6,33,20,17),(2868,6,33,21,17),(2869,6,33,22,17),(2870,4,33,31,17),(2871,4,33,32,17),(2872,3,33,39,17),(2873,3,33,40,17),(2874,3,33,43,17),(2875,3,33,44,17),(2876,3,33,45,17),(2877,3,33,46,17),(2878,4,33,47,17),(2879,4,33,48,17),(2880,13,33,6,18),(2881,6,33,18,18),(2882,6,33,22,18),(2883,7,33,29,18),(2884,4,33,32,18),(2885,4,33,33,18),(2886,4,33,34,18),(2887,3,33,40,18),(2888,3,33,41,18),(2889,3,33,42,18),(2890,3,33,43,18),(2891,3,33,44,18),(2892,3,33,45,18),(2893,3,33,46,18),(2894,4,33,47,18),(2895,0,33,24,19),(2896,7,33,28,19),(2897,7,33,29,19),(2898,4,33,33,19),(2899,3,33,39,19),(2900,3,33,40,19),(2901,3,33,41,19),(2902,3,33,42,19),(2903,3,33,43,19),(2904,3,33,44,19),(2905,3,33,45,19),(2906,4,33,46,19),(2907,4,33,47,19),(2908,4,33,48,19),(2909,0,33,19,20),(2910,0,33,27,20),(2911,7,33,29,20),(2912,7,33,30,20),(2913,7,33,31,20),(2914,3,33,38,20),(2915,3,33,39,20),(2916,3,33,40,20),(2917,3,33,41,20),(2918,3,33,42,20),(2919,3,33,43,20),(2920,3,33,44,20),(2921,3,33,45,20),(2922,3,33,46,20),(2923,4,33,47,20),(2924,4,33,48,20),(2925,5,33,15,21),(2926,7,33,30,21),(2927,9,33,39,21),(2928,3,33,43,21),(2929,3,33,44,21),(2930,3,33,45,21),(2931,4,33,46,21),(2932,4,33,47,21),(2933,5,33,15,22),(2934,5,33,16,22),(2935,5,33,17,22),(2936,7,33,28,22),(2937,7,33,29,22),(2938,7,33,30,22),(2939,7,33,31,22),(2940,7,33,37,22),(2941,3,33,44,22),(2942,3,33,45,22),(2943,4,33,46,22),(2944,4,33,47,22),(2945,4,33,48,22),(2946,4,33,49,22),(2947,3,33,50,22),(2948,5,33,15,23),(2949,7,33,27,23),(2950,7,33,28,23),(2951,7,33,29,23),(2952,7,33,30,23),(2953,7,33,31,23),(2954,7,33,36,23),(2955,7,33,37,23),(2956,7,33,38,23),(2957,3,33,43,23),(2958,3,33,44,23),(2959,4,33,46,23),(2960,4,33,47,23),(2961,3,33,48,23),(2962,3,33,49,23),(2963,3,33,50,23),(2964,0,33,51,23),(2965,5,33,6,24),(2966,5,33,7,24),(2967,5,33,8,24),(2968,5,33,9,24),(2969,5,33,14,24),(2970,5,33,15,24),(2971,5,33,16,24),(2972,5,33,17,24),(2973,5,33,18,24),(2974,7,33,27,24),(2975,7,33,28,24),(2976,7,33,29,24),(2977,7,33,30,24),(2978,7,33,31,24),(2979,7,33,32,24),(2980,7,33,35,24),(2981,7,33,36,24),(2982,7,33,37,24),(2983,7,33,38,24),(2984,7,33,39,24),(2985,7,33,40,24),(2986,3,33,41,24),(2987,3,33,42,24),(2988,3,33,43,24),(2989,3,33,44,24),(2990,3,33,45,24),(2991,3,33,46,24),(2992,3,33,47,24),(2993,3,33,48,24),(2994,3,33,49,24),(2995,3,33,50,24),(2996,0,33,5,25),(2997,5,33,7,25),(2998,13,33,8,25),(2999,5,33,15,25),(3000,5,33,18,25),(3001,7,33,28,25),(3002,7,33,29,25),(3003,7,33,34,25),(3004,7,33,35,25),(3005,7,33,36,25),(3006,7,33,37,25),(3007,7,33,38,25),(3008,7,33,39,25),(3009,7,33,40,25),(3010,7,33,41,25),(3011,3,33,42,25),(3012,3,33,43,25),(3013,3,33,44,25),(3014,3,33,45,25),(3015,3,33,46,25),(3016,3,33,47,25),(3017,3,33,48,25),(3018,3,33,49,25),(3019,3,33,50,25),(3020,3,33,51,25),(3021,3,33,52,25),(3022,5,33,7,26),(3023,5,33,14,26),(3024,5,33,15,26),(3025,7,33,27,26),(3026,7,33,28,26),(3027,7,33,29,26),(3028,7,33,30,26),(3029,7,33,36,26),(3030,7,33,37,26),(3031,7,33,38,26),(3032,7,33,39,26),(3033,7,33,40,26),(3034,7,33,41,26),(3035,3,33,43,26),(3036,3,33,44,26),(3037,3,33,45,26),(3038,3,33,46,26),(3039,3,33,47,26),(3040,3,33,48,26),(3041,3,33,49,26),(3042,3,33,50,26),(3043,3,33,51,26),(3044,3,33,52,26),(3045,5,33,4,27),(3046,5,33,5,27),(3047,5,33,6,27),(3048,5,33,7,27),(3049,5,33,8,27),(3050,5,33,9,27),(3051,5,33,10,27),(3052,5,33,11,27),(3053,7,33,27,27),(3054,7,33,28,27),(3055,7,33,30,27),(3056,7,33,36,27),(3057,7,33,37,27),(3058,7,33,38,27),(3059,7,33,39,27),(3060,7,33,40,27),(3061,7,33,41,27),(3062,7,33,42,27),(3063,3,33,43,27),(3064,3,33,44,27),(3065,3,33,45,27),(3066,3,33,46,27),(3067,3,33,47,27),(3068,3,33,48,27),(3069,3,33,49,27),(3070,3,33,51,27),(3071,4,38,24,0),(3072,4,38,25,0),(3073,7,38,39,0),(3074,7,38,40,0),(3075,7,38,41,0),(3076,3,38,46,0),(3077,3,38,47,0),(3078,3,38,48,0),(3079,3,38,49,0),(3080,3,38,50,0),(3081,3,38,51,0),(3082,4,38,21,1),(3083,4,38,22,1),(3084,4,38,23,1),(3085,4,38,24,1),(3086,4,38,25,1),(3087,4,38,26,1),(3088,0,38,39,1),(3089,7,38,41,1),(3090,7,38,42,1),(3091,3,38,46,1),(3092,3,38,47,1),(3093,3,38,48,1),(3094,3,38,49,1),(3095,3,38,50,1),(3096,3,38,51,1),(3097,4,38,21,2),(3098,4,38,22,2),(3099,4,38,23,2),(3100,4,38,24,2),(3101,4,38,25,2),(3102,4,38,26,2),(3103,4,38,27,2),(3104,4,38,28,2),(3105,4,38,29,2),(3106,0,38,30,2),(3107,7,38,41,2),(3108,7,38,42,2),(3109,7,38,43,2),(3110,3,38,48,2),(3111,3,38,49,2),(3112,3,38,50,2),(3113,3,38,51,2),(3114,5,38,1,3),(3115,5,38,9,3),(3116,5,38,10,3),(3117,5,38,11,3),(3118,5,38,12,3),(3119,3,38,16,3),(3120,3,38,17,3),(3121,3,38,18,3),(3122,3,38,19,3),(3123,3,38,20,3),(3124,3,38,21,3),(3125,4,38,22,3),(3126,4,38,23,3),(3127,4,38,24,3),(3128,4,38,25,3),(3129,4,38,26,3),(3130,4,38,27,3),(3131,4,38,28,3),(3132,7,38,39,3),(3133,7,38,40,3),(3134,7,38,41,3),(3135,7,38,42,3),(3136,3,38,48,3),(3137,3,38,49,3),(3138,3,38,50,3),(3139,3,38,51,3),(3140,5,38,1,4),(3141,5,38,2,4),(3142,5,38,8,4),(3143,5,38,9,4),(3144,5,38,10,4),(3145,5,38,11,4),(3146,5,38,12,4),(3147,5,38,13,4),(3148,3,38,19,4),(3149,3,38,20,4),(3150,4,38,22,4),(3151,4,38,23,4),(3152,4,38,24,4),(3153,4,38,26,4),(3154,4,38,27,4),(3155,4,38,28,4),(3156,6,38,29,4),(3157,6,38,30,4),(3158,4,38,35,4),(3159,7,38,39,4),(3160,7,38,40,4),(3161,7,38,41,4),(3162,7,38,42,4),(3163,3,38,49,4),(3164,3,38,50,4),(3165,5,38,0,5),(3166,5,38,1,5),(3167,5,38,2,5),(3168,5,38,5,5),(3169,5,38,6,5),(3170,5,38,7,5),(3171,5,38,8,5),(3172,5,38,9,5),(3173,5,38,11,5),(3174,5,38,13,5),(3175,3,38,16,5),(3176,3,38,17,5),(3177,3,38,18,5),(3178,3,38,19,5),(3179,3,38,20,5),(3180,3,38,21,5),(3181,4,38,26,5),(3182,6,38,27,5),(3183,6,38,28,5),(3184,6,38,29,5),(3185,6,38,30,5),(3186,6,38,31,5),(3187,6,38,32,5),(3188,4,38,35,5),(3189,7,38,37,5),(3190,7,38,38,5),(3191,7,38,39,5),(3192,7,38,40,5),(3193,7,38,41,5),(3194,3,38,49,5),(3195,3,38,50,5),(3196,5,38,0,6),(3197,5,38,1,6),(3198,5,38,2,6),(3199,5,38,7,6),(3200,5,38,8,6),(3201,5,38,9,6),(3202,5,38,10,6),(3203,5,38,11,6),(3204,5,38,13,6),(3205,5,38,14,6),(3206,3,38,18,6),(3207,3,38,20,6),(3208,3,38,21,6),(3209,3,38,22,6),(3210,6,38,28,6),(3211,6,38,29,6),(3212,6,38,30,6),(3213,4,38,35,6),(3214,7,38,37,6),(3215,7,38,38,6),(3216,7,38,39,6),(3217,7,38,41,6),(3218,13,38,43,6),(3219,5,38,0,7),(3220,5,38,1,7),(3221,5,38,2,7),(3222,5,38,3,7),(3223,5,38,4,7),(3224,5,38,6,7),(3225,5,38,7,7),(3226,5,38,8,7),(3227,5,38,9,7),(3228,5,38,10,7),(3229,5,38,11,7),(3230,3,38,19,7),(3231,3,38,20,7),(3232,6,38,28,7),(3233,4,38,34,7),(3234,4,38,35,7),(3235,4,38,36,7),(3236,7,38,39,7),(3237,7,38,40,7),(3238,7,38,41,7),(3239,7,38,42,7),(3240,5,38,0,8),(3241,5,38,1,8),(3242,5,38,2,8),(3243,5,38,3,8),(3244,5,38,4,8),(3245,5,38,5,8),(3246,5,38,7,8),(3247,5,38,8,8),(3248,5,38,9,8),(3249,5,38,10,8),(3250,3,38,14,8),(3251,6,38,17,8),(3252,6,38,18,8),(3253,6,38,19,8),(3254,4,38,34,8),(3255,4,38,35,8),(3256,4,38,36,8),(3257,4,38,37,8),(3258,7,38,39,8),(3259,7,38,40,8),(3260,5,38,41,8),(3261,7,38,42,8),(3262,5,38,43,8),(3263,5,38,44,8),(3264,5,38,45,8),(3265,5,38,46,8),(3266,5,38,47,8),(3267,5,38,49,8),(3268,5,38,0,9),(3269,5,38,1,9),(3270,5,38,2,9),(3271,5,38,3,9),(3272,5,38,4,9),(3273,5,38,5,9),(3274,5,38,6,9),(3275,5,38,7,9),(3276,5,38,10,9),(3277,5,38,11,9),(3278,3,38,12,9),(3279,3,38,13,9),(3280,3,38,14,9),(3281,3,38,15,9),(3282,6,38,17,9),(3283,6,38,18,9),(3284,6,38,19,9),(3285,4,38,33,9),(3286,4,38,34,9),(3287,4,38,35,9),(3288,4,38,36,9),(3289,4,38,37,9),(3290,4,38,38,9),(3291,4,38,39,9),(3292,5,38,41,9),(3293,5,38,42,9),(3294,5,38,43,9),(3295,5,38,44,9),(3296,5,38,45,9),(3297,5,38,46,9),(3298,5,38,47,9),(3299,5,38,48,9),(3300,5,38,49,9),(3301,5,38,50,9),(3302,5,38,51,9),(3303,5,38,0,10),(3304,5,38,1,10),(3305,5,38,2,10),(3306,5,38,3,10),(3307,3,38,10,10),(3308,3,38,11,10),(3309,3,38,12,10),(3310,3,38,13,10),(3311,3,38,14,10),(3312,3,38,15,10),(3313,3,38,16,10),(3314,6,38,17,10),(3315,6,38,18,10),(3316,6,38,19,10),(3317,4,38,31,10),(3318,4,38,32,10),(3319,4,38,33,10),(3320,4,38,34,10),(3321,4,38,35,10),(3322,4,38,36,10),(3323,4,38,38,10),(3324,6,38,39,10),(3325,5,38,44,10),(3326,5,38,45,10),(3327,5,38,47,10),(3328,5,38,49,10),(3329,5,38,50,10),(3330,5,38,51,10),(3331,5,38,0,11),(3332,5,38,1,11),(3333,5,38,3,11),(3334,3,38,11,11),(3335,3,38,13,11),(3336,3,38,14,11),(3337,3,38,16,11),(3338,3,38,17,11),(3339,6,38,18,11),(3340,6,38,19,11),(3341,4,38,32,11),(3342,4,38,33,11),(3343,4,38,34,11),(3344,4,38,37,11),(3345,4,38,38,11),(3346,6,38,39,11),(3347,5,38,43,11),(3348,5,38,44,11),(3349,5,38,45,11),(3350,5,38,46,11),(3351,5,38,47,11),(3352,5,38,48,11),(3353,5,38,49,11),(3354,5,38,50,11),(3355,5,38,51,11),(3356,5,38,0,12),(3357,5,38,1,12),(3358,5,38,2,12),(3359,14,38,3,12),(3360,3,38,12,12),(3361,3,38,13,12),(3362,3,38,14,12),(3363,7,38,23,12),(3364,7,38,25,12),(3365,3,38,29,12),(3366,3,38,32,12),(3367,3,38,33,12),(3368,4,38,34,12),(3369,4,38,35,12),(3370,4,38,36,12),(3371,6,38,38,12),(3372,6,38,39,12),(3373,6,38,40,12),(3374,5,38,44,12),(3375,5,38,45,12),(3376,5,38,47,12),(3377,5,38,48,12),(3378,5,38,49,12),(3379,5,38,50,12),(3380,5,38,51,12),(3381,0,38,0,13),(3382,3,38,12,13),(3383,3,38,13,13),(3384,3,38,14,13),(3385,7,38,20,13),(3386,7,38,21,13),(3387,7,38,23,13),(3388,7,38,24,13),(3389,7,38,25,13),(3390,7,38,26,13),(3391,3,38,29,13),(3392,3,38,30,13),(3393,3,38,31,13),(3394,3,38,32,13),(3395,3,38,33,13),(3396,3,38,34,13),(3397,4,38,35,13),(3398,6,38,38,13),(3399,6,38,39,13),(3400,6,38,40,13),(3401,6,38,41,13),(3402,6,38,42,13),(3403,5,38,44,13),(3404,5,38,45,13),(3405,8,38,48,13),(3406,5,38,51,13),(3407,3,38,13,14),(3408,7,38,20,14),(3409,7,38,21,14),(3410,7,38,23,14),(3411,7,38,24,14),(3412,7,38,25,14),(3413,7,38,26,14),(3414,3,38,29,14),(3415,3,38,30,14),(3416,3,38,32,14),(3417,3,38,33,14),(3418,3,38,34,14),(3419,2,38,35,14),(3420,1,38,39,14),(3421,5,38,43,14),(3422,5,38,44,14),(3423,5,38,45,14),(3424,5,38,46,14),(3425,5,38,51,14),(3426,10,38,6,15),(3427,4,38,20,15),(3428,7,38,21,15),(3429,7,38,22,15),(3430,7,38,23,15),(3431,7,38,24,15),(3432,7,38,25,15),(3433,7,38,26,15),(3434,7,38,27,15),(3435,7,38,28,15),(3436,3,38,29,15),(3437,4,38,30,15),(3438,4,38,31,15),(3439,4,38,32,15),(3440,3,38,33,15),(3441,3,38,34,15),(3442,5,38,51,15),(3443,9,38,2,16),(3444,4,38,18,16),(3445,4,38,20,16),(3446,7,38,22,16),(3447,7,38,23,16),(3448,7,38,24,16),(3449,7,38,25,16),(3450,7,38,26,16),(3451,7,38,27,16),(3452,7,38,28,16),(3453,4,38,32,16),(3454,4,38,33,16),(3455,3,38,34,16),(3456,3,38,35,16),(3457,5,38,47,16),(3458,5,38,48,16),(3459,5,38,49,16),(3460,5,38,50,16),(3461,5,38,51,16),(3462,4,38,18,17),(3463,4,38,19,17),(3464,4,38,20,17),(3465,4,38,21,17),(3466,7,38,22,17),(3467,7,38,23,17),(3468,11,38,24,17),(3469,1,38,28,17),(3470,4,38,31,17),(3471,4,38,32,17),(3472,4,38,33,17),(3473,3,38,34,17),(3474,3,38,35,17),(3475,3,38,36,17),(3476,3,38,37,17),(3477,4,38,38,17),(3478,4,38,39,17),(3479,5,38,46,17),(3480,5,38,48,17),(3481,5,38,49,17),(3482,5,38,50,17),(3483,5,38,51,17),(3484,4,38,15,18),(3485,4,38,16,18),(3486,4,38,17,18),(3487,4,38,18,18),(3488,4,38,19,18),(3489,4,38,20,18),(3490,0,38,21,18),(3491,7,38,23,18),(3492,4,38,32,18),(3493,4,38,33,18),(3494,4,38,34,18),(3495,4,38,35,18),(3496,3,38,36,18),(3497,4,38,37,18),(3498,4,38,38,18),(3499,5,38,46,18),(3500,5,38,47,18),(3501,5,38,48,18),(3502,5,38,49,18),(3503,5,38,50,18),(3504,5,38,51,18),(3505,4,38,16,19),(3506,4,38,17,19),(3507,4,38,18,19),(3508,4,38,19,19),(3509,4,38,20,19),(3510,7,38,23,19),(3511,4,38,32,19),(3512,4,38,33,19),(3513,4,38,34,19),(3514,4,38,35,19),(3515,4,38,36,19),(3516,4,38,37,19),(3517,4,38,38,19),(3518,4,38,39,19),(3519,12,38,45,19),(3520,5,38,51,19),(3521,4,38,16,20),(3522,4,38,17,20),(3523,4,38,18,20),(3524,4,38,19,20),(3525,4,38,20,20),(3526,8,38,21,20),(3527,3,38,30,20),(3528,3,38,31,20),(3529,4,38,32,20),(3530,4,38,33,20),(3531,4,38,34,20),(3532,4,38,35,20),(3533,4,38,36,20),(3534,4,38,37,20),(3535,4,38,38,20),(3536,5,38,51,20),(3537,4,38,18,21),(3538,4,38,19,21),(3539,4,38,20,21),(3540,3,38,30,21),(3541,3,38,31,21),(3542,4,38,32,21),(3543,3,38,33,21),(3544,3,38,34,21),(3545,3,38,35,21),(3546,3,38,36,21),(3547,4,38,37,21),(3548,5,38,51,21),(3549,4,38,15,22),(3550,4,38,16,22),(3551,4,38,17,22),(3552,4,38,18,22),(3553,6,38,19,22),(3554,4,38,20,22),(3555,3,38,31,22),(3556,3,38,32,22),(3557,3,38,33,22),(3558,3,38,34,22),(3559,3,38,35,22),(3560,3,38,36,22),(3561,5,38,51,22),(3562,4,38,18,23),(3563,13,38,19,23),(3564,0,38,25,23),(3565,3,38,32,23),(3566,3,38,34,23),(3567,5,38,51,23),(3568,4,38,18,24),(3569,3,38,32,24),(3570,3,38,33,24),(3571,3,38,34,24),(3572,3,38,35,24),(3573,3,38,36,24),(3574,3,38,37,24),(3575,5,38,51,24),(3576,3,38,35,25),(3577,3,38,36,25),(3578,5,38,50,25),(3579,5,38,51,25),(3580,5,32,0,0),(3581,5,32,1,0),(3582,5,32,2,0),(3583,5,32,3,0),(3584,5,32,16,0),(3585,5,32,17,0),(3586,5,32,18,0),(3587,5,32,19,0),(3588,5,32,20,0),(3589,5,32,21,0),(3590,5,32,22,0),(3591,5,32,23,0),(3592,5,32,24,0),(3593,5,32,25,0),(3594,5,32,26,0),(3595,5,32,0,1),(3596,5,32,1,1),(3597,5,32,2,1),(3598,5,32,3,1),(3599,5,32,4,1),(3600,12,32,7,1),(3601,5,32,17,1),(3602,5,32,18,1),(3603,5,32,20,1),(3604,14,32,22,1),(3605,5,32,26,1),(3606,5,32,28,1),(3607,5,32,0,2),(3608,5,32,1,2),(3609,5,32,2,2),(3610,5,32,4,2),(3611,5,32,5,2),(3612,5,32,25,2),(3613,5,32,26,2),(3614,5,32,28,2),(3615,5,32,29,2),(3616,5,32,0,3),(3617,5,32,1,3),(3618,5,32,4,3),(3619,5,32,5,3),(3620,5,32,28,3),(3621,6,32,29,3),(3622,5,32,28,4),(3623,6,32,29,4),(3624,4,32,3,5),(3625,4,32,5,5),(3626,0,32,18,5),(3627,6,32,27,5),(3628,6,32,28,5),(3629,6,32,29,5),(3630,4,32,2,6),(3631,4,32,3,6),(3632,4,32,4,6),(3633,4,32,5,6),(3634,6,32,26,6),(3635,6,32,27,6),(3636,6,32,28,6),(3637,6,32,29,6),(3638,4,32,1,7),(3639,4,32,2,7),(3640,4,32,3,7),(3641,4,32,4,7),(3642,4,32,5,7),(3643,6,32,26,7),(3644,5,32,27,7),(3645,5,32,28,7),(3646,5,32,29,7),(3647,4,32,1,8),(3648,4,32,2,8),(3649,4,32,3,8),(3650,4,32,4,8),(3651,0,32,10,8),(3652,5,32,27,8),(3653,5,32,28,8),(3654,5,32,29,8),(3655,4,32,1,9),(3656,4,32,2,9),(3657,4,32,3,9),(3658,5,32,29,9),(3659,4,32,1,10),(3660,6,32,5,10),(3661,6,32,6,10),(3662,5,32,28,10),(3663,5,32,29,10),(3664,6,32,4,11),(3665,6,32,5,11),(3666,6,32,6,11),(3667,6,32,7,11),(3668,6,32,8,11),(3669,5,32,27,11),(3670,5,32,28,11),(3671,5,32,29,11),(3672,13,32,1,12),(3673,6,32,8,12),(3674,6,32,9,12),(3675,6,32,10,12),(3676,5,32,27,12),(3677,5,32,28,12),(3678,5,32,29,12),(3679,6,32,8,13),(3680,6,32,9,13),(3681,6,32,10,13),(3682,5,32,28,13),(3683,5,32,29,13),(3684,5,32,2,14),(3685,6,32,9,14),(3686,5,32,28,14),(3687,5,32,0,15),(3688,5,32,2,15),(3689,5,32,3,15),(3690,5,32,0,16),(3691,5,32,1,16),(3692,5,32,2,16),(3693,5,32,3,16),(3694,5,32,4,16),(3695,2,32,26,16),(3696,5,32,0,17),(3697,5,32,1,17),(3698,5,32,2,17),(3699,5,32,3,17),(3700,5,32,4,17),(3701,5,32,0,18),(3702,5,32,1,18),(3703,5,32,3,18),(3704,6,32,6,18),(3705,4,32,24,18),(3706,4,32,29,18),(3707,5,32,0,19),(3708,5,32,2,19),(3709,5,32,3,19),(3710,6,32,7,19),(3711,6,32,8,19),(3712,4,32,24,19),(3713,4,32,25,19),(3714,4,32,26,19),(3715,4,32,27,19),(3716,4,32,28,19),(3717,4,32,29,19),(3718,5,32,0,20),(3719,11,32,1,20),(3720,6,32,5,20),(3721,6,32,6,20),(3722,6,32,7,20),(3723,6,32,8,20),(3724,6,32,9,20),(3725,4,32,23,20),(3726,4,32,24,20),(3727,4,32,25,20),(3728,4,32,26,20),(3729,4,32,27,20),(3730,4,32,28,20),(3731,4,32,29,20),(3732,5,32,0,21),(3733,6,32,5,21),(3734,6,32,6,21),(3735,4,32,24,21),(3736,4,32,25,21),(3737,4,32,26,21),(3738,4,32,27,21),(3739,4,32,28,21),(3740,4,32,29,21),(3741,5,32,0,22),(3742,6,32,6,22),(3743,8,32,10,22),(3744,4,32,24,22),(3745,4,32,25,22),(3746,4,32,26,22),(3747,4,32,27,22),(3748,4,32,28,22),(3749,4,32,29,22),(3750,5,32,0,23),(3751,4,32,26,23),(3752,4,32,27,23),(3753,4,32,28,23),(3754,5,32,0,24),(3755,3,32,18,24),(3756,3,32,19,24),(3757,3,32,20,24),(3758,0,32,24,24),(3759,4,32,27,24),(3760,0,32,28,24),(3761,5,32,0,25),(3762,3,32,9,25),(3763,3,32,10,25),(3764,3,32,13,25),(3765,3,32,14,25),(3766,3,32,15,25),(3767,3,32,17,25),(3768,3,32,18,25),(3769,3,32,19,25),(3770,3,32,20,25),(3771,3,32,21,25),(3772,5,32,0,26),(3773,5,32,1,26),(3774,5,32,2,26),(3775,3,32,9,26),(3776,3,32,10,26),(3777,3,32,11,26),(3778,3,32,14,26),(3779,3,32,15,26),(3780,3,32,16,26),(3781,3,32,17,26),(3782,3,32,18,26),(3783,3,32,19,26),(3784,3,32,20,26),(3785,3,32,21,26),(3786,3,32,23,26),(3787,5,32,2,27),(3788,0,32,3,27),(3789,3,32,10,27),(3790,3,32,11,27),(3791,3,32,12,27),(3792,3,32,13,27),(3793,3,32,14,27),(3794,3,32,15,27),(3795,3,32,16,27),(3796,3,32,17,27),(3797,3,32,18,27),(3798,3,32,19,27),(3799,3,32,20,27),(3800,3,32,21,27),(3801,3,32,22,27),(3802,3,32,23,27),(3803,3,32,24,27),(3804,0,32,0,28),(3805,3,32,11,28),(3806,3,32,12,28),(3807,3,32,13,28),(3808,3,32,14,28),(3809,3,32,15,28),(3810,3,32,16,28),(3811,3,32,17,28),(3812,3,32,18,28),(3813,3,32,19,28),(3814,3,32,20,28),(3815,3,32,21,28),(3816,3,32,22,28),(3817,3,32,23,28),(3818,3,32,24,28),(3819,3,32,10,29),(3820,3,32,11,29),(3821,3,32,12,29),(3822,3,32,13,29),(3823,3,32,14,29),(3824,3,32,15,29),(3825,3,32,16,29),(3826,3,32,17,29),(3827,3,32,18,29),(3828,3,32,19,29),(3829,3,32,20,29),(3830,3,32,21,29),(3831,3,32,22,29),(3832,3,32,23,29);
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
INSERT INTO `units` VALUES (1,100,1,32,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,18,28,NULL,1,0,0,0),(2,100,1,32,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,18,28,NULL,1,0,0,0),(3,100,1,32,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,18,28,NULL,1,0,0,0),(4,100,1,32,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,18,28,NULL,1,0,0,0),(5,100,1,32,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,18,28,NULL,1,0,0,0),(6,200,1,32,4,NULL,NULL,NULL,NULL,0,0,'Glancer',0,18,28,NULL,1,0,0,0),(7,200,1,32,4,NULL,NULL,NULL,NULL,0,0,'Glancer',0,18,28,NULL,1,0,0,0),(8,200,1,32,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,18,28,NULL,1,0,0,0),(9,200,1,32,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,18,28,NULL,1,0,0,0),(10,100,1,32,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,18,28,NULL,1,0,0,0),(11,100,1,32,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,18,28,NULL,1,0,0,0),(12,100,1,32,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,18,28,NULL,1,0,0,0),(13,100,1,32,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,26,16,NULL,1,0,0,0),(14,100,1,32,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,26,16,NULL,1,0,0,0),(15,100,1,32,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,26,16,NULL,1,0,0,0),(16,100,1,32,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,26,16,NULL,1,0,0,0),(17,100,1,32,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,26,16,NULL,1,0,0,0),(18,200,1,32,4,NULL,NULL,NULL,NULL,0,0,'Glancer',0,26,16,NULL,1,0,0,0),(19,200,1,32,4,NULL,NULL,NULL,NULL,0,0,'Glancer',0,26,16,NULL,1,0,0,0),(20,200,1,32,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,26,16,NULL,1,0,0,0),(21,200,1,32,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,26,16,NULL,1,0,0,0),(22,100,1,32,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,26,16,NULL,1,0,0,0),(23,100,1,32,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,26,16,NULL,1,0,0,0),(24,100,1,32,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,26,16,NULL,1,0,0,0),(25,100,1,32,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,3,27,NULL,1,0,0,0),(26,100,1,32,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,3,27,NULL,1,0,0,0),(27,100,1,32,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,3,27,NULL,1,0,0,0),(28,100,1,32,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,3,27,NULL,1,0,0,0),(29,100,1,32,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,3,27,NULL,1,0,0,0),(30,200,1,32,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,3,27,NULL,1,0,0,0),(31,200,1,32,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,3,27,NULL,1,0,0,0),(32,100,1,32,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,28,24,NULL,1,0,0,0),(33,100,1,32,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,28,24,NULL,1,0,0,0),(34,100,1,32,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,28,24,NULL,1,0,0,0),(35,100,1,32,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,28,24,NULL,1,0,0,0),(36,100,1,32,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,28,24,NULL,1,0,0,0),(37,200,1,32,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,28,24,NULL,1,0,0,0),(38,200,1,32,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,28,24,NULL,1,0,0,0),(39,100,1,32,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,18,25,NULL,1,0,0,0),(40,100,1,32,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,18,25,NULL,1,0,0,0),(41,100,1,32,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,18,25,NULL,1,0,0,0),(42,100,1,32,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,18,25,NULL,1,0,0,0),(43,100,1,32,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,18,25,NULL,1,0,0,0),(44,200,1,32,4,NULL,NULL,NULL,NULL,0,0,'Glancer',0,18,25,NULL,1,0,0,0),(45,200,1,32,4,NULL,NULL,NULL,NULL,0,0,'Glancer',0,18,25,NULL,1,0,0,0),(46,200,1,32,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,18,25,NULL,1,0,0,0),(47,200,1,32,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,18,25,NULL,1,0,0,0),(48,100,1,32,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,18,25,NULL,1,0,0,0),(49,100,1,32,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,18,25,NULL,1,0,0,0),(50,100,1,32,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,18,25,NULL,1,0,0,0),(51,100,1,32,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,15,26,NULL,1,0,0,0),(52,100,1,32,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,15,26,NULL,1,0,0,0),(53,100,1,32,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,15,26,NULL,1,0,0,0),(54,100,1,32,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,15,26,NULL,1,0,0,0),(55,100,1,32,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,15,26,NULL,1,0,0,0),(56,200,1,32,4,NULL,NULL,NULL,NULL,0,0,'Glancer',0,15,26,NULL,1,0,0,0),(57,200,1,32,4,NULL,NULL,NULL,NULL,0,0,'Glancer',0,15,26,NULL,1,0,0,0),(58,200,1,32,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,15,26,NULL,1,0,0,0),(59,200,1,32,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,15,26,NULL,1,0,0,0),(60,100,1,32,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,15,26,NULL,1,0,0,0),(61,100,1,32,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,15,26,NULL,1,0,0,0),(62,100,1,32,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,15,26,NULL,1,0,0,0),(63,100,1,32,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,7,28,NULL,1,0,0,0),(64,100,1,32,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,7,28,NULL,1,0,0,0),(65,100,1,32,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,7,28,NULL,1,0,0,0),(66,100,1,32,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,7,28,NULL,1,0,0,0),(67,100,1,32,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,7,28,NULL,1,0,0,0),(68,200,1,32,4,NULL,NULL,NULL,NULL,0,0,'Glancer',0,7,28,NULL,1,0,0,0),(69,200,1,32,4,NULL,NULL,NULL,NULL,0,0,'Glancer',0,7,28,NULL,1,0,0,0),(70,200,1,32,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,7,28,NULL,1,0,0,0),(71,200,1,32,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,7,28,NULL,1,0,0,0),(72,100,1,32,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,7,28,NULL,1,0,0,0),(73,100,1,32,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,7,28,NULL,1,0,0,0),(74,100,1,32,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,7,28,NULL,1,0,0,0),(75,100,1,32,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,24,24,NULL,1,0,0,0),(76,100,1,32,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,24,24,NULL,1,0,0,0),(77,100,1,32,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,24,24,NULL,1,0,0,0),(78,100,1,32,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,24,24,NULL,1,0,0,0),(79,100,1,32,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,24,24,NULL,1,0,0,0),(80,200,1,32,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,24,24,NULL,1,0,0,0),(81,200,1,32,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,24,24,NULL,1,0,0,0),(82,100,1,32,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,0,28,NULL,1,0,0,0),(83,100,1,32,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,0,28,NULL,1,0,0,0),(84,100,1,32,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,0,28,NULL,1,0,0,0),(85,100,1,32,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,0,28,NULL,1,0,0,0),(86,100,1,32,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,0,28,NULL,1,0,0,0),(87,200,1,32,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,0,28,NULL,1,0,0,0),(88,200,1,32,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,0,28,NULL,1,0,0,0),(89,100,1,32,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,22,27,NULL,1,0,0,0),(90,100,1,32,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,22,27,NULL,1,0,0,0),(91,100,1,32,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,22,27,NULL,1,0,0,0),(92,100,1,32,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,22,27,NULL,1,0,0,0),(93,100,1,32,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,22,27,NULL,1,0,0,0),(94,200,1,32,4,NULL,NULL,NULL,NULL,0,0,'Glancer',0,22,27,NULL,1,0,0,0),(95,200,1,32,4,NULL,NULL,NULL,NULL,0,0,'Glancer',0,22,27,NULL,1,0,0,0),(96,200,1,32,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,22,27,NULL,1,0,0,0),(97,200,1,32,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,22,27,NULL,1,0,0,0),(98,100,1,32,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,22,27,NULL,1,0,0,0),(99,100,1,32,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,22,27,NULL,1,0,0,0),(100,100,1,32,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,22,27,NULL,1,0,0,0),(101,100,1,32,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,25,20,NULL,1,0,0,0),(102,100,1,32,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,25,20,NULL,1,0,0,0),(103,100,1,32,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,25,20,NULL,1,0,0,0),(104,100,1,32,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,25,20,NULL,1,0,0,0),(105,100,1,32,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,25,20,NULL,1,0,0,0),(106,200,1,32,4,NULL,NULL,NULL,NULL,0,0,'Glancer',0,25,20,NULL,1,0,0,0),(107,200,1,32,4,NULL,NULL,NULL,NULL,0,0,'Glancer',0,25,20,NULL,1,0,0,0),(108,200,1,32,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,25,20,NULL,1,0,0,0),(109,200,1,32,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,25,20,NULL,1,0,0,0),(110,100,1,32,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,25,20,NULL,1,0,0,0),(111,100,1,32,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,25,20,NULL,1,0,0,0),(112,100,1,32,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,25,20,NULL,1,0,0,0),(113,100,1,32,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,12,27,NULL,1,0,0,0),(114,100,1,32,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,12,27,NULL,1,0,0,0),(115,100,1,32,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,12,27,NULL,1,0,0,0),(116,100,1,32,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,12,27,NULL,1,0,0,0),(117,100,1,32,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,12,27,NULL,1,0,0,0),(118,200,1,32,4,NULL,NULL,NULL,NULL,0,0,'Glancer',0,12,27,NULL,1,0,0,0),(119,200,1,32,4,NULL,NULL,NULL,NULL,0,0,'Glancer',0,12,27,NULL,1,0,0,0),(120,200,1,32,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,12,27,NULL,1,0,0,0),(121,200,1,32,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,12,27,NULL,1,0,0,0),(122,100,1,32,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,12,27,NULL,1,0,0,0),(123,100,1,32,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,12,27,NULL,1,0,0,0),(124,100,1,32,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,12,27,NULL,1,0,0,0),(125,100,1,32,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,26,27,NULL,1,0,0,0),(126,100,1,32,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,26,27,NULL,1,0,0,0),(127,100,1,32,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,26,27,NULL,1,0,0,0),(128,100,1,32,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,26,27,NULL,1,0,0,0),(129,100,1,32,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,26,27,NULL,1,0,0,0),(130,200,1,32,4,NULL,NULL,NULL,NULL,0,0,'Glancer',0,26,27,NULL,1,0,0,0),(131,200,1,32,4,NULL,NULL,NULL,NULL,0,0,'Glancer',0,26,27,NULL,1,0,0,0),(132,200,1,32,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,26,27,NULL,1,0,0,0),(133,200,1,32,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,26,27,NULL,1,0,0,0),(134,100,1,32,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,26,27,NULL,1,0,0,0),(135,100,1,32,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,26,27,NULL,1,0,0,0),(136,100,1,32,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,26,27,NULL,1,0,0,0);
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

-- Dump completed on 2010-10-08  9:36:41
