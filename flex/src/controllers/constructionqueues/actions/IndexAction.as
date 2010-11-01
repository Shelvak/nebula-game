package controllers.constructionqueues.actions
{
   
   import controllers.CommunicationAction;
   import controllers.CommunicationCommand;
   
   import globalevents.GUnitEvent;
   
   import models.building.Building;
   import models.constructionqueueentry.ConstructionQueueEntry;
   import models.factories.ConstructionQueryEntryFactory;
   

   public class IndexAction extends CommunicationAction
   {
//    # Lists all ConstructionQueueEntry's.
//    #
//    # This is pushed by other actions in this controller.
//    #
//    # Response:
//    #   * entries - Array of ConstructionQueueEntry.
//    #
      /**
       * @private 
       */
      override public function applyServerAction
         (cmd: CommunicationCommand) :void
      {
         if (cmd.parameters.entries != null)
         {
            var currentFacility: Building = ML.latestPlanet.getBuildingById(cmd.parameters.constructorId);
            currentFacility.constructionQueueEntries.removeAll();
            for each(var queueElementObj: Object in cmd.parameters.entries)
            {
               var tempQuery:ConstructionQueueEntry = 
                  ConstructionQueryEntryFactory.fromObject(queueElementObj);
               ML.latestPlanet.getBuildingById(tempQuery.constructorId).constructionQueueEntries.addItem(tempQuery);
            }
            currentFacility.dispatchQueryChangeEvent();
         }
      }
   }
}