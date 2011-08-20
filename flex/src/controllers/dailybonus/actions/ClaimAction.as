package controllers.dailybonus.actions
{
   import controllers.CommunicationAction;
   import controllers.CommunicationCommand;
   import controllers.GlobalFlags;
   
   import utils.remote.rmo.ClientRMO;

   public class ClaimAction extends CommunicationAction
   {
      private function get GF() : GlobalFlags {
         return GlobalFlags.getInstance();
      }
      
      
      public override function applyClientAction(cmd:CommunicationCommand) : void {
         GF.lockApplication = true;
         super.applyClientAction(cmd);
      }
      
      public override function cancel(rmo:ClientRMO) : void {
         super.cancel(rmo);
         GF.lockApplication = false;
      }
      
      public override function result(rmo:ClientRMO) : void {
         ML.player.dailyBonus = null;
         GF.lockApplication = false;
      }
   }
}