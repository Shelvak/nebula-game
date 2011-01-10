package components.battle
{
   import animation.AnimatedBitmap;
   import animation.AnimationTimer;
   
   import flash.geom.Point;
   import flash.geom.Vector3D;
   
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
      
      
      /* ####################### */
      /* ### TRANSFORMATIONS ### */
      /* ####################### */
      
      
      private var _flippedHorizontally:Boolean = false;
      public function get flippedHorizontally() : Boolean
      {
         return _flippedHorizontally;
      }
      /**
       * Flips component horizontally (transformation around component's center).  Transformation point
       * is moved back to the default position ([0; 0]).
       */
      public function flipHorizontally() : void
      {
         _flippedHorizontally = !_flippedHorizontally;
         transformX = width  / 2;
         transformY = height / 2;
         scaleX = _flippedHorizontally ? -1 : 1;
      }
      
      
      private var _flippedVertically:Boolean = false;
      public function get flippedVertically() : Boolean
      {
         return _flippedVertically;
      }
      /**
       * Flips component vertically (transformation around component's center). Transformation point
       * is moved back to the default position ([0; 0]).
       */
      public function flipVertically() : void
      {
         _flippedVertically = !_flippedVertically;
         transformX = width  / 2;
         transformY = height / 2;
         scaleY = _flippedVertically ? -1 : 1;
      }
      
      
      /**
       * Makes 2D transformations around the given transformation point.
       * 
       * @see #transformAround()
       */
      public function transformAround2D(transformCenter:Point,
                                        scale:Point = null,
                                        rotation:Number = 0,
                                        translation:Point = null,
                                        postLayoutScale:Point = null,
                                        postlayoutRotation:Point = null,
                                        postLayoutTranslation:Point = null,
                                        invalidateLayout:Boolean = true) : void
      {
         function getVector3D(point:Point) : Vector3D
         {
            if (!point)
            {
               return null;
            }
            return new Vector3D(point.x, point.y);
         }
         transformAround(
            getVector3D(transformCenter),
            getVector3D(scale),
            new Vector3D(0, 0, rotation),
            getVector3D(translation),
            getVector3D(postLayoutScale),
            getVector3D(postlayoutRotation),
            getVector3D(postLayoutTranslation),
            invalidateLayout
         );
      }
   }
}