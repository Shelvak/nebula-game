-- MySQL dump 10.13  Distrib 5.5.17, for Linux (i686)
--
-- Host: localhost    Database: spacegame
-- ------------------------------------------------------
-- Server version	5.5.17-55

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
  CONSTRAINT `alliances_ibfk_1` FOREIGN KEY (`galaxy_id`) REFERENCES `galaxies` (`id`) ON DELETE CASCADE,
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
  `type` varchar(255) NOT NULL,
  `upgrade_ends_at` datetime DEFAULT NULL,
  `x_end` tinyint(2) unsigned NOT NULL DEFAULT '0',
  `y_end` tinyint(2) unsigned NOT NULL DEFAULT '0',
  `state` tinyint(2) NOT NULL DEFAULT '0',
  `pause_remainder` int(10) unsigned DEFAULT NULL,
  `constructable_type` varchar(100) DEFAULT NULL,
  `constructable_id` int(11) DEFAULT NULL,
  `construction_mod` tinyint(2) unsigned NOT NULL DEFAULT '0',
  `cooldown_ends_at` datetime DEFAULT NULL,
  `hp_percentage` float unsigned NOT NULL DEFAULT '1',
  `flags` tinyint(2) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `tiles_taken` (`planet_id`,`x`,`y`,`x_end`,`y_end`),
  KEY `index_buildings_on_construction_ends` (`upgrade_ends_at`),
  KEY `buildings_by_type` (`planet_id`,`type`),
  CONSTRAINT `buildings_ibfk_1` FOREIGN KEY (`planet_id`) REFERENCES `ss_objects` (`id`) ON DELETE CASCADE
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
  `class` varchar(50) NOT NULL,
  `object_id` int(10) unsigned NOT NULL,
  `ends_at` datetime NOT NULL,
  `event` tinyint(2) unsigned NOT NULL DEFAULT '0',
  `ruleset` varchar(30) NOT NULL,
  `failed` tinyint(1) NOT NULL DEFAULT '0',
  UNIQUE KEY `main` (`class`,`object_id`,`event`),
  KEY `tick` (`ends_at`,`failed`)
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
  `info` mediumtext NOT NULL,
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
  `flags` tinyint(2) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
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
  `ends_at` datetime NOT NULL,
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
  CONSTRAINT `folliages_ibfk_1` FOREIGN KEY (`planet_id`) REFERENCES `ss_objects` (`id`) ON DELETE CASCADE
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
  CONSTRAINT `fow_ss_entries_ibfk_3` FOREIGN KEY (`alliance_id`) REFERENCES `alliances` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fow_ss_entries_ibfk_1` FOREIGN KEY (`solar_system_id`) REFERENCES `solar_systems` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fow_ss_entries_ibfk_2` FOREIGN KEY (`player_id`) REFERENCES `players` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `fow_ss_entries`
--

LOCK TABLES `fow_ss_entries` WRITE;
/*!40000 ALTER TABLE `fow_ss_entries` DISABLE KEYS */;
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
  `callback_url` varchar(255) NOT NULL,
  `apocalypse_start` datetime DEFAULT NULL,
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
  `to_rate` double unsigned NOT NULL,
  `created_at` datetime NOT NULL,
  `cancellation_shift` double NOT NULL,
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
  KEY `lookup` (`galaxy_id`,`from_kind`,`to_kind`),
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
  KEY `order` (`read`,`created_at`),
  KEY `player_with_event` (`player_id`,`event`),
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
  `completed` int(10) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `objective_fk` (`objective_id`),
  KEY `player_fk` (`player_id`),
  CONSTRAINT `objective_progresses_ibfk_1` FOREIGN KEY (`objective_id`) REFERENCES `objectives` (`id`) ON DELETE CASCADE,
  CONSTRAINT `objective_progresses_ibfk_2` FOREIGN KEY (`player_id`) REFERENCES `players` (`id`) ON DELETE CASCADE
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
  `flags` tinyint(2) unsigned NOT NULL DEFAULT '1',
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
  PRIMARY KEY (`id`),
  UNIQUE KEY `authentication` (`galaxy_id`,`web_user_id`),
  KEY `index_players_on_alliance_id` (`alliance_id`),
  KEY `last_login` (`last_seen`),
  KEY `alive_players` (`galaxy_id`,`planets_count`),
  KEY `alliance_cooldown_id` (`alliance_cooldown_id`),
  CONSTRAINT `players_ibfk_3` FOREIGN KEY (`alliance_cooldown_id`) REFERENCES `alliances` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `players_ibfk_1` FOREIGN KEY (`galaxy_id`) REFERENCES `galaxies` (`id`) ON DELETE CASCADE,
  CONSTRAINT `players_ibfk_2` FOREIGN KEY (`alliance_id`) REFERENCES `alliances` (`id`) ON DELETE SET NULL
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
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `parent_id` int(11) DEFAULT NULL,
  `rewards` text,
  `help_url_id` varchar(255) DEFAULT NULL,
  `achievement` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `child quests` (`parent_id`),
  KEY `index_quests_on_achievement` (`achievement`),
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
  `player_id` int(10) DEFAULT NULL,
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
  `jumps_at` datetime DEFAULT NULL,
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
INSERT INTO `schema_migrations` VALUES ('20090601175224'),('20090601184051'),('20090601184055'),('20090601184059'),('20090701164131'),('20090713165021'),('20090808144214'),('20090809160211'),('20090810173759'),('20090826140238'),('20090826141836'),('20090829202538'),('20090829210029'),('20090829224505'),('20090830143959'),('20090830145319'),('20090901153809'),('20090904190655'),('20090905175341'),('20090905192056'),('20090906135044'),('20090909222719'),('20090911180950'),('20090912165229'),('20090919155819'),('20091024222359'),('20091103164416'),('20091103180558'),('20091103181146'),('20091109191211'),('20091225193714'),('20100114152902'),('20100121142414'),('20100127115341'),('20100127120219'),('20100127120515'),('20100127121337'),('20100129150736'),('20100203202757'),('20100203204803'),('20100204172507'),('20100204173714'),('20100208163239'),('20100210114531'),('20100212134334'),('20100218181507'),('20100219114448'),('20100220144106'),('20100222144003'),('20100223153023'),('20100224153728'),('20100224163525'),('20100225124928'),('20100225153721'),('20100225155505'),('20100225155739'),('20100226122144'),('20100226122651'),('20100301153626'),('20100302131225'),('20100303131706'),('20100308163148'),('20100308164422'),('20100310172315'),('20100310181338'),('20100311123523'),('20100315112858'),('20100319141401'),('20100322184529'),('20100324134243'),('20100324141652'),('20100331125702'),('20100415130556'),('20100415130600'),('20100415130605'),('20100415134627'),('20100419141518'),('20100419142018'),('20100419164230'),('20100426141509'),('20100428130912'),('20100429171200'),('20100430174140'),('20100610151652'),('20100610180750'),('20100614142225'),('20100614160819'),('20100614162423'),('20100616132525'),('20100616135507'),('20100622124252'),('20100706105523'),('20100710121447'),('20100710191351'),('20100716155807'),('20100719131622'),('20100721155359'),('20100722124307'),('20100812164444'),('20100812164449'),('20100812164518'),('20100812164524'),('20100817165213'),('20100819175736'),('20100820185846'),('20100906095758'),('20100915145823'),('20100929111549'),('20101001155323'),('20101005180058'),('20101022155620'),('20101117131430'),('20101208135417'),('20101209122838'),('20101222150446'),('20101223125157'),('20101223172333'),('20110106110617'),('20110117182616'),('20110119121807'),('20110125161025'),('20110128094012'),('20110201122224'),('20110211124612'),('20110214130700'),('20110214165108'),('20110215161039'),('20110221105637'),('20110224162141'),('20110224174209'),('20110307104202'),('20110307121218'),('20110309114701'),('20110309194328'),('20110310113500'),('20110311172250'),('20110314132426'),('20110317165341'),('20110329163829'),('20110330141930'),('20110410103752'),('20110413154835'),('20110420152125'),('20110420153521'),('20110422180144'),('20110426131533'),('20110426145014'),('20110429150825'),('20110430142655'),('20110501202247'),('20110502175634'),('20110503165127'),('20110506202156'),('20110509144521'),('20110520172423'),('20110529152142'),('20110530121627'),('20110601155244'),('20110606114650'),('20110606154238'),('20110615120534'),('20110620180705'),('20110621165656'),('20110627164509'),('20110711160159'),('20110728101729'),('20110731170836'),('20110801114044'),('20110802172428'),('20110807130218'),('20110807131155'),('20110807161232'),('20110812114804'),('20110905102038'),('20110911155609'),('20110916153737'),('20110920150711'),('20110922154003'),('20110924163350'),('20110924173927'),('20110927142508'),('20111003185306'),('20111013125109'),('20111024104056'),('20111027145938'),('20111115150234'),('20111119101809'),('20111125123219'),('20111202191900'),('20111208124349'),('20111229121331'),('20120107144305'),('20120113160416'),('20120116161146'),('20120117110804');
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
  `shield_ends_at` datetime DEFAULT NULL,
  `shield_owner_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uniqueness` (`galaxy_id`,`x`,`y`),
  KEY `shield_owner_id` (`shield_owner_id`),
  CONSTRAINT `solar_systems_ibfk_1` FOREIGN KEY (`galaxy_id`) REFERENCES `galaxies` (`id`) ON DELETE CASCADE,
  CONSTRAINT `solar_systems_ibfk_2` FOREIGN KEY (`shield_owner_id`) REFERENCES `players` (`id`) ON DELETE SET NULL ON UPDATE CASCADE
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
  PRIMARY KEY (`id`),
  UNIQUE KEY `uniqueness` (`solar_system_id`,`position`,`angle`),
  KEY `index_planets_on_galaxy_id_and_solar_system_id` (`solar_system_id`),
  KEY `index_planets_on_player_id_and_galaxy_id` (`player_id`),
  KEY `group_by_for_fowssentry_status_updates` (`player_id`,`solar_system_id`),
  CONSTRAINT `ss_objects_ibfk_1` FOREIGN KEY (`solar_system_id`) REFERENCES `solar_systems` (`id`) ON DELETE CASCADE,
  CONSTRAINT `ss_objects_ibfk_2` FOREIGN KEY (`player_id`) REFERENCES `players` (`id`) ON DELETE SET NULL
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
  `type` varchar(50) NOT NULL,
  `pause_scientists` int(10) unsigned DEFAULT NULL,
  `flags` tinyint(2) unsigned NOT NULL DEFAULT '0',
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
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `kind` tinyint(2) unsigned NOT NULL DEFAULT '0',
  `planet_id` int(11) NOT NULL,
  `x` tinyint(2) unsigned NOT NULL DEFAULT '0',
  `y` tinyint(2) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uniqueness` (`planet_id`,`x`,`y`),
  CONSTRAINT `tiles_ibfk_1` FOREIGN KEY (`planet_id`) REFERENCES `ss_objects` (`id`) ON DELETE CASCADE
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
  `location_id` int(10) unsigned NOT NULL,
  `location_type` tinyint(2) unsigned NOT NULL DEFAULT '0',
  `player_id` int(11) DEFAULT NULL,
  `upgrade_ends_at` datetime DEFAULT NULL,
  `pause_remainder` int(10) unsigned DEFAULT NULL,
  `xp` mediumint(8) unsigned NOT NULL DEFAULT '0',
  `type` varchar(50) NOT NULL,
  `flank` tinyint(2) unsigned NOT NULL DEFAULT '0',
  `location_x` mediumint(9) DEFAULT NULL,
  `location_y` mediumint(9) DEFAULT NULL,
  `route_id` int(11) DEFAULT NULL,
  `galaxy_id` int(11) NOT NULL,
  `stance` tinyint(2) unsigned NOT NULL DEFAULT '0',
  `construction_mod` tinyint(2) unsigned NOT NULL DEFAULT '0',
  `stored` int(10) unsigned NOT NULL DEFAULT '0',
  `metal` int(10) unsigned NOT NULL DEFAULT '0',
  `energy` int(10) unsigned NOT NULL DEFAULT '0',
  `zetium` int(10) unsigned NOT NULL DEFAULT '0',
  `hp_percentage` float unsigned NOT NULL DEFAULT '1',
  `flags` tinyint(2) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `location` (`player_id`,`location_id`,`location_type`),
  KEY `location_and_player` (`location_type`,`location_id`,`location_x`,`location_y`,`player_id`),
  KEY `index_units_on_route_id` (`route_id`),
  KEY `type` (`player_id`,`type`),
  KEY `foreign_key` (`galaxy_id`),
  CONSTRAINT `units_ibfk_1` FOREIGN KEY (`player_id`) REFERENCES `players` (`id`) ON DELETE SET NULL,
  CONSTRAINT `units_ibfk_2` FOREIGN KEY (`galaxy_id`) REFERENCES `galaxies` (`id`) ON DELETE CASCADE,
  CONSTRAINT `units_ibfk_3` FOREIGN KEY (`route_id`) REFERENCES `routes` (`id`) ON DELETE SET NULL
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
-- Table structure for table `units_bulk`
--

DROP TABLE IF EXISTS `units_bulk`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `units_bulk` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `hp_percentage` float unsigned NOT NULL DEFAULT '1',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1001 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `units_bulk`
--

LOCK TABLES `units_bulk` WRITE;
/*!40000 ALTER TABLE `units_bulk` DISABLE KEYS */;
INSERT INTO `units_bulk` VALUES (1,0.98),(2,0.98),(3,0.98),(4,0.98),(5,0.98),(6,0.98),(7,0.98),(8,0.98),(9,0.98),(10,0.98),(11,0.98),(12,0.98),(13,0.98),(14,0.98),(15,0.98),(16,0.98),(17,0.98),(18,0.98),(19,0.98),(20,0.98),(21,0.98),(22,0.98),(23,0.98),(24,0.98),(25,0.98),(26,0.98),(27,0.98),(28,0.98),(29,0.98),(30,0.98),(31,0.98),(32,0.98),(33,0.98),(34,0.98),(35,0.98),(36,0.98),(37,0.98),(38,0.98),(39,0.98),(40,0.98),(41,0.98),(42,0.98),(43,0.98),(44,0.98),(45,0.98),(46,0.98),(47,0.98),(48,0.98),(49,0.98),(50,0.98),(51,0.98),(52,0.98),(53,0.98),(54,0.98),(55,0.98),(56,0.98),(57,0.98),(58,0.98),(59,0.98),(60,0.98),(61,0.98),(62,0.98),(63,0.98),(64,0.98),(65,0.98),(66,0.98),(67,0.98),(68,0.98),(69,0.98),(70,0.98),(71,0.98),(72,0.98),(73,0.98),(74,0.98),(75,0.98),(76,0.98),(77,0.98),(78,0.98),(79,0.98),(80,0.98),(81,0.98),(82,0.98),(83,0.98),(84,0.98),(85,0.98),(86,0.98),(87,0.98),(88,0.98),(89,0.98),(90,0.98),(91,0.98),(92,0.98),(93,0.98),(94,0.98),(95,0.98),(96,0.98),(97,0.98),(98,0.98),(99,0.98),(100,0.98),(101,0.98),(102,0.98),(103,0.98),(104,0.98),(105,0.98),(106,0.98),(107,0.98),(108,0.98),(109,0.98),(110,0.98),(111,0.98),(112,0.98),(113,0.98),(114,0.98),(115,0.98),(116,0.98),(117,0.98),(118,0.98),(119,0.98),(120,0.98),(121,0.98),(122,0.98),(123,0.98),(124,0.98),(125,0.98),(126,0.98),(127,0.98),(128,0.98),(129,0.98),(130,0.98),(131,0.98),(132,0.98),(133,0.98),(134,0.98),(135,0.98),(136,0.98),(137,0.98),(138,0.98),(139,0.98),(140,0.98),(141,0.98),(142,0.98),(143,0.98),(144,0.98),(145,0.98),(146,0.98),(147,0.98),(148,0.98),(149,0.98),(150,0.98),(151,0.98),(152,0.98),(153,0.98),(154,0.98),(155,0.98),(156,0.98),(157,0.98),(158,0.98),(159,0.98),(160,0.98),(161,0.98),(162,0.98),(163,0.98),(164,0.98),(165,0.98),(166,0.98),(167,0.98),(168,0.98),(169,0.98),(170,0.98),(171,0.98),(172,0.98),(173,0.98),(174,0.98),(175,0.98),(176,0.98),(177,0.98),(178,0.98),(179,0.98),(180,0.98),(181,0.98),(182,0.98),(183,0.98),(184,0.98),(185,0.98),(186,0.98),(187,0.98),(188,0.98),(189,0.98),(190,0.98),(191,0.98),(192,0.98),(193,0.98),(194,0.98),(195,0.98),(196,0.98),(197,0.98),(198,0.98),(199,0.98),(200,0.98),(201,0.98),(202,0.98),(203,0.98),(204,0.98),(205,0.98),(206,0.98),(207,0.98),(208,0.98),(209,0.98),(210,0.98),(211,0.98),(212,0.98),(213,0.98),(214,0.98),(215,0.98),(216,0.98),(217,0.98),(218,0.98),(219,0.98),(220,0.98),(221,0.98),(222,0.98),(223,0.98),(224,0.98),(225,0.98),(226,0.98),(227,0.98),(228,0.98),(229,0.98),(230,0.98),(231,0.98),(232,0.98),(233,0.98),(234,0.98),(235,0.98),(236,0.98),(237,0.98),(238,0.98),(239,0.98),(240,0.98),(241,0.98),(242,0.98),(243,0.98),(244,0.98),(245,0.98),(246,0.98),(247,0.98),(248,0.98),(249,0.98),(250,0.98),(251,0.98),(252,0.98),(253,0.98),(254,0.98),(255,0.98),(256,0.98),(257,0.98),(258,0.98),(259,0.98),(260,0.98),(261,0.98),(262,0.98),(263,0.98),(264,0.98),(265,0.98),(266,0.98),(267,0.98),(268,0.98),(269,0.98),(270,0.98),(271,0.98),(272,0.98),(273,0.98),(274,0.98),(275,0.98),(276,0.98),(277,0.98),(278,0.98),(279,0.98),(280,0.98),(281,0.98),(282,0.98),(283,0.98),(284,0.98),(285,0.98),(286,0.98),(287,0.98),(288,0.98),(289,0.98),(290,0.98),(291,0.98),(292,0.98),(293,0.98),(294,0.98),(295,0.98),(296,0.98),(297,0.98),(298,0.98),(299,0.98),(300,0.98),(301,0.98),(302,0.98),(303,0.98),(304,0.98),(305,0.98),(306,0.98),(307,0.98),(308,0.98),(309,0.98),(310,0.98),(311,0.98),(312,0.98),(313,0.98),(314,0.98),(315,0.98),(316,0.98),(317,0.98),(318,0.98),(319,0.98),(320,0.98),(321,0.98),(322,0.98),(323,0.98),(324,0.98),(325,0.98),(326,0.98),(327,0.98),(328,0.98),(329,0.98),(330,0.98),(331,0.98),(332,0.98),(333,0.98),(334,0.98),(335,0.98),(336,0.98),(337,0.98),(338,0.98),(339,0.98),(340,0.98),(341,0.98),(342,0.98),(343,0.98),(344,0.98),(345,0.98),(346,0.98),(347,0.98),(348,0.98),(349,0.98),(350,0.98),(351,0.98),(352,0.98),(353,0.98),(354,0.98),(355,0.98),(356,0.98),(357,0.98),(358,0.98),(359,0.98),(360,0.98),(361,0.98),(362,0.98),(363,0.98),(364,0.98),(365,0.98),(366,0.98),(367,0.98),(368,0.98),(369,0.98),(370,0.98),(371,0.98),(372,0.98),(373,0.98),(374,0.98),(375,0.98),(376,0.98),(377,0.98),(378,0.98),(379,0.98),(380,0.98),(381,0.98),(382,0.98),(383,0.98),(384,0.98),(385,0.98),(386,0.98),(387,0.98),(388,0.98),(389,0.98),(390,0.98),(391,0.98),(392,0.98),(393,0.98),(394,0.98),(395,0.98),(396,0.98),(397,0.98),(398,0.98),(399,0.98),(400,0.98),(401,0.98),(402,0.98),(403,0.98),(404,0.98),(405,0.98),(406,0.98),(407,0.98),(408,0.98),(409,0.98),(410,0.98),(411,0.98),(412,0.98),(413,0.98),(414,0.98),(415,0.98),(416,0.98),(417,0.98),(418,0.98),(419,0.98),(420,0.98),(421,0.98),(422,0.98),(423,0.98),(424,0.98),(425,0.98),(426,0.98),(427,0.98),(428,0.98),(429,0.98),(430,0.98),(431,0.98),(432,0.98),(433,0.98),(434,0.98),(435,0.98),(436,0.98),(437,0.98),(438,0.98),(439,0.98),(440,0.98),(441,0.98),(442,0.98),(443,0.98),(444,0.98),(445,0.98),(446,0.98),(447,0.98),(448,0.98),(449,0.98),(450,0.98),(451,0.98),(452,0.98),(453,0.98),(454,0.98),(455,0.98),(456,0.98),(457,0.98),(458,0.98),(459,0.98),(460,0.98),(461,0.98),(462,0.98),(463,0.98),(464,0.98),(465,0.98),(466,0.98),(467,0.98),(468,0.98),(469,0.98),(470,0.98),(471,0.98),(472,0.98),(473,0.98),(474,0.98),(475,0.98),(476,0.98),(477,0.98),(478,0.98),(479,0.98),(480,0.98),(481,0.98),(482,0.98),(483,0.98),(484,0.98),(485,0.98),(486,0.98),(487,0.98),(488,0.98),(489,0.98),(490,0.98),(491,0.98),(492,0.98),(493,0.98),(494,0.98),(495,0.98),(496,0.98),(497,0.98),(498,0.98),(499,0.98),(500,0.98),(501,0.98),(502,0.98),(503,0.98),(504,0.98),(505,0.98),(506,0.98),(507,0.98),(508,0.98),(509,0.98),(510,0.98),(511,0.98),(512,0.98),(513,0.98),(514,0.98),(515,0.98),(516,0.98),(517,0.98),(518,0.98),(519,0.98),(520,0.98),(521,0.98),(522,0.98),(523,0.98),(524,0.98),(525,0.98),(526,0.98),(527,0.98),(528,0.98),(529,0.98),(530,0.98),(531,0.98),(532,0.98),(533,0.98),(534,0.98),(535,0.98),(536,0.98),(537,0.98),(538,0.98),(539,0.98),(540,0.98),(541,0.98),(542,0.98),(543,0.98),(544,0.98),(545,0.98),(546,0.98),(547,0.98),(548,0.98),(549,0.98),(550,0.98),(551,0.98),(552,0.98),(553,0.98),(554,0.98),(555,0.98),(556,0.98),(557,0.98),(558,0.98),(559,0.98),(560,0.98),(561,0.98),(562,0.98),(563,0.98),(564,0.98),(565,0.98),(566,0.98),(567,0.98),(568,0.98),(569,0.98),(570,0.98),(571,0.98),(572,0.98),(573,0.98),(574,0.98),(575,0.98),(576,0.98),(577,0.98),(578,0.98),(579,0.98),(580,0.98),(581,0.98),(582,0.98),(583,0.98),(584,0.98),(585,0.98),(586,0.98),(587,0.98),(588,0.98),(589,0.98),(590,0.98),(591,0.98),(592,0.98),(593,0.98),(594,0.98),(595,0.98),(596,0.98),(597,0.98),(598,0.98),(599,0.98),(600,0.98),(601,0.98),(602,0.98),(603,0.98),(604,0.98),(605,0.98),(606,0.98),(607,0.98),(608,0.98),(609,0.98),(610,0.98),(611,0.98),(612,0.98),(613,0.98),(614,0.98),(615,0.98),(616,0.98),(617,0.98),(618,0.98),(619,0.98),(620,0.98),(621,0.98),(622,0.98),(623,0.98),(624,0.98),(625,0.98),(626,0.98),(627,0.98),(628,0.98),(629,0.98),(630,0.98),(631,0.98),(632,0.98),(633,0.98),(634,0.98),(635,0.98),(636,0.98),(637,0.98),(638,0.98),(639,0.98),(640,0.98),(641,0.98),(642,0.98),(643,0.98),(644,0.98),(645,0.98),(646,0.98),(647,0.98),(648,0.98),(649,0.98),(650,0.98),(651,0.98),(652,0.98),(653,0.98),(654,0.98),(655,0.98),(656,0.98),(657,0.98),(658,0.98),(659,0.98),(660,0.98),(661,0.98),(662,0.98),(663,0.98),(664,0.98),(665,0.98),(666,0.98),(667,0.98),(668,0.98),(669,0.98),(670,0.98),(671,0.98),(672,0.98),(673,0.98),(674,0.98),(675,0.98),(676,0.98),(677,0.98),(678,0.98),(679,0.98),(680,0.98),(681,0.98),(682,0.98),(683,0.98),(684,0.98),(685,0.98),(686,0.98),(687,0.98),(688,0.98),(689,0.98),(690,0.98),(691,0.98),(692,0.98),(693,0.98),(694,0.98),(695,0.98),(696,0.98),(697,0.98),(698,0.98),(699,0.98),(700,0.98),(701,0.98),(702,0.98),(703,0.98),(704,0.98),(705,0.98),(706,0.98),(707,0.98),(708,0.98),(709,0.98),(710,0.98),(711,0.98),(712,0.98),(713,0.98),(714,0.98),(715,0.98),(716,0.98),(717,0.98),(718,0.98),(719,0.98),(720,0.98),(721,0.98),(722,0.98),(723,0.98),(724,0.98),(725,0.98),(726,0.98),(727,0.98),(728,0.98),(729,0.98),(730,0.98),(731,0.98),(732,0.98),(733,0.98),(734,0.98),(735,0.98),(736,0.98),(737,0.98),(738,0.98),(739,0.98),(740,0.98),(741,0.98),(742,0.98),(743,0.98),(744,0.98),(745,0.98),(746,0.98),(747,0.98),(748,0.98),(749,0.98),(750,0.98),(751,0.98),(752,0.98),(753,0.98),(754,0.98),(755,0.98),(756,0.98),(757,0.98),(758,0.98),(759,0.98),(760,0.98),(761,0.98),(762,0.98),(763,0.98),(764,0.98),(765,0.98),(766,0.98),(767,0.98),(768,0.98),(769,0.98),(770,0.98),(771,0.98),(772,0.98),(773,0.98),(774,0.98),(775,0.98),(776,0.98),(777,0.98),(778,0.98),(779,0.98),(780,0.98),(781,0.98),(782,0.98),(783,0.98),(784,0.98),(785,0.98),(786,0.98),(787,0.98),(788,0.98),(789,0.98),(790,0.98),(791,0.98),(792,0.98),(793,0.98),(794,0.98),(795,0.98),(796,0.98),(797,0.98),(798,0.98),(799,0.98),(800,0.98),(801,0.98),(802,0.98),(803,0.98),(804,0.98),(805,0.98),(806,0.98),(807,0.98),(808,0.98),(809,0.98),(810,0.98),(811,0.98),(812,0.98),(813,0.98),(814,0.98),(815,0.98),(816,0.98),(817,0.98),(818,0.98),(819,0.98),(820,0.98),(821,0.98),(822,0.98),(823,0.98),(824,0.98),(825,0.98),(826,0.98),(827,0.98),(828,0.98),(829,0.98),(830,0.98),(831,0.98),(832,0.98),(833,0.98),(834,0.98),(835,0.98),(836,0.98),(837,0.98),(838,0.98),(839,0.98),(840,0.98),(841,0.98),(842,0.98),(843,0.98),(844,0.98),(845,0.98),(846,0.98),(847,0.98),(848,0.98),(849,0.98),(850,0.98),(851,0.98),(852,0.98),(853,0.98),(854,0.98),(855,0.98),(856,0.98),(857,0.98),(858,0.98),(859,0.98),(860,0.98),(861,0.98),(862,0.98),(863,0.98),(864,0.98),(865,0.98),(866,0.98),(867,0.98),(868,0.98),(869,0.98),(870,0.98),(871,0.98),(872,0.98),(873,0.98),(874,0.98),(875,0.98),(876,0.98),(877,0.98),(878,0.98),(879,0.98),(880,0.98),(881,0.98),(882,0.98),(883,0.98),(884,0.98),(885,0.98),(886,0.98),(887,0.98),(888,0.98),(889,0.98),(890,0.98),(891,0.98),(892,0.98),(893,0.98),(894,0.98),(895,0.98),(896,0.98),(897,0.98),(898,0.98),(899,0.98),(900,0.98),(901,0.98),(902,0.98),(903,0.98),(904,0.98),(905,0.98),(906,0.98),(907,0.98),(908,0.98),(909,0.98),(910,0.98),(911,0.98),(912,0.98),(913,0.98),(914,0.98),(915,0.98),(916,0.98),(917,0.98),(918,0.98),(919,0.98),(920,0.98),(921,0.98),(922,0.98),(923,0.98),(924,0.98),(925,0.98),(926,0.98),(927,0.98),(928,0.98),(929,0.98),(930,0.98),(931,0.98),(932,0.98),(933,0.98),(934,0.98),(935,0.98),(936,0.98),(937,0.98),(938,0.98),(939,0.98),(940,0.98),(941,0.98),(942,0.98),(943,0.98),(944,0.98),(945,0.98),(946,0.98),(947,0.98),(948,0.98),(949,0.98),(950,0.98),(951,0.98),(952,0.98),(953,0.98),(954,0.98),(955,0.98),(956,0.98),(957,0.98),(958,0.98),(959,0.98),(960,0.98),(961,0.98),(962,0.98),(963,0.98),(964,0.98),(965,0.98),(966,0.98),(967,0.98),(968,0.98),(969,0.98),(970,0.98),(971,0.98),(972,0.98),(973,0.98),(974,0.98),(975,0.98),(976,0.98),(977,0.98),(978,0.98),(979,0.98),(980,0.98),(981,0.98),(982,0.98),(983,0.98),(984,0.98),(985,0.98),(986,0.98),(987,0.98),(988,0.98),(989,0.98),(990,0.98),(991,0.98),(992,0.98),(993,0.98),(994,0.98),(995,0.98),(996,0.98),(997,0.98),(998,0.98),(999,0.98),(1000,0.96);
/*!40000 ALTER TABLE `units_bulk` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `wreckages`
--

DROP TABLE IF EXISTS `wreckages`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `wreckages` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `galaxy_id` int(11) NOT NULL,
  `location_id` int(11) NOT NULL,
  `location_type` tinyint(3) unsigned NOT NULL,
  `location_x` smallint(6) NOT NULL,
  `location_y` smallint(6) NOT NULL,
  `metal` int(10) unsigned NOT NULL DEFAULT '0',
  `energy` int(10) unsigned NOT NULL DEFAULT '0',
  `zetium` int(10) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `location` (`location_id`,`location_type`,`location_x`,`location_y`),
  KEY `galaxy_id` (`galaxy_id`),
  CONSTRAINT `wreckages_ibfk_1` FOREIGN KEY (`galaxy_id`) REFERENCES `galaxies` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
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

-- Dump completed on 2012-01-18  9:33:05
