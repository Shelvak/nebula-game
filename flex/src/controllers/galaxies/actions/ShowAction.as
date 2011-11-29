package controllers.galaxies.actions
{
   import controllers.CommunicationAction;
   import controllers.CommunicationCommand;
   import controllers.planets.PlanetsCommand;
   import controllers.planets.actions.ShowActionParams;
   import controllers.solarsystems.SolarSystemsCommand;
   import controllers.solarsystems.actions.ShowActionParams;
   import controllers.ui.NavigationController;
   import controllers.units.SquadronsController;

   import globalevents.GlobalEvent;

   import models.MWreckage;
   import models.cooldown.MCooldownSpace;
   import models.factories.GalaxyFactory;
   import models.factories.UnitFactory;
   import models.galaxy.Galaxy;
   import models.map.MapArea;
   import models.map.MapType;
   import models.movement.MHop;
   import models.solarsystem.MSSObject;
   import models.solarsystem.MSolarSystem;
   import models.time.MTimeEventFixedMoment;

   import mx.collections.ArrayCollection;
   import mx.collections.IList;
   import mx.collections.ListCollectionView;

   import utils.Objects;


   /**
    * Downloads list of solar systems for a galaxy and shows galaxy map.
    * 
    * <p>
    * Client -->> Server: no parameters
    * </p>
    * <p>
    * Client <<-- Server
    * <ul>
    *    <li><code>reason</code></li>
    *    <li><code>battlegroundId</code></li>
    *    <li><code>solarSystems</code></li>
    *    <li><code>fowEntries</code></li>
    *    <li><code>wreckages</code></li>
    *    <li><code>cooldowns</code></li>
    *    <li><code>units</code></li>
    *    <li><code>players</code></li>
    *    <li><code>routeHops</code></li>
    * </ul>
    * </p>
    */
   public class ShowAction extends CommunicationAction
   {
      private function get SQUADS_CTRL() : SquadronsController {
         return SquadronsController.getInstance();
      }
      
      private function get NAV_CTRL() : NavigationController {
         return NavigationController.getInstance();
      }
      
      
      public function ShowAction() {
         super();
      }
      
      public override function applyServerAction(cmd:CommunicationCommand) :
            void {
         var params:Object = cmd.parameters;
         var startup:Boolean = ML.latestGalaxy == null;
         ML.player.galaxyId = params["galaxyId"];
         createGalaxy(
            ML.player.galaxyId,
            params["battlegroundId"],
            params["apocalypseStart"],
            GalaxyFactory.createFowEntries(params["fowEntries"]),
            GalaxyFactory.createSolarSystems(params["solarSystems"]),
            Objects.fillCollection(
               new ArrayCollection(), MWreckage, params["wreckages"]
            ),
            Objects.fillCollection(
               new ArrayCollection(), MCooldownSpace, params["cooldowns"]
            ),
            UnitFactory.fromObjects(params["units"], params["players"]),
            IList(Objects.fillCollection(
               new ArrayCollection(), MHop, params["routeHops"])
            ).toArray(),
            params["nonFriendlyJumpsAt"]
         );
         var galaxy:Galaxy = ML.latestGalaxy;

         if (!startup) {
            if (params["reason"] == "alliance") {
               reloadPlanetMap();
               reloadSolarSystemMap();
            }
            NAV_CTRL.recreateMap(galaxy);
            if (ML.activeMapType == MapType.PLANET) {
               if (ML.latestPlanet == null) {
                  if (ML.latestSSMap != null)
                     NAV_CTRL.toSolarSystem(ML.latestSSMap.id);
                  else
                     NAV_CTRL.toGalaxy();
               }
            }
            else if (ML.activeMapType == MapType.SOLAR_SYSTEM) {
               if (ML.latestSSMap == null)
                  NAV_CTRL.toGalaxy();
            }
         }
         else {
            // If you are playing the game for the first time or only have
            // one planet and don't have any units in galaxy - then open first
            // player planet.
            var deepOpen:Boolean =
               ML.player.firstTime || ML.player.planetsCountAll == 1 &&
               ! galaxy.hasMoreThanOneObject && ! galaxy.hasUnits;
            if (deepOpen) {
               NAV_CTRL.toGalaxy(galaxy,
                  function() : void {
                     new GlobalEvent(GlobalEvent.APP_READY);

                     NAV_CTRL.toPlanet(
                        MSSObject(ML.player.planets.getItemAt(0)),
                        function() : void {
                           if (ML.player.firstTime)
                              NAV_CTRL.showWelcomeScreen();
                        }
                     );
                  }
               );
            }
            else {
               NAV_CTRL.toGalaxy(galaxy,
                  function() : void {
                     new GlobalEvent(GlobalEvent.APP_READY);

                     var solarSystems: ListCollectionView =
                        galaxy.solarSystemsWithPlayer;
                     if (solarSystems.length != 0) {
                        var ss: MSolarSystem = MSolarSystem(
                           solarSystems.getItemAt(0)
                        );
                        galaxy.moveTo(ss.currentLocation, true);
                     }
                  }
               );
            }
         }
      }
      
      public function createGalaxy(galaxyId:int,
                                   battlegroundId:int,
                                   apocalypseStart: String,
                                   fowEntries:Array,
                                   solarSystems:IList,
                                   wreckages:IList,
                                   cooldowns:IList,
                                   units:IList,
                                   hops:Array,
                                   jumpsAtHash:Object) : void {
         ML.latestGalaxy = null;
         var galaxy:Galaxy = new Galaxy();
         galaxy.id = galaxyId;
         galaxy.battlegroundId = battlegroundId;
         if (apocalypseStart != null) {
            galaxy.apocalypseStartEvent =
               MTimeEventFixedMoment.autoCreate(null, apocalypseStart);
         }
         galaxy.addAllObjects(solarSystems);
         galaxy.addAllObjects(wreckages);
         galaxy.addAllObjects(cooldowns);
         ML.units.disableAutoUpdate();
         ML.units.addAll(units);
         ML.units.enableAutoUpdate();
         galaxy.setFOWEntries(Vector.<MapArea>(fowEntries), units);
         SQUADS_CTRL.createSquadronsForUnits(units, galaxy);
         SQUADS_CTRL.addHopsToSquadrons(hops);
         SQUADS_CTRL.attachJumpsAtToHostileSquads(galaxy.squadrons, jumpsAtHash);

         ML.latestGalaxy = galaxy;
         var cachedSS: MSolarSystem = ML.latestSSMap != null
                                         ? ML.latestSSMap.solarSystem
                                         : null;
         if (cachedSS == null
                || cachedSS.isGlobalBattleground
                      && !galaxy.hasWormholes
                || !cachedSS.isGlobalBattleground
                      && galaxy.getSSById(cachedSS.id) == null) {
            ML.latestPlanet = null;
            ML.latestSSMap = null;
         }
      }
      
      private function reloadPlanetMap() : void {
         if (ML.latestPlanet != null) {
            ML.latestPlanet.fake = true;
            if (ML.activeMapType == MapType.PLANET) {
               new PlanetsCommand(
                  PlanetsCommand.SHOW,
                  new controllers.planets.actions.ShowActionParams(ML.latestPlanet.id, true)
               ).dispatch();
            }
         }
      }
      
      private function reloadSolarSystemMap() : void {
         if (ML.latestSSMap != null) {
            ML.latestSSMap.fake = true;
            if (ML.activeMapType == MapType.SOLAR_SYSTEM) {
               new SolarSystemsCommand(
                  SolarSystemsCommand.SHOW,
                  new controllers.solarsystems.actions.ShowActionParams(ML.latestSSMap.id, true)
               ).dispatch();
            }
         }
      }
   }
}