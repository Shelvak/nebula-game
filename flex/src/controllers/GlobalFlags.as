package controllers
{
   import com.developmentarc.core.utils.SingletonFactory;
   
   import controllers.events.GlobalFlagsEvent;
   
   import flash.events.EventDispatcher;

   
   /**
    * Dispatched when <code>issuingOrders</code> property of <code>GlobalFlags</code> instance
    * changes.
    * 
    * @eventType controllers.events.GlobalFlagsEvent.ISSUING_ORDERS_CHANGE
    */
   [Event(name="issuingOrdersChange", type="controllers.events.GlobalFlagsEvent")]
   
   
   /**
    * Defines static flags that alter actions of a few controllers in a row.
    */
   public class GlobalFlags extends EventDispatcher
   {
      /**
       * Sets all flags to their default values.
       */
      public static function reset () :void
      {
         var inst:GlobalFlags = getInstance();
         inst.reconnecting = false;
         inst.lockApplication = false;
         inst.issuingOrders = false;
      }
      
      
      /**
       * @return allways the same instance of <code>GlobalFlags</code>
       */
      public static function getInstance() : GlobalFlags
      {
         return SingletonFactory.getSingletonInstance(GlobalFlags);
      }
      
      
      /**
       * If true this it meants that application is going through the process
       * of reconnecting with the server.
       */
      public var reconnecting:Boolean = false;
      
      
      [Bindable]
      /**
       * If <code>true</code> user won't be able to input anything and spinner will be shown.
       */
      public var lockApplication:Boolean = false;
      
      
      private var _issuingOrders:Boolean = false;
      [Bindable(event="issuingOrdersChange")]
      /**
       * Indicates if user is going to give orders to some units.
       */
      public function set issuingOrders(value:Boolean) : void
      {
         if (_issuingOrders != value)
         {
            _issuingOrders = value;
            dispatchEvent(new GlobalFlagsEvent(GlobalFlagsEvent.ISSUING_ORDERS_CHANGE));
         }
      }
      /**
       * @private
       */
      public function get issuingOrders() : Boolean
      {
         return _issuingOrders;
      }
   }
}