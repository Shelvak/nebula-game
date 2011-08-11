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
      /**
       * Returns "objectIds".
       */
      protected override function get objectsHashName() : String {
         return "objectIds";
      }
      
      
      protected override function applyServerActionImpl(objectClass:String,
                                                        objectSubclass:String,
                                                        reason:String,
                                                        objects:Array) : void {
         if (ML.latestPlanet != null)
            ML.latestPlanet.units.disableAutoUpdate();
         if (objectClass == ObjectClass.UNIT)
            UnitController.getInstance().unitsDestroyed(objects, reason);
         else
            for each (var objectId:int in objects) {
               getCustomController(objectClass).objectDestroyed(objectSubclass, objectId, reason);
            }
         if (ML.latestPlanet != null)
            ML.latestPlanet.units.enableAutoUpdate();
      }
   }
}