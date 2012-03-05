/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package spacemule.persistence

import com.mysql.jdbc.exceptions.jdbc4.CommunicationsException
import java.text.SimpleDateFormat
import java.util.Calendar
import java.util.Date
import scala.collection.mutable.ListBuffer
import java.sql.{SQLException, Connection, DriverManager, ResultSet}
import org.apache.commons.io.{FileUtils, IOUtils}
import java.io.{FileWriter, File}

object DB {
  class LoadInFileException(
    filePath: String, tableName: String, columns: String, data: String,
    cause: Throwable
  ) extends RuntimeException(
    """Error while LOAD DATA INFILE from %s to %s

Data was:
%s
%s

Original exception:
%s
""".format(
      filePath, tableName, columns, data, cause.toString
    ),
    cause
  )
  
  /**
   * Use this instead of NULL if you're using loadInFile()
   */
  val loadInFileNull = "\\N"

  /**
   * Format date to db string.
   */
  def date(date: Date): String =
    new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(date)

  def date(calendar: Calendar): String = date(calendar.getTime)
  def date(calendar: Option[Calendar]): String = calendar match {
    case Some(cal) => date(cal)
    case None | null => loadInFileNull
  }

  private var connection: Connection = null
  private var connStr: String = null

  def connect(connStr: String): Unit = {
    // Load the driver
    Class.forName("com.mysql.jdbc.Driver").newInstance

    // Setup the connection
    connection = DriverManager.getConnection(connStr)
  }

  def connect(host: String, port: Int, user: String, password: String, 
              dbName: String): Unit = {
    connStr = (
      "jdbc:mysql://%s:%d/%s?user=%s&password=%s&characterEncoding=UTF8"
    ).format(
      host, port, dbName, user, password
    )
    connect(connStr)
  }
  
  def connect(host: String, user: String, password: String, 
              dbName: String): Unit = {
    connect(host, 3306, user, password, dbName)
  }

  private[this] def reconnect() {
    connect(connStr)
  }

  /**
   * This prevents dreaded
   *
   * "com.mysql.jdbc.exceptions.jdbc4.CommunicationsException: The last packet
   * successfully received from the server was 88,235,472 milliseconds ago.
   * The last packet sent successfully to the server was 88,235,472
   * milliseconds ago. is longer than the server configured value of
   * 'wait_timeout'. You should consider either expiring and/or testing
   * connection validity before use in your application, increasing the server
   * configured values for client timeouts, or using the Connector/J
   * connection property 'autoReconnect=true' to avoid this problem."
   *
   * exception by ensuring we have a live connection.
   */
  private[this] def ensureConnection() {
    if (! connection.isValid(1)) reconnect()
  }

  def close() = if (connection != null) connection.close

  def exec(sql: String): Int = {
    val statement = connection.createStatement
    statement.executeUpdate(sql)
  }

  def transaction(func: () => Unit) {
    ensureConnection()

    val autocommit = connection.getAutoCommit
    
    try {
      connection.setAutoCommit(false)
      func()
      connection.commit()
    }
    catch {
      case e: Exception =>
        connection.rollback()
        throw e
    }
    finally {
      connection.setAutoCommit(autocommit)
    }
  }

  /**
   * Loads data from values into table ultra quickly fast.
   *
   * See http://dev.mysql.com/doc/refman/5.1/en/load-data.html for
   * information how to avoid being sql injected by using this.
   */
  def loadInFile(tableName: String, columns: String, values: Seq[String]) = {
    if (values.isEmpty)
      throw new IllegalArgumentException(
        "Cannot save empty values list to table '%s' with columns '%s'!".format(
          tableName, columns
        )
      )
    
    val file = File.createTempFile("bulk_sql-scala", null)
    file.setReadable(true, false); // Allow mysql to read that file.

    // Win32 support. Replace backslashes with double backslashes, because
    // mysql does its own backslash escaping, so we actually need to pass
    // "C:/tmp/foo" instead of "c:\tmp\foo". Thank god windows at least supports
    // '/' as path separator.
    val filename = file.getAbsolutePath.replace('\\', '/')
    // Define the query we are going to execute
    val statementText = (
      "LOAD DATA INFILE '%s' INTO TABLE `%s` (%s)"
    ).format(filename, tableName, columns)

    // Create StringBuilder to String that will become stream
    val builder = new StringBuilder()

    // Iterate over map and create tab-text string
    values.foreach { entry =>
      builder.append(entry)
      builder.append('\n')
    }

//    // Debugging material
//    def fileName(table: String, counter: Int=0): File = {
//      val file = new File("%s-%03d.tabFile".format(table, counter))
//      if (file.exists()) fileName(table, counter + 1) else file
//    }
//    FileUtils.writeStringToFile(
//      fileName(tableName),
//      "%s\n\n%s".format(columns.replace(',', '\t'), builder.toString)
//    )

    ensureConnection()

    // First create a statement off the connection
    val statement = connection.createStatement.asInstanceOf[
      com.mysql.jdbc.Statement]

    try {
      // Write contents to file.
      val writer = new FileWriter(file)
      writer.write(builder.toString)
      writer.close()

      // Execute the load infile
      statement.execute(statementText);
    }
    catch {
      case ex: Exception => throw new LoadInFileException(
        file.getAbsolutePath, tableName, columns, builder.toString, ex
      )
    }
    finally {
      statement.close()
      file.delete()
    }
  }

  def query(sql: String): ResultSet = {
    ensureConnection()

    // Configure to be Read Only
    val statement = connection.createStatement(
      ResultSet.TYPE_FORWARD_ONLY, ResultSet.CONCUR_READ_ONLY
    )

    statement.executeQuery(sql)
  }

  def getOne[T](sql: String): Option[T] = {
    val resultSet = query(sql)
    return if (resultSet.first)
      Some(resultSet.getObject(1).asInstanceOf[T])
    else
      None
  }

  def getCol[T](sql: String): List[T] = {
    val resultSet = query(sql)
    val list = ListBuffer[T]()
    while (resultSet.next) {
      list += resultSet.getObject(1).asInstanceOf[T]
    }

    return list.toList
  }
}
