/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package spacemule.modules.pathfinder.objects

case class ServerLocation(id: Int, kind: Int, x: Option[Int], y: Option[Int]) {
  def toMap: Map[String, Any] = {
    return Map[String, Any](
      "id" -> id,
      "type" -> kind,
      "x" -> (x match {
        case Some(int: Int) => int
        case None => null
      }),
      "y" -> (y match {
        case Some(int: Int) => int
        case None => null
      })
    )
  }
}
