package models.player
{
   import config.Config;
   
   import interfaces.IUpdatable;
   
   import models.Reward;
   import models.parts.events.UpgradeEvent;
   import models.player.events.PlayerEvent;
   import models.solarsystem.MSSObject;
   import models.technology.TechnologiesModel;
   import models.technology.Technology;
   import models.time.MTimeEventFixedMoment;
   import models.time.events.MTimeEventEvent;
   
   import mx.collections.ArrayCollection;
   import mx.collections.Sort;
   import mx.utils.ObjectUtil;
   
   import utils.DateUtil;
   import utils.MathUtil;
   import utils.NumberUtil;
   import utils.datastructures.Collections;
   
   
   /**
    * @see models.player.events.PlayerEvent#POPULATION_CAP_CHANGE
    * @eventType models.player.events.PlayerEvent.POPULATION_CAP_CHANGE
    */
   [Event(name="populationCapChange", type="models.player.events.PlayerEvent")]
   
   /**
    * @see models.player.events.PlayerEvent#CREDS_CHANGE
    * @eventType models.player.events.PlayerEvent.CREDS_CHANGE
    */
   [Event(name="credsChange", type="models.player.events.PlayerEvent")]
   
   /**
    * @see models.player.events.PlayerEvent#SCIENTISTS_CHANGE
    * @eventType models.player.events.PlayerEvent.SCIENTISTS_CHANGE
    */
   [Event(name="scientistsChange", type="models.player.events.PlayerEvent")]
   
   /**
    * @see models.player.events.PlayerEvent#ALLIANCE_ID_CHANGE
    * @eventType models.player.events.PlayerEvent.ALLIANCE_ID_CHANGE
    */
   [Event(name="allianceIdChange", type="models.player.events.PlayerEvent")]
   
   /**
    * @see models.player.events.PlayerEvent#ALLIANCE_OWNER_CHANGE
    * @eventType models.player.events.PlayerEvent.ALLIANCE_OWNER_CHANGE
    */
   [Event(name="allianceOwnerChange", type="models.player.events.PlayerEvent")]
   
   /**
    * @see models.player.events.PlayerEvent#ALLIANCE_PLAYER_COUNT_CHANGE
    * @eventType models.player.events.PlayerEvent.ALLIANCE_PLAYER_COUNT_CHANGE
    */
   [Event(name="alliancePlayerCountChange", type="models.player.events.PlayerEvent")]
   
   /**
    * @see models.player.events.PlayerEvent#MAX_ALLIANCE_PLAYER_COUNT_CHANGE
    * @eventType models.player.events.PlayerEvent.MAX_ALLIANCE_PLAYER_COUNT_CHANGE
    */
   [Event(name="maxAlliancePlayerCountChange", type="models.player.events.PlayerEvent")]
   
   /**
    * @see models.player.events.PlayerEvent#ALLIANCE_COOLDOWN_CHANGE
    * @eventType models.player.events.PlayerEvent.ALLIANCE_COOLDOWN_CHANGE
    */
   [Event(name="allianceCooldownChange", type="models.player.events.PlayerEvent")]
   
   
   [Bindable]
   public class Player extends PlayerMinimal implements IUpdatable
   {
      public function Player()
      {
         super();
         planets = new ArrayCollection();
         planets.sort = new Sort();
         planets.sort.compareFunction = compareFunction_planets;
         planets.refresh();
         
         _allianceCooldown = new MTimeEventFixedMoment();
         _allianceCooldown.occuresAt = DateUtil.BEGINNING;
         _allianceCooldown.addEventListener
            (MTimeEventEvent.HAS_OCCURED_CHANGE, allianceCooldown_hasOccuredChange, false, 0, true);
      }
      
      
      [Optional]
      /**
       * Indicates if the player has logged in for the first time. Makes sense only for the player instance
       * in <code>ModelLocator</code>.
       * 
       * <p><i><b>Metadata</b>:<br/>
       * [Optional]</i></p>
       * 
       * @default false
       */
      public var firstTime:Boolean = false;
      
      
      [SkipProperty]
      /**
       * Makes sense only for the player instance in <code>ModelLocator</code>.
       * 
       * <p><i><b>Metadata</b>:<br/>
       * [SkipProperty]</i></p>
       * 
       * @default 0
       */
      public var galaxyId:int = 0;
      
      
      [SkipProperty]
      /**
       * Makes sense only for the player instance in <code>ModelLocator</code>.
       * 
       * <p><i><b>Metadata</b>:<br/>
       * [SkipProperty]</i></p>
       * 
       * @default null
       */
      public var loggedIn:Boolean = false;
      
      [SkipProperty]
      public var dailyBonus: Reward = null;
      
      
      [SkipProperty]
      /**
       * A list of all planets this player owns. Elements of this collection are instances of <b>SSObject</b>.
       * 
       * <p><i><b>Metadata</b>:<br/>
       * [SkipProperty]</i></p>
       */
      public var planets:ArrayCollection;
      private function compareFunction_planets(p0:MSSObject, p1:MSSObject, fields:Array = null) : int
      {
         var res:int = ObjectUtil.stringCompare(p0.name, p1.name, true);
         return res == 0 ? NumberUtil.compare(p0.id, p1.id) : res;
      }
      
      /**
       * Number of planets owned by the player (including the ones in battlegrounds).
       */ 
      public function get planetsCountAll() : int {
         return planets != null ? planets.length : 0;
      }
      
      
      private var _creds: int = 0;
      [Bindable(event="credsChange")]
      [Optional]
      /**
       * Amount of credits player has.
       */
      public function set creds(value: int): void
      {
         if (_creds != value)
         {
            _creds = value;
            dispatchCredsChangeEvent();
         }
      }
      /**
       * @private
       */
      public function get creds(): int
      {
         return _creds;
      }
      
      
      [Optional]
      public var vipLevel: int = 0;
      
      [Optional]
      public var vipCreds: int = 0;
      
      [Optional]
      public var freeCreds: int = 0;
      
      [Optional]
      public var vipCredsUntil: Date;
      public var vipCredsTime: String = null;
      
      [Optional]
      public var vipUntil: Date;
      public var vipTime: String = null;
      
      private var _population: int;
      
      [Optional]
      public function set population(value: int): void
      {
         _population = value;
         dispatchPopulationChangeEvent();
      }
      
      [Bindable (event="populationChange")]
      public function get population(): int
      {
         return _population;
      }
      
      [Optional]
      public function set populationCap(value: int): void
      {
         _populationCap = value;
         dispatchPopulationCapChangeEvent();
      }
      
      [Bindable (event="populationCapChange")]
      public function get populationCap(): int
      {
         return _populationCap;
      }
      
      private var _populationCap: int = 0;
      
      [Bindable (event="populationCapChange")]
      public function get populationMax(): int
      {
         return Math.min(_populationCap, Config.getMaxPopulation());
      }
      
      [Bindable (event="populationCapChange")]
      public function get populationMaxReached(): Boolean
      {
         return _populationCap >= Config.getMaxPopulation();
      }
      
      [Bindable (event="populationChange")]
      public function get overPopulationAntibonus(): Number
      {
         return MathUtil.round(100 * (1 - (populationMax / population)), 1);
      }
      
      private var _scientists:int = 0;
      [Bindable(event="scientistsChange")]
      [Optional]
      public function set scientists(value: int): void
      {
         if (_scientists != value)
         {
            _scientists = value;
            dispatchScientistsChangeEvent();
            dispatchPropertyUpdateEvent("scientists", value);
         }
      }
      public function get scientists(): int
      {
         return _scientists
      }
      
      
      [Optional]
      public var scientistsTotal:int = 0;
      
      
      [Optional]
      public var xp:int = 0;
      
      
      /* ################ */
      /* ### ALLIANCE ### */
      /* ################ */
      
      private var _alliancesTechnology:Technology = null; 
      private function get alliancesTechnology() : Technology {
         if (_alliancesTechnology == null) {
            _alliancesTechnology = ML.technologies.getTechnologyByType(TechnologiesModel.TECH_ALLIANCES);
            _alliancesTechnology.addEventListener
               (UpgradeEvent.LEVEL_CHANGE, alliancesTech_levelChangeHandler, false, 0, true);
         }
         return _alliancesTechnology;
      }
      
      private var _allianceId:int = 0;
      [Optional]
      [Bindable(event="allianceIdChange")]
      /**
       * Id of an alliance the player belongs to.
       */
      public function set allianceId(value:int) : void {
         if (_allianceId != value) {
            _allianceId = value;
            dispatchPlayerEvent(PlayerEvent.ALLIANCE_ID_CHANGE);
         }
      }
      /**
       * @private
       */
      public function get allianceId() : int {
         return _allianceId;
      }
      
      [Bindable(event="allianceIdChange")]
      /**
       * <code>true</code> if this player belongs to an alliance.
       */
      public function get belongsToAlliance() : Boolean {
         return allianceId > 0;
      }
      
      private var _allianceOwner:Boolean = false;
      [Optional]
      [Bindable(event="allianceOwnerChange")]
      /**
       * Does the player owns his alliance?
       */
      public function set allianceOwner(value:Boolean) : void {
         if (_allianceOwner != value)
         {
            _allianceOwner = value;
            dispatchPlayerEvent(PlayerEvent.ALLIANCE_OWNER_CHANGE);
         }
      }
      /**
       * @private
       */
      public function get allianceOwner() : Boolean {
         return _allianceOwner;
      }
      
      private var _alliancePlayerCount:int = 0;
      [Optional]
      [Bindable(event="alliancePlayerCountChange")]
      /**
       * Number of members in the player's alliance. This is only not <code>0</code> if the player owns
       * the alliance.
       */
      public function set alliancePlayerCount(value:int) : void {
         if (_alliancePlayerCount != value)
         {
            _alliancePlayerCount = value;
            dispatchPlayerEvent(PlayerEvent.ALLIANCE_PLAYER_COUNT_CHANGE);
         }
      }
      /**
       * @private
       */
      public function get alliancePlayerCount() : int {
         return _alliancePlayerCount;
      }
      
      private function alliancesTech_levelChangeHandler(event:UpgradeEvent) : void {
         dispatchPlayerEvent(PlayerEvent.MAX_ALLIANCE_PLAYER_COUNT_CHANGE);
      }
      
      [Bindable(event="maxAlliancePlayerCountChange")]
      public function get maxAlliancePlayerCount() : int {
         return Config.getAllianceMaxPlayers(alliancesTechnology.level);
      }
      
      [Bindable(event="maxAlliancePlayerCountChange")]
      public function get hasAllianceTechnology() : Boolean {
         return maxAlliancePlayerCount > 0;
      }
      
      [Bindable(event="alliancePlayerCountChange")]
      [Bindable(event="maxAlliancePlayerCountChange")]
      public function get allianceFull() : Boolean {
         return maxAlliancePlayerCount == alliancePlayerCount;
      }
      
      [Bindable(event="allianceIdChange")]
      [Bindable(event="allianceCooldownChange")]
      public function get canJoinAlliance() : Boolean {
         return !belongsToAlliance && !allianceCooldownInEffect;
      }
      
      public function belongsTo(allianceId:int) : Boolean {
         return this.allianceId == allianceId;
      }
      
      public function ownsAlliance(allianceId:int) : Boolean {
         return belongsTo(allianceId) && allianceOwner;
      }
      
      
      /* ######################### */
      /* ### ALLIANCE COOLDOWN ### */
      /* ######################### */
      
      private var _allianceCooldown:MTimeEventFixedMoment;
      [Bindable(event="willNotChange")]
      public function get allianceCooldown() : MTimeEventFixedMoment {
         return _allianceCooldown;
      }
      
      private function allianceCooldown_hasOccuredChange(event:MTimeEventEvent) : void {
         dispatchPlayerEvent(PlayerEvent.ALLIANCE_COOLDOWN_CHANGE);
      }
      
      [Bindable(event="allianceCooldownChange")]
      public function get allianceCooldownInEffect() : Boolean {
         return !allianceCooldown.hasOccured;
      }
      
      
      /* ############# */
      /* ### STATS ### */
      /* ############# */
      
      
      [SkipProperty]
      [Bindable(event="propertyChange")]
      /**
       * Sum of all points: war, economy, science and army.
       * 
       * <p><i><b>Metadata</b>:<br/>
       * [SkipProperty]</i></p>
       */
      public function get points() : int
      {
         return warPoints + economyPoints + sciencePoints + armyPoints;
      }
      private function dispatchPointsPropertyChangeEvent() : void
      {
         dispatchPropertyUpdateEvent("points", points);
      }
      
      
      private var _warPoints:int = 0;
      [Optional]
      [Bindable(event="propertyChange")]
      public function set warPoints(value:int) : void
      {
         var oldValue:int = _warPoints;
         if (oldValue != value)
         {
            _warPoints = value;
            dispatchPropertyUpdateEvent("warPoints", value, oldValue);
            dispatchPointsPropertyChangeEvent();
         }
      }
      public function get warPoints() : int
      {
         return _warPoints;
      }
      
      
      private var _economyPoints:int = 0;
      [Optional]
      [Bindable(event="propertyChange")]
      public function set economyPoints(value:int) : void
      {
         var oldValue:int = _economyPoints;
         if (oldValue != value)
         {
            _economyPoints = value;
            dispatchPropertyUpdateEvent("economyPoints", value, oldValue);
            dispatchPointsPropertyChangeEvent();
         }
      }
      public function get economyPoints() : int
      {
         return _economyPoints;
      }
      
      
      private var _sciencePoints:int = 0;
      [Optional]
      [Bindable(event="propertyChange")]
      public function set sciencePoints(value:int) : void
      {
         var oldValue:int = _sciencePoints;
         if (oldValue != value)
         {
            _sciencePoints = value;
            dispatchPropertyUpdateEvent("sciencePoints", value, oldValue);
            dispatchPointsPropertyChangeEvent();
         }
      }
      public function get sciencePoints() : int
      {
         return _sciencePoints;
      }
      
      
      private var _armyPoints:int = 0;
      [Optional]
      [Bindable(event="propertyChange")]
      public function set armyPoints(value:int) : void
      {
         var oldValue:int = _armyPoints;
         if (oldValue != value)
         {
            _armyPoints = value;
            dispatchPropertyUpdateEvent("armyPoints", value, oldValue);
            dispatchPointsPropertyChangeEvent();
         }
      }
      public function get armyPoints() : int
      {
         return _armyPoints;
      }
      
      
      private var _victoryPoints:int = 0;
      [Optional]
      [Bindable(event="propertyChange")]
      public function set victoryPoints(value:int) : void
      {
         var oldValue:int = _victoryPoints;
         if (oldValue != value)
         {
            _victoryPoints = value;
            dispatchPropertyUpdateEvent("victoryPoints", value, oldValue);
            dispatchPointsPropertyChangeEvent();
         }
      }
      public function get victoryPoints() : int
      {
         return _victoryPoints;
      }
      
      
      
      [Optional]
      /**
       * Number of planets in normal solar systems owned by the player.
       */ 
      public var planetsCount:int = 0;
      
      
      public function reset() : void
      {
         Collections.cleanListOfICleanables(planets);
         loggedIn = false;
         scientists = 0;
         scientistsTotal = 0;
         xp = 0;
         allianceId = 0;
         warPoints = 0;
         sciencePoints = 0;
         armyPoints = 0;
         economyPoints = 0;
         planetsCount = 0;
         if (_alliancesTechnology != null)
         {
            _alliancesTechnology.removeEventListener
               (UpgradeEvent.LEVEL_CHANGE, alliancesTech_levelChangeHandler, false);
            _alliancesTechnology = null;
         }
      }
      
      
      /* ################## */
      /* ### IUpdatable ### */
      /* ################## */
      
      
      public function update() : void {
         var now:Number = DateUtil.now;
         
         _allianceCooldown.update();
         
         if (vipCredsUntil != null && vipCredsUntil.time > now)
            vipCredsTime = DateUtil.secondsToHumanString((vipCredsUntil.time - now) / 1000, 2);
         else
            vipCredsTime = null;
         
         if (vipUntil != null && vipUntil.time > now)
            vipTime = DateUtil.secondsToHumanString((vipUntil.time - now) / 1000, 2);
         else
            vipTime = null;
      }
      
      
      public function resetChangeFlags() : void {
         _allianceCooldown.resetChangeFlags();
      }
      
      
      /* ########################### */
      /* ### BaseModel OVERRIDES ### */
      /* ########################### */
      
      
      public override function toString() : String {
         return "[class: " + className + ", id: " + id + ", name: " + name + "]";
      }
      
      
      /* ############### */
      /* ### HELPERS ### */
      /* ############### */
      
      private function dispatchPlayerEvent(type:String) : void {
         dispatchSimpleEvent(PlayerEvent as Class, type);
      }
      
      private function dispatchScientistsChangeEvent(): void {
         dispatchPlayerEvent(PlayerEvent.SCIENTISTS_CHANGE);
      }
      
      private function dispatchCredsChangeEvent(): void {
         dispatchPlayerEvent(PlayerEvent.CREDS_CHANGE);
      }
      
      private function dispatchPopulationCapChangeEvent() : void
      {
         dispatchPlayerEvent(PlayerEvent.POPULATION_CAP_CHANGE);
      }
      
      private function dispatchPopulationChangeEvent() : void
      {
         dispatchPlayerEvent(PlayerEvent.POPULATION_CHANGE);
      }
   }
}
