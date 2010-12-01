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
   
   import mx.collections.ArrayCollection;
   
   
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
         var params:Object = cmd.parameters;
         ML.selectedSSObject = null;
         
         // Planets come as separate parameter so put it to the solar system
         params.solarSystem.ssObjects = params.ssObjects;
         
         var ss:SolarSystem = SolarSystemFactory.fromObject(params.solarSystem);
         
         // Invalidate old planet if it is not part of the new solar system
         if (ML.latestSolarSystem && (ss.id != ML.latestSolarSystem.id || ML.latestSolarSystem.fake))
         {
            ML.latestSolarSystem.setFlag_destructionPending();
            ML.latestSolarSystem = null;
            if (ML.latestPlanet && ML.latestPlanet.solarSystemId != ss.id)
            {
               ML.latestPlanet.setFlag_destructionPending();
               ML.latestPlanet = null;
            }
         }
         var units:ArrayCollection = UnitFactory.fromObjects(params.units);
         ML.units.addAll(units);
         SQUADS_CTRL.createSquadronsForUnits(units);
         SQUADS_CTRL.addHopsToSquadrons(params.routeHops);
         NAV_CTRL.showSolarSystem(ss);
         GlobalFlags.getInstance().lockApplication = false;
      }
   }
}