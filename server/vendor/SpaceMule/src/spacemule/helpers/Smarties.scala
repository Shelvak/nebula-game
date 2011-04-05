package spacemule.helpers

import collection.SeqLike
import java.awt.Rectangle
import spacemule.helpers.json.Json
import spacemule.modules.pmg.classes.geom.Coords
import java.util.Calendar
import scala.{collection => sc}
import scalaj.collection.Implicits._
import java.math.BigDecimal

/**
 * Created by IntelliJ IDEA.
 * User: arturas
 * Date: Oct 13, 2010
 * Time: 2:22:34 PM
 * To change this template use File | Settings | File Templates.
 */

object Converters {
  implicit def intToSmartInt(int: Int) = new SmartInt(int)
  implicit def stringToSmartString(string: String) = new SmartString(string)
  implicit def mapToSmartMap[K, V](map: Map[K, V]) = new SmartMap[K, V](map)
  implicit def mapToSmartMap[K, V](map: sc.Map[K, V]) = new SmartMap[K, V](map)
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
  def foreachWithIndex[U](function: (T, Int) => U): Unit = {
    var index = 0
    traversable.foreach { item =>
      function(item, index)
      index += 1
    }
  }
}

class SmartInt(int: Int) {
  def times(block: () => Unit) = (0 until int).foreach { i => block() }
  def times(block: Int => Unit) = (0 until int).foreach { i => block(i) }

  def fromNow() = {
    val calendar = Calendar.getInstance
    calendar.add(Calendar.SECOND, int)
    calendar
  }
}

class SmartString(string: String) {
  /**
   * Turns CamelCase to camel_case.
   */
  def underscore: String = {
    var underscored = string
    underscored = underscored.replaceAll("([A-Z]+)([A-Z][a-z])", "$1_$2")
    underscored = underscored.replaceAll("([a-z\\d])([A-Z])", "$1_$2")
    underscored = underscored.replace('-', '_').toLowerCase()
    return underscored
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
    return camelcased
  }
}

class SmartMap[K, +V](map: sc.Map[K, V]) {
  /**
   * Retrieves key or raises exception with errorMessage.
   */
  def getOrError(key: K, errorMessage: String): V = {
    return map.get(key) match {
      case Some(value: Any) => {
        if (value == null) error("cannot cast null to wanted class!")
        else value.asInstanceOf[V]
      }
      case None => error(errorMessage)
    }
  }

  def getOrError(key: K): V = getOrError(
    key, "%s must be defined for %s!".format(key, map.toString))

  def toJson() = Json.toJson[K, V](map)
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
  def random:T = {
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
}

class SmartRange(range: Range) {
  def random:Int = {
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
    
    return new SmartRange(newRange).random * grade
  }
}