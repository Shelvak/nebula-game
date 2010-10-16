package components.spinner {
	import animation.AnimatedBitmap;
	import animation.AnimationTimer;
	import animation.Sequence;
	
	import config.Config;
	
	import mx.events.FlexEvent;
	
	import utils.assets.AssetNames;
	import utils.assets.ImagePreloader;
   
	public class Spinner extends AnimatedBitmap {
		
//		public var autoPlay:Boolean = true;
      private var _isPlaying: Boolean = false;
		
		
		public function Spinner() 
      {
			super();
         setTimer(AnimationTimer.forUi);
//			addEventListener(FlexEvent.CREATION_COMPLETE, handleCreationComplete);
		}
      
//      private function handleCreationComplete(e: FlexEvent): void
//      {
//         if (autoPlay)
//         {
//            play();
//         }
//      }
      
      protected function setAnimations(): void
      {
         var key:String = "images.ui.spinner.";
         var animations: Object = Config.getAssetValue(key + "actions");
         for (var action: String in animations)
         {
            var anim:Object = animations[action];
            addAnimation(action, new Sequence(anim.start, anim.loop, anim.finish));
         }
      }
		
		/**
		 * Begin the circular fading of the ticks.
		 */
		public function play():void {
			if (! _isPlaying) {
            if (!hasAnimations)
            {
               setFrames(ImagePreloader.getInstance().getFrames(AssetNames.UI_IMAGES_FOLDER+'spinner'));
               setAnimations();
            }
				playAnimation('spin');
				_isPlaying = true;
			}
		}
		
		/**
		 * Stop the spinning.
		 */
		public function stop():void {
				_isPlaying = false;
            stopAnimations();
		}
		
		public function get isPlaying():Boolean {
			return _isPlaying;
		}
	}
}