package ext.hamcrest.object.metadata
{
   import org.hamcrest.Description;
   import org.hamcrest.TypeSafeMatcher;

   import utils.Objects;


   public class WithAttributeMatcher extends TypeSafeMatcher
   {
      private var _expectedAttributeName: String;
      private var _expectedAttributeValue: String;

      public function WithAttributeMatcher(attributeName: String,
                                           attributeValue: String) {
         super(XML);
         _expectedAttributeName =
            Objects.paramNotEmpty("attributeName", attributeName);
         _expectedAttributeValue =
            Objects.paramNotEmpty("attributeValue", attributeValue);
      }


      private var _attributeDefined: Boolean;
      private var _actualAttributeValue: String;

      override public function matchesSafely(item: Object): Boolean {
         _attributeDefined = true;
         _actualAttributeValue = null;
         const tagInfo: XML = item as XML;
         const attributes: XMLList = tagInfo.arg.(@key == _expectedAttributeName);
         if (attributes.length() == 0) {
            _attributeDefined = false;
            return false;
         }
         const attributeInfo: XML = attributes[0];
         _actualAttributeValue = attributeInfo.@value;
         return _actualAttributeValue == _expectedAttributeValue;
      }

      override public function describeMismatch(item: Object,
                                                mismatchDescription: Description): void {
         if (!_attributeDefined) {
            mismatchDescription
               .appendText("attribute ")
               .appendValue(_expectedAttributeName)
               .appendText(" has not been defined");
         }
         else {
            mismatchDescription
               .appendText("value of attribute ")
               .appendValue(_expectedAttributeName)
               .appendText(" was equal to ")
               .appendValue(_actualAttributeValue);
         }
      }

      override public function describeTo(description: Description): void {
         description
            .appendText("attribute ")
            .appendValue(_expectedAttributeName)
            .appendText(" with value ")
            .appendValue(_expectedAttributeValue);
      }
   }
}
