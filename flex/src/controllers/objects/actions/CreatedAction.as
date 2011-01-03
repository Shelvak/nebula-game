package controllers.objects.actions
{
   import globalevents.GObjectEvent;
   
   
   /**
    * is received for every object that was created 
    * @author Jho
    * 
    */   
   public class CreatedAction extends BaseObjectsAction
   {
      override protected function applyServerActionImpl(objectClass:String,
                                                        objectSubclass:String,
                                                        reason:String,
                                                        parameters:Object) : void
      {
         for each (var object:Object in parameters.objects)
         {
            getCustomController(objectClass).objectCreated(objectSubclass, object, reason);
            new GObjectEvent(GObjectEvent.OBJECT_APPROVED);
         }
      }
   }
}