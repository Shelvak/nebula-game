package models.unit
{
   import models.notification.MFaultEvent;
   import models.notification.MTimedEvent;

   import mx.collections.ArrayCollection;
   import mx.collections.ListCollectionView;

   import utils.locale.Localizer;
   
   public class LoadUnloadFlank extends UnitsFlank
   {
      public function LoadUnloadFlank(_flank:ListCollectionView, _nr:int, _owner:int)
      {
         super(_nr, _owner);
         flankUnits = _flank;
         for each (var unit: MCUnit in flankUnits)
         {
            unit.flankModel = this;
         }
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
                  selection.removeItemAt(idx);
               }
            }
         }
      }
      
      public override function invertSelection(model:MCUnit, shiftPressed:Boolean):void
      {
         if (selectionMode == UNDEFINED_SELECTION || !shiftPressed
            || model == lastUnit)
         {
            if (model.selected)
            {
               trySelecting(model);
               selectionMode = SELECTING;
               lastUnit = model;
            }
            else
            {
               selection.removeItemAt(selection.getItemIndex(model));
               selectionMode = DESELECTING;
               lastUnit = model;
            }
         }
         else
         {
            executeShiftSelection(model);
         }
         LS.refreshVolume();
      }
      
      private function trySelecting(model: MCUnit): void
      {
         if (!LS.selectionClass.selectUnit(model, this))
         {
            model.selected = false;
            new MFaultEvent(Localizer.string('Units', 'message.notSelected'));
         }
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
               if (selection.getItemIndex(currentModel) == -1)
               {
                  trySelecting(currentModel);
               }
               else
               {
                  currentModel.selected = true;
               }
            }
            else
            {
               currentModel.selected = false;
               var indx: int = selection.getItemIndex(currentModel);
               if (indx != -1)
               {
                  selection.removeItemAt(indx);
               }
            }
         }
      }
      
      private var LS: MCLoadUnloadScreen = MCLoadUnloadScreen.getInstance();
      
      public override function selectAll(dispatchEvnt:Boolean=true):void
      {
         if (!LS.selectionClass.selectFlank(this))
         {
            new MFaultEvent(Localizer.string('Units', 'message.notSelected'));
         }
         if (dispatchEvnt)
         {
            LS.refreshVolume();
         }
      }
      
      public override function deselectAll(dispatchEvnt:Boolean=true):void
      {
         for each (var model: MCUnit in selection)
         {
            model.selected = false;
         }
         selection = new ArrayCollection();
         if (dispatchEvnt)
         {
            LS.refreshVolume();
         }
      }

      public override function selectType(type: String):void
      {
         var someFailed: Boolean = false;
         for each (var model: MCUnit in flankUnits)
         {
            if (model.unit.type == type && selection.getItemIndex(model) == -1)
            {
               if (!LS.selectionClass.selectUnit(model, this))
               {
                  model.selected = false;
                  someFailed = true;
               }
            }
         }
         if (someFailed)
         {
            new MFaultEvent(Localizer.string('Units', 'message.notSelected'));
         }
         LS.refreshVolume();
      }

      public override function deselectType(type: String):void
      {
         for each (var model: MCUnit in flankUnits)
         {
            if (model.unit.type == type)
            {
               var idx: int = selection.getItemIndex(model);
               if (idx != -1)
               {
                  model.selected = false;
                  selection.removeItemAt(idx);
               }
            }
         }
         LS.refreshVolume();
      }
   }
}