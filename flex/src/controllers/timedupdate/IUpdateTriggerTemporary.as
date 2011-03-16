package controllers.timedupdate
{
   import models.IMSelfUpdating;
   
   
   /**
    * Does the same as <code>IUpdateTrigger</code>. The difference is that you have to register
    * (an unregister) any instances of <code>IMSelfUpdating</code> with an implementation of this
    * interface explicitly. This trigger variant should be used for triggering updates of temporary
    * models that can't be reached through <code>ModelLocator</code>.
    */
   public interface IUpdateTriggerTemporary extends IUpdateTrigger
   {
      /**
       * Registers given isntace of <code>IMSelfUpdating</code> with this trigger. Repeated calls to
       * this method with the same instance are ignored.
       * 
       * <p>As soon as the instance does not need to be updated, you <b>must</b> unregister it via
       * <code>unregisterModel()</code> call. Failing to do so will cause memory leaks.</p>
       */
      function registerModel(model:IMSelfUpdating) : void;
      
      
      /**
       * Unregisters given instance of <codeIMSelfUpdating</code> from this trigger.
       */
      function unregisterModel(model:IMSelfUpdating) : void;
   }
}