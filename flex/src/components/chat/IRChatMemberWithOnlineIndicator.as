package components.chat
{
   import flash.display.BitmapData;

   import models.chat.MChatMember;

   import models.chat.events.MChatMemberEvent;

   import mx.core.IVisualElement;

   import spark.primitives.BitmapImage;

   import utils.assets.AssetNames;
   import utils.assets.ImagePreloader;


   public class IRChatMemberWithOnlineIndicator extends IRChatMember
   {
      private static const ICON_KEY_ONLINE:String = "online";
      private static const ICON_KEY_OFFLINE: String = "offline";


      /* ############# */
      /* ### MODEL ### */
      /* ############# */

      override protected function set model(value: MChatMember): void {
         if (model != value) {
            if (model != null) {
               model.removeEventListener(
                  MChatMemberEvent.IS_ONLINE_CHANGE,
                  model_isOnlineChange, false
               );
            }
            super.model = value;
            if (model != null) {
               model.addEventListener(
                  MChatMemberEvent.IS_ONLINE_CHANGE,
                  model_isOnlineChange, false, 0, true
               );
            }
         }
      }

      override protected function modelCommit(): void {
         super.modelCommit();
         updateBmpOnlineIndicatorSource();
      }

      private function model_isOnlineChange(event: MChatMemberEvent): void {
         updateBmpOnlineIndicatorSource();
      }


      /* ################ */
      /* ### CHILDREN ### */
      /* ################ */

      private var bmpOnlineIndicator: BitmapImage;


      override protected function createOnlineIcon(): IVisualElement {
         const icon: BitmapImage = new BitmapImage();
         updateBmpOnlineIndicatorSource();
         return icon;
      }

      private function updateBmpOnlineIndicatorSource(): void {
         if (bmpOnlineIndicator != null) {
            if (model != null && model.isOnline) {
               bmpOnlineIndicator.source = getIcon(ICON_KEY_ONLINE);
            }
            else {
               bmpOnlineIndicator.source = getIcon(ICON_KEY_OFFLINE);
            }
         }
      }


      /* ############### */
      /* ### HELPERS ### */
      /* ############### */

      private function getIcon(key: String): BitmapData {
         return ImagePreloader.getInstance()
                   .getImage(AssetNames.getIconImageName(key));
      }
   }
}
