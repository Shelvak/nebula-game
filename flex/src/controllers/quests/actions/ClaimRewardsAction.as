package controllers.quests.actions
{
   import controllers.CommunicationAction;
   
   import globalevents.GQuestEvent;

   import utils.remote.rmo.ClientRMO;
   
   
   public class ClaimRewardsAction extends CommunicationAction
   {
      public override function result(rmo:ClientRMO) : void
      {
         super.result(rmo);
         new GQuestEvent(GQuestEvent.CLAIM_APROVED);
      }
   }
}