/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package spacemule.modules.combat.objects

object Player {
  class Technologies(val damageMod: Double)
}

class Player(val id: Int, val allianceId: Option[Int],
             val technologies: Player.Technologies) {
  override def equals(other: Any) = other match {
    case player: Player => id == player.id
    case _ => false
  }
}
