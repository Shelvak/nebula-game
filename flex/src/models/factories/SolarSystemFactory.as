package models.factories
{
   import models.BaseModel;
   import models.MWreckage;
   import models.solarsystem.MSSMetadata;
   import models.solarsystem.MSolarSystem;
   
   import mx.core.mx_internal;
   
   
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
      public static function fromObject(data:Object) : MSolarSystem {
         if (!data) {
            return null;
         }
         
         var ss:MSolarSystem = BaseModel.createModel(MSolarSystem, data);
         if (data["metadata"] != null)
            ss.metadata = BaseModel.createModel(MSSMetadata, data.metadata);
         for each (var object:Object in data.ssObjects) {
            ss.addObject(SSObjectFactory.fromObject(object));
         }
         for each (var wreckage:Object in data.wreckages) {
            ss.addObject(BaseModel.createModel(MWreckage, wreckage));
         }
         for each (var cooldown:Object in data.cooldowns) {
            ss.addObject(CooldownFactory.MCooldownSpace_fromObject(cooldown));
         }
         
         return ss;
      }
   }
}