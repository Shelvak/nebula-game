-- MySQL dump 10.13  Distrib 5.5.31, for debian-linux-gnu (x86_64)
--
-- Host: localhost    Database: spacegame
-- ------------------------------------------------------
-- Server version	5.5.31-0ubuntu0.12.10.1

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
  `name` varchar(50) NOT NULL,
  `galaxy_id` int(11) NOT NULL,
  `owner_id` int(11) NOT NULL,
  `description` text NOT NULL,
  `victory_points` int(10) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uniq_galaxy_name` (`galaxy_id`,`name`),
  UNIQUE KEY `uniq_galaxy_owner` (`galaxy_id`,`owner_id`),
  KEY `owner_id` (`owner_id`),
  CONSTRAINT `alliances_ibfk_3` FOREIGN KEY (`galaxy_id`) REFERENCES `galaxies` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `alliances_ibfk_2` FOREIGN KEY (`owner_id`) REFERENCES `players` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE
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
  `type` enum('Barracks','CollectorT1','CollectorT2','CollectorT3','Crane','DefensivePortal','EnergyStorage','GroundFactory','Headquarters','HealingCenter','Housing','Market','MetalExtractor','MetalExtractorT2','MetalStorage','MobileScreamer','MobileThunder','MobileVulcan','Mothership','NpcCommunicationsHub','NpcExcavationSite','NpcGeothermalPlant','NpcHall','NpcInfantryFactory','NpcJumpgate','NpcMetalExtractor','NpcResearchCenter','NpcSolarPlant','NpcSpaceFactory','NpcTankFactory','NpcTemple','NpcZetiumExtractor','Radar','ResearchCenter','ResourceTransporter','Screamer','SpaceFactory','Thunder','Vulcan','ZetiumExtractor','ZetiumExtractorT2','ZetiumStorage') NOT NULL,
  `upgrade_ends_at` datetime DEFAULT NULL,
  `x_end` tinyint(2) unsigned NOT NULL DEFAULT '0',
  `y_end` tinyint(2) unsigned NOT NULL DEFAULT '0',
  `state` tinyint(2) NOT NULL DEFAULT '0',
  `pause_remainder` int(10) unsigned DEFAULT NULL,
  `construction_mod` tinyint(2) unsigned NOT NULL DEFAULT '0',
  `cooldown_ends_at` datetime DEFAULT NULL,
  `hp_percentage` float unsigned NOT NULL DEFAULT '1',
  `flags` tinyint(2) unsigned NOT NULL DEFAULT '0',
  `constructable_building_id` int(11) DEFAULT NULL,
  `constructable_unit_id` int(11) DEFAULT NULL,
  `batch_id` varchar(50) NOT NULL DEFAULT '',
  PRIMARY KEY (`id`),
  UNIQUE KEY `tiles_taken` (`planet_id`,`x`,`y`,`x_end`,`y_end`),
  KEY `index_buildings_on_construction_ends` (`upgrade_ends_at`),
  KEY `buildings_by_type` (`planet_id`,`type`),
  KEY `constructable_building_id` (`constructable_building_id`),
  KEY `constructable_unit_id` (`constructable_unit_id`),
  KEY `batch_id` (`batch_id`),
  CONSTRAINT `buildings_ibfk_1` FOREIGN KEY (`planet_id`) REFERENCES `ss_objects` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `buildings_ibfk_2` FOREIGN KEY (`constructable_building_id`) REFERENCES `buildings` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `buildings_ibfk_3` FOREIGN KEY (`constructable_unit_id`) REFERENCES `units` (`id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `buildings`
--

LOCK TABLES `buildings` WRITE;
/*!40000 ALTER TABLE `buildings` DISABLE KEYS */;
/*!40000 ALTER TABLE `buildings` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `callbacks`
--

DROP TABLE IF EXISTS `callbacks`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `callbacks` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `ends_at` datetime NOT NULL,
  `event` tinyint(2) unsigned NOT NULL DEFAULT '0',
  `ruleset` varchar(30) NOT NULL,
  `processing` tinyint(1) NOT NULL DEFAULT '0',
  `player_id` int(11) DEFAULT NULL,
  `technology_id` int(11) DEFAULT NULL,
  `galaxy_id` int(11) DEFAULT NULL,
  `solar_system_id` int(11) DEFAULT NULL,
  `ss_object_id` int(11) DEFAULT NULL,
  `building_id` int(11) DEFAULT NULL,
  `unit_id` int(11) DEFAULT NULL,
  `route_hop_id` int(11) DEFAULT NULL,
  `cooldown_id` int(11) DEFAULT NULL,
  `notification_id` int(11) DEFAULT NULL,
  `nap_id` int(11) DEFAULT NULL,
  `combat_log_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `player_id_uniq` (`player_id`,`event`),
  UNIQUE KEY `technology_id_uniq` (`technology_id`,`event`),
  UNIQUE KEY `galaxy_id_uniq` (`galaxy_id`,`event`),
  UNIQUE KEY `solar_system_id_uniq` (`solar_system_id`,`event`),
  UNIQUE KEY `ss_object_id_uniq` (`ss_object_id`,`event`),
  UNIQUE KEY `building_id_uniq` (`building_id`,`event`),
  UNIQUE KEY `unit_id_uniq` (`unit_id`,`event`),
  UNIQUE KEY `route_hop_id_uniq` (`route_hop_id`,`event`),
  UNIQUE KEY `cooldown_id_uniq` (`cooldown_id`,`event`),
  UNIQUE KEY `notification_id_uniq` (`notification_id`,`event`),
  UNIQUE KEY `nap_id_uniq` (`nap_id`,`event`),
  UNIQUE KEY `combat_log_id_uniq` (`combat_log_id`,`event`),
  KEY `tick` (`ends_at`,`processing`),
  CONSTRAINT `callbacks_ibfk_1` FOREIGN KEY (`player_id`) REFERENCES `players` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `callbacks_ibfk_10` FOREIGN KEY (`notification_id`) REFERENCES `notifications` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `callbacks_ibfk_11` FOREIGN KEY (`nap_id`) REFERENCES `naps` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `callbacks_ibfk_12` FOREIGN KEY (`combat_log_id`) REFERENCES `combat_logs` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `callbacks_ibfk_2` FOREIGN KEY (`technology_id`) REFERENCES `technologies` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `callbacks_ibfk_3` FOREIGN KEY (`galaxy_id`) REFERENCES `galaxies` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `callbacks_ibfk_4` FOREIGN KEY (`solar_system_id`) REFERENCES `solar_systems` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `callbacks_ibfk_5` FOREIGN KEY (`ss_object_id`) REFERENCES `ss_objects` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `callbacks_ibfk_6` FOREIGN KEY (`building_id`) REFERENCES `buildings` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `callbacks_ibfk_7` FOREIGN KEY (`unit_id`) REFERENCES `units` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `callbacks_ibfk_8` FOREIGN KEY (`route_hop_id`) REFERENCES `route_hops` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `callbacks_ibfk_9` FOREIGN KEY (`cooldown_id`) REFERENCES `cooldowns` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
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
-- Table structure for table `chat_messages`
--

DROP TABLE IF EXISTS `chat_messages`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `chat_messages` (
  `source_id` int(11) NOT NULL,
  `target_id` int(11) NOT NULL,
  `message` varchar(255) NOT NULL,
  `created_at` datetime NOT NULL,
  KEY `index_chat_messages_on_source_id` (`source_id`),
  KEY `index_chat_messages_on_target_id` (`target_id`),
  CONSTRAINT `chat_messages_ibfk_2` FOREIGN KEY (`target_id`) REFERENCES `players` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `chat_messages_ibfk_1` FOREIGN KEY (`source_id`) REFERENCES `players` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `chat_messages`
--

LOCK TABLES `chat_messages` WRITE;
/*!40000 ALTER TABLE `chat_messages` DISABLE KEYS */;
/*!40000 ALTER TABLE `chat_messages` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `combat_logs`
--

DROP TABLE IF EXISTS `combat_logs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `combat_logs` (
  `sha1_id` char(40) NOT NULL,
  `info` longblob NOT NULL,
  `id` int(11) NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (`id`),
  UNIQUE KEY `lookup` (`sha1_id`)
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
  `flags` tinyint(2) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `index_upgrade_queue_entries_on_position` (`position`),
  KEY `foreign_key` (`constructor_id`),
  CONSTRAINT `construction_queue_entries_ibfk_1` FOREIGN KEY (`constructor_id`) REFERENCES `buildings` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
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
  `location_x` int(11) DEFAULT NULL,
  `location_y` int(11) DEFAULT NULL,
  `ends_at` datetime NOT NULL,
  `location_galaxy_id` int(11) DEFAULT NULL,
  `location_solar_system_id` int(11) DEFAULT NULL,
  `location_ss_object_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `location_galaxy` (`location_galaxy_id`,`location_x`,`location_y`),
  UNIQUE KEY `location_solar_system` (`location_solar_system_id`,`location_x`,`location_y`),
  UNIQUE KEY `location_ss_object_good` (`location_ss_object_id`),
  CONSTRAINT `cooldowns_ibfk_1` FOREIGN KEY (`location_galaxy_id`) REFERENCES `galaxies` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `cooldowns_ibfk_2` FOREIGN KEY (`location_solar_system_id`) REFERENCES `solar_systems` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `cooldowns_ibfk_3` FOREIGN KEY (`location_ss_object_id`) REFERENCES `ss_objects` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
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
-- Table structure for table `cred_stats`
--

DROP TABLE IF EXISTS `cred_stats`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cred_stats` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `action` tinyint(2) unsigned NOT NULL,
  `player_id` int(11) DEFAULT NULL,
  `creds` int(10) unsigned NOT NULL,
  `class_name` varchar(50) DEFAULT NULL,
  `level` tinyint(2) unsigned DEFAULT NULL,
  `cost` int(10) unsigned NOT NULL,
  `time` int(10) unsigned DEFAULT NULL,
  `actual_time` int(10) unsigned DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `resource` varchar(6) DEFAULT NULL,
  `attr` varchar(7) DEFAULT NULL,
  `vip_level` tinyint(2) unsigned NOT NULL DEFAULT '0',
  `vip_creds` int(10) unsigned NOT NULL DEFAULT '0',
  `free_creds` int(10) unsigned NOT NULL,
  `objects` mediumtext,
  PRIMARY KEY (`id`),
  KEY `by_action` (`action`),
  KEY `by_player` (`player_id`),
  CONSTRAINT `cred_stats_ibfk_1` FOREIGN KEY (`player_id`) REFERENCES `players` (`id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cred_stats`
--

LOCK TABLES `cred_stats` WRITE;
/*!40000 ALTER TABLE `cred_stats` DISABLE KEYS */;
/*!40000 ALTER TABLE `cred_stats` ENABLE KEYS */;
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
  CONSTRAINT `folliages_ibfk_1` FOREIGN KEY (`planet_id`) REFERENCES `ss_objects` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `folliages`
--

LOCK TABLES `folliages` WRITE;
/*!40000 ALTER TABLE `folliages` DISABLE KEYS */;
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
  `player_id` int(11) NOT NULL,
  `x` int(11) NOT NULL,
  `y` int(11) NOT NULL,
  `x_end` int(11) NOT NULL,
  `y_end` int(11) NOT NULL,
  `counter` tinyint(2) unsigned NOT NULL DEFAULT '1',
  PRIMARY KEY (`id`),
  UNIQUE KEY `player_visiblity` (`player_id`,`x`,`y`,`x_end`,`y_end`),
  KEY `lookup_players_by_coords` (`galaxy_id`,`x`,`x_end`,`y`,`y_end`),
  KEY `for_cleanup` (`counter`),
  CONSTRAINT `fow_galaxy_entries_ibfk_1` FOREIGN KEY (`galaxy_id`) REFERENCES `galaxies` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fow_galaxy_entries_ibfk_2` FOREIGN KEY (`player_id`) REFERENCES `players` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
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
-- Table structure for table `galaxies`
--

DROP TABLE IF EXISTS `galaxies`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `galaxies` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `created_at` datetime NOT NULL,
  `ruleset` varchar(30) NOT NULL DEFAULT '0',
  `callback_url` varchar(255) NOT NULL,
  `apocalypse_start` datetime DEFAULT NULL,
  `pool_free_zones` smallint(5) unsigned NOT NULL,
  `pool_free_home_ss` smallint(5) unsigned NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `galaxies`
--

LOCK TABLES `galaxies` WRITE;
/*!40000 ALTER TABLE `galaxies` DISABLE KEYS */;
/*!40000 ALTER TABLE `galaxies` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `location_locks`
--

DROP TABLE IF EXISTS `location_locks`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `location_locks` (
  `location_galaxy_id` int(11) DEFAULT NULL,
  `location_solar_system_id` int(11) DEFAULT NULL,
  `location_ss_object_id` int(11) DEFAULT NULL,
  `location_x` int(11) DEFAULT NULL,
  `location_y` int(11) DEFAULT NULL,
  UNIQUE KEY `galaxy_coordinates` (`location_galaxy_id`,`location_x`,`location_y`),
  UNIQUE KEY `solar_system_coordinates` (`location_solar_system_id`,`location_x`,`location_y`),
  UNIQUE KEY `ss_object` (`location_ss_object_id`),
  CONSTRAINT `location_locks_ibfk_3` FOREIGN KEY (`location_ss_object_id`) REFERENCES `ss_objects` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `location_locks_ibfk_1` FOREIGN KEY (`location_galaxy_id`) REFERENCES `galaxies` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `location_locks_ibfk_2` FOREIGN KEY (`location_solar_system_id`) REFERENCES `solar_systems` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `location_locks`
--

LOCK TABLES `location_locks` WRITE;
/*!40000 ALTER TABLE `location_locks` DISABLE KEYS */;
/*!40000 ALTER TABLE `location_locks` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `market_offers`
--

DROP TABLE IF EXISTS `market_offers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `market_offers` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `galaxy_id` int(11) NOT NULL,
  `planet_id` int(10) DEFAULT NULL,
  `from_kind` tinyint(2) unsigned NOT NULL,
  `from_amount` int(10) unsigned NOT NULL,
  `to_kind` tinyint(2) unsigned NOT NULL,
  `to_rate` double(16,4) unsigned NOT NULL,
  `created_at` datetime NOT NULL,
  `cancellation_shift` double(16,4) NOT NULL,
  `cancellation_amount` int(9) unsigned NOT NULL,
  `cancellation_total_amount` int(9) unsigned NOT NULL,
  PRIMARY KEY (`id`),
  KEY `galaxy foreign key` (`galaxy_id`),
  KEY `planet foreign key` (`planet_id`),
  KEY `avg. market value` (`from_kind`,`to_kind`),
  CONSTRAINT `market_offers_ibfk_1` FOREIGN KEY (`galaxy_id`) REFERENCES `galaxies` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `market_offers_ibfk_2` FOREIGN KEY (`planet_id`) REFERENCES `ss_objects` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `market_offers`
--

LOCK TABLES `market_offers` WRITE;
/*!40000 ALTER TABLE `market_offers` DISABLE KEYS */;
/*!40000 ALTER TABLE `market_offers` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `market_rates`
--

DROP TABLE IF EXISTS `market_rates`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `market_rates` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `galaxy_id` int(11) NOT NULL,
  `from_kind` tinyint(2) unsigned NOT NULL,
  `to_kind` tinyint(2) unsigned NOT NULL,
  `from_amount` int(10) unsigned NOT NULL,
  `to_rate` double unsigned NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `lookup` (`galaxy_id`,`from_kind`,`to_kind`),
  CONSTRAINT `market_rates_ibfk_1` FOREIGN KEY (`galaxy_id`) REFERENCES `galaxies` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `market_rates`
--

LOCK TABLES `market_rates` WRITE;
/*!40000 ALTER TABLE `market_rates` DISABLE KEYS */;
/*!40000 ALTER TABLE `market_rates` ENABLE KEYS */;
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
  CONSTRAINT `naps_ibfk_4` FOREIGN KEY (`acceptor_id`) REFERENCES `alliances` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `naps_ibfk_3` FOREIGN KEY (`initiator_id`) REFERENCES `alliances` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
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
  KEY `order` (`read`,`created_at`),
  KEY `player_with_event` (`player_id`,`event`),
  CONSTRAINT `notifications_ibfk_1` FOREIGN KEY (`player_id`) REFERENCES `players` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
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
  `completed` int(10) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `objective_fk` (`objective_id`),
  KEY `player_fk` (`player_id`),
  CONSTRAINT `objective_progresses_ibfk_4` FOREIGN KEY (`player_id`) REFERENCES `players` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `objective_progresses_ibfk_3` FOREIGN KEY (`objective_id`) REFERENCES `objectives` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
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
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `quest_id` int(11) NOT NULL,
  `type` varchar(255) NOT NULL,
  `key` varchar(255) DEFAULT NULL,
  `count` int(10) unsigned NOT NULL DEFAULT '1',
  `level` tinyint(2) unsigned DEFAULT NULL,
  `alliance` tinyint(1) NOT NULL DEFAULT '0',
  `npc` tinyint(1) NOT NULL DEFAULT '0',
  `limit` int(10) unsigned DEFAULT NULL,
  `outcome` tinyint(2) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `quest_objectives` (`quest_id`),
  KEY `on_progress` (`type`,`key`),
  CONSTRAINT `objectives_ibfk_1` FOREIGN KEY (`quest_id`) REFERENCES `quests` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
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
-- Table structure for table `player_options`
--

DROP TABLE IF EXISTS `player_options`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `player_options` (
  `player_id` int(11) NOT NULL,
  `data` blob NOT NULL,
  PRIMARY KEY (`player_id`),
  CONSTRAINT `player_options_ibfk_1` FOREIGN KEY (`player_id`) REFERENCES `players` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `player_options`
--

LOCK TABLES `player_options` WRITE;
/*!40000 ALTER TABLE `player_options` DISABLE KEYS */;
/*!40000 ALTER TABLE `player_options` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `players`
--

DROP TABLE IF EXISTS `players`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `players` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `galaxy_id` int(11) NOT NULL,
  `web_user_id` int(10) unsigned NOT NULL,
  `name` varchar(64) NOT NULL,
  `scientists` int(10) unsigned NOT NULL DEFAULT '0',
  `scientists_total` int(10) unsigned NOT NULL DEFAULT '0',
  `alliance_id` int(11) DEFAULT NULL,
  `xp` int(10) unsigned NOT NULL DEFAULT '0',
  `war_points` int(10) unsigned NOT NULL DEFAULT '0',
  `flags` tinyint(2) unsigned NOT NULL DEFAULT '0',
  `army_points` int(10) unsigned NOT NULL DEFAULT '0',
  `science_points` int(10) unsigned NOT NULL DEFAULT '0',
  `economy_points` int(10) unsigned NOT NULL DEFAULT '0',
  `planets_count` tinyint(2) unsigned NOT NULL,
  `last_seen` datetime DEFAULT NULL,
  `victory_points` mediumint(8) unsigned NOT NULL DEFAULT '0',
  `language` char(2) NOT NULL DEFAULT 'en',
  `population` mediumint(8) unsigned NOT NULL DEFAULT '0',
  `population_cap` mediumint(8) unsigned NOT NULL,
  `alliance_cooldown_ends_at` datetime DEFAULT NULL,
  `vip_level` tinyint(2) unsigned NOT NULL DEFAULT '0',
  `vip_creds` int(10) unsigned NOT NULL DEFAULT '0',
  `vip_until` datetime DEFAULT NULL,
  `vip_creds_until` datetime DEFAULT NULL,
  `daily_bonus_at` datetime DEFAULT NULL,
  `alliance_vps` int(10) unsigned NOT NULL DEFAULT '0',
  `pure_creds` int(10) unsigned NOT NULL DEFAULT '0',
  `free_creds` int(10) unsigned NOT NULL DEFAULT '0',
  `bg_planets_count` tinyint(2) unsigned NOT NULL DEFAULT '0',
  `death_date` datetime DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `alliance_cooldown_id` int(11) DEFAULT NULL,
  `batch_id` varchar(50) NOT NULL DEFAULT '',
  `last_market_offer_cancel` datetime NOT NULL DEFAULT '0000-01-01 00:00:00',
  PRIMARY KEY (`id`),
  UNIQUE KEY `authentication` (`galaxy_id`,`web_user_id`),
  UNIQUE KEY `naming` (`galaxy_id`,`name`),
  KEY `index_players_on_alliance_id` (`alliance_id`),
  KEY `last_login` (`last_seen`),
  KEY `alive_players` (`galaxy_id`,`planets_count`),
  KEY `alliance_cooldown_id` (`alliance_cooldown_id`),
  KEY `batch_id` (`batch_id`),
  CONSTRAINT `players_ibfk_3` FOREIGN KEY (`alliance_cooldown_id`) REFERENCES `alliances` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `players_ibfk_4` FOREIGN KEY (`galaxy_id`) REFERENCES `galaxies` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `players_ibfk_5` FOREIGN KEY (`alliance_id`) REFERENCES `alliances` (`id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `players`
--

LOCK TABLES `players` WRITE;
/*!40000 ALTER TABLE `players` DISABLE KEYS */;
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
  CONSTRAINT `quest_progresses_ibfk_4` FOREIGN KEY (`player_id`) REFERENCES `players` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `quest_progresses_ibfk_3` FOREIGN KEY (`quest_id`) REFERENCES `quests` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
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
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `parent_id` int(11) DEFAULT NULL,
  `rewards` text,
  `main_quest_slides` varchar(255) DEFAULT NULL,
  `achievement` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `child quests` (`parent_id`),
  KEY `index_quests_on_achievement` (`achievement`),
  CONSTRAINT `quests_ibfk_1` FOREIGN KEY (`parent_id`) REFERENCES `quests` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
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
-- Table structure for table `route_hops`
--

DROP TABLE IF EXISTS `route_hops`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `route_hops` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `route_id` int(11) NOT NULL,
  `location_x` int(11) DEFAULT NULL,
  `location_y` int(11) DEFAULT NULL,
  `arrives_at` datetime NOT NULL,
  `index` smallint(6) NOT NULL,
  `next` tinyint(1) NOT NULL DEFAULT '0',
  `location_galaxy_id` int(11) DEFAULT NULL,
  `location_solar_system_id` int(11) DEFAULT NULL,
  `location_ss_object_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `next_hop` (`route_id`,`index`),
  KEY `next` (`route_id`,`next`),
  KEY `location_galaxy` (`location_galaxy_id`,`location_x`,`location_y`),
  KEY `location_solar_system` (`location_solar_system_id`,`location_x`,`location_y`),
  KEY `location_ss_object` (`location_ss_object_id`,`location_x`,`location_y`),
  KEY `route_galaxy` (`route_id`,`location_galaxy_id`),
  KEY `route_solar_system` (`route_id`,`location_solar_system_id`),
  KEY `route_ss_object` (`route_id`,`location_ss_object_id`),
  CONSTRAINT `route_hops_ibfk_1` FOREIGN KEY (`route_id`) REFERENCES `routes` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `route_hops_ibfk_2` FOREIGN KEY (`location_galaxy_id`) REFERENCES `galaxies` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `route_hops_ibfk_3` FOREIGN KEY (`location_solar_system_id`) REFERENCES `solar_systems` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `route_hops_ibfk_4` FOREIGN KEY (`location_ss_object_id`) REFERENCES `ss_objects` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
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
  `arrives_at` datetime NOT NULL,
  `cached_units` text NOT NULL,
  `player_id` int(10) DEFAULT NULL,
  `target_x` int(11) NOT NULL,
  `target_y` int(11) NOT NULL,
  `current_x` int(11) NOT NULL,
  `current_y` int(11) NOT NULL,
  `source_x` int(11) NOT NULL,
  `source_y` int(11) NOT NULL,
  `jumps_at` datetime DEFAULT NULL,
  `source_galaxy_id` int(11) DEFAULT NULL,
  `source_solar_system_id` int(11) DEFAULT NULL,
  `source_ss_object_id` int(11) DEFAULT NULL,
  `current_galaxy_id` int(11) DEFAULT NULL,
  `current_solar_system_id` int(11) DEFAULT NULL,
  `current_ss_object_id` int(11) DEFAULT NULL,
  `target_galaxy_id` int(11) DEFAULT NULL,
  `target_solar_system_id` int(11) DEFAULT NULL,
  `target_ss_object_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `foreign_key` (`player_id`),
  KEY `source_galaxy` (`source_galaxy_id`,`source_x`,`source_y`),
  KEY `source_solar_system` (`source_solar_system_id`,`source_x`,`source_y`),
  KEY `source_ss_object` (`source_ss_object_id`,`source_x`,`source_y`),
  KEY `current_galaxy` (`current_galaxy_id`,`current_x`,`current_y`),
  KEY `current_solar_system` (`current_solar_system_id`,`current_x`,`current_y`),
  KEY `current_ss_object` (`current_ss_object_id`,`current_x`,`current_y`),
  KEY `target_galaxy` (`target_galaxy_id`,`target_x`,`target_y`),
  KEY `target_solar_system` (`target_solar_system_id`,`target_x`,`target_y`),
  KEY `target_ss_object` (`target_ss_object_id`,`target_x`,`target_y`),
  CONSTRAINT `routes_ibfk_1` FOREIGN KEY (`player_id`) REFERENCES `players` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `routes_ibfk_10` FOREIGN KEY (`target_ss_object_id`) REFERENCES `ss_objects` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `routes_ibfk_2` FOREIGN KEY (`source_galaxy_id`) REFERENCES `galaxies` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `routes_ibfk_3` FOREIGN KEY (`source_solar_system_id`) REFERENCES `solar_systems` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `routes_ibfk_4` FOREIGN KEY (`source_ss_object_id`) REFERENCES `ss_objects` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `routes_ibfk_5` FOREIGN KEY (`current_galaxy_id`) REFERENCES `galaxies` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `routes_ibfk_6` FOREIGN KEY (`current_solar_system_id`) REFERENCES `solar_systems` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `routes_ibfk_7` FOREIGN KEY (`current_ss_object_id`) REFERENCES `ss_objects` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `routes_ibfk_8` FOREIGN KEY (`target_galaxy_id`) REFERENCES `galaxies` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `routes_ibfk_9` FOREIGN KEY (`target_solar_system_id`) REFERENCES `solar_systems` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
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
INSERT INTO `schema_migrations` VALUES ('20090601175224'),('20090601184051'),('20090601184055'),('20090601184059'),('20090701164131'),('20090713165021'),('20090808144214'),('20090809160211'),('20090810173759'),('20090826140238'),('20090826141836'),('20090829202538'),('20090829210029'),('20090829224505'),('20090830143959'),('20090830145319'),('20090901153809'),('20090904190655'),('20090905175341'),('20090905192056'),('20090906135044'),('20090909222719'),('20090911180950'),('20090912165229'),('20090919155819'),('20091024222359'),('20091103164416'),('20091103180558'),('20091103181146'),('20091109191211'),('20091225193714'),('20100114152902'),('20100121142414'),('20100127115341'),('20100127120219'),('20100127120515'),('20100127121337'),('20100129150736'),('20100203202757'),('20100203204803'),('20100204172507'),('20100204173714'),('20100208163239'),('20100210114531'),('20100212134334'),('20100218181507'),('20100219114448'),('20100220144106'),('20100222144003'),('20100223153023'),('20100224153728'),('20100224163525'),('20100225124928'),('20100225153721'),('20100225155505'),('20100225155739'),('20100226122144'),('20100226122651'),('20100301153626'),('20100302131225'),('20100303131706'),('20100308163148'),('20100308164422'),('20100310172315'),('20100310181338'),('20100311123523'),('20100315112858'),('20100319141401'),('20100322184529'),('20100324134243'),('20100324141652'),('20100331125702'),('20100415130556'),('20100415130600'),('20100415130605'),('20100415134627'),('20100419141518'),('20100419142018'),('20100419164230'),('20100426141509'),('20100428130912'),('20100429171200'),('20100430174140'),('20100610151652'),('20100610180750'),('20100614142225'),('20100614160819'),('20100614162423'),('20100616132525'),('20100616135507'),('20100622124252'),('20100706105523'),('20100710121447'),('20100710191351'),('20100716155807'),('20100719131622'),('20100721155359'),('20100722124307'),('20100812164444'),('20100812164449'),('20100812164518'),('20100812164524'),('20100817165213'),('20100819175736'),('20100820185846'),('20100906095758'),('20100915145823'),('20100929111549'),('20101001155323'),('20101005180058'),('20101022155620'),('20101117131430'),('20101208135417'),('20101209122838'),('20101222150446'),('20101223125157'),('20101223172333'),('20110106110617'),('20110117182616'),('20110119121807'),('20110125161025'),('20110128094012'),('20110201122224'),('20110211124612'),('20110214130700'),('20110214165108'),('20110215161039'),('20110221105637'),('20110224162141'),('20110224174209'),('20110307104202'),('20110307121218'),('20110309114701'),('20110309194328'),('20110310113500'),('20110311172250'),('20110314132426'),('20110317165341'),('20110329163829'),('20110330141930'),('20110410103752'),('20110413154835'),('20110420152125'),('20110420153521'),('20110422180144'),('20110426131533'),('20110426145014'),('20110429150825'),('20110430142655'),('20110501202247'),('20110502175634'),('20110503165127'),('20110506202156'),('20110509144521'),('20110520172423'),('20110529152142'),('20110530121627'),('20110601155244'),('20110606114650'),('20110606154238'),('20110615120534'),('20110620180705'),('20110621165656'),('20110627164509'),('20110711160159'),('20110728101729'),('20110731170836'),('20110801114044'),('20110802172428'),('20110807130218'),('20110807131155'),('20110807161232'),('20110812114804'),('20110905102038'),('20110911155609'),('20110916153737'),('20110920150711'),('20110922154003'),('20110924163350'),('20110924173927'),('20110927142508'),('20111003185306'),('20111013125109'),('20111024104056'),('20111027145938'),('20111115150234'),('20111119101809'),('20111125123219'),('20111202191900'),('20111208124349'),('20111214120514'),('20111227121256'),('20111228161017'),('20111229121331'),('20120104105526'),('20120105100946'),('20120105175009'),('20120107144305'),('20120113160416'),('20120116161146'),('20120117110804'),('20120119111535'),('20120201154523'),('20120209120424'),('20120214222310'),('20120215123242'),('20120216143141'),('20120221162141'),('20120222105249'),('20120222124109'),('20120318125810'),('20120322111549'),('20120327174215'),('20120412112541'),('20120424180813'),('20120425160035'),('20120507134202'),('20120509164923'),('20120510105951'),('20120615165756'),('20120625131303'),('20120629173034'),('20120705144136'),('20120810144445'),('20120818181103');
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
  `galaxy_id` int(11) NOT NULL,
  `x` mediumint(9) DEFAULT NULL,
  `y` mediumint(9) DEFAULT NULL,
  `kind` tinyint(2) NOT NULL DEFAULT '0',
  `player_id` int(11) DEFAULT NULL,
  `batch_id` varchar(50) NOT NULL DEFAULT '',
  `spawn_counter` int(10) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uniqueness` (`galaxy_id`,`player_id`,`kind`),
  UNIQUE KEY `lookup` (`galaxy_id`,`x`,`y`),
  KEY `player_id` (`player_id`),
  KEY `batch_id` (`batch_id`),
  CONSTRAINT `solar_systems_ibfk_2` FOREIGN KEY (`player_id`) REFERENCES `players` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `solar_systems_ibfk_3` FOREIGN KEY (`galaxy_id`) REFERENCES `galaxies` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `solar_systems`
--

LOCK TABLES `solar_systems` WRITE;
/*!40000 ALTER TABLE `solar_systems` DISABLE KEYS */;
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
  `name` varchar(12) NOT NULL DEFAULT '',
  `size` int(11) NOT NULL DEFAULT '0',
  `terrain` tinyint(2) unsigned NOT NULL DEFAULT '0',
  `metal` float unsigned NOT NULL DEFAULT '0',
  `metal_generation_rate` float unsigned NOT NULL DEFAULT '0',
  `metal_storage` float NOT NULL DEFAULT '0',
  `energy` float unsigned NOT NULL DEFAULT '0',
  `energy_generation_rate` float unsigned NOT NULL DEFAULT '0',
  `energy_storage` float NOT NULL DEFAULT '0',
  `zetium` float unsigned NOT NULL DEFAULT '0',
  `zetium_generation_rate` float unsigned NOT NULL DEFAULT '0',
  `zetium_storage` float NOT NULL DEFAULT '0',
  `last_resources_update` datetime DEFAULT NULL,
  `energy_diminish_registered` tinyint(1) NOT NULL DEFAULT '0',
  `exploration_x` tinyint(2) unsigned DEFAULT NULL,
  `exploration_y` tinyint(2) unsigned DEFAULT NULL,
  `exploration_ends_at` datetime DEFAULT NULL,
  `can_destroy_building_at` datetime DEFAULT NULL,
  `next_raid_at` datetime DEFAULT NULL,
  `metal_rate_boost_ends_at` datetime DEFAULT NULL,
  `metal_storage_boost_ends_at` datetime DEFAULT NULL,
  `energy_rate_boost_ends_at` datetime DEFAULT NULL,
  `energy_storage_boost_ends_at` datetime DEFAULT NULL,
  `zetium_rate_boost_ends_at` datetime DEFAULT NULL,
  `zetium_storage_boost_ends_at` datetime DEFAULT NULL,
  `metal_usage_rate` float unsigned NOT NULL DEFAULT '0',
  `energy_usage_rate` float unsigned NOT NULL DEFAULT '0',
  `zetium_usage_rate` float unsigned NOT NULL DEFAULT '0',
  `owner_changed` datetime DEFAULT NULL,
  `raid_arg` tinyint(2) unsigned NOT NULL DEFAULT '0',
  `batch_id` varchar(50) NOT NULL DEFAULT '',
  `spawn_counter` int(9) unsigned NOT NULL DEFAULT '0',
  `next_spawn` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uniqueness` (`solar_system_id`,`position`,`angle`),
  KEY `batch_id` (`batch_id`),
  KEY `observer_player_ids` (`player_id`,`solar_system_id`),
  CONSTRAINT `ss_objects_ibfk_3` FOREIGN KEY (`solar_system_id`) REFERENCES `solar_systems` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `ss_objects_ibfk_4` FOREIGN KEY (`player_id`) REFERENCES `players` (`id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ss_objects`
--

LOCK TABLES `ss_objects` WRITE;
/*!40000 ALTER TABLE `ss_objects` DISABLE KEYS */;
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
  `upgrade_ends_at` datetime DEFAULT NULL,
  `pause_remainder` int(10) unsigned DEFAULT NULL,
  `scientists` int(10) unsigned DEFAULT '0',
  `level` tinyint(2) unsigned NOT NULL,
  `player_id` int(11) NOT NULL,
  `type` enum('Alliances','Avenger','AvengerAbsorption','AvengerArmor','AvengerCritical','AvengerDamage','AvengerSpeed','Azure','AzureAbsorption','AzureArmor','AzureCritical','AzureDamage','BuildingRepair','CollectorT2','CollectorT3','Crane','Crow','CrowAbsorption','CrowArmor','CrowCritical','CrowDamage','CrowSpeed','Cyrix','CyrixAbsorption','CyrixArmor','CyrixCritical','CyrixDamage','CyrixSpeed','Dart','DartAbsorption','DartArmor','DartCritical','DartDamage','DartSpeed','DefensivePortal','Demosis','DemosisAbsorption','DemosisArmor','DemosisCritical','DemosisDamage','DemosisSpeed','Dirac','DiracAbsorption','DiracArmor','DiracCritical','DiracDamage','DiracSpeed','EnergyStorage','FieryMelters','Glancer','GlancerAbsorption','GlancerArmor','GlancerCritical','GlancerDamage','Gnat','GnatAbsorption','GnatArmor','GnatCritical','GnatDamage','Gnawer','GnawerAbsorption','GnawerArmor','GnawerCritical','GnawerDamage','GroundAbsorption','GroundArmor','GroundCritical','GroundDamage','GroundFactory','HealingCenter','HeavyFlight','Jumper','LightFlight','Mantis','MantisAbsorption','MantisArmor','MantisCritical','MantisDamage','Market','Mdh','MetalExtractorT2','MetalStorage','MobileScreamer','MobileThunder','MobileVulcan','Mule','MuleAbsorption','MuleArmor','MuleSpeed','MuleStorage','NpcGroundAbsorption','NpcGroundArmor','NpcGroundCritical','NpcGroundDamage','NpcHeavyFlight','NpcLightFlight','NpcSpaceAbsorption','NpcSpaceArmor','NpcSpaceCritical','NpcSpaceDamage','PowderedZetium','Radar','ResourceTransporter','Rhyno','RhynoAbsorption','RhynoArmor','RhynoCritical','RhynoDamage','RhynoSpeed','RhynoStorage','Scorpion','ScorpionAbsorption','ScorpionArmor','ScorpionCritical','ScorpionDamage','Screamer','ScreamerAbsorption','ScreamerArmor','ScreamerCritical','ScreamerDamage','Seeker','SeekerAbsorption','SeekerArmor','SeekerCritical','SeekerDamage','ShipStorage','Shocker','ShockerAbsorption','ShockerArmor','ShockerCritical','ShockerDamage','SpaceAbsorption','SpaceArmor','SpaceCritical','SpaceDamage','SpaceFactory','Spaceport','Spudder','SpudderAbsorption','SpudderArmor','SpudderCritical','SpudderDamage','SuperconductorTechnology','Thor','ThorAbsorption','ThorArmor','ThorCritical','ThorDamage','ThorSpeed','Thunder','ThunderAbsorption','ThunderArmor','ThunderCritical','ThunderDamage','Trooper','TrooperAbsorption','TrooperArmor','TrooperCritical','TrooperDamage','TurretAbsorption','TurretArmor','TurretCritical','TurretDamage','Vulcan','VulcanAbsorption','VulcanArmor','VulcanCritical','VulcanDamage','ZetiumExtraction','ZetiumExtractorT2','ZetiumStorage','Zeus','ZeusAbsorption','ZeusArmor','ZeusCritical','ZeusDamage') NOT NULL,
  `pause_scientists` int(10) unsigned DEFAULT NULL,
  `flags` tinyint(2) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `main` (`player_id`,`type`,`level`),
  UNIQUE KEY `type_by_player` (`player_id`,`type`,`level`),
  UNIQUE KEY `ensure_uniqueness` (`player_id`,`type`),
  KEY `upgrading` (`player_id`,`upgrade_ends_at`),
  CONSTRAINT `technologies_ibfk_1` FOREIGN KEY (`player_id`) REFERENCES `players` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
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
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `kind` tinyint(2) unsigned NOT NULL DEFAULT '0',
  `planet_id` int(11) NOT NULL,
  `x` tinyint(2) unsigned NOT NULL DEFAULT '0',
  `y` tinyint(2) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uniqueness` (`planet_id`,`x`,`y`),
  CONSTRAINT `tiles_ibfk_1` FOREIGN KEY (`planet_id`) REFERENCES `ss_objects` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tiles`
--

LOCK TABLES `tiles` WRITE;
/*!40000 ALTER TABLE `tiles` DISABLE KEYS */;
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
  `level` tinyint(2) unsigned NOT NULL,
  `player_id` int(11) DEFAULT NULL,
  `upgrade_ends_at` datetime DEFAULT NULL,
  `pause_remainder` int(10) unsigned DEFAULT NULL,
  `xp` mediumint(8) unsigned NOT NULL DEFAULT '0',
  `type` enum('Avenger','Azure','BossShip','ConvoyShip','Crow','Cyrix','Dart','Demosis','Dirac','Glancer','Gnat','Gnawer','Jumper','Mantis','Mdh','MobileScreamer','MobileThunder','MobileVulcan','Mule','Rhyno','Scorpion','Seeker','Shocker','Spudder','Thor','Trooper','Worg','Zeus') NOT NULL,
  `flank` tinyint(2) unsigned NOT NULL DEFAULT '0',
  `location_x` mediumint(7) DEFAULT NULL,
  `location_y` mediumint(7) DEFAULT NULL,
  `route_id` int(11) DEFAULT NULL,
  `stance` tinyint(2) unsigned NOT NULL DEFAULT '0',
  `construction_mod` tinyint(2) unsigned NOT NULL DEFAULT '0',
  `stored` int(10) unsigned NOT NULL DEFAULT '0',
  `metal` int(10) unsigned NOT NULL DEFAULT '0',
  `energy` int(10) unsigned NOT NULL DEFAULT '0',
  `zetium` int(10) unsigned NOT NULL DEFAULT '0',
  `hp_percentage` float unsigned NOT NULL DEFAULT '1',
  `flags` tinyint(2) unsigned NOT NULL DEFAULT '0',
  `location_galaxy_id` int(11) DEFAULT NULL,
  `location_solar_system_id` int(11) DEFAULT NULL,
  `location_ss_object_id` int(11) DEFAULT NULL,
  `location_building_id` int(11) DEFAULT NULL,
  `location_unit_id` int(11) DEFAULT NULL,
  `batch_id` varchar(50) NOT NULL DEFAULT '',
  PRIMARY KEY (`id`),
  KEY `index_units_on_route_id` (`route_id`),
  KEY `type` (`player_id`,`type`),
  KEY `location_galaxy` (`player_id`,`location_galaxy_id`),
  KEY `location_solar_system` (`player_id`,`location_solar_system_id`),
  KEY `location_ss_object` (`player_id`,`location_ss_object_id`),
  KEY `location_building` (`player_id`,`location_building_id`),
  KEY `location_unit` (`player_id`,`location_unit_id`),
  KEY `location_galaxy_and_player` (`location_galaxy_id`,`location_x`,`location_y`,`player_id`),
  KEY `location_solar_system_and_player` (`location_solar_system_id`,`location_x`,`location_y`,`player_id`),
  KEY `location_ss_object_and_player` (`location_ss_object_id`,`location_x`,`location_y`,`player_id`),
  KEY `location_building_and_player` (`location_building_id`,`location_x`,`location_y`,`player_id`),
  KEY `location_unit_and_player` (`location_unit_id`,`location_x`,`location_y`,`player_id`),
  KEY `batch_id` (`batch_id`),
  CONSTRAINT `units_ibfk_10` FOREIGN KEY (`location_building_id`) REFERENCES `buildings` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `units_ibfk_11` FOREIGN KEY (`location_unit_id`) REFERENCES `units` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `units_ibfk_4` FOREIGN KEY (`player_id`) REFERENCES `players` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `units_ibfk_5` FOREIGN KEY (`route_id`) REFERENCES `routes` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `units_ibfk_7` FOREIGN KEY (`location_galaxy_id`) REFERENCES `galaxies` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `units_ibfk_8` FOREIGN KEY (`location_solar_system_id`) REFERENCES `solar_systems` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `units_ibfk_9` FOREIGN KEY (`location_ss_object_id`) REFERENCES `ss_objects` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `units`
--

LOCK TABLES `units` WRITE;
/*!40000 ALTER TABLE `units` DISABLE KEYS */;
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
  `location_x` smallint(6) NOT NULL,
  `location_y` smallint(6) NOT NULL,
  `metal` int(10) unsigned NOT NULL DEFAULT '0',
  `energy` int(10) unsigned NOT NULL DEFAULT '0',
  `zetium` int(10) unsigned NOT NULL DEFAULT '0',
  `location_galaxy_id` int(11) DEFAULT NULL,
  `location_solar_system_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `location_galaxy` (`location_galaxy_id`,`location_x`,`location_y`),
  UNIQUE KEY `location_solar_system` (`location_solar_system_id`,`location_x`,`location_y`),
  CONSTRAINT `wreckages_ibfk_2` FOREIGN KEY (`location_galaxy_id`) REFERENCES `galaxies` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `wreckages_ibfk_3` FOREIGN KEY (`location_solar_system_id`) REFERENCES `solar_systems` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
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

-- Dump completed on 2013-04-28 10:28:17
