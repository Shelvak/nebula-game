package ext.hamcrest.object
{
   import org.hamcrest.Description;
   import org.hamcrest.Matcher;
   
   
   /**
    * <b>DOES NOT WORK!</b>
    */
   public class CallReturnMatcher extends CallMatcher
   {
      private var _returnValueMatcher:Matcher;
      private var _methodError:Error;
      
      
      public function CallReturnMatcher(methodName:String, arguments:Array, returnValue:Object)
      {
         super(methodName, arguments);
         if (returnValue is Matcher)
         {
            _returnValueMatcher = Matcher(returnValue);
         }
         else
         {
            _returnValueMatcher = equals(returnValue);
         }
      }
      
      
      public override function matches(item:Object):Boolean
      {
         try
         {
            return _returnValueMatcher.matches(invokeMethod(item));
         }
         catch (err:Error)
         {
            _methodError = err;
         }
         return false;
      }
      
      
      public override function describeMismatch(item:Object, mismatchDescription:Description) : void
      {
         mismatchDescription.appendText("a call to " + methodName + " method ");
         if (arguments)
         {
            mismatchDescription.appendText("(arguments " + arguments.join(", ") + ")");
         }
         mismatchDescription.appendText(" on ").appendValue(item);
         if (_methodError)
         {
            mismatchDescription
               .appendText(" caused ")
               .appendValue(_methodError);
            _methodError = null;
         }
         else
         {
            mismatchDescription
               .appendText(" did not return ")
               .appendDescriptionOf(_returnValueMatcher);
         }
      }
      
      
      public override function describeTo(description:Description) : void
      {
         description.appendText("a call to " + methodName + " method ");
         if (arguments)
         {
            description.appendText("(arguments " + arguments.join(", ") + ")");
         }
         description.appendText(" returning ").appendDescriptionOf(_returnValueMatcher);
      }
   }
}