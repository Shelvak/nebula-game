package components.gameobjects.planet
{
   import animation.AnimatedBitmap;
   import animation.Sequence;
   
   import models.folliage.NonblockingFolliage;
   import models.folliage.events.NonblockingFolliageEvent;
   
   import mx.graphics.BitmapFillMode;
   
   
   /**
    * Basic implementation of <code>IPlanetMapObject</code>. A model of this component
    * should be static and should not change through components life cycle.
    */
   public class PrimitivePlanetMapObject extends AnimatedBitmap implements IPrimitivePlanetMapObject
   {
      public function PrimitivePlanetMapObject()
      {
         super();
         smooth = true;
         fillMode = BitmapFillMode.CLIP;
      }
      
      
      include "mixin_defaultModelPropImpl.as";
      include "mixin_zIndexChangeHandler.as";
      
      
      public function setDepth() : void
      {
         depth = _model.zIndex;
      }
      
      
      /**
       * Called when model has been successfully set by <code>initModel()</code> method.
       * This method sets neccessary component properties' values.
       */
      protected function initProperties() : void
      {
         var model:NonblockingFolliage = NonblockingFolliage(_model);
         setFrames(model.framesData);
         if (model.animations)
         {
            for (var name:String in model.animations)
            {
               var anim:Object = model.animations[name];
               addAnimation(name, new Sequence(anim.start, anim.loop, anim.finish));
            }
         }
         addModelEventHandlers(model);
         setDepth();
      }
      
      
      public override function cleanup() : void
      {
         super.cleanup();
         if (model)
         {
            removeModelEventHandlers(NonblockingFolliage(model));
            _model = null;
         }
      }
      
      
      /* ###################### */
      /* ### EVENT HANDLERS ### */
      /* ###################### */
      
      
      private function addModelEventHandlers(model:NonblockingFolliage) : void
      {
         addModelZIndexChangeHandler(model);
         model.addEventListener(NonblockingFolliageEvent.SWING, model_swingHandler);
      }
      
      
      private function removeModelEventHandlers(model:NonblockingFolliage) : void
      {
         removeModelZIndexChangeHandler(model);
         model.removeEventListener(NonblockingFolliageEvent.SWING, model_swingHandler);
      }
      
      
      private function model_swingHandler(event:NonblockingFolliageEvent) : void
      {
         playAnimation("swing");
      }
   }
}