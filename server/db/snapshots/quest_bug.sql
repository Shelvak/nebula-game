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
  `x` tinyint(2) unsigned NOT NULL,
  `y` tinyint(2) unsigned NOT NULL,
  `armor_mod` int(11) NOT NULL,
  `constructor_mod` int(11) NOT NULL,
  `energy_mod` int(11) NOT NULL,
  `level` tinyint(2) unsigned NOT NULL DEFAULT '0',
  `type` varchar(255) NOT NULL,
  `upgrade_ends_at` datetime DEFAULT NULL,
  `x_end` tinyint(2) unsigned NOT NULL,
  `y_end` tinyint(2) unsigned NOT NULL,
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
) ENGINE=InnoDB AUTO_INCREMENT=25 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `buildings`
--

LOCK TABLES `buildings` WRITE;
/*!40000 ALTER TABLE `buildings` DISABLE KEYS */;
INSERT INTO `buildings` VALUES (1,19,7,16,0,0,0,1,'Thunder',NULL,8,17,NULL,1,300,NULL,0,NULL,NULL,0),(2,19,21,16,0,0,0,1,'Thunder',NULL,22,17,NULL,1,300,NULL,0,NULL,NULL,0),(3,19,21,9,0,0,0,1,'Screamer',NULL,22,10,NULL,1,300,NULL,0,NULL,NULL,0),(4,19,18,28,0,0,0,1,'NpcSolarPlant',NULL,19,29,NULL,0,1000,NULL,0,NULL,NULL,0),(5,19,7,9,0,0,0,1,'Vulcan',NULL,8,10,NULL,1,300,NULL,0,NULL,NULL,0),(6,19,14,22,0,0,0,1,'Thunder',NULL,15,23,NULL,1,300,NULL,0,NULL,NULL,0),(8,19,3,27,0,0,0,1,'NpcMetalExtractor',NULL,4,28,NULL,0,400,NULL,0,NULL,NULL,0),(9,19,28,24,0,0,0,1,'NpcMetalExtractor',NULL,29,25,NULL,0,400,NULL,0,NULL,NULL,0),(10,19,18,25,0,0,0,1,'NpcSolarPlant',NULL,19,26,NULL,0,1000,NULL,0,NULL,NULL,0),(11,19,15,26,0,0,0,1,'NpcSolarPlant',NULL,16,27,NULL,0,1000,NULL,0,NULL,NULL,0),(12,19,7,28,0,0,0,1,'NpcCommunicationsHub',NULL,9,29,NULL,0,1200,NULL,0,NULL,NULL,0),(13,19,21,22,0,0,0,1,'Vulcan',NULL,22,23,NULL,1,300,NULL,0,NULL,NULL,0),(14,19,24,24,0,0,0,1,'NpcMetalExtractor',NULL,25,25,NULL,0,400,NULL,0,NULL,NULL,0),(15,19,0,28,0,0,0,1,'NpcMetalExtractor',NULL,1,29,NULL,0,400,NULL,0,NULL,NULL,0),(16,19,11,14,0,0,0,1,'Mothership',NULL,18,19,NULL,1,10500,NULL,0,NULL,NULL,0),(17,19,22,27,0,0,0,1,'NpcSolarPlant',NULL,23,28,NULL,0,1000,NULL,0,NULL,NULL,0),(18,19,14,9,0,0,0,1,'Thunder',NULL,15,10,NULL,1,300,NULL,0,NULL,NULL,0),(19,19,25,20,0,0,0,1,'NpcTemple',NULL,27,22,NULL,0,1500,NULL,0,NULL,NULL,0),(20,19,12,27,0,0,0,1,'NpcSolarPlant',NULL,13,28,NULL,0,1000,NULL,0,NULL,NULL,0),(21,19,7,22,0,0,0,1,'Screamer',NULL,8,23,NULL,1,300,NULL,0,NULL,NULL,0),(22,19,26,27,0,0,0,1,'NpcCommunicationsHub',NULL,28,28,NULL,0,1200,NULL,0,NULL,NULL,0),(23,19,0,0,-18,0,0,1,'Barracks',NULL,2,2,NULL,1,300,NULL,0,NULL,NULL,0),(24,19,1,4,0,24,0,1,'ResearchCenter',NULL,4,7,NULL,1,5000,NULL,0,NULL,NULL,24);
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
INSERT INTO `combat_logs` VALUES ('5e685da79f35c0ce21fc7050c4bebeba9a0e9ed1','{\"location\":{\"type\":2,\"y\":0,\"variation\":0,\"x\":2,\"solar_system_id\":2,\"name\":\"G1-S2-P19\",\"id\":19},\"log\":[[\"tick\",\"start\"],[\"group\",[[\"fire\",[13,0],[[0,[147,0],false,6]]],[\"fire\",[146,0],[[0,[14,0],false,12]]],[\"fire\",[24,0],[[0,[147,0],false,6]]],[\"fire\",[140,0],[[0,[17,0],false,28]]]]],[\"group\",[[\"fire\",[16,0],[[0,[147,0],false,6]]],[\"fire\",[149,0],[[0,[16,0],false,38]]],[\"fire\",[23,0],[[0,[147,0],false,6]]],[\"fire\",[138,0],[[0,[15,0],false,28]]]]],[\"group\",[[\"fire\",[21,0],[[0,[137,0],false,45]]],[\"fire\",[137,0],[[0,[23,0],false,14]]],[\"fire\",[22,0],[[0,[142,0],false,6]]],[\"fire\",[148,0],[[0,[15,0],false,38]]]]],[\"group\",[[\"fire\",[20,0],[[0,[142,0],false,45]]],[\"fire\",[153,0],[[0,[21,0],false,56]]],[\"fire\",[19,0],[[0,[142,0],false,45]]],[\"fire\",[143,0],[[0,[19,0],false,9]]]]],[\"group\",[[\"fire\",[14,0],[[0,[143,0],false,6]]],[\"fire\",[145,0],[[0,[20,0],false,36]]],[\"fire\",[17,0],[[0,[143,0],false,6]]],[\"fire\",[152,0],[[0,[13,0],false,84]]]]],[\"group\",[[\"fire\",[15,0],[[0,[145,0],false,6]]],[\"fire\",[142,0],[[0,[23,0],false,14]]],[\"fire\",[18,0],[[0,[143,0],false,45]]],[\"fire\",[139,0],[[0,[17,0],false,28]]]]],[\"group\",[[\"fire\",[150,0],[[0,[17,0],false,38]]],[\"fire\",[144,0],[[0,[14,0],false,14]]]]],[\"group\",[[\"fire\",[147,0],[[0,[17,0],false,6]]],[\"fire\",[141,0],[[0,[21,0],false,9]]]]],[\"group\",[[\"fire\",[151,0],[[0,[19,0],false,56]]]]],[\"tick\",\"end\"],[\"tick\",\"start\"],[\"group\",[[\"fire\",[15,0],[[0,[142,0],false,4]]],[\"fire\",[147,0],[[0,[18,0],false,36]]],[\"fire\",[14,0],[[0,[147,0],false,6]]],[\"fire\",[139,0],[[0,[23,0],false,28]]]]],[\"group\",[[\"fire\",[16,0],[[0,[145,0],false,6]]],[\"fire\",[146,0],[[0,[16,0],false,12]]],[\"fire\",[24,0],[[0,[141,0],false,6]]],[\"fire\",[143,0],[[0,[15,0],false,14]]]]],[\"group\",[[\"fire\",[13,0],[[0,[150,0],false,11]]],[\"fire\",[148,0],[[0,[14,0],false,38]]],[\"fire\",[152,0],[[0,[23,0],false,44]]]]],[\"group\",[[\"fire\",[22,0],[[0,[146,0],false,6]]],[\"fire\",[151,0],[[0,[15,0],false,20]]],[\"fire\",[150,0],[[0,[24,0],false,38]]]]],[\"group\",[[\"fire\",[144,0],[[0,[13,0],false,14]]],[\"fire\",[145,0],[[0,[14,0],false,12]]]]],[\"group\",[[\"fire\",[140,0],[[0,[19,0],false,19]]],[\"fire\",[153,0],[[0,[21,0],false,56]]]]],[\"group\",[[\"fire\",[138,0],[[0,[24,0],false,28]]],[\"fire\",[149,0],[[0,[16,0],false,38]]]]],[\"group\",[[\"fire\",[141,0],[[0,[20,0],false,9]]],[\"fire\",[137,0],[[0,[14,0],false,14]]]]],[\"tick\",\"end\"],[\"tick\",\"start\"],[\"group\",[[\"fire\",[16,0],[[0,[145,0],false,6]]],[\"fire\",[152,0],[[0,[20,0],false,56]]],[\"fire\",[20,0],[[0,[146,0],false,45]]],[\"fire\",[140,0],[[0,[20,0],false,19]]]]],[\"group\",[[\"fire\",[14,0],[[0,[141,0],false,6]]],[\"fire\",[144,0],[[0,[14,0],false,10]]],[\"fire\",[24,0],[[0,[137,0],false,6]]],[\"fire\",[148,0],[[0,[16,0],false,12]]]]],[\"group\",[[\"fire\",[18,0],[[0,[146,0],false,45]]],[\"fire\",[138,0],[[0,[21,0],false,19]]],[\"fire\",[22,0],[[0,[138,0],false,11]]],[\"fire\",[139,0],[[0,[19,0],false,19]]]]],[\"group\",[[\"fire\",[21,0],[[0,[137,0],false,45]]],[\"fire\",[147,0],[[0,[13,0],false,2]]],[\"fire\",[19,0],[[0,[150,0],false,84]]],[\"fire\",[143,0],[[0,[19,0],false,9]]]]],[\"group\",[[\"fire\",[150,0],[[0,[19,0],false,88]]],[\"fire\",[151,0],[[0,[21,0],false,56]]]]],[\"group\",[[\"fire\",[146,0],[[0,[18,0],false,36]]],[\"fire\",[145,0],[[0,[18,0],false,36]]]]],[\"group\",[[\"fire\",[137,0],[[0,[18,0],false,9]]],[\"fire\",[149,0],[[0,[18,0],false,83]]]]],[\"group\",[[\"fire\",[153,0],[[0,[22,0],false,84]]],[\"fire\",[141,0],[[0,[20,0],false,9]]]]],[\"tick\",\"end\"],[\"tick\",\"start\"],[\"group\",[[\"fire\",[141,0],[[0,[21,0],false,4]]],[\"fire\",[138,0],[[0,[22,0],false,16]]]]],[\"group\",[[\"fire\",[24,0],[[0,[137,0],false,4]]],[\"fire\",[151,0],[[0,[24,0],false,34]]],[\"fire\",[137,0],[[0,[20,0],false,9]]]]],[\"group\",[[\"fire\",[143,0],[[0,[20,0],false,9]]],[\"fire\",[148,0],[[0,[20,0],false,53]]]]],[\"tick\",\"end\"]],\"alliances\":{\"-2\":{\"flanks\":{\"0\":[{\"type\":\"Gnat\",\"hp\":100,\"player_id\":null,\"level\":1,\"kind\":0,\"stance\":0,\"id\":13},{\"type\":\"Gnat\",\"hp\":100,\"player_id\":null,\"level\":1,\"kind\":0,\"stance\":0,\"id\":14},{\"type\":\"Gnat\",\"hp\":100,\"player_id\":null,\"level\":1,\"kind\":0,\"stance\":0,\"id\":15},{\"type\":\"Gnat\",\"hp\":100,\"player_id\":null,\"level\":1,\"kind\":0,\"stance\":0,\"id\":16},{\"type\":\"Gnat\",\"hp\":100,\"player_id\":null,\"level\":1,\"kind\":0,\"stance\":0,\"id\":17},{\"type\":\"Glancer\",\"hp\":200,\"player_id\":null,\"level\":1,\"kind\":0,\"stance\":0,\"id\":18},{\"type\":\"Glancer\",\"hp\":200,\"player_id\":null,\"level\":1,\"kind\":0,\"stance\":0,\"id\":19}],\"1\":[{\"type\":\"Glancer\",\"hp\":200,\"player_id\":null,\"level\":1,\"kind\":0,\"stance\":0,\"id\":20},{\"type\":\"Glancer\",\"hp\":200,\"player_id\":null,\"level\":1,\"kind\":0,\"stance\":0,\"id\":21},{\"type\":\"Gnat\",\"hp\":100,\"player_id\":null,\"level\":1,\"kind\":0,\"stance\":0,\"id\":22},{\"type\":\"Gnat\",\"hp\":100,\"player_id\":null,\"level\":1,\"kind\":0,\"stance\":0,\"id\":23},{\"type\":\"Gnat\",\"hp\":100,\"player_id\":null,\"level\":1,\"kind\":0,\"stance\":0,\"id\":24}]},\"players\":[{\"name\":null,\"id\":null}]},\"-1\":{\"flanks\":{\"0\":[{\"type\":\"Trooper\",\"hp\":100,\"player_id\":1,\"level\":1,\"kind\":0,\"stance\":1,\"id\":137},{\"type\":\"Trooper\",\"hp\":100,\"player_id\":1,\"level\":1,\"kind\":0,\"stance\":1,\"id\":141},{\"type\":\"Trooper\",\"hp\":100,\"player_id\":1,\"level\":1,\"kind\":0,\"stance\":1,\"id\":142},{\"type\":\"Trooper\",\"hp\":100,\"player_id\":1,\"level\":1,\"kind\":0,\"stance\":1,\"id\":143},{\"type\":\"Trooper\",\"hp\":100,\"player_id\":1,\"level\":1,\"kind\":0,\"stance\":1,\"id\":144},{\"type\":\"Shocker\",\"hp\":100,\"player_id\":1,\"level\":1,\"kind\":0,\"stance\":1,\"id\":145},{\"type\":\"Shocker\",\"hp\":100,\"player_id\":1,\"level\":1,\"kind\":0,\"stance\":1,\"id\":146},{\"type\":\"Shocker\",\"hp\":100,\"player_id\":1,\"level\":1,\"kind\":0,\"stance\":1,\"id\":147}],\"1\":[{\"type\":\"Trooper\",\"hp\":100,\"player_id\":1,\"level\":1,\"kind\":0,\"stance\":2,\"id\":138},{\"type\":\"Trooper\",\"hp\":100,\"player_id\":1,\"level\":1,\"kind\":0,\"stance\":2,\"id\":139},{\"type\":\"Trooper\",\"hp\":100,\"player_id\":1,\"level\":1,\"kind\":0,\"stance\":2,\"id\":140},{\"type\":\"Shocker\",\"hp\":100,\"player_id\":1,\"level\":3,\"kind\":0,\"stance\":2,\"id\":148},{\"type\":\"Shocker\",\"hp\":100,\"player_id\":1,\"level\":3,\"kind\":0,\"stance\":2,\"id\":149},{\"type\":\"Shocker\",\"hp\":100,\"player_id\":1,\"level\":3,\"kind\":0,\"stance\":2,\"id\":150},{\"type\":\"Seeker\",\"hp\":100,\"player_id\":1,\"level\":3,\"kind\":0,\"stance\":2,\"id\":151},{\"type\":\"Seeker\",\"hp\":100,\"player_id\":1,\"level\":3,\"kind\":0,\"stance\":2,\"id\":152},{\"type\":\"Seeker\",\"hp\":100,\"player_id\":1,\"level\":3,\"kind\":0,\"stance\":2,\"id\":153}]},\"players\":[{\"name\":\"Test Player\",\"id\":1}]}},\"nap_rules\":{}}','2010-10-15 18:00:00');
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
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8;
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
INSERT INTO `folliages` VALUES (14,0,8,9),(14,1,4,5),(14,1,19,10),(14,1,20,3),(14,2,4,5),(14,2,16,13),(14,2,19,4),(14,3,16,10),(14,3,20,6),(14,4,1,6),(14,4,14,9),(14,4,18,5),(14,4,19,2),(14,4,20,10),(14,5,2,2),(14,5,5,9),(14,5,7,8),(14,6,2,12),(14,6,7,6),(14,7,0,0),(14,7,2,3),(14,8,1,3),(14,8,3,7),(14,8,4,9),(14,8,7,10),(14,9,0,5),(14,9,7,2),(14,9,16,13),(14,9,17,5),(14,10,0,7),(14,10,15,1),(14,10,16,11),(14,10,17,2),(14,11,7,7),(14,11,14,11),(14,11,15,3),(14,11,21,0),(14,12,7,10),(14,12,11,9),(14,12,16,12),(14,13,7,11),(14,13,21,2),(14,14,1,13),(14,14,9,10),(14,14,16,13),(14,15,7,11),(14,15,17,5),(14,15,21,12),(14,16,1,3),(14,16,6,6),(14,16,10,0),(14,16,14,5),(14,17,0,8),(14,17,1,5),(14,17,8,4),(14,17,10,9),(14,18,4,7),(14,18,13,6),(14,18,14,11),(14,19,3,7),(14,19,4,4),(14,20,0,11),(14,20,10,10),(14,20,15,2),(14,20,19,3),(14,21,2,7),(14,21,7,3),(14,21,8,10),(14,21,10,7),(14,21,13,4),(14,21,16,1),(14,21,18,4),(14,21,20,11),(14,22,13,10),(14,23,10,2),(14,23,13,3),(14,23,21,11),(14,24,8,8),(14,24,20,6),(14,24,21,11),(14,25,6,13),(14,26,16,9),(14,26,17,2),(14,27,6,5),(14,27,8,7),(14,28,4,1),(14,29,21,1),(14,30,7,5),(14,30,12,3),(14,30,16,2),(14,31,8,13),(14,31,15,13),(14,32,8,11),(14,32,17,9),(14,32,19,4),(14,33,16,0),(14,34,21,13),(14,35,14,5),(14,35,16,9),(14,35,21,4),(14,36,6,2),(14,36,16,4),(14,36,20,2),(14,37,14,10),(14,37,21,6),(14,38,20,12),(14,39,1,6),(14,39,4,5),(14,39,13,10),(14,39,14,13),(14,39,15,0),(15,0,5,4),(15,0,9,9),(15,1,2,13),(15,1,3,13),(15,1,4,11),(15,1,10,9),(15,1,11,5),(15,1,14,9),(15,1,24,5),(15,2,1,5),(15,2,10,0),(15,2,11,4),(15,2,21,9),(15,2,24,0),(15,3,19,11),(15,3,24,0),(15,4,17,0),(15,4,20,10),(15,5,0,10),(15,5,8,3),(15,5,10,13),(15,5,11,5),(15,5,14,6),(15,5,16,7),(15,6,0,3),(15,6,3,6),(15,6,5,13),(15,6,6,9),(15,6,10,12),(15,6,11,9),(15,7,1,2),(15,7,2,12),(15,7,7,10),(15,8,2,4),(15,8,6,2),(15,8,17,6),(15,8,25,7),(15,9,6,5),(15,9,11,3),(15,9,12,3),(15,9,25,8),(15,10,1,11),(15,10,9,13),(15,10,15,10),(15,10,17,5),(15,11,4,7),(15,11,8,2),(15,11,10,9),(15,11,11,7),(15,11,12,1),(15,11,15,9),(15,11,21,12),(15,11,25,11),(15,12,1,5),(15,12,6,3),(15,12,9,8),(15,12,21,2),(15,12,22,2),(15,12,23,6),(15,13,9,4),(15,13,17,13),(15,13,23,8),(15,13,24,11),(15,14,0,11),(15,14,1,12),(15,14,15,9),(15,14,23,0),(15,15,0,3),(15,15,5,1),(15,15,8,5),(15,15,21,13),(15,15,24,6),(15,16,4,1),(15,16,18,1),(15,16,24,1),(15,17,1,5),(15,17,3,12),(15,17,6,0),(15,17,8,10),(15,17,9,3),(15,17,22,10),(15,17,24,5),(15,18,7,4),(15,18,8,2),(15,18,9,13),(15,18,24,0),(15,18,25,6),(15,19,1,1),(15,19,3,13),(15,19,21,8),(15,19,23,3),(15,19,24,6),(15,19,25,7),(15,20,1,10),(15,20,20,4),(15,20,21,7),(15,20,22,0),(15,21,14,13),(15,21,19,12),(15,21,20,1),(15,21,22,4),(15,21,23,4),(15,21,25,9),(15,22,1,8),(15,22,3,12),(15,22,16,12),(15,23,4,6),(15,23,14,8),(15,23,21,6),(15,24,0,0),(15,25,3,9),(15,27,0,6),(15,27,1,13),(15,27,7,11),(15,27,10,10),(15,27,18,7),(15,29,7,1),(15,29,10,9),(15,30,6,11),(15,30,10,9),(15,30,11,3),(15,31,7,12),(15,31,8,5),(15,31,9,8),(15,32,9,6),(15,32,21,10),(15,33,8,7),(15,33,11,9),(15,33,17,11),(15,33,19,10),(15,33,20,11),(15,34,7,2),(15,34,15,4),(15,34,25,2),(15,35,10,11),(15,35,13,13),(15,35,14,3),(15,35,15,13),(15,36,8,4),(15,36,18,11),(15,36,24,9),(15,36,25,11),(15,37,6,8),(15,37,7,11),(15,37,9,8),(15,37,10,4),(15,37,14,1),(15,37,17,12),(17,2,1,13),(17,2,2,5),(17,3,0,8),(17,3,4,1),(17,4,4,5),(17,5,2,1),(17,5,3,1),(17,6,4,11),(17,6,5,10),(17,6,19,0),(17,7,19,9),(17,8,9,4),(17,9,9,8),(17,9,19,10),(17,10,18,0),(17,11,8,10),(17,11,17,1),(17,12,16,5),(17,12,19,7),(17,13,1,13),(17,14,8,5),(17,14,18,6),(17,15,6,5),(17,15,7,9),(17,15,8,12),(17,15,11,10),(17,15,12,8),(17,16,4,9),(17,17,7,8),(17,17,9,9),(17,17,17,7),(17,17,18,8),(17,17,19,11),(17,18,6,11),(17,18,15,11),(17,19,7,4),(17,19,17,0),(17,19,18,8),(17,20,0,11),(17,20,2,8),(17,20,18,0),(17,21,7,9),(17,21,16,8),(17,22,6,8),(17,22,10,10),(17,23,1,0),(17,24,18,1),(17,25,2,13),(17,25,8,6),(17,25,14,4),(17,26,2,2),(17,26,16,4),(17,27,0,7),(17,27,11,0),(17,27,13,7),(17,27,15,9),(17,28,1,0),(17,28,3,1),(17,28,5,9),(17,28,16,8),(17,29,3,13),(17,29,11,9),(17,29,12,9),(17,29,14,0),(17,30,13,10),(17,30,17,13),(17,31,7,0),(17,31,9,2),(17,31,15,2),(17,31,17,2),(17,31,19,3),(17,32,11,8),(17,32,15,10),(17,32,16,6),(17,33,10,11),(17,33,15,4),(17,33,18,0),(17,34,2,6),(17,34,9,12),(17,34,13,10),(17,35,5,8),(17,35,8,2),(17,36,16,3),(17,36,17,12),(17,37,14,13),(17,37,16,4),(17,37,17,11),(17,37,19,10),(17,38,2,10),(17,38,16,3),(17,38,17,8),(17,38,18,1),(17,39,1,1),(17,39,5,2),(17,39,7,0),(17,39,12,10),(17,40,10,13),(17,40,11,13),(17,40,15,8),(17,41,2,10),(17,41,3,0),(17,41,7,12),(17,42,9,6),(17,42,15,13),(17,43,12,3),(17,44,1,3),(17,44,2,5),(17,44,8,6),(17,46,15,13),(17,47,1,6),(17,47,8,12),(17,48,17,7),(17,49,16,1),(17,49,17,2),(17,50,1,2),(17,50,4,2),(17,50,5,6),(17,50,17,1),(17,50,18,4),(19,0,7,8),(19,0,12,1),(19,0,14,6),(19,0,27,4),(19,1,27,5),(19,2,10,12),(19,2,28,9),(19,2,29,11),(19,3,29,6),(19,4,29,1),(19,5,1,11),(19,5,4,2),(19,5,14,6),(19,5,16,5),(19,5,24,4),(19,5,25,0),(19,6,0,2),(19,6,2,2),(19,6,4,3),(19,6,7,5),(19,6,14,3),(19,6,15,0),(19,6,17,5),(19,6,24,5),(19,6,25,8),(19,6,27,11),(19,6,28,6),(19,7,8,3),(19,7,24,3),(19,7,25,2),(19,8,0,13),(19,8,8,9),(19,8,18,2),(19,9,0,8),(19,9,15,1),(19,9,19,4),(19,9,23,4),(19,10,10,10),(19,10,16,2),(19,10,17,10),(19,10,18,9),(19,10,28,11),(19,11,11,12),(19,11,13,6),(19,12,12,8),(19,13,4,13),(19,13,5,11),(19,13,6,12),(19,13,20,13),(19,13,24,13),(19,14,2,5),(19,15,3,2),(19,15,6,0),(19,15,7,8),(19,15,12,11),(19,15,13,2),(19,15,21,10),(19,16,1,13),(19,16,4,9),(19,16,7,9),(19,16,24,13),(19,17,3,9),(19,17,7,6),(19,17,8,1),(19,18,11,0),(19,18,22,7),(19,19,1,0),(19,19,11,9),(19,19,12,12),(19,19,16,8),(19,19,23,10),(19,20,4,9),(19,20,5,4),(19,20,7,5),(19,20,14,9),(19,20,18,2),(19,20,21,4),(19,21,1,7),(19,21,6,8),(19,21,12,10),(19,21,18,13),(19,21,19,10),(19,22,5,5),(19,22,6,11),(19,22,15,0),(19,22,18,5),(19,22,19,7),(19,22,25,1),(19,22,26,0),(19,23,5,8),(19,23,9,1),(19,23,10,2),(19,23,11,0),(19,24,10,2),(19,24,13,13),(19,24,23,3),(19,24,29,13),(19,25,5,5),(19,25,10,10),(19,25,13,7),(19,25,15,10),(19,26,3,0),(19,26,5,13),(19,26,11,2),(19,26,14,8),(19,27,9,11),(19,27,10,2),(19,27,13,4),(19,27,15,3),(19,27,26,7),(19,28,18,11),(19,28,29,8),(19,29,0,9),(19,29,14,10),(19,29,17,10),(22,0,2,5),(22,0,3,9),(22,0,6,9),(22,0,10,2),(22,0,12,12),(22,1,1,12),(22,1,3,9),(22,1,7,2),(22,1,10,7),(22,2,1,1),(22,2,13,9),(22,2,18,5),(22,3,4,12),(22,3,18,4),(22,4,3,13),(22,4,4,13),(22,5,5,11),(22,5,11,4),(22,5,15,10),(22,6,9,2),(22,6,10,11),(22,7,3,1),(22,7,6,10),(22,7,15,7),(22,7,16,13),(22,7,17,1),(22,7,19,11),(22,8,4,2),(22,8,10,4),(22,8,11,6),(22,8,18,3),(22,8,19,0),(22,9,6,9),(22,9,9,12),(22,9,18,12),(22,9,19,5),(22,10,9,6),(22,10,16,1),(22,12,10,3),(22,13,3,12),(22,13,16,3),(22,14,6,5),(22,14,16,2),(22,15,17,10),(22,15,18,9),(22,15,19,5),(22,16,14,1),(22,16,16,7),(22,17,0,10),(22,17,15,8),(22,17,18,2),(22,17,19,7),(22,18,18,2),(22,19,14,7),(22,20,19,3),(22,21,17,2),(22,22,18,7),(22,22,19,0),(22,23,1,7),(22,23,3,2),(22,23,4,7),(22,23,5,13),(22,24,0,13),(22,24,2,11),(22,24,4,0),(22,24,18,2),(22,24,19,10),(22,25,1,6),(22,25,3,2),(22,26,19,6),(22,27,19,2),(22,29,0,2),(22,29,16,11),(22,30,0,10),(22,30,4,8),(22,30,5,13),(22,30,10,12),(22,30,15,6),(22,30,16,6),(22,31,7,3),(22,31,13,4),(22,32,1,11),(22,32,15,1),(22,32,18,10),(22,33,3,13),(22,33,15,10),(22,34,0,6),(22,34,1,5),(22,34,3,7),(22,34,4,8),(22,34,15,8),(25,0,8,8),(25,0,10,13),(25,0,12,10),(25,0,13,1),(25,0,14,6),(25,0,16,1),(25,0,19,1),(25,0,21,8),(25,0,23,10),(25,1,0,4),(25,1,2,3),(25,1,3,2),(25,1,5,3),(25,1,14,1),(25,1,19,10),(25,2,4,12),(25,2,16,8),(25,3,4,3),(25,5,5,6),(25,6,8,11),(25,7,7,13),(25,7,14,7),(25,8,12,3),(25,9,7,1),(25,9,10,10),(25,11,17,7),(25,11,20,3),(25,12,6,3),(25,12,11,7),(25,12,23,13),(25,13,3,9),(25,13,7,12),(25,13,17,8),(25,13,21,2),(25,13,22,12),(25,14,22,2),(25,15,11,1),(25,15,17,10),(25,15,24,0),(25,16,3,11),(25,16,11,0),(25,17,21,11),(25,18,14,9),(25,19,4,1),(25,19,8,1),(25,19,12,8),(25,19,14,9),(25,19,15,5),(25,19,19,4),(25,20,10,13),(25,20,14,3),(25,20,15,8),(25,20,23,6),(25,21,7,9),(25,21,11,3),(25,21,15,3),(25,21,23,7),(25,22,5,13),(25,22,11,0),(25,22,12,7),(25,22,24,7),(25,23,8,0),(25,23,10,11),(25,23,11,2),(25,23,12,6),(25,23,15,11),(25,23,17,5),(25,23,20,2),(25,24,10,0),(25,24,11,9),(25,24,12,7),(25,26,0,8),(25,26,21,11),(25,27,1,0),(25,27,21,11),(25,28,0,12),(25,28,5,11),(25,28,19,11),(25,29,17,11),(25,29,19,3),(25,30,7,11),(25,31,11,4),(25,31,20,6),(25,31,21,12),(25,32,7,4),(25,32,15,5),(25,33,7,4),(25,34,7,6),(25,34,8,8),(25,35,8,4),(25,35,13,6),(25,35,14,2),(25,35,16,4),(25,36,17,0),(25,37,6,1),(25,37,12,6),(25,38,0,9),(25,38,6,4),(25,38,15,0),(25,38,20,0),(28,0,0,13),(28,0,3,3),(28,0,9,3),(28,1,0,7),(28,2,0,12),(28,2,3,9),(28,8,11,7),(28,8,13,13),(28,9,4,4),(28,9,13,7),(28,11,0,12),(28,13,17,3),(28,16,12,13),(28,17,1,13),(28,17,13,3),(28,17,16,13),(28,18,0,13),(28,18,2,3),(28,18,7,6),(28,19,2,11),(28,19,7,3),(28,19,10,10),(28,19,11,9),(28,19,16,0),(28,20,9,9),(28,20,10,1),(28,20,11,13),(28,20,13,4),(28,21,13,2),(28,21,14,8),(28,23,11,5),(28,23,12,1),(28,24,4,13),(28,25,4,0),(28,25,8,10),(28,26,5,0),(28,26,6,3),(28,26,15,0),(28,28,5,12),(28,29,3,5),(28,30,3,10),(28,30,11,0),(28,31,6,12),(28,31,10,5),(28,31,13,8),(28,32,5,9),(28,33,2,1),(28,33,5,5),(28,33,16,2),(28,35,5,13),(28,35,9,3),(28,35,14,4),(28,35,15,3),(28,36,7,5),(28,36,8,12),(28,36,9,7),(28,37,12,9),(28,38,7,8),(28,38,10,1),(28,39,0,10),(28,39,6,13),(28,39,7,8),(28,39,9,2),(28,40,2,11),(28,40,11,1),(28,42,4,6),(28,43,3,3),(28,44,1,5),(34,0,9,3),(34,0,11,2),(34,0,16,13),(34,0,17,10),(34,0,21,2),(34,1,23,8),(34,1,25,3),(34,2,26,0),(34,3,14,0),(34,3,20,11),(34,4,21,4),(34,4,22,6),(34,4,25,1),(34,5,2,5),(34,5,22,7),(34,5,23,12),(34,6,5,10),(34,6,21,10),(34,6,23,10),(34,8,3,12),(34,8,11,3),(34,8,19,0),(34,9,3,4),(34,9,22,6),(34,10,3,2),(34,10,6,2),(34,10,8,4),(34,10,13,11),(34,11,2,4),(34,11,4,12),(34,12,1,9),(34,13,6,10),(34,13,7,8),(34,14,8,9),(34,15,0,10),(34,15,4,11),(34,16,2,10),(34,16,3,6),(34,16,4,0),(34,16,14,12),(34,17,1,10),(34,17,2,7),(34,17,4,2),(34,17,15,13),(34,17,17,0),(34,17,26,8),(34,18,1,4),(34,18,4,5),(34,18,17,2),(34,18,26,5),(34,19,7,6),(34,20,2,8),(34,20,26,5),(34,21,9,0),(34,21,25,0),(34,21,26,3),(34,22,4,13),(34,22,5,7),(34,22,13,0),(34,22,23,3),(34,23,8,2),(34,23,23,5),(34,24,7,0),(34,24,21,3),(34,24,22,10),(34,24,26,9),(34,25,2,2),(34,25,4,4),(34,25,26,6),(34,26,0,11),(34,26,2,8),(34,26,5,5),(34,26,12,2),(34,26,17,8),(34,26,18,7),(34,26,19,6),(34,26,26,7),(34,27,1,7),(34,27,15,9),(34,27,22,11),(34,27,26,2),(34,28,20,11),(34,29,21,7),(34,30,0,7),(34,30,1,5),(34,30,18,11),(34,30,21,3),(34,30,23,2),(34,31,0,9),(34,31,3,11),(34,31,4,2),(34,31,18,3),(34,31,22,3),(34,31,26,8),(34,32,1,2),(34,32,15,10),(34,33,3,8),(34,33,12,7),(34,34,0,1),(34,34,11,3),(34,34,15,12),(34,34,16,1),(34,35,1,12),(34,35,2,4),(34,35,17,11),(34,36,6,1),(34,36,13,13),(34,36,14,4),(34,36,15,1),(34,37,12,1),(34,37,13,3),(34,37,16,3),(34,37,19,12),(34,38,2,3),(34,38,14,1),(34,38,18,13),(34,38,22,6),(34,38,23,10),(34,39,12,7),(34,40,0,1),(34,40,11,1),(34,40,13,6),(34,40,23,12),(34,41,12,1),(34,41,13,5),(34,42,13,7),(34,42,15,5),(34,43,16,10),(34,44,16,9),(34,44,17,10),(34,45,11,0),(34,45,17,10),(34,46,22,5),(34,47,0,5),(34,47,8,8),(34,48,2,1),(34,48,16,10),(37,0,4,5),(37,0,8,3),(37,1,2,0),(37,1,11,9),(37,1,16,13),(37,2,13,6),(37,2,14,3),(37,3,11,10),(37,3,12,0),(37,4,7,3),(37,4,14,12),(37,5,9,5),(37,5,12,13),(37,5,13,0),(37,5,14,4),(37,6,1,10),(37,6,9,9),(37,6,14,0),(37,6,15,5),(37,6,17,7),(37,6,18,13),(37,7,13,13),(37,7,14,2),(37,7,15,2),(37,7,18,8),(37,8,13,9),(37,8,14,10),(37,8,18,3),(37,10,14,7),(37,10,16,6),(37,10,17,9),(37,10,18,10),(37,10,19,2),(37,11,13,3),(37,12,13,0),(37,12,14,9),(37,13,0,7),(37,13,2,1),(37,13,4,11),(37,13,5,1),(37,13,14,2),(37,14,0,1),(37,14,3,9),(37,14,13,10),(37,14,14,6),(37,14,16,10),(37,15,2,10),(37,15,15,8),(37,16,6,2),(37,16,16,12),(37,17,6,8),(37,17,14,1),(37,17,19,12),(37,18,6,4),(37,18,19,6),(37,19,9,4),(37,20,9,3),(37,21,10,1),(37,22,9,1),(37,22,18,13),(37,23,5,10),(37,23,19,0),(37,24,4,10),(37,24,7,8),(37,24,11,2),(37,24,12,2),(37,24,19,8),(37,25,8,7),(37,25,11,4),(37,26,2,13),(37,26,4,0),(37,26,5,1),(37,26,7,9),(37,26,13,11),(37,26,19,12),(37,27,1,6),(37,27,3,10),(37,27,6,6),(37,27,18,11),(37,28,1,13),(37,28,2,0),(37,28,7,10),(37,28,14,5),(37,31,6,4),(37,31,19,7),(37,32,7,10),(37,32,10,1),(37,33,1,5),(37,33,5,9),(37,33,7,4),(37,33,8,9),(37,33,9,0),(37,33,11,7),(37,33,12,0),(37,33,19,11),(37,34,0,3),(37,34,11,9),(37,35,2,1),(37,35,7,12),(37,35,9,13),(37,35,19,13),(37,36,17,6),(37,36,19,9),(37,37,0,13),(37,37,17,0),(37,37,18,4),(37,37,19,4),(37,38,1,4),(37,38,7,4),(37,40,17,4),(37,44,0,13),(37,45,9,8),(37,45,11,9),(37,46,6,1),(37,46,8,5),(37,46,15,5),(38,0,1,5),(38,0,3,1),(38,0,14,4),(38,1,2,10),(38,1,11,0),(38,1,12,11),(38,1,15,4),(38,1,16,2),(38,1,17,0),(38,2,2,8),(38,2,3,6),(38,2,4,8),(38,2,7,6),(38,2,10,11),(38,2,15,10),(38,2,16,9),(38,3,0,9),(38,3,1,1),(38,3,6,13),(38,3,12,7),(38,3,13,9),(38,4,8,13),(38,4,10,7),(38,4,11,7),(38,4,12,11),(38,4,13,8),(38,4,17,8),(38,5,1,5),(38,5,4,11),(38,5,6,8),(38,5,7,13),(38,5,8,13),(38,5,15,9),(38,6,7,11),(38,6,15,4),(38,7,9,3),(38,7,11,11),(38,8,5,12),(38,8,8,12),(38,8,14,8),(38,9,11,0),(38,9,15,12),(38,11,4,8),(38,11,6,7),(38,11,10,2),(38,12,13,9),(38,13,14,11),(38,14,1,12),(38,14,14,4),(38,14,15,6),(38,14,17,7),(38,15,0,0),(38,15,1,9),(38,15,17,12),(38,18,14,11),(38,19,3,6),(38,19,6,10),(38,19,13,13),(38,19,14,3),(38,20,2,12),(38,20,11,7),(38,21,0,12),(38,21,4,0),(38,22,1,9),(38,22,4,9),(38,23,1,12),(38,23,2,10),(38,24,1,11),(38,24,5,11),(38,24,12,12),(38,24,13,13),(38,25,14,13),(38,25,16,0),(38,26,16,1),(38,26,17,1),(38,27,7,10),(38,28,4,1),(38,28,7,8),(38,29,2,5),(38,30,2,0),(38,31,3,6),(38,32,3,6),(38,33,2,1),(38,34,8,1),(38,35,8,3),(38,36,9,6),(38,37,3,0),(38,37,13,6),(38,39,13,3),(38,40,0,8),(38,40,1,13),(38,40,10,11),(38,41,8,6),(38,44,9,2),(38,44,17,6),(38,45,2,0),(38,45,8,0),(38,45,17,6),(38,46,5,4),(38,47,3,13),(38,47,5,1),(38,47,6,5),(38,48,6,2),(38,48,7,1),(38,48,8,5),(38,49,0,11),(38,49,3,0),(38,51,0,11),(38,52,4,6),(38,52,6,5),(39,0,10,3),(39,0,12,9),(39,0,13,3),(39,1,2,3),(39,1,11,3),(39,1,24,11),(39,2,0,5),(39,2,12,1),(39,3,1,0),(39,3,10,12),(39,3,11,11),(39,3,12,8),(39,3,15,12),(39,4,9,5),(39,5,0,12),(39,5,9,0),(39,5,16,11),(39,5,18,10),(39,5,26,10),(39,6,10,5),(39,6,15,5),(39,6,16,7),(39,6,18,5),(39,6,22,13),(39,6,29,0),(39,7,13,1),(39,7,14,0),(39,7,15,9),(39,7,25,9),(39,7,27,6),(39,8,8,10),(39,8,11,9),(39,8,14,1),(39,8,15,4),(39,8,22,10),(39,8,25,13),(39,8,27,4),(39,9,9,5),(39,9,21,12),(39,9,23,2),(39,9,24,7),(39,10,6,5),(39,10,9,13),(39,10,14,4),(39,10,15,1),(39,10,16,11),(39,10,24,3),(39,11,6,12),(39,11,11,12),(39,11,12,13),(39,11,18,0),(39,11,30,13),(39,11,32,0),(39,12,7,8),(39,12,10,4),(39,12,14,4),(39,12,19,2),(39,12,28,13),(39,12,30,3),(39,13,1,11),(39,13,7,1),(39,13,13,5),(39,13,19,2),(39,13,21,8),(39,13,27,7),(39,13,29,1),(39,13,30,3),(39,14,2,3),(39,14,3,9),(39,14,5,11),(39,14,6,12),(39,14,14,0),(39,14,17,7),(39,14,18,5),(39,14,19,13),(39,14,28,13),(39,14,31,2),(39,15,1,3),(39,15,2,10),(39,15,7,6),(39,15,14,13),(39,15,17,3),(39,15,24,8),(39,15,27,3),(39,15,30,0),(39,16,3,13),(39,16,12,2),(39,16,18,5),(39,17,18,9),(39,18,6,12),(39,18,20,5),(39,18,24,4),(39,19,2,11),(39,19,32,1),(39,20,9,7),(39,20,13,13),(39,20,15,5),(39,20,24,11),(39,20,32,6),(39,21,0,10),(39,21,2,0),(39,21,3,7),(39,21,4,5),(39,21,16,5),(39,21,19,2),(39,21,25,5),(39,22,1,2),(39,22,2,9),(39,22,3,13),(39,22,13,12),(39,22,16,7),(39,22,21,4),(39,22,22,2),(39,22,23,7),(39,22,29,7),(39,23,0,9),(39,23,3,13),(39,23,4,1),(39,23,16,2),(39,23,24,12),(39,23,25,9),(39,23,26,10),(39,23,28,11),(39,23,29,4),(39,24,6,8),(39,24,26,5),(39,24,29,12),(39,24,30,0),(39,25,0,5),(39,25,5,12),(39,25,20,2),(39,25,23,5),(39,25,28,12),(39,26,0,1),(39,26,1,1),(39,26,7,6),(39,26,8,7),(39,26,9,1),(39,26,27,8),(39,27,0,0),(39,27,9,10),(39,27,11,9),(39,28,14,9),(39,29,4,9),(39,29,13,7),(39,29,16,6),(39,29,27,13),(39,31,11,4),(39,31,14,11),(39,31,29,5),(39,32,6,13),(39,32,12,4),(39,32,17,8),(39,32,29,8),(39,33,5,8),(39,33,18,0),(39,33,19,0),(39,33,28,4),(39,34,6,1),(39,34,7,8),(39,34,8,10),(39,34,10,0),(39,34,12,8),(39,34,16,2),(39,34,17,11),(39,34,22,10),(39,34,28,12),(39,34,31,0),(39,34,32,7),(39,35,0,7),(39,35,2,1),(39,35,3,2),(39,35,7,0),(39,35,10,7),(39,35,13,5),(39,35,18,11),(39,35,20,11),(39,36,2,4),(39,36,4,8),(39,36,6,2),(39,36,13,12),(39,36,26,5),(39,36,27,4),(39,36,29,10),(39,36,32,12),(39,37,0,11),(39,37,7,6),(39,37,10,7),(39,37,11,3),(39,37,18,5),(39,37,19,6),(39,37,20,5),(39,37,27,4),(39,38,1,4),(39,38,2,7),(39,38,3,3),(39,38,9,12),(39,38,19,1),(39,38,20,6),(39,38,25,11),(39,38,26,12),(39,38,28,5),(39,39,2,5),(39,39,11,12),(39,39,22,12),(39,39,32,6),(39,40,1,9),(39,40,2,9),(39,40,4,6),(39,40,7,11),(39,40,29,7),(39,41,20,9),(39,41,22,12),(39,41,29,3),(39,42,1,5),(39,42,14,4),(39,42,22,0),(39,42,25,12),(39,42,29,0),(39,42,31,1),(39,43,9,0),(39,43,27,12),(39,43,28,6),(39,43,32,7),(39,44,0,11),(39,44,9,2),(39,44,22,11),(39,44,31,13),(39,44,32,6),(39,45,8,3),(39,45,9,3),(39,45,12,2),(39,45,13,5),(39,45,30,3),(39,45,31,8),(39,46,4,13),(39,46,7,4),(39,46,8,10),(39,46,21,12),(39,46,30,6);
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
INSERT INTO `fow_ss_entries` VALUES (1,2,1,2,1,0,0,0,NULL,NULL,NULL,NULL,NULL),(2,3,1,1,0,0,0,0,NULL,NULL,NULL,NULL,NULL),(3,4,1,1,0,0,0,0,NULL,NULL,NULL,NULL,NULL),(4,1,1,1,0,0,0,0,NULL,NULL,NULL,NULL,NULL);
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
  `ruleset` varchar(30) NOT NULL DEFAULT 'default',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `galaxies`
--

LOCK TABLES `galaxies` WRITE;
/*!40000 ALTER TABLE `galaxies` DISABLE KEYS */;
INSERT INTO `galaxies` VALUES (1,'2010-10-01 16:45:31','dev');
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
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `notifications`
--

LOCK TABLES `notifications` WRITE;
/*!40000 ALTER TABLE `notifications` DISABLE KEYS */;
INSERT INTO `notifications` VALUES (1,1,'2010-10-01 16:45:35','2010-10-15 16:45:35',3,'--- \n:id: 1\n',0,0),(2,1,'2010-10-01 16:45:35','2010-10-15 16:45:35',3,'--- \n:id: 2\n',0,0),(3,1,'2010-10-01 17:57:52','2010-10-15 17:57:52',3,'--- \n:id: 3\n',0,0),(4,1,'2010-10-01 17:57:52','2010-10-15 17:57:52',4,'--- \n:id: 2\n',0,0),(5,1,'2010-10-01 17:58:13','2010-10-15 17:58:13',3,'--- \n:id: 4\n',0,0),(6,1,'2010-10-01 17:58:13','2010-10-15 17:58:13',4,'--- \n:id: 3\n',0,0),(7,1,'2010-10-01 17:59:09','2010-10-15 17:59:09',3,'--- \n:id: 5\n',0,0),(8,1,'2010-10-01 17:59:09','2010-10-15 17:59:09',3,'--- \n:id: 10\n',0,0),(9,1,'2010-10-01 17:59:09','2010-10-15 17:59:09',4,'--- \n:id: 4\n',0,0),(10,1,'2010-10-01 18:00:00','2010-10-15 18:00:00',2,'--- \n:location: !ruby/object:ClientLocation \n  id: 19\n  name: G1-S2-P19\n  solar_system_id: 2\n  type: 2\n  variation: 0\n  x: 2\n  y: 0\n:alliances: \n  -2: \n    :players: \n    - :name: \n      :id: \n    :name: \n    :classification: 1\n  -1: \n    :players: \n    - :name: Test Player\n      :id: 1\n    :name: \n    :classification: 0\n:log_id: 5e685da79f35c0ce21fc7050c4bebeba9a0e9ed1\n:units: \n  :yours: \n    :dead: \n      Unit::Trooper: 2\n    :alive: \n      Unit::Seeker: 3\n      Unit::Shocker: 6\n      Unit::Trooper: 6\n  :nap: \n    :dead: {}\n\n    :alive: {}\n\n  :alliance: \n    :dead: {}\n\n    :alive: {}\n\n  :enemy: \n    :dead: \n      Unit::Glancer: 4\n      Unit::Gnat: 8\n    :alive: {}\n\n:alliance_id: -1\n:outcome: 0\n:leveled_up: []\n\n:statistics: \n  :damage_dealt_alliance: 1600\n  :damage_taken_player: 519\n  :damage_taken_alliance: 519\n  :points_earned: 14135\n  :xp_earned: 4675\n  :damage_dealt_player: 1600\n',0,1);
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
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `objective_progresses`
--

LOCK TABLES `objective_progresses` WRITE;
/*!40000 ALTER TABLE `objective_progresses` DISABLE KEYS */;
INSERT INTO `objective_progresses` VALUES (1,1,1,0),(2,2,1,0),(6,6,1,8),(7,7,1,4),(8,12,1,8),(9,13,1,4),(10,14,1,0);
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
INSERT INTO `objectives` VALUES (1,1,'HaveUpgradedTo','Building::MetalExtractor',1,1,0,0),(2,1,'HaveUpgradedTo','Building::SolarPlant',2,1,0,0),(3,2,'HaveUpgradedTo','Building::Barracks',1,1,0,0),(4,3,'UpgradeTo','Unit::Trooper',3,1,0,0),(5,4,'UpgradeTo','Unit::Shocker',2,1,0,0),(6,5,'Destroy','Unit::Gnat',10,1,0,0),(7,5,'Destroy','Unit::Glancer',5,1,0,0),(8,6,'HaveUpgradedTo','Building::GroundFactory',1,1,0,0),(9,7,'HaveUpgradedTo','Building::SpaceFactory',1,1,0,0),(10,8,'AnnexPlanet','Planet',1,NULL,0,0),(11,9,'AnnexPlanet','Planet',1,NULL,0,0),(12,10,'HaveUpgradedTo','Unit::Trooper',10,1,0,0),(13,10,'HaveUpgradedTo','Unit::Shocker',5,1,0,0),(14,10,'HaveUpgradedTo','Unit::Seeker',5,1,0,0);
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
) ENGINE=InnoDB AUTO_INCREMENT=40 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `planets`
--

LOCK TABLES `planets` WRITE;
/*!40000 ALTER TABLE `planets` DISABLE KEYS */;
INSERT INTO `planets` VALUES (1,1,NULL,NULL,0,90,2,'Mining',NULL,'G1-S1-P1',56,207,145,336),(2,1,NULL,NULL,2,0,3,'Mining',NULL,'G1-S1-P2',44,344,102,197),(3,1,NULL,NULL,3,112,0,'Mining',NULL,'G1-S1-P3',56,149,233,176),(4,1,NULL,NULL,4,270,1,'Resource',NULL,'G1-S1-P4',59,395,352,169),(5,1,NULL,NULL,5,150,5,'Mining',NULL,'G1-S1-P5',37,397,118,400),(6,1,NULL,NULL,6,180,0,'Npc',NULL,'G1-S1-P6',26,NULL,NULL,NULL),(7,1,NULL,NULL,7,66,2,'Jumpgate',NULL,'G1-S1-P7',47,NULL,NULL,NULL),(8,1,NULL,NULL,9,216,1,'Jumpgate',NULL,'G1-S1-P8',30,NULL,NULL,NULL),(9,1,NULL,NULL,11,7,2,'Jumpgate',NULL,'G1-S1-P9',27,NULL,NULL,NULL),(10,1,NULL,NULL,12,126,5,'Resource',NULL,'G1-S1-P10',42,398,298,357),(11,1,NULL,NULL,13,120,2,'Jumpgate',NULL,'G1-S1-P11',60,NULL,NULL,NULL),(12,1,NULL,NULL,15,245,0,'Resource',NULL,'G1-S1-P12',60,234,267,223),(13,1,NULL,NULL,16,20,0,'Jumpgate',NULL,'G1-S1-P13',42,NULL,NULL,NULL),(14,1,40,22,17,275,5,'Regular',NULL,'G1-S1-P14',49,NULL,NULL,NULL),(15,1,38,26,18,20,6,'Regular',NULL,'G1-S1-P15',51,NULL,NULL,NULL),(16,1,NULL,NULL,19,240,3,'Resource',NULL,'G1-S1-P16',45,225,164,329),(17,2,51,20,0,270,6,'Regular',NULL,'G1-S2-P17',56,NULL,NULL,NULL),(18,2,NULL,NULL,1,225,2,'Mining',NULL,'G1-S2-P18',54,119,168,113),(19,2,30,30,2,0,0,'Homeworld',1,'G1-S2-P19',38,NULL,NULL,NULL),(20,2,NULL,NULL,3,44,2,'Jumpgate',NULL,'G1-S2-P20',46,NULL,NULL,NULL),(21,2,NULL,NULL,4,108,3,'Mining',NULL,'G1-S2-P21',26,226,361,365),(22,2,35,20,5,210,3,'Regular',NULL,'G1-S2-P22',44,NULL,NULL,NULL),(23,2,NULL,NULL,6,192,0,'Npc',NULL,'G1-S2-P23',33,NULL,NULL,NULL),(24,3,NULL,NULL,0,90,1,'Jumpgate',NULL,'G1-S3-P24',51,NULL,NULL,NULL),(25,3,39,25,1,135,6,'Regular',NULL,'G1-S3-P25',51,NULL,NULL,NULL),(26,3,NULL,NULL,2,30,2,'Jumpgate',NULL,'G1-S3-P26',32,NULL,NULL,NULL),(27,3,NULL,NULL,3,270,3,'Mining',NULL,'G1-S3-P27',52,305,287,200),(28,3,45,18,4,342,3,'Regular',NULL,'G1-S3-P28',50,NULL,NULL,NULL),(29,3,NULL,NULL,5,60,2,'Jumpgate',NULL,'G1-S3-P29',33,NULL,NULL,NULL),(30,3,NULL,NULL,7,123,4,'Mining',NULL,'G1-S3-P30',43,276,206,288),(31,4,NULL,NULL,0,0,2,'Jumpgate',NULL,'G1-S4-P31',38,NULL,NULL,NULL),(32,4,NULL,NULL,1,315,2,'Mining',NULL,'G1-S4-P32',38,124,192,340),(33,4,NULL,NULL,2,240,0,'Jumpgate',NULL,'G1-S4-P33',60,NULL,NULL,NULL),(34,4,49,27,3,0,6,'Regular',NULL,'G1-S4-P34',60,NULL,NULL,NULL),(35,4,NULL,NULL,4,270,6,'Mining',NULL,'G1-S4-P35',56,186,160,160),(36,4,NULL,NULL,5,240,1,'Jumpgate',NULL,'G1-S4-P36',28,NULL,NULL,NULL),(37,4,47,20,6,216,0,'Regular',NULL,'G1-S4-P37',53,NULL,NULL,NULL),(38,4,53,18,7,270,3,'Regular',NULL,'G1-S4-P38',56,NULL,NULL,NULL),(39,4,47,33,8,200,6,'Regular',NULL,'G1-S4-P39',64,NULL,NULL,NULL);
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
INSERT INTO `players` VALUES (1,1,'0000000000000000000000000000000000000000000000000000000000000000','Test Player',50,50,NULL,0,0);
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
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `quest_progresses`
--

LOCK TABLES `quest_progresses` WRITE;
/*!40000 ALTER TABLE `quest_progresses` DISABLE KEYS */;
INSERT INTO `quest_progresses` VALUES (1,1,1,0,0),(2,2,1,2,1),(3,3,1,2,1),(4,4,1,2,1),(5,5,1,0,0),(6,10,1,0,0);
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
) ENGINE=InnoDB AUTO_INCREMENT=40 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `resources_entries`
--

LOCK TABLES `resources_entries` WRITE;
/*!40000 ALTER TABLE `resources_entries` DISABLE KEYS */;
INSERT INTO `resources_entries` VALUES (1,0,0,0,0,0,0,0,0,0,NULL,0),(2,0,0,0,0,0,0,0,0,0,NULL,0),(3,0,0,0,0,0,0,0,0,0,NULL,0),(4,0,0,0,0,0,0,0,0,0,NULL,0),(5,0,0,0,0,0,0,0,0,0,NULL,0),(6,0,0,0,0,0,0,0,0,0,NULL,0),(7,0,0,0,0,0,0,0,0,0,NULL,0),(8,0,0,0,0,0,0,0,0,0,NULL,0),(9,0,0,0,0,0,0,0,0,0,NULL,0),(10,0,0,0,0,0,0,0,0,0,NULL,0),(11,0,0,0,0,0,0,0,0,0,NULL,0),(12,0,0,0,0,0,0,0,0,0,NULL,0),(13,0,0,0,0,0,0,0,0,0,NULL,0),(14,0,0,0,0,0,0,0,0,0,NULL,0),(15,0,0,0,0,0,0,0,0,0,NULL,0),(16,0,0,0,0,0,0,0,0,0,NULL,0),(17,0,0,0,0,0,0,0,0,0,NULL,0),(18,0,0,0,0,0,0,0,0,0,NULL,0),(19,3024,3024,6048,6048,100,604.8,50,100,0,'2010-10-01 17:59:20',0),(20,0,0,0,0,0,0,0,0,0,NULL,0),(21,0,0,0,0,0,0,0,0,0,NULL,0),(22,0,0,0,0,0,0,0,0,0,NULL,0),(23,0,0,0,0,0,0,0,0,0,NULL,0),(24,0,0,0,0,0,0,0,0,0,NULL,0),(25,0,0,0,0,0,0,0,0,0,NULL,0),(26,0,0,0,0,0,0,0,0,0,NULL,0),(27,0,0,0,0,0,0,0,0,0,NULL,0),(28,0,0,0,0,0,0,0,0,0,NULL,0),(29,0,0,0,0,0,0,0,0,0,NULL,0),(30,0,0,0,0,0,0,0,0,0,NULL,0),(31,0,0,0,0,0,0,0,0,0,NULL,0),(32,0,0,0,0,0,0,0,0,0,NULL,0),(33,0,0,0,0,0,0,0,0,0,NULL,0),(34,0,0,0,0,0,0,0,0,0,NULL,0),(35,0,0,0,0,0,0,0,0,0,NULL,0),(36,0,0,0,0,0,0,0,0,0,NULL,0),(37,0,0,0,0,0,0,0,0,0,NULL,0),(38,0,0,0,0,0,0,0,0,0,NULL,0),(39,0,0,0,0,0,0,0,0,0,NULL,0);
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
INSERT INTO `solar_systems` VALUES (1,'Resource',1,-2,2),(2,'Homeworld',1,0,0),(3,'Expansion',1,-3,1),(4,'Expansion',1,-3,2);
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
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `technologies`
--

LOCK TABLES `technologies` WRITE;
/*!40000 ALTER TABLE `technologies` DISABLE KEYS */;
INSERT INTO `technologies` VALUES (1,NULL,NULL,NULL,NULL,1,1,'Shocker',NULL);
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
  `kind` tinyint(2) unsigned NOT NULL,
  `planet_id` int(11) NOT NULL,
  `x` tinyint(2) unsigned NOT NULL,
  `y` tinyint(2) unsigned NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uniqueness` (`planet_id`,`x`,`y`),
  CONSTRAINT `tiles_ibfk_1` FOREIGN KEY (`planet_id`) REFERENCES `planets` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=3589 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tiles`
--

LOCK TABLES `tiles` WRITE;
/*!40000 ALTER TABLE `tiles` DISABLE KEYS */;
INSERT INTO `tiles` VALUES (1,4,14,2,0),(2,4,14,3,0),(3,14,14,11,0),(4,8,14,25,0),(5,8,14,28,0),(6,4,14,32,0),(7,6,14,33,0),(8,6,14,34,0),(9,6,14,35,0),(10,6,14,36,0),(11,6,14,37,0),(12,6,14,38,0),(13,4,14,1,1),(14,4,14,2,1),(15,4,14,3,1),(16,2,14,18,1),(17,5,14,22,1),(18,5,14,24,1),(19,4,14,31,1),(20,4,14,32,1),(21,4,14,33,1),(22,4,14,34,1),(23,4,14,35,1),(24,14,14,36,1),(25,4,14,0,2),(26,4,14,1,2),(27,4,14,2,2),(28,4,14,3,2),(29,5,14,22,2),(30,5,14,23,2),(31,5,14,24,2),(32,4,14,31,2),(33,4,14,32,2),(34,4,14,33,2),(35,4,14,34,2),(36,4,14,35,2),(37,4,14,0,3),(38,4,14,1,3),(39,4,14,2,3),(40,4,14,3,3),(41,4,14,4,3),(42,4,14,5,3),(43,3,14,14,3),(44,3,14,15,3),(45,5,14,22,3),(46,5,14,24,3),(47,5,14,25,3),(48,4,14,29,3),(49,4,14,30,3),(50,4,14,31,3),(51,4,14,32,3),(52,4,14,34,3),(53,4,14,35,3),(54,4,14,0,4),(55,4,14,5,4),(56,3,14,12,4),(57,3,14,13,4),(58,3,14,14,4),(59,3,14,15,4),(60,5,14,21,4),(61,5,14,22,4),(62,5,14,23,4),(63,5,14,24,4),(64,10,14,31,4),(65,11,14,1,5),(66,3,14,10,5),(67,3,14,11,5),(68,3,14,12,5),(69,3,14,13,5),(70,3,14,14,5),(71,3,14,15,5),(72,3,14,16,5),(73,3,14,17,5),(74,3,14,18,5),(75,5,14,19,5),(76,5,14,20,5),(77,5,14,21,5),(78,5,14,22,5),(79,3,14,12,6),(80,3,14,13,6),(81,3,14,14,6),(82,3,14,15,6),(83,5,14,18,6),(84,5,14,19,6),(85,5,14,20,6),(86,5,14,21,6),(87,5,14,22,6),(88,2,14,37,6),(89,3,14,14,7),(90,5,14,19,7),(91,5,14,22,7),(92,7,14,5,8),(93,7,14,6,8),(94,7,14,7,8),(95,7,14,8,8),(96,7,14,12,8),(97,5,14,18,8),(98,5,14,19,8),(99,5,14,22,8),(100,12,14,33,8),(101,7,14,5,9),(102,7,14,6,9),(103,7,14,7,9),(104,7,14,8,9),(105,7,14,9,9),(106,7,14,10,9),(107,7,14,11,9),(108,7,14,12,9),(109,4,14,13,9),(110,5,14,17,9),(111,5,14,18,9),(112,5,14,19,9),(113,0,14,24,9),(114,5,14,26,9),(115,4,14,30,9),(116,4,14,31,9),(117,4,14,32,9),(118,3,14,0,10),(119,7,14,7,10),(120,7,14,8,10),(121,7,14,9,10),(122,7,14,10,10),(123,7,14,11,10),(124,4,14,13,10),(125,5,14,26,10),(126,5,14,27,10),(127,4,14,30,10),(128,4,14,31,10),(129,4,14,32,10),(130,3,14,0,11),(131,3,14,1,11),(132,3,14,2,11),(133,7,14,4,11),(134,7,14,5,11),(135,7,14,6,11),(136,7,14,7,11),(137,7,14,8,11),(138,7,14,9,11),(139,0,14,10,11),(140,4,14,13,11),(141,13,14,18,11),(142,5,14,24,11),(143,5,14,25,11),(144,5,14,26,11),(145,4,14,27,11),(146,4,14,29,11),(147,4,14,30,11),(148,4,14,31,11),(149,4,14,32,11),(150,3,14,0,12),(151,3,14,1,12),(152,3,14,2,12),(153,3,14,3,12),(154,7,14,4,12),(155,7,14,5,12),(156,7,14,6,12),(157,7,14,7,12),(158,6,14,9,12),(159,4,14,13,12),(160,4,14,14,12),(161,4,14,15,12),(162,5,14,24,12),(163,5,14,25,12),(164,4,14,26,12),(165,4,14,27,12),(166,4,14,28,12),(167,4,14,29,12),(168,4,14,31,12),(169,4,14,32,12),(170,3,14,1,13),(171,3,14,2,13),(172,3,14,3,13),(173,7,14,4,13),(174,7,14,6,13),(175,7,14,7,13),(176,7,14,8,13),(177,6,14,9,13),(178,6,14,10,13),(179,6,14,11,13),(180,0,14,12,13),(181,4,14,14,13),(182,4,14,15,13),(183,4,14,16,13),(184,4,14,17,13),(185,5,14,24,13),(186,5,14,25,13),(187,5,14,26,13),(188,4,14,27,13),(189,4,14,28,13),(190,4,14,29,13),(191,4,14,31,13),(192,4,14,32,13),(193,3,14,1,14),(194,3,14,2,14),(195,3,14,3,14),(196,7,14,6,14),(197,7,14,7,14),(198,7,14,8,14),(199,6,14,9,14),(200,6,14,10,14),(201,4,14,14,14),(202,4,14,17,14),(203,9,14,22,14),(204,4,14,26,14),(205,4,14,27,14),(206,4,14,28,14),(207,4,14,29,14),(208,4,14,30,14),(209,4,14,31,14),(210,4,14,32,14),(211,3,14,0,15),(212,3,14,1,15),(213,3,14,2,15),(214,3,14,3,15),(215,3,14,4,15),(216,7,14,6,15),(217,4,14,13,15),(218,4,14,14,15),(219,4,14,15,15),(220,11,14,16,15),(221,4,14,28,15),(222,4,14,29,15),(223,4,14,30,15),(224,4,14,32,15),(225,0,14,7,16),(226,4,14,13,16),(227,4,14,15,16),(228,4,14,32,16),(229,5,14,11,17),(230,5,14,12,17),(231,5,14,13,17),(232,3,14,24,17),(233,3,14,25,17),(234,1,14,28,17),(235,9,14,8,18),(236,5,14,12,18),(237,5,14,13,18),(238,5,14,14,18),(239,5,14,15,18),(240,3,14,23,18),(241,3,14,24,18),(242,3,14,25,18),(243,3,14,26,18),(244,3,14,27,18),(245,3,14,30,18),(246,1,14,37,18),(247,0,14,5,19),(248,5,14,12,19),(249,5,14,13,19),(250,5,14,14,19),(251,3,14,23,19),(252,3,14,25,19),(253,3,14,27,19),(254,3,14,28,19),(255,3,14,29,19),(256,3,14,30,19),(257,6,14,33,19),(258,6,14,7,20),(259,5,14,14,20),(260,3,14,25,20),(261,3,14,26,20),(262,3,14,27,20),(263,3,14,28,20),(264,6,14,32,20),(265,6,14,33,20),(266,6,14,5,21),(267,6,14,6,21),(268,6,14,7,21),(269,6,14,8,21),(270,3,14,26,21),(271,3,14,27,21),(272,6,14,31,21),(273,6,14,32,21),(274,6,14,33,21),(275,4,15,26,0),(276,1,15,29,0),(277,13,15,31,0),(278,6,15,37,0),(279,4,15,26,1),(280,6,15,37,1),(281,3,15,4,2),(282,13,15,11,2),(283,4,15,25,2),(284,4,15,26,2),(285,4,15,27,2),(286,5,15,29,2),(287,5,15,30,2),(288,5,15,31,2),(289,6,15,32,2),(290,6,15,33,2),(291,6,15,34,2),(292,6,15,35,2),(293,6,15,36,2),(294,6,15,37,2),(295,3,15,4,3),(296,3,15,5,3),(297,4,15,26,3),(298,4,15,28,3),(299,5,15,29,3),(300,5,15,30,3),(301,5,15,31,3),(302,5,15,32,3),(303,5,15,33,3),(304,6,15,34,3),(305,6,15,35,3),(306,6,15,36,3),(307,6,15,37,3),(308,3,15,3,4),(309,3,15,4,4),(310,3,15,5,4),(311,11,15,19,4),(312,4,15,24,4),(313,4,15,25,4),(314,4,15,26,4),(315,4,15,27,4),(316,4,15,28,4),(317,4,15,29,4),(318,5,15,31,4),(319,5,15,32,4),(320,9,15,33,4),(321,6,15,37,4),(322,3,15,1,5),(323,3,15,2,5),(324,3,15,3,5),(325,3,15,4,5),(326,3,15,5,5),(327,4,15,23,5),(328,4,15,24,5),(329,4,15,25,5),(330,4,15,26,5),(331,4,15,27,5),(332,4,15,28,5),(333,6,15,37,5),(334,3,15,0,6),(335,3,15,1,6),(336,3,15,2,6),(337,4,15,23,6),(338,4,15,24,6),(339,4,15,25,6),(340,4,15,27,6),(341,3,15,0,7),(342,3,15,1,7),(343,7,15,23,7),(344,4,15,25,7),(345,3,15,1,8),(346,0,15,2,8),(347,7,15,23,8),(348,7,15,24,8),(349,4,15,25,8),(350,7,15,23,9),(351,7,15,24,9),(352,7,15,25,9),(353,4,15,14,10),(354,4,15,15,10),(355,4,15,16,10),(356,4,15,17,10),(357,7,15,21,10),(358,7,15,22,10),(359,7,15,23,10),(360,7,15,24,10),(361,7,15,25,10),(362,7,15,26,10),(363,4,15,14,11),(364,4,15,15,11),(365,4,15,16,11),(366,4,15,17,11),(367,6,15,18,11),(368,6,15,19,11),(369,7,15,21,11),(370,7,15,22,11),(371,7,15,23,11),(372,7,15,24,11),(373,10,15,25,11),(374,8,15,6,12),(375,4,15,12,12),(376,4,15,13,12),(377,4,15,14,12),(378,4,15,15,12),(379,6,15,18,12),(380,6,15,19,12),(381,6,15,20,12),(382,7,15,22,12),(383,7,15,24,12),(384,14,15,2,13),(385,0,15,9,13),(386,4,15,12,13),(387,4,15,13,13),(388,4,15,15,13),(389,4,15,16,13),(390,4,15,17,13),(391,4,15,18,13),(392,6,15,19,13),(393,7,15,22,13),(394,5,15,29,13),(395,4,15,0,14),(396,4,15,14,14),(397,4,15,15,14),(398,4,15,16,14),(399,4,15,17,14),(400,6,15,19,14),(401,6,15,20,14),(402,6,15,22,14),(403,5,15,29,14),(404,8,15,30,14),(405,4,15,0,15),(406,4,15,1,15),(407,5,15,6,15),(408,5,15,7,15),(409,5,15,8,15),(410,5,15,9,15),(411,4,15,15,15),(412,4,15,16,15),(413,4,15,17,15),(414,6,15,18,15),(415,6,15,19,15),(416,6,15,20,15),(417,6,15,21,15),(418,6,15,22,15),(419,11,15,23,15),(420,5,15,27,15),(421,5,15,28,15),(422,5,15,29,15),(423,4,15,0,16),(424,4,15,1,16),(425,5,15,7,16),(426,5,15,8,16),(427,5,15,9,16),(428,5,15,10,16),(429,4,15,15,16),(430,4,15,17,16),(431,3,15,18,16),(432,3,15,19,16),(433,3,15,20,16),(434,3,15,21,16),(435,5,15,27,16),(436,5,15,29,16),(437,4,15,0,17),(438,4,15,1,17),(439,4,15,2,17),(440,5,15,7,17),(441,3,15,16,17),(442,3,15,17,17),(443,3,15,18,17),(444,3,15,19,17),(445,3,15,20,17),(446,5,15,27,17),(447,5,15,28,17),(448,6,15,29,17),(449,6,15,31,17),(450,6,15,32,17),(451,2,15,34,17),(452,4,15,0,18),(453,4,15,1,18),(454,4,15,2,18),(455,4,15,3,18),(456,4,15,4,18),(457,3,15,17,18),(458,3,15,18,18),(459,3,15,20,18),(460,3,15,21,18),(461,3,15,22,18),(462,5,15,28,18),(463,6,15,29,18),(464,6,15,30,18),(465,6,15,31,18),(466,4,15,0,19),(467,4,15,1,19),(468,4,15,2,19),(469,12,15,5,19),(470,3,15,16,19),(471,3,15,17,19),(472,3,15,18,19),(473,3,15,20,19),(474,3,15,22,19),(475,6,15,27,19),(476,6,15,28,19),(477,6,15,29,19),(478,6,15,30,19),(479,3,15,34,19),(480,3,15,35,19),(481,3,15,36,19),(482,3,15,37,19),(483,4,15,0,20),(484,4,15,1,20),(485,4,15,2,20),(486,3,15,16,20),(487,7,15,27,20),(488,7,15,28,20),(489,6,15,29,20),(490,6,15,30,20),(491,3,15,34,20),(492,3,15,35,20),(493,3,15,36,20),(494,3,15,37,20),(495,4,15,0,21),(496,3,15,25,21),(497,3,15,26,21),(498,3,15,27,21),(499,7,15,28,21),(500,7,15,29,21),(501,6,15,30,21),(502,3,15,31,21),(503,3,15,33,21),(504,3,15,34,21),(505,3,15,35,21),(506,3,15,36,21),(507,3,15,37,21),(508,4,15,0,22),(509,4,15,1,22),(510,4,15,2,22),(511,3,15,24,22),(512,3,15,25,22),(513,3,15,26,22),(514,3,15,27,22),(515,7,15,28,22),(516,7,15,29,22),(517,6,15,30,22),(518,3,15,31,22),(519,3,15,32,22),(520,3,15,33,22),(521,3,15,34,22),(522,3,15,35,22),(523,3,15,36,22),(524,4,15,0,23),(525,4,15,1,23),(526,4,15,2,23),(527,0,15,22,23),(528,3,15,24,23),(529,3,15,25,23),(530,3,15,26,23),(531,7,15,27,23),(532,7,15,28,23),(533,0,15,29,23),(534,0,15,31,23),(535,7,15,33,23),(536,4,15,0,24),(537,3,15,24,24),(538,3,15,25,24),(539,3,15,26,24),(540,3,15,27,24),(541,7,15,28,24),(542,7,15,33,24),(543,7,15,34,24),(544,3,15,22,25),(545,3,15,23,25),(546,3,15,24,25),(547,3,15,25,25),(548,3,15,26,25),(549,3,15,27,25),(550,7,15,28,25),(551,7,15,29,25),(552,7,15,30,25),(553,7,15,31,25),(554,7,15,32,25),(555,7,15,33,25),(556,7,17,14,0),(557,7,17,15,0),(558,7,17,16,0),(559,7,17,17,0),(560,7,17,18,0),(561,7,17,19,0),(562,4,17,32,0),(563,4,17,33,0),(564,6,17,36,0),(565,6,17,37,0),(566,6,17,38,0),(567,6,17,39,0),(568,2,17,41,0),(569,12,17,7,1),(570,7,17,14,1),(571,7,17,15,1),(572,7,17,16,1),(573,7,17,17,1),(574,0,17,18,1),(575,4,17,30,1),(576,4,17,31,1),(577,4,17,32,1),(578,4,17,33,1),(579,6,17,35,1),(580,6,17,36,1),(581,7,17,15,2),(582,7,17,17,2),(583,0,17,22,2),(584,4,17,30,2),(585,4,17,31,2),(586,4,17,32,2),(587,4,17,33,2),(588,6,17,35,2),(589,5,17,43,2),(590,7,17,17,3),(591,3,17,25,3),(592,3,17,26,3),(593,4,17,31,3),(594,4,17,32,3),(595,4,17,33,3),(596,4,17,34,3),(597,6,17,35,3),(598,6,17,36,3),(599,5,17,43,3),(600,5,17,44,3),(601,9,17,46,3),(602,3,17,0,4),(603,7,17,17,4),(604,7,17,18,4),(605,13,17,19,4),(606,3,17,25,4),(607,3,17,26,4),(608,3,17,27,4),(609,0,17,33,4),(610,6,17,35,4),(611,5,17,41,4),(612,5,17,42,4),(613,5,17,43,4),(614,3,17,0,5),(615,3,17,1,5),(616,3,17,2,5),(617,3,17,3,5),(618,7,17,16,5),(619,7,17,17,5),(620,3,17,25,5),(621,3,17,26,5),(622,3,17,27,5),(623,5,17,42,5),(624,5,17,43,5),(625,5,17,44,5),(626,5,17,45,5),(627,3,17,0,6),(628,3,17,1,6),(629,3,17,2,6),(630,3,17,3,6),(631,4,17,5,6),(632,3,17,26,6),(633,3,17,27,6),(634,2,17,32,6),(635,5,17,42,6),(636,5,17,43,6),(637,5,17,44,6),(638,5,17,45,6),(639,5,17,46,6),(640,4,17,49,6),(641,3,17,0,7),(642,3,17,1,7),(643,3,17,2,7),(644,4,17,4,7),(645,4,17,5,7),(646,3,17,26,7),(647,5,17,42,7),(648,5,17,43,7),(649,5,17,44,7),(650,5,17,45,7),(651,5,17,46,7),(652,4,17,49,7),(653,4,17,50,7),(654,3,17,0,8),(655,3,17,1,8),(656,3,17,2,8),(657,4,17,3,8),(658,4,17,5,8),(659,5,17,7,8),(660,4,17,19,8),(661,1,17,22,8),(662,3,17,26,8),(663,3,17,27,8),(664,5,17,41,8),(665,5,17,42,8),(666,5,17,43,8),(667,4,17,50,8),(668,3,17,0,9),(669,3,17,1,9),(670,3,17,2,9),(671,4,17,3,9),(672,4,17,4,9),(673,4,17,5,9),(674,4,17,6,9),(675,5,17,7,9),(676,0,17,10,9),(677,4,17,14,9),(678,4,17,19,9),(679,3,17,25,9),(680,3,17,26,9),(681,3,17,27,9),(682,10,17,35,9),(683,5,17,43,9),(684,5,17,44,9),(685,5,17,45,9),(686,4,17,49,9),(687,4,17,50,9),(688,5,17,0,10),(689,3,17,1,10),(690,4,17,2,10),(691,4,17,3,10),(692,4,17,4,10),(693,4,17,5,10),(694,4,17,6,10),(695,5,17,7,10),(696,5,17,8,10),(697,4,17,13,10),(698,4,17,14,10),(699,4,17,19,10),(700,4,17,20,10),(701,0,17,41,10),(702,0,17,43,10),(703,8,17,46,10),(704,4,17,49,10),(705,4,17,50,10),(706,5,17,0,11),(707,11,17,1,11),(708,5,17,5,11),(709,5,17,6,11),(710,5,17,7,11),(711,4,17,12,11),(712,4,17,13,11),(713,4,17,14,11),(714,4,17,18,11),(715,4,17,19,11),(716,4,17,20,11),(717,3,17,45,11),(718,4,17,50,11),(719,5,17,0,12),(720,5,17,5,12),(721,5,17,6,12),(722,5,17,7,12),(723,5,17,8,12),(724,4,17,9,12),(725,4,17,10,12),(726,4,17,11,12),(727,4,17,12,12),(728,5,17,13,12),(729,5,17,14,12),(730,1,17,16,12),(731,4,17,18,12),(732,4,17,19,12),(733,4,17,20,12),(734,4,17,21,12),(735,3,17,23,12),(736,3,17,24,12),(737,3,17,41,12),(738,3,17,42,12),(739,3,17,44,12),(740,3,17,45,12),(741,4,17,49,12),(742,4,17,50,12),(743,5,17,0,13),(744,5,17,5,13),(745,5,17,6,13),(746,5,17,7,13),(747,5,17,8,13),(748,5,17,9,13),(749,5,17,10,13),(750,4,17,11,13),(751,5,17,12,13),(752,5,17,13,13),(753,5,17,14,13),(754,5,17,15,13),(755,4,17,19,13),(756,3,17,21,13),(757,3,17,22,13),(758,3,17,23,13),(759,3,17,24,13),(760,3,17,40,13),(761,3,17,41,13),(762,3,17,42,13),(763,3,17,43,13),(764,3,17,44,13),(765,3,17,45,13),(766,4,17,49,13),(767,5,17,0,14),(768,5,17,5,14),(769,5,17,7,14),(770,14,17,8,14),(771,4,17,11,14),(772,5,17,12,14),(773,5,17,13,14),(774,5,17,14,14),(775,5,17,15,14),(776,5,17,16,14),(777,5,17,17,14),(778,5,17,18,14),(779,4,17,19,14),(780,3,17,20,14),(781,3,17,21,14),(782,3,17,22,14),(783,3,17,23,14),(784,3,17,24,14),(785,0,17,34,14),(786,3,17,40,14),(787,3,17,41,14),(788,3,17,42,14),(789,3,17,43,14),(790,3,17,44,14),(791,3,17,45,14),(792,4,17,49,14),(793,5,17,0,15),(794,5,17,5,15),(795,5,17,6,15),(796,5,17,7,15),(797,4,17,11,15),(798,4,17,12,15),(799,5,17,13,15),(800,5,17,14,15),(801,5,17,15,15),(802,5,17,17,15),(803,4,17,19,15),(804,3,17,20,15),(805,3,17,21,15),(806,3,17,23,15),(807,3,17,24,15),(808,3,17,25,15),(809,3,17,44,15),(810,6,17,45,15),(811,6,17,47,15),(812,6,17,48,15),(813,4,17,49,15),(814,5,17,0,16),(815,5,17,5,16),(816,5,17,6,16),(817,5,17,7,16),(818,5,17,14,16),(819,5,17,17,16),(820,5,17,18,16),(821,3,17,23,16),(822,3,17,24,16),(823,3,17,25,16),(824,3,17,44,16),(825,6,17,45,16),(826,6,17,46,16),(827,6,17,47,16),(828,5,17,0,17),(829,5,17,1,17),(830,5,17,2,17),(831,5,17,3,17),(832,5,17,4,17),(833,5,17,5,17),(834,5,17,6,17),(835,5,17,7,17),(836,5,17,14,17),(837,5,17,18,17),(838,7,17,23,17),(839,7,17,24,17),(840,7,17,25,17),(841,7,17,26,17),(842,7,17,28,17),(843,7,17,29,17),(844,0,17,42,17),(845,6,17,44,17),(846,6,17,45,17),(847,6,17,46,17),(848,6,17,47,17),(849,5,17,0,18),(850,5,17,1,18),(851,5,17,2,18),(852,5,17,3,18),(853,5,17,4,18),(854,5,17,5,18),(855,5,17,6,18),(856,5,17,18,18),(857,7,17,25,18),(858,7,17,26,18),(859,7,17,27,18),(860,7,17,28,18),(861,6,17,44,18),(862,6,17,45,18),(863,6,17,46,18),(864,6,17,47,18),(865,5,17,0,19),(866,5,17,1,19),(867,5,17,2,19),(868,5,17,3,19),(869,5,17,5,19),(870,7,17,24,19),(871,7,17,25,19),(872,7,17,26,19),(873,7,17,27,19),(874,7,17,28,19),(875,7,17,29,19),(876,6,17,42,19),(877,6,17,43,19),(878,6,17,44,19),(879,6,17,45,19),(880,6,17,46,19),(881,6,17,47,19),(882,9,22,4,0),(883,5,22,10,0),(884,6,22,11,0),(885,5,22,12,0),(886,7,22,13,0),(887,7,22,14,0),(888,7,22,15,0),(889,7,22,16,0),(890,7,22,19,0),(891,5,22,9,1),(892,5,22,10,1),(893,5,22,11,1),(894,5,22,12,1),(895,7,22,13,1),(896,7,22,14,1),(897,7,22,15,1),(898,7,22,16,1),(899,7,22,17,1),(900,7,22,18,1),(901,7,22,19,1),(902,7,22,20,1),(903,2,22,27,1),(904,4,22,8,2),(905,4,22,9,2),(906,4,22,10,2),(907,5,22,12,2),(908,5,22,13,2),(909,5,22,14,2),(910,7,22,15,2),(911,7,22,16,2),(912,7,22,17,2),(913,7,22,18,2),(914,11,22,19,2),(915,0,22,5,3),(916,4,22,9,3),(917,4,22,10,3),(918,5,22,11,3),(919,5,22,12,3),(920,5,22,14,3),(921,5,22,15,3),(922,14,22,16,3),(923,11,22,26,3),(924,6,22,2,4),(925,5,22,12,4),(926,5,22,13,4),(927,5,22,14,4),(928,5,22,15,4),(929,6,22,31,4),(930,6,22,32,4),(931,6,22,33,4),(932,6,22,2,5),(933,0,22,12,5),(934,5,22,14,5),(935,6,22,31,5),(936,6,22,2,6),(937,4,22,3,6),(938,4,22,4,6),(939,0,22,10,6),(940,4,22,15,6),(941,6,22,30,6),(942,6,22,31,6),(943,5,22,32,6),(944,5,22,33,6),(945,5,22,34,6),(946,6,22,2,7),(947,4,22,3,7),(948,4,22,4,7),(949,0,22,6,7),(950,4,22,12,7),(951,4,22,13,7),(952,4,22,14,7),(953,4,22,15,7),(954,4,22,16,7),(955,4,22,17,7),(956,4,22,18,7),(957,3,22,23,7),(958,6,22,30,7),(959,5,22,33,7),(960,5,22,34,7),(961,4,22,2,8),(962,4,22,3,8),(963,3,22,11,8),(964,3,22,13,8),(965,4,22,15,8),(966,4,22,16,8),(967,12,22,17,8),(968,3,22,23,8),(969,3,22,24,8),(970,6,22,30,8),(971,4,22,31,8),(972,4,22,32,8),(973,5,22,33,8),(974,5,22,34,8),(975,4,22,1,9),(976,4,22,2,9),(977,4,22,3,9),(978,3,22,11,9),(979,3,22,12,9),(980,3,22,13,9),(981,3,22,14,9),(982,4,22,16,9),(983,3,22,23,9),(984,12,22,24,9),(985,6,22,30,9),(986,4,22,31,9),(987,5,22,32,9),(988,5,22,33,9),(989,5,22,34,9),(990,4,22,2,10),(991,10,22,13,10),(992,3,22,23,10),(993,4,22,31,10),(994,5,22,32,10),(995,5,22,34,10),(996,1,22,2,11),(997,5,22,12,11),(998,3,22,23,11),(999,4,22,30,11),(1000,4,22,31,11),(1001,4,22,32,11),(1002,4,22,33,11),(1003,5,22,34,11),(1004,0,22,5,12),(1005,3,22,7,12),(1006,5,22,12,12),(1007,3,22,23,12),(1008,4,22,30,12),(1009,5,22,34,12),(1010,3,22,3,13),(1011,3,22,4,13),(1012,3,22,7,13),(1013,3,22,8,13),(1014,3,22,9,13),(1015,5,22,10,13),(1016,5,22,11,13),(1017,5,22,12,13),(1018,4,22,30,13),(1019,6,22,32,13),(1020,5,22,34,13),(1021,8,22,0,14),(1022,3,22,3,14),(1023,3,22,4,14),(1024,3,22,5,14),(1025,3,22,8,14),(1026,3,22,9,14),(1027,3,22,10,14),(1028,5,22,11,14),(1029,5,22,12,14),(1030,5,22,13,14),(1031,5,22,14,14),(1032,5,22,15,14),(1033,6,22,30,14),(1034,6,22,31,14),(1035,6,22,32,14),(1036,5,22,33,14),(1037,5,22,34,14),(1038,3,22,3,15),(1039,5,22,8,15),(1040,5,22,9,15),(1041,5,22,10,15),(1042,5,22,11,15),(1043,5,22,12,15),(1044,5,22,13,15),(1045,5,22,14,15),(1046,5,22,15,15),(1047,13,22,20,15),(1048,6,22,31,15),(1049,3,22,3,16),(1050,0,22,27,16),(1051,2,22,0,17),(1052,4,22,5,17),(1053,4,22,6,17),(1054,1,22,12,17),(1055,3,22,22,17),(1056,3,22,23,17),(1057,3,22,24,17),(1058,3,22,25,17),(1059,3,22,26,17),(1060,6,22,32,17),(1061,6,22,33,17),(1062,6,22,34,17),(1063,4,22,5,18),(1064,4,22,6,18),(1065,4,22,7,18),(1066,3,22,23,18),(1067,6,22,33,18),(1068,4,22,2,19),(1069,4,22,3,19),(1070,4,22,4,19),(1071,4,22,5,19),(1072,4,22,6,19),(1073,3,22,23,19),(1074,6,22,33,19),(1075,5,25,3,0),(1076,5,25,4,0),(1077,5,25,5,0),(1078,7,25,6,0),(1079,7,25,7,0),(1080,7,25,8,0),(1081,7,25,9,0),(1082,7,25,10,0),(1083,7,25,11,0),(1084,7,25,12,0),(1085,7,25,13,0),(1086,5,25,16,0),(1087,5,25,17,0),(1088,5,25,18,0),(1089,5,25,19,0),(1090,5,25,20,0),(1091,5,25,21,0),(1092,5,25,22,0),(1093,5,25,23,0),(1094,5,25,24,0),(1095,3,25,30,0),(1096,3,25,32,0),(1097,3,25,33,0),(1098,3,25,34,0),(1099,5,25,1,1),(1100,5,25,2,1),(1101,5,25,3,1),(1102,5,25,4,1),(1103,5,25,5,1),(1104,5,25,7,1),(1105,5,25,8,1),(1106,7,25,9,1),(1107,7,25,10,1),(1108,7,25,11,1),(1109,7,25,12,1),(1110,0,25,13,1),(1111,5,25,16,1),(1112,5,25,17,1),(1113,5,25,18,1),(1114,5,25,19,1),(1115,0,25,20,1),(1116,5,25,22,1),(1117,5,25,23,1),(1118,5,25,24,1),(1119,5,25,25,1),(1120,3,25,30,1),(1121,3,25,31,1),(1122,3,25,32,1),(1123,3,25,33,1),(1124,3,25,34,1),(1125,3,25,35,1),(1126,3,25,36,1),(1127,5,25,2,2),(1128,5,25,3,2),(1129,5,25,4,2),(1130,5,25,5,2),(1131,5,25,6,2),(1132,5,25,7,2),(1133,7,25,8,2),(1134,7,25,9,2),(1135,7,25,10,2),(1136,3,25,11,2),(1137,3,25,12,2),(1138,5,25,16,2),(1139,5,25,17,2),(1140,5,25,18,2),(1141,5,25,22,2),(1142,5,25,23,2),(1143,5,25,24,2),(1144,5,25,25,2),(1145,5,25,26,2),(1146,1,25,28,2),(1147,3,25,30,2),(1148,3,25,31,2),(1149,3,25,32,2),(1150,3,25,33,2),(1151,10,25,34,2),(1152,5,25,3,3),(1153,5,25,5,3),(1154,5,25,6,3),(1155,7,25,7,3),(1156,7,25,8,3),(1157,3,25,9,3),(1158,3,25,10,3),(1159,3,25,12,3),(1160,5,25,17,3),(1161,5,25,18,3),(1162,5,25,19,3),(1163,5,25,20,3),(1164,5,25,21,3),(1165,5,25,22,3),(1166,5,25,23,3),(1167,5,25,24,3),(1168,4,25,25,3),(1169,3,25,30,3),(1170,3,25,31,3),(1171,3,25,32,3),(1172,3,25,33,3),(1173,5,25,6,4),(1174,7,25,7,4),(1175,3,25,8,4),(1176,3,25,9,4),(1177,3,25,10,4),(1178,3,25,11,4),(1179,3,25,12,4),(1180,3,25,13,4),(1181,3,25,14,4),(1182,3,25,15,4),(1183,5,25,16,4),(1184,5,25,17,4),(1185,5,25,18,4),(1186,5,25,22,4),(1187,5,25,23,4),(1188,5,25,24,4),(1189,4,25,25,4),(1190,4,25,26,4),(1191,9,25,29,4),(1192,4,25,2,5),(1193,5,25,6,5),(1194,3,25,11,5),(1195,3,25,12,5),(1196,3,25,13,5),(1197,3,25,14,5),(1198,3,25,15,5),(1199,7,25,16,5),(1200,5,25,17,5),(1201,5,25,18,5),(1202,5,25,19,5),(1203,5,25,23,5),(1204,4,25,25,5),(1205,4,25,26,5),(1206,4,25,27,5),(1207,4,25,1,6),(1208,4,25,2,6),(1209,4,25,4,6),(1210,4,25,5,6),(1211,5,25,6,6),(1212,3,25,13,6),(1213,5,25,14,6),(1214,5,25,15,6),(1215,7,25,16,6),(1216,5,25,17,6),(1217,5,25,18,6),(1218,5,25,23,6),(1219,4,25,24,6),(1220,4,25,25,6),(1221,4,25,26,6),(1222,4,25,27,6),(1223,4,25,28,6),(1224,4,25,1,7),(1225,4,25,2,7),(1226,4,25,3,7),(1227,4,25,4,7),(1228,4,25,5,7),(1229,5,25,6,7),(1230,5,25,14,7),(1231,5,25,16,7),(1232,5,25,17,7),(1233,5,25,18,7),(1234,5,25,23,7),(1235,4,25,24,7),(1236,4,25,27,7),(1237,4,25,28,7),(1238,4,25,1,8),(1239,4,25,2,8),(1240,4,25,3,8),(1241,4,25,5,8),(1242,7,25,10,8),(1243,5,25,13,8),(1244,5,25,14,8),(1245,5,25,15,8),(1246,5,25,16,8),(1247,5,25,17,8),(1248,4,25,24,8),(1249,4,25,28,8),(1250,4,25,4,9),(1251,4,25,5,9),(1252,4,25,6,9),(1253,4,25,7,9),(1254,4,25,8,9),(1255,7,25,10,9),(1256,7,25,11,9),(1257,5,25,13,9),(1258,5,25,14,9),(1259,5,25,15,9),(1260,5,25,16,9),(1261,5,25,17,9),(1262,5,25,18,9),(1263,4,25,24,9),(1264,0,25,25,9),(1265,13,25,29,9),(1266,6,25,3,10),(1267,6,25,4,10),(1268,4,25,5,10),(1269,4,25,6,10),(1270,4,25,7,10),(1271,4,25,8,10),(1272,7,25,10,10),(1273,3,25,13,10),(1274,5,25,14,10),(1275,5,25,17,10),(1276,5,25,18,10),(1277,5,25,19,10),(1278,6,25,1,11),(1279,6,25,2,11),(1280,6,25,3,11),(1281,6,25,4,11),(1282,4,25,5,11),(1283,4,25,7,11),(1284,4,25,8,11),(1285,7,25,10,11),(1286,7,25,11,11),(1287,3,25,13,11),(1288,5,25,14,11),(1289,12,25,25,11),(1290,6,25,1,12),(1291,6,25,2,12),(1292,6,25,3,12),(1293,4,25,4,12),(1294,4,25,5,12),(1295,7,25,9,12),(1296,7,25,10,12),(1297,7,25,11,12),(1298,7,25,12,12),(1299,3,25,13,12),(1300,3,25,14,12),(1301,3,25,15,12),(1302,3,25,16,12),(1303,6,25,2,13),(1304,6,25,3,13),(1305,6,25,4,13),(1306,4,25,5,13),(1307,7,25,9,13),(1308,7,25,10,13),(1309,7,25,11,13),(1310,3,25,13,13),(1311,3,25,14,13),(1312,3,25,15,13),(1313,3,25,16,13),(1314,6,25,3,14),(1315,6,25,4,14),(1316,4,25,5,14),(1317,7,25,8,14),(1318,7,25,9,14),(1319,7,25,10,14),(1320,6,25,11,14),(1321,3,25,12,14),(1322,3,25,13,14),(1323,3,25,14,14),(1324,3,25,15,14),(1325,0,25,3,15),(1326,6,25,7,15),(1327,6,25,8,15),(1328,6,25,9,15),(1329,6,25,10,15),(1330,6,25,11,15),(1331,3,25,14,15),(1332,3,25,15,15),(1333,0,25,33,15),(1334,6,25,5,16),(1335,6,25,6,16),(1336,6,25,7,16),(1337,6,25,8,16),(1338,6,25,9,16),(1339,6,25,10,16),(1340,3,25,13,16),(1341,3,25,14,16),(1342,14,25,20,16),(1343,2,25,3,17),(1344,6,25,6,17),(1345,6,25,7,17),(1346,4,25,9,17),(1347,4,25,10,17),(1348,11,25,6,18),(1349,4,25,10,18),(1350,4,25,11,18),(1351,4,25,12,18),(1352,4,25,13,18),(1353,2,25,24,18),(1354,12,25,32,18),(1355,4,25,3,19),(1356,4,25,11,19),(1357,4,25,12,19),(1358,4,25,3,20),(1359,4,25,12,20),(1360,4,25,13,20),(1361,4,25,14,20),(1362,8,25,18,20),(1363,6,25,24,20),(1364,0,25,29,20),(1365,4,25,2,21),(1366,4,25,3,21),(1367,4,25,4,21),(1368,4,25,5,21),(1369,4,25,10,21),(1370,4,25,11,21),(1371,4,25,12,21),(1372,6,25,21,21),(1373,6,25,22,21),(1374,6,25,24,21),(1375,3,25,38,21),(1376,4,25,0,22),(1377,4,25,1,22),(1378,4,25,2,22),(1379,4,25,3,22),(1380,4,25,4,22),(1381,4,25,5,22),(1382,4,25,10,22),(1383,4,25,11,22),(1384,6,25,22,22),(1385,6,25,23,22),(1386,6,25,24,22),(1387,6,25,25,22),(1388,6,25,26,22),(1389,6,25,27,22),(1390,3,25,30,22),(1391,3,25,31,22),(1392,3,25,38,22),(1393,4,25,1,23),(1394,4,25,2,23),(1395,4,25,3,23),(1396,4,25,10,23),(1397,6,25,24,23),(1398,6,25,25,23),(1399,3,25,29,23),(1400,3,25,30,23),(1401,3,25,31,23),(1402,3,25,38,23),(1403,4,25,2,24),(1404,4,25,3,24),(1405,6,25,25,24),(1406,6,25,26,24),(1407,3,25,28,24),(1408,3,25,29,24),(1409,3,25,30,24),(1410,3,25,31,24),(1411,3,25,32,24),(1412,3,25,33,24),(1413,3,25,34,24),(1414,3,25,35,24),(1415,3,25,36,24),(1416,3,25,37,24),(1417,3,25,38,24),(1418,11,28,3,0),(1419,4,28,22,0),(1420,4,28,23,0),(1421,7,28,24,0),(1422,7,28,25,0),(1423,7,28,26,0),(1424,7,28,27,0),(1425,7,28,28,0),(1426,5,28,29,0),(1427,5,28,30,0),(1428,5,28,31,0),(1429,5,28,32,0),(1430,3,28,36,0),(1431,3,28,37,0),(1432,3,28,38,0),(1433,4,28,22,1),(1434,4,28,23,1),(1435,7,28,24,1),(1436,4,28,25,1),(1437,7,28,26,1),(1438,7,28,27,1),(1439,5,28,28,1),(1440,5,28,30,1),(1441,5,28,31,1),(1442,5,28,32,1),(1443,3,28,35,1),(1444,3,28,36,1),(1445,3,28,37,1),(1446,3,28,38,1),(1447,3,28,39,1),(1448,3,28,40,1),(1449,3,28,41,1),(1450,14,28,15,2),(1451,4,28,22,2),(1452,4,28,23,2),(1453,4,28,24,2),(1454,4,28,25,2),(1455,4,28,26,2),(1456,5,28,27,2),(1457,5,28,28,2),(1458,5,28,29,2),(1459,5,28,30,2),(1460,5,28,31,2),(1461,3,28,35,2),(1462,3,28,36,2),(1463,3,28,37,2),(1464,3,28,38,2),(1465,1,28,10,3),(1466,10,28,18,3),(1467,4,28,22,3),(1468,4,28,23,3),(1469,4,28,24,3),(1470,4,28,26,3),(1471,4,28,27,3),(1472,4,28,28,3),(1473,3,28,34,3),(1474,3,28,35,3),(1475,3,28,36,3),(1476,3,28,37,3),(1477,9,28,38,3),(1478,3,28,2,4),(1479,4,28,22,4),(1480,4,28,23,4),(1481,6,28,27,4),(1482,3,28,37,4),(1483,3,28,0,5),(1484,3,28,1,5),(1485,3,28,2,5),(1486,12,28,7,5),(1487,5,28,14,5),(1488,4,28,22,5),(1489,4,28,23,5),(1490,4,28,24,5),(1491,4,28,25,5),(1492,6,28,27,5),(1493,6,28,29,5),(1494,3,28,1,6),(1495,3,28,2,6),(1496,3,28,3,6),(1497,3,28,4,6),(1498,3,28,5,6),(1499,3,28,6,6),(1500,5,28,14,6),(1501,5,28,15,6),(1502,4,28,24,6),(1503,6,28,27,6),(1504,6,28,28,6),(1505,6,28,29,6),(1506,7,28,34,6),(1507,9,28,40,6),(1508,3,28,0,7),(1509,3,28,1,7),(1510,3,28,2,7),(1511,0,28,3,7),(1512,7,28,5,7),(1513,3,28,6,7),(1514,5,28,13,7),(1515,5,28,14,7),(1516,5,28,15,7),(1517,5,28,16,7),(1518,6,28,26,7),(1519,6,28,27,7),(1520,6,28,28,7),(1521,7,28,33,7),(1522,7,28,34,7),(1523,3,28,1,8),(1524,3,28,2,8),(1525,7,28,5,8),(1526,3,28,6,8),(1527,5,28,13,8),(1528,5,28,14,8),(1529,0,28,23,8),(1530,7,28,27,8),(1531,7,28,28,8),(1532,7,28,32,8),(1533,7,28,33,8),(1534,7,28,34,8),(1535,3,28,1,9),(1536,3,28,2,9),(1537,7,28,3,9),(1538,7,28,4,9),(1539,7,28,5,9),(1540,7,28,6,9),(1541,5,28,14,9),(1542,5,28,15,9),(1543,5,28,16,9),(1544,5,28,17,9),(1545,7,28,28,9),(1546,7,28,29,9),(1547,7,28,30,9),(1548,5,28,32,9),(1549,7,28,33,9),(1550,7,28,34,9),(1551,6,28,42,9),(1552,6,28,43,9),(1553,6,28,44,9),(1554,3,28,0,10),(1555,3,28,1,10),(1556,3,28,2,10),(1557,7,28,3,10),(1558,7,28,4,10),(1559,7,28,5,10),(1560,7,28,6,10),(1561,5,28,13,10),(1562,5,28,14,10),(1563,0,28,25,10),(1564,7,28,27,10),(1565,7,28,28,10),(1566,7,28,29,10),(1567,5,28,32,10),(1568,5,28,33,10),(1569,4,28,41,10),(1570,6,28,42,10),(1571,6,28,43,10),(1572,6,28,44,10),(1573,3,28,0,11),(1574,3,28,1,11),(1575,12,28,2,11),(1576,11,28,10,11),(1577,2,28,14,11),(1578,7,28,28,11),(1579,5,28,31,11),(1580,5,28,32,11),(1581,0,28,33,11),(1582,4,28,39,11),(1583,4,28,41,11),(1584,4,28,42,11),(1585,6,28,43,11),(1586,6,28,44,11),(1587,3,28,0,12),(1588,3,28,1,12),(1589,6,28,24,12),(1590,6,28,25,12),(1591,8,28,26,12),(1592,5,28,31,12),(1593,5,28,32,12),(1594,4,28,38,12),(1595,4,28,39,12),(1596,4,28,40,12),(1597,4,28,41,12),(1598,4,28,42,12),(1599,4,28,43,12),(1600,4,28,44,12),(1601,3,28,0,13),(1602,3,28,1,13),(1603,14,28,14,13),(1604,6,28,23,13),(1605,6,28,24,13),(1606,5,28,25,13),(1607,5,28,32,13),(1608,5,28,33,13),(1609,5,28,34,13),(1610,5,28,35,13),(1611,4,28,38,13),(1612,4,28,40,13),(1613,4,28,41,13),(1614,4,28,42,13),(1615,4,28,43,13),(1616,4,28,44,13),(1617,3,28,0,14),(1618,3,28,1,14),(1619,6,28,22,14),(1620,6,28,23,14),(1621,6,28,24,14),(1622,5,28,25,14),(1623,5,28,32,14),(1624,5,28,33,14),(1625,5,28,34,14),(1626,4,28,38,14),(1627,4,28,39,14),(1628,4,28,40,14),(1629,4,28,41,14),(1630,4,28,42,14),(1631,4,28,43,14),(1632,4,28,44,14),(1633,3,28,0,15),(1634,3,28,1,15),(1635,0,28,8,15),(1636,6,28,23,15),(1637,6,28,24,15),(1638,5,28,25,15),(1639,13,28,27,15),(1640,5,28,34,15),(1641,4,28,38,15),(1642,4,28,39,15),(1643,4,28,40,15),(1644,4,28,41,15),(1645,4,28,43,15),(1646,4,28,44,15),(1647,3,28,0,16),(1648,3,28,1,16),(1649,5,28,22,16),(1650,5,28,23,16),(1651,5,28,24,16),(1652,5,28,25,16),(1653,5,28,26,16),(1654,4,28,37,16),(1655,4,28,38,16),(1656,4,28,39,16),(1657,4,28,40,16),(1658,4,28,41,16),(1659,4,28,42,16),(1660,4,28,43,16),(1661,4,28,44,16),(1662,3,28,0,17),(1663,3,28,1,17),(1664,3,28,2,17),(1665,6,28,3,17),(1666,6,28,4,17),(1667,6,28,5,17),(1668,6,28,6,17),(1669,6,28,7,17),(1670,6,28,8,17),(1671,6,28,9,17),(1672,6,28,10,17),(1673,6,28,11,17),(1674,5,28,24,17),(1675,5,28,25,17),(1676,5,28,26,17),(1677,5,28,27,17),(1678,5,28,28,17),(1679,5,28,29,17),(1680,5,28,30,17),(1681,4,28,36,17),(1682,4,28,37,17),(1683,4,28,38,17),(1684,4,28,39,17),(1685,4,28,40,17),(1686,4,28,41,17),(1687,5,34,0,0),(1688,5,34,1,0),(1689,5,34,2,0),(1690,5,34,3,0),(1691,5,34,4,0),(1692,5,34,0,1),(1693,5,34,1,1),(1694,5,34,2,1),(1695,5,34,3,1),(1696,5,34,4,1),(1697,5,34,5,1),(1698,5,34,34,1),(1699,5,34,40,1),(1700,5,34,41,1),(1701,13,34,42,1),(1702,5,34,0,2),(1703,5,34,1,2),(1704,5,34,2,2),(1705,5,34,3,2),(1706,5,34,4,2),(1707,5,34,34,2),(1708,5,34,39,2),(1709,5,34,40,2),(1710,5,34,41,2),(1711,5,34,0,3),(1712,5,34,1,3),(1713,5,34,2,3),(1714,5,34,3,3),(1715,5,34,4,3),(1716,5,34,5,3),(1717,5,34,29,3),(1718,5,34,34,3),(1719,5,34,36,3),(1720,5,34,37,3),(1721,5,34,38,3),(1722,5,34,39,3),(1723,5,34,40,3),(1724,5,34,41,3),(1725,5,34,42,3),(1726,5,34,43,3),(1727,0,34,44,3),(1728,5,34,0,4),(1729,5,34,1,4),(1730,5,34,2,4),(1731,5,34,3,4),(1732,4,34,9,4),(1733,5,34,28,4),(1734,5,34,29,4),(1735,5,34,30,4),(1736,5,34,34,4),(1737,5,34,35,4),(1738,5,34,37,4),(1739,5,34,38,4),(1740,5,34,39,4),(1741,5,34,40,4),(1742,5,34,41,4),(1743,5,34,42,4),(1744,5,34,43,4),(1745,5,34,1,5),(1746,5,34,2,5),(1747,5,34,3,5),(1748,5,34,4,5),(1749,4,34,8,5),(1750,4,34,9,5),(1751,4,34,10,5),(1752,4,34,11,5),(1753,3,34,15,5),(1754,3,34,16,5),(1755,3,34,17,5),(1756,3,34,18,5),(1757,3,34,20,5),(1758,5,34,28,5),(1759,5,34,29,5),(1760,5,34,30,5),(1761,5,34,32,5),(1762,5,34,35,5),(1763,5,34,37,5),(1764,5,34,39,5),(1765,5,34,40,5),(1766,5,34,41,5),(1767,5,34,42,5),(1768,5,34,44,5),(1769,5,34,0,6),(1770,5,34,1,6),(1771,0,34,2,6),(1772,4,34,8,6),(1773,4,34,9,6),(1774,4,34,11,6),(1775,3,34,16,6),(1776,3,34,17,6),(1777,3,34,18,6),(1778,3,34,19,6),(1779,3,34,20,6),(1780,5,34,28,6),(1781,5,34,29,6),(1782,5,34,30,6),(1783,5,34,31,6),(1784,5,34,32,6),(1785,5,34,33,6),(1786,5,34,34,6),(1787,5,34,35,6),(1788,5,34,37,6),(1789,5,34,38,6),(1790,5,34,40,6),(1791,5,34,42,6),(1792,5,34,43,6),(1793,5,34,44,6),(1794,7,34,4,7),(1795,7,34,5,7),(1796,7,34,6,7),(1797,4,34,9,7),(1798,4,34,10,7),(1799,4,34,11,7),(1800,4,34,12,7),(1801,3,34,15,7),(1802,3,34,16,7),(1803,3,34,17,7),(1804,3,34,18,7),(1805,3,34,20,7),(1806,3,34,21,7),(1807,5,34,27,7),(1808,5,34,28,7),(1809,5,34,29,7),(1810,5,34,30,7),(1811,5,34,31,7),(1812,5,34,32,7),(1813,5,34,33,7),(1814,5,34,34,7),(1815,5,34,35,7),(1816,5,34,36,7),(1817,5,34,37,7),(1818,5,34,38,7),(1819,9,34,42,7),(1820,9,34,1,8),(1821,7,34,5,8),(1822,7,34,6,8),(1823,4,34,8,8),(1824,4,34,11,8),(1825,4,34,12,8),(1826,4,34,13,8),(1827,3,34,16,8),(1828,3,34,17,8),(1829,4,34,18,8),(1830,4,34,19,8),(1831,4,34,20,8),(1832,4,34,21,8),(1833,4,34,22,8),(1834,4,34,25,8),(1835,5,34,26,8),(1836,5,34,27,8),(1837,5,34,28,8),(1838,5,34,29,8),(1839,5,34,30,8),(1840,5,34,31,8),(1841,5,34,32,8),(1842,5,34,33,8),(1843,5,34,34,8),(1844,5,34,35,8),(1845,5,34,36,8),(1846,5,34,37,8),(1847,5,34,38,8),(1848,5,34,39,8),(1849,7,34,5,9),(1850,7,34,6,9),(1851,7,34,7,9),(1852,4,34,8,9),(1853,4,34,9,9),(1854,4,34,10,9),(1855,4,34,11,9),(1856,4,34,12,9),(1857,4,34,13,9),(1858,4,34,14,9),(1859,4,34,15,9),(1860,3,34,16,9),(1861,3,34,17,9),(1862,4,34,18,9),(1863,4,34,19,9),(1864,4,34,20,9),(1865,4,34,22,9),(1866,4,34,24,9),(1867,4,34,25,9),(1868,12,34,27,9),(1869,5,34,33,9),(1870,5,34,35,9),(1871,5,34,36,9),(1872,5,34,37,9),(1873,5,34,39,9),(1874,5,34,40,9),(1875,7,34,5,10),(1876,7,34,6,10),(1877,7,34,7,10),(1878,7,34,8,10),(1879,0,34,9,10),(1880,4,34,11,10),(1881,4,34,12,10),(1882,4,34,13,10),(1883,3,34,15,10),(1884,3,34,16,10),(1885,3,34,17,10),(1886,4,34,18,10),(1887,4,34,19,10),(1888,4,34,20,10),(1889,4,34,21,10),(1890,4,34,22,10),(1891,4,34,23,10),(1892,4,34,24,10),(1893,4,34,25,10),(1894,4,34,26,10),(1895,5,34,33,10),(1896,5,34,34,10),(1897,5,34,35,10),(1898,5,34,36,10),(1899,5,34,37,10),(1900,5,34,38,10),(1901,5,34,39,10),(1902,7,34,1,11),(1903,7,34,2,11),(1904,7,34,3,11),(1905,7,34,4,11),(1906,7,34,5,11),(1907,7,34,6,11),(1908,7,34,7,11),(1909,4,34,11,11),(1910,6,34,13,11),(1911,3,34,15,11),(1912,3,34,16,11),(1913,3,34,17,11),(1914,3,34,18,11),(1915,4,34,20,11),(1916,4,34,22,11),(1917,4,34,23,11),(1918,4,34,24,11),(1919,4,34,25,11),(1920,4,34,26,11),(1921,5,34,33,11),(1922,5,34,37,11),(1923,5,34,38,11),(1924,7,34,1,12),(1925,7,34,2,12),(1926,7,34,3,12),(1927,7,34,4,12),(1928,7,34,5,12),(1929,11,34,6,12),(1930,4,34,10,12),(1931,4,34,11,12),(1932,6,34,13,12),(1933,6,34,14,12),(1934,6,34,15,12),(1935,3,34,16,12),(1936,4,34,22,12),(1937,4,34,23,12),(1938,4,34,24,12),(1939,7,34,1,13),(1940,7,34,2,13),(1941,7,34,3,13),(1942,7,34,4,13),(1943,7,34,5,13),(1944,6,34,11,13),(1945,6,34,13,13),(1946,3,34,15,13),(1947,3,34,16,13),(1948,4,34,18,13),(1949,4,34,19,13),(1950,4,34,20,13),(1951,4,34,21,13),(1952,4,34,24,13),(1953,7,34,1,14),(1954,7,34,2,14),(1955,7,34,4,14),(1956,6,34,10,14),(1957,6,34,11,14),(1958,6,34,12,14),(1959,6,34,13,14),(1960,4,34,18,14),(1961,4,34,19,14),(1962,4,34,20,14),(1963,4,34,23,14),(1964,4,34,24,14),(1965,7,34,1,15),(1966,6,34,10,15),(1967,6,34,11,15),(1968,6,34,12,15),(1969,6,34,13,15),(1970,6,34,14,15),(1971,6,34,15,15),(1972,6,34,16,15),(1973,4,34,19,15),(1974,4,34,20,15),(1975,4,34,22,15),(1976,4,34,23,15),(1977,4,34,24,15),(1978,2,34,28,15),(1979,0,34,46,15),(1980,7,34,1,16),(1981,6,34,10,16),(1982,6,34,11,16),(1983,6,34,12,16),(1984,6,34,13,16),(1985,6,34,14,16),(1986,6,34,16,16),(1987,4,34,17,16),(1988,4,34,18,16),(1989,4,34,19,16),(1990,4,34,20,16),(1991,4,34,21,16),(1992,4,34,22,16),(1993,4,34,23,16),(1994,4,34,24,16),(1995,4,34,25,16),(1996,3,34,39,16),(1997,6,34,10,17),(1998,6,34,11,17),(1999,6,34,12,17),(2000,6,34,13,17),(2001,6,34,14,17),(2002,6,34,15,17),(2003,4,34,20,17),(2004,4,34,21,17),(2005,4,34,22,17),(2006,4,34,24,17),(2007,4,34,25,17),(2008,0,34,28,17),(2009,3,34,37,17),(2010,3,34,38,17),(2011,3,34,39,17),(2012,3,34,40,17),(2013,6,34,10,18),(2014,6,34,11,18),(2015,6,34,12,18),(2016,10,34,13,18),(2017,4,34,21,18),(2018,3,34,35,18),(2019,3,34,36,18),(2020,3,34,37,18),(2021,3,34,42,18),(2022,3,34,43,18),(2023,7,34,46,18),(2024,7,34,47,18),(2025,7,34,48,18),(2026,1,34,0,19),(2027,6,34,9,19),(2028,6,34,10,19),(2029,6,34,11,19),(2030,6,34,12,19),(2031,14,34,21,19),(2032,0,34,29,19),(2033,8,34,33,19),(2034,3,34,36,19),(2035,3,34,38,19),(2036,3,34,39,19),(2037,3,34,42,19),(2038,3,34,43,19),(2039,7,34,44,19),(2040,7,34,45,19),(2041,7,34,46,19),(2042,7,34,47,19),(2043,7,34,48,19),(2044,0,34,7,20),(2045,6,34,9,20),(2046,6,34,10,20),(2047,6,34,11,20),(2048,6,34,12,20),(2049,3,34,36,20),(2050,3,34,37,20),(2051,3,34,38,20),(2052,3,34,39,20),(2053,3,34,41,20),(2054,3,34,42,20),(2055,3,34,43,20),(2056,3,34,45,20),(2057,7,34,46,20),(2058,7,34,47,20),(2059,7,34,48,20),(2060,6,34,9,21),(2061,6,34,10,21),(2062,6,34,11,21),(2063,6,34,12,21),(2064,4,34,17,21),(2065,3,34,32,21),(2066,3,34,36,21),(2067,3,34,37,21),(2068,3,34,38,21),(2069,3,34,39,21),(2070,3,34,40,21),(2071,3,34,41,21),(2072,3,34,42,21),(2073,3,34,43,21),(2074,3,34,44,21),(2075,3,34,45,21),(2076,3,34,46,21),(2077,3,34,47,21),(2078,7,34,48,21),(2079,6,34,6,22),(2080,6,34,7,22),(2081,6,34,10,22),(2082,4,34,11,22),(2083,4,34,12,22),(2084,4,34,13,22),(2085,4,34,14,22),(2086,4,34,15,22),(2087,4,34,16,22),(2088,4,34,17,22),(2089,14,34,18,22),(2090,3,34,32,22),(2091,3,34,33,22),(2092,3,34,34,22),(2093,3,34,35,22),(2094,3,34,36,22),(2095,3,34,37,22),(2096,3,34,39,22),(2097,3,34,40,22),(2098,3,34,41,22),(2099,3,34,42,22),(2100,3,34,43,22),(2101,3,34,44,22),(2102,3,34,45,22),(2103,3,34,47,22),(2104,7,34,48,22),(2105,6,34,7,23),(2106,6,34,8,23),(2107,6,34,9,23),(2108,6,34,10,23),(2109,6,34,11,23),(2110,4,34,13,23),(2111,4,34,14,23),(2112,4,34,15,23),(2113,4,34,16,23),(2114,4,34,17,23),(2115,3,34,32,23),(2116,3,34,34,23),(2117,3,34,35,23),(2118,3,34,36,23),(2119,3,34,39,23),(2120,7,34,41,23),(2121,3,34,42,23),(2122,3,34,43,23),(2123,8,34,44,23),(2124,7,34,47,23),(2125,7,34,48,23),(2126,6,34,6,24),(2127,6,34,7,24),(2128,6,34,8,24),(2129,6,34,9,24),(2130,6,34,10,24),(2131,4,34,11,24),(2132,4,34,12,24),(2133,4,34,13,24),(2134,4,34,14,24),(2135,4,34,15,24),(2136,4,34,16,24),(2137,4,34,17,24),(2138,1,34,29,24),(2139,3,34,34,24),(2140,7,34,39,24),(2141,7,34,40,24),(2142,7,34,41,24),(2143,0,34,42,24),(2144,7,34,47,24),(2145,7,34,48,24),(2146,6,34,6,25),(2147,6,34,7,25),(2148,6,34,8,25),(2149,6,34,9,25),(2150,6,34,10,25),(2151,4,34,11,25),(2152,4,34,12,25),(2153,4,34,13,25),(2154,4,34,14,25),(2155,4,34,15,25),(2156,4,34,16,25),(2157,4,34,17,25),(2158,7,34,39,25),(2159,7,34,40,25),(2160,7,34,41,25),(2161,7,34,47,25),(2162,7,34,48,25),(2163,6,34,6,26),(2164,6,34,7,26),(2165,6,34,8,26),(2166,6,34,9,26),(2167,6,34,10,26),(2168,6,34,11,26),(2169,4,34,12,26),(2170,4,34,13,26),(2171,4,34,15,26),(2172,7,34,41,26),(2173,7,34,42,26),(2174,7,34,43,26),(2175,7,34,44,26),(2176,7,34,45,26),(2177,7,34,46,26),(2178,7,34,47,26),(2179,7,34,48,26),(2180,6,37,6,0),(2181,6,37,7,0),(2182,6,37,8,0),(2183,6,37,9,0),(2184,6,37,10,0),(2185,6,37,11,0),(2186,7,37,15,0),(2187,7,37,16,0),(2188,7,37,17,0),(2189,7,37,18,0),(2190,7,37,19,0),(2191,7,37,20,0),(2192,7,37,21,0),(2193,7,37,22,0),(2194,7,37,23,0),(2195,0,37,25,0),(2196,3,37,39,0),(2197,3,37,40,0),(2198,3,37,41,0),(2199,3,37,42,0),(2200,3,37,43,0),(2201,4,37,3,1),(2202,4,37,4,1),(2203,4,37,5,1),(2204,6,37,7,1),(2205,6,37,8,1),(2206,7,37,16,1),(2207,7,37,17,1),(2208,7,37,18,1),(2209,7,37,19,1),(2210,7,37,20,1),(2211,7,37,21,1),(2212,7,37,22,1),(2213,0,37,29,1),(2214,3,37,39,1),(2215,3,37,40,1),(2216,3,37,41,1),(2217,3,37,42,1),(2218,3,37,43,1),(2219,3,37,44,1),(2220,3,37,45,1),(2221,5,37,46,1),(2222,4,37,4,2),(2223,4,37,5,2),(2224,6,37,6,2),(2225,6,37,7,2),(2226,7,37,17,2),(2227,6,37,18,2),(2228,7,37,19,2),(2229,7,37,20,2),(2230,7,37,21,2),(2231,7,37,22,2),(2232,5,37,34,2),(2233,3,37,37,2),(2234,3,37,39,2),(2235,3,37,40,2),(2236,3,37,41,2),(2237,3,37,42,2),(2238,5,37,43,2),(2239,3,37,44,2),(2240,5,37,45,2),(2241,5,37,46,2),(2242,4,37,0,3),(2243,4,37,1,3),(2244,4,37,3,3),(2245,4,37,4,3),(2246,6,37,6,3),(2247,0,37,10,3),(2248,6,37,15,3),(2249,6,37,16,3),(2250,6,37,18,3),(2251,7,37,19,3),(2252,14,37,20,3),(2253,5,37,31,3),(2254,5,37,32,3),(2255,5,37,34,3),(2256,5,37,35,3),(2257,3,37,36,3),(2258,3,37,37,3),(2259,3,37,38,3),(2260,3,37,39,3),(2261,3,37,40,3),(2262,3,37,41,3),(2263,3,37,42,3),(2264,5,37,43,3),(2265,5,37,44,3),(2266,5,37,45,3),(2267,5,37,46,3),(2268,4,37,1,4),(2269,4,37,2,4),(2270,4,37,3,4),(2271,4,37,4,4),(2272,5,37,5,4),(2273,5,37,6,4),(2274,5,37,7,4),(2275,5,37,8,4),(2276,5,37,9,4),(2277,6,37,15,4),(2278,6,37,16,4),(2279,6,37,17,4),(2280,6,37,18,4),(2281,6,37,19,4),(2282,5,37,31,4),(2283,5,37,32,4),(2284,5,37,33,4),(2285,5,37,34,4),(2286,5,37,35,4),(2287,5,37,36,4),(2288,5,37,38,4),(2289,3,37,39,4),(2290,3,37,40,4),(2291,3,37,41,4),(2292,3,37,42,4),(2293,5,37,43,4),(2294,5,37,44,4),(2295,5,37,45,4),(2296,5,37,46,4),(2297,4,37,1,5),(2298,4,37,2,5),(2299,5,37,3,5),(2300,5,37,4,5),(2301,5,37,5,5),(2302,5,37,6,5),(2303,5,37,7,5),(2304,5,37,8,5),(2305,11,37,9,5),(2306,6,37,17,5),(2307,6,37,18,5),(2308,0,37,28,5),(2309,5,37,31,5),(2310,5,37,32,5),(2311,5,37,34,5),(2312,5,37,35,5),(2313,5,37,36,5),(2314,5,37,37,5),(2315,5,37,38,5),(2316,5,37,39,5),(2317,3,37,40,5),(2318,5,37,42,5),(2319,5,37,44,5),(2320,5,37,46,5),(2321,4,37,0,6),(2322,4,37,1,6),(2323,5,37,3,6),(2324,5,37,4,6),(2325,5,37,6,6),(2326,5,37,7,6),(2327,5,37,8,6),(2328,5,37,34,6),(2329,5,37,35,6),(2330,3,37,39,6),(2331,3,37,40,6),(2332,5,37,42,6),(2333,5,37,43,6),(2334,5,37,44,6),(2335,5,37,3,7),(2336,5,37,5,7),(2337,5,37,6,7),(2338,5,37,7,7),(2339,5,37,8,7),(2340,4,37,14,7),(2341,4,37,15,7),(2342,3,37,39,7),(2343,3,37,40,7),(2344,5,37,44,7),(2345,8,37,1,8),(2346,5,37,5,8),(2347,2,37,7,8),(2348,4,37,13,8),(2349,4,37,15,8),(2350,6,37,28,8),(2351,6,37,29,8),(2352,6,37,30,8),(2353,3,37,38,8),(2354,3,37,39,8),(2355,3,37,40,8),(2356,3,37,41,8),(2357,5,37,44,8),(2358,4,37,13,9),(2359,4,37,14,9),(2360,4,37,15,9),(2361,14,37,16,9),(2362,10,37,26,9),(2363,6,37,30,9),(2364,3,37,37,9),(2365,3,37,38,9),(2366,3,37,39,9),(2367,3,37,40,9),(2368,5,37,43,9),(2369,5,37,44,9),(2370,4,37,5,10),(2371,4,37,6,10),(2372,4,37,7,10),(2373,4,37,13,10),(2374,4,37,14,10),(2375,4,37,15,10),(2376,2,37,19,10),(2377,6,37,30,10),(2378,6,37,31,10),(2379,3,37,38,10),(2380,3,37,39,10),(2381,3,37,41,10),(2382,4,37,6,11),(2383,4,37,7,11),(2384,4,37,8,11),(2385,4,37,9,11),(2386,4,37,10,11),(2387,0,37,11,11),(2388,4,37,13,11),(2389,4,37,14,11),(2390,4,37,15,11),(2391,6,37,31,11),(2392,6,37,32,11),(2393,0,37,36,11),(2394,3,37,38,11),(2395,3,37,39,11),(2396,3,37,41,11),(2397,4,37,6,12),(2398,4,37,7,12),(2399,4,37,9,12),(2400,4,37,10,12),(2401,4,37,13,12),(2402,4,37,14,12),(2403,4,37,15,12),(2404,7,37,19,12),(2405,7,37,20,12),(2406,7,37,21,12),(2407,7,37,23,12),(2408,6,37,30,12),(2409,6,37,31,12),(2410,6,37,32,12),(2411,3,37,35,12),(2412,3,37,38,12),(2413,3,37,39,12),(2414,3,37,41,12),(2415,3,37,42,12),(2416,4,37,9,13),(2417,4,37,10,13),(2418,4,37,15,13),(2419,7,37,18,13),(2420,7,37,20,13),(2421,7,37,22,13),(2422,7,37,23,13),(2423,7,37,24,13),(2424,12,37,29,13),(2425,3,37,35,13),(2426,3,37,36,13),(2427,3,37,37,13),(2428,3,37,38,13),(2429,3,37,39,13),(2430,3,37,40,13),(2431,3,37,41,13),(2432,3,37,42,13),(2433,3,37,43,13),(2434,3,37,44,13),(2435,3,37,45,13),(2436,7,37,18,14),(2437,7,37,19,14),(2438,7,37,20,14),(2439,7,37,21,14),(2440,7,37,22,14),(2441,7,37,23,14),(2442,7,37,24,14),(2443,3,37,35,14),(2444,3,37,36,14),(2445,3,37,37,14),(2446,3,37,38,14),(2447,3,37,39,14),(2448,3,37,40,14),(2449,3,37,41,14),(2450,3,37,42,14),(2451,3,37,43,14),(2452,3,37,45,14),(2453,4,37,2,15),(2454,4,37,3,15),(2455,4,37,4,15),(2456,7,37,17,15),(2457,7,37,18,15),(2458,6,37,19,15),(2459,7,37,20,15),(2460,7,37,21,15),(2461,6,37,22,15),(2462,7,37,23,15),(2463,13,37,35,15),(2464,3,37,41,15),(2465,5,37,42,15),(2466,3,37,43,15),(2467,3,37,44,15),(2468,3,37,45,15),(2469,4,37,2,16),(2470,4,37,3,16),(2471,4,37,4,16),(2472,4,37,5,16),(2473,4,37,6,16),(2474,7,37,18,16),(2475,6,37,19,16),(2476,6,37,20,16),(2477,6,37,21,16),(2478,6,37,22,16),(2479,9,37,23,16),(2480,3,37,41,16),(2481,5,37,42,16),(2482,3,37,43,16),(2483,3,37,44,16),(2484,4,37,1,17),(2485,4,37,2,17),(2486,4,37,3,17),(2487,4,37,4,17),(2488,1,37,14,17),(2489,6,37,19,17),(2490,6,37,20,17),(2491,6,37,21,17),(2492,5,37,41,17),(2493,5,37,42,17),(2494,5,37,43,17),(2495,3,37,44,17),(2496,3,37,45,17),(2497,3,37,46,17),(2498,4,37,0,18),(2499,4,37,1,18),(2500,4,37,4,18),(2501,6,37,19,18),(2502,5,37,39,18),(2503,5,37,40,18),(2504,5,37,41,18),(2505,5,37,42,18),(2506,5,37,43,18),(2507,5,37,44,18),(2508,5,37,45,18),(2509,3,37,46,18),(2510,4,37,1,19),(2511,4,37,2,19),(2512,6,37,19,19),(2513,5,37,38,19),(2514,5,37,39,19),(2515,5,37,40,19),(2516,5,37,41,19),(2517,5,37,42,19),(2518,5,37,43,19),(2519,5,37,45,19),(2520,5,38,33,0),(2521,5,38,34,0),(2522,5,38,35,0),(2523,5,38,36,0),(2524,5,38,37,0),(2525,0,38,38,0),(2526,5,38,42,0),(2527,5,38,33,1),(2528,5,38,34,1),(2529,5,38,35,1),(2530,5,38,36,1),(2531,5,38,37,1),(2532,5,38,42,1),(2533,5,38,43,1),(2534,2,38,6,2),(2535,12,38,13,2),(2536,9,38,24,2),(2537,5,38,34,2),(2538,5,38,36,2),(2539,5,38,37,2),(2540,5,38,38,2),(2541,5,38,39,2),(2542,5,38,40,2),(2543,5,38,41,2),(2544,5,38,43,2),(2545,5,38,44,2),(2546,6,38,1,3),(2547,5,38,35,3),(2548,5,38,36,3),(2549,5,38,39,3),(2550,5,38,40,3),(2551,5,38,41,3),(2552,5,38,42,3),(2553,5,38,43,3),(2554,5,38,44,3),(2555,5,38,45,3),(2556,5,38,46,3),(2557,1,38,50,3),(2558,6,38,0,4),(2559,6,38,1,4),(2560,11,38,29,4),(2561,5,38,33,4),(2562,5,38,34,4),(2563,5,38,35,4),(2564,5,38,36,4),(2565,5,38,37,4),(2566,5,38,38,4),(2567,7,38,39,4),(2568,5,38,40,4),(2569,5,38,41,4),(2570,5,38,42,4),(2571,5,38,43,4),(2572,5,38,44,4),(2573,5,38,45,4),(2574,6,38,1,5),(2575,4,38,10,5),(2576,5,38,26,5),(2577,5,38,34,5),(2578,5,38,35,5),(2579,5,38,36,5),(2580,7,38,37,5),(2581,7,38,38,5),(2582,7,38,39,5),(2583,7,38,40,5),(2584,5,38,41,5),(2585,5,38,42,5),(2586,4,38,43,5),(2587,4,38,44,5),(2588,4,38,45,5),(2589,6,38,0,6),(2590,6,38,1,6),(2591,4,38,7,6),(2592,4,38,8,6),(2593,4,38,9,6),(2594,4,38,10,6),(2595,5,38,22,6),(2596,5,38,23,6),(2597,5,38,25,6),(2598,5,38,26,6),(2599,5,38,34,6),(2600,7,38,35,6),(2601,7,38,36,6),(2602,7,38,37,6),(2603,7,38,38,6),(2604,7,38,39,6),(2605,7,38,40,6),(2606,7,38,41,6),(2607,5,38,42,6),(2608,4,38,43,6),(2609,4,38,44,6),(2610,4,38,45,6),(2611,6,38,1,7),(2612,4,38,10,7),(2613,5,38,21,7),(2614,5,38,22,7),(2615,5,38,23,7),(2616,5,38,24,7),(2617,5,38,25,7),(2618,7,38,35,7),(2619,7,38,36,7),(2620,7,38,38,7),(2621,7,38,39,7),(2622,4,38,40,7),(2623,4,38,41,7),(2624,4,38,42,7),(2625,4,38,43,7),(2626,4,38,44,7),(2627,4,38,45,7),(2628,4,38,46,7),(2629,0,38,50,7),(2630,3,38,52,7),(2631,4,38,9,8),(2632,4,38,10,8),(2633,7,38,16,8),(2634,7,38,17,8),(2635,5,38,18,8),(2636,5,38,19,8),(2637,5,38,22,8),(2638,5,38,23,8),(2639,5,38,24,8),(2640,5,38,25,8),(2641,7,38,36,8),(2642,8,38,37,8),(2643,4,38,44,8),(2644,4,38,46,8),(2645,4,38,47,8),(2646,3,38,52,8),(2647,4,38,9,9),(2648,4,38,10,9),(2649,4,38,11,9),(2650,4,38,12,9),(2651,7,38,14,9),(2652,7,38,16,9),(2653,7,38,17,9),(2654,5,38,18,9),(2655,5,38,19,9),(2656,5,38,20,9),(2657,5,38,21,9),(2658,5,38,22,9),(2659,5,38,23,9),(2660,5,38,24,9),(2661,5,38,25,9),(2662,14,38,26,9),(2663,5,38,42,9),(2664,5,38,43,9),(2665,14,38,45,9),(2666,3,38,49,9),(2667,3,38,50,9),(2668,3,38,51,9),(2669,3,38,52,9),(2670,4,38,8,10),(2671,4,38,9,10),(2672,4,38,10,10),(2673,4,38,12,10),(2674,7,38,13,10),(2675,7,38,14,10),(2676,7,38,15,10),(2677,7,38,16,10),(2678,7,38,17,10),(2679,5,38,22,10),(2680,5,38,23,10),(2681,5,38,24,10),(2682,4,38,29,10),(2683,4,38,30,10),(2684,4,38,31,10),(2685,4,38,32,10),(2686,5,38,41,10),(2687,5,38,42,10),(2688,3,38,48,10),(2689,3,38,49,10),(2690,3,38,50,10),(2691,3,38,51,10),(2692,3,38,52,10),(2693,4,38,8,11),(2694,0,38,12,11),(2695,7,38,14,11),(2696,7,38,15,11),(2697,1,38,16,11),(2698,0,38,21,11),(2699,4,38,30,11),(2700,4,38,31,11),(2701,4,38,32,11),(2702,11,38,33,11),(2703,3,38,38,11),(2704,5,38,40,11),(2705,5,38,41,11),(2706,5,38,42,11),(2707,0,38,43,11),(2708,10,38,48,11),(2709,3,38,52,11),(2710,4,38,7,12),(2711,4,38,8,12),(2712,4,38,9,12),(2713,4,38,10,12),(2714,4,38,11,12),(2715,7,38,15,12),(2716,4,38,30,12),(2717,4,38,31,12),(2718,4,38,32,12),(2719,3,38,38,12),(2720,5,38,39,12),(2721,5,38,40,12),(2722,5,38,41,12),(2723,5,38,42,12),(2724,3,38,52,12),(2725,4,38,7,13),(2726,4,38,8,13),(2727,4,38,9,13),(2728,4,38,10,13),(2729,4,38,11,13),(2730,7,38,15,13),(2731,7,38,16,13),(2732,7,38,17,13),(2733,0,38,22,13),(2734,4,38,27,13),(2735,4,38,28,13),(2736,4,38,29,13),(2737,4,38,30,13),(2738,4,38,31,13),(2739,4,38,32,13),(2740,3,38,38,13),(2741,5,38,40,13),(2742,5,38,41,13),(2743,5,38,42,13),(2744,5,38,43,13),(2745,5,38,44,13),(2746,5,38,45,13),(2747,5,38,46,13),(2748,5,38,47,13),(2749,4,38,9,14),(2750,4,38,10,14),(2751,6,38,11,14),(2752,6,38,12,14),(2753,8,38,15,14),(2754,0,38,26,14),(2755,9,38,29,14),(2756,3,38,38,14),(2757,5,38,41,14),(2758,5,38,42,14),(2759,5,38,43,14),(2760,5,38,44,14),(2761,5,38,45,14),(2762,5,38,46,14),(2763,6,38,7,15),(2764,6,38,8,15),(2765,4,38,10,15),(2766,6,38,11,15),(2767,6,38,12,15),(2768,6,38,13,15),(2769,3,38,21,15),(2770,3,38,37,15),(2771,3,38,38,15),(2772,5,38,42,15),(2773,5,38,43,15),(2774,13,38,44,15),(2775,3,38,50,15),(2776,3,38,52,15),(2777,6,38,5,16),(2778,6,38,6,16),(2779,6,38,7,16),(2780,4,38,10,16),(2781,6,38,11,16),(2782,6,38,12,16),(2783,3,38,19,16),(2784,3,38,20,16),(2785,3,38,21,16),(2786,3,38,22,16),(2787,3,38,23,16),(2788,3,38,24,16),(2789,3,38,37,16),(2790,3,38,38,16),(2791,3,38,39,16),(2792,3,38,40,16),(2793,3,38,50,16),(2794,3,38,51,16),(2795,3,38,52,16),(2796,6,38,6,17),(2797,6,38,7,17),(2798,6,38,8,17),(2799,4,38,10,17),(2800,6,38,12,17),(2801,3,38,17,17),(2802,3,38,18,17),(2803,3,38,19,17),(2804,3,38,20,17),(2805,3,38,21,17),(2806,3,38,22,17),(2807,3,38,38,17),(2808,3,38,39,17),(2809,3,38,40,17),(2810,3,38,47,17),(2811,3,38,48,17),(2812,3,38,49,17),(2813,3,38,50,17),(2814,3,38,51,17),(2815,3,38,52,17),(2816,9,39,7,0),(2817,4,39,11,0),(2818,6,39,28,0),(2819,6,39,29,0),(2820,6,39,30,0),(2821,4,39,31,0),(2822,4,39,32,0),(2823,4,39,33,0),(2824,3,39,4,1),(2825,3,39,5,1),(2826,4,39,11,1),(2827,6,39,29,1),(2828,4,39,31,1),(2829,4,39,32,1),(2830,4,39,33,1),(2831,4,39,34,1),(2832,3,39,4,2),(2833,3,39,5,2),(2834,3,39,6,2),(2835,4,39,11,2),(2836,4,39,12,2),(2837,6,39,26,2),(2838,6,39,27,2),(2839,6,39,28,2),(2840,6,39,29,2),(2841,4,39,30,2),(2842,4,39,31,2),(2843,4,39,32,2),(2844,4,39,33,2),(2845,4,39,34,2),(2846,11,39,42,2),(2847,3,39,0,3),(2848,3,39,1,3),(2849,0,39,2,3),(2850,3,39,4,3),(2851,3,39,6,3),(2852,4,39,7,3),(2853,4,39,9,3),(2854,4,39,10,3),(2855,4,39,11,3),(2856,4,39,12,3),(2857,4,39,13,3),(2858,7,39,18,3),(2859,7,39,19,3),(2860,7,39,20,3),(2861,6,39,27,3),(2862,4,39,28,3),(2863,4,39,29,3),(2864,4,39,30,3),(2865,4,39,31,3),(2866,4,39,32,3),(2867,4,39,33,3),(2868,4,39,34,3),(2869,3,39,0,4),(2870,3,39,1,4),(2871,3,39,4,4),(2872,3,39,5,4),(2873,4,39,6,4),(2874,4,39,7,4),(2875,4,39,8,4),(2876,4,39,9,4),(2877,4,39,10,4),(2878,4,39,11,4),(2879,7,39,19,4),(2880,4,39,28,4),(2881,0,39,30,4),(2882,4,39,32,4),(2883,4,39,33,4),(2884,3,39,0,5),(2885,3,39,1,5),(2886,3,39,2,5),(2887,3,39,3,5),(2888,3,39,4,5),(2889,3,39,5,5),(2890,3,39,6,5),(2891,3,39,7,5),(2892,4,39,8,5),(2893,4,39,9,5),(2894,4,39,11,5),(2895,4,39,12,5),(2896,0,39,15,5),(2897,7,39,19,5),(2898,6,39,20,5),(2899,6,39,21,5),(2900,6,39,22,5),(2901,4,39,27,5),(2902,4,39,28,5),(2903,4,39,29,5),(2904,4,39,32,5),(2905,3,39,0,6),(2906,3,39,1,6),(2907,3,39,2,6),(2908,3,39,3,6),(2909,3,39,5,6),(2910,3,39,6,6),(2911,3,39,7,6),(2912,4,39,8,6),(2913,4,39,12,6),(2914,4,39,13,6),(2915,7,39,19,6),(2916,7,39,20,6),(2917,7,39,21,6),(2918,6,39,22,6),(2919,6,39,23,6),(2920,4,39,27,6),(2921,4,39,28,6),(2922,4,39,29,6),(2923,4,39,30,6),(2924,4,39,31,6),(2925,3,39,0,7),(2926,3,39,1,7),(2927,3,39,2,7),(2928,3,39,3,7),(2929,3,39,4,7),(2930,3,39,5,7),(2931,3,39,6,7),(2932,3,39,7,7),(2933,3,39,8,7),(2934,7,39,17,7),(2935,7,39,18,7),(2936,7,39,19,7),(2937,7,39,20,7),(2938,7,39,21,7),(2939,7,39,22,7),(2940,6,39,23,7),(2941,6,39,24,7),(2942,6,39,25,7),(2943,4,39,28,7),(2944,4,39,29,7),(2945,4,39,30,7),(2946,4,39,31,7),(2947,4,39,32,7),(2948,3,39,0,8),(2949,3,39,1,8),(2950,3,39,3,8),(2951,3,39,7,8),(2952,10,39,14,8),(2953,7,39,18,8),(2954,7,39,19,8),(2955,7,39,20,8),(2956,7,39,21,8),(2957,7,39,22,8),(2958,7,39,23,8),(2959,6,39,24,8),(2960,4,39,29,8),(2961,4,39,30,8),(2962,4,39,31,8),(2963,3,39,2,9),(2964,3,39,3,9),(2965,7,39,19,9),(2966,7,39,21,9),(2967,7,39,22,9),(2968,7,39,23,9),(2969,7,39,24,9),(2970,4,39,30,9),(2971,4,39,31,9),(2972,4,39,32,9),(2973,5,39,19,10),(2974,7,39,20,10),(2975,7,39,21,10),(2976,7,39,22,10),(2977,7,39,23,10),(2978,7,39,24,10),(2979,4,39,32,10),(2980,13,39,40,10),(2981,6,39,4,11),(2982,6,39,6,11),(2983,5,39,18,11),(2984,5,39,19,11),(2985,5,39,20,11),(2986,2,39,21,11),(2987,6,39,4,12),(2988,6,39,5,12),(2989,6,39,6,12),(2990,5,39,17,12),(2991,5,39,18,12),(2992,5,39,19,12),(2993,9,39,24,12),(2994,3,39,39,12),(2995,3,39,40,12),(2996,3,39,41,12),(2997,3,39,42,12),(2998,3,39,43,12),(2999,2,39,1,13),(3000,6,39,3,13),(3001,6,39,4,13),(3002,6,39,5,13),(3003,6,39,6,13),(3004,5,39,16,13),(3005,5,39,17,13),(3006,5,39,18,13),(3007,5,39,19,13),(3008,3,39,38,13),(3009,3,39,39,13),(3010,3,39,40,13),(3011,3,39,41,13),(3012,3,39,42,13),(3013,3,39,43,13),(3014,3,39,44,13),(3015,4,39,4,14),(3016,5,39,16,14),(3017,5,39,17,14),(3018,5,39,19,14),(3019,3,39,36,14),(3020,3,39,37,14),(3021,3,39,38,14),(3022,3,39,39,14),(3023,3,39,40,14),(3024,3,39,41,14),(3025,3,39,43,14),(3026,3,39,44,14),(3027,3,39,45,14),(3028,4,39,1,15),(3029,4,39,2,15),(3030,4,39,4,15),(3031,5,39,16,15),(3032,5,39,17,15),(3033,5,39,18,15),(3034,3,39,26,15),(3035,3,39,27,15),(3036,3,39,28,15),(3037,3,39,30,15),(3038,3,39,37,15),(3039,3,39,39,15),(3040,3,39,40,15),(3041,3,39,41,15),(3042,3,39,42,15),(3043,3,39,43,15),(3044,3,39,44,15),(3045,3,39,45,15),(3046,3,39,46,15),(3047,4,39,0,16),(3048,4,39,1,16),(3049,4,39,2,16),(3050,4,39,3,16),(3051,4,39,4,16),(3052,0,39,11,16),(3053,5,39,15,16),(3054,5,39,16,16),(3055,5,39,17,16),(3056,5,39,18,16),(3057,5,39,19,16),(3058,5,39,20,16),(3059,3,39,25,16),(3060,3,39,26,16),(3061,3,39,27,16),(3062,3,39,28,16),(3063,3,39,30,16),(3064,3,39,31,16),(3065,3,39,32,16),(3066,3,39,37,16),(3067,3,39,40,16),(3068,3,39,41,16),(3069,3,39,42,16),(3070,3,39,43,16),(3071,3,39,45,16),(3072,3,39,46,16),(3073,4,39,0,17),(3074,4,39,1,17),(3075,4,39,2,17),(3076,4,39,3,17),(3077,4,39,4,17),(3078,8,39,7,17),(3079,5,39,16,17),(3080,5,39,18,17),(3081,5,39,19,17),(3082,5,39,20,17),(3083,5,39,21,17),(3084,5,39,22,17),(3085,5,39,23,17),(3086,5,39,24,17),(3087,3,39,26,17),(3088,3,39,27,17),(3089,3,39,28,17),(3090,3,39,29,17),(3091,3,39,30,17),(3092,3,39,31,17),(3093,3,39,37,17),(3094,3,39,39,17),(3095,3,39,40,17),(3096,8,39,41,17),(3097,4,39,0,18),(3098,4,39,1,18),(3099,4,39,2,18),(3100,4,39,3,18),(3101,5,39,18,18),(3102,5,39,19,18),(3103,5,39,20,18),(3104,5,39,21,18),(3105,3,39,24,18),(3106,3,39,25,18),(3107,3,39,26,18),(3108,3,39,27,18),(3109,5,39,28,18),(3110,3,39,29,18),(3111,3,39,30,18),(3112,3,39,31,18),(3113,3,39,39,18),(3114,3,39,40,18),(3115,4,39,0,19),(3116,4,39,1,19),(3117,11,39,2,19),(3118,5,39,18,19),(3119,5,39,19,19),(3120,5,39,20,19),(3121,3,39,23,19),(3122,3,39,24,19),(3123,3,39,25,19),(3124,3,39,26,19),(3125,5,39,27,19),(3126,5,39,28,19),(3127,3,39,29,19),(3128,3,39,30,19),(3129,3,39,31,19),(3130,3,39,32,19),(3131,3,39,39,19),(3132,1,39,44,19),(3133,4,39,1,20),(3134,6,39,17,20),(3135,3,39,23,20),(3136,3,39,24,20),(3137,3,39,26,20),(3138,5,39,27,20),(3139,5,39,28,20),(3140,3,39,29,20),(3141,3,39,30,20),(3142,3,39,31,20),(3143,3,39,32,20),(3144,3,39,33,20),(3145,4,39,0,21),(3146,4,39,1,21),(3147,6,39,16,21),(3148,6,39,17,21),(3149,3,39,24,21),(3150,5,39,25,21),(3151,5,39,26,21),(3152,5,39,27,21),(3153,5,39,28,21),(3154,5,39,29,21),(3155,5,39,30,21),(3156,3,39,31,21),(3157,5,39,35,21),(3158,0,39,0,22),(3159,10,39,11,22),(3160,6,39,16,22),(3161,6,39,17,22),(3162,6,39,18,22),(3163,6,39,19,22),(3164,5,39,23,22),(3165,5,39,24,22),(3166,5,39,25,22),(3167,5,39,26,22),(3168,5,39,27,22),(3169,5,39,28,22),(3170,5,39,29,22),(3171,5,39,30,22),(3172,3,39,31,22),(3173,5,39,32,22),(3174,5,39,33,22),(3175,5,39,35,22),(3176,5,39,36,22),(3177,4,39,45,22),(3178,6,39,16,23),(3179,6,39,17,23),(3180,5,39,24,23),(3181,5,39,26,23),(3182,5,39,27,23),(3183,5,39,28,23),(3184,5,39,29,23),(3185,5,39,30,23),(3186,5,39,31,23),(3187,5,39,32,23),(3188,5,39,33,23),(3189,5,39,34,23),(3190,5,39,35,23),(3191,5,39,36,23),(3192,5,39,37,23),(3193,4,39,45,23),(3194,4,39,46,23),(3195,5,39,26,24),(3196,5,39,27,24),(3197,5,39,28,24),(3198,5,39,29,24),(3199,5,39,30,24),(3200,5,39,31,24),(3201,5,39,32,24),(3202,5,39,33,24),(3203,5,39,34,24),(3204,5,39,35,24),(3205,5,39,36,24),(3206,5,39,37,24),(3207,14,39,39,24),(3208,4,39,43,24),(3209,4,39,44,24),(3210,4,39,45,24),(3211,4,39,46,24),(3212,6,39,0,25),(3213,5,39,28,25),(3214,5,39,29,25),(3215,5,39,30,25),(3216,5,39,31,25),(3217,5,39,32,25),(3218,5,39,33,25),(3219,5,39,34,25),(3220,5,39,35,25),(3221,5,39,37,25),(3222,4,39,43,25),(3223,4,39,44,25),(3224,4,39,45,25),(3225,4,39,46,25),(3226,6,39,0,26),(3227,6,39,1,26),(3228,5,39,2,26),(3229,5,39,3,26),(3230,5,39,4,26),(3231,12,39,16,26),(3232,5,39,27,26),(3233,5,39,28,26),(3234,5,39,29,26),(3235,5,39,31,26),(3236,5,39,32,26),(3237,5,39,33,26),(3238,5,39,34,26),(3239,5,39,35,26),(3240,5,39,37,26),(3241,4,39,42,26),(3242,4,39,43,26),(3243,4,39,45,26),(3244,4,39,46,26),(3245,6,39,0,27),(3246,5,39,3,27),(3247,5,39,4,27),(3248,5,39,27,27),(3249,5,39,28,27),(3250,5,39,30,27),(3251,5,39,31,27),(3252,5,39,32,27),(3253,5,39,33,27),(3254,5,39,35,27),(3255,4,39,42,27),(3256,4,39,44,27),(3257,4,39,45,27),(3258,4,39,46,27),(3259,6,39,0,28),(3260,6,39,1,28),(3261,5,39,2,28),(3262,5,39,3,28),(3263,5,39,4,28),(3264,5,39,5,28),(3265,5,39,26,28),(3266,5,39,27,28),(3267,5,39,28,28),(3268,4,39,42,28),(3269,4,39,44,28),(3270,4,39,45,28),(3271,4,39,46,28),(3272,6,39,1,29),(3273,5,39,3,29),(3274,5,39,4,29),(3275,5,39,5,29),(3276,5,39,7,29),(3277,5,39,8,29),(3278,1,39,25,29),(3279,5,39,28,29),(3280,7,39,29,29),(3281,0,39,0,30),(3282,5,39,2,30),(3283,5,39,3,30),(3284,5,39,4,30),(3285,5,39,5,30),(3286,5,39,6,30),(3287,5,39,7,30),(3288,5,39,8,30),(3289,5,39,10,30),(3290,7,39,27,30),(3291,7,39,28,30),(3292,7,39,29,30),(3293,7,39,30,30),(3294,7,39,31,30),(3295,7,39,32,30),(3296,5,39,2,31),(3297,5,39,3,31),(3298,5,39,4,31),(3299,5,39,5,31),(3300,5,39,6,31),(3301,5,39,7,31),(3302,5,39,8,31),(3303,5,39,9,31),(3304,5,39,10,31),(3305,7,39,23,31),(3306,7,39,24,31),(3307,7,39,25,31),(3308,7,39,26,31),(3309,7,39,27,31),(3310,7,39,28,31),(3311,7,39,29,31),(3312,7,39,30,31),(3313,7,39,31,31),(3314,7,39,32,31),(3315,7,39,33,31),(3316,5,39,1,32),(3317,5,39,2,32),(3318,5,39,3,32),(3319,5,39,4,32),(3320,5,39,5,32),(3321,5,39,6,32),(3322,5,39,7,32),(3323,5,39,8,32),(3324,7,39,22,32),(3325,7,39,23,32),(3326,7,39,24,32),(3327,7,39,25,32),(3328,7,39,26,32),(3329,7,39,27,32),(3330,7,39,28,32),(3331,7,39,29,32),(3332,7,39,30,32),(3333,7,39,31,32),(3334,7,39,32,32),(3335,7,39,33,32),(3336,5,19,0,0),(3337,5,19,1,0),(3338,5,19,2,0),(3339,5,19,3,0),(3340,5,19,16,0),(3341,5,19,17,0),(3342,5,19,18,0),(3343,5,19,19,0),(3344,5,19,20,0),(3345,5,19,21,0),(3346,5,19,22,0),(3347,5,19,23,0),(3348,5,19,24,0),(3349,5,19,25,0),(3350,5,19,26,0),(3351,5,19,0,1),(3352,5,19,1,1),(3353,5,19,2,1),(3354,5,19,3,1),(3355,5,19,4,1),(3356,12,19,7,1),(3357,5,19,17,1),(3358,5,19,18,1),(3359,5,19,20,1),(3360,14,19,22,1),(3361,5,19,26,1),(3362,5,19,28,1),(3363,5,19,0,2),(3364,5,19,1,2),(3365,5,19,2,2),(3366,5,19,4,2),(3367,5,19,5,2),(3368,5,19,25,2),(3369,5,19,26,2),(3370,5,19,28,2),(3371,5,19,29,2),(3372,5,19,0,3),(3373,5,19,1,3),(3374,5,19,4,3),(3375,5,19,5,3),(3376,5,19,28,3),(3377,6,19,29,3),(3378,5,19,28,4),(3379,6,19,29,4),(3380,4,19,3,5),(3381,4,19,5,5),(3382,0,19,18,5),(3383,6,19,27,5),(3384,6,19,28,5),(3385,6,19,29,5),(3386,4,19,2,6),(3387,4,19,3,6),(3388,4,19,4,6),(3389,4,19,5,6),(3390,6,19,26,6),(3391,6,19,27,6),(3392,6,19,28,6),(3393,6,19,29,6),(3394,4,19,1,7),(3395,4,19,2,7),(3396,4,19,3,7),(3397,4,19,4,7),(3398,4,19,5,7),(3399,6,19,26,7),(3400,5,19,27,7),(3401,5,19,28,7),(3402,5,19,29,7),(3403,4,19,1,8),(3404,4,19,2,8),(3405,4,19,3,8),(3406,4,19,4,8),(3407,0,19,10,8),(3408,5,19,27,8),(3409,5,19,28,8),(3410,5,19,29,8),(3411,4,19,1,9),(3412,4,19,2,9),(3413,4,19,3,9),(3414,5,19,29,9),(3415,4,19,1,10),(3416,6,19,5,10),(3417,6,19,6,10),(3418,5,19,28,10),(3419,5,19,29,10),(3420,6,19,4,11),(3421,6,19,5,11),(3422,6,19,6,11),(3423,6,19,7,11),(3424,6,19,8,11),(3425,5,19,27,11),(3426,5,19,28,11),(3427,5,19,29,11),(3428,13,19,1,12),(3429,6,19,8,12),(3430,6,19,9,12),(3431,6,19,10,12),(3432,5,19,27,12),(3433,5,19,28,12),(3434,5,19,29,12),(3435,6,19,8,13),(3436,6,19,9,13),(3437,6,19,10,13),(3438,5,19,28,13),(3439,5,19,29,13),(3440,5,19,2,14),(3441,6,19,9,14),(3442,5,19,28,14),(3443,5,19,0,15),(3444,5,19,2,15),(3445,5,19,3,15),(3446,5,19,0,16),(3447,5,19,1,16),(3448,5,19,2,16),(3449,5,19,3,16),(3450,5,19,4,16),(3451,2,19,26,16),(3452,5,19,0,17),(3453,5,19,1,17),(3454,5,19,2,17),(3455,5,19,3,17),(3456,5,19,4,17),(3457,5,19,0,18),(3458,5,19,1,18),(3459,5,19,3,18),(3460,6,19,6,18),(3461,4,19,24,18),(3462,4,19,29,18),(3463,5,19,0,19),(3464,5,19,2,19),(3465,5,19,3,19),(3466,6,19,7,19),(3467,6,19,8,19),(3468,4,19,24,19),(3469,4,19,25,19),(3470,4,19,26,19),(3471,4,19,27,19),(3472,4,19,28,19),(3473,4,19,29,19),(3474,5,19,0,20),(3475,11,19,1,20),(3476,6,19,5,20),(3477,6,19,6,20),(3478,6,19,7,20),(3479,6,19,8,20),(3480,6,19,9,20),(3481,4,19,23,20),(3482,4,19,24,20),(3483,4,19,25,20),(3484,4,19,26,20),(3485,4,19,27,20),(3486,4,19,28,20),(3487,4,19,29,20),(3488,5,19,0,21),(3489,6,19,5,21),(3490,6,19,6,21),(3491,4,19,24,21),(3492,4,19,25,21),(3493,4,19,26,21),(3494,4,19,27,21),(3495,4,19,28,21),(3496,4,19,29,21),(3497,5,19,0,22),(3498,6,19,6,22),(3499,8,19,10,22),(3500,4,19,24,22),(3501,4,19,25,22),(3502,4,19,26,22),(3503,4,19,27,22),(3504,4,19,28,22),(3505,4,19,29,22),(3506,5,19,0,23),(3507,4,19,26,23),(3508,4,19,27,23),(3509,4,19,28,23),(3510,5,19,0,24),(3511,3,19,18,24),(3512,3,19,19,24),(3513,3,19,20,24),(3514,0,19,24,24),(3515,4,19,27,24),(3516,0,19,28,24),(3517,5,19,0,25),(3518,3,19,9,25),(3519,3,19,10,25),(3520,3,19,13,25),(3521,3,19,14,25),(3522,3,19,15,25),(3523,3,19,17,25),(3524,3,19,18,25),(3525,3,19,19,25),(3526,3,19,20,25),(3527,3,19,21,25),(3528,5,19,0,26),(3529,5,19,1,26),(3530,5,19,2,26),(3531,3,19,9,26),(3532,3,19,10,26),(3533,3,19,11,26),(3534,3,19,14,26),(3535,3,19,15,26),(3536,3,19,16,26),(3537,3,19,17,26),(3538,3,19,18,26),(3539,3,19,19,26),(3540,3,19,20,26),(3541,3,19,21,26),(3542,3,19,23,26),(3543,5,19,2,27),(3544,0,19,3,27),(3545,3,19,10,27),(3546,3,19,11,27),(3547,3,19,12,27),(3548,3,19,13,27),(3549,3,19,14,27),(3550,3,19,15,27),(3551,3,19,16,27),(3552,3,19,17,27),(3553,3,19,18,27),(3554,3,19,19,27),(3555,3,19,20,27),(3556,3,19,21,27),(3557,3,19,22,27),(3558,3,19,23,27),(3559,3,19,24,27),(3560,0,19,0,28),(3561,3,19,11,28),(3562,3,19,12,28),(3563,3,19,13,28),(3564,3,19,14,28),(3565,3,19,15,28),(3566,3,19,16,28),(3567,3,19,17,28),(3568,3,19,18,28),(3569,3,19,19,28),(3570,3,19,20,28),(3571,3,19,21,28),(3572,3,19,22,28),(3573,3,19,23,28),(3574,3,19,24,28),(3575,3,19,10,29),(3576,3,19,11,29),(3577,3,19,12,29),(3578,3,19,13,29),(3579,3,19,14,29),(3580,3,19,15,29),(3581,3,19,16,29),(3582,3,19,17,29),(3583,3,19,18,29),(3584,3,19,19,29),(3585,3,19,20,29),(3586,3,19,21,29),(3587,3,19,22,29),(3588,3,19,23,29);
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
  `location_type` tinyint(2) unsigned NOT NULL,
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
  PRIMARY KEY (`id`),
  KEY `location` (`player_id`,`location_id`,`location_type`),
  KEY `location_and_player` (`location_type`,`location_id`,`location_x`,`location_y`,`player_id`),
  KEY `index_units_on_route_id` (`route_id`),
  KEY `type` (`player_id`,`type`),
  KEY `group_by_for_fowssentry_status_updates` (`player_id`,`location_id`,`location_type`),
  KEY `foreign_key` (`galaxy_id`),
  CONSTRAINT `units_ibfk_1` FOREIGN KEY (`player_id`) REFERENCES `players` (`id`) ON DELETE SET NULL,
  CONSTRAINT `units_ibfk_2` FOREIGN KEY (`galaxy_id`) REFERENCES `galaxies` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=154 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `units`
--

LOCK TABLES `units` WRITE;
/*!40000 ALTER TABLE `units` DISABLE KEYS */;
INSERT INTO `units` VALUES (1,100,1,19,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,18,28,NULL,1,0,0),(2,100,1,19,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,18,28,NULL,1,0,0),(3,100,1,19,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,18,28,NULL,1,0,0),(4,100,1,19,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,18,28,NULL,1,0,0),(5,100,1,19,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,18,28,NULL,1,0,0),(6,200,1,19,4,NULL,NULL,NULL,NULL,0,0,'Glancer',0,18,28,NULL,1,0,0),(7,200,1,19,4,NULL,NULL,NULL,NULL,0,0,'Glancer',0,18,28,NULL,1,0,0),(8,200,1,19,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,18,28,NULL,1,0,0),(9,200,1,19,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,18,28,NULL,1,0,0),(10,100,1,19,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,18,28,NULL,1,0,0),(11,100,1,19,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,18,28,NULL,1,0,0),(12,100,1,19,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,18,28,NULL,1,0,0),(25,100,1,19,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,3,27,NULL,1,0,0),(26,100,1,19,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,3,27,NULL,1,0,0),(27,100,1,19,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,3,27,NULL,1,0,0),(28,100,1,19,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,3,27,NULL,1,0,0),(29,100,1,19,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,3,27,NULL,1,0,0),(30,200,1,19,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,3,27,NULL,1,0,0),(31,200,1,19,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,3,27,NULL,1,0,0),(32,100,1,19,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,28,24,NULL,1,0,0),(33,100,1,19,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,28,24,NULL,1,0,0),(34,100,1,19,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,28,24,NULL,1,0,0),(35,100,1,19,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,28,24,NULL,1,0,0),(36,100,1,19,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,28,24,NULL,1,0,0),(37,200,1,19,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,28,24,NULL,1,0,0),(38,200,1,19,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,28,24,NULL,1,0,0),(39,100,1,19,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,18,25,NULL,1,0,0),(40,100,1,19,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,18,25,NULL,1,0,0),(41,100,1,19,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,18,25,NULL,1,0,0),(42,100,1,19,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,18,25,NULL,1,0,0),(43,100,1,19,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,18,25,NULL,1,0,0),(44,200,1,19,4,NULL,NULL,NULL,NULL,0,0,'Glancer',0,18,25,NULL,1,0,0),(45,200,1,19,4,NULL,NULL,NULL,NULL,0,0,'Glancer',0,18,25,NULL,1,0,0),(46,200,1,19,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,18,25,NULL,1,0,0),(47,200,1,19,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,18,25,NULL,1,0,0),(48,100,1,19,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,18,25,NULL,1,0,0),(49,100,1,19,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,18,25,NULL,1,0,0),(50,100,1,19,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,18,25,NULL,1,0,0),(51,100,1,19,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,15,26,NULL,1,0,0),(52,100,1,19,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,15,26,NULL,1,0,0),(53,100,1,19,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,15,26,NULL,1,0,0),(54,100,1,19,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,15,26,NULL,1,0,0),(55,100,1,19,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,15,26,NULL,1,0,0),(56,200,1,19,4,NULL,NULL,NULL,NULL,0,0,'Glancer',0,15,26,NULL,1,0,0),(57,200,1,19,4,NULL,NULL,NULL,NULL,0,0,'Glancer',0,15,26,NULL,1,0,0),(58,200,1,19,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,15,26,NULL,1,0,0),(59,200,1,19,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,15,26,NULL,1,0,0),(60,100,1,19,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,15,26,NULL,1,0,0),(61,100,1,19,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,15,26,NULL,1,0,0),(62,100,1,19,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,15,26,NULL,1,0,0),(63,100,1,19,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,7,28,NULL,1,0,0),(64,100,1,19,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,7,28,NULL,1,0,0),(65,100,1,19,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,7,28,NULL,1,0,0),(66,100,1,19,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,7,28,NULL,1,0,0),(67,100,1,19,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,7,28,NULL,1,0,0),(68,200,1,19,4,NULL,NULL,NULL,NULL,0,0,'Glancer',0,7,28,NULL,1,0,0),(69,200,1,19,4,NULL,NULL,NULL,NULL,0,0,'Glancer',0,7,28,NULL,1,0,0),(70,200,1,19,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,7,28,NULL,1,0,0),(71,200,1,19,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,7,28,NULL,1,0,0),(72,100,1,19,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,7,28,NULL,1,0,0),(73,100,1,19,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,7,28,NULL,1,0,0),(74,100,1,19,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,7,28,NULL,1,0,0),(75,100,1,19,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,24,24,NULL,1,0,0),(76,100,1,19,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,24,24,NULL,1,0,0),(77,100,1,19,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,24,24,NULL,1,0,0),(78,100,1,19,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,24,24,NULL,1,0,0),(79,100,1,19,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,24,24,NULL,1,0,0),(80,200,1,19,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,24,24,NULL,1,0,0),(81,200,1,19,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,24,24,NULL,1,0,0),(82,100,1,19,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,0,28,NULL,1,0,0),(83,100,1,19,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,0,28,NULL,1,0,0),(84,100,1,19,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,0,28,NULL,1,0,0),(85,100,1,19,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,0,28,NULL,1,0,0),(86,100,1,19,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,0,28,NULL,1,0,0),(87,200,1,19,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,0,28,NULL,1,0,0),(88,200,1,19,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,0,28,NULL,1,0,0),(89,100,1,19,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,22,27,NULL,1,0,0),(90,100,1,19,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,22,27,NULL,1,0,0),(91,100,1,19,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,22,27,NULL,1,0,0),(92,100,1,19,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,22,27,NULL,1,0,0),(93,100,1,19,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,22,27,NULL,1,0,0),(94,200,1,19,4,NULL,NULL,NULL,NULL,0,0,'Glancer',0,22,27,NULL,1,0,0),(95,200,1,19,4,NULL,NULL,NULL,NULL,0,0,'Glancer',0,22,27,NULL,1,0,0),(96,200,1,19,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,22,27,NULL,1,0,0),(97,200,1,19,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,22,27,NULL,1,0,0),(98,100,1,19,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,22,27,NULL,1,0,0),(99,100,1,19,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,22,27,NULL,1,0,0),(100,100,1,19,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,22,27,NULL,1,0,0),(101,100,1,19,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,25,20,NULL,1,0,0),(102,100,1,19,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,25,20,NULL,1,0,0),(103,100,1,19,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,25,20,NULL,1,0,0),(104,100,1,19,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,25,20,NULL,1,0,0),(105,100,1,19,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,25,20,NULL,1,0,0),(106,200,1,19,4,NULL,NULL,NULL,NULL,0,0,'Glancer',0,25,20,NULL,1,0,0),(107,200,1,19,4,NULL,NULL,NULL,NULL,0,0,'Glancer',0,25,20,NULL,1,0,0),(108,200,1,19,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,25,20,NULL,1,0,0),(109,200,1,19,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,25,20,NULL,1,0,0),(110,100,1,19,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,25,20,NULL,1,0,0),(111,100,1,19,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,25,20,NULL,1,0,0),(112,100,1,19,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,25,20,NULL,1,0,0),(113,100,1,19,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,12,27,NULL,1,0,0),(114,100,1,19,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,12,27,NULL,1,0,0),(115,100,1,19,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,12,27,NULL,1,0,0),(116,100,1,19,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,12,27,NULL,1,0,0),(117,100,1,19,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,12,27,NULL,1,0,0),(118,200,1,19,4,NULL,NULL,NULL,NULL,0,0,'Glancer',0,12,27,NULL,1,0,0),(119,200,1,19,4,NULL,NULL,NULL,NULL,0,0,'Glancer',0,12,27,NULL,1,0,0),(120,200,1,19,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,12,27,NULL,1,0,0),(121,200,1,19,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,12,27,NULL,1,0,0),(122,100,1,19,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,12,27,NULL,1,0,0),(123,100,1,19,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,12,27,NULL,1,0,0),(124,100,1,19,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,12,27,NULL,1,0,0),(125,100,1,19,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,26,27,NULL,1,0,0),(126,100,1,19,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,26,27,NULL,1,0,0),(127,100,1,19,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,26,27,NULL,1,0,0),(128,100,1,19,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,26,27,NULL,1,0,0),(129,100,1,19,4,NULL,NULL,NULL,NULL,0,0,'Gnat',0,26,27,NULL,1,0,0),(130,200,1,19,4,NULL,NULL,NULL,NULL,0,0,'Glancer',0,26,27,NULL,1,0,0),(131,200,1,19,4,NULL,NULL,NULL,NULL,0,0,'Glancer',0,26,27,NULL,1,0,0),(132,200,1,19,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,26,27,NULL,1,0,0),(133,200,1,19,4,NULL,NULL,NULL,NULL,0,0,'Glancer',1,26,27,NULL,1,0,0),(134,100,1,19,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,26,27,NULL,1,0,0),(135,100,1,19,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,26,27,NULL,1,0,0),(136,100,1,19,4,NULL,NULL,NULL,NULL,0,0,'Gnat',1,26,27,NULL,1,0,0),(138,89,1,19,2,1,NULL,NULL,NULL,237,0,'Trooper',1,NULL,NULL,NULL,1,2,0),(139,100,1,19,2,1,NULL,NULL,NULL,150,0,'Trooper',1,NULL,NULL,NULL,1,2,0),(140,100,1,19,2,1,NULL,NULL,NULL,132,0,'Trooper',1,NULL,NULL,NULL,1,2,0),(141,88,1,19,2,1,NULL,NULL,NULL,122,0,'Trooper',0,NULL,NULL,NULL,1,1,0),(143,43,1,19,2,1,NULL,NULL,NULL,367,0,'Trooper',0,NULL,NULL,NULL,1,1,0),(144,100,1,19,2,1,NULL,NULL,NULL,76,0,'Trooper',0,NULL,NULL,NULL,1,1,0),(145,82,1,19,2,1,NULL,NULL,NULL,258,0,'Shocker',0,NULL,NULL,NULL,1,1,0),(146,4,1,19,2,1,NULL,NULL,NULL,600,0,'Shocker',0,NULL,NULL,NULL,1,1,0),(147,70,1,19,2,1,NULL,NULL,NULL,238,0,'Shocker',0,NULL,NULL,NULL,1,1,0),(148,100,3,19,2,1,NULL,NULL,NULL,282,0,'Shocker',1,NULL,NULL,NULL,1,2,0),(149,100,3,19,2,1,NULL,NULL,NULL,318,0,'Shocker',1,NULL,NULL,NULL,1,2,0),(150,5,3,19,2,1,NULL,NULL,NULL,803,0,'Shocker',1,NULL,NULL,NULL,1,2,0),(151,100,3,19,2,1,NULL,NULL,NULL,332,0,'Seeker',1,NULL,NULL,NULL,1,2,0),(152,100,3,19,2,1,NULL,NULL,NULL,368,0,'Seeker',1,NULL,NULL,NULL,1,2,0),(153,100,3,19,2,1,NULL,NULL,NULL,392,0,'Seeker',1,NULL,NULL,NULL,1,2,0);
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

-- Dump completed on 2010-10-01 18:00:21
