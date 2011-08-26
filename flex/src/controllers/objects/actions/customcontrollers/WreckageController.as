package controllers.objects.actions.customcontrollers
{
   import models.MWreckage;
   import models.location.LocationType;
   
   import utils.Objects;
   import utils.datastructures.Collections;
   
   
   public class WreckageController extends BaseObjectController
   {
      public function WreckageController() {
         super();
      }
      
      
      public override function objectCreated(objectSubclass:String, object:Object, reason:String) : void {
         var wreck:MWreckage = Objects.create(MWreckage, object);
         if (wreck.currentLocation.isObserved) {
            if (wreck.currentLocation.type == LocationType.SOLAR_SYSTEM)
               ML.latestSolarSystem.addObject(wreck);
            else
               ML.latestGalaxy.addObject(wreck);
         }
      }
      
      public override function objectUpdated(objectSubclass:String, object:Object, reason:String) : void {
         var wreckNew:MWreckage = Objects.create(MWreckage, object);
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