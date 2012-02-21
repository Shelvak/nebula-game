package controllers.objects.actions
{
   import controllers.objects.ObjectClass;
   import controllers.objects.UpdatedReason;

   import models.healing.MCHealingScreen;

   import models.unit.MCLoadUnloadScreen;
   import models.unit.MCUnitScreen;
   
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
            ML.latestPlanet.units.refresh();
            ML.latestPlanet.dispatchUnitRefreshEvent();
            // TODO: Find out why some filters don't refresh if you dont call
            // refresh function on the list
            var HS: MCHealingScreen = MCHealingScreen.getInstance();
            if (HS.oldProvider != null)
            {
               HS.oldProvider.refresh();
               HS.refreshScreen();
            }
            // TODO: Find out why some filters don't refresh if you dont call 
            // refresh function on the list
            var LS: MCLoadUnloadScreen = MCLoadUnloadScreen.getInstance();
            if (LS.oldProvider != null)
            {
               LS.oldProvider.refresh();
               if (reason == UpdatedReason.TRANSPORTATION)
               {
                  LS.refreshScreen();
               }
            }
            // TODO: Find out why some filters don't refresh if you dont call 
            // refresh function on the list
            var US: MCUnitScreen = MCUnitScreen.getInstance();
            if (US.units != null)
            {
               US.units.refresh();
               if (reason == UpdatedReason.TRANSPORTATION)
               {
                  US.refreshScreen();
               }
            }
         }
      }
   }
}