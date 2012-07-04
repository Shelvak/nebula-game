package models.planet
{
   import components.popups.ActionConfirmationPopUp;

   import controllers.planets.PlanetsCommand;
   import controllers.planets.actions.ReinitiateCombatAction;
   import controllers.planets.actions.ReinitiateCombatActionParams;

   import flash.events.EventDispatcher;

   import flashx.textLayout.formats.LineBreak;

   import interfaces.ICleanable;

   import models.Owner;

   import models.cooldown.MCooldown;
   import models.planet.events.MPlanetCooldownEvent;
   import models.planet.events.MPlanetEvent;
   import models.solarsystem.MSSObject;
   import models.solarsystem.events.MSSObjectEvent;

   import spark.components.Button;

   import spark.components.Label;

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
         return _planet.hasActiveUnits(Owner.ENEMY_PLAYER) || _planet.hasActiveUnits(Owner.NAP);
      }

      private function get npcUnitPresent(): Boolean {
         return _planet.hasActiveUnits(Owner.NPC);
      }

      private function get playerUnitPresent(): Boolean {
         return _planet.hasActiveUnits(Owner.PLAYER);
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

      public function askForConfirmationAndReinitiateCombat(): void {
         const popup:ActionConfirmationPopUp = new ActionConfirmationPopUp();
         popup.minWidth = 250;
         popup.maxWidth = 300;
         popup.minHeight = 160;
         popup.title = getString("popup.title");
         popup.cancelButtonLabel = getString("popup.label.cancelButton");
         popup.cancelButtonEnabled = true;
         popup.cancelButtonVisible = true;
         popup.closeOnCancel = true;
         popup.confirmButtonLabel = getString("popup.label.confirmButton");
         popup.confirmButtonEnabled = true;
         popup.confirmButtonVisible = true;
         popup.closeOnConfirm = true;
         popup.confirmButtonClickHandler = function (button: Button): void {
            reinitiateCombat();
         }
         const label: Label = new Label();
         label.text = getString("popup.message.confirm");
         label.left = 0;
         label.right = 0;
         label.setStyle("lineBreak", LineBreak.TO_FIT);
         popup.addElement(label);
         popup.show();
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

      // TODO: write test for this
      [Bindable(event=MPlanetCooldownEvent.CAN_REINITIATE_COMBAT_CHANGE)]
      public function get tooltip_reinitiateButton(): String {
         if (canReinitiateCombat) {
            return getString("message.canReinitiate");
         }
         else {
            return getString("message.cannotReinitiate") + "\n" + message_reinitiationRestrictions;
         }
      }

      public function cleanup(): void {
         _ssObjectEventBridge.cleanup();
         _planetEventBridge.cleanup();
      }

      private function getString(property: String): String {
         return Localizer.string("PlanetCooldown", property);
      }
   }
}
