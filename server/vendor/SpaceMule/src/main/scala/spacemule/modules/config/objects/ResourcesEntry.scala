package spacemule.modules.config.objects

object ResourcesEntry {
  def extract(array: Any) = {
    val resources = array.asInstanceOf[IndexedSeq[Double]]
    ResourcesEntry(resources(0), resources(1), resources(2))
  }
}

case class ResourcesEntry(metal: Double, energy: Double, zetium: Double)