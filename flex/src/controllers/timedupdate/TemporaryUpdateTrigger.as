package controllers.timedupdate
{
   import flash.utils.Dictionary;
   
   import interfaces.IUpdatable;
   
   import utils.Objects;
   import utils.SingletonFactory;
   
   
   /**
    * Does not require you to unregister models because weak keys in the
    * underlying <code>Dictionary</code>. However doing so is recommended
    * because models eligible for garbage collection may still be updated
    * until GC removes them.
    */
   public class TemporaryUpdateTrigger implements IUpdateTriggerTemporary
   {
      public static function getInstance() : IUpdateTriggerTemporary {
         return SingletonFactory.getSingletonInstance(TemporaryUpdateTrigger);
      }

      private const _registered: Dictionary = new Dictionary(true);

      public function register(updatable: IUpdatable): void {
         _registered[Objects.paramNotNull("updatable", updatable)] = true;
      }

      public function unregister(updatable: IUpdatable): void {
         delete _registered[Objects.paramNotNull("updatable", updatable)];
      }

      public function update(): void {
         for (var updatable: Object in _registered) {
            IUpdatable(updatable).update();
         }
      }

      public function resetChangeFlags(): void {
         for (var updatable: Object in _registered) {
            IUpdatable(updatable).resetChangeFlags();
         }
      }
   }
}