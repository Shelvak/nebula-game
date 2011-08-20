package components.announcement
{
   import components.base.AttentionButton;
   
   import flash.display.BitmapData;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   import models.announcement.MAnnouncement;
   import models.announcement.MAnnouncementEvent;
   
   import utils.assets.AssetNames;
   import utils.assets.ImagePreloader;
   
   public class AnnouncementButton extends AttentionButton
   {
      private function getImage(name:String) : BitmapData {
         return ImagePreloader.getInstance()
            .getImage(AssetNames.ANNOUNCEMENTS_IMAGES_FOLDER + "button_" + name);
      }
      
      private function get model() : MAnnouncement {
         return MAnnouncement.getInstance();
      }
      
      
      public function AnnouncementButton() {
         super();
         this.upImage   = getImage("up");
         this.fadeImage = getImage("fade");
         this.overImage = getImage("over");
         this.addEventListener(MouseEvent.CLICK, this_clickHandler, false, 0, true);
         model.addEventListener
            (MAnnouncementEvent.BUTTON_VISIBLE_CHANGE, model_buttonVisibleChangeHandler, false, 0, true);
         updateVisibility();
      }
      
      private function updateVisibility() : void {
         this.visible = model.buttonVisible;
         this.enabled = model.buttonVisible;
      }
      
      private function this_clickHandler(event:MouseEvent) : void {
         AnnouncementPopup.getInstance().show();
      }
      
      private function model_buttonVisibleChangeHandler(event:MAnnouncementEvent) : void {
         updateVisibility();
      }
   }
}