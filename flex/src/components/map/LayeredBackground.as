package components.map
{
   import components.base.BaseContainer;
   import components.map.controllers.MapViewport;
//   import components.map.events.MapEvent;
   
   import flash.geom.Point;
   
   import mx.events.FlexEvent;
   import mx.events.MoveEvent;
   import mx.events.ResizeEvent;
   import mx.graphics.BitmapFillMode;
   
   import spark.primitives.BitmapImage;
   
   import utils.assets.AssetNames;
   
   
   
   
   /**
    * The fancy layerd background component for galaxy and solar system maps. 
    */
   public class LayeredBackground extends BaseContainer
   {
      /**
       * Default number of layers. 
       */      
      public  static const DEFAULT_NUM_LAYERS: Number = 1;
      private static const LAYER_SIZE_RATIO:   Number = 0.3;
      
      
      private var _ignoreNextMoveEvent: Boolean = false;
      private var _lastMoveEvent: MoveEvent = null;
      
      
      private var _viewport: MapViewport = null;
      private var _map:CMap = null;
      
      
      /* ###################### */
      /* ### INITIALIZATION ### */
      /* ###################### */
      
      
      public function LayeredBackground(viewport:MapViewport)
      {
         super();
         
         left = right = top = bottom = 0;
         
         mouseEnabled = false;
         mouseChildren = false;
         
         _viewport = viewport;
         _map = viewport.map;
         
         addEventListener(ResizeEvent.RESIZE, this_resizeHandler);
         addEventListener(FlexEvent.CREATION_COMPLETE, this_creationCompleteHandler);
         
         addViewportHandlers(_viewport);
         addMapHandlers(_map);
      }
      
      
      public function cleanup() : void
      {
         removeAllElements();
         _layers = null;
         if (_viewport)
         {
            removeViewportHandlers(_viewport);
            _viewport = null;
         }
         if (_map)
         {
            removeMapHandlers(_map);
            _map = null;
         }
      }
      
      
      protected override function createChildren() : void
      {
         super.createChildren();
         recreateLayers();
      }
      
      
      private var _layers:Array;
      /**
       * Removes all background layers from the component and creates
       * new layers. Calls setBackgroundImages().
       */
      private function recreateLayers() :void
      {
         removeAllElements();
         _layers = new Array();
         
         var layer:BitmapImage = null;
         for (var i: int = 0; i < DEFAULT_NUM_LAYERS; i++)
         {
            layer = new BitmapImage();
            layer.fillMode = BitmapFillMode.REPEAT;
            _layers.push(layer);
         }
         
         for (i = DEFAULT_NUM_LAYERS - 1; i >= 0; i--)
         {
            addElement(_layers[i]);
         }
         setBackgroundImages();
      }
      
      
      /**
       * Sets source properties for each layer viewport and map exist. 
       */      
      private function setBackgroundImages() : void
      {
         for (var i: int = 0; i < _layers.length; i++)
         {
            (_layers[i] as BitmapImage).source = IMG.getImage(AssetNames.getSpaceBackgroundImageName(i));
         }
      }
      
      
      override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number) : void
      {
         super.updateDisplayList(unscaledWidth, unscaledHeight);
         for (var i: int = 0; i < _layers.length; i++)
         {
            var layer: BitmapImage = _layers[i] as BitmapImage;
            var scale: Number = getLayerScale(i);
            var dx: Number = (layer.scaleX - scale) * layer.width / 2;
            var dy: Number = (layer.scaleY - scale) * layer.height / 2;
            layer.scaleX = scale;
            layer.scaleY = scale;
            layer.x = layer.x + dx;
            layer.y = layer.y + dy;
         }
         _lastMoveEvent = null;
      }
      
      
      private function getLayerScale (layer:int) : Number
      {
         return 1 - (1 - _map.scaleX) * LAYER_SIZE_RATIO / (layer + 1);
      }
      
      
      private function getLayerPosition(layer:int) : Point
      {
         if (!_lastMoveEvent || _ignoreNextMoveEvent)
         {
            return new Point(_layers[layer].x, _layers[layer].y);
         }
         return new Point(
            _layers[layer].x + (_map.x - _lastMoveEvent.oldX) * LAYER_SIZE_RATIO / (layer + 1),
            _layers[layer].y + (_map.y - _lastMoveEvent.oldY) * LAYER_SIZE_RATIO / (layer + 1)
         );
      }
      
      
      private function resizeLayers () :void
      {
         var width:Number = Math.max(_map.width, this.width)
            + _viewport.extraMapMoveSpace * 2;
         var height:Number = Math.max(_map.height, this.height)
            + _viewport.extraMapMoveSpace * 2;
         
         for (var i: int = 0; i < _layers.length; i++)
         {
            _layers[i].width = width;
            _layers[i].height = height;
         }
      }
      
      
      private function centerLayers () :void
      {
         for (var i: int = 0; i < _layers.length; i++)
         {
            _layers[i].x = (width  - _layers[i].width)  / 2;
            _layers[i].y = (height - _layers[i].height) / 2;
         }
      }
      
      
      /* ###################### */
      /* ### EVENT HANDLERS ### */
      /* ###################### */
      
      
      private function addViewportHandlers(viewport:MapViewport) :void
      {
//         viewport.addEventListener(MapEvent.MAP_SCALE_CHANGE, viewport_mapScaleChangeHandler);
      }
      
      
      private function removeViewportHandlers (viewport:MapViewport) :void
      {
//         viewport.removeEventListener(MapEvent.MAP_SCALE_CHANGE, viewport_mapScaleChangeHandler);
      }
      
      
      private function addMapHandlers(map:CMap) :void
      {
         map.addEventListener(MoveEvent.MOVE, map_moveHandler);
      }
      
      
      private function removeMapHandlers(map:CMap) :void
      {
         map.removeEventListener(MoveEvent.MOVE, map_moveHandler);
      }
      
      
      private function this_resizeHandler(event:ResizeEvent) : void
      {
         resizeLayers();
         centerLayers();
      }
      
      
      private function this_creationCompleteHandler(event:FlexEvent) : void
      {
         resizeLayers();
         centerLayers();
      }
      
      
//      private function viewport_mapScaleChangeHandler(event:MapEvent) :void
//      {
//         _ignoreNextMoveEvent = true;
//         invalidateDisplayList();
//      }
      
      
      private function map_moveHandler(event:MoveEvent) : void
      {
         _lastMoveEvent = event;
         for (var i:int = 0; i < _layers.length; i++)
         {
            var layer:BitmapImage = _layers [i] as BitmapImage; 
            var position:Point = getLayerPosition(i);
            layer.x = position.x;
            layer.y = position.y;
         }
         _lastMoveEvent = null;
         _ignoreNextMoveEvent = false;
      }
   }
}