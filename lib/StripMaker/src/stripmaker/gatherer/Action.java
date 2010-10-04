package stripmaker.gatherer;

import java.awt.image.BufferedImage;
import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;
import java.util.Iterator;
import java.util.List;
import javax.imageio.ImageIO;
import org.apache.commons.lang.StringUtils;
import stripmaker.utils.SortedList;

/**
 *
 * @author arturas
 */
public class Action implements Comparable<Action>, Iterable<File> {
  private String name;
  private File path;
  private ArrayList<File> frames = new ArrayList<File>();

  public Action(String actionName, File path) throws IOException {
    this.path = path;
    this.name = actionName;

    List<String> files = SortedList.fromArray(path.list());
    frames.ensureCapacity(files.size());
    
    for (String framePath: files) {
      if (framePath.endsWith(".png")) {
        frames.add(new File(path, framePath));
      }
    }
  }

  public String getName() {
    return name;
  }

  public int getFrameCount() {
    return frames.size();
  }

  public String getFramesString(int frameIndex) {
    String[] frameNumbers = new String[getFrameCount()];
    for (int index = 0; index < frameNumbers.length; index++) {
      frameNumbers[index] = String.format("%d", frameIndex - 1 + index);
    }

    return StringUtils.join(frameNumbers, ", ");
  }

  public int compareTo(Action action) {
    return name.compareTo(action.getName());
  }

  public Iterator<File> iterator() {
    return frames.iterator();
  }

  BufferedImage getFrame(int i) throws IOException {
    return ImageIO.read(frames.get(i));
  }
}
