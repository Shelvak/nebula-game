/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package spacemule.modules.combat

import scala.collection.mutable.ListBuffer
import spacemule.modules.combat.objects.Building
import spacemule.modules.combat.objects.Combatant
import spacemule.modules.combat.objects.Gun
import spacemule.modules.combat.objects.Troop
import spacemule.helpers.json.Json

object Log {
  /**
   * Returns ID representation for log of combatant.
   */
  def id(combatant: Combatant) = List(combatant.id, Combatant.kind(combatant))

  object Tick {
    object Fire {
      /**
       * Represents one hit from one gun to one target when combatant is
       * fireing.
       */
      case class Hit(gun: Gun, target: Combatant, damage: Int) {
        /**
         * hit = [gun_index, target_id, damage]
         *  gun_index - index of the gun shooting (from 0)
         *  target_id - same as unit_id
         *  damage - how much damage has target received
         */
        def asJson = List(gun.index, Log.id(target), damage)
      }
    }

    /**
     * Base trait for log items.
     */
    trait Item {
      def asJson: List[Any]
    }

    /**
     * Represents sequence of shots for one combatant.
     */
    class Fire(source: Combatant) extends Item {
      private val hits = ListBuffer[Log.Tick.Fire.Hit]()

      def hit(gun: Gun, target: Combatant, damage: Int) =
        hits += Log.Tick.Fire.Hit(gun, target, damage)

      def isEmpty = hits.isEmpty

      def asJson = List("fire", Log.id(source), hits.map { _.asJson })
    }
    
    /**
     * Represents unit unloading.
     */
    class Appear(transporterId: Int, target: Troop) extends Item {
      def asJson = List("appear", transporterId, target.asJson, target.flank)
    }
  }

  /**
   * Represents one tick where every unit fires.
   */
  class Tick {
    private val items = ListBuffer[Log.Tick.Item]()

    def +=(fire: Log.Tick.Item) = items += fire

    def isEmpty = items.isEmpty

    def asJson = List("tick", "start") ++ items.map { _.asJson }
  }
}

class Log {
  private val ticks = ListBuffer[Log.Tick]()

  def +=(tick: Log.Tick) = ticks += tick

  def isEmpty = ticks.isEmpty

  def asJson = ticks.map { _.asJson }

  def toJson = Json.toJson(asJson)
}