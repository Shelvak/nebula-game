package controllers.players.actions
{
   import controllers.CommunicationAction;
   import controllers.CommunicationCommand;
   import controllers.GlobalFlags;
   import controllers.ui.NavigationController;
   
   import models.factories.AchievementFactory;
   import models.factories.RatingsPlayerFactory;
   
   import utils.remote.rmo.ClientRMO;
   
   
   
   /**
    * Requests player profile information from server
    */
   public class ShowProfileAction extends CommunicationAction
   {
      public override function applyServerAction(cmd:CommunicationCommand):void
      {
         NavigationController.getInstance().openPlayerScreen(
            RatingsPlayerFactory.fromObject(cmd.parameters.player),
            AchievementFactory.fromObjects(cmd.parameters.achievements));
      }
      
      public override function result(rmo:ClientRMO):void
      {
         GlobalFlags.getInstance().lockApplication = false;
      }
      
      public override function cancel(rmo:ClientRMO):void
      {
         super.cancel(rmo);
         GlobalFlags.getInstance().lockApplication = false;
      }
   }
}