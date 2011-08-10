package components.foliage.events
{
   import flash.events.Event;
   
   public class CFoliageSidebarMEvent extends Event
   {
      /**
       * Dispatched by foliage panel model when its state has changed.
       * @eventType sateChange
       */
      public static const STATE_CHANGE:String = "stateChange";
      
      
      public function CFoliageSidebarMEvent(type:String) {
         super(type);
      }
   }
}