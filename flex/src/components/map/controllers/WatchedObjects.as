package components.map.controllers
{
   import interfaces.ICleanable;

   import models.map.IMStaticSpaceObject;
   import models.map.MMapSpace;
   import models.map.events.MMapEvent;

   import mx.collections.ArrayCollection;
   import mx.collections.Sort;

   import utils.Objects;


   public class WatchedObjects extends ArrayCollection implements ICleanable
   {
      public function sectorsCompareFunction(a: Sector,
                                             b: Sector,
                                             fields:Array = null): int {
         Objects.paramNotNull("a", a);
         Objects.paramNotNull("b", b);
         if (a.hasObject && !b.hasObject) return -1;
         if (!a.hasObject && b.hasObject) return +1;
         if (a.location.x < b.location.x) return -1;
         if (a.location.x > b.location.x) return +1;
         if (a.location.y < b.location.y) return -1;
         if (a.location.y > b.location.y) return +1;
         throw new ArgumentError(
            "Both sectors a=" + a + " and b=" + b + " define the same "
               + "location and both contain either objects or ships "
               + "which is illegal"
         );
         // unreachable
         return 0;
      }

      public function itemSelected(sector: Sector): void {
         _map.deselectSelectedObject();
         if (sector.hasObject) {
            _map.selectObject(sector.object);
         }
         else {
            _map.moveTo(sector.location);
         }
      }

      private var _map: MMapSpace;
      private var _sectorsProvider: ISectorsProvider;
      
      /**
       * @param map | <b>not null</b>
       * @param sectorsProvider | <b>not null</b>
       */
      public function WatchedObjects(map:MMapSpace,
                                     sectorsProvider:ISectorsProvider) {
         this._map =
            Objects.paramNotNull("map", map);
         this._sectorsProvider =
            Objects.paramNotNull("sectorsProvider", sectorsProvider);
         addObjectEventHandler(MMapEvent.OBJECT_ADD);
         addObjectEventHandler(MMapEvent.OBJECT_REMOVE);
         addSquadronEventHandler(MMapEvent.SQUADRON_ENTER);
         addSquadronEventHandler(MMapEvent.SQUADRON_LEAVE);
         addSquadronEventHandler(MMapEvent.SQUADRON_MOVE);
         sort = new Sort();
         sort.compareFunction = sectorsCompareFunction;
         refresh();
         rebuild();
      }

      private var f_cleanupCalled: Boolean = false;
      public function cleanup(): void {
         if (f_cleanupCalled) {
            return;
         }
         f_cleanupCalled = true;
         removeObjectEventHandler(MMapEvent.OBJECT_ADD);
         removeObjectEventHandler(MMapEvent.OBJECT_REMOVE);
         removeSquadronEventHandler(MMapEvent.SQUADRON_ENTER);
         removeSquadronEventHandler(MMapEvent.SQUADRON_LEAVE);
         removeSquadronEventHandler(MMapEvent.SQUADRON_MOVE);
         this._map = null;
         this._sectorsProvider = null;
      }

      public function get itemRendererFunction(): Function {
         return _sectorsProvider.itemRendererFunction;
      }

      private function addSquadronEventHandler(eventType: String): void {
         _map.addEventListener(
            eventType, map_squadronEventHandler, false, 0, true
         );
      }

      private function removeSquadronEventHandler(eventType: String): void {
         _map.removeEventListener(
            eventType, map_squadronEventHandler, false
         );
      }

      private function map_squadronEventHandler(event: MMapEvent): void {
         if (_sectorsProvider.includeSectorsWithShipsOf(event.squadron.owner)) {
            rebuild();
         }
      }

      private function addObjectEventHandler(eventType: String): void {
         _map.addEventListener(
            eventType, map_objectEventHandler, false, 0, true
         );
      }

      private function removeObjectEventHandler(eventType: String): void {
         _map.removeEventListener(
            eventType, map_objectEventHandler, false
         );
      }

      private function map_objectEventHandler(event: MMapEvent): void {
         if (IMStaticSpaceObject(event.object).objectType
                == MMapSpace.STATIC_OBJECT_NATURAL) {
            rebuild();
         }
      }

      private function rebuild(): void {
         source = _sectorsProvider.getSpaceSectors();
      }
   }
}
