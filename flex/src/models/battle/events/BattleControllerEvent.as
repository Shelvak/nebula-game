package models.battle.events
{
   import flash.events.Event;
   
   public class BattleControllerEvent extends Event
   {
      public static const TOGGLE_PAUSE: String = 'togglePauseBattle';
      
      public static const CHANGE_SPEED: String = 'changeBattleSpeed';
      
      public var increase: Boolean;
      
      public function BattleControllerEvent(type:String, _increase: Boolean = false)
      {
         if (type == CHANGE_SPEED)
         {
            increase = _increase;
         }
         super(type);
      }
   }
}