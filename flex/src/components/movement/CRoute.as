package components.movement
{
   import components.map.space.Grid;
   
   import flash.events.MouseEvent;
   import flash.geom.Point;
   
   import interfaces.ICleanable;
   
   import models.location.LocationMinimal;
   import models.movement.MHop;
   import models.movement.MSquadron;
   import models.movement.events.MRouteEvent;
   import models.movement.events.MRouteEventChangeKind;
   import models.movement.events.MSquadronEvent;
   
   import mx.collections.ArrayCollection;
   import mx.graphics.SolidColor;
   import mx.graphics.SolidColorStroke;
   
   import spark.components.Group;
   import spark.components.Label;
   import spark.primitives.Ellipse;
   import spark.primitives.Line;
   
   import utils.ClassUtil;
   import utils.DateUtil;
   
   
   [ResourceBundle("Movement")]
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
         addSelfEventHandlers();
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
      
      
      private var _hopLines:Vector.<Line>;
      private var _hopEndpoints:Vector.<Ellipse>;
      private var _hopEndpointInformation:Label;
      
      
      protected override function createChildren() : void
      {
         super.createChildren();
         _hopLines = new Vector.<Line>();
         _hopEndpoints = new Vector.<Ellipse>();
         var start:MHop = _squadron.currentHop;
         for each (var end:MHop in _squadron.hops)
         {
            addHop();
            start = end;
         }
         
         _hopEndpointInformation = new Label();
         _hopEndpointInformation.visible = false;
         _hopEndpointInformation.depth = Number.MAX_VALUE;
         addElement(_hopEndpointInformation);
      }
      
      
      private function addHop() : void
      {
         var hop:Line = new Line();
         hop.stroke = new SolidColorStroke(0x00FF00, 2);
         _hopLines.push(hop);
         addElement(hop);
         var endpoint:Ellipse = new Ellipse();
         endpoint.fill = new SolidColor(0x00FF00);
         endpoint.width = endpoint.height = 10;
         _hopEndpoints.push(endpoint)
         addElement(endpoint);
         invalidateDisplayList();
      }
      
      
      private function removeFirstHop() : void
      {
         removeElement(_hopLines.shift());
         removeElement(_hopEndpoints.shift());
         invalidateDisplayList();
      }
      
      
      /* ############### */
      /* ### VISUALS ### */
      /* ############### */
      
      
      private function updateVisibility() : void
      {
         mouseEnabled = mouseChildren = visible = _squadron.showRoute;
      }
      
      
      protected override function updateDisplayList(uw:Number, uh:Number) : void
      {
         super.updateDisplayList(uw, uh);
         
         if (_squadron)
         {
            var idx:int = 0;
            var start:MHop = _squadron.currentHop;
            for each (var end:MHop in _squadron.hops)
            {
               var startCoords:Point = _grid.getSectorRealCoordinates(start.location);
               var endCoords:Point = _grid.getSectorRealCoordinates(end.location);
               var hop:Line = _hopLines[idx];
               hop.xFrom = startCoords.x;
               hop.yFrom = startCoords.y;
               hop.xTo = endCoords.x;
               hop.yTo = endCoords.y;
               var endpoint:Ellipse = _hopEndpoints[idx];
               endpoint.x = endCoords.x - endpoint.width / 2;
               endpoint.y = endCoords.y - endpoint.height / 2;
               start = end;
               idx++;
            }
         }
      }
      
      
      private function updateEndpointInformation() : void
      {
         var idx:int = 0;
         for each (var endpoint:Ellipse in _hopEndpoints)
         {
            if (Math.abs(endpoint.x + endpoint.width / 2 - mouseX) < endpoint.width * 2 &&
                Math.abs(endpoint.y + endpoint.height / 2 - mouseY) < endpoint.height * 2)
            {
               var hop:MHop = MHop(_squadron.hops.getItemAt(idx));
               _hopEndpointInformation.text = resourceManager.getString(
                  "Movement", "label.arrivesIn",
                  [DateUtil.secondsToHumanString((hop.arrivesAt.time - new Date().time) / 1000)]
               );
               _hopEndpointInformation.visible = true;
               _hopEndpointInformation.x = endpoint.x;
               _hopEndpointInformation.y = endpoint.y;
               return;
            }
            idx++;
         }
         _hopEndpointInformation.visible = false;
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
      
      
      /* ########################### */
      /* ### SELF EVENT HANDLERS ### */
      /* ########################### */
      
      
      private function addSelfEventHandlers() : void
      {
         addEventListener(MouseEvent.MOUSE_MOVE, this_mouseMoveHandler);
      }
      
      
      private function this_mouseMoveHandler(event:MouseEvent) : void
      {
         updateEndpointInformation();
      }
   }
}