package controllers.galaxies.actions
{
   import com.developmentarc.core.utils.EventBroker;

   import components.player.MWaitingScreen;

   import controllers.CommunicationAction;
   import controllers.CommunicationCommand;
   import controllers.players.MultiAccountController;
   import controllers.planets.PlanetsCommand;
   import controllers.planets.actions.ShowActionParams;
   import controllers.solarsystems.SolarSystemsCommand;
   import controllers.solarsystems.actions.ShowActionParams;
   import controllers.startup.StartupInfo;
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
   import models.player.PlayerOptions;
   import models.quest.MMainQuestLine;
   import models.solarsystem.MSSObject;
   import models.solarsystem.MSolarSystem;
   import models.time.MTimeEventFixedMoment;

   import mx.collections.ArrayCollection;
   import mx.collections.IList;

   import utils.Objects;
   import utils.datastructures.Collections;


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
         EventBroker.subscribe(GlobalEvent.APP_RESET, global_appResetHandler);
      }


      private var _restoreView: Boolean = false;
      private var _restorePlanet: int = 0;
      private var _restoreSS: int = 0;

      private function global_appResetHandler(event: GlobalEvent): void {
         _restorePlanet = ML.latestPlanet != null ? ML.latestPlanet.id : 0;
         _restoreSS = ML.latestSSMap != null ? ML.latestSSMap.id : 0;
         _restoreView = _restorePlanet != 0 || _restoreSS != 0;
      }

      public override function applyServerAction(cmd: CommunicationCommand): void {
         var SI: StartupInfo = StartupInfo.getInstance();
         SI.initializationComplete = true;
         MWaitingScreen.getInstance().visible = false;
         const startup: Boolean = ML.latestGalaxy == null;
         const params: Object = cmd.parameters;
         ML.player.galaxyId = params["galaxyId"];
         if (SI.MACheck != null)
         {
            SI.MACheck.stop();
         }
         SI.MACheck = new MultiAccountController(SI.server + '_galaxy_' + ML.player.galaxyId);
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
         const galaxy:Galaxy = ML.latestGalaxy;

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
            // If player has set openFirstPlanet parameter and has any planet
            // we open first planet
            const deepOpen: Boolean =
                     _restorePlanet
                        || (ML.player.planets.length > 0
                               && PlayerOptions.openFirstPlanetAfterLogin);
            if (deepOpen) {
               NAV_CTRL.toGalaxy(galaxy,
                  function() : void {
                     new GlobalEvent(GlobalEvent.APP_READY);
                     if (_restoreView) {
                        if (_restoreSS != 0) {
                           moveToSS(galaxy, _restoreSS);
                           NAV_CTRL.toSolarSystem(
                              _restoreSS,
                              function (): void {
                                 if (_restorePlanet != 0) {
                                    const p: MSSObject =
                                             ML.latestSSMap.getSSObjectById(_restorePlanet);
                                    if (p != null) {
                                       NAV_CTRL.toPlanet(p);
                                    }
                                 }
                              }
                           );
                        }
                        _restoreView = false;
                     }
                     else {
                        moveToHomeSS(galaxy);
                        NAV_CTRL.toPlanet(MSSObject(ML.player.planets.getItemAt(0)));
                     }
                  }
               );
            }
            else {
               NAV_CTRL.toGalaxy(galaxy,
                  function() : void {
                     new GlobalEvent(GlobalEvent.APP_READY);
                     moveToHomeSS(galaxy);
                  }
               );
            }

            const instance: MMainQuestLine = MMainQuestLine.getInstance();
            if (instance.hasUncompletedMainQuest()
                   && PlayerOptions.showPopupsAfterLogin) {
               instance.openCurrentUncompletedQuest();
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

      private function moveToHomeSS(galaxy: Galaxy): void {
         const ss: MSolarSystem = Collections.findFirst(
            galaxy.solarSystemsWithPlayer,
            function (ss: MSolarSystem): Boolean {
               return ss.player != null && ss.player.equals(ML.player);
            }
         );
         // May be null if player has lost his home solar system during apocalypse
         if (ss != null) {
            moveToSS(galaxy, ss.id);
         }
      }

      private function moveToSS(galaxy: Galaxy, id: int): void {
         const ss: MSolarSystem = galaxy.getSSById(id);
         if (ss != null) {
            galaxy.moveToLocation(ss.currentLocation, true);
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