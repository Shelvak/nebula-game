package components.movement
{
   import components.map.space.Grid;
   import components.movement.events.CSquadronMapIconEvent;
   
   import flash.events.TimerEvent;
   import flash.geom.Point;
   
   import interfaces.ICleanable;
   
   import models.OwnerColor;
   import models.movement.MHop;
   import models.movement.MSquadron;
   import models.movement.events.MRouteEvent;
   import models.movement.events.MRouteEventChangeKind;
   
   import spark.components.Group;
   
   import utils.ClassUtil;
   import utils.DateUtil;
   import utils.Localizer;
   
   
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
         mouseEnabled = mouseChildren = visible = false;
         _squadC = squadC;
         _squadM = squadC.squadron;
         _grid = grid;
         addModelEventHandlers(_squadM);
         addCSquadronEventHandlers(squadC);
         addTimerEventHandlers();
      }
      
      
      public function cleanup() : void
      {
         removeTimerEventHandlers();
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
      
      
      private var _hopsEndpoints:Vector.<CHopInfo>;
      
      
      private function createHopEndpoint() : void
      {
         var hopInfo:CHopInfo = new CHopInfo();
         hopInfo.squadOwner = squadron.owner;
         _hopsEndpoints.push(hopInfo);
         addElement(hopInfo);
      }
      
      
      private function removeFirstHopEndpoint() : void
      {
         removeElement(_hopsEndpoints.shift());
      }
      
      
      private function updateHopsEndpoints() : void
      {
         for (var idx:int = 0; idx < _squadM.hops.length; idx++)
         {
            var hop:MHop = MHop(squadron.hops.getItemAt(idx));
            var hopInfo:CHopInfo = _hopsEndpoints[idx];
            hopInfo.text = Localizer.string(
               "Movement", "label.arrivesIn",
               [DateUtil.secondsToHumanString((hop.arrivesAt.time - new Date().time) / 1000)]
            );
            var coords:Point = _grid.getSectorRealCoordinates(hop.location);
            hopInfo.x = coords.x;
            hopInfo.y = coords.y;
         }
      }
      
      
      protected override function createChildren() : void
      {
         super.createChildren();
         _hopsEndpoints = new Vector.<CHopInfo>();
         for (var idx:int = 0; idx < _squadM.hops.length; idx++)
         {
            createHopEndpoint();
         }
         updateHopsEndpoints();
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
            graphics.lineStyle(2, OwnerColor.getColor(_squadM.owner), 1);
            for each (var end:MHop in _squadM.hops)
            {
               coords = _grid.getSectorRealCoordinates(end.location);
               graphics.lineTo(coords.x, coords.y);
            }
            updateHopsEndpoints();
         }
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
         if (event.kind == MRouteEventChangeKind.HOP_ADD)
         {
            createHopEndpoint();
         }
         else
         {
            removeFirstHopEndpoint();
         }
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
      
      
      private function addTimerEventHandlers() : void
      {
         CSquadronPopup.ARRIVES_IN_TIMER.addEventListener(TimerEvent.TIMER, arrivesInTimer_timerHandler);
      }
      
      
      private function removeTimerEventHandlers() : void
      {
         CSquadronPopup.ARRIVES_IN_TIMER.removeEventListener(TimerEvent.TIMER, arrivesInTimer_timerHandler);
      }
      
      
      private function arrivesInTimer_timerHandler(event:TimerEvent) : void
      {
         updateHopsEndpoints();
      }
   }
}