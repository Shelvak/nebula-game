package ext.hamcrest.component
{
   import ext.hamcrest.object.equals;
   import org.hamcrest.Matcher;
   
   
   /**
    * @copy ext.hamcrest.component.HasChildMatcher
    */
   public function hasChild(value:Object) : Matcher
   {
      if (value is Matcher)
      {
         return new HasChildMatcher(Matcher(value));
      }
      else
      {
         return hasChild(equals(value));
      }
   }
}