package components.factories
{
   import components.gameobjects.solarsystem.SolarSystemTile;
   
   import models.solarsystem.SolarSystem;
   
   import mx.collections.ArrayCollection;
   
   
   
   
   /**
    * Lets easily create different type tiles for maps. 
    */   
   public class MapTileFactory
   {
      /**
       * Creates tiles for solar system map.
       *  
       * @param solarSystems List of solar system models.
       * 
       * @return A list of <code>SolarSystemTile</code> instances.
       */      
      public static function solarSystemTiles
         (solarSystems: ArrayCollection) :Array
      {
         var tiles: Array = new Array ();
         
         for each (var ss: SolarSystem in solarSystems)
         {
            var tile: SolarSystemTile = new SolarSystemTile ();
            tile.model = ss;
            tiles.push (tile);
         }
         
         return tiles;
      }
   }
}