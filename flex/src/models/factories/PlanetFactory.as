package models.factories
{
   import models.BaseModel;
   import models.folliage.Folliage;
   import models.planet.Planet;
   import models.tile.Tile;
   
   import mx.collections.ArrayCollection;
   
   
   
   /**
    * Lets easily create instaces of planets. 
    */
   public class PlanetFactory
   {
      /**
       * Creates a planet form a given simple object.
       *  
       * @param data An object representing a planet.
       * 
       * @return instance of <code>Planet</code> with values of properties
       * loaded from the data object.
       */	   
      public static function fromObject(data:Object) : Planet
      {
         if (!data)
         {
            return null;
         }
         
         var planet:Planet = BaseModel.createModel(Planet, data);         
         planet.location.angle = data.angle;
         planet.location.position = data.position;
         
         var objects:ArrayCollection = new ArrayCollection();
         
         for each (var t:Object in data.tiles)
         {
            var tile:Tile = TileFactory.fromObject(t);
            planet.addTile(tile);
            
            // If the tile is of resource type, add other three resource tiles but mark
            // them as fake.
            if (tile.isResource())
            {
               addFakeTile(planet, tile, true,  false);   // Fake tile on the right
               addFakeTile(planet, tile, false, true);    // Fake tile under
               addFakeTile(planet, tile, true,  true);    // Fake tile on the right and under
            }
            
            // If the tile is of folliage that means we need blocking folliage
            if (tile.isFolliage())
            {
               objects.addItem(FolliageFactory.blocking(tile));
            }
         }
         for each (var building:Object in data.buildings)
         {
            objects.addItem(BuildingFactory.fromObject(building));
         }
         for each (var folliage:Object in data.folliages)
         {
            objects.addItem(FolliageFactory.nonblockingFromObject(folliage));
         }
         planet.addAllObjects(objects);
         Folliage.setTerrainType(planet.terrainType, planet.folliages);
         
         return planet;
      }
      
      
      private static function addFakeTile
         (planet: Planet, orig: Tile, incrX: Boolean, incrY: Boolean) :void
      {
         var fake: Tile = orig.cloneFake ();
         if (incrX) fake.x++;
         if (incrY) fake.y++;
         planet.addTile (fake);
      }
   }
}