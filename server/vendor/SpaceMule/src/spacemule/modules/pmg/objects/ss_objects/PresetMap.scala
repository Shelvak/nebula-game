package spacemule.modules.pmg.objects.ss_objects

trait PresetMap extends TerrainFeatures {
  /**
   * Map data.
   */
  protected def data: MapData
  
  override val area = data.area
  override lazy protected val tilesMap = data.tilesMap
  override protected val buildings = data.buildings
  override protected val buildingTiles = data.buildingTiles

  override protected def initializeTerrain() = putFolliage()
  protected def putFolliage()
}
