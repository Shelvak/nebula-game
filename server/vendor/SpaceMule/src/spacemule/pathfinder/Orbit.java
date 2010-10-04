package spacemule.pathfinder;

import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.TreeMap;

/**
 *
 * @author arturas
 */
public class Orbit implements Iterable<OrbitPoint> {
  private int position;
  private List<Integer> angles;
  private Map<Integer, OrbitPoint> points = new TreeMap<Integer, OrbitPoint>();

  /**
   *
   * @param index Indexed from 1
   */
  public Orbit(int position) {
    if (position < 0)
      throw new IllegalArgumentException(
        "Position cannot be < 0, but " + position + " was given."
      );

    this.position = position;

    angles = new ArrayList<Integer>(getNumOfPoints());

    int quarterPointDegrees = getQuarterPointDegrees();
    int pointIndex = 0;
    int numOfQuarterPoints = getNumOfQuarterPoints();
    for (int quarter = 0; quarter < 360; quarter += 90) {
      for (int quarterPointIndex = 0;
      quarterPointIndex < numOfQuarterPoints;
      quarterPointIndex++) {
        int angle = quarter + quarterPointIndex * quarterPointDegrees;
        points.put(angle, new OrbitPoint(position, angle, pointIndex));
        angles.add(angle);
        pointIndex++;
      }
    }
  }

  public int getPosition() {
    return position;
  }

  public int getPointMaxIndex() {
    return angles.size() - 1;
  }

  public OrbitPoint getPointByIndex(int index) {
    return getPointByAngle(angles.get(index));
  }

  public OrbitPoint getPointByAngle(int angle) {
    if (points.containsKey(angle))
      return points.get(angle);
    else
      throw new IllegalArgumentException("Orbit " +
        position + " does not contain angle " + angle + "!");
  }

  private int getNumOfPoints() {
    return 4 + 4 * position;
  }

  private int getNumOfQuarterPoints() {
    return position + 1;
  }

  private int getQuarterPointDegrees() {
    return 90 / getNumOfQuarterPoints();
  }

  public Iterator<OrbitPoint> iterator() {
    return points.values().iterator();
  }
}
