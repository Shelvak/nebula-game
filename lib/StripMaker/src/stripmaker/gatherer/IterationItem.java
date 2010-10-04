package stripmaker.gatherer;

import java.awt.image.BufferedImage;

/**
 *
 * @author arturas
 */
public class IterationItem {
  public BufferedImage image;
  public int frame;

  public IterationItem(BufferedImage image, int frame) {
    this.image = image;
    this.frame = frame;
  }
}
