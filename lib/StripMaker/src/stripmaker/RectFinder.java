package stripmaker;

import java.io.IOException;
import stripmaker.gatherer.Gatherer;
import stripmaker.gatherer.IterationItem;
import java.awt.Rectangle;
import java.awt.image.BufferedImage;
import stripmaker.modes.Mode;

/**
 * Class that finds common rectangle in all the images.
 *
 * @author arturas
 */
public class RectFinder {
  public static Rectangle find(Gatherer gatherer, Mode mode)
    throws IOException {
    Rectangle area = mode.getStartArea(gatherer);

    for (IterationItem item: gatherer) {
      Rectangle frameArea = find(item.image);
      if (frameArea != null) {
        if (area == null) {
          area = frameArea;
        }
        else {
          area.add(frameArea);
        }
      }
    }

    return area;
  }

  public static Rectangle find(BufferedImage image) {
    int width = image.getWidth();
    int height = image.getHeight();

    int lastX = 0, lastY = 0;
    int firstX = width;
    int firstY = height;

    for (int x = 0; x < width; x++) {
      for (int y = 0; y < height; y++) {
        if (! isPixelTransparent(image.getRGB(x, y))) {
          if (x < firstX) firstX = x;
          if (x > lastX) lastX = x;
          if (y < firstY) firstY = y;
          if (y > lastY) lastY = y;
        }
      }
    }

    // Image was totally transparent.
    if (firstX > lastX) {
      return null;
    }
    else {
      return new Rectangle(firstX, firstY, lastX - firstX, lastY - firstY);
    }
  }

  private static boolean isPixelTransparent(int argb) {
    return ((argb >> 24) & 0xff) == 0;
  }
}
