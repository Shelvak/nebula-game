package models.planet
{
   import controllers.planets.PlanetsCommand;
   import controllers.planets.actions.ReinitiateCombatAction;
   import controllers.planets.actions.ReinitiateCombatActionParams;

   import flash.events.EventDispatcher;

   import models.cooldown.MCooldown;

   import utils.Objects;


   public class MPlanetCooldown extends EventDispatcher
   {
      private var _cooldown: MCooldown;
      private var _planet: MPlanet;

      public function MPlanetCooldown(cooldown: MCooldown, planet: MPlanet) {
//         _cooldown = Objects.paramNotNull("cooldown", cooldown);
         _planet = Objects.paramNotNull("planet", planet);
      }

      public function get cooldown(): MCooldown {
         return _cooldown;
      }

      public function get canReinitiateCombat(): Boolean {
         return false;
      }

      public function reinitiateCombat(): void {
         new PlanetsCommand(PlanetsCommand.REINITIATE_COMBAT, new ReinitiateCombatActionParams(_planet.id)).dispatch();
      }

      public function get message_reinitiationRestrictions(): String {
         return "";
      }
   }
}
