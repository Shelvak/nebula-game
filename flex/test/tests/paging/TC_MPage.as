package tests.paging
{
   import components.base.paging.MPage;
   import components.base.paging.PageModelEvent;

   import ext.hamcrest.events.causes;
   import ext.hamcrest.object.definesProperties;
   import ext.hamcrest.object.metadata.withBindableTag;

   import org.hamcrest.assertThat;

   import org.hamcrest.object.isFalse;
   import org.hamcrest.object.isTrue;

   import utils.SingletonFactory;


   public class TC_MPage
   {
      [After]
      public function tearDown(): void {
         SingletonFactory.clearAllSingletonInstances();
      }

      [Test]
      public function visible(): void {
         const slide: MPage = new MPage();
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
         const page: MPage = new MPage();
         assertThat(
            "should not be visible by default", page.loading, isFalse()
         );
         assertThat(
            "changing loading property dispatches event",
            function():void{ page.loading = true },
            causes (page) .toDispatchEvent (PageModelEvent.LOADING_CHANGE)
         );
         assertThat( "should be loading", page.loading, isTrue() );
      }

      [Test]
      public function metadata(): void {
         assertThat(
            MPage, definesProperties({
               "visible": withBindableTag(PageModelEvent.VISIBLE_CHANGE),
               "loading": withBindableTag(PageModelEvent.LOADING_CHANGE)
            })
         );
      }
   }
}
