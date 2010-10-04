package models.planet.events
{
   import flash.events.Event;
   
   import models.planet.Planet;
   import models.planet.PlanetObject;
   
   
   
   /**
    * The PlanetEvent class represents the event object passed to the event
    * listener for planet events.  
    */
   public class PlanetEvent extends Event
   {
      /**
       * The <code>PlanetEvent.OWNER_CHANGE</code> constant defines the value
       * of the type property of the event object for a PlanetEvent.
       * 
       * @eventType planetOwnerChange
       */
      public static const OWNER_CHANGE:String = "planetOwnerChange";
      
      /**
       * Dispatched when an object has been added to the planet.
       * 
       * @eventType planetObjectAdd
       */
      public static const OBJECT_ADD:String = "planetObjectAdd";
      
      
      /**
       * Dispatched when building has been upgraded.
       * 
       * @eventType planetBuildingUpgraded
       */
      public static const BUILDING_UPGRADED:String = "planetBuildingUpgraded";
      
      /**
       * Dispatched when an object has been removed from the planet.
       * 
       * @eventType planetObjectRemove
       */
      public static const OBJECT_REMOVE:String = "planetObjectRemove";
      
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
      public function get planet() : Planet
      {
         return target as Planet;
      }
      
      
      private var _object:PlanetObject = null;
      /**
       * Used only for <code>OBJECT_ADD</code> and <code>OBJECT_REMOVE</code>
       * events: holds instance of <code>PlanetObject</code> that has been either
       * added to or removed from the planet this event originated from.
       */
      public function get object() : PlanetObject
      {
         return _object;
      }
      
      
      /**
       * Constructor. 
       */
      public function PlanetEvent(type:String, object:PlanetObject = null)
      {
         super (type, false, false);
         _object = object;
      }
   }
}