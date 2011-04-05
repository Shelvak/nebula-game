package models.healing
{
   import controllers.Messenger;
   import controllers.screens.MainAreaScreens;
   import controllers.screens.MainAreaScreensSwitch;
   
   import globalevents.GHealingScreenEvent;
   
   import models.building.Building;
   import models.unit.Unit;
   
   import mx.collections.ArrayCollection;
   
   import utils.locale.Localizer;
   
   public class HealingSelection
   {      
      public var flanks: ArrayCollection;
      
      public var center: Building;
      
      public function selectUnit(unit: Unit, flank: MHealFlank): Boolean
      {
         if (!selectedPrice)
         {
            selectedPrice = new HealPrice();
         }
         if (selectedPrice.addIfPossible(HealPrice.calculateHealingPrice([unit], center.level, center.type)))
         {
            flank.selection.push(unit);
            return true;
         }
         return false;
      }
      
      public function clear(): void
      {
         flanks = null;
         selectedPrice = null;
      }
      
      public var selectedPrice: HealPrice;
      
      public function selectFlank(flank: MHealFlank): Boolean
      {
         var selectedAll: Boolean = true;
         for each (var unit: Unit in flank.flank)
         {
            if (flank.selection.indexOf(unit) == -1)
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
         for each (var flank: MHealFlank in flanks)
         {
            if (!selectFlank(flank))
            {
               selectedAll = false;
            }
         }
         new GHealingScreenEvent(GHealingScreenEvent.SELECTION_UPDATED);
         return selectedAll;
      }
      
      public function updateSelection(flank: MHealFlank, selection: Vector.<Object>): Boolean
      {
         var selectedAll: Boolean = true;
         for each (var unit: Unit in flank.selection)
         {
            if (selection.indexOf(unit) == -1)
            {
               selectedPrice.substract(HealPrice.calculateHealingPrice([unit], center.level, center.type));
            }
         }
         var newSelection: Vector.<Object> = new Vector.<Object>;
         for each (unit in selection)
         {
            if (flank.selection.indexOf(unit) == -1)
            {
               if (!selectUnit(unit, flank))
               {
                  selectedAll = false;
               }
               else
               {
                  newSelection.push(unit);
               }
            }
            else
            {
               newSelection.push(unit);
            }
         }
         
         flank.selection = newSelection;
         
         return selectedAll;
      }
      
      private function deselectLast(): void
      {
         for each (var flank: MHealFlank in flanks)
         {
            if (flank.selection.length > 0)
            {
               var deselectedUnit: Unit = flank.selection.pop();
               selectedPrice.substract(HealPrice.calculateHealingPrice([deselectedUnit], center.level, center.type));
               checkIfNotNegative();
               return;
            }
         }
      }
      
      public function checkIfNotNegative(): void
      {
         if (selectedPrice && !selectedPrice.validate())
         {
            deselectLast();
            if (MainAreaScreensSwitch.getInstance().currentScreenName == MainAreaScreens.HEAL)
            {
               Messenger.show(Localizer.string('Units', 'message.wasDeselected'), Messenger.MEDIUM);
            }
         }
      }
   }
}