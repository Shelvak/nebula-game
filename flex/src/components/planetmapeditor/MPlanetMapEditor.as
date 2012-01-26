package components.planetmapeditor
{
   import components.base.viewport.ViewportZoomable;
   import components.map.planet.PlanetMap;
   import components.planetmapeditor.events.MPlanetMapEditorEvent;

   import flash.events.EventDispatcher;

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


   public class MPlanetMapEditor extends EventDispatcher
   {
      public const MAX_WIDTH:int = 30;
      public const MIN_WIDTH:int = 4;
      public const MAX_HEIGHT:int = 30;
      public const MIN_HEIGHT:int = 4;

      public const MIN_BUILDING_LEVEL:int = 1;
      public const MAX_BUILDING_LEVEL:int = 10;
      public const MIN_NPC_LEVEL:int = 0;
      public const MAX_NPC_LEVEL:int = 9;

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
         newBuilding(BuildingType.METAL_EXTRACTOR_T2, MIN_BUILDING_LEVEL),
         newBuilding(BuildingType.GEOTHERMAL_PLANT, MIN_BUILDING_LEVEL),
         newBuilding(BuildingType.HQ, MIN_BUILDING_LEVEL)
      ]);
      
      public const NPC_BUILDINGS: ArrayCollection = new ArrayCollection([
         newBuilding(BuildingType.NPC_GROUND_FACTORY, MIN_NPC_LEVEL),
         newBuilding(BuildingType.NPC_HALL, MIN_NPC_LEVEL),
         newBuilding(BuildingType.NPC_SPACE_FACTORY, MIN_NPC_LEVEL)
      ]);

      public const FOLIAGE: ArrayCollection = new ArrayCollection([
         newFoliage(FolliageTileKind._3X3),
         newFoliage(FolliageTileKind._3X4),
         newFoliage(FolliageTileKind._4X3),
         newFoliage(FolliageTileKind._4X4),
         newFoliage(FolliageTileKind._4X6),
         newFoliage(FolliageTileKind._6X2),
         newFoliage(FolliageTileKind._6X6)
      ]);

      private var _terrainType:int = TerrainType.GRASS;
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

      /* ####################### */
      /* ### OBJECT TO ERECT ### */
      /* ####################### */

      private var _objectToErect:MPlanetObject = BUILDINGS[0];
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

      public function generateMap(viewport:ViewportZoomable): void {
         Objects.paramNotNull("viewport", viewport);
         const ssObject: MSSObject = new MSSObject();
         ssObject.terrain = _terrainType;
         ssObject.type = SSObjectType.PLANET;
         ssObject.width = _mapWidth;
         ssObject.height = _mapHeight;
         _objectsEditorLayer = new ObjectsEditorLayer(_objectToErect);
         _terrainEditorLayer = new TerrainEditorLayer(_selectedTileKind);
         _planet = new MPlanet(ssObject);
         const map:PlanetMap = new PlanetMap(
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

      private function newFoliage(kind:int): BlockingFolliage {
         const foliage:BlockingFolliage = new BlockingFolliage();
         foliage.kind = kind;
         return foliage;
      }

      public static function newBuilding(type:String, level:int): Building {
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
         building.level = level;
         Building.setSize(building);
         return building;
      }
   }
}
