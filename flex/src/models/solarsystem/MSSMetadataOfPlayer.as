package models.solarsystem
{
   import flash.display.BitmapData;

   import interfaces.IEqualsComparable;

   import models.OwnerType;

   import models.player.PlayerMinimal;

   import utils.ObjectStringBuilder;
   import utils.Objects;
   import utils.locale.Localizer;


   public class MSSMetadataOfPlayer implements IEqualsComparable
   {
      public function MSSMetadataOfPlayer(
         player: PlayerMinimal,
         ownerType: OwnerType,
         hasPlanets: Boolean,
         hasShips: Boolean)
      {
         super();
         _player = Objects.paramNotNull("player", player);
         _ownerType = Objects.paramNotNull("ownerType", ownerType);
         _hasPlanets = hasPlanets;
         _hasShips = hasShips;
      }

      private var _player: PlayerMinimal;
      public function get player(): PlayerMinimal {
         return _player;
      }

      private var _hasPlanets: Boolean;
      public function get hasPlanets(): Boolean {
         return _hasPlanets;
      }

      private var _hasShips: Boolean;
      public function get hasShips(): Boolean {
         return _hasShips;
      }

      private var _ownerType: OwnerType;
      public function get ownerType(): OwnerType {
         return _ownerType;
      }

      public function get planetIcon(): BitmapData {
         return _ownerType.planetIcon;
      }

      public function get shipIcon(): BitmapData {
         return _ownerType.shipIcon;
      }

      public function get planetIconTooltip(): String {
         return getTooltip("Planets");
      }

      public function get shipIconTooltip(): String {
         return getTooltip("Ships");
      }

      private function getTooltip(assetType: String): String {
         return Localizer.string("Galaxy", "label." + ownerType.name.toLowerCase() + assetType);
      }

      public function toString(): String {
         return new ObjectStringBuilder(this)
            .addProp("player")
            .addProp("ownerType")
            .addProp("hasPlanets")
            .addProp("hasShips").finish();
      }

      public function equals(o: Object): Boolean {
         const another: MSSMetadataOfPlayer = o as MSSMetadataOfPlayer;
         return another != null
            && another.player.equals(this.player)
            && another.ownerType.equals(this.ownerType)
            && another.hasPlanets == this.hasPlanets
            && another.hasShips == this.hasShips;
      }
   }
}
