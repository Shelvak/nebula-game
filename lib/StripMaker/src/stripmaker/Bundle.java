package stripmaker;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.util.zip.ZipEntry;
import java.util.zip.ZipOutputStream;
import javax.imageio.ImageIO;
import stripmaker.gatherer.IterationItem;

/**
 *
 * @author arturas
 */
public class Bundle {
  private ZipOutputStream zip;

  public Bundle(File outFile) throws FileNotFoundException {
    if (outFile.exists()) {
      outFile.delete();
    }
    
    zip = new ZipOutputStream(new FileOutputStream(outFile));
  }

  public void writeMetadata(String metadata) throws IOException {
    zip.putNextEntry(new ZipEntry("metadata.yml"));
    zip.write(metadata.getBytes());
    zip.closeEntry();
  }

  public void addFrame(IterationItem item) throws IOException {
    zip.putNextEntry(getFrameZipEntry(item.frame));
    ImageIO.write(item.image, "png", zip);
    zip.closeEntry();
  }

  public void close() throws IOException {
    zip.close();
  }

  private ZipEntry getFrameZipEntry(int frame) {
    return new ZipEntry(String.format("%04d.png", frame));
  }
}
