package components.map.planet
{
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.Graphics;
   import flash.geom.ColorTransform;
   import flash.geom.Point;
   
   import mx.core.UIComponent;
   
   import utils.assets.AssetNames;
   import utils.assets.ImagePreloader;
   
   
   /**
    * This draws a basment of a planet object as separate tiles rather than one hudge rectangle
    * like <code>PlanetObjectBasement</code> does.
    */
   public class PlanetObjectBasementTiled extends UIComponent
   {
      private static function get IMG() : ImagePreloader
      {
         return ImagePreloader.getInstance();
      }
      
      
      /**
       * @param defaultTileState default state of a tile. Use constance defined in <code>TileState</code>.
       * @param logicalWidth logical width of a planet object
       * @param logicalHeight logical height of a planet object
       */
      public function PlanetObjectBasementTiled(defaultTileState:int, logicalWidth:int, logicalHeight:int)
      {
         super();
         mouseEnabled = false;
         mouseChildren = false;
         focusEnabled = false;
         _logicalWidth  = logicalWidth;
         _logicalHeight = logicalHeight;
         _defaultTileState = defaultTileState;
         _coordsTransform = new PlanetMapCoordsTransform(logicalWidth, logicalHeight);
         _tileImage = IMG.getImage(AssetNames.getTileMaskImageName(TileMaskType.TILE)).clone();
         _tileColorTransform = new ColorTransform();
         initTileStates();
      }
      
      
      private var _tileColorTransform:ColorTransform;
      private var _tileImage:BitmapData;
      private var _coordsTransform:PlanetMapCoordsTransform;
      private var _defaultTileState:int;
      private var _logicalWidth:int;
      private var _logicalHeight:int;
      
      
      private var _tileStates:Vector.<Vector.<int>>;
      private function initTileStates() : void
      {
         _tileStates = new Vector.<Vector.<int>>(_logicalWidth, true);
         for (var lx:int = 0; lx < _logicalWidth; lx++)
         {
            _tileStates[lx] = new Vector.<int>(_logicalHeight, true);
         }
         resetTileStates();
      }
      
      
      /**
       * A 2D array containing states of each tile under an object. Size of this array is <code>[logicalWidth
       * x logicalHeight]</code>.
       * 
       * <p>Once you have completed modifying this array, call <code>applyTileStates()</code> to apply the
       * changes.</p>
       * 
       * @see #PlanetObjectBasementTiled()
       */
      public function get tileStates() : Vector.<Vector.<int>>
      {
         return _tileStates;
      }
      
      
      /**
       * Call this when you are done modifying the <code>tileStates</code> array so that the component
       * gets redrawn during the next screen render.
       */
      public function applyTileStates() : void
      {
         f_tileStatesChanged = true;
         invalidateDisplayList();
      }
      
      
      /**
       * Resets all tile states to default values.
       */      
      public function resetTileStates() : void
      {
         for (var lx:int = 0; lx < _logicalWidth; lx++)
         {
            for (var ly:int = 0; ly < _logicalHeight; ly++)
            {
               _tileStates[lx][ly] = _defaultTileState;
            }
         }
         applyTileStates();
      }
      
      
      /* ################ */
      /* ### CHILDREN ### */
      /* ################ */
      
      
      private var _basementBitmap:Bitmap;
      
      
      protected override function createChildren() : void
      {
         super.createChildren();
         _basementBitmap = new Bitmap(new BitmapData(_coordsTransform.realWidth,
                                                     _coordsTransform.realHeight,
                                                     true, 0));
         addChild(_basementBitmap);
      }
      
      
      /* ############ */
      /* ### SIZE ### */
      /* ############ */
      
      
      protected override function measure() : void
      {
         measuredWidth  = _coordsTransform.realWidth;
         measuredHeight = _coordsTransform.realHeight;
      }
      
      
      /* ############### */
      /* ### VISUALS ### */
      /* ############### */
      
      
      private var f_tileStatesChanged:Boolean = true;
      
      
      protected override function updateDisplayList(uw:Number, uh:Number) : void
      {
         super.updateDisplayList(uw, uh);
         if (f_tileStatesChanged)
         {
            _basementBitmap.bitmapData.fillRect(_basementBitmap.bitmapData.rect, 0);
            for (var lx:int = 0; lx < _logicalWidth; lx++)
            {
               for (var ly:int = 0; ly < _logicalHeight; ly++)
               {
                  _tileColorTransform.color = TileState.getColor(_tileStates[lx][ly]);
                  _tileImage.colorTransform(_tileImage.rect, _tileColorTransform);
                  _basementBitmap.bitmapData.copyPixels(
                     _tileImage,
                     _tileImage.rect,
                     _coordsTransform.logicalToReal(new Point(lx, ly)),
                     null, null, true
                  );
               }
            }
         }
         f_tileStatesChanged = false;
      }
   }
}