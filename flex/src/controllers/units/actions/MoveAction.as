package controllers.units.actions
{
   import controllers.CommunicationAction;
   import controllers.CommunicationCommand;
   import controllers.GlobalFlags;
   import controllers.units.OrdersController;
   
   import models.location.LocationMinimal;
   
   import utils.remote.rmo.ClientRMO;
   
   
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
      private var GF:GlobalFlags = GlobalFlags.getInstance();
      private var ORDERS_CTRL:OrdersController = OrdersController.getInstance();
      
      
      public function MoveAction()
      {
         super();
      }
      
      
      public override function applyClientAction(cmd:CommunicationCommand) : void
      {
         GF.lockApplication = true;
         var params:MoveActionParams = MoveActionParams(cmd.parameters);
         var locSource:LocationMinimal = params.sourceLocation;
         var locTarget:LocationMinimal = params.targetLocation;
         
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
      
      
      public override function cancel(rmo:ClientRMO) : void
      {
         super.cancel(rmo);
         ORDERS_CTRL.cancelOrder();
         GF.lockApplication = false;
      }
   }
}