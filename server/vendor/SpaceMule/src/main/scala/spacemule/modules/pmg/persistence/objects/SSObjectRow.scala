package spacemule.modules.pmg.persistence.objects

import spacemule.modules.pmg.persistence.Manager
import spacemule.modules.pmg.persistence.TableIds
import spacemule.modules.pmg.classes.geom.Coords
import spacemule.modules.pmg.objects.ss_objects._
import spacemule.helpers.Converters._
import spacemule.modules.pmg.objects.SSObject
import spacemule.modules.config.objects.Config
import spacemule.persistence.{DB, RowObject, Row}

object SSObjectRow extends RowObject {
  val columnsSeq = List(
    "id", "type", "solar_system_id", "angle", "position", "width", "height",
    "terrain", "player_id", "name", "size",
    "metal", "metal_generation_rate", "metal_usage_rate", "metal_storage",
    "energy", "energy_generation_rate", "energy_usage_rate", "energy_storage",
    "zetium", "zetium_generation_rate", "zetium_usage_rate", "zetium_storage",
    "last_resources_update", "owner_changed"
  )
}

case class SSObjectRow(solarSystemRow: SolarSystemRow, coord: Coords,
                  ssObject: SSObject) extends Row {
  val id = TableIds.ssObject.next
  val width = ssObject match {
    case planet: Planet => planet.area.width
    case _ => 0
  }
  val height = ssObject match {
    case planet: Planet => planet.area.height
    case _ => 0
  }
  val size = ssObject match {
    case planet: Planet => {
      val areaPercentage = planet.area.edgeSum * 100 / Config.planetAreaMax
      val range = Config.ssObjectSize
      range.start + (range.end - range.start) * areaPercentage / 100
    }
    case _ => Config.ssObjectSize.random
  }
  val terrain = ssObject match {
    case planet: Planet => planet.terrainType
    case _ => 0
  }
  val playerId = ssObject match {
    case h: Homeworld => solarSystemRow.playerRow.get.id.toString
    case _ => DB.loadInFileNull
  }
  val name = ssObject match {
    case bgPlanet: MiniBgPlanet => "%s-%d".format(
        BgPlanet.Names.wrapped(bgPlanet.index),
        id
    )
    case bgPlanet: BgPlanet => BgPlanet.Names.wrapped(bgPlanet.index)
    case planet: Planet => "P-%d".format(id)
    case _ => DB.loadInFileNull
  }

  val valuesSeq = List(
    id, ssObject.name, solarSystemRow.id, coord.angle, coord.position,
    width, height, terrain, playerId, name, size
  ) ++ (ssObject match {
    case asteroid: Asteroid =>
      List(
        0, asteroid.metalRate, 0,
        0, asteroid.energyRate, 0,
        0, asteroid.zetiumRate, 0,
        DB.loadInFileNull, DB.loadInFileNull
      )
    case homeworld: Homeworld =>
      List(
        Config.homeworldStartingMetal,
        homeworld.metalGenerationRate,
        homeworld.metalUsageRate,
        homeworld.metalStorage,
        Config.homeworldStartingEnergy,
        homeworld.energyGenerationRate,
        homeworld.energyUsageRate,
        homeworld.energyStorage,
        Config.homeworldStartingZetium,
        homeworld.zetiumGenerationRate,
        homeworld.zetiumUsageRate,
        homeworld.zetiumStorage,
        Manager.currentDateTime,
        Manager.currentDateTime
      )
    case planet: Planet =>
      List(
        0,
        planet.metalGenerationRate,
        planet.metalUsageRate,
        planet.metalStorage,
        0,
        planet.energyGenerationRate,
        planet.energyUsageRate,
        planet.energyStorage,
        0,
        planet.zetiumGenerationRate,
        planet.zetiumUsageRate,
        planet.zetiumStorage,
        Manager.currentDateTime,
        DB.loadInFileNull
      )
    case _ =>
      List(
        0, 0, 0,
        0, 0, 0,
        0, 0, 0,
        DB.loadInFileNull, DB.loadInFileNull
      )
  })
}