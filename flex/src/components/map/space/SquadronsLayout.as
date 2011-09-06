package components.map.space
{
   import components.movement.CSquadronMapIcon;
   
   import flash.geom.Point;
   
   import models.Owner;
   import models.location.LocationMinimal;
   import models.movement.MSquadron;
   
   import mx.collections.ArrayCollection;
   import mx.collections.ICollectionView;
   import mx.collections.Sort;
   import mx.core.IVisualElement;
   
   import utils.datastructures.Collections;
   
   
   public class SquadronsLayout
   {
      /**
       * Gap between adjecent <code>CSquadronMapIcon</code> components in pixels. 
       */
      internal static const GAP:int = 0;
      
      
      private var _grid:Grid,
                  _squadsController:SquadronsController;
      
      
      public function SquadronsLayout(squadsController:SquadronsController, grid:Grid)
      {
         _grid = grid;
         _squadsController = squadsController;
      }
      
      
      /**
       * Returns coordinates of the top-left corner of a free slot for the given squadron which could
       * placed there. This method assumes that all other squadrons in the same location have already been
       * positioned correctly, that is the first squad uccupies the first slot and there are no vacant slots
       * between them.
       */
      public function getFreeSlotCoords(squadM:MSquadron) : Point
      {
         var squads:ICollectionView = Collections.filter(
            getSquadsInLocation(squadM.currentHop.location, squadM),
            function(squadC:CSquadronMapIcon) : Boolean { return squadC.squadronOwner == squadM.owner }
         );
         return getSlotCoords(squadM.currentHop.location, squadM.owner, squads.length);
      }
      
      
      /**
       * Positions all squadrons on a map.
       */
      public function repositionAllSquadrons() : void
      {
         for each (var location:LocationMinimal in _grid.getAllSectors())
         {
            repositionSquadrons(location);
         }
      }
      
      
      /**
       * Repositions all squadrons in given location that belong to the given owner type or
       * all squadrons in that location if owner type has not been provided.
       */
      public function repositionSquadrons(location:LocationMinimal, owner:int = Owner.UNDEFINED) : void
      {
         var squads:ArrayCollection = getSquadsInLocation(location);
         for each (var ownerType:int in [Owner.PLAYER, Owner.ALLY, Owner.NAP, Owner.ENEMY])
         {
            if (ownerType == owner || owner == Owner.UNDEFINED)
            {
               squads.filterFunction = function(squadC:CSquadronMapIcon) : Boolean
               {
                  return squadC.squadronOwner == ownerType;
               };
               squads.sort = new Sort();
               squads.sort.compareFunction = function(squadA:CSquadronMapIcon,
                                                      squadB:CSquadronMapIcon,
                                                      fields:Array = null) : int
               {
                  if (!squadA.squadron.isMoving &&
                      !squadB.squadron.isMoving)
                  {
                     return 0;
                  }
                  if (!squadA.squadron.isMoving)
                  {
                     return -1;
                  }
                  if (!squadB.squadron.isMoving)
                  {
                     return 1;
                  }
                  return 0;
               }
               squads.refresh();
               var slot:int = 0;
               for each (var squad:CSquadronMapIcon in squads)
               {
                  var coords:Point = getSlotCoords(location, ownerType, slot);
                  squad.x = coords.x
                  squad.y = coords.y;
                  slot++;
               }
            }
         }
      }
      
      
      /**
       * Chooses between <code>getSlotCoordsEmpty()</code> and <code>getSlotCoordsStatic()</code>.
       */      
      private function getSlotCoords(loc:LocationMinimal, owner:int, slot:int) : Point
      {
         // NPC units align together with enemy units
         if (owner == Owner.UNDEFINED)
            owner = Owner.ENEMY;
         var obj:IVisualElement = _grid.getStaticObjectInSector(loc);
         return obj ?
            getSlotCoordsStatic(loc, owner, slot, obj) :
            getSlotCoordsEmpty(loc, owner, slot);
      }
      
      
      /**
       * #return coordinates of top-left corner of slot in an empty sector
       */
      private function getSlotCoordsEmpty(loc:LocationMinimal, owner:int, slot:int) : Point
      {
         slot++;
         // find logical corrdinates in the first quarter
         var diag:int = Math.ceil((Math.sqrt(1 + 8 * slot) - 1) / 2);
         var x:int = diag / 2 * (1 + diag) - slot;
         var y:int = x - diag;
         // transform logical coordinates to the quarter we need
         // taking into account the fact that we actually must calculate coordinates of top-left corner in the
         // next step (-1 for x and -1 for y) 
         if (owner == Owner.ENEMY || owner == Owner.ALLY) x = -x - 1;
         if (owner == Owner.ENEMY || owner == Owner.NAP)  y = -y - 1;
         // calculate real coordinates from the logical ones
         var coords:Point = _grid.getSectorRealCoordinates(loc);
         coords.x += CSquadronMapIcon.WIDTH  * x;
         coords.y += CSquadronMapIcon.HEIGHT * y;
         return coords;
      }
      
      
      /**
       * @return coordinates of top-left corner of slot in a sector where static object is
       */      
      private function getSlotCoordsStatic(loc:LocationMinimal, owner:int, slot:int, obj:IVisualElement) : Point
      {
         var sectorCoords:Point = _grid.getSectorRealCoordinates(loc);
         var w:Number = CSquadronMapIcon.WIDTH;
         var h:Number = CSquadronMapIcon.HEIGHT;
         var coords:Point = new Point(sectorCoords.x, sectorCoords.y);
         coords.y -= 2 * h + 1.5 * GAP;
         coords.y += owner * (h + GAP);
         coords.x = obj ? obj.getLayoutBoundsX() + obj.getLayoutBoundsWidth() : sectorCoords.x;
         coords.x += slot * (w + GAP);
         return coords;
      }
      
      
      private function getSquadsInLocation(location:LocationMinimal, exclude:MSquadron = null) : ArrayCollection
      {
         var squads:ArrayCollection = new ArrayCollection();
         squads.addAll(_squadsController.getCSquadronsIn(location));
         if (exclude)
         {
            var removeIdx:int = Collections.findFirstIndex(squads,
               function(squadC:CSquadronMapIcon) : Boolean
               {
                  return squadC.squadron.equals(exclude);
               }
            );
            if (removeIdx >= 0)
            {
               squads.removeItemAt(removeIdx);
            }
         }
         return squads;
      }
   }
}