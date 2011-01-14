package interfaces
{
   /**
    * Implement this interface if your class is a potential source of memory leaks: that is if
    * it needs to be destroyed not only by removing reference to an object. In particular classes
    * that register event listeners on other objects (especially global objects) should implement
    * this interface. This way a user of this class will know that once he/she does not need
    * an instance, he <b>must</b> call <code>cleanup()</code> to ensure that isntance can be
    * garbage-collected.
    */
   public interface ICleanable
   {
      /**
       * <b>For class users.</b> You <b>must</b> call this method if you no longer need the
       * instance. Not doing so will cause memory leaks and probably unexpected behaviour. After
       * calling the method you won't (probably) be able to use the instance anymore.
       * <p>
       * <b>For interface implementators.</b> This method is the place where you unregister all event
       * listeners, remove references and release all other resources. It is your responsibility to
       * make the instance available for garbage collection. 
       * </p>
       */
      function cleanup() : void
   }
}