package models.unit
{
   import mx.collections.ArrayCollection;
   
   public class LoadUnloadSelection
   {
      public var freeStorage: int;
      public var flanks: ArrayCollection;
      
      public function selectUnit(unit: MCUnit, flank: LoadUnloadFlank): Boolean
      {
         if (freeStorage == -1)
         {
            flank.selection.addItem(unit);
            unit.selected = true;
            return true;
         }
         if (unit.unit.volume <= freeStorage)
         {
            flank.selection.addItem(unit);
            unit.selected = true;
            freeStorage -= unit.unit.volume;
            return true;
         }
         return false;
      }
      
      public function clear(): void
      {
         flanks = null;
         freeStorage = 0;
      }
      
      public function selectFlank(flank: LoadUnloadFlank): Boolean
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
      
      public function selectAll(): Boolean
      {
         var selectedAll: Boolean = true;
         for each (var flank: LoadUnloadFlank in flanks)
         {
            if (!selectFlank(flank))
            {
               selectedAll = false;
            }
         }
         return selectedAll;
      }
   }
}