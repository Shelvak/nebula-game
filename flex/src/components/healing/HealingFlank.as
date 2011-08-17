package components.healing
{
   import com.developmentarc.core.utils.EventBroker;
   
   import components.base.AdvancedList;
   import components.base.Panel;
   import components.skins.HealingFlankSkin;
   import components.unitsscreen.events.UnitsScreenEvent;
   
   import controllers.Messenger;
   
   import flash.events.Event;
   
   import globalevents.GHealingScreenEvent;
   import globalevents.GUnitsScreenEvent;
   
   import models.healing.MHealFlank;
   import models.unit.Unit;
   
   import mx.collections.ArrayCollection;
   import mx.events.FlexEvent;
   
   import utils.locale.Localizer;
   
   public class HealingFlank extends Panel
   {
      public function HealingFlank()
      {
         super();
         setStyle('skinClass', HealingFlankSkin);
         addEventListener(Event.ADDED_TO_STAGE, addEventListeners);
         addEventListener(Event.REMOVED_FROM_STAGE, removeEventListeners);
      }
      
      private function addEventListeners(e: Event): void
      {
         EventBroker.subscribe(GHealingScreenEvent.DESELECT_UNITS, deselectAll);
         EventBroker.subscribe(GHealingScreenEvent.SELECTION_UPDATED, markSelected);
      }
      
      
      private function removeEventListeners(e: Event): void
      {
         EventBroker.unsubscribe(GHealingScreenEvent.DESELECT_UNITS, deselectAll);
         EventBroker.unsubscribe(GHealingScreenEvent.SELECTION_UPDATED, markSelected);
      }
      
      public function selectAllRequested(): void
      {
         if (!flankModel.selectionClass.selectFlank(flankModel))
         {
            Messenger.show(Localizer.string('Units', 'message.noResources'), MESSAGE_DURATION);
         }
         markSelected();
      }
      
      private function markSelected(e: GHealingScreenEvent = null): void
      {
         var tempSelection: Vector.<Object> = new Vector.<Object>;
         for each (var unit: Unit in flankModel.selection)
         {
            tempSelection.push(unit);
         }
         unitsList.selectedItems = tempSelection;
         new GUnitsScreenEvent(GUnitsScreenEvent.SELECTION_PRECHANGE);
      }
      
      private static const MESSAGE_DURATION: int = Messenger.MEDIUM;
      
      [Bindable]
      public var flankModel: MHealFlank;
      
      public function get selectedUnits(): Vector.<Object>
      {
         return unitsList.selectedItems;
      }
      
      public function deselectAll(e: GHealingScreenEvent = null): void
      {
         unitsList.selectedIndices = new Vector.<int>;
         flankModel.selection = new ArrayCollection();
         new GUnitsScreenEvent(GUnitsScreenEvent.SELECTION_PRECHANGE);
      }
      
      public function unitsList_changeHandler(event:Event = null):void
      {
         if (!flankModel.selectionClass.updateSelection(flankModel, unitsList.selectedItems))
         {
            function renewSelection(e: FlexEvent): void
            {
               unitsList.removeEventListener(FlexEvent.UPDATE_COMPLETE, renewSelection);
               new GHealingScreenEvent(GHealingScreenEvent.SELECTION_UPDATED);
               Messenger.show(Localizer.string('Units', 'message.noResources'), MESSAGE_DURATION);
            }
            unitsList.addEventListener(FlexEvent.UPDATE_COMPLETE, renewSelection);
         }
         new GUnitsScreenEvent(GUnitsScreenEvent.SELECTION_PRECHANGE);
      }
      
      [SkinPart (required="true")]
      public var unitsList: AdvancedList;
   }
}