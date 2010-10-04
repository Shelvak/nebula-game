package planetmapgenerator;

import java.io.BufferedReader;
import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.Reader;
import java.util.Map;
import org.json.simple.JSONValue;

public class Runner {
  // Read two values from standart input and return them as range.

  static String readLine(BufferedReader in) throws IOException {
    String line;
    while ((line = in.readLine()) != null) {
      line = line.trim();
      if (!line.isEmpty() && !line.startsWith("#")) {
        return line;
      }
    }
    return null;
  }

  static Integer readInt(BufferedReader in) throws IOException {
    return readInts(in, 1)[0];
  }

  static Integer[] readInts(BufferedReader in, int number) throws IOException {
    String line = readLine(in);
    String pieces[] = line.split(" ");
    Integer ints[] = new Integer[number];

    for (int index = 0; index < number; index++) {
      ints[index] = Integer.parseInt(pieces[index]);
    }
    return ints;
  }

  static Integer[] readPair(BufferedReader in) throws IOException {
    return readInts(in, 2);
  }

  static Pair readRange(BufferedReader in) throws IOException {
    Integer pair[] = readPair(in);
    return new Pair(pair[0], pair[1]);
  }

  public static BufferedReader getReader(String[] args) throws FileNotFoundException {
    Reader source;
    // Read from file
    if (args.length == 2) {
      source = new FileReader(args[1]);
    }
    // Read from console
    else {
     source = new InputStreamReader(System.in);
    }
    return new BufferedReader(source);
  }

  /**
   * @param args the command line arguments
   */
  public static void main(String[] args) throws IOException {
    Generator generator = null;
    BufferedReader in = getReader(args);

    // Table names
    String table_names[] = readLine(in).split(" ");
    SqlDumper dumper = new SqlDumper(table_names[0], 
            table_names[1], table_names[2], table_names[3]);
    int galaxyId = Integer.parseInt(readLine(in));

    String line;
    String configBuffer = "";
    while ((line = readLine(in)) != null) {
      if (line.equals("end_of_config")) {
        try {
          Object obj = JSONValue.parse(configBuffer);
          Config.setConfig((Map) obj);
        }
        catch (Exception e) {
          System.err.println("Error while setting config!");
          System.err.println(e.toString());
          System.err.println(configBuffer);
        }

        generator = new Generator();
      }
      else if (! Config.hasConfig()) {
        configBuffer += line + "\n";
      }
      else {
        String pieces[] = line.split(" ");
        String mode = pieces[0];
        Integer planetId = Integer.parseInt(pieces[1]);

        if (mode.equals("generate")) {
          Pair size = new Pair(
                  Integer.parseInt(pieces[2]),
                  Integer.parseInt(pieces[3]));
          String type = pieces[4];

          generator.generate(size.x, size.y, type);
        }
        else if (mode.equals("homeworld")) {
          generator.homeworld();
        }
        else {
          System.err.println("Unknown mode: " + mode + "\n" +
                  "Input line: " + line);
          System.exit(1);
        }
        
        dumper.dump(galaxyId, planetId, generator);
      }
    }

    System.exit(0);
  }
}
