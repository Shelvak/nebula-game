package models.map
{
   import interfaces.IUpdatable;

   import models.location.Location;

   import models.location.LocationMinimal;

   import models.location.LocationMinimalSolarSystem;
   import models.location.LocationType;

   import models.solarsystem.MSSObject;
   import models.solarsystem.MSolarSystem;

   import mx.collections.ListCollectionView;

   import utils.Objects;
   import utils.datastructures.Collections;


   public class MMapSolarSystem extends MMapSpace implements IUpdatable
   {
      public function MMapSolarSystem(solarSystem:MSolarSystem) {
         _solarSystem = Objects.paramNotNull("solarSystem", solarSystem);
         super();
         _importantObjects = Collections.filter(
            naturalObjects,
            ff_importantObjects
         );
      }

      private var _solarSystem:MSolarSystem;
      public function get solarSystem(): MSolarSystem {
         return _solarSystem;
      }

      private var _importantObjects:ListCollectionView;
      private function ff_importantObjects(object:MSSObject) : Boolean {
         return object.isPlanet || object.isJumpgate;
      }
      [Bindable(event="willNotChange")]
      /**
       * Important to player objects (planets and jumpgates).
       */
      public function get importantObjects() : ListCollectionView {
         return _importantObjects;
      }

      /**
       * Returns total number of orbits (this might be greater than number of planets).
       */
      public function get orbitsTotal(): int {
         var orbits: int = 0;
         for each (var ssObject: MSSObject in naturalObjects) {
            orbits = Math.max(orbits, ssObject.position);
         }
         return orbits + 1;
      }

      public function getSSObjectById(id: int): MSSObject {
         return Collections.findFirst(
            naturalObjects,
            function(ssObject: MSSObject): Boolean {
               return ssObject.id == id;
            }
         );
      }

      public function getSSObjectAt(position: int, angle: int): MSSObject {
         return MSSObject(getNaturalObjectAt(position, angle));
      }

      /* ##################### */
      /* ### MMapOverrides ### */
      /* ##################### */

      [Bindable(event="willNotChange")]
      /**
       * Proxy to <code>solarSystem.currentLocation</code>
       */
      public override function get currentLocation(): LocationMinimal {
         return _solarSystem.currentLocation;
      }

      [Bindable(event="willNotChange")]
      /**
       * Returns <code>MapType.GALAXY</code>.
       *
       * @see models.map.MMap#mapType
       */
      override public function get mapType(): int {
         return MapType.SOLAR_SYSTEM;
      }

      protected override function get definedLocationType(): int {
         return LocationType.SOLAR_SYSTEM;
      }

      protected override function setCustomLocationFields(location: Location): void {
         location.variation = _solarSystem.variation;
      }

      protected override function definesLocationImpl(location: LocationMinimal): Boolean {
         var locWrapper: LocationMinimalSolarSystem =
                new LocationMinimalSolarSystem(location);
         return locWrapper.type == LocationType.SOLAR_SYSTEM
                   && locWrapper.id == id
                   && locWrapper.position >= 0
                   && locWrapper.position < orbitsTotal;
      }

      /**
       * Proxy to <code>solarSystem.cached</code>
       */
      override public function get cached(): Boolean {
         return _solarSystem.cached;
      }

      /* ################## */
      /* ### IUpdatable ### */
      /* ################## */

      public function update(): void {
         _solarSystem.update();
      }

      public function resetChangeFlags(): void {
         _solarSystem.resetChangeFlags();
      }

      /* ########################### */
      /* ### BaseModel OVERRIDES ### */
      /* ########################### */


      override public function equals(o: Object): Boolean {
         if (!(o is MMapSolarSystem)) {
            return false;
         }
         var ssMap:MMapSolarSystem = MMapSolarSystem(o);
         return this._solarSystem.equals(ssMap._solarSystem);
      }

      override public function hashKey(): String {
         return _solarSystem.hashKey();
      }

      [Optional]
      [Bindable(event="modelIdChange")]
      /**
       * Proxy to <code>solarSystem.id</code>
       */
      override public function set id(value: int): void {
         _solarSystem.id = value;
      }
      override public function get id(): int {
         return _solarSystem.id;
      }

      /**
       * Proxy to <code>solarSystem.fake</code>
       */
      override public function set fake(value: Boolean): void {
         _solarSystem.fake = value;
      }
      override public function get fake(): Boolean {
         return _solarSystem.fake;
      }

      [SkipProperty]
      [Bindable(event="pendingChange")]
      /**
       * Proxy to <code>solarSystem.pending</code>
       */
      override public function set pending(value: Boolean): void {
         if (_solarSystem.pending != value) {
            _solarSystem.pending = value;
            dispatchPendingChangeEvent();
         }
      }
      override public function get pending(): Boolean {
         return _solarSystem.pending;
      }

      public override function toString(): String {
         return "[class: " + className + ", solarSystem: " + _solarSystem + "]";
      }
   }
}
