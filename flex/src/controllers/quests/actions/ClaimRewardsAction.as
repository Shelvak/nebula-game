package controllers.quests.actions
{
   import controllers.CommunicationAction;
   import controllers.GlobalFlags;
   
   import globalevents.GQuestEvent;
   
   import utils.remote.rmo.ClientRMO;
   
   
   public class ClaimRewardsAction extends CommunicationAction
   {
      public override function result(rmo:ClientRMO) : void
      {
         new GQuestEvent(GQuestEvent.CLAIM_APROVED);
         GlobalFlags.getInstance().lockApplication = false;
      }
   }
}