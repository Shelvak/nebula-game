package spacemule.modules.config.objects

import core.AnyConversions._
import scala.{collection => sc}

object ResourcesEntry {
  type Data = sc.Seq[Any]

  def extract(resources: Data) = {
    try {
      ResourcesEntry(
        resources(0).asDouble, resources(1).asDouble, resources(2).asDouble
      )
    }
    catch {
      case e: Exception => 
        System.err.println(
          "Error while converting %s to ResourcesEntry".format(resources)
        )
        throw e
    }
  }
}

case class ResourcesEntry(metal: Double, energy: Double, zetium: Double) {
  override def toString = "<ResourcesEntry m:"+metal+" e:"+energy+" z:"+zetium+
    ">"
}