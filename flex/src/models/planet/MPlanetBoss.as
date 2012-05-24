package models.planet
{
   import config.Config;

   import controllers.planets.PlanetsCommand;
   import controllers.planets.actions.BgSpawnActionParams;

   import flash.events.EventDispatcher;

   import models.Owner;
   import models.planet.events.MPlanetBossEvent;
   import models.solarsystem.MSSObject;
   import models.solarsystem.events.MSSObjectEvent;
   import models.unit.RaidingUnitEntry;

   import mx.collections.ArrayCollection;
   import mx.collections.IList;

   import utils.Events;
   import utils.Objects;
   import utils.StringUtil;
   import utils.locale.Localizer;


   [Event(name="unitsChange", type="models.solarsystem.events.MSSObjectEvent")]
   [Event(name="canSpawnChange", type="models.solarsystem.events.MSSObjectEvent")]
   [Event(name="canSpawnNowChange", type="models.solarsystem.events.MSSObjectEvent")]
   [Event(name="messageSpawnAbilityChange", type="models.solarsystem.events.MSSObjectEvent")]

   public class MPlanetBoss extends EventDispatcher
   {
      private var _planet: MSSObject;

      public function MPlanetBoss(planet: MSSObject) {
         _planet = Objects.paramNotNull("planet", planet);
         _planet.addEventListener(
            MSSObjectEvent.COOLDOWN_CHANGE, planet_cooldownChangeHandler, false, 0, true);
         _planet.addEventListener(
            MSSObjectEvent.OWNER_CHANGE, planet_ownerChangeHandler, false, 0, true);
         _planet.addEventListener(
            MSSObjectEvent.SPAWN_COUNTER_CHANGE, planet_spawnCounterChangeHandler, false, 0, true);
         _planet.addEventListener(
            MSSObjectEvent.NEXT_SPAWN_CHANGE, planet_nextSpawnChangeHandler, false, 0, true);
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
         const unitEntries: Array = new Array();
         const counterParam: Object = {"counter": _planet.spawnCounter};
         for each (var entryData: Array in configUnits) {
            unitEntries.push(new RaidingUnitEntry(
               entryData[2],
               StringUtil.evalFormula(entryData[0], counterParam),
               StringUtil.evalFormula(entryData[1], counterParam),
               1
            ));
         }
         return unitEntries;
      }

      [Bindable(event="canSpawnChange")]
      public function get canSpawn(): Boolean {
         return (_planet.owner == Owner.PLAYER || _planet.owner == Owner.NPC)
            && _planet.cooldown == null;
      }

      [Bindable(event="canSpawnNowChange")]
      public function get canSpawnNow(): Boolean {
         return canSpawn && _planet.nextSpawn == null;
      }

      [Bindable(event="messageSpawnAbilityChange")]
      public function get message_spawnAbility(): String {
         if (canSpawnNow) {
            return getString("message.canSpawnNow");
         }
         if (!canSpawn) {
            return getString("message.canNotSpawn");
         }
         return getString("message.canSpawnIn", [_planet.nextSpawn.occursInString()]);
      }


      /* ############## */
      /* ### EVENTS ### */
      /* ############## */

      private function planet_spawnCounterChangeHandler(event: MSSObjectEvent): void {
         dispatchThisEvent(MPlanetBossEvent.UNITS_CHANGE);
      }

      private function planet_nextSpawnChangeHandler(event: MSSObjectEvent): void {
         dispatchThisEvent(MPlanetBossEvent.CAN_SPAWN_NOW_CHANGE);
         dispatchThisEvent(MPlanetBossEvent.MESSAGE_SPAWN_ABILITY_CHANGE);
      }

      private function planet_ownerChangeHandler(event: MSSObjectEvent): void {
         dispatchThisEvent(MPlanetBossEvent.CAN_SPAWN_CHANGE);
         planet_nextSpawnChangeHandler(null);
      }

      private function planet_cooldownChangeHandler(event: MSSObjectEvent): void {
         planet_ownerChangeHandler(null);
      }

      private function dispatchThisEvent(type: String): void {
         Events.dispatchSimpleEvent(this, MPlanetBossEvent, type);
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
