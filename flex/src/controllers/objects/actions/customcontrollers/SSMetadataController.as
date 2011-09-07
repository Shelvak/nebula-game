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
         var metadata:SSMetadata = ss.metadata;
         metadata.copyProperties(ssMetadata);
      }
      
      public override function objectDestroyed(objectSubclass:String, objectId:int, reason:String) : void {
         var ssMetadata:SSMetadata = ML.latestGalaxy.getSSById(objectId).metadata;
         ssMetadata.reset();
      }
   }
}