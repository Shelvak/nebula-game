package planetmapgenerator;

import java.util.Collection;
import java.util.HashSet;
import java.util.LinkedList;
import java.util.List;
import java.util.Set;

class PlanetMap {
  private int width, height;
  private int map[];
  private Set<SqlData> folliages = new HashSet<SqlData>();
  private Set<SqlData> buildings = new HashSet<SqlData>();
  public TilesMap unusedTiles = new TilesMap();

  private void setByString(int x, int y, String tile) {
    if (tile.equals(".")) {
      set(x, y, Generator.MAP_REGULAR);
    }
    else if (tile.equalsIgnoreCase("o")) {
      flagBlockAsUsed(x, y, Generator.MAP_ORE);
    }
    else if (tile.equals("%")) {
      flagBlockAsUsed(x, y, Generator.MAP_GEOTHERMAL);
    }
    else if (tile.equals("$")) {
      flagBlockAsUsed(x, y, Generator.MAP_ZETIUM);
    }
    else if (tile.equals("6")) {
      flagBlockAsUsed(x, y, Generator.FOLLIAGE_6X6);
    }
    else if (tile.equals("^")) {
      flagBlockAsUsed(x, y, Generator.FOLLIAGE_6X2);
    }
    else if (tile.equals("4")) {
      flagBlockAsUsed(x, y, Generator.FOLLIAGE_4X6);
    }
    else if (tile.equals("@")) {
      flagBlockAsUsed(x, y, Generator.FOLLIAGE_4X4);
    }
    else if (tile.equals("!")) {
      flagBlockAsUsed(x, y, Generator.FOLLIAGE_4X3);
    }
    else if (tile.equals("3")) {
      flagBlockAsUsed(x, y, Generator.FOLLIAGE_3X3);
    }
    else if (tile.equals("#")) {
      flagBlockAsUsed(x, y, Generator.FOLLIAGE_3X4);
    }
    else if (tile.equalsIgnoreCase("s")) {
      flagAsUsed(x, y, Generator.MAP_SAND);
    }
    else if (tile.equalsIgnoreCase("j")) {
      flagAsUsed(x, y, Generator.MAP_JUNKYARD);
    }
    else if (tile.equalsIgnoreCase("n")) {
      flagAsUsed(x, y, Generator.MAP_NOXRIUM);
    }
    else if (tile.equalsIgnoreCase("t")) {
      flagAsUsed(x, y, Generator.MAP_TITAN);
    }
    else if (tile.equalsIgnoreCase("w")) {
      flagAsUsed(x, y, Generator.MAP_WATER);
    }
    else if (tile.equalsIgnoreCase("-")) {
      flagAsUsed(x, y, Generator.MAP_VOID);
    }
    else {
      System.err.println("Unknown map signature: " + tile);
      System.exit(1);
    }
  }

  public int getWidth() {
    return width;
  }

  public int getHeight() {
    return height;
  }

  PlanetMap(String[] map) {
    this(map[0].length() / 2, map.length);

    for (int row = 0; row < height; row++) {
      for (int col = 0; col < width; col++) {
        int stringIndex = col * 2;
        String tile = map[row].substring(stringIndex, stringIndex + 1);
        String building = map[row].substring(stringIndex + 1, stringIndex + 2);

        setByString(col, row, tile);
        if (! (building.equals(" ") || building.equals("-"))) {
          buildings.add(new Building(col, row, building));
        }
      }
    }
  }

  PlanetMap(int width, int height) {
    this(width, height, null);
  }

  PlanetMap(int width, int height, Integer value) {
    initMap(width, height);

    for (int indexX = 0; indexX < this.width; indexX++) {
      for (int indexY = 0; indexY < this.height; indexY++) {
        if (value != null) {
          set(indexX, indexY, value);
        }
        Pair coord = new Pair(indexX, indexY);
        unusedTiles.add(coord);
      }
    }
  }

  public Collection<SqlData> getBuildings() {
    return buildings;
  }

  public Collection<SqlData> getUnits(int galaxyId) {
    LinkedList<SqlData> data = new LinkedList<SqlData>();
    for (SqlData building: buildings) {
      for (Unit unit: ((Building) building).getUnits()) {
        unit.galaxyId = galaxyId;
        data.add(unit);
      }
    }

    return data;
  }

  int get(int x, int y) {
    return map[index(x, y)];
  }

  void set(int x, int y, int value) {
    map[index(x, y)] = value;
  }

  public Collection<SqlData> getFolliages() {
    return folliages;
  }

  void addFolliage(Folliage f) {
    folliages.add(f);
  }

  void print() {
    for (int indexY = 0; indexY < height; indexY++) {
      for (int indexX = 0; indexX < width; indexX++) {
        System.out.print(String.format("%-2d ", get(indexX, indexY)));
      }
      System.out.println();
    }
  }

  private int index(int x, int y) {
    int index = y * width + x;
    if (index > map.length - 1) {
      throw new ArrayIndexOutOfBoundsException(
              String.format(
                "Error in PlanetMap#index (w: %d, h: %d)\n" +
                "x: %d, y: %d maps to out of range index %d! Exiting.",
                width, height,
                x, y, index
              )
      );
    }
    else {
      return index;
    }
  }

  private void initMap(int width, int height) {
    this.width = width;
    this.height = height;
    map = new int[width * height];
  }

  /**
   * Return TilesMap with all regular tiles in it.
   * 
   * @return TilesMap
   */
  public TilesMap getUnusedTiles() {
    TilesMap tilesMap = new TilesMap();
    for (int row = 0; row < height; row++) {
      for (int col = 0; col < width; col++) {
        int type = get(col, row);
        if (type == Generator.MAP_REGULAR) {
          tilesMap.add(new Pair(col, row));
        }
      }
    }

    return tilesMap;
  }

  /**
   * Get List of SqlData which should be inserted to database.
   * 
   * @return
   */
  public List<SqlData> getDatabaseTiles() {
    List<SqlData> tiles = new LinkedList<SqlData>();

    for (int row = 0; row < height; row++) {
      for (int col = 0; col < width; col++) {
        int type = get(col, row);
        // Skip utility types
        if (type >= 0) {
          SqlTile tile = new SqlTile(type, col, row);
          tiles.add(tile);
        }
      }
    }

    return tiles;
  }

  // Try to find block by trying different offsets and checking map.
  //
  // Return true if such block is found (stored in block)
  // Return false if there is no free block.
  public boolean findFreeBlock(Pair tile, CoordsBlock block) {
    // Minimal starting tile X and Y values. These are inclusive.
    int minStartX = tile.x - block.width + 1;
    int minStartY = tile.y - block.height + 1;
    // Ensure they are not negative.
    if (minStartX < 0) { minStartX = 0; }
    if (minStartY < 0) { minStartY = 0; }

    // Move the starting tile to check all possible locations in the
    // block.
    for (int startTileX = tile.x; startTileX >= minStartX; startTileX--) {
      startingTileY:
      for (int startTileY = tile.y; startTileY >= minStartY; startTileY--) {
        // Check if the block can be established with this stating
        // tile. These are exclusive.
        int blockEndX = startTileX + block.width;
        int blockEndY = startTileY + block.height;

        // Check the ending of the block.
        // We don't check the border because the border doesn't apply
        // to the edge of the map.
        if (blockEndX >= this.width || blockEndY >= this.height) {
          // This cannot be established because the block would end over
          // the edge of map.
          continue startingTileY;
        }

        // Check if all tiles inside block are of regular type.
        int blockCheckStartX = startTileX;
        int blockCheckStartY = startTileY;
        int blockCheckEndX = blockEndX;
        int blockCheckEndY = blockEndY;

        // If block needs border we should also check if perimeter around
        // the block is free.
        if (block.needsBorder) {
          if (blockCheckStartX > 0) { blockCheckStartX--; }
          if (blockCheckStartY > 0) { blockCheckStartY--; }
          if (blockCheckEndX < this.width) { blockCheckEndX++; }
          if (blockCheckEndY < this.height) { blockCheckEndY++; }
        }
        
        for (int x = blockCheckStartX; x < blockCheckEndX; x++) {
          for (int y = blockCheckStartY; y < blockCheckEndY; y++) {
            // If tile at x, y is not regular, we cannot establish block
            // here.
            if (get(x, y) != Generator.MAP_REGULAR) {
              continue startingTileY;
            }
          }
        }

        // If we are here then we can use this block.
        block.startingCoord = new Pair(startTileX, startTileY);
        return true;
      }
    }

    return false;
  }

  public void flagAsUsed(int x, int y, int type) {
    flagAsUsed(new Pair(x, y), type);
  }

  public void flagBlockAsUsed(int x, int y, int type) {
    BlockTileType tileType = Generator.BLOCK_TILES.get(type);
    CoordsBlock block = new CoordsBlock(tileType.width, tileType.height,
            false);
    block.startingCoord = new Pair(x, y);
    flagAsUsed(block, type);
  }

  public void flagAsUsed(Pair tile, int type) {
    unusedTiles.remove(tile);
    set(tile.x, tile.y, type);
  }

  /**
   * Flag whole block as used. Sets starting tile to type and others to
   * void.
   *
   * @param block
   * @param type
   */
  public void flagAsUsed(CoordsBlock block, int type) {
    int xStart = block.startingCoord.x;
    int yStart = block.startingCoord.y;
    int xEnd = xStart + block.width;
    int yEnd = yStart + block.height;

    for (int x = xStart; x < xEnd; x++) {
      for (int y = yStart; y < yEnd; y++) {
        Pair pair = new Pair(x, y);

        if (x == xStart && y == yStart) {
          flagAsUsed(pair, type);
        }
        else {
          flagAsUsed(pair, Generator.MAP_VOID);
        }
      }
    }
  }
};
