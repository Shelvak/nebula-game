package tests.planetmapeditor
{
   import components.base.viewport.ViewportZoomable;
   import components.planetmapeditor.IRTileKindM;
   import components.planetmapeditor.MPlanetMapEditor;
   import components.planetmapeditor.events.MPlanetMapEditorEvent;

   import ext.hamcrest.events.causes;
   import ext.hamcrest.object.equals;

   import models.building.Building;
   import models.building.BuildingType;
   import models.folliage.BlockingFolliage;
   import models.tile.TerrainType;
   import models.tile.TileKind;

   import org.flexunit.assertThat;
   import org.hamcrest.object.strictlyEqualTo;


   public class TC_MPlanetMapEditor
   {
      private var editor: MPlanetMapEditor;

      [Before]
      public function setUp(): void {
          editor = new MPlanetMapEditor()
      }

      [After]
      public function tearDown(): void {
         editor = null;
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
         assertThat(
            "default terrain type is TerrainType.GRASS",
            editor.terrainType, equals (TerrainType.GRASS)
         );
         
         editor.terrainType = TerrainType.MUD;
         for each (var foliage:BlockingFolliage in editor.FOLIAGE) {
            assertThat(
               "foliage terrain changed",
               foliage.terrainType, equals (TerrainType.MUD)
            );
         }
         for each (var tile:IRTileKindM in editor.TILE_KINDS) {
            assertThat(
               "tile terrain changed",
               tile.terrainType, equals (TerrainType.MUD)
            );
         }
      }

      [Test]
      public function widthAndHeight(): void {
         assertThat(
            "default width", editor.mapWidth, equals (editor.MIN_WIDTH)
         );
         assertThat(
            "default height", editor.mapHeight, equals (editor.MIN_HEIGHT)
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

         const building:Building = newBuilding(BuildingType.HEALING_CENTER);
         editor.generateMap(new ViewportZoomable());
         editor.objectToErect = building;
         assertThat(
            "setting to new value should change the property",
            editor.objectToErect, strictlyEqualTo (building)
         );
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
