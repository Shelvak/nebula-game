package spacemule.helpers

import collection.SeqLike
import java.awt.Rectangle
import spacemule.modules.pmg.classes.geom.Coords
import java.util.Calendar
import scala.collection.Map
import scala.collection.mutable
import java.math.BigDecimal

object Converters {
  implicit def intToSmartInt(int: Int) = new SmartInt(int)
  implicit def stringToSmartString(string: String) = new SmartString(string)
  implicit def mapToSmartMap[K, V](map: Map[K, V]) = new SmartMap[K, V](map)
  implicit def mapToSmartMutableMap[K, V](map: mutable.Map[K, V]) =
    new SmartMutableMap[K, V](map)
  implicit def rectangleToSmartRectangle(rectangle: Rectangle) =
    new SmartRectangle(rectangle)
  implicit def sequenceToSmartSequence[T, Repr](sequence: SeqLike[T, Repr]) =
    new SmartSequence[T, Repr](sequence)
  implicit def travesableOnceToSmart[T](traversable: TraversableOnce[T]) =
    new SmartTraversableOnce[T](traversable)
  implicit def rangeToSmartRange(range: Range) = new SmartRange(range)
}

class SmartTraversableOnce[+T](traversable: TraversableOnce[T]) {
  /**
   * Iterates over collection and yields items and their indexes.
   */
  def foreachWithIndex[U](function: (T, Int) => U) {
    var index = 0
    traversable.foreach { item =>
      function(item, index)
      index += 1
    }
  }
}

class SmartInt(int: Int) {
  def times(block: () => Any) = (0 until int).foreach { i => block() }
  def times(block: Int => Any) = (0 until int).foreach { i => block(i) }

  def seconds = int
  def minutes = int * 60
  def hours = int * 3600
  def days = int * 3600 * 24
  def weeks = int * 3600 * 24 * 7
  def months = int * 3600 * 24 * 31

  def fromNow = {
    val calendar = Calendar.getInstance
    calendar.add(Calendar.SECOND, int)
    calendar
  }
  
  def toBigDecimal = new BigDecimal(int)
}

class SmartString(string: String) {
  /**
   * Turns CamelCase to camel_case.
   */
  def underscore: String = {
    var underscored = string
    underscored = underscored.replaceAll("([A-Z]+)([A-Z][a-z])", "$1_$2")
    underscored = underscored.replaceAll("([a-z\\d])([A-Z])", "$1_$2")
    underscored = underscored.replace('-', '_').toLowerCase
    underscored
  }

  /**
   * Turns under_score to UnderScore.
   */
  def camelcase: String = {
    var camelcased = "";
    string.split("_").foreach { part =>
      camelcased += Character.toUpperCase(part.charAt(0))
      camelcased += part.substring(1)
    }
    camelcased
  }
}

class SmartMap[K, +V](map: Map[K, V]) {
  /**
   * Retrieves key or raises exception with errorMessage if key is non-existant.
   * Returns None if value is null.
   */
  def getOptOrError(key: K, errorMessage: String): Option[V] =
    map.get(key) match {
      case Some(null) => None
      case Some(value: Any) => Some(value.asInstanceOf[V])
      case None => sys.error(errorMessage)
    }

  def getOptOrError(key: K): Option[V] = getOptOrError(
    key, "%s must be defined for %s!".format(key, map.toString()))

  /**
   * Retrieves key or raises exception with errorMessage if key is non-existant.
   */
  def getOrError(key: K, errorMessage: String): V =
    map.get(key) match {
      case Some(null) => sys.error("cannot cast null to wanted class!")
      case Some(value: Any) => value.asInstanceOf[V]
      case None => sys.error(errorMessage)
    }

  def getOrError(key: K): V = getOrError(
    key, "%s must be defined for %s!".format(key, map.toString()))
}

class SmartMutableMap[K, V](map: mutable.Map[K, V]) {
  /**
   * Only set value if map does not contain key.
   */
  def ||=(key: K, value: => V) = if (! map.contains(key)) map(key) = value
}

class SmartRectangle(rectangle: Rectangle) {
  def area: Int = rectangle.width * rectangle.height
  def coord: Coords = new Coords(rectangle.x, rectangle.y)

  /**
   * xEnd (exclusive)
   */
  def xEnd: Int = rectangle.x + rectangle.width
  /**
   * yEnd (exclusive)
   */
  def yEnd: Int = rectangle.y + rectangle.height
}

class SmartSequence[+T, +Repr](sequence: SeqLike[T, Repr]) {
  def random: T = {
    val size = sequence.size
    if (size == 0) {
      throw new IllegalStateException(
        "Sequence " + sequence + " is empty, cannot give random element!"
      )
    }
    sequence(Random.nextInt(size))
  }

  /**
   * Retrieves element from sequence. Ensures that out of bounds never occurs
   * by moding index by sequence size.
   */
  def wrapped(index: Int): T = sequence(index % sequence.size)

  /**
   * Returns this sequence shuffled. Returns new collection.
   */
  def shuffled = sequence.sortWith { case (_, _) => Random.nextBoolean() }
}

class SmartRange(range: Range) {
  def random: Int = {
    val randEnd = (range.end - range.start + {
      if (range.isInclusive) 1 else 0
    }) / range.step
    
    range.start + Random.nextInt(randEnd) * range.step 
  }

  /**
   * Allows getting random values in grade.
   */
  def random(grade: Double): Double = {
    val start = (range.start / grade).toInt
    val end = (range.end / grade).toInt
    val step = (range.step / grade).toInt
    val newRange = if (range.isInclusive) Range.inclusive(start, end, step)
      else Range(start, end, step)
    
    new SmartRange(newRange).random * grade
  }
}