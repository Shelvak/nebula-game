package models.unit
{
   import com.developmentarc.core.utils.EventBroker;

   import controllers.navigation.MCMainArea;
   import controllers.screens.MainAreaScreens;

   import flash.errors.IllegalOperationError;

   import globalevents.GlobalEvent;

   import models.ModelLocator;

   import models.ModelsCollection;
   import models.events.ScreensSwitchEvent;
   import models.location.LocationType;

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
         Collections.filter(ModelLocator.getInstance().units,
            function(unit:Unit) : Boolean
            {
               return unit.location.type == LocationType.UNIT;
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
   }
}