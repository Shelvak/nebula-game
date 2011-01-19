package components.map.planet
{
   import animation.AnimationTimer;
   
   import components.gameobjects.planet.IInteractivePlanetMapObject;
   import components.map.CMap;
   
   import flash.display.BitmapData;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   
   import models.map.MapDimensionType;
   import models.planet.Planet;
   import models.tile.Tile;
   
   import utils.assets.AssetNames;
   
   
   
   
   /**
    * Map of a planet. Probably the most difficult of all.
    */
   public class PlanetMap extends CMap
   {
      /**
       * Called by <code>NavigationController</code> when planet map screen is shown.
       */
      public static function screenShowHandler() : void
      {
         AnimationTimer.forPlanet.start();
      }
      
      
      /**
       * Called by <code>NavigationController</code> when planet map screen is hidden.
       */
      public static function screenHideHandler() : void
      {
         AnimationTimer.forPlanet.stop();
      }
      
      
      /**
       * Size of a border made up from tiles around the actual map.
       */
      internal static const BORDER_SIZE:int = 1;
      
      
      /* ###################### */
      /* ### INITIALIZATION ### */
      /* ###################### */
      
      
      private var _backgroundRenderer:BackgroundRenderer = null;
      
      
      /**
       * Constructor.
       * 
       * @param model a planet to create map for
       */
      public function PlanetMap(model:Planet)
      {         
         super(model);
      }
      
      
      public override function cleanup() : void
      {
         if (_objectsLayer)
         {
            removeElement(_objectsLayer);
            _objectsLayer.cleanup();
            _objectsLayer = null;
         }
         if (_backgroundRenderer)
         {
            _backgroundRenderer = null;
         }
         super.cleanup();
      }
      
      
      public override function getBackground() : BitmapData
      {
         if (!_backgroundRenderer)
         {
            _backgroundRenderer = new BackgroundRenderer(this);
         }
         return _backgroundRenderer.renderBackground();
      }
      
      
      protected override function createObjects() : void
      {
         super.createObjects();
         
         _objectsLayer = new PlanetObjectsLayer(this, getPlanet());
         addElement(_objectsLayer);
      }
      
      
      protected override function reset() : void
      {
         if (_objectsLayer != null)
         {
            _objectsLayer.reset();
         }
      }
      
      
      /* ########################### */
      /* ### INTERNAL CONTAINERS ### */
      /* ########################### */
      
      
      /**
       * Container that holds all planet objects.
       */       
      private var _objectsLayer:PlanetObjectsLayer = null;
      
      
//      /**
//       * Clouds layer. Thy dont need fancy depth sorting support found in <code>_objectsLayer</code>
//       * so they are held in another container.
//       */
//      private var _cloudsLayer:CloudsLayer = null;
      
      
      /**
       * Typed getter for property <code>model</code>.
       */      
      public function getPlanet() : Planet
      {
         return Planet(model);
      }
      
      
      protected override function selectObjectImpl(object:*, operationCompleteHandler:Function = null) : void
      {
         var obj:IInteractivePlanetMapObject = IInteractivePlanetMapObject(_objectsLayer.getObjectByModel(object));
         _objectsLayer.selectObject(obj);
         viewport.zoomArea(new Rectangle(obj.x, obj.y, obj.width, obj.height), true, operationCompleteHandler);
      }
      
      /* ################################### */
      /* ### REAL DIMENSIONS CALCULATION ### */
      /* ################################### */
      
      
      public function get logicalHeight() : int
      {
         return model ? Planet(model).height : 0;
      }
      
      
      internal function get logicalHeightBorder() : int
      {
         return logicalHeight + BORDER_SIZE * 2;
      }
      
      
      public function get logicalWidth() : int
      {
         return model ? Planet(model).width : 0;
      }
      
      
      internal function get logicalWidthBorder() : int
      {
         return logicalWidth + BORDER_SIZE * 2;
      }
      
      
      internal function get extraYPixels() : int
      {
         return logicalHeightBorder - 1;
      }
      
      
      internal function get extraXPixels() : int
      {
         return logicalWidthBorder - 1;
      }
      
      
      internal function get extraWidthPixels() : int
      {
         return extraYPixels + extraXPixels;
      }
      
      
      public function getRealWidth() : Number
      {
         return getRealSideLength(Tile.IMAGE_WIDTH) + extraWidthPixels;
      }
      
      
      public function getRealHeight() : Number
      {
         return getRealSideLength(Tile.IMAGE_HEIGHT);
      }
      
      
      /**
       * Calculates real length of one map side.
       */ 
      private function getRealSideLength (tileDimension: Number) :Number
      {
         return (logicalHeightBorder + logicalWidthBorder) * tileDimension / 2;
      }
      
      
      /* ######################################### */
      /* ### REAL TILE COORDINATES CALCULATION ### */
      /* ######################################### */
      
      
      public function getRealTileX (logicalX: int, logicalY: int) :Number
      {
         logicalX += BORDER_SIZE;
         logicalY += BORDER_SIZE;
         return (extraYPixels + logicalX - logicalY) * Tile.IMAGE_WIDTH / 2 + logicalX - logicalY + extraYPixels;
      }
      
      
      public function getRealTileY (logicalX: int, logicalY: int) :Number
      {
         logicalX += BORDER_SIZE;
         logicalY += BORDER_SIZE;
         return (logicalHeightBorder + logicalWidthBorder - logicalX - logicalY - 2) * Tile.IMAGE_HEIGHT / 2;
      }
      
      
      /* ############################################# */
      /* ### LOGICAL TILE COORDINATES CALCULATION  ### */
      /* ############################################# */
      
      /**
       * Calculates and returns logical tile coordinates under the given point.
       *  
       * @param realX Actual x coordinate of a point (in pixels)
       * @param realY Actual y coordinate of a point (in pixels)
       * @param nullForNoTile if <code>false</code>, will return corrdinates of a tile even if
       * given real coordinates are not within bounds of the map
       * 
       * @return Instance of <code>Point</code> where x is a logical x and y is a logical y of
       * a tile under the given point or null if there is no tile under the point (unless
       * <code>nullForNoTile</code> is <code>false</code>). 
       */      
      public function getLogicalTileCoords(realX:Number, realY:Number, nullForNoTile:Boolean = true) : Point
      {
         realX = realX - logicalHeightBorder * Tile.IMAGE_WIDTH / 2 - extraYPixels;
         realY = getRealHeight() - realY;
         
         var x: int = Math.floor((realY - Math.floor((1 - realX) / 2)) / Tile.IMAGE_HEIGHT) - BORDER_SIZE;
         var y: int = Math.floor((realY - Math.floor(realX / 2)) / Tile.IMAGE_HEIGHT) - BORDER_SIZE;
         
         if (nullForNoTile && (x < 0 || y < 0 || x > logicalWidth - 1 || y > logicalHeight - 1))
         {
            return null;
         }
         
         return new Point(x, y);
      }
   }
}