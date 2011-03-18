package spacemule.modules.combat.objects

import spacemule.modules.config.objects.Config

/**
 * Entity that can participate in combat.
 */
trait Combatant {
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
   * Additional armor modifier.
   */
  val armorModifier: Double
  /**
   * Guns for this participant.
   */
  val guns: Seq[Gun]
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
   * Stance of this combatant.
   */
  val stance: Stance.Type
  /**
   * Number of hit points.
   */
  var hp: Int
  /**
   * Wrap it into methods to allow for overriding in child classes.
   */
  protected var _xp: Int
  /**
   * XP accumulated per combat.
   */
  def xp = _xp
  def xp_=(value: Int) = _xp = value

  def isAlive = hp > 0
  def isDead = hp == 0

  def technologiesDamageMod = player match {
    case Some(player) => player.technologies.damageMod
    case None => 0
  }

  def stanceDamageMod = Config.stanceDamageMod(stance)
  def stanceArmorMod = Config.stanceArmorMod(stance)
}
