package controllers.objects.actions.customcontrollers
{
   import models.solarsystem.SSMetadata;
   
   import utils.Objects;
   
   
   public class SSMetadataController extends BaseObjectController
   {
      public function SSMetadataController() {
         super();
      }
      
      
      public override function objectUpdated(objectSubclass:String, object:Object, reason:String) : void {
         var ssMetadata:SSMetadata = Objects.create(SSMetadata, object);
         ML.latestGalaxy.getSSById(ssMetadata.id).metadata.copyProperties(ssMetadata);
      }
      
      public override function objectDestroyed(objectSubclass:String, objectId:int, reason:String) : void {
         var ssMetadata:SSMetadata = ML.latestGalaxy.getSSById(objectId).metadata;
         ssMetadata.reset();
      }
   }
}