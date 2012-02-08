package controllers.objects.actions.customcontrollers
{
   import controllers.ui.NavigationController;

   import models.location.LocationMinimal;

   import models.map.MapType;
   import models.player.PlayerMinimal;
   import models.solarsystem.MSSMetadata;
   import models.solarsystem.MSolarSystem;
   import models.solarsystem.SSKind;

   import utils.Objects;
   
   
   public class SSMetadataController extends BaseObjectController
   {
      public function SSMetadataController() {
         super();
      }
      
      public override function objectUpdated(objectSubclass:String,
                                             object:Object,
                                             reason:String) : void {
         var ss:MSolarSystem = ML.latestGalaxy.getSSById(object.id);
         if (ss == null) {
            throw new Error("Unable to find solar system with id " + 
               object.id + " to update its metadata!");
         }
         var metadata:MSSMetadata = ss.metadata;
         Objects.update(metadata, object);
         ML.latestGalaxy.refreshSolarSystemsWithPlayer();
      }
      
      public override function objectDestroyed(objectSubclass:String,
                                               objectId:int,
                                               reason:String) : void {
         var navCtrl:NavigationController = NavigationController.getInstance();
         var ss:MSolarSystem = ML.latestGalaxy.getSSById(objectId);
         ML.latestGalaxy.removeObject(ss);
         if (ML.activeMapType != MapType.GALAXY) {
            navCtrl.toGalaxy();
         }
         if (ML.latestPlanet != null && ML.latestPlanet.solarSystemId == ss.id) {
            ML.latestPlanet = null;
         }
         if (ML.latestSSMap != null && ML.latestSSMap.id == ss.id) {
            ML.latestSSMap = null;
         }
      }

      public override function objectCreated(objectSubclass:String,
                                             object:Object,
                                             reason:String): * {
         var ssMetadata:MSSMetadata = Objects.create(MSSMetadata, object);
         var ss:MSolarSystem = new MSolarSystem();
         ss.id = ssMetadata.id;
         ss.metadata = ssMetadata;
         ss.x = object["x"];
         ss.y = object["y"];
         ss.kind = object["kind"];
         ss.player = Objects.create(PlayerMinimal, object["player"]);
         ML.latestGalaxy.addObject(ss);
      }
   }
}
