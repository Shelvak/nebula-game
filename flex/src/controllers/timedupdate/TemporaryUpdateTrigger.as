package controllers.timedupdate
{
   import flash.utils.Dictionary;
   
   import interfaces.IUpdatable;
   
   import utils.Objects;
   import utils.SingletonFactory;
   
   
   /**
    * Does not require you to unregister models because weak keys in the underlieing <code>Dictionary</code>.
    * However doing so is recommended because models eligable for garbage collection may still be updated
    * until GC removes them.
    */
   public class TemporaryUpdateTrigger implements IUpdateTriggerTemporary
   {
      public static function getInstance() : IUpdateTriggerTemporary
      {
         return SingletonFactory.getSingletonInstance(TemporaryUpdateTrigger);
      }
      
      
      private var _registered:Dictionary;
      
      
      public function TemporaryUpdateTrigger()
      {
         _registered = new Dictionary(true);
      }
      
      
      public function register(model:IUpdatable) : void
      {
         Objects.paramNotNull("model", model);
         _registered[model] = true;
      }
      
      
      public function unregister(model:IUpdatable) : void
      {
         Objects.paramNotNull("model", model);
         delete _registered[model];
      }
      
      
      public function update() : void
      {
         for (var model:Object in _registered)
         {
            IUpdatable(model).update();
         }
      }
      
      
      public function resetChangeFlags() : void
      {
         for (var model:Object in _registered)
         {
            IUpdatable(model).resetChangeFlags();
         }
      }
   }
}