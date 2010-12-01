package components.base {
	import animation.AnimatedBitmap;
	import animation.AnimationTimer;
	import animation.Sequence;
	
	import config.Config;
	
	import utils.assets.AssetNames;
	import utils.assets.ImagePreloader;
   
   
	public class Spinner extends AnimatedBitmap
   {
		public function Spinner() 
      {
			super();
         setTimer(AnimationTimer.forUi);
		}
      
      protected function setAnimations() : void
      {
         var animations:Object = Config.getAssetValue("images.ui.spinner.actions");
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
               setFrames(ImagePreloader.getInstance().getFrames(AssetNames.UI_IMAGES_FOLDER + 'spinner'));
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