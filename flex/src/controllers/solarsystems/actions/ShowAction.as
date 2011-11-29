package controllers.solarsystems.actions
{
   import controllers.CommunicationAction;
   import controllers.CommunicationCommand;
   import controllers.ui.NavigationController;
   import controllers.units.SquadronsController;

   import models.MWreckage;
   import models.cooldown.MCooldownSpace;
   import models.factories.SolarSystemFactory;
   import models.factories.UnitFactory;
   import models.map.MMapSolarSystem;
   import models.movement.MHop;
   import models.solarsystem.MSSObject;
   import models.solarsystem.MSolarSystem;

   import mx.collections.ArrayCollection;
   import mx.collections.IList;
   import mx.logging.Log;

   import utils.Objects;
   import utils.remote.rmo.ClientRMO;

   /**
    * Downloads objects for one solar system and shows solar system map.
    *
    * <p>
    * Client -->> Server: <code>ShowActionParams</code>
    * </p>
    * <p>
    * Client <<-- Server
    * <ul>
    *    <li><code>solarSystem</code> - a generic object that represents a
    *        solar system</li>
    *    <li><code>ssObjects</code> - array of generic objects representing
    *        objects in the solar system</li>
    * </ul>
    * </p>
    *
    * @see controllers.solarsystems.actions.ShowActionParams
    */
   public class ShowAction extends CommunicationAction
   {
      private function get SQUADS_CTRL() : SquadronsController {
         return SquadronsController.getInstance();
      }

      private function get NAV_CTRL() : NavigationController {
         return NavigationController.getInstance();
      }
      
      public function ShowAction()
      {
         super();
      }

      // Should applyServerAction() create only the map or also switch screen?
      private var f_createMapOnly:Boolean = false;
      private function resetFlags() : void {
         f_createMapOnly = false;
      }


      override public function applyClientAction(cmd:CommunicationCommand) : void {
         var params:ShowActionParams = ShowActionParams(cmd.parameters);
         f_createMapOnly = params.createMapOnly;
         sendMessage(new ClientRMO({"id": params.solarSystemId}));
      }

      override public function applyServerAction(cmd: CommunicationCommand): void {
         function log(message: String): void {
            Log.getLogger("controllers.solarsystems.actions.ShowAction")
               .debug("@applyServerAction(): " + message);
         }

         var params:Object = cmd.parameters;

         log("creating MSolarSystem");
         var ss:MSolarSystem = SolarSystemFactory.fromObject(params["solarSystem"]);
         log("creating MMapSolarSystem");
         var ssMap:MMapSolarSystem = new MMapSolarSystem(ss);
         log("creating MSSObject's for MMapSolarSystem");
         createMapObjects(ssMap, MSSObject, params["ssObjects"]);
         log("creating MWreckage's for MMapSolarSystem");
         createMapObjects(ssMap, MWreckage, params["wreckages"]);
         log("creating MCooldownSpace's for MMapSolarSystem");
         createMapObjects(ssMap, MCooldownSpace, params["cooldowns"]);

         log("check and destroy ML.latestPlanet");
         // destroy latest a planet if its not in the given solar system
         if (ML.latestPlanet != null
                && (!ML.latestPlanet.inBattleground
                       || !ss.isGlobalBattleground)) {
            if (!(ML.latestPlanet.inBattleground && ss.isGlobalBattleground
                     || ML.latestPlanet.solarSystemId == ss.id)) {
               ML.latestPlanet.setFlag_destructionPending();
               ML.latestPlanet = null;
            }
         }
         log("check and destroy ML.latestSSMap");
         // destroy old solar system
         if (ML.latestSSMap != null) {
            ML.latestSSMap.setFlag_destructionPending();
            ML.latestSSMap = null;
         }
         log("creating units, squads, hops");
         var units:ArrayCollection = UnitFactory.fromObjects(params["units"], params["players"]);
         ML.units.disableAutoUpdate();
         ML.units.addAll(units);
         ML.units.enableAutoUpdate();
         SQUADS_CTRL.createSquadronsForUnits(units, ssMap);
         SQUADS_CTRL.addHopsToSquadrons(IList(Objects.fillCollection(new ArrayCollection(), MHop, params["routeHops"])).toArray());
         SQUADS_CTRL.attachJumpsAtToHostileSquads(ssMap.squadrons, params["nonFriendlyJumpsAt"]);
         if (f_createMapOnly) {
            log("just recreating solar system map");
            NAV_CTRL.recreateMap(ssMap);
         }
         else {
            log("showing new solar system map");
            NAV_CTRL.showSolarSystem(ssMap);
         }
         resetFlags();
      }

      public override function cancel(rmo:ClientRMO) : void {
         resetFlags();
         super.cancel(rmo);
      }

      public override function result(rmo:ClientRMO) : void {
         resetFlags();
         super.result(rmo);
      }

      private function createMapObjects(ssMap:MMapSolarSystem,
                                        objectClass:Class,
                                        objects:Object): void {
         ssMap.addAllObjects(
            Objects.fillCollection(new ArrayCollection(), objectClass, objects)
         );
      }
   }
}