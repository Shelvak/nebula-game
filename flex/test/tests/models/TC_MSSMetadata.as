package tests.models
{
   import ext.hamcrest.collection.array;
   import ext.hamcrest.object.definesProperties;
   import ext.hamcrest.object.definesProperty;
   import ext.hamcrest.object.metadata.withAttribute;
   import ext.hamcrest.object.metadata.withMetadataTag;

   import models.ModelLocator;

   import models.solarsystem.MSSMetadata;
   import models.solarsystem.MSSMetadataOfOwner;

   import org.hamcrest.assertThat;
   import org.hamcrest.collection.emptyArray;
   import org.hamcrest.object.isFalse;
   import org.hamcrest.object.isTrue;


   public class TC_MSSMetadata
   {
      private var model: MSSMetadata;
      private var ML: ModelLocator;

      [Before]
      public function setUp(): void {
         ML = ModelLocator.getInstance();
         model = new MSSMetadata();
      }

      [Test]
      public function metadata(): void {
         assertThat(
            MSSMetadata, definesProperties({
               "playerShips": withMetadataTag("Required"),
               "playerPlanets": withMetadataTag("Required")
            })
         );
         for each (var prop:String in ["alliesWithPlanets", "alliesWithShips",
                                       "enemiesWithPlanets", "enemiesWithShips",
                                       "napsWithPlanets", "napsWithShips"]) {
            assertThat(
               MSSMetadata, definesProperty(
                  prop, withMetadataTag("Required",
                  withAttribute("elementType", "models.player.PlayerMinimal")))
            );
         }
      }

      [Test]
      public function playerMetadata(): void {
         model.playerPlanets = false;
         assertThat("planets", model.playerMetadata.planets, emptyArray());
         assertThat(
            "should not have planets if playerPlanets is false",
            model.playerMetadata.hasPlanets, isFalse()
         );
         model.playerPlanets = true;
         assertThat("planets", model.playerMetadata.planets, array (ML.player));
         assertThat(
            "should have planets if playerPlanets is true",
            model.playerMetadata.hasPlanets, isTrue()
         );

         model.playerShips = false;
         assertThat("ships", model.playerMetadata.ships, emptyArray());
         assertThat(
            "should not have ships if playerShips is false",
            model.playerMetadata.hasPlanets, isTrue()
         );
         model.playerShips = true;
         assertThat("ships", model.playerMetadata.ships, array (ML.player));
         assertThat(
            "should have ships if playerShips is true",
            model.playerMetadata.hasPlanets, isTrue()
         );
      }

      [Test]
      public function hasPlanetsAndShipsProperties(): void {
         testOwnerMetadata("allies");
         testOwnerMetadata("naps");
         testOwnerMetadata("enemies");
      }

      private function testOwnerMetadata(propPrefix: String): void {
         const planetsListName: String = propPrefix + "WithPlanets";
         const shipsListName: String = propPrefix + "WithShips";
         const metadataName: String = propPrefix + "Metadata";

         function ownerMeta(): MSSMetadataOfOwner {
            return model[metadataName];
         }

         model[planetsListName] = [];
         assertThat(
            planetsListName + ": should not have planets if there are no "
               + propPrefix + " players in the list",
            ownerMeta().hasPlanets, isFalse());
         model[shipsListName] = [];
         assertThat(
            shipsListName + ": should not have ships if there are no "
               + propPrefix + " players in the list",
            ownerMeta().hasShips, isFalse());

         model[planetsListName] = ["test"];
         assertThat(
            planetsListName + ": should have planets if there are any "
               + propPrefix + " players in the list",
            ownerMeta().hasPlanets, isTrue());
         model[shipsListName] = ["test"];
         assertThat(
            shipsListName + ": should have ships if there are any "
               + propPrefix + " players in the list",
            ownerMeta().hasShips, isTrue());
      }
   }
}
