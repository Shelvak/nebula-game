package models.movement.events
{
   import flash.events.Event;
   
   import models.location.LocationMinimal;
   import models.movement.MHop;
   import models.movement.MSquadron;
   
   public class MRouteEvent extends MSquadronEvent
   {
      /**
       * Dispatched when
       * <ul>
       *    <li>a hop has been added to the route of a squadron
       *        (<code>kind = MRouteEventChangeKind.HOP_ADD</code>)</li>
       *    <li>a hop has been removed from the route of a squadron
       *        (<code>kind = MRouteEventChangeKind.HOP_REMOVE</code>)</li>
       * </ul>
       * 
       * @eventType routeChange
       */
      public static const CHANGE:String = "routeChange";
      
      
      /**
       * Constructor.
       */
      public function MRouteEvent(type:String)
      {
         super(type);
         this.kind = kind;
      }
      
      
      /**
       * Kind of <code>CHANGE</code> event. Can be one of constants in
       * <code>RouteEventChangeKind</code> class.
       */
      public var kind:uint;
      
      
      /**
       * A hop which has been:
       * <ul>
       *    <li>added to a route if <code>kind == MRouteEventChangeKind.HOP_ADD</code></li>
       *    <li>removed from a route if <code>kind == MRouteEventChangeKind.HOP_REMOVE</code></li>
       * </ul>
       */
      public var hop:MHop;
   }
}