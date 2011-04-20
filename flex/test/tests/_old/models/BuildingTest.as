package tests._old.models
{
   import models.building.Building;
   import models.building.BuildingBonuses;
   
   import net.digitalprimates.fluint.tests.TestCase;
   
   
   
   
   public class BuildingTest extends TestCase
   {
      private var b: Building;
      private var xMin :int, xMax: int, yMin: int, yMax: int;
      
      
      override protected function setUp () :void
      {
         b = new Building ();
         xMin = xMax = yMin = yMax = 0;
      };
      
      
      override protected function tearDown():void
      {
         b.cleanup();
         b = null;
      };
      
      
      [Test]
      public function getWidth () :void
      {
         b.x = 0;
         b.xEnd = 1;
         assertEquals ("Width should be equal to 2 (1 - 0 + 1)", 2, b.width);
         
         b.x = 5;
         b.xEnd = 5;
         assertEquals ("Width should be equal to 1 (5 - 5 + 1)", 1, b.width);
         
         b.x = 2;
         b.xEnd = 10;
         assertEquals ("Width should be equal to 9 (10 - 2 + 1)", 9, b.width);
      };
        
      [Test]
      public function getHeight () :void
      {
         b.y = 0;
         b.yEnd = 1;
         assertEquals ("Width should be equal to 2 (1 - 0 + 1)", 2, b.height);
         
         b.y = 5;
         b.yEnd = 5;
         assertEquals ("Width should be equal to 1 (5 - 5 + 1)", 1, b.height);
         
         b.y = 2;
         b.yEnd = 10;
         assertEquals ("Width should be equal to 9 (10 - 2 + 1)", 9, b.height);
      };
      
      
      [Test]
      public function fallsIntoArea_inside () :void
      {
         // Testing when building occupies exacly the whole area.
         
         xMin = xMax = yMin = yMax = 0; 
         b.x = b.y = b.xEnd = b.yEnd = 0;
         assertTrue (
            "Should be true when building occupies exacly the whole area.",
            b.fallsIntoArea (xMin, xMax, yMin, yMax)
         );
         
         xMin = xMax = 2;
         yMin = yMax = 5;
         
         b.x = b.y = 2
         b.xEnd = b.yEnd = 5;
         assertTrue (
            "Should be true when building occupies exacly the whole area.",
            b.fallsIntoArea (xMin, xMax, yMin, yMax)
         );
         
         // Testing the same but with negative coordinate values.
         
         b.x = b.y = xMin = yMin = -5;
         b.xEnd = b.yEnd = xMax = yMax = -2;
         assertTrue (
            "Should be true when building occupies exacly the whole area event " +
            "if coordinate are negative.", b.fallsIntoArea (xMin, xMax, yMin, yMax)
         );
         
         xMin = -1; xMax = 1;
         yMin = -2; yMax = 2; 
         b.x = -1; b.xEnd = 1;
         b.y = -2; b.yEnd = 2;
         assertTrue (
            "Should be true when building occupies exacly the whole area.",
            b.fallsIntoArea (xMin, xMax, yMin, yMax)
         );
         
         
         // Testing when building occupies part of the area
         
         xMin = yMin = 2;
         xMax = yMax = 5;
         
         b.x = 3; b.xEnd = 4;
         b.y = 3; b.yEnd = 4;
         assertTrue (
            "Should be true when occupies only part of the area.",
            b.fallsIntoArea (xMin, xMax, yMin, yMax)
         );
         
         b.x = 2; b.xEnd = 3;
         b.y = 3; b.yEnd = 5;
         assertTrue (
            "Should be true when occupies only part of the area.",
            b.fallsIntoArea (xMin, xMax, yMin, yMax)
         );
         
         b.x = 3; b.xEnd = 5;
         b.y = 2; b.yEnd = 5;
         assertTrue (
            "Should be true when occupies only part of the area.",
            b.fallsIntoArea (xMin, xMax, yMin, yMax)
         );
      };
      
      
      [Test]
      public function fallsIntoArea_outside () :void
      {
         xMin = yMin = 5;
         xMax = yMax = 10;
         
         b.x = 2; b.xEnd = 4;
         b.y = 0; b.yEnd = 8;
         assertFalse (
            "Should be false as the building is on the left of the area",
            b.fallsIntoArea (xMin, xMax, yMin, yMax)
         );
         
         b.x = 1; b.xEnd = 2;
         b.y = 5; b.yEnd = 9;
         assertFalse (
            "Should be false as the building is on the far left of the area",
            b.fallsIntoArea (xMin, xMax, yMin, yMax)
         );
         
         b.x = 11; b.xEnd = 13;
         b.y = 0;  b.yEnd = 100;
         assertFalse (
            "Should be false as the building is on the right of the area",
            b.fallsIntoArea (xMin, xMax, yMin, yMax)
         );
         
         b.x = 15; b.xEnd = 18;
         b.y = 23; b.yEnd = 13;
         assertFalse (
            "Should be false as the building is on the far right of the area",
            b.fallsIntoArea (xMin, xMax, yMin, yMax)
         );
         
         b.x = 6;  b.xEnd = 8;
         b.y = 11; b.yEnd = 15;
         assertFalse (
            "Should be false as the building is on the top of the area",
            b.fallsIntoArea (xMin, xMax, yMin, yMax)
         );
         
         b.x = 2;  b.xEnd = 12;
         b.y = 14; b.yEnd = 15;
         assertFalse (
            "Should be false as the building is on the far top of the area",
            b.fallsIntoArea (xMin, xMax, yMin, yMax)
         );
         
         b.x = 6; b.xEnd = 8;
         b.y = 2; b.yEnd = 4;
         assertFalse (
            "Should be false as the building is on the bottom of the area",
            b.fallsIntoArea (xMin, xMax, yMin, yMax)
         );
         
         b.x = 2; b.xEnd = 12;
         b.y = 1; b.yEnd = 1;
         assertFalse (
            "Should be false as the building is on the far bottom of the area",
            b.fallsIntoArea (xMin, xMax, yMin, yMax)
         );
      };
      
      
      [Test]
      public function fallsIntoArea_overlapsPartially () :void
      {
         xMin = yMin = 5;
         xMax = yMax = 10;
         
         b.x = b.y = 3;
         b.xEnd = b.yEnd = 12;
         assertTrue (
            "Should be true when occupies only part of the area.",
            b.fallsIntoArea (xMin, xMax, yMin, yMax)
         );
         
         b.x = 3; b.xEnd = 8;
         b.y = 2; b.yEnd = 12;
         assertTrue (
            "Should be true when occupies only part of the area.",
            b.fallsIntoArea (xMin, xMax, yMin, yMax)
         );
         
         b.y = 3; b.yEnd = 8;
         b.x = 2; b.xEnd = 12;
         assertTrue (
            "Should be true when occupies only part of the area.",
            b.fallsIntoArea (xMin, xMax, yMin, yMax)
         );
      };
   }
}