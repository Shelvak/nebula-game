package components.unitsscreen
{
   import components.base.Panel;
   import components.skins.FlankPanelSkin;
   
   import flash.events.Event;
   
   import models.unit.MCUnitScreen;
   
   public class CUnitScreenFlank extends Panel
   {
      public function CUnitScreenFlank()
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
      }
      
      
      private function removeEventListeners(e: Event): void
      {
         removeEventListener(UnitsScreenEvent.FLANK_SELECT_ALL, selectAllUnits);
         removeEventListener(UnitsScreenEvent.FLANK_DESELECT, deselectAll);
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
      
      //TODO check below
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
            uScreen.updateUnits(flanksObj);
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
            for each (var unit: Unit in flankModel.flank)
            {
               var idx: int = flankModel.flank.getItemIndex(unit);
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
            uScreen.updateUnits(flanksObj);
            deselectAll();
         }
      }
      
      
      public function unitsList_changeHandler(event:Event = null):void
      {
         unitsList.removeEventListener(FlexEvent.UPDATE_COMPLETE, unitsList_changeHandler);
         if ((flankModel.selection.length < unitsList.selectedIndices.length) && _transfer 
            && freeStorage != -1 && !selectDeselectAllRequested)
         {
            flankModel.selection = flankModel.selection.filter(function(item: Unit, index:int, vector:*): Boolean
            {
               return unitsList.selectedItems.indexOf(item) != -1;
            });
            var didntFit: Boolean = false;
            var newSelectedIndices: Vector.<int> = new Vector.<int>;
            flankModel.selection = unitsList.selectedItems.filter(function(item: Unit, index:int, vector:*): Boolean
            {
               if (flankModel.selection.indexOf(item) != -1)
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
            if (didntFit)
            {
               Messenger.show(Localizer.string('Units', 'message.notSelected'), MESSAGE_DURATION);
            }
            unitsList.addEventListener(FlexEvent.UPDATE_COMPLETE, unitsList_changeHandler);
         }
         else
         {
            flankModel.selection = unitsList.selectedItems;
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