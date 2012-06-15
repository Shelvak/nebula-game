package controllers.objects.actions.customcontrollers
{
   import controllers.galaxies.GalaxiesCommand;
   import controllers.startup.StartupInfo;
   import controllers.ui.NavigationController;

   import models.map.MapType;
   import models.player.PlayerMinimal;
   import models.solarsystem.MSSMetadata;
   import models.solarsystem.MSolarSystem;

   import utils.Objects;


   public class SSMetadataController extends BaseObjectController
   {
      public function SSMetadataController() {
         super();
      }

      public override function objectUpdated(objectSubclass: String,
                                             object: Object,
                                             reason: String): void {
         if (StartupInfo.relaxedServerMessagesHandlingMode && ML.latestGalaxy == null) {
            return;
         }
         const ss: MSolarSystem = ML.latestGalaxy.getSSById(object.id);
         Objects.notNull(ss, "Solar system with id " + object["id"] + " not found.");
         const metadata: MSSMetadata = ss.metadata;
         Objects.update(metadata, object);
         ML.latestGalaxy.refreshSolarSystemsWithPlayer();
      }
      
      public override function objectDestroyed(objectSubclass: String,
                                               objectId: int,
                                               reason: String): void {
         const navCtrl: NavigationController = NavigationController.getInstance();
         const ss: MSolarSystem = ML.latestGalaxy.getSSById(objectId);
         Objects.notNull(ss, "Solar system with id " + objectId + " not found.");
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

      public override function objectCreated(objectSubclass: String,
                                             object: Object,
                                             reason: String): * {
         const ssMetadata: MSSMetadata = Objects.create(MSSMetadata, object);
         const ss: MSolarSystem = new MSolarSystem();
         ss.id = ssMetadata.id;
         ss.metadata = ssMetadata;
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
