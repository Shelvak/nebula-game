package tests.maps
{
   import components.base.viewport.IVisibleAreaTrackerClient;
   import components.base.viewport.VisibleAreaTracker;
   
   import ext.hamcrest.object.equals;
   
   import flash.geom.Rectangle;
   
   import org.hamcrest.assertThat;
   import org.hamcrest.collection.arrayWithSize;
   import org.hamcrest.collection.emptyArray;
   import org.hamcrest.collection.hasItem;
   import org.hamcrest.collection.hasItems;
   import org.hamcrest.object.hasProperties;
   import org.hamcrest.object.isTrue;
   import org.hamcrest.object.notNullValue;

   public class TC_VisibleAreaTracker
   {
      private var tracker:VisibleAreaTracker;
      private var client:MockClient;
      private var hiddenArea:Rectangle;
      
      /* ########################## */
      /* ### SET UP / TEAR DOWN ### */
      /* ########################## */
      
      [Before]
      public function setUp() : void {
         createTracker();
      }
      
      [After]
      public function tearDown() : void {
         client = null;
         tracker = null;
         hiddenArea = null;
      }
      
      
      /* ############# */
      /* ### TESTS ### */
      /* ############# */
      
      [Test]
      public function initialization() : void {
         contentInitialized(-10, -10, 200, 200, 1);
         assertThat( "client.visibleAreaChange called once", client.visibleAreaChangeCalls, equals (1) );
         var params:VisibleAreaChangeParams = client.visibleAreaChangeParams;
         assertThat(
            "visibleArea parameter passed to client.visibleAreaChange",
            params.visibleArea, notNullValue()
         );
         assertThat(
            "areasHidden parameter passed to client.visibleAreaChange",
            params.areasHidden, notNullValue()
         );
         assertThat(
            "areasShown parameter passed to client.visibleAreaChange",
            params.areasShown, notNullValue()
         );
         assertInitialAreaPositionAndSize(
            "content larger than viewport when not scaled",
            10, 10, 100, 100
         );
         
         contentInitialized(10, 10, 80, 80, 1);
         assertInitialAreaPositionAndSize(
            "content smaller than viewport when not scaled",
            0, 0, 80, 80
         );
         
         contentInitialized(-10, -10, 400, 400, 0.5);
         assertInitialAreaPositionAndSize(
            "content larger than viewport, when scaled",
            20, 20, 200, 200
         );
         
         contentInitialized(10, 10, 400, 400, 0.1);
         assertInitialAreaPositionAndSize(
            "content smaller than viewport, when scaled",
            0, 0, 400, 400
         );
         
         contentInitialized(10, 10, 100, 100, 1.0);
         assertInitialAreaPositionAndSize(
            "content same size as viewport, south-east clip, when not scaled",
            0, 0, 90, 90
         );
         
         contentInitialized(-10, -10, 100, 100, 1.0);
         assertInitialAreaPositionAndSize(
            "content same size as viewport, north-west clip, when not scaled",
            10, 10, 90, 90
         );
         
         contentInitialized(10, 10, 200, 200, 0.5);
         assertInitialAreaPositionAndSize(
            "content same size as viewport, south-east clip, when scaled",
            0, 0, 180, 180
         );
         
         contentInitialized(-10, -10, 200, 200, 0.5);
         assertInitialAreaPositionAndSize(
            "content same size as viewport, north-west clip, when scaled",
            20, 20, 180, 180
         );
         
         contentInitialized(200, 200, 100, 100, 1);
         assertThat(
            "client.visibleAreaChange not called if content is not visible",
            client.visibleAreaChangeCalls, equals (0)
         );
      }
      
      private function assertInitialAreaPositionAndSize(message:String,
                                                        x:int,
                                                        y:int,
                                                        width:int,
                                                        height:int) : void {
         var shownArea:Rectangle = client.visibleAreaChangeParams.areasShown[0];
         var visibleArea:Rectangle = client.visibleAreaChangeParams.visibleArea;
         assertThat( message + "; shownArea.x", shownArea.x, equals (x) );
         assertThat( message + "; shownArea.y", shownArea.y, equals (y) );
         assertThat( message + "; shownArea.width", shownArea.width, equals (width) );
         assertThat( message + "; shownArea.height", shownArea.height, equals (height) );
         assertThat(
            message + "; visibleArea is the same as shownArea",
            shownArea.equals(visibleArea), isTrue()
         );
      }
      
      // -----
      
      [Test]
      public function contentPositionUpdate_wholeContentInsideViewport() : void {
         var initialVisibleArea:Rectangle = new Rectangle(200, 200, 100, 100);
         var shownArea:Rectangle;
         
         shownArea = new Rectangle(50, 200, 100, 100);
         assertOneAxisAlignedShift( "full horizontal shift right", -50, -200,
            shownArea, shownArea, initialVisibleArea
         );
         
         shownArea = new Rectangle(350, 200, 100, 100);
         assertOneAxisAlignedShift( "full horizontal shift left", -350, -200,
            shownArea, shownArea, initialVisibleArea
         );
         
         assertOneAxisAlignedShift( "half horizontal shift right", -150, -200,
            new Rectangle(150, 200, 100, 100),
            new Rectangle(150, 200,  50, 100),
            new Rectangle(250, 200,  50, 100)
         );
         
         assertOneAxisAlignedShift( "half horizontal shift left", -250, -200,
            new Rectangle(250, 200, 100, 100),
            new Rectangle(300, 200,  50, 100),
            new Rectangle(200, 200,  50, 100)
         );
         
         shownArea = new Rectangle(200, 50, 100, 100);
         assertOneAxisAlignedShift( "full vertical shift down", -200, -50,
            shownArea, shownArea, initialVisibleArea
         );
         
         shownArea = new Rectangle(200, 350, 100, 100);
         assertOneAxisAlignedShift( "full vertical shift up", -200, -350,
            shownArea, shownArea, initialVisibleArea
         );
         
         assertOneAxisAlignedShift( "half vertical shift down", -200, -150,
            new Rectangle(200, 150, 100, 100),
            new Rectangle(200, 150, 100,  50),
            new Rectangle(200, 250, 100,  50)
         );
         
         assertOneAxisAlignedShift( "half vertical shift up", -200, -250,
            new Rectangle(200, 250, 100, 100),
            new Rectangle(200, 300, 100,  50),
            new Rectangle(200, 200, 100,  50)
         );
      }
      
      [Test]
      public function contentPositionUpdate_halfContentInsideViewport() : void {
         var initialVisibleArea:Rectangle = new Rectangle(200, 200, 100, 100);
         var shownArea:Rectangle;
         
         shownArea = new Rectangle(0, 200, 50, 100);
         assertOneAxisAlignedShift( "shift right", 50, -200, shownArea, shownArea, initialVisibleArea);
         
         shownArea = new Rectangle(450, 200, 50, 100);
         assertOneAxisAlignedShift( "shift left", -450, -200, shownArea, shownArea, initialVisibleArea);
         
         shownArea = new Rectangle(200, 0, 100, 50);
         assertOneAxisAlignedShift( "shift down", -200, 50, shownArea, shownArea, initialVisibleArea);
         
         shownArea = new Rectangle(200, 450, 100, 50);
         assertOneAxisAlignedShift( "shift up", -200, -450, shownArea, shownArea, initialVisibleArea);
      }
      
      private function assertOneAxisAlignedShift(message:String,
                                                 newContentX:int,
                                                 newContentY:int,
                                                 visibleAreaExpected:Rectangle,
                                                 shownAreaExpected:Rectangle,
                                                 hiddenAreaExpected:Rectangle) : void {
         contentInitialized(-200, -200, 500, 500, 1);
         client.clear();
         
         tracker.updateContentPosition(newContentX, newContentY);
         tracker.updateComplete();
         message += " (newContentX = " + newContentX + ", newContentY = " + newContentY + "): ";
         
         assertThat(
            message + "client.visibleAreaChange called once",
            client.visibleAreaChangeCalls, equals (1)
         );
         var params:VisibleAreaChangeParams = client.visibleAreaChangeParams;
         assertThat( "visible area changed", visibleAreaExpected.equals(params.visibleArea), isTrue() );
         assertThat( "one area shown", params.areasShown, arrayWithSize (1) );
         assertThat(
            message + "shown area",
            shownAreaExpected.equals(params.areasShown[0]), isTrue()
         );
         assertThat( "one area hidden", params.areasHidden, arrayWithSize (1) );
         assertThat(
            message + "hidden area",
            hiddenAreaExpected.equals(params.areasHidden[0]), isTrue()
         );
      }
      
      // -----
      
      [Test]
      public function viewportSizeIncrease() : void {
         contentInitialized(-100, -100, 300, 300, 1);
         client.clear();
         tracker.updateViewportSize(150, 150);
         tracker.updateComplete();
         
         var params:VisibleAreaChangeParams = client.visibleAreaChangeParams;
         assertThat(
            "visible area changed",
            new Rectangle(100, 100, 150, 150).equals(params.visibleArea), isTrue()
         );
         assertThat( "no areas hidden", params.areasHidden, emptyArray() );
         assertThat( "two areas shown", params.areasShown, arrayWithSize (2) );
         assertThat( "client.shownArea (vertical)",
            params.areasShown, hasItem (hasProperties ({
               "x": 200, "width": 50,
               "y": 100, "height": 150
            }))
         );
         assertThat( "client.shownArea (horizontal)",
            params.areasShown, hasItem (hasProperties ({
               "x": 100, "width": 100,
               "y": 200, "height": 50
            }))
         );
      }
      
      [Test]
      public function viewportSizeDecrease() : void {
         contentInitialized(-100, -100, 300, 300, 1);
         client.clear();
         tracker.updateViewportSize(50, 50);
         tracker.updateComplete();
         
         var params:VisibleAreaChangeParams = client.visibleAreaChangeParams;
         assertThat(
            "visible area changed",
            new Rectangle(100, 100, 50, 50).equals(params.visibleArea), isTrue()
         );
         assertThat( "no areas shown", params.areasShown, emptyArray() );
         assertThat( "two areas hidden", params.areasHidden, arrayWithSize (2) );
         assertThat( "client.hiddenArea (vertical)",
            params.areasHidden, hasItem (hasProperties ({
               "x": 150, "width": 50,
               "y": 100, "height": 100
            }))
         );
         assertThat( "client.hiddenArea (horizontal)",
            params.areasHidden, hasItem (hasProperties ({
               "x": 100, "width": 50,
               "y": 150, "height": 50
            }))
         );
      }
      
      // -----
      
      [Test]
      public function contentScaleDecrease_wholeViewportFilled() : void {
         contentInitialized(-100, -100, 400, 400, 1);
         client.clear();
         tracker.updateContentScale(0.8);
         tracker.updateComplete();
         
         var params:VisibleAreaChangeParams = client.visibleAreaChangeParams;
         assertThat(
            "visible area changed",
            new Rectangle(125, 125, 125, 125).equals(params.visibleArea), isTrue()
         );
         assertThat( "two areas hidden", params.areasHidden, arrayWithSize (2) );
         assertThat( "two areas shown", params.areasHidden, arrayWithSize (2) );
         assertThat( "client.hiddenArea (vertical)",
            params.areasHidden, hasItem( hasProperties ({
               "x": 100, "width": 25,
               "y": 100, "height": 100
            }))
         );
         assertThat( "client.hiddenArea (horizontal)",
            params.areasHidden, hasItems( hasProperties ({
               "x": 125, "width": 75,
               "y": 100, "height": 25
            }))
         );
         assertThat( "client.shownArea (vertical)",
            params.areasShown, hasItem( hasProperties ({
               "x": 200, "width": 50,
               "y": 125, "height": 125
            }))
         );
         assertThat( "client.shownArea (horizontal)",
            params.areasShown, hasItem( hasProperties ({
               "x": 125, "width": 75,
               "y": 200, "height": 50
            }))
         );
      }
      
      [Test]
      public function contentScaleIncrease_fromVoidAreaToCornerOfViewport() : void {
         contentInitialized(-100, -100, 200, 200, 0.5);
         client.clear();
         tracker.updateContentScale(0.8);
         tracker.updateComplete();
         
         var params:VisibleAreaChangeParams = client.visibleAreaChangeParams;
         assertThat( "no areas hidden", params.areasHidden, emptyArray() );
         assertThat( "one area shown", params.areasShown, arrayWithSize (1) );
         var shownArea:Rectangle = new Rectangle(125, 125, 75, 75);
         assertThat( "shownArea", shownArea.equals(params.areasShown[0]), isTrue() );
         assertThat( "visibleArea same as shownArea", shownArea.equals(params.visibleArea), isTrue() );
      }
      
      // -----
      
      [Test]
      public function zoomOutCenter() : void {
         contentInitialized(-200, -200, 500, 500, 1.0);
         client.clear();
         tracker.updateContentScale(0.5);
         tracker.updateContentPosition(-75, -75);
         tracker.updateComplete();
         
         var params:VisibleAreaChangeParams = client.visibleAreaChangeParams;
         assertThat(
            "visible area changed",
            new Rectangle(150, 150, 200, 200).equals(params.visibleArea), isTrue()
         );
         assertThat( "no areas hidden", params.areasHidden, emptyArray() );
         assertThat( "4 areas shown", params.areasShown, arrayWithSize (4) );
         assertThat( "client.shownArea (vertical, left)",
            params.areasShown, hasItem (hasProperties ({
               "x": 150, "width": 50,
               "y": 150, "height": 200
            }))
         );
         assertThat( "client.shownArea (vertical, right)",
            params.areasShown, hasItem (hasProperties ({
               "x": 300, "width": 50,
               "y": 150, "height": 200
            }))
         );
         assertThat( "client.shownArea (horizontal, top)",
            params.areasShown, hasItem( hasProperties ({
               "x": 200, "width": 100,
               "y": 150, "height": 50
            }))
         );
         assertThat( "client.shownArea (horizontal, top)",
            params.areasShown, hasItem( hasProperties ({
               "x": 200, "width": 100,
               "y": 300, "height": 50
            }))
         );
      }
      
      
      /* ############## */
      /* ## HELPERS ### */
      /* ############## */
      
      /**
       * viewportWidth: 100,
       * viewportHeight: 100
       */
      private function contentInitialized(contentX:int,
                                          contentY:int,
                                          contentWidth:int,
                                          contentHeight:int,
                                          contentScale:Number) : void {
         createTracker();
         tracker.contentInitialized(
            100, 100,
            contentX, contentY,
            contentWidth, contentHeight, contentScale
         );
      }
      
      private function createTracker() : VisibleAreaTracker {
         this.client = new MockClient();
         this.tracker = new VisibleAreaTracker(this.client);
         return this.tracker;
      }
   }
}


import components.base.viewport.IVisibleAreaTrackerClient;

import flash.geom.Rectangle;


class MockClient implements IVisibleAreaTrackerClient
{
   public var visibleAreaChangeCalls:int;
   public var visibleAreaChangeParams:VisibleAreaChangeParams;
   
   public function MockClient() {
      clear();
   }
   
   public function visibleAreaChange(visibleArea:Rectangle,
                                     areasHidden:Vector.<Rectangle>,
                                     areasShown:Vector.<Rectangle>) : void {
      visibleAreaChangeCalls++;
      visibleAreaChangeParams = new VisibleAreaChangeParams(
         visibleArea,
         areasHidden,
         areasShown
      );
   }
   
   public function clear() : void {
      visibleAreaChangeCalls = 0;
      visibleAreaChangeParams = null;
   }
}

class VisibleAreaChangeParams
{
   public var visibleArea:Rectangle;
   public var areasHidden:Vector.<Rectangle>;
   public var areasShown:Vector.<Rectangle>;
   
   public function VisibleAreaChangeParams(visibleArea:Rectangle,
                                           areasHidden:Vector.<Rectangle>,
                                           areasShown:Vector.<Rectangle>) {
      this.visibleArea = visibleArea;
      this.areasHidden = areasHidden;
      this.areasShown = areasShown;
   }
}