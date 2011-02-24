package controllers.objects.actions.customcontrollers
{
   import utils.SingletonFactory;
   
   import models.BaseModel;
   import models.solarsystem.SSMetadata;
   
   
   public class SSMetadataController extends BaseObjectController
   {
      public static function getInstance() : SSMetadataController
      {
         return SingletonFactory.getSingletonInstance(SSMetadataController);
      }
      
      
      public function SSMetadataController()
      {
         super();
      }
      
      
      public override function objectUpdated(objectSubclass:String, object:Object, reason:String) : void
      {
         var ssMetadata:SSMetadata = BaseModel.createModel(SSMetadata, object);
         ML.latestGalaxy.getSSById(ssMetadata.id).metadata.copyProperties(ssMetadata);
      }
   }
}