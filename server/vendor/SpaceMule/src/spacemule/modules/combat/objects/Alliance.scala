/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package spacemule.modules.combat.objects

import scala.collection.mutable
import scala.collection.immutable._
import spacemule.helpers.Converters._
import spacemule.helpers.{StdErrLog => L}

class Alliance(id: Int, 
               val players: Set[Option[Player]],
               combatants: Set[Combatant]) {
  private val (groundFlanks, spaceFlanks) = {
    val (ground, space) = combatants.partition { _.isGround }
    (new Flanks("ground", ground), new Flanks("space", space))
  }

  /**
   * Returns active combatants from space and ground unit lists by their
   * initiative.
   */
  def take() = Set(groundFlanks.take, spaceFlanks.take).flatten

  /**
   * Returns combatant that you can shoot or None if no such combatant exists.
   */
  def target(gun: Gun): Option[Combatant] = flanks(gun.kind).target(gun.damage)

  /**
   * Returns flanks for given kind.
   */
  private def flanks(kind: Kind.Value) = kind match {
    case Kind.Ground => groundFlanks
    case Kind.Space => spaceFlanks
  }

  /**
   * Kills target and removes it from alive flanks.
   */
  def kill(target: Combatant) = flanks(target.kind).kill(target)

  /**
   * Reset ground and space initiative lists.
   */
  def reset() =
    L.debug("Resetting alliance (id: %d) initiative lists".format(id), () => {
      groundFlanks.reset
      spaceFlanks.reset
    })

  /**
   * Is this alliance still alive?
   */
  def isAlive = groundFlanks.hasAlive || spaceFlanks.hasAlive

  /**
   * Is this player still alive?
   */
  def isAlive(player: Option[Player]) =
    groundFlanks.isAlive(player) || spaceFlanks.isAlive(player)
}
