/**
 * Created by IntelliJ IDEA.
 * User: MikisM
 * Date: 11.12.6
 * Time: 13.08
 * To change this template use File | Settings | File Templates.
 */
package tests.maps
{
   import components.map.controllers.GalaxySectorsProvider;
   import components.map.controllers.IRGalaxySectorWithSS;
   import components.map.controllers.IRGalaxySectorWithShips;
   import components.map.controllers.Sector;
   import components.map.controllers.SectorShips;

   import ext.hamcrest.collection.hasItems;

   import ext.hamcrest.object.equals;

   import models.ModelLocator;

   import models.Owner;
   import models.galaxy.Galaxy;
   import models.location.LocationMinimal;
   import models.location.LocationType;
   import models.movement.MHop;
   import models.movement.MSquadron;
   import models.solarsystem.MSSMetadata;
   import models.solarsystem.MSolarSystem;

   import mx.collections.ArrayCollection;

   import org.hamcrest.assertThat;
   import org.hamcrest.collection.arrayWithSize;
   import org.hamcrest.object.instanceOf;
   import org.hamcrest.object.isFalse;
   import org.hamcrest.object.isTrue;

   import testsutils.ImageUtl;

   import utils.SingletonFactory;
   import utils.assets.AssetNames;


   public class TC_GalaxySectorsProvider
   {
      private static const GALAXY_ID:int = 1;

      private var galaxy:Galaxy;
      private var sectors:Array;

      [Before]
      public function setUp(): void {
         ModelLocator.getInstance().player.galaxyId = GALAXY_ID;
         ImageUtl.add(AssetNames.SS_SHIELD_IMAGE_NAME);
         ImageUtl.addSSMetadataIcons();
         galaxy = new Galaxy();
         galaxy.id = GALAXY_ID;
      }

      [After]
      public function tearDown(): void {
         galaxy.cleanup();
         galaxy = null;
         ImageUtl.tearDown();
         SingletonFactory.clearAllSingletonInstances();
      }

      [Test]
      public function itemRendererFunction(): void {
         const provider:GalaxySectorsProvider = new GalaxySectorsProvider(galaxy);
         assertThat(
            "IRGalaxySectorWithSS for sectors only with object",
            provider.itemRendererFunction (
               getSector(0, 0, getSolarSystem(1, 0, 0, true, false))
            ).newInstance(), instanceOf (IRGalaxySectorWithSS)
         );
         assertThat(
            "IRGalaxySectorWithShips for sectors with ships",
            provider.itemRendererFunction(
               getSector(0, 0, null, new SectorShips(true))
            ).newInstance(), instanceOf (IRGalaxySectorWithShips)
         );
      }

      [Test]
      public function includeSectorsWithShipsOf(): void {
         const provider:GalaxySectorsProvider = new GalaxySectorsProvider(galaxy);
         assertThat(
            "include player ships",
            provider.includeSectorsWithShipsOf(Owner.PLAYER), isTrue()
         );
         for each (var owner: int in [Owner.ALLY, Owner.ENEMY, Owner.NAP,
                                      Owner.NPC]) {
            assertThat(
               "exclude non-player ships",
               provider.includeSectorsWithShipsOf(owner), isFalse()
            );
         }
      }

      [Test]
      public function containsOnlySolarSystemsWithPlayer(): void {
         galaxy.addAllObjects(new ArrayCollection([
            getSolarSystem(1, 0, 0, false, false),
            getSolarSystem(2, 0, 1, false, true),
            getSolarSystem(3, 0, 2, true, false),
            getSolarSystem(4, 0, 3, true, true)
         ]));
         sectors = new GalaxySectorsProvider(galaxy).getSpaceSectors();
         assertThat( "# of items", sectors, arrayWithSize (2) );
         assertThat( "sectors", sectors, hasItems(
            equals (getSector(0, 2, galaxy.getSSAt(0, 2), null)),
            equals (getSector(0, 3, galaxy.getSSAt(0, 3), null))
         ));
      }

      [Test]
      public function containsOnlyLocationsWithPlayerShips(): void {
         galaxy.squadrons.addAll(new ArrayCollection([
            getPlayerSquadron(1, 0, 0),
            getPlayerSquadron(2, 0, 0),
            getPlayerSquadron(3, 0, 1),
            getEnemySquadron(4, 0, 4)
         ]));
         sectors = new GalaxySectorsProvider(galaxy).getSpaceSectors();
         assertThat( "# of items", sectors, arrayWithSize (2) );
         assertThat( "locations with ships", sectors, hasItems(
            equals (getSector(0, 0, null, new SectorShips(true))),
            equals (getSector(0, 1, null, new SectorShips(true)))
         ));
      }

      [Test]
      public function separateEntriesForSolarSystemsAndShipsAtTheSameLocation(): void {
         galaxy.addAllObjects(new ArrayCollection([
            getSolarSystem(1, 0, 0, true, false)
         ]));
         galaxy.squadrons.addAll(new ArrayCollection([
            getPlayerSquadron(1, 0, 0)
         ]));
         sectors = new GalaxySectorsProvider(galaxy).getSpaceSectors();
         assertThat( "# of items", sectors, arrayWithSize (2) );
         assertThat( "sectors with ship and solar system", sectors, hasItems(
            equals (getSector(0, 0, galaxy.getSSAt(0, 0))),
            equals (getSector(0, 0, galaxy.getSSAt(0, 0), new SectorShips(true)))
         ));
      }

      [Test]
      public function sectorsCompareFunction(): void {
         const sectorPlayerShips:SectorShips = new SectorShips(true);
         function assertNotEquals(message_a_less_b: String,
                                  message_b_greater_a: String,
                                  a: Sector, b:Sector): void {
            assertThat(
               message_a_less_b,
               new GalaxySectorsProvider(galaxy).sectorsCompareFunction(a, b),
               equals (-1)
            );
            assertThat(
               message_b_greater_a,
               new GalaxySectorsProvider(galaxy).sectorsCompareFunction(b, a),
               equals (+1)
            );
         }
         assertNotEquals(
            "sector with objects comes before sector with ships "
               + "no matter what location it defines",
            "sector with ships comes after sector with objects"
               + "no matter what location it defines",
            getSector(1, 1, getSolarSystem(1, 1, 1, true, false)),
            getSector(0, 0, null, sectorPlayerShips)
         );
         assertNotEquals(
            "sector with object only comes before sector with object and ships "
               + "no matter what location they define",
            "sector with objects and ships comes after sector with object only "
               + "no matter what location they define",
            getSector(1, 1, getSolarSystem(1, 1, 1, true, false)),
            getSector(0, 0, getSolarSystem(1, 0, 0, true, false), sectorPlayerShips)
         );
         assertNotEquals(
            "sector on the left comes before sector on the right",
            "sector on the right comes after sector on the left",
            getSector(0, 1, null, sectorPlayerShips),
            getSector(1, 0, null, sectorPlayerShips)
         );
         assertNotEquals(
            "sector at the bottom comes before sector at the top "
               + "when x coordinate is the same",
            "sector at the top comes after sector at the bottom "
               + "when x coordinate is the same",
            getSector(0, 0, getSolarSystem(1, 0, 0, true, false)),
            getSector(0, 1, getSolarSystem(2, 0, 1, true, false))
         );
      }


      /* ############### */
      /* ### HELPERS ### */
      /* ############### */

      private function getSolarSystem(id: int, x: int, y: int,
                                      playerShips: Boolean,
                                      enemyShips: Boolean): MSolarSystem {
         var ss: MSolarSystem = new MSolarSystem();
         ss.id = id;
         ss.x = x;
         ss.y = y;
         ss.metadata = new MSSMetadata();
         ss.metadata.playerShips = playerShips;
         ss.metadata.enemyShips = enemyShips;
         return ss;
      }

      private function getPlayerSquadron(id: int, x: int, y: int): MSquadron {
         return getSquadron(id, x, y, Owner.PLAYER);
      }

      private function getEnemySquadron(id: int, x: int, y: int): MSquadron {
         return getSquadron(id, x, y, Owner.ENEMY);
      }

      private function getSquadron(id: int, x: int, y: int, owner: int): MSquadron {
         var squad: MSquadron = new MSquadron();
         squad.id = id;
         squad.owner = owner;
         squad.currentHop = new MHop();
         squad.currentHop.location = getGalaxyLocation(x, y);
         return squad;
      }

      private function getSector(x: int,
                                 y: int,
                                 solarSystem: MSolarSystem = null,
                                 ships:SectorShips = null): Sector {
         return new Sector(
            getGalaxyLocation(x, y),
            ships,
            solarSystem
         );
      }

      private function getGalaxyLocation(x: int, y: int): LocationMinimal {
         var loc: LocationMinimal = new LocationMinimal();
         loc.type = LocationType.GALAXY;
         loc.id = GALAXY_ID;
         loc.x = x;
         loc.y = y;
         return loc;
      }
   }
}
