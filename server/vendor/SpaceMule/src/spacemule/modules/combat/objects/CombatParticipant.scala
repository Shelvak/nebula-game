package spacemule.modules.combat.objects



/**
 * Available participant kinds.
 */
object Kind extends Enumeration {
  val Ground = Value("ground")
  val Space = Value("space")
}

/**
 * Available gun reach kinds.
 */
object Reach extends Enumeration {
  val Ground = Value("ground")
  val Space = Value("space")
  val Both = Value("both")
}

/**
 * Available damage types.
 */
object Damage extends Enumeration {
  type Type = Value

  val Piercing = Value("piercing")
  val Normal = Value("normal")
  val Explosive = Value("explosive")
  val Siege = Value("siege")
}

/**
 * Available participant armor types.
 */
object Armor extends Enumeration {
  type Type = Value

  val Light = Value("light")
  val Normal = Value("normal")
  val Heavy = Value("heavy")
  val Fortified = Value("fortified")
}

class Gun {
  val damage: Damage.Type
}

/**
 * Entity that can participate in combat.
 */
trait CombatParticipant {
  /**
   * What kind of participant it is?
   */
  val kind: Kind.Value
  /**
   * Type of armor.
   */
  val armor: Armor.Type
  /**
   * Additional armor modifier.
   */
  val armorModifier: Number
  /**
   * Guns for this participant.
   */
  val guns: Seq[Gun]

  def isGround = kind == Kind.Ground
  def isSpace = kind == Kind.Space
}
