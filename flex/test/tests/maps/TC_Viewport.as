package tests.maps
{
   import components.base.skins.ViewportSkin;
   import components.base.viewport.VisibleAreaTracker;
   
   import ext.hamcrest.object.equals;
   
   import flash.geom.Point;
   
   import mx.events.FlexEvent;
   
   import org.flexunit.assertThat;
   import org.fluint.uiImpersonation.UIImpersonator;
   import org.hamcrest.Matcher;
   import org.hamcrest.collection.array;
   import org.hamcrest.collection.arrayWithSize;
   import org.hamcrest.collection.emptyArray;
   import org.hamcrest.collection.hasItems;
   import org.hamcrest.object.hasProperties;
   
   import spark.components.Group;

   public class TC_Viewport
   {
      include "../asyncSequenceHelpers.as";
      
      private var trackerClient:VisibleAreaTrackerClientMock;
      private var viewport:ViewportImpl;
      private var uiContent:Group;
      
      [Before]
      public function setUp() : void {
         runner = new SequenceRunner(this);
      }
      
      [After]
      public function tearDown() : void {
         UIImpersonator.removeChild(uiContent);
         trackerClient = null;
         viewport = null;
         uiContent = null;
         runner = null;
      }
      
      private static const oneTime:int = 1;
      
      
      /* ############# */
      /* ### TESTS ### */
      /* ############# */
      
      [Test(async, ui)]
      public function initializingViewportWithContent() : void {
         initViewportWithContent(100, 100, 300, 300, 1);
         makeAssertions(function() : void {
            var params:VisibleAreaChangeParams = trackerClient.visibleAreaChangeParams;
            assertVisibleAreaChangeCalledOnce();
            assertThat(
               "trackerClient.visibleArea",
               params.visibleArea, definesArea (100, 100, 100, 100)
            );
         });
         runSequence();
      }
      
      [Test(async, ui)]
      public function moveContentInstantly() : void {
         initViewportWithContent(100, 100, 300, 300, 1);
         call(function() : void {
            trackerClient.clear();
            viewport.moveContentBy(new Point(50, 0));
         });
         waitForViewportUpdate();
         makeAssertions(function() : void {
            var params:VisibleAreaChangeParams = trackerClient.visibleAreaChangeParams;
            assertVisibleAreaChangeCalledOnce()
            assertThat(
               "visible area",
               params.visibleArea, definesArea (50, 100, 100, 100)
            );
            assertThat(
               "one area hidden",
               params.areasHidden, array (definesArea (150, 100, 50, 100))
            );
            assertThat(
               "one area shown",
               params.areasShown, array (definesArea (50, 100, 50, 100))
            );
         });
         runSequence();
      }
      
      [Test(async, ui)]
      public function resizeViewportOnce() : void {
         initViewportWithContent(100, 100, 300, 300, 1);
         call(function() : void {
            trackerClient.clear();
            viewport.width = 150;
            viewport.height = 150;
         });
         waitForViewportUpdate();
         makeAssertions(function() : void {
            var params:VisibleAreaChangeParams = trackerClient.visibleAreaChangeParams;
            assertVisibleAreaChangeCalledOnce();
            assertThat(
               "visible area",
               params.visibleArea, definesArea (100, 100, 150, 150)
            );
            assertThat( "no areas hidden", params.areasHidden, emptyArray () );
            assertThat( "2 areas shown", params.areasShown, hasItems(
               definesArea(200, 100,  50, 150),
               definesArea(100, 200, 100,  50)
            ));
         });
         runSequence();
      }
      
      [Test(async, ui)]
      public function scaleContentOnce() : void {
         initViewportWithContent(100, 100, 300, 300, 1);
         call(function() : void {
            trackerClient.clear();
            viewport.content.scaleX = 0.8;
            viewport.content.scaleY = 0.8;
         });
         waitForViewportUpdate();
         makeAssertions(function() : void {
            var params:VisibleAreaChangeParams = trackerClient.visibleAreaChangeParams;
            assertVisibleAreaChangeCalledOnce();
            assertThat(
               "visible area",
               params.visibleArea, definesArea (125, 125, 125, 125)
            );
            assertThat( "2 areas hidden", params.areasHidden, arrayWithSize (2) );
            assertThat( "2 areas shown", params.areasShown, arrayWithSize (2) );
         });
         runSequence();
      }
      
      [Test(async, ui)]
      public function moveAndScaleContentAndResizeViewportSimultaneously() : void {
         initViewportWithContent(100, 100, 300, 300, 1);
         call(function() : void {
            trackerClient.clear();
            viewport.content.scaleX = 0.8;
            viewport.content.scaleY = 0.8;
            viewport.width = 120;
            viewport.height = 120;
            viewport.moveContentBy(new Point(25, 25));
         });
         waitForViewportUpdate();
         makeAssertions(function() : void {
            assertVisibleAreaChangeCalledOnce();
            var params:VisibleAreaChangeParams = trackerClient.visibleAreaChangeParams;
            assertThat(
               "visible area",
               params.visibleArea, definesArea (100, 100, 150, 150)
            );
            assertThat( "no areas hidden", params.areasHidden, emptyArray() );
            assertThat( "2 areas shown", params.areasShown, arrayWithSize (2) );
         });
         runSequence();
      }
      
      
      /* ############### */
      /* ### HELPERS ### */
      /* ############### */
      
      private function initViewportWithContent(viewportWidth:int,
                                               viewportHeight:int,
                                               contentWidth:int,
                                               contentHeight:int,
                                               contentScale:int, 
                                               paddingHorizontal:int = 0,
                                               paddingVertical:int = 0) : void {
         var content:Group = new Group();
         content.width = contentWidth;
         content.height = contentHeight;
         content.scaleX = contentScale;
         content.scaleY = contentScale;
         initViewport(
            viewportWidth,
            viewportHeight,
            paddingHorizontal,
            paddingVertical,
            content
         );
      }
      
      private function initViewport(viewportWidth:int,
                                    viewportHeight:int,
                                    paddingHorizontal:int,
                                    paddingVertical:int,
                                    content:Group) : void {
         trackerClient = new VisibleAreaTrackerClientMock();
         viewport = new ViewportImpl(new VisibleAreaTracker(trackerClient));
         viewport.setStyle("skinClass", ViewportSkin);
         viewport.x = 0;
         viewport.y = 0;
         viewport.width = viewportWidth;
         viewport.height = viewportHeight;
         viewport.paddingHorizontal = paddingHorizontal;
         viewport.paddingVertical = paddingVertical;
         viewport.content = content;
         uiContent = new Group();
         uiContent.addElement(viewport);
         call(function() : void {
            UIImpersonator.addChild(uiContent)
         });
         waitForViewportUpdate();
      }
      
      private function assertVisibleAreaChangeCalledOnce() : void {
         assertThat(
            "visibleAreaChange() called once",
            trackerClient.visibleAreaChangeCalls, equals (1)
         );
      }
      
      private function definesArea(x:int, y:int, width:int, height:int) : Matcher {
         return hasProperties({"x": x, "y": y, "width": width, "height": height});
      }
      
      private function makeAssertions(assertionsFunction:Function) : void {
         call(assertionsFunction);
      }
      
      private function waitForViewportUpdate() : void {
         waitFor(viewport, FlexEvent.UPDATE_COMPLETE, 200);
      }
   }
}


import components.base.viewport.Viewport;
import components.base.viewport.VisibleAreaTracker;

import spark.components.Scroller;


class ViewportImpl extends Viewport
{
   public function ViewportImpl(visibleAreaTracker:VisibleAreaTracker = null) {
      super(visibleAreaTracker);
   }
   
   protected override function createScroller() : Scroller {
      return null;
   }
}