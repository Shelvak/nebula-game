package models.cooldown
{
   import flash.display.BitmapData;
   
   import models.IMStaticSpaceObject;
   import models.map.MMapSpace;
   
   import utils.assets.AssetNames;
   
   
   public class MCooldownSpace extends MCooldown implements IMStaticSpaceObject
   {
      public function MCooldownSpace()
      {
         super();
      }
      
      
      /**
       * All frames of cooldown animation.
       */
      public function get framesData() : Vector.<BitmapData>
      {
         return IMG.getFrames(AssetNames.UI_MAPS_SPACE_STATIC_OBJECT + "cooldown_indicator");
      }
      
      
      public function get componentWidth() : int
      {
         return framesData[0].width;
      }
      
      
      public function get componentHeight() : int
      {
         return framesData[0].height;
      }
      
      
      public function get objectType() : int
      {
         return MMapSpace.STATIC_OBJECT_COOLDOWN;
      }
   }
}