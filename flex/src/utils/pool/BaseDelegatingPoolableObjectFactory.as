package utils.pool
{
   /**
    * A base implementation of <code>IPoolableObjectFactory</code> which delegates execution of all
    * operations to the objects themselves. Therefore objects must implement <code>IPoolable</code> interface.
    * However, <code>makeObject()</code> is still abstract and must be overriden by subclasses.
    */
   public class BaseDelegatingPoolableObjectFactory extends BasePoolableObjectFactory
      implements IPoolableObjectFactory
   {
      public function BaseDelegatingPoolableObjectFactory()
      {
      }
      
      
      public function makeObject() : Object
      {
         return super.makeObject();
      }
      
      
      /**
       * Delegates to <code>IPoolableObject.destroy()</code>.
       */
      public function destroyObject(obj:Object) : void
      {
         IPoolableObject(obj).destroy();
      }
      
      
      /**
       * Delegates to <code>IPoolableObject.validate()</code>
       */
      public function validateObject(obj:Object) : Boolean
      {
         return IPoolableObject(obj).validate();
      }
      
      
      /**
       * Delegates to <code>IPoolableObject.activate()</code>
       */
      public function activateObject(obj:Object) : void
      {
         return IPoolableObject(obj).activate();
      }
      
      
      /**
       * Delegates to <code>IPoolableObject.passivate()</code>
       */
      public function passivateObject(obj:Object) : void
      {
         return IPoolableObject(obj).passivate();
      }
   }
}