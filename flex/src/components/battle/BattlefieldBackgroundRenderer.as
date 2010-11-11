package components.battle
{
   import flash.display.BitmapData;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   
   import spark.primitives.Rect;
   
   import utils.assets.AssetNames;
   import utils.assets.ImagePreloader;

   public class BattlefieldBackgroundRenderer
   {
      private var totalWidth:Number;
      private var totalHeight:Number;
      private var spaceHeight:Number;
      private var groundHeight:Number;
      private var terrainType:int;
      
      
      private function get includeSpace() : Boolean
      {
         return spaceHeight > 0;
      }
      
      
      private function get includeGround() : Boolean
      {
         return groundHeight > 0;
      }
      
      
      private function get includeScenery() : Boolean
      {
         return includeGround;
      }
      
      
      private function calculateTotalHeight() : void
      {
         totalHeight = 0;
         if (includeGround)
         {
            totalHeight += groundHeight;
         }
         if (includeScenery)
         {
            totalHeight += getPartImage(BattlefieldBackgroundPart.SCENERY).height;
         }
         if (includeSpace)
         {
            totalHeight += spaceHeight;
         }
      }
      
      
      public function BattlefieldBackgroundRenderer
         (terrainType:int, spaceHeight:Number, groundHeight:Number, totalWidth:Number)
      {
         this.terrainType = terrainType;
         this.totalWidth = totalWidth;
         this.spaceHeight = spaceHeight;
         this.groundHeight = groundHeight;
         calculateTotalHeight();
      }
      
      
      private var background:BitmapData = null;
      /**
       * Renders and returns background. This method will cache background data when this method
       * id called for the first time and will return the same <code>BitampData</code> object
       * on any repreated calls to this method.
       * 
       * @return <code>BitampData</code> object that contains rendered background image
       */
      public function render() : BitmapData
      {
         // Return cached data on repeated calls
         if (background)
         {
            return background;
         }
         try
         {
            background = new BitmapData(totalWidth, totalHeight, false, 0x000000);
         }
         catch (err: Error)
         {
            throw new Error('width: '+totalWidth+', height: '+totalHeight+', '+err);
         }
         
         // Space
         if (includeSpace)
         {
            var spaceTop:Number = 0;
            var spaceMiddle:Number = spaceHeight - 1;
            var spaceBottom:Number = spaceMiddle;
            
            // Space above the scenery
            if (includeScenery)
            {
               var partSpaceScenery:BitmapData = getPartImage(BattlefieldBackgroundPart.SPACE_SCENERY);
               spaceMiddle = spaceMiddle - partSpaceScenery.height + 1;
               fill(spaceMiddle, spaceBottom, partSpaceScenery, FillDirection.TOP_TO_BOTTOM);
            }
            
            // Space only
            if (spaceMiddle > spaceTop)
            {
               var partSpace:BitmapData = getPartImage(BattlefieldBackgroundPart.SPACE);
               fill(spaceTop, spaceMiddle, partSpace, FillDirection.BOTTOM_TO_TOP);
            }
         }
         
         // Scenery
         if (includeScenery)
         {
            var partScenery:BitmapData = getPartImage(BattlefieldBackgroundPart.SCENERY);
            var sceneryTop:int = spaceHeight;
            var sceneryBottom:int = spaceHeight + partScenery.height - 1;
            fill(sceneryTop, sceneryBottom, partScenery, FillDirection.TOP_TO_BOTTOM);
         }
         
         // Ground
         if (includeGround)
         {
            var partSceneryGround:BitmapData = getPartImage(BattlefieldBackgroundPart.SCENERY_GROUND);
            var partGround:BitmapData = getPartImage(BattlefieldBackgroundPart.GROUND);
            
            var groundTop:Number = totalHeight - groundHeight;
            var groundMiddle:Number = groundTop + partSceneryGround.height
            var groundBottom:Number = totalHeight;
            
            // Ground below the scenery
            fill(groundTop, groundMiddle - 1, partSceneryGround, FillDirection.TOP_TO_BOTTOM);
            // Only ground
            fill(groundMiddle, groundBottom, partGround, FillDirection.TOP_TO_BOTTOM);
         }
         
         // Border
         //TOP
         var topLeftCorner: BitmapData = getBorderImage(BattlefieldBorderPart.TOP_LEFT_CORNER);
         var topLeft: BitmapData = getBorderImage(BattlefieldBorderPart.TOP_LEFT);
         var topMiddle: BitmapData = getBorderImage(BattlefieldBorderPart.TOP_CENTER_REPEAT);
         var topRight: BitmapData = getBorderImage(BattlefieldBorderPart.TOP_RIGHT);
         var topRightCorner: BitmapData = getBorderImage(BattlefieldBorderPart.TOP_RIGHT_CORNER);
         //SIDES
         var leftTop: BitmapData = getBorderImage(BattlefieldBorderPart.LEFT_TOP);
         var leftMiddle: BitmapData = getBorderImage(BattlefieldBorderPart.LEFT_CENTER_REPEAT);
         var leftBottom: BitmapData = getBorderImage(BattlefieldBorderPart.LEFT_BOTTOM);
         var rightTop: BitmapData = getBorderImage(BattlefieldBorderPart.RIGHT_TOP);
         var rightMiddle: BitmapData = getBorderImage(BattlefieldBorderPart.RIGHT_CENTER_REPEAT);
         var rightBottom: BitmapData = getBorderImage(BattlefieldBorderPart.RIGHT_BOTTOM);
         //BOTTOM
         var bottomLeftCorner: BitmapData = getBorderImage(BattlefieldBorderPart.BOTTOM_LEFT_CORNER);
         var bottomLeft: BitmapData = getBorderImage(BattlefieldBorderPart.BOTTOM_LEFT);
         var bottomMiddle: BitmapData = getBorderImage(BattlefieldBorderPart.BOTTOM_CENTER_REPEAT);
         var bottomRight: BitmapData = getBorderImage(BattlefieldBorderPart.BOTTOM_RIGHT);
         var bottomRightCorner: BitmapData = getBorderImage(BattlefieldBorderPart.BOTTOM_RIGHT_CORNER);
         
         var newBackground : BitmapData = new BitmapData(topLeftCorner.width + background.width + bottomRightCorner.width,
            topLeftCorner.height + background.height + bottomLeftCorner.height);
         newBackground.copyPixels(background, new Rectangle(0, 0, background.width, background.height), 
            new Point(topLeftCorner.width, topLeftCorner.height));
         background = newBackground;
         totalWidth += (topLeftCorner.width + bottomRightCorner.width);
         totalHeight += (topLeftCorner.height + bottomLeftCorner.height);
         
         //Place border repeat centers
         lineFill(topMiddle, new Point(0, 0), new Point(background.width, 0));
         lineFill(bottomMiddle, new Point(0, background.height - bottomMiddle.height), new Point(background.width, background.height - bottomMiddle.height));
         lineFill(leftMiddle, new Point(0, 0), new Point(0, background.height));
         lineFill(rightMiddle, new Point(background.width - rightMiddle.width, 0), new Point(background.width - rightMiddle.width, background.height));
         
         //Place corners
         background.copyPixels(topLeftCorner, new Rectangle(0, 0, topLeftCorner.width, topLeftCorner.height), new Point());
         background.copyPixels(topRightCorner, new Rectangle(0, 0, topRightCorner.width, topRightCorner.height), new Point(background.width - topRightCorner.width, 0));
         background.copyPixels(bottomLeftCorner, new Rectangle(0, 0, bottomLeftCorner.width, bottomLeftCorner.height), new Point(0, background.height - bottomLeftCorner.height));
         background.copyPixels(bottomRightCorner, new Rectangle(0, 0, bottomRightCorner.width, bottomRightCorner.height), new Point(background.width - bottomRightCorner.width, background.height - bottomRightCorner.height));
         
         //Place horizontal stuff next to corners
         background.copyPixels(topLeft, new Rectangle(0, 0, topLeft.width, topLeft.height), new Point(topLeftCorner.width, 0));
         background.copyPixels(topRight, new Rectangle(0, 0, topRight.width, topRight.height), new Point(background.width - topRight.width - topRightCorner.width, 0));
         background.copyPixels(bottomLeft, new Rectangle(0, 0, bottomLeft.width, bottomLeft.height), new Point(bottomLeftCorner.width, background.height - bottomLeft.height));
         background.copyPixels(bottomRight, new Rectangle(0, 0, bottomRight.width, bottomRight.height), new Point(background.width - bottomRightCorner.width - bottomRight.width, background.height - bottomRight.height));
         
         //Place vertical stuff next to corners
         background.copyPixels(leftTop, new Rectangle(0, 0, leftTop.width, leftTop.height), new Point(0, topLeftCorner.height));
         background.copyPixels(leftBottom, new Rectangle(0, 0, leftBottom.width, leftBottom.height), new Point(0, background.height - bottomLeftCorner.height - leftBottom.height));
         background.copyPixels(rightTop, new Rectangle(0, 0, rightTop.width, rightTop.height), new Point(background.width - rightTop.width, topRightCorner.height));
         background.copyPixels(rightBottom, new Rectangle(0, 0, rightBottom.width, rightBottom.height), new Point(background.width - rightBottom.width, background.height - bottomRightCorner.height - rightBottom.height));
         
         
         return background;
      }
      
      /**
       * 
       * for borders
       * 
       */      
      private function lineFill(data: BitmapData, startPoint: Point, endPoint: Point): void
      {
         var currentPoint: Point = startPoint;
         if (startPoint.x == endPoint.x)
         {
            while (currentPoint.y < endPoint.y)
            {
               background.copyPixels(data, new Rectangle(0, 0, data.width, 
                  Math.min(data.height, background.height - currentPoint.y)), currentPoint);
               currentPoint.y += data.height;
            }
         }
         else
         {
            while (currentPoint.x < endPoint.x)
            {
               background.copyPixels(data, new Rectangle(0, 0, 
                  Math.min(data.width, background.width - currentPoint.x), data.height), currentPoint);
               currentPoint.x += data.width;
            }
         }
      }
      
      
      /**
       * <code>top</code> and <code>buttom</code> defines inclusive range
       */      
      private function fill(top:int,
                            bottom:int,
                            data:BitmapData,
                            direction:int) : void
      {
         var totalHeight:int = bottom - top + 1;
         var totalWidth:int = this.totalWidth;
         
         var verticalPasses:int = Math.ceil(totalHeight / data.height);
         var horizontalPasses:int = Math.ceil(totalWidth / data.width);
         
         var sourceRect:Rectangle = new Rectangle();

         var destPoint:Point = new Point();
         
         for (var vPass:int = 0; vPass < verticalPasses; vPass++)
         {
            if (vPass + 1 != verticalPasses)
            {
               sourceRect.height = data.height;
               sourceRect.y = 0;
               if (direction == FillDirection.TOP_TO_BOTTOM)
               {
                  destPoint.y = data.height * vPass + top;
               }
               else
               {
                  destPoint.y = bottom - data.height * (vPass + 1) + 1;
               }
            }
            else
            {
               sourceRect.height = totalHeight - data.height * vPass;
               if (direction == FillDirection.TOP_TO_BOTTOM)
               {
                  sourceRect.y = 0;
                  destPoint.y = data.height * vPass + top; 
               }
               else
               {
                  sourceRect.y = data.height - sourceRect.height;
                  destPoint.y = top;
               }
            }
            for (var hPass:int = 0; hPass < horizontalPasses; hPass++)
            {
               sourceRect.width = hPass + 1 != horizontalPasses ?
                  data.width : totalWidth - data.width * hPass;
               destPoint.x = data.width * hPass;
               background.copyPixels(data, sourceRect, destPoint);
            }
         }   
      }
      
      private function getBorderImage(part: String) : BitmapData
      {
         return ImagePreloader.getInstance()
            .getImage(AssetNames.getBattlefieldBorderImage(part));
      }
      
      
      private function getPartImage(part:String) : BitmapData
      {
         return ImagePreloader.getInstance()
            .getImage(AssetNames.getBattlefieldBackgroundImage(part, terrainType));
      }
   }
}


class FillDirection
{
   public static const BOTTOM_TO_TOP:int = -1;
   public static const TOP_TO_BOTTOM:int =  1;
}