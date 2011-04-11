package controllers.constructionqueues.actions
{
   
   import controllers.CommunicationAction;
   
   import globalevents.GBuildingEvent;
   
   import mx.states.OverrideBase;
   
   import utils.remote.rmo.ClientRMO;
   
   
   public class MoveAction extends CommunicationAction
   {
      public override function result(rmo:ClientRMO) : void
      {
         new GBuildingEvent(GBuildingEvent.QUEUE_APROVED);
      }
      
      public override function cancel(rmo:ClientRMO) : void
      {
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