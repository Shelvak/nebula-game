package models.building
{
   import models.ModelsCollection;
   import models.building.events.BuildingEvent;
   import models.location.LocationType;
   import models.unit.Unit;

   import mx.collections.ArrayCollection;

   import utils.datastructures.Collections;

   public class Npc extends Building
   {
      public function Npc() : void
      {
         super();
         units = new ModelsCollection();
         units.list = ML.units;
         units = Collections.applyFilter(units,
            function(unit:Unit) : Boolean
            {
               return unit.location.type == LocationType.BUILDING && unit.location.id == id;
            }
         );
      }

      private var _unitsCached: Object = null;
      /* if this building has it's npc units downloaded yet */
      public function set unitsCached(value: Object): void
      {
         _unitsCached = value;
         dispatchUnitsCachedChangeEvent();
      }

      public function get unitsCached(): Object
      {
         return _unitsCached;
      }

      protected override function get collectionsFilterProperties() : Object
      {
         return {"units": ["id"]};
      }
      
      public var units:ModelsCollection;
      
      public override function cleanup() : void {
         super.cleanup();
         Collections.cleanListOfICleanables(units);
         units.list = null;
         units.filterFunction = null;
         units = null;
         unitsCached = null;
      }

      private function dispatchUnitsCachedChangeEvent(): void
      {
         if (hasEventListener(BuildingEvent.CACHED_UNITS_CHANGE))
         {
            dispatchEvent(new BuildingEvent(BuildingEvent.CACHED_UNITS_CHANGE));
         }
      }
   }
}