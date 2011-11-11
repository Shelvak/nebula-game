package models.planet.events
{
   import flash.events.Event;
   
   import models.planet.MPlanet;
   import models.planet.MPlanetObject;
   
   
   public class MPlanetEvent extends Event
   {
      /**
       * Dispatched when an object has been added to the planet.
       * 
       * @eventType planetObjectAdd
       */
      public static const OBJECT_ADD:String = "planetObjectAdd";
      
      
      /**
       * Dispatched when an object has been removed from the planet.
       * 
       * @eventType planetObjectRemove
       */
      public static const OBJECT_REMOVE:String = "planetObjectRemove";
      
      
      /**
       * @see models.planet.MPlanet#buildingMove
       * 
       * @eventType buildingMove
       */
      public static const BUILDING_MOVE:String = "buildingMove";
      
      
      /**
       * Dispatched when building has been upgraded.
       * 
       * @eventType planetBuildingUpgraded
       */
      public static const BUILDING_UPGRADED:String = "planetBuildingUpgraded";
      
      
      /**
       * Dispatched when Units||NEW is received.
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
      public function get planet() : MPlanet
      {
         return target as MPlanet;
      }
      
      
      private var _object:MPlanetObject = null;
      /**
       * Used only for <code>OBJECT_ADD</code> and <code>OBJECT_REMOVE</code> events: holds instance
       * of <code>MPlanetObject</code> that has been either added to or removed from the planet this
       * event originated from.
       */
      public function get object() : MPlanetObject
      {
         return _object;
      }
      
      
      /**
       * Constructor. 
       */
      public function MPlanetEvent(type:String, object:MPlanetObject = null)
      {
         super(type, false, false);
         _object = object;
      }
   }
}