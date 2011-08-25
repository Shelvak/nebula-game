package tests.animation
{
   import controllers.notifications.actions.ReadAction;
   
   import flash.geom.Point;
   
   import models.battle.PlaceFinder;
   
   import org.flexunit.asserts.assertEquals;
   import org.flexunit.asserts.assertFalse;
   import org.flexunit.asserts.assertNotNull;
   import org.flexunit.asserts.assertTrue;
   import org.hamcrest.assertThat;
   import org.hamcrest.collection.arrayWithSize;
   import org.hamcrest.collection.everyItem;
   import org.hamcrest.object.equalTo;
   
   import spark.primitives.Rect;
   
   import utils.random.Rndm;
   
   
   public class TC_PlaceFinder
   {
      private var fnd: PlaceFinder; 
      
      
      
      [Before]
      public function setUp():void
      {
         
      }
      
      [Test]
      public function fitMaxTest (): void
      {
         fnd = new PlaceFinder(10, 10, new Rndm());
         var pnt: Point = fnd.findPlace(10, 10);
         assertNotNull("Should fit in exact rect",pnt);
         assertEquals("Should be no free space left", 0, fnd.rects.count);
      }
      
      [Test]
      public function collisionTest (): void
      {
         fnd = new PlaceFinder(10, 10, new Rndm());
         var rect1: Rect = new Rect();
         var rect2: Rect = new Rect();
         rect1.x = 5;
         rect1.y = 5;
         rect1.width = 10;
         rect1.height = 10;
         rect2.x = 14;
         rect2.y = 6;
         rect2.width = 5;
         rect2.height = 5;
         assertTrue("Should detect right collision",  fnd.collides(rect1, rect2));
         
         rect1.x = 5;
         rect1.y = 5;
         rect1.width = 10;
         rect1.height = 10;
         rect2.x = 15;
         rect2.y = 6;
         rect2.width = 5;
         rect2.height = 5;
         assertFalse("Shouldnt detect right collision when touching",  fnd.collides(rect1, rect2));
         
         rect1.x = 5;
         rect1.y = 5;
         rect1.width = 10;
         rect1.height = 10;
         rect2.x = 2;
         rect2.y = 6;
         rect2.width = 4;
         rect2.height = 1;
         assertTrue("Should detect left collision",  fnd.collides(rect1, rect2));
         
         rect1.x = 5;
         rect1.y = 5;
         rect1.width = 10;
         rect1.height = 10;
         rect2.x = 2;
         rect2.y = 6;
         rect2.width = 3;
         rect2.height = 1;
         assertFalse("Shouldnt detect left collision when touching",  fnd.collides(rect1, rect2));
         
         rect1.x = 5;
         rect1.y = 5;
         rect1.width = 10;
         rect1.height = 10;
         rect2.x = 6;
         rect2.y = 1;
         rect2.width = 3;
         rect2.height = 5;
         assertTrue("Should detect top collision",  fnd.collides(rect1, rect2));
         
         rect1.x = 5;
         rect1.y = 5;
         rect1.width = 10;
         rect1.height = 10;
         rect2.x = 6;
         rect2.y = 1;
         rect2.width = 3;
         rect2.height = 4;
         assertFalse("Shouldnt detect top collision when touching",  fnd.collides(rect1, rect2));
         
         rect1.x = 5;
         rect1.y = 5;
         rect1.width = 10;
         rect1.height = 10;
         rect2.x = 6;
         rect2.y = 14;
         rect2.width = 3;
         rect2.height = 5;
         assertTrue("Should detect bottom collision",  fnd.collides(rect1, rect2));
         
         rect1.x = 5;
         rect1.y = 5;
         rect1.width = 10;
         rect1.height = 10;
         rect2.x = 6;
         rect2.y = 15;
         rect2.width = 3;
         rect2.height = 4;
         assertFalse("Shouldnt detect bottom collision when touching",  fnd.collides(rect1, rect2));
         
         rect1.x = 5;
         rect1.y = 5;
         rect1.width = 10;
         rect1.height = 10;
         rect2.x = 3;
         rect2.y = 3;
         rect2.width = 3;
         rect2.height = 3;
         assertTrue("Should detect left top collision",  fnd.collides(rect1, rect2));
         
         rect1.x = 5;
         rect1.y = 5;
         rect1.width = 10;
         rect1.height = 10;
         rect2.x = 3;
         rect2.y = 3;
         rect2.width = 2;
         rect2.height = 2;
         assertFalse("Shouldnt detect left top collision when touching",  fnd.collides(rect1, rect2));
         
         rect1.x = 5;
         rect1.y = 5;
         rect1.width = 10;
         rect1.height = 10;
         rect2.x = 14;
         rect2.y = 3;
         rect2.width = 3;
         rect2.height = 3;
         assertTrue("Should detect right top collision",  fnd.collides(rect1, rect2));
         
         rect1.x = 5;
         rect1.y = 5;
         rect1.width = 10;
         rect1.height = 10;
         rect2.x = 15;
         rect2.y = 3;
         rect2.width = 2;
         rect2.height = 2;
         assertFalse("Shouldnt detect right top collision when touching",  fnd.collides(rect1, rect2));
         
         rect1.x = 5;
         rect1.y = 5;
         rect1.width = 10;
         rect1.height = 10;
         rect2.x = 14;
         rect2.y = 14;
         rect2.width = 3;
         rect2.height = 3;
         assertTrue("Should detect right bottom collision",  fnd.collides(rect1, rect2));
         
         rect1.x = 5;
         rect1.y = 5;
         rect1.width = 10;
         rect1.height = 10;
         rect2.x = 15;
         rect2.y = 15;
         rect2.width = 2;
         rect2.height = 2;
         assertFalse("Shouldnt detect right bottom collision when touching",  fnd.collides(rect1, rect2));
         
         rect1.x = 5;
         rect1.y = 5;
         rect1.width = 10;
         rect1.height = 10;
         rect2.x = 3;
         rect2.y = 14;
         rect2.width = 3;
         rect2.height = 3;
         assertTrue("Should detect right bottom collision",  fnd.collides(rect1, rect2));
         
         rect1.x = 5;
         rect1.y = 5;
         rect1.width = 10;
         rect1.height = 10;
         rect2.x = 3;
         rect2.y = 15;
         rect2.width = 2;
         rect2.height = 2;
         assertFalse("Shouldnt detect right bottom collision when touching",  fnd.collides(rect1, rect2));
         
         rect1.x = 5;
         rect1.y = 5;
         rect1.width = 10;
         rect1.height = 10;
         rect2.x = 3;
         rect2.y = 3;
         rect2.width = 19;
         rect2.height = 3;
         assertTrue("Should detect top half collision",  fnd.collides(rect1, rect2));
         
         rect1.x = 5;
         rect1.y = 5;
         rect1.width = 10;
         rect1.height = 10;
         rect2.x = 3;
         rect2.y = 3;
         rect2.width = 19;
         rect2.height = 2;
         assertFalse("Shouldnt detect top half collision when touching",  fnd.collides(rect1, rect2));
         
         rect1.x = 5;
         rect1.y = 5;
         rect1.width = 10;
         rect1.height = 10;
         rect2.x = 3;
         rect2.y = 14;
         rect2.width = 19;
         rect2.height = 3;
         assertTrue("Should detect bottom half collision",  fnd.collides(rect1, rect2));
         
         rect1.x = 5;
         rect1.y = 5;
         rect1.width = 10;
         rect1.height = 10;
         rect2.x = 3;
         rect2.y = 15;
         rect2.width = 19;
         rect2.height = 2;
         assertFalse("Shouldnt detect bottom half collision when touching",  fnd.collides(rect1, rect2));
         
         rect1.x = 5;
         rect1.y = 5;
         rect1.width = 10;
         rect1.height = 10;
         rect2.x = 3;
         rect2.y = 3;
         rect2.width = 3;
         rect2.height = 19;
         assertTrue("Should detect left half collision",  fnd.collides(rect1, rect2));
         
         rect1.x = 5;
         rect1.y = 5;
         rect1.width = 10;
         rect1.height = 10;
         rect2.x = 3;
         rect2.y = 3;
         rect2.width = 2;
         rect2.height = 19;
         assertFalse("Shouldnt detect left half collision when touching",  fnd.collides(rect1, rect2));
         
         rect1.x = 5;
         rect1.y = 5;
         rect1.width = 10;
         rect1.height = 10;
         rect2.x = 14;
         rect2.y = 3;
         rect2.width = 3;
         rect2.height = 19;
         assertTrue("Should detect right half collision",  fnd.collides(rect1, rect2));
         
         rect1.x = 5;
         rect1.y = 5;
         rect1.width = 10;
         rect1.height = 10;
         rect2.x = 15;
         rect2.y = 3;
         rect2.width = 2;
         rect2.height = 19;
         assertFalse("Shouldnt detect right half collision when touching",  fnd.collides(rect1, rect2));
         
         rect1.x = 5;
         rect1.y = 5;
         rect1.width = 2;
         rect1.height = 2;
         rect2.x = 4;
         rect2.y = 4;
         rect2.width = 4;
         rect2.height = 4;
         assertTrue("Should detect full collision",  fnd.collides(rect1, rect2));
      }
      
      [Test]
      public function splitTest (): void
      {
         var rect1: Rect = new Rect();
         var rect2: Rect = new Rect();
         var rect3: Rect = new Rect();
         rect1.x = 5;
         rect1.y = 5;
         rect1.width = 2;
         rect1.height = 2;
         rect2.x = 6;
         rect2.y = 3;
         rect2.width = 3;
         rect2.height = 3;
         fnd = new PlaceFinder(10, 10, new Rndm());
         fnd.rects.addItem(rect1);
         fnd.split(rect1, rect2);
         assertEquals("Should split rects when touching corners", 3, fnd.rects.count);
         fnd.rects.addItem(rect2);
         rect3.x = 7;
         rect3.y = 4;
         rect3.width = 1;
         rect3.height = 1;
         fnd.split(rect2, rect3);
         
         assertEquals("Should split rects when in middle", 7, fnd.rects.count);
         fnd.rects.addItem(rect3);
         fnd.split(rect3, rect3);
         assertEquals("Should remove rects when equal", 7, fnd.rects.count);
      }
      
      [Test]
      public function freeSpaceTest (): void
      {
         fnd = new PlaceFinder(10, 10, new Rndm());
         fnd.findPlace(3,5);
         var xStart: int = fnd.getXStartFree();
         var xEnd: int = fnd.getXEndFree();
         assertEquals("Should find correct free space", 3, fnd.maxWidth - xEnd - xStart);
      }
         
      
      [After]
      public function tearDown():void
      {
      }
   }
}