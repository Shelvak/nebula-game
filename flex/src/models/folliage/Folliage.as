package models.folliage
{
   import models.planet.PlanetObject;
   import models.tile.TerrainType;
   
   import mx.collections.IList;
   
   
   /**
    * Base class for folliages.
    */
   public class Folliage extends PlanetObject
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
       * <code>PlanetObjectEvent.IMAGE_CHANGE</code> event.</p>
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
   }
}