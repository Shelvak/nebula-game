package models.location.events
{
   import flash.events.Event;
   
   
   public class LocationEvent extends Event
   {
      /**
       * @see models.location.Location
       * 
       * @eventType isNavigableChange
       */
      public static const IS_NAVIGABLE_CHANGE:String = "isNavigableChange";
      
      
      public function LocationEvent(type:String)
      {
         super(type, false, false);
      }
   }
}