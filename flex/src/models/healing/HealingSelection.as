package models.healing
{
   
   import models.building.Building;
   import models.unit.MCUnit;
   
   import mx.collections.ArrayCollection;
   
   public class HealingSelection
   {      
      public var flanks: ArrayCollection;
      
      public var allFlanks: Array;
      
      public var center: Building;
      
      public function selectUnit(unit: MCUnit, flank: MHealFlank): Boolean
      {
         if (!selectedPrice)
         {
            selectedPrice = new HealPrice();
         }
         if (selectedPrice.addIfPossible(HealPrice.calculateHealingPrice([unit], center.level, center.type)))
         {
            flank.selection.addItem(unit);
            unit.selected = true;
            return true;
         }
         return false;
      }
      
      public function clear(): void
      {
         flanks = null;
         allFlanks = null;
      }
      
      public var selectedPrice: HealPrice;
      
      public function selectFlank(flank: MHealFlank): Boolean
      {
         var selectedAll: Boolean = true;
         for each (var unit: MCUnit in flank.flankUnits)
         {
            if (flank.selection.getItemIndex(unit) == -1)
            {
               if (!selectUnit(unit, flank))
               {
                  selectedAll = false;
               }
            }
         }
         
         return selectedAll;
      }
      
      public function selectAll(onlyHealable: Boolean): Boolean
      {
         var selectedAll: Boolean = true;
         for each (var flank: MHealFlank in flanks)
         {
            if (onlyHealable)
            {
               if (!selectFlank(flank))
               {
                  selectedAll = false;
               }
            }
            else
            {
               flank.selectAll();
            }
         }
         return selectedAll;
      }
   }
}