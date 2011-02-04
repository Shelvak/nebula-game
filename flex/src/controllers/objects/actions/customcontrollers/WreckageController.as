package controllers.objects.actions.customcontrollers
{
   import com.developmentarc.core.utils.SingletonFactory;
   
   import globalevents.GResourcesEvent;
   
   import models.BaseModel;
   import models.MWreckage;
   import models.location.LocationType;
   
   import utils.datastructures.Collections;
   
   
   public class WreckageController extends BaseObjectController
   {
      public static function getInstance() : WreckageController
      {
         return SingletonFactory.getSingletonInstance(WreckageController);
      }
      
      
      public function WreckageController()
      {
      }
      
      
      public override function objectCreated(objectSubclass:String, object:Object, reason:String) : void
      {
         var wreck:MWreckage = BaseModel.createModel(MWreckage, object);
         if (wreck.currentLocation.isObserved)
         {
            if (wreck.currentLocation.type == LocationType.SOLAR_SYSTEM)
            {
               ML.latestSolarSystem.addObject(wreck);
            }
            else
            {
               ML.latestGalaxy.addObject(wreck);
            }
         }
      }
      
      
      public override function objectUpdated(objectSubclass:String, object:Object, reason:String) : void
      {
         var wreckNew:MWreckage = BaseModel.createModel(MWreckage, object);
         var wreckOld:MWreckage = null;
         if (ML.latestGalaxy)
         {
            wreckOld = Collections.findFirstEqualTo(ML.latestGalaxy.wreckages, wreckNew);
         }
         if (ML.latestSolarSystem && !wreckOld)
         {
            wreckOld = Collections.findFirstEqualTo(ML.latestSolarSystem.wreckages, wreckNew);
         }
         if (!wreckOld)
         {
            throw new Error("Can't update wreckage " + wreckNew + ": the object was was not found");
         }
         wreckOld.copyProperties(wreckNew);
      }
      
      
      public override function objectDestroyed(objectSubclass:String, objectId:int, reason:String) : void
      {
         var wreckSample:MWreckage = new MWreckage();
         wreckSample.id = objectId;
         var wreckRemoved:MWreckage = null;
         if (ML.latestSolarSystem)
         {
            wreckRemoved = ML.latestSolarSystem.removeObject(wreckSample, true);
         }
         if (ML.latestGalaxy && !wreckRemoved)
         {
            wreckRemoved = ML.latestGalaxy.removeObject(wreckSample, true);
         }
      }
   }
}