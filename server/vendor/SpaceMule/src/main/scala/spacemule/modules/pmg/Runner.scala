package spacemule.modules.pmg

import objects.{Zone, Galaxy, Player}
import persistence.objects.{SaveResult, CallbackRow, GalaxyRow}
import spacemule.helpers.Converters._
import spacemule.helpers.JRuby._
import spacemule.helpers.BenchmarkableMock
import spacemule.modules.pmg.objects.solar_systems.Battleground
import spacemule.modules.pmg.persistence.Manager
import spacemule.modules.config.objects.Config
import java.util.Date
import spacemule.persistence.DB
import spacemule.logging.Log
import org.jruby.RubyHash

object Runner extends BenchmarkableMock {
  /**
   * Creates galaxy with ruleset and callbackUrl. Returns galaxy id.
   */
  @EnhanceStrings
  def createGalaxy(ruleset: String, callbackUrl: String): Int = {
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

  def createPlayer(
    ruleset: String, galaxyId: Int, webUserId: Int, playerName: String
  ): SaveResult = {
    val galaxy = new Galaxy(galaxyId, ruleset)

    Log.block("load galaxy", level=Log.Debug) { () =>
      Manager.load(galaxy)
    }

    val player = Player(playerName, webUserId)
    Log.block("create player", level=Log.Debug) { () =>
      galaxy.createZoneFor(player)
    }

    val result = Log.block("save galaxy", level=Log.Debug) { () =>
      Manager.save(galaxy)
    }
    printBenchmarkResults()

    result
  }
  
  def createZone(
    ruleset: String,
    galaxyId: Int,
    // [1, 4]
    quarter: Int,
    // [1, inf)
    slot: Int
  ) = {
    val galaxy = new Galaxy(galaxyId, ruleset)

    benchmark("generate zone") { () =>
      galaxy.addZone(Zone(slot, quarter, Config.zoneDiameter))
    }

    val result = benchmark("save galaxy") { () => Manager.save(galaxy) }
    printBenchmarkResults()

    result
  }
}
