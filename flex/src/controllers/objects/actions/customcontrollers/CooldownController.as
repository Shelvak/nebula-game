package controllers.objects.actions.customcontrollers
{
   import models.BaseModel;
   import models.cooldown.MCooldown;
   import models.cooldown.MCooldownSpace;
   import models.location.LocationMinimal;
   import models.map.MMapSpace;
   
   import utils.DateUtil;
   
   
   public class CooldownController extends BaseObjectController
   {
      public function CooldownController()
      {
         super();
      }
      
      
      public override function objectCreated(objectSubclass:String, object:Object, reason:String) : void
      {
         var location:LocationMinimal = BaseModel.createModel(LocationMinimal, object.location);
         // don't need cooldowns for other objects than maps
         if (!location.isObserved)
         {
            return;
         }
         var cooldown:MCooldown = location.isSSObject ?
            new MCooldown() :
            new MCooldownSpace();
         cooldown.id = object.id;
         cooldown.currentLocation = location;
         cooldown.endsAt = DateUtil.parseServerDTF(object.endsAt, false);
         if (location.isSSObject)
         {
            ML.latestPlanet.ssObject.cooldown = cooldown;
         }
         else
         {
            MMapSpace(location.isGalaxy ? ML.latestGalaxy : ML.latestSolarSystem).addObject(cooldown);
         }
      }
   }
}