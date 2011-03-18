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
         addEventListener(Event.REMOVED_FROM_STAGE, this_removedFromStage, false, 0, true);
      }
      
      
      private var _image:AnimatedBitmap;
      protected override function createChildren() : void
      {
         super.createChildren();
         
         _image = AnimatedBitmap.createInstance(
            MCooldownSpace(staticObject).framesData,
            Config.getValue("assets.images.ui.maps.space.staticObject.cooldownIndicator.actions"),
            AnimationTimer.forUi
         );
         _image.playAnimation("spin");
         addElement(_image);
      }
      
      
      private function this_removedFromStage(event:Event) : void
      {
         _image.stopAnimationsImmediately();
         _image.cleanup();
         removeElement(_image);
         _image = null;
      }
   }
}