package controllers.objects.actions.customcontrollers
{
   import flash.errors.IllegalOperationError;
   
   import models.ModelLocator;
   
   
   public class BaseObjectController
   {
      protected var ML:ModelLocator = ModelLocator.getInstance();
      
      
      public function BaseObjectController()
      {
      }
      
      
      public function objectCreated(objectSubclass:String, object:Object, reason:String) : void
      {
         throw new IllegalOperationError("This operation is not supported");
      }
      
      
      public function objectUpdated(objectSubclass:String, object:Object, reason:String) : void
      {
         throw new IllegalOperationError("This operation is not supported");
      }
      
      
      public function objectDestroyed(objectSubclass:String, objectId:int, reason:String) : void
      {
         throw new IllegalOperationError("This operation is not supported");
      }
   }
}