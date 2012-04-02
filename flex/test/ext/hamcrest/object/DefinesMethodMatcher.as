package ext.hamcrest.object
{
   import flash.utils.describeType;

   import org.hamcrest.Description;

   import org.hamcrest.Matcher;
   import org.hamcrest.TypeSafeMatcher;

   import utils.Objects;


   public class DefinesMethodMatcher extends TypeSafeMatcher
   {
      private var _expectedMethodName: String;
      private var _methodInfoMatcher: Matcher;

      public function DefinesMethodMatcher(methodName: String,
                                           methodMatcher: Matcher) {
         super(Class);
         _expectedMethodName = Objects.paramNotEmpty("methodName", methodName);
         _methodInfoMatcher = Objects.paramNotNull("methodMatcher", methodMatcher);
      }

      private var _matchedClass: Class = null;
      private var _methodDefined: Boolean = true;

      override public function matchesSafely(item: Object): Boolean {
         _matchedClass = item as Class;
         const typeInfo: XML = describeType(_matchedClass).factory[0];
         const typeName: String = typeInfo.@type[0];
         const methodInfo: XML = typeInfo.method.
                                    (@name == _expectedMethodName &&
                                     @declaredBy == typeName)[0];
         if (methodInfo == null) {
            _methodDefined = false;
            return false;
         }
         return _methodInfoMatcher.matches(methodInfo);
      }


      override public function describeMismatch(item: Object,
                                                mismatchDescription: Description): void {
         if (!_methodDefined) {
            mismatchDescription
               .appendValue(_matchedClass)
               .appendText(" does not define method ")
               .appendValue(_expectedMethodName);
         }
         else {
            mismatchDescription
               .appendText("method ")
               .appendValue(_expectedMethodName)
               .appendText(" of ")
               .appendValue(_matchedClass)
               .appendText(" ")
               .appendMismatchOf(_methodInfoMatcher, item);
         }
      }

      override public function describeTo(description: Description): void {
         if (_matchedClass != null) {
            description
               .appendValue(_matchedClass)
               .appendText(" ");
         }
         description
            .appendText("to define method ")
            .appendValue(_expectedMethodName)
            .appendText(" with ")
            .appendDescriptionOf(_methodInfoMatcher);
      }
   }
}
