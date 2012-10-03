/**
 * Created with IntelliJ IDEA.
 * User: jho
 * Date: 10/3/12
 * Time: 10:22 AM
 * To change this template use File | Settings | File Templates.
 */
package models.notification {
   import flash.display.BitmapData;
   import flash.events.MouseEvent;

   import models.player.PlayerOptions;
   import models.resource.ResourceType;

   import utils.assets.AssetNames;

   import utils.locale.Localizer;

   public class MCredsGainedEvent extends MEvent {

         public function MCredsGainedEvent(amount: int) {
            super(Localizer.string("Notifications", "message.credsGained",
                  [amount]),
               PlayerOptions.actionEventTime * 1000);
         }

         public override function get image(): BitmapData
         {
            return IMG.getImage(AssetNames.UI_IMAGES_FOLDER +
               ResourceType.CREDS + '_large');
         }

         public override function clickHandler(event: MouseEvent): void {
            //TODO maby someday implement open main menu
         }
      }
}
