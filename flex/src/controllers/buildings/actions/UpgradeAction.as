package controllers.buildings.actions
{

   import controllers.CommunicationAction;
   import controllers.CommunicationCommand;

   import models.building.Building;
   import models.factories.BuildingFactory;

   import utils.Objects;

   /**
    * Used for upgrading building
    */
   public class UpgradeAction extends CommunicationAction
   {
      public override function applyServerAction(cmd:CommunicationCommand) : void
      {
         var building: Object = cmd.parameters.building;
         if (building != null)
         {
            if (ML.latestPlanet && ML.latestPlanet.id == building.planetId)
            {
               var targetBuilding:Building = ML.latestPlanet.getBuildingById(building.id);
               Objects.update(targetBuilding, building);
               targetBuilding.upgradePart.startUpgrade();
            }
         }
      }
   }
}