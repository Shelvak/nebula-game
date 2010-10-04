package stripmaker.processor;

import stripmaker.gatherer.Gatherer;
import stripmaker.gatherer.IterationItem;

/**
 *
 * @author arturas
 */
class Iterator extends stripmaker.gatherer.Iterator {
  private Processor processor;

  Iterator(Processor processor, Gatherer gatherer) {
    super(gatherer);
    this.processor = processor;
  }

  @Override
  public IterationItem next() {
    IterationItem item = super.next();
    item.image = processor.process(item.image);
    return item;
  }
}
