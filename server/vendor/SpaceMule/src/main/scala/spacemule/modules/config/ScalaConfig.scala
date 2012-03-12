package spacemule.modules.config

/**
 * Created by IntelliJ IDEA.
 * User: arturas
 * Date: 2/3/12
 * Time: 2:48 PM
 * To change this template use File | Settings | File Templates.
 */

trait ScalaConfig {
  def get[T](key: String, set: String): T

  def getOpt[T](key: String, set: String): Option[T]
}
