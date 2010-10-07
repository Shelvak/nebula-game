package controllers.units
{
   import com.developmentarc.core.utils.SingletonFactory;
   
   import components.map.space.CMapSpace;
   import components.map.space.Grid;
   import components.movement.CRoute;
   import components.movement.CSquadronsMapIcon;
   
   import ext.flex.mx.collections.ArrayCollection;
   import ext.flex.mx.collections.IList;
   
   import flash.events.TimerEvent;
   import flash.geom.Point;
   import flash.utils.Timer;
   
   import flashx.textLayout.edit.SelectionState;
   
   import models.BaseModel;
   import models.galaxy.Galaxy;
   import models.ModelLocator;
   import models.ModelsCollection;
   import models.Owner;
   import models.factories.SquadronFactory;
   import models.location.Location;
   import models.location.LocationMinimal;
   import models.location.LocationType;
   import models.map.Map;
   import models.map.MapType;
   import models.movement.MHop;
   import models.movement.MSquadron;
   import models.movement.events.MSquadronEvent;
   import models.planet.Planet;
   import models.solarsystem.SolarSystem;
   import models.unit.Unit;
   import models.unit.UnitEntry;
   import models.unit.UnitKind;
   
   import mx.core.IVisualElement;
   import mx.events.EffectEvent;
   
   import namespaces.client_internal;
   import namespaces.map_internal;
   
   import spark.effects.Move;
   
   
   use namespace map_internal;

   
   /**
    * Controls <code>MSquadron</code> and <code>CSquadron</code> objects in all maps.
    */
   public class SquadronsController
   {
      public static function getInstance() : SquadronsController
      {
         return SingletonFactory.getSingletonInstance(SquadronsController);
      }
      
      
      private static const MOVEMENT_TIMER_DELAY:int = 1000; // Milliseconds
      public static const MOVE_EFFECT_DURATION:int = 500;  // Milliseconds
      private static const CSQUAD_GAP:int = 8;  // Pixels
      
      
      private var _modelLoc:ModelLocator = ModelLocator.getInstance();
      private var _squadrons:ModelsCollection = _modelLoc.squadrons;
      
      
      public function SquadronsController()
      {
         _timer = new Timer(MOVEMENT_TIMER_DELAY);
         _timer.addEventListener(TimerEvent.TIMER, movementTimer_timerHandler);
      }
      
      
      /* ####################################################### */
      /* ### FUNCTIONS CALLED FROM COMMUNICATION CONTROLLERS ### */
      /* ###                WORKS WITH MODELS                ### */
      /* ####################################################### */
      
      
      /**
       * Use to add next hop to hostile squadron when that hop is received from the server. Will
       * ignore given hop if squadron to add the hop to can't be found.
       */
      public function addNextHopToHostileSquadron(hop:MHop) : void
      {
         var squad:MSquadron = MSquadron(_squadrons.findModel(hop.routeId));
         if (squad)
         {
            squad.addHop(hop);
         }
      }
      
      
      /**
       * Use when you need to create new squadron if: hostile squadron enters palyer's visible area,
       * any squadron makes a jump between maps, when any stationary units need to be moved or when
       * units moving already need to be dispatched different way.
       * 
       * <p>If given units belong to the same moving squadron already in <code>ModelLocator.squadrons</code>
       * list, this squadron is destroyed first and the new one is created.</p>
       */
      public function createSquadron(units:IList, hops:IList,locSource:Location = null, locTarget:Location = null) : void
      {
         var sampleUnit:Unit = Unit(units.getFirstItem());
         var loc:LocationMinimal = sampleUnit.location;
         var squad:MSquadron = SquadronFactory.fromUnit(sampleUnit);
         squad.units.addAll(units);
         squad.addAllHops(hops);
         squad.sourceLocation = locSource;
         squad.targetLocation = locTarget;
         squad.client_internal::rebuildCachedUnits();
         
         // hostile squadrons must be added to list and maps only if it is located in one of cached maps
         if (squad.isHostile)
         {
            var planet:Planet = _modelLoc.latestPlanet;
            var solarSystem:SolarSystem = _modelLoc.latestSolarSystem;
            var galaxy:Galaxy = _modelLoc.latestGalaxy;
            if ( (!planet || planet.fake || !planet.definesLocation(loc)) &&
                 (!solarSystem || solarSystem.fake || !solarSystem.definesLocation(loc)) &&
                 (!galaxy || galaxy.fake || !galaxy.definesLocation(loc)) )
            {
               return;
            }
         }
         
         // find moving squadron
         var ownerSquad:MSquadron = findSquadron(sampleUnit.squadronId, sampleUnit.playerId, loc);
         // or stationary squadron
         if (!ownerSquad)
         {
            ownerSquad = findSquadron(0, squad.playerId, loc);
         }
         // if still no luck, run a heavy search: look for a squadron wich has a sample unit
         if (!ownerSquad)
         {
            ownerSquad = _squadrons.filterItems(
               function(squad:MSquadron) : Boolean
               {
                  return !squad.units.filterItems(
                     function(unit:Unit) : Boolean
                     {
                        return unit.equals(sampleUnit);
                     }
                  ).isEmpty;
               }
            ).getFirstItem();
         }
         
         if (ownerSquad)
         {
            if (ownerSquad.id != squad.id)
            {
               if (!ownerSquad.separateUnits(squad))
               {
                  removeSquadronFromListAndMap(ownerSquad);
               }
            }
            else if (squad.isMoving)
            {
               removeSquadronFromListAndMap(ownerSquad);
            }
            else
            {
               ownerSquad.merge(squad);
               return;
            }
         }
         
         addSquadronToListAndMap(squad);
      }
      
      
      /**
       * Use to create friendly squadrons when they start moving but map defining their location
       * has not been opened, you don't have units that should be moved and as as result you are
       * unable to use <code>createSquadron()</code> method.
       * 
       * @param data should have <code>hops</code> list
       */
      public function createFriendlySquadron(data:Object) : void
      {
         var newSquad:MSquadron = SquadronFactory.fromObject(data);
         newSquad.owner = newSquad.playerId == _modelLoc.player.id ? Owner.PLAYER : Owner.ALLY;
         
         if (!newSquad.isMoving)
         {
            throw new ArgumentError(
               "Squadron " + newSquad + " is not moving: this method supports only moving squadrons"
            );
         }
         
         addSquadronToListAndMap(newSquad);
      }
      
      
      /**
       * Use when:
       * <ul>
       *    <li>ENEMY or NAP squadron leaves visible area of a galaxy</li>
       *    <li>when any squadron has been destroyed</li>
       * </ul>
       * 
       * @param id must be id of moving squadron. If a squadron with given id could not be found,
       * nothing happens.
       */
      public function destroySquadron(id:int) : void
      {
         if (id <= 0)
         {
            throw new ArgumentError("Illegal moving squadron id: " + id);
         }
         var squad:MSquadron = MSquadron(_squadrons.findModel(id));
         if (squad)
         {
            if (_selectedCSquadrons && _selectedCSquadrons.squadrons.contains(squad))
            {
               saveSelectionState(squad.currentHop.location, squad.currentHop.location);
               deselectSelectedCSquadrons();
            }
            removeSquadronFromListAndMap(squad);
            loadSelectionState();
         }
      }
      
      
      /**
       * Use to update <code>currentLocation</code> of frienldy squadron.
       * 
       * @param squadron must be a moving squadron and must belong to either the player or an ally
       */
      public function updateFriendlySquadron(id:int, location:Location) : void
      {
         if (id <= 0)
         {
            throwIllegalMovingSquadId(id);
         }
         var squad:MSquadron = _squadrons.findModel(id);
         if (!squad)
         {
            throw new ArgumentError("Squadron with id " + id + " could not be found");
         }
         if (squad.isHostile)
         {
            throw new ArgumentError("Squadron " + squad + " must be owned by the player or an ally");
         }
         squad.currentLocation = location;
         for each (var unit:Unit in squad.units)
         {
            unit.location = location;
         }
      }
      
      
      /**
       * Use to stop a squadron which is moving.
       * Will ignore IDs of squadrons not present in <code>ModelLocator.squadrons</code>.
       */
      public function stopSquadron(id:int) : void
      {
         if (id <= 0)
         {
            throwIllegalMovingSquadId(id);
         }
         
         var squadToStop:MSquadron = MSquadron(_squadrons.findModel(id));
         if (!squadToStop)
         {
            return;
         }
         var loc:LocationMinimal = squadToStop.currentHop.location;
         if (_selectedCSquadrons && _selectedCSquadrons.squadrons.contains(squadToStop))
         {
            saveSelectionState(loc, loc);
         }
         removeSquadronFromListAndMap(squadToStop);
         for each (var unit:Unit in squadToStop.units)
         {
            unit.squadronId = 0;
         }
         if (!loc.isPlanet)
         {
            squadToStop.id = 0;
            var squadStationary:MSquadron = findSquadron(0, squadToStop.playerId, loc);
            if (squadStationary)
            {
               squadStationary.merge(squadToStop);
            }
            else
            {
               addSquadronToListAndMap(squadToStop);
            }
            loadSelectionState();
         }
         else if (_modelLoc.latestPlanet && _modelLoc.latestPlanet.definesLocation(loc))
         {
            _modelLoc.latestPlanet.units.addAll(squadToStop.units);
         }
      }
      
      
      public function createPlayerSquadrons(routes:Array) : void
      {
         for each (var data:Object in routes)
         {
            var squad:MSquadron = SquadronFactory.fromObject(data);
            squad.owner = Owner.PLAYER;
            squad.playerId = _modelLoc.player.id;
            _squadrons.addItem(squad);
         }
      }
      
      
      /**
       * Use when a map is destroyed and all hostile (ENEMY and NAP) and all not moving squadrons
       * must be removed form squadrons list.
       * 
       * Removes all squadrons that do not belong to the player or an ally that are located in the
       * given map from <code>ModelLocator.squadrons</code>.
       */
      public function removeHostileAndStationarySquadronsFromList(mapM:Map) : void
      {
         for each (var squad:MSquadron in mapM.squadrons)
         {
            if (squad.isHostile || !squad.isMoving)
            {
               _squadrons.removeItem(squad);
            }
         }
      }
      
      
      /**
       * Use after initialization of a new map to distribute all units in its area to squadrons. This method
       * will add new squadrons (if any has been created) to <code>ModelLocator.squadrons</code>
       * list as well as to the given map squadrons list.
       * 
       * <p>
       * Do not use for starting units movement. Use <code>createSquadron()</code> or
       * <code>createFriendlySquadron()</code> for that.
       * </p>
       */
      public function distributeUnitsToSquadrons(units:IList, mapM:Map) : void
      {
         if (mapM.fake)
         {
            return;
         }
         var squad:MSquadron;
         var newSquads:ModelsCollection = new ModelsCollection();
         for each (var unit:Unit in units)
         {
            if (unit.kind != UnitKind.SPACE ||
               !unit.isMoving && (!unit.location || unit.location.isPlanet) ||
                unit.location && !mapM.definesLocation(unit.location))
            {
               continue;
            }
            
            squad = findSquadron(unit.squadronId, unit.playerId, unit.location);
            
            // No squadron for the unit: create one
            if (!squad)
            {
               squad = SquadronFactory.fromUnit(unit);
               _squadrons.addItem(squad);
               newSquads.addItem(squad);
            }
            
            if (!squad.units.findModel(unit.id))
            {
               squad.units.addItem(unit);
            }
         }
         
         for each (squad in newSquads)
         {
            squad.client_internal::rebuildCachedUnits()
         }
         
         for each (squad in _squadrons)
         {
            if (mapM.definesLocation(squad.currentHop.location))
            {
               mapM.addSquadron(squad);
            }
         }
      }
      
      
      private function addSquadronToListAndMap(squad:MSquadron) : void
      {
         if (squad.currentHop.fake)
         {
            return;
         }
         if (addSquadronToCachedMMap(squad) || squad.isFriendly && squad.isMoving)
         {
            _squadrons.addItem(squad);
         }
      }
      
      
      private function removeSquadronFromListAndMap(squad:MSquadron) : void
      {
         if (removeSquadronFromCachedMMap(squad) || squad.isFriendly)
         {
            _squadrons.removeItem(squad);
         }
      }
      
      
      /**
       * @return <code>true</code> if squadron has actually been added to a cached map 
       */
      private function addSquadronToCachedMMap(squad:MSquadron) : Boolean
      {
         var loc:LocationMinimal = squad.currentHop.location;
         var mapM:Map = getCachedMap(loc.type);
         if (loc.type == LocationType.PLANET && !squad.isMoving)
         {
            mapM = null;
         }
         if (mapM && !mapM.fake && mapM.definesLocation(loc))
         {
            mapM.addSquadron(squad);
            return true;
         }
         return false;
      }
      
      
      /**
       * Also removes units in the given squadron from cached planet map.
       *  
       * @return <code>true</code> if squadron has actually been removed from a cached map 
       */
      private function removeSquadronFromCachedMMap(squad:MSquadron) : Boolean
      {
         var loc:LocationMinimal = squad.currentHop.location;
         var mapM:Map = getCachedMap(loc.type);
         if (mapM && !mapM.fake && mapM.definesLocation(loc) && mapM.squadrons.contains(squad))
         {
            mapM.removeSquadron(squad);
            if (mapM.mapType == MapType.PLANET)
            {
               for each (var unit:Unit in squad.units)
               {
                  if (Planet(mapM).units.contains(unit))
                  {
                     Planet(mapM).units.removeItem(unit);
                  }
               }
            }
            return true;
         }
         return false;
      }
      
      
      /* ####################################### */
      /* ### SQUADRONS AND ROUTES MANAGEMENT ### */
      /* ###      WORKS WITH COMPONENTS      ### */
      /* ####################################### */
      
      
      map_internal function initializeCMapSquadrons(mapC:CMapSpace) : void
      {
         var mapM:Map = Map(mapC.model);
         for each (var squad:MSquadron in mapM.squadrons)
         {
            createOrUpdateCSquadrons(mapC, squad);
         }
      }
      
      
      /**
       * Takes care of <code>CRoute</code> also.
       */
      map_internal function createOrUpdateCSquadrons(map:CMapSpace, squadron:MSquadron) : CSquadronsMapIcon
      {
         // create CRoute. Only moving squadrons have route.
         if (squadron.isMoving)
         {
            map.addCRoute(new CRoute(squadron, map.grid));
         }
         
         // update CSquadronsMapIcon
         var squadC:CSquadronsMapIcon = null;
         for each (var component:CSquadronsMapIcon in map.getCSquadronsByLocation(squadron.currentHop.location))
         {
            if (component.squadronsOwner == squadron.owner)
            {
               squadC = component;
               break;
            }
         }
         // create CSquadronsMapIcon
         if (!squadC)
         {
            squadC = new CSquadronsMapIcon();
            squadC.addSquadron(squadron);
            positionCSquadron(map, squadC);
            map.addCSquadrons(squadC);
         }
         else
         {
            squadC.addSquadron(squadron);
         }
         return squadC;
      }
      
      
      /**
       * Takes care of <code>CRoute</code> also.
       */
      map_internal function removeOrUpdateCSquadrons(map:CMapSpace, squadron:MSquadron, location:LocationMinimal = null) : CSquadronsMapIcon
      {
         // remove CRoute. Stationary squads do not have routes
         if (squadron.isMoving)
         {
            var routeC:CRoute = map.getCRouteByModel(squadron);
            map.removeCRoute(routeC);
            routeC.cleanup();
         }
         
         // update CSquadronsMapIcon
         var squadC:CSquadronsMapIcon = map.getCSquadronsByModel(squadron);
         squadC.removeSquadron(squadron);
         // remove CSquadronsMapIcon
         if (!squadC.hasSquadrons)
         {
            if (!location)
            {
               location = squadron.currentHop.location;
            }
            if (squadC == _selectedCSquadrons)
            {
               deselectSelectedCSquadrons();
            }
            map.removeCSquadrons(squadC, location);
         }
         return squadC;
      }
      
      
      map_internal function positionAllCSquadrons(mapC:CMapSpace) : void
      {
         for each (var squadC:CSquadronsMapIcon in mapC.getSquadronObjects())
         {
            positionCSquadron(mapC, squadC);
         }
         for each (var routeC:CRoute in mapC.getRouteObjects())
         {
            routeC.invalidateDisplayList();
         }
      }
      
      
      private function positionCSquadron(mapC:CMapSpace, squadC:CSquadronsMapIcon) : void
      {
         var position:Point = getCSquadronsPosition(mapC, squadC.squadronsOwner, squadC.currentLocation);
         squadC.x = position.x;
         squadC.y = position.y;
      }
      
      
      /* ################################## */
      /* ### SQUADS MOVEMENT AUTOMATION ### */
      /* ################################## */
      
      
      private var _timer:Timer;
      
      
      private function movementTimer_timerHandler(event:TimerEvent) : void
      {
         var aheadTime:Number = MOVE_EFFECT_DURATION + 500
         var currentTime:Number = new Date().time;
         for each (var squad:MSquadron in _squadrons)
         {
            // either move squadron to the next hop
            if (squad.hasHopsRemaining && squad.nextHop.arrivesAt.time - aheadTime <= currentTime)
            {
               client_internal::moveSquadron(squad);
            }
            // or remove it from the map if this was the last hop in that map
            else if (squad.currentHop.jumpsAt && squad.currentHop.jumpsAt.time - aheadTime <= currentTime)
            {
               if (squad.isHostile)
               {
                  removeSquadronFromListAndMap(squad);
               }
               else
               {
                  removeSquadronFromCachedMMap(squad);
               }
               // mark current hop as fake so that we don't accidently add this squadron to the same
               // map again
               squad.currentHop.fake = true;
            }
         }
      }
      
      
      public function startMovementTimer() : void
      {
         _timer.start();
      }
      
      
      public function stopMovementTimer() : void
      {
         _timer.stop();
      }
      
      
      /* #################### */
      /* ### MOVING SQUAD ### */
      /* #################### */
      
      
      client_internal function moveSquadron(squadron:MSquadron) : void
      {
         if (squadron.isMoving && squadron.hasHopsRemaining)
         {
            function squadron_moveHandler(event:MSquadronEvent) : void
            {
               squadron.removeEventListener(MSquadronEvent.MOVE, squadron_moveHandler);
               var fromLoc:LocationMinimal = event.moveFrom;
               var fromMapM:Map = getCachedMap(fromLoc.type);
               var toLoc:LocationMinimal = event.moveTo;
               var toMapM:Map = getCachedMap(toLoc.type);
               if (toMapM)
               {
                  squadron.currentLocation = toMapM.getLocation(toLoc.x, toLoc.y);
               }
               if (fromLoc.type != toLoc.type)
               {
                  if (fromMapM)
                  {
                     fromMapM.removeSquadron(squadron);
                  }
                  if (toMapM)
                  {
                     toMapM.addSquadron(squadron);
                  }
               }
            }
            squadron.addEventListener(MSquadronEvent.MOVE, squadron_moveHandler);
            squadron.moveToNextHop();
         }
      }
      
      
      /**
       * Calls to this method when <code>from.type != to.type</code> are ignored.
       */
      map_internal function moveSquadron(mapC:CMapSpace, squadron:MSquadron, from:LocationMinimal, to:LocationMinimal) : void
      {
         if (from.type != to.type)
         {
            return;
         }
         if (_selectedCSquadrons && _selectedCSquadrons.squadrons.contains(squadron))
         {
            saveSelectionState(from, to);
            deselectSelectedCSquadrons();
         }
         // Remove squadron from CSquadrons component it is in
         removeOrUpdateCSquadrons(mapC, squadron, from);
         var fromCoords:Point = getCSquadronsPosition(mapC, squadron.owner, from);
         var toCoords:Point = getCSquadronsPosition(mapC, squadron.owner, to);
         // Create CSquadrons component that will be moved
         var movingSquadC:CSquadronsMapIcon = new CSquadronsMapIcon();
         movingSquadC.addSquadron(squadron);
         movingSquadC.x = fromCoords.x;
         movingSquadC.y = fromCoords.y;
         mapC.squadronObjectsCont.addElement(movingSquadC);
         // Move that component smoothly
         var moveEffect:Move = createMoveEffect(movingSquadC, toCoords.x, toCoords.y);
         moveEffect.addEventListener(
            EffectEvent.EFFECT_END, function(event:EffectEvent) : void
            {
               // Remove the component wich has been moved and add squadron to static CSquadrons
               // component (or create new if needed - createOrUpdateCSquadrons() takes care of this
               // operation)
               mapC.squadronObjectsCont.removeElement(movingSquadC);
               createOrUpdateCSquadrons(mapC, squadron);
               removeMoveEffect(moveEffect);
               loadSelectionState();
            }
         );
         moveEffect.play();
      }
      
      
      private var _moveEffects:ArrayCollection = new ArrayCollection();
      /**
       * Does not start the effect.
       */
      private function createMoveEffect(target:Object, xTo:Number, yTo:Number) : Move
      {
         var effect:Move = new Move(target);
         effect.duration = MOVE_EFFECT_DURATION;
         effect.xTo = xTo;
         effect.yTo = yTo;
         _moveEffects.addItem(effect);
         return effect;
      }
      /**
       * Removes the effect from <code>_moveEffects</code> collection.
       */
      private function removeMoveEffect(effect:Move) : void
      {
         _moveEffects.removeItem(effect);
      }
      
      
      /* ####################### */
      /* ### SQUAD SELECTION ### */
      /* ####################### */
      
      
      private var _lastSelectionState:SelectionState;
      private function saveSelectionState(locOld:LocationMinimal, locNew:LocationMinimal) : void
      {
         if (_selectedCSquadrons)
         {
            var squad:MSquadron = _selectedCSquadronsMap.squadronsInfo.selectedSquadron;
            _lastSelectionState = new SelectionState(
               _selectedCSquadronsMap,
               squad ? squad.id : 0,
               _selectedCSquadrons.squadronsOwner,
               locOld,
               locNew
            );
         }
      }
      private function loadSelectionState() : void
      {
         if (!_lastSelectionState)
         {
            return;
         }
         var mapC:CMapSpace = _lastSelectionState.map;
         var id:int = _lastSelectionState.id;
         var owner:int = _lastSelectionState.owner;
         var locOld:LocationMinimal = _lastSelectionState.currentLocation;
         var locNew:LocationMinimal = _lastSelectionState.nextLocation;
         function getCSuadrons(loc:LocationMinimal) : CSquadronsMapIcon
         {
            if (!loc)
            {
               return null;
            }
            return mapC.getCSquadronsByLocation(loc).filterItems(
               function(squadC:CSquadronsMapIcon) : Boolean
               {
                  return squadC.squadronsOwner == owner;
               }
            ).getFirstItem();
         };
         var squadCOld:CSquadronsMapIcon = getCSuadrons(locOld);
         var squadCNew:CSquadronsMapIcon = getCSuadrons(locNew);
         // we had a moving squadron selected
         if (id != 0)
         {
            if (Map(mapC.model).definesLocation(locNew))
            {
               selectCSquadrons(mapC, squadCNew);
               var movingSquad:MSquadron = _squadrons.findModel(id);
               // we still have it in the same map so select it
               if (movingSquad)
               {
                  mapC.squadronsInfo.selectedSquadron = movingSquad;
               }
               // the squadron has stopped so select a stationary squad
               else
               {
                  mapC.squadronsInfo.selectedSquadron = squadCNew.squadrons.findModel(0);
               }
            }
         }
         // user only observed all squadrons in a location
         else
         {
            if (!squadCOld && squadCNew)
            {
               selectCSquadrons(mapC, squadCNew);
            }
            else if (squadCOld)
            {
               selectCSquadrons(mapC, squadCOld);
            }
         }
         resetSelectionState(mapC);
      }
      public function resetSelectionState(mapC:CMapSpace) : void
      {
         if (_selectedCSquadronsMap == mapC)
         {
            _lastSelectionState = null;
         }
      }
      
      
      private var _selectedCSquadrons:CSquadronsMapIcon = null;
      private var _selectedCSquadronsMap:CMapSpace = null;
      
      
      map_internal function selectCSquadrons(mapC:CMapSpace, component:CSquadronsMapIcon) : void
      {
         resetSelectionState(_selectedCSquadronsMap);
         deselectSelectedCSquadrons();
         var position:Point = getCSquadronsPosition(mapC, component.squadronsOwner, component.currentLocation);
         mapC.squadronsInfo.move(
            position.x + component.getExplicitOrMeasuredWidth() / 2,
            position.y + component.getExplicitOrMeasuredHeight() / 2
         );
         mapC.squadronsInfo.squadrons = component.squadrons;
         _selectedCSquadrons = component;
         _selectedCSquadronsMap = mapC;
      }
      
      
      private function deselectSelectedCSquadrons() : void
      {
         if (_selectedCSquadrons)
         {
            _selectedCSquadronsMap.squadronsInfo.reset();
            _selectedCSquadrons = null;
            _selectedCSquadronsMap = null;
         }
      }
      
      
      /* ############### */
      /* ### HELPERS ### */
      /* ############### */
      
      
      /**
       * Returns actual position of a <code>CSquadronsMapIcon</code> component in the given space sector.
       * This method takes into account following properties of the component and space sector when
       * calculating position:
       * <ul>
       *    <li>dimensions of the component;</li>
       *    <li>owners of the squadrons represented by the component;</li>
       *    <li>existance of static objects in the space sector.</li>
       * </ul>
       */
      private function getCSquadronsPosition(map:CMapSpace, owner:uint, location:LocationMinimal) : Point
      {
         var grid:Grid = map.grid;
         var coords:Point = null;
         var staticObject:IVisualElement = grid.getStaticObjectInSector(location);
         if (staticObject)
         {
            coords = new Point();
            coords.x = staticObject.x + staticObject.width - 1 - CSquadronsMapIcon.WIDTH;
            coords.y = staticObject.y + staticObject.height - 1 - CSquadronsMapIcon.HEIGHT;
            switch(owner)
            {
               case Owner.PLAYER:
                  coords.y -= 2 * (CSQUAD_GAP + CSquadronsMapIcon.HEIGHT);
                  break;
               case Owner.ALLY:
                  coords.y -= CSQUAD_GAP + CSquadronsMapIcon.HEIGHT;
                  break;
               case Owner.NAP:
                  coords.x -= 2 * (CSQUAD_GAP + CSquadronsMapIcon.WIDTH);
                  break;
               case Owner.ENEMY:
                  coords.x -= CSQUAD_GAP + CSquadronsMapIcon.WIDTH;
                  break;
            }
         }
         else
         {
            var mltpX:int = 1;
            var mltpY:int = 1;
            switch(owner)
            {
               case Owner.PLAYER:
                  mltpX = mltpY = -1;
                  break;
               case Owner.ALLY:
                  mltpY = -1;
                  break;
               case Owner.NAP:
                  mltpX = -1;
                  break;
            }
            coords = grid.getSectorRealCoordinates(location);
            coords.x += mltpX * (CSQUAD_GAP + CSquadronsMapIcon.WIDTH) / 2 - CSquadronsMapIcon.WIDTH / 2;
            coords.y += mltpY * (CSQUAD_GAP + CSquadronsMapIcon.HEIGHT) / 2 - CSquadronsMapIcon.HEIGHT / 2;
         }
         return coords;
      }
      
      
      private function findSquadron(id:int, playerId:int = -1, loc:LocationMinimal = null) : MSquadron
      {
         return MSquadron(_squadrons.filterItems(
            function(squad:MSquadron) : Boolean
            {
               return squad.id == id && (!squad.isMoving ?
                  squad.playerId == playerId && squad.currentHop.location.equals(loc) :
                  true);
            }
         ).getFirstItem());
      }
      
      
      private function getCachedMap(locationType:int) : Map
      {
         switch(locationType)
         {
            case LocationType.GALAXY:
               return _modelLoc.latestGalaxy;
            case LocationType.SOLAR_SYSTEM:
               return _modelLoc.latestSolarSystem;
            case LocationType.PLANET:
               return _modelLoc.latestPlanet;
         }
         return null;   // unreachable
      }
      
      
      private function throwIllegalMovingSquadId(id:int) : void
      {
         throw new ArgumentError("Illegal moving squadron id: " + id);
      }
   }
}


import components.map.space.CMapSpace;
import models.location.LocationMinimal;
import models.movement.MSquadron;
internal class SelectionState
{
   public function SelectionState(map:CMapSpace, id:int, owner:int, currentLocation:LocationMinimal, nextLocation:LocationMinimal)
   {
      this.map = map;
      this.id = id;
      this.owner = owner;
      this.currentLocation = currentLocation;
      this.nextLocation = nextLocation;
   }
   public var map:CMapSpace;
   public var id:int;
   public var owner:int;
   public var currentLocation:LocationMinimal;
   public var nextLocation:LocationMinimal;
}