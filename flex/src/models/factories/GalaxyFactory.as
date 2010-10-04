package models.factories
{
   import models.Galaxy;
   
   import namespaces.client_internal;
   
   
   /**
    * Lets easily create galaxy instances. 
    */   
   public class GalaxyFactory
   {  
      /**
       * Creates galaxy from a simple raw object.
       *  
       * @param data Object representing a galaxy.
       * 
       * @return instance of <code>Galaxy</code>.
       */
      public static function fromObject(data:Object) : Galaxy
      {
         if (!data)
         {
            return null;
         }
         
         var g:Galaxy = new Galaxy();
         g.id = data.id;
         for each (var data:Object in data.solarSystems)
         {
            data.solarSystem.metadata = data.metadata;
            g.addSolarSystem(SolarSystemFactory.fromObject(data.solarSystem));
         }
         g.client_internal::setMinMaxProperties();
         
         return g;
      }
   }
}