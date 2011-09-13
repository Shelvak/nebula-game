/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package spacemule.modules.config.objects

import spacemule.helpers.Converters._

object UnitsEntry {
  def foreach(entries: Iterable[UnitsEntry])(block: (String, Int) => Unit) {
    entries.foreach { entry =>
      val count = entry.count match {
        case Left(number) => number
        case Right(range) => range.random
      }

      count.times { () => block(entry.kind, entry.flanks.random) }
    }
  }
}

class UnitsEntry(val kind: String, val count: Either[Int, Range],
                 val flanks: IndexedSeq[Int]) {
  /**
   * Creates units entry from definition.
   */
  def this(definition: Seq[Any]) = {
    this(
      definition(0).asInstanceOf[String].camelcase,
      definition(1) match {
        case long: Long => Left(long.toInt)
        case any: Any => {
            val seq = any.asInstanceOf[Seq[Long]]
            Right(seq(0).toInt to seq(1).toInt)
        }
      },
      definition(2) match {
        case long: Long => IndexedSeq(long.toInt)
        case any: Any => {
            val seq = any.asInstanceOf[Seq[Long]]
            seq.map { _.toInt }.toIndexedSeq
        }
      }
    )
  }
}
