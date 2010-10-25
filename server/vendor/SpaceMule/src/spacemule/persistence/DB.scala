/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package spacemule.persistence

import java.sql.{Connection, DriverManager, ResultSet}
import org.apache.commons.io.IOUtils

object DB {
  /**
   * Use this instead of NULL if you're using loadInFile()
   */
  val loadInFileNull = "\\N"

  private var connection: Connection = null
  
  def connect(host: String, port: Int, user: String, password: String, 
              dbName: String) = {
    val connStr = (
      "jdbc:mysql://%s:%d/%s?user=%s&password=%s&characterEncoding=UTF8"
    ).format(
      host, port, dbName, user, password
    )

    // Load the driver
    Class.forName("com.mysql.jdbc.Driver").newInstance
    
    // Setup the connection
    connection = DriverManager.getConnection(connStr)
  }
  
  def connect(host: String, user: String, password: String, 
              dbName: String): Unit = {
    connect(host, 3306, user, password, dbName)
  }

  def close() = if (connection != null) connection.close

  def exec(sql: String): Int = {
    val statement = connection.createStatement
    return statement.executeUpdate(sql)
  }

  /**
   * Loads data from values into table ultra quickly fast.
   *
   * See http://dev.mysql.com/doc/refman/5.1/en/load-data.html for
   * information how to avoid being sql injected by using this.
   */
  def loadInFile(tableName: String, columns: String, values: Seq[String]) = {
    // First create a statement off the connection
    val statement = connection.createStatement.asInstanceOf[
      com.mysql.jdbc.Statement]

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

    // Create stream from String Builder
    val inputStream = IOUtils.toInputStream(builder);

    // Setup our input stream as the source for the local infile
    statement.setLocalInfileInputStream(inputStream);

    // Execute the load infile
    statement.execute(statementText);
  }

  def query(sql: String): ResultSet = {
    // Configure to be Read Only
    val statement = connection.createStatement(
      ResultSet.TYPE_FORWARD_ONLY, ResultSet.CONCUR_READ_ONLY
    )

    return statement.executeQuery(sql)
  }

  def getOne[T](sql: String): Option[T] = {
    val resultSet = query(sql)
    return if (resultSet.first)
      Option[T](resultSet.getObject(1).asInstanceOf[T])
    else
      None
  }
}
