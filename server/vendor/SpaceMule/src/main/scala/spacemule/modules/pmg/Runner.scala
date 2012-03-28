package spacemule.modules.pmg

import objects.{Zone, Galaxy, Player}
import persistence.objects.{SaveResult, CallbackRow, GalaxyRow}
import spacemule.helpers.Converters._
import spacemule.helpers.BenchmarkableMock
import spacemule.modules.pmg.objects.solar_systems.Battleground
import spacemule.modules.pmg.persistence.Manager
import spacemule.modules.config.objects.Config
import java.util.{Calendar, Date}
import spacemule.persistence.{ReferableRow, DB}

object Runner extends BenchmarkableMock {
  /**
   * Creates galaxy with ruleset and callbackUrl. Returns galaxy id.
   */
  @EnhanceStrings
  def createGalaxy(ruleset: String, callbackUrl: String): Int = {
    Config.withSetScope(ruleset) { () =>
      Manager.buffers.transaction { () =>
        val createdAt = DB.date(new Date())
        val galaxyId = DB.insert("""
          INSERT INTO `#Manager.GalaxiesTable` SET
          `ruleset`=?, `callback_url`=?, `created_at`=?
        """, List(ruleset, callbackUrl, createdAt))
        val galaxyRow = new GalaxyRow(galaxyId)

        Manager.initDates()

        Manager.save { () =>
          Manager.callbacks += CallbackRow(
            galaxyRow, ruleset, CallbackRow.Events.Spawn,
            Config.convoyTime.fromNow
          )

          // Create system offer creation cooldowns.
          List(
            CallbackRow.Events.CreateMetalSystemOffer,
            CallbackRow.Events.CreateEnergySystemOffer,
            CallbackRow.Events.CreateZetiumSystemOffer
          ).foreach { event =>
            Manager.callbacks += CallbackRow(
              galaxyRow, ruleset, event,
              Config.marketBotRandomResourceCooldown.fromNow
            )
          }

          val galaxy = new Galaxy(galaxyId, ruleset)
          val battleground = new Battleground()
          battleground.createObjects()
          Manager.readSolarSystem(galaxy, None, battleground)

          galaxyId
        }
      }
    }
  }

  def createPlayers(
    ruleset: String,
    galaxyId: Int,
    // web user id -> player name
    players: Map[Long, String]
  ): SaveResult = {
    Config.withSetScope(ruleset) { () =>
      Manager.buffers.transaction { () =>
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
  
  def createZone(
    ruleset: String,
    galaxyId: Int,
    // [1, 4]
    quarter: Int,
    // [1, inf)
    slot: Int
  ) = {
    Config.withSetScope(ruleset) { () =>
      Manager.buffers.transaction { () =>
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
}
