package models.unit
{
   [Bindable]
   public class FlankUnit
   {
      public var unit: Unit;
      public var transfer: Boolean;
      public function FlankUnit(_unit: Unit, _transfer: Boolean = false)
      {
            unit = _unit;
            transfer = _transfer;
      }
   }
}