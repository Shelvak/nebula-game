package spacemule.helpers.json;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.JSONValue;
import scala.Tuple2;
import scala.collection.Iterator;
import scala.collection.Map;
import scala.collection.Iterable;

/**
 *
 * @author arturas
 */
public class ScalaToJson {
  public static <T> String toJson(Iterable<T> iterable) {
    return JSONValue.toJSONString(convertValue(iterable));
  }

  public static <K, V> String toJson(Map<K, V> map) {
    return JSONValue.toJSONString(convertValue(map));
  }

  private static Object convertValue(Object input) {
    // A JSON object
    if (input instanceof Map) {
      Map map = (Map) input;
      JSONObject jsonObject = new JSONObject();

      for (Iterator iter = map.iterator(); iter.hasNext();) {
         Tuple2 tuple = (Tuple2) iter.next();
         jsonObject.put(convertValue(tuple._1()), convertValue(tuple._2()));
      }
      
      return jsonObject;
    }

    // Some kind of thingie we can map to array
    if (input instanceof Iterable) {
      JSONArray array = new JSONArray();

      for (Iterator iter = ((Iterable) input).iterator(); iter.hasNext();) {
         Object value = iter.next();
         array.add(convertValue(value));
      }

      return array;
    }

    return input;
  }
}
