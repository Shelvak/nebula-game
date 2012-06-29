package spacemule.modules.config.objects

import _root_.java.util.NoSuchElementException
import spacemule.helpers.Converters._
import spacemule.modules.pmg.classes.geom.Coords
import spacemule.modules.pmg.classes.geom.area.Area
import spacemule.modules.pmg.objects._
import spacemule.modules.pmg.objects.planet._
import spacemule.modules.combat
import spacemule.modules.pathfinder.{objects => pfo}
import scala.collection.Map
import scala.{collection => sc}
import spacemule.modules.combat.objects.{Combatant, Damage, Armor, Stance}
import spacemule.modules.config.ScalaConfig
import core.Values._
import _root_.java.{util => ju}
import scala.collection.mutable.HashMap

object Config {
  /**
   * Default set name.
   */
  val DefaultSet = "default"

  var _data: ScalaConfig = null
  def data: ScalaConfig = {
    if (_data == null)
      throw new UninitializedFieldError(
        "data for config has not been set yet!"
      )

    _data
  }
  // Called by JRuby
  def setData(value: ScalaConfig) { _data = value }

  //////////////////////////////////////////////////////////////////////////////
  // Helper methods
  //////////////////////////////////////////////////////////////////////////////

  private def any(key: String): Any = data.any(key) match {
    case None => throw new NoSuchElementException("Unknown config key: "+key)
    case Some(x) => x
  }
  private def int(key: String): Int = data.int(key) match {
    case None => throw new NoSuchElementException("Unknown config key: "+key)
    case Some(x) => x
  }
  private def string(key: String): String = data.string(key) match {
    case None => throw new NoSuchElementException("Unknown config key: "+key)
    case Some(x) => x
  }
  private def symbol(key: String): Symbol = data.symbol(key) match {
    case None => throw new NoSuchElementException("Unknown config key: "+key)
    case Some(x) => x
  }
  private def boolean(key: String): Boolean = data.boolean(key) match {
    case None => throw new NoSuchElementException("Unknown config key: "+key)
    case Some(x) => x
  }
  private def float(key: String): Float = data.float(key) match {
    case None => throw new NoSuchElementException("Unknown config key: "+key)
    case Some(x) => x
  }
  private def double(key: String): Double = data.double(key) match {
    case None => throw new NoSuchElementException("Unknown config key: "+key)
    case Some(x) => x
  }
  private def seq[T](key: String): sc.Seq[T] =
    data.array[T](key) match {
      case None => throw new NoSuchElementException("Unknown config key: "+key)
      case Some(x) => x
    }
  private def map[K, V](key: String): sc.Map[K, V] =
    data.hash[K, V](key) match {
      case None => throw new NoSuchElementException("Unknown config key: "+key)
      case Some(x) => x
    }
  
  private def anyOpt(key: String) = data.any(key)
  private def intOpt(key: String) = data.int(key)
  private def stringOpt(key: String) = data.string(key)
  private def symbolOpt(key: String) = data.symbol(key)
  private def booleanOpt(key: String) = data.boolean(key)
  private def floatOpt(key: String) = data.float(key)
  private def doubleOpt(key: String) = data.double(key)
  private def seqOpt[T](key: String) = data.array[T](key)
  private def mapOpt[K, V](key: String) = data.hash[K, V](key)

  //////////////////////////////////////////////////////////////////////////////
  // End of helper methods
  //////////////////////////////////////////////////////////////////////////////

  private def area(key: String) = new Area(
    int("%s.width".format(key)), int("%s.height".format(key))
  )

  private def formulaEvalMatch(
    key: String, value: Any, calc: String => Double
  ) =
    value match {
      case s: String => calc(s)
      case l: Long => l.toDouble
      case d: Double => d
      case x: Any => throw new RuntimeException(
        "Unknown formula value for key '"+key+"': "+x
      )
    }

  def formulaEval(key: String): Double =
    formulaEvalMatch(key, any(key), s => FormulaCalc.calc(s, speedMap))

  def formulaEval(key: String, vars: Map[String, Double]): Double =
    formulaEvalMatch(key, any(key), s => FormulaCalc.calc(s, speedMap ++ vars))

  def formulaEval(key: String, default: Double): Double =
    anyOpt(key) match {
      case None => default
      case Some(value) =>
        formulaEvalMatch(key, value, s => FormulaCalc.calc(s, speedMap))
    }

  def formulaEval(
    key: String, vars: Map[String, Double], default: Double
  ): Double =
    anyOpt(key) match {
      case None => default
      case Some(value) =>
        formulaEvalMatch(key, value, s => FormulaCalc.calc(s, speedMap ++ vars))
    }

  private def range(key: String): Range = {
    val rangeData = seq[Long](key)
    Range.inclusive(rangeData(0).toInt, rangeData(1).toInt)
  }
  
  /**
   * Same as range(), but range limits are formulas with speed.
   */
  private def evalRange(key: String): Range = {
    val rangeData = seq(key)
    val speedMap = this.speedMap
    val from = FormulaCalc.calc(rangeData(0).toString, speedMap).toInt
    val to = FormulaCalc.calc(rangeData(1).toString, speedMap).toInt

    Range.inclusive(from, to)
  }

//  private def objectChances(name: String): Seq[ObjectChance] = {
//    buffer[ju.List[AnyRef]](name).map { chances =>
//      ObjectChance(
//        chances(0).asInstanceOf[Long].toInt,
//        chances(1).asInstanceOf[String].camelcase
//      )
//    }
//  }

  private def positions(name: String): Seq[Coords] = {
    seq[sc.Seq[Long]](name).map { coords =>
      Coords(coords(0), coords(1))
    }
  }

  private def cost(key: String) = any(key) match {
    case d: Double => d.ceil.toInt
    case l: Long => l.toInt
  }
  private def cost(key: String, level: Int) =
    formulaEval(key, Map("level" -> level.toDouble)).ceil.toInt

  //////////////////////////////////////////////////////////////////////////////
  // Reader methods 
  //////////////////////////////////////////////////////////////////////////////

  def speed = int("speed")
  def speedMap = Map("speed" -> int("speed").toDouble)

  def zoneStartSlot = int("galaxy.zone.start_slot")
  def zoneDiameter = int("galaxy.zone.diameter")
  def zoneMaturityAge = int("galaxy.zone.maturity_age")
  def playersPerZone = int("galaxy.zone.players")
//  // Number of seconds for first inactivity check.
//  def playerInactivityCheck: Int = {
//    try {
//      val formula = buffer[ju.List[ju.List[(
//        "galaxy.player.inactivity_check"
//      )(0).asArray(1).toString
//      FormulaCalc.calc(formula, speedMap).toInt
//    }
//    catch {
//      case e: Exception => throw new RuntimeException(
//        "Error while accessing galaxy.player.inactivity_check[0][1]:\n" +
//          string("galaxy.player.inactivity_check"), e
//      )
//    }
//  }
  lazy val freeSolarSystems =
    positions("galaxy.free_systems.positions")
  lazy val wormholes = positions("galaxy.wormholes.positions")
  lazy val miniBattlegrounds = positions("galaxy.mini_battlegrounds.positions")
  def convoyTime = formulaEval(
    "galaxy.convoy.time", Map("wormholes" -> 2.0)
  ).toInt
  def marketBotResourceCooldownRange = 
    evalRange("market.bot.resources.cooldown")
  def marketBotRandomResourceCooldown = marketBotResourceCooldownRange.random

  // Combat attributes

  lazy val maxFlankIndex = int("combat.flanks.max")
  lazy val combatLineHitChance = double("combat.line_hit_chance")
  lazy val combatMaxDamageChance = double("combat.max_damage_chance")
  lazy val combatRoundTicks = int("combat.round.ticks")
  lazy val wreckageRange = range("combat.wreckage.range")
  
  lazy val criticalMultiplier = double("combat.critical.multiplier")
  lazy val absorptionDivider = double("combat.absorption.divider")

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

  def fairnessPoints(
    economy: Int, science: Int, army: Int, war: Int, victory: Int
  ): Int = FormulaCalc.calc(
    string("combat.battle.fairness_points"),
    Map(
      "economy" -> economy.toDouble, "science" -> science.toDouble,
      "army" -> army.toDouble, "war" -> war.toDouble,
      "victory" -> victory.toDouble
    )
  ).round.toInt
  def fairnessPoints(
    economy: Long, science: Long, army: Long, war: Long, victory: Long
  ): Int = fairnessPoints(
    economy.toInt, science.toInt, army.toInt, war.toInt, victory.toInt
  )
  def fairnessPoints(points: combat.objects.Player.Points): Int =
    fairnessPoints(
      points.economy, points.science, points.army, points.war, points.victory
    )
  def fairnessPoints(player: combat.objects.Player): Int =
    fairnessPoints(player.points)

  lazy val battleVpsMaxWeakness = double("combat.battle.max_weakness")

  // Seq of location kinds where combat gives victory points
  lazy val combatVpZones = seq[Long]("combat.battle.vp_zones").
    map { kind => Location(kind) }
  
  // Function that transforms groundDamage, spaceDamage & fairness_multiplier
  // to victory points.
  type CombatVpsFormula = (Int, Int, Double) => Double
  // Function that transforms victory points to creds.
  type CombatCredsFormula = (Double) => Double

  private def getCombatVpsFormula(kind: String): CombatVpsFormula = {
    val key = "%s.battle.victory_points".format(kind)
    (groundDamage: Int, spaceDamage: Int, fairnessMultiplier: Double) => {
      any(key) match {
        case formula: String => FormulaCalc.calc(formula, Map(
          "damage_dealt_to_ground" -> groundDamage.toDouble,
          "damage_dealt_to_space" -> spaceDamage.toDouble,
          "fairness_multiplier" -> fairnessMultiplier
        ))
        case l: Long => l.toDouble
        case d: Double => d
        case obj: Any =>
          throw new RuntimeException("Unknown object "+obj+" for key "+key)
      }
    }
  }
  
  private def getCombatCredsFormula(kind: String): CombatCredsFormula = {
    val key = "%s.battle.creds".format(kind)
    (victoryPoints: Double) => {
      any(key) match {
        case formula: String => FormulaCalc.calc(formula, Map(
          "victory_points" -> victoryPoints
        ))
        case l: Long => l.toDouble
        case d: Double => d
        case obj: Any =>
          throw new RuntimeException("Unknown object "+obj+" for key "+key)
      }
    }
  }
  
  val regularCombatVpsFormula = getCombatVpsFormula("combat")
  val battlegroundCombatVpsFormula = getCombatVpsFormula("battleground")
  val blankCombatVpsFormula: CombatVpsFormula =
    (_: Int, _: Int, _: Double) => 0.0

  val regularCombatCredsFormula = getCombatCredsFormula("combat")
  val battlegroundCombatCredsFormula = getCombatCredsFormula("battleground")
  val blankCombatCredsFormula: CombatCredsFormula = (_: Double) => 0.0

  // Returns VPs given out for receiving number of damage points.
  def vpsForReceivedDamage(combatant: Combatant, damage: Int): Double = {
    val key = "%s.vps_on_damage".format(resolveCombatantKey(combatant))
    val multiplier = doubleOpt(key) match {
      case None => 0.0
      case Some(d) => d
    }
    multiplier * damage
  }

  def credsForKilling(combatant: Combatant): Int = {
    val key = "%s.creds_for_killing".format(resolveCombatantKey(combatant))
    intOpt(key) match {
      case None => 0
      case Some(i) => i
    }
  }

  // End of combat attributes

  def orbitCount = int("solar_system.orbit.count")

  def orbitLinkWeight(position: Int) = formulaEval(
    "solar_system.links.orbit.weight",
    Map("position" -> position.toDouble))
  def parentLinkWeight(position: Int) = formulaEval(
    "solar_system.links.parent.weight",
    Map("position" -> position.toDouble))
  def planetLinkWeight = double("solar_system.links.planet.weight")
  def wormholeHopMultiplier(ss: pfo.SolarSystem) = 
    if (ss.isGlobalBattleground)
      double("solar_system.battleground.jump.multiplier") 
    else 
      double("solar_system.regular.jump.multiplier")

  def asteroidFirstSpawnCooldown = formulaEval(
    "ss_object.asteroid.wreckage.time.first"
  ).toInt

  def ssObjectSize = range("ss_object.size")

  def planetExpandedMap(name: String) =
    map[String, ju.Map[String, Any]]("planet.expanded_map")(name)

  private[this] val solarSystemMapSets = HashMap.empty[String, SsMapSet]
  def solarSystemMapSet(key: String) = {
    if (solarSystemMapSets.contains(key)) {
      solarSystemMapSets(key)
    }
    else {
      val configKey = "solar_system.map.%s".format(key)
      try {
        val buffer = this.seq[Any](configKey)
        val set = SsMapSet.extract(buffer)
        solarSystemMapSets(key) = set
        set
      }
      catch {
        case e: Exception =>
          throw core.Exceptions.extend("Error while getting " + configKey, e)
      }
    }
  }
  def solarSystemMap(key: String) = solarSystemMapSet(key).random
  
  def homeworldSsConfig = solarSystemMap("home")
  def battlegroundSsConfig = solarSystemMap("battleground")
  def pulsarSsConfig = solarSystemMap("pulsar")
  def freeSsConfig = solarSystemMap("free")

  def startingPopulationMax: Int = int("buildings.mothership.population")

  // Common combatant attributes

  type GunDefinition = sc.Map[String, Any]
  private val gunDefinitionsCache =
    HashMap[String, sc.Seq[GunDefinition]]()
  private def gunDefinitions(name: String) = {
    gunDefinitionsCache ||= (
      name,
      seq[GunDefinition](name)
    )
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

  def unitEntriesFor(building: Building) = {

  }

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


  def getBuildingArea(name: String): Area = area(
    "buildings.%s".format(name.underscore))

  private def buildingRate(kind: String)
                          (building: Building, resource: String) = {
    val name = building.name.underscore
    val level = building.level.toDouble
    val default = 0.0
    val key = "buildings.%s.%s.%s".format(name, resource, kind)

    try {
      formulaEval(key, Map("level" -> level), default)
    }
    catch {
      case e: Exception =>
        System.err.println(
          "Error while evaluating building rate for %s, level %d".
            format(key, building.level)
        )
        throw e
    }
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
    val level = building.level.toDouble
    val default = 0.0

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

  def isBuildingNpc(name: String) = booleanOpt(
    "buildings.%s.npc".format(name.underscore)
  ) match {
    case Some(value) => value
    case None => false
  }

  // End of building attributes
  
  // Troop attributes
  def troopGalaxySsHopTimeRatio = double("units.galaxy_ss_hop_ratio")

  def troopKind(name: String) =
    symbol("units.%s.kind".format(name.underscore)).name
  def troopArmor(name: String) =
    string("units.%s.armor".format(name.underscore))
  def troopArmorModifier(name: String, level: Int): Double =
    formulaEval("units.%s.armor_mod".format(name.underscore),
                Map("level" -> level.toDouble)) / 100
  def troopInitiative(name: String) =
    int("units.%s.initiative".format(name.underscore))
  def troopHp(unit: Troop): Int = troopHp(unit.name)
  def troopHp(name: String) = int("units.%s.hp".format(name.underscore))

  def troopMaxLevel(troop: combat.objects.Troop): Int =
    troopMaxLevel(troop.name)
  def troopMaxLevel(name: String) =
    int("units.%s.max_level".format(name.underscore))

  def troopMetalCost(name: String) =
    cost("units.%s.metal.cost".format(name.underscore))
  def troopEnergyCost(name: String) =
    cost("units.%s.energy.cost".format(name.underscore))
  def troopZetiumCost(name: String) =
    cost("units.%s.zetium.cost".format(name.underscore))
  def troopGunDefinitions(name: String) =
    gunDefinitions("units.%s.guns".format(name.underscore))

  // End of unit attributes
  
  // Planet configuration

  def planetAreaMax = int("planet.area.max")
  
  private[this] val planetMapSetCache = 
    HashMap.empty[String, ss_objects.Planet.MapSet]
  
  def mapSet(key: String): ss_objects.Planet.MapSet = {
    if (! planetMapSetCache.contains(key)) {
      val mapSet = try {
        val fullKey = "planet.map.%s".format(key)
        ss_objects.Planet.MapSet.extract(
          seq[sc.Map[String, Any]](fullKey)
        )
      }
      catch {
        case e: Exception =>
          throw new IllegalArgumentException(
            "Error while extracting mapset %s:\n%s".format(key, e.getMessage),
            e
          )
      }
      planetMapSetCache(key) = mapSet
      mapSet
    }
    else {
      planetMapSetCache(key)
    }
  }

  def planetMap(mapSetName: String) = mapSet(mapSetName).random
  
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

  // End of planet configuration
  
  def raidingDelayRange = evalRange("raiding.delay")
  def raidingDelayRandomDate = raidingDelayRange.random.seconds.fromNow
}