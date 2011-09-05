package components.dailybonus
{
   import components.base.AttentionButton;
   import components.popups.ActionConfirmationPopup;
   
   import controllers.dailybonus.DailyBonusCommand;
   
   import flash.display.BitmapData;
   import flash.events.MouseEvent;
   
   import models.ModelLocator;
   import models.player.Player;
   
   import mx.events.PropertyChangeEvent;
   
   import spark.components.Button;
   
   import utils.assets.AssetNames;
   import utils.assets.ImagePreloader;
   import utils.locale.Localizer;
   
   
   public class DailyBonusButton extends AttentionButton
   {
      private function getImage(name:String) : BitmapData {
         return ImagePreloader.getInstance().getImage(AssetNames.BUTTONS_IMAGE_FOLDER + "daily_bonus_" + name);
      }
      
      private function get player() : Player {
         return ModelLocator.getInstance().player;
      }
      
      
      public function DailyBonusButton() {
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
         this.enabled = this.visible = player.dailyBonus != null;
      }
      
      private function this_clickHandler(event:MouseEvent) : void {
         var popup:ActionConfirmationPopup = new ActionConfirmationPopup();
         var cont:DailyBonusComp = new DailyBonusComp();
         cont.reward = player.dailyBonus;
         cont.addEventListener(
            DailyBonusEvent.CLOSE_PANEL, 
            function(event:DailyBonusEvent):void {
               popup.close();
            }
         );
         popup.title = Localizer.string('Popups', 'title.dailyBonus');
         popup.addElement(cont);
         popup.confirmButtonLabel = Localizer.string('Quests', 'label.claimReward');
         popup.cancelButtonLabel  = Localizer.string('Quests', 'label.claimLater');
         popup.confirmButtonClickHandler = function(button:Button) : void {
            new DailyBonusCommand(DailyBonusCommand.CLAIM, 
               {'planetId': MSSObject(cont.planetSelector.selectedItem).id}
            ).dispatch();
         };
         popup.show()
      }
   }
}