package models.factories
{
   import models.BaseModel;
   import models.solarsystem.MSSMetadata;
   import models.solarsystem.MSolarSystem;
   
   import mx.core.mx_internal;
   
   
   /**
    * Lets easily create instances of solar systems.
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
         if (data["metadata"] != null) {
            ss.metadata = BaseModel.createModel(MSSMetadata, data.metadata);
         }
         return ss;
      }
   }
}