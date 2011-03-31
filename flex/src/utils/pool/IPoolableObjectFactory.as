package utils.pool
{
   /**
    * An interface defining life-cycle methods for instances to be served by an <code>IObjectPool</code>.
    * 
    * <p>
    * By contract, when an <code>IObjectPool</code> delegates to a <code>IPoolableObjectFactory</code>,
    * <ol>
    *    <li>
    *       <code>makeObject</code> is called whenever a new instance is needed.
    *    </li>
    *    <li>
    *       <code>activateObject</code> is invoked on every instance that has been passivated (with
    *       <code>passivateObject</code>) before it is borrowed (with <code>borrowObject</code>) from the
    *       pool.
    *    </li>
    *    <li>
    *       <code>validateObject</code> is invoked on activated (with <code>activateObject</code>) instances
    *       to make sure they can be borrowed (<code>borrowObject</code>) from the pool.
    *       <code>validateObject</code> <b>may</b> also be used to test an instance being returned (with
    *       <code>returnObject</code>) to the pool before it is passivated (with
    *       <code>passivateObject</code>). It will only be invoked on an activated instance.
    *    </li>
    *    <li>
    *       <code>passivateObject</code> is invoked on every instance when it is returned to the pool.
    *    </li>
    *    <li>
    *       <code>destroyObject</code> is invoked on every instance when it is being "dropped" from the
    *       pool (whether due to the response from <code>validateObject</code>, or for reasons specific to
    *       the pool implementation). There is no guarantee that the instance being destroyed will be
    *       considered active, passive or in a generally consistent state.
    *    </li>
    * </ol>
    * </p>
    *
    * @see IObjectPool
    */
   public interface IPoolableObjectFactory
   {
      /**
       * Creates an instance that can be served by the pool. Instances returned from this method should be in
       * the same state as if they had been activated (with <code>activateObject</code>). They will not be
       * activated before being served by the pool.
       *
       * @return an instance that can be served by the pool.
       * 
       * @throws Error if there is a problem creating a new instance, this will be propagated to the code
       * requesting an object.
       */
      function makeObject() : Object;
      
      
      /**
       * Destroys an instance no longer needed by the pool.
       * 
       * <p>
       * It is important for implementations of this method to be aware that there is no guarantee about what
       * state <code>obj</code> will be in and the implementation should be prepared to handle unexpected
       * errors.
       * </p>
       * 
       * <p>
       * Also, an implementation must take in to consideration that instances lost to the garbage collector
       * may never be destroyed.
       * </p>
       *
       * @param obj the instance to be destroyed
       * 
       * @throws Error should be avoided as it may be swallowed by the pool implementation.
       * 
       * @see #validateObject()
       * @see IObjectPool#invalidateObject()
       */
      function destroyObject(obj:Object) : void;
      
      
      /**
       * Ensures that the instance is safe to be returned by the pool. Returns <code>false</code> if
       * <code>obj</code> should be destroyed.
       *
       * @param obj the instance to be validated
       * 
       * @return <code>false</code> if <code>obj</code> is not valid and should be dropped from the pool,
       *         <code>true</code> otherwise.
       */
      function validateObject(obj:Object) : Boolean;
      
      
      /**
       * Reinitialize an instance to be returned by the pool.
       *
       * @param obj the instance to be activated
       * 
       * @throws Error if there is a problem activating <code>obj</code>, this exception may be swallowed by
       *         the pool.
       * 
       * @see #destroyObject()
       */
      function activateObject(obj:Object) : void;
      
      
      /**
       * Uninitialize an instance to be returned to the idle object pool.
       *
       * @param obj the instance to be passivated
       * 
       * @throws Error if there is a problem passivating <code>obj</code>, this exception may be swallowed by
       *         the pool.
       * 
       * @see #destroyObject()
       */
      function passivateObject(obj:Object) : void;
   }
}