package controllers.buildings.actions
{
   import controllers.CommunicationAction;
   import controllers.CommunicationCommand;
   import controllers.GlobalFlags;
   
   import models.building.Building;
   
   import utils.remote.rmo.ClientRMO;
   
   public class SetBuildIn2ndFlankAction extends CommunicationAction
   {
      private var building: Building;
      private var enable: Boolean;
      
      public override function applyClientAction(cmd:CommunicationCommand):void
      {
         GlobalFlags.getInstance().lockApplication = true;
         building = cmd.parameters.model;
         enable = cmd.parameters.enable;
         sendMessage(new ClientRMO({"id": building.id, "enabled": enable}, building)) ;
      }
      public override function result(rmo:ClientRMO):void
      {
         building.buildIn2ndFlank = enable;
         GlobalFlags.getInstance().lockApplication = false;
      }
      
      public override function cancel(rmo:ClientRMO):void
      {
         super.cancel(rmo);
         GlobalFlags.getInstance().lockApplication = false;
      }
   }
}