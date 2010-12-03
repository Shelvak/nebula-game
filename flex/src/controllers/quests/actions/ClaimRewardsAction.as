package controllers.quests.actions
{
   import controllers.CommunicationAction;
   import controllers.GlobalFlags;
   
   import globalevents.GQuestEvent;

   public class ClaimRewardsAction extends CommunicationAction
   {
      public override function result():void
      {
         new GQuestEvent(GQuestEvent.CLAIM_APROVED);
         GlobalFlags.getInstance().lockApplication = false;
      }
   }
}