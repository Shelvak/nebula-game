package controllers.constructionqueues.actions
{
   
   import controllers.CommunicationAction;
   import controllers.CommunicationCommand;
   
   import models.building.Building;
   import models.constructionqueueentry.ConstructionQueueEntry;
   import models.factories.ConstructionQueryEntryFactory;
   import models.planet.Planet;
   

   public class IndexAction extends CommunicationAction
   {
//    # Lists all ConstructionQueueEntry's.
//    #
//    # This is pushed by other actions in this controller.
//    #
//    # Response:
//    #   * entries - Array of ConstructionQueueEntry.
//    #
      override public function applyServerAction(cmd:CommunicationCommand) : void
      {
         if (cmd.parameters.entries != null)
         {
            var planet:Planet = ML.latestPlanet;
            var currentFacility:Building = planet.getBuildingById(cmd.parameters.constructorId);
            currentFacility.constructionQueueEntries.removeAll();
            for each(var queueElementObj:Object in cmd.parameters.entries)
            {
               var tempQuery:ConstructionQueueEntry = ConstructionQueryEntryFactory.fromObject(queueElementObj);
               planet.getBuildingById(tempQuery.constructorId).constructionQueueEntries.addItem(tempQuery);
            }
            currentFacility.dispatchQueryChangeEvent();
         }
      }
   }
}