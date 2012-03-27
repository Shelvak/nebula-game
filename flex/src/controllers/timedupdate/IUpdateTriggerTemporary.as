package controllers.timedupdate
{
   import interfaces.IUpdatable;
   
   
   /**
    * Does the same as <code>IUpdateTrigger</code>. The difference is that you
    * have to register (an unregister) any instances of <code>IUpdatable</code>
    * with an implementation of this interface explicitly. This trigger variant
    * should be used for triggering updates of temporary models that can't be
    * reached through <code>ModelLocator</code>.
    */
   public interface IUpdateTriggerTemporary extends IUpdateTrigger
   {
      /**
       * Registers given instance of <code>IUpdatable</code> with this trigger.
       * Repeated calls to this method with the same instance are ignored.
       * 
       * <p>As soon as the instance does not need to be updated, you should
       * unregister it via <code>unregisterUpdatable()</code> call. Failing to
       * do so may cause memory leaks (depends on implementation).</p>
       * 
       * @param updatable <b>Not null.</b>
       */
      function register(updatable: IUpdatable): void;
      
      /**
       * Unregisters given instance of <code>IUpdatable</code> from this trigger.
       * 
       * @param updatable <b>Not null.</b>
       */
      function unregister(updatable: IUpdatable): void;
   }
}