package utils.pool
{
   import com.adobe.errors.IllegalStateError;
   
   import flash.errors.IllegalOperationError;
   
   
   /**
    * A simple base implementation of <code>IObjectPool</code>. Optional operations are implemented to either
    * do nothing, return a value indicating it is unsupported or throw <code>IllegalOperationError</code>.
    */
   public class BaseObjectPool implements IObjectPool
   {
      public function BaseObjectPool()
      {
      }
      
      
      public function borrowObject() : Object
      {
         throw new IllegalOperationError("This method is abstract");
         return null;   // unreachable
      }
      
      
      public function returnObject(obj:Object) : void
      {
         throw new IllegalOperationError("This method is abstract");
      }
      
      
      public function invalidateObject(obj:Object) : void
      {
         throw new IllegalOperationError("This method is abstract");
      }
      
      
      /**
       * Not supported in this base implementation. Always throws an <code>IllegalOperationError</code>,
       * subclasses should override this behavior.
       * 
       * @throws IllegalOperationError
       */
      public function addObject() : void
      {
         throw new IllegalOperationError("Not supported");
      }
      
      
      /**
       * Not supported in this base implementation. Returns negative value.
       */
      public function get numIdle() : int
      {
         return -1;
      }
      
      
      /**
       * Not supported in this base implementation. Returns negative value.
       */
      public function get numActive() : int
      {
         return -1;
      }
      
      
      /**
       * Not supported in this base implementation.
       * 
       * @throws IllegalOperationError
       */
      public function clear() : void
      {
         throw new IllegalOperationError("Not supported");
      }
      
      
      /**
       * Whether or not the pool is closed.
       */
      private var _closed:Boolean = false;
      
      
      /**
       * Close this pool. This affects the behavior of <code>isClosed</code> and <code>assertOpen</code>.
       */
      public function close() : void
      {
         _closed = true;
      }
      
      
      /**
       * Indicates if this pool has been closed.
       */
      protected final function get closed() : Boolean
      {
         return _closed;
      }
      
      
      /**
       * Throws an <code>IllegalStateError</code> when this pool has been closed.
       * 
       * @throws IllegalStateError when this pool has been closed.
       * 
       * @see #closed
       */
      protected final function assertOpen() : void
      {
         if (closed)
         {
            throw new IllegalStateError("Pool is not open");
         }
      }
   }
}