package tests.quests
{
   import ext.hamcrest.events.causes;
   import ext.hamcrest.events.event;
   import ext.hamcrest.object.equals;

   import models.quest.MMainQuestLine;
   import models.quest.MMainQuestPresentation;
   import models.quest.Quest;
   import models.quest.QuestsCollection;
   import models.quest.events.MMainQuestLineEvent;

   import org.flexunit.assertThat;
   import org.hamcrest.core.allOf;
   import org.hamcrest.core.not;
   import org.hamcrest.object.hasProperty;
   import org.hamcrest.object.isFalse;
   import org.hamcrest.object.isTrue;
   import org.hamcrest.object.notNullValue;
   import org.hamcrest.object.nullValue;
   import org.hamcrest.object.sameInstance;

   import utils.SingletonFactory;


   public class TC_MMainQuestLine
   {
      [After]
      public function tearDown(): void {
         SingletonFactory.clearAllSingletonInstances();
      }

      [Test]
      public function setQuests(): void {
         const mql:MMainQuestLine = new MMainQuestLine();
         mql.open(getQuest());
         assertThat(
            "setting quests dispatches events when MQL is open",
            function():void{ mql.setQuests(new QuestsCollection()) },
            causes (mql) .toDispatch (
               event (MMainQuestLineEvent.IS_OPEN_CHANGE),
               event (MMainQuestLineEvent.CURRENT_PRESENTATION_CHANGE),
               event (MMainQuestLineEvent.SHOW_BUTTON_CHANGE)
            )
         );
         assertThat( "MQL is closed", mql.isOpen, isFalse() );
         assertThat(
            "currentPresentation is nullified",
            mql.currentPresentation, nullValue()
         );
      }

      [Test]
      public function open(): void {
         const mql:MMainQuestLine = new MMainQuestLine();
         const quest:Quest = getQuest();
         var presentation:MMainQuestPresentation = null;
         assertThat(
            "events dispatched when MQL is opened",
            function():void{ mql.open(quest) },
            causes (mql) .toDispatch(
               event (MMainQuestLineEvent.CURRENT_PRESENTATION_CHANGE),
               event (MMainQuestLineEvent.IS_OPEN_CHANGE)
            )
         );
         assertThat( "is open", mql.isOpen, isTrue() );
         assertThat(
            "currentPresentation changed",
            mql.currentPresentation, notNullValue()
         );
         assertThat(
            "currentPresentation has first slide opened",
            mql.currentPresentation.currentSlide,
            allOf(
               notNullValue(),
               hasProperty("key", equals ("A"))
            )
         );
         
         presentation = mql.currentPresentation;
         assertThat(
            "events not dispatched if MQL is already open",
            function():void{ mql.open(quest) },
            allOf(
               not (causes (mql) .toDispatchEvent
                  (MMainQuestLineEvent.IS_OPEN_CHANGE)),
               not (causes (mql) .toDispatchEvent
                  (MMainQuestLineEvent.CURRENT_PRESENTATION_CHANGE))
            )
         );
         assertThat(
            "currentPresentation not changed",
            mql.currentPresentation, sameInstance (presentation)
         );
      }

      [Test]
      public function openTheSamePresentationAgainAfterClosing(): void {
         const mql:MMainQuestLine = new MMainQuestLine();
         const quest:Quest = getQuest();
         mql.open(quest);
         mql.currentPresentation.nextSlide();
         mql.close();
         mql.open(quest);
         assertThat(
            "first slide is shown",
            mql.currentPresentation.currentSlide.key, equals("A")
         );
      }

      [Test]
      public function close(): void {
         const mql:MMainQuestLine = new MMainQuestLine();
         mql.open(getQuest());
         const presentation:MMainQuestPresentation = mql.currentPresentation;
         assertThat(
            "IS_OPEN_CHANGE event is dispatched when MQL is closed",
            mql.close,
            allOf(
               causes (mql) .toDispatchEvent
                  (MMainQuestLineEvent.IS_OPEN_CHANGE),
               not (causes (mql) .toDispatchEvent
                  (MMainQuestLineEvent.CURRENT_PRESENTATION_CHANGE))
            )
         );
         assertThat( "is closed", mql.isOpen, isFalse() );
         assertThat(
            "currentPresentation not changed",
            mql.currentPresentation, sameInstance (presentation)
         );
         assertThat(
            "repeated close() invocations are ignored",
            mql.close,
            allOf(
               not (causes (mql) .toDispatchEvent
                  (MMainQuestLineEvent.IS_OPEN_CHANGE)),
               not (causes (mql) .toDispatchEvent
                  (MMainQuestLineEvent.CURRENT_PRESENTATION_CHANGE))
            )
         );
      }

      [Test]
      public function openCurrentUncompletedQuest(): void {
         const mql:MMainQuestLine = new MMainQuestLine();
         const quests:QuestsCollection = new QuestsCollection();
         const quest:Quest = getQuest();
         quests.addItem(quest);
         mql.setQuests(quests);
         
         mql.openCurrentUncompletedQuest();
         assertThat( "MQL is open", mql.isOpen, isTrue() );
         assertThat( "currentPresentation set", mql.currentPresentation, notNullValue() );
         assertThat(
            "currentQuest is uncompleted main quest from quests list",
            mql.currentQuest, sameInstance (quest)
         );
      }

      [Test]
      public function showButton(): void {
         const quests:QuestsCollection = new QuestsCollection();
         const mql:MMainQuestLine = new MMainQuestLine();
         mql.setQuests(quests);

         assertThat(
            "button not visible when there are no quests",
            mql.showButton, isFalse()
         );

         assertThat(
            "event is dispatched when main quest is added",
            function():void{ quests.addItem(getQuest()) },
            causes (mql) .toDispatchEvent (MMainQuestLineEvent.SHOW_BUTTON_CHANGE)
         );
         assertThat(
            "button visible when there is a main quest in the collection of quests",
            mql.showButton, isTrue()
         );

         assertThat(
            "event is dispatched when main quest is completed",
            function():void{ quests.getQuestAt(0).status = Quest.STATUS_COMPLETED },
            causes (mql) .toDispatchEvent (MMainQuestLineEvent.SHOW_BUTTON_CHANGE)
         );
         assertThat(
            "button not visible when all main quests have been completed",
            mql.showButton, isFalse()
         );
      }

      private function getQuest(slides:String = "A,B"): Quest {
         const quest:Quest = new Quest();
         quest.mainQuestSlides = slides;
         quest.status = Quest.STATUS_STARTED;
         return quest;
      }
   }
}
