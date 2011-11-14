package models.folliage
{
   import models.planet.MPlanetObject;
   import models.tile.TerrainType;
   
   import mx.collections.IList;
   
   
   /**
    * Base class for folliages.
    */
   public class Folliage extends MPlanetObject
   {
      /**
       * Sets terrain type of each folliage in the list.
       * 
       * @param terrainType New terrain type. Use constants from
       * <code>TerrainType</code> class.
       * @param list List of folliages to update.
       * 
       * @param params List of <code>Folliage</code> instances.
       */
      public static function setTerrainType(terrainType:int, list:IList) : void
      {
         for (var i:int = 0; i < list.length; i++)
         {
            Folliage(list.getItemAt(i)).terrainType = terrainType;
         }
      }
      
      
      /* ################## */
      /* ### PROPERTIES ### */
      /* ################## */
      
      
      private var _terrainType:int = TerrainType.GRASS;
      [Bindable]
      /**
       * Type of planet terrain this folliage is standing on. Use constants
       * from <code>TerrainType</code> class.
       * 
       * <p>Setting this property will dispatch
       * <code>MPlanetObjectEvent.IMAGE_CHANGE</code> event.</p>
       * 
       * @default TerrainType.GRASS
       */
      public function set terrainType(v:int) : void
      {
         _terrainType = v;
         dispatchImageChangeEvent();
      }
      public function get terrainType() : int
      {
         return _terrainType;
      }
      
      
      /* ########################### */
      /* ### BaseModel OVERRIDES ### */
      
      public override function toString() : String {
         return "[class: " + className +
                ", id: " + id +
                ", x: " + x +
                ", xEnd: " + xEnd +
                ", y: " + y +
                ", yEnd: " + yEnd + "]"
      }
   }
}