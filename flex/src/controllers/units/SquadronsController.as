package controllers.units
{
   import com.developmentarc.core.utils.SingletonFactory;
   
   import components.map.space.CMapSpace;
   import components.map.space.Grid;
   import components.map.space.SquadronsController;
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
   import models.movement.SquadronsList;
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
    * Works with <code>MSquadron</code> objects and <code>ModelLocator.squadrons</code> list.
    */
   public class SquadronsController
   {
      public static function getInstance() : SquadronsController
      {
         return SingletonFactory.getSingletonInstance(SquadronsController);
      }
      
      
      private static const MOVEMENT_TIMER_DELAY:int = 1000; // Milliseconds
      
      
      private var ML:ModelLocator = ModelLocator.getInstance();
      private var SQUADS:SquadronsList = ML.squadrons;
      
      
      public function SquadronsController()
      {
         _timer = new Timer(MOVEMENT_TIMER_DELAY);
         _timer.addEventListener(TimerEvent.TIMER, movementTimer_timerHandler);
      }
      
      
      /**
       * Use to add next hop to hostile squadron when that hop is received from the server. Will
       * ignore given hop if squadron to add the hop to can't be found.
       */
      public function addHopToHostileSquadron(hop:MHop) : void
      {
         var squad:MSquadron = SQUADS.findMoving(hop.routeId);
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
       * Use to create friendly squadrons when they start moving but map defining their location has not been opened,
       * you don't have units that should be moved and you are unable to use <code>createSquadron()</code> method.
       * 
       * @param data should have <code>hops</code> list
       */
      public function createFriendlySquadron(data:Object) : void
      {
         var newSquad:MSquadron = SquadronFactory.fromObject(data);
         newSquad.owner = newSquad.playerId == ML.player.id ? Owner.PLAYER : Owner.ALLY;
         
         if (!newSquad.isMoving)
         {
            throw new ArgumentError(
               "Squadron " + newSquad + " is not moving: this method supports only moving squadrons"
            );
         }
         
         SQUADS.addItem(newSquad);
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
      public function destroyMovingSquadron(id:int) : void
      {
         if (id <= 0)
         {
            throw new ArgumentError("Illegal moving squadron id: " + id);
         }
         var squad:MSquadron = SQUADS.findMoving(id);
         if (squad)
         {
            SQUADS.removeItem(squad);
         }
      }
      
      
      /**
       * Call this when a map is to be destroyed and all hostile squadrons must be removed from squadrons list.
       * 
       * @param map can be either instance of <code>Planet</code> or <code>SolarSystem</code>
       */
      public function destroyHostileAndStationarySquadrons(map:Map) : void
      {
         var locId:int = map.id;
         var locType:int = map.isOfType(MapType.SOLAR_SYSTEM) ? LocationType.SOLAR_SYSTEM : LocationType.PLANET;
         var squadsToRemove:Array = SQUADS.findAll(
            function(squad:MSquadron) : Boolean
            {
               var loc:LocationMinimal = squad.currentHop.location
               return squad.isHostile && loc.type == locType && loc.id == locId;
            }
         );
         for each (var squad:MSquadron in squadsToRemove)
         {
            SQUADS.removeItem(squad);
         }
      }
      
      
      /**
       * Use to update <code>currentLocation</code> of frienldy squadron.
       * 
       * @param squadron must be a moving squadron and must belong to either the player or an ally
       */
      public function updateMovingFriendlySquadron(id:int, location:Location) : void
      {
         if (id <= 0)
         {
            throwIllegalMovingSquadId(id);
         }
         var squad:MSquadron = SQUADS.findMoving(id);
         if (!squad)
         {
            throw new ArgumentError("Squadron with id " + id + " could not be found");
         }
         if (squad.isHostile)
         {
            throw new ArgumentError("Squadron " + squad + " must be friendly");
         }
         squad.currentLocation = location;
         for each (var unit:Unit in squad.units)
         {
            unit.location = location;
         }
      }
      
      
      /**
       * Use to stop a squadron which is moving. Will ignore IDs of squadrons not present in
       * <code>ModelLocator.squadrons</code>.
       */
      public function stopSquadron(id:int) : void
      {
         if (id <= 0)
         {
            throwIllegalMovingSquadId(id);
         }
         
         var squadToStop:MSquadron = SQUADS.findMoving(id);
         if (!squadToStop)
         {
            return;
         }
         SQUADS.removeItem(squadToStop);
         squadToStop.id = 0;
         squadToStop.arrivesAt = null;
         squadToStop.sourceLocation = null;
         squadToStop.targetLocation = null;
         squadToStop.showRoute = false;
         squadToStop.hops.removeAll();
         for each (var unit:Unit in squadToStop.units)
         {
            unit.squadronId = 0;
         }
         var squadStationary:MSquadron = SQUADS.findStationary(squadToStop.currentHop.location, squadToStop.owner);
         if (squadStationary)
         {
            squadStationary.merge(squadToStop);
         }
         else
         {
            SQUADS.addItem(squadToStop);
         }
      }
      
      
      /**
       * Use to create all squadrons when they are received from the server after player has logged in.
       */
      public function createPlayerSquadrons(routes:Array) : void
      {
         for each (var data:Object in routes)
         {
            var squad:MSquadron = SquadronFactory.fromObject(data);
            squad.owner = Owner.PLAYER;
            squad.playerId = ML.player.id;
            SQUADS.addItem(squad);
         }
      }
      
      
      /**
       * Use when new units have been received to distribute them to squadrons. This method will add new squadrons
       * (if any has been created) to <code>ModelLocator.squadrons</code> list.
       * 
       * <p>
       * Do not use for starting units movement. Use <code>createSquadron()</code> or
       * <code>createFriendlySquadron()</code> for that.
       * </p>
       */
      public function distributeUnitsToSquadrons(units:IList) : void
      {
         var squad:MSquadron;
         var newSquads:Array = new Array();
         for each (var unit:Unit in units)
         {
            if (unit.kind != UnitKind.SPACE || !unit.isMoving && (!unit.location || unit.location.isPlanet))
            {
               continue;
            }
            
            squad = findSquad(unit.squadronId, unit.owner, unit.location);
            
            // No squadron for the unit: create one
            if (!squad)
            {
               // this should never be true, but just in case
               if (unit.isMoving)
               {
                  throw new Error(
                     "Could not find squadron for moving unit " + unit + ". All moving squadrons should have " +
                     "been created before calling distributeUnitsToSquadrons()"
                  );
               }
               squad = SquadronFactory.fromUnit(unit);
               SQUADS.addItem(squad);
               newSquads.push(squad);
            }
            
            // we only need to add units if they have not been added earlier
            if (!squad.units.findModel(unit.id))
            {
               squad.units.addItem(unit);
            }
         }
         
         for each (squad in newSquads)
         {
            squad.client_internal::rebuildCachedUnits()
         }
      }
      
      
      /* ################################## */
      /* ### SQUADS MOVEMENT AUTOMATION ### */
      /* ################################## */
      
      
      private var _timer:Timer;
      
      
      private function movementTimer_timerHandler(event:TimerEvent) : void
      {
         var aheadTime:Number = components.map.space.SquadronsController.MOVE_EFFECT_DURATION + 500;
         var currentTime:Number = new Date().time;
         for each (var squad:MSquadron in SQUADS)
         {
            if (squad.isMoving && squad.hasHopsRemaining && squad.nextHop.arrivesAt.time - aheadTime <= currentTime)
            {
               squad.moveToNextHop();
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
      
      
      /* ############### */
      /* ### HELPERS ### */
      /* ############### */
      
      
      private function findSquad(id:int, owner:int = Owner.UNDEFINED, loc:LocationMinimal = null) : MSquadron
      {
         return SQUADS.findFirst(
            function(squad:MSquadron) : Boolean
            {
               if (squad.isMoving)
               {
                  return squad.id == id;
               }
               return squad.owner == owner && squad.currentHop.location.equals(loc);
            }
         );
      }
      
      
      private function throwIllegalMovingSquadId(id:int) : void
      {
         throw new ArgumentError("Illegal moving squadron id: " + id);
      }
   }
}