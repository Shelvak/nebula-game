package models.exploration
{
   import config.Config;
   
   import controllers.planets.PlanetsCommand;
   import controllers.planets.actions.FinishExplorationActionParams;
   
   import flash.errors.IllegalOperationError;
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
   
   import utils.EventUtils;
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
       * @param width width of a foliage
       * @param height height of a foliage
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
       * Calculates time needed for exploration of a foliage of given size.
       * 
       * @param width width of a foliage
       * @param height height of a foliage
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
       * Calculates number of credits required for istantly finishing exploration of a foliage.
       * 
       * @param width width of a foliage
       * @param height height of a foliage
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
      
      private function get planet() : Planet {
         return ML.latestPlanet;
      }
      
      
      public function ExplorationStatus() {
         super();
         ML.player.addEventListener(
            PropertyChangeEvent.PROPERTY_CHANGE,
            player_propertyChangeHandler, false, 0, true
         );
         ML.player.addEventListener(
            PlayerEvent.CREDS_CHANGE,
            player_credsChangeHandler, false, 0, true
         );
      }
      
      private var _foliage:BlockingFolliage
      [Bindable(event="statusChange")]
      public function set foliage(value:BlockingFolliage) : void {
         if (_foliage != value) {
            if (_foliage != null) {
               removeFoliageEventHandlers(_foliage);
               if (planet != null)
                  removePlanetEventHandlers(planet);
            }
            _foliage = value;
            if (_foliage != null) {
               addFoliageEventHandlers(_foliage);
               if (planet != null)
                  addPlanetEventHandlers(planet);
            }
            dispatchStatusChangeEvent();
         }
      }
      public function get foliage() : BlockingFolliage {
         return _foliage;
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
         return calculateNeededScientists(_foliage.width, _foliage.height);
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
         return calculateNeededTime(_foliage.width, _foliage.height);
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
       * Indicates if an exploration of the <code>foliage</code> in the <code>planet</code> is underway.
       * 
       * <p><i><b>Metadata</b>:<br/>
       * [Bindable(event="statusChange")]</p>
       */
      public function get explorationIsUnderway() : Boolean {
         return planet != null && planet.ssObject != null && planet.ssObject.explorationEndsAt != null;
      }
      
      [Bindable(event="statusChange")]
      /**
       * Indicates if an exploration of the <code>foliage</code> can be started considering given resources.
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
       * Idicates if this object is in valid state: that is if <code>palnet</code> and <code>foliage</code>
       * are set and values of other properties can be determined corectly.
       * 
       * <p><i><b>Metadata</b>:<br/>
       * [Bindable(event="statusChange")]</p>
       */
      public function get stateIsValid() : Boolean {
         return _foliage != null && planet != null;
      }
      
      /**
       * Will start exploration if state is valid and all requirements are met.
       */
      public function beginExploration() : void {
         if (stateIsValid && explorationCanBeStarted) {
            new PlanetsCommand(PlanetsCommand.EXPLORE, {
               "planet": planet,
               "folliage": _foliage
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
            return calculateCredsForInstantFinish(
               planet.exploredFoliage.width,
               planet.exploredFoliage.height
            );
         else
            return 0;
      }
      
      [Bindable(event="statusChange")]
      /**
       * Idicates of the player can instatly finish explortion of a foliage. This is true if:
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
       * Requests server to instantly finish exploration of a foliage. Throws exception if instant finishing
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
      
      private function player_propertyChangeHandler(event:PropertyChangeEvent) : void {
         if (event.property == Player.prop_name::scientists)
            dispatchStatusChangeEvent();
      }
      
      private function player_credsChangeHandler(event:PlayerEvent) : void {
         dispatchStatusChangeEvent();
      }
      
      private function addPlanetEventHandlers(palnet:Planet) : void {
         planet.addEventListener(PlanetEvent.OBJECT_ADD, planet_objectsListUpdateHandler, false, 0, true);
         planet.addEventListener(PlanetEvent.OBJECT_REMOVE, planet_objectsListUpdateHandler, false, 0, true);
         planet.ssObject.addEventListener(
            PropertyChangeEvent.PROPERTY_CHANGE,
            ssObject_propertyChangeHandler, false, 0, true
         );
         planet.ssObject.addEventListener(
            SSObjectEvent.OWNER_CHANGE,
            ssObject_ownerChangeHandler, false, 0, true
         );
      }
      
      private function removePlanetEventHandlers(planet:Planet) : void
      {
         planet.removeEventListener(PlanetEvent.OBJECT_ADD, planet_objectsListUpdateHandler, false);
         planet.removeEventListener(PlanetEvent.OBJECT_REMOVE, planet_objectsListUpdateHandler, false);
         if (planet.ssObject != null) {
            planet.ssObject.removeEventListener(
               PropertyChangeEvent.PROPERTY_CHANGE,
               ssObject_propertyChangeHandler, false
            );
            planet.ssObject.removeEventListener(
               SSObjectEvent.OWNER_CHANGE,
               ssObject_ownerChangeHandler, false
            );
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
      
      private function addFoliageEventHandlers(foliage:BlockingFolliage) : void {
         foliage.addEventListener(BaseModelEvent.PENDING_CHANGE, foliage_pendingChangeHandler, false, 0, true);
      }
      
      private function removeFoliageEventHandlers(foliage:BlockingFolliage) : void {
         foliage.removeEventListener(BaseModelEvent.PENDING_CHANGE, foliage_pendingChangeHandler, false);
      }
      
      private function foliage_pendingChangeHandler(event:BaseModelEvent) : void {
         dispatchStatusChangeEvent();
      }
      
      
      /* ################################## */
      /* ### EVENTS DISPATCHING METHODS ### */
      /* ################################## */
      
      private function dispatchStatusChangeEvent() : void {
         EventUtils.dispatchSimpleEvent(this, ExplorationStatusEvent, ExplorationStatusEvent.STATUS_CHANGE);
      }
   }
}