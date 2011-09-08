package spacemule.helpers.json;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.json.simple.parser.ParseException;
import scala.collection.mutable.HashMap;
import scala.collection.mutable.ListBuffer;
import scala.collection.immutable.Map;

/**
 *
 * @author arturas
 */
class JsonToScala {
  private static JSONParser parser = null;

  public static Map<String, Object> parseMap(String input)
      throws ParseException  {
    initializeParser();

    if (input.trim().equals("")) {
      return null;
    }

    Object result = parser.parse(input);

    if (result instanceof JSONObject) {
      return (Map<String, Object>) convertValue(result);
    }
    else {
      throw new IllegalArgumentException("input was not an json object");
    }
  }

  private static void initializeParser() {
    if (parser == null) {
      parser = new JSONParser();
    }
  }

  private static Object convertValue(Object input) {
    if (input instanceof String) return (String) input;
    if (input instanceof Integer) return (Integer) input;
    if (input instanceof Double) return (Double) input;
    if (input instanceof Long) return ((Long) input).intValue();
    if (input instanceof Boolean) return (Boolean) input;
    if (input == null) return null;

    if (input instanceof JSONArray) {
      JSONArray arr = (JSONArray) input;
      ListBuffer<Object> list = new ListBuffer<Object>();
      for (Object arrValue: arr) {
        list.$plus$eq(convertValue(arrValue));
      }

      return scala.collection.immutable.Nil.companion().apply(list);
    }

    if (input instanceof JSONObject) {
      HashMap<String, Object> map = new HashMap<String, Object>();
      JSONObject obj = (JSONObject) input;

      for (Object key: obj.keySet()) {
        Object value = convertValue(obj.get(key));
        map.put((String) key, value);
      }

      return new scala.collection.immutable.HashMap().$plus$plus(map);
    }

    throw new IllegalArgumentException(
      String.format("Don't know how to handle '%s' (class %s)!",
        input,
        input.getClass().getName()
      )
    );
  }
}
