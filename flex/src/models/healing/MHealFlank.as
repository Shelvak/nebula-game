package models.healing
{
   import controllers.Messenger;
   
   import models.ModelsCollection;
   import models.Owner;
   import models.unit.MCUnit;
   import models.unit.Unit;
   import models.unit.UnitsFlank;
   
   import mx.collections.ArrayCollection;
   import mx.collections.ListCollectionView;
   import mx.states.OverrideBase;
   
   import utils.locale.Localizer;
   
   public class MHealFlank extends UnitsFlank
   {
      public function MHealFlank(_flank:ListCollectionView, 
                                 _nr:int, _owner:int=Owner.PLAYER, 
                                 _selectionClass: HealingSelection = null)
      {
         super(_nr, _owner);
         flankUnits = _flank;
         for each (var unit: MCUnit in flankUnits)
         {
            unit.flankModel = this;
         }
         selectionClass = _selectionClass;
      }
      
      public function removeUnit(unit: Unit): void
      {
         for (var i: int = 0; i<flankUnits.length; i++)
         {
            var mUnit: MCUnit = MCUnit(flankUnits.getItemAt(i));
            if (mUnit.unit == unit)
            {    
               if (lastUnit == mUnit)
               {
                  selectionMode = UNDEFINED_SELECTION;
                  lastUnit = null;
               }
               flankUnits.removeItemAt(i);
               var idx: int = selection.getItemIndex(mUnit);
               if (idx != -1)
               {
                  mUnit.selected = false;
                  selection.removeItemAt(idx);
                  HS.refreshPrice();
               }
               return;
            }
         }
      }
      
      private var HS: MCHealingScreen = MCHealingScreen.getInstance();
      
      public override function deselectAll(dispatchEvnt:Boolean=true):void
      {
         for each (var model: MCUnit in selection)
         {
            model.selected = false;
         }
         selection = new ArrayCollection();
         if (dispatchEvnt)
         {
            HS.refreshPrice();
         }
      }
      
      public override function selectAll(dispatchEvnt:Boolean=true):void
      {
         for each (var unit: MCUnit in flankUnits)
         {
            if (selection.getItemIndex(unit) == -1)
            {
               unit.selected = true;
               selection.addItem(unit);
            }
         }
         HS.refreshPrice();
      }
      
      public override function invertSelection(model:MCUnit, shiftPressed:Boolean):void
      {
         if (selectionMode == UNDEFINED_SELECTION || !shiftPressed
            || model == lastUnit)
         {
            if (model.selected)
            {
               selection.addItem(model);
               selectionMode = SELECTING;
            }
            else
            {
               selection.removeItemAt(selection.getItemIndex(model));
               selectionMode = DESELECTING;
            }
            lastUnit = model;
         }
         else
         {
            executeShiftSelection(model);
         }
         HS.refreshPrice();
      }
      
      private function executeShiftSelection(model: MCUnit): void
      {
         var fromIndex: int = flankUnits.getItemIndex(lastUnit);
         var toIndex: int = flankUnits.getItemIndex(model);
         for (var i: int = Math.min(fromIndex, toIndex); i <= Math.max(fromIndex, toIndex); i++)
         {
            var currentModel: MCUnit = MCUnit(flankUnits.getItemAt(i));
            if (selectionMode == SELECTING)
            {
               currentModel.selected = true;
               if (selection.getItemIndex(currentModel) == -1)
               {
                  selection.addItem(currentModel);
               }
            }
            else
            {
               currentModel.selected = false;
               var idx: int = selection.getItemIndex(currentModel);
               if (idx != -1)
               {
                  selection.removeItemAt(idx);
               }
            }
         }
      }
      
      public var selectionClass: HealingSelection;
   }
}