package stripmaker.processor;

import stripmaker.gatherer.Gatherer;
import stripmaker.gatherer.IterationItem;
import com.mortennobel.imagescaling.AdvancedResizeOp.UnsharpenMask;
import com.mortennobel.imagescaling.ResampleOp;
import java.awt.Rectangle;
import java.awt.image.BufferedImage;
import java.io.IOException;
import stripmaker.RectFinder;
import stripmaker.modes.Mode;

/**
 *
 * @author arturas
 */
public class Processor implements Iterable<IterationItem> {
  private Gatherer gatherer;
  private Rectangle commonRect;
  private int targetHeight;
  private int targetWidth;
  private ResampleOp resampleOp;

  public Processor(Gatherer gatherer, Rectangle commonRect, Mode mode) {
    this.gatherer = gatherer;
    this.commonRect = commonRect;
    this.targetWidth = mode.getTargetWidth(commonRect);
    this.targetHeight = mode.getTargetHeight(commonRect);
    resampleOp = new ResampleOp(targetWidth, targetHeight);
    resampleOp.setUnsharpenMask(mode.getUnsharpenMask());
  }

  public Rectangle getTargetSize() {
    return new Rectangle(0, 0, targetWidth, targetHeight);
  }

  public java.util.Iterator<IterationItem> iterator() {
    return new Iterator(this, gatherer);
  }

  public Rectangle getBox() throws IOException {
    BufferedImage frame = gatherer.getBoxFrame();
    if (frame == null) {
      return new Rectangle();
    }
    else {
      return RectFinder.find(process(frame));
    }
  }

  public BufferedImage process(BufferedImage frame) {
    // Crop the image
    frame = frame.getSubimage(commonRect.x, commonRect.y, commonRect.width,
            commonRect.height);

    // Resize it
    frame = resampleOp.filter(frame, null);

    return frame;
  }
}
