package controllers.planets.actions
{
   import controllers.CommunicationAction;
   import controllers.CommunicationCommand;
   import controllers.GlobalFlags;
   import controllers.ui.NavigationController;
   import controllers.units.SquadronsController;
   
   import globalevents.GPlanetEvent;
   
   import models.factories.PlanetFactory;
   import models.factories.UnitFactory;
   import models.planet.Planet;
   import models.solarsystem.SolarSystem;
   
   import utils.remote.rmo.ClientRMO;
   
   
   /**
    * Dispached from <code>EventBroker</code> when list of buildings in current
    * planet changes.
    */
   [Event(name="planetBuildingsChange", type="globalevents.GPlanetEvent")]
   
   
   /**
    * Downloads planet form the server, creates a map for it and shows that
    * planet.
    * 
    * <p>
    * Client -->> Server
    * <ul>
    *    <li><code>planet</code> - a planet to show</li>
    * </ul>
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
    */
   public class ShowAction extends CommunicationAction
   {
      private var _squadronsController:SquadronsController = SquadronsController.getInstance();
      
      
      override public function applyClientAction(cmd:CommunicationCommand) : void
      {
         var p:Planet = Planet(cmd.parameters.planet);
         
         // Players can't enter a planet if it is not owned by them
         if (!p.isOwnedByCurrent)
         {
            return;
         }
         
         GlobalFlags.getInstance().lockApplication = true;
         sendMessage(new ClientRMO({"id": p.id}));
      }
      
      
      override public function applyServerAction(cmd:CommunicationCommand) : void
      {
         // these parameters come in separate variable so set them
         cmd.parameters.planet.tiles     = cmd.parameters.tiles;
         cmd.parameters.planet.buildings = cmd.parameters.buildings;
         cmd.parameters.planet.folliages = cmd.parameters.folliages;
         
         var planet:Planet = PlanetFactory.fromObject(cmd.parameters.planet);
         planet.units = UnitFactory.fromStatusHash(cmd.parameters.units);
         planet.initUpgradeProcess();
         
         // If we jumped right to this planet not going through solar system
         // create a fake solar system in model locator with correct id
         if (ML.latestSolarSystem == null || ML.latestSolarSystem.id != planet.solarSystemId)
         {
            if (ML.latestSolarSystem)
            {
               _squadronsController.destroyHostileAndStationarySquadrons(ML.latestSolarSystem);
            }
            var ss:SolarSystem = new SolarSystem();
            ss.fake = true;
            ss.id = planet.solarSystemId;
            ML.latestSolarSystem = ss;
         }
         
         if (ML.latestPlanet)
         {
            _squadronsController.destroyHostileAndStationarySquadrons(ML.latestPlanet);
         }
         _squadronsController.distributeUnitsToSquadrons(planet.units);
         
         NavigationController.getInstance().showPlanet(planet);
         GlobalFlags.getInstance().lockApplication = false;
         
         dispatchPlanetBuildingsChangeEvent();
      }
      
      private function dispatchPlanetBuildingsChangeEvent() : void
      {
         new GPlanetEvent(GPlanetEvent.BUILDINGS_CHANGE, ML.latestPlanet);
      }
   }
}