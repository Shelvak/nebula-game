package planetmapgenerator;

import java.util.HashSet;
import java.util.Set;

class TilesMap implements Cloneable {
  private Set<Pair> tiles = new HashSet<Pair>();
  private boolean needsUpdating;
  private Pair keys[];

  @Override
  protected TilesMap clone() {
    TilesMap clone = new TilesMap();
    clone.setCloneAttrs(tiles, keys, needsUpdating);
    return clone;
  }

  public void setCloneAttrs(Set<Pair> tiles, Pair keys[],
          boolean needsUpdating) {
      this.tiles = tiles;
      this.keys = keys;
      this.needsUpdating = needsUpdating;
  }

  TilesMap() {
    this.keys = null;
    this.needsUpdating = true;
  }

  int size() {
    return this.tiles.size();
  }

  void add(Pair c) {
    if (this.tiles.add(c)) {
      this.needsUpdating = true;
    }
  }

  void remove(Pair c) {
    if (this.tiles.remove(c)) {
      this.needsUpdating = true;
    }
  }

  Pair random() {
    this.update_keys();

    int index = Rand.range(0, this.tiles.size());
    return this.keys[index];
  }

  void update_keys() {
    if (this.needsUpdating) {
      this.needsUpdating = false;

      this.keys = new Pair[this.tiles.size()];
      int i = 0;
      for (Pair c: tiles) {
        keys[i] = c;
        i++;
      }
    }
  }
};
