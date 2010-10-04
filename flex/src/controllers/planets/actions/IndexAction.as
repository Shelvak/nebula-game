package controllers.planets.actions
{
	import controllers.CommunicationAction;
	import controllers.CommunicationCommand;
	import controllers.GlobalFlags;
	import controllers.ui.NavigationController;
	import controllers.units.SquadronsController;
	
	import models.factories.SolarSystemFactory;
	import models.factories.UnitFactory;
	import models.solarsystem.SolarSystem;
	
	
	/**
	 * Downloads planets for one solar system and shows solar system map.
    * 
    * <p>
    * Client -->> Server
    * <ul>
    *    <li><code>solarSystemId</code> - id of a solar system</li>
    * </ul>
    * </p>
    * <p>
    * Client <<-- Server
    * <ul>
    *    <li><code>solarSystem</code> - a generic object that represents a solar system</li>
    *    <li><code>planets</code> - array of generic objects representing planets in the solar system</li>
    * </ul>
    * </p>
	 */ 
	public class IndexAction extends CommunicationAction
	{
      private var _squadsController:SquadronsController = SquadronsController.getInstance();
      
      
		/**
       * @private
       */
      override public function applyClientAction(cmd:CommunicationCommand) :void
      {
         GlobalFlags.getInstance().lockApplication = true;
         super.applyClientAction(cmd);
      }
      
      
      /**
       * @private 
       */
      override public function applyServerAction(cmd:CommunicationCommand) : void
      {
         ML.selectedPlanet = null;
         
         // Planets come as separate parameter so put it to the solar system
         cmd.parameters.solarSystem.planets = cmd.parameters.planets;
         
         var ss:SolarSystem = SolarSystemFactory.fromObject(cmd.parameters.solarSystem);
         
         // Invalidate old planet if it is not part of the new solar system
         if (ML.latestSolarSystem && ss.id != ML.latestSolarSystem.id)
         {
            _squadsController.removeHostileAndStationarySquadronsFromList(ML.latestSolarSystem);
            if (ML.latestPlanet)
            {
               _squadsController.removeHostileAndStationarySquadronsFromList(ML.latestPlanet);
               ML.latestPlanet = null;
            }
         }
         _squadsController.distributeUnitsToSquadrons(UnitFactory.fromStatusHash(cmd.parameters.units), ss);
         
         NavigationController.getInstance().showSolarSystem(ss);
         GlobalFlags.getInstance().lockApplication = false;
      }
	}
}