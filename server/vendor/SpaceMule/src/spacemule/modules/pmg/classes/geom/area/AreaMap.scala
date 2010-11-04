package spacemule.modules.pmg.classes.geom.area

import spacemule.modules.pmg.classes.geom.Coords

object AreaMap {
  val DefaultValue = 0
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
        block(Coords(col, row), get(index(col, row)))
      }
    }
  }

  private def index(x: Int, y: Int): Int = {
    val index = y * width + x;
    if (x < 0 || y < 0 || x >= width || y >= height ||
        index > data.length - 1) {
      throw new ArrayIndexOutOfBoundsException(
        ("Error in AreaMap#index (w: %d, h: %d) x: %d, y: %d " +
         "is out of range!").format(
          width, height,
          x, y
        )
      );
    }

    return index
  }

  def get(index: Int) = data(index)
  def apply(c: Coords) = get(index(c.x, c.y))
  def set(index: Int, value: Int) = data(index) = value
  def update(c: Coords, value: Int) = set(index(c.x, c.y), value)
}