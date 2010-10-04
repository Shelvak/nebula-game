package planetmapgenerator;

/**
 * Stores coordinate blocks.
 *
 * @author arturaz
 */
public class CoordsBlock {
  public int width;
  public int height;
  public boolean needsBorder;
  public Pair startingCoord = null;

  public CoordsBlock(int width, int height, boolean needsBorder) {
    this.width = width;
    this.height = height;
    this.needsBorder = needsBorder;
  }
}
