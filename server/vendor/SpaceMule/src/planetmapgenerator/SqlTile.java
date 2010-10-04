/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package planetmapgenerator;

/**
 *
 * @author arturaz
 */
public class SqlTile extends Pair implements SqlData {
  private int type;
  private Integer variation = null;

  public SqlTile(int type, int x, int y) {
    super(x, y);
    this.type = type;
  }

  public void setVariation(Integer variation) {
    this.variation = variation;
  }

  public static String columns() {
    return "`planet_id`, `kind`, `x`, `y`";
  }

  public String toValues(int planetId) {
    return String.format(
              "%d, %d, %d, %d",
              planetId,
              type,
              x,
              y
              );
  }

}
