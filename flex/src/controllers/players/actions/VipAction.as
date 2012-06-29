package controllers.players.actions
{
   import controllers.CommunicationAction;

   import models.notification.MSuccessEvent;

   import models.notification.MTimedEvent;

   import utils.locale.Localizer;
   import utils.remote.rmo.ClientRMO;

   /**
    * Informs the server that a player has seen first time login screen and open up quests window from
    * there.
    */
   public class VipAction extends CommunicationAction
   {
      
      public override function result(rmo:ClientRMO):void
      {
         super.result(rmo);
         new MSuccessEvent(
            Localizer.string('Credits','message.vipOrdered'));
      }
   }
}