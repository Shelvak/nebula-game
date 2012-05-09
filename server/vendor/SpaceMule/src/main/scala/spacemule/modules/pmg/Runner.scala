package spacemule.modules.pmg

import objects.Galaxy
import spacemule.modules.pmg.persistence.Manager
import spacemule.logging.Log

case class EnsurePoolResult(createdZones: Int, createdHomeSs: Int)

object Runner {
  /**
   * Fills just created galaxy with objects.
   *
   * Creates battleground, given number of free zones and given number of pooled
   * home systems.
   *
   * @param galaxyId
   * @param ruleset
   * @param freeZoneCount
   * @param freeHomeSsCount
   */
  def fillGalaxy(
    galaxyId: Int, ruleset: String, freeZoneCount: Int, freeHomeSsCount: Int
  ) {
    Manager.initDates()
    val galaxy = new Galaxy(galaxyId, ruleset)

    Log.block("Creating battleground") { () => galaxy.createBattleground() }
    Log.block("Ensuring "+freeZoneCount+" free zones") { () =>
      galaxy.ensureFreeZones(freeZoneCount)
    }
    Log.block("Ensuring "+freeHomeSsCount+" free home ss") { () =>
      galaxy.ensureFreeHomeSystems(freeHomeSsCount)
    }

    Log.block("Saving galaxy") { () => Manager.save(galaxy) }
  }

  /**
   * Ensures that enough free zones and home solar systems exist in the galaxy
   * pool.
   *
   * @param galaxyId
   * @param ruleset
   * @param freeZones ensured number of free zones.
   * @param maxZoneIterations max number of zones per generation.
   * @param freeHomeSystems ensured number of free home solar systems.
   * @param maxHomeIterations max number of home ss per generation.
   */
  def ensurePool(
    galaxyId: Int, ruleset: String,
    freeZones: Int, maxZoneIterations: Int,
    freeHomeSystems: Int, maxHomeIterations: Int
  ): EnsurePoolResult = {
    require(
      freeZones >= 0,
      "free zones should be >= 0, but was "+freeZones
    )
    require(
      maxZoneIterations > 0,
      "max zone iterations should be > 0, but was "+maxZoneIterations
    )
    require(
      freeHomeSystems >= 0,
      "free home ss should be >= 0, but was "+freeHomeSystems
    )
    require(
      maxHomeIterations > 0,
      "max home ss iterations should be > 0, but was "+maxHomeIterations
    )

    val galaxy = new Galaxy(galaxyId, ruleset)

    Log.block("load galaxy") { () => Manager.load(galaxy) }

    val createdZones = Log.block("ensure free zones") { () =>
      galaxy.ensureFreeZones(freeZones, Some(maxZoneIterations))
    }
    val createdHomeSs = Log.block("ensure free home ss") { () =>
      galaxy.ensureFreeHomeSystems(freeHomeSystems, Some(maxHomeIterations))
    }

    Log.block("save galaxy") { () => Manager.save(galaxy) }

    EnsurePoolResult(createdZones, createdHomeSs)
  }
}
