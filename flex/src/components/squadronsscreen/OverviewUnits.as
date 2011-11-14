package components.squadronsscreen
{
   import components.unitsscreen.events.UnitsScreenEvent;

   import flash.events.EventDispatcher;

   import models.ModelLocator;
   import models.factories.PlayerFactory;
   import models.location.Location;
   import models.location.LocationType;
   import models.player.PlayerMinimal;
   import models.unit.MPositionedUnits;
   
   import mx.collections.ArrayCollection;
   import mx.collections.ListCollectionView;

   import utils.SingletonFactory;

   public class OverviewUnits extends EventDispatcher
   {
      public static function getInstance(): OverviewUnits
      {
         return SingletonFactory.getSingletonInstance(OverviewUnits);
      }

      public var sourcePlayerUnits: ArrayCollection;
      public var sourceAllyUnits: ArrayCollection;
      [Bindable]
      public var playerUnits: ListCollectionView;
      [Bindable]
      public var allyUnits: ListCollectionView;
      [Bindable]
      public var owners: ArrayCollection;
      [Bindable]
      public var allyLocationObjects: ArrayCollection;
      [Bindable]
      public var playerLocationObjects: ArrayCollection;

      public function filterAllyUnits(locationType: int, location: Object,
              player: PlayerMinimal): void
      {
         allyUnits.filterFunction = function(item: MPositionedUnits): Boolean
         {
            return (locationType == LocationType.ANY
                    || item.location.type == locationType)
            && (!(location is Location)
                    || (item.location.type == Location(location).type
                    && item.location.id == Location(location).id))
            && (player.name == "" || player.name == item.player.name);
         }
         allyUnits.refresh();
      }

      public function refreshAllyLocationObjects(locationType: int): void
      {
         allyLocationObjects = findDifferentLocations(sourceAllyUnits, locationType);
      }

      public function refreshPlayerLocationObjects(locationType: int): void
      {
         playerLocationObjects = findDifferentLocations(sourcePlayerUnits, locationType);
      }

      public function filterPlayerUnits(locationType: int, location: Object): void
      {
         playerUnits.filterFunction = function(item: MPositionedUnits): Boolean
         {
            return (locationType == LocationType.ANY
                    || item.location.type == locationType)
            && (!(location is Location)
                    || (item.location.type == Location(location).type
                    && item.location.id == Location(location).id));
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
         sourceAllyUnits = new ArrayCollection(_allyUnits);
         sourcePlayerUnits = new ArrayCollection(_playerUnits);
         playerUnits = new ListCollectionView(sourcePlayerUnits);
         allyUnits = new ListCollectionView(sourceAllyUnits);
         createFilterLists();
         dispatchScreenOpenEvent();
      }
      
      private var players: Object;

      private function createFilterLists(): void
      {
         createOwners();
         createLocationObjects();
         filterPlayerUnits(LocationType.ANY, 'any');
         filterAllyUnits(LocationType.ANY, 'any', new PlayerMinimal());
      }

      private function createOwners(): void
      {
         var _owners: Array = [];
         _owners.push(new PlayerMinimal());
         for each (var player: PlayerMinimal in players)
         {
            if (player.id != ModelLocator.getInstance().player.id)
            {
               _owners.push(player);
            }
         }
         owners = new ArrayCollection(_owners);
      }

      private function findDifferentLocations(
              units: ArrayCollection,
              locationType: int = LocationType.ANY): ArrayCollection
         {
            var locations: Array = [];
            //For "any" selection
            locations.push('any');
            function notYetIncluded(location: Location): Boolean
            {
               for each (var currentObject: Object in locations)
               {
                  if (currentObject is Location)
                  {
                     var currentLocation: Location = Location(currentObject);
                     if (currentLocation.type != LocationType.ANY &&
                             currentLocation.isSolarSystem &&
                          currentLocation.id == location.id)
                     {
                        return false;
                     }
                  }
               }
               return true;
            }
            for each (var bunch: MPositionedUnits in units)
            {
               if (bunch.location.isSSObject &&
                       (locationType == LocationType.SS_OBJECT
                               || locationType == LocationType.ANY))
               {
                  if (locations.indexOf(bunch.location) == -1)
                  {
                     locations.push(bunch.location);
                  }
               }
               else if (bunch.location.isSolarSystem &&
                       (locationType == LocationType.SOLAR_SYSTEM
                               || locationType == LocationType.ANY))
               {
                  if (notYetIncluded(bunch.location))
                  {
                     locations.push(bunch.location);
                  }
               }
            }
            return new ArrayCollection(locations);
         }

      private function createLocationObjects(): void
      {
         allyLocationObjects = findDifferentLocations(sourceAllyUnits);
         playerLocationObjects = findDifferentLocations(sourcePlayerUnits);
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

      private function dispatchScreenOpenEvent(): void
      {
         if (hasEventListener(UnitsScreenEvent.OVERVIEW_OPENED))
         {
            dispatchEvent(new UnitsScreenEvent(UnitsScreenEvent.OVERVIEW_OPENED));
         }
      }
      
   }
}