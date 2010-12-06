package components.base.viewport
{
   import flash.errors.IllegalOperationError;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   
   import mx.events.FlexEvent;
   import mx.events.ResizeEvent;
   
   
   public class ViewportZoomable extends Viewport
   {
      private static const ZOOM_STEP:Number = 0.025;
      private static const ZOOM_EFFECT_DURATION:Number = 500;
      
      
      /* ###################### */
      /* ### INITIALIZATION ### */
      /* ###################### */
      
      
      public function ViewportZoomable()
      {
         super();
         super.useScrollBars = false;
      }
      
      
      /* ################## */
      /* ### PROPERTIES ### */
      /* ################## */
      
      
      /**
       * Read-only property.
       * 
       * @copy Viewport#useScrollBars
       */
      public override function set useScrollBars(value : Boolean) : void
      {
         throw IllegalOperationError("[prop useScrollBars] is read only");
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
      
      
      /* ############### */
      /* ### ZOOMING ### */
      /* ############### */
      
      
      public function zoomPoint(point:Point, useAnimation:Boolean = false, animationCompleteHandler:Function = null) : void
      {
         zoomArea(new Rectangle(point.x, point.y, 1, 1), useAnimation, animationCompleteHandler);
      }
      
      
      /**
       * Positions and zooms viewport's content so that the given area is in the center of the viewport
       * or at least visible in the viewport. Coordinates of the area must be provided with respect
       * to <strong>unscaled</strong> dimentions of the viewport content.
       */
      public function zoomArea(area:Rectangle, useAnimation:Boolean = false, animationCompleteHandler:Function = null) : void
      {
         var centerPoint:Point = new Point(
            Math.floor((area.left + area.right) / 2),
            Math.floor((area.top + area.bottom) / 2)
         );
         changeContentScale(
            Math.min(width / area.width, height / area.height), centerPoint,
            function() : void { moveContentTo(centerPoint, useAnimation, animationCompleteHandler); }
         );
      }
      
      
      /**
       * Zooms content in by predefined step value. 
       */
      public function zoomIn() : void
      {
         changeContentScale(_currentScale + ZOOM_STEP * 5, centerPointViewport_CCS());
      }
      
      
      /**
       * Zooms content out by predefined step value.
       */      
      public function zoomOut() : void
      {
         changeContentScale(_currentScale - ZOOM_STEP * 5, centerPointViewport_CCS());
      }
      
      
      /**
       * Scales the map so that it whole fits into the viewport. 
       */      
      public function zoomToFit() : void
      {
         changeContentScale(minScale, centerPointViewport_CCS());
      }
      
      
      /**
       * Changes zoom level of the content: makes it of default scale.
       */
      public function zoomToDefault() : void
      {
         changeContentScale(1, centerPointViewport_CCS());
      }
      
      
      /**
       * Current zoom level (from <code>minScale</code> to <code>1</code>).
       */
      private var _currentScale:Number = 1;
      
      
      /**
       * Indicates if current content scale (zoom) is valid. It might not be valid
       * after content or viewport is resized.
       */      
      private function get currentScaleValid() : Boolean
      {
         return _currentScale >= minScale && _currentScale <= 1;
      }
      
      
      /**
       * Changes the scale of a content if possible and moves it so that the <code>lockedPoint</code>
       * before scaling appears in the same place after scaling.
       * 
       * @param newScale new scale value (zoom level) for the content
       * @param lockedPoint a point to wich view should be zoomed in or out (point wich will not be
       * moved during zooming)
       * @param zoomCommitHandler function to call when actually the content has been scaled
       * and its position has been fixed after scaling
       */
      public function changeContentScale(newScale:Number, lockedPoint:Point, zoomCommitHandler:Function = null) : void
      {
         function callZoomCommitHandler() : void
         {
            if (zoomCommitHandler != null)
            {
               zoomCommitHandler();
            }
         }
         
         // no zoom if there is no content
         // no zoom if the content is smaller than the viewport
         if (!content || minScale == 1)
         {
            return;
         }
         
         // just in case scale is out of bounds
         if (newScale < minScale || Math.abs(newScale - minScale) < minScale * 0.01)
         {
            newScale = minScale;
         }
         else if (newScale > 1)
         {
            newScale = 1;
         }
         
         // abort scaling procedure if scale will not change after it
         // otherwise the code below will cause map to move around like crazy
         if (newScale == _currentScale && currentScaleValid)
         {
            callZoomCommitHandler();
            return;
         }
         
         // take only first 10 digits
         newScale = Math.ceil(newScale * 10000000000) / 10000000000;
         
         // find out how much content will have to be moved after scaling
         var moveBy:Point = new Point(
            lockedPoint.x * (_currentScale - newScale) / newScale,
            lockedPoint.y * (_currentScale - newScale) / newScale
         );
         
         // change the scale of the content and update currentScale
         content.scaleX = newScale;
         content.scaleY = newScale;
         _currentScale = newScale;
         
         // finally, move the content back to it's original point
         // Reason for callLater(): moveContentBy() which manipulates horizontalScrollPosition and
         // verticalScrollPosition does not work because new values are effetively canceled by
         // Flex because when they are set, content's size (and probably other properties) has not been
         // recalculated after new scale value has been applied. content.validateNow() does not help
         // either
         callLater(
            function() : void
            {
               moveContentBy(moveBy);
               callZoomCommitHandler();
            }
         );
      }
      
      
      private function changeZoom(event:MouseEvent) : void
      {
         // zoom is available only if content is present and it is bigger than the viewport
         if (content && minScale < 1)
         {
            changeContentScale(_currentScale + event.delta * ZOOM_STEP, contentMouseCoordinates());
         }
      }
      
      
      /**
       * Sets minScale according to viewport and contentContainer dimensions.
       * Called when content is changed or it is resized or viewport is resized. 
       */
      private function setMinScale() : void
      {
         // nothing to update if there is no content
         if (!content)
         {
            _minScale = 1;
            return;
         }
         
         // 1 will be set if content's both dimentions are smaller than
         // of the viewport.
         _minScale = Math.min(
            (width - paddingHorizontal * 2) / content.getExplicitOrMeasuredWidth(),
            (height - paddingVertical * 2) / content.getExplicitOrMeasuredHeight(),
            1
         );
         
         // after viewport is resized, the content might end up in a position
         // where one or more of it's borders are in the middle of a viewport so we
         // need to fix that
         changeContentScale(_currentScale, centerPointViewport_CCS());
      }
      
      
      private function contentMouseCoordinates() : Point
      {
         return new Point(content.mouseX, content.mouseY);
      }
      
      
      /* ########################### */
      /* ### SELF EVENT HANDLERS ### */
      /* ########################### */
      
      
      protected override function addSelfEventHandlers() : void
      {
         super.addSelfEventHandlers();
         addEventListener(MouseEvent.MOUSE_WHEEL, this_mouseWheelHandler);
      }
      
      
      protected override function removeSelfEventHandlers() : void
      {
         removeEventListener(MouseEvent.MOUSE_WHEEL, this_mouseWheelHandler);
         super.removeSelfEventHandlers();
      }
      
      
      protected override function this_creationCompleteHandler(event:FlexEvent) : void
      {
         super.this_creationCompleteHandler(event);
         setMinScale();
         zoomToDefault();
      }
      
      
      protected override function this_resizeHandler(event:ResizeEvent) : void
      {
         super.this_resizeHandler(event);
         setMinScale();
      }
      
      
      protected override function content_resizeHandler(event:Event) : void
      {
         super.content_resizeHandler(event);
         setMinScale();
      }
      
      
      private function this_mouseWheelHandler(event:MouseEvent) : void
      {
         if (event.isDefaultPrevented())
         {
            return;
         }
         changeZoom(event);
      }
   }
}