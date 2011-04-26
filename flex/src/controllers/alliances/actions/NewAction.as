package controllers.alliances.actions
{
   import controllers.CommunicationAction;
   import controllers.CommunicationCommand;
   import controllers.GlobalFlags;
   import controllers.ui.NavigationController;
   
   import globalevents.GAllianceEvent;
   
   import mx.collections.ArrayCollection;
   import mx.collections.Sort;
   import mx.collections.SortField;
   
   import utils.remote.rmo.ClientRMO;
   
   /**
    * Gets ratings data. 
    */
   public class NewAction extends CommunicationAction
   {
      public override function result(rmo:ClientRMO):void
      {
         new GAllianceEvent(GAllianceEvent.ALLIANCE_CONFIRMED);
      }
      
      public override function cancel(rmo:ClientRMO):void
      {
         super.cancel(rmo);
         new GAllianceEvent(GAllianceEvent.ALLIANCE_CONFIRMED);
      }
      
      public override function applyServerAction(cmd:CommunicationCommand) : void
      {
         if (cmd.parameters.id == 0)
         {
            new GAllianceEvent(GAllianceEvent.ALLIANCE_FAILED);
         }
      }
   }
}