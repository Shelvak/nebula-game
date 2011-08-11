package components.unitsscreen
{
   import components.base.Panel;
   import components.skins.FlankPanelSkin;
   
   import flash.events.Event;
   
   import models.unit.MCUnitScreen;
   
   import mx.collections.ArrayCollection;
   import mx.collections.ListCollectionView;
   
   import utils.datastructures.Collections;
   
   [SkinState("transfering")]
   [SkinState("normal")]
   
   public class FlankComp extends Panel
   {
      public function FlankComp()
      {
         super();
         setStyle('skinClass', FlankPanelSkin);
         addEventListener(Event.ADDED_TO_STAGE, addEventListeners);
         addEventListener(Event.REMOVED_FROM_STAGE, removeEventListeners);
      }
      
      private function addEventListeners(e: Event): void
      {
         addEventListener(UnitsScreenEvent.FLANK_SELECT_ALL, selectAllUnits);
         addEventListener(UnitsScreenEvent.FLANK_DESELECT, deselectAll);
         EventBroker.subscribe(GUnitsScreenEvent.DESELECT_UNITS, deselectAll);
         EventBroker.subscribe(GUnitsScreenEvent.SELECT_ALL, selectAllUnits);
         EventBroker.subscribe(GUnitsScreenEvent.SET_STANCE, updateStances);
         if (_transfer)
         {
            EventBroker.subscribe(GLoadUnloadScreenEvent.DESELECT_UNITS, deselectAll);
            EventBroker.subscribe(GLoadUnloadScreenEvent.SELECT_ALL, selectAllUnits);
            EventBroker.subscribe(GLoadUnloadScreenEvent.FREE_STORAGE_CHANGE, changeFreeStorage);
         }
      }
      
      
      private function removeEventListeners(e: Event): void
      {
         removeEventListener(UnitsScreenEvent.FLANK_SELECT_ALL, selectAllUnits);
         removeEventListener(UnitsScreenEvent.FLANK_DESELECT, deselectAll);
         EventBroker.unsubscribe(GUnitsScreenEvent.DESELECT_UNITS, deselectAll);
         EventBroker.unsubscribe(GUnitsScreenEvent.SELECT_ALL, selectAllUnits);
         EventBroker.unsubscribe(GUnitsScreenEvent.SET_STANCE, updateStances);
         EventBroker.unsubscribe(GLoadUnloadScreenEvent.DESELECT_UNITS, deselectAll);
         EventBroker.unsubscribe(GLoadUnloadScreenEvent.SELECT_ALL, selectAllUnits);
         EventBroker.unsubscribe(GLoadUnloadScreenEvent.FREE_STORAGE_CHANGE, changeFreeStorage);
      }
      
      import com.developmentarc.core.utils.EventBroker;
      
      import components.base.AdvancedList;
      import components.unitsscreen.events.UnitsScreenEvent;
      
      import controllers.Messenger;
      
      import globalevents.GLoadUnloadScreenEvent;
      import globalevents.GUnitsScreenEvent;
      
      import models.unit.Unit;
      import models.unit.UnitsFlank;
      
      import mx.core.IUIComponent;
      import mx.events.DragEvent;
      import mx.events.FlexEvent;
      import mx.managers.DragManager;
      
      import spark.components.List;
      import spark.events.IndexChangeEvent;
      
      import utils.locale.Localizer;
      
      private static const MESSAGE_DURATION: int = Messenger.MEDIUM;
      
      private var _freeStorage: int = 0;
      
      public function set freeStorage(value: int): void
      {
         _freeStorage = value;
      }
      
      public function changeFreeStorage(e: GLoadUnloadScreenEvent): void
      {
         _freeStorage = e.freeStorage;
      }
      
      public function get freeStorage(): int
      {
         return _freeStorage;
      }
      
      [Bindable (event="flankModelChange")]
      public function get flankModel(): UnitsFlank
      {
         return _flankModel;
      }
      
      public function set flankModel(value: UnitsFlank): void
      {
         if (_flankModel)
         {
            _flankModel.removeEventListener(UnitsScreenEvent.FLANK_DESELECT, deselectAll);
         }
         _flankModel = value;
         if (_flankModel)
         {
            _flankModel.addEventListener(UnitsScreenEvent.FLANK_DESELECT, deselectAll);
         }
         dispatchFlankModelChangeEvent();
      }
      
      private function dispatchFlankModelChangeEvent(): void
      {
         if (hasEventListener(UnitsScreenEvent.FLANK_MODEL_CHANGE))
         {
            dispatchEvent(new UnitsScreenEvent(UnitsScreenEvent.FLANK_MODEL_CHANGE));
         }
      }
      
      public var _flankModel: UnitsFlank;
      
      public function get selectedUnits(): Vector.<Object>
      {
         return unitsList.selectedItems;
      }
      
      public function dragEnterHandler(event:DragEvent):void
      {           
         DragManager.acceptDragDrop(event.currentTarget as IUIComponent);
      }
      
      private var uScreen: MCUnitScreen = MCUnitScreen.getInstance();
      
      public function unitsList_dragDropHandler(event:DragEvent):void
      {
         if (event.dragInitiator is List)
         { 
            var flanksObj: Object = {};
            for each (var unit: Unit in (event.dragInitiator as List).selectedItems)
            {
               flanksObj[unit.id] = [flankModel.nr - 1, null, unit];
            }
            uScreen.updateChanges();
         }
         deselect = true;
      }
      
      public var deselect: Boolean = false;
      
      private function deselectAll(e: Event = null): void
      {
         if (e is UnitsScreenEvent || (e is GLoadUnloadScreenEvent && _transfer) 
            || (e is GUnitsScreenEvent && !_transfer))
         {
            unitsList.selectedIndices = new Vector.<int>;
            selectDeselectAllRequested = false;
            unitsList.addEventListener(FlexEvent.UPDATE_COMPLETE, unitsList_changeHandler);
         }
      }
      
      private function selectAllUnits(e: Event): void
      {
         if (e is UnitsScreenEvent || (e is GLoadUnloadScreenEvent && _transfer) 
            || (e is GUnitsScreenEvent && !_transfer))
         {
            var allSelection: Vector.<int> = new Vector.<int>;
            var total: int = 0;
            for each (var unit: Unit in flankModel.flankUnits)
            {
               var idx: int = flankModel.flankUnits.getItemIndex(unit);
               if (!unitsList.selectedIndices || unitsList.selectedIndices.lastIndexOf(idx) == -1)
               {
                  if (((unit.volume + total) <= freeStorage) || (freeStorage == -1) || !_transfer)
                  {
                     total+= (freeStorage == -1?0:unit.volume);
                     allSelection.push(idx);
                  }
                  else
                  {
                     Messenger.show(Localizer.string('Units', 'message.notSelected'), MESSAGE_DURATION);
                  }
               }
               else
               {
                  allSelection.push(idx);
               }
            }
            if (freeStorage != -1 && total > 0 && _transfer)
            {
               new GLoadUnloadScreenEvent(GLoadUnloadScreenEvent.FREE_STORAGE_CHANGE, freeStorage - total);
            }
            unitsList.selectedIndices = allSelection;
            selectDeselectAllRequested = true;
            unitsList.addEventListener(FlexEvent.UPDATE_COMPLETE, unitsList_changeHandler);
         }
      }
      
      private var selectDeselectAllRequested: Boolean = false;
      
      private function updateStances(e: GUnitsScreenEvent): void
      {
         if (!_transfer)
         {
            var flanksObj: Object = {};
            ML.units.disableAutoUpdate();
            for each (var unit: Unit in unitsList.selectedItems)
            {
               flanksObj[unit.id] = [null, e.stance, unit];
               unit.newStance = e.stance;
            }
            ML.units.enableAutoUpdate();
            uScreen.updateChanges();
            deselectAll();
         }
      }
      
      
      public function unitsList_changeHandler(event:Event = null):void
      {
         unitsList.removeEventListener(FlexEvent.UPDATE_COMPLETE, unitsList_changeHandler);
         if ((flankModel.selection.length < unitsList.selectedIndices.length) && _transfer 
            && freeStorage != -1 && !selectDeselectAllRequested)
         {
            flankModel.selection = Collections.filter(flankModel.selection,
               function(item: Unit): Boolean
            {
               return unitsList.selectedItems.indexOf(item) != -1;
            });
            var didntFit: Boolean = false;
            var newSelectedIndices: Vector.<int> = new Vector.<int>;
            var tempSelection: Vector.<Object> = unitsList.selectedItems.filter(function(item: Unit, index:int, vector:*): Boolean
            {
               if (flankModel.selection.getItemIndex(item) != -1)
               {
                  newSelectedIndices.push(unitsList.selectedIndices[index]);
                  return true;
               }
               else
               {
                  if (item.volume > freeStorage)
                  {
                     didntFit = true;
                     return false;
                  }
                  else
                  {
                     freeStorage -= item.volume;
                     newSelectedIndices.push(unitsList.selectedIndices[index]);
                     return true;
                  }
               }
            });
            unitsList.selectedIndices = newSelectedIndices;
            flankModel.selection = new ArrayCollection();
            for each (var unit: Unit in tempSelection)
            {
               flankModel.selection.addItem(unit);
            }
            if (didntFit)
            {
               Messenger.show(Localizer.string('Units', 'message.notSelected'), MESSAGE_DURATION);
            }
            unitsList.addEventListener(FlexEvent.UPDATE_COMPLETE, unitsList_changeHandler);
         }
         else
         {
            flankModel.selection = new ArrayCollection();
            for each (unit in unitsList.selectedItems)
            {
               flankModel.selection.addItem(unit);
            }
            uScreen.dispatchSelectionChangeEvent();
         }
         selectDeselectAllRequested = false;
      }
      
      override protected function getCurrentSkinState():String
      {
         if (_transfer)
            return "transfering";
         else
            return "normal";
      }
      
      private var _transfer: Boolean = false;
      
      public function set transfer(value: Boolean): void
      {
         _transfer = value;
         if (_transfer)
         {
            EventBroker.subscribe(GLoadUnloadScreenEvent.DESELECT_UNITS, deselectAll);
            EventBroker.subscribe(GLoadUnloadScreenEvent.SELECT_ALL, selectAllUnits);
            EventBroker.subscribe(GLoadUnloadScreenEvent.FREE_STORAGE_CHANGE, changeFreeStorage);
         }
         invalidateSkinState();
      }
      
      [SkinPart (required="true")]
      public var unitsList: AdvancedList;
   }
}