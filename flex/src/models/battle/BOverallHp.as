package models.battle
{
   import flash.events.Event;
   import flash.events.EventDispatcher;

   [Bindable]
   public class BOverallHp extends EventDispatcher
   {
      public function BOverallHp(status: int)
      {
         super();
         playerStatus = status;
      }
      
      public var spaceCurrent: int = 0;
      public var spaceMax: int = 0;
      public var groundCurrent: int = 0;
      public var groundMax: int = 0;
      public var playerStatus: int = 0;
   }
}