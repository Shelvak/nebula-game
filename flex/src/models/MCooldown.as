package models
{
   import flash.display.BitmapData;
   
   import models.location.LocationMinimal;
   import models.map.MMapSpace;
   
   import utils.assets.AssetNames;
   
   
   public class MCooldown extends BaseModel implements IMStaticSpaceObject
   {
      public function MCooldown()
      {
         super();
      }
      
      
      /**
       * Time when this cooldown ends.
       * 
       * @default null;
       */
      public var endsAt:Date = null;
      
      
      public function get objectType() : int
      {
         return MMapSpace.STATIC_OBJECT_COOLDOWN;
      }
      
      
      private var _currentLocation:LocationMinimal;
      public function get currentLocation() : LocationMinimal
      {
         return _currentLocation;
      }
      /**
       * @private
       */
      public function set currentLocation(value:LocationMinimal) : void
      {
         if (_currentLocation != value)
         {
            _currentLocation = value;
         }
      }
      
      
      /**
       * All frames of cooldown animation.
       */
      public function get framesData() : Vector.<BitmapData>
      {
         return IMG.getFrames(AssetNames.UI_MAPS_SPACE_STATIC_OBJECT + "cooldown");
      }
      
      
      public function get componentWidth() : int
      {
         return framesData[0].width;
      }
      
      
      public function get componentHeight() : int
      {
         return framesData[0].height;
      }
      
      
      public function get isNavigable() : Boolean
      {
         return false;
      }
      
      
      public function navigateTo() : void
      {
      }
   }
}