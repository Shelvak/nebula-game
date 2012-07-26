package factories
{
   import models.location.LocationMinimal;
   import models.location.LocationType;

   public final class LocationMinimalBuilder
   {
      private var _loc: LocationMinimal = new LocationMinimal();
      public function get GET(): LocationMinimal {
         return _loc;
      }
      
      public function id(id: int): LocationMinimalBuilder {
         _loc.id = id;
         return this;
      }
      
      public function type(type: uint): LocationMinimalBuilder {
         _loc.type = type;
         return this;
      }
      
      public function inGalaxy(): LocationMinimalBuilder {
         return type(LocationType.GALAXY);
      }
      
      public function inSolarSystem(): LocationMinimalBuilder {
         return type(LocationType.SOLAR_SYSTEM);
      }
      
      public function inSSObject(): LocationMinimalBuilder {
         setDefaultCoords();
         return type(LocationType.SS_OBJECT);
      }
      
      public function inBuilding(): LocationMinimalBuilder {
         setDefaultCoords();
         return type(LocationType.BUILDING);
      }
      
      public function inUnit(): LocationMinimalBuilder {
         setDefaultCoords();
         return type(LocationType.UNIT);
      }
      
      public function x(x: int): LocationMinimalBuilder {
         _loc.x = x;
         return this;
      }
      
      public function y(y: int): LocationMinimalBuilder {
         _loc.y = y;
         return this;
      }
      
      
      private function setDefaultCoords(): void {
         _loc.setDefaultCoordinates();
      }
   }
}