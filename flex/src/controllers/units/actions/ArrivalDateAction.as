package controllers.units.actions
{
   import controllers.CommunicationAction;
   import controllers.CommunicationCommand;
   import controllers.units.OrdersController;
   
   import models.location.LocationMinimal;
   
   import utils.DateUtil;
   import utils.remote.rmo.ClientRMO;
   
   
   /**
    * Calculate arrival date of selected space units.
    *
    * <p>
    * Client -->> Server: <code>ArrivalDataActionParams</code>
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
    * @see ArrivalDateActionParams
    */
   public class ArrivalDateAction extends CommunicationAction
   {
      private function get ORDERS_CTRL() : OrdersController
      {
         return OrdersController.getInstance();
      }
      
      
      public function ArrivalDateAction()
      {
         super();
      }
      
      
      public override function applyClientAction(cmd:CommunicationCommand) : void
      {
         var params:ArrivalDateActionParams = ArrivalDateActionParams(cmd.parameters);
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
            "avoidNpc": params.avoidNpc
         }, params.squadron));
      }
      
      
      public override function applyServerAction(cmd:CommunicationCommand) : void
      {
         ORDERS_CTRL.showSpeedUpPopup(DateUtil.parseServerDTF(cmd.parameters.arrivalDate));
      }
      
      
      public override function cancel(rmo:ClientRMO) : void
      {
         ORDERS_CTRL.cancelOrder();
         super.cancel(rmo);
      }
   }
}