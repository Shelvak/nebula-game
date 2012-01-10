package models.alliance
{
   import config.Config;

   import flash.events.EventDispatcher;

   import models.alliance.events.MAllianceEvent;
   import models.factories.RatingsPlayerFactory;
   import models.player.MRatingPlayer;
   import models.technology.Technology;

   import mx.collections.ArrayCollection;

   import utils.Events;
   import utils.datastructures.Collections;


   [Event(name="ownerChange", type="models.alliance.events.MAllianceEvent")]

   public class MAlliance extends EventDispatcher
   {
      public static function technologyLevelRequiredForPlayers(numPlayers:int): int {
         const maxLevel:int = Config.getTechnologyMaxLevel(Technology.ALLIANCE);
         for (var level:int = 1; level <= maxLevel; level++) {
            if (numPlayers <= Config.getAllianceMaxPlayers(level)) {
               return level;
            }
         }
         throw new ArgumentError(
            "Alliance technology can only support up to "
               + Config.getAllianceMaxPlayers(maxLevel) + " players but [param "
               + "numPlayers] was " + numPlayers
         );
         return 0;   // unreachable
      }

      private var _ownerId: int;
      [Bindable(event="ownerChange")]
      public function set ownerId(value: int): void {
         if (_ownerId != value) {
            _ownerId = value;
            Events.dispatchSimpleEvent(
               this,
               MAllianceEvent,
               MAllianceEvent.OWNER_CHANGE
            );
         }
      }
      public function get ownerId(): int {
         return _ownerId;
      }

      [Bindable(event="ownerChange")]
      public function get owner(): MRatingPlayer {
         return Collections.findFirstWithId(players, ownerId);
      }

      [Bindable]
      public var name: String;
      
      public var description: String;
      [Bindable]
      public var newDescription: String;
      [Bindable]
      public var players: ArrayCollection;
      [Bindable]
      public var invPlayers: ArrayCollection;
      
      [Bindable]
      public var totalWarPoints: int = 0;
      [Bindable]
      public var totalEconomyPoints: int = 0;
      [Bindable]
      public var totalArmyPoints: int = 0;
      [Bindable]
      public var totalSciencePoints: int = 0;
      [Bindable]
      public var totalVictoryPoints: int = 0;
      [Bindable]
      public var totalAllianceVps: int = 0;
      [Bindable]
      public var totalPlanetsCount: int = 0;
      [Bindable]
      public var totalBgPlanetsCount: int = 0;
      [Bindable]
      public var totalPoints: int = 0;
      [Bindable]
      public var id: int = 0;
      
      public function getPlayerName(playerId: int): String
      {
         for each (var player: MRatingPlayer in players)
         {
            if (player.id == playerId)
            {
               return player.name;
            }
         }
         throw new Error ('Alliance player with id: ' + playerId + ' not found!');
      }
      public function MAlliance(data: Object)
      {
         name = data.name;
         description = data.description;
         newDescription = description;
         ownerId = data.ownerId;
         id = data.id;
         players = RatingsPlayerFactory.fromObjects(data.players);
         if (data.invitablePlayers != null)
         {
            invPlayers = RatingsPlayerFactory.fromObjects(data.invitablePlayers);
         }
         totalAllianceVps = data.victoryPoints;
      }
   }
}