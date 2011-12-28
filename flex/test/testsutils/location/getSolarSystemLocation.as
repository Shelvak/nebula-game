package testsutils.location
{
   import models.location.LocationMinimal;
   import models.location.LocationType;


   public function getSolarSystemLocation(id: int,
                                          x: int = 0,
                                          y: int = 0): LocationMinimal {
      return getLocation(LocationType.SOLAR_SYSTEM, id, x, y);
   }
}