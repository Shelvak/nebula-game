package controllers.constructionqueues.actions
{
   
   import controllers.CommunicationAction;
   
   import globalevents.GBuildingEvent;
   
   import mx.states.OverrideBase;
   
   import utils.remote.rmo.ClientRMO;
   import utils.remote.rmo.ServerRMO;


   public class MoveAction extends CommunicationAction
   {
      public override function result(rmo:ClientRMO) : void
      {
         super.result(rmo);
         new GBuildingEvent(GBuildingEvent.QUEUE_APROVED);
      }
      
      public override function cancel(rmo:ClientRMO, srmo: ServerRMO) : void
      {
         super.cancel(rmo, srmo);
         new GBuildingEvent(GBuildingEvent.QUEUE_APROVED);
      }
//      # Move ConstructionQueueEntry in queue.
//      #
//      # Params:
//      #   * id - id of ConstructionQueueEntry
//      #   * position - new element position.
//      #
//      # Response: None
//      # #
   }
}