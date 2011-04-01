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
      protected override function applyServerActionImpl(objectClass:String,
                                                        objectSubclass:String,
                                                        reason:String,
                                                        objects:Array) : void
      {
         for each (var object:Object in objects)
         {
            getCustomController(objectClass).objectCreated(objectSubclass, object, reason);
         }
      }
   }
}