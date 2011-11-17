package controllers.buildings.actions
{
   
   import controllers.CommunicationAction;
   import controllers.CommunicationCommand;
   import controllers.GlobalFlags;
   
   import models.building.Building;
   import models.factories.BuildingFactory;
   
   import utils.remote.rmo.ClientRMO;
   
   
   /**
    * Used for upgrading building
    */
   public class UpgradeAction extends CommunicationAction
   {
      public override function applyServerAction(cmd:CommunicationCommand) : void
      {
         if (cmd.parameters.building != null)
         {
            var temp:Building = BuildingFactory.fromObject(cmd.parameters.building);
            if (ML.latestPlanet && ML.latestPlanet.id == cmd.parameters.building.planetId)
            {
               var targetBuilding:Building = ML.latestPlanet.getBuildingById(temp.id);
               targetBuilding.copyProperties(temp);
               targetBuilding.upgradePart.startUpgrade();
            }
            temp.cleanup();
         }
      }
      
      
      public override function cancel(rmo:ClientRMO) : void
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