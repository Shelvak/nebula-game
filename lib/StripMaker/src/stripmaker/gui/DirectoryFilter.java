package stripmaker.gui;

import java.io.File;
import javax.swing.filechooser.FileFilter;

/**
 *
 * @author arturas
 */
public class DirectoryFilter extends FileFilter {

  @Override
  public boolean accept(File file) {
    return file.isDirectory();
  }

  @Override
  public String getDescription() {
    return "Directories";
  }

}
