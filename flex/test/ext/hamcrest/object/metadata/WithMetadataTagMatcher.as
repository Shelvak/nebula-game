package ext.hamcrest.object.metadata
{
   import org.hamcrest.Description;
   import org.hamcrest.Matcher;
   import org.hamcrest.TypeSafeMatcher;

   import utils.Objects;


   public class WithMetadataTagMatcher extends TypeSafeMatcher
   {
      private var _expectedTagName: String;
      private var _attributesMatcher: Matcher;

      public function WithMetadataTagMatcher(tagName: String,
                                             attributesMatcher: Matcher = null) {
         super(XML);
         _expectedTagName = Objects.paramNotEmpty("tagName", tagName);
         _attributesMatcher = attributesMatcher;
      }

      private var _tagAttached: Boolean = true;

      override public function matchesSafely(item: Object): Boolean {
         const propInfo: XML = item as XML;
         const metadataTags: XMLList = propInfo.metadata.(@name == _expectedTagName);
         if (metadataTags.length() == 0) {
            _tagAttached = false;
            return false;
         }
         if (_attributesMatcher == null) {
            return true;
         }
         for each (var tagInfo: XML in metadataTags) {
            if (_attributesMatcher.matches(tagInfo)) {
               return true;
            }
         }
         return false;
      }

      override public function describeMismatch(item: Object,
                                                mismatchDescription: Description): void {
         if (!_tagAttached) {
            mismatchDescription
               .appendText("does not have [" + _expectedTagName + "] tag attached");
         }
         else {
            mismatchDescription
               .appendText("does not have [" + _expectedTagName + "] tag attached with ")
               .appendDescriptionOf(_attributesMatcher)
         }
      }

      override public function describeTo(description: Description): void {
         description
            .appendText("[" + _expectedTagName + "] metadata tag attached");
         if (_attributesMatcher != null) {
            description
               .appendText(" with ")
               .appendDescriptionOf(_attributesMatcher)
         }
      }
   }
}
