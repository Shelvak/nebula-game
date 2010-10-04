package utils.components
{
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   
   import mx.core.UIComponent;
   import mx.graphics.BitmapFillMode;
   
   import spark.components.Group;
   import spark.core.IGraphicElement;
   import spark.primitives.BitmapImage;
   
   
   /**
    * Similar to <code>mx.core.Image</code> in the way that this component centers
    * the source image instead of sticking it to top left corner.
    */
   public class CenteredBitmapImage extends UIComponent
   {
      public function CenteredBitmapImage()
      {
         super();
      }
      
      
      
      /* ################ */
      /* ### CHILDREN ### */
      /* ################ */
      
      
      private var _bitmap:Bitmap;
      protected override function createChildren() : void
      {
         super.createChildren();
         _bitmap = new Bitmap();
         addChild(_bitmap);
      }
      
      
      /* ################## */
      /* ### PROPERTIES ### */
      /* ################## */
      
      
      private var _source:BitmapData = null;
      /**
       * @see spark.primitives.BitmapImage#source
       */
      public function set source(value:BitmapData) : void
      {
         if (_source != value)
         {
            _source = value;
            _fSourceChanged = true;
            invalidateProperties();
         }
      }
      /**
       * @private
       */
      public function get source():BitmapData
      {
         return _source;
      }
      
      
      private var _smooth:Boolean = false;
      /**
       * @see spark.primitives.BitmapImage#smooth
       */
      public function set smooth(value:Boolean) : void
      {
         if (_smooth != value)
         {
            _smooth = value;
            _fSmoothChanged = true;
            invalidateProperties();
         }
      }
      /**
       * @private
       */
      public function get smooth() : Boolean
      {
         return _smooth;
      }
      
      
      private var _fSmoothChanged:Boolean = true;
      private var _fSourceChanged:Boolean = true;
      protected override function commitProperties() : void
      {
         super.commitProperties();
         
         if (_fSmoothChanged)
         {
            _bitmap.smoothing = _smooth;
         }
         if (_fSourceChanged)
         {
            _bitmap.bitmapData = _source;
            invalidateDisplayList();
            invalidateSize();
         }
         
         _fSmoothChanged = false;
         _fSourceChanged = false;
      }
      
      
      /* ############ */
      /* ### SIZE ### */
      /* ############ */
      
      
      protected override function measure() : void
      {
         if (_source == null)
         {
            measuredWidth = 0;
            measuredHeight = 0;
            measuredMinWidth = 0;
            measuredMinHeight = 0;
         }
         else
         {
            measuredWidth = _source.width;
            measuredHeight = _source.height;
         }
      }
      
      
      /* ############### */
      /* ### VISUALS ### */
      /* ############### */
      
      
      protected override function updateDisplayList(uw:Number, uh:Number) : void
      {
         super.updateDisplayList(uw, uh);
         
         if (_source == null)
         {
            return;
         }
         
         var sourceWHRatio:Number = _source.width / _source.height;
         var widthRatio:Number = _source.width / uw;
         var heightRatio:Number = _source.height / uh;
         
         if (widthRatio > heightRatio)
         {
            _bitmap.scaleX = uw / _source.width;
            _bitmap.scaleY = uw / (_source.height * sourceWHRatio);
            _bitmap.x = 0;
            _bitmap.y = (uh - _bitmap.height) / 2;
         }
         else
         {
            _bitmap.scaleY = uh / _source.height;
            _bitmap.scaleX = uh / (_source.width / sourceWHRatio);
            _bitmap.y = 0;
            _bitmap.x = (uw - _bitmap.width) / 2;
         }
      }
   }
}