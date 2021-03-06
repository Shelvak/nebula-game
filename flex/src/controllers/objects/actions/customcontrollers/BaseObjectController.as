package controllers.objects.actions.customcontrollers
{
   import flash.errors.IllegalOperationError;
   
   import models.ModelLocator;
   import mx.collections.IList;
   
   
   public class BaseObjectController
   {
      protected function get ML() : ModelLocator {
         return ModelLocator.getInstance();
      }
      
      
      public function BaseObjectController() {
         super();
      }
      
      
      public function objectCreated(objectSubclass:String, object:Object, reason:String) : * {
         throw new IllegalOperationError("This operation is not supported");
      }
      
      public function objectUpdated(objectSubclass:String, object:Object, reason:String) : void {
         throw new IllegalOperationError("This operation is not supported");
      }
      
      public function objectDestroyed(objectSubclass:String, objectId:int, reason:String) : void {
         throw new IllegalOperationError("This operation is not supported");
      }
   }
}