package components.movement
{
   import components.base.BaseSkinnableComponent;
   import components.movement.skins.CSquadronPopupSkin;
   
   import controllers.routes.RoutesCommand;
   import controllers.ui.NavigationController;
   import controllers.units.OrdersController;
   
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   
   import interfaces.ICleanable;
   
   import models.Owner;
   import models.movement.MSquadron;
   import models.unit.Unit;
   
   import mx.collections.ListCollectionView;
   
   import spark.components.Button;
   import spark.components.DataGroup;
   import spark.components.Group;
   import spark.components.Label;
   
   import utils.DateUtil;
   import utils.Localizer;
   import utils.datastructures.Collections;
   
   
   [ResourceBundle("Movement")]
   /**
    * This is a window that pops up when user clicks on a <code>CSquadronsMapIcon</code> componenent.
    */
   public class CSquadronPopup extends BaseSkinnableComponent implements ICleanable
   {
      internal static const ARRIVES_IN_TIMER:Timer = new Timer(1000); ARRIVES_IN_TIMER.start();
      
      
      public function CSquadronPopup()
      {
         super();
         setStyle("skinClass", CSquadronPopupSkin);
         addSelfEventHandlers();
      }
      
      
      public function cleanup() : void
      {
         if (_squadron)
         {
            _squadron = null
            dgrUnits.dataProvider = null;
            removeArrivesInTimerEventHandlers();
         }
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
      
      
      private var _underMouse:Boolean = false;
      private function set underMouse(value:Boolean) : void
      {
         if (_underMouse != value)
         {
            _underMouse = value;
            f_underMouseChanged = true;
            invalidateProperties();
         }
      }
      
      
      private var f_squadronChanged:Boolean = true,
                  f_underMouseChanged:Boolean = true;
      
      
      protected override function commitProperties() : void
      {
         super.commitProperties();
         if (f_squadronChanged)
         {
            if (_squadron && _squadron.route)
            {
               addArrivesInTimerEventHandlers();
            }
            else
            {
               removeArrivesInTimerEventHandlers();
            }
            grpUnitsViewport.verticalScrollPosition = 0;
            dgrUnits.dataProvider = _squadron ? _squadron.units : null;
            visible = _squadron ? true : false;
            showSourceLoc = _squadron && _squadron.route;
            showDestLoc = _squadron && _squadron.route;
            updateUnitsOrdersButtonsVisibility();
            updateSourceAndDestLabels();
            updateArrivesInLabel();
            updateOwnerNameLabel();
         }
         if (f_underMouseChanged)
         {
            alpha = _underMouse ? 1 : 0.3;
         }
         f_squadronChanged = f_underMouseChanged = false;
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
      
      
      [SkinPart(required="true")]
      /**
       * Scroller viewport.
       */
      public var grpUnitsViewport:Group
      
      
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
         if (_squadron && _squadron.route)
         {
            if (lblSourceLocTitle)
            {
               lblSourceLocTitle.text = getString("label.location.source");
            }
            if (lblSourceLoc)
            {
               lblSourceLoc.text = _squadron.route.sourceLocation.shortDescription;
            }
         }
         if (_squadron && _squadron.route)
         {
            if (lblDestLocTitle)
            {
               lblDestLocTitle.text = getString("label.location.target");
            }
            if (lblDestLoc)
            {
               lblDestLoc.text = _squadron.route.targetLocation.shortDescription;
            }
         }
      }
      
      
      [SkinPart(required="true")]
      /**
       * Shows how long until squadron reaches its destination.
       */
      public var lblArrivesIn:Label;
      
      
      private function updateArrivesInLabel() : void
      {
         if (lblArrivesIn && _squadron && _squadron.route)
         {
            var timeLeft:Number = Math.ceil(Math.max(_squadron.route.arrivesAt.time - new Date().time, 0) / 1000);
            lblArrivesIn.text = getString("label.location.arrivesIn", [DateUtil.secondsToHumanString(timeLeft)]);
         }
      }
      
      
      [SkinPart(required="true")]
      /**
       * Owner label.
       */
      public var lblOwner:Label;
      
      
      [SkinPart(required="true")]
      /**
       * Name of the player who owns this squadron. 
       */
      public var lblOwnerName:Label;
      
      
      private function updateOwnerNameLabel() : void
      {
         if (lblOwnerName && _squadron)
         {
            lblOwnerName.text = _squadron.player.name;
         }
      }
      
      
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
         else if (instance == btnOpenSourceLoc)
         {
            addSourceLocButtonEventHandlers(btnOpenSourceLoc);
         }
         else if (instance == btnOpenDestLoc)
         {
            addDestLocButtonEventHandlers(btnOpenDestLoc);
         }
         else if (instance == lblOwner)
         {
            lblOwner.text = getString("label.owner");
         }
         if (instance == btnOpenSourceLoc || instance == btnOpenDestLoc)
         {
            Button(instance).label = getString("label.location.open");
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
      
      
      private function addSourceLocButtonEventHandlers(button:Button) : void
      {
         button.addEventListener(MouseEvent.CLICK, btnOpenSourceLoc_clickHandler);
      }
      
      
      private function addDestLocButtonEventHandlers(button:Button) : void
      {
         button.addEventListener(MouseEvent.CLICK, btnOpenDestLoc_clickHandler);
      }
      
      
      private function unitsManagementButton_clickHandler(event:MouseEvent) : void
      {
         var unitIDs:Array = _squadron.units.toArray().map(
            function(unit:Unit, idx:int, array:Array) : int { return unit.id }
         );
         var units:ListCollectionView = Collections.filter(_squadron.units,
            function(unit:Unit) : Boolean { return unitIDs.indexOf(unit.id) >= 0 }
         );
         NavigationController.getInstance().showUnits(units, _squadron.currentHop.location.toLocation());
      }
      
      
      private function moveButton_clickHandler(event:MouseEvent) : void
      {
         OrdersController.getInstance().issueOrder(_squadron.units);
      }
      
      
      private function stopButton_clickHandler(event:MouseEvent) : void
      {
         new RoutesCommand(RoutesCommand.DESTROY, _squadron).dispatch();
      }
      
      
      private function btnOpenSourceLoc_clickHandler(event:MouseEvent) : void
      {
         _squadron.route.sourceLocation.show();
      }
      
      
      private function btnOpenDestLoc_clickHandler(event:MouseEvent) : void
      {
         _squadron.route.targetLocation.show();
      }
      
      
      /* ########################### */
      /* ### SELF EVENT HANDLERS ### */
      /* ########################### */
      
      
      private function addSelfEventHandlers() : void
      {
         addEventListener(MouseEvent.CLICK, this_mouseEventHandler);
         addEventListener(MouseEvent.MOUSE_MOVE, this_mouseEventHandler);
         addEventListener(MouseEvent.ROLL_OVER, this_rollOverEvent);
         addEventListener(MouseEvent.ROLL_OUT, this_rollOutEvent);
      }
      
      
      private function this_mouseEventHandler(event:MouseEvent) : void
      {
         event.stopImmediatePropagation();
      }
      
      
      private function this_rollOverEvent(event:MouseEvent) : void
      {
         underMouse = true;
      }
      
      
      private function this_rollOutEvent(event:MouseEvent) : void
      {
         if (event.target == this)
         {
            underMouse = false;
         }
      }
      
      
      /* ####################################### */
      /* ### ARRIVES IN TIMER EVENT HANDLERS ### */
      /* ####################################### */
      
      
      private function addArrivesInTimerEventHandlers() : void
      {
         ARRIVES_IN_TIMER.addEventListener(TimerEvent.TIMER, arrivesInTimer_timerHandler);
      }
      
      
      private function removeArrivesInTimerEventHandlers() : void
      {
         ARRIVES_IN_TIMER.removeEventListener(TimerEvent.TIMER, arrivesInTimer_timerHandler);
      }
      
      
      private function arrivesInTimer_timerHandler(event:TimerEvent) : void
      {
         updateArrivesInLabel();
      }
      
      
      /* ############### */
      /* ### HELPERS ### */
      /* ############### */
      
      
      private function getString(resourceName:String, parameters:Array = null) : String
      {
         return Localizer.string("Movement", resourceName, parameters);
      }
   }
}