package models.player
{
   import models.player.events.PlayerEvent;
   
   import mx.collections.ArrayCollection;
   
   import utils.datastructures.Collections;
   
   [Bindable]
   public class Player extends PlayerMinimal
   {
      [Optional]
      /**
       * Indicates if the player has logged in for the first time. Makes sense only for the player instance
       * in <code>ModelLocator</code>.
       * 
       * <p><i><b>Metadata</b>:<br/>
       * [Optional]</p>
       * 
       * @default false
       */
      public var firstTime:Boolean = false;
      
      
      [SkipProperty]
      /**
       * Makes sense only for the player instance in <code>ModelLocator</code>.
       * 
       * <p><i><b>Metadata</b>:<br/>
       * [SkipProperty]</p>
       * 
       * @default 0
       */
      public var galaxyId:int = 0;
      
      
      [SkipProperty]
      /**
       * Makes sense only for the player instance in <code>ModelLocator</code>.
       * 
       * <p><i><b>Metadata</b>:<br/>
       * [SkipProperty]</p>
       * 
       * @default null
       */
      public var loggedIn:Boolean = false;
      
      
      [SkipProperty]
      /**
       * A list of all planets this player owns. Elements of this collection are instances of <b>SSObject</b>.
       * 
       * <p><i><b>Metadata</b>:<br/>
       * [SkipProperty]</p>
       */
      public var planets:ArrayCollection = new ArrayCollection();
      
      
      private var _scientists:int = 0;
      [Bindable(event='scientistsChanged')]
      [Optional]
      public function set scientists(value: int): void
      {
         if (_scientists != value)
         {
            _scientists = value;
            dispatchScientistsChangeEvent();
            dispatchPropertyUpdateEvent("scientists", value);
         }
      }
      public function get scientists(): int
      {
         return _scientists
      }
      
      
      [Optional]
      public var scientistsTotal:int = 0;
      
      
      [Optional]
      public var xp:int = 0;
      
      
      [Optional]
      public var allianceId:int = 0;
      
      
      [Optional]
      public var points:int = 0;
      
      
      public function reset() : void
      {
         Collections.cleanListOfICleanables(planets);
         loggedIn = false;
         scientists = 0;
         scientistsTotal = 0;
         xp = 0;
         allianceId = 0;
         points = 0;
      }
      
      
      public override function toString():String
      {
         return '[Player id: ' + id + ', name: ' + name + ', galaxyId: ' + galaxyId + ', scientists: ' + 
            scientists + ', scientistsTotal: ' + scientistsTotal + ', allianceId: ' + allianceId + ', xp: ' + 
            xp + ', points: ' + points + ', logged: ' + loggedIn + 
            ', planetsCount: ' + planets.length + ']'; 
      }
      
      
      private function dispatchScientistsChangeEvent(): void
      {
         if (hasEventListener(PlayerEvent.SCIENTISTS_CHANGE))
         {
            dispatchEvent(new PlayerEvent(PlayerEvent.SCIENTISTS_CHANGE));
         }
      }
   }
}