package utils.pool.impl
{
   import utils.ClassUtil;
   import utils.pool.IObjectPool;
   import utils.pool.IObjectPoolFactory;
   import utils.pool.IPoolableObjectFactory;
   
   
   /**
    * A factory for creating <code>StackObjectPool</code> instances.
    *
    * @see StackObjectPool
    */
   public class StackObjectPoolFactory implements IObjectPoolFactory
   {
      /**
       * Creates a new <code>StackObjectPoolFactory</code>.
       *
       * @param factory the <code>IPoolableObjectFactory</code> used by created pools. <b>Not null</b>.
       * 
       * @see StackObjectPool#StackObjectPool()
       */
      public function StackObjectPoolFactory(factory:IPoolableObjectFactory)
      {
         ClassUtil.checkIfParamNotNull("factory", factory);
         _factory = factory;
      }
      
      
      private var _factory:IPoolableObjectFactory;
      /**
       * Returns the factory used by created pools.
       * 
       * @return the <code>IPoolableObjectFactory</code> used by created pools.
       */
      public function get factory() : IPoolableObjectFactory
      {
         return _factory;
      }
      
      
      /**
       * Create a <code>StackObjectPool</code>.
       * 
       * @return a new <code>StackObjectPool</code> with the configured factory.
       */
      public function createPool() : IObjectPool
      {
         return new StackObjectPool(_factory);
      }
   }
}