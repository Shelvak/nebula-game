package spacemule.modules.pmg.persistence.objects

case class SaveResult(val updatedPlayerIds: Set[Int],
                      val updatedAllianceIds: Set[Int])