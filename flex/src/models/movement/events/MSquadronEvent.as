package models.movement.events
{
   import flash.events.Event;
   
   import models.location.LocationMinimal;
   import models.movement.MSquadron;
   
   
   public class MSquadronEvent extends Event
   {
      /**
       * Dispatched when a squadron moves to new location.
       * 
       * @eventType move
       */
      public static const MOVE:String = "move";

      /**
       * Dispatched when a selected squadron killing reward multiplier changes.
       *
       * @eventType multiplierChange
       */
      public static const MULTIPLIER_CHANGE:String = "multiplierChange";
      
      
      /**
       * Dispatched when <code>showRoute</code> property changes.
       * 
       * @event type showRouteChange
       */
      public static const SHOW_ROUTE_CHANGE:String = "showRouteChange";
      
      
      /**
       * Constructor.
       */
      public function MSquadronEvent(type:String)
      {
         super(type, false, false);
      }
      
      
      /**
       * Typed alias for <code>target</code>.
       */
      public function get squadron() : MSquadron
      {
         return MSquadron(target);
      }
      
      
      /**
       * A sector this squadron has moved from. Makes sense only for <code>MOVE</code> event.
       */
      public var moveFrom:LocationMinimal = null;
      
      
      /**
       * A sector this squadron has moved to. Makes sense only for <code>MOVE</code> event.
       */
      public var moveTo:LocationMinimal = null;
   }
}