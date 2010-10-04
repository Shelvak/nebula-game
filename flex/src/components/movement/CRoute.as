package components.movement
{
   import components.map.space.Grid;
   
   import flash.geom.Point;
   
   import interfaces.ICleanable;
   
   import models.location.LocationMinimal;
   import models.movement.MHop;
   import models.movement.MSquadron;
   import models.movement.events.MRouteEvent;
   import models.movement.events.MRouteEventChangeKind;
   import models.movement.events.MSquadronEvent;
   
   import mx.collections.ArrayCollection;
   import mx.graphics.SolidColorStroke;
   
   import spark.components.Group;
   import spark.primitives.Line;
   
   import utils.ClassUtil;
   
   
   public class CRoute extends Group implements ICleanable
   {
      private var _squadron:MSquadron;
      /**
       * Squadron travelling this route.
       */
      public function get squadron() : MSquadron
      {
         return _squadron;
      }
      
      
      private var _grid:Grid;
      
      
      /* ###################### */
      /* ### INITIALIZATION ### */
      /* ###################### */
      
      
      /**
       * Constructor.
       * 
       * @param model model of a squadron travelling along the route
       * @param grid reference to map grid (will be used for calculating positioning and sizing
       * component)
       */
      public function CRoute(squadron:MSquadron, grid:Grid)
      {
         super();
         ClassUtil.checkIfParamNotNull("squadron", squadron);
         ClassUtil.checkIfParamNotNull("grid", grid);
         left = right = top = bottom = 0;
         _squadron = squadron;
         _grid = grid;
         addModelEventHandlers(squadron);
         updateVisibility();
      }
      
      
      public function cleanup() : void
      {
         if (_squadron)
         {
            removeModelEventHandlers(_squadron);
            _squadron = null;
         }
      }
      
      
      /* ################ */
      /* ### CHILDREN ### */
      /* ################ */
      
      
      private var _hopLines:ArrayCollection;
      
      
      protected override function createChildren() : void
      {
         super.createChildren();
         _hopLines = new ArrayCollection();
         var start:MHop = _squadron.currentHop;
         for each (var end:MHop in _squadron.hops)
         {
            addHop();
            start = end;
         }
      }
      
      
      private function addHop() : void
      {
         var hop:Line = new Line();
         hop.stroke = new SolidColorStroke(0x00FF00, 2);
         _hopLines.addItem(hop);
         addElement(hop);
         invalidateDisplayList();
      }
      
      
      private function removeFirstHop() : void
      {
         removeElement(Line(_hopLines.removeItemAt(0)));
         invalidateDisplayList();
      }
      
      
      /* ############### */
      /* ### VISUALS ### */
      /* ############### */
      
      
      private function updateVisibility() : void
      {
         visible = _squadron.showRoute;
      }
      
      
      protected override function updateDisplayList(uw:Number, uh:Number) : void
      {
         super.updateDisplayList(uw, uh);
         
         if (_squadron)
         {
            var index:int = 0;
            var start:MHop = _squadron.currentHop;
            for each (var end:MHop in _squadron.hops)
            {
               var startCoords:Point = _grid.getSectorRealCoordinates(start.location);
               var endCoords:Point = _grid.getSectorRealCoordinates(end.location);
               var hop:Line = Line(_hopLines.getItemAt(index));
               hop.xFrom = startCoords.x;
               hop.yFrom = startCoords.y;
               hop.xTo = endCoords.x;
               hop.yTo = endCoords.y;
               start = end;
               index++;
            }
         }
      }
      
      
      /* ############################ */
      /* ### MODEL EVENT HANDLERS ### */
      /* ############################ */
      
      
      private function addModelEventHandlers(squad:MSquadron) : void
      {
         squad.addEventListener(MRouteEvent.CHANGE, model_routeChangeHandler);
         squad.addEventListener(MSquadronEvent.SHOW_ROUTE_CHANGE, model_showRouteChangeHandler);
      }
      
      
      private function removeModelEventHandlers(squad:MSquadron) : void
      {
         squad.removeEventListener(MRouteEvent.CHANGE, model_routeChangeHandler);
         squad.removeEventListener(MSquadronEvent.SHOW_ROUTE_CHANGE, model_showRouteChangeHandler);
      }
      
      
      private function model_routeChangeHandler(event:MRouteEvent) : void
      {
         if (event.kind == MRouteEventChangeKind.HOP_ADD)
         {
            addHop();
         }
         else
         {
            removeFirstHop();
         }
      }
      
      
      private function model_showRouteChangeHandler(event:MSquadronEvent) : void
      {
         updateVisibility();
      }
   }
}