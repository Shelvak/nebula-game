package models.factories
{
   import flash.geom.Rectangle;
   
   import models.galaxy.Galaxy;
   
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
         for each (var item:Object in data.solarSystems)
         {
            item.solarSystem.metadata = item.metadata;
            g.addSolarSystem(SolarSystemFactory.fromObject(item.solarSystem));
         }
         
         return g;
      }
      
      
      public static function createFowEntries(data:Array) : Vector.<Rectangle>
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