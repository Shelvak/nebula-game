package models.location
{
   import flash.events.Event;

   public class LocationEvent extends Event
   {
      /**
       * Dispatched when <code>Location.name</code> and <code>Location.planetName</code> properties
       * have changed.
       */
      public static const NAME_CHANGE:String = "nameChange";
      
      
      public function LocationEvent(type:String) {
         super(type);
      }
   }
}