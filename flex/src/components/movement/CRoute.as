package components.movement
{
   import components.map.space.Grid;
   
   import flash.geom.Point;
   
   import interfaces.ICleanable;
   
   import models.OwnerColor;
   import models.events.BaseModelEvent;
   import models.movement.MHop;
   import models.movement.MSquadron;
   import models.movement.events.MRouteEvent;
   import models.movement.events.MRouteEventChangeKind;
   
   import spark.components.Group;
   
   import utils.Objects;
   import utils.locale.Localizer;
   
   
   public class CRoute extends Group implements ICleanable
   {
      public function get squadron() : MSquadron
      {
         return _squadM;
      }
      
      
      private var _squadC:CSquadronMapIcon;
      private var _squadM:MSquadron;
      private var _grid:Grid;
      
      
      /* ###################### */
      /* ### INITIALIZATION ### */
      /* ###################### */
      
      /**
       * @param model model of a squadron travelling along the route
       * @param grid reference to map grid (will be used for calculating positioning and sizing
       * component)
       */
      public function CRoute(squadC:CSquadronMapIcon, grid:Grid)
      {
         super();
         Objects.paramNotNull("squadron", squadC);
         Objects.paramNotNull("grid", grid);
         left = right = top = bottom = 0;
         mouseEnabled = mouseChildren = visible = false;
         _squadC = squadC;
         _squadM = squadC.squadron;
         _grid = grid;
         addModelEventHandlers(_squadM);
      }
      
      public function cleanup() : void {
         if (_squadM) {
            removeModelEventHandlers(_squadM);
            _squadM = null;
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
            invalidateDisplayList();
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
         var currentTime: Number = new Date().time;
         for (var idx:int = 0; idx < _squadM.hops.length; idx++)
         {
            var hop:MHop = MHop(squadron.hops.getItemAt(idx));
            var hopInfo:CHopInfo = _hopsEndpoints[idx];
            hopInfo.text = Localizer.string("Movement", "label.arrivesIn", [hop.arrivalEvent.occuresInString]);
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
         if (_squadM != null)
         {
            graphics.clear();
            var coords:Point;
            var start:MHop = _squadM.currentHop;
            if (start.location.equals(_squadC.currentLocation) && _squadM.hasHopsRemaining)
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
      
      private function addModelEventHandlers(squad:MSquadron) : void {
         squad.addEventListener(MRouteEvent.CHANGE, model_routeChangeHandler, false, 0, true);
         squad.addEventListener(BaseModelEvent.UPDATE, model_updateHandler, false, 0, true);
      }
      
      private function removeModelEventHandlers(squad:MSquadron) : void {
         squad.removeEventListener(MRouteEvent.CHANGE, model_routeChangeHandler, false);
         squad.removeEventListener(BaseModelEvent.UPDATE, model_updateHandler, false);
      }
      
      private function model_routeChangeHandler(event:MRouteEvent) : void {
         invalidateDisplayList();
         if (event.kind == MRouteEventChangeKind.HOP_ADD)
            createHopEndpoint();
         else
            removeFirstHopEndpoint();
      }
      
      private function model_updateHandler(event:BaseModelEvent) : void {
         updateHopsEndpoints();
      }
   }
}