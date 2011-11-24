package controllers.dailybonus.actions
{
   import controllers.CommunicationAction;

   import utils.remote.rmo.ClientRMO;

   public class ClaimAction extends CommunicationAction
   {
      public override function result(rmo:ClientRMO) : void {
         super.result(rmo);
         ML.player.dailyBonus = null;
      }
   }
}