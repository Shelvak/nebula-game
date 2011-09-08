/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package spacemule.helpers

import scala.collection.mutable.LinkedHashMap

case class BenchmarkData(var count: Int, var time: Long)

trait BenchmarkableMock {
  protected def benchmark[T](title: String)(block: () => T): T = block()
  protected def printBenchmarkResults() = {}
}

trait Benchmarkable {
  private val benchmarkData = LinkedHashMap[String, BenchmarkData]()

  protected def benchmark[T](title: String)(block: () => T): T = {
    val start = System.currentTimeMillis
    val result = block()
    val time = System.currentTimeMillis - start

    if (benchmarkData.contains(title)) {
      val data = benchmarkData(title)
      data.count += 1
      data.time += time
    }
    else {
      benchmarkData(title) = BenchmarkData(1, time)
    }

    return result
  }

  protected def printBenchmarkResults() = {
    benchmarkData.foreach { case(title, data) =>
        System.err.println("%s: total: %dms, count: %d, per run: %dms".format(
            title, data.time, data.count, data.time / data.count
          ))
    }
  }
}