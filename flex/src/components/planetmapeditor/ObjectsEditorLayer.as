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
   import models.folliage.BlockingFolliage;
   import models.planet.MPlanet;
   import models.planet.MPlanetObject;

   import mx.collections.ListCollectionView;

   import utils.Objects;
   import utils.undo.CommandInvoker;


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

      public function ObjectsEditorLayer(initialObject:MPlanetObject,
                                         commandInvoker:CommandInvoker) {
         super();
         _initialObject = Objects.paramNotNull("initialObject", initialObject);
         _commandInvoker = Objects.paramNotNull("commandInvoker", commandInvoker);
      }

      private var _commandInvoker: CommandInvoker = null;
      private var _initialObject: MPlanetObject = null;
      private var _objectPlaceholder: CObjectPlaceholder =
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
         const command: AddObjectCommand = new AddObjectCommand(
            map, planet, cloneObject(object)
         );
         command.execute();
         _commandInvoker.addCommand(command);
      }
      

      /* ################################ */
      /* ### INTERFACE FOR MAP EDITOR ### */
      /* ################################ */

      public function setObject(object:MPlanetObject): void {
         _objectPlaceholder.initModel(object);
      }
   }
}


import components.map.planet.PlanetMap;

import models.building.Building;
import models.building.Extractor;
import models.folliage.BlockingFolliage;
import models.planet.MPlanet;
import models.planet.MPlanetObject;
import models.tile.Tile;
import models.tile.TileKind;

import utils.undo.ICommand;


class AddObjectCommand implements ICommand
{
   private var _map: PlanetMap;
   private var _planet: MPlanet;
   private var _objectToAdd: MPlanetObject;
   private var _tileAdded: Tile = null;
   private var _objectsRemoved: Array = new Array();
   private var _tilesRemoved: Array = new Array();

   private function removeObject(x: int, y: int): void {
      const object: MPlanetObject = _planet.getObject(x, y);
      if (object != null) {
         const clone: MPlanetObject = cloneObject(object);
         const removed: Boolean = _planet.removeObject(object) != null;
         if (removed)
            _objectsRemoved.push(clone);
         }
   }

   private function removeTile(x: int, y: int): void {
      const removed: Tile = _planet.removeTile(x, y);
      if (removed != null) {
         _tilesRemoved.push(removed);
      }
   }

   public function AddObjectCommand(map: PlanetMap,
                                    planet: MPlanet,
                                    objectToAdd: MPlanetObject) {
      _map = map;
      _planet = planet;
      _objectToAdd = objectToAdd;
   }

   public function execute(): void {
      const building: Building = _objectToAdd as Building;
      _planet.forEachPointUnder(
         _objectToAdd, false, true,
         function(x: int, y: int): void {
            removeObject(x, y);
            if (_objectToAdd is BlockingFolliage
                   || !building.npc
                   || building.isTileRestricted(_planet.getTileKind(x, y))) {
               removeTile(x, y);
            }
         }
      );
      if (_objectToAdd is Building) {
         _planet.forEachPointUnder(
            _objectToAdd, true, true,
            function(x: int, y: int): void {
               removeObject(x, y);
               if (TileKind.isResourceKind(_planet.getTileKind(x, y))) {
                  removeTile(x, y);
               }
            }
         );
         if (building.isExtractor) {
            _planet.addTile(
               Extractor(building).baseResource, building.x, building.y
            );
            _tileAdded = _planet.getTile(building.x, building.y);
         }
      }
      _planet.addObject(cloneObject(_objectToAdd));
      _map.renderBackground(false);
   }

   public function undo(): void {
      _planet.removeObject(_planet.getObject(_objectToAdd.x, _objectToAdd.y));
      if (_tileAdded != null) {
         _planet.removeTile(_tileAdded.x, _tileAdded.y);
      }
      _tileAdded = null;
      for each (var object: MPlanetObject in _objectsRemoved) {
         _planet.addObject(object);
      }
      _objectsRemoved = new Array();
      for each (var tileRemoved: Tile in _tilesRemoved) {
         _planet.addTile(tileRemoved.kind, tileRemoved.x, tileRemoved.y);
      }
      _tilesRemoved = new Array();
      _map.renderBackground(false);
   }
}

function cloneObject(object: MPlanetObject): MPlanetObject {
   return object is Building
             ? cloneBuilding(object as Building)
             : cloneFoliage(object as BlockingFolliage);
}

function cloneFoliage(foliage: BlockingFolliage): BlockingFolliage {
   const clone: BlockingFolliage = new BlockingFolliage();
   clone.kind = foliage.kind;
   clone.terrainType = foliage.terrainType;
   copyDimensions(foliage, clone);
   return clone;
}

function cloneBuilding(building: Building): Building {
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

function copyDimensions(source: MPlanetObject,
                        destination: MPlanetObject): void {
   destination.x = source.x;
   destination.y = source.y;
   destination.xEnd = source.xEnd;
   destination.yEnd = source.yEnd;
}