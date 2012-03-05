package models.galaxy.events
{
   import flash.events.Event;

   import models.galaxy.Galaxy;
   import models.location.LocationMinimal;


   public class GalaxyEvent extends Event
   {
      public static const GALAXY_READY: String = "galaxyReady";
      public static const HAS_WORMHOLES_CHANGE: String = "hasWormholesChange";
      public static const APOCALYPSE_START_EVENT_CHANGE: String =
                             "apocalypseStartEventChange";
      public static const NEW_VISIBLE_LOCATION: String = "newVisibleLocation";

      /**
       * Typed alias for <code>target</code>.
       */
      public function get galaxy(): Galaxy {
         return Galaxy(target);
      }

      private var _location: LocationMinimal;
      /**
       * A location that became visible in the galaxy. Relevant only for
       * <code>NEW_VISIBLE_LOCATION</code> event.
       */
      public function get location(): LocationMinimal {
         return _location;
      }

      public function GalaxyEvent(type: String, location:LocationMinimal = null) {
         super(type);
         _location = location;
      }
   }
}