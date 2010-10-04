package spacemule.pathfinder;

import spacemule.pathfinder.locations.Locatable;
import spacemule.pathfinder.locations.Location;

/**
 *
 * @author arturas
 */
public class OrbitPoint {
  public int angle, position, index;

  public OrbitPoint(int position, int angle, int index) {
    this.angle = angle;
    this.position = position;
    this.index = index;
  }

  @Override
  public String toString() {
    return String.format("<Point:%d position: %d, angle: %d>", index,
            position,
            angle);
  }
}
