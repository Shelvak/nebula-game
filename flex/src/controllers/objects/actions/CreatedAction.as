package controllers.objects.actions
{
   import controllers.objects.ObjectClass;
   import controllers.units.SquadronsController;
   
   import models.location.LocationType;
   import models.map.MMap;
   import models.unit.Unit;
   
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
            var unit:Unit = Unit(unitsCreated.getItemAt(0));
            var map:MMap;
            switch (unit.location.type) {
               case LocationType.GALAXY: map = ML.latestGalaxy; break;
               case LocationType.SOLAR_SYSTEM: map = ML.latestSolarSystem; break;
               case LocationType.SS_OBJECT: map = ML.latestPlanet; break;
               default: map = null;
            }
            if (map != null) {
               SquadronsController.getInstance().createSquadronsForUnits(unitsCreated, map);
            }
            if (ML.latestPlanet != null) {
               ML.latestPlanet.dispatchUnitRefreshEvent();
            }
         }
         else {
            for each (object in objects) {
               getCustomController(objectClass).objectCreated(objectSubclass, object, reason);
            }
         }
      }
   }
}