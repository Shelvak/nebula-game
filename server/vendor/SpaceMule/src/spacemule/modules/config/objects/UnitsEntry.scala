/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package spacemule.modules.config.objects

import spacemule.helpers.Converters._

object UnitsEntry {
  def foreach(entries: Iterable[UnitsEntry])(block: (String, Int) => Unit) = {
    entries.foreach { entry =>
      val count = entry.count match {
        case Left(count) => count
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
        case int: Int => Left(int)
        case any: Any => {
            val seq = any.asInstanceOf[Seq[Int]]
            Right(seq(0) to seq(1))
        }
      },
      definition(2) match {
        case int: Int => IndexedSeq(int)
        case any: Any => {
            val seq = any.asInstanceOf[Seq[Int]]
            seq.toIndexedSeq
        }
      }
    )
  }
}
