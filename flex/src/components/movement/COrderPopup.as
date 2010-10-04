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
   [SkinState("normal")]
   
   /**
    * User can also select if he/she wants to send units to a space sector or a planet in that
    * sector.
    */
   [SkinState("dualLocation")]
   
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
       * User confirms order with this button.
       */
      public var btnCommitOrder:Button;
      
      
      [SkinPart(required="true")]
      /**
       * User may cancel order with this button.
       */
      public var btnCancelOrder:Button;
      
      
      [SkinPart(required="true")]
      /**
       * If selected, user will issue move order to a space sector. Visible only in "dualLocation"
       * state.
       */
      public var radioSector:RadioButton;
      
      
      [SkinPart(required="true")]
      /**
       * If selected, user will issue land order on a planet. Visible only in "dualLocation" state.
       */
      public var radioPlanet:RadioButton;
      
      
      protected override function partAdded(partName:String, instance:Object) : void
      {
         super.partAdded(partName, instance);
         switch(instance)
         {
            case btnCommitOrder:
               btnCommitOrder.addEventListener(MouseEvent.CLICK, btnCommitOrder_clickHandler);
               btnCommitOrder.label = RM.getString("Movement", "label.commitOrder");
               break;
            case btnCancelOrder:
               btnCancelOrder.addEventListener(MouseEvent.CLICK, btnCancelOrder_clickHandler);
               btnCancelOrder.label = RM.getString("Movement", "label.cancelOrder");
               break;
            case radioPlanet:
               radioPlanet.group = _radioGroup;
               radioPlanet.label = RM.getString("Movement", "label.planet");
               radioPlanet.selected = true;
               _radioGroup.selection = radioPlanet;
               break;
            case radioSector:
               radioSector.group = _radioGroup;
               radioSector.label = RM.getString("Movement", "label.sector");
               break;
         }
      }
      
      
      protected override function getCurrentSkinState() : String
      {
         if (_locationSpace && _locationPlanet)
         {
            return "dualLocation";
         }
         return "normal";
      }
      
      
      /* ################################# */
      /* ### SKIN PARTS EVENT HANDLERS ### */
      /* ################################# */
      
      
      private function btnCommitOrder_clickHandler(event:MouseEvent) : void
      {
         visible = false;
         var location:LocationMinimal;
         if (_locationSpace && _locationPlanet)
         {
            if (radioPlanet.selected)
            {
               location = _locationPlanet
            }
            else
            {
               location = _locationSpace;
            }
            
         }
         else if (_locationSpace)
         {
            location = _locationSpace;
         }
         else
         {
            location = _locationPlanet;
         }
         ORDERS_CTRL.commitOrder(location);
      }
      
      
      private function btnCancelOrder_clickHandler(event:MouseEvent) : void
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