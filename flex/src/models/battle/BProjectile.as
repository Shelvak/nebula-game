package models.battle
{
   import config.BattleConfig;
   
   import flash.display.BitmapData;
   import flash.geom.Point;
   
   import models.BaseModel;
   import models.IAnimatedModel;
   
   import utils.StringUtil;
   import utils.assets.AssetNames;
   import utils.assets.ImagePreloader;
   
   
   public class BProjectile extends BaseModel implements IAnimatedModel
   {
      public static function getDelay(gunType:String) : Number
      {
         return BattleConfig.getGunDelay(gunType); 
      }
      
      
      public static function getSpeed(gunType:String) : Number
      {
         return BattleConfig.getGunSpeed(gunType); 
      }
      
      
      include "mixins/frameDimensions.as";
      
      
      public var gunType:String = "MachineGun";
      
      
      public function get speed() : Number
      {
         return getSpeed(gunType);
      }
      
      
      public function get headCoords() : Point
      {
         return BattleConfig.getProjectileHeadCoords(gunType);
      }
      
      
      public function get tailCoords() : Point
      {
         return BattleConfig.getProjectileTailCoords(gunType);
      }
      
      
      public function get framesData() : Vector.<BitmapData>
      {
         return ImagePreloader.getInstance().getFrames(
            AssetNames.getProjectileFramesFolder(StringUtil.camelCaseToUnderscore(gunType))
         );
      }
   }
}