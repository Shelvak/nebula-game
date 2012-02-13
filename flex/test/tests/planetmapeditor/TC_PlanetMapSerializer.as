package tests.planetmapeditor
{
   import components.planetmapeditor.PlanetMapSerializer;

   import config.Config;

   import ext.hamcrest.object.equals;

   import models.building.Building;
   import models.building.BuildingType;
   import models.building.Extractor;
   import models.building.ZetiumExtractor;
   import models.folliage.BlockingFolliage;
   import models.planet.MPlanet;
   import models.planet.Range2D;
   import models.solarsystem.MSSObject;
   import models.solarsystem.SSObjectType;
   import models.tile.FolliageTileKind;
   import models.tile.TerrainType;
   import models.tile.Tile;
   import models.tile.TileKind;

   import org.flexunit.assertThat;
   import org.hamcrest.collection.*;
   import org.hamcrest.core.not;
   import org.hamcrest.object.*;


   public class TC_PlanetMapSerializer
   {
      [Before]
      public function setUp(): void {
         Config.setConfig({
            "buildings.barracks.width": 2,
            "buildings.barracks.height": 2,
            "buildings.barracks.hp": 100,
            "buildings.barracks.npc": false,
            "buildings.metalExtractorT2.width": 2,
            "buildings.metalExtractorT2.height": 2,
            "buildings.metalExtractorT2.hp": 100,
            "buildings.metalExtractorT2.npc": false,
            "buildings.zetiumExtractorT2.width": 2,
            "buildings.zetiumExtractorT2.height": 2,
            "buildings.zetiumExtractorT2.hp": 100,
            "buildings.zetiumExtractorT2.npc": false,
            "buildings.npcHall.width": 2,
            "buildings.npcHall.height": 2,
            "buildings.npcHall.hp": 100,
            "buildings.npcHall.npc": true,
            "buildings.npcZetiumExtractor.width": 2,
            "buildings.npcZetiumExtractor.height": 2,
            "buildings.npcZetiumExtractor.hp": 100,
            "buildings.npcZetiumExtractor.npc": true
         });
      }

      [After]
      public function tearDown(): void {
         Config.setConfig(new Object());
      }

      
      /* ##################### */
      /* ### SERIALIZATION ### */
      /* ##################### */

      [Test]
      public function serialize_emptyMap(): void {
         assertThat(
            "empty map of 4x4 size",
            serialize(newPlanet(4, 4)), equals (
               'terrain: <%= Terrain::EARTH %>\n' +
               'name: "P-%d"\n' +
               '# 4x4 (area 16)\n' +
               'map:\n' +
               '  - ". . . . "\n' +
               '  - ". . . . "\n' +
               '  - ". . . . "\n' +
               '  - ". . . . "'
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
               'terrain: <%= Terrain::EARTH %>\n' +
               'name: "P-%d"\n' +
               '# 4x4 (area 16)\n' +
               'map:\n' +
               '  - ". . . . "\n' +
               '  - ". ----. "\n' +
               '  - ". -b-2. "\n' +
               '  - ". . . . "'
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
               'terrain: <%= Terrain::EARTH %>\n' +
               'name: "P-%d"\n' +
               '# 4x4 (area 16)\n' +
               'map:\n' +
               '  - ". . . . "\n' +
               '  - ". ----. "\n' +
               '  - ". -b-0. "\n' +
               '  - ". . . . "'
            )
         );
      }

      [Test]
      public function serialize_mapWithTitanField(): void {
         const planet: MPlanet = newPlanet(4, 4);
         planet.addTile(TileKind.TITAN, 1, 1);
         planet.addTile(TileKind.TITAN, 1, 2);
         planet.addTile(TileKind.TITAN, 2, 1);
         planet.addTile(TileKind.TITAN, 2, 2);
         assertThat(
            "4x4 map with 2x2 TITAN field at (1; 1)",
            serialize(planet), equals (
               'terrain: <%= Terrain::EARTH %>\n' +
               'name: "P-%d"\n' +
               '# 4x4 (area 16)\n' +
               'map:\n' +
               '  - ". . . . "\n' +
               '  - ". ^ ^ . "\n' +
               '  - ". ^ ^ . "\n' +
               '  - ". . . . "'
            )
         );
      }

      [Test]
      public function serialize_mapWithNpcBuildingAndNonResourceTilesUnder(): void {
         const planet: MPlanet = newPlanet(4, 4);
         planet.addTile(TileKind.NOXRIUM, 1, 1);
         planet.addTile(TileKind.NOXRIUM, 2, 1);
         planet.addTile(TileKind.NOXRIUM, 2, 2);
         planet.addObject(newBuilding(BuildingType.NPC_HALL, 0, 1, 1));
         assertThat(
            "4x4 map with 2x2 npc building of level 0 at (1; 1) and " +
               "NOXRIUM at (1; 1), (2; 1), (2; 2)",
            serialize(planet), equals (
               'terrain: <%= Terrain::EARTH %>\n' +
               'name: "P-%d"\n' +
               '# 4x4 (area 16)\n' +
               'map:\n' +
               '  - ". . . . "\n' +
               '  - ". .-/-. "\n' +
               '  - ". /a/0. "\n' +
               '  - ". . . . "'
            )
         );
      }

      [Test]
      public function serialize_mapWithNpcAndPlayerExtractor(): void {
         const planet: MPlanet = newPlanet(7, 4);
         planet.addObject(newBuilding(BuildingType.NPC_ZETIUM_EXTRACTOR, 1, 1, 1));
         planet.addObject(newBuilding(BuildingType.METAL_EXTRACTOR_T2, 1, 4, 1));
         planet.addTile(TileKind.ZETIUM, 1, 1);
         planet.addTile(TileKind.ORE, 4, 1);
         assertThat(
            "7x4 map with NPC extractor at (1; 1) and player extractor at (1; 4)",
            serialize(planet), equals (
               'terrain: <%= Terrain::EARTH %>\n' +
               'name: "P-%d"\n' +
               '# 7x4 (area 28)\n' +
               'map:\n' +
               '  - ". . . . . . . "\n' +
               '  - ". ----. ----. "\n' +
               '  - ". $Z-1. Ox-1. "\n' +
               '  - ". . . . . . . "'
            )
         );
      }

      [Test]
      public function serialize_mapWithGeothermalSpot(): void {
         const planet: MPlanet = newPlanet(4, 4);
         planet.addTile(TileKind.GEOTHERMAL, 1, 1);
         assertThat(
            "4x4 map with GEOTHERMAL spot at (1; 1)",
            serialize(planet), equals (
               'terrain: <%= Terrain::EARTH %>\n' +
               'name: "P-%d"\n' +
               '# 4x4 (area 16)\n' +
               'map:\n' +
               '  - ". . . . "\n' +
               '  - ". - - . "\n' +
               '  - ". % - . "\n' +
               '  - ". . . . "'
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
               'terrain: <%= Terrain::EARTH %>\n' +
               'name: "P-%d"\n' +
               '# 4x5 (area 20)\n' +
               'map:\n' +
               '  - ". . . . "\n' +
               '  - ". ----. "\n' +
               '  - ". ----. "\n' +
               '  - ". 1---. "\n' +
               '  - ". . . . "'
            )
         );
      }


      /* ####################### */
      /* ### DESERIALIZATION ### */
      /* ####################### */

      [Test]
      public function deserialize_emptyMap(): void {
         const planet: MPlanet = deserialize(
            'terrain: <%= Terrain::DESERT %>\n' +
            'name: "Test-%d"\n' +
            'map:\n' +
            '  - ". . . . "\n' +
            '  - ". . . . "\n' +
            '  - ". . . . "\n' +
            '  - ". . . . "'
         );
         assertThat( "terrain", planet.ssObject.terrain, equals (TerrainType.DESERT) );
         assertThat( "name", planet.ssObject.name, equals ("Test") );
         assertThat( "width", planet.width, equals (4) );
         assertThat( "height", planet.height, equals (4));
         assertThat( "no objects", planet.objects, emptyArray() );
         planet.forEachPointIn(
            [new Range2D(0, 3, 0, 3)], false,
            function(x: int, y: int): void {
               assertThat(
                  "only regular tiles",
                  planet.getTileKind(x, y), equals (TileKind.REGULAR)
               );
            }
         );
      }

      [Test]
      public function deserialize_mapWithOneResourceTile(): void {
         const planet: MPlanet = deserialize(
            'terrain: <%= Terrain::EARTH %>\n' +
            'name: "P-%d"\n' +
            'map:\n' +
            '  - ". . . . "\n' +
            '  - ". ----. "\n' +
            '  - ". O---. "\n' +
            '  - ". . . . "'
         );
         assertRegularTile(planet, [
            new Range2D(0, 3, 0, 0),
            new Range2D(0, 3, 3, 3),
            new Range2D(0, 0, 1, 2),
            new Range2D(3, 3, 1, 2)
         ]);
         planet.forEachPointIn(
            [new Range2D(1, 2, 1, 2)], false,
            function(x: int, y: int): void {
               const tile: Tile = planet.getTile(x, y);
               const message: String = "ORE tile at (" + x + "; " + y + ") ";
               assertThat( message, tile.kind, equals (TileKind.ORE) );
               if (x == 1 && y == 1) {
                  assertThat( message + "is not fake", tile.fake, isFalse() );
               }
               else {
                  assertThat( message + "is fake", tile.fake, isTrue() );
               }
            }
         )
      }

      [Test]
      public function deserialize_mapWithNoxriumField(): void {
         const planet: MPlanet = deserialize(
            'terrain: <%= Terrain::EARTH %>\n' +
            'name: "P-%d"\n' +
            'map:\n' +
            '  - ". . . . "\n' +
            '  - ". . . . "\n' +
            '  - ". . / / "\n' +
            '  - ". . / / "'
         );
         assertRegularTile(planet, [
            new Range2D(0, 1, 0, 3),
            new Range2D(2, 3, 2, 3)
         ]);
         planet.forEachPointIn(
            [new Range2D(2, 3, 0, 1)], false,
            function(x: int, y: int): void {
               const tile: Tile = planet.getTile(x, y);
               const message: String = "NOXRIUM tile at (" + x + "; " + y + ") ";
               assertThat( message, tile.kind, equals (TileKind.NOXRIUM) );
               assertThat( message + " is not fake", tile.fake, isFalse() );
            }
         );
      }

      [Test]
      public function deserialize_mapWithFoliage(): void {
         const planet: MPlanet = deserialize(
            'terrain: <%= Terrain::EARTH %>\n' +
            'name: "P-%d"\n' +
            'map:\n' +
            '  - ". . . . "\n' +
            '  - ". ----. "\n' +
            '  - ". ----. "\n' +
            '  - ". 1---. "\n' +
            '  - ". . . . "'
         );
         assertRegularTile(planet, [new Range2D(0, 4, 0, 4)]);
         assertThat( "only one object", planet.objects, arrayWithSize (1) );
         const foliage: BlockingFolliage =
                  planet.getObject(1, 1) as BlockingFolliage;
         assertThat( "foliage at (1; 1)", foliage, notNullValue() );
         assertThat(
            "foliage is of 2x3 kind",
            foliage.kind, equals (FolliageTileKind._2X3)
         );
      }

      [Test]
      public function deserialize_mapWithBuilding(): void {
         const planet: MPlanet = deserialize(
            'terrain: <%= Terrain::EARTH %>\n' +
            'name: "P-%d"\n' +
            'map:\n' +
            '  - ". . . . "\n' +
            '  - ". ----. "\n' +
            '  - ". -b-2. "\n' +
            '  - ". . . . "'
         );
         assertThat( "only one object", planet.objects, arrayWithSize (1) );
         const building: Building = planet.getObject(1, 1) as Building;
         assertThat( "building at (1; 1)", building, notNullValue() );
         assertThat( "building level", building.level, equals (2) );
         assertThat( "building is not ghost", building.isGhost, isFalse() );
         assertThat( "building hp", building.hp, equals (building.hpMax) );
         assertThat( "building active", building.state, equals (Building.ACTIVE) );
         assertThat(
            "building is not an extractor",
            building, not (instanceOf (Extractor))
         );
      }

      [Test]
      public function deserialize_mapWithExtractor(): void {
         const planet: MPlanet = deserialize(
            'terrain: <%= Terrain::EARTH %>\n' +
            'name: "P-%d"\n' +
            'map:\n' +
            '  - ". . . . "\n' +
            '  - ". ----. "\n' +
            '  - ". $z-1. "\n' +
            '  - ". . . . "'
         );
         assertRegularTile(planet, [
            new Range2D(0, 3, 0, 0),
            new Range2D(0, 3, 3, 3),
            new Range2D(0, 0, 1, 2),
            new Range2D(3, 3, 1, 2)
         ]);
         planet.forEachPointIn(
            [new Range2D(1, 2, 1, 2)], false,
            function(x: int, y: int): void {
               assertThat(
                  "ZETIUM tile at (" + x + "; " + y + ")",
                  planet.getTileKind(x, y), equals (TileKind.ZETIUM)
               );
            }
         );
         const building: Building = planet.getObject(1, 1) as Building;
         assertThat( "building at (1; 1)", building, notNullValue() );
         assertThat( "building level", building.level, equals (1) );
         assertThat(
            "building is ZetiumExtractor",
            building, instanceOf (ZetiumExtractor)
         );
      }

      [Test]
      public function deserialize_mapWithBuildingAndNonRegularTilesUnderIt(): void {
         const planet: MPlanet = deserialize(
            'terrain: <%= Terrain::EARTH %>\n' +
            'name: "P-%d"\n' +
            'map:\n' +
            '  - ". # # # . . "\n' +
            '  - ". # # # . . "\n' +
            '  - ". #-.-. . . "\n' +
            '  - ". #a.3. . . "'
         );
         assertRegularTile(planet,  [
            new Range2D(0, 0, 0, 3),
            new Range2D(2, 5, 0, 1),
            new Range2D(4, 5, 2, 3)
         ]);
         planet.forEachPointIn(
            [
               new Range2D(1, 1, 0, 1),
               new Range2D(1, 3, 2, 3)
            ],
            false,
            function(x: int, y: int): void {
               assertThat(
                  "JUNKYARD tile at (" + x + "; " + y + ")",
                  planet.getTileKind(x, y), equals (TileKind.JUNKYARD)
               );
            }
         );
         assertThat( "only one object", planet.objects, arrayWithSize (1) );
         const building: Building = planet.getObject(1, 0) as Building;
         assertThat( "building at (0; 1)", building, notNullValue() );
         assertThat( "building level", building.metaLevel, equals (3) );
         assertThat(
            "building is not Extractor",
            building, not (instanceOf (Extractor))
         );
      }


      /* ############### */
      /* ### HELPERS ### */
      /* ############### */

      private function assertRegularTile(planet: MPlanet, ranges: Array): void {
         planet.forEachPointIn(
            ranges, true,
            function(x: int, y: int): void {
               assertThat(
                  "regular tile at (" + x + "; " + y + ")",
                  planet.getTileKind(x, y), equals (TileKind.REGULAR)
               );
            }
         );
      }

      private function newPlanet(width: int, height: int): MPlanet {
         const ssObject: MSSObject = new MSSObject();
         ssObject.type = SSObjectType.PLANET;
         ssObject.name = "P";
         ssObject.width = width;
         ssObject.height = height;
         return new MPlanet(ssObject);
      }

      private function newBuilding(type: String, level: int,
                                   x: int, y: int): Building {
         const building: Building = new Building();
         building.id = 1;
         building.type = type;
         if (building.npc) {
            building.metaLevel = level;
         }
         else {
            building.level = level;
         }
         building.moveTo(x, y);
         building.hp = building.hpMax;
         Building.setSize(building);
         return building;
      }

      private function newFoliage(kind: int, x: int, y: int): BlockingFolliage {
         const foliage: BlockingFolliage = new BlockingFolliage();
         foliage.kind = kind;
         foliage.moveTo(x, y);
         BlockingFolliage.setSize(foliage);
         return foliage;
      }

      private function serialize(planet: MPlanet): String {
         return new PlanetMapSerializer().serialize(planet);
      }

      private function deserialize(data: String): MPlanet {
         return new PlanetMapSerializer().deserialize(data);
      }
   }
}
