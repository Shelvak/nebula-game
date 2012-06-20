package controllers.solarsystems.actions
{
   import controllers.CommunicationAction;
   import controllers.CommunicationCommand;
   import controllers.ui.NavigationController;
   import controllers.units.SquadronsController;

   import models.MWreckage;
   import models.ModelsCollection;
   import models.cooldown.MCooldownSpace;
   import models.factories.SolarSystemFactory;
   import models.factories.UnitFactory;
   import models.location.LocationMinimal;
   import models.location.LocationType;
   import models.map.MMapSolarSystem;
   import models.movement.MHop;
   import models.planet.MPlanet;
   import models.player.PlayerMinimal;
   import models.solarsystem.MSSObject;
   import models.solarsystem.MSolarSystem;
   import models.unit.Unit;

   import mx.collections.ArrayCollection;
   import mx.collections.IList;
   import mx.logging.Log;

   import utils.Objects;
   import utils.execution.IJobExecutor;
   import utils.execution.JobExecutorFactory;
   import utils.remote.rmo.ClientRMO;
   import utils.remote.rmo.ServerRMO;


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
         const params: Object = cmd.parameters;
         const ssCreationJob: IJobExecutor =
                  JobExecutorFactory.frameBasedExecutor(true);

         var ss: MSolarSystem;
         var ssMap: MMapSolarSystem;

         ssCreationJob.addSubJob(function (): void {
            ss = SolarSystemFactory.fromObject(params["solarSystem"]);
            ssMap = new MMapSolarSystem(ss);
            createMapObjects(ssMap, MSSObject, params["ssObjects"]);
            createMapObjects(ssMap, MWreckage, params["wreckages"]);
            createMapObjects(ssMap, MCooldownSpace, params["cooldowns"]);
            const planet: MPlanet = ML.latestPlanet;
            // destroy latest a planet if its not in the given solar system
            if (planet != null && (!planet.inBattleground || !ss.isGlobalBattleground)) {
               if (!(planet.inBattleground
                        && ss.isGlobalBattleground
                        || planet.solarSystemId == ss.id)) {
                  ML.latestPlanet.setFlag_destructionPending();
                  ML.latestPlanet = null;
               }
            }
            // destroy old solar system
            if (ML.latestSSMap != null) {
               ML.latestSSMap.setFlag_destructionPending();
               ML.latestSSMap = null;
            }
         });

         function addUnitsList(units: IList): void {
            ML.units.disableAutoUpdate();
            ML.units.addAll(units);
            ML.units.enableAutoUpdate();
            SQUADS_CTRL.createSquadronsForUnits(units, ssMap);
         }

         function createUnitsJob(unitsBatch: Array): Function {
            return function (): void {
               addUnitsList(UnitFactory.fromObjects(
                  unitsBatch, params["players"]
               ));
            }
         }

         // Moving or non-npc units.
         const units: Array = params["units"];
         const step: int = 200;
         for (var idx: int = 0; idx < units.length; idx += step) {
            ssCreationJob.addSubJob(
               createUnitsJob(units.slice(idx, idx + step))
            );
         }

         function createNpcUnitsJob(npcUnits: Object,
                                    keys: Vector.<String>): Function {
            return function (): void {
               addUnitsList(UnitFactory.ssNpcUnits(npcUnits, keys, ss.id));
            }
         }
         // Non-moving npc units. There can be a lot of them so these need
         // specific handling.
         //
         // See UnitFactory.ssNpcUnits for data definition.
         const npcUnits: Object = params["npcUnits"];
         const npcStep: int = 3;
         var keys: Vector.<String> = new Vector.<String>();
         for (var key: String in npcUnits) {
            keys.push(key);
            if (keys.length == npcStep) {
               ssCreationJob.addSubJob(createNpcUnitsJob(npcUnits, keys));
               keys = new Vector.<String>();
            }
         }
         if (keys.length != 0) {
            ssCreationJob.addSubJob(createNpcUnitsJob(npcUnits, keys));
         }
         
         ssCreationJob.addSubJob(function (): void {
            SQUADS_CTRL.addHopsToSquadrons(
               IList(Objects.fillCollection(
                  new ArrayCollection(), MHop, params["routeHops"]
               )).toArray()
            );
            SQUADS_CTRL.attachJumpsAtToHostileSquads(
               ssMap.squadrons, params["nonFriendlyJumpsAt"]
            );
            if (f_createMapOnly) {
               NAV_CTRL.recreateMap(ssMap);
            }
            else {
               NAV_CTRL.showSolarSystem(ssMap);
            }
            resetFlags();
         });
         ssCreationJob.execute();
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

      private function createMapObjects(ssMap:MMapSolarSystem,
                                        objectClass:Class,
                                        objects:Object): void {
         ssMap.addAllObjects(
            Objects.fillCollection(new ArrayCollection(), objectClass, objects)
         );
      }
   }
}