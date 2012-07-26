package controllers.units.actions
{
   import controllers.CommunicationAction;
   import controllers.CommunicationCommand;
   import utils.ApplicationLocker;
   import controllers.units.OrdersController;
   
   import models.location.LocationMinimal;
   
   import utils.DateUtil;
   import utils.remote.rmo.ClientRMO;
   import utils.remote.rmo.ServerRMO;


   /**
    * Calculate arrival date of selected space units.
    *
    * <p>
    * Client -->> Server: <code>MoveMetaActionParams</code>
    * </p>
    * 
    * <p>
    * Client <<-- Server:<br/>
    * <ul>
    *    <li><code>arrivalDate</code> - full date and time when units are expected to reach their
    *        destination</li>
    * </ul>
    * </p>
    * 
    * @see MoveMetaActionParams
    */
   public class MoveMetaAction extends CommunicationAction
   {
      private const ORDERS_CTRL: OrdersController = OrdersController.getInstance();


      public override function applyClientAction(cmd: CommunicationCommand): void {
         const params: MoveMetaActionParams = MoveMetaActionParams(cmd.parameters);
         const locSource: LocationMinimal = params.sourceLocation;
         const locTarget: LocationMinimal = params.targetLocation;
         
         sendMessage(new ClientRMO({
            "unitIds": params.unitIds,
            "source": {
               "locationId": locSource.id, "locationType": locSource.type,
               "locationX": locSource.x, "locationY": locSource.y
            },
            "target": {
               "locationId": locTarget.id, "locationType": locTarget.type,
               "locationX": locTarget.x, "locationY": locTarget.y
            },
            "avoidNpc": params.avoidNpc
         }));
      }

      public override function applyServerAction(cmd: CommunicationCommand): void {
         ORDERS_CTRL.showSpeedUpPopup(
            DateUtil.parseServerDTF(cmd.parameters["arrivalDate"]).time,
            cmd.parameters["hopCount"]
         );
      }

      public override function cancel(rmo: ClientRMO, srmo: ServerRMO): void {
         super.cancel(rmo, srmo);
         ORDERS_CTRL.cancelOrder();
      }
   }
}