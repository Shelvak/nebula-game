package components.base {
   import animation.AnimatedBitmap;
   import animation.AnimationTimer;
   import animation.Sequence;
   
   import config.Config;
   
   import utils.assets.AssetNames;
   import utils.assets.ImagePreloader;
   
   
   public class CoinComp extends AnimatedBitmap
   {
      public function CoinComp() 
      {
         super();
         setTimer(AnimationTimer.forUi);
         play();
      }
      
      protected function setAnimations() : void
      {
         var animations:Object = Config.getAssetValue("images.ui.credit.actions");
         for (var action:String in animations)
         {
            var anim:Object = animations[action];
            addAnimation(action, new Sequence(anim.start, anim.loop, anim.finish));
         }
      }
      
      
      public function play() : void
      {
         if (!isPlaying)
         {
            if (!hasAnimations)
            {
               setFrames(ImagePreloader.getInstance().getFrames(AssetNames.UI_IMAGES_FOLDER + 'credit'));
               setAnimations();
            }
            playAnimation('spin');
         }
      }
      
      
      public function stop() : void
      {
         if (isPlaying)
         {
            stopAnimations();            
         }
      }
   }
}