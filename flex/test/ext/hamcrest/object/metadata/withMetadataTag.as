package ext.hamcrest.object.metadata
{
   import org.hamcrest.Matcher;


   public function withMetadataTag(tagName: String,
                                   attributesMatcher: Matcher = null): Matcher {
      return new WithMetadataTagMatcher(tagName, attributesMatcher);
   }
}
