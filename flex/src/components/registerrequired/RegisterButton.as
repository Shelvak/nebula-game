/**
 * Created with IntelliJ IDEA.
 * User: jho
 * Date: 4/18/12
 * Time: 4:43 PM
 * To change this template use File | Settings | File Templates.
 */
package components.registerrequired {
   import components.base.AttentionButton;

   import flash.display.BitmapData;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.external.ExternalInterface;
   import flash.utils.Timer;

   import models.ModelLocator;
   import models.player.Player;

   import mx.events.PropertyChangeEvent;

   import spark.components.Button;

   import utils.UrlNavigate;
   import utils.assets.AssetNames;
   import utils.assets.ImagePreloader;


   public class RegisterButton extends AttentionButton
   {
      private static const TIMER_DELAY: int = 180000; // 3 minutes

      private function getImage(name:String) : BitmapData {
         return ImagePreloader.getInstance().getImage(AssetNames.UI_IMAGES_FOLDER + "registration/button_" + name);
      }

      private function get player() : Player {
         return ModelLocator.getInstance().player;
      }


      public function RegisterButton() {
         super();
         this.upImage   = getImage("up");
         this.fadeImage = getImage("blink");
         this.overImage = getImage("over");
         this.addEventListener(MouseEvent.CLICK, this_clickHandler, false, 0, true);
         player.addEventListener(PropertyChangeEvent.PROPERTY_CHANGE, player_propertyChangeHandler, false, 0, true);
         updateVisibility();
      }


      private function player_propertyChangeHandler(event:PropertyChangeEvent) : void {
         updateVisibility()
      }

      private function updateVisibility() : void {
         this.enabled = this.visible = player.trial;
         if (player.trial)
         {
            if (timer == null && !popupVisible)
            {
               setTimer();
            }
         }
         else
         {
            if (timer != null)
            {
               removeTimer();
            }
            else if (popup != null)
            {
               popup.close();
               popup = null;
            }
         }
      }

      private var timer: Timer;

      private var popupVisible: Boolean = false;

      private function setTimer(): void
      {
         if (timer != null) removeTimer();
         popupVisible = false;
         timer = new Timer(TIMER_DELAY, 1);
         timer.addEventListener(TimerEvent.TIMER, showPopup);
         timer.start();
      }

      private function removeTimer(): void
      {
         timer.removeEventListener(TimerEvent.TIMER, showPopup);
         timer.stop();
         timer = null;
      }

      private var popup:RegisterPopup;

      private function showPopup(e: TimerEvent): void
      {
         popupVisible = true;
         if (timer != null) removeTimer();
         popup = new RegisterPopup();
         popup.cancelButtonClickHandler = function(button:Button) : void {
            setTimer();
            popup = null;
         };
         popup.confirmButtonClickHandler = function(button:Button) : void {
            this_clickHandler();
            popup = null;
         };
         popup.show();
      }

      private function this_clickHandler(event:MouseEvent = null) : void {
         ExternalInterface.call("openTrialRegistration");
         setTimer();
      }
   }
}