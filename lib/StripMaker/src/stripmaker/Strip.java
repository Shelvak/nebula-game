package stripmaker;

import stripmaker.gatherer.IterationItem;
import java.awt.Graphics;
import java.awt.image.BufferedImage;
import java.io.File;
import java.io.IOException;
import javax.imageio.ImageIO;

/**
 *
 * @author arturas
 */
public class Strip {
  private int frameWidth;
  private int frameHeight;
  private BufferedImage image;
  final int OFFSET = 0;
  final int SCANSIZE = 0;

  public Strip(int frameWidth, int frameHeight, int frameCount) {
    this.frameWidth = frameWidth;
    this.frameHeight = frameHeight;
    image = new BufferedImage(frameWidth * frameCount, frameHeight,
            BufferedImage.TYPE_INT_ARGB);
  }

  void blit(IterationItem item) {
    Graphics imageGraphics = image.getGraphics();
    imageGraphics.drawImage(item.image,
            frameWidth * item.frame, 0,
            frameWidth, frameHeight, null);
  }

  void save(File file) throws IOException {
    if (file.exists()) {
      file.delete();
    }
    
    file.createNewFile();
    ImageIO.write(image, "png", file);
  }

}
