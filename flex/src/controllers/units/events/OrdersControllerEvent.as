package controllers.units.events
{
   import flash.events.Event;
   
   public class OrdersControllerEvent extends Event
   {
      /**
       * Dispatched when <code>OrdersController.issuingOrders</code> property changes.
       * 
       * @eventType issuingOrdersChange
       */
      public static const ISSUING_ORDERS_CHANGE:String = "issuingOrdersChange";
      
      
      /**
       * Dispatched when <code>locationSource</code> property changes.
       * 
       * @eventType locationSourceChange
       */
      public static const LOCATION_SOURCE_CHANGE:String = "locationSourceChange";
      
      
      /**
       * Dispatched form <code>OrdersController.showSpeedUpPopup()</code>. Currently active space map
       * must show a speed up popup when this event is dispatched.
       * 
       * @param uicmdActivateSpeedUpPopup
       */
      public static const UICMD_ACTIVATE_SPEED_UP_POPUP:String = "uicmdActivateSpeedUpPopup";
      
      
      /**
       * Constructor.
       * 
       * @param _hopCount - used for showing speed up popup
       */
      public function OrdersControllerEvent(type:String, _hopCount: int = 0)
      {
         hopCount = _hopCount;
         super(type, false, false);
      }
      
      public var hopCount: int = 0;
      
      /**
       * Marks the time (in seconds; without speed modifier applied) units whould reach their destination if
       * they are dispatched right now. Relevant only for <code>UICMD_ACTIVATE_SPEED_UP_POPUP</code> event.
       */
      public var arrivalTime:Number;
   }
}