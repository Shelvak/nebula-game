package components.movement.speedup
{
   import interfaces.IUpdatable;

   import models.time.IMTimeEvent;


   public interface ISpeedControl extends IUpdatable
   {
      function get arrivalEvent(): IMTimeEvent;
      function reset(): void;
   }
}
