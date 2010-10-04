package stripmaker.gatherer;

import java.io.File;
import java.io.IOException;
import java.util.List;
import javax.imageio.ImageIO;

/**
 *
 * @author arturas
 */
public class Iterator implements java.util.Iterator<IterationItem> {
  private Gatherer gatherer;
  private List<Action> actions;
  private java.util.Iterator<File> actionIterator;
  private int actionIndex = -1;
  private int frameIndex = 0;

  public Iterator(Gatherer gatherer) {
    this.gatherer = gatherer;
    this.actions = gatherer.getActions();
    nextAction();
  }

  public boolean hasNext() {
    boolean hasNext = actionIterator.hasNext();
    if (hasNext) {
      return true;
    }
    else {
      return (actionIndex + 1 != actions.size());
    }
  }

  public IterationItem next() {
    boolean hasNext = actionIterator.hasNext();
    if (! hasNext) {
      nextAction();
    }

    IterationItem item = null;
    try {
      item = new IterationItem(
              ImageIO.read(actionIterator.next()),
              frameIndex);
      frameIndex++;
    } catch (IOException ex) {}
    
    return item;
  }

  public void remove() {
    throw new UnsupportedOperationException("Not supported yet.");
  }

  private void nextAction() {
    actionIndex++;
    this.actionIterator = actions.get(actionIndex).iterator();
  }

}
