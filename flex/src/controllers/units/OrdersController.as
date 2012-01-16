package controllers.units
{
   import com.developmentarc.core.utils.EventBroker;

   import components.movement.CTargetLocationPopup;

   import controllers.ui.NavigationController;
   import controllers.units.actions.MoveActionParams;
   import controllers.units.actions.MoveMetaActionParams;
   import controllers.units.events.OrdersControllerEvent;

   import flash.errors.IllegalOperationError;
   import flash.events.EventDispatcher;
   import flash.events.KeyboardEvent;
   import flash.ui.Keyboard;

   import globalevents.GlobalEvent;

   import models.ModelLocator;
   import models.events.BaseModelEvent;
   import models.location.LocationMinimal;
   import models.location.LocationType;
   import models.map.IMStaticSpaceObject;
   import models.map.MapType;
   import models.movement.MSquadron;
   import models.solarsystem.MSSObject;
   import models.unit.Unit;

   import mx.collections.IList;
   import mx.collections.ListCollectionView;
   import mx.events.CollectionEvent;
   import mx.events.CollectionEventKind;
   import mx.events.PropertyChangeEvent;

   import namespaces.prop_name;

   import utils.Events;
   import utils.Objects;
   import utils.SingletonFactory;
   import utils.datastructures.Collections;


   /**
    * @see controllers.units.events.OrdersControllerEvent#ISSUING_ORDERS_CHANGE
    */
   [Event(name="issuingOrdersChange", type="controllers.units.events.OrdersControllerEvent")]
   
   
   /**
    * @see controllers.units.events.OrdersControllerEvent#LOCATION_SOURCE_CHANGE
    */
   [Event(name="locationSourceChange", type="controllers.units.events.OrdersControllerEvent")]
   
   
   /**
    * @see controllers.units.events.OrdersControllerEvent#UICMD_ACTIVATE_SPEED_UP_POPUP
    */
   [Event(name="uicmdActivateSpeedUpPopup", type="controllers.units.events.OrdersControllerEvent")]
   
   
   public class OrdersController extends EventDispatcher
   {
      public static function getInstance() : OrdersController {
         return SingletonFactory.getSingletonInstance(OrdersController);
      }
      
      
      private function get NAV_CTRL() : NavigationController {
         return NavigationController.getInstance();
      }
      
      private function get ML() : ModelLocator {
         return ModelLocator.getInstance();
      }
      
      
      public function OrdersController() {
         super();
         EventBroker.subscribe(KeyboardEvent.KEY_UP, stage_keyUpHandler);
         EventBroker.subscribe(GlobalEvent.APP_RESET, global_appResetHandler);
      }
      
      
      prop_name static const flag_disableOrderPopup:String = "flag_disableOrderPopup";
      [Bindable]
      /**
       * Indicates if order popup should be disabled in all maps.
       */
      public var flag_disableOrderPopup:Boolean = false;
      
      
      private function global_appResetHandler(event:GlobalEvent) : void
      {
         _issuingOrders = false;
         locationSource = null;
         locationSourceGalaxy = null;
         locationSourceSolarSystem = null;
         if (units)
         {
            removeUnitsListEventHandlers(units);
            units.list = null;
            units.filterFunction = null;
            units = null;
         }
         _unitIds = null;
         _locTarget = null;
      }
      
      
      private var _issuingOrders:Boolean = false;
      [Bindable(event="issuingOrdersChange")]
      /**
       * Indicates if user is in the process of giving orders to some units.
       */
      public function set issuingOrders(value:Boolean) : void {
         if (_issuingOrders != value) {
            _issuingOrders = value;
            dispatchOrderCtrlEvent(OrdersControllerEvent.ISSUING_ORDERS_CHANGE);
         }
      }
      /**
       * @private
       */
      public function get issuingOrders() : Boolean {
         return _issuingOrders;
      }
      
      
      [Bindable(event="locationSourceChange")]
      public var locationSourceSolarSystem:LocationMinimal;
      
      [Bindable(event="locationSourceChange")]
      public var locationSourceGalaxy:LocationMinimal;
      
      [Bindable(event="locationSourceChange")]
      public var locationSource:LocationMinimal;
      
      private function setSourceLocations() : void {
         if (units == null)
            locationSource = locationSourceGalaxy = locationSourceSolarSystem = null;
         else {
            locationSource = Unit(units.getItemAt(0)).location;
            switch (ML.activeMapType)
            {
               case MapType.GALAXY:
                  locationSourceGalaxy = locationSource;
                  break;
               
               case MapType.SOLAR_SYSTEM:
                  if (!ML.latestSSMap.solarSystem.isBattleground)
                     locationSourceGalaxy = ML.latestSSMap.currentLocation;
                  else
                     locationSourceGalaxy = null;
                  
                  if (locationSource.isSSObject)
                     locationSourceSolarSystem = ML.latestPlanet.currentLocation;
                  else
                     locationSourceSolarSystem = locationSource;
                  break;
               
               case MapType.PLANET:
                  if (!ML.latestPlanet.inBattleground)
                     locationSourceGalaxy = ML.latestSSMap.currentLocation;
                  else
                     locationSourceGalaxy = null;
                  locationSourceSolarSystem = ML.latestPlanet.currentLocation;
                  break;
            }
         }
         dispatchOrderCtrlEvent(OrdersControllerEvent.LOCATION_SOURCE_CHANGE); 
      }
      
      
      public var units:ListCollectionView = null;
      private var _unitIds:Array = null;
      private var _locTarget:LocationMinimal = null;
      private var _squad:MSquadron = null;
      
      
      /* ######################### */
      /* ### INTERFACE METHODS ### */
      /* ######################### */
      
      public function updateTargetLocationPopup(location:LocationMinimal,
                                                popup:CTargetLocationPopup,
                                                staticObjectModel:IMStaticSpaceObject) : void {
         if (locationSource.isSSObject && location.isSolarSystem && staticObjectModel is MSSObject &&
             location.equals(MSSObject(staticObjectModel).currentLocation) &&
             locationSource.equals(MSSObject(staticObjectModel).toLocation())) {
            popup.locationSpace = location;
            popup.locationPlanet = null;
         }
         else if (location.isSolarSystem && staticObjectModel is MSSObject &&
                  MSSObject(staticObjectModel).isPlanet) {
            if (location.equals(locationSource))
               popup.locationSpace = null;
            else
               popup.locationSpace = location;
            popup.locationPlanet = MSSObject(staticObjectModel).toLocation();
         }
         else if (location.equals(locationSource)) {
            popup.locationSpace = null;
            popup.locationPlanet = null;
         }
         else {
            popup.locationSpace = location;
            popup.locationPlanet = null;
         }
      }
      
      
      /* ################## */
      /* ### FIRST STEP ### */
      /* ################## */
      
      /**
       * Initiates process of giving order to units. This is the firsts step of this process: method
       * must be called after user has selected units he wants to give orders to.
       * 
       * @param units List of units you want to give order to
       * @param squad pass the suqadron model if units to be moved are already moving
       */
      public function issueOrder(units:IList, squad:MSquadron = null) : void {
         Objects.paramNotNull("units", units);
         if (units.length == 0)
            throw new IllegalOperationError(
               "There must be at least one unit in the list if you want to issue an order"
            );
         if (squad != null) {
            _squad = squad;
            _squad.addEventListener(BaseModelEvent.PENDING_CHANGE, squad_pendingChangeHandler);
            squad_pendingChangeHandler();
         }
         
         _unitIds = units.toArray().map(
            function(unit:Unit, idx:int, array:Array) : int { return unit.id }
         );
         this.units = Collections.filter(ML.units,
            function(unit:Unit) : Boolean { return _unitIds != null ? _unitIds.indexOf(unit.id) >= 0 : false }
         );
         addUnitsListEventHandlers(this.units);
         setSourceLocations();
         issuingOrders = true;
         switch(locationSource.type)
         {
            case LocationType.GALAXY:
               NAV_CTRL.toGalaxy();
               break;
            case LocationType.SOLAR_SYSTEM:
               NAV_CTRL.toSolarSystem(locationSource.id);
               break;
            case LocationType.SS_OBJECT:
               NAV_CTRL.toSolarSystem(
                  ML.latestPlanet.solarSystemId,
                  function() : void {
                     ML.latestSSMap.moveToLocation(ML.latestPlanet.currentLocation);
                  }
               );
               break;
         }
      }
      
      
      /* ################### */
      /* ### SECOND STEP ### */
      /* ################### */
      
      private var _avoidNpc:Boolean = true;
      
      /**
       * Selects given location as destination. Then asks server to calculate trip time and lets user to
       * speed up or slow down the squad. This is the third step of squad order initiation process.
       * 
       * @param location destination of the order: location to which units will be moved
       * @param avoidNpc should the fleet avoid NPC units while travelling
       */
      public function commitTargetLocation(location:LocationMinimal, avoidNpc:Boolean) : void {
         _avoidNpc = avoidNpc;
         _locTarget = Objects.paramNotNull("location", location);
         new UnitsCommand(UnitsCommand.MOVE_META, new MoveMetaActionParams(
            _unitIds,
            locationSource,
            _locTarget,
            _avoidNpc
         )).dispatch();
      }
      
      /**
       * Called by <code>controllers.units.MoveAction</code> when server has
       * sent us trip time back. Now user can choose to speed up or slow down
       * the units.
       * 
       * @param arrivalTime when units would reach their destination if they
       * are dispatched right away.
       */
      public function showSpeedUpPopup(arrivalTime:Number, hopCount: int) : void {
         if (hasEventListener(OrdersControllerEvent.UICMD_ACTIVATE_SPEED_UP_POPUP)) {
            var event:OrdersControllerEvent = new OrdersControllerEvent(
               OrdersControllerEvent.UICMD_ACTIVATE_SPEED_UP_POPUP,
               hopCount
            );
            event.arrivalTime = arrivalTime;
            dispatchEvent(event);
         }
      }
      
      /**
       * Called by <code>CSpeedControlPopupM</code> if user cancels speed up and wishes to change target
       * location. This takes us back to the first step.
       */
      public function cancelTargetLocation() : void {
         _locTarget = null;
      }
      
      
      /* ################# */
      /* ### LAST STEP ### */
      /* ################# */
      
      /**
       * Commits order: sends <code>UnitsCommand.MOVE</code> to the server. This is the last step in
       * order initiation process. Called by <code>CSpeedControlPopupM</code>.
       * 
       * @param speedModifier speed modifier to use for speeding up or slowing down the squad.
       */
      public function commitOrder(speedModifier:Number) : void {
         new UnitsCommand(UnitsCommand.MOVE, new MoveActionParams(
            _unitIds,
            locationSource,
            _locTarget,
            _avoidNpc,
            speedModifier,
            _squad
         )).dispatch();
      }
      
      
      /* ########################## */
      /* ### ORDER CANCELLATION ### */
      /* ########################## */
      
      /**
       * Cancels current order: restores client to its state before the order issuing process
       * without sending server any messages. This is the fourth and last step of the process.
       */
      public function cancelOrder() : void {
         orderComplete();
      }
      
      /**
       * Cancels current order if this order involves (controller holds a reference to) at least one unit in
       * the given list. Use this when units have been destroyed and you need to cancel order issuing process.
       */
      public function cancelOrderIfInvolves(units:IList) : void {
         if (!issuingOrders)
            return;
         for each (var unit:Unit in units.toArray()) {
            if (_unitIds.indexOf(unit.id) >= 0) {
               cancelOrder();
               return;
            }
         }
      }
      
      
      /* ######################## */
      /* ### ORDER COMPLETION ### */
      /* ######################## */
      
      /**
       * Called by <code>controllers.units.actions.MoveAction</code> when response is received from
       * the server.
       */
      public function orderComplete() : void {
         if (issuingOrders) {
            issuingOrders = false;
            _locTarget = null;
            removeUnitsListEventHandlers(units);
            units.list = null;
            units.filterFunction = null;
            units = null;
            _unitIds = null;
            if (_squad != null) {
               _squad.removeEventListener(BaseModelEvent.PENDING_CHANGE, squad_pendingChangeHandler);
               _squad = null;
               squad_pendingChangeHandler();
            }
            setSourceLocations();
         }
      }
      
      
      /* ############################ */
      /* ### STAGE EVENT HANDLERS ### */
      /* ############################ */
      
      private function stage_keyUpHandler(event:KeyboardEvent) : void {
         if (!event.isDefaultPrevented() && event.keyCode == Keyboard.ESCAPE) {
            cancelOrder();
         }
      }
      
      
      /* ################################ */
      /* ### MSQUADRON EVENT HANDLERS ### */
      /* ################################ */
      
      private function squad_pendingChangeHandler(event:BaseModelEvent = null) : void {
         flag_disableOrderPopup = _squad != null && _squad.pending;
      }
      
      
      /* ################################# */
      /* ### UNITS LIST EVENT HANDLERS ### */
      /* ################################# */
      
      private function addUnitsListEventHandlers(units:ListCollectionView) : void {
         units.addEventListener(
            CollectionEvent.COLLECTION_CHANGE,
            units_collectionChangeHandler, false, 0, true
         );
      }
      
      private function removeUnitsListEventHandlers(units:ListCollectionView) : void {
         units.removeEventListener(
            CollectionEvent.COLLECTION_CHANGE, units_collectionChangeHandler,
            false
         );
      }
      
      private function units_collectionChangeHandler(event:CollectionEvent) : void {
         if (event.kind == CollectionEventKind.UPDATE) {
            for each (var propChangeEvent:PropertyChangeEvent in event.items) {
               if (propChangeEvent.property == "location") {
                  setSourceLocations();
               }
            }
         }
      }
      
      
      /* ############### */
      /* ### HELPERS ### */
      /* ############### */
      
      private function dispatchOrderCtrlEvent(type:String) : void {
         Events.dispatchSimpleEvent(this, OrdersControllerEvent, type);
      }
   }
}