package models.solarsystem.events
{
   import flash.events.Event;

   public class SolarSystemEvent extends Event
   {
      /**
       * @see models.solarSystem.SolarSystem
       * 
       * @eventType shieldOwnerChange
       */      
      public static const SHIELD_OWNER_CHANGE:String = "shieldOwnerChange";
      
      
      /**
       * @see models.solarSystem.SolarSystem
       * 
       * @eventType shieldEndsAtChange
       */
      public static const SHIELD_ENDS_AT_CHANGE:String = "shieldEndsAtChange";
      
      
      /**
       * @see models.solarSystem.SolarSystem
       * 
       * @eventType shieldEndsInChange
       */
      public static const SHIELD_ENDS_IN_CHANGE:String = "shieldEndsInChange";
      
      
      public function SolarSystemEvent(type:String)
      {
         super(type);
      }
   }
}