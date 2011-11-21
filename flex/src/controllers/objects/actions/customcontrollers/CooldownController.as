package controllers.objects.actions.customcontrollers
{
   import models.cooldown.MCooldown;
   import models.cooldown.MCooldownSpace;
   import models.location.LocationMinimal;
   import models.map.MMapSpace;
   
   import utils.DateUtil;
   import utils.datastructures.Collections;
   import utils.Objects;
   
   
   public class CooldownController extends BaseObjectController
   {
      public function CooldownController() {
         super();
      }

      public override function objectCreated(objectSubclass:String,
                                             object:Object,
                                             reason:String) : * {
         var location:LocationMinimal =
                Objects.create(LocationMinimal, object.location);
         
         // don't need cooldowns for other objects than maps
         if (!location.isObserved)
            return;
         
         var cooldown:MCooldown = location.isSSObject ?
            new MCooldown() :
            new MCooldownSpace();
         cooldown.id = object.id;
         cooldown.currentLocation = location;
         cooldown.endsAt = DateUtil.parseServerDTF(object.endsAt);
         if (location.isSSObject)
            ML.latestPlanet.ssObject.cooldown = cooldown;
         else {
            var map:MMapSpace = MMapSpace(location.isGalaxy ? ML.latestGalaxy : ML.latestSSMap);
            // Server often sends objects|created with a cooldown in the same location just
            // before a few seconds it is about to be removed by the client
            Collections.removeFirstEqualTo(map.cooldowns, cooldown, true);
            map.addObject(cooldown);
         }
         
         return cooldown;
      }
   }
}