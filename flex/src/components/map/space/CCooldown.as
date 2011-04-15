package components.map.space
{
   import animation.AnimatedBitmap;
   import animation.AnimationTimer;
   
   import config.Config;
   
   import flash.events.Event;
   
   import models.cooldown.MCooldownSpace;

   public class CCooldown extends CStaticSpaceObject
   {
      public function CCooldown()
      {
         super();
         addEventListener(Event.REMOVED_FROM_STAGE, this_removedFromStageHandler, false, 0, true);
      }
      
      
      private var _image:AnimatedBitmap;
      protected override function createChildren() : void
      {
         super.createChildren();
         
         _image = AnimatedBitmap.createInstance(
            MCooldownSpace(staticObject).framesData,
            Config.getAssetValue("images.ui.maps.space.staticObject.cooldownIndicator.actions"),
            AnimationTimer.forUi
         );
         _image.verticalCenter =
         _image.horizontalCenter = 0;
         _image.playAnimation("spin");
         addElement(_image);
      }
      
      
      private function this_removedFromStageHandler(event:Event) : void
      {
         if (_image != null)
         {
            _image.stopAnimationsImmediately();
            _image.cleanup();
            removeElement(_image);
            _image = null;
         }
      }
   }
}