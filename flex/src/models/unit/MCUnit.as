package models.unit
{
   public class MCUnit
   {
      public function MCUnit(_unit: Unit, flank: UnitsFlank = null, _loadUnload: Boolean = false)
      {
         unit = _unit;
         flankModel = flank;
         stance = unit.stance;
         hidden = unit.hidden;
         loadUnload = _loadUnload;
      }
      
      [Bindable]
      public var loadUnload: Boolean = false;
      
      [Bindable]
      public var unit: Unit;
      
      [Bindable]
      public var stance: int;

      [Bindable]
      public var hidden: Boolean;
      
      [Bindable]
      public var flankModel: UnitsFlank;
      
      [Bindable]
      public var selected: Boolean = false;
   }
}