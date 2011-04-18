package controllers.buildings.actions
{
   import controllers.CommunicationAction;
   import controllers.CommunicationCommand;
   import controllers.GlobalFlags;
   
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
    */
   public class MoveAction extends CommunicationAction
   {
      private function get GF() : GlobalFlags
      {
         return GlobalFlags.getInstance();
      }
      
      
      public function MoveAction()
      {
         super();
      }
      
      
      override public function applyClientAction(cmd:CommunicationCommand):void
      {
         GF.lockApplication = true;
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
         GF.lockApplication = false;
      }
      
      
      override public function result(rmo:ClientRMO) : void
      {
         super.result(rmo);
         var params:MoveActionParams = MoveActionParams(rmo.additionalParams);
         new GBuildingEvent(GBuildingEvent.MOVE_CONFIRM, params.building);
         GF.lockApplication = false;
      }
   }
}