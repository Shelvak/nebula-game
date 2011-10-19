package components.base.viewport
{
   import flash.geom.Point;
   import flash.geom.Rectangle;
   
   import utils.GeomUtils;
   import utils.Objects;

   /**
    * An object that keeps track of visible area of the content of a <code>Viewport</code> and reports
    * results to <code>IVisibleAreaTrackerClient</code>.
    */
   public class VisibleAreaTracker
   {
      private var _client:IVisibleAreaTrackerClient = null;
      private var _viewportSize:Point;
      private var _contentRect:Rectangle;
      private var _contentScale:Number;
      private var _clippedArea:ClippedArea;
      
      public function VisibleAreaTracker(client:IVisibleAreaTrackerClient) {
         _client = Objects.paramNotNull("client", client);
      }
      
      /**
       * Called only once when viewport and content have been initialized, sized, positioned.
       * 
       * @param viewportWidth width of a viewport | <b>positive, 0 allowed</b>
       * @param viewportHeight height of a viewport | <b>positive, 0 allowed</b>
       * @param contentX X coordinate of a content in viewport coordinate space
       * @param contentY Y coordinate of a content in viewport coordinate space
       * @param contentWidth width of content (not scaled) | <b>positive, 0 allowed</b>
       * @param contentHeight height of content (not scaled) | <b>positive, 0 allowed</b>
       * @param contentScale initial scale of a content | <b>range (0, 1]</b>
       */
      public function contentInitialized(viewportWidth:int,
                                         viewportHeight:int,
                                         contentX:int,
                                         contentY:int,
                                         contentWidth:int,
                                         contentHeight:int,
                                         contentScale:Number) : void {
         _viewportSize = new Point(
            assertSizeParam("viewportWidth", viewportWidth),
            assertSizeParam("viewportHeight", viewportHeight)
         );
         _contentRect = new Rectangle(
            contentX,
            contentY,
            assertSizeParam("contentWidth", contentWidth),
            assertSizeParam("contentHeight", contentHeight)
         );
         _contentScale = assertScaleParam("contentScale", contentScale);
         _clippedArea = new ClippedArea(_viewportSize, _contentRect, _contentScale);
         if (!_clippedArea.voidArea) {
            _client.visibleAreaChange(
               _clippedArea.rectangle,
               new Vector.<Rectangle>(),
               Vector.<Rectangle>([_clippedArea.rectangle])
            );
         }
      }
      
      /**
       * Called when position of the content has changed.
       * 
       * @param newX new X coordinate
       * @param newY new Y coordinate
       */
      public function updateContentPosition(newX:int, newY:int) : void {
         _contentRect.x = newX;
         _contentRect.y = newY;
      }
      
      /**
       * Called when scale of the content of a viewport has changed (content has been zoomed in or out).
       * 
       * @param newScale new scale of the content | <b>range (0, 1] </b>
       */
      public function updateContentScale(newScale:Number) : void {
         _contentScale = assertScaleParam("newScale", newScale);
      }
      
      /**
       * Called when size of the viewport has changed.
       * 
       * @param newWidth new width of the viewport | <b>positive, 0 allowed</b>
       * @param newHeight new height of the viewport | <b>positive, 0 allowed</b>
       */
      public function updateViewportSize(newWidth:int, newHeight:int) : void {
         _viewportSize.x = assertSizeParam("newWidth", newWidth);
         _viewportSize.y = assertSizeParam("newHeight", newHeight);
      }
      
      /**
       * Called when content position, size, scale or viewport size have changed to apply all those changes
       * and notify client about the change. 
       */
      public function updateComplete() : void {
         var oldArea:ClippedArea = _clippedArea;
         var newArea:ClippedArea = new ClippedArea(_viewportSize, _contentRect, _contentScale);
         if (oldArea.equals(newArea) ||
             oldArea.voidArea && newArea.voidArea) {
            return;
         }
         _clippedArea = newArea;
         if (oldArea.voidArea && !newArea.voidArea) {
            _client.visibleAreaChange(
               _clippedArea.rectangle,
               new Vector.<Rectangle>(),
               Vector.<Rectangle>([newArea.rectangle])
            );
         }
         else if (!oldArea.voidArea && newArea.voidArea) {
            _client.visibleAreaChange(
               _clippedArea.rectangle,
               Vector.<Rectangle>([oldArea.rectangle]),
               new Vector.<Rectangle>()
            );
         }
         else {
            var oldRect:AreaRectangle = oldArea.rectangle;
            var newRect:AreaRectangle = newArea.rectangle;
            _client.visibleAreaChange(
               _clippedArea.rectangle,
               oldRect.substract(newRect),
               newRect.substract(oldRect)
            );
         }
      }
      
      
      /* ############### */
      /* ### HELPERS ### */
      /* ############### */
      
      private function assertScaleParam(paramName:String, paramValue:Number) : Number {
         return Objects.paramInRangeNumbers(paramName, 0, 1, paramValue, false, true);
      }
      
      private function assertSizeParam(paramName:String, paramValue:Number) : Number {
         return Objects.paramPositiveNumber(paramName, paramValue);
      }
   }
}


import flash.geom.Point;
import flash.geom.Rectangle;

import utils.GeomUtils;
import utils.Objects;


class AreaRectangle extends Rectangle
{
   public function AreaRectangle(x:Number, y:Number, width:Number, height:Number) {
      super(x, y, width, height);
   }
   
   public function get voidArea() : Boolean {
      return width <= 0 || height <= 0;
   }
   
   public function substract(toSubstract:Rectangle) : Vector.<Rectangle> {
      Objects.paramNotNull("rect", toSubstract);
      var sections:Vector.<Rectangle> = new Vector.<Rectangle>();
      for each (var section:Rectangle in GeomUtils.substract(this, toSubstract)) {
         sections.push(new AreaRectangle(
            section.x, section.y,
            section.width, section.height
         ));
      }
      return sections;
   }
}


class ClippedArea
{
   private var _widthGeometry:ClippedAreaDimension;
   private var _heightGeometry:ClippedAreaDimension;
   private var _rectangle:AreaRectangle;
   
   public function ClippedArea(viewportSize:Point, contentRect:Rectangle, contentScale:Number) {
      _widthGeometry = new ClippedAreaDimension(
         viewportSize.x,
         contentRect.x,
         contentRect.width,
         contentScale
      );
      _heightGeometry = new ClippedAreaDimension(
         viewportSize.y,
         contentRect.y,
         contentRect.height,
         contentScale
      );
      _rectangle = new AreaRectangle(x, y, width, height);
   }
   
   public function get x() : int {
      return _widthGeometry.positionComponent;
   }
   
   public function get y() : int {
      return _heightGeometry.positionComponent;
   }
   
   public function get width() : int {
      return _widthGeometry.sizeComponent;
   }
   
   public function get height() : int {
      return _heightGeometry.sizeComponent;
   }
   
   public function get voidArea() : Boolean {
      return _rectangle.voidArea;
   }
   
   public function get rectangle() : AreaRectangle {
      return _rectangle;
   }
   
   public function equals(another:ClippedArea) : Boolean {
      return another != null && rectangle.equals(another.rectangle);
   }
}


class ClippedAreaDimension
{
   private var _viewportSize:int;
   private var _contentPosition:int;
   private var _contentSize:int;
   private var _contentScale:Number;
   
   public function ClippedAreaDimension(viewportSizeComponent:int,
                                        contentPositionComponent:int,
                                        contentSizeComponent:int,
                                        contentScale:Number) {
      _viewportSize = viewportSizeComponent;
      _contentPosition = contentPositionComponent;
      _contentSize = contentSizeComponent;
      _contentScale = contentScale;
      
      calculatePositionComponent();
      calculateSizeComponent();
   }
   
   private function calculatePositionComponent() : void {
      _positionComponent = -_contentPosition / _contentScale;
      if (_positionComponent < 0 || _positionComponent > _contentSize) {
         _positionComponent = 0;
      }
   }
   
   private function calculateSizeComponent() : void {
      var clipMin:int = _positionComponent;
      var clipMax:int = Math.min(_contentSize, (_viewportSize - _contentPosition) / _contentScale);
      if (_positionComponent >= clipMax || _contentSize <= clipMin) {
         _sizeComponent = 0;
      }
      else {
         _sizeComponent = clipMax - clipMin;
      }
   }
   
   private var _positionComponent:int;
   public function get positionComponent() : int {
      return _positionComponent;
   }
   
   private var _sizeComponent:int;
   public function get sizeComponent() : int {
      return _sizeComponent;
   }
}