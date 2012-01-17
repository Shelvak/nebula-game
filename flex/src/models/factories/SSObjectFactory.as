package models.factories
{
   import models.cooldown.MCooldown;
   import models.resource.Resource;
   import models.resource.ResourceType;
   import models.solarsystem.MSSObject;
   
   import utils.DateUtil;
   import utils.Objects;
   
   public class SSObjectFactory
   {
      public static function fromObject(data:Object) : MSSObject
      {
         if (!data)
         {
            return null;
         }
         
         var object:MSSObject = Objects.create(MSSObject, data);
         if (data.cooldownEndsAt != null)
         {
            object.cooldown = new MCooldown();
            object.cooldown.endsEvent.occuresAt = DateUtil.parseServerDTF(data.cooldownEndsAt);
            object.cooldown.currentLocation = object.currentLocation;
         }
         function createResource(type:String) : void
         {
            var resource:Resource = new Resource();
            resource.type = type;
            if (data[type] == null)
            {
               resource.unknown = true;
            }
            resource.currentStock = data[type];
            resource.maxStock = data[type + "Storage"];
            resource.usageRate = data[type + "UsageRate"];
            resource.generationRate = data[type + "GenerationRate"];
            if (object[type] != null)
            {
               resource.boost = object[type].boost;
            }
            object[type] = resource;
         }
         for each (var type:String in [ResourceType.METAL, ResourceType.ENERGY, ResourceType.ZETIUM])
         {
            createResource(type);
         }
         return object;
      }
   }
}