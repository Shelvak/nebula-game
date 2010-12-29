package controllers.galaxies.actions
{
   import controllers.CommunicationAction;
   import controllers.CommunicationCommand;
   import controllers.GlobalFlags;
   import controllers.ui.NavigationController;
   import controllers.units.SquadronsController;
   
   import flash.geom.Rectangle;
   
   import interfaces.ICleanable;
   
   import models.MStaticSpaceObjectsAggregator;
   import models.MWreckage;
   import models.ModelsCollection;
   import models.factories.GalaxyFactory;
   import models.factories.UnitFactory;
   import models.galaxy.Galaxy;
   import models.location.LocationMinimal;
   import models.map.MapType;
   import models.solarsystem.SolarSystem;
   
   import mx.collections.ArrayCollection;
   import mx.collections.IList;
   
   import utils.datastructures.Collections;
   
   
   /**
    * Downloads list of solar systems for a galaxy and shows galaxy map.
    * 
    * <p>
    * Client -->> Server
    * <ul>
    *    <li>no parameters</li>
    * </ul>
    * </p>
    * <p>
    * Client <<-- Server
    * <ul>
    *    <li><code>solarSystems</code> - array of generic objects representing solar systems</li>
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
      
      
      override public function applyClientAction(cmd:CommunicationCommand) : void
      {
         GlobalFlags.getInstance().lockApplication = true;
         super.applyClientAction(cmd);
      }
      
      
      public override function applyServerAction(cmd:CommunicationCommand) : void
      {
         var params:Object = cmd.parameters;
         var galaxy:Galaxy = GalaxyFactory.fromObject
            ({"id": ML.player.galaxyId, "solarSystems": params.solarSystems, "wreckages": params.wreckages});
         var fowEntries:Vector.<Rectangle> = GalaxyFactory.createFowEntries(galaxy, params.fowEntries);
         var units:IList = UnitFactory.fromObjects(params.units, params.players);
         
         // Update existing galaxy if this is not the first solar_systems|index message
         if (ML.latestGalaxy)
         {
            ML.latestGalaxy.removeAllStaticObjectsAgregators();
            ML.latestGalaxy.addAllStaticObjectsAggregators(galaxy.objects);
            for each (var squad:ICleanable in ML.latestGalaxy.squadrons)
            {
               squad.cleanup();
            }
            ML.latestGalaxy.squadrons.removeAll();
            ML.latestGalaxy.units.removeAll();
            ML.latestGalaxy.setFOWEntries(fowEntries, units);
         }
         else
         {
            ML.selectedBuilding = null;
            ML.selectedFolliage = null;
            ML.selectedTechnology = null;
         }
         
         galaxy.setFOWEntries(fowEntries, units);
         ML.units.addAll(units);
         SQUADS_CTRL.createSquadronsForUnits(units);
         SQUADS_CTRL.addHopsToSquadrons(params.routeHops);
         if (!ML.latestGalaxy)
         {
            NAV_CTRL.showGalaxy(galaxy);
            GlobalFlags.getInstance().lockApplication = false;
         }
      }
   }
}