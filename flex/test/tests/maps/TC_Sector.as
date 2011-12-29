package tests.maps
{
   import components.map.controllers.Sector;
   import components.map.controllers.SectorShips;

   import ext.hamcrest.object.equals;

   import models.ModelLocator;
   import models.Owner;
   import models.galaxy.Galaxy;
   import models.location.LocationMinimal;
   import models.location.LocationType;
   import models.map.IMStaticSpaceObject;
   import models.solarsystem.MSolarSystem;

   import namespaces.client_internal;

   import org.hamcrest.assertThat;
   import org.hamcrest.core.not;
   import org.hamcrest.object.isFalse;
   import org.hamcrest.object.isTrue;
   import org.hamcrest.object.nullValue;

   import testsutils.LocalizerUtl;

   import utils.SingletonFactory;
   import utils.assets.AssetNames;
   import utils.assets.ImagePreloader;


   public class TC_Sector
   {
      private var sector:Sector;
      private const galaxyLoc:LocationMinimal =
                       getLocation(LocationType.GALAXY);

      [Before]
      public function setUp(): void {
         ImagePreloader.getInstance().client_internal::
            addFrames(AssetNames.getSSImageName(0));
         ModelLocator.getInstance().latestGalaxy = new Galaxy();
         LocalizerUtl.setUp();
         LocalizerUtl.addBundle("Location", {"sector": "Sector"});
      }

      [After]
      public function tearDown(): void {
         ImagePreloader.getInstance().client_internal::clearFrames();
         LocalizerUtl.tearDown();
         SingletonFactory.clearAllSingletonInstances();
      }

      [Test]
      public function shipsProperty(): void {
         var ships:SectorShips;

         sector = getSector(galaxyLoc);
         ships = new SectorShips();
         assertThat(
            "ships has default value when not provided",
            sector.ships, equals (ships)
         );

         ships = new SectorShips(false, true, true);
         sector = getSector(galaxyLoc, ships);
         assertThat(
            "ships equals to provided object to constructor",
            sector.ships, equals(ships)
         );
      }

      [Test]
      public function locationProperties(): void {
         sector = getSector(galaxyLoc);
         assertThat( "location", sector.location, equals (galaxyLoc) );
         assertThat( "sectorLabel", sector.sectorLabel, equals ("Sector 0:0") );
      }

      [Test]
      public function objectProperties(): void {
         sector = getSector(galaxyLoc);
         assertThat(
            "hasObject when no object",
            sector.hasObject, isFalse()
         );
         assertThat(
            "object when no object",
            sector.object, nullValue()
         );
         assertThat(
            "objectOwner when no object",
            sector.objectOwner, equals (Owner.UNDEFINED)
         );

         const object:IMStaticSpaceObject = getObject();
         sector = getSector(galaxyLoc, null, object, Owner.PLAYER);
         assertThat(
            "hasObject with object",
            sector.hasObject, isTrue()
         );
         assertThat(
            "object with object",
            sector.object, equals (object)
         );
         assertThat(
            "objectOwner with object",
            sector.objectOwner, equals (Owner.PLAYER)
         );
      }

      [Test]
      public function equalsTest(): void {
         assertThat(
            "not equals if locations are not the same",
            getSector(galaxyLoc),
            not (equals (getSector(getLocation(LocationType.SOLAR_SYSTEM))))
         );
         assertThat(
            "not equals if this.object is null and other.object isn't",
            getSector(galaxyLoc),
            not (equals (getSector(getLocation(LocationType.GALAXY), null, getObject())))
         );
         assertThat(
            "not equals if other.object is null and this.object isn't",
            getSector(galaxyLoc, null, getObject()),
            not (equals (getSector(galaxyLoc)))
         );
         assertThat(
            "not equals if objects are not the same",
            getSector(galaxyLoc, null, getObject(1)),
            not (equals (getSector(galaxyLoc, null, getObject(2))))
         );
         assertThat(
            "not equals if ships are not the same",
            getSector(galaxyLoc, new SectorShips(false)),
            not (equals (getSector(galaxyLoc, new SectorShips(true))))
         );
         assertThat(
            "equals if objects are null and locations and ships are the same",
            getSector(getLocation(LocationType.GALAXY)),
            equals (getSector(galaxyLoc))
         );
         assertThat(
            "equals if locations, objects ships are the same",
            getSector(getLocation(LocationType.GALAXY), null, getObject(1)),
            equals (getSector(galaxyLoc, null, getObject(1)))
         );
      }


      /* ############### */
      /* ### HELPERS ### */
      /* ############### */

      private function getSector(loc: LocationMinimal,
                                 ships: SectorShips = null,
                                 object: IMStaticSpaceObject = null,
                                 objectOwner: int = Owner.UNDEFINED): Sector {
         return new Sector(loc, ships, object, objectOwner);
      }

      private function getObject(id: int = 1): IMStaticSpaceObject {
         var ss:MSolarSystem = new MSolarSystem();
         ss.id = id;
         return ss;
      }

      private function getLocation(type: int,
                                   id: int = 1,
                                   x: int = 0,
                                   y: int = 0): LocationMinimal {
         var loc: LocationMinimal = new LocationMinimal();
         loc.type = type;
         loc.id = id;
         loc.x = x;
         loc.y = y;
         return loc;
      }
   }
}
