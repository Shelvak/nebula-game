package models.building
{
   import models.ModelsCollection;
   import models.location.LocationType;
   import models.unit.Unit;
   
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
      }
   }
}