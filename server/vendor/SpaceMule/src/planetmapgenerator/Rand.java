package planetmapgenerator;

import java.util.Random;

public class Rand {
  static int rand(int max) {
    Random r = new Random();
    return r.nextInt(max);
  }

  static int range(int min, int max) {
    Random r = new Random();
    return min + (r.nextInt(Math.abs(min - max)));
  }
}
