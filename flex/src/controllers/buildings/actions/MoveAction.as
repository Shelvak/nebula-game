package controllers.buildings.actions
{
   import controllers.CommunicationAction;
   import controllers.CommunicationCommand;
   
   import globalevents.GBuildingEvent;
   
   import utils.remote.rmo.ClientRMO;
   
   
   /**
    * Moves building to another spot in the planet. Requires credits.
    * 
    * <p>
    * Client -->> Server: <code>MoveActionParams</code>
    * </p>
    * 
    * @see MoveActionParams
    * @see MoveActionParams#MoveActionParams()
    */
   public class MoveAction extends CommunicationAction
   {
      public function MoveAction()
      {
         super();
      }
      
      
      override public function applyClientAction(cmd:CommunicationCommand):void
      {
         var params:MoveActionParams = MoveActionParams(cmd.parameters);
         sendMessage(
            new ClientRMO(
               {"id": params.building.id,
                "x":  params.newX,
                "y":  params.newY},
               params.building,
               params
            )
         );
      }
      
      
      override public function cancel(rmo:ClientRMO) : void
      {
         super.cancel(rmo);
         var params:MoveActionParams = MoveActionParams(rmo.additionalParams);
         new GBuildingEvent(GBuildingEvent.MOVE_CANCEL, params.building);
      }
      
      
      override public function result(rmo:ClientRMO) : void
      {
         super.result(rmo);
         var params:MoveActionParams = MoveActionParams(rmo.additionalParams);
         new GBuildingEvent(GBuildingEvent.MOVE_CONFIRM, params.building);
      }
   }
}