package models.healing
{
   import controllers.Messenger;
   
   import globalevents.GHealingScreenEvent;
   
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
         if (!selectionClass.selectFlank(this))
         {
            Messenger.show(Localizer.string('Units', 'message.noResources'), Messenger.MEDIUM);
         }
         HS.refreshPrice();
      }
      
      public override function invertSelection(model:MCUnit):void
      {
         if (model.selected)
         {
            if (!selectionClass.selectUnit(model, this))
            {
               model.selected = false;
               Messenger.show(Localizer.string('Units', 'message.noResources'), Messenger.MEDIUM);
            }
            else
            {
               HS.refreshPrice();
            }
         }
         else
         {
            selection.removeItemAt(selection.getItemIndex(model));
            HS.refreshPrice();
         }
      }
      
      public var selectionClass: HealingSelection;
   }
}