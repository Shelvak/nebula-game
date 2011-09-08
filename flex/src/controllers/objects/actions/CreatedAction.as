package controllers.objects.actions
{
   import controllers.objects.ObjectClass;
   
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
         ML.units.disableAutoUpdate();
         for each (var object:Object in objects)
         {
            getCustomController(objectClass).objectCreated(objectSubclass, object, reason);
         }
         ML.units.enableAutoUpdate();
         if (objectClass == ObjectClass.UNIT && ML.latestPlanet != null)
         {
            ML.latestPlanet.dispatchUnitRefreshEvent();
         }
      }
   }
}