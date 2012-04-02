package ext.hamcrest.object
{
   import org.hamcrest.Matcher;
   import org.hamcrest.core.allOf;

   import utils.Objects;


   public function definesMethods(matchers: Object): Matcher {
         Objects.paramNotNull("matchers", matchers);
         const definesMethodMatchers: Array = new Array();
         for (var methodName: String in matchers) {
            definesMethodMatchers.push(
               definesMethod(methodName, matchers[methodName])
            );
         }
         return allOf.apply(null, definesMethodMatchers);

   }
}
