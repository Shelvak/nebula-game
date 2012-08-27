package tests.models
{
   import ext.hamcrest.object.equals;
   import ext.hamcrest.object.notEquals;

   import models.OwnerType;

   import models.player.PlayerMinimal;
   import models.solarsystem.MSSMetadataOfPlayer;

   import org.hamcrest.assertThat;


   public class TC_MSSMetadataOfPlayer
   {
      [Test]
      public function equalsTest(): void {
         function $metadata(
            playerId: int,
            ownerType: OwnerType,
            hasPlanets: Boolean,
            hasShips: Boolean) : MSSMetadataOfPlayer
         {
            return new MSSMetadataOfPlayer(
               new PlayerMinimal(playerId, "Test" + playerId), ownerType, hasPlanets, hasShips
            );
         }

         const reference: MSSMetadataOfPlayer = $metadata(1, OwnerType.PLAYER, true, true);
         assertThat(
            "should not be equal if compared with another type",
            reference, notEquals (new Object()));
         assertThat(
            "should not be equal if player is not equal",
            reference, notEquals ($metadata(2, OwnerType.PLAYER, true, true)));
         assertThat(
            "should not be equal if owner type is not equal",
            reference, notEquals ($metadata(1, OwnerType.ENEMY, true, true)));
         assertThat(
            "should not be equal if hasPlanets is not the same",
            reference, notEquals ($metadata(1, OwnerType.PLAYER, false, true)));
         assertThat(
            "should not be equal if hasShips is not the same",
            reference, notEquals ($metadata(1, OwnerType.PLAYER, true, false)));
         assertThat(
            "should be equal if everything is the same",
            reference, equals ($metadata(1, OwnerType.PLAYER, true, true)));
      }

      [Test]
      public function toStringTest(): void {
         const meta: MSSMetadataOfPlayer =
            new MSSMetadataOfPlayer(new PlayerMinimal(1, "Test"), OwnerType.PLAYER, true, true);
         assertThat( meta.toString(), equals (
            '[class: models.solarsystem::MSSMetadataOfPlayer, ' +
            'player: [class: models.player::PlayerMinimal, id: 1, name: "Test"], ' +
            'ownerType: [Enum models::OwnerType.PLAYER], ' +
            'hasPlanets: true, ' +
            'hasShips: true]'));
      }
   }
}
