package spacemule.modules.config.objects

/**
 * Created by IntelliJ IDEA.
 * User: arturas
 * Date: Oct 13, 2010
 * Time: 11:50:18 AM
 * To change this template use File | Settings | File Templates.
 */

import java.math.BigDecimal
import spacemule.helpers.Converters._
import spacemule.modules.pmg.classes.geom.Coords
import spacemule.modules.pmg.classes.geom.area.Area
import spacemule.modules.pmg.classes.geom.area.AreaTileConfig
import spacemule.modules.pmg.classes.{Chance, ObjectChance, UnitChance}
import spacemule.modules.pmg.objects._
import spacemule.modules.pmg.objects.planet.tiles.AreaTile
import spacemule.modules.pmg.objects.planet.tiles.BlockTile
import spacemule.modules.pmg.objects.solar_systems._
import spacemule.modules.pmg.objects.ss_objects.{RichAsteroid, Asteroid}
import spacemule.modules.pmg.objects.planet._
import spacemule.modules.pmg.objects.planet.buildings._
import net.java.dev.eval.Expression
import scala.collection.Map

object Config {
  /**
   * Default set name.
   */
  val DefaultSet = "default"

  /**
   * Various game configuration sets.
   */
  var sets = Map[String, Map[String, Any]]()

  /**
   * Current set from which to take configuration.
   */
  private var currentSet = DefaultSet

  /**
   * Executes given block with required set.
   */
  def withSetScope[T](set: String)(block: () => T): T = {
    val oldSet = currentSet
    currentSet = set
    val result = block()
    currentSet = oldSet
    return result
  }

  private def get[T](key: String): T = {
    val set = sets.getOrError(
      currentSet,
      "Config set '%s' not found!".format(currentSet)
    )

    return set.getOrError(
      key,
      "Key '%s' not found in config set '%s'!".format(key, currentSet)
    ).asInstanceOf[T]
  }

  //////////////////////////////////////////////////////////////////////////////
  // Helper methods
  //////////////////////////////////////////////////////////////////////////////

  private def int(key: String) = get[Int](key)
  private def string(key: String) = get[String](key)
  private def double(key: String) = get[Double](key)
  private def list[T](key: String) = get[List[T]](key)
  private def area(key: String) = Area(
    int("%s.width".format(key)), int("%s.height".format(key))
  )
  def formula(key: String): Expression = {
    val formula = get[Any](key).toString
    return new Expression(formula.replaceAll("\\*\\*", "pow"))
  }
  private def formulaEval(key: String,
                          vars: Map[String, BigDecimal]): BigDecimal = {
    return formulaEval(formula(key), vars)
  }
  private def formulaEval(exp: Expression,
                          vars: Map[String, BigDecimal]): BigDecimal = {
    if (vars == null) {
      return exp.eval()
    }
    else {
      val javaMap = new java.util.HashMap[String, BigDecimal]()
      vars.foreach { case (key, value) =>
          javaMap.put(key, value)
      }
      return exp.eval(javaMap)
    }
  }

  private def range(key: String): Range = {
    val rangeData = list[Int](key)
    return Range.inclusive(rangeData(0), rangeData(1))
  }

  private def areaTileConfig(name: String): AreaTileConfig = {
    return AreaTileConfig(
      range("planet.tiles.%s.isles".format(name)).random,
      range("planet.tiles.%s".format(name)).random
    )
  }

  private def chances(name: String): List[Chance] = list[List[Int]](
    name
  ).map { chanceList => 
    Chance(chanceList(0), chanceList(1))
  }

  private def objectChances(name: String): List[ObjectChance] = {
    list[List[Any]](name).map { chanceList =>
        ObjectChance(
          chanceList(0).asInstanceOf[Int],
          chanceList(1).asInstanceOf[Int],
          chanceList(2).asInstanceOf[String].camelcase
        )
    }
  }

  private def unitChances(name: String): List[UnitChance] = {
    list[List[Any]](name).map { chanceList =>
        UnitChance(
          chanceList(0).asInstanceOf[Int],
          chanceList(1).asInstanceOf[Int],
          chanceList(2).asInstanceOf[String].camelcase,
          chanceList(3).asInstanceOf[Int]
        )
    }
  }

  private def positions(name: String): List[Coords] = {
    list[List[Int]](name).map { coordsList =>
      Coords(coordsList(0), coordsList(1))
    }
  }

  private def map(name: String) = get[List[String]](name).reverse

  //////////////////////////////////////////////////////////////////////////////
  // Reader methods 
  //////////////////////////////////////////////////////////////////////////////

  def zoneDiameter = int("galaxy.zone.diameter")
  def playersPerZone = int("galaxy.zone.players")
  def expansionSolarSystems = int("galaxy.expansion_systems.number")
  def resourceSolarSystems = int("galaxy.resource_systems.number")
  def wormholes = positions("galaxy.wormholes.positions")

  def orbitCount = int("solar_system.orbit.count")

  def orbitLinkWeight(position: Int) = formulaEval(
    "solar_system.links.orbit.weight",
    Map("position" -> new BigDecimal(position)))
  def parentLinkWeight(position: Int) = formulaEval(
    "solar_system.links.parent.weight",
    Map("position" -> new BigDecimal(position)))
  def planetLinkWeight = double("solar_system.links.planet.weight")

  def planetCount(solarSystem: SolarSystem) = solarSystem match {
    case ss: Wormhole => 0
    case ss: Battleground => battlegroundPlanetPositions.size
    case ss: Homeworld => int("solar_system.homeworld.planet.count")
    case ss: Expansion => range("solar_system.expansion.planet.count").random
    case ss: Resource => range("solar_system.resources.planet.count").random
  }

  def battlegroundPlanetPositions =
    positions("solar_system.battleground.planet.positions")

  def asteroidCount(solarSystem: SolarSystem) = solarSystem match {
    case ss: Wormhole => 0
    case ss: Battleground => 0
    case ss: Homeworld => int("solar_system.homeworld.asteroid.count")
    case ss: Expansion => range("solar_system.expansion.asteroid.count").random
    case ss: Resource => range("solar_system.resources.asteroid.count").random
  }

  def richAsteroidCount(solarSystem: SolarSystem) = solarSystem match {
    case ss: Wormhole => 0
    case ss: Battleground => 0
    case ss: Homeworld => int("solar_system.homeworld.rich_asteroid.count")
    case ss: Expansion => range(
        "solar_system.expansion.rich_asteroid.count").random
    case ss: Resource => range(
        "solar_system.resources.rich_asteroid.count").random
  }

  def jumpgateCount(solarSystem: SolarSystem) = solarSystem match {
    case ss: Wormhole => 0
    case ss: Battleground => battlegroundJumpgatePositions.size
    case ss: Homeworld => int("solar_system.homeworld.jumpgate.count")
    case ss: Expansion => range("solar_system.expansion.jumpgate.count").random
    case ss: Resource => range("solar_system.resources.jumpgate.count").random
  }

  def battlegroundJumpgatePositions =
    positions("solar_system.battleground.jumpgate.positions")

  def asteroidRateStep = double("ss_object.asteroid.rate_step")

  def asteroidMetalRate(asteroid: Asteroid): Double = asteroid match {
    case asteroid: RichAsteroid =>
      range("ss_object.rich_asteroid.metal_rate").random(asteroidRateStep)
    case asteroid: Asteroid =>
      range("ss_object.asteroid.metal_rate").random(asteroidRateStep)
  }

  def asteroidEnergyRate(asteroid: Asteroid): Double = asteroid match {
    case asteroid: RichAsteroid =>
      range("ss_object.rich_asteroid.energy_rate").random(asteroidRateStep)
    case asteroid: Asteroid =>
      range("ss_object.asteroid.energy_rate").random(asteroidRateStep)
  }

  def asteroidZetiumRate(asteroid: Asteroid): Double = asteroid match {
    case asteroid: RichAsteroid =>
      range("ss_object.rich_asteroid.zetium_rate").random(asteroidRateStep)
    case asteroid: Asteroid =>
      range("ss_object.asteroid.zetium_rate").random(asteroidRateStep)
  }

  def ssObjectSize = range("ss_object.size")
  def planetAreaMax = int("planet.area.max")
  def planetArea = range("planet.area").random
  def planetProportion = range("planet.area.proportion").random / 100.0

  def homeSolarSystemPlanetsArea = int("planet.home_system.area")

  def homeworldMap = map("planet.homeworld.map")
  def battlegroundPlanetMaps = (0 until battlegroundPlanetPositions.size).map {
    index => map("planet.battleground.map.%d".format(index))
  }
  
  def homeworldStartingMetal: Double = 
    double("buildings.mothership.metal.starting")
  def homeworldStartingMetalRate: Double =
    double("buildings.mothership.metal.generate")
  def homeworldStartingMetalStorage: Double =
    double("buildings.mothership.metal.store")
  def homeworldStartingEnergy: Double =
    double("buildings.mothership.energy.starting")
  def homeworldStartingEnergyRate: Double =
    double("buildings.mothership.energy.generate")
  def homeworldStartingEnergyStorage: Double =
    double("buildings.mothership.energy.store")
  def homeworldStartingZetium: Double =
    double("buildings.mothership.zetium.starting")
  def homeworldStartingZetiumRate: Double =
    double("buildings.mothership.zetium.generate")
  def homeworldStartingZetiumStorage: Double =
    double("buildings.mothership.zetium.store")
  def homeworldStartingScientists: Int =
    double("buildings.mothership.scientists").toInt

  def planetBlockTileCount(tile: BlockTile): Int = tile match {
    case BlockTile.Ore => range("planet.tiles.ore").random
    case BlockTile.Geothermal => range("planet.tiles.geothermal").random
    case BlockTile.Zetium => range("planet.tiles.zetium").random
    case BlockTile.Folliage3X3 => range("planet.tiles.f3x3").random
    case BlockTile.Folliage3X4 => range("planet.tiles.f3x4").random
    case BlockTile.Folliage4X3 => range("planet.tiles.f4x3").random
    case BlockTile.Folliage4X4 => range("planet.tiles.f4x4").random
    case BlockTile.Folliage4X6 => range("planet.tiles.f4x6").random
    case BlockTile.Folliage6X6 => range("planet.tiles.f6x6").random
    case BlockTile.Folliage6X2 => range("planet.tiles.f6x2").random
  }

  def planetAreaTileConfig(tile: AreaTile): AreaTileConfig = tile match {
    case AreaTile.Regular => AreaTileConfig(
      1, range("planet.tiles.regular").random
    )
    case AreaTile.Noxrium => areaTileConfig("noxrium")
    case AreaTile.Junkyard => areaTileConfig("junkyard")
    case AreaTile.Titan => areaTileConfig("titan")
    case AreaTile.Sand => areaTileConfig("sand")
    case AreaTile.Water => areaTileConfig("water")
  }

  def resourceTileImportance(blockTile: BlockTile): Int = blockTile match {
    case BlockTile.Ore => int("ss_object.planet.ore.importance")
    case BlockTile.Geothermal => int("ss_object.planet.geothermal.importance")
    case BlockTile.Zetium => int("ss_object.planet.zetium.importance")
  }

  def jumpgateImportance = range("ss_object.jumpgate.importance").random
  def homeworldJumpgateImportance = int(
    "ss_object.homeworld_jumpgate.importance")

  def asteroidImportance(metalStorage: Double, energyStorage: Double,
                         zetiumStorage: Double): Int = {
    return (
            metalStorage * int("ss_object.asteroid.metal.importance") +
            energyStorage * int("ss_object.asteroid.energy.importance") +
            zetiumStorage * int("ss_object.asteroid.zetium.importance")
    ).round.toInt
  }

  def ssObjectOrbitUnitChances = chances("ss_object.orbit.unit.chances")
  def homeworldSsObjectOrbitUnitsChances = chances(
    "ss_object.homeworld.orbit.unit.chances")

  def extractorNpcChance(blockTile: BlockTile): Int = blockTile match {
    case BlockTile.Ore => int("planet.npc.tiles.ore.chance")
    case BlockTile.Geothermal => 
      int("planet.npc.tiles.geothermal.chance")
    case BlockTile.Zetium => int("planet.npc.tiles.zetium.chance")
  }

  def getBuildingArea(name: String): Area = area(
    "buildings.%s".format(name.underscore))

  def npcBuildingChances = objectChances("planet.npc.building.chances")

  def npcBuildingImportance(building: Npc): Int = building.name match {
    case "NpcMetalExtractor" => 
      int("planet.npc.building.metal_extractor.importance")
    case "NpcGeothermalPlant" =>
      int("planet.npc.building.geothermal_plant.importance")
    case "NpcZetiumExtractor" =>
      int("planet.npc.building.zetium_extractor.importance")
    case _ => building.area.area
  }

  def buildingHp(building: Building) = 
    int("buildings.%s.hp".format(building.name.underscore))

  def unitHp(unit: Unit) = int("units.%s.hp".format(unit.name.underscore))

  def npcOrbitUnitChances = 
    unitChances("ss_object.orbit.units")

  def homeworldOrbitUnits =
    unitChances("ss_object.homeworld.orbit.units")

  def npcHomeworldBuildingUnitChances =
    unitChances("planet.npc.homeworld.building.units")

  def npcBuildingUnitChances =
    unitChances("planet.npc.building.units")

  def folliagePercentage = range("planet.folliage.area").random
  def folliageVariations = int("ui.planet.folliage.variations")

  def folliageCount1stType = range("planet.folliage.type.1.count").random
  def folliageSpacingRadius1stType = 
    int("planet.folliage.type.2.spacing_radius")
  def folliageKinds1stType(terrainType: Int) = list[Int](
    "planet.folliage.type.1.variations.%d".format(terrainType)
  )

  def folliagePercentage2ndType = 
    range("planet.folliage.type.2.percentage").random
  def folliageSpacingRadius2ndType = 
    int("planet.folliage.type.2.spacing_radius")
  def folliageKinds2ndType(terrainType: Int) = list[Int](
    "planet.folliage.type.2.variations.%d".format(terrainType)
  )
}