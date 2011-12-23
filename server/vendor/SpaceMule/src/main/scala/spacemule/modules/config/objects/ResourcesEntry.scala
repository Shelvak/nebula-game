package spacemule.modules.config.objects

object ResourcesEntry {
  def extract(array: Any) = {
    try {
      val resources = array.asInstanceOf[IndexedSeq[Double]]
      ResourcesEntry(resources(0), resources(1), resources(2))
    }
    catch {
      case e: Exception => 
        System.err.println(
          "Error while converting %s to ResourcesEntry".format(array)
        )
        throw e
    }
  }
}

case class ResourcesEntry(metal: Double, energy: Double, zetium: Double)