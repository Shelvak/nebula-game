package components.map.controllers
{
   import models.Owner;
   import models.location.LocationMinimal;
   import models.map.MMapSolarSystem;
   import models.movement.MSquadron;
   import models.solarsystem.MSSObject;

   import mx.core.ClassFactory;

   import mx.core.IFactory;

   import utils.Objects;


   public class SolarSystemSectorsProvider implements ISectorsProvider
   {
      private var _map:MMapSolarSystem;

      public function SolarSystemSectorsProvider(map:MMapSolarSystem) {
         _map = Objects.paramNotNull("map", map);
      }

      public function getSpaceSectors(): Array {
         const shipsHash:Object = new Object();
         var ships:SectorShipsOwners;
         var key:String;
         if (_map.squadrons != null) {
            for each (var squad: MSquadron in _map.squadrons) {
               key = squad.currentHop.location.hashKey();
               if (shipsHash[key] === undefined) {
                  shipsHash[key] =
                     new SectorShipsOwners(squad.currentHop.location);
               }
               ships = shipsHash[key];
               ships.owners[squad.owner] = true;
            }
         }
         const sectors:Array = new Array();
         for each (var object:MSSObject in _map.naturalObjects) {
            if (object.isJumpgate || object.isPlanet) {
               key = object.currentLocation.hashKey();
               ships = shipsHash[key];
               // so that we do not come across the same entry in the loop
               // afterwards
               delete shipsHash[key];
               sectors.push(getSector(object.currentLocation, ships, object));
            }
         }
         for each (ships in shipsHash) {
            sectors.push(getSector(ships.location, ships, null));
         }
         return sectors;
      }

      private function getSector(location:LocationMinimal,
                                 ships:SectorShipsOwners,
                                 object:MSSObject): Sector {
         var sectorShips:SectorShips = null;
         if (ships != null) {
            sectorShips = new SectorShips(
               ships.owners[Owner.PLAYER],
               ships.owners[Owner.ALLY],
               ships.owners[Owner.NAP],
               ships.owners[Owner.ENEMY],
               ships.owners[Owner.NPC]
            );
         }
         return new Sector(
            location,
            sectorShips,
            object,
            object != null ? object.owner : Owner.UNDEFINED
         );
      }

      public function includeSectorsWithShipsOf(owner: int): Boolean {
         return true;
      }

      public function itemRendererFunction(sector: Sector): IFactory {
         return new ClassFactory(IRSolarSystemSector);
      }
   }
}

import models.location.LocationMinimal;


internal class SectorShipsOwners
{
   public function SectorShipsOwners(location:LocationMinimal) {
      this.location = location;
   }
   
   public const owners:Object = new Object();
   public var location:LocationMinimal;
}
