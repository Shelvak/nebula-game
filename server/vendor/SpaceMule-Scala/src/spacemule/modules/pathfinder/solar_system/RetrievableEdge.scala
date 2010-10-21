/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package spacemule.modules.pathfinder.solar_system

import org.jgrapht.graph.DefaultEdge

class RetrievableEdge[V](val source: V, val target: V) 
    extends DefaultEdge {

  override def getSource(): V = source
  override def getTarget(): V = target
}
