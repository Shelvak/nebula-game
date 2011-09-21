package controllers.objects.actions.customcontrollers
{
   import utils.SingletonFactory;
   
   import globalevents.GResourcesEvent;
   
   import models.BaseModel;
   import models.MWreckage;
   import models.location.LocationType;
   
   import utils.datastructures.Collections;
   
   
   public class WreckageController extends BaseObjectController
   {
      public function WreckageController() {
         super();
      }
      
      
      public override function objectCreated(objectSubclass:String, object:Object, reason:String) : * {
         var wreck:MWreckage = BaseModel.createModel(MWreckage, object);
         if (wreck.currentLocation.isObserved) {
            if (wreck.currentLocation.type == LocationType.SOLAR_SYSTEM)
               ML.latestSolarSystem.addObject(wreck);
            else
               ML.latestGalaxy.addObject(wreck);
         }
         return wreck;
      }
      
      public override function objectUpdated(objectSubclass:String, object:Object, reason:String) : void {
         var wreckNew:MWreckage = BaseModel.createModel(MWreckage, object);
         var wreckOld:MWreckage = null;
         if (ML.latestGalaxy != null)
            wreckOld = Collections.findFirstEqualTo(ML.latestGalaxy.wreckages, wreckNew);
         if (ML.latestSolarSystem != null && wreckOld == null)
            wreckOld = Collections.findFirstEqualTo(ML.latestSolarSystem.wreckages, wreckNew);
         if (wreckOld == null)
            throw new Error("Can't update wreckage " + wreckNew + ": the object was was not found");
         wreckOld.copyProperties(wreckNew);
      }
      
      
      public override function objectDestroyed(objectSubclass:String, objectId:int, reason:String) : void {
         var wreckSample:MWreckage = new MWreckage();
         wreckSample.id = objectId;
         var wreckRemoved:MWreckage = null;
         if (ML.latestSolarSystem != null)
            wreckRemoved = ML.latestSolarSystem.removeObject(wreckSample, true);
         if (ML.latestGalaxy != null && wreckRemoved == null)
            wreckRemoved = ML.latestGalaxy.removeObject(wreckSample, true);
      }
   }
}