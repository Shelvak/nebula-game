package tests.quests
{
   import components.base.paging.PageModelEvent;

   import ext.hamcrest.events.causes;
   import ext.hamcrest.object.definesProperties;
   import ext.hamcrest.object.metadata.withBindableTag;

   import models.quest.Quest;
   import models.quest.slides.MSlide;

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
         const slide: MSlide = new MSlide("A", new Quest());
         assertThat( "is not visible by default", slide.visible, isFalse() );
         assertThat(
            "changing visibility dispatches event",
            function():void{ slide.visible = true },
            causes (slide) .toDispatchEvent (PageModelEvent.VISIBLE_CHANGE)
         );
         assertThat( "should be visible", slide.visible, isTrue() );
      }

      [Test]
      public function loading(): void {
         const slide: MSlide = new MSlide("A", new Quest());
         assertThat(
            "should not be visible by default", slide.loading, isFalse()
         );
         assertThat(
            "changing loading property dispatches event",
            function():void{ slide.loading = true },
            causes (slide) .toDispatchEvent (PageModelEvent.LOADING_CHANGE)
         );
         assertThat( "should be loading", slide.loading, isTrue() );
      }

      [Test]
      public function metadata(): void {
         assertThat(
            MSlide, definesProperties({
               "visible": withBindableTag(PageModelEvent.VISIBLE_CHANGE),
               "loading": withBindableTag(PageModelEvent.LOADING_CHANGE)
            })
         );
      }
   }
}
