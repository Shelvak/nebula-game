package tests.viewport
{
   import components.base.viewport.IVisibleAreaTrackerClient;
   import components.base.viewport.VisibleAreaTracker;
   
   import ext.hamcrest.object.equals;
   
   import flash.geom.Rectangle;
   
   import org.hamcrest.assertThat;
   import org.hamcrest.collection.hasItem;
   import org.hamcrest.collection.hasItems;
   import org.hamcrest.object.hasProperties;
   import org.hamcrest.object.isTrue;

   public class TC_VisibleAreaTracker
   {
      private var tracker:VisibleAreaTracker;
      private var client:MockClient;
      private var shownArea:Rectangle;
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
         shownArea = null;
         hiddenArea = null;
      }
      
      
      /* ############# */
      /* ### TESTS ### */
      /* ############# */
      
      [Test]
      public function initialization() : void {
         contentInitialized(-10, -10, 200, 200, 1);
         assertThat( "client.areaHidden not called", client.areaHiddenCalls, equals (0) );
         assertThat( "client.areaShown should have been called once", client.areaShownCalls, equals (1) );
         assertThat( "area parameter passed to client.areaShown", client.areaShownParams.length, equals (1) );
         assertInitialAreaPositionAndSize("content larger than viewport when not scaled", 10, 10, 100, 100);
         
         contentInitialized(10, 10, 80, 80, 1);
         assertInitialAreaPositionAndSize("content smaller than viewport when not scaled", 0, 0, 80, 80);
         
         contentInitialized(-10, -10, 400, 400, 0.5);
         assertInitialAreaPositionAndSize("content larger than viewport, when scaled", 20, 20, 200, 200);
         
         contentInitialized(10, 10, 400, 400, 0.1);
         assertInitialAreaPositionAndSize("content smaller than viewport, when scaled", 0, 0, 400, 400);
         
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
            "client.areaShown not called if content is not visible",
            client.areaShownCalls, equals (0)
         );
         assertThat(
            "client.areaHidden not called if content is not visible",
            client.areaHiddenCalls, equals (0)
         );
      }
      
      private function assertInitialAreaPositionAndSize(message:String,
                                                        x:int,
                                                        y:int,
                                                        width:int,
                                                        height:int) : void {
         shownArea = client.areaShownParams[0];
         assertAreaPositionAndSize(message, x, y, width, height);
      }
      
      // -----
      
      [Test]
      public function contentPositionUpdate_wholeContentInsideViewport() : void {
         var initialVisibleArea:Rectangle = new Rectangle(200, 200, 100, 100);
         
         assertOneAxisAlignedShift("full horizontal shift right", -50, -200,
            new Rectangle(50, 200, 100, 100), initialVisibleArea
         );
         assertOneAxisAlignedShift( "full horizontal shift left", -350, -200,
            new Rectangle(350, 200, 100, 100), initialVisibleArea
         );
         assertOneAxisAlignedShift( "half horizontal shift right", -150, -200,
            new Rectangle(150, 200, 50, 100), new Rectangle(250, 200, 50, 100)
         );
         assertOneAxisAlignedShift( "half horizontal shift left", -250, -200,
            new Rectangle(300, 200, 50, 100), new Rectangle(200, 200, 50, 100)
         );
         
         assertOneAxisAlignedShift( "full vertical shift down", -200, -50,
            new Rectangle(200, 50, 100, 100), initialVisibleArea
         );
         assertOneAxisAlignedShift( "full vertical shift up", -200, -350,
            new Rectangle(200, 350, 100, 100), initialVisibleArea
         );
         assertOneAxisAlignedShift( "half vertical shift down", -200, -150,
            new Rectangle(200, 150, 100, 50), new Rectangle(200, 250, 100, 50)
         );
         assertOneAxisAlignedShift( "half vertical shift up", -200, -250,
            new Rectangle(200, 300, 100, 50), new Rectangle(200, 200, 100, 50)
         );
      }
      
      [Test]
      public function contentPositionUpdate_halfContentInsideViewport() : void {
         var initialVisibleArea:Rectangle = new Rectangle(200, 200, 100, 100);
         
         assertOneAxisAlignedShift( "shift right", 50, -200,
            new Rectangle(0, 200, 50, 100), initialVisibleArea
         );
         assertOneAxisAlignedShift( "shift left", -450, -200,
            new Rectangle(450, 200, 50, 100), initialVisibleArea
         );
         
         assertOneAxisAlignedShift( "shift down", -200, 50,
            new Rectangle(200, 0, 100, 50), initialVisibleArea
         );
         assertOneAxisAlignedShift( "shift up", -200, -450,
            new Rectangle(200, 450, 100, 50), initialVisibleArea
         );
      }
      
      private function assertOneAxisAlignedShift(message:String,
                                                 newContentX:int,
                                                 newContentY:int,
                                                 shownAreaExpected:Rectangle,
                                                 hiddenAreaExpected:Rectangle) : void {
         contentInitialized(-200, -200, 500, 500, 1);
         client.clear();
         
         tracker.updateContentPosition(newContentX, newContentY);
         tracker.updateComplete();
         message += " (newContentX = " + newContentX + ", newContentY = " + newContentY + "): ";
         
         assertThat( message + "client.areaShown called once", client.areaShownCalls, equals (1) );
         assertThat( message + "shownArea", shownAreaExpected.equals(client.areaShownParams[0]), isTrue() );
         assertThat( message + "client.areaHidden called once", client.areaHiddenCalls, equals (1) );
         assertThat( message + "hiddenArea", hiddenAreaExpected.equals(client.areaHiddenParams[0]), isTrue() );
      }
      
      // -----
      
      [Test]
      public function viewportSizeIncrease() : void {
         contentInitialized(-100, -100, 300, 300, 1);
         client.clear();
         tracker.updateViewportSize(150, 150);
         tracker.updateComplete();
         
         assertThat( "client.areaShown called twice", client.areaShownCalls, equals (2) );
         assertThat( "client.areaHidden not called", client.areaHiddenCalls, equals (0) );
         assertThat( "client.shownArea (vertical)",
            client.areaShownParams, hasItem (hasProperties ({
               "x": 200, "width": 50,
               "y": 100, "height": 150
            }))
         );
         assertThat( "client.shownArea (horizontal)",
            client.areaShownParams, hasItem (hasProperties ({
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
         
         assertThat( "client.areaShown not called", client.areaShownCalls, equals (0) );
         assertThat( "client.areaHidden called twice", client.areaHiddenCalls, equals (2) );
         assertThat( "client.hiddenArea (vertical)",
            client.areaHiddenParams, hasItem (hasProperties ({
               "x": 150, "width": 50,
               "y": 100, "height": 100
            }))
         );
         assertThat( "client.hiddenArea (horizontal)",
            client.areaHiddenParams, hasItem (hasProperties ({
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
         
         assertThat( "client.areaShown called twice", client.areaShownCalls, equals (2) );
         assertThat( "client.areaHidden called twice", client.areaHiddenCalls, equals (2) );
         assertThat( "client.hiddenArea (vertical)",
            client.areaHiddenParams, hasItem( hasProperties ({
               "x": 100, "width": 25,
               "y": 100, "height": 100
            }))
         );
         assertThat( "client.hiddenArea (horizontal)",
            client.areaHiddenParams, hasItems( hasProperties ({
               "x": 125, "width": 75,
               "y": 100, "height": 25
            }))
         );
         assertThat( "client.shownArea (vertical)",
            client.areaShownParams, hasItem( hasProperties ({
               "x": 200, "width": 50,
               "y": 125, "height": 125
            }))
         );
         assertThat( "client.shownArea (horizontal)",
            client.areaShownParams, hasItem( hasProperties ({
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
         
         assertThat( "client.areaShown called once", client.areaShownCalls, equals (1) );
         assertThat( "client.areaHidden not called", client.areaHiddenCalls, equals (0) );
         var expectedShownArea:Rectangle = new Rectangle(125, 125, 75, 75);
         assertThat( "client.shownArea", expectedShownArea.equals(client.areaShownParams[0]), isTrue() );
      }
      
      // -----
      
      [Test]
      public function zoomOutCenter() : void {
         contentInitialized(-200, -200, 500, 500, 1.0);
         client.clear();
         tracker.updateContentScale(0.5);
         tracker.updateContentPosition(-75, -75);
         tracker.updateComplete();
         
         assertThat( "client.areaShown called 4 times", client.areaShownCalls, equals (4) );
         assertThat( "client.areaHidden not called", client.areaHiddenCalls, equals (0) );
         assertThat( "client.shownArea (vertical, left)",
            client.areaShownParams, hasItem (hasProperties ({
               "x": 150, "width": 50,
               "y": 150, "height": 200
            }))
         );
         assertThat( "client.shownArea (vertical, right)",
            client.areaShownParams, hasItem (hasProperties ({
               "x": 300, "width": 50,
               "y": 150, "height": 200
            }))
         );
         assertThat( "client.shownArea (horizontal, top)",
            client.areaShownParams, hasItem( hasProperties ({
               "x": 200, "width": 100,
               "y": 150, "height": 50
            }))
         );
         assertThat( "client.shownArea (horizontal, top)",
            client.areaShownParams, hasItem( hasProperties ({
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
      
      private function assertAreaPositionAndSize(message:String,
                                                 x:int,
                                                 y:int,
                                                 width:int,
                                                 height:int) : void {
         assertThat( message + "; area.x", shownArea.x, equals (x) );
         assertThat( message + "; area.y", shownArea.y, equals (y) );
         assertThat( message + "; area.width", shownArea.width, equals (width) );
         assertThat( message + "; area.height", shownArea.height, equals (height) );         
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
   public var areaHiddenParams:Vector.<Rectangle> = new Vector.<Rectangle>();
   public var areaHiddenCalls:int = 0;
   
   public function areaHidden(area:Rectangle) : void {
      areaHiddenCalls++;
      areaHiddenParams.push(area);
   }
   
   public var areaShownParams:Vector.<Rectangle> = new Vector.<Rectangle>();
   public var areaShownCalls:int = 0;
   
   public function areaShown(area:Rectangle) : void {
      areaShownCalls++;
      areaShownParams.push(area);
   }
   
   public function clear() : void {
      areaHiddenCalls = 0;
      areaHiddenParams.splice(0, areaHiddenParams.length);
      areaShownCalls = 0;
      areaShownParams.splice(0, areaShownParams.length);
   }
}