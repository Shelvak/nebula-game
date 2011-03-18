package controllers.ui
{
   import com.developmentarc.core.datastructures.utils.HashTable;
   import utils.SingletonFactory;
   
   import components.markers.IActiveCursorUser;
   
   import flash.display.BitmapData;
   import flash.display.DisplayObject;
   import flash.errors.IllegalOperationError;
   import flash.events.MouseEvent;
   import flash.ui.Mouse;
   
   import mx.core.FlexGlobals;
   import mx.managers.PopUpManager;
   import mx.managers.PopUpManagerChildList;
   import mx.managers.SystemManager;
   
   import spark.components.Application;
   import spark.components.Button;
   import spark.components.CheckBox;
   import spark.components.DropDownList;
   import spark.components.Group;
   import spark.components.ToggleButton;
   import spark.primitives.BitmapImage;
   
   import utils.ClassUtil;
   import utils.assets.Cursors;
   import utils.datastructures.PriorityQueue;

   
   /**
    * Cursor manager for the game because existing manager (flex CursorManager) does not quite
    * fit our needs.
    * <p>
    * Requirements for the application:
    * <ul>
    *    <li>Cursors should have been dowloaded before calling <code>GameCursorManager.initialize()</code> because
    *        <code>Cursors.DEFAULT</code> needs to be accessible.</li>
    * </ul>
    * </p>
    */
   public class GameCursorManager
   {
      /* ############### */
      /* ### STATICS ### */
      /* ############### */
      
      
      /**
       * Determines if a component needs custom over cursor.
       *  
       * @param comp Any component instance.
       * 
       * @return <code>true</code> if a given component should have custom
       * over cursor or <code>false</code> otherwise. 
       */      
      public static function requiresOverCursor(comp:DisplayObject) : Boolean
      {
         while(comp)
         {
            if (ifRequiresOverCursor(comp))
            {
               return true;
            }
            comp = comp.parent
         }
         return false;
      }
      private static function ifRequiresOverCursor(comp:DisplayObject) : Boolean
      {
         if (comp is IActiveCursorUser ||
             comp is Button ||
             comp is ToggleButton ||
             comp is DropDownList ||
             comp is CheckBox)
         {
            return true;
         }
         return false;
      }
      
      
      
      /**
       * This is what <code>setCursor()</code> returns if the given cursor class is
       * shown now as a cursor.
       */
      public static const NO_CURSOR_ID:int = -1;
      
      
      /**
       * Use this to always get the same instance of <code>GameCursorManager</code>.
       * 
       * @return always the same instance of <code>GameCursorManager</code>
       */
      public static function getInstance() : GameCursorManager
      {
         return SingletonFactory.getSingletonInstance(GameCursorManager);
      }
      
      
      /* ###################### */
      /* ### INITIALIZATION ### */
      /* ###################### */
      
      
      private var _testMode:Boolean;
      /**
       * Constructor. Do not create instances of this class directly. Use <code>getInstance()</code>
       * instead.
       * 
       * @param testMode used only in tests to make this class work without actual cursors.
       */
      public function GameCursorManager(testMode:Boolean = false)
      {
         _testMode = testMode;
      }
      
      
      /**
       * Call this when application has been created to initialize the manager.
       */
      public function initialize() : void
      {
         Mouse.hide();
         
         _cursorImageComp = new BitmapImage();
         _cursorContainer = new Group();
         _cursorContainer.mouseEnabled = false;
         _cursorContainer.mouseChildren = false;
         _cursorContainer.depth = Number.MAX_VALUE;
         _cursorContainer.addElement(_cursorImageComp);
         PopUpManager.addPopUp(_cursorContainer, _application, false, PopUpManagerChildList.POPUP);
         
         setDefaultCursorImage(Cursors.getInstance().DEFAULT);
         addApplicationEventHandlers();
      }
      
      
      private var _defaultCursorImage:BitmapData = null;
      /**
       * Sets default cursor image.
       * 
       * @param image default cursor image
       */
      public function setDefaultCursorImage(image:BitmapData) : void
      {
         ClassUtil.checkIfParamNotNull("image", image);
         if (_defaultCursorImage != null)
         {
            throw new IllegalOperationError("Default cursor image can only be set once");
         }
         _defaultCursorImage = image;
         setCursor(_defaultCursorImage, GameCursorPriority.LOWEST);
      }
      
      
      /* ################## */
      /* ### PROPERTIES ### */
      /* ################## */
      
      
      /**
       * Image data of currently visible cursor.
       */
      public function get currentCursorImage() : BitmapData
      {
         return peekEntry.image;
      }
      
      
      /**
       * ID of currently visible cursor.
       */
      public function get currentCursorId() : int
      {
         return peekId;
      }
      
      
      private var _currentCursorPriority:uint = GameCursorPriority.LOWEST;
      /**
       * Priority of currently visible cursor.
       */
      public function get currentCursorPriority() : uint
      {
         return peekEntry.priority;
      }
      
      
      /* ######################### */
      /* ### INTERFACE METHODS ### */
      /* ######################### */
      
      
      private var _nextCursorId:int = 0;
      
      
      /**
       * Adds given cursor to queue and shows it when that is appropriate.
       * 
       * @param image image of a cursor; different instances of <code>BitmapData</code> means different cursors.
       * @param priority priority of a cursors.
       * @param offsetX cursor image offset on X axis
       * @param offsetY cursor image offset on Y axis
       * 
       * @return cursor id or <code>NO_CURSORS_ID</code> if this cursor would end up in the queue
       * next to the same cursor
       */
      public function setCursor(image:BitmapData, priority:uint, offsetX:Number = 0, offsetY:Number = 0) : int
      {
         if (sameCursorNextTo(image, priority))
         {
            return NO_CURSOR_ID;
         }
         
         var newCursorId:uint = _nextCursorId;
         _nextCursorId++;
         addCursorToQueue(newCursorId, priority, image);
         updateCursorComponent();
         return newCursorId;
      }
      
      
      /**
       * Removes a cursors from manager. If no cursor with a given id is found, nothing happens.
       * 
       * @param id id of a cursor to remove
       * 
       * @throws IllegalOperationError if you try to remove default cursor
       */
      public function removeCursor(id:int) : void
      {
         if (id == bottomId)
         {
            throw new IllegalOperationError("You can't remove default cursor " +
                                            "(now its id is " + id + ")");
         }
         if (!_cursorsHash.containsKey(id))
         {
            return;
         }
         var cursorEntry:CursorEntry = _cursorsHash.getItem(id);
         _cursorIDsQueue.removeOneItem(id, cursorEntry.priority);
         _cursorsHash.remove(id);
         cursorEntry.cleanup();
         updateCursorComponent();
      }
      
      
      /**
       * Will remove all cursors that were added to que via <code>setCursor()</code> and will show
       * default cursor.
       */
      public function removeAllCursors() : void
      {
         _cursorsHash.removeAll();
         _cursorIDsQueue.removeAllItems();
         setCursor(_defaultCursorImage, GameCursorPriority.LOWEST);
      }
      
      
      /* ############################### */
      /* ### CURSORS LIST MANAGEMENT ### */
      /* ############################### */
      
      
      private var _cursorsHash:HashTable = new HashTable();
      private var _cursorIDsQueue:PriorityQueue = new PriorityQueue();
      
      
      private function addCursorToQueue(id:int, priority:uint, image:BitmapData) : void
      {
         _cursorsHash.addItem(id, new CursorEntry(image, id, priority));
         _cursorIDsQueue.addItem(id, priority);
      }
      
      
      private function getCursorEntry(id:int) : CursorEntry
      {
         return _cursorsHash.getItem(id);
      }
      
      
      private function get peekId() : int
      {
         return _cursorIDsQueue.peek();
      }
      
      
      private function get bottomId() : int
      {
         return _cursorIDsQueue.bottom();
      }
      
      
      private function get peekEntry() : CursorEntry
      {
         return getCursorEntry(peekId);
      }
      
      
      private function sameCursorNextTo(cursorImage:BitmapData, priority:uint) : Boolean
      {
         if (!_cursorIDsQueue.hasItems)
         {
            return false;
         }
         
         var position:int = _cursorIDsQueue.getPosition(priority);
         
         // Cursor on the left
         if (position != 0 &&
             getCursorEntry(_cursorIDsQueue.getItemAt(position - 1)).image === cursorImage)
         {
            return true;
         }
         
         // Cursor on the right
         if (position != _cursorIDsQueue.length &&
             getCursorEntry(_cursorIDsQueue.getItemAt(position)).image === cursorImage)
         {
            return true;
         }
         
         return false;
      }
      
      
      /* ################################### */
      /* ### CURSOR COMPONENT MANAGEMENT ### */
      /* ################################### */
      
      
      private var _cursorContainer:Group;
      private var _cursorImageComp:BitmapImage;
      
      
      private function updateCursorComponent() : void
      {
         updateCursorImage();
         updateCursorPosition();
      }
      
      
      private function updateCursorImage() : void
      {
         if (!_testMode)
         {
            _cursorImageComp.source = peekEntry.image;
         }
      }
      
      
      private function updateCursorPosition() :void
      {
         if (!_testMode)
         {
            _cursorContainer.move(mouseX + peekEntry.offsetX, mouseY + peekEntry.offsetY);
         }
      }
      
      
      /* ############### */
      /* ### HELPERS ### */
      /* ############### */
      
      
      private var _application:Application = Application(FlexGlobals.topLevelApplication)
      
      
      private function get mouseX() : Number
      {
         return _application.stage.mouseX;
      }
      
      
      private function get mouseY() : Number
      {
         return _application.stage.mouseY;
      }
      
      
      /* ########################### */
      /* ### APPLICATION CURSORS ### */
      /* ########################### */
      
      
      private var _overCursorId:int = NO_CURSOR_ID;
      private function get overCursorSet() : Boolean
      {
         return _overCursorId != NO_CURSOR_ID;
      }
      /**
       * Sets over cursor. 
       */
      public function setOverCursor() : void
      {
         if (overCursorSet) return;
         _overCursorId = setCursor(Cursors.getInstance().OVER, GameCursorPriority.LOW);
      }
      /**
       * Removes over cursor (default game cursor is restored). 
       */
      public function removeOverCursor() : void
      {
         if (overCursorSet)
         {
            removeCursor(_overCursorId);
            _overCursorId = NO_CURSOR_ID;
         }
      }
      
      
      /* ################################## */
      /* ### APPLICATION EVENT HANDLERS ### */
      /* ################################## */
      
      
      private function addApplicationEventHandlers() : void
      {
         SystemManager(_application.parent).addEventListener(MouseEvent.MOUSE_MOVE, systemManager_mouseMoveHandler, true);
         _application.addEventListener(MouseEvent.MOUSE_OVER, application_mouseOverHandler);
         _application.addEventListener(MouseEvent.MOUSE_OUT, application_mouseOutHandler);
      }
      
      
      private function systemManager_mouseMoveHandler(event:MouseEvent) : void
      {
         updateCursorPosition();
      }
      
      
      /**
       * Sets custom OVER cursor when target is one of special types.
       */
      private function application_mouseOverHandler(event:MouseEvent) : void
      {
         var displayObject:DisplayObject = event.target as DisplayObject;
         if (requiresOverCursor(displayObject))
         {
            setOverCursor();
         }
      }
      
      
      /**
       * Removes custom OVER cursor when target is one of special types.
       */
      private function application_mouseOutHandler(event:MouseEvent) : void
      {
         var displayObject:DisplayObject = event.target as DisplayObject;
         if (requiresOverCursor(displayObject))
         {
            removeOverCursor();
         }
      }
   }
}


import flash.display.BitmapData;


class CursorEntry
{
   public function CursorEntry(image:BitmapData, id:int, priority:uint,
                               offsetX:Number = 0, offsetY:Number = 0)
   {
      this.id = id;
      this.priority = priority;
      this.image = image;
      this.offsetX = offsetX;
      this.offsetY = offsetY;
   }
   
   
   public var id:int;
   public var priority:uint;
   public var image:BitmapData;
   public var offsetX:Number;
   public var offsetY:Number;
   
   
   public function cleanup() : void
   {
      image = null;
   }
}