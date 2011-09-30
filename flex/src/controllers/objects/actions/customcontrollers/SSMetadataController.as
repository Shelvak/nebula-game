package controllers.objects.actions.customcontrollers
{
   import controllers.ui.NavigationController;
   
   import models.BaseModel;
   import models.map.MapType;
   import models.solarsystem.SSMetadata;
   import models.solarsystem.SolarSystem;
   
   
   public class SSMetadataController extends BaseObjectController
   {
      public function SSMetadataController() {
         super();
      }
      
      
      public override function objectUpdated(objectSubclass:String, object:Object, reason:String) : void {
         var ssMetadata:SSMetadata = BaseModel.createModel(SSMetadata, object);
         var ss:SolarSystem = ML.latestGalaxy.getSSById(ssMetadata.id);
         if (ss == null) {
            throw new Error("Unable to find solar system with id " + 
               ssMetadata.id + " to update its metadata!");
         }
         var metadata:SSMetadata = ss.metadata;
         metadata.copyProperties(ssMetadata);
         ML.latestGalaxy.refreshSolarSystemsWithPlayer();
      }
      
      public override function objectDestroyed(objectSubclass:String, objectId:int, reason:String) : void {
         var navCtrl:NavigationController = NavigationController.getInstance();
         var ss:SolarSystem = ML.latestGalaxy.getSSById(objectId);
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
