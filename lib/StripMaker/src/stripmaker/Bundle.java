package stripmaker;

import com.sun.xml.internal.ws.util.ByteArrayBuffer;
import java.io.BufferedOutputStream;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.util.Date;
import java.util.zip.GZIPOutputStream;
import javax.imageio.ImageIO;
import org.apache.commons.compress.archivers.tar.TarArchiveEntry;
import org.apache.commons.compress.archivers.tar.TarArchiveOutputStream;
import stripmaker.gatherer.IterationItem;

/**
 *
 * @author arturas
 */
public class Bundle {
  private TarArchiveOutputStream archive;

  public Bundle(File outFile) throws FileNotFoundException, IOException {
    if (outFile.exists()) {
      outFile.delete();
    }
    
    archive = new TarArchiveOutputStream(new GZIPOutputStream(
      new BufferedOutputStream(new FileOutputStream(outFile))));
  }

  public void writeMetadata(String metadata) throws IOException {
    archive.putArchiveEntry(getTarEntry("metadata.yml", metadata.length()));
    archive.write(metadata.getBytes());
    archive.closeArchiveEntry();
  }

  public void addFrame(IterationItem item) throws IOException {
    ByteArrayBuffer buffer = new ByteArrayBuffer();
    ImageIO.write(item.image, "png", buffer);
    byte[] bytes = buffer.getRawData();

    archive.putArchiveEntry(
      getTarEntry(getFrameName(item.frame), bytes.length));
    archive.write(bytes);
    archive.closeArchiveEntry();
  }

  public void close() throws IOException {
    archive.close();
  }

  private TarArchiveEntry getTarEntry(String name, long size) {
    TarArchiveEntry entry = new TarArchiveEntry(name);
    entry.setIds(0, 0);
    entry.setNames("root", "root");
    entry.setModTime(new Date());
    entry.setMode(entry.DEFAULT_FILE_MODE);
    entry.setSize(size);
    return entry;
  }

  private String getFrameName(int frame) {
    return String.format("%04d.png", frame);
  }
}
