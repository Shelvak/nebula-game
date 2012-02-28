package components.movement
{
   import components.map.space.Grid;

   import flash.geom.Point;

   import interfaces.ICleanable;

   import models.ModelLocator;
   import models.OwnerColor;
   import models.events.BaseModelEvent;
   import models.location.LocationMinimal;
   import models.map.MMapSolarSystem;
   import models.movement.MHop;
   import models.movement.MSquadron;
   import models.movement.events.MRouteEvent;
   import models.movement.events.MRouteEventChangeKind;

   import spark.components.Group;

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
       * @param squadC model of a squadron travelling along the route
       * @param grid reference to map grid (will be used for calculating
       * positioning and sizing component)
       */
      public function CRoute(squadC:CSquadronMapIcon, grid:Grid) {
         super();
         left = right = top = bottom = 0;
         mouseEnabled = mouseChildren = visible = false;
         _squadC = Objects.paramNotNull("squadron", squadC);
         _grid = Objects.paramNotNull("grid", grid);
         _squadM = squadC.squadron;
         addModelEventHandlers(_squadM);
      }
      
      public function cleanup() : void {
         if (_squadM != null) {
            removeModelEventHandlers(_squadM);
            _squadM = null;
         }
      }
      
      
      /* ################## */
      /* ### PROPERTIES ### */
      /* ################## */

      public override function set visible(value: Boolean): void {
         if (super.visible != value) {
            super.visible = value;
            f_visibleChanged = true;
            invalidateProperties();
            invalidateDisplayList();
         }
      }

      private var f_visibleChanged: Boolean = true;

      protected override function commitProperties(): void {
         super.commitProperties();
         if (f_visibleChanged) {
            mouseEnabled = mouseChildren = visible;
         }
         f_visibleChanged = false;
      }
      
      
      /* ################ */
      /* ### CHILDREN ### */
      /* ################ */

      private var _hopsEndpoints: Vector.<CHopInfo>;

      private function createHopEndpoint(): void {
         var hopInfo: CHopInfo = new CHopInfo();
         hopInfo.squadOwner = squadron.owner;
         hopInfo.arrivesInLabelText = getLabel("arrivesIn");
         _hopsEndpoints.push(hopInfo);
         addElement(hopInfo);
      }

      private function removeFirstHopEndpoint(): void {
         if (_hopsEndpoints.length > 1 || !squadron.jumpPending) {
            removeElement(_hopsEndpoints.shift());
         }
      }
      
      private function updateHopsEndpoints() : void {
         var hop:MHop = null;
         var hopInfo:CHopInfo = null;
         var coords:Point = null;
         for each (hopInfo in _hopsEndpoints) {
            hopInfo.arrivesInValueText = null;
            hopInfo.arrivesInVisible = false;
            hopInfo.jumpsInValueText = null;
            hopInfo.jumpsInVisible = false;
         }
         for (var idx: int = 0; idx < _squadM.hops.length; idx++) {
            hop = MHop(_squadM.hops.getItemAt(idx));
            coords = _grid.getSectorRealCoordinates(hop.location);
            hopInfo = _hopsEndpoints[idx];
            hopInfo.arrivesInValueText = hop.arrivalEvent.occuresInString;
            hopInfo.arrivesInVisible = true;
            hopInfo.x = coords.x;
            hopInfo.y = coords.y;
         }
         if (_hopsEndpoints.length > 0
                && _squadM.jumpPending
                && (_squadM.isFriendly || !_squadM.hasHopsRemaining)) {
            const loc: LocationMinimal = _squadM.hasHopsRemaining
                                            ? _squadM.lastHop.location
                                            : _squadM.currentHop.location;
            if (loc.isSolarSystem) {
               const ss: MMapSolarSystem = ModelLocator.getInstance().latestSSMap;
            }
            hopInfo = _hopsEndpoints[_hopsEndpoints.length - 1];
            hopInfo.jumpsInVisible = true;
            hopInfo.jumpsInLabelText = getLabel(
               loc.isSolarSystem && ss.getSSObjectAt(loc.x, loc.y).isPlanet
                  ? "landsIn"
                  : "jumpsIn"
            );
            coords = _grid.getSectorRealCoordinates(loc);
            hopInfo.jumpsInValueText = _squadM.jumpsAtEvent.occuresInString;
            hopInfo.x = coords.x;
            hopInfo.y = coords.y;
         }
//         if (_hopsEndpoints.length > 0
//             && _squadM.jumpPending
//             && (_squadM.isFriendly || !_squadM.hasHopsRemaining)) {
//            hopInfo = _hopsEndpoints[_hopsEndpoints.length - 1];
//            var loc:LocationMinimal = _squadM.hasHopsRemaining ?
//               _squadM.lastHop.location :
//               _squadM.currentHop.location;
//            var locWrap:LocationMinimalSolarSystem =
//               new LocationMinimalSolarSystem(loc);
//
//            var showJumpsAt:Boolean = false;
//            if (loc.isGalaxy) {
//               var galaxy:Galaxy = ModelLocator.getInstance().latestGalaxy;
//               showJumpsAt = galaxy.getSSAt(loc.x, loc.y) != null;
//            }
//            else if (loc.isSolarSystem) {
//               var ss:MMapSolarSystem = ModelLocator.getInstance().latestSSMap;
//               var sso:MSSObject = ss.getSSObjectAt(
//                  locWrap.position,
//                  locWrap.angle
//               );
//               showJumpsAt = sso != null && (sso.isPlanet || sso.isJumpgate);
//            }
//
//            hopInfo.jumpsInVisible = showJumpsAt;
//            if (showJumpsAt) {
//               hopInfo.jumpsInLabelText =
//                  getLabel(
//                     loc.isSolarSystem
//                        && ss.getSSObjectAt(locWrap.position,
//                                            locWrap.angle).isPlanet
//                        ? "landsIn"
//                        : "jumpsIn"
//                  );
//               coords = _grid.getSectorRealCoordinates(loc);
//               hopInfo.jumpsInValueText = _squadM.jumpsAtEvent.occuresInString;
//               hopInfo.x = coords.x;
//               hopInfo.y = coords.y;
//            }
//         }
      }
      
      protected override function createChildren() : void {
         super.createChildren();
         var hop:MHop = null;
         _hopsEndpoints = new Vector.<CHopInfo>();
         for each (hop in _squadM.hops) {
            createHopEndpoint();
         }
         if (_hopsEndpoints.length == 0 && _squadM.jumpPending) {
            createHopEndpoint();
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
      
      private function addModelEventHandlers(squad: MSquadron): void {
         squad.addEventListener(
            MRouteEvent.CHANGE, model_routeChangeHandler,
            false, 0, true
         );
         squad.addEventListener(
            MRouteEvent.JUMPS_AT_CHANGE,
            model_jumpsAtChangeHandler, false, 0, true
         );
         squad.addEventListener(
            BaseModelEvent.UPDATE, model_updateHandler,
            false, 0, true
         );
      }
      
      private function removeModelEventHandlers(squad:MSquadron) : void {
         squad.removeEventListener(
            MRouteEvent.CHANGE, model_routeChangeHandler, false
         );
         squad.removeEventListener(
            MRouteEvent.JUMPS_AT_CHANGE, model_jumpsAtChangeHandler, false
         );
         squad.removeEventListener(
            BaseModelEvent.UPDATE, model_updateHandler, false
         );
      }
      
      private function model_routeChangeHandler(event:MRouteEvent) : void {
         if (event.kind == MRouteEventChangeKind.HOP_ADD) {
            createHopEndpoint();
         }
         else {
            removeFirstHopEndpoint();
         }
         invalidateDisplayList();
      }

      private function model_updateHandler(event:BaseModelEvent) : void {
         updateHopsEndpoints();
      }
      
      private function model_jumpsAtChangeHandler(e: MRouteEvent) : void {
         invalidateDisplayList();
      }
      
      
      /* ############### */
      /* ### HELPERS ### */
      /* ############### */
      
      private function getLabel(property:String) : String {
         return Localizer.string("Movement", "label.hop." + property);
      }
   }
}