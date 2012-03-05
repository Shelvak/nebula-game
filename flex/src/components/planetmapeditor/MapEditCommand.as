package components.planetmapeditor
{
   import components.map.planet.PlanetMap;

   import models.planet.MPlanet;
   import models.planet.MPlanetObject;
   import models.tile.Tile;

   import utils.Objects;


   public class MapEditCommand
   {
      protected var map: PlanetMap;
      protected var planet: MPlanet;

      private var _objectsRemoved:Array = new Array();
      private var _tilesRemoved:Array = new Array();

      protected function removeObjectToRestore(x: int, y: int): Boolean {
         const object: MPlanetObject = planet.getObject(x, y);
         var removed: Boolean = false;
         if (object != null) {
            const clone: MPlanetObject = MPlanetMapEditor.cloneObject(object);
            removed = planet.removeObject(object) != null;
            if (removed) {
               _objectsRemoved.push(clone);
            }
         }
         return removed;
      }

      protected function removeTileToRestore(x: int, y: int): void {
         const removed: Tile = planet.removeTile(x, y);
         if (removed != null) {
            _tilesRemoved.push(removed);
         }
      }

      public function MapEditCommand(map: PlanetMap, planet: MPlanet) {
         this.map = Objects.paramNotNull("map", map);
         this.planet = Objects.paramNotNull("planet", planet);
      }

      protected function restoreRemoved(): void {
         for each (var object: MPlanetObject in _objectsRemoved) {
            planet.addObject(object);
         }
         _objectsRemoved = new Array();
         
         for each (var tileRemoved: Tile in _tilesRemoved) {
            planet.addTile(tileRemoved.kind, tileRemoved.x, tileRemoved.y);
         }
         _tilesRemoved = new Array();
         map.renderBackground(false);
      }
   }
}
