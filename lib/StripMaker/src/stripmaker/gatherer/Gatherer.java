package stripmaker.gatherer;

import java.awt.image.BufferedImage;
import java.io.BufferedReader;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import stripmaker.utils.SortedList;

/**
 *
 * @author arturas
 */
public class Gatherer implements Iterable<IterationItem> {

  public final static String DEFAULT_ACTION = "default";
  private File dataDirectory;
  private String metadata = "";
  private List<Action> actions = new ArrayList<Action>();
  private Action defaultAction = null;

  public Gatherer(String dataDirName) throws IOException {
    dataDirectory = new File(dataDirName);

    if (!dataDirectory.exists() || !dataDirectory.isDirectory()) {
      throw new FileNotFoundException(
        "Data directory '" + dataDirectory.toString() + "' does not exist!");
    }

    readActions();
    readMetadata();
  }

  public File getDataDirectory() {
    return dataDirectory;
  }

  public List<Action> getActions() {
    return actions;
  }

  public String getMetadata() {
    return metadata;
  }

  public int getFrameCount() {
    int count = 0;

    for (Action action : actions) {
      count += action.getFrameCount();
    }

    return count;
  }

  public BufferedImage getBoxFrame() throws IOException {
    if (defaultAction != null) {
      return defaultAction.getFrame(0);
    } else {
      throw new FileNotFoundException("No default action (name: "
        + DEFAULT_ACTION + "), cannot get box!");
    }
  }

  public java.util.Iterator<IterationItem> iterator() {
    return new Iterator(this);
  }

  private void readActions() throws IOException {
    for (String actionDirPath : SortedList.fromArray(dataDirectory.list())) {
      File actionDir = new File(dataDirectory, actionDirPath);
      if (actionDir.isDirectory()) {
        // Skip directories without _ in them.
        if (actionDirPath.indexOf("_") != -1) {
          String[] parts = actionDirPath.split("_", 2);
          String actionName = parts[1];

          Action action = new Action(actionName, actionDir);
          actions.add(action);

          if (actionName.equals(DEFAULT_ACTION)) {
            defaultAction = action;
          }
        }
      }
    }

    if (actions.isEmpty()) {
      throw new RuntimeException(
        "No actions were found, are you sure you didn't forget to include "
        + "them? \n"
        + "\n"
        + "Actions should be named in such fashion: 00_fire_gun_0"
      );
    }
  }

  private void readMetadata() throws IOException {
    File metadataFile = new File(dataDirectory, "metadata.yml");
    if (metadataFile.exists()) {
      BufferedReader in = new BufferedReader(
        new FileReader(metadataFile));

      while (in.ready()) {
        metadata += in.readLine() + "\n";
      }

      in.close();
    } else {
      metadata = null;
    }
  }
}
