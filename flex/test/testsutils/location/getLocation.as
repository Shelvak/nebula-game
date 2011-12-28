package testsutils.location
{
   import models.location.LocationMinimal;


   public function getLocation(type: int,
                               id: int,
                               x: int = 0,
                               y: int = 0): LocationMinimal {
      var loc: LocationMinimal = new LocationMinimal();
      loc.type = type;
      loc.id = id;
      loc.x = x;
      loc.y = y;
      return loc;
   }
}