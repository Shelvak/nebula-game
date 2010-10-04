/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package planetmapgenerator;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

/**
 *
 * @author arturaz
 */
public class Config {
  private static Map config = null;

  static boolean hasConfig() {
    return config != null;
  }

  static void setConfig(Map config) {
    Config.config = config;
  }

  static Object get(String key) {
    return get(key, true);
  }

  static Object get(String key, boolean critical) {
    Object value = config.get(key);
    if (value == null && critical) {
      System.err.println(
              "[JAVA] Config key '" + key + "' not found! Exiting!");
      System.exit(1);
    }

    return value;
  }

  static int getInt(String key) {
    return getInt(key, true);
  }

  static int getInt(String key, boolean critical) {
    return ((Long) get(key, critical)).intValue();
  }

  static boolean getBoolean(String key) {
    return getBoolean(key, true);
  }

  static boolean getBoolean(String key, boolean critical) {
    return (Boolean) get(key, critical);
  }

  static List getList(String key) {
    return getList(key, true);
  }

  static List getList(String key, boolean critical) {
    return (List) get(key, critical);
  }

  static String[] getMap(String key) {
    List<String> map = (ArrayList<String>) get(key);
    String[] stringArray = new String[map.size()];
    int index = 0;
    for (String line: map) {
      // YAML cuts off empty spaces at the end of a string.
      if (line.length() % 2 != 0) {
        line += " ";
      }

      stringArray[index] = line;
      index++;
    }
    
    return stringArray;
  }

  static int getVariationRand(String key) {
    return Rand.range(0, Config.getInt(key));
  }

  static int getRangeRand(String baseKey) {
    return new Pair(
            getInt(baseKey + ".from"),
            getInt(baseKey + ".to")
    ).rand();
  }

  static int getFolliageRand() {
    return getRangeRand("planet.folliage.area");
  }

  static String underscore(String name) {
    name = name.replaceAll("([A-Z]+)([A-Z][a-z])", "$1_$2");
    name = name.replaceAll("([a-z\\d])([A-Z])", "$1_$2");
    name = name.replace('-', '_').toLowerCase();
    return name;
  }

  static String camelcase(String name) {
    String camelcased = "";
    for (String part: name.split("_")) {
      camelcased += Character.toUpperCase(part.charAt(0));
      camelcased += part.substring(1);
    }
    return camelcased;
  }
}
