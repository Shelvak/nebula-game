package stripmaker.modes;

import java.awt.Rectangle;

/**
 *
 * @author arturas
 */
public class Units extends Mode {
  protected int frameHeight;

  public Units(int frameHeight) {
    this.frameHeight = frameHeight;
  }

  public void setFrameHeight(int frameHeight) {
    this.frameHeight = frameHeight;
  }

  @Override
  public int getTargetWidth(Rectangle commonRect) {
    double ratio = ((double) frameHeight) / commonRect.height;
    return (int) Math.round(commonRect.width * ratio);
  }

  @Override
  public int getTargetHeight(Rectangle commonRect) {
    return frameHeight;
  }
}
