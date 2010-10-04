package interfaces
{
   /**
    * Implement this interface to provide a method for generating unique key for each distinct
    * object (not equal to other objects) and probably use that key 
    */
   public interface IHashable
   {
      /**
       * This method <b>must</b> return distinct keys (for use in hash table) for two unequal
       * objects (two instances of <code>IEqualsComparable</code> are considered unequal if
       * <code>equals()</code> method returns <code>false</code>) and vise versa (i. e. same keys
       * for equal objects).
       */
      function hashKey() : String;
   }
}