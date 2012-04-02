package ext.hamcrest.object
{
   import org.hamcrest.Matcher;


   public function definesMethod(methodName: String, methodMatcher: Matcher) {
      return new DefinesMethodMatcher(methodName, methodMatcher);
   }
}
