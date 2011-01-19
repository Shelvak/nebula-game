package models.factories
{
   import models.BaseModel;
   import models.folliage.Folliage;
   import models.planet.Planet;
   import models.solarsystem.MSSObject;
   import models.tile.Tile;
   
   import mx.collections.ArrayCollection;
   
   
   
   /**
    * Lets easily create instaces of planets. 
    */
   public class PlanetFactory
   {
      /**
       * Creates a planet form a given solar system objects with given tiles, buildings and folliages.
       * 
       * @return instance of <code>Planet</code> with values of properties
       * loaded from the data object.
       */	   
      public static function fromSSObject(ssObject:MSSObject,
                                          tiles:Array,
                                          buildings:Array,
                                          folliages:Array) : Planet
      {
         
         var planet:Planet = new Planet(ssObject);
         var objects:ArrayCollection = new ArrayCollection();
         
         for each (var t:Object in tiles)
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
         for each (var building:Object in buildings)
         {
            objects.addItem(BuildingFactory.fromObject(building));
         }
         for each (var folliage:Object in folliages)
         {
            objects.addItem(FolliageFactory.nonblockingFromObject(folliage));
         }
         planet.addAllObjects(objects);
         Folliage.setTerrainType(ssObject.terrain, planet.folliages);
         
         return planet;
      }
      
      
      private static function addFakeTile(planet:Planet, orig:Tile, incrX:Boolean, incrY:Boolean) : void
      {
         var fake: Tile = orig.cloneFake();
         if (incrX) fake.x++;
         if (incrY) fake.y++;
         planet.addTile(fake);
      }
   }
}