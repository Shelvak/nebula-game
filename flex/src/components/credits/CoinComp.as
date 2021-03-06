package components.credits {
   import animation.AnimatedBitmap;
   import animation.AnimationTimer;
   import animation.Sequence;
   
   import config.Config;
   
   import spark.components.Group;
   
   import utils.assets.AssetNames;
   import utils.assets.ImagePreloader;
   
   
   public class CoinComp extends Group
   {
      private var aBitmap: AnimatedBitmap;
      
      public function CoinComp() 
      {
         super();
         aBitmap = new AnimatedBitmap();
         aBitmap.setTimer(AnimationTimer.forUi);
         addElement(aBitmap);
         play();
         
      }
      
      protected function setAnimations() : void
      {
         var animations:Object = Config.getAssetValue("images.ui.credit.actions");
         for (var action:String in animations)
         {
            var anim:Object = animations[action];
            aBitmap.addAnimation(action, new Sequence(anim.start, anim.loop, anim.finish));
         }
      }
      
      
      public function play() : void
      {
         if (!aBitmap.isPlaying)
         {
            if (!aBitmap.hasAnimations)
            {
               aBitmap.setFrames(ImagePreloader.getInstance().getFrames(AssetNames.UI_IMAGES_FOLDER + 'credit'));
               setAnimations();
            }
            aBitmap.playAnimation('spin');
         }
      }
      
      
      public function stop() : void
      {
         if (aBitmap.isPlaying)
         {
            aBitmap.stopAnimations();            
         }
      }
   }
}