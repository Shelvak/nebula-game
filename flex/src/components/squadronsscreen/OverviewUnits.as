package components.squadronsscreen
{
   import models.ModelLocator;
   import models.factories.PlayerFactory;
   import models.player.PlayerMinimal;
   import models.unit.MPositionedUnits;
   
   import mx.collections.ArrayCollection;
   
   import utils.SingletonFactory;

   public class OverviewUnits
   {
      public static function getInstance(): OverviewUnits
      {
         return SingletonFactory.getSingletonInstance(OverviewUnits);
      }
      
      [Bindable]
      public var playerUnits: ArrayCollection;
      [Bindable]
      public var allyUnits: ArrayCollection;
      
      public function setData(data: Object, _players: Object): void
      {
         var _playerUnits: Array = [];
         var _allyUnits: Array = [];
         players = PlayerFactory.fromHash(_players);
         for (var playerId: String in data)
         {
            if (int(playerId) == ModelLocator.getInstance().player.id)
            {
               _playerUnits = createPlayerCachedUnits(data[playerId], playerId);
            }
            else
            {
               addAllyCachedUnits(_allyUnits, data[playerId], playerId);
            }
         }
         playerUnits = new ArrayCollection(_playerUnits);
         allyUnits = new ArrayCollection(_allyUnits);
      }
      
      private var players: Object;
      
      private function createPlayerCachedUnits(positions: Object, playerId: String): Array
      {
         var units: Array = [];
         addCachedUnits(units, positions, playerId);
         return units;
      }
      
      private function addAllyCachedUnits(units: Array, positions: Object, playerId: String): void
      {
         addCachedUnits(units, positions, playerId);
      }
      
      private function addCachedUnits(list: Array, positions: Object, playerId: String): void
      {
         for each (var position: Object in positions)
         {
            list.push(new MPositionedUnits(position.location, position.cachedUnits, 
               PlayerMinimal(players[playerId])));
         }
      }
      
   }
}