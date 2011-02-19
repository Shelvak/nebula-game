package spacemule.modules.combat.objects.combat

import scala.collection.mutable
import spacemule.modules.combat.objects.Unit

/**
 * Alliance used in combat.
 */
class Alliance(list: AlliancesList, val id: Int)
extends mutable.Map[Int, Flank] {
  def +=(unit: Unit) = {
    if (! contains(unit.flank)) this(unit.flank) = new Flank(this, unit.flank)
    this(unit.flank) += unit
  }
}