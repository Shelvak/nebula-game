package controllers.objects.actions.customcontrollers
{
   import controllers.ui.NavigationController;
   
   import models.BaseModel;
   import models.map.MapType;
   import models.solarsystem.MSSMetadata;
   import models.solarsystem.MSolarSystem;
   
   
   public class SSMetadataController extends BaseObjectController
   {
      public function SSMetadataController() {
         super();
      }
      
      
      public override function objectUpdated(objectSubclass:String, object:Object, reason:String) : void {
         var ssMetadata:MSSMetadata = BaseModel.createModel(MSSMetadata, object);
         var ss:MSolarSystem = ML.latestGalaxy.getSSById(ssMetadata.id);
         if (ss == null) {
            throw new Error("Unable to find solar system with id " + 
               ssMetadata.id + " to update its metadata!");
         }
         var metadata:MSSMetadata = ss.metadata;
         metadata.copyProperties(ssMetadata);
         ML.latestGalaxy.refreshSolarSystemsWithPlayer();
      }
      
      public override function objectDestroyed(objectSubclass:String, objectId:int, reason:String) : void {
         var navCtrl:NavigationController = NavigationController.getInstance();
         var ss:MSolarSystem = ML.latestGalaxy.getSSById(objectId);
         ML.latestGalaxy.removeObject(ss);
         if (ML.activeMapType != MapType.GALAXY) {
            navCtrl.toGalaxy();
         }
         if (ML.latestPlanet != null && ML.latestPlanet.solarSystemId == ss.id) {
            ML.latestPlanet = null;
         }
         if (ML.latestSolarSystem != null && ML.latestSolarSystem.id == ss.id) {
            ML.latestSolarSystem = null;
         }
      }
   }
}
