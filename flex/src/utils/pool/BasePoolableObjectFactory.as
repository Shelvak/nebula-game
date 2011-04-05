package utils.pool
{
   import flash.errors.IllegalOperationError;

   /**
    * A base implementation of <code>IPoolableObjectFactory</code>.
    * 
    * <p>All operations defined here are essentially no-op's. <code>makeObject()</code> is abstract
    * and must be overriden by subclasses.</p>
    *
    * @see IPoolableObjectFactory
    * @see BaseDelegatingPoolableObjectFactory
    */
   public class BasePoolableObjectFactory implements IPoolableObjectFactory
   {
      public function BasePoolableObjectFactory()
      {
      }
      
      
      public function makeObject() : Object
      {
         throw new IllegalOperationError("This method is abstract!");
      }
      
      
      /**
       * No-op.
       * 
       * @param obj ignored
       */
      public function destroyObject(obj:Object) : void
      {
      }
      
      
      /**
       * This implementation always returns <tt>true</tt>.
       * 
       * @param obj ignored
       * 
       * @return <code>true</code>
       */
      public function validateObject(obj:Object) : Boolean
      {
         return true;
      }
      
      
      /**
       * No-op.
       * 
       * @param obj ignored
       */
      public function activateObject(obj:Object) : void
      {
      }
      
      
      /**
       * No-op.
       * 
       * @param obj ignored
       */
      public function passivateObject(obj:Object) : void
      {
      }
   }
}