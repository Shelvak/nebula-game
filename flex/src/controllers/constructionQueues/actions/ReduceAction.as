package controllers.constructionQueues.actions
{
   
   import controllers.CommunicationAction;
   
   import globalevents.GUnitEvent;
   
   
   public class ReduceAction extends CommunicationAction
   {
      public override function result():void
      {
         super.result();
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