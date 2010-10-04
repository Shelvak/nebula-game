package models.quest
{
   import models.unit.UnitEntry;

   [Bindable]
   public class QuestReward
   {
      public function QuestReward(obj: Object)
      {
         metal = (obj.metal == null)? 0 : obj.metal;
         energy = (obj.energy == null)? 0 : obj.energy;
         zetium = (obj.zetium == null)? 0 : obj.zetium;
         points = (obj.points == null)? 0 : obj.points;
         for each (var unit: Object in obj.units)
         {
            units.push(new UnitEntry(unit.type, unit.count));
         }
      }
      
      public var metal: Number = 0;
      public var energy: Number = 0;
      public var zetium: Number = 0;
      public var points: Number = 0;
      public var units: Array = [];
   }
}