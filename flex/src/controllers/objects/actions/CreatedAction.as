package controllers.objects.actions
{
   import controllers.objects.ObjectClass;
   import controllers.units.SquadronsController;
   
   import globalevents.GObjectEvent;
   
   import mx.collections.ArrayCollection;
   
   
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
                                                        objects:Array) : void {
         var object:Object;
         if (objectClass == ObjectClass.UNIT) {
            var unitsCreated:ArrayCollection = new ArrayCollection();
            ML.units.disableAutoUpdate();
            for each (object in objects) {
               unitsCreated.addItem(getCustomController(objectClass).objectCreated(objectSubclass, object, reason));
            }
            ML.units.enableAutoUpdate();
            SquadronsController.getInstance().createSquadronsForUnits(unitsCreated);
            if (ML.latestPlanet != null)
               ML.latestPlanet.dispatchUnitRefreshEvent();
         }
         else {
            for each (object in objects) {
               getCustomController(objectClass).objectCreated(objectSubclass, object, reason);
            }
         }
      }
   }
}