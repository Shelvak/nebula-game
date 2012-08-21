package tests.models
{
   import ext.hamcrest.object.definesProperties;
   import ext.hamcrest.object.definesProperty;
   import ext.hamcrest.object.equals;
   import ext.hamcrest.object.metadata.withAttribute;
   import ext.hamcrest.object.metadata.withAttributes;
   import ext.hamcrest.object.metadata.withMetadataTag;
   import ext.hamcrest.object.metadata.withMetadataTags;

   import models.ModelLocator;
   import models.OwnerType;
   import models.solarsystem.MSSMetadata;
   import models.solarsystem.MSSMetadataOfPlayer;

   import org.hamcrest.Matcher;
   import org.hamcrest.assertThat;
   import org.hamcrest.collection.arrayWithSize;
   import org.hamcrest.collection.hasItem;
   import org.hamcrest.core.allOf;
   import org.hamcrest.object.isFalse;
   import org.hamcrest.object.notNullValue;


   public class TC_MSSMetadata
   {
      private var model: MSSMetadata;
      private var ML: ModelLocator;

      [Before]
      public function setUp(): void {
         ML = ModelLocator.getInstance();
         ML.player.id = 1;
         ML.player.name = "Test1";
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
         for each (var ownerPrefix: String in ["allies", "naps", "enemies"]) {
            var metadataProp: String = ownerPrefix + "Metadata";
            var sourceWithPlanetsProp: String = ownerPrefix + "WithPlanets";
            var sourceWithShipsProp: String = ownerPrefix + "WithShips";

            var requiredMatcher: Matcher = withAttribute(
               "aggregatesProps", sourceWithPlanetsProp + ", " + sourceWithShipsProp);
            var propsMapMatchers: Object = new Object();
            propsMapMatchers[sourceWithPlanetsProp] = "playersWithPlanets";
            propsMapMatchers[sourceWithShipsProp] = "playersWithShips";

            assertThat(MSSMetadata, definesProperty(metadataProp,
               withMetadataTags({
                  "Required": requiredMatcher,
                  "PropsMap": withAttributes (propsMapMatchers)})
            ));
         }
      }

      [Test]
      public function playerMetadata(): void {

         function $metadata(hasPlanets: Boolean, hasShips: Boolean): MSSMetadataOfPlayer {
            return new MSSMetadataOfPlayer(ML.player, OwnerType.PLAYER, hasPlanets, hasShips);
         }

         model.playerPlanets = false;
         model.playerShips = false;
         assertThat(
            "should have metadata instance if playerPlanets and playerShips are false",
            model.playerMetadata, notNullValue());
         assertThat(
            "metadata instance should not have anything if playerShips and playerPlanets is false",
            model.playerMetadata.hasSomething, isFalse());

         model.playerPlanets = true;
         model.playerShips = false;
         assertThat(
            "should have single metadata entry if playerPlanets is true and playerShips is false",
            model.playerMetadata.playersMetadata, allOf(
               arrayWithSize (1),
               hasItem (equals ($metadata(true, false)))));

         model.playerPlanets = false;
         model.playerShips = true;
         assertThat(
            "should have single metadata entry if playerPlanets is false and playerShips is true",
            model.playerMetadata.playersMetadata, allOf(
               arrayWithSize (1),
               hasItem (equals ($metadata(false, true)))));

         model.playerPlanets = true;
         model.playerShips = true;
         assertThat(
            "should have single metadata entry if playerPlanets and playerShips is true",
            model.playerMetadata.playersMetadata, allOf(
               arrayWithSize (1),
               hasItem (equals ($metadata(true, true)))));
      }
   }
}
