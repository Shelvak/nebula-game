package components.map.controllers.events
{
   import flash.events.Event;
   
   public class MapViewportEvent extends Event
   {
      /**
       * Dispatched when user clicks on an empty space of a viewport.
       * 
       * @eventType clickEmptySpace
       */
      public static const CLICK_EMPTY_SPACE:String = "clickEmptySpace";
      
      
      /**
       * Constructor.
       */
      public function MapViewportEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
      {
         super(type, bubbles, cancelable);
      }
   }
}