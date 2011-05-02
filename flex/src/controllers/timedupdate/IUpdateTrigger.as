package controllers.timedupdate
{
   /**
    * Controllers implement this interface if they are responsible for triggering update of models
    * <b>accesible from the <code>ModelLocator</code></b> of one or several related types. In addition
    * to that, controllers must check if any of the models updated have expired (if that is relevant
    * for some specific model type) and act accordingly (destroy, disable or whatever).
    * 
    * <p>Implementations of <code>update()</code> and <code>resetChangeFlags()</code> should be
    * aware of the fact that some (or maybe even all) of the models may not be accessible when
    * these methods are invoked. Therefore you should allways check for <code>null</code>s before
    * accessing properties and chains of properties.</p>
    * 
    * <p>All models that can't be accessed through <code>ModelLocator</code> should be registered
    * (and unregistered) explicitly with <code>IUpdateTriggerTemporary</code> implementation.
    * </p>
    */
   public interface IUpdateTrigger
   {
      /**
       * Triggers update of models. Checks if any of the models updated have expired: actions taken
       * by the controller in such situation are implementation specific.
       */
      function update() : void;
      
      
      /**
       * Triggers reset of flags in <code>change_flag</code> namspace of models that were updated
       * as a result of call to <code>update()</code>.
       */
      function resetChangeFlags() : void;
   }
}