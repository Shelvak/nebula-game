package models.factories
{
   import controllers.objects.ObjectClass;
   
   import models.BaseModel;
   import models.building.Building;
   import models.constructionqueueentry.ConstructionQueueEntry;
   import models.folliage.Folliage;
   import models.folliage.NonblockingFolliage;
   import models.planet.MPlanet;
   import models.planet.MPlanetObject;
   import models.solarsystem.MSSObject;
   import models.tile.Tile;
   
   import mx.collections.ArrayCollection;
   
   import utils.ModelUtil;
   import utils.datastructures.Collections;
   
   
   
   /**
    * Lets easily create instaces of planets. 
    */
   public class PlanetFactory
   {
      /**
       * Creates a planet form a given solar system objects with given tiles, buildings and folliages.
       * 
       * @return instance of <code>MPlanet</code> with values of properties
       * loaded from the data object.
       */	   
      public static function fromSSObject(ssObject:MSSObject,
                                          tiles:Array,
                                          buildings:Array,
                                          folliages:Array) : MPlanet
      {
         
         var planet:MPlanet = new MPlanet(ssObject);
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
            var b:Building = BuildingFactory.fromObject(building);
            objects.addItem(b);
            if (b.isConstructor(ObjectClass.BUILDING))
            {
               for each (var queueEntry:ConstructionQueueEntry in b.constructionQueueEntries)
               {
                  objects.addItem(BuildingFactory.createGhost(
                     ModelUtil.getModelSubclass(queueEntry.constructableType),
                     queueEntry.params.x,
                     queueEntry.params.y,
                     b.id,
                     queueEntry.prepaid
                  ));
               }
            }
         }
         for each (var genericFolliage:Object in folliages)
         {
            var folliage:NonblockingFolliage = FolliageFactory.nonblockingFromObject(genericFolliage);
            var object:MPlanetObject = Collections.findFirst(objects,
               function(object:MPlanetObject) : Boolean
               {
                  return object.fallsIntoArea(folliage.x, folliage.xEnd, folliage.y, folliage.yEnd);
               }
            );
            if (object == null)
            {
               objects.addItem(folliage);
            }
         }
         planet.addAllObjects(objects);
         Folliage.setTerrainType(ssObject.terrain, planet.folliages);
         
         return planet;
      }
      
      
      private static function addFakeTile(planet:MPlanet, orig:Tile, incrX:Boolean, incrY:Boolean) : void
      {
         var fake: Tile = orig.cloneFake();
         if (incrX) fake.x++;
         if (incrY) fake.y++;
         planet.addTile(fake);
      }
   }
}