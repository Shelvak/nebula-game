package spacemule.persistence

/**
 * Created by IntelliJ IDEA.
 * User: arturas
 * Date: 9/20/11
 * Time: 12:41 PM
 * To change this template use File | Settings | File Templates.
 */

trait Row {
  val companion: RowObject

  protected[this] def valuesImpl(): Seq[Any]

  final def valuesSeq: Seq[Any] = {
    val valuesSeq = valuesImpl()

    if (companion.columnsSeq.size != valuesSeq.size)
      throw new IllegalArgumentException(
        ("columns sequence size (%d) must be equal to values " +
            "sequence size (%d) for %s!").format(
          companion.columnsSeq.size, valuesSeq.size, toString
        )
      )

    valuesSeq
  }
}