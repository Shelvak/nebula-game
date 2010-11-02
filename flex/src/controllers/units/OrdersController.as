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
   import models.movement.MSquadron;
   import models.planet.Planet;
   import models.solarsystem.SSObject;
   
   import mx.collections.ArrayCollection;
   
   import utils.ClassUtil;
   
   
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
      
      
      private var _locSource:LocationMinimal = null;
      [Bindable(event="locationSourceChange")]
      public function set locationSource(value:LocationMinimal) : void
      {
         if (_locSource != value)
         {
            _locSource = value;
            if (hasEventListener(OrdersControllerEvent.LOCATION_SOURCE_CHANGE))
            {
               dispatchEvent(new OrdersControllerEvent(OrdersControllerEvent.LOCATION_SOURCE_CHANGE));
            }
         }
      }
      public function get locationSource() : LocationMinimal
      {
         return _locSource;
      }
      
      
      private var _units:ArrayCollection = null;
      private var _locTarget:LocationMinimal = null;
      
      
      /* ######################### */
      /* ### INTERFACE METHODS ### */
      /* ######################### */
      
      
      public function updateOrderPopup(location:LocationMinimal, popup:COrderPopup, staticObjectModel:BaseModel) : void
      {
         if (_locSource.isSSObject && location.isSolarSystem &&
             _locSource.x == location.x && _locSource.y == location.y)
         {
            popup.locationSpace = location;
            popup.locationPlanet = null;
         }
         else if (location.isSolarSystem && staticObjectModel is SSObject &&
                  SSObject(staticObjectModel).isPlanet)
         {
            if (location.equals(_locSource))
            {
               popup.locationSpace = null;
            }
            else
            {
               popup.locationSpace = location;
            }
            popup.locationPlanet = Planet(staticObjectModel).toLocation();
         }
         else if (location.equals(_locSource))
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
      public function issueOrder(units:ArrayCollection, location:LocationMinimal) : void
      {
         ClassUtil.checkIfParamNotNull("units", units);
         ClassUtil.checkIfParamNotNull("location", location);
         if (units.length == 0)
         {
            throwNoUnitsError();
         }
         _units = units;
         switch (ML.activeMapType)
         {
            case MapType.GALAXY:
               locationSourceGalaxy = location;
               break;
            case MapType.SOLAR_SYSTEM:
               locationSourceGalaxy = ML.latestSolarSystem.currentLocation;
               locationSourceSolarSystem = location;
               break;
            case MapType.PLANET:
               locationSourceGalaxy = ML.latestSolarSystem.currentLocation;
               locationSourceSolarSystem = ML.latestPlanet.currentLocation;
               break;
         }
         locationSource = location;
         issuingOrders = true;
         switch(location.type)
         {
            case LocationType.GALAXY:
               NAV_CTRL.toGalaxy();
               break;
            case LocationType.SOLAR_SYSTEM:
               NAV_CTRL.toSolarSystem(location.id);
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
            "units": _units,
            "source": _locSource,
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
       * Called by <code>controllers.units.actions.MoveAction</code> when response is received from
       * the server.
       */
      public function orderComplete() : void
      {
         _units = null;
         _locTarget = null;
         locationSourceGalaxy = null;
         locationSourceSolarSystem = null;
         locationSource = null;
         issuingOrders = false;
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