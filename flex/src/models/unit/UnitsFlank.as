package models.unit
{
   import com.developmentarc.core.utils.EventBroker;
   
   import components.unitsscreen.events.UnitsScreenEvent;
   
   import flash.events.EventDispatcher;
   
   import globalevents.GUnitsScreenEvent;
   
   import models.ModelsCollection;
   import models.Owner;
   import models.factories.UnitFactory;

   import mx.collections.ArrayCollection;
   import mx.collections.ListCollectionView;
   
   [Bindable]
   public class UnitsFlank extends EventDispatcher
   {
      public function set flankUnits(value: ListCollectionView): void
      {
         _flankUnits = value;
         refreshCachedUnits();
         dispatchFlankUnitsChangeEvent();
      }

      [Bindable (event="flankUnitsChange")]
      public function get flankUnits(): ListCollectionView
      {
         return _flankUnits;
      }
      private var _flankUnits: ListCollectionView;
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
         refreshCachedUnits();
      }

      private function refreshCachedUnits(): void
      {
         if (_flankUnits.length > 0
                 && _flankUnits.getItemAt(0) is Unit)
         {
            cachedUnits = UnitFactory.buildCachedUnitsFromUnits(_flankUnits);
         }
         else
         {
            cachedUnits = null;
         }
//         else
//         {
//            var tObj: Object = {};
//            for each (var unit: MCUnit in flankUnits)
//            {
//               if (tObj[unit.unit.type == null])
//               {
//                  tObj[unit.unit.type] = 1;
//               }
//               else
//               {
//                  tObj[unit.unit.type]++;
//               }
//            }
//            cachedUnits = UnitFactory.createCachedUnits(tObj);
//         }
      }

      public function getFlankCachedUnits(): ArrayCollection
      {
         if (cachedUnits == null)
         {
            var tObj: Object = {};
            for each (var unit: MCUnit in flankUnits)
            {
               if (tObj[unit.unit.type] == null)
               {
                  tObj[unit.unit.type] = 1;
               }
               else
               {
                  tObj[unit.unit.type]++;
               }
            }
            cachedUnits = UnitFactory.createCachedUnits(tObj);
         }
         return cachedUnits;
      }

      public var cachedUnits: ArrayCollection;

       /* Only for NPC flanks in building selected sidebar */
      public var showCachedUnits: Boolean = false;
      
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
            model.selected = false;
         }
         flankUnits.enableAutoUpdate();
         if (selectionChanged && dispatchEvnt)
         {
            US.dispatchSelectionChangeEvent();
         }
         refreshCachedUnits();
      }
      
      public static const UNDEFINED_SELECTION: int = -1;
      public static const SELECTING: int = 0;
      public static const DESELECTING: int = 1;
      
      protected var selectionMode: int = UNDEFINED_SELECTION;
      protected var lastUnit: MCUnit;
      
      public function handleShiftClick(model: MCUnit): Boolean
      {
         if (selectionMode != UNDEFINED_SELECTION
            && model != lastUnit
            && flankUnits.getItemIndex(lastUnit) != -1)
         {
            executeShiftSelection(model);
            US.dispatchSelectionChangeEvent();
            return true;
         }
         else
         {
            return false;
         }
      }
      
      public function invertSelection(model: MCUnit, shiftPressed: Boolean): void
      {
         if (selectionMode == UNDEFINED_SELECTION || !shiftPressed
         || model == lastUnit || flankUnits.getItemIndex(lastUnit) == -1)
         {
            if (model.selected)
            {
               selection.addItem(model);
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
         US.dispatchSelectionChangeEvent();
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

      public function deselectType(type: String): void
      {
         for each (var unit: MCUnit in flankUnits)
         {
            if (unit.unit.type == type)
            {
               var idx: int = selection.getItemIndex(unit);
               if (idx != -1)
               {
                  unit.selected = false;
                  selection.removeItemAt(idx);
               }
            }
         }
         US.dispatchSelectionChangeEvent();
      }

      public function selectType(type: String): void
      {
         for each (var unit: MCUnit in flankUnits)
         {
            if (unit.unit.type == type && selection.getItemIndex(unit) == -1)
            {
               unit.selected = true;
               selection.addItem(unit);
            }
         }
         US.dispatchSelectionChangeEvent();
      }
      
      public function deselectUnit(unitId: int): void
      {
         for (var i: int = 0; i < selection.length; i++)
         {
            if (lastUnit != null && unitId == lastUnit.unit.id)
            {
               lastUnit = null;
               selectionMode = UNDEFINED_SELECTION;
            }
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

      public function setHidden(hidden: Boolean): void
      {
         US.transformedUnits.disableAutoUpdate();
         for each (var unit: MCUnit in selection)
         {
            unit.hidden = hidden;
         }
         US.transformedUnits.enableAutoUpdate();
         US.dispatchFormationChangeEvent();
      }

      private function dispatchFlankUnitsChangeEvent(): void
      {
         if (hasEventListener(UnitsScreenEvent.FLANK_UNITS_CHANGE))
         {
            dispatchEvent(new UnitsScreenEvent(UnitsScreenEvent.FLANK_UNITS_CHANGE));
         }
      }
   }
}