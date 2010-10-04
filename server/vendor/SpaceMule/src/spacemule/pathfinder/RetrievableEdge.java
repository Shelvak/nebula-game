package spacemule.pathfinder;

import org.jgrapht.graph.DefaultEdge;

/**
 *
 * @author arturas
 */
public class RetrievableEdge<V> extends DefaultEdge {
  private V source, target;

  public RetrievableEdge(V source, V target) {
    this.source = source;
    this.target = target;
  }

  @Override
  public V getSource() {
    return source;
  }

  @Override
  public V getTarget() {
    return target;
  }
}
