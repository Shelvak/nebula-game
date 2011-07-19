package components.movement
{
   import com.developmentarc.core.utils.EventBroker;
   
   import components.map.space.CSpaceMapPopup;
   import components.movement.skins.CSquadronPopupSkin;
   import components.ui.PlayerProfileButton;
   
   import controllers.routes.RoutesCommand;
   import controllers.ui.NavigationController;
   import controllers.units.OrdersController;
   
   import flash.events.MouseEvent;
   
   import globalevents.GlobalEvent;
   
   import interfaces.ICleanable;
   
   import models.Owner;
   import models.events.BaseModelEvent;
   import models.movement.MSquadron;
   import models.unit.Unit;
   
   import mx.collections.ListCollectionView;
   
   import spark.components.Button;
   import spark.components.Label;
   import spark.components.List;
   
   import utils.DateUtil;
   import utils.datastructures.Collections;
   import utils.locale.Localizer;
   
   
   /**
    * This is a window that pops up when user clicks on a <code>CSquadronsMapIcon</code> componenent.
    */
   public class CSquadronPopup extends CSpaceMapPopup implements ICleanable
   {
      public function CSquadronPopup() {
         super();
         setStyle("skinClass", CSquadronPopupSkin);
      }
      
      public function cleanup() : void {
         if (squadron != null) {
            squadron = null
            lstUnits.dataProvider = null;
            removeGlobalEventHandlers();
         }
      }
      
      private function get NAV_CTRL() : NavigationController {
         return NavigationController.getInstance();
      }
      
      
      /* ################## */
      /* ### PROPERTIES ### */
      /* ################## */
      
      private var _squadronOld:MSquadron = null;
      private var _squadron:MSquadron = null;
      [Bindable]
      /**
       * A squadron to show information about.
       */
      public function set squadron(value:MSquadron) : void {
         if (_squadron != value) {
            if (_squadronOld == null)
               _squadronOld = _squadron;
            _squadron = value;
            f_squadronChanged = true;
            invalidateProperties();
         }
      }
      /**
       * @private
       */
      public function get squadron() : MSquadron {
         return _squadron;
      }
      
      private var f_squadronChanged:Boolean = true,
                  f_underMouseChanged:Boolean = true,
                  f_squadronPendingChanged:Boolean = true;
      
      protected override function commitProperties() : void{
         super.commitProperties();
         if (f_squadronChanged) {
            if (_squadronOld != null)
               removeSquadronEventHandlers(_squadronOld);
            if (_squadron != null)
               addSquadronEventHandlers(_squadron);
            if (_squadron != null && _squadron.route != null)
               addGlobalEventHandlers();
            else
               removeGlobalEventHandlers();
            lstUnits.dataProvider = _squadron != null ? _squadron.units : null;
            visible = _squadron != null ? true : false;
            showSourceLoc = _squadron != null && _squadron.route != null;
            showDestLoc = showSourceLoc;
            updateUnitsOrdersButtonsVisibility();
            updateUnitsManagementButtonLabel();
            updateSourceAndDestLabels();
            updateArrivesInLabel();
            updateOwnerButton();
         }
         if (f_squadronChanged || f_squadronPendingChanged)
            enabled = _squadron == null || !_squadron.pending;
         f_squadronChanged = f_squadronPendingChanged = false;
      }
      
      
      /* ############ */
      /* ### SKIN ### */
      /* ############ */
      
      [Bindable]
      /**
       * Whether source location information should be visible or not. Skin only cares about this.
       */
      public var showSourceLoc:Boolean = true;
      
      [Bindable]
      /**
       * Whether source location information should be visible or not. Skin only cares about this.
       */
      public var showDestLoc:Boolean = true;
      
      [SkinPart(required="true")]
      /**
       * When clicked, opens up units screen so that user could issue orders for units in space.
       */
      public var btnUnitsManagement:Button;
      
      private function updateUnitsManagementButtonLabel() : void {
         if (btnUnitsManagement != null && _squadron != null) {
            if (_squadron.owner == Owner.PLAYER)
               btnUnitsManagement.label = getString("label.unitsManagement");
            else
               btnUnitsManagement.label = getString("label.showUnits");
         }
      }
      
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
      
      private function updateUnitsOrdersButtonsVisibility() : void {
         if (btnMove != null)
            btnMove.visible = _squadron != null && _squadron.owner == Owner.PLAYER;
         if (btnStop != null)
            btnStop.visible = _squadron != null && _squadron.owner == Owner.PLAYER && _squadron.isMoving;
      }
      
      [SkinPart(required="true")]
      /**
       * List of units in a squadron.
       */
      public var lstUnits:List;
      
      [SkinPart(required="true")]
      /**
       * When clicked, navigates to squadrons source (departure) location.
       */
      public var btnOpenSourceLoc:Button;
      
      [SkinPart(required="true")]
      /**
       * When clicked, navigates to squadrons destination (target) location.
       */
      public var btnOpenDestLoc:Button;
      
      [SkinPart(required="true")]
      /**
       * Label to hold source location title.
       */
      public var lblSourceLocTitle:Label;
      
      [SkinPart(required="true")]
      /**
       * Label to hold information about source location.
       */
      public var lblSourceLoc:Label;
      
      [SkinPart(required="true")]
      /**
       * Label to hold destination location title.
       */
      public var lblDestLocTitle:Label;
      
      [SkinPart(required="true")]
      /**
       * Label to hold information about destination location.
       */
      public var lblDestLoc:Label;
      
      private function updateSourceAndDestLabels() : void
      {
         if (_squadron != null && _squadron.route != null) {
            if (lblSourceLocTitle != null) lblSourceLocTitle.text = getString("label.location.source");
            if (lblSourceLoc != null) lblSourceLoc.text = _squadron.route.sourceLocation.shortDescription;
            if (lblDestLocTitle != null) lblDestLocTitle.text = getString("label.location.target");
            if (lblDestLoc != null) lblDestLoc.text = _squadron.route.targetLocation.shortDescription;
         }
      }
      
      [SkinPart(required="true")]
      /**
       * Shows how long until squadron reaches its destination.
       */
      public var lblArrivesIn:Label;
      
      private function updateArrivesInLabel() : void {
         if (lblArrivesIn != null && _squadron != null && _squadron.route != null)
            lblArrivesIn.text = getString
               ("label.location.arrivesIn", [_squadron.route.arrivalEvent.occuresInString]);
      }
      
      [SkinPart(required="true")]
      /**
       * Owner label.
       */
      public var lblOwner:Label;
      
      [SkinPart(required="true")]
      /**
       * Opens player profile when clicked. 
       */
      public var btnOwner:PlayerProfileButton;
      
      private function updateOwnerButton() : void {
         if (btnOwner != null && _squadron != null) btnOwner.player = _squadron.player;
      }
      
      
      protected override function partAdded(partName:String, instance:Object) : void
      {
         if (instance == btnUnitsManagement) {
            updateUnitsManagementButtonLabel();
            addUnitsManagementButtonEventHandlers(btnUnitsManagement);
            updateUnitsOrdersButtonsVisibility();
         }
         else if (instance == btnStop) {
            btnStop.label = getString("label.stop");
            addStopButtonEventHandlers(btnStop);
            updateUnitsOrdersButtonsVisibility();
         }
         else if (instance == btnMove) {
            btnMove.label = getString("label.move");
            addMoveButtonEventHandlers(btnMove);
            updateUnitsOrdersButtonsVisibility();
         }
         else if (instance == btnOpenSourceLoc) {
            addSourceLocButtonEventHandlers(btnOpenSourceLoc);
         }
         else if (instance == btnOpenDestLoc) {
            addDestLocButtonEventHandlers(btnOpenDestLoc);
         }
         else if (instance == lblOwner) {
            lblOwner.text = getString("label.owner");
         }
         else if (instance == btnOwner) {
            addOwnerButtonEventHandlers(btnOwner);
            updateOwnerButton();
         }
         if (instance == btnOpenSourceLoc || instance == btnOpenDestLoc) {
            Button(instance).label = getString("label.location.open");
         }
      }
      
      
      /* ################################# */
      /* ### SKIN PARTS EVENT HANDLERS ### */
      /* ################################# */
      
      private function addUnitsManagementButtonEventHandlers(button:Button) : void {
         button.addEventListener(MouseEvent.CLICK, unitsManagementButton_clickHandler);
      }
      
      private function addStopButtonEventHandlers(button:Button) : void {
         button.addEventListener(MouseEvent.CLICK, stopButton_clickHandler);
      }
      
      private function addMoveButtonEventHandlers(button:Button) : void {
         button.addEventListener(MouseEvent.CLICK, moveButton_clickHandler);
      }
      
      private function addSourceLocButtonEventHandlers(button:Button) : void {
         button.addEventListener(MouseEvent.CLICK, btnOpenSourceLoc_clickHandler);
      }
      
      private function addDestLocButtonEventHandlers(button:Button) : void {
         button.addEventListener(MouseEvent.CLICK, btnOpenDestLoc_clickHandler);
      }
      
      private function addOwnerButtonEventHandlers(button:Button) : void {
         button.addEventListener(MouseEvent.CLICK, btnOwner_clickHandler, false, 0, true);
      }
      
      private function unitsManagementButton_clickHandler(event:MouseEvent) : void {
         var unitIDs:Array = _squadron.units.toArray().map(
            function(unit:Unit, idx:int, array:Array) : int { return unit.id }
         );
         var units:ListCollectionView = Collections.filter(_squadron.units,
            function(unit:Unit) : Boolean { return unitIDs.indexOf(unit.id) >= 0 }
         );
         NAV_CTRL.showUnits(units, _squadron.currentHop.location.toLocation(), null, null, _squadron.owner);
      }
      
      private function moveButton_clickHandler(event:MouseEvent) : void {
         OrdersController.getInstance().issueOrder(_squadron.units, true, _squadron);
      }
      
      private function stopButton_clickHandler(event:MouseEvent) : void {
         new RoutesCommand(RoutesCommand.DESTROY, _squadron).dispatch();
      }
      
      private function btnOpenSourceLoc_clickHandler(event:MouseEvent) : void {
         _squadron.route.sourceLocation.navigateTo();
      }
            
      private function btnOpenDestLoc_clickHandler(event:MouseEvent) : void {
         _squadron.route.targetLocation.navigateTo();
      }
      
      private function btnOwner_clickHandler(event:MouseEvent) : void {
         _squadron.player.show();
      }
      
      
      /* ################################ */
      /* ### MSQUADRON EVENT HANDLERS ### */
      /* ################################ */
      
      private function addSquadronEventHandlers(squad:MSquadron) : void {
         squad.addEventListener(BaseModelEvent.PENDING_CHANGE, squadron_pendingChangeHandler,
                                false, 0, true);
      }
      
      private function removeSquadronEventHandlers(squad:MSquadron) : void {
         squad.removeEventListener(BaseModelEvent.PENDING_CHANGE, squadron_pendingChangeHandler,
                                   false);
      }
      
      private function squadron_pendingChangeHandler(event:BaseModelEvent) : void {
         f_squadronPendingChanged = true;
         invalidateProperties();
      }
      
      
      /* ############################# */
      /* ### GLOBAL EVENT HANDLERS ### */
      /* ############################# */
      
      private function addGlobalEventHandlers() : void {
         EventBroker.subscribe(GlobalEvent.TIMED_UPDATE, global_timedUpdateHandler);
      }
      
      private function removeGlobalEventHandlers() : void {
         EventBroker.unsubscribe(GlobalEvent.TIMED_UPDATE, global_timedUpdateHandler);
      }
      
      private function global_timedUpdateHandler(event:GlobalEvent) : void {
         updateArrivesInLabel();
      }
      
      
      /* ############### */
      /* ### HELPERS ### */
      /* ############### */
      
      private function getString(resourceName:String, parameters:Array = null) : String {
         return Localizer.string("Movement", resourceName, parameters);
      }
   }
}