package models.battle
{
   import utils.assets.AssetNames;
   import utils.assets.ImagePreloader;
   
   import config.Config;
   
   import flash.display.BitmapData;
   import flash.geom.Point;
   
   import models.BaseModel;
   import models.IAnimatedModel;
   
   import utils.StringUtil;
   
   
   public class BProjectile extends BaseModel implements IAnimatedModel
   {
      include "mixins/frameDimensions.as";
      
      
      public var gunType: String = "MachineGun";
      
      public var fromPosition:Point = null;
      
      public var toPosition:Point = null;
      
      
      /**
       * @see models.battle.BGun#getProjectileSpeed()
       */
      public function get speed() : Number
      {
         return BProjectileSpeed.getSpeed(gunType);
      }
      
      
      public function get framesData() : Vector.<BitmapData>
      {
         return ImagePreloader.getInstance().getFrames(
            AssetNames.getProjectileFramesFolder(StringUtil.camelCaseToUnderscore(gunType))
         );
      }
      
      
      public function get pathLength(): Number
      {
         return Point.distance(fromPosition, toPosition);
      }
      
      
      public function get isFromLeftToRight() : Boolean
      {
         return fromPosition.x < toPosition.x;
      }
   }
}