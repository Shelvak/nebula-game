package models.cooldown
{
   import flash.display.BitmapData;

   import models.map.IMStaticSpaceObject;
   import models.map.MMapSpace;

   import utils.assets.AssetNames;


   public class MCooldownSpace extends MCooldown implements IMStaticSpaceObject
   {
      public function MCooldownSpace() {
         super();
      }

      /**
       * All frames of cooldown animation.
       */
      public function get framesData(): Vector.<BitmapData> {
         return IMG.getFrames(
            AssetNames.UI_MAPS_SPACE_STATIC_OBJECT + "cooldown_indicator"
         );
      }

      // componentWidth, componentHeight returns 1 so that cooldowns would
      // not have any effect on the dimensions and position of
      // CStaticObjectsAggregator

      /**
       * Not supported.
       *
       * @return null
       */
      public function get imageData(): BitmapData {
         return null;
      }

      /**
       * Not supported.
       *
       * @return empty string
       */
      public function get name(): String {
         return "";
      }

      public function get componentWidth(): int {
         return 1;
      }

      public function get componentHeight(): int {
         return 1;
      }

      public function get objectType(): int {
         return MMapSpace.STATIC_OBJECT_COOLDOWN;
      }
   }
}