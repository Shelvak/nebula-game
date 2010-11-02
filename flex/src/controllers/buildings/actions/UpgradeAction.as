package controllers.buildings.actions
{
   
   import controllers.CommunicationAction;
   import controllers.CommunicationCommand;
   
   import globalevents.GBuildingEvent;
   
   import models.building.Building;
   import models.factories.BuildingFactory;
   
   
   
   
   /**
    * Used for upgrading building
    */
   public class UpgradeAction extends CommunicationAction
   {
      override public function applyServerAction
         (cmd: CommunicationCommand) :void{
         if (cmd.parameters.building != null)
         {
            var temp: Building = BuildingFactory.fromObject(cmd.parameters.building);
            if (ML.latestSSObject && ML.latestSSObject.id == cmd.parameters.building.planetId)
            {
               var targetBuilding: Building = ML.latestSSObject.getBuildingById(temp.id);
               targetBuilding.copyProperties(temp);
               targetBuilding.upgradePart.startUpgrade();
               new GBuildingEvent(GBuildingEvent.UPGRADE_APPROVED);
            }
         }
      }
      
      
   }
}