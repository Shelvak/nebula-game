package spacemule.helpers

import collection.mutable.{HashMap, ArrayBuffer}

/**
 * Created by IntelliJ IDEA.
 * User: arturas
 * Date: Oct 14, 2010
 * Time: 3:59:27 PM
 * To change this template use File | Settings | File Templates.
 */

/**
 * An array which allows for fast picking of random indexes.
 *
 * It features a fast delete operation which does not keep order but works
 * in constant time.
 */
class RandomArray[T](val unique: Boolean, private val initialSize: Int) {
  def this(unique: Boolean) = this(unique, 16)
  def this(initialSize: Int) = this(true, initialSize)
  def this() = this(true, 16)

  /**
   * We store actual values here.
   */
  private val data = new ArrayBuffer[T](initialSize)

  /**
   * We cache T => index pairs here for fast -= operation.
   */
  private val lookup = new HashMap[T, Int]()

  /**
   * Number of items stored in this array
   */
  var size = 0

  override def toString = "<RandomArray(%d,%s)>".format(size,
    if (unique) "uniq" else "non-uniq"
  )

  def contains(value: T) = lookup.contains(value)

  override def clone(): RandomArray[T] = {
    val clone = new RandomArray[T](unique, size)
    (0 until size).foreach { index =>
      clone += data(index)
    }
    
    return clone
  }

  /**
   *  Add an value to array.
   */
  def +=(value: T) = {
    if (unique && contains(value)) {
      throw new IllegalArgumentException(
        "Cannot add " + value + " which is already added!"
      )
    }

    // Internal array holds some unnecessary data, overwrite it
    if (size < data.size) {
      data(size) = value
    }
    else {
      data += value
    }
    lookup(value) = size
    size += 1
  }

  /**
   * Remove by value. Fail if not found.
   */
  def -=(value: T) = this.remove(value, true)

  /**
   * Remove by value. DO NOT fail if not found.
   */
  def -=!(value: T) = this.remove(value, false)

  /**
   * Remove by value from array.
   */
  private def remove(value: T, failOnNotFound: Boolean) = {
    if (lookup.contains(value) || failOnNotFound) {
      internalRemove(value, lookup(value))
    }
  }

  /**
   * Removes value T which has index _index_ from RandomArray. 
   */
  private def internalRemove(value: T, index: Int) = {
    // Remove from hashset
    lookup -= value

    // We don't need any swapping if it's the last element in array.
    if (index != size - 1) {
      val last = data(size - 1)
      lookup(last) = index
      data(index) = last
    }

    // Downsize our array
    size -= 1
  }

  /**
   * Return a random index.
   */
  private def randomIndex: Int = Random.nextInt(size)

  /**
   * Return random element.
   */
  def random: T = data(randomIndex)

  /**
   * Takes random element, removes it from array and returns.
   *
   * This takes constant time.
   */
  def takeRandom: T = {
    val index = randomIndex
    val value = data(index)
    internalRemove(value, index)
    return value
  }
}