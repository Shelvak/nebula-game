package components.movement
{
   import components.base.BaseSkinnableComponent;
   import components.movement.skins.COrderPopupSkin;
   
   import controllers.units.OrdersController;
   
   import flash.events.MouseEvent;
   
   import interfaces.ICleanable;
   
   import models.location.LocationMinimal;
   
   import mx.events.PropertyChangeEvent;
   
   import namespaces.property_name;
   
   import spark.components.Button;
   
   import utils.Localizer;
   
   
   /**
    * User may only confirm or cancel order as he/she clicked on a space sector without a planet in
    * it.
    */
   [SkinState("space")]
   
   /**
    * User may only confirm or cancel order as he/she clicked on a space sector with a planet in it
    * but can't move units to the space sector itself (probably units are already there).
    */
   [SkinState("planet")]
   
   /**
    * User can also select if he/she wants to send units to a space sector or a planet in that
    * sector.
    */
   [SkinState("dual")]
   
   
   public class COrderPopup extends BaseSkinnableComponent implements ICleanable
   {
      private static const ORDERS_CTRL:OrdersController = OrdersController.getInstance();
      
      
      /* ###################### */
      /* ### INITIALIZATION ### */
      /* ###################### */
      
      
      public function COrderPopup() : void
      {
         setStyle("skinClass", COrderPopupSkin);
         addSelfEventHandlers();
         addOrdersControllerEventHandlers();
         visible = false;
      }
      
      
      public function reset() : void
      {
         locationPlanet = null;
         locationSpace = null;
         enabled = true;
         includeInLayout =
         visible = false;
      }
      
      
      public function cleanup() : void
      {
         removeOrdersControllerEventHandlers();
      }
      
      
      /* ################## */
      /* ### PROPERTIES ### */
      /* ################## */
      
      
      private var _locationSpace:LocationMinimal;
      public function set locationSpace(value:LocationMinimal) : void
      {
         if (_locationSpace != value)
         {
            _locationSpace = value;
            includeInLayout = visible = _locationPlanet || _locationSpace;
            invalidateSkinState();
         }
      }
      
      
      private var _locationPlanet:LocationMinimal;
      public function set locationPlanet(value:LocationMinimal) : void
      {
         if (_locationPlanet != value)
         {
            _locationPlanet = value;
            includeInLayout = visible = _locationPlanet || _locationSpace;
            invalidateSkinState();
         }
      }
      
      
      /* ############ */
      /* ### SKIN ### */
      /* ############ */
      
      
      [SkinPart(required="true")]
      /**
       * User will send units to a space sector with this button.
       */
      public var btnToSector:Button;
      
      
      [SkinPart(required="true")]
      /**
       * User will send units to a planet with this button.
       */
      public var btnToPlanet:Button;
      
      
      [SkinPart(required="true")]
      /**
       * User may cancel order with this button.
       */
      public var btnCancel:Button;
      
      
      protected override function partAdded(partName:String, instance:Object) : void
      {
         super.partAdded(partName, instance);
         switch(instance)
         {
            case btnToSector:
               btnToSector.addEventListener(MouseEvent.CLICK, btnToSector_clickHandler);
               btnToSector.label = Localizer.string("Movement", "label.toSector");
               break;
            case btnToPlanet:
               btnToPlanet.addEventListener(MouseEvent.CLICK, btnToPlanet_clickHandler);
               btnToPlanet.label = Localizer.string("Movement", "label.toPlanet");
               break;
            case btnCancel:
               btnCancel.addEventListener(MouseEvent.CLICK, btnCancel_clickHandler);
               btnCancel.label = Localizer.string("Movement", "label.cancel");
               break;
         }
      }
      
      
      protected override function getCurrentSkinState() : String
      {
         if (_locationSpace && _locationPlanet)
         {
            return "dual";
         }
         if (_locationSpace)
         {
            return "space"
         }
         return "planet";
      }
      
      
      /* ################################# */
      /* ### SKIN PARTS EVENT HANDLERS ### */
      /* ################################# */
      
      
      private function btnToSector_clickHandler(event:MouseEvent) : void
      {
         visible = false;
         ORDERS_CTRL.commitOrder(_locationSpace);
      }
      
      
      private function btnToPlanet_clickHandler(event:MouseEvent) : void
      {
         visible = false;
         ORDERS_CTRL.commitOrder(_locationPlanet);
      }
      
      
      private function btnCancel_clickHandler(event:MouseEvent) : void
      {
         visible = false;
         ORDERS_CTRL.cancelOrder();
      }
      
      
      /* ########################### */
      /* ### SELF EVENT HANDLERS ### */
      /* ########################### */
      
      
      private function addSelfEventHandlers() : void
      {
         addEventListener(MouseEvent.CLICK, this_mouseEventHandler);
         addEventListener(MouseEvent.MOUSE_MOVE, this_mouseEventHandler);
      }
      
      
      private function this_mouseEventHandler(event:MouseEvent) : void
      {
         event.stopImmediatePropagation();
      }
      
      
      /* ######################################## */
      /* ### ORDERS CONTROLLER EVENT HANDLERS ### */
      /* ######################################## */
      
      
      private function addOrdersControllerEventHandlers() : void
      {
         ORDERS_CTRL.addEventListener(PropertyChangeEvent.PROPERTY_CHANGE, ordersCtrl_propertyChangeHandler,
                                      false, 0, true);
      }
      
      
      private function removeOrdersControllerEventHandlers() : void
      {
         ORDERS_CTRL.removeEventListener(PropertyChangeEvent.PROPERTY_CHANGE, ordersCtrl_propertyChangeHandler,
                                         false);
      }
      
      
      private function ordersCtrl_propertyChangeHandler(event:PropertyChangeEvent) : void
      {
         if (event.property == OrdersController.property_name::flag_disableOrderPopup)
         {
            enabled = !ORDERS_CTRL.flag_disableOrderPopup;
         }
      }
      
      
      /* ############### */
      /* ### HELPERS ### */
      /* ############### */
      
      
      private function get location() : LocationMinimal
      {
         return LocationMinimal(model);
      }
   }
}