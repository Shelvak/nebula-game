package components.squadronsscreen
{
   import models.ModelLocator;
   import models.factories.PlayerFactory;
   import models.location.Location;
   import models.location.LocationType;
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
      [Bindable]
      public var owners: ArrayCollection;
      [Bindable]
      public var allyLocationObjects: ArrayCollection;
      [Bindable]
      public var playerLocationObjects: ArrayCollection;

      public function filterAllyUnits(locationType: int, location: Location,
              player: String): void
      {
         allyUnits.filterFunction = function(item: MPositionedUnits): Boolean
         {
            return (locationType == LocationType.ANY
                    || item.location.type == locationType)
            && (location == null || (item.location.type == location.type
                    && item.location.id == location.id))
            && (player == null || player == item.player.name);
         }
         allyUnits.refresh();
      }

      public function filterPlayerUnits(locationType: int, location: Location): void
      {
         playerUnits.filterFunction = function(item: MPositionedUnits): Boolean
         {
            return (locationType == LocationType.ANY
                    || item.location.type == locationType)
            && (location == null || (item.location.type == location.type
                    && item.location.id == location.id));
         }
         playerUnits.refresh();
      }
      
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
         createFilterLists();
      }
      
      private var players: Object;

      private function createFilterLists(): void
      {
         createOwners();
         createLocationObjects();
      }

      private function createOwners(): void
      {
         var _owners: Array = [];
         for each (var player: PlayerMinimal in players)
         {
            if (player.id != ModelLocator.getInstance().player.id)
            {
               _owners.push(player.name);
            }
         }
         owners = new ArrayCollection(_owners);
      }

      private function createLocationObjects(): void
      {
         function findDifferentLocations(units: ArrayCollection): ArrayCollection
         {
            var locations: Array = [];
            function notYetIncluded(location: Location): Boolean
            {
               for each (var currentLocation: Location in locations)
               {
                  if (currentLocation.isSolarSystem &&
                       currentLocation.id == location.id)
                  {
                     return false;
                  }
               }
               return true;
            }
            for each (var bunch: MPositionedUnits in units)
            {
               if (bunch.location.isSSObject)
               {
                  if (locations.indexOf(bunch.location) == -1)
                  {
                     locations.push(bunch.location);
                  }
               }
               else if (bunch.location.isSolarSystem)
               {
                  if (notYetIncluded(bunch.location))
                  {
                     locations.push(bunch.location);
                  }
               }
            }
            return new ArrayCollection(locations);
         }
         allyLocationObjects = findDifferentLocations(allyUnits);
         playerLocationObjects = findDifferentLocations(playerUnits);
      }

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