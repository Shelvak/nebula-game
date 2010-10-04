/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package spacemule;

import org.junit.AfterClass;
import org.junit.BeforeClass;
import org.junit.Test;
import static org.junit.Assert.*;

/**
 *
 * @author arturas
 */
public class RunnerTest {

  public RunnerTest() {
  }

  @BeforeClass
  public static void setUpClass() throws Exception {
  }

  @AfterClass
  public static void tearDownClass() throws Exception {
  }

  /**
   * Test of main method, of class Runner.
   */
  @Test
  public void testDispatchCommand() throws Exception {
    Runner.dispatchCommand(
      "{\"from_jumpgate\":{\"type\":2,\"x\":3,\"y\":90,\"id\":2},\"from\":{\"type\":2,\"x\":0,\"y\":0,\"id\":1},\"action\":\"find_path\",\"to\":{\"type\":2,\"x\":0,\"y\":0,\"id\":3},\"from_solar_system\":{\"x\":1,\"galaxy_id\":1,\"y\":1,\"id\":1,\"orbit_count\":4},\"to_jumpgate\":{\"type\":2,\"x\":3,\"y\":180,\"id\":4},\"to_solar_system\":{\"x\":5,\"galaxy_id\":1,\"y\":5,\"id\":2,\"orbit_count\":4}}"
    );
  }

}