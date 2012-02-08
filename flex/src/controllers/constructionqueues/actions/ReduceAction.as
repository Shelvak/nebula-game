package controllers.constructionqueues.actions
{
   
   import controllers.CommunicationAction;
   
   import globalevents.GUnitEvent;
   
   import mx.states.OverrideBase;
   
   import utils.remote.rmo.ClientRMO;
   import utils.remote.rmo.ServerRMO;


   public class ReduceAction extends CommunicationAction
   {
      public override function result(rmo:ClientRMO) : void
      {
         super.result(rmo);
         new GUnitEvent(GUnitEvent.DELETE_APPROVED);
      }
      
      public override function cancel(rmo:ClientRMO, srmo: ServerRMO):void
      {
         super.cancel(rmo, srmo);
         new GUnitEvent(GUnitEvent.DELETE_APPROVED);
      }
//      # Reduce count from ConstructionQueueEntry.
//      #
//      # Params:
//      #   * id - id of ConstructionQueueEntry
//      #   * count - count to reduce
//      #
//      # Response: None
//      # #
   }
}