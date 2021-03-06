package ext.hamcrest.object
{
   import org.hamcrest.Matcher;
   import org.hamcrest.core.allOf;

   import utils.Objects;


   public function definesProperties(matchers: Object): Matcher {
      Objects.paramNotNull("matchers", matchers);
      const definesPropertyMatchers: Array = new Array();
      for (var propertyName: String in matchers) {
         definesPropertyMatchers.push(
            definesProperty(propertyName, matchers[propertyName])
         );
      }
      return allOf.apply(null, definesPropertyMatchers);
   }
}
