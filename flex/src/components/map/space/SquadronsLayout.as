package components.map.space
{
   import components.movement.CSquadronMapIcon;
   
   import flash.geom.Point;
   
   import models.Owner;
   import models.location.LocationMinimal;
   
   import mx.collections.ArrayCollection;
   import mx.collections.ICollectionView;
   import mx.core.IVisualElement;
   
   import namespaces.map_internal;
   
   import utils.datastructures.Collections;
   
   
   public class SquadronsLayout
   {
      /**
       * Gap between adjecent <code>CSquadronMapIcon</code> components in pixels. 
       */
      private static const GAP:int = 8;
      
      
      private var _grid:Grid,
                  _map:CMapSpace,
                  _squadsController:SquadronsController;
      
      
      public function SquadronsLayout(mapC:CMapSpace)
      {
         _squadsController = mapC.squadronsController;
         _grid = mapC.grid;
         _map = mapC;
      }
      
      
      /**
       * Returns coordinates of the top-left corner of a free slot for a next squadron (belonging
       * to the given owner type) which could placed there. 
       */
      public function getFreeSlotCoords(location:LocationMinimal, owner:int) : Point
      {
         var squads:ICollectionView = Collections.filter(
            getSquadsInLocation(location),
            function(squad:CSquadronMapIcon) : Boolean { return squad.squadronOwner == owner }
         );
         return getSlotCoords(location, owner, squads.length);
      }
      
      
      /**
       * Repositions all squadrons in given location that belong to the given owner type or
       * all squadrons in that location if owner type has not been provided.
       */
      public function repositionCSquadrons(location:LocationMinimal, owner:int = Owner.UNDEFINED) : void
      {
         var squads:ArrayCollection = getSquadsInLocation(location);
         for each (var ownerType:int in [Owner.PLAYER, Owner.ALLY, Owner.NAP, Owner.ENEMY])
         {
            if (ownerType == owner || owner == Owner.UNDEFINED)
            {
               squads.filterFunction = function(squad:CSquadronMapIcon) : Boolean
               {
                  return squad.squadronOwner == ownerType;
               };
               squads.refresh();
               var slot:int = 0;
               for each (var squad:CSquadronMapIcon in squads)
               {
                  var coords:Point = getSlotCoords(location, ownerType, slot);
                  squad.setLayoutBoundsPosition(coords.x, coords.y);
                  slot++;
               }
            }
         }
      }
      
      
      private function getSlotCoords(location:LocationMinimal, owner:int, slot:int) : Point
      {
         var obj:IVisualElement = _grid.getStaticObjectInSector(location);
         var sectorCoords:Point = _grid.getSectorRealCoordinates(location);
         var w:Number = CSquadronMapIcon.WIDTH;
         var coords:Point = new Point();
         coords.y = getRowOrdinate(sectorCoords, owner);
         coords.x = obj ? obj.getLayoutBoundsX(true) + obj.getLayoutBoundsWidth(true) : sectorCoords.x;
         coords.x += slot * (w + GAP);
         return coords;
      }
      
      
      private function getRowOrdinate(sectorCoords:Point, owner:int) : Number
      {
         var coords:Point = new Point(sectorCoords.x, sectorCoords.y);
         var h:Number = CSquadronMapIcon.HEIGHT;
         coords.y -= 2 * h + 1.5 * GAP;
         coords.y += owner * (h + GAP);
         return coords.y;
      }
      
      
      private function getSquadsInLocation(location:LocationMinimal) : ArrayCollection
      {
         return Collections.hashToCollection(_squadsController.getSquadronsByLocation(location), new ArrayCollection());
      }
   }
}