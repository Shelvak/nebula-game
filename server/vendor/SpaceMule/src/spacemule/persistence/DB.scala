/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package spacemule.persistence

import java.sql.{Connection, DriverManager, ResultSet}

object DB {
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
