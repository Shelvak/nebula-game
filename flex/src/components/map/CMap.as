package components.map
{
   import com.developmentarc.core.utils.EventBroker;
   
   import components.base.CustomCursorContainer;
   import components.base.viewport.ViewportZoomable;
   
   import flash.display.BitmapData;
   import flash.display.DisplayObject;
   import flash.errors.IllegalOperationError;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   
   import globalevents.GMapEvent;
   import globalevents.GScreenChangeEvent;
   import globalevents.GlobalEvent;
   
   import interfaces.ICleanable;
   
   import models.BaseModel;
   import models.location.LocationMinimal;
   import models.map.MMap;
   import models.map.events.MMapEvent;
   
   import mx.graphics.BitmapFillMode;
   
   import spark.primitives.BitmapImage;
   
   
   /**
    * Base class for all maps. A map is not ordinary Flex component and therefore does not follow
    * Flex components lifecycle. Map is drawn, measured and all objects are created when instance is
    * created. Three protected methods must be overriden in order this works properly:
    * <code>getBackground()</code>, <code>getSize()</code> and <code>createObjects()</code> (read
    * documentation of these methods for more information). The mehods are called in the order
    * they have been mentioned here.
    * <p>
    * When you no longer need the map, you <b>must</b> call <code>cleanup()</code> method to remove
    * all event listeners, references to other objects. Not doing so will <b>definitely</b>
    * result in memory leaks and performance loss. You also should override this method to release
    * any additional resources used by the deriving class.
    * </p>
    */
   public class CMap extends CustomCursorContainer implements ICleanable
   {
      public static const CURSOR_OFFSET_X:int = -17;
      public static const CURSOR_OFFSET_Y:int = CURSOR_OFFSET_X;
      
      
      /* ###################### */
      /* ### INITIALIZATION ### */
      /* ###################### */
      
      
      private var _backgroundData:BitmapData = null;
      private var _backgroundComponent:BitmapImage = null;
      
      
      public function CMap(model:MMap) : void
      {
         super();
         super.model = model;
         addGlobalEventHandlers();
         addModelEventHandlers(model);
//         setCursorProperty();
      }
      
      
      /**
       * Called by constructor to get background image of the map. If you don't have or need a
       * background for the map you should not override this method but in that case you <b>must</b>
       * override <code>getSize()</code> because default implementation of that method relies on
       * <code>getBackground()</code>.
       * 
       * @return background image of the map. Default implementation returns <code>null</code>.
       */
      public function getBackground() : BitmapData
      {
         return null;
      }
      
      
      /**
       * Called by constructor to set size of the map. You can leave default implementation of this
       * method <b>only if</b> <code>getBackground()</code> does not return <code>null</code> (that
       * means you have implemented it in your own way).
       * 
       * @return a point that defines size of the map: <code>x</code> is width of the map and
       * <code>y</code> is height. Default implemetation returns <code>width</code> and
       * <code>height</code> properties values of <code>getBackground()</code>.
       */
      public function getSize() : Point
      {
         return new Point(
            getBackground().width,
            getBackground().height
         );
      }
      
      
      /**
       * Called in <code>createChildren()</code> to create any objects on the map. You don'thave to override this
       * method and can create and remove objects from the map at any time. Default implementation of this method
       * is empty.
       */
      protected function createObjects() : void
      {
      }
      
      
      private var f_childrenCreated:Boolean = false;
      protected override function createChildren() : void
      {
         super.createChildren();
         if (f_childrenCreated)
         {
            return;
         }
         
         _backgroundData = getBackground();
         // Create background image component if we got background
         if (_backgroundData != null)
         {
            _backgroundComponent = new BitmapImage();
            _backgroundComponent.smooth = true;
            _backgroundComponent.fillMode = BitmapFillMode.REPEAT;
            _backgroundComponent.source = _backgroundData;
            addElement(_backgroundComponent);
         }
         createObjects();
         f_childrenCreated = true;
      }
      
      
      public function cleanup() : void
      {
         removeGlobalEventHandlers();
         if (model)
         {
            removeModelEventHandlers(getModel());
            model = null;
         }
         if (_backgroundComponent)
         {
            removeElement(_backgroundComponent);
            _backgroundComponent.source = null;
            _backgroundComponent = null;
            _backgroundData = null;
         }
         _viewport = null;
      }
      
      
      /* ######################## */
      /* ### SIZE AND VISUALS ### */
      /* ######################## */
      
      
      protected override function measure() : void
      {
         var size:Point = getSize();
         measuredWidth = size.x;
         measuredHeight = size.y;
      }
      
      
      protected override function updateDisplayList(uw:Number, uh:Number) : void
      {
         super.updateDisplayList(uw, uh);
         if (_backgroundComponent)
         {
            _backgroundComponent.width = uw;
            _backgroundComponent.height = uh;
         }
      }      
      
      /* ################## */
      /* ### PROPERTIES ### */
      /* ################## */
      
      
      private var f_viewportSet:Boolean = false;
      private var _viewport:ViewportZoomable = null;
      /**
       * A viewport that is responsible for moving and zooming this map. This is a
       * write-once-read-many property.
       */
      public function set viewport(value:ViewportZoomable) : void
      {
         if (f_viewportSet)
         {
            throwWriteOncePropertyError();
         }
         if (_viewport != value)
         {
            _viewport = value;
            f_viewportSet = true;
         }
      }
      /**
       * @private
       */
      public function get viewport() : ViewportZoomable
      {
         return _viewport;
      }
      
      
      /**
       * Actual width of a map (with respect to scaling).
       */
      public function get scaledWidth() : Number
      {
         return width * scaleX;
      }
      
      
      /**
       * Actual height of a map (with respect to scaling).
       */
      public function get scaledHeight() : Number
      {
         return height * scaleY;
      }
      
      
      /* ######################### */
      /* ### INTERFACE METHODS ### */
      /* ######################### */
      
      
      /**
       * Returns component which will be used as source for minimap snapshot. Method in
       * <code>CMap</code> returns map container itself.
       */
      public function getSnapshotComponent() : DisplayObject
      {
         return this;
      }
      
      
      /**
       * When this method is invoked the map should select given model if that model is of correct
       * type. In <code>CMap</code> this method is empty. Second call to this method should open
       * the object
       * 
       * @param object an object that must be selected or opened.
       */
      protected function selectModel(object:BaseModel) : void
      {
      }
      
      
      /**
       * Similar to <code>selectModel()</code>. Only the parameter passed is not a model, but
       * a component. The component passed is guaranteed to be of correct type.
       * 
       * @param component a component that represents model of an object that needs to be selected
       * @param center idicates if the component should be moved to the center of the viewport
       * @param openOnSecondCall if <code>true</code> and <code>component</code> is the object already
       * selected, the object will be opened rather than selected.
       */
      public function selectComponent(component:Object,
                                      center:Boolean = false,
                                      openOnSecondCall:Boolean = false) : void
      {
      }
      
      
      /**
       * Opens (navigates to) a model assosiated with the given component. The component passed is
       * guaranteed to be of correct type.
       * 
       * @param component a component that represents model of an object that need to be opened
       */
      public function openComponent(component:Object) : void
      {
      }
      
      
      /**
       * When this method is invoked the map should deselect selected object. In
       * <code>CMap</code> this method is empty.
       */
      public function deselectSelectedObject() : void
      {
      }
      
      
      /**
       * When invoked, map should reset itself to initial state. This is an empty method in
       * <code>CMap</code>: override if needed.
       */
      protected function reset() : void
      {
      }
      
      
      protected function zoomArea(area:Rectangle, operationCompleteHandler:Function = null) : void
      {
         _viewport.zoomArea(area, true, operationCompleteHandler);
      }
      
      
      protected function centerLocation(location:LocationMinimal, operationCompleteHandler:Function) : void
      {
      }
      
      
      protected function zoomObjectImpl(object:*, operationCompleteHandler:Function = null) : void
      {
      }
      
      
      protected function selectObjectImpl(object:*, operationCompleteHandler:Function = null) : void
      {
      }
      
      
      /* ###################### */
      /* ### EVENT HANDLERS ### */
      /* ###################### */
      
      
      protected function addGlobalEventHandlers() : void
      {
         EventBroker.subscribe(GMapEvent.SELECT_OBJECT, global_selectMapObjectHandler);
         EventBroker.subscribe(GScreenChangeEvent.MAIN_AREA_CHANGING, global_mainAreaChangingHandler);
         EventBroker.subscribe(GlobalEvent.APP_RESET, global_appResetHandler);
      }
      
      
      protected function removeGlobalEventHandlers() : void
      {
         EventBroker.unsubscribe(GMapEvent.SELECT_OBJECT, global_selectMapObjectHandler);
         EventBroker.unsubscribe(GScreenChangeEvent.MAIN_AREA_CHANGING, global_mainAreaChangingHandler);
         EventBroker.unsubscribe(GlobalEvent.APP_RESET, global_appResetHandler);
      }
      
      
      private function global_selectMapObjectHandler(event:GMapEvent) : void
      {
         selectModel(event.object);
      }
      
      
      private function global_mainAreaChangingHandler(event:GScreenChangeEvent) : void
      {
         reset();
      }
      
      
      private function global_appResetHandler(event:GlobalEvent) : void
      {
         cleanup();
      }
      
      
      protected function addModelEventHandlers(model:MMap) : void
      {
         model.addEventListener(MMapEvent.UICMD_ZOOM_OBJECT, model_uicmdZoomObjectHandler, false, 0, true);
         model.addEventListener(MMapEvent.UICMD_SELECT_OBJECT, model_uicmdSelectObjectHandler, false, 0, true);
         model.addEventListener(MMapEvent.UICMD_MOVE_TO, model_uicmdMoveToHandler, false, 0, true);
      }
      
      
      protected function removeModelEventHandlers(model:MMap) : void
      {
         model.removeEventListener(MMapEvent.UICMD_ZOOM_OBJECT, model_uicmdZoomObjectHandler, false);
         model.removeEventListener(MMapEvent.UICMD_SELECT_OBJECT, model_uicmdSelectObjectHandler, false);
         model.removeEventListener(MMapEvent.UICMD_MOVE_TO, model_uicmdMoveToHandler, false);
      }
      
      
      private function model_uicmdZoomObjectHandler(event:MMapEvent) : void
      {
         if (viewport)
         {
            zoomObjectImpl(event.object, event.operationCompleteHandler);
         }
      }
      
      
      private function model_uicmdSelectObjectHandler(event:MMapEvent) : void
      {
         if (viewport)
         {
            selectObjectImpl(event.object, event.operationCompleteHandler);
         }
      }
      
      
      private function model_uicmdMoveToHandler(event:MMapEvent) : void
      {
         if (viewport)
         {
            centerLocation(event.object, event.operationCompleteHandler);
         }
      }
      
      
      /* ############### */
      /* ### HELPERS ### */
      /* ############### */
      
      
      protected function getModel() : MMap
      {
         return MMap(model);
      }
      
      
      /**
       * @throws IllegalOperationError
       */
      private function throwWriteOncePropertyError() : void
      {
         throw new IllegalOperationError("This property is of write-once type: it can be set only once");
      }
      
      
      /* ############################### */
      /* ### CURSOR MANAGEMENT LOGIC ### */
      /* ############################### */
      
      
//      private function setCursorProperty() : void
//      {
//         cursor = Cursors.getInstance().MAP_DEFAULT;
//      }
//      override public function setCursor() : void
//      {
//         if (cursorSet)
//         {
//            return;
//         }
//         cursorId = GameCursorManager.getInstance().setCursor(
//            cursor, GameCursorPriority.MAP_DEFAULT,
//            CURSOR_OFFSET_X, CURSOR_OFFSET_Y
//         );
//      }
//      
//      override protected function setCursor_handler(e:MouseEvent) : void
//      {
//         if (e.target == background || e.target == this)
//         {
//            removeGripCursor();
//            setCursor();
//         }
//      }
//      override protected function removeCursor_handler(e:MouseEvent) : void
//      {
//         if (e.target == background || e.target == this)
//         {
//            removeGripCursor();
//            removeCursor();
//         }
//      }
//      
//      
//      /**
//       * Id of grip cursor. 
//       */
//      protected var gripCursorId:int = GameCursorManager.NO_CURSOR_ID;
//      /**
//       * Indicates if map gas grip cursor set.
//       * 
//       * @default false  
//       */
//      public function get gripCursorSet() : Boolean
//      {
//         return gripCursorId != GameCursorManager.NO_CURSOR_ID;
//      }
//      /**
//       * Sets Cursors.MAP_GRIP cursor when primary mouse button is down.
//       */
//      protected function setGripCursor_handler(e:MouseEvent) : void
//      {
//         if (e.target == background || e.target == this)
//         {
//            setGripCursor();
//         }
//      }
//      /**
//       * Sets Cursors.MAP_GRIP cursor.
//       */
//      public function setGripCursor() : void
//      {
//         if(gripCursorSet)
//         {
//            return;
//         }
//         gripCursorId = GameCursorManager.getInstance().setCursor(
//            Cursors.getInstance().MAP_GRIP,
//            GameCursorPriority.MAP_GRIP,
//            CURSOR_OFFSET_X, CURSOR_OFFSET_Y
//         );
//      }
//      /**
//       * Removes Cursors.MAP_GRIP cursor when primary mouse button is up again.
//       */
//      protected function removeGripCursor_handler (e:MouseEvent) : void
//      {
//         if (e.target == background || e.target == this)
//         {
//            removeGripCursor();
//         }
//      }
//      /**
//       * Removes Cursors.MAP_GRIP cursor. 
//       */
//      public function removeGripCursor() : void
//      {
//         if (gripCursorSet)
//         {
//            GameCursorManager.getInstance().removeCursor(gripCursorId);
//            gripCursorId = GameCursorManager.NO_CURSOR_ID;
//         }
//      }
   }
}