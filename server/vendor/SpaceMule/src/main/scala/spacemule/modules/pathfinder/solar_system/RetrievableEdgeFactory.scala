/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package spacemule.modules.pathfinder.solar_system

class RetrievableEdgeFactory[V]
    extends org.jgrapht.EdgeFactory[V, RetrievableEdge[V]] {

  def createEdge(source: V, target: V): RetrievableEdge[V] = {
    new RetrievableEdge[V](source, target)
  }
}