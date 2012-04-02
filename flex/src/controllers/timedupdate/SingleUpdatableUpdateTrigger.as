package controllers.timedupdate
{
   import interfaces.IUpdatable;

   import utils.Objects;


   /**
    * A trigger that will only update one IUpdatable.
    */
   public class SingleUpdatableUpdateTrigger implements IUpdateTrigger
   {
      /**
       * @param updatableFunction function that return instance of IUpdatable
       *        to be updated or <code>null</code> if it is not available when
       *        this function is invoked.
       */
      public function SingleUpdatableUpdateTrigger(updatableFunction: Function) {
         _updatableFunction =
            Objects.paramNotNull("updatableFunction", updatableFunction);
      }

      private var _updatableFunction: Function;

      private function get updatable(): IUpdatable {
         return _updatableFunction.call();
      }

      public function update(): void {
         MasterUpdateTrigger.updateItem(updatable);
      }

      public function resetChangeFlags(): void {
         MasterUpdateTrigger.resetChangeFlagsOf(updatable);
      }
   }
}
