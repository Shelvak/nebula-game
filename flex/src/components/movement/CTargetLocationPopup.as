package components.movement
{
   import components.base.BaseSkinnableComponent;
   import components.movement.skins.CTargetLocationPopupSkin;
   
   import controllers.units.OrdersController;
   
   import flash.events.MouseEvent;
   
   import interfaces.ICleanable;
   
   import models.location.LocationMinimal;
   
   import mx.events.PropertyChangeEvent;
   
   import namespaces.prop_name;
   
   import spark.components.Button;
   import spark.components.CheckBox;
   
   import utils.locale.Localizer;
   
   
   /**
    * User may only confirm or cancel location as he/she clicked on a space sector without a planet in
    * it.
    */
   [SkinState("space")]
   
   /**
    * User may only confirm or cancel location as he/she clicked on a space sector with a planet in it
    * but can't move units to the space sector itself (probably units are already there).
    */
   [SkinState("planet")]
   
   /**
    * User can also select if he/she wants to send units to a space sector or a planet in that
    * sector.
    */
   [SkinState("dual")]
   
   public class CTargetLocationPopup extends BaseSkinnableComponent implements ICleanable
   {
      private function get ORDERS_CTRL() : OrdersController {
         return OrdersController.getInstance();
      }
      
      
      /* ###################### */
      /* ### INITIALIZATION ### */
      /* ###################### */
      
      public function CTargetLocationPopup() : void {
         setStyle("skinClass", CTargetLocationPopupSkin);
         addSelfEventHandlers();
         addOrdersControllerEventHandlers();
         visible = false;
      }
      
      public function cleanup() : void {
         removeOrdersControllerEventHandlers();
      }
      
      
      /* ################## */
      /* ### PROPERTIES ### */
      /* ################## */
      
      private var _locationSpace:LocationMinimal;
      public function set locationSpace(value:LocationMinimal) : void {
         if (_locationSpace != value) {
            _locationSpace = value;
            includeInLayout = visible = _locationPlanet || _locationSpace;
            invalidateSkinState();
         }
      }
      public function get locationSpace() : LocationMinimal {
         return _locationSpace;
      }
      
      private var _locationPlanet:LocationMinimal;
      public function set locationPlanet(value:LocationMinimal) : void {
         if (_locationPlanet != value) {
            _locationPlanet = value;
            includeInLayout = visible = _locationPlanet || _locationSpace;
            invalidateSkinState();
         }
      }
      public function get locationPlanet() : LocationMinimal {
         return _locationPlanet;
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
      
      [SkinPart(required="true")]
      /**
       * Lets user to choose whether NPC units should be avoided.
       */
      public var chkAvoidNpc:CheckBox;
      
      private function resetAvoidNpcCheckBox() : void {
         if (chkAvoidNpc != null) chkAvoidNpc.selected = true;
      }
      
      protected override function partAdded(partName:String, instance:Object) : void {
         super.partAdded(partName, instance);
         switch(instance) {
            case btnToSector:
               btnToSector.addEventListener(MouseEvent.CLICK, btnToSector_clickHandler);
               btnToSector.label = getString("label.toSector");
               break;
            case btnToPlanet:
               btnToPlanet.addEventListener(MouseEvent.CLICK, btnToPlanet_clickHandler);
               btnToPlanet.label = getString("label.toPlanet");
               break;
            case btnCancel:
               btnCancel.addEventListener(MouseEvent.CLICK, btnCancel_clickHandler);
               btnCancel.label = getString("label.cancel");
               break;
            case chkAvoidNpc:
               chkAvoidNpc.label = getString("label.avoidNpc");
               chkAvoidNpc.toolTip = getString("description.avoidNpc");
               resetAvoidNpcCheckBox();
               break;
         }
      }
      
      protected override function getCurrentSkinState() : String {
         if (_locationSpace && _locationPlanet) return "dual";
         if (_locationSpace) return "space"
         return "planet";
      }
      
      
      /* ################################# */
      /* ### SKIN PARTS EVENT HANDLERS ### */
      /* ################################# */
      
      private function btnToSector_clickHandler(event:MouseEvent) : void {
         visible = false;
         ORDERS_CTRL.commitTargetLocation(_locationSpace, chkAvoidNpc.selected);
         resetAvoidNpcCheckBox();
      }
      
      private function btnToPlanet_clickHandler(event:MouseEvent) : void {
         visible = false;
         ORDERS_CTRL.commitTargetLocation(_locationPlanet, chkAvoidNpc.selected);
         resetAvoidNpcCheckBox();
      }
      
      private function btnCancel_clickHandler(event:MouseEvent) : void {
         visible = false;
         ORDERS_CTRL.cancelOrder();
         resetAvoidNpcCheckBox();
      }
      
      
      /* ########################### */
      /* ### SELF EVENT HANDLERS ### */
      /* ########################### */
      
      private function addSelfEventHandlers() : void {
         addEventListener(MouseEvent.CLICK, this_mouseEventHandler);
         addEventListener(MouseEvent.MOUSE_MOVE, this_mouseEventHandler);
      }
      
      private function this_mouseEventHandler(event:MouseEvent) : void {
         event.stopImmediatePropagation();
      }
      
      
      /* ######################################## */
      /* ### ORDERS CONTROLLER EVENT HANDLERS ### */
      /* ######################################## */
      
      private function addOrdersControllerEventHandlers() : void {
         ORDERS_CTRL.addEventListener(
            PropertyChangeEvent.PROPERTY_CHANGE, ordersCtrl_propertyChangeHandler, false, 0, true
         );
      }
      
      private function removeOrdersControllerEventHandlers() : void {
         ORDERS_CTRL.removeEventListener(
            PropertyChangeEvent.PROPERTY_CHANGE, ordersCtrl_propertyChangeHandler, false
         );
      }
      
      private function ordersCtrl_propertyChangeHandler(event:PropertyChangeEvent) : void {
         if (event.property == OrdersController.prop_name::flag_disableOrderPopup)
            enabled = !ORDERS_CTRL.flag_disableOrderPopup;
      }
      
      
      /* ############### */
      /* ### HELPERS ### */
      /* ############### */
      
      private function get location() : LocationMinimal {
         return LocationMinimal(model);
      }
      
      private function getString(property:String, parameters:Array = null) : String {
         return Localizer.string("Movement", property, parameters);
      }
   }
}