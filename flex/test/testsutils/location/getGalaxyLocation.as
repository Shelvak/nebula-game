package testsutils.location
{
   import models.location.LocationMinimal;
   import models.location.LocationType;


   public function getGalaxyLocation(id: int,
                                     x: int = 0,
                                     y: int = 0): LocationMinimal {
      return getLocation(LocationType.GALAXY, id, x, y);
   }
}