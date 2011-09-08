package models.unit
{
   import controllers.Messenger;
   
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
               flankUnits.removeItemAt(i);
               var idx: int = selection.getItemIndex(mUnit);
               if (idx != -1)
               {
                  selection.removeItemAt(idx);
               }
            }
         }
      }
      
      public override function invertSelection(model: MCUnit): void
      {
         if (model.selected)
         {
            if (!LS.selectionClass.selectUnit(model, this))
            {
               model.selected = false;
               Messenger.show(Localizer.string('Units', 'message.notSelected'), 
                  Messenger.SHORT);
            }
         }
         else
         {
            selection.removeItemAt(selection.getItemIndex(model));
         }
         LS.refreshVolume();
      }
      
      private var LS: MCLoadUnloadScreen = MCLoadUnloadScreen.getInstance();
      
      public override function selectAll(dispatchEvnt:Boolean=true):void
      {
         if (!LS.selectionClass.selectFlank(this))
         {
            Messenger.show(Localizer.string('Units', 'message.notSelected'), 
               Messenger.SHORT);
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
   }
}