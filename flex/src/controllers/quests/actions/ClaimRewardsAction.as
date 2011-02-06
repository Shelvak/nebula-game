package controllers.quests.actions
{
   import controllers.CommunicationAction;
   import controllers.GlobalFlags;
   import controllers.Messenger;
   
   import globalevents.GQuestEvent;
   
   import utils.Localizer;
   import utils.remote.rmo.ClientRMO;
   
   
   public class ClaimRewardsAction extends CommunicationAction
   {
      public override function result(rmo:ClientRMO) : void
      {
         new GQuestEvent(GQuestEvent.CLAIM_APROVED);
         GlobalFlags.getInstance().lockApplication = false;
      }
      
      
      public override function cancel(rmo:ClientRMO):void
      {
         super.cancel(rmo);
         result(rmo);
      }
   }
}