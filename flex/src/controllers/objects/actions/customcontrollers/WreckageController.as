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

      public override function objectCreated(objectSubclass: String,
                                             object: Object,
                                             reason: String): * {
         var wreck: MWreckage = Objects.create(MWreckage, object);
         if (wreck.currentLocation.isObserved) {
            if (wreck.currentLocation.type == LocationType.SOLAR_SYSTEM) {
               ML.latestSSMap.addObject(wreck);
            }
            else {
               ML.latestGalaxy.addObject(wreck);
            }
         }
         return wreck;
      }

      public override function objectUpdated(objectSubclass: String,
                                             object: Object,
                                             reason: String): void {
         var wreckOld: MWreckage = null;
         function isEqualTo(item: MWreckage): Boolean
         {
            return item.id == object.id;
         }
         if (ML.latestGalaxy != null) {
            wreckOld = Collections.findFirst(ML.latestGalaxy.wreckages, isEqualTo);
         }
         if (ML.latestSSMap != null && wreckOld == null) {
            wreckOld = Collections.findFirst(ML.latestSSMap.wreckages, isEqualTo);
         }
         if (wreckOld == null) {
            throw new Error(
               "Can't update wreckage with id: " + object.id + ": the object "
                  + "was not found"
            );
         }
         Objects.update(wreckOld, object);
      }

      public override function objectDestroyed(objectSubclass: String,
                                               objectId: int,
                                               reason: String): void {
         var wreckSample: MWreckage = new MWreckage();
         wreckSample.id = objectId;
         var wreckRemoved: MWreckage = null;
         if (ML.latestSSMap != null) {
            wreckRemoved = ML.latestSSMap.removeObject(wreckSample, true);
         }
         if (ML.latestGalaxy != null && wreckRemoved == null) {
            wreckRemoved = ML.latestGalaxy.removeObject(wreckSample, true);
         }
      }
   }
}