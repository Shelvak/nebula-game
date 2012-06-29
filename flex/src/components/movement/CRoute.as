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
   import models.solarsystem.MSSObject;

   import spark.components.Group;

   import utils.Objects;
   import utils.locale.Localizer;
   import utils.logging.Log;


   public class CRoute extends Group implements ICleanable
   {
      private var _grid: Grid;

      public function CRoute(grid: Grid) {
         super();
         left = 0;
         right = 0;
         top = 0;
         bottom = 0;
         mouseEnabled = false;
         mouseChildren = false;
         visible = false;
         _grid = Objects.paramNotNull("grid", grid);
      }

      public function cleanup() : void {
         setSquad(null);
      }


      /* ################## */
      /* ### PROPERTIES ### */
      /* ################## */

      private var _squadC: CSquadronMapIcon;
      public function setSquad(squadC: CSquadronMapIcon): void {
         if (_squadC != null) {
            removeModelEventHandlers(_squadM);
            _squadM = null;
         }
         _squadC = squadC;
         if (_squadC != null) {
            _squadM = _squadC.squadron;
            addModelEventHandlers(_squadM);
         }
         visible = _squadC != null;
         f_squadChanged = true;
         invalidateProperties();
         invalidateDisplayList();
      }

      private var _squadM: MSquadron;
      public function get squadron(): MSquadron {
         return _squadM;
      }

      private var f_squadChanged: Boolean = true;
      private var f_squadUpdated: Boolean = true;

      protected override function commitProperties(): void {
         super.commitProperties();
         if (f_squadChanged) {
            removeAllHopEndpoints();
            if (_squadM != null) {
               createHopEndpoints();
            }
         }
         if (f_squadChanged || f_squadUpdated) {
            if (_squadM != null) {
               updateHopsEndpoints();
            }
         }
         f_squadChanged = false;
         f_squadUpdated = false;
      }


      /* ############ */
      /* ### HOPS ### */
      /* ############ */

      private const _hopsEndpoints: Array = new Array();

      private function removeAllHopEndpoints(): void {
         while (_hopsEndpoints.length > 0) {
            removeElement(_hopsEndpoints.pop());
         }
      }

      private function removeFirstHopEndpoint(): void {
         if (_hopsEndpoints.length > 1 || !_squadM.jumpPending) {
            removeElement(_hopsEndpoints.shift());
         }
      }

      private function createHopEndpoints(): void {
         for each (var hop: MHop in _squadM.hops) {
            createHopEndpoint();
         }
         if (_hopsEndpoints.length == 0 && _squadM.jumpPending) {
            createHopEndpoint();
         }
      }

      private function createHopEndpoint(): void {
         const hopInfo: CHopInfo = new CHopInfo();
         hopInfo.squadOwner = _squadM.owner;
         hopInfo.arrivesInLabelText = getLabel("arrivesIn");
         _hopsEndpoints.push(hopInfo);
         addElement(hopInfo);
      }

      private function updateHopsEndpoints() : void {
         var hop: MHop = null;
         var hopInfo: CHopInfo = null;
         var coords: Point = null;
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
            hopInfo.arrivesInValueText = hop.arrivalEvent.occursInString();
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
            coords = _grid.getSectorRealCoordinates(loc);
            hopInfo = _hopsEndpoints[_hopsEndpoints.length - 1];
            hopInfo.x = coords.x;
            hopInfo.y = coords.y;
            if (loc.isSolarSystem) {
               const ss: MMapSolarSystem = ModelLocator.getInstance().latestSSMap;
               const ssObject: MSSObject = ss.getSSObjectAt(loc.x, loc.y);
               // TODO: Not a real fix for 0001221. Find out whats going on here!
               if (ssObject == null) {
                  Log.getMethodLogger(this, "updateHopsEndpoints").error(
                     "Unable to set landsAt label for hop at {0}. "
                        + "There is no planet at that location!"
                        + "\n solarSystem: {1}", loc, ss
                  );
                  return;
               }
            }
            hopInfo.jumpsInVisible = true;
            hopInfo.jumpsInValueText = _squadM.jumpsAtEvent.occursInString();
            hopInfo.jumpsInLabelText = getLabel(
               loc.isSolarSystem && ssObject.isPlanet
                  ? "landsIn"
                  : "jumpsIn"
            );
         }
      }
      
      
      /* ############### */
      /* ### VISUALS ### */
      /* ############### */

      protected override function updateDisplayList(uw:Number, uh:Number) : void {
         super.updateDisplayList(uw, uh);
         if (_squadM != null) {
            graphics.clear();
            const start: MHop = _squadM.currentHop;
            var coords: Point;
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
         f_squadUpdated = true;
         invalidateProperties();
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