package tests.maps
{
   import components.map.controllers.IRSolarSystemSector;
   import components.map.controllers.Sector;
   import components.map.controllers.SectorShips;
   import components.map.controllers.SolarSystemSectorsProvider;

   import ext.hamcrest.collection.hasItems;
   import ext.hamcrest.object.equals;

   import models.Owner;
   import models.map.MMapSolarSystem;
   import models.movement.MHop;
   import models.movement.MSquadron;
   import models.solarsystem.MSSObject;
   import models.solarsystem.MSolarSystem;
   import models.solarsystem.SSObjectType;

   import mx.collections.ArrayCollection;

   import org.hamcrest.assertThat;
   import org.hamcrest.collection.arrayWithSize;
   import org.hamcrest.object.instanceOf;
   import org.hamcrest.object.isTrue;

   import testsutils.ImageUtl;

   import testsutils.location.getSolarSystemLocation;

   import utils.SingletonFactory;
   import utils.assets.AssetNames;


   public class TC_SolarSystemSectorsProvider
   {
      private static const SS_ID:int = 1;

      private var sectors:Array;
      private var ssMap:MMapSolarSystem;

      [Before]
      public function setUp(): void {
         SingletonFactory.clearAllSingletonInstances();
         ImageUtl.add(AssetNames.MOVEMENT_IMAGES_FOLDER + "sector_with_ships");
         ImageUtl.addSSMetadataIcons();
         ssMap = new MMapSolarSystem(new MSolarSystem());
         ssMap.id = SS_ID;
      }

      [After]
      public function tearDown(): void {
         if (ssMap != null) {
            ssMap.cleanup();
            ssMap = null;
         }
         sectors = null;
         ImageUtl.tearDown();
         SingletonFactory.clearAllSingletonInstances();
      }

      [Test]
      public function itemRendererFunction(): void {
         const provider: SolarSystemSectorsProvider = getProvider(ssMap);
         assertThat(
            "IRSolarSystemSector for all sorts of sectors",
            provider.itemRendererFunction(getSector(0, 0, getPlanet(1, 0, 0)))
               .newInstance(), instanceOf (IRSolarSystemSector)
         );
      }

      [Test]
      public function includeSectorsWithShipsOf(): void {
         const provider: SolarSystemSectorsProvider = getProvider(ssMap);
         for each (var owner: int in Owner.VALID_OWNER_TYPES) {
            assertThat(
               "includes ships of any owner",
               provider.includeSectorsWithShipsOf(owner), isTrue()
            );
         }
      }

      [Test]
      public function containsOnlySectorsWithPlanetsAndJumpgates(): void {
         ssMap.addAllObjects(new ArrayCollection([
            getJumpgate(1, 0, 0),
            getPlanet(2, 1, 0),
            getAsteroid(3, 2, 0)
         ]));
         sectors = getProvider(ssMap).getSpaceSectors();
         assertThat( "# of sectors", sectors, arrayWithSize (2) );
         assertThat( "sectors with planet and jumpgate", sectors, hasItems(
            equals (getSector(0, 0, ssMap.getSSObjectById(1))),
            equals (getSector(1, 0, ssMap.getSSObjectById(2)))
         ));
      }

      [Test]
      public function containsOnlySectorsWithShipsOfAnyOwner(): void {
         ssMap.squadrons.addAll(new ArrayCollection([
            getSquadron(1, 0, 0, Owner.PLAYER),
            getSquadron(2, 0, 20, Owner.ALLY),
            getSquadron(3, 0, 40, Owner.NAP),
            getSquadron(4, 0, 60, Owner.ENEMY),
            getSquadron(5, 0, 80, Owner.NPC)
         ]));
         sectors = getProvider(ssMap).getSpaceSectors();
         assertThat( "# of sectors", sectors, arrayWithSize (5));
         assertThat( "sectors with ships of all possible owners", sectors, hasItems(
            equals (getSector(
               0, 0, null, new SectorShips(true, false, false, false, false)
            )),
            equals (getSector(
               0, 20, null, new SectorShips(false, true, false, false, false)
            )),
            equals (getSector(
               0, 40, null, new SectorShips(false, false, true, false, false)
            )),
            equals (getSector(
               0, 60, null, new SectorShips(false, false, false, true, false)
            )),
            equals (getSector(
               0, 80, null, new SectorShips(false, false, false, false, true)
            ))
         ));
      }

      [Test]
      public function onlyOneSectorForObjectsAndShipsAtTheSameLocation(): void {
         ssMap.addAllObjects(new ArrayCollection([
            getPlanet(1, 0, 0),
            getJumpgate(2, 1, 0)
         ]));
         ssMap.squadrons.addAll(new ArrayCollection([
            getSquadron(1, 0, 0, Owner.PLAYER),
            getSquadron(2, 0, 0, Owner.PLAYER),
            getSquadron(3, 1, 0, Owner.ALLY),
            getSquadron(4, 1, 0, Owner.ENEMY)
         ]));
         sectors = getProvider(ssMap).getSpaceSectors();
         assertThat( "# of sectors", sectors, arrayWithSize (2) );
         assertThat( "sectors of combined ships and objects", sectors, hasItems(
            equals (getSector(
               0, 0, ssMap.getSSObjectAt(0, 0),
               new SectorShips(true)
            )),
            equals (getSector(
               1, 0, ssMap.getSSObjectAt(1, 0),
               new SectorShips(false, true, false, true)
            ))
         ));
      }

      
      /* ############### */
      /* ### HELPERS ### */
      /* ############### */

      private function getSector(position: int,
                                 angle: int,
                                 object: MSSObject = null,
                                 ships:SectorShips = null): Sector {
         return new Sector(
            getSolarSystemLocation(SS_ID, position, angle),
            ships,
            object,
            object != null ? object.owner : Owner.UNDEFINED
         );
      }

      private function getProvider(map:MMapSolarSystem): SolarSystemSectorsProvider {
         return new SolarSystemSectorsProvider(map);
      }

      private function getJumpgate(id:int, position:int, angle:int): MSSObject {
         return getSSObject(SSObjectType.JUMPGATE, id, position, angle);
      }

      private function getPlanet(id:int, position:int, angle:int): MSSObject {
         return getSSObject(SSObjectType.PLANET, id, position, angle);
      }

      private function getAsteroid(id:int, position:int, angle:int): MSSObject {
         return getSSObject(SSObjectType.ASTEROID, id, position, angle);
      }

      private function getSquadron(id: int,
                                   position: int,
                                   angle: int,
                                   owner: int): MSquadron {
         var squad: MSquadron = new MSquadron();
         squad.id = id;
         squad.owner = owner;
         squad.currentHop = new MHop();
         squad.currentHop.location =
            getSolarSystemLocation(SS_ID, position, angle);
         return squad;
      }

      private function getSSObject(type:String,
                                   id:int,
                                   position:int,
                                   angle:int): MSSObject {
         var ssObject:MSSObject = new MSSObject();
         ssObject.type = type;
         ssObject.id = id;
         ssObject.solarSystemId = SS_ID;
         ssObject.position = position;
         ssObject.angle = angle;
         return ssObject;
      }
   }
}
