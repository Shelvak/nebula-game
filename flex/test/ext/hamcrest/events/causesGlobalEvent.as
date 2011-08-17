package ext.hamcrest.events
{
   /**
    * Matches if a global event is dispatched and optional event <code>Matcher</code> also matches.
    */
   public function causesGlobalEvent(eventType:String, eventMatcher:* = null) : DispatchesGlobalEventsMatcher {
      return causesGlobal(new ExpectedEvent(eventType, eventMatcher));
   }
}