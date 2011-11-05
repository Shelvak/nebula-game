package models
{
   import flash.display.BitmapData;
   import flash.errors.IllegalOperationError;
   
   import models.location.LocationMinimal;
   import models.map.MMapSpace;
   
   import utils.assets.AssetNames;
   import models.map.IMStaticSpaceObject;
   
   
   public class MWreckage extends BaseModel implements IMStaticSpaceObject
   {
      public function MWreckage()
      {
         super();
      }
      
      
      public function get objectType() : int
      {
         return MMapSpace.STATIC_OBJECT_WRECKAGE
      }
      
      
      private var _currentLocation:LocationMinimal;
      [Bindable(event="willNotChange")]
      [Required(alias="location")]
      [SkipProperty]
      /**
       * <p><i><b>Metadata</b>:<br/>
       * [Bindable(event="willNotChange")]<br/>
       * [Required(alias="location")]<br/>
       * [SkipProperty]</i></p>
       */
      public function set currentLocation(value:LocationMinimal) : void
      {
         if (_currentLocation != value)
         {
            _currentLocation = value;
         }
      }
      /**
       * @private
       */
      public function get currentLocation() : LocationMinimal
      {
         return _currentLocation;
      }
      
      
      public function get isNavigable() : Boolean
      {
         return false;
      }
      
      
      public function navigateTo() : void
      {
         throw new IllegalOperationError("Wreckage type static objects are not navigable!");
      }
      
      
      [Bindable(event="willNotChange")]
      public function get imageData() : BitmapData
      {
         return IMG.getImage(AssetNames.getIconImageName("wreckage"));;
      }
      
      
      [Bindable(event="willNotChange")]
      public function get componentWidth() : int
      {
         return imageData.width;
      }
      
      
      [Bindable(event="willNotChange")]
      public function get componentHeight() : int
      {
         return imageData.height;
      }
      
      
      [Bindable]
      [Required]
      /**
       * <p><i><b>Metadata</b>:<br/>
       * [Bindable]<br/>
       * [Required]</p> 
       */
      public var metal:Number;
      
      
      [Bindable]
      [Required]
      /**
       * <p><i><b>Metadata</b>:<br/>
       * [Bindable]<br/>
       * [Required]</p> 
       */
      public var energy:Number;
      
      
      [Bindable]
      [Required]
      /**
       * <p><i><b>Metadata</b>:<br/>
       * [Bindable]<br/>
       * [Required]</p> 
       */
      public var zetium:Number;
      
      
      public override function toString() : String
      {
         return "[class: " + className + 
            ", id: " + id + 
            ", currentLocation: " + currentLocation + "]";
      }
   }
}