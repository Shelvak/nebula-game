package models.factories
{
   import flash.geom.Rectangle;
   
   import mx.collections.ArrayCollection;
   import mx.collections.IList;
   
   
   /**
    * Lets easily create galaxy instances. 
    */   
   public class GalaxyFactory
   {
      public static function createFowEntries(data:Array) : Array {
         var fowEntries:Array = new Array();
         for each (var item:Object in data) {
            fowEntries.push(
               new Rectangle(
                  item.x,
                  item.y,
                  item.xEnd - item.x + 1,
                  item.yEnd - item.y + 1
               )
            );
         }
         return fowEntries;
      }
      
      public static function createSolarSystems(data:Array) : IList {
         var solarSystems:IList = new ArrayCollection();
         for each (var item:Object in data) {
            var ssData:Object = item["solarSystem"];
            ssData["metadata"] = item["metadata"];
            solarSystems.addItem(SolarSystemFactory.fromObject(ssData));
         }
         return solarSystems;
      }
   }
}