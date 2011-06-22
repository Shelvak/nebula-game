package models.alliance
{
   import models.factories.RatingsPlayerFactory;
   import models.player.MRatingPlayer;
   
   import mx.collections.ArrayCollection;

   public class MAlliance
   {
      [Bindable]
      public var ownerId: int;
      [Bindable]
      public var name: String;
      
      public var description: String;
      [Bindable]
      public var newDescription: String;
      [Bindable]
      public var players: ArrayCollection;
      
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
         totalAllianceVps = data.victoryPoints;
      }
   }
}