package stripmaker.utils;

import java.util.Arrays;
import java.util.Collections;
import java.util.List;

/**
 *
 * @author arturas
 */
public class SortedList {
  public static <T extends Comparable<T>> List<T> fromArray(T[] array)  {
    List<T> collection = Arrays.asList(array);
    Collections.sort(collection);
    return collection;
  }
}
