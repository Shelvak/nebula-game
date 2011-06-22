package models.player
{
   import com.developmentarc.core.utils.EventBroker;
   
   import config.Config;
   
   import globalevents.GlobalEvent;
   
   import models.Reward;
   import models.alliance.MAlliance;
   import models.player.events.PlayerEvent;
   import models.solarsystem.MSSObject;
   
   import mx.collections.ArrayCollection;
   import mx.collections.Sort;
   import mx.logging.Log;
   import mx.utils.ObjectUtil;
   
   import utils.DateUtil;
   import utils.NumberUtil;
   import utils.datastructures.Collections;
   
   
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
   
   
   [Bindable]
   public class Player extends PlayerMinimal
   {
      public function Player()
      {
         super();
         planets = new ArrayCollection();
         planets.sort = new Sort();
         planets.sort.compareFunction = compareFunction_planets;
         planets.refresh();
         EventBroker.subscribe(GlobalEvent.TIMED_UPDATE, timedUpdateHandler);
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
      public var vipCredsUntil: Date;
      public var vipCredsTime: String = null;
      
      [Optional]
      public var vipUntil: Date;
      public var vipTime: String = null;
      
      [Optional]
      public var population: int = 0;
      
      [Optional]
      public var populationMax: int = 0;
      
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
      
      
      
      private var _allianceId:int = 0;
      [Optional]
      [Bindable(event="allianceIdChange")]
      /**
       * Id of an alliance the player belongs to.
       */
      public function set allianceId(value:int) : void {
         if (_allianceId != value)
         {
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
      
      
      public function get hasAllianceTechnology() : Boolean {
         return maxAlliancePlayerCount > 0;
      }
      
      public function get maxAlliancePlayerCount() : int {
         return Config.getAllianceMaxPlayers(ML.technologies.getTechnologyByType('alliances').level);
      }
      
      // TODO: this also changes if maxAlliancePlayerCount changes
      [Bindable(event="alliancePlayerCountChange")]
      public function get allianceFull() : Boolean {
         return maxAlliancePlayerCount == alliancePlayerCount;
      }
      
      
      [Optional]
      public var allianceCooldownEndsAt: Date;
      
      
      public function get allianceCooldownInEffect() : Boolean
      {
         return allianceCooldownEndsAt != null &&
                allianceCooldownEndsAt.time > DateUtil.now;
      }
      
      
      public function get canJoinAlliance() : Boolean
      {
         return !belongsToAlliance && !allianceCooldownInEffect;
      }
      
      
      [Bindable(event="allianceIdChange")]
      /**
       * <code>true</code> if this player belongs to an alliance.
       */
      public function get belongsToAlliance() : Boolean
      {
         return allianceId > 0;
      }
      
      
      public function belongsTo(allianceId:int) : Boolean
      {
         return this.allianceId == allianceId;
      }
      
      
      public function ownsAlliance(allianceId:int) : Boolean
      {
         return belongsTo(allianceId) && allianceOwner;
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
         allianceId = 0;
         allianceCooldownEndsAt = null;
      }
      
      private function timedUpdateHandler(e: GlobalEvent): void
      {
         var cTime: Date = new Date();
         if (vipCredsUntil != null && vipCredsUntil.time > cTime.time)
         {
            vipCredsTime = 
               DateUtil.secondsToHumanString((vipCredsUntil.time - cTime.time)/1000, 2);
         }
         else
         {
            vipCredsTime = null;
         }
         if (vipUntil && vipUntil.time > cTime.time)
         {
            vipTime = DateUtil.secondsToHumanString((vipUntil.time - cTime.time)/1000, 2);
         }
         else
         {
            vipTime = null;
         }
      }
      
      public override function toString() : String
      {
         return "[class: " + className + ", id: " + id + ", name: " + name + "]";
      }
      
      /* ############### */
      /* ### HELPERS ### */
      /* ############### */
      
      
      private function dispatchPlayerEvent(type:String) : void {
         dispatchSimpleEvent(PlayerEvent, type);
      }
      
      private function dispatchScientistsChangeEvent(): void {
         dispatchPlayerEvent(PlayerEvent.SCIENTISTS_CHANGE);
      }
      
      private function dispatchCredsChangeEvent(): void {
         dispatchPlayerEvent(PlayerEvent.CREDS_CHANGE);
      }
   }
}