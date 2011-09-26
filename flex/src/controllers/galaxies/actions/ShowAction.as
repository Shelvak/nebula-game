package controllers.galaxies.actions
{
   import controllers.CommunicationAction;
   import controllers.CommunicationCommand;
   import controllers.GlobalFlags;
   import controllers.planets.PlanetsCommand;
   import controllers.planets.actions.ShowActionParams;
   import controllers.solarsystems.SolarSystemsCommand;
   import controllers.solarsystems.actions.ShowActionParams;
   import controllers.ui.NavigationController;
   import controllers.units.SquadronsController;
   
   import flash.geom.Rectangle;
   
   import globalevents.GlobalEvent;
   
   import models.BaseModel;
   import models.MWreckage;
   import models.cooldown.MCooldownSpace;
   import models.factories.GalaxyFactory;
   import models.factories.UnitFactory;
   import models.galaxy.Galaxy;
   import models.map.MapType;
   import models.movement.MHop;
   import models.planet.Planet;
   import models.solarsystem.MSSObject;
   import models.solarsystem.SolarSystem;
   
   import mx.collections.ArrayCollection;
   import mx.collections.IList;
   
   
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
    *    <li><code>cooldows</code></li>
    *    <li><code>units</code></li>
    *    <li><code>players</code></li>
    *    <li><code>routeHops</code></li>
    * </ul>
    * </p>
    */
   public class ShowAction extends CommunicationAction
   {
      private function get GF() : GlobalFlags {
         return GlobalFlags.getInstance();
      }
      
      private function get SQUADS_CTRL() : SquadronsController {
         return SquadronsController.getInstance();
      }
      
      private function get NAV_CTRL() : NavigationController {
         return NavigationController.getInstance();
      }
      
      
      public function ShowAction() {
         super();
      }
      
      
      override public function applyClientAction(cmd:CommunicationCommand) : void {
         GF.lockApplication = true;
         super.applyClientAction(cmd);
      }
      
      public override function applyServerAction(cmd:CommunicationCommand) : void {
         var params:Object = cmd.parameters;
         var startup:Boolean = ML.latestGalaxy == null;
         ML.player.galaxyId = params["galaxyId"];
         createGalaxy(
            ML.player.galaxyId,
            params["battlegroundId"],
            GalaxyFactory.createFowEntries(params["fowEntries"]),
            GalaxyFactory.createSolarSystems(params["solarSystems"]),
            BaseModel.createCollection(ArrayCollection, MWreckage, params["wreckages"]),
            BaseModel.createCollection(ArrayCollection, MCooldownSpace, params["cooldowns"]),
            UnitFactory.fromObjects(params["units"], params["players"]),
            IList(BaseModel.createCollection(ArrayCollection, MHop, params["routeHops"])).toArray()
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
                  if (ML.latestSolarSystem != null)
                     NAV_CTRL.toSolarSystem(ML.latestSolarSystem.id);
                  else
                     NAV_CTRL.toGalaxy();
               }
            }
            else if (ML.activeMapType == MapType.SOLAR_SYSTEM) {
               if (ML.latestSolarSystem == null)
                  NAV_CTRL.toGalaxy();
            }
         }
         else {
            var deepOpen:Boolean =
               ML.player.firstTime ||
               ML.player.planetsCountAll == 1 && !galaxy.hasMoreThanOneObject && !galaxy.hasUnits;
            if (deepOpen) {
               NAV_CTRL.toGalaxy(galaxy,
                  function() : void {
                     new GlobalEvent(GlobalEvent.APP_READY);
                     NAV_CTRL.toPlanet(MSSObject(ML.player.planets.getItemAt(0)),
                        function() : void {
                           if (ML.player.firstTime)
                              NAV_CTRL.showWelcomeScreen();
                        }
                     );
                  }
               );
            }
            else {
               NAV_CTRL.toGalaxy(galaxy);
               new GlobalEvent(GlobalEvent.APP_READY);
            }
         }
         
         GF.lockApplication = false;
      }
      
      public function createGalaxy(galaxyId:int,
                                   battlegroundId:int,
                                   fowEntries:Array,
                                   solarSystems:IList,
                                   wreckages:IList,
                                   cooldowns:IList,
                                   units:IList,
                                   hops:Array) : void {
         ML.latestGalaxy = null;
         var galaxy:Galaxy = new Galaxy();
         galaxy.id = galaxyId;
         galaxy.battlegroundId = battlegroundId;
         galaxy.addAllObjects(solarSystems);
         galaxy.addAllObjects(wreckages);
         galaxy.addAllObjects(cooldowns);
         ML.units.disableAutoUpdate();
         ML.units.addAll(units);
         ML.units.enableAutoUpdate();
         galaxy.setFOWEntries(Vector.<Rectangle>(fowEntries), units);
         SQUADS_CTRL.createSquadronsForUnits(units);
         SQUADS_CTRL.addHopsToSquadrons(hops);
         
         var cachedSS:SolarSystem = ML.latestSolarSystem;
         var ssInGalaxy:SolarSystem = cachedSS != null ?
            galaxy.getSSById(cachedSS.id) :
            null;
         var cachedPlanet:Planet = ML.latestPlanet;
         if (cachedPlanet != null &&
             galaxy.getSSById(cachedPlanet.solarSystemId) == null) {
            ML.latestPlanet = null;
         }
         if (ssInGalaxy == null)
            ML.latestSolarSystem = null;
         
         ML.latestGalaxy = galaxy;
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
         if (ML.latestSolarSystem != null) {
            ML.latestSolarSystem.fake = true;
            if (ML.activeMapType == MapType.SOLAR_SYSTEM) {
               new SolarSystemsCommand(
                  SolarSystemsCommand.SHOW,
                  new controllers.solarsystems.actions.ShowActionParams(ML.latestSolarSystem.id, true)
               ).dispatch();
            }
         }
      }
   }
}