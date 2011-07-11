package components.market.events
{
   import flash.events.Event;
   
   public class MarketEvent extends Event
   {
      public static const SELECTED_CHANGE: String = 'selectedResourceChange';
      public function MarketEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
      {
         super(type, bubbles, cancelable);
      }
   }
}