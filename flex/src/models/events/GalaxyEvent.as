package models.events
{
   import flash.events.Event;
   
   import models.galaxy.Galaxy;
   
   
   public class GalaxyEvent extends Event
   {
      public static const RESIZE:String = "galaxyResize";
      
      
      /**
       * Typed alias for <code>target</code>.
       */
      public function get galaxy() : Galaxy
      {
         return Galaxy(target); 
      }
      
      
      public function GalaxyEvent(type:String)
      {
         super(type);
      }
   }
}