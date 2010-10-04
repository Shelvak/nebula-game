package components.battle
{
   import animation.AnimatedBitmap;
   import animation.AnimationTimer;
   
   import config.Config;
   
   import flash.display.BitmapData;
   import flash.errors.IllegalOperationError;
   
   import models.BaseModel;
   import models.IAnimatedModel;
   
   import utils.ClassUtil;

   public class BAnimatedBitmap extends AnimatedBitmap
   {
      private var _model:IAnimatedModel;
      public function get model() : IAnimatedModel
      {
         return _model;
      }
      
      
      public function BAnimatedBitmap(model:IAnimatedModel)
      {
         super();
         ClassUtil.checkIfParamNotNull("model", model);
         _model = model;
         
         setTimer(AnimationTimer.forBattle);
         initFrames();
         initAnimations();
         
         smooth = true;
      }
      
      
      protected function initFrames() : void
      {
      }
      
      
      protected function initAnimations() : void
      {
      }
      
      
      protected function getFrameWidth() : int
      {
         return _model.frameWidth;
      }
      
      
      public override function setFrames(framesData:Vector.<BitmapData>) : void
      {
         super.setFrames(framesData);
         transformX = width / 2;
         transformY = height / 2;
      }
      
      
      /* ####################### */
      /* ### TRANSFORMATIONS ### */
      /* ####################### */
      
      
      private var _flippedHorizontally:Boolean = false;
      public function get flippedHorizontally() : Boolean
      {
         return _flippedHorizontally;
      }
      /**
       * Flips component horizontally.
       */
      public function flipHorizontally() : void
      {
         _flippedHorizontally = !_flippedHorizontally;
         if (_flippedHorizontally)
         {
            scaleX = -1
         }
         else
         {
            scaleX = 1;
         }
      }
      
      
      private var _flippedVertically:Boolean = false;
      /**
       * Flips component vertically.
       */
      public function get flippedVertically() : Boolean
      {
         return _flippedVertically;
      }
      public function flipVertically() : void
      {
         _flippedVertically = !_flippedVertically;
         if (_flippedVertically)
         {
            scaleY = -1;
         }
         else
         {
            scaleY = 1;
         }
      }
   }
}