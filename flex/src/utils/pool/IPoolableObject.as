package utils.pool
{
   /**
    * An interface defining life-cycle methods for instances to be created, activated, passivated,
    * validated and passivated by <code>IPoolableObjectFactory</code>. All the methods here should do
    * the same thing as methods of <code>IPoolableObjectFactory</code>.
    * 
    * @see IPoolableObjectFactory
    */
   public interface IPoolableObject
   {
      /**
       * @see IPoolableObjectFactory#destroyObject()
       */
      function destroy() : void;
      
      
      /**
       * @see IPoolableObjectFactory#activateObject()
       */
      function activate() : void;
      
      
      /**
       * @see IPoolableObjectFactory#passivateObject()
       */
      function passivate() : void;
      
      
      /**
       * @see IPoolableObjectFactory#validateObject()
       */
      function validate() : Boolean;
   }
}