package components.planetmapeditor
{
   import components.base.viewport.Viewport;
   import components.base.viewport.ViewportZoomable;
   import components.map.planet.PlanetMap;
   import components.planetmapeditor.events.MPlanetMapEditorEvent;

   import flash.events.EventDispatcher;

   import models.building.Building;
   import models.building.BuildingType;
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
      private const PLANET_ID:int = 1;

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
            for each (var foliage:BlockingFolliage in FOLIAGE) {
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
         Objects.paramNotNull("value", value);
         if (_selectedTileKind != value) {
            _selectedTileKind = value;
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
         }
      }
      public function get objectToErect(): MPlanetObject {
         return _objectToErect;
      }

      public function get erectBuilding(): Building {
         const building:Building = _objectToErect as Building;
         if (building != null && !building.npc) {
            return building;
         }
         return null;
      }

      public function get erectNpcBuilding(): Building {
         const building:Building = _objectToErect as Building;
         if (building != null && building.npc) {
            return building;
         }
         return null;
      }

      public function get erectFoliage(): BlockingFolliage {
         return _objectToErect as BlockingFolliage;
      }


      /* ############### */
      /* ### ACTIONS ### */
      /* ############### */

      private var _planet:MSSObject;

      public function generateMap(viewport:ViewportZoomable): void {
         Objects.paramNotNull("viewport", viewport);
         if (_planet != null) {
            _planet.cleanup();
         }
         _planet = new MSSObject();
         _planet.terrain = _terrainType;
         _planet.type = SSObjectType.PLANET;
         _planet.width = _mapWidth;
         _planet.height = _mapHeight;
         viewport.content = new PlanetMap(new MPlanet(_planet));
      }

      private function renderBackground(): void {
         if (_planet != null) {
            _planet.terrain = _terrainType;
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

      private function newBuilding(type:String, level:int): Building {
         var building:Building = new Building();
         building.type = type;
         building.planetId = PLANET_ID;
         building.level = level;
         return building;
      }
   }
}
