package models.quest
{
   import components.base.paging.MPageSwitcher;

   import flash.errors.IllegalOperationError;
   import flash.events.EventDispatcher;

   import models.quest.events.MMainQuestLineEvent;
   import models.quest.events.QuestCollectionEvent;
   import models.tips.MTipScreen;

   import utils.Events;
   import utils.Objects;
   import utils.SingletonFactory;


   [Event(
      name="currentPresentationChange",
      type="models.quest.events.MMainQuestLineEvent")]
   [Event(
      name="showButtonChange",
      type="models.quest.events.MMainQuestLineEvent")]

   public class MMainQuestLine extends EventDispatcher
   {
      public static function getInstance(): MMainQuestLine {
         return SingletonFactory.getSingletonInstance(MMainQuestLine);
      }

      private var _quests:QuestsCollection;
      public function setQuests(quests:QuestsCollection): void {
         Objects.paramNotNull("quests", quests);
         if (_quests != null) {
            _quests.removeEventListener(
               QuestCollectionEvent.COUNTERS_UPDATED,
               quests_countersUpdatedHandler, false
            );
         }
         _quests = quests;
         _quests.addEventListener(
            QuestCollectionEvent.COUNTERS_UPDATED,
            quests_countersUpdatedHandler, false, 0, true
         );
         setCurrentPresentation(null);
         dispatchMQLEvent(MMainQuestLineEvent.SHOW_BUTTON_CHANGE);
      }

      public function hasUncompletedMainQuest(): Boolean {
         return _quests != null ? _quests.hasUncompletedMainQuest : false;
      }

      public function openCurrentUncompletedQuest(): void {
         if (!hasUncompletedMainQuest()) {
            throw new IllegalOperationError(
               "There is no uncompleted main quest in the quests list"
            );
         }
         open(_quests.currentUncompletedMainQuest);
      }

      public function open(quest:Quest): void {
         MTipScreen.getInstance().close();
         Objects.paramNotNull("quest", quest);
         setCurrentPresentation(quest);
         _currentPresentation.firstPage();
         _currentPresentation.open();
      }

      public function close(): void {
         if (_currentPresentation != null) {
            _currentPresentation.close();
         }
      }

      private var _currentQuest:Quest;
      public function get currentQuest(): Quest {
         return _currentQuest;
      }

      private var _currentPresentation: MPageSwitcher;
      [Bindable(event="currentPresentationChange")]
      public function get currentPresentation(): MPageSwitcher {
         return _currentPresentation;
      }
      private function setCurrentPresentation(quest:Quest): void {
         if (_currentQuest != quest) {
            _currentQuest = quest;
            if (_currentPresentation != null) {
               _currentPresentation.close();
            }
            if (quest != null) {
               const factory: MainQuestPresentationFactory =
                        MainQuestPresentationFactory.getInstance();
               _currentPresentation = factory.getPresentation(quest);
            }
            else {
               _currentPresentation = null;
            }
            dispatchMQLEvent(MMainQuestLineEvent.CURRENT_PRESENTATION_CHANGE);
         }
      }

      private function quests_countersUpdatedHandler(event:QuestCollectionEvent): void {
         dispatchMQLEvent(MMainQuestLineEvent.SHOW_BUTTON_CHANGE);
      }

      [Bindable(event="showButtonChange")]
      public function get showButton(): Boolean {
         return hasUncompletedMainQuest();
      }


      /* ############### */
      /* ### HELPERS ### */
      /* ############### */

      private function dispatchMQLEvent(type:String): void {
         Events.dispatchSimpleEvent(this, MMainQuestLineEvent, type);
      }
   }
}
