package components.map.space
{
   import components.movement.CRoute;
   import components.movement.CSquadronMapIcon;
   
   import controllers.routes.RoutesCommand;
   
   import flash.geom.Point;
   
   import interfaces.ICleanable;
   
   import models.location.LocationMinimal;
   import models.map.Map;
   import models.map.events.MapEvent;
   import models.movement.MHop;
   import models.movement.MSquadron;
   import models.movement.events.MSquadronEvent;
   
   import mx.collections.ArrayCollection;
   
   import spark.components.Group;
   import spark.effects.Move;

   public class SquadronsController implements ICleanable
   {
      public static const MOVE_EFFECT_DURATION:int = 500;   // Milliseconds
      private static const FADE_EFFECT_DURATION:int = 500;   // Milliseconds
      
      
      private var _mapM:Map,
                  _mapC:CMapSpace,
                  _grid:Grid,
                  _layout:SquadronsLayout,
                  _squadronsContainer:Group,
                  _routesContainer:Group;
      
      
      /* ###################### */
      /* ### INITIALIZATION ### */
      /* ###################### */
      
      
      public function SquadronsController(mapC:CMapSpace)
      {
         _mapC = mapC;
         _mapM = Map(mapC.model);
         _squadronsContainer = mapC.squadronObjectsCont;
         _routesContainer = mapC.routeObjectsCont;
         _grid = mapC.grid;
         _layout = new SquadronsLayout(mapC);
         addMapEventHandlers(_mapM);
         
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
      }
      
      
      /* ######################### */
      /* ### COMPONENTS HASHES ### */
      /* ######################### */
      
      
      /**
       * Hash of <code>CSquadronMapIcon</code> components where key is
       * <code>component.model.currentLocation.hashKey()</code> and value is a hash of components
       * where key is the <code>component.model.hashKey()</code>.
       */
      private var _squadronsHash:Object = new Object();
      
      
      private function addSquadronToHash(squadC:CSquadronMapIcon) : void
      {
         var squadM:MSquadron = squadC.squadron;
         var keyLocation:String = squadM.currentHop.location.hashKey();
         var hashBySquad:Object = _squadronsHash[keyLocation];
         if (!hashByModel)
         {
            hashBySquad = new Object();
            _squadronsHash[keyLocation] = hashBySquad;
         }
         hashBySquad[squadM.hashKey()] = squadC;
      }
      
      
      private function removeSquadronFromHash(squadC:CSquadronMapIcon) : void
      {
         var squadM:MSquadron = squadC.squadron;
         delete _squadronsHash[squadM.currentHop.location.hashKey()][squadM.hashKey()];
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
      
      
      private function removeRouteFromHash(routeC:CRoute) : void
      {
         delete _routesHash[routeC.squadron.hashKey()]
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
         
         var squadC:CSquadronMapIcon = new CSquadronMapIcon();
         squadC.squadron = squadM;
         addSquadronToHash(squadC);
         var coords:Point = _layout.getFreeSlotCoords(squadC.currentLocation, squadC.squadronOwner);
         squadC.move(coords.x, coords.y);
         _squadronsContainer.addElement(squadC);
      }
      
      
      private function destroySquadron(squadM:MSquadron) : void
      {
         removeSquadronEventHandlers(squadM);
         
         if (squadM.isMoving)
         {
            var routeC:CRoute = getRouteByModel(squadM);
            removeRouteFromHash(routeC);
            _routesContainer.removeElement(routeC);
            routeC.cleanup();
         }
         
         var squadC:CSquadronMapIcon = getSquadronByModel(squadM);
         removeSquadronFromHash(squadC);
         _squadronsContainer.removeElement(squadC);
         squadC.cleanup();
      }
      
      
      /* ################ */
      /* ### MOVEMENT ### */
      /* ################ */
      
      
      /**
       * Hash of <code>CSquadronMapIcon</code> components that are beeing moved from one location
       * to another. These components will not be present in <code>_squadronsHash</code> during
       * that period of time. 
       */
      private var _movingSquadsHash:Object = new Object();
      
      
      private function moveSquadron(squadM:MSquadron, from:LocationMinimal, to:LocationMinimal) : void
      {
         var coordsTo:Point = _layout.getFreeSlotCoords(to, squadM.owner);
         var effect:Move = new Move(getSquadronByModel(squadM));
         effect.duration = MOVE_EFFECT_DURATION;
         effect.xTo = xTo;
         effect.yTo = yTo;
         createMoveEffect(
            ,
            
         ).play();
      }
      
      
      private var _effects:ArrayCollection = new ArrayCollection();
      /**
       * Does not start the effect.
       */
      private function createMoveEffect(target:Object, xTo:Number, yTo:Number) : Move
      {
         var effect:Move = new Move(target);
         effect.duration = MOVE_EFFECT_DURATION;
         effect.xTo = xTo;
         effect.yTo = yTo;
         function effectEndHandler(event:EffectEvent) : void
         {
            effect.removeEventListener(EffectEvent.EFFECT_END, effectEndHandler);
            _effects.removeItem(effect);
         }
         effect.addEventListener(EffectEvent.EFFECT_END, effectEndHandler);
         _effects.addItem(effect);
         return effect;
      }
      /**
       * Removes the effect from <code>_moveEffects</code> collection.
       */
      private function removeMoveEffect(effect:Move) : void
      {
         _effects.removeItem(effect);
      }
      
      
      /* ################# */
      /* ### SELECTION ### */
      /* ################# */
      
      
      private var _selectedSquadC:CSquadronMapIcon;
      
      
      internal function selectSquadron(squadC:CSquadronMapIcon) : void
      {
         deselectSelectedSquadron();
         _mapC.squadronsInfo.move(
            squadC.getLayoutBoundsX(true) + squadC.getLayoutBoundsWidth(true) / 2,
            squadC.getLayoutBoundsY(true) + squadC.getLayoutBoundsHeight(true) / 2
         );
         _mapC.squadronsInfo.squadron = squadC.squadron;
         _selectedSquadC = squadC;
         _selectedSquadC.selected = true;
      }
      
      
      internal function deselectSelectedSquadron() : void
      {
         if (_selectedSquadC)
         {
            _mapC.squadronsInfo.squadron = null;
            _selectedSquadC.selected = false;
            _selectedSquadC = null;
         }
      }
      
      
      /* ######################### */
      /* ### COMPONENTS LOOKUP ### */
      /* ######################### */
      
      
      private function getRouteByModel(squadM:MSquadron) : CRoute
      {
         return _routeObjectsHash.[squadM.hashKey()];
      }
      
      
      /**
       * @return A hash of squadrons (where key is <code>MSquadron.hashKey()</code>) in the given location.
       */
      internal function getSquadronsByLocation(location:LocationMinimal) : Object
      {
         return _squadronObjectsHash.[location.hashKey()];
      }
      
      
      internal function getSquadronByModel(squadM:MSquadron) : CSquadronMapIcon
      {
         var hashByIDs:Object = getSquadronsByLocation(squadM.currentHop.location);
         return hashByIDs ? hashByIDs[squadM.hashKey()] : null;
      }
      
      
      internal function getSquadronStationary(location:LocationMinimal, owner:int) : CSquadronMapIcon
      {
         var squad:MSquadron = new MSquadron();
         squad.id = 0;
         squad.owner = owner;
         squad.currentHop = new MHop();
         squad.currentHop.location = location;
         return getSquadronByModel(squad);
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