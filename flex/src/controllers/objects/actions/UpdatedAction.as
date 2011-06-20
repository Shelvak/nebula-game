package controllers.objects.actions
{
   import controllers.objects.ObjectClass;

   /**
    *is received after battle for every unit that was updated 
    * @author Jho
    * 
    */
   public class UpdatedAction extends BaseObjectsAction
   {
      protected override function applyServerActionImpl(objectClass:String,
                                                        objectSubclass:String,
                                                        reason:String,
                                                        objects:Array):void
      {
         ML.units.disableAutoUpdate();
         for each (var object:Object in objects)
         {
            getCustomController(objectClass).objectUpdated(objectSubclass, object, reason);
         }
         ML.units.enableAutoUpdate();
         if (objectClass == ObjectClass.UNIT && ML.latestPlanet != null)
         {
           ML.latestPlanet.dispatchUnitRefreshEvent();
         }
      }
   }
}