package controllers.units.events
{
   import flash.events.Event;
   
   import mx.collections.IList;
   
   public class OrdersControllerEvent extends Event
   {
      public static const ISSUING_ORDERS_CHANGE:String = "issuingOrdersChange";
      public static const LOCATION_SOURCE_CHANGE:String = "locationSourceChange";
      
      
      /**
       * Constructor.
       */
      public function OrdersControllerEvent(type:String)
      {
         super(type, false, false);
      }
   }
}