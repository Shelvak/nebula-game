package spacemule.modules.pmg

import persistence.objects.{SaveResult, CallbackRow, GalaxyRow}
import spacemule.helpers.Converters._
import java.util.Date
import spacemule.helpers.BenchmarkableMock
import spacemule.modules.pmg.objects.Galaxy
import spacemule.modules.pmg.objects.Player
import spacemule.modules.pmg.objects.solar_systems.Battleground
import spacemule.modules.pmg.persistence.Manager
import spacemule.modules.config.objects.Config
import spacemule.modules.pmg.persistence.TableIds
import spacemule.persistence.DB

object Runner extends BenchmarkableMock {
  /**
   * Creates galaxy with ruleset and callbackUrl. Returns galaxy id.
   */
  def createGalaxy(ruleset: String, callbackUrl: String): Int = {
    Config.withSetScope(ruleset) { () =>
      val createdAt = DB.date(new Date())
      TableIds.initialize()
      val galaxyRow = new GalaxyRow(ruleset, callbackUrl, createdAt)
      CallbackRow.initConvoySpawn

      val battleground = benchmark("create battleground") { 
        () =>
        val battleground = new Battleground()
        battleground.createObjects()
        battleground
      }

      benchmark("saving") { () => 
        Manager.save { () =>
          Manager.galaxies += galaxyRow.values
          Manager.callbacks += CallbackRow(galaxyRow, ruleset).values
          
          // Create system offer creation cooldowns.
          List(
            CallbackRow.Events.CreateMetalSystemOffer,
            CallbackRow.Events.CreateEnergySystemOffer,
            CallbackRow.Events.CreateZetiumSystemOffer
          ).foreach { event => 
            Manager.callbacks += CallbackRow(
              galaxyRow, ruleset, Some(event),
              Some(Config.marketBotRandomResourceCooldown.fromNow())
            ).values
          }
          val battlegroundRow = Manager.readBattleground(
            galaxyRow.id,
            new Galaxy(galaxyRow.id, ruleset),
            battleground
          )
          Manager.callbacks += CallbackRow(
            battlegroundRow, ruleset,
            Some(CallbackRow.Events.Spawn),
            Some(0.seconds.fromNow)
          ).values
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
}
