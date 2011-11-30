package controllers.players.actions
{
   import controllers.CommunicationAction;
   import controllers.CommunicationCommand;
   import controllers.ui.NavigationController;

   import models.factories.AchievementFactory;
   import models.factories.RatingsPlayerFactory;

   /**
    * Requests player profile information from server
    */
   public class ShowProfileAction extends CommunicationAction
   {
      public override function applyServerAction(cmd:CommunicationCommand):void
      {
         NavigationController.getInstance().openPlayerScreen(
            RatingsPlayerFactory.fromObject(cmd.parameters.player),
            AchievementFactory.fromObjects(cmd.parameters.achievements)
         );
      }
   }
}