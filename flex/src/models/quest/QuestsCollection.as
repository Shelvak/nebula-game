package models.quest
{
   import com.developmentarc.core.utils.EventBroker;
   
   import controllers.ui.NavigationController;
   
   import globalevents.GlobalEvent;
   
   import models.ModelsCollection;
   import models.quest.events.QuestCollectionEvent;
   import models.quest.events.QuestEvent;
   
   import mx.collections.Sort;
   import mx.collections.SortField;
   import mx.events.CollectionEvent;
   import mx.events.CollectionEventKind;
   
   
   /**
    * Dispatched when quest has been selected or deselected. If both are true, only one event will be
    * dispatched. 
    * 
    * @eventType models.quest.events.QuestCollectionEvent.SELECTION_CHANGE
    */
   [Event(name="selectionChange", type="models.quest.events.QuestCollectionEvent")]
   
   
   /**
    * Dispatched when any of counter properties
    * <code>currentTotal</code> and <code>completedTotal</code>) where updated.
    * 
    * @eventType models.quest.events.QuestCollectionEvent.COUNTERS_UPDATED
    */
   [Event(name="countersUpdated", type="models.quest.events.QuestCollectionEvent")]
   
   
   /**
    * List of quests.
    */
   public class QuestsCollection extends ModelsCollection
   {
      private var allQuests: ModelsCollection;
      /**
       * @see mx.collections.ArrayCollection#ArrayCollection()
       */
      public function QuestsCollection(source:Array = null)
      {
         super(source);
         allQuests = new ModelsCollection(source);
         registerSelfEventHandlers();
         applyIdSort();
         updateCounters();
         applyCompletedFilter(false);
      }
      
      
      /* ################## */
      /* ### PROPERTIES ### */
      /* ################## */
      
      private var _currentTotal: int = 0;
      private var _completedTotal: int = 0;
      
      [Bindable(event="countersUpdated")]
      public function get questsTotal() : int
      {
         return source.length;
      }
      
      [Bindable(event="countersUpdated")]
      public function get currentTotal() : int
      {
         return _currentTotal;
      }
      
      [Bindable(event="countersUpdated")]
      public function get completedTotal() : int
      {
         return _completedTotal;
      }
      
      [Bindable(event="countersUpdated")]
      public function get hasQuests() : Boolean
      {
         return questsTotal > 0;
      }
      
      
      private var _selectedQuest:Quest = null;
      [Bindable(event="selectionChange")]
      /**
       * Currrently selected quest.
       */
      public function get selectedQuest() : Quest
      {
         return _selectedQuest;
      }
      
      
      /* ######################### */
      /* ### INTERFACE METHODS ### */
      /* ######################### */
      
      
      /**
       * Same as: <code>getItemAt(index, prefetch) as Quest</code>
       * 
       * @see #getItemAt()
       */
      public function getQuestAt(index:int, prefetch:int = 0) : Quest
      {
         return getItemAt(index, prefetch) as Quest;
      }
      
      public function findQuestByObjective(objectiveId: int): Quest
      {
         for each (var quest: Quest in allQuests)
         {
            if (quest.objectives.find(objectiveId) != null)
            {
               return quest;
            }
         }
         return null;
      }
      
      public function findQuest(questId: int): Quest
      {
         for each (var quest: Quest in allQuests)
         {
            if (quest.id == questId)
            {
               return quest;
            }
         }
         return null;
      }
      
      public function findQuestByProgress(progressId: int): Quest
      {
         for each (var quest: Quest in allQuests)
         {
            for each (var objective: QuestObjective in quest.objectives)
            {
               if (objective.progressId == progressId)
               {
                  return quest;
               }
            }
         }
         return null;
      }
      
      public function findObjective(objectiveId: int): QuestObjective
      {
         for each (var quest: Quest in allQuests)
         {
            if (quest.objectives.find(objectiveId) != null)
            {
               return quest.objectives.find(objectiveId);
            }
         }
         return null;
      }
      
      
      public override function addItemAt(item:Object, index:int) : void
      {
         super.addItemAt(item, index);
         registerQuestEventHandlers(item as Quest);
      }
      
      public override function addItem(item:Object):void
      {
         allQuests.addItem(item);
         super.addItem(item);
      }
      
      public override function removeAll(): void
      {
         removeFilter();
         super.removeAll();
         for each (var quest: Quest in allQuests)
         {
            removeQuestEventHandlers(quest);
         }
         allQuests.removeAll();
         applyCompletedFilter(false);
      }
      
      public override function removeItemAt(index:int):Object
      {
         var questRemoved:Quest = super.removeItemAt(index) as Quest;
         removeQuestEventHandlers(questRemoved);
         return questRemoved;
      }
      
      public var selectedFilter: int = 0;
      
      public function applyCompletedFilter(completed: Boolean) : void
      {
         selectedFilter = completed?1:0;
         filterFunction = function(quest:Quest) : Boolean
         {
            return (completed
               ? quest.status == Quest.STATUS_REWARD_TAKEN 
               : quest.status != Quest.STATUS_REWARD_TAKEN);
         }
         refresh();
         updateSelectionAfterFilter();
         if (hasEventListener(QuestCollectionEvent.FILTER))
         {
            dispatchEvent(new QuestCollectionEvent(QuestCollectionEvent.FILTER));
         }
         updateCounters();
      }
      
      public function applyCurrentFilter(): void
      {
         refresh();
         updateSelectionAfterFilter();
         if (_selectedQuest != null)
         {
            var newId: int = _selectedQuest.id
            _selectedQuest = null;
            select(newId);
         }
         updateCounters();
      }
      
      public function showAndFilter(completed: Boolean, selectedItem: Quest): void
      {
         NavigationController.getInstance().showQuests();
         applyCompletedFilter(completed);
         var selectAfterUpdate: Function = function (e: QuestCollectionEvent): void
         {
            select(selectedItem.id);
            removeEventListener(QuestCollectionEvent.UPDATE_COMPLETED, selectAfterUpdate);
         }
         addEventListener(QuestCollectionEvent.UPDATE_COMPLETED, selectAfterUpdate);
      }
      
      
      public function removeFilter() : void
      {
         filterFunction = null;
         refresh();
      }
      
      
      public function select(id:int) : void
      {
         selectImpl(findQuest(id));
      }
      
      
      public function deselect(dispatchUiCommand:Boolean = true) : void
      {
         selectImpl(null, dispatchUiCommand);
      }
      
      
      /**
       * Navigates to quests screen and selects quest with a given id.
       * 
       * @param id id of quest to select
       */
      public function show(id:int) : void
      {
         NavigationController.getInstance().showQuests();
         select(id);
      }
      
      
      /* ############### */
      /* ### HELPERS ### */
      /* ############### */
      
      
      private function applyIdSort() : void
      {
         var sort:Sort = new Sort();
         sort.fields = [
            new SortField("id")
         ];
         this.sort = sort;
         refresh();
      }
      
      
      private function updateSelectionAfterFilter() : void
      {
         if (_selectedQuest && !contains(_selectedQuest))
         {
            deselect();
         }
      }
      
      
      private function selectImpl(newQuest:Quest = null, dispatchUiCommand:Boolean = true) : void
      {
         var oldQuest:Quest = _selectedQuest;
         if (newQuest != oldQuest)
         {
            _selectedQuest = newQuest;
            if (dispatchUiCommand)
            {
               dispatchSelectionChangeEvent(oldQuest, newQuest);
            }
         }
      }
      
      
      private function updateCounters() : void
      {
         _completedTotal = 0;
         _currentTotal = 0;
         for each (var quest:Quest in source)
         {
            if (quest.status == Quest.STATUS_REWARD_TAKEN)
            {
               _completedTotal++;
            }
            else
            {
               _currentTotal++;
            }
         }
         dispatchCountersUpdatedEvent();
      }
      
      
      /* ################################## */
      /* ### EVENTS DISPATCHING METHODS ### */
      /* ################################## */
      
      
      private function dispatchSelectionChangeEvent(oldQuest:Quest, newQuest:Quest) : void
      {
         if (hasEventListener(QuestCollectionEvent.SELECTION_CHANGE))
         {
            dispatchEvent(new QuestCollectionEvent(
               QuestCollectionEvent.SELECTION_CHANGE,
               oldQuest, newQuest
            ));
         }
      }
      
      
      private function dispatchCountersUpdatedEvent() : void
      {
         if (hasEventListener(QuestCollectionEvent.COUNTERS_UPDATED))
         {
            dispatchEvent(new QuestCollectionEvent(
               QuestCollectionEvent.COUNTERS_UPDATED
            ));
         }
      }
      
      
      /* ############################ */
      /* ### ITEM EVENTS HANDLERS ### */
      /* ############################ */
      
      
      private function registerQuestEventHandlers(quest:Quest) : void
      {
         quest.addEventListener(
            QuestEvent.STATUS_CHANGE,
            quest_changeHandler, false, 1000
         );
      }
      
      
      private function removeQuestEventHandlers(quest:Quest) : void
      {
         quest.removeEventListener(QuestEvent.STATUS_CHANGE, quest_changeHandler);
      }
      
      
      private function quest_changeHandler(event:QuestEvent) : void
      {
         updateCounters();
      }
      
      
      /* ############################ */
      /* ### SELF EVENTS HANDLERS ### */
      /* ############################ */
      
      
      private function registerSelfEventHandlers() : void
      {
         addEventListener(
            CollectionEvent.COLLECTION_CHANGE,
            this_collectionChangeHandler, false, 1000
         );
      }
      
      private function this_collectionChangeHandler(event:CollectionEvent) : void
      {
         if (event.kind != CollectionEventKind.REFRESH)
         {
            updateCounters();
            refresh();
            updateSelectionAfterFilter();
            if (_selectedQuest != null)
               select(_selectedQuest.id);
         }
      }
   }
}