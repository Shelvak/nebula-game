package models.unit
{
   import com.developmentarc.core.utils.EventBroker;
   
   import globalevents.GUnitsScreenEvent;
   
   import models.ModelsCollection;
   
   import mx.controls.Alert;

   [Bindable]
   public class UnitsFlank
   {
      public var flank: ModelsCollection = new ModelsCollection();
      public var nr: int;
      public var selection: Vector.<Object> = new Vector.<Object>;
      
      public function UnitsFlank(_flank: ModelsCollection, _nr: int)
      {
         EventBroker.subscribe(GUnitsScreenEvent.DESTROY_UNIT, dropUnits);
         flank = _flank;
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