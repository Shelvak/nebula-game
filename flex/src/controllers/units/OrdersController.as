package controllers.units
{
   import com.developmentarc.core.utils.SingletonFactory;
   
   import components.movement.COrderPopup;
   
   import controllers.ui.NavigationController;
   import controllers.units.events.OrdersControllerEvent;
   
   import flash.errors.IllegalOperationError;
   import flash.events.EventDispatcher;
   
   import models.BaseModel;
   import models.ModelLocator;
   import models.location.LocationMinimal;
   import models.location.LocationType;
   import models.map.MapType;
   import models.solarsystem.SSObject;
   import models.unit.Unit;
   
   import mx.collections.ArrayCollection;
   import mx.collections.IList;
   import mx.collections.ListCollectionView;
   import mx.events.CollectionEvent;
   import mx.events.CollectionEventKind;
   import mx.events.PropertyChangeEvent;
   
   import utils.ClassUtil;
   import utils.datastructures.Collections;
   
   
   /**
    * Dispatched when <code>issuingOrders</code> property changes.
    * 
    * @eventType controllers.units.events.OrdersControllerEvent.ISSUING_ORDERS_CHANGE
    */
   [Event(name="issuingOrdersChange", type="controllers.units.events.OrdersControllerEvent")]
   
   
   /**
    * Dispatched when <code>issuingOrders</code> property changes.
    * 
    * @eventType controllers.units.events.OrdersControllerEvent.LOCATION_SOURCE_CHANGE
    */
   [Event(name="locationSourceChange", type="controllers.units.events.OrdersControllerEvent")]
   
   
   public class OrdersController extends EventDispatcher
   {
      public static function getInstance() : OrdersController
      {
         return SingletonFactory.getSingletonInstance(OrdersController);
      }
      
      
      private var NAV_CTRL:NavigationController = NavigationController.getInstance();
      private var ML:ModelLocator = ModelLocator.getInstance();
      
      
      private var _issuingOrders:Boolean = false;
      [Bindable(event="issuingOrdersChange")]
      /**
       * Indicates if user is in the process of giving orders to some units.
       */
      public function set issuingOrders(value:Boolean) : void
      {
         if (_issuingOrders != value)
         {
            _issuingOrders = value;
            if (hasEventListener(OrdersControllerEvent.ISSUING_ORDERS_CHANGE))
            {
               dispatchEvent(new OrdersControllerEvent(OrdersControllerEvent.ISSUING_ORDERS_CHANGE));
            }
         }
      }
      /**
       * @private
       */
      public function get issuingOrders() : Boolean
      {
         return _issuingOrders;
      }
      
      
      [Bindable(event="locationSourceChange")]
      public var locationSourceSolarSystem:LocationMinimal;
      
      
      [Bindable(event="locationSourceChange")]
      public var locationSourceGalaxy:LocationMinimal;
      
      
      [Bindable(event="locationSourceChange")]
      public var locationSource:LocationMinimal;
      
      
      private function setSourceLocations() : void
      {
         if (!units)
         {
            locationSource = locationSourceGalaxy = locationSourceSolarSystem = null;
         }
         else
         {
            locationSource = Unit(units.getItemAt(0)).location;
            switch (ML.activeMapType)
            {
               case MapType.GALAXY:
                  locationSourceGalaxy = locationSource;
                  break;
               case MapType.SOLAR_SYSTEM:
                  locationSourceGalaxy = ML.latestSolarSystem.currentLocation;
                  if (locationSource.isSSObject)
                  {
                     locationSourceSolarSystem = ML.latestPlanet.currentLocation;
                  }
                  else
                  {
                     locationSourceSolarSystem = locationSource;
                  }
                  break;
               case MapType.PLANET:
                  locationSourceGalaxy = ML.latestSolarSystem.currentLocation;
                  locationSourceSolarSystem = ML.latestPlanet.currentLocation;
                  break;
            }
         }
         if (hasEventListener(OrdersControllerEvent.LOCATION_SOURCE_CHANGE))
         {
            dispatchEvent(new OrdersControllerEvent(OrdersControllerEvent.LOCATION_SOURCE_CHANGE));
         }
      }
      
      
      public var units:ListCollectionView = null;
      private var _unitsCopy:ArrayCollection = null;
      private var _locTarget:LocationMinimal = null;
      
      
      /* ######################### */
      /* ### INTERFACE METHODS ### */
      /* ######################### */
      
      
      public function updateOrderPopup(location:LocationMinimal, popup:COrderPopup, staticObjectModel:BaseModel) : void
      {
         if (locationSource.isSSObject && location.isSolarSystem && ML.latestPlanet &&
             location.equals(ML.latestPlanet.currentLocation))
         {
            popup.locationSpace = location;
            popup.locationPlanet = null;
         }
         else if (location.isSolarSystem && staticObjectModel is SSObject &&
                  SSObject(staticObjectModel).isPlanet)
         {
            if (location.equals(locationSource))
            {
               popup.locationSpace = null;
            }
            else
            {
               popup.locationSpace = location;
            }
            popup.locationPlanet = SSObject(staticObjectModel).toLocation();
         }
         else if (location.equals(locationSource))
         {
            popup.locationSpace = null;
            popup.locationPlanet = null;
         }
         else
         {
            popup.locationSpace = location;
            popup.locationPlanet = null;
         }
      }
      
      
      /**
       * Initiates process of giving order to units. This is the second step of this process: method
       * must be called after user has selected units he wants to give orders to.
       * 
       * @param units List of units you want to give order to
       * @param location current location of given units
       */
      public function issueOrder(units:IList) : void
      {
         ClassUtil.checkIfParamNotNull("units", units);
         if (units.length == 0)
         {
            throwNoUnitsError();
         }
         
         var unitIds:Array = units.toArray().map(
            function(unit:Unit, idx:int, array:Array) : int { return unit.id }
         );
         this.units = Collections.filter(ML.units,
            function(unit:Unit) : Boolean { return unitIds.indexOf(unit.id) >= 0 }
         );
         _unitsCopy = new ArrayCollection();
         _unitsCopy.addAll(units);
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
               NAV_CTRL.toSolarSystem(ML.latestPlanet.solarSystemId);
               break;
         }
      }
      
      
      /**
       * Commits the order: sends message to the server with all required data. Then restores
       * client to its state before the order issuing process. This is the third and last step of
       * the process.
       * 
       * @param location destination of the order: location to which units must be moved
       */
      public function commitOrder(location:LocationMinimal) : void
      {
         _locTarget = location;
         new UnitsCommand(UnitsCommand.MOVE, {
            "units": _unitsCopy,
            "source": locationSource,
            "target": _locTarget
         }).dispatch();
      }
      
      
      /**
       * Cancels current order: restores client to its state before the order issuing process
       * without sending server any messages. This is the third and last step of the process.
       */
      public function cancelOrder() : void
      {
         orderComplete();
      }
      
      
      /**
       * Cancels current order if this order involves (controller holds a reference to) at least one unit in
       * the given list. Use this when units have been destroyed and you need to cancel order issuing process.
       */
      public function cancelOrderIfInvolves(units:IList) : void
      {
         if (!issuingOrders)
         {
            return;
         }
         for each (var unit:Unit in _unitsCopy)
         {
            if (Collections.findFirstEqualTo(units, unit) != null)
            {
               cancelOrder();
               return;
            }
         }
      }
      
      
      /**
       * Called by <code>controllers.units.actions.MoveAction</code> when response is received from
       * the server.
       */
      public function orderComplete() : void
      {
         if (issuingOrders)
         {
            issuingOrders = false;
            _locTarget = null;
            units.list = null;
            units.filterFunction = null;
            units = null;
            _unitsCopy = null;
            setSourceLocations();
         }
      }
      
      
      /* ################################# */
      /* ### UNITS LIST EVENT HANDLERS ### */
      /* ################################# */
      
      
      private function addUnitsListEventHandlers(units:ListCollectionView) : void
      {
         units.addEventListener(CollectionEvent.COLLECTION_CHANGE, units_collectionChangeHandler);
      }
      
      
      private function units_collectionChangeHandler(event:CollectionEvent) : void
      {
         if (event.kind == CollectionEventKind.UPDATE)
         {
            for each (var propChangeEvent:PropertyChangeEvent in event.items)
            {
               if (propChangeEvent.property == "location")
               {
                  setSourceLocations();
               }
            }
         }
      }
      
      
      /* ############### */
      /* ### HELPERS ### */
      /* ############### */
      
      
      /**
       * @throws IllegalOperationError
       */
      private function throwNoUnitsError() : void
      {
         throw new IllegalOperationError("There must be at least one unit in the list if you want to issue an order");
      }
   }
}