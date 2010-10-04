/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package planetmapgenerator;

/**
 *
 * @author arturaz
 */
public class AreaTileType extends TileType {
  public boolean storeToDatabase = true;

  public AreaTileType(String name, int type) {
    super(name, type);
  }

  public AreaTileType(String name, int type, boolean storeToDatabase) {
    this(name, type);
    this.storeToDatabase = storeToDatabase;
  }
}
