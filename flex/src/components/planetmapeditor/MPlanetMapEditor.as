package components.planetmapeditor
{
   import com.developmentarc.core.utils.EventBroker;

   import components.base.viewport.ViewportZoomable;
   import components.map.planet.PlanetMap;
   import components.planetmapeditor.events.MPlanetMapEditorEvent;

   import flash.events.EventDispatcher;
   import flash.events.KeyboardEvent;

   import models.building.Building;
   import models.building.BuildingType;
   import models.building.CollectorT3;
   import models.building.MetalExtractor;
   import models.building.ZetiumExtractor;
   import models.folliage.BlockingFolliage;
   import models.planet.MPlanet;
   import models.planet.MPlanetObject;
   import models.solarsystem.MSSObject;
   import models.solarsystem.SSObjectType;
   import models.tile.FolliageTileKind;
   import models.tile.TerrainType;
   import models.tile.TileKind;

   import mx.collections.ArrayCollection;

   import utils.Events;
   import utils.Objects;
   import utils.StringUtil;
   import utils.undo.CommandInvoker;


   public class MPlanetMapEditor extends EventDispatcher
   {
      public const DEFAULT_MAP_NAME: String = "P";
      public const MAX_NAME_CHARS: int = 8;

      public const MAX_WIDTH: int = 50;
      public const MIN_WIDTH: int = 4;
      public const MAX_HEIGHT: int = 50;
      public const MIN_HEIGHT: int = 4;

      public static const MIN_BUILDING_LEVEL: int = 1;
      public static const MAX_BUILDING_LEVEL: int = 10;
      public static const MIN_NPC_LEVEL: int = 0;
      public static const MAX_NPC_LEVEL: int = 9;

      public const TERRAIN_TYPES: ArrayCollection = new ArrayCollection([
         TerrainType.GRASS,
         TerrainType.DESERT,
         TerrainType.MUD
      ]);

      public const TILE_KINDS: ArrayCollection = new ArrayCollection([
         new IRTileKindM(TileKind.REGULAR),
         new IRTileKindM(TileKind.JUNKYARD),
         new IRTileKindM(TileKind.NOXRIUM),
         new IRTileKindM(TileKind.SAND),
         new IRTileKindM(TileKind.TITAN),
         new IRTileKindM(TileKind.ORE),
         new IRTileKindM(TileKind.ZETIUM),
         new IRTileKindM(TileKind.GEOTHERMAL)
      ]);

      public const BUILDINGS: ArrayCollection = new ArrayCollection([
         newBuilding(BuildingType.MOTHERSHIP),
         newBuilding(BuildingType.HQ),
         newBuilding(BuildingType.BARRACKS),
         newBuilding(BuildingType.METAL_EXTRACTOR_T2),
         newBuilding(BuildingType.COLLECTOR_T2),
         newBuilding(BuildingType.ZETIUM_EXTRACTOR_T2),
         newBuilding(BuildingType.NPC_HALL),
         newBuilding(BuildingType.NPC_INFANTRY_FACTORY),
         newBuilding(BuildingType.NPC_GROUND_FACTORY),
         newBuilding(BuildingType.NPC_SPACE_FACTORY)
      ]);
      
      public const NPC_BUILDINGS: ArrayCollection = new ArrayCollection([
         newNpcBuilding(BuildingType.NPC_SOLAR_PLANT),
         newNpcBuilding(BuildingType.NPC_METAL_EXTRACTOR),
         newNpcBuilding(BuildingType.NPC_ZETIUM_EXTRACTOR),
         newNpcBuilding(BuildingType.NPC_GEOTHERMAL_PLANT),
         newNpcBuilding(BuildingType.NPC_COMMUNICATIONS_HUB),
         newNpcBuilding(BuildingType.NPC_TEMPLE),
         newNpcBuilding(BuildingType.NPC_RESEARCH_CENTER),
         newNpcBuilding(BuildingType.NPC_EXCAVATION_SITE),
         newNpcBuilding(BuildingType.NPC_JUMPGATE)
      ]);

      public const FOLIAGE: ArrayCollection = new ArrayCollection([
         newFoliage(FolliageTileKind._2X3),
         newFoliage(FolliageTileKind._2X4),
//         newFoliage(FolliageTileKind._3X2),
         newFoliage(FolliageTileKind._3X3),
         newFoliage(FolliageTileKind._3X4),
         newFoliage(FolliageTileKind._4X3),
         newFoliage(FolliageTileKind._4X4),
         newFoliage(FolliageTileKind._4X6),
         newFoliage(FolliageTileKind._6X2),
         newFoliage(FolliageTileKind._6X6)
      ]);

      private const COMMAND_INVOKER: CommandInvoker = new CommandInvoker();
      private function keyDownHandler(event: KeyboardEvent): void {
         if (event.ctrlKey) {
            if (event.charCode == charCode("z") && !event.shiftKey) {
               COMMAND_INVOKER.undo();
            }
            else if (event.charCode == charCode("y")
               || (event.charCode == charCode("z") && event.shiftKey)) {
               COMMAND_INVOKER.redo();
            }
         }
      }
      private function charCode(char:String): Number {
         return char.charCodeAt(0);
      }

      public function MPlanetMapEditor() {
         EventBroker.subscribe(KeyboardEvent.KEY_DOWN, keyDownHandler);
      }

      private var _terrainType:int = TerrainType.GRASS;
      [Bindable(event="terrainChange")]
      public function set terrainType(value:int): void {
         if (value != _terrainType) {
            _terrainType = value;
            for each (var tile:IRTileKindM in TILE_KINDS) {
               tile.terrainType = value;
            }
            var foliage:BlockingFolliage;
            for each (foliage in FOLIAGE) {
               foliage.terrainType = value;
            }
            for each (foliage in _planet.blockingFolliages) {
               foliage.terrainType = value;
            }
            renderBackground();
            dispatchEditorEvent(MPlanetMapEditorEvent.TERRAIN_CHANGE);
         }
      }
      public function get terrainType(): int {
         return _terrainType;
      }

      private var _selectedTileKind:IRTileKindM = TILE_KINDS[0];
      public function set selectedTileKind(value: IRTileKindM): void {
         if (value != null && _selectedTileKind != value) {
            _selectedTileKind = value;
            if (_terrainEditorLayer != null) {
               _terrainEditorLayer.setTile(value);
            }
         }
      }
      public function get selectedTileKind(): IRTileKindM {
         return _selectedTileKind;
      }

      private var _mapWidth:int = MIN_WIDTH;
      [Bindable(event="widthChange")]
      public function set mapWidth(value: int): void {
         Objects.paramInRangeNumbers(
            "value", MIN_WIDTH, MAX_WIDTH, value, true, true
         );
         if (_mapWidth != value) {
            _mapWidth = value;
            dispatchEditorEvent(MPlanetMapEditorEvent.WIDTH_CHANGE);
         }
      }
      public function get mapWidth(): int {
         return _mapWidth;
      }

      private var _mapHeight:int = MIN_HEIGHT;
      [Bindable(event="heightChange")]
      public function set mapHeight(value: int): void {
         Objects.paramInRangeNumbers(
            "value", MIN_HEIGHT, MAX_HEIGHT, value, true, true
         );
         if (_mapHeight != value) {
            _mapHeight = value;
            dispatchEditorEvent(MPlanetMapEditorEvent.HEIGHT_CHANGE);
         }
      }
      public function get mapHeight(): int {
         return _mapHeight;
      }

      private var _mapName:String = DEFAULT_MAP_NAME;
      [Bindable(event="nameChange")]
      public function set mapName(value: String): void {
         if (value == null) {
            return;
         }
         if (_mapName != value) {
            value = StringUtil.trim(value);
            if (value.length == 0) {
               value = DEFAULT_MAP_NAME;
            }
            dispatchEditorEvent(MPlanetMapEditorEvent.NAME_CHANGE);
            _mapName = value;
         }
      }
      public function get mapName(): String {
         return _mapName;
      }

      public var viewport: ViewportZoomable = null;

      
      /* ####################### */
      /* ### OBJECT TO ERECT ### */
      /* ####################### */

      private var _objectToErect: MPlanetObject = BUILDINGS[0];
      public function set objectToErect(value: MPlanetObject): void {
         if (_objectToErect != value) {
            _objectToErect = value;
            if (value != null) {
               value.x = 0;
               value.y = 0;
               if (value is Building) {
                  Building.setSize(Building(value));
               }
               else {
                  BlockingFolliage.setSize(BlockingFolliage(value));
               }
               if (_objectsEditorLayer != null) {
                  _objectsEditorLayer.setObject(value);
               }
            }
         }
      }
      public function get objectToErect(): MPlanetObject {
         return _objectToErect;
      }


      /* ############### */
      /* ### ACTIONS ### */
      /* ############### */

      private var _planet: MPlanet;
      private var _objectsEditorLayer: ObjectsEditorLayer;
      private var _terrainEditorLayer: TerrainEditorLayer;

      public function serializeMap(): String {
         if (_planet != null) {
            _planet.ssObject.name = _mapName;
            return new PlanetMapSerializer().serialize(_planet);
         }
         return null;
      }

      public function loadMap(data: String): void {
         createMap(new PlanetMapSerializer().deserialize(data));
         mapWidth = _planet.ssObject.width;
         mapHeight = _planet.ssObject.height;
         terrainType = _planet.ssObject.terrain;
         mapName = _planet.ssObject.name;
      }

      public function generateMap(): void {
         Objects.notNull(
            viewport,
            "[prop viewport] must be set before map can be generated"
         );
         const ssObject: MSSObject = new MSSObject();
         ssObject.terrain = _terrainType;
         ssObject.type = SSObjectType.PLANET;
         ssObject.width = _mapWidth;
         ssObject.height = _mapHeight;
         createMap(new MPlanet(ssObject));
      }

      private function createMap(planet: MPlanet): void {
         COMMAND_INVOKER.clear();
         _planet = planet;
         _objectsEditorLayer =
            new ObjectsEditorLayer(_objectToErect, COMMAND_INVOKER);
         _terrainEditorLayer =
            new TerrainEditorLayer(_selectedTileKind, COMMAND_INVOKER);
         const map: PlanetMap = new PlanetMap(
            _planet, _objectsEditorLayer, _terrainEditorLayer
         );
         map.viewport = viewport;
         viewport.content = map;
      }

      private function renderBackground(): void {
         if (_planet != null) {
            _planet.ssObject.terrain = _terrainType;
         }
      }


      /* ############### */
      /* ### HELPERS ### */
      /* ############### */

      private function dispatchEditorEvent(type:String): void {
         Events.dispatchSimpleEvent(this, MPlanetMapEditorEvent, type);
      }

      private function newFoliage(kind: int): BlockingFolliage {
         const foliage: BlockingFolliage = new BlockingFolliage();
         foliage.kind = kind;
         return foliage;
      }

      private function newNpcBuilding(type:String): Building {
         return newBuilding(type, MIN_NPC_LEVEL);
      }

      public static function newBuilding(type: String,
                                         level: int = MIN_BUILDING_LEVEL): Building {
         var building:Building;
         switch (type) {
            case BuildingType.GEOTHERMAL_PLANT:
            case BuildingType.NPC_GEOTHERMAL_PLANT:
               building = new CollectorT3();
               break;
            case BuildingType.METAL_EXTRACTOR:
            case BuildingType.METAL_EXTRACTOR_T2:
            case BuildingType.NPC_METAL_EXTRACTOR:
               building = new MetalExtractor();
               break;
            case BuildingType.ZETIUM_EXTRACTOR:
            case BuildingType.ZETIUM_EXTRACTOR_T2:
            case BuildingType.NPC_ZETIUM_EXTRACTOR:
               building = new ZetiumExtractor();
               break;
            default:
               building = new Building();
         }
         building.type = type;
         building.planetId = 1;
         building.level = building.npc ? 1 : level;
         building.metaLevel = building.npc ? level : 0;
         Building.setSize(building);
         return building;
      }

      public static function cloneObject(object: MPlanetObject): MPlanetObject {
         return object is Building
                   ? cloneBuilding(object as Building)
                   : cloneFoliage(object as BlockingFolliage);
      }

      private static function cloneFoliage(foliage: BlockingFolliage): BlockingFolliage {
         const clone: BlockingFolliage = new BlockingFolliage();
         clone.kind = foliage.kind;
         clone.terrainType = foliage.terrainType;
         copyDimensions(foliage, clone);
         return clone;
      }

      private static function cloneBuilding(building: Building): Building {
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

      private static function copyDimensions(source: MPlanetObject,
                                              destination: MPlanetObject): void {
         destination.x = source.x;
         destination.y = source.y;
         destination.xEnd = source.xEnd;
         destination.yEnd = source.yEnd;
      }
   }
}
