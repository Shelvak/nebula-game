package ext.hamcrest.object
{
   import org.hamcrest.Matcher;
   import org.hamcrest.validator.MatcherValidator;
   
   
   /**
    * <b>DOES NOT WORK!</b>
    */
   public class CallMatcherBuilder
   {
      private var _methodName:String;
      private var _arguments:Array;
      
      
      public function CallMatcherBuilder(methodName:String, arguments:Array)
      {
         _methodName = methodName;
         _arguments = arguments;
      }
      
      
      /**
       * The matcher returned will try to match value return by the method called on an item beeing matched against the
       * given value.
       */
      public function returns(value:Object) : Matcher
      {
         return new CallReturnMatcher(_methodName, _arguments, value);
      }
   }
}