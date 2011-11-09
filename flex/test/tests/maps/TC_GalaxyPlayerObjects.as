package tests.maps
{
   import components.map.controllers.GalaxyPlayerObjects;
   import components.map.controllers.IRSectorWithShips;
   import components.map.controllers.IRSolarSystem;

   import ext.hamcrest.collection.array;
   import ext.hamcrest.collection.hasItems;
   import ext.hamcrest.object.equals;

   import models.ModelLocator;
   import models.Owner;
   import models.galaxy.Galaxy;
   import models.location.LocationMinimal;
   import models.location.LocationType;
   import models.movement.MHop;
   import models.movement.MSquadron;
   import models.solarsystem.SSMetadata;
   import models.solarsystem.SSMetadataType;
   import models.solarsystem.SolarSystem;

   import mx.collections.ArrayCollection;

   import namespaces.client_internal;

   import org.hamcrest.assertThat;
   import org.hamcrest.collection.arrayWithSize;
   import org.hamcrest.collection.emptyArray;
   import org.hamcrest.collection.hasItem;
   import org.hamcrest.core.isA;
   import org.hamcrest.core.not;

   import utils.SingletonFactory;
   import utils.assets.AssetNames;
   import utils.assets.ImagePreloader;


   public class TC_GalaxyPlayerObjects
   {
      private static const GALAXY_ID:int = 1;

      private function get ML(): ModelLocator {
         return ModelLocator.getInstance();
      }

      private function get IMG(): ImagePreloader {
         return ImagePreloader.getInstance();
      }

      private function addImage(name:String) : void {
         IMG.client_internal::addFrames(name);
      }

      private var objects:GalaxyPlayerObjects;
      private var galaxy:Galaxy;

      [Before]
      public function setUp(): void {
         addImage(AssetNames.SS_SHIELD_IMAGE_NAME);
         addImage(AssetNames.MOVEMENT_IMAGES_FOLDER + "sector_with_ships");
         addSSIconImage(SSMetadataType.PLAYER_SHIPS);
         addSSIconImage(SSMetadataType.PLAYER_PLANETS);
         addSSIconImage(SSMetadataType.ALLIANCE_SHIPS);
         addSSIconImage(SSMetadataType.ALLIANCE_PLANETS);
         addSSIconImage(SSMetadataType.NAP_SHIPS);
         addSSIconImage(SSMetadataType.NAP_PLANETS);
         addSSIconImage(SSMetadataType.ENEMY_SHIPS);
         addSSIconImage(SSMetadataType.ENEMY_PLANETS);
         ML.player.galaxyId = GALAXY_ID;
         galaxy = new Galaxy();
         galaxy.id = GALAXY_ID;
      }

      private function addSSIconImage(ssMetadataType:String): void {
         addImage(AssetNames.getSSStatusIconName(ssMetadataType));
      }

      [After]
      public function tearDown(): void {
         objects = null;
         galaxy = null;
         IMG.client_internal::clearFrames();
         SingletonFactory.clearAllSingletonInstances();
      }

      [Test]
      public function containsOnlySolarSystemsWithPlayer(): void {
         galaxy.addAllObjects(new ArrayCollection([
            getSolarSystem(1, 0, 0, false, false),
            getSolarSystem(2, 0, 1, false, true),
            getSolarSystem(3, 0, 2, true, false),
            getSolarSystem(4, 0, 3, true, true)
         ]));
         objects = new GalaxyPlayerObjects(galaxy);
         assertThat( "# of items", objects, arrayWithSize (2) );
         assertThat( "solar systems", objects, hasItems(
            equals (galaxy.getSSAt(0, 2)),
            equals (galaxy.getSSAt(0, 3))
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
         objects = new GalaxyPlayerObjects(galaxy);
         assertThat( "# of items", objects, arrayWithSize (2) );
         assertThat( "locations with ships", objects, hasItems(
            equals (getGalaxyLocation(0, 0)),
            equals (getGalaxyLocation(0, 1))
         ));
      }

      [Test]
      public function isRefreshedWhenSolarSystemWithPlayerIsAddedOrRemoved(): void {
         objects = new GalaxyPlayerObjects(galaxy);
         
         galaxy.addObject(getSolarSystem(1, 0, 0, true, false));
         assertThat( "# of items", objects, arrayWithSize (1) );
         assertThat(
            "contains added solar system",
            objects, hasItem (equals (galaxy.getSSAt(0, 0)))
         );
         
         galaxy.removeObject(galaxy.getSSAt(0, 0));
         assertThat( "no items contained", objects, emptyArray() );
      }

      [Test]
      public function isRefreshedWhenPlayerSquadEntersOrLeaves(): void {
         objects = new GalaxyPlayerObjects(galaxy);

         ML.squadrons.addItem(getPlayerSquadron(1, 0, 0));
         assertThat( "# of items", objects, arrayWithSize (1) );
         assertThat(
            "contains location with squadron added",
            objects,  hasItem (equals (getGalaxyLocation(0, 0)))
         );

         ML.squadrons.remove(1);
         assertThat( "no items contained", objects, emptyArray() );
      }

      [Test]
      public function doesNotChangeIfNonPlayerSquadEntersOrLeaves(): void {
         objects = new GalaxyPlayerObjects(galaxy);

         ML.squadrons.addItem(getEnemySquadron(1, 0, 0));
         assertThat( "no items contained", objects, emptyArray() );

         ML.squadrons.remove(1);
         assertThat( "no items contained", objects, emptyArray() );
      }

      [Test]
      public function isRefreshedWhenPlayerSquadMoves(): void {
         objects = new GalaxyPlayerObjects(galaxy);
         ML.squadrons.addItem(getPlayerSquadron(1, 0, 0, [
            getHop(0, 0, 1, new Date(2000, 0, 5)),
            getHop(1, 0, 2, new Date(2000, 0, 6))
         ]));
         assertThat( objects, arrayWithSize(1) );
         assertThat( objects, hasItem(equals(getGalaxyLocation(0, 0))) );

         MSquadron(ML.squadrons.find(1)).moveToLastHop();
         assertThat("# of items", objects, arrayWithSize(1));
         assertThat(
            "old location removed",
            objects, not(hasItem(equals(getGalaxyLocation(0, 0))))
         );
         assertThat(
            "location squad has moved to is now in the list",
            objects, hasItem(equals(getGalaxyLocation(0, 2)))
         );
      }

      [Test]
      public function doesNotChangeIfNonPlayerSquadMoves(): void {
         objects = new GalaxyPlayerObjects(galaxy);
         ML.squadrons.addItem(getEnemySquadron(1, 0, 0, [
            getHop(0, 0, 1, new Date(2000, 0, 5)),
            getHop(1, 0, 2, new Date(2000, 0, 6))
         ]));
         assertThat( objects, arrayWithSize(0) );

         MSquadron(ML.squadrons.find(1)).moveToLastHop();
         assertThat( "no items contained", objects, emptyArray() );
      }

      [Test]
      public function sorting_onlySolarSystems() : void {
         galaxy.addAllObjects(new ArrayCollection([
            getSolarSystem(1, 0, 0, true, false),
            getSolarSystem(2, 1, 0, true, false),
            getSolarSystem(3, 1, 1, true, false),
            getSolarSystem(4, 0, 1, true, false)
         ]));
         objects = new GalaxyPlayerObjects(galaxy);
         assertThat(
            "solar systems are sorted by x, then y",
            objects, array(
               equals (galaxy.getSSAt(0, 0)),
               equals (galaxy.getSSAt(0, 1)),
               equals (galaxy.getSSAt(1, 0)),
               equals (galaxy.getSSAt(1, 1))
            )
         );
      }

      [Test]
      public function sorting_onlyLocationsWithShips() : void {
         ML.squadrons.addAll(new ArrayCollection([
            getPlayerSquadron(1, 1, 1),
            getPlayerSquadron(2, 1, 0),
            getPlayerSquadron(3, 0, 1),
            getPlayerSquadron(4, 0, 0)
         ]));
         objects = new GalaxyPlayerObjects(galaxy);
         assertThat(
            "locations with ships are sorted by x, then y",
            objects, array(
               equals (getGalaxyLocation(0, 0)),
               equals (getGalaxyLocation(0, 1)),
               equals (getGalaxyLocation(1, 0)),
               equals (getGalaxyLocation(1, 1))
            )
         );
      }

      [Test]
      public function sorting_mixed() : void {
         galaxy.addAllObjects(new ArrayCollection([
            getSolarSystem(2, 1, 1, true, false),
            getSolarSystem(1, 0, 0, true, false)
         ]));
         ML.squadrons.addAll(new ArrayCollection([
            getPlayerSquadron(1, 1, 0),
            getPlayerSquadron(2, 0, 1)
         ]));
         objects = new GalaxyPlayerObjects(galaxy);
         assertThat(
            "solar systems come before locations",
            objects, array(
               equals (galaxy.getSSAt(0, 0)),
               equals (galaxy.getSSAt(1, 1)),
               equals (getGalaxyLocation(0, 1)),
               equals (getGalaxyLocation(1, 0))
            )
         );
      }

      [Test]
      public function itemRendererFunction() : void {
         assertThat(
            "returns factory of IRSolarSystem for SolarSystem",
            GalaxyPlayerObjects
               .itemRendererFunction(new SolarSystem())
               .newInstance(),
            isA (IRSolarSystem)
         );

         assertThat(
            "returns factory o f IRSectorWithShips for LocationMinimal",
            GalaxyPlayerObjects
               .itemRendererFunction(new LocationMinimal())
               .newInstance(),
            isA (IRSectorWithShips)
         );
      }


      /* ############### */
      /* ### HELPERS ### */
      /* ############### */
      
      private function getSolarSystem(id:int, x:int, y:int,
                                      playerShips:Boolean,
                                      enemyShips:Boolean) : SolarSystem {
         var ss:SolarSystem = new SolarSystem();
         ss.id = id;
         ss.x = x;
         ss.y = y;
         ss.metadata = new SSMetadata();
         ss.metadata.playerShips = playerShips;
         ss.metadata.enemyShips = enemyShips;
         return ss;
      }
      
      private function getPlayerSquadron(id:int, x:int, y:int,
                                         hops:Array = null) : MSquadron {
         return getSquadron(id, x, y, Owner.PLAYER, hops);
      }
      
      private function getEnemySquadron(id:int, x:int, y:int,
                                        hops:Array = null) : MSquadron {
         return getSquadron(id, x, y, Owner.ENEMY, hops);
      }
      
      private function getSquadron(id:int, x:int, y:int, owner:int,
                                   hops:Array) : MSquadron {
         var squad:MSquadron = new MSquadron();
         squad.id = id;
         squad.owner = owner;
         squad.currentHop = new MHop();
         squad.currentHop.location = getGalaxyLocation(x, y);
         squad.addAllHops(new ArrayCollection(hops));
         return squad;
      }
      
      private function getHop(index:int, x:int, y:int, arrivesAt:Date) : MHop {
         var hop:MHop = new MHop();
         hop.index = index;
         hop.arrivesAt = arrivesAt;
         hop.location = getGalaxyLocation(x, y);
         return hop;
      }
      
      private function getGalaxyLocation(x:int, y:int) : LocationMinimal {
         var loc:LocationMinimal = new LocationMinimal();
         loc.type = LocationType.GALAXY;
         loc.id = GALAXY_ID;
         loc.x = x;
         loc.y = y;
         return loc;
      }
   }
}