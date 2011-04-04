package utils.pool
{
   /**
    * A factory interface for creating <code>IObjectPool</code>s.
    *
    * @see IObjectPool
    */
   public interface IObjectPoolFactory
   {
      /**
       * Create and return a new <code>IObjectPool</code>.
       * 
       * @return a new <code>IObjectPool</code>
       * 
       * @throws IllegalStateError when this pool factory is not configured properly
       */
      function createPool() : IObjectPool;
   }
}