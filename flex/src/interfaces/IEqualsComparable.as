package interfaces
{
   /**
    * If you wan't to be able to compare istances of your class to other objects using
    * <code>equals()</code> method, implement this interface.
    */
   public interface IEqualsComparable
   {
      /**
       * Compares this istance to the given object.
       * 
       * @param o an object to compare this instance to
       * 
       * @return <code>true</code> if this is equal to the given object or <code>false</code>
       * otherwise 
       */
      function equals(o:Object) : Boolean
   }
}