package stripmaker;

import java.awt.Point;
import stripmaker.gatherer.Action;
import stripmaker.gatherer.Gatherer;
import java.awt.Rectangle;
import java.io.BufferedWriter;
import java.io.File;
import java.io.FileWriter;
import java.io.IOException;
import java.io.StringWriter;
import java.util.ArrayList;
import java.util.List;

/**
 *
 * @author arturas
 */
public class InfoManager {
  public static String getMetadata(Gatherer gatherer, Rectangle processedRect,
          Rectangle box, Rectangle targetBox) {
    StringWriter out = new StringWriter();

    out.write("---\n");

    out.write("# Box where actual unit is in default action.\n");
    writeBoxProperties(out, "box", box);
    writeUnitProperties(out, targetBox);
    writeProjectileProperties(out);
    
    out.write("# Actions\n");
    writeActions(gatherer, out);

    return out.toString();
  }

  public static String getActions(Gatherer gatherer) {
    StringWriter out = new StringWriter();
    writeActions(gatherer, out);
    return out.toString();
  }

  private static void writeActions(Gatherer gatherer, StringWriter out) {
    List<Action> actions = gatherer.getActions();

    if (actions.size() < 2) {
      out.write("actions: {}\n");
    }
    else {
      out.write("actions:\n");

      int frameIndex = 1;
      for (Action action: actions) {
        if (! action.getName().equals(Gatherer.DEFAULT_ACTION)) {
          out.write(String.format("  %s:\n", action.getName()));
          out.write(String.format("    finish: [%s]\n",
                  action.getFramesString(frameIndex)
          ));
        }

        frameIndex += action.getFrameCount();
      }
    }
  }

  public static void save(Gatherer gatherer, String metadata)
          throws IOException {
    File file = new File(gatherer.getDataDirectory(), "metadata.yml");
    if (file.exists()) file.delete();
    file.createNewFile();

    BufferedWriter out = new BufferedWriter(new FileWriter(file));
    out.write(metadata);
    out.close();
  }

  public static String getGunPoints(ArrayList<Point> guns) {
    StringWriter out = new StringWriter();
    out.write("gun_points:\n");
    for (Point gun: guns) {
      out.write(String.format("  - [%d, %d]\n", gun.x, gun.y));
    }
    return out.toString();
  }

  private static void writeUnitProperties(StringWriter out, 
          Rectangle targetBox) {
    out.write("### Combat Participant properties ###\n");
    out.write("# Only useful if this asset is unit or shooting building.\n");
    out.write("# Guns\n");
    out.write("guns:\n");
    out.write("  - machine_gun\n");
    out.write("\n");
    out.write("# Gun points (where bullets appear).\n");
    ArrayList<Point> guns = new ArrayList<Point>();
    guns.add(new Point(0, 0));
    out.write(getGunPoints(guns));
    out.write("\n");
    out.write("# Target box (where bullets hit).\n");
    out.write(getBoxProperties("target_box", targetBox));
    out.write("\n");
    out.write("# Is this unit passable when dead?\n");
    out.write("dead.passable: false\n");
    out.write("\n");
    out.write("# Movement speed - pixels per second\n");
    out.write("move.speed: 20\n");
    out.write("\n");
    out.write("### End of Combat Participant properties ###\n");
    out.write("\n");
  }

  private static void writeProjectileProperties(StringWriter out) {
    out.write("### Projectile properties  ###\n");
    out.write("# Destination of projectile:\n");
    out.write("#   none - default, straight line\n");
    out.write("#   air-to-ground - for orbital bombers\n");
    out.write("#destination: air-to-ground\n");
    out.write("\n");
    out.write("# How many shots of this projectile should be fired?\n");
    out.write("shots: 1\n");
    out.write("\n");
    out.write("# Dispersion of the shots in Y axis in px\n");
    out.write("dispersion: 0\n");
    out.write("\n");
    out.write("# Movement speed - pixels per milisecond\n");
    out.write("move.speed: 1\n");
    out.write("# Delay between multiple shots in ms\n");
    out.write("shots.delay: 100\n");
    out.write("\n");
    out.write("### End of Projectile properties ###\n");
    out.write("\n");
  }

  public static String getBoxProperties(String key, Rectangle box) {
    StringWriter out = new StringWriter();
    writeBoxProperties(out, key, box);
    return out.toString();
  }

  private static void writeBoxProperties(StringWriter out, String key, 
          Rectangle box) {
    out.write(key + ":\n");
    out.write(String.format("  top_left: [%d, %d]\n", box.x, box.y));
    out.write(String.format("  bottom_right: [%d, %d]\n",
            box.x + box.width, box.y + box.height));
    out.write("\n");
  }
}
