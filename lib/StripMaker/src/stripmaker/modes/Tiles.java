package stripmaker.modes;

import java.awt.Rectangle;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.IOException;
import javax.imageio.ImageIO;
import stripmaker.RectFinder;
import stripmaker.gatherer.Gatherer;

/**
 *
 * @author arturas
 */
public class Tiles extends Mode {
  public static final int TILE_WIDTH = 98;
  public static final int TILE_HEIGHT = 50;

  @Override
  public Rectangle getStartArea(Gatherer gatherer) throws IOException {
    File base = new File(gatherer.getDataDirectory(), "base.png");
    if (base.exists() && base.isFile()) {
      return RectFinder.find(ImageIO.read(base));
    }
    else {
      throw new FileNotFoundException(base.toString() + " does not exist!");
    }
  }

  protected int width, height;

  public void setWidth(int width) {
    this.width = width;
  }

  public void setHeight(int height) {
    this.height = height;
  }

  public Tiles(int width, int height) {
    this.width = width;
    this.height = height;
  }

  private int getBaseWidth(int tileWidth, int tileHeight) {
    return (tileWidth + tileHeight) * TILE_WIDTH / 2 + tileWidth + tileHeight
      - 2;
  }

  @Override
  public int getTargetWidth(Rectangle commonRect) {
    return getBaseWidth(width, height);
  }

  @Override
  public int getTargetHeight(Rectangle commonRect) {
    return getTargetWidth(commonRect) * commonRect.height / commonRect.width;
  }

}
