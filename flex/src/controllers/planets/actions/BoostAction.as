package controllers.planets.actions
{
   import controllers.CommunicationAction;
   import controllers.CommunicationCommand;
   import controllers.GlobalFlags;
   
   import models.planet.Planet;
   
   import utils.locale.Localizer;
   import utils.remote.rmo.ClientRMO;
   
   
   public class BoostAction extends CommunicationAction
   {
      
      public override function applyClientAction(cmd:CommunicationCommand) : void
      {
         var planet:Planet = Planet(cmd.parameters.planet);
         sendMessage(new ClientRMO({
            "id": planet.id,
            "resource": cmd.parameters.resource,
            "attribute": cmd.parameters.attribute
         }, planet));
      }
      
      public override function cancel(rmo:ClientRMO):void
      {
         super.cancel(rmo);
         GlobalFlags.getInstance().lockApplication = false;
      }
      
      public override function result(rmo:ClientRMO):void
      {
         GlobalFlags.getInstance().lockApplication = false;
      }
   }
}