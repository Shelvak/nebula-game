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
         // server bug workaround: current location is present in the hops list so just remove it for now
         cmd.parameters.routeHops.shift();
         cmd.parameters.route.hops = cmd.parameters.routeHops;
         _squadsController.startMovement(cmd.parameters.route, cmd.parameters.unitIds);
         var GF:GlobalFlags = GlobalFlags.getInstance();
         if (GF.issuingOrders)
         {
            OrdersController.getInstance().orderComplete();
            GF.lockApplication = false;
         }
      }
   }
}