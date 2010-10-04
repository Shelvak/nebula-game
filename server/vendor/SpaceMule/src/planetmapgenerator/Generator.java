package planetmapgenerator;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

public class Generator {
  // Changed on each generate() call
  private Map<Integer, Integer> tile_numbers;
  private int width;
  private int height;
  private String type;

  static int MAX_ITERATIONS = 1000;

  PlanetMap planetMap;

  // Utility types
  static int MAP_REGULAR = -1;
  static int MAP_VOID = -2;
  // Single tile types
  static int MAP_ORE = 0;
  static int MAP_GEOTHERMAL = 1;
  static int MAP_ZETIUM = 2;
  // Multi tile types
  static int MAP_NOXRIUM = 3;
  static int MAP_JUNKYARD = 4;
  static int MAP_SAND = 5;
  static int MAP_TITAN = 6;
  static int MAP_WATER = 7;
  static int FOLLIAGE_3X3 = 8;
  static int FOLLIAGE_3X4 = 14;
  static int FOLLIAGE_4X3 = 9;
  static int FOLLIAGE_4X4 = 10;
  static int FOLLIAGE_4X6 = 11;
  static int FOLLIAGE_6X6 = 12;
  static int FOLLIAGE_6X2 = 13;
  static Map<Integer, BlockTileType> BLOCK_TILES =
          new LinkedHashMap<Integer, BlockTileType>();
  static List<AreaTileType> AREA_TILES = new ArrayList<AreaTileType>();

  // Order matters, put them from largest to smallest so algo could
  // find space for them
  static {
    BLOCK_TILES.put(FOLLIAGE_6X6,
            new BlockTileType("folliage_6x6", FOLLIAGE_6X6, 6, 6));
    BLOCK_TILES.put(FOLLIAGE_6X2,
            new BlockTileType("folliage_6x2", FOLLIAGE_6X2, 6, 2));
    BLOCK_TILES.put(FOLLIAGE_4X6,
            new BlockTileType("folliage_4x6", FOLLIAGE_4X6, 4, 6));
    BLOCK_TILES.put(FOLLIAGE_4X4,
            new BlockTileType("folliage_4x4", FOLLIAGE_4X4, 4, 4));
    BLOCK_TILES.put(FOLLIAGE_4X3,
            new BlockTileType("folliage_4x3", FOLLIAGE_4X3, 4, 3));
    BLOCK_TILES.put(FOLLIAGE_3X4,
            new BlockTileType("folliage_3x4", FOLLIAGE_3X4, 3, 4));
    BLOCK_TILES.put(FOLLIAGE_3X3,
            new BlockTileType("folliage_3x3", FOLLIAGE_3X3, 3, 3));
    BLOCK_TILES.put(MAP_ORE,
            new BlockTileType("ore", MAP_ORE, 2, 2));
    BLOCK_TILES.put(MAP_GEOTHERMAL,
            new BlockTileType("geothermal", MAP_GEOTHERMAL, 2, 2));
    BLOCK_TILES.put(MAP_ZETIUM,
            new BlockTileType("zetium", MAP_ZETIUM, 2, 2));

    AREA_TILES.add(new AreaTileType("regular", MAP_REGULAR, false));
    AREA_TILES.add(new AreaTileType("junkyard", MAP_JUNKYARD));
    AREA_TILES.add(new AreaTileType("noxrium", MAP_NOXRIUM));
    AREA_TILES.add(new AreaTileType("sand", MAP_SAND));
    AREA_TILES.add(new AreaTileType("titan", MAP_TITAN));
    AREA_TILES.add(new AreaTileType("water", MAP_WATER));
  }

  Generator() {
    this.planetMap = null;
    this.tile_numbers = null;
  }

  void print_map() {
    planetMap.print();
  }

  void homeworld() {
    planetMap = new PlanetMap(
      Config.getMap("planet.homeworld.map")
    );
    width = planetMap.getWidth();
    height = planetMap.getHeight();

    placeFolliage();
  }

  void generate(int width, int height, String type) {
    this.width = width;
    this.height = height;
    this.type = type;
    this.planetMap = new PlanetMap(width, height, MAP_REGULAR);

    placeBlockTiles();
    placeAreaTiles();
    placeFolliage();
  }

  private void get_multi_tile_numbers() {
    tile_numbers = new HashMap<Integer, Integer>();
    int unused_count = planetMap.unusedTiles.size();

    // Get numbers from random ranges for each type
    Map<Integer, Integer> tile_proportions = new HashMap<Integer, Integer>();
    int total_proportion = 0;

    for (AreaTileType tileType: AREA_TILES) {
      int proportion = Config.getRangeRand(
        "planet." + this.type + ".tiles." + tileType.name
      );

      tile_proportions.put(tileType.type, proportion);
      // Accumulate total proportion of all types
      total_proportion += proportion;
    }

    // Convert each proportion to number of tiles each terrain type needs
    Iterator it = tile_proportions.entrySet().iterator();
    while (it.hasNext()) {
      Map.Entry pairs = (Map.Entry) it.next();

      float proportion = ((Integer) pairs.getValue()).floatValue();
      Double number = (Double) Math.floor((proportion / total_proportion * unused_count));
      tile_numbers.put(
              (Integer) pairs.getKey(),
              number.intValue());
    }
  }

  // <editor-fold desc="Block tiles placement">
  private void placeBlockTiles() {
    for (BlockTileType blockTileType: BLOCK_TILES.values()) {
      int times = Config.getRangeRand(
        "planet." + this.type + ".tiles." + blockTileType.name
      );

      for (int index = 0; index < times; index++) {
        this.setUnusedBlockTo(blockTileType);
      }
    }
  }

  // Find unused square and set it to type.
  private void setUnusedBlockTo(BlockTileType blockTile) {
    CoordsBlock block = new CoordsBlock(blockTile.width,
            blockTile.height, blockTile.withBorder);

    boolean foundTile = false;
    int iteration = 0;
    while (! foundTile) {
      if (iteration > MAX_ITERATIONS) {
        System.err.println("Max iterations reached in "
                + "setUnusedBlockTo! Planet too small?");
        planetMap.print();
        System.exit(1);
      }

      Pair tile = this.planetMap.unusedTiles.random();
      foundTile = planetMap.findFreeBlock(tile, block);

      iteration++;
    }

    // let's flag them in a map as used.
    planetMap.flagAsUsed(block, blockTile.type);
  }
  // </editor-fold>

  private void placeAreaTiles() {
    get_multi_tile_numbers();

    for (AreaTileType tileType: AREA_TILES) {
      if (tileType.storeToDatabase) {
        int numOfIsles = Config.getRangeRand(
          "planet." + this.type + ".tiles." + tileType.name + ".isles"
        );
        create_area(tileType.type, numOfIsles);
      }
    }
  }

  private void placeFolliage() {
    TilesMap folliageTiles = planetMap.unusedTiles.clone();

    // Remove building tiles.
    for (SqlData sqlData: planetMap.getBuildings()) {
      Building building = (Building) sqlData;
      Pair[] coordinates = building.getCoordinates();
      for (int x = coordinates[0].x; x <= coordinates[1].x; x++) {
        for (int y = coordinates[0].y; y <= coordinates[1].y; y++) {
          folliageTiles.remove(new Pair(x, y));
        }
      }
    }

    int hasToPlace = folliageTiles.size() *
            Config.getFolliageRand() / 100;
    int placed = 0;

    while (placed < hasToPlace) {
      Pair tile = folliageTiles.random();
      folliageTiles.remove(tile);
      
      planetMap.addFolliage(new Folliage(tile.x, tile.y));
      placed++;
    }
  }

  private void create_area(int type, int numOfIsles) {
    int tiles_laid = 0;
    int tiles_laid_in_isle = 0;
    int number_of_tiles = tile_numbers.get(type);
    int tiles_per_isle = (int) Math.ceil((float) number_of_tiles / numOfIsles);

    TilesMap possible_positions = new TilesMap();

    // Try laying tiles until there are no unused tiles left or we laid our number
    // of tiles.
    int iterations = 0;
    while (planetMap.unusedTiles.size() != 0 && tiles_laid < number_of_tiles) {
      if (iterations > MAX_ITERATIONS) {
        System.err.println(String.format("Max iterations reached in create_area for type %d",
                type));
        System.exit(1);
      }

      //Check if we should start new isle
      if (tiles_laid_in_isle >= tiles_per_isle) {
        tiles_laid_in_isle = 0;
        iterations = 0;
        possible_positions = new TilesMap();
      }

      // Get new tile to be laid
      Pair tile;
      if (possible_positions.size() == 0) {
        tile = set_unused_tile_to(type);
      } else {
        tile = possible_positions.random();
        possible_positions.remove(tile);

        planetMap.flagAsUsed(tile, type);
      }
      tiles_laid += 1;
      tiles_laid_in_isle += 1;

      // Look up any other possible positions
      add_as_possible(possible_positions, tile.x + 1, tile.y);
      add_as_possible(possible_positions, tile.x - 1, tile.y);
      add_as_possible(possible_positions, tile.x, tile.y + 1);
      add_as_possible(possible_positions, tile.x, tile.y - 1);

      iterations++;
    }
  }

  private void add_as_possible(TilesMap possible_positions, int x, int y) {
    if (x >= 0 && x < width && y >= 0
            && y < height && planetMap.get(x, y) == MAP_REGULAR) {
      Pair tile = new Pair(x, y);
      possible_positions.add(tile);
    }
  }
  
  // Fetch random unused tile and set that it's used by type.
  private Pair set_unused_tile_to(int type) {
    Pair tile = planetMap.unusedTiles.random();
    planetMap.flagAsUsed(tile, type);
    return tile;
  }
}