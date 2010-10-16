package models.folliage
{
   import utils.assets.AssetNames;
   import utils.assets.ImagePreloader;
   
   import config.Config;
   
   import flash.display.BitmapData;
   import flash.errors.IllegalOperationError;
   
   import models.folliage.events.NonblockingFolliageEvent;
   
   import spark.primitives.BitmapImage;
   
   
   [Event(name="swing", type="models.folliage.events.NonblockingFolliageEvent")]
   
   
   /**
    * Folliage that does not block construction of buildings. This is just
    * an asset of planet map.
    */
   public class NonblockingFolliage extends Folliage
   {
      /* ################## */
      /* ### PROPERTIES ### */
      /* ################## */
      
      
      private var _variation:int = 0;
      [Required]
      [Bindable]
      /**
       * Variation of a folliage.
       * 
       * <p>Setting this property will dispatch
       * <code>PlanetObjectEvent.IMAGE_CHANGE</code> event.</p>
       * 
       * @default 0
       */
      public function set variation(v:int) : void
      {
         _variation = v;
         dispatchImageChangeEvent();
      }
      /**
       * @private
       */
      public function get variation() : int
      {
         return _variation;
      }
      
      
      /**
       * Not supported. Use <code>framesData</code> instead.
       * 
       * @throws IllegalOperationError if you try to read this property
       */
      override public function get imageData() : BitmapData
      {
         throw new IllegalOperationError("This property is not supported. Use [prop framesData] instead");
      }
      
      
      [Bindable(event="planetObjectImageChange")]
      /**
       * List of animation frames of the folliage.
       */
      public function get framesData() : Vector.<BitmapData>
      {
         return ImagePreloader.getInstance().getFrames
            (AssetNames.getNonBlockingFolliagesFramesFolder(terrainType, variation));
      }
      
      
      public override function get imageHeight():Number
      {
         return framesData[0].height;
      }
      
      
      public override function get imageWidth():Number
      {
         return framesData[0].width;
      }
      
      
      /**
       * A hash of available animations.
       */
      public function get animations() : Object
      {
         return Config.getNonBlockingFolliageAnimations(terrainType, variation);
      }
      
      
      [Bindable(event="planetObjectDimensionChange")]
      /**
       * This property is <strong>Read Only</strong>. It <strong>does
       * not have</strong> <code>Required</code> metadata tag defined.
       * 
       * @see models.planet.PlanetObject#xEnd
       */
      override public function set xEnd(v:Number) : void
      {
         throw new IllegalOperationError("xEnd Read Only property is.");
      }
      /**
       * @private
       */
      override public function get xEnd() : Number
      {
         return x;
      };
      
      
      [Bindable(event="planetObjectDimensionChange")]
      /**
       * This property is <strong>Read Only</strong>. It <strong>does
       * not have</strong> <code>Required</code> metadata tag defined.
       * 
       * @see models.planet.PlanetObject#yEnd
       */
      override public function set yEnd(v:Number) : void
      {
         throw new IllegalOperationError("yEnd Read Only property is.");
      }
      /**
       * @private
       */
      override public function get yEnd() : Number
      {
         return y;
      };
      
      
      [Bindable(event="planetObjectDimensionChange")]
      override public function get width() : Number
      {
         return 1;
      };
      
      
      [Bindable(event="planetObjectDimensionChange")]
      override public function get height() : Number
      {
         return 1;
      }
      
      
      /**
       * Returns <strong><code>false</code></strong>.
       * 
       * @see models.planet.PlanetObject#isBlocking
       */
      override public function get isBlocking() : Boolean
      {
         return false;
      }
      
      
      /* ######################### */
      /* ### INTERFACE METHODS ### */
      /* ######################### */
      
      
      public function swing() : void
      {
         if (animations && hasEventListener(NonblockingFolliageEvent.SWING))
         {
            dispatchEvent(new NonblockingFolliageEvent(NonblockingFolliageEvent.SWING));
         }
      }
   }
}