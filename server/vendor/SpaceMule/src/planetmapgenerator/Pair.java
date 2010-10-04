package planetmapgenerator;

public class Pair implements Comparable<Pair> {
  Integer x;
  Integer y;

  public Pair() {
  }

  public Pair(Integer x, Integer y) {
    this.x = x;
    this.y = y;
  }

  int rand() {
    return Rand.range(x, y + 1);
  }

  @Override
  public boolean equals(Object obj) {
    if (obj instanceof Pair) {
      Pair other = (Pair) obj;
      return x == other.x && y == other.y;
    }
    else {
      return false;
    }
  }

  @Override
  public int hashCode() {
    int hash = 7;
    hash = 29 * hash + (this.x != null ? this.x.hashCode() : 0);
    hash = 29 * hash + (this.y != null ? this.y.hashCode() : 0);
    return hash;
  }

  public int compareTo(Pair other) {
    if (x.equals(other.x)) {
      return y.compareTo(other.y);
    } else {
      return x.compareTo(other.x);
    }
  }
}
