package spacemule;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.json.simple.parser.ParseException;

/**
 *
 * @author arturas
 */
public class Runner {
  private static JSONParser parser;
  static {
    parser = new JSONParser();
  }

  public static void main(String[] args) throws IOException {
    BufferedReader reader = new BufferedReader(
      new InputStreamReader(System.in));

    JSONObject input = null;
    JSONObject response = null;
    String line = null;
    while (true) {
      line = reader.readLine();

      // Exit if input is gone
      if (line == null) {
        System.exit(0);
      }

      try {
        response = dispatchCommand(line);
      }
      catch (ParseException ex) {
        response = new JSONObject();
        response.put("error", "parse_error");
        response.put("details", ex.getMessage());
      }

      if (response == null) {
        response = new JSONObject();
        response.put("error", "unknown_command");
        response.put("details", null);
      }

      System.out.println(response.toString());
    }
  }

  public static JSONObject dispatchCommand(String input) throws ParseException {
    Object result = parser.parse(input);
    if (result instanceof JSONObject) {
      return dispatchCommand((JSONObject) result);
    }
    else {
      throw new ParseException(ParseException.ERROR_UNEXPECTED_TOKEN);
    }
  }

  private static JSONObject dispatchCommand(JSONObject input) {
    if (! input.containsKey("action")) {
      return null;
    }

    String action = (String) input.get("action");
    if (action.equals("find_path")) {
      return spacemule.pathfinder.Runner.run(input);
    }
    else {
      return null;
    }
  }
}
