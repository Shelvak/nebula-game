package models.unit
{
   import com.developmentarc.core.utils.EventBroker;

   import controllers.navigation.MCMainArea;
   import controllers.screens.MainAreaScreens;
   import controllers.ui.NavigationController;
   import controllers.units.UnitsCommand;

   import flash.errors.IllegalOperationError;

   import globalevents.GUnitEvent;

   import globalevents.GlobalEvent;

   import models.ModelLocator;

   import models.ModelsCollection;
   import models.Owner;
   import models.events.ScreensSwitchEvent;
   import models.location.LocationType;
   import models.planet.MPlanet;
   import models.player.PlayerOptions;

   import utils.datastructures.Collections;

   import utils.random.Rndm;
   
   
   public class UnitsList extends ModelsCollection
   {
      public function UnitsList(source:Array=null)
      {
         super(source);
      }
      
      
      /**
       * Removes units with given ids from the collection.
       * 
       * @return collection of units removed
       */
      public function removeWithIDs(ids:Array, silent:Boolean = false) : ModelsCollection
      {
         var removedUnits:ModelsCollection = new ModelsCollection();
         for each (var id:int in ids)
         {
            // Modified by Jho: was - removedUnits.addItem(remove(id, silent));
            // if remove() returns null, addItem gets exception null is not a model,
            // so null check is added
            var unit: Unit = remove(id, silent);
            if (unit != null)
            {
               unit.cleanup();
               removedUnits.addItem(unit);
            }
         }
         return removedUnits;
      }

      public function removeStoredUnits(e: ScreensSwitchEvent = null): void
      {
         if (e != null)
         {
            if (MCMainArea.getInstance().currentName == MainAreaScreens.STORAGE
               || MCMainArea.getInstance().currentName == MainAreaScreens.LOAD_UNLOAD
               || MCMainArea.getInstance().currentName == MainAreaScreens.UNITS)
            {
               return;
            }
            MCMainArea.getInstance().removeEventListener(ScreensSwitchEvent.SCREEN_CHANGED,
            removeStoredUnits);
            EventBroker.unsubscribe(GlobalEvent.APP_RESET, reset);
         }
         Collections.filter(this,
            function(unit:Unit) : Boolean
            {
               return unit.location.type == LocationType.UNIT;
            }
         ).removeAll();
      }

      public function removeGarrisonUnits(): void
      {
         Collections.filter(this,
            function(unit:Unit) : Boolean
            {
               return unit.location.type == LocationType.BUILDING;
            }
         ).removeAll();
      }

      private function reset(e: GlobalEvent): void
      {
         MCMainArea.getInstance().removeEventListener(ScreensSwitchEvent.SCREEN_CHANGED,
         removeStoredUnits);
         EventBroker.unsubscribe(GlobalEvent.APP_RESET, reset);
      }

      /* removes all units in this list, whose location is unit after screen
       * change if new screen is not one of these: STORAGE, LOAD_UNLOAD, UNIT*/
      public function removeStoredAfterScreenChange(): void
      {
         MCMainArea.getInstance().addEventListener(ScreensSwitchEvent.SCREEN_CHANGED,
         removeStoredUnits);
         EventBroker.subscribe(GlobalEvent.APP_RESET, reset);
      }
      
      
      public override function shuffle(random:Rndm=null):void
      {
         throw new IllegalOperationError("Method is not supported");
      }

      /* show load or unload screen of given unit */
      public function showUnit(load: Boolean, unit: Unit): void
      {
         removeStoredUnits();
         unitsLoading = load;
         unitToOpen = unit;
         if (!unitsLoading && unitToOpen.stored > 0
                 && (PlayerOptions.defaultTransporterTab ==
                     PlayerOptions.TRANSPORTER_TAB_UNITS))
         {
            EventBroker.subscribe(GUnitEvent.UNITS_SHOWN, openUnit);
            new UnitsCommand(UnitsCommand.SHOW, unitToOpen).dispatch();
         }
         else {
            openUnit();
         }
      }

      private var unitsLoading: Boolean;
      private var unitToOpen: Unit;

      private function openUnit(e: GUnitEvent = null): void {
         var NC: NavigationController = NavigationController.getInstance();
         var planet: MPlanet = ModelLocator.getInstance().latestPlanet;
         var unitsReceived: Boolean = false;
         if (e != null) {
            EventBroker.unsubscribe(GUnitEvent.UNITS_SHOWN, openUnit);
            unitsReceived = true;
         }
         NC.enableActiveButton();
         if (unitsLoading) {
            NC.showLoadUnload(
               planet.toLocation(),
               unitToOpen,
               Collections.filter(
                  planet.units,
                  function (_unit: Unit): Boolean {
                     return (_unit.level > 0)
                               && (_unit.volume > 0)
                               && (_unit.owner == Owner.PLAYER)
                               && _unit.location.type == LocationType.SS_OBJECT;
                  }
               )
            );
         }
         else {
            NC.showLoadUnload(
               unitToOpen,
               planet.toLocation(),
               !unitsReceived
                  ? null
                  : Collections.filter(
                     this,
                     function (_unit: Unit): Boolean {
                        return (_unit.level > 0)
                           && (_unit.location.type == LocationType.UNIT)
                           && (unitToOpen != null)
                           && (_unit.location.id == unitToOpen.id);
                     }
                  )
            );
         }
         unitToOpen = null;
      }
   }
}