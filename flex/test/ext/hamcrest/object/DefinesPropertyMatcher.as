package ext.hamcrest.object
{
   import flash.utils.describeType;

   import org.hamcrest.Description;
   import org.hamcrest.Matcher;
   import org.hamcrest.TypeSafeMatcher;

   import utils.Objects;


   public class DefinesPropertyMatcher extends TypeSafeMatcher
   {
      private var _expectedPropertyName: String;
      private var _propertyInfoMatcher: Matcher;

      public function DefinesPropertyMatcher(propertyName: String,
                                             propertyInfoMatcher: Matcher) {
         super(Class);
         _expectedPropertyName =
            Objects.paramNotEmpty("propertyName", propertyName);
         _propertyInfoMatcher =
            Objects.paramNotNull("propertyInfoMatcher", propertyInfoMatcher);
      }

      private var _matchedClass: Class;
      private var _propertyDefined: Boolean = true;

      override public function matchesSafely(item: Object): Boolean {
         _matchedClass = item as Class;
         const typeInfo: XML = describeType(_matchedClass).factory[0];
         const typeName: String = typeInfo.@type[0];
         var propInfo: XMLList = new XMLList();
         function findPropertyInfo(propertyType: String): void {
            if (propInfo.length() == 0) {
               // TODO: does not match correctly overridden properties
               if (propertyType == "accessor") {
                  propInfo = typeInfo.child(propertyType).
                                (@name == _expectedPropertyName &&
                                   @declaredBy == typeName);
               }
               else {
                  propInfo = typeInfo.child(propertyType).
                                (@name == _expectedPropertyName);
               }
            }
         }
         findPropertyInfo("accessor");
         findPropertyInfo("variable");
         findPropertyInfo("constant");
         if (propInfo.length() == 0) {
            _propertyDefined = false;
            return false;
         }
         return _propertyInfoMatcher.matches(propInfo[0]);
      }

      override public function describeMismatch(item: Object,
                                                mismatchDescription: Description): void {
         if (!_propertyDefined) {
            mismatchDescription
               .appendValue(_matchedClass)
               .appendText(" does not define property ")
               .appendValue(_expectedPropertyName);
         }
         else {
            mismatchDescription
               .appendText("property ")
               .appendValue(_expectedPropertyName)
               .appendText(" of ")
               .appendValue(_matchedClass)
               .appendText(" ")
               .appendMismatchOf(_propertyInfoMatcher, item);
         }
      }

      override public function describeTo(description: Description): void {
         if (_matchedClass != null) {
            description
               .appendValue(_matchedClass)
               .appendText(" ");
         }
         description
            .appendText("to define property ")
            .appendValue(_expectedPropertyName)
            .appendText(" with ")
            .appendDescriptionOf(_propertyInfoMatcher);
      }
   }
}
