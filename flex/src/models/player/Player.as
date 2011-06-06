package models.player
{
   import com.developmentarc.core.utils.EventBroker;
   
   import globalevents.GlobalEvent;
   
   import models.Reward;
   import models.alliance.MAlliance;
   import models.player.events.PlayerEvent;
   import models.solarsystem.MSSObject;
   
   import mx.collections.ArrayCollection;
   import mx.collections.Sort;
   import mx.utils.ObjectUtil;
   
   import utils.DateUtil;
   import utils.NumberUtil;
   import utils.datastructures.Collections;
   
   
   /**
    * @see models.player.events.PlayerEvent#CREDS_CHANGE
    */
   [Event(name="credsChange", type="models.player.events.PlayerEvent")]
   
   
   /**
    * @see models.player.events.PlayerEvent#SCIENTISTS_CHANGE
    */
   [Event(name="scientistsChange", type="models.player.events.PlayerEvent")]
   
   
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
      
      [Bindable]
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
      
      
      [Optional]
      /**
       * Id of alliance the player belongs to.
       */
      public var allianceId:int = 0;
      
      
      [Optional]
      public var allianceCooldownEndsAt: Date;
      
      
      /**
       * An alliance the player belongs to. This is not <code>null</code> only if <code>allianceId > 0</code>.
       */
      public function get alliance() : MAlliance
      {
         return ML.alliance;
      }
      
      
      /**
       * <code>true</code> if this player belongs to an alliance.
       */
      public function get belongsToAlliance() : Boolean
      {
         return allianceId > 0;
      }
      
      
      /**
       * Indicates if the player owns the alliance he/she belongs to.
       */
      public function get ownsAlliance() : Boolean
      {
         return alliance != null &&
                alliance.ownerId == id;
      }
      
      
      /**
       * Checks if a player with a given id can be invited to the alliance owned by the current player.
       * 
       * @param playerId id of a player.
       * 
       * @return <code>true</code> if a player can be invited to the alliance or <code>false</code> otherwise.
       */
      public function canInviteToAlliance(playerId:int) : Boolean
      {
         return ownsAlliance && Collections.findFirstWithId(alliance.players, playerId) == null;
      }
      
      
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
      
      private function dispatchScientistsChangeEvent(): void
      {
         dispatchSimpleEvent(PlayerEvent, PlayerEvent.SCIENTISTS_CHANGE);
      }
      
      private function dispatchCredsChangeEvent(): void
      {
         dispatchSimpleEvent(PlayerEvent, PlayerEvent.CREDS_CHANGE);
      }
   }
}