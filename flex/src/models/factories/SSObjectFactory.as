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
         function createResource(
            type:String, getResource: Function, setResource: Function
         ) : void
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

            var originalResource: Resource = getResource();
            if (originalResource != null) {
               resource.boost = originalResource.boost;
            }
            
            setResource(resource);
         }
         
         createResource(
            ResourceType.METAL,
            function(): Resource { return object.metal; },
            function(resource: Resource): void { object.metal = resource; }
         );
         createResource(
            ResourceType.ENERGY,
            function(): Resource { return object.energy; },
            function(resource: Resource): void { object.energy = resource; }
         );
         createResource(
            ResourceType.ZETIUM,
            function(): Resource { return object.zetium; },
            function(resource: Resource): void { object.zetium = resource; }
         );

         return object;
      }
   }
}