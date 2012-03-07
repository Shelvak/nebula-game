package ext.hamcrest.object.metadata
{
   import org.hamcrest.Matcher;
   import org.hamcrest.core.allOf;


   public function withMetadataTags(tags: Object): Matcher {
      const tagMatchers: Array = new Array();
      for (var tagName: String in tags) {
         tagMatchers.push(withMetadataTag(tagName, tags[tagName]));
      }
      return allOf.apply(null, tagMatchers);
   }
}
