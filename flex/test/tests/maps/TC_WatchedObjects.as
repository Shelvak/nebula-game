package tests.maps
{
   import components.map.controllers.GalaxySectorsProvider;
   import components.map.controllers.Sector;
   import components.map.controllers.SectorShips;
   import components.map.controllers.WatchedObjects;

   import ext.hamcrest.events.causes;
   import ext.hamcrest.object.equals;

   import models.ModelLocator;
   import models.Owner;
   import models.galaxy.Galaxy;
   import models.location.LocationMinimal;
   import models.map.events.MMapEvent;
   import models.movement.MHop;
   import models.movement.MSquadron;
   import models.solarsystem.MSSMetadata;
   import models.solarsystem.MSolarSystem;

   import mx.collections.ArrayCollection;

   import org.hamcrest.assertThat;
   import org.hamcrest.collection.arrayWithSize;
   import org.hamcrest.collection.emptyArray;
   import org.hamcrest.collection.hasItem;
   import org.hamcrest.core.allOf;
   import org.hamcrest.core.not;
   import org.hamcrest.object.isFalse;
   import org.hamcrest.object.nullValue;

   import testsutils.location.getGalaxyLocation;


   public class TC_WatchedObjects
   {
      private static const GALAXY_ID:int = 1;

      private var galaxy:Galaxy;
      private var sectorsProvider:GalaxySectorsProvider;
      private var watchedObjects:WatchedObjects;

      private function get ML(): ModelLocator {
         return ModelLocator.getInstance();
      }

      [Before]
      public function setUp(): void {
         galaxy = new Galaxy();
         galaxy.id = GALAXY_ID;
         ML.latestGalaxy = galaxy;
         ML.player.galaxyId = GALAXY_ID;
         sectorsProvider = new GalaxySectorsProvider(galaxy);
         watchedObjects = new WatchedObjects(galaxy, sectorsProvider);
      }

      [After]
      public function tearDown(): void {
         if (watchedObjects != null) {
            watchedObjects.cleanup();
            watchedObjects = null;
         }
         if (sectorsProvider != null) {
            sectorsProvider = null;
         }
         if (galaxy != null) {
            galaxy.cleanup();
            galaxy = null;
         }
      }

      [Test]
      public function sectorsCompareFunction(): void {
         const sectorPlayerShips:SectorShips = new SectorShips(true);
         function assertNotEquals(message_a_less_b: String,
                                  message_b_greater_a: String,
                                  a: Sector, b:Sector): void {
            assertThat(
               message_a_less_b, watchedObjects.sectorsCompareFunction(a, b),
               equals (-1)
            );
            assertThat(
               message_b_greater_a, watchedObjects.sectorsCompareFunction(b, a),
               equals (+1)
            );
         }
         assertNotEquals(
            "sector with objects comes before sector with ships "
               + "no matter what location it defines",
            "sector with ships comes after sector with objects"
               + "no matter what location it defines",
            getSector(1, 1, getSolarSystem(1, 0, 0, false)),
            getSector(0, 0, null, sectorPlayerShips)
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
            getSector(0, 0, getSolarSystem(1, 0, 0, true)),
            getSector(0, 1, getSolarSystem(2, 0, 1, true))
         );
      }

      [Test]
      public function itemSelected(): void {
         const galaxy:Galaxy = new Galaxy();
         galaxy.addObject(getSolarSystem(1, 0, 0, true));
         const location:LocationMinimal = galaxy.getLocation(0, 0);
         const objects:WatchedObjects = new WatchedObjects(
            galaxy, new GalaxySectorsProvider(galaxy)
         );

         assertThat(
            "map moved to the selected sector location",
            function(): void {
               objects.itemSelected(new Sector(location, new SectorShips(true)));
            },
            allOf (
               not (causes(galaxy) .toDispatchEvent (MMapEvent.UICMD_SELECT_LOCATION)),
               causes(galaxy) .toDispatchEvent (MMapEvent.UICMD_DESELECT_SELECTED_LOCATION),
               causes(galaxy) .toDispatchEvent (
                  MMapEvent.UICMD_MOVE_TO_LOCATION,
                  function(event: MMapEvent): void {
                     assertThat(
                        "map moved to correct location",
                        event.object, equals (location)
                     );
                     assertThat(
                        "event.instant", event.instant, isFalse()
                     );
                     assertThat(
                        "event.operationCompleteHandler",
                        event.operationCompleteHandler, nullValue()
                     );
                  }
               )
            )
         );

         const solarSystem:MSolarSystem = getSolarSystem(1, 0, 0, true);
         assertThat(
            "sector with object is selected",
            function(): void {
               objects.itemSelected(new Sector(location, null, solarSystem));
            },
            allOf(
               not (causes(galaxy) .toDispatchEvent (MMapEvent.UICMD_MOVE_TO_LOCATION)),
               causes(galaxy) .toDispatchEvent (MMapEvent.UICMD_DESELECT_SELECTED_LOCATION),
               causes(galaxy) .toDispatchEvent(
                  MMapEvent.UICMD_SELECT_LOCATION,
                  function(event: MMapEvent): void {
                     assertThat(
                        "event.object holds selected object instance",
                        event.object, equals (solarSystem)
                     );
                     assertThat(
                        "event.instant", event.instant, isFalse()
                     );
                     assertThat(
                        "event.operationCompleteHandler",
                        event.operationCompleteHandler, nullValue()
                     );
                  }
               )
            )
         );
      }

      [Test]
      public function isRefreshedWhenObjectIsAddedToOrRemovedFromAMap(): void {
         galaxy.addObject(getSolarSystem(1, 0, 0, true));
         assertThat( "# of items increased", watchedObjects, arrayWithSize (1) );
         galaxy.removeObject(galaxy.getSSAt(0, 0));
         assertThat( "# of items decreased", watchedObjects, emptyArray() );
      }

      [Test]
      public function isRefreshedWhenSquadEntersOrLeavesAMap(): void {
         ML.squadrons.addItem(getSquadron(1, 0, 0));
         assertThat( "# of items increased", watchedObjects, arrayWithSize (1) );
         ML.squadrons.remove(1);
         assertThat( "# of items decreased", watchedObjects, emptyArray() );
      }

      [Test]
      public function isRefreshedWhenSquadMovesInsideAMap(): void {
         const sectorShips:SectorShips = new SectorShips(true);
         ML.squadrons.addItem(getSquadron(1, 0, 0, [
            getHop(0, 0, 1, new Date(2000, 0, 5)),
            getHop(1, 0, 2, new Date(2000, 0, 6))
         ]));
         assertThat( watchedObjects, arrayWithSize(1) );
         assertThat(
            watchedObjects,
            hasItem (equals (getSector(0, 0, null, sectorShips)))
         );

         MSquadron(ML.squadrons.find(1)).moveToLastHop();
         assertThat( "# of items", watchedObjects, arrayWithSize (1) );
         assertThat(
            "old sector removed", watchedObjects,
            not (hasItem (equals (getSector(0, 0, null, sectorShips))))
         );
         assertThat(
            "sector squad has moved to is now in the list", watchedObjects,
            hasItem (equals (getSector(0, 2, null, sectorShips)))
         );
      }


      /* ############### */
      /* ### HELPERS ### */
      /* ############### */
      
      private function getSolarSystem(id: int, x: int, y: int,
                                      playerShips: Boolean): MSolarSystem {
         var ss: MSolarSystem = new MSolarSystem();
         ss.id = id;
         ss.x = x;
         ss.y = y;
         ss.metadata = new MSSMetadata();
         ss.metadata.playerShips = playerShips;
         return ss;
      }

      private function getSquadron(id: int, x: int, y: int,
                                   hops: Array = null): MSquadron {
         var squad: MSquadron = new MSquadron();
         squad.id = id;
         squad.owner = Owner.PLAYER;
         squad.currentHop = new MHop();
         squad.currentHop.location = galaxy.getLocation(x, y);
         squad.addAllHops(new ArrayCollection(hops));
         return squad;
      }

      private function getSector(x: int,
                                 y: int,
                                 solarSystem: MSolarSystem = null,
                                 ships: SectorShips = null): Sector {
         return new Sector(
            getGalaxyLocation(GALAXY_ID, x, y),
            ships,
            solarSystem
         );
      }

      private function getHop(index: int, x: int, y: int,
                              arrivesAt: Date): MHop {
         var hop: MHop = new MHop();
         hop.index = index;
         hop.arrivalEvent.occuresAt = arrivesAt;
         hop.location = getGalaxyLocation(GALAXY_ID, x, y);
         return hop;
      }
   }
}
