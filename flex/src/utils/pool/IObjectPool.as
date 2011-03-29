package utils.pool
{
   /**
    * A pooling interface.
    * <p>
    * <code>ObjectPool</code> defines a trivially simple pooling interface. The only required methods are
    * <code>borrowObject</code>, <code>returnObject</code> and <code>invalidateObject</code>.
    * </p>
    * <p>
    * Example of use:
    * <pre>
    * var obj:Object = null;
    * try
    * {
    * &nbsp;&nbsp; obj = pool.borrowObject();
    * &nbsp;&nbsp; try
    * &nbsp;&nbsp; {
    * &nbsp;&nbsp;&nbsp;&nbsp; //...use the object...
    * &nbsp;&nbsp; }
    * &nbsp;&nbsp; catch (var e:Error)
    * &nbsp;&nbsp; {
    * &nbsp;&nbsp; &nbsp;&nbsp; // invalidate the object
    * &nbsp;&nbsp; &nbsp;&nbsp; pool.invalidateObject(obj);
    * &nbsp;&nbsp; &nbsp;&nbsp; // do not return the object to the pool twice
    * &nbsp;&nbsp; &nbsp;&nbsp; obj = null;
    * &nbsp;&nbsp; }
    * &nbsp;&nbsp; finally
    * &nbsp;&nbsp; {
    * &nbsp;&nbsp; &nbsp;&nbsp; // make sure the object is returned to the pool
    * &nbsp;&nbsp; &nbsp;&nbsp; if (obj != null)
    * &nbsp;&nbsp; &nbsp;&nbsp; {
    * &nbsp;&nbsp; &nbsp;&nbsp; &nbsp;&nbsp; pool.returnObject(obj);
    * &nbsp;&nbsp; &nbsp;&nbsp; }
    * &nbsp;&nbsp; }
    * }
    * catch(var e:Error)
    * {
    *    // failed to borrow an object
    * }
    * </pre>
    * </p>
    *
    * <p>See <code>BaseObjectPool</code> for a simple base implementation.</p>
    *
    * @see IPoolableObjectFactory
    * @see IObjectPoolFactory
    * @see BaseObjectPool
    */
   public interface IObjectPool
   {
      /**
       * Obtains an instance from this pool.
       * <p>
       * Instances returned from this method will have been either newly created with
       * <code>IPoolableObjectFactory.makeObject</code> or will be a previously idle object and have been
       * activated with <code>PoolableObjectFactory.activateObject</code> and then validated with
       * <code>PoolableObjectFactory.validateObject</code>.
       * </p>
       * <p>
       * By contract, clients <b>must</b> return the borrowed instance using
       * <code>returnObject</code>, <code>invalidateObject</code>, or a related method as defined in an
       * implementation or sub-interface.
       * </p>
       *
       * @return an instance from this pool.
       * @throws IllegalStateError after <code>close</code> has been called on this pool.
       * @throws Error when <code>IPoolableObjectFactory.makeObject</code> throws an error.
       */
      function borrowObject() : Object;
      
      
      /**
       * Return an instance to the pool. By contract, <code>obj</code> <b>must</b> have been obtained
       * using <code>borrowObject</code> or a related method as defined in an implementation or sub-interface.
       *
       * @param obj a <code>borrowObject</code> instance to be returned. <b>Not null</b>.
       */
      function returnObject(obj:Object) : void;
      
      
      /**
       * <p>Invalidates an object from the pool.</p>
       * 
       * <p>By contract, <code>obj</code> <b>must</b> have been obtained using <code>borrowObject</code> or a
       * related method as defined in an implementation or sub-interface.</p>
       *
       * <p>This method should be used when an object that has been borrowed is determined (due to an error or
       * other problem) to be invalid.</p>
       *
       * @param obj borrowed instance to be disposed. <b>Not null</b>.
       */
      function invalidateObject(obj:Object) : void;
      
      
      /**
       * Create an object using the <code>IPoolableObjectFactory</code> or other implementation dependent
       * mechanism, passivate it, and then place it in the idle object pool. <code>addObject</code> is useful
       * for "pre-loading" a pool with idle objects. (Optional operation).
       *
       * @throws Error when <code>IPoolableObjectFactory.makeObject</code> fails.
       * @throws IllegalStateError after <code>close</code> has been called on this pool.
       * @throws IllegalOperationError when this pool cannot add new idle objects.
       */
      function addObject() : void;
      
      
      /**
       * Return the number of instances currently idle in this pool (optional operation). This may be
       * considered an approximation of the number of objects that can be borrowed (with
       * <code>borrowObject</code>) without creating any new instances. Returns a negative value if this
       * information is not available.
       */
      function get numIdle() : int;
      
      
      /**
       * Return the number of instances currently borrowed from this pool (optional operation).
       * Returns a negative value if this information is not available.
       */
      function get numActive() : int;
      
      
      /**
       * Clears any objects sitting idle in the pool, releasing any associated resources (optional operation).
       * Idle objects cleared must be destroyed (with <code>IPoolableObjectFactory.destroyObject()</code>).
       *
       * @throws IllegalOperation if this implementation does not support the operation.
       */
      function clear() : void;
      
      
      /**
       * Close this pool, and free any resources associated with it.
       * 
       * <p>Calling <code>borrowObject</code> after invoking this method on a pool will cause them to throw an
       * <code>IllegalStateError</code>.</p>
       */
      function close() : void;
   }
}