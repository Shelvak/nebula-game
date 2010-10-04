package ext.hamcrest.object
{
   import org.hamcrest.Matcher;
   
   
   /**
    * @copy EqualsMatcher
    */
   public function equals(value:Object) : Matcher
   {
      return new EqualsMatcher(value);
   }
}