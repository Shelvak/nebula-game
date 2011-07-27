package controllers.planets.actions
{
   import controllers.CommunicationAction;
   import controllers.GlobalFlags;
   import controllers.Messenger;
   
   import utils.locale.Localizer;
   import utils.remote.rmo.ClientRMO;
   
   /**
    * # Take ownership of a free planet. To take a planet, it must belong to
    * # NPC, you should not have enemies in that planet and you or your alliance
    * # should have units there.
    * #
    * # Invocation: by client
    * #
    * # Parameters:
    * # - id (Fixnum): ID of the planet you want to take
    * #
    * # Response: None
    * #
    * def action_take 
    * @author Jho
    * 
    */   
   public class TakeAction extends CommunicationAction
   {
      public override function cancel(rmo:ClientRMO):void
      {
         super.cancel(rmo);
         GlobalFlags.getInstance().lockApplication = false;
      }
      
      public override function result(rmo:ClientRMO):void
      {
         Messenger.show(Localizer.string('General', 'message.planetClaimed'), 
            Messenger.MEDIUM);
         GlobalFlags.getInstance().lockApplication = false;
      }
   }
}