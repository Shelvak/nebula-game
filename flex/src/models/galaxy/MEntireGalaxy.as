package models.galaxy
{
   import components.map.space.galaxy.entiregalaxy.MiniSS;

   import models.location.LocationMinimal;
   import models.location.LocationType;

   import models.map.MapArea;

   import mx.collections.ArrayList;

   import utils.Objects;


   public class MEntireGalaxy
   {
      private var _fowMatrix: FOWMatrix;
      private var _solarSystems: Array;

      public function MEntireGalaxy(fowEntries: Vector.<MapArea>, solarSystems: Array) {
         Objects.paramNotNull("fowEntries", fowEntries);
         _solarSystems = Objects.paramNotNull("solarSystems", solarSystems);
         const locations:Array = solarSystems.map(
            function (ss: MiniSS, index: int, array: Array): LocationMinimal {
               return new LocationMinimal(LocationType.GALAXY, 1, ss.x, ss.y);
            });
         _fowMatrix = new FOWMatrix(1, fowEntries, locations, new ArrayList());
      }

      public function get fowMatrix(): FOWMatrix {
         return _fowMatrix;
      }

      public function get solarSystems(): Array {
         return _solarSystems;
      }
   }
}
