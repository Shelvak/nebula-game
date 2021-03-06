package spacemule.modules.combat.post_combat

import scala.collection.mutable.ListBuffer
import spacemule.modules.combat.objects.Combatant
import spacemule.modules.combat.objects.Gun

object Log {
  /**
   * Returns ID representation for log of combatant.
   */
  def id(combatant: Combatant): (Long, Int) =
    (combatant.id, Combatant.kind(combatant).id)

  object Tick {
    object Fire {
      /**
       * Represents one hit from one gun to one target when combatant is
       * firring.
       */
      case class Hit(gun: Gun, target: Combatant, damage: Int) {
        /**
         * hit = [gun_index, target_id, damage]
         *  gun_index - index of the gun shooting (from 0)
         *  target_id - same as unit_id
         *  damage - how much damage has target received
         */
        def toData = (gun.index, Log.id(target), damage)
      }
    }

    /**
     * Represents sequence of shots for one combatant.
     */
    class Fire(source: Combatant) {
      private val hits = ListBuffer[Log.Tick.Fire.Hit]()

      def hit(gun: Gun, target: Combatant, damage: Int) =
        hits += Log.Tick.Fire.Hit(gun, target, damage)

      def isEmpty = hits.isEmpty

      def toData = (Log.id(source), hits.map { _.toData })
    }
  }

  /**
   * Represents one tick where every unit fires.
   */
  class Tick {
    private val fires = ListBuffer[Log.Tick.Fire]()

    def +=(fire: Log.Tick.Fire) = fires += fire

    def isEmpty = fires.isEmpty

    def toData = fires.map { _.toData }
  }
}

class Log(unloadedUnitIds: collection.Map[Long, Seq[Long]]) {
  private val ticks = ListBuffer[Log.Tick]()

  def +=(tick: Log.Tick) = ticks += tick

  def isEmpty = ticks.isEmpty && unloadedUnitIds.isEmpty

  /**
   * Returns JSON representation.
   *
   * Map(
   *   "unloaded" -> Map[transporterId: Int, unitIds: Seq[Int]],
   *   "ticks" -> Seq[Log.Tick]
   * )
   */
  def toMap: Map[String, Any] = Map(
    "unloaded" -> unloadedUnitIds,
    "ticks" -> ticks.map { _.toData }
  )
}