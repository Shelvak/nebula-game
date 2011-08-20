package models
{
   import models.tile.TerrainType;
   import models.unit.UnitBuildingEntry;

   [Bindable]
   public class Reward
   {
      public function Reward(obj: Object)
      {
         metal = Math.floor((obj.metal == null)? 0 : obj.metal);
         energy = Math.floor((obj.energy == null)? 0 : obj.energy);
         zetium = Math.floor((obj.zetium == null)? 0 : obj.zetium);
         points = (obj.points == null)? 0 : obj.points;
         scientists = (obj.scientists == null)?0:obj.scientists;
         creds = (obj.creds == null)?0:obj.creds;
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
      public var creds: int = 0;
      public var units: Array = [];
   }
}