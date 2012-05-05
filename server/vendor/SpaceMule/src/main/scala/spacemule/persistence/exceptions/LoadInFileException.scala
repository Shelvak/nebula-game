package spacemule.persistence.exceptions

import java.sql.SQLException

/**
 * Created with IntelliJ IDEA.
 * User: arturas
 * Date: 5/5/12
 * Time: 12:14 PM
 * To change this template use File | Settings | File Templates.
 */

class LoadInFileException(
  filePath: String, tableName: String, columns: String, data: String,
  cause: Throwable
) extends SQLException(
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
