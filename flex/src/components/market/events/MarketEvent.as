package components.market.events
{
   import flash.events.Event;
   
   public class MarketEvent extends Event
   {
      public static const SELECTED_RESOURCE_CHANGE: String = 'selectedResourceChange';
      public static const OFFER_OWNER_CHANGE: String = 'offerOwnerChange';
      public static const OFFER_RATE_CHANGE: String = 'offerRateChange';
      public static const AVG_RATE_CHANGE: String = 'avgRateChange';
      public function MarketEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
      {
         super(type, bubbles, cancelable);
      }
   }
}