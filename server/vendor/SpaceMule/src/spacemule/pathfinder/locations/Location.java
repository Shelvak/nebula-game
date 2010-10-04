package spacemule.pathfinder.locations;

import org.json.simple.JSONObject;

/**
 *
 * @author arturas
 */
public class Location {
  // Objects here because they can be null.
  public Integer locationId, locationType, locationX, locationY;

  public Location(Integer locationId, Integer locationType, Integer locationX, Integer locationY) {
    if (locationId == null)
      throw new IllegalArgumentException("locationId cannot be null!");
    if (locationType == null)
      throw new IllegalArgumentException("locationType cannot be null!");

    this.locationId = locationId;
    this.locationType = locationType;
    this.locationX = locationX;
    this.locationY = locationY;
  }

  @Override
  public String toString() {
    return String.format("<Location id: %d, type: %d, x: %d, y: %d>",
            locationId,
            locationType,
            locationX,
            locationY);
  }

  public JSONObject toJSON() {
    JSONObject obj = new JSONObject();
    obj.put("id", locationId);
    obj.put("type", locationType);
    obj.put("x", locationX);
    obj.put("y", locationY);
    return obj;
  }

  public String toJSONString() {
    return toJSON().toString();
  }

  @Override
  public boolean equals(Object otherObject) {
    if (otherObject instanceof Location) {
      Location other = (Location) otherObject;
      return locationId.equals(other.locationId) &&
              locationType.equals(other.locationType) &&
              (
                locationX == null 
                  ? locationX == locationY
                  : locationX.equals(other.locationX)
              ) &&
              (
                locationY == null
                  ? locationY == locationY
                  : locationY.equals(other.locationY)
              );
    }
    else {
      return super.equals(otherObject);
    }
  }

  @Override
  public int hashCode() {
    int hash = 7;
    hash = 61 * hash + (this.locationId != null ? this.locationId.hashCode() : 0);
    hash = 61 * hash + (this.locationType != null ? this.locationType.hashCode() : 0);
    hash = 61 * hash + (this.locationX != null ? this.locationX.hashCode() : 0);
    hash = 61 * hash + (this.locationY != null ? this.locationY.hashCode() : 0);
    return hash;
  }
}
