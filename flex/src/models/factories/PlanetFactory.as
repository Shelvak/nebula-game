package models.factories
{
   import controllers.objects.ObjectClass;

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
    * Lets easily create instances of planets.
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
                                          foliage:Array) : MPlanet {
         var planet:MPlanet = new MPlanet(ssObject);
         var objects:ArrayCollection = new ArrayCollection();
         for each (var t: Object in tiles) {
            var tile: Tile = TileFactory.fromObject(t);
            if (tile.isFolliage()) {
               objects.addItem(FolliageFactory.blocking(tile));
            }
            else {
               planet.addTile(tile.kind, tile.x, tile.y);
            }
         }
         for each (var building: Object in buildings) {
            var buildingModel: Building = BuildingFactory.fromObject(building);
            objects.addItem(buildingModel);
            if (buildingModel.isConstructor(ObjectClass.BUILDING)) {
               for each (var queueEntry:ConstructionQueueEntry
                                 in buildingModel.constructionQueueEntries) {
                  objects.addItem(BuildingFactory.createGhost(
                     ModelUtil.getModelSubclass(queueEntry.constructableType),
                     queueEntry.params.x,
                     queueEntry.params.y,
                     buildingModel.id,
                     queueEntry.prepaid
                  ));
               }
            }
         }
         for each (var genericFoliage: Object in foliage) {
            var foliageModel: NonblockingFolliage =
                   FolliageFactory.nonblockingFromObject(genericFoliage);
            var object: MPlanetObject = Collections.findFirst(
               objects,
               function(object: MPlanetObject): Boolean {
                  return object.fallsIntoArea(
                     foliageModel.x, foliageModel.xEnd,
                     foliageModel.y, foliageModel.yEnd
                  );
               }
            );
            if (object == null) {
               objects.addItem(foliageModel);
            }
         }
         planet.addAllObjects(objects);
         Folliage.setTerrainType(ssObject.terrain, planet.folliages);
         
         return planet;
      }
   }
}