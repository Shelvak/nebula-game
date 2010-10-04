/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package planetmapgenerator;

import java.util.HashMap;
import java.util.Map;

/**
 *
 * @author arturaz
 */
public class BlockTileType extends TileType {
  public int width;
  public int height;
  public boolean withBorder = false;
  public static Map<Integer, BlockTileType> availableTypes =
          new HashMap<Integer, BlockTileType>();

  public BlockTileType(String name, int type, int width, int height) {
    super(name, type);
    this.width = width;
    this.height = height;

    // Store for later lookup.
    availableTypes.put(type, this);
  }

  public BlockTileType(String name, int type, int width, int height,
          boolean withBorder) {
    this(name, type, width, height);
    this.withBorder = withBorder;
  }
}
