package controllers.units
{
   import animation.AnimationTimer;
   
   import com.developmentarc.core.utils.SingletonFactory;
   
   import components.movement.COrderPopup;
   
   import controllers.GlobalFlags;
   import controllers.ui.NavigationController;
   
   import ext.flex.mx.collections.ArrayCollection;
   
   import flash.errors.IllegalOperationError;
   
   import models.BaseModel;
   import models.ModelLocator;
   import models.location.Location;
   import models.location.LocationMinimal;
   import models.location.LocationType;
   import models.planet.Planet;
   import models.planet.PlanetClass;
   
   import mx.collections.ArrayCollection;
   
   import utils.ClassUtil;
   
   
   public class OrdersController
   {
      public static function getInstance() : OrdersController
      {
         return SingletonFactory.getSingletonInstance(OrdersController);
      }
      
      
      private static const GF:GlobalFlags = GlobalFlags.getInstance();
      private static const NAV_CTRL:NavigationController = NavigationController.getInstance();
      
      
      private var _units:ext.flex.mx.collections.ArrayCollection = null;
      private var _locSource:Location = null;
      private var _locTarget:LocationMinimal = null;
      
      
      /* ######################### */
      /* ### INTERFACE METHODS ### */
      /* ######################### */
      
      
      public function updateOrderPopup(location:LocationMinimal, popup:COrderPopup, staticObjectModel:BaseModel) : void
      {
         if (_locSource.isPlanet && location.isSolarSystem &&
             _locSource.x == location.x && _locSource.y == location.y)
         {
            popup.locationSpace = location;
            popup.locationPlanet = null;
         }
         else if (location.isSolarSystem && staticObjectModel is Planet &&
                  Planet(staticObjectModel).planetClass == PlanetClass.LANDABLE)
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
      public function issueOrder(units:mx.collections.ArrayCollection, location:Location) : void
      {
         ClassUtil.checkIfParamNotNull("units", units);
         ClassUtil.checkIfParamNotNull("location", location);
         if (units.length == 0)
         {
            throwNoUnitsError();
         }
         _units = new ext.flex.mx.collections.ArrayCollection(units.source);
         _locSource = location;
         GF.issuingOrders = true;
         AnimationTimer.forMovement.start();
         switch(location.type)
         {
            case LocationType.GALAXY:
               NAV_CTRL.toGalaxy();
               break;
            case LocationType.SOLAR_SYSTEM:
               NAV_CTRL.toSolarSystem(location.id);
               break;
            case LocationType.PLANET:
               NAV_CTRL.toSolarSystem(ModelLocator.getInstance().latestPlanet.solarSystemId);
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
         _locSource = null;
         _locTarget = null;
         GF.issuingOrders = false;
         AnimationTimer.forMovement.stop();
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