package stripmaker.gui;

import javax.swing.InputVerifier;
import javax.swing.JComponent;
import javax.swing.JTextField;

/**
 *
 * @author arturas
 */
public class NumberInputVerifier extends InputVerifier {

  @Override
  public boolean verify(JComponent jc) {
    JTextField tf = (JTextField) jc;
    try {
      return Integer.parseInt(tf.getText()) > 0;
    }
    catch (NumberFormatException e) {
      return false;
    }
  }

}
