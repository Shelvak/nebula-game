/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package spacemule.modules.combat.objects

import spacemule.modules.config.objects.Config

class Unit(val id: Int, name: String, val player: Option[Player],
           val flank: Int,
           val units: Option[Set[Unit]])
extends CombatParticipant with Ordered[Unit] {
  def volume = Config.unitVolume(name)

  def compare(unit: Unit): Int = {
    if (flank != unit.flank) return flank.compare(unit.flank)
    volume.compare(unit.volume)
  }
}
