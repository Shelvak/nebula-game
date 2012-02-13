package components.map.controllers
{
   import models.Owner;
   import models.galaxy.Galaxy;
   import models.location.LocationMinimal;
   import models.movement.MSquadron;
   import models.solarsystem.MSolarSystem;

   import mx.core.ClassFactory;
   import mx.core.IFactory;

   import utils.ArrayUtil;
   import utils.Objects;


   public class GalaxySectorsProvider implements ISectorsProvider
   {
      private var _map:Galaxy;

      public function GalaxySectorsProvider(map:Galaxy) {
         _map = Objects.paramNotNull("map", map);
      }

      public function sectorsCompareFunction(a: Sector,
                                             b: Sector,
                                             fields: Array = null): int {
         Objects.paramNotNull("a", a);
         Objects.paramNotNull("b", b);
         if (a.hasObject && !b.hasObject) return -1;
         if (!a.hasObject && b.hasObject) return +1;
         if (a.hasObject && b.hasObject) {
            if (!a.hasShips && b.hasShips) return -1;
            if (a.hasShips && !b.hasShips) return +1;
         }
         return WatchedObjects.compareLocations(a.location, b.location);
      }

      public function getSpaceSectors(): Array {
         var sectorsWithSolarSystems:Array = new Array();
         if (_map.solarSystems != null) {
            for each (var ss:MSolarSystem in _map.solarSystemsWithPlayer) {
               sectorsWithSolarSystems
                  .push(new Sector(ss.currentLocation, null, ss));
            }
         }
         var sectorsWithShips:Array = new Array();
         if (_map.squadrons != null) {
            var loc: LocationMinimal;
            const sectorsHash: Object = new Object();
            for each (var squad: MSquadron in _map.squadrons) {
               if (squad.owner == Owner.PLAYER) {
                  loc = squad.currentHop.location;
                  if (sectorsHash[loc.hashKey()] === undefined) {
                     sectorsHash[loc.hashKey()] = new Sector(
                        loc,
                        new SectorShips(true),
                        _map.getSSAt(loc.x, loc.y)
                     );
                  }
               }
            }
            sectorsWithShips = ArrayUtil.fromObject(sectorsHash);
         }
         return sectorsWithSolarSystems.concat(sectorsWithShips);
      }

      public function includeSectorsWithShipsOf(owner: int): Boolean {
         Objects.paramEquals("owner", owner, Owner.VALID_OWNER_TYPES);
         return owner == Owner.PLAYER;
      }

      public function itemRendererFunction(sector: Sector): IFactory {
         if (sector.hasShips) {
            return new ClassFactory(IRGalaxySectorWithShips);
         }
         return new ClassFactory(IRGalaxySectorWithSS);
      }
   }
}
