package spacemule.modules.pmg

import spacemule.helpers.Converters._
import java.util.Date
import spacemule.helpers.BenchmarkableMock
import spacemule.modules.pmg.objects.Galaxy
import spacemule.modules.pmg.objects.Player
import spacemule.modules.pmg.objects.solar_systems.Battleground
import spacemule.modules.pmg.persistence.Manager
import spacemule.modules.config.objects.Config
import spacemule.modules.pmg.persistence.TableIds
import spacemule.modules.pmg.persistence.objects.CallbackRow
import spacemule.modules.pmg.persistence.objects.GalaxyRow
import spacemule.persistence.DB

object Runner extends BenchmarkableMock {
  def createGalaxy(input: Map[String, Any]): Map[String, Any] = {
    val ruleset = getRuleset(input)
    val callbackUrl = input.getOrError("callback_url").asInstanceOf[String]
    return Config.withSetScope(ruleset) { () =>
      val createdAt = DB.date(new Date())
      TableIds.initialize
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
              Some(Config.marketBotRandomResourceCooldown.fromNow)
            ).values
          }
          Manager.readBattleground(
            galaxyRow.id,
            new Galaxy(galaxyRow.id, ruleset),
            battleground
          )
        }
      }
      printBenchmarkResults()
      
      Map("id" -> galaxyRow.id)
    }
  }

  def createPlayers(input: Map[String, Any]): Map[String, Any] = {
    val ruleset = getRuleset(input)

    return Config.withSetScope(ruleset) { () =>
      val galaxy = new Galaxy(
        input.getOrError(
          "galaxy_id", "'galaxy_id' was not defined!"
        ).asInstanceOf[Int],
        ruleset
      )

      benchmark("load galaxy") { () => Manager.load(galaxy) }

      input.getOrError(
        "players",
        "'players' must be defined!"
      ).asInstanceOf[Map[String, String]].foreach { case(authToken, name) =>
        val player = Player(name, authToken)
        benchmark("create player") { () => galaxy.createZoneFor(player) }
      }

      val result = benchmark("save galaxy") { () => Manager.save(galaxy) }
      printBenchmarkResults()

      Map(
        "updated_player_ids" -> result.updatedPlayerIds,
        "updated_alliance_ids" -> result.updatedAllianceIds
      )
    }
  }

  private def getRuleset(input: Map[String, Any]): String = input.getOrError(
    "ruleset", "'ruleset' was not defined!"
  ).asInstanceOf[String]
}
