package components.map.planet
{
   import animation.AnimationTimer;
   
   import components.map.CMap;
   
   import flash.display.BitmapData;
   import flash.geom.Point;
   
   import models.planet.Planet;
   import models.tile.Tile;
   
   
   
   
   /**
    * Map of a planet. Probably the most difficult of all.
    */
   public class PlanetMap extends CMap
   {
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
      
      
      protected override function getBackground() : BitmapData
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
         
         _objectsLayer = new PlanetObjectsLayer();
         _objectsLayer.initializeLayer(this, getPlanet());
         addElement(_objectsLayer);
         
         AnimationTimer.forPlanet.start();
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
      
      
      /**
       * Clouds layer. Thy dont need fancy depth sorting support found in <code>_objectsLayer</code>
       * so they are held in another container.
       */
      private var _cloudsLayer:CloudsLayer = null;
      
      
      /**
       * Typed getter for property <code>model</code>.
       */      
      public function getPlanet() : Planet
      {
         return model as Planet;
      }
      
      
      /* ################################### */
      /* ### REAL DIMENSIONS CALCULATION ### */
      /* ################################### */
      
      
      public function get logicalHeight() : int
      {
         return model ? Planet(model).height : 0;
      }
      
      
      public function get logicalWidth() : int
      {
         return model ? Planet(model).width : 0;
      }
      
      
      public function get extraYPixels () :int
      {
         return logicalHeight - 1;
      }
      
      
      public function get extraXPixels () :int
      {
         return logicalWidth - 1;
      }
      
      
      public function get extraWidthPixels () :int
      {
         return extraYPixels + extraXPixels;
      }
      
      
      public function getRealWidth () :Number
      {
         return getRealSideLength (Tile.IMAGE_WIDTH) + extraWidthPixels;
      }
      
      
      public function getRealHeight () :Number
      {
         return getRealSideLength (Tile.IMAGE_HEIGHT);
      }
      
      
      /**
       * Calculates real length of one map side.
       */ 
      private function getRealSideLength (tileDimention: Number) :Number
      {
         return (logicalHeight + logicalWidth) * tileDimention / 2;
      }
      
      
      /* ######################################### */
      /* ### REAL TILE COORDINATES CALCULATION ### */
      /* ######################################### */
      
      
      public function getRealTileX (logicalX: int, logicalY: int) :Number
      {
         return (extraYPixels + logicalX - logicalY) * Tile.IMAGE_WIDTH / 2
            + logicalX - logicalY + extraYPixels;
      }
      
      
      public function getRealTileY (logicalX: int, logicalY: int) :Number
      {
         return (logicalHeight + logicalWidth - logicalX - logicalY - 2) * Tile.IMAGE_HEIGHT / 2;
      }
      
      
      /* ############################################# */
      /* ### LOGICAL TILE COORDINATES CALCULATION  ### */
      /* ############################################# */
      
      /**
       * Calculates and returns logical tile coordinates under the given point.
       *  
       * @param realX Actual x coordinate of a point (in pixels).
       * @param realY Actual y coordinate of a point (in pixels).
       * 
       * @return Instance of <code>Point</code> where x is a logical x and y is a logical y of
       * a tile under the given point or null if there is no tile under the point. 
       * 
       */      
      public function getLogicalTileCoords (realX: Number, realY: Number) :Point
      {
         realX = realX - logicalHeight * Tile.IMAGE_WIDTH / 2 - extraYPixels;
         realY = getRealHeight () - realY;
         
         var x: int = Math.floor ((realY - Math.floor ((1 - realX) / 2)) / Tile.IMAGE_HEIGHT);
         var y: int = Math.floor ((realY - Math.floor (realX / 2)) / Tile.IMAGE_HEIGHT);
         
         if (x < 0 || x > logicalWidth  - 1 ||
            y < 0 || y > logicalHeight - 1)
            return null;
         
         return new Point (x, y);
      }
   }
}