package controllers.units.actions
{
   import com.developmentarc.core.utils.EventBroker;
   
   import controllers.CommunicationAction;
   import controllers.CommunicationCommand;
   import controllers.GlobalFlags;
   import controllers.units.OrdersController;
   import controllers.units.SquadronsController;
   
   import ext.flex.mx.collections.ArrayCollection;
   import ext.flex.mx.collections.IList;
   
   import globalevents.GUnitEvent;
   
   import models.BaseModel;
   import models.ModelsCollection;
   import models.Owner;
   import models.factories.SquadronFactory;
   import models.location.Location;
   import models.location.LocationMinimal;
   import models.movement.MHop;
   import models.movement.MSquadron;
   import models.unit.Unit;
   
   
   /**
    * Actually starts movement of units.
    * 
    * <p>
    * If player is friendly, full route data and all route hops in the current location of units
    * beeing moved will be received. If not, route will only have id and current location and next
    * hop will also be provided.
    * </p>
    * 
    * <p>
    * Client <<-- Server:</br>
    * <ul>
    *    <li><code>route</code> - route data as described above</li>
    *    <li><code>unitIds</code> - ids of units that are beeing moved</li>
    *    <li><code>routeHops</code> - route hops in units current location</li>
    * </ul>
    * </p>
    */
   public class MovementPrepareAction extends CommunicationAction
   {
      private var _squadsController:SquadronsController = SquadronsController.getInstance();
      
      
      public function MovementPrepareAction()
      {
         super();
      }
      
      
      public override function applyServerAction(cmd:CommunicationCommand) : void
      {
         var params:Object = cmd.parameters;
         var route:Object = params.route;
         route.hops = params.routeHops;
         
         var units:ModelsCollection = new ModelsCollection();
         var squad:MSquadron = null;
         var unitIds:ArrayCollection = new ArrayCollection(params.unitIds);
         var currentLocation:Location = BaseModel.createModel(Location, params.route.current);
         
         function findUnitsWithIdsIn(units:ModelsCollection) : ModelsCollection
         {
            return units.filterItems(
               function(unit:Unit) : Boolean
               {
                  return unitIds.contains(unit.id);
               }
            );
         };
         
         if (currentLocation.isPlanet)
         {
            if (ML.latestPlanet && !ML.latestPlanet.fake)
            {
               units = findUnitsWithIdsIn(ML.latestPlanet.units);
            }
         }
         else
         {
            for each (squad in ML.squadrons)
            {
               units = findUnitsWithIdsIn(squad.units);
               if (!units.isEmpty)
               {
                  break;
               }
            }
         }
         
         if (!units.isEmpty)
         {
            for each (var unit:Unit in units)
            {
               unit.squadronId = route.id;
               unit.location = currentLocation;
            }
            _squadsController.createSquadron(
               units, BaseModel.createCollection(ModelsCollection, MHop, params.routeHops),
               BaseModel.createModel(Location, params.route.source),
               BaseModel.createModel(Location, params.route.target)
            );
         }
         // ALLY or PLAYER units are starting to move but we don't have that map open
         else if (route.target !== undefined)
         {
            _squadsController.createFriendlySquadron(route);
         }
         
         var GF:GlobalFlags = GlobalFlags.getInstance();
         if (GF.issuingOrders)
         {
            OrdersController.getInstance().orderComplete();
            GF.lockApplication = false;
         }
      }
   }
}