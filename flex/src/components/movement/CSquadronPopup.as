package components.movement
{
   import components.base.BaseSkinnableComponent;
   import components.movement.skins.CSquadronPopupSkin;
   
   import controllers.routes.RoutesCommand;
   import controllers.ui.NavigationController;
   import controllers.units.OrdersController;
   
   import flash.events.MouseEvent;
   
   import models.Owner;
   import models.movement.MSquadron;
   
   import spark.components.Button;
   import spark.components.DataGroup;
   
   
   [ResourceBundle("Movement")]
   /**
    * This is a window that pops up when user clicks on a <code>CSquadronsMapIcon</code> componenent.
    */
   public class CSquadronPopup extends BaseSkinnableComponent
   {
      public function CSquadronPopup()
      {
         super();
         setStyle("skinClass", CSquadronPopupSkin);
         addSelfEventHandlers();
      }
      
      
      /* ################## */
      /* ### PROPERTIES ### */
      /* ################## */
      
      
      private var _squadron:MSquadron = null;
      [Bindable]
      /**
       * A squadron to show information about.
       */
      public function set squadron(value:MSquadron) : void
      {
         if (_squadron != value)
         {
            _squadron = value;
            f_squadronChanged = true;
            invalidateProperties();
         }
      }
      /**
       * @private
       */
      public function get squadron() : MSquadron
      {
         return _squadron;
      }
      
      
      private var f_squadronChanged:Boolean = true;
      
      
      protected override function commitProperties() : void
      {
         super.commitProperties();
         if (f_squadronChanged)
         {
            dgrUnits.dataProvider = _squadron ? _squadron.units : null;
            visible = _squadron ? true : false;
            updateUnitsOrdersButtonsVisibility();
         }
         f_squadronChanged = false;
      }
      
      
      /* ############ */
      /* ### SKIN ### */
      /* ############ */
      
      
      [SkinPart(required="true")]
      /**
       * When clicked, opens up units screen so that user could issue orders for units in space.
       */
      public var btnUnitsManagement:Button;
      
      
      [SkinPart(required="true")]
      /**
       * Lets user easily move all units in the squadron to another location.
       */
      public var btnMove:Button;
      
      
      [SkinPart(required="true")]
      /**
       * Stops moving squadron.
       */
      public var btnStop:Button;
      
      
      private function updateUnitsOrdersButtonsVisibility() : void
      {
         if (btnUnitsManagement && btnMove)
         {
            btnMove.visible = btnUnitsManagement.visible = _squadron && _squadron.owner == Owner.PLAYER;
         }
         if (btnStop)
         {
            btnStop.visible = _squadron && _squadron.owner == Owner.PLAYER && _squadron.isMoving;
         }
      }
      
      
      [SkinPart(required="true")]
      /**
       * List of units in a squadron.
       */
      public var dgrUnits:DataGroup;
      
      
      protected override function partAdded(partName:String, instance:Object) : void
      {
         if (instance == btnUnitsManagement)
         {
            btnUnitsManagement.label = getString("label.unitsManagement");
            addUnitsManagementButtonEventHandlers(btnUnitsManagement);
            updateUnitsOrdersButtonsVisibility();
         }
         else if (instance == btnStop)
         {
            btnStop.label = getString("label.stop");
            addStopButtonEventHandlers(btnStop);
            updateUnitsOrdersButtonsVisibility();
         }
         else if (instance == btnMove)
         {
            btnMove.label = getString("label.move");
            addMoveButtonEventHandlers(btnMove);
            updateUnitsOrdersButtonsVisibility();
         }
      }
      
      
      /* ################################# */
      /* ### SKIN PARTS EVENT HANDLERS ### */
      /* ################################# */
      
      
      private function addUnitsManagementButtonEventHandlers(button:Button) : void
      {
         button.addEventListener(MouseEvent.CLICK, unitsManagementButton_clickHandler);
      }
      
      
      private function addStopButtonEventHandlers(button:Button) : void
      {
         button.addEventListener(MouseEvent.CLICK, stopButton_clickHandler);
      }
      
      
      private function addMoveButtonEventHandlers(button:Button) : void
      {
         button.addEventListener(MouseEvent.CLICK, moveButton_clickHandler);
      }
      
      
      private function unitsManagementButton_clickHandler(event:MouseEvent) : void
      {
         NavigationController.getInstance().showUnits(_squadron.units, _squadron.currentLocation);
      }
      
      
      private function moveButton_clickHandler(event:MouseEvent) : void
      {
         OrdersController.getInstance().issueOrder(_squadron.units, _squadron.currentLocation);
      }
      
      
      private function stopButton_clickHandler(event:MouseEvent) : void
      {
         new RoutesCommand(RoutesCommand.DESTROY, _squadron).dispatch();
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
      
      
      private function getString(resourceName:String) : String
      {
         return RM.getString("Movement", resourceName);
      }
   }
}