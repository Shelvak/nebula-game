-- phpMyAdmin SQL Dump
-- version 3.3.2deb1
-- http://www.phpmyadmin.net
--
-- Host: localhost
-- Generation Time: Sep 02, 2011 at 01:16 AM
-- Server version: 5.5.13
-- PHP Version: 5.3.2-1ubuntu4.9

SET SQL_MODE="NO_AUTO_VALUE_ON_ZERO";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;

--
-- Database: `spacegame_game`
--

-- --------------------------------------------------------

DROP DATABASE `spacegame`;
CREATE DATABASE `spacegame` DEFAULT CHARACTER SET utf8 COLLATE utf8_lithuanian_ci;

USE `spacegame`;

-- SET UNIQUE_CHECKS=0;
SET FOREIGN_KEY_CHECKS=0;
SET SQL_MODE='NO_AUTO_VALUE_ON_ZERO'; 


--
-- Table structure for table `alliances`
--

CREATE TABLE IF NOT EXISTS `alliances` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(50) NOT NULL,
  `galaxy_id` int(11) NOT NULL,
  `owner_id` int(11) NOT NULL,
  `description` text NOT NULL,
  `victory_points` int(10) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uniq_galaxy_name` (`name`,`galaxy_id`),
  KEY `foreign_key` (`galaxy_id`),
  KEY `owner_id` (`owner_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=7 ;

-- --------------------------------------------------------

--
-- Table structure for table `buildings`
--

CREATE TABLE IF NOT EXISTS `buildings` (
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
  PRIMARY KEY (`id`),
  UNIQUE KEY `tiles_taken` (`planet_id`,`x`,`y`,`x_end`,`y_end`),
  KEY `index_buildings_on_construction_ends` (`upgrade_ends_at`),
  KEY `buildings_by_type` (`planet_id`,`type`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=151153 ;

-- --------------------------------------------------------

--
-- Table structure for table `callbacks`
--

CREATE TABLE IF NOT EXISTS `callbacks` (
  `class` varchar(50) NOT NULL,
  `object_id` int(10) unsigned NOT NULL,
  `ends_at` datetime NOT NULL,
  `event` tinyint(2) unsigned NOT NULL DEFAULT '0',
  `ruleset` varchar(30) NOT NULL,
  UNIQUE KEY `main` (`class`,`object_id`,`event`),
  KEY `tick` (`ends_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `chat_messages`
--

CREATE TABLE IF NOT EXISTS `chat_messages` (
  `source_id` int(11) NOT NULL,
  `target_id` int(11) NOT NULL,
  `message` varchar(255) NOT NULL,
  `created_at` datetime NOT NULL,
  KEY `index_chat_messages_on_source_id` (`source_id`),
  KEY `index_chat_messages_on_target_id` (`target_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `combat_logs`
--

CREATE TABLE IF NOT EXISTS `combat_logs` (
  `sha1_id` char(40) NOT NULL,
  `info` mediumtext NOT NULL,
  `expires_at` datetime NOT NULL,
  PRIMARY KEY (`sha1_id`),
  KEY `index_combat_logs_on_expires_at` (`expires_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `construction_queue_entries`
--

CREATE TABLE IF NOT EXISTS `construction_queue_entries` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `constructable_type` varchar(100) NOT NULL,
  `constructor_id` int(11) NOT NULL,
  `count` int(11) NOT NULL,
  `position` smallint(2) unsigned NOT NULL DEFAULT '0',
  `params` text,
  `player_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_upgrade_queue_entries_on_position` (`position`),
  KEY `foreign_key` (`constructor_id`),
  KEY `player_id` (`player_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=28123 ;

-- --------------------------------------------------------

--
-- Table structure for table `cooldowns`
--

CREATE TABLE IF NOT EXISTS `cooldowns` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `location_id` int(10) unsigned NOT NULL,
  `location_type` tinyint(2) unsigned NOT NULL,
  `location_x` int(11) DEFAULT NULL,
  `location_y` int(11) DEFAULT NULL,
  `ends_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `location` (`location_id`,`location_type`,`location_x`,`location_y`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=14205 ;

-- --------------------------------------------------------

--
-- Table structure for table `cred_stats`
--

CREATE TABLE IF NOT EXISTS `cred_stats` (
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
  KEY `by_player` (`player_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=41582 ;

-- --------------------------------------------------------

--
-- Table structure for table `folliages`
--

CREATE TABLE IF NOT EXISTS `folliages` (
  `planet_id` int(11) NOT NULL,
  `x` tinyint(2) unsigned NOT NULL DEFAULT '0',
  `y` tinyint(2) unsigned NOT NULL DEFAULT '0',
  `kind` tinyint(2) unsigned NOT NULL DEFAULT '0',
  UNIQUE KEY `coords` (`planet_id`,`x`,`y`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `fow_galaxy_entries`
--

CREATE TABLE IF NOT EXISTS `fow_galaxy_entries` (
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
  KEY `for_cleanup` (`counter`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=1380 ;

-- --------------------------------------------------------

--
-- Table structure for table `fow_ss_entries`
--

CREATE TABLE IF NOT EXISTS `fow_ss_entries` (
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
  KEY `for_cleanup` (`counter`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=29324 ;

-- --------------------------------------------------------

--
-- Table structure for table `galaxies`
--

CREATE TABLE IF NOT EXISTS `galaxies` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `created_at` datetime NOT NULL,
  `ruleset` varchar(30) NOT NULL DEFAULT '0',
  `callback_url` varchar(255) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=3 ;

-- --------------------------------------------------------

--
-- Table structure for table `market_offers`
--

CREATE TABLE IF NOT EXISTS `market_offers` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `galaxy_id` int(11) NOT NULL,
  `planet_id` int(10) DEFAULT NULL,
  `from_kind` tinyint(2) unsigned NOT NULL,
  `from_amount` int(10) unsigned NOT NULL,
  `to_kind` tinyint(2) unsigned NOT NULL,
  `to_rate` float unsigned NOT NULL,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `galaxy foreign key` (`galaxy_id`),
  KEY `planet foreign key` (`planet_id`),
  KEY `avg. market value` (`from_kind`,`to_kind`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=4452 ;

-- --------------------------------------------------------

--
-- Table structure for table `naps`
--

CREATE TABLE IF NOT EXISTS `naps` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `initiator_id` int(11) NOT NULL,
  `acceptor_id` int(11) NOT NULL,
  `status` tinyint(2) unsigned NOT NULL DEFAULT '0',
  `created_at` datetime NOT NULL,
  `expires_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `enforce_one_nap_per_pair` (`initiator_id`,`acceptor_id`),
  KEY `lookup_naps_for_alliance_1st` (`initiator_id`,`status`),
  KEY `lookup_naps_for_alliance_2nd` (`acceptor_id`,`status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `notifications`
--

CREATE TABLE IF NOT EXISTS `notifications` (
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
  KEY `player_with_event` (`player_id`,`event`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=156207 ;

-- --------------------------------------------------------

--
-- Table structure for table `objectives`
--

CREATE TABLE IF NOT EXISTS `objectives` (
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
  KEY `on_progress` (`type`,`key`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=247 ;

-- --------------------------------------------------------

--
-- Table structure for table `objective_progresses`
--

CREATE TABLE IF NOT EXISTS `objective_progresses` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `objective_id` int(11) DEFAULT NULL,
  `player_id` int(11) DEFAULT NULL,
  `completed` int(10) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `objective_fk` (`objective_id`),
  KEY `player_fk` (`player_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=233689 ;

-- --------------------------------------------------------

--
-- Table structure for table `players`
--

CREATE TABLE IF NOT EXISTS `players` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `galaxy_id` int(11) DEFAULT NULL,
  `auth_token` char(64) NOT NULL,
  `name` varchar(64) NOT NULL,
  `scientists` int(10) unsigned NOT NULL DEFAULT '0',
  `scientists_total` int(10) unsigned NOT NULL DEFAULT '0',
  `alliance_id` int(11) DEFAULT NULL,
  `xp` int(10) unsigned NOT NULL DEFAULT '0',
  `war_points` int(10) unsigned NOT NULL DEFAULT '0',
  `first_time` tinyint(1) NOT NULL DEFAULT '1',
  `army_points` int(10) unsigned NOT NULL DEFAULT '0',
  `science_points` int(10) unsigned NOT NULL DEFAULT '0',
  `economy_points` int(10) unsigned NOT NULL DEFAULT '0',
  `planets_count` tinyint(2) unsigned NOT NULL,
  `last_login` datetime DEFAULT NULL,
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
  `vip_free` tinyint(1) DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `authentication` (`galaxy_id`,`auth_token`),
  KEY `index_players_on_alliance_id` (`alliance_id`),
  KEY `last_login` (`last_login`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=1608 ;

-- --------------------------------------------------------

--
-- Table structure for table `quests`
--

CREATE TABLE IF NOT EXISTS `quests` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `parent_id` int(11) DEFAULT NULL,
  `rewards` text,
  `help_url_id` varchar(255) DEFAULT NULL,
  `achievement` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `child quests` (`parent_id`),
  KEY `index_quests_on_achievement` (`achievement`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=10407 ;

-- --------------------------------------------------------

--
-- Table structure for table `quest_progresses`
--

CREATE TABLE IF NOT EXISTS `quest_progresses` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `quest_id` int(11) NOT NULL,
  `player_id` int(11) NOT NULL,
  `status` tinyint(2) unsigned NOT NULL,
  `completed` tinyint(2) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `on_objective_complete` (`quest_id`,`player_id`),
  KEY `listing` (`player_id`,`status`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=232401 ;

-- --------------------------------------------------------

--
-- Table structure for table `routes`
--

CREATE TABLE IF NOT EXISTS `routes` (
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
  `first_hop` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `incoming_routes` (`target_type`,`target_id`),
  KEY `foreign_key` (`player_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=38880 ;

-- --------------------------------------------------------

--
-- Table structure for table `route_hops`
--

CREATE TABLE IF NOT EXISTS `route_hops` (
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
  KEY `next` (`route_id`,`next`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=124467 ;

-- --------------------------------------------------------

--
-- Table structure for table `schema_migrations`
--

CREATE TABLE IF NOT EXISTS `schema_migrations` (
  `version` varchar(255) NOT NULL,
  UNIQUE KEY `unique_schema_migrations` (`version`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `solar_systems`
--

CREATE TABLE IF NOT EXISTS `solar_systems` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `galaxy_id` int(11) NOT NULL,
  `x` mediumint(9) DEFAULT NULL,
  `y` mediumint(9) DEFAULT NULL,
  `kind` tinyint(2) NOT NULL DEFAULT '0',
  `shield_ends_at` datetime DEFAULT NULL,
  `shield_owner_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uniqueness` (`galaxy_id`,`x`,`y`),
  KEY `shield_owner_id` (`shield_owner_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=2434 ;

-- --------------------------------------------------------

--
-- Table structure for table `ss_objects`
--

CREATE TABLE IF NOT EXISTS `ss_objects` (
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
  `shield_ends_at` datetime DEFAULT NULL,
  `shield_owner_id` int(11) DEFAULT NULL,
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
  PRIMARY KEY (`id`),
  UNIQUE KEY `uniqueness` (`solar_system_id`,`position`,`angle`),
  KEY `index_planets_on_galaxy_id_and_solar_system_id` (`solar_system_id`),
  KEY `index_planets_on_player_id_and_galaxy_id` (`player_id`),
  KEY `group_by_for_fowssentry_status_updates` (`player_id`,`solar_system_id`),
  KEY `shield_owner_id` (`shield_owner_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=25879 ;

-- --------------------------------------------------------

--
-- Table structure for table `technologies`
--

CREATE TABLE IF NOT EXISTS `technologies` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `upgrade_ends_at` datetime DEFAULT NULL,
  `pause_remainder` int(10) unsigned DEFAULT NULL,
  `scientists` int(10) unsigned DEFAULT '0',
  `level` tinyint(2) unsigned NOT NULL,
  `player_id` int(11) NOT NULL,
  `type` varchar(50) NOT NULL,
  `pause_scientists` int(10) unsigned DEFAULT NULL,
  `speed_up` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `main` (`player_id`,`type`,`level`),
  UNIQUE KEY `type_by_player` (`player_id`,`type`,`level`),
  UNIQUE KEY `ensure_uniqueness` (`player_id`,`type`),
  KEY `upgrading` (`player_id`,`upgrade_ends_at`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=6767 ;

-- --------------------------------------------------------

--
-- Table structure for table `tiles`
--

CREATE TABLE IF NOT EXISTS `tiles` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `kind` tinyint(2) unsigned NOT NULL DEFAULT '0',
  `planet_id` int(11) NOT NULL,
  `x` tinyint(2) unsigned NOT NULL DEFAULT '0',
  `y` tinyint(2) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uniqueness` (`planet_id`,`x`,`y`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=1453547 ;

-- --------------------------------------------------------

--
-- Table structure for table `units`
--

CREATE TABLE IF NOT EXISTS `units` (
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
  `metal` float NOT NULL DEFAULT '0',
  `energy` float NOT NULL DEFAULT '0',
  `zetium` float NOT NULL DEFAULT '0',
  `hp_percentage` float unsigned NOT NULL DEFAULT '1',
  PRIMARY KEY (`id`),
  KEY `location` (`player_id`,`location_id`,`location_type`),
  KEY `location_and_player` (`location_type`,`location_id`,`location_x`,`location_y`,`player_id`),
  KEY `index_units_on_route_id` (`route_id`),
  KEY `type` (`player_id`,`type`),
  KEY `foreign_key` (`galaxy_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=1114176 ;

-- --------------------------------------------------------

--
-- Table structure for table `wreckages`
--

CREATE TABLE IF NOT EXISTS `wreckages` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `galaxy_id` int(11) DEFAULT NULL,
  `location_id` int(11) NOT NULL,
  `location_type` tinyint(3) unsigned NOT NULL,
  `location_x` smallint(6) NOT NULL,
  `location_y` smallint(6) NOT NULL,
  `metal` float NOT NULL DEFAULT '0',
  `energy` float NOT NULL DEFAULT '0',
  `zetium` float NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `location` (`location_id`,`location_type`,`location_x`,`location_y`),
  KEY `galaxy_id` (`galaxy_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=19850 ;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `alliances`
--
ALTER TABLE `alliances`
  ADD CONSTRAINT `alliances_ibfk_1` FOREIGN KEY (`galaxy_id`) REFERENCES `galaxies` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `alliances_ibfk_2` FOREIGN KEY (`owner_id`) REFERENCES `players` (`id`) ON DELETE NO ACTION;

--
-- Constraints for table `buildings`
--
ALTER TABLE `buildings`
  ADD CONSTRAINT `buildings_ibfk_1` FOREIGN KEY (`planet_id`) REFERENCES `ss_objects` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `chat_messages`
--
ALTER TABLE `chat_messages`
  ADD CONSTRAINT `chat_messages_ibfk_1` FOREIGN KEY (`source_id`) REFERENCES `players` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `chat_messages_ibfk_2` FOREIGN KEY (`target_id`) REFERENCES `players` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `construction_queue_entries`
--
ALTER TABLE `construction_queue_entries`
  ADD CONSTRAINT `construction_queue_entries_ibfk_1` FOREIGN KEY (`constructor_id`) REFERENCES `buildings` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `construction_queue_entries_ibfk_2` FOREIGN KEY (`player_id`) REFERENCES `players` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `cred_stats`
--
ALTER TABLE `cred_stats`
  ADD CONSTRAINT `cred_stats_ibfk_1` FOREIGN KEY (`player_id`) REFERENCES `players` (`id`) ON DELETE SET NULL;

--
-- Constraints for table `folliages`
--
ALTER TABLE `folliages`
  ADD CONSTRAINT `folliages_ibfk_1` FOREIGN KEY (`planet_id`) REFERENCES `ss_objects` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `fow_galaxy_entries`
--
ALTER TABLE `fow_galaxy_entries`
  ADD CONSTRAINT `fow_galaxy_entries_ibfk_1` FOREIGN KEY (`galaxy_id`) REFERENCES `galaxies` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `fow_ss_entries`
--
ALTER TABLE `fow_ss_entries`
  ADD CONSTRAINT `fow_ss_entries_ibfk_1` FOREIGN KEY (`solar_system_id`) REFERENCES `solar_systems` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `fow_ss_entries_ibfk_2` FOREIGN KEY (`player_id`) REFERENCES `players` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `fow_ss_entries_ibfk_3` FOREIGN KEY (`alliance_id`) REFERENCES `alliances` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `market_offers`
--
ALTER TABLE `market_offers`
  ADD CONSTRAINT `market_offers_ibfk_1` FOREIGN KEY (`galaxy_id`) REFERENCES `galaxies` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `market_offers_ibfk_2` FOREIGN KEY (`planet_id`) REFERENCES `ss_objects` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `naps`
--
ALTER TABLE `naps`
  ADD CONSTRAINT `naps_ibfk_1` FOREIGN KEY (`initiator_id`) REFERENCES `alliances` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `naps_ibfk_2` FOREIGN KEY (`acceptor_id`) REFERENCES `alliances` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `notifications`
--
ALTER TABLE `notifications`
  ADD CONSTRAINT `notifications_ibfk_1` FOREIGN KEY (`player_id`) REFERENCES `players` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `objectives`
--
ALTER TABLE `objectives`
  ADD CONSTRAINT `objectives_ibfk_1` FOREIGN KEY (`quest_id`) REFERENCES `quests` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `objective_progresses`
--
ALTER TABLE `objective_progresses`
  ADD CONSTRAINT `objective_progresses_ibfk_1` FOREIGN KEY (`objective_id`) REFERENCES `objectives` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `objective_progresses_ibfk_2` FOREIGN KEY (`player_id`) REFERENCES `players` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `players`
--
ALTER TABLE `players`
  ADD CONSTRAINT `players_ibfk_1` FOREIGN KEY (`galaxy_id`) REFERENCES `galaxies` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `players_ibfk_2` FOREIGN KEY (`alliance_id`) REFERENCES `alliances` (`id`) ON DELETE SET NULL;

--
-- Constraints for table `quests`
--
ALTER TABLE `quests`
  ADD CONSTRAINT `quests_ibfk_1` FOREIGN KEY (`parent_id`) REFERENCES `quests` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `quest_progresses`
--
ALTER TABLE `quest_progresses`
  ADD CONSTRAINT `quest_progresses_ibfk_1` FOREIGN KEY (`quest_id`) REFERENCES `quests` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `quest_progresses_ibfk_2` FOREIGN KEY (`player_id`) REFERENCES `players` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `routes`
--
ALTER TABLE `routes`
  ADD CONSTRAINT `routes_ibfk_1` FOREIGN KEY (`player_id`) REFERENCES `players` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `route_hops`
--
ALTER TABLE `route_hops`
  ADD CONSTRAINT `route_hops_ibfk_1` FOREIGN KEY (`route_id`) REFERENCES `routes` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `solar_systems`
--
ALTER TABLE `solar_systems`
  ADD CONSTRAINT `solar_systems_ibfk_1` FOREIGN KEY (`galaxy_id`) REFERENCES `galaxies` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `solar_systems_ibfk_2` FOREIGN KEY (`shield_owner_id`) REFERENCES `players` (`id`) ON DELETE SET NULL;

--
-- Constraints for table `ss_objects`
--
ALTER TABLE `ss_objects`
  ADD CONSTRAINT `ss_objects_ibfk_1` FOREIGN KEY (`solar_system_id`) REFERENCES `solar_systems` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `ss_objects_ibfk_2` FOREIGN KEY (`player_id`) REFERENCES `players` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `ss_objects_ibfk_3` FOREIGN KEY (`shield_owner_id`) REFERENCES `players` (`id`) ON DELETE SET NULL;

--
-- Constraints for table `technologies`
--
ALTER TABLE `technologies`
  ADD CONSTRAINT `technologies_ibfk_1` FOREIGN KEY (`player_id`) REFERENCES `players` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `tiles`
--
ALTER TABLE `tiles`
  ADD CONSTRAINT `tiles_ibfk_1` FOREIGN KEY (`planet_id`) REFERENCES `ss_objects` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `units`
--
ALTER TABLE `units`
  ADD CONSTRAINT `units_ibfk_1` FOREIGN KEY (`player_id`) REFERENCES `players` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `units_ibfk_2` FOREIGN KEY (`galaxy_id`) REFERENCES `galaxies` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `units_ibfk_3` FOREIGN KEY (`route_id`) REFERENCES `routes` (`id`) ON DELETE SET NULL;

--
-- Constraints for table `wreckages`
--
ALTER TABLE `wreckages`
  ADD CONSTRAINT `wreckages_ibfk_1` FOREIGN KEY (`galaxy_id`) REFERENCES `galaxies` (`id`) ON DELETE CASCADE;
