/**
 * Created with IntelliJ IDEA.
 * User: jho
 * Date: 4/18/12
 * Time: 4:43 PM
 * To change this template use File | Settings | File Templates.
 */
package components.registerrequired {
   import components.base.AttentionButton;
   import components.popups.ActionConfirmationPopUp;

   import flash.display.BitmapData;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.utils.Timer;

   import models.ModelLocator;
   import models.player.Player;

   import mx.events.PropertyChangeEvent;

   import spark.components.Button;
   import spark.components.Label;

   import utils.UrlNavigate;

   import utils.assets.AssetNames;
   import utils.assets.ImagePreloader;
   import utils.locale.Localizer;


   public class RegisterButton extends AttentionButton
   {
      private static const TIMER_DELAY: int = 180000; // 3 minutes

      private function getImage(name:String) : BitmapData {
         return ImagePreloader.getInstance().getImage(AssetNames.BUTTONS_IMAGE_FOLDER + "registration/button_" + name);
      }

      private function get player() : Player {
         return ModelLocator.getInstance().player;
      }


      public function RegisterButton() {
         super();
         upImage   = getImage("up");
         fadeImage = getImage("blink");
         overImage = getImage("over");
         addEventListener(MouseEvent.CLICK, this_clickHandler, false, 0, true);
         player.addEventListener(PropertyChangeEvent.PROPERTY_CHANGE, player_propertyChangeHandler, false, 0, true);
         updateVisibility();
      }


      private function player_propertyChangeHandler(event:PropertyChangeEvent) : void {
         updateVisibility()
      }

      private function updateVisibility() : void {
         this.enabled = this.visible = player.trial;
         if (timer == null && player.trial && !popupVisible)
         {
            setTimer();
         }
         else if (!player.trial && timer != null)
         {
            removeTimer();
         }
      }

      private var timer: Timer;

      private var popupVisible: Boolean = false;

      private function setTimer(): void
      {
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

      private function showPopup(e: TimerEvent): void
      {
         popupVisible = true;
         removeTimer();
         var popup:ActionConfirmationPopUp = new ActionConfirmationPopUp();
         var cont:Label = new Label();
         cont.text = Localizer.string('Popups', 'message.registration');
         popup.title = Localizer.string('Popups', 'title.registration');
         popup.addElement(cont);
         popup.confirmButtonLabel = Localizer.string('Players', 'label.registerNow');
         popup.cancelButtonLabel  = Localizer.string('Players', 'label.registerLater');
         popup.cancelButtonClickHandler = function(button:Button) : void {
            setTimer();
         };
         popup.confirmButtonClickHandler = function(button:Button) : void {
            this_clickHandler();
         };
         popup.show()
      }

      private function this_clickHandler(event:MouseEvent = null) : void {
         UrlNavigate.getInstance().showRegistrationUrl();
      }
   }
}