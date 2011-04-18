package utils.datastructures
{
   import namespaces.client_internal;

   /**
    * Aggregates a hash function and its name that are used in <code>HashingCollection</code>.
    */
   public class HashFunction
   {
      /**
       * Name of a hash function.
       */
      public var name:String;
      
      
      /**
       * Hash function. It must accept an object as the only one argument and for that argument this
       * function must return a hash key (non null string). Its signature should be:
       * <pre>
       * function hashFunction(object:Object) : String
       * </pre>
       */
      public var func:Function;
      
      
      /**
       * @param name see <code>name</code> property
       * @param func see <code>func</code> property
       * 
       * @see #name
       * @see #func
       */
      public function HashFunction(name:String, func:Function)
      {
         this.name = name;
         this.func = func;
         client_internal::itemsHash = new Object();
      }
      
      
      /**
       * Used only by <code>HashingCollection</code>. Each item in this hash is maped to a key generated
       * using <code>func</code> hash function.
       */
      client_internal var itemsHash:Object;
   }
}