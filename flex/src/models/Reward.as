package models
{
   import models.tile.TerrainType;
   import models.unit.UnitBuildingEntry;

   [Bindable]
   public class Reward
   {
      public function Reward(obj: Object)
      {
         metal = (obj.metal == null)? 0 : obj.metal;
         energy = (obj.energy == null)? 0 : obj.energy;
         zetium = (obj.zetium == null)? 0 : obj.zetium;
         points = (obj.points == null)? 0 : obj.points;
         for each (var unit: Object in obj.units)
         {
            units.push(new UnitBuildingEntry('Unit::'+unit.type, unit.count, TerrainType.GRASS, unit.level));
         }
      }
      
      public var metal: Number = 0;
      public var energy: Number = 0;
      public var zetium: Number = 0;
      public var points: Number = 0;
      public var units: Array = [];
   }
}