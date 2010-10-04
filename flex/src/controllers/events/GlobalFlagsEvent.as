package controllers.events
{
   import flash.events.Event;
   
   public class GlobalFlagsEvent extends Event
   {
      /**
       * Dispatched when <code>issuingOrders</code> property of <code>GlobalFlags</code>
       * instance changes.
       * 
       * @eventType issuingOrdersChange
       */
      public static const ISSUING_ORDERS_CHANGE:String = "issuingOrdersChange";
      
      
      /**
       * Constructor.
       */
      public function GlobalFlagsEvent(type:String)
      {
         super(type, false, false);
      }
   }
}