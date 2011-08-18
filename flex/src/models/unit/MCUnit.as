package models.unit
{
   public class MCUnit
   {
      public function MCUnit(_unit: Unit, flank: UnitsFlank = null)
      {
         unit = _unit;
         flankModel = flank;
         stance = unit.stance;
      }
      
      [Bindable]
      public var unit: Unit;
      
      [Bindable]
      public var stance: int;
      
      [Bindable]
      public var flankModel: UnitsFlank;
      
      [Bindable]
      public var selected: Boolean = false;
   }
}