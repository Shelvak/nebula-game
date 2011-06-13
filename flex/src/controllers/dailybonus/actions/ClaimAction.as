package controllers.dailybonus.actions
{
   import controllers.CommunicationAction;
   import controllers.GlobalFlags;
   
   import utils.remote.rmo.ClientRMO;

   public class ClaimAction extends CommunicationAction
   {
      public override function cancel(rmo:ClientRMO):void
      {
         super.cancel(rmo);
         GlobalFlags.getInstance().lockApplication = false;
      }
      
      public override function result(rmo:ClientRMO):void
      {
         ML.player.dailyBonus = null;
         GlobalFlags.getInstance().lockApplication = false;
      }
   }
}