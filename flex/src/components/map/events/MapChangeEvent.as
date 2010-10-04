package components.map.events
{
   import components.map.CMap;
   
   import flash.events.Event;
   
   
   public class MapChangeEvent extends Event
   {
      /**
       * The <code>MapChangeEvent.MAP_DATA_CHANGE</code> constant defines the
       * value of the type property of the event object for a MapChange
       * event. <code>oldMap</code> property is not used for this event.
       * 
       * @eventType mapDataChange
       */
      public static const MAP_DATA_CHANGE:String = "mapDataChange";
      
      
      /**
       * Constructor. 
       */
      public function MapChangeEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false)
      {
         super(type, bubbles, cancelable);
      }
   }
}