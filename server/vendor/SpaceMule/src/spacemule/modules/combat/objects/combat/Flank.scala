package spacemule.modules.combat.objects.combat

import scala.collection.mutable.HashSet
import spacemule.modules.combat.objects.Unit
import spacemule.modules.combat.objects.Kind

/**
 * Flank used in combat.
 */
class Flank(alliance: Alliance, number: Int) {
  def this(alliance: Alliance, number: Int, units: Seq[Unit]) = {
    this(alliance, number)
    units.foreach { unit => this += unit }
  }

  private val units = Map(
    Kind.Ground -> new HashSet[Unit](),
    Kind.Space -> new HashSet[Unit]()
  )

  private var _size = 0
  def size = _size

  def +=(unit: Unit) = {
    units(unit.kind).add(unit)
    _size += 1
  }

  def -=(unit: Unit) = {
    units(unit.kind).remove(unit)
    _size -= 1
    if (_size == 0) alliance.remove(number)
  }
}
