package components.map.space
{
   import flash.display.BitmapData;

   import mx.collections.ArrayList;
   import mx.collections.IList;

   import utils.Objects;
   import utils.assets.AssetNames;
   import utils.assets.ImagePreloader;
   import utils.locale.Localizer;


   public class CSolarSystemAssetsM
   {
      private var _assetType: String;
      private var _hasPlayers: Boolean;
      private var _players: Array;

      public function CSolarSystemAssetsM(assetType: String, hasPlayers: Boolean, players: Array) {
         _assetType = Objects.paramNotEmpty("assetType", assetType);
         _players = Objects.paramNotNull("players", players);
         _hasPlayers = hasPlayers;
      }

      public function get visible(): Boolean {
         return _hasPlayers;
      }

      public function get dataProvider(): IList {
         return new ArrayList(_players);
      }

      public function get icon(): BitmapData {
         return ImagePreloader.getInstance().getImage(AssetNames.getSSStatusIconName(_assetType));
      }

      public function get tooltip(): String {
         return Localizer.string('Galaxy', 'label.' + _assetType);
      }
   }
}
