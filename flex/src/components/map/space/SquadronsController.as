package components.map.space
{
   import components.movement.CRoute;
   import components.movement.CSquadronMapIcon;
   
   import controllers.units.OrdersController;
   import controllers.units.events.OrdersControllerEvent;
   
   import flash.geom.Point;
   
   import interfaces.ICleanable;
   
   import models.events.BaseModelEvent;
   import models.location.LocationMinimal;
   import models.map.MMap;
   import models.map.events.MMapEvent;
   import models.movement.MSquadron;
   import models.movement.events.MSquadronEvent;
   import models.unit.Unit;
   
   import mx.collections.ArrayCollection;
   import mx.collections.IList;
   import mx.collections.ListCollectionView;
   import mx.events.EffectEvent;
   import mx.logging.ILogger;
   import mx.logging.Log;
   
   import spark.components.Group;
   import spark.effects.Fade;
   import spark.effects.Move;
   import spark.primitives.BitmapImage;
   
   import utils.Objects;
   import utils.components.DisplayListUtil;
   import utils.datastructures.Collections;
   
   
   public class SquadronsController implements ICleanable
   {
      private static const SQUAD_FADE_EFFECT_DURATION:int = 500;  // milliseconds
      public  static const MOVE_EFFECT_DURATION:int = 500;        // milliseconds

      private function get ORDERS_CTRL(): OrdersController {
         return OrdersController.getInstance();
      }

      private function get logger(): ILogger {
         return Log.getLogger(Objects.getClassName(this, true));
      }

      private var _mapM: MMap;
      private var _mapC: CMapSpace;
      private var _layout: SquadronsLayout;
      private var _grid: Grid;
      private var _squadronsContainer: Group;
      private var _routesContainer: Group;
      
      
      /* ###################### */
      /* ### INITIALIZATION ### */
      /* ###################### */

      public function SquadronsController(mapC: CMapSpace) {
         _mapC = mapC;
         _mapM = MMap(mapC.model);
         _grid = mapC.grid;
         _squadronsContainer = mapC.squadronObjectsCont;
         _routesContainer = mapC.routeObjectsCont;
         _layout = new SquadronsLayout(this, _grid);
         addMapModelEventHandlers(_mapM);
         addOrdersControllerEventHandlers();
         for each (var squadM: MSquadron in _mapM.squadrons) {
            createSquadron(squadM, false);
         }
      }

      public function cleanup(): void {
         if (_mapM != null) {
            for each (var squadM: MSquadron in _mapM.squadrons) {
               destroySquadron(squadM, false);
            }
            removeMapModelEventHandlers(_mapM);
            _mapM = null;
         }
         removeOrdersControllerEventHandlers();
      }

      public function repositionAllSquadrons(): void {
         _layout.repositionAllSquadrons();
         if (_selectedSquadC) {
            selectSquadron(_selectedSquadC);
         }
      }

      public function repositionAllSquadronsIn(location: LocationMinimal): void {
         _layout.repositionSquadrons(location);
         if (_selectedSquadC) {
            selectSquadron(_selectedSquadC);
         }
      }
      
      
      /* ######################## */
      /* ### COMPONENTS LISTS ### */
      /* ######################## */

      private var _squads: ArrayCollection = new ArrayCollection();
      private var _routes: ArrayCollection = new ArrayCollection();
      
      private function getFilterByModel(squadM:MSquadron) : Function {
         return function(component:*) : Boolean { return squadM.equals(component.squadron) };
      }
      private function getFilterByLocation(loc:LocationMinimal) : Function {
         return function(squadC:CSquadronMapIcon) : Boolean { return squadC.currentLocation.equals(loc) };
      }

      private function getCRoute(squadM: MSquadron): CRoute {
         const routeC: IList = filter(_routes, getFilterByModel(squadM));
         if (routeC.length > 0) {
            return CRoute(routeC.getItemAt(0));
         }
         return null;
      }

      private function getCSquadron(squadM: MSquadron): CSquadronMapIcon {
         return CSquadronMapIcon(
            filter(_squads, getFilterByModel(squadM)).getItemAt(0)
         );
      }

      internal function getCSquadronsIn(location: LocationMinimal): ListCollectionView {
         return filter(_squads, getFilterByLocation(location));
      }
      
      
      /* ##################################### */
      /* ### SQUADS CREATION / DESTRUCTION ### */
      /* ##################################### */

      private function createSquadron(squadM: MSquadron,
                                      useFadeEffect: Boolean = true): void {
         addSquadronEventHandlers(squadM);

         const coords: Point = _layout.getFreeSlotCoords(squadM);
         const squadC: CSquadronMapIcon = new CSquadronMapIcon();
         squadC.squadron = squadM;
         squadC.move(coords.x, coords.y);
         _squads.addItem(squadC);
         _squadronsContainer.addElement(squadC);

         if (squadM.isMoving) {
            const routeC: CRoute = new CRoute(squadC, _grid);
            _routes.addItem(routeC);
            _routesContainer.addElement(routeC);
         }

         if (!_mapM.flag_destructionPending && useFadeEffect) {
            const fadeIn: Fade = new Fade(squadC);
            fadeIn.duration = SQUAD_FADE_EFFECT_DURATION;
            fadeIn.alphaFrom = 0;
            fadeIn.alphaTo = 1;
            fadeIn.play();
         }
      }


      private function destroySquadron(squadM: MSquadron,
                                       useFadeEffect: Boolean = true): void {
         removeSquadronEventHandlers(squadM);

         if (squadM.isMoving) {
            const routeC: CRoute = getCRoute(squadM);
            _routesContainer.removeElement(routeC);
            removeItem(_routes, routeC);
            routeC.cleanup();
         }

         const squadC: CSquadronMapIcon = getCSquadron(squadM);
         squadC.endEffectsStarted();

         // don't wait until an effect (if used) finishes: remove squad component form the list at once
         // so that it is not found during the next lookup
         removeItem(_squads, squadC);

         if (_selectedSquadC == squadC) {
            deselectSelectedSquadron();
         }
         if (_commandedSquadC == squadC) {
            setCommandedSquad(null);
         }
         if (!_mapM.flag_destructionPending && useFadeEffect) {
            const fadeOut: Fade = new Fade(squadC);
            fadeOut.duration = SQUAD_FADE_EFFECT_DURATION;
            fadeOut.alphaFrom = 1;
            fadeOut.alphaTo = 0;
            fadeOut.addEventListener(
               EffectEvent.EFFECT_END, squadC_fadeOut_effectEndHandler
            );
            fadeOut.play();
            return;
         }
         _squadronsContainer.removeElement(squadC);
         _layout.repositionSquadrons(
            squadC.currentLocation, squadC.squadronOwner
         );
         squadC.cleanup();
      }

      private function squadC_fadeOut_effectEndHandler(event: EffectEvent): void {
         var squadC: CSquadronMapIcon = CSquadronMapIcon(Fade(event.target).target);
         _squadronsContainer.removeElement(squadC);
         _layout.repositionSquadrons(
            squadC.currentLocation, squadC.squadronOwner
         );
         squadC.cleanup();
      }
      
      
      /* ################ */
      /* ### MOVEMENT ### */
      /* ################ */

      private function moveSquadron(squadM: MSquadron,
                                    from: LocationMinimal,
                                    to: LocationMinimal): void {
         // reposition squadrons in the old location
         _layout.repositionSquadrons(from, squadM.owner);
         const squadC: CSquadronMapIcon = getCSquadron(squadM);
         squadC.endEffectsStarted();
         const coordsTo: Point = _layout.getFreeSlotCoords(squadM);
         const effect: Move = new Move(squadC);
         effect.duration = MOVE_EFFECT_DURATION;
         effect.xTo = coordsTo.x;
         effect.yTo = coordsTo.y;
         squadM.pending = true;
         function effectEndHandler(event: EffectEvent): void {
            effect.removeEventListener(EffectEvent.EFFECT_END, effectEndHandler);
            // and fix position because the one we calculated in the beginning
            // of the effect might now be obsolete
            _layout.repositionSquadrons(to, squadM.owner);
            // and fix position of squadrons popup if the squad we moved is the one which is selected
            if (_selectedSquadC && _selectedSquadC.currentLocation
                                      .equals(squadM.currentHop.location)) {
               selectSquadron(_selectedSquadC);
            }
            squadM.pending = false;
         }

         effect.addEventListener(EffectEvent.EFFECT_END, effectEndHandler);
         effect.play();
      }
      
      
      /* ################# */
      /* ### SELECTION ### */
      /* ################# */


      private var _selectedSquadC: CSquadronMapIcon;
      private var _commandedSquadC: CSquadronMapIcon;
      private var _selectedRouteC: CRoute;

      private function setCommandedSquad(value: CSquadronMapIcon): void {
         if (_commandedSquadC != value) {
            if (_commandedSquadC != null) {
               _commandedSquadC.commanded = false;
            }
            _commandedSquadC = value;
            if (_commandedSquadC != null) {
               _commandedSquadC.commanded = true;
            }
         }
      }
      
      private function selectSquadWithUnits(units:IList) : void {
         const unit: Unit = Unit(units.getItemAt(0));
         if (_mapM.squadrons == null) {
            logger.warn(
               "selectSquadWithUnits(): Map model {0} most likely has been "
               + "cleaned up and _mapM.squadrons is null. Unable to select units:"
               + "\n   {1}"
               + "\nReturning",
               _mapM, units.toArray().join("   \n")
            );
            return;
         }
         if (!_mapM.definesLocation(unit.location)) {
            return;
         }
         const squad: MSquadron = Collections.findFirst(
            _mapM.squadrons,
            function (squad: MSquadron): Boolean {
               if (squad.units.length == 0) {
                  logger.warn(
                     "selectSquadWithUnits()=> Collections.findFirst(=> testFunction):"
                        + "\n   Squad {0} has most likely been cleaned up and has no units."
                        + "\n   Assuming the squad should not be selected.",
                     squad
                  );
                  return false;
               }
               return Collections.findFirstEqualTo(squad.units, unit) != null;
            }
         );
         selectSquadron(getCSquadron(squad));
      }

      internal function selectSquadron(squadC: CSquadronMapIcon): void {
         deselectSelectedSquadron();
         _mapC.squadronsInfo.move(
            squadC.x + squadC.width / 2,
            squadC.y + squadC.height / 2
         );
         _mapC.squadronsInfo.squadron = squadC.squadron;
         _selectedSquadC = squadC;
         _selectedSquadC.selected = true;
         _selectedRouteC = getCRoute(squadC.squadron);
         if (_selectedRouteC) {
            _selectedRouteC.visible = true;
         }
      }

      internal function deselectSelectedSquadron(): void {
         if (_selectedSquadC != null) {
            _mapC.squadronsInfo.squadron = null;
            _selectedSquadC.selected = false;
            _selectedSquadC = null;
            if (_selectedRouteC != null) {
               _selectedRouteC.visible = false;
               _selectedRouteC = null;
            }
         }
      }
      
      
      /* ################################################## */
      /* ### ORDER SOURCE LOCATION INDICATOR MANAGEMENT ### */
      /* ################################################## */
      
      
      /**
       * Updates (positions, hides/shows) order source location indicator.
       */
      public function updateOrderSourceLocIndicator(): void {
         var indicator: BitmapImage = _mapC.orderSourceLocIndicator;
         if (ORDERS_CTRL.issuingOrders
                && (_mapM.definesLocation(ORDERS_CTRL.locationSourceGalaxy)
                       || _mapM.definesLocation(ORDERS_CTRL.locationSourceSolarSystem))) {
            var coords: Point;
            if (_mapM.definesLocation(ORDERS_CTRL.locationSourceGalaxy)) {
               coords = _grid.getSectorRealCoordinates(
                  ORDERS_CTRL.locationSourceGalaxy
               );
            }
            else {
               coords = _grid.getSectorRealCoordinates(
                  ORDERS_CTRL.locationSourceSolarSystem
               );
            }
            indicator.visible = true;
            indicator.x = coords.x - indicator.width / 2;
            indicator.y = coords.y - indicator.height / 2;
         }
         else {
            indicator.visible = false;
            _mapC.passivateTargetLocationPopup();
            _mapC.passivateSpeedControlPopup();
         }
      }
      
      
      /* ######################################## */
      /* ### ORDERS CONTROLLER EVENT HANDLERS ### */
      /* ######################################## */

      private function addOrdersControllerEventHandlers(): void {
         ORDERS_CTRL.addEventListener(
            OrdersControllerEvent.ISSUING_ORDERS_CHANGE,
            ordersCtrl_issuingOrdersChangeHandler
         );
         ORDERS_CTRL.addEventListener(
            OrdersControllerEvent.LOCATION_SOURCE_CHANGE,
            ordersCtrl_locationSourceChangeHandler
         );
      }

      private function removeOrdersControllerEventHandlers(): void {
         ORDERS_CTRL.removeEventListener(
            OrdersControllerEvent.ISSUING_ORDERS_CHANGE,
            ordersCtrl_issuingOrdersChangeHandler
         );
         ORDERS_CTRL.removeEventListener(
            OrdersControllerEvent.LOCATION_SOURCE_CHANGE,
            ordersCtrl_locationSourceChangeHandler
         );
      }

      private function ordersCtrl_locationSourceChangeHandler(event: OrdersControllerEvent): void {
         updateOrderSourceLocIndicator();
      }

      private function ordersCtrl_issuingOrdersChangeHandler(event: OrdersControllerEvent): void {
         if (ORDERS_CTRL.issuingOrders) {
            setCommandedSquad(_selectedSquadC);
            deselectSelectedSquadron();
         }
         else {
            if (ORDERS_CTRL.units != null && ORDERS_CTRL.units.length > 0) {
               selectSquadWithUnits(ORDERS_CTRL.units);
               setCommandedSquad(null);
            }
         }
         updateOrderSourceLocIndicator();
      }
      
      
      /* ################################ */
      /* ### MAP MODEL EVENT HANDLERS ### */
      /* ################################ */

      private function addMapModelEventHandlers(mapM: MMap): void {
         mapM.addEventListener(
            MMapEvent.SQUADRON_ENTER, mapM_squadronEnterHandler
         );
         mapM.addEventListener(
            MMapEvent.SQUADRON_LEAVE, mapM_squadronLeaveHandler
         );
         mapM.addEventListener(
            BaseModelEvent.FLAG_DESTRUCTION_PENDING_SET,
            mapM_destructionPendingSetHandler
         );
      }

      private function removeMapModelEventHandlers(mapM: MMap): void {
         mapM.removeEventListener(
            MMapEvent.SQUADRON_ENTER, mapM_squadronEnterHandler
         );
         mapM.removeEventListener(
            MMapEvent.SQUADRON_LEAVE, mapM_squadronLeaveHandler
         );
         mapM.removeEventListener(
            BaseModelEvent.FLAG_DESTRUCTION_PENDING_SET,
            mapM_destructionPendingSetHandler
         );
      }

      private function mapM_squadronEnterHandler(event: MMapEvent): void {
         createSquadron(event.squadron);
      }

      private function mapM_squadronLeaveHandler(event: MMapEvent): void {
         destroySquadron(event.squadron);
      }

      private function mapM_destructionPendingSetHandler(event: BaseModelEvent): void {
         for each (var squadC: CSquadronMapIcon
            in DisplayListUtil.getChildren(_squadronsContainer)) {
            squadC.endEffectsStarted();
         }
      }
      
      
      /* ##################################### */
      /* ### SQUADRON MODEL EVENT HANDLERS ### */
      /* ##################################### */

      private function addSquadronEventHandlers(squadM: MSquadron): void {
         squadM.addEventListener(MSquadronEvent.MOVE, squadron_moveHandler);
      }

      private function removeSquadronEventHandlers(squadM: MSquadron): void {
         squadM.removeEventListener(MSquadronEvent.MOVE, squadron_moveHandler);
      }

      private function squadron_moveHandler(event: MSquadronEvent): void {
         moveSquadron(event.squadron, event.moveFrom, event.moveTo);
      }
      
      
      /* ############### */
      /* ### HELPERS ### */
      /* ############### */

      private function filter(list: IList,
                              filterFunction: Function): ListCollectionView {
         return Collections.filter(list, filterFunction);
      }

      private function removeItem(list: IList, item: Object): Object {
         return list.removeItemAt(list.getItemIndex(item));
      }
   }
}