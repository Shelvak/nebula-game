/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package spacemule;

import java.io.IOException;

/**
 *
 * @author arturas
 */
public class Main {

  /**
   * @param args the command line arguments
   */
  public static void main(String[] args) throws IOException {
    if (args.length > 0) {
      if (args[0].equals("planet_map_generator")) {
        planetmapgenerator.Runner.main(args);
      }
      else if (args[0].equals("mule")) {
        Runner.main(args);
      }
      else {
        System.err.println("Unknown param: " + args[0]);
        System.err.println();
        usage();
        System.exit(1);
      }
    }
    else {
      usage();
      System.exit(1);
    }
  }

  private static void usage() {
    System.err.println("Usage: java -jar SpaceMule.jar mode");
    System.err.println();
    System.err.println("Modes:");
    System.err.println("  planet_map_generator - generates planet maps.");
    System.err.println("  mule - heavy work lifter.");
  }
}
