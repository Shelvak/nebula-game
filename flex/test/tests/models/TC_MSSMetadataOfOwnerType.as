package tests.models
{
   import ext.hamcrest.collection.hasItems;
   import ext.hamcrest.object.equals;

   import models.ModelLocator;
   import models.OwnerType;
   import models.player.PlayerMinimal;
   import models.solarsystem.MSSMetadataOfOwnerType;
   import models.solarsystem.MSSMetadataOfPlayer;

   import org.hamcrest.assertThat;
   import org.hamcrest.collection.arrayWithSize;
   import org.hamcrest.core.allOf;
   import org.hamcrest.object.isFalse;
   import org.hamcrest.object.isTrue;

   import utils.SingletonFactory;


   public class TC_MSSMetadataOfOwnerType
   {
      private var model: MSSMetadataOfOwnerType;
      private var ML: ModelLocator;

      [Before]
      public function setUp(): void {
         ML = ModelLocator.getInstance();
         ML.player.id = 1;
         ML.player.name = "Test1";
      }

      [After]
      public function tearDown(): void {
         SingletonFactory.clearAllSingletonInstances();
      }

      [Test]
      public function hasPlanetsShipsSomething(): void {
         model = new MSSMetadataOfOwnerType(OwnerType.PLAYER);
         assertThat(
            "should not have planets if playersWithPlanets is empty",
            model.hasPlanets, isFalse());
         assertThat(
            "should not have ships if playersWithShips is empty",
            model.hasShips, isFalse());
         assertThat(
            "should not have anything if playersWithShips and playersWithPlanets is empty",
            model.hasSomething, isFalse());

         model.playersWithPlanets = [ML.player];
         model.playersWithShips = [];
         assertThat(
            "should have something if playersWithPlanets is not empty but playersWithShips is",
            model.hasSomething, isTrue());

         model.playersWithPlanets = [];
         model.playersWithShips = [ML.player];
         assertThat(
            "should have something if playersWithPlanets is empty but playersWithShips is not",
            model.hasSomething, isTrue());

         model.playersWithPlanets = [ML.player];
         model.playersWithShips = [ML.player];
         assertThat(
            "should have planets if playersWithPlanets is not empty",
            model.hasPlanets, isTrue());
         assertThat(
            "should have ships if playersWithShips is not empty",
            model.hasShips, isTrue());
         assertThat(
            "should have something if playersWithPlanets and playersWithShips is not empty",
            model.hasSomething, isTrue());
      }

      [Test]
      public function playersMetadata(): void {

         function $player(playerId: int): PlayerMinimal {
            return new PlayerMinimal(playerId, "Test" + playerId);
         }

         function $metadata(playerId: int, hasPlanets: Boolean, hasShips: Boolean): MSSMetadataOfPlayer {
            return new MSSMetadataOfPlayer(
               $player(playerId), OwnerType.ENEMY, hasPlanets, hasShips
            );
         }

         model = new MSSMetadataOfOwnerType(OwnerType.ENEMY);
         model.playersWithPlanets = [$player(1), $player(2)];
         model.playersWithShips = [$player(1), $player(3)];

         assertThat(
            "3 players should have military assets in the solar system",
            model.playersMetadata, allOf(
               arrayWithSize(3),
               hasItems(
                  equals ($metadata(1, true, true)),
                  equals ($metadata(2, true, false)),
                  equals ($metadata(3, false, true)))));
      }
   }
}
