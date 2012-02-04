package spacemule.modules.pmg.classes.geom.area

import spacemule.modules.pmg.classes.geom.Coords

object AreaMap {
  val DefaultValue = -1
}

class AreaMap(width: Int, height: Int) {
  def this(area: Area) {
    this(area.width, area.height)
  }

  protected val data = Array.fill[Int](width * height) { AreaMap.DefaultValue }

  /**
   * Yields each x, y and value.
   */
  def foreach(block: (Coords, Int) => Unit) {
    (0 until height).foreach { row =>
      (0 until width).foreach { col =>
        block(Coords(col, row), apply(index(col, row)))
      }
    }
  }

  private def index(x: Int, y: Int): Int = {
    if (x < 0 || y < 0 || x >= width || y >= height)
      throw new ArrayIndexOutOfBoundsException(
        "Coordinates x: %d, y: %d are out of map! (w: %d, h: %d)".format(
          x, y, width, height
        )
      );
    
    val index = y * width + x;
    if (index > data.length - 1)
      throw new ArrayIndexOutOfBoundsException(
        "Coordinates x: %d, y: %d map to bad index %d (max: %d)!".format(
          index, data.length - 1
        )
      );

    return index
  }

  def apply(index: Int): Int = data(index)
  def apply(c: Coords): Int = apply(index(c.x, c.y))
  def update(index: Int, value: Int) { data(index) = value }
  def update(c: Coords, value: Int) { update(index(c.x, c.y), value) }
}