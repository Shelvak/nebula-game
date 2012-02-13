package controllers.technologies.actions
{
   
   import controllers.CommunicationAction;
   import controllers.CommunicationCommand;
   
   import models.building.Building;
   import models.building.MCBuildingSelectedSidebar;
   import models.factories.TechnologyFactory;
   import models.technology.Technology;

   import utils.Objects;

   /**
    * Downloads all technologies
    */ 
   public class IndexAction extends CommunicationAction
   {  
      
      /**
       * @private
       */
      override public function applyServerAction(cmd:CommunicationCommand) :void
      { 
         ML.technologies.createAllTechnologies();
         var technologies: Object = cmd.parameters.technologies;
         for each (var element: Object in technologies)
         {
            var technology:Technology = ML.technologies.getTechnologyByType(element.type);
            Objects.update(technology, element);
            if (technology.upgradePart.upgradeEndsAt)
               technology.upgradePart.startUpgrade();
         }
         MCBuildingSelectedSidebar.getInstance().constructable = 
            Building.getConstructableBuildings();
         ML.resourcesMods.recalculateMods();
      }
      
      
   }
}