package models
{
   import config.Config;
   
   import models.tile.TerrainType;
   import models.unit.UnitBuildingEntry;
   
   import utils.MathUtil;

   [Bindable]
   public class Reward
   {
      public function Reward(obj: Object)
      {
         metal = MathUtil.round((obj.metal == null)? 0 : obj.metal, Config.getRoundingPrecision());
         energy = MathUtil.round((obj.energy == null)? 0 : obj.energy, Config.getRoundingPrecision());
         zetium = MathUtil.round((obj.zetium == null)? 0 : obj.zetium, Config.getRoundingPrecision());
         points = (obj.points == null)? 0 : obj.points;
         scientists = (obj.scientists == null)?0:obj.scientists;
         for each (var unit: Object in obj.units)
         {
            units.push(new UnitBuildingEntry('Unit::'+unit.type, unit.count, TerrainType.GRASS, unit.level));
         }
      }
      
      public var metal: Number = 0;
      public var energy: Number = 0;
      public var zetium: Number = 0;
      public var points: int = 0;
      public var scientists: int = 0;
      public var units: Array = [];
   }
}