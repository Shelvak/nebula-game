package components.exploration
{
   import components.exploration.events.ExplorationStatusEvent;
   
   import config.Config;
   
   import flash.events.EventDispatcher;
   
   import models.ModelLocator;
   import models.building.Building;
   import models.building.BuildingType;
   import models.events.BaseModelEvent;
   import models.folliage.BlockingFolliage;
   import models.planet.Planet;
   import models.planet.events.PlanetEvent;
   
   import mx.events.PropertyChangeEvent;
   
   import utils.StringUtil;
   import utils.datastructures.Collections;
   
   
   /**
    * Dispatched when any of properties defining status of exploration (and that involves all properties)
    * has changed.
    * 
    * @eventType components.exploration.events.ExplorationStatusEvent.STATUS_CHANGE
    */
   [Event(name="statusChange", type="components.exploration.events.ExplorationStatusEvent")]
   
   
   /**
    * Encapsulates status of current exploration process.
    */
   public class ExplorationStatus extends EventDispatcher
   {
      private var ML:ModelLocator = ModelLocator.getInstance();
      
      
      public function ExplorationStatus()
      {
         super();
         addModelLocatorEventHandlers();
      }
      
      
      [Bindable(event="statusChange")]
      /**
       * A planet in which the folliage currently beeing explored or due to be explored is.
       * 
       * <p><i><b>Metadata</b>:<br/>
       * [Bindable(event="statusChange")]</p>
       */
      public function get planet() : Planet
      {
         return ML.latestPlanet;
      }
      
      
      [Bindable(event="statusChange")]
      /**
       * A folliage currently beeing explored in the <code>planet</code> or is due to be explored.
       * 
       * <p><i><b>Metadata</b>:<br/>
       * [Bindable(event="statusChange")]</p>
       */
      public function get folliage() : BlockingFolliage
      {
         return ML.selectedFolliage;
      }
      
      
      [Bindable(event="statusChange")]
      /**
       * How many scientists are needed for the exploration. This is <code>0</code> if the count can't be
       * determined or exploration is already underway.
       * 
       * <p><i><b>Metadata</b>:<br/>
       * [Bindable(event="statusChange")]</p> 
       */
      public function get scientistNeeded() : int
      {
         if (!stateIsValid || explorationIsUnderway)
         {
            return 0;
         }
         return StringUtil.evalFormula(
            Config.getValue("tiles.exploration.scientists"),
            {"width": folliage.width, "height": folliage.height}
         );
      }
      
      
      [Bindable(event="statusChange")]
      /**
       * How much time (in seconds) will exploration take. This is <code>0</code> if the amount of time
       * can't be determined or exploration is already underway.
       * 
       * <p><i><b>Metadata</b>:<br/>
       * [Bindable(event="statusChange")]</p> 
       */
      public function get timeNeeded() : int
      {
         if (!stateIsValid || explorationIsUnderway)
         {
            return 0;
         }
         return StringUtil.evalFormula(
            Config.getValue("tiles.exploration.time"),
            {"width": folliage.width, "height": folliage.height}
         );
      }
      
      
      /**
       * How much time (in seconds) is left unit exploration is completed. This is 0 if state is not valid
       * or exploration is not underway.
       */
      public function get timeLeft() : int
      {
         if (!explorationIsUnderway)
         {
            return 0;
         }
         return Math.max(0, ML.latestPlanet.ssObject.explorationEndsAt.time - new Date().time);
      }
      
      
      [Bindable(event="statusChange")]
      /**
       * Indicates if an exploration of the <code>folliage</code> in the <code>planet</code> is underway.
       * 
       * <p><i><b>Metadata</b>:<br/>
       * [Bindable(event="statusChange")]</p>
       */
      public function get explorationIsUnderway() : Boolean
      {
         return stateIsValid && ML.latestPlanet.ssObject && ML.latestPlanet.ssObject.explorationEndsAt;
      }
      
      
      [Bindable(event="statusChange")]
      /**
       * Indicates if an exploration of the <code>folliage</code> can be started considering given resources.
       * 
       * <p><i><b>Metadata</b>:<br/>
       * [Bindable(event="statusChange")]</p>
       */
      public function get explorationCanBeStarted() : Boolean
      {
         return planetHasReasearchCenter && playerHasEnoughScientists;
      }
      
      
      [Bindable(event="statusChange")]
      /**
       * Indicates if there is a Research Center in the <code>planet</code>.
       * 
       * <p><i><b>Metadata</b>:<br/>
       * [Bindable(event="statusChange")]</p>
       */
      public function get planetHasReasearchCenter() : Boolean
      {
         if (!stateIsValid)
         {
            return false;
         }
         var researchCenter:Building = Collections.findFirst(ML.latestPlanet.buildings,
            function(building:Building) : Boolean
            {
               return building.type == BuildingType.RESEARCH_CENTER
            }
         );
         return researchCenter != null;
      }
      
      
      [Bindable(event="statusChange")]
      /**
       * Idicates if player has enough free scientists to begin an exploration. This returns <code>true</code>
       * if exploration is underway.
       * 
       * <p><i><b>Metadata</b>:<br/>
       * [Bindable(event="statusChange")]</p>
       */      
      public function get playerHasEnoughScientists() : Boolean
      {
         return explorationIsUnderway || stateIsValid && scientistNeeded <= ML.player.scientists;
      }
      
      
      [Bindable(event="statusChange")]
      /**
       * Idicates if this object is in valid state: that is if <code>palnet</code> and <code>folliage</code>
       * are set and values of other properties can be determined corectly.
       * 
       * <p><i><b>Metadata</b>:<br/>
       * [Bindable(event="statusChange")]</p>
       */
      public function get stateIsValid() : Boolean
      {
         return folliage && planet;
      }
      
      
      /* ############################# */
      /* ### MODELS EVENT HANDLERS ### */
      /* ############################# */
      
      
      private function addModelLocatorEventHandlers() : void
      {
         ML.addEventListener(PropertyChangeEvent.PROPERTY_CHANGE, ML_propertyChangeHandler);
         ML.player.addEventListener(PropertyChangeEvent.PROPERTY_CHANGE, player_propertyChangeHandler);
      }
      
      
      private function ML_propertyChangeHandler(event:PropertyChangeEvent) : void
      {
         switch (event.property)
         {
            case "latestPlanet":
               if (event.oldValue)
               {
                  removePlanetEventHandlers(Planet(event.oldValue));
               }
               if (event.newValue)
               {
                  addPlanetEventHandlers(Planet(event.newValue));
               }
               dispatchStatusChangeEvent();
               break;
            
            case "selectedFolliage":
               if (event.oldValue)
               {
                  removeFolliageEventHandlers(BlockingFolliage(event.oldValue));
               }
               if (event.newValue)
               {
                  addFolliageEventHandlers(BlockingFolliage(event.newValue));
               }
               dispatchStatusChangeEvent();
               break;
         }
      }
      
      
      private function player_propertyChangeHandler(event:PropertyChangeEvent) : void
      {
         if (event.property == "scientists")
         {
            dispatchStatusChangeEvent();
         }
      }
      
      
      private function addPlanetEventHandlers(palnet:Planet) : void
      {
         planet.addEventListener(PlanetEvent.OBJECT_ADD, planet_objectsListUpdateHandler);
         planet.addEventListener(PlanetEvent.OBJECT_REMOVE, planet_objectsListUpdateHandler);
         planet.ssObject.addEventListener(PropertyChangeEvent.PROPERTY_CHANGE,
                                          ssObject_propertyChangeHandler, false, 0, true);
      }
      
      
      private function removePlanetEventHandlers(planet:Planet) : void
      {
         planet.removeEventListener(PlanetEvent.OBJECT_ADD, planet_objectsListUpdateHandler);
         planet.removeEventListener(PlanetEvent.OBJECT_REMOVE, planet_objectsListUpdateHandler);
         if (planet.ssObject)
         {
            planet.ssObject.removeEventListener(PropertyChangeEvent.PROPERTY_CHANGE,
                                                ssObject_propertyChangeHandler);
         }
      }
      
      
      private function planet_objectsListUpdateHandler(event:PlanetEvent) : void
      {
         dispatchStatusChangeEvent();
      }
      
      
      private function ssObject_propertyChangeHandler(event:PropertyChangeEvent) : void
      {
         if (event.property == "explorationEndsAt")
         {
            dispatchStatusChangeEvent();
         }
      }
      
      
      private function addFolliageEventHandlers(folliage:BlockingFolliage) : void
      {
         folliage.addEventListener(BaseModelEvent.PENDING_CHANGE, folliage_pendingChangeHandler);
      }
      
      
      private function removeFolliageEventHandlers(folliage:BlockingFolliage) : void
      {
         folliage.removeEventListener(BaseModelEvent.PENDING_CHANGE, folliage_pendingChangeHandler);
      }
      
      
      private function folliage_pendingChangeHandler(event:BaseModelEvent) : void
      {
         dispatchStatusChangeEvent();
      }
      
      
      /* ################################## */
      /* ### EVENTS DISPATCHING METHODS ### */
      /* ################################## */
      
      
      private function dispatchStatusChangeEvent() : void
      {
         if (hasEventListener(ExplorationStatusEvent.STATUS_CHANGE))
         {
            dispatchEvent(new ExplorationStatusEvent(ExplorationStatusEvent.STATUS_CHANGE));
         }
      }
   }
}