package tests.animation
{
   import flash.geom.Point;
   
   import models.battle.BattleMatrix;
   
   import org.flexunit.asserts.assertEquals;
   import org.hamcrest.assertThat;
   import org.hamcrest.collection.arrayWithSize;
   import org.hamcrest.collection.everyItem;
   import org.hamcrest.object.equalTo;
   
   import tests.hasSameValuesLikeMatrix;

   public class TC_BattleMatrix
   {
      private var testMatrix: BattleMatrix = new BattleMatrix();
      
      private static const emptyMatrix: Array = 
         [[0, 0, 0, 0, 0, 0, 0, 0],
         [0, 0, 0, 0, 0, 0, 0, 0],
         [0, 0, 0, 0, 0, 0, 0, 0],
         [0, 0, 0, 0, 0, 0, 0, 0],
         [0, 0, 0, 0, 0, 0, 0, 0],
         [0, 0, 0, 0, 0, 0, 0, 0],
         [0, 0, 0, 0, 0, 0, 0, 0],
         [0, 0, 0, 0, 0, 0, 0, 0]];
      
      private static const oneUnitMatrix: Array = 
         [[0, 0, 0, 0, 0, 0, 0, 0],
         [0, 0, 0, 0, 0, 0, 0, 0],
         [0, 0, BattleMatrix.TAKEN, BattleMatrix.TAKEN, 0, 0, 0, 0],
         [0, 0, BattleMatrix.TAKEN, BattleMatrix.TAKEN, 0, 0, 0, 0],
         [0, 0, BattleMatrix.TAKEN, BattleMatrix.TAKEN, 0, 0, 0, 0],
         [0, 0, 0, 0, 0, 0, 0, 0],
         [0, 0, 0, 0, 0, 0, 0, 0],
         [0, 0, 0, 0, 0, 0, 0, 0]];
      
      private static const oneUnitMovedMatrix: Array = 
         [[0, 0, 0, 0, 0, 0, 0, 0],
            [0, 0, 0, 0, 0, 0, 0, 0],
            [0, 0, 0, 0, 0, BattleMatrix.TAKEN, BattleMatrix.TAKEN, 0],
            [0, 0, 0, 0, 0, BattleMatrix.TAKEN, BattleMatrix.TAKEN, 0],
            [0, 0, 0, 0, 0, BattleMatrix.TAKEN, BattleMatrix.TAKEN, 0],
            [0, 0, 0, 0, 0, 0, 0, 0],
            [0, 0, 0, 0, 0, 0, 0, 0],
            [0, 0, 0, 0, 0, 0, 0, 0]];
      
      
      private static const preparedMatrix: Array = 
         [[0, 0, 0, 0, 0, 0, 0, 0],
            [0, 0, 0, 0, 0, 0, 0, 0],
            [0, 0, 0, 0, 0, BattleMatrix.TAKEN, BattleMatrix.TAKEN, -1],
            [0, 0, 0, 0, 0, BattleMatrix.TAKEN, BattleMatrix.TAKEN, 0],
            [0, 0, -1, 0, 0, BattleMatrix.TAKEN, BattleMatrix.TAKEN, 0],
            [0, 0, 0, 0, 0, 0, 0, 0],
            [0, 0, 0, 0, 0, 0, 0, 0],
            [0, 0, 0, 0, 0, 0, 0, 0]];
      
      private static const oneUnitBlockedMatrix: Array = 
         [[0, 0, 0, 0, 0, 0, 0, 0],
            [0, 0, 0, 0, 0, 0, 0, 0],
            [0, 0, 0, 0, 0, BattleMatrix.TAKEN, BattleMatrix.TAKEN, -1],
            [0, 0, 0, 0, 0, BattleMatrix.TAKEN, BattleMatrix.TAKEN, 0],
            [0, 0, -1, 0, 0, BattleMatrix.TAKEN, BattleMatrix.TAKEN, 0],
            [0, 0, 0, 0, 0, 0, 0, 0],
            [0, 0, 0, 0, 0, 0, 0, 0],
            [0, 0, 0, 0, 0, 0, 0, 0]];
      
      [Before]
      public function setUp():void
      {
         testMatrix.rowCount = 8;
         for (var i : int = 0; i < 8; i++)
            testMatrix.addColumn();
      }

      [Test]
      public function returnTestMatrixTest(): void
      {
         assertThat(testMatrix.returnTestMatrix(), hasSameValuesLikeMatrix(emptyMatrix));
      }
      
      [Test]
      public function occupyTest (): void
      {
         testMatrix.occupy(new Point(2, 2), new Point(3, 4));
         assertThat(testMatrix.returnTestMatrix(), hasSameValuesLikeMatrix(oneUnitMatrix));
      }
      
      [Test]
      public function moveTest (): void
      {
         testMatrix.occupy(new Point(2, 2), new Point(3, 4));
         testMatrix.move(new Point(2, 2), new Point(3, 4), 3);
         assertThat(testMatrix.returnTestMatrix(), hasSameValuesLikeMatrix(oneUnitMovedMatrix));
      }
      
      [Test]
      public function horizontalFreeSpaceTest (): void
      {
         testMatrix.occupy(new Point(2, 2), new Point(3, 4));
         testMatrix.move(new Point(2, 2), new Point(3, 4), 3);
         testMatrix.occupyCell(2, 4, -1);
         testMatrix.occupyCell(7, 2, -1);
         assertThat(testMatrix.returnTestMatrix(), hasSameValuesLikeMatrix(preparedMatrix));
         assertEquals("Should calculate correct free space to the left", 2,
             testMatrix.getFreeHorizontalCols(new Point(0, 2), new Point(4, 4),1));
         assertEquals("Should calculate correct free space to the right", 0,
             testMatrix.getFreeHorizontalCols(new Point(6, 2), new Point(7, 4),0));
      }
      
      [Test]
      public function flankLimitTest (): void
      {
         testMatrix.occupy(new Point(2, 2), new Point(2, 4));
         testMatrix.occupyCell(5, 0, -1);
         testMatrix.occupyCell(0, 0, -1);
         assertEquals("Should find flank limit to the right", 2,
            testMatrix.getFreeHorizontalCols(new Point(3, 2), new Point(7, 4),0));
         
         assertEquals("Should find flank limit to the left", 1,
            testMatrix.getFreeHorizontalCols(new Point(0, 2), new Point(1, 4),1));
         
         testMatrix.occupyCell(3, 0, -1);
         testMatrix.occupyCell(1, 0, -1);
         assertEquals("Should find zero flank limit to the left", 0,
            testMatrix.getFreeHorizontalCols(new Point(0, 2), new Point(1, 4),1));
         assertEquals("Should find zoro flank limit to the right", 0,
            testMatrix.getFreeHorizontalCols(new Point(0, 2), new Point(1, 4),0));
      }
      
      
      [After]
      public function tearDown():void
      {
      }
   }
}