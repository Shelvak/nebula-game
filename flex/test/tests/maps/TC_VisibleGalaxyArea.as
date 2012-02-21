package tests.maps
{
   import components.map.space.GalaxyMapCoordsTransform;
   import models.galaxy.IVisibleGalaxyAreaClient;
   
   import ext.hamcrest.object.equals;
   
   import flash.geom.Rectangle;
   
   import models.galaxy.Galaxy;
   import models.galaxy.VisibleGalaxyArea;
   import models.map.MapArea;
   import models.solarsystem.MSolarSystem;
   
   import mx.collections.ArrayCollection;
   
   import org.hamcrest.Matcher;
   import org.hamcrest.assertThat;
   import org.hamcrest.collection.arrayWithSize;
   import org.hamcrest.collection.hasItems;
   import org.hamcrest.object.hasProperties;
   import org.hamcrest.object.notNullValue;
   import org.hamcrest.object.nullValue;

   public class TC_VisibleGalaxyArea
   {
      private static function get SECTOR_W() : int {
         return GalaxyMapCoordsTransform.SECTOR_WIDTH;
      }
      
      private static function get SECTOR_H() : int {
         return GalaxyMapCoordsTransform.SECTOR_HEIGHT;
      }
      
      private var galaxy:Galaxy;
      private var area:VisibleGalaxyArea;
      private var client:ClientMock;
      
      [Before]
      public function setUp() : void {
      }
      
      [After]
      public function tearDown() : void {
         galaxy = null;
         area = null;
         client = null;
      }
      
      
      /* ############# */
      /* ### TESTS ### */
      /* ############# */
      
      [Test]
      public function initialization() : void {
         galaxy = new Galaxy();
         client = new ClientMock();
         area = new VisibleGalaxyArea(galaxy, client, new GalaxyMapCoordsTransform(galaxy));
         assertThat( "visibleArea", area.visibleArea, nullValue() );
      }
      
      [Test]
      public function firstCallToVisibleAreaChange() : void {
         init(new MapArea(0, 1, -1, 0));
         var shownArea:Rectangle = new Rectangle(
            0, 0,
            galaxy.bounds.width * SECTOR_W,
            galaxy.bounds.height * SECTOR_H
         );
         area.visibleAreaChange(
            shownArea,
            areaVector(),
            areaVector([shownArea])
         );
         
         assertThat( "visibleArea exists", area.visibleArea, notNullValue() );
         assertThat(
            "visibleArea covers whole visible map",
            area.visibleArea, equals (new MapArea(0, 1, -1, 0))
         );
         assertThat( "sectorHidden not called", client.sectorHiddenCalls, equals (0) );
         assertThat( "sectorShown called 4 times", client.sectorShownCalls, equals (4) );
         assertThat( "shown sectors", client.sectorShownParams, hasItems(
            definesPoint (0,  0),
            definesPoint (0, -1),
            definesPoint (1,  0),
            definesPoint (1, -1)
         ));
      }

      [Test]
      public function visibleAreaCompletelyLeavesVisibleGalaxyArea(): void {
         init(new MapArea(0, 1, -1, 0));
         const initialVisibleArea:Rectangle = new Rectangle(
            2 * SECTOR_W, 2 * SECTOR_H,
            2 * SECTOR_W, 2 * SECTOR_H
         );
         area.visibleAreaChange(
            initialVisibleArea,
            areaVector(),
            areaVector([initialVisibleArea])
         );
         client.clear();

         area.visibleAreaChange(
            new Rectangle(-1000, -1000, 20, 20),
            areaVector([initialVisibleArea]),
            areaVector()
         );

         assertThat( "visibleArea does not exist", area.visibleArea, nullValue() );
         assertThat( "sectorShown not called", client.sectorShownCalls, equals(0) );
         assertThat( "sectorHidden called 4 times", client.sectorHiddenCalls, equals (4) );
         assertThat( "hidden sectors", client.sectorHiddenParams, hasItems(
            definesPoint (0,  0),
            definesPoint (0, -1),
            definesPoint (1,  0),
            definesPoint (1, -1)
         ));
      }
      
      [Test]
      public function completeVisibleAreaChange() : void {
         init(new MapArea(0, 3, -1, 0));
         var initialVisibleArea:Rectangle = new Rectangle(
            2 * SECTOR_W, 2 * SECTOR_H,
            2 * SECTOR_W, 2 * SECTOR_H
         );
         area.visibleAreaChange(
            initialVisibleArea,
            areaVector(),
            areaVector([initialVisibleArea])
         );
         client.clear();
         
         area.visibleAreaChange(
            new Rectangle(),
            areaVector([initialVisibleArea]),
            areaVector()
         );
         assertThat( "visibleArea does not exist", area.visibleArea, nullValue() );
         assertThat( "sectorHidden called 4 times", client.sectorHiddenCalls, equals (4) );
         assertThat( "hidden sectors", client.sectorHiddenParams, hasItems(
            definesPoint (0,  0),
            definesPoint (0, -1),
            definesPoint (1,  0),
            definesPoint (1, -1)
         ));
         
         var shownArea:Rectangle = new Rectangle(
            4 * SECTOR_W, 3 * SECTOR_H,
            2 * SECTOR_W, 2 * SECTOR_H
         );
         area.visibleAreaChange(
            shownArea,
            areaVector(),
            areaVector([shownArea])
         );
         assertThat(
            "visibleArea covers south-east quarter of whole map",
            area.visibleArea, equals (new MapArea(2, 3, -1, -1))
         );
         assertThat( "sectorShown called 2 times", client.sectorShownCalls, equals (2) );
         assertThat( "shown sectors", client.sectorShownParams, hasItems(
            definesPoint (2, -1),
            definesPoint (3, -1)
         ));
      }
      
      [Test]
      public function expansionOfVisibleArea() : void {
         init(new MapArea(0, 3, -1, 0));
         var initialVisibleArea:Rectangle = new Rectangle(
            2 * SECTOR_W, 2 * SECTOR_H,
            2 * SECTOR_W, 2 * SECTOR_H
         );
         area.visibleAreaChange(
            initialVisibleArea,
            areaVector(),
            areaVector([initialVisibleArea])
         );
         client.clear();
         
         area.visibleAreaChange(
            new Rectangle(
               2 * SECTOR_W, 2 * SECTOR_H,
               3 * SECTOR_W, 2 * SECTOR_H
            ),
            areaVector(),
            areaVector([new Rectangle(
               4 * SECTOR_W, 2 * SECTOR_H,
               1 * SECTOR_W, 2 * SECTOR_H
            )])
         );
         assertThat(
            "visibleArea covers 3 left-most sector columns",
            area.visibleArea, equals (new MapArea(0, 2, -1, 0))
         );
         assertThat( "no sectors hidden", client.sectorHiddenCalls, equals (0) );
         assertThat( "2 sectors shown", client.sectorShownCalls, equals (2) );
         assertThat( "shown sectors", client.sectorShownParams, hasItems(
            definesPoint (2, -1),
            definesPoint (2,  0)
         ));
      }
      
      [Test]
      public function shrinkOfVisibleArea() : void {
         init(new MapArea(0, 2, -1, 0));
         var initialVisibleArea:Rectangle = new Rectangle(
            2 * SECTOR_W, 2 * SECTOR_H,
            3 * SECTOR_W, 2 * SECTOR_H
         );
         area.visibleAreaChange(initialVisibleArea, areaVector(), areaVector([initialVisibleArea]));
         client.clear();
         
         area.visibleAreaChange(
            new Rectangle(
               2 * SECTOR_W, 2 * SECTOR_H,
               2 * SECTOR_W, 2 * SECTOR_H
            ),
            areaVector([new Rectangle(
               4 * SECTOR_W, 2 * SECTOR_H,
               1 * SECTOR_W, 2 * SECTOR_H
            )]),
            areaVector()
         );
         assertThat(
            "visibleArea covers 2 left-most sector columns",
            area.visibleArea, equals (new MapArea(0, 1, -1, 0))
         );
         assertThat( "no sectors shown", client.sectorShownCalls, equals (0) );
         assertThat( "2 sectors hidden", client.sectorHiddenCalls, equals (2) );
         assertThat( "hidden sectors", client.sectorHiddenParams, hasItems(
            definesPoint (2, -1),
            definesPoint (2,  0)
         ));
      }
      
      // -----
      
      [Test]
      public function hideAllButOnePixelOfSectorColumnOnLeft() : void {
         init2x2MapAreaWholeVisibleInViewport();
         
         area.visibleAreaChange(
            new Rectangle(
               3 * SECTOR_W - 1, 2 * SECTOR_H,
               1 * SECTOR_W + 1, 2 * SECTOR_H
            ),
            areaVector([new Rectangle(
               2 * SECTOR_W,     2 * SECTOR_H,
               1 * SECTOR_W - 1, 2 * SECTOR_H
            )]),
            areaVector()
         );
         assertVisibleAreaIs2x2MapArea();
         assertNoHiddenAndShownSectors();
      }
      
      [Test]
      public function hideAllButOnePixelOfSectorColumnOnRight() : void {
         init2x2MapAreaWholeVisibleInViewport();
         
         area.visibleAreaChange(
            new Rectangle(
               2 * SECTOR_W,     2 * SECTOR_H,
               1 * SECTOR_W + 1, 2 * SECTOR_H
            ),
            areaVector([new Rectangle(
               3 * SECTOR_W + 1, 2 * SECTOR_H,
               1 * SECTOR_W - 1, 2 * SECTOR_H
            )]),
            areaVector()
         );
         assertVisibleAreaIs2x2MapArea();
         assertNoHiddenAndShownSectors();
      }
      
      [Test]
      public function hideAllButOnePixelOfSectorRowOnTop() : void {
         init2x2MapAreaWholeVisibleInViewport();
         
         area.visibleAreaChange(
            new Rectangle(
               2 * SECTOR_W, 3 * SECTOR_H - 1,
               2 * SECTOR_W, 1 * SECTOR_H + 1
            ),
            areaVector([new Rectangle(
               2 * SECTOR_W, 2 * SECTOR_H,
               2 * SECTOR_W, 1 * SECTOR_H - 1
            )]),
            areaVector()
         );
         assertVisibleAreaIs2x2MapArea();
         assertNoHiddenAndShownSectors();
      }
      
      [Test]
      public function hideAllButOnePixelOfSectorRowOnBottom() : void {
         init2x2MapAreaWholeVisibleInViewport();
         
         area.visibleAreaChange(
            new Rectangle(
               2 * SECTOR_W, 2 * SECTOR_H,
               2 * SECTOR_W, 1 * SECTOR_H + 1
            ),
            areaVector([new Rectangle(
               2 * SECTOR_W, 3 * SECTOR_H + 1,
               2 * SECTOR_W, 1 * SECTOR_H - 1
            )]),
            areaVector()
         );
         assertVisibleAreaIs2x2MapArea();
         assertNoHiddenAndShownSectors();
      }
      
      /**
       * <pre> 
       * new MapArea(0, 1, -1, 0)
       * initialVisibleArea = new Rectangle(
       * &nbsp;&nbsp;&nbsp;2 * SECTOR_W, 2 * SECTOR_H,
       * &nbsp;&nbsp;&nbsp;2 * SECTOR_W, 2 * SECTOR_H
       * );
       * </pre>
       */      
      private function init2x2MapAreaWholeVisibleInViewport() : void {
         init(new MapArea(0, 1, -1, 0));
         var initialVisibleArea:Rectangle = new Rectangle(
            2 * SECTOR_W, 2 * SECTOR_H,
            2 * SECTOR_W, 2 * SECTOR_H
         );
         area.visibleAreaChange(
            initialVisibleArea,
            areaVector(),
            areaVector([initialVisibleArea])
         );
         client.clear();
      }
      
      private function assertNoHiddenAndShownSectors() : void {
         assertThat( "no shown sectors", client.sectorShownCalls, equals (0) );
         assertThat( "no hidden sectors", client.sectorHiddenCalls, equals (0) );
      }
      
      private function assertVisibleAreaIs2x2MapArea() : void {
         assertThat(
            "visible area remains the same",
            area.visibleArea, equals (new MapArea(0, 1, -1, 0))
         );
      }
      
      // -----
      
      [Test]
      public function hideLastPixelOfSectorColumnOnLeft() : void {
         init(new MapArea(0, 1, -1, 0));
         var initialVisibleArea:Rectangle = new Rectangle(
            3 * SECTOR_W - 1, 2 * SECTOR_H,
            1 * SECTOR_W + 1, 2 * SECTOR_H
         );
         area.visibleAreaChange(
            initialVisibleArea,
            areaVector(),
            areaVector([initialVisibleArea])
         );
         client.clear();
         
         area.visibleAreaChange(
            new Rectangle(
               3 * SECTOR_W, 2 * SECTOR_H,
               1 * SECTOR_W, 2 * SECTOR_H
            ),
            areaVector([new Rectangle(
               3 * SECTOR_W - 1, 2 * SECTOR_H,
                              1, 2 * SECTOR_H
            )]),
            areaVector()
         );
         assertThat( "visible area changed", area.visibleArea, equals (new MapArea(1, 1, -1, 0)) );
         assertThat( "no shown sectors", client.sectorShownCalls, equals (0) );
         assertThat( "hidden sectors", client.sectorHiddenParams, hasItems(
            definesPoint (0, -1),
            definesPoint (0,  0)
         ));
      }
      
      [Test]
      public function hideLastPixelOfSectorColumnOnRight() : void {
         init(new MapArea(0, 1, -1, 0));
         var initialVisibleArea:Rectangle = new Rectangle(
            2 * SECTOR_W,     2 * SECTOR_H,
            1 * SECTOR_W + 1, 2 * SECTOR_H
         );
         area.visibleAreaChange(
            initialVisibleArea,
            areaVector(),
            areaVector([initialVisibleArea])
         );
         client.clear();
         
         area.visibleAreaChange(
            new Rectangle(
               2 * SECTOR_W, 2 * SECTOR_H,
               1 * SECTOR_W, 2 * SECTOR_H
            ),
            areaVector([new Rectangle(
               3 * SECTOR_W, 2 * SECTOR_H,
               1,            2 * SECTOR_H
            )]),
            areaVector()
         );
         assertThat( "visible area changed", area.visibleArea, equals (new MapArea(0, 0, -1, 0)) );
         assertThat( "no shown sectors", client.sectorShownCalls, equals (0) );
         assertThat( "hidden sectors", client.sectorHiddenParams, hasItems(
            definesPoint (1, -1),
            definesPoint (1,  0)
         ));
      }
      
      [Test]
      public function hideLastPixelOfSectorColumnAtBottom() : void {
         init(new MapArea(0, 1, -1, 0));
         var initialVisibleArea:Rectangle = new Rectangle(
            2 * SECTOR_W, 2 * SECTOR_H,
            2 * SECTOR_W, 1 * SECTOR_H + 1
         );
         area.visibleAreaChange(
            initialVisibleArea,
            areaVector(),
            areaVector([initialVisibleArea])
         );
         client.clear();
         
         area.visibleAreaChange(
            new Rectangle(
               2 * SECTOR_W, 2 * SECTOR_H,
               2 * SECTOR_W, 1 * SECTOR_H
            ),
            areaVector([new Rectangle(
               2 * SECTOR_W, 3 * SECTOR_H,
               2 * SECTOR_W, 1
            )]),
            areaVector()
         );
         assertThat( "visible area changed", area.visibleArea, equals (new MapArea(0, 1, 0, 0)) );
         assertThat( "no shown sectors", client.sectorShownCalls, equals (0) );
         assertThat( "hidden sectors", client.sectorHiddenParams, hasItems(
            definesPoint (0, -1),
            definesPoint (1, -1)
         ));
      }
      
      // -----
      
      [Test]
      public function hideSomeOfSectorInOneDimenstionAndAllOfSectorInAnother() : void {
         init(new MapArea(0, 1, -1, 0));
         var initialVisibleArea:Rectangle = new Rectangle(
            2 * SECTOR_W, 2 * SECTOR_H,
            2 * SECTOR_W, 2 * SECTOR_H
         );
         area.visibleAreaChange(
            initialVisibleArea,
            areaVector(),
            areaVector([initialVisibleArea])
         );
         client.clear();
         
         area.visibleAreaChange(
            new Rectangle(
               2.5 * SECTOR_W, 3 * SECTOR_H,
               1.5 * SECTOR_W, 1 * SECTOR_H
            ),
            areaVector([new Rectangle(
               2   * SECTOR_W, 2 * SECTOR_H,
               0.5 * SECTOR_W, 1 * SECTOR_H
            )]),
            areaVector()
         );
         assertThat( "visible area changed", area.visibleArea, equals (new MapArea(0, 1, -1, -1)) );
         assertThat( "no shown sectors", client.sectorShownCalls, equals (0) );
         assertThat( "2 sectors hidden", client.sectorHiddenCalls, equals (2) );
         assertThat( "hidden sectors", client.sectorHiddenParams, hasItems(
            definesPoint (0, 0),
            definesPoint (1, 0)
         ));
      }
      
      
      // -----
      
      [Test]
      public function accountsForHiddenSectorsInGalaxyAndSectorsWithStaticObjects() : void {
         galaxy = new Galaxy();
         galaxy.addObject(solarSystem(1, 3,  0));
         galaxy.addObject(solarSystem(2, 0, -1));
         galaxy.setFOWEntries(
            Vector.<MapArea>([
               new MapArea(0, 1,  0,  0),
               new MapArea(2, 3, -1, -1)
            ]),
            new ArrayCollection()
         );
         client = new ClientMock();
         area = new VisibleGalaxyArea(galaxy, client, new GalaxyMapCoordsTransform(galaxy));
         
         var visibleScreenArea:Rectangle = new Rectangle(
            2 * SECTOR_W, 2 * SECTOR_H,
            4 * SECTOR_W, 4 * SECTOR_H
         );
         area.visibleAreaChange(
            visibleScreenArea,
            areaVector(),
            areaVector([visibleScreenArea])
         );
         assertThat( "6 sectors have been shown", client.sectorShownParams, arrayWithSize (6) );
         assertThat( "4 sectors of visible galaxy shown", client.sectorShownParams, hasItems(
            definesPoint (0,  0),
            definesPoint (1,  0),
            definesPoint (2, -1),
            definesPoint (3, -1)
         ));
         assertThat( "2 sectors with static objects shown", client.sectorShownParams, hasItems(
            definesPoint (3,  0),
            definesPoint (0, -1)
         ));
         
         area.visibleAreaChange(
            new Rectangle(),
            areaVector([visibleScreenArea]),
            areaVector()
         );
         assertThat(
            "6 sectors previously shown have been hidden",
            client.sectorHiddenParams, arrayWithSize (6)
         );
         assertThat(
            "the same 4 sectors of visible galaxy hidden",
            client.sectorHiddenParams, hasItems(
               definesPoint (0,  0),
               definesPoint (1,  0),
               definesPoint (2, -1),
               definesPoint (3, -1)
            )
         );
         assertThat(
            "the same 2 sectors with static objects hidden",
            client.sectorHiddenParams, hasItems(
               definesPoint (3,  0),
               definesPoint (0, -1)
            )
         );
      }
      
      
      /* ############### */
      /* ### HELPERS ### */
      /* ############### */
      
      private function areaVector(areas:Array = null) : Vector.<Rectangle> {
         if (areas == null) {
            areas = new Array();
         }
         return Vector.<Rectangle>(areas);
      }
      
      private function init(visibleArea:MapArea) : void {
         galaxy = new Galaxy();
         galaxy.setFOWEntries(Vector.<MapArea>([visibleArea]), new ArrayCollection());
         client = new ClientMock();
         area = new VisibleGalaxyArea(galaxy, client, new GalaxyMapCoordsTransform(galaxy));
      }
      
      private function solarSystem(id:int, x:int, y:int) : MSolarSystem {
         var ss:MSolarSystem = new MSolarSystem();
         ss.id = id;
         ss.x = x;
         ss.y = y;
         return ss;
      }
      
      private function definesPoint(x:int, y:int) : Matcher {
         return hasProperties({"x": x, "y": y});
      }
   }
}


import models.galaxy.IVisibleGalaxyAreaClient;

import flash.geom.Point;


class ClientMock implements IVisibleGalaxyAreaClient
{
   public var sectorHiddenCalls:int;
   public var sectorHiddenParams:Vector.<Point>;
   public var sectorShownCalls:int = 0;
   public var sectorShownParams:Vector.<Point>;
   
   public function ClientMock() {
      clear();
   }
   
   public function sectorHidden(x:int, y:int) : void {
      sectorHiddenCalls++;
      sectorHiddenParams.push(new Point(x, y));
   }
   
   public function sectorShown(x:int, y:int) : void {
      sectorShownCalls++;
      sectorShownParams.push(new Point(x, y));
   }
   
   public function clear() : void {
      sectorHiddenCalls = 0;
      sectorHiddenParams = new Vector.<Point>();
      sectorShownCalls = 0;
      sectorShownParams = new Vector.<Point>();
   }
}