package components.map.space
{
   import animation.AnimatedBitmap;
   import animation.AnimationTimer;
   
   import config.Config;
   
   import models.cooldown.MCooldownSpace;
   
   
   public class CCooldown extends CStaticSpaceObject
   {
      public function CCooldown() {
         super();
      }
      
      private var _image:AnimatedBitmap;
      protected override function createChildren() : void {
         super.createChildren();
         
         _image = AnimatedBitmap.createInstance(
            new MCooldownSpace().framesData,
            Config.getAssetValue("images.ui.maps.space.staticObject.cooldownIndicator.actions"),
            AnimationTimer.forUi
         );
         _image.verticalCenter = 0;
         _image.horizontalCenter = 0;
         addElement(_image);
      }
      
      protected override function activate() : void {
         _image.playAnimation("spin");
      }
      
      protected override function passivate() : void {         
         _image.stopAnimations();
      }
   }
}