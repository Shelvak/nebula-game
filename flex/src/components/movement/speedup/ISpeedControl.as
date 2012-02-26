package components.movement.speedup
{
   import flash.events.IEventDispatcher;

   import interfaces.IUpdatable;

   import models.time.IMTimeEvent;


   public interface ISpeedControl extends IUpdatable, IEventDispatcher
   {
      function set speedModifier(value: Number): void;
      function get speedModifier(): Number;
      function get speedupCost(): int;
      function get arrivalEvent(): IMTimeEvent;
      function reset(): void;
   }
}
