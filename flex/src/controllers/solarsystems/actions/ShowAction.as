package controllers.solarsystems.actions
{
   import controllers.CommunicationAction;
   import controllers.CommunicationCommand;
   import controllers.GlobalFlags;
   import controllers.screens.MainAreaScreens;
   import controllers.ui.NavigationController;
   import controllers.units.SquadronsController;
   
   import models.factories.SolarSystemFactory;
   import models.factories.UnitFactory;
   import models.solarsystem.SolarSystem;
   
   import mx.collections.ArrayCollection;
   
   import utils.remote.rmo.ClientRMO;
   
   
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
      private var GF:GlobalFlags = GlobalFlags.getInstance();
      
      
      public function ShowAction()
      {
         super();
      }
      
      
      override public function applyClientAction(cmd:CommunicationCommand) :void
      {
         GF.lockApplication = true;
         super.applyClientAction(cmd);
      }
      
      
      override public function applyServerAction(cmd:CommunicationCommand) : void
      {
         var params:Object = cmd.parameters;
         
         // objects come as separate parameter so put it to the solar system
         params.solarSystem.ssObjects = params.ssObjects;
         params.solarSystem.wreckages = params.wreckages;
         
         var ss:SolarSystem = SolarSystemFactory.fromObject(params.solarSystem);
         
         // destroy latest a planet if its not in the given solar system
         if (ML.latestPlanet != null && (!ML.latestPlanet.inBattleground || !ss.isBattleground))
         {
            ML.latestPlanet.setFlag_destructionPending();
            ML.latestPlanet == null;
         }
         // destroy old solar system
         if (ML.latestSolarSystem != null)
         {
            ML.latestSolarSystem.setFlag_destructionPending();
            ML.latestSolarSystem = null;
         }
         var units:ArrayCollection = UnitFactory.fromObjects(params.units, params.players);
         ML.units.addAll(units);
         SQUADS_CTRL.createSquadronsForUnits(units);
         SQUADS_CTRL.addHopsToSquadrons(params.routeHops);
         NAV_CTRL.showSolarSystem(ss);
         GF.lockApplication = false;
      }
      
      
      public override function cancel(rmo:ClientRMO):void
      {
         GF.lockApplication = false;
         super.cancel(rmo);
      }
   }
}