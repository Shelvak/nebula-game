/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package spacemule.helpers.json

import org.json.simple.parser.ParseException
import scala.collection.Map

object Json {
  def parseMap(input: String): Option[Map[String, Object]] = {
    try {
      val parsed = JsonToScala.parseMap(input)
      return if (parsed == null) None else Some(parsed)
    }
    catch {
      case (ex: ParseException) => return None
    }
  }

  def toJson[T](iterable: Iterable[T]): String = ScalaToJson.toJson[T](iterable)

  def toJson[K, V](map: Map[K, V]): String = ScalaToJson.toJson[K, V](map)
}
