package utils.pool
{
   import utils.Objects;

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
       * 
       * @param obj instance of <code>IPoolableObject</code> to destroy. <b>Not null</b>.
       */
      public function destroyObject(obj:Object) : void
      {
         Objects.paramNotNull("obj", obj);
         IPoolableObject(obj).destroy();
      }
      
      
      /**
       * Delegates to <code>IPoolableObject.validate()</code>.
       * 
       * @param obj instance of <code>IPoolableObject</code> to be validated. <b>Not null</b>.
       */
      public function validateObject(obj:Object) : Boolean
      {
         Objects.paramNotNull("obj", obj);
         return IPoolableObject(obj).validate();
      }
      
      
      /**
       * Delegates to <code>IPoolableObject.activate()</code>
       * 
       * @param obj instance of <code>IPoolableObject</code> to be activated. <b>Not null</b>.
       */
      public function activateObject(obj:Object) : void
      {
         Objects.paramNotNull("obj", obj);
         IPoolableObject(obj).activate();
      }
      
      
      /**
       * Delegates to <code>IPoolableObject.passivate()</code>
       * 
       * @param obj instance of <code>IPoolableObject</code> to be passivated. <b>Not null</b>.
       */
      public function passivateObject(obj:Object) : void
      {
         Objects.paramNotNull("obj", obj);
         IPoolableObject(obj).passivate();
      }
   }
}