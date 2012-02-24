package controllers.objects.actions
{
   import controllers.Messenger;
   import controllers.navigation.MCMainArea;
   import controllers.objects.ObjectClass;
   import controllers.objects.UpdatedReason;
   import controllers.objects.actions.customcontrollers.UnitController;
   import controllers.screens.MainAreaScreens;

   import models.healing.MCHealingScreen;
   import models.unit.MCLoadUnloadScreen;
   import models.unit.MCUnitScreen;

   import utils.locale.Localizer;


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
                                                        objects:Array) : void
      {
         ML.units.disableAutoUpdate();
         if (objectClass == ObjectClass.UNIT)
         {
            UnitController.getInstance().unitsDestroyed(objects, reason);
            if (ML.latestPlanet != null)
            {
               ML.latestPlanet.units.refresh();
               ML.latestPlanet.dispatchUnitRefreshEvent();
            }
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
               LS.refreshScreen();
            }
            // TODO: Find out why some filters don't refresh if you dont call
            // refresh function on the list
            var US: MCUnitScreen = MCUnitScreen.getInstance();
            if (US.units != null)
            {
               US.units.refresh();
               if (reason == UpdatedReason.COMBAT)
               {
                  if (MCMainArea.getInstance().currentName == MainAreaScreens.UNITS)
                  {
                     if (US.hasChanges)
                     {
                        Messenger.show(Localizer.string('Units', 'message.changesCanceled'),
                           Messenger.MEDIUM);
                     }
                     US.refreshScreen();
                     US.cancel();
                  }
               }
            }
         }
         else
            for each (var objectId:int in objects) {
            getCustomController(objectClass).objectDestroyed(objectSubclass, objectId, reason);
         }
         ML.units.enableAutoUpdate();
         if (objectClass == ObjectClass.UNIT && ML.latestPlanet)
         {
            ML.latestPlanet.dispatchUnitRefreshEvent();
         }
      }
   }
}