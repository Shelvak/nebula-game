package tests.planetmapeditor
{
   import components.base.viewport.ViewportZoomable;
   import components.map.planet.TileMaskType;
   import components.planetmapeditor.IRTileKindM;
   import components.planetmapeditor.MPlanetMapEditor;
   import components.planetmapeditor.events.MPlanetMapEditorEvent;

   import config.Config;

   import ext.hamcrest.events.causes;
   import ext.hamcrest.object.equals;

   import models.building.Building;
   import models.building.BuildingType;
   import models.folliage.BlockingFolliage;
   import models.map.MapDimensionType;
   import models.tile.TerrainType;
   import models.tile.TileKind;

   import org.flexunit.assertThat;
   import org.hamcrest.object.strictlyEqualTo;

   import testsutils.ImageUtl;

   import utils.ObjectPropertyType;
   import utils.Objects;
   import utils.assets.AssetNames;


   public class TC_MPlanetMapEditor
   {
      private var editor: MPlanetMapEditor;

      [Before]
      public function setUp(): void {
         editor = new MPlanetMapEditor();
         editor.viewport = new ViewportZoomable();
      }

      [After]
      public function tearDown(): void {
         editor = null;
         Config.setConfig(new Object());
         ImageUtl.tearDown();
      }

      [Test]
      public function selectedTileKind(): void {
         assertThat(
            "default is null",
            editor.selectedTileKind, equals (editor.TILE_KINDS[0])
         );

         editor.selectedTileKind = newTile(TileKind.GEOTHERMAL);
         assertThat(
            "selection changed",
            editor.selectedTileKind, equals (newTile(TileKind.GEOTHERMAL))
         );
      }

      [Test]
      public function terrainType(): void {
         Objects.forEachStaticValue(
            TerrainType, ObjectPropertyType.STATIC_CONST,
            function(terrainType: int): void {
               ImageUtl.add(AssetNames.getRegularTileImageName(terrainType));
               ImageUtl.add(AssetNames.get3DPlaneImageName(
                  terrainType, MapDimensionType.HEIGHT
               ));
               ImageUtl.add(AssetNames.get3DPlaneImageName(
                  terrainType, MapDimensionType.WIDHT
               ));
            }
         );
         Objects.forEachStaticValue(
            TileMaskType, ObjectPropertyType.STATIC_CONST,
            function(maskType: String): void {
               ImageUtl.add(AssetNames.getTileMaskImageName(maskType));
            }
         );

         assertThat(
            "default terrain type is TerrainType.GRASS",
            editor.terrainType, equals (TerrainType.GRASS)
         );

         editor.generateMap();

         assertThat(
            "changing terrain type dispatches event",
            function():void{ editor.terrainType = TerrainType.DESERT },
            causes (editor) .toDispatchEvent (MPlanetMapEditorEvent.TERRAIN_CHANGE)
         );

         editor.terrainType = TerrainType.MUD;
         for each (var foliage: BlockingFolliage in editor.FOLIAGE) {
            assertThat(
               "foliage terrain changed",
               foliage.terrainType, equals (TerrainType.MUD)
            );
         }
         for each (var tile: IRTileKindM in editor.TILE_KINDS) {
            assertThat(
               "tile terrain changed",
               tile.terrainType, equals (TerrainType.MUD)
            );
         }
      }

      [Test]
      public function widthAndHeight(): void {
         assertThat(
            "default width", editor.mapWidth, equals (30)
         );
         assertThat(
            "default height", editor.mapHeight, equals (30)
         );

         editor.mapWidth = 10;
         assertThat( "width changed", editor.mapWidth, equals (10) );
         editor.mapHeight = 10;
         assertThat( "height changed", editor.mapHeight, equals (10) );

         assertThat(
            "changing width dispatches event",
            function():void{ editor.mapWidth = 20 },
            causes (editor) .toDispatchEvent (MPlanetMapEditorEvent.WIDTH_CHANGE)
         );
         assertThat(
            "changing height dispatches event",
            function():void{ editor.mapHeight = 20 },
            causes (editor) .toDispatchEvent (MPlanetMapEditorEvent.HEIGHT_CHANGE)
         );
      }

      [Test]
      public function objectToErect(): void {
         assertThat(
            "default is first building in BUILDINGS",
            editor.objectToErect, strictlyEqualTo (editor.BUILDINGS[0])
         );

         Config.setConfig({
            "buildings.healingCenter.width": 2,
            "buildings.healingCenter.height": 2
         });
         const building:Building = newBuilding(BuildingType.HEALING_CENTER);
         editor.generateMap();
         editor.objectToErect = building;
         assertThat(
            "setting to new value should change the property",
            editor.objectToErect, strictlyEqualTo (building)
         );
      }

      [Test]
      public function mapName(): void {
         assertThat(
            "default map name",
            editor.mapName, equals (editor.DEFAULT_MAP_NAME)
         );

         assertThat(
            "changing name dispatches event",
            function():void{ editor.mapName = "Name" },
            causes (editor) .toDispatchEvent (MPlanetMapEditorEvent.NAME_CHANGE)
         );
         assertThat( "name changed", editor.mapName, equals ("Name") );
      }

      private function newBuilding(type:String): Building {
         const building:Building = new Building();
         building.type = type;
         return building;
      }

      private function newTile(kind:int,
                               terrain:int = TerrainType.GRASS): IRTileKindM {
         return new IRTileKindM(kind, terrain);
      }
   }
}
