package controllers.buildings.actions
{
   import controllers.CommunicationAction;
   import controllers.CommunicationCommand;

   import models.building.Building;

   import utils.remote.rmo.ClientRMO;

   public class SetBuildIn2ndFlankAction extends CommunicationAction
   {
      private var building: Building;
      private var enable: Boolean;
      
      public override function applyClientAction(cmd:CommunicationCommand):void
      {
         building = cmd.parameters.model;
         enable = cmd.parameters.enable;
         sendMessage(new ClientRMO({"id": building.id, "enabled": enable}, building)) ;
      }
      public override function result(rmo:ClientRMO):void
      {
         super.result(rmo);
         building.buildIn2ndFlank = enable;
      }
   }
}