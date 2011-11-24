package controllers.quests.actions
{
   import controllers.CommunicationAction;
   import utils.ApplicationLocker;
   import controllers.Messenger;
   
   import globalevents.GQuestEvent;
   
   import utils.locale.Localizer;
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