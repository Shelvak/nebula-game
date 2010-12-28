package models
{
   import flash.display.BitmapData;
   
   import models.location.LocationMinimal;
   
   
   public class Wreckage extends BaseModel implements IStaticSpaceSectorObject
   {
      public function Wreckage()
      {
         super();
      }
      
      
      public function get objectType() : String
      {
         return StaticSpaceObjectsAggregator.TYPE_WRECKAGE;
      }
      
      
      private var _currentLocation:LocationMinimal;
      [Bindable]
      [Required(alias="location")]
      /**
       * <p><i><b>Metadata</b>:<br/>
       * [Bindable]<br/>
       * [Required(alias="location")]</p>
       *  
       * @copy IStaticSpaceObject#currentLocation
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
      
      
      [Bindable(event="willNotChange")]
      /**
       * <p><i><b>Metadata</b>:<br/>
       * [Bindable(event="willNotChange")]</p>
       */
      public function get imageData() : BitmapData
      {
         return null;
      }
      
      
      [Bindable(event="willNotChange")]
      /**
       * <p><i><b>Metadata</b>:<br/>
       * [Bindable(event="willNotChange")]</p>
       */
      public function get componentWidth() : int
      {
         return 0;
      }
      
      
      [Bindable(event="willNotChange")]
      /**
       * <p><i><b>Metadata</b>:<br/>
       * [Bindable(event="willNotChange")]</p>
       */
      public function get componentHeight() : int
      {
         return 0;
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
         return "[class: " + className + ", id: " + ", currentLocation: " + currentLocation + "]";
      }
   }
}