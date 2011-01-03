package controllers.objects.actions.customcontrollers
{
   import com.developmentarc.core.utils.SingletonFactory;
   
   import controllers.objects.ObjectClass;
   
   import globalevents.GObjectEvent;
   
   import models.building.Building;
   import models.constructionqueueentry.ConstructionQueueEntry;
   import models.factories.ConstructionQueryEntryFactory;
   
   import utils.ClassUtil;
   import utils.StringUtil;
   
   
   public class ConstructionQueueEntryController extends BaseObjectController
   {
      public static function getInstance() : ConstructionQueueEntryController
      {
         return SingletonFactory.getSingletonInstance(ConstructionQueueEntryController);
      }
      
      
      public function ConstructionQueueEntryController()
      {
         super();
      }
      
      
      public override function objectCreated(objectSubclass:String, object:Object, reason:String) : void
      {
         var query:ConstructionQueueEntry = ConstructionQueryEntryFactory.fromObject(object);
         var constructor:Building = ML.latestPlanet.getBuildingById(query.constructorId);
         constructor.constructionQueueEntries.addItemAt(query, query.position); 
         constructor.dispatchQueryChangeEvent();
         if (StringUtil.firstToLowerCase(query.constructableType.split('::')[0]) == ObjectClass.BUILDING)
         {
            ML.latestPlanet.buildGhost(
               ClassUtil.toSimpleClassName(query.constructableType),
               query.params.x,
               query.params.y,
               constructor.id
            );
         }
      }
      
      
      public override function objectUpdated(objectSubclass:String, object:Object, reason:String) : void
      {
         var tempQuery:ConstructionQueueEntry = ConstructionQueryEntryFactory.fromObject(object);
         var constructor:Building = ML.latestPlanet.getBuildingById(tempQuery.constructorId);
         constructor.constructionQueueEntries.addItem(tempQuery); 
         constructor.dispatchQueryChangeEvent();
         new GObjectEvent(GObjectEvent.OBJECT_APPROVED);
      }
   }
}