package models.planet
{
   import controllers.planets.PlanetsCommand;
   import controllers.planets.actions.ReinitiateCombatAction;
   import controllers.planets.actions.ReinitiateCombatActionParams;

   import flash.events.EventDispatcher;

   import interfaces.ICleanable;

   import models.Owner;

   import models.cooldown.MCooldown;
   import models.planet.events.MPlanetCooldownEvent;
   import models.planet.events.MPlanetEvent;
   import models.solarsystem.MSSObject;
   import models.solarsystem.events.MSSObjectEvent;

   import utils.EventBridge;

   import utils.Objects;
   import utils.locale.Localizer;


   public class MPlanetCooldown extends EventDispatcher implements ICleanable
   {
      private var _cooldown: MCooldown;
      private var _planet: MPlanet;

      private var _planetEventBridge: EventBridge;
      private var _ssObjectEventBridge: EventBridge;

      public function MPlanetCooldown(cooldown: MCooldown, planet: MPlanet) {
         _cooldown = Objects.paramNotNull("cooldown", cooldown);
         _planet = Objects.paramNotNull("planet", planet);

         const eventsToDispatch: Array = [MPlanetCooldownEvent.CAN_REINITIATE_COMBAT_CHANGE];
         _ssObjectEventBridge = new EventBridge(_planet.ssObject, this)
            .onEvents([MSSObjectEvent.OWNER_CHANGE])
            .dispatchSimple(MPlanetCooldownEvent, eventsToDispatch);
         _planetEventBridge = new EventBridge(_planet, this)
            .onEvents([MPlanetEvent.UNIT_REFRESH_NEEDED])
            .dispatchSimple(MPlanetCooldownEvent, eventsToDispatch);
      }

      public function get cooldown(): MCooldown {
         return _cooldown;
      }

      private function get hostileUnitPresent(): Boolean {
         return _planet.hasActiveUnits([Owner.ENEMY, Owner.NAP]);
      }

      private function get npcUnitPresent(): Boolean {
         return _planet.hasActiveUnits([Owner.NPC]);
      }

      private function get playerUnitPresent(): Boolean {
         return _planet.hasActiveUnits([Owner.PLAYER]);
      }

      private function get ownerIsAllyOrNPC(): Boolean {
         const ssObject: MSSObject = _planet.ssObject;
         return ssObject.ownerIsAlly || ssObject.owner == Owner.NPC;
      }

      private function get ownerIsPlayer(): Boolean {
         return _planet.ssObject.ownerIsPlayer;
      }

      [Bindable(event=MPlanetCooldownEvent.CAN_REINITIATE_COMBAT_CHANGE)]
      public function get canReinitiateCombat(): Boolean {
         return (ownerIsPlayer || ownerIsAllyOrNPC && playerUnitPresent)
            && npcUnitPresent && !hostileUnitPresent;
      }

      public function reinitiateCombat(): void {
         if (canReinitiateCombat) {
            new PlanetsCommand(
               PlanetsCommand.REINITIATE_COMBAT,
               new ReinitiateCombatActionParams(_planet.id)).dispatch();
         }
      }

      [Bindable(event=MPlanetCooldownEvent.CAN_REINITIATE_COMBAT_CHANGE)]
      public function get message_reinitiationRestrictions(): String {
         if (canReinitiateCombat) {
            return "";
         }
         const messages: Array = new Array();
         function append(key: String): void {
            messages.push(getString("message." + key));
         }
         if (!npcUnitPresent) append("noNpc");
         if (hostileUnitPresent) append("enemyOrNapUnit");
         if (ownerIsAllyOrNPC && !playerUnitPresent) append("noPlayerUnit");
         if (!ownerIsAllyOrNPC && !ownerIsPlayer) append("enemyOrNapPlanet");
         return messages.join("\n");
      }

      public function cleanup(): void {
         _ssObjectEventBridge.cleanup();
         _planetEventBridge.cleanup();
      }

      public function get label_reinitiateButton(): String {
         return getString("label.reinitiateButton");
      }

      private function getString(property: String): String {
         return Localizer.string("PlanetCooldown", property);
      }
   }
}
