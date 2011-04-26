package tests._old.models
{
   import models.planet.Planet;
   import models.planet.PlanetObject;
   import models.solarsystem.MSSObject;
   
   import mx.collections.ArrayCollection;
   
   import net.digitalprimates.fluint.tests.TestCase;
   
   /**
    * Map size in all tests is 7 x 8 (W x H).
    * 
    * Empty tile is marked as a dot (.);
    * Objects of 1x1 size are marked with zIndex value;
    * Objects larger than 1x1 are marked as # and the top-right corner holds zIndex value;
    */
   public class ZIndexCalculatorTest extends TestCase
   {
      private var planet:Planet = null;
      private var objects:ArrayCollection = null;
      
      /**
       * Initialize planet.
       */
      protected override function setUp() : void
      {
         var sso:MSSObject = new MSSObject();
         sso.width = 7;
         sso.height = 9;
         planet = new Planet(sso);
         objects = new ArrayCollection();
      };
      
      
      /**
       * YY 
       * 8  . . . . . . .
       * 7  . . . . . 0 .
       * 6  . . . . 2 . .
       * 5  . . . 4 . 1 .
       * 4  . . 6 . 3 . .
       * 3  . 8 . 5 . . .
       * 2  . . 7 . . . .
       * 1  . 9 . . . . .
       * 0  . . . . . . .
       * 
       *    0 1 2 3 4 5 6 XX
       */
      [Test]
      public function twoDiagonalRowsOf_1x1() : void
      {
         newObject(1, 1); newObject(1, 3);
         newObject(2, 2); newObject(2, 4);
         newObject(3, 3); newObject(3, 5);
         newObject(4, 4); newObject(4, 6);
         newObject(5, 5); newObject(5, 7);
         planet.addAllObjects(objects);
         checkZIndex(5, 7, 0); checkZIndex(5, 5, 1);
         checkZIndex(4, 6, 2); checkZIndex(4, 4, 3);
         checkZIndex(3, 5, 4); checkZIndex(3, 3, 5);
         checkZIndex(2, 4, 6); checkZIndex(2, 2, 7);
         checkZIndex(1, 3, 8); checkZIndex(1, 1, 9);
      };
      
      
      /**
       * YY 
       * 8  . . . . . . .
       * 7  . . . . . . .
       * 6  . . . . . . .
       * 5  . # # # # 0 .
       * 4  . # # # # # .
       * 3  . # # # # # .
       * 2  . . . . . . .
       * 1  . . . . . . .
       * 0  . . . . . . .
       * 
       *    0 1 2 3 4 5 6 XX
       */
      [Test]
      public function oneLargeInTheCenter() : void
      {
         newObject(1, 3, 5, 5);
         planet.addAllObjects(objects);
         checkZIndex(1, 3, 0);
      };
      
      
      /**
       * YY 
       * 8  . . . . . . 0
       * 7  . . 2 . . . .
       * 6  . . 3 1 . . .
       * 5  . . . . . . .
       * 4  # # # # # # 4
       * 3  . . . . . . .
       * 2  . . 7 6 . . .
       * 1  . . 8 . . . .
       * 0  . . . . . . 5
       * 
       *    0 1 2 3 4 5 6 XX
       */
      [Test]
      public function oneBlockSplit() : void
      {
         newObject(6, 8); newObject(6, 0);
         newObject(2, 7); newObject(2, 1);
         newObject(2, 6); newObject(2, 2);
         newObject(3, 6); newObject(3, 2);
         newObject(0, 4, 6, 4);
         planet.addAllObjects(objects);
         checkZIndex(6, 8, 0); checkZIndex(6, 0, 5);
         checkZIndex(2, 7, 2); checkZIndex(2, 1, 8);
         checkZIndex(2, 6, 3); checkZIndex(2, 2, 7);
         checkZIndex(3, 6, 1); checkZIndex(3, 2, 6);
         checkZIndex(0, 4, 4);
      };
      
      
      /**
       * Check if after a split when there is no top block calculation does not
       * enter infinite loop.
       * 
       * YY 
       * 8  . # # # # 0 .
       * 7  . . . . . . .
       * 6  . . . . . . .
       * 5  . . . . . . .
       * 4  . . . . . . .
       * 3  . . . . . . .
       * 2  . . . . . . .
       * 1  . . . . . . .
       * 0  . . . . . . .
       * 
       *    0 1 2 3 4 5 6 XX
       */
      [Test]
      public function splitTopBlockEmpty() : void
      {
         newObject(1, 8, 5, 8);
         planet.addAllObjects(objects);
         checkZIndex(1, 8, 0);
      };
      
      
      /**
       * Check if after a split when there is no bottom block calculation does not
       * enter infinite loop.
       *  
       * YY 
       * 8  . . . . . . .
       * 7  . . . . . . .
       * 6  . . . . . . .
       * 5  . . . . . . .
       * 4  . . . . . . .
       * 3  . . . . . . .
       * 2  . . . . . . .
       * 1  . . . . . . .
       * 0  . # # # # 0 .
       * 
       *    0 1 2 3 4 5 6 XX
       */
      [Test]
      public function splitBottomBlockEmpty() : void
      {
         newObject(1, 0, 5, 0);
         planet.addAllObjects(objects);
         checkZIndex(1, 0, 0);
      }
      
      
      /**
       * Should do 4 splits and take more time than other tests.
       *  
       * YY 
       * 8  . . 0 . . . .
       * 7  . # # 1 . . .
       * 6  . . . 2 . . .
       * 5  . . # # 3 . .
       * 4  . . . . 4 . .
       * 3  . . . # # 5 .
       * 2  . . . . . 6 .
       * 1  . . . . # # 7
       * 0  . . . . . . .
       * 
       *    0 1 2 3 4 5 6 XX
       */
      [Test]
      public function fourSplitsStairsLayout() : void
      {
         newObject(4, 1, 6, 1); newObject(5, 2);
         newObject(3, 3, 5, 3); newObject(4, 4);
         newObject(2, 5, 4, 5); newObject(3, 6);
         newObject(1, 7, 3, 7); newObject(2, 8);
         planet.addAllObjects(objects);
         checkZIndex(4, 1, 7); checkZIndex(5, 2, 6);
         checkZIndex(3, 3, 5); checkZIndex(4, 4, 4);
         checkZIndex(2, 5, 3); checkZIndex(3, 6, 2);
         checkZIndex(1, 7, 1); checkZIndex(2, 8, 0);
      }
      
      
      /**
       * Various objects of various size in different positions.
       *  
       * YY 
       * 8  . # 2 . . . 0
       * 7  . # # . . . #
       * 6  # # # 3 . . #
       * 5  . . . . . . .
       * 4  6 . . # # # 4
       * 3  . 5 . # # # #
       * 2  . . . . . . .
       * 1  . # # # # 7 .
       * 0  . . . . . . .
       * 
       *    0 1 2 3 4 5 6 XX
       */
      [Test]
      public function randomObjects() : void
      {
         newObject(6, 6, 6, 8);
         newObject(4, 7);
         newObject(1, 7, 2, 8);
         newObject(0, 6, 3, 6);
         newObject(3, 3, 6, 4);
         newObject(1, 3);
         newObject(1, 1, 5, 1);
         newObject(0, 4);
         planet.addAllObjects(objects);
         checkZIndex(6, 6, 0);
         checkZIndex(4, 7, 1);
         checkZIndex(1, 7, 2);
         checkZIndex(0, 6, 3);
         checkZIndex(3, 3, 4);
         checkZIndex(1, 3, 5);
         checkZIndex(1, 1, 6);
         checkZIndex(0, 4, 7);
      }
      
      
      private function checkZIndex(x:int, y:int, expectedZIndex:int) : void
      {
         assertEquals(
            "should have calculated correct zIndex value",
            expectedZIndex, planet.getObject(x, y).zIndex
         );
      }
      
      
      private function newObject(x:int, y:int, xEnd:int = -1, yEnd:int = -1) : void
      {
         var object:PlanetObject = new PlanetObjectImpl();
         object.x = x;
         object.y = y;
         object.xEnd = xEnd >= 0 ? xEnd : x;
         object.yEnd = yEnd >= 0 ? yEnd : y;
         objects.addItem(object);
      }
   }
}


import models.planet.PlanetObject;


class PlanetObjectImpl extends PlanetObject
{
   public function PlanetObjectImpl()
   {
      super();
   }
   
   
   public override function get isBlocking() : Boolean
   {
      return false;
   }
}