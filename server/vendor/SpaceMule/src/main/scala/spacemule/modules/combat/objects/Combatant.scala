package spacemule.modules.combat.objects

import spacemule.helpers.Trackable
import spacemule.modules.config.objects.Config

object Combatant {
  object Kind extends Enumeration {
    val Troop = Value(0, "troop")
    val BuildingShooting = Value(1, "shooting building")
    val BuildingPassive = Value(2, "passive building")
  }

  /**
   * Returns one of the Kind integer values.
   */
  def kind(combatant: Combatant) = combatant match {
    case t: Troop => Kind.Troop
    case b: Building => if (b.guns.isEmpty) Kind.BuildingPassive
      else Kind.BuildingShooting
  }
  
  type AsJson = Map[String, Any]
}

/**
 * Entity that can participate in combat.
 */
trait Combatant extends Trackable {
  /**
   * ID of this combatant in database.
   */
  val id: Long
  /**
   * String name for the combatant type.
   */
  val name: String
  /**
   * Name that is used in Ruby side.
   */
  val rubyName: String
  /**
   * What kind of participant it is?
   */
  val kind: Kind.Value

  def isGround = kind == Kind.Ground
  def isSpace = kind == Kind.Space

  /**
   * Type of armor.
   */
  val armor: Armor.Type
  /**
   * Additional armor modifier from level.
   */
  val armorModifier: Double
  /**
   * Guns for this participant.
   */
  val guns = Gun.gunsFor(this)
  /**
   * Initiative of this combatant.
   */
  val initiative: Int
  /**
   * Flank index.
   */
  val flank: Int
  /**
   * To whom this combatant belongs?
   */
  val player: Option[Player]
  /**
   * Level of this combatant.
   */
  var level: Int
  /**
   * Does this combatant still gain XP?
   */
  def gainsXp: Boolean

  /**
   * Metal cost.
   */
  def metalCost: Int
  /**
   * Energy cost.
   */
  def energyCost: Int
  /**
   * Zetium cost.
   */
  def zetiumCost: Int
  /**
   * Stance of this combatant.
   */
  val stance: Stance.Type
  /**
   * Number of hit points.
   */
  var hp: Int
  /**
   * Maximum number of hit points.
   */
  val hitPoints: Int
  /**
   * Wrap it into methods to allow for overriding in child classes.
   */
  protected var _xp: Int
  /**
   * XP accumulated per combat.
   */
  def xp = _xp
  def xp_=(value: Int) { _xp = value }

  def isAlive = hp > 0
  def isDead = hp == 0

  /**
   * Chance for critical hit.
   */
  def criticalChance = player match {
    case Some(p) => p.technologies.criticalChanceFor(this)
    case None => 0.0
  }

  /**
   * Chance for damage absorption.
   */
  def absorptionChance = player match {
    case Some(p) => p.technologies.absorptionChanceFor(this)
    case None => 0.0
  }
  
  /**
   * Damage modifier gained from technologies.
   */
  def technologiesDamageMod = player match {
    case Some(p) => p.technologies.damageModFor(this)
    case None => 0.0
  }

  /**
   * Armor modifier gained from technologies.
   */
  def technologiesArmorMod = player match {
    case Some(p) => p.technologies.armorModFor(this)
    case None => 0.0
  }

  /**
   * Returns value (0..1] for combat mods. If player is overpopulated this
   * value will be < 1, else it will be 1.0.
   */
  def overpopulationMod = player match {
    case Some(p) => p.overpopulation
    case None => Player.DefaultOverpopulation
  }

  /**
   * Damage modifier gained from stance.
   */
  def stanceDamageMod = Config.stanceDamageMod(stance)
  
  /**
   * Armor modifier gained from stance.
   */
  def stanceArmorMod = Config.stanceArmorMod(stance)

  /**
   * Returns JSON representation of combatant.
   *
   * Map(
   *   "id" -> Int,
   *   "player_id" -> Int | null,
   *   "type" -> String,
   *   "kind" -> Int,
   *   "hp" -> Int,
   *   "level" -> Int,
   *   "stance" -> Int
   * )
   */
  def asJson: Combatant.AsJson = Map(
    "id" -> id,
    "player_id" -> (player match {
      case Some(player) => player.id
      case None => null
    }),
    "type" -> name,
    "kind" -> Combatant.kind(this).id,
    "hp" -> hp,
    "level" -> level,
    "stance" -> stance.id
  )

  protected def trackedAttributes = Map("level" -> level, "hp" -> hp,
                                        "xp" -> xp)

  /**
   * Victory points given to attacker for damage dealt to this combatant.
   */
  def vpsForReceivedDamage(damage: Int) =
    Config.vpsForReceivedDamage(this, damage)

  /**
   * Creds given to killed for killing this combatant.
   */
  def credsForKilling = Config.credsForKilling(this)
}
