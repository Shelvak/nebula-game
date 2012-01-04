package tests.quests
{
   import ext.hamcrest.events.causes;
   import ext.hamcrest.object.equals;

   import models.quest.MMainQuestPresentation;
   import models.quest.slides.MSlide;
   import models.quest.Quest;
   import models.quest.events.MMainQuestPresentationEvent;

   import org.flexunit.assertThat;
   import org.hamcrest.object.isFalse;
   import org.hamcrest.object.isTrue;

   import utils.SingletonFactory;


   public class TC_MMainQuestPresentation
   {
      private var presentation:MMainQuestPresentation;

      [Before]
      public function setUp(): void {
         presentation = new MMainQuestPresentation(getQuest());
      }

      [After]
      public function tearDown(): void {
         presentation = null;
         SingletonFactory.clearAllSingletonInstances();
      }

      [Test]
      public function initialization(): void {
         assertThat(
            "first slide is the currentSlide",
            presentation.currentSlide.key, equals("A")
         );
         assertThat(
            "can switch to next slide",
            presentation.hasNextSlide, isTrue()
         );
         assertThat(
            "can't switch to previous slide",
            presentation.hasPreviousSlide, isFalse()
         );
      }

      [Test]
      public function slidesNavigation(): void {
         assertThat(
            "has next slide when currentSlide is the first",
            presentation.hasNextSlide, isTrue()
         );
         assertThat(
            "does not have previous slide when currentSlide is the first",
            presentation.hasPreviousSlide, isFalse()
         );
         
         assertThat(
            "event is dispatched when next slide is switched",
            presentation.nextSlide,
            causes (presentation) .toDispatchEvent(
               MMainQuestPresentationEvent.CURRENT_SLIDE_CHANGE
            )
         );
         assertThat(
            "switched to next slide",
            presentation.currentSlide.key, equals ("B")
         );
         assertThat(
            "has next slide when current slide is in the middle",
            presentation.hasNextSlide, isTrue()
         );
         assertThat(
            "has previous slide when current slide is in the middle",
            presentation.hasPreviousSlide, isTrue()
         );

         presentation.nextSlide();
         assertThat(
            "switched to next slide",
            presentation.currentSlide.key, equals ("C")
         );
         assertThat(
            "does not have next slide when current slide is the last",
            presentation.hasNextSlide, isFalse()
         );
         assertThat(
            "has previous slide when current slide is in the last",
            presentation.hasPreviousSlide, isTrue()
         );

         assertThat(
            "event is dispatched when previous slide is switched",
            presentation.previousSlide,
            causes (presentation) .toDispatchEvent(
               MMainQuestPresentationEvent.CURRENT_SLIDE_CHANGE
            )
         );
         assertThat(
            "switched to previous slide",
            presentation.currentSlide.key, equals ("B")
         );

         assertThat(
            "event is dispatched when first slide is switched",
            presentation.firstSlide,
            causes (presentation) .toDispatchEvent(
               MMainQuestPresentationEvent.CURRENT_SLIDE_CHANGE
            )
         );
         assertThat(
            "switched to first slide",
            presentation.currentSlide.key, equals ("A")
         );
      }

      [Test]
      public function navigatingSlidesChangesTheirVisibility(): void {
         var slide:MSlide = presentation.currentSlide;
         assertThat(
            "when presentation is created the first slide is visible",
            slide.visible, isTrue()
         );
         
         presentation.nextSlide();
         assertThat(
            "when switching to next slide, previous current invisible",
            slide.visible, isFalse()
         );
         slide = presentation.currentSlide;
         assertThat(
            "when switching to next slide, that slide becomes visible",
            slide.visible, isTrue()
         );

         presentation.previousSlide();
         assertThat(
            "when switching to previous slide, current becomes invisible",
            slide.visible, isFalse()
         );
         slide = presentation.currentSlide;
         assertThat(
            "when switching to previous slide, that slide becomes visible",
            slide.visible, isTrue()
         );
      }

      private function getQuest(slides:String = "A,B,C"): Quest {
         const quest:Quest = new Quest();
         quest.status = Quest.STATUS_STARTED;
         quest.mainQuestSlides = slides;
         return quest;
      }
   }
}
