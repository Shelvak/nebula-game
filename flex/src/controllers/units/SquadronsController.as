package controllers.units
{
   import com.developmentarc.core.utils.SingletonFactory;
   
   import components.map.space.CMapSpace;
   import components.map.space.Grid;
   import components.map.space.SquadronsLayout;
   import components.movement.CRoute;
   import components.movement.CSquadronMapIcon;
   
   import ext.flex.mx.collections.ArrayCollection;
   import ext.flex.mx.collections.IList;
   
   import flash.events.TimerEvent;
   import flash.geom.Point;
   import flash.utils.Timer;
   
   import models.ModelLocator;
   import models.ModelsCollection;
   import models.Owner;
   import models.factories.SquadronFactory;
   import models.galaxy.Galaxy;
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
            if (_selectedCSquadron && _selectedCSquadron.squadron.equals(squad))
            {
               deselectSelectedCSquadron();
            }
            removeSquadronFromListAndMap(squad);
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
         var selectAfterStop:Boolean;
         var selectedSquadMap:CMapSpace;
         if (_selectedCSquadron && _selectedCSquadron.squadron.equals(squadToStop))
         {
            selectAfterStop = true;
            selectedSquadMap = _selectedCSquadronMap;
            deselectSelectedCSquadron();
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
            var squadToSelect:MSquadron;
            if (squadStationary)
            {
               squadStationary.merge(squadToStop);
               squadToSelect = squadStationary;
            }
            else
            {
               addSquadronToListAndMap(squadToStop);
               squadToSelect = squadToStop;
            }
            if (selectAfterStop)
            {
               selectCSquadrons(selectedSquadMap, selectedSquadMap.getCSquadronByModel(squadToSelect));
            }
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
            squadron.moveToNextHop();
         }
      }
      
      
      /* ############### */
      /* ### HELPERS ### */
      /* ############### */
      
      
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
      
      
      private function throwIllegalMovingSquadId(id:int) : void
      {
         throw new ArgumentError("Illegal moving squadron id: " + id);
      }
   }
}