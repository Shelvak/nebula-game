package controllers.planets.actions
{
   import controllers.CommunicationAction;
   import controllers.CommunicationCommand;
   import controllers.GlobalFlags;
   
   import globalevents.GCreditEvent;
   
   import models.planet.MPlanet;
   
   import utils.locale.Localizer;
   import utils.remote.rmo.ClientRMO;
   
   
   public class BoostAction extends CommunicationAction
   {
      
      public override function applyClientAction(cmd:CommunicationCommand) : void
      {
         var planet:MPlanet = MPlanet(cmd.parameters.planet);
         sendMessage(new ClientRMO({
            "id": planet.id,
            "resource": cmd.parameters.resource,
            "attribute": cmd.parameters.attribute
         }, planet));
      }
      
      public override function cancel(rmo:ClientRMO):void
      {
         super.cancel(rmo);
         new GCreditEvent(GCreditEvent.BOOST_CONFIRMED);
         GlobalFlags.getInstance().lockApplication = false;
      }
      
      public override function result(rmo:ClientRMO):void
      {
         new GCreditEvent(GCreditEvent.BOOST_CONFIRMED);
         GlobalFlags.getInstance().lockApplication = false;
      }
   }
}