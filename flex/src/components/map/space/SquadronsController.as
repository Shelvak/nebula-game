package components.map.space
{
   import components.movement.COrderSourceLocationIndicator;
   import components.movement.CRoute;
   import components.movement.CSquadronMapIcon;
   
   import controllers.units.OrdersController;
   import controllers.units.events.OrdersControllerEvent;
   
   import flash.geom.Point;
   
   import interfaces.ICleanable;
   
   import models.location.LocationMinimal;
   import models.map.Map;
   import models.map.MapType;
   import models.map.events.MapEvent;
   import models.movement.MSquadron;
   import models.movement.events.MSquadronEvent;
   
   import mx.events.EffectEvent;
   
   import spark.components.Group;
   import spark.effects.Move;

   public class SquadronsController implements ICleanable
   {
      public static const MOVE_EFFECT_DURATION:int = 500;   // Milliseconds
      
      
      private var ORDERS_CTRL:OrdersController = OrdersController.getInstance();
      
      
      private var _mapM:Map,
                  _mapC:CMapSpace,
                  _layout:SquadronsLayout,
                  _grid:Grid,
                  _squadronsContainer:Group,
                  _routesContainer:Group;
      
      
      /* ###################### */
      /* ### INITIALIZATION ### */
      /* ###################### */
      
      
      public function SquadronsController(mapC:CMapSpace)
      {
         _mapC = mapC;
         _mapM = Map(mapC.model);
         _grid = mapC.grid;
         _squadronsContainer = mapC.squadronObjectsCont;
         _routesContainer = mapC.routeObjectsCont;
         _layout = new SquadronsLayout(this, _grid);
         addMapEventHandlers(_mapM);
         addOrdersControllerEventHandlers();
         for each (var squadM:MSquadron in _mapM.squadrons)
         {
            createSquadron(squadM);
         }
      }
      
      
      public function cleanup() : void
      {
         if (_mapM)
         {
            for each (var squadM:MSquadron in _mapM.squadrons)
            {
               destroySquadron(squadM);
            }
            removeMapEventHandlers(_mapM);
            _mapM = null;
         }
         if (ORDERS_CTRL)
         {
            removeOrdersCrontrollerEventHandlers();
            ORDERS_CTRL = null;
         }
      }
      
      
      public function repositionAllSquadrons() : void
      {
         _layout.repositionAllSquadrons();
      }
      
      
      /* ######################### */
      /* ### COMPONENTS HASHES ### */
      /* ######################### */
      
      
      /**
       * Hash of <code>CSquadronMapIcon</code> static (not beeing moved by any effects) components
       * where key is <code>component.model.currentLocation.hashKey()</code> and value is a hash of
       * components where key is the <code>component.model.hashKey()</code>.
       */
      private var _squadsHash:Object = new Object();
      
      
      private function addSquadToHash(squadC:CSquadronMapIcon, loc:LocationMinimal = null) : void
      {
         var squadM:MSquadron = squadC.squadron;
         if (!loc)
         {
            loc = squadM.currentHop.location;
         }
         var keyLocation:String = loc.hashKey();
         var hashBySquad:Object = _squadsHash[keyLocation];
         if (!hashBySquad)
         {
            hashBySquad = new Object();
            _squadsHash[keyLocation] = hashBySquad;
         }
         hashBySquad[squadM.hashKey()] = squadC;
      }
      
      
      private function removeSquadFromHash(squadM:MSquadron, loc:LocationMinimal = null) : void
      {
         if (!loc)
         {
            loc = squadM.currentHop.location;
         }
         delete _squadsHash[loc.hashKey()][squadM.hashKey()];
      }
      
      
      /**
       * Hash of <code>CRoute</code> components where key is <code>component.model.hashKey()</code>
       * and <code>component.model.currentLocation.hashKey()</code>.
       */
      private var _routesHash:Object = new Object();
      
      
      private function addRouteToHash(routeC:CRoute) : void
      {
         _routesHash[routeC.squadron.hashKey()] = routeC;
      }
      
      
      private function removeRouteFromHash(squadM:MSquadron) : void
      {
         delete _routesHash[squadM.hashKey()]
      }
      
      
      /* ##################################### */
      /* ### SQUADS CREATION / DESTRUCTION ### */
      /* ##################################### */
      
      
      private function createSquadron(squadM:MSquadron) : void
      {
         addSquadronEventHandlers(squadM);
         
         if (squadM.isMoving)
         {
            var routeC:CRoute = new CRoute(squadM, _grid);
            addRouteToHash(routeC);
            _routesContainer.addElement(routeC);
         }
         
         var coords:Point = _layout.getFreeSlotCoords(squadM.currentHop.location, squadM.owner);
         var squadC:CSquadronMapIcon = new CSquadronMapIcon();
         squadC.squadron = squadM;
         squadC.move(coords.x, coords.y);
         addSquadToHash(squadC);
         _squadronsContainer.addElement(squadC);
      }
      
      
      private function destroySquadron(squadM:MSquadron) : void
      {
         removeSquadronEventHandlers(squadM);
         
         if (squadM.isMoving)
         {
            var routeC:CRoute = getRoute(squadM);
            removeRouteFromHash(squadM);
            _routesContainer.removeElement(routeC);
            routeC.cleanup();
         }
         
         var squadC:CSquadronMapIcon = getSquadron(squadM);
         squadC.endEffectsStarted();
         removeSquadFromHash(squadM);
         if (_selectedSquadC == squadC)
         {
            deselectSelectedSquadron();
         }
         _squadronsContainer.removeElement(squadC);
         squadC.cleanup();
      }
      
      
      /* ################ */
      /* ### MOVEMENT ### */
      /* ################ */
      
      
      private function moveSquadron(squadM:MSquadron, from:LocationMinimal, to:LocationMinimal) : void
      {         
         var squadC:CSquadronMapIcon = getSquadron(squadM, from);
         // while beeing moved, squadron is considered to be in both - from and to - locations
         addSquadToHash(squadC, to);
         
         var coordsTo:Point = _layout.getFreeSlotCoords(to, squadM.owner);
         var effect:Move = new Move(squadC);
         effect.duration = MOVE_EFFECT_DURATION;
         effect.xTo = coordsTo.x;
         effect.yTo = coordsTo.y;
         function effectEndHandler(event:EffectEvent) : void
         {
            effect.removeEventListener(EffectEvent.EFFECT_END, effectEndHandler);
            // when squadron has been moved, it is now only in to location
            removeSquadFromHash(squadM, from);
            // reposition squadrons in the old location
            _layout.repositionSquadrons(from, squadM.owner);
            // and fix position because the one we calculated in the beggining of the effect
            // might now be obsolete
            _layout.repositionSquadrons(to, squadM.owner);
            // and fix position of squadrons popup if the squad we moved is the one which is selected
            if (_selectedSquadC == squadC)
            {
               selectSquadron(squadC);
            }
         }
         effect.addEventListener(EffectEvent.EFFECT_END, effectEndHandler);
         effect.play();
      }
      
      
      /* ################# */
      /* ### SELECTION ### */
      /* ################# */
      
      
      private var _selectedSquadC:CSquadronMapIcon;
      private var _selectedRouteC:CRoute;
      
      
      internal function selectSquadron(squadC:CSquadronMapIcon) : void
      {
         // only update position of the popup if the given squad is already selected
         _mapC.squadronsInfo.move(
            squadC.getLayoutBoundsX(true) + squadC.getLayoutBoundsWidth(true) / 2,
            squadC.getLayoutBoundsY(true) + squadC.getLayoutBoundsHeight(true) / 2
         );
         if (_selectedSquadC != squadC)
         {
            deselectSelectedSquadron();
            _mapC.squadronsInfo.squadron = squadC.squadron;
            _selectedSquadC = squadC;
            _selectedSquadC.selected = true;
            _selectedRouteC = getRoute(squadC.squadron);
            if (_selectedRouteC)
            {
               _selectedRouteC.visible = true;
            }
         }
      }
      
      
      internal function deselectSelectedSquadron() : void
      {
         if (_selectedSquadC)
         {
            _mapC.squadronsInfo.squadron = null;
            _selectedSquadC.selected = false;
            _selectedSquadC = null;
            if (_selectedRouteC)
            {
               _selectedRouteC.visible = false;
               _selectedRouteC = null;
            }
         }
      }
      
      
      /* ######################### */
      /* ### COMPONENTS LOOKUP ### */
      /* ######################### */
      
      
      private function getRoute(squadM:MSquadron) : CRoute
      {
         return _routesHash[squadM.hashKey()];
      }
      
      
      /**
       * @return A hash of squadrons (where key is <code>location.hashKey()</code>) in the given
       * location. Squadrons that are beeing moved between two hops are in both locations at the
       * same time.
       */
      internal function getSquadronsIn(location:LocationMinimal) : Object
      {
         return _squadsHash[location.hashKey()];
      }
      
      
      internal function getSquadron(squadM:MSquadron, location:LocationMinimal = null) : CSquadronMapIcon
      {
         if (!location)
         {
            location = squadM.currentHop.location;
         }
         var hashByIDs:Object = getSquadronsIn(location);
         return hashByIDs ? hashByIDs[squadM.hashKey()] : null;
      }
      
      
      internal function getSquadronStationary(location:LocationMinimal, owner:int) : CSquadronMapIcon
      {
         var squad:MSquadron = new MSquadron();
         squad.id = 0;
         squad.owner = owner;
         return getSquadron(squad, location);
      }
      
      
      /* ################################################## */
      /* ### ORDER SOURCE LOCATION INDICATOR MANAGEMENT ### */
      /* ################################################## */
      
      
      private function updateOrderSourceLocIndicator() : void
      {
         var indicator:COrderSourceLocationIndicator = _mapC.orderSourceLocIndicator;
         var locSource:LocationMinimal = ORDERS_CTRL.locationSource;
         if (locSource && ORDERS_CTRL.issuingOrders && _mapM.definesDeepLocation(locSource))
         {
            var coords:Point = _grid.getSectorRealCoordinates(_mapM.getLocalLocation(locSource));
            indicator.visible = true;
            indicator.x = coords.x - indicator.width / 2;
            indicator.y = coords.y - indicator.height / 2;
         }
         else
         {
            indicator.visible = false;
         }
      }
      
      
      /* ######################################## */
      /* ### ORDERS CONTROLLER EVENT HANDLERS ### */
      /* ######################################## */
      
      
      private function addOrdersControllerEventHandlers() : void
      {
         ORDERS_CTRL.addEventListener(OrdersControllerEvent.ISSUING_ORDERS_CHANGE, ordersCtrl_changeHandler);
         ORDERS_CTRL.addEventListener(OrdersControllerEvent.LOCATION_SOURCE_CHANGE, ordersCtrl_changeHandler);
      }
      
      
      private function removeOrdersCrontrollerEventHandlers() : void
      {
         ORDERS_CTRL.removeEventListener(OrdersControllerEvent.ISSUING_ORDERS_CHANGE, ordersCtrl_changeHandler);
         ORDERS_CTRL.removeEventListener(OrdersControllerEvent.LOCATION_SOURCE_CHANGE, ordersCtrl_changeHandler);
      }
      
      
      private function ordersCtrl_changeHandler(event:OrdersControllerEvent) : void
      {
         updateOrderSourceLocIndicator();
      }
      
      
      /* ################################ */
      /* ### MAP MODEL EVENT HANDLERS ### */
      /* ################################ */
      
      
      private function addMapEventHandlers(mapM:Map) : void
      {
         mapM.addEventListener(MapEvent.SQUADRON_ENTER, map_squadronEnterHandler);
         mapM.addEventListener(MapEvent.SQUADRON_LEAVE, map_squadronLeaveHandler);
      }
      
      
      private function removeMapEventHandlers(mapM:Map) : void
      {
         mapM.removeEventListener(MapEvent.SQUADRON_ENTER, map_squadronEnterHandler);
         mapM.removeEventListener(MapEvent.SQUADRON_LEAVE, map_squadronLeaveHandler);
      }
      
      
      private function map_squadronEnterHandler(event:MapEvent) : void
      {
         createSquadron(event.squadron);
      }
      
      
      private function map_squadronLeaveHandler(event:MapEvent) : void
      {
         destroySquadron(event.squadron);
      }
      
      
      /* ##################################### */
      /* ### SQUADRON MODEL EVENT HANDLERS ### */
      /* ##################################### */
      
      
      private function addSquadronEventHandlers(squadM:MSquadron) : void
      {
         squadM.addEventListener(MSquadronEvent.MOVE, squadron_moveHandler);
      }
      
      
      private function removeSquadronEventHandlers(squadM:MSquadron) : void
      {
         squadM.removeEventListener(MSquadronEvent.MOVE, squadron_moveHandler);
      }
      
      
      private function squadron_moveHandler(event:MSquadronEvent) : void
      {
         moveSquadron(event.squadron, event.moveFrom, event.moveTo);
      }
   }
}