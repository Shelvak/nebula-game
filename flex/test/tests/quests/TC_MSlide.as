package tests.quests
{
   import ext.hamcrest.events.causes;

   import models.quest.slides.MSlide;
   import models.quest.Quest;
   import models.quest.events.MMainQuestSlideEvent;

   import org.flexunit.assertThat;
   import org.hamcrest.object.isFalse;
   import org.hamcrest.object.isTrue;

   import utils.SingletonFactory;


   public class TC_MSlide
   {
      [After]
      public function tearDown(): void {
         SingletonFactory.clearAllSingletonInstances();
      }

      [Test]
      public function visible(): void {
         const slide:MSlide = new MSlide("A", new Quest());
         assertThat( "is not visible by default", slide.visible, isFalse() );
         assertThat(
            "changing visibility dispatches event",
            function():void{ slide.visible = true },
            causes (slide) .toDispatchEvent (MMainQuestSlideEvent.VISIBLE_CHANGE)
         );
         assertThat( "visibility changed", slide.visible, isTrue() );
      }
   }
}
