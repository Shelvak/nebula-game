package spacemule;

import org.json.simple.JSONObject;

/**
 *
 * @author arturas
 */
public class JSONUtils {
  public static int getInt(JSONObject input, String key) {
    return ((Long) input.get(key)).intValue();
  }
}
