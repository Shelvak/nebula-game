package ext.hamcrest.events
{
   import flash.events.IEventDispatcher;
   
   
   /**
    * Matches if given target dispatches an event and optional event <code>Matcher</code> also matches.
    */
   public function causesTarget(target:IEventDispatcher) : DispatchesMatcherBuilder
   {
      return new DispatchesMatcherBuilder().causesTarget(target);
   }
}