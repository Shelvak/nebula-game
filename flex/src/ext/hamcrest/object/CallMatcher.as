package ext.hamcrest.object
{
   import org.hamcrest.BaseMatcher;
   
   /**
    * <b>DOES NOT WORK!</b>
    */
   public class CallMatcher extends BaseMatcher
   {
      protected var methodName:String;
      protected var arguments:Array;
      
      
      public function CallMatcher(methodName:String, arguments:Array)
      {
         super();
         this.methodName = methodName;
         this.arguments = arguments;
      }
      
      
      protected function invokeMethod(target:Object) : *
      {
         var f:Function = target[methodName];
         return f.apply(target, arguments);
      }
   }
}