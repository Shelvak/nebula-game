package controllers.objects.actions.customcontrollers
{
   import utils.SingletonFactory;
   
   import controllers.objects.ObjectClass;
   
   import globalevents.GObjectEvent;
   
   import models.building.Building;
   import models.constructionqueueentry.ConstructionQueueEntry;
   import models.factories.ConstructionQueryEntryFactory;
   
   import utils.Objects;
   import utils.ModelUtil;
   
   
   public class ConstructionQueueEntryController extends BaseObjectController
   {
      public function ConstructionQueueEntryController() {
         super();
      }
      
      public override function objectCreated(objectSubclass:String, object:Object, reason:String) : void {
         var query:ConstructionQueueEntry = ConstructionQueryEntryFactory.fromObject(object);
         var constructor:Building = ML.latestPlanet.getBuildingById(query.constructorId);
         constructor.constructionQueueEntries.addItemAt(query, query.position); 
         constructor.dispatchQueryChangeEvent();
         if (ModelUtil.getModelClass(query.constructableType) == ObjectClass.BUILDING)
            ML.latestPlanet.buildGhost(
               Objects.toSimpleClassName(query.constructableType),
               query.params.x,
               query.params.y,
               constructor.id
            );
      }
      
      public override function objectUpdated(objectSubclass:String, object:Object, reason:String) : void {
         var tempQuery:ConstructionQueueEntry = ConstructionQueryEntryFactory.fromObject(object);
         var constructor:Building = ML.latestPlanet.getBuildingById(tempQuery.constructorId);
         constructor.constructionQueueEntries.addOrUpdate(tempQuery); 
         constructor.dispatchQueryChangeEvent();
         new GObjectEvent(GObjectEvent.OBJECT_APPROVED);
      }
   }
}