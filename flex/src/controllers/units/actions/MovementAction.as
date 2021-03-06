package controllers.units.actions
{
   import controllers.CommunicationAction;
   import controllers.CommunicationCommand;
   import controllers.startup.StartupInfo;
   import controllers.units.SquadronsController;
   
   import models.factories.UnitFactory;
   import models.movement.MHop;
   
   import mx.collections.ArrayCollection;
   
   import utils.Objects;
   import utils.logging.Log;


   /**
    * Updates moving squadron
    * 
    * <p>
    * Server will send:
    * <ul>
    *    <li>next route hop for ENEMY and NAP squadrons if they moved in the same map</li>
    *    <li>list of any units that have entered players visible area along with next hop</li>
    *    <li>list of units belonging to any player if those units have made a jump between two maps
    *        along with route hops in a new map</li>
    * </ul>
    * </p>
    * 
    * <p>
    * Client <<-- Server:</br>
    * <ul>
    *    <li><code>units</code> - units wrapped with their statuses</li>
    *    <li><code>routeHops</code> - hops of those units route</li>
    * </ul>
    * </p>
    */
   public class MovementAction extends CommunicationAction
   {
      private var SQUADS_CTRL:SquadronsController = SquadronsController.getInstance();


      public override function applyServerAction(cmd: CommunicationCommand): void {
         if (!StartupInfo.getInstance().initializationComplete) {
            Log.getMethodLogger(this, "applyServerAction")
               .warn("Message received before application had been initialized. Ignoring.");
            return;
         }
         const params: Object = cmd.parameters;
         const units: Array = params["units"];
         const players: Object = params["players"];
         const routeHops: Array = params["routeHops"];
         const jumpsAt: String = params["jumpsAt"];
         // we have received next hop for hostile squad
         if (units.length == 0) {
            SQUADS_CTRL.addHopToSquadron(Objects.create(MHop, routeHops[0]));
         }
         // friendly squadron made a jump between maps or a squadron jumped into players visible area
         else {
            SQUADS_CTRL.executeJump(
               UnitFactory.fromObjects(units, players),
               Objects.fillCollection(new ArrayCollection(), MHop, routeHops),
               jumpsAt
            );
         }
      }
   }
}