package models.exploration
{
   import config.Config;
   
   import controllers.planets.PlanetsCommand;
   import controllers.planets.actions.FinishExplorationActionParams;
   
   import flash.errors.IllegalOperationError;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   
   import models.ModelLocator;
   import models.building.Building;
   import models.building.BuildingType;
   import models.events.BaseModelEvent;
   import models.exploration.events.ExplorationStatusEvent;
   import models.folliage.BlockingFolliage;
   import models.planet.Planet;
   import models.planet.events.PlanetEvent;
   import models.player.Player;
   import models.player.events.PlayerEvent;
   import models.solarsystem.MSSObject;
   import models.solarsystem.events.SSObjectEvent;
   
   import mx.events.PropertyChangeEvent;
   
   import namespaces.prop_name;
   
   import utils.SingletonFactory;
   import utils.StringUtil;
   import utils.datastructures.Collections;
   
   
   /**
    * Dispatched when any of properties defining status of exploration (and that involves all properties)
    * has changed.
    * 
    * @eventType components.exploration.events.ExplorationStatusEvent.STATUS_CHANGE
    */
   [Event(name="statusChange", type="models.exploration.events.ExplorationStatusEvent")]
   
   
   /**
    * Encapsulates status of current exploration process.
    */
   public class ExplorationStatus extends EventDispatcher
   {
      public static function getInstance() : ExplorationStatus {
         return SingletonFactory.getSingletonInstance(ExplorationStatus);
      }
      
      
      /**
       * Calculates number of scientists needed for exploration of a folliage of given size.
       * 
       * @param width width of a folliage
       * @param height height of a folliage
       * 
       * @return number of scientists
       */
      public static function calculateNeededScientists(width:int, height:int) : int {
         return StringUtil.evalFormula(
            Config.getValue("tiles.exploration.scientists"),
            {"width": width, "height": height}
         );
      }
      
      /**
       * Calculates time needed for exploration of a folliage of given size.
       * 
       * @param width width of a folliage
       * @param height height of a folliage
       * 
       * @return time in seconds
       */
      public static function calculateNeededTime(width:int, height:int) : Number {
         return StringUtil.evalFormula(
            Config.getValue("tiles.exploration.time"),
            {"width": width, "height": height}
         );
      }
      
      /**
       * Calculates number of credits required for istantly finishing exploration of a folliage.
       * 
       * @param width width of a folliage
       * @param height height of a folliage
       * 
       * @return number of credits
       */
      public static function calculateCredsForInstantFinish(width:int, height:int) : int {
         return Math.round(StringUtil.evalFormula(
            Config.getValue("creds.exploration.finish"),
            {"width": width, "height": height}
         ));
      }
      
      
      private function get ML() : ModelLocator {
         return ModelLocator.getInstance();
      }
      
      
      public function ExplorationStatus() {
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
      public function get planet() : Planet {
         return ML.latestPlanet;
      }
      
      [Bindable(event="statusChange")]
      /**
       * A folliage currently beeing explored in the <code>planet</code> or is due to be explored.
       * 
       * <p><i><b>Metadata</b>:<br/>
       * [Bindable(event="statusChange")]</p>
       */
      public function get folliage() : BlockingFolliage {
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
      public function get scientistNeeded() : int {
         if (!stateIsValid || explorationIsUnderway)
            return 0;
         return calculateNeededScientists(folliage.width, folliage.height);
      }
      
      [Bindable(event="statusChange")]
      /**
       * How much time (in seconds) will exploration take. This is <code>0</code> if the amount of time
       * can't be determined or exploration is already underway.
       * 
       * <p><i><b>Metadata</b>:<br/>
       * [Bindable(event="statusChange")]</p> 
       */
      public function get timeNeeded() : int {
         if (!stateIsValid || explorationIsUnderway)
            return 0;
         return calculateNeededTime(folliage.width, folliage.height);
      }
      
      /**
       * How much time (in seconds) is left until exploration is completed. This is 0 if state is not valid
       * or exploration is not underway.
       */
      public function get timeLeft() : int {
         if (!explorationIsUnderway)
            return 0;
         return Math.max(0, (ML.latestPlanet.ssObject.explorationEndsAt.time - new Date().time) / 1000);
      }
      
      [Bindable(event="statusChange")]
      /**
       * Indicates if an exploration of the <code>folliage</code> in the <code>planet</code> is underway.
       * 
       * <p><i><b>Metadata</b>:<br/>
       * [Bindable(event="statusChange")]</p>
       */
      public function get explorationIsUnderway() : Boolean {
         return stateIsValid && ML.latestPlanet.ssObject && ML.latestPlanet.ssObject.explorationEndsAt;
      }
      
      [Bindable(event="statusChange")]
      /**
       * Indicates if an exploration of the <code>folliage</code> can be started considering given resources.
       * Returns <code>false</code> if exploration is underway.
       * 
       * <p><i><b>Metadata</b>:<br/>
       * [Bindable(event="statusChange")]</p>
       */
      public function get explorationCanBeStarted() : Boolean {
         return planetBelongsToPlayer && !explorationIsUnderway &&
                planetHasReasearchCenter && playerHasEnoughScientists;
      }
      
      [Bindable(event="statusChange")]
      /**
       * Indicates if there is a Research Center in the <code>planet</code>.
       * 
       * <p><i><b>Metadata</b>:<br/>
       * [Bindable(event="statusChange")]</p>
       */
      public function get planetHasReasearchCenter() : Boolean {
         if (!stateIsValid)
            return false;
         var researchCenter:Building = Collections.findFirst(ML.latestPlanet.buildings,
            function(building:Building) : Boolean {
               return building.type == BuildingType.RESEARCH_CENTER && building.level > 0 ||
                      building.type == BuildingType.MOTHERSHIP;
            }
         );
         return researchCenter != null;
      }
      
      [Bindable(event="statusChange")]
      /**
       * Indicates if the <code>planet</code> belongs to the player. 
       *
       * <p><i><b>Metadata</b>:<br/>
       * [Bindable(event="statusChange")]</p> 
       */
      public function get planetBelongsToPlayer() : Boolean {
         if (!stateIsValid || ML.latestPlanet.ssObject == null)
            return false;
         return ML.latestPlanet.ssObject.ownerIsPlayer;
      }
      
      [Bindable(event="statusChange")]
      /**
       * Idicates if player has enough free scientists to begin an exploration. This returns <code>true</code>
       * if exploration is underway.
       * 
       * <p><i><b>Metadata</b>:<br/>
       * [Bindable(event="statusChange")]</p>
       */      
      public function get playerHasEnoughScientists() : Boolean {
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
      public function get stateIsValid() : Boolean {
         return folliage != null && planet != null;
      }
      
      /**
       * Will start exploration if state is valid and all requirements are met.
       */
      public function beginExploration() : void {
         if (stateIsValid && explorationCanBeStarted) {
            new PlanetsCommand(PlanetsCommand.EXPLORE, {
               "planet": planet,
               "folliage": folliage
            }).dispatch();
         }
      }
      
      
      /* ########################## */
      /* ### INSTANCE FINISHING ### */
      /* ########################## */
      
      [Bindable(event="statusChange")]
      /**
       * Number of credits the player will have to pay to instantly finish exploration of the folliage beeing
       * explored.
       */      
      public function get instantFinishCost() : int {
         if (explorationIsUnderway)
            return calculateCredsForInstantFinish(folliage.width, folliage.height);
         else
            return 0;
      }
      
      [Bindable(event="statusChange")]
      /**
       * Idicates of the player can instatly finish explortion of a folliage. This is true if:
       * <ul>
       *    <li>exploration is underway and</li>
       *    <li>player has enough credits</li>
       * </ul>
       */
      public function get canInstantFinish() : Boolean {
         if (explorationIsUnderway && ML.player.creds >= instantFinishCost)
            return true;
         return false;
      }
      
      /**
       * Requests server to instantly finish exploration of a folliage. Throws exception if instant finishing
       * is not available.
       */
      public function finishInstantly() : void {
         if (canInstantFinish)
            new PlanetsCommand(PlanetsCommand.FINISH_EXPLORATION, new FinishExplorationActionParams(planet.id)).dispatch();
         else
            throw new IllegalOperationError(
               "Instant finishing of exploration is not available: " +
                  explorationIsUnderway ?
                     "player " + ML.player + " only has " + ML.player.creds + " creds but " + instantFinishCost + " is required" :
                     "exploration is not underway"
            );
      }
      
      
      /* ############################# */
      /* ### MODELS EVENT HANDLERS ### */
      /* ############################# */      
      
      private function addModelLocatorEventHandlers() : void {
         ML.addEventListener(PropertyChangeEvent.PROPERTY_CHANGE, ML_propertyChangeHandler);
         ML.player.addEventListener(PropertyChangeEvent.PROPERTY_CHANGE, player_propertyChangeHandler);
         ML.player.addEventListener(PlayerEvent.CREDS_CHANGE, player_credsChangeHandler, false, 0, true);
      }
      
      private function ML_propertyChangeHandler(event:PropertyChangeEvent) : void {
         switch (event.property) 
         {
            case ModelLocator.prop_name::latestPlanet:
               if (event.oldValue != null)
                  removePlanetEventHandlers(Planet(event.oldValue));
               if (event.newValue != null)
                  addPlanetEventHandlers(Planet(event.newValue));
               dispatchStatusChangeEvent();
               break;
            
            case ModelLocator.prop_name::selectedFolliange:
               if (event.oldValue != null)
                  removeFolliageEventHandlers(BlockingFolliage(event.oldValue));
               if (event.newValue != null)
                  addFolliageEventHandlers(BlockingFolliage(event.newValue));
               dispatchStatusChangeEvent();
               break;
         }
      }
      
      private function player_propertyChangeHandler(event:PropertyChangeEvent) : void {
         if (event.property == Player.prop_name::scientists)
            dispatchStatusChangeEvent();
      }
      
      private function player_credsChangeHandler(event:PlayerEvent) : void {
         dispatchStatusChangeEvent();
      }
      
      private function addPlanetEventHandlers(palnet:Planet) : void {
         planet.addEventListener(PlanetEvent.OBJECT_ADD, planet_objectsListUpdateHandler);
         planet.addEventListener(PlanetEvent.OBJECT_REMOVE, planet_objectsListUpdateHandler);
         planet.ssObject.addEventListener(PropertyChangeEvent.PROPERTY_CHANGE,
                                          ssObject_propertyChangeHandler, false, 0, true);
         planet.ssObject.addEventListener(SSObjectEvent.OWNER_CHANGE,
                                          ssObject_ownerChangeHandler, false, 0, true);
      }
      
      private function removePlanetEventHandlers(planet:Planet) : void
      {
         planet.removeEventListener(PlanetEvent.OBJECT_ADD, planet_objectsListUpdateHandler);
         planet.removeEventListener(PlanetEvent.OBJECT_REMOVE, planet_objectsListUpdateHandler);
         if (planet.ssObject != null) {
            planet.ssObject.removeEventListener(PropertyChangeEvent.PROPERTY_CHANGE,
                                                ssObject_propertyChangeHandler, false);
            planet.ssObject.removeEventListener(SSObjectEvent.OWNER_CHANGE,
                                                ssObject_ownerChangeHandler, false);
         }
      }
      
      private function planet_objectsListUpdateHandler(event:PlanetEvent) : void {
         dispatchStatusChangeEvent();
      }
      
      private function ssObject_propertyChangeHandler(event:PropertyChangeEvent) : void {
         if (event.property == MSSObject.prop_name::explorationEndsAt)
            dispatchStatusChangeEvent();
      }
      
      private function ssObject_ownerChangeHandler(event:SSObjectEvent) : void {
         dispatchStatusChangeEvent();
      }
      
      private function addFolliageEventHandlers(folliage:BlockingFolliage) : void {
         folliage.addEventListener(BaseModelEvent.PENDING_CHANGE, folliage_pendingChangeHandler);
      }
      
      private function removeFolliageEventHandlers(folliage:BlockingFolliage) : void {
         folliage.removeEventListener(BaseModelEvent.PENDING_CHANGE, folliage_pendingChangeHandler);
      }
      
      private function folliage_pendingChangeHandler(event:BaseModelEvent) : void {
         dispatchStatusChangeEvent();
      }
      
      
      /* ################################## */
      /* ### EVENTS DISPATCHING METHODS ### */
      /* ################################## */
      
      private function dispatchStatusChangeEvent() : void {
         if (hasEventListener(ExplorationStatusEvent.STATUS_CHANGE))
            dispatchEvent(new ExplorationStatusEvent(ExplorationStatusEvent.STATUS_CHANGE));
      }
   }
}