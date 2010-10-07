package models.events
{
   import flash.events.Event;
   
   import models.galaxy.Galaxy;
   import models.solarsystem.SolarSystem;
   
   public class GalaxyEvent extends Event
   {
      public static const SOLAR_SYSTEM_ADD:String = "solarSystemAdd";
      public static const SOLAR_SYSTEM_REMOVE:String = "solarSystemRemove";
      public static const RESIZE:String = "galaxyResize";
      
      
      /**
       * Makes sense only for <code>SOLAR_SYSTEM_ADD</code> and <code>SOLAR_SYSTEM_REMOVE</code>
       * events.
       */
      public var solarSystem:SolarSystem;
      
      
      /**
       * Typed alias for <code>target</code>.
       */
      public function get galaxy() : Galaxy
      {
         return Galaxy(target); 
      }
      
      
      public function GalaxyEvent(type:String, solarSystem:SolarSystem = null)
      {
         super(type);
         this.solarSystem = solarSystem;
      }
   }
}