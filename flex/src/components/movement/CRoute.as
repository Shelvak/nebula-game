package components.movement
{
   import com.developmentarc.core.utils.EventBroker;
   
   import components.map.space.Grid;
   
   import flash.geom.Point;
   
   import globalevents.GlobalEvent;
   
   import interfaces.ICleanable;
   
   import models.ModelLocator;
   import models.OwnerColor;
   import models.location.Location;
   import models.location.LocationMinimal;
   import models.location.LocationMinimalSolarSystem;
   import models.movement.MHop;
   import models.movement.MSquadron;
   import models.movement.events.MRouteEvent;
   import models.movement.events.MRouteEventChangeKind;
   import models.solarsystem.SolarSystem;
   
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
         var hopInfo:CHopInfo = new CHopInfo();
         hopInfo.squadOwner = squadron.owner;
         _hopsEndpoints.push(hopInfo);
         addElement(hopInfo);
      }
      
      private function removeFirstHopEndpoint() : void {
         if (_hopsEndpoints.length > 1 || !squadron.jumpPending) {
            removeElement(_hopsEndpoints.shift());            
         }
      }
      
      private function updateHopsEndpoints() : void {
         var hop:MHop = null;
         var hopInfo:CHopInfo = null;
         var hopTime:String = "";
         var coords:Point = null;
         for each (hopInfo in _hopsEndpoints) {
            hopInfo.text = "";
         }
         for (var idx:int = 0; idx < _squadM.hops.length; idx++)  {
            hop = MHop(_squadM.hops.getItemAt(idx));
            hopInfo = _hopsEndpoints[idx];
            hopTime = getLabel("arrivesIn", [getEventInString(hop.arrivesAt.time)]);
            coords = _grid.getSectorRealCoordinates(hop.location);
            hopInfo.x = coords.x;
            hopInfo.y = coords.y;
            hopInfo.text = hopTime;
         }
         if (_hopsEndpoints.length > 0 && _squadM.jumpPending) {
            hop = _squadM.jumpHop;
            hopInfo = _hopsEndpoints[_hopsEndpoints.length - 1];
            hopTime = getEventInString(hop.jumpsAt.time);
            var loc:LocationMinimal = hop.location;
            var locWrap:LocationMinimalSolarSystem = new LocationMinimalSolarSystem(loc);
            var ss:SolarSystem = ModelLocator.getInstance().latestSolarSystem;
            if (loc.isGalaxy ||
                loc.isSolarSystem && ss.getSSObjectAt(locWrap.position, locWrap.angle).isJumpgate) {
               hopTime = getLabel("jumpsIn", [hopTime]);
            }
            else {
               hopTime = getLabel("landsIn", [hopTime]);
            }
            if (hopInfo.text.length > 0) {
               hopInfo.text += "\n" + hopTime
            }
            else {
               hopInfo.text = hopTime;
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
         if (_squadM != null) {
            updateHopsEndpoints();
         }
      }
      
      
      /* ############### */
      /* ### HELPERS ### */
      /* ############### */
      
      private function getEventInString(time:Number) : String {
         return DateUtil.secondsToHumanString(Math.max(0, (time - DateUtil.now) / 1000));
      }
      
      private function getLabel(property:String, parameters:Array = null) : String {
         return Localizer.string("Movement", "label." + property, parameters);
      }
   }
}