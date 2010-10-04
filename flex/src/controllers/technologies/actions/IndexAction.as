package controllers.technologies.actions
{
   
   import controllers.CommunicationAction;
   import controllers.CommunicationCommand;
   
   import models.building.Building;
   import models.factories.TechnologyFactory;
   import models.technology.Technology;
   
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
            var temp: Technology = TechnologyFactory.fromObject(element);
            ML.technologies.getTechnologyByType(temp.type).copyProperties(temp);
            if (!ML.technologies.getTechnologyByType(temp.type).upgradePart.upgradeCompleted)
               ML.technologies.getTechnologyByType(temp.type).upgradePart.startUpgrade();
         }
         ML.constructable = Building.getConstructableBuildings();
         ML.resourcesMods.recalculateMods();
      }
      
      
   }
}