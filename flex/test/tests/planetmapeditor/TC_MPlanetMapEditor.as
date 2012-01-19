package tests.planetmapeditor
{
   import components.planetmapeditor.IRTileKindM;
   import components.planetmapeditor.MPlanetMapEditor;
   import components.planetmapeditor.events.MPlanetMapEditorEvent;

   import config.Config;

   import ext.hamcrest.events.causes;
   import ext.hamcrest.object.equals;

   import models.building.Building;

   import models.building.Building;
   import models.building.BuildingType;
   import models.folliage.BlockingFolliage;
   import models.tile.FolliageTileKind;

   import models.tile.TerrainType;
   import models.tile.TileKind;

   import org.flexunit.assertThat;
   import org.hamcrest.object.hasProperties;
   import org.hamcrest.object.instanceOf;
   import org.hamcrest.object.nullValue;
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

         var b:Building = newBuilding(BuildingType.HEALING_CENTER);
         editor.objectToErect = b;
         assertThat(
            "setting to new value should change the property",
            editor.objectToErect, strictlyEqualTo (b)
         );

         Config.setConfig({
            "buildings.healingCenter.npc": false,
            "buildings.npcSpaceFactory.npc": true
         });

         assertThat(
            "when objectToErect is building, erectBuilding returns objectToErect",
            editor, hasProperties({
               "erectBuilding": strictlyEqualTo (editor.objectToErect),
               "erectNpcBuilding": nullValue(),
               "erectFoliage": nullValue()
            })
         );

         editor.objectToErect = newBuilding(BuildingType.NPC_SPACE_FACTORY)
         assertThat(
            "when objectToErect is npc building, erectNpcBuilding returns objectToErect",
            editor, hasProperties({
               "erectBuilding": nullValue(),
               "erectNpcBuilding": strictlyEqualTo (editor.objectToErect),
               "erectFoliage": nullValue()
            })
         );

         editor.objectToErect = newFoliage(FolliageTileKind._3X3);
         assertThat(
            "when objectToErect is foliage, erectFoliage returns objectToErect",
            editor, hasProperties({
               "erectBuilding": nullValue(),
               "erectNpcBuilding": nullValue(),
               "erectFoliage": strictlyEqualTo (editor.objectToErect)
            })
         );
      }

      private function newFoliage(kind:int): BlockingFolliage {
         var foliage:BlockingFolliage = new BlockingFolliage();
         foliage.kind = kind;
         return foliage;
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
