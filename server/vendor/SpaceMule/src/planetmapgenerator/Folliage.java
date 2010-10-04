/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package planetmapgenerator;

/**
 *
 * @author arturaz
 */
public class Folliage extends Pair implements SqlData {
  Folliage(int x, int y) {
    super(x, y);
  }

  public static String columns() {
    return "`planet_id`, `x`, `y`, `variation`";
  }

  public String toValues(int planetId) {
    return String.format("%d, %d, %d, %d",
            planetId,
            x,
            y,
            Config.getVariationRand("ui.planet.folliage.variations")
    );
  }
}
