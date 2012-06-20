package components.map.space
{
   import models.player.PlayerMinimal;

   import mx.collections.ArrayList;
   import mx.collections.IList;

   import utils.Objects;


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
         return new ArrayList(_players.map(
            function (player: PlayerMinimal, index: int, array: Array): MSingleAsset {
               return new MSingleAsset(_assetType, player);
            }
         ));
      }
   }
}
