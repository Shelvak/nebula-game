package controllers.units.actions
{
   import controllers.CommunicationAction;
   import controllers.CommunicationCommand;
   import utils.ApplicationLocker;
   import controllers.units.OrdersController;
   
   import models.location.LocationMinimal;
   
   import utils.remote.rmo.ClientRMO;
   import utils.remote.rmo.ServerRMO;


   /**
    * Order units to move to a new location. Response is received as <code>MOVEMENT_PREPARE</code>
    * action.
    * 
    * <p>
    * Client -->> Server: <code>MoveActionParams</code>
    * </p>
    */
   public class MoveAction extends CommunicationAction
   {
      private const ORDERS_CTRL: OrdersController = OrdersController.getInstance();
      

      public override function applyClientAction(cmd: CommunicationCommand): void {
         const params: MoveActionParams = MoveActionParams(cmd.parameters);
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
            "avoidNpc": params.avoidNpc,
            "speedModifier": params.speedModifier
         }, params.squadron));
      }

      public override function cancel(rmo: ClientRMO, srmo: ServerRMO): void {
         super.cancel(rmo, srmo);
         ORDERS_CTRL.cancelOrder();
      }
   }
}