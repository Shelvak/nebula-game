package models.quest
{
   import flash.errors.IllegalOperationError;
   import flash.events.EventDispatcher;

   import models.quest.events.MMainQuestLineEvent;
   import models.quest.events.QuestCollectionEvent;

   import utils.Events;
   import utils.Objects;
   import utils.SingletonFactory;


   [Event(
      name="currentPresentationChange",
      type="models.quest.events.MMainQuestLineEvent")]
   [Event(
      name="showButtonChange",
      type="models.quest.events.MMainQuestLineEvent")]
   [Event(
      name="isOpenChange",
      type="models.quest.events.MMainQuestLineEvent")]

   public class MMainQuestLine extends EventDispatcher
   {
      public static function getInstance(): MMainQuestLine {
         return SingletonFactory.getSingletonInstance(MMainQuestLine);
      }

      private var _quests:QuestsCollection;
      public function setQuests(quests:QuestsCollection): void {
         Objects.paramNotNull("quests", quests)
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
         close();
         dispatchMQLEvent(MMainQuestLineEvent.SHOW_BUTTON_CHANGE);
      }

      public function openCurrentUncompletedQuest(): void {
         if (!_quests.hasUncompletedMainQuest) {
            throw new IllegalOperationError(
               "There is no uncompleted main quest in the quests list"
            );
         }
         open(_quests.currentUncompletedMainQuest);
      }

      public function open(quest:Quest): void {
         Objects.paramNotNull("quest", quest);
         setCurrentPresentation(quest);
         setIsOpen(true);
         _currentPresentation.firstSlide();
      }

      public function close(): void {
         setIsOpen(false);
      }

      private var _currentQuest:Quest;
      public function get currentQuest(): Quest {
         return _currentQuest;
      }
      private var _currentPresentation:MMainQuestPresentation;
      [Bindable(event="currentPresentationChange")]
      public function get currentPresentation(): MMainQuestPresentation {
         return _currentPresentation;
      }
      private function setCurrentPresentation(quest:Quest): void {
         if (_currentQuest != quest) {
            _currentQuest = quest;
            if (quest != null) {
               _currentPresentation = new MMainQuestPresentation(quest);
               _currentPresentation.firstSlide();
            }
            else {
               _currentPresentation = null;
            }
            dispatchMQLEvent(MMainQuestLineEvent.CURRENT_PRESENTATION_CHANGE);
         }
      }

      private var _isOpen:Boolean = false;
      [Bindable(event="isOpenChange")]
      public function get isOpen(): Boolean {
         return _isOpen;
      }
      private function setIsOpen(value:Boolean) : void {
         if (_isOpen != value) {
            _isOpen = value;
            dispatchMQLEvent(MMainQuestLineEvent.IS_OPEN_CHANGE);
         }
      }

      private function quests_countersUpdatedHandler(event:QuestCollectionEvent): void {
         dispatchMQLEvent(MMainQuestLineEvent.SHOW_BUTTON_CHANGE);
      }

      [Bindable(event="showButtonChange")]
      public function get showButton(): Boolean {
         return _quests.hasUncompletedMainQuest;
      }


      /* ############### */
      /* ### HELPERS ### */
      /* ############### */

      private function dispatchMQLEvent(type:String): void {
         Events.dispatchSimpleEvent(this, MMainQuestLineEvent, type);
      }
   }
}
