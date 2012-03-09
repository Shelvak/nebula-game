package ext.hamcrest.object
{
   import org.hamcrest.Matcher;


   public function definesProperty(propertyName: String,
                                   propertyMatcher: Matcher): Matcher {
      return new DefinesPropertyMatcher(propertyName, propertyMatcher);
   }
}