/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package spacemule.persistence

import com.mysql.jdbc.CommunicationsException
import java.sql.{Connection, DriverManager, ResultSet}
import java.text.SimpleDateFormat
import java.util.Calendar
import java.util.Date
import org.apache.commons.io.IOUtils
import scala.collection.mutable.ListBuffer

object DB {
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

  private def reconnect = connect(connStr)

  def close() = if (connection != null) connection.close

  def exec(sql: String): Int = {
    reconnecting { () =>
      val statement = connection.createStatement
      return statement.executeUpdate(sql)
    }
  }

  /**
   * Loads data from values into table ultra quickly fast.
   *
   * See http://dev.mysql.com/doc/refman/5.1/en/load-data.html for
   * information how to avoid being sql injected by using this.
   */
  def loadInFile(tableName: String, columns: String, values: Seq[String]) = {
    // Define the query we are going to execute
    val statementText = (
      "LOAD DATA LOCAL INFILE 'file.txt' INTO TABLE `%s` (%s)"
    ).format(tableName, columns)

    // Create StringBuilder to String that will become stream
    val builder = new StringBuilder()

    // Iterate over map and create tab-text string
    values.foreach { entry =>
      builder.append(entry)
      builder.append('\n')
    }

    // Debugging material
//    FileUtils.writeStringToFile(
//      new File("%s.tabFile".format(tableName)), builder.toString
//    )

    // Create stream from String Builder
    val inputStream = IOUtils.toInputStream(builder);

    reconnecting { () =>
      // First create a statement off the connection
      val statement = connection.createStatement.asInstanceOf[
        com.mysql.jdbc.Statement]

      // Setup our input stream as the source for the local infile
      statement.setLocalInfileInputStream(inputStream);

      // Execute the load infile
      statement.execute(statementText);
    }
  }

  def query(sql: String): ResultSet = {
    reconnecting { () =>
      // Configure to be Read Only
      val statement = connection.createStatement(
        ResultSet.TYPE_FORWARD_ONLY, ResultSet.CONCUR_READ_ONLY
      )

      statement.executeQuery(sql)
    }
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
  
  private val MaxReconnects = 3

  private def reconnecting[T](code: () => T, reconnect: Int=0): T = {
    try {
      code()
    }
    catch {
      case e: CommunicationsException => {
          if (reconnect == MaxReconnects) throw e
          else {
            reconnect
            reconnecting(code, reconnect + 1)
          }
      }
    }
  }
}
