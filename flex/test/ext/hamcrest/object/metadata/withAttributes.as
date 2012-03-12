package ext.hamcrest.object.metadata
{
   import org.hamcrest.Matcher;
   import org.hamcrest.core.allOf;


   public function withAttributes(matchers: Object): Matcher {
      const attributeMatchers: Array = new Array();
      for (var attributeName:String in matchers) {
         attributeMatchers.push(
            withAttribute(attributeName, matchers[attributeName])
         );
      }
      return allOf.apply(null, attributeMatchers);
   }
}
