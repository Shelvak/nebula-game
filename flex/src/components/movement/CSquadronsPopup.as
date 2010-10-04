package components.movement
{
   import components.base.BaseSkinnableComponent;
   import components.movement.skins.CSquadronsPopupSkin;
   
   import controllers.ui.NavigationController;
   import controllers.units.OrdersController;
   
   import ext.flex.mx.collections.ArrayCollectionSlave;
   import ext.flex.mx.collections.ICollectionView;
   
   import flash.events.MouseEvent;
   
   import models.IModelsList;
   import models.Owner;
   import models.movement.MSquadron;
   
   import mx.events.FlexEvent;
   
   import spark.components.Button;
   import spark.components.DataGroup;
   import spark.components.List;
   import spark.events.IndexChangeEvent;
   
   
   /**
    * List of squadrons is shown.
    */
   [SkinState("list")]
   
   /**
    * All information about one squadron is shown. 
    */
   [SkinState("squadron")]
   
   
   [ResourceBundle("Movement")]
   
   
   /**
    * This is a window that pops up when user clicks on a <code>CSquadronsMapIcon</code> componenent.
    */
   public class CSquadronsPopup extends BaseSkinnableComponent
   {
      /**
       * Constructor.
       */
      public function CSquadronsPopup()
      {
         super();
         setStyle("skinClass", CSquadronsPopupSkin);
         addSelfEventHandlers();
      }
      
      
      /* ################## */
      /* ### PROPERTIES ### */
      /* ################## */
      
      
      private var _selectedSquadron:MSquadron = null;
      public function set selectedSquadron(value:MSquadron) : void
      {
         if (_selectedSquadron != value)
         {
            _selectedSquadron = value;
            f_selectedSquadronChanged = true;
         }
      }
      public function get selectedSquadron() : MSquadron
      {
         return _selectedSquadron;
      }
      
      
      private var _squadrons:IModelsList = null;
      /**
       * List of squadrons to show information about.
       */
      public function set squadrons(value:IModelsList) : void
      {
         if (_squadrons != value)
         {
            _squadrons = value;
            f_squadronsChanged = true;
            invalidateProperties();
         }
      }
      
      
      private var f_selectedSquadronChanged:Boolean = true;
      private var f_squadronsChanged:Boolean = true;
      
      
      protected override function commitProperties() : void
      {
         super.commitProperties();
         if (f_squadronsChanged)
         {
            if (!f_selectedSquadronChanged)
            {
               deselectSelectedSquadron();
            }
            squadronsList.dataProvider = _squadrons;
            if (_squadrons)
            {
               // if we have one squad in the list, select it right away
               if (ICollectionView(_squadrons).length == 1 && !f_selectedSquadronChanged)
               {
                  selectedSquadron = MSquadron(_squadrons.getFirstItem());
               }
               visible = true;
            }
            else
            {
               visible = false;
            }
         }
         if (f_selectedSquadronChanged)
         {
            squadronsList.selectedItem = _selectedSquadron;
         }
         f_selectedSquadronChanged = false;
         f_squadronsChanged = false;
      }
      
      
      /* ###################### */
      /* ### INTERNAL LOGIC ### */
      /* ###################### */
      
      
      private function get isSquadronSelected() : Boolean
      {
         return _selectedSquadron != null;
      }
      
      
      private function selectSquadron(squadron:MSquadron) : void
      {
         _selectedSquadron = squadron;
         _selectedSquadron.showRoute = true;
         unitsList.dataProvider = _selectedSquadron.units;
         invalidateSkinState();
         updateUnitsOrdersButtonsVisibility();
      }
      
      
      private function deselectSelectedSquadron() : void
      {
         if (_selectedSquadron)
         {
            _selectedSquadron.showRoute = false;
            _selectedSquadron = null;
            unitsList.dataProvider = null;
            squadronsList.selectedIndex = -1;
            invalidateSkinState();
            updateUnitsOrdersButtonsVisibility();
         }
      }
      
      
      /* ############ */
      /* ### SKIN ### */
      /* ############ */
      
      
      [SkinPart(required="true")]
      /**
       * When user click, this button will deselect selected squadron and component will switch
       * to "list" state.
       */
      public var backButton:Button;
      
      
      [SkinPart(required="true")]
      /**
       * When clicked, opens up units screen so that user could issue orders for units in space.
       */
      public var unitsManagementButton:Button;
      
      
      [SkinPart(required="true")]
      /**
       * Lets user easily move all units in the squadron to another location.
       */
      public var moveButton:Button;
      
      
      [SkinPart(required="true")]
      /**
       * Stops moving squadron.
       */
      public var stopButton:Button;
      
      
      private function updateUnitsOrdersButtonsVisibility() : void
      {
         if (unitsManagementButton && moveButton)
         {
            moveButton.visible =
            unitsManagementButton.visible = isSquadronSelected ?
               _selectedSquadron.owner == Owner.PLAYER : false;
         }
         if (stopButton)
         {
            stopButton.visible = isSquadronSelected ?
               _selectedSquadron.owner == Owner.PLAYER && _selectedSquadron.isMoving : false;
         }
      }
      
      
      [SkinPart(required="true")]
      /**
       * A list that will hold compact representation of each squadron.
       */
      public var squadronsList:List;
      
      
      [SkinPart(required="true")]
      /**
       * Holds a list of units in one squadron.
       */
      public var unitsList:DataGroup;
      
      
      protected override function partAdded(partName:String, instance:Object) : void
      {
         if (instance == squadronsList)
         {
            squadronsList.requireSelection = false;
            squadronsList.allowMultipleSelection = false;
            addSquadronsListEventHandlers(squadronsList);
         }
         else if (instance == backButton)
         {
            backButton.label = getString("label.close");
            addBackButtonEventHandlers(backButton);
         }
         else if (instance == unitsManagementButton)
         {
            unitsManagementButton.label = getString("label.unitsManagement");
            addUnitsManagementButtonEventHandlers(unitsManagementButton);
            updateUnitsOrdersButtonsVisibility();
         }
         else if (instance == stopButton)
         {
            stopButton.label = getString("label.stop");
            addStopButtonEventHandlers(stopButton);
            updateUnitsOrdersButtonsVisibility();
         }
         else if (instance == moveButton)
         {
            moveButton.label = getString("label.move");
            addMoveButtonEventHandlers(moveButton);
            updateUnitsOrdersButtonsVisibility();
         }
      }
      
      
      protected override function getCurrentSkinState() : String
      {
         if (isSquadronSelected)
         {
            return "squadron";
         }
         return "list";
      }
      
      
      /* ################################# */
      /* ### SKIN PARTS EVENT HANDLERS ### */
      /* ################################# */
      
      
      private function addSquadronsListEventHandlers(list:List) : void
      {
         list.addEventListener(IndexChangeEvent.CHANGE, squadronsList_changeHandler);
         list.addEventListener(FlexEvent.VALUE_COMMIT, squadronsList_valueCommitHandler);
      }
      
      
      private function squadronsList_changeHandler(event:IndexChangeEvent) : void
      {
         if (event.oldIndex >= 0)
         {
            deselectSelectedSquadron();
         }
         if (event.newIndex >= 0)
         {
            selectedSquadron = squadronsList.selectedItem;
            selectSquadron(squadronsList.selectedItem);
         }
      }
      
      
      private function squadronsList_valueCommitHandler(event:FlexEvent) : void
      {
         if (_squadrons && squadronsList.selectedItem)
         {
            selectSquadron(squadronsList.selectedItem);
         }
      }
      
      
      private function addBackButtonEventHandlers(button:Button) : void
      {
         button.addEventListener(MouseEvent.CLICK, backButton_clickHandler);
      }
      
      
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
      
      
      private function backButton_clickHandler(event:MouseEvent) : void
      {
         deselectSelectedSquadron();
      }
      
      
      private function unitsManagementButton_clickHandler(event:MouseEvent) : void
      {
         NavigationController.getInstance().showUnits(
            _selectedSquadron.units,
            _selectedSquadron.currentLocation
         );
      }
      
      
      private function moveButton_clickHandler(event:MouseEvent) : void
      {
         OrdersController.getInstance().issueOrder(_selectedSquadron.units, _selectedSquadron.currentLocation);
      }
      
      
      private function stopButton_clickHandler(event:MouseEvent) : void
      {
         // TODO: once server supports this, I will have to implement the feature
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
      
      
      /* ######################### */
      /* ### INTERFACE METHODS ### */
      /* ######################### */
      
      
      /**
       * Call this to reset component to its initial state (selected squadron is deselected
       * and list of squadrons is set to <code>null</code>).
       */
      public function reset() : void
      {
         deselectSelectedSquadron();
         squadrons = null;
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