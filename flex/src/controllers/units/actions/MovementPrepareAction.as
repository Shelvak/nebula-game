package controllers.units.actions
{
   import controllers.CommunicationAction;
   import controllers.CommunicationCommand;
   import controllers.units.SquadronsController;


   /**
    * Actually starts movement of units.
    *
    * <p>
    * If player is friendly, full route data and all route hops in the current location of units
    * being moved will be received. If not, route will only have id and current location and next
    * hop will also be provided.
    * </p>
    *
    * <p>
    * Client <<-- Server:</br>
    * <ul>
    *    <li><code>route</code> - route data as described above</li>
    *    <li><code>unitIds</code> - ids of units that are being moved</li>
    *    <li><code>routeHops</code> - route hops in units current location</li>
    * </ul>
    * </p>
    */
   public class MovementPrepareAction extends CommunicationAction
   {
      private var SQUADS_CTRL: SquadronsController = SquadronsController.getInstance();


      public override function applyServerAction(cmd: CommunicationCommand): void {
         const route: Object = cmd.parameters["route"];
         const unitIds: Array = cmd.parameters["unitIds"];
         route["hops"] = cmd.parameters["routeHops"];
         SQUADS_CTRL.startMovement(route, unitIds);
      }
   }
}