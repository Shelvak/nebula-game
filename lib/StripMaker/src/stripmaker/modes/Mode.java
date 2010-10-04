/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package stripmaker.modes;

import com.mortennobel.imagescaling.AdvancedResizeOp.UnsharpenMask;
import java.awt.Rectangle;
import java.io.IOException;
import java.util.HashMap;
import java.util.Map;
import stripmaker.gatherer.Gatherer;

/**
 *
 * @author arturas
 */
public abstract class Mode {
  public Rectangle getStartArea(Gatherer gatherer) throws IOException {
    return null;
  }

  protected final static Map<Integer, UnsharpenMask> sharpens =
    new HashMap<Integer, UnsharpenMask>();
  static {
    sharpens.put(0, UnsharpenMask.None);
    sharpens.put(1, UnsharpenMask.Soft);
    sharpens.put(2, UnsharpenMask.Normal);
    sharpens.put(3, UnsharpenMask.VerySharp);
    sharpens.put(4, UnsharpenMask.Oversharpened);
  }

  protected UnsharpenMask unsharpenMask = UnsharpenMask.Soft;
  public UnsharpenMask getUnsharpenMask() {
    return unsharpenMask;
  }

  public void setUnsharpenMaskIndex(int index) {
    this.unsharpenMask = sharpens.get(index);
  }


  abstract public int getTargetWidth(Rectangle commonRect);
  abstract public int getTargetHeight(Rectangle commonRect);
}
