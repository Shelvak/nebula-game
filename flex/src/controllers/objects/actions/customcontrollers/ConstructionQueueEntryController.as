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
      
      public override function objectCreated(objectSubclass:String, object:Object, reason:String) : * {
         var constructor:Building = ML.latestPlanet.getBuildingById(object.constructorId);
         var query:ConstructionQueueEntry = constructor.constructionQueueEntries.find(object.id);
         if (query == null)
         {
            query = ConstructionQueryEntryFactory.fromObject(object);
            constructor.constructionQueueEntries.addItemAt(query, query.position);
            constructor.dispatchQueryChangeEvent();
         }
         if (ModelUtil.getModelClass(query.constructableType) == ObjectClass.BUILDING)
            ML.latestPlanet.buildGhost(
               Objects.toSimpleClassName(query.constructableType),
               query.params.x,
               query.params.y,
               constructor.id,
               query.prepaid
            );
         return query;
      }
      
      public override function objectUpdated(objectSubclass:String, object:Object, reason:String) : void {
         var constructor:Building = ML.latestPlanet.getBuildingById(object.constructorId);
         constructor.constructionQueueEntries.addOrUpdate(object, ConstructionQueueEntry);
         constructor.dispatchQueryChangeEvent();
         new GObjectEvent(GObjectEvent.OBJECT_APPROVED);
      }
   }
}