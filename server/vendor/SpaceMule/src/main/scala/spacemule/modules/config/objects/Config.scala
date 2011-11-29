package spacemule.modules.config.objects

import java.math.BigDecimal
import scala.collection.mutable.HashMap
import spacemule.helpers.Converters._
import spacemule.modules.pmg.classes.geom.Coords
import spacemule.modules.pmg.classes.geom.area.Area
import spacemule.modules.pmg.classes.geom.area.AreaTileConfig
import spacemule.modules.pmg.classes.{ObjectChance, UnitChance}
import spacemule.modules.pmg.objects._
import spacemule.modules.pmg.objects.planet.tiles.AreaTile
import spacemule.modules.pmg.objects.planet.tiles.BlockTile
import spacemule.modules.pmg.objects.solar_systems._
import spacemule.modules.pmg.objects.ss_objects.{RichAsteroid, Asteroid}
import spacemule.modules.pmg.objects.planet._
import spacemule.modules.pmg.objects.planet.buildings._
import spacemule.modules.combat
import spacemule.modules.pathfinder.{objects => pfo}
import net.java.dev.eval.Expression
import scala.collection.Map
import spacemule.modules.combat.objects.{Combatant, Damage, Armor, Stance}

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
    result
  }

  private def getOpt[T](key: String): Option[T] =
    sets.getOrError(
      currentSet,
      "Config set '%s' not found!".format(currentSet)
    ).get(key).asInstanceOf[Option[T]]

  private def get[T](key: String): T =
    getOpt[T](key) match {
      case Some(value) => value
      case None => throw new NoSuchElementException(
        "Key '%s' not found in config set '%s'!".format(key, currentSet)
      )
    }

  //////////////////////////////////////////////////////////////////////////////
  // Helper methods
  //////////////////////////////////////////////////////////////////////////////
  
  private def int(key: String) = get[Any](key) match {
    case i: Int => i
    case l: Long => l.toInt
    case d: Double => d.toInt
    case value: AnyRef => sys.error(
      "Cannot convert %s of class %s to Int (key: %s)!".format(
        value.toString, value.getClass, key)
      )
    case value => sys.error(
      "Cannot convert %s of AnyVal to Int (key: %s)!".format(
        value.toString, key)
      )
  }
  private def string(key: String) = get[String](key)
  private def double(key: String) = get[Any](key) match {
    case i: Int => i.toDouble
    case l: Long => l.toDouble
    case d: Double => d
    case value: AnyRef => sys.error(
      "Cannot convert %s of class %s to Double (key: %s)!".format(
        value.toString, value.getClass, key)
      )
    case value => sys.error(
      "Cannot convert %s of AnyVal to Double (key: %s)!".format(
        value.toString, key)
      )
  }
  private def seq[T](key: String) = get[Seq[T]](key)
  private def area(key: String) = new Area(
    int("%s.width".format(key)), int("%s.height".format(key))
  )
  
  def formula(formula: String, vars: Map[String, BigDecimal]): BigDecimal = {
    formulaEval(parseFormula(formula), vars)
  }

  private def parseFormula(formula: String) =
    new Expression(formula.replaceAll("\\*\\*", "pow"))

  def formulaEval(key: String,
                  vars: Map[String, BigDecimal]): BigDecimal = {
    val formula = get[Any](key).toString
    formulaEval(parseFormula(formula), vars)
  }

  def formulaEval(key: String, vars: Map[String, BigDecimal],
                  default: BigDecimal): BigDecimal = {
    getOpt[Any](key) match {
      case Some(value) => this.formula(value.toString, vars)
      case None => default
    }
  }
  
  private def formulaEval(exp: Expression,
                          vars: Map[String, BigDecimal]): BigDecimal = {
    if (vars == null) {
      exp.eval()
    }
    else {
      val javaMap = new java.util.HashMap[String, BigDecimal]()
      vars.foreach { case (key, value) =>
          javaMap.put(key, value)
      }

      exp.eval(javaMap)
    }
  }

  private def range(key: String): Range = {
    val rangeData = seq[Long](key)

    Range.inclusive(rangeData(0).toInt, rangeData(1).toInt)
  }
  
  /**
   * Same as range(), but range limits are formulas with speed.
   */
  private def evalRange(key: String): Range = {
    val rangeData = seq[String](key)
    val params = Map("speed" -> new BigDecimal(speed))
    val from = formula(rangeData(0), params).intValue
    val to = formula(rangeData(1), params).intValue

    Range.inclusive(from, to)
  }

  private def areaTileConfig(name: String): AreaTileConfig =
    AreaTileConfig(
      range("planet.tiles.%s.isles".format(name)).random,
      range("planet.tiles.%s".format(name)).random
    )

  private def objectChances(name: String): Seq[ObjectChance] = {
    seq[Seq[Any]](name).map { chanceSeq =>
        ObjectChance(
          chanceSeq(0).asInstanceOf[Long].toInt,
          chanceSeq(1).asInstanceOf[String].camelcase
        )
    }
  }

  private def unitChances(name: String): Seq[UnitChance] = {
    seq[Seq[Any]](name).map { chanceSeq =>
        UnitChance(
          chanceSeq(0).asInstanceOf[Long].toInt,
          chanceSeq(1).asInstanceOf[Long].toInt,
          chanceSeq(2).asInstanceOf[String].camelcase,
          chanceSeq(3).asInstanceOf[Long].toInt
        )
    }
  }

  private def positions(name: String): Seq[Coords] = {
    seq[Seq[Long]](name).map { coordsSeq =>
      Coords(coordsSeq(0).toInt, coordsSeq(1).toInt)
    }
  }

  private def map(name: String) = get[Seq[String]](name).reverse

  private def unitsEntry(name: String) = get[Seq[Seq[Any]]](name).map {
    entry => new UnitsEntry(entry)
  }

  private def cost(key: String) = double(key).ceil.toInt
  private def cost(key: String, level: Int) =
    formulaEval(key, Map("level" -> level.toBigDecimal)).
      doubleValue().ceil.toInt
  private def speed = int("speed")

  //////////////////////////////////////////////////////////////////////////////
  // Reader methods 
  //////////////////////////////////////////////////////////////////////////////

  def zoneDiameter = int("galaxy.zone.diameter")
  def playersPerZone = int("galaxy.zone.players")
  def playerShieldDuration = int("galaxy.player.shield_duration")
  def playerInactivityCheck = int("galaxy.player.inactivity_check")
  lazy val expansionSolarSystems =
    positions("galaxy.expansion_systems.positions")
  lazy val resourceSolarSystems =
    positions("galaxy.resource_systems.positions")
  lazy val wormholes = positions("galaxy.wormholes.positions")
  lazy val miniBattlegrounds = positions("galaxy.mini_battlegrounds.positions")
  def convoyTime = int("galaxy.convoy.time")
  def marketBotResourceCooldownRange = 
    evalRange("market.bot.resources.cooldown")
  def marketBotRandomResourceCooldown = marketBotResourceCooldownRange.random

  // Combat attributes

  lazy val maxFlankIndex = int("combat.flanks.max")
  lazy val combatLineHitChance = double("combat.line_hit_chance")
  lazy val combatMaxDamageChance = double("combat.max_damage_chance")
  lazy val combatRoundTicks = int("combat.round.ticks")
  lazy val wreckageRange = range("combat.wreckage.range")

  def damageModifier(damage: Damage.Type, armor: Armor.Type) = double(
    "damages.%s.%s".format(Damage.toString(damage), Armor.toString(armor)))

  def stanceProperty(stance: Stance.Type, property: String) = stance match {
    case Stance.Normal => 1.0
    case _ => double("combat.stance.%d.%s".format(stance.id, property))
  }
  def stanceDamageMod(stance: Stance.Type) = stanceProperty(stance, "damage")
  def stanceArmorMod(stance: Stance.Type) = stanceProperty(stance, "armor")

  lazy val metalVolume = double("units.transportation.volume.metal")
  lazy val energyVolume = double("units.transportation.volume.energy")
  lazy val zetiumVolume = double("units.transportation.volume.zetium")

  private lazy val battlegroundCombatVpsExpression = parseFormula(
    get[String]("battleground.battle.victory_points")
  )
  def battlegroundCombatVps(groundDamage: Int, spaceDamage: Int): Double =
    formulaEval(battlegroundCombatVpsExpression, Map(
      "damage_dealt_to_ground" -> groundDamage.toBigDecimal,
      "damage_dealt_to_space" -> spaceDamage.toBigDecimal
    )).doubleValue()

  def vpsForReceivedDamage(combatant: Combatant, damage: Int): Double = {
    val key = "%s.vps_on_damage".format(resolveCombatantKey(combatant))
    val multiplier = getOpt[Double](key) match {
      case Some(v) => v
      case None => 0.0
    }
    multiplier * damage
  }

  def credsForKilling(combatant: Combatant): Int = {
    val key = "%s.creds_for_killing".format(resolveCombatantKey(combatant))
    getOpt[Long](key) match {
      case Some(v) => v.toInt
      case None => 0
    }
  }

  // End of combat attributes

  def orbitCount = int("solar_system.orbit.count")

  def orbitLinkWeight(position: Int) = formulaEval(
    "solar_system.links.orbit.weight",
    Map("position" -> new BigDecimal(position)))
  def parentLinkWeight(position: Int) = formulaEval(
    "solar_system.links.parent.weight",
    Map("position" -> new BigDecimal(position)))
  def planetLinkWeight = double("solar_system.links.planet.weight")
  def wormholeHopMultiplier(ss: pfo.SolarSystem) = 
    if (ss.isGlobalBattleground)
      double("solar_system.battleground.jump.multiplier") 
    else 
      double("solar_system.regular.jump.multiplier")

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

  def asteroidFirstSpawnCooldown = int(
    "ss_object.asteroid.wreckage.time.first")

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
  def homeworldStartingEnergy: Double =
    double("buildings.mothership.energy.starting")
  def homeworldStartingZetium: Double =
    double("buildings.mothership.zetium.starting")
  def startingScientists: Int =
    double("buildings.mothership.scientists").toInt
  def startingPopulationMax: Int =
    int("galaxy.player.population") + int("buildings.mothership.population")

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
  }

  def extractorNpcChance(blockTile: BlockTile): Int = blockTile match {
    case BlockTile.Ore => int("planet.npc.tiles.ore.chance")
    case BlockTile.Geothermal => 
      int("planet.npc.tiles.geothermal.chance")
    case BlockTile.Zetium => int("planet.npc.tiles.zetium.chance")
  }

  def getBuildingArea(name: String): Area = area(
    "buildings.%s".format(name.underscore))

  private def buildingRate(kind: String)
                          (building: Building, resource: String) = {
    val name = building.name.underscore
    val level = building.level.toBigDecimal
    val default = 0.toBigDecimal
    
    formulaEval(
      "buildings.%s.%s.%s".format(name, resource, kind), Map("level" -> level),
      default
    )
  }

  private val buildingGenerationRate = buildingRate("generate") _
  def buildingMetalGenerationRate(building: Building) = 
    buildingGenerationRate(building, "metal")
  def buildingEnergyGenerationRate(building: Building) = 
    buildingGenerationRate(building, "energy")
  def buildingZetiumGenerationRate(building: Building) = 
    buildingGenerationRate(building, "zetium")

  private val buildingUsageRate = buildingRate("use") _
  def buildingMetalUsageRate(building: Building) = 
    buildingUsageRate(building, "metal")
  def buildingEnergyUsageRate(building: Building) = 
    buildingUsageRate(building, "energy")
  def buildingZetiumUsageRate(building: Building) = 
    buildingUsageRate(building, "zetium")

  private def buildingStorage(building: Building, resource: String) = {
    val name = building.name.underscore
    val level = building.level.toBigDecimal
    val default = 0.toBigDecimal

    formulaEval(
      "buildings.%s.%s.store".format(name, resource), Map("level" -> level),
      default
    )
  }

  def buildingMetalStorage(building: Building) =
    buildingStorage(building, "metal")
  def buildingEnergyStorage(building: Building) =
    buildingStorage(building, "energy")
  def buildingZetiumStorage(building: Building) =
    buildingStorage(building, "zetium")

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

  // Common combatant attributes

  type GunDefinition = Map[String, Any]
  private val gunDefinitionsCache = HashMap[String, Seq[GunDefinition]]()
  private def gunDefinitions(name: String) = {
    gunDefinitionsCache ||= (name, seq[GunDefinition](name))
    gunDefinitionsCache(name)
  }

  private def resolveCombatantKey(combatant: Combatant): String = {
    val format: String = combatant match {
      case b: combat.objects.Building => "buildings.%s"
      case t: combat.objects.Troop => "units.%s"
      case other =>
        sys.error("Unknown combatant class: %s".format(other.getClass))
    }
    format.format(combatant.name.underscore)
  }

  // End of combatant attributes

  // Building attributes

  lazy val battlegroundBuildingMaxLevel = 
    int("buildings.battleground.max_level")
  
  def buildingInitiative(name: String) =
    int("buildings.%s.initiative".format(name.underscore))
  def buildingHp(building: Building): Int = buildingHp(building.name)
  def buildingHp(name: String) =
    int("buildings.%s.hp".format(name.underscore))

  def metalCost(b: combat.objects.Building) =
    cost("buildings.%s.metal.cost".format(b.name.underscore), b.level)
  def energyCost(b: combat.objects.Building) =
    cost("buildings.%s.energy.cost".format(b.name.underscore), b.level)
  def zetiumCost(b: combat.objects.Building) =
    cost("buildings.%s.zetium.cost".format(b.name.underscore), b.level)
  def buildingGunDefinitions(name: String) =
    gunDefinitions("buildings.%s.guns".format(name.underscore))

  // End of building attributes
  
  // Troop attributes
  def troopGalaxySsHopTimeRatio = double("units.galaxy_ss_hop_ratio")

  def troopKind(name: String) =
    string("units.%s.kind".format(name.underscore))
  def troopArmor(name: String) =
    string("units.%s.armor".format(name.underscore))
  def troopArmorModifier(name: String, level: Int) =
    formulaEval("units.%s.armor_mod".format(name.underscore),
                Map("level" -> new BigDecimal(level))).doubleValue / 100
  def troopInitiative(name: String) =
    int("units.%s.initiative".format(name.underscore))
  def troopHp(unit: Troop): Int = troopHp(unit.name)
  def troopHp(name: String) = int("units.%s.hp".format(name.underscore))

  def troopMetalCost(name: String) =
    cost("units.%s.metal.cost".format(name.underscore))
  def troopEnergyCost(name: String) =
    cost("units.%s.energy.cost".format(name.underscore))
  def troopZetiumCost(name: String) =
    cost("units.%s.zetium.cost".format(name.underscore))
  def troopGunDefinitions(name: String) =
    gunDefinitions("units.%s.guns".format(name.underscore))

  // End of unit attributes

  // Ground units configuration
  
  lazy val regularPlanetGroundUnits = unitsEntry(
    "ss_object.regular.planet.units")
  lazy val homeworldPlanetGroundUnits = unitsEntry(
    "ss_object.homeworld.planet.units")
  lazy val homeworldExpansionPlanetGroundUnits = unitsEntry(
    "ss_object.homeworld.expansion_planet.units")
  lazy val battlegroundPlanetGroundUnits = unitsEntry(
    "ss_object.battleground.planet.units")
  
  // End of ground units configuration
  
  // Orbit units configuration

  lazy val regularPlanetOrbitUnits = unitsEntry(
    "ss_object.regular.orbit.planet.units")
  lazy val regularRichAsteroidOrbitUnits = unitsEntry(
    "ss_object.regular.orbit.rich_asteroid.units")
  lazy val regularAsteroidOrbitUnits = unitsEntry(
    "ss_object.regular.orbit.asteroid.units")
  lazy val regularJumpgateOrbitUnits = unitsEntry(
    "ss_object.regular.orbit.jumpgate.units")

  lazy val homeworldPlanetOrbitUnits = unitsEntry(
    "ss_object.homeworld.orbit.planet.units")
  lazy val homeworldExpansionPlanetOrbitUnits = unitsEntry(
    "ss_object.homeworld.orbit.expansion_planet.units")
  lazy val homeworldRichAsteroidOrbitUnits = unitsEntry(
    "ss_object.homeworld.orbit.rich_asteroid.units")
  lazy val homeworldAsteroidOrbitUnits = unitsEntry(
    "ss_object.homeworld.orbit.asteroid.units")
  lazy val homeworldJumpgateOrbitUnits = unitsEntry(
    "ss_object.homeworld.orbit.jumpgate.units")

  lazy val battlegroundPlanetOrbitUnits = unitsEntry(
    "ss_object.battleground.orbit.planet.units")
  lazy val battlegroundRichAsteroidOrbitUnits = unitsEntry(
    "ss_object.battleground.orbit.rich_asteroid.units")
  lazy val battlegroundAsteroidOrbitUnits = unitsEntry(
    "ss_object.battleground.orbit.asteroid.units")
  lazy val battlegroundJumpgateOrbitUnits = unitsEntry(
    "ss_object.battleground.orbit.jumpgate.units")

  // End of orbit units configuration

  lazy val npcHomeworldBuildingUnitChances =
    unitChances("planet.npc.homeworld.building.units")

  lazy val npcBuildingUnitChances =
    unitChances("planet.npc.building.units")

  def folliagePercentage = range("planet.folliage.area").random
  def folliageVariations = int("ui.planet.folliage.variations")

  def folliageCount1stType = range("planet.folliage.type.1.count").random
  def folliageSpacingRadius1stType = 
    int("planet.folliage.type.2.spacing_radius")
  def folliageKinds1stType(terrainType: Int) = seq[Long](
    "planet.folliage.type.1.variations.%d".format(terrainType)
  ).map { _.toInt }

  def folliagePercentage2ndType = 
    range("planet.folliage.type.2.percentage").random
  def folliageSpacingRadius2ndType = 
    int("planet.folliage.type.2.spacing_radius")
  def folliageKinds2ndType(terrainType: Int) = seq[Long](
    "planet.folliage.type.2.variations.%d".format(terrainType)
  ).map { _.toInt }

  def raidingDelayRange = evalRange("raiding.delay")
  def raidingDelayRandomDate = raidingDelayRange.random.seconds.fromNow
}