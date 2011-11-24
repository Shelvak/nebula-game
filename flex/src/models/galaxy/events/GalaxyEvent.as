package models.galaxy.events
{
   import flash.events.Event;

   import models.galaxy.Galaxy;


   public class GalaxyEvent extends Event
   {
      /**
       * @eventType galaxyResize
       *
       * @see GalaxyEvent#galaxyResize
       */
      public static const RESIZE: String = "galaxyResize";

      /**
       * @eventType hasWormholesChange
       *
       * @see GalaxyEvent#hasWormholesChange
       */
      public static const HAS_WORMHOLES_CHANGE: String = "hasWormholesChange";

      /**
       * Dispatched when <code>Galaxy.apocalypseStartEvent</code> property
       * changes.
       */
      public static const APOCALYPSE_START_EVENT_CHANGE: String =
                             "apocalypseStartEventChange";

      /**
       * Typed alias for <code>target</code>.
       */
      public function get galaxy(): Galaxy {
         return Galaxy(target);
      }

      public function GalaxyEvent(type: String) {
         super(type);
      }
   }
}