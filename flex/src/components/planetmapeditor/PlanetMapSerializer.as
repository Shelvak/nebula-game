package components.planetmapeditor
{
   import models.building.Building;
   import models.building.BuildingType;
   import models.folliage.BlockingFolliage;
   import models.planet.MPlanet;
   import models.planet.MPlanetObject;
   import models.solarsystem.MSSObject;
   import models.solarsystem.SSObjectType;
   import models.tile.FolliageTileKind;
   import models.tile.TerrainType;
   import models.tile.Tile;
   import models.tile.TileKind;

   import mx.controls.Alert;
   import mx.utils.StringUtil;

   import utils.Objects;


public final class PlanetMapSerializer
   {
      private const SYM_SPACE: String = " ";
      private const SYM_DASH: String = "-";
      private const SYM_POINT: String = ".";

      private function isRegularTileSymbol(symbol: String): Boolean {
         return symbol == SYM_DASH
                   || symbol == SYM_POINT
                   || symbol == SYM_SPACE;
      }

      private const TILE_SYMBOL: Object = new Object();
      private const SYMBOL_TILE: Object = {
         "_": TileKind.SAND,
         "/": TileKind.NOXRIUM,
         "#": TileKind.JUNKYARD,
         "^": TileKind.TITAN,
         "O": TileKind.ORE,
         "%": TileKind.GEOTHERMAL,
         "$": TileKind.ZETIUM,
         "1": FolliageTileKind._2X3,
         "2": FolliageTileKind._2X4,
         "5": FolliageTileKind._3X2,
         "3": FolliageTileKind._3X3,
         "*": FolliageTileKind._3X4,
         "!": FolliageTileKind._4X3,
         "@": FolliageTileKind._4X4,
         "4": FolliageTileKind._4X6,
         "~": FolliageTileKind._6X2,
         "6": FolliageTileKind._6X6
      };
      
      private function getTileKind(symbol: String): int {
         return SYMBOL_TILE[symbol];
      }

      private function getTileSymbol(kind: int): String {
         return TILE_SYMBOL[kind];
      }

      private const BUILDING_SYMBOL: Object = new Object();
      private const SYMBOL_BUILDING: Object = {
          "m": BuildingType.MOTHERSHIP,
          "h": BuildingType.HQ,
          "b": BuildingType.BARRACKS,
          "x": BuildingType.METAL_EXTRACTOR_T2,
          "c": BuildingType.COLLECTOR_T2,
          "z": BuildingType.ZETIUM_EXTRACTOR_T2,
          "a": BuildingType.NPC_HALL,
          "i": BuildingType.NPC_INFANTRY_FACTORY,
          "n": BuildingType.NPC_GROUND_FACTORY,
          "f": BuildingType.NPC_SPACE_FACTORY,
          "P": BuildingType.NPC_SOLAR_PLANT,
          "H": BuildingType.NPC_COMMUNICATIONS_HUB,
          "X": BuildingType.NPC_METAL_EXTRACTOR,
          "Z": BuildingType.NPC_ZETIUM_EXTRACTOR,
          "E": BuildingType.NPC_TEMPLE,
          "G": BuildingType.NPC_GEOTHERMAL_PLANT,
          "R": BuildingType.NPC_RESEARCH_CENTER,
          "C": BuildingType.NPC_EXCAVATION_SITE,
          "U": BuildingType.NPC_JUMPGATE
      };

      private function getBuildingType(symbol: String): String {
         return SYMBOL_BUILDING[symbol];
      }

      private function getBuildingSymbol(type: String): String {
         return BUILDING_SYMBOL[type];
      }

      public function PlanetMapSerializer() {
         for (var tileSym: String in SYMBOL_TILE) {
            TILE_SYMBOL[getTileKind(tileSym)] = tileSym;
         }
         for (var buildingSym: String in SYMBOL_BUILDING) {
            BUILDING_SYMBOL[getBuildingType(buildingSym)] = buildingSym;
         }
      }

      public function serialize(planet: MPlanet): String {
         Objects.paramNotNull("planet", planet);
         const rows: Array = new Array();
         for (var y: int = 0; y < planet.height; y++) {
            var row: String = "";
            for (var x: int = 0; x < planet.width; x++) {
               const object: MPlanetObject = planet.getObject(x, y);
               const tile: Tile = planet.getTile(x, y);
               var symPair: String = null;
               if (object != null) {
                  if (object is Building) {
                     const building: Building = Building(object);
                     if (tile != null) {
                        symPair = !tile.fake
                                     ? getTileSymbol(tile.kind)
                                     : SYM_DASH;
                     }
                     else {
                        if (building.isExtractor) {
                           symPair = SYM_DASH;
                        }
                        else {
                           symPair = building.npc ? SYM_POINT : SYM_DASH;
                        }
                     }
                     if (y == building.y && x == building.x) {
                        symPair += getBuildingSymbol(building.type);
                     }
                     else if (y == building.y && x == building.x + 1) {
                        symPair += (building.npc
                           ? building.metaLevel % 10
                           : building.level % 10);
                     }
                     else {
                        symPair += SYM_DASH;
                     }
                  }
                  else {
                     const foliage: BlockingFolliage = BlockingFolliage(object);
                     symPair = foliage.x == x && foliage.y == y
                                  ? getTileSymbol(foliage.kind)
                                  : SYM_DASH;
                     symPair += SYM_DASH;
                  }
               }
               else {
                  if (tile != null) {
                     symPair = !tile.fake ? getTileSymbol(tile.kind) : SYM_DASH;
                  }
                  else {
                     symPair = SYM_POINT;
                  }
                  symPair += SYM_SPACE;
               }
               row += symPair;
            }
            row = '  - "' + row + '"';
            rows.push(row);
         }
         return StringUtil.substitute(
            'terrain: <%= Terrain::{0} %>\n' +
            'name: "{1}-%s"\n' +
            '# {2}x{3} (area {4})\n' +
            'map:\n{5}',
            TerrainType.getName(planet.ssObject.terrain, true),
            planet.ssObject.name,
            planet.width, planet.height, planet.width * planet.height,
            rows.reverse().join('\n')
         );
      }

      public function deserialize(data: String): MPlanet {
         Objects.paramNotEmpty("data", data);
         const dataRows:Array = data.split("\n");
         var newRows: Array = [];
         for (var i: int = 0; i < dataRows.length; i++) {
            if (!(String(dataRows[i]).replace(/^\s*/, "") == ""
               || (String(dataRows[i]).replace(/^\s*/, "").charAt(0) == "#"))) {
               newRows.push(dataRows[i]);
            }
         }
         const ssObject: MSSObject = new MSSObject();
         ssObject.id = 1;
         ssObject.type = SSObjectType.PLANET;
         try {
            ssObject.terrain = TerrainType.getType(
               /terrain:\s*<%=\s*Terrain::([[A-Z]+)\s*%>/.exec(newRows[0])[1]
            );
         }
         catch (e: Error) {
            Alert.show("Error parsing terrain, setting to earth!\n" +
               e.message + "\nData:\n" + newRows[0]);
            ssObject.terrain = TerrainType.GRASS;
         }

         try {
            ssObject.name = /name: "(.+?)(-%s)?"/.exec(newRows[1])[1];
         }
         catch (e: Error) {
            Alert.show("Error parsing name, setting to default!\n" +
               e.message + "\nData:\n" + newRows[1]);
            ssObject.name = "P";
         }

         const rows: Array = newRows.slice(3).reverse().map(
            function(row: String, index: int, array: Array): String {
               return row == '' ? ''
                         : row.replace(/^\s*-\s"/, "").replace(/"\s*$/, "");
            }
         );

         ssObject.width = String(rows[0]).length / 2;
         ssObject.height = rows.length;
         const planet: MPlanet = new MPlanet(ssObject);
         for (var y: int = 0; y < planet.height; y++) {
            for (var x: int = 0; x < planet.width; x++) {
               const row: String = rows[y];
               const tileSym: String = row.charAt(2 * x);
               const objectSym: String = row.charAt(2 * x + 1);

               if (!isRegularTileSymbol(tileSym)) {
                  const tileKind: int = getTileKind(tileSym);
                  if (FolliageTileKind.isFolliageKind(tileKind)) {
                     const foliage: BlockingFolliage = new BlockingFolliage();
                     foliage.kind = tileKind;
                     foliage.moveTo(x, y);
                     foliage.terrainType = ssObject.terrain;
                     BlockingFolliage.setSize(foliage);
                     planet.addObject(foliage);
                  }
                  else {
                     planet.addTile(tileKind, x, y);
                  }
               }

               if (!isRegularTileSymbol(objectSym)) {
                  const levelSym: String = (x < planet.width - 1)
                                              ? row.charAt(2 * x + 3)
                                              : SYM_SPACE;
                  if (!isRegularTileSymbol(levelSym)) {
                     const building: Building = MPlanetMapEditor.newBuilding(
                        getBuildingType(objectSym),
                        int(levelSym)
                     );
                     building.id = 1;
                     building.state = Building.ACTIVE;
                     building.hp = building.hpMax;
                     building.moveTo(x, y);
                     planet.addObject(building);
                  }
               }
            }
         }
         return planet;
      }
   }
}
