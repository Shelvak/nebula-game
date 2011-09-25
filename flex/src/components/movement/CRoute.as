package components.movement
{
   import com.developmentarc.core.utils.EventBroker;
   
   import components.map.space.Grid;
   
   import flash.geom.Point;
   
   import globalevents.GlobalEvent;
   
   import interfaces.ICleanable;
   
   import models.OwnerColor;
   import models.movement.MHop;
   import models.movement.MSquadron;
   import models.movement.events.MRouteEvent;
   import models.movement.events.MRouteEventChangeKind;
   
   import spark.components.Group;
   
   import utils.DateUtil;
   import utils.Objects;
   import utils.locale.Localizer;
   
   
   public class CRoute extends Group implements ICleanable
   {
      public function get squadron() : MSquadron {
         return _squadM;
      }
      
      
      private var _squadC:CSquadronMapIcon;
      private var _squadM:MSquadron;
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
      public function CRoute(squadC:CSquadronMapIcon, grid:Grid) {
         super();
         left = right = top = bottom = 0;
         mouseEnabled = mouseChildren = visible = false;
         _squadC = Objects.paramNotNull("squadron", squadC);
         _grid = Objects.paramNotNull("grid", grid);
         _squadM = squadC.squadron;
         addModelEventHandlers(_squadM);
         addGlobalEventHandlers();
      }
      
      public function cleanup() : void {
         removeGlobalEventHandlers();
         if (_squadM != null) {
            removeModelEventHandlers(_squadM);
            _squadM = null;
         }
      }
      
      
      /* ################## */
      /* ### PROPERTIES ### */
      /* ################## */
      
      
      public override function set visible(value:Boolean):void {
         if (super.visible != value) {
            super.visible = value;
            f_visibleChanged = true;
            invalidateProperties();
            invalidateDisplayList();
         }
      }
      
      
      private var f_visibleChanged:Boolean = true;
      
      
      protected override function commitProperties() : void {
         super.commitProperties();
         if (f_visibleChanged)
            mouseEnabled = mouseChildren = visible;
         f_visibleChanged = false;
      }
      
      
      /* ################ */
      /* ### CHILDREN ### */
      /* ################ */
      
      private var _hopsEndpoints:Vector.<CHopInfo>;
      
      private function createHopEndpoint(newHop:MHop) : void {
         if (!_grid.definesLocation(newHop.location))
            return;
         var hopInfo:CHopInfo = new CHopInfo();
         hopInfo.squadOwner = squadron.owner;
         _hopsEndpoints.push(hopInfo);
         addElement(hopInfo);
      }
      
      private function removeFirstHopEndpoint() : void {
         if (_hopsEndpoints.length > 0)
            removeElement(_hopsEndpoints.shift());
      }
      
      private function updateHopsEndpoints() : void {
         var hopTime:String = null;
         var hop:MHop = null;
         var hopInfo:CHopInfo = null;
         var coords:Point = null;
         for each (hopInfo in _hopsEndpoints) {
            hopInfo.text = "";
         }
         for (var idx:int = 0; idx < _squadM.hops.length; idx++)  {
            hop = MHop(_squadM.hops.getItemAt(idx));
            hopTime = DateUtil.secondsToHumanString((hop.arrivesAt.time - DateUtil.now) / 1000);
            if (_grid.definesLocation(hop.location)) {
               hopInfo = _hopsEndpoints[idx];
               hopTime = getLabel("arrivesIn", [hopTime]);
            }
            else {
               hopInfo = _hopsEndpoints[idx > 0 ? idx - 1 : idx];
               if (hop.location.isSSObject)
                  hopTime = getLabel("landsIn", [hopTime]);
               else
                  hopTime = getLabel("jumpsIn", [hopTime]);
            }
            if (hopInfo.text.length == 0)
               hopInfo.text = hopTime;
            else
               hopInfo.text += "\n" + hopTime;
            if (!_grid.definesLocation(hop.location)) {
               if (idx == 0)
                  hop = _squadM.currentHop;
               else
                  hop = MHop(_squadM.hops.getItemAt(idx - 1));
            }
            coords = _grid.getSectorRealCoordinates(hop.location);
            hopInfo.x = coords.x;
            hopInfo.y = coords.y;
         }
      }
      
      protected override function createChildren() : void {
         super.createChildren();
         _hopsEndpoints = new Vector.<CHopInfo>();
         for each (var hop:MHop in _squadM.hops) {
            createHopEndpoint(hop);
         }
         updateHopsEndpoints();
      }
      
      
      /* ############### */
      /* ### VISUALS ### */
      /* ############### */
      
      protected override function updateDisplayList(uw:Number, uh:Number) : void {
         super.updateDisplayList(uw, uh);
         if (_squadM != null) {
            graphics.clear();
            var coords:Point;
            var start:MHop = _squadM.currentHop;
            if (start.location.equals(_squadC.currentLocation) && _squadM.hasHopsRemaining)
               graphics.moveTo(_squadC.x + _squadC.width / 2, _squadC.y + _squadC.height / 2);
            else {
               coords = _grid.getSectorRealCoordinates(start.location);
               graphics.moveTo(coords.x, coords.y);
            }
            graphics.lineStyle(2, OwnerColor.getColor(_squadM.owner), 1);
            for each (var end:MHop in _squadM.hops) {
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
         squad.addEventListener(MRouteEvent.CHANGE, model_routeChangeHandler);
      }
      
      private function removeModelEventHandlers(squad:MSquadron) : void {
         squad.removeEventListener(MRouteEvent.CHANGE, model_routeChangeHandler);
      }
      
      private function model_routeChangeHandler(event:MRouteEvent) : void {
         if (event.kind == MRouteEventChangeKind.HOP_ADD)
            createHopEndpoint(event.hop);
         else
            removeFirstHopEndpoint();
         invalidateDisplayList();
      }
      
      
      /* ############################# */
      /* ### GLOBAL EVENT HANDLERS ### */
      /* ############################# */
      
      private function addGlobalEventHandlers() : void {
         EventBroker.subscribe(GlobalEvent.TIMED_UPDATE, global_timedUpdateHandler);
      }
      
      private function removeGlobalEventHandlers() : void {
         EventBroker.unsubscribe(GlobalEvent.TIMED_UPDATE, global_timedUpdateHandler);
      }     
      
      private function global_timedUpdateHandler(event:GlobalEvent) : void {
         updateHopsEndpoints();
      }
      
      
      /* ############### */
      /* ### HELPERS ### */
      /* ############### */
      
      private function getLabel(property:String, parameters:Array = null) : String {
         return Localizer.string("Movement", "label." + property, parameters);
      }
   }
}