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
            map, planet, MPlanetMapEditor.cloneObject(object)
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
import components.planetmapeditor.MPlanetMapEditor;
import components.planetmapeditor.MapEditCommand;

import models.building.Building;
import models.building.Extractor;
import models.folliage.BlockingFolliage;
import models.planet.MPlanet;
import models.planet.MPlanetObject;
import models.tile.Tile;
import models.tile.TileKind;

import utils.undo.ICommand;


class AddObjectCommand extends MapEditCommand implements ICommand
{
   private var _objectToAdd: MPlanetObject;
   private var _tileAdded: Tile = null;

   public function AddObjectCommand(map: PlanetMap,
                                    planet: MPlanet,
                                    objectToAdd: MPlanetObject) {
      super(map, planet);
      _objectToAdd = objectToAdd;
   }

   public function execute(): void {
      const building: Building = _objectToAdd as Building;
      planet.forEachPointUnder(
         _objectToAdd, false, true,
         function(x: int, y: int): void {
            removeObjectToRestore(x, y);
            if (_objectToAdd is BlockingFolliage
                   || !building.npc
                   || building.isTileRestricted(planet.getTileKind(x, y))) {
               removeTileToRestore(x, y);
            }
         }
      );
      if (_objectToAdd is Building) {
         planet.forEachPointUnder(
            _objectToAdd, true, true,
            function(x: int, y: int): void {
               removeObjectToRestore(x, y);
               if (TileKind.isResourceKind(planet.getTileKind(x, y))) {
                  removeTileToRestore(x, y);
               }
            }
         );
         if (building.isExtractor) {
            planet.addTile(
               Extractor(building).baseResource, building.x, building.y
            );
            _tileAdded = planet.getTile(building.x, building.y);
         }
      }
      planet.addObject(MPlanetMapEditor.cloneObject(_objectToAdd));
      map.renderBackground(false);
   }

   public function undo(): void {
      planet.removeObject(planet.getObject(_objectToAdd.x, _objectToAdd.y));
      if (_tileAdded != null) {
         planet.removeTile(_tileAdded.x, _tileAdded.y);
      }
      restoreRemoved();
   }
}