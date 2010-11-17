package components.movement
{
   import components.map.space.Grid;
   import components.movement.events.CSquadronMapIconEvent;
   
   import flash.events.MouseEvent;
   import flash.geom.Point;
   
   import interfaces.ICleanable;
   
   import models.Owner;
   import models.movement.MHop;
   import models.movement.MSquadron;
   import models.movement.events.MRouteEvent;
   
   import spark.components.Group;
   
   import utils.ClassUtil;
   import utils.DateUtil;
   
   
   [ResourceBundle("Movement")]
   public class CRoute extends Group implements ICleanable
   {
      public function get squadron() : MSquadron
      {
         return _squadM;
      }
      
      
      private var _squadC:CSquadronMapIcon,
                  _squadM:MSquadron,
                  _grid:Grid;
      
      
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
      public function CRoute(squadC:CSquadronMapIcon, grid:Grid)
      {
         super();
         ClassUtil.checkIfParamNotNull("squadron", squadC);
         ClassUtil.checkIfParamNotNull("grid", grid);
         left = right = top = bottom = 0;
         visible = false;
         _squadC = squadC;
         _squadM = squadC.squadron;
         _grid = grid;
         addModelEventHandlers(_squadM);
         addCSquadronEventHandlers(squadC);
         addSelfEventHandlers();
      }
      
      
      public function cleanup() : void
      {
         if (_squadM)
         {
            removeModelEventHandlers(_squadM);
            _squadM = null;
         }
         if (_squadC)
         {
            removeCSquadronEventHandlers(_squadC);
            _squadC = null;
         }
      }
      
      
      /* ################## */
      /* ### PROPERTIES ### */
      /* ################## */
      
      
      public override function set visible(value:Boolean):void
      {
         if (super.visible != value)
         {
            super.visible = value;
            f_visibleChanged = true;
            invalidateProperties();
         }
      }
      
      
      private var f_visibleChanged:Boolean = true;
      
      
      protected override function commitProperties() : void
      {
         super.commitProperties();
         if (f_visibleChanged)
         {
            mouseEnabled = mouseChildren = visible;
         }
         f_visibleChanged = false;
      }
      
      
      /* ################ */
      /* ### CHILDREN ### */
      /* ################ */
      
      
      private var _hopInfo:CHopInfo;
      
      
      protected override function createChildren() : void
      {
         super.createChildren();
         _hopInfo = new CHopInfo();
         _hopInfo.visible = false;
         _hopInfo.depth = Number.MAX_VALUE;
         _hopInfo.squadOwner = _squadM.owner;
         addElement(_hopInfo);
      }
      
      
      /* ############### */
      /* ### VISUALS ### */
      /* ############### */
      
      
      protected override function updateDisplayList(uw:Number, uh:Number) : void
      {
         super.updateDisplayList(uw, uh);
         
         if (_squadM)
         {
            graphics.clear();
            var coords:Point;
            var start:MHop = _squadM.currentHop;
            if (start.location.equals(_squadC.locationActual) && _squadM.hasHopsRemaining)
            {
               graphics.moveTo(_squadC.x + _squadC.width / 2, _squadC.y + _squadC.height / 2);
            }
            else
            {
               coords = _grid.getSectorRealCoordinates(start.location);
               graphics.moveTo(coords.x, coords.y);
            }
            for each (var end:MHop in _squadM.hops)
            {
               coords = _grid.getSectorRealCoordinates(end.location);
               graphics.lineStyle(2, Owner.getColor(_squadM.owner), 1);
               graphics.lineTo(coords.x, coords.y);
               graphics.lineStyle(0, 0, 0);
               graphics.beginFill(0, 0);
               graphics.drawCircle(coords.x, coords.y, 40);
               graphics.endFill();
               graphics.moveTo(coords.x, coords.y);
            }
            updateEndpointInformation();
         }
      }
      
      
      private function updateEndpointInformation() : void
      {
         for each (var hop:MHop in _squadM.hops)
         {
            var coords:Point = _grid.getSectorRealCoordinates(hop.location);
            if (Math.abs(coords.x - mouseX) < 20 && Math.abs(coords.y - mouseY) < 20)
            {
               _hopInfo.text = resourceManager.getString(
                  "Movement", "label.arrivesIn",
                  [DateUtil.secondsToHumanString((hop.arrivesAt.time - new Date().time) / 1000)]
               );
               _hopInfo.x = coords.x;
               _hopInfo.y = coords.y;
               _hopInfo.visible = true;
               return;
            }
         }
         _hopInfo.visible = false;
      }
      
      
      /* ############################ */
      /* ### MODEL EVENT HANDLERS ### */
      /* ############################ */
      
      
      private function addModelEventHandlers(squad:MSquadron) : void
      {
         squad.addEventListener(MRouteEvent.CHANGE, model_routeChangeHandler);
      }
      
      
      private function removeModelEventHandlers(squad:MSquadron) : void
      {
         squad.removeEventListener(MRouteEvent.CHANGE, model_routeChangeHandler);
      }
      
      
      private function model_routeChangeHandler(event:MRouteEvent) : void
      {
         invalidateDisplayList();
      }
      
      
      /* ################################ */
      /* ### CSQUADRON EVENT HANDLERS ### */
      /* ################################ */
      
      
      private function addCSquadronEventHandlers(squadC:CSquadronMapIcon) : void
      {
         squadC.addEventListener(CSquadronMapIconEvent.LOCATION_ACTUAL_CHANGE, squadC_locationActualChangeHandler);
      }
      
      
      private function removeCSquadronEventHandlers(squadC:CSquadronMapIcon) : void
      {
         squadC.removeEventListener(CSquadronMapIconEvent.LOCATION_ACTUAL_CHANGE, squadC_locationActualChangeHandler);
      }
      
      
      private function squadC_locationActualChangeHandler(event:CSquadronMapIconEvent) : void
      {
         invalidateDisplayList();
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