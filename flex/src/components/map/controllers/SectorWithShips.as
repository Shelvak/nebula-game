package components.map.controllers
{
   import interfaces.IEqualsComparable;

   import models.location.LocationMinimal;
   import models.solarsystem.MSolarSystem;

   import utils.Objects;


   /**
    * Aggregates location that player has ships in and a solar system
    * at that location if one exists.
    */
   public final class SectorWithShips implements IEqualsComparable
   {
      public function SectorWithShips(location: LocationMinimal,
                                      solarSystem: MSolarSystem = null) {
         _location = Objects.paramNotNull("location", location);
         _solarSystem = solarSystem;
      }

      private var _location: LocationMinimal;
      public function get location(): LocationMinimal {
         return _location;
      }

      public function get sectorLabel(): String {
         return LocationMinimal.getSectorLabel(_location);
      }

      private var _solarSystem: MSolarSystem;
      public function get solarSystem(): MSolarSystem {
         return _solarSystem;
      }

      public function get hasObject(): Boolean {
         return _solarSystem != null;
      }

      public function toString(): String {
         return "[class: " + Objects.getClassName(this)
                   + ", location: " + _location
                   + ", solarSystem: " + _solarSystem + "]";
      }

      public function equals(o: Object): Boolean {
         if (!(o is SectorWithShips)) {
            return false;
         }
         var sector: SectorWithShips = SectorWithShips(o);
         if (!this._location.equals(sector._location)) {
            return false;
         }
         if (this._solarSystem == null && sector._solarSystem == null) {
            return true;
         }
         if (this._solarSystem == null && sector._solarSystem != null) {
            return false;
         }
         return this._solarSystem.equals(sector._solarSystem);
      }
   }
}
