package controllers.objects.actions
{
   import controllers.objects.ObjectClass;
   import controllers.objects.actions.customcontrollers.UnitController;
   
   
   /**
    *is received after battle for every unit that was destroyed 
    * @author Jho
    * 
    */   
   public class DestroyedAction extends BaseObjectsAction
   {
      override protected function applyServerActionImpl(objectClass:String,
                                                        objectSubclass:String,
                                                        reason:String,
                                                        parameters:Object) : void
      {
         if (ML.latestPlanet)
         {
            ML.latestPlanet.units.disableAutoUpdate();
         }
         if (objectClass == ObjectClass.UNIT)
         {
            UnitController.getInstance().unitsDestroyed(parameters.objectIds, reason);
         }
         else
         {
            for each (var objectId:int in parameters.objectIds)
            {
               getCustomController(objectClass).objectDestroyed(objectSubclass, objectId, reason);
            }
         }
         if (ML.latestPlanet)
         {
            ML.latestPlanet.units.enableAutoUpdate();
         }
      }
   }
}