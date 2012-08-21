package models.solarsystem
{
   import flash.display.BitmapData;

   import models.OwnerType;
   import models.player.PlayerMinimal;

   import utils.ObjectStringBuilder;

   import utils.Objects;


   public class MSSMetadataOfOwnerType
   {
      public function MSSMetadataOfOwnerType(ownerType: OwnerType) {
         super();
         _ownerType = Objects.paramNotNull("ownerType", ownerType);
      }

      [Required(elementType="models.player.PlayerMinimal")]
      public var playersWithShips: Array = [];

      [Required(elementType="models.player.PlayerMinimal")]
      public var playersWithPlanets: Array = [];

      private var _ownerType: OwnerType;
      public function get ownerType(): OwnerType {
         return _ownerType;
      }

      public function get hasSomething(): Boolean {
         return hasShips || hasPlanets;
      }

      public function get hasShips(): Boolean {
         return playersWithShips.length > 0;
      }

      public function get hasPlanets(): Boolean {
         return playersWithPlanets.length > 0;
      }

      public function get playersMetadata(): Array {
         var player: PlayerMinimal;
         const allPlayers: Array = [];

         const withShipsMap: Object = new Object();
         for each (player in playersWithShips) {
            withShipsMap[player.id] = true;
            allPlayers.push(player);
         }

         const withPlanetsMap: Object = new Object();
         for each (player in playersWithPlanets) {
            withPlanetsMap[player.id] = true;
            if (withShipsMap[player.id] == null) {
               allPlayers.push(player);
            }
         }

         const playersMetadata: Array = [];
         for each (player in allPlayers) {
            playersMetadata.push(new MSSMetadataOfPlayer(
               player, ownerType, withPlanetsMap[player.id], withShipsMap[player.id]
            ));
         }
         return playersMetadata;
      }

      public function get shipIcon(): BitmapData {
         return ownerType.shipIcon;
      }

      public function get planetIcon(): BitmapData {
         return ownerType.planetIcon;
      }

      public function toString(): String {
         return new ObjectStringBuilder(this)
            .addProp("ownerType")
            .addProp("playersWithPlanets")
            .addProp("playersWithShips").finish();
      }
   }
}
