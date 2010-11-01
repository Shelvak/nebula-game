package controllers.solarsystems.actions
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
    * Downloads objects for one solar system and shows solar system map.
    * 
    * <p>
    * Client -->> Server
    * <ul>
    *    <li><code>id</code> - id of a solar system</li>
    * </ul>
    * </p>
    * <p>
    * Client <<-- Server
    * <ul>
    *    <li><code>solarSystem</code> - a generic object that represents a solar system</li>
    *    <li><code>ssObjects</code> - array of generic objects representing objects in the solar system</li>
    * </ul>
    * </p>
    */
   public class ShowAction extends CommunicationAction
   {
      private var SQUADS_CTRL:SquadronsController = SquadronsController.getInstance();
      private var NAV_CTRL:NavigationController = NavigationController.getInstance();
      
      
      public function ShowAction()
      {
         super();
      }
      
      
      override public function applyClientAction(cmd:CommunicationCommand) :void
      {
         GlobalFlags.getInstance().lockApplication = true;
         super.applyClientAction(cmd);
      }
      
      
      override public function applyServerAction(cmd:CommunicationCommand) : void
      {
         ML.selectedPlanet = null;
         
         // Planets come as separate parameter so put it to the solar system
         cmd.parameters.solarSystem.planets = cmd.parameters.ssObjects;
         
         var ss:SolarSystem = SolarSystemFactory.fromObject(cmd.parameters.solarSystem);
         
         // Invalidate old planet if it is not part of the new solar system
         if (ML.latestSolarSystem && ss.id != ML.latestSolarSystem.id)
         {
            SQUADS_CTRL.destroyHostileAndStationarySquadrons(ML.latestSolarSystem);
            if (ML.latestPlanet)
            {
               SQUADS_CTRL.destroyHostileAndStationarySquadrons(ML.latestPlanet);
               ML.latestPlanet = null;
            }
         }
         SQUADS_CTRL.distributeUnitsToSquadrons(UnitFactory.fromStatusHash(cmd.parameters.units));
         NAV_CTRL.showSolarSystem(ss);
         GlobalFlags.getInstance().lockApplication = false;
      }
   }
}