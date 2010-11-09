package models.factories
{
   import flash.geom.Rectangle;
   
   import models.ModelsCollection;
   import models.galaxy.Galaxy;
   import models.solarsystem.SolarSystem;
   
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
         var source:Array = new Array();
         for each (var item:Object in data.solarSystems)
         {
            item.solarSystem.metadata = item.metadata;
            source.push(SolarSystemFactory.fromObject(item.solarSystem));
         }
         g.solarSystems = new ModelsCollection(source);
         
         return g;
      }
      
      
      public static function createFowEntries(galaxy:Galaxy, data:Array) : Vector.<Rectangle>
      {
         var fowEntries:Vector.<Rectangle> = new Vector.<Rectangle>();
         for each (var item:Object in data)
         {
            fowEntries.push(new Rectangle(item.x, item.y, item.xEnd - item.x + 1, item.yEnd - item.y + 1));
         }
         return fowEntries;
      }
   }
}