package controllers.objects.actions.customcontrollers
{
   import controllers.galaxies.GalaxiesCommand;
   import controllers.startup.StartupInfo;
   import controllers.ui.NavigationController;

   import models.galaxy.Galaxy;
   import models.map.MapType;
   import models.player.PlayerMinimal;
   import models.solarsystem.MSSMetadata;
   import models.solarsystem.MSolarSystem;

   import utils.Objects;
   import utils.logging.Log;


   public class SSMetadataController extends BaseObjectController
   {
      public function SSMetadataController() {
         super();
      }

      public override function objectUpdated(
         objectSubclass: String, object: Object, reason: String): void
      {
         function createMetadata(ss: MSolarSystem): void {
            ss.metadata = Objects.create(MSSMetadata, object);
         }

         var galaxy: Galaxy = ML.latestGalaxy;
         if (StartupInfo.relaxedServerMessagesHandlingMode && galaxy == null) {
            return;
         }
         const id: int = object["id"];
         if (galaxy.isBattleground(id)) {
            for each (var wormhole: MSolarSystem in galaxy.wormholes) {
               createMetadata(wormhole);
            }
         }
         else {
            const ss: MSolarSystem = galaxy.getSSById(id);
            Objects.notNull(ss, "Solar system with id " + id + " not found.");
            createMetadata(ss);
            galaxy.refreshSolarSystemsWithPlayer();
         }
      }
      
      public override function objectDestroyed(
         objectSubclass: String, objectId: int, reason: String): void
      {
         const navCtrl: NavigationController = NavigationController.getInstance();
         const ss: MSolarSystem = ML.latestGalaxy.getSSById(objectId);
         if (ss == null) {
            Log.getMethodLogger(this, "objectDestroyed")
               .warn("Unable to find solar system {0}. Ignoring.", objectId);
            return;
         }
         ML.latestGalaxy.removeObject(ss);
         if (ML.latestPlanet != null && ML.latestPlanet.solarSystemId == ss.id) {
            if (ML.activeMapType == MapType.PLANET) {
               navCtrl.toGalaxy();
            }
            ML.latestPlanet = null;
         }
         if (ML.latestSSMap != null && ML.latestSSMap.id == ss.id) {
            if (ML.activeMapType == MapType.SOLAR_SYSTEM) {
               navCtrl.toGalaxy();
            }
            ML.latestSSMap = null;
         }
      }

      public override function objectCreated(
         objectSubclass: String, object: Object, reason: String): *
      {
         const metadata: MSSMetadata = Objects.create(MSSMetadata, object);
         const ss: MSolarSystem = new MSolarSystem();
         ss.id = metadata.id;
         ss.metadata = metadata;
         ss.x = object["x"];
         ss.y = object["y"];
         ss.kind = object["kind"];
         ss.player = Objects.create(PlayerMinimal, object["player"]);
         if (!ML.latestGalaxy.addSSToVisibleBounds(ss)) {
            new GalaxiesCommand(GalaxiesCommand.SHOW).dispatch();
         }
      }
   }
}
