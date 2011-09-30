package controllers.objects.actions.customcontrollers
{
   import models.BaseModel;
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
         throw new Error("Unable to find solar system with id " + 
            ssMetadata.id + " to update its metadata!");
         var metadata:SSMetadata = ss.metadata;
         metadata.copyProperties(ssMetadata);
         ML.latestGalaxy.refreshSolarSystemsWithPlayer();
      }
      
      public override function objectDestroyed(objectSubclass:String, objectId:int, reason:String) : void {
         var ssMetadata:SSMetadata = ML.latestGalaxy.getSSById(objectId).metadata;
         ssMetadata.reset();
      }
   }
}
