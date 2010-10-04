package models.movement.events
{
   public class MRouteEventChangeKind
   {
      /**
       * Indicates that <code>RouteEvent.CHANGE</code> event has been dispatched after a new hop
       * has been added to a route.
       */
      public static const HOP_ADD:uint = 0;
      
      /**
       * Indicates that <code>RouteEvent.CHANGE</code> event has been dispatched after a hop
       * has been removed from a route.
       */
      public static const HOP_REMOVE:uint = 1;
   }
}