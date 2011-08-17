package tests.controllers.ui.tests
{
   import controllers.ui.GameCursorManager;
   import controllers.ui.GameCursorPriority;
   
   import flash.display.BitmapData;
   import flash.errors.IllegalOperationError;
   import flash.ui.Mouse;
   
   import mx.managers.CursorManager;
   
   import org.hamcrest.assertThat;
   import org.hamcrest.collection.everyItem;
   import org.hamcrest.core.allOf;
   import org.hamcrest.core.isA;
   import org.hamcrest.core.throws;
   import org.hamcrest.object.equalTo;
   import org.hamcrest.object.hasProperties;
   
   
   public class TC_GameCursorManager
   {
      private var manager:GameCursorManager;
      
      
      private var CursorDefault:BitmapData = new BitmapData(1,1);
      private var Cursor0:BitmapData = new BitmapData(1,1);
      private var Cursor1:BitmapData = new BitmapData(1,1);
      private var Cursor2:BitmapData = new BitmapData(1,1);
      private var Cursor3:BitmapData = new BitmapData(1,1);
      private var Cursor4:BitmapData = new BitmapData(1,1);
      private var Cursor5:BitmapData = new BitmapData(1,1);
      private var Cursor6:BitmapData = new BitmapData(1,1);
      private var Cursor7:BitmapData = new BitmapData(1,1);
      private var Cursor8:BitmapData = new BitmapData(1,1);
      private var Cursor9:BitmapData = new BitmapData(1,1);
      
      
      [Before]
      public function setUp() : void
      {
         manager = new GameCursorManager(true);
         manager.setDefaultCursorImage(CursorDefault);
      };
      
      
      [After]
      public function tearDown() : void
      {
         manager = null;
      };
      
      
      [Test]
      /**
       * Checks if setDefaultCursorClass() correctly accepts parameters.
       */
      public function setDefaultCursorClass() : void
      {
         // Should not accept null values
         assertThat( 
            function():void{ new GameCursorManager().setDefaultCursorImage(null) },
            throws (ArgumentError)
         );
         
         // Can be called only once
         assertThat(
            function():void{ manager.setDefaultCursorImage(CursorDefault) },
            throws (IllegalOperationError)
         );
         
         // This should not cause any exceptions
         new GameCursorManager(true).setDefaultCursorImage(CursorDefault);
      }
      
      
      [Test]
      /**
       * When manager is created it should show default cursor.
       */
      public function afterInitialization() : void
      {
         assertThat( manager.currentCursorId, equalTo (0) );
         assertThat( manager.currentCursorPriority, equalTo (GameCursorPriority.LOWEST) );
      };
      
      
      [Test]
      /**
       * Should show new cursor if its priority is grater than of the current one.
       */
      public function setCursor_incrementalPriority() : void
      {
         var cursor0ID:int = manager.setCursor(Cursor0, GameCursorPriority.LOW);
         assertThat( manager, hasProperties ({
            "currentCursorId": cursor0ID,
            "currentCursorPriority": GameCursorPriority.LOW,
            "currentCursorImage": Cursor0
         }));
         
         var cursor1ID:int = manager.setCursor(Cursor1, GameCursorPriority.NORMAL);
         assertThat( manager, hasProperties ({
            "currentCursorId": cursor1ID,
            "currentCursorPriority": GameCursorPriority.NORMAL,
            "currentCursorImage": Cursor1
         }));
         
         var cursor2ID:int = manager.setCursor(Cursor2, GameCursorPriority.HIGH);
         assertThat( manager, hasProperties ({
            "currentCursorId": cursor2ID,
            "currentCursorPriority": GameCursorPriority.HIGH,
            "currentCursorImage": Cursor2
         }));
      };
      
      
      [Test]
      /**
       * Should not switch to new cursor if it has got lower priority than current cursor.
       */
      public function setCursor_mixedPriorities() : void
      {
         var cursor0ID:int = manager.setCursor(Cursor0, GameCursorPriority.NORMAL);
         assertThat( manager, hasProperties ({
            "currentCursorId": cursor0ID,
            "currentCursorPriority": GameCursorPriority.NORMAL,
            "currentCursorImage": Cursor0
         }));
         
         var cursor1ID:int = manager.setCursor(Cursor1, GameCursorPriority.LOW);
         assertThat( manager, hasProperties ({
            "currentCursorId": cursor0ID,
            "currentCursorPriority": GameCursorPriority.NORMAL,
            "currentCursorImage": Cursor0
         }));
         
         var cursor2ID:int = manager.setCursor(Cursor3, GameCursorPriority.HIGHEST);
         assertThat( manager, hasProperties ({
            "currentCursorId": cursor2ID,
            "currentCursorPriority": GameCursorPriority.HIGHEST,
            "currentCursorImage": Cursor3
         }));
      };
      
      
      [Test]
      /**
       * Should switch to a new cursor if we give it the same priority as current cursor has.
       */
      public function setCursor_differentCursorsSamePriorities() : void
      {
         var cursor0ID:int = manager.setCursor(Cursor0, GameCursorPriority.NORMAL);
         assertThat( manager, hasProperties ({
            "currentCursorId": cursor0ID,
            "currentCursorPriority": GameCursorPriority.NORMAL,
            "currentCursorImage": Cursor0
         }));
         
         var cursor1ID:int = manager.setCursor(Cursor1, GameCursorPriority.NORMAL);
         assertThat( manager, hasProperties ({
            "currentCursorId": cursor1ID,
            "currentCursorPriority": GameCursorPriority.NORMAL,
            "currentCursorImage": Cursor1
         }));
         
         var cursor2ID:int = manager.setCursor(Cursor3, GameCursorPriority.NORMAL);
         assertThat( manager, hasProperties ({
            "currentCursorId": cursor2ID,
            "currentCursorPriority": GameCursorPriority.NORMAL,
            "currentCursorImage": Cursor3
         }));
      };
      
      
      [Test]
      /**
       * Should not return valid cursor id and should not switch cursors if we try to set a
       * cursor which already has been added and as a result these to cursor would end up
       * next to each other.
       */
      public function setCursor_sameCursorsNextToEachOther() : void
      {
         var cursor0ID:int = manager.setCursor(Cursor0, GameCursorPriority.NORMAL);
         var cursor1ID:int = manager.setCursor(Cursor1, GameCursorPriority.HIGH);
         var cursor2ID:int = manager.setCursor(Cursor0, GameCursorPriority.NORMAL);
         var cursor3ID:int = manager.setCursor(Cursor0, GameCursorPriority.LOW);
         var cursor4ID:int = manager.setCursor(Cursor1, GameCursorPriority.HIGH);
         var cursor5ID:int = manager.setCursor(Cursor1, GameCursorPriority.HIGHEST);
         var cursor6ID:int = manager.setCursor(Cursor1, GameCursorPriority.NORMAL);
         assertThat( cursor2ID, equalTo (GameCursorManager.NO_CURSOR_ID) );
         assertThat( cursor3ID, equalTo (GameCursorManager.NO_CURSOR_ID) );
         assertThat( cursor4ID, equalTo (GameCursorManager.NO_CURSOR_ID) );
         assertThat( cursor5ID, equalTo (GameCursorManager.NO_CURSOR_ID) );
         assertThat( cursor6ID, equalTo (GameCursorManager.NO_CURSOR_ID) );
         assertThat( manager, hasProperties ({
            "currentCursorId": cursor1ID,
            "currentCursorPriority": GameCursorPriority.HIGH,
            "currentCursorImage": Cursor1
         }));
      };
      
      
      [Test]
      /**
       * Should clean up the queue and switch to default cursor.
       */
      public function removeAllCursors() : void
      {
         manager.setCursor(Cursor0, GameCursorPriority.NORMAL);
         manager.setCursor(Cursor1, GameCursorPriority.HIGH);
         manager.removeAllCursors();
         assertThat( manager, hasProperties ({
            "currentCursorPriority": GameCursorPriority.LOWEST,
            "currentCursorImage": CursorDefault
         }));
      };
      
      
      [Test]
      /**
       * When id of non-existing cursor is given, nothing should happen.
       */
      public function removeCursor_nonExisting() : void
      {
         var cursor0ID:int = manager.setCursor(Cursor0, GameCursorPriority.NORMAL);
         var cursor1ID:int = manager.setCursor(Cursor1, GameCursorPriority.NORMAL);
         manager.removeCursor(10);
         manager.removeCursor(20);
         assertThat( manager, hasProperties ({
            "currentCursorId": cursor1ID,
            "currentCursorPriority": GameCursorPriority.NORMAL,
            "currentCursorImage": Cursor1
         }));
      };
      
      
      [Test]
      /**
       * Should not allow removing default cursor.
       */
      public function removeCursor_default() : void
      {
         assertThat(
            function():void{ manager.removeCursor(manager.currentCursorId) },
            throws (IllegalOperationError)
         );
      };
      
      
      /**
       * Should remove cursor with given id from the queue and switch to another cursor if needed.
       */
      [Test]
      public function removeCursor_existing() : void
      {
         var cursor0ID:int = manager.setCursor(Cursor0, GameCursorPriority.LOW);
         var cursor1ID:int = manager.setCursor(Cursor1, GameCursorPriority.NORMAL);
         var cursor2ID:int = manager.setCursor(Cursor0, GameCursorPriority.HIGH);
         var cursor3ID:int = manager.setCursor(Cursor2, GameCursorPriority.NORMAL);
         var cursor4ID:int = manager.setCursor(Cursor3, GameCursorPriority.HIGHEST);
         assertThat( manager.currentCursorId, equalTo(cursor4ID) );
         manager.removeCursor(cursor3ID);
         assertThat( manager, hasProperties ({
            "currentCursorId": cursor4ID,
            "currentCursorPriority": GameCursorPriority.HIGHEST,
            "currentCursorImage": Cursor3
         }));
         manager.removeCursor(cursor4ID);
         assertThat( manager, hasProperties ({
            "currentCursorId": cursor2ID,
            "currentCursorPriority": GameCursorPriority.HIGH,
            "currentCursorImage": Cursor0
         }));
         manager.removeCursor(cursor1ID);
         assertThat( manager, hasProperties ({
            "currentCursorId": cursor2ID,
            "currentCursorPriority": GameCursorPriority.HIGH,
            "currentCursorImage": Cursor0
         }));
         manager.removeCursor(cursor0ID);
         assertThat( manager, hasProperties ({
            "currentCursorId": cursor2ID,
            "currentCursorPriority": GameCursorPriority.HIGH,
            "currentCursorImage": Cursor0
         }));
         manager.removeCursor(cursor2ID);
         assertThat( manager, hasProperties ({
            "currentCursorId": 0,
            "currentCursorPriority": GameCursorPriority.LOWEST,
            "currentCursorImage": CursorDefault
         }));
      }
   }
}