package spacemule.pathfinder;

/**
 *
 * @author arturas
 */
public class EdgeFactory<V, E extends RetrievableEdge>
        implements org.jgrapht.EdgeFactory<V, E> {
  public E createEdge(V source, V target) {
    return (E) new RetrievableEdge<V>(source, target);
  }
}
