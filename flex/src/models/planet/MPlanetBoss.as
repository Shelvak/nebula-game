package models.planet
{
   import config.Config;

   import controllers.planets.PlanetsCommand;
   import controllers.planets.actions.BgSpawnActionParams;

   import flash.events.EventDispatcher;

   import interfaces.ICleanable;

   import models.Owner;
   import models.events.BaseModelEvent;
   import models.planet.events.MPlanetBossEvent;
   import models.planet.events.MPlanetEvent;
   import models.solarsystem.MSSObject;
   import models.solarsystem.events.MSSObjectEvent;
   import models.unit.RaidingUnitEntry;

   import mx.collections.ArrayCollection;
   import mx.collections.IList;

   import utils.ArrayUtil;
   import utils.EventBridge;
   import utils.Events;
   import utils.Objects;
   import utils.StringUtil;
   import utils.locale.Localizer;


   [Event(name="unitsChange", type="models.solarsystem.events.MSSObjectEvent")]
   [Event(name="canSpawnChange", type="models.solarsystem.events.MSSObjectEvent")]
   [Event(name="canSpawnNowChange", type="models.solarsystem.events.MSSObjectEvent")]
   [Event(name="messageSpawnAbilityChange", type="models.solarsystem.events.MSSObjectEvent")]

   public class MPlanetBoss extends EventDispatcher implements ICleanable
   {
      private const allSpawnChangeEvents: Array = [
         MPlanetBossEvent.CAN_SPAWN_CHANGE,
         MPlanetBossEvent.CAN_SPAWN_NOW_CHANGE,
         MPlanetBossEvent.MESSAGE_SPAWN_ABILITY_CHANGE];

      private var _planetEventBridge: EventBridge;
      private var _planet: MSSObject;

      public function MPlanetBoss(planet: MSSObject) {
         _planet = Objects.paramNotNull("planet", planet);
         _planetEventBridge = new EventBridge(_planet, this)
            .onEvents([MSSObjectEvent.OWNER_CHANGE])
               .dispatchSimple(MPlanetBossEvent, allSpawnChangeEvents)
            .onEvents([MSSObjectEvent.SPAWN_COUNTER_CHANGE])
               .dispatchSimple(MPlanetBossEvent, [MPlanetBossEvent.UNITS_CHANGE])
            .onEvents([MSSObjectEvent.NEXT_SPAWN_CHANGE])
               .dispatchSimple(MPlanetBossEvent, [
                  MPlanetBossEvent.CAN_SPAWN_NOW_CHANGE,
                  MPlanetBossEvent.MESSAGE_SPAWN_ABILITY_CHANGE])
            .onEvents([BaseModelEvent.UPDATE])
               .dispatchSimple(MPlanetBossEvent, [MPlanetBossEvent.MESSAGE_SPAWN_ABILITY_CHANGE]);
      }

      public function cleanup(): void {
         _planetEventBridge.cleanup();
         _planetMap = null;
      }

      private var _planetMapEventBridge: EventBridge;
      private var _planetMap: MPlanet;
      public function set planetMap(value: MPlanet): void {
         if (_planetMap != value) {
            if (_planetMap != null) {
               _planetEventBridge.cleanup();
            }
            _planetMap = value;
            if (_planetMap != null) {
               _planetMapEventBridge = new EventBridge(_planetMap, this)
                  .onEvents([MPlanetEvent.UNIT_REFRESH_NEEDED])
                     .dispatchSimple(MPlanetBossEvent, allSpawnChangeEvents);
            }
            // dispatch events for binding to work
            for each (var event: String in allSpawnChangeEvents) {
               Events.dispatchSimpleEvent(this, MPlanetBossEvent, event);
            }
         }
      }
      public function get planetMap(): MPlanet {
         return _planetMap;
      }

      public function spawn(): void {
         if (canSpawnNow) {
            new PlanetsCommand(
               PlanetsCommand.BG_SPAWN, new BgSpawnActionParams(_planet.id)
            ).dispatch();
         }
      }

      [Bindable(event="unitsChange")]
      public function get units(): IList {
         const configUnits: Array = _planet.inMiniBattleground
            ? Config.getMiniBattlegroundBoss()
            : Config.getBattlegroundBoss();
         return new ArrayCollection(parseBossUnits(configUnits));
      }

      private function parseBossUnits(configUnits: Array): Array {
         const unitEntries: Object = new Object();
         const counterParam: Object = {"counter": _planet.spawnCounter};
         for each (var entryData: Array in configUnits) {
            const type: String = entryData[2];
            const existingEntry: RaidingUnitEntry = unitEntries[type];
            const newEntry: RaidingUnitEntry = new RaidingUnitEntry(
               type,
               StringUtil.evalFormula(entryData[0], counterParam),
               StringUtil.evalFormula(entryData[1], counterParam),
               0.5);
            unitEntries[type] = existingEntry != null ? existingEntry.add(newEntry) : newEntry;
         }
         return ArrayUtil.fromObject(unitEntries, true);
      }

      [Bindable(event="canSpawnChange")]
      public function get canSpawn(): Boolean {
         return (_planet.owner == Owner.PLAYER || _planet.owner == Owner.NPC
            || _planet.owner == Owner.ALLY)
            && (_planetMap == null ||
                   _planetMap.hasAggressiveGroundUnits()
               && !_planetMap.hasActiveUnits([Owner.ENEMY, Owner.NAP]));
      }

      [Bindable(event="canSpawnNowChange")]
      public function get canSpawnNow(): Boolean {
         return canSpawn && _planet.nextSpawn == null;
      }

      [Bindable(event="canSpawnNowChange")]
      public function get spawnCooldownActive(): Boolean {
         return _planet.nextSpawn != null;
      }

      [Bindable(event="messageSpawnAbilityChange")]
      public function get occursInString(): String {
         return _planet.nextSpawn == null
            ? null
            : _planet.nextSpawn.occursInString();
      }

      [Bindable(event="canSpawnNowChange")]
      public function get label_canSpawn(): String {
         return _planet.nextSpawn == null
            ? getString("message.canSpawnNow")
            : getString("message.canSpawnIn");
      }

      [Bindable(event="messageSpawnAbilityChange")]
      public function get toolTip_canSpawnIn(): String {
         return _planet.nextSpawn == null
            ? ''
            : getString("toolTip.canSpawnIn",
               [_planet.nextSpawn.occursInString()]);
      }

      [Bindable(event="messageSpawnAbilityChange")]
      public function get message_spawnAbility(): String {
         if (canSpawn) {
            return "";
         }
         const messages: Array = new Array();
         function addMessage(key: String): void {
            messages.push(getString("message.canNotSpawn." + key));
         }
         if (_planet.owner != Owner.PLAYER
               && _planet.owner != Owner.NPC
               && _planet.owner != Owner.ALLY) {
            addMessage("player");
         }
         if (_planetMap != null) {
            if (!_planetMap.hasAggressiveGroundUnits()) {
               addMessage("noGroundUnits");
            }
            if (_planetMap.hasActiveUnits([Owner.ENEMY, Owner.NAP])) {
               addMessage("napOrEnemyUnits");
            }
         }
         return messages.join("\n");
      }


      /* ##################### */
      /* ### STATIC LABELS ### */
      /* ##################### */

      public function get title_panel(): String {
         return getString("title");
      }

      public function get label_unitsList(): String {
         return getString("label.unitsList");
      }

      public function get label_spawnButton(): String {
         return getString("label.spawnButton");
      }


      private function getString(property: String, parameters: Array = null): String {
         return Localizer.string("PlanetBoss", property, parameters);
      }
   }
}
