package components.map.controllers
{
   import com.developmentarc.core.utils.EventBroker;
   
   import components.map.LayeredBackground;
   import components.map.CMap;
   import components.map.controllers.events.MapViewportEvent;
   import components.map.events.MapEvent;
   
   import flash.events.MouseEvent;
   
   import globalevents.GlobalEvent;
   
   import mx.core.FlexGlobals;
   import mx.core.UIComponent;
   import mx.events.FlexEvent;
   import mx.events.ResizeEvent;
   
   import spark.components.SkinnableContainer;
   import spark.effects.Move;
   import spark.layouts.BasicLayout;
   
   
   /**
    * Dispatched when zoom changes.
    * 
    * @eventType components.map.events.MapEvent.MAP_SCALE_CHANGE 
    */
   [Event(name="mapScaleChange", type="components.map.events.MapEvent")]
   
   
   /**
    * Dispatched when user clicks on an empty space of a viewport.
    * 
    * @eventType components.map.constrollers.events.MapViewportEvent.CLICK_EMPTY_SPACE
    */
   [Event(name="clickEmptySpace", type="components.map.controllers.events.MapViewportEvent")]
   
   
   /**
    * <b>DEPRECATED: use <code>components.base.Viewport</code> and
    * <code>components.base.ViewportZoomable</code>.</b>
    * Component that shows only a part of any <code>UIComponent</code>
    * instance and lets moving it around, zooming in and out and doing other
    * similar stuff that is typical for maps in games.
    * 
    * <p>
    * This component uses following events events:
    * <ul>
    *    <li>
    *       MouseEvent.MOUSE_DOWN - for starting the map drag
    *    </li>
    *    <li>
    *       MouseEvent.MOUSE_MOVE - for moving the map around
    *    </li>
    *    <li>MouseEvent.MOUSE_WHEEL - for zooming in and out.</li>
    *    <li>
    *       ResizeEvent.RESIZE - for recalculating minimal scale value.
    *       Registers listener with itself as well as with the map component.
    *    </li>
    * </ul>
    * </p>
    * 
    * <p>The map won't be moved and won't support zoom if (until) it's both
    * dimentions (width and height) are smaller than dimentions of the
    * viewport.</p>
    */   
   public class MapViewport extends SkinnableContainer
   {
      private static const ZOOM_SPEED:Number = 0.025;
      
      
      private var _moveEffect:Move;
      
      
      /* ###################### */
      /* ### INITIALIZATION ### */
      /* ###################### */
      
      
      /**
       * Constructor. 
       */      
      public function MapViewport(map:CMap)
      {
         super();
         
         if (map == null)
         {
            throw new ArgumentError("You must provide valid BaseMap instance");
         }
         
         left = right = top = bottom = 0;
         layout = new BasicLayout();
         
         _moveEffect = new Move();
         _moveEffect.duration = 500;
         
         // Creation complete
         addEventListener(FlexEvent.CREATION_COMPLETE, this_creationCompleteHandler);
         
         // Map drag events
         addEventListener(MouseEvent.CLICK, handleClickEventPropagation, true);
         addEventListener(MouseEvent.CLICK, this_clickEventHandler);
         addEventListener(MouseEvent.MOUSE_DOWN, initializeMapDrag, true);
         addEventListener(MouseEvent.MOUSE_UP, stopMapDrag, true);
         addEventListener(MouseEvent.ROLL_OUT, stopMapDrag);
         
         // Map zoom events
         addEventListener(ResizeEvent.RESIZE, this_resizeHandler);
         addEventListener(MouseEvent.MOUSE_WHEEL, changeZoom);
         
         addGlobalEventHandlers();
         
         // Initialize map
         _map = map;
         _map.viewport = this;
         _moveEffect.target = map;
         addElement(map);
         
         // Create layered background if one is needed
         if (map.showLayeredBackground)
         {
            _layeredBackground = new LayeredBackground(this);
            _layeredBackground.depth = -10;
            addElement(_layeredBackground);
         }
      }
      
      
      public function cleanup() : void
      {
         if (_map)
         {
            _map.cleanup();
            _map = null;
         }
         removeGlobalEventHandlers();
      }
      
      
      private function this_creationCompleteHandler(event:FlexEvent) : void
      {
         setMinScale();
         zoomToDefault();
         centerMap();
      }
      
      
      /* ############### */
      /* ### OBJECTS ### */
      /* ############### */
      
      
      /**
       * Fancy layered background for solar system and galaxy maps.
       */
      private var _layeredBackground:LayeredBackground = null;
      
      
      private var _map:CMap = null;
      [Bindable("willNotChange")]
      /**
       * A map controled by this viewport.
       */
      public function get map() : CMap
      {
         return _map;
      }
      
      
      
      /* ################## */
      /* ### PROPERTIES ### */
      /* ################## */
      
      
      private var _extraMapMoveSpace:Number = 200;
      /**
       * Indicates how far a map can be moved from the border of a <code>MapViewport</code>
       * to its center before it is stopped. 
       */
      public function set extraMapMoveSpace(v:Number) : void
      {
         _extraMapMoveSpace = v;
         _fExtraMapMoveSpaceChanged = true;
         invalidateProperties();
      }
      /**
       * @private 
       */
      public function get extraMapMoveSpace() : Number
      {
         return _extraMapMoveSpace;
      }
      
      
      private var _minScale:Number = 1;
      /**
       * Scale value for which the whole map is seen in the viewport.
       * 
       * @default 1 
       */
      public function get minScale():Number
      {
         return _minScale;
      }
      
      
      private var _fExtraMapMoveSpaceChanged:Boolean = true;
      override protected function commitProperties () :void
      {
         super.commitProperties ();
         
         // Fix map position
         if (_fExtraMapMoveSpaceChanged)
         {
            moveMapBy(0, 0);
         }
         
         _fExtraMapMoveSpaceChanged = false;
      }
      
      
      /* ######################### */
      /* ### Moving map around ### */
      /* ######################### */
      
      
      /**
       * Centers the map in the viewport. 
       */      
      public function centerMap() : void
      {
         if (_map)
         {
            _map.move(
               (width - _map.scaledWidth) / 2,
               (height - _map.scaledHeight) / 2
            );
         }
      }
      
      
      /**
       * Moves the map by the given amount of pixels. 
       * 
       * @param deltaX 
       * @param deltaY
       * @param useMoveEffect indicates if map should be moved gradually (true)
       * or instantly (false)
       */      
      public function moveMapBy(deltaX:Number, deltaY:Number, useMoveEffect:Boolean = false) : void
      {
         // If there is no map then there is nothing to move
         if (!_map)
         {
            return;
         }
         
         var newX: Number = _map.x + deltaX;
         var newY: Number = _map.y + deltaY;
         
         // Map is smaller than the viewport so move it to center
         if (width > _map.scaledWidth + extraMapMoveSpace * 2)
         {
            newX = (width - _map.scaledWidth) / 2;
         }
         // Left bound reached
         else if (newX > extraMapMoveSpace)
         {
            newX = extraMapMoveSpace;
         }
         // Right bound reached
         else if (newX + _map.scaledWidth + extraMapMoveSpace < width)
         {
            newX = width - _map.scaledWidth - extraMapMoveSpace;
         }
         
         // Map is smaller than the viewport so move it to center
         if (height > _map.scaledHeight + extraMapMoveSpace * 2)
         {
            newY = (height - _map.scaledHeight) / 2;
         }
         // Top bound reached
         else if (newY > extraMapMoveSpace)
         {
            newY = extraMapMoveSpace;
         }
         // Bottom bound reached
         else if (newY + _map.scaledHeight + extraMapMoveSpace < height)
         {
            newY = height - _map.scaledHeight - extraMapMoveSpace;
         }
         
         newX = Math.round (newX);
         newY = Math.round (newY);
         
         // Now move the map as we know its new coordinates
         if (useMoveEffect)
         {
            _moveEffect.end();
            _moveEffect.xFrom = _map.x;
            _moveEffect.yFrom = _map.y;
            _moveEffect.xTo = newX;
            _moveEffect.yTo = newY;
            _moveEffect.play();
         }
         else
         {
            _moveEffect.end ();
            _map.move(newX, newY);
         }
      }
      
      
      /**
       * Moves the map to a given coordinates (ensures these coordinates appear
       * at the center of a viewport or at least are visible if bounds of the
       * map are reached). Coordinate must be provided with respect to
       * <strong>unscaled</strong> dimentions of the map.
       * 
       * @param x Coordinate x that should be seen in the viewport after the map
       * has been moved.
       * @param y Coordinate y that should be seen in the viewport after the map
       * has been moved.
       * @param useMoveEffect indicates if map should be moved gradually (true)
       * or instantly (false)
       */      
      public function moveMapTo(x:Number, y:Number, useMoveEffect:Boolean = false) : void
      {
         // If there is no map then there is nothing to move
         if (!_map)
         {
            return;
         }
         
         moveMapBy(
            width / 2 - x * _map.scaleX - _map.x,
            height / 2 - y * _map.scaleY - _map.y,
            useMoveEffect
         );
      }
      
      
      /**
       * Indicates if the map is beeing draged with a mouse. 
       */      
      private var _fMapOnDrag: Boolean = false;
      
      
      /**
       * Old mouse coordinates (global Stage) before the MOUSE_MOVE event.
       */
      private var oldMouseX: Number = 0;
      private var oldMouseY: Number = 0;
      
      
      private function initializeMapDrag(event:MouseEvent) : void
      {
         if (_map && event.buttonDown)
         {
            _fMapOnDrag = true;
            addEventListener (MouseEvent.MOUSE_MOVE, doMapDrag, true);
            
            oldMouseX = UIComponent(FlexGlobals.topLevelApplication).mouseX;
            oldMouseY = UIComponent(FlexGlobals.topLevelApplication).mouseY;
         }
      }
      
      
      private function doMapDrag(event:MouseEvent) : void
      {
         if (_fMapOnDrag && _map && event.buttonDown)
         {
            var mouseX: Number =
               (FlexGlobals.topLevelApplication as UIComponent).mouseX;
            var mouseY: Number =
               (FlexGlobals.topLevelApplication as UIComponent).mouseY;
            
            moveMapBy (mouseX - oldMouseX, mouseY - oldMouseY);
            
            oldMouseX = mouseX;
            oldMouseY = mouseY;
            
            fMapMoved = true;
            
            event.stopImmediatePropagation();
         }
      }
      
      
      private function stopMapDrag(event:MouseEvent = null) : void
      {
         _fMapOnDrag = false;
         removeEventListener(MouseEvent.MOUSE_MOVE, doMapDrag);
      }
      
      
      /* ############### */
      /* ### ZOOMING ### */
      /* ############### */
      
      
      /**
       * Zooms map in by predefined step value. 
       */
      public function zoomIn() : void
      {
         changeMapScale(_currentScale + ZOOM_SPEED * 5);
      }
      
      
      /**
       * Zooms map out by predefined step value.
       */      
      public function zoomOut() : void
      {
         changeMapScale(_currentScale - ZOOM_SPEED * 5);
      }
      
      
      /**
       * Scales the map so that it whole fits into the viewport. 
       */      
      public function zoomToFit() : void
      {
         changeMapScale(minScale);
      }
      
      
      /**
       * Changes zoom level of the map: makes it of default scale.
       */ 
      public function zoomToDefault() : void
      {
         changeMapScale(_map.getDefaultScale());
      }
      
      
      /**
       * Current zoom level (from minScale to 1).
       */
      private var _currentScale:Number = 1;
      
      
      /**
       * Indicates if current map scale (zoom) is valid. It might not be valid
       * after map or viewport is resized.
       */      
      private function get currentScaleValid() : Boolean
      {
         return _currentScale >= minScale && _currentScale <= 1;
      }
      
      
      /**
       * Changes the scale of a map if possible and moves it so that the same
       * point before scaling appears in the same place as the mouse pointer
       * after scaling as well (or in the center of a viewport if mouse is not
       * over the viewport).
       * 
       * @param newScale new scale value (zoom level) for the map
       * @param toMouse If true, map will be zoomed in/out to the mouse pointer,
       * false - to the point that is currently in the center of a viewport.
       */
      public function changeMapScale(newScale:Number, toMouse:Boolean = false) : void
      {
         // No zoom if there is no map.
         // No zoom if the map is smaller thant the viewport.
         if (!_map || minScale == 1)
         {
            return;
         }
         
         // Just in case scale is out of bounds
         if (newScale < minScale ||
             Math.abs (newScale - minScale) < minScale * 0.01)
         {
            newScale = minScale;
         }
         else if (newScale > 1)
         {
            newScale = 1;
         }
         
         // Abort scaling procedure if scale will not change after it
         // Otherwise the code will cause map to move around like crazy...
         if (newScale == _currentScale && currentScaleValid)
         {
            return;
         }
         
         // Take only first 10 digits
         newScale = Math.ceil (newScale * 10000000000) / 10000000000;
         
         // Find out how much the map will have to be moved after scaling.
         var moveByX: Number = 0;
         var moveByY: Number = 0;
         if (toMouse)
         {
            moveByX = _map.mouseX * (_currentScale - newScale);
            moveByY = _map.mouseY * (_currentScale - newScale);
         }
         else
         {
            moveByX = (width  / 2 - _map.x) * (1 - newScale / _currentScale);
            moveByY = (height / 2 - _map.y) * (1 - newScale / _currentScale);
         }
         
         // Change the scale of a map and update currentScale.
         _map.scaleX = newScale;
         _map.scaleY = newScale;
         _currentScale = newScale;
         
         dispatchEvent(new MapEvent(MapEvent.MAP_SCALE_CHANGE));
         
         // Finally move that map back to it's original point.
         moveMapBy (moveByX, moveByY);
      }
      
      
      private function changeZoom(event:MouseEvent) :void
      {
         // Zoom is available only if map is present and it is bigger then the
         // viewport.
         if (_map && minScale < 1)
         {
            changeMapScale (_currentScale + event.delta * ZOOM_SPEED, true);
         }
         
         event.stopImmediatePropagation ();
      }
      
      
      /**
       * Sets minScale according to viewport's and map's dimentions.
       * Called when map is changed or it is resized or viewport is resized. 
       */
      private function setMinScale () :void
      {
         // Nothing to update if there is no map
         if (!_map)
         {
            _minScale = 1;
            return;
         }
         
         // 1 will be set if the map's both dimentions are smaller than
         // of the viewport.
         _minScale = Math.min (
            width  / _map.width,
            height / _map.height,
            1
         );
         
         // After viewport is resized, the map might end up in a position
         // where one or more of it's borders are in the middle of a viewport so
         // need to fix that.
         changeMapScale(_currentScale);
      }
      
      
      /* ###################### */
      /* ### OTHER HANDLERS ### */
      /* ###################### */
      
      
      private function this_resizeHandler(event:ResizeEvent) : void
      {
         setMinScale();
         centerMap();
      }
      
      /**
       * Flag that is set to true if map has been moved. It is set in the
       * <code>doMapDrag()</code> method and should be only unset in
       * <code>handleClickEventPropagation()</code> method.
       */
      private var fMapMoved:Boolean = false;
      private function handleClickEventPropagation(event:MouseEvent) : void
      {
         if (fMapMoved)
         {
            fMapMoved = false;
            event.stopImmediatePropagation();
         }
      }
      
      
      private function this_clickEventHandler(event:MouseEvent) : void
      {
         if (event.target == contentGroup || event.target == this)
         {
            dispatchEvent(new MapViewportEvent(MapViewportEvent.CLICK_EMPTY_SPACE));
         }
      }
      
      /* ############################# */
      /* ### GLOBAL EVENT HANDLERS ### */
      /* ############################# */
      
      
      private function addGlobalEventHandlers() : void
      {
         EventBroker.subscribe(GlobalEvent.APP_RESET, global_appResetHandler);
      }
      
      
      private function removeGlobalEventHandlers() : void
      {
         EventBroker.unsubscribe(GlobalEvent.APP_RESET, global_appResetHandler);
      }
      
      
      private function global_appResetHandler(event:GlobalEvent) : void
      {
         cleanup();
      }
   }
}