package components.base
{
   import flash.display.BitmapData;
   
   import spark.components.Button;
   import spark.effects.Fade;
   import spark.effects.animation.RepeatBehavior;
   import spark.primitives.BitmapImage;
 
   
   public class AttentionButton extends Button
   {
      private var _fade:Fade;
      
      
      public function AttentionButton() {
         super();
         setStyle("skinClass", AttentionButtonSkin);
      }
      
      
      private var _upImage:BitmapData;
      public function set upImage(value:BitmapData) : void {
         _upImage = value;
      }
      
      private var _overImage:BitmapData;
      public function set overImage(value:BitmapData) : void {
         _overImage = value;
      }
      
      private var _fadeImage:BitmapData;
      public function set fadeImage(value:BitmapData) : void {
         _fadeImage = value;
      }
      
      
      [SkinPart(required="true")]
      public var bmpMainImage:BitmapImage;
      
      [SkinPart(required="true")]
      public var bmpFadeImage:BitmapImage;
      
      protected override function partAdded(partName:String, instance:Object) : void {
         super.partAdded(partName, instance);
         if (instance == bmpFadeImage) {
            bmpFadeImage.source = _fadeImage;
            _fade = new Fade(bmpFadeImage);
            _fade.alphaFrom = 1;
            _fade.alphaTo = 0;
            _fade.repeatBehavior = RepeatBehavior.REVERSE;
            _fade.duration = 1000;
            _fade.repeatCount = 0;
         }
      }
      
      protected override function stateChanged(oldState:String, newState:String, recursive:Boolean) : void {
         super.stateChanged(oldState, newState, recursive);
         switch (newState)
         {
            case "up":
               bmpMainImage.source = _upImage;
               bmpFadeImage.visible = true;
               _fade.play();
               break;
               
            case "disabled":
               bmpMainImage.source = _upImage;
               bmpFadeImage.visible = false;
               _fade.stop();
               break;
            
            case "down":
            case "over":
               bmpMainImage.source = _overImage;
               bmpFadeImage.visible = false;
               _fade.stop();
               break;
         }
      }
   }
}