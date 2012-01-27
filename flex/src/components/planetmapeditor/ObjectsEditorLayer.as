package components.planetmapeditor
{
   import components.map.planet.PlanetMap;
   import components.map.planet.PlanetObjectsLayer;
   import components.map.planet.objects.BlockingFolliageMapObject;
   import components.map.planet.objects.IPrimitivePlanetMapObject;
   import components.map.planet.objects.InteractivePlanetMapObject;
   import components.map.planet.objects.MapBuilding;

   import flash.events.MouseEvent;

   import models.building.Building;
   import models.building.Extractor;
   import models.folliage.BlockingFolliage;
   import models.planet.MPlanet;
   import models.planet.MPlanetObject;
   import models.tile.TileKind;

   import mx.collections.ListCollectionView;

   import utils.Objects;


   public class ObjectsEditorLayer extends MapEditorLayer
   {
      override protected function get componentClass(): Class {
         return InteractivePlanetMapObject;
      }

      override protected function get modelClass(): Class {
         return MPlanetObject;
      }

      override protected function get objectsList(): ListCollectionView {
         return planet.objects;
      }

      public function ObjectsEditorLayer(initialObject:MPlanetObject) {
         super();
         _initialObject = Objects.paramNotNull("initialObject", initialObject);
      }

      private var _initialObject:MPlanetObject;
      private var _objectPlaceholder:CObjectPlaceholder =
                     new CObjectPlaceholder();

      override public function initialize(objectsLayer: PlanetObjectsLayer,
                                          map: PlanetMap,
                                          planet: MPlanet): void {
         super.initialize(objectsLayer, map, planet);
         _objectPlaceholder.initModel(_initialObject);
         _objectPlaceholder.visible = false;
         _objectPlaceholder.depth = Number.MAX_VALUE;
         objectsLayer.addObject(_objectPlaceholder);
         activationKeyUp();
         _initialObject = null;
      }

      override protected function addObjectImpl(object: MPlanetObject): IPrimitivePlanetMapObject {
         var component:InteractivePlanetMapObject = null;
         if (object is Building) {
            component = new MapBuilding();
         }
         else if (object is BlockingFolliage) {
            component = new BlockingFolliageMapObject();
         }
         else {
            throw new Error("Unsupported object type: " + object.CLASS);
         }
         component.initModel(object);
         objectsLayer.addObject(component);
         return component;
      }

      override protected function activationKeyUp(): void {
         objectsLayer.passOverMouseEventsTo(this);
         _objectPlaceholder.visible = true;
         moveObjectToMouse(_objectPlaceholder);
      }

      override protected function activationKeyDown(): void {
         _objectPlaceholder.visible = false;
      }

      override protected function mouseOverHandler(event: MouseEvent): void {
         moveObjectToMouse(_objectPlaceholder);
      }

      override protected function mouseMoveHandler(event: MouseEvent): void {
         moveObjectToMouse(_objectPlaceholder);
      }

      override protected function clickHandler(event: MouseEvent): void {
         const object: MPlanetObject = _objectPlaceholder.model;
         if (!planet.isObjectOnMap(object)) {
            return;
         }
         const building: Building = object as Building;
         const foliage: BlockingFolliage = object as BlockingFolliage;
         planet.forEachPointUnder(
            object, false, true,
            function(x: int, y: int): void {
               const objectUnder:MPlanetObject = planet.getObject(x, y);
               if (objectUnder != null) {
                  planet.removeObject(objectUnder);
               }
               if (object is BlockingFolliage
                      || !building.npc
                      || building.isTileRestricted(planet.getTileKind(x, y))) {
                  planet.removeTile(x, y);
               }
            }
         );
         if (object is Building) {
            planet.forEachPointUnder(
               object, true, true,
               function(x: int, y: int): void {
                  const objectUnder:MPlanetObject = planet.getObject(x, y);
                  if (objectUnder is Building) {
                     planet.removeObject(objectUnder);
                  }
                  if (TileKind.isResourceKind(planet.getTileKind(x, y))) {
                     planet.removeTile(x, y);
                  }
               }
            );
            if (building.isExtractor) {
               planet.addTile(
                  Extractor(building).baseResource, building.x, building.y
               );
            }
         }
         planet.addObject(
            object is Building ? cloneBuilding(building) : cloneFoliage(foliage)
         );
         map.renderBackground(false);
      }

      private function cloneFoliage(foliage: BlockingFolliage): BlockingFolliage {
         const clone: BlockingFolliage = new BlockingFolliage();
         clone.kind = foliage.kind;
         clone.terrainType = foliage.terrainType;
         copyDimensions(foliage, clone);
         return clone;
      }

      private function cloneBuilding(building: Building): Building {
         const clone: Building = new building.CLASS();
         clone.id = 1;
         clone.planetId = building.planetId;
         clone.type = building.type;
         clone.level = Math.min(building.level, building.maxLevel);
         clone.hp = clone.hpMax;
         clone.state = Building.ACTIVE;
         copyDimensions(building, clone);
         return clone;
      }

      private function copyDimensions(source:MPlanetObject,
                                      destination:MPlanetObject): void {
         destination.x = source.x;
         destination.y = source.y;
         destination.xEnd = source.xEnd;
         destination.yEnd = source.yEnd;
      }

      /* ################################ */
      /* ### INTERFACE FOR MAP EDITOR ### */
      /* ################################ */

      public function setObject(object:MPlanetObject): void {
         _objectPlaceholder.initModel(object);
      }
   }
}
