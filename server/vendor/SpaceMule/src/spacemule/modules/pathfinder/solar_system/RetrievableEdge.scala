/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package spacemule.modules.pathfinder.solar_system

import org.jgrapht.graph.DefaultEdge

class RetrievableEdge[V](val from: V, val to: V)
    extends DefaultEdge {

  override def getSource(): Object = from.asInstanceOf[Object]
  override def getTarget(): Object = to.asInstanceOf[Object]
}
