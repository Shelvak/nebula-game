package components.market.events
{
   import flash.events.Event;
   
   public class MarketEvent extends Event
   {
      public static const SELECTED_RESOURCE_CHANGE: String = 'selectedResourceChange';
      public static const OFFER_OWNER_CHANGE: String = 'offerOwnerChange';
      public function MarketEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
      {
         super(type, bubbles, cancelable);
      }
   }
}