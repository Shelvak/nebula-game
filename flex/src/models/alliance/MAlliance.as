package models.alliance
{
   import mx.collections.ArrayCollection;

   public class MAlliance
   {
      [Bindable]
      public var ownerId: int;
      [Bindable]
      public var name: String;
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
      public var totalPlanetsCount: int = 0;
      [Bindable]
      public var totalPoints: int = 0;
      public function MAlliance(data: Object)
      {
         name = data.name;
         ownerId = data.ownerId;
         players = new ArrayCollection(data.players);
      }
   }
}