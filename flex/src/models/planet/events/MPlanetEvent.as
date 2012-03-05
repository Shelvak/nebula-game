package models.planet.events
{
   import flash.events.Event;

   import models.planet.MPlanet;
   import models.planet.MPlanetObject;


   public class MPlanetEvent extends Event
   {
      public static const OBJECT_ADD:String = "planetObjectAdd";
      public static const OBJECT_REMOVE:String = "planetObjectRemove";
      
      public static const BUILDING_MOVE:String = "buildingMove";
      public static const BUILDING_UPGRADED:String = "planetBuildingUpgraded";

      /**
       * @see MPlanet
       */
      public static const UICMD_SELECT_OBJECT:String = "uicmdSelectObject";
      
      /**
       * Dispatched when Units|NEW is received.
       *
       * @eventType unitUpgradeStarted
       */
      public static const UNIT_UPGRADE_STARTED:String = "unitUpgradeStarted";
      
      /**
       * Dispatched when Unit has finished it's upgrade progress.
       * 
       * @eventType unitRefresh
       */      
      public static const UNIT_REFRESH_NEEDED:String = "unitRefresh";

      /**
       * Typed alias for <code>target</code> property.
       */
      public function get planet(): MPlanet {
         return target as MPlanet;
      }
      
      
      private var _object:MPlanetObject = null;
      /**
       * When used with <code>OBJECT_ADD</code>, <code>OBJECT_REMOVE</code>
       * events: holds instance of <code>MPlanetObject</code> that has been
       * either added to or removed from the planet this event originated from.
       *
       * When used with <code>UICMD_SELECT_BUILDING</code> holds building to
       * be selected by the map component.
       */
      public function get object(): MPlanetObject {
         return _object;
      }

      public function MPlanetEvent(type: String, object: MPlanetObject = null) {
         super(type, false, false);
         _object = object;
      }
   }
}