package components.movement
{
   import components.base.BaseSkinnableComponent;
   import components.movement.skins.COrderPopupSkin;
   
   import controllers.units.OrdersController;
   
   import flash.events.MouseEvent;
   
   import models.BaseModel;
   import models.location.LocationMinimal;
   import models.location.LocationType;
   
   import spark.components.Button;
   import spark.components.RadioButton;
   import spark.components.RadioButtonGroup;
   
   
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
   
   [ResourceBundle("Movement")]
   public class COrderPopup extends BaseSkinnableComponent
   {
      private static const ORDERS_CTRL:OrdersController = OrdersController.getInstance();
      
      
      private var _radioGroup:RadioButtonGroup;
      
      
      /* ###################### */
      /* ### INITIALIZATION ### */
      /* ###################### */
      
      
      public function COrderPopup() : void
      {
         _radioGroup = new RadioButtonGroup();
         setStyle("skinClass", COrderPopupSkin);
         addSelfEventHandlers();
         visible = false;
      }
      
      
      public function reset() : void
      {
         locationPlanet = null;
         locationSpace = null;
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
            f_locationSpaceChanged = true;
            invalidateProperties();
            invalidateSkinState();
         }
      }
      
      
      private var _locationPlanet:LocationMinimal;
      public function set locationPlanet(value:LocationMinimal) : void
      {
         if (_locationPlanet != value)
         {
            _locationPlanet = value;
            f_locationPlanetChanged = true;
            invalidateProperties();
            invalidateSkinState();
         }
      }
      
      
      private var f_locationSpaceChanged:Boolean = true;
      private var f_locationPlanetChanged:Boolean = true;
      
      
      protected override function commitProperties() : void
      {
         super.commitProperties();
         if (f_locationPlanetChanged || f_locationSpaceChanged)
         {
            visible = _locationPlanet || _locationSpace;
         }
         f_locationPlanetChanged =
         f_locationSpaceChanged = false;
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
               btnToSector.label = RM.getString("Movement", "label.toSector");
               break;
            case btnToPlanet:
               btnToPlanet.addEventListener(MouseEvent.CLICK, btnToPlanet_clickHandler);
               btnToPlanet.label = RM.getString("Movement", "label.toPlanet");
               break;
            case btnCancel:
               btnCancel.addEventListener(MouseEvent.CLICK, btnCancel_clickHandler);
               btnCancel.label = RM.getString("Movement", "label.cancel");
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
      
      
      /* ############### */
      /* ### HELPERS ### */
      /* ############### */
      
      
      private function get location() : LocationMinimal
      {
         return LocationMinimal(model);
      }
   }
}