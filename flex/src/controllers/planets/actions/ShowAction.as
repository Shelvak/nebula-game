package controllers.planets.actions
{
   import controllers.CommunicationAction;
   import controllers.CommunicationCommand;
   import controllers.planets.PlanetsCommand;
   import controllers.startup.StartupInfo;
   import controllers.ui.NavigationController;
   import controllers.units.SquadronsController;

   import globalevents.GPlanetEvent;

   import models.factories.PlanetFactory;
   import models.factories.SSObjectFactory;
   import models.factories.UnitFactory;
   import models.map.MMapSolarSystem;
   import models.planet.MPlanet;
   import models.solarsystem.MSolarSystem;
   import models.solarsystem.SSKind;

   import utils.execution.JobExecutorFactory;
   import utils.remote.rmo.ClientRMO;
   import utils.remote.rmo.ServerRMO;


   /**
    * Dispatched from <code>EventBroker</code> when list of buildings in current
    * planet changes.
    */
   [Event(name="planetBuildingsChange", type="globalevents.GPlanetEvent")]
   
   
   /**
    * Downloads planet form the server, creates a map for it and shows that
    * planet.
    * 
    * <p>
    * Client -->> Server: <code>ShowActionParams</code>
    * </p>
    * <p>
    * Client <<-- Server
    * <ul>
    *    <li><code>planet</code> - generic object representing the planet</li>
    *    <li><code>tiles</code> - array of generic objects representing tiles</li>
    *    <li><code>buildings</code> - array of generic objects representing buildings</li>
    *    <li><code>folliages</code> - array of generic objects representing folliages</li>
    *    <li><code>units</code> - array of generic objects representing units</li>
    * </ul>
    * </p>
    * 
    * @see controllers.planets.actions.ShowActionParams
    */
   public class ShowAction extends CommunicationAction
   {
      private function get NAV_CTRL() : NavigationController {
         return NavigationController.getInstance();
      }
      
      private function get SQUADS_CTRL() : SquadronsController {
         return SquadronsController.getInstance();
      }
      
      
      // Should applyServerAction() create only the map or also switch screen?
      private var f_createMapOnly:Boolean = false;
      private function resetFlags() : void {
         f_createMapOnly = false;
      }
      
      
      override public function applyClientAction(cmd:CommunicationCommand) : void {
         if (!StartupInfo.getInstance().initializationComplete) {
            return;
         }
         var params:ShowActionParams = ShowActionParams(cmd.parameters);
         f_createMapOnly = params.createMapOnly;
         sendMessage(new ClientRMO({"id": params.planetId}, null, null, PlanetsCommand.SHOW));
      }
      
      override public function applyServerAction(cmd:CommunicationCommand) : void {
         var params: Object = cmd.parameters;
         var paramsPlanet: Object = params["planet"];
         var planet: MPlanet;
         JobExecutorFactory.frameBasedExecutor(true)
            .addSubJob(
            function (): void {
               ML.latestPlanet = null;
            })
            .addSubJob(
            function (): void {
               ML.units.disableAutoUpdate();
               ML.units.removeGarrisonUnits();
               ML.units.addAll(UnitFactory.fromObjects(params["units"], params["players"]));
               ML.units.enableAutoUpdate();
            })
            .addSubJob(
            function (): void {
               paramsPlanet["cooldownEndsAt"] = params["cooldownEndsAt"];
               planet = PlanetFactory.fromSSObject(
                  SSObjectFactory.fromObject(paramsPlanet),
                  params["tiles"],
                  params["buildings"],
                  params["folliages"]
               );
               planet.initUpgradeProcess();
               var ss: MSolarSystem;

               // special case for wormholes here since wormhole id and planet.solarSystemId never match
               if (planet.inBattleground) {
                  if (ML.latestGalaxy.hasWormholes) {
                     if (ML.latestSSMap == null
                            || !ML.latestSSMap.solarSystem.isWormhole
                                  && !ML.latestSSMap.solarSystem.isGlobalBattleground) {
                        if (ML.latestSSMap != null) {
                           ML.latestSSMap.setFlag_destructionPending();
                        }
                        ss = new MSolarSystem();
                        ss.fake = true;
                        const wormholeInGalaxy: MSolarSystem =
                               MSolarSystem(ML.latestGalaxy.wormholes.getItemAt(0));
                        ss.id = wormholeInGalaxy.id;
                        ss.x = wormholeInGalaxy.x;
                        ss.y = wormholeInGalaxy.y;
                        ss.kind = SSKind.WORMHOLE;
                        ML.latestSSMap = new MMapSolarSystem(ss);
                     }
                  }
                  else {
                     if (ML.latestSSMap != null) {
                        ML.latestSSMap.setFlag_destructionPending();
                        ML.latestSSMap = null;
                     }
                  }
               }
               // If we jumped right to this planet not going through solar system
               // create a fake solar system in model locator with correct id
               else if (ML.latestSSMap == null
                           || ML.latestSSMap.id != planet.solarSystemId) {
                  if (ML.latestSSMap != null) {
                     ML.latestSSMap.setFlag_destructionPending();
                  }
                  ss = new MSolarSystem();
                  ss.fake = true;
                  ss.id = planet.solarSystemId;
                  var ssInGalaxy: MSolarSystem = ML.latestGalaxy.getSSById(ss.id);
                  if (ssInGalaxy == null) {
                     throw new Error(
                        "Can't find solar system with id " + ss.id + " in galaxy."
                     );
                  }
                  ss.x = ssInGalaxy.x;
                  ss.y = ssInGalaxy.y;
                  ss.kind = ssInGalaxy.kind;
                  ML.latestSSMap = new MMapSolarSystem(ss);
               }
            })
            .addSubJob(
            function (): void {
               SQUADS_CTRL.createSquadronsForUnits(planet.units, planet);
               SQUADS_CTRL.attachJumpsAtToHostileSquads(
                  planet.squadrons, params["nonFriendlyJumpsAt"]
               );
               planet.invalidateUnitCachesAndDispatchEvent();
            })
            .addSubJob(
            function (): void {
               if (f_createMapOnly) {
                  NAV_CTRL.recreateMap(planet);
               }
               else {
                  NAV_CTRL.showPlanet(planet);
               }
               dispatchPlanetBuildingsChangeEvent();
               resetFlags();
            })
            .execute();
      }
      
      private function dispatchPlanetBuildingsChangeEvent() : void {
         new GPlanetEvent(GPlanetEvent.BUILDINGS_CHANGE, ML.latestPlanet);
      }

      public override function cancel(rmo:ClientRMO, srmo: ServerRMO) : void {
         resetFlags();
         NAV_CTRL.mapLoadFailed();
         super.cancel(rmo, srmo);
      }
      
      public override function result(rmo:ClientRMO) : void {
         resetFlags();
         super.result(rmo);
      }
   }
}
