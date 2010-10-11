package models.unit
{
   import com.developmentarc.core.utils.EventBroker;
   
   import globalevents.GUnitsScreenEvent;
   
   import models.ModelsCollection;
   
   import mx.collections.ArrayCollection;
   import mx.controls.Alert;

   [Bindable]
   public class UnitsFlank
   {
      public var flank: ModelsCollection;
      public var nr: int;
      public var selection: Vector.<Object> = new Vector.<Object>;
      
      public function UnitsFlank(_flank: ArrayCollection, _nr: int)
      {
         EventBroker.subscribe(GUnitsScreenEvent.DESTROY_UNIT, dropUnits);
         flank = ModelsCollection.createFrom(_flank);
         nr = _nr;
      }
      
      private function dropUnits(e: GUnitsScreenEvent): void
      {
         for each (var unit: Unit in e.units)
         {
            flank.removeModelWithId(unit.id);
         }
      }
   }
}