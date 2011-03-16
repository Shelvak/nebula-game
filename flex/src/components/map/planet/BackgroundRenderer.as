package components.map.planet
{
   import flash.display.BitmapData;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   
   import interfaces.ICleanable;
   
   import models.map.MapDimensionType;
   import models.tile.TerrainType;
   import models.tile.Tile;
   
   import utils.BitmapUtil;
   import utils.assets.AssetNames;
   import utils.assets.ImagePreloader;
   
   
   
   
   /**
    * Does the rendering of a planet map background.
    */
   public class BackgroundRenderer implements ICleanable
   {
      private static const IMG:ImagePreloader = ImagePreloader.getInstance();
      
      private static const TRANSP_BLACK:uint = 0x00000000;
      private static const SOLID_WHITE:uint  = 0xFFFFFFFF;
      
      private static const POINT_0x0:Point = new Point();
      
      
      private var _map:PlanetMap = null,
                  _coordsTransform:PlanetMapCoordsTransform = null,
                  _background:BitmapData = null,
                  _texture:BitmapData = null,
      
      // 3d plane
                  _plane3D_width:BitmapData = null,
                  _plane3D_height:BitmapData = null,
      
      // tile masks
                  _tileMask:BitmapData = null,
                  _sideLeftMask:BitmapData = null,
                  _sideRightMask:BitmapData = null,
                  _sideTopMask:BitmapData = null,
                  _sideBottomMask:BitmapData = null,
                  _cornerTopLeftMask:BitmapData = null,
                  _cornerTopRightMask:BitmapData = null,
                  _cornerBottomLeftMask:BitmapData = null,
                  _cornerBottomRightMask:BitmapData = null;
      
      
      /**
       * Constructor.
       * 
       * @param map instance of <code>PlanetMap</code> that will be using this renderer. This
       * must be a valid instance of <code>PlanetMap</code>.
       */
      public function BackgroundRenderer(map:PlanetMap)
      {
         _map = map;
         _coordsTransform = map.coordsTransform;
         
         _tileMask = IMG.getImage(AssetNames.getTileMaskImageName(TileMaskType.TILE)).clone();
         
         _sideTopMask = IMG.getImage(AssetNames.getTileMaskImageName(TileMaskType.SIDE)).clone();
         _sideLeftMask = BitmapUtil.flipVertically(_sideTopMask);
         _sideRightMask = BitmapUtil.flipHorizontally(_sideTopMask);
         _sideBottomMask = BitmapUtil.flipVertically(BitmapUtil.flipHorizontally(_sideTopMask));
         
         _cornerTopLeftMask = IMG.getImage(AssetNames.getTileMaskImageName(TileMaskType.CORNER_WIDTH)).clone();
         _cornerBottomRightMask = BitmapUtil.flipHorizontally(_cornerTopLeftMask);
         
         _cornerTopRightMask = IMG.getImage(AssetNames.getTileMaskImageName(TileMaskType.CORNER_HEIGHT)).clone();
         _cornerBottomLeftMask = BitmapUtil.flipVertically(_cornerTopRightMask);
      }
      
      
      private var f_cleanupCalled:Boolean = false;
      public function cleanup() : void
      {
         if (f_cleanupCalled)
         {
            return;
         }
         if (_background)
         {
            _background.dispose();
            _background = null;
         }
      }
      
      
      /**
       * Renders a background of the map. Actual rendering is performed during the first call
       * of this method. Any additional calls will return cached <code>BitmapData</code>
       * instance.
       * 
       * @return rendered background of the given map.
       */
      public function renderBackground() : BitmapData
      {
         if (f_cleanupCalled)
         {
            return null;
         }
         if (_background)
         {
            return _background;
         }
         
         var border:int = PlanetMap.BORDER_SIZE;
         var terrain:int = _map.getPlanet().ssObject.terrain;
         
         _plane3D_width = IMG.getImage(AssetNames.get3DPlaneImageName(terrain, MapDimensionType.WIDHT)).clone();
         _plane3D_height = IMG.getImage(AssetNames.get3DPlaneImageName(terrain, MapDimensionType.HEIGHT)).clone();
         
         _background = new BitmapData(
            _coordsTransform.realWidth,
            _coordsTransform.realHeight + _plane3D_height.height,
            false, 0x000000
         );
         
         
         /**
          * Draw the regular tile as the main background. There is A border of PlanetMap.BORDER_SIZE
          * width around the active map area.
          */
         
         buildTexture(0, IMG.getImage(AssetNames.getRegularTileImageName(terrain)));
         for (var logicalX:int = -border; logicalX < _coordsTransform.logicalWidth + border; logicalX++)
         {
            for (var logicalY:int = -border; logicalY < _coordsTransform.logicalHeight + border; logicalY++)
            {
               addTile(logicalX, logicalY, _tileMask);
            }
         }
         
         
         /**
          * Draw other tile types on top of the regular.
          */
         
         // First find all resource type tiles and put them in a separate list as they
         // will be drawn in the end. In addition create here DFS array for map rendering
         // in areas (instead of individual tiles)
         var dfsArray: Array = new Array();
         var resourceTiles: Array = new Array();
         for (var x: int = 0; x < _coordsTransform.logicalWidth; x++)
         {
            dfsArray.push (new Array());
            for (var y: int = 0; y < _coordsTransform.logicalHeight; y++)
            {
               var t: Tile = _map.getPlanet().getTile(x, y);
               
               // Folliage tiles must become regular tiles as they are
               // not rendered here (this is responsibility of one of planet map
               // layers)
               if (t && t.isFolliage())
               {
                  dfsArray[x].push(new DFSRecord(null));
               }
               else
               {
                  dfsArray[x].push(new DFSRecord(t));
               }
               
               if (t && t.isResource())
               {
                  resourceTiles.push(t);
               }
            }
         }
         
         // Now render the map. Here we go through all tiles and once we find the area
         // we haven't drawn yet we draw it also blending the border of the area.
         // Area drawing is implemented using DFS-like algorithm
         for (x = 0; x < _coordsTransform.logicalWidth; x++)
         {
            for (y = 0; y < _coordsTransform.logicalHeight; y++)
            {
               // Examine only not visited tiles and only tiles that are not of
               // resource or regular (dfsRecord == null) type.
               var dfsRecord: DFSRecord = dfsArray[x][y];
               if (dfsRecord.tile && !dfsRecord.visited && !dfsRecord.tile.isResource())
               {
                  buildTexture(dfsRecord.tile.kind);
                  buildAreaMask(x, y, dfsRecord.tile.kind, dfsArray);
               }
            }
         }
         
         // drawing resource tiles
         for each (t in resourceTiles)
         {
            addResourceTile(t);
         }
         
         // 3d plane imitation
         var srcRect:Rectangle = new Rectangle(0, 0, _plane3D_height.width, _plane3D_height.height);
         var realX:Number;
         var realY:Number = _coordsTransform.logicalToReal_Y(-border,
                                                             _coordsTransform.logicalHeight + border - 2);
         for (realX = 0; realX < _coordsTransform.logicalToReal_X(-border + 1, -border); realX += 2)
         {
            _background.copyPixels(_plane3D_height, srcRect, new Point(realX, realY));
            _background.copyPixels(_plane3D_height, srcRect, new Point(realX + 1, realY));
            realY++;
         }
         for (; realX < _coordsTransform.logicalToReal_X(_coordsTransform.logicalWidth + border,
                                                         -border - 1); realX += 2)
         {
            realY--;
            _background.copyPixels(_plane3D_width, srcRect, new Point(realX, realY));
            _background.copyPixels(_plane3D_width, srcRect, new Point(realX + 1, realY));
         }
         
         _map = null;
         _coordsTransform = null;
         _texture.dispose(); _texture = null;
         _tileMask.dispose(); _tileMask = null;
         _sideBottomMask.dispose(); _sideBottomMask = null;
         _sideLeftMask.dispose(); _sideLeftMask = null;
         _sideRightMask.dispose(); _sideRightMask = null;
         _sideTopMask.dispose(); _sideTopMask = null;
         _cornerBottomLeftMask.dispose(); _cornerBottomLeftMask = null;
         _cornerBottomRightMask.dispose(); _cornerBottomRightMask = null;
         _cornerTopLeftMask.dispose(); _cornerTopLeftMask = null;
         _cornerTopRightMask.dispose(); _cornerTopRightMask = null;
         _plane3D_width.dispose(); _plane3D_width = null;
         _plane3D_height.dispose(); _plane3D_height = null;
         
         return _background;
      }
      
      
      /**
       * Draws whole area of the same tile tipe and blends borders of this area.
       */ 
      private function buildAreaMask(logicalX:int, logicalY:int, kind:int, dfsArray:Array) : void
      {
         // If we are out of range just return
         if (logicalX < 0 || logicalX >= _coordsTransform.logicalWidth ||
             logicalY < 0 || logicalY >= _coordsTransform.logicalHeight)
         {
            return;
         }
         
         var record:DFSRecord = dfsArray[logicalX][logicalY];
         
         // Don't examine tiles if they are of regular type (record.tile == null), if they were
         // visited, if they are of different type than the type of the area or if the tile is
         // of resource type (should not happen but just as a precaution).
         if (!record.tile || record.visited == true || record.tile.kind != kind || record.tile.isResource())
         {
            return;
         }
         
         record.visited = true;
         
         // Draw whole tile's mask
         addTile(logicalX, logicalY, _tileMask);
         
         // Examine the surrounding tiles of the current tile and draw masks if necessary
         for (var x:int = logicalX - 1; x <= logicalX + 1; x++)
         {
            for (var y:int = logicalY - 1; y <= logicalY + 1; y++)
            {
               blendTile(logicalX, logicalY, x, y, kind, dfsArray);
            }
         }
         
         // Then go through the adjecent tiles
         for (x = logicalX - 1; x <= logicalX + 1; x++)
         {
            for (y = logicalY - 1; y <= logicalY + 1; y++)
            {
               buildAreaMask(x, y, kind, dfsArray)
            }
         }
      }
      
      
      /**
       * Draws blending mask for a given current and adjecent tiles if necessary.
       */ 
      private function blendTile (currX:int, currY:int,
                                  adjX:int, adjY:int,
                                  kind:int, dfsArray:Array) :void
      {
         // Current and adjecent tiles are the same.
         if (adjX == currX && adjY == currY)
         {
            return;
         }
         
         var border:int = PlanetMap.BORDER_SIZE;
         
         // If we are out of range just return
         if (adjX < -border || adjX >= _coordsTransform.logicalWidth + border ||
             adjY < -border || adjY >= _coordsTransform.logicalHeight + border)
         {
            return;
         }
         
         var current:DFSRecord = dfsArray[currX][currY];
         var adjecent:DFSRecord;
         if (adjX >= 0 && adjX < _coordsTransform.logicalWidth &&
             adjY >= 0 && adjY < _coordsTransform.logicalHeight)
         {
            adjecent = dfsArray[adjX][adjY];
         }
         else
         {
            adjecent = new DFSRecord(null);
         }
         
         // We don't need to draw anything if the adjecent tile is of the same kind as
         // the current one.
         if (adjecent.tile && current.tile.kind == adjecent.tile.kind)
         {
            return;
         }
         
         // Otherwise determine the type of a mask and draw it.
         var mask:BitmapData;
         var dx:int = adjX - currX;
         var dy:int = adjY - currY;
         
         // TileMaskType.SIDE
         if (currX == adjX || currY == adjY)
         {
            if (dy == 1)
            {
               mask = _sideTopMask;
            }
            else if (dx == 1)
            {
               mask = _sideRightMask;
            }
            else if (dy == -1)
            {
               mask = _sideBottomMask;
            }
            else
            {
               mask = _sideLeftMask;
            }
         }
         
         // TileMaskType.CORNER_WIDTH or TileMaskType.CORNER_HEIGHT
         else
         {
            // If there is another tile adjecent to tile beeing examined and the tile
            // beeing blended we don't need to blend anything
            var adjTileY:Tile = adjY >= 0 && adjY < _map.height ? DFSRecord(dfsArray[currX][adjY]).tile : null;
            var adjTileX:Tile = adjX >= 0 && adjX < _map.width  ? DFSRecord(dfsArray[adjX][currY]).tile : null;
            if (adjTileY && adjTileY.kind == kind || adjTileX && adjTileX.kind == kind)
            {
               return;
            }
            
            if (dx == dy)
            {
               if (dy == 1)
               {
                  mask = _cornerTopRightMask;
               }
               else
               {
                  mask = _cornerBottomLeftMask;
               }
            }
            else
            {
               if (dy == 1)
               {
                  mask = _cornerTopLeftMask;
               }
               else
               {
                  mask = _cornerBottomRightMask;
               }
            }
         }
         
         // Draw the mask
         addTile(adjX, adjY, mask);
      }
      
      
      /**
       * Adds tile (one of its variations) to <code>_background</code> object.
       */ 
      private function addTile(logicalX:int, logicalY:int, tileMask:BitmapData) : void
      {
         var destPoint:Point = new Point(
            _coordsTransform.logicalToReal_X(logicalX, logicalY),
            _coordsTransform.logicalToReal_Y(logicalX, logicalY)
         );
         
         // Source rectangle is a bit tricky as we must copy the right piece of the texture
         var sourceRect:Rectangle = new Rectangle(
            destPoint.x % (_texture.width - tileMask.width),
            destPoint.y % (_texture.height - tileMask.height),
            tileMask.width,
            tileMask.height
         );
         
         _background.copyPixels(_texture, sourceRect, destPoint, tileMask, POINT_0x0, true);
      }
      
      
      /**
       * Draws resource tile directly to <code>_background</code> object.
       */
      private function addResourceTile(t:Tile) :void
      {
         // Don't draw fake resource tiles
         if (t.fake) return;
         
         var image:BitmapData = IMG.getImage(AssetNames.getTileImageName(t.kind));
         var destPoint:Point = new Point(
            _coordsTransform.logicalToReal_X(t.x, t.y + 1),
            _coordsTransform.logicalToReal_Y(t.x + 1, t.y + 1)
         );
         
         _background.copyPixels(image, image.rect, destPoint, null, null, true);
      }
      
      
      /**
       * Builds a texture of a given <code>tileKind</code> or from a given <code>sampleTexture</code>
       * four times of the size the sample texture is and sores it in <code>_texture</code> variable.
       * 
       * @param tileKind kind of a tile (values are from <code>TileKind</code>)
       * @param sampleTexture sample image of a texture. If this one if provided <code>tileKind</code>
       * is ingnored.
       */
      private function buildTexture(tileKind:int, sampleTexture:BitmapData = null) : void
      {
         if (sampleTexture == null)
         {
            sampleTexture = IMG.getImage(AssetNames.getTileImageName(tileKind));
         }
         _texture = new BitmapData(
            sampleTexture.width + _tileMask.width,
            sampleTexture.height + _tileMask.height,
            false
         );
         BitmapUtil.fillWithBitmap(sampleTexture, _texture);
      }
   }
}




import models.tile.Tile;
class DFSRecord
{
   public var tile: Tile = null;
   public var visited: Boolean = false;
   
   public function DFSRecord (tile: Tile)
   {
      this.tile = tile;
   }
}