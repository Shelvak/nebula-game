package ext.hamcrest.object
{
   import org.hamcrest.Matcher;
   import org.hamcrest.core.not;


   public function notEquals(value: Object): Matcher {
      return not (equals (value));
   }
}
