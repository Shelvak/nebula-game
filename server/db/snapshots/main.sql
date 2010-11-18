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
  `x` tinyint(2) unsigned NOT NULL default '0',
  `y` tinyint(2) unsigned NOT NULL default '0',
  `armor_mod` int(11) NOT NULL,
  `constructor_mod` int(11) NOT NULL,
  `energy_mod` int(11) NOT NULL,
  `level` tinyint(2) unsigned NOT NULL default '0',
  `type` varchar(255) NOT NULL,
  `upgrade_ends_at` datetime default NULL,
  `x_end` tinyint(2) unsigned NOT NULL default '0',
  `y_end` tinyint(2) unsigned NOT NULL default '0',
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
INSERT INTO `buildings` VALUES (1,2,7,16,0,0,0,1,'Thunder',NULL,8,17,NULL,1,300,NULL,0,NULL,NULL,0),(2,2,21,16,0,0,0,1,'Thunder',NULL,22,17,NULL,1,300,NULL,0,NULL,NULL,0),(3,2,21,9,0,0,0,1,'Screamer',NULL,22,10,NULL,1,300,NULL,0,NULL,NULL,0),(4,2,18,28,0,0,0,1,'NpcSolarPlant',NULL,19,29,NULL,0,1000,NULL,0,NULL,NULL,0),(5,2,7,9,0,0,0,1,'Vulcan',NULL,8,10,NULL,1,300,NULL,0,NULL,NULL,0),(6,2,14,22,0,0,0,1,'Thunder',NULL,15,23,NULL,1,300,NULL,0,NULL,NULL,0),(7,2,26,16,0,0,0,1,'NpcZetiumExtractor',NULL,27,17,NULL,0,800,NULL,0,NULL,NULL,0),(8,2,3,27,0,0,0,1,'NpcMetalExtractor',NULL,4,28,NULL,0,400,NULL,0,NULL,NULL,0),(9,2,28,24,0,0,0,1,'NpcMetalExtractor',NULL,29,25,NULL,0,400,NULL,0,NULL,NULL,0),(10,2,18,25,0,0,0,1,'NpcSolarPlant',NULL,19,26,NULL,0,1000,NULL,0,NULL,NULL,0),(11,2,15,26,0,0,0,1,'NpcSolarPlant',NULL,16,27,NULL,0,1000,NULL,0,NULL,NULL,0),(12,2,7,28,0,0,0,1,'NpcCommunicationsHub',NULL,9,29,NULL,0,1200,NULL,0,NULL,NULL,0),(13,2,21,22,0,0,0,1,'Vulcan',NULL,22,23,NULL,1,300,NULL,0,NULL,NULL,0),(14,2,24,24,0,0,0,1,'NpcMetalExtractor',NULL,25,25,NULL,0,400,NULL,0,NULL,NULL,0),(15,2,0,28,0,0,0,1,'NpcMetalExtractor',NULL,1,29,NULL,0,400,NULL,0,NULL,NULL,0),(16,2,11,14,0,0,0,1,'Mothership',NULL,18,19,NULL,1,10500,NULL,0,NULL,NULL,0),(17,2,22,27,0,0,0,1,'NpcSolarPlant',NULL,23,28,NULL,0,1000,NULL,0,NULL,NULL,0),(18,2,14,9,0,0,0,1,'Thunder',NULL,15,10,NULL,1,300,NULL,0,NULL,NULL,0),(19,2,25,20,0,0,0,1,'NpcTemple',NULL,27,22,NULL,0,1500,NULL,0,NULL,NULL,0),(20,2,12,27,0,0,0,1,'NpcSolarPlant',NULL,13,28,NULL,0,1000,NULL,0,NULL,NULL,0),(21,2,7,22,0,0,0,1,'Screamer',NULL,8,23,NULL,1,300,NULL,0,NULL,NULL,0),(22,2,26,27,0,0,0,1,'NpcCommunicationsHub',NULL,28,28,NULL,0,1200,NULL,0,NULL,NULL,0);
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
INSERT INTO `callbacks` VALUES ('Notification',1,'2010-11-21 21:27:18',4,'dev'),('Notification',2,'2010-11-21 21:27:18',4,'dev');
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
  `x` tinyint(2) unsigned NOT NULL default '0',
  `y` tinyint(2) unsigned NOT NULL default '0',
  `variation` tinyint(2) unsigned NOT NULL default '0',
  UNIQUE KEY `coords` (`planet_id`,`x`,`y`),
  CONSTRAINT `folliages_ibfk_1` FOREIGN KEY (`planet_id`) REFERENCES `planets` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `folliages`
--

LOCK TABLES `folliages` WRITE;
/*!40000 ALTER TABLE `folliages` DISABLE KEYS */;
INSERT INTO `folliages` VALUES (1,0,4,11),(1,1,12,12),(1,2,6,11),(1,2,7,3),(1,2,14,2),(1,3,31,2),(1,4,1,0),(1,5,19,6),(1,5,20,4),(1,6,5,4),(1,6,19,0),(1,7,13,2),(1,7,21,7),(1,8,11,5),(1,8,25,9),(1,9,0,6),(1,9,31,9),(1,10,1,9),(1,10,9,0),(1,10,27,10),(1,10,31,3),(1,11,2,2),(1,11,16,13),(1,11,17,13),(1,11,27,1),(1,11,30,11),(1,11,31,10),(1,12,1,2),(1,12,2,5),(1,12,10,10),(1,12,17,3),(1,12,29,10),(1,12,30,11),(1,13,3,0),(1,13,16,6),(1,13,17,4),(1,14,3,3),(1,14,4,8),(1,14,23,0),(1,14,24,7),(1,14,27,13),(1,14,29,0),(1,15,7,3),(1,15,10,7),(1,15,14,13),(1,15,24,1),(1,16,7,6),(1,16,8,9),(1,16,15,5),(1,16,24,4),(1,17,3,3),(1,17,4,2),(1,17,13,10),(1,17,19,8),(1,17,20,1),(1,17,23,12),(1,17,24,10),(1,17,28,4),(1,18,5,4),(1,18,12,3),(1,18,16,0),(1,18,18,7),(1,18,20,9),(1,18,23,3),(1,18,26,11),(1,18,28,5),(1,18,31,4),(1,19,4,9),(1,19,18,4),(1,19,20,10),(1,19,21,6),(1,19,25,13),(1,19,29,10),(1,19,31,5),(1,20,5,5),(1,20,26,11),(1,20,29,2),(1,21,13,8),(1,21,20,5),(1,21,24,12),(1,21,27,12),(1,22,1,8),(1,22,4,9),(1,22,13,4),(1,22,17,9),(1,22,20,9),(1,22,24,9),(1,22,27,9),(1,22,29,5),(1,23,2,6),(1,23,21,12),(1,23,22,12),(1,23,24,11),(1,23,25,13),(1,23,29,4),(1,23,31,4),(1,24,14,7),(1,24,24,8),(1,24,29,11),(1,24,30,5),(1,24,31,4),(1,25,14,13),(1,25,18,13),(1,25,19,2),(1,25,24,0),(1,25,25,3),(1,25,30,9),(1,25,31,5),(1,26,8,0),(1,26,20,3),(1,26,31,13),(1,27,4,10),(1,27,8,3),(1,27,21,8),(1,27,22,3),(1,27,26,13),(1,28,24,0),(1,28,26,0),(1,29,11,10),(1,29,25,5),(1,30,3,9),(1,30,12,13),(1,31,0,0),(1,31,25,8),(1,32,0,12),(1,32,11,13),(1,32,18,1),(1,32,28,3),(1,33,12,13),(1,33,13,3),(1,33,20,13),(1,33,28,13),(1,33,29,6),(1,33,30,1),(1,33,31,3),(1,34,13,5),(1,34,15,1),(1,35,2,8),(1,35,8,13),(1,35,28,12),(1,36,3,11),(1,36,4,3),(1,36,8,0),(1,36,9,9),(1,36,12,1),(1,36,30,1),(1,36,31,1),(1,37,0,4),(1,37,27,5),(1,37,28,4),(1,37,29,13),(1,38,9,8),(1,38,10,2),(1,38,30,0),(1,38,31,9),(1,39,0,1),(1,39,3,2),(1,39,26,1),(1,39,29,12),(1,40,3,11),(1,40,14,1),(1,41,5,7),(1,41,6,12),(1,41,15,5),(1,41,16,1),(1,41,18,1),(1,41,29,1),(1,41,31,12),(1,42,2,10),(1,42,3,7),(1,42,18,11),(1,42,19,3),(1,42,29,10),(1,43,3,1),(1,43,4,1),(1,43,7,12),(1,43,8,6),(1,43,17,0),(1,43,29,12),(1,44,11,4),(1,44,22,4),(1,44,27,11),(2,0,13,9),(2,1,11,4),(2,1,15,8),(2,2,10,10),(2,4,9,13),(2,4,10,4),(2,4,14,12),(2,4,15,5),(2,4,19,12),(2,5,15,7),(2,5,22,13),(2,5,24,12),(2,6,1,12),(2,6,4,8),(2,6,8,8),(2,6,15,4),(2,6,17,12),(2,6,28,11),(2,8,0,12),(2,8,14,10),(2,8,24,2),(2,8,25,12),(2,9,7,9),(2,9,9,5),(2,9,11,12),(2,9,21,0),(2,9,23,13),(2,9,24,11),(2,10,10,7),(2,10,16,8),(2,10,18,13),(2,10,21,1),(2,10,28,4),(2,11,7,2),(2,11,10,10),(2,11,12,9),(2,12,0,4),(2,12,8,8),(2,12,9,3),(2,12,11,11),(2,12,12,10),(2,12,13,1),(2,12,26,5),(2,13,5,4),(2,13,10,13),(2,13,11,11),(2,13,13,5),(2,13,20,5),(2,13,22,7),(2,14,5,13),(2,14,6,6),(2,14,12,2),(2,14,21,12),(2,14,24,9),(2,15,0,1),(2,15,4,10),(2,15,21,4),(2,16,1,9),(2,16,4,7),(2,16,10,6),(2,16,24,12),(2,17,4,2),(2,17,9,5),(2,17,23,2),(2,17,24,5),(2,18,3,10),(2,18,20,8),(2,19,10,11),(2,19,11,0),(2,19,12,8),(2,19,16,0),(2,19,22,9),(2,20,2,0),(2,20,3,1),(2,20,4,8),(2,20,9,6),(2,20,16,9),(2,20,21,7),(2,21,1,8),(2,21,8,11),(2,21,11,11),(2,21,13,6),(2,21,14,6),(2,21,19,7),(2,21,20,11),(2,22,12,8),(2,22,20,1),(2,22,24,6),(2,22,26,2),(2,23,9,12),(2,23,12,6),(2,23,13,12),(2,24,5,12),(2,24,10,8),(2,24,13,7),(2,24,14,4),(2,24,23,11),(2,24,26,5),(2,25,1,2),(2,25,4,0),(2,25,16,4),(2,25,26,4),(2,25,28,2),(2,26,13,10),(2,26,14,5),(2,26,26,12),(2,27,0,12),(2,27,2,3),(2,27,3,11),(2,27,13,4),(2,27,25,3),(2,27,29,12),(2,28,15,5),(2,28,18,1),(2,29,1,4),(2,29,14,8),(2,29,15,3),(2,29,23,0),(2,29,27,5),(5,0,4,4),(5,0,22,8),(5,0,23,12),(5,0,24,8),(5,0,25,0),(5,1,2,13),(5,1,3,9),(5,1,15,4),(5,1,20,6),(5,1,30,0),(5,2,21,10),(5,2,22,0),(5,3,4,7),(5,3,21,0),(5,3,24,1),(5,3,25,10),(5,3,30,0),(5,4,0,4),(5,4,1,4),(5,4,3,12),(5,4,5,11),(5,4,10,5),(5,4,12,1),(5,4,26,9),(5,4,27,9),(5,4,30,6),(5,5,5,1),(5,5,8,12),(5,5,26,10),(5,5,27,11),(5,6,5,12),(5,6,24,6),(5,6,25,10),(5,6,27,7),(5,7,8,1),(5,7,9,11),(5,7,14,3),(5,8,5,7),(5,8,9,7),(5,8,16,7),(5,8,17,0),(5,8,18,8),(5,8,27,2),(5,8,28,5),(5,9,9,0),(5,9,10,12),(5,9,25,2),(5,10,13,9),(5,10,21,12),(5,10,27,0),(5,11,9,13),(5,11,22,3),(5,12,9,0),(5,12,15,2),(5,12,27,4),(5,13,1,6),(5,13,17,3),(5,13,24,0),(5,13,25,3),(5,13,29,13),(5,14,1,12),(5,14,15,12),(5,14,17,4),(5,14,18,8),(5,14,27,2),(5,14,29,6),(5,15,7,3),(5,15,19,13),(5,15,30,13),(5,16,28,0),(5,17,25,3),(5,17,28,5),(5,17,30,0),(5,18,12,7),(5,18,21,3),(5,18,25,0),(5,18,29,11),(5,19,1,7),(5,19,15,13),(5,19,17,9),(5,19,21,0),(5,19,29,1),(5,20,18,0),(5,21,1,11),(5,21,30,4),(5,22,15,12),(5,23,14,4),(5,23,16,3),(5,23,18,3),(5,23,24,8),(5,23,26,9),(5,23,28,5),(5,23,29,6),(5,24,17,5),(5,24,18,5),(5,24,22,5),(5,24,24,2),(5,25,14,11),(5,25,15,4),(5,25,16,7),(5,25,23,5),(5,25,24,4),(5,25,26,6),(5,25,27,10),(5,26,4,3),(5,26,14,12),(5,26,21,3),(5,26,25,8),(5,26,30,12),(8,0,20,5),(8,0,29,0),(8,0,32,12),(8,0,33,11),(8,0,34,12),(8,1,0,6),(8,1,24,0),(8,2,0,10),(8,2,1,8),(8,2,7,11),(8,2,28,7),(8,2,32,0),(8,2,33,6),(8,3,8,4),(8,3,22,7),(8,3,25,11),(8,3,27,1),(8,3,32,11),(8,4,8,1),(8,4,11,3),(8,4,13,8),(8,4,20,0),(8,4,23,10),(8,4,34,5),(8,5,1,5),(8,5,2,12),(8,5,28,13),(8,5,32,2),(8,5,33,7),(8,6,1,12),(8,6,7,3),(8,6,13,2),(8,6,19,9),(8,6,25,4),(8,6,26,13),(8,6,27,3),(8,6,29,5),(8,6,30,12),(8,6,33,1),(8,7,3,1),(8,7,8,13),(8,7,9,10),(8,7,16,4),(8,7,20,2),(8,7,21,8),(8,7,23,4),(8,7,25,12),(8,7,27,4),(8,8,4,7),(8,8,7,10),(8,8,12,1),(8,8,18,3),(8,8,19,5),(8,8,24,2),(8,8,25,9),(8,8,34,1),(8,9,0,13),(8,9,4,2),(8,9,6,5),(8,9,8,7),(8,9,13,8),(8,9,20,8),(8,9,22,10),(8,9,29,0),(8,9,30,4),(8,10,2,6),(8,10,19,12),(8,10,29,5),(8,11,0,10),(8,11,1,11),(8,11,2,9),(8,11,4,1),(8,11,5,3),(8,11,19,9),(8,11,20,4),(8,11,21,13),(8,11,28,3),(8,11,32,6),(8,12,2,2),(8,12,3,8),(8,12,4,2),(8,12,6,9),(8,12,11,1),(8,12,25,5),(8,13,6,3),(8,13,26,12),(8,13,29,0),(8,13,31,5),(8,13,34,7),(8,14,2,9),(8,14,7,2),(8,14,13,7),(8,14,16,10),(8,14,21,9),(8,14,22,10),(8,14,25,10),(8,14,30,2),(8,14,31,2),(8,15,0,10),(8,15,20,4),(8,15,21,5),(8,15,23,6),(8,15,30,4),(8,15,31,5),(8,16,3,12),(8,16,15,13),(8,16,25,10),(8,16,34,0),(8,17,3,6),(8,17,4,5),(8,18,26,7),(8,18,33,10),(8,19,2,2),(8,19,12,7),(8,20,3,3),(8,20,4,7),(8,20,33,0),(8,21,0,5),(8,21,1,0),(8,21,3,3),(8,21,12,6),(8,21,13,1),(8,21,14,2),(8,22,11,13),(8,22,13,2),(8,23,18,12),(8,24,0,1),(8,24,16,13),(8,25,9,1),(8,26,1,5),(8,26,2,10),(8,27,3,11),(8,27,19,8),(8,27,27,5),(8,28,17,12),(8,29,19,2),(8,29,20,5),(8,31,9,1),(8,31,10,6),(8,32,23,4),(8,32,31,9),(8,33,6,12),(8,33,7,7),(8,33,9,6),(8,33,13,10),(8,34,5,5),(8,34,6,9),(8,34,9,4),(8,34,10,10),(8,34,22,10),(8,34,32,9),(8,34,34,2),(23,0,23,2),(23,0,33,8),(23,0,38,2),(23,1,31,9),(23,1,34,8),(23,1,36,4),(23,1,40,4),(23,2,16,1),(23,3,5,3),(23,3,19,4),(23,3,22,5),(23,3,24,6),(23,3,36,12),(23,3,40,4),(23,4,4,0),(23,4,10,7),(23,4,21,9),(23,6,6,1),(23,6,13,11),(23,6,33,2),(23,7,15,8),(23,7,32,11),(23,8,26,1),(23,8,29,3),(23,8,31,3),(23,9,28,5),(23,9,36,0),(23,10,33,6),(23,11,28,13),(23,11,34,6),(23,12,7,12),(23,12,31,7),(23,12,35,8),(23,12,38,4),(23,13,15,5),(23,13,25,7),(23,13,33,5),(23,14,6,9),(23,14,7,13),(23,14,8,2),(23,14,15,1),(23,14,16,12),(23,14,32,9),(23,15,9,11),(23,15,13,5),(23,15,17,2),(23,15,33,6),(23,16,6,12),(23,16,10,9),(23,16,17,1),(23,16,26,10),(23,16,27,5),(23,16,34,3),(23,16,39,12),(23,16,40,0),(23,17,11,4),(23,17,12,8),(23,17,33,10),(23,17,37,1),(23,17,39,12),(23,18,3,0),(23,18,15,2),(23,19,40,8),(23,20,2,7),(23,20,24,6),(23,20,26,4),(23,20,35,11),(23,21,3,13),(23,21,4,13),(23,21,5,5),(23,21,12,9),(23,21,27,1),(23,21,36,9),(23,21,38,2),(23,21,39,11),(23,22,3,4),(23,22,15,6),(23,22,19,9),(23,22,37,1),(23,23,2,1),(23,23,3,9),(23,23,5,11),(23,23,15,3),(23,23,18,3),(23,23,20,10),(23,23,21,1),(23,23,26,4),(23,23,36,1),(23,23,38,3),(23,23,39,13),(23,23,40,13),(25,0,7,3),(25,0,10,13),(25,0,14,5),(25,0,15,10),(25,0,17,5),(25,0,18,5),(25,1,2,8),(25,1,3,3),(25,1,5,8),(25,1,6,12),(25,1,13,5),(25,1,18,8),(25,2,2,8),(25,2,4,4),(25,3,4,1),(25,3,11,4),(25,4,15,6),(25,7,13,3),(25,7,17,3),(25,7,18,8),(25,8,8,12),(25,8,17,3),(25,10,9,11),(25,10,11,5),(25,10,13,11),(25,10,16,3),(25,11,12,7),(25,13,8,11),(25,13,12,12),(25,13,14,13),(25,13,17,0),(25,14,1,8),(25,14,18,7),(25,15,9,12),(25,15,12,10),(25,15,15,12),(25,16,7,12),(25,16,11,13),(25,16,13,0),(25,16,16,12),(25,17,2,8),(25,17,3,12),(25,17,9,0),(25,17,15,7),(25,17,18,13),(25,18,2,5),(25,18,10,9),(25,19,8,11),(25,19,10,5),(25,20,10,1),(25,20,18,10),(25,21,5,13),(25,21,10,8),(25,21,11,7),(25,22,4,11),(25,22,17,7),(25,24,11,2),(25,24,12,3),(25,24,16,3),(25,25,13,2),(25,25,14,4),(25,25,16,2),(25,26,12,8),(25,26,13,6),(25,26,15,10),(25,27,8,8),(25,27,13,2),(25,28,4,12),(25,28,5,5),(25,28,8,3),(25,28,9,7),(25,28,10,3),(25,28,16,2),(25,28,18,3),(25,29,15,11),(25,29,17,3),(25,29,18,0),(25,30,14,5),(25,30,17,2),(25,31,14,11),(25,32,17,13),(25,33,5,5),(25,33,11,11),(25,33,15,7),(25,34,14,8),(25,35,15,5),(25,35,16,13),(25,35,18,3),(25,36,8,9),(25,36,17,9),(25,37,14,0),(25,38,4,8),(25,38,18,5),(25,40,12,4),(25,40,18,12),(25,41,5,3),(25,41,11,7),(25,42,13,2),(26,0,15,10),(26,0,19,9),(26,0,21,9),(26,0,25,8),(26,0,29,0),(26,0,31,8),(26,1,6,6),(26,1,8,5),(26,1,9,13),(26,1,12,8),(26,1,21,5),(26,1,32,6),(26,2,8,3),(26,2,10,9),(26,2,11,5),(26,2,12,3),(26,2,13,11),(26,3,7,8),(26,3,8,7),(26,3,11,11),(26,3,26,7),(26,4,3,6),(26,4,7,10),(26,4,8,10),(26,4,15,12),(26,4,16,11),(26,4,22,5),(26,4,23,2),(26,5,3,10),(26,5,21,9),(26,5,22,4),(26,5,23,10),(26,5,29,5),(26,6,3,6),(26,6,5,1),(26,6,7,3),(26,6,30,7),(26,7,2,12),(26,7,3,1),(26,7,7,1),(26,7,29,6),(26,8,11,12),(26,8,29,3),(26,8,30,10),(26,8,32,12),(26,9,2,1),(26,9,10,10),(26,9,11,5),(26,10,1,11),(26,10,4,6),(26,11,2,6),(26,11,3,5),(26,11,32,8),(26,13,0,6),(26,14,0,6),(26,14,4,12),(26,14,6,0),(26,14,8,9),(26,15,5,6),(26,15,6,10),(26,15,25,11),(26,15,26,0),(26,15,29,2),(26,15,30,1),(26,15,31,10),(26,16,1,8),(26,16,14,6),(26,16,30,11),(26,16,32,4),(26,17,13,1),(26,17,14,3),(26,17,16,12),(26,17,25,2),(26,17,27,9),(26,18,3,0),(26,18,5,0),(26,18,8,2),(26,18,10,12),(26,18,11,7),(26,18,14,6),(26,19,3,13),(26,19,5,7),(26,19,9,7),(26,19,13,5),(26,19,14,2),(26,19,16,13),(26,19,32,10),(26,20,0,13),(26,20,2,5),(26,20,7,0),(26,20,11,5),(26,20,13,3),(26,20,29,3),(26,21,1,3),(26,21,3,0),(26,21,4,4),(26,21,13,0),(26,21,15,9),(26,21,16,2),(26,21,17,8),(26,21,18,9),(26,21,29,1),(26,22,1,7),(26,22,10,11),(26,22,11,11),(26,22,13,13),(26,22,14,4),(26,22,16,3),(26,23,4,0),(26,23,11,11),(26,23,12,6),(26,23,13,6),(26,23,14,0),(26,23,15,1),(26,23,21,12),(26,24,14,4),(26,24,16,10),(26,24,22,8),(26,24,24,7),(26,25,10,13),(26,25,27,5),(26,25,30,0),(26,26,9,4),(26,26,13,6),(26,26,22,13),(26,26,24,0),(26,26,26,0),(26,26,29,0),(26,26,31,7),(26,27,11,13),(26,27,12,11),(26,28,11,2),(26,28,14,6),(26,28,15,12),(26,28,16,4),(26,28,28,4),(26,28,30,5),(26,29,14,13),(26,29,16,1),(26,29,31,3),(26,30,14,6),(26,30,21,4),(26,31,30,10),(26,31,31,11),(28,0,0,9),(28,0,14,6),(28,0,20,13),(28,0,21,9),(28,0,22,7),(28,0,27,10),(28,1,5,8),(28,1,12,5),(28,1,27,6),(28,2,0,10),(28,2,7,11),(28,3,0,6),(28,3,1,6),(28,3,18,0),(28,3,20,1),(28,3,24,13),(28,3,25,0),(28,3,27,6),(28,4,0,6),(28,4,9,2),(28,4,11,3),(28,4,24,2),(28,5,10,0),(28,6,1,12),(28,6,3,4),(28,6,26,1),(28,7,1,13),(28,7,6,2),(28,7,11,0),(28,8,0,8),(28,8,4,9),(28,8,5,9),(28,9,5,12),(28,10,4,7),(28,10,14,4),(28,10,16,1),(28,11,2,1),(28,11,11,13),(28,11,17,6),(28,12,1,11),(28,12,3,13),(28,12,9,2),(28,12,13,11),(28,12,28,6),(28,13,1,12),(28,13,8,2),(28,13,11,0),(28,13,14,2),(28,13,27,4),(28,14,2,4),(28,14,5,1),(28,14,6,5),(28,14,10,11),(28,14,13,5),(28,14,14,13),(28,14,19,4),(28,15,1,3),(28,15,3,4),(28,15,4,4),(28,15,7,0),(28,15,9,3),(28,15,12,8),(28,15,13,8),(28,15,28,0),(28,16,1,13),(28,16,3,11),(28,16,7,3),(28,16,16,1),(28,16,24,6),(28,16,25,7),(28,17,0,1),(28,17,4,6),(28,17,8,12),(28,17,9,5),(28,17,25,1),(28,18,6,5),(28,18,17,7),(28,18,24,6),(28,19,6,11),(28,19,16,9),(28,19,28,6),(28,20,17,1),(28,20,27,2),(28,21,23,2),(28,22,1,7),(28,22,3,3),(28,22,4,11),(28,22,5,12),(28,22,6,8),(28,22,7,9),(28,22,8,3),(28,22,10,3),(28,23,4,7),(28,23,20,3),(28,23,23,11),(28,24,0,0),(28,24,2,7),(28,24,6,8),(28,25,3,0),(28,26,18,1),(28,26,26,7),(28,26,28,0),(28,27,4,7),(28,27,14,6),(28,27,25,12),(28,28,1,4),(28,28,3,6),(28,28,6,10),(28,28,24,6),(28,28,25,0),(28,29,0,13),(28,29,4,1),(28,29,12,4),(28,29,17,0),(28,29,19,6),(28,29,20,2),(28,29,22,12),(28,29,27,11),(28,29,28,9),(28,30,4,3),(28,30,6,10),(28,30,9,2),(28,30,21,7),(28,30,22,13),(28,30,28,3),(28,31,0,2),(28,31,7,0),(28,31,8,10),(28,31,19,4),(28,31,23,0),(28,31,24,8),(28,31,28,11),(28,32,5,1),(28,32,8,7),(28,32,11,6),(28,32,20,0),(28,32,21,3),(28,32,27,9),(28,33,3,9),(28,33,10,2),(28,33,27,4),(34,0,0,10),(34,0,2,1),(34,0,3,1),(34,0,9,12),(34,0,12,0),(34,0,25,12),(34,0,30,13),(34,0,35,0),(34,0,40,3),(34,1,3,9),(34,1,8,10),(34,1,12,3),(34,1,13,6),(34,1,15,5),(34,1,17,10),(34,1,30,1),(34,1,34,11),(34,1,37,8),(34,2,4,2),(34,2,7,10),(34,2,16,13),(34,2,17,0),(34,2,19,5),(34,3,0,2),(34,3,1,5),(34,3,3,11),(34,3,8,12),(34,3,17,4),(34,3,18,5),(34,3,19,5),(34,3,37,8),(34,3,43,8),(34,4,1,13),(34,4,6,5),(34,4,7,7),(34,4,9,6),(34,4,36,2),(34,4,43,1),(34,5,9,8),(34,5,23,13),(34,5,35,8),(34,5,36,7),(34,5,40,6),(34,6,0,1),(34,6,12,5),(34,6,17,2),(34,6,22,13),(34,6,31,8),(34,6,35,0),(34,6,42,10),(34,7,7,4),(34,7,16,0),(34,7,17,11),(34,7,21,0),(34,7,24,7),(34,7,31,3),(34,7,32,7),(34,7,33,5),(34,7,43,6),(34,8,20,3),(34,8,22,11),(34,8,25,12),(34,8,39,0),(34,9,12,4),(34,9,16,12),(34,9,17,2),(34,9,20,2),(34,9,26,13),(34,9,36,2),(34,10,0,2),(34,10,18,4),(34,10,21,6),(34,10,27,4),(34,10,35,8),(34,10,36,10),(34,11,29,13),(34,11,33,7),(34,12,15,7),(34,12,18,12),(34,12,36,0),(34,13,19,7),(34,13,20,0),(34,13,32,4),(34,14,3,1),(34,14,18,4),(34,14,36,2),(34,15,0,11),(34,15,21,0),(34,15,23,10),(34,15,32,6),(34,16,6,12),(34,16,18,6),(34,16,30,7),(34,16,32,10),(34,17,16,0),(34,17,19,1),(34,17,32,11),(34,18,36,13),(34,19,18,7),(34,19,19,7),(34,19,21,2),(34,19,27,11),(34,20,17,5),(34,20,21,4),(34,20,27,9),(34,20,28,13),(34,20,31,10),(34,20,32,10),(34,20,36,0),(34,20,39,7),(34,20,40,6),(34,22,20,3),(34,22,28,13),(34,22,33,10),(34,22,34,10),(34,22,37,7),(34,23,18,11),(34,23,33,1),(34,23,37,6),(34,24,24,2),(34,24,25,12),(34,24,28,8),(34,24,30,11),(34,24,31,10),(34,24,32,6),(34,25,20,6),(34,26,1,0),(34,26,2,6),(34,26,18,7),(34,26,25,4),(34,26,32,9),(34,26,37,7),(34,26,41,10),(34,27,1,0),(34,27,2,0),(34,27,10,0),(34,27,17,2),(34,27,21,10),(34,27,25,9),(34,27,31,1),(34,27,34,2),(34,27,36,11),(34,28,12,11),(34,28,17,10),(34,28,24,6),(34,28,32,3),(34,28,37,2),(34,29,3,11),(34,29,9,13),(34,29,10,1),(34,29,14,3),(34,29,22,2),(34,29,30,10),(34,29,40,6),(34,29,41,7);
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
INSERT INTO `fow_ss_entries` VALUES (1,1,1,2,1,0,0,0,NULL,NULL,NULL,NULL,NULL),(2,2,1,1,0,0,0,0,NULL,NULL,NULL,NULL,NULL),(3,3,1,1,0,0,0,0,NULL,NULL,NULL,NULL,NULL),(4,4,1,1,0,0,0,0,NULL,NULL,NULL,NULL,NULL);
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
  `ruleset` varchar(30) NOT NULL default '0',
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `galaxies`
--

LOCK TABLES `galaxies` WRITE;
/*!40000 ALTER TABLE `galaxies` DISABLE KEYS */;
INSERT INTO `galaxies` VALUES (1,'2010-11-07 21:27:07','dev');
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
INSERT INTO `notifications` VALUES (1,1,'2010-11-07 21:27:18','2010-11-21 21:27:18',3,'--- \n:id: 1\n',0,0),(2,1,'2010-11-07 21:27:18','2010-11-21 21:27:18',3,'--- \n:id: 2\n',0,0);
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
) ENGINE=InnoDB AUTO_INCREMENT=36 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `planets`
--

LOCK TABLES `planets` WRITE;
/*!40000 ALTER TABLE `planets` DISABLE KEYS */;
INSERT INTO `planets` VALUES (1,1,45,32,0,270,3,'Regular',NULL,'G1-S1-P1',61,NULL,NULL,NULL),(2,1,30,30,1,135,0,'Homeworld',1,'G1-S1-P2',34,NULL,NULL,NULL),(3,1,NULL,NULL,2,300,6,'Mining',NULL,'G1-S1-P3',40,142,304,178),(4,1,NULL,NULL,3,336,0,'Npc',NULL,'G1-S1-P4',43,NULL,NULL,NULL),(5,1,27,31,4,342,7,'Regular',NULL,'G1-S1-P5',46,NULL,NULL,NULL),(6,1,NULL,NULL,5,75,3,'Mining',NULL,'G1-S1-P6',27,382,372,239),(7,1,NULL,NULL,6,162,0,'Jumpgate',NULL,'G1-S1-P7',53,NULL,NULL,NULL),(8,2,35,35,0,270,6,'Regular',NULL,'G1-S2-P8',56,NULL,NULL,NULL),(9,2,NULL,NULL,1,315,2,'Jumpgate',NULL,'G1-S2-P9',35,NULL,NULL,NULL),(10,2,NULL,NULL,2,210,1,'Resource',NULL,'G1-S2-P10',47,223,332,149),(11,2,NULL,NULL,4,90,4,'Mining',NULL,'G1-S2-P11',51,280,378,205),(12,2,NULL,NULL,5,15,2,'Mining',NULL,'G1-S2-P12',49,271,222,356),(13,2,NULL,NULL,6,330,0,'Resource',NULL,'G1-S2-P13',59,137,231,250),(14,2,NULL,NULL,8,320,0,'Resource',NULL,'G1-S2-P14',44,211,352,386),(15,2,NULL,NULL,9,117,1,'Jumpgate',NULL,'G1-S2-P15',33,NULL,NULL,NULL),(16,2,NULL,NULL,10,302,0,'Npc',NULL,'G1-S2-P16',30,NULL,NULL,NULL),(17,2,NULL,NULL,11,42,2,'Resource',NULL,'G1-S2-P17',56,106,228,332),(18,2,NULL,NULL,12,300,3,'Mining',NULL,'G1-S2-P18',25,107,147,330),(19,3,NULL,NULL,0,180,0,'Jumpgate',NULL,'G1-S3-P19',51,NULL,NULL,NULL),(20,3,NULL,NULL,1,225,5,'Mining',NULL,'G1-S3-P20',45,292,191,359),(21,3,NULL,NULL,2,240,2,'Jumpgate',NULL,'G1-S3-P21',40,NULL,NULL,NULL),(22,3,NULL,NULL,3,246,4,'Mining',NULL,'G1-S3-P22',55,154,209,385),(23,3,24,41,4,90,4,'Regular',NULL,'G1-S3-P23',52,NULL,NULL,NULL),(24,3,NULL,NULL,5,255,1,'Jumpgate',NULL,'G1-S3-P24',49,NULL,NULL,NULL),(25,3,43,19,7,22,1,'Regular',NULL,'G1-S3-P25',49,NULL,NULL,NULL),(26,3,32,33,8,60,4,'Regular',NULL,'G1-S3-P26',52,NULL,NULL,NULL),(27,3,NULL,NULL,9,144,2,'Mining',NULL,'G1-S3-P27',48,353,400,259),(28,4,34,29,1,135,5,'Regular',NULL,'G1-S4-P28',50,NULL,NULL,NULL),(29,4,NULL,NULL,3,112,5,'Mining',NULL,'G1-S4-P29',32,131,280,186),(30,4,NULL,NULL,4,342,4,'Mining',NULL,'G1-S4-P30',57,381,379,379),(31,4,NULL,NULL,5,120,1,'Jumpgate',NULL,'G1-S4-P31',51,NULL,NULL,NULL),(32,4,NULL,NULL,6,270,1,'Jumpgate',NULL,'G1-S4-P32',35,NULL,NULL,NULL),(33,4,NULL,NULL,7,55,1,'Jumpgate',NULL,'G1-S4-P33',39,NULL,NULL,NULL),(34,4,30,44,8,90,8,'Regular',NULL,'G1-S4-P34',59,NULL,NULL,NULL),(35,4,NULL,NULL,9,117,4,'Mining',NULL,'G1-S4-P35',47,105,397,246);
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
) ENGINE=InnoDB AUTO_INCREMENT=36 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `resources_entries`
--

LOCK TABLES `resources_entries` WRITE;
/*!40000 ALTER TABLE `resources_entries` DISABLE KEYS */;
INSERT INTO `resources_entries` VALUES (1,0,0,0,0,0,0,0,0,0,NULL,0),(2,864,3024,1728,6048,0,604.8,0.02,0.04,0,'2010-11-07 21:27:14',0),(3,0,0,0,0,0,0,0,0,0,NULL,0),(4,0,0,0,0,0,0,0,0,0,NULL,0),(5,0,0,0,0,0,0,0,0,0,NULL,0),(6,0,0,0,0,0,0,0,0,0,NULL,0),(7,0,0,0,0,0,0,0,0,0,NULL,0),(8,0,0,0,0,0,0,0,0,0,NULL,0),(9,0,0,0,0,0,0,0,0,0,NULL,0),(10,0,0,0,0,0,0,0,0,0,NULL,0),(11,0,0,0,0,0,0,0,0,0,NULL,0),(12,0,0,0,0,0,0,0,0,0,NULL,0),(13,0,0,0,0,0,0,0,0,0,NULL,0),(14,0,0,0,0,0,0,0,0,0,NULL,0),(15,0,0,0,0,0,0,0,0,0,NULL,0),(16,0,0,0,0,0,0,0,0,0,NULL,0),(17,0,0,0,0,0,0,0,0,0,NULL,0),(18,0,0,0,0,0,0,0,0,0,NULL,0),(19,0,0,0,0,0,0,0,0,0,NULL,0),(20,0,0,0,0,0,0,0,0,0,NULL,0),(21,0,0,0,0,0,0,0,0,0,NULL,0),(22,0,0,0,0,0,0,0,0,0,NULL,0),(23,0,0,0,0,0,0,0,0,0,NULL,0),(24,0,0,0,0,0,0,0,0,0,NULL,0),(25,0,0,0,0,0,0,0,0,0,NULL,0),(26,0,0,0,0,0,0,0,0,0,NULL,0),(27,0,0,0,0,0,0,0,0,0,NULL,0),(28,0,0,0,0,0,0,0,0,0,NULL,0),(29,0,0,0,0,0,0,0,0,0,NULL,0),(30,0,0,0,0,0,0,0,0,0,NULL,0),(31,0,0,0,0,0,0,0,0,0,NULL,0),(32,0,0,0,0,0,0,0,0,0,NULL,0),(33,0,0,0,0,0,0,0,0,0,NULL,0),(34,0,0,0,0,0,0,0,0,0,NULL,0),(35,0,0,0,0,0,0,0,0,0,NULL,0);
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
INSERT INTO `solar_systems` VALUES (1,'Homeworld',1,0,0),(2,'Resource',1,-3,-1),(3,'Expansion',1,-1,2),(4,'Expansion',1,0,-2);
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
  `kind` tinyint(2) unsigned NOT NULL default '0',
  `planet_id` int(11) NOT NULL,
  `x` tinyint(2) unsigned NOT NULL default '0',
  `y` tinyint(2) unsigned NOT NULL default '0',
  PRIMARY KEY  (`id`),
  UNIQUE KEY `uniqueness` (`planet_id`,`x`,`y`),
  CONSTRAINT `tiles_ibfk_1` FOREIGN KEY (`planet_id`) REFERENCES `planets` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=3094 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tiles`
--

LOCK TABLES `tiles` WRITE;
/*!40000 ALTER TABLE `tiles` DISABLE KEYS */;
INSERT INTO `tiles` VALUES (1,9,1,0,0),(2,4,1,6,0),(3,4,1,7,0),(4,6,1,21,0),(5,6,1,22,0),(6,6,1,28,0),(7,4,1,5,1),(8,4,1,6,1),(9,4,1,8,1),(10,4,1,9,1),(11,6,1,21,1),(12,6,1,26,1),(13,6,1,27,1),(14,6,1,28,1),(15,6,1,29,1),(16,6,1,30,1),(17,6,1,31,1),(18,4,1,5,2),(19,4,1,6,2),(20,4,1,7,2),(21,4,1,8,2),(22,4,1,10,2),(23,6,1,21,2),(24,6,1,22,2),(25,6,1,27,2),(26,6,1,29,2),(27,6,1,30,2),(28,6,1,31,2),(29,6,1,32,2),(30,13,1,1,3),(31,4,1,7,3),(32,4,1,8,3),(33,4,1,9,3),(34,4,1,10,3),(35,6,1,20,3),(36,6,1,21,3),(37,6,1,22,3),(38,4,1,23,3),(39,6,1,29,3),(40,6,1,31,3),(41,4,1,7,4),(42,4,1,8,4),(43,4,1,9,4),(44,4,1,10,4),(45,4,1,13,4),(46,6,1,20,4),(47,4,1,23,4),(48,4,1,24,4),(49,6,1,30,4),(50,6,1,31,4),(51,6,1,32,4),(52,6,1,33,4),(53,6,1,44,4),(54,5,1,5,5),(55,5,1,7,5),(56,4,1,10,5),(57,4,1,11,5),(58,4,1,12,5),(59,4,1,13,5),(60,4,1,22,5),(61,4,1,23,5),(62,4,1,24,5),(63,12,1,29,5),(64,6,1,43,5),(65,6,1,44,5),(66,5,1,3,6),(67,5,1,4,6),(68,5,1,5,6),(69,5,1,6,6),(70,5,1,7,6),(71,5,1,8,6),(72,5,1,9,6),(73,4,1,10,6),(74,4,1,12,6),(75,11,1,17,6),(76,4,1,21,6),(77,4,1,22,6),(78,4,1,23,6),(79,4,1,24,6),(80,0,1,25,6),(81,13,1,35,6),(82,6,1,44,6),(83,5,1,3,7),(84,5,1,4,7),(85,5,1,5,7),(86,5,1,6,7),(87,5,1,7,7),(88,5,1,8,7),(89,5,1,9,7),(90,5,1,10,7),(91,5,1,11,7),(92,4,1,21,7),(93,4,1,22,7),(94,4,1,23,7),(95,4,1,24,7),(96,6,1,44,7),(97,5,1,3,8),(98,5,1,4,8),(99,5,1,5,8),(100,5,1,6,8),(101,5,1,7,8),(102,0,1,12,8),(103,4,1,21,8),(104,4,1,22,8),(105,4,1,23,8),(106,4,1,24,8),(107,4,1,25,8),(108,6,1,44,8),(109,5,1,2,9),(110,5,1,3,9),(111,5,1,4,9),(112,5,1,5,9),(113,5,1,6,9),(114,5,1,7,9),(115,5,1,8,9),(116,4,1,21,9),(117,4,1,22,9),(118,4,1,23,9),(119,4,1,24,9),(120,4,1,25,9),(121,6,1,44,9),(122,5,1,2,10),(123,5,1,3,10),(124,5,1,4,10),(125,5,1,5,10),(126,5,1,6,10),(127,5,1,7,10),(128,4,1,21,10),(129,4,1,22,10),(130,4,1,23,10),(131,4,1,24,10),(132,4,1,25,10),(133,4,1,26,10),(134,4,1,27,10),(135,4,1,28,10),(136,8,1,39,10),(137,5,1,3,11),(138,5,1,4,11),(139,5,1,5,11),(140,5,1,7,11),(141,5,1,9,11),(142,4,1,11,11),(143,4,1,13,11),(144,4,1,14,11),(145,4,1,15,11),(146,4,1,16,11),(147,4,1,21,11),(148,4,1,22,11),(149,4,1,23,11),(150,4,1,24,11),(151,4,1,25,11),(152,4,1,26,11),(153,4,1,27,11),(154,4,1,28,11),(155,5,1,3,12),(156,5,1,6,12),(157,5,1,7,12),(158,5,1,8,12),(159,5,1,9,12),(160,4,1,10,12),(161,4,1,11,12),(162,4,1,12,12),(163,4,1,13,12),(164,4,1,14,12),(165,4,1,15,12),(166,4,1,21,12),(167,4,1,22,12),(168,4,1,23,12),(169,4,1,24,12),(170,4,1,25,12),(171,4,1,26,12),(172,4,1,27,12),(173,3,1,28,12),(174,5,1,0,13),(175,5,1,1,13),(176,5,1,2,13),(177,5,1,3,13),(178,5,1,4,13),(179,5,1,5,13),(180,5,1,6,13),(181,4,1,12,13),(182,4,1,13,13),(183,4,1,14,13),(184,4,1,15,13),(185,4,1,23,13),(186,4,1,24,13),(187,4,1,26,13),(188,4,1,27,13),(189,3,1,28,13),(190,3,1,29,13),(191,3,1,30,13),(192,3,1,31,13),(193,5,1,0,14),(194,5,1,1,14),(195,5,1,3,14),(196,5,1,4,14),(197,5,1,5,14),(198,4,1,9,14),(199,4,1,10,14),(200,4,1,11,14),(201,4,1,12,14),(202,4,1,13,14),(203,6,1,22,14),(204,4,1,26,14),(205,3,1,27,14),(206,3,1,28,14),(207,3,1,29,14),(208,3,1,30,14),(209,3,1,31,14),(210,3,1,32,14),(211,11,1,36,14),(212,5,1,0,15),(213,5,1,1,15),(214,5,1,4,15),(215,5,1,5,15),(216,4,1,7,15),(217,4,1,9,15),(218,4,1,10,15),(219,4,1,12,15),(220,4,1,13,15),(221,4,1,14,15),(222,6,1,22,15),(223,6,1,23,15),(224,6,1,24,15),(225,3,1,25,15),(226,3,1,26,15),(227,3,1,27,15),(228,3,1,28,15),(229,3,1,29,15),(230,3,1,30,15),(231,3,1,31,15),(232,3,1,32,15),(233,5,1,0,16),(234,5,1,1,16),(235,5,1,2,16),(236,5,1,4,16),(237,5,1,5,16),(238,5,1,6,16),(239,4,1,7,16),(240,4,1,8,16),(241,4,1,9,16),(242,4,1,10,16),(243,4,1,12,16),(244,4,1,14,16),(245,4,1,15,16),(246,6,1,22,16),(247,6,1,23,16),(248,6,1,24,16),(249,6,1,25,16),(250,3,1,26,16),(251,3,1,27,16),(252,3,1,28,16),(253,3,1,29,16),(254,3,1,30,16),(255,3,1,31,16),(256,14,1,33,16),(257,5,1,0,17),(258,5,1,1,17),(259,8,1,2,17),(260,4,1,5,17),(261,4,1,6,17),(262,4,1,8,17),(263,4,1,9,17),(264,4,1,10,17),(265,6,1,23,17),(266,3,1,26,17),(267,3,1,28,17),(268,3,1,29,17),(269,3,1,30,17),(270,3,1,31,17),(271,3,1,32,17),(272,5,1,0,18),(273,5,1,1,18),(274,4,1,5,18),(275,4,1,6,18),(276,4,1,7,18),(277,4,1,8,18),(278,4,1,9,18),(279,4,1,10,18),(280,4,1,11,18),(281,3,1,30,18),(282,3,1,31,18),(283,5,1,0,19),(284,5,1,1,19),(285,4,1,7,19),(286,4,1,8,19),(287,4,1,9,19),(288,4,1,10,19),(289,4,1,11,19),(290,4,1,12,19),(291,10,1,13,19),(292,0,1,28,19),(293,3,1,30,19),(294,3,1,31,19),(295,3,1,32,19),(296,5,1,0,20),(297,5,1,1,20),(298,5,1,2,20),(299,4,1,8,20),(300,3,1,9,20),(301,3,1,10,20),(302,3,1,11,20),(303,3,1,12,20),(304,3,1,30,20),(305,3,1,31,20),(306,3,1,34,20),(307,3,1,35,20),(308,3,1,36,20),(309,12,1,38,20),(310,5,1,0,21),(311,5,1,1,21),(312,5,1,2,21),(313,5,1,3,21),(314,3,1,8,21),(315,3,1,9,21),(316,3,1,10,21),(317,3,1,11,21),(318,3,1,12,21),(319,2,1,17,21),(320,3,1,31,21),(321,3,1,32,21),(322,3,1,33,21),(323,3,1,34,21),(324,5,1,0,22),(325,5,1,1,22),(326,5,1,2,22),(327,5,1,3,22),(328,5,1,4,22),(329,5,1,5,22),(330,3,1,8,22),(331,3,1,9,22),(332,3,1,10,22),(333,3,1,11,22),(334,3,1,12,22),(335,0,1,30,22),(336,3,1,32,22),(337,3,1,33,22),(338,3,1,34,22),(339,3,1,35,22),(340,3,1,36,22),(341,3,1,37,22),(342,5,1,0,23),(343,5,1,1,23),(344,5,1,2,23),(345,7,1,3,23),(346,5,1,4,23),(347,5,1,5,23),(348,3,1,6,23),(349,3,1,7,23),(350,3,1,8,23),(351,3,1,9,23),(352,3,1,10,23),(353,3,1,11,23),(354,3,1,12,23),(355,3,1,13,23),(356,3,1,32,23),(357,3,1,33,23),(358,3,1,34,23),(359,3,1,35,23),(360,3,1,36,23),(361,3,1,37,23),(362,5,1,0,24),(363,5,1,1,24),(364,7,1,2,24),(365,7,1,3,24),(366,7,1,4,24),(367,7,1,5,24),(368,7,1,6,24),(369,3,1,7,24),(370,3,1,8,24),(371,3,1,9,24),(372,3,1,10,24),(373,3,1,12,24),(374,3,1,32,24),(375,3,1,36,24),(376,5,1,0,25),(377,7,1,1,25),(378,7,1,2,25),(379,7,1,3,25),(380,7,1,4,25),(381,7,1,5,25),(382,7,1,6,25),(383,7,1,7,25),(384,3,1,9,25),(385,3,1,10,25),(386,3,1,11,25),(387,7,1,0,26),(388,7,1,1,26),(389,7,1,2,26),(390,7,1,3,26),(391,7,1,4,26),(392,7,1,5,26),(393,7,1,6,26),(394,7,1,7,26),(395,3,1,11,26),(396,0,1,29,26),(397,3,1,31,26),(398,1,1,40,26),(399,7,1,0,27),(400,14,1,1,27),(401,7,1,4,27),(402,7,1,5,27),(403,7,1,6,27),(404,7,1,7,27),(405,7,1,8,27),(406,3,1,24,27),(407,3,1,25,27),(408,3,1,26,27),(409,3,1,27,27),(410,3,1,28,27),(411,3,1,31,27),(412,3,1,32,27),(413,7,1,0,28),(414,7,1,4,28),(415,7,1,5,28),(416,7,1,6,28),(417,7,1,7,28),(418,7,1,8,28),(419,7,1,9,28),(420,3,1,26,28),(421,3,1,28,28),(422,3,1,29,28),(423,3,1,30,28),(424,3,1,31,28),(425,7,1,4,29),(426,7,1,5,29),(427,7,1,6,29),(428,7,1,7,29),(429,7,1,8,29),(430,3,1,26,29),(431,3,1,27,29),(432,3,1,28,29),(433,3,1,29,29),(434,3,1,30,29),(435,3,1,31,29),(436,7,1,4,30),(437,7,1,5,30),(438,7,1,6,30),(439,7,1,7,30),(440,7,1,8,30),(441,7,1,9,30),(442,3,1,26,30),(443,3,1,27,30),(444,3,1,28,30),(445,3,1,29,30),(446,3,1,30,30),(447,3,1,31,30),(448,3,1,32,30),(449,7,1,5,31),(450,7,1,6,31),(451,3,1,27,31),(452,3,1,28,31),(453,3,1,29,31),(454,3,1,31,31),(455,3,1,32,31),(456,3,5,10,0),(457,3,5,11,0),(458,4,5,22,0),(459,4,5,23,0),(460,4,5,24,0),(461,4,5,25,0),(462,4,5,26,0),(463,10,5,5,1),(464,3,5,10,1),(465,3,5,11,1),(466,4,5,22,1),(467,4,5,23,1),(468,4,5,24,1),(469,4,5,25,1),(470,4,5,26,1),(471,3,5,9,2),(472,3,5,10,2),(473,3,5,11,2),(474,4,5,13,2),(475,4,5,14,2),(476,0,5,15,2),(477,7,5,17,2),(478,7,5,18,2),(479,1,5,19,2),(480,4,5,22,2),(481,4,5,23,2),(482,4,5,24,2),(483,4,5,25,2),(484,4,5,26,2),(485,11,5,9,3),(486,4,5,13,3),(487,4,5,14,3),(488,7,5,17,3),(489,7,5,18,3),(490,7,5,21,3),(491,4,5,22,3),(492,4,5,23,3),(493,4,5,24,3),(494,4,5,25,3),(495,4,5,26,3),(496,4,5,13,4),(497,4,5,14,4),(498,4,5,15,4),(499,4,5,16,4),(500,4,5,17,4),(501,7,5,18,4),(502,7,5,19,4),(503,7,5,21,4),(504,4,5,22,4),(505,4,5,23,4),(506,4,5,24,4),(507,4,5,13,5),(508,4,5,14,5),(509,4,5,15,5),(510,4,5,16,5),(511,7,5,17,5),(512,7,5,18,5),(513,7,5,19,5),(514,7,5,20,5),(515,7,5,21,5),(516,4,5,22,5),(517,4,5,23,5),(518,4,5,24,5),(519,4,5,25,5),(520,4,5,26,5),(521,7,5,0,6),(522,4,5,13,6),(523,4,5,14,6),(524,4,5,15,6),(525,4,5,16,6),(526,7,5,17,6),(527,7,5,18,6),(528,7,5,19,6),(529,7,5,20,6),(530,7,5,21,6),(531,7,5,22,6),(532,7,5,23,6),(533,3,5,24,6),(534,3,5,25,6),(535,3,5,26,6),(536,7,5,0,7),(537,7,5,1,7),(538,7,5,3,7),(539,7,5,4,7),(540,4,5,13,7),(541,4,5,14,7),(542,4,5,16,7),(543,4,5,17,7),(544,4,5,18,7),(545,4,5,19,7),(546,7,5,20,7),(547,7,5,21,7),(548,3,5,22,7),(549,3,5,23,7),(550,3,5,24,7),(551,3,5,25,7),(552,3,5,26,7),(553,7,5,0,8),(554,7,5,1,8),(555,7,5,2,8),(556,7,5,3,8),(557,7,5,4,8),(558,4,5,13,8),(559,4,5,14,8),(560,4,5,15,8),(561,4,5,16,8),(562,4,5,17,8),(563,12,5,20,8),(564,3,5,26,8),(565,7,5,0,9),(566,7,5,1,9),(567,7,5,2,9),(568,7,5,3,9),(569,7,5,4,9),(570,4,5,13,9),(571,4,5,14,9),(572,0,5,15,9),(573,4,5,17,9),(574,4,5,18,9),(575,3,5,26,9),(576,7,5,0,10),(577,7,5,1,10),(578,6,5,2,10),(579,6,5,3,10),(580,3,5,5,10),(581,3,5,6,10),(582,4,5,14,10),(583,4,5,18,10),(584,7,5,0,11),(585,6,5,1,11),(586,6,5,2,11),(587,6,5,3,11),(588,3,5,5,11),(589,3,5,6,11),(590,3,5,7,11),(591,3,5,8,11),(592,6,5,9,11),(593,6,5,10,11),(594,4,5,12,11),(595,4,5,13,11),(596,4,5,14,11),(597,4,5,15,11),(598,4,5,16,11),(599,7,5,0,12),(600,7,5,1,12),(601,6,5,2,12),(602,3,5,6,12),(603,3,5,7,12),(604,6,5,8,12),(605,6,5,9,12),(606,4,5,14,12),(607,4,5,15,12),(608,4,5,16,12),(609,4,5,17,12),(610,7,5,0,13),(611,0,5,1,13),(612,8,5,4,13),(613,3,5,7,13),(614,3,5,8,13),(615,6,5,9,13),(616,4,5,13,13),(617,4,5,14,13),(618,4,5,15,13),(619,4,5,16,13),(620,4,5,17,13),(621,4,5,18,13),(622,7,5,0,14),(623,1,5,9,14),(624,4,5,13,14),(625,4,5,15,14),(626,4,5,16,14),(627,4,5,17,14),(628,4,5,18,14),(629,4,5,19,14),(630,4,5,20,14),(631,3,5,21,14),(632,3,5,22,14),(633,7,5,0,15),(634,3,5,11,15),(635,4,5,13,15),(636,4,5,16,15),(637,4,5,17,15),(638,4,5,18,15),(639,3,5,20,15),(640,3,5,21,15),(641,5,5,0,16),(642,5,5,1,16),(643,5,5,2,16),(644,5,5,3,16),(645,5,5,4,16),(646,3,5,11,16),(647,3,5,12,16),(648,14,5,16,16),(649,3,5,19,16),(650,3,5,20,16),(651,3,5,21,16),(652,3,5,22,16),(653,5,5,1,17),(654,5,5,2,17),(655,5,5,3,17),(656,14,5,4,17),(657,3,5,9,17),(658,3,5,11,17),(659,3,5,20,17),(660,3,5,21,17),(661,5,5,0,18),(662,5,5,1,18),(663,5,5,2,18),(664,3,5,9,18),(665,3,5,10,18),(666,3,5,11,18),(667,2,5,12,18),(668,5,5,21,18),(669,3,5,9,19),(670,3,5,11,19),(671,5,5,19,19),(672,5,5,20,19),(673,5,5,21,19),(674,9,5,22,19),(675,0,5,7,20),(676,6,5,15,20),(677,5,5,20,20),(678,5,5,21,20),(679,6,5,15,21),(680,6,5,16,21),(681,6,5,17,21),(682,5,5,20,21),(683,5,5,21,21),(684,13,5,3,22),(685,5,5,13,22),(686,5,5,14,22),(687,6,5,17,22),(688,6,5,18,22),(689,5,5,19,22),(690,5,5,20,22),(691,5,5,21,22),(692,5,5,14,23),(693,5,5,15,23),(694,5,5,16,23),(695,5,5,17,23),(696,5,5,18,23),(697,10,5,19,23),(698,5,5,14,24),(699,5,5,15,24),(700,5,5,15,25),(701,5,5,16,25),(702,0,5,2,27),(703,6,5,11,29),(704,6,5,12,29),(705,6,5,10,30),(706,6,5,11,30),(707,6,5,12,30),(708,6,5,13,30),(709,7,8,3,0),(710,14,8,28,0),(711,6,8,31,0),(712,6,8,32,0),(713,6,8,33,0),(714,6,8,34,0),(715,7,8,0,1),(716,7,8,1,1),(717,7,8,3,1),(718,0,8,31,1),(719,6,8,33,1),(720,6,8,34,1),(721,7,8,1,2),(722,7,8,2,2),(723,7,8,3,2),(724,7,8,4,2),(725,6,8,21,2),(726,6,8,22,2),(727,6,8,23,2),(728,6,8,24,2),(729,6,8,33,2),(730,6,8,34,2),(731,7,8,1,3),(732,7,8,2,3),(733,7,8,3,3),(734,7,8,4,3),(735,0,8,5,3),(736,6,8,22,3),(737,6,8,23,3),(738,5,8,31,3),(739,6,8,32,3),(740,6,8,33,3),(741,6,8,34,3),(742,7,8,2,4),(743,7,8,3,4),(744,7,8,4,4),(745,6,8,22,4),(746,6,8,23,4),(747,6,8,24,4),(748,5,8,27,4),(749,5,8,28,4),(750,5,8,29,4),(751,5,8,31,4),(752,5,8,32,4),(753,6,8,33,4),(754,6,8,34,4),(755,7,8,2,5),(756,7,8,4,5),(757,7,8,5,5),(758,7,8,6,5),(759,12,8,16,5),(760,6,8,22,5),(761,6,8,23,5),(762,5,8,28,5),(763,5,8,29,5),(764,5,8,30,5),(765,5,8,31,5),(766,6,8,33,5),(767,5,8,1,6),(768,7,8,3,6),(769,7,8,4,6),(770,7,8,5,6),(771,7,8,6,6),(772,7,8,7,6),(773,6,8,22,6),(774,6,8,23,6),(775,6,8,24,6),(776,5,8,27,6),(777,5,8,28,6),(778,5,8,29,6),(779,5,8,30,6),(780,5,8,31,6),(781,5,8,32,6),(782,5,8,0,7),(783,5,8,1,7),(784,7,8,4,7),(785,7,8,7,7),(786,6,8,22,7),(787,5,8,29,7),(788,5,8,30,7),(789,5,8,31,7),(790,5,8,32,7),(791,5,8,0,8),(792,9,8,11,8),(793,5,8,31,8),(794,6,8,32,8),(795,5,8,0,9),(796,5,8,2,9),(797,6,8,32,9),(798,5,8,0,10),(799,5,8,1,10),(800,5,8,2,10),(801,5,8,3,10),(802,4,8,24,10),(803,4,8,25,10),(804,4,8,26,10),(805,6,8,32,10),(806,6,8,33,10),(807,5,8,0,11),(808,5,8,1,11),(809,5,8,3,11),(810,7,8,11,11),(811,7,8,14,11),(812,7,8,16,11),(813,7,8,17,11),(814,7,8,18,11),(815,7,8,19,11),(816,7,8,20,11),(817,4,8,26,11),(818,4,8,27,11),(819,6,8,29,11),(820,6,8,30,11),(821,6,8,31,11),(822,6,8,32,11),(823,6,8,33,11),(824,6,8,34,11),(825,5,8,0,12),(826,5,8,1,12),(827,5,8,3,12),(828,7,8,9,12),(829,7,8,10,12),(830,7,8,11,12),(831,7,8,12,12),(832,7,8,13,12),(833,7,8,14,12),(834,7,8,15,12),(835,7,8,16,12),(836,7,8,17,12),(837,7,8,18,12),(838,4,8,23,12),(839,4,8,24,12),(840,4,8,25,12),(841,4,8,26,12),(842,4,8,27,12),(843,4,8,28,12),(844,6,8,29,12),(845,6,8,30,12),(846,6,8,31,12),(847,6,8,33,12),(848,6,8,34,12),(849,5,8,0,13),(850,5,8,1,13),(851,5,8,2,13),(852,5,8,3,13),(853,7,8,10,13),(854,7,8,11,13),(855,7,8,15,13),(856,7,8,16,13),(857,3,8,20,13),(858,4,8,23,13),(859,4,8,24,13),(860,4,8,25,13),(861,4,8,26,13),(862,4,8,27,13),(863,4,8,28,13),(864,4,8,30,13),(865,4,8,31,13),(866,4,8,32,13),(867,5,8,34,13),(868,5,8,0,14),(869,11,8,1,14),(870,13,8,5,14),(871,7,8,13,14),(872,7,8,14,14),(873,7,8,15,14),(874,7,8,16,14),(875,3,8,17,14),(876,3,8,18,14),(877,3,8,20,14),(878,4,8,22,14),(879,4,8,23,14),(880,4,8,24,14),(881,4,8,25,14),(882,4,8,26,14),(883,4,8,27,14),(884,4,8,28,14),(885,4,8,29,14),(886,4,8,30,14),(887,4,8,31,14),(888,5,8,32,14),(889,5,8,33,14),(890,5,8,34,14),(891,7,8,14,15),(892,7,8,15,15),(893,3,8,17,15),(894,3,8,19,15),(895,3,8,20,15),(896,4,8,23,15),(897,4,8,25,15),(898,4,8,26,15),(899,4,8,27,15),(900,4,8,28,15),(901,4,8,29,15),(902,4,8,30,15),(903,5,8,31,15),(904,5,8,32,15),(905,5,8,33,15),(906,5,8,34,15),(907,2,8,5,16),(908,0,8,10,16),(909,3,8,17,16),(910,3,8,18,16),(911,3,8,19,16),(912,3,8,20,16),(913,4,8,23,16),(914,0,8,25,16),(915,4,8,27,16),(916,4,8,29,16),(917,4,8,30,16),(918,4,8,31,16),(919,5,8,32,16),(920,5,8,33,16),(921,5,8,34,16),(922,9,8,12,17),(923,3,8,16,17),(924,3,8,17,17),(925,3,8,18,17),(926,3,8,19,17),(927,5,8,20,17),(928,3,8,21,17),(929,3,8,22,17),(930,4,8,24,17),(931,4,8,30,17),(932,4,8,31,17),(933,4,8,32,17),(934,5,8,33,17),(935,5,8,34,17),(936,3,8,16,18),(937,3,8,18,18),(938,3,8,19,18),(939,3,8,20,18),(940,3,8,21,18),(941,4,8,24,18),(942,4,8,25,18),(943,4,8,26,18),(944,4,8,28,18),(945,5,8,32,18),(946,5,8,33,18),(947,3,8,16,19),(948,3,8,17,19),(949,6,8,18,19),(950,3,8,19,19),(951,3,8,20,19),(952,3,8,21,19),(953,4,8,22,19),(954,4,8,23,19),(955,4,8,25,19),(956,4,8,26,19),(957,4,8,28,19),(958,5,8,32,19),(959,5,8,33,19),(960,5,8,34,19),(961,3,8,16,20),(962,3,8,17,20),(963,6,8,18,20),(964,6,8,19,20),(965,4,8,20,20),(966,4,8,22,20),(967,4,8,23,20),(968,4,8,24,20),(969,4,8,25,20),(970,4,8,26,20),(971,4,8,27,20),(972,4,8,28,20),(973,3,8,30,20),(974,5,8,32,20),(975,5,8,33,20),(976,1,8,16,21),(977,6,8,18,21),(978,6,8,19,21),(979,4,8,20,21),(980,4,8,21,21),(981,4,8,22,21),(982,4,8,23,21),(983,4,8,24,21),(984,4,8,25,21),(985,4,8,26,21),(986,3,8,27,21),(987,4,8,28,21),(988,3,8,30,21),(989,6,8,18,22),(990,6,8,19,22),(991,4,8,20,22),(992,4,8,22,22),(993,4,8,23,22),(994,4,8,24,22),(995,4,8,25,22),(996,3,8,26,22),(997,3,8,27,22),(998,3,8,28,22),(999,3,8,29,22),(1000,3,8,30,22),(1001,3,8,31,22),(1002,6,8,16,23),(1003,6,8,18,23),(1004,6,8,19,23),(1005,4,8,20,23),(1006,4,8,21,23),(1007,4,8,22,23),(1008,4,8,23,23),(1009,4,8,24,23),(1010,4,8,25,23),(1011,4,8,26,23),(1012,3,8,28,23),(1013,3,8,29,23),(1014,3,8,30,23),(1015,3,8,31,23),(1016,3,8,33,23),(1017,6,8,15,24),(1018,6,8,16,24),(1019,6,8,17,24),(1020,6,8,18,24),(1021,6,8,19,24),(1022,4,8,20,24),(1023,4,8,21,24),(1024,4,8,22,24),(1025,4,8,23,24),(1026,4,8,24,24),(1027,4,8,25,24),(1028,4,8,26,24),(1029,4,8,27,24),(1030,4,8,28,24),(1031,3,8,29,24),(1032,3,8,30,24),(1033,3,8,31,24),(1034,3,8,32,24),(1035,3,8,33,24),(1036,8,8,0,25),(1037,4,8,19,25),(1038,4,8,20,25),(1039,4,8,21,25),(1040,4,8,22,25),(1041,14,8,24,25),(1042,3,8,27,25),(1043,3,8,28,25),(1044,3,8,29,25),(1045,3,8,30,25),(1046,3,8,31,25),(1047,3,8,32,25),(1048,3,8,33,25),(1049,4,8,20,26),(1050,4,8,21,26),(1051,4,8,22,26),(1052,3,8,27,26),(1053,3,8,28,26),(1054,3,8,29,26),(1055,3,8,30,26),(1056,3,8,31,26),(1057,3,8,32,26),(1058,3,8,33,26),(1059,3,8,34,26),(1060,4,8,20,27),(1061,4,8,21,27),(1062,4,8,22,27),(1063,3,8,29,27),(1064,3,8,30,27),(1065,3,8,32,27),(1066,3,8,33,27),(1067,3,8,34,27),(1068,4,8,19,28),(1069,4,8,20,28),(1070,4,8,21,28),(1071,4,8,22,28),(1072,4,8,23,28),(1073,3,8,27,28),(1074,3,8,28,28),(1075,3,8,29,28),(1076,3,8,30,28),(1077,3,8,31,28),(1078,3,8,32,28),(1079,3,8,33,28),(1080,3,8,34,28),(1081,4,8,17,29),(1082,4,8,18,29),(1083,4,8,19,29),(1084,4,8,20,29),(1085,4,8,21,29),(1086,4,8,22,29),(1087,4,8,23,29),(1088,4,8,24,29),(1089,10,8,26,29),(1090,3,8,30,29),(1091,3,8,31,29),(1092,3,8,32,29),(1093,3,8,33,29),(1094,3,8,34,29),(1095,4,8,17,30),(1096,4,8,18,30),(1097,4,8,19,30),(1098,4,8,20,30),(1099,4,8,21,30),(1100,4,8,22,30),(1101,4,8,23,30),(1102,0,8,24,30),(1103,3,8,30,30),(1104,3,8,31,30),(1105,3,8,32,30),(1106,3,8,33,30),(1107,4,8,17,31),(1108,4,8,19,31),(1109,4,8,20,31),(1110,4,8,22,31),(1111,4,8,23,31),(1112,5,8,30,31),(1113,3,8,31,31),(1114,0,8,7,32),(1115,4,8,21,32),(1116,4,8,22,32),(1117,4,8,23,32),(1118,4,8,24,32),(1119,4,8,25,32),(1120,5,8,30,32),(1121,5,8,31,32),(1122,4,8,23,33),(1123,5,8,25,33),(1124,5,8,26,33),(1125,5,8,27,33),(1126,5,8,28,33),(1127,5,8,29,33),(1128,5,8,30,33),(1129,5,8,23,34),(1130,5,8,24,34),(1131,5,8,25,34),(1132,5,8,26,34),(1133,5,8,27,34),(1134,5,8,28,34),(1135,5,8,29,34),(1136,5,8,30,34),(1137,5,8,31,34),(1138,5,8,32,34),(1139,5,8,33,34),(1140,4,23,0,0),(1141,4,23,1,0),(1142,4,23,2,0),(1143,4,23,3,0),(1144,4,23,4,0),(1145,4,23,5,0),(1146,6,23,6,0),(1147,6,23,7,0),(1148,6,23,8,0),(1149,6,23,9,0),(1150,6,23,10,0),(1151,6,23,11,0),(1152,5,23,12,0),(1153,5,23,13,0),(1154,5,23,14,0),(1155,4,23,15,0),(1156,4,23,16,0),(1157,4,23,17,0),(1158,4,23,18,0),(1159,4,23,19,0),(1160,4,23,20,0),(1161,4,23,0,1),(1162,4,23,1,1),(1163,4,23,2,1),(1164,4,23,3,1),(1165,4,23,4,1),(1166,6,23,6,1),(1167,3,23,7,1),(1168,6,23,8,1),(1169,3,23,9,1),(1170,5,23,11,1),(1171,5,23,12,1),(1172,5,23,13,1),(1173,5,23,14,1),(1174,5,23,15,1),(1175,4,23,16,1),(1176,4,23,18,1),(1177,4,23,19,1),(1178,4,23,20,1),(1179,4,23,0,2),(1180,4,23,1,2),(1181,4,23,2,2),(1182,4,23,3,2),(1183,3,23,6,2),(1184,3,23,7,2),(1185,3,23,8,2),(1186,3,23,9,2),(1187,5,23,10,2),(1188,5,23,11,2),(1189,5,23,12,2),(1190,5,23,13,2),(1191,5,23,14,2),(1192,5,23,15,2),(1193,4,23,16,2),(1194,4,23,17,2),(1195,4,23,18,2),(1196,4,23,19,2),(1197,4,23,0,3),(1198,4,23,1,3),(1199,4,23,2,3),(1200,4,23,3,3),(1201,4,23,4,3),(1202,3,23,7,3),(1203,3,23,8,3),(1204,3,23,9,3),(1205,5,23,11,3),(1206,5,23,12,3),(1207,5,23,13,3),(1208,4,23,14,3),(1209,4,23,15,3),(1210,4,23,16,3),(1211,4,23,19,3),(1212,4,23,0,4),(1213,4,23,1,4),(1214,4,23,2,4),(1215,3,23,8,4),(1216,3,23,9,4),(1217,5,23,11,4),(1218,5,23,12,4),(1219,0,23,13,4),(1220,4,23,16,4),(1221,4,23,17,4),(1222,4,23,19,4),(1223,5,23,20,4),(1224,4,23,0,5),(1225,4,23,1,5),(1226,4,23,2,5),(1227,3,23,7,5),(1228,3,23,8,5),(1229,3,23,9,5),(1230,3,23,10,5),(1231,5,23,11,5),(1232,5,23,12,5),(1233,5,23,16,5),(1234,5,23,17,5),(1235,5,23,18,5),(1236,5,23,19,5),(1237,5,23,20,5),(1238,4,23,1,6),(1239,4,23,2,6),(1240,3,23,10,6),(1241,5,23,11,6),(1242,5,23,12,6),(1243,5,23,13,6),(1244,5,23,17,6),(1245,5,23,18,6),(1246,5,23,19,6),(1247,5,23,20,6),(1248,5,23,21,6),(1249,4,23,0,7),(1250,4,23,1,7),(1251,4,23,2,7),(1252,4,23,3,7),(1253,4,23,4,7),(1254,12,23,5,7),(1255,5,23,17,7),(1256,5,23,18,7),(1257,5,23,19,7),(1258,5,23,20,7),(1259,4,23,0,8),(1260,4,23,1,8),(1261,4,23,2,8),(1262,4,23,3,8),(1263,5,23,16,8),(1264,5,23,17,8),(1265,5,23,18,8),(1266,10,23,19,8),(1267,4,23,0,9),(1268,4,23,1,9),(1269,4,23,2,9),(1270,4,23,3,9),(1271,5,23,12,9),(1272,5,23,13,9),(1273,5,23,14,9),(1274,5,23,17,9),(1275,5,23,18,9),(1276,4,23,0,10),(1277,4,23,2,10),(1278,5,23,11,10),(1279,5,23,12,10),(1280,0,23,13,10),(1281,5,23,17,10),(1282,5,23,18,10),(1283,4,23,1,11),(1284,4,23,2,11),(1285,4,23,3,11),(1286,3,23,4,11),(1287,5,23,11,11),(1288,5,23,12,11),(1289,5,23,18,11),(1290,3,23,2,12),(1291,3,23,3,12),(1292,3,23,4,12),(1293,5,23,11,12),(1294,5,23,12,12),(1295,5,23,13,12),(1296,5,23,14,12),(1297,5,23,15,12),(1298,5,23,16,12),(1299,3,23,1,13),(1300,3,23,2,13),(1301,3,23,3,13),(1302,3,23,4,13),(1303,3,23,5,13),(1304,3,23,7,13),(1305,5,23,8,13),(1306,5,23,9,13),(1307,5,23,10,13),(1308,5,23,11,13),(1309,0,23,12,13),(1310,5,23,14,13),(1311,5,23,1,14),(1312,5,23,2,14),(1313,3,23,3,14),(1314,3,23,4,14),(1315,3,23,5,14),(1316,3,23,6,14),(1317,3,23,7,14),(1318,5,23,8,14),(1319,5,23,9,14),(1320,5,23,10,14),(1321,5,23,11,14),(1322,5,23,2,15),(1323,5,23,3,15),(1324,3,23,4,15),(1325,3,23,5,15),(1326,6,23,6,15),(1327,5,23,9,15),(1328,0,23,10,15),(1329,5,23,0,16),(1330,5,23,1,16),(1331,5,23,3,16),(1332,3,23,4,16),(1333,6,23,5,16),(1334,6,23,6,16),(1335,6,23,7,16),(1336,6,23,8,16),(1337,5,23,9,16),(1338,6,23,12,16),(1339,0,23,17,16),(1340,9,23,19,16),(1341,5,23,1,17),(1342,5,23,2,17),(1343,5,23,3,17),(1344,5,23,4,17),(1345,12,23,5,17),(1346,6,23,11,17),(1347,6,23,12,17),(1348,6,23,13,17),(1349,5,23,0,18),(1350,5,23,1,18),(1351,5,23,2,18),(1352,5,23,3,18),(1353,5,23,4,18),(1354,6,23,11,18),(1355,6,23,12,18),(1356,7,23,14,18),(1357,7,23,15,18),(1358,3,23,17,18),(1359,3,23,18,18),(1360,6,23,0,19),(1361,5,23,1,19),(1362,5,23,2,19),(1363,5,23,4,19),(1364,6,23,11,19),(1365,7,23,12,19),(1366,7,23,13,19),(1367,7,23,14,19),(1368,7,23,15,19),(1369,3,23,16,19),(1370,3,23,17,19),(1371,3,23,18,19),(1372,3,23,20,19),(1373,6,23,0,20),(1374,6,23,1,20),(1375,5,23,2,20),(1376,5,23,3,20),(1377,5,23,4,20),(1378,6,23,11,20),(1379,7,23,12,20),(1380,7,23,13,20),(1381,7,23,14,20),(1382,3,23,16,20),(1383,3,23,17,20),(1384,3,23,18,20),(1385,3,23,19,20),(1386,3,23,20,20),(1387,3,23,21,20),(1388,6,23,0,21),(1389,6,23,1,21),(1390,5,23,2,21),(1391,5,23,3,21),(1392,7,23,11,21),(1393,7,23,12,21),(1394,7,23,13,21),(1395,7,23,15,21),(1396,3,23,16,21),(1397,3,23,17,21),(1398,2,23,18,21),(1399,3,23,20,21),(1400,3,23,21,21),(1401,6,23,0,22),(1402,6,23,1,22),(1403,6,23,2,22),(1404,7,23,11,22),(1405,7,23,13,22),(1406,7,23,14,22),(1407,7,23,15,22),(1408,7,23,16,22),(1409,3,23,17,22),(1410,3,23,20,22),(1411,6,23,23,22),(1412,8,23,8,23),(1413,7,23,12,23),(1414,7,23,13,23),(1415,7,23,14,23),(1416,7,23,15,23),(1417,7,23,16,23),(1418,7,23,17,23),(1419,6,23,21,23),(1420,6,23,22,23),(1421,6,23,23,23),(1422,14,23,0,24),(1423,7,23,12,24),(1424,7,23,13,24),(1425,7,23,14,24),(1426,7,23,15,24),(1427,7,23,16,24),(1428,6,23,21,24),(1429,6,23,22,24),(1430,6,23,23,24),(1431,7,23,12,25),(1432,7,23,14,25),(1433,7,23,15,25),(1434,6,23,23,25),(1435,3,23,3,26),(1436,3,23,4,26),(1437,3,23,5,26),(1438,3,23,6,26),(1439,3,23,7,26),(1440,7,23,12,26),(1441,7,23,14,26),(1442,3,23,15,26),(1443,3,23,5,27),(1444,7,23,11,27),(1445,7,23,12,27),(1446,3,23,13,27),(1447,7,23,14,27),(1448,3,23,15,27),(1449,1,23,2,28),(1450,3,23,4,28),(1451,3,23,5,28),(1452,3,23,6,28),(1453,3,23,13,28),(1454,3,23,14,28),(1455,3,23,15,28),(1456,3,23,16,28),(1457,3,23,17,28),(1458,9,23,19,28),(1459,3,23,4,29),(1460,3,23,5,29),(1461,3,23,6,29),(1462,3,23,12,29),(1463,3,23,13,29),(1464,3,23,14,29),(1465,3,23,15,29),(1466,3,23,16,29),(1467,3,23,3,30),(1468,3,23,4,30),(1469,3,23,5,30),(1470,3,23,6,30),(1471,3,23,7,30),(1472,0,23,13,30),(1473,3,23,15,30),(1474,8,23,2,31),(1475,3,23,7,31),(1476,3,23,15,31),(1477,3,23,16,31),(1478,3,23,17,31),(1479,3,23,18,31),(1480,10,23,19,31),(1481,11,23,4,34),(1482,13,23,14,35),(1483,1,23,10,36),(1484,0,23,1,37),(1485,2,23,8,37),(1486,4,23,13,37),(1487,4,23,14,37),(1488,4,23,10,38),(1489,4,23,11,38),(1490,4,23,13,38),(1491,4,23,14,38),(1492,4,23,15,38),(1493,4,23,16,38),(1494,4,23,9,39),(1495,4,23,10,39),(1496,4,23,11,39),(1497,4,23,12,39),(1498,4,23,13,39),(1499,4,23,14,39),(1500,4,23,15,39),(1501,4,23,8,40),(1502,4,23,9,40),(1503,4,23,10,40),(1504,4,23,11,40),(1505,4,23,12,40),(1506,4,23,13,40),(1507,4,23,14,40),(1508,4,23,15,40),(1509,5,25,3,0),(1510,5,25,4,0),(1511,5,25,5,0),(1512,5,25,6,0),(1513,5,25,7,0),(1514,5,25,8,0),(1515,5,25,9,0),(1516,5,25,14,0),(1517,5,25,15,0),(1518,5,25,16,0),(1519,5,25,17,0),(1520,5,25,18,0),(1521,5,25,19,0),(1522,4,25,20,0),(1523,4,25,21,0),(1524,4,25,22,0),(1525,4,25,23,0),(1526,4,25,24,0),(1527,6,25,25,0),(1528,5,25,26,0),(1529,5,25,28,0),(1530,5,25,29,0),(1531,3,25,30,0),(1532,3,25,31,0),(1533,3,25,32,0),(1534,3,25,33,0),(1535,3,25,34,0),(1536,3,25,35,0),(1537,6,25,38,0),(1538,6,25,39,0),(1539,6,25,40,0),(1540,6,25,41,0),(1541,6,25,42,0),(1542,5,25,4,1),(1543,5,25,5,1),(1544,4,25,6,1),(1545,5,25,8,1),(1546,5,25,9,1),(1547,5,25,16,1),(1548,5,25,18,1),(1549,5,25,19,1),(1550,4,25,20,1),(1551,0,25,21,1),(1552,4,25,23,1),(1553,4,25,24,1),(1554,4,25,25,1),(1555,5,25,26,1),(1556,5,25,27,1),(1557,5,25,28,1),(1558,5,25,29,1),(1559,3,25,30,1),(1560,3,25,31,1),(1561,3,25,32,1),(1562,3,25,33,1),(1563,3,25,34,1),(1564,0,25,35,1),(1565,0,25,38,1),(1566,6,25,40,1),(1567,4,25,4,2),(1568,4,25,6,2),(1569,4,25,7,2),(1570,4,25,8,2),(1571,12,25,9,2),(1572,5,25,16,2),(1573,3,25,19,2),(1574,3,25,20,2),(1575,4,25,23,2),(1576,4,25,24,2),(1577,4,25,25,2),(1578,4,25,26,2),(1579,5,25,27,2),(1580,4,25,28,2),(1581,5,25,29,2),(1582,5,25,30,2),(1583,3,25,31,2),(1584,3,25,32,2),(1585,3,25,33,2),(1586,3,25,34,2),(1587,4,25,4,3),(1588,4,25,5,3),(1589,4,25,6,3),(1590,4,25,7,3),(1591,4,25,8,3),(1592,3,25,18,3),(1593,3,25,19,3),(1594,3,25,20,3),(1595,4,25,23,3),(1596,4,25,25,3),(1597,4,25,26,3),(1598,4,25,27,3),(1599,4,25,28,3),(1600,4,25,29,3),(1601,5,25,30,3),(1602,3,25,31,3),(1603,3,25,32,3),(1604,3,25,33,3),(1605,5,25,35,3),(1606,5,25,36,3),(1607,5,25,37,3),(1608,4,25,4,4),(1609,4,25,5,4),(1610,4,25,6,4),(1611,4,25,7,4),(1612,4,25,8,4),(1613,3,25,16,4),(1614,3,25,17,4),(1615,3,25,18,4),(1616,3,25,19,4),(1617,4,25,23,4),(1618,4,25,25,4),(1619,4,25,26,4),(1620,3,25,29,4),(1621,3,25,30,4),(1622,3,25,31,4),(1623,3,25,32,4),(1624,5,25,35,4),(1625,5,25,37,4),(1626,14,25,2,5),(1627,9,25,5,5),(1628,3,25,17,5),(1629,3,25,18,5),(1630,3,25,19,5),(1631,3,25,20,5),(1632,4,25,22,5),(1633,4,25,24,5),(1634,4,25,25,5),(1635,4,25,26,5),(1636,3,25,29,5),(1637,3,25,30,5),(1638,3,25,31,5),(1639,3,25,32,5),(1640,5,25,34,5),(1641,5,25,35,5),(1642,5,25,36,5),(1643,5,25,37,5),(1644,2,25,38,5),(1645,5,25,42,5),(1646,3,25,17,6),(1647,4,25,21,6),(1648,4,25,22,6),(1649,4,25,23,6),(1650,7,25,24,6),(1651,7,25,25,6),(1652,4,25,26,6),(1653,4,25,27,6),(1654,11,25,29,6),(1655,8,25,33,6),(1656,5,25,36,6),(1657,5,25,37,6),(1658,5,25,42,6),(1659,4,25,21,7),(1660,4,25,22,7),(1661,7,25,23,7),(1662,7,25,24,7),(1663,7,25,25,7),(1664,4,25,26,7),(1665,4,25,27,7),(1666,0,25,37,7),(1667,5,25,41,7),(1668,5,25,42,7),(1669,7,25,5,8),(1670,7,25,6,8),(1671,4,25,21,8),(1672,4,25,22,8),(1673,7,25,23,8),(1674,7,25,24,8),(1675,7,25,25,8),(1676,7,25,26,8),(1677,5,25,41,8),(1678,0,25,2,9),(1679,7,25,4,9),(1680,7,25,5,9),(1681,7,25,6,9),(1682,6,25,12,9),(1683,6,25,13,9),(1684,4,25,20,9),(1685,4,25,21,9),(1686,4,25,22,9),(1687,4,25,23,9),(1688,4,25,24,9),(1689,7,25,25,9),(1690,7,25,26,9),(1691,13,25,33,9),(1692,5,25,39,9),(1693,5,25,40,9),(1694,5,25,41,9),(1695,7,25,5,10),(1696,7,25,6,10),(1697,7,25,7,10),(1698,7,25,8,10),(1699,6,25,12,10),(1700,6,25,13,10),(1701,7,25,23,10),(1702,7,25,24,10),(1703,7,25,25,10),(1704,5,25,39,10),(1705,5,25,41,10),(1706,5,25,42,10),(1707,7,25,6,11),(1708,7,25,7,11),(1709,6,25,13,11),(1710,4,25,19,11),(1711,3,25,34,11),(1712,3,25,35,11),(1713,3,25,36,11),(1714,3,25,37,11),(1715,3,25,38,11),(1716,3,25,39,11),(1717,7,25,5,12),(1718,7,25,6,12),(1719,7,25,7,12),(1720,4,25,19,12),(1721,4,25,20,12),(1722,4,25,21,12),(1723,4,25,22,12),(1724,4,25,23,12),(1725,13,25,29,12),(1726,3,25,35,12),(1727,3,25,36,12),(1728,3,25,37,12),(1729,3,25,38,12),(1730,6,25,39,12),(1731,4,25,20,13),(1732,4,25,21,13),(1733,4,25,22,13),(1734,3,25,35,13),(1735,3,25,36,13),(1736,3,25,37,13),(1737,6,25,38,13),(1738,6,25,39,13),(1739,6,25,40,13),(1740,6,25,41,13),(1741,4,25,18,14),(1742,4,25,19,14),(1743,4,25,20,14),(1744,4,25,21,14),(1745,3,25,36,14),(1746,10,25,38,14),(1747,6,25,11,15),(1748,6,25,12,15),(1749,4,25,21,15),(1750,4,25,22,15),(1751,0,25,31,15),(1752,1,25,36,15),(1753,6,25,11,16),(1754,6,25,12,16),(1755,6,25,13,16),(1756,0,25,14,16),(1757,0,25,20,16),(1758,6,25,12,17),(1759,3,26,0,0),(1760,3,26,1,0),(1761,3,26,2,0),(1762,3,26,3,0),(1763,6,26,4,0),(1764,6,26,5,0),(1765,6,26,6,0),(1766,0,26,11,0),(1767,4,26,23,0),(1768,4,26,25,0),(1769,4,26,26,0),(1770,6,26,27,0),(1771,5,26,28,0),(1772,5,26,29,0),(1773,5,26,30,0),(1774,5,26,31,0),(1775,3,26,0,1),(1776,3,26,1,1),(1777,3,26,2,1),(1778,3,26,3,1),(1779,3,26,4,1),(1780,6,26,5,1),(1781,6,26,6,1),(1782,8,26,13,1),(1783,4,26,23,1),(1784,4,26,24,1),(1785,4,26,25,1),(1786,4,26,26,1),(1787,4,26,27,1),(1788,5,26,28,1),(1789,5,26,29,1),(1790,5,26,30,1),(1791,3,26,0,2),(1792,3,26,1,2),(1793,3,26,2,2),(1794,3,26,3,2),(1795,6,26,6,2),(1796,4,26,24,2),(1797,4,26,25,2),(1798,4,26,26,2),(1799,4,26,27,2),(1800,5,26,28,2),(1801,5,26,30,2),(1802,5,26,31,2),(1803,3,26,0,3),(1804,3,26,1,3),(1805,3,26,2,3),(1806,3,26,3,3),(1807,4,26,24,3),(1808,4,26,25,3),(1809,4,26,26,3),(1810,4,26,27,3),(1811,5,26,28,3),(1812,5,26,29,3),(1813,5,26,30,3),(1814,5,26,31,3),(1815,3,26,0,4),(1816,3,26,1,4),(1817,0,26,2,4),(1818,0,26,12,4),(1819,4,26,25,4),(1820,4,26,26,4),(1821,4,26,27,4),(1822,4,26,28,4),(1823,5,26,29,4),(1824,5,26,31,4),(1825,3,26,0,5),(1826,2,26,9,5),(1827,5,26,11,5),(1828,4,26,20,5),(1829,7,26,23,5),(1830,4,26,25,5),(1831,7,26,26,5),(1832,7,26,27,5),(1833,7,26,28,5),(1834,7,26,29,5),(1835,5,26,30,5),(1836,5,26,31,5),(1837,5,26,11,6),(1838,5,26,12,6),(1839,5,26,13,6),(1840,4,26,17,6),(1841,4,26,19,6),(1842,4,26,20,6),(1843,4,26,21,6),(1844,4,26,22,6),(1845,7,26,23,6),(1846,7,26,24,6),(1847,7,26,25,6),(1848,7,26,26,6),(1849,7,26,27,6),(1850,7,26,28,6),(1851,7,26,29,6),(1852,7,26,30,6),(1853,5,26,31,6),(1854,5,26,10,7),(1855,5,26,11,7),(1856,5,26,12,7),(1857,5,26,13,7),(1858,4,26,15,7),(1859,4,26,16,7),(1860,4,26,17,7),(1861,4,26,19,7),(1862,4,26,21,7),(1863,4,26,22,7),(1864,4,26,23,7),(1865,4,26,24,7),(1866,7,26,27,7),(1867,7,26,28,7),(1868,7,26,29,7),(1869,7,26,30,7),(1870,7,26,31,7),(1871,14,26,5,8),(1872,5,26,9,8),(1873,5,26,10,8),(1874,5,26,11,8),(1875,5,26,12,8),(1876,4,26,15,8),(1877,4,26,17,8),(1878,4,26,20,8),(1879,4,26,21,8),(1880,4,26,22,8),(1881,4,26,23,8),(1882,4,26,24,8),(1883,7,26,25,8),(1884,7,26,26,8),(1885,7,26,27,8),(1886,7,26,28,8),(1887,7,26,29,8),(1888,7,26,30,8),(1889,7,26,31,8),(1890,6,26,3,9),(1891,6,26,4,9),(1892,5,26,10,9),(1893,5,26,11,9),(1894,5,26,12,9),(1895,5,26,13,9),(1896,4,26,14,9),(1897,4,26,15,9),(1898,4,26,16,9),(1899,4,26,17,9),(1900,4,26,21,9),(1901,7,26,25,9),(1902,7,26,27,9),(1903,7,26,28,9),(1904,7,26,29,9),(1905,7,26,30,9),(1906,7,26,31,9),(1907,6,26,4,10),(1908,5,26,10,10),(1909,5,26,11,10),(1910,5,26,12,10),(1911,5,26,13,10),(1912,4,26,15,10),(1913,4,26,16,10),(1914,4,26,17,10),(1915,4,26,21,10),(1916,7,26,28,10),(1917,7,26,29,10),(1918,7,26,30,10),(1919,7,26,31,10),(1920,5,26,10,11),(1921,5,26,11,11),(1922,5,26,12,11),(1923,5,26,13,11),(1924,4,26,14,11),(1925,4,26,15,11),(1926,4,26,16,11),(1927,4,26,17,11),(1928,10,26,5,12),(1929,5,26,9,12),(1930,5,26,10,12),(1931,5,26,11,12),(1932,5,26,12,12),(1933,5,26,13,12),(1934,5,26,14,12),(1935,5,26,15,12),(1936,4,26,16,12),(1937,4,26,17,12),(1938,4,26,18,12),(1939,5,26,11,13),(1940,5,26,12,13),(1941,5,26,13,13),(1942,5,26,14,13),(1943,4,26,16,13),(1944,4,26,11,14),(1945,5,26,12,14),(1946,3,26,13,14),(1947,3,26,14,14),(1948,3,26,15,14),(1949,4,26,9,15),(1950,4,26,10,15),(1951,4,26,11,15),(1952,5,26,12,15),(1953,3,26,13,15),(1954,3,26,15,15),(1955,4,26,0,16),(1956,4,26,2,16),(1957,4,26,5,16),(1958,4,26,6,16),(1959,4,26,7,16),(1960,4,26,8,16),(1961,4,26,9,16),(1962,4,26,10,16),(1963,5,26,12,16),(1964,3,26,13,16),(1965,3,26,14,16),(1966,3,26,15,16),(1967,3,26,16,16),(1968,5,26,26,16),(1969,5,26,27,16),(1970,4,26,0,17),(1971,4,26,1,17),(1972,4,26,2,17),(1973,4,26,3,17),(1974,4,26,4,17),(1975,4,26,6,17),(1976,4,26,8,17),(1977,4,26,9,17),(1978,4,26,10,17),(1979,4,26,11,17),(1980,4,26,12,17),(1981,3,26,13,17),(1982,3,26,14,17),(1983,3,26,15,17),(1984,3,26,16,17),(1985,9,26,17,17),(1986,10,26,22,17),(1987,5,26,26,17),(1988,5,26,27,17),(1989,5,26,28,17),(1990,5,26,30,17),(1991,4,26,0,18),(1992,4,26,1,18),(1993,4,26,2,18),(1994,4,26,3,18),(1995,4,26,4,18),(1996,4,26,5,18),(1997,4,26,6,18),(1998,4,26,7,18),(1999,4,26,8,18),(2000,4,26,9,18),(2001,4,26,10,18),(2002,4,26,12,18),(2003,3,26,13,18),(2004,3,26,14,18),(2005,3,26,15,18),(2006,3,26,16,18),(2007,5,26,28,18),(2008,5,26,30,18),(2009,5,26,31,18),(2010,4,26,3,19),(2011,4,26,5,19),(2012,4,26,6,19),(2013,6,26,7,19),(2014,6,26,8,19),(2015,0,26,9,19),(2016,3,26,11,19),(2017,3,26,12,19),(2018,3,26,13,19),(2019,3,26,14,19),(2020,3,26,15,19),(2021,3,26,16,19),(2022,5,26,27,19),(2023,5,26,28,19),(2024,5,26,29,19),(2025,5,26,30,19),(2026,5,26,31,19),(2027,4,26,3,20),(2028,4,26,4,20),(2029,4,26,5,20),(2030,4,26,6,20),(2031,6,26,7,20),(2032,6,26,8,20),(2033,3,26,11,20),(2034,3,26,13,20),(2035,3,26,14,20),(2036,3,26,15,20),(2037,3,26,16,20),(2038,3,26,17,20),(2039,3,26,18,20),(2040,3,26,19,20),(2041,3,26,20,20),(2042,0,26,26,20),(2043,5,26,28,20),(2044,5,26,29,20),(2045,5,26,30,20),(2046,5,26,31,20),(2047,3,26,7,21),(2048,3,26,8,21),(2049,3,26,9,21),(2050,3,26,12,21),(2051,3,26,13,21),(2052,3,26,14,21),(2053,3,26,15,21),(2054,3,26,16,21),(2055,3,26,17,21),(2056,3,26,18,21),(2057,3,26,19,21),(2058,3,26,20,21),(2059,1,26,21,21),(2060,5,26,28,21),(2061,5,26,1,22),(2062,3,26,6,22),(2063,3,26,7,22),(2064,3,26,9,22),(2065,3,26,10,22),(2066,3,26,11,22),(2067,3,26,12,22),(2068,3,26,13,22),(2069,3,26,14,22),(2070,3,26,15,22),(2071,3,26,16,22),(2072,3,26,17,22),(2073,3,26,19,22),(2074,3,26,20,22),(2075,11,26,27,22),(2076,5,26,0,23),(2077,5,26,1,23),(2078,5,26,2,23),(2079,5,26,3,23),(2080,3,26,7,23),(2081,3,26,8,23),(2082,3,26,9,23),(2083,3,26,10,23),(2084,3,26,11,23),(2085,3,26,12,23),(2086,3,26,13,23),(2087,3,26,14,23),(2088,3,26,15,23),(2089,0,26,18,23),(2090,9,26,20,23),(2091,5,26,0,24),(2092,5,26,1,24),(2093,5,26,2,24),(2094,5,26,3,24),(2095,5,26,4,24),(2096,5,26,5,24),(2097,3,26,7,24),(2098,3,26,8,24),(2099,3,26,9,24),(2100,3,26,10,24),(2101,3,26,11,24),(2102,3,26,12,24),(2103,3,26,13,24),(2104,3,26,14,24),(2105,5,26,1,25),(2106,5,26,2,25),(2107,5,26,3,25),(2108,5,26,4,25),(2109,5,26,5,25),(2110,3,26,8,25),(2111,3,26,9,25),(2112,3,26,10,25),(2113,3,26,11,25),(2114,3,26,12,25),(2115,3,26,13,25),(2116,3,26,14,25),(2117,5,26,2,26),(2118,5,26,4,26),(2119,5,26,5,26),(2120,3,26,6,26),(2121,3,26,7,26),(2122,3,26,8,26),(2123,12,26,9,26),(2124,6,26,16,26),(2125,13,26,1,27),(2126,6,26,16,27),(2127,13,26,18,27),(2128,6,26,15,28),(2129,6,26,16,28),(2130,6,26,17,28),(2131,6,26,16,29),(2132,6,26,17,29),(2133,6,26,18,29),(2134,6,26,23,29),(2135,6,26,24,29),(2136,6,26,25,29),(2137,6,26,22,30),(2138,6,26,23,30),(2139,6,26,24,30),(2140,6,26,23,31),(2141,6,26,24,31),(2142,4,28,18,0),(2143,4,28,19,0),(2144,4,28,20,0),(2145,4,28,21,0),(2146,4,28,22,0),(2147,5,28,32,0),(2148,5,28,33,0),(2149,3,28,1,1),(2150,3,28,4,1),(2151,4,28,17,1),(2152,4,28,18,1),(2153,4,28,19,1),(2154,1,28,20,1),(2155,5,28,31,1),(2156,5,28,32,1),(2157,5,28,33,1),(2158,3,28,0,2),(2159,3,28,1,2),(2160,3,28,2,2),(2161,3,28,3,2),(2162,3,28,4,2),(2163,3,28,5,2),(2164,4,28,16,2),(2165,4,28,17,2),(2166,4,28,19,2),(2167,0,28,30,2),(2168,5,28,32,2),(2169,5,28,33,2),(2170,3,28,0,3),(2171,3,28,1,3),(2172,3,28,2,3),(2173,3,28,3,3),(2174,3,28,4,3),(2175,3,28,5,3),(2176,4,28,17,3),(2177,4,28,18,3),(2178,3,28,0,4),(2179,3,28,1,4),(2180,6,28,2,4),(2181,6,28,3,4),(2182,6,28,4,4),(2183,6,28,5,4),(2184,4,28,18,4),(2185,6,28,2,5),(2186,6,28,4,5),(2187,6,28,5,5),(2188,6,28,6,5),(2189,6,28,4,6),(2190,6,28,5,6),(2191,4,28,25,6),(2192,3,28,1,7),(2193,4,28,7,7),(2194,4,28,8,7),(2195,4,28,25,7),(2196,3,28,1,8),(2197,4,28,6,8),(2198,4,28,7,8),(2199,4,28,8,8),(2200,4,28,24,8),(2201,4,28,25,8),(2202,4,28,26,8),(2203,6,28,29,8),(2204,3,28,0,9),(2205,3,28,1,9),(2206,3,28,2,9),(2207,3,28,3,9),(2208,0,28,6,9),(2209,4,28,8,9),(2210,4,28,9,9),(2211,4,28,24,9),(2212,4,28,25,9),(2213,4,28,26,9),(2214,4,28,27,9),(2215,6,28,28,9),(2216,6,28,29,9),(2217,3,28,0,10),(2218,3,28,1,10),(2219,3,28,2,10),(2220,3,28,3,10),(2221,3,28,4,10),(2222,4,28,8,10),(2223,4,28,9,10),(2224,4,28,10,10),(2225,12,28,16,10),(2226,2,28,23,10),(2227,4,28,25,10),(2228,4,28,26,10),(2229,6,28,28,10),(2230,6,28,29,10),(2231,6,28,30,10),(2232,3,28,1,11),(2233,3,28,2,11),(2234,3,28,3,11),(2235,4,28,8,11),(2236,4,28,9,11),(2237,4,28,10,11),(2238,4,28,25,11),(2239,4,28,26,11),(2240,6,28,29,11),(2241,6,28,30,11),(2242,6,28,31,11),(2243,3,28,2,12),(2244,3,28,3,12),(2245,6,28,5,12),(2246,7,28,7,12),(2247,7,28,8,12),(2248,4,28,10,12),(2249,7,28,22,12),(2250,7,28,23,12),(2251,7,28,24,12),(2252,7,28,25,12),(2253,4,28,26,12),(2254,14,28,30,12),(2255,5,28,33,12),(2256,3,28,2,13),(2257,3,28,3,13),(2258,3,28,4,13),(2259,6,28,5,13),(2260,6,28,6,13),(2261,7,28,7,13),(2262,7,28,22,13),(2263,7,28,23,13),(2264,7,28,24,13),(2265,0,28,25,13),(2266,7,28,27,13),(2267,7,28,28,13),(2268,5,28,33,13),(2269,6,28,1,14),(2270,6,28,2,14),(2271,6,28,3,14),(2272,6,28,4,14),(2273,6,28,5,14),(2274,6,28,6,14),(2275,7,28,7,14),(2276,7,28,9,14),(2277,7,28,22,14),(2278,7,28,23,14),(2279,7,28,24,14),(2280,7,28,28,14),(2281,5,28,33,14),(2282,4,28,0,15),(2283,4,28,1,15),(2284,6,28,2,15),(2285,4,28,3,15),(2286,7,28,5,15),(2287,7,28,6,15),(2288,7,28,7,15),(2289,7,28,8,15),(2290,7,28,9,15),(2291,7,28,10,15),(2292,7,28,22,15),(2293,7,28,23,15),(2294,7,28,24,15),(2295,7,28,25,15),(2296,7,28,27,15),(2297,7,28,28,15),(2298,5,28,33,15),(2299,4,28,0,16),(2300,4,28,1,16),(2301,4,28,2,16),(2302,4,28,3,16),(2303,7,28,4,16),(2304,7,28,5,16),(2305,7,28,6,16),(2306,7,28,7,16),(2307,7,28,8,16),(2308,7,28,9,16),(2309,14,28,22,16),(2310,7,28,25,16),(2311,7,28,26,16),(2312,7,28,27,16),(2313,7,28,28,16),(2314,5,28,32,16),(2315,5,28,33,16),(2316,4,28,0,17),(2317,4,28,1,17),(2318,4,28,2,17),(2319,4,28,3,17),(2320,4,28,4,17),(2321,7,28,5,17),(2322,7,28,6,17),(2323,11,28,7,17),(2324,4,28,16,17),(2325,5,28,21,17),(2326,7,28,25,17),(2327,7,28,26,17),(2328,0,28,27,17),(2329,5,28,32,17),(2330,4,28,1,18),(2331,7,28,4,18),(2332,7,28,5,18),(2333,7,28,6,18),(2334,5,28,11,18),(2335,4,28,14,18),(2336,4,28,15,18),(2337,4,28,16,18),(2338,6,28,18,18),(2339,5,28,19,18),(2340,5,28,20,18),(2341,5,28,21,18),(2342,7,28,25,18),(2343,4,28,1,19),(2344,7,28,4,19),(2345,7,28,5,19),(2346,7,28,6,19),(2347,5,28,11,19),(2348,1,28,12,19),(2349,4,28,15,19),(2350,6,28,17,19),(2351,6,28,18,19),(2352,5,28,19,19),(2353,5,28,20,19),(2354,5,28,21,19),(2355,8,28,4,20),(2356,5,28,11,20),(2357,4,28,14,20),(2358,4,28,15,20),(2359,4,28,16,20),(2360,6,28,17,20),(2361,6,28,18,20),(2362,9,28,19,20),(2363,0,28,24,20),(2364,0,28,11,21),(2365,3,28,13,21),(2366,3,28,14,21),(2367,4,28,15,21),(2368,4,28,16,21),(2369,6,28,17,21),(2370,6,28,18,21),(2371,3,28,13,22),(2372,4,28,14,22),(2373,4,28,15,22),(2374,4,28,16,22),(2375,6,28,17,22),(2376,6,28,18,22),(2377,8,28,25,22),(2378,13,28,6,23),(2379,3,28,12,23),(2380,3,28,13,23),(2381,3,28,14,23),(2382,4,28,15,23),(2383,6,28,18,23),(2384,3,28,12,24),(2385,3,28,13,24),(2386,3,28,14,24),(2387,3,28,15,24),(2388,10,28,21,24),(2389,3,28,9,25),(2390,3,28,10,25),(2391,3,28,11,25),(2392,3,28,12,25),(2393,3,28,13,25),(2394,3,28,14,25),(2395,3,28,15,25),(2396,5,28,3,26),(2397,5,28,4,26),(2398,3,28,8,26),(2399,3,28,9,26),(2400,3,28,10,26),(2401,3,28,11,26),(2402,3,28,12,26),(2403,3,28,13,26),(2404,3,28,15,26),(2405,5,28,2,27),(2406,5,28,4,27),(2407,3,28,5,27),(2408,3,28,6,27),(2409,3,28,7,27),(2410,3,28,8,27),(2411,3,28,9,27),(2412,3,28,10,27),(2413,3,28,12,27),(2414,3,28,15,27),(2415,5,28,2,28),(2416,5,28,3,28),(2417,5,28,4,28),(2418,3,28,5,28),(2419,3,28,6,28),(2420,3,28,7,28),(2421,3,28,8,28),(2422,3,28,9,28),(2423,3,28,10,28),(2424,4,34,11,0),(2425,4,34,12,0),(2426,4,34,13,0),(2427,7,34,17,0),(2428,7,34,18,0),(2429,7,34,19,0),(2430,7,34,20,0),(2431,7,34,21,0),(2432,7,34,22,0),(2433,7,34,23,0),(2434,7,34,24,0),(2435,6,34,5,1),(2436,6,34,6,1),(2437,6,34,7,1),(2438,6,34,8,1),(2439,4,34,10,1),(2440,4,34,11,1),(2441,4,34,12,1),(2442,7,34,15,1),(2443,7,34,17,1),(2444,7,34,18,1),(2445,7,34,19,1),(2446,7,34,20,1),(2447,7,34,21,1),(2448,7,34,22,1),(2449,7,34,23,1),(2450,0,34,24,1),(2451,6,34,5,2),(2452,6,34,6,2),(2453,6,34,7,2),(2454,4,34,8,2),(2455,4,34,9,2),(2456,4,34,10,2),(2457,4,34,11,2),(2458,5,34,12,2),(2459,4,34,13,2),(2460,7,34,14,2),(2461,7,34,15,2),(2462,7,34,16,2),(2463,7,34,17,2),(2464,7,34,18,2),(2465,7,34,19,2),(2466,7,34,20,2),(2467,7,34,21,2),(2468,7,34,22,2),(2469,7,34,23,2),(2470,6,34,6,3),(2471,4,34,7,3),(2472,4,34,8,3),(2473,4,34,9,3),(2474,4,34,10,3),(2475,4,34,11,3),(2476,5,34,12,3),(2477,4,34,13,3),(2478,7,34,16,3),(2479,7,34,17,3),(2480,7,34,18,3),(2481,7,34,19,3),(2482,7,34,20,3),(2483,7,34,21,3),(2484,7,34,22,3),(2485,14,34,23,3),(2486,1,34,3,4),(2487,4,34,5,4),(2488,4,34,6,4),(2489,4,34,7,4),(2490,4,34,8,4),(2491,4,34,9,4),(2492,5,34,11,4),(2493,5,34,12,4),(2494,4,34,13,4),(2495,4,34,14,4),(2496,4,34,15,4),(2497,4,34,16,4),(2498,7,34,17,4),(2499,7,34,18,4),(2500,7,34,19,4),(2501,7,34,20,4),(2502,7,34,21,4),(2503,7,34,22,4),(2504,8,34,26,4),(2505,4,34,7,5),(2506,5,34,9,5),(2507,5,34,11,5),(2508,5,34,12,5),(2509,4,34,13,5),(2510,4,34,14,5),(2511,7,34,15,5),(2512,7,34,16,5),(2513,7,34,17,5),(2514,7,34,18,5),(2515,7,34,19,5),(2516,7,34,20,5),(2517,7,34,21,5),(2518,7,34,22,5),(2519,5,34,7,6),(2520,5,34,8,6),(2521,5,34,9,6),(2522,5,34,10,6),(2523,5,34,11,6),(2524,5,34,12,6),(2525,4,34,13,6),(2526,4,34,14,6),(2527,4,34,15,6),(2528,7,34,17,6),(2529,7,34,18,6),(2530,7,34,19,6),(2531,7,34,20,6),(2532,7,34,21,6),(2533,7,34,22,6),(2534,5,34,6,7),(2535,5,34,8,7),(2536,5,34,9,7),(2537,5,34,10,7),(2538,5,34,11,7),(2539,4,34,13,7),(2540,4,34,14,7),(2541,4,34,15,7),(2542,4,34,16,7),(2543,7,34,17,7),(2544,7,34,18,7),(2545,7,34,19,7),(2546,7,34,20,7),(2547,7,34,21,7),(2548,7,34,22,7),(2549,7,34,23,7),(2550,7,34,24,7),(2551,9,34,25,7),(2552,5,34,6,8),(2553,5,34,7,8),(2554,5,34,8,8),(2555,3,34,9,8),(2556,3,34,10,8),(2557,5,34,11,8),(2558,5,34,12,8),(2559,5,34,13,8),(2560,4,34,14,8),(2561,5,34,15,8),(2562,5,34,16,8),(2563,7,34,17,8),(2564,7,34,18,8),(2565,7,34,19,8),(2566,7,34,20,8),(2567,7,34,21,8),(2568,7,34,22,8),(2569,7,34,23,8),(2570,7,34,24,8),(2571,5,34,7,9),(2572,5,34,8,9),(2573,3,34,9,9),(2574,3,34,10,9),(2575,3,34,11,9),(2576,4,34,12,9),(2577,4,34,13,9),(2578,4,34,14,9),(2579,5,34,15,9),(2580,5,34,16,9),(2581,7,34,17,9),(2582,7,34,18,9),(2583,9,34,19,9),(2584,7,34,23,9),(2585,7,34,24,9),(2586,11,34,2,10),(2587,5,34,6,10),(2588,5,34,7,10),(2589,2,34,8,10),(2590,3,34,10,10),(2591,3,34,11,10),(2592,4,34,13,10),(2593,5,34,14,10),(2594,5,34,15,10),(2595,5,34,16,10),(2596,5,34,17,10),(2597,7,34,18,10),(2598,3,34,23,10),(2599,3,34,24,10),(2600,0,34,25,10),(2601,3,34,10,11),(2602,3,34,12,11),(2603,4,34,13,11),(2604,5,34,14,11),(2605,5,34,15,11),(2606,5,34,16,11),(2607,5,34,17,11),(2608,7,34,18,11),(2609,3,34,23,11),(2610,3,34,24,11),(2611,3,34,7,12),(2612,3,34,8,12),(2613,3,34,10,12),(2614,3,34,11,12),(2615,3,34,12,12),(2616,3,34,13,12),(2617,3,34,14,12),(2618,5,34,15,12),(2619,5,34,16,12),(2620,5,34,18,12),(2621,5,34,19,12),(2622,3,34,21,12),(2623,3,34,23,12),(2624,3,34,24,12),(2625,3,34,25,12),(2626,3,34,26,12),(2627,3,34,27,12),(2628,3,34,6,13),(2629,3,34,7,13),(2630,3,34,8,13),(2631,3,34,9,13),(2632,3,34,10,13),(2633,3,34,11,13),(2634,3,34,12,13),(2635,3,34,13,13),(2636,5,34,15,13),(2637,5,34,16,13),(2638,5,34,17,13),(2639,5,34,18,13),(2640,3,34,19,13),(2641,3,34,20,13),(2642,3,34,21,13),(2643,3,34,22,13),(2644,3,34,23,13),(2645,3,34,24,13),(2646,0,34,26,13),(2647,3,34,6,14),(2648,3,34,8,14),(2649,3,34,9,14),(2650,3,34,10,14),(2651,3,34,13,14),(2652,5,34,14,14),(2653,5,34,15,14),(2654,5,34,18,14),(2655,2,34,19,14),(2656,3,34,21,14),(2657,3,34,22,14),(2658,3,34,23,14),(2659,3,34,24,14),(2660,3,34,25,14),(2661,3,34,8,15),(2662,3,34,9,15),(2663,3,34,13,15),(2664,5,34,14,15),(2665,5,34,15,15),(2666,5,34,16,15),(2667,3,34,21,15),(2668,3,34,22,15),(2669,3,34,23,15),(2670,3,34,24,15),(2671,3,34,25,15),(2672,5,34,13,16),(2673,5,34,14,16),(2674,5,34,15,16),(2675,3,34,21,16),(2676,3,34,24,16),(2677,3,34,25,16),(2678,3,34,23,17),(2679,3,34,24,17),(2680,0,34,4,18),(2681,3,34,24,18),(2682,1,34,26,19),(2683,4,34,2,20),(2684,4,34,2,21),(2685,4,34,3,21),(2686,4,34,4,21),(2687,4,34,5,21),(2688,3,34,13,21),(2689,3,34,14,21),(2690,0,34,16,21),(2691,4,34,0,22),(2692,4,34,1,22),(2693,4,34,2,22),(2694,4,34,3,22),(2695,4,34,4,22),(2696,4,34,5,22),(2697,3,34,12,22),(2698,3,34,13,22),(2699,3,34,14,22),(2700,10,34,19,22),(2701,13,34,23,22),(2702,4,34,0,23),(2703,4,34,1,23),(2704,4,34,2,23),(2705,4,34,3,23),(2706,4,34,4,23),(2707,6,34,11,23),(2708,6,34,12,23),(2709,3,34,13,23),(2710,3,34,14,23),(2711,4,34,16,23),(2712,4,34,17,23),(2713,4,34,0,24),(2714,4,34,2,24),(2715,4,34,3,24),(2716,4,34,4,24),(2717,4,34,5,24),(2718,6,34,10,24),(2719,6,34,11,24),(2720,6,34,12,24),(2721,3,34,13,24),(2722,3,34,14,24),(2723,4,34,15,24),(2724,4,34,16,24),(2725,4,34,17,24),(2726,4,34,18,24),(2727,12,34,2,25),(2728,6,34,10,25),(2729,6,34,11,25),(2730,6,34,12,25),(2731,3,34,13,25),(2732,3,34,14,25),(2733,3,34,15,25),(2734,4,34,16,25),(2735,4,34,17,25),(2736,4,34,18,25),(2737,3,34,11,26),(2738,3,34,12,26),(2739,3,34,13,26),(2740,4,34,14,26),(2741,4,34,15,26),(2742,4,34,16,26),(2743,4,34,17,26),(2744,4,34,18,26),(2745,4,34,19,26),(2746,3,34,11,27),(2747,3,34,12,27),(2748,3,34,13,27),(2749,3,34,14,27),(2750,4,34,15,27),(2751,4,34,16,27),(2752,4,34,17,27),(2753,4,34,18,27),(2754,4,34,8,28),(2755,3,34,10,28),(2756,3,34,11,28),(2757,3,34,12,28),(2758,3,34,13,28),(2759,3,34,14,28),(2760,3,34,15,28),(2761,4,34,16,28),(2762,6,34,26,28),(2763,6,34,28,28),(2764,6,34,29,28),(2765,4,34,8,29),(2766,4,34,9,29),(2767,4,34,10,29),(2768,4,34,12,29),(2769,4,34,13,29),(2770,3,34,14,29),(2771,3,34,15,29),(2772,4,34,16,29),(2773,6,34,26,29),(2774,6,34,27,29),(2775,6,34,28,29),(2776,6,34,29,29),(2777,4,34,8,30),(2778,4,34,9,30),(2779,4,34,10,30),(2780,4,34,11,30),(2781,4,34,12,30),(2782,3,34,14,30),(2783,3,34,15,30),(2784,6,34,28,30),(2785,4,34,8,31),(2786,4,34,10,31),(2787,4,34,11,31),(2788,4,34,12,31),(2789,4,34,13,31),(2790,3,34,15,31),(2791,4,34,10,32),(2792,4,34,11,32),(2793,6,34,14,32),(2794,6,34,9,33),(2795,6,34,14,33),(2796,6,34,15,33),(2797,8,34,19,33),(2798,6,34,7,34),(2799,6,34,8,34),(2800,6,34,9,34),(2801,6,34,10,34),(2802,6,34,13,34),(2803,6,34,14,34),(2804,6,34,15,34),(2805,6,34,7,35),(2806,6,34,8,35),(2807,6,34,15,35),(2808,6,34,7,36),(2809,12,34,9,37),(2810,11,34,16,37),(2811,14,34,2,39),(2812,5,34,25,40),(2813,5,34,15,41),(2814,5,34,20,41),(2815,5,34,22,41),(2816,5,34,23,41),(2817,5,34,25,41),(2818,5,34,15,42),(2819,5,34,20,42),(2820,5,34,21,42),(2821,5,34,22,42),(2822,5,34,23,42),(2823,5,34,25,42),(2824,5,34,26,42),(2825,5,34,11,43),(2826,5,34,12,43),(2827,5,34,13,43),(2828,5,34,14,43),(2829,5,34,15,43),(2830,5,34,16,43),(2831,5,34,17,43),(2832,5,34,18,43),(2833,5,34,19,43),(2834,5,34,20,43),(2835,5,34,21,43),(2836,5,34,22,43),(2837,5,34,23,43),(2838,5,34,24,43),(2839,5,34,25,43),(2840,5,34,26,43),(2841,5,2,0,0),(2842,5,2,1,0),(2843,5,2,2,0),(2844,5,2,3,0),(2845,5,2,16,0),(2846,5,2,17,0),(2847,5,2,18,0),(2848,5,2,19,0),(2849,5,2,20,0),(2850,5,2,21,0),(2851,5,2,22,0),(2852,5,2,23,0),(2853,5,2,24,0),(2854,5,2,25,0),(2855,5,2,26,0),(2856,5,2,0,1),(2857,5,2,1,1),(2858,5,2,2,1),(2859,5,2,3,1),(2860,5,2,4,1),(2861,12,2,7,1),(2862,5,2,17,1),(2863,5,2,18,1),(2864,5,2,20,1),(2865,14,2,22,1),(2866,5,2,26,1),(2867,5,2,28,1),(2868,5,2,0,2),(2869,5,2,1,2),(2870,5,2,2,2),(2871,5,2,4,2),(2872,5,2,5,2),(2873,5,2,25,2),(2874,5,2,26,2),(2875,5,2,28,2),(2876,5,2,29,2),(2877,5,2,0,3),(2878,5,2,1,3),(2879,5,2,4,3),(2880,5,2,5,3),(2881,5,2,28,3),(2882,6,2,29,3),(2883,5,2,28,4),(2884,6,2,29,4),(2885,4,2,3,5),(2886,4,2,5,5),(2887,0,2,18,5),(2888,6,2,27,5),(2889,6,2,28,5),(2890,6,2,29,5),(2891,4,2,2,6),(2892,4,2,3,6),(2893,4,2,4,6),(2894,4,2,5,6),(2895,6,2,26,6),(2896,6,2,27,6),(2897,6,2,28,6),(2898,6,2,29,6),(2899,4,2,1,7),(2900,4,2,2,7),(2901,4,2,3,7),(2902,4,2,4,7),(2903,4,2,5,7),(2904,6,2,26,7),(2905,5,2,27,7),(2906,5,2,28,7),(2907,5,2,29,7),(2908,4,2,1,8),(2909,4,2,2,8),(2910,4,2,3,8),(2911,4,2,4,8),(2912,0,2,10,8),(2913,5,2,27,8),(2914,5,2,28,8),(2915,5,2,29,8),(2916,4,2,1,9),(2917,4,2,2,9),(2918,4,2,3,9),(2919,5,2,29,9),(2920,4,2,1,10),(2921,6,2,5,10),(2922,6,2,6,10),(2923,5,2,28,10),(2924,5,2,29,10),(2925,6,2,4,11),(2926,6,2,5,11),(2927,6,2,6,11),(2928,6,2,7,11),(2929,6,2,8,11),(2930,5,2,27,11),(2931,5,2,28,11),(2932,5,2,29,11),(2933,13,2,1,12),(2934,6,2,8,12),(2935,6,2,9,12),(2936,6,2,10,12),(2937,5,2,27,12),(2938,5,2,28,12),(2939,5,2,29,12),(2940,6,2,8,13),(2941,6,2,9,13),(2942,6,2,10,13),(2943,5,2,28,13),(2944,5,2,29,13),(2945,5,2,2,14),(2946,6,2,9,14),(2947,5,2,28,14),(2948,5,2,0,15),(2949,5,2,2,15),(2950,5,2,3,15),(2951,5,2,0,16),(2952,5,2,1,16),(2953,5,2,2,16),(2954,5,2,3,16),(2955,5,2,4,16),(2956,2,2,26,16),(2957,5,2,0,17),(2958,5,2,1,17),(2959,5,2,2,17),(2960,5,2,3,17),(2961,5,2,4,17),(2962,5,2,0,18),(2963,5,2,1,18),(2964,5,2,3,18),(2965,6,2,6,18),(2966,4,2,24,18),(2967,4,2,29,18),(2968,5,2,0,19),(2969,5,2,2,19),(2970,5,2,3,19),(2971,6,2,7,19),(2972,6,2,8,19),(2973,4,2,24,19),(2974,4,2,25,19),(2975,4,2,26,19),(2976,4,2,27,19),(2977,4,2,28,19),(2978,4,2,29,19),(2979,5,2,0,20),(2980,11,2,1,20),(2981,6,2,5,20),(2982,6,2,6,20),(2983,6,2,7,20),(2984,6,2,8,20),(2985,6,2,9,20),(2986,4,2,23,20),(2987,4,2,24,20),(2988,4,2,25,20),(2989,4,2,26,20),(2990,4,2,27,20),(2991,4,2,28,20),(2992,4,2,29,20),(2993,5,2,0,21),(2994,6,2,5,21),(2995,6,2,6,21),(2996,4,2,24,21),(2997,4,2,25,21),(2998,4,2,26,21),(2999,4,2,27,21),(3000,4,2,28,21),(3001,4,2,29,21),(3002,5,2,0,22),(3003,6,2,6,22),(3004,8,2,10,22),(3005,4,2,24,22),(3006,4,2,25,22),(3007,4,2,26,22),(3008,4,2,27,22),(3009,4,2,28,22),(3010,4,2,29,22),(3011,5,2,0,23),(3012,4,2,26,23),(3013,4,2,27,23),(3014,4,2,28,23),(3015,5,2,0,24),(3016,3,2,18,24),(3017,3,2,19,24),(3018,3,2,20,24),(3019,0,2,24,24),(3020,4,2,27,24),(3021,0,2,28,24),(3022,5,2,0,25),(3023,3,2,9,25),(3024,3,2,10,25),(3025,3,2,13,25),(3026,3,2,14,25),(3027,3,2,15,25),(3028,3,2,17,25),(3029,3,2,18,25),(3030,3,2,19,25),(3031,3,2,20,25),(3032,3,2,21,25),(3033,5,2,0,26),(3034,5,2,1,26),(3035,5,2,2,26),(3036,3,2,9,26),(3037,3,2,10,26),(3038,3,2,11,26),(3039,3,2,14,26),(3040,3,2,15,26),(3041,3,2,16,26),(3042,3,2,17,26),(3043,3,2,18,26),(3044,3,2,19,26),(3045,3,2,20,26),(3046,3,2,21,26),(3047,3,2,23,26),(3048,5,2,2,27),(3049,0,2,3,27),(3050,3,2,10,27),(3051,3,2,11,27),(3052,3,2,12,27),(3053,3,2,13,27),(3054,3,2,14,27),(3055,3,2,15,27),(3056,3,2,16,27),(3057,3,2,17,27),(3058,3,2,18,27),(3059,3,2,19,27),(3060,3,2,20,27),(3061,3,2,21,27),(3062,3,2,22,27),(3063,3,2,23,27),(3064,3,2,24,27),(3065,0,2,0,28),(3066,3,2,11,28),(3067,3,2,12,28),(3068,3,2,13,28),(3069,3,2,14,28),(3070,3,2,15,28),(3071,3,2,16,28),(3072,3,2,17,28),(3073,3,2,18,28),(3074,3,2,19,28),(3075,3,2,20,28),(3076,3,2,21,28),(3077,3,2,22,28),(3078,3,2,23,28),(3079,3,2,24,28),(3080,3,2,10,29),(3081,3,2,11,29),(3082,3,2,12,29),(3083,3,2,13,29),(3084,3,2,14,29),(3085,3,2,15,29),(3086,3,2,16,29),(3087,3,2,17,29),(3088,3,2,18,29),(3089,3,2,19,29),(3090,3,2,20,29),(3091,3,2,21,29),(3092,3,2,22,29),(3093,3,2,23,29);
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
  `location_type` tinyint(2) unsigned NOT NULL default '0',
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
INSERT INTO `units` VALUES (1,120,1,2,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,18,28,NULL,1,0,0,0),(2,120,1,2,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,18,28,NULL,1,0,0,0),(3,120,1,2,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,18,28,NULL,1,0,0,0),(4,120,1,2,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,18,28,NULL,1,0,0,0),(5,120,1,2,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,18,28,NULL,1,0,0,0),(6,140,1,2,4,NULL,NULL,NULL,NULL,0,0,'Glancer',0,18,28,NULL,1,0,0,0),(7,140,1,2,4,NULL,NULL,NULL,NULL,0,0,'Glancer',0,18,28,NULL,1,0,0,0),(8,140,1,2,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,18,28,NULL,1,0,0,0),(9,140,1,2,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,18,28,NULL,1,0,0,0),(10,120,1,2,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,18,28,NULL,1,0,0,0),(11,120,1,2,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,18,28,NULL,1,0,0,0),(12,120,1,2,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,18,28,NULL,1,0,0,0),(13,120,1,2,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,26,16,NULL,1,0,0,0),(14,120,1,2,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,26,16,NULL,1,0,0,0),(15,120,1,2,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,26,16,NULL,1,0,0,0),(16,120,1,2,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,26,16,NULL,1,0,0,0),(17,120,1,2,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,26,16,NULL,1,0,0,0),(18,140,1,2,4,NULL,NULL,NULL,NULL,0,0,'Glancer',0,26,16,NULL,1,0,0,0),(19,140,1,2,4,NULL,NULL,NULL,NULL,0,0,'Glancer',0,26,16,NULL,1,0,0,0),(20,140,1,2,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,26,16,NULL,1,0,0,0),(21,140,1,2,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,26,16,NULL,1,0,0,0),(22,120,1,2,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,26,16,NULL,1,0,0,0),(23,120,1,2,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,26,16,NULL,1,0,0,0),(24,120,1,2,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,26,16,NULL,1,0,0,0),(25,120,1,2,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,3,27,NULL,1,0,0,0),(26,120,1,2,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,3,27,NULL,1,0,0,0),(27,120,1,2,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,3,27,NULL,1,0,0,0),(28,120,1,2,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,3,27,NULL,1,0,0,0),(29,120,1,2,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,3,27,NULL,1,0,0,0),(30,140,1,2,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,3,27,NULL,1,0,0,0),(31,140,1,2,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,3,27,NULL,1,0,0,0),(32,120,1,2,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,28,24,NULL,1,0,0,0),(33,120,1,2,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,28,24,NULL,1,0,0,0),(34,120,1,2,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,28,24,NULL,1,0,0,0),(35,120,1,2,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,28,24,NULL,1,0,0,0),(36,120,1,2,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,28,24,NULL,1,0,0,0),(37,140,1,2,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,28,24,NULL,1,0,0,0),(38,140,1,2,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,28,24,NULL,1,0,0,0),(39,120,1,2,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,18,25,NULL,1,0,0,0),(40,120,1,2,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,18,25,NULL,1,0,0,0),(41,120,1,2,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,18,25,NULL,1,0,0,0),(42,120,1,2,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,18,25,NULL,1,0,0,0),(43,120,1,2,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,18,25,NULL,1,0,0,0),(44,140,1,2,4,NULL,NULL,NULL,NULL,0,0,'Glancer',0,18,25,NULL,1,0,0,0),(45,140,1,2,4,NULL,NULL,NULL,NULL,0,0,'Glancer',0,18,25,NULL,1,0,0,0),(46,140,1,2,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,18,25,NULL,1,0,0,0),(47,140,1,2,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,18,25,NULL,1,0,0,0),(48,120,1,2,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,18,25,NULL,1,0,0,0),(49,120,1,2,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,18,25,NULL,1,0,0,0),(50,120,1,2,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,18,25,NULL,1,0,0,0),(51,120,1,2,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,15,26,NULL,1,0,0,0),(52,120,1,2,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,15,26,NULL,1,0,0,0),(53,120,1,2,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,15,26,NULL,1,0,0,0),(54,120,1,2,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,15,26,NULL,1,0,0,0),(55,120,1,2,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,15,26,NULL,1,0,0,0),(56,140,1,2,4,NULL,NULL,NULL,NULL,0,0,'Glancer',0,15,26,NULL,1,0,0,0),(57,140,1,2,4,NULL,NULL,NULL,NULL,0,0,'Glancer',0,15,26,NULL,1,0,0,0),(58,140,1,2,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,15,26,NULL,1,0,0,0),(59,140,1,2,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,15,26,NULL,1,0,0,0),(60,120,1,2,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,15,26,NULL,1,0,0,0),(61,120,1,2,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,15,26,NULL,1,0,0,0),(62,120,1,2,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,15,26,NULL,1,0,0,0),(63,120,1,2,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,7,28,NULL,1,0,0,0),(64,120,1,2,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,7,28,NULL,1,0,0,0),(65,120,1,2,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,7,28,NULL,1,0,0,0),(66,120,1,2,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,7,28,NULL,1,0,0,0),(67,120,1,2,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,7,28,NULL,1,0,0,0),(68,140,1,2,4,NULL,NULL,NULL,NULL,0,0,'Glancer',0,7,28,NULL,1,0,0,0),(69,140,1,2,4,NULL,NULL,NULL,NULL,0,0,'Glancer',0,7,28,NULL,1,0,0,0),(70,140,1,2,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,7,28,NULL,1,0,0,0),(71,140,1,2,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,7,28,NULL,1,0,0,0),(72,120,1,2,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,7,28,NULL,1,0,0,0),(73,120,1,2,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,7,28,NULL,1,0,0,0),(74,120,1,2,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,7,28,NULL,1,0,0,0),(75,120,1,2,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,24,24,NULL,1,0,0,0),(76,120,1,2,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,24,24,NULL,1,0,0,0),(77,120,1,2,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,24,24,NULL,1,0,0,0),(78,120,1,2,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,24,24,NULL,1,0,0,0),(79,120,1,2,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,24,24,NULL,1,0,0,0),(80,140,1,2,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,24,24,NULL,1,0,0,0),(81,140,1,2,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,24,24,NULL,1,0,0,0),(82,120,1,2,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,0,28,NULL,1,0,0,0),(83,120,1,2,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,0,28,NULL,1,0,0,0),(84,120,1,2,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,0,28,NULL,1,0,0,0),(85,120,1,2,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,0,28,NULL,1,0,0,0),(86,120,1,2,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,0,28,NULL,1,0,0,0),(87,140,1,2,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,0,28,NULL,1,0,0,0),(88,140,1,2,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,0,28,NULL,1,0,0,0),(89,120,1,2,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,22,27,NULL,1,0,0,0),(90,120,1,2,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,22,27,NULL,1,0,0,0),(91,120,1,2,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,22,27,NULL,1,0,0,0),(92,120,1,2,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,22,27,NULL,1,0,0,0),(93,120,1,2,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,22,27,NULL,1,0,0,0),(94,140,1,2,4,NULL,NULL,NULL,NULL,0,0,'Glancer',0,22,27,NULL,1,0,0,0),(95,140,1,2,4,NULL,NULL,NULL,NULL,0,0,'Glancer',0,22,27,NULL,1,0,0,0),(96,140,1,2,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,22,27,NULL,1,0,0,0),(97,140,1,2,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,22,27,NULL,1,0,0,0),(98,120,1,2,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,22,27,NULL,1,0,0,0),(99,120,1,2,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,22,27,NULL,1,0,0,0),(100,120,1,2,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,22,27,NULL,1,0,0,0),(101,120,1,2,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,25,20,NULL,1,0,0,0),(102,120,1,2,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,25,20,NULL,1,0,0,0),(103,120,1,2,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,25,20,NULL,1,0,0,0),(104,120,1,2,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,25,20,NULL,1,0,0,0),(105,120,1,2,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,25,20,NULL,1,0,0,0),(106,140,1,2,4,NULL,NULL,NULL,NULL,0,0,'Glancer',0,25,20,NULL,1,0,0,0),(107,140,1,2,4,NULL,NULL,NULL,NULL,0,0,'Glancer',0,25,20,NULL,1,0,0,0),(108,140,1,2,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,25,20,NULL,1,0,0,0),(109,140,1,2,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,25,20,NULL,1,0,0,0),(110,120,1,2,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,25,20,NULL,1,0,0,0),(111,120,1,2,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,25,20,NULL,1,0,0,0),(112,120,1,2,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,25,20,NULL,1,0,0,0),(113,120,1,2,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,12,27,NULL,1,0,0,0),(114,120,1,2,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,12,27,NULL,1,0,0,0),(115,120,1,2,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,12,27,NULL,1,0,0,0),(116,120,1,2,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,12,27,NULL,1,0,0,0),(117,120,1,2,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,12,27,NULL,1,0,0,0),(118,140,1,2,4,NULL,NULL,NULL,NULL,0,0,'Glancer',0,12,27,NULL,1,0,0,0),(119,140,1,2,4,NULL,NULL,NULL,NULL,0,0,'Glancer',0,12,27,NULL,1,0,0,0),(120,140,1,2,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,12,27,NULL,1,0,0,0),(121,140,1,2,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,12,27,NULL,1,0,0,0),(122,120,1,2,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,12,27,NULL,1,0,0,0),(123,120,1,2,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,12,27,NULL,1,0,0,0),(124,120,1,2,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,12,27,NULL,1,0,0,0),(125,120,1,2,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,26,27,NULL,1,0,0,0),(126,120,1,2,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,26,27,NULL,1,0,0,0),(127,120,1,2,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,26,27,NULL,1,0,0,0),(128,120,1,2,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,26,27,NULL,1,0,0,0),(129,120,1,2,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,26,27,NULL,1,0,0,0),(130,140,1,2,4,NULL,NULL,NULL,NULL,0,0,'Glancer',0,26,27,NULL,1,0,0,0),(131,140,1,2,4,NULL,NULL,NULL,NULL,0,0,'Glancer',0,26,27,NULL,1,0,0,0),(132,140,1,2,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,26,27,NULL,1,0,0,0),(133,140,1,2,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,26,27,NULL,1,0,0,0),(134,120,1,2,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,26,27,NULL,1,0,0,0),(135,120,1,2,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,26,27,NULL,1,0,0,0),(136,120,1,2,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,26,27,NULL,1,0,0,0);
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

-- Dump completed on 2010-11-07 21:27:22
