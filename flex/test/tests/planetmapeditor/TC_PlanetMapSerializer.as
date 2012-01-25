package tests.planetmapeditor
{
   import components.planetmapeditor.PlanetMapSerializer;

   import config.Config;

   import ext.hamcrest.object.equals;

   import flash.geom.Point;

   import models.building.Building;
   import models.building.BuildingType;
   import models.folliage.BlockingFolliage;
   import models.folliage.BlockingFolliage;

   import models.planet.MPlanet;
   import models.solarsystem.MSSObject;
   import models.solarsystem.SSObjectType;
   import models.tile.FolliageTileKind;
   import models.tile.Tile;
   import models.tile.TileKind;

   import org.flexunit.assertThat;


   public class TC_PlanetMapSerializer
   {
      [Before]
      public function setUp(): void {
         Config.setConfig({
            "buildings.barracks.width": 2,
            "buildings.barracks.height": 2,
            "buildings.barracks.npc": false,
            "buildings.metalExtractorT2.width": 2,
            "buildings.metalExtractorT2.height": 2,
            "buildings.metalExtractorT2.npc": false,
            "buildings.npcHall.width": 2,
            "buildings.npcHall.height": 2,
            "buildings.npcHall.npc": true,
            "buildings.npcZetiumExtractor.width": 2,
            "buildings.npcZetiumExtractor.height": 2,
            "buildings.npcZetiumExtractor.npc": true
         });
      }

      [After]
      public function tearDown(): void {
         Config.setConfig(new Object());
      }

      [Test]
      public function serialize_emptyMap(): void {
         assertThat(
            "empty map of 4x4 size",
            serialize(newPlanet(4, 4)), equals (
               ". . . . \n" +
               ". . . . \n" +
               ". . . . \n" +
               ". . . . "
            )
         );
      }

      [Test]
      public function serialize_withPlayerBuilding(): void {
         const planet: MPlanet = newPlanet(4, 4);
         planet.addObject(newBuilding(BuildingType.BARRACKS, 2, 1, 1));
         assertThat(
            "4x4 map with 2x2 building of level 2 at (1; 1)",
            serialize(planet), equals (
               ". . . . \n" +
               ". ----. \n" +
               ". -b-2. \n" +
               ". . . . "
            )
         );
      }

      [Test]
      public function serialize_withPlayerBuildingOfLevel10(): void {
         const planet: MPlanet = newPlanet(4, 4);
         planet.addObject(newBuilding(BuildingType.BARRACKS, 10, 1, 1));
         assertThat(
            "4x4 map with 2x2 building of level 10 at (1; 1)",
            serialize(planet), equals (
               ". . . . \n" +
               ". ----. \n" +
               ". -b-0. \n" +
               ". . . . "
            )
         );
      }

      [Test]
      public function serialize_mapWithTitanField(): void {
         const planet: MPlanet = newPlanet(4, 4);
         planet.addTile(newTile(TileKind.TITAN, 1, 1));
         planet.addTile(newTile(TileKind.TITAN, 1, 2));
         planet.addTile(newTile(TileKind.TITAN, 2, 1));
         planet.addTile(newTile(TileKind.TITAN, 2, 2));
         assertThat(
            "4x4 map with 2x2 TITAN field at (1; 1)",
            serialize(planet), equals (
               ". . . . \n" +
               ". ^ ^ . \n" +
               ". ^ ^ . \n" +
               ". . . . "
            )
         );
      }

      [Test]
      public function serialize_mapWithNpcBuildingAndNonResourceTilesUnder(): void {
         const planet: MPlanet = newPlanet(4, 4);
         planet.addTile(newTile(TileKind.NOXRIUM, 1, 1));
         planet.addTile(newTile(TileKind.NOXRIUM, 2, 1));
         planet.addTile(newTile(TileKind.NOXRIUM, 2, 2));
         planet.addObject(newBuilding(BuildingType.NPC_HALL, 0, 1, 1));
         assertThat(
            "4x4 map with 2x2 npc building of level 0 at (1; 1) and " +
               "NOXRIUM at (1; 1), (2; 1), (2; 2)",
            serialize(planet), equals (
               ". . . . \n" +
               ". .-/-. \n" +
               ". /a/0. \n" +
               ". . . . "
            )
         );
      }

      [Test]
      public function serialize_mapWithNpcAndPlayerExtractor(): void {
         const planet: MPlanet = newPlanet(7, 4);
         planet.addObject(newBuilding(BuildingType.NPC_ZETIUM_EXTRACTOR, 1, 1, 1));
         planet.addObject(newBuilding(BuildingType.METAL_EXTRACTOR_T2, 1, 4, 1));
         planet.addResourceTile(1, 1, TileKind.ZETIUM);
         planet.addResourceTile(4, 1, TileKind.ORE);
         assertThat(
            "4x7 map with NPC extractor at (1; 1) and player extractor at (1; 4)",
            serialize(planet), equals (
               ". . . . . . . \n" +
               ". ----. ----. \n" +
               ". $Z-1. Ox-1. \n" +
               ". . . . . . . "
            )
         );
      }

      [Test]
      public function serialize_mapWithGeothermalSpot(): void {
         const planet: MPlanet = newPlanet(4, 4);
         planet.addResourceTile(1, 1, TileKind.GEOTHERMAL);
         assertThat(
            "4x4 map with GEOTHERMAL spot at (1; 1)",
            serialize(planet), equals (
               ". . . . \n" +
               ". - - . \n" +
               ". % - . \n" +
               ". . . . "
            )
         );
      }

      [Test]
      public function serialize_mapWithFoliage(): void {
         const planet: MPlanet = newPlanet(4, 5);
         planet.addObject(newFoliage(FolliageTileKind._2X3, 1, 1));
         assertThat(
            "4x5 map with 2x3 foliage at (1; 1)",
            serialize(planet), equals (
               ". . . . \n" +
               ". ----. \n" +
               ". ----. \n" +
               ". 1---. \n" +
               ". . . . "
            )
         );
      }


      /* ############### */
      /* ### HELPERS ### */
      /* ############### */

      private function newTile(kind: int, x: int, y: int): Tile {
         const tile: Tile = new Tile(kind);
         tile.x = x;
         tile.y = y;
         return tile;
      }

      private function newPlanet(width: int, height: int): MPlanet {
         const ssObject: MSSObject = new MSSObject();
         ssObject.type = SSObjectType.PLANET;
         ssObject.width = width;
         ssObject.height = height;
         return new MPlanet(ssObject);
      }

      private function newBuilding(type: String, level: int,
                                   x: int, y: int): Building {
         const building: Building = new Building();
         building.type = type;
         building.level = level;
         building.x = x;
         building.y = y;
         building.setSize(
            Config.getBuildingWidth(type),
            Config.getBuildingHeight(type)
         );
         return building;
      }

      private function newFoliage(kind:int, x:int, y:int): BlockingFolliage {
         const foliage: BlockingFolliage = new BlockingFolliage();
         foliage.kind = kind;
         foliage.x = x;
         foliage.y = y;
         const size: Point = FolliageTileKind.getSize(kind);
         foliage.setSize(size.x, size.y);
         return foliage;
      }

      private function serialize(planet: MPlanet): String {
         return new PlanetMapSerializer().serialize(planet);
      }
   }
}
