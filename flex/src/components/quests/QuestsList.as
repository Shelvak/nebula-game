package components.quests
{
   import models.ModelLocator;
   import models.quest.Quest;
   import models.quest.QuestsCollection;
   import models.quest.events.QuestCollectionEvent;
   import models.quest.events.QuestEvent;
   
   import mx.collections.IList;
   import mx.core.ClassFactory;
   import mx.events.FlexEvent;
   
   import spark.components.List;
   import spark.layouts.HorizontalAlign;
   import spark.layouts.VerticalLayout;
   
   /**
    * @eventType models.quest.events.QuestEvent.SCROLL_REQUESTED
    */
   [Event(name="scrollRequested", type="models.quest.events.QuestEvent")]
   /**
    * List specializes in displaying quests.
    */
   public class QuestsList extends List
   {
      public function QuestsList()
      {
         super();
         itemRenderer = new ClassFactory(IRQuest);
         dataProvider = ModelLocator.getInstance().quests;
         var layout:VerticalLayout = new VerticalLayout();
         layout.horizontalAlign = HorizontalAlign.JUSTIFY;
         layout.variableRowHeight = true;
         layout.gap = 0;
         this.layout = layout;
         addSelfEventHandlers();
      }
      
      
      /* ################## */
      /* ### PROPERTIES ### */
      /* ################## */
      
      
      private var _oldQuests:QuestsCollection = null;
      public override function set dataProvider(value:IList):void
      {
         if (super.dataProvider != value)
         {
            if (!_oldQuests)
            {
               _oldQuests = quests;
            }
            super.dataProvider = value;
            _fDataProviderChanged = true;
         }
      }
      
      
      private var _fDataProviderChanged:Boolean = true;
      protected override function commitProperties() : void
      {
         super.commitProperties();
         
         if (_fDataProviderChanged)
         {
            if (_oldQuests)
            {
               removeQuestsEventHandlers(_oldQuests);
            }
            if (quests)
            {
               addQuestsEventHandlers(quests);
            }
         }
         
         _fDataProviderChanged = false;
      }
      
      
      /* ############### */
      /* ### HELPERS ### */
      /* ############### */
      
      
      protected override function itemSelected(index:int, selected:Boolean):void
      {
         super.itemSelected(index, selected);
         if (selected)
         {
            selectQuest(quests.getQuestAt(index));
         }
      }
      
      
      private function get quests() : QuestsCollection
      {
         return dataProvider as QuestsCollection;
      }
      
      
      private function selectQuest(quest:Quest) : void
      {
         selectedItem = quest;
         if (quest != null && quests.getItemIndex(quest) != -1)
         {
            quests.select(quest.id);
            try
            {
               dispatchEvent(new QuestEvent(QuestEvent.SCROLL_REQUESTED, quests.getItemIndex(quest)));
            }
            catch (err: Error)
            {
               throw new Error("index "+quests.getItemIndex(quest)+" was not found in list " + err);
            }
         }
         else
         {
            quests.deselect();
         }
         if (selectedItem != null)
         {
            selectedItem.dispatchEvent(new QuestEvent(QuestEvent.REFRESH_REQUESTED));
         }
      }
      
      
      /* ###################### */
      /* ### EVENT HANDLERS ### */
      /* ###################### */
      
      
      private function addSelfEventHandlers() : void
      {
         addEventListener(FlexEvent.CREATION_COMPLETE, this_creationCompleteHandler);
         addEventListener(FlexEvent.UPDATE_COMPLETE, this_updateCompleteHandler);
      }
      
      
      private function addQuestsEventHandlers(quests:QuestsCollection) : void
      {
         quests.addEventListener(QuestCollectionEvent.SELECTION_CHANGE, quests_selectionChangeHandler);
      }
      
      
      private function removeQuestsEventHandlers(quests:QuestsCollection) : void
      {
         quests.removeEventListener(QuestCollectionEvent.SELECTION_CHANGE, quests_selectionChangeHandler);
      }
      
      
      private function this_creationCompleteHandler(event:FlexEvent) : void
      {
         if (quests.selectedQuest)
         {
            selectQuest(quests.selectedQuest);
         }
         else
         {
            selectQuest(Quest(quests.getItemAt(0)));
         }
      }
      
      
      private function this_updateCompleteHandler(event:FlexEvent) : void
      {
         quests.dispatchEvent(new QuestCollectionEvent(QuestCollectionEvent.UPDATE_COMPLETED));
      }
      
      
      private function quests_selectionChangeHandler(event:QuestCollectionEvent) : void
      {
         if (selectedItem !== event.newQuest)
         {
            selectQuest(event.newQuest);
         }
      }
   }
}