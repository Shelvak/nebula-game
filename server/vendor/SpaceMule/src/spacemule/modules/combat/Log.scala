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
   * 
   * * 0 - troop
   * * 1 - building (shooting)
   * * 2 - building (passive)
   */
  def id(combatant: Combatant) = combatant match {
    case t: Troop => List(t.id, 0)
    case b: Building => List(b.id, if (b.guns.isEmpty) 2 else 1)
  }

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
     * Represents sequence of shots for one combatant.
     */
    class Fire(source: Combatant) {
      private val hits = ListBuffer[Log.Tick.Fire.Hit]()

      def hit(gun: Gun, target: Combatant, damage: Int) =
        hits += Log.Tick.Fire.Hit(gun, target, damage)

      def isEmpty = hits.isEmpty

      def asJson = List("fire", Log.id(source), hits.map { _.asJson })
    }
  }

  /**
   * Represents one tick where every unit fires.
   */
  class Tick {
    private val fires = ListBuffer[Log.Tick.Fire]()

    def +=(fire: Log.Tick.Fire) = fires += fire

    def isEmpty = fires.isEmpty

    def asJson = List("tick", "start") ++ fires.map { _.asJson }
  }
}

class Log {
  private val ticks = ListBuffer[Log.Tick]()

  def +=(tick: Log.Tick) = ticks += tick

  def isEmpty = ticks.isEmpty

  def asJson = ticks.map { _.asJson }

  def toJson = Json.toJson(asJson)
}