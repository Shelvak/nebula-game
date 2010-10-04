package components.map.controllers.minimap
{
   import components.base.viewport.Viewport;
   import components.base.viewport.events.ViewportEvent;
   import components.map.CMap;
   import components.map.controllers.IMapViewportController;
   import components.map.events.MapChangeEvent;
   import components.markers.IActiveCursorUser;
   
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.geom.Point;
   import flash.utils.Timer;
   
   import mx.core.UIComponent;
   import mx.events.ResizeEvent;
   
   import spark.components.supportClasses.SkinnableComponent;
   
   
   /**
    * <b>DO NOT USE: Does not work.</b>
    */
   public class Minimap extends SkinnableComponent implements IActiveCursorUser, IMapViewportController
   {
      private static const TIMER:Timer = new Timer(5000);
      
      
      private var flags:Object = new Object();
      
      
      /**
       * If this is set to true, minimap won't react to any events comming from the viewport. Needed in order
       * interaction with minimap to be possible.
       */ 
      private var f_DisableViewportEvents:Boolean = false;
      
      
      /**
       * Component that represents the whole map in the minimap. 
       */	   
      [SkinPart (required="true")]
      public var mapArea:MapArea = null;
      
      
      /**
       * This component indicates area of a map that is seen in the viewport.
       */	   
      [SkinPart (required="true")]
      public var viewportIndicator:UIComponent = null;
      
      
      public function setViewport(viewport:Viewport) : void
      {
         this.viewport = viewport;
      }
      
      
      public function cleanup() : void
      {
         viewport = null;
      }
      
      
      private var _oldViewport:Viewport = null;
      private var _viewport:Viewport = null;
      /**
       * Instance of <code>Viewport<code> this minimap is bound with.
       */
      [Bindable]
      public function set viewport(value:Viewport) : void
      {
         if (!flags.viewportChanged)
         {
            _oldViewport = _viewport;
         }
         _viewport = value;
         flags.viewportChanged = true;
         invalidateProperties ();
         invalidateDisplayList ();
      }
      /**
       * @private 
       */      
      public function get viewport() : Viewport
      {
         return _viewport;
      }
      
      
      
      
      /**
       * Constructor. 
       */      
      public function Minimap ()
      {
         addEventListener(ResizeEvent.RESIZE, this_resizeHandler);
         addEventListener(MouseEvent.ROLL_OVER, this_rollOverHandler);
         addEventListener(MouseEvent.ROLL_OUT, this_rollOutHandler);
         addEventListener(MouseEvent.MOUSE_DOWN, this_mouseDownHandler);
         addEventListener(MouseEvent.MOUSE_MOVE, this_mouseMoveHandler);
         addEventListener(Event.ENTER_FRAME, this_enterFrameHandler);
         addEventListener(Event.EXIT_FRAME, this_exitFrameHandler);
         addTimerEventHandlers();
         if (!TIMER.running)
         {
            TIMER.start();
         }
      }
      
      
      override protected function commitProperties() : void
      {
         super.commitProperties();
         if (flags.viewportChanged)
         {
            // Remove event listener form the old viewport if one existed.
            if (_oldViewport)
            {
               removeViewportHandlers(_oldViewport);
               removeMapHandlers(CMap(_oldViewport.content));
            }
            
            // Register same event listeners with a new viewport
            if (_viewport)
            {
               addViewportHandlers(_viewport);
               addMapHandlers(CMap(_viewport.content));
            }
            
            _oldViewport = null;
            
            // Do stuff that i haven't figured out yet.
         }
         
         flags = new Object ();
      }
      
      
      private var _mapPosition:Point = new Point();
      override protected function updateDisplayList(uw:Number, uh:Number) : void
      {
         super.updateDisplayList(uw, uh);
         var map:CMap = CMap(viewport.content)
         
         // TODO: figure out what to do when there is no map or whole viewport
         // Resize and position the mapArea component
         if (mapArea && viewport && map)
         {
            var sizeRatio:Number = Math.min(uw / map.scaledWidth, uh / map.scaledHeight);
            mapArea.setActualSize(Math.round(map.scaledWidth * sizeRatio), Math.round(map.scaledHeight * sizeRatio));
            
            // Center mapArea in the minimap
            mapArea.move(Math.round((uw - mapArea.width)  / 2), Math.round((uh - mapArea.height) / 2));
         }
         
         
         // Now viewportIndicator
         if (viewportIndicator && viewport && map)
         {
            var widthRatio:Number = viewport.width / map.scaledWidth;
            var heightRatio:Number = viewport.height / map.scaledHeight;
            
            viewportIndicator.setActualSize(mapArea.width * widthRatio, mapArea.height * heightRatio);
            
            var newX: Number = _mapPosition.x * (-1) * mapArea.width / map.scaledWidth + mapArea.x;
            var newY: Number = _mapPosition.y * (-1) * mapArea.height / map.scaledHeight + mapArea.y;
            
            viewportIndicator.move(newX, newY);
         }
      }
      
      
      
      
      // ###################### //
      // ### EVENT HANDLERS ### //
      // ###################### //
      
      
      private function addViewportHandlers(viewport:Viewport) : void
      {
         if (!viewport)
         {
            return;
         }
         viewport.addEventListener(ResizeEvent.RESIZE, viewport_resizeHandler);
         viewport.addEventListener(ViewportEvent.CONTENT_CHANGE, viewport_contentChangeHandler);
         viewport.addEventListener(ViewportEvent.CONTENT_RESIZE, viewport_contentResizeHandler);
         viewport.addEventListener(ViewportEvent.CONTENT_MOVE, viewport_contentMoveHandler);
      }
      private function removeViewportHandlers(viewport:Viewport) : void
      {
         if (!viewport)
         {
            return;
         }
         viewport.removeEventListener(ResizeEvent.RESIZE, viewport_resizeHandler);
         viewport.removeEventListener(ViewportEvent.CONTENT_CHANGE, viewport_contentChangeHandler);
         viewport.removeEventListener(ViewportEvent.CONTENT_RESIZE, viewport_contentResizeHandler);
         viewport.removeEventListener(ViewportEvent.CONTENT_MOVE, viewport_contentMoveHandler);
      }
      private function addMapHandlers(map:CMap) : void
      {
         if (!map)
         {
            return;
         }
         map.addEventListener(MapChangeEvent.MAP_DATA_CHANGE, map_mapDataChange);
      }
      private function removeMapHandlers(map:CMap) : void
      {
         if (!map)
         {
            return;
         }
         map.removeEventListener(MapChangeEvent.MAP_DATA_CHANGE, map_mapDataChange);
      }
      
      
      private function this_resizeHandler(event:ResizeEvent) : void
      {
         invalidateDisplayList();
      }
      
      
      private function viewport_resizeHandler(event:ResizeEvent) : void
      {
         invalidateDisplayList();
      }
      
      
      private function viewport_contentChangeHandler(event:ViewportEvent) : void
      {
         mapArea.snapshot.source = null;
         removeMapHandlers(CMap(event.contentOld));
         addMapHandlers(CMap(event.contentNew));
         invalidateDisplayList();
      }
      
      
      private function viewport_contentResizeHandler(event:ViewportEvent) : void
      {
         if (!f_DisableViewportEvents)
         { 
            invalidateDisplayList();
         }
      }
      
      
      private function viewport_contentMoveHandler(event:ViewportEvent) : void
      {
         if (!f_DisableViewportEvents)
         {
            _mapPosition = event.contentPosition;
            invalidateDisplayList();
         }
      }
      
      
      private function addTimerEventHandlers() : void
      {
         TIMER.addEventListener(TimerEvent.TIMER, TIMER_timerEventHandler);
      }
      
      
      private function removeTimerEventHandlers() : void
      {
         TIMER.removeEventListener(TimerEvent.TIMER, TIMER_timerEventHandler);
      }
      
      
      private function TIMER_timerEventHandler(event:TimerEvent) : void
      {
         takeMapSnapshot();
      }
      
      
      private function takeMapSnapshot() : void
      {
         if (mapArea && viewport && viewport.content)
         {
            mapArea.snapshot.takeSnapshot(CMap(viewport.content).getSnapshotComponent());
         }
      }
      
      
      private var _snapshotComponent:UIComponent = null;
      private var _fTakeSnapshotThisFrame:Boolean = false;
      private var _fTakeSnapshotNextFrame:Boolean = false;
      private function map_mapDataChange(event:MapChangeEvent) : void
      {
         _snapshotComponent = event.target as UIComponent;
         _fTakeSnapshotNextFrame = true;
      }
      
      
      private function this_exitFrameHandler(event:Event) : void
      {
         if (_fTakeSnapshotNextFrame)
         {
            _fTakeSnapshotNextFrame = false;
            _fTakeSnapshotThisFrame = true;
         }
      }
      
      
      private function this_enterFrameHandler(event:Event) : void
      {
         if (_fTakeSnapshotThisFrame)
         {
            mapArea.snapshot.takeSnapshot(_snapshotComponent);
            _fTakeSnapshotThisFrame = false;
            _snapshotComponent = null;
         }
      }
      
      
      
      
      // ############################### //
      // ### DIRECT USER INTERACTION ### //
      // ############################### //
      
      
      // When mouse is over the minimap, disable viewport events
      private function this_rollOverHandler(event:MouseEvent) : void
      {
          f_DisableViewportEvents = true;
      }
      
      
      // When mouse is outside the minimap, enable viewport events
      // And just in case enable click event
      private function this_rollOutHandler(event:MouseEvent) : void
      {
         f_DisableViewportEvents = false;
      }
      
      
      private function this_mouseDownHandler(event:MouseEvent) : void
      {
         moveToMouse();
      }
      
      
      private function this_mouseMoveHandler(event:MouseEvent) : void
      {
         if (event.buttonDown)
         {
            moveToMouse();
         }
      }
      
      
      /**
       * Moves viewport indicator to current mouse position (center of the
       * indicator will be in the same place as the mouse pointer if possible)
       * and then moves the map to appropriate position as well. 
       */      
      private function moveToMouse() : void
      {
         // Nothing to move
         if (!viewportIndicator || !viewport || !viewport.content)
         {
            return;
         }
         
         // Extra space calculation. Complex. DO NOT TOUCH.
         var extraMoveSpaceX:Number = viewport.paddingHorizontal / viewport.width  * viewportIndicator.width;
         var extraMoveSpaceY:Number = viewport.paddingVertical / viewport.height * viewportIndicator.height;
         
         var x:Number = mouseX - viewportIndicator.width  / 2;
         var y:Number = mouseY - viewportIndicator.height / 2;
         
         // Check the bounds and fix if necessary
         if (x < mapArea.x - extraMoveSpaceX)
         {
            x = mapArea.x - extraMoveSpaceX;
         }
         else if (x + viewportIndicator.width > mapArea.x + mapArea.width + extraMoveSpaceX)
         {
            x = mapArea.x + mapArea.width - viewportIndicator.width + extraMoveSpaceX;
         }
         if (y < mapArea.y - extraMoveSpaceY)
         {
            y = mapArea.y - extraMoveSpaceY;
         }
         else if (y + viewportIndicator.height > mapArea.y + mapArea.height + extraMoveSpaceY)
         {
            y = mapArea.y + mapArea.height - viewportIndicator.height + extraMoveSpaceY;
         }
         
         // Move indicator
         viewportIndicator.move(Math.round(x), Math.round(y));
         
         // Move the map
         _mapPosition = new Point(
            Math.round((mouseX - mapArea.x) / mapArea.width  * viewport.content.getExplicitOrMeasuredWidth()),
            Math.round((mouseY - mapArea.y) / mapArea.height * viewport.content.getExplicitOrMeasuredHeight())
         );
         viewport.moveContentTo(_mapPosition);
      }
   }
}