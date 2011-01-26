package models.unit
{
   import com.developmentarc.core.utils.EventBroker;
   
   import globalevents.GUnitsScreenEvent;
   
   import models.ModelsCollection;
   import models.Owner;
   
   [Bindable]
   public class UnitsFlank
   {
      public var flank: ModelsCollection;
      public var nr: int;
      public var owner: int;
      public var selection: Vector.<Object> = new Vector.<Object>;
      
      public function UnitsFlank(_flank: ModelsCollection, _nr: int, _owner: int = Owner.PLAYER)
      {     
         EventBroker.subscribe(GUnitsScreenEvent.DESTROY_UNIT, dropUnits);
         flank = _flank;
         nr = _nr;
         owner = _owner
      }
      
      
      
      private function dropUnits(e: GUnitsScreenEvent): void
      {
         for each (var unit: Unit in e.units)
         {
            flank.remove(unit.id, true);
         }
      }
   }
}