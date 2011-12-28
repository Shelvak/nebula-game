package components.map.controllers
{
   import interfaces.IEqualsComparable;

   import models.Owner;
   import models.location.LocationMinimal;
   import models.map.IMStaticSpaceObject;

   import utils.Objects;


   /**
    * Aggregates location that player has ships in and a static object at that
    * location if one exists.
    */
   public final class Sector implements IEqualsComparable
   {
      public function Sector(location: LocationMinimal,
                             ships: SectorShips = null,
                             object: IMStaticSpaceObject = null,
                             objectOwner: int = Owner.UNDEFINED) {
         _location = Objects.paramNotNull("location", location);
         _ships = ships != null
                     ? ships
                     : new SectorShips(false, false, false ,false, false);
         _object = object;
         if (object == null && objectOwner != Owner.UNDEFINED) {
            throw new ArgumentError(
               "[param objectOwner] must be equal to Owner.UNDEFINED ("
                  + Owner.UNDEFINED + ") when [param object] is null but "
                  + "[param objectOwner] was equal to " + objectOwner
            );
         }
         _objectOwner = Objects.paramEquals(
            "objectOwner", objectOwner, [
               Owner.ALLY,
               Owner.ENEMY,
               Owner.NAP,
               Owner.NPC,
               Owner.PLAYER,
               Owner.UNDEFINED
            ]
         );
      }

      private var _location: LocationMinimal;
      public function get location(): LocationMinimal {
         return _location;
      }

      public function get sectorLabel(): String {
         return LocationMinimal.getSectorLabel(_location);
      }

      private var _ships:SectorShips;
      public function get ships(): SectorShips {
         return _ships;
      }
      public function get hasShips(): Boolean {
         return _ships.shipsPresent;
      }

      private var _object: IMStaticSpaceObject;
      public function get object(): IMStaticSpaceObject {
         return _object;
      }
      public function get hasObject(): Boolean {
         return _object != null;
      }

      private var _objectOwner:int;
      public function get objectOwner(): int {
         return _objectOwner;
      }

      public function toString(): String {
         return "[class: " + Objects.getClassName(this)
                   + ", location: " + _location
                   + ", ships " + _ships
                   + ", object: " + _object + "]";
      }

      public function equals(o: Object): Boolean {
         if (!(o is Sector)) {
            return false;
         }
         var sector: Sector = Sector(o);
         if (!this._location.equals(sector._location)) {
            return false;
         }
         if (this._object == null) {
            return sector._object == null && this._ships.equals(sector._ships);
         }
         return this._object.equals(sector._object)
                   && this._ships.equals(sector._ships);
      }
   }
}
