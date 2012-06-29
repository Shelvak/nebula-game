package models.solarsystem
{
   import utils.Objects;


   public class MSSMetadataOfOwner
   {
      private var _owner: int;
      private var _planets: Array;
      private var _ships: Array;

      public function MSSMetadataOfOwner(owner: int, planets: Array, ships: Array) {
         _owner = owner;
         _planets = Objects.paramNotNull("planets", planets);
         _ships = Objects.paramNotNull("ships", ships);
      }

      public function get owner(): int {
         return _owner;
      }

      public function get planets(): Array {
         return _planets;
      }

      public function get hasPlanets(): Boolean {
         return _planets.length > 0;
      }

      public function get ships(): Array {
         return _ships;
      }

      public function get hasShips(): Boolean {
         return _ships.length > 0;
      }
   }
}
