/**
 * Created by IntelliJ IDEA.
 * User: Jho
 * Date: 1/13/12
 * Time: 4:24 PM
 * To change this template use File | Settings | File Templates.
 */
package models.movement {
   import flash.events.EventDispatcher;

   import models.movement.events.MSquadronEvent;

   import utils.SingletonFactory;

   public class MSquadKillReward extends EventDispatcher {
      public static function getInstance(): MSquadKillReward
      {
         return SingletonFactory.getSingletonInstance(MSquadKillReward);
      }
      
      private var _multiplier: Number;
      
      public function set multiplier(value: Number): void
      {
         _multiplier = value;
         dispatchMultiplierChangeEvent();
      }

      public function get multiplier(): Number
      {
         return _multiplier;
      }

      private function dispatchMultiplierChangeEvent(): void
      {
         if (hasEventListener(MSquadronEvent.MULTIPLIER_CHANGE))
         {
            dispatchEvent(new MSquadronEvent(MSquadronEvent.MULTIPLIER_CHANGE));
         }
      }
   }
}
