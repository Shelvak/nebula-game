package models.factories
{
   import models.resource.Resource;
   import models.resource.ResourceType;
   import models.solarsystem.SSObject;

   public class SSObjectFactory
   {
      public static function fromObject(data:Object) : SSObject
      {
         if (!data)
         {
            return null;
         }
         
         var object:SSObject = BaseModel.createModel(SSObject, data);
         function createResource(type:String) : Resource
         {
            var resource:Resource = new Resource();
            resource.type = type;
            resource.currentStock = data[type];
            resource.maxStock = data[type + "Storage"];
            resource.rate = data[type + "Rate"];
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