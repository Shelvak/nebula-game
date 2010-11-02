package models.factories
{
   import models.BaseModel;
   import models.ModelsCollection;
   import models.solarsystem.SSMetadata;
   import models.solarsystem.SolarSystem;
   
   import mx.collections.ArrayCollection;
   
   
   
   
   /**
    * Lets easily create instaces of solar systems. 
    */
   public class SolarSystemFactory
   {
      /**
       * Creates a solar system form a given simple object.
       *  
       * @param data An object representing a solar system.
       * 
       * @return instance of <code>SolarSystem</code> with values of properties
       * loaded from the data object.
       */
      public static function fromObject (data: Object) :SolarSystem
      {
         if (!data)
         {
            return null;
         }
         
         var ss: SolarSystem = BaseModel.createModel (SolarSystem, data);
         ss.metadata = BaseModel.createModel(SSMetadata, data.metadata);
         
         var source:Array = new Array();
         for each (var obj:Object in data.ssObjects)
         {
            source.push(SSObjectFactory.fromObject(obj));
         }
         ss.objects.addAll(new ArrayCollection(source));
         
         return ss;
      }
   }
}