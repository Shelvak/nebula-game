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
INSERT INTO `buildings` VALUES (1,38,7,16,0,0,0,1,'Thunder',NULL,8,17,NULL,1,300,NULL,0,NULL,NULL,0),(2,38,21,16,0,0,0,1,'Thunder',NULL,22,17,NULL,1,300,NULL,0,NULL,NULL,0),(3,38,21,9,0,0,0,1,'Screamer',NULL,22,10,NULL,1,300,NULL,0,NULL,NULL,0),(4,38,18,28,0,0,0,1,'NpcSolarPlant',NULL,19,29,NULL,0,1000,NULL,0,NULL,NULL,0),(5,38,7,9,0,0,0,1,'Vulcan',NULL,8,10,NULL,1,300,NULL,0,NULL,NULL,0),(6,38,14,22,0,0,0,1,'Thunder',NULL,15,23,NULL,1,300,NULL,0,NULL,NULL,0),(7,38,26,16,0,0,0,1,'NpcZetiumExtractor',NULL,27,17,NULL,0,800,NULL,0,NULL,NULL,0),(8,38,3,27,0,0,0,1,'NpcMetalExtractor',NULL,4,28,NULL,0,400,NULL,0,NULL,NULL,0),(9,38,28,24,0,0,0,1,'NpcMetalExtractor',NULL,29,25,NULL,0,400,NULL,0,NULL,NULL,0),(10,38,18,25,0,0,0,1,'NpcSolarPlant',NULL,19,26,NULL,0,1000,NULL,0,NULL,NULL,0),(11,38,15,26,0,0,0,1,'NpcSolarPlant',NULL,16,27,NULL,0,1000,NULL,0,NULL,NULL,0),(12,38,7,28,0,0,0,1,'NpcCommunicationsHub',NULL,9,29,NULL,0,1200,NULL,0,NULL,NULL,0),(13,38,21,22,0,0,0,1,'Vulcan',NULL,22,23,NULL,1,300,NULL,0,NULL,NULL,0),(14,38,24,24,0,0,0,1,'NpcMetalExtractor',NULL,25,25,NULL,0,400,NULL,0,NULL,NULL,0),(15,38,0,28,0,0,0,1,'NpcMetalExtractor',NULL,1,29,NULL,0,400,NULL,0,NULL,NULL,0),(16,38,11,14,0,0,0,1,'Mothership',NULL,18,19,NULL,1,10500,NULL,0,NULL,NULL,0),(17,38,22,27,0,0,0,1,'NpcSolarPlant',NULL,23,28,NULL,0,1000,NULL,0,NULL,NULL,0),(18,38,14,9,0,0,0,1,'Thunder',NULL,15,10,NULL,1,300,NULL,0,NULL,NULL,0),(19,38,25,20,0,0,0,1,'NpcTemple',NULL,27,22,NULL,0,1500,NULL,0,NULL,NULL,0),(20,38,12,27,0,0,0,1,'NpcSolarPlant',NULL,13,28,NULL,0,1000,NULL,0,NULL,NULL,0),(21,38,7,22,0,0,0,1,'Screamer',NULL,8,23,NULL,1,300,NULL,0,NULL,NULL,0),(22,38,26,27,0,0,0,1,'NpcCommunicationsHub',NULL,28,28,NULL,0,1200,NULL,0,NULL,NULL,0);
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
INSERT INTO `folliages` VALUES (4,0,0,13),(4,0,1,10),(4,0,2,13),(4,0,3,3),(4,0,4,6),(4,0,5,2),(4,0,12,4),(4,0,16,11),(4,0,22,6),(4,0,23,9),(4,0,28,3),(4,0,29,13),(4,1,2,10),(4,1,7,1),(4,1,10,11),(4,1,15,3),(4,1,27,4),(4,2,2,11),(4,2,8,11),(4,2,11,9),(4,2,14,0),(4,2,19,5),(4,2,29,1),(4,3,1,7),(4,3,14,4),(4,3,29,5),(4,4,4,1),(4,4,10,12),(4,4,11,3),(4,4,12,5),(4,4,21,6),(4,4,28,3),(4,5,1,12),(4,5,7,2),(4,5,8,7),(4,5,9,7),(4,5,11,3),(4,5,12,9),(4,5,15,9),(4,5,16,10),(4,6,6,11),(4,6,12,8),(4,6,14,1),(4,6,16,9),(4,6,28,12),(4,7,16,1),(4,7,18,5),(4,7,23,0),(4,7,26,1),(4,7,28,7),(4,7,29,12),(4,8,20,12),(4,8,23,12),(4,8,27,8),(4,9,7,11),(4,9,8,8),(4,9,28,6),(4,10,16,1),(4,10,21,5),(4,10,24,12),(4,10,26,2),(4,11,10,8),(4,11,20,9),(4,11,28,0),(4,12,23,13),(4,12,29,8),(4,13,3,7),(4,13,27,1),(4,14,5,1),(4,15,8,11),(4,15,19,13),(4,15,22,3),(4,15,29,11),(4,16,17,1),(4,16,22,12),(4,16,24,2),(4,17,9,6),(4,17,10,8),(4,17,22,6),(4,17,24,10),(4,18,20,12),(4,18,24,13),(4,18,25,11),(4,19,21,8),(4,20,23,4),(4,20,24,13),(4,20,28,2),(4,21,20,5),(4,21,22,6),(4,21,23,4),(4,21,26,4),(4,22,0,11),(4,22,13,11),(4,22,18,7),(4,23,1,13),(4,23,20,9),(4,23,25,4),(4,23,26,0),(4,24,15,3),(4,24,25,13),(4,24,26,8),(4,25,7,9),(4,25,10,8),(4,25,15,6),(4,25,17,1),(4,25,18,12),(4,25,26,9),(4,25,29,6),(4,26,10,11),(4,26,12,4),(4,26,15,8),(4,26,16,8),(4,26,18,11),(4,26,19,7),(4,26,24,3),(4,26,25,13),(4,27,2,5),(4,27,11,11),(4,27,13,12),(4,27,17,4),(4,27,18,1),(4,27,24,3),(4,27,27,10),(4,28,5,7),(4,28,14,1),(4,28,26,13),(4,29,2,7),(4,29,7,11),(4,29,11,11),(4,29,24,6),(4,29,26,8),(4,29,27,5),(4,29,28,10),(4,30,2,2),(4,31,2,1),(4,31,4,4),(4,31,7,12),(4,31,9,6),(4,31,14,3),(4,31,15,1),(4,31,16,9),(4,32,6,11),(4,32,8,5),(4,32,11,2),(4,32,15,7),(4,32,29,12),(4,33,6,3),(4,33,11,2),(4,33,12,9),(4,33,15,0),(4,33,16,13),(4,34,7,6),(4,34,14,11),(4,34,17,8),(4,34,18,0),(4,34,20,4),(4,35,8,12),(4,35,10,1),(4,35,14,9),(4,35,16,0),(4,35,17,8),(4,35,19,9),(4,35,27,1),(4,36,7,8),(4,36,12,2),(4,36,27,13),(4,37,10,6),(4,37,12,3),(4,37,16,1),(4,37,19,10),(4,37,27,10),(4,38,17,3),(4,38,18,3),(4,38,21,4),(4,38,29,4),(4,39,9,6),(4,39,13,10),(4,39,17,5),(4,39,26,9),(4,39,29,12),(4,40,5,9),(4,40,8,13),(4,40,21,5),(4,41,6,12),(4,41,7,5),(4,41,9,3),(4,41,10,5),(4,41,12,6),(4,41,14,9),(4,41,21,6),(4,41,23,3),(4,41,26,0),(4,41,29,5),(4,42,7,8),(4,42,8,8),(4,42,18,10),(4,42,20,10),(4,42,22,6),(4,43,7,8),(4,43,11,10),(4,43,14,3),(4,43,16,9),(4,43,17,3),(4,44,8,4),(4,44,21,4),(4,44,23,13),(4,45,5,12),(4,45,10,13),(4,45,15,0),(4,46,5,0),(4,47,7,11),(4,47,11,6),(4,48,7,0),(4,48,13,6),(4,48,26,9),(4,49,11,11),(4,49,13,13),(4,49,26,4),(4,49,28,9),(4,50,7,10),(4,50,11,9),(4,50,19,0),(4,50,27,9),(4,50,28,3),(4,50,29,3),(4,51,0,5),(4,51,8,11),(4,51,11,5),(4,51,16,2),(4,51,19,4),(4,51,20,10),(4,51,23,0),(4,51,26,8),(4,51,28,3),(4,52,10,6),(4,52,24,11),(4,52,25,7),(20,0,2,4),(20,0,3,1),(20,1,13,6),(20,4,0,10),(20,5,4,1),(20,5,12,12),(20,6,2,12),(20,6,3,7),(20,6,13,7),(20,7,3,1),(20,9,4,5),(20,9,6,7),(20,10,13,0),(20,11,9,8),(20,11,13,0),(20,12,10,4),(20,13,0,1),(20,13,1,8),(20,15,7,8),(20,15,13,0),(20,18,13,5),(20,20,0,10),(20,20,5,7),(20,21,0,11),(20,21,12,4),(20,23,9,2),(20,25,9,7),(20,26,3,3),(20,26,8,2),(20,27,8,2),(20,28,2,10),(20,31,2,9),(20,33,5,6),(20,33,7,5),(20,34,8,3),(20,35,8,11),(20,35,9,8),(20,35,12,8),(20,36,4,10),(20,36,11,8),(20,36,12,9),(20,37,4,13),(20,37,8,8),(20,37,9,4),(20,37,13,6),(20,38,4,8),(20,38,9,7),(20,40,2,4),(20,40,3,7),(20,40,13,0),(20,41,6,13),(20,41,13,0),(20,42,6,13),(20,42,13,1),(20,43,10,9),(20,43,12,0),(21,0,0,11),(21,0,1,12),(21,0,3,8),(21,0,4,9),(21,0,5,4),(21,1,2,4),(21,1,4,11),(21,1,5,11),(21,1,9,10),(21,1,23,2),(21,2,7,3),(21,2,19,13),(21,2,22,5),(21,2,24,6),(21,3,7,4),(21,3,8,1),(21,3,13,5),(21,4,24,10),(21,5,23,11),(21,6,13,12),(21,6,16,5),(21,7,17,4),(21,8,18,11),(21,9,2,4),(21,10,4,0),(21,10,20,0),(21,10,21,5),(21,11,1,10),(21,11,4,11),(21,11,5,9),(21,11,24,1),(21,13,5,6),(21,13,12,13),(21,13,20,6),(21,13,24,8),(21,14,3,6),(21,14,8,13),(21,14,12,1),(21,14,24,8),(21,15,7,7),(21,15,8,7),(21,15,13,6),(21,15,17,6),(21,16,3,8),(21,16,4,9),(21,16,6,1),(21,16,7,11),(21,16,10,3),(21,16,16,12),(21,16,17,11),(21,17,5,8),(21,17,7,4),(21,17,10,10),(21,18,11,6),(21,18,17,12),(21,19,10,4),(21,19,14,1),(21,20,8,8),(21,20,19,10),(21,23,4,2),(21,23,19,0),(21,24,3,3),(21,24,17,8),(21,26,10,4),(21,26,11,0),(21,26,19,2),(21,27,1,1),(21,28,1,5),(21,28,6,3),(21,28,10,4),(21,28,24,8),(21,29,10,13),(21,29,20,5),(21,29,23,5),(21,30,1,4),(21,30,7,1),(21,30,19,6),(21,31,23,6),(21,31,24,6),(21,32,9,1),(21,32,19,12),(21,32,23,5),(21,32,24,2),(21,33,14,0),(21,33,16,6),(21,33,18,4),(21,34,13,8),(21,35,12,13),(21,36,19,9),(21,36,20,6),(21,37,7,13),(21,37,8,6),(21,37,9,8),(21,37,11,5),(21,37,13,2),(21,39,15,5),(21,39,17,1),(21,40,0,5),(21,40,16,6),(21,40,20,1),(21,41,4,5),(21,41,5,1),(21,41,20,12),(21,41,23,2),(21,42,7,13),(21,42,11,9),(21,42,17,3),(21,42,19,10),(21,43,3,11),(21,43,9,8),(21,43,21,2),(21,43,23,10),(21,44,3,11),(21,44,8,12),(21,44,22,13),(21,44,23,9),(21,45,3,13),(21,45,5,12),(21,45,7,12),(21,45,16,2),(21,45,20,4),(21,45,21,11),(22,0,4,8),(22,0,13,7),(22,0,14,2),(22,1,13,7),(22,2,13,4),(22,3,1,8),(22,3,8,6),(22,4,13,1),(22,5,13,0),(22,5,14,0),(22,7,9,13),(22,7,14,2),(22,8,2,13),(22,8,4,8),(22,8,11,10),(22,8,14,2),(22,8,15,13),(22,9,3,13),(22,9,4,8),(22,9,13,12),(22,10,6,9),(22,10,7,6),(22,11,2,6),(22,11,7,0),(22,11,11,4),(22,11,15,3),(22,12,1,7),(22,12,7,11),(22,12,15,6),(22,13,0,4),(22,13,4,6),(22,13,6,1),(22,13,7,3),(22,15,4,3),(22,16,15,9),(22,17,5,2),(22,17,15,2),(22,18,1,9),(22,18,2,13),(22,18,5,0),(22,18,10,4),(22,19,1,3),(22,19,4,13),(22,19,15,11),(22,20,3,10),(22,20,7,6),(22,22,0,6),(22,22,2,2),(22,23,2,13),(22,23,3,2),(22,24,1,12),(22,24,2,4),(22,25,8,3),(22,30,5,13),(22,31,6,10),(22,32,5,10),(22,32,10,4),(22,33,4,1),(22,35,2,11),(22,35,9,5),(22,36,2,5),(22,38,2,10),(22,38,3,1),(22,38,11,0),(22,39,1,12),(22,39,2,0),(22,39,14,8),(23,0,9,2),(23,0,12,10),(23,0,13,10),(23,0,14,3),(23,0,15,12),(23,0,16,4),(23,3,9,7),(23,3,12,11),(23,3,16,8),(23,4,6,6),(23,4,14,6),(23,5,14,10),(23,6,10,1),(23,6,18,7),(23,6,20,9),(23,7,1,10),(23,8,3,4),(23,8,20,0),(23,9,0,8),(23,9,4,3),(23,9,14,9),(23,9,20,5),(23,10,1,10),(23,10,2,8),(23,10,7,10),(23,11,3,0),(23,11,5,13),(23,11,8,2),(23,11,10,3),(23,11,19,1),(23,12,4,2),(23,13,2,2),(23,13,5,13),(23,13,6,5),(23,13,7,11),(23,13,8,13),(23,14,3,7),(23,14,4,7),(23,14,6,1),(23,14,18,5),(23,15,1,2),(23,16,0,8),(23,16,19,6),(23,17,20,3),(23,18,19,7),(23,19,3,1),(23,19,8,0),(23,19,20,3),(23,20,6,3),(23,20,8,3),(23,20,9,13),(23,21,9,9),(23,21,20,4),(23,22,9,4),(23,22,10,7),(23,23,9,7),(23,23,12,5),(23,23,15,10),(23,23,16,1),(23,23,17,3),(23,24,6,2),(23,24,7,4),(23,24,10,3),(23,24,12,2),(23,24,16,0),(23,24,17,5),(23,24,19,12),(23,25,10,8),(23,25,11,0),(23,25,14,10),(23,25,17,10),(23,26,7,12),(23,27,8,0),(23,27,11,8),(23,28,11,11),(23,28,14,1),(23,29,0,13),(23,29,3,7),(23,29,11,1),(23,29,20,4),(23,30,9,2),(23,31,1,7),(23,31,7,0),(23,31,10,10),(23,31,18,1),(23,32,0,11),(23,34,6,5),(23,34,8,3),(23,35,0,6),(23,35,8,2),(23,36,6,7),(23,36,9,12),(23,37,1,6),(23,37,5,4),(23,37,11,11),(23,37,15,4),(23,38,0,8),(23,38,9,8),(23,39,14,3),(23,39,15,9),(23,40,7,5),(23,41,1,11),(23,41,5,5),(23,41,6,9),(23,44,16,5),(23,45,15,10),(23,45,16,3),(23,46,4,10),(23,46,9,5),(23,46,13,2),(23,47,15,13),(23,48,0,5),(23,48,11,2),(23,49,9,7),(23,49,12,4),(23,49,15,9),(23,50,10,11),(23,50,11,5),(23,51,9,7),(23,51,11,4),(23,52,2,3),(23,52,6,1),(23,52,9,11),(23,52,11,8),(23,53,0,3),(23,53,1,4),(27,0,5,0),(27,0,6,8),(27,0,12,4),(27,0,20,0),(27,0,21,6),(27,1,6,13),(27,1,9,12),(27,1,12,12),(27,1,22,0),(27,2,15,11),(27,2,16,5),(27,2,17,10),(27,2,19,4),(27,2,23,5),(27,3,8,4),(27,3,17,3),(27,3,19,8),(27,4,7,4),(27,4,18,5),(27,4,24,0),(27,5,16,1),(27,6,18,10),(27,7,4,11),(27,7,15,11),(27,7,17,8),(27,8,4,0),(27,8,13,11),(27,9,7,11),(27,9,24,5),(27,10,24,10),(27,12,23,2),(27,13,5,0),(27,15,8,12),(27,16,6,12),(27,16,7,3),(27,16,8,12),(27,16,24,0),(27,17,12,6),(27,17,13,1),(27,17,24,3),(27,18,14,4),(27,19,1,4),(27,19,20,0),(27,20,15,4),(27,20,17,5),(27,20,21,8),(27,20,23,13),(27,21,4,7),(27,21,10,3),(27,21,11,2),(27,22,3,8),(27,22,5,10),(27,22,12,7),(27,23,13,0),(27,23,16,1),(27,23,24,10),(27,24,9,10),(27,24,13,9),(27,24,16,5),(27,25,1,8),(27,25,8,12),(27,25,16,13),(27,25,18,5),(27,25,21,5),(27,26,10,3),(27,26,17,2),(27,27,1,10),(27,27,12,3),(27,27,13,4),(27,27,15,12),(27,27,21,10),(27,28,1,4),(27,28,8,7),(27,28,23,12),(27,29,2,10),(27,29,3,2),(27,29,4,5),(27,29,6,3),(27,29,9,11),(27,29,23,5),(27,30,8,3),(27,32,0,10),(27,32,4,5),(27,32,5,3),(27,34,5,2),(27,34,6,1),(27,34,8,3),(27,35,6,2),(27,35,7,13),(27,35,8,9),(27,36,2,3),(27,36,4,4),(27,36,6,10),(27,36,7,11),(27,37,6,3),(27,38,0,6),(27,38,6,1),(27,39,0,4),(27,39,8,4),(27,39,9,2),(27,39,18,7),(27,39,22,6),(27,40,0,12),(27,40,8,13),(27,40,9,3),(27,40,23,10),(27,41,6,10),(27,41,20,9),(27,41,24,0),(27,42,13,11),(27,42,16,10),(27,42,19,5),(27,42,21,12),(27,43,17,12),(27,43,21,11),(27,43,24,12),(27,44,23,1),(27,45,1,13),(27,45,6,13),(27,45,14,6),(27,46,24,8),(27,47,6,9),(27,47,9,9),(27,47,10,8),(27,49,4,11),(27,49,6,4),(27,49,19,4),(27,49,20,4),(27,50,0,0),(27,50,2,11),(27,50,3,11),(27,50,4,6),(27,50,5,13),(27,50,7,6),(27,50,10,5),(30,0,3,4),(30,0,14,9),(30,0,16,9),(30,1,13,5),(30,2,4,7),(30,2,13,9),(30,3,2,12),(30,3,4,9),(30,3,5,2),(30,3,21,5),(30,4,3,0),(30,4,21,1),(30,5,4,12),(30,5,5,12),(30,5,6,5),(30,5,8,12),(30,6,2,11),(30,7,2,4),(30,7,5,10),(30,7,6,11),(30,7,10,8),(30,8,9,4),(30,9,7,9),(30,9,9,2),(30,9,11,13),(30,10,0,11),(30,10,10,13),(30,11,13,12),(30,11,20,3),(30,12,2,1),(30,13,9,7),(30,13,19,2),(30,14,15,0),(30,14,17,2),(30,15,18,13),(30,16,2,8),(30,16,13,2),(30,16,19,6),(30,17,1,7),(30,17,2,0),(30,17,4,1),(30,17,5,6),(30,18,0,8),(30,18,8,6),(30,18,18,9),(30,19,9,2),(30,19,18,4),(30,20,0,10),(30,20,9,7),(30,21,9,12),(30,21,16,11),(30,22,15,1),(30,22,18,2),(30,22,19,2),(30,23,15,9),(30,24,18,6),(30,25,5,2),(30,25,15,6),(30,26,8,5),(30,26,17,2),(30,27,8,10),(30,27,9,9),(30,28,8,3),(30,29,5,9),(30,29,6,10),(30,29,10,6),(30,29,13,0),(30,30,10,12),(30,30,12,0),(30,31,3,9),(30,31,4,12),(30,31,7,6),(30,31,10,3),(30,32,1,0),(30,32,2,9),(30,32,3,0),(30,32,10,13),(30,32,17,6),(30,33,8,2),(30,33,9,10),(30,33,14,8),(30,33,17,7),(30,33,21,5),(30,34,4,9),(30,34,17,11),(30,35,7,4),(30,35,9,4),(30,35,21,11),(30,36,5,11),(30,36,14,5),(30,36,15,7),(30,37,7,2),(30,39,20,12),(30,40,7,5),(30,41,4,0),(30,41,17,5),(30,41,20,1),(30,42,21,11),(30,43,11,9),(30,43,21,2),(30,44,1,4),(30,44,3,2),(30,44,5,2),(30,44,11,9),(30,45,3,4),(30,46,1,9),(30,46,21,0),(30,47,2,3),(30,47,4,6),(30,47,5,5),(30,47,6,6),(30,47,7,1),(30,48,0,0),(30,48,1,8),(33,0,9,13),(33,0,11,13),(33,0,19,4),(33,1,7,9),(33,1,10,6),(33,1,14,4),(33,1,16,11),(33,1,20,13),(33,2,3,4),(33,2,12,6),(33,2,16,12),(33,3,0,5),(33,3,5,10),(33,3,11,7),(33,4,11,11),(33,4,19,12),(33,5,17,0),(33,5,18,8),(33,6,10,10),(33,6,11,7),(33,6,13,1),(33,7,7,5),(33,7,10,1),(33,8,10,13),(33,10,6,12),(33,11,5,11),(33,13,1,11),(33,14,1,8),(33,14,17,3),(33,15,11,0),(33,15,18,11),(33,15,19,6),(33,17,16,5),(33,19,1,3),(33,19,10,12),(33,19,11,1),(33,19,18,7),(33,20,4,5),(33,20,6,11),(33,20,7,10),(33,20,10,6),(33,21,6,3),(33,21,10,6),(33,22,1,7),(33,22,4,13),(33,22,6,2),(33,22,7,13),(33,22,8,3),(33,23,4,10),(33,23,7,9),(33,23,8,3),(33,24,20,8),(33,25,8,5),(33,25,9,9),(33,25,20,9),(33,26,20,10),(33,27,19,3),(33,28,0,7),(33,28,9,2),(33,29,9,3),(33,29,20,12),(33,30,5,11),(33,30,9,1),(33,31,1,11),(33,32,1,11),(33,32,2,0),(33,32,3,10),(33,32,4,0),(33,32,5,9),(33,32,15,4),(33,32,16,1),(33,32,18,2),(33,33,0,5),(33,33,3,0),(33,33,5,1),(33,33,10,0),(33,33,12,5),(33,33,13,0),(33,34,1,3),(33,35,12,7),(33,35,13,9),(33,37,3,13),(34,0,11,1),(34,0,12,12),(34,0,17,0),(34,1,20,7),(34,2,19,2),(34,3,12,12),(34,4,10,1),(34,4,11,7),(34,4,17,0),(34,4,18,12),(34,5,5,7),(34,5,14,7),(34,6,4,8),(34,6,9,9),(34,6,14,13),(34,6,19,8),(34,7,14,5),(34,7,15,0),(34,7,16,12),(34,8,13,9),(34,8,15,5),(34,8,17,12),(34,8,18,3),(34,9,18,3),(34,10,23,10),(34,11,8,10),(34,11,11,3),(34,11,23,11),(34,12,7,5),(34,12,11,4),(34,13,14,8),(34,13,23,1),(34,14,2,5),(34,16,2,13),(34,16,4,4),(34,16,10,7),(34,16,22,6),(34,17,14,9),(34,17,15,5),(34,17,18,5),(34,17,20,5),(34,17,22,11),(34,18,13,9),(34,18,14,13),(34,19,1,12),(34,19,2,13),(34,19,11,8),(34,19,12,5),(34,19,15,10),(34,20,0,4),(34,20,12,6),(34,20,20,11),(34,21,1,12),(34,21,14,4),(34,21,15,3),(34,21,22,5),(34,22,9,3),(34,22,10,10),(34,22,18,4),(34,22,19,3),(34,22,21,8),(34,23,14,9),(34,23,22,4),(34,24,3,6),(34,24,7,8),(34,24,8,11),(34,24,23,7),(34,25,6,7),(34,25,9,1),(34,25,11,10),(34,25,17,2),(34,25,18,1),(34,25,19,2),(34,26,0,0),(34,26,5,11),(34,27,1,8),(34,27,2,2),(34,27,5,0),(34,28,3,12),(34,28,7,6),(34,28,10,4),(34,28,12,3),(34,28,14,4),(34,28,17,4),(34,29,0,2),(34,29,2,10),(34,29,3,7),(34,29,5,9),(34,29,8,1),(34,29,10,7),(34,29,12,2),(34,30,2,11),(34,30,15,4),(34,30,18,9),(34,30,20,12),(34,30,21,7),(34,31,14,6),(34,31,15,2),(34,31,17,9),(34,32,3,0),(34,33,0,1),(34,33,1,7),(34,33,15,10),(34,35,5,2),(34,36,3,12),(34,37,2,2),(34,38,1,7),(34,39,10,5),(34,39,23,2),(34,40,12,2),(34,40,14,0),(34,40,16,8),(34,41,0,5),(34,41,1,3),(34,41,4,11),(34,41,13,5),(34,41,15,8),(34,41,21,2),(34,42,6,7),(34,42,12,5),(34,42,13,4),(34,42,22,13),(34,43,19,1),(34,44,10,3),(34,45,5,11),(34,45,10,7),(34,45,21,1),(34,46,17,2),(34,49,13,9),(34,49,18,5),(34,51,6,3),(34,51,7,3),(34,51,9,5),(34,51,13,1),(34,51,18,7),(34,52,0,5),(34,52,2,12),(34,52,13,5),(34,53,2,11),(34,53,5,1),(34,53,6,7),(34,53,7,10),(34,53,10,0),(34,53,12,13),(36,0,3,9),(36,0,4,9),(36,0,5,13),(36,0,20,10),(36,1,1,0),(36,1,5,12),(36,1,6,4),(36,1,7,4),(36,2,0,2),(36,2,1,2),(36,2,22,0),(36,2,23,0),(36,3,17,1),(36,3,18,10),(36,5,0,7),(36,5,13,5),(36,5,15,12),(36,5,18,9),(36,5,20,8),(36,6,13,5),(36,6,23,12),(36,7,4,0),(36,7,19,1),(36,8,6,8),(36,8,11,6),(36,8,23,2),(36,9,0,1),(36,9,1,2),(36,9,10,13),(36,9,11,9),(36,9,12,6),(36,9,13,3),(36,9,21,5),(36,10,0,2),(36,10,1,9),(36,10,2,0),(36,10,11,2),(36,10,12,9),(36,10,13,9),(36,10,17,9),(36,10,19,6),(36,10,20,0),(36,12,1,6),(36,12,9,5),(36,14,0,9),(36,14,23,10),(36,15,3,12),(36,16,0,11),(36,16,4,8),(36,16,5,3),(36,16,11,12),(36,16,23,4),(36,17,1,4),(36,17,4,8),(36,17,5,11),(36,17,6,13),(36,17,7,13),(36,17,12,12),(36,17,19,3),(36,17,21,7),(36,17,22,7),(36,17,23,8),(36,18,2,6),(36,18,3,5),(36,18,10,5),(36,18,15,0),(36,18,19,5),(36,18,20,8),(36,18,23,7),(36,19,0,3),(36,19,10,1),(36,19,20,4),(36,19,22,7),(36,21,0,0),(36,21,1,12),(36,21,4,1),(36,21,5,5),(36,21,9,1),(36,21,14,9),(36,21,21,3),(36,21,22,8),(36,22,7,4),(36,22,10,6),(36,22,11,11),(36,22,16,4),(36,22,18,4),(36,22,19,5),(36,22,22,12),(36,22,23,7),(36,23,1,7),(36,23,2,2),(36,23,7,12),(36,23,9,11),(36,23,15,6),(36,23,17,12),(36,23,19,4),(36,24,3,13),(36,24,8,5),(36,24,12,7),(36,24,19,2),(36,24,22,11),(36,25,2,2),(36,25,9,11),(36,25,10,13),(36,25,23,8),(36,26,3,9),(36,26,5,3),(36,26,6,1),(36,26,7,6),(36,26,10,7),(36,26,11,10),(36,26,13,7),(36,27,5,8),(36,27,7,6),(36,27,16,2),(36,27,17,3),(36,27,23,13),(36,28,3,8),(36,28,4,8),(36,28,10,6),(36,28,13,3),(36,28,17,13),(36,28,18,6),(36,28,19,12),(36,28,21,4),(36,28,22,1),(36,29,1,5),(36,30,3,0),(36,30,22,5),(36,31,21,9),(36,32,3,11),(36,32,16,4),(36,32,20,8),(36,33,6,11),(36,33,16,3),(36,33,20,12),(36,33,21,2),(36,34,6,12),(36,34,17,6),(36,35,5,9),(36,35,17,7),(36,36,2,0),(36,36,18,3),(36,37,4,4),(36,37,16,1),(36,37,18,13),(36,37,20,5),(36,37,21,10),(36,38,2,7),(36,38,8,13),(36,38,16,1),(36,40,6,3),(36,41,0,0),(36,42,22,9),(36,42,23,2),(36,43,3,11),(36,43,6,4),(36,44,0,5),(36,44,3,2),(36,44,21,13),(36,44,23,7),(36,46,0,6),(36,46,3,10),(36,46,4,6),(38,0,4,4),(38,0,5,6),(38,0,6,7),(38,0,8,8),(38,0,11,13),(38,0,14,9),(38,1,6,0),(38,1,14,4),(38,2,3,12),(38,2,4,5),(38,3,2,12),(38,3,26,11),(38,4,5,4),(38,4,9,6),(38,4,14,6),(38,4,19,9),(38,4,26,3),(38,5,0,3),(38,5,4,12),(38,5,15,6),(38,6,0,7),(38,6,3,2),(38,6,4,2),(38,6,7,9),(38,6,14,9),(38,6,17,1),(38,6,19,4),(38,6,23,4),(38,6,24,1),(38,7,15,8),(38,7,26,3),(38,8,0,6),(38,8,8,7),(38,8,15,12),(38,8,18,12),(38,8,27,12),(38,9,9,7),(38,9,17,0),(38,9,23,11),(38,9,27,6),(38,10,7,4),(38,10,14,11),(38,10,15,6),(38,10,16,1),(38,10,18,0),(38,10,21,6),(38,10,28,11),(38,11,0,11),(38,11,20,1),(38,12,0,3),(38,12,7,8),(38,12,13,6),(38,12,25,4),(38,12,26,7),(38,13,1,13),(38,13,3,9),(38,13,9,8),(38,13,10,0),(38,13,13,3),(38,13,21,7),(38,14,6,9),(38,14,11,2),(38,14,24,3),(38,15,0,8),(38,15,2,1),(38,15,3,2),(38,15,7,8),(38,15,11,3),(38,15,12,1),(38,15,13,13),(38,15,21,9),(38,16,2,3),(38,16,13,1),(38,16,21,7),(38,17,12,9),(38,17,20,10),(38,18,8,4),(38,19,1,10),(38,19,2,4),(38,19,14,0),(38,19,19,5),(38,20,2,13),(38,20,5,4),(38,20,15,3),(38,20,19,10),(38,20,22,13),(38,20,23,7),(38,21,1,13),(38,21,3,4),(38,21,4,11),(38,21,7,11),(38,21,11,5),(38,21,14,2),(38,21,18,12),(38,21,19,0),(38,21,20,5),(38,21,21,10),(38,22,6,7),(38,22,12,0),(38,22,25,7),(38,22,26,11),(38,23,5,10),(38,23,7,11),(38,23,9,6),(38,23,11,7),(38,23,13,6),(38,23,23,7),(38,23,24,13),(38,24,11,8),(38,24,13,9),(38,24,29,0),(38,25,4,7),(38,25,15,0),(38,25,17,11),(38,25,28,9),(38,26,3,10),(38,26,4,0),(38,26,8,10),(38,26,18,5),(38,26,26,6),(38,26,29,4),(38,27,3,9),(38,27,10,0),(38,27,13,4),(38,27,14,3),(38,27,15,4),(38,27,26,8),(38,28,15,3),(38,28,18,6),(38,29,1,13),(38,29,14,4),(38,29,17,4),(38,29,23,7),(41,0,4,5),(41,0,6,3),(41,1,0,8),(41,1,11,11),(41,1,17,13),(41,2,12,6),(41,4,0,4),(41,5,1,8),(41,6,14,10),(41,7,12,11),(41,7,17,5),(41,8,10,13),(41,8,18,10),(41,9,0,8),(41,9,9,8),(41,9,14,5),(41,10,19,0),(41,12,9,13),(41,12,14,13),(41,13,1,4),(41,13,19,4),(41,15,1,7),(41,17,3,3),(41,18,8,12),(41,19,1,13),(41,19,9,2),(41,20,1,7),(41,20,2,10),(41,21,1,2),(41,22,1,0),(41,22,2,3),(41,22,16,9),(41,23,0,3),(41,23,4,8),(41,24,11,5),(41,24,19,3),(41,25,10,13),(41,25,11,4),(41,25,15,0),(41,25,19,3),(41,26,2,13),(41,26,9,6),(41,26,11,2),(41,26,15,6),(41,26,16,7),(41,27,0,8),(41,27,2,3),(41,27,9,3),(41,27,18,5),(41,29,1,3),(41,30,1,0),(41,30,3,9),(41,30,4,0),(41,31,1,5),(41,31,2,6),(41,31,3,4),(41,31,4,10),(41,31,5,11),(41,32,0,7),(41,32,1,9),(41,32,2,0),(41,32,12,4),(41,32,13,12),(41,33,0,9),(41,33,12,1),(41,33,18,1),(41,34,7,8),(41,34,9,8),(41,34,13,0),(41,34,19,12);
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
INSERT INTO `fow_ss_entries` VALUES (1,4,1,2,1,0,0,0,NULL,NULL,NULL,NULL,NULL),(2,1,1,1,0,0,0,0,NULL,NULL,NULL,NULL,NULL),(3,3,1,1,0,0,0,0,NULL,NULL,NULL,NULL,NULL),(4,2,1,1,0,0,0,0,NULL,NULL,NULL,NULL,NULL);
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
INSERT INTO `galaxies` VALUES (1,'2010-09-23 10:10:10','dev');
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
  `id` int(11) NOT NULL auto_increment,
  `objective_id` int(11) default NULL,
  `player_id` int(11) default NULL,
  `completed` tinyint(2) unsigned NOT NULL default '0',
  PRIMARY KEY  (`id`),
  KEY `objective_fk` (`objective_id`),
  KEY `player_fk` (`player_id`),
  CONSTRAINT `objective_progresses_ibfk_2` FOREIGN KEY (`player_id`) REFERENCES `players` (`id`) ON DELETE CASCADE,
  CONSTRAINT `objective_progresses_ibfk_1` FOREIGN KEY (`objective_id`) REFERENCES `objectives` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `objective_progresses`
--

LOCK TABLES `objective_progresses` WRITE;
/*!40000 ALTER TABLE `objective_progresses` DISABLE KEYS */;
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
  `count` tinyint(2) unsigned default NULL,
  `level` tinyint(2) unsigned default NULL,
  `alliance` tinyint(1) NOT NULL default '0',
  PRIMARY KEY  (`id`),
  KEY `quest_objectives` (`quest_id`),
  KEY `on_progress` (`type`,`key`),
  CONSTRAINT `objectives_ibfk_1` FOREIGN KEY (`quest_id`) REFERENCES `quests` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `objectives`
--

LOCK TABLES `objectives` WRITE;
/*!40000 ALTER TABLE `objectives` DISABLE KEYS */;
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
) ENGINE=InnoDB AUTO_INCREMENT=43 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `planets`
--

LOCK TABLES `planets` WRITE;
/*!40000 ALTER TABLE `planets` DISABLE KEYS */;
INSERT INTO `planets` VALUES (1,1,NULL,NULL,0,0,0,'Mining',NULL,'G1-S1-P1',28,176,254,305),(2,1,NULL,NULL,1,270,0,'Jumpgate',NULL,'G1-S1-P2',34,NULL,NULL,NULL),(3,1,NULL,NULL,2,30,2,'Mining',NULL,'G1-S1-P3',30,311,240,200),(4,1,53,30,3,314,3,'Regular',NULL,'G1-S1-P4',66,NULL,NULL,NULL),(5,1,NULL,NULL,4,144,3,'Resource',NULL,'G1-S1-P5',33,249,348,364),(6,1,NULL,NULL,5,150,2,'Mining',NULL,'G1-S1-P6',47,285,266,120),(7,1,NULL,NULL,7,235,4,'Mining',NULL,'G1-S1-P7',25,290,135,130),(8,1,NULL,NULL,8,350,0,'Npc',NULL,'G1-S1-P8',47,NULL,NULL,NULL),(9,1,NULL,NULL,9,90,1,'Jumpgate',NULL,'G1-S1-P9',50,NULL,NULL,NULL),(10,1,NULL,NULL,10,40,2,'Jumpgate',NULL,'G1-S1-P10',45,NULL,NULL,NULL),(11,1,NULL,NULL,11,326,5,'Resource',NULL,'G1-S1-P11',55,120,370,357),(12,1,NULL,NULL,13,228,0,'Resource',NULL,'G1-S1-P12',52,127,249,246),(13,1,NULL,NULL,14,294,1,'Jumpgate',NULL,'G1-S1-P13',53,NULL,NULL,NULL),(14,1,NULL,NULL,16,65,0,'Mining',NULL,'G1-S1-P14',51,187,178,145),(15,1,NULL,NULL,17,160,2,'Jumpgate',NULL,'G1-S1-P15',43,NULL,NULL,NULL),(16,2,NULL,NULL,1,90,0,'Mining',NULL,'G1-S2-P16',49,204,229,390),(17,2,NULL,NULL,2,120,1,'Jumpgate',NULL,'G1-S2-P17',53,NULL,NULL,NULL),(18,2,NULL,NULL,3,22,1,'Resource',NULL,'G1-S2-P18',60,111,143,370),(19,2,NULL,NULL,4,90,0,'Jumpgate',NULL,'G1-S2-P19',27,NULL,NULL,NULL),(20,2,44,14,5,300,7,'Regular',NULL,'G1-S2-P20',46,NULL,NULL,NULL),(21,2,46,25,7,336,2,'Regular',NULL,'G1-S2-P21',56,NULL,NULL,NULL),(22,2,40,16,8,170,6,'Regular',NULL,'G1-S2-P22',44,NULL,NULL,NULL),(23,2,54,21,9,288,2,'Regular',NULL,'G1-S2-P23',60,NULL,NULL,NULL),(24,2,NULL,NULL,10,294,5,'Mining',NULL,'G1-S2-P24',27,361,197,369),(25,3,NULL,NULL,0,270,3,'Mining',NULL,'G1-S3-P25',45,210,106,363),(26,3,NULL,NULL,1,90,6,'Mining',NULL,'G1-S3-P26',34,248,374,150),(27,3,51,25,2,0,3,'Regular',NULL,'G1-S3-P27',60,NULL,NULL,NULL),(28,3,NULL,NULL,3,90,0,'Npc',NULL,'G1-S3-P28',46,NULL,NULL,NULL),(29,3,NULL,NULL,4,288,3,'Mining',NULL,'G1-S3-P29',36,239,354,124),(30,3,49,22,5,120,3,'Regular',NULL,'G1-S3-P30',56,NULL,NULL,NULL),(31,3,NULL,NULL,6,306,1,'Jumpgate',NULL,'G1-S3-P31',43,NULL,NULL,NULL),(32,3,NULL,NULL,7,235,1,'Jumpgate',NULL,'G1-S3-P32',56,NULL,NULL,NULL),(33,3,40,21,8,60,4,'Regular',NULL,'G1-S3-P33',48,NULL,NULL,NULL),(34,3,54,24,9,36,4,'Regular',NULL,'G1-S3-P34',62,NULL,NULL,NULL),(35,3,NULL,NULL,10,236,0,'Jumpgate',NULL,'G1-S3-P35',33,NULL,NULL,NULL),(36,4,47,24,0,90,2,'Regular',NULL,'G1-S4-P36',56,NULL,NULL,NULL),(37,4,NULL,NULL,1,315,1,'Mining',NULL,'G1-S4-P37',56,330,193,218),(38,4,30,30,2,330,0,'Homeworld',1,'G1-S4-P38',25,NULL,NULL,NULL),(39,4,NULL,NULL,3,180,2,'Mining',NULL,'G1-S4-P39',37,151,112,145),(40,4,NULL,NULL,4,198,0,'Npc',NULL,'G1-S4-P40',46,NULL,NULL,NULL),(41,4,35,20,5,120,1,'Regular',NULL,'G1-S4-P41',44,NULL,NULL,NULL),(42,4,NULL,NULL,6,48,0,'Jumpgate',NULL,'G1-S4-P42',26,NULL,NULL,NULL);
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `quest_progresses`
--

LOCK TABLES `quest_progresses` WRITE;
/*!40000 ALTER TABLE `quest_progresses` DISABLE KEYS */;
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
  `help_url_id` int(11) default NULL,
  `text` text NOT NULL,
  PRIMARY KEY  (`id`),
  KEY `child quests` (`parent_id`),
  CONSTRAINT `quests_ibfk_1` FOREIGN KEY (`parent_id`) REFERENCES `quests` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `quests`
--

LOCK TABLES `quests` WRITE;
/*!40000 ALTER TABLE `quests` DISABLE KEYS */;
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
) ENGINE=InnoDB AUTO_INCREMENT=43 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `resources_entries`
--

LOCK TABLES `resources_entries` WRITE;
/*!40000 ALTER TABLE `resources_entries` DISABLE KEYS */;
INSERT INTO `resources_entries` VALUES (1,0,0,0,0,0,0,0,0,0,NULL,0),(2,0,0,0,0,0,0,0,0,0,NULL,0),(3,0,0,0,0,0,0,0,0,0,NULL,0),(4,0,0,0,0,0,0,0,0,0,NULL,0),(5,0,0,0,0,0,0,0,0,0,NULL,0),(6,0,0,0,0,0,0,0,0,0,NULL,0),(7,0,0,0,0,0,0,0,0,0,NULL,0),(8,0,0,0,0,0,0,0,0,0,NULL,0),(9,0,0,0,0,0,0,0,0,0,NULL,0),(10,0,0,0,0,0,0,0,0,0,NULL,0),(11,0,0,0,0,0,0,0,0,0,NULL,0),(12,0,0,0,0,0,0,0,0,0,NULL,0),(13,0,0,0,0,0,0,0,0,0,NULL,0),(14,0,0,0,0,0,0,0,0,0,NULL,0),(15,0,0,0,0,0,0,0,0,0,NULL,0),(16,0,0,0,0,0,0,0,0,0,NULL,0),(17,0,0,0,0,0,0,0,0,0,NULL,0),(18,0,0,0,0,0,0,0,0,0,NULL,0),(19,0,0,0,0,0,0,0,0,0,NULL,0),(20,0,0,0,0,0,0,0,0,0,NULL,0),(21,0,0,0,0,0,0,0,0,0,NULL,0),(22,0,0,0,0,0,0,0,0,0,NULL,0),(23,0,0,0,0,0,0,0,0,0,NULL,0),(24,0,0,0,0,0,0,0,0,0,NULL,0),(25,0,0,0,0,0,0,0,0,0,NULL,0),(26,0,0,0,0,0,0,0,0,0,NULL,0),(27,0,0,0,0,0,0,0,0,0,NULL,0),(28,0,0,0,0,0,0,0,0,0,NULL,0),(29,0,0,0,0,0,0,0,0,0,NULL,0),(30,0,0,0,0,0,0,0,0,0,NULL,0),(31,0,0,0,0,0,0,0,0,0,NULL,0),(32,0,0,0,0,0,0,0,0,0,NULL,0),(33,0,0,0,0,0,0,0,0,0,NULL,0),(34,0,0,0,0,0,0,0,0,0,NULL,0),(35,0,0,0,0,0,0,0,0,0,NULL,0),(36,0,0,0,0,0,0,0,0,0,NULL,0),(37,0,0,0,0,0,0,0,0,0,NULL,0),(38,864,3024,1728,6048,0,604.8,50,100,0,'2010-09-23 10:10:13',0),(39,0,0,0,0,0,0,0,0,0,NULL,0),(40,0,0,0,0,0,0,0,0,0,NULL,0),(41,0,0,0,0,0,0,0,0,0,NULL,0),(42,0,0,0,0,0,0,0,0,0,NULL,0);
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
INSERT INTO `schema_migrations` VALUES ('20090601175224'),('20090601184051'),('20090601184055'),('20090601184059'),('20090701164131'),('20090713165021'),('20090808144214'),('20090809160211'),('20090810173759'),('20090826140238'),('20090826141836'),('20090829202538'),('20090829210029'),('20090829224505'),('20090830143959'),('20090830145319'),('20090901153809'),('20090904190655'),('20090905175341'),('20090905192056'),('20090906135044'),('20090909222719'),('20090911180950'),('20090912165229'),('20090919155819'),('20091024222359'),('20091103164416'),('20091103180558'),('20091103181146'),('20091109191211'),('20091225193714'),('20100114152902'),('20100121142414'),('20100127115341'),('20100127120219'),('20100127120515'),('20100127121337'),('20100129150736'),('20100203202757'),('20100203204803'),('20100204172507'),('20100204173714'),('20100208163239'),('20100210114531'),('20100212134334'),('20100218181507'),('20100219114448'),('20100220144106'),('20100222144003'),('20100223153023'),('20100224153728'),('20100224163525'),('20100225124928'),('20100225153721'),('20100225155505'),('20100225155739'),('20100226122144'),('20100226122651'),('20100301153626'),('20100302131225'),('20100303131706'),('20100308163148'),('20100308164422'),('20100310172315'),('20100310181338'),('20100311123523'),('20100315112858'),('20100319141401'),('20100322184529'),('20100324134243'),('20100324141652'),('20100331125702'),('20100415130556'),('20100415130600'),('20100415130605'),('20100415134627'),('20100419141518'),('20100419142018'),('20100419164230'),('20100426141509'),('20100428130912'),('20100429171200'),('20100430174140'),('20100610151652'),('20100610180750'),('20100614142225'),('20100614160819'),('20100614162423'),('20100616132525'),('20100616135507'),('20100622124252'),('20100706105523'),('20100710121447'),('20100710191351'),('20100716155807'),('20100719131622'),('20100721155359'),('20100722124307'),('20100812164444'),('20100812164449'),('20100812164518'),('20100812164524'),('20100817165213'),('20100819175736'),('20100820185846'),('20100906095758'),('20100915145823'),('99999999999900');
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
INSERT INTO `solar_systems` VALUES (1,'Resource',1,0,-2),(2,'Expansion',1,3,-2),(3,'Expansion',1,0,-1),(4,'Homeworld',1,0,0);
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
) ENGINE=InnoDB AUTO_INCREMENT=3982 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tiles`
--

LOCK TABLES `tiles` WRITE;
/*!40000 ALTER TABLE `tiles` DISABLE KEYS */;
INSERT INTO `tiles` VALUES (1,3,4,5,0),(2,3,4,6,0),(3,3,4,7,0),(4,3,4,8,0),(5,3,4,9,0),(6,3,4,10,0),(7,3,4,11,0),(8,3,4,14,0),(9,3,4,15,0),(10,3,4,16,0),(11,3,4,17,0),(12,3,4,18,0),(13,3,4,19,0),(14,5,4,25,0),(15,4,4,35,0),(16,4,4,36,0),(17,4,4,37,0),(18,4,4,38,0),(19,14,4,39,0),(20,3,4,42,0),(21,3,4,43,0),(22,3,4,44,0),(23,3,4,45,0),(24,4,4,46,0),(25,4,4,47,0),(26,4,4,48,0),(27,4,4,49,0),(28,4,4,50,0),(29,3,4,7,1),(30,3,4,9,1),(31,3,4,10,1),(32,0,4,11,1),(33,3,4,14,1),(34,3,4,15,1),(35,3,4,17,1),(36,3,4,18,1),(37,3,4,19,1),(38,3,4,20,1),(39,5,4,25,1),(40,4,4,33,1),(41,4,4,34,1),(42,4,4,35,1),(43,4,4,36,1),(44,4,4,37,1),(45,4,4,38,1),(46,3,4,42,1),(47,3,4,43,1),(48,3,4,44,1),(49,3,4,45,1),(50,3,4,46,1),(51,4,4,47,1),(52,4,4,48,1),(53,4,4,49,1),(54,4,4,50,1),(55,4,4,51,1),(56,4,4,52,1),(57,3,4,4,2),(58,3,4,5,2),(59,3,4,6,2),(60,3,4,7,2),(61,3,4,8,2),(62,3,4,9,2),(63,3,4,10,2),(64,3,4,13,2),(65,3,4,14,2),(66,3,4,15,2),(67,3,4,17,2),(68,3,4,20,2),(69,5,4,23,2),(70,5,4,24,2),(71,5,4,25,2),(72,4,4,33,2),(73,4,4,34,2),(74,0,4,35,2),(75,4,4,37,2),(76,3,4,42,2),(77,3,4,43,2),(78,3,4,44,2),(79,3,4,45,2),(80,3,4,46,2),(81,3,4,47,2),(82,4,4,48,2),(83,4,4,49,2),(84,4,4,50,2),(85,7,4,51,2),(86,4,4,52,2),(87,3,4,5,3),(88,3,4,6,3),(89,3,4,7,3),(90,3,4,8,3),(91,3,4,9,3),(92,3,4,10,3),(93,3,4,11,3),(94,3,4,12,3),(95,3,4,15,3),(96,3,4,16,3),(97,3,4,17,3),(98,3,4,18,3),(99,3,4,19,3),(100,3,4,20,3),(101,3,4,21,3),(102,3,4,22,3),(103,3,4,23,3),(104,5,4,24,3),(105,4,4,33,3),(106,4,4,34,3),(107,4,4,37,3),(108,4,4,38,3),(109,3,4,42,3),(110,3,4,43,3),(111,3,4,44,3),(112,3,4,45,3),(113,3,4,46,3),(114,3,4,47,3),(115,4,4,49,3),(116,4,4,50,3),(117,4,4,51,3),(118,4,4,52,3),(119,3,4,5,4),(120,3,4,6,4),(121,3,4,7,4),(122,3,4,8,4),(123,3,4,9,4),(124,3,4,10,4),(125,3,4,11,4),(126,3,4,12,4),(127,3,4,16,4),(128,3,4,17,4),(129,3,4,18,4),(130,3,4,19,4),(131,3,4,20,4),(132,3,4,21,4),(133,3,4,22,4),(134,5,4,24,4),(135,5,4,27,4),(136,4,4,33,4),(137,4,4,34,4),(138,4,4,35,4),(139,4,4,36,4),(140,4,4,37,4),(141,4,4,39,4),(142,3,4,41,4),(143,3,4,42,4),(144,3,4,43,4),(145,3,4,44,4),(146,3,4,45,4),(147,3,4,46,4),(148,3,4,47,4),(149,3,4,48,4),(150,4,4,49,4),(151,4,4,50,4),(152,4,4,51,4),(153,4,4,52,4),(154,3,4,5,5),(155,3,4,6,5),(156,3,4,7,5),(157,3,4,8,5),(158,3,4,9,5),(159,3,4,10,5),(160,3,4,11,5),(161,3,4,12,5),(162,3,4,15,5),(163,3,4,16,5),(164,3,4,19,5),(165,3,4,22,5),(166,5,4,23,5),(167,5,4,24,5),(168,5,4,25,5),(169,5,4,26,5),(170,5,4,27,5),(171,4,4,33,5),(172,4,4,34,5),(173,4,4,35,5),(174,4,4,36,5),(175,4,4,37,5),(176,4,4,38,5),(177,4,4,39,5),(178,3,4,43,5),(179,3,4,44,5),(180,3,4,47,5),(181,4,4,48,5),(182,4,4,49,5),(183,4,4,50,5),(184,4,4,51,5),(185,4,4,52,5),(186,0,4,7,6),(187,3,4,9,6),(188,3,4,10,6),(189,3,4,11,6),(190,3,4,12,6),(191,12,4,19,6),(192,5,4,25,6),(193,5,4,26,6),(194,5,4,27,6),(195,4,4,35,6),(196,4,4,36,6),(197,4,4,39,6),(198,3,4,42,6),(199,3,4,43,6),(200,3,4,44,6),(201,3,4,45,6),(202,3,4,47,6),(203,4,4,49,6),(204,4,4,50,6),(205,4,4,51,6),(206,4,4,52,6),(207,3,4,11,7),(208,3,4,12,7),(209,3,4,13,7),(210,3,4,14,7),(211,4,4,51,7),(212,3,4,8,8),(213,3,4,10,8),(214,3,4,11,8),(215,3,4,12,8),(216,3,4,13,8),(217,3,4,14,8),(218,4,4,18,8),(219,3,4,7,9),(220,3,4,8,9),(221,3,4,9,9),(222,3,4,10,9),(223,3,4,11,9),(224,3,4,12,9),(225,3,4,13,9),(226,3,4,14,9),(227,3,4,15,9),(228,4,4,16,9),(229,4,4,18,9),(230,6,4,26,9),(231,6,4,27,9),(232,6,4,29,9),(233,3,4,10,10),(234,3,4,12,10),(235,3,4,13,10),(236,3,4,14,10),(237,4,4,15,10),(238,4,4,16,10),(239,4,4,18,10),(240,6,4,27,10),(241,6,4,28,10),(242,6,4,29,10),(243,6,4,30,10),(244,8,4,38,10),(245,7,4,8,11),(246,0,4,10,11),(247,3,4,12,11),(248,3,4,13,11),(249,3,4,14,11),(250,4,4,15,11),(251,4,4,16,11),(252,4,4,17,11),(253,4,4,18,11),(254,6,4,28,11),(255,6,4,30,11),(256,6,4,31,11),(257,7,4,8,12),(258,4,4,12,12),(259,4,4,13,12),(260,4,4,14,12),(261,4,4,15,12),(262,4,4,16,12),(263,4,4,17,12),(264,4,4,18,12),(265,0,4,19,12),(266,6,4,29,12),(267,6,4,30,12),(268,6,4,31,12),(269,7,4,4,13),(270,7,4,5,13),(271,7,4,6,13),(272,7,4,7,13),(273,7,4,8,13),(274,7,4,9,13),(275,7,4,10,13),(276,7,4,11,13),(277,4,4,12,13),(278,4,4,13,13),(279,4,4,14,13),(280,4,4,15,13),(281,4,4,16,13),(282,4,4,18,13),(283,6,4,28,13),(284,6,4,29,13),(285,6,4,30,13),(286,8,4,36,13),(287,6,4,47,13),(288,7,4,4,14),(289,7,4,7,14),(290,7,4,8,14),(291,7,4,9,14),(292,7,4,10,14),(293,7,4,11,14),(294,7,4,12,14),(295,4,4,13,14),(296,4,4,14,14),(297,4,4,16,14),(298,4,4,17,14),(299,6,4,19,14),(300,6,4,22,14),(301,6,4,47,14),(302,6,4,48,14),(303,5,4,2,15),(304,5,4,3,15),(305,7,4,8,15),(306,7,4,9,15),(307,7,4,10,15),(308,7,4,11,15),(309,7,4,12,15),(310,7,4,13,15),(311,4,4,14,15),(312,4,4,15,15),(313,4,4,16,15),(314,4,4,17,15),(315,6,4,18,15),(316,6,4,19,15),(317,6,4,20,15),(318,6,4,21,15),(319,6,4,22,15),(320,6,4,44,15),(321,6,4,46,15),(322,6,4,47,15),(323,6,4,48,15),(324,6,4,49,15),(325,5,4,1,16),(326,5,4,2,16),(327,5,4,3,16),(328,7,4,8,16),(329,7,4,9,16),(330,7,4,11,16),(331,7,4,12,16),(332,7,4,13,16),(333,7,4,14,16),(334,4,4,17,16),(335,4,4,18,16),(336,6,4,19,16),(337,6,4,20,16),(338,6,4,21,16),(339,6,4,22,16),(340,6,4,23,16),(341,6,4,44,16),(342,6,4,45,16),(343,6,4,46,16),(344,6,4,47,16),(345,5,4,1,17),(346,5,4,2,17),(347,5,4,3,17),(348,5,4,4,17),(349,7,4,7,17),(350,7,4,8,17),(351,7,4,9,17),(352,7,4,10,17),(353,7,4,11,17),(354,7,4,12,17),(355,7,4,13,17),(356,7,4,14,17),(357,6,4,18,17),(358,6,4,19,17),(359,6,4,20,17),(360,6,4,21,17),(361,12,4,28,17),(362,6,4,45,17),(363,6,4,46,17),(364,6,4,47,17),(365,0,4,48,17),(366,5,4,2,18),(367,5,4,4,18),(368,7,4,8,18),(369,7,4,9,18),(370,7,4,10,18),(371,7,4,11,18),(372,7,4,12,18),(373,7,4,13,18),(374,7,4,14,18),(375,13,4,16,18),(376,0,4,23,18),(377,6,4,47,18),(378,5,4,3,19),(379,5,4,4,19),(380,5,4,5,19),(381,7,4,9,19),(382,7,4,11,19),(383,7,4,12,19),(384,7,4,13,19),(385,7,4,14,19),(386,11,4,46,19),(387,0,4,1,20),(388,5,4,3,20),(389,5,4,5,20),(390,5,4,6,20),(391,7,4,12,20),(392,7,4,13,20),(393,7,4,14,20),(394,7,4,15,20),(395,9,4,24,20),(396,4,4,35,20),(397,4,4,36,20),(398,4,4,37,20),(399,7,4,11,21),(400,7,4,12,21),(401,4,4,34,21),(402,4,4,35,21),(403,4,4,36,21),(404,4,4,37,21),(405,10,4,3,22),(406,1,4,9,22),(407,7,4,11,22),(408,7,4,12,22),(409,4,4,34,22),(410,4,4,35,22),(411,4,4,36,22),(412,4,4,37,22),(413,4,4,38,22),(414,4,4,39,22),(415,4,4,40,22),(416,7,4,11,23),(417,6,4,13,23),(418,11,4,30,23),(419,4,4,34,23),(420,4,4,35,23),(421,4,4,36,23),(422,4,4,37,23),(423,4,4,39,23),(424,4,4,40,23),(425,6,4,11,24),(426,6,4,12,24),(427,6,4,13,24),(428,6,4,14,24),(429,4,4,34,24),(430,4,4,35,24),(431,4,4,36,24),(432,4,4,37,24),(433,4,4,38,24),(434,4,4,39,24),(435,10,4,42,24),(436,6,4,11,25),(437,6,4,12,25),(438,6,4,13,25),(439,6,4,14,25),(440,6,4,15,25),(441,6,4,16,25),(442,6,4,17,25),(443,4,4,35,25),(444,4,4,36,25),(445,4,4,37,25),(446,4,4,38,25),(447,5,4,47,25),(448,6,4,12,26),(449,6,4,14,26),(450,6,4,15,26),(451,6,4,16,26),(452,6,4,17,26),(453,6,4,18,26),(454,6,4,19,26),(455,6,4,20,26),(456,4,4,35,26),(457,4,4,37,26),(458,4,4,38,26),(459,5,4,47,26),(460,2,4,14,27),(461,6,4,16,27),(462,6,4,17,27),(463,6,4,18,27),(464,6,4,19,27),(465,6,4,20,27),(466,5,4,46,27),(467,5,4,47,27),(468,5,4,48,27),(469,6,4,16,28),(470,6,4,19,28),(471,5,4,42,28),(472,5,4,43,28),(473,5,4,44,28),(474,5,4,45,28),(475,5,4,46,28),(476,5,4,47,28),(477,6,4,16,29),(478,6,4,19,29),(479,5,4,42,29),(480,5,4,43,29),(481,5,4,44,29),(482,5,4,45,29),(483,5,4,46,29),(484,5,4,47,29),(485,1,20,0,0),(486,4,20,2,0),(487,4,20,3,0),(488,3,20,25,0),(489,3,20,26,0),(490,3,20,27,0),(491,3,20,28,0),(492,4,20,31,0),(493,4,20,32,0),(494,4,20,33,0),(495,0,20,34,0),(496,3,20,37,0),(497,3,20,38,0),(498,3,20,39,0),(499,3,20,40,0),(500,4,20,2,1),(501,12,20,14,1),(502,3,20,24,1),(503,3,20,25,1),(504,3,20,26,1),(505,3,20,27,1),(506,7,20,29,1),(507,4,20,30,1),(508,4,20,31,1),(509,0,20,32,1),(510,3,20,36,1),(511,3,20,37,1),(512,3,20,38,1),(513,3,20,39,1),(514,3,20,40,1),(515,1,20,41,1),(516,4,20,2,2),(517,6,20,3,2),(518,8,20,11,2),(519,4,20,22,2),(520,4,20,23,2),(521,4,20,24,2),(522,7,20,25,2),(523,3,20,26,2),(524,7,20,29,2),(525,4,20,1,3),(526,4,20,2,3),(527,6,20,3,3),(528,6,20,4,3),(529,4,20,10,3),(530,6,20,22,3),(531,4,20,23,3),(532,4,20,24,3),(533,7,20,25,3),(534,7,20,27,3),(535,7,20,28,3),(536,7,20,29,3),(537,7,20,30,3),(538,2,20,31,3),(539,5,20,42,3),(540,5,20,43,3),(541,6,20,4,4),(542,4,20,10,4),(543,6,20,22,4),(544,4,20,24,4),(545,7,20,25,4),(546,7,20,26,4),(547,7,20,27,4),(548,7,20,28,4),(549,7,20,29,4),(550,5,20,35,4),(551,5,20,39,4),(552,5,20,40,4),(553,5,20,42,4),(554,5,20,43,4),(555,14,20,1,5),(556,10,20,4,5),(557,4,20,9,5),(558,4,20,10,5),(559,4,20,11,5),(560,4,20,12,5),(561,3,20,23,5),(562,7,20,24,5),(563,7,20,25,5),(564,7,20,26,5),(565,7,20,27,5),(566,7,20,28,5),(567,7,20,29,5),(568,5,20,30,5),(569,5,20,34,5),(570,5,20,35,5),(571,5,20,36,5),(572,5,20,40,5),(573,5,20,41,5),(574,5,20,42,5),(575,5,20,43,5),(576,9,20,10,6),(577,6,20,21,6),(578,3,20,23,6),(579,7,20,24,6),(580,7,20,25,6),(581,7,20,26,6),(582,0,20,27,6),(583,5,20,29,6),(584,5,20,30,6),(585,2,20,31,6),(586,5,20,35,6),(587,5,20,39,6),(588,5,20,40,6),(589,11,20,17,7),(590,6,20,21,7),(591,3,20,22,7),(592,3,20,23,7),(593,3,20,24,7),(594,3,20,25,7),(595,7,20,26,7),(596,5,20,29,7),(597,5,20,30,7),(598,5,20,35,7),(599,5,20,36,7),(600,11,20,39,7),(601,3,20,0,8),(602,6,20,21,8),(603,3,20,23,8),(604,3,20,24,8),(605,3,20,25,8),(606,5,20,30,8),(607,5,20,31,8),(608,5,20,36,8),(609,3,20,0,9),(610,3,20,1,9),(611,14,20,2,9),(612,13,20,5,9),(613,6,20,21,9),(614,6,20,22,9),(615,3,20,27,9),(616,5,20,30,9),(617,5,20,36,9),(618,3,20,0,10),(619,3,20,1,10),(620,3,20,26,10),(621,3,20,27,10),(622,5,20,28,10),(623,5,20,29,10),(624,5,20,30,10),(625,0,20,31,10),(626,3,20,0,11),(627,3,20,1,11),(628,4,20,8,11),(629,4,20,9,11),(630,5,20,21,11),(631,5,20,22,11),(632,5,20,23,11),(633,5,20,24,11),(634,5,20,25,11),(635,3,20,26,11),(636,3,20,27,11),(637,3,20,28,11),(638,5,20,29,11),(639,5,20,30,11),(640,0,20,33,11),(641,3,20,1,12),(642,4,20,7,12),(643,4,20,8,12),(644,4,20,9,12),(645,4,20,10,12),(646,5,20,22,12),(647,5,20,23,12),(648,5,20,24,12),(649,3,20,25,12),(650,3,20,26,12),(651,3,20,27,12),(652,5,20,28,12),(653,5,20,29,12),(654,5,20,30,12),(655,5,20,31,12),(656,5,20,32,12),(657,5,20,22,13),(658,5,20,23,13),(659,5,20,24,13),(660,5,20,25,13),(661,6,20,26,13),(662,6,20,27,13),(663,6,20,28,13),(664,5,20,29,13),(665,5,20,30,13),(666,5,20,31,13),(667,5,20,32,13),(668,5,20,33,13),(669,5,20,34,13),(670,4,21,6,0),(671,4,21,7,0),(672,8,21,12,0),(673,5,21,18,0),(674,4,21,22,0),(675,4,21,23,0),(676,4,21,24,0),(677,4,21,25,0),(678,7,21,28,0),(679,7,21,29,0),(680,7,21,30,0),(681,7,21,31,0),(682,7,21,32,0),(683,7,21,33,0),(684,7,21,34,0),(685,7,21,35,0),(686,7,21,36,0),(687,7,21,37,0),(688,7,21,38,0),(689,7,21,39,0),(690,4,21,6,1),(691,4,21,7,1),(692,5,21,18,1),(693,5,21,19,1),(694,5,21,20,1),(695,4,21,21,1),(696,4,21,22,1),(697,4,21,23,1),(698,4,21,24,1),(699,4,21,25,1),(700,4,21,26,1),(701,7,21,29,1),(702,7,21,32,1),(703,7,21,33,1),(704,7,21,34,1),(705,7,21,35,1),(706,7,21,36,1),(707,7,21,38,1),(708,7,21,39,1),(709,4,21,3,2),(710,4,21,4,2),(711,4,21,5,2),(712,4,21,6,2),(713,4,21,7,2),(714,4,21,8,2),(715,5,21,18,2),(716,5,21,19,2),(717,5,21,20,2),(718,5,21,21,2),(719,4,21,22,2),(720,4,21,23,2),(721,4,21,24,2),(722,4,21,25,2),(723,7,21,31,2),(724,7,21,32,2),(725,7,21,33,2),(726,7,21,34,2),(727,7,21,35,2),(728,7,21,36,2),(729,7,21,37,2),(730,7,21,39,2),(731,7,21,40,2),(732,2,21,41,2),(733,14,21,2,3),(734,4,21,5,3),(735,4,21,6,3),(736,4,21,7,3),(737,5,21,17,3),(738,5,21,18,3),(739,2,21,19,3),(740,4,21,21,3),(741,4,21,22,3),(742,4,21,23,3),(743,4,21,25,3),(744,0,21,29,3),(745,7,21,31,3),(746,7,21,32,3),(747,7,21,33,3),(748,7,21,34,3),(749,7,21,35,3),(750,7,21,36,3),(751,7,21,37,3),(752,7,21,38,3),(753,4,21,5,4),(754,4,21,6,4),(755,4,21,7,4),(756,4,21,8,4),(757,4,21,9,4),(758,4,21,22,4),(759,4,21,25,4),(760,4,21,26,4),(761,7,21,33,4),(762,7,21,34,4),(763,7,21,35,4),(764,7,21,36,4),(765,7,21,37,4),(766,7,21,38,4),(767,7,21,39,4),(768,4,21,5,5),(769,4,21,6,5),(770,4,21,7,5),(771,4,21,8,5),(772,4,21,9,5),(773,4,21,10,5),(774,9,21,18,5),(775,4,21,22,5),(776,4,21,23,5),(777,4,21,24,5),(778,4,21,31,5),(779,7,21,33,5),(780,7,21,34,5),(781,7,21,35,5),(782,7,21,36,5),(783,7,21,37,5),(784,7,21,38,5),(785,1,21,43,5),(786,4,21,6,6),(787,4,21,7,6),(788,4,21,9,6),(789,4,21,10,6),(790,4,21,11,6),(791,4,21,12,6),(792,4,21,31,6),(793,4,21,32,6),(794,4,21,33,6),(795,7,21,34,6),(796,7,21,35,6),(797,7,21,36,6),(798,7,21,38,6),(799,7,21,39,6),(800,4,21,5,7),(801,4,21,6,7),(802,4,21,7,7),(803,4,21,9,7),(804,4,21,10,7),(805,4,21,11,7),(806,4,21,12,7),(807,4,21,13,7),(808,4,21,14,7),(809,8,21,24,7),(810,4,21,31,7),(811,4,21,32,7),(812,7,21,34,7),(813,4,21,35,7),(814,4,21,36,7),(815,6,21,5,8),(816,4,21,7,8),(817,4,21,8,8),(818,4,21,9,8),(819,4,21,10,8),(820,4,21,11,8),(821,3,21,31,8),(822,4,21,32,8),(823,4,21,33,8),(824,7,21,34,8),(825,4,21,35,8),(826,6,21,5,9),(827,4,21,9,9),(828,4,21,10,9),(829,10,21,20,9),(830,3,21,30,9),(831,3,21,31,9),(832,4,21,33,9),(833,4,21,34,9),(834,4,21,35,9),(835,14,21,39,9),(836,6,21,3,10),(837,6,21,4,10),(838,6,21,5,10),(839,11,21,7,10),(840,0,21,13,10),(841,3,21,30,10),(842,3,21,31,10),(843,4,21,32,10),(844,4,21,33,10),(845,4,21,34,10),(846,4,21,35,10),(847,4,21,36,10),(848,4,21,37,10),(849,5,21,0,11),(850,5,21,1,11),(851,6,21,2,11),(852,6,21,3,11),(853,6,21,4,11),(854,6,21,5,11),(855,3,21,29,11),(856,3,21,30,11),(857,3,21,31,11),(858,4,21,32,11),(859,4,21,33,11),(860,4,21,34,11),(861,4,21,36,11),(862,5,21,0,12),(863,5,21,1,12),(864,5,21,2,12),(865,5,21,3,12),(866,6,21,4,12),(867,6,21,5,12),(868,3,21,28,12),(869,3,21,29,12),(870,3,21,30,12),(871,3,21,31,12),(872,3,21,32,12),(873,3,21,33,12),(874,5,21,0,13),(875,5,21,1,13),(876,5,21,2,13),(877,6,21,4,13),(878,5,21,19,13),(879,5,21,20,13),(880,5,21,21,13),(881,3,21,24,13),(882,3,21,25,13),(883,3,21,26,13),(884,3,21,28,13),(885,3,21,31,13),(886,3,21,33,13),(887,5,21,2,14),(888,6,21,4,14),(889,6,21,5,14),(890,3,21,11,14),(891,3,21,12,14),(892,0,21,13,14),(893,5,21,20,14),(894,5,21,21,14),(895,3,21,22,14),(896,3,21,23,14),(897,3,21,24,14),(898,3,21,25,14),(899,3,21,26,14),(900,4,21,27,14),(901,4,21,28,14),(902,4,21,30,14),(903,4,21,31,14),(904,9,21,41,14),(905,6,21,1,15),(906,6,21,2,15),(907,6,21,3,15),(908,6,21,4,15),(909,6,21,5,15),(910,6,21,6,15),(911,3,21,11,15),(912,3,21,12,15),(913,5,21,19,15),(914,5,21,20,15),(915,5,21,21,15),(916,5,21,22,15),(917,3,21,23,15),(918,3,21,24,15),(919,3,21,25,15),(920,3,21,26,15),(921,4,21,27,15),(922,4,21,28,15),(923,4,21,29,15),(924,4,21,30,15),(925,4,21,31,15),(926,4,21,32,15),(927,3,21,35,15),(928,3,21,36,15),(929,3,21,37,15),(930,3,21,38,15),(931,0,21,0,16),(932,6,21,2,16),(933,6,21,3,16),(934,6,21,4,16),(935,6,21,5,16),(936,3,21,9,16),(937,3,21,10,16),(938,3,21,11,16),(939,3,21,12,16),(940,3,21,13,16),(941,3,21,14,16),(942,3,21,15,16),(943,5,21,20,16),(944,5,21,21,16),(945,3,21,23,16),(946,3,21,24,16),(947,3,21,25,16),(948,3,21,26,16),(949,4,21,27,16),(950,4,21,28,16),(951,4,21,29,16),(952,4,21,30,16),(953,3,21,34,16),(954,3,21,35,16),(955,3,21,36,16),(956,3,21,37,16),(957,3,21,38,16),(958,11,21,3,17),(959,3,21,9,17),(960,3,21,10,17),(961,3,21,11,17),(962,3,21,12,17),(963,3,21,13,17),(964,3,21,14,17),(965,5,21,20,17),(966,5,21,21,17),(967,5,21,22,17),(968,3,21,23,17),(969,3,21,25,17),(970,3,21,26,17),(971,4,21,27,17),(972,4,21,28,17),(973,4,21,29,17),(974,4,21,30,17),(975,3,21,33,17),(976,3,21,34,17),(977,3,21,35,17),(978,3,21,36,17),(979,3,21,37,17),(980,3,21,12,18),(981,3,21,13,18),(982,12,21,14,18),(983,5,21,21,18),(984,5,21,22,18),(985,6,21,25,18),(986,3,21,26,18),(987,4,21,27,18),(988,4,21,28,18),(989,4,21,29,18),(990,4,21,30,18),(991,4,21,31,18),(992,3,21,35,18),(993,3,21,36,18),(994,3,21,37,18),(995,3,21,12,19),(996,3,21,22,19),(997,6,21,25,19),(998,4,21,28,19),(999,3,21,34,19),(1000,3,21,35,19),(1001,3,21,37,19),(1002,3,21,20,20),(1003,3,21,21,20),(1004,3,21,22,20),(1005,6,21,25,20),(1006,6,21,26,20),(1007,6,21,27,20),(1008,0,21,34,20),(1009,3,21,20,21),(1010,3,21,21,21),(1011,3,21,22,21),(1012,3,21,23,21),(1013,3,21,24,21),(1014,6,21,25,21),(1015,6,21,26,21),(1016,6,21,27,21),(1017,6,21,28,21),(1018,5,21,36,21),(1019,5,21,37,21),(1020,13,21,8,22),(1021,3,21,21,22),(1022,6,21,25,22),(1023,6,21,26,22),(1024,6,21,27,22),(1025,5,21,36,22),(1026,5,21,37,22),(1027,1,21,38,22),(1028,3,21,20,23),(1029,3,21,21,23),(1030,5,21,34,23),(1031,5,21,35,23),(1032,5,21,36,23),(1033,3,21,15,24),(1034,3,21,16,24),(1035,3,21,17,24),(1036,3,21,18,24),(1037,3,21,19,24),(1038,3,21,20,24),(1039,3,21,21,24),(1040,3,21,22,24),(1041,5,21,35,24),(1042,5,21,36,24),(1043,5,21,37,24),(1044,6,22,1,0),(1045,3,22,3,0),(1046,3,22,4,0),(1047,6,22,5,0),(1048,6,22,6,0),(1049,5,22,7,0),(1050,5,22,8,0),(1051,5,22,9,0),(1052,5,22,10,0),(1053,0,22,15,0),(1054,3,22,25,0),(1055,3,22,26,0),(1056,6,22,30,0),(1057,6,22,31,0),(1058,6,22,32,0),(1059,6,22,33,0),(1060,6,22,1,1),(1061,6,22,4,1),(1062,6,22,5,1),(1063,6,22,6,1),(1064,6,22,7,1),(1065,5,22,8,1),(1066,3,22,25,1),(1067,3,22,26,1),(1068,3,22,27,1),(1069,10,22,28,1),(1070,6,22,0,2),(1071,6,22,1,2),(1072,12,22,2,2),(1073,3,22,26,2),(1074,3,22,33,2),(1075,6,22,1,3),(1076,5,22,14,3),(1077,2,22,24,3),(1078,0,22,26,3),(1079,3,22,33,3),(1080,3,22,34,3),(1081,6,22,1,4),(1082,5,22,14,4),(1083,3,22,34,4),(1084,3,22,35,4),(1085,3,22,36,4),(1086,3,22,1,5),(1087,5,22,12,5),(1088,5,22,13,5),(1089,5,22,14,5),(1090,5,22,15,5),(1091,7,22,16,5),(1092,0,22,21,5),(1093,3,22,23,5),(1094,3,22,24,5),(1095,3,22,25,5),(1096,10,22,26,5),(1097,9,22,35,5),(1098,3,22,0,6),(1099,3,22,1,6),(1100,5,22,14,6),(1101,5,22,15,6),(1102,7,22,16,6),(1103,7,22,17,6),(1104,3,22,24,6),(1105,3,22,25,6),(1106,5,22,32,6),(1107,1,22,33,6),(1108,3,22,0,7),(1109,3,22,1,7),(1110,5,22,15,7),(1111,7,22,16,7),(1112,7,22,17,7),(1113,7,22,18,7),(1114,6,22,21,7),(1115,6,22,22,7),(1116,6,22,23,7),(1117,3,22,24,7),(1118,5,22,31,7),(1119,5,22,32,7),(1120,3,22,0,8),(1121,5,22,1,8),(1122,5,22,2,8),(1123,14,22,4,8),(1124,8,22,8,8),(1125,0,22,11,8),(1126,13,22,13,8),(1127,6,22,20,8),(1128,6,22,21,8),(1129,6,22,22,8),(1130,5,22,30,8),(1131,5,22,31,8),(1132,5,22,32,8),(1133,5,22,33,8),(1134,4,22,34,8),(1135,4,22,35,8),(1136,4,22,36,8),(1137,4,22,37,8),(1138,4,22,38,8),(1139,5,22,0,9),(1140,5,22,1,9),(1141,0,22,2,9),(1142,11,22,19,9),(1143,12,22,23,9),(1144,5,22,30,9),(1145,5,22,31,9),(1146,4,22,33,9),(1147,4,22,34,9),(1148,4,22,36,9),(1149,4,22,37,9),(1150,4,22,38,9),(1151,4,22,39,9),(1152,5,22,0,10),(1153,5,22,1,10),(1154,4,22,11,10),(1155,4,22,12,10),(1156,4,22,13,10),(1157,4,22,14,10),(1158,4,22,15,10),(1159,4,22,33,10),(1160,4,22,34,10),(1161,4,22,35,10),(1162,4,22,36,10),(1163,4,22,37,10),(1164,4,22,38,10),(1165,5,22,0,11),(1166,5,22,1,11),(1167,0,22,2,11),(1168,4,22,12,11),(1169,4,22,13,11),(1170,4,22,14,11),(1171,4,22,15,11),(1172,14,22,16,11),(1173,4,22,31,11),(1174,4,22,32,11),(1175,4,22,33,11),(1176,4,22,34,11),(1177,4,22,35,11),(1178,4,22,36,11),(1179,4,22,37,11),(1180,5,22,0,12),(1181,8,22,10,12),(1182,4,22,13,12),(1183,4,22,14,12),(1184,4,22,15,12),(1185,4,22,31,12),(1186,4,22,33,12),(1187,9,22,35,12),(1188,0,22,13,13),(1189,4,22,15,13),(1190,2,22,29,13),(1191,4,22,31,13),(1192,4,22,33,13),(1193,4,22,34,13),(1194,7,22,1,14),(1195,7,22,2,14),(1196,4,22,31,14),(1197,4,22,32,14),(1198,4,22,33,14),(1199,4,22,34,14),(1200,7,22,0,15),(1201,7,22,1,15),(1202,7,22,2,15),(1203,7,22,3,15),(1204,7,22,4,15),(1205,5,22,24,15),(1206,5,22,25,15),(1207,5,22,26,15),(1208,5,22,27,15),(1209,5,22,28,15),(1210,5,22,29,15),(1211,5,22,30,15),(1212,5,22,31,15),(1213,5,22,32,15),(1214,4,22,33,15),(1215,4,22,34,15),(1216,4,22,35,15),(1217,4,22,36,15),(1218,4,22,37,15),(1219,4,22,38,15),(1220,12,23,1,0),(1221,4,23,19,0),(1222,4,23,20,0),(1223,4,23,21,0),(1224,4,23,22,0),(1225,7,23,23,0),(1226,7,23,24,0),(1227,7,23,25,0),(1228,7,23,27,0),(1229,4,23,40,0),(1230,4,23,41,0),(1231,3,23,42,0),(1232,3,23,43,0),(1233,3,23,44,0),(1234,3,23,45,0),(1235,3,23,46,0),(1236,3,23,49,0),(1237,3,23,50,0),(1238,3,23,51,0),(1239,0,23,8,1),(1240,1,23,16,1),(1241,4,23,19,1),(1242,4,23,20,1),(1243,4,23,21,1),(1244,4,23,22,1),(1245,7,23,23,1),(1246,7,23,25,1),(1247,7,23,26,1),(1248,7,23,27,1),(1249,7,23,28,1),(1250,4,23,39,1),(1251,4,23,40,1),(1252,3,23,42,1),(1253,3,23,43,1),(1254,3,23,44,1),(1255,3,23,45,1),(1256,3,23,46,1),(1257,3,23,47,1),(1258,3,23,48,1),(1259,3,23,49,1),(1260,3,23,50,1),(1261,5,23,51,1),(1262,4,23,18,2),(1263,4,23,19,2),(1264,4,23,20,2),(1265,4,23,21,2),(1266,7,23,22,2),(1267,7,23,23,2),(1268,7,23,24,2),(1269,7,23,25,2),(1270,7,23,26,2),(1271,5,23,33,2),(1272,5,23,34,2),(1273,5,23,35,2),(1274,5,23,36,2),(1275,4,23,37,2),(1276,4,23,38,2),(1277,4,23,39,2),(1278,4,23,41,2),(1279,3,23,42,2),(1280,3,23,43,2),(1281,3,23,44,2),(1282,3,23,45,2),(1283,3,23,46,2),(1284,3,23,47,2),(1285,3,23,48,2),(1286,3,23,49,2),(1287,5,23,50,2),(1288,5,23,51,2),(1289,6,23,17,3),(1290,4,23,20,3),(1291,4,23,21,3),(1292,4,23,22,3),(1293,7,23,23,3),(1294,7,23,24,3),(1295,7,23,25,3),(1296,7,23,26,3),(1297,7,23,27,3),(1298,5,23,34,3),(1299,5,23,35,3),(1300,4,23,38,3),(1301,4,23,39,3),(1302,4,23,40,3),(1303,4,23,41,3),(1304,4,23,42,3),(1305,3,23,43,3),(1306,3,23,44,3),(1307,3,23,45,3),(1308,3,23,47,3),(1309,3,23,48,3),(1310,3,23,49,3),(1311,3,23,50,3),(1312,5,23,51,3),(1313,5,23,52,3),(1314,6,23,15,4),(1315,6,23,16,4),(1316,6,23,17,4),(1317,6,23,18,4),(1318,6,23,19,4),(1319,4,23,21,4),(1320,4,23,22,4),(1321,4,23,23,4),(1322,7,23,24,4),(1323,7,23,25,4),(1324,7,23,26,4),(1325,7,23,27,4),(1326,2,23,28,4),(1327,4,23,36,4),(1328,4,23,37,4),(1329,4,23,38,4),(1330,4,23,39,4),(1331,3,23,41,4),(1332,3,23,42,4),(1333,3,23,43,4),(1334,3,23,47,4),(1335,3,23,49,4),(1336,5,23,50,4),(1337,5,23,51,4),(1338,5,23,52,4),(1339,0,23,9,5),(1340,6,23,17,5),(1341,6,23,18,5),(1342,6,23,19,5),(1343,6,23,20,5),(1344,4,23,21,5),(1345,4,23,23,5),(1346,7,23,24,5),(1347,7,23,25,5),(1348,4,23,38,5),(1349,4,23,39,5),(1350,3,23,43,5),(1351,10,23,48,5),(1352,5,23,52,5),(1353,5,23,53,5),(1354,6,23,15,6),(1355,6,23,16,6),(1356,6,23,17,6),(1357,6,23,19,6),(1358,7,23,25,6),(1359,4,23,38,6),(1360,3,23,43,6),(1361,10,23,14,7),(1362,6,23,19,7),(1363,7,23,25,7),(1364,5,23,41,7),(1365,5,23,42,7),(1366,5,23,43,7),(1367,5,23,44,7),(1368,7,23,25,8),(1369,11,23,39,8),(1370,5,23,43,8),(1371,5,23,44,8),(1372,5,23,45,8),(1373,0,23,12,9),(1374,3,23,19,9),(1375,6,23,32,9),(1376,6,23,34,9),(1377,5,23,43,9),(1378,5,23,44,9),(1379,5,23,45,9),(1380,9,23,7,10),(1381,3,23,18,10),(1382,3,23,19,10),(1383,6,23,32,10),(1384,6,23,33,10),(1385,6,23,34,10),(1386,6,23,35,10),(1387,9,23,43,10),(1388,0,23,5,11),(1389,3,23,11,11),(1390,3,23,12,11),(1391,3,23,13,11),(1392,3,23,14,11),(1393,3,23,15,11),(1394,3,23,16,11),(1395,3,23,17,11),(1396,3,23,18,11),(1397,3,23,19,11),(1398,3,23,21,11),(1399,6,23,34,11),(1400,6,23,35,11),(1401,6,23,36,11),(1402,3,23,11,12),(1403,3,23,13,12),(1404,3,23,14,12),(1405,3,23,15,12),(1406,3,23,16,12),(1407,3,23,17,12),(1408,3,23,18,12),(1409,3,23,19,12),(1410,3,23,20,12),(1411,3,23,21,12),(1412,6,23,33,12),(1413,6,23,34,12),(1414,5,23,35,12),(1415,6,23,36,12),(1416,3,23,11,13),(1417,7,23,12,13),(1418,7,23,13,13),(1419,7,23,14,13),(1420,3,23,15,13),(1421,3,23,16,13),(1422,3,23,17,13),(1423,3,23,18,13),(1424,3,23,19,13),(1425,3,23,20,13),(1426,3,23,21,13),(1427,3,23,22,13),(1428,8,23,29,13),(1429,6,23,34,13),(1430,5,23,35,13),(1431,5,23,36,13),(1432,6,23,51,13),(1433,6,23,52,13),(1434,6,23,53,13),(1435,4,23,1,14),(1436,3,23,11,14),(1437,0,23,12,14),(1438,7,23,14,14),(1439,7,23,15,14),(1440,3,23,16,14),(1441,3,23,17,14),(1442,3,23,18,14),(1443,11,23,19,14),(1444,4,23,27,14),(1445,5,23,34,14),(1446,5,23,35,14),(1447,5,23,36,14),(1448,5,23,37,14),(1449,0,23,43,14),(1450,6,23,50,14),(1451,6,23,53,14),(1452,4,23,1,15),(1453,7,23,11,15),(1454,7,23,14,15),(1455,7,23,15,15),(1456,3,23,16,15),(1457,3,23,18,15),(1458,4,23,27,15),(1459,4,23,28,15),(1460,4,23,32,15),(1461,4,23,33,15),(1462,5,23,34,15),(1463,5,23,35,15),(1464,5,23,36,15),(1465,6,23,50,15),(1466,6,23,51,15),(1467,6,23,52,15),(1468,6,23,53,15),(1469,4,23,1,16),(1470,4,23,4,16),(1471,14,23,8,16),(1472,7,23,11,16),(1473,7,23,12,16),(1474,7,23,13,16),(1475,7,23,14,16),(1476,7,23,15,16),(1477,7,23,16,16),(1478,4,23,27,16),(1479,4,23,28,16),(1480,4,23,29,16),(1481,4,23,30,16),(1482,4,23,31,16),(1483,4,23,32,16),(1484,4,23,33,16),(1485,14,23,35,16),(1486,13,23,38,16),(1487,6,23,51,16),(1488,6,23,52,16),(1489,6,23,53,16),(1490,4,23,0,17),(1491,4,23,1,17),(1492,4,23,4,17),(1493,2,23,11,17),(1494,7,23,13,17),(1495,7,23,14,17),(1496,7,23,16,17),(1497,7,23,17,17),(1498,7,23,18,17),(1499,4,23,26,17),(1500,4,23,27,17),(1501,4,23,28,17),(1502,4,23,29,17),(1503,4,23,30,17),(1504,4,23,31,17),(1505,4,23,32,17),(1506,4,23,33,17),(1507,3,23,44,17),(1508,3,23,45,17),(1509,3,23,48,17),(1510,3,23,49,17),(1511,6,23,52,17),(1512,6,23,53,17),(1513,4,23,0,18),(1514,4,23,1,18),(1515,4,23,2,18),(1516,4,23,3,18),(1517,4,23,4,18),(1518,4,23,5,18),(1519,7,23,13,18),(1520,7,23,16,18),(1521,7,23,17,18),(1522,7,23,18,18),(1523,4,23,26,18),(1524,4,23,27,18),(1525,4,23,28,18),(1526,4,23,29,18),(1527,4,23,30,18),(1528,4,23,32,18),(1529,4,23,33,18),(1530,3,23,38,18),(1531,3,23,39,18),(1532,3,23,40,18),(1533,3,23,41,18),(1534,0,23,42,18),(1535,3,23,44,18),(1536,3,23,45,18),(1537,3,23,47,18),(1538,3,23,48,18),(1539,5,23,51,18),(1540,6,23,52,18),(1541,5,23,53,18),(1542,4,23,2,19),(1543,4,23,3,19),(1544,4,23,5,19),(1545,4,23,6,19),(1546,7,23,13,19),(1547,7,23,14,19),(1548,4,23,27,19),(1549,4,23,28,19),(1550,4,23,29,19),(1551,4,23,30,19),(1552,4,23,32,19),(1553,4,23,33,19),(1554,3,23,34,19),(1555,3,23,38,19),(1556,3,23,39,19),(1557,3,23,40,19),(1558,3,23,41,19),(1559,3,23,44,19),(1560,3,23,45,19),(1561,3,23,46,19),(1562,3,23,47,19),(1563,3,23,48,19),(1564,5,23,49,19),(1565,5,23,50,19),(1566,5,23,51,19),(1567,5,23,52,19),(1568,5,23,53,19),(1569,4,23,3,20),(1570,4,23,4,20),(1571,4,23,5,20),(1572,7,23,11,20),(1573,7,23,12,20),(1574,7,23,13,20),(1575,4,23,25,20),(1576,4,23,26,20),(1577,4,23,27,20),(1578,4,23,28,20),(1579,4,23,30,20),(1580,4,23,31,20),(1581,3,23,34,20),(1582,3,23,35,20),(1583,3,23,36,20),(1584,3,23,37,20),(1585,3,23,38,20),(1586,3,23,39,20),(1587,3,23,40,20),(1588,3,23,41,20),(1589,3,23,42,20),(1590,3,23,43,20),(1591,3,23,44,20),(1592,3,23,45,20),(1593,3,23,46,20),(1594,3,23,47,20),(1595,3,23,48,20),(1596,3,23,49,20),(1597,3,23,50,20),(1598,5,23,51,20),(1599,5,23,52,20),(1600,5,23,53,20),(1601,5,27,0,0),(1602,5,27,1,0),(1603,5,27,2,0),(1604,5,27,3,0),(1605,5,27,4,0),(1606,5,27,5,0),(1607,5,27,6,0),(1608,5,27,7,0),(1609,2,27,8,0),(1610,6,27,10,0),(1611,3,27,11,0),(1612,3,27,12,0),(1613,3,27,13,0),(1614,3,27,14,0),(1615,3,27,15,0),(1616,3,27,16,0),(1617,3,27,17,0),(1618,3,27,18,0),(1619,3,27,19,0),(1620,3,27,20,0),(1621,4,27,28,0),(1622,4,27,29,0),(1623,4,27,30,0),(1624,4,27,31,0),(1625,4,27,33,0),(1626,4,27,34,0),(1627,4,27,35,0),(1628,4,27,36,0),(1629,5,27,42,0),(1630,5,27,43,0),(1631,5,27,0,1),(1632,5,27,1,1),(1633,5,27,2,1),(1634,5,27,3,1),(1635,5,27,4,1),(1636,5,27,5,1),(1637,5,27,6,1),(1638,5,27,7,1),(1639,6,27,10,1),(1640,6,27,11,1),(1641,3,27,12,1),(1642,3,27,13,1),(1643,3,27,14,1),(1644,3,27,15,1),(1645,3,27,18,1),(1646,4,27,29,1),(1647,4,27,30,1),(1648,4,27,31,1),(1649,4,27,32,1),(1650,4,27,33,1),(1651,4,27,34,1),(1652,4,27,35,1),(1653,4,27,36,1),(1654,4,27,37,1),(1655,5,27,42,1),(1656,5,27,43,1),(1657,5,27,44,1),(1658,5,27,47,1),(1659,5,27,0,2),(1660,5,27,1,2),(1661,5,27,2,2),(1662,5,27,3,2),(1663,5,27,4,2),(1664,5,27,5,2),(1665,5,27,6,2),(1666,5,27,7,2),(1667,5,27,8,2),(1668,6,27,10,2),(1669,6,27,11,2),(1670,3,27,12,2),(1671,6,27,13,2),(1672,3,27,14,2),(1673,3,27,15,2),(1674,12,27,23,2),(1675,4,27,30,2),(1676,4,27,31,2),(1677,4,27,32,2),(1678,4,27,33,2),(1679,4,27,34,2),(1680,4,27,35,2),(1681,5,27,40,2),(1682,5,27,41,2),(1683,5,27,42,2),(1684,5,27,43,2),(1685,5,27,44,2),(1686,5,27,47,2),(1687,5,27,0,3),(1688,5,27,1,3),(1689,0,27,2,3),(1690,5,27,4,3),(1691,5,27,5,3),(1692,5,27,6,3),(1693,5,27,7,3),(1694,5,27,8,3),(1695,6,27,9,3),(1696,6,27,10,3),(1697,6,27,11,3),(1698,6,27,12,3),(1699,6,27,13,3),(1700,3,27,14,3),(1701,3,27,15,3),(1702,3,27,16,3),(1703,11,27,17,3),(1704,4,27,31,3),(1705,4,27,32,3),(1706,4,27,33,3),(1707,4,27,34,3),(1708,5,27,39,3),(1709,5,27,40,3),(1710,5,27,41,3),(1711,5,27,42,3),(1712,5,27,43,3),(1713,5,27,44,3),(1714,5,27,45,3),(1715,5,27,46,3),(1716,5,27,47,3),(1717,5,27,48,3),(1718,5,27,0,4),(1719,5,27,1,4),(1720,5,27,4,4),(1721,5,27,5,4),(1722,5,27,6,4),(1723,3,27,10,4),(1724,3,27,11,4),(1725,3,27,12,4),(1726,3,27,13,4),(1727,3,27,14,4),(1728,3,27,15,4),(1729,3,27,16,4),(1730,4,27,33,4),(1731,4,27,34,4),(1732,4,27,35,4),(1733,5,27,38,4),(1734,5,27,39,4),(1735,5,27,41,4),(1736,5,27,42,4),(1737,5,27,43,4),(1738,5,27,44,4),(1739,5,27,45,4),(1740,5,27,46,4),(1741,5,27,47,4),(1742,5,27,1,5),(1743,13,27,3,5),(1744,3,27,14,5),(1745,3,27,15,5),(1746,3,27,16,5),(1747,4,27,35,5),(1748,5,27,42,5),(1749,5,27,44,5),(1750,5,27,46,5),(1751,5,27,47,5),(1752,5,27,42,6),(1753,5,27,43,6),(1754,5,27,44,6),(1755,5,27,46,6),(1756,1,27,1,7),(1757,6,27,5,7),(1758,6,27,6,7),(1759,12,27,41,7),(1760,6,27,6,8),(1761,6,27,7,8),(1762,10,27,8,8),(1763,8,27,2,9),(1764,6,27,6,9),(1765,6,27,7,9),(1766,8,27,34,9),(1767,6,27,7,10),(1768,6,27,31,10),(1769,9,27,37,10),(1770,6,27,5,11),(1771,6,27,6,11),(1772,6,27,7,11),(1773,0,27,13,11),(1774,6,27,31,11),(1775,6,27,32,11),(1776,7,27,48,11),(1777,6,27,6,12),(1778,5,27,15,12),(1779,5,27,16,12),(1780,3,27,18,12),(1781,3,27,19,12),(1782,3,27,20,12),(1783,6,27,29,12),(1784,6,27,30,12),(1785,6,27,31,12),(1786,6,27,32,12),(1787,9,27,33,12),(1788,7,27,47,12),(1789,7,27,48,12),(1790,0,27,11,13),(1791,5,27,13,13),(1792,5,27,14,13),(1793,5,27,15,13),(1794,3,27,18,13),(1795,3,27,19,13),(1796,3,27,20,13),(1797,6,27,29,13),(1798,6,27,30,13),(1799,6,27,31,13),(1800,6,27,32,13),(1801,5,27,37,13),(1802,5,27,38,13),(1803,2,27,40,13),(1804,7,27,45,13),(1805,7,27,46,13),(1806,7,27,47,13),(1807,7,27,48,13),(1808,0,27,5,14),(1809,5,27,13,14),(1810,5,27,14,14),(1811,5,27,15,14),(1812,3,27,16,14),(1813,3,27,17,14),(1814,3,27,19,14),(1815,3,27,20,14),(1816,11,27,29,14),(1817,5,27,37,14),(1818,5,27,38,14),(1819,7,27,46,14),(1820,5,27,10,15),(1821,5,27,11,15),(1822,5,27,12,15),(1823,5,27,13,15),(1824,5,27,14,15),(1825,5,27,15,15),(1826,5,27,16,15),(1827,3,27,17,15),(1828,3,27,18,15),(1829,3,27,19,15),(1830,5,27,33,15),(1831,5,27,34,15),(1832,5,27,35,15),(1833,5,27,36,15),(1834,5,27,37,15),(1835,5,27,38,15),(1836,5,27,39,15),(1837,7,27,43,15),(1838,7,27,44,15),(1839,7,27,45,15),(1840,7,27,46,15),(1841,7,27,47,15),(1842,7,27,48,15),(1843,7,27,49,15),(1844,5,27,10,16),(1845,5,27,11,16),(1846,5,27,12,16),(1847,5,27,13,16),(1848,5,27,14,16),(1849,5,27,15,16),(1850,4,27,16,16),(1851,3,27,17,16),(1852,3,27,18,16),(1853,3,27,19,16),(1854,3,27,20,16),(1855,5,27,33,16),(1856,5,27,34,16),(1857,5,27,35,16),(1858,5,27,36,16),(1859,5,27,37,16),(1860,5,27,38,16),(1861,5,27,39,16),(1862,5,27,40,16),(1863,5,27,41,16),(1864,7,27,44,16),(1865,7,27,45,16),(1866,7,27,46,16),(1867,7,27,47,16),(1868,7,27,48,16),(1869,7,27,49,16),(1870,7,27,50,16),(1871,5,27,10,17),(1872,5,27,11,17),(1873,5,27,12,17),(1874,5,27,13,17),(1875,4,27,14,17),(1876,5,27,15,17),(1877,4,27,16,17),(1878,4,27,17,17),(1879,4,27,18,17),(1880,4,27,19,17),(1881,1,27,22,17),(1882,5,27,33,17),(1883,5,27,34,17),(1884,5,27,35,17),(1885,5,27,36,17),(1886,5,27,37,17),(1887,5,27,38,17),(1888,5,27,40,17),(1889,5,27,41,17),(1890,5,27,42,17),(1891,7,27,44,17),(1892,7,27,45,17),(1893,7,27,46,17),(1894,7,27,47,17),(1895,7,27,48,17),(1896,7,27,49,17),(1897,7,27,50,17),(1898,5,27,7,18),(1899,5,27,8,18),(1900,5,27,9,18),(1901,5,27,10,18),(1902,5,27,11,18),(1903,5,27,12,18),(1904,5,27,13,18),(1905,4,27,14,18),(1906,4,27,15,18),(1907,4,27,16,18),(1908,4,27,17,18),(1909,4,27,18,18),(1910,4,27,19,18),(1911,4,27,20,18),(1912,5,27,34,18),(1913,5,27,35,18),(1914,5,27,36,18),(1915,5,27,37,18),(1916,5,27,38,18),(1917,7,27,41,18),(1918,7,27,42,18),(1919,7,27,43,18),(1920,7,27,44,18),(1921,7,27,45,18),(1922,7,27,46,18),(1923,7,27,47,18),(1924,7,27,48,18),(1925,7,27,49,18),(1926,7,27,50,18),(1927,6,27,5,19),(1928,5,27,7,19),(1929,5,27,8,19),(1930,5,27,9,19),(1931,3,27,10,19),(1932,3,27,11,19),(1933,3,27,12,19),(1934,5,27,13,19),(1935,4,27,14,19),(1936,4,27,15,19),(1937,4,27,16,19),(1938,4,27,17,19),(1939,4,27,18,19),(1940,10,27,21,19),(1941,5,27,34,19),(1942,5,27,35,19),(1943,5,27,36,19),(1944,5,27,37,19),(1945,7,27,43,19),(1946,7,27,44,19),(1947,7,27,45,19),(1948,7,27,46,19),(1949,7,27,47,19),(1950,7,27,48,19),(1951,6,27,4,20),(1952,6,27,5,20),(1953,6,27,6,20),(1954,6,27,7,20),(1955,6,27,8,20),(1956,5,27,9,20),(1957,3,27,11,20),(1958,3,27,12,20),(1959,3,27,13,20),(1960,3,27,14,20),(1961,4,27,15,20),(1962,4,27,16,20),(1963,4,27,18,20),(1964,14,27,30,20),(1965,5,27,34,20),(1966,4,27,35,20),(1967,4,27,36,20),(1968,4,27,37,20),(1969,4,27,38,20),(1970,4,27,39,20),(1971,4,27,40,20),(1972,7,27,44,20),(1973,7,27,45,20),(1974,7,27,46,20),(1975,7,27,47,20),(1976,7,27,48,20),(1977,6,27,4,21),(1978,6,27,5,21),(1979,6,27,6,21),(1980,6,27,7,21),(1981,6,27,8,21),(1982,5,27,9,21),(1983,3,27,10,21),(1984,3,27,11,21),(1985,3,27,12,21),(1986,3,27,13,21),(1987,4,27,14,21),(1988,4,27,15,21),(1989,4,27,16,21),(1990,4,27,17,21),(1991,4,27,18,21),(1992,4,27,33,21),(1993,4,27,34,21),(1994,4,27,35,21),(1995,4,27,36,21),(1996,4,27,37,21),(1997,4,27,38,21),(1998,7,27,45,21),(1999,7,27,47,21),(2000,6,27,48,21),(2001,6,27,49,21),(2002,6,27,50,21),(2003,13,27,3,22),(2004,3,27,9,22),(2005,3,27,10,22),(2006,3,27,11,22),(2007,3,27,12,22),(2008,3,27,13,22),(2009,4,27,14,22),(2010,0,27,15,22),(2011,4,27,17,22),(2012,4,27,18,22),(2013,4,27,33,22),(2014,4,27,34,22),(2015,4,27,35,22),(2016,4,27,36,22),(2017,4,27,37,22),(2018,6,27,47,22),(2019,6,27,48,22),(2020,6,27,49,22),(2021,3,27,13,23),(2022,4,27,17,23),(2023,4,27,18,23),(2024,4,27,33,23),(2025,4,27,34,23),(2026,4,27,35,23),(2027,4,27,36,23),(2028,4,27,37,23),(2029,4,27,38,23),(2030,4,27,39,23),(2031,6,27,47,23),(2032,6,27,48,23),(2033,6,27,49,23),(2034,4,27,31,24),(2035,4,27,32,24),(2036,4,27,33,24),(2037,4,27,34,24),(2038,4,27,35,24),(2039,4,27,37,24),(2040,4,27,39,24),(2041,6,27,48,24),(2042,6,27,49,24),(2043,3,30,12,0),(2044,3,30,13,0),(2045,3,30,14,0),(2046,3,30,15,0),(2047,3,30,16,0),(2048,3,30,17,0),(2049,5,30,23,0),(2050,5,30,24,0),(2051,5,30,25,0),(2052,5,30,26,0),(2053,5,30,27,0),(2054,5,30,28,0),(2055,5,30,29,0),(2056,5,30,30,0),(2057,3,30,14,1),(2058,3,30,15,1),(2059,3,30,16,1),(2060,5,30,20,1),(2061,5,30,23,1),(2062,5,30,24,1),(2063,5,30,25,1),(2064,5,30,26,1),(2065,5,30,27,1),(2066,5,30,28,1),(2067,5,30,30,1),(2068,14,30,36,1),(2069,10,30,8,2),(2070,3,30,13,2),(2071,3,30,14,2),(2072,3,30,15,2),(2073,5,30,20,2),(2074,5,30,21,2),(2075,5,30,22,2),(2076,5,30,24,2),(2077,5,30,25,2),(2078,5,30,26,2),(2079,5,30,27,2),(2080,5,30,28,2),(2081,5,30,29,2),(2082,5,30,30,2),(2083,5,30,31,2),(2084,0,30,34,2),(2085,0,30,41,2),(2086,3,30,14,3),(2087,5,30,20,3),(2088,5,30,21,3),(2089,5,30,22,3),(2090,5,30,23,3),(2091,5,30,24,3),(2092,5,30,25,3),(2093,5,30,26,3),(2094,5,30,27,3),(2095,5,30,12,4),(2096,3,30,13,4),(2097,3,30,14,4),(2098,3,30,15,4),(2099,5,30,22,4),(2100,5,30,23,4),(2101,5,30,25,4),(2102,14,30,26,4),(2103,7,30,45,4),(2104,7,30,46,4),(2105,6,30,1,5),(2106,6,30,2,5),(2107,5,30,12,5),(2108,5,30,13,5),(2109,3,30,14,5),(2110,5,30,22,5),(2111,5,30,23,5),(2112,7,30,46,5),(2113,6,30,0,6),(2114,6,30,2,6),(2115,5,30,10,6),(2116,5,30,11,6),(2117,5,30,13,6),(2118,3,30,14,6),(2119,5,30,15,6),(2120,8,30,20,6),(2121,7,30,42,6),(2122,7,30,46,6),(2123,6,30,0,7),(2124,6,30,1,7),(2125,6,30,2,7),(2126,5,30,10,7),(2127,5,30,11,7),(2128,5,30,12,7),(2129,5,30,13,7),(2130,5,30,14,7),(2131,5,30,15,7),(2132,5,30,16,7),(2133,5,30,17,7),(2134,7,30,41,7),(2135,7,30,42,7),(2136,7,30,43,7),(2137,7,30,44,7),(2138,7,30,45,7),(2139,7,30,46,7),(2140,7,30,48,7),(2141,6,30,0,8),(2142,6,30,1,8),(2143,6,30,2,8),(2144,4,30,4,8),(2145,5,30,11,8),(2146,5,30,12,8),(2147,5,30,13,8),(2148,5,30,14,8),(2149,5,30,15,8),(2150,5,30,16,8),(2151,10,30,37,8),(2152,7,30,41,8),(2153,7,30,42,8),(2154,7,30,46,8),(2155,7,30,47,8),(2156,7,30,48,8),(2157,6,30,0,9),(2158,6,30,1,9),(2159,4,30,2,9),(2160,4,30,3,9),(2161,4,30,4,9),(2162,4,30,5,9),(2163,5,30,12,9),(2164,5,30,14,9),(2165,11,30,22,9),(2166,7,30,42,9),(2167,7,30,43,9),(2168,7,30,44,9),(2169,7,30,45,9),(2170,7,30,46,9),(2171,7,30,47,9),(2172,7,30,48,9),(2173,6,30,0,10),(2174,4,30,1,10),(2175,4,30,2,10),(2176,4,30,3,10),(2177,4,30,4,10),(2178,4,30,5,10),(2179,4,30,6,10),(2180,4,30,8,10),(2181,5,30,12,10),(2182,5,30,13,10),(2183,5,30,14,10),(2184,3,30,15,10),(2185,3,30,16,10),(2186,3,30,18,10),(2187,3,30,20,10),(2188,3,30,21,10),(2189,1,30,41,10),(2190,4,30,45,10),(2191,4,30,46,10),(2192,4,30,47,10),(2193,4,30,48,10),(2194,0,30,2,11),(2195,4,30,4,11),(2196,4,30,5,11),(2197,4,30,6,11),(2198,4,30,7,11),(2199,4,30,8,11),(2200,5,30,11,11),(2201,5,30,13,11),(2202,3,30,14,11),(2203,3,30,15,11),(2204,3,30,16,11),(2205,3,30,17,11),(2206,3,30,18,11),(2207,3,30,19,11),(2208,3,30,20,11),(2209,3,30,21,11),(2210,9,30,31,11),(2211,4,30,46,11),(2212,4,30,47,11),(2213,4,30,48,11),(2214,4,30,4,12),(2215,4,30,5,12),(2216,4,30,6,12),(2217,4,30,7,12),(2218,4,30,8,12),(2219,5,30,10,12),(2220,5,30,11,12),(2221,5,30,12,12),(2222,5,30,13,12),(2223,5,30,14,12),(2224,5,30,15,12),(2225,5,30,16,12),(2226,3,30,17,12),(2227,3,30,19,12),(2228,3,30,20,12),(2229,3,30,21,12),(2230,5,30,36,12),(2231,5,30,37,12),(2232,5,30,39,12),(2233,5,30,40,12),(2234,5,30,41,12),(2235,5,30,42,12),(2236,4,30,43,12),(2237,4,30,44,12),(2238,4,30,45,12),(2239,4,30,46,12),(2240,4,30,47,12),(2241,4,30,48,12),(2242,4,30,4,13),(2243,4,30,5,13),(2244,7,30,6,13),(2245,7,30,7,13),(2246,4,30,8,13),(2247,5,30,10,13),(2248,5,30,13,13),(2249,5,30,14,13),(2250,5,30,15,13),(2251,3,30,17,13),(2252,3,30,18,13),(2253,3,30,19,13),(2254,3,30,20,13),(2255,3,30,21,13),(2256,5,30,36,13),(2257,5,30,37,13),(2258,5,30,38,13),(2259,5,30,39,13),(2260,5,30,40,13),(2261,5,30,41,13),(2262,5,30,42,13),(2263,4,30,43,13),(2264,4,30,45,13),(2265,4,30,47,13),(2266,4,30,48,13),(2267,6,30,1,14),(2268,6,30,2,14),(2269,6,30,3,14),(2270,6,30,4,14),(2271,4,30,5,14),(2272,7,30,6,14),(2273,7,30,7,14),(2274,5,30,12,14),(2275,5,30,13,14),(2276,3,30,15,14),(2277,3,30,16,14),(2278,3,30,17,14),(2279,3,30,18,14),(2280,3,30,19,14),(2281,3,30,20,14),(2282,3,30,21,14),(2283,11,30,28,14),(2284,0,30,37,14),(2285,5,30,39,14),(2286,5,30,40,14),(2287,5,30,41,14),(2288,5,30,42,14),(2289,5,30,43,14),(2290,4,30,44,14),(2291,4,30,45,14),(2292,4,30,46,14),(2293,4,30,47,14),(2294,4,30,48,14),(2295,6,30,2,15),(2296,6,30,3,15),(2297,6,30,4,15),(2298,7,30,5,15),(2299,7,30,6,15),(2300,7,30,7,15),(2301,13,30,8,15),(2302,3,30,17,15),(2303,3,30,18,15),(2304,3,30,19,15),(2305,3,30,20,15),(2306,5,30,39,15),(2307,5,30,40,15),(2308,5,30,41,15),(2309,12,30,42,15),(2310,4,30,48,15),(2311,6,30,1,16),(2312,6,30,2,16),(2313,6,30,3,16),(2314,6,30,4,16),(2315,7,30,5,16),(2316,3,30,6,16),(2317,7,30,7,16),(2318,3,30,18,16),(2319,3,30,19,16),(2320,5,30,36,16),(2321,5,30,37,16),(2322,5,30,38,16),(2323,5,30,39,16),(2324,5,30,40,16),(2325,5,30,41,16),(2326,4,30,48,16),(2327,6,30,1,17),(2328,6,30,2,17),(2329,7,30,3,17),(2330,7,30,4,17),(2331,7,30,5,17),(2332,3,30,6,17),(2333,7,30,7,17),(2334,7,30,8,17),(2335,7,30,9,17),(2336,6,30,10,17),(2337,6,30,11,17),(2338,5,30,37,17),(2339,5,30,38,17),(2340,5,30,39,17),(2341,4,30,48,17),(2342,7,30,2,18),(2343,7,30,3,18),(2344,3,30,4,18),(2345,7,30,5,18),(2346,3,30,6,18),(2347,3,30,7,18),(2348,3,30,8,18),(2349,3,30,9,18),(2350,6,30,10,18),(2351,6,30,11,18),(2352,6,30,12,18),(2353,6,30,13,18),(2354,6,30,14,18),(2355,4,30,25,18),(2356,4,30,26,18),(2357,4,30,27,18),(2358,5,30,36,18),(2359,5,30,37,18),(2360,5,30,38,18),(2361,5,30,39,18),(2362,5,30,40,18),(2363,4,30,48,18),(2364,7,30,1,19),(2365,7,30,2,19),(2366,7,30,3,19),(2367,3,30,4,19),(2368,3,30,5,19),(2369,3,30,6,19),(2370,3,30,7,19),(2371,3,30,8,19),(2372,2,30,9,19),(2373,6,30,11,19),(2374,6,30,12,19),(2375,6,30,17,19),(2376,6,30,18,19),(2377,1,30,19,19),(2378,4,30,25,19),(2379,4,30,26,19),(2380,4,30,27,19),(2381,0,30,34,19),(2382,5,30,36,19),(2383,5,30,37,19),(2384,4,30,48,19),(2385,7,30,1,20),(2386,7,30,2,20),(2387,3,30,6,20),(2388,3,30,7,20),(2389,3,30,8,20),(2390,6,30,12,20),(2391,6,30,15,20),(2392,6,30,16,20),(2393,6,30,17,20),(2394,6,30,18,20),(2395,4,30,21,20),(2396,4,30,22,20),(2397,4,30,23,20),(2398,4,30,24,20),(2399,4,30,25,20),(2400,4,30,26,20),(2401,4,30,27,20),(2402,4,30,28,20),(2403,4,30,29,20),(2404,4,30,30,20),(2405,4,30,31,20),(2406,4,30,32,20),(2407,4,30,33,20),(2408,5,30,36,20),(2409,5,30,37,20),(2410,5,30,38,20),(2411,4,30,48,20),(2412,7,30,2,21),(2413,3,30,6,21),(2414,3,30,7,21),(2415,3,30,8,21),(2416,6,30,12,21),(2417,6,30,13,21),(2418,6,30,14,21),(2419,6,30,16,21),(2420,6,30,17,21),(2421,6,30,18,21),(2422,6,30,19,21),(2423,6,30,20,21),(2424,6,30,21,21),(2425,4,30,24,21),(2426,4,30,25,21),(2427,4,30,26,21),(2428,4,30,27,21),(2429,4,30,28,21),(2430,4,30,29,21),(2431,4,30,30,21),(2432,4,30,31,21),(2433,4,30,32,21),(2434,5,30,37,21),(2435,5,33,4,0),(2436,5,33,5,0),(2437,5,33,6,0),(2438,5,33,7,0),(2439,5,33,8,0),(2440,5,33,9,0),(2441,5,33,10,0),(2442,4,33,15,0),(2443,6,33,24,0),(2444,6,33,26,0),(2445,1,33,29,0),(2446,4,33,37,0),(2447,4,33,38,0),(2448,4,33,39,0),(2449,5,33,3,1),(2450,5,33,4,1),(2451,5,33,5,1),(2452,5,33,6,1),(2453,5,33,7,1),(2454,5,33,8,1),(2455,5,33,9,1),(2456,5,33,10,1),(2457,4,33,11,1),(2458,4,33,15,1),(2459,4,33,16,1),(2460,0,33,17,1),(2461,0,33,20,1),(2462,6,33,23,1),(2463,6,33,24,1),(2464,6,33,25,1),(2465,6,33,26,1),(2466,4,33,36,1),(2467,4,33,37,1),(2468,4,33,38,1),(2469,4,33,39,1),(2470,5,33,3,2),(2471,5,33,4,2),(2472,5,33,5,2),(2473,5,33,6,2),(2474,5,33,7,2),(2475,5,33,8,2),(2476,5,33,9,2),(2477,4,33,10,2),(2478,4,33,11,2),(2479,4,33,13,2),(2480,4,33,14,2),(2481,4,33,15,2),(2482,4,33,16,2),(2483,10,33,24,2),(2484,0,33,29,2),(2485,4,33,35,2),(2486,4,33,36,2),(2487,4,33,37,2),(2488,4,33,38,2),(2489,4,33,39,2),(2490,5,33,4,3),(2491,8,33,5,3),(2492,5,33,8,3),(2493,4,33,11,3),(2494,4,33,12,3),(2495,4,33,13,3),(2496,4,33,14,3),(2497,4,33,15,3),(2498,11,33,16,3),(2499,4,33,35,3),(2500,4,33,38,3),(2501,4,33,39,3),(2502,5,33,4,4),(2503,5,33,8,4),(2504,4,33,10,4),(2505,4,33,11,4),(2506,4,33,12,4),(2507,4,33,13,4),(2508,4,33,15,4),(2509,7,33,35,4),(2510,4,33,36,4),(2511,4,33,37,4),(2512,4,33,38,4),(2513,4,33,39,4),(2514,5,33,8,5),(2515,4,33,12,5),(2516,5,33,13,5),(2517,5,33,14,5),(2518,6,33,34,5),(2519,7,33,35,5),(2520,7,33,36,5),(2521,4,33,38,5),(2522,4,33,39,5),(2523,5,33,8,6),(2524,5,33,11,6),(2525,5,33,12,6),(2526,5,33,14,6),(2527,5,33,15,6),(2528,6,33,32,6),(2529,6,33,33,6),(2530,6,33,34,6),(2531,7,33,35,6),(2532,14,33,36,6),(2533,3,33,39,6),(2534,5,33,8,7),(2535,5,33,9,7),(2536,5,33,11,7),(2537,5,33,13,7),(2538,5,33,14,7),(2539,5,33,15,7),(2540,6,33,21,7),(2541,7,33,32,7),(2542,6,33,33,7),(2543,6,33,34,7),(2544,7,33,35,7),(2545,3,33,39,7),(2546,5,33,7,8),(2547,5,33,8,8),(2548,5,33,9,8),(2549,5,33,10,8),(2550,5,33,11,8),(2551,5,33,12,8),(2552,5,33,13,8),(2553,5,33,14,8),(2554,5,33,15,8),(2555,6,33,20,8),(2556,6,33,21,8),(2557,7,33,32,8),(2558,7,33,33,8),(2559,7,33,34,8),(2560,7,33,35,8),(2561,3,33,39,8),(2562,5,33,7,9),(2563,3,33,8,9),(2564,3,33,9,9),(2565,3,33,10,9),(2566,5,33,11,9),(2567,5,33,12,9),(2568,5,33,13,9),(2569,5,33,14,9),(2570,5,33,15,9),(2571,6,33,20,9),(2572,6,33,21,9),(2573,6,33,22,9),(2574,7,33,31,9),(2575,7,33,32,9),(2576,7,33,33,9),(2577,6,33,34,9),(2578,6,33,35,9),(2579,3,33,39,9),(2580,3,33,9,10),(2581,3,33,10,10),(2582,3,33,11,10),(2583,1,33,12,10),(2584,5,33,14,10),(2585,5,33,15,10),(2586,2,33,16,10),(2587,0,33,24,10),(2588,7,33,31,10),(2589,7,33,32,10),(2590,6,33,34,10),(2591,6,33,35,10),(2592,14,33,36,10),(2593,3,33,39,10),(2594,3,33,7,11),(2595,3,33,10,11),(2596,3,33,11,11),(2597,5,33,14,11),(2598,4,33,23,11),(2599,4,33,26,11),(2600,4,33,27,11),(2601,9,33,28,11),(2602,7,33,32,11),(2603,6,33,34,11),(2604,6,33,35,11),(2605,3,33,39,11),(2606,3,33,7,12),(2607,3,33,8,12),(2608,3,33,10,12),(2609,3,33,11,12),(2610,3,33,12,12),(2611,3,33,13,12),(2612,3,33,14,12),(2613,13,33,15,12),(2614,4,33,23,12),(2615,4,33,24,12),(2616,4,33,25,12),(2617,4,33,26,12),(2618,3,33,39,12),(2619,3,33,5,13),(2620,3,33,7,13),(2621,3,33,8,13),(2622,3,33,9,13),(2623,3,33,10,13),(2624,3,33,11,13),(2625,3,33,12,13),(2626,0,33,13,13),(2627,4,33,26,13),(2628,4,33,27,13),(2629,3,33,39,13),(2630,3,33,5,14),(2631,3,33,6,14),(2632,3,33,7,14),(2633,3,33,8,14),(2634,3,33,9,14),(2635,5,33,10,14),(2636,5,33,11,14),(2637,3,33,12,14),(2638,7,33,15,14),(2639,7,33,16,14),(2640,7,33,17,14),(2641,7,33,18,14),(2642,7,33,19,14),(2643,12,33,20,14),(2644,4,33,26,14),(2645,4,33,27,14),(2646,11,33,28,14),(2647,12,33,33,14),(2648,3,33,39,14),(2649,3,33,3,15),(2650,3,33,4,15),(2651,3,33,5,15),(2652,3,33,6,15),(2653,3,33,7,15),(2654,3,33,8,15),(2655,3,33,9,15),(2656,5,33,10,15),(2657,5,33,11,15),(2658,3,33,12,15),(2659,3,33,13,15),(2660,7,33,15,15),(2661,7,33,16,15),(2662,7,33,17,15),(2663,7,33,18,15),(2664,7,33,19,15),(2665,4,33,26,15),(2666,4,33,27,15),(2667,3,33,39,15),(2668,3,33,3,16),(2669,3,33,4,16),(2670,3,33,5,16),(2671,3,33,6,16),(2672,3,33,7,16),(2673,3,33,8,16),(2674,3,33,9,16),(2675,5,33,10,16),(2676,3,33,12,16),(2677,3,33,13,16),(2678,7,33,14,16),(2679,7,33,15,16),(2680,7,33,16,16),(2681,7,33,18,16),(2682,7,33,19,16),(2683,4,33,26,16),(2684,4,33,27,16),(2685,3,33,39,16),(2686,3,33,4,17),(2687,3,33,6,17),(2688,5,33,8,17),(2689,5,33,9,17),(2690,5,33,10,17),(2691,5,33,11,17),(2692,5,33,12,17),(2693,5,33,13,17),(2694,7,33,16,17),(2695,6,33,18,17),(2696,6,33,19,17),(2697,4,33,26,17),(2698,4,33,27,17),(2699,3,33,39,17),(2700,5,33,7,18),(2701,5,33,8,18),(2702,5,33,9,18),(2703,5,33,10,18),(2704,5,33,11,18),(2705,0,33,12,18),(2706,4,33,26,18),(2707,4,33,27,18),(2708,3,33,39,18),(2709,5,33,8,19),(2710,5,33,9,19),(2711,5,33,10,19),(2712,5,33,11,19),(2713,4,33,26,19),(2714,3,33,32,19),(2715,3,33,39,19),(2716,5,33,6,20),(2717,5,33,7,20),(2718,5,33,8,20),(2719,5,33,9,20),(2720,5,33,10,20),(2721,5,33,11,20),(2722,5,33,12,20),(2723,5,33,13,20),(2724,3,33,30,20),(2725,3,33,31,20),(2726,3,33,32,20),(2727,3,33,33,20),(2728,3,33,34,20),(2729,3,33,35,20),(2730,3,33,36,20),(2731,3,33,37,20),(2732,3,33,38,20),(2733,3,33,39,20),(2734,3,34,0,0),(2735,3,34,1,0),(2736,3,34,2,0),(2737,3,34,3,0),(2738,3,34,4,0),(2739,3,34,7,0),(2740,3,34,8,0),(2741,3,34,9,0),(2742,5,34,10,0),(2743,5,34,11,0),(2744,0,34,14,0),(2745,8,34,34,0),(2746,7,34,37,0),(2747,7,34,38,0),(2748,7,34,39,0),(2749,7,34,40,0),(2750,7,34,42,0),(2751,7,34,43,0),(2752,7,34,44,0),(2753,7,34,45,0),(2754,4,34,46,0),(2755,4,34,47,0),(2756,3,34,0,1),(2757,3,34,1,1),(2758,3,34,2,1),(2759,3,34,3,1),(2760,3,34,4,1),(2761,3,34,5,1),(2762,3,34,6,1),(2763,3,34,7,1),(2764,3,34,8,1),(2765,3,34,9,1),(2766,5,34,10,1),(2767,5,34,11,1),(2768,5,34,12,1),(2769,5,34,13,1),(2770,7,34,40,1),(2771,7,34,42,1),(2772,7,34,43,1),(2773,4,34,44,1),(2774,4,34,45,1),(2775,4,34,46,1),(2776,4,34,47,1),(2777,3,34,0,2),(2778,3,34,1,2),(2779,3,34,2,2),(2780,3,34,3,2),(2781,3,34,4,2),(2782,3,34,5,2),(2783,3,34,6,2),(2784,3,34,7,2),(2785,3,34,8,2),(2786,3,34,9,2),(2787,5,34,10,2),(2788,0,34,11,2),(2789,7,34,38,2),(2790,7,34,39,2),(2791,7,34,40,2),(2792,7,34,41,2),(2793,7,34,42,2),(2794,7,34,43,2),(2795,4,34,46,2),(2796,4,34,47,2),(2797,4,34,48,2),(2798,4,34,49,2),(2799,3,34,0,3),(2800,3,34,1,3),(2801,3,34,2,3),(2802,3,34,3,3),(2803,3,34,4,3),(2804,3,34,5,3),(2805,3,34,6,3),(2806,3,34,7,3),(2807,3,34,8,3),(2808,3,34,9,3),(2809,5,34,10,3),(2810,6,34,13,3),(2811,6,34,14,3),(2812,6,34,15,3),(2813,7,34,37,3),(2814,7,34,38,3),(2815,7,34,39,3),(2816,7,34,40,3),(2817,7,34,41,3),(2818,7,34,42,3),(2819,4,34,43,3),(2820,4,34,44,3),(2821,4,34,45,3),(2822,4,34,46,3),(2823,4,34,49,3),(2824,3,34,0,4),(2825,3,34,1,4),(2826,3,34,2,4),(2827,3,34,3,4),(2828,3,34,7,4),(2829,3,34,8,4),(2830,5,34,9,4),(2831,5,34,10,4),(2832,6,34,11,4),(2833,6,34,12,4),(2834,6,34,13,4),(2835,6,34,14,4),(2836,6,34,15,4),(2837,6,34,19,4),(2838,0,34,33,4),(2839,7,34,38,4),(2840,7,34,39,4),(2841,7,34,40,4),(2842,4,34,42,4),(2843,4,34,43,4),(2844,4,34,44,4),(2845,4,34,45,4),(2846,4,34,46,4),(2847,4,34,47,4),(2848,0,34,49,4),(2849,3,34,0,5),(2850,3,34,1,5),(2851,3,34,2,5),(2852,3,34,3,5),(2853,3,34,6,5),(2854,3,34,7,5),(2855,5,34,8,5),(2856,5,34,9,5),(2857,5,34,10,5),(2858,5,34,11,5),(2859,13,34,12,5),(2860,6,34,19,5),(2861,9,34,20,5),(2862,7,34,38,5),(2863,7,34,39,5),(2864,7,34,40,5),(2865,7,34,41,5),(2866,4,34,42,5),(2867,0,34,43,5),(2868,4,34,46,5),(2869,4,34,47,5),(2870,5,34,0,6),(2871,5,34,1,6),(2872,3,34,2,6),(2873,5,34,3,6),(2874,3,34,5,6),(2875,3,34,6,6),(2876,3,34,7,6),(2877,3,34,8,6),(2878,5,34,9,6),(2879,5,34,10,6),(2880,5,34,11,6),(2881,6,34,19,6),(2882,11,34,31,6),(2883,11,34,35,6),(2884,7,34,40,6),(2885,7,34,41,6),(2886,4,34,45,6),(2887,4,34,46,6),(2888,4,34,47,6),(2889,4,34,48,6),(2890,4,34,49,6),(2891,5,34,0,7),(2892,5,34,1,7),(2893,5,34,2,7),(2894,5,34,3,7),(2895,3,34,7,7),(2896,3,34,8,7),(2897,5,34,9,7),(2898,1,34,15,7),(2899,6,34,18,7),(2900,6,34,19,7),(2901,14,34,40,7),(2902,0,34,43,7),(2903,4,34,45,7),(2904,4,34,46,7),(2905,4,34,47,7),(2906,4,34,49,7),(2907,5,34,0,8),(2908,5,34,1,8),(2909,5,34,2,8),(2910,5,34,3,8),(2911,5,34,4,8),(2912,3,34,6,8),(2913,3,34,7,8),(2914,3,34,8,8),(2915,3,34,9,8),(2916,6,34,19,8),(2917,6,34,20,8),(2918,6,34,21,8),(2919,6,34,22,8),(2920,4,34,45,8),(2921,10,34,46,8),(2922,5,34,0,9),(2923,5,34,1,9),(2924,5,34,2,9),(2925,3,34,5,9),(2926,3,34,7,9),(2927,3,34,8,9),(2928,3,34,9,9),(2929,3,34,10,9),(2930,3,34,11,9),(2931,0,34,17,9),(2932,6,34,19,9),(2933,6,34,20,9),(2934,6,34,21,9),(2935,4,34,44,9),(2936,4,34,45,9),(2937,5,34,0,10),(2938,5,34,1,10),(2939,3,34,5,10),(2940,3,34,6,10),(2941,3,34,7,10),(2942,3,34,8,10),(2943,3,34,9,10),(2944,3,34,10,10),(2945,3,34,11,10),(2946,6,34,21,10),(2947,5,34,1,11),(2948,3,34,6,11),(2949,3,34,7,11),(2950,3,34,8,11),(2951,3,34,9,11),(2952,3,34,10,11),(2953,4,34,45,11),(2954,2,34,51,11),(2955,3,34,7,12),(2956,3,34,9,12),(2957,3,34,10,12),(2958,3,34,11,12),(2959,12,34,34,12),(2960,4,34,44,12),(2961,4,34,45,12),(2962,4,34,46,12),(2963,4,34,47,12),(2964,4,34,48,12),(2965,4,34,49,12),(2966,4,34,50,12),(2967,3,34,6,13),(2968,3,34,7,13),(2969,3,34,10,13),(2970,3,34,11,13),(2971,4,34,44,13),(2972,4,34,45,13),(2973,4,34,46,13),(2974,4,34,47,13),(2975,4,34,48,13),(2976,3,34,2,14),(2977,3,34,10,14),(2978,6,34,14,14),(2979,6,34,15,14),(2980,4,34,45,14),(2981,4,34,46,14),(2982,4,34,47,14),(2983,4,34,48,14),(2984,4,34,49,14),(2985,4,34,50,14),(2986,3,34,1,15),(2987,3,34,2,15),(2988,3,34,10,15),(2989,3,34,11,15),(2990,6,34,13,15),(2991,6,34,14,15),(2992,6,34,15,15),(2993,6,34,16,15),(2994,0,34,22,15),(2995,9,34,42,15),(2996,4,34,46,15),(2997,4,34,47,15),(2998,4,34,48,15),(2999,4,34,49,15),(3000,4,34,50,15),(3001,3,34,0,16),(3002,3,34,1,16),(3003,3,34,2,16),(3004,6,34,13,16),(3005,6,34,14,16),(3006,6,34,15,16),(3007,6,34,16,16),(3008,4,34,48,16),(3009,4,34,49,16),(3010,4,34,50,16),(3011,4,34,51,16),(3012,4,34,52,16),(3013,3,34,2,17),(3014,12,34,10,17),(3015,6,34,16,17),(3016,4,34,32,17),(3017,5,34,41,17),(3018,4,34,47,17),(3019,4,34,48,17),(3020,4,34,51,17),(3021,5,34,53,17),(3022,3,34,1,18),(3023,3,34,2,18),(3024,3,34,3,18),(3025,4,34,32,18),(3026,4,34,34,18),(3027,4,34,35,18),(3028,4,34,36,18),(3029,4,34,37,18),(3030,6,34,38,18),(3031,5,34,39,18),(3032,5,34,40,18),(3033,5,34,41,18),(3034,5,34,42,18),(3035,5,34,43,18),(3036,5,34,44,18),(3037,5,34,45,18),(3038,5,34,46,18),(3039,4,34,47,18),(3040,4,34,48,18),(3041,5,34,50,18),(3042,5,34,52,18),(3043,5,34,53,18),(3044,3,34,3,19),(3045,3,34,4,19),(3046,3,34,5,19),(3047,14,34,7,19),(3048,10,34,26,19),(3049,4,34,31,19),(3050,4,34,32,19),(3051,4,34,33,19),(3052,4,34,34,19),(3053,4,34,35,19),(3054,6,34,36,19),(3055,6,34,37,19),(3056,6,34,38,19),(3057,5,34,39,19),(3058,5,34,40,19),(3059,5,34,41,19),(3060,5,34,42,19),(3061,5,34,44,19),(3062,5,34,45,19),(3063,7,34,46,19),(3064,4,34,47,19),(3065,4,34,48,19),(3066,5,34,49,19),(3067,5,34,50,19),(3068,5,34,51,19),(3069,5,34,52,19),(3070,3,34,2,20),(3071,3,34,3,20),(3072,1,34,4,20),(3073,4,34,32,20),(3074,4,34,33,20),(3075,4,34,34,20),(3076,4,34,35,20),(3077,4,34,36,20),(3078,6,34,37,20),(3079,4,34,38,20),(3080,4,34,39,20),(3081,4,34,40,20),(3082,5,34,41,20),(3083,5,34,42,20),(3084,7,34,44,20),(3085,7,34,45,20),(3086,7,34,46,20),(3087,5,34,47,20),(3088,5,34,48,20),(3089,5,34,49,20),(3090,7,34,50,20),(3091,5,34,51,20),(3092,5,34,52,20),(3093,3,34,1,21),(3094,3,34,2,21),(3095,3,34,3,21),(3096,4,34,33,21),(3097,4,34,34,21),(3098,4,34,36,21),(3099,6,34,37,21),(3100,4,34,38,21),(3101,4,34,39,21),(3102,5,34,42,21),(3103,7,34,43,21),(3104,7,34,44,21),(3105,7,34,46,21),(3106,7,34,47,21),(3107,7,34,48,21),(3108,7,34,49,21),(3109,7,34,50,21),(3110,7,34,51,21),(3111,5,34,52,21),(3112,3,34,0,22),(3113,3,34,1,22),(3114,3,34,2,22),(3115,3,34,3,22),(3116,3,34,4,22),(3117,3,34,5,22),(3118,3,34,6,22),(3119,4,34,33,22),(3120,4,34,34,22),(3121,4,34,35,22),(3122,4,34,36,22),(3123,4,34,37,22),(3124,4,34,38,22),(3125,4,34,39,22),(3126,4,34,40,22),(3127,7,34,44,22),(3128,7,34,45,22),(3129,7,34,46,22),(3130,7,34,47,22),(3131,7,34,48,22),(3132,7,34,49,22),(3133,7,34,50,22),(3134,7,34,51,22),(3135,5,34,52,22),(3136,5,34,53,22),(3137,3,34,1,23),(3138,3,34,2,23),(3139,3,34,3,23),(3140,3,34,4,23),(3141,3,34,5,23),(3142,3,34,6,23),(3143,4,34,35,23),(3144,4,34,36,23),(3145,4,34,37,23),(3146,4,34,38,23),(3147,7,34,43,23),(3148,7,34,44,23),(3149,7,34,45,23),(3150,7,34,46,23),(3151,7,34,47,23),(3152,7,34,48,23),(3153,7,34,49,23),(3154,7,34,50,23),(3155,7,34,51,23),(3156,7,34,52,23),(3157,7,34,53,23),(3158,3,36,13,0),(3159,5,36,28,0),(3160,5,36,29,0),(3161,5,36,30,0),(3162,5,36,31,0),(3163,5,36,32,0),(3164,5,36,33,0),(3165,5,36,34,0),(3166,5,36,35,0),(3167,11,36,3,1),(3168,3,36,13,1),(3169,5,36,28,1),(3170,5,36,30,1),(3171,5,36,31,1),(3172,5,36,32,1),(3173,5,36,33,1),(3174,14,36,40,1),(3175,3,36,11,2),(3176,3,36,12,2),(3177,3,36,13,2),(3178,5,36,27,2),(3179,5,36,28,2),(3180,5,36,29,2),(3181,5,36,30,2),(3182,5,36,31,2),(3183,5,36,32,2),(3184,3,36,11,3),(3185,3,36,12,3),(3186,3,36,13,3),(3187,6,36,19,3),(3188,5,36,31,3),(3189,0,36,34,3),(3190,3,36,10,4),(3191,3,36,11,4),(3192,3,36,12,4),(3193,3,36,13,4),(3194,6,36,19,4),(3195,0,36,24,4),(3196,9,36,29,4),(3197,4,36,45,4),(3198,3,36,10,5),(3199,3,36,11,5),(3200,3,36,12,5),(3201,3,36,13,5),(3202,3,36,14,5),(3203,6,36,19,5),(3204,6,36,20,5),(3205,4,36,44,5),(3206,4,36,45,5),(3207,4,36,46,5),(3208,3,36,9,6),(3209,3,36,10,6),(3210,3,36,11,6),(3211,3,36,12,6),(3212,3,36,13,6),(3213,3,36,14,6),(3214,6,36,18,6),(3215,6,36,19,6),(3216,6,36,20,6),(3217,6,36,21,6),(3218,6,36,22,6),(3219,4,36,45,6),(3220,4,36,46,6),(3221,12,36,2,7),(3222,3,36,8,7),(3223,3,36,9,7),(3224,3,36,10,7),(3225,3,36,11,7),(3226,3,36,12,7),(3227,3,36,13,7),(3228,3,36,14,7),(3229,6,36,20,7),(3230,6,36,21,7),(3231,13,36,29,7),(3232,7,36,35,7),(3233,7,36,36,7),(3234,7,36,37,7),(3235,7,36,38,7),(3236,4,36,42,7),(3237,4,36,43,7),(3238,4,36,44,7),(3239,4,36,45,7),(3240,4,36,46,7),(3241,0,36,0,8),(3242,0,36,10,8),(3243,3,36,12,8),(3244,3,36,13,8),(3245,3,36,14,8),(3246,3,36,15,8),(3247,0,36,19,8),(3248,7,36,35,8),(3249,7,36,36,8),(3250,7,36,37,8),(3251,4,36,41,8),(3252,4,36,42,8),(3253,4,36,43,8),(3254,4,36,44,8),(3255,4,36,45,8),(3256,3,36,13,9),(3257,3,36,29,9),(3258,7,36,30,9),(3259,7,36,31,9),(3260,7,36,32,9),(3261,7,36,33,9),(3262,7,36,34,9),(3263,7,36,35,9),(3264,7,36,36,9),(3265,6,36,37,9),(3266,6,36,38,9),(3267,6,36,39,9),(3268,7,36,41,9),(3269,7,36,42,9),(3270,4,36,43,9),(3271,7,36,44,9),(3272,7,36,46,9),(3273,5,36,0,10),(3274,5,36,1,10),(3275,10,36,11,10),(3276,3,36,29,10),(3277,3,36,30,10),(3278,7,36,31,10),(3279,7,36,32,10),(3280,7,36,33,10),(3281,7,36,34,10),(3282,7,36,35,10),(3283,6,36,36,10),(3284,6,36,37,10),(3285,6,36,38,10),(3286,6,36,39,10),(3287,6,36,41,10),(3288,7,36,42,10),(3289,7,36,43,10),(3290,7,36,44,10),(3291,7,36,45,10),(3292,7,36,46,10),(3293,5,36,0,11),(3294,5,36,1,11),(3295,1,36,19,11),(3296,3,36,28,11),(3297,3,36,29,11),(3298,3,36,30,11),(3299,7,36,31,11),(3300,7,36,32,11),(3301,7,36,33,11),(3302,7,36,34,11),(3303,3,36,35,11),(3304,6,36,36,11),(3305,6,36,37,11),(3306,6,36,38,11),(3307,6,36,39,11),(3308,6,36,40,11),(3309,6,36,41,11),(3310,7,36,42,11),(3311,7,36,43,11),(3312,7,36,44,11),(3313,7,36,45,11),(3314,7,36,46,11),(3315,5,36,0,12),(3316,5,36,1,12),(3317,3,36,29,12),(3318,3,36,30,12),(3319,3,36,31,12),(3320,3,36,32,12),(3321,3,36,33,12),(3322,3,36,34,12),(3323,3,36,35,12),(3324,6,36,36,12),(3325,6,36,37,12),(3326,6,36,38,12),(3327,6,36,39,12),(3328,6,36,40,12),(3329,6,36,41,12),(3330,7,36,42,12),(3331,7,36,43,12),(3332,7,36,44,12),(3333,7,36,46,12),(3334,5,36,0,13),(3335,5,36,1,13),(3336,5,36,2,13),(3337,5,36,3,13),(3338,3,36,7,13),(3339,5,36,15,13),(3340,0,36,18,13),(3341,0,36,22,13),(3342,3,36,29,13),(3343,3,36,30,13),(3344,3,36,31,13),(3345,3,36,32,13),(3346,3,36,33,13),(3347,3,36,34,13),(3348,3,36,35,13),(3349,3,36,36,13),(3350,3,36,37,13),(3351,6,36,38,13),(3352,6,36,39,13),(3353,9,36,40,13),(3354,7,36,44,13),(3355,7,36,45,13),(3356,7,36,46,13),(3357,0,36,0,14),(3358,5,36,2,14),(3359,5,36,3,14),(3360,5,36,4,14),(3361,3,36,5,14),(3362,3,36,6,14),(3363,3,36,7,14),(3364,3,36,8,14),(3365,3,36,9,14),(3366,3,36,10,14),(3367,5,36,13,14),(3368,5,36,14,14),(3369,5,36,15,14),(3370,5,36,16,14),(3371,5,36,17,14),(3372,6,36,25,14),(3373,6,36,26,14),(3374,6,36,27,14),(3375,6,36,28,14),(3376,3,36,29,14),(3377,3,36,30,14),(3378,3,36,31,14),(3379,3,36,32,14),(3380,3,36,33,14),(3381,3,36,34,14),(3382,3,36,35,14),(3383,3,36,36,14),(3384,4,36,38,14),(3385,4,36,39,14),(3386,7,36,45,14),(3387,7,36,46,14),(3388,5,36,2,15),(3389,3,36,4,15),(3390,3,36,6,15),(3391,3,36,7,15),(3392,3,36,8,15),(3393,3,36,9,15),(3394,3,36,10,15),(3395,3,36,11,15),(3396,3,36,12,15),(3397,5,36,13,15),(3398,5,36,14,15),(3399,5,36,15,15),(3400,5,36,16,15),(3401,5,36,17,15),(3402,6,36,25,15),(3403,6,36,27,15),(3404,4,36,29,15),(3405,3,36,31,15),(3406,3,36,35,15),(3407,4,36,39,15),(3408,7,36,45,15),(3409,5,36,0,16),(3410,5,36,1,16),(3411,5,36,2,16),(3412,3,36,3,16),(3413,3,36,4,16),(3414,3,36,5,16),(3415,3,36,6,16),(3416,3,36,7,16),(3417,3,36,8,16),(3418,3,36,9,16),(3419,3,36,10,16),(3420,3,36,11,16),(3421,3,36,12,16),(3422,5,36,13,16),(3423,5,36,14,16),(3424,5,36,15,16),(3425,5,36,16,16),(3426,5,36,17,16),(3427,5,36,18,16),(3428,14,36,19,16),(3429,4,36,28,16),(3430,4,36,29,16),(3431,4,36,30,16),(3432,4,36,31,16),(3433,4,36,39,16),(3434,4,36,41,16),(3435,4,36,42,16),(3436,4,36,45,16),(3437,5,36,0,17),(3438,5,36,1,17),(3439,3,36,6,17),(3440,3,36,7,17),(3441,3,36,8,17),(3442,3,36,9,17),(3443,12,36,11,17),(3444,5,36,17,17),(3445,5,36,18,17),(3446,2,36,25,17),(3447,4,36,29,17),(3448,4,36,30,17),(3449,4,36,38,17),(3450,4,36,39,17),(3451,4,36,40,17),(3452,4,36,41,17),(3453,4,36,42,17),(3454,4,36,44,17),(3455,4,36,45,17),(3456,4,36,46,17),(3457,5,36,1,18),(3458,3,36,6,18),(3459,3,36,7,18),(3460,3,36,8,18),(3461,3,36,9,18),(3462,3,36,10,18),(3463,5,36,18,18),(3464,4,36,30,18),(3465,4,36,31,18),(3466,4,36,32,18),(3467,4,36,33,18),(3468,4,36,38,18),(3469,4,36,39,18),(3470,4,36,41,18),(3471,4,36,42,18),(3472,4,36,43,18),(3473,4,36,44,18),(3474,4,36,45,18),(3475,4,36,46,18),(3476,3,36,9,19),(3477,4,36,29,19),(3478,4,36,30,19),(3479,4,36,31,19),(3480,5,36,35,19),(3481,6,36,38,19),(3482,6,36,39,19),(3483,4,36,40,19),(3484,4,36,41,19),(3485,6,36,42,19),(3486,4,36,43,19),(3487,4,36,44,19),(3488,4,36,45,19),(3489,4,36,46,19),(3490,8,36,25,20),(3491,4,36,29,20),(3492,4,36,30,20),(3493,5,36,35,20),(3494,5,36,36,20),(3495,6,36,39,20),(3496,6,36,40,20),(3497,6,36,41,20),(3498,6,36,42,20),(3499,4,36,43,20),(3500,4,36,44,20),(3501,4,36,45,20),(3502,13,36,3,21),(3503,4,36,29,21),(3504,5,36,34,21),(3505,5,36,35,21),(3506,5,36,36,21),(3507,6,36,39,21),(3508,6,36,40,21),(3509,6,36,41,21),(3510,6,36,42,21),(3511,4,36,43,21),(3512,5,36,33,22),(3513,5,36,34,22),(3514,5,36,36,22),(3515,5,36,37,22),(3516,5,36,38,22),(3517,5,36,39,22),(3518,6,36,40,22),(3519,6,36,41,22),(3520,4,36,43,22),(3521,5,36,35,23),(3522,5,36,36,23),(3523,5,36,37,23),(3524,5,36,38,23),(3525,5,36,39,23),(3526,6,36,40,23),(3527,3,41,2,0),(3528,3,41,7,0),(3529,6,41,10,0),(3530,6,41,12,0),(3531,5,41,17,0),(3532,5,41,18,0),(3533,3,41,34,0),(3534,3,41,1,1),(3535,3,41,2,1),(3536,3,41,7,1),(3537,6,41,8,1),(3538,6,41,9,1),(3539,6,41,10,1),(3540,6,41,11,1),(3541,6,41,12,1),(3542,5,41,18,1),(3543,3,41,34,1),(3544,3,41,0,2),(3545,3,41,1,2),(3546,3,41,2,2),(3547,3,41,3,2),(3548,3,41,4,2),(3549,3,41,5,2),(3550,3,41,7,2),(3551,6,41,10,2),(3552,6,41,11,2),(3553,5,41,18,2),(3554,5,41,19,2),(3555,3,41,33,2),(3556,3,41,34,2),(3557,3,41,2,3),(3558,3,41,3,3),(3559,3,41,4,3),(3560,3,41,6,3),(3561,3,41,7,3),(3562,5,41,8,3),(3563,12,41,10,3),(3564,5,41,19,3),(3565,5,41,20,3),(3566,5,41,21,3),(3567,5,41,22,3),(3568,5,41,23,3),(3569,13,41,24,3),(3570,3,41,32,3),(3571,3,41,33,3),(3572,3,41,34,3),(3573,3,41,2,4),(3574,0,41,3,4),(3575,3,41,5,4),(3576,3,41,6,4),(3577,3,41,7,4),(3578,5,41,8,4),(3579,5,41,9,4),(3580,1,41,19,4),(3581,3,41,32,4),(3582,3,41,33,4),(3583,3,41,34,4),(3584,3,41,5,5),(3585,3,41,6,5),(3586,3,41,7,5),(3587,5,41,8,5),(3588,4,41,16,5),(3589,4,41,17,5),(3590,9,41,22,5),(3591,3,41,33,5),(3592,3,41,34,5),(3593,7,41,1,6),(3594,7,41,3,6),(3595,7,41,4,6),(3596,3,41,5,6),(3597,3,41,6,6),(3598,5,41,7,6),(3599,5,41,8,6),(3600,5,41,9,6),(3601,4,41,16,6),(3602,4,41,17,6),(3603,4,41,20,6),(3604,12,41,28,6),(3605,3,41,34,6),(3606,7,41,0,7),(3607,7,41,1,7),(3608,7,41,2,7),(3609,7,41,3,7),(3610,7,41,4,7),(3611,7,41,5,7),(3612,7,41,6,7),(3613,5,41,8,7),(3614,4,41,16,7),(3615,4,41,17,7),(3616,4,41,18,7),(3617,4,41,19,7),(3618,4,41,20,7),(3619,6,41,21,7),(3620,7,41,2,8),(3621,7,41,3,8),(3622,7,41,4,8),(3623,7,41,5,8),(3624,7,41,6,8),(3625,7,41,7,8),(3626,5,41,8,8),(3627,4,41,16,8),(3628,4,41,17,8),(3629,4,41,19,8),(3630,4,41,20,8),(3631,6,41,21,8),(3632,6,41,22,8),(3633,6,41,23,8),(3634,0,41,24,8),(3635,7,41,2,9),(3636,7,41,4,9),(3637,7,41,5,9),(3638,7,41,7,9),(3639,0,41,14,9),(3640,4,41,16,9),(3641,4,41,17,9),(3642,4,41,18,9),(3643,6,41,21,9),(3644,6,41,22,9),(3645,0,41,4,10),(3646,4,41,16,10),(3647,6,41,17,10),(3648,6,41,18,10),(3649,6,41,19,10),(3650,6,41,20,10),(3651,6,41,21,10),(3652,6,41,22,10),(3653,13,41,8,11),(3654,9,41,14,11),(3655,6,41,18,11),(3656,6,41,19,11),(3657,6,41,22,11),(3658,0,41,5,12),(3659,6,41,18,12),(3660,6,41,19,12),(3661,6,41,20,12),(3662,6,41,21,12),(3663,6,41,22,12),(3664,11,41,27,12),(3665,3,41,0,13),(3666,3,41,1,13),(3667,2,41,10,13),(3668,11,41,18,13),(3669,8,41,22,13),(3670,3,41,0,14),(3671,3,41,1,14),(3672,3,41,2,14),(3673,3,41,3,14),(3674,3,41,4,14),(3675,4,41,7,14),(3676,3,41,0,15),(3677,3,41,1,15),(3678,3,41,2,15),(3679,3,41,3,15),(3680,4,41,5,15),(3681,4,41,6,15),(3682,4,41,7,15),(3683,14,41,11,15),(3684,10,41,14,15),(3685,3,41,0,16),(3686,4,41,4,16),(3687,4,41,5,16),(3688,4,41,6,16),(3689,4,41,7,16),(3690,4,41,8,16),(3691,4,41,10,16),(3692,4,41,25,16),(3693,3,41,0,17),(3694,4,41,5,17),(3695,4,41,6,17),(3696,4,41,8,17),(3697,4,41,9,17),(3698,4,41,10,17),(3699,4,41,24,17),(3700,4,41,25,17),(3701,4,41,26,17),(3702,4,41,6,18),(3703,4,41,9,18),(3704,4,41,10,18),(3705,4,41,25,18),(3706,4,41,26,18),(3707,4,41,28,18),(3708,4,41,29,18),(3709,4,41,30,18),(3710,4,41,31,18),(3711,4,41,32,18),(3712,5,41,14,19),(3713,5,41,15,19),(3714,5,41,16,19),(3715,5,41,17,19),(3716,5,41,18,19),(3717,5,41,19,19),(3718,5,41,20,19),(3719,5,41,21,19),(3720,5,41,22,19),(3721,5,41,23,19),(3722,4,41,26,19),(3723,4,41,27,19),(3724,4,41,28,19),(3725,4,41,29,19),(3726,4,41,30,19),(3727,4,41,31,19),(3728,4,41,32,19),(3729,5,38,0,0),(3730,5,38,1,0),(3731,5,38,2,0),(3732,5,38,3,0),(3733,5,38,16,0),(3734,5,38,17,0),(3735,5,38,18,0),(3736,5,38,19,0),(3737,5,38,20,0),(3738,5,38,21,0),(3739,5,38,22,0),(3740,5,38,23,0),(3741,5,38,24,0),(3742,5,38,25,0),(3743,5,38,26,0),(3744,5,38,0,1),(3745,5,38,1,1),(3746,5,38,2,1),(3747,5,38,3,1),(3748,5,38,4,1),(3749,12,38,7,1),(3750,5,38,17,1),(3751,5,38,18,1),(3752,5,38,20,1),(3753,14,38,22,1),(3754,5,38,26,1),(3755,5,38,28,1),(3756,5,38,0,2),(3757,5,38,1,2),(3758,5,38,2,2),(3759,5,38,4,2),(3760,5,38,5,2),(3761,5,38,25,2),(3762,5,38,26,2),(3763,5,38,28,2),(3764,5,38,29,2),(3765,5,38,0,3),(3766,5,38,1,3),(3767,5,38,4,3),(3768,5,38,5,3),(3769,5,38,28,3),(3770,6,38,29,3),(3771,5,38,28,4),(3772,6,38,29,4),(3773,4,38,3,5),(3774,4,38,5,5),(3775,0,38,18,5),(3776,6,38,27,5),(3777,6,38,28,5),(3778,6,38,29,5),(3779,4,38,2,6),(3780,4,38,3,6),(3781,4,38,4,6),(3782,4,38,5,6),(3783,6,38,26,6),(3784,6,38,27,6),(3785,6,38,28,6),(3786,6,38,29,6),(3787,4,38,1,7),(3788,4,38,2,7),(3789,4,38,3,7),(3790,4,38,4,7),(3791,4,38,5,7),(3792,6,38,26,7),(3793,5,38,27,7),(3794,5,38,28,7),(3795,5,38,29,7),(3796,4,38,1,8),(3797,4,38,2,8),(3798,4,38,3,8),(3799,4,38,4,8),(3800,0,38,10,8),(3801,5,38,27,8),(3802,5,38,28,8),(3803,5,38,29,8),(3804,4,38,1,9),(3805,4,38,2,9),(3806,4,38,3,9),(3807,5,38,29,9),(3808,4,38,1,10),(3809,6,38,5,10),(3810,6,38,6,10),(3811,5,38,28,10),(3812,5,38,29,10),(3813,6,38,4,11),(3814,6,38,5,11),(3815,6,38,6,11),(3816,6,38,7,11),(3817,6,38,8,11),(3818,5,38,27,11),(3819,5,38,28,11),(3820,5,38,29,11),(3821,13,38,1,12),(3822,6,38,8,12),(3823,6,38,9,12),(3824,6,38,10,12),(3825,5,38,27,12),(3826,5,38,28,12),(3827,5,38,29,12),(3828,6,38,8,13),(3829,6,38,9,13),(3830,6,38,10,13),(3831,5,38,28,13),(3832,5,38,29,13),(3833,5,38,2,14),(3834,6,38,9,14),(3835,5,38,28,14),(3836,5,38,0,15),(3837,5,38,2,15),(3838,5,38,3,15),(3839,5,38,0,16),(3840,5,38,1,16),(3841,5,38,2,16),(3842,5,38,3,16),(3843,5,38,4,16),(3844,2,38,26,16),(3845,5,38,0,17),(3846,5,38,1,17),(3847,5,38,2,17),(3848,5,38,3,17),(3849,5,38,4,17),(3850,5,38,0,18),(3851,5,38,1,18),(3852,5,38,3,18),(3853,6,38,6,18),(3854,4,38,24,18),(3855,4,38,29,18),(3856,5,38,0,19),(3857,5,38,2,19),(3858,5,38,3,19),(3859,6,38,7,19),(3860,6,38,8,19),(3861,4,38,24,19),(3862,4,38,25,19),(3863,4,38,26,19),(3864,4,38,27,19),(3865,4,38,28,19),(3866,4,38,29,19),(3867,5,38,0,20),(3868,11,38,1,20),(3869,6,38,5,20),(3870,6,38,6,20),(3871,6,38,7,20),(3872,6,38,8,20),(3873,6,38,9,20),(3874,4,38,23,20),(3875,4,38,24,20),(3876,4,38,25,20),(3877,4,38,26,20),(3878,4,38,27,20),(3879,4,38,28,20),(3880,4,38,29,20),(3881,5,38,0,21),(3882,6,38,5,21),(3883,6,38,6,21),(3884,4,38,24,21),(3885,4,38,25,21),(3886,4,38,26,21),(3887,4,38,27,21),(3888,4,38,28,21),(3889,4,38,29,21),(3890,5,38,0,22),(3891,6,38,6,22),(3892,8,38,10,22),(3893,4,38,24,22),(3894,4,38,25,22),(3895,4,38,26,22),(3896,4,38,27,22),(3897,4,38,28,22),(3898,4,38,29,22),(3899,5,38,0,23),(3900,4,38,26,23),(3901,4,38,27,23),(3902,4,38,28,23),(3903,5,38,0,24),(3904,3,38,18,24),(3905,3,38,19,24),(3906,3,38,20,24),(3907,0,38,24,24),(3908,4,38,27,24),(3909,0,38,28,24),(3910,5,38,0,25),(3911,3,38,9,25),(3912,3,38,10,25),(3913,3,38,13,25),(3914,3,38,14,25),(3915,3,38,15,25),(3916,3,38,17,25),(3917,3,38,18,25),(3918,3,38,19,25),(3919,3,38,20,25),(3920,3,38,21,25),(3921,5,38,0,26),(3922,5,38,1,26),(3923,5,38,2,26),(3924,3,38,9,26),(3925,3,38,10,26),(3926,3,38,11,26),(3927,3,38,14,26),(3928,3,38,15,26),(3929,3,38,16,26),(3930,3,38,17,26),(3931,3,38,18,26),(3932,3,38,19,26),(3933,3,38,20,26),(3934,3,38,21,26),(3935,3,38,23,26),(3936,5,38,2,27),(3937,0,38,3,27),(3938,3,38,10,27),(3939,3,38,11,27),(3940,3,38,12,27),(3941,3,38,13,27),(3942,3,38,14,27),(3943,3,38,15,27),(3944,3,38,16,27),(3945,3,38,17,27),(3946,3,38,18,27),(3947,3,38,19,27),(3948,3,38,20,27),(3949,3,38,21,27),(3950,3,38,22,27),(3951,3,38,23,27),(3952,3,38,24,27),(3953,0,38,0,28),(3954,3,38,11,28),(3955,3,38,12,28),(3956,3,38,13,28),(3957,3,38,14,28),(3958,3,38,15,28),(3959,3,38,16,28),(3960,3,38,17,28),(3961,3,38,18,28),(3962,3,38,19,28),(3963,3,38,20,28),(3964,3,38,21,28),(3965,3,38,22,28),(3966,3,38,23,28),(3967,3,38,24,28),(3968,3,38,10,29),(3969,3,38,11,29),(3970,3,38,12,29),(3971,3,38,13,29),(3972,3,38,14,29),(3973,3,38,15,29),(3974,3,38,16,29),(3975,3,38,17,29),(3976,3,38,18,29),(3977,3,38,19,29),(3978,3,38,20,29),(3979,3,38,21,29),(3980,3,38,22,29),(3981,3,38,23,29);
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
INSERT INTO `units` VALUES (1,100,1,38,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,18,28,NULL,1,0,0),(2,100,1,38,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,18,28,NULL,1,0,0),(3,100,1,38,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,18,28,NULL,1,0,0),(4,100,1,38,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,18,28,NULL,1,0,0),(5,100,1,38,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,18,28,NULL,1,0,0),(6,200,1,38,4,NULL,NULL,NULL,NULL,0,0,'Glancer',0,18,28,NULL,1,0,0),(7,200,1,38,4,NULL,NULL,NULL,NULL,0,0,'Glancer',0,18,28,NULL,1,0,0),(8,200,1,38,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,18,28,NULL,1,0,0),(9,200,1,38,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,18,28,NULL,1,0,0),(10,100,1,38,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,18,28,NULL,1,0,0),(11,100,1,38,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,18,28,NULL,1,0,0),(12,100,1,38,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,18,28,NULL,1,0,0),(13,100,1,38,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,26,16,NULL,1,0,0),(14,100,1,38,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,26,16,NULL,1,0,0),(15,100,1,38,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,26,16,NULL,1,0,0),(16,100,1,38,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,26,16,NULL,1,0,0),(17,100,1,38,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,26,16,NULL,1,0,0),(18,200,1,38,4,NULL,NULL,NULL,NULL,0,0,'Glancer',0,26,16,NULL,1,0,0),(19,200,1,38,4,NULL,NULL,NULL,NULL,0,0,'Glancer',0,26,16,NULL,1,0,0),(20,200,1,38,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,26,16,NULL,1,0,0),(21,200,1,38,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,26,16,NULL,1,0,0),(22,100,1,38,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,26,16,NULL,1,0,0),(23,100,1,38,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,26,16,NULL,1,0,0),(24,100,1,38,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,26,16,NULL,1,0,0),(25,100,1,38,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,3,27,NULL,1,0,0),(26,100,1,38,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,3,27,NULL,1,0,0),(27,100,1,38,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,3,27,NULL,1,0,0),(28,100,1,38,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,3,27,NULL,1,0,0),(29,100,1,38,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,3,27,NULL,1,0,0),(30,200,1,38,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,3,27,NULL,1,0,0),(31,200,1,38,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,3,27,NULL,1,0,0),(32,100,1,38,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,28,24,NULL,1,0,0),(33,100,1,38,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,28,24,NULL,1,0,0),(34,100,1,38,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,28,24,NULL,1,0,0),(35,100,1,38,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,28,24,NULL,1,0,0),(36,100,1,38,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,28,24,NULL,1,0,0),(37,200,1,38,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,28,24,NULL,1,0,0),(38,200,1,38,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,28,24,NULL,1,0,0),(39,100,1,38,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,18,25,NULL,1,0,0),(40,100,1,38,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,18,25,NULL,1,0,0),(41,100,1,38,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,18,25,NULL,1,0,0),(42,100,1,38,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,18,25,NULL,1,0,0),(43,100,1,38,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,18,25,NULL,1,0,0),(44,200,1,38,4,NULL,NULL,NULL,NULL,0,0,'Glancer',0,18,25,NULL,1,0,0),(45,200,1,38,4,NULL,NULL,NULL,NULL,0,0,'Glancer',0,18,25,NULL,1,0,0),(46,200,1,38,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,18,25,NULL,1,0,0),(47,200,1,38,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,18,25,NULL,1,0,0),(48,100,1,38,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,18,25,NULL,1,0,0),(49,100,1,38,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,18,25,NULL,1,0,0),(50,100,1,38,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,18,25,NULL,1,0,0),(51,100,1,38,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,15,26,NULL,1,0,0),(52,100,1,38,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,15,26,NULL,1,0,0),(53,100,1,38,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,15,26,NULL,1,0,0),(54,100,1,38,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,15,26,NULL,1,0,0),(55,100,1,38,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,15,26,NULL,1,0,0),(56,200,1,38,4,NULL,NULL,NULL,NULL,0,0,'Glancer',0,15,26,NULL,1,0,0),(57,200,1,38,4,NULL,NULL,NULL,NULL,0,0,'Glancer',0,15,26,NULL,1,0,0),(58,200,1,38,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,15,26,NULL,1,0,0),(59,200,1,38,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,15,26,NULL,1,0,0),(60,100,1,38,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,15,26,NULL,1,0,0),(61,100,1,38,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,15,26,NULL,1,0,0),(62,100,1,38,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,15,26,NULL,1,0,0),(63,100,1,38,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,7,28,NULL,1,0,0),(64,100,1,38,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,7,28,NULL,1,0,0),(65,100,1,38,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,7,28,NULL,1,0,0),(66,100,1,38,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,7,28,NULL,1,0,0),(67,100,1,38,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,7,28,NULL,1,0,0),(68,200,1,38,4,NULL,NULL,NULL,NULL,0,0,'Glancer',0,7,28,NULL,1,0,0),(69,200,1,38,4,NULL,NULL,NULL,NULL,0,0,'Glancer',0,7,28,NULL,1,0,0),(70,200,1,38,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,7,28,NULL,1,0,0),(71,200,1,38,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,7,28,NULL,1,0,0),(72,100,1,38,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,7,28,NULL,1,0,0),(73,100,1,38,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,7,28,NULL,1,0,0),(74,100,1,38,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,7,28,NULL,1,0,0),(75,100,1,38,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,24,24,NULL,1,0,0),(76,100,1,38,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,24,24,NULL,1,0,0),(77,100,1,38,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,24,24,NULL,1,0,0),(78,100,1,38,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,24,24,NULL,1,0,0),(79,100,1,38,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,24,24,NULL,1,0,0),(80,200,1,38,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,24,24,NULL,1,0,0),(81,200,1,38,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,24,24,NULL,1,0,0),(82,100,1,38,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,0,28,NULL,1,0,0),(83,100,1,38,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,0,28,NULL,1,0,0),(84,100,1,38,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,0,28,NULL,1,0,0),(85,100,1,38,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,0,28,NULL,1,0,0),(86,100,1,38,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,0,28,NULL,1,0,0),(87,200,1,38,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,0,28,NULL,1,0,0),(88,200,1,38,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,0,28,NULL,1,0,0),(89,100,1,38,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,22,27,NULL,1,0,0),(90,100,1,38,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,22,27,NULL,1,0,0),(91,100,1,38,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,22,27,NULL,1,0,0),(92,100,1,38,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,22,27,NULL,1,0,0),(93,100,1,38,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,22,27,NULL,1,0,0),(94,200,1,38,4,NULL,NULL,NULL,NULL,0,0,'Glancer',0,22,27,NULL,1,0,0),(95,200,1,38,4,NULL,NULL,NULL,NULL,0,0,'Glancer',0,22,27,NULL,1,0,0),(96,200,1,38,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,22,27,NULL,1,0,0),(97,200,1,38,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,22,27,NULL,1,0,0),(98,100,1,38,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,22,27,NULL,1,0,0),(99,100,1,38,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,22,27,NULL,1,0,0),(100,100,1,38,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,22,27,NULL,1,0,0),(101,100,1,38,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,25,20,NULL,1,0,0),(102,100,1,38,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,25,20,NULL,1,0,0),(103,100,1,38,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,25,20,NULL,1,0,0),(104,100,1,38,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,25,20,NULL,1,0,0),(105,100,1,38,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,25,20,NULL,1,0,0),(106,200,1,38,4,NULL,NULL,NULL,NULL,0,0,'Glancer',0,25,20,NULL,1,0,0),(107,200,1,38,4,NULL,NULL,NULL,NULL,0,0,'Glancer',0,25,20,NULL,1,0,0),(108,200,1,38,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,25,20,NULL,1,0,0),(109,200,1,38,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,25,20,NULL,1,0,0),(110,100,1,38,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,25,20,NULL,1,0,0),(111,100,1,38,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,25,20,NULL,1,0,0),(112,100,1,38,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,25,20,NULL,1,0,0),(113,100,1,38,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,12,27,NULL,1,0,0),(114,100,1,38,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,12,27,NULL,1,0,0),(115,100,1,38,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,12,27,NULL,1,0,0),(116,100,1,38,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,12,27,NULL,1,0,0),(117,100,1,38,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,12,27,NULL,1,0,0),(118,200,1,38,4,NULL,NULL,NULL,NULL,0,0,'Glancer',0,12,27,NULL,1,0,0),(119,200,1,38,4,NULL,NULL,NULL,NULL,0,0,'Glancer',0,12,27,NULL,1,0,0),(120,200,1,38,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,12,27,NULL,1,0,0),(121,200,1,38,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,12,27,NULL,1,0,0),(122,100,1,38,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,12,27,NULL,1,0,0),(123,100,1,38,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,12,27,NULL,1,0,0),(124,100,1,38,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,12,27,NULL,1,0,0),(125,100,1,38,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,26,27,NULL,1,0,0),(126,100,1,38,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,26,27,NULL,1,0,0),(127,100,1,38,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,26,27,NULL,1,0,0),(128,100,1,38,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,26,27,NULL,1,0,0),(129,100,1,38,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,26,27,NULL,1,0,0),(130,200,1,38,4,NULL,NULL,NULL,NULL,0,0,'Glancer',0,26,27,NULL,1,0,0),(131,200,1,38,4,NULL,NULL,NULL,NULL,0,0,'Glancer',0,26,27,NULL,1,0,0),(132,200,1,38,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,26,27,NULL,1,0,0),(133,200,1,38,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,26,27,NULL,1,0,0),(134,100,1,38,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,26,27,NULL,1,0,0),(135,100,1,38,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,26,27,NULL,1,0,0),(136,100,1,38,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,26,27,NULL,1,0,0);
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

-- Dump completed on 2010-09-23 10:10:36
