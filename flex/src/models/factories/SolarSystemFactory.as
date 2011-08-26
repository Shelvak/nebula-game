package models.factories
{
   import models.MWreckage;
   import models.solarsystem.SSMetadata;
   import models.solarsystem.SolarSystem;
   
   import utils.Objects;
   
   
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
      public static function fromObject(data:Object) : SolarSystem {
         if (!data) {
            return null;
         }
         
         var ss:SolarSystem = Objects.create(SolarSystem, data);
         if (data["metadata"] != null)
            ss.metadata = Objects.create(SSMetadata, data.metadata);
         for each (var object:Object in data.ssObjects) {
            ss.objects.addItem(SSObjectFactory.fromObject(object));
         }
         for each (var wreckage:Object in data.wreckages) {
            ss.objects.addItem(Objects.create(MWreckage, wreckage));
         }
         for each (var cooldown:Object in data.cooldowns) {
            ss.objects.addItem(CooldownFactory.MCooldownSpace_fromObject(cooldown));
         }
         
         return ss;
      }
   }
}