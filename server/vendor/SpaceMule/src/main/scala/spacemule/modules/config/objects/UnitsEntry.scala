/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package spacemule.modules.config.objects

import spacemule.helpers.Converters._
import collection.mutable.ListBuffer
import spacemule.modules.pmg.objects.Troop

object UnitsEntry {
  /**
   * Extract data from dynamicly typed data store:
   *
    [
      [count, type, flank, hp_percentage],
      ...
    ]
   */
  def extract(entries: Any): Seq[UnitsEntry] = {
    entries.asInstanceOf[Seq[IndexedSeq[Any]]].map { entryArray =>
      new UnitsEntry(
        entryArray(1).asInstanceOf[String].camelcase,
        Left(entryArray(0).asInstanceOf[Long].toInt),
        Left(entryArray(2).asInstanceOf[Long].toInt),
        entryArray(3) match {
          case l: Long => l.toDouble
          case d: Double => d
        }
      )
    }
  }
}

class UnitsEntry(
                  // Dirac, Thor, Demosis, ...
                  val kind: String,
                  val count: Either[Int, Range],
                  val flanks: Either[Int, IndexedSeq[Int]],
                  val hpPercentage: Double = 1.0
                ) {
  /**
   * Creates units entry from definition.
   */
  def this(definition: Seq[Any]) = {
    this(
      definition(0).asInstanceOf[String].camelcase,
      definition(1) match {
        case long: Long => Left(long.toInt)
        case any: Any =>
          val seq = any.asInstanceOf[Seq[Long]]
          Right(seq(0).toInt to seq(1).toInt)
      },
      definition(2) match {
        case long: Long => Left(long.toInt)
        case any: Any =>
          val seq = any.asInstanceOf[Seq[Long]].map(_.toInt).toIndexedSeq
          Right(seq)
      }
    )
  }

  def createTroops() = {
    val cnt = count match {
      case Left(number) => number
      case Right(range) => range.random
    }
    val flank = flanks match {
      case Left(number) => number
      case Right(array) => array.random
    }

    val troops = ListBuffer.empty[Troop]
    cnt.times { () => troops += Troop(kind, flank, hpPercentage)  }

    troops.toSeq
  }
}
