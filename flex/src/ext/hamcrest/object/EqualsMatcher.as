package ext.hamcrest.object
{
   import interfaces.IEqualsComparable;
   
   import org.hamcrest.BaseMatcher;
   import org.hamcrest.object.IsEqualMatcher;
   
   
   /**
    * Checks if the item being matched is equal (uses <code>==</code> operator to match item; if
    * it does not match the value, then uses <code>equals()</code> method of
    * <code>IEqualsComparable</code> interface).
    *
    * <ul>
    *    <li>see <code>org.hamcrest.object.IsEqualMatcher</code></li>
    *    <li>item (if instance of <code>IEqualsComparable</code>) matches if <code>equals()</code>
    *        returns <code>true</code></li>
    * </ul>
    *
    * @see org.hamcrest.object.IsEqualMatcher
    * @see extensions.hamcrest.object#equals()
    */
   public class EqualsMatcher extends IsEqualMatcher
   {
      private var _value:Object;
      
      
      /**
       * Constructor.
       *
       * @param value an object the item being matched must be equal to
       */
      public function EqualsMatcher(value:Object)
      {
         super(value);
         _value = value;
      }
      
      
      public override function matches(item:Object):Boolean
      {
         if (super.matches(item))
         {
            return true;
         }
         if (item is IEqualsComparable)
         {
            return IEqualsComparable(item).equals(_value);
         }
         return false;
      }
   }
}