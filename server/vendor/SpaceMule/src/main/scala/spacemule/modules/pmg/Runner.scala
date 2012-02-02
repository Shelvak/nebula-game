package spacemule.modules.pmg

import objects.{Zone, Galaxy, Player}
import persistence.objects.{SaveResult, CallbackRow, GalaxyRow}
import spacemule.helpers.Converters._
import spacemule.helpers.BenchmarkableMock
import spacemule.modules.pmg.objects.solar_systems.Battleground
import spacemule.modules.pmg.persistence.Manager
import spacemule.modules.config.objects.Config
import spacemule.modules.pmg.persistence.TableIds
import spacemule.persistence.DB
import java.util.{Calendar, Date}

object Runner extends BenchmarkableMock {
  /**
   * Creates galaxy with ruleset and callbackUrl. Returns galaxy id.
   */
  def createGalaxy(ruleset: String, callbackUrl: String): Int = {
    Config.withSetScope(ruleset) { () =>
      val createdAt = DB.date(new Date())
      TableIds.initialize()
      Manager.initDates()
      val galaxyRow = new GalaxyRow(ruleset, callbackUrl, createdAt)
      val galaxy = new Galaxy(galaxyRow.id, ruleset)

      val battleground = benchmark("create battleground") { 
        () =>
        val battleground = new Battleground()
        battleground.createObjects()
        battleground
      }

      benchmark("saving") { () => 
        Manager.save { () =>
          Manager.galaxies += galaxyRow.values
          Manager.callbacks += CallbackRow(
            galaxyRow, ruleset, CallbackRow.Events.Spawn,
            Config.convoyTime.fromNow
          ).values
          
          // Create system offer creation cooldowns.
          List(
            CallbackRow.Events.CreateMetalSystemOffer,
            CallbackRow.Events.CreateEnergySystemOffer,
            CallbackRow.Events.CreateZetiumSystemOffer
          ).foreach { event => 
            Manager.callbacks += CallbackRow(
              galaxyRow, ruleset, event,
              Config.marketBotRandomResourceCooldown.fromNow
            ).values
          }

          Manager.readSolarSystem(galaxy, None, battleground)
        }
      }
      printBenchmarkResults()
      
      galaxyRow.id
    }
  }

  def createPlayers(
    ruleset: String,
    galaxyId: Int,
    // web user id -> player name
    players: Map[Long, String]
  ): SaveResult = {
    Config.withSetScope(ruleset) { () =>
      val galaxy = new Galaxy(galaxyId, ruleset)

      benchmark("load galaxy") { () => Manager.load(galaxy) }

      players.foreach { case(webUserId, name) =>
        val player = Player(name, webUserId)
        benchmark("create player") { () => galaxy.createZoneFor(player) }
      }

      val result = benchmark("save galaxy") { () => Manager.save(galaxy) }
      printBenchmarkResults()

      result
    }
  }
  
  def createZone(
    ruleset: String,
    galaxyId: Int,
    // [1, 4]
    quarter: Int,
    // [1, inf)
    slot: Int
  ) = {
    Config.withSetScope(ruleset) { () =>
      TableIds.initialize()
      val galaxy = new Galaxy(galaxyId, ruleset)

      benchmark("generate zone") { () =>
        galaxy.addZone(Zone(slot, quarter, Config.zoneDiameter))
      }

      val result = benchmark("save galaxy") { () => Manager.save(galaxy) }
      printBenchmarkResults()

      result
    }
  }
}
