package ext.hamcrest.object
{
   /**
    * <b>DOES NOT WORK!</b> 
    * Returns a builder for matchers that will kick off when the given method on an object being matched is called.
    */
   public function calling(methodName:String, ... args) : CallMatcherBuilder
   {
      if (args.length == 0)
      {
         args = null;
      }
      return new CallMatcherBuilder(methodName, args);
   }
}