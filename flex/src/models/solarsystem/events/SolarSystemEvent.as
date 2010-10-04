package models.solarsystem.events
{
   import flash.events.Event;

   public class SolarSystemEvent extends Event
   {
      public static const ID_CHANGED: String = "solarSystemIdChanged";
      
      public function SolarSystemEvent(type:String)
      {
         super(type)
      }
   }
}