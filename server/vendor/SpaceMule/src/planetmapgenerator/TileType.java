/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package planetmapgenerator;

public abstract class TileType {
  public String name;
  public int type;

  public TileType(String name, int type) {
    this.name = name;
    this.type = type;
  }
}
