package models.galaxy.events
{
   import flash.events.Event;
   
   public final class MEntireGalaxyEvent extends Event
   {
      public static const RERENDER: String = "RERENDER";
      
      public function MEntireGalaxyEvent(type: String) {
         super(type, false, false);
      }
   }
}