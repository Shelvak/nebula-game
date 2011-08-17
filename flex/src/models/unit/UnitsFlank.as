package models.unit
{
   import com.developmentarc.core.utils.EventBroker;
   
   import components.unitsscreen.events.UnitsScreenEvent;
   
   import flash.events.EventDispatcher;
   
   import globalevents.GUnitsScreenEvent;
   
   import models.ModelsCollection;
   import models.Owner;
   
   import mx.collections.ArrayCollection;
   import mx.collections.ListCollectionView;
   
   [Bindable]
   public class UnitsFlank extends EventDispatcher
   {
      public var flankUnits: ListCollectionView;
      public var nr: int;
      public var owner: int;
      public var selection: ListCollectionView;
      
      public function UnitsFlank(_nr: int, _owner: int)
      {
         nr = _nr;
         owner = _owner;
         selection = new ArrayCollection();
      }
      
      /* ############################################### */
      /* ### FOLOWING APPLIES FOR SIMPLE UNIT SCREEN ### */
      /* ############################################### */
      
      public function addUnits(models: Array): void
      {
         flankUnits.disableAutoUpdate();
         for each (var model: MCUnit in models)
         {
            flankUnits.addItem(model);
         }
         flankUnits.enableAutoUpdate();
      }
      
      public function removeUnits(models: Array, dispatchEvnt: Boolean = true): void
      {
         var selectionChanged: Boolean = false;
         flankUnits.disableAutoUpdate();
         for each (var model: MCUnit in models)
         {
            flankUnits.removeItemAt(flankUnits.getItemIndex(model));
            var indx: int = selection.getItemIndex(model);
            if (indx != -1)
            {
               selection.removeItemAt(indx);
               selectionChanged = true;
            }
         }
         flankUnits.enableAutoUpdate();
         if (selectionChanged && dispatchEvnt)
         {
            US.dispatchSelectionChangeEvent();
         }
      }
      
      public function invertSelection(model: MCUnit): void
      {
         if (model.selected)
         {
            selection.addItem(model);
         }
         else
         {
            selection.removeItemAt(selection.getItemIndex(model));
         }
         US.dispatchSelectionChangeEvent();
      }
      
      public function deselectAll(dispatchEvnt: Boolean = true): void
      {
         selection = new ArrayCollection();
         for each (var unit: MCUnit in flankUnits)
         {
            unit.selected = false;
         }
         if (dispatchEvnt)
         {
            US.dispatchSelectionChangeEvent();
         }
      }
      
      public function selectAll(dispatchEvnt: Boolean = true): void
      {
         for each (var unit: MCUnit in flankUnits)
         {
            if (selection.getItemIndex(unit) == -1)
            {
               unit.selected = true;
               selection.addItem(unit);
            }
         }
         if (dispatchEvnt)
         {
            US.dispatchSelectionChangeEvent();
         }
      }
      
      public function deselectUnit(unitId: int): void
      {
         for (var i: int = 0; i < selection.length; i++)
         {
            if (MCUnit(selection.getItemAt(i)).unit.id == unitId)
            {
               selection.removeItemAt(i);
               US.dispatchSelectionChangeEvent();
               return;
            }
         }
      }
      
      public function startDrag(): void
      {
         US.sourceFlank = this;
         US.sourceUnits = selection;
      }
      
      public function stopDrag(): void
      {
         US.transformedUnits.disableAutoUpdate();
         for each (var unit: MCUnit in US.sourceUnits)
         {
            unit.flankModel = this;
         }
         US.transformedUnits.enableAutoUpdate();
         US.sourceFlank = null;
         US.sourceUnits = null;
         US.dispatchFormationChangeEvent();
         US.deselectUnits();
      }
      
      private var US: MCUnitScreen = MCUnitScreen.getInstance();
      
      public function setStance(stance: int): void
      {
         US.transformedUnits.disableAutoUpdate();
         for each (var unit: MCUnit in selection)
         {
            unit.stance = stance;
         }
         US.transformedUnits.enableAutoUpdate();
         US.dispatchFormationChangeEvent();
      }
   }
}