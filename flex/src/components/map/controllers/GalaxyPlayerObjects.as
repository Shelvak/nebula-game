package components.map.controllers
{
   import interfaces.ICleanable;

   import models.Owner;
   import models.galaxy.Galaxy;
   import models.location.LocationMinimal;
   import models.map.events.MMapEvent;
   import models.movement.MSquadron;
   import models.solarsystem.SolarSystem;

   import mx.collections.ArrayCollection;
   import mx.collections.Sort;
   import mx.core.ClassFactory;
   import mx.core.IFactory;
   import mx.utils.ObjectUtil;

   import utils.ArrayUtil;
   import utils.Objects;


   /**
    * A read-only list of solar systems that player has units or planets in and
    * galaxy locations that player has units at.
    */
   public class GalaxyPlayerObjects extends ArrayCollection implements ICleanable
   {
      public static function itemRendererFunction(item:Object): IFactory {
         if (item is SolarSystem) {
            return new ClassFactory(IRSolarSystem);
         }
         else if (item is SectorWithShips) {
            return new ClassFactory(IRSectorWithShips);
         }
         throw new ArgumentError(
            "[param item] must be either of " + SolarSystem +
            " or " + SectorWithShips + " type but was: " + item
         );
      }

      private function compareFunction(a:*, b:*, fields:Array = null) : int {
         var locA:LocationMinimal;
         var locB:LocationMinimal;
         if (a is SolarSystem && b is SectorWithShips) {
            return -1;
         }
         else if (a is SectorWithShips && b is SolarSystem) {
            return 1;
         }
         else if (a is SolarSystem) {
            locA = SolarSystem(a).currentLocation;
            locB = SolarSystem(b).currentLocation;
         }
         else {
            locA = SectorWithShips(a).location;
            locB = SectorWithShips(b).location;
         }
         var compareValue:int = ObjectUtil.numericCompare(locA.x, locB.x);
         if (compareValue == 0) {
            compareValue = ObjectUtil.numericCompare(locA.y, locB.y);
         }
         return compareValue;
      }

      private var _galaxy: Galaxy;

      public function GalaxyPlayerObjects(galaxy: Galaxy) {
         super(null);
         sort = new Sort();
         sort.compareFunction = compareFunction;
         _galaxy = Objects.paramNotNull("galaxy", galaxy);
         addObjectAddRemoveHandler(MMapEvent.OBJECT_ADD);
         addObjectAddRemoveHandler(MMapEvent.OBJECT_REMOVE);
         addSquadronEventHandler(MMapEvent.SQUADRON_ENTER);
         addSquadronEventHandler(MMapEvent.SQUADRON_LEAVE);
         addSquadronEventHandler(MMapEvent.SQUADRON_MOVE);
         rebuild();
      }

      private var f_cleanupCalled: Boolean = false;

      public function cleanup(): void {
         if (f_cleanupCalled) {
            return;
         }
         f_cleanupCalled = true;
         removeObjectAddRemoveHandler(MMapEvent.OBJECT_ADD);
         removeObjectAddRemoveHandler(MMapEvent.OBJECT_REMOVE);
         removeSquadronEventHandler(MMapEvent.SQUADRON_ENTER);
         removeSquadronEventHandler(MMapEvent.SQUADRON_LEAVE);
         removeSquadronEventHandler(MMapEvent.SQUADRON_MOVE);
         _galaxy = null;
      }

      private function addSquadronEventHandler(eventType: String): void {
         _galaxy.addEventListener(
            eventType, galaxy_squadronEnterLeaveHandler, false, 0, true
         );
      }

      private function removeSquadronEventHandler(eventType: String): void {
         _galaxy.removeEventListener(
            eventType, galaxy_squadronEnterLeaveHandler, false
         );
      }

      private function galaxy_squadronEnterLeaveHandler(event: MMapEvent): void {
         if (event.squadron.owner == Owner.PLAYER) {
            rebuild();
         }
      }

      private function addObjectAddRemoveHandler(eventType: String): void {
         _galaxy.addEventListener(
            eventType, galaxy_objectAddRemoveHandler, false, 0, true
         );
      }

      private function removeObjectAddRemoveHandler(eventType: String): void {
         _galaxy.removeEventListener(
            eventType, galaxy_objectAddRemoveHandler, false
         );
      }

      private function galaxy_objectAddRemoveHandler(event: MMapEvent): void {
         rebuild();
      }

      private function rebuild(): void {
         removeAll();
         addAllFromArray(getSolarSystems());
         addAllFromArray(getSectorsWithShips());
         refresh();
      }

      private function getSolarSystems(): Array {
         if (_galaxy.solarSystems == null) {
            return new Array();
         }
         return _galaxy.solarSystemsWithPlayer.toArray();
      }

      private function getSectorsWithShips(): Array {
         if (_galaxy.squadrons == null) {
            return new Array();
         }
         var loc: LocationMinimal;
         var sectorsWithShips: Object = new Object();
         for each (var squad: MSquadron in _galaxy.squadrons) {
            if (squad.owner == Owner.PLAYER) {
               loc = squad.currentHop.location;
               if (sectorsWithShips[loc.hashKey()] === undefined) {
                  sectorsWithShips[loc.hashKey()] = new SectorWithShips(
                     loc, _galaxy.getSSAt(loc.x, loc.y)
                  );
               }
            }
         }
         return ArrayUtil.fromObject(sectorsWithShips);
      }

      private function addAllFromArray(items: Array): void {
         for each (var item: Object in items) {
            addItem(item);
         }
      }
   }
}