/**
 * Created with IntelliJ IDEA.
 * User: jho
 * Date: 6/28/12
 * Time: 2:33 PM
 * To change this template use File | Settings | File Templates.
 */
package models.unit {
   import flash.display.BitmapData;
   import flash.events.MouseEvent;

   import models.ModelLocator;
   import models.resource.Resource;

   import utils.assets.AssetNames;

   import utils.assets.ImagePreloader;

   public class MLoadableResource extends MLoadable {
      private var resourceType: String;
      public function MLoadableResource(type: String) {
         super();
         resourceType = type;
      }

      public override function get image(): BitmapData
      {
         return ImagePreloader.getInstance().getImage(
                   AssetNames.UI_IMAGES_FOLDER + resourceType + '_large');
      }

      public override function clickHandler(e: MouseEvent): void {
         AL.transferResource(resourceType);
      }

      private function get ML(): ModelLocator
      {
         return ModelLocator.getInstance();
      }

      [Bindable(event="loadableCountChange")]
      override public function get enabled(): Boolean {
         return super.enabled && (maxVolume == PLANET_STORAGE
            ? (ML.latestPlanet.ssObject.metal.unknown ||
                !Resource(ML.latestPlanet.ssObject[resourceType]).isFull)
            : maxVolume > 0);
      }

      public override function get sidePadding(): int
      {
         return 5;
      }
   }
}
