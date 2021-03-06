package spacemule.modules.pmg

import objects.Galaxy
import spacemule.modules.pmg.persistence.Manager
import spacemule.logging.Log

case class EnsurePoolResult(createdZones: Int, createdHomeSs: Int)
case class PoolStatsResult(freeZones: Int, freeHomeSs: Int)

object Runner {
  /**
   * Fills just created galaxy with necessary objects.
   *
   * Currently it only creates battleground solar system.
   *
   * @param galaxyId
   * @param ruleset
   */
  def fillGalaxy(galaxyId: Int, ruleset: String) {
    Manager.initDates()
    val galaxy = new Galaxy(galaxyId, ruleset)
    Log.block("Creating battleground") { () => galaxy.createBattleground() }
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
    Some(3)
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

  def poolStats(galaxyId: Int): PoolStatsResult = {
    val galaxy = new Galaxy(galaxyId, "default")

    Log.block("load galaxy") { () => Manager.load(galaxy) }

    PoolStatsResult(galaxy.freeZones, galaxy.freeHomeSystems)
  }
}
