package spacemule.persistence.exceptions

import java.sql.SQLException

/**
 * Created with IntelliJ IDEA.
 * User: arturas
 * Date: 5/5/12
 * Time: 12:14 PM
 * To change this template use File | Settings | File Templates.
 */

@EnhanceStrings
class LoadInFileException(
  filePath: String, tableName: String, columns: String, cause: Throwable
) extends SQLException(
  """Error while LOAD DATA INFILE from #filePath to #tableName
for columns #columns

Original exception:
#cause.toString
""", cause
)
