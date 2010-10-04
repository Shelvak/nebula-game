package components.battle
{
   import flash.display.BitmapData;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   
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
         
         return background;
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