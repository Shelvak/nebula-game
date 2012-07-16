/**
 * Created with IntelliJ IDEA.
 * User: jho
 * Date: 6/28/12
 * Time: 3:17 PM
 * To change this template use File | Settings | File Templates.
 */
package models.unit {
   import config.Config;

   import flash.display.BitmapData;
   import flash.events.MouseEvent;

   import utils.assets.AssetNames;
   import utils.assets.ImagePreloader;

   public class MLoadableUnit extends MLoadable {
      public function MLoadableUnit(_type: String,  _count: int) {
         super();
         count = _count;
         type = _type;
      }

      public override function clickHandler(e: MouseEvent): void {
         AL.loadUnits(type);
      }

      private var type: String;

      public override function get image(): BitmapData
      {
         return ImagePreloader.getInstance().getImage(
            AssetNames.getUnitImageName(type));
      }
   }
}
