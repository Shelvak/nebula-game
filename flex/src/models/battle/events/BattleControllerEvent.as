package models.battle.events
{
   import flash.events.Event;
   
   public class BattleControllerEvent extends Event
   {
      public static const TOGGLE_PAUSE: String = 'togglePauseBattle';
      
      public static const CHANGE_SPEED: String = 'changeBattleSpeed';
      
      public var speed: Number;
      
      public function BattleControllerEvent(type:String, _speed: Number = 0)
      {
         if (type == CHANGE_SPEED)
         {
            speed = _speed;
         }
         super(type);
      }
   }
}