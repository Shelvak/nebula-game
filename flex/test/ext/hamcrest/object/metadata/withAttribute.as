package ext.hamcrest.object.metadata
{
   import org.hamcrest.Matcher;


   public function withAttribute(attributeName: String, attributeValue: String): Matcher {
      return new WithAttributeMatcher(attributeName, attributeValue);
   }
}
