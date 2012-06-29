package components.map.space.galaxy
{
   import flash.display.BitmapData;

   import models.player.PlayerMinimal;

   import utils.Objects;
   import utils.assets.AssetNames;
   import utils.assets.ImagePreloader;
   import utils.locale.Localizer;


   public class MSingleAsset
   {
      private var _player: PlayerMinimal;
      private var _assetType: String;

      public function MSingleAsset(assetType: String, player: PlayerMinimal) {
         _player = Objects.paramNotNull("player", player);
         _assetType = Objects.paramNotEmpty("assetType", assetType);
      }

      public function get player(): PlayerMinimal {
         return _player;
      }

      public function get tooltip(): String {
         return Localizer.string('Galaxy', 'label.' + _assetType);
      }

      public function get icon(): BitmapData {
         return ImagePreloader.getInstance().getImage(AssetNames.getSSStatusIconName(_assetType));
      }
   }
}
