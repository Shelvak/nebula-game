package components.unitsscreen
{
   import components.base.Panel;
   import components.skins.FlankPanelSkin;
   
   import flash.events.Event;
   
   import models.unit.MCLoadUnloadScreen;
   import models.unit.MCUnitScreen;
   
   import mx.collections.ArrayCollection;
   
   import utils.datastructures.Collections;
   
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
         EventBroker.subscribe(GLoadUnloadScreenEvent.DESELECT_UNITS, deselectAll);
         EventBroker.subscribe(GLoadUnloadScreenEvent.SELECT_ALL, selectAllUnits);
      }
      
      
      private function removeEventListeners(e: Event): void
      {
         EventBroker.unsubscribe(GLoadUnloadScreenEvent.DESELECT_UNITS, deselectAll);
         EventBroker.unsubscribe(GLoadUnloadScreenEvent.SELECT_ALL, selectAllUnits);
      }
      
      import com.developmentarc.core.utils.EventBroker;
      
      import components.base.AdvancedList;
      import components.unitsscreen.events.UnitsScreenEvent;
      
      import controllers.Messenger;
      
      import globalevents.GLoadUnloadScreenEvent;
      
      import models.unit.Unit;
      import models.unit.UnitsFlank;
      
      import mx.events.FlexEvent;
      
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
         _flankModel = value;
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
      
      public function deselectAll(e: GLoadUnloadScreenEvent = null): void
      {
         flankModel.selection = new ArrayCollection();
         unitsList.selectedIndices = new Vector.<int>;
         selectDeselectAllRequested = false;
         LS.refreshVolume();
      }
      
      private var LS: MCLoadUnloadScreen = MCLoadUnloadScreen.getInstance();
      
      public function selectAllUnits(e: GLoadUnloadScreenEvent = null): void
      {
         var allSelection: Vector.<int> = new Vector.<int>;
         var total: int = 0;
         var notSelected: Boolean = false;
         for each (var unit: Unit in flankModel.flankUnits)
         {
            var idx: int = flankModel.flankUnits.getItemIndex(unit);
            if (!unitsList.selectedIndices || unitsList.selectedIndices.lastIndexOf(idx) == -1)
            {
               if (unit.volume + total <= LS.freeSpace)
               {
                  total += unit.volume;
                  allSelection.push(idx);
               }
               else
               {
                  notSelected = true;
               }
            }
            else
            {
               allSelection.push(idx);
            }
         }
         unitsList.selectedIndices = allSelection;
         var selectionSource: Array = [];
         for each (var selUnit: Unit in selectionSource)
         {
            selectionSource.push(selUnit);
         }
         flankModel.selection = new ArrayCollection(selectionSource);
         selectDeselectAllRequested = true;
         if (notSelected)
         {
            Messenger.show(Localizer.string('Units', 'message.notSelected'), MESSAGE_DURATION);
         }
         LS.refreshVolume();
      }
      
      private var selectDeselectAllRequested: Boolean = false;
      
      
      public function unitsList_changeHandler(event:Event = null):void
      {
         if (flankModel.selection.length < unitsList.selectedIndices.length 
            && !selectDeselectAllRequested)
         {
            flankModel.selection = Collections.filter(flankModel.selection,
               function(item: Unit): Boolean
               {
                  return unitsList.selectedItems.indexOf(item) != -1;
               });
            var didntFit: Boolean = false;
            var newSelectedIndices: Vector.<int> = new Vector.<int>;
            var freeSpace: int = LS.freeSpace;
            var tempSelection: Vector.<Object> = unitsList.selectedItems.filter(function(item: Unit, index:int, vector:*): Boolean
            {
               if (flankModel.selection.getItemIndex(item) != -1)
               {
                  newSelectedIndices.push(unitsList.selectedIndices[index]);
                  return true;
               }
               else
               {
                  if (item.volume > freeSpace)
                  {
                     didntFit = true;
                     return false;
                  }
                  else
                  {
                     freeSpace -= item.volume;
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
            LS.refreshVolume();
         }
         selectDeselectAllRequested = false;
      }
      
      [SkinPart (required="true")]
      public var unitsList: AdvancedList;
   }
}