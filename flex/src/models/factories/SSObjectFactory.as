package models.factories
{
   import models.BaseModel;
   import models.resource.Resource;
   import models.resource.ResourceType;
   import models.solarsystem.MSSObject;

   public class SSObjectFactory
   {
      public static function fromObject(data:Object) : MSSObject
      {
         if (!data)
         {
            return null;
         }
         
         var object:MSSObject = BaseModel.createModel(MSSObject, data);
         function createResource(type:String) : void
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