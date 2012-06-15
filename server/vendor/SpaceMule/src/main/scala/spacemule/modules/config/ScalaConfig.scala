package spacemule.modules.config

import scala.{collection => sc}

/**
 * Created by IntelliJ IDEA.
 * User: arturas
 * Date: 2/3/12
 * Time: 2:48 PM
 * To change this template use File | Settings | File Templates.
 */

trait ScalaConfig {
  def any(key: String): Option[Any]
  def int(key: String): Option[Int]
  def float(key: String): Option[Float]
  def double(key: String): Option[Double]
  def string(key: String): Option[String]
  def symbol(key: String): Option[Symbol]
  def boolean(key: String): Option[Boolean]
  def array[T](key: String): Option[sc.Seq[T]]
  def hash[K, V](key: String): Option[sc.Map[K, V]]
}
