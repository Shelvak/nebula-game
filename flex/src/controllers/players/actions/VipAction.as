package controllers.players.actions
{
   import controllers.CommunicationAction;
   import controllers.CommunicationCommand;
   import controllers.GlobalFlags;
   import controllers.Messenger;
   
   import mx.states.OverrideBase;
   
   import utils.locale.Localizer;
   import utils.remote.rmo.ClientRMO;
   
   
   
   /**
    * Informs the server that a player has seen first time login screen and open up quests window from
    * there.
    */
   public class VipAction extends CommunicationAction
   {
      public override function cancel(rmo:ClientRMO):void
      {
         super.cancel(rmo);
         GlobalFlags.getInstance().lockApplication = false;
      }
      
      public override function result(rmo:ClientRMO):void
      {
         GlobalFlags.getInstance().lockApplication = false;
         Messenger.show(
            Localizer.string('Credits','message.vipOrdered'), Messenger.MEDIUM);
      }
   }
}